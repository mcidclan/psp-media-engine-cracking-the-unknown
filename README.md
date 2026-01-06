## PSP Media Engine Cracking The Unknown

This project is an attempt to shed light on the Virtual Mobile Engine (VME) present in Sony's PSP, as well as the H.264 decoder, both available on the Media Engine side, by digging into the surrounding components and elements such as the local DMACs and VLD unit, the known specialized instructions like those reusing the LDL and SDL opcodes, and what appears to be a bitstream sent to the VME.


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


### Access Patterns
...

#### Switching Between Access Patterns
...

#### Forcing Access Enablement
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


## Disclamer
This project is provided for educational and research purposes only. This project and code are provided as-is without warranty. Users assume full responsibility for any implementation or consequences. Use at your own discretion and risk

## Related work
[PSP Media Engine Reload](https://github.com/mcidclan/psp-media-engine-reload)  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  

*m-c/d*
