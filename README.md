## PSP Media Engine Cracking The Unknown

This project is an attempt to shed light on the Virtual Mobile Engine (VME) present in Sony's PSP, as well as the H.264 decoder, both available on the Media Engine side, by digging into the surrounding components and elements such as the local DMACs and VLD unit, the known specialized instructions like those reusing the LDL and SDL opcodes, and what appears to be a bitstream sent to the VME.


## Targeted Components / Areas of Interest

The components of interest in this experimental investigation are primarily the VME and the H.264 decoder, both of which are hosted within the Media Engine. According to information provided by Sony, the VME appears to be a type of CGRA.  


## LDL/SDL: Move-To and Move-From Vendor Specific Instructions

Those instructions are encoded as follows in MIPS64:

| opcode (6 bits) | base (5 bits) | rt (5 bits) | offset (16 bits) |
|-----------------|---------------|-------------|-----------------|
| 31-26           | 25-21         | 20-16       | 15-0            |


and are most likely used exclusively in the media engine core, with the `a3 ($7)` register as `rt` as follows:  
```asm
sdl src, offset(a3)
ldl dst, offset(a3)
```

However, with naive usage of these instructions, `sdl` followed by `ldl` on `a3` will lead to a zero value in `dst`. In any case, this proves that `ldl` affects the `dst` register.

If the usage of `sdl` + `ldl` always leads to zero using `a3` with our configuration, then one of the first directions to take was to increment `a3`. Unfortunately, in early tests this led nowhere. The next step was to try another register, like `a2`, which led to the same result, then a classical temporary general-purpose register like `t0`, which finally gave different but unstable results.  

### Unpredictability after sleep or reboot

```asm
.set push
.set noreorder
.set volatile
.set mips64
.set noat

li t0, 0
li t1, 0xffffffff
sdl t1, 0(t0)
ldl t2, 0(t0)

.set pop
```

With the previous code, `t2` will result in either a `zero` value or `0x7fff`. Actually, some hardware configuration seems to be affected after hardware sleep or hardware reboot. Note that it is not affected by a code reboot.  

The access pattern to the target hardware registers or memory appears to not always be the same and may be identified (possibly just a coincidence) by the value given by the `0xBC400018` hardware profiler register, which is the one for Coprocessor stalled cycles on the System Control side.  

Additionally, in this code, the value passed to `t0` appears to be irrelevant, only the offset matters. As shown, `ldl` returns the maximun of the positive value of a signed 16-bit data item.

### Banks / Access Context

The first conclusion, as a starting point regardless of the usage of the `rt` register, is that it should not be used like a classical MIPS register with `ldl` and `sdl`. Rather, it behaves more like a set of Banks or an Access Context.  

Currently, three families of Banks are identified:  

- $0  
- $1, $2, $3  
- $4, $5, $6, $7  
- $8 to $31  

These Banks act differently, and we will examine some of them more closely in the next sections.  

#### Banks Behaviors

* Bank $0 seems to allow resetting the patterns to a starting point.
* Banks $1, $2, and $3 allow switching between access patterns.
* Banks `$4, $5, $6, and $7` are probably of the same kind, with `$7` (register `a3`) being used in the firmware code. According to the firmware, these banks likely target internal memory or registers. However, attempting to use them directly in the same way as observed in the Media Engine firmware code has not produced any observable results so far.
* Banks `$8` to `$31` appear to hold actual data that can be read and written, and this data **persists across reset and code reboot**, suggesting that these banks are likely tied to the CGRA (VME) rather than the H.264 decoder.

### Access Patterns

By default, access patterns change after hardware sleep or reset. The following are just observations, they are provided here as information to aid understanding. This is still a work in progress (WIP).  

