# VME Bitstream v0.3 - Preliminary Spec

This part of our experimental investigation is an attempt to figure out how the Virtual Mobile Engine could be programmed, and whether what appears to be a bitstream sent somewhere is the one related to the VME or something else.

## Revealing the Unknown

By luck, during a test, a wrong address passed to the DMAC with the previous configuration was producing data transformation and generation over the internal 24-bit ring buffers.

From there, the first attempt was to send various random data, observe the results, and try to isolate which data units were triggering exploitable outputs.

This ended up revealing recognizable memory patterns, providing a first basis to explore toward the discovery of a clearer structure, one that was also recognizable inside an eDRAM dump.  

Note: It is important to know, that the bitstream or related data found in the eDRAM does not generate changes over the internal ring buffers as is.

## The Emerging Bitstream Structure

Below is an early attempt at mapping the structure and meaning of the bitstream and its command units:

```cpp
unsigned int defaultBitstream[] __attribute__((aligned(64))) = {
    
    /*
     * Buffers sources routing/configuration - (routing << 24) | (data transformation) << 8 | (k)
     * (k) is a Constant used in DSP operations 
     */

    0x00000000, // 0x000 - Descriptor for PE 0
    0x00000000, // 0x004 - Descriptor for PE 1
    0x00000000, // 0x008 - Descriptor for PE 2
    0x00000000, // 0x00C - Descriptor for PE 3

    
    /*
     * Unknown, possibly related to additional buffer or extended configuration.
     */
     
    0x00000000, // 0x010
    0x00000000, // 0x014
    0x00000000, // 0x018
    0x00000000, // 0x01C
    
    
    /*
     * Transformation: DSP operations applied to the corresponding routed buffer.
     */
     
    // Registers for PE 0
    0x00000000, // 0x020 - (a) Register used in DSP operations
    0x00000000, // 0x024 - (b) Register used in DSP operations
    
    // Registers for PE 1
    0x00000000, // 0x028 - (a)
    0x00000000, // 0x02C - (b)
    
    // Registers for PE 2
    0x00000000, // 0x030 - (a)
    0x00000000, // 0x034 - (b)
    
    // Registers for PE 3
    0x00000000, // 0x038 - (a)
    0x00000000, // 0x03C - (b)
    
    
    /*
     * Unknown
     */
    
    0x00000000, // 0x040
    0x00000000, // 0x044
    0x00000000, // 0x048
    0x00000000, // 0x04C
    
    0x00000000, // 0x050
    0x00000000, // 0x054
    0x00000000, // 0x058
    0x00000000, // 0x05C
    
    
    /*
     * Unclear, Source II related, Mixer ?
     */
    
    0x00000000, // 0x060
    0x00000000, // 0x064
    0x00000000, // 0x068
    
    
    /*
     * Processing Element Mapping
     */
     
    0x00000000, // 0x06C - unknown
    0x00000000, // 0x070 - unknown
    0x00000000, // 0x074 - SRC PE Mapper, (? << 16) | (target PE: PE_3, PE_2, PE_1, PE_0)
    0x00000000, // 0x078 - DST PE Mapper, (? << 16) | (target PE: PE_3, PE_2, PE_1, PE_0)
    0x00000000, // 0x07C - unknown 
    0x00000000, // 0x080 - unknown
    
    
    /*
     * Processing Element for routed buffers 0, (base address: 0x44000000)
     */
     
    // Source processor I (configuration and process)
    0x00000000, // 0x084 - (Local Config < 16) | (Source Offset)
    0x00000000, // 0x088 - (Local Config < 16) | (Source Count - 1)
    0x00000000, // 0x08C - (Local Config < 16) | (Shift Scale and Step related, depends on Local Config)
    0x00000000, // 0x090 - (Local Config < 16) | (Shift Scale and Step related, depends on Local Config)
    0x00000000, // 0x094 - additionnal transformations, offset shift, reserve
    0x00000000, // 0x098 - unclear / additionnal transformations
    
    // Source processor II (configuration and process) could be used as a storage result
    0x00000000, // 0x09C
    0x00000000, // 0x0A0
    0x00000000, // 0x0A4
    0x00000000, // 0x0A8
    0x00000000, // 0x0AC
    0x00000000, // 0x0B0
    
    // Destination processor (configuration and process)
    0x00000000, // 0x0B4 - (Local Config < 16) | (Destination Offset)
    0x00000000, // 0x0B8 - (Local Config < 16) | (Destination Count - 1)
    0x00000000, // 0x0BC - (Local Config < 16) | (Shift Scale and Step related, depends on Local Config)
    0x00000000, // 0x0C0 - (Local Config < 16) | (Shift Scale and Step related, depends on Local Config)
    0x00000000, // 0x0C4 - additionnal transformations, offset shift, reserve
    0x00000000, // 0x0C8 - unclear / additionnal transformations
    
    /*
     * Processing Element for routed buffers 1 , (base address: 0x44002000)
     */
     
    // Unclear - Probably independent Source processor I
    0x00000000, // 0x0CC
    0x00000000, // 0x0D0
    0x00000000, // 0x0D4
    0x00000000, // 0x0D8
    0x00000000, // 0x0DC
    0x00000000, // 0x0E0
    
    // Source processor II
    0x00000000, // 0x0E4
    0x00000000, // 0x0E8
    0x00000000, // 0x0EC
    0x00000000, // 0x0F0
    0x00000000, // 0x0F4
    0x00000000, // 0x0F8
    
    // Destination processor
    0x00000000, // 0x0FC
    0x00000000, // 0x100
    0x00000000, // 0x104
    0x00000000, // 0x108
    0x00000000, // 0x10C
    0x00000000, // 0x110
    
    
    /*
     * Processing Element for routed buffers 2, (base address: 0x44004000)
     */
     
    // Unclear - Probably independent Source processor I
    0x00000000, // 0x114
    0x00000000, // 0x118
    0x00000000, // 0x11C
    0x00000000, // 0x120
    0x00000000, // 0x124
    0x00000000, // 0x128

    // Source processor II (e.g base address could be set at 0x44004000)
    0x00000000, // 0x12C
    0x00000000, // 0x130
    0x00000000, // 0x134
    0x00000000, // 0x138
    0x00000000, // 0x13C
    0x00000000, // 0x140
    
    // Destination processor (e.g base address could be set at 0x44004000)
    0x00000000, // 0x144
    0x00000000, // 0x148
    0x00000000, // 0x14C
    0x00000000, // 0x150
    0x00000000, // 0x154
    0x00000000, // 0x158
    
    
    /*
     * Processing Element for routed buffers 3, (base address: 0x44004000)
     */
    
    // Unclear - Probably independent Source processor I
    0x00000000, // 0x15C
    0x00000000, // 0x160
    0x00000000, // 0x164
    0x00000000, // 0x168
    0x00000000, // 0x16C
    0x00000000, // 0x170
    
    // Source processor II (e.g base address could be set at 0x44006000)
    0x00000000, // 0x174
    0x00000000, // 0x178
    0x00000000, // 0x17C
    0x00000000, // 0x180
    0x00000000, // 0x184
    0x00000000, // 0x188
    
    // Destination processor (e.g base address could be set at 0x44006000)
    0x00000000, // 0x18C
    0x00000000, // 0x190
    0x00000000, // 0x194
    0x00000000, // 0x198
    0x00000000, // 0x19C
    0x00000000, // 0x1A0
    
    
    /*
     * End ?
     */
     
    0x00000018, // 0x1A4 - default met value
};
```

As shown above, this attempt to identify an exploitable structure remains incomplete.

The goal of this experimental investigation is to clarify the structure and meaning of the instruction and data units within the bitstream.

### Processing Element Block Structure

Each Processing Element (PE) in what we assume to be a CGRA bitstream appears to be composed of blocks made of 6 consecutive 32-bit words, representing 12 x 16-bit configuration units:

```cpp
// Block part of a Processing Element (12 x 16-bit units)
0x80000000, // Word 0: Enable flag (bit 31 must be set to activate the block)
0x00000000, // Word 1
0x00000000, // Word 2
0x00000000, // Word 3
0x00000000, // Word 4
0x00000000, // Word 5
```
