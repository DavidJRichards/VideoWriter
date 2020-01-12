
        org $C000


START:
        ld hl, HELLO

PRINT:
        ld a, (hl)
        cp $00
        jr z, DONE
        out ($F5), a
        inc hl
        jr PRINT


DONE:
        jr DONE


HELLO:
        defmz "Hello world!"


; $C000 CCCCCCCCCCCCCCCBBBBBBBBBBBB

; Labels
;
; $C000 => START         DONE   => $C00D
; $C003 => PRINT         HELLO  => $C00F
; $C00D => DONE          PRINT  => $C003
; $C00F => HELLO         START  => $C000
