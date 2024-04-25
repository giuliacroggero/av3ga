;-------------------------------------
; change_if.nasm
; Leia o README.md para detalhes
;-------------------------------------

leaw $0, %A
movw (%A), %D
leaw $10, %A
subw (%A), %D, %D

leaw $IF, %A
je %D
nop

leaw $END, %A 
jmp 
nop    

IF:
leaw $1, %A
movw (%A), %D
leaw $10, %A
movw %D, (%A)

END:

