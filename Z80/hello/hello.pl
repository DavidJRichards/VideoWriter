#!perl

use strict;
use warnings;

use CPU::Z80::Disassembler;
my $dis = CPU::Z80::Disassembler->new;

unlink "hello.ctl";
CPU::Z80::Disassembler->create_control_file("hello.ctl", "hello.bin", 0xC000);

$dis->load_control_file("hello.ctl");
$dis->memory->load_file( "hello.bin", 0xC000);

$dis->code(0xC000, "START");
$dis->labels->add(0xC003, "PRINT");
$dis->labels->add(0xC00D, "DONE");
$dis->analyse;
#$dis->defb(0xC00F, 13, "HELLO");
$dis->defmz(0xC00F, 13, "HELLO");

$dis->write_asm("hello.asm");
