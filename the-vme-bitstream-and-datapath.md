## The VME Bitstream and DataPath Documentation

The VME has fine-grained capabilities, meaning we can first send it a coarse-grained bitstream for initial or full configuration of its datapath, and then specifically apply changes to precise exposed datapath nodes.

The following is an attempt to explain how the VME pipeline works.

### Pipeline

The VME pipeline is composed of 4 main Process Elements (PEs). However, nodes associated with the same PE are not necessarily contiguous or sequential, neither in the configuration bitstream nor across the datapath controller interface. The main flow starts from the top and goes down to the last PE, although this can be reconfigured.

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
| `0x00204000` | Multiply-accumulate with shift (MAC) | `(x * b) >> k`                                |


### Inter-buffer

| Opcode     | Operation                                                        | Expression                      |
|:-----------|:-----------------------------------------------------------------|:--------------------------------|
| 0x00010000 | Add root buffer to selected buffer and right shift               | `(root[x] + selected[x]) >> k`  |
| 0x00020000 | Same as the previous one?                                        |                                 |
| 0x00030000 | Add root buffer to selected buffer and add constant              | `(root[x] + selected[x]) + a`   |
| 0x00040000 | Add root buffer to selected buffer right shifted by b            | `root[x] + (selected[x] >> b)`  |
| 0x00050000 | Subtract selected buffer right shifted by b from root buffer     | `root[x] - (selected[x] >> b)`  |
| 0x00060000 | Unknown                                                          |                                 |
| 0x00070000 | Unknown                                                          |                                 |
| 0x00080000 | Unknown                                                          |                                 |
| 0x00090000 | Unknown                                                          |                                 |
| 0x000a0000 | Unknown                                                          |                                 |
| 0x000b0000 | Unknown                                                          |                                 |
| 0x000c0000 | Unknown                                                          |                                 |
| 0x000d0000 | Unknown                                                          |                                 |
| 0x000e0000 | Unknown                                                          |                                 |
| 0x000f0000 | Unknown                                                          |                                 |
