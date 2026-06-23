## The Virtual Mobile Engine 2 (PSP VME)

This is a temporary documentation on the VME, aiming to record observations as well as the behavior of the VME during the hardware testing phase of the CGRA, with tests being conducted on a PSP Slim. This documentation will serve as a basis for a future, more comprehensive documentation.


### Bitstream/Context Memory and DataPath

The VME features fine-grained control capabilities, it can first be configured with a coarse-grained bitstream/context for initial or full datapath setup, and then apply targeted updates to specific exposed datapath nodes.

It appears to be more advanced than a simple audio processor. The analysis of the Processing Elements, through the DSP opcodes used within them and the communication patterns between them, reveals a stream-oriented vector processing architecture capable of operating directly on internal buffers through inter-buffer operations, fixed-point MAC and branchless conditional transforms. All of this suggests a hardware pipeline optimized for real-time vector computation rather than classic scalar execution.

The architecture operates on 24-bit two's complement data, therefore supporting the Q23 format. The internal accumulators are 64 bits wide and allow precise multiply-accumulate operations without immediate overflow. MAC instructions, variable shifts, implicit min/max, logical operations and conditional negations could potentially allow the implementation of fixed-point physics engines, 2D/3D matrix transforms, software rasterizers, complex DSP filters, audio synthesis, interpolation and geometry pipelines.

The inter-buffer operations (front[n], back[n]) indicate a streamed vector processing capability where complete data blocks can be staged and transformed within the pipeline with very little software overhead. The local SRAM hosting the 8 KB internal buffers could serve as a vertex cache, scanline buffer, audio sample store, or even a physics scratchpad.

The following is an attempt to explain how the VME pipeline works.  

*Note: All of the following are based on personal observations and empirical findings made on PSP Slim hardware running Pro-C.*

### Pipeline

- The VME pipeline is composed of 4 main Process Elements (PEs).
- Nodes associated with the same PE are not necessarily contiguous or sequential, neither in the configuration bitstream/context nor across the datapath controller interface.
- The main flow has a configurable entry point, by default starting from the top PE and going down to the last one. This entry point can be set to any PE, allowing partial use of the pipeline.
- Each PE can at least process over 1 or 2 data sources depending on its configuration.
- As an individual unit, the PE directly maps routes to data sources. For example, 'top' buffers are mapped to the related 'TOP' blocks of the PEs, and 'base' buffers are mapped to the 'BASE' blocks of the PEs.
- By default, PEs run asynchronously and independently from each other. A sequential flow must be explicitly enforced through synchronization.
- As a unit within a sequential flow, a PE inherits the last processed data from the previous stage, referred to as the back buffer, while still retaining its own TOP and BASE buffer mapping.
- A PE can explicitly process data by applying operations on its input, including arithmetic, bitwise logic, shifts and conditional operations. This behavior must be configured through the DESCRIPTOR node.
- Independently of any computation, a PE always has a structural role through its source and destination configuration, covering routing, offsets, word counts, local transformations and synchronization, among other capabilities that are not yet fully understood.


### Process Element

The composition of a Process Element is as follows:

