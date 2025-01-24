
fmt:    .string "x: %d, y: %d, Current Minimum: %d\n"   // Define format string 

        .global main                
        .balign 4

main:   stp    x29, x30, [sp, -16]! 
        mov    x29, sp              

        mov    x19, -11              // Set x19 general purpose register to -1
        mov    x21, 0               // x 
        mov    x22, 0               // Equation register
        mov    x23, 0               // y 
        mov    x24, 50000             // minimum register 


test:   cmp    x19, 9
        b.ge   done                 // If loop counter >= 9, exit and branch to done
        
        mov    x21, x19             // Calculating x

        // Calculating y = 6x^4 - 333x^2 - 74x - 23
        mul    x22, x21, x21        // x * x = x^2
        mul    x22, x22, x21        // x^2 * x = x^3
        mul    x22, x22, x21        // x^3 * x^4
        mov    x20, 6               // Place 6 into x20
        mul    x22, x22, x20        // 6 * x^4
        mov    x23, x22             // 6x^4
        
        mul    x22, x21, x21        // x * x = x^2
        mov    x20, -333            // Place -333 into x20
        mul    x22, x22, x20        // -333 * x^2
        add    x23, x23, x22        // 6x^4 - 333x^2 in x23 register
        
        mov    x20, -74             // Place -74 into x20
        mul    x22, x21, x20        // -74 * x
        add    x23, x23, x22        // 6x^4 - 333x^2 - 74x
        
        mov    x20, -23             // Place -23 into x20
        add    x23, x23, x20        // 6x^4 - 333x^2 - 74x - 23
        
        cmp    x23, x24             // This is to compare y to the current minimum 
        b.ge   print                // If y >= current minimum then go to print
        mov    x24, x23             // Update the current minimum to y
        
print:  adrp   x0, fmt              // Set the 1st argument 
        add    x0, x0, :lo12:fmt     
        mov    x1, x21              // Set the 2nd argument 
        mov    x2, x23              // Set the 3rd argument 
        mov    x3, x24              // Set the 4th argument 

        bl     printf               // Call the printf() function
        
        
        add    x19, x19, 1          // Increment x  
        b      test                 
        
done:   mov    x0, 0                
        ldp    x29, x30, [sp], 16   
        ret                         

