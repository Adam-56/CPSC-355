// CPSC 355: assign4.asm
// Name: Adam Affan, UCID: 30160144

// Assember equates
FALSE = 0
TRUE = 1

// Point struct equates
point_x = 0
point_y = 4

// Dimension struct equates
dimension_width = 0 
dimension_height = 4

// Box struct equates
box_origin = 0                                          
box_dimension = 8                                       
box_area = 16                                           
box_size = 20                                           

// Define first and second sizes for memory allocation
first_size = 20                                   
second_size = 20                                  
total_size = first_size + second_size

// More equates for first and second box 
first_s = 16                                            
second_s = first_s + box_size                       

// Allocation 
alloc = -(16 + total_size) & -16        
dealloc = -alloc

// Newbox allocation
newBox_alloc = -(16 + box_size) & -16                     
newBox_dealloc = -newBox_alloc    

fp      .req x29        
lr      .req x30                                             

// Define the strings
fmt1:   .string "Box %s origin = (%d, %d)  width = %d  height = %d   area = %d\n"
fmt2:   .string "Initial box values:\n"
fmt3:   .string "\nChanged box values:\n"
first:  .string "first"
second: .string "second"

        .balign 4

newBox:     
        stp     fp, lr, [sp, newBox_alloc]!                    
        mov     fp, sp                                         

        mov     w9, 1                                          

        str     xzr, [x1, box_origin + point_x]                 // Store 0 in b.origin.x 
        str     xzr, [x1, box_origin + point_y]                 // Store 0 in b.origin.y

        str     w9, [x1, box_dimension + dimension_width]       // Store 1 in b.size.width
        str     w9, [x1, box_dimension + dimension_height]      // Store 1 in b.size.height

        str     w9, [x1, box_area]                              

        ldp     fp, lr, [sp], newBox_dealloc                    
        ret                                                     

move:       
        stp     fp, lr, [sp, -16]!                              
        mov     fp, sp                                          

        ldr     w9, [x0, box_origin + point_x]                  // Load w9 to b->origin.x
        add     w9, w9, w1                                      // w9 = b->origin.x += deltaX
        str     w9, [x0, box_origin + point_x]                  // Store result back into the memory

        ldr     w9, [x0, box_origin + point_y]                  // Load w9 to b->origin.y
        add     w9, w9, w2                                      // w9 = b->origin.y += deltaY
        str     w9, [x0, box_origin + point_y]                  // Store result back into the memory

        ldp     fp, lr, [sp], 16                                
        ret                                                     

expand:     
        stp     fp, lr, [sp, -16]!                              
        mov     fp, sp                                          

        ldr     w9, [x0, box_dimension + dimension_width]       // Load w9 to b->size.width
        mul     w9, w9, w1                                      // b->size.width *= factor
        str     w9, [x0, box_dimension + dimension_width]       // Store result back into the memory

        ldr     w10, [x0, box_dimension + dimension_height]     // Load w10 to b->size.height 
        mul     w10, w10, w1                                    // b->size.height *= factor
        str     w10, [x0, box_dimension + dimension_height]     // Store result back into the memory

        mul     w9, w9, w10                                     // Multiply width * height 
        str     w9, [x0, box_area]                              // Store result back into the memory

        mov     w0, 0
        ldp     fp, lr, [sp], 16                                
        ret                                                     

printBox:   
        stp     fp, lr, [sp, -16]!                              
        mov     fp, sp                                          

        ldr     w2, [x1, box_origin + point_x]                  // Load the arguments 
        ldr     w3, [x1, box_origin + point_y]                  
        ldr     w4, [x1, box_dimension + dimension_width]       
        ldr     w5, [x1, box_dimension + dimension_height]      
        ldr     w6, [x1, box_area]                              
        
        mov     x1, x0 
        adrp    x0, fmt1                                        // Add fmt1 to x0
        add     x0, x0, :lo12:fmt1                              
        bl      printf                                          // Call the print function

        ldp     fp, lr, [sp], 16                                
        ret                                                     

equal:		
        stp     fp, lr, [sp, -16]!					            
        mov     fp, sp							                

        ldr     w10, [x0, box_origin + point_x]				    // Load w10 to b1->origin.x
        ldr     w11, [x1, box_origin + point_x]				    // Load w11 to b2->origin.x
        cmp     w10, w11							            // Compare w10 and w11
        b.ne    ret1							                // If not equal, then return false (ret1)

        ldr     w10, [x0, box_origin + point_y]				    // Load w10 to b1->origin.y
        ldr     w11, [x1, box_origin + point_y]				    // Load w11 to b2->origin.y
        cmp     w10, w11							            // Compare w10 and w11
        b.ne    ret1							                // If not equal, then return false (ret1)

        ldr     w10, [x0, box_dimension + dimension_width]	    // Load w10 to b1->size.width
        ldr     w11, [x1, box_dimension + dimension_width]		// Load w11 to b2->size.width
        cmp     w10, w11							            // Compare w10 and w11
        b.ne    ret1							                // If not equal, then return false (ret1)

        ldr     w10, [x0, box_dimension + dimension_height]		// Load w10 to b1->size.height
        ldr     w11, [x1, box_dimension + dimension_height]		// Load w11 to b2->size.height
        cmp     w10, w11							            // Compare w10 and w11
        b.ne    ret1							                // If not equal, then return false (ret1)

        mov     x0, TRUE							            // Set x0 to TRUE
        b       equal_done                                      // Branch to equal_done

ret1:  
        mov     w0, FALSE                                       // Set w0 to FALSE

equal_done:	
        ldp     fp, lr, [sp], 16						        
	ret								                           

        .global main
main:   
        stp     fp, lr, [sp, alloc]!                            // Allocate memory
        mov     fp, sp                                          // Update fp

        add     x1, fp, first_s                                 // Store fp and first_s in x1
        bl      newBox                                          // Call newBox function
        
        add     x1, fp, second_s                                // Store fp and second_s in x1
        bl      newBox                                          // Call newBox function

        adrp    x0, fmt2                                        // Add fmt2 to x0
        add     x0, x0, :lo12:fmt2                              
        bl      printf                                          // Call the print function

        adrp    x0, first                                       // Add first to x0
        add     x0, x0, :lo12:first                             
        add     x1, fp, first_s                                 
        bl      printBox                                        // Call printBox function

        adrp    x0, second                                      // Add second to x0
        add     x0, x0, :lo12:second                            
        add     x1, fp, second_s                                
        bl      printBox                                        // Call printBox function

        add     x0, fp, first_s                                 
        add     x1, fp, second_s                                
        bl      equal                                           
        cmp     w0, FALSE                                       
        b.eq    next                                            

        add     x0, fp, first_s                                 // Load fp and first_s into x0
        mov     w1, -5                                          // Load -5 into w1
        mov     w2, 7                                           // Load 7 into w2
        bl      move                                            // Call move function

        add     x0, fp, second_s                                // Load fp and second_s into x0
        mov     w1, 3                                           // Load 3 into w1
        bl      expand                                          // Call expand function

next:
        adrp    x0, fmt3                                        // Add fmt3 to x0
        add     x0, x0, :lo12:fmt3                              
        bl      printf                                          // Call the print function

        adrp    x0, first                                       // Add first to x0
        add     x0, x0, :lo12:first                             
        add     x1, fp, first_s                                 
        bl      printBox                                        // Call printBox function

        adrp    x0, second                                      // Add second to x0
        add     x0, x0, :lo12:second                            
        add     x1, fp, second_s                                
        bl      printBox                                        // Call printBox function  

done:       
        ldp     fp, lr, [sp], dealloc                           // Deallocate memory
        ret                  
