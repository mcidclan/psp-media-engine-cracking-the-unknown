# The Virtual Mobile Engine

## Preface
 
I had started experimenting with the Media Engine to take advantage of additional resources for Voxel rendering projects.

I would not have been able to get started on this topic without the resources available online, whether directly related to the subject or tangentially so.

So, thank you to the pioneers and everyone who worked on or contributed to reversing the PSP, building CFW, and/or exploring Media Engine related topics. Enumerating everyone might take more than an article, but you know who you are.


## Introduction

The first thing I did was to find a way to execute code on the Media Engine with just a few lines of code, and get the ability to exchange/share data between it and the main CPU.

In reality, people had already done the heavy lifting for this. I just had to dig around the topic, learn a bit of MIPS, and keep only the essentials to get started: A software reset to the reset vector, followed by branching out of the exception context into a function where the final code would be executed.

From there, I ran many experiments, which led to the `media-engine-reload` project. Following exchanges with the community and out of necessity, the `me-core-mapper` library was born, upon which the `me-custom-core` library was then built.

More recently, another library came out: `me-safe-task`, which uses new approaches other than writing to the reset vector to run custom tasks on the Media Engine.

Feel free to check out these projects, as these libraries will be used to take advantage of the VME.


## The VME itself

Based on available information at the time, this unit was described as a type of Coarse Grained Reconfigurable Architecture with a 24-bit data width, though this had never been fully confirmed, until now.

And it is in fact both a type of CGRA and a Fine Grained Reconfigurable Architecture at the same time, as you can configure it once from a bitstream, or modify any part of the DataPath without reloading the entire bitstream.

More precisely, we have a Coarse Grained Reconfigurable DSP with a Fine Grained controller extension over the PSP Media Engine.


Understanding this unit housed by the Media Engine, alongside the second MIPS core and the H.264 decoder, came from both reverse engineering of the Media Engine core I carried out in Ghidra, and from numerous trial-and-error tests on a PSP Slim.

These steps did not follow a strict or regular research schedule. Many poorly understood topics were set aside and later revisited as ideas developed over time. That said, it should be seen as a whole, because in the end, everything contributed to getting here.


### The Coarse Grained Bitstream

By luck, during a test, a wrong address passed to the DMAC at `0x440ff000` was producing data transformations over the internal 24-bit ring buffers.

From there, the first attempt was to send various random data, observe the results, and try to isolate which data units were triggering exploitable outputs.

This ended up revealing patterns, providing a first basis toward the discovery of a clearer structure, one that was also recognizable inside dumps of the local eDRAM.

This default uploaded bitstream can be described as coarse, as it is not fully operational, it is simply loaded into the VME via a DMAC transfer, after which the VME waits for explicit data transfers or modifications.

That said, I had no idea why Sony wrote the default bitstream that way, so I started experimenting further with VME processing over the bitstream, and got more concret results once I understood how to configure and program specific DSP processes with it.

Please see [vme-bitstream-v0.3.md](bitstream/vme-bitstream-v0.3.md) for more information.


### The 0x440f8000 VME Fine Grained Controller / DataPath Mapping

I started trying to transfer data using this hardware during the `Media Engine Reload` project. I succeeded in making transfers using it, but many registers behaved oddly, I first thought it was some sort of multiplexer, given the many available sources and destinations, and I got a bit lost with it at the time.

Actually, this is a direct mapping to the internal DataPath of the VME itself, where this register (`0x440f8000`) directly corresponds to the base offset of the bitstream previously uploaded/injected into the VME that become its DataPath. And this, is fire!

That said, we can now understand the purpose of the previous coarse bitstream, the DataPath it defines within the VME, can be updated dynamically through the set of registers exposed by this controller.
 
 
### DSP Capabilities

The VME has DSP capabilities. It exposes 8 main 24-bit ring buffers, 4 primary and 4 additional, all sharing the same base address at `0x44000000`, and each usable as either a source or a destination.

Each buffer is mirrored contiguously in memory with a size of 8192 bytes, since each 24-bit value is stored in a 32-bit word. The mirroring allows the DataPath to read and write across buffer boundaries without explicit wrap-around handling. The format uses 1 sign bit with two's complement fixed-point encoding, leaving 23 bits for the actual data.

