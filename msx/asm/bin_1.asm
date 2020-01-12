L_0018     equ $0018
SYS_CALL   equ $0024
DATA_8     equ $7FF8
DATA_A     equ $7FFA
DATA_B     equ $7FFB
DATA_C     equ $7FFC
DATA_D     equ $7FFD
DATA_F     equ $7FFF
DATA_BUF88 equ $8800
DATA_BUF90 equ $9000
SYSDAT2a   equ $C9FB
SYSDAT8    equ $F7F8
SYSDAT9    equ $F7F9
numbrives  equ $FB21
SYSDAT3    equ $FB22
SYSDAT2    equ $FBC9
SYSDAT4    equ $FCC1

        org $D000


START:
        ld a, (SYSDAT3)
        ld h, $40
        call SYS_CALL
        defb $21
        sbc a, a
        ld a, (iy-$0B)
        ld (hl), $C9
        push hl
        ld hl, DATA_C
        xor a
        ld c, a
        ld (hl), a
        inc hl
        ld (hl), $C0
        ld d, l

L_D01A:
        dec de
        ex (sp), hl
        ex (sp), hl
        ld a, d
        or e
        jr nz, L_D01A
        call L_D0C3
        inc (hl)
        call L_D0C3
        dec (hl)

L_D029:
        ld a, c
        ld ($7FF9), a
        ld a, $08
        rst $18
        defb $DF
        ld d, $2F
        ld a, c

L_D034:
        inc d
        sub $0A
        jr nc, L_D034
        add a, $3A
        ld e, a
        ld a, d
        rst $18
        defb $7B
        rst $18
        defb $F3
        ld b, $12
        ld de, DATA_BUF88

L_D046:
        ld a, $12
        sub b
        ld (DATA_A), a
        ld a, $82
        ld (DATA_8), a
        call L_D0E4
        ld a, (DATA_8)
        or a
        jr nz, L_D091
        djnz L_D046
        inc (hl)
        ld b, $12
        ld de, DATA_BUF88

L_D062:
        ld a, $12
        sub b
        ld (DATA_A), a
        ld a, $A2
        ld (DATA_8), a
        call L_D0F2
        ld a, (DATA_8)
        or a
        jr nz, L_D091
        djnz L_D062
        inc c
        ld a, $50
        cp c
        jr z, L_D087
        call L_D0D4
        dec (hl)
        call L_D0D4
        jr L_D029


L_D087:
        call L_D0CD
        dec (hl)
        call L_D0CD
        xor a
        jr L_D094


L_D091:
        ld a, (DATA_8)

L_D094:
        ld (SYSDAT8), a
        ld a, (hl)
        and $01
        ld (SYSDAT9), a
        ld (hl), a
        ld a, (SYSDAT4)
        ld h, $40
        call SYS_CALL
        defb $E1
        pop af
        ld (hl), a
        ei
        ret


t_msg:
        defm "Peter van Overbeek, 1992"

L_D0C3:
        ld a, (DATA_8)
        bit 7, a
        jr z, L_D0CD
        pop de
        jr L_D091


L_D0CD:
        ld a, $04
        ld (DATA_8), a
        jr L_D0D9


L_D0D4:
        ld a, $54
        ld (DATA_8), a

L_D0D9:
        ld a, (DATA_F)
        bit 6, a
        jr nz, L_D0D9
        ld a, (DATA_8)
        ret


L_D0E4:
        ld a, (DATA_F)
        add a, a
        ret p
        jr c, L_D0E4
        ld a, (DATA_B)
        ld (de), a
        inc de
        jr L_D0E4


L_D0F2:
        ld a, (DATA_F)
        add a, a
        ret p
        jr c, L_D0F2
        ld a, (de)
        ld (DATA_B), a
        inc de
        jr L_D0F2



; $D000 CCCCCCCCBCCCCCCCCCCCCCCCCCCCCCCC
; $D020 CCCCCCCCCCCCCCCCBCCCCCCCCCCCCCBCBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
; $D070 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCBCCCCBBBBBBBBBBBBBBBBBBBBB
; $D0C0 BBBCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

; Labels
;
; $0018 => L_0018            DATA_8     => $7FF8
; $0024 => SYS_CALL          DATA_A     => $7FFA
; $7FF8 => DATA_8            DATA_B     => $7FFB
; $7FFA => DATA_A            DATA_BUF88 => $8800
; $7FFB => DATA_B            DATA_BUF90 => $9000
; $7FFC => DATA_C            DATA_C     => $7FFC
; $7FFD => DATA_D            DATA_D     => $7FFD
; $7FFF => DATA_F            DATA_F     => $7FFF
; $8800 => DATA_BUF88        L_0018     => $0018
; $9000 => DATA_BUF90        L_D01A     => $D01A
; $C9FB => SYSDAT2a          L_D029     => $D029
; $D000 => START             L_D034     => $D034
; $D01A => L_D01A            L_D046     => $D046
; $D029 => L_D029            L_D062     => $D062
; $D034 => L_D034            L_D087     => $D087
; $D046 => L_D046            L_D091     => $D091
; $D062 => L_D062            L_D094     => $D094
; $D087 => L_D087            L_D0C3     => $D0C3
; $D091 => L_D091            L_D0CD     => $D0CD
; $D094 => L_D094            L_D0D4     => $D0D4
; $D0AB => t_msg             L_D0D9     => $D0D9
; $D0C3 => L_D0C3            L_D0E4     => $D0E4
; $D0CD => L_D0CD            L_D0F2     => $D0F2
; $D0D4 => L_D0D4            numbrives  => $FB21
; $D0D9 => L_D0D9            START      => $D000
; $D0E4 => L_D0E4            SYS_CALL   => $0024
; $D0F2 => L_D0F2            SYSDAT2    => $FBC9
; $F7F8 => SYSDAT8           SYSDAT2a   => $C9FB
; $F7F9 => SYSDAT9           SYSDAT3    => $FB22
; $FB21 => numbrives         SYSDAT4    => $FCC1
; $FB22 => SYSDAT3           SYSDAT8    => $F7F8
; $FBC9 => SYSDAT2           SYSDAT9    => $F7F9
; $FCC1 => SYSDAT4           t_msg      => $D0AB


; Check these calls manualy: $0018, $0024, $D0C3

