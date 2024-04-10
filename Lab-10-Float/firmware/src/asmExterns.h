/* ************************************************************************** */
/** Descriptive File Name

  @Company
    Company Name

  @File Name
    filename.h

  @Summary
    Brief description of the file.

  @Description
    Describe the purpose of this file.
 */
/* ************************************************************************** */

#ifndef _ASM_EXTERNS_H    /* Guard against multiple inclusion */
#define _ASM_EXTERNS_H


/* ************************************************************************** */
/* ************************************************************************** */
/* Section: Included Files                                                    */
/* ************************************************************************** */
/* ************************************************************************** */

/* This section lists the other files that are included in this file.
 */

/* TODO:  Include other files here if needed. */


/* Provide C++ Compatibility */
#ifdef __cplusplus
extern "C" {
#endif

    // externs defined in the assembly file:
    extern uint32_t nameStrPtr;

    extern float f1,f2,fMax;
    extern uint32_t sb1,sb2,signBitMax;
    // adjusted UNBIASED (real) exponent
    extern int32_t realExp1,realExp2,realExpMax; // adjusted UNBIASED exponent
    // adjusted mantissa (hidden bit added when appropriate, 
    // see lecture for details)
    extern uint32_t mant1,mant2,mantMax; // adjusted mantissa (hidden bit added when appropriate))
    // exponent bits copied from float
    extern int32_t storedExp1,storedExp2,storedExpMax; // exponent bits copied from float
    extern uint32_t nanValue;

    /* Provide C++ Compatibility */
#ifdef __cplusplus
}
#endif

#endif /* _ASM_EXTERNS_H */

/* *****************************************************************************
 End of File
 */
