## VME Bitstream v0.1 - Rough Exploration

This part of our experimental investigation is an attempt to figure out how the Virtual Mobile Engine could be programmed, and whether what appears to be a bitstream sent somewhere is the one related to the VME or something else.

### Sending via DMAC

Reversing the part of the code related to bitstream transfer into the ME core, reveals 2 possible addresses as sources for the bitstream. Unfortunately, neither of them contains directly exploitable data. The first targets the address of the ME EDRAM at `0x403cf4f8`, which contains a succession of 24-bit values. The other is at `0x5fff917c`, which is probably a bad decompilation and causes a complete reset of the Media Engine. The exact reason (bus error, unhandled exception, etc.) has not been investigated. That said, below is the minimal configuration required to load the bitstream.  

#### Minimal configuration
```cpp
  hw(0x440ff004) = 0x10; // Routing config ?
  hw(0x440ff010) = 0x40000000 | (u32Me)&bitstream; // Channel1 src (host memory or me edram)
  hw(0x440ff008) = 0x1c; // Control
  
  meCoreDMACPrimMuxWaitStatus(0x200); // Wait for the transfer to finish
```

### Revealing the unknown

By luck, during a test, a wrong address passed to the DMAC with the previous configuration was producing data transformation/generation over the internal 24-bit ring buffers.  

From there, the first attempt was to send different random data, observe the result, and try to isolate which data units were triggering exploitable results. This ended up revealing recognizable memory patterns that followed an exploitable structure, which was actually findable in the EDRAM dump.  

Please see tools/bitstream/edram-dump for the dumping sample.  

#### About the default bitstream

It is important to note that the bitstream or data found in the EDRAM does not generate changes over the internal ring buffers as is, but sending it with our DMAC minimal configuration makes it pass through the following wait status:  
```cpp
meCoreDMACPrimMuxWaitStatus(0x800); 
```
which I think could be related to waiting for the VME to be in a dormant state.  

#### The emerging bitstream structure

Here's an early analysis of the bitstream for what I believe, based on the limited information available on the VME, to be a type of CGRA:  
```cpp
unsigned int defaultBitstream[] __attribute__((aligned(64))) = {
  // Global CGRA configuration?
  0x00000000, // 0x00 - config / routing related to first internal ring buffer?
  0x00000000, // 0x04 - config / routing related to second internal ring buffer?
  0x00000000, // 0x08 - config / routing related to third internal ring buffer?
  0x00000000, // 0x0c - config / routing related to fourth internal ring buffer?
  
  //
  0x00000000, // 0x10 - additional config / mode / word quantity?

  // Unknown
  0x00000000, // 0x14
  0x00000000, // 0x18
  0x00000000, // 0x1c
  0x00000000, // 0x20
  
  // Related to data transformation?
  0x00000000, // 0x24
  0x00000000, // 0x28 - mode / frequency / block size? - affect data
  0x00000000, // 0x2c - affect ring buffer 0 data
  0x00000000, // 0x30 - affect ring buffer 1 data
  0x00000000, // 0x34 - affect ring buffer 2 data
  0x00000000, // 0x38 - affect ring buffer 3 data

  // Unknown
  0x00000000, // 0x3c
  0x00000000, // 0x40
  0x00000000, // 0x44
  0x00000000, // 0x48
  0x00000000, // 0x4c
  0x00000000, // 0x50
  
  // Unknown
  0x00000000, // 0x54
  0x00000000, // 0x58
  0x00000000, // 0x5c
  0x00000000, // 0x60 - affects output data / frequency / word quantity?
  0x00000000, // 0x64
  0x00000000, // 0x68
  
  // Processing Element (PE) 0 / router ? - This seems not to be an executable block.
  // Transformation related / ring buffer selector? 
  0x00000000, // 0x6c - enable
  0x00000000, // 0x70 - type / selector?
  0x00000000, // 0x74 - type / selector?
  0x00000000, // 0x78 - type / selector / disable ring buffers?
  0x00000000, // 0x7c - type / selector / disable/enable data components?
  0x00000000, // 0x80 - type / selector?
  
  // Processing Element (PE) 01 ? - This appear to be an executable block.
  // Enable transfer / transformation of all local ring buffers?
  0x00000000, // 0x84
  0x00000000, // 0x88
  0x00000000, // 0x8c
  0x00000000, // 0x90
  0x00000000, // 0x94
  0x00000000, // 0x98

  // Processing Element (PE) 02 ? - This appear to be an executable block.
  // Dynamic transformation?
  0x00000000, // 0x9c - enable
  0x00000000, // 0xa0 - type / data smoothing/graining?
  0x00000000, // 0xa4 
  0x00000000, // 0xa8
  0x00000000, // 0xac
  0x00000000, // 0xb0

  // Processing Element (PE) 03 ? - This appear to be an executable block.
  // Same type as 0x84? Required to enable dynamic transformation?
  0x00000000, // 0xb4 - enable + target first offset word to be transformed?
  0x00000000, // 0xb8 - type?
  0x00000000, // 0xbc
  0x00000000, // 0xc0
  0x00000000, // 0xc4
  0x00000000, // 0xc8 - word quantity per ring buffer / frequency / components?
  
  // Processing Element (PE) 04 ? - This appear to be an executable block.
  // Unknown - No feedback yet
  0x00000000, // 0xcc
  0x00000000, // 0xd0
  0x00000000, // 0xd4
  0x00000000, // 0xd8
  0x00000000, // 0xdc
  0x00000000, // 0xe0
  
  // Processing Element (PE) 05 ? - This appear to be an executable block.
  // Same type as 0x84?
  0x00000000, // 0xe4
  0x00000000, // 0xe8
  0x00000000, // 0xec
  0x00000000, // 0xf0
  0x00000000, // 0xf4
  0x00000000, // 0xf8
  
  // Processing Element (PE) 06 ? - This appear to be an executable block.
  // Unknown - No feedback yet
  0x00000000, // 0xfc
  0x00000000, // 0x100
  0x00000000, // 0x104
  0x00000000, // 0x108
  0x00000000, // 0x10c
  0x00000000, // 0x110
  
  // Processing Element (PE) 07 ? - This appear to be an executable block.
  // Same type as 0x84?
  0x00000000, // 0x114
  0x00000000, // 0x118
  0x00000000, // 0x11c
  0x00000000, // 0x120
  0x00000000, // 0x124
  0x00000000, // 0x128
  
  // Processing Element (PE) 08 ? - This appear to be an executable block.
  // Unknown - No feedback yet
  0x00000000, // 0x12c
  0x00000000, // 0x130
  0x00000000, // 0x134
  0x00000000, // 0x138
  0x00000000, // 0x13c
  0x00000000, // 0x140
  
  // Processing Element (PE) 09 ? - This appear to be an executable block.
  // Same type as 0x84?
  0x00000000, // 0x144
  0x00000000, // 0x148
  0x00000000, // 0x14c
  0x00000000, // 0x150
  0x00000000, // 0x154
  0x00000000, // 0x158
  
  // Processing Element (PE) 10 ? - This appear to be an executable block.
  // Unknown - No feedback yet
  0x00000000, // 0x15c
  0x00000000, // 0x160
  0x00000000, // 0x164
  0x00000000, // 0x168
  0x00000000, // 0x16c
  0x00000000, // 0x170
  
  // Processing Element (PE) 11 ? - This appear to be an executable block.
  // Same type as 0x84?
  0x00000000, // 0x174
  0x00000000, // 0x178
  0x00000000, // 0x17c
  0x00000000, // 0x180
  0x00000000, // 0x184
  0x00000000, // 0x188
  
  // Processing Element (PE) 12 ? - This appear to be an executable block.
  // Unknown - No feedback yet
  0x00000000, // 0x18c
  0x00000000, // 0x190
  0x00000000, // 0x194
  0x00000000, // 0x198
  0x00000000, // 0x19c
  0x00000000, // 0x1a0
  
  // end?
  0x00000000,  // 0x1a4
};
```

As you can see, this first attempt to figure out an exploitable structure is highly abstract and imprecise. The goal behind this experimental investigation is to clarify the structure and meaning of the instructions/data units in the bitstream, which is the objective of the following sections that evolve alongside the tests and progress.

#### PE Configuration Block Structure

Each Processing Element (PE) in what we assume to be a CGRA, seems to be configured by a block of 6 consecutive 32-bit words, representing 12 x 16-bit configuration units:  
```cpp
// PE Configuration Block? (6 x 32-bit words = 12 x 16-bit units)
0x80000000, // Word 0: Enable flag (bit 31 must be set to activate the PE)
0x00000001, // Word 1: Operation selector (bit 0 = enable basic transform?)
0x00000000, // Word 2: Configuration parameter?
0x00000000, // Word 3: Configuration parameter?
0x00000000, // Word 4: Configuration parameter?
0x00000000, // Word 5: Configuration parameter?
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

### Default Met Values

The following is an attempt to provide an initial interpretation of the data found in the EDRAM dump, which I believe corresponds to a default generic Processing Element.  
```cpp
// Default PE (neutral / inactive configuration)
0x8000, 0x0000, // Word 0 - PE enable (global valid), reserved / unused
0x0001, 0x0007, // Word 1 - ALU control: NOP / bypass, input source: IDLE / invalid?
0x0001, 0x0007, // Word 2 - ALU control: NOP / bypass, input source: IDLE / invalid?
0x0001, 0x0007, // Word 3 - ALU control: NOP / bypass, input source: IDLE / invalid?
0x0002, 0x0000, // Word 4 - Output routing configuration?, unused / default
0x003b, 0x0000, // Word 5 - PE index / local offset / base identifier?
```

Keep in mind that this may be incorrect, yet it is necessary to lay a logical foundation to proceed.  

### The 0x0b4 Offset

The executable block at `0x0b4` can be used as a dst configuration:

```cpp
0x80090000, // 0xb4 // The last 2 bytes specify the dst offset (max 2048 words / 8192 bytes), first bit enables it.
0x0001007f, // 0xb8 // Max dst size minus 1, maximum value is 127?
0x00000000, // 0xbc // Step - 1 during the copy.
0x00000000, // 0xc0 // Step / gap - 1 on dst?
0x00000000, // 0xc4 // msb, possibly for some offset routing?
0x10000000, // 0xc8 // In this configuration, bit 31 or 28 should be active.
```

### Bitstream-Driven Data Transformation in Local Ring Buffers
WIP ...  

#### Bitstream Examples
WIP ...  
