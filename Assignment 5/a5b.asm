// CPSC 355: a5b.asm
// Name: Adam Affan, UCID: 30160144

// Macros
define(argc_r, w19)
define(argv_r, x20)
define(month_r, w21)
define(day_r, w22)
define(year_r, w25)          
define(suffix_r, w24)
define(suffix_base_r, x22)
define(month_base_r, x23)

// Strings for all months
jan:    .string "January"       
feb:    .string "February"                                                          
mar:    .string "March"                                                           
apr:    .string "April"                                                          
may:    .string "May"                                                      
jun:    .string "June"                                                       
jul:    .string "July"                                                           
aug:    .string "August"                                                           
sep:    .string "September"                                                         
oct:    .string "October"                                                           
nov:    .string "November"                                                          
dec:    .string "December"        

// Strings for suffixes
th:     .string "th"                                                  
st:     .string "st"                                                                 
nd:     .string "nd"
rd:     .string "rd"

fmt1:   .string "%s %d%s, %d\n"			
fmt2:   .string "Usage: a5b mm dd yyyy\n"	
fmt3:   .string "ERROR\n"
    
        .data
        .balign 8
months: .dword  jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
suffixs:.dword  th, st, nd, rd

fp      .req x29        
lr      .req x30

        .text
        .balign 4
        .global main

main:   
        stp	fp, lr, [sp, -16]!                                                                
        mov	fp, sp                                                                              

        mov	argc_r, w0                                                          
        mov  	argv_r, x1                                                                                                                                                               
        cmp     argc_r, 4                        
        b.eq    next                                                       
        adrp    x0, fmt2                                                     
        add     x0, x0, :lo12:fmt2                                                 
        bl      printf                                                             
        b       done                                                                  
        
next:
        ldr	x0, [argv_r, 8]			        // Load first argument (mm)
        bl      atoi	 
        mov     month_r, w0								

        ldr     x0, [argv_r, 16]				// Load second argument (dd)					
        bl      atoi											
        mov     day_r, w0										

        ldr     x0, [argv_r, 24]                // Load third argument (yyyy)
        bl      atoi
        mov     year_r, w0

        cmp     month_r, 1						    // month >= 1
        b.lt    error								// Branch to error if less
        cmp     month_r, 12						    // month <= 12
        b.gt    error								// Branch to error if greater
        cmp     day_r, 1							// day >= 1
        b.lt    error								// Branch to error if less
        cmp     day_r, 31						    // day <= 31
        b.gt    error								// Branch to error if greater    

// Determine Suffix
        cmp     day_r, 1							// If day = 1
        b.eq    suffix1							// Branch to suffix1 (st)
        cmp     day_r, 21						// If day = 21
        b.eq    suffix1							// Branch to suffix1 (st)
        cmp     day_r, 31						// If day = 31
        b.eq    suffix1							// Branch to suff1 (st)

        cmp     day_r, 2							// If day = 2
        b.eq    suffix2							// Branch to suffix2 (nd)
        cmp     day_r, 22						// If day = 22
        b.eq    suffix2							// Branch to suffix2 (nd)

        cmp     day_r, 3							// If day = 3
        b.eq    suffix3							// Branch to suffix3 (rd)
        cmp     day_r, 23						// If day = 23
        b.eq    suffix3							// Branch to suffix3 (rd)

        mov     suffix_r, 0						// suffix_r = 0 ("th")
        b       output							// Branch to output

suffix1:
        mov     suffix_r, 1						// suffix_r = 1 ("st")
        b       output							// Branch to output

suffix2:
        mov     suffix_r, 2						// suffix_r = 2 ("nd")
        b       output							// Branch to output

suffix3:
        mov     suffix_r, 3						// suffix_r = 3 ("rd")
        b       output							// Branch to output



output:	
        adrp	x0, fmt1				            	    // Load address of display string
        add    	x0, x0, :lo12:fmt1			    		    

        adrp	month_base_r, months				        	// Get base address of months
        add    	month_base_r, month_base_r, :lo12:months		
        sub    	month_r, month_r, 1			                
        ldr    	x1, [month_base_r, month_r, SXTW #3]		    // Load month string

        mov    	w2, day_r					                    // Move day to w2

        adrp	suffix_base_r, suffixs			        	    // Get base address of suffixes
        add    	suffix_base_r, suffix_base_r, :lo12:suffixs	
      	ldr   	x3, [suffix_base_r, suffix_r, SXTW #3]	        // Load suffix string

        mov    	w4, year_r                                      // Move year to w4

        bl    	printf					                        // Call printf
        b    	done					                        

error:		
        adrp	x0, fmt3									// Load address of error message
        add    	x0, x0, :lo12:fmt3							
        bl    	printf						

done:
        ldp	fp, lr, [sp], 16							
        ret                                                                 