```
// valid offsets over bank $8 (t0)

// xx, 01, 02, xx, xx, 05, 06, xx, xx, 09, 0a, xx, xx, 0d, 0e, xx, xx, 11, 12, xx, xx, 15, 16, xx, xx, ... n

// xx, 01, xx, 03, xx, 05, xx, 07, xx, 09, xx, 0b, xx, 0d, xx, 0f, xx, 11, xx, 13, xx, 15, xx, 17... n      
// xx, xx, 02, xx, xx, xx, 06, xx, xx, xx, 0a, xx, xx, xx, 0e, xx, xx, xx, 12, xx, xx, xx, 16... n
// xx, xx, xx, 03, xx, xx, xx, 07, xx, xx, xx, 0b, xx, xx, xx, 0f, xx, xx, xx, 13, xx, xx, xx, 17... n

// 00, 01, xx, xx, 04, 05, xx, xx, 08, 09,   ...0x1d, ... n
// 00, 01, 02, xx, 04, 05, 06, xx, 08, 09, 0a, xx, 0c, 0d, 0e, xx, 10, 11, 12, xx, 14, 15, 16 ... n
```

As previously mentioned, by default these patterns seem to always correspond to specific values given by the hardware register `0xBC400018` after reboot or sleep. It can be noted that any value ending with `4` (e.g., `0x8404`) or `8` (e.g., `0x8518`) results in completely disabled access, meaning any attempt to write to the target offset will have no effect and `ldl` will always return `0`.


#### Switching Between Access Patterns

It has been observed that the banks `$1, $2, and $3` allow switching between access patterns. This can be done by targeting one of their offsets using `sdl` or `ldl` as follows:

```asm
.set push
.set noreorder
.set volatile
.set mips64
.set noat

sdl t0, 0($1)
// or
ldl t0, 0($1)

.set pop
```

Make sure to use `.set noat`, as using `$1` could trigger compiler optimizations or adjustments that are not compatible with our intended hardware usage.

Targeting between two banks for example, $1 and $2, $1 and $3, or $2 and $3, will switch between two access patterns, depending on the pattern the hardware initially landed on after sleep or reboot. The initial pattern is undefined and seems random, so behavior can vary. Switching between all three banks at once appears to completely disable access, meaning that reads and writes will have no effect.

#### Debugging

As it can be difficult to obtain the same pattern after a hardware sleep or reboot, an assembly file containing a helper function has been added to this repository. It is a tool written and used during this experimental investigation.


### Forcing Access and Activating Patterns

It has been found that forcing access and thus forcing active patterns can be achieved by targeting negative offsets of the `$0`, `$1`, `$2`, and `$3` banks.  

This can simply be done, for example, as follows:  
```asm
.set push
.set noreorder
.set volatile
.set mips64
.set noat

li t1, 1
sdl t1, -1($1)

.set pop
```

This will ensure that a pattern is active, but at this point we cannot yet be sure of the initial pattern, so we need something to fix it. This can be achieved using `$0` to `$3` just before accessing the negative offset.

#### Switching Access Patterns After Forced Activation

As you can understand, these processes are still unclear, so you are invited to conduct your own tests, and if you wish, come here to add your observations.

For the moment, and as an example, here is how you can reach a specific pattern:
```asm
.set push
.set noreorder
.set volatile
.set mips64
.set noat

// reset
li $t1, 0
sdl $t1, 0($0)

// switch to 00, xx, xx, xx, 04, xx, xx, xx, 08, xx, ... n pattern
sdl $t1, 0($1)
sdl $t1, 0($2)
sdl $t1, 0($3)

// force enable
li $t1, 1
sdl $t1, -1($0)

//
li $t1, 3
sdl $t1, 0x04($8)
ldl $t0, 0x04($8) // t0 gives 3

.set pop
```

Here are some other observed patterns (WIP):  

