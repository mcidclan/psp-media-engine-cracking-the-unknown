## The VME Bitstream/Context and DataPath Documentation

The VME features fine-grained control capabilities, meaning it can first be configured with a coarse-grained bitstream/context for initial or full datapath setup, and then apply targeted updates to specific exposed datapath nodes.

It appears to be more advanced than a simple audio processor. What the analysis of the Processing Elements exposes, through the DSP opcodes observed in use within them and the communication patterns between them, is a stream-oriented vector processing architecture capable of operating directly on internal buffers through inter-buffer operations, fixed-point MAC and branchless conditional transforms. The whole thing suggests a hardware pipeline optimized for real-time vector computation rather than classic scalar execution.

The architecture operates on 24-bit two's complement data, therefore supporting the Q23 format. The internal accumulators are 64 bits wide and allow precise multiply-accumulate operations without immediate overflow. MAC instructions, variable shifts, implicit min/max, logical operations and conditional negations could potentially allow the implementation of fixed-point physics engines, 2D/3D matrix transforms, software rasterizers, complex DSP filters, audio synthesis, interpolation and geometry pipelines.

The inter-buffer operations (front[n], back[n]) indicate a streamed vector processing capability where complete data blocks can be staged and transformed within the pipeline with very little software overhead. The 8 KB internal buffers (Base/Top) suggest a dedicated fast local SRAM that could serve as a vertex cache, scanline buffer, audio sample store, or even a physics data scratch space.

The following is an attempt to explain how the VME pipeline works.


*Note: All of the following observations were made on real PSP Slim hardware.*

### Pipeline

- The VME pipeline is composed of 4 main Process Elements (PEs).
- Nodes associated with the same PE are not necessarily contiguous or sequential, neither in the configuration bitstream/context nor across the datapath controller interface.
- The main flow has a configurable entry point, by default starting from the top PE and going down to the last one. This entry point can be set to any PE, allowing partial use of the pipeline.
- Each PE can at least process over 1 or 2 data sources depending on its configuration.
- As an individual unit, the PE directly maps routes to data sources. For example, 'top' buffers are mapped to the related 'TOP' blocks of the PEs, and 'base' buffers are mapped to the 'BASE' blocks of the PEs.
- By default, PEs run asynchronously and independently from each other. A sequential flow must be explicitly enforced through synchronization.
- As a unit within a sequential flow, a PE inherits the last processed data from the previous stage, referred to as the back buffer, while still retaining its own TOP and BASE buffer mapping.
- A PE can explicitly process data by applying ALU operations on its input, including arithmetic, bitwise logic, shifts and conditional operations. This behavior must be configured through the DESCRIPTOR node.
- Independently of any computation, a PE always has a structural role through its source and destination configuration, covering routing, offsets, word counts, local transformations and synchronization, among other capabilities that are not yet fully understood.


### Process Element

The composition of a Process Element is as follows:

