// CPSC 355: assign2a.asm
// Name: Adam Affan, UCID: 30160144

// Define M4 Macros
define(x_v, w19)
define(y_v, w20)
define(t1, w21)
define(t2, w22)
define(t3, w23)
define(t4, w24)
define(temp1, w25)
define(temp2, w26)

fmt:    .string "original: 0x%08X      reversed: 0x%08X\n"     // Print out the original and reversed variables


        .global main
        .balign 4

main:
        stp     x29, x30, [sp, -16]!
        mov     x29, sp

        mov     x_v, 0x07FC07FC                 // Initialize x as 0x07FC07FC 

step1:
        and     t1, x_v, 0x55555555             // Use bitwise AND with x variable and 0x55555555 into t1 
        lsl     t1, t1, 1                       // Logical shift left by 1 of t1 into t1
        lsr     t2, x_v, 1                      // Logical shift right by 1 
        and     t2, t2, 0x55555555              // AND with t2 and 0x55555555 into t2
        orr     y_v, t1, t2                     // Use ORR on t1 and t2 into y variable 

step2:
        and     t1, y_v, 0x33333333             // Use bitwise AND with y variable and 0x33333333 into t1
        lsl     t1, t1, 2                       // Logical shift left by 2 of t1 into t1
        lsr     t2, y_v, 2                      // Logical shift right by 2
        and     t2, t2, 0x33333333              // AND with t2 and 0x33333333 into t2
        orr     y_v, t1, t2                     // Use ORR on t1 and t2 into y variable

step3:
        and     t1, y_v, 0x0F0F0F0F             // Use bitwise AND with y variable and 0x0F0F0F0F into t1
        lsl     t1, t1, 4                       // Logical shift left by 4 of t1 into t1
        lsr     t2, y_v, 4                      // Logical shift right by 4
        and     t2, t2, 0x0F0F0F0F              // AND with t2 and 0x0F0F0F0F into t2
        orr     y_v, t1, t2                     // Use ORR on t1 and t2 into y variable

step4:
        lsl     t1, y_v, 24                     // Logical shift left by 24 of y variable 
        and     t2, y_v, 0xFF00                 // Use bitwise AND with y variable and 0xFF00 into t2
        lsl     t2, t2, 8                       // Logical shift left by 8 of t2 into t2
        lsr     t3, y_v, 8                      // Logical shift right by 8 of y variable
        and     t3, t3, 0xFF00                  // Use bitwise AND with t3 and 0xFF00 into t3
        lsr     t4, y_v, 24                     // Logical shift right by 24 of y variable into t4
 
orrstep:
        orr     temp1, t1, t2                   // Use ORR on t1 and t2 into temp1
        orr     temp2, t3, t4                   // Use ORR on t3 and t4 into temp2
        orr     y_v, temp1, temp2               // Use ORR on temp1 and temp2 into y variable

print:  // Arguments for print function
        adrp    x0, fmt                         
        add     x0, x0, :lo12:fmt               
        mov     w1, x_v
        mov     w2, y_v
        bl      printf                          // Call print function

done:
        ldp     x29, x30, [sp], 16
        mov     x0, 0
        ret
