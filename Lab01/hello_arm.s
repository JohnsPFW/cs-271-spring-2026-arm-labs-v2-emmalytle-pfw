// Lab 0: Toolchain Verification
// CS 271 - Spring 2026
.global _start

_start:
    MOV X0, #42         // Load the answer to life into X0
    MOV X1, #0          // Clear X1
    ADD X2, X0, X1      // X2 = X0 + X1 = 42
    
    // Signal completion
    YIELD               // Tell the processor we are done

