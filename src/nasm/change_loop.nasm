;-------------------------------------
; change_loop.nasm
; Leia o README.md para detalhes
;-------------------------------------

leaw $20, %A
movw %A, %D
leaw $30, %A
movw %D, (%A)
leaw $31, %A
movw $0, (%A)

leaw $REPETE, %A
jmp
nop

REPETE:
leaw $30, %A
movw (%A), %D
leaw $29, %A
subw %A, %D, %D
leaw $FIM, %A
jl %D
nop

leaw $30, %A
movw (%A), %A
movw (%A), %D

leaw $0, %A
subw %D, (%A), %D
leaw $SE, %A
je %D
nop

AUMENTA:
leaw $30, %A
addw $1, (%A), %D
movw %D, (%A)

leaw $REPETE, %A
jmp
nop


SE:
leaw $1, %A
movw (%A), %D
leaw $30, %A
movw (%A), %A
movw %D, (%A)

leaw $31, %A
addw (%A), $1, %D
movw %D, (%A)

leaw $AUMENTA, %A
jmp
nop

FIM:
leaw $31, %A
movw (%A), %D
leaw $21184, %A
movw %D, (%A)


