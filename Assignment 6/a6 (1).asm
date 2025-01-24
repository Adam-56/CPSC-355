// CPSC 355: a6.asm
// Name: Adam Affan, UCID: 30160144

// Define macros
define(argc_r, w18)
define(fd_r, w19)                                             
define(nread_r, x20)                                         
define(buf_base_r, x21)
define(argv_r, x22)                                       
define(expon, d19)              // Exponent
define(num, d20)                // Numerator
define(factor, d21)             // Factorial
define(equ, d22)                // Equation
define(expan, d23)              // Expansion
define(incr, d24)               // Increment 

buf_size = 8                                                
alloc = -(16 + buf_size) & -16                              // Allocate
dealloc = -alloc                                            // Deallocate
buf_s = 16                                                  

minimum:    .double 0r1.0e-10 
pi_two:     .double 0r1.57079632679489661923 
ninety:     .double 0r90.0 
zero:       .double 0r0.0 

fmt1:       .string "|     x     |     cos(x)     |     sin(x)     |\n" 
fmt2:       .string "%13.10f  \t%13.10f  \t%13.10f\n"
fmt3:       .string "ERROR\n"

fp      .req x29
lr      .req x30

        .global main
        .balign 4

main:
        stp     fp, lr, [sp, alloc]! 
        mov     fp, sp 

        mov     argc_r, w0                  // Move w0 into argc_r
        mov     argv_r, x1                  // Move x1 into argv_r

        cmp     argc_r, 2                   // If argc_r is not 2  
        b.ne    print_error                 // Branch to print_error

        adrp    x0, fmt1                    // Print first statement
        add     x0, x0, :lo12:fmt1          
        bl      printf                      // Call print function

        mov     w0, -100 
        ldr     x1, [argv_r, 8] 
        mov     w2, 0 
        mov     w3, 0 
        mov     w8, 56                      // Openat I/O request
        svc     0                           // System function 
        mov     fd_r, w0                    

        cmp     fd_r, 0                     // Error check
        b.ge    true              

        adrp    x0, fmt3                    // Print third statement
        add     x0, x0, :lo12:fmt3 
        bl      printf                      // Call print function

        mov     w0, -1                      // Move -1 into w0
        b       exit 

true:
        add     buf_base_r, fp, buf_s       

top:
        mov     w0, fd_r                    // Move w0 to fd_r
        mov     x1, buf_base_r              // Move x1 to buf_base_r
        mov     w2, buf_size                // Move w2 to buf_size
        mov     x8, 63                      // Read I/O request
        svc     0                           // Call sys function

        mov     nread_r, x0                 // nread_r is in x0

        cmp     nread_r, buf_size           // Compare nread_r to buf_size
        b.ne    done                         

        adrp    x10, zero                   // Load zero
        add     x10, x10, :lo12:zero 
        ldr     d13, [x10] 

        adrp    x10, pi_two                 // Load pi_two
        add     x10, x10, :lo12:pi_two 
        ldr     d14, [x10] 

        adrp    x10, ninety                 // Load ninety
        add     x10, x10, :lo12:ninety 
        ldr     d15, [x10] 

        fcmp    d0, d13                     
        b.lt    top                         // Branch to top if less than

        fcmp    d0, d15 
        b.gt    top                         // Branch to top if greater than 

        ldr     d0, [buf_base_r]            // Load value
        bl      sin 
        fmov    d1, d0 

        ldr     d0, [buf_base_r]            // Load value
        bl      cos 
        fmov    d2, d0 

        adrp    x0, fmt2                    // Print second statement
        add     x0, x0, :lo12:fmt2 
        ldr     d0, [buf_base_r] 
        bl      printf                      // Call print function

        b       top 

done:
        mov     w0, fd_r                // Move w0 to fd_r
        mov     x8, 57                  // Close I/O request
        svc     0                       // System function
        mov     w0, 0                   // Move w0 to 0
        b       exit                    // Branch to exit

print_error:
        adrp    x0, fmt3                // Print third statement
        add     x0, x0, :lo12:fmt3
        bl      printf                  // Call print function

exit:
        ldp     fp, lr, [sp], dealloc
        ret 

        .balign 4
        .global sin

sin:
        stp     fp, lr, [sp, -16]! 
        mov     fp, sp 

        fdiv    d13, d14, d15 
        fmul    d0, d0, d13 

        adrp    x10, minimum                    // Load minimum
        add     x10, x10, :lo12:minimum 
        ldr     d5, [x10] 

        fmov    d12, d0                     // Move d0 into d12
        fmul    d12, d12, d12               

        fmov    num, d0                 // Move d0 into num
        fmov    factor, 1.0             // factor = 1.0
        fmov    expon, 1.0              // expon = 1.0
        fmov    incr, 1.0               // incr = 1.0
        fmov    expan, num              // Move num into expan
        fdiv    equ, num, factor        // Equ = num / factor

sin_next:
        fneg    num, num 
        fmul    num, num, d12 

        fadd    expon, expon, incr              // Exponent += 1
        fmul    factor, factor, expon           // Factorial *= exponent 

        fadd    expon, expon, incr              // Exponent +=  1
        fmul    factor, factor, expon           // Factorial *= exponent

        fdiv    equ, num, factor                // Equation = num / factor

        fadd    expan, expan, equ               // Expansion += equation
    
        fabs    equ, equ 
        fcmp    equ, d5 
        b.ge    sin_next 

        fmov    d0, expan               
        
        ldp     fp, lr, [sp], 16 
        ret     

        .balign 4
        .global cos

cos:
        stp     fp, lr, [sp, -16]! 
        mov     fp, sp 

        fdiv    d13, d14, d15 

        fmul    d0, d0, d13 

        adrp    x10, minimum                // Load minimum
        add     x10, x10, :lo12:minimum 
        ldr     d5, [x10] 

        fmov    d12, d0                 // Move d0 into d12
        fmul    d12, d12, d12           

        fmov    num, d12                    // Move d12 into num
        fmov    factor, 2.0                 // factor = 2.0 
        fmov    expon, 2.0                  // expon = 2.0
        fmov    incr, 1.0                   // incr = 1.0
        fmov    expan, 1.0                  // expan = 1.0

cos_next:
        fneg    num, num 
        fdiv    equ, num, factor            // Equation = Numerator / Factorial
        fmul    num, num, d12               

        fadd    expon, expon, incr          // Exponent += 1
        fmul    factor, factor, expon       // Factorial *= Exponent

        fadd    expon, expon, incr          // Exponent += 1
        fmul    factor, factor, expon           // Factorial *= Exponent

        fadd    expan, expan, equ               // Expansion += Equation

        fabs    equ, equ 
        fcmp    equ, d5 
        b.ge    cos_next 

        fmov    d0, expan 

        ldp     fp, lr, [sp], 16
        ret 



