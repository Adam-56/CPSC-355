// CPSC 355: assign3.asm
// Name: Adam Affan, UCID: 30160144

define(i, w19)                                  
define(random, w20)                             
define(j, w22)                                  
define(vj_r, w24)                               
define(temp, w25)                               

// Define the strings 
fmt1:   .string "v[%d]: %d\n"                           
fmt2:   .string "\nSorted array:\n"                   

	// Assembler equates
	SIZE = 80                                       // Set SIZE to 80
        i_size = 4                                      // Size of i is 4 bytes
        j_size = 4                                      // Size of j is 4 bytes
        v_size = 4 * SIZE                               // Size of v is 4 bytes * 80 

	alloc = -(16 + i_size + j_size + v_size) & -16
        dealloc = -alloc 

        i_s = 16 					// Size of i offset
        j_s = i_s + j_size 				// Size of j offset
        arr_s = j_s + i_size 				// Size of array offset
        temp_s = 0

        .balign 4       
        .global main        
    
main:       
	stp     x29, x30, [sp, alloc]!                    
	mov     x29, sp                            
    
        add     x28, x29, arr_s                         // Calculate array address

        mov     i, 0                                
        str     i, [x29, i_s]                     
        b       test1                               

outloop:                                          
        bl      rand                                    // Generate the random number
        ldr     i, [x29, i_s]                           // i from stack
        and     random, w0, 0x1FF                       // 0x1FF, mod 512
        str     random, [x28, i, SXTW 2]                // Random to array

        adrp    x0, fmt1                                // Print
        add     w0, w0, :lo12:fmt1                 
        mov     w1, i                               
        mov     w2, random                           
        bl      printf                             

        add     i, i, 1                                 // i++
        str     i, [x29, i_s]                           // i to stack

test1:                                                  // Tests if i < 80, then branch to test2
        cmp     i, SIZE                                 // If i < 80 then branch to outloop
        b.lt    outloop                               

        mov     i, SIZE                             
        sub     i, i, 1                                 // i--
        str     i, [x29, i_s]                           // i to stack
        b       test2                                   // Branch to test2

inloop:                                                 // Sorting the arrays
        ldr     w23, [x28, j, SXTW 2]                   // Read v[j]
        sub     vj_r, j, 1                              // vj_r = j - 1
        ldr     random, [x28, vj_r, SXTW 2]             
        cmp     random, w23                             // Compare v[j-1] with v[j]
        b.lt    in_next                                

        add     sp, sp, -4 & -16                    
        mov     temp, random                            
        str     temp, [x29, temp_s]                     // Store temp in stack
        mov     random, w23                             // v[j-1] = v[j]
        str     random, [x28, vj_r, SXTW 2]             // v[j-1] to array
        
        mov     w23, temp                               
        str     w23, [x28, j, SXTW 2]                   // v[j] to array
        add     sp, sp, 16                              

in_next:                                           
        add     j, j, 1                                 // j++


test3:                                          
        cmp     j, i                                    // if j <= i then branch to inloop
        b.le    inloop                                  

        sub     i, i, 1                                 // i--

test2:                                                  // Innitializes j to 1
        mov     j, 1                                    // j = 1
        str     j, [x29, j_s]                           // Write index j to stack

        cmp     i, 0                                    // if i >= 0 then branch to test3
        b.ge    test3                                   

        mov     i, 0                                    // i = 0
        str     i, [x29, i_s]                           // Write index i to stack

        adrp    x0, fmt2                          
        add     w0, w0, :lo12:fmt2                
        mov     w1, 0                              
        bl      printf                               
        b       printtest                           

printloop:                                      
        ldr     w26, [x28, i, SXTW 2]                  
        adrp    x0, fmt1                         
        add     w0, w0, :lo12:fmt1                
        mov     w1, i                              
        mov     w2, w26                             
        bl      printf                              
        add     i, i, 1                                 // i++

printtest:                                      
        cmp     i, SIZE                                 // if i < size then branch to print
        b.lt    printloop                                

done:
        mov     w0, 0                               
        ldp     x29, x30, [sp], dealloc              
        ret                                         