| Register         | Description                                                                                                                                                                                                                        | Format                                |
|:-----------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------|
| TOP_DESCRIPTOR   | Description of the DSP process to apply, <br>starting with the index of the secondary source used <br>to compute against the current buffer data, <br>followed by the operation opcode and the k register value                    | `(indexes << 24 \| opcode << 6 \| k)` |
| TOP_REGISTER_A   | The 'a' register used by the selected operation <br>applied to the 'top' source                                                                                                                                                    | `a`                                   |
| TOP_REGISTER_B   | The 'b' register used by the selected operation <br>applied to the 'top' source                                                                                                                                                    | `b`                                   |
| TOP_SRC          | Routing to the 'top' source targeted by the <br>current Process Element, including the offset (in words) <br>from where to start                                                                                                   | `(routing << 16 \| offset)`           |
| TOP_COUNT        | Number of words - 1 to read from the 'top' source                                                                                                                                                                                  | `(config << 16 \| count)`             |
| TOP_PARAM_0      | Additional local transformations applied on the 'top' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                         | `(config << 16 \| value)`             |
| TOP_PARAM_1      | Additional local transformations applied on the 'top' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                         | `(config << 16 \| value)`             |
| TOP_PARAM_2      | Additional local transformations applied on the 'top' source: <br>offset shift, reserved, unknown, depends on the local config                                                                                                     | `(config << 16 \| value)`             |
| TOP_PARAM_3      | Additional local process applied on the 'top' source: sync, <br>unknown, depends on the local config                                                                                                                               | `(config << 16 \| value)`             |
| BASE_DESCRIPTOR  | Description of the DSP process to apply on the base source, <br>starting with the index of the secondary source used to <br>compute against the current buffer data, <br>followed by the operation opcode and the k register value | `(index << 28 \| opcode << 8 \| k)`   |
| BASE_REGISTER_A  | The 'a' register used by the selected operation <br>applied to the 'base' source                                                                                                                                                   | `a`                                   |
| BASE_REGISTER_B  | The 'b' register used by the selected operation <br>applied to the 'base' source                                                                                                                                                   | `b`                                   |
| BASE_SRC         | Routing to the 'base' source targeted by the current <br>Process Element, including the offset (in words) <br>from where to start                                                                                                  | `(routing << 16 \| offset)`           |
| BASE_COUNT       | Number of words - 1 to read from the 'base' source                                                                                                                                                                                 | `(config << 16 \| count)`             |
| BASE_PARAM_0     | Additional local transformations applied on the 'base' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                        | `(config << 16 \| value)`             |
| BASE_PARAM_1     | Additional local transformations applied on the 'base' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                        | `(config << 16 \| value)`             |
| BASE_PARAM_2     | Additional local transformations applied on the 'base' source: <br>offset shift, reserved, unknown, depends on the local config                                                                                                    | `(config << 16 \| value)`             |
| BASE_PARAM_3     | Additional local process applied on the 'base' source: <br>sync, unknown, depends on the local config                                                                                                                              | `(config << 16 \| value)`             |
| DST              | Routing to the destination targeted by the current <br>Process Element, including the offset (in words) <br>from where to start                                                                                                    | `(routing << 16 \| offset)`           |
| DST_COUNT        | Number of words - 1 to write to the destination                                                                                                                                                                                    | `(config << 16 \| count)`             |
| DST_PARAM_0      | Additional local transformations applied on the destination: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                          | `(config << 16 \| value)`             |
| DST_PARAM_1      | Additional local transformations applied on the destination: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                          | `(config << 16 \| value)`             |
| DST_PARAM_2      | Additional local transformations applied on the destination: <br>offset shift, reserved, unknown, depends on the local config                                                                                                      | `(config << 16 \| value)`             |
| DST_PARAM_3      | Additional local process applied on the destination: <br>sync, unknown, depends on the local config / PE end token                                                                                                                 | `(config << 16 \| value)`             |


### Technical Observations

#### Parameters and Sync
DST_PARAM_3 = 0x00200000 seems to enable a sync mode. Without it DST_PARAM_2 has no effect. DST_PARAM_2 value field (lower 16 bits) is a word offset introducing a padding representing the pipeline drain. Below 0x0a sync seems to not fire correctly, 0x0a and above work. This minimum value suggests a pipeline depth of ~10 stages. Higher values work but waste words.  

#### Internal Accumulator
The real size of the internal accumulator appears to be 64 bits with barrel/cyclic rotation capability, which can be verified by shifting the value 0x01.  

#### Descriptors
For now we have the following observed format for the TOP and BASE descriptors: `FRI << 28 | BRI << 24 | Opcode << 12 | unknown << 6 | k`, where FRI is the front buffer routing index, BRI is the back buffer routing index, and the last 6 bits are the shift amount. The shift can be used to bring data back from the upper 32 bits of the accumulator (for example, after N successive accumulations, the result could grow up to log2(N) bits upward, requiring a corresponding shift to normalize the output), however the shift may also be used as part of the computation itself. In any case, more tests need to be done to clarify the bits.

#### Back and Front Buffers
In the following, what is referred to as the Back buffer is the buffer routed to the current TOP_SOURCE, over which the Front buffer will be processed.

### Operations

#### Generics

