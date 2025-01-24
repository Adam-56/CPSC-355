// CPSC 355: a5a.asm
// Name: Adam Affan, UCID: 30160144

// Global variable equates
MAXOP = 20
NUMBER = '0'
TOOBIG = '9'
MAXVAL = 100
BUFSIZE = 100

// Define macros
define(f_r, w19)
define(i_r, w20)
define(c_r, w21)
define(sp_r, w22)
define(lim, w23)
define(temp_r, x27)

// Define strings
fmt1:   .string "error: stack full\n"
fmt2:   .string "error: stack empty\n"
fmt3:   .string "ungetch: too many characters\n"

// Declare the variables
        .data
        .global sp_m
sp_m:   .word 0                                             // sp = 0

        .global bufp_m
bufp_m: .word 0                                             // bufp = 0

        .bss
        .global val_m
val_m:  .skip MAXVAL * 4                                // 400 bytes 

        .global buf_m
buf_m:  .skip BUFSIZE * 4                               // 400 bytes

fp      .req x29        
lr      .req x30

        .text
        .balign 4 
        .global push
push:
        stp     fp, lr, [sp, -16]!
        mov     fp, sp

        mov     f_r, w0                         // Move w0 to f_r

        adrp    x24, sp_m                       // Sets 1st argument
        add     x24, x24, :lo12:sp_m                  
        ldr     sp_r, [x24]

        cmp     sp_r, MAXVAL                    // If sp_r >= MAXVAL
        b.ge    push_else                       // Branch to push_else

        adrp    x25, val_m                      // Sets 1st argument
        add     x25, x25, :lo12:val_m
        str     f_r, [x25, sp_r, SXTW 2]
        
        adrp    x25, val_m                      // Sets 1st argument                                                 
        add     x25, x25, :lo12:val_m                                       
        ldr     w0, [x25, sp_r, SXTW 2]

        add     sp_r, sp_r, 1                   // Increments sp_r by 1                                               
        str     sp_r, [x24]                                                 
    
        b       push_done                       // Branches to done                                                          

push_else: 
        adrp    x0, fmt1                        // Prints first message                                             
        add     x0, x0, :lo12:fmt1                                    
        bl      printf                          // Call print function                                                       
        bl      clear                           // Call clear function                                                        
        mov     w0, 0                                                       

push_done:
        ldp     fp, lr, [sp], 16  
        ret 


        .balign 4
        .global pop
pop:
        stp     fp, lr, [sp, -16]!
        mov     fp, sp

        adrp    x9, sp_m                        // Sets arg                                                   
        add     x9, x9, :lo12:sp_m                                          
        ldr     sp_r, [x9]                                                  

        cmp     sp_r, 0                         // If sp_r <= 0                                                     
        b.le    pop_else                        // Branch to pop_else                               

        sub     sp_r, sp_r, 1                   // Decrements sp_r by 1                                              
        str     sp_r, [x9] 

        adrp    x9, sp_m                        // Sets arg                                                  
        add     x9, x9, :lo12:sp_m                                        
        ldr     sp_r, [x9]                                                

        adrp    x9, val_m                       // Sets arg                                                 
        add     x9, x9, :lo12:val_m                                       
        SXTW    x22, sp_r                                                 
        ldr     w0, [x9, x22, LSL 2]                                       

        b       pop_done

pop_else:
        adrp    x0, fmt2                        // Prints second error message                                  
        add     x0, x0, :lo12:fmt2                                 
        bl      printf                          // Calls print function                                                      
        bl      clear                           // Calls clear function                                                       
        mov     w0, 0 

pop_done:
        ldp     fp, lr, [sp], 16
        ret


        .balign 4
        .global clear
clear:
        stp     fp, lr, [sp, -16]!
        mov     fp, sp

        mov     sp_r, 0                         // Move 0 to sp_r  

        adrp    x24, sp_m                       // Sets arg                                                 
        add     x24, x24, :lo12:sp_m                                       
        str     sp_r, [x24]                                                

clear_done:
        ldp     fp, lr, [sp], 16
        ret


        .balign 4
        .global getop
getop:
        stp     fp, lr, [sp, -16]!
        mov     fp, sp

        mov     temp_r, x0                                                  
        mov     lim, w1                                                   

getop_while1:                                                              
        bl      getch                           // Calls getch function                                                       
        mov     c_r, w0                                                    

        cmp     c_r, ' '                        // If c_r = ' '                                                   
        b.eq    getop_while1                    // Branch to getop_while1                                 
        
        cmp     c_r, '\t'                       // If C_r = '\t'                                                  
        b.eq    getop_while1                    // Branch to getop_while1                                                      

        cmp     c_r, '\n'                       // If c_r = '\n'                                                   
        b.eq    getop_while1                    // Branch to getop_while1

