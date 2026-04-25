## PSP Media Engine Cracking The Unknown

This project is an attempt to shed light on the Virtual Mobile Engine (VME) present in Sony's PSP, as well as the H.264 decoder, both available on the Media Engine side, by digging into the surrounding components and elements such as the local DMACs and VLD unit, the known specialized instructions like those reusing the LDL and SDL opcodes, and what appears to be a bitstream sent via DMAC to the VME or possibly another component.


## Targeted Components / Areas of Interest

The components of interest in this experimental investigation are primarily the VME and the H.264 decoder, both of which are hosted within the Media Engine. According to information we can find on internet, the VME appears to be a type of CGRA.  

## VME Bitstream

- [VME: Bitstream v0.1](bitstream/vme-bitstream-v0.1.md)  
**older versions**:  
- [VME: Bitstream v0.1](bitstream/vme-bitstream-v0.1.md)  

## VME MoveTo and MoveFrom

- [VME: MoveTo, MoveFrom](mt-mf-vme.md)

## Syscall Tables

- [Syscall Table: Slim+ (t2img.img)](media-engine-t2img.syscall-table.txt)

## Testing Context

It is important to note that these early tests have so far been conducted on a PSP Slim running CFW 6.61 Pro-C.  

Iterations were performed through PSPLINK in order to reduce time consumption and simplify the testing process. However, note that when using PSPLINK, some initial states could differ from a normal eboot launch, for example when testing the VME bitstream.  

## Disclamer
This project is provided for educational and research purposes only. This project and code are provided as-is without warranty. Users assume full responsibility for any implementation or consequences. Use at your own discretion and risk

## Related work
[PSP Media Engine Reload](https://github.com/mcidclan/psp-media-engine-reload)  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  

*m-c/d*
