# -------------------------------------------------------
# File:         test_piped.s
# Maintainer:   ziyue
# Date:         2021-05-11 12:42
# Purpose:      test some basic instructions of cpu core.
# -------------------------------------------------------

    addi    zero, zero, 0
    
# test I type
    addi    a0, zero, 7     # a0 = 0x0000_0007 04
    slti    a1, a0, 9       # a1 = 0x0000_0001 08
    sltiu   a2, a0, 8       # a2 = 0x0000_0001 0c
    xori    a3, a0, 8       # a3 = 0x0000_000F 10
    ori     a4, a0, 6       # a4 = 0x0000_0007 14
    andi    a5, a0, 6       # a5 = 0x0000_0006 18
    slli    a6, a0, 2       # a6 = 0x0000_001C 1c
    srli    a7, a0, 2       # a7 = 0x0000_0001 20
    srai    a7, a0, 0       # a7 = 0x0000_0007 24

# test R type
    add     s1, a0, a0      # s1 = 0x0000_000E 28
    sub     s2, a6, a0      # s2 = 0x0000_0015 2c
    sll     s3, a6, a3      # s3 = 0x000E_0000 30
    slt     s4, a0, s3      # s4 = 0x0000_0001 34
    xor     s5, a0, a3      # s5 = 0x0000_0008 38
    srl     s6, a0, a2      # s6 = 0x0000_0003 3c
    or      s7, a0, a4      # s7 = 0x0000_0007 40
    and     s8, a0, a2      # s8 = 0x0000_0001 44


# test LW and SW
    lw      s0, 0(zero)     # s0 = 0x1234_5678 48
    slli    s0, s0, 1       # s0 = 0x2468_acf0 4c
    sw      s0, 4(zero)     # (* no GPRs modified *) 50
    lw      a0, 4(zero)     # a0 = 0x2468_acf0 54
    
    bne     a0, a1, bne_target
    beq     zero, zero, end_b
    

# test JUMP and BRANCH

bne_target:
    addi    a3, zero, 0     # a3 = 0x0
    lw      s1, 0(zero)     # s1 = 0x1234_5678
    beq     a0, s1, end_b
    addi    s1, a0, 2       # a0 = 0x2468_acf2
    bge     a2, zero, bge_target
    beq     zero, zero, end_b

bge_target:
    addi    a3, a3, 1       # a3 = 0x1
    sub     a1, zero, a0    # a1 = 0xdb97_5310
    bltu    a0, a1, bltu_target
    beq     zero, zero, end_b

bltu_target:
    addi    a3, a3, 1       # a3 = 0x2
    blt     a0, a1, blt_target
    beq     zero, zero, end_b

blt_target:
    addi    a3, a3, 1
   
end_b:
    addi    zero, zero, 0
    addi	t6, zero, 1     # t6 = 1
	lui		t5, 0xbabe      # t5 = 0x0babe000

end:    
    jal		ra, func        # dead loop
    jal		zero, end
    
func:
	addi	zero, zero, 0
    jalr	zero, ra, 0