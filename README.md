## PSP Media Engine Cracking The Unknown

This project is an attempt to shed light on the Virtual Mobile Engine (VME) present in Sony's PSP, as well as the H.264 decoder, both available on the Media Engine side, by digging into the surrounding components and elements such as the local DMACs and VLD unit, the known specialized instructions like those reusing the LDL and SDL opcodes, and what appears to be a bitstream sent via DMAC to the VME or possibly another component.


## Targeted Components / Areas of Interest

The components of interest in this experimental investigation are primarily the VME and the H.264 decoder, both of which are hosted within the Media Engine. According to information we can find on internet, the VME appears to be a type of CGRA.  

## The VME Itself

- Cracking the unknown around [The PSP Virtual Mobile Engine](the-psp-virtual-mobile-engine/the-virtual-mobile-engine.md)
- Documentation on the VME [VME Documentation](the-psp-virtual-mobile-engine/the-vme-bitstream-and-datapath.md)  
  *Including Opcodes, Processing Elements, Bitstream/Context, and DataPath.*

## Special Move To and From Instructions

- [VME: MoveTo, MoveFrom v0.1](mt-mf-vme.md)

## Syscall Tables

- [Syscall Table: Slim+ (t2img.img)](media-engine-t2img.syscall-table.txt)

## Other Observations

- [Primary DMAC/ Main VME DMAC](0x440ff000.md)

## Testing Context

The tests have been conducted on a PSP Slim running CFW 6.61 Pro-C. Iterations were performed through PSPLINK in order to reduce time consumption and simplify the testing process. However, note that when using PSPLINK, some initial states could differ from a normal eboot launch, for example when testing the VME bitstream.  

## Contribution Guidelines

### AI-assisted development

AI tools may be used as development aids. However, the following rules apply strictly:

* All commits must be authored by a human contributor (pseudonyms are perfectly acceptable).
* The commit history must not contain any AI attribution as author or co-author.
* Contributors must fully review, understand, and validate all submitted code before opening a pull request.
* Contributors are expected to be able to explain and justify their changes during reviews.
* The contributor is responsible for ensuring that their code or changes do not break existing functionality, integrations, dependencies, documentation consistency, APIs, build processes, tests, or the overall behavior and technical integrity of the project.
*In short: AI can assist, but humans must retain full ownership of the work.*

Pull requests that include AI attribution in commits, or that are not clearly understood and validated by the contributor, will be rejected.

### License compatibility

All code submitted to this repository must be compatible with the MIT License. Dependencies or code snippets under more restrictive licenses (e.g. GPL, LGPL, proprietary) are not accepted. Contributors are responsible for verifying that any third-party code they include is under a permissive license granting at least the same level of freedom as MIT.

## Disclamer
This project is provided for educational and research purposes only. This project and code are provided as-is without warranty. Users assume full responsibility for any implementation or consequences. Use at your own discretion and risk

## Related work

[PSP Media Engine Safe Task + MIST](https://github.com/mcidclan/psp-media-engine-safe-task)  
[PSP Media Engine Custom Core](https://github.com/mcidclan/psp-media-engine-custom-core)  
[PSP Media Engine Reload](https://github.com/mcidclan/psp-media-engine-reload)  

*m-c/d*