| Opcode       | Operation                                                              | Expression                                    |
|:-------------|:-----------------------------------------------------------------------|:----------------------------------------------|
| `0x00004000` | Passthrough                                                            | `x`                                           |
| `0x00014000` | Right shift                                                            | `(x >> k)`                                    |
| `0x00024000` | Add immediate with shift                                               | `(x + b) >> k`                                |
| `0x00034000` | Sub back from front buffer and right shift                             | `(back[n] - front[n]) + a`                    |
| `0x00044000` | Shift accumulate                                                       | `(x >> b) + a`                                |
| `0x00054000` | Shift and subtract                                                     | `(x >> b) - a`                                |
| `0x00064000` | Conditional negation                                                   | `(x & a) != 0 ? x : NEG(x)` *(~x + 1)*        |
| `0x00074000` | Subtract immediate and left shift                                      | `(x - b) << k`                                |
| `0x00084000` | Negative product of back[n] and front[n] if front[n] ∈ [-2, 2], else 0 | `-(back[n] * front[n]) * 1[-2,2]​(front[n])`   |
| `0x00094000` | *Unknown*                                                              |                                               |
| `0x000a4000` | Left shift                                                             | `(x << b)`                                    |
| `0x000b4000` | Left shift (unclear)                                                   | `(x << b)`                                    |
| `0x000c4000` | Bitwise AND                                                            | `(x & b)`                                     |
| `0x000d4000` | Bitwise OR                                                             | `(x \| b)`                                    |
| `0x000e4000` | Exclusive OR                                                           | `(x ^ b)`                                     |
| `0x000f4000` | Non-zero test                                                          | `(x != 0)`                                    |

#### Multiply / MACs / Filters

| Opcode       | Operation                                        | Expression                                    |
|:-------------|:-------------------------------------------------|:----------------------------------------------|
| `0x00200000` | Multiply back and front buffers with shift       | `(back[n] * front[n]) >> k`                   |
| `0x00201000` | Seems to be the same as the previous one (Ssapo) |                                               |
| `0x00202000` | Ssapo                                            |                                               |
| `0x00203000` | Ssapo                                            |                                               |
| `0x00204000` | Multiply by constant with shift                  | `(back[n] * b) >> k`                          |
| `0x00205000` | Ssapo                                            |                                               |
| `0x00206000` | Ssapo                                            |                                               |
| `0x00207000` | Ssapo                                            |                                               |
| `0x00208000` | Multiply-negate with shift                       | `(-(back[n] * front[n])) >> k`                |
| `0x00209000` | Ssapo                                            |                                               |
| `0x0020a000` | Ssapo                                            |                                               |
| `0x0020b000` | Ssapo                                            |                                               |
| `0x0020c000` | Multiply-negate by constant with shift           | `(-(back[n] * b)) >> k`                       |
| `0x0020d000` | Ssapo                                            |                                               |
| `0x0020e000` | Ssapo                                            |                                               |
| `0x0020f000` | Ssapo                                            |                                               |

| Opcode       | Operation                                        | Expression                                                            |
|:-------------|:-------------------------------------------------|:----------------------------------------------------------------------|
| `0x00210000` | Delayed Scalar Multiply-Shift                    | `(x[n] * x[n-1]) >> k` with `x[-1] = b`                               |
| `0x00220000` | Vector Multiply-Shift                            | `(back[n] * front[n]) >> k`                                           |
| `0x00230000` | Negated Vector Multiply-Shift                    | `-((front[n] * back[n]) >> k)`                                        |
| `0x00240000` | Inner Product VMAC with Bias                     | `(Σn(back[n] * front[n]) + b) >> k`                                   |
| `0x00250000` | Temporal MAC with Bias Shift                     | `((y[n-1] + x[n]) + b) >> k`                                          |
| `0x00260000` | Scalar Multiply-Shift with Bias                  | `((a * x[n]) + b) >> k`                                               |
| `0x00270000` | Vector Multiply-Shift with Bias                  | `(back[n] * front[n]) + b) >> k`                                      |
| `0x00280000` | Delayed Feedback IIR Accumulator                 | `0 if n < 2 else ((out[n-1] + front[n-2] + back[n-2]) >> k) + a`      |
| `0x00290000` | 4-Tap Delayed FIR Convolution Filter             | `(Σ{m=0...3}(back[m] * front[n-3-m]) >> k) + a`                       |
| `0x002a0000` | Same as `0x00280000`?                            |                                                                       |
| `0x002b0000` | *unknown*                                        |                                                                       |
| `0x002c0000` | *unknown*                                        |                                                                       |
| `0x002d0000` | *unknown*                                        |                                                                       |
| `0x002e0000` | *unknown*                                        |                                                                       |
| `0x002f0000` | *unknown*                                        |                                                                       |


