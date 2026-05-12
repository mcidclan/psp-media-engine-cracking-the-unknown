## The VME Bitstream and DataPath Documentation

The VME appears to be far more advanced than a simple audio processor. It has fine-grained capabilities, meaning we can first send it a coarse-grained bitstream for initial or full configuration of its datapath, and then specifically apply changes to precise exposed datapath nodes.

The discovered opcodes reveal a streamed vector processing oriented architecture, capable of operating directly on internal buffers through inter-buffer operations, fixed-point MAC and branchless conditional transforms. The whole thing suggests a hardware pipeline optimized for massive real-time computation rather than classic scalar execution.

The architecture operates on 24-bit two's complement data, therefore supporting the Q23 format. The internal accumulators are at least 48 bits wide and allow precise multiply-accumulate operations without immediate overflow. MAC instructions, variable shifts, implicit min/max, logical operations and conditional negations could potentially allow the implementation of fixed-point physics engines, 2D/3D matrix transforms, software rasterizers, complex DSP filters, audio synthesis, interpolation and geometry pipelines.

The inter-buffer operations (front[n], back[n]) indicate a streamed vector processing capability where complete data blocks can be transformed in a pipeline with very little software overhead. The multiple 8 KB internal buffers (Base/Top) suggest fast local SRAM that can serve as a vertex cache/pipeline, scanlines, audio samples or physics data. This is straight up fire!

The following is an attempt to explain how the VME pipeline works.

### Pipeline

- The VME pipeline is composed of 4 main Process Elements (PEs).
- Nodes associated with the same PE are not necessarily contiguous or sequential, neither in the configuration bitstream nor across the datapath controller interface.
- The main flow has a configurable entry point, by default starting from the top PE and going down to the last one. This entry point can be set to any PE, allowing partial use of the pipeline.
- Each PE can at least process over 1 or 2 data sources depending on its configuration.
- As an individual unit, the PE directly maps routes to data sources. For example, 'top' buffers are mapped to the related 'TOP' blocks of the PEs, and 'base' buffers are mapped to the 'BASE' blocks of the PEs.
- By default, PEs run asynchronously and independently from each other. A sequential flow must be explicitly enforced through synchronization.
- As a unit within a sequential flow, a PE inherits the last processed data from the previous stage, referred to as the back buffer, while still retaining its own TOP and BASE buffer mapping.
- A PE can explicitly process data by applying ALU operations on its input, including arithmetic, bitwise logic, shifts and conditional operations. This behavior must be configured through the DESCRIPTOR node.
- Independently of any computation, a PE always has a structural role through its source and destination configuration, covering routing, offsets, word counts, local transformations and synchronization, among other capabilities that are not yet fully understood.

### Process Element

The composition of a Process Element is as follows, described here for PE 0:

| Register         | Description | Format |
|---|---|---|
| TOP_DESCRIPTOR   | Description of the DSP process to apply, starting with the index of the secondary source used to compute against the current buffer data, followed by the operation opcode and the k register value | `(index << 28 \| opcode << 8 \| k)` |
| TOP_REGISTER_A   | The 'a' register used by the selected operation applied to the 'top' source| `a` |
| TOP_REGISTER_B   | The 'b' register used by the selected operation applied to the 'top' source | `b` |
| TOP_SRC          | Routing to the 'top' source targeted by the current Process Element including the offset (in words) from where to start | `(routing << 16 \| offset)` |
| TOP_COUNT        | Number of words - 1 to read from the 'top' source | `(config << 16 \| count)` |
| TOP_PARAM_0      | Additional local transformations applied on the 'top' source: Shift, Scale, Step, unknown, depends on the local config | `(config << 16 \| value)` |
| TOP_PARAM_1      | Additional local transformations applied on the 'top' source: Shift, Scale, Step, unknown, depends on the local config | `(config << 16 \| value)` |
| TOP_PARAM_2      | Additional local transformations applied on the 'top' source: offset shift, reserved, unknown, depends on the local config | `(config << 16 \| value)` |
| TOP_PARAM_3      | Additional local process applied on the 'top' source: sync, unknown, depends on the local config | `(config << 16 \| value)` |
| BASE_DESCRIPTOR  | Description of the DSP process to apply on the base source, starting with the index of the secondary source used to compute against the current buffer data, followed by the operation opcode and the k register value | `(index << 28 \| opcode << 8 \| k)` |
| BASE_REGISTER_A  | The 'a' register used by the selected operation applied to the 'base' source | `a` |
| BASE_REGISTER_B  | The 'b' register used by the selected operation applied to the 'base' source| `b` |
| BASE_SRC         | Routing to the 'base' source targeted by the current Process Element including the offset (in words) from where to start | `(routing << 16 \| offset)` |
| BASE_COUNT       | Number of words - 1 to read from the 'base' source | `(config << 16 \| count)` |
| BASE_PARAM_0     | Additional local transformations applied on the 'base' source: Shift, Scale, Step, unknown, depends on the local config | `(config << 16 \| value)` |
| BASE_PARAM_1     | Additional local transformations applied on the 'base' source: Shift, Scale, Step, unknown, depends on the local config | `(config << 16 \| value)` |
| BASE_PARAM_2     | Additional local transformations applied on the 'base' source: offset shift, reserved, unknown, depends on the local config | `(config << 16 \| value)` |
| BASE_PARAM_3     | Additional local process applied on the 'base' source: sync, unknown, depends on the local config | `(config << 16 \| value)` |
| DST              | Routing to the destination targeted by the current Process Element including the offset (in words) from where to start | `(routing << 16 \| offset)` |
| DST_COUNT        | Number of words - 1 to write to the destination | `(config << 16 \| count)` |
| DST_PARAM_0      | Additional local transformations applied on the destination: Shift, Scale, Step, unknown, depends on the local config | `(config << 16 \| value)` |
| DST_PARAM_1      | Additional local transformations applied on the destination: Shift, Scale, Step, unknown, depends on the local config | `(config << 16 \| value)` |
| DST_PARAM_2      | Additional local transformations applied on the destination: offset shift, reserved, unknown, depends on the local config | `(config << 16 \| value)` |
| DST_PARAM_3      | Additional local process applied on the destination: sync, unknown, depends on the local config | `(config << 16 \| value)` |

