## LDL/SDL (move to, move from) pattern analysis
```
// Patterns tested over bank $8

// | -------------------------------------------------------------------------------------------------------------------------------- |
// | 0xBC400018  | Pattern                                        | Observed Behavior                                                 |
// | -------------------------------------------------------------------------------------------------------------------------------- |
// | 0x2080      | xx, 01, 02, xx, xx, 05, 06, xx, xx, 09, 0a ... | not persistent, all routed to the same registers/data             |
// | 0xca04      |                                                | disabled?                                                         |
// | 0x4010      | 00, 01, xx, xx, 04, 05, xx, xx, 08, 09, xx ... | persistent?, routed to independent registers/data                 |
// | 0x8518      |                                                | disabled?                                                         |
// | 0x4000      | 00, 01, xx, xx, 04, 05, xx, xx, 08, 09, xx ... | same as 0x4010?                                                   |
// | 0x1060      | xx, 01, xx, 03, xx, 05, xx, 07, xx, 09, xx ... | not persistent, routed to the same registers/data                 |
// | 0x0518      |                                                | disabled?                                                         |
// | 0x8804      |                                                | disabled?                                                         |
// | 0x1040      | xx, 01, xx, 03, xx, 05, xx, 07, xx, 09, xx ... | not persistent, alternated routing? same data every other access, |
// |             |                                                | otherwise previous access erases next one?                        |
// | 0x2082      | xx, 01, 02, 03, xx, 05, 06, 07, xx, 09, 0a ... | persistent?, routed to independent registers/data                 |
// | 0x0418      |                                                | disabled?                                                         |
// | 0x0504      |                                                | disabled?                                                         |
// | 0x1418      |                                                | disabled?                                                         |
// | 0x8a04      |                                                | disabled?                                                         |
// | 0x4011      | 00, 01, xx, xx, 04, 05, xx, xx, 08, 09, xx ... | not persistent, routed to independent registers/data              |

// WIP ...
```