#### Inter-buffer

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


**WIP**  

#### Runners

| Opcode       | Operation                                                              | Expression                                             |
|:-------------|:-----------------------------------------------------------------------|:-------------------------------------------------------|
| `0x00100000` | Running max                                                            | `out[n] = max(out[n-1], in[n])`                        |
| `0x00110000` | running min extrema filters                                            | `out[n] = min(LASTMIN(out), back[n] - front[n])`       |
| `0x00120000` | Running rate-limited smoothing filter <br>Peak Clamper ?               | `out[n] = min(in[n], max(in[0..n−1])); out[0] = in[0]` |
| `0x00130000` | running max extrema filters                                            | `out[n] = max(LASTMIN(out), back[n] - front[n])`       |

#### 0x00008000 to 0x000f8000

| Opcode       | Operation                                                              | Expression                                               |
|:-------------|:-----------------------------------------------------------------------|:---------------------------------------------------------|
| `0x00008000` | Passthrough                                                            | `back[n]`                                                |
| `0x00018000` | Subtract back buffer from front buffer and right shift                 | `(front[n] - back[n]) >> k`                              |
| `0x00028000` | Same as previous one                                                   |                                                          |
| `0x00038000` | Accumulate front and back buffers                                      | `(front[n] + back[n])`                                   |
| `0x00048000` | Subtract back buffer from front buffer and add constant b              | `(front[n] - back[n]) + b`                               |
| `0x00058000` | Add second 8-bit channel components <br>and scale result               | `(((0xFF00 & front[n]) + (0xFF00 & back[n])) >> 8) << k` |
| `0x00068000` | *unknown*                                                              |                                                          |
| `0x00078000` | Minimum of front and back buffers                                      | `min(back[n], front[n])`                                 |
| `0x00088000` | Constant                                                               | `b`                                                      |
| `0x00098000` | Left shift constant b by back buffer value                             | `(b << back[n])`                                         |
| `0x000a8000` |                                                                        | `back[n] ROR.64 front[n]`                                |
| `0x000b8000` |                                                                        |                                                          |
| `0x000c8000` |                                                                        |                                                          |
| `0x000d8000` |                                                                        |                                                          |
| `0x000e8000` |                                                                        |                                                          |
| `0x000f8000` |                                                                        |                                                          |

#### 0x00140000 to 0x001f0000

| Opcode       | Operation                                                              | Expression                                           |
|:-------------|:-----------------------------------------------------------------------|:-----------------------------------------------------|
| `0x00140000` | *unknown*                                                              |                                                      |
| `0x00150000` | *unknown*                                                              |                                                      |
| `0x00160000` | *unknown*                                                              |                                                      |
| `0x00170000` |                                                                        | (back[n] - a)                                        |
| `0x00180000` | *unknown*                                                              |                                                      |
| `0x00190000` | *unknown*                                                              |                                                      |
| `0x001a0000` | *unknown*                                                              |                                                      |
| `0x001b0000` | Constant                                                               | b                                                    |
| `0x001c0000` | Add back buffer to front buffer                                        | (back[n] + front[n])                                 |
| `0x001d0000` | *unknown*                                                              |                                                      |
| `0x001e0000` |                                                                        | (back[n] - front[n]) + a                             |
| `0x001f0000` |                                                                        | (front[n] - back[n]) + b                             |

#### 0x0000c000 to ?
| Opcode       | Operation                                                              | Expression                                       |
|:-------------|:-----------------------------------------------------------------------|:-------------------------------------------------|
| `0x0000c000` | Constant                                                               | b                                                |

### Libraries

See the following libraries for using the VME and for code examples:  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  
[PSP Media Engine Safe Task](https://github.com/mcidclan/psp-media-engine-safe-task)  

*mcidclan, m-c/d 2026*
