SYS_CALL      equ $0024
DATA_8        equ $7FF8
DATA_A        equ $7FFA
DATA_B        equ $7FFB
DATA_C        equ $7FFC
DATA_D        equ $7FFD
DATA_F        equ $7FFF
DATA_BUF88    equ $8800
DATA_BUF90    equ $9000
SYSDAT2a      equ $C9FB
INPUP_INTEGER equ $F7F8
SYSDAT9       equ $F7F9
numbrives     equ $FB21
SYSDAT3       equ $FB22
SYSDAT2       equ $FBC9
SYSDAT4       equ $FCC1

        org $D000


START:
        ld a, (SYSDAT3)
        ld h, $40
        call SYS_CALL
        defb $3E
        ret nz
        ld (DATA_D), a
        ld hl, DATA_8
        ld a, $04
        ld (hl), a
        ld d, l

L_D014:
        dec de
        ld a, d
        or e
        ex (sp), hl
        ex (sp), hl
        jr nz, L_D014
        ld a, (hl)
        and $91
        jr z, L_D02A
        ld a, $80
        ld (INPUP_INTEGER), a
        ld a, $D8
        ld (hl), a
        jr L_D062


L_D02A:
        ld a, (SYSDAT9)
        ld (DATA_C), a
        ld a, (INPUP_INTEGER)
        ld (DATA_B), a
        ld (hl), $14
        call L_D087
        ld de, DATA_BUF88

L_D03E:
        bit 1, (hl)
        jr z, L_D03E
        ld b, $1C

L_D044:
        ld (hl), $C0

L_D046:
        ld a, (DATA_F)
        add a, a
        jp p, L_D056
        jr c, L_D046
        ld a, (DATA_B)
        ld (de), a
        ld (de), a
        jr L_D046


L_D056:
        ld a, (hl)
        or a
        jr nz, L_D05C
        djnz L_D044

L_D05C:
        ld (INPUP_INTEGER), a
        call L_D085

L_D062:
        xor a
        ld (DATA_D), a
        ld a, (SYSDAT4)
        ld h, $40
        call SYS_CALL
        defb $FB
        defb $C9

t_msg:
        defm "Peter van Overbeek'92"

L_D085:
        ld (hl), $04

L_D087:
        ld a, (DATA_F)
        bit 6, a
        jr nz, L_D087
        ld a, (hl)
        ret



; $D000 CCCCCCCCBCCCCCCCCCCCCCCCCCCCCCCC
; $D020 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBB
; $D070 BBBBBBBBBBBBBBBBBBBBBCCCCCCCCCC

; Labels
;
; $0024 => SYS_CALL             DATA_8        => $7FF8
; $7FF8 => DATA_8               DATA_A        => $7FFA
; $7FFA => DATA_A               DATA_B        => $7FFB
; $7FFB => DATA_B               DATA_BUF88    => $8800
; $7FFC => DATA_C               DATA_BUF90    => $9000
; $7FFD => DATA_D               DATA_C        => $7FFC
; $7FFF => DATA_F               DATA_D        => $7FFD
; $8800 => DATA_BUF88           DATA_F        => $7FFF
; $9000 => DATA_BUF90           INPUP_INTEGER => $F7F8
; $C9FB => SYSDAT2a             L_D014        => $D014
; $D000 => START                L_D02A        => $D02A
; $D014 => L_D014               L_D03E        => $D03E
; $D02A => L_D02A               L_D044        => $D044
; $D03E => L_D03E               L_D046        => $D046
; $D044 => L_D044               L_D056        => $D056
; $D046 => L_D046               L_D05C        => $D05C
; $D056 => L_D056               L_D062        => $D062
; $D05C => L_D05C               L_D085        => $D085
; $D062 => L_D062               L_D087        => $D087
; $D070 => t_msg                numbrives     => $FB21
; $D085 => L_D085               START         => $D000
; $D087 => L_D087               SYS_CALL      => $0024
; $F7F8 => INPUP_INTEGER        SYSDAT2       => $FBC9
; $F7F9 => SYSDAT9              SYSDAT2a      => $C9FB
; $FB21 => numbrives            SYSDAT3       => $FB22
; $FB22 => SYSDAT3              SYSDAT4       => $FCC1
; $FBC9 => SYSDAT2              SYSDAT9       => $F7F9
; $FCC1 => SYSDAT4              t_msg         => $D070


; Check these calls manualy: $0024