| Register                  | Description                                                                                                                                                                                                                            | Format                      |
|:--------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------|
| FUNCTIONAL_UNIT_PRIMARY   | Configuration of the Top Functional Unit (FU). <br>`Mux F Sel` and `Mux B Sel` select the front and back buffer <br>inputs of the internal two-input MUX feeding the ALU/MAC, <br>which applies `Opcode` on the multiplexed data. <br>The result passes through the saturator (`Sat`) <br>and the shifter (`k`). | `bit[31:28] Mux F Sel` <br> `bit[27:24] Mux B Sel` <br> `bit[23:12] Opcode` <br> `bit[11:8]  Sat` <br> `bit[7:6]   unknown` <br> `bit[5:0]   k` |
| FU_PRIMARY_REGISTER_A     | The 'a' register used by the selected operation <br>applied to the 'top' source                                                                                                                                                        | `top a`                     |
| FU_PRIMARY_REGISTER_B     | The 'b' register used by the selected operation <br>applied to the 'top' source                                                                                                                                                        | `top b`                     |
| TOP_MODE                  | Routing to the 'top' source targeted by the <br>current Process Element, including the offset (in words) <br>from where to start                                                                                                       | `(routing << 16 \| offset)` |
| TOP_COUNT                 | Step, Number of words - Step to read from the 'top' source                                                                                                                                                                             | `(step << 16 \| count)`     |
| TOP_INNER_0               | Local AGU transformations applied on the 'top' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                                    | `(config << 16 \| value)`   |
| TOP_INNER_1               | Local AGU transformations applied on the 'top' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                                    | `(config << 16 \| value)`   |
| TOP_FORMAT_0              | Local AGU transformations applied on the 'top' source: <br>offset shift, reverse, unknown, depends on the local config                                                                                                                 | `(config << 16 \| value)`   |
| TOP_FORMAT_1              | Local AGU process applied on the 'top' source: sync, <br>unknown, depends on the local config                                                                                                                                          | `(config << 16 \| value)`   |
| FUNCTIONAL_UNIT_SECONDARY | Configuration of the Base Functional Unit (FU). <br>`Mux F Sel` and `Mux B Sel` select the front and back buffer <br>inputs of the internal two-input MUX feeding the ALU/MAC, <br>which applies `Opcode` on the multiplexed data. <br>The result passes through the saturator (`Sat`) <br>and the shifter (`k`). | `bit[31:28] Mux F Sel` <br> `bit[27:24] Mux B Sel` <br> `bit[23:12] Opcode` <br> `bit[11:8]  Sat` <br> `bit[7:6]   unknown` <br> `bit[5:0]   k` |
| FU_SECONDARY_REGISTER_A   | The 'a' register used by the selected operation <br>applied to the 'base' source                                                                                                                                                       | `base a`                    |
| FU_SECONDARY_REGISTER_B   | The 'b' register used by the selected operation <br>applied to the 'base' source                                                                                                                                                       | `base b`                    |
| BASE_MODE                 | Routing to the 'base' source targeted by the current <br>Process Element, including the offset (in words) <br>from where to start                                                                                                      | `(routing << 16 \| offset)` |
| BASE_COUNT                | Step, Number of words - Step to read from the 'base' source                                                                                                                                                                            | `(step << 16 \| count)`     |
| BASE_INNER_0              | Local AGU transformations applied on the 'base' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                                   | `(config << 16 \| value)`   |
| BASE_INNER_1              | Local AGU transformations applied on the 'base' source: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                                   | `(config << 16 \| value)`   |
| BASE_FORMAT_0             | Local AGU transformations applied on the 'base' source: <br>offset shift, reverse, unknown, depends on the local config                                                                                                                | `(config << 16 \| value)`   |
| BASE_FORMAT_1             | Local AGU process applied on the 'base' source: <br>sync, unknown, depends on the local config                                                                                                                                         | `(config << 16 \| value)`   |
| WRITE                     | Routing to the destination targeted by the current <br>Process Element, including the offset (in words) <br>from where to start                                                                                                        | `(routing << 16 \| offset)` |
| WRITE_COUNT               | Step, Number of words - Step to write to the destination                                                                                                                                                                               | `(step << 16 \| count)`     |
| WRITE_INNER_0             | Local AGU transformations applied on the destination: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                                     | `(config << 16 \| value)`   |
| WRITE_INNER_1             | Local AGU transformations applied on the destination: <br>Shift, Scale, Step, unknown, depends on the local config                                                                                                                     | `(config << 16 \| value)`   |
| WRITE_FORMAT_0            | Local AGU transformations applied on the destination: <br>offset shift, reverse, unknown, depends on the local config                                                                                                                  | `(config << 16 \| value)`   |
| WRITE_FORMAT_1            | Local AGU process applied on the destination: <br>sync, unknown, depends on the local config / PE end token                                                                                                                            | `(config << 16 \| value)`   |


### Technical Observations

The following may be inaccurate, more testing is needed to confirm, clarify, or invalidate it.  

#### AGU Parameters, Sync, Reverse, FFT butterflies
+ `INNER_0` higher 16 bits with Prefix `0x8c00` insert a step between each word.
+ `INNER_0` lower 16 bits appear to encode a count minus one, specifying how many words are read from the source before advancing to the next input stream segment. `PARAM_2` bit[17] needs to be set.
+ `INNER_1` higher 16 bits with Prefix `0x8c00` or `0x8500` insert a step between each word.
+ `INNER_1` and `PARAM_0` using Prefix `0x8c00`can be cumulated.
+ `FORMAT_0` value field (lower 16 bits) is a word offset introducing a Word-Shift that could be used as a pipeline drain. Below 0x0a sync seems to not fire correctly, 0x0a and above work. This minimum value suggests a pipeline depth of ~10 stages. Higher values work but waste words.  
+ `FORMAT_0` with bit[21,16] enabled, it can be used to Replicate the first value of the current buffer across the entire buffer range count. This is useful for filling or clearing the buffer with a single value.
+ `FORMAT_0` with bit[28] enabled, it can be used to Reverse the word order across the entire buffer range count.
+ `FORMAT_1` with bit[21] enabled, it seems to enable a Sync mode. Without it DST_PARAM_2 Word-Shift has no effect.
+ `FORMAT_1` with bit[29] and using Prefix `0x8400` the last nibble seems to activate FFT-related stage/butterfly transformations (bit-reversal for example).

