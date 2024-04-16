/*** asmFmax.s   ***/
#include <xc.h>
.syntax unified

@ Declare the following to be in data memory
.data  

@ Define the globals so that the C code can access them

/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "David McColl"  
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global f0,f1,fMax,signBitMax,storedExpMax,realExpMax,mantMax
.type f0,%gnu_unique_object
.type f1,%gnu_unique_object
.type fMax,%gnu_unique_object
.type signBitMax,%gnu_unique_object
.type storedExpMax,%gnu_unique_object
.type realExpMax,%gnu_unique_object
.type mantMax,%gnu_unique_object

.global sb0,sb1,storedExp0,storedExp1,realExp0,realExp1,mant0,mant1
.type sb1,%gnu_unique_object
.type sb2,%gnu_unique_object
.type storedExp0,%gnu_unique_object
.type storedExp1,%gnu_unique_object
.type realExp0,%gnu_unique_object
.type realExp1,%gnu_unique_object
.type mant0,%gnu_unique_object
.type mant1,%gnu_unique_object
 
.align
 // structure offsets...
.EQU FLOAT_OFF,	    0x0
.EQU SIGN_OFF,	    0x4
.EQU BIASED_OFF,    0x8
.EQU EXP_OFF,	    0xC
.EQU MANT_OFF,	    0x10
@ use these locations to store f1 values
f0: .word 0
sb0: .word 0
storedExp0: .word 0  /* the unmodified 8b exp value extracted from the float */
realExp0: .word 0
mant0: .word 0
 
@ use these locations to store f2 values
f1: .word 0
sb1: .word 0
realExp1: .word 0
storedExp1: .word 0  /* the unmodified 8b exp value extracted from the float */
mant1: .word 0
 
@ use these locations to store fMax values
fMax: .word 0
signBitMax: .word 0
storedExpMax: .word 0
realExpMax: .word 0
mantMax: .word 0

fZero: .word 0,0,0,0,0
    
.global nanValue 
.type nanValue,%gnu_unique_object
nanValue: .word 0x7FFFFFFF            

@ Tell the assembler that what follows is in instruction memory    
.text
.align

/********************************************************************
 function name: initVariables
    input:  none
    output: initializes all f1*, f2*, and *Max varibales to 0
********************************************************************/
.global initVariables
 .type initVariables,%function
initVariables:
    /* YOUR initVariables CODE BELOW THIS LINE! Don't forget to push and pop! */
    push {r4-r11,LR}
    LDR R0,=fZero
    LDR R1,=f0
    BL copy_struct
    LDR R1,=f1
    BL copy_struct
    LDR R1,=fMax
    BL copy_struct
    pop  {r4-r11,PC}
    /* YOUR initVariables CODE ABOVE THIS LINE! Don't forget to push and pop! */

    
/********************************************************************
 function name: getSignBit
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store sign bit (bit 31).
                Store a 1 if the sign bit is negative,
                Store a 0 if the sign bit is positive
                use sb0, sb1, or signBitMax for storage, as needed
    output: [r1]: mem location given by r1 contains the sign bit
********************************************************************/
.global getSignBit
.type getSignBit,%function
getSignBit:
    /* YOUR getSignBit CODE BELOW THIS LINE! Don't forget to push and pop! */
    push {r4-r11,LR}
    pop  {r4-r11,PC}
    /* YOUR getSignBit CODE ABOVE THIS LINE! Don't forget to push and pop! */
    

    
/********************************************************************
 function name: getExponent
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store "stored" (biased)
                bits 23-30 (exponent) 
                BIASED means the unpacked value (range 0-255) copied
                out of the original float. Make sure to shift exp to LSBs!
                Use storedExp0, storedExp1, or storedExpMax for storage, 
                as needed
            r2: address of mem to store unpacked REAL exponent
                bits 23-30 (exponent) 
                REAL means the unpacked value - 127
                NOTE: the real exponent may be changed later in asmFmax
                depending on whether the float is subnormal or +/- zero
                Use realExp0, realExp1, or realExpMax for storage, as needed
    output: [r1]: mem location given by r1 contains the unpacked
                  original (stored) exponent bits, in the lower 8b of the mem 
                  location
            [r2]: mem location given by r2 contains the unpacked
                  and UNBIASED exponent bits, in the lower 8b of the mem 
                  location
********************************************************************/
.global getExponent
.type getExponent,%function
getExponent:
    /* YOUR getExponent CODE BELOW THIS LINE! Don't forget to push and pop! */
    push {r4-r11,LR}
    pop  {r4-r11,PC}
    /* YOUR getExponent CODE ABOVE THIS LINE! Don't forget to push and pop! */
   

    
