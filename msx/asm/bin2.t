#!perl

use strict;
use warnings;

use CPU::Z80::Disassembler;
my $dis = CPU::Z80::Disassembler->new;

unlink "bin_2.ctl";
CPU::Z80::Disassembler->create_control_file("bin_2.ctl", "bin_2.bin", 0xD000);

$dis->load_control_file("bin_2.ctl");
$dis->memory->load_file( "bin_2.bin", 0xD000);

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

$dis->code(0xD009);

#$dis->code(0xD05D);
#$dis->code(0xD05e);
#$dis->labels->add(0xC003, "PRINT");
#$dis->labels->add(0xC00D, "DONE");
$dis->analyse;

$dis->defw(0xD05C, 1);

#$dis->defb(0xD05C, 1);
#$dis->defb(0xD05D, 1);


$dis->defm(0xD05E, 25, "t_msg");

#$dis->defb(0xD074, 5);

$dis->code(0xD079);

#$dis->defb(0xD0E4, 1);



#$dis->defb(0xC00F, 13, "HELLO");
#$dis->defmz(0xC00F, 13, "HELLO");

$dis->write_asm("bin_2.asm");
