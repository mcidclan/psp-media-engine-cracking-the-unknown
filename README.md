## PSP Media Engine Cracking The Unknown

This project is an attempt to shed light on the Virtual Mobile Engine (VME) present in Sony's PSP, as well as the H.264 decoder, both available on the Media Engine side, by digging into the surrounding components and elements such as the local DMACs and VLD unit, the known specialized instructions like those reusing the LDL and SDL opcodes, and what appears to be a bitstream sent to the VME.


## Targeted Components / Areas of Interest

The components of interest in this study are primarily the VME, which, according to information provided by Sony, appears to be a type of CGRA, as well as the H.264 decoder. Both are hosted within the Media Engine.  


## LDL/SDL: Move-To and Move-From Vendor Specific Instructions

Those instructions are encoded as follows in MIPS64:

| opcode (6 bits) | base (5 bits) | rt (5 bits) | offset (16 bits) |
|-----------------|---------------|-------------|-----------------|
| 31-26           | 25-21         | 20-16       | 15-0            |


and are most likely used exclusively in the media engine core, with the `a3 ($7)` register as `rt` as follows:  
```
sdl src, offset(a3)
ldl dst, offset(a3)
```

However, with naive usage of these instructions, `sdl` followed by `ldl` on `a3` will lead to a zero value in `dst`. In any case, this proves that `ldl` affects the `dst` register.

If the usage of `sdl` + `ldl` always leads to zero using `a3` with our configuration, then one of the first directions to take was to increment `a3`. Unfortunately, in early tests this led nowhere. The next step was to try another register, like `a2`, which led to the same result, then a classical temporary general-purpose register like `t0`, which finally gave different but unstable results.  

### Unpredictability after sleep or reboot

```
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
* Banks `$4, $5, $6, and $7` are probably of the same kind, with `$7` (register `a3`) being used in the firmware code. According to the code, this bank likely target internal memory or registers, but attempts to directly read/write them manually have not produced observable results yet.  
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
````

Make sure to use `.set noat`, as using `$1` could trigger compiler optimizations or adjustments that are not compatible with our intended hardware usage.

Targeting between two banks for example, $1 and $2, $1 and $3, or $2 and $3, will switch between two access patterns, depending on the pattern the hardware initially landed on after sleep or reboot. The initial pattern is undefined and seems random, so behavior can vary. Switching between all three banks at once appears to completely disable access, meaning that reads and writes will have no effect.


### Forcing Access Enablement
...

### Sending and Retrieving Data
...

### How Was This Knowledge Discovered ?

Since these instructions were undocumented and the target hardware was unknown and still is, the investigation was carried out through iterative experimental testing cycles, each starting from a distinct hypothesis. Hypotheses that did not yield exploitable results were then eliminated.  

Note: given the persistence of the data after code reboot, those instructions may not be related to the H.264 decoder, or could be shared with the VME or across multiple hardware components.  


## VME Bitstream
...

### Sending via DMAC
...

### Bitstream-Driven Data Transformation in Transfer Buffers
...

## Testing Context

It is important to note that these early tests have so far been conducted on a PSP Slim running CFW 6.61 Pro-C.  

Iterations were performed through PSPLINK in order to reduce time consumption and simplify the testing process. However, note that when using PSPLINK, some initial states could differ from a normal eboot launch, for example when testing the VME bitstream.  

## Disclamer
This project is provided for educational and research purposes only. This project and code are provided as-is without warranty. Users assume full responsibility for any implementation or consequences. Use at your own discretion and risk

## Related work
[PSP Media Engine Reload](https://github.com/mcidclan/psp-media-engine-reload)  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  

*m-c/d*