Note on FFT bit-reversal stage:  
`out[n] = in[ bitrev(n, [0...p-1]) ]` bitrev(n) on [0 ... p-1] bits where p is the last nibble  

#### Internal Accumulator
The real size of the internal accumulator appears to be 64 bits with barrel/cyclic rotation capability, which can be verified by shifting the value 0x01.  

#### Descriptors
For now we have the following observed format for the TOP and BASE descriptors: `MUX(F Sel << 28 | B Sel << 24 | S Sel << 22) | Opcode << 12 | Sat << 8 | unknown << 6 | k`, where F Sel is the front buffer Selector, B Sel is the back buffer Selector, and the last 6 bits are the shift amount. The shift can be used to bring data back from the upper 32 bits of the accumulator (for example, after N successive accumulations, the result could grow up to log2(N) bits upward, requiring a corresponding shift to normalize the output), however the shift may also be used as part of the computation itself. In any case, more tests need to be done to clarify the bits.

Bit field breakdown:

| Bits      | Field                 | Notes                                                 |
|:----------|:----------------------|:------------------------------------------------------|
| `[31:28]` | Front Selector        | Selects the Front buffer source                       |
| `[27:24]` | Back Selector         | Selects the Back buffer source                        |
| `[23:22]` | FU Staging Selector   |                                                       |
| `[23:20]` | Operation family      |                                                       |
| `[19:16]` | Operation variant     |                                                       |
| `[15:12]` | Mode?                 |                                                       |
| `[11:6]`  | Saturation            | See the saturator note below                          |
| `[5:0]`   | `k`                   | Shift amount in most cases (6 bits, range 0–63)       |


**Note on the FU Saturator Field `[11:6]`**

| Bit    | Min         | Max        |
|:-------|:------------|:-----------|
| `[6]`  |             |            |
| `[7]`  | -1          | 0          |
| `[8]`  | -2          | 1          |
| `[9]`  | -8          | 7          |
| `[10]` | -128        | 127        |
| `[11]` | -32768      | 32767      |


#### Back and Front Buffers
In the following, what is referred to as the Back buffer is the buffer routed to the current TOP_SOURCE, over which the Front buffer will be processed. It is worth noting that the Front buffer appears to be routable to any Base or Top buffer available in the ranges `0x44000000` or `0x44020000` using the F Sel related bits.

#### Globals

**INTERCONNECT_AGU_TOP** (renamed from INPUT) maps the 8 buffers to PE inputs in the following layout:
```text
  [PE3:8] [PE2:8] [PE1:8] [PE0:8]
```
Each byte encodes:
```text
  [front index routing:4 | back index routing:4]
```

*Note:can be using with `BASE_INPUT`/`ENABLE_SECOND_FU` as a router*
 
**INTERCONNECT_AGU_WRITE** (renamed from ARCH) maps inter-PE datapath configuration inheritance. Each nibble selects the source PE index for a target PE lane:
```text
  [PE3:4] [PE2:4] [PE1:4] [PE0:4]
```
Each nibble encodes:
```text
  [PE index routing:4]
```

*Note: this mapping appears to be used for inter-PE datapath configuration inheritance, covering routing and associated control parameters.*

**INTERCONNECT_AGU_BASE** (renamed from FLOW) re-routes the wiring of the local MUX of each PE. The 32-bit field is split into two 16-bit halves, each divided into four nibbles, one per physical PE (PE0 to PE3):
```text
  [PE3:4] [PE2:4] [PE1:4] [PE0:4]
```
Each nibble encodes:
```text
  [PE index routing:4]
```
Each nibble encodes the index of the PE whose BASE_SRC (or TOP_SRC) is routed as input to the local MUX of the targeted PE.

**INTERCONNECT_SKEW** selects an input and applies a cycle skew to the data stream forwarded to the target PE.
```text
  top[31:16]{[PE3:4] [PE2:4] [PE1:4] [PE0:4]} base[15:0]{[PE3:4] [PE2:4] [PE1:4] [PE0:4]}
```
Each nibble encodes:
```text
  [PE skew code:4]
```
Skews:  
`0b000` 0, `0b100` 1, `0b101` 2, `0b110` 3, `0b111` 4

### Operations

Using the following opcodes, the Back and Front buffers both appear to be routed to `0x44020000` by default. F Sel and B Sel must be modified to change the routing.

#### Generics ALU

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
| `0x00094000` | Right shift constant b by back[n] (variable barrel shift)              | `(b >> back[n])`                              |
| `0x000a4000` | Left shift                                                             | `(x << b)`                                    |
| `0x000b4000` | Left shift (unclear)                                                   | `(x << b)`                                    |
| `0x000c4000` | Bitwise AND                                                            | `(x & b)`                                     |
| `0x000d4000` | Bitwise OR                                                             | `(x \| b)`                                    |
| `0x000e4000` | Exclusive OR                                                           | `(x ^ b)`                                     |
| `0x000f4000` | Non-zero test                                                          | `(x != 0)`                                    |

#### Multiply / MACs / Filters using the ACC

| Opcode       | Operation                                        | Expression                                    |
|:-------------|:-------------------------------------------------|:----------------------------------------------|
| `0x00200000` | Multiply back and front buffers with shift       | `(back[n] * front[n]) >> k`                   |
| `0x00201000` | Same as the previous one?                        |                                               |
| `0x00202000` | Same as the previous one?                        |                                               |
| `0x00203000` | Same as the previous one?                        |                                               |
| `0x00204000` | Multiply by constant with shift                  | `(back[n] * b) >> k`                          |
| `0x00205000` | Same as the previous one?                        |                                               |
| `0x00206000` | Same as the previous one?                        |                                               |
| `0x00207000` | Same as the previous one?                        |                                               |
| `0x00208000` | Multiply-negate with shift                       | `(-(back[n] * front[n])) >> k`                |
| `0x00209000` | Same as the previous one?                        |                                               |
| `0x0020a000` | Same as the previous one?                        |                                               |
| `0x0020b000` | Same as the previous one?                        |                                               |
| `0x0020c000` | Multiply-negate by constant with shift           | `(-(back[n] * b)) >> k`                       |
| `0x0020d000` | Same as the previous one?                        |                                               |
| `0x0020e000` | Same as the previous one?                        |                                               |
| `0x0020f000` | Same as the previous one?                        |                                               |

| Opcode       | Operation                                        | Expression                                                            |
|:-------------|:-------------------------------------------------|:----------------------------------------------------------------------|
| `0x00200000` | Multiply back and front buffers with shift       | `(back[n] * front[n]) >> k`                                           |
| `0x00210000` | Delayed Scalar Multiply-Shift                    | `(x[n] * x[n-1]) >> k` with `x[-1] = b`                               |
| `0x00220000` | Vector Multiply-Shift                            | `(back[n] * front[n]) >> k`                                           |
| `0x00230000` | Negated Vector Multiply-Shift                    | `-((front[n] * back[n]) >> k)`                                        |
| `0x00240000` | Inner Product running VMAC with Bias             | `(Σn(back[n] * front[n]) + b) >> k`                                   |
| `0x00250000` | Accumulate with Shift and Bias                   | `(i == 0 ? (b >> K) : out[n-1]) + (back[n] >> k)`                     |
| `0x00260000` | Scalar Multiply-Shift with Bias                  | `((a * n) + b) >> k`                                                  |
| `0x00270000` | Vector Multiply-Shift with Bias                  | `(back[n] * front[n]) + b) >> k`                                      |
| `0x00280000` | Delayed Feedback IIR Accumulator                 | `0 if n < 2 else ((out[n-1] + front[n-2] + back[n-2]) >> k) + a`      |
| `0x00290000` | Sum of Absolute Differences (SAD)                | `Σ{m=0..n-2} abs(back[m] - front[m]) + b`                             |
| `0x002a0000` | Same as `0x00280000`?                            |                                                                       |
| `0x002b0000` | *unknown*                                        |                                                                       |
| `0x002c0000` | *unknown*                                        |                                                                       |
| `0x002d0000` | *unknown*                                        |                                                                       |
| `0x002e0000` | *unknown*                                        |                                                                       |
| `0x002f0000` | *unknown*                                        |                                                                       |


**0x00a00000 or (0x00800000 | 0x00200000)**  

