.text
  
.globl meLibLdlSdlDebug
.ent   meLibLdlSdlDebug
meLibLdlSdlDebug:
  .set push
  .set noreorder
  .set volatile
  .set mips64
  .set noat
  
  // move $t0, $a2
  // move $t1, $a3
  
  li $t0, 0xffffffff
  li $t1, 0
  
  sdl $t0, 0x0($t1)
  sdl $t0, 0x1($t1)
  sdl $t0, 0x2($t1)
  sdl $t0, 0x3($t1)
  sdl $t0, 0x4($t1)
  sdl $t0, 0x5($t1)
  sdl $t0, 0x6($t1)
  sdl $t0, 0x7($t1)
  sdl $t0, 0x8($t1)
  sdl $t0, 0x9($t1)
  sdl $t0, 0xa($t1)
  sdl $t0, 0xb($t1)
  sdl $t0, 0xc($t1)
  sdl $t0, 0xd($t1)
  sdl $t0, 0xe($t1)
  sdl $t0, 0xf($t1)
  sdl $t0, 0x10($t1)
  sdl $t0, 0x11($t1)
  sdl $t0, 0x12($t1)
  sdl $t0, 0x13($t1)
  sdl $t0, 0x14($t1)
  sdl $t0, 0x15($t1)
  sdl $t0, 0x16($t1)
  sdl $t0, 0x17($t1)
  sdl $t0, 0x18($t1)
  sdl $t0, 0x19($t1)
  sdl $t0, 0x1a($t1)
  sdl $t0, 0x1b($t1)
  sdl $t0, 0x1c($t1)
  sdl $t0, 0x1d($t1)
  sdl $t0, 0x1e($t1)
  sdl $t0, 0x1f($t1)
  sdl $t0, 0x20($t1)
  sdl $t0, 0x21($t1)
  sdl $t0, 0x22($t1)
  sdl $t0, 0x23($t1)
  sdl $t0, 0x24($t1)
  sdl $t0, 0x25($t1)
  sdl $t0, 0x26($t1)
  sdl $t0, 0x27($t1)
  sdl $t0, 0x28($t1)
  sdl $t0, 0x29($t1)
  sdl $t0, 0x2a($t1)
  sdl $t0, 0x2b($t1)
  sdl $t0, 0x2c($t1)
  sdl $t0, 0x2d($t1)
  sdl $t0, 0x2e($t1)
  sdl $t0, 0x2f($t1)
  sdl $t0, 0x30($t1)
  sdl $t0, 0x31($t1)
  sdl $t0, 0x32($t1)
  sdl $t0, 0x33($t1)
  sdl $t0, 0x34($t1)
  sdl $t0, 0x35($t1)
  sdl $t0, 0x36($t1)
  sdl $t0, 0x37($t1)
  sdl $t0, 0x38($t1)
  sdl $t0, 0x39($t1)
  sdl $t0, 0x3a($t1)
  sdl $t0, 0x3b($t1)
  sdl $t0, 0x3c($t1)
  sdl $t0, 0x3d($t1)
  sdl $t0, 0x3e($t1)
  sdl $t0, 0x3f($t1)
  sdl $t0, 0x40($t1)
  sdl $t0, 0x41($t1)
  sdl $t0, 0x42($t1)
  sdl $t0, 0x43($t1)
  sdl $t0, 0x44($t1)
  sdl $t0, 0x45($t1)
  sdl $t0, 0x46($t1)
  sdl $t0, 0x47($t1)
  sdl $t0, 0x48($t1)
  sdl $t0, 0x49($t1)
  sdl $t0, 0x4a($t1)
  sdl $t0, 0x4b($t1)
  sdl $t0, 0x4c($t1)
  sdl $t0, 0x4d($t1)
  sdl $t0, 0x4e($t1)
  sdl $t0, 0x4f($t1)
  sdl $t0, 0x50($t1)
  sdl $t0, 0x51($t1)
  sdl $t0, 0x52($t1)
  sdl $t0, 0x53($t1)
  sdl $t0, 0x54($t1)
  sdl $t0, 0x55($t1)
  sdl $t0, 0x56($t1)
  sdl $t0, 0x57($t1)
  sdl $t0, 0x58($t1)
  sdl $t0, 0x59($t1)
  sdl $t0, 0x5a($t1)
  sdl $t0, 0x5b($t1)
  sdl $t0, 0x5c($t1)
  sdl $t0, 0x5d($t1)
  sdl $t0, 0x5e($t1)
  sdl $t0, 0x5f($t1)
  sdl $t0, 0x60($t1)
  sdl $t0, 0x61($t1)
  sdl $t0, 0x62($t1)
  sdl $t0, 0x63($t1)
  sdl $t0, 0x64($t1)
  sdl $t0, 0x65($t1)
  sdl $t0, 0x66($t1)
  sdl $t0, 0x67($t1)
  sdl $t0, 0x68($t1)
  sdl $t0, 0x69($t1)
  sdl $t0, 0x6a($t1)
  sdl $t0, 0x6b($t1)
  sdl $t0, 0x6c($t1)
  sdl $t0, 0x6d($t1)
  sdl $t0, 0x6e($t1)
  sdl $t0, 0x6f($t1)
  sdl $t0, 0x70($t1)
  sdl $t0, 0x71($t1)
  sdl $t0, 0x72($t1)
  sdl $t0, 0x73($t1)
  sdl $t0, 0x74($t1)
  sdl $t0, 0x75($t1)
  sdl $t0, 0x76($t1)
  sdl $t0, 0x77($t1)
  sdl $t0, 0x78($t1)
  sdl $t0, 0x79($t1)
  sdl $t0, 0x7a($t1)
  sdl $t0, 0x7b($t1)
  sdl $t0, 0x7c($t1)
  sdl $t0, 0x7d($t1)
  sdl $t0, 0x7e($t1)
  sdl $t0, 0x7f($t1)
  sdl $t0, 0x80($t1)
  sdl $t0, 0x81($t1)
  sdl $t0, 0x82($t1)
  sdl $t0, 0x83($t1)
  sdl $t0, 0x84($t1)
  sdl $t0, 0x85($t1)
  sdl $t0, 0x86($t1)
  sdl $t0, 0x87($t1)
  sdl $t0, 0x88($t1)
  sdl $t0, 0x89($t1)
  sdl $t0, 0x8a($t1)
  sdl $t0, 0x8b($t1)
  sdl $t0, 0x8c($t1)
  sdl $t0, 0x8d($t1)
  sdl $t0, 0x8e($t1)
  sdl $t0, 0x8f($t1)
  sdl $t0, 0x90($t1)
  sdl $t0, 0x91($t1)
  sdl $t0, 0x92($t1)
  sdl $t0, 0x93($t1)
  sdl $t0, 0x94($t1)
  sdl $t0, 0x95($t1)
  sdl $t0, 0x96($t1)
  sdl $t0, 0x97($t1)
  sdl $t0, 0x98($t1)
  sdl $t0, 0x99($t1)
  sdl $t0, 0x9a($t1)
  sdl $t0, 0x9b($t1)
  sdl $t0, 0x9c($t1)
  sdl $t0, 0x9d($t1)
  sdl $t0, 0x9e($t1)
  sdl $t0, 0x9f($t1)
  sdl $t0, 0xa0($t1)
  sdl $t0, 0xa1($t1)
  sdl $t0, 0xa2($t1)
  sdl $t0, 0xa3($t1)
  sdl $t0, 0xa4($t1)
  sdl $t0, 0xa5($t1)
  sdl $t0, 0xa6($t1)
  sdl $t0, 0xa7($t1)
  sdl $t0, 0xa8($t1)
  sdl $t0, 0xa9($t1)
  sdl $t0, 0xaa($t1)
  sdl $t0, 0xab($t1)
  sdl $t0, 0xac($t1)
  sdl $t0, 0xad($t1)
  sdl $t0, 0xae($t1)
  sdl $t0, 0xaf($t1)
  sdl $t0, 0xb0($t1)
  sdl $t0, 0xb1($t1)
  sdl $t0, 0xb2($t1)
  sdl $t0, 0xb3($t1)
  sdl $t0, 0xb4($t1)
  sdl $t0, 0xb5($t1)
  sdl $t0, 0xb6($t1)
  sdl $t0, 0xb7($t1)
  sdl $t0, 0xb8($t1)
  sdl $t0, 0xb9($t1)
  sdl $t0, 0xba($t1)
  sdl $t0, 0xbb($t1)
  sdl $t0, 0xbc($t1)
  sdl $t0, 0xbd($t1)
  sdl $t0, 0xbe($t1)
  sdl $t0, 0xbf($t1)
  sdl $t0, 0xc0($t1)
  sdl $t0, 0xc1($t1)
  sdl $t0, 0xc2($t1)
  sdl $t0, 0xc3($t1)
  sdl $t0, 0xc4($t1)
  sdl $t0, 0xc5($t1)
  sdl $t0, 0xc6($t1)
  sdl $t0, 0xc7($t1)
  sdl $t0, 0xc8($t1)
  sdl $t0, 0xc9($t1)
  sdl $t0, 0xca($t1)
  sdl $t0, 0xcb($t1)
  sdl $t0, 0xcc($t1)
  sdl $t0, 0xcd($t1)
  sdl $t0, 0xce($t1)
  sdl $t0, 0xcf($t1)
  sdl $t0, 0xd0($t1)
  sdl $t0, 0xd1($t1)
  sdl $t0, 0xd2($t1)
  sdl $t0, 0xd3($t1)
  sdl $t0, 0xd4($t1)
  sdl $t0, 0xd5($t1)
  sdl $t0, 0xd6($t1)
  sdl $t0, 0xd7($t1)
  sdl $t0, 0xd8($t1)
  sdl $t0, 0xd9($t1)
  sdl $t0, 0xda($t1)
  sdl $t0, 0xdb($t1)
  sdl $t0, 0xdc($t1)
  sdl $t0, 0xdd($t1)
  sdl $t0, 0xde($t1)
  sdl $t0, 0xdf($t1)
  sdl $t0, 0xe0($t1)
  sdl $t0, 0xe1($t1)
  sdl $t0, 0xe2($t1)
  sdl $t0, 0xe3($t1)
  sdl $t0, 0xe4($t1)
  sdl $t0, 0xe5($t1)
  sdl $t0, 0xe6($t1)
  sdl $t0, 0xe7($t1)
  sdl $t0, 0xe8($t1)
  sdl $t0, 0xe9($t1)
  sdl $t0, 0xea($t1)
  sdl $t0, 0xeb($t1)
  sdl $t0, 0xec($t1)
  sdl $t0, 0xed($t1)
  sdl $t0, 0xee($t1)
  sdl $t0, 0xef($t1)
  sdl $t0, 0xf0($t1)
  sdl $t0, 0xf1($t1)
  sdl $t0, 0xf2($t1)
  sdl $t0, 0xf3($t1)
  sdl $t0, 0xf4($t1)
  sdl $t0, 0xf5($t1)
  sdl $t0, 0xf6($t1)
  sdl $t0, 0xf7($t1)
  sdl $t0, 0xf8($t1)
  sdl $t0, 0xf9($t1)
  sdl $t0, 0xfa($t1)
  sdl $t0, 0xfb($t1)
  sdl $t0, 0xfc($t1)
  sdl $t0, 0xfd($t1)
  sdl $t0, 0xfe($t1)
  sdl $t0, 0xff($t1)
  sync

  sdl $t0, 0x100($t1)
  sdl $t0, 0x101($t1)
  sdl $t0, 0x102($t1)
  sdl $t0, 0x103($t1)
  sdl $t0, 0x104($t1)
  sdl $t0, 0x105($t1)
  sdl $t0, 0x106($t1)
  sdl $t0, 0x107($t1)
  sdl $t0, 0x108($t1)
  sdl $t0, 0x109($t1)
  sdl $t0, 0x10a($t1)
  sdl $t0, 0x10b($t1)
  sdl $t0, 0x10c($t1)
  sdl $t0, 0x10d($t1)
  sdl $t0, 0x10e($t1)
  sdl $t0, 0x10f($t1)
  sdl $t0, 0x110($t1)
  sdl $t0, 0x111($t1)
  sdl $t0, 0x112($t1)
  sdl $t0, 0x113($t1)
  sdl $t0, 0x114($t1)
  sdl $t0, 0x115($t1)
  sdl $t0, 0x116($t1)
  sdl $t0, 0x117($t1)
  sdl $t0, 0x118($t1)
  sdl $t0, 0x119($t1)
  sdl $t0, 0x11a($t1)
  sdl $t0, 0x11b($t1)
  sdl $t0, 0x11c($t1)
  sdl $t0, 0x11d($t1)
  sdl $t0, 0x11e($t1)
  sdl $t0, 0x11f($t1)
  sdl $t0, 0x120($t1)
  sdl $t0, 0x121($t1)
  sdl $t0, 0x122($t1)
  sdl $t0, 0x123($t1)
  sdl $t0, 0x124($t1)
  sdl $t0, 0x125($t1)
  sdl $t0, 0x126($t1)
  sdl $t0, 0x127($t1)
  sdl $t0, 0x128($t1)
  sdl $t0, 0x129($t1)
  sdl $t0, 0x12a($t1)
  sdl $t0, 0x12b($t1)
  sdl $t0, 0x12c($t1)
  sdl $t0, 0x12d($t1)
  sdl $t0, 0x12e($t1)
  sdl $t0, 0x12f($t1)
  sdl $t0, 0x130($t1)
  sdl $t0, 0x131($t1)
  sdl $t0, 0x132($t1)
  sdl $t0, 0x133($t1)
  sdl $t0, 0x134($t1)
  sdl $t0, 0x135($t1)
  sdl $t0, 0x136($t1)
  sdl $t0, 0x137($t1)
  sdl $t0, 0x138($t1)
  sdl $t0, 0x139($t1)
  sdl $t0, 0x13a($t1)
  sdl $t0, 0x13b($t1)
  sdl $t0, 0x13c($t1)
  sdl $t0, 0x13d($t1)
  sdl $t0, 0x13e($t1)
  sdl $t0, 0x13f($t1)
  sdl $t0, 0x140($t1)
  sdl $t0, 0x141($t1)
  sdl $t0, 0x142($t1)
  sdl $t0, 0x143($t1)
  sdl $t0, 0x144($t1)
  sdl $t0, 0x145($t1)
  sdl $t0, 0x146($t1)
  sdl $t0, 0x147($t1)
  sdl $t0, 0x148($t1)
  sdl $t0, 0x149($t1)
  sdl $t0, 0x14a($t1)
  sdl $t0, 0x14b($t1)
  sdl $t0, 0x14c($t1)
  sdl $t0, 0x14d($t1)
  sdl $t0, 0x14e($t1)
  sdl $t0, 0x14f($t1)
  sdl $t0, 0x150($t1)
  sdl $t0, 0x151($t1)
  sdl $t0, 0x152($t1)
  sdl $t0, 0x153($t1)
  sdl $t0, 0x154($t1)
  sdl $t0, 0x155($t1)
  sdl $t0, 0x156($t1)
  sdl $t0, 0x157($t1)
  sdl $t0, 0x158($t1)
  sdl $t0, 0x159($t1)
  sdl $t0, 0x15a($t1)
  sdl $t0, 0x15b($t1)
  sdl $t0, 0x15c($t1)
  sdl $t0, 0x15d($t1)
  sdl $t0, 0x15e($t1)
  sdl $t0, 0x15f($t1)
  sdl $t0, 0x160($t1)
  sdl $t0, 0x161($t1)
  sdl $t0, 0x162($t1)
  sdl $t0, 0x163($t1)
  sdl $t0, 0x164($t1)
  sdl $t0, 0x165($t1)
  sdl $t0, 0x166($t1)
  sdl $t0, 0x167($t1)
  sdl $t0, 0x168($t1)
  sdl $t0, 0x169($t1)
  sdl $t0, 0x16a($t1)
  sdl $t0, 0x16b($t1)
  sdl $t0, 0x16c($t1)
  sdl $t0, 0x16d($t1)
  sdl $t0, 0x16e($t1)
  sdl $t0, 0x16f($t1)
  sdl $t0, 0x170($t1)
  sdl $t0, 0x171($t1)
  sdl $t0, 0x172($t1)
  sdl $t0, 0x173($t1)
  sdl $t0, 0x174($t1)
  sdl $t0, 0x175($t1)
  sdl $t0, 0x176($t1)
  sdl $t0, 0x177($t1)
  sdl $t0, 0x178($t1)
  sdl $t0, 0x179($t1)
  sdl $t0, 0x17a($t1)
  sdl $t0, 0x17b($t1)
  sdl $t0, 0x17c($t1)
  sdl $t0, 0x17d($t1)
  sdl $t0, 0x17e($t1)
  sdl $t0, 0x17f($t1)
  sdl $t0, 0x180($t1)
  sdl $t0, 0x181($t1)
  sdl $t0, 0x182($t1)
  sdl $t0, 0x183($t1)
  sdl $t0, 0x184($t1)
  sdl $t0, 0x185($t1)
  sdl $t0, 0x186($t1)
  sdl $t0, 0x187($t1)
  sdl $t0, 0x188($t1)
  sdl $t0, 0x189($t1)
  sdl $t0, 0x18a($t1)
  sdl $t0, 0x18b($t1)
  sdl $t0, 0x18c($t1)
  sdl $t0, 0x18d($t1)
  sdl $t0, 0x18e($t1)
  sdl $t0, 0x18f($t1)
  sdl $t0, 0x190($t1)
  sdl $t0, 0x191($t1)
  sdl $t0, 0x192($t1)
  sdl $t0, 0x193($t1)
  sdl $t0, 0x194($t1)
  sdl $t0, 0x195($t1)
  sdl $t0, 0x196($t1)
  sdl $t0, 0x197($t1)
  sdl $t0, 0x198($t1)
  sdl $t0, 0x199($t1)
  sdl $t0, 0x19a($t1)
  sdl $t0, 0x19b($t1)
  sdl $t0, 0x19c($t1)
  sdl $t0, 0x19d($t1)
  sdl $t0, 0x19e($t1)
  sdl $t0, 0x19f($t1)
  sdl $t0, 0x1a0($t1)
  sdl $t0, 0x1a1($t1)
  sdl $t0, 0x1a2($t1)
  sdl $t0, 0x1a3($t1)
  sdl $t0, 0x1a4($t1)
  sdl $t0, 0x1a5($t1)
  sdl $t0, 0x1a6($t1)
  sdl $t0, 0x1a7($t1)
  sdl $t0, 0x1a8($t1)
  sdl $t0, 0x1a9($t1)
  sdl $t0, 0x1aa($t1)
  sdl $t0, 0x1ab($t1)
  sdl $t0, 0x1ac($t1)
  sdl $t0, 0x1ad($t1)
  sdl $t0, 0x1ae($t1)
  sdl $t0, 0x1af($t1)
  sdl $t0, 0x1b0($t1)
  sdl $t0, 0x1b1($t1)
  sdl $t0, 0x1b2($t1)
  sdl $t0, 0x1b3($t1)
  sdl $t0, 0x1b4($t1)
  sdl $t0, 0x1b5($t1)
  sdl $t0, 0x1b6($t1)
  sdl $t0, 0x1b7($t1)
  sdl $t0, 0x1b8($t1)
  sdl $t0, 0x1b9($t1)
  sdl $t0, 0x1ba($t1)
  sdl $t0, 0x1bb($t1)
  sdl $t0, 0x1bc($t1)
  sdl $t0, 0x1bd($t1)
  sdl $t0, 0x1be($t1)
  sdl $t0, 0x1bf($t1)
  sdl $t0, 0x1c0($t1)
  sdl $t0, 0x1c1($t1)
  sdl $t0, 0x1c2($t1)
  sdl $t0, 0x1c3($t1)
  sdl $t0, 0x1c4($t1)
  sdl $t0, 0x1c5($t1)
  sdl $t0, 0x1c6($t1)
  sdl $t0, 0x1c7($t1)
  sdl $t0, 0x1c8($t1)
  sdl $t0, 0x1c9($t1)
  sdl $t0, 0x1ca($t1)
  sdl $t0, 0x1cb($t1)
  sdl $t0, 0x1cc($t1)
  sdl $t0, 0x1cd($t1)
  sdl $t0, 0x1ce($t1)
  sdl $t0, 0x1cf($t1)
  sdl $t0, 0x1d0($t1)
  sdl $t0, 0x1d1($t1)
  sdl $t0, 0x1d2($t1)
  sdl $t0, 0x1d3($t1)
  sdl $t0, 0x1d4($t1)
  sdl $t0, 0x1d5($t1)
  sdl $t0, 0x1d6($t1)
  sdl $t0, 0x1d7($t1)
  sdl $t0, 0x1d8($t1)
  sdl $t0, 0x1d9($t1)
  sdl $t0, 0x1da($t1)
  sdl $t0, 0x1db($t1)
  sdl $t0, 0x1dc($t1)
  sdl $t0, 0x1dd($t1)
  sdl $t0, 0x1de($t1)
  sdl $t0, 0x1df($t1)
  sdl $t0, 0x1e0($t1)
  sdl $t0, 0x1e1($t1)
  sdl $t0, 0x1e2($t1)
  sdl $t0, 0x1e3($t1)
  sdl $t0, 0x1e4($t1)
  sdl $t0, 0x1e5($t1)
  sdl $t0, 0x1e6($t1)
  sdl $t0, 0x1e7($t1)
  sdl $t0, 0x1e8($t1)
  sdl $t0, 0x1e9($t1)
  sdl $t0, 0x1ea($t1)
  sdl $t0, 0x1eb($t1)
  sdl $t0, 0x1ec($t1)
  sdl $t0, 0x1ed($t1)
  sdl $t0, 0x1ee($t1)
  sdl $t0, 0x1ef($t1)
  sdl $t0, 0x1f0($t1)
  sdl $t0, 0x1f1($t1)
  sdl $t0, 0x1f2($t1)
  sdl $t0, 0x1f3($t1)
  sdl $t0, 0x1f4($t1)
  sdl $t0, 0x1f5($t1)
  sdl $t0, 0x1f6($t1)
  sdl $t0, 0x1f7($t1)
  sdl $t0, 0x1f8($t1)
  sdl $t0, 0x1f9($t1)
  sdl $t0, 0x1fa($t1)
  sdl $t0, 0x1fb($t1)
  sdl $t0, 0x1fc($t1)
  sdl $t0, 0x1fd($t1)
  sdl $t0, 0x1fe($t1)
  sdl $t0, 0x1ff($t1)
  sync

  sdl $t0, 0x200($t1)
  sync

  li $t1, 0

  ldl $t0, 0($t1)
  or $t1, $t1, $t0

  ldl $t0, 1($t1)
  or $t1, $t1, $t0

  ldl $t0, 2($t1)
  or $t1, $t1, $t0

  ldl $t0, 3($t1)
  or $t1, $t1, $t0

  ldl $t0, 4($t1)
  or $t1, $t1, $t0

  ldl $t0, 5($t1)
  or $t1, $t1, $t0

  ldl $t0, 6($t1)
  or $t1, $t1, $t0

  ldl $t0, 7($t1)
  or $t1, $t1, $t0

  ldl $t0, 8($t1)
  or $t1, $t1, $t0

  ldl $t0, 9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x10($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x11($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x12($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x13($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x14($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x15($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x16($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x17($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x18($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x19($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x1a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x1b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x1c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x1d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x1e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x1f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x20($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x21($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x22($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x23($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x24($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x25($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x26($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x27($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x28($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x29($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x2a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x2b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x2c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x2d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x2e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x2f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x30($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x31($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x32($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x33($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x34($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x35($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x36($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x37($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x38($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x39($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x3a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x3b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x3c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x3d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x3e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x3f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x40($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x41($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x42($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x43($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x44($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x45($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x46($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x47($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x48($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x49($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x4a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x4b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x4c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x4d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x4e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x4f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x50($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x51($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x52($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x53($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x54($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x55($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x56($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x57($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x58($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x59($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x5a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x5b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x5c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x5d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x5e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x5f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x60($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x61($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x62($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x63($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x64($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x65($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x66($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x67($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x68($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x69($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x6a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x6b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x6c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x6d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x6e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x6f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x70($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x71($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x72($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x73($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x74($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x75($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x76($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x77($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x78($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x79($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x7a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x7b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x7c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x7d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x7e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x7f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x80($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x81($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x82($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x83($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x84($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x85($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x86($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x87($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x88($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x89($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x8a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x8b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x8c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x8d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x8e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x8f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x90($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x91($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x92($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x93($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x94($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x95($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x96($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x97($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x98($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x99($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x9a($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x9b($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x9c($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x9d($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x9e($t1)
  or $t1, $t1, $t0

  ldl $t0, 0x9f($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa0($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa1($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa2($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa3($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa4($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa5($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa6($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa7($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa8($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xa9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xaa($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xab($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xac($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xad($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xae($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xaf($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb0($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb1($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb2($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb3($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb4($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb5($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb6($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb7($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb8($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xb9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xba($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xbb($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xbc($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xbd($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xbe($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xbf($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc0($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc1($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc2($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc3($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc4($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc5($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc6($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc7($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc8($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xc9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xca($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xcb($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xcc($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xcd($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xce($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xcf($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd0($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd1($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd2($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd3($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd4($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd5($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd6($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd7($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd8($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xd9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xda($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xdb($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xdc($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xdd($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xde($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xdf($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe0($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe1($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe2($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe3($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe4($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe5($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe6($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe7($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe8($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xe9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xea($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xeb($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xec($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xed($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xee($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xef($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf0($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf1($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf2($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf3($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf4($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf5($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf6($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf7($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf8($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xf9($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xfa($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xfb($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xfc($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xfd($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xfe($t1)
  or $t1, $t1, $t0

  ldl $t0, 0xff($t1)
  or $t1, $t1, $t0  
  sync
  
  
  ldl $t0, 0x100($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x101($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x102($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x103($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x104($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x105($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x106($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x107($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x108($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x109($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x10a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x10b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x10c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x10d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x10e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x10f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x110($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x111($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x112($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x113($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x114($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x115($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x116($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x117($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x118($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x119($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x11a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x11b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x11c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x11d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x11e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x11f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x120($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x121($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x122($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x123($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x124($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x125($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x126($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x127($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x128($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x129($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x12a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x12b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x12c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x12d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x12e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x12f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x130($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x131($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x132($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x133($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x134($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x135($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x136($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x137($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x138($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x139($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x13a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x13b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x13c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x13d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x13e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x13f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x140($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x141($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x142($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x143($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x144($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x145($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x146($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x147($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x148($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x149($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x14a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x14b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x14c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x14d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x14e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x14f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x150($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x151($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x152($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x153($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x154($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x155($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x156($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x157($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x158($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x159($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x15a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x15b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x15c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x15d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x15e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x15f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x160($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x161($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x162($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x163($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x164($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x165($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x166($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x167($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x168($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x169($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x16a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x16b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x16c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x16d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x16e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x16f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x170($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x171($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x172($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x173($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x174($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x175($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x176($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x177($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x178($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x179($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x17a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x17b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x17c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x17d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x17e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x17f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x180($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x181($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x182($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x183($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x184($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x185($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x186($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x187($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x188($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x189($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x18a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x18b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x18c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x18d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x18e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x18f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x190($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x191($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x192($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x193($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x194($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x195($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x196($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x197($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x198($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x199($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x19a($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x19b($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x19c($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x19d($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x19e($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x19f($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a0($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a1($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a2($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a3($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a4($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a5($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a6($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a7($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a8($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1a9($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1aa($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ab($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ac($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ad($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ae($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1af($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b0($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b1($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b2($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b3($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b4($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b5($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b6($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b7($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b8($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1b9($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ba($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1bb($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1bc($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1bd($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1be($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1bf($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c0($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c1($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c2($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c3($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c4($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c5($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c6($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c7($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c8($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1c9($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ca($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1cb($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1cc($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1cd($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ce($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1cf($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d0($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d1($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d2($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d3($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d4($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d5($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d6($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d7($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d8($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1d9($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1da($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1db($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1dc($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1dd($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1de($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1df($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e0($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e1($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e2($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e3($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e4($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e5($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e6($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e7($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e8($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1e9($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ea($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1eb($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ec($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ed($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ee($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ef($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f0($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f1($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f2($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f3($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f4($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f5($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f6($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f7($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f8($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1f9($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1fa($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1fb($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1fc($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1fd($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1fe($t1)
  or $t1, $t1, $t0
  ldl $t0, 0x1ff($t1)
  or $t1, $t1, $t0
  sync

  ldl $t0, 0x200($t1)
  or $t1, $t1, $t0  
  sync
  
  move $v0, $t1
  
  .set pop
  jr     $ra
  nop
  .end   meLibLdlSdlDebug
