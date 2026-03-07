// =============================================================================
// CS 271 Computer Architecture - Lab 01: String Copy (STRCPY)
// Purdue University Fort Wayne
// =============================================================================
// STUDENT NAME: Emma Lytle
// DATE: 02/25/2026
// =============================================================================
// OBJECTIVE:
//   Implement a loop that copies a null-terminated string from a source
//   address to a destination address, simulating the classic C strcpy()
//   function.
//
// MEMORY LAYOUT:
//   - Source string starts at address 0x50 (80 decimal)
//   - Destination buffer starts at address 0x13C (316 decimal)
//   - The source string is: "Hello" (5 characters + null terminator)
//
// EXPECTED OUTCOME:
//   - The string "Hello" should be copied to the destination
//   - Your loop should iterate 6 times (5 letters + 1 null terminator)
//   - Simulation output: "[EDUCORE LOG]: Apollo has landed"
//
// INSTRUCTIONS:
//   1. Complete the TODO sections below (5 lines of code total)
//   2. Run: make sim_lab01
//   3. Verify success with "Apollo has landed" message
//   4. (Optional) Open Surfer to view waveforms
// =============================================================================

    .text
    .global _start

_start:
    // =========================================================================
    // STEP 1: Initialize Pointers (Already done for you)
    // =========================================================================
    // These lines set up X0 to point to the source string
    // and X1 to point to the destination buffer.
    // DO NOT MODIFY these two lines.
    
    MOV     X0, #5       // loop counter starting at 5
    MOV     X4, #0       // running sum
    MOV     X5, #0       // iteration counter
    MOV     X1, #1      // destination pointer (address 0x13C)

    // =========================================================================
    // STEP 2: Implement the Copy Loop (YOUR CODE GOES HERE)
    // =========================================================================
    // You need to write 5 instructions inside this loop:
    //   1. Load a byte from source
    //   2. Store that byte to destination
    //   3. Check if it was the null terminator
    //   4. Increment both pointers
    //   5. Loop back
    
    

sum_loop:
    ADD     X4, X4, X0      // Add counter into running sum
    ADD     X5, X5, X1      // Increment iteration count
    SUBS    X0, X0, X1      // Decrement counter and set flags
    B.NE    sum_loop        // Loop again while X0 != 0




done:
    // When your loop exits (after copying the null terminator),
    // execution reaches here and YIELD signals success.
    YIELD
