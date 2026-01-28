        .section .data
input_string:   .asciz "Hello world!"

        # tohost/fromhost are data locations used by Spike
        .align 8
tohost: .byte 0
        .align 8
fromhost: .byte 0

        
        .section .text
        .globl _start
_start:
        # Load the address of the input string into a0
        la a0, input_string

loop:
        lbu t0, 0(a0)              
        beq t0, x0, end_program   

        # Check if 'a' <= t0 <= 'z'
        li   t1, 'a'              
        blt  t0, t1, not_lower     

        li   t2, 'z' + 1           
        bge  t0, t2, not_lower     

        addi t0, t0, -32          
        sb   t0, 0(a0)            

not_lower:
        addi a0, a0, 1            
        j    loop                 

end_program:
        # jump here when you're done
        j end_program              # infinite loop