| Opcode       | Operation                                                     | Expression                                                       | Duplicate |
|:-------------|:--------------------------------------------------------------|:-----------------------------------------------------------------|:----------|
| `0x00a00000` | *unclear*                                                     | `(back[n] * front[n]) >> k`                                      | yes       |
| `0x00a10000` | *unclear*                                                     | `front[n] * front[n-1] + ((!(n % 4) && n) ? front[n-1] / 3 : 0)` | no        |
| `0x00a20000` | same as 0x00a00000?                                           |                                                                  | yes       |
| `0x00a30000` | *unclear*                                                     | `-((back[n] * front[n]) >> k)`                                   | yes       |
| `0x00a40000` | *unclear*                                                     | `(Σn(back[n] * front[n]) + b) >> k`                              | yes       |
| `0x00a50000` | *unclear*                                                     | `(Σn(front[0..n]) + b) >> k`                                     | no        |
| `0x00a60000` | *unclear*                                                     | `((n * a) + b) >> k`                                             | yes       |
| `0x00a70000` | *unclear*                                                     | `(back[n] * front[n]) + b) >> k`                                 | yes       |
| `0x00a80000` | *unclear*                                                     | `0 if n < 2 else ((out[n-1] + front[n-2] + back[n-2]) >> k) + a` | yes       |
| `0x00a90000` | *unclear*                                                     | `Σ{m=0..n-2} abs(back[m] - front[m]) + b`                        | yes       |
| `0x00aa0000` |  Same as `0x00a80000`?                                        |                                                                  | yes       |
| `0x00ab0000` | *unknown*                                                     |                                                                  |           |
| `0x00ac0000` | *unknown*                                                     |                                                                  |           |
| `0x00ad0000` | *unknown*                                                     |                                                                  |           |
| `0x00ae0000` | *unknown*                                                     |                                                                  |           |
| `0x00af0000` | *unknown*                                                     |                                                                  |           |

*Note: using this opcode, or when OR'ing `0x00800000` with another opcode, the Back and Front buffers appear to be respectively routed to `0x44020000` and `0x44020800`.*


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
| `0x00090000` | Right shift constant b by back[n] (variable barrel shift)         | `(b >> back[n])`                        |
| `0x000a0000` | Shift back buffer left by front buffer value                      | `back[n] << front[n]`                   |
| `0x000b0000` | Same as the previous one?                                         |                                         |
| `0x000c0000` | Minimum of back and front buffer                                  | `min(back[n], front[n])`                |
| `0x000d0000` | Bitwise OR of back and front buffer                               | `back[n] \| front[n]`                   |
| `0x000e0000` | Bitwise XOR of back and front buffer                              | `back[n] ^ front[n]`                    |
| `0x000f0000` | *Unknown*                                                         |                                         |


#### Data Conditioning ALU and Bitwise Opcodes

| Opcode       | Operation                                                         | Expression                                  |
|:-------------|:------------------------------------------------------------------|:--------------------------------------------|
| `0x0000c000` | Constant b                                                        | `b`                                         |
| `0x0001c000` | Arithmetic right shift back by k                                  | `(back[n] >> k)`                            |
| `0x0002c000` | Negate shifted back, add constant b                               | `(-(back[n] >> k)) + b`                     |
| `0x0003c000` | Subtract back from front                                          | `(front[n] - back[n])`                      |
| `0x0004c000` | Negate back shifted by b, add a                                   | `(-(back[n] >> b)) + a`                     |
| `0x0005c000` | Add front and back, shift left by k (1-2 bits)                    | `(back[n] + front[n]) << k` with `k[0..1]`  |
| `0x0006c000` | Branchless conditional move (CMOV) with bias                      | `((front[n] & a) ? back[n] : 0) + b`        |
| `0x0007c000` | Clamp back buffer                                                 | `max(a, min(b, back[n]))`                   |
| `0x0008c000` | Conditional: return b if bit test on back passes, else 0          | `(back[n] & a) ? b : 0`                     |
| `0x0009c000` | Right shift constant b by back[n] (variable barrel shift)         | `(b >> back[n])`                            |
| `0x000ac000` | Right shift back[n] by constant b                                 | `(back[n]) >> b`                            |
| `0x000bc000` | Same as previous one?                                             |                                             |
| `0x000cc000` | Bitwise NAND of b and back[n]                                     | `-(b & back[n]) - 1` or `~(b & back[n])`    |
| `0x000dc000` | Bitwise NOT of back[n] masked by ~b                               | `(-back[n] - 1) & ~b` or `(~back[n]) & ~b`  |
| `0x000ec000` | Bitwise NOT of back[n] XOR b (selective bit flip)                 | `(~back[n]) ^ b`                            |
| `0x000fc000` | Bitwise NOT / polarity inversion                                  | `~back[n]`                                  |


#### Running Extrema & Envelope Follower

| Opcode       | Operation                                                              | Expression                                             |
|:-------------|:-----------------------------------------------------------------------|:-------------------------------------------------------|
| `0x00100000` | Running max                                                            | `max(out[n-1], in[n])`                                 |
| `0x00110000` | Running min extrema filters                                            | `min(LASTMIN(out), back[n] - front[n])`                |
| `0x00120000` | Running rate-limited smoothing filter <br>Peak Clamper ?               | `min(in[n], max(in[0..n−1])); out[0] = in[0]`          |
| `0x00130000` | Running max extrema filters                                            | `max(LASTMIN(out), back[n] - front[n])`                |

| Opcode       | Operation                                                              | Expression                                           |
|:-------------|:-----------------------------------------------------------------------|:-----------------------------------------------------|
| `0x00140000` | Per-element maximum                                                    | `max(back[n], front[n])`                             |
| `0x00150000` | Back buffer *unclear*                                                  | `back[n]`                                            |
| `0x00160000` | Same as previous one?                                                  |                                                      |
| `0x00170000` | Signed 24-bit absolute difference                                      | `\|back[n]-b\|`                                      |
| `0x00180000` | Back buffer *unclear*                                                  | `back[n]`                                            |
| `0x00190000` | Same as previous one?                                                  |                                                      |
| `0x001a0000` | Same as previous one?                                                  |                                                      |
| `0x001b0000` | Constant                                                               | `b`                                                  |
| `0x001c0000` | Signed 24-bit absolute sum                                             | `\|(back[n] + front[n])\|`                           |
| `0x001d0000` | Back buffer *unclear*                                                  | `back[n]`                                            |
| `0x001e0000` | Signed 24-bit absolute difference with offset a                        | `\|(back[n] - front[n])\| + a`                       |
| `0x001f0000` |                                                                        | `\|(front[n] - back[n])\| + b`                       |


#### Some Pixel ALU Operations: bitwise logic, arithmetic, shift and predicated select

| Opcode       | Operation                                                              | Expression                                               |
|:-------------|:-----------------------------------------------------------------------|:---------------------------------------------------------|
| `0x00008000` | Passthrough                                                            | `back[n]`                                                |
| `0x00018000` | Subtract back buffer from front buffer and right shift                 | `(front[n] - back[n]) >> k`                              |
| `0x00028000` | Same as previous one?                                                  |                                                          |
| `0x00038000` | Accumulate front and back buffers                                      | `(front[n] + back[n])`                                   |
| `0x00048000` | Subtract back buffer from front buffer and add constant b              | `(front[n] - back[n]) + b`                               |
| `0x00058000` | Add second 8-bit channel components <br>and scale result               | `(((0xFF00 & front[n]) + (0xFF00 & back[n])) >> 8) << k` |
| `0x00068000` | predicated select PHIMUX                                               | `(front[n] & a) != 0 ? b : back[n]`                      |
| `0x00078000` | Minimum of front and back buffers                                      | `min(back[n], front[n])`                                 |
| `0x00088000` | Constant                                                               | `b`                                                      |
| `0x00098000` | Left shift constant b by back buffer value                             | `(b << back[n])`                                         |
| `0x000a8000` | Vector Shift Right                                                     | `back[n] ROR.64 front[n]`                                |
| `0x000b8000` | Same as previous one?                                                  | `back[n] >> front[n]`                                    |
| `0x000c8000` | NAND                                                                   | `~(front[n] & back[n])`                                  |
| `0x000d8000` | NOR                                                                    | `~(front[n] | back[n])`                                  |
| `0x000e8000` | Inverted absolute difference                                           | `~(\|front[n]-back[n]\|)`                                |
| `0x000f8000` | XOR parity                                                             | `back[n]0 ^ back[n]1 ^ back[n]2 ^ ...`                   |


**WIP**  

#### 0x00050000 to 0x0005f000

