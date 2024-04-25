;-------------------------------------
; change.nasm
; Leia o README.md para detalhes
;-------------------------------------

leaw $1, %A
movw (%A), %D
leaw $2 , %A
movw (%A), %A
movw %D, (%A)