## Operations

### Generics

| Opcode       | Operation                            | Expression                                    |
|:-------------|:-------------------------------------|:----------------------------------------------|
| `0x00004000` | Passthrough                          | `x`                                           |
| `0x00014000` | Right shift                          | `(x >> k)`                                    |
| `0x00024000` | Add immediate                        | `(x + b)`                                     |
| `0x00034000` | Constant                             | `a`                                           |
| `0x00044000` | Shift-accumulate                     | `(x >> b) + a`                                |
| `0x00054000` | Shift and subtract                   | `(x >> b) - a`                                |
| `0x00064000` | Conditional negation                 | `(x & a) != 0 ? x : NEG(x)` *(~x + 1)*        |
| `0x00074000` | Subtract immediate                   | `(x - b)`                                     |
| `0x00084000` | *Unknown*                            |                                               |
| `0x00094000` | *Unknown*                            |                                               |
| `0x000a4000` | Left shift                           | `(x << b)`                                    |
| `0x000b4000` | Left shift (unclear)                 | `(x << b)`                                    |
| `0x000c4000` | Bitwise AND                          | `(x & b)`                                     |
| `0x000d4000` | Bitwise OR                           | `(x \| b)`                                    |
| `0x000e4000` | Exclusive OR                         | `(x ^ b)`                                     |
| `0x000f4000` | Non-zero test                        | `(x != 0)`                                    |
|              |                                      |                                               |

### MACs

| Opcode       | Operation                            | Expression                                    |
|:-------------|:-------------------------------------|:----------------------------------------------|
| `0x00204000` | Multiply-accumulate with shift (MAC) | `(x * b) >> k`                                |


### Inter-buffer

| Opcode       | Operation                                                         | Expression                              |
|:-------------|:------------------------------------------------------------------|:----------------------------------------|
| `0x00010000` | Add back buffer to front buffer and right shift                   | `(back[n] + front[n]) >> k`             |
| `0x00020000` | Same as the previous one?                                         |                                         |
| `0x00030000` | Add back buffer to front buffer and add constant                  | `(back[n] + front[n]) + a`              |
| `0x00040000` | Add back buffer to front buffer right shifted by b                | `back[n] + (front[n] >> b)`             |
| `0x00050000` | Subtract front buffer right shifted by b from back buffer         | `back[n] - (front[n] >> b)`             |
| `0x00060000` | Conditional negation of back buffer based on front buffer mask    | `(front[n] & a) ? -back[n] : back[n]`   |
| `0x00070000` | Shift back buffer left by k and add constant                      | `(back[n] << k) + b`                    |
| `0x00080000` | Clamped multiply of back buffer by front buffer                   | `clamp(back[n], NEG2, POS2) * front[n]` |
| `0x00090000` | *Unknown*                                                         |                                         |
| `0x000a0000` | Shift back buffer left by front buffer value                      | `back[n] << front[n]`                   |
| `0x000b0000` | Same as the previous one?                                         |                                         |
| `0x000c0000` | Minimum of back and front buffer                                  | `min(back[n], front[n])`                |
| `0x000d0000` | Bitwise OR of back and front buffer                               | `back[n] \| front[n]`                   |
| `0x000e0000` | Bitwise XOR of back and front buffer                              | `back[n] ^ front[n]`                    |
| `0x000f0000` | *Unknown*                                                         |                                         |


*mcidclan, m-c/d 2026*