| Opcode       | Operation                                                          | Expression                                                   |
|:-------------|:-------------------------------------------------------------------|:-------------------------------------------------------------|
| `0x00050000` | Subtract front buffer right shifted by b from back buffer          | `back[n] - (front[n] >> b)`                                  |
| `0x00051000` | Same as previous one?                                              |                                                              |
| `0x00052000` | Same as previous one?                                              |                                                              |
| `0x00053000` | Same as previous one?                                              |                                                              |
| `0x00054000` | Shift and subtract                                                 | `(back[n] >> b) - a`                                         |
| `0x00055000` | Same as previous one?                                              |                                                              |
| `0x00056000` | Same as previous one?                                              |                                                              |
| `0x00057000` | Same as previous one?                                              |                                                              |
| `0x00058000` | Add second 8-bit channel components <br>and scale result           | `(((0xFF00 & front[n]) + (0xFF00 & back[n])) >> 8) << k`     |
| `0x00059000` | Same as previous one?                                              |                                                              |
| `0x0005a000` | Same as previous one?                                              |                                                              |
| `0x0005b000` | Same as previous one?                                              |                                                              |
| `0x0005c000` | Add front and back, shift left by k (1-2 bits)                     | `((0xFF & back[n]) + (0xFF & front[n])) << k` with `k[0..1]` |
| `0x0005d000` | Same as previous one?                                              |                                                              |
| `0x0005e000` | Same as previous one?                                              |                                                              |
| `0x0005f000` | Same as previous one?                                              |                                                              |

#### 0x00080000 to 0x0008f000

| Opcode       | Operation                                                              | Expression                                           |
|:-------------|:-----------------------------------------------------------------------|:-----------------------------------------------------|
| `0x00080000` | Multiply back and front buffers if front[n] ∈ [-2, 2], else 0          | `(back[n] * front[n]) * 1[-2,2]​(front[n])`           |
| `0x00081000` | Same as previous one?                                                  |                                                      |
| `0x00082000` | Same as previous one?                                                  |                                                      |
| `0x00083000` | Same as previous one? *last bits unknown*                              |                                                      |
| `0x00084000` | Negative product of back[n] and front[n] if front[n] ∈ [-2, 2], else 0 | `-(back[n] * front[n]) * 1[-2,2]​(front[n])`          |
| `0x00085000` | Same as previous one?                                                  |                                                      |
| `0x00086000` | Same as previous one?                                                  |                                                      |
| `0x00087000` | Same as previous one?                                                  |                                                      |
| `0x00088000` | Constant                                                               | `b`                                                  |
| `0x00089000` | Same as previous one?                                                  |                                                      |
| `0x0008a000` | Same as previous one?                                                  |                                                      |
| `0x0008b000` | Same as previous one?                                                  |                                                      |
| `0x0008c000` | Conditional: return b if bit test on back passes, else 0               | `(back[n] & a) ? b : 0`                              |
| `0x0008d000` | Same as previous one?                                                  |                                                      |
| `0x0008e000` | Same as previous one?                                                  |                                                      |
| `0x0008f000` | Same as previous one?                                                  |                                                      |

#### 0x00050000 to 0x00f50000

| Opcode       | Operation                                                              | Expression                                           |
|:-------------|:-----------------------------------------------------------------------|:-----------------------------------------------------|
| `0x00050000` | Subtract front buffer right shifted by b from back buffer              | `back[n] - (front[n] >> b)`                          |
| `0x00150000` | Back buffer                                                            | `back[n]`                                            |
| `0x00250000` | Accumulate with Shift and Bias                                         | `(i == 0 ? (b >> k) : out[n-1]) + (back[n] >> k)`    |
| `0x00350000` | *unknown*                                                              | *unknown*                                            |
| `0x00450000` | Subtract and right shift                                               | `(back[n] - front[n]) >> b`                          |
| `0x00550000` | Back buffer                                                            | `back[n]`                                            |
| `0x00650000` |                                                                        | `(out[n-1] + back[n] + b) >> k`                      |
| `0x00750000` | *unknown*                                                              |                                                      |
| `0x00850000` |                                                                        | `-front[n]`                                          |
| `0x00950000` | *unknown*                                                              |                                                      |
| `0x00a50000` |                                                                        |                                                      |
| `0x00b50000` |                                                                        |                                                      |
| `0x00c50000` |                                                                        |                                                      |
| `0x00d50000` |                                                                        |                                                      |
| `0x00e50000` |                                                                        |                                                      |
| `0x00f50000` |                                                                        |                                                      |


#### 0x00001000 to 0x000f1000
 