```
// 00, xx, xx, xx, 04, xx, xx, xx, 08, xx, ... n (through offset -1 on $0        after setting 0 on banks $0,$1,$2,$3)
// 00, 01, xx, xx, 04, 05, xx, xx, 08, 09, ... n (through offset -1 on $0 and $1 after setting 0 on banks $0,$1,$2,$3)
// 00, xx, 02, xx, 04, xx, 06, xx, 08, xx, ... n (through offset -1 on $0 and $2 after setting 0 on banks $0,$1,$2,$3)
// 00, xx, xx, 03, 04, xx, xx, 07, 08, xx, ... n (through offset -1 on $0 and $3 after setting 0 on banks $0,$1,$2,$3)
```

### Sending and Retrieving Data

We can send and retrieve data over all activated offsets, or over the offset range -1 to -32768 (-0x8000), with limitations discussed in the following section:

#### Using negative offsets

It is interesting to note that (at least by default) sending and retrieving data over negative offsets appears to actually target the same registers or memory area, and thus this can be verified as follows:
```asm
.set push
.set noreorder
.set volatile
.set mips64
.set noat

li $7, 0x100 // This is not necessary, just as proof.
li $t1, 0x123
sdl $t1, -1($0)
ldl $t0, -1($7)

.set pop
```

### How Was This Knowledge Discovered ?

Since these instructions were undocumented and the target hardware was unknown and still is, the investigation was carried out through iterative experimental testing cycles, each starting from a distinct hypothesis. Hypotheses that did not yield exploitable results were then eliminated.  

Note: given the persistence of the data after code reboot, those instructions may not be related to the H.264 decoder, or could be shared with the VME or across multiple hardware components.  


### Important Notes on Current Findings

The results from this part of our experimental investigation currently allow usage that is completely outside of what Sony appears to be doing with the `ldl` and `sdl` instructions in the Media Engine firmware. We are therefore dealing with unknown use cases, which for now are only useful for those who wish to investigate further, or potentially for using the accessible registers/memory to store persistent variables, although limited to signed 16-bit values. The approach used takes hardware feedback into account to expand our understanding of what we're dealing with.  

---

## VME Bitstream

This part of our experimental investigation is an attempt to figure out how the Virtual Mobile Engine could be programmed, and whether what appears to be a bitstream sent somewhere is the one related to the VME or something else.

### Sending via DMAC

#### Minimal configuration
```cpp
  hw(0x440ff004) = 0x10; // Routing config ?
  hw(0x440ff010) = 0x40000000 | (u32Me)&bitstream; // Channel1 src (host memory or me edram)
  hw(0x440ff008) = 0x1c; // Control
  
  meCoreDMACPrimMuxWaitStatus(0x200); // Wait for the transfer to finish
```

### Revealing the unknown

By luck, during a test, a wrong address passed to the DMAC with the previous configuration was producing data transformation/generation over the internal 24-bit buffers.  

From there, the first attempt was to send different random data, observe the result, and try to isolate which data units were triggering exploitable results.  

This ended up revealing recognizable memory patterns that followed an exploitable structure, which was actually findable in the EDRAM dump.  

Please see tools/bitstream/edram-dump for the dumping sample.  

#### Default bitstream

It is important to note that the bitstream or data found in the EDRAM does not generate changes over the internal buffers as is, but sending it with our DMAC minimal configuration makes it pass through the following wait status:  
```cpp
meCoreDMACPrimMuxWaitStatus(0x800); 
```
which I think could be related to waiting for the VME to be in a dormant state.  

#### The emerging bitstream structure
WIP ...  

### Bitstream-Driven Data Transformation in Transfer Buffers

WIP ...  

## Testing Context

It is important to note that these early tests have so far been conducted on a PSP Slim running CFW 6.61 Pro-C.  

Iterations were performed through PSPLINK in order to reduce time consumption and simplify the testing process. However, note that when using PSPLINK, some initial states could differ from a normal eboot launch, for example when testing the VME bitstream.  

## Disclamer
This project is provided for educational and research purposes only. This project and code are provided as-is without warranty. Users assume full responsibility for any implementation or consequences. Use at your own discretion and risk

## Related work
[PSP Media Engine Reload](https://github.com/mcidclan/psp-media-engine-reload)  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  

*m-c/d*
