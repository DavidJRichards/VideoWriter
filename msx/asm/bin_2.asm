SYS_CALL         equ $0024
DATA_8           equ $7FF8
DATA_A           equ $7FFA
DATA_B           equ $7FFB
DATA_C           equ $7FFC
DATA_D           equ $7FFD
DATA_F           equ $7FFF
DATA_BUF88       equ $8800
DATA_BUF90       equ $9000
SYSDAT2a         equ $C9FB
INPUT_TYPE       equ $F663
INPUT_INTEGER_LO equ $F7F8
INPUT_INTEGER_HI equ $F7F9
numbrives        equ $FB21
SYSDAT3          equ $FB22
SYSDAT2          equ $FBC9
SYSDAT4          equ $FCC1

        org $D000


START:
        ld a, (SYSDAT3)
        ld h, $40
        call SYS_CALL
        defb $AF
        ld (DATA_C), a
        ld a, $C0
        ld (DATA_D), a
        ld hl, DATA_8
        ld d, l

L_D015:
        dec de
        ld a, d
        or e
        ex (sp), hl
        ex (sp), hl
        jr nz, L_D015
        bit 7, (hl)
        jr z, L_D026
        ld a, (hl)
        ld (INPUT_INTEGER_LO), a
        jr L_D050


L_D026:
        call L_D077
        ld a, (INPUT_INTEGER_LO)
        ld (DATA_B), a
        ld (hl), $14
        call L_D079
        ld b, $12
        ld de, DATA_BUF90

L_D039:
        ld a, $12
        sub b
        ld (DATA_A), a
        ld (hl), $82
        call L_D082
        ld a, (hl)
        or a
        jr nz, L_D04A
        djnz L_D039

L_D04A:
        ld (INPUT_INTEGER_LO), a
        call L_D077

L_D050:
        xor a
        ld (DATA_D), a
        ld a, (SYSDAT4)
        ld h, $40
        call SYS_CALL
        defw SYSDAT2a

t_msg:
        defm "(c) Peter van Overbeek'92"

L_D077:
        ld (hl), $04

L_D079:
        ld a, (DATA_F)
        bit 6, a
        jr nz, L_D079
        ld a, (hl)
        ret


L_D082:
        ld a, (DATA_F)
        add a, a
        ret p
        jr c, L_D082
        ld a, (DATA_B)
        ldi (de), a
        jr L_D082



; $D000 CCCCCCCCBCCCCCCCCCCCCCCCCCCCCCCC
; $D020 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCWWBBBBBBBBBBBBBBBBBB
; $D070 BBBBBBBCCCCCCCCCCCCCCCCCCCCCCCC

; Labels
;
; $0024 => SYS_CALL                DATA_8           => $7FF8
; $7FF8 => DATA_8                  DATA_A           => $7FFA
; $7FFA => DATA_A                  DATA_B           => $7FFB
; $7FFB => DATA_B                  DATA_BUF88       => $8800
; $7FFC => DATA_C                  DATA_BUF90       => $9000
; $7FFD => DATA_D                  DATA_C           => $7FFC
; $7FFF => DATA_F                  DATA_D           => $7FFD
; $8800 => DATA_BUF88              DATA_F           => $7FFF
; $9000 => DATA_BUF90              INPUT_INTEGER_HI => $F7F9
; $C9FB => SYSDAT2a                INPUT_INTEGER_LO => $F7F8
; $D000 => START                   INPUT_TYPE       => $F663
; $D015 => L_D015                  L_D015           => $D015
; $D026 => L_D026                  L_D026           => $D026
; $D039 => L_D039                  L_D039           => $D039
; $D04A => L_D04A                  L_D04A           => $D04A
; $D050 => L_D050                  L_D050           => $D050
; $D05E => t_msg                   L_D077           => $D077
; $D077 => L_D077                  L_D079           => $D079
; $D079 => L_D079                  L_D082           => $D082
; $D082 => L_D082                  numbrives        => $FB21
; $F663 => INPUT_TYPE              START            => $D000
; $F7F8 => INPUT_INTEGER_LO        SYS_CALL         => $0024
; $F7F9 => INPUT_INTEGER_HI        SYSDAT2          => $FBC9
; $FB21 => numbrives               SYSDAT2a         => $C9FB
; $FB22 => SYSDAT3                 SYSDAT3          => $FB22
; $FBC9 => SYSDAT2                 SYSDAT4          => $FCC1
; $FCC1 => SYSDAT4                 t_msg            => $D05E


; Check these calls manualy: $0024

