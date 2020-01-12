#!perl

use strict;
use warnings;

use CPU::Z80::Disassembler;
my $dis = CPU::Z80::Disassembler->new;

unlink "bin_1.ctl";
CPU::Z80::Disassembler->create_control_file("bin_1.ctl", "bin_1.bin", 0xD000);

$dis->load_control_file("bin_1.ctl");
$dis->memory->load_file( "bin_1.bin", 0xD000);

$dis->labels->add(0x8800, "DATA_BUF88");
$dis->labels->add(0x9000, "DATA_BUF90");
$dis->labels->add(0x7FF8, "DATA_8");
$dis->labels->add(0x7FFA, "DATA_A");
$dis->labels->add(0x7FFB, "DATA_B");
$dis->labels->add(0x7FFC, "DATA_C");
$dis->labels->add(0x7FFD, "DATA_D");
$dis->labels->add(0x7FFF, "DATA_F");

$dis->labels->add(0xF663, "INPUT_TYPE");
$dis->labels->add(0xF7F8, "INPUT_INTEGER_LO");
$dis->labels->add(0xF7F9, "INPUT_INTEGER_HI");
$dis->labels->add(0xFB21, "numbrives");

$dis->labels->add(0xFBC9, "SYSDAT2");
$dis->labels->add(0xC9FB, "SYSDAT2a");
$dis->labels->add(0xFB22, "SYSDAT3");
$dis->labels->add(0xFCC1, "SYSDAT4");
$dis->labels->add(0x0024, "SYS_CALL");





$dis->code(0xD000, "START");
$dis->defb(0xD008, 1);
#$dis->defb(0xD009, 1);
$dis->code(0xD009);
#$dis->code(0xD05D);
#$dis->code(0xD05e);
#$dis->labels->add(0xC003, "PRINT");
#$dis->labels->add(0xC00D, "DONE");
$dis->code(0xD024);
$dis->code(0xD028);

$dis->defb(0xD030, 1);
$dis->code(0xD031);
$dis->defb(0xD03e, 1,);

$dis->code(0xD03f);
$dis->defb(0xD040, 1);

$dis->code(0xD041);


$dis->code(0xD046);
$dis->code(0xD062);



#$dis->analyse;
##$dis->defb(0xD05D, 1);
$dis->defb(0xD0a6, 1);
$dis->code(0xD0a7);
$dis->defm(0xD0AB, 24, "t_msg");
$dis->code(0xD0D4);
$dis->code(0xD0ec);
$dis->code(0xD0f2);
$dis->write_asm("bin_1.asm");
