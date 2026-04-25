## VME Bitstream v0.2 - Preliminary Spec

This part of our experimental investigation is an attempt to figure out how the Virtual Mobile Engine could be programmed, and whether what appears to be a bitstream sent somewhere is the one related to the VME or something else.

### Sending and Processing the Bitstream via DMAC

Below are the minimal configurations required to load and execute it:

```cpp
  hw(0x440ff004) = 0x10;                            // Routing config ?
  hw(0x440ff010) = 0x40000000 | (u32Me)&bitstream;  // Channel1 src (host memory or me edram)
  hw(0x440ff008) = 0x1c;                            // Control
  
  meCoreDMACPrimMuxWaitStatus(0x200);               // Wait for the transfer to finish
```

```cpp
  meCoreDMACPrimMuxWaitStatus(0x800);               // Execute and wait for the VME to finish
```

### Revealing the Unknown

By luck, during a test, a wrong address passed to the DMAC with the previous configuration was producing data transformation and generation over the internal 24-bit ring buffers.

From there, the first attempt was to send various random data, observe the results, and try to isolate which data units were triggering exploitable outputs.

This ended up revealing recognizable memory patterns, providing a first basis to explore toward the discovery of a clearer structure, one that was also recognizable inside an EDRAM dump.  

Please see tools/bitstream/edram-dump for the dumping sample.  

#### About the Default Bitstream

It is important to note that the bitstream or data found in the EDRAM does not generate changes over the internal ring buffers as is, but sending it with our DMAC minimal configuration makes it pass through the wait status.  

which I think could be related to waiting for the VME to be in a dormant/finish state, after processing the first pass.

#### The Emerging Bitstream Structure

Based on the limited information available on the VME, it appears to be a type of CGRA.

Below is an early analysis of the bitstream:

```cpp
unsigned int defaultBitstream[] __attribute__((aligned(64))) = {
    
    /*
     * Buffers sources routing/configuration - (routing << 16) | (data transformation)
     */

    0x00000000, // 0x000 - configuration for buffer 0
    0x00000000, // 0x004 - configuration for buffer 1
    0x00000000, // 0x008 - configuration for buffer 2
    0x00000000, // 0x00C - configuration for buffer 3

    
    /*
     * Unknown
     */
     
    0x00000000, // 0x010
    0x00000000, // 0x014
    0x00000000, // 0x018
    0x00000000, // 0x01C
    
    
    /*
     * Transformation (with 0x00044000 as configuration)
     */
     
    // buffer 0
    0x00000000, // 0x020 - addition of the constant value, use negative number to get the opposite
    0x00000000, // 0x024 - right shift of the constante value, use negative number to get the oposite
    
    // buffer 1
    0x00000000, // 0x028
    0x00000000, // 0x02C
    
    // buffer 2
    0x00000000, // 0x030
    0x00000000, // 0x034
    
    // buffer 3
    0x00000000, // 0x038
    0x00000000, // 0x03C
    
    
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
    0x00000000, // 0x060
    0x00000000, // 0x064
    0x00000000, // 0x068

    
    /*
     * Target Buffer Processing Element Mapping
     */
     
    0x00000000, // 0x06C - unknown
    0x00000000, // 0x070 - unknown
    0x00000000, // 0x074 - unknown
    0x00000000, // 0x078 - target controler, (? << 16) | (target PE, buf3, buf2, buf1, buf0)
    0x00000000, // 0x07C - unknown 
    0x00000000, // 0x080 - unknown
    
    
    /*
     * Processing Element for routed buffer 0
     */
     
    // Source configuration and process
    0x00000000, // 0x084 - (Local Config < 16) | (Source Offset)
    0x00000000, // 0x088 - (Local Config < 16) | (Source Count - 1)
    0x00000000, // 0x08C - (Local Config < 16) | (Step related)
    0x00000000, // 0x090 - (Local Config < 16) | (unclear)
    0x00000000, // 0x094 - unclear / additionnal transformation
    0x00000000, // 0x098 - unclear
    
    // Unknown
    0x00000000, // 0x09C
    0x00000000, // 0x0A0
    0x00000000, // 0x0A4
    0x00000000, // 0x0A8
    0x00000000, // 0x0AC
    0x00000000, // 0x0B0
    
    // Destination configuration and process
    0x00000000, // 0x0B4 - (Local Config < 16) | (Destination Offset)
    0x00000000, // 0x0B8 - (Local Config < 16) | (Destination Count - 1)
    0x00000000, // 0x0BC - (Local Config < 16) | (Step related)
    0x00000000, // 0x0C0 - (Local Config < 16) | (unclear)
    0x00000000, // 0x0C4 - unclear / additionnal transformation
    0x00000000, // 0x0C8 - unclear
    
    
    /*
     * Processing Element for routed buffer 1
     */
     
    // Unclear - Probably independent source control for routed buffer 1
    0x00000000, // 0x0CC
    0x00000000, // 0x0D0
    0x00000000, // 0x0D4
    0x00000000, // 0x0D8
    0x00000000, // 0x0DC
    0x00000000, // 0x0E0
    
    // Unknown
    0x00000000, // 0x0E4
    0x00000000, // 0x0E8
    0x00000000, // 0x0EC
    0x00000000, // 0x0F0
    0x00000000, // 0x0F4
    0x00000000, // 0x0F8
    
    // Destination configuration and process for routed buffer 1
    0x00000000, // 0x0FC
    0x00000000, // 0x100
    0x00000000, // 0x104
    0x00000000, // 0x108
    0x00000000, // 0x10C
    0x00000000, // 0x110
    
    
    /*
     * Processing Element for routed buffer 2
     */
     
    // Unclear - Probably independent source control for routed buffer 2
    0x00000000, // 0x114
    0x00000000, // 0x118
    0x00000000, // 0x11C
    0x00000000, // 0x120
    0x00000000, // 0x124
    0x00000000, // 0x128
    
    // Unknown
    0x00000000, // 0x12C
    0x00000000, // 0x130
    0x00000000, // 0x134
    0x00000000, // 0x138
    0x00000000, // 0x13C
    0x00000000, // 0x140
    
    // Destination configuration and process for routed buffer 2
    0x00000000, // 0x144
    0x00000000, // 0x148
    0x00000000, // 0x14C
    0x00000000, // 0x150
    0x00000000, // 0x154
    0x00000000, // 0x158
    
    
    /*
     * Processing Element for routed buffer 3
     */
    
    // Unclear - Probably independent source control for routed buffer 3
    0x00000000, // 0x15C
    0x00000000, // 0x160
    0x00000000, // 0x164
    0x00000000, // 0x168
    0x00000000, // 0x16C
    0x00000000, // 0x170
    
    // Unknown
    0x00000000, // 0x174
    0x00000000, // 0x178
    0x00000000, // 0x17C
    0x00000000, // 0x180
    0x00000000, // 0x184
    0x00000000, // 0x188
    
    // Destination configuration and process for routed buffer 3
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

#### PE Configuration Block Structure

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

Which gives us something like:  
| Word  | Data Unit MSB | Data Unit LSB |
|-------|---------------|---------------|
| 0     | DU0           | DU1           |
| 1     | DU2           | DU3           |
| 2     | DU4           | DU5           |
| 3     | DU6           | DU7           |
| 4     | DU8           | DU9           |
| 5     | DU10          | DU11          |

#### Default Met Values

The following is a part of a Processing Element found in the EDRAM dump.  
```cpp
0x8000 < 16 | 0x0000,
0x0001 < 16 | 0x0007,
0x0001 < 16 | 0x0007,
0x0001 < 16 | 0x0007,
0x0002 < 16 | 0x0000,
0x003b < 16 | 0x0000,
```