Another set of mirrored buffers starts at `0x44020000`, which appears to be one of the routable sources from which the VME can pull data, and the one I used to conduct my tests.

The VME itself appears to operate using relative offsets starting from 0, depending on where the bases are routed.


#### DSP Operations / Instruction Set

Here are some examples of the available DSP operations, the list is non-exhaustive:

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
| `0x00204000` | Multiply-accumulate with shift (MAC) | `(x * k) >> b`                                |


#### DSP Process Element Operations

Process Element (loosely speaking) appears to be composed of 3 distinct blocks, 2 source controls, and one destination. Their usage and configuration are still not fully understood, as they seem to depend on the activation of other configuration registers.  

The following is a list of identified operations or transfer controls that can be configured via a PE:

- Activate
- Offset Start
- Word Count
- Shift Scaling
- Inverted Word Transfer

## Communicating with the VME

It is possible to directly communicate with the VME using the Primary DMAC registers and the dedicated Fine Grained Controller. However, the `me-core-mapper` and `me-core-lib` provide some useful helper functions that make the code easier, lighter, and more readable. It is therefore recommended to use them as much as possible.

### Send The Bitstream

First of all, before being able to write to the VME and related buffers, we need to initialize the hardware. Using the `me-core-lib`, we can simply do:

```cpp
  vmeLibInit();
```

Then we can send our custom bitstream using the following:

```cpp
  vmeLibSendCustomBitstream((void*)bitstream);
```

This will upload the Bitstream to the VME to become the DSP Reconfigurable DataPath.

### Transfer from eDRAM to the 0x44020000 ring buffers

The VME can operate over the buffer ranges activated by the Primary DMAC (`0x44000000` and `0x44020000`). To process data, the simplest configuration found for experimentation is to write raw data directly to the 0x44020000 buffers, which will act as the primary data source. With the configuration explored so far, the `0x44000000` buffers act as the destination, however they can also be used as a source. It is not yet known whether host memory and local eDRAM are also accessible as sources or destination.  

The following will send the content of a buffer to `0x44020000` with a size of 32768 bytes and wait for the transfer to complete:

Then via me-core-mapper
```cpp
  meCoreDMACPrimMemoryToRingBuffer((void*)buffer, 0x8000, 0x2000);
  meCoreDMACPrimWaitTransfertFinish();
```

### Fined Grained Reconfiguration

We can send either an empty or a pre-filled bitstream to the VME, then use the Fine Grained Controller to update a specific part of the DataPath. First, we need to enable the controller using `meCoreBusClockEnableVMECtrl`, or let `vmeLibInit`, as previously seen, handle the entire initialization for us.

It will then be possible to modify any word constituting the DataPath, using the `me-core-lib` macro as demonstrated in the following:

```cpp
  vme_set(VME_DESCRIPTOR_1, 0x00000000);
  vme_set(VME_PE_0_I_SRC, VME_ENABLE | 0x0000);
```

Or directly by using the index of the word in the DataPath:

```cpp
  vme_set(1, 0x00000000);
```

After this, you can re-execute the VME without the need to re-upload the entire bitstream, simply by calling:

```cpp
  vmeLibRefreshProcess();
```

## Required Libraries and Related Work

**Libraries**:  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)
[PSP Media Engine Safe Task](https://github.com/mcidclan/psp-media-engine-safe-task)
[PSP Media Engine Reload](https://github.com/mcidclan/psp-media-engine-reload)  

**Preliminary documents related to the VME Bitstream**:  
- [VME: Bitstream v0.2 - Preliminary Spec](bitstream/vme-bitstream-v0.2.md)  
- [VME: Bitstream v0.1 - Rough Exploration](bitstream/vme-bitstream-v0.1.md)  

## What's Next?

It is said that no one has been able to interpret its "firmware" yet. I guess we can now say that someone has, at least partially, but that is no reason to stop here. Significant work remains to be done and more concrete sample code will follow, along with improvements to the `me-core-mapper` library to simplify access to the VME, whether you are using `me-custom-core` or `me-safe-task`.

*m-c/d*
