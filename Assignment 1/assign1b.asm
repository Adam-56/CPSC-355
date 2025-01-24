// Optimized version Assignment 1


        // Define macros
        define(counter, x19)        // For loop counter
        define(temp, x20)           // Temporary register for constants
        define(x_reg, x21)          // Register for x
        define(equ_reg, x22)        // Register for equation
        define(y_reg, x23)          // Register for y 
        define(min, x24)            // Minimum register



fmt:    .string "x: %d, y: %d, Current Minimum: %d\n"   // Define format string 

        .global main                
        .balign 4

main:   
        stp    x29, x30, [sp, -16]!          
        mov    x29, sp                     

        mov    x_reg, 0               // x 
        mov    equ_reg, 0               // Equation register
        mov    y_reg, 0               // y 
        mov    counter, -11                // Set x19 (counter) to -11
        mov    min, 50000                  // Initialize minimum register to a large value

loop:   mov    x_reg, counter              // x = counter

        // Calculate y = 6x^4 - 333x^2 - 74x - 23
        mul    equ_reg, x_reg, x_reg       // x^2
        mul    temp, equ_reg, x_reg        // x^3
        mul    equ_reg, temp, x_reg        // x^4
        
        mov    temp, 6                     // Load 6
        mul    equ_reg, equ_reg, temp      // 6 * x^4
        
        mov    temp, -333                  // Load -333
        madd   equ_reg, temp, x_reg, equ_reg // -333 * x^2 + 6x^4

        mov    temp, -74                   // Load -74
        madd   equ_reg, temp, x_reg, equ_reg // -74 * x + previous result
        
        add    y_reg, equ_reg, -23         // y = result + (-23)

        cmp    y_reg, min                  
        b.ge   print                   

        mov    min, y_reg                  // Update minimum if y < min

        // Print x, y, and minimum
print:  adrp   x0, fmt                     // Load format string (high bits)
        add    x0, x0, :lo12:fmt           // Load format string (low bits)

        mov    x1, x_reg                   // Move x into x1 for printf
        mov    x2, y_reg                   // Move y into x2 for printf
        mov    x3, min                     // Move current minimum into x3 for printf

        bl     printf                      // Call printf

        add    counter, counter, 1         // Increment the loop counter
        
        cmp    counter, 9                  // Compare counter with 9
        b.le   loop                        // If counter <= 9, repeat loop

done:   mov    x0, 0                       
        ldp    x29, x30, [sp], 16          
        ret                                