| Opcode       | FU Name                  | Operation                     | Expression                                           |
|:-------------|:-------------------------|:------------------------------|:-----------------------------------------------------|
| `0x00001000` |                          |                               |                                                      |
| `0x00011000` | Vector Add               | Element-wise addition         | `back[n] + front[n]`                                 |
| `0x00021000` | Accumulate Add           | Accumulated addition          | `back[n] + front[n]`                                 |
| `0x00031000` | Add Immediate            | Addition with immediate       | `(back[n] + front[n]) + a`                           |
| `0x00041000` | Shift Scale              | Arithmetic right scaling      | `(back[n] + front[n]) >> b`                          |
| `0x00051000` | Subtract Bias            | Difference with bias removal  | `(back[n] - front[n]) - b`                           |
| `0x00061000` | Predicate Negate         | Conditional sign inversion    | `(front[n] & a) ? -back[n] : back[n]`                |
| `0x00071000` | Predicated Add/Sub       | Conditional add/subtract      | `(i & a) ? back[i] - b : back[i] + b`                |

#### 0x00090000 to 0x00f90000

| Opcode       | Operation                                                              | Expression                                               |
|:-------------|:-----------------------------------------------------------------------|:---------------------------------------------------------|
| `0x00090000` | Left shift constant b by Back buffer value                             | `(b << back[n])`                                         |
| `0x00190000` | Back buffer                                                            | `back[n]`                                                |
| `0x00290000` | SAD                                                                    |                                                          |
| `0x00390000` | *unknown*                                                              | `unknown`                                                |
| `0x00490000` | Left shift constant b by Back buffer value                             | `(b << back[n])`                                         |
| `0x00590000` | Back buffer                                                            | `back[n]`                                                |
| `0x00690000` | SAD                                                                    |                                                          |
| `0x00790000` | *unknown*                                                              | `unknown`                                                |
| `0x00890000` | Left shift constant b by Front buffer value                            | `(b << front[n])`                                        |
| `0x00990000` | Front buffer                                                           | `front[n]`                                               |
| `0x00a90000` | SAD                                                                    |                                                          |
| `0x00b90000` | *unknown*                                                              | `unknown`                                                |
| `0x00c90000` | Left shift constant b by Front buffer value                            | `(b << front[n])`                                        |
| `0x00d90000` | Front buffer                                                           | `front[n]`                                               |
| `0x00e90000` | SAD (OR'ed with 0x00a00000)                                            |                                                          |
| `0x00f90000` | *unknown*                                                              | `unknown`                                                |

#### 0x00010000 to 0x00f10000

| Opcode       | Operation                                                     | Expression                                                       |
|:-------------|:--------------------------------------------------------------|:-----------------------------------------------------------------|
| `0x00010000` | Add back buffer to front buffer and right shift               | `(back[n] + front[n]) >> k`                                      |
| `0x00110000` | Running min extrema filters                                   | `min(LASTMIN(out), back[n] - front[n])`                          |
| `0x00210000` | Delayed Scalar Multiply-Shift                                 | `(x[n] * x[n-1]) >> k` with `x[-1] = b`                          |
| `0x00310000` |                                                               | `(back[n] + front[n]) >> k`                                      |
| `0x00410000` |                                                               | `(back[n] + front[n]) >> k`                                      |
| `0x00510000` |                                                               | `(front[n] - back[n]) >> k`                                      |
| `0x00610000` |                                                               | `back[i] * back[i-1]` with `back[-1] = b`                        |
| `0x00710000` |                                                               |                                                                  |
| `0x00810000` |                                                               |                                                                  |
| `0x00910000` |                                                               |                                                                  |
| `0x00a10000` | *unclear*                                                     | `front[n] * front[n-1] + ((!(n % 4) && n) ? front[n-1] / 3 : 0)` |
| `0x00b10000` |                                                               |                                                                  |
| `0x00c10000` |                                                               |                                                                  |
| `0x00d10000` |                                                               |                                                                  |
| `0x00e10000` |                                                               |                                                                  |
| `0x00f10000` |                                                               |                                                                  |

#### Todo

| Opcode       | Operation                                                     | Expression                                                       |
|:-------------|:--------------------------------------------------------------|:-----------------------------------------------------------------|
| `0x00020000` |                                                               |                                                                  |
| `0x00120000` |                                                               |                                                                  |
| `0x00220000` |                                                               |                                                                  |
| `0x00320000` |                                                               |                                                                  |


### MODIFIER Observations

#### MODIFIER_A
0x00001040 -x  
0x00000080 to 0x...f0 shift 1 cycle  
0x20000040 shift right fu flow cycles?  
0x80000040 clear  
0x00010040 add 1  
0x00020040 bits right shift  
0x00030040 bits right shift (min 1)  

#### MODIFIER_C
0x00000004 right shift 3 cycles  

### Libraries

See the following libraries for using the VME and for code examples:  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  
[PSP Media Engine Safe Task](https://github.com/mcidclan/psp-media-engine-safe-task)  

*mcidclan, m-c/d 2026*
