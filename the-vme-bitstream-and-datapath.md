## The VME Bitstream and DataPath Documentation

The VME has fine-grained capabilities, meaning we can first send it a coarse-grained bitstream for initial or full configuration of its datapath, and then specifically apply changes to precise exposed datapath nodes.

The following is an attempt to explain how the VME pipeline works.

### Pipeline

The VME pipeline is composed of 4 main Process Elements (PEs). However, nodes associated with the same PE are not necessarily contiguous or sequential, neither in the configuration bitstream nor across the datapath controller interface. The main flow starts from the top and goes down to the last PE, although this can be reconfigured using a specific node.

### Process Element

The composition of a Process Element is as follows, described here for PE 0:

| Register | Description | Format |
|---|---|---|
| TOP_DESCRIPTOR  | Description of the DSP process to apply, starting with the index of the secondary source used to compute against the current buffer data, followed by the operation opcode and the k register value | `(index << 28 \| opcode << 8 \| k)` |
| TOP_REGISTER_A  | a register used by the selected operation                   | a |
| TOP_REGISTER_B  | b register used by the selected operation                   | b |
| TOP_SRC         | Routing to the top source targeted by the current Process Element including the offset (in word) from where to start | |
| TOP_COUNT       | Number of word - 1 to read from the source                  | |
| TOP_PARAM_0     | Additionnal local tranformations, Shift Scale, Step, unknown, depends on the local config | |
| TOP_PARAM_1     | Additionnal local tranformations, Shift Scale, Step, unknown, depends on the local config | |
| TOP_PARAM_2     | Additionnal local tranformations, offset shift, reserve, unknown, depends on the local config | |
| TOP_PARAM_3     | | |
| BASE_DESCRIPTOR | | |
| BASE_REGISTER_A | | |
| BASE_REGISTER_B | | |
| BASE_SRC        | | |
| BASE_COUNT      | | |
| BASE_PARAM_0    | | |
| BASE_PARAM_1    | | |
| BASE_PARAM_2    | | |
| BASE_PARAM_3    | | |
| DST             | | |
| DST_COUNT       | | |
| DST_PARAM_0     | | |
| DST_PARAM_1     | | |
| DST_PARAM_2     | | |
| DST_PARAM_3     | | |


0x00010000 | add root buffer to selected buffer and right shift | (root[x] + selected[x]) >> k |
0x00020000 | same as the previous one ? | |
0x00030000 | add root buffer to selected buffer and add constant | (root[x] + selected[x]) + a |
0x00040000 |  | root[x] + (selected[x] >> b) |
0x00050000 |  | root[x] - (selected[x] >> b) |
0x00060000 |  | Unknown |