getop_if1:
        cmp     c_r, '0'                        // If c_r < '0'                                                             
        b.lt    getop_ret                       // Branch to getop_while1                                                        

        cmp     c_r, '9'                        // If c_r <= '9'                             
        b.le    getop_next1                     // Branch to getop_while1

getop_ret: 
        mov     w0, c_r                         // Move c_r to w0                                                      
        b       getop_done                      // Branch to getop_done

getop_next1:
        str     c_r, [temp_r]                                                    
                                                               
        mov     i_r, 0                          // Move 0 to i_r                                                       
        b       getop_loop                      // Branch to getop_loop                                                           

getop_if2:                                                                 
        cmp     i_r, lim                        // If i_r >= lim                                                   
        b.ge    getop_loop                      // Branch to getop_while1                                                        

        str     c_r, [temp_r, i_r, SXTW 2]                                   

getop_loop:                                                                
        add     i_r, i_r, 1                                                  
        bl      getchar                                                       
        mov     c_r, w0                                                      

        cmp     c_r, '0'                         // If c_r < '0'                                                    
        b.lt    getop_if3                       // Branch to getop_if3                                                         

        cmp     c_r, '9'                        // If c_r <= '9'                            
        b.le    getop_if2                       // Branch to getop_if2                                                         

getop_if3:                                                                 
        mov     w0, c_r                         // Move c_r to w0                                                      
        bl      ungetch                         // Calls ungetch function                                                      
                                                                
        str     wzr, [temp_r, i_r, SXTW 2]                                   
        mov     x0, NUMBER                      // Move NUMBER function to x0                                                   
        b       getop_done                      // Branch to getop_done                                                                                                                          

getop_while2:                                                              
        cmp     c_r, '\n'                       // If c_r = '\n'                                                    
        b.eq    getop_next2                     // Branch to getop_next2                                                      
        
        cmp     c_r, -1                         // If c_r = -1                                                      
        b.eq    getop_next2                     // Branch to getop_next2                                                       

        bl      getchar                         // Calls getchar function                              
        mov     c_r, w0                         // Move w0 to c_r                                                      
        b       getop_while2                    // Branch to getop_while2                                                         

getop_next2:
        sub     lim, lim, 1                     // Decrement lim by 1                                             
        str     wzr, [temp_r, lim, SXTW 2]                                 
        mov     w0, TOOBIG                      // Move TOOBIG function to w0                                                   

getop_done:
        ldp     fp, lr, [sp], 16
        ret


        .balign 4
        .global getch         
getch:
        stp     fp, lr, [sp, -16]!
        mov     fp, sp

        adrp    x11, bufp_m                                                   
        add     x11, x11, :lo12:bufp_m                                        
        ldr     w12, [x11]                                                  

getch_if:
        cmp     w12, 0                          // If w12(bufp) <= 0                                                      
        b.le    getch_else                      // Branch to getch_else                                                       

        sub     w12, w12, 1                     // Decrements w12(bufp) by 1                                                 
        str     w12, [x11]                                                  

        adrp    x11, buf_m                                                    
        add     x11, x11, :lo12:buf_m                                         
        SXTW    x12, w12                                                    
        ldrb    w0, [x11, x12]                                              
        b       getch_done                                                         

getch_else:
        bl      getchar                         // Calls getchar function                                                       
    
getch_done:
        ldp     fp, lr, [sp], 16
        ret        


        .balign 4
        .global ungetch
ungetch:
        stp     fp, lr, [sp, -16]!
        mov     fp, sp

        mov     c_r, w0                                                      

        adrp    x11, bufp_m                     // Sets arg                                                   
        add     x11, x11, :lo12:bufp_m                                        
        ldr     w12, [x11]                                                  

        cmp     w12, BUFSIZE                    // If w12(bufp) <= BUFSIZE                                                 
        b.le    ungetch_else                    // Branch to getch_else                                                      

        adrp    x0, fmt3                        // Prints third error message                                              
        add     x0, x0, :lo12:fmt3                                    
        bl      printf                          // Calls print function                                                         
        b       ungetch_done                    // Branch to ungetch_done                                                       

ungetch_else:
        adrp    x13, buf_m                      // Sets arg                              
        add     x13, x13, :lo12:buf_m                                         
        str     c_r, [x13, w12, SXTW 2]                                     
        
        add     w12, w12, 1                     // Increments w12(bufp) by 1                                                 
        str     w12, [x11]                                                  

ungetch_done:
        ldp     fp, lr, [sp], 16
        ret
