## LDL/SDL (move to, move from) pattern analysis

```
// Patterns tested over bank $8

// | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
// | 0xBC400018  | Pattern                                        | Observed Behavior                                                                                            |
// | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
// | 0x1040      | **, 01, **, 03, **, 05, **, 07, **, 09, ** ... | not persistent, alternated routing? same data every other access, otherwise previous access erases next one? |
// | 0x1060      | **, 01, **, 03, **, 05, **, 07, **, 09, ** ... | not persistent, routed to the same registers/data                                                            |
// | 0x2080      | **, 01, 02, **, **, 05, 06, **, **, 09, 0a ... | not persistent, all routed to the same registers/data                                                        |
// | 0x2082      | **, 01, 02, 03, **, 05, 06, 07, **, 09, 0a ... | persistent?, routed to independent registers/data                                                            |
// | 0x4000      | 00, 01, **, **, 04, 05, **, **, 08, 09, ** ... | same as 0x4010?                                                                                              |
// | 0x4001      | 00, 01, **, **, 04, 05, **, **, 08, 09, ** ... | not persistent, routed to independent registers/data                                                         |                                                                                                                                                                                 |
// | 0x4010      | 00, 01, **, **, 04, 05, **, **, 08, 09, ** ... | persistent?, routed to independent registers/data                                                            |
// | 0x4011      | 00, 01, **, **, 04, 05, **, **, 08, 09, ** ... | not persistent, routed to independent registers/data                                                         |

// | 0x18000601  | **, 01, **, **, **, 05, **, **, **, 09, ** ... | persistent, routed to the same registers/data                                                                |
// | 0x24008802  | **, 01, 02, **, **, 05, 06, **, **, 09, 0a ... | not persistent, routed to independent registers/data                                                         |
// | 0x4a001100  | **, **, 02, 03, **, **, 06, 07, **, **, 0a ... | not persistent, routed to the same registers/data                                                         |

// | 0x1504      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x0418      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x0504      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x0518      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x1418      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x8804      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x8a04      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0x8518      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |
// | 0xca04      | **, **, **, **, **, **, **, **, **, **, ** ... | disabled?                                                                                                    |

// WIP ...
```

// 0x2080, 0x2082 switched?

Simple code example for pattern testing:  
```asm
.text

.globl getLdlSdlDebug
.ent   getLdlSdlDebug

getLdlSdlDebug:
  .set push
  .set noreorder
  .set volatile
  .set mips64
  .set noat
  
  li   $t1, 0x5678
  sdl  $t1, 0x00($8) // adjust offset here to find writable slots
    
  // block for testing if slots are independent
  // li   $t1, 0x1234
  // sdl  $t1, 0x01($8) // use a different active offset to test slot independence
  
  // load data from hardware to $t1
  ldl  $t1, 0x00($8)
  sync

  move $v0, $t1

  .set pop
  jr   $ra
  nop

  .end   getLdlSdlDebug
```