/********************************************************************
 function name: getMantissa
    input:  r0: address of mem containing 32b float to be unpacked
            r1: address of mem to store unpacked bits 0-22 (mantissa) 
                of 32b float. 
                NOTE: the mantissa may be changed later in asmFmax
                depending on whether the float is subnormal or +/- zero
                Use mant0, mant1, or mantMax for storage, as needed
    output: [r1]: mem location given by r1 contains the unpacked
                  mantissa bits
********************************************************************/
.global getMantissa
.type getMantissa,%function
getMantissa:
    /* YOUR getMantissa CODE BELOW THIS LINE! Don't forget to push and pop! */
    push {r4-r11,LR}
    pop  {r4-r11,PC}
    /* YOUR getMantissa CODE ABOVE THIS LINE! Don't forget to push and pop! */
   


    
/********************************************************************
function name: asmFmax
function description:
     max = asmFmax ( f0 , f1 )
     
where:
     f0, f1 are 32b floating point values passed in by the C caller
     max is the ADDRESS of fMax, where the greater of (f0,f1) must be stored
     
     if f0 equals f1, return either one
     notes:
        "greater than" means the most positive numeber.
        For example, -1 is greater than -200
     
     The function must also unpack the greater number and update the 
     following global variables prior to returning to the caller:
     
     signBitMax: 0 if the larger number is positive, otherwise 1
     realExpMax: The REAL exponent of the max value
                 i.e. the STORED exponent - 127 (or -126, see lecture
                 notes for details)
     mantMax:    the lower 23b unpacked from the larger number
     
     SEE LECTURE SLIDES FOR EXACT REQUIREMENTS on when and how to 
     adjust exponent and max values!


********************************************************************/    
.global asmFmax
.type asmFmax,%function
asmFmax:   

    /* YOUR asmFmax CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
    push {r4-r11,LR}
    BL initVariables    // copy fZero to f0,f1,fMax
    
    lDR R2,=f0
    STR R0,[R2,FLOAT_OFF]   // save f0 input to f0-struct
    LDR R2,=f1
    STR R1,[R2,FLOAT_OFF]   // save f1 input to f1-struct
    
    /* analyze the two floating point values */
    LDR R0,=f0             // R0= struct to extract
    BL  extract_parts
    LDR R0,=f1             // R0= struct to extract
    BL  extract_parts
    
    // ToDo : compare using the extracted parts
    // or just use sign/magnitude shortcut
    LDR R2,=0x7FFFFFFF   // magnitude mask
    LDR R0,=f0
    LDR R0,[R0,FLOAT_OFF]
    AND R0, R2           // extract magnitude
    LDR R1,=f1
    LDR R1,[R1,FLOAT_OFF]
    AND R1,R2           // extract magnitude
    CMP R0,R1           // compare magnitudes
    LDRGE R0,=f0
    LDRLT R0,=f1
    
    // assume src float in R0
    LDR R1,=fMax   // destination addr
    BL copy_struct
    LDR R0,=fMax   // return address(fMax)
    pop  {r4-r11,PC}
    /* YOUR asmFmax CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

   
// local function
copy_struct: // R0= from_struct addr, R1 = to_struct addr
    push {r4,LR} /* save the caller's registers */    
    LDR R4,[R0,FLOAT_OFF]  // read
    STR R4,[R1,FLOAT_OFF]  // write
    LDR R4,[R0,SIGN_OFF]
    STR R4,[R1,SIGN_OFF]
    LDR R4,[R0,BIASED_OFF]
    STR R4,[R1,BIASED_OFF]
    LDR R4,[R0,EXP_OFF]
    STR R4,[R1,EXP_OFF]
    LDR R4,[R0,MANT_OFF]
    STR R4,[R1,MANT_OFF]
    pop {r4,PC} /* restore the caller's registers */
 
    // local function
extract_parts: // void  extract_parts(struct float_parts*=R0)
    // R0-R3 unchanged,R0=float value R4=field value, R5=struct base addr, R6=Mask
    push {R4-R6,LR} /* save the caller's registers */
    MOV R5,R0             // R5 = base of structure
    LDR R0,[R5,FLOAT_OFF] // R0 = value of float
    LSR R4,R0,31          // R4 = field bits; get sign bit
    STR R4,[R5,SIGN_OFF]  // save sign bit
    
    LSR R4,R0,23          // shift out mantissa
    AND R4,0xFF           // mask 8 bit exp field
    STR R4,[R5,BIASED_OFF]// save biased exp
    SUB R4,127            // unbias
    STR R4,[R5,EXP_OFF]   // save exp
    
    LDR R6,=0x007FFFFF   // mantissa mask bits
    AND R4,R0,R6         // and-out non-mantissa bits
    LDR R6,=0x00800000   // hidden bit mask
    ORR R4,R4,R6         // orr-in hidden bit
    STR R4,[R5,MANT_OFF] // save mant
    pop {R4-R6,PC} /* restore the caller's registers */

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




