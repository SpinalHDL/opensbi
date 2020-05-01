
build/platform/litex/vexriscv/firmware/fw_jump.elf:     file format elf32-littleriscv


Disassembly of section .text:

40f00000 <_fw_start>:
	.align 3
	.globl _start
	.globl _start_warm
_start:
	/* Find preferred boot HART id */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f00000:	00050433          	add	s0,a0,zero
40f00004:	000584b3          	add	s1,a1,zero
40f00008:	00060933          	add	s2,a2,zero
	call	fw_boot_hart
40f0000c:	764000ef          	jal	ra,40f00770 <fw_boot_hart>
	add	a6, a0, zero
40f00010:	00050833          	add	a6,a0,zero
	MOV_3R	a0, s0, a1, s1, a2, s2
40f00014:	00040533          	add	a0,s0,zero
40f00018:	000485b3          	add	a1,s1,zero
40f0001c:	00090633          	add	a2,s2,zero
	li	a7, -1
40f00020:	fff00893          	li	a7,-1
	beq	a6, a7, _try_lottery
40f00024:	01180463          	beq	a6,a7,40f0002c <_try_lottery>
	/* Jump to relocation wait loop if we are not boot hart */
	bne	a0, a6, _wait_relocate_copy_done
40f00028:	17051063          	bne	a0,a6,40f00188 <_wait_relocate_copy_done>

40f0002c <_try_lottery>:
_try_lottery:
	/* Jump to relocation wait loop if we don't get relocation lottery */
	la	a6, _relocate_lottery
40f0002c:	00000817          	auipc	a6,0x0
40f00030:	4bc80813          	addi	a6,a6,1212 # 40f004e8 <_relocate_lottery>
	li	a7, 1
40f00034:	00100893          	li	a7,1
	amoadd.w a6, a7, (a6)
40f00038:	0118282f          	amoadd.w	a6,a7,(a6)
	bnez	a6, _wait_relocate_copy_done
40f0003c:	14081663          	bnez	a6,40f00188 <_wait_relocate_copy_done>

	/* Save load address */
	la	t0, _load_start
40f00040:	00000297          	auipc	t0,0x0
40f00044:	4b028293          	addi	t0,t0,1200 # 40f004f0 <_load_start>
	la	t1, _start
40f00048:	00000317          	auipc	t1,0x0
40f0004c:	fb830313          	addi	t1,t1,-72 # 40f00000 <_fw_start>
	REG_S	t1, 0(t0)
40f00050:	0062a023          	sw	t1,0(t0)

40f00054 <_relocate>:

	/* Relocate if load address != link address */
_relocate:
	la	t0, _link_start
40f00054:	00000297          	auipc	t0,0x0
40f00058:	4a028293          	addi	t0,t0,1184 # 40f004f4 <_link_start>
	REG_L	t0, 0(t0)
40f0005c:	0002a283          	lw	t0,0(t0)
	la	t1, _link_end
40f00060:	00000317          	auipc	t1,0x0
40f00064:	49830313          	addi	t1,t1,1176 # 40f004f8 <_link_end>
	REG_L	t1, 0(t1)
40f00068:	00032303          	lw	t1,0(t1)
	la	t2, _load_start
40f0006c:	00000397          	auipc	t2,0x0
40f00070:	48438393          	addi	t2,t2,1156 # 40f004f0 <_load_start>
	REG_L	t2, 0(t2)
40f00074:	0003a383          	lw	t2,0(t2)
	sub	t3, t1, t0
40f00078:	40530e33          	sub	t3,t1,t0
	add	t3, t3, t2
40f0007c:	007e0e33          	add	t3,t3,t2
	beq	t0, t2, _relocate_done
40f00080:	14728a63          	beq	t0,t2,40f001d4 <_relocate_done>
	la	t4, _relocate_done
40f00084:	00000e97          	auipc	t4,0x0
40f00088:	150e8e93          	addi	t4,t4,336 # 40f001d4 <_relocate_done>
	sub	t4, t4, t2
40f0008c:	407e8eb3          	sub	t4,t4,t2
	add	t4, t4, t0
40f00090:	005e8eb3          	add	t4,t4,t0
	blt	t2, t0, _relocate_copy_to_upper
40f00094:	0653ce63          	blt	t2,t0,40f00110 <_relocate_copy_to_upper>

40f00098 <_relocate_copy_to_lower>:
_relocate_copy_to_lower:
	ble	t1, t2, _relocate_copy_to_lower_loop
40f00098:	0663d063          	bge	t2,t1,40f000f8 <_relocate_copy_to_lower_loop>
	la	t3, _relocate_lottery
40f0009c:	00000e17          	auipc	t3,0x0
40f000a0:	44ce0e13          	addi	t3,t3,1100 # 40f004e8 <_relocate_lottery>
	BRANGE	t2, t1, t3, _start_hang
40f000a4:	007e4663          	blt	t3,t2,40f000b0 <_relocate_copy_to_lower+0x18>
40f000a8:	006e5463          	bge	t3,t1,40f000b0 <_relocate_copy_to_lower+0x18>
40f000ac:	4ac0006f          	j	40f00558 <_start_hang>
	la	t3, _boot_status
40f000b0:	00000e17          	auipc	t3,0x0
40f000b4:	43ce0e13          	addi	t3,t3,1084 # 40f004ec <_boot_status>
	BRANGE	t2, t1, t3, _start_hang
40f000b8:	007e4663          	blt	t3,t2,40f000c4 <_relocate_copy_to_lower+0x2c>
40f000bc:	006e5463          	bge	t3,t1,40f000c4 <_relocate_copy_to_lower+0x2c>
40f000c0:	4980006f          	j	40f00558 <_start_hang>
	la	t3, _relocate
40f000c4:	00000e17          	auipc	t3,0x0
40f000c8:	f90e0e13          	addi	t3,t3,-112 # 40f00054 <_relocate>
	la	t5, _relocate_done
40f000cc:	00000f17          	auipc	t5,0x0
40f000d0:	108f0f13          	addi	t5,t5,264 # 40f001d4 <_relocate_done>
	BRANGE	t2, t1, t3, _start_hang
40f000d4:	007e4663          	blt	t3,t2,40f000e0 <_relocate_copy_to_lower+0x48>
40f000d8:	006e5463          	bge	t3,t1,40f000e0 <_relocate_copy_to_lower+0x48>
40f000dc:	47c0006f          	j	40f00558 <_start_hang>
	BRANGE	t2, t1, t5, _start_hang
40f000e0:	007f4663          	blt	t5,t2,40f000ec <_relocate_copy_to_lower+0x54>
40f000e4:	006f5463          	bge	t5,t1,40f000ec <_relocate_copy_to_lower+0x54>
40f000e8:	4700006f          	j	40f00558 <_start_hang>
	BRANGE  t3, t5, t2, _start_hang
40f000ec:	01c3c663          	blt	t2,t3,40f000f8 <_relocate_copy_to_lower_loop>
40f000f0:	01e3d463          	bge	t2,t5,40f000f8 <_relocate_copy_to_lower_loop>
40f000f4:	4640006f          	j	40f00558 <_start_hang>

40f000f8 <_relocate_copy_to_lower_loop>:
_relocate_copy_to_lower_loop:
	REG_L	t3, 0(t2)
40f000f8:	0003ae03          	lw	t3,0(t2)
	REG_S	t3, 0(t0)
40f000fc:	01c2a023          	sw	t3,0(t0)
	add	t0, t0, __SIZEOF_POINTER__
40f00100:	00428293          	addi	t0,t0,4
	add	t2, t2, __SIZEOF_POINTER__
40f00104:	00438393          	addi	t2,t2,4
	blt	t0, t1, _relocate_copy_to_lower_loop
40f00108:	fe62c8e3          	blt	t0,t1,40f000f8 <_relocate_copy_to_lower_loop>
	jr	t4
40f0010c:	000e8067          	jr	t4

40f00110 <_relocate_copy_to_upper>:
_relocate_copy_to_upper:
	ble	t3, t0, _relocate_copy_to_upper_loop
40f00110:	07c2d063          	bge	t0,t3,40f00170 <_relocate_copy_to_upper_loop>
	la	t2, _relocate_lottery
40f00114:	00000397          	auipc	t2,0x0
40f00118:	3d438393          	addi	t2,t2,980 # 40f004e8 <_relocate_lottery>
	BRANGE	t0, t3, t2, _start_hang
40f0011c:	0053c663          	blt	t2,t0,40f00128 <_relocate_copy_to_upper+0x18>
40f00120:	01c3d463          	bge	t2,t3,40f00128 <_relocate_copy_to_upper+0x18>
40f00124:	4340006f          	j	40f00558 <_start_hang>
	la	t2, _boot_status
40f00128:	00000397          	auipc	t2,0x0
40f0012c:	3c438393          	addi	t2,t2,964 # 40f004ec <_boot_status>
	BRANGE	t0, t3, t2, _start_hang
40f00130:	0053c663          	blt	t2,t0,40f0013c <_relocate_copy_to_upper+0x2c>
40f00134:	01c3d463          	bge	t2,t3,40f0013c <_relocate_copy_to_upper+0x2c>
40f00138:	4200006f          	j	40f00558 <_start_hang>
	la	t2, _relocate
40f0013c:	00000397          	auipc	t2,0x0
40f00140:	f1838393          	addi	t2,t2,-232 # 40f00054 <_relocate>
	la	t5, _relocate_done
40f00144:	00000f17          	auipc	t5,0x0
40f00148:	090f0f13          	addi	t5,t5,144 # 40f001d4 <_relocate_done>
	BRANGE	t0, t3, t2, _start_hang
40f0014c:	0053c663          	blt	t2,t0,40f00158 <_relocate_copy_to_upper+0x48>
40f00150:	01c3d463          	bge	t2,t3,40f00158 <_relocate_copy_to_upper+0x48>
40f00154:	4040006f          	j	40f00558 <_start_hang>
	BRANGE	t0, t3, t5, _start_hang
40f00158:	005f4663          	blt	t5,t0,40f00164 <_relocate_copy_to_upper+0x54>
40f0015c:	01cf5463          	bge	t5,t3,40f00164 <_relocate_copy_to_upper+0x54>
40f00160:	3f80006f          	j	40f00558 <_start_hang>
	BRANGE	t2, t5, t0, _start_hang
40f00164:	0072c663          	blt	t0,t2,40f00170 <_relocate_copy_to_upper_loop>
40f00168:	01e2d463          	bge	t0,t5,40f00170 <_relocate_copy_to_upper_loop>
40f0016c:	3ec0006f          	j	40f00558 <_start_hang>

40f00170 <_relocate_copy_to_upper_loop>:
_relocate_copy_to_upper_loop:
	add	t3, t3, -__SIZEOF_POINTER__
40f00170:	ffce0e13          	addi	t3,t3,-4
	add	t1, t1, -__SIZEOF_POINTER__
40f00174:	ffc30313          	addi	t1,t1,-4
	REG_L	t2, 0(t3)
40f00178:	000e2383          	lw	t2,0(t3)
	REG_S	t2, 0(t1)
40f0017c:	00732023          	sw	t2,0(t1)
	blt	t0, t1, _relocate_copy_to_upper_loop
40f00180:	fe62c8e3          	blt	t0,t1,40f00170 <_relocate_copy_to_upper_loop>
	jr	t4
40f00184:	000e8067          	jr	t4

40f00188 <_wait_relocate_copy_done>:
_wait_relocate_copy_done:
	la	t0, _start
40f00188:	00000297          	auipc	t0,0x0
40f0018c:	e7828293          	addi	t0,t0,-392 # 40f00000 <_fw_start>
	la	t1, _link_start
40f00190:	00000317          	auipc	t1,0x0
40f00194:	36430313          	addi	t1,t1,868 # 40f004f4 <_link_start>
	REG_L	t1, 0(t1)
40f00198:	00032303          	lw	t1,0(t1)
	beq	t0, t1, _wait_for_boot_hart
40f0019c:	2a628c63          	beq	t0,t1,40f00454 <_wait_for_boot_hart>
	la	t2, _boot_status
40f001a0:	00000397          	auipc	t2,0x0
40f001a4:	34c38393          	addi	t2,t2,844 # 40f004ec <_boot_status>
	la	t3, _wait_for_boot_hart
40f001a8:	00000e17          	auipc	t3,0x0
40f001ac:	2ace0e13          	addi	t3,t3,684 # 40f00454 <_wait_for_boot_hart>
	sub	t3, t3, t0
40f001b0:	405e0e33          	sub	t3,t3,t0
	add	t3, t3, t1
40f001b4:	006e0e33          	add	t3,t3,t1
1:
	/* waitting for relocate copy done (_boot_status == 1) */
	li	t4, BOOT_STATUS_RELOCATE_DONE
40f001b8:	00100e93          	li	t4,1
	REG_L	t5, 0(t2)
40f001bc:	0003af03          	lw	t5,0(t2)
	/* Reduce the bus traffic so that boot hart may proceed faster */
	nop
40f001c0:	00000013          	nop
	nop
40f001c4:	00000013          	nop
	nop
40f001c8:	00000013          	nop
	bgt     t4, t5, 1b
40f001cc:	ffdf46e3          	blt	t5,t4,40f001b8 <_wait_relocate_copy_done+0x30>
	jr	t3
40f001d0:	000e0067          	jr	t3

40f001d4 <_relocate_done>:

	/*
	 * Mark relocate copy done
	 * Use _boot_status copy relative to the load address
	 */
	la	t0, _boot_status
40f001d4:	00000297          	auipc	t0,0x0
40f001d8:	31828293          	addi	t0,t0,792 # 40f004ec <_boot_status>
	la	t1, _link_start
40f001dc:	00000317          	auipc	t1,0x0
40f001e0:	31830313          	addi	t1,t1,792 # 40f004f4 <_link_start>
	REG_L	t1, 0(t1)
40f001e4:	00032303          	lw	t1,0(t1)
	la	t2, _load_start
40f001e8:	00000397          	auipc	t2,0x0
40f001ec:	30838393          	addi	t2,t2,776 # 40f004f0 <_load_start>
	REG_L	t2, 0(t2)
40f001f0:	0003a383          	lw	t2,0(t2)
	sub	t0, t0, t1
40f001f4:	406282b3          	sub	t0,t0,t1
	add	t0, t0, t2
40f001f8:	007282b3          	add	t0,t0,t2
	li	t1, BOOT_STATUS_RELOCATE_DONE
40f001fc:	00100313          	li	t1,1
	REG_S	t1, 0(t0)
40f00200:	0062a023          	sw	t1,0(t0)
	fence	rw, rw
40f00204:	0330000f          	fence	rw,rw

	/* At this point we are running from link address */

	/* Reset all registers for boot HART */
	li	ra, 0
40f00208:	00000093          	li	ra,0
	call	_reset_regs
40f0020c:	4ec000ef          	jal	ra,40f006f8 <_reset_regs>

	/* Allow main firmware to save info */
	MOV_5R	s0, a0, s1, a1, s2, a2, s3, a3, s4, a4
40f00210:	00050433          	add	s0,a0,zero
40f00214:	000584b3          	add	s1,a1,zero
40f00218:	00060933          	add	s2,a2,zero
40f0021c:	000689b3          	add	s3,a3,zero
40f00220:	00070a33          	add	s4,a4,zero
	call	fw_save_info
40f00224:	554000ef          	jal	ra,40f00778 <fw_save_info>
	MOV_5R	a0, s0, a1, s1, a2, s2, a3, s3, a4, s4
40f00228:	00040533          	add	a0,s0,zero
40f0022c:	000485b3          	add	a1,s1,zero
40f00230:	00090633          	add	a2,s2,zero
40f00234:	000986b3          	add	a3,s3,zero
40f00238:	000a0733          	add	a4,s4,zero

	/* Preload HART details
	 * s7 -> HART Count
	 * s8 -> HART Stack Size
	 */
	la	a4, platform
40f0023c:	0000a717          	auipc	a4,0xa
40f00240:	34070713          	addi	a4,a4,832 # 40f0a57c <platform>
#if __riscv_xlen == 64
	lwu	s7, SBI_PLATFORM_HART_COUNT_OFFSET(a4)
	lwu	s8, SBI_PLATFORM_HART_STACK_SIZE_OFFSET(a4)
#else
	lw	s7, SBI_PLATFORM_HART_COUNT_OFFSET(a4)
40f00244:	05072b83          	lw	s7,80(a4)
	lw	s8, SBI_PLATFORM_HART_STACK_SIZE_OFFSET(a4)
40f00248:	05472c03          	lw	s8,84(a4)
#endif

	/* Setup scratch space for all the HARTs*/
	la	tp, _fw_end
40f0024c:	0000d217          	auipc	tp,0xd
40f00250:	db420213          	addi	tp,tp,-588 # 40f0d000 <_fw_end>
	mul	a5, s7, s8
40f00254:	038b87b3          	mul	a5,s7,s8
	add	tp, tp, a5
40f00258:	00f20233          	add	tp,tp,a5
	/* Keep a copy of tp */
	add	t3, tp, zero
40f0025c:	00020e33          	add	t3,tp,zero
	/* Counter */
	li	t2, 1
40f00260:	00100393          	li	t2,1
	/* hartid 0 is mandated by ISA */
	li	t1, 0
40f00264:	00000313          	li	t1,0

40f00268 <_scratch_init>:
_scratch_init:
	add	tp, t3, zero
40f00268:	000e0233          	add	tp,t3,zero
	mul	a5, s8, t1
40f0026c:	026c07b3          	mul	a5,s8,t1
	sub	tp, tp, a5
40f00270:	40f20233          	sub	tp,tp,a5
	li	a5, SBI_SCRATCH_SIZE
40f00274:	10000793          	li	a5,256
	sub	tp, tp, a5
40f00278:	40f20233          	sub	tp,tp,a5

	/* Initialize scratch space */
	/* Store fw_start and fw_size in scratch space */
	la	a4, _fw_start
40f0027c:	00000717          	auipc	a4,0x0
40f00280:	d8470713          	addi	a4,a4,-636 # 40f00000 <_fw_start>
	la	a5, _fw_end
40f00284:	0000d797          	auipc	a5,0xd
40f00288:	d7c78793          	addi	a5,a5,-644 # 40f0d000 <_fw_end>
	mul	t0, s7, s8
40f0028c:	038b82b3          	mul	t0,s7,s8
	add	a5, a5, t0
40f00290:	005787b3          	add	a5,a5,t0
	sub	a5, a5, a4
40f00294:	40e787b3          	sub	a5,a5,a4
	REG_S	a4, SBI_SCRATCH_FW_START_OFFSET(tp)
40f00298:	00e22023          	sw	a4,0(tp) # 0 <_fw_start-0x40f00000>
	REG_S	a5, SBI_SCRATCH_FW_SIZE_OFFSET(tp)
40f0029c:	00f22223          	sw	a5,4(tp) # 4 <_fw_start-0x40effffc>
	/* Store next arg1 in scratch space */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f002a0:	00050433          	add	s0,a0,zero
40f002a4:	000584b3          	add	s1,a1,zero
40f002a8:	00060933          	add	s2,a2,zero
	call	fw_next_arg1
40f002ac:	4dc000ef          	jal	ra,40f00788 <fw_next_arg1>
	REG_S	a0, SBI_SCRATCH_NEXT_ARG1_OFFSET(tp)
40f002b0:	00a22423          	sw	a0,8(tp) # 8 <_fw_start-0x40effff8>
	MOV_3R	a0, s0, a1, s1, a2, s2
40f002b4:	00040533          	add	a0,s0,zero
40f002b8:	000485b3          	add	a1,s1,zero
40f002bc:	00090633          	add	a2,s2,zero
	/* Store next address in scratch space */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f002c0:	00050433          	add	s0,a0,zero
40f002c4:	000584b3          	add	s1,a1,zero
40f002c8:	00060933          	add	s2,a2,zero
	call	fw_next_addr
40f002cc:	4c4000ef          	jal	ra,40f00790 <fw_next_addr>
	REG_S	a0, SBI_SCRATCH_NEXT_ADDR_OFFSET(tp)
40f002d0:	00a22623          	sw	a0,12(tp) # c <_fw_start-0x40effff4>
	MOV_3R	a0, s0, a1, s1, a2, s2
40f002d4:	00040533          	add	a0,s0,zero
40f002d8:	000485b3          	add	a1,s1,zero
40f002dc:	00090633          	add	a2,s2,zero
	/* Store next mode in scratch space */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f002e0:	00050433          	add	s0,a0,zero
40f002e4:	000584b3          	add	s1,a1,zero
40f002e8:	00060933          	add	s2,a2,zero
	call	fw_next_mode
40f002ec:	4b4000ef          	jal	ra,40f007a0 <fw_next_mode>
	REG_S	a0, SBI_SCRATCH_NEXT_MODE_OFFSET(tp)
40f002f0:	00a22823          	sw	a0,16(tp) # 10 <_fw_start-0x40effff0>
	MOV_3R	a0, s0, a1, s1, a2, s2
40f002f4:	00040533          	add	a0,s0,zero
40f002f8:	000485b3          	add	a1,s1,zero
40f002fc:	00090633          	add	a2,s2,zero
	/* Store warm_boot address in scratch space */
	la	a4, _start_warm
40f00300:	00000717          	auipc	a4,0x0
40f00304:	17470713          	addi	a4,a4,372 # 40f00474 <_start_warm>
	REG_S	a4, SBI_SCRATCH_WARMBOOT_ADDR_OFFSET(tp)
40f00308:	00e22a23          	sw	a4,20(tp) # 14 <_fw_start-0x40efffec>
	/* Store platform address in scratch space */
	la	a4, platform
40f0030c:	0000a717          	auipc	a4,0xa
40f00310:	27070713          	addi	a4,a4,624 # 40f0a57c <platform>
	REG_S	a4, SBI_SCRATCH_PLATFORM_ADDR_OFFSET(tp)
40f00314:	00e22c23          	sw	a4,24(tp) # 18 <_fw_start-0x40efffe8>
	/* Store hartid-to-scratch function address in scratch space */
	la	a4, _hartid_to_scratch
40f00318:	00000717          	auipc	a4,0x0
40f0031c:	1e870713          	addi	a4,a4,488 # 40f00500 <_hartid_to_scratch>
	REG_S	a4, SBI_SCRATCH_HARTID_TO_SCRATCH_OFFSET(tp)
40f00320:	00e22e23          	sw	a4,28(tp) # 1c <_fw_start-0x40efffe4>
	/* Clear tmp0 in scratch space */
	REG_S	zero, SBI_SCRATCH_TMP0_OFFSET(tp)
40f00324:	02022023          	sw	zero,32(tp) # 20 <_fw_start-0x40efffe0>
	/* Store firmware options in scratch space */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f00328:	00050433          	add	s0,a0,zero
40f0032c:	000584b3          	add	s1,a1,zero
40f00330:	00060933          	add	s2,a2,zero
#ifdef FW_OPTIONS
	li	a4, FW_OPTIONS
#else
	add	a4, zero, zero
40f00334:	00000733          	add	a4,zero,zero
#endif
	call	fw_options
40f00338:	470000ef          	jal	ra,40f007a8 <fw_options>
	or	a4, a4, a0
40f0033c:	00a76733          	or	a4,a4,a0
	REG_S	a4, SBI_SCRATCH_OPTIONS_OFFSET(tp)
40f00340:	02e22223          	sw	a4,36(tp) # 24 <_fw_start-0x40efffdc>
	MOV_3R	a0, s0, a1, s1, a2, s2
40f00344:	00040533          	add	a0,s0,zero
40f00348:	000485b3          	add	a1,s1,zero
40f0034c:	00090633          	add	a2,s2,zero
	/* Move to next scratch space */
	add	t1, t1, t2
40f00350:	00730333          	add	t1,t1,t2
	blt	t1, s7, _scratch_init
40f00354:	f1734ae3          	blt	t1,s7,40f00268 <_scratch_init>

	/* Zero-out BSS */
	la	a4, _bss_start
40f00358:	0000c717          	auipc	a4,0xc
40f0035c:	ca870713          	addi	a4,a4,-856 # 40f0c000 <_bss_start>
	la	a5, _bss_end
40f00360:	0000c797          	auipc	a5,0xc
40f00364:	d8078793          	addi	a5,a5,-640 # 40f0c0e0 <_bss_end>

40f00368 <_bss_zero>:
_bss_zero:
	REG_S	zero, (a4)
40f00368:	00072023          	sw	zero,0(a4)
	add	a4, a4, __SIZEOF_POINTER__
40f0036c:	00470713          	addi	a4,a4,4
	blt	a4, a5, _bss_zero
40f00370:	fef74ce3          	blt	a4,a5,40f00368 <_bss_zero>

	/* Override pervious arg1 */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f00374:	00050433          	add	s0,a0,zero
40f00378:	000584b3          	add	s1,a1,zero
40f0037c:	00060933          	add	s2,a2,zero
	call	fw_prev_arg1
40f00380:	400000ef          	jal	ra,40f00780 <fw_prev_arg1>
	add	t1, a0, zero
40f00384:	00050333          	add	t1,a0,zero
	MOV_3R	a0, s0, a1, s1, a2, s2
40f00388:	00040533          	add	a0,s0,zero
40f0038c:	000485b3          	add	a1,s1,zero
40f00390:	00090633          	add	a2,s2,zero
	beqz	t1, _prev_arg1_override_done
40f00394:	00030463          	beqz	t1,40f0039c <_prev_arg1_override_done>
	add	a1, t1, zero
40f00398:	000305b3          	add	a1,t1,zero

40f0039c <_prev_arg1_override_done>:
	 * destination FDT address = next arg1
	 *
	 * Note: We will preserve a0 and a1 passed by
	 * previous booting stage.
	 */
	beqz	a1, _fdt_reloc_done
40f0039c:	0a058063          	beqz	a1,40f0043c <_fdt_reloc_done>
	/* Mask values in a3 and a4 */
	li	a3, ~(__SIZEOF_POINTER__ - 1)
40f003a0:	ffc00693          	li	a3,-4
	li	a4, 0xff
40f003a4:	0ff00713          	li	a4,255
	/* t1 = destination FDT start address */
	MOV_3R	s0, a0, s1, a1, s2, a2
40f003a8:	00050433          	add	s0,a0,zero
40f003ac:	000584b3          	add	s1,a1,zero
40f003b0:	00060933          	add	s2,a2,zero
	call	fw_next_arg1
40f003b4:	3d4000ef          	jal	ra,40f00788 <fw_next_arg1>
	add	t1, a0, zero
40f003b8:	00050333          	add	t1,a0,zero
	MOV_3R	a0, s0, a1, s1, a2, s2
40f003bc:	00040533          	add	a0,s0,zero
40f003c0:	000485b3          	add	a1,s1,zero
40f003c4:	00090633          	add	a2,s2,zero
	beqz	t1, _fdt_reloc_done
40f003c8:	06030a63          	beqz	t1,40f0043c <_fdt_reloc_done>
	beq	t1, a1, _fdt_reloc_done
40f003cc:	06b30863          	beq	t1,a1,40f0043c <_fdt_reloc_done>
	and	t1, t1, a3
40f003d0:	00d37333          	and	t1,t1,a3
	/* t0 = source FDT start address */
	add	t0, a1, zero
40f003d4:	000582b3          	add	t0,a1,zero
	and	t0, t0, a3
40f003d8:	00d2f2b3          	and	t0,t0,a3
	/* t2 = source FDT size in big-endian */
#if __riscv_xlen == 64
	lwu	t2, 4(t0)
#else
	lw	t2, 4(t0)
40f003dc:	0042a383          	lw	t2,4(t0)
#endif
	/* t3 = bit[15:8] of FDT size */
	add	t3, t2, zero
40f003e0:	00038e33          	add	t3,t2,zero
	srli	t3, t3, 16
40f003e4:	010e5e13          	srli	t3,t3,0x10
	and	t3, t3, a4
40f003e8:	00ee7e33          	and	t3,t3,a4
	slli	t3, t3, 8
40f003ec:	008e1e13          	slli	t3,t3,0x8
	/* t4 = bit[23:16] of FDT size */
	add	t4, t2, zero
40f003f0:	00038eb3          	add	t4,t2,zero
	srli	t4, t4, 8
40f003f4:	008ede93          	srli	t4,t4,0x8
	and	t4, t4, a4
40f003f8:	00eefeb3          	and	t4,t4,a4
	slli	t4, t4, 16
40f003fc:	010e9e93          	slli	t4,t4,0x10
	/* t5 = bit[31:24] of FDT size */
	add	t5, t2, zero
40f00400:	00038f33          	add	t5,t2,zero
	and	t5, t5, a4
40f00404:	00ef7f33          	and	t5,t5,a4
	slli	t5, t5, 24
40f00408:	018f1f13          	slli	t5,t5,0x18
	/* t2 = bit[7:0] of FDT size */
	srli	t2, t2, 24
40f0040c:	0183d393          	srli	t2,t2,0x18
	and	t2, t2, a4
40f00410:	00e3f3b3          	and	t2,t2,a4
	/* t2 = FDT size in little-endian */
	or	t2, t2, t3
40f00414:	01c3e3b3          	or	t2,t2,t3
	or	t2, t2, t4
40f00418:	01d3e3b3          	or	t2,t2,t4
	or	t2, t2, t5
40f0041c:	01e3e3b3          	or	t2,t2,t5
	/* t2 = destination FDT end address */
	add	t2, t1, t2
40f00420:	007303b3          	add	t2,t1,t2
	/* FDT copy loop */
	ble	t2, t1, _fdt_reloc_done
40f00424:	00735c63          	bge	t1,t2,40f0043c <_fdt_reloc_done>

40f00428 <_fdt_reloc_again>:
_fdt_reloc_again:
	REG_L	t3, 0(t0)
40f00428:	0002ae03          	lw	t3,0(t0)
	REG_S	t3, 0(t1)
40f0042c:	01c32023          	sw	t3,0(t1)
	add	t0, t0, __SIZEOF_POINTER__
40f00430:	00428293          	addi	t0,t0,4
	add	t1, t1, __SIZEOF_POINTER__
40f00434:	00430313          	addi	t1,t1,4
	blt	t1, t2, _fdt_reloc_again
40f00438:	fe7348e3          	blt	t1,t2,40f00428 <_fdt_reloc_again>

40f0043c <_fdt_reloc_done>:
_fdt_reloc_done:

	/* mark boot hart done */
	li	t0, BOOT_STATUS_BOOT_HART_DONE
40f0043c:	00200293          	li	t0,2
	la	t1, _boot_status
40f00440:	00000317          	auipc	t1,0x0
40f00444:	0ac30313          	addi	t1,t1,172 # 40f004ec <_boot_status>
	REG_S	t0, 0(t1)
40f00448:	00532023          	sw	t0,0(t1)
	fence	rw, rw
40f0044c:	0330000f          	fence	rw,rw
	j	_start_warm
40f00450:	0240006f          	j	40f00474 <_start_warm>

40f00454 <_wait_for_boot_hart>:

	/* waitting for boot hart done (_boot_status == 2) */
_wait_for_boot_hart:
	li	t0, BOOT_STATUS_BOOT_HART_DONE
40f00454:	00200293          	li	t0,2
	la	t1, _boot_status
40f00458:	00000317          	auipc	t1,0x0
40f0045c:	09430313          	addi	t1,t1,148 # 40f004ec <_boot_status>
	REG_L	t1, 0(t1)
40f00460:	00032303          	lw	t1,0(t1)
	/* Reduce the bus traffic so that boot hart may proceed faster */
	nop
40f00464:	00000013          	nop
	nop
40f00468:	00000013          	nop
	nop
40f0046c:	00000013          	nop
	bne	t0, t1, _wait_for_boot_hart
40f00470:	fe6292e3          	bne	t0,t1,40f00454 <_wait_for_boot_hart>

40f00474 <_start_warm>:

_start_warm:
	/* Reset all registers for non-boot HARTs */
	li	ra, 0
40f00474:	00000093          	li	ra,0
	call	_reset_regs
40f00478:	280000ef          	jal	ra,40f006f8 <_reset_regs>

	/* Disable and clear all interrupts */
	csrw	CSR_MIE, zero
40f0047c:	30401073          	csrw	mie,zero
	csrw	CSR_MIP, zero
40f00480:	34401073          	csrw	mip,zero

	la	a4, platform
40f00484:	0000a717          	auipc	a4,0xa
40f00488:	0f870713          	addi	a4,a4,248 # 40f0a57c <platform>
#if __riscv_xlen == 64
	lwu	s7, SBI_PLATFORM_HART_COUNT_OFFSET(a4)
	lwu	s8, SBI_PLATFORM_HART_STACK_SIZE_OFFSET(a4)
#else
	lw	s7, SBI_PLATFORM_HART_COUNT_OFFSET(a4)
40f0048c:	05072b83          	lw	s7,80(a4)
	lw	s8, SBI_PLATFORM_HART_STACK_SIZE_OFFSET(a4)
40f00490:	05472c03          	lw	s8,84(a4)
#endif

	/* HART ID should be within expected limit */
	csrr	s6, CSR_MHARTID
40f00494:	f1402b73          	csrr	s6,mhartid
	bge	s6, s7, _start_hang
40f00498:	0d7b5063          	bge	s6,s7,40f00558 <_start_hang>

	/* find the scratch space for this hart */
	la	tp, _fw_end
40f0049c:	0000d217          	auipc	tp,0xd
40f004a0:	b6420213          	addi	tp,tp,-1180 # 40f0d000 <_fw_end>
	mul	a5, s7, s8
40f004a4:	038b87b3          	mul	a5,s7,s8
	add	tp, tp, a5
40f004a8:	00f20233          	add	tp,tp,a5
	mul	a5, s8, s6
40f004ac:	036c07b3          	mul	a5,s8,s6
	sub	tp, tp, a5
40f004b0:	40f20233          	sub	tp,tp,a5
	li	a5, SBI_SCRATCH_SIZE
40f004b4:	10000793          	li	a5,256
	sub	tp, tp, a5
40f004b8:	40f20233          	sub	tp,tp,a5

	/* update the mscratch */
	csrw	CSR_MSCRATCH, tp
40f004bc:	34021073          	csrw	mscratch,tp

	/* Setup stack */
	add	sp, tp, zero
40f004c0:	00020133          	add	sp,tp,zero

	/* Setup trap handler */
	la	a4, _trap_handler
40f004c4:	00000717          	auipc	a4,0x0
40f004c8:	09c70713          	addi	a4,a4,156 # 40f00560 <_trap_handler>
	csrw	CSR_MTVEC, a4
40f004cc:	30571073          	csrw	mtvec,a4
	/* Make sure that mtvec is updated */
1:	csrr	a5, CSR_MTVEC
40f004d0:	305027f3          	csrr	a5,mtvec
	bne	a4, a5, 1b
40f004d4:	fef71ee3          	bne	a4,a5,40f004d0 <_start_warm+0x5c>

	/* Initialize SBI runtime */
	csrr	a0, CSR_MSCRATCH
40f004d8:	34002573          	csrr	a0,mscratch
	call	sbi_init
40f004dc:	2dc000ef          	jal	ra,40f007b8 <sbi_init>

	/* We don't expect to reach here hence just hang */
	j	_start_hang
40f004e0:	0780006f          	j	40f00558 <_start_hang>
40f004e4:	00000013          	nop

40f004e8 <_relocate_lottery>:
40f004e8:	0000                	unimp
	...

40f004ec <_boot_status>:
40f004ec:	0000                	unimp
	...

40f004f0 <_load_start>:
40f004f0:	0000                	unimp
40f004f2:	40f0                	lw	a2,68(s1)

40f004f4 <_link_start>:
40f004f4:	0000                	unimp
40f004f6:	40f0                	lw	a2,68(s1)

40f004f8 <_link_end>:
40f004f8:	d000                	sw	s0,32(s0)
40f004fa:	40f0                	lw	a2,68(s1)
40f004fc:	00000013          	nop

40f00500 <_hartid_to_scratch>:

	.section .entry, "ax", %progbits
	.align 3
	.globl _hartid_to_scratch
_hartid_to_scratch:
	add	sp, sp, -(3 * __SIZEOF_POINTER__)
40f00500:	ff410113          	addi	sp,sp,-12
	REG_S	s0, (sp)
40f00504:	00812023          	sw	s0,0(sp)
	REG_S	s1, (__SIZEOF_POINTER__)(sp)
40f00508:	00912223          	sw	s1,4(sp)
	REG_S	s2, (__SIZEOF_POINTER__ * 2)(sp)
40f0050c:	01212423          	sw	s2,8(sp)
	 * a0 -> HART ID (passed by caller)
	 * s0 -> HART Stack Size
	 * s1 -> HART Stack End
	 * s2 -> Temporary
	 */
	la	s2, platform
40f00510:	0000a917          	auipc	s2,0xa
40f00514:	06c90913          	addi	s2,s2,108 # 40f0a57c <platform>
#if __riscv_xlen == 64
	lwu	s0, SBI_PLATFORM_HART_STACK_SIZE_OFFSET(s2)
	lwu	s2, SBI_PLATFORM_HART_COUNT_OFFSET(s2)
#else
	lw	s0, SBI_PLATFORM_HART_STACK_SIZE_OFFSET(s2)
40f00518:	05492403          	lw	s0,84(s2)
	lw	s2, SBI_PLATFORM_HART_COUNT_OFFSET(s2)
40f0051c:	05092903          	lw	s2,80(s2)
#endif
	mul	s2, s2, s0
40f00520:	02890933          	mul	s2,s2,s0
	la	s1, _fw_end
40f00524:	0000d497          	auipc	s1,0xd
40f00528:	adc48493          	addi	s1,s1,-1316 # 40f0d000 <_fw_end>
	add	s1, s1, s2
40f0052c:	012484b3          	add	s1,s1,s2
	mul	s2, s0, a0
40f00530:	02a40933          	mul	s2,s0,a0
	sub	s1, s1, s2
40f00534:	412484b3          	sub	s1,s1,s2
	li	s2, SBI_SCRATCH_SIZE
40f00538:	10000913          	li	s2,256
	sub	a0, s1, s2
40f0053c:	41248533          	sub	a0,s1,s2
	REG_L	s0, (sp)
40f00540:	00012403          	lw	s0,0(sp)
	REG_L	s1, (__SIZEOF_POINTER__)(sp)
40f00544:	00412483          	lw	s1,4(sp)
	REG_L	s2, (__SIZEOF_POINTER__ * 2)(sp)
40f00548:	00812903          	lw	s2,8(sp)
	add	sp, sp, (3 * __SIZEOF_POINTER__)
40f0054c:	00c10113          	addi	sp,sp,12
	ret
40f00550:	00008067          	ret
40f00554:	00000013          	nop

40f00558 <_start_hang>:

	.section .entry, "ax", %progbits
	.align 3
	.globl _start_hang
_start_hang:
	wfi
40f00558:	10500073          	wfi
	j	_start_hang
40f0055c:	ffdff06f          	j	40f00558 <_start_hang>

40f00560 <_trap_handler>:
	.section .entry, "ax", %progbits
	.align 3
	.globl _trap_handler
_trap_handler:
	/* Swap TP and MSCRATCH */
	csrrw	tp, CSR_MSCRATCH, tp
40f00560:	34021273          	csrrw	tp,mscratch,tp

	/* Save T0 in scratch space */
	REG_S	t0, SBI_SCRATCH_TMP0_OFFSET(tp)
40f00564:	02522023          	sw	t0,32(tp) # 20 <_fw_start-0x40efffe0>

	/* Check which mode we came from */
	csrr	t0, CSR_MSTATUS
40f00568:	300022f3          	csrr	t0,mstatus
	srl	t0, t0, MSTATUS_MPP_SHIFT
40f0056c:	00b2d293          	srli	t0,t0,0xb
	and	t0, t0, PRV_M
40f00570:	0032f293          	andi	t0,t0,3
	xori	t0, t0, PRV_M
40f00574:	0032c293          	xori	t0,t0,3
	beq	t0, zero, _trap_handler_m_mode
40f00578:	00028863          	beqz	t0,40f00588 <_trap_handler_m_mode>

40f0057c <_trap_handler_s_mode>:

	/* We came from S-mode or U-mode */
_trap_handler_s_mode:
	/* Set T0 to original SP */
	add	t0, sp, zero
40f0057c:	000102b3          	add	t0,sp,zero

	/* Setup exception stack */
	add	sp, tp, -(SBI_TRAP_REGS_SIZE)
40f00580:	f7420113          	addi	sp,tp,-140 # ffffff74 <_fw_end+0xbf0f2f74>

	/* Jump to code common for all modes */
	j	_trap_handler_all_mode
40f00584:	00c0006f          	j	40f00590 <_trap_handler_all_mode>

40f00588 <_trap_handler_m_mode>:

	/* We came from M-mode */
_trap_handler_m_mode:
	/* Set T0 to original SP */
	add	t0, sp, zero
40f00588:	000102b3          	add	t0,sp,zero

	/* Re-use current SP as exception stack */
	add	sp, sp, -(SBI_TRAP_REGS_SIZE)
40f0058c:	f7410113          	addi	sp,sp,-140

40f00590 <_trap_handler_all_mode>:

_trap_handler_all_mode:
	/* Save original SP (from T0) on stack */
	REG_S	t0, SBI_TRAP_REGS_OFFSET(sp)(sp)
40f00590:	00512423          	sw	t0,8(sp)

	/* Restore T0 from scratch space */
	REG_L	t0, SBI_SCRATCH_TMP0_OFFSET(tp)
40f00594:	02022283          	lw	t0,32(tp) # 20 <_fw_start-0x40efffe0>

	/* Save T0 on stack */
	REG_S	t0, SBI_TRAP_REGS_OFFSET(t0)(sp)
40f00598:	00512a23          	sw	t0,20(sp)

	/* Swap TP and MSCRATCH */
	csrrw	tp, CSR_MSCRATCH, tp
40f0059c:	34021273          	csrrw	tp,mscratch,tp

	/* Save MEPC and MSTATUS CSRs */
	csrr	t0, CSR_MEPC
40f005a0:	341022f3          	csrr	t0,mepc
	REG_S	t0, SBI_TRAP_REGS_OFFSET(mepc)(sp)
40f005a4:	08512023          	sw	t0,128(sp)
	csrr	t0, CSR_MSTATUS
40f005a8:	300022f3          	csrr	t0,mstatus
	REG_S	t0, SBI_TRAP_REGS_OFFSET(mstatus)(sp)
40f005ac:	08512223          	sw	t0,132(sp)
	REG_S	zero, SBI_TRAP_REGS_OFFSET(mstatusH)(sp)
40f005b0:	08012423          	sw	zero,136(sp)
#if __riscv_xlen == 32
	csrr	t0, CSR_MISA
40f005b4:	301022f3          	csrr	t0,misa
	srli	t0, t0, ('H' - 'A')
40f005b8:	0072d293          	srli	t0,t0,0x7
	andi	t0, t0, 0x1
40f005bc:	0012f293          	andi	t0,t0,1
	beq	t0, zero, _skip_mstatush_save
40f005c0:	00028663          	beqz	t0,40f005cc <_skip_mstatush_save>
	csrr	t0, CSR_MSTATUSH
40f005c4:	310022f3          	csrr	t0,0x310
	REG_S	t0, SBI_TRAP_REGS_OFFSET(mstatusH)(sp)
40f005c8:	08512423          	sw	t0,136(sp)

40f005cc <_skip_mstatush_save>:
_skip_mstatush_save:
#endif

	/* Save all general regisers except SP and T0 */
	REG_S	zero, SBI_TRAP_REGS_OFFSET(zero)(sp)
40f005cc:	00012023          	sw	zero,0(sp)
	REG_S	ra, SBI_TRAP_REGS_OFFSET(ra)(sp)
40f005d0:	00112223          	sw	ra,4(sp)
	REG_S	gp, SBI_TRAP_REGS_OFFSET(gp)(sp)
40f005d4:	00312623          	sw	gp,12(sp)
	REG_S	tp, SBI_TRAP_REGS_OFFSET(tp)(sp)
40f005d8:	00412823          	sw	tp,16(sp)
	REG_S	t1, SBI_TRAP_REGS_OFFSET(t1)(sp)
40f005dc:	00612c23          	sw	t1,24(sp)
	REG_S	t2, SBI_TRAP_REGS_OFFSET(t2)(sp)
40f005e0:	00712e23          	sw	t2,28(sp)
	REG_S	s0, SBI_TRAP_REGS_OFFSET(s0)(sp)
40f005e4:	02812023          	sw	s0,32(sp)
	REG_S	s1, SBI_TRAP_REGS_OFFSET(s1)(sp)
40f005e8:	02912223          	sw	s1,36(sp)
	REG_S	a0, SBI_TRAP_REGS_OFFSET(a0)(sp)
40f005ec:	02a12423          	sw	a0,40(sp)
	REG_S	a1, SBI_TRAP_REGS_OFFSET(a1)(sp)
40f005f0:	02b12623          	sw	a1,44(sp)
	REG_S	a2, SBI_TRAP_REGS_OFFSET(a2)(sp)
40f005f4:	02c12823          	sw	a2,48(sp)
	REG_S	a3, SBI_TRAP_REGS_OFFSET(a3)(sp)
40f005f8:	02d12a23          	sw	a3,52(sp)
	REG_S	a4, SBI_TRAP_REGS_OFFSET(a4)(sp)
40f005fc:	02e12c23          	sw	a4,56(sp)
	REG_S	a5, SBI_TRAP_REGS_OFFSET(a5)(sp)
40f00600:	02f12e23          	sw	a5,60(sp)
	REG_S	a6, SBI_TRAP_REGS_OFFSET(a6)(sp)
40f00604:	05012023          	sw	a6,64(sp)
	REG_S	a7, SBI_TRAP_REGS_OFFSET(a7)(sp)
40f00608:	05112223          	sw	a7,68(sp)
	REG_S	s2, SBI_TRAP_REGS_OFFSET(s2)(sp)
40f0060c:	05212423          	sw	s2,72(sp)
	REG_S	s3, SBI_TRAP_REGS_OFFSET(s3)(sp)
40f00610:	05312623          	sw	s3,76(sp)
	REG_S	s4, SBI_TRAP_REGS_OFFSET(s4)(sp)
40f00614:	05412823          	sw	s4,80(sp)
	REG_S	s5, SBI_TRAP_REGS_OFFSET(s5)(sp)
40f00618:	05512a23          	sw	s5,84(sp)
	REG_S	s6, SBI_TRAP_REGS_OFFSET(s6)(sp)
40f0061c:	05612c23          	sw	s6,88(sp)
	REG_S	s7, SBI_TRAP_REGS_OFFSET(s7)(sp)
40f00620:	05712e23          	sw	s7,92(sp)
	REG_S	s8, SBI_TRAP_REGS_OFFSET(s8)(sp)
40f00624:	07812023          	sw	s8,96(sp)
	REG_S	s9, SBI_TRAP_REGS_OFFSET(s9)(sp)
40f00628:	07912223          	sw	s9,100(sp)
	REG_S	s10, SBI_TRAP_REGS_OFFSET(s10)(sp)
40f0062c:	07a12423          	sw	s10,104(sp)
	REG_S	s11, SBI_TRAP_REGS_OFFSET(s11)(sp)
40f00630:	07b12623          	sw	s11,108(sp)
	REG_S	t3, SBI_TRAP_REGS_OFFSET(t3)(sp)
40f00634:	07c12823          	sw	t3,112(sp)
	REG_S	t4, SBI_TRAP_REGS_OFFSET(t4)(sp)
40f00638:	07d12a23          	sw	t4,116(sp)
	REG_S	t5, SBI_TRAP_REGS_OFFSET(t5)(sp)
40f0063c:	07e12c23          	sw	t5,120(sp)
	REG_S	t6, SBI_TRAP_REGS_OFFSET(t6)(sp)
40f00640:	07f12e23          	sw	t6,124(sp)

	/* Call C routine */
	add	a0, sp, zero
40f00644:	00010533          	add	a0,sp,zero
	csrr	a1, CSR_MSCRATCH
40f00648:	340025f3          	csrr	a1,mscratch
	call	sbi_trap_handler
40f0064c:	149020ef          	jal	ra,40f02f94 <sbi_trap_handler>

	/* Restore all general regisers except SP and T0 */
	REG_L	ra, SBI_TRAP_REGS_OFFSET(ra)(sp)
40f00650:	00412083          	lw	ra,4(sp)
	REG_L	gp, SBI_TRAP_REGS_OFFSET(gp)(sp)
40f00654:	00c12183          	lw	gp,12(sp)
	REG_L	tp, SBI_TRAP_REGS_OFFSET(tp)(sp)
40f00658:	01012203          	lw	tp,16(sp)
	REG_L	t1, SBI_TRAP_REGS_OFFSET(t1)(sp)
40f0065c:	01812303          	lw	t1,24(sp)
	REG_L	t2, SBI_TRAP_REGS_OFFSET(t2)(sp)
40f00660:	01c12383          	lw	t2,28(sp)
	REG_L	s0, SBI_TRAP_REGS_OFFSET(s0)(sp)
40f00664:	02012403          	lw	s0,32(sp)
	REG_L	s1, SBI_TRAP_REGS_OFFSET(s1)(sp)
40f00668:	02412483          	lw	s1,36(sp)
	REG_L	a0, SBI_TRAP_REGS_OFFSET(a0)(sp)
40f0066c:	02812503          	lw	a0,40(sp)
	REG_L	a1, SBI_TRAP_REGS_OFFSET(a1)(sp)
40f00670:	02c12583          	lw	a1,44(sp)
	REG_L	a2, SBI_TRAP_REGS_OFFSET(a2)(sp)
40f00674:	03012603          	lw	a2,48(sp)
	REG_L	a3, SBI_TRAP_REGS_OFFSET(a3)(sp)
40f00678:	03412683          	lw	a3,52(sp)
	REG_L	a4, SBI_TRAP_REGS_OFFSET(a4)(sp)
40f0067c:	03812703          	lw	a4,56(sp)
	REG_L	a5, SBI_TRAP_REGS_OFFSET(a5)(sp)
40f00680:	03c12783          	lw	a5,60(sp)
	REG_L	a6, SBI_TRAP_REGS_OFFSET(a6)(sp)
40f00684:	04012803          	lw	a6,64(sp)
	REG_L	a7, SBI_TRAP_REGS_OFFSET(a7)(sp)
40f00688:	04412883          	lw	a7,68(sp)
	REG_L	s2, SBI_TRAP_REGS_OFFSET(s2)(sp)
40f0068c:	04812903          	lw	s2,72(sp)
	REG_L	s3, SBI_TRAP_REGS_OFFSET(s3)(sp)
40f00690:	04c12983          	lw	s3,76(sp)
	REG_L	s4, SBI_TRAP_REGS_OFFSET(s4)(sp)
40f00694:	05012a03          	lw	s4,80(sp)
	REG_L	s5, SBI_TRAP_REGS_OFFSET(s5)(sp)
40f00698:	05412a83          	lw	s5,84(sp)
	REG_L	s6, SBI_TRAP_REGS_OFFSET(s6)(sp)
40f0069c:	05812b03          	lw	s6,88(sp)
	REG_L	s7, SBI_TRAP_REGS_OFFSET(s7)(sp)
40f006a0:	05c12b83          	lw	s7,92(sp)
	REG_L	s8, SBI_TRAP_REGS_OFFSET(s8)(sp)
40f006a4:	06012c03          	lw	s8,96(sp)
	REG_L	s9, SBI_TRAP_REGS_OFFSET(s9)(sp)
40f006a8:	06412c83          	lw	s9,100(sp)
	REG_L	s10, SBI_TRAP_REGS_OFFSET(s10)(sp)
40f006ac:	06812d03          	lw	s10,104(sp)
	REG_L	s11, SBI_TRAP_REGS_OFFSET(s11)(sp)
40f006b0:	06c12d83          	lw	s11,108(sp)
	REG_L	t3, SBI_TRAP_REGS_OFFSET(t3)(sp)
40f006b4:	07012e03          	lw	t3,112(sp)
	REG_L	t4, SBI_TRAP_REGS_OFFSET(t4)(sp)
40f006b8:	07412e83          	lw	t4,116(sp)
	REG_L	t5, SBI_TRAP_REGS_OFFSET(t5)(sp)
40f006bc:	07812f03          	lw	t5,120(sp)
	REG_L	t6, SBI_TRAP_REGS_OFFSET(t6)(sp)
40f006c0:	07c12f83          	lw	t6,124(sp)

	/* Restore MEPC and MSTATUS CSRs */
	REG_L	t0, SBI_TRAP_REGS_OFFSET(mepc)(sp)
40f006c4:	08012283          	lw	t0,128(sp)
	csrw	CSR_MEPC, t0
40f006c8:	34129073          	csrw	mepc,t0
	REG_L	t0, SBI_TRAP_REGS_OFFSET(mstatus)(sp)
40f006cc:	08412283          	lw	t0,132(sp)
	csrw	CSR_MSTATUS, t0
40f006d0:	30029073          	csrw	mstatus,t0
#if __riscv_xlen == 32
	csrr	t0, CSR_MISA
40f006d4:	301022f3          	csrr	t0,misa
	srli	t0, t0, ('H' - 'A')
40f006d8:	0072d293          	srli	t0,t0,0x7
	andi	t0, t0, 0x1
40f006dc:	0012f293          	andi	t0,t0,1
	beq	t0, zero, _skip_mstatush_restore
40f006e0:	00028663          	beqz	t0,40f006ec <_skip_mstatush_restore>
	REG_L	t0, SBI_TRAP_REGS_OFFSET(mstatusH)(sp)
40f006e4:	08812283          	lw	t0,136(sp)
	csrw	CSR_MSTATUSH, t0
40f006e8:	31029073          	csrw	0x310,t0

40f006ec <_skip_mstatush_restore>:
_skip_mstatush_restore:
#endif

	/* Restore T0 */
	REG_L	t0, SBI_TRAP_REGS_OFFSET(t0)(sp)
40f006ec:	01412283          	lw	t0,20(sp)

	/* Restore SP */
	REG_L	sp, SBI_TRAP_REGS_OFFSET(sp)(sp)
40f006f0:	00812103          	lw	sp,8(sp)

	mret
40f006f4:	30200073          	mret

40f006f8 <_reset_regs>:
	.align 3
	.globl _reset_regs
_reset_regs:

	/* flush the instruction cache */
	fence.i
40f006f8:	0000100f          	fence.i
	/* Reset all registers except ra, a0, a1 and a2 */
	li sp, 0
40f006fc:	00000113          	li	sp,0
	li gp, 0
40f00700:	00000193          	li	gp,0
	li tp, 0
40f00704:	00000213          	li	tp,0
	li t0, 0
40f00708:	00000293          	li	t0,0
	li t1, 0
40f0070c:	00000313          	li	t1,0
	li t2, 0
40f00710:	00000393          	li	t2,0
	li s0, 0
40f00714:	00000413          	li	s0,0
	li s1, 0
40f00718:	00000493          	li	s1,0
	li a3, 0
40f0071c:	00000693          	li	a3,0
	li a4, 0
40f00720:	00000713          	li	a4,0
	li a5, 0
40f00724:	00000793          	li	a5,0
	li a6, 0
40f00728:	00000813          	li	a6,0
	li a7, 0
40f0072c:	00000893          	li	a7,0
	li s2, 0
40f00730:	00000913          	li	s2,0
	li s3, 0
40f00734:	00000993          	li	s3,0
	li s4, 0
40f00738:	00000a13          	li	s4,0
	li s5, 0
40f0073c:	00000a93          	li	s5,0
	li s6, 0
40f00740:	00000b13          	li	s6,0
	li s7, 0
40f00744:	00000b93          	li	s7,0
	li s8, 0
40f00748:	00000c13          	li	s8,0
	li s9, 0
40f0074c:	00000c93          	li	s9,0
	li s10, 0
40f00750:	00000d13          	li	s10,0
	li s11, 0
40f00754:	00000d93          	li	s11,0
	li t3, 0
40f00758:	00000e13          	li	t3,0
	li t4, 0
40f0075c:	00000e93          	li	t4,0
	li t5, 0
40f00760:	00000f13          	li	t5,0
	li t6, 0
40f00764:	00000f93          	li	t6,0
	csrw CSR_MSCRATCH, 0
40f00768:	34005073          	csrwi	mscratch,0

	ret
40f0076c:	00008067          	ret

40f00770 <fw_boot_hart>:
	 * fw_save_info() is called.
	 * We can only use a0, a1, and a2 registers here.
	 * The boot HART id should be returned in 'a0'.
	 */
fw_boot_hart:
	li	a0, -1
40f00770:	fff00513          	li	a0,-1
	ret
40f00774:	00008067          	ret

40f00778 <fw_save_info>:
	 * The a0, a1, and a2 registers will be same as passed by
	 * previous booting stage.
	 * Nothing to be returned here.
	 */
fw_save_info:
	ret
40f00778:	00008067          	ret
40f0077c:	00000013          	nop

40f00780 <fw_prev_arg1>:
	 * The a0, a1, and a2 registers will be same as passed by
	 * previous booting stage.
	 * The previous arg1 should be returned in 'a0'.
	 */
fw_prev_arg1:
	add	a0, zero, zero
40f00780:	00000533          	add	a0,zero,zero
	ret
40f00784:	00008067          	ret

40f00788 <fw_next_arg1>:
	 * previous booting stage.
	 * The next arg1 should be returned in 'a0'.
	 */
fw_next_arg1:
#ifdef FW_JUMP_FDT_ADDR
	li	a0, FW_JUMP_FDT_ADDR
40f00788:	40ef0537          	lui	a0,0x40ef0
#else
	add	a0, a1, zero
#endif
	ret
40f0078c:	00008067          	ret

40f00790 <fw_next_addr>:
	/*
	 * We can only use a0, a1, and a2 registers here.
	 * The next address should be returned in 'a0'.
	 */
fw_next_addr:
	la	a0, _jump_addr
40f00790:	00000517          	auipc	a0,0x0
40f00794:	02050513          	addi	a0,a0,32 # 40f007b0 <_jump_addr>
	REG_L	a0, (a0)
40f00798:	00052503          	lw	a0,0(a0)
	ret
40f0079c:	00008067          	ret

40f007a0 <fw_next_mode>:
	/*
	 * We can only use a0, a1, and a2 registers here.
	 * The next address should be returned in 'a0'
	 */
fw_next_mode:
	li	a0, PRV_S
40f007a0:	00100513          	li	a0,1
	ret
40f007a4:	00008067          	ret

40f007a8 <fw_options>:
	 * We can only use a0, a1, and a2 registers here.
	 * The 'a4' register will have default options.
	 * The next address should be returned in 'a0'.
	 */
fw_options:
	add	a0, zero, zero
40f007a8:	00000533          	add	a0,zero,zero
	ret
40f007ac:	00008067          	ret

40f007b0 <_jump_addr>:
40f007b0:	0000                	unimp
40f007b2:	4000                	lw	s0,0(s0)
40f007b4:	0000                	unimp
	...

40f007b8 <sbi_init>:
 * 4. All interrupts are disabled in MIE CSR
 *
 * @param scratch pointer to sbi_scratch of current HART
 */
void __noreturn sbi_init(struct sbi_scratch *scratch)
{
40f007b8:	f9010113          	addi	sp,sp,-112
40f007bc:	06812423          	sw	s0,104(sp)
40f007c0:	06912223          	sw	s1,100(sp)
40f007c4:	07212023          	sw	s2,96(sp)
40f007c8:	06112623          	sw	ra,108(sp)
40f007cc:	05312e23          	sw	s3,92(sp)
40f007d0:	05412c23          	sw	s4,88(sp)
40f007d4:	05512a23          	sw	s5,84(sp)
40f007d8:	05612823          	sw	s6,80(sp)
40f007dc:	05712623          	sw	s7,76(sp)
40f007e0:	07010413          	addi	s0,sp,112
40f007e4:	00050493          	mv	s1,a0
	bool coldboot			= FALSE;
	u32 hartid			= sbi_current_hartid();
40f007e8:	2d0060ef          	jal	ra,40f06ab8 <sbi_current_hartid>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f007ec:	0194c683          	lbu	a3,25(s1)
40f007f0:	0184c603          	lbu	a2,24(s1)
40f007f4:	01a4c703          	lbu	a4,26(s1)
40f007f8:	01b4c783          	lbu	a5,27(s1)
40f007fc:	00869693          	slli	a3,a3,0x8
40f00800:	00c6e6b3          	or	a3,a3,a2
40f00804:	01071713          	slli	a4,a4,0x10
40f00808:	00d76733          	or	a4,a4,a3
40f0080c:	01879793          	slli	a5,a5,0x18
40f00810:	00e7e7b3          	or	a5,a5,a4
	u32 hartid			= sbi_current_hartid();
40f00814:	00050913          	mv	s2,a0
 * @return TRUE if HART is disabled and FALSE otherwise
 */
static inline bool sbi_platform_hart_disabled(const struct sbi_platform *plat,
					      u32 hartid)
{
	if (plat && (plat->disabled_hart_mask & (1 << hartid)))
40f00818:	06078863          	beqz	a5,40f00888 <sbi_init+0xd0>
40f0081c:	0597c803          	lbu	a6,89(a5)
40f00820:	05d7c503          	lbu	a0,93(a5)
40f00824:	0587c303          	lbu	t1,88(a5)
40f00828:	05a7c583          	lbu	a1,90(a5)
40f0082c:	05c7c883          	lbu	a7,92(a5)
40f00830:	05e7c603          	lbu	a2,94(a5)
40f00834:	05b7c703          	lbu	a4,91(a5)
40f00838:	05f7c683          	lbu	a3,95(a5)
40f0083c:	00851513          	slli	a0,a0,0x8
40f00840:	00881793          	slli	a5,a6,0x8
40f00844:	0067e7b3          	or	a5,a5,t1
40f00848:	01059593          	slli	a1,a1,0x10
40f0084c:	01156533          	or	a0,a0,a7
40f00850:	01061613          	slli	a2,a2,0x10
40f00854:	00100813          	li	a6,1
40f00858:	01281833          	sll	a6,a6,s2
40f0085c:	00f5e5b3          	or	a1,a1,a5
40f00860:	00a66633          	or	a2,a2,a0
40f00864:	01871793          	slli	a5,a4,0x18
40f00868:	01869713          	slli	a4,a3,0x18
40f0086c:	00b7e7b3          	or	a5,a5,a1
40f00870:	00c76733          	or	a4,a4,a2
40f00874:	41f85693          	srai	a3,a6,0x1f
40f00878:	0107f7b3          	and	a5,a5,a6
40f0087c:	00d77733          	and	a4,a4,a3
40f00880:	00e7e7b3          	or	a5,a5,a4
40f00884:	06079063          	bnez	a5,40f008e4 <sbi_init+0x12c>

	if (sbi_platform_hart_disabled(plat, hartid))
		sbi_hart_hang();

	if (atomic_add_return(&coldboot_lottery, 1) == 1)
40f00888:	00100593          	li	a1,1
40f0088c:	0000b517          	auipc	a0,0xb
40f00890:	77450513          	addi	a0,a0,1908 # 40f0c000 <_bss_start>
40f00894:	559030ef          	jal	ra,40f045ec <atomic_add_return>
40f00898:	00100793          	li	a5,1
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f0089c:	0194c703          	lbu	a4,25(s1)
40f008a0:	0184c603          	lbu	a2,24(s1)
	if (atomic_add_return(&coldboot_lottery, 1) == 1)
40f008a4:	1af50463          	beq	a0,a5,40f00a4c <sbi_init+0x294>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f008a8:	01a4c783          	lbu	a5,26(s1)
40f008ac:	01b4c683          	lbu	a3,27(s1)
40f008b0:	00871713          	slli	a4,a4,0x8
40f008b4:	00c76733          	or	a4,a4,a2
40f008b8:	01079793          	slli	a5,a5,0x10
40f008bc:	00e7e7b3          	or	a5,a5,a4
	sbi_hart_wait_for_coldboot(scratch, hartid);
40f008c0:	00090593          	mv	a1,s2
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f008c4:	01869713          	slli	a4,a3,0x18
	sbi_hart_wait_for_coldboot(scratch, hartid);
40f008c8:	00048513          	mv	a0,s1
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f008cc:	00f769b3          	or	s3,a4,a5
	if (!init_count_offset)
40f008d0:	0000ba17          	auipc	s4,0xb
40f008d4:	734a0a13          	addi	s4,s4,1844 # 40f0c004 <init_count_offset>
	sbi_hart_wait_for_coldboot(scratch, hartid);
40f008d8:	301060ef          	jal	ra,40f073d8 <sbi_hart_wait_for_coldboot>
	if (!init_count_offset)
40f008dc:	000a2783          	lw	a5,0(s4)
40f008e0:	00079463          	bnez	a5,40f008e8 <sbi_init+0x130>
		sbi_hart_hang();
40f008e4:	071060ef          	jal	ra,40f07154 <sbi_hart_hang>
	rc = sbi_system_early_init(scratch, FALSE);
40f008e8:	00000593          	li	a1,0
40f008ec:	00048513          	mv	a0,s1
40f008f0:	084010ef          	jal	ra,40f01974 <sbi_system_early_init>
	if (rc)
40f008f4:	fe0518e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_hart_init(scratch, hartid, FALSE);
40f008f8:	00000613          	li	a2,0
40f008fc:	00090593          	mv	a1,s2
40f00900:	00048513          	mv	a0,s1
40f00904:	3ec060ef          	jal	ra,40f06cf0 <sbi_hart_init>
	if (rc)
40f00908:	fc051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
 * @return 0 on success and negative error code on failure
 */
static inline int sbi_platform_irqchip_init(const struct sbi_platform *plat,
					    bool cold_boot)
{
	if (plat && sbi_platform_ops(plat)->irqchip_init)
40f0090c:	06098063          	beqz	s3,40f0096c <sbi_init+0x1b4>
40f00910:	0619c683          	lbu	a3,97(s3)
40f00914:	0609c603          	lbu	a2,96(s3)
40f00918:	0629c703          	lbu	a4,98(s3)
40f0091c:	0639c783          	lbu	a5,99(s3)
40f00920:	00869693          	slli	a3,a3,0x8
40f00924:	00c6e6b3          	or	a3,a3,a2
40f00928:	01071713          	slli	a4,a4,0x10
40f0092c:	00d76733          	or	a4,a4,a3
40f00930:	01879793          	slli	a5,a5,0x18
40f00934:	00e7e7b3          	or	a5,a5,a4
40f00938:	02d7c683          	lbu	a3,45(a5)
40f0093c:	02c7c603          	lbu	a2,44(a5)
40f00940:	02e7c703          	lbu	a4,46(a5)
40f00944:	02f7c783          	lbu	a5,47(a5)
40f00948:	00869693          	slli	a3,a3,0x8
40f0094c:	00c6e6b3          	or	a3,a3,a2
40f00950:	01071713          	slli	a4,a4,0x10
40f00954:	00d76733          	or	a4,a4,a3
40f00958:	01879793          	slli	a5,a5,0x18
40f0095c:	00e7e7b3          	or	a5,a5,a4
40f00960:	00078663          	beqz	a5,40f0096c <sbi_init+0x1b4>
		return sbi_platform_ops(plat)->irqchip_init(cold_boot);
40f00964:	000780e7          	jalr	a5
	if (rc)
40f00968:	f6051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_ipi_init(scratch, FALSE);
40f0096c:	00000593          	li	a1,0
40f00970:	00048513          	mv	a0,s1
40f00974:	435000ef          	jal	ra,40f015a8 <sbi_ipi_init>
	if (rc)
40f00978:	f60516e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_tlb_init(scratch, FALSE);
40f0097c:	00000593          	li	a1,0
40f00980:	00048513          	mv	a0,s1
40f00984:	7dd010ef          	jal	ra,40f02960 <sbi_tlb_init>
	if (rc)
40f00988:	f4051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_timer_init(scratch, FALSE);
40f0098c:	00000593          	li	a1,0
40f00990:	00048513          	mv	a0,s1
40f00994:	72c010ef          	jal	ra,40f020c0 <sbi_timer_init>
	if (rc)
40f00998:	f40516e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_system_final_init(scratch, FALSE);
40f0099c:	00000593          	li	a1,0
40f009a0:	00048513          	mv	a0,s1
40f009a4:	088010ef          	jal	ra,40f01a2c <sbi_system_final_init>
	if (rc)
40f009a8:	f2051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	sbi_hart_mark_available(hartid);
40f009ac:	00090513          	mv	a0,s2
40f009b0:	0c5060ef          	jal	ra,40f07274 <sbi_hart_mark_available>
	init_count = sbi_scratch_offset_ptr(scratch, init_count_offset);
40f009b4:	000a2783          	lw	a5,0(s4)
40f009b8:	00f487b3          	add	a5,s1,a5
	(*init_count)++;
40f009bc:	0007a683          	lw	a3,0(a5)
	sbi_hart_switch_mode(hartid, scratch->next_arg1,
40f009c0:	00000713          	li	a4,0
40f009c4:	00090513          	mv	a0,s2
	(*init_count)++;
40f009c8:	00168693          	addi	a3,a3,1
40f009cc:	00d7a023          	sw	a3,0(a5)
	sbi_hart_switch_mode(hartid, scratch->next_arg1,
40f009d0:	0114c883          	lbu	a7,17(s1)
40f009d4:	00d4c803          	lbu	a6,13(s1)
40f009d8:	0094c583          	lbu	a1,9(s1)
40f009dc:	0104c283          	lbu	t0,16(s1)
40f009e0:	0124c683          	lbu	a3,18(s1)
40f009e4:	00c4cf83          	lbu	t6,12(s1)
40f009e8:	00e4c603          	lbu	a2,14(s1)
40f009ec:	0084cf03          	lbu	t5,8(s1)
40f009f0:	00a4c783          	lbu	a5,10(s1)
40f009f4:	0134ce83          	lbu	t4,19(s1)
40f009f8:	00f4ce03          	lbu	t3,15(s1)
40f009fc:	00b4c303          	lbu	t1,11(s1)
40f00a00:	00889893          	slli	a7,a7,0x8
40f00a04:	00881813          	slli	a6,a6,0x8
40f00a08:	00859593          	slli	a1,a1,0x8
40f00a0c:	01e5e5b3          	or	a1,a1,t5
40f00a10:	0058e8b3          	or	a7,a7,t0
40f00a14:	01069693          	slli	a3,a3,0x10
40f00a18:	01f86833          	or	a6,a6,t6
40f00a1c:	01061613          	slli	a2,a2,0x10
40f00a20:	01079793          	slli	a5,a5,0x10
40f00a24:	00b7e7b3          	or	a5,a5,a1
40f00a28:	0116e6b3          	or	a3,a3,a7
40f00a2c:	018e9e93          	slli	t4,t4,0x18
40f00a30:	01066633          	or	a2,a2,a6
40f00a34:	018e1e13          	slli	t3,t3,0x18
40f00a38:	01831593          	slli	a1,t1,0x18
40f00a3c:	00dee6b3          	or	a3,t4,a3
40f00a40:	00ce6633          	or	a2,t3,a2
40f00a44:	00f5e5b3          	or	a1,a1,a5
40f00a48:	724060ef          	jal	ra,40f0716c <sbi_hart_switch_mode>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00a4c:	01a4c783          	lbu	a5,26(s1)
40f00a50:	01b4c683          	lbu	a3,27(s1)
40f00a54:	00871713          	slli	a4,a4,0x8
40f00a58:	00c76733          	or	a4,a4,a2
40f00a5c:	01079793          	slli	a5,a5,0x10
40f00a60:	00e7e7b3          	or	a5,a5,a4
	init_count_offset = sbi_scratch_alloc_offset(__SIZEOF_POINTER__,
40f00a64:	00009597          	auipc	a1,0x9
40f00a68:	59c58593          	addi	a1,a1,1436 # 40f0a000 <__modsi3+0x624>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00a6c:	01869713          	slli	a4,a3,0x18
	init_count_offset = sbi_scratch_alloc_offset(__SIZEOF_POINTER__,
40f00a70:	00400513          	li	a0,4
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00a74:	00f769b3          	or	s3,a4,a5
	init_count_offset = sbi_scratch_alloc_offset(__SIZEOF_POINTER__,
40f00a78:	585000ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f00a7c:	0000b797          	auipc	a5,0xb
40f00a80:	58a7a423          	sw	a0,1416(a5) # 40f0c004 <init_count_offset>
	if (!init_count_offset)
40f00a84:	e60500e3          	beqz	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_system_early_init(scratch, TRUE);
40f00a88:	00100593          	li	a1,1
40f00a8c:	00048513          	mv	a0,s1
40f00a90:	6e5000ef          	jal	ra,40f01974 <sbi_system_early_init>
	if (rc)
40f00a94:	e40518e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_hart_init(scratch, hartid, TRUE);
40f00a98:	00100613          	li	a2,1
40f00a9c:	00090593          	mv	a1,s2
40f00aa0:	00048513          	mv	a0,s1
40f00aa4:	24c060ef          	jal	ra,40f06cf0 <sbi_hart_init>
	if (rc)
40f00aa8:	e2051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_console_init(scratch);
40f00aac:	00048513          	mv	a0,s1
40f00ab0:	445040ef          	jal	ra,40f056f4 <sbi_console_init>
	if (rc)
40f00ab4:	e20518e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	if (plat && sbi_platform_ops(plat)->irqchip_init)
40f00ab8:	06098263          	beqz	s3,40f00b1c <sbi_init+0x364>
40f00abc:	0619c683          	lbu	a3,97(s3)
40f00ac0:	0609c603          	lbu	a2,96(s3)
40f00ac4:	0629c703          	lbu	a4,98(s3)
40f00ac8:	0639c783          	lbu	a5,99(s3)
40f00acc:	00869693          	slli	a3,a3,0x8
40f00ad0:	00c6e6b3          	or	a3,a3,a2
40f00ad4:	01071713          	slli	a4,a4,0x10
40f00ad8:	00d76733          	or	a4,a4,a3
40f00adc:	01879793          	slli	a5,a5,0x18
40f00ae0:	00e7e7b3          	or	a5,a5,a4
40f00ae4:	02d7c683          	lbu	a3,45(a5)
40f00ae8:	02c7c603          	lbu	a2,44(a5)
40f00aec:	02e7c703          	lbu	a4,46(a5)
40f00af0:	02f7c783          	lbu	a5,47(a5)
40f00af4:	00869693          	slli	a3,a3,0x8
40f00af8:	00c6e6b3          	or	a3,a3,a2
40f00afc:	01071713          	slli	a4,a4,0x10
40f00b00:	00d76733          	or	a4,a4,a3
40f00b04:	01879793          	slli	a5,a5,0x18
40f00b08:	00e7e7b3          	or	a5,a5,a4
40f00b0c:	00078863          	beqz	a5,40f00b1c <sbi_init+0x364>
		return sbi_platform_ops(plat)->irqchip_init(cold_boot);
40f00b10:	00100513          	li	a0,1
40f00b14:	000780e7          	jalr	a5
	if (rc)
40f00b18:	dc0516e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_ipi_init(scratch, TRUE);
40f00b1c:	00100593          	li	a1,1
40f00b20:	00048513          	mv	a0,s1
40f00b24:	285000ef          	jal	ra,40f015a8 <sbi_ipi_init>
	if (rc)
40f00b28:	da051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_tlb_init(scratch, TRUE);
40f00b2c:	00100593          	li	a1,1
40f00b30:	00048513          	mv	a0,s1
40f00b34:	62d010ef          	jal	ra,40f02960 <sbi_tlb_init>
	if (rc)
40f00b38:	da0516e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_timer_init(scratch, TRUE);
40f00b3c:	00100593          	li	a1,1
40f00b40:	00048513          	mv	a0,s1
40f00b44:	57c010ef          	jal	ra,40f020c0 <sbi_timer_init>
	if (rc)
40f00b48:	d8051ee3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_ecall_init();
40f00b4c:	194050ef          	jal	ra,40f05ce0 <sbi_ecall_init>
	if (rc)
40f00b50:	d8051ae3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	rc = sbi_system_final_init(scratch, TRUE);
40f00b54:	00100593          	li	a1,1
40f00b58:	00048513          	mv	a0,s1
40f00b5c:	6d1000ef          	jal	ra,40f01a2c <sbi_system_final_init>
	if (rc)
40f00b60:	d80512e3          	bnez	a0,40f008e4 <sbi_init+0x12c>
	if (!(scratch->options & SBI_SCRATCH_NO_BOOT_PRINTS))
40f00b64:	0244c783          	lbu	a5,36(s1)
40f00b68:	0017f793          	andi	a5,a5,1
40f00b6c:	02078463          	beqz	a5,40f00b94 <sbi_init+0x3dc>
	sbi_hart_wake_coldboot_harts(scratch, hartid);
40f00b70:	00090593          	mv	a1,s2
40f00b74:	00048513          	mv	a0,s1
40f00b78:	211060ef          	jal	ra,40f07588 <sbi_hart_wake_coldboot_harts>
	sbi_hart_mark_available(hartid);
40f00b7c:	00090513          	mv	a0,s2
40f00b80:	6f4060ef          	jal	ra,40f07274 <sbi_hart_mark_available>
	init_count = sbi_scratch_offset_ptr(scratch, init_count_offset);
40f00b84:	0000b797          	auipc	a5,0xb
40f00b88:	48078793          	addi	a5,a5,1152 # 40f0c004 <init_count_offset>
40f00b8c:	0007a783          	lw	a5,0(a5)
40f00b90:	e29ff06f          	j	40f009b8 <sbi_init+0x200>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00b94:	0194ca03          	lbu	s4,25(s1)
40f00b98:	0184c683          	lbu	a3,24(s1)
40f00b9c:	01a4c783          	lbu	a5,26(s1)
40f00ba0:	01b4c703          	lbu	a4,27(s1)
40f00ba4:	008a1a13          	slli	s4,s4,0x8
40f00ba8:	00da6a33          	or	s4,s4,a3
40f00bac:	01079793          	slli	a5,a5,0x10
40f00bb0:	0147e7b3          	or	a5,a5,s4
	sbi_printf("\nOpenSBI %s\n", OPENSBI_VERSION_GIT);
40f00bb4:	00009597          	auipc	a1,0x9
40f00bb8:	45858593          	addi	a1,a1,1112 # 40f0a00c <__modsi3+0x630>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00bbc:	01871a13          	slli	s4,a4,0x18
	sbi_printf("\nOpenSBI %s\n", OPENSBI_VERSION_GIT);
40f00bc0:	00009517          	auipc	a0,0x9
40f00bc4:	45450513          	addi	a0,a0,1108 # 40f0a014 <__modsi3+0x638>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00bc8:	00fa6a33          	or	s4,s4,a5
	sbi_printf("\nOpenSBI %s\n", OPENSBI_VERSION_GIT);
40f00bcc:	231040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf(BANNER);
40f00bd0:	00009517          	auipc	a0,0x9
40f00bd4:	45450513          	addi	a0,a0,1108 # 40f0a024 <__modsi3+0x648>
40f00bd8:	225040ef          	jal	ra,40f055fc <sbi_printf>
	xlen = misa_xlen();
40f00bdc:	4c4030ef          	jal	ra,40f040a0 <misa_xlen>
40f00be0:	00050593          	mv	a1,a0
	if (xlen < 1) {
40f00be4:	18a05263          	blez	a0,40f00d68 <sbi_init+0x5b0>
	xlen = 16 * (1 << xlen);
40f00be8:	01000b93          	li	s7,16
40f00bec:	00ab9bb3          	sll	s7,s7,a0
40f00bf0:	04100993          	li	s3,65
40f00bf4:	f9040a93          	addi	s5,s0,-112

static inline void misa_string(char *out, unsigned int out_sz)
{
	unsigned long i;

	for (i = 0; i < 26; i++) {
40f00bf8:	05b00b13          	li	s6,91
		if (misa_extension_imp('A' + i)) {
40f00bfc:	00098513          	mv	a0,s3
40f00c00:	3d4030ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f00c04:	00050663          	beqz	a0,40f00c10 <sbi_init+0x458>
			*out = 'A' + i;
40f00c08:	013a8023          	sb	s3,0(s5)
			out++;
40f00c0c:	001a8a93          	addi	s5,s5,1
40f00c10:	00198993          	addi	s3,s3,1
40f00c14:	0ff9f993          	andi	s3,s3,255
	for (i = 0; i < 26; i++) {
40f00c18:	ff6992e3          	bne	s3,s6,40f00bfc <sbi_init+0x444>
		}
	}
	*out = '\0';
40f00c1c:	000a8023          	sb	zero,0(s5)
	if (plat)
40f00c20:	100a0e63          	beqz	s4,40f00d3c <sbi_init+0x584>
	sbi_printf("Platform Name          : %s\n", sbi_platform_name(plat));
40f00c24:	008a0593          	addi	a1,s4,8
40f00c28:	00009517          	auipc	a0,0x9
40f00c2c:	53c50513          	addi	a0,a0,1340 # 40f0a164 <__modsi3+0x788>
40f00c30:	1cd040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("Platform HART Features : RV%d%s\n", xlen, str);
40f00c34:	f9040613          	addi	a2,s0,-112
40f00c38:	000b8593          	mv	a1,s7
40f00c3c:	00009517          	auipc	a0,0x9
40f00c40:	54850513          	addi	a0,a0,1352 # 40f0a184 <__modsi3+0x7a8>
40f00c44:	1b9040ef          	jal	ra,40f055fc <sbi_printf>
		return plat->hart_count;
40f00c48:	051a4703          	lbu	a4,81(s4)
40f00c4c:	050a4603          	lbu	a2,80(s4)
40f00c50:	052a4783          	lbu	a5,82(s4)
40f00c54:	053a4683          	lbu	a3,83(s4)
40f00c58:	00871a13          	slli	s4,a4,0x8
40f00c5c:	00ca6a33          	or	s4,s4,a2
40f00c60:	01079793          	slli	a5,a5,0x10
40f00c64:	0147e7b3          	or	a5,a5,s4
40f00c68:	01869a13          	slli	s4,a3,0x18
40f00c6c:	00fa6a33          	or	s4,s4,a5
	sbi_printf("Platform Max HARTs     : %d\n",
40f00c70:	000a0593          	mv	a1,s4
40f00c74:	00009517          	auipc	a0,0x9
40f00c78:	53450513          	addi	a0,a0,1332 # 40f0a1a8 <__modsi3+0x7cc>
40f00c7c:	181040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("Current Hart           : %u\n", hartid);
40f00c80:	00090593          	mv	a1,s2
40f00c84:	00009517          	auipc	a0,0x9
40f00c88:	54450513          	addi	a0,a0,1348 # 40f0a1c8 <__modsi3+0x7ec>
40f00c8c:	171040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("Firmware Base          : 0x%lx\n", scratch->fw_start);
40f00c90:	0014c703          	lbu	a4,1(s1)
40f00c94:	0004c683          	lbu	a3,0(s1)
40f00c98:	0024c783          	lbu	a5,2(s1)
40f00c9c:	0034c583          	lbu	a1,3(s1)
40f00ca0:	00871713          	slli	a4,a4,0x8
40f00ca4:	00d76733          	or	a4,a4,a3
40f00ca8:	01079793          	slli	a5,a5,0x10
40f00cac:	00e7e7b3          	or	a5,a5,a4
40f00cb0:	01859593          	slli	a1,a1,0x18
40f00cb4:	00f5e5b3          	or	a1,a1,a5
40f00cb8:	00009517          	auipc	a0,0x9
40f00cbc:	53050513          	addi	a0,a0,1328 # 40f0a1e8 <__modsi3+0x80c>
40f00cc0:	13d040ef          	jal	ra,40f055fc <sbi_printf>
		   (u32)(scratch->fw_size / 1024));
40f00cc4:	0054c703          	lbu	a4,5(s1)
40f00cc8:	0044c683          	lbu	a3,4(s1)
40f00ccc:	0064c783          	lbu	a5,6(s1)
40f00cd0:	0074c583          	lbu	a1,7(s1)
40f00cd4:	00871713          	slli	a4,a4,0x8
40f00cd8:	00d76733          	or	a4,a4,a3
40f00cdc:	01079793          	slli	a5,a5,0x10
40f00ce0:	00e7e7b3          	or	a5,a5,a4
40f00ce4:	01859593          	slli	a1,a1,0x18
40f00ce8:	00f5e5b3          	or	a1,a1,a5
	sbi_printf("Firmware Size          : %d KB\n",
40f00cec:	00a5d593          	srli	a1,a1,0xa
40f00cf0:	00009517          	auipc	a0,0x9
40f00cf4:	51850513          	addi	a0,a0,1304 # 40f0a208 <__modsi3+0x82c>
40f00cf8:	105040ef          	jal	ra,40f055fc <sbi_printf>
		   sbi_ecall_version_major(), sbi_ecall_version_minor());
40f00cfc:	2b5040ef          	jal	ra,40f057b0 <sbi_ecall_version_major>
40f00d00:	00050993          	mv	s3,a0
40f00d04:	2c9040ef          	jal	ra,40f057cc <sbi_ecall_version_minor>
	sbi_printf("Runtime SBI Version    : %d.%d\n",
40f00d08:	00050613          	mv	a2,a0
40f00d0c:	00098593          	mv	a1,s3
40f00d10:	00009517          	auipc	a0,0x9
40f00d14:	51850513          	addi	a0,a0,1304 # 40f0a228 <__modsi3+0x84c>
40f00d18:	0e5040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("\n");
40f00d1c:	00009517          	auipc	a0,0x9
40f00d20:	42850513          	addi	a0,a0,1064 # 40f0a144 <__modsi3+0x768>
40f00d24:	0d9040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_hart_delegation_dump(scratch);
40f00d28:	00048513          	mv	a0,s1
40f00d2c:	5a9050ef          	jal	ra,40f06ad4 <sbi_hart_delegation_dump>
	sbi_hart_pmp_dump(scratch);
40f00d30:	00048513          	mv	a0,s1
40f00d34:	61d050ef          	jal	ra,40f06b50 <sbi_hart_pmp_dump>
40f00d38:	e39ff06f          	j	40f00b70 <sbi_init+0x3b8>
	sbi_printf("Platform Name          : %s\n", sbi_platform_name(plat));
40f00d3c:	00009597          	auipc	a1,0x9
40f00d40:	50c58593          	addi	a1,a1,1292 # 40f0a248 <__modsi3+0x86c>
40f00d44:	00009517          	auipc	a0,0x9
40f00d48:	42050513          	addi	a0,a0,1056 # 40f0a164 <__modsi3+0x788>
40f00d4c:	0b1040ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("Platform HART Features : RV%d%s\n", xlen, str);
40f00d50:	f9040613          	addi	a2,s0,-112
40f00d54:	000b8593          	mv	a1,s7
40f00d58:	00009517          	auipc	a0,0x9
40f00d5c:	42c50513          	addi	a0,a0,1068 # 40f0a184 <__modsi3+0x7a8>
40f00d60:	09d040ef          	jal	ra,40f055fc <sbi_printf>
	if (plat)
40f00d64:	f0dff06f          	j	40f00c70 <sbi_init+0x4b8>
		sbi_printf("Error %d getting MISA XLEN\n", xlen);
40f00d68:	00009517          	auipc	a0,0x9
40f00d6c:	3e050513          	addi	a0,a0,992 # 40f0a148 <__modsi3+0x76c>
40f00d70:	08d040ef          	jal	ra,40f055fc <sbi_printf>
40f00d74:	b71ff06f          	j	40f008e4 <sbi_init+0x12c>

40f00d78 <sbi_init_count>:
unsigned long sbi_init_count(u32 hartid)
{
	struct sbi_scratch *scratch;
	unsigned long *init_count;

	if (sbi_platform_hart_count(sbi_platform_thishart_ptr()) <= hartid ||
40f00d78:	34002673          	csrr	a2,mscratch
40f00d7c:	01964683          	lbu	a3,25(a2)
40f00d80:	01864583          	lbu	a1,24(a2)
40f00d84:	01a64703          	lbu	a4,26(a2)
40f00d88:	01b64783          	lbu	a5,27(a2)
40f00d8c:	00869693          	slli	a3,a3,0x8
40f00d90:	00b6e6b3          	or	a3,a3,a1
40f00d94:	01071713          	slli	a4,a4,0x10
40f00d98:	00d76733          	or	a4,a4,a3
40f00d9c:	01879793          	slli	a5,a5,0x18
40f00da0:	00e7e7b3          	or	a5,a5,a4
40f00da4:	0a078063          	beqz	a5,40f00e44 <sbi_init_count+0xcc>
		return plat->hart_count;
40f00da8:	0517c683          	lbu	a3,81(a5)
40f00dac:	0507c603          	lbu	a2,80(a5)
40f00db0:	0527c703          	lbu	a4,82(a5)
40f00db4:	0537c783          	lbu	a5,83(a5)
40f00db8:	00869693          	slli	a3,a3,0x8
40f00dbc:	00c6e6b3          	or	a3,a3,a2
40f00dc0:	01071713          	slli	a4,a4,0x10
40f00dc4:	00d76733          	or	a4,a4,a3
40f00dc8:	01879793          	slli	a5,a5,0x18
40f00dcc:	00e7e7b3          	or	a5,a5,a4
40f00dd0:	06f57863          	bgeu	a0,a5,40f00e40 <sbi_init_count+0xc8>
{
40f00dd4:	ff010113          	addi	sp,sp,-16
40f00dd8:	00812423          	sw	s0,8(sp)
40f00ddc:	00912223          	sw	s1,4(sp)
40f00de0:	00112623          	sw	ra,12(sp)
40f00de4:	01010413          	addi	s0,sp,16
	    !init_count_offset)
40f00de8:	0000b497          	auipc	s1,0xb
40f00dec:	21c48493          	addi	s1,s1,540 # 40f0c004 <init_count_offset>
40f00df0:	0004a783          	lw	a5,0(s1)
	if (sbi_platform_hart_count(sbi_platform_thishart_ptr()) <= hartid ||
40f00df4:	00079e63          	bnez	a5,40f00e10 <sbi_init_count+0x98>

	scratch = sbi_hart_id_to_scratch(sbi_scratch_thishart_ptr(), hartid);
	init_count = sbi_scratch_offset_ptr(scratch, init_count_offset);

	return *init_count;
}
40f00df8:	00c12083          	lw	ra,12(sp)
40f00dfc:	00812403          	lw	s0,8(sp)
40f00e00:	00412483          	lw	s1,4(sp)
40f00e04:	00078513          	mv	a0,a5
40f00e08:	01010113          	addi	sp,sp,16
40f00e0c:	00008067          	ret
	scratch = sbi_hart_id_to_scratch(sbi_scratch_thishart_ptr(), hartid);
40f00e10:	00050593          	mv	a1,a0
40f00e14:	34002573          	csrr	a0,mscratch
40f00e18:	570060ef          	jal	ra,40f07388 <sbi_hart_id_to_scratch>
	return *init_count;
40f00e1c:	0004a783          	lw	a5,0(s1)
}
40f00e20:	00c12083          	lw	ra,12(sp)
40f00e24:	00812403          	lw	s0,8(sp)
	return *init_count;
40f00e28:	00f50533          	add	a0,a0,a5
40f00e2c:	00052783          	lw	a5,0(a0)
}
40f00e30:	00412483          	lw	s1,4(sp)
40f00e34:	00078513          	mv	a0,a5
40f00e38:	01010113          	addi	sp,sp,16
40f00e3c:	00008067          	ret
		return 0;
40f00e40:	00000793          	li	a5,0
}
40f00e44:	00078513          	mv	a0,a5
40f00e48:	00008067          	ret

40f00e4c <sbi_exit>:
 * 2. Stack pointer (SP) is setup for current HART
 *
 * @param scratch pointer to sbi_scratch of current HART
 */
void __noreturn sbi_exit(struct sbi_scratch *scratch)
{
40f00e4c:	ff010113          	addi	sp,sp,-16
40f00e50:	00812423          	sw	s0,8(sp)
40f00e54:	00912223          	sw	s1,4(sp)
40f00e58:	01212023          	sw	s2,0(sp)
40f00e5c:	00112623          	sw	ra,12(sp)
40f00e60:	01010413          	addi	s0,sp,16
40f00e64:	00050913          	mv	s2,a0
	u32 hartid			= sbi_current_hartid();
40f00e68:	451050ef          	jal	ra,40f06ab8 <sbi_current_hartid>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f00e6c:	01994483          	lbu	s1,25(s2)
40f00e70:	01894603          	lbu	a2,24(s2)
40f00e74:	01a94703          	lbu	a4,26(s2)
40f00e78:	01b94683          	lbu	a3,27(s2)
40f00e7c:	00849493          	slli	s1,s1,0x8
40f00e80:	00c4e4b3          	or	s1,s1,a2
40f00e84:	01071713          	slli	a4,a4,0x10
40f00e88:	00976733          	or	a4,a4,s1
40f00e8c:	01869493          	slli	s1,a3,0x18
40f00e90:	00e4e4b3          	or	s1,s1,a4
	if (plat && (plat->disabled_hart_mask & (1 << hartid)))
40f00e94:	18048863          	beqz	s1,40f01024 <sbi_exit+0x1d8>
40f00e98:	0594c783          	lbu	a5,89(s1)
40f00e9c:	05d4c803          	lbu	a6,93(s1)
40f00ea0:	05c4c883          	lbu	a7,92(s1)
40f00ea4:	0584ce03          	lbu	t3,88(s1)
40f00ea8:	05a4c583          	lbu	a1,90(s1)
40f00eac:	05e4c603          	lbu	a2,94(s1)
40f00eb0:	05b4c703          	lbu	a4,91(s1)
40f00eb4:	05f4c683          	lbu	a3,95(s1)
40f00eb8:	00879793          	slli	a5,a5,0x8
40f00ebc:	00881813          	slli	a6,a6,0x8
40f00ec0:	01c7e7b3          	or	a5,a5,t3
40f00ec4:	01186833          	or	a6,a6,a7
40f00ec8:	01059593          	slli	a1,a1,0x10
40f00ecc:	01061613          	slli	a2,a2,0x10
40f00ed0:	00100893          	li	a7,1
40f00ed4:	00a898b3          	sll	a7,a7,a0
40f00ed8:	00f5e5b3          	or	a1,a1,a5
40f00edc:	01066633          	or	a2,a2,a6
40f00ee0:	01871793          	slli	a5,a4,0x18
40f00ee4:	01869713          	slli	a4,a3,0x18
40f00ee8:	00b7e7b3          	or	a5,a5,a1
40f00eec:	00c76733          	or	a4,a4,a2
40f00ef0:	41f8d693          	srai	a3,a7,0x1f
40f00ef4:	0117f7b3          	and	a5,a5,a7
40f00ef8:	00d77733          	and	a4,a4,a3
40f00efc:	00e7e7b3          	or	a5,a5,a4
40f00f00:	12079063          	bnez	a5,40f01020 <sbi_exit+0x1d4>

	if (sbi_platform_hart_disabled(plat, hartid))
		sbi_hart_hang();

	sbi_hart_unmark_available(hartid);
40f00f04:	3d0060ef          	jal	ra,40f072d4 <sbi_hart_unmark_available>
	if (plat && sbi_platform_ops(plat)->early_exit)
40f00f08:	0614c683          	lbu	a3,97(s1)
40f00f0c:	0604c603          	lbu	a2,96(s1)
40f00f10:	0624c703          	lbu	a4,98(s1)
40f00f14:	0634c783          	lbu	a5,99(s1)
40f00f18:	00869693          	slli	a3,a3,0x8
40f00f1c:	00c6e6b3          	or	a3,a3,a2
40f00f20:	01071713          	slli	a4,a4,0x10
40f00f24:	00d76733          	or	a4,a4,a3
40f00f28:	01879793          	slli	a5,a5,0x18
40f00f2c:	00e7e7b3          	or	a5,a5,a4
40f00f30:	0097c683          	lbu	a3,9(a5)
40f00f34:	0087c603          	lbu	a2,8(a5)
40f00f38:	00a7c703          	lbu	a4,10(a5)
40f00f3c:	00b7c783          	lbu	a5,11(a5)
40f00f40:	00869693          	slli	a3,a3,0x8
40f00f44:	00c6e6b3          	or	a3,a3,a2
40f00f48:	01071713          	slli	a4,a4,0x10
40f00f4c:	00d76733          	or	a4,a4,a3
40f00f50:	01879793          	slli	a5,a5,0x18
40f00f54:	00e7e7b3          	or	a5,a5,a4
40f00f58:	00078463          	beqz	a5,40f00f60 <sbi_exit+0x114>
		sbi_platform_ops(plat)->early_exit();
40f00f5c:	000780e7          	jalr	a5

	sbi_platform_early_exit(plat);

	sbi_timer_exit(scratch);
40f00f60:	00090513          	mv	a0,s2
40f00f64:	26c010ef          	jal	ra,40f021d0 <sbi_timer_exit>

	sbi_ipi_exit(scratch);
40f00f68:	00090513          	mv	a0,s2
40f00f6c:	7d8000ef          	jal	ra,40f01744 <sbi_ipi_exit>
 *
 * @param plat pointer to struct sbi_platform
 */
static inline void sbi_platform_irqchip_exit(const struct sbi_platform *plat)
{
	if (plat && sbi_platform_ops(plat)->irqchip_exit)
40f00f70:	0614c783          	lbu	a5,97(s1)
40f00f74:	0604c803          	lbu	a6,96(s1)
40f00f78:	0624c683          	lbu	a3,98(s1)
40f00f7c:	0634c703          	lbu	a4,99(s1)
40f00f80:	00879593          	slli	a1,a5,0x8
40f00f84:	01069613          	slli	a2,a3,0x10
40f00f88:	0105e5b3          	or	a1,a1,a6
40f00f8c:	00b665b3          	or	a1,a2,a1
40f00f90:	01871613          	slli	a2,a4,0x18
40f00f94:	00b66633          	or	a2,a2,a1
40f00f98:	03164503          	lbu	a0,49(a2)
40f00f9c:	03064883          	lbu	a7,48(a2)
40f00fa0:	03264583          	lbu	a1,50(a2)
40f00fa4:	03364603          	lbu	a2,51(a2)
40f00fa8:	00851513          	slli	a0,a0,0x8
40f00fac:	01156533          	or	a0,a0,a7
40f00fb0:	01059593          	slli	a1,a1,0x10
40f00fb4:	00a5e5b3          	or	a1,a1,a0
40f00fb8:	01861613          	slli	a2,a2,0x18
40f00fbc:	00b66633          	or	a2,a2,a1
40f00fc0:	00060c63          	beqz	a2,40f00fd8 <sbi_exit+0x18c>
		sbi_platform_ops(plat)->irqchip_exit();
40f00fc4:	000600e7          	jalr	a2
40f00fc8:	0604c803          	lbu	a6,96(s1)
40f00fcc:	0614c783          	lbu	a5,97(s1)
40f00fd0:	0624c683          	lbu	a3,98(s1)
40f00fd4:	0634c703          	lbu	a4,99(s1)
	if (plat && sbi_platform_ops(plat)->final_exit)
40f00fd8:	00879793          	slli	a5,a5,0x8
40f00fdc:	0107e7b3          	or	a5,a5,a6
40f00fe0:	01069693          	slli	a3,a3,0x10
40f00fe4:	00f6e6b3          	or	a3,a3,a5
40f00fe8:	01871793          	slli	a5,a4,0x18
40f00fec:	00d7e7b3          	or	a5,a5,a3
40f00ff0:	00d7c683          	lbu	a3,13(a5)
40f00ff4:	00c7c603          	lbu	a2,12(a5)
40f00ff8:	00e7c703          	lbu	a4,14(a5)
40f00ffc:	00f7c783          	lbu	a5,15(a5)
40f01000:	00869693          	slli	a3,a3,0x8
40f01004:	00c6e6b3          	or	a3,a3,a2
40f01008:	01071713          	slli	a4,a4,0x10
40f0100c:	00d76733          	or	a4,a4,a3
40f01010:	01879793          	slli	a5,a5,0x18
40f01014:	00e7e7b3          	or	a5,a5,a4
40f01018:	00078463          	beqz	a5,40f01020 <sbi_exit+0x1d4>
		sbi_platform_ops(plat)->final_exit();
40f0101c:	000780e7          	jalr	a5
		sbi_hart_hang();
40f01020:	134060ef          	jal	ra,40f07154 <sbi_hart_hang>
	sbi_hart_unmark_available(hartid);
40f01024:	2b0060ef          	jal	ra,40f072d4 <sbi_hart_unmark_available>
	sbi_timer_exit(scratch);
40f01028:	00090513          	mv	a0,s2
40f0102c:	1a4010ef          	jal	ra,40f021d0 <sbi_timer_exit>
	sbi_ipi_exit(scratch);
40f01030:	00090513          	mv	a0,s2
40f01034:	710000ef          	jal	ra,40f01744 <sbi_ipi_exit>
	if (plat && sbi_platform_ops(plat)->irqchip_exit)
40f01038:	fe9ff06f          	j	40f01020 <sbi_exit+0x1d4>

40f0103c <sbi_ipi_process_smode>:

	ipi_ops_array[event] = NULL;
}

static void sbi_ipi_process_smode(struct sbi_scratch *scratch)
{
40f0103c:	ff010113          	addi	sp,sp,-16
40f01040:	00812623          	sw	s0,12(sp)
40f01044:	01010413          	addi	s0,sp,16
	csr_set(CSR_MIP, MIP_SSIP);
40f01048:	34416073          	csrsi	mip,2
}
40f0104c:	00c12403          	lw	s0,12(sp)
40f01050:	01010113          	addi	sp,sp,16
40f01054:	00008067          	ret

40f01058 <sbi_ipi_process_halt>:
{
	csr_clear(CSR_MIP, MIP_SSIP);
}

static void sbi_ipi_process_halt(struct sbi_scratch *scratch)
{
40f01058:	ff010113          	addi	sp,sp,-16
40f0105c:	00812423          	sw	s0,8(sp)
40f01060:	00112623          	sw	ra,12(sp)
40f01064:	01010413          	addi	s0,sp,16
	sbi_exit(scratch);
40f01068:	de5ff0ef          	jal	ra,40f00e4c <sbi_exit>

40f0106c <sbi_ipi_event_create.part.0>:
int sbi_ipi_event_create(const struct sbi_ipi_event_ops *ops)
40f0106c:	ff010113          	addi	sp,sp,-16
40f01070:	00812623          	sw	s0,12(sp)
40f01074:	0000b597          	auipc	a1,0xb
40f01078:	fec58593          	addi	a1,a1,-20 # 40f0c060 <ipi_ops_array>
40f0107c:	01010413          	addi	s0,sp,16
40f01080:	00058713          	mv	a4,a1
	for (i = 0; i < SBI_IPI_EVENT_MAX; i++) {
40f01084:	00000793          	li	a5,0
40f01088:	02000613          	li	a2,32
40f0108c:	00c0006f          	j	40f01098 <sbi_ipi_event_create.part.0+0x2c>
40f01090:	00178793          	addi	a5,a5,1
40f01094:	02c78663          	beq	a5,a2,40f010c0 <sbi_ipi_event_create.part.0+0x54>
		if (!ipi_ops_array[i]) {
40f01098:	00072683          	lw	a3,0(a4)
40f0109c:	00470713          	addi	a4,a4,4
40f010a0:	fe0698e3          	bnez	a3,40f01090 <sbi_ipi_event_create.part.0+0x24>
			ipi_ops_array[i] = ops;
40f010a4:	00279713          	slli	a4,a5,0x2
40f010a8:	00e585b3          	add	a1,a1,a4
40f010ac:	00a5a023          	sw	a0,0(a1)
}
40f010b0:	00c12403          	lw	s0,12(sp)
40f010b4:	00078513          	mv	a0,a5
40f010b8:	01010113          	addi	sp,sp,16
40f010bc:	00008067          	ret
40f010c0:	00c12403          	lw	s0,12(sp)
	int i, ret = SBI_ENOSPC;
40f010c4:	ff500793          	li	a5,-11
}
40f010c8:	00078513          	mv	a0,a5
40f010cc:	01010113          	addi	sp,sp,16
40f010d0:	00008067          	ret

40f010d4 <sbi_ipi_send_many>:
{
40f010d4:	fb010113          	addi	sp,sp,-80
40f010d8:	04812423          	sw	s0,72(sp)
40f010dc:	04912223          	sw	s1,68(sp)
40f010e0:	05212023          	sw	s2,64(sp)
40f010e4:	03312e23          	sw	s3,60(sp)
40f010e8:	03512a23          	sw	s5,52(sp)
40f010ec:	01b12e23          	sw	s11,28(sp)
40f010f0:	05010413          	addi	s0,sp,80
40f010f4:	04112623          	sw	ra,76(sp)
40f010f8:	03412c23          	sw	s4,56(sp)
40f010fc:	03612823          	sw	s6,48(sp)
40f01100:	03712623          	sw	s7,44(sp)
40f01104:	03812423          	sw	s8,40(sp)
40f01108:	03912223          	sw	s9,36(sp)
40f0110c:	03a12023          	sw	s10,32(sp)
40f01110:	00050d93          	mv	s11,a0
40f01114:	00058913          	mv	s2,a1
40f01118:	00060993          	mv	s3,a2
40f0111c:	00068a93          	mv	s5,a3
40f01120:	fae42e23          	sw	a4,-68(s0)
	ulong mask = sbi_hart_available_mask();
40f01124:	214060ef          	jal	ra,40f07338 <sbi_hart_available_mask>
	if (!(word & (~0ul << 32))) {
		num -= 32;
		word <<= 32;
	}
#endif
	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
40f01128:	ffff07b7          	lui	a5,0xffff0
40f0112c:	00f577b3          	and	a5,a0,a5
40f01130:	00050493          	mv	s1,a0
40f01134:	24079a63          	bnez	a5,40f01388 <sbi_ipi_send_many+0x2b4>
		num -= 16;
		word <<= 16;
40f01138:	01051793          	slli	a5,a0,0x10
		num -= 16;
40f0113c:	00f00713          	li	a4,15
	}
	if (!(word & (~0ul << (BITS_PER_LONG-8)))) {
40f01140:	ff0006b7          	lui	a3,0xff000
40f01144:	00d7f6b3          	and	a3,a5,a3
40f01148:	00069663          	bnez	a3,40f01154 <sbi_ipi_send_many+0x80>
		num -= 8;
40f0114c:	ff870713          	addi	a4,a4,-8
		word <<= 8;
40f01150:	00879793          	slli	a5,a5,0x8
	}
	if (!(word & (~0ul << (BITS_PER_LONG-4)))) {
40f01154:	f00006b7          	lui	a3,0xf0000
40f01158:	00d7f6b3          	and	a3,a5,a3
40f0115c:	00069663          	bnez	a3,40f01168 <sbi_ipi_send_many+0x94>
		num -= 4;
40f01160:	ffc70713          	addi	a4,a4,-4
		word <<= 4;
40f01164:	00479793          	slli	a5,a5,0x4
	}
	if (!(word & (~0ul << (BITS_PER_LONG-2)))) {
40f01168:	c00006b7          	lui	a3,0xc0000
40f0116c:	00d7f6b3          	and	a3,a5,a3
40f01170:	00069663          	bnez	a3,40f0117c <sbi_ipi_send_many+0xa8>
		num -= 2;
40f01174:	ffe70713          	addi	a4,a4,-2
		word <<= 2;
40f01178:	00279793          	slli	a5,a5,0x2
	}
	if (!(word & (~0ul << (BITS_PER_LONG-1))))
		num -= 1;
40f0117c:	fff7c793          	not	a5,a5
40f01180:	01f7d793          	srli	a5,a5,0x1f
	if (hbase != -1UL) {
40f01184:	fff00693          	li	a3,-1
40f01188:	40f70733          	sub	a4,a4,a5
40f0118c:	00d98e63          	beq	s3,a3,40f011a8 <sbi_ipi_send_many+0xd4>
		if (hbase > last_bit)
40f01190:	21376263          	bltu	a4,s3,40f01394 <sbi_ipi_send_many+0x2c0>
		tempmask = hmask << hbase;
40f01194:	01391933          	sll	s2,s2,s3
		tempmask = ~mask & tempmask;
40f01198:	fff4c793          	not	a5,s1
40f0119c:	0127f7b3          	and	a5,a5,s2
		if (tempmask)
40f011a0:	1e079a63          	bnez	a5,40f01394 <sbi_ipi_send_many+0x2c0>
		mask &= (hmask << hbase);
40f011a4:	0124f4b3          	and	s1,s1,s2
	for (i = 0, m = mask; m; i++, m >>= 1)
40f011a8:	00000993          	li	s3,0
40f011ac:	18048e63          	beqz	s1,40f01348 <sbi_ipi_send_many+0x274>
	    !ipi_ops_array[event] ||
40f011b0:	002a9b13          	slli	s6,s5,0x2
40f011b4:	0000b797          	auipc	a5,0xb
40f011b8:	eac78793          	addi	a5,a5,-340 # 40f0c060 <ipi_ops_array>
	if ((SBI_IPI_EVENT_MAX <= event) ||
40f011bc:	01f00b93          	li	s7,31
	    !ipi_ops_array[event] ||
40f011c0:	01678b33          	add	s6,a5,s6
	ipi_data = sbi_scratch_offset_ptr(remote_scratch, ipi_data_off);
40f011c4:	0000bc17          	auipc	s8,0xb
40f011c8:	e44c0c13          	addi	s8,s8,-444 # 40f0c008 <ipi_data_off>
	if (plat && (plat->disabled_hart_mask & (1 << hartid)))
40f011cc:	00100c93          	li	s9,1
40f011d0:	0100006f          	j	40f011e0 <sbi_ipi_send_many+0x10c>
	for (i = 0, m = mask; m; i++, m >>= 1)
40f011d4:	0014d493          	srli	s1,s1,0x1
40f011d8:	00198993          	addi	s3,s3,1
40f011dc:	16048663          	beqz	s1,40f01348 <sbi_ipi_send_many+0x274>
		if (m & 1UL)
40f011e0:	0014f793          	andi	a5,s1,1
40f011e4:	fe0788e3          	beqz	a5,40f011d4 <sbi_ipi_send_many+0x100>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f011e8:	019dc903          	lbu	s2,25(s11)
40f011ec:	018dc683          	lbu	a3,24(s11)
40f011f0:	01adc783          	lbu	a5,26(s11)
40f011f4:	01bdc703          	lbu	a4,27(s11)
40f011f8:	00891913          	slli	s2,s2,0x8
40f011fc:	00d96933          	or	s2,s2,a3
40f01200:	01079793          	slli	a5,a5,0x10
40f01204:	0127e7b3          	or	a5,a5,s2
40f01208:	01871913          	slli	s2,a4,0x18
40f0120c:	00f96933          	or	s2,s2,a5
	if ((SBI_IPI_EVENT_MAX <= event) ||
40f01210:	fd5be2e3          	bltu	s7,s5,40f011d4 <sbi_ipi_send_many+0x100>
	    !ipi_ops_array[event] ||
40f01214:	000b2a03          	lw	s4,0(s6)
	if ((SBI_IPI_EVENT_MAX <= event) ||
40f01218:	fa0a0ee3          	beqz	s4,40f011d4 <sbi_ipi_send_many+0x100>
40f0121c:	06090663          	beqz	s2,40f01288 <sbi_ipi_send_many+0x1b4>
40f01220:	05994803          	lbu	a6,89(s2)
40f01224:	05d94503          	lbu	a0,93(s2)
40f01228:	05c94783          	lbu	a5,92(s2)
40f0122c:	05894883          	lbu	a7,88(s2)
40f01230:	05a94583          	lbu	a1,90(s2)
40f01234:	05e94603          	lbu	a2,94(s2)
40f01238:	05b94703          	lbu	a4,91(s2)
40f0123c:	05f94683          	lbu	a3,95(s2)
40f01240:	00881813          	slli	a6,a6,0x8
40f01244:	00851513          	slli	a0,a0,0x8
40f01248:	00f56533          	or	a0,a0,a5
40f0124c:	01186833          	or	a6,a6,a7
40f01250:	01059593          	slli	a1,a1,0x10
40f01254:	01061613          	slli	a2,a2,0x10
40f01258:	013c97b3          	sll	a5,s9,s3
40f0125c:	00a66633          	or	a2,a2,a0
40f01260:	0105e5b3          	or	a1,a1,a6
40f01264:	01871713          	slli	a4,a4,0x18
40f01268:	01869693          	slli	a3,a3,0x18
40f0126c:	00b76733          	or	a4,a4,a1
40f01270:	00c6e6b3          	or	a3,a3,a2
40f01274:	41f7d613          	srai	a2,a5,0x1f
40f01278:	00f777b3          	and	a5,a4,a5
40f0127c:	00c6f733          	and	a4,a3,a2
40f01280:	00e7e7b3          	or	a5,a5,a4
40f01284:	f40798e3          	bnez	a5,40f011d4 <sbi_ipi_send_many+0x100>
	remote_scratch = sbi_hart_id_to_scratch(scratch, remote_hartid);
40f01288:	00098593          	mv	a1,s3
40f0128c:	000d8513          	mv	a0,s11
40f01290:	0f8060ef          	jal	ra,40f07388 <sbi_hart_id_to_scratch>
	ipi_data = sbi_scratch_offset_ptr(remote_scratch, ipi_data_off);
40f01294:	000c2783          	lw	a5,0(s8)
	if (ipi_ops->update) {
40f01298:	020a2703          	lw	a4,32(s4)
	ipi_data = sbi_scratch_offset_ptr(remote_scratch, ipi_data_off);
40f0129c:	00f50d33          	add	s10,a0,a5
	if (ipi_ops->update) {
40f012a0:	00070e63          	beqz	a4,40f012bc <sbi_ipi_send_many+0x1e8>
		ret = ipi_ops->update(scratch, remote_scratch,
40f012a4:	fbc42683          	lw	a3,-68(s0)
40f012a8:	00050593          	mv	a1,a0
40f012ac:	00098613          	mv	a2,s3
40f012b0:	000d8513          	mv	a0,s11
40f012b4:	000700e7          	jalr	a4
		if (ret < 0)
40f012b8:	f0054ee3          	bltz	a0,40f011d4 <sbi_ipi_send_many+0x100>
	atomic_raw_set_bit(event, &ipi_data->ipi_type);
40f012bc:	000d0593          	mv	a1,s10
40f012c0:	000a8513          	mv	a0,s5
40f012c4:	438030ef          	jal	ra,40f046fc <atomic_raw_set_bit>
	smp_wmb();
40f012c8:	0110000f          	fence	w,w
 * @param target_hart HART ID of IPI target
 */
static inline void sbi_platform_ipi_send(const struct sbi_platform *plat,
					 u32 target_hart)
{
	if (plat && sbi_platform_ops(plat)->ipi_send)
40f012cc:	06090063          	beqz	s2,40f0132c <sbi_ipi_send_many+0x258>
40f012d0:	06194683          	lbu	a3,97(s2)
40f012d4:	06094603          	lbu	a2,96(s2)
40f012d8:	06294703          	lbu	a4,98(s2)
40f012dc:	06394783          	lbu	a5,99(s2)
40f012e0:	00869693          	slli	a3,a3,0x8
40f012e4:	00c6e6b3          	or	a3,a3,a2
40f012e8:	01071713          	slli	a4,a4,0x10
40f012ec:	00d76733          	or	a4,a4,a3
40f012f0:	01879793          	slli	a5,a5,0x18
40f012f4:	00e7e7b3          	or	a5,a5,a4
40f012f8:	0357c683          	lbu	a3,53(a5)
40f012fc:	0347c603          	lbu	a2,52(a5)
40f01300:	0367c703          	lbu	a4,54(a5)
40f01304:	0377c783          	lbu	a5,55(a5)
40f01308:	00869693          	slli	a3,a3,0x8
40f0130c:	00c6e6b3          	or	a3,a3,a2
40f01310:	01071713          	slli	a4,a4,0x10
40f01314:	00d76733          	or	a4,a4,a3
40f01318:	01879793          	slli	a5,a5,0x18
40f0131c:	00e7e7b3          	or	a5,a5,a4
40f01320:	00078663          	beqz	a5,40f0132c <sbi_ipi_send_many+0x258>
		sbi_platform_ops(plat)->ipi_send(target_hart);
40f01324:	00098513          	mv	a0,s3
40f01328:	000780e7          	jalr	a5
	if (ipi_ops->sync)
40f0132c:	024a2783          	lw	a5,36(s4)
40f01330:	ea0782e3          	beqz	a5,40f011d4 <sbi_ipi_send_many+0x100>
		ipi_ops->sync(scratch);
40f01334:	000d8513          	mv	a0,s11
	for (i = 0, m = mask; m; i++, m >>= 1)
40f01338:	0014d493          	srli	s1,s1,0x1
		ipi_ops->sync(scratch);
40f0133c:	000780e7          	jalr	a5
	for (i = 0, m = mask; m; i++, m >>= 1)
40f01340:	00198993          	addi	s3,s3,1
40f01344:	e8049ee3          	bnez	s1,40f011e0 <sbi_ipi_send_many+0x10c>
	return 0;
40f01348:	00000513          	li	a0,0
}
40f0134c:	04c12083          	lw	ra,76(sp)
40f01350:	04812403          	lw	s0,72(sp)
40f01354:	04412483          	lw	s1,68(sp)
40f01358:	04012903          	lw	s2,64(sp)
40f0135c:	03c12983          	lw	s3,60(sp)
40f01360:	03812a03          	lw	s4,56(sp)
40f01364:	03412a83          	lw	s5,52(sp)
40f01368:	03012b03          	lw	s6,48(sp)
40f0136c:	02c12b83          	lw	s7,44(sp)
40f01370:	02812c03          	lw	s8,40(sp)
40f01374:	02412c83          	lw	s9,36(sp)
40f01378:	02012d03          	lw	s10,32(sp)
40f0137c:	01c12d83          	lw	s11,28(sp)
40f01380:	05010113          	addi	sp,sp,80
40f01384:	00008067          	ret
	if (!(word & (~0ul << (BITS_PER_LONG-16)))) {
40f01388:	00050793          	mv	a5,a0
	int num = BITS_PER_LONG - 1;
40f0138c:	01f00713          	li	a4,31
40f01390:	db1ff06f          	j	40f01140 <sbi_ipi_send_many+0x6c>
			return SBI_EINVAL;
40f01394:	ffd00513          	li	a0,-3
40f01398:	fb5ff06f          	j	40f0134c <sbi_ipi_send_many+0x278>

40f0139c <sbi_ipi_event_create>:
	if (!ops || !ops->process)
40f0139c:	02050863          	beqz	a0,40f013cc <sbi_ipi_event_create+0x30>
40f013a0:	02852783          	lw	a5,40(a0)
40f013a4:	02078463          	beqz	a5,40f013cc <sbi_ipi_event_create+0x30>
{
40f013a8:	ff010113          	addi	sp,sp,-16
40f013ac:	00812423          	sw	s0,8(sp)
40f013b0:	00112623          	sw	ra,12(sp)
40f013b4:	01010413          	addi	s0,sp,16
40f013b8:	cb5ff0ef          	jal	ra,40f0106c <sbi_ipi_event_create.part.0>
}
40f013bc:	00c12083          	lw	ra,12(sp)
40f013c0:	00812403          	lw	s0,8(sp)
40f013c4:	01010113          	addi	sp,sp,16
40f013c8:	00008067          	ret
		return SBI_EINVAL;
40f013cc:	ffd00513          	li	a0,-3
}
40f013d0:	00008067          	ret

40f013d4 <sbi_ipi_event_destroy>:
{
40f013d4:	ff010113          	addi	sp,sp,-16
40f013d8:	00812623          	sw	s0,12(sp)
40f013dc:	01010413          	addi	s0,sp,16
	if (SBI_IPI_EVENT_MAX <= event)
40f013e0:	01f00793          	li	a5,31
40f013e4:	00a7ec63          	bltu	a5,a0,40f013fc <sbi_ipi_event_destroy+0x28>
	ipi_ops_array[event] = NULL;
40f013e8:	00251513          	slli	a0,a0,0x2
40f013ec:	0000b797          	auipc	a5,0xb
40f013f0:	c7478793          	addi	a5,a5,-908 # 40f0c060 <ipi_ops_array>
40f013f4:	00a78533          	add	a0,a5,a0
40f013f8:	00052023          	sw	zero,0(a0)
}
40f013fc:	00c12403          	lw	s0,12(sp)
40f01400:	01010113          	addi	sp,sp,16
40f01404:	00008067          	ret

40f01408 <sbi_ipi_send_smode>:
{
40f01408:	ff010113          	addi	sp,sp,-16
40f0140c:	00812423          	sw	s0,8(sp)
40f01410:	00112623          	sw	ra,12(sp)
40f01414:	01010413          	addi	s0,sp,16
	return sbi_ipi_send_many(scratch, hmask, hbase, ipi_smode_event, NULL);
40f01418:	0000a797          	auipc	a5,0xa
40f0141c:	bec78793          	addi	a5,a5,-1044 # 40f0b004 <ipi_smode_event>
40f01420:	0007a683          	lw	a3,0(a5)
40f01424:	00000713          	li	a4,0
40f01428:	cadff0ef          	jal	ra,40f010d4 <sbi_ipi_send_many>
}
40f0142c:	00c12083          	lw	ra,12(sp)
40f01430:	00812403          	lw	s0,8(sp)
40f01434:	01010113          	addi	sp,sp,16
40f01438:	00008067          	ret

40f0143c <sbi_ipi_clear_smode>:
{
40f0143c:	ff010113          	addi	sp,sp,-16
40f01440:	00812623          	sw	s0,12(sp)
40f01444:	01010413          	addi	s0,sp,16
	csr_clear(CSR_MIP, MIP_SSIP);
40f01448:	34417073          	csrci	mip,2
}
40f0144c:	00c12403          	lw	s0,12(sp)
40f01450:	01010113          	addi	sp,sp,16
40f01454:	00008067          	ret

40f01458 <sbi_ipi_send_halt>:
};

static u32 ipi_halt_event = SBI_IPI_EVENT_MAX;

int sbi_ipi_send_halt(struct sbi_scratch *scratch, ulong hmask, ulong hbase)
{
40f01458:	ff010113          	addi	sp,sp,-16
40f0145c:	00812423          	sw	s0,8(sp)
40f01460:	00112623          	sw	ra,12(sp)
40f01464:	01010413          	addi	s0,sp,16
	return sbi_ipi_send_many(scratch, hmask, hbase, ipi_halt_event, NULL);
40f01468:	0000a797          	auipc	a5,0xa
40f0146c:	b9878793          	addi	a5,a5,-1128 # 40f0b000 <ipi_halt_event>
40f01470:	0007a683          	lw	a3,0(a5)
40f01474:	00000713          	li	a4,0
40f01478:	c5dff0ef          	jal	ra,40f010d4 <sbi_ipi_send_many>
}
40f0147c:	00c12083          	lw	ra,12(sp)
40f01480:	00812403          	lw	s0,8(sp)
40f01484:	01010113          	addi	sp,sp,16
40f01488:	00008067          	ret

40f0148c <sbi_ipi_process>:

void sbi_ipi_process(struct sbi_scratch *scratch)
{
40f0148c:	fe010113          	addi	sp,sp,-32
40f01490:	00812c23          	sw	s0,24(sp)
40f01494:	01312623          	sw	s3,12(sp)
40f01498:	00112e23          	sw	ra,28(sp)
40f0149c:	00912a23          	sw	s1,20(sp)
40f014a0:	01212823          	sw	s2,16(sp)
40f014a4:	02010413          	addi	s0,sp,32
	unsigned long ipi_type;
	unsigned int ipi_event;
	const struct sbi_ipi_event_ops *ipi_ops;
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f014a8:	01954703          	lbu	a4,25(a0)
40f014ac:	01854683          	lbu	a3,24(a0)
40f014b0:	01a54783          	lbu	a5,26(a0)
40f014b4:	01b54483          	lbu	s1,27(a0)
40f014b8:	00871713          	slli	a4,a4,0x8
40f014bc:	00d76733          	or	a4,a4,a3
	struct sbi_ipi_data *ipi_data =
40f014c0:	0000b697          	auipc	a3,0xb
40f014c4:	b4868693          	addi	a3,a3,-1208 # 40f0c008 <ipi_data_off>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f014c8:	01079793          	slli	a5,a5,0x10
	struct sbi_ipi_data *ipi_data =
40f014cc:	0006a903          	lw	s2,0(a3)
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f014d0:	00e7e7b3          	or	a5,a5,a4
40f014d4:	01849493          	slli	s1,s1,0x18
40f014d8:	00f4e4b3          	or	s1,s1,a5
{
40f014dc:	00050993          	mv	s3,a0
	struct sbi_ipi_data *ipi_data =
40f014e0:	01250933          	add	s2,a0,s2
			sbi_scratch_offset_ptr(scratch, ipi_data_off);

	u32 hartid = sbi_current_hartid();
40f014e4:	5d4050ef          	jal	ra,40f06ab8 <sbi_current_hartid>
 * @param target_hart HART ID of IPI target
 */
static inline void sbi_platform_ipi_clear(const struct sbi_platform *plat,
					  u32 target_hart)
{
	if (plat && sbi_platform_ops(plat)->ipi_clear)
40f014e8:	04048e63          	beqz	s1,40f01544 <sbi_ipi_process+0xb8>
40f014ec:	0614c683          	lbu	a3,97(s1)
40f014f0:	0604c603          	lbu	a2,96(s1)
40f014f4:	0624c703          	lbu	a4,98(s1)
40f014f8:	0634c783          	lbu	a5,99(s1)
40f014fc:	00869693          	slli	a3,a3,0x8
40f01500:	00c6e6b3          	or	a3,a3,a2
40f01504:	01071713          	slli	a4,a4,0x10
40f01508:	00d76733          	or	a4,a4,a3
40f0150c:	01879793          	slli	a5,a5,0x18
40f01510:	00e7e7b3          	or	a5,a5,a4
40f01514:	0397c683          	lbu	a3,57(a5)
40f01518:	0387c603          	lbu	a2,56(a5)
40f0151c:	03a7c703          	lbu	a4,58(a5)
40f01520:	03b7c783          	lbu	a5,59(a5)
40f01524:	00869693          	slli	a3,a3,0x8
40f01528:	00c6e6b3          	or	a3,a3,a2
40f0152c:	01071713          	slli	a4,a4,0x10
40f01530:	00d76733          	or	a4,a4,a3
40f01534:	01879793          	slli	a5,a5,0x18
40f01538:	00e7e7b3          	or	a5,a5,a4
40f0153c:	00078463          	beqz	a5,40f01544 <sbi_ipi_process+0xb8>
		sbi_platform_ops(plat)->ipi_clear(target_hart);
40f01540:	000780e7          	jalr	a5
	sbi_platform_ipi_clear(plat, hartid);

	ipi_type = atomic_raw_xchg_ulong(&ipi_data->ipi_type, 0);
40f01544:	00000593          	li	a1,0
40f01548:	00090513          	mv	a0,s2
40f0154c:	17c030ef          	jal	ra,40f046c8 <atomic_raw_xchg_ulong>
40f01550:	00050493          	mv	s1,a0
	ipi_event = 0;
	while (ipi_type) {
40f01554:	02050c63          	beqz	a0,40f0158c <sbi_ipi_process+0x100>
40f01558:	0000b917          	auipc	s2,0xb
40f0155c:	b0890913          	addi	s2,s2,-1272 # 40f0c060 <ipi_ops_array>
		if (!(ipi_type & 1UL))
40f01560:	0014f793          	andi	a5,s1,1
		ipi_ops = ipi_ops_array[ipi_event];
		if (ipi_ops && ipi_ops->process)
			ipi_ops->process(scratch);

skip:
		ipi_type = ipi_type >> 1;
40f01564:	0014d493          	srli	s1,s1,0x1
		if (!(ipi_type & 1UL))
40f01568:	00078e63          	beqz	a5,40f01584 <sbi_ipi_process+0xf8>
		ipi_ops = ipi_ops_array[ipi_event];
40f0156c:	00092783          	lw	a5,0(s2)
			ipi_ops->process(scratch);
40f01570:	00098513          	mv	a0,s3
		if (ipi_ops && ipi_ops->process)
40f01574:	00078863          	beqz	a5,40f01584 <sbi_ipi_process+0xf8>
40f01578:	0287a783          	lw	a5,40(a5)
40f0157c:	00078463          	beqz	a5,40f01584 <sbi_ipi_process+0xf8>
			ipi_ops->process(scratch);
40f01580:	000780e7          	jalr	a5
		ipi_event++;
40f01584:	00490913          	addi	s2,s2,4
	while (ipi_type) {
40f01588:	fc049ce3          	bnez	s1,40f01560 <sbi_ipi_process+0xd4>
	};
}
40f0158c:	01c12083          	lw	ra,28(sp)
40f01590:	01812403          	lw	s0,24(sp)
40f01594:	01412483          	lw	s1,20(sp)
40f01598:	01012903          	lw	s2,16(sp)
40f0159c:	00c12983          	lw	s3,12(sp)
40f015a0:	02010113          	addi	sp,sp,32
40f015a4:	00008067          	ret

40f015a8 <sbi_ipi_init>:

int sbi_ipi_init(struct sbi_scratch *scratch, bool cold_boot)
{
40f015a8:	fe010113          	addi	sp,sp,-32
40f015ac:	00812c23          	sw	s0,24(sp)
40f015b0:	00912a23          	sw	s1,20(sp)
40f015b4:	01312623          	sw	s3,12(sp)
40f015b8:	00112e23          	sw	ra,28(sp)
40f015bc:	01212823          	sw	s2,16(sp)
40f015c0:	01412423          	sw	s4,8(sp)
40f015c4:	02010413          	addi	s0,sp,32
40f015c8:	00058993          	mv	s3,a1
40f015cc:	00050493          	mv	s1,a0
	int ret;
	struct sbi_ipi_data *ipi_data;

	if (cold_boot) {
40f015d0:	0e059a63          	bnez	a1,40f016c4 <sbi_ipi_init+0x11c>
		ret = sbi_ipi_event_create(&ipi_halt_ops);
		if (ret < 0)
			return ret;
		ipi_halt_event = ret;
	} else {
		if (!ipi_data_off)
40f015d4:	0000b797          	auipc	a5,0xb
40f015d8:	a3478793          	addi	a5,a5,-1484 # 40f0c008 <ipi_data_off>
40f015dc:	0007a903          	lw	s2,0(a5)
40f015e0:	14090a63          	beqz	s2,40f01734 <sbi_ipi_init+0x18c>
			return SBI_ENOMEM;
		if (SBI_IPI_EVENT_MAX <= ipi_smode_event ||
40f015e4:	0000a797          	auipc	a5,0xa
40f015e8:	a2078793          	addi	a5,a5,-1504 # 40f0b004 <ipi_smode_event>
40f015ec:	0007a703          	lw	a4,0(a5)
40f015f0:	01f00793          	li	a5,31
40f015f4:	12e7ec63          	bltu	a5,a4,40f0172c <sbi_ipi_init+0x184>
		    SBI_IPI_EVENT_MAX <= ipi_halt_event)
40f015f8:	0000a717          	auipc	a4,0xa
40f015fc:	a0870713          	addi	a4,a4,-1528 # 40f0b000 <ipi_halt_event>
		if (SBI_IPI_EVENT_MAX <= ipi_smode_event ||
40f01600:	00072703          	lw	a4,0(a4)
40f01604:	12e7e463          	bltu	a5,a4,40f0172c <sbi_ipi_init+0x184>
			return SBI_ENOSPC;
	}

	ipi_data = sbi_scratch_offset_ptr(scratch, ipi_data_off);
	ipi_data->ipi_type = 0x00;
40f01608:	01248933          	add	s2,s1,s2
40f0160c:	00092023          	sw	zero,0(s2)

	/* Platform init */
	ret = sbi_platform_ipi_init(sbi_platform_ptr(scratch), cold_boot);
40f01610:	0194c683          	lbu	a3,25(s1)
40f01614:	0184c603          	lbu	a2,24(s1)
40f01618:	01a4c703          	lbu	a4,26(s1)
40f0161c:	01b4c783          	lbu	a5,27(s1)
40f01620:	00869693          	slli	a3,a3,0x8
40f01624:	00c6e6b3          	or	a3,a3,a2
40f01628:	01071713          	slli	a4,a4,0x10
40f0162c:	00d76733          	or	a4,a4,a3
40f01630:	01879793          	slli	a5,a5,0x18
40f01634:	00e7e7b3          	or	a5,a5,a4
 * @return 0 on success and negative error code on failure
 */
static inline int sbi_platform_ipi_init(const struct sbi_platform *plat,
					bool cold_boot)
{
	if (plat && sbi_platform_ops(plat)->ipi_init)
40f01638:	06078263          	beqz	a5,40f0169c <sbi_ipi_init+0xf4>
40f0163c:	0617c683          	lbu	a3,97(a5)
40f01640:	0607c603          	lbu	a2,96(a5)
40f01644:	0627c703          	lbu	a4,98(a5)
40f01648:	0637c783          	lbu	a5,99(a5)
40f0164c:	00869693          	slli	a3,a3,0x8
40f01650:	00c6e6b3          	or	a3,a3,a2
40f01654:	01071713          	slli	a4,a4,0x10
40f01658:	00d76733          	or	a4,a4,a3
40f0165c:	01879793          	slli	a5,a5,0x18
40f01660:	00e7e7b3          	or	a5,a5,a4
40f01664:	03d7c683          	lbu	a3,61(a5)
40f01668:	03c7c603          	lbu	a2,60(a5)
40f0166c:	03e7c703          	lbu	a4,62(a5)
40f01670:	03f7c783          	lbu	a5,63(a5)
40f01674:	00869693          	slli	a3,a3,0x8
40f01678:	00c6e6b3          	or	a3,a3,a2
40f0167c:	01071713          	slli	a4,a4,0x10
40f01680:	00d76733          	or	a4,a4,a3
40f01684:	01879793          	slli	a5,a5,0x18
40f01688:	00e7e7b3          	or	a5,a5,a4
40f0168c:	00078863          	beqz	a5,40f0169c <sbi_ipi_init+0xf4>
		return sbi_platform_ops(plat)->ipi_init(cold_boot);
40f01690:	00098513          	mv	a0,s3
40f01694:	000780e7          	jalr	a5
	if (ret)
40f01698:	00051663          	bnez	a0,40f016a4 <sbi_ipi_init+0xfc>
		return ret;

	/* Enable software interrupts */
	csr_set(CSR_MIE, MIP_MSIP);
40f0169c:	30446073          	csrsi	mie,8

	return 0;
40f016a0:	00000513          	li	a0,0
}
40f016a4:	01c12083          	lw	ra,28(sp)
40f016a8:	01812403          	lw	s0,24(sp)
40f016ac:	01412483          	lw	s1,20(sp)
40f016b0:	01012903          	lw	s2,16(sp)
40f016b4:	00c12983          	lw	s3,12(sp)
40f016b8:	00812a03          	lw	s4,8(sp)
40f016bc:	02010113          	addi	sp,sp,32
40f016c0:	00008067          	ret
		ipi_data_off = sbi_scratch_alloc_offset(sizeof(*ipi_data),
40f016c4:	00009597          	auipc	a1,0x9
40f016c8:	b8c58593          	addi	a1,a1,-1140 # 40f0a250 <__modsi3+0x874>
40f016cc:	00400513          	li	a0,4
40f016d0:	12c000ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f016d4:	0000b797          	auipc	a5,0xb
40f016d8:	92a7aa23          	sw	a0,-1740(a5) # 40f0c008 <ipi_data_off>
40f016dc:	00050913          	mv	s2,a0
		if (!ipi_data_off)
40f016e0:	04050a63          	beqz	a0,40f01734 <sbi_ipi_init+0x18c>
	if (!ops || !ops->process)
40f016e4:	0000aa17          	auipc	s4,0xa
40f016e8:	934a0a13          	addi	s4,s4,-1740 # 40f0b018 <ipi_smode_ops>
40f016ec:	028a2783          	lw	a5,40(s4)
40f016f0:	04078663          	beqz	a5,40f0173c <sbi_ipi_init+0x194>
40f016f4:	000a0513          	mv	a0,s4
40f016f8:	975ff0ef          	jal	ra,40f0106c <sbi_ipi_event_create.part.0>
		if (ret < 0)
40f016fc:	fa0544e3          	bltz	a0,40f016a4 <sbi_ipi_init+0xfc>
	if (!ops || !ops->process)
40f01700:	054a2783          	lw	a5,84(s4)
		ipi_smode_event = ret;
40f01704:	0000a717          	auipc	a4,0xa
40f01708:	90a72023          	sw	a0,-1792(a4) # 40f0b004 <ipi_smode_event>
	if (!ops || !ops->process)
40f0170c:	02078863          	beqz	a5,40f0173c <sbi_ipi_init+0x194>
40f01710:	0000a517          	auipc	a0,0xa
40f01714:	93450513          	addi	a0,a0,-1740 # 40f0b044 <ipi_halt_ops>
40f01718:	955ff0ef          	jal	ra,40f0106c <sbi_ipi_event_create.part.0>
		if (ret < 0)
40f0171c:	f80544e3          	bltz	a0,40f016a4 <sbi_ipi_init+0xfc>
		ipi_halt_event = ret;
40f01720:	0000a797          	auipc	a5,0xa
40f01724:	8ea7a023          	sw	a0,-1824(a5) # 40f0b000 <ipi_halt_event>
40f01728:	ee1ff06f          	j	40f01608 <sbi_ipi_init+0x60>
			return SBI_ENOSPC;
40f0172c:	ff500513          	li	a0,-11
40f01730:	f75ff06f          	j	40f016a4 <sbi_ipi_init+0xfc>
			return SBI_ENOMEM;
40f01734:	ff400513          	li	a0,-12
40f01738:	f6dff06f          	j	40f016a4 <sbi_ipi_init+0xfc>
		return SBI_EINVAL;
40f0173c:	ffd00513          	li	a0,-3
40f01740:	f65ff06f          	j	40f016a4 <sbi_ipi_init+0xfc>

40f01744 <sbi_ipi_exit>:

void sbi_ipi_exit(struct sbi_scratch *scratch)
{
40f01744:	ff010113          	addi	sp,sp,-16
40f01748:	00812423          	sw	s0,8(sp)
40f0174c:	00912223          	sw	s1,4(sp)
40f01750:	00112623          	sw	ra,12(sp)
40f01754:	01010413          	addi	s0,sp,16
40f01758:	00050493          	mv	s1,a0
	/* Disable software interrupts */
	csr_clear(CSR_MIE, MIP_MSIP);
40f0175c:	30447073          	csrci	mie,8

	/* Process pending IPIs */
	sbi_ipi_process(scratch);
40f01760:	d2dff0ef          	jal	ra,40f0148c <sbi_ipi_process>

	/* Platform exit */
	sbi_platform_ipi_exit(sbi_platform_ptr(scratch));
40f01764:	0194c683          	lbu	a3,25(s1)
40f01768:	0184c603          	lbu	a2,24(s1)
40f0176c:	01a4c703          	lbu	a4,26(s1)
40f01770:	01b4c783          	lbu	a5,27(s1)
40f01774:	00869693          	slli	a3,a3,0x8
40f01778:	00c6e6b3          	or	a3,a3,a2
40f0177c:	01071713          	slli	a4,a4,0x10
40f01780:	00d76733          	or	a4,a4,a3
40f01784:	01879793          	slli	a5,a5,0x18
40f01788:	00e7e7b3          	or	a5,a5,a4
 *
 * @param plat pointer to struct sbi_platform
 */
static inline void sbi_platform_ipi_exit(const struct sbi_platform *plat)
{
	if (plat && sbi_platform_ops(plat)->ipi_exit)
40f0178c:	04078e63          	beqz	a5,40f017e8 <sbi_ipi_exit+0xa4>
40f01790:	0617c683          	lbu	a3,97(a5)
40f01794:	0607c603          	lbu	a2,96(a5)
40f01798:	0627c703          	lbu	a4,98(a5)
40f0179c:	0637c783          	lbu	a5,99(a5)
40f017a0:	00869693          	slli	a3,a3,0x8
40f017a4:	00c6e6b3          	or	a3,a3,a2
40f017a8:	01071713          	slli	a4,a4,0x10
40f017ac:	00d76733          	or	a4,a4,a3
40f017b0:	01879793          	slli	a5,a5,0x18
40f017b4:	00e7e7b3          	or	a5,a5,a4
40f017b8:	0417c683          	lbu	a3,65(a5)
40f017bc:	0407c603          	lbu	a2,64(a5)
40f017c0:	0427c703          	lbu	a4,66(a5)
40f017c4:	0437c783          	lbu	a5,67(a5)
40f017c8:	00869693          	slli	a3,a3,0x8
40f017cc:	00c6e6b3          	or	a3,a3,a2
40f017d0:	01071713          	slli	a4,a4,0x10
40f017d4:	00d76733          	or	a4,a4,a3
40f017d8:	01879793          	slli	a5,a5,0x18
40f017dc:	00e7e7b3          	or	a5,a5,a4
40f017e0:	00078463          	beqz	a5,40f017e8 <sbi_ipi_exit+0xa4>
		sbi_platform_ops(plat)->ipi_exit();
40f017e4:	000780e7          	jalr	a5
}
40f017e8:	00c12083          	lw	ra,12(sp)
40f017ec:	00812403          	lw	s0,8(sp)
40f017f0:	00412483          	lw	s1,4(sp)
40f017f4:	01010113          	addi	sp,sp,16
40f017f8:	00008067          	ret

40f017fc <sbi_scratch_alloc_offset>:

static spinlock_t extra_lock = SPIN_LOCK_INITIALIZER;
static unsigned long extra_offset = SBI_SCRATCH_EXTRA_SPACE_OFFSET;

unsigned long sbi_scratch_alloc_offset(unsigned long size, const char *owner)
{
40f017fc:	fe010113          	addi	sp,sp,-32
40f01800:	00812c23          	sw	s0,24(sp)
40f01804:	00112e23          	sw	ra,28(sp)
40f01808:	00912a23          	sw	s1,20(sp)
40f0180c:	01212823          	sw	s2,16(sp)
40f01810:	01312623          	sw	s3,12(sp)
40f01814:	01412423          	sw	s4,8(sp)
40f01818:	01512223          	sw	s5,4(sp)
40f0181c:	02010413          	addi	s0,sp,32
	 *
	 * In future, we will have more sophisticated allocator which
	 * will allow us to re-claim free-ed space.
	 */

	if (!size)
40f01820:	12050a63          	beqz	a0,40f01954 <sbi_scratch_alloc_offset+0x158>
		return 0;

	if (size & (__SIZEOF_POINTER__ - 1))
40f01824:	00357793          	andi	a5,a0,3
40f01828:	00050493          	mv	s1,a0
40f0182c:	00078663          	beqz	a5,40f01838 <sbi_scratch_alloc_offset+0x3c>
		size = (size & ~(__SIZEOF_POINTER__ - 1)) + __SIZEOF_POINTER__;
40f01830:	ffc57493          	andi	s1,a0,-4
40f01834:	00448493          	addi	s1,s1,4

	spin_lock(&extra_lock);
40f01838:	0000a517          	auipc	a0,0xa
40f0183c:	7d450513          	addi	a0,a0,2004 # 40f0c00c <extra_lock>
40f01840:	03c030ef          	jal	ra,40f0487c <spin_lock>

	if (SBI_SCRATCH_SIZE < (extra_offset + size))
40f01844:	00009797          	auipc	a5,0x9
40f01848:	7c478793          	addi	a5,a5,1988 # 40f0b008 <extra_offset>
40f0184c:	0007a903          	lw	s2,0(a5)
40f01850:	10000713          	li	a4,256

	ret = extra_offset;
	extra_offset += size;

done:
	spin_unlock(&extra_lock);
40f01854:	0000a517          	auipc	a0,0xa
40f01858:	7b850513          	addi	a0,a0,1976 # 40f0c00c <extra_lock>
	if (SBI_SCRATCH_SIZE < (extra_offset + size))
40f0185c:	009907b3          	add	a5,s2,s1
40f01860:	0cf76263          	bltu	a4,a5,40f01924 <sbi_scratch_alloc_offset+0x128>
	extra_offset += size;
40f01864:	00009717          	auipc	a4,0x9
40f01868:	7af72223          	sw	a5,1956(a4) # 40f0b008 <extra_offset>
	spin_unlock(&extra_lock);
40f0186c:	040030ef          	jal	ra,40f048ac <spin_unlock>

	if (ret) {
40f01870:	0e090263          	beqz	s2,40f01954 <sbi_scratch_alloc_offset+0x158>
		scratch = sbi_scratch_thishart_ptr();
40f01874:	340029f3          	csrr	s3,mscratch
		plat = sbi_platform_ptr(scratch);
40f01878:	0199ca03          	lbu	s4,25(s3)
40f0187c:	0189c683          	lbu	a3,24(s3)
40f01880:	01a9c783          	lbu	a5,26(s3)
40f01884:	01b9c703          	lbu	a4,27(s3)
40f01888:	008a1a13          	slli	s4,s4,0x8
40f0188c:	00da6a33          	or	s4,s4,a3
40f01890:	01079793          	slli	a5,a5,0x10
40f01894:	0147e7b3          	or	a5,a5,s4
40f01898:	01871a13          	slli	s4,a4,0x18
40f0189c:	00fa6a33          	or	s4,s4,a5
	if (plat)
40f018a0:	080a0663          	beqz	s4,40f0192c <sbi_scratch_alloc_offset+0x130>
		return plat->hart_count;
40f018a4:	051a4683          	lbu	a3,81(s4)
40f018a8:	050a4603          	lbu	a2,80(s4)
40f018ac:	052a4703          	lbu	a4,82(s4)
40f018b0:	053a4783          	lbu	a5,83(s4)
40f018b4:	00869693          	slli	a3,a3,0x8
40f018b8:	00c6e6b3          	or	a3,a3,a2
40f018bc:	01071713          	slli	a4,a4,0x10
40f018c0:	00d76733          	or	a4,a4,a3
40f018c4:	01879793          	slli	a5,a5,0x18
40f018c8:	00e7e7b3          	or	a5,a5,a4
		for (i = 0; i < sbi_platform_hart_count(plat); i++) {
40f018cc:	06078063          	beqz	a5,40f0192c <sbi_scratch_alloc_offset+0x130>
40f018d0:	00000a93          	li	s5,0
			rscratch = sbi_hart_id_to_scratch(scratch, i);
40f018d4:	000a8593          	mv	a1,s5
40f018d8:	00098513          	mv	a0,s3
40f018dc:	2ad050ef          	jal	ra,40f07388 <sbi_hart_id_to_scratch>
			ptr = sbi_scratch_offset_ptr(rscratch, ret);
			sbi_memset(ptr, 0, size);
40f018e0:	00048613          	mv	a2,s1
40f018e4:	00000593          	li	a1,0
40f018e8:	01250533          	add	a0,a0,s2
40f018ec:	3c4020ef          	jal	ra,40f03cb0 <sbi_memset>
40f018f0:	051a4683          	lbu	a3,81(s4)
40f018f4:	050a4603          	lbu	a2,80(s4)
40f018f8:	052a4703          	lbu	a4,82(s4)
40f018fc:	053a4783          	lbu	a5,83(s4)
40f01900:	00869693          	slli	a3,a3,0x8
40f01904:	00c6e6b3          	or	a3,a3,a2
40f01908:	01071713          	slli	a4,a4,0x10
40f0190c:	00d76733          	or	a4,a4,a3
40f01910:	01879793          	slli	a5,a5,0x18
		for (i = 0; i < sbi_platform_hart_count(plat); i++) {
40f01914:	001a8a93          	addi	s5,s5,1
40f01918:	00e7e7b3          	or	a5,a5,a4
40f0191c:	fafaece3          	bltu	s5,a5,40f018d4 <sbi_scratch_alloc_offset+0xd8>
40f01920:	00c0006f          	j	40f0192c <sbi_scratch_alloc_offset+0x130>
	spin_unlock(&extra_lock);
40f01924:	789020ef          	jal	ra,40f048ac <spin_unlock>
	unsigned long ret = 0;
40f01928:	00000913          	li	s2,0
		}
	}

	return ret;
}
40f0192c:	01c12083          	lw	ra,28(sp)
40f01930:	01812403          	lw	s0,24(sp)
40f01934:	00090513          	mv	a0,s2
40f01938:	01412483          	lw	s1,20(sp)
40f0193c:	01012903          	lw	s2,16(sp)
40f01940:	00c12983          	lw	s3,12(sp)
40f01944:	00812a03          	lw	s4,8(sp)
40f01948:	00412a83          	lw	s5,4(sp)
40f0194c:	02010113          	addi	sp,sp,32
40f01950:	00008067          	ret
		return 0;
40f01954:	00000913          	li	s2,0
40f01958:	fd5ff06f          	j	40f0192c <sbi_scratch_alloc_offset+0x130>

40f0195c <sbi_scratch_free_offset>:

void sbi_scratch_free_offset(unsigned long offset)
{
40f0195c:	ff010113          	addi	sp,sp,-16
40f01960:	00812623          	sw	s0,12(sp)
40f01964:	01010413          	addi	s0,sp,16

	/*
	 * We don't actually free-up because it's a simple
	 * brain-dead allocator.
	 */
}
40f01968:	00c12403          	lw	s0,12(sp)
40f0196c:	01010113          	addi	sp,sp,16
40f01970:	00008067          	ret

40f01974 <sbi_system_early_init>:
#include <sbi/sbi_ipi.h>
#include <sbi/sbi_init.h>

int sbi_system_early_init(struct sbi_scratch *scratch, bool cold_boot)
{
	return sbi_platform_early_init(sbi_platform_ptr(scratch), cold_boot);
40f01974:	01954683          	lbu	a3,25(a0)
40f01978:	01854603          	lbu	a2,24(a0)
40f0197c:	01a54703          	lbu	a4,26(a0)
40f01980:	01b54783          	lbu	a5,27(a0)
40f01984:	00869693          	slli	a3,a3,0x8
40f01988:	00c6e6b3          	or	a3,a3,a2
40f0198c:	01071713          	slli	a4,a4,0x10
40f01990:	00d76733          	or	a4,a4,a3
40f01994:	01879793          	slli	a5,a5,0x18
40f01998:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->early_init)
40f0199c:	08078463          	beqz	a5,40f01a24 <sbi_system_early_init+0xb0>
40f019a0:	0617c683          	lbu	a3,97(a5)
40f019a4:	0607c603          	lbu	a2,96(a5)
40f019a8:	0627c703          	lbu	a4,98(a5)
40f019ac:	0637c783          	lbu	a5,99(a5)
40f019b0:	00869693          	slli	a3,a3,0x8
40f019b4:	00c6e6b3          	or	a3,a3,a2
40f019b8:	01071713          	slli	a4,a4,0x10
40f019bc:	00d76733          	or	a4,a4,a3
40f019c0:	01879793          	slli	a5,a5,0x18
40f019c4:	00e7e7b3          	or	a5,a5,a4
40f019c8:	0017c683          	lbu	a3,1(a5)
40f019cc:	0007c603          	lbu	a2,0(a5)
40f019d0:	0027c703          	lbu	a4,2(a5)
40f019d4:	0037c783          	lbu	a5,3(a5)
40f019d8:	00869693          	slli	a3,a3,0x8
40f019dc:	00c6e6b3          	or	a3,a3,a2
40f019e0:	01071713          	slli	a4,a4,0x10
40f019e4:	00d76733          	or	a4,a4,a3
40f019e8:	01879793          	slli	a5,a5,0x18
40f019ec:	00e7e7b3          	or	a5,a5,a4
	return 0;
40f019f0:	00000513          	li	a0,0
	if (plat && sbi_platform_ops(plat)->early_init)
40f019f4:	02078663          	beqz	a5,40f01a20 <sbi_system_early_init+0xac>
{
40f019f8:	ff010113          	addi	sp,sp,-16
40f019fc:	00812423          	sw	s0,8(sp)
40f01a00:	00112623          	sw	ra,12(sp)
40f01a04:	01010413          	addi	s0,sp,16
40f01a08:	00058513          	mv	a0,a1
		return sbi_platform_ops(plat)->early_init(cold_boot);
40f01a0c:	000780e7          	jalr	a5
}
40f01a10:	00c12083          	lw	ra,12(sp)
40f01a14:	00812403          	lw	s0,8(sp)
40f01a18:	01010113          	addi	sp,sp,16
40f01a1c:	00008067          	ret
40f01a20:	00008067          	ret
	return 0;
40f01a24:	00000513          	li	a0,0
40f01a28:	00008067          	ret

40f01a2c <sbi_system_final_init>:

int sbi_system_final_init(struct sbi_scratch *scratch, bool cold_boot)
{
	return sbi_platform_final_init(sbi_platform_ptr(scratch), cold_boot);
40f01a2c:	01954683          	lbu	a3,25(a0)
40f01a30:	01854603          	lbu	a2,24(a0)
40f01a34:	01a54703          	lbu	a4,26(a0)
40f01a38:	01b54783          	lbu	a5,27(a0)
40f01a3c:	00869693          	slli	a3,a3,0x8
40f01a40:	00c6e6b3          	or	a3,a3,a2
40f01a44:	01071713          	slli	a4,a4,0x10
40f01a48:	00d76733          	or	a4,a4,a3
40f01a4c:	01879793          	slli	a5,a5,0x18
40f01a50:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->final_init)
40f01a54:	08078463          	beqz	a5,40f01adc <sbi_system_final_init+0xb0>
40f01a58:	0617c683          	lbu	a3,97(a5)
40f01a5c:	0607c603          	lbu	a2,96(a5)
40f01a60:	0627c703          	lbu	a4,98(a5)
40f01a64:	0637c783          	lbu	a5,99(a5)
40f01a68:	00869693          	slli	a3,a3,0x8
40f01a6c:	00c6e6b3          	or	a3,a3,a2
40f01a70:	01071713          	slli	a4,a4,0x10
40f01a74:	00d76733          	or	a4,a4,a3
40f01a78:	01879793          	slli	a5,a5,0x18
40f01a7c:	00e7e7b3          	or	a5,a5,a4
40f01a80:	0057c683          	lbu	a3,5(a5)
40f01a84:	0047c603          	lbu	a2,4(a5)
40f01a88:	0067c703          	lbu	a4,6(a5)
40f01a8c:	0077c783          	lbu	a5,7(a5)
40f01a90:	00869693          	slli	a3,a3,0x8
40f01a94:	00c6e6b3          	or	a3,a3,a2
40f01a98:	01071713          	slli	a4,a4,0x10
40f01a9c:	00d76733          	or	a4,a4,a3
40f01aa0:	01879793          	slli	a5,a5,0x18
40f01aa4:	00e7e7b3          	or	a5,a5,a4
	return 0;
40f01aa8:	00000513          	li	a0,0
	if (plat && sbi_platform_ops(plat)->final_init)
40f01aac:	02078663          	beqz	a5,40f01ad8 <sbi_system_final_init+0xac>
{
40f01ab0:	ff010113          	addi	sp,sp,-16
40f01ab4:	00812423          	sw	s0,8(sp)
40f01ab8:	00112623          	sw	ra,12(sp)
40f01abc:	01010413          	addi	s0,sp,16
40f01ac0:	00058513          	mv	a0,a1
		return sbi_platform_ops(plat)->final_init(cold_boot);
40f01ac4:	000780e7          	jalr	a5
}
40f01ac8:	00c12083          	lw	ra,12(sp)
40f01acc:	00812403          	lw	s0,8(sp)
40f01ad0:	01010113          	addi	sp,sp,16
40f01ad4:	00008067          	ret
40f01ad8:	00008067          	ret
	return 0;
40f01adc:	00000513          	li	a0,0
40f01ae0:	00008067          	ret

40f01ae4 <sbi_system_early_exit>:

void sbi_system_early_exit(struct sbi_scratch *scratch)
{
	sbi_platform_early_exit(sbi_platform_ptr(scratch));
40f01ae4:	01954683          	lbu	a3,25(a0)
40f01ae8:	01854603          	lbu	a2,24(a0)
40f01aec:	01a54703          	lbu	a4,26(a0)
40f01af0:	01b54783          	lbu	a5,27(a0)
40f01af4:	00869693          	slli	a3,a3,0x8
40f01af8:	00c6e6b3          	or	a3,a3,a2
40f01afc:	01071713          	slli	a4,a4,0x10
40f01b00:	00d76733          	or	a4,a4,a3
40f01b04:	01879793          	slli	a5,a5,0x18
40f01b08:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->early_exit)
40f01b0c:	06078e63          	beqz	a5,40f01b88 <sbi_system_early_exit+0xa4>
40f01b10:	0617c683          	lbu	a3,97(a5)
40f01b14:	0607c603          	lbu	a2,96(a5)
40f01b18:	0627c703          	lbu	a4,98(a5)
40f01b1c:	0637c783          	lbu	a5,99(a5)
40f01b20:	00869693          	slli	a3,a3,0x8
40f01b24:	00c6e6b3          	or	a3,a3,a2
40f01b28:	01071713          	slli	a4,a4,0x10
40f01b2c:	00d76733          	or	a4,a4,a3
40f01b30:	01879793          	slli	a5,a5,0x18
40f01b34:	00e7e7b3          	or	a5,a5,a4
40f01b38:	0097c683          	lbu	a3,9(a5)
40f01b3c:	0087c603          	lbu	a2,8(a5)
40f01b40:	00a7c703          	lbu	a4,10(a5)
40f01b44:	00b7c783          	lbu	a5,11(a5)
40f01b48:	00869693          	slli	a3,a3,0x8
40f01b4c:	00c6e6b3          	or	a3,a3,a2
40f01b50:	01071713          	slli	a4,a4,0x10
40f01b54:	00d76733          	or	a4,a4,a3
40f01b58:	01879793          	slli	a5,a5,0x18
40f01b5c:	00e7e7b3          	or	a5,a5,a4
40f01b60:	02078463          	beqz	a5,40f01b88 <sbi_system_early_exit+0xa4>
{
40f01b64:	ff010113          	addi	sp,sp,-16
40f01b68:	00812423          	sw	s0,8(sp)
40f01b6c:	00112623          	sw	ra,12(sp)
40f01b70:	01010413          	addi	s0,sp,16
		sbi_platform_ops(plat)->early_exit();
40f01b74:	000780e7          	jalr	a5
}
40f01b78:	00c12083          	lw	ra,12(sp)
40f01b7c:	00812403          	lw	s0,8(sp)
40f01b80:	01010113          	addi	sp,sp,16
40f01b84:	00008067          	ret
40f01b88:	00008067          	ret

40f01b8c <sbi_system_final_exit>:

void sbi_system_final_exit(struct sbi_scratch *scratch)
{
	sbi_platform_final_exit(sbi_platform_ptr(scratch));
40f01b8c:	01954683          	lbu	a3,25(a0)
40f01b90:	01854603          	lbu	a2,24(a0)
40f01b94:	01a54703          	lbu	a4,26(a0)
40f01b98:	01b54783          	lbu	a5,27(a0)
40f01b9c:	00869693          	slli	a3,a3,0x8
40f01ba0:	00c6e6b3          	or	a3,a3,a2
40f01ba4:	01071713          	slli	a4,a4,0x10
40f01ba8:	00d76733          	or	a4,a4,a3
40f01bac:	01879793          	slli	a5,a5,0x18
40f01bb0:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->final_exit)
40f01bb4:	06078e63          	beqz	a5,40f01c30 <sbi_system_final_exit+0xa4>
40f01bb8:	0617c683          	lbu	a3,97(a5)
40f01bbc:	0607c603          	lbu	a2,96(a5)
40f01bc0:	0627c703          	lbu	a4,98(a5)
40f01bc4:	0637c783          	lbu	a5,99(a5)
40f01bc8:	00869693          	slli	a3,a3,0x8
40f01bcc:	00c6e6b3          	or	a3,a3,a2
40f01bd0:	01071713          	slli	a4,a4,0x10
40f01bd4:	00d76733          	or	a4,a4,a3
40f01bd8:	01879793          	slli	a5,a5,0x18
40f01bdc:	00e7e7b3          	or	a5,a5,a4
40f01be0:	00d7c683          	lbu	a3,13(a5)
40f01be4:	00c7c603          	lbu	a2,12(a5)
40f01be8:	00e7c703          	lbu	a4,14(a5)
40f01bec:	00f7c783          	lbu	a5,15(a5)
40f01bf0:	00869693          	slli	a3,a3,0x8
40f01bf4:	00c6e6b3          	or	a3,a3,a2
40f01bf8:	01071713          	slli	a4,a4,0x10
40f01bfc:	00d76733          	or	a4,a4,a3
40f01c00:	01879793          	slli	a5,a5,0x18
40f01c04:	00e7e7b3          	or	a5,a5,a4
40f01c08:	02078463          	beqz	a5,40f01c30 <sbi_system_final_exit+0xa4>
{
40f01c0c:	ff010113          	addi	sp,sp,-16
40f01c10:	00812423          	sw	s0,8(sp)
40f01c14:	00112623          	sw	ra,12(sp)
40f01c18:	01010413          	addi	s0,sp,16
		sbi_platform_ops(plat)->final_exit();
40f01c1c:	000780e7          	jalr	a5
}
40f01c20:	00c12083          	lw	ra,12(sp)
40f01c24:	00812403          	lw	s0,8(sp)
40f01c28:	01010113          	addi	sp,sp,16
40f01c2c:	00008067          	ret
40f01c30:	00008067          	ret

40f01c34 <sbi_system_reboot>:

void __noreturn sbi_system_reboot(struct sbi_scratch *scratch, u32 type)
{
40f01c34:	fe010113          	addi	sp,sp,-32
40f01c38:	00112e23          	sw	ra,28(sp)
40f01c3c:	00812c23          	sw	s0,24(sp)
40f01c40:	00912a23          	sw	s1,20(sp)
40f01c44:	02010413          	addi	s0,sp,32
40f01c48:	01212823          	sw	s2,16(sp)
40f01c4c:	01312623          	sw	s3,12(sp)
40f01c50:	00050493          	mv	s1,a0
40f01c54:	00058913          	mv	s2,a1
	u32 current_hartid_mask = 1UL << sbi_current_hartid();
40f01c58:	661040ef          	jal	ra,40f06ab8 <sbi_current_hartid>
40f01c5c:	00050993          	mv	s3,a0

	/* Send HALT IPI to every hart other than the current hart */
	sbi_ipi_send_halt(scratch,
			  sbi_hart_available_mask() & ~current_hartid_mask, 0);
40f01c60:	6d8050ef          	jal	ra,40f07338 <sbi_hart_available_mask>
	u32 current_hartid_mask = 1UL << sbi_current_hartid();
40f01c64:	00100593          	li	a1,1
40f01c68:	013595b3          	sll	a1,a1,s3
			  sbi_hart_available_mask() & ~current_hartid_mask, 0);
40f01c6c:	fff5c593          	not	a1,a1
	sbi_ipi_send_halt(scratch,
40f01c70:	00a5f5b3          	and	a1,a1,a0
40f01c74:	00000613          	li	a2,0
40f01c78:	00048513          	mv	a0,s1
40f01c7c:	fdcff0ef          	jal	ra,40f01458 <sbi_ipi_send_halt>

	/* Platform specific reooot */
	sbi_platform_system_reboot(sbi_platform_ptr(scratch), type);
40f01c80:	0194c683          	lbu	a3,25(s1)
40f01c84:	0184c603          	lbu	a2,24(s1)
40f01c88:	01a4c703          	lbu	a4,26(s1)
40f01c8c:	01b4c783          	lbu	a5,27(s1)
40f01c90:	00869693          	slli	a3,a3,0x8
40f01c94:	00c6e6b3          	or	a3,a3,a2
40f01c98:	01071713          	slli	a4,a4,0x10
40f01c9c:	00d76733          	or	a4,a4,a3
40f01ca0:	01879793          	slli	a5,a5,0x18
40f01ca4:	00e7e7b3          	or	a5,a5,a4
 * @return 0 on success and negative error code on failure
 */
static inline int sbi_platform_system_reboot(const struct sbi_platform *plat,
					     u32 type)
{
	if (plat && sbi_platform_ops(plat)->system_reboot)
40f01ca8:	06078063          	beqz	a5,40f01d08 <sbi_system_reboot+0xd4>
40f01cac:	0617c683          	lbu	a3,97(a5)
40f01cb0:	0607c603          	lbu	a2,96(a5)
40f01cb4:	0627c703          	lbu	a4,98(a5)
40f01cb8:	0637c783          	lbu	a5,99(a5)
40f01cbc:	00869693          	slli	a3,a3,0x8
40f01cc0:	00c6e6b3          	or	a3,a3,a2
40f01cc4:	01071713          	slli	a4,a4,0x10
40f01cc8:	00d76733          	or	a4,a4,a3
40f01ccc:	01879793          	slli	a5,a5,0x18
40f01cd0:	00e7e7b3          	or	a5,a5,a4
40f01cd4:	05d7c683          	lbu	a3,93(a5)
40f01cd8:	05c7c603          	lbu	a2,92(a5)
40f01cdc:	05e7c703          	lbu	a4,94(a5)
40f01ce0:	05f7c783          	lbu	a5,95(a5)
40f01ce4:	00869693          	slli	a3,a3,0x8
40f01ce8:	00c6e6b3          	or	a3,a3,a2
40f01cec:	01071713          	slli	a4,a4,0x10
40f01cf0:	00d76733          	or	a4,a4,a3
40f01cf4:	01879793          	slli	a5,a5,0x18
40f01cf8:	00e7e7b3          	or	a5,a5,a4
40f01cfc:	00078663          	beqz	a5,40f01d08 <sbi_system_reboot+0xd4>
		return sbi_platform_ops(plat)->system_reboot(type);
40f01d00:	00090513          	mv	a0,s2
40f01d04:	000780e7          	jalr	a5

	/* If platform specific reboot did not work then do sbi_exit() */
	sbi_exit(scratch);
40f01d08:	00048513          	mv	a0,s1
40f01d0c:	940ff0ef          	jal	ra,40f00e4c <sbi_exit>

40f01d10 <sbi_system_shutdown>:
}

void __noreturn sbi_system_shutdown(struct sbi_scratch *scratch, u32 type)
{
40f01d10:	fe010113          	addi	sp,sp,-32
40f01d14:	00112e23          	sw	ra,28(sp)
40f01d18:	00812c23          	sw	s0,24(sp)
40f01d1c:	00912a23          	sw	s1,20(sp)
40f01d20:	02010413          	addi	s0,sp,32
40f01d24:	01212823          	sw	s2,16(sp)
40f01d28:	01312623          	sw	s3,12(sp)
40f01d2c:	00050493          	mv	s1,a0
40f01d30:	00058913          	mv	s2,a1
	u32 current_hartid_mask = 1UL << sbi_current_hartid();
40f01d34:	585040ef          	jal	ra,40f06ab8 <sbi_current_hartid>
40f01d38:	00050993          	mv	s3,a0

	/* Send HALT IPI to every hart other than the current hart */
	sbi_ipi_send_halt(scratch,
			  sbi_hart_available_mask() & ~current_hartid_mask, 0);
40f01d3c:	5fc050ef          	jal	ra,40f07338 <sbi_hart_available_mask>
	u32 current_hartid_mask = 1UL << sbi_current_hartid();
40f01d40:	00100593          	li	a1,1
40f01d44:	013595b3          	sll	a1,a1,s3
			  sbi_hart_available_mask() & ~current_hartid_mask, 0);
40f01d48:	fff5c593          	not	a1,a1
	sbi_ipi_send_halt(scratch,
40f01d4c:	00a5f5b3          	and	a1,a1,a0
40f01d50:	00000613          	li	a2,0
40f01d54:	00048513          	mv	a0,s1
40f01d58:	f00ff0ef          	jal	ra,40f01458 <sbi_ipi_send_halt>

	/* Platform specific shutdown */
	sbi_platform_system_shutdown(sbi_platform_ptr(scratch), type);
40f01d5c:	0194c683          	lbu	a3,25(s1)
40f01d60:	0184c603          	lbu	a2,24(s1)
40f01d64:	01a4c703          	lbu	a4,26(s1)
40f01d68:	01b4c783          	lbu	a5,27(s1)
40f01d6c:	00869693          	slli	a3,a3,0x8
40f01d70:	00c6e6b3          	or	a3,a3,a2
40f01d74:	01071713          	slli	a4,a4,0x10
40f01d78:	00d76733          	or	a4,a4,a3
40f01d7c:	01879793          	slli	a5,a5,0x18
40f01d80:	00e7e7b3          	or	a5,a5,a4
 * @return 0 on success and negative error code on failure
 */
static inline int sbi_platform_system_shutdown(const struct sbi_platform *plat,
					       u32 type)
{
	if (plat && sbi_platform_ops(plat)->system_shutdown)
40f01d84:	06078063          	beqz	a5,40f01de4 <sbi_system_shutdown+0xd4>
40f01d88:	0617c683          	lbu	a3,97(a5)
40f01d8c:	0607c603          	lbu	a2,96(a5)
40f01d90:	0627c703          	lbu	a4,98(a5)
40f01d94:	0637c783          	lbu	a5,99(a5)
40f01d98:	00869693          	slli	a3,a3,0x8
40f01d9c:	00c6e6b3          	or	a3,a3,a2
40f01da0:	01071713          	slli	a4,a4,0x10
40f01da4:	00d76733          	or	a4,a4,a3
40f01da8:	01879793          	slli	a5,a5,0x18
40f01dac:	00e7e7b3          	or	a5,a5,a4
40f01db0:	0617c683          	lbu	a3,97(a5)
40f01db4:	0607c603          	lbu	a2,96(a5)
40f01db8:	0627c703          	lbu	a4,98(a5)
40f01dbc:	0637c783          	lbu	a5,99(a5)
40f01dc0:	00869693          	slli	a3,a3,0x8
40f01dc4:	00c6e6b3          	or	a3,a3,a2
40f01dc8:	01071713          	slli	a4,a4,0x10
40f01dcc:	00d76733          	or	a4,a4,a3
40f01dd0:	01879793          	slli	a5,a5,0x18
40f01dd4:	00e7e7b3          	or	a5,a5,a4
40f01dd8:	00078663          	beqz	a5,40f01de4 <sbi_system_shutdown+0xd4>
		return sbi_platform_ops(plat)->system_shutdown(type);
40f01ddc:	00090513          	mv	a0,s2
40f01de0:	000780e7          	jalr	a5

	/* If platform specific shutdown did not work then do sbi_exit() */
	sbi_exit(scratch);
40f01de4:	00048513          	mv	a0,s1
40f01de8:	864ff0ef          	jal	ra,40f00e4c <sbi_exit>

40f01dec <get_ticks>:

static unsigned long time_delta_off;

#if __riscv_xlen == 32
u64 get_ticks(void)
{
40f01dec:	ff010113          	addi	sp,sp,-16
40f01df0:	00812623          	sw	s0,12(sp)
40f01df4:	01010413          	addi	s0,sp,16
	u32 lo, hi, tmp;
	__asm__ __volatile__("1:\n"
40f01df8:	c81025f3          	rdtimeh	a1
40f01dfc:	c0102573          	rdtime	a0
40f01e00:	c81027f3          	rdtimeh	a5
40f01e04:	fef59ae3          	bne	a1,a5,40f01df8 <get_ticks+0xc>
			     "rdtime %1\n"
			     "rdtimeh %2\n"
			     "bne %0, %2, 1b"
			     : "=&r"(hi), "=&r"(lo), "=&r"(tmp));
	return ((u64)hi << 32) | lo;
}
40f01e08:	00c12403          	lw	s0,12(sp)
40f01e0c:	01010113          	addi	sp,sp,16
40f01e10:	00008067          	ret

40f01e14 <sbi_timer_value>:
}
#endif

u64 sbi_timer_value(struct sbi_scratch *scratch)
{
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f01e14:	01954683          	lbu	a3,25(a0)
40f01e18:	01854603          	lbu	a2,24(a0)
40f01e1c:	01a54703          	lbu	a4,26(a0)
40f01e20:	01b54783          	lbu	a5,27(a0)
40f01e24:	00869693          	slli	a3,a3,0x8
40f01e28:	00c6e6b3          	or	a3,a3,a2
40f01e2c:	01071713          	slli	a4,a4,0x10
40f01e30:	00d76733          	or	a4,a4,a3
40f01e34:	01879793          	slli	a5,a5,0x18
40f01e38:	00e7e7b3          	or	a5,a5,a4

	if (sbi_platform_has_timer_value(plat))
40f01e3c:	0487c703          	lbu	a4,72(a5)
40f01e40:	00177713          	andi	a4,a4,1
40f01e44:	08070663          	beqz	a4,40f01ed0 <sbi_timer_value+0xbc>
	if (plat && sbi_platform_ops(plat)->timer_value)
40f01e48:	06078e63          	beqz	a5,40f01ec4 <sbi_timer_value+0xb0>
40f01e4c:	0617c683          	lbu	a3,97(a5)
40f01e50:	0607c603          	lbu	a2,96(a5)
40f01e54:	0627c703          	lbu	a4,98(a5)
40f01e58:	0637c783          	lbu	a5,99(a5)
40f01e5c:	00869693          	slli	a3,a3,0x8
40f01e60:	00c6e6b3          	or	a3,a3,a2
40f01e64:	01071713          	slli	a4,a4,0x10
40f01e68:	00d76733          	or	a4,a4,a3
40f01e6c:	01879793          	slli	a5,a5,0x18
40f01e70:	00e7e7b3          	or	a5,a5,a4
40f01e74:	0497c683          	lbu	a3,73(a5)
40f01e78:	0487c603          	lbu	a2,72(a5)
40f01e7c:	04a7c703          	lbu	a4,74(a5)
40f01e80:	04b7c783          	lbu	a5,75(a5)
40f01e84:	00869693          	slli	a3,a3,0x8
40f01e88:	00c6e6b3          	or	a3,a3,a2
40f01e8c:	01071713          	slli	a4,a4,0x10
40f01e90:	00d76733          	or	a4,a4,a3
40f01e94:	01879793          	slli	a5,a5,0x18
40f01e98:	00e7e7b3          	or	a5,a5,a4
40f01e9c:	02078463          	beqz	a5,40f01ec4 <sbi_timer_value+0xb0>
{
40f01ea0:	ff010113          	addi	sp,sp,-16
40f01ea4:	00812423          	sw	s0,8(sp)
40f01ea8:	00112623          	sw	ra,12(sp)
40f01eac:	01010413          	addi	s0,sp,16
		return sbi_platform_ops(plat)->timer_value();
40f01eb0:	000780e7          	jalr	a5
		return sbi_platform_timer_value(plat);
	else
		return get_ticks();
}
40f01eb4:	00c12083          	lw	ra,12(sp)
40f01eb8:	00812403          	lw	s0,8(sp)
40f01ebc:	01010113          	addi	sp,sp,16
40f01ec0:	00008067          	ret
	return 0;
40f01ec4:	00000513          	li	a0,0
40f01ec8:	00000593          	li	a1,0
40f01ecc:	00008067          	ret
	__asm__ __volatile__("1:\n"
40f01ed0:	c81025f3          	rdtimeh	a1
40f01ed4:	c0102573          	rdtime	a0
40f01ed8:	c81027f3          	rdtimeh	a5
40f01edc:	fef59ae3          	bne	a1,a5,40f01ed0 <sbi_timer_value+0xbc>
	return ((u64)hi << 32) | lo;
40f01ee0:	00008067          	ret

40f01ee4 <sbi_timer_virt_value>:

u64 sbi_timer_virt_value(struct sbi_scratch *scratch)
{
40f01ee4:	ff010113          	addi	sp,sp,-16
40f01ee8:	00812423          	sw	s0,8(sp)
40f01eec:	00112623          	sw	ra,12(sp)
40f01ef0:	00912223          	sw	s1,4(sp)
40f01ef4:	01010413          	addi	s0,sp,16
	u64 *time_delta = sbi_scratch_offset_ptr(scratch, time_delta_off);
40f01ef8:	0000a797          	auipc	a5,0xa
40f01efc:	11878793          	addi	a5,a5,280 # 40f0c010 <time_delta_off>
40f01f00:	0007a483          	lw	s1,0(a5)
40f01f04:	009504b3          	add	s1,a0,s1

	return sbi_timer_value(scratch) + *time_delta;
40f01f08:	f0dff0ef          	jal	ra,40f01e14 <sbi_timer_value>
40f01f0c:	00050793          	mv	a5,a0
40f01f10:	0004a503          	lw	a0,0(s1)
40f01f14:	0044a703          	lw	a4,4(s1)
}
40f01f18:	00c12083          	lw	ra,12(sp)
40f01f1c:	00812403          	lw	s0,8(sp)
	return sbi_timer_value(scratch) + *time_delta;
40f01f20:	00a78533          	add	a0,a5,a0
40f01f24:	00f537b3          	sltu	a5,a0,a5
40f01f28:	00e585b3          	add	a1,a1,a4
}
40f01f2c:	00412483          	lw	s1,4(sp)
40f01f30:	00b785b3          	add	a1,a5,a1
40f01f34:	01010113          	addi	sp,sp,16
40f01f38:	00008067          	ret

40f01f3c <sbi_timer_get_delta>:

u64 sbi_timer_get_delta(struct sbi_scratch *scratch)
{
40f01f3c:	ff010113          	addi	sp,sp,-16
40f01f40:	00812623          	sw	s0,12(sp)
40f01f44:	01010413          	addi	s0,sp,16
	u64 *time_delta = sbi_scratch_offset_ptr(scratch, time_delta_off);

	return *time_delta;
40f01f48:	0000a797          	auipc	a5,0xa
40f01f4c:	0c878793          	addi	a5,a5,200 # 40f0c010 <time_delta_off>
40f01f50:	0007a783          	lw	a5,0(a5)
}
40f01f54:	00c12403          	lw	s0,12(sp)
	return *time_delta;
40f01f58:	00f50533          	add	a0,a0,a5
}
40f01f5c:	00452583          	lw	a1,4(a0)
40f01f60:	00052503          	lw	a0,0(a0)
40f01f64:	01010113          	addi	sp,sp,16
40f01f68:	00008067          	ret

40f01f6c <sbi_timer_set_delta>:

void sbi_timer_set_delta(struct sbi_scratch *scratch, ulong delta)
{
40f01f6c:	ff010113          	addi	sp,sp,-16
40f01f70:	00812623          	sw	s0,12(sp)
40f01f74:	01010413          	addi	s0,sp,16
	u64 *time_delta = sbi_scratch_offset_ptr(scratch, time_delta_off);

	*time_delta = (u64)delta;
40f01f78:	0000a797          	auipc	a5,0xa
40f01f7c:	09878793          	addi	a5,a5,152 # 40f0c010 <time_delta_off>
40f01f80:	0007a783          	lw	a5,0(a5)
40f01f84:	00f50533          	add	a0,a0,a5
40f01f88:	00b52023          	sw	a1,0(a0)
40f01f8c:	00052223          	sw	zero,4(a0)
}
40f01f90:	00c12403          	lw	s0,12(sp)
40f01f94:	01010113          	addi	sp,sp,16
40f01f98:	00008067          	ret

40f01f9c <sbi_timer_set_delta_upper>:

void sbi_timer_set_delta_upper(struct sbi_scratch *scratch, ulong delta_upper)
{
40f01f9c:	ff010113          	addi	sp,sp,-16
40f01fa0:	00812623          	sw	s0,12(sp)
40f01fa4:	01010413          	addi	s0,sp,16
	u64 *time_delta = sbi_scratch_offset_ptr(scratch, time_delta_off);
40f01fa8:	0000a797          	auipc	a5,0xa
40f01fac:	06878793          	addi	a5,a5,104 # 40f0c010 <time_delta_off>
40f01fb0:	0007a783          	lw	a5,0(a5)
40f01fb4:	00f50533          	add	a0,a0,a5

	*time_delta &= 0xffffffffULL;
	*time_delta |= ((u64)delta_upper << 32);
40f01fb8:	00b52223          	sw	a1,4(a0)
}
40f01fbc:	00c12403          	lw	s0,12(sp)
40f01fc0:	01010113          	addi	sp,sp,16
40f01fc4:	00008067          	ret

40f01fc8 <sbi_timer_event_start>:

void sbi_timer_event_start(struct sbi_scratch *scratch, u64 next_event)
{
	sbi_platform_timer_event_start(sbi_platform_ptr(scratch), next_event);
40f01fc8:	01954683          	lbu	a3,25(a0)
40f01fcc:	01854803          	lbu	a6,24(a0)
40f01fd0:	01a54703          	lbu	a4,26(a0)
40f01fd4:	01b54783          	lbu	a5,27(a0)
40f01fd8:	00869693          	slli	a3,a3,0x8
40f01fdc:	0106e6b3          	or	a3,a3,a6
40f01fe0:	01071713          	slli	a4,a4,0x10
40f01fe4:	00d76733          	or	a4,a4,a3
40f01fe8:	01879793          	slli	a5,a5,0x18
40f01fec:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->timer_event_start)
40f01ff0:	08078a63          	beqz	a5,40f02084 <sbi_timer_event_start+0xbc>
40f01ff4:	0617c683          	lbu	a3,97(a5)
40f01ff8:	0607c503          	lbu	a0,96(a5)
40f01ffc:	0627c703          	lbu	a4,98(a5)
40f02000:	0637c783          	lbu	a5,99(a5)
40f02004:	00869693          	slli	a3,a3,0x8
40f02008:	00a6e6b3          	or	a3,a3,a0
40f0200c:	01071713          	slli	a4,a4,0x10
40f02010:	00d76733          	or	a4,a4,a3
40f02014:	01879793          	slli	a5,a5,0x18
40f02018:	00e7e7b3          	or	a5,a5,a4
40f0201c:	04d7c683          	lbu	a3,77(a5)
40f02020:	04c7c503          	lbu	a0,76(a5)
40f02024:	04e7c703          	lbu	a4,78(a5)
40f02028:	04f7c783          	lbu	a5,79(a5)
40f0202c:	00869693          	slli	a3,a3,0x8
40f02030:	00a6e6b3          	or	a3,a3,a0
40f02034:	01071713          	slli	a4,a4,0x10
40f02038:	00d76733          	or	a4,a4,a3
40f0203c:	01879793          	slli	a5,a5,0x18
40f02040:	00e7e7b3          	or	a5,a5,a4
40f02044:	04078063          	beqz	a5,40f02084 <sbi_timer_event_start+0xbc>
{
40f02048:	ff010113          	addi	sp,sp,-16
40f0204c:	00812423          	sw	s0,8(sp)
40f02050:	00112623          	sw	ra,12(sp)
40f02054:	01010413          	addi	s0,sp,16
40f02058:	00058513          	mv	a0,a1
40f0205c:	00060593          	mv	a1,a2
		sbi_platform_ops(plat)->timer_event_start(next_event);
40f02060:	000780e7          	jalr	a5
	csr_clear(CSR_MIP, MIP_STIP);
40f02064:	02000793          	li	a5,32
40f02068:	3447b073          	csrc	mip,a5
	csr_set(CSR_MIE, MIP_MTIP);
40f0206c:	08000793          	li	a5,128
40f02070:	3047a073          	csrs	mie,a5
}
40f02074:	00c12083          	lw	ra,12(sp)
40f02078:	00812403          	lw	s0,8(sp)
40f0207c:	01010113          	addi	sp,sp,16
40f02080:	00008067          	ret
	csr_clear(CSR_MIP, MIP_STIP);
40f02084:	02000793          	li	a5,32
40f02088:	3447b073          	csrc	mip,a5
	csr_set(CSR_MIE, MIP_MTIP);
40f0208c:	08000793          	li	a5,128
40f02090:	3047a073          	csrs	mie,a5
40f02094:	00008067          	ret

40f02098 <sbi_timer_process>:

void sbi_timer_process(struct sbi_scratch *scratch)
{
40f02098:	ff010113          	addi	sp,sp,-16
40f0209c:	00812623          	sw	s0,12(sp)
40f020a0:	01010413          	addi	s0,sp,16
	csr_clear(CSR_MIE, MIP_MTIP);
40f020a4:	08000793          	li	a5,128
40f020a8:	3047b073          	csrc	mie,a5
	csr_set(CSR_MIP, MIP_STIP);
40f020ac:	02000793          	li	a5,32
40f020b0:	3447a073          	csrs	mip,a5
}
40f020b4:	00c12403          	lw	s0,12(sp)
40f020b8:	01010113          	addi	sp,sp,16
40f020bc:	00008067          	ret

40f020c0 <sbi_timer_init>:

int sbi_timer_init(struct sbi_scratch *scratch, bool cold_boot)
{
40f020c0:	ff010113          	addi	sp,sp,-16
40f020c4:	00812423          	sw	s0,8(sp)
40f020c8:	00912223          	sw	s1,4(sp)
40f020cc:	01212023          	sw	s2,0(sp)
40f020d0:	00112623          	sw	ra,12(sp)
40f020d4:	01010413          	addi	s0,sp,16
40f020d8:	00058913          	mv	s2,a1
40f020dc:	00050493          	mv	s1,a0
	u64 *time_delta;

	if (cold_boot) {
40f020e0:	0c059663          	bnez	a1,40f021ac <sbi_timer_init+0xec>
		time_delta_off = sbi_scratch_alloc_offset(sizeof(*time_delta),
							  "TIME_DELTA");
		if (!time_delta_off)
			return SBI_ENOMEM;
	} else {
		if (!time_delta_off)
40f020e4:	0000a797          	auipc	a5,0xa
40f020e8:	f2c78793          	addi	a5,a5,-212 # 40f0c010 <time_delta_off>
40f020ec:	0007a503          	lw	a0,0(a5)
40f020f0:	0c050c63          	beqz	a0,40f021c8 <sbi_timer_init+0x108>
			return SBI_ENOMEM;
	}

	time_delta = sbi_scratch_offset_ptr(scratch, time_delta_off);
	*time_delta = 0;
40f020f4:	00a48533          	add	a0,s1,a0
40f020f8:	00000793          	li	a5,0
40f020fc:	00000813          	li	a6,0
40f02100:	00f52023          	sw	a5,0(a0)
40f02104:	01052223          	sw	a6,4(a0)

	return sbi_platform_timer_init(sbi_platform_ptr(scratch), cold_boot);
40f02108:	0194c683          	lbu	a3,25(s1)
40f0210c:	0184c603          	lbu	a2,24(s1)
40f02110:	01a4c703          	lbu	a4,26(s1)
40f02114:	01b4c783          	lbu	a5,27(s1)
40f02118:	00869693          	slli	a3,a3,0x8
40f0211c:	00c6e6b3          	or	a3,a3,a2
40f02120:	01071713          	slli	a4,a4,0x10
40f02124:	00d76733          	or	a4,a4,a3
40f02128:	01879793          	slli	a5,a5,0x18
40f0212c:	00e7e7b3          	or	a5,a5,a4
	return 0;
40f02130:	00000513          	li	a0,0
	if (plat && sbi_platform_ops(plat)->timer_init)
40f02134:	06078063          	beqz	a5,40f02194 <sbi_timer_init+0xd4>
40f02138:	0617c683          	lbu	a3,97(a5)
40f0213c:	0607c603          	lbu	a2,96(a5)
40f02140:	0627c703          	lbu	a4,98(a5)
40f02144:	0637c783          	lbu	a5,99(a5)
40f02148:	00869693          	slli	a3,a3,0x8
40f0214c:	00c6e6b3          	or	a3,a3,a2
40f02150:	01071713          	slli	a4,a4,0x10
40f02154:	00d76733          	or	a4,a4,a3
40f02158:	01879793          	slli	a5,a5,0x18
40f0215c:	00e7e7b3          	or	a5,a5,a4
40f02160:	0557c683          	lbu	a3,85(a5)
40f02164:	0547c603          	lbu	a2,84(a5)
40f02168:	0567c703          	lbu	a4,86(a5)
40f0216c:	0577c783          	lbu	a5,87(a5)
40f02170:	00869693          	slli	a3,a3,0x8
40f02174:	00c6e6b3          	or	a3,a3,a2
40f02178:	01071713          	slli	a4,a4,0x10
40f0217c:	00d76733          	or	a4,a4,a3
40f02180:	01879793          	slli	a5,a5,0x18
40f02184:	00e7e7b3          	or	a5,a5,a4
40f02188:	00078663          	beqz	a5,40f02194 <sbi_timer_init+0xd4>
		return sbi_platform_ops(plat)->timer_init(cold_boot);
40f0218c:	00090513          	mv	a0,s2
40f02190:	000780e7          	jalr	a5
}
40f02194:	00c12083          	lw	ra,12(sp)
40f02198:	00812403          	lw	s0,8(sp)
40f0219c:	00412483          	lw	s1,4(sp)
40f021a0:	00012903          	lw	s2,0(sp)
40f021a4:	01010113          	addi	sp,sp,16
40f021a8:	00008067          	ret
		time_delta_off = sbi_scratch_alloc_offset(sizeof(*time_delta),
40f021ac:	00008597          	auipc	a1,0x8
40f021b0:	0b058593          	addi	a1,a1,176 # 40f0a25c <__modsi3+0x880>
40f021b4:	00800513          	li	a0,8
40f021b8:	e44ff0ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f021bc:	0000a797          	auipc	a5,0xa
40f021c0:	e4a7aa23          	sw	a0,-428(a5) # 40f0c010 <time_delta_off>
		if (!time_delta_off)
40f021c4:	f20518e3          	bnez	a0,40f020f4 <sbi_timer_init+0x34>
			return SBI_ENOMEM;
40f021c8:	ff400513          	li	a0,-12
40f021cc:	fc9ff06f          	j	40f02194 <sbi_timer_init+0xd4>

40f021d0 <sbi_timer_exit>:

void sbi_timer_exit(struct sbi_scratch *scratch)
{
40f021d0:	ff010113          	addi	sp,sp,-16
40f021d4:	00812423          	sw	s0,8(sp)
40f021d8:	00912223          	sw	s1,4(sp)
40f021dc:	00112623          	sw	ra,12(sp)
40f021e0:	01010413          	addi	s0,sp,16
	sbi_platform_timer_event_stop(sbi_platform_ptr(scratch));
40f021e4:	01954683          	lbu	a3,25(a0)
40f021e8:	01854603          	lbu	a2,24(a0)
40f021ec:	01a54703          	lbu	a4,26(a0)
40f021f0:	01b54783          	lbu	a5,27(a0)
40f021f4:	00869693          	slli	a3,a3,0x8
40f021f8:	00c6e6b3          	or	a3,a3,a2
40f021fc:	01071713          	slli	a4,a4,0x10
40f02200:	00d76733          	or	a4,a4,a3
40f02204:	01879793          	slli	a5,a5,0x18
40f02208:	00e7e7b3          	or	a5,a5,a4
{
40f0220c:	00050493          	mv	s1,a0
	if (plat && sbi_platform_ops(plat)->timer_event_stop)
40f02210:	04078e63          	beqz	a5,40f0226c <sbi_timer_exit+0x9c>
40f02214:	0617c683          	lbu	a3,97(a5)
40f02218:	0607c603          	lbu	a2,96(a5)
40f0221c:	0627c703          	lbu	a4,98(a5)
40f02220:	0637c783          	lbu	a5,99(a5)
40f02224:	00869693          	slli	a3,a3,0x8
40f02228:	00c6e6b3          	or	a3,a3,a2
40f0222c:	01071713          	slli	a4,a4,0x10
40f02230:	00d76733          	or	a4,a4,a3
40f02234:	01879793          	slli	a5,a5,0x18
40f02238:	00e7e7b3          	or	a5,a5,a4
40f0223c:	0517c683          	lbu	a3,81(a5)
40f02240:	0507c603          	lbu	a2,80(a5)
40f02244:	0527c703          	lbu	a4,82(a5)
40f02248:	0537c783          	lbu	a5,83(a5)
40f0224c:	00869693          	slli	a3,a3,0x8
40f02250:	00c6e6b3          	or	a3,a3,a2
40f02254:	01071713          	slli	a4,a4,0x10
40f02258:	00d76733          	or	a4,a4,a3
40f0225c:	01879793          	slli	a5,a5,0x18
40f02260:	00e7e7b3          	or	a5,a5,a4
40f02264:	00078463          	beqz	a5,40f0226c <sbi_timer_exit+0x9c>
		sbi_platform_ops(plat)->timer_event_stop();
40f02268:	000780e7          	jalr	a5

	csr_clear(CSR_MIP, MIP_STIP);
40f0226c:	02000793          	li	a5,32
40f02270:	3447b073          	csrc	mip,a5
	csr_clear(CSR_MIE, MIP_MTIP);
40f02274:	08000793          	li	a5,128
40f02278:	3047b073          	csrc	mie,a5

	sbi_platform_timer_exit(sbi_platform_ptr(scratch));
40f0227c:	0194c683          	lbu	a3,25(s1)
40f02280:	0184c603          	lbu	a2,24(s1)
40f02284:	01a4c703          	lbu	a4,26(s1)
40f02288:	01b4c783          	lbu	a5,27(s1)
40f0228c:	00869693          	slli	a3,a3,0x8
40f02290:	00c6e6b3          	or	a3,a3,a2
40f02294:	01071713          	slli	a4,a4,0x10
40f02298:	00d76733          	or	a4,a4,a3
40f0229c:	01879793          	slli	a5,a5,0x18
40f022a0:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->timer_exit)
40f022a4:	04078e63          	beqz	a5,40f02300 <sbi_timer_exit+0x130>
40f022a8:	0617c683          	lbu	a3,97(a5)
40f022ac:	0607c603          	lbu	a2,96(a5)
40f022b0:	0627c703          	lbu	a4,98(a5)
40f022b4:	0637c783          	lbu	a5,99(a5)
40f022b8:	00869693          	slli	a3,a3,0x8
40f022bc:	00c6e6b3          	or	a3,a3,a2
40f022c0:	01071713          	slli	a4,a4,0x10
40f022c4:	00d76733          	or	a4,a4,a3
40f022c8:	01879793          	slli	a5,a5,0x18
40f022cc:	00e7e7b3          	or	a5,a5,a4
40f022d0:	0597c683          	lbu	a3,89(a5)
40f022d4:	0587c603          	lbu	a2,88(a5)
40f022d8:	05a7c703          	lbu	a4,90(a5)
40f022dc:	05b7c783          	lbu	a5,91(a5)
40f022e0:	00869693          	slli	a3,a3,0x8
40f022e4:	00c6e6b3          	or	a3,a3,a2
40f022e8:	01071713          	slli	a4,a4,0x10
40f022ec:	00d76733          	or	a4,a4,a3
40f022f0:	01879793          	slli	a5,a5,0x18
40f022f4:	00e7e7b3          	or	a5,a5,a4
40f022f8:	00078463          	beqz	a5,40f02300 <sbi_timer_exit+0x130>
		sbi_platform_ops(plat)->timer_exit();
40f022fc:	000780e7          	jalr	a5
}
40f02300:	00c12083          	lw	ra,12(sp)
40f02304:	00812403          	lw	s0,8(sp)
40f02308:	00412483          	lw	s1,4(sp)
40f0230c:	01010113          	addi	sp,sp,16
40f02310:	00008067          	ret

40f02314 <sbi_tlb_local_flush>:
				     : "memory");
	}
}

static void sbi_tlb_local_flush(struct sbi_tlb_info *tinfo)
{
40f02314:	fe010113          	addi	sp,sp,-32
40f02318:	00812c23          	sw	s0,24(sp)
40f0231c:	00112e23          	sw	ra,28(sp)
40f02320:	00912a23          	sw	s1,20(sp)
40f02324:	01212823          	sw	s2,16(sp)
40f02328:	01312623          	sw	s3,12(sp)
40f0232c:	01412423          	sw	s4,8(sp)
40f02330:	01512223          	sw	s5,4(sp)
40f02334:	02010413          	addi	s0,sp,32
	switch (tinfo->type) {
40f02338:	00c52583          	lw	a1,12(a0)
40f0233c:	00600793          	li	a5,6
40f02340:	1ab7e463          	bltu	a5,a1,40f024e8 <sbi_tlb_local_flush+0x1d4>
40f02344:	00008697          	auipc	a3,0x8
40f02348:	f2468693          	addi	a3,a3,-220 # 40f0a268 <__modsi3+0x88c>
40f0234c:	00259713          	slli	a4,a1,0x2
40f02350:	00d70733          	add	a4,a4,a3
40f02354:	00072783          	lw	a5,0(a4)
40f02358:	00d787b3          	add	a5,a5,a3
40f0235c:	00078067          	jr	a5
	unsigned long start = tinfo->start;
40f02360:	00052983          	lw	s3,0(a0)
	unsigned long size  = tinfo->size;
40f02364:	00452903          	lw	s2,4(a0)
	if (start == 0 && size == 0) {
40f02368:	0129e7b3          	or	a5,s3,s2
40f0236c:	18078a63          	beqz	a5,40f02500 <sbi_tlb_local_flush+0x1ec>
	if (size == SBI_TLB_FLUSH_ALL) {
40f02370:	fff00793          	li	a5,-1
	unsigned long asid  = tinfo->asid;
40f02374:	00852a03          	lw	s4,8(a0)
	if (size == SBI_TLB_FLUSH_ALL) {
40f02378:	1af90063          	beq	s2,a5,40f02518 <sbi_tlb_local_flush+0x204>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f0237c:	00000493          	li	s1,0
40f02380:	00001ab7          	lui	s5,0x1
40f02384:	02090063          	beqz	s2,40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_vvma_asid_va(asid, start + i);
40f02388:	009985b3          	add	a1,s3,s1
40f0238c:	000a0513          	mv	a0,s4
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02390:	015484b3          	add	s1,s1,s5
		__sbi_hfence_vvma_asid_va(asid, start + i);
40f02394:	704040ef          	jal	ra,40f06a98 <__sbi_hfence_vvma_asid_va>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02398:	ff24e8e3          	bltu	s1,s2,40f02388 <sbi_tlb_local_flush+0x74>
40f0239c:	0080006f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		break;
	case SBI_TLB_FLUSH_VVMA_ASID:
		sbi_tlb_hfence_vvma_asid(tinfo);
		break;
	case SBI_ITLB_FLUSH:
		__asm__ __volatile("fence.i");
40f023a0:	0000100f          	fence.i
	default:
		sbi_printf("Invalid tlb flush request type [%lu]\n",
			   tinfo->type);
	}
	return;
}
40f023a4:	01c12083          	lw	ra,28(sp)
40f023a8:	01812403          	lw	s0,24(sp)
40f023ac:	01412483          	lw	s1,20(sp)
40f023b0:	01012903          	lw	s2,16(sp)
40f023b4:	00c12983          	lw	s3,12(sp)
40f023b8:	00812a03          	lw	s4,8(sp)
40f023bc:	00412a83          	lw	s5,4(sp)
40f023c0:	02010113          	addi	sp,sp,32
40f023c4:	00008067          	ret
		sbi_tlb_sfence_vma(tinfo);
40f023c8:	00052683          	lw	a3,0(a0)
40f023cc:	00452703          	lw	a4,4(a0)
	if ((start == 0 && size == 0) || (size == SBI_TLB_FLUSH_ALL)) {
40f023d0:	00e6e7b3          	or	a5,a3,a4
40f023d4:	12078263          	beqz	a5,40f024f8 <sbi_tlb_local_flush+0x1e4>
40f023d8:	fff00793          	li	a5,-1
40f023dc:	10f70e63          	beq	a4,a5,40f024f8 <sbi_tlb_local_flush+0x1e4>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f023e0:	00001637          	lui	a2,0x1
40f023e4:	fc0700e3          	beqz	a4,40f023a4 <sbi_tlb_local_flush+0x90>
				     : "r"(start + i)
40f023e8:	00b687b3          	add	a5,a3,a1
		__asm__ __volatile__("sfence.vma %0"
40f023ec:	12078073          	sfence.vma	a5
	for (i = 0; i < size; i += PAGE_SIZE) {
40f023f0:	00c585b3          	add	a1,a1,a2
40f023f4:	fee5eae3          	bltu	a1,a4,40f023e8 <sbi_tlb_local_flush+0xd4>
40f023f8:	fadff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
	unsigned long start = tinfo->start;
40f023fc:	00052603          	lw	a2,0(a0)
	unsigned long size  = tinfo->size;
40f02400:	00452683          	lw	a3,4(a0)
	if (start == 0 && size == 0) {
40f02404:	00d667b3          	or	a5,a2,a3
40f02408:	0e078863          	beqz	a5,40f024f8 <sbi_tlb_local_flush+0x1e4>
	if (size == SBI_TLB_FLUSH_ALL) {
40f0240c:	fff00793          	li	a5,-1
	unsigned long asid  = tinfo->asid;
40f02410:	00852583          	lw	a1,8(a0)
	if (size == SBI_TLB_FLUSH_ALL) {
40f02414:	0ef68e63          	beq	a3,a5,40f02510 <sbi_tlb_local_flush+0x1fc>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02418:	00000793          	li	a5,0
40f0241c:	00001537          	lui	a0,0x1
40f02420:	f80682e3          	beqz	a3,40f023a4 <sbi_tlb_local_flush+0x90>
				     : "r"(start + i), "r"(asid)
40f02424:	00f60733          	add	a4,a2,a5
		__asm__ __volatile__("sfence.vma %0, %1"
40f02428:	12b70073          	sfence.vma	a4,a1
	for (i = 0; i < size; i += PAGE_SIZE) {
40f0242c:	00a787b3          	add	a5,a5,a0
40f02430:	fed7eae3          	bltu	a5,a3,40f02424 <sbi_tlb_local_flush+0x110>
40f02434:	f71ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
	unsigned long start = tinfo->start;
40f02438:	00052983          	lw	s3,0(a0) # 1000 <_fw_start-0x40eff000>
	unsigned long size  = tinfo->size;
40f0243c:	00452903          	lw	s2,4(a0)
	if (start == 0 && size == 0) {
40f02440:	0129e7b3          	or	a5,s3,s2
40f02444:	0c078263          	beqz	a5,40f02508 <sbi_tlb_local_flush+0x1f4>
	if (size == SBI_TLB_FLUSH_ALL) {
40f02448:	fff00793          	li	a5,-1
	unsigned long vmid  = tinfo->asid;
40f0244c:	00852a03          	lw	s4,8(a0)
	if (size == SBI_TLB_FLUSH_ALL) {
40f02450:	0cf90a63          	beq	s2,a5,40f02524 <sbi_tlb_local_flush+0x210>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02454:	00000493          	li	s1,0
40f02458:	00001ab7          	lui	s5,0x1
40f0245c:	f40904e3          	beqz	s2,40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_gvma_vmid_gpa(vmid, start+i);
40f02460:	013485b3          	add	a1,s1,s3
40f02464:	000a0513          	mv	a0,s4
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02468:	015484b3          	add	s1,s1,s5
		__sbi_hfence_gvma_vmid_gpa(vmid, start+i);
40f0246c:	60c040ef          	jal	ra,40f06a78 <__sbi_hfence_gvma_vmid_gpa>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02470:	ff24e8e3          	bltu	s1,s2,40f02460 <sbi_tlb_local_flush+0x14c>
40f02474:	f31ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		sbi_tlb_hfence_vvma(tinfo);
40f02478:	00052983          	lw	s3,0(a0)
40f0247c:	00452903          	lw	s2,4(a0)
	if ((start == 0 && size == 0) || (size == SBI_TLB_FLUSH_ALL)) {
40f02480:	0129e7b3          	or	a5,s3,s2
40f02484:	06078e63          	beqz	a5,40f02500 <sbi_tlb_local_flush+0x1ec>
40f02488:	fff00793          	li	a5,-1
40f0248c:	06f90a63          	beq	s2,a5,40f02500 <sbi_tlb_local_flush+0x1ec>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f02490:	00000493          	li	s1,0
40f02494:	00001a37          	lui	s4,0x1
40f02498:	f00906e3          	beqz	s2,40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_vvma_va(start+i);
40f0249c:	00998533          	add	a0,s3,s1
	for (i = 0; i < size; i += PAGE_SIZE) {
40f024a0:	014484b3          	add	s1,s1,s4
		__sbi_hfence_vvma_va(start+i);
40f024a4:	604040ef          	jal	ra,40f06aa8 <__sbi_hfence_vvma_va>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f024a8:	ff24eae3          	bltu	s1,s2,40f0249c <sbi_tlb_local_flush+0x188>
40f024ac:	ef9ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		sbi_tlb_hfence_gvma(tinfo);
40f024b0:	00052983          	lw	s3,0(a0)
40f024b4:	00452903          	lw	s2,4(a0)
	if ((start == 0 && size == 0) || (size == SBI_TLB_FLUSH_ALL)) {
40f024b8:	0129e7b3          	or	a5,s3,s2
40f024bc:	04078663          	beqz	a5,40f02508 <sbi_tlb_local_flush+0x1f4>
40f024c0:	fff00793          	li	a5,-1
40f024c4:	04f90263          	beq	s2,a5,40f02508 <sbi_tlb_local_flush+0x1f4>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f024c8:	00000493          	li	s1,0
40f024cc:	00001a37          	lui	s4,0x1
40f024d0:	ec090ae3          	beqz	s2,40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_gvma_gpa(start+i);
40f024d4:	00998533          	add	a0,s3,s1
	for (i = 0; i < size; i += PAGE_SIZE) {
40f024d8:	014484b3          	add	s1,s1,s4
		__sbi_hfence_gvma_gpa(start+i);
40f024dc:	5ac040ef          	jal	ra,40f06a88 <__sbi_hfence_gvma_gpa>
	for (i = 0; i < size; i += PAGE_SIZE) {
40f024e0:	ff24eae3          	bltu	s1,s2,40f024d4 <sbi_tlb_local_flush+0x1c0>
40f024e4:	ec1ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		sbi_printf("Invalid tlb flush request type [%lu]\n",
40f024e8:	00008517          	auipc	a0,0x8
40f024ec:	d9c50513          	addi	a0,a0,-612 # 40f0a284 <__modsi3+0x8a8>
40f024f0:	10c030ef          	jal	ra,40f055fc <sbi_printf>
	return;
40f024f4:	eb1ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
	__asm__ __volatile("sfence.vma");
40f024f8:	12000073          	sfence.vma
		return;
40f024fc:	ea9ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_vvma_all();
40f02500:	5b0040ef          	jal	ra,40f06ab0 <__sbi_hfence_vvma_all>
		return;
40f02504:	ea1ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_gvma_all();
40f02508:	588040ef          	jal	ra,40f06a90 <__sbi_hfence_gvma_all>
		return;
40f0250c:	e99ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		__asm__ __volatile__("sfence.vma x0, %0"
40f02510:	12b00073          	sfence.vma	zero,a1
		return;
40f02514:	e91ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_vvma_asid(asid);
40f02518:	000a0513          	mv	a0,s4
40f0251c:	584040ef          	jal	ra,40f06aa0 <__sbi_hfence_vvma_asid>
		return;
40f02520:	e85ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>
		__sbi_hfence_gvma_vmid(vmid);
40f02524:	000a0513          	mv	a0,s4
40f02528:	558040ef          	jal	ra,40f06a80 <__sbi_hfence_gvma_vmid>
		return;
40f0252c:	e79ff06f          	j	40f023a4 <sbi_tlb_local_flush+0x90>

40f02530 <sbi_tlb_entry_process>:

static void sbi_tlb_entry_process(struct sbi_scratch *scratch,
				  struct sbi_tlb_info *tinfo)
{
40f02530:	fe010113          	addi	sp,sp,-32
40f02534:	00812c23          	sw	s0,24(sp)
40f02538:	00912a23          	sw	s1,20(sp)
40f0253c:	01512223          	sw	s5,4(sp)
40f02540:	00112e23          	sw	ra,28(sp)
40f02544:	01212823          	sw	s2,16(sp)
40f02548:	01312623          	sw	s3,12(sp)
40f0254c:	01412423          	sw	s4,8(sp)
40f02550:	01612023          	sw	s6,0(sp)
40f02554:	02010413          	addi	s0,sp,32
40f02558:	00058493          	mv	s1,a1
40f0255c:	00050a93          	mv	s5,a0
	u32 i;
	u64 m;
	struct sbi_scratch *rscratch = NULL;
	unsigned long *rtlb_sync = NULL;

	sbi_tlb_local_flush(tinfo);
40f02560:	00058513          	mv	a0,a1
40f02564:	db1ff0ef          	jal	ra,40f02314 <sbi_tlb_local_flush>
	for (i = 0, m = tinfo->shart_mask; m; i++, m >>= 1) {
40f02568:	0104a483          	lw	s1,16(s1)
40f0256c:	06048e63          	beqz	s1,40f025e8 <sbi_tlb_entry_process+0xb8>
40f02570:	00000913          	li	s2,0
40f02574:	00000a13          	li	s4,0
		if (!(m & 1UL))
			continue;

		rscratch = sbi_hart_id_to_scratch(scratch, i);
		rtlb_sync = sbi_scratch_offset_ptr(rscratch, tlb_sync_off);
40f02578:	0000ab17          	auipc	s6,0xa
40f0257c:	aa8b0b13          	addi	s6,s6,-1368 # 40f0c020 <tlb_sync_off>
40f02580:	0200006f          	j	40f025a0 <sbi_tlb_entry_process+0x70>
	for (i = 0, m = tinfo->shart_mask; m; i++, m >>= 1) {
40f02584:	01f91793          	slli	a5,s2,0x1f
40f02588:	0014d493          	srli	s1,s1,0x1
40f0258c:	0097e4b3          	or	s1,a5,s1
40f02590:	00195913          	srli	s2,s2,0x1
40f02594:	0124e7b3          	or	a5,s1,s2
40f02598:	001a0a13          	addi	s4,s4,1 # 1001 <_fw_start-0x40efefff>
40f0259c:	04078663          	beqz	a5,40f025e8 <sbi_tlb_entry_process+0xb8>
		if (!(m & 1UL))
40f025a0:	0014f793          	andi	a5,s1,1
40f025a4:	fe0780e3          	beqz	a5,40f02584 <sbi_tlb_entry_process+0x54>
		rscratch = sbi_hart_id_to_scratch(scratch, i);
40f025a8:	000a0593          	mv	a1,s4
40f025ac:	000a8513          	mv	a0,s5
40f025b0:	5d9040ef          	jal	ra,40f07388 <sbi_hart_id_to_scratch>
		rtlb_sync = sbi_scratch_offset_ptr(rscratch, tlb_sync_off);
40f025b4:	000b2983          	lw	s3,0(s6)
40f025b8:	013509b3          	add	s3,a0,s3
		while (atomic_raw_xchg_ulong(rtlb_sync, 1)) ;
40f025bc:	00100593          	li	a1,1
40f025c0:	00098513          	mv	a0,s3
40f025c4:	104020ef          	jal	ra,40f046c8 <atomic_raw_xchg_ulong>
40f025c8:	fe051ae3          	bnez	a0,40f025bc <sbi_tlb_entry_process+0x8c>
	for (i = 0, m = tinfo->shart_mask; m; i++, m >>= 1) {
40f025cc:	01f91793          	slli	a5,s2,0x1f
40f025d0:	0014d493          	srli	s1,s1,0x1
40f025d4:	0097e4b3          	or	s1,a5,s1
40f025d8:	00195913          	srli	s2,s2,0x1
40f025dc:	0124e7b3          	or	a5,s1,s2
40f025e0:	001a0a13          	addi	s4,s4,1
40f025e4:	fa079ee3          	bnez	a5,40f025a0 <sbi_tlb_entry_process+0x70>
	}
}
40f025e8:	01c12083          	lw	ra,28(sp)
40f025ec:	01812403          	lw	s0,24(sp)
40f025f0:	01412483          	lw	s1,20(sp)
40f025f4:	01012903          	lw	s2,16(sp)
40f025f8:	00c12983          	lw	s3,12(sp)
40f025fc:	00812a03          	lw	s4,8(sp)
40f02600:	00412a83          	lw	s5,4(sp)
40f02604:	00012b03          	lw	s6,0(sp)
40f02608:	02010113          	addi	sp,sp,32
40f0260c:	00008067          	ret

40f02610 <sbi_tlb_process>:

	}
}

static void sbi_tlb_process(struct sbi_scratch *scratch)
{
40f02610:	fd010113          	addi	sp,sp,-48
40f02614:	02812423          	sw	s0,40(sp)
40f02618:	03212023          	sw	s2,32(sp)
40f0261c:	02112623          	sw	ra,44(sp)
40f02620:	02912223          	sw	s1,36(sp)
40f02624:	03010413          	addi	s0,sp,48
	struct sbi_tlb_info tinfo;
	struct sbi_fifo *tlb_fifo =
			sbi_scratch_offset_ptr(scratch, tlb_fifo_off);
40f02628:	0000a797          	auipc	a5,0xa
40f0262c:	9f478793          	addi	a5,a5,-1548 # 40f0c01c <tlb_fifo_off>
	struct sbi_fifo *tlb_fifo =
40f02630:	0007a483          	lw	s1,0(a5)
{
40f02634:	00050913          	mv	s2,a0
	struct sbi_fifo *tlb_fifo =
40f02638:	009504b3          	add	s1,a0,s1

	while (!sbi_fifo_dequeue(tlb_fifo, &tinfo))
40f0263c:	00c0006f          	j	40f02648 <sbi_tlb_process+0x38>
		sbi_tlb_entry_process(scratch, &tinfo);
40f02640:	00090513          	mv	a0,s2
40f02644:	eedff0ef          	jal	ra,40f02530 <sbi_tlb_entry_process>
	while (!sbi_fifo_dequeue(tlb_fifo, &tinfo))
40f02648:	fdc40593          	addi	a1,s0,-36
40f0264c:	00048513          	mv	a0,s1
40f02650:	354040ef          	jal	ra,40f069a4 <sbi_fifo_dequeue>
		sbi_tlb_entry_process(scratch, &tinfo);
40f02654:	fdc40593          	addi	a1,s0,-36
	while (!sbi_fifo_dequeue(tlb_fifo, &tinfo))
40f02658:	fe0504e3          	beqz	a0,40f02640 <sbi_tlb_process+0x30>
}
40f0265c:	02c12083          	lw	ra,44(sp)
40f02660:	02812403          	lw	s0,40(sp)
40f02664:	02412483          	lw	s1,36(sp)
40f02668:	02012903          	lw	s2,32(sp)
40f0266c:	03010113          	addi	sp,sp,48
40f02670:	00008067          	ret

40f02674 <sbi_tlb_process_count.constprop.4>:
static void sbi_tlb_process_count(struct sbi_scratch *scratch, int count)
40f02674:	fd010113          	addi	sp,sp,-48
40f02678:	02812423          	sw	s0,40(sp)
40f0267c:	03212023          	sw	s2,32(sp)
40f02680:	02112623          	sw	ra,44(sp)
40f02684:	02912223          	sw	s1,36(sp)
40f02688:	03010413          	addi	s0,sp,48
			sbi_scratch_offset_ptr(scratch, tlb_fifo_off);
40f0268c:	0000a797          	auipc	a5,0xa
40f02690:	99078793          	addi	a5,a5,-1648 # 40f0c01c <tlb_fifo_off>
	struct sbi_fifo *tlb_fifo =
40f02694:	0007a483          	lw	s1,0(a5)
static void sbi_tlb_process_count(struct sbi_scratch *scratch, int count)
40f02698:	00050913          	mv	s2,a0
	while (!sbi_fifo_dequeue(tlb_fifo, &tinfo)) {
40f0269c:	fdc40593          	addi	a1,s0,-36
	struct sbi_fifo *tlb_fifo =
40f026a0:	009504b3          	add	s1,a0,s1
	while (!sbi_fifo_dequeue(tlb_fifo, &tinfo)) {
40f026a4:	00048513          	mv	a0,s1
40f026a8:	2fc040ef          	jal	ra,40f069a4 <sbi_fifo_dequeue>
40f026ac:	02051663          	bnez	a0,40f026d8 <sbi_tlb_process_count.constprop.4+0x64>
		sbi_tlb_entry_process(scratch, &tinfo);
40f026b0:	fdc40593          	addi	a1,s0,-36
40f026b4:	00090513          	mv	a0,s2
40f026b8:	e79ff0ef          	jal	ra,40f02530 <sbi_tlb_entry_process>
	while (!sbi_fifo_dequeue(tlb_fifo, &tinfo)) {
40f026bc:	fdc40593          	addi	a1,s0,-36
40f026c0:	00048513          	mv	a0,s1
40f026c4:	2e0040ef          	jal	ra,40f069a4 <sbi_fifo_dequeue>
40f026c8:	00051863          	bnez	a0,40f026d8 <sbi_tlb_process_count.constprop.4+0x64>
		sbi_tlb_entry_process(scratch, &tinfo);
40f026cc:	fdc40593          	addi	a1,s0,-36
40f026d0:	00090513          	mv	a0,s2
40f026d4:	e5dff0ef          	jal	ra,40f02530 <sbi_tlb_entry_process>
}
40f026d8:	02c12083          	lw	ra,44(sp)
40f026dc:	02812403          	lw	s0,40(sp)
40f026e0:	02412483          	lw	s1,36(sp)
40f026e4:	02012903          	lw	s2,32(sp)
40f026e8:	03010113          	addi	sp,sp,48
40f026ec:	00008067          	ret

40f026f0 <sbi_tlb_update>:
}

static int sbi_tlb_update(struct sbi_scratch *scratch,
			  struct sbi_scratch *remote_scratch,
			  u32 remote_hartid, void *data)
{
40f026f0:	fd010113          	addi	sp,sp,-48
40f026f4:	02812423          	sw	s0,40(sp)
40f026f8:	02912223          	sw	s1,36(sp)
40f026fc:	01312e23          	sw	s3,28(sp)
40f02700:	01412c23          	sw	s4,24(sp)
40f02704:	01512a23          	sw	s5,20(sp)
40f02708:	01612823          	sw	s6,16(sp)
40f0270c:	02112623          	sw	ra,44(sp)
40f02710:	03212023          	sw	s2,32(sp)
40f02714:	01712623          	sw	s7,12(sp)
40f02718:	03010413          	addi	s0,sp,48
40f0271c:	00068493          	mv	s1,a3
40f02720:	00050b13          	mv	s6,a0
40f02724:	00058a93          	mv	s5,a1
40f02728:	00060a13          	mv	s4,a2
	int ret;
	struct sbi_fifo *tlb_fifo_r;
	struct sbi_tlb_info *tinfo = data;
	u32 curr_hartid = sbi_current_hartid();
40f0272c:	38c040ef          	jal	ra,40f06ab8 <sbi_current_hartid>
	/*
	 * If address range to flush is too big then simply
	 * upgrade it to flush all because we can only flush
	 * 4KB at a time.
	 */
	if (tinfo->size > tlb_range_flush_limit) {
40f02730:	0000a797          	auipc	a5,0xa
40f02734:	8e478793          	addi	a5,a5,-1820 # 40f0c014 <tlb_range_flush_limit>
40f02738:	0044a703          	lw	a4,4(s1)
40f0273c:	0007a783          	lw	a5,0(a5)
	u32 curr_hartid = sbi_current_hartid();
40f02740:	00050993          	mv	s3,a0
	if (tinfo->size > tlb_range_flush_limit) {
40f02744:	00e7f863          	bgeu	a5,a4,40f02754 <sbi_tlb_update+0x64>
		tinfo->start = 0;
		tinfo->size = SBI_TLB_FLUSH_ALL;
40f02748:	fff00793          	li	a5,-1
		tinfo->start = 0;
40f0274c:	0004a023          	sw	zero,0(s1)
		tinfo->size = SBI_TLB_FLUSH_ALL;
40f02750:	00f4a223          	sw	a5,4(s1)

	/*
	 * If the request is to queue a tlb flush entry for itself
	 * then just do a local flush and return;
	 */
	if (remote_hartid == curr_hartid) {
40f02754:	0b498063          	beq	s3,s4,40f027f4 <sbi_tlb_update+0x104>
		sbi_tlb_local_flush(tinfo);
		return -1;
	}

	tlb_fifo_r = sbi_scratch_offset_ptr(remote_scratch, tlb_fifo_off);
40f02758:	0000a797          	auipc	a5,0xa
40f0275c:	8c478793          	addi	a5,a5,-1852 # 40f0c01c <tlb_fifo_off>
40f02760:	0007a903          	lw	s2,0(a5)

	ret = sbi_fifo_inplace_update(tlb_fifo_r, data, sbi_tlb_update_cb);
40f02764:	00000617          	auipc	a2,0x0
40f02768:	10060613          	addi	a2,a2,256 # 40f02864 <sbi_tlb_update_cb>
40f0276c:	00048593          	mv	a1,s1
	tlb_fifo_r = sbi_scratch_offset_ptr(remote_scratch, tlb_fifo_off);
40f02770:	012a8933          	add	s2,s5,s2
	ret = sbi_fifo_inplace_update(tlb_fifo_r, data, sbi_tlb_update_cb);
40f02774:	00090513          	mv	a0,s2
40f02778:	080040ef          	jal	ra,40f067f8 <sbi_fifo_inplace_update>
	if (ret != SBI_FIFO_UNCHANGED) {
40f0277c:	00200713          	li	a4,2
		return 1;
40f02780:	00100793          	li	a5,1
		 * loop leading to a deadlock.
		 * TODO: Introduce a wait/wakeup event mechanism to handle
		 * this properly.
		 */
		sbi_tlb_process_count(scratch, 1);
		sbi_dprintf(remote_scratch, "hart%d: hart%d tlb fifo full\n",
40f02784:	00008b97          	auipc	s7,0x8
40f02788:	b28b8b93          	addi	s7,s7,-1240 # 40f0a2ac <__modsi3+0x8d0>
	if (ret != SBI_FIFO_UNCHANGED) {
40f0278c:	04e50863          	beq	a0,a4,40f027dc <sbi_tlb_update+0xec>
			    curr_hartid, remote_hartid);
	}

	return 0;
}
40f02790:	02c12083          	lw	ra,44(sp)
40f02794:	02812403          	lw	s0,40(sp)
40f02798:	02412483          	lw	s1,36(sp)
40f0279c:	02012903          	lw	s2,32(sp)
40f027a0:	01c12983          	lw	s3,28(sp)
40f027a4:	01812a03          	lw	s4,24(sp)
40f027a8:	01412a83          	lw	s5,20(sp)
40f027ac:	01012b03          	lw	s6,16(sp)
40f027b0:	00c12b83          	lw	s7,12(sp)
40f027b4:	00078513          	mv	a0,a5
40f027b8:	03010113          	addi	sp,sp,48
40f027bc:	00008067          	ret
		sbi_tlb_process_count(scratch, 1);
40f027c0:	000b0513          	mv	a0,s6
40f027c4:	eb1ff0ef          	jal	ra,40f02674 <sbi_tlb_process_count.constprop.4>
		sbi_dprintf(remote_scratch, "hart%d: hart%d tlb fifo full\n",
40f027c8:	000a0693          	mv	a3,s4
40f027cc:	00098613          	mv	a2,s3
40f027d0:	000b8593          	mv	a1,s7
40f027d4:	000a8513          	mv	a0,s5
40f027d8:	6a9020ef          	jal	ra,40f05680 <sbi_dprintf>
	while (sbi_fifo_enqueue(tlb_fifo_r, data) < 0) {
40f027dc:	00048593          	mv	a1,s1
40f027e0:	00090513          	mv	a0,s2
40f027e4:	104040ef          	jal	ra,40f068e8 <sbi_fifo_enqueue>
40f027e8:	fc054ce3          	bltz	a0,40f027c0 <sbi_tlb_update+0xd0>
	return 0;
40f027ec:	00000793          	li	a5,0
40f027f0:	fa1ff06f          	j	40f02790 <sbi_tlb_update+0xa0>
		sbi_tlb_local_flush(tinfo);
40f027f4:	00048513          	mv	a0,s1
40f027f8:	b1dff0ef          	jal	ra,40f02314 <sbi_tlb_local_flush>
		return -1;
40f027fc:	fff00793          	li	a5,-1
40f02800:	f91ff06f          	j	40f02790 <sbi_tlb_update+0xa0>

40f02804 <sbi_tlb_sync>:
{
40f02804:	ff010113          	addi	sp,sp,-16
40f02808:	00812423          	sw	s0,8(sp)
40f0280c:	01212023          	sw	s2,0(sp)
40f02810:	00112623          	sw	ra,12(sp)
40f02814:	00912223          	sw	s1,4(sp)
40f02818:	01010413          	addi	s0,sp,16
			sbi_scratch_offset_ptr(scratch, tlb_sync_off);
40f0281c:	0000a797          	auipc	a5,0xa
40f02820:	80478793          	addi	a5,a5,-2044 # 40f0c020 <tlb_sync_off>
	unsigned long *tlb_sync =
40f02824:	0007a483          	lw	s1,0(a5)
{
40f02828:	00050913          	mv	s2,a0
	unsigned long *tlb_sync =
40f0282c:	009504b3          	add	s1,a0,s1
	while (!atomic_raw_xchg_ulong(tlb_sync, 0)) {
40f02830:	00c0006f          	j	40f0283c <sbi_tlb_sync+0x38>
		sbi_tlb_process_count(scratch, 1);
40f02834:	00090513          	mv	a0,s2
40f02838:	e3dff0ef          	jal	ra,40f02674 <sbi_tlb_process_count.constprop.4>
	while (!atomic_raw_xchg_ulong(tlb_sync, 0)) {
40f0283c:	00000593          	li	a1,0
40f02840:	00048513          	mv	a0,s1
40f02844:	685010ef          	jal	ra,40f046c8 <atomic_raw_xchg_ulong>
40f02848:	fe0506e3          	beqz	a0,40f02834 <sbi_tlb_sync+0x30>
}
40f0284c:	00c12083          	lw	ra,12(sp)
40f02850:	00812403          	lw	s0,8(sp)
40f02854:	00412483          	lw	s1,4(sp)
40f02858:	00012903          	lw	s2,0(sp)
40f0285c:	01010113          	addi	sp,sp,16
40f02860:	00008067          	ret

40f02864 <sbi_tlb_update_cb>:
{
40f02864:	ff010113          	addi	sp,sp,-16
40f02868:	00812623          	sw	s0,12(sp)
40f0286c:	01010413          	addi	s0,sp,16
	if (!in || !data)
40f02870:	06050063          	beqz	a0,40f028d0 <sbi_tlb_update_cb+0x6c>
40f02874:	04058e63          	beqz	a1,40f028d0 <sbi_tlb_update_cb+0x6c>
	if (next->type == SBI_TLB_FLUSH_VMA_ASID &&
40f02878:	00c52703          	lw	a4,12(a0)
40f0287c:	00100693          	li	a3,1
40f02880:	00050793          	mv	a5,a0
40f02884:	04d70e63          	beq	a4,a3,40f028e0 <sbi_tlb_update_cb+0x7c>
	} else if (next->type == SBI_TLB_FLUSH_VMA &&
40f02888:	04071463          	bnez	a4,40f028d0 <sbi_tlb_update_cb+0x6c>
40f0288c:	00c5a703          	lw	a4,12(a1)
		return ret;
40f02890:	00200513          	li	a0,2
	} else if (next->type == SBI_TLB_FLUSH_VMA &&
40f02894:	04071063          	bnez	a4,40f028d4 <sbi_tlb_update_cb+0x70>
	next_end = next->start + next->size;
40f02898:	0007a603          	lw	a2,0(a5)
40f0289c:	0047a683          	lw	a3,4(a5)
	curr_end = curr->start + curr->size;
40f028a0:	0005a803          	lw	a6,0(a1)
40f028a4:	0045a703          	lw	a4,4(a1)
	next_end = next->start + next->size;
40f028a8:	00d606b3          	add	a3,a2,a3
	curr_end = curr->start + curr->size;
40f028ac:	00e80733          	add	a4,a6,a4
	if (next->start <= curr->start && next_end > curr_end) {
40f028b0:	04c87663          	bgeu	a6,a2,40f028fc <sbi_tlb_update_cb+0x98>
	} else if (next->start >= curr->start && next_end <= curr_end) {
40f028b4:	02d76063          	bltu	a4,a3,40f028d4 <sbi_tlb_update_cb+0x70>
		curr->shart_mask = curr->shart_mask | next->shart_mask;
40f028b8:	0105a703          	lw	a4,16(a1)
40f028bc:	0107a783          	lw	a5,16(a5)
		ret		 = SBI_FIFO_SKIP;
40f028c0:	00000513          	li	a0,0
		curr->shart_mask = curr->shart_mask | next->shart_mask;
40f028c4:	00f76733          	or	a4,a4,a5
40f028c8:	00e5a823          	sw	a4,16(a1)
		ret		 = SBI_FIFO_SKIP;
40f028cc:	0080006f          	j	40f028d4 <sbi_tlb_update_cb+0x70>
		return ret;
40f028d0:	00200513          	li	a0,2
}
40f028d4:	00c12403          	lw	s0,12(sp)
40f028d8:	01010113          	addi	sp,sp,16
40f028dc:	00008067          	ret
	if (next->type == SBI_TLB_FLUSH_VMA_ASID &&
40f028e0:	00c5a683          	lw	a3,12(a1)
		return ret;
40f028e4:	00200513          	li	a0,2
	if (next->type == SBI_TLB_FLUSH_VMA_ASID &&
40f028e8:	fee696e3          	bne	a3,a4,40f028d4 <sbi_tlb_update_cb+0x70>
		if (next->asid == curr->asid)
40f028ec:	0087a683          	lw	a3,8(a5)
40f028f0:	0085a703          	lw	a4,8(a1)
40f028f4:	fee690e3          	bne	a3,a4,40f028d4 <sbi_tlb_update_cb+0x70>
40f028f8:	fa1ff06f          	j	40f02898 <sbi_tlb_update_cb+0x34>
	if (next->start <= curr->start && next_end > curr_end) {
40f028fc:	02d77463          	bgeu	a4,a3,40f02924 <sbi_tlb_update_cb+0xc0>
		curr->start = next->start;
40f02900:	00c5a023          	sw	a2,0(a1)
		curr->size  = next->size;
40f02904:	0047a683          	lw	a3,4(a5)
		curr->shart_mask = curr->shart_mask | next->shart_mask;
40f02908:	0105a703          	lw	a4,16(a1)
		ret	    = SBI_FIFO_UPDATED;
40f0290c:	00100513          	li	a0,1
		curr->size  = next->size;
40f02910:	00d5a223          	sw	a3,4(a1)
		curr->shart_mask = curr->shart_mask | next->shart_mask;
40f02914:	0107a783          	lw	a5,16(a5)
40f02918:	00f76733          	or	a4,a4,a5
40f0291c:	00e5a823          	sw	a4,16(a1)
		ret	    = SBI_FIFO_UPDATED;
40f02920:	fb5ff06f          	j	40f028d4 <sbi_tlb_update_cb+0x70>
	} else if (next->start >= curr->start && next_end <= curr_end) {
40f02924:	fb0618e3          	bne	a2,a6,40f028d4 <sbi_tlb_update_cb+0x70>
40f02928:	f91ff06f          	j	40f028b8 <sbi_tlb_update_cb+0x54>

40f0292c <sbi_tlb_request>:

static u32 tlb_event = SBI_IPI_EVENT_MAX;

int sbi_tlb_request(struct sbi_scratch *scratch, ulong hmask,
		    ulong hbase, struct sbi_tlb_info *tinfo)
{
40f0292c:	ff010113          	addi	sp,sp,-16
40f02930:	00812423          	sw	s0,8(sp)
40f02934:	00112623          	sw	ra,12(sp)
40f02938:	01010413          	addi	s0,sp,16
	return sbi_ipi_send_many(scratch, hmask, hbase, tlb_event, tinfo);
40f0293c:	00008797          	auipc	a5,0x8
40f02940:	6d078793          	addi	a5,a5,1744 # 40f0b00c <tlb_event>
40f02944:	00068713          	mv	a4,a3
40f02948:	0007a683          	lw	a3,0(a5)
40f0294c:	f88fe0ef          	jal	ra,40f010d4 <sbi_ipi_send_many>
}
40f02950:	00c12083          	lw	ra,12(sp)
40f02954:	00812403          	lw	s0,8(sp)
40f02958:	01010113          	addi	sp,sp,16
40f0295c:	00008067          	ret

40f02960 <sbi_tlb_init>:

int sbi_tlb_init(struct sbi_scratch *scratch, bool cold_boot)
{
40f02960:	fe010113          	addi	sp,sp,-32
40f02964:	00812c23          	sw	s0,24(sp)
40f02968:	00912a23          	sw	s1,20(sp)
40f0296c:	00112e23          	sw	ra,28(sp)
40f02970:	01212823          	sw	s2,16(sp)
40f02974:	01312623          	sw	s3,12(sp)
40f02978:	01412423          	sw	s4,8(sp)
40f0297c:	01512223          	sw	s5,4(sp)
40f02980:	01612023          	sw	s6,0(sp)
40f02984:	02010413          	addi	s0,sp,32
40f02988:	00050493          	mv	s1,a0
	void *tlb_mem;
	unsigned long *tlb_sync;
	struct sbi_fifo *tlb_q;
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);

	if (cold_boot) {
40f0298c:	08059a63          	bnez	a1,40f02a20 <sbi_tlb_init+0xc0>
			return ret;
		}
		tlb_event = ret;
		tlb_range_flush_limit = sbi_platform_tlbr_flush_limit(plat);
	} else {
		if (!tlb_sync_off ||
40f02990:	00009797          	auipc	a5,0x9
40f02994:	69078793          	addi	a5,a5,1680 # 40f0c020 <tlb_sync_off>
40f02998:	0007a783          	lw	a5,0(a5)
40f0299c:	1c078863          	beqz	a5,40f02b6c <sbi_tlb_init+0x20c>
		    !tlb_fifo_off ||
40f029a0:	00009717          	auipc	a4,0x9
40f029a4:	67c70713          	addi	a4,a4,1660 # 40f0c01c <tlb_fifo_off>
40f029a8:	00072503          	lw	a0,0(a4)
		if (!tlb_sync_off ||
40f029ac:	1c050063          	beqz	a0,40f02b6c <sbi_tlb_init+0x20c>
		    !tlb_fifo_mem_off)
40f029b0:	00009717          	auipc	a4,0x9
40f029b4:	66870713          	addi	a4,a4,1640 # 40f0c018 <tlb_fifo_mem_off>
40f029b8:	00072583          	lw	a1,0(a4)
		    !tlb_fifo_off ||
40f029bc:	1a058863          	beqz	a1,40f02b6c <sbi_tlb_init+0x20c>
			return SBI_ENOMEM;
		if (SBI_IPI_EVENT_MAX <= tlb_event)
40f029c0:	00008717          	auipc	a4,0x8
40f029c4:	64c70713          	addi	a4,a4,1612 # 40f0b00c <tlb_event>
40f029c8:	00072683          	lw	a3,0(a4)
40f029cc:	01f00713          	li	a4,31
40f029d0:	1ad76263          	bltu	a4,a3,40f02b74 <sbi_tlb_init+0x214>

	tlb_sync = sbi_scratch_offset_ptr(scratch, tlb_sync_off);
	tlb_q = sbi_scratch_offset_ptr(scratch, tlb_fifo_off);
	tlb_mem = sbi_scratch_offset_ptr(scratch, tlb_fifo_mem_off);

	*tlb_sync = 0;
40f029d4:	00f487b3          	add	a5,s1,a5
40f029d8:	0007a023          	sw	zero,0(a5)

	sbi_fifo_init(tlb_q, tlb_mem,
40f029dc:	01400693          	li	a3,20
40f029e0:	00800613          	li	a2,8
40f029e4:	00b485b3          	add	a1,s1,a1
40f029e8:	00a48533          	add	a0,s1,a0
40f029ec:	43d030ef          	jal	ra,40f06628 <sbi_fifo_init>
		      SBI_TLB_FIFO_NUM_ENTRIES, SBI_TLB_INFO_SIZE);

	return 0;
40f029f0:	00000913          	li	s2,0
}
40f029f4:	01c12083          	lw	ra,28(sp)
40f029f8:	01812403          	lw	s0,24(sp)
40f029fc:	00090513          	mv	a0,s2
40f02a00:	01412483          	lw	s1,20(sp)
40f02a04:	01012903          	lw	s2,16(sp)
40f02a08:	00c12983          	lw	s3,12(sp)
40f02a0c:	00812a03          	lw	s4,8(sp)
40f02a10:	00412a83          	lw	s5,4(sp)
40f02a14:	00012b03          	lw	s6,0(sp)
40f02a18:	02010113          	addi	sp,sp,32
40f02a1c:	00008067          	ret
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f02a20:	01954983          	lbu	s3,25(a0)
40f02a24:	01854683          	lbu	a3,24(a0)
40f02a28:	01a54783          	lbu	a5,26(a0)
40f02a2c:	01b54703          	lbu	a4,27(a0)
40f02a30:	00899993          	slli	s3,s3,0x8
40f02a34:	00d9e9b3          	or	s3,s3,a3
40f02a38:	01079793          	slli	a5,a5,0x10
40f02a3c:	0137e7b3          	or	a5,a5,s3
		tlb_sync_off = sbi_scratch_alloc_offset(sizeof(*tlb_sync),
40f02a40:	00008597          	auipc	a1,0x8
40f02a44:	88c58593          	addi	a1,a1,-1908 # 40f0a2cc <__modsi3+0x8f0>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f02a48:	01871993          	slli	s3,a4,0x18
		tlb_sync_off = sbi_scratch_alloc_offset(sizeof(*tlb_sync),
40f02a4c:	00400513          	li	a0,4
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f02a50:	00f9e9b3          	or	s3,s3,a5
		tlb_sync_off = sbi_scratch_alloc_offset(sizeof(*tlb_sync),
40f02a54:	da9fe0ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f02a58:	00009797          	auipc	a5,0x9
40f02a5c:	5ca7a423          	sw	a0,1480(a5) # 40f0c020 <tlb_sync_off>
40f02a60:	00009b17          	auipc	s6,0x9
40f02a64:	5c0b0b13          	addi	s6,s6,1472 # 40f0c020 <tlb_sync_off>
		if (!tlb_sync_off)
40f02a68:	10050263          	beqz	a0,40f02b6c <sbi_tlb_init+0x20c>
		tlb_fifo_off = sbi_scratch_alloc_offset(sizeof(*tlb_q),
40f02a6c:	00008597          	auipc	a1,0x8
40f02a70:	87058593          	addi	a1,a1,-1936 # 40f0a2dc <__modsi3+0x900>
40f02a74:	01000513          	li	a0,16
40f02a78:	d85fe0ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f02a7c:	00009797          	auipc	a5,0x9
40f02a80:	5aa7a023          	sw	a0,1440(a5) # 40f0c01c <tlb_fifo_off>
40f02a84:	00009a97          	auipc	s5,0x9
40f02a88:	598a8a93          	addi	s5,s5,1432 # 40f0c01c <tlb_fifo_off>
		if (!tlb_fifo_off) {
40f02a8c:	0e050863          	beqz	a0,40f02b7c <sbi_tlb_init+0x21c>
		tlb_fifo_mem_off = sbi_scratch_alloc_offset(
40f02a90:	00008597          	auipc	a1,0x8
40f02a94:	85c58593          	addi	a1,a1,-1956 # 40f0a2ec <__modsi3+0x910>
40f02a98:	0a000513          	li	a0,160
40f02a9c:	d61fe0ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f02aa0:	00009797          	auipc	a5,0x9
40f02aa4:	56a7ac23          	sw	a0,1400(a5) # 40f0c018 <tlb_fifo_mem_off>
40f02aa8:	00009a17          	auipc	s4,0x9
40f02aac:	570a0a13          	addi	s4,s4,1392 # 40f0c018 <tlb_fifo_mem_off>
		if (!tlb_fifo_mem_off) {
40f02ab0:	0c050e63          	beqz	a0,40f02b8c <sbi_tlb_init+0x22c>
		ret = sbi_ipi_event_create(&tlb_ops);
40f02ab4:	00008517          	auipc	a0,0x8
40f02ab8:	5bc50513          	addi	a0,a0,1468 # 40f0b070 <tlb_ops>
40f02abc:	8e1fe0ef          	jal	ra,40f0139c <sbi_ipi_event_create>
40f02ac0:	00050913          	mv	s2,a0
		if (ret < 0) {
40f02ac4:	08054663          	bltz	a0,40f02b50 <sbi_tlb_init+0x1f0>
		tlb_event = ret;
40f02ac8:	00008797          	auipc	a5,0x8
40f02acc:	54a7a223          	sw	a0,1348(a5) # 40f0b00c <tlb_event>
	if (plat && sbi_platform_ops(plat)->get_tlbr_flush_limit)
40f02ad0:	06098c63          	beqz	s3,40f02b48 <sbi_tlb_init+0x1e8>
40f02ad4:	0619c683          	lbu	a3,97(s3)
40f02ad8:	0609c603          	lbu	a2,96(s3)
40f02adc:	0629c703          	lbu	a4,98(s3)
40f02ae0:	0639c783          	lbu	a5,99(s3)
40f02ae4:	00869693          	slli	a3,a3,0x8
40f02ae8:	00c6e6b3          	or	a3,a3,a2
40f02aec:	01071713          	slli	a4,a4,0x10
40f02af0:	00d76733          	or	a4,a4,a3
40f02af4:	01879793          	slli	a5,a5,0x18
40f02af8:	00e7e7b3          	or	a5,a5,a4
40f02afc:	0457c683          	lbu	a3,69(a5)
40f02b00:	0447c603          	lbu	a2,68(a5)
40f02b04:	0467c703          	lbu	a4,70(a5)
40f02b08:	0477c783          	lbu	a5,71(a5)
40f02b0c:	00869693          	slli	a3,a3,0x8
40f02b10:	00c6e6b3          	or	a3,a3,a2
40f02b14:	01071713          	slli	a4,a4,0x10
40f02b18:	00d76733          	or	a4,a4,a3
40f02b1c:	01879793          	slli	a5,a5,0x18
40f02b20:	00e7e7b3          	or	a5,a5,a4
40f02b24:	00001537          	lui	a0,0x1
40f02b28:	00078463          	beqz	a5,40f02b30 <sbi_tlb_init+0x1d0>
		return sbi_platform_ops(plat)->get_tlbr_flush_limit();
40f02b2c:	000780e7          	jalr	a5
		tlb_range_flush_limit = sbi_platform_tlbr_flush_limit(plat);
40f02b30:	00009797          	auipc	a5,0x9
40f02b34:	4ea7a223          	sw	a0,1252(a5) # 40f0c014 <tlb_range_flush_limit>
40f02b38:	000b2783          	lw	a5,0(s6)
40f02b3c:	000aa503          	lw	a0,0(s5)
40f02b40:	000a2583          	lw	a1,0(s4)
40f02b44:	e91ff06f          	j	40f029d4 <sbi_tlb_init+0x74>
	if (plat && sbi_platform_ops(plat)->get_tlbr_flush_limit)
40f02b48:	00001537          	lui	a0,0x1
40f02b4c:	fe5ff06f          	j	40f02b30 <sbi_tlb_init+0x1d0>
			sbi_scratch_free_offset(tlb_fifo_mem_off);
40f02b50:	000a2503          	lw	a0,0(s4)
40f02b54:	e09fe0ef          	jal	ra,40f0195c <sbi_scratch_free_offset>
			sbi_scratch_free_offset(tlb_fifo_off);
40f02b58:	000aa503          	lw	a0,0(s5)
40f02b5c:	e01fe0ef          	jal	ra,40f0195c <sbi_scratch_free_offset>
			sbi_scratch_free_offset(tlb_sync_off);
40f02b60:	000b2503          	lw	a0,0(s6)
40f02b64:	df9fe0ef          	jal	ra,40f0195c <sbi_scratch_free_offset>
			return ret;
40f02b68:	e8dff06f          	j	40f029f4 <sbi_tlb_init+0x94>
			return SBI_ENOMEM;
40f02b6c:	ff400913          	li	s2,-12
40f02b70:	e85ff06f          	j	40f029f4 <sbi_tlb_init+0x94>
			return SBI_ENOSPC;
40f02b74:	ff500913          	li	s2,-11
40f02b78:	e7dff06f          	j	40f029f4 <sbi_tlb_init+0x94>
			sbi_scratch_free_offset(tlb_sync_off);
40f02b7c:	000b2503          	lw	a0,0(s6)
			return SBI_ENOMEM;
40f02b80:	ff400913          	li	s2,-12
			sbi_scratch_free_offset(tlb_sync_off);
40f02b84:	dd9fe0ef          	jal	ra,40f0195c <sbi_scratch_free_offset>
			return SBI_ENOMEM;
40f02b88:	e6dff06f          	j	40f029f4 <sbi_tlb_init+0x94>
			sbi_scratch_free_offset(tlb_fifo_off);
40f02b8c:	000aa503          	lw	a0,0(s5)
			return SBI_ENOMEM;
40f02b90:	ff400913          	li	s2,-12
			sbi_scratch_free_offset(tlb_fifo_off);
40f02b94:	dc9fe0ef          	jal	ra,40f0195c <sbi_scratch_free_offset>
			sbi_scratch_free_offset(tlb_sync_off);
40f02b98:	000b2503          	lw	a0,0(s6)
40f02b9c:	dc1fe0ef          	jal	ra,40f0195c <sbi_scratch_free_offset>
			return SBI_ENOMEM;
40f02ba0:	e55ff06f          	j	40f029f4 <sbi_tlb_init+0x94>

40f02ba4 <sbi_trap_redirect>:
 * @return 0 on success and negative error code on failure
 */
int sbi_trap_redirect(struct sbi_trap_regs *regs,
		      struct sbi_trap_info *trap,
		      struct sbi_scratch *scratch)
{
40f02ba4:	fe010113          	addi	sp,sp,-32
40f02ba8:	00812c23          	sw	s0,24(sp)
40f02bac:	00112e23          	sw	ra,28(sp)
40f02bb0:	00912a23          	sw	s1,20(sp)
40f02bb4:	01212823          	sw	s2,16(sp)
40f02bb8:	01312623          	sw	s3,12(sp)
40f02bbc:	01412423          	sw	s4,8(sp)
40f02bc0:	02010413          	addi	s0,sp,32
#endif
	/* By default, we redirect to HS-mode */
	bool next_virt = FALSE;

	/* Sanity check on previous mode */
	prev_mode = (regs->mstatus & MSTATUS_MPP) >> MSTATUS_MPP_SHIFT;
40f02bc4:	08554683          	lbu	a3,133(a0) # 1085 <_fw_start-0x40efef7b>
40f02bc8:	08454603          	lbu	a2,132(a0)
40f02bcc:	08654703          	lbu	a4,134(a0)
40f02bd0:	08754783          	lbu	a5,135(a0)
40f02bd4:	00869693          	slli	a3,a3,0x8
40f02bd8:	00c6e6b3          	or	a3,a3,a2
40f02bdc:	01071713          	slli	a4,a4,0x10
40f02be0:	00d76733          	or	a4,a4,a3
40f02be4:	01879793          	slli	a5,a5,0x18
40f02be8:	00e7e7b3          	or	a5,a5,a4
40f02bec:	00b7d793          	srli	a5,a5,0xb
	if (prev_mode != PRV_S && prev_mode != PRV_U)
40f02bf0:	0027f713          	andi	a4,a5,2
	bool prev_virt = (regs->mstatusH & MSTATUSH_MPV) ? TRUE : FALSE;
40f02bf4:	08854a03          	lbu	s4,136(a0)
	if (prev_mode != PRV_S && prev_mode != PRV_U)
40f02bf8:	38071a63          	bnez	a4,40f02f8c <sbi_trap_redirect+0x3e8>
		return SBI_ENOTSUPP;

	/* For certain exceptions from VS/VU-mode we redirect to VS-mode */
	if (misa_extension('H') && prev_virt) {
40f02bfc:	00050493          	mv	s1,a0
40f02c00:	04800513          	li	a0,72
40f02c04:	0037f913          	andi	s2,a5,3
40f02c08:	00058993          	mv	s3,a1
40f02c0c:	3c8010ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f02c10:	007a5a13          	srli	s4,s4,0x7
40f02c14:	0894c683          	lbu	a3,137(s1)
40f02c18:	0884c603          	lbu	a2,136(s1)
40f02c1c:	14051463          	bnez	a0,40f02d64 <sbi_trap_redirect+0x1c0>
		};
	}

	/* Update MSTATUS MPV bits */
#if __riscv_xlen == 32
	regs->mstatusH &= ~MSTATUSH_MPV;
40f02c20:	08a4c703          	lbu	a4,138(s1)
40f02c24:	08b4c783          	lbu	a5,139(s1)
40f02c28:	00869693          	slli	a3,a3,0x8
40f02c2c:	00c6e6b3          	or	a3,a3,a2
40f02c30:	01071713          	slli	a4,a4,0x10
40f02c34:	00d76733          	or	a4,a4,a3
40f02c38:	01879793          	slli	a5,a5,0x18
40f02c3c:	00e7e7b3          	or	a5,a5,a4
40f02c40:	f7f7f713          	andi	a4,a5,-129
	regs->mstatusH |= (next_virt) ? MSTATUSH_MPV : 0UL;
40f02c44:	00875613          	srli	a2,a4,0x8
40f02c48:	01075693          	srli	a3,a4,0x10
40f02c4c:	07f7f793          	andi	a5,a5,127
40f02c50:	01875713          	srli	a4,a4,0x18
40f02c54:	08f48423          	sb	a5,136(s1)
40f02c58:	08c484a3          	sb	a2,137(s1)
40f02c5c:	08d48523          	sb	a3,138(s1)
40f02c60:	08e485a3          	sb	a4,139(s1)
	regs->mstatus &= ~MSTATUS_MPV;
	regs->mstatus |= (next_virt) ? MSTATUS_MPV : 0UL;
#endif

	/* Update HSTATUS for VS/VU-mode to HS-mode transition */
	if (misa_extension('H') && prev_virt && !next_virt) {
40f02c64:	04800513          	li	a0,72
40f02c68:	36c010ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f02c6c:	30051c63          	bnez	a0,40f02f84 <sbi_trap_redirect+0x3e0>

		/* Update VS-mode SSTATUS CSR */
		csr_write(CSR_VSSTATUS, vsstatus);
	} else {
		/* Update S-mode exception info */
		csr_write(CSR_STVAL, trap->tval);
40f02c70:	0089a783          	lw	a5,8(s3)
40f02c74:	14379073          	csrw	stval,a5
		csr_write(CSR_SEPC, trap->epc);
40f02c78:	0009a783          	lw	a5,0(s3)
40f02c7c:	14179073          	csrw	sepc,a5
		csr_write(CSR_SCAUSE, trap->cause);
40f02c80:	0049a783          	lw	a5,4(s3)
40f02c84:	14279073          	csrw	scause,a5

		/* Set MEPC to S-mode exception vector base */
		regs->mepc = csr_read(CSR_STVEC);
40f02c88:	10502673          	csrr	a2,stvec

		/* Set MPP to S-mode */
		regs->mstatus &= ~MSTATUS_MPP;
40f02c8c:	0854c683          	lbu	a3,133(s1)
40f02c90:	0844c583          	lbu	a1,132(s1)
40f02c94:	0864c703          	lbu	a4,134(s1)
40f02c98:	0874c783          	lbu	a5,135(s1)
40f02c9c:	00869693          	slli	a3,a3,0x8
40f02ca0:	00b6e6b3          	or	a3,a3,a1
40f02ca4:	01071713          	slli	a4,a4,0x10
40f02ca8:	00d76733          	or	a4,a4,a3
40f02cac:	01879793          	slli	a5,a5,0x18
40f02cb0:	00e7e7b3          	or	a5,a5,a4
		regs->mepc = csr_read(CSR_STVEC);
40f02cb4:	00865813          	srli	a6,a2,0x8
40f02cb8:	01065513          	srli	a0,a2,0x10
40f02cbc:	01865593          	srli	a1,a2,0x18
40f02cc0:	ffffe737          	lui	a4,0xffffe
40f02cc4:	6ff70713          	addi	a4,a4,1791 # ffffe6ff <_fw_end+0xbf0f16ff>
40f02cc8:	08c48023          	sb	a2,128(s1)
40f02ccc:	090480a3          	sb	a6,129(s1)
40f02cd0:	08a48123          	sb	a0,130(s1)
40f02cd4:	08b481a3          	sb	a1,131(s1)
		regs->mstatus |= (PRV_S << MSTATUS_MPP_SHIFT);

		/* Set SPP for S-mode*/
		regs->mstatus &= ~MSTATUS_SPP;
		if (prev_mode == PRV_S)
40f02cd8:	00100693          	li	a3,1
40f02cdc:	00e7f7b3          	and	a5,a5,a4
			regs->mstatus |= (1UL << MSTATUS_SPP_SHIFT);
40f02ce0:	00001737          	lui	a4,0x1
		if (prev_mode == PRV_S)
40f02ce4:	28d90c63          	beq	s2,a3,40f02f7c <sbi_trap_redirect+0x3d8>
		regs->mstatus &= ~MSTATUS_SPP;
40f02ce8:	80070713          	addi	a4,a4,-2048 # 800 <_fw_start-0x40eff800>
			regs->mstatus |= (1UL << MSTATUS_SPP_SHIFT);
40f02cec:	00e7e7b3          	or	a5,a5,a4
40f02cf0:	0187d713          	srli	a4,a5,0x18
40f02cf4:	0087d613          	srli	a2,a5,0x8
40f02cf8:	0107d693          	srli	a3,a5,0x10
40f02cfc:	08f48223          	sb	a5,132(s1)
40f02d00:	08e483a3          	sb	a4,135(s1)
40f02d04:	08c482a3          	sb	a2,133(s1)

		/* Set SPIE for S-mode */
		regs->mstatus &= ~MSTATUS_SPIE;
		if (regs->mstatus & MSTATUS_SIE)
40f02d08:	0027f713          	andi	a4,a5,2
			regs->mstatus |= (1UL << MSTATUS_SPP_SHIFT);
40f02d0c:	08d48323          	sb	a3,134(s1)
		regs->mstatus &= ~MSTATUS_SPIE;
40f02d10:	fdf7f793          	andi	a5,a5,-33
		if (regs->mstatus & MSTATUS_SIE)
40f02d14:	00070463          	beqz	a4,40f02d1c <sbi_trap_redirect+0x178>
			regs->mstatus |= (1UL << MSTATUS_SPIE_SHIFT);
40f02d18:	0207e793          	ori	a5,a5,32

		/* Clear SIE for S-mode */
		regs->mstatus &= ~MSTATUS_SIE;
40f02d1c:	ffd7f713          	andi	a4,a5,-3
40f02d20:	00875613          	srli	a2,a4,0x8
40f02d24:	01075693          	srli	a3,a4,0x10
40f02d28:	0fd7f793          	andi	a5,a5,253
40f02d2c:	01875713          	srli	a4,a4,0x18
40f02d30:	08f48223          	sb	a5,132(s1)
40f02d34:	08c482a3          	sb	a2,133(s1)
40f02d38:	08d48323          	sb	a3,134(s1)
40f02d3c:	08e483a3          	sb	a4,135(s1)
	}

	return 0;
40f02d40:	00000513          	li	a0,0
}
40f02d44:	01c12083          	lw	ra,28(sp)
40f02d48:	01812403          	lw	s0,24(sp)
40f02d4c:	01412483          	lw	s1,20(sp)
40f02d50:	01012903          	lw	s2,16(sp)
40f02d54:	00c12983          	lw	s3,12(sp)
40f02d58:	00812a03          	lw	s4,8(sp)
40f02d5c:	02010113          	addi	sp,sp,32
40f02d60:	00008067          	ret
40f02d64:	08a4c783          	lbu	a5,138(s1)
40f02d68:	08b4c703          	lbu	a4,139(s1)
40f02d6c:	00869693          	slli	a3,a3,0x8
40f02d70:	00c6e6b3          	or	a3,a3,a2
40f02d74:	01079793          	slli	a5,a5,0x10
40f02d78:	00d7e7b3          	or	a5,a5,a3
40f02d7c:	01871713          	slli	a4,a4,0x18
40f02d80:	00f76733          	or	a4,a4,a5
40f02d84:	f7f77793          	andi	a5,a4,-129
	if (misa_extension('H') && prev_virt) {
40f02d88:	040a0a63          	beqz	s4,40f02ddc <sbi_trap_redirect+0x238>
		switch (trap->cause) {
40f02d8c:	0049a683          	lw	a3,4(s3)
40f02d90:	00300613          	li	a2,3
40f02d94:	ff468693          	addi	a3,a3,-12
40f02d98:	06d66863          	bltu	a2,a3,40f02e08 <sbi_trap_redirect+0x264>
40f02d9c:	00100a13          	li	s4,1
40f02da0:	00da16b3          	sll	a3,s4,a3
40f02da4:	00b6f693          	andi	a3,a3,11
40f02da8:	0c069663          	bnez	a3,40f02e74 <sbi_trap_redirect+0x2d0>
	regs->mstatusH |= (next_virt) ? MSTATUSH_MPV : 0UL;
40f02dac:	0087d613          	srli	a2,a5,0x8
40f02db0:	0107d693          	srli	a3,a5,0x10
40f02db4:	07f77713          	andi	a4,a4,127
40f02db8:	0187d793          	srli	a5,a5,0x18
40f02dbc:	08e48423          	sb	a4,136(s1)
40f02dc0:	08c484a3          	sb	a2,137(s1)
40f02dc4:	08d48523          	sb	a3,138(s1)
40f02dc8:	08f485a3          	sb	a5,139(s1)
	if (misa_extension('H') && prev_virt && !next_virt) {
40f02dcc:	04800513          	li	a0,72
40f02dd0:	204010ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f02dd4:	e8050ee3          	beqz	a0,40f02c70 <sbi_trap_redirect+0xcc>
40f02dd8:	05c0006f          	j	40f02e34 <sbi_trap_redirect+0x290>
	regs->mstatusH |= (next_virt) ? MSTATUSH_MPV : 0UL;
40f02ddc:	0087d613          	srli	a2,a5,0x8
40f02de0:	0107d693          	srli	a3,a5,0x10
40f02de4:	07f77713          	andi	a4,a4,127
40f02de8:	0187d793          	srli	a5,a5,0x18
40f02dec:	08e48423          	sb	a4,136(s1)
40f02df0:	08c484a3          	sb	a2,137(s1)
40f02df4:	08d48523          	sb	a3,138(s1)
40f02df8:	08f485a3          	sb	a5,139(s1)
	if (misa_extension('H') && prev_virt && !next_virt) {
40f02dfc:	04800513          	li	a0,72
40f02e00:	1d4010ef          	jal	ra,40f03fd4 <misa_extension_imp>
	if (next_virt) {
40f02e04:	e6dff06f          	j	40f02c70 <sbi_trap_redirect+0xcc>
	regs->mstatusH |= (next_virt) ? MSTATUSH_MPV : 0UL;
40f02e08:	0087d613          	srli	a2,a5,0x8
40f02e0c:	0107d693          	srli	a3,a5,0x10
40f02e10:	07f77713          	andi	a4,a4,127
40f02e14:	0187d793          	srli	a5,a5,0x18
40f02e18:	08e48423          	sb	a4,136(s1)
40f02e1c:	08c484a3          	sb	a2,137(s1)
40f02e20:	08d48523          	sb	a3,138(s1)
40f02e24:	08f485a3          	sb	a5,139(s1)
	if (misa_extension('H') && prev_virt && !next_virt) {
40f02e28:	04800513          	li	a0,72
40f02e2c:	1a8010ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f02e30:	e40500e3          	beqz	a0,40f02c70 <sbi_trap_redirect+0xcc>
		hstatus = csr_read(CSR_HSTATUS);
40f02e34:	600027f3          	csrr	a5,0x600
		hstatus |= (regs->mstatus & MSTATUS_SPP) ? HSTATUS_SP2P : 0;
40f02e38:	0854c703          	lbu	a4,133(s1)
40f02e3c:	cff7f793          	andi	a5,a5,-769
40f02e40:	00871713          	slli	a4,a4,0x8
40f02e44:	10077713          	andi	a4,a4,256
		hstatus &= ~HSTATUS_SP2V;
40f02e48:	00e7e733          	or	a4,a5,a4
		hstatus |= (hstatus & HSTATUS_SPV) ? HSTATUS_SP2V : 0;
40f02e4c:	00271793          	slli	a5,a4,0x2
40f02e50:	2007f793          	andi	a5,a5,512
40f02e54:	00e7e7b3          	or	a5,a5,a4
		hstatus |= (prev_virt) ? HSTATUS_SPV : 0;
40f02e58:	0807e793          	ori	a5,a5,128
		csr_write(CSR_HSTATUS, hstatus);
40f02e5c:	60079073          	csrw	0x600,a5
		csr_write(CSR_HTVAL, trap->tval2);
40f02e60:	00c9a783          	lw	a5,12(s3)
40f02e64:	64379073          	csrw	0x643,a5
		csr_write(CSR_HTINST, trap->tinst);
40f02e68:	0109a783          	lw	a5,16(s3)
40f02e6c:	64a79073          	csrw	0x64a,a5
	if (next_virt) {
40f02e70:	e01ff06f          	j	40f02c70 <sbi_trap_redirect+0xcc>
	regs->mstatusH |= (next_virt) ? MSTATUSH_MPV : 0UL;
40f02e74:	0807e793          	ori	a5,a5,128
40f02e78:	0087d613          	srli	a2,a5,0x8
40f02e7c:	0107d693          	srli	a3,a5,0x10
40f02e80:	0187d713          	srli	a4,a5,0x18
40f02e84:	08f48423          	sb	a5,136(s1)
40f02e88:	08c484a3          	sb	a2,137(s1)
40f02e8c:	08d48523          	sb	a3,138(s1)
40f02e90:	08e485a3          	sb	a4,139(s1)
	if (misa_extension('H') && prev_virt && !next_virt) {
40f02e94:	04800513          	li	a0,72
40f02e98:	13c010ef          	jal	ra,40f03fd4 <misa_extension_imp>
		csr_write(CSR_VSTVAL, trap->tval);
40f02e9c:	0089a783          	lw	a5,8(s3)
40f02ea0:	24379073          	csrw	hbadaddr,a5
		csr_write(CSR_VSEPC, trap->epc);
40f02ea4:	0009a783          	lw	a5,0(s3)
40f02ea8:	24179073          	csrw	hepc,a5
		csr_write(CSR_VSCAUSE, trap->cause);
40f02eac:	0049a783          	lw	a5,4(s3)
40f02eb0:	24279073          	csrw	hcause,a5
		regs->mepc = csr_read(CSR_VSTVEC);
40f02eb4:	20502673          	csrr	a2,htvec
		regs->mstatus &= ~MSTATUS_MPP;
40f02eb8:	0854c683          	lbu	a3,133(s1)
40f02ebc:	0844c583          	lbu	a1,132(s1)
40f02ec0:	0864c703          	lbu	a4,134(s1)
40f02ec4:	0874c783          	lbu	a5,135(s1)
40f02ec8:	00869693          	slli	a3,a3,0x8
40f02ecc:	00b6e6b3          	or	a3,a3,a1
40f02ed0:	01071713          	slli	a4,a4,0x10
40f02ed4:	00d76733          	or	a4,a4,a3
40f02ed8:	01879793          	slli	a5,a5,0x18
40f02edc:	00e7e7b3          	or	a5,a5,a4
40f02ee0:	ffffe737          	lui	a4,0xffffe
40f02ee4:	7ff70713          	addi	a4,a4,2047 # ffffe7ff <_fw_end+0xbf0f17ff>
40f02ee8:	00e7f7b3          	and	a5,a5,a4
		regs->mstatus |= (PRV_S << MSTATUS_MPP_SHIFT);
40f02eec:	00001737          	lui	a4,0x1
40f02ef0:	80070713          	addi	a4,a4,-2048 # 800 <_fw_start-0x40eff800>
40f02ef4:	00e7e7b3          	or	a5,a5,a4
		regs->mepc = csr_read(CSR_VSTVEC);
40f02ef8:	00865893          	srli	a7,a2,0x8
40f02efc:	01065813          	srli	a6,a2,0x10
40f02f00:	01865513          	srli	a0,a2,0x18
		regs->mstatus |= (PRV_S << MSTATUS_MPP_SHIFT);
40f02f04:	0087d593          	srli	a1,a5,0x8
40f02f08:	0107d693          	srli	a3,a5,0x10
40f02f0c:	0187d713          	srli	a4,a5,0x18
		regs->mepc = csr_read(CSR_VSTVEC);
40f02f10:	08c48023          	sb	a2,128(s1)
40f02f14:	091480a3          	sb	a7,129(s1)
40f02f18:	09048123          	sb	a6,130(s1)
40f02f1c:	08a481a3          	sb	a0,131(s1)
		regs->mstatus |= (PRV_S << MSTATUS_MPP_SHIFT);
40f02f20:	08f48223          	sb	a5,132(s1)
40f02f24:	08b482a3          	sb	a1,133(s1)
40f02f28:	08d48323          	sb	a3,134(s1)
40f02f2c:	08e483a3          	sb	a4,135(s1)
		vsstatus = csr_read(CSR_VSSTATUS);
40f02f30:	200027f3          	csrr	a5,hstatus
		vsstatus &= ~SSTATUS_SPP;
40f02f34:	eff7f793          	andi	a5,a5,-257
		if (prev_mode == PRV_S)
40f02f38:	01491463          	bne	s2,s4,40f02f40 <sbi_trap_redirect+0x39c>
			vsstatus |= (1UL << SSTATUS_SPP_SHIFT);
40f02f3c:	1007e793          	ori	a5,a5,256
		if (vsstatus & SSTATUS_SIE)
40f02f40:	0027f713          	andi	a4,a5,2
		vsstatus &= ~SSTATUS_SPIE;
40f02f44:	fdf7f793          	andi	a5,a5,-33
		if (vsstatus & SSTATUS_SIE)
40f02f48:	00070463          	beqz	a4,40f02f50 <sbi_trap_redirect+0x3ac>
			vsstatus |= (1UL << SSTATUS_SPIE_SHIFT);
40f02f4c:	0207e793          	ori	a5,a5,32
		vsstatus &= ~SSTATUS_SIE;
40f02f50:	ffd7f793          	andi	a5,a5,-3
		csr_write(CSR_VSSTATUS, vsstatus);
40f02f54:	20079073          	csrw	hstatus,a5
}
40f02f58:	01c12083          	lw	ra,28(sp)
40f02f5c:	01812403          	lw	s0,24(sp)
40f02f60:	01412483          	lw	s1,20(sp)
40f02f64:	01012903          	lw	s2,16(sp)
40f02f68:	00c12983          	lw	s3,12(sp)
40f02f6c:	00812a03          	lw	s4,8(sp)
	return 0;
40f02f70:	00000513          	li	a0,0
}
40f02f74:	02010113          	addi	sp,sp,32
40f02f78:	00008067          	ret
			regs->mstatus |= (1UL << MSTATUS_SPP_SHIFT);
40f02f7c:	90070713          	addi	a4,a4,-1792
40f02f80:	d6dff06f          	j	40f02cec <sbi_trap_redirect+0x148>
	if (misa_extension('H') && prev_virt && !next_virt) {
40f02f84:	ea0a18e3          	bnez	s4,40f02e34 <sbi_trap_redirect+0x290>
40f02f88:	ce9ff06f          	j	40f02c70 <sbi_trap_redirect+0xcc>
		return SBI_ENOTSUPP;
40f02f8c:	ffe00513          	li	a0,-2
40f02f90:	db5ff06f          	j	40f02d44 <sbi_trap_redirect+0x1a0>

40f02f94 <sbi_trap_handler>:
 * @param regs pointer to register state
 * @param scratch pointer to sbi_scratch of current HART
 */
void sbi_trap_handler(struct sbi_trap_regs *regs,
		      struct sbi_scratch *scratch)
{
40f02f94:	fb010113          	addi	sp,sp,-80
40f02f98:	04812423          	sw	s0,72(sp)
40f02f9c:	03312e23          	sw	s3,60(sp)
40f02fa0:	03712623          	sw	s7,44(sp)
40f02fa4:	03812423          	sw	s8,40(sp)
40f02fa8:	04112623          	sw	ra,76(sp)
40f02fac:	04912223          	sw	s1,68(sp)
40f02fb0:	05212023          	sw	s2,64(sp)
40f02fb4:	03412c23          	sw	s4,56(sp)
40f02fb8:	03512a23          	sw	s5,52(sp)
40f02fbc:	03612823          	sw	s6,48(sp)
40f02fc0:	05010413          	addi	s0,sp,80
40f02fc4:	00050993          	mv	s3,a0
40f02fc8:	00058c13          	mv	s8,a1
	int rc = SBI_ENOTSUPP;
	const char *msg = "trap handler failed";
	u32 hartid = sbi_current_hartid();
40f02fcc:	2ed030ef          	jal	ra,40f06ab8 <sbi_current_hartid>
40f02fd0:	00050b93          	mv	s7,a0
	ulong mcause = csr_read(CSR_MCAUSE);
40f02fd4:	342024f3          	csrr	s1,mcause
40f02fd8:	00048913          	mv	s2,s1
	ulong mtval = csr_read(CSR_MTVAL), mtval2 = 0, mtinst = 0;
40f02fdc:	34302b73          	csrr	s6,mtval
	struct sbi_trap_info trap, *uptrap;

	if (misa_extension('H')) {
40f02fe0:	04800513          	li	a0,72
40f02fe4:	7f1000ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f02fe8:	02050a63          	beqz	a0,40f0301c <sbi_trap_handler+0x88>
		mtval2 = csr_read(CSR_MTVAL2);
40f02fec:	34b02a73          	csrr	s4,0x34b
		mtinst = csr_read(CSR_MTINST);
40f02ff0:	34a02af3          	csrr	s5,0x34a
	}

	if (mcause & (1UL << (__riscv_xlen - 1))) {
40f02ff4:	0204ca63          	bltz	s1,40f03028 <sbi_trap_handler+0x94>
			goto trap_error;
		};
		return;
	}

	switch (mcause) {
40f02ff8:	00f00793          	li	a5,15
40f02ffc:	1a97ece3          	bltu	a5,s1,40f039b4 <sbi_trap_handler+0xa20>
40f03000:	00007697          	auipc	a3,0x7
40f03004:	30068693          	addi	a3,a3,768 # 40f0a300 <__modsi3+0x924>
40f03008:	00249713          	slli	a4,s1,0x2
40f0300c:	00d70733          	add	a4,a4,a3
40f03010:	00072783          	lw	a5,0(a4)
40f03014:	00d787b3          	add	a5,a5,a3
40f03018:	00078067          	jr	a5
	ulong mtval = csr_read(CSR_MTVAL), mtval2 = 0, mtinst = 0;
40f0301c:	00000a93          	li	s5,0
40f03020:	00000a13          	li	s4,0
	if (mcause & (1UL << (__riscv_xlen - 1))) {
40f03024:	fc04dae3          	bgez	s1,40f02ff8 <sbi_trap_handler+0x64>
		mcause &= ~(1UL << (__riscv_xlen - 1));
40f03028:	00149913          	slli	s2,s1,0x1
40f0302c:	00195913          	srli	s2,s2,0x1
		switch (mcause) {
40f03030:	00300793          	li	a5,3
40f03034:	22f908e3          	beq	s2,a5,40f03a64 <sbi_trap_handler+0xad0>
40f03038:	00700793          	li	a5,7
40f0303c:	02f91e63          	bne	s2,a5,40f03078 <sbi_trap_handler+0xe4>
			sbi_timer_process(scratch);
40f03040:	000c0513          	mv	a0,s8
40f03044:	854ff0ef          	jal	ra,40f02098 <sbi_timer_process>
trap_error:
	if (rc) {
		sbi_trap_error(msg, rc, hartid, mcause, mtval,
			       mtval2, mtinst, regs);
	}
}
40f03048:	04c12083          	lw	ra,76(sp)
40f0304c:	04812403          	lw	s0,72(sp)
40f03050:	04412483          	lw	s1,68(sp)
40f03054:	04012903          	lw	s2,64(sp)
40f03058:	03c12983          	lw	s3,60(sp)
40f0305c:	03812a03          	lw	s4,56(sp)
40f03060:	03412a83          	lw	s5,52(sp)
40f03064:	03012b03          	lw	s6,48(sp)
40f03068:	02c12b83          	lw	s7,44(sp)
40f0306c:	02812c03          	lw	s8,40(sp)
40f03070:	05010113          	addi	sp,sp,80
40f03074:	00008067          	ret
			msg = "unhandled external interrupt";
40f03078:	00007697          	auipc	a3,0x7
40f0307c:	38c68693          	addi	a3,a3,908 # 40f0a404 <__func__.1282+0xc4>
	int rc = SBI_ENOTSUPP;
40f03080:	ffe00513          	li	a0,-2
	sbi_printf("%s: hart%d: %s (error %d)\n", __func__, hartid, msg, rc);
40f03084:	00050713          	mv	a4,a0
40f03088:	00007597          	auipc	a1,0x7
40f0308c:	2b858593          	addi	a1,a1,696 # 40f0a340 <__func__.1282>
40f03090:	000b8613          	mv	a2,s7
40f03094:	00007517          	auipc	a0,0x7
40f03098:	39050513          	addi	a0,a0,912 # 40f0a424 <__func__.1282+0xe4>
40f0309c:	560020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: mcause=0x%" PRILX " mtval=0x%" PRILX "\n",
40f030a0:	000b0713          	mv	a4,s6
40f030a4:	00090693          	mv	a3,s2
40f030a8:	000b8613          	mv	a2,s7
40f030ac:	00007597          	auipc	a1,0x7
40f030b0:	29458593          	addi	a1,a1,660 # 40f0a340 <__func__.1282>
40f030b4:	00007517          	auipc	a0,0x7
40f030b8:	38c50513          	addi	a0,a0,908 # 40f0a440 <__func__.1282+0x100>
40f030bc:	540020ef          	jal	ra,40f055fc <sbi_printf>
	if (misa_extension('H')) {
40f030c0:	04800513          	li	a0,72
40f030c4:	711000ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f030c8:	1a0514e3          	bnez	a0,40f03a70 <sbi_trap_handler+0xadc>
	sbi_printf("%s: hart%d: mepc=0x%" PRILX " mstatus=0x%" PRILX "\n",
40f030cc:	0859c603          	lbu	a2,133(s3)
40f030d0:	0819c683          	lbu	a3,129(s3)
40f030d4:	0849c883          	lbu	a7,132(s3)
40f030d8:	0809c803          	lbu	a6,128(s3)
40f030dc:	0869c703          	lbu	a4,134(s3)
40f030e0:	0829c783          	lbu	a5,130(s3)
40f030e4:	0839c583          	lbu	a1,131(s3)
40f030e8:	0879c503          	lbu	a0,135(s3)
40f030ec:	00861613          	slli	a2,a2,0x8
40f030f0:	00869693          	slli	a3,a3,0x8
40f030f4:	01166633          	or	a2,a2,a7
40f030f8:	0106e6b3          	or	a3,a3,a6
40f030fc:	01071713          	slli	a4,a4,0x10
40f03100:	01079793          	slli	a5,a5,0x10
40f03104:	00d7e7b3          	or	a5,a5,a3
40f03108:	00c76733          	or	a4,a4,a2
40f0310c:	01851513          	slli	a0,a0,0x18
40f03110:	01859693          	slli	a3,a1,0x18
40f03114:	00e56733          	or	a4,a0,a4
40f03118:	00f6e6b3          	or	a3,a3,a5
40f0311c:	000b8613          	mv	a2,s7
40f03120:	00007597          	auipc	a1,0x7
40f03124:	22058593          	addi	a1,a1,544 # 40f0a340 <__func__.1282>
40f03128:	00007517          	auipc	a0,0x7
40f0312c:	37050513          	addi	a0,a0,880 # 40f0a498 <__func__.1282+0x158>
40f03130:	4cc020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f03134:	0099c603          	lbu	a2,9(s3)
40f03138:	0059c683          	lbu	a3,5(s3)
40f0313c:	0089c883          	lbu	a7,8(s3)
40f03140:	0049c503          	lbu	a0,4(s3)
40f03144:	00a9c783          	lbu	a5,10(s3)
40f03148:	0069c703          	lbu	a4,6(s3)
40f0314c:	00b9c803          	lbu	a6,11(s3)
40f03150:	0079c583          	lbu	a1,7(s3)
40f03154:	00861613          	slli	a2,a2,0x8
40f03158:	00869693          	slli	a3,a3,0x8
40f0315c:	01166633          	or	a2,a2,a7
40f03160:	00a6e6b3          	or	a3,a3,a0
40f03164:	01079793          	slli	a5,a5,0x10
40f03168:	01071713          	slli	a4,a4,0x10
40f0316c:	00c7e7b3          	or	a5,a5,a2
40f03170:	00d76733          	or	a4,a4,a3
40f03174:	01859593          	slli	a1,a1,0x18
40f03178:	01881813          	slli	a6,a6,0x18
40f0317c:	00f86833          	or	a6,a6,a5
40f03180:	00e5e733          	or	a4,a1,a4
40f03184:	00007797          	auipc	a5,0x7
40f03188:	34078793          	addi	a5,a5,832 # 40f0a4c4 <__func__.1282+0x184>
40f0318c:	00007697          	auipc	a3,0x7
40f03190:	33c68693          	addi	a3,a3,828 # 40f0a4c8 <__func__.1282+0x188>
40f03194:	000b8613          	mv	a2,s7
40f03198:	00007597          	auipc	a1,0x7
40f0319c:	1a858593          	addi	a1,a1,424 # 40f0a340 <__func__.1282>
40f031a0:	00007517          	auipc	a0,0x7
40f031a4:	32c50513          	addi	a0,a0,812 # 40f0a4cc <__func__.1282+0x18c>
40f031a8:	454020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f031ac:	0119c603          	lbu	a2,17(s3)
40f031b0:	00d9c683          	lbu	a3,13(s3)
40f031b4:	0109c883          	lbu	a7,16(s3)
40f031b8:	00c9c503          	lbu	a0,12(s3)
40f031bc:	0129c783          	lbu	a5,18(s3)
40f031c0:	00e9c703          	lbu	a4,14(s3)
40f031c4:	0139c803          	lbu	a6,19(s3)
40f031c8:	00f9c583          	lbu	a1,15(s3)
40f031cc:	00861613          	slli	a2,a2,0x8
40f031d0:	00869693          	slli	a3,a3,0x8
40f031d4:	01166633          	or	a2,a2,a7
40f031d8:	00a6e6b3          	or	a3,a3,a0
40f031dc:	01079793          	slli	a5,a5,0x10
40f031e0:	01071713          	slli	a4,a4,0x10
40f031e4:	00c7e7b3          	or	a5,a5,a2
40f031e8:	00d76733          	or	a4,a4,a3
40f031ec:	01859593          	slli	a1,a1,0x18
40f031f0:	01881813          	slli	a6,a6,0x18
40f031f4:	00f86833          	or	a6,a6,a5
40f031f8:	00e5e733          	or	a4,a1,a4
40f031fc:	00007797          	auipc	a5,0x7
40f03200:	2f478793          	addi	a5,a5,756 # 40f0a4f0 <__func__.1282+0x1b0>
40f03204:	00007697          	auipc	a3,0x7
40f03208:	2f068693          	addi	a3,a3,752 # 40f0a4f4 <__func__.1282+0x1b4>
40f0320c:	000b8613          	mv	a2,s7
40f03210:	00007597          	auipc	a1,0x7
40f03214:	13058593          	addi	a1,a1,304 # 40f0a340 <__func__.1282>
40f03218:	00007517          	auipc	a0,0x7
40f0321c:	2b450513          	addi	a0,a0,692 # 40f0a4cc <__func__.1282+0x18c>
40f03220:	3dc020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f03224:	0259c603          	lbu	a2,37(s3)
40f03228:	0219c683          	lbu	a3,33(s3)
40f0322c:	0249c883          	lbu	a7,36(s3)
40f03230:	0209c503          	lbu	a0,32(s3)
40f03234:	0269c783          	lbu	a5,38(s3)
40f03238:	0229c703          	lbu	a4,34(s3)
40f0323c:	0279c803          	lbu	a6,39(s3)
40f03240:	0239c583          	lbu	a1,35(s3)
40f03244:	00861613          	slli	a2,a2,0x8
40f03248:	00869693          	slli	a3,a3,0x8
40f0324c:	01166633          	or	a2,a2,a7
40f03250:	00a6e6b3          	or	a3,a3,a0
40f03254:	01079793          	slli	a5,a5,0x10
40f03258:	01071713          	slli	a4,a4,0x10
40f0325c:	00c7e7b3          	or	a5,a5,a2
40f03260:	00d76733          	or	a4,a4,a3
40f03264:	01859593          	slli	a1,a1,0x18
40f03268:	01881813          	slli	a6,a6,0x18
40f0326c:	00f86833          	or	a6,a6,a5
40f03270:	00e5e733          	or	a4,a1,a4
40f03274:	00007797          	auipc	a5,0x7
40f03278:	28478793          	addi	a5,a5,644 # 40f0a4f8 <__func__.1282+0x1b8>
40f0327c:	00007697          	auipc	a3,0x7
40f03280:	28068693          	addi	a3,a3,640 # 40f0a4fc <__func__.1282+0x1bc>
40f03284:	000b8613          	mv	a2,s7
40f03288:	00007597          	auipc	a1,0x7
40f0328c:	0b858593          	addi	a1,a1,184 # 40f0a340 <__func__.1282>
40f03290:	00007517          	auipc	a0,0x7
40f03294:	23c50513          	addi	a0,a0,572 # 40f0a4cc <__func__.1282+0x18c>
40f03298:	364020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f0329c:	02d9c603          	lbu	a2,45(s3)
40f032a0:	0299c683          	lbu	a3,41(s3)
40f032a4:	02c9c883          	lbu	a7,44(s3)
40f032a8:	0289c503          	lbu	a0,40(s3)
40f032ac:	02e9c783          	lbu	a5,46(s3)
40f032b0:	02a9c703          	lbu	a4,42(s3)
40f032b4:	02f9c803          	lbu	a6,47(s3)
40f032b8:	02b9c583          	lbu	a1,43(s3)
40f032bc:	00861613          	slli	a2,a2,0x8
40f032c0:	00869693          	slli	a3,a3,0x8
40f032c4:	01166633          	or	a2,a2,a7
40f032c8:	00a6e6b3          	or	a3,a3,a0
40f032cc:	01079793          	slli	a5,a5,0x10
40f032d0:	01071713          	slli	a4,a4,0x10
40f032d4:	00c7e7b3          	or	a5,a5,a2
40f032d8:	00d76733          	or	a4,a4,a3
40f032dc:	01859593          	slli	a1,a1,0x18
40f032e0:	01881813          	slli	a6,a6,0x18
40f032e4:	00f86833          	or	a6,a6,a5
40f032e8:	00e5e733          	or	a4,a1,a4
40f032ec:	00007797          	auipc	a5,0x7
40f032f0:	21478793          	addi	a5,a5,532 # 40f0a500 <__func__.1282+0x1c0>
40f032f4:	00007697          	auipc	a3,0x7
40f032f8:	21068693          	addi	a3,a3,528 # 40f0a504 <__func__.1282+0x1c4>
40f032fc:	000b8613          	mv	a2,s7
40f03300:	00007597          	auipc	a1,0x7
40f03304:	04058593          	addi	a1,a1,64 # 40f0a340 <__func__.1282>
40f03308:	00007517          	auipc	a0,0x7
40f0330c:	1c450513          	addi	a0,a0,452 # 40f0a4cc <__func__.1282+0x18c>
40f03310:	2ec020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f03314:	0359c603          	lbu	a2,53(s3)
40f03318:	0319c683          	lbu	a3,49(s3)
40f0331c:	0349c883          	lbu	a7,52(s3)
40f03320:	0309c503          	lbu	a0,48(s3)
40f03324:	0369c783          	lbu	a5,54(s3)
40f03328:	0329c703          	lbu	a4,50(s3)
40f0332c:	0379c803          	lbu	a6,55(s3)
40f03330:	0339c583          	lbu	a1,51(s3)
40f03334:	00861613          	slli	a2,a2,0x8
40f03338:	00869693          	slli	a3,a3,0x8
40f0333c:	01166633          	or	a2,a2,a7
40f03340:	00a6e6b3          	or	a3,a3,a0
40f03344:	01079793          	slli	a5,a5,0x10
40f03348:	01071713          	slli	a4,a4,0x10
40f0334c:	00c7e7b3          	or	a5,a5,a2
40f03350:	00d76733          	or	a4,a4,a3
40f03354:	01859593          	slli	a1,a1,0x18
40f03358:	01881813          	slli	a6,a6,0x18
40f0335c:	00f86833          	or	a6,a6,a5
40f03360:	00e5e733          	or	a4,a1,a4
40f03364:	00007797          	auipc	a5,0x7
40f03368:	1a478793          	addi	a5,a5,420 # 40f0a508 <__func__.1282+0x1c8>
40f0336c:	00007697          	auipc	a3,0x7
40f03370:	1a068693          	addi	a3,a3,416 # 40f0a50c <__func__.1282+0x1cc>
40f03374:	000b8613          	mv	a2,s7
40f03378:	00007597          	auipc	a1,0x7
40f0337c:	fc858593          	addi	a1,a1,-56 # 40f0a340 <__func__.1282>
40f03380:	00007517          	auipc	a0,0x7
40f03384:	14c50513          	addi	a0,a0,332 # 40f0a4cc <__func__.1282+0x18c>
40f03388:	274020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f0338c:	03d9c603          	lbu	a2,61(s3)
40f03390:	0399c683          	lbu	a3,57(s3)
40f03394:	03c9c883          	lbu	a7,60(s3)
40f03398:	0389c503          	lbu	a0,56(s3)
40f0339c:	03e9c783          	lbu	a5,62(s3)
40f033a0:	03a9c703          	lbu	a4,58(s3)
40f033a4:	03f9c803          	lbu	a6,63(s3)
40f033a8:	03b9c583          	lbu	a1,59(s3)
40f033ac:	00861613          	slli	a2,a2,0x8
40f033b0:	00869693          	slli	a3,a3,0x8
40f033b4:	01166633          	or	a2,a2,a7
40f033b8:	00a6e6b3          	or	a3,a3,a0
40f033bc:	01079793          	slli	a5,a5,0x10
40f033c0:	01071713          	slli	a4,a4,0x10
40f033c4:	00c7e7b3          	or	a5,a5,a2
40f033c8:	00d76733          	or	a4,a4,a3
40f033cc:	01859593          	slli	a1,a1,0x18
40f033d0:	01881813          	slli	a6,a6,0x18
40f033d4:	00f86833          	or	a6,a6,a5
40f033d8:	00e5e733          	or	a4,a1,a4
40f033dc:	00007797          	auipc	a5,0x7
40f033e0:	13478793          	addi	a5,a5,308 # 40f0a510 <__func__.1282+0x1d0>
40f033e4:	00007697          	auipc	a3,0x7
40f033e8:	13068693          	addi	a3,a3,304 # 40f0a514 <__func__.1282+0x1d4>
40f033ec:	000b8613          	mv	a2,s7
40f033f0:	00007597          	auipc	a1,0x7
40f033f4:	f5058593          	addi	a1,a1,-176 # 40f0a340 <__func__.1282>
40f033f8:	00007517          	auipc	a0,0x7
40f033fc:	0d450513          	addi	a0,a0,212 # 40f0a4cc <__func__.1282+0x18c>
40f03400:	1fc020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f03404:	0459c603          	lbu	a2,69(s3)
40f03408:	0419c683          	lbu	a3,65(s3)
40f0340c:	0449c883          	lbu	a7,68(s3)
40f03410:	0409c503          	lbu	a0,64(s3)
40f03414:	0469c783          	lbu	a5,70(s3)
40f03418:	0429c703          	lbu	a4,66(s3)
40f0341c:	0479c803          	lbu	a6,71(s3)
40f03420:	0439c583          	lbu	a1,67(s3)
40f03424:	00861613          	slli	a2,a2,0x8
40f03428:	00869693          	slli	a3,a3,0x8
40f0342c:	01166633          	or	a2,a2,a7
40f03430:	00a6e6b3          	or	a3,a3,a0
40f03434:	01079793          	slli	a5,a5,0x10
40f03438:	01071713          	slli	a4,a4,0x10
40f0343c:	00c7e7b3          	or	a5,a5,a2
40f03440:	00d76733          	or	a4,a4,a3
40f03444:	01859593          	slli	a1,a1,0x18
40f03448:	01881813          	slli	a6,a6,0x18
40f0344c:	00f86833          	or	a6,a6,a5
40f03450:	00e5e733          	or	a4,a1,a4
40f03454:	00007797          	auipc	a5,0x7
40f03458:	0c478793          	addi	a5,a5,196 # 40f0a518 <__func__.1282+0x1d8>
40f0345c:	00007697          	auipc	a3,0x7
40f03460:	0c068693          	addi	a3,a3,192 # 40f0a51c <__func__.1282+0x1dc>
40f03464:	000b8613          	mv	a2,s7
40f03468:	00007597          	auipc	a1,0x7
40f0346c:	ed858593          	addi	a1,a1,-296 # 40f0a340 <__func__.1282>
40f03470:	00007517          	auipc	a0,0x7
40f03474:	05c50513          	addi	a0,a0,92 # 40f0a4cc <__func__.1282+0x18c>
40f03478:	184020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f0347c:	04d9c603          	lbu	a2,77(s3)
40f03480:	0499c683          	lbu	a3,73(s3)
40f03484:	04c9c883          	lbu	a7,76(s3)
40f03488:	0489c503          	lbu	a0,72(s3)
40f0348c:	04e9c783          	lbu	a5,78(s3)
40f03490:	04a9c703          	lbu	a4,74(s3)
40f03494:	04f9c803          	lbu	a6,79(s3)
40f03498:	04b9c583          	lbu	a1,75(s3)
40f0349c:	00861613          	slli	a2,a2,0x8
40f034a0:	00869693          	slli	a3,a3,0x8
40f034a4:	01166633          	or	a2,a2,a7
40f034a8:	00a6e6b3          	or	a3,a3,a0
40f034ac:	01079793          	slli	a5,a5,0x10
40f034b0:	01071713          	slli	a4,a4,0x10
40f034b4:	00c7e7b3          	or	a5,a5,a2
40f034b8:	00d76733          	or	a4,a4,a3
40f034bc:	01859593          	slli	a1,a1,0x18
40f034c0:	01881813          	slli	a6,a6,0x18
40f034c4:	00f86833          	or	a6,a6,a5
40f034c8:	00e5e733          	or	a4,a1,a4
40f034cc:	00007797          	auipc	a5,0x7
40f034d0:	05478793          	addi	a5,a5,84 # 40f0a520 <__func__.1282+0x1e0>
40f034d4:	00007697          	auipc	a3,0x7
40f034d8:	05068693          	addi	a3,a3,80 # 40f0a524 <__func__.1282+0x1e4>
40f034dc:	000b8613          	mv	a2,s7
40f034e0:	00007597          	auipc	a1,0x7
40f034e4:	e6058593          	addi	a1,a1,-416 # 40f0a340 <__func__.1282>
40f034e8:	00007517          	auipc	a0,0x7
40f034ec:	fe450513          	addi	a0,a0,-28 # 40f0a4cc <__func__.1282+0x18c>
40f034f0:	10c020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f034f4:	0559c603          	lbu	a2,85(s3)
40f034f8:	0519c683          	lbu	a3,81(s3)
40f034fc:	0549c883          	lbu	a7,84(s3)
40f03500:	0509c503          	lbu	a0,80(s3)
40f03504:	0569c783          	lbu	a5,86(s3)
40f03508:	0529c703          	lbu	a4,82(s3)
40f0350c:	0579c803          	lbu	a6,87(s3)
40f03510:	0539c583          	lbu	a1,83(s3)
40f03514:	00861613          	slli	a2,a2,0x8
40f03518:	00869693          	slli	a3,a3,0x8
40f0351c:	01166633          	or	a2,a2,a7
40f03520:	00a6e6b3          	or	a3,a3,a0
40f03524:	01079793          	slli	a5,a5,0x10
40f03528:	01071713          	slli	a4,a4,0x10
40f0352c:	00c7e7b3          	or	a5,a5,a2
40f03530:	00d76733          	or	a4,a4,a3
40f03534:	01859593          	slli	a1,a1,0x18
40f03538:	01881813          	slli	a6,a6,0x18
40f0353c:	00f86833          	or	a6,a6,a5
40f03540:	00e5e733          	or	a4,a1,a4
40f03544:	00007797          	auipc	a5,0x7
40f03548:	fe478793          	addi	a5,a5,-28 # 40f0a528 <__func__.1282+0x1e8>
40f0354c:	00007697          	auipc	a3,0x7
40f03550:	fe068693          	addi	a3,a3,-32 # 40f0a52c <__func__.1282+0x1ec>
40f03554:	000b8613          	mv	a2,s7
40f03558:	00007597          	auipc	a1,0x7
40f0355c:	de858593          	addi	a1,a1,-536 # 40f0a340 <__func__.1282>
40f03560:	00007517          	auipc	a0,0x7
40f03564:	f6c50513          	addi	a0,a0,-148 # 40f0a4cc <__func__.1282+0x18c>
40f03568:	094020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f0356c:	05d9c603          	lbu	a2,93(s3)
40f03570:	0599c683          	lbu	a3,89(s3)
40f03574:	05c9c883          	lbu	a7,92(s3)
40f03578:	0589c503          	lbu	a0,88(s3)
40f0357c:	05e9c783          	lbu	a5,94(s3)
40f03580:	05a9c703          	lbu	a4,90(s3)
40f03584:	05f9c803          	lbu	a6,95(s3)
40f03588:	05b9c583          	lbu	a1,91(s3)
40f0358c:	00861613          	slli	a2,a2,0x8
40f03590:	00869693          	slli	a3,a3,0x8
40f03594:	01166633          	or	a2,a2,a7
40f03598:	00a6e6b3          	or	a3,a3,a0
40f0359c:	01079793          	slli	a5,a5,0x10
40f035a0:	01071713          	slli	a4,a4,0x10
40f035a4:	00c7e7b3          	or	a5,a5,a2
40f035a8:	00d76733          	or	a4,a4,a3
40f035ac:	01859593          	slli	a1,a1,0x18
40f035b0:	01881813          	slli	a6,a6,0x18
40f035b4:	00f86833          	or	a6,a6,a5
40f035b8:	00e5e733          	or	a4,a1,a4
40f035bc:	00007797          	auipc	a5,0x7
40f035c0:	f7478793          	addi	a5,a5,-140 # 40f0a530 <__func__.1282+0x1f0>
40f035c4:	00007697          	auipc	a3,0x7
40f035c8:	f7068693          	addi	a3,a3,-144 # 40f0a534 <__func__.1282+0x1f4>
40f035cc:	000b8613          	mv	a2,s7
40f035d0:	00007597          	auipc	a1,0x7
40f035d4:	d7058593          	addi	a1,a1,-656 # 40f0a340 <__func__.1282>
40f035d8:	00007517          	auipc	a0,0x7
40f035dc:	ef450513          	addi	a0,a0,-268 # 40f0a4cc <__func__.1282+0x18c>
40f035e0:	01c020ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f035e4:	0659c603          	lbu	a2,101(s3)
40f035e8:	0619c683          	lbu	a3,97(s3)
40f035ec:	0649c883          	lbu	a7,100(s3)
40f035f0:	0609c503          	lbu	a0,96(s3)
40f035f4:	0669c783          	lbu	a5,102(s3)
40f035f8:	0629c703          	lbu	a4,98(s3)
40f035fc:	0679c803          	lbu	a6,103(s3)
40f03600:	0639c583          	lbu	a1,99(s3)
40f03604:	00861613          	slli	a2,a2,0x8
40f03608:	00869693          	slli	a3,a3,0x8
40f0360c:	01166633          	or	a2,a2,a7
40f03610:	00a6e6b3          	or	a3,a3,a0
40f03614:	01079793          	slli	a5,a5,0x10
40f03618:	01071713          	slli	a4,a4,0x10
40f0361c:	00c7e7b3          	or	a5,a5,a2
40f03620:	00d76733          	or	a4,a4,a3
40f03624:	01859593          	slli	a1,a1,0x18
40f03628:	01881813          	slli	a6,a6,0x18
40f0362c:	00f86833          	or	a6,a6,a5
40f03630:	00e5e733          	or	a4,a1,a4
40f03634:	00007797          	auipc	a5,0x7
40f03638:	f0478793          	addi	a5,a5,-252 # 40f0a538 <__func__.1282+0x1f8>
40f0363c:	00007697          	auipc	a3,0x7
40f03640:	f0068693          	addi	a3,a3,-256 # 40f0a53c <__func__.1282+0x1fc>
40f03644:	000b8613          	mv	a2,s7
40f03648:	00007597          	auipc	a1,0x7
40f0364c:	cf858593          	addi	a1,a1,-776 # 40f0a340 <__func__.1282>
40f03650:	00007517          	auipc	a0,0x7
40f03654:	e7c50513          	addi	a0,a0,-388 # 40f0a4cc <__func__.1282+0x18c>
40f03658:	7a5010ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f0365c:	06d9c603          	lbu	a2,109(s3)
40f03660:	0699c683          	lbu	a3,105(s3)
40f03664:	06c9c883          	lbu	a7,108(s3)
40f03668:	0689c503          	lbu	a0,104(s3)
40f0366c:	06e9c783          	lbu	a5,110(s3)
40f03670:	06a9c703          	lbu	a4,106(s3)
40f03674:	06f9c803          	lbu	a6,111(s3)
40f03678:	06b9c583          	lbu	a1,107(s3)
40f0367c:	00861613          	slli	a2,a2,0x8
40f03680:	00869693          	slli	a3,a3,0x8
40f03684:	01166633          	or	a2,a2,a7
40f03688:	00a6e6b3          	or	a3,a3,a0
40f0368c:	01079793          	slli	a5,a5,0x10
40f03690:	01071713          	slli	a4,a4,0x10
40f03694:	00c7e7b3          	or	a5,a5,a2
40f03698:	00d76733          	or	a4,a4,a3
40f0369c:	01859593          	slli	a1,a1,0x18
40f036a0:	01881813          	slli	a6,a6,0x18
40f036a4:	00f86833          	or	a6,a6,a5
40f036a8:	00e5e733          	or	a4,a1,a4
40f036ac:	00007797          	auipc	a5,0x7
40f036b0:	e9478793          	addi	a5,a5,-364 # 40f0a540 <__func__.1282+0x200>
40f036b4:	00007697          	auipc	a3,0x7
40f036b8:	e9068693          	addi	a3,a3,-368 # 40f0a544 <__func__.1282+0x204>
40f036bc:	000b8613          	mv	a2,s7
40f036c0:	00007597          	auipc	a1,0x7
40f036c4:	c8058593          	addi	a1,a1,-896 # 40f0a340 <__func__.1282>
40f036c8:	00007517          	auipc	a0,0x7
40f036cc:	e0450513          	addi	a0,a0,-508 # 40f0a4cc <__func__.1282+0x18c>
40f036d0:	72d010ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f036d4:	0199c603          	lbu	a2,25(s3)
40f036d8:	0159c683          	lbu	a3,21(s3)
40f036dc:	0189c883          	lbu	a7,24(s3)
40f036e0:	0149c503          	lbu	a0,20(s3)
40f036e4:	01a9c783          	lbu	a5,26(s3)
40f036e8:	0169c703          	lbu	a4,22(s3)
40f036ec:	01b9c803          	lbu	a6,27(s3)
40f036f0:	0179c583          	lbu	a1,23(s3)
40f036f4:	00861613          	slli	a2,a2,0x8
40f036f8:	00869693          	slli	a3,a3,0x8
40f036fc:	01166633          	or	a2,a2,a7
40f03700:	00a6e6b3          	or	a3,a3,a0
40f03704:	01079793          	slli	a5,a5,0x10
40f03708:	01071713          	slli	a4,a4,0x10
40f0370c:	00c7e7b3          	or	a5,a5,a2
40f03710:	00d76733          	or	a4,a4,a3
40f03714:	01859593          	slli	a1,a1,0x18
40f03718:	01881813          	slli	a6,a6,0x18
40f0371c:	00f86833          	or	a6,a6,a5
40f03720:	00e5e733          	or	a4,a1,a4
40f03724:	00007797          	auipc	a5,0x7
40f03728:	e2478793          	addi	a5,a5,-476 # 40f0a548 <__func__.1282+0x208>
40f0372c:	00007697          	auipc	a3,0x7
40f03730:	e2068693          	addi	a3,a3,-480 # 40f0a54c <__func__.1282+0x20c>
40f03734:	000b8613          	mv	a2,s7
40f03738:	00007597          	auipc	a1,0x7
40f0373c:	c0858593          	addi	a1,a1,-1016 # 40f0a340 <__func__.1282>
40f03740:	00007517          	auipc	a0,0x7
40f03744:	d8c50513          	addi	a0,a0,-628 # 40f0a4cc <__func__.1282+0x18c>
40f03748:	6b5010ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f0374c:	0719c603          	lbu	a2,113(s3)
40f03750:	01d9c683          	lbu	a3,29(s3)
40f03754:	0709c883          	lbu	a7,112(s3)
40f03758:	01c9c503          	lbu	a0,28(s3)
40f0375c:	0729c783          	lbu	a5,114(s3)
40f03760:	01e9c703          	lbu	a4,30(s3)
40f03764:	0739c803          	lbu	a6,115(s3)
40f03768:	01f9c583          	lbu	a1,31(s3)
40f0376c:	00861613          	slli	a2,a2,0x8
40f03770:	00869693          	slli	a3,a3,0x8
40f03774:	01166633          	or	a2,a2,a7
40f03778:	00a6e6b3          	or	a3,a3,a0
40f0377c:	01079793          	slli	a5,a5,0x10
40f03780:	01071713          	slli	a4,a4,0x10
40f03784:	00c7e7b3          	or	a5,a5,a2
40f03788:	00d76733          	or	a4,a4,a3
40f0378c:	01859593          	slli	a1,a1,0x18
40f03790:	01881813          	slli	a6,a6,0x18
40f03794:	00f86833          	or	a6,a6,a5
40f03798:	00e5e733          	or	a4,a1,a4
40f0379c:	00007797          	auipc	a5,0x7
40f037a0:	db478793          	addi	a5,a5,-588 # 40f0a550 <__func__.1282+0x210>
40f037a4:	00007697          	auipc	a3,0x7
40f037a8:	db068693          	addi	a3,a3,-592 # 40f0a554 <__func__.1282+0x214>
40f037ac:	000b8613          	mv	a2,s7
40f037b0:	00007597          	auipc	a1,0x7
40f037b4:	b9058593          	addi	a1,a1,-1136 # 40f0a340 <__func__.1282>
40f037b8:	00007517          	auipc	a0,0x7
40f037bc:	d1450513          	addi	a0,a0,-748 # 40f0a4cc <__func__.1282+0x18c>
40f037c0:	63d010ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX " %s=0x%" PRILX "\n", __func__,
40f037c4:	0799c603          	lbu	a2,121(s3)
40f037c8:	0759c683          	lbu	a3,117(s3)
40f037cc:	0789c883          	lbu	a7,120(s3)
40f037d0:	0749c503          	lbu	a0,116(s3)
40f037d4:	07a9c783          	lbu	a5,122(s3)
40f037d8:	0769c703          	lbu	a4,118(s3)
40f037dc:	07b9c803          	lbu	a6,123(s3)
40f037e0:	0779c583          	lbu	a1,119(s3)
40f037e4:	00861613          	slli	a2,a2,0x8
40f037e8:	00869693          	slli	a3,a3,0x8
40f037ec:	01166633          	or	a2,a2,a7
40f037f0:	00a6e6b3          	or	a3,a3,a0
40f037f4:	01079793          	slli	a5,a5,0x10
40f037f8:	01071713          	slli	a4,a4,0x10
40f037fc:	00c7e7b3          	or	a5,a5,a2
40f03800:	00d76733          	or	a4,a4,a3
40f03804:	01859593          	slli	a1,a1,0x18
40f03808:	01881813          	slli	a6,a6,0x18
40f0380c:	00f86833          	or	a6,a6,a5
40f03810:	00e5e733          	or	a4,a1,a4
40f03814:	00007797          	auipc	a5,0x7
40f03818:	d4478793          	addi	a5,a5,-700 # 40f0a558 <__func__.1282+0x218>
40f0381c:	00007697          	auipc	a3,0x7
40f03820:	d4068693          	addi	a3,a3,-704 # 40f0a55c <__func__.1282+0x21c>
40f03824:	000b8613          	mv	a2,s7
40f03828:	00007597          	auipc	a1,0x7
40f0382c:	b1858593          	addi	a1,a1,-1256 # 40f0a340 <__func__.1282>
40f03830:	00007517          	auipc	a0,0x7
40f03834:	c9c50513          	addi	a0,a0,-868 # 40f0a4cc <__func__.1282+0x18c>
40f03838:	5c5010ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("%s: hart%d: %s=0x%" PRILX "\n", __func__, hartid, "t6",
40f0383c:	07d9c703          	lbu	a4,125(s3)
40f03840:	07c9c603          	lbu	a2,124(s3)
40f03844:	07e9c783          	lbu	a5,126(s3)
40f03848:	07f9c683          	lbu	a3,127(s3)
40f0384c:	00871713          	slli	a4,a4,0x8
40f03850:	00c76733          	or	a4,a4,a2
40f03854:	01079793          	slli	a5,a5,0x10
40f03858:	00e7e7b3          	or	a5,a5,a4
40f0385c:	01869713          	slli	a4,a3,0x18
40f03860:	00f76733          	or	a4,a4,a5
40f03864:	00007697          	auipc	a3,0x7
40f03868:	cfc68693          	addi	a3,a3,-772 # 40f0a560 <__func__.1282+0x220>
40f0386c:	000b8613          	mv	a2,s7
40f03870:	00007597          	auipc	a1,0x7
40f03874:	ad058593          	addi	a1,a1,-1328 # 40f0a340 <__func__.1282>
40f03878:	00007517          	auipc	a0,0x7
40f0387c:	cec50513          	addi	a0,a0,-788 # 40f0a564 <__func__.1282+0x224>
40f03880:	57d010ef          	jal	ra,40f055fc <sbi_printf>
	sbi_hart_hang();
40f03884:	0d1030ef          	jal	ra,40f07154 <sbi_hart_hang>
		rc  = sbi_ecall_handler(hartid, mcause, regs, scratch);
40f03888:	000c0693          	mv	a3,s8
40f0388c:	00098613          	mv	a2,s3
40f03890:	00048593          	mv	a1,s1
40f03894:	000b8513          	mv	a0,s7
40f03898:	0a4020ef          	jal	ra,40f0593c <sbi_ecall_handler>
		msg = "ecall handler failed";
40f0389c:	00007697          	auipc	a3,0x7
40f038a0:	b2c68693          	addi	a3,a3,-1236 # 40f0a3c8 <__func__.1282+0x88>
	if (rc) {
40f038a4:	fa050263          	beqz	a0,40f03048 <sbi_trap_handler+0xb4>
40f038a8:	fdcff06f          	j	40f03084 <sbi_trap_handler+0xf0>
		rc  = sbi_illegal_insn_handler(hartid, mcause, mtval,
40f038ac:	00098693          	mv	a3,s3
40f038b0:	000c0713          	mv	a4,s8
40f038b4:	000b0613          	mv	a2,s6
40f038b8:	00200593          	li	a1,2
40f038bc:	000b8513          	mv	a0,s7
40f038c0:	0a0040ef          	jal	ra,40f07960 <sbi_illegal_insn_handler>
		msg = "illegal instruction handler failed";
40f038c4:	00007697          	auipc	a3,0x7
40f038c8:	aa068693          	addi	a3,a3,-1376 # 40f0a364 <__func__.1282+0x24>
	if (rc) {
40f038cc:	f6050e63          	beqz	a0,40f03048 <sbi_trap_handler+0xb4>
40f038d0:	fb4ff06f          	j	40f03084 <sbi_trap_handler+0xf0>
		rc = sbi_misaligned_load_handler(hartid, mcause, mtval,
40f038d4:	000a0693          	mv	a3,s4
40f038d8:	000c0813          	mv	a6,s8
40f038dc:	00098793          	mv	a5,s3
40f038e0:	000a8713          	mv	a4,s5
40f038e4:	000b0613          	mv	a2,s6
40f038e8:	00400593          	li	a1,4
40f038ec:	000b8513          	mv	a0,s7
40f038f0:	1d8040ef          	jal	ra,40f07ac8 <sbi_misaligned_load_handler>
		msg = "misaligned load handler failed";
40f038f4:	00007697          	auipc	a3,0x7
40f038f8:	a9468693          	addi	a3,a3,-1388 # 40f0a388 <__func__.1282+0x48>
	if (rc) {
40f038fc:	f4050663          	beqz	a0,40f03048 <sbi_trap_handler+0xb4>
40f03900:	f84ff06f          	j	40f03084 <sbi_trap_handler+0xf0>
		uptrap = sbi_hart_get_trap_info(scratch);
40f03904:	000c0513          	mv	a0,s8
40f03908:	7dc030ef          	jal	ra,40f070e4 <sbi_hart_get_trap_info>
		if ((regs->mstatus & MSTATUS_MPRV) && uptrap) {
40f0390c:	0869c783          	lbu	a5,134(s3)
40f03910:	0819c683          	lbu	a3,129(s3)
40f03914:	0809c603          	lbu	a2,128(s3)
40f03918:	0017d793          	srli	a5,a5,0x1
40f0391c:	0017f793          	andi	a5,a5,1
40f03920:	0e078863          	beqz	a5,40f03a10 <sbi_trap_handler+0xa7c>
40f03924:	0829c703          	lbu	a4,130(s3)
40f03928:	0839c783          	lbu	a5,131(s3)
40f0392c:	00869693          	slli	a3,a3,0x8
40f03930:	00c6e6b3          	or	a3,a3,a2
40f03934:	01071713          	slli	a4,a4,0x10
40f03938:	00d76733          	or	a4,a4,a3
40f0393c:	01879793          	slli	a5,a5,0x18
40f03940:	00e7e7b3          	or	a5,a5,a4
40f03944:	00078713          	mv	a4,a5
40f03948:	0e050463          	beqz	a0,40f03a30 <sbi_trap_handler+0xa9c>
			regs->mepc += 4;
40f0394c:	00478713          	addi	a4,a5,4
			uptrap->epc = regs->mepc;
40f03950:	00f52023          	sw	a5,0(a0)
			regs->mepc += 4;
40f03954:	00875613          	srli	a2,a4,0x8
40f03958:	01075693          	srli	a3,a4,0x10
40f0395c:	01875793          	srli	a5,a4,0x18
40f03960:	08e98023          	sb	a4,128(s3)
40f03964:	08c980a3          	sb	a2,129(s3)
40f03968:	08d98123          	sb	a3,130(s3)
40f0396c:	08f981a3          	sb	a5,131(s3)
			uptrap->cause = mcause;
40f03970:	00952223          	sw	s1,4(a0)
			uptrap->tval = mtval;
40f03974:	01652423          	sw	s6,8(a0)
			uptrap->tval2 = mtval2;
40f03978:	01452623          	sw	s4,12(a0)
			uptrap->tinst = mtinst;
40f0397c:	01552823          	sw	s5,16(a0)
	if (rc) {
40f03980:	ec8ff06f          	j	40f03048 <sbi_trap_handler+0xb4>
		rc  = sbi_misaligned_store_handler(hartid, mcause, mtval,
40f03984:	000a0693          	mv	a3,s4
40f03988:	000c0813          	mv	a6,s8
40f0398c:	00098793          	mv	a5,s3
40f03990:	000a8713          	mv	a4,s5
40f03994:	000b0613          	mv	a2,s6
40f03998:	00600593          	li	a1,6
40f0399c:	000b8513          	mv	a0,s7
40f039a0:	3a0040ef          	jal	ra,40f07d40 <sbi_misaligned_store_handler>
		msg = "misaligned store handler failed";
40f039a4:	00007697          	auipc	a3,0x7
40f039a8:	a0468693          	addi	a3,a3,-1532 # 40f0a3a8 <__func__.1282+0x68>
	if (rc) {
40f039ac:	e8050e63          	beqz	a0,40f03048 <sbi_trap_handler+0xb4>
40f039b0:	ed4ff06f          	j	40f03084 <sbi_trap_handler+0xf0>
		trap.epc = regs->mepc;
40f039b4:	0819c683          	lbu	a3,129(s3)
40f039b8:	0809c603          	lbu	a2,128(s3)
40f039bc:	0829c703          	lbu	a4,130(s3)
40f039c0:	0839c783          	lbu	a5,131(s3)
40f039c4:	00869693          	slli	a3,a3,0x8
40f039c8:	00c6e6b3          	or	a3,a3,a2
40f039cc:	01071713          	slli	a4,a4,0x10
40f039d0:	00d76733          	or	a4,a4,a3
40f039d4:	01879793          	slli	a5,a5,0x18
40f039d8:	00e7e7b3          	or	a5,a5,a4
		rc = sbi_trap_redirect(regs, &trap, scratch);
40f039dc:	000c0613          	mv	a2,s8
40f039e0:	fbc40593          	addi	a1,s0,-68
40f039e4:	00098513          	mv	a0,s3
		trap.epc = regs->mepc;
40f039e8:	faf42e23          	sw	a5,-68(s0)
		trap.cause = mcause;
40f039ec:	fc942023          	sw	s1,-64(s0)
		trap.tval = mtval;
40f039f0:	fd642223          	sw	s6,-60(s0)
		trap.tval2 = mtval2;
40f039f4:	fd442423          	sw	s4,-56(s0)
		trap.tinst = mtinst;
40f039f8:	fd542623          	sw	s5,-52(s0)
		rc = sbi_trap_redirect(regs, &trap, scratch);
40f039fc:	9a8ff0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
	const char *msg = "trap handler failed";
40f03a00:	00007697          	auipc	a3,0x7
40f03a04:	95068693          	addi	a3,a3,-1712 # 40f0a350 <__func__.1282+0x10>
	if (rc) {
40f03a08:	e4050063          	beqz	a0,40f03048 <sbi_trap_handler+0xb4>
40f03a0c:	e78ff06f          	j	40f03084 <sbi_trap_handler+0xf0>
40f03a10:	0829c783          	lbu	a5,130(s3)
40f03a14:	0839c703          	lbu	a4,131(s3)
40f03a18:	00869693          	slli	a3,a3,0x8
40f03a1c:	00c6e6b3          	or	a3,a3,a2
40f03a20:	01079793          	slli	a5,a5,0x10
40f03a24:	00d7e7b3          	or	a5,a5,a3
40f03a28:	01871713          	slli	a4,a4,0x18
40f03a2c:	00f76733          	or	a4,a4,a5
			rc = sbi_trap_redirect(regs, &trap, scratch);
40f03a30:	000c0613          	mv	a2,s8
40f03a34:	fbc40593          	addi	a1,s0,-68
40f03a38:	00098513          	mv	a0,s3
			trap.epc = regs->mepc;
40f03a3c:	fae42e23          	sw	a4,-68(s0)
			trap.cause = mcause;
40f03a40:	fc942023          	sw	s1,-64(s0)
			trap.tval = mtval;
40f03a44:	fd642223          	sw	s6,-60(s0)
			trap.tval2 = mtval2;
40f03a48:	fd442423          	sw	s4,-56(s0)
			trap.tinst = mtinst;
40f03a4c:	fd542623          	sw	s5,-52(s0)
			rc = sbi_trap_redirect(regs, &trap, scratch);
40f03a50:	954ff0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
		msg = "page/access fault handler failed";
40f03a54:	00007697          	auipc	a3,0x7
40f03a58:	98c68693          	addi	a3,a3,-1652 # 40f0a3e0 <__func__.1282+0xa0>
	if (rc) {
40f03a5c:	de050663          	beqz	a0,40f03048 <sbi_trap_handler+0xb4>
40f03a60:	e24ff06f          	j	40f03084 <sbi_trap_handler+0xf0>
			sbi_ipi_process(scratch);
40f03a64:	000c0513          	mv	a0,s8
40f03a68:	a25fd0ef          	jal	ra,40f0148c <sbi_ipi_process>
			break;
40f03a6c:	ddcff06f          	j	40f03048 <sbi_trap_handler+0xb4>
		sbi_printf("%s: hart%d: mtval2=0x%" PRILX
40f03a70:	000a8713          	mv	a4,s5
40f03a74:	000a0693          	mv	a3,s4
40f03a78:	000b8613          	mv	a2,s7
40f03a7c:	00007597          	auipc	a1,0x7
40f03a80:	8c458593          	addi	a1,a1,-1852 # 40f0a340 <__func__.1282>
40f03a84:	00007517          	auipc	a0,0x7
40f03a88:	9e850513          	addi	a0,a0,-1560 # 40f0a46c <__func__.1282+0x12c>
40f03a8c:	371010ef          	jal	ra,40f055fc <sbi_printf>
40f03a90:	e3cff06f          	j	40f030cc <sbi_trap_handler+0x138>

40f03a94 <sbi_strcmp>:
 */

#include <sbi/sbi_string.h>

int sbi_strcmp(const char *a, const char *b)
{
40f03a94:	ff010113          	addi	sp,sp,-16
40f03a98:	00812623          	sw	s0,12(sp)
40f03a9c:	01010413          	addi	s0,sp,16
	/* search first diff or end of string */
	for (; *a == *b && *a != '\0'; a++, b++)
40f03aa0:	00054703          	lbu	a4,0(a0)
40f03aa4:	0005c783          	lbu	a5,0(a1)
40f03aa8:	00e79e63          	bne	a5,a4,40f03ac4 <sbi_strcmp+0x30>
40f03aac:	02078463          	beqz	a5,40f03ad4 <sbi_strcmp+0x40>
40f03ab0:	00150513          	addi	a0,a0,1
40f03ab4:	00158593          	addi	a1,a1,1
40f03ab8:	0005c783          	lbu	a5,0(a1)
40f03abc:	00054703          	lbu	a4,0(a0)
40f03ac0:	fef706e3          	beq	a4,a5,40f03aac <sbi_strcmp+0x18>
		;

	return *a - *b;
}
40f03ac4:	00c12403          	lw	s0,12(sp)
40f03ac8:	40f70533          	sub	a0,a4,a5
40f03acc:	01010113          	addi	sp,sp,16
40f03ad0:	00008067          	ret
40f03ad4:	00c12403          	lw	s0,12(sp)
	for (; *a == *b && *a != '\0'; a++, b++)
40f03ad8:	00000713          	li	a4,0
}
40f03adc:	40f70533          	sub	a0,a4,a5
40f03ae0:	01010113          	addi	sp,sp,16
40f03ae4:	00008067          	ret

40f03ae8 <sbi_strlen>:

size_t sbi_strlen(const char *str)
{
40f03ae8:	ff010113          	addi	sp,sp,-16
40f03aec:	00812623          	sw	s0,12(sp)
40f03af0:	01010413          	addi	s0,sp,16
	unsigned long ret = 0;

	while (*str != '\0') {
40f03af4:	00054783          	lbu	a5,0(a0)
40f03af8:	02078463          	beqz	a5,40f03b20 <sbi_strlen+0x38>
	unsigned long ret = 0;
40f03afc:	00000793          	li	a5,0
		ret++;
40f03b00:	00178793          	addi	a5,a5,1
	while (*str != '\0') {
40f03b04:	00f50733          	add	a4,a0,a5
40f03b08:	00074703          	lbu	a4,0(a4)
40f03b0c:	fe071ae3          	bnez	a4,40f03b00 <sbi_strlen+0x18>
		str++;
	}

	return ret;
}
40f03b10:	00c12403          	lw	s0,12(sp)
40f03b14:	00078513          	mv	a0,a5
40f03b18:	01010113          	addi	sp,sp,16
40f03b1c:	00008067          	ret
40f03b20:	00c12403          	lw	s0,12(sp)
	unsigned long ret = 0;
40f03b24:	00000793          	li	a5,0
}
40f03b28:	00078513          	mv	a0,a5
40f03b2c:	01010113          	addi	sp,sp,16
40f03b30:	00008067          	ret

40f03b34 <sbi_strnlen>:

size_t sbi_strnlen(const char *str, size_t count)
{
40f03b34:	ff010113          	addi	sp,sp,-16
40f03b38:	00812623          	sw	s0,12(sp)
40f03b3c:	01010413          	addi	s0,sp,16
	unsigned long ret = 0;

	while (*str != '\0' && ret < count) {
40f03b40:	00054783          	lbu	a5,0(a0)
40f03b44:	02078c63          	beqz	a5,40f03b7c <sbi_strnlen+0x48>
	unsigned long ret = 0;
40f03b48:	00000793          	li	a5,0
	while (*str != '\0' && ret < count) {
40f03b4c:	00059663          	bnez	a1,40f03b58 <sbi_strnlen+0x24>
40f03b50:	01c0006f          	j	40f03b6c <sbi_strnlen+0x38>
40f03b54:	00d7fc63          	bgeu	a5,a3,40f03b6c <sbi_strnlen+0x38>
		ret++;
40f03b58:	00178793          	addi	a5,a5,1
	while (*str != '\0' && ret < count) {
40f03b5c:	00f50733          	add	a4,a0,a5
40f03b60:	00074703          	lbu	a4,0(a4)
40f03b64:	40f586b3          	sub	a3,a1,a5
40f03b68:	fe0716e3          	bnez	a4,40f03b54 <sbi_strnlen+0x20>
		str++;
		count--;
	}

	return ret;
}
40f03b6c:	00c12403          	lw	s0,12(sp)
40f03b70:	00078513          	mv	a0,a5
40f03b74:	01010113          	addi	sp,sp,16
40f03b78:	00008067          	ret
	unsigned long ret = 0;
40f03b7c:	00000793          	li	a5,0
40f03b80:	fedff06f          	j	40f03b6c <sbi_strnlen+0x38>

40f03b84 <sbi_strcpy>:

char *sbi_strcpy(char *dest, const char *src)
{
40f03b84:	ff010113          	addi	sp,sp,-16
40f03b88:	00812623          	sw	s0,12(sp)
40f03b8c:	01010413          	addi	s0,sp,16
	char *ret = dest;

	while (*src != '\0') {
40f03b90:	0005c783          	lbu	a5,0(a1)
40f03b94:	00078e63          	beqz	a5,40f03bb0 <sbi_strcpy+0x2c>
40f03b98:	00050713          	mv	a4,a0
		*dest++ = *src++;
40f03b9c:	00170713          	addi	a4,a4,1
40f03ba0:	00158593          	addi	a1,a1,1
40f03ba4:	fef70fa3          	sb	a5,-1(a4)
	while (*src != '\0') {
40f03ba8:	0005c783          	lbu	a5,0(a1)
40f03bac:	fe0798e3          	bnez	a5,40f03b9c <sbi_strcpy+0x18>
	}

	return ret;
}
40f03bb0:	00c12403          	lw	s0,12(sp)
40f03bb4:	01010113          	addi	sp,sp,16
40f03bb8:	00008067          	ret

40f03bbc <sbi_strncpy>:

char *sbi_strncpy(char *dest, const char *src, size_t count)
{
40f03bbc:	ff010113          	addi	sp,sp,-16
40f03bc0:	00812623          	sw	s0,12(sp)
40f03bc4:	01010413          	addi	s0,sp,16
	char *ret = dest;

	while (count-- && *src != '\0') {
40f03bc8:	02060863          	beqz	a2,40f03bf8 <sbi_strncpy+0x3c>
40f03bcc:	0005c703          	lbu	a4,0(a1)
40f03bd0:	02070463          	beqz	a4,40f03bf8 <sbi_strncpy+0x3c>
40f03bd4:	00c50633          	add	a2,a0,a2
40f03bd8:	00050793          	mv	a5,a0
40f03bdc:	00c0006f          	j	40f03be8 <sbi_strncpy+0x2c>
40f03be0:	0005c703          	lbu	a4,0(a1)
40f03be4:	00070a63          	beqz	a4,40f03bf8 <sbi_strncpy+0x3c>
		*dest++ = *src++;
40f03be8:	00178793          	addi	a5,a5,1
40f03bec:	fee78fa3          	sb	a4,-1(a5)
40f03bf0:	00158593          	addi	a1,a1,1
	while (count-- && *src != '\0') {
40f03bf4:	fec796e3          	bne	a5,a2,40f03be0 <sbi_strncpy+0x24>
	}

	return ret;
}
40f03bf8:	00c12403          	lw	s0,12(sp)
40f03bfc:	01010113          	addi	sp,sp,16
40f03c00:	00008067          	ret

40f03c04 <sbi_strchr>:

char *sbi_strchr(const char *s, int c)
{
40f03c04:	ff010113          	addi	sp,sp,-16
40f03c08:	00812623          	sw	s0,12(sp)
40f03c0c:	01010413          	addi	s0,sp,16
	while (*s != '\0' && *s != (char)c)
40f03c10:	00054783          	lbu	a5,0(a0)
40f03c14:	00078c63          	beqz	a5,40f03c2c <sbi_strchr+0x28>
40f03c18:	0ff5f593          	andi	a1,a1,255
40f03c1c:	00f58a63          	beq	a1,a5,40f03c30 <sbi_strchr+0x2c>
		s++;
40f03c20:	00150513          	addi	a0,a0,1
	while (*s != '\0' && *s != (char)c)
40f03c24:	00054783          	lbu	a5,0(a0)
40f03c28:	fe079ae3          	bnez	a5,40f03c1c <sbi_strchr+0x18>

	if (*s == '\0')
		return NULL;
40f03c2c:	00000513          	li	a0,0
	else
		return (char *)s;
}
40f03c30:	00c12403          	lw	s0,12(sp)
40f03c34:	01010113          	addi	sp,sp,16
40f03c38:	00008067          	ret

40f03c3c <sbi_strrchr>:

char *sbi_strrchr(const char *s, int c)
{
40f03c3c:	ff010113          	addi	sp,sp,-16
40f03c40:	00812623          	sw	s0,12(sp)
40f03c44:	01010413          	addi	s0,sp,16
	while (*str != '\0') {
40f03c48:	00054703          	lbu	a4,0(a0)
40f03c4c:	0ff5f593          	andi	a1,a1,255
40f03c50:	04070c63          	beqz	a4,40f03ca8 <sbi_strrchr+0x6c>
	unsigned long ret = 0;
40f03c54:	00000713          	li	a4,0
		ret++;
40f03c58:	00170713          	addi	a4,a4,1
		str++;
40f03c5c:	00e507b3          	add	a5,a0,a4
	while (*str != '\0') {
40f03c60:	0007c683          	lbu	a3,0(a5)
40f03c64:	fe069ae3          	bnez	a3,40f03c58 <sbi_strrchr+0x1c>
	const char *last = s + sbi_strlen(s);

	while (last > s && *last != (char)c)
40f03c68:	00000713          	li	a4,0
40f03c6c:	00f57e63          	bgeu	a0,a5,40f03c88 <sbi_strrchr+0x4c>
40f03c70:	00059663          	bnez	a1,40f03c7c <sbi_strrchr+0x40>
40f03c74:	0240006f          	j	40f03c98 <sbi_strrchr+0x5c>
40f03c78:	02b70063          	beq	a4,a1,40f03c98 <sbi_strrchr+0x5c>
		last--;
40f03c7c:	fff78793          	addi	a5,a5,-1
40f03c80:	0007c703          	lbu	a4,0(a5)
	while (last > s && *last != (char)c)
40f03c84:	fef51ae3          	bne	a0,a5,40f03c78 <sbi_strrchr+0x3c>

	if (*last != (char)c)
		return NULL;
40f03c88:	40b70733          	sub	a4,a4,a1
40f03c8c:	00173713          	seqz	a4,a4
40f03c90:	40e00733          	neg	a4,a4
40f03c94:	00e7f7b3          	and	a5,a5,a4
	else
		return (char *)last;
}
40f03c98:	00c12403          	lw	s0,12(sp)
40f03c9c:	00078513          	mv	a0,a5
40f03ca0:	01010113          	addi	sp,sp,16
40f03ca4:	00008067          	ret
	while (*str != '\0') {
40f03ca8:	00050793          	mv	a5,a0
40f03cac:	fddff06f          	j	40f03c88 <sbi_strrchr+0x4c>

40f03cb0 <sbi_memset>:
void *sbi_memset(void *s, int c, size_t count)
{
40f03cb0:	ff010113          	addi	sp,sp,-16
40f03cb4:	00812623          	sw	s0,12(sp)
40f03cb8:	01010413          	addi	s0,sp,16
40f03cbc:	00c50733          	add	a4,a0,a2
	char *temp = s;

	while (count > 0) {
40f03cc0:	00060c63          	beqz	a2,40f03cd8 <sbi_memset+0x28>
40f03cc4:	0ff5f593          	andi	a1,a1,255
40f03cc8:	00050793          	mv	a5,a0
		count--;
		*temp++ = c;
40f03ccc:	00178793          	addi	a5,a5,1
40f03cd0:	feb78fa3          	sb	a1,-1(a5)
	while (count > 0) {
40f03cd4:	fee79ce3          	bne	a5,a4,40f03ccc <sbi_memset+0x1c>
	}

	return s;
}
40f03cd8:	00c12403          	lw	s0,12(sp)
40f03cdc:	01010113          	addi	sp,sp,16
40f03ce0:	00008067          	ret

40f03ce4 <sbi_memcpy>:

void *sbi_memcpy(void *dest, const void *src, size_t count)
{
40f03ce4:	ff010113          	addi	sp,sp,-16
40f03ce8:	00812623          	sw	s0,12(sp)
40f03cec:	01010413          	addi	s0,sp,16
	char *temp1	  = dest;
	const char *temp2 = src;

	while (count > 0) {
40f03cf0:	02060063          	beqz	a2,40f03d10 <sbi_memcpy+0x2c>
40f03cf4:	00c50633          	add	a2,a0,a2
	char *temp1	  = dest;
40f03cf8:	00050793          	mv	a5,a0
		*temp1++ = *temp2++;
40f03cfc:	00158593          	addi	a1,a1,1
40f03d00:	fff5c703          	lbu	a4,-1(a1)
40f03d04:	00178793          	addi	a5,a5,1
40f03d08:	fee78fa3          	sb	a4,-1(a5)
	while (count > 0) {
40f03d0c:	fec798e3          	bne	a5,a2,40f03cfc <sbi_memcpy+0x18>
		count--;
	}

	return dest;
}
40f03d10:	00c12403          	lw	s0,12(sp)
40f03d14:	01010113          	addi	sp,sp,16
40f03d18:	00008067          	ret

40f03d1c <sbi_memmove>:

void *sbi_memmove(void *dest, const void *src, size_t count)
{
40f03d1c:	ff010113          	addi	sp,sp,-16
40f03d20:	00812623          	sw	s0,12(sp)
40f03d24:	01010413          	addi	s0,sp,16
	char *temp1	  = (char *)dest;
	const char *temp2 = (char *)src;

	if (src == dest)
40f03d28:	02b50463          	beq	a0,a1,40f03d50 <sbi_memmove+0x34>
		return dest;

	if (dest < src) {
40f03d2c:	02b57863          	bgeu	a0,a1,40f03d5c <sbi_memmove+0x40>
		while (count > 0) {
40f03d30:	02060063          	beqz	a2,40f03d50 <sbi_memmove+0x34>
40f03d34:	00c50633          	add	a2,a0,a2
40f03d38:	00050793          	mv	a5,a0
			*temp1++ = *temp2++;
40f03d3c:	00158593          	addi	a1,a1,1
40f03d40:	fff5c703          	lbu	a4,-1(a1)
40f03d44:	00178793          	addi	a5,a5,1
40f03d48:	fee78fa3          	sb	a4,-1(a5)
		while (count > 0) {
40f03d4c:	fef618e3          	bne	a2,a5,40f03d3c <sbi_memmove+0x20>
			count--;
		}
	}

	return dest;
}
40f03d50:	00c12403          	lw	s0,12(sp)
40f03d54:	01010113          	addi	sp,sp,16
40f03d58:	00008067          	ret
		temp1 = dest + count - 1;
40f03d5c:	fff60713          	addi	a4,a2,-1
40f03d60:	00e507b3          	add	a5,a0,a4
		temp2 = src + count - 1;
40f03d64:	00e585b3          	add	a1,a1,a4
		while (count > 0) {
40f03d68:	fe0604e3          	beqz	a2,40f03d50 <sbi_memmove+0x34>
40f03d6c:	fff50693          	addi	a3,a0,-1
			*temp1-- = *temp2--;
40f03d70:	fff58593          	addi	a1,a1,-1
40f03d74:	0015c703          	lbu	a4,1(a1)
40f03d78:	fff78793          	addi	a5,a5,-1
40f03d7c:	00e780a3          	sb	a4,1(a5)
		while (count > 0) {
40f03d80:	fed798e3          	bne	a5,a3,40f03d70 <sbi_memmove+0x54>
}
40f03d84:	00c12403          	lw	s0,12(sp)
40f03d88:	01010113          	addi	sp,sp,16
40f03d8c:	00008067          	ret

40f03d90 <sbi_memcmp>:

int sbi_memcmp(const void *s1, const void *s2, size_t count)
{
40f03d90:	ff010113          	addi	sp,sp,-16
40f03d94:	00812623          	sw	s0,12(sp)
40f03d98:	01010413          	addi	s0,sp,16
	const char *temp1 = s1;
	const char *temp2 = s2;

	for (; count > 0 && (*temp1 == *temp2); count--) {
40f03d9c:	02060863          	beqz	a2,40f03dcc <sbi_memcmp+0x3c>
40f03da0:	00054783          	lbu	a5,0(a0)
40f03da4:	0005c703          	lbu	a4,0(a1)
40f03da8:	02f71a63          	bne	a4,a5,40f03ddc <sbi_memcmp+0x4c>
40f03dac:	00c50633          	add	a2,a0,a2
40f03db0:	0100006f          	j	40f03dc0 <sbi_memcmp+0x30>
40f03db4:	00054783          	lbu	a5,0(a0)
40f03db8:	0005c703          	lbu	a4,0(a1)
40f03dbc:	02e79063          	bne	a5,a4,40f03ddc <sbi_memcmp+0x4c>
		temp1++;
40f03dc0:	00150513          	addi	a0,a0,1
		temp2++;
40f03dc4:	00158593          	addi	a1,a1,1
	for (; count > 0 && (*temp1 == *temp2); count--) {
40f03dc8:	fec516e3          	bne	a0,a2,40f03db4 <sbi_memcmp+0x24>

	if (count > 0)
		return *(unsigned char *)temp1 - *(unsigned char *)temp2;
	else
		return 0;
}
40f03dcc:	00c12403          	lw	s0,12(sp)
		return 0;
40f03dd0:	00000513          	li	a0,0
}
40f03dd4:	01010113          	addi	sp,sp,16
40f03dd8:	00008067          	ret
40f03ddc:	00c12403          	lw	s0,12(sp)
		return *(unsigned char *)temp1 - *(unsigned char *)temp2;
40f03de0:	40e78533          	sub	a0,a5,a4
}
40f03de4:	01010113          	addi	sp,sp,16
40f03de8:	00008067          	ret

40f03dec <sbi_memchr>:

void *sbi_memchr(const void *s, int c, size_t count)
{
40f03dec:	ff010113          	addi	sp,sp,-16
40f03df0:	00812623          	sw	s0,12(sp)
40f03df4:	01010413          	addi	s0,sp,16
	const unsigned char *temp = s;

	while (count > 0) {
40f03df8:	02060863          	beqz	a2,40f03e28 <sbi_memchr+0x3c>
		if ((unsigned char)c == *temp++) {
40f03dfc:	00054703          	lbu	a4,0(a0)
40f03e00:	0ff5f593          	andi	a1,a1,255
40f03e04:	00150793          	addi	a5,a0,1
40f03e08:	02b70a63          	beq	a4,a1,40f03e3c <sbi_memchr+0x50>
40f03e0c:	00c50633          	add	a2,a0,a2
40f03e10:	0100006f          	j	40f03e20 <sbi_memchr+0x34>
40f03e14:	fff74683          	lbu	a3,-1(a4)
40f03e18:	00b68a63          	beq	a3,a1,40f03e2c <sbi_memchr+0x40>
40f03e1c:	00070793          	mv	a5,a4
40f03e20:	00178713          	addi	a4,a5,1
	while (count > 0) {
40f03e24:	fef618e3          	bne	a2,a5,40f03e14 <sbi_memchr+0x28>
			return (void *)(temp - 1);
		}
		count--;
	}

	return NULL;
40f03e28:	00000793          	li	a5,0
}
40f03e2c:	00c12403          	lw	s0,12(sp)
40f03e30:	00078513          	mv	a0,a5
40f03e34:	01010113          	addi	sp,sp,16
40f03e38:	00008067          	ret
		if ((unsigned char)c == *temp++) {
40f03e3c:	00050793          	mv	a5,a0
40f03e40:	fedff06f          	j	40f03e2c <sbi_memchr+0x40>

40f03e44 <vex_final_init>:


/* clang-format on */

static int vex_final_init(bool cold_boot)
{
40f03e44:	ff010113          	addi	sp,sp,-16
40f03e48:	00812623          	sw	s0,12(sp)
40f03e4c:	01010413          	addi	s0,sp,16
	return 0;
}
40f03e50:	00c12403          	lw	s0,12(sp)
40f03e54:	00000513          	li	a0,0
40f03e58:	01010113          	addi	sp,sp,16
40f03e5c:	00008067          	ret

40f03e60 <vex_pmp_region_count>:

static u32 vex_pmp_region_count(u32 hartid)
{
40f03e60:	ff010113          	addi	sp,sp,-16
40f03e64:	00812623          	sw	s0,12(sp)
40f03e68:	01010413          	addi	s0,sp,16
	return 0;
}
40f03e6c:	00c12403          	lw	s0,12(sp)
40f03e70:	00000513          	li	a0,0
40f03e74:	01010113          	addi	sp,sp,16
40f03e78:	00008067          	ret

40f03e7c <vex_pmp_region_info>:

static int vex_pmp_region_info(u32 hartid, u32 index, ulong *prot, ulong *addr,
				ulong *log2size)
{
40f03e7c:	ff010113          	addi	sp,sp,-16
40f03e80:	00812623          	sw	s0,12(sp)
40f03e84:	01010413          	addi	s0,sp,16
		ret = -1;
		break;
	};

	return ret;
}
40f03e88:	00c12403          	lw	s0,12(sp)
40f03e8c:	fff00513          	li	a0,-1
40f03e90:	01010113          	addi	sp,sp,16
40f03e94:	00008067          	ret

40f03e98 <vex_console_init>:

extern void vex_putc(char ch);
extern int vex_getc(void);

static int vex_console_init(void)
{
40f03e98:	ff010113          	addi	sp,sp,-16
40f03e9c:	00812623          	sw	s0,12(sp)
40f03ea0:	01010413          	addi	s0,sp,16
	return 0;
}
40f03ea4:	00c12403          	lw	s0,12(sp)
40f03ea8:	00000513          	li	a0,0
40f03eac:	01010113          	addi	sp,sp,16
40f03eb0:	00008067          	ret

40f03eb4 <vex_system_down>:

	return clint_warm_timer_init();
}

static int vex_system_down(u32 type)
{
40f03eb4:	ff010113          	addi	sp,sp,-16
40f03eb8:	00812623          	sw	s0,12(sp)
40f03ebc:	01010413          	addi	s0,sp,16
	return 0;
}
40f03ec0:	00c12403          	lw	s0,12(sp)
40f03ec4:	00000513          	li	a0,0
40f03ec8:	01010113          	addi	sp,sp,16
40f03ecc:	00008067          	ret

40f03ed0 <vex_timer_init>:
{
40f03ed0:	ff010113          	addi	sp,sp,-16
40f03ed4:	00812423          	sw	s0,8(sp)
40f03ed8:	00112623          	sw	ra,12(sp)
40f03edc:	01010413          	addi	s0,sp,16
	if (cold_boot) {
40f03ee0:	00050c63          	beqz	a0,40f03ef8 <vex_timer_init+0x28>
		rc = clint_cold_timer_init(VEX_CLINT_ADDR,
40f03ee4:	00100613          	li	a2,1
40f03ee8:	00400593          	li	a1,4
40f03eec:	f0010537          	lui	a0,0xf0010
40f03ef0:	2a1040ef          	jal	ra,40f08990 <clint_cold_timer_init>
		if (rc)
40f03ef4:	00051463          	bnez	a0,40f03efc <vex_timer_init+0x2c>
	return clint_warm_timer_init();
40f03ef8:	229040ef          	jal	ra,40f08920 <clint_warm_timer_init>
}
40f03efc:	00c12083          	lw	ra,12(sp)
40f03f00:	00812403          	lw	s0,8(sp)
40f03f04:	01010113          	addi	sp,sp,16
40f03f08:	00008067          	ret

40f03f0c <vex_ipi_init>:
{
40f03f0c:	ff010113          	addi	sp,sp,-16
40f03f10:	00812423          	sw	s0,8(sp)
40f03f14:	00112623          	sw	ra,12(sp)
40f03f18:	01010413          	addi	s0,sp,16
	if (cold_boot) {
40f03f1c:	00050a63          	beqz	a0,40f03f30 <vex_ipi_init+0x24>
		rc = clint_cold_ipi_init(VEX_CLINT_ADDR, VEX_HART_COUNT);
40f03f20:	00400593          	li	a1,4
40f03f24:	f0010537          	lui	a0,0xf0010
40f03f28:	0d5040ef          	jal	ra,40f087fc <clint_cold_ipi_init>
		if (rc)
40f03f2c:	00051463          	bnez	a0,40f03f34 <vex_ipi_init+0x28>
	return clint_warm_ipi_init();
40f03f30:	05d040ef          	jal	ra,40f0878c <clint_warm_ipi_init>
}
40f03f34:	00c12083          	lw	ra,12(sp)
40f03f38:	00812403          	lw	s0,8(sp)
40f03f3c:	01010113          	addi	sp,sp,16
40f03f40:	00008067          	ret

40f03f44 <vex_irqchip_init>:
40f03f44:	ff010113          	addi	sp,sp,-16
40f03f48:	00812623          	sw	s0,12(sp)
40f03f4c:	01010413          	addi	s0,sp,16
40f03f50:	00c12403          	lw	s0,12(sp)
40f03f54:	00000513          	li	a0,0
40f03f58:	01010113          	addi	sp,sp,16
40f03f5c:	00008067          	ret

40f03f60 <vex_putc>:


#include <generated/csr.h>
#include <hw/flags.h>

void vex_putc(char c){
40f03f60:	ff010113          	addi	sp,sp,-16
40f03f64:	00812623          	sw	s0,12(sp)
40f03f68:	01010413          	addi	s0,sp,16
	MMPTR(a) = v;
}

static inline unsigned long csr_read_simple(unsigned long a)
{
	return MMPTR(a);
40f03f6c:	f0002737          	lui	a4,0xf0002
40f03f70:	80472783          	lw	a5,-2044(a4) # f0001804 <_fw_end+0xaf0f4804>
	while (uart_txfull_read());
40f03f74:	0ff7f793          	andi	a5,a5,255
40f03f78:	fe079ce3          	bnez	a5,40f03f70 <vex_putc+0x10>
	MMPTR(a) = v;
40f03f7c:	80a72023          	sw	a0,-2048(a4)
40f03f80:	00100793          	li	a5,1
40f03f84:	80f72823          	sw	a5,-2032(a4)
	uart_rxtx_write(c);
	uart_ev_pending_write(UART_EV_TX);
}
40f03f88:	00c12403          	lw	s0,12(sp)
40f03f8c:	01010113          	addi	sp,sp,16
40f03f90:	00008067          	ret

40f03f94 <vex_getc>:

int vex_getc(void){
40f03f94:	ff010113          	addi	sp,sp,-16
40f03f98:	00812623          	sw	s0,12(sp)
40f03f9c:	01010413          	addi	s0,sp,16
	return MMPTR(a);
40f03fa0:	f0002737          	lui	a4,0xf0002
40f03fa4:	80872783          	lw	a5,-2040(a4) # f0001808 <_fw_end+0xaf0f4808>
	char c;
	if (uart_rxempty_read()) return -1;
40f03fa8:	0ff7f793          	andi	a5,a5,255
40f03fac:	02079063          	bnez	a5,40f03fcc <vex_getc+0x38>
40f03fb0:	80072503          	lw	a0,-2048(a4)
	MMPTR(a) = v;
40f03fb4:	00200793          	li	a5,2
40f03fb8:	80f72823          	sw	a5,-2032(a4)
	c = uart_rxtx_read();
	uart_ev_pending_write(UART_EV_RX);
	return c;
40f03fbc:	0ff57513          	andi	a0,a0,255
}
40f03fc0:	00c12403          	lw	s0,12(sp)
40f03fc4:	01010113          	addi	sp,sp,16
40f03fc8:	00008067          	ret
	if (uart_rxempty_read()) return -1;
40f03fcc:	fff00513          	li	a0,-1
40f03fd0:	ff1ff06f          	j	40f03fc0 <vex_getc+0x2c>

40f03fd4 <misa_extension_imp>:
#include <sbi/sbi_platform.h>

/* determine CPU extension, return non-zero support */
int misa_extension_imp(char ext)
{
	unsigned long misa = csr_read(CSR_MISA);
40f03fd4:	301027f3          	csrr	a5,misa

	if (misa)
40f03fd8:	0a079863          	bnez	a5,40f04088 <misa_extension_imp+0xb4>
		return misa & (1 << (ext - 'A'));

	return sbi_platform_misa_extension(sbi_platform_thishart_ptr(), ext);
40f03fdc:	34002673          	csrr	a2,mscratch
40f03fe0:	01964683          	lbu	a3,25(a2)
40f03fe4:	01864583          	lbu	a1,24(a2)
40f03fe8:	01a64703          	lbu	a4,26(a2)
40f03fec:	01b64783          	lbu	a5,27(a2)
40f03ff0:	00869693          	slli	a3,a3,0x8
40f03ff4:	00b6e6b3          	or	a3,a3,a1
40f03ff8:	01071713          	slli	a4,a4,0x10
40f03ffc:	00d76733          	or	a4,a4,a3
40f04000:	01879793          	slli	a5,a5,0x18
40f04004:	00e7e7b3          	or	a5,a5,a4
	return 0;
40f04008:	00000713          	li	a4,0
	if (plat && sbi_platform_ops(plat)->misa_check_extension)
40f0400c:	08078663          	beqz	a5,40f04098 <misa_extension_imp+0xc4>
40f04010:	0617c603          	lbu	a2,97(a5)
40f04014:	0607c583          	lbu	a1,96(a5)
40f04018:	0627c683          	lbu	a3,98(a5)
40f0401c:	0637c783          	lbu	a5,99(a5)
40f04020:	00861613          	slli	a2,a2,0x8
40f04024:	00b66633          	or	a2,a2,a1
40f04028:	01069693          	slli	a3,a3,0x10
40f0402c:	00c6e6b3          	or	a3,a3,a2
40f04030:	01879793          	slli	a5,a5,0x18
40f04034:	00d7e7b3          	or	a5,a5,a3
40f04038:	0117c603          	lbu	a2,17(a5)
40f0403c:	0107c583          	lbu	a1,16(a5)
40f04040:	0127c683          	lbu	a3,18(a5)
40f04044:	0137c783          	lbu	a5,19(a5)
40f04048:	00861613          	slli	a2,a2,0x8
40f0404c:	00b66633          	or	a2,a2,a1
40f04050:	01069693          	slli	a3,a3,0x10
40f04054:	00c6e6b3          	or	a3,a3,a2
40f04058:	01879793          	slli	a5,a5,0x18
40f0405c:	00d7e7b3          	or	a5,a5,a3
40f04060:	02078c63          	beqz	a5,40f04098 <misa_extension_imp+0xc4>
{
40f04064:	ff010113          	addi	sp,sp,-16
40f04068:	00812423          	sw	s0,8(sp)
40f0406c:	00112623          	sw	ra,12(sp)
40f04070:	01010413          	addi	s0,sp,16
		return sbi_platform_ops(plat)->misa_check_extension(ext);
40f04074:	000780e7          	jalr	a5
}
40f04078:	00c12083          	lw	ra,12(sp)
40f0407c:	00812403          	lw	s0,8(sp)
40f04080:	01010113          	addi	sp,sp,16
40f04084:	00008067          	ret
		return misa & (1 << (ext - 'A'));
40f04088:	fbf50693          	addi	a3,a0,-65 # f000ffbf <_fw_end+0xaf102fbf>
40f0408c:	00100713          	li	a4,1
40f04090:	00d71733          	sll	a4,a4,a3
40f04094:	00f77733          	and	a4,a4,a5
}
40f04098:	00070513          	mv	a0,a4
40f0409c:	00008067          	ret

40f040a0 <misa_xlen>:

int misa_xlen(void)
{
	long r;

	if (csr_read(CSR_MISA) == 0)
40f040a0:	301027f3          	csrr	a5,misa
40f040a4:	02078263          	beqz	a5,40f040c8 <misa_xlen+0x28>
		return sbi_platform_misa_xlen(sbi_platform_thishart_ptr());

	__asm__ __volatile__(
40f040a8:	301022f3          	csrr	t0,misa
40f040ac:	0002a313          	slti	t1,t0,0
40f040b0:	00131313          	slli	t1,t1,0x1
40f040b4:	00129293          	slli	t0,t0,0x1
40f040b8:	0002a293          	slti	t0,t0,0
40f040bc:	00628533          	add	a0,t0,t1
		"add    %0, t0, t1"
		: "=r"(r)
		:
		: "t0", "t1");

	return r ? r : -1;
40f040c0:	0a050863          	beqz	a0,40f04170 <misa_xlen+0xd0>
40f040c4:	00008067          	ret
		return sbi_platform_misa_xlen(sbi_platform_thishart_ptr());
40f040c8:	34002673          	csrr	a2,mscratch
40f040cc:	01964683          	lbu	a3,25(a2)
40f040d0:	01864583          	lbu	a1,24(a2)
40f040d4:	01a64703          	lbu	a4,26(a2)
40f040d8:	01b64783          	lbu	a5,27(a2)
40f040dc:	00869693          	slli	a3,a3,0x8
40f040e0:	00b6e6b3          	or	a3,a3,a1
40f040e4:	01071713          	slli	a4,a4,0x10
40f040e8:	00d76733          	or	a4,a4,a3
40f040ec:	01879793          	slli	a5,a5,0x18
40f040f0:	00e7e7b3          	or	a5,a5,a4
	if (plat && sbi_platform_ops(plat)->misa_get_xlen)
40f040f4:	06078e63          	beqz	a5,40f04170 <misa_xlen+0xd0>
40f040f8:	0617c683          	lbu	a3,97(a5)
40f040fc:	0607c603          	lbu	a2,96(a5)
40f04100:	0627c703          	lbu	a4,98(a5)
40f04104:	0637c783          	lbu	a5,99(a5)
40f04108:	00869693          	slli	a3,a3,0x8
40f0410c:	00c6e6b3          	or	a3,a3,a2
40f04110:	01071713          	slli	a4,a4,0x10
40f04114:	00d76733          	or	a4,a4,a3
40f04118:	01879793          	slli	a5,a5,0x18
40f0411c:	00e7e7b3          	or	a5,a5,a4
40f04120:	0157c683          	lbu	a3,21(a5)
40f04124:	0147c603          	lbu	a2,20(a5)
40f04128:	0167c703          	lbu	a4,22(a5)
40f0412c:	0177c783          	lbu	a5,23(a5)
40f04130:	00869693          	slli	a3,a3,0x8
40f04134:	00c6e6b3          	or	a3,a3,a2
40f04138:	01071713          	slli	a4,a4,0x10
40f0413c:	00d76733          	or	a4,a4,a3
40f04140:	01879793          	slli	a5,a5,0x18
40f04144:	00e7e7b3          	or	a5,a5,a4
40f04148:	02078463          	beqz	a5,40f04170 <misa_xlen+0xd0>
{
40f0414c:	ff010113          	addi	sp,sp,-16
40f04150:	00812423          	sw	s0,8(sp)
40f04154:	00112623          	sw	ra,12(sp)
40f04158:	01010413          	addi	s0,sp,16
		return sbi_platform_ops(plat)->misa_get_xlen();
40f0415c:	000780e7          	jalr	a5
}
40f04160:	00c12083          	lw	ra,12(sp)
40f04164:	00812403          	lw	s0,8(sp)
40f04168:	01010113          	addi	sp,sp,16
40f0416c:	00008067          	ret
	return -1;
40f04170:	fff00513          	li	a0,-1
40f04174:	00008067          	ret

40f04178 <csr_read_num>:

unsigned long csr_read_num(int csr_num)
{
40f04178:	ff010113          	addi	sp,sp,-16
40f0417c:	00812623          	sw	s0,12(sp)
40f04180:	01010413          	addi	s0,sp,16
	unsigned long ret = 0;

	switch (csr_num) {
40f04184:	c6050513          	addi	a0,a0,-928
40f04188:	01f00793          	li	a5,31
40f0418c:	0ca7e463          	bltu	a5,a0,40f04254 <csr_read_num+0xdc>
40f04190:	00006717          	auipc	a4,0x6
40f04194:	4c070713          	addi	a4,a4,1216 # 40f0a650 <platform_ops+0x6c>
40f04198:	00251513          	slli	a0,a0,0x2
40f0419c:	00e50533          	add	a0,a0,a4
40f041a0:	00052783          	lw	a5,0(a0)
40f041a4:	00e787b3          	add	a5,a5,a4
40f041a8:	00078067          	jr	a5
		break;
	case CSR_PMPADDR14:
		ret = csr_read(CSR_PMPADDR14);
		break;
	case CSR_PMPADDR15:
		ret = csr_read(CSR_PMPADDR15);
40f041ac:	3bf02573          	csrr	a0,pmpaddr15
	default:
		break;
	};

	return ret;
}
40f041b0:	00c12403          	lw	s0,12(sp)
40f041b4:	01010113          	addi	sp,sp,16
40f041b8:	00008067          	ret
		ret = csr_read(CSR_PMPADDR14);
40f041bc:	3be02573          	csrr	a0,pmpaddr14
		break;
40f041c0:	ff1ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR13);
40f041c4:	3bd02573          	csrr	a0,pmpaddr13
		break;
40f041c8:	fe9ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR12);
40f041cc:	3bc02573          	csrr	a0,pmpaddr12
		break;
40f041d0:	fe1ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR11);
40f041d4:	3bb02573          	csrr	a0,pmpaddr11
		break;
40f041d8:	fd9ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR10);
40f041dc:	3ba02573          	csrr	a0,pmpaddr10
		break;
40f041e0:	fd1ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR9);
40f041e4:	3b902573          	csrr	a0,pmpaddr9
		break;
40f041e8:	fc9ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR8);
40f041ec:	3b802573          	csrr	a0,pmpaddr8
		break;
40f041f0:	fc1ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR7);
40f041f4:	3b702573          	csrr	a0,pmpaddr7
		break;
40f041f8:	fb9ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR6);
40f041fc:	3b602573          	csrr	a0,pmpaddr6
		break;
40f04200:	fb1ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR5);
40f04204:	3b502573          	csrr	a0,pmpaddr5
		break;
40f04208:	fa9ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR4);
40f0420c:	3b402573          	csrr	a0,pmpaddr4
		break;
40f04210:	fa1ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR3);
40f04214:	3b302573          	csrr	a0,pmpaddr3
		break;
40f04218:	f99ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR2);
40f0421c:	3b202573          	csrr	a0,pmpaddr2
		break;
40f04220:	f91ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR1);
40f04224:	3b102573          	csrr	a0,pmpaddr1
		break;
40f04228:	f89ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPADDR0);
40f0422c:	3b002573          	csrr	a0,pmpaddr0
		break;
40f04230:	f81ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPCFG3);
40f04234:	3a302573          	csrr	a0,pmpcfg3
		break;
40f04238:	f79ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPCFG2);
40f0423c:	3a202573          	csrr	a0,pmpcfg2
		break;
40f04240:	f71ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPCFG1);
40f04244:	3a102573          	csrr	a0,pmpcfg1
		break;
40f04248:	f69ff06f          	j	40f041b0 <csr_read_num+0x38>
		ret = csr_read(CSR_PMPCFG0);
40f0424c:	3a002573          	csrr	a0,pmpcfg0
		break;
40f04250:	f61ff06f          	j	40f041b0 <csr_read_num+0x38>
	unsigned long ret = 0;
40f04254:	00000513          	li	a0,0
	return ret;
40f04258:	f59ff06f          	j	40f041b0 <csr_read_num+0x38>

40f0425c <csr_write_num>:

void csr_write_num(int csr_num, unsigned long val)
{
40f0425c:	ff010113          	addi	sp,sp,-16
40f04260:	00812623          	sw	s0,12(sp)
40f04264:	01010413          	addi	s0,sp,16
	switch (csr_num) {
40f04268:	c6050513          	addi	a0,a0,-928
40f0426c:	01f00793          	li	a5,31
40f04270:	02a7e263          	bltu	a5,a0,40f04294 <csr_write_num+0x38>
40f04274:	00006717          	auipc	a4,0x6
40f04278:	45c70713          	addi	a4,a4,1116 # 40f0a6d0 <platform_ops+0xec>
40f0427c:	00251513          	slli	a0,a0,0x2
40f04280:	00e50533          	add	a0,a0,a4
40f04284:	00052783          	lw	a5,0(a0)
40f04288:	00e787b3          	add	a5,a5,a4
40f0428c:	00078067          	jr	a5
		break;
	case CSR_PMPADDR14:
		csr_write(CSR_PMPADDR14, val);
		break;
	case CSR_PMPADDR15:
		csr_write(CSR_PMPADDR15, val);
40f04290:	3bf59073          	csrw	pmpaddr15,a1
		break;
	default:
		break;
	};
}
40f04294:	00c12403          	lw	s0,12(sp)
40f04298:	01010113          	addi	sp,sp,16
40f0429c:	00008067          	ret
		csr_write(CSR_PMPADDR14, val);
40f042a0:	3be59073          	csrw	pmpaddr14,a1
		break;
40f042a4:	ff1ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR13, val);
40f042a8:	3bd59073          	csrw	pmpaddr13,a1
		break;
40f042ac:	fe9ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR12, val);
40f042b0:	3bc59073          	csrw	pmpaddr12,a1
		break;
40f042b4:	fe1ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR11, val);
40f042b8:	3bb59073          	csrw	pmpaddr11,a1
		break;
40f042bc:	fd9ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR10, val);
40f042c0:	3ba59073          	csrw	pmpaddr10,a1
		break;
40f042c4:	fd1ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR9, val);
40f042c8:	3b959073          	csrw	pmpaddr9,a1
		break;
40f042cc:	fc9ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR8, val);
40f042d0:	3b859073          	csrw	pmpaddr8,a1
		break;
40f042d4:	fc1ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR7, val);
40f042d8:	3b759073          	csrw	pmpaddr7,a1
		break;
40f042dc:	fb9ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR6, val);
40f042e0:	3b659073          	csrw	pmpaddr6,a1
		break;
40f042e4:	fb1ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR5, val);
40f042e8:	3b559073          	csrw	pmpaddr5,a1
		break;
40f042ec:	fa9ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR4, val);
40f042f0:	3b459073          	csrw	pmpaddr4,a1
		break;
40f042f4:	fa1ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR3, val);
40f042f8:	3b359073          	csrw	pmpaddr3,a1
		break;
40f042fc:	f99ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR2, val);
40f04300:	3b259073          	csrw	pmpaddr2,a1
		break;
40f04304:	f91ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR1, val);
40f04308:	3b159073          	csrw	pmpaddr1,a1
		break;
40f0430c:	f89ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPADDR0, val);
40f04310:	3b059073          	csrw	pmpaddr0,a1
		break;
40f04314:	f81ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPCFG3, val);
40f04318:	3a359073          	csrw	pmpcfg3,a1
		break;
40f0431c:	f79ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPCFG2, val);
40f04320:	3a259073          	csrw	pmpcfg2,a1
		break;
40f04324:	f71ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPCFG1, val);
40f04328:	3a159073          	csrw	pmpcfg1,a1
		break;
40f0432c:	f69ff06f          	j	40f04294 <csr_write_num+0x38>
		csr_write(CSR_PMPCFG0, val);
40f04330:	3a059073          	csrw	pmpcfg0,a1
		break;
40f04334:	f61ff06f          	j	40f04294 <csr_write_num+0x38>

40f04338 <pmp_set>:
	int pmpcfg_csr, pmpcfg_shift, pmpaddr_csr;
	unsigned long cfgmask, pmpcfg;
	unsigned long addrmask, pmpaddr;

	/* check parameters */
	if (n >= PMP_COUNT || log2len > __riscv_xlen || log2len < PMP_SHIFT)
40f04338:	00f00793          	li	a5,15
40f0433c:	12a7e463          	bltu	a5,a0,40f04464 <pmp_set+0x12c>
{
40f04340:	fd010113          	addi	sp,sp,-48
40f04344:	02812423          	sw	s0,40(sp)
40f04348:	01812423          	sw	s8,8(sp)
40f0434c:	02112623          	sw	ra,44(sp)
40f04350:	02912223          	sw	s1,36(sp)
40f04354:	03212023          	sw	s2,32(sp)
40f04358:	01312e23          	sw	s3,28(sp)
40f0435c:	01412c23          	sw	s4,24(sp)
40f04360:	01512a23          	sw	s5,20(sp)
40f04364:	01612823          	sw	s6,16(sp)
40f04368:	01712623          	sw	s7,12(sp)
40f0436c:	03010413          	addi	s0,sp,48
	if (n >= PMP_COUNT || log2len > __riscv_xlen || log2len < PMP_SHIFT)
40f04370:	ffe68c13          	addi	s8,a3,-2
40f04374:	01e00793          	li	a5,30
40f04378:	0f87ea63          	bltu	a5,s8,40f0446c <pmp_set+0x134>
40f0437c:	00058493          	mv	s1,a1
		return SBI_EINVAL;

		/* calculate PMP register and offset */
#if __riscv_xlen == 32
	pmpcfg_csr   = CSR_PMPCFG0 + (n >> 2);
	pmpcfg_shift = (n & 3) << 3;
40f04380:	00351593          	slli	a1,a0,0x3
40f04384:	0185fb93          	andi	s7,a1,24
40f04388:	0ff00713          	li	a4,255
	pmpcfg_csr   = CSR_PMPCFG0 + (n >> 2);
40f0438c:	00255a13          	srli	s4,a0,0x2
40f04390:	01771733          	sll	a4,a4,s7
	pmpaddr_csr = CSR_PMPADDR0 + n;
	if (pmpcfg_csr < 0 || pmpcfg_shift < 0)
		return SBI_ENOTSUPP;

	/* encode PMP config */
	prot |= (log2len == PMP_SHIFT) ? PMP_A_NA4 : PMP_A_NAPOT;
40f04394:	00200793          	li	a5,2
40f04398:	00068b13          	mv	s6,a3
40f0439c:	00060993          	mv	s3,a2
	pmpcfg_csr   = CSR_PMPCFG0 + (n >> 2);
40f043a0:	3a0a0a13          	addi	s4,s4,928
	pmpaddr_csr = CSR_PMPADDR0 + n;
40f043a4:	3b050913          	addi	s2,a0,944
	prot |= (log2len == PMP_SHIFT) ? PMP_A_NA4 : PMP_A_NAPOT;
40f043a8:	fff74a93          	not	s5,a4
40f043ac:	08f68a63          	beq	a3,a5,40f04440 <pmp_set+0x108>
	cfgmask = ~(0xff << pmpcfg_shift);
	pmpcfg	= (csr_read_num(pmpcfg_csr) & cfgmask);
40f043b0:	000a0513          	mv	a0,s4
40f043b4:	dc5ff0ef          	jal	ra,40f04178 <csr_read_num>
	prot |= (log2len == PMP_SHIFT) ? PMP_A_NA4 : PMP_A_NAPOT;
40f043b8:	0184e593          	ori	a1,s1,24
	pmpcfg |= ((prot << pmpcfg_shift) & ~cfgmask);
40f043bc:	017595b3          	sll	a1,a1,s7
40f043c0:	00b54533          	xor	a0,a0,a1
40f043c4:	01557ab3          	and	s5,a0,s5

	/* encode PMP address */
	if (log2len == PMP_SHIFT) {
		pmpaddr = (addr >> PMP_SHIFT);
	} else {
		if (log2len == __riscv_xlen) {
40f043c8:	02000793          	li	a5,32
	pmpcfg |= ((prot << pmpcfg_shift) & ~cfgmask);
40f043cc:	00bacab3          	xor	s5,s5,a1
			pmpaddr = -1UL;
40f043d0:	fff00593          	li	a1,-1
		if (log2len == __riscv_xlen) {
40f043d4:	02fb0263          	beq	s6,a5,40f043f8 <pmp_set+0xc0>
		} else {
			addrmask = (1UL << (log2len - PMP_SHIFT)) - 1;
40f043d8:	00100793          	li	a5,1
40f043dc:	018797b3          	sll	a5,a5,s8
			pmpaddr	 = ((addr >> PMP_SHIFT) & ~addrmask);
40f043e0:	0029d993          	srli	s3,s3,0x2
40f043e4:	40f00633          	neg	a2,a5
			addrmask = (1UL << (log2len - PMP_SHIFT)) - 1;
40f043e8:	fff78593          	addi	a1,a5,-1
			pmpaddr	 = ((addr >> PMP_SHIFT) & ~addrmask);
40f043ec:	00c9f9b3          	and	s3,s3,a2
			pmpaddr |= (addrmask >> 1);
40f043f0:	0015d593          	srli	a1,a1,0x1
40f043f4:	0135e5b3          	or	a1,a1,s3
		}
	}

	/* write csrs */
	csr_write_num(pmpaddr_csr, pmpaddr);
40f043f8:	00090513          	mv	a0,s2
40f043fc:	e61ff0ef          	jal	ra,40f0425c <csr_write_num>
	csr_write_num(pmpcfg_csr, pmpcfg);
40f04400:	000a0513          	mv	a0,s4
40f04404:	000a8593          	mv	a1,s5
40f04408:	e55ff0ef          	jal	ra,40f0425c <csr_write_num>

	return 0;
40f0440c:	00000513          	li	a0,0
}
40f04410:	02c12083          	lw	ra,44(sp)
40f04414:	02812403          	lw	s0,40(sp)
40f04418:	02412483          	lw	s1,36(sp)
40f0441c:	02012903          	lw	s2,32(sp)
40f04420:	01c12983          	lw	s3,28(sp)
40f04424:	01812a03          	lw	s4,24(sp)
40f04428:	01412a83          	lw	s5,20(sp)
40f0442c:	01012b03          	lw	s6,16(sp)
40f04430:	00c12b83          	lw	s7,12(sp)
40f04434:	00812c03          	lw	s8,8(sp)
40f04438:	03010113          	addi	sp,sp,48
40f0443c:	00008067          	ret
	pmpcfg	= (csr_read_num(pmpcfg_csr) & cfgmask);
40f04440:	000a0513          	mv	a0,s4
40f04444:	d35ff0ef          	jal	ra,40f04178 <csr_read_num>
	prot |= (log2len == PMP_SHIFT) ? PMP_A_NA4 : PMP_A_NAPOT;
40f04448:	0104e593          	ori	a1,s1,16
	pmpcfg |= ((prot << pmpcfg_shift) & ~cfgmask);
40f0444c:	017595b3          	sll	a1,a1,s7
40f04450:	00b54533          	xor	a0,a0,a1
40f04454:	01557ab3          	and	s5,a0,s5
40f04458:	00bacab3          	xor	s5,s5,a1
		pmpaddr = (addr >> PMP_SHIFT);
40f0445c:	0029d593          	srli	a1,s3,0x2
40f04460:	f99ff06f          	j	40f043f8 <pmp_set+0xc0>
		return SBI_EINVAL;
40f04464:	ffd00513          	li	a0,-3
}
40f04468:	00008067          	ret
		return SBI_EINVAL;
40f0446c:	ffd00513          	li	a0,-3
40f04470:	fa1ff06f          	j	40f04410 <pmp_set+0xd8>

40f04474 <pmp_get>:
	int pmpcfg_csr, pmpcfg_shift, pmpaddr_csr;
	unsigned long cfgmask, pmpcfg, prot;
	unsigned long t1, addr, log2len;

	/* check parameters */
	if (n >= PMP_COUNT || !prot_out || !addr_out || !log2len_out)
40f04474:	00f00793          	li	a5,15
40f04478:	12a7e663          	bltu	a5,a0,40f045a4 <pmp_get+0x130>
40f0447c:	12058463          	beqz	a1,40f045a4 <pmp_get+0x130>
40f04480:	12060263          	beqz	a2,40f045a4 <pmp_get+0x130>
40f04484:	12068063          	beqz	a3,40f045a4 <pmp_get+0x130>
{
40f04488:	fe010113          	addi	sp,sp,-32
40f0448c:	00812c23          	sw	s0,24(sp)
40f04490:	00912a23          	sw	s1,20(sp)
40f04494:	01212823          	sw	s2,16(sp)
40f04498:	01312623          	sw	s3,12(sp)
40f0449c:	01412423          	sw	s4,8(sp)
40f044a0:	01512223          	sw	s5,4(sp)
40f044a4:	01612023          	sw	s6,0(sp)
40f044a8:	00112e23          	sw	ra,28(sp)
40f044ac:	02010413          	addi	s0,sp,32
40f044b0:	00050793          	mv	a5,a0
		return SBI_EINVAL;
	*prot_out = *addr_out = *log2len_out = 0;
40f044b4:	0006a023          	sw	zero,0(a3)

	/* calculate PMP register and offset */
#if __riscv_xlen == 32
	pmpcfg_csr   = CSR_PMPCFG0 + (n >> 2);
	pmpcfg_shift = (n & 3) << 3;
40f044b8:	00379913          	slli	s2,a5,0x3
	*prot_out = *addr_out = *log2len_out = 0;
40f044bc:	00062023          	sw	zero,0(a2)
	pmpcfg_csr   = CSR_PMPCFG0 + (n >> 2);
40f044c0:	00255513          	srli	a0,a0,0x2
	pmpcfg_shift = (n & 3) << 3;
40f044c4:	01897b13          	andi	s6,s2,24
	*prot_out = *addr_out = *log2len_out = 0;
40f044c8:	0005a023          	sw	zero,0(a1)
	if (pmpcfg_csr < 0 || pmpcfg_shift < 0)
		return SBI_ENOTSUPP;

	/* decode PMP config */
	cfgmask = (0xff << pmpcfg_shift);
	pmpcfg	= csr_read_num(pmpcfg_csr) & cfgmask;
40f044cc:	3a050513          	addi	a0,a0,928
	cfgmask = (0xff << pmpcfg_shift);
40f044d0:	0ff00913          	li	s2,255
	pmpaddr_csr = CSR_PMPADDR0 + n;
40f044d4:	3b078493          	addi	s1,a5,944
	pmpcfg	= csr_read_num(pmpcfg_csr) & cfgmask;
40f044d8:	00068a93          	mv	s5,a3
40f044dc:	00060a13          	mv	s4,a2
40f044e0:	00058993          	mv	s3,a1
	cfgmask = (0xff << pmpcfg_shift);
40f044e4:	01691933          	sll	s2,s2,s6
	pmpcfg	= csr_read_num(pmpcfg_csr) & cfgmask;
40f044e8:	c91ff0ef          	jal	ra,40f04178 <csr_read_num>
40f044ec:	00a97933          	and	s2,s2,a0
	prot	= pmpcfg >> pmpcfg_shift;
40f044f0:	01695933          	srl	s2,s2,s6

	/* decode PMP address */
	if ((prot & PMP_A) == PMP_A_NAPOT) {
40f044f4:	01897713          	andi	a4,s2,24
40f044f8:	01800793          	li	a5,24
		addr = csr_read_num(pmpaddr_csr);
40f044fc:	00048513          	mv	a0,s1
	if ((prot & PMP_A) == PMP_A_NAPOT) {
40f04500:	04f70463          	beq	a4,a5,40f04548 <pmp_get+0xd4>
			t1	= ctz(~addr);
			addr	= (addr & ~((1UL << t1) - 1)) << PMP_SHIFT;
			log2len = (t1 + PMP_SHIFT + 1);
		}
	} else {
		addr	= csr_read_num(pmpaddr_csr) << PMP_SHIFT;
40f04504:	c75ff0ef          	jal	ra,40f04178 <csr_read_num>
40f04508:	00251513          	slli	a0,a0,0x2
		log2len = PMP_SHIFT;
40f0450c:	00200793          	li	a5,2
	}

	/* return details */
	*prot_out    = prot;
40f04510:	0129a023          	sw	s2,0(s3)
	*addr_out    = addr;
40f04514:	00aa2023          	sw	a0,0(s4)
	*log2len_out = log2len;
40f04518:	00faa023          	sw	a5,0(s5)

	return 0;
}
40f0451c:	01c12083          	lw	ra,28(sp)
40f04520:	01812403          	lw	s0,24(sp)
40f04524:	01412483          	lw	s1,20(sp)
40f04528:	01012903          	lw	s2,16(sp)
40f0452c:	00c12983          	lw	s3,12(sp)
40f04530:	00812a03          	lw	s4,8(sp)
40f04534:	00412a83          	lw	s5,4(sp)
40f04538:	00012b03          	lw	s6,0(sp)
	return 0;
40f0453c:	00000513          	li	a0,0
}
40f04540:	02010113          	addi	sp,sp,32
40f04544:	00008067          	ret
		addr = csr_read_num(pmpaddr_csr);
40f04548:	c31ff0ef          	jal	ra,40f04178 <csr_read_num>
		if (addr == -1UL) {
40f0454c:	fff00793          	li	a5,-1
40f04550:	04f50463          	beq	a0,a5,40f04598 <pmp_get+0x124>
			t1	= ctz(~addr);
40f04554:	fff54713          	not	a4,a0
	while (!(x & 1UL)) {
40f04558:	00177793          	andi	a5,a4,1
40f0455c:	00078a63          	beqz	a5,40f04570 <pmp_get+0xfc>
40f04560:	00300793          	li	a5,3
			addr	= (addr & ~((1UL << t1) - 1)) << PMP_SHIFT;
40f04564:	00251513          	slli	a0,a0,0x2
			log2len = (t1 + PMP_SHIFT + 1);
40f04568:	fa9ff06f          	j	40f04510 <pmp_get+0x9c>
		ret++;
40f0456c:	00060793          	mv	a5,a2
		x = x >> 1;
40f04570:	00175713          	srli	a4,a4,0x1
	while (!(x & 1UL)) {
40f04574:	00177693          	andi	a3,a4,1
		ret++;
40f04578:	00178613          	addi	a2,a5,1
	while (!(x & 1UL)) {
40f0457c:	fe0688e3          	beqz	a3,40f0456c <pmp_get+0xf8>
40f04580:	fff00713          	li	a4,-1
40f04584:	00c71633          	sll	a2,a4,a2
40f04588:	00c57533          	and	a0,a0,a2
40f0458c:	00478793          	addi	a5,a5,4
			addr	= (addr & ~((1UL << t1) - 1)) << PMP_SHIFT;
40f04590:	00251513          	slli	a0,a0,0x2
			log2len = (t1 + PMP_SHIFT + 1);
40f04594:	f7dff06f          	j	40f04510 <pmp_get+0x9c>
			log2len = __riscv_xlen;
40f04598:	02000793          	li	a5,32
			addr	= 0;
40f0459c:	00000513          	li	a0,0
40f045a0:	f71ff06f          	j	40f04510 <pmp_get+0x9c>
		return SBI_EINVAL;
40f045a4:	ffd00513          	li	a0,-3
}
40f045a8:	00008067          	ret

40f045ac <atomic_read>:
#include <sbi/riscv_atomic.h>
#include <sbi/riscv_barrier.h>
#include <sbi/sbi_bits.h>

long atomic_read(atomic_t *atom)
{
40f045ac:	ff010113          	addi	sp,sp,-16
40f045b0:	00812623          	sw	s0,12(sp)
40f045b4:	01010413          	addi	s0,sp,16
	long ret = atom->counter;
40f045b8:	00052503          	lw	a0,0(a0)
	rmb();
40f045bc:	0aa0000f          	fence	ir,ir
	return ret;
}
40f045c0:	00c12403          	lw	s0,12(sp)
40f045c4:	01010113          	addi	sp,sp,16
40f045c8:	00008067          	ret

40f045cc <atomic_write>:

void atomic_write(atomic_t *atom, long value)
{
40f045cc:	ff010113          	addi	sp,sp,-16
40f045d0:	00812623          	sw	s0,12(sp)
40f045d4:	01010413          	addi	s0,sp,16
	atom->counter = value;
40f045d8:	00b52023          	sw	a1,0(a0)
	wmb();
40f045dc:	0550000f          	fence	ow,ow
}
40f045e0:	00c12403          	lw	s0,12(sp)
40f045e4:	01010113          	addi	sp,sp,16
40f045e8:	00008067          	ret

40f045ec <atomic_add_return>:

long atomic_add_return(atomic_t *atom, long value)
{
40f045ec:	ff010113          	addi	sp,sp,-16
40f045f0:	00812623          	sw	s0,12(sp)
40f045f4:	01010413          	addi	s0,sp,16
	long ret;

	__asm__ __volatile__("	amoadd.w.aqrl  %1, %2, %0"
40f045f8:	06b527af          	amoadd.w.aqrl	a5,a1,(a0)
			     : "+A"(atom->counter), "=r"(ret)
			     : "r"(value)
			     : "memory");

	return ret + value;
}
40f045fc:	00c12403          	lw	s0,12(sp)
40f04600:	00f58533          	add	a0,a1,a5
40f04604:	01010113          	addi	sp,sp,16
40f04608:	00008067          	ret

40f0460c <atomic_sub_return>:

long atomic_sub_return(atomic_t *atom, long value)
{
40f0460c:	ff010113          	addi	sp,sp,-16
40f04610:	00812623          	sw	s0,12(sp)
40f04614:	01010413          	addi	s0,sp,16
	long ret;

	__asm__ __volatile__("	amoadd.w.aqrl  %1, %2, %0"
			     : "+A"(atom->counter), "=r"(ret)
			     : "r"(-value)
40f04618:	40b007b3          	neg	a5,a1
	__asm__ __volatile__("	amoadd.w.aqrl  %1, %2, %0"
40f0461c:	06f527af          	amoadd.w.aqrl	a5,a5,(a0)
			     : "memory");

	return ret - value;
}
40f04620:	00c12403          	lw	s0,12(sp)
40f04624:	40b78533          	sub	a0,a5,a1
40f04628:	01010113          	addi	sp,sp,16
40f0462c:	00008067          	ret

40f04630 <arch_atomic_cmpxchg>:
		(__typeof__(*(ptr)))                                \
			__cmpxchg((ptr), _o_, _n_, sizeof(*(ptr))); \
	})

long arch_atomic_cmpxchg(atomic_t *atom, long oldval, long newval)
{
40f04630:	ff010113          	addi	sp,sp,-16
40f04634:	00812623          	sw	s0,12(sp)
40f04638:	01010413          	addi	s0,sp,16
40f0463c:	00050793          	mv	a5,a0
#ifdef __riscv_atomic
	return __sync_val_compare_and_swap(&atom->counter, oldval, newval);
40f04640:	0f50000f          	fence	iorw,ow
40f04644:	1407a52f          	lr.w.aq	a0,(a5)
40f04648:	00b51663          	bne	a0,a1,40f04654 <arch_atomic_cmpxchg+0x24>
40f0464c:	1cc7a72f          	sc.w.aq	a4,a2,(a5)
40f04650:	fe071ae3          	bnez	a4,40f04644 <arch_atomic_cmpxchg+0x14>
#else
	return cmpxchg(&atom->counter, oldval, newval);
#endif
}
40f04654:	00c12403          	lw	s0,12(sp)
40f04658:	01010113          	addi	sp,sp,16
40f0465c:	00008067          	ret

40f04660 <arch_atomic_xchg>:

long arch_atomic_xchg(atomic_t *atom, long newval)
{
40f04660:	fe010113          	addi	sp,sp,-32
40f04664:	00812e23          	sw	s0,28(sp)
40f04668:	02010413          	addi	s0,sp,32
	/* Atomically set new value and return old value. */
#ifdef __riscv_atomic
	return axchg(&atom->counter, newval);
40f0466c:	feb42223          	sw	a1,-28(s0)
40f04670:	fe442783          	lw	a5,-28(s0)
40f04674:	fef42423          	sw	a5,-24(s0)
40f04678:	fe842783          	lw	a5,-24(s0)
40f0467c:	0ef527af          	amoswap.w.aqrl	a5,a5,(a0)
40f04680:	fef42623          	sw	a5,-20(s0)
40f04684:	fec42503          	lw	a0,-20(s0)
#else
	return xchg(&atom->counter, newval);
#endif
}
40f04688:	01c12403          	lw	s0,28(sp)
40f0468c:	02010113          	addi	sp,sp,32
40f04690:	00008067          	ret

40f04694 <atomic_raw_xchg_uint>:

unsigned int atomic_raw_xchg_uint(volatile unsigned int *ptr,
				  unsigned int newval)
{
40f04694:	fe010113          	addi	sp,sp,-32
40f04698:	00812e23          	sw	s0,28(sp)
40f0469c:	02010413          	addi	s0,sp,32
	/* Atomically set new value and return old value. */
#ifdef __riscv_atomic
	return axchg(ptr, newval);
40f046a0:	feb42223          	sw	a1,-28(s0)
40f046a4:	fe442783          	lw	a5,-28(s0)
40f046a8:	fef42423          	sw	a5,-24(s0)
40f046ac:	fe842783          	lw	a5,-24(s0)
40f046b0:	0ef527af          	amoswap.w.aqrl	a5,a5,(a0)
40f046b4:	fef42623          	sw	a5,-20(s0)
40f046b8:	fec42503          	lw	a0,-20(s0)
#else
	return xchg(ptr, newval);
#endif
}
40f046bc:	01c12403          	lw	s0,28(sp)
40f046c0:	02010113          	addi	sp,sp,32
40f046c4:	00008067          	ret

40f046c8 <atomic_raw_xchg_ulong>:

unsigned long atomic_raw_xchg_ulong(volatile unsigned long *ptr,
				    unsigned long newval)
{
40f046c8:	fe010113          	addi	sp,sp,-32
40f046cc:	00812e23          	sw	s0,28(sp)
40f046d0:	02010413          	addi	s0,sp,32
	/* Atomically set new value and return old value. */
#ifdef __riscv_atomic
	return axchg(ptr, newval);
40f046d4:	feb42223          	sw	a1,-28(s0)
40f046d8:	fe442783          	lw	a5,-28(s0)
40f046dc:	fef42423          	sw	a5,-24(s0)
40f046e0:	fe842783          	lw	a5,-24(s0)
40f046e4:	0ef527af          	amoswap.w.aqrl	a5,a5,(a0)
40f046e8:	fef42623          	sw	a5,-20(s0)
40f046ec:	fec42503          	lw	a0,-20(s0)
#else
	return xchg(ptr, newval);
#endif
}
40f046f0:	01c12403          	lw	s0,28(sp)
40f046f4:	02010113          	addi	sp,sp,32
40f046f8:	00008067          	ret

40f046fc <atomic_raw_set_bit>:
#define __NOP(x) (x)
#define __NOT(x) (~(x))

inline int atomic_raw_set_bit(int nr, volatile unsigned long *addr)
{
	return __atomic_op_bit(or, __NOP, nr, addr);
40f046fc:	41f55793          	srai	a5,a0,0x1f
40f04700:	01b7d693          	srli	a3,a5,0x1b
40f04704:	01f7f793          	andi	a5,a5,31
40f04708:	00d50733          	add	a4,a0,a3
40f0470c:	00a787b3          	add	a5,a5,a0
{
40f04710:	ff010113          	addi	sp,sp,-16
	return __atomic_op_bit(or, __NOP, nr, addr);
40f04714:	01f77713          	andi	a4,a4,31
40f04718:	4057d793          	srai	a5,a5,0x5
{
40f0471c:	00812623          	sw	s0,12(sp)
	return __atomic_op_bit(or, __NOP, nr, addr);
40f04720:	40d70733          	sub	a4,a4,a3
{
40f04724:	01010413          	addi	s0,sp,16
	return __atomic_op_bit(or, __NOP, nr, addr);
40f04728:	00279793          	slli	a5,a5,0x2
40f0472c:	00100513          	li	a0,1
40f04730:	00e51533          	sll	a0,a0,a4
40f04734:	00f585b3          	add	a1,a1,a5
40f04738:	46a5a52f          	amoor.w.aqrl	a0,a0,(a1)
}
40f0473c:	00c12403          	lw	s0,12(sp)
40f04740:	01010113          	addi	sp,sp,16
40f04744:	00008067          	ret

40f04748 <atomic_raw_clear_bit>:

inline int atomic_raw_clear_bit(int nr, volatile unsigned long *addr)
{
	return __atomic_op_bit(and, __NOT, nr, addr);
40f04748:	41f55793          	srai	a5,a0,0x1f
40f0474c:	01b7d693          	srli	a3,a5,0x1b
40f04750:	00d50733          	add	a4,a0,a3
40f04754:	01f7f793          	andi	a5,a5,31
40f04758:	00a787b3          	add	a5,a5,a0
40f0475c:	01f77713          	andi	a4,a4,31
{
40f04760:	ff010113          	addi	sp,sp,-16
	return __atomic_op_bit(and, __NOT, nr, addr);
40f04764:	40d70733          	sub	a4,a4,a3
40f04768:	4057d793          	srai	a5,a5,0x5
40f0476c:	00100513          	li	a0,1
{
40f04770:	00812623          	sw	s0,12(sp)
	return __atomic_op_bit(and, __NOT, nr, addr);
40f04774:	00279793          	slli	a5,a5,0x2
{
40f04778:	01010413          	addi	s0,sp,16
	return __atomic_op_bit(and, __NOT, nr, addr);
40f0477c:	00e51533          	sll	a0,a0,a4
40f04780:	00f585b3          	add	a1,a1,a5
40f04784:	fff54513          	not	a0,a0
40f04788:	66a5a52f          	amoand.w.aqrl	a0,a0,(a1)
}
40f0478c:	00c12403          	lw	s0,12(sp)
40f04790:	01010113          	addi	sp,sp,16
40f04794:	00008067          	ret

40f04798 <atomic_set_bit>:
	return __atomic_op_bit(or, __NOP, nr, addr);
40f04798:	41f55793          	srai	a5,a0,0x1f
40f0479c:	01b7d693          	srli	a3,a5,0x1b
40f047a0:	01f7f793          	andi	a5,a5,31
40f047a4:	00d50733          	add	a4,a0,a3
40f047a8:	00a787b3          	add	a5,a5,a0

inline int atomic_set_bit(int nr, atomic_t *atom)
{
40f047ac:	ff010113          	addi	sp,sp,-16
	return __atomic_op_bit(or, __NOP, nr, addr);
40f047b0:	01f77713          	andi	a4,a4,31
40f047b4:	4057d793          	srai	a5,a5,0x5
{
40f047b8:	00812623          	sw	s0,12(sp)
	return __atomic_op_bit(or, __NOP, nr, addr);
40f047bc:	40d70733          	sub	a4,a4,a3
{
40f047c0:	01010413          	addi	s0,sp,16
	return __atomic_op_bit(or, __NOP, nr, addr);
40f047c4:	00279793          	slli	a5,a5,0x2
40f047c8:	00100513          	li	a0,1
40f047cc:	00e51533          	sll	a0,a0,a4
40f047d0:	00f585b3          	add	a1,a1,a5
40f047d4:	46a5a52f          	amoor.w.aqrl	a0,a0,(a1)
	return atomic_raw_set_bit(nr, (unsigned long *)&atom->counter);
}
40f047d8:	00c12403          	lw	s0,12(sp)
40f047dc:	01010113          	addi	sp,sp,16
40f047e0:	00008067          	ret

40f047e4 <atomic_clear_bit>:
	return __atomic_op_bit(and, __NOT, nr, addr);
40f047e4:	41f55793          	srai	a5,a0,0x1f
40f047e8:	01b7d693          	srli	a3,a5,0x1b
40f047ec:	00d50733          	add	a4,a0,a3
40f047f0:	01f7f793          	andi	a5,a5,31
40f047f4:	00a787b3          	add	a5,a5,a0
40f047f8:	01f77713          	andi	a4,a4,31

inline int atomic_clear_bit(int nr, atomic_t *atom)
{
40f047fc:	ff010113          	addi	sp,sp,-16
	return __atomic_op_bit(and, __NOT, nr, addr);
40f04800:	40d70733          	sub	a4,a4,a3
40f04804:	4057d793          	srai	a5,a5,0x5
40f04808:	00100513          	li	a0,1
{
40f0480c:	00812623          	sw	s0,12(sp)
	return __atomic_op_bit(and, __NOT, nr, addr);
40f04810:	00279793          	slli	a5,a5,0x2
{
40f04814:	01010413          	addi	s0,sp,16
	return __atomic_op_bit(and, __NOT, nr, addr);
40f04818:	00e51533          	sll	a0,a0,a4
40f0481c:	00f585b3          	add	a1,a1,a5
40f04820:	fff54513          	not	a0,a0
40f04824:	66a5a52f          	amoand.w.aqrl	a0,a0,(a1)
	return atomic_raw_clear_bit(nr, (unsigned long *)&atom->counter);
}
40f04828:	00c12403          	lw	s0,12(sp)
40f0482c:	01010113          	addi	sp,sp,16
40f04830:	00008067          	ret

40f04834 <spin_lock_check>:

#include <sbi/riscv_barrier.h>
#include <sbi/riscv_locks.h>

int spin_lock_check(spinlock_t *lock)
{
40f04834:	ff010113          	addi	sp,sp,-16
40f04838:	00812623          	sw	s0,12(sp)
40f0483c:	01010413          	addi	s0,sp,16
	return (lock->lock == __RISCV_SPIN_UNLOCKED) ? 0 : 1;
40f04840:	00052503          	lw	a0,0(a0)
}
40f04844:	00c12403          	lw	s0,12(sp)
40f04848:	00a03533          	snez	a0,a0
40f0484c:	01010113          	addi	sp,sp,16
40f04850:	00008067          	ret

40f04854 <spin_trylock>:

int spin_trylock(spinlock_t *lock)
{
40f04854:	ff010113          	addi	sp,sp,-16
40f04858:	00812623          	sw	s0,12(sp)
40f0485c:	01010413          	addi	s0,sp,16
	int tmp = 1, busy;

	__asm__ __volatile__(
40f04860:	00100793          	li	a5,1
40f04864:	08f527af          	amoswap.w	a5,a5,(a0)
40f04868:	0230000f          	fence	r,rw
		: "=r"(busy), "+A"(lock->lock)
		: "r"(tmp)
		: "memory");

	return !busy;
}
40f0486c:	00c12403          	lw	s0,12(sp)
40f04870:	0017b513          	seqz	a0,a5
40f04874:	01010113          	addi	sp,sp,16
40f04878:	00008067          	ret

40f0487c <spin_lock>:

void spin_lock(spinlock_t *lock)
{
40f0487c:	ff010113          	addi	sp,sp,-16
40f04880:	00812623          	sw	s0,12(sp)
40f04884:	01010413          	addi	s0,sp,16
	__asm__ __volatile__(
40f04888:	00100713          	li	a4,1
	return (lock->lock == __RISCV_SPIN_UNLOCKED) ? 0 : 1;
40f0488c:	00052783          	lw	a5,0(a0)
	while (1) {
		if (spin_lock_check(lock))
40f04890:	fe079ee3          	bnez	a5,40f0488c <spin_lock+0x10>
	__asm__ __volatile__(
40f04894:	08e527af          	amoswap.w	a5,a4,(a0)
40f04898:	0230000f          	fence	r,rw
			continue;

		if (spin_trylock(lock))
40f0489c:	fe0798e3          	bnez	a5,40f0488c <spin_lock+0x10>
			break;
	}
}
40f048a0:	00c12403          	lw	s0,12(sp)
40f048a4:	01010113          	addi	sp,sp,16
40f048a8:	00008067          	ret

40f048ac <spin_unlock>:

void spin_unlock(spinlock_t *lock)
{
40f048ac:	ff010113          	addi	sp,sp,-16
40f048b0:	00812623          	sw	s0,12(sp)
40f048b4:	01010413          	addi	s0,sp,16
	__smp_store_release(&lock->lock, __RISCV_SPIN_UNLOCKED);
40f048b8:	0310000f          	fence	rw,w
}
40f048bc:	00c12403          	lw	s0,12(sp)
	__smp_store_release(&lock->lock, __RISCV_SPIN_UNLOCKED);
40f048c0:	00052023          	sw	zero,0(a0)
}
40f048c4:	01010113          	addi	sp,sp,16
40f048c8:	00008067          	ret

40f048cc <sbi_isprintable>:

static const struct sbi_platform *console_plat = NULL;
static spinlock_t console_out_lock	       = SPIN_LOCK_INITIALIZER;

bool sbi_isprintable(char c)
{
40f048cc:	ff010113          	addi	sp,sp,-16
40f048d0:	00812623          	sw	s0,12(sp)
	if (((31 < c) && (c < 127)) || (c == '\f') || (c == '\r') ||
40f048d4:	fe050793          	addi	a5,a0,-32
{
40f048d8:	01010413          	addi	s0,sp,16
	if (((31 < c) && (c < 127)) || (c == '\f') || (c == '\r') ||
40f048dc:	0ff7f793          	andi	a5,a5,255
40f048e0:	05e00713          	li	a4,94
40f048e4:	02f77663          	bgeu	a4,a5,40f04910 <sbi_isprintable+0x44>
40f048e8:	ff450713          	addi	a4,a0,-12
40f048ec:	0ff77713          	andi	a4,a4,255
	    (c == '\n') || (c == '\t')) {
		return TRUE;
40f048f0:	00100793          	li	a5,1
	if (((31 < c) && (c < 127)) || (c == '\f') || (c == '\r') ||
40f048f4:	00e7f663          	bgeu	a5,a4,40f04900 <sbi_isprintable+0x34>
	    (c == '\n') || (c == '\t')) {
40f048f8:	ff750513          	addi	a0,a0,-9
40f048fc:	00253793          	sltiu	a5,a0,2
	}
	return FALSE;
}
40f04900:	00c12403          	lw	s0,12(sp)
40f04904:	00078513          	mv	a0,a5
40f04908:	01010113          	addi	sp,sp,16
40f0490c:	00008067          	ret
40f04910:	00c12403          	lw	s0,12(sp)
		return TRUE;
40f04914:	00100793          	li	a5,1
}
40f04918:	00078513          	mv	a0,a5
40f0491c:	01010113          	addi	sp,sp,16
40f04920:	00008067          	ret

40f04924 <sbi_getc>:

int sbi_getc(void)
{
	return sbi_platform_console_getc(console_plat);
40f04924:	00007797          	auipc	a5,0x7
40f04928:	70478793          	addi	a5,a5,1796 # 40f0c028 <console_plat>
40f0492c:	0007a703          	lw	a4,0(a5)
	if (plat && sbi_platform_ops(plat)->console_getc)
40f04930:	06070e63          	beqz	a4,40f049ac <sbi_getc+0x88>
40f04934:	06174603          	lbu	a2,97(a4)
40f04938:	06274683          	lbu	a3,98(a4)
40f0493c:	06074583          	lbu	a1,96(a4)
40f04940:	06374783          	lbu	a5,99(a4)
40f04944:	00861713          	slli	a4,a2,0x8
40f04948:	00b76633          	or	a2,a4,a1
40f0494c:	01069713          	slli	a4,a3,0x10
40f04950:	00c76733          	or	a4,a4,a2
40f04954:	01879793          	slli	a5,a5,0x18
40f04958:	00e7e7b3          	or	a5,a5,a4
40f0495c:	0257c683          	lbu	a3,37(a5)
40f04960:	0247c603          	lbu	a2,36(a5)
40f04964:	0267c703          	lbu	a4,38(a5)
40f04968:	0277c783          	lbu	a5,39(a5)
40f0496c:	00869693          	slli	a3,a3,0x8
40f04970:	00c6e6b3          	or	a3,a3,a2
40f04974:	01071713          	slli	a4,a4,0x10
40f04978:	00d76733          	or	a4,a4,a3
40f0497c:	01879793          	slli	a5,a5,0x18
40f04980:	00e7e7b3          	or	a5,a5,a4
40f04984:	02078463          	beqz	a5,40f049ac <sbi_getc+0x88>
{
40f04988:	ff010113          	addi	sp,sp,-16
40f0498c:	00812423          	sw	s0,8(sp)
40f04990:	00112623          	sw	ra,12(sp)
40f04994:	01010413          	addi	s0,sp,16
		return sbi_platform_ops(plat)->console_getc();
40f04998:	000780e7          	jalr	a5
}
40f0499c:	00c12083          	lw	ra,12(sp)
40f049a0:	00812403          	lw	s0,8(sp)
40f049a4:	01010113          	addi	sp,sp,16
40f049a8:	00008067          	ret
	return -1;
40f049ac:	fff00513          	li	a0,-1
40f049b0:	00008067          	ret

40f049b4 <sbi_putc>:

void sbi_putc(char ch)
{
40f049b4:	ff010113          	addi	sp,sp,-16
40f049b8:	00812423          	sw	s0,8(sp)
40f049bc:	00912223          	sw	s1,4(sp)
40f049c0:	01212023          	sw	s2,0(sp)
40f049c4:	00112623          	sw	ra,12(sp)
40f049c8:	01010413          	addi	s0,sp,16
40f049cc:	00007917          	auipc	s2,0x7
40f049d0:	65c90913          	addi	s2,s2,1628 # 40f0c028 <console_plat>
	if (ch == '\n')
40f049d4:	00a00713          	li	a4,10
{
40f049d8:	00050493          	mv	s1,a0
40f049dc:	00092783          	lw	a5,0(s2)
	if (ch == '\n')
40f049e0:	06e50e63          	beq	a0,a4,40f04a5c <sbi_putc+0xa8>
	if (plat && sbi_platform_ops(plat)->console_putc)
40f049e4:	06078063          	beqz	a5,40f04a44 <sbi_putc+0x90>
40f049e8:	0617c683          	lbu	a3,97(a5)
40f049ec:	0607c603          	lbu	a2,96(a5)
40f049f0:	0627c703          	lbu	a4,98(a5)
40f049f4:	0637c783          	lbu	a5,99(a5)
40f049f8:	00869693          	slli	a3,a3,0x8
40f049fc:	00c6e6b3          	or	a3,a3,a2
40f04a00:	01071713          	slli	a4,a4,0x10
40f04a04:	00d76733          	or	a4,a4,a3
40f04a08:	01879793          	slli	a5,a5,0x18
40f04a0c:	00e7e7b3          	or	a5,a5,a4
40f04a10:	0217c683          	lbu	a3,33(a5)
40f04a14:	0207c603          	lbu	a2,32(a5)
40f04a18:	0227c703          	lbu	a4,34(a5)
40f04a1c:	0237c783          	lbu	a5,35(a5)
40f04a20:	00869693          	slli	a3,a3,0x8
40f04a24:	00c6e6b3          	or	a3,a3,a2
40f04a28:	01071713          	slli	a4,a4,0x10
40f04a2c:	00d76733          	or	a4,a4,a3
40f04a30:	01879793          	slli	a5,a5,0x18
40f04a34:	00e7e7b3          	or	a5,a5,a4
40f04a38:	00078663          	beqz	a5,40f04a44 <sbi_putc+0x90>
		sbi_platform_ops(plat)->console_putc(ch);
40f04a3c:	00048513          	mv	a0,s1
40f04a40:	000780e7          	jalr	a5
		sbi_platform_console_putc(console_plat, '\r');
	sbi_platform_console_putc(console_plat, ch);
}
40f04a44:	00c12083          	lw	ra,12(sp)
40f04a48:	00812403          	lw	s0,8(sp)
40f04a4c:	00412483          	lw	s1,4(sp)
40f04a50:	00012903          	lw	s2,0(sp)
40f04a54:	01010113          	addi	sp,sp,16
40f04a58:	00008067          	ret
	if (plat && sbi_platform_ops(plat)->console_putc)
40f04a5c:	fe0784e3          	beqz	a5,40f04a44 <sbi_putc+0x90>
40f04a60:	0617c683          	lbu	a3,97(a5)
40f04a64:	0607c603          	lbu	a2,96(a5)
40f04a68:	0627c703          	lbu	a4,98(a5)
40f04a6c:	0637c783          	lbu	a5,99(a5)
40f04a70:	00869693          	slli	a3,a3,0x8
40f04a74:	00c6e6b3          	or	a3,a3,a2
40f04a78:	01071713          	slli	a4,a4,0x10
40f04a7c:	00d76733          	or	a4,a4,a3
40f04a80:	01879793          	slli	a5,a5,0x18
40f04a84:	00e7e7b3          	or	a5,a5,a4
40f04a88:	0217c683          	lbu	a3,33(a5)
40f04a8c:	0207c603          	lbu	a2,32(a5)
40f04a90:	0227c703          	lbu	a4,34(a5)
40f04a94:	0237c783          	lbu	a5,35(a5)
40f04a98:	00869693          	slli	a3,a3,0x8
40f04a9c:	00c6e6b3          	or	a3,a3,a2
40f04aa0:	01071713          	slli	a4,a4,0x10
40f04aa4:	00d76733          	or	a4,a4,a3
40f04aa8:	01879793          	slli	a5,a5,0x18
40f04aac:	00e7e7b3          	or	a5,a5,a4
40f04ab0:	f8078ae3          	beqz	a5,40f04a44 <sbi_putc+0x90>
		sbi_platform_ops(plat)->console_putc(ch);
40f04ab4:	00d00513          	li	a0,13
40f04ab8:	000780e7          	jalr	a5
40f04abc:	00092783          	lw	a5,0(s2)
40f04ac0:	f25ff06f          	j	40f049e4 <sbi_putc+0x30>

40f04ac4 <printc>:
#define va_arg __builtin_va_arg
typedef __builtin_va_list va_list;

static void printc(char **out, u32 *out_len, char ch)
{
	if (out) {
40f04ac4:	04050863          	beqz	a0,40f04b14 <printc+0x50>
		if (*out) {
40f04ac8:	00052783          	lw	a5,0(a0)
40f04acc:	02078863          	beqz	a5,40f04afc <printc+0x38>
			if (out_len && (0 < *out_len)) {
40f04ad0:	02058863          	beqz	a1,40f04b00 <printc+0x3c>
40f04ad4:	0005a703          	lw	a4,0(a1)
40f04ad8:	02070463          	beqz	a4,40f04b00 <printc+0x3c>
				**out = ch;
40f04adc:	00c78023          	sb	a2,0(a5)
				++(*out);
40f04ae0:	00052783          	lw	a5,0(a0)
40f04ae4:	00178793          	addi	a5,a5,1
40f04ae8:	00f52023          	sw	a5,0(a0)
				(*out_len)--;
40f04aec:	0005a783          	lw	a5,0(a1)
40f04af0:	fff78793          	addi	a5,a5,-1
40f04af4:	00f5a023          	sw	a5,0(a1)
40f04af8:	00008067          	ret
40f04afc:	00008067          	ret
			} else {
				**out = ch;
40f04b00:	00c78023          	sb	a2,0(a5)
				++(*out);
40f04b04:	00052783          	lw	a5,0(a0)
40f04b08:	00178793          	addi	a5,a5,1
40f04b0c:	00f52023          	sw	a5,0(a0)
40f04b10:	00008067          	ret
{
40f04b14:	ff010113          	addi	sp,sp,-16
40f04b18:	00812423          	sw	s0,8(sp)
40f04b1c:	00112623          	sw	ra,12(sp)
40f04b20:	01010413          	addi	s0,sp,16
40f04b24:	00060513          	mv	a0,a2
			}
		}
	} else {
		sbi_putc(ch);
40f04b28:	e8dff0ef          	jal	ra,40f049b4 <sbi_putc>
	}
}
40f04b2c:	00c12083          	lw	ra,12(sp)
40f04b30:	00812403          	lw	s0,8(sp)
40f04b34:	01010113          	addi	sp,sp,16
40f04b38:	00008067          	ret

40f04b3c <prints>:

static int prints(char **out, u32 *out_len, const char *string, int width,
		  int flags)
{
40f04b3c:	fd010113          	addi	sp,sp,-48
40f04b40:	02812423          	sw	s0,40(sp)
40f04b44:	02912223          	sw	s1,36(sp)
40f04b48:	03212023          	sw	s2,32(sp)
40f04b4c:	01312e23          	sw	s3,28(sp)
40f04b50:	01412c23          	sw	s4,24(sp)
40f04b54:	02112623          	sw	ra,44(sp)
40f04b58:	01512a23          	sw	s5,20(sp)
40f04b5c:	01612823          	sw	s6,16(sp)
40f04b60:	01712623          	sw	s7,12(sp)
40f04b64:	03010413          	addi	s0,sp,48
40f04b68:	00060493          	mv	s1,a2
40f04b6c:	00068a13          	mv	s4,a3
40f04b70:	00050913          	mv	s2,a0
40f04b74:	00058993          	mv	s3,a1
	int pc	     = 0;
	char padchar = ' ';

	if (width > 0) {
40f04b78:	00064603          	lbu	a2,0(a2)
40f04b7c:	0ed05c63          	blez	a3,40f04c74 <prints+0x138>
		int len = 0;
		const char *ptr;
		for (ptr = string; *ptr; ++ptr)
40f04b80:	10060c63          	beqz	a2,40f04c98 <prints+0x15c>
		int len = 0;
40f04b84:	00000793          	li	a5,0
			++len;
40f04b88:	00178793          	addi	a5,a5,1
		for (ptr = string; *ptr; ++ptr)
40f04b8c:	00f486b3          	add	a3,s1,a5
40f04b90:	0006c683          	lbu	a3,0(a3)
40f04b94:	fe069ae3          	bnez	a3,40f04b88 <prints+0x4c>
		if (len >= width)
40f04b98:	0147ce63          	blt	a5,s4,40f04bb4 <prints+0x78>
			width = 0;
		else
			width -= len;
		if (flags & PAD_ZERO)
40f04b9c:	00277b13          	andi	s6,a4,2
40f04ba0:	0e0b0063          	beqz	s6,40f04c80 <prints+0x144>
			padchar = '0';
40f04ba4:	03000b93          	li	s7,48
			width = 0;
40f04ba8:	00000a13          	li	s4,0
	int pc	     = 0;
40f04bac:	00000b13          	li	s6,0
40f04bb0:	04c0006f          	j	40f04bfc <prints+0xc0>
40f04bb4:	40fa0b33          	sub	s6,s4,a5
		if (flags & PAD_ZERO)
40f04bb8:	00277b93          	andi	s7,a4,2
			padchar = '0';
40f04bbc:	001bbb93          	seqz	s7,s7
40f04bc0:	41700bb3          	neg	s7,s7
40f04bc4:	ff0bfb93          	andi	s7,s7,-16
	}
	if (!(flags & PAD_RIGHT)) {
40f04bc8:	00177713          	andi	a4,a4,1
			padchar = '0';
40f04bcc:	030b8b93          	addi	s7,s7,48
		for (; width > 0; --width) {
40f04bd0:	000b0a13          	mv	s4,s6
	if (!(flags & PAD_RIGHT)) {
40f04bd4:	0a071c63          	bnez	a4,40f04c8c <prints+0x150>
		for (; width > 0; --width) {
40f04bd8:	0d605463          	blez	s6,40f04ca0 <prints+0x164>
40f04bdc:	fffa0a13          	addi	s4,s4,-1
			printc(out, out_len, padchar);
40f04be0:	000b8613          	mv	a2,s7
40f04be4:	00098593          	mv	a1,s3
40f04be8:	00090513          	mv	a0,s2
40f04bec:	ed9ff0ef          	jal	ra,40f04ac4 <printc>
		for (; width > 0; --width) {
40f04bf0:	fe0a16e3          	bnez	s4,40f04bdc <prints+0xa0>
40f04bf4:	0004c603          	lbu	a2,0(s1)
			++pc;
		}
	}
	for (; *string; ++string) {
40f04bf8:	04060663          	beqz	a2,40f04c44 <prints+0x108>
40f04bfc:	409b0ab3          	sub	s5,s6,s1
40f04c00:	001a8a93          	addi	s5,s5,1
		printc(out, out_len, *string);
40f04c04:	00098593          	mv	a1,s3
40f04c08:	00090513          	mv	a0,s2
40f04c0c:	01548b33          	add	s6,s1,s5
40f04c10:	eb5ff0ef          	jal	ra,40f04ac4 <printc>
	for (; *string; ++string) {
40f04c14:	00148493          	addi	s1,s1,1
40f04c18:	0004c603          	lbu	a2,0(s1)
40f04c1c:	fe0614e3          	bnez	a2,40f04c04 <prints+0xc8>
		++pc;
	}
	for (; width > 0; --width) {
40f04c20:	03405263          	blez	s4,40f04c44 <prints+0x108>
40f04c24:	000a0493          	mv	s1,s4
40f04c28:	fff48493          	addi	s1,s1,-1
		printc(out, out_len, padchar);
40f04c2c:	000b8613          	mv	a2,s7
40f04c30:	00098593          	mv	a1,s3
40f04c34:	00090513          	mv	a0,s2
40f04c38:	e8dff0ef          	jal	ra,40f04ac4 <printc>
	for (; width > 0; --width) {
40f04c3c:	fe0496e3          	bnez	s1,40f04c28 <prints+0xec>
40f04c40:	014b0b33          	add	s6,s6,s4
		++pc;
	}

	return pc;
}
40f04c44:	02c12083          	lw	ra,44(sp)
40f04c48:	02812403          	lw	s0,40(sp)
40f04c4c:	000b0513          	mv	a0,s6
40f04c50:	02412483          	lw	s1,36(sp)
40f04c54:	02012903          	lw	s2,32(sp)
40f04c58:	01c12983          	lw	s3,28(sp)
40f04c5c:	01812a03          	lw	s4,24(sp)
40f04c60:	01412a83          	lw	s5,20(sp)
40f04c64:	01012b03          	lw	s6,16(sp)
40f04c68:	00c12b83          	lw	s7,12(sp)
40f04c6c:	03010113          	addi	sp,sp,48
40f04c70:	00008067          	ret
	char padchar = ' ';
40f04c74:	02000b93          	li	s7,32
	int pc	     = 0;
40f04c78:	00000b13          	li	s6,0
40f04c7c:	f7dff06f          	j	40f04bf8 <prints+0xbc>
			width = 0;
40f04c80:	00000a13          	li	s4,0
	char padchar = ' ';
40f04c84:	02000b93          	li	s7,32
40f04c88:	f75ff06f          	j	40f04bfc <prints+0xc0>
	int pc	     = 0;
40f04c8c:	00000b13          	li	s6,0
	for (; *string; ++string) {
40f04c90:	f60616e3          	bnez	a2,40f04bfc <prints+0xc0>
40f04c94:	f8dff06f          	j	40f04c20 <prints+0xe4>
		for (ptr = string; *ptr; ++ptr)
40f04c98:	00068b13          	mv	s6,a3
40f04c9c:	f1dff06f          	j	40f04bb8 <prints+0x7c>
	int pc	     = 0;
40f04ca0:	00000b13          	li	s6,0
40f04ca4:	f55ff06f          	j	40f04bf8 <prints+0xbc>

40f04ca8 <printi>:

static int printi(char **out, u32 *out_len, long long i, int b, int sg,
		  int width, int flags, int letbase)
{
40f04ca8:	f7010113          	addi	sp,sp,-144
40f04cac:	08812423          	sw	s0,136(sp)
40f04cb0:	08912223          	sw	s1,132(sp)
40f04cb4:	09010413          	addi	s0,sp,144
40f04cb8:	09212023          	sw	s2,128(sp)
40f04cbc:	07312e23          	sw	s3,124(sp)
40f04cc0:	07412c23          	sw	s4,120(sp)
40f04cc4:	07512a23          	sw	s5,116(sp)
40f04cc8:	07612823          	sw	s6,112(sp)
40f04ccc:	08112623          	sw	ra,140(sp)
40f04cd0:	07712623          	sw	s7,108(sp)
40f04cd4:	07812423          	sw	s8,104(sp)
40f04cd8:	07912223          	sw	s9,100(sp)
40f04cdc:	07a12023          	sw	s10,96(sp)
40f04ce0:	05b12e23          	sw	s11,92(sp)
40f04ce4:	00078a13          	mv	s4,a5
40f04ce8:	0048f793          	andi	a5,a7,4
40f04cec:	f6a42e23          	sw	a0,-132(s0)
40f04cf0:	f6b42c23          	sw	a1,-136(s0)
40f04cf4:	f6f42a23          	sw	a5,-140(s0)
40f04cf8:	00088a93          	mv	s5,a7
40f04cfc:	00070993          	mv	s3,a4
40f04d00:	00080b13          	mv	s6,a6
	char print_buf[PRINT_BUF_LEN];
	char *s;
	int neg = 0, pc = 0;
	u64 t;
	unsigned long long u = i;
40f04d04:	00060913          	mv	s2,a2
40f04d08:	00068493          	mv	s1,a3

	if (sg && b == 10 && i < 0) {
40f04d0c:	000a0663          	beqz	s4,40f04d18 <printi+0x70>
40f04d10:	00a00793          	li	a5,10
40f04d14:	16f70a63          	beq	a4,a5,40f04e88 <printi+0x1e0>
		neg = 1;
		u   = -i;
	}

	s  = print_buf + PRINT_BUF_LEN - 1;
	*s = '\0';
40f04d18:	fa040fa3          	sb	zero,-65(s0)

	if (!u) {
40f04d1c:	00d66633          	or	a2,a2,a3
40f04d20:	0a061e63          	bnez	a2,40f04ddc <printi+0x134>
		*--s = '0';
40f04d24:	03000793          	li	a5,48
40f04d28:	faf40f23          	sb	a5,-66(s0)
				t += letbase - '0' - 10;
			*--s = t + '0';
		}
	}

	if (flags & PAD_ALTERNATE) {
40f04d2c:	004af793          	andi	a5,s5,4
40f04d30:	00000a13          	li	s4,0
		*--s = '0';
40f04d34:	fbe40d93          	addi	s11,s0,-66
	if (flags & PAD_ALTERNATE) {
40f04d38:	06079463          	bnez	a5,40f04da0 <printi+0xf8>
		} else {
			*--s = '-';
		}
	}

	return pc + prints(out, out_len, s, width, flags);
40f04d3c:	f7842583          	lw	a1,-136(s0)
40f04d40:	f7c42503          	lw	a0,-132(s0)
40f04d44:	000a8713          	mv	a4,s5
40f04d48:	000b0693          	mv	a3,s6
40f04d4c:	000d8613          	mv	a2,s11
40f04d50:	dedff0ef          	jal	ra,40f04b3c <prints>
}
40f04d54:	08c12083          	lw	ra,140(sp)
40f04d58:	08812403          	lw	s0,136(sp)
	return pc + prints(out, out_len, s, width, flags);
40f04d5c:	01450533          	add	a0,a0,s4
}
40f04d60:	08412483          	lw	s1,132(sp)
40f04d64:	08012903          	lw	s2,128(sp)
40f04d68:	07c12983          	lw	s3,124(sp)
40f04d6c:	07812a03          	lw	s4,120(sp)
40f04d70:	07412a83          	lw	s5,116(sp)
40f04d74:	07012b03          	lw	s6,112(sp)
40f04d78:	06c12b83          	lw	s7,108(sp)
40f04d7c:	06812c03          	lw	s8,104(sp)
40f04d80:	06412c83          	lw	s9,100(sp)
40f04d84:	06012d03          	lw	s10,96(sp)
40f04d88:	05c12d83          	lw	s11,92(sp)
40f04d8c:	09010113          	addi	sp,sp,144
40f04d90:	00008067          	ret
		while (u) {
40f04d94:	0b397863          	bgeu	s2,s3,40f04e44 <printi+0x19c>
	if (flags & PAD_ALTERNATE) {
40f04d98:	f7442783          	lw	a5,-140(s0)
40f04d9c:	00078e63          	beqz	a5,40f04db8 <printi+0x110>
		if ((b == 16) && (letbase == 'A')) {
40f04da0:	01000713          	li	a4,16
40f04da4:	fffd8793          	addi	a5,s11,-1
40f04da8:	0ae98863          	beq	s3,a4,40f04e58 <printi+0x1b0>
		*--s = '0';
40f04dac:	03000713          	li	a4,48
40f04db0:	feed8fa3          	sb	a4,-1(s11)
40f04db4:	00078d93          	mv	s11,a5
	if (neg) {
40f04db8:	f80a02e3          	beqz	s4,40f04d3c <printi+0x94>
		if (width && (flags & PAD_ZERO)) {
40f04dbc:	000b0663          	beqz	s6,40f04dc8 <printi+0x120>
40f04dc0:	002af793          	andi	a5,s5,2
40f04dc4:	0e079063          	bnez	a5,40f04ea4 <printi+0x1fc>
			*--s = '-';
40f04dc8:	02d00793          	li	a5,45
40f04dcc:	fefd8fa3          	sb	a5,-1(s11)
	int neg = 0, pc = 0;
40f04dd0:	00000a13          	li	s4,0
			*--s = '-';
40f04dd4:	fffd8d93          	addi	s11,s11,-1
40f04dd8:	f65ff06f          	j	40f04d3c <printi+0x94>
40f04ddc:	00000a13          	li	s4,0
				t += letbase - '0' - 10;
40f04de0:	00042783          	lw	a5,0(s0)
40f04de4:	41f9dc93          	srai	s9,s3,0x1f
{
40f04de8:	fbf40d93          	addi	s11,s0,-65
				t += letbase - '0' - 10;
40f04dec:	fc678c13          	addi	s8,a5,-58
			t = u % b;
40f04df0:	00098613          	mv	a2,s3
40f04df4:	000c8693          	mv	a3,s9
40f04df8:	00090513          	mv	a0,s2
40f04dfc:	00048593          	mv	a1,s1
40f04e00:	644040ef          	jal	ra,40f09444 <__umoddi3>
40f04e04:	00050d13          	mv	s10,a0
40f04e08:	00058b93          	mv	s7,a1
			u = u / b;
40f04e0c:	00090513          	mv	a0,s2
40f04e10:	00048593          	mv	a1,s1
40f04e14:	00098613          	mv	a2,s3
40f04e18:	000c8693          	mv	a3,s9
40f04e1c:	054040ef          	jal	ra,40f08e70 <__udivdi3>
			*--s = t + '0';
40f04e20:	fffd8d93          	addi	s11,s11,-1
			t = u % b;
40f04e24:	000d0793          	mv	a5,s10
			if (t >= 10)
40f04e28:	020b9463          	bnez	s7,40f04e50 <printi+0x1a8>
40f04e2c:	00900713          	li	a4,9
40f04e30:	03a76063          	bltu	a4,s10,40f04e50 <printi+0x1a8>
			*--s = t + '0';
40f04e34:	03078793          	addi	a5,a5,48
40f04e38:	00fd8023          	sb	a5,0(s11)
		while (u) {
40f04e3c:	f594eee3          	bltu	s1,s9,40f04d98 <printi+0xf0>
40f04e40:	f49c8ae3          	beq	s9,s1,40f04d94 <printi+0xec>
			u = u / b;
40f04e44:	00050913          	mv	s2,a0
40f04e48:	00058493          	mv	s1,a1
40f04e4c:	fa5ff06f          	j	40f04df0 <printi+0x148>
				t += letbase - '0' - 10;
40f04e50:	01ac07b3          	add	a5,s8,s10
40f04e54:	fe1ff06f          	j	40f04e34 <printi+0x18c>
		if ((b == 16) && (letbase == 'A')) {
40f04e58:	00042683          	lw	a3,0(s0)
40f04e5c:	04100713          	li	a4,65
40f04e60:	04e68e63          	beq	a3,a4,40f04ebc <printi+0x214>
		} else if ((b == 16) && (letbase == 'a')) {
40f04e64:	00042683          	lw	a3,0(s0)
40f04e68:	06100713          	li	a4,97
40f04e6c:	f4e690e3          	bne	a3,a4,40f04dac <printi+0x104>
			*--s = 'x';
40f04e70:	ffed8713          	addi	a4,s11,-2
40f04e74:	07800693          	li	a3,120
40f04e78:	fedd8fa3          	sb	a3,-1(s11)
40f04e7c:	00078d93          	mv	s11,a5
40f04e80:	00070793          	mv	a5,a4
40f04e84:	f29ff06f          	j	40f04dac <printi+0x104>
	if (sg && b == 10 && i < 0) {
40f04e88:	e806d8e3          	bgez	a3,40f04d18 <printi+0x70>
		u   = -i;
40f04e8c:	40c00933          	neg	s2,a2
40f04e90:	012037b3          	snez	a5,s2
40f04e94:	40d004b3          	neg	s1,a3
40f04e98:	40f484b3          	sub	s1,s1,a5
	*s = '\0';
40f04e9c:	fa040fa3          	sb	zero,-65(s0)
	if (!u) {
40f04ea0:	f41ff06f          	j	40f04de0 <printi+0x138>
			printc(out, out_len, '-');
40f04ea4:	f7842583          	lw	a1,-136(s0)
40f04ea8:	f7c42503          	lw	a0,-132(s0)
40f04eac:	02d00613          	li	a2,45
			--width;
40f04eb0:	fffb0b13          	addi	s6,s6,-1
			printc(out, out_len, '-');
40f04eb4:	c11ff0ef          	jal	ra,40f04ac4 <printc>
			--width;
40f04eb8:	e85ff06f          	j	40f04d3c <printi+0x94>
			*--s = 'X';
40f04ebc:	ffed8713          	addi	a4,s11,-2
40f04ec0:	05800693          	li	a3,88
40f04ec4:	fedd8fa3          	sb	a3,-1(s11)
40f04ec8:	00078d93          	mv	s11,a5
40f04ecc:	00070793          	mv	a5,a4
40f04ed0:	eddff06f          	j	40f04dac <printi+0x104>

40f04ed4 <print>:

static int print(char **out, u32 *out_len, const char *format, va_list args)
{
40f04ed4:	f9010113          	addi	sp,sp,-112
40f04ed8:	06812423          	sw	s0,104(sp)
40f04edc:	05412c23          	sw	s4,88(sp)
40f04ee0:	06112623          	sw	ra,108(sp)
40f04ee4:	06912223          	sw	s1,100(sp)
40f04ee8:	07212023          	sw	s2,96(sp)
40f04eec:	05312e23          	sw	s3,92(sp)
40f04ef0:	05512a23          	sw	s5,84(sp)
40f04ef4:	05612823          	sw	s6,80(sp)
40f04ef8:	05712623          	sw	s7,76(sp)
40f04efc:	05812423          	sw	s8,72(sp)
40f04f00:	05912223          	sw	s9,68(sp)
40f04f04:	05a12023          	sw	s10,64(sp)
40f04f08:	03b12e23          	sw	s11,60(sp)
40f04f0c:	07010413          	addi	s0,sp,112
	int width, flags, acnt = 0;
	int pc = 0;
	char scr[2];
	unsigned long long tmp;

	for (; *format != 0; ++format) {
40f04f10:	00064783          	lbu	a5,0(a2)
{
40f04f14:	00050a13          	mv	s4,a0
	for (; *format != 0; ++format) {
40f04f18:	38078463          	beqz	a5,40f052a0 <print+0x3cc>
40f04f1c:	00060c93          	mv	s9,a2
40f04f20:	00058a93          	mv	s5,a1
40f04f24:	00068993          	mv	s3,a3
	int pc = 0;
40f04f28:	00000d13          	li	s10,0
	int width, flags, acnt = 0;
40f04f2c:	00000b13          	li	s6,0
		if (*format == '%') {
40f04f30:	02500913          	li	s2,37
			}
			if (*format == '#') {
				++format;
				flags |= PAD_ALTERNATE;
			}
			while (*format == '0') {
40f04f34:	03000c13          	li	s8,48
				++format;
				flags |= PAD_ZERO;
			}
			/* Get width */
			for (; *format >= '0' && *format <= '9'; ++format) {
40f04f38:	00900b93          	li	s7,9
		if (*format == '%') {
40f04f3c:	001c8493          	addi	s1,s9,1
40f04f40:	17279263          	bne	a5,s2,40f050a4 <print+0x1d0>
			if (*format == '\0')
40f04f44:	001cc603          	lbu	a2,1(s9)
40f04f48:	10060063          	beqz	a2,40f05048 <print+0x174>
			if (*format == '%')
40f04f4c:	19260263          	beq	a2,s2,40f050d0 <print+0x1fc>
			if (*format == '-') {
40f04f50:	02d00793          	li	a5,45
			width = flags = 0;
40f04f54:	00000d93          	li	s11,0
			if (*format == '-') {
40f04f58:	00f61863          	bne	a2,a5,40f04f68 <print+0x94>
				++format;
40f04f5c:	002cc603          	lbu	a2,2(s9)
40f04f60:	002c8493          	addi	s1,s9,2
				flags = PAD_RIGHT;
40f04f64:	00100d93          	li	s11,1
			if (*format == '#') {
40f04f68:	02300793          	li	a5,35
40f04f6c:	12f60463          	beq	a2,a5,40f05094 <print+0x1c0>
			while (*format == '0') {
40f04f70:	01861a63          	bne	a2,s8,40f04f84 <print+0xb0>
				++format;
40f04f74:	00148493          	addi	s1,s1,1
			while (*format == '0') {
40f04f78:	0004c603          	lbu	a2,0(s1)
				flags |= PAD_ZERO;
40f04f7c:	002ded93          	ori	s11,s11,2
			while (*format == '0') {
40f04f80:	ff860ae3          	beq	a2,s8,40f04f74 <print+0xa0>
			for (; *format >= '0' && *format <= '9'; ++format) {
40f04f84:	fd060793          	addi	a5,a2,-48
40f04f88:	0ff7f713          	andi	a4,a5,255
			width = flags = 0;
40f04f8c:	00000f13          	li	t5,0
			for (; *format >= '0' && *format <= '9'; ++format) {
40f04f90:	02ebe463          	bltu	s7,a4,40f04fb8 <print+0xe4>
40f04f94:	00148493          	addi	s1,s1,1
				width *= 10;
40f04f98:	002f1813          	slli	a6,t5,0x2
			for (; *format >= '0' && *format <= '9'; ++format) {
40f04f9c:	0004c603          	lbu	a2,0(s1)
				width *= 10;
40f04fa0:	01e80833          	add	a6,a6,t5
40f04fa4:	00181813          	slli	a6,a6,0x1
				width += *format - '0';
40f04fa8:	01078f33          	add	t5,a5,a6
			for (; *format >= '0' && *format <= '9'; ++format) {
40f04fac:	fd060793          	addi	a5,a2,-48
40f04fb0:	0ff7f713          	andi	a4,a5,255
40f04fb4:	feebf0e3          	bgeu	s7,a4,40f04f94 <print+0xc0>
			}
			if (*format == 's') {
40f04fb8:	07300793          	li	a5,115
40f04fbc:	14f60c63          	beq	a2,a5,40f05114 <print+0x240>
				acnt += sizeof(char *);
				pc += prints(out, out_len, s ? s : "(null)",
					     width, flags);
				continue;
			}
			if ((*format == 'd') || (*format == 'i')) {
40f04fc0:	06400793          	li	a5,100
40f04fc4:	10f60a63          	beq	a2,a5,40f050d8 <print+0x204>
40f04fc8:	06900793          	li	a5,105
40f04fcc:	10f60663          	beq	a2,a5,40f050d8 <print+0x204>
				pc += printi(out, out_len, va_arg(args, int),
					     10, 1, width, flags, '0');
				acnt += sizeof(int);
				continue;
			}
			if (*format == 'x') {
40f04fd0:	07800793          	li	a5,120
40f04fd4:	16f60863          	beq	a2,a5,40f05144 <print+0x270>
					     va_arg(args, unsigned int), 16, 0,
					     width, flags, 'a');
				acnt += sizeof(unsigned int);
				continue;
			}
			if (*format == 'X') {
40f04fd8:	05800793          	li	a5,88
40f04fdc:	1ef60e63          	beq	a2,a5,40f051d8 <print+0x304>
					     va_arg(args, unsigned int), 16, 0,
					     width, flags, 'A');
				acnt += sizeof(unsigned int);
				continue;
			}
			if (*format == 'u') {
40f04fe0:	07500793          	li	a5,117
40f04fe4:	26f60a63          	beq	a2,a5,40f05258 <print+0x384>
					     va_arg(args, unsigned int), 10, 0,
					     width, flags, 'a');
				acnt += sizeof(unsigned int);
				continue;
			}
			if (*format == 'p') {
40f04fe8:	07000793          	li	a5,112
40f04fec:	14f60c63          	beq	a2,a5,40f05144 <print+0x270>
					     va_arg(args, unsigned long), 16, 0,
					     width, flags, 'a');
				acnt += sizeof(unsigned long);
				continue;
			}
			if (*format == 'P') {
40f04ff0:	05000793          	li	a5,80
40f04ff4:	1ef60263          	beq	a2,a5,40f051d8 <print+0x304>
					     va_arg(args, unsigned long), 16, 0,
					     width, flags, 'A');
				acnt += sizeof(unsigned long);
				continue;
			}
			if (*format == 'l' && *(format + 1) == 'l') {
40f04ff8:	06c00793          	li	a5,108
40f04ffc:	00148c93          	addi	s9,s1,1
40f05000:	16f60463          	beq	a2,a5,40f05168 <print+0x294>
						     va_arg(args, long), 10, 1,
						     width, flags, '0');
					acnt += sizeof(long);
				}
			}
			if (*format == 'c') {
40f05004:	0004c703          	lbu	a4,0(s1)
40f05008:	06300793          	li	a5,99
40f0500c:	0af71c63          	bne	a4,a5,40f050c4 <print+0x1f0>
				/* char are converted to int then pushed on the stack */
				scr[0] = va_arg(args, int);
40f05010:	0009a783          	lw	a5,0(s3)
				scr[1] = '\0';
				pc += prints(out, out_len, scr, width, flags);
40f05014:	000d8713          	mv	a4,s11
40f05018:	000f0693          	mv	a3,t5
40f0501c:	fb440613          	addi	a2,s0,-76
40f05020:	000a8593          	mv	a1,s5
40f05024:	000a0513          	mv	a0,s4
				scr[0] = va_arg(args, int);
40f05028:	faf40a23          	sb	a5,-76(s0)
				scr[1] = '\0';
40f0502c:	fa040aa3          	sb	zero,-75(s0)
				pc += prints(out, out_len, scr, width, flags);
40f05030:	b0dff0ef          	jal	ra,40f04b3c <prints>
	for (; *format != 0; ++format) {
40f05034:	0014c783          	lbu	a5,1(s1)
				scr[0] = va_arg(args, int);
40f05038:	00498993          	addi	s3,s3,4
				pc += prints(out, out_len, scr, width, flags);
40f0503c:	00ad0d33          	add	s10,s10,a0
				acnt += sizeof(int);
40f05040:	004b0b13          	addi	s6,s6,4
	for (; *format != 0; ++format) {
40f05044:	ee079ce3          	bnez	a5,40f04f3c <print+0x68>
		out:
			printc(out, out_len, *format);
			++pc;
		}
	}
	if (out)
40f05048:	000a0663          	beqz	s4,40f05054 <print+0x180>
		**out = '\0';
40f0504c:	000a2783          	lw	a5,0(s4)
40f05050:	00078023          	sb	zero,0(a5)

	return pc;
}
40f05054:	06c12083          	lw	ra,108(sp)
40f05058:	06812403          	lw	s0,104(sp)
40f0505c:	000d0513          	mv	a0,s10
40f05060:	06412483          	lw	s1,100(sp)
40f05064:	06012903          	lw	s2,96(sp)
40f05068:	05c12983          	lw	s3,92(sp)
40f0506c:	05812a03          	lw	s4,88(sp)
40f05070:	05412a83          	lw	s5,84(sp)
40f05074:	05012b03          	lw	s6,80(sp)
40f05078:	04c12b83          	lw	s7,76(sp)
40f0507c:	04812c03          	lw	s8,72(sp)
40f05080:	04412c83          	lw	s9,68(sp)
40f05084:	04012d03          	lw	s10,64(sp)
40f05088:	03c12d83          	lw	s11,60(sp)
40f0508c:	07010113          	addi	sp,sp,112
40f05090:	00008067          	ret
				flags |= PAD_ALTERNATE;
40f05094:	0014c603          	lbu	a2,1(s1)
40f05098:	004ded93          	ori	s11,s11,4
				++format;
40f0509c:	00148493          	addi	s1,s1,1
40f050a0:	ed1ff06f          	j	40f04f70 <print+0x9c>
		if (*format == '%') {
40f050a4:	00048793          	mv	a5,s1
40f050a8:	000cc603          	lbu	a2,0(s9)
40f050ac:	000c8493          	mv	s1,s9
40f050b0:	00078c93          	mv	s9,a5
			printc(out, out_len, *format);
40f050b4:	000a8593          	mv	a1,s5
40f050b8:	000a0513          	mv	a0,s4
40f050bc:	a09ff0ef          	jal	ra,40f04ac4 <printc>
			++pc;
40f050c0:	001d0d13          	addi	s10,s10,1
	for (; *format != 0; ++format) {
40f050c4:	0014c783          	lbu	a5,1(s1)
40f050c8:	e6079ae3          	bnez	a5,40f04f3c <print+0x68>
40f050cc:	f7dff06f          	j	40f05048 <print+0x174>
40f050d0:	002c8c93          	addi	s9,s9,2
40f050d4:	fe1ff06f          	j	40f050b4 <print+0x1e0>
				pc += printi(out, out_len, va_arg(args, int),
40f050d8:	0009a603          	lw	a2,0(s3)
40f050dc:	000d8893          	mv	a7,s11
40f050e0:	01812023          	sw	s8,0(sp)
40f050e4:	000f0813          	mv	a6,t5
40f050e8:	00100793          	li	a5,1
40f050ec:	00a00713          	li	a4,10
40f050f0:	41f65693          	srai	a3,a2,0x1f
				pc += printi(out, out_len,
40f050f4:	000a8593          	mv	a1,s5
40f050f8:	000a0513          	mv	a0,s4
40f050fc:	badff0ef          	jal	ra,40f04ca8 <printi>
					     va_arg(args, unsigned int), 16, 0,
40f05100:	00498993          	addi	s3,s3,4
				pc += printi(out, out_len,
40f05104:	00ad0d33          	add	s10,s10,a0
				acnt += sizeof(unsigned int);
40f05108:	004b0b13          	addi	s6,s6,4
				continue;
40f0510c:	00148c93          	addi	s9,s1,1
40f05110:	fb5ff06f          	j	40f050c4 <print+0x1f0>
				char *s = va_arg(args, char *);
40f05114:	0009a603          	lw	a2,0(s3)
				acnt += sizeof(char *);
40f05118:	004b0b13          	addi	s6,s6,4
				char *s = va_arg(args, char *);
40f0511c:	00498993          	addi	s3,s3,4
				pc += prints(out, out_len, s ? s : "(null)",
40f05120:	0c060263          	beqz	a2,40f051e4 <print+0x310>
40f05124:	000d8713          	mv	a4,s11
40f05128:	000f0693          	mv	a3,t5
40f0512c:	000a8593          	mv	a1,s5
40f05130:	000a0513          	mv	a0,s4
40f05134:	a09ff0ef          	jal	ra,40f04b3c <prints>
40f05138:	00ad0d33          	add	s10,s10,a0
				continue;
40f0513c:	00148c93          	addi	s9,s1,1
40f05140:	f85ff06f          	j	40f050c4 <print+0x1f0>
				pc += printi(out, out_len,
40f05144:	0009a603          	lw	a2,0(s3)
40f05148:	06100793          	li	a5,97
40f0514c:	00f12023          	sw	a5,0(sp)
40f05150:	000d8893          	mv	a7,s11
40f05154:	000f0813          	mv	a6,t5
40f05158:	00000793          	li	a5,0
40f0515c:	01000713          	li	a4,16
40f05160:	00000693          	li	a3,0
40f05164:	f91ff06f          	j	40f050f4 <print+0x220>
			if (*format == 'l' && *(format + 1) == 'l') {
40f05168:	0014c783          	lbu	a5,1(s1)
40f0516c:	14c78463          	beq	a5,a2,40f052b4 <print+0x3e0>
				if (*(format + 1) == 'u') {
40f05170:	07500713          	li	a4,117
40f05174:	00148c93          	addi	s9,s1,1
40f05178:	00498293          	addi	t0,s3,4
40f0517c:	0009a603          	lw	a2,0(s3)
40f05180:	0ee78e63          	beq	a5,a4,40f0527c <print+0x3a8>
				} else if (*(format + 1) == 'x') {
40f05184:	07800713          	li	a4,120
40f05188:	004b0b13          	addi	s6,s6,4
40f0518c:	10e78e63          	beq	a5,a4,40f052a8 <print+0x3d4>
				} else if (*(format + 1) == 'X') {
40f05190:	05800713          	li	a4,88
40f05194:	fa542423          	sw	t0,-88(s0)
40f05198:	06e78a63          	beq	a5,a4,40f0520c <print+0x338>
					pc += printi(out, out_len,
40f0519c:	000f0813          	mv	a6,t5
40f051a0:	01812023          	sw	s8,0(sp)
40f051a4:	000d8893          	mv	a7,s11
40f051a8:	00100793          	li	a5,1
40f051ac:	00a00713          	li	a4,10
40f051b0:	41f65693          	srai	a3,a2,0x1f
40f051b4:	000a8593          	mv	a1,s5
40f051b8:	000a0513          	mv	a0,s4
40f051bc:	fbe42623          	sw	t5,-84(s0)
40f051c0:	ae9ff0ef          	jal	ra,40f04ca8 <printi>
						     va_arg(args, long), 10, 1,
40f051c4:	fa842283          	lw	t0,-88(s0)
					pc += printi(out, out_len,
40f051c8:	00ad0d33          	add	s10,s10,a0
						     va_arg(args, long), 10, 1,
40f051cc:	fac42f03          	lw	t5,-84(s0)
40f051d0:	00028993          	mv	s3,t0
40f051d4:	e31ff06f          	j	40f05004 <print+0x130>
				pc += printi(out, out_len,
40f051d8:	0009a603          	lw	a2,0(s3)
40f051dc:	04100793          	li	a5,65
40f051e0:	f6dff06f          	j	40f0514c <print+0x278>
				pc += prints(out, out_len, s ? s : "(null)",
40f051e4:	00005617          	auipc	a2,0x5
40f051e8:	56c60613          	addi	a2,a2,1388 # 40f0a750 <platform_ops+0x16c>
40f051ec:	000d8713          	mv	a4,s11
40f051f0:	000f0693          	mv	a3,t5
40f051f4:	000a8593          	mv	a1,s5
40f051f8:	000a0513          	mv	a0,s4
40f051fc:	941ff0ef          	jal	ra,40f04b3c <prints>
40f05200:	00ad0d33          	add	s10,s10,a0
				continue;
40f05204:	00148c93          	addi	s9,s1,1
40f05208:	ebdff06f          	j	40f050c4 <print+0x1f0>
					pc += printi(
40f0520c:	04100793          	li	a5,65
					pc += printi(
40f05210:	00f12023          	sw	a5,0(sp)
40f05214:	000d8893          	mv	a7,s11
40f05218:	000f0813          	mv	a6,t5
40f0521c:	fbe42623          	sw	t5,-84(s0)
40f05220:	00000793          	li	a5,0
40f05224:	01000713          	li	a4,16
40f05228:	00000693          	li	a3,0
40f0522c:	000a8593          	mv	a1,s5
40f05230:	000a0513          	mv	a0,s4
40f05234:	a75ff0ef          	jal	ra,40f04ca8 <printi>
						va_arg(args, unsigned long), 16,
40f05238:	fa842283          	lw	t0,-88(s0)
40f0523c:	00248793          	addi	a5,s1,2
					pc += printi(
40f05240:	00ad0d33          	add	s10,s10,a0
					format += 1;
40f05244:	000c8493          	mv	s1,s9
						va_arg(args, unsigned long), 16,
40f05248:	00028993          	mv	s3,t0
40f0524c:	00078c93          	mv	s9,a5
40f05250:	fac42f03          	lw	t5,-84(s0)
40f05254:	db1ff06f          	j	40f05004 <print+0x130>
				pc += printi(out, out_len,
40f05258:	06100793          	li	a5,97
40f0525c:	0009a603          	lw	a2,0(s3)
40f05260:	000d8893          	mv	a7,s11
40f05264:	00f12023          	sw	a5,0(sp)
40f05268:	000f0813          	mv	a6,t5
40f0526c:	00000793          	li	a5,0
40f05270:	00a00713          	li	a4,10
				pc += printi(out, out_len,
40f05274:	00000693          	li	a3,0
40f05278:	e7dff06f          	j	40f050f4 <print+0x220>
					pc += printi(
40f0527c:	06100793          	li	a5,97
40f05280:	00f12023          	sw	a5,0(sp)
40f05284:	fa542423          	sw	t0,-88(s0)
40f05288:	000d8893          	mv	a7,s11
40f0528c:	000f0813          	mv	a6,t5
40f05290:	fbe42623          	sw	t5,-84(s0)
40f05294:	00000793          	li	a5,0
40f05298:	00a00713          	li	a4,10
40f0529c:	f8dff06f          	j	40f05228 <print+0x354>
	int pc = 0;
40f052a0:	00000d13          	li	s10,0
40f052a4:	da5ff06f          	j	40f05048 <print+0x174>
					pc += printi(
40f052a8:	fa542423          	sw	t0,-88(s0)
40f052ac:	06100793          	li	a5,97
40f052b0:	f61ff06f          	j	40f05210 <print+0x33c>
				while (acnt &
40f052b4:	007b7793          	andi	a5,s6,7
40f052b8:	00098713          	mv	a4,s3
40f052bc:	0e078663          	beqz	a5,40f053a8 <print+0x4d4>
					va_arg(args, int);
40f052c0:	00470713          	addi	a4,a4,4
					acnt += sizeof(int);
40f052c4:	016707b3          	add	a5,a4,s6
40f052c8:	413787b3          	sub	a5,a5,s3
				while (acnt &
40f052cc:	0077f693          	andi	a3,a5,7
40f052d0:	fe0698e3          	bnez	a3,40f052c0 <print+0x3ec>
					((unsigned long *)&tmp)[1] =
40f052d4:	00472683          	lw	a3,4(a4)
					((unsigned long *)&tmp)[0] =
40f052d8:	00072603          	lw	a2,0(a4)
				if (*(format + 2) == 'u') {
40f052dc:	0024c583          	lbu	a1,2(s1)
					((unsigned long *)&tmp)[1] =
40f052e0:	fad42e23          	sw	a3,-68(s0)
					((unsigned long *)&tmp)[0] =
40f052e4:	fac42c23          	sw	a2,-72(s0)
				if (*(format + 2) == 'u') {
40f052e8:	07500693          	li	a3,117
						va_arg(args, unsigned long);
40f052ec:	00870993          	addi	s3,a4,8
					acnt += 2 * sizeof(unsigned long);
40f052f0:	00878b13          	addi	s6,a5,8
				if (*(format + 2) == 'u') {
40f052f4:	04d58863          	beq	a1,a3,40f05344 <print+0x470>
				} else if (*(format + 2) == 'x') {
40f052f8:	07800793          	li	a5,120
40f052fc:	fb842603          	lw	a2,-72(s0)
40f05300:	fbc42683          	lw	a3,-68(s0)
40f05304:	08f58e63          	beq	a1,a5,40f053a0 <print+0x4cc>
				} else if (*(format + 2) == 'X') {
40f05308:	05800793          	li	a5,88
40f0530c:	06f58c63          	beq	a1,a5,40f05384 <print+0x4b0>
					pc += printi(out, out_len, tmp, 10, 1,
40f05310:	000d8893          	mv	a7,s11
40f05314:	01812023          	sw	s8,0(sp)
40f05318:	000f0813          	mv	a6,t5
40f0531c:	00100793          	li	a5,1
40f05320:	00a00713          	li	a4,10
40f05324:	000a8593          	mv	a1,s5
40f05328:	000a0513          	mv	a0,s4
					format += 1;
40f0532c:	00148d93          	addi	s11,s1,1
					pc += printi(out, out_len, tmp, 10, 1,
40f05330:	979ff0ef          	jal	ra,40f04ca8 <printi>
40f05334:	00248c93          	addi	s9,s1,2
40f05338:	00ad0d33          	add	s10,s10,a0
					format += 1;
40f0533c:	000d8493          	mv	s1,s11
40f05340:	d85ff06f          	j	40f050c4 <print+0x1f0>
					pc += printi(out, out_len, tmp, 10, 0,
40f05344:	fb842603          	lw	a2,-72(s0)
40f05348:	fbc42683          	lw	a3,-68(s0)
40f0534c:	06100793          	li	a5,97
40f05350:	00f12023          	sw	a5,0(sp)
40f05354:	000d8893          	mv	a7,s11
40f05358:	000f0813          	mv	a6,t5
40f0535c:	00000793          	li	a5,0
40f05360:	00a00713          	li	a4,10
					pc += printi(out, out_len, tmp, 16, 0,
40f05364:	000a8593          	mv	a1,s5
40f05368:	000a0513          	mv	a0,s4
					format += 2;
40f0536c:	00248d93          	addi	s11,s1,2
					pc += printi(out, out_len, tmp, 16, 0,
40f05370:	939ff0ef          	jal	ra,40f04ca8 <printi>
40f05374:	00348c93          	addi	s9,s1,3
40f05378:	00ad0d33          	add	s10,s10,a0
					format += 2;
40f0537c:	000d8493          	mv	s1,s11
40f05380:	d45ff06f          	j	40f050c4 <print+0x1f0>
					pc += printi(out, out_len, tmp, 16, 0,
40f05384:	04100793          	li	a5,65
40f05388:	00f12023          	sw	a5,0(sp)
40f0538c:	000d8893          	mv	a7,s11
40f05390:	000f0813          	mv	a6,t5
40f05394:	00000793          	li	a5,0
40f05398:	01000713          	li	a4,16
40f0539c:	fc9ff06f          	j	40f05364 <print+0x490>
					pc += printi(out, out_len, tmp, 16, 0,
40f053a0:	06100793          	li	a5,97
40f053a4:	fe5ff06f          	j	40f05388 <print+0x4b4>
				while (acnt &
40f053a8:	000b0793          	mv	a5,s6
40f053ac:	f29ff06f          	j	40f052d4 <print+0x400>

40f053b0 <sbi_puts>:
{
40f053b0:	ff010113          	addi	sp,sp,-16
40f053b4:	00812423          	sw	s0,8(sp)
40f053b8:	00912223          	sw	s1,4(sp)
40f053bc:	00112623          	sw	ra,12(sp)
40f053c0:	01010413          	addi	s0,sp,16
40f053c4:	00050493          	mv	s1,a0
	spin_lock(&console_out_lock);
40f053c8:	00007517          	auipc	a0,0x7
40f053cc:	c5c50513          	addi	a0,a0,-932 # 40f0c024 <console_out_lock>
40f053d0:	cacff0ef          	jal	ra,40f0487c <spin_lock>
	while (*str) {
40f053d4:	0004c503          	lbu	a0,0(s1)
40f053d8:	00050a63          	beqz	a0,40f053ec <sbi_puts+0x3c>
		str++;
40f053dc:	00148493          	addi	s1,s1,1
		sbi_putc(*str);
40f053e0:	dd4ff0ef          	jal	ra,40f049b4 <sbi_putc>
	while (*str) {
40f053e4:	0004c503          	lbu	a0,0(s1)
40f053e8:	fe051ae3          	bnez	a0,40f053dc <sbi_puts+0x2c>
	spin_unlock(&console_out_lock);
40f053ec:	00007517          	auipc	a0,0x7
40f053f0:	c3850513          	addi	a0,a0,-968 # 40f0c024 <console_out_lock>
40f053f4:	cb8ff0ef          	jal	ra,40f048ac <spin_unlock>
}
40f053f8:	00c12083          	lw	ra,12(sp)
40f053fc:	00812403          	lw	s0,8(sp)
40f05400:	00412483          	lw	s1,4(sp)
40f05404:	01010113          	addi	sp,sp,16
40f05408:	00008067          	ret

40f0540c <sbi_gets>:
{
40f0540c:	fe010113          	addi	sp,sp,-32
40f05410:	00812c23          	sw	s0,24(sp)
40f05414:	01212823          	sw	s2,16(sp)
40f05418:	00112e23          	sw	ra,28(sp)
40f0541c:	00912a23          	sw	s1,20(sp)
40f05420:	01312623          	sw	s3,12(sp)
40f05424:	01412423          	sw	s4,8(sp)
40f05428:	01512223          	sw	s5,4(sp)
40f0542c:	02010413          	addi	s0,sp,32
	return sbi_platform_console_getc(console_plat);
40f05430:	00007917          	auipc	s2,0x7
40f05434:	bf890913          	addi	s2,s2,-1032 # 40f0c028 <console_plat>
40f05438:	00092783          	lw	a5,0(s2)
	if (plat && sbi_platform_ops(plat)->console_getc)
40f0543c:	10078663          	beqz	a5,40f05548 <sbi_gets+0x13c>
40f05440:	0617c803          	lbu	a6,97(a5)
40f05444:	0607c883          	lbu	a7,96(a5)
40f05448:	0627c683          	lbu	a3,98(a5)
40f0544c:	0637c703          	lbu	a4,99(a5)
40f05450:	00881793          	slli	a5,a6,0x8
40f05454:	0117e833          	or	a6,a5,a7
40f05458:	01069793          	slli	a5,a3,0x10
40f0545c:	0107e7b3          	or	a5,a5,a6
40f05460:	01871713          	slli	a4,a4,0x18
40f05464:	00f76733          	or	a4,a4,a5
40f05468:	02574803          	lbu	a6,37(a4)
40f0546c:	02474883          	lbu	a7,36(a4)
40f05470:	02674683          	lbu	a3,38(a4)
40f05474:	02774783          	lbu	a5,39(a4)
40f05478:	00881713          	slli	a4,a6,0x8
40f0547c:	01176833          	or	a6,a4,a7
40f05480:	01069713          	slli	a4,a3,0x10
40f05484:	01076733          	or	a4,a4,a6
40f05488:	01879793          	slli	a5,a5,0x18
40f0548c:	00e7e7b3          	or	a5,a5,a4
40f05490:	0a078c63          	beqz	a5,40f05548 <sbi_gets+0x13c>
40f05494:	00060993          	mv	s3,a2
40f05498:	00050a93          	mv	s5,a0
40f0549c:	00b504b3          	add	s1,a0,a1
	while ((ch = sbi_getc()) != endchar && ch >= 0 && maxwidth > 1) {
40f054a0:	00100a13          	li	s4,1
40f054a4:	0700006f          	j	40f05514 <sbi_gets+0x108>
40f054a8:	06054c63          	bltz	a0,40f05520 <sbi_gets+0x114>
40f054ac:	06fa5a63          	bge	s4,a5,40f05520 <sbi_gets+0x114>
	return sbi_platform_console_getc(console_plat);
40f054b0:	00092703          	lw	a4,0(s2)
		*retval = (char)ch;
40f054b4:	00aa8023          	sb	a0,0(s5)
		retval++;
40f054b8:	001a8a93          	addi	s5,s5,1
40f054bc:	06070263          	beqz	a4,40f05520 <sbi_gets+0x114>
40f054c0:	06174603          	lbu	a2,97(a4)
40f054c4:	06274683          	lbu	a3,98(a4)
40f054c8:	06074583          	lbu	a1,96(a4)
40f054cc:	06374783          	lbu	a5,99(a4)
40f054d0:	00861713          	slli	a4,a2,0x8
40f054d4:	00b76633          	or	a2,a4,a1
40f054d8:	01069713          	slli	a4,a3,0x10
40f054dc:	00c76733          	or	a4,a4,a2
40f054e0:	01879793          	slli	a5,a5,0x18
40f054e4:	00e7e7b3          	or	a5,a5,a4
40f054e8:	0257c683          	lbu	a3,37(a5)
40f054ec:	0247c603          	lbu	a2,36(a5)
40f054f0:	0267c703          	lbu	a4,38(a5)
40f054f4:	0277c783          	lbu	a5,39(a5)
40f054f8:	00869693          	slli	a3,a3,0x8
40f054fc:	00c6e6b3          	or	a3,a3,a2
40f05500:	01071713          	slli	a4,a4,0x10
40f05504:	00d76733          	or	a4,a4,a3
40f05508:	01879793          	slli	a5,a5,0x18
40f0550c:	00e7e7b3          	or	a5,a5,a4
40f05510:	00078863          	beqz	a5,40f05520 <sbi_gets+0x114>
		return sbi_platform_ops(plat)->console_getc();
40f05514:	000780e7          	jalr	a5
		*retval = (char)ch;
40f05518:	415487b3          	sub	a5,s1,s5
	while ((ch = sbi_getc()) != endchar && ch >= 0 && maxwidth > 1) {
40f0551c:	f8a996e3          	bne	s3,a0,40f054a8 <sbi_gets+0x9c>
	*retval = '\0';
40f05520:	000a8023          	sb	zero,0(s5)
}
40f05524:	01c12083          	lw	ra,28(sp)
40f05528:	01812403          	lw	s0,24(sp)
40f0552c:	01412483          	lw	s1,20(sp)
40f05530:	01012903          	lw	s2,16(sp)
40f05534:	00c12983          	lw	s3,12(sp)
40f05538:	00812a03          	lw	s4,8(sp)
40f0553c:	00412a83          	lw	s5,4(sp)
40f05540:	02010113          	addi	sp,sp,32
40f05544:	00008067          	ret
	char *retval = s;
40f05548:	00050a93          	mv	s5,a0
40f0554c:	fd5ff06f          	j	40f05520 <sbi_gets+0x114>

40f05550 <sbi_sprintf>:

int sbi_sprintf(char *out, const char *format, ...)
{
40f05550:	fb010113          	addi	sp,sp,-80
40f05554:	02812423          	sw	s0,40(sp)
40f05558:	02112623          	sw	ra,44(sp)
40f0555c:	03010413          	addi	s0,sp,48
	va_list args;
	int retval;

	va_start(args, format);
40f05560:	00840313          	addi	t1,s0,8
{
40f05564:	fca42e23          	sw	a0,-36(s0)
40f05568:	00c42423          	sw	a2,8(s0)
40f0556c:	00d42623          	sw	a3,12(s0)
	retval = print(&out, NULL, format, args);
40f05570:	00058613          	mv	a2,a1
40f05574:	fdc40513          	addi	a0,s0,-36
40f05578:	00030693          	mv	a3,t1
40f0557c:	00000593          	li	a1,0
{
40f05580:	00e42823          	sw	a4,16(s0)
40f05584:	00f42a23          	sw	a5,20(s0)
40f05588:	01042c23          	sw	a6,24(s0)
40f0558c:	01142e23          	sw	a7,28(s0)
	va_start(args, format);
40f05590:	fe642623          	sw	t1,-20(s0)
	retval = print(&out, NULL, format, args);
40f05594:	941ff0ef          	jal	ra,40f04ed4 <print>
	va_end(args);

	return retval;
}
40f05598:	02c12083          	lw	ra,44(sp)
40f0559c:	02812403          	lw	s0,40(sp)
40f055a0:	05010113          	addi	sp,sp,80
40f055a4:	00008067          	ret

40f055a8 <sbi_snprintf>:

int sbi_snprintf(char *out, u32 out_sz, const char *format, ...)
{
40f055a8:	fb010113          	addi	sp,sp,-80
40f055ac:	02812423          	sw	s0,40(sp)
40f055b0:	02112623          	sw	ra,44(sp)
40f055b4:	03010413          	addi	s0,sp,48
	va_list args;
	int retval;

	va_start(args, format);
40f055b8:	00c40313          	addi	t1,s0,12
{
40f055bc:	fca42e23          	sw	a0,-36(s0)
40f055c0:	fcb42c23          	sw	a1,-40(s0)
40f055c4:	00d42623          	sw	a3,12(s0)
	retval = print(&out, &out_sz, format, args);
40f055c8:	fd840593          	addi	a1,s0,-40
40f055cc:	fdc40513          	addi	a0,s0,-36
40f055d0:	00030693          	mv	a3,t1
{
40f055d4:	00e42823          	sw	a4,16(s0)
40f055d8:	00f42a23          	sw	a5,20(s0)
40f055dc:	01042c23          	sw	a6,24(s0)
40f055e0:	01142e23          	sw	a7,28(s0)
	va_start(args, format);
40f055e4:	fe642623          	sw	t1,-20(s0)
	retval = print(&out, &out_sz, format, args);
40f055e8:	8edff0ef          	jal	ra,40f04ed4 <print>
	va_end(args);

	return retval;
}
40f055ec:	02c12083          	lw	ra,44(sp)
40f055f0:	02812403          	lw	s0,40(sp)
40f055f4:	05010113          	addi	sp,sp,80
40f055f8:	00008067          	ret

40f055fc <sbi_printf>:

int sbi_printf(const char *format, ...)
{
40f055fc:	fc010113          	addi	sp,sp,-64
40f05600:	00112e23          	sw	ra,28(sp)
40f05604:	00812c23          	sw	s0,24(sp)
40f05608:	00912a23          	sw	s1,20(sp)
40f0560c:	02010413          	addi	s0,sp,32
40f05610:	00050493          	mv	s1,a0
	va_list args;
	int retval;

	spin_lock(&console_out_lock);
40f05614:	00007517          	auipc	a0,0x7
40f05618:	a1050513          	addi	a0,a0,-1520 # 40f0c024 <console_out_lock>
{
40f0561c:	00e42823          	sw	a4,16(s0)
40f05620:	01042c23          	sw	a6,24(s0)
40f05624:	01142e23          	sw	a7,28(s0)
40f05628:	00f42a23          	sw	a5,20(s0)
40f0562c:	00b42223          	sw	a1,4(s0)
40f05630:	00c42423          	sw	a2,8(s0)
40f05634:	00d42623          	sw	a3,12(s0)
	spin_lock(&console_out_lock);
40f05638:	a44ff0ef          	jal	ra,40f0487c <spin_lock>
	va_start(args, format);
40f0563c:	00440793          	addi	a5,s0,4
	retval = print(NULL, NULL, format, args);
40f05640:	00048613          	mv	a2,s1
40f05644:	00078693          	mv	a3,a5
40f05648:	00000593          	li	a1,0
40f0564c:	00000513          	li	a0,0
	va_start(args, format);
40f05650:	fef42623          	sw	a5,-20(s0)
	retval = print(NULL, NULL, format, args);
40f05654:	881ff0ef          	jal	ra,40f04ed4 <print>
40f05658:	00050493          	mv	s1,a0
	va_end(args);
	spin_unlock(&console_out_lock);
40f0565c:	00007517          	auipc	a0,0x7
40f05660:	9c850513          	addi	a0,a0,-1592 # 40f0c024 <console_out_lock>
40f05664:	a48ff0ef          	jal	ra,40f048ac <spin_unlock>

	return retval;
}
40f05668:	01c12083          	lw	ra,28(sp)
40f0566c:	01812403          	lw	s0,24(sp)
40f05670:	00048513          	mv	a0,s1
40f05674:	01412483          	lw	s1,20(sp)
40f05678:	04010113          	addi	sp,sp,64
40f0567c:	00008067          	ret

40f05680 <sbi_dprintf>:

int sbi_dprintf(struct sbi_scratch *scratch, const char *format, ...)
{
40f05680:	fc010113          	addi	sp,sp,-64
40f05684:	00812c23          	sw	s0,24(sp)
40f05688:	00112e23          	sw	ra,28(sp)
40f0568c:	02010413          	addi	s0,sp,32
	va_list args;
	int retval = 0;

	va_start(args, format);
40f05690:	00840313          	addi	t1,s0,8
{
40f05694:	00c42423          	sw	a2,8(s0)
40f05698:	00d42623          	sw	a3,12(s0)
40f0569c:	00e42823          	sw	a4,16(s0)
40f056a0:	00f42a23          	sw	a5,20(s0)
40f056a4:	01042c23          	sw	a6,24(s0)
40f056a8:	01142e23          	sw	a7,28(s0)
	va_start(args, format);
40f056ac:	fe642623          	sw	t1,-20(s0)
	if (scratch->options & SBI_SCRATCH_DEBUG_PRINTS)
40f056b0:	02454783          	lbu	a5,36(a0)
	int retval = 0;
40f056b4:	00000513          	li	a0,0
	if (scratch->options & SBI_SCRATCH_DEBUG_PRINTS)
40f056b8:	0027f793          	andi	a5,a5,2
40f056bc:	00079a63          	bnez	a5,40f056d0 <sbi_dprintf+0x50>
		retval = print(NULL, NULL, format, args);
	va_end(args);

	return retval;
}
40f056c0:	01c12083          	lw	ra,28(sp)
40f056c4:	01812403          	lw	s0,24(sp)
40f056c8:	04010113          	addi	sp,sp,64
40f056cc:	00008067          	ret
40f056d0:	00058613          	mv	a2,a1
		retval = print(NULL, NULL, format, args);
40f056d4:	00030693          	mv	a3,t1
40f056d8:	00000593          	li	a1,0
40f056dc:	00000513          	li	a0,0
40f056e0:	ff4ff0ef          	jal	ra,40f04ed4 <print>
}
40f056e4:	01c12083          	lw	ra,28(sp)
40f056e8:	01812403          	lw	s0,24(sp)
40f056ec:	04010113          	addi	sp,sp,64
40f056f0:	00008067          	ret

40f056f4 <sbi_console_init>:

int sbi_console_init(struct sbi_scratch *scratch)
{
	console_plat = sbi_platform_ptr(scratch);
40f056f4:	01954683          	lbu	a3,25(a0)
40f056f8:	01854603          	lbu	a2,24(a0)
40f056fc:	01a54703          	lbu	a4,26(a0)
40f05700:	01b54783          	lbu	a5,27(a0)
40f05704:	00869693          	slli	a3,a3,0x8
40f05708:	00c6e6b3          	or	a3,a3,a2
40f0570c:	01071713          	slli	a4,a4,0x10
40f05710:	00d76733          	or	a4,a4,a3
40f05714:	01879793          	slli	a5,a5,0x18
40f05718:	00e7e7b3          	or	a5,a5,a4
40f0571c:	00007717          	auipc	a4,0x7
40f05720:	90f72623          	sw	a5,-1780(a4) # 40f0c028 <console_plat>
	if (plat && sbi_platform_ops(plat)->console_init)
40f05724:	08078263          	beqz	a5,40f057a8 <sbi_console_init+0xb4>
40f05728:	0617c683          	lbu	a3,97(a5)
40f0572c:	0607c603          	lbu	a2,96(a5)
40f05730:	0627c703          	lbu	a4,98(a5)
40f05734:	0637c783          	lbu	a5,99(a5)
40f05738:	00869693          	slli	a3,a3,0x8
40f0573c:	00c6e6b3          	or	a3,a3,a2
40f05740:	01071713          	slli	a4,a4,0x10
40f05744:	00d76733          	or	a4,a4,a3
40f05748:	01879793          	slli	a5,a5,0x18
40f0574c:	00e7e7b3          	or	a5,a5,a4
40f05750:	0297c683          	lbu	a3,41(a5)
40f05754:	0287c603          	lbu	a2,40(a5)
40f05758:	02a7c703          	lbu	a4,42(a5)
40f0575c:	02b7c783          	lbu	a5,43(a5)
40f05760:	00869693          	slli	a3,a3,0x8
40f05764:	00c6e6b3          	or	a3,a3,a2
40f05768:	01071713          	slli	a4,a4,0x10
40f0576c:	00d76733          	or	a4,a4,a3
40f05770:	01879793          	slli	a5,a5,0x18
40f05774:	00e7e7b3          	or	a5,a5,a4
	return 0;
40f05778:	00000513          	li	a0,0
	if (plat && sbi_platform_ops(plat)->console_init)
40f0577c:	02078463          	beqz	a5,40f057a4 <sbi_console_init+0xb0>
{
40f05780:	ff010113          	addi	sp,sp,-16
40f05784:	00812423          	sw	s0,8(sp)
40f05788:	00112623          	sw	ra,12(sp)
40f0578c:	01010413          	addi	s0,sp,16
		return sbi_platform_ops(plat)->console_init();
40f05790:	000780e7          	jalr	a5

	return sbi_platform_console_init(console_plat);
}
40f05794:	00c12083          	lw	ra,12(sp)
40f05798:	00812403          	lw	s0,8(sp)
40f0579c:	01010113          	addi	sp,sp,16
40f057a0:	00008067          	ret
40f057a4:	00008067          	ret
	return 0;
40f057a8:	00000513          	li	a0,0
40f057ac:	00008067          	ret

40f057b0 <sbi_ecall_version_major>:
#include <sbi/sbi_ecall_interface.h>
#include <sbi/sbi_error.h>
#include <sbi/sbi_trap.h>

u16 sbi_ecall_version_major(void)
{
40f057b0:	ff010113          	addi	sp,sp,-16
40f057b4:	00812623          	sw	s0,12(sp)
40f057b8:	01010413          	addi	s0,sp,16
	return SBI_ECALL_VERSION_MAJOR;
}
40f057bc:	00c12403          	lw	s0,12(sp)
40f057c0:	00000513          	li	a0,0
40f057c4:	01010113          	addi	sp,sp,16
40f057c8:	00008067          	ret

40f057cc <sbi_ecall_version_minor>:

u16 sbi_ecall_version_minor(void)
{
40f057cc:	ff010113          	addi	sp,sp,-16
40f057d0:	00812623          	sw	s0,12(sp)
40f057d4:	01010413          	addi	s0,sp,16
	return SBI_ECALL_VERSION_MINOR;
}
40f057d8:	00c12403          	lw	s0,12(sp)
40f057dc:	00200513          	li	a0,2
40f057e0:	01010113          	addi	sp,sp,16
40f057e4:	00008067          	ret

40f057e8 <sbi_ecall_find_extension>:

static SBI_LIST_HEAD(ecall_exts_list);

struct sbi_ecall_extension *sbi_ecall_find_extension(unsigned long extid)
{
40f057e8:	ff010113          	addi	sp,sp,-16
40f057ec:	00812623          	sw	s0,12(sp)
40f057f0:	01010413          	addi	s0,sp,16
	struct sbi_ecall_extension *t, *ret = NULL;

	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f057f4:	00006697          	auipc	a3,0x6
40f057f8:	81c68693          	addi	a3,a3,-2020 # 40f0b010 <ecall_exts_list>
40f057fc:	0006a783          	lw	a5,0(a3)
40f05800:	00d78e63          	beq	a5,a3,40f0581c <sbi_ecall_find_extension+0x34>
		if (t->extid_start <= extid && extid <= t->extid_end) {
40f05804:	0087a703          	lw	a4,8(a5)
40f05808:	00e56663          	bltu	a0,a4,40f05814 <sbi_ecall_find_extension+0x2c>
40f0580c:	00c7a703          	lw	a4,12(a5)
40f05810:	00a77863          	bgeu	a4,a0,40f05820 <sbi_ecall_find_extension+0x38>
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05814:	0007a783          	lw	a5,0(a5)
40f05818:	fed796e3          	bne	a5,a3,40f05804 <sbi_ecall_find_extension+0x1c>
	struct sbi_ecall_extension *t, *ret = NULL;
40f0581c:	00000793          	li	a5,0
			break;
		}
	}

	return ret;
}
40f05820:	00c12403          	lw	s0,12(sp)
40f05824:	00078513          	mv	a0,a5
40f05828:	01010113          	addi	sp,sp,16
40f0582c:	00008067          	ret

40f05830 <sbi_ecall_register_extension>:

int sbi_ecall_register_extension(struct sbi_ecall_extension *ext)
{
40f05830:	ff010113          	addi	sp,sp,-16
40f05834:	00812623          	sw	s0,12(sp)
40f05838:	01010413          	addi	s0,sp,16
	if (!ext || (ext->extid_end < ext->extid_start) || !ext->handle)
40f0583c:	08050863          	beqz	a0,40f058cc <sbi_ecall_register_extension+0x9c>
40f05840:	00c52803          	lw	a6,12(a0)
40f05844:	00852583          	lw	a1,8(a0)
40f05848:	08b86263          	bltu	a6,a1,40f058cc <sbi_ecall_register_extension+0x9c>
40f0584c:	01452783          	lw	a5,20(a0)
40f05850:	06078e63          	beqz	a5,40f058cc <sbi_ecall_register_extension+0x9c>
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05854:	00005697          	auipc	a3,0x5
40f05858:	7bc68693          	addi	a3,a3,1980 # 40f0b010 <ecall_exts_list>
40f0585c:	0006a783          	lw	a5,0(a3)
40f05860:	02d78c63          	beq	a5,a3,40f05898 <sbi_ecall_register_extension+0x68>
40f05864:	00078713          	mv	a4,a5
		if (t->extid_start <= extid && extid <= t->extid_end) {
40f05868:	00872603          	lw	a2,8(a4)
40f0586c:	00c5e663          	bltu	a1,a2,40f05878 <sbi_ecall_register_extension+0x48>
40f05870:	00c72603          	lw	a2,12(a4)
40f05874:	04b67c63          	bgeu	a2,a1,40f058cc <sbi_ecall_register_extension+0x9c>
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05878:	00072703          	lw	a4,0(a4)
40f0587c:	fed716e3          	bne	a4,a3,40f05868 <sbi_ecall_register_extension+0x38>
		if (t->extid_start <= extid && extid <= t->extid_end) {
40f05880:	0087a703          	lw	a4,8(a5)
40f05884:	00e86663          	bltu	a6,a4,40f05890 <sbi_ecall_register_extension+0x60>
40f05888:	00c7a703          	lw	a4,12(a5)
40f0588c:	05077063          	bgeu	a4,a6,40f058cc <sbi_ecall_register_extension+0x9c>
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05890:	0007a783          	lw	a5,0(a5)
40f05894:	fed796e3          	bne	a5,a3,40f05880 <sbi_ecall_register_extension+0x50>
		return SBI_EINVAL;
	if (sbi_ecall_find_extension(ext->extid_start) ||
	    sbi_ecall_find_extension(ext->extid_end))
		return SBI_EINVAL;

	SBI_INIT_LIST_HEAD(&ext->head);
40f05898:	00a52023          	sw	a0,0(a0)
40f0589c:	00a52223          	sw	a0,4(a0)
 * Note: the new node is added before tail node.
 */
static inline void sbi_list_add_tail(struct sbi_dlist *new,
				     struct sbi_dlist *tnode)
{
	__sbi_list_add(new, tnode->prev, tnode);
40f058a0:	0046a783          	lw	a5,4(a3)
	new->next = next;
40f058a4:	00d52023          	sw	a3,0(a0)
	sbi_list_add_tail(&ext->head, &ecall_exts_list);

	return 0;
40f058a8:	00000713          	li	a4,0
	new->prev = prev;
40f058ac:	00f52223          	sw	a5,4(a0)
	prev->next = new;
40f058b0:	00a7a023          	sw	a0,0(a5)
}
40f058b4:	00c12403          	lw	s0,12(sp)
	next->prev = new;
40f058b8:	00005797          	auipc	a5,0x5
40f058bc:	74a7ae23          	sw	a0,1884(a5) # 40f0b014 <ecall_exts_list+0x4>
40f058c0:	00070513          	mv	a0,a4
40f058c4:	01010113          	addi	sp,sp,16
40f058c8:	00008067          	ret
40f058cc:	00c12403          	lw	s0,12(sp)
		return SBI_EINVAL;
40f058d0:	ffd00713          	li	a4,-3
}
40f058d4:	00070513          	mv	a0,a4
40f058d8:	01010113          	addi	sp,sp,16
40f058dc:	00008067          	ret

40f058e0 <sbi_ecall_unregister_extension>:

void sbi_ecall_unregister_extension(struct sbi_ecall_extension *ext)
{
40f058e0:	ff010113          	addi	sp,sp,-16
40f058e4:	00812623          	sw	s0,12(sp)
40f058e8:	01010413          	addi	s0,sp,16
	bool found = FALSE;
	struct sbi_ecall_extension *t;

	if (!ext)
40f058ec:	02050063          	beqz	a0,40f0590c <sbi_ecall_unregister_extension+0x2c>
		return;

	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f058f0:	00005717          	auipc	a4,0x5
40f058f4:	72070713          	addi	a4,a4,1824 # 40f0b010 <ecall_exts_list>
40f058f8:	00072783          	lw	a5,0(a4)
40f058fc:	00e78863          	beq	a5,a4,40f0590c <sbi_ecall_unregister_extension+0x2c>
		if (t == ext) {
40f05900:	00f50c63          	beq	a0,a5,40f05918 <sbi_ecall_unregister_extension+0x38>
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05904:	0007a783          	lw	a5,0(a5)
40f05908:	fee79ce3          	bne	a5,a4,40f05900 <sbi_ecall_unregister_extension+0x20>
		}
	}

	if (found)
		sbi_list_del_init(&ext->head);
}
40f0590c:	00c12403          	lw	s0,12(sp)
40f05910:	01010113          	addi	sp,sp,16
40f05914:	00008067          	ret
 * Deletes entry from list and reinitialize it.
 * @param entry the element to delete from the list.
 */
static inline void sbi_list_del_init(struct sbi_dlist *entry)
{
	__sbi_list_del_entry(entry);
40f05918:	00052783          	lw	a5,0(a0)
40f0591c:	00452703          	lw	a4,4(a0)
	prev->next = next;
40f05920:	00f72023          	sw	a5,0(a4)
	next->prev = prev;
40f05924:	00e7a223          	sw	a4,4(a5)
40f05928:	00c12403          	lw	s0,12(sp)
	SBI_INIT_LIST_HEAD(entry);
40f0592c:	00a52023          	sw	a0,0(a0)
40f05930:	00a52223          	sw	a0,4(a0)
40f05934:	01010113          	addi	sp,sp,16
40f05938:	00008067          	ret

40f0593c <sbi_ecall_handler>:

int sbi_ecall_handler(u32 hartid, ulong mcause, struct sbi_trap_regs *regs,
		      struct sbi_scratch *scratch)
{
40f0593c:	fa010113          	addi	sp,sp,-96
40f05940:	04812c23          	sw	s0,88(sp)
40f05944:	04912a23          	sw	s1,84(sp)
40f05948:	05312623          	sw	s3,76(sp)
40f0594c:	05412423          	sw	s4,72(sp)
40f05950:	05512223          	sw	s5,68(sp)
40f05954:	05612023          	sw	s6,64(sp)
40f05958:	03712e23          	sw	s7,60(sp)
40f0595c:	04112e23          	sw	ra,92(sp)
40f05960:	05212823          	sw	s2,80(sp)
40f05964:	03812c23          	sw	s8,56(sp)
40f05968:	06010413          	addi	s0,sp,96
40f0596c:	00060493          	mv	s1,a2
	struct sbi_trap_info trap = {0};
	unsigned long out_val = 0;
	bool is_0_1_spec = 0;
	unsigned long args[6];

	args[0] = regs->a0;
40f05970:	02964e03          	lbu	t3,41(a2)
	args[1] = regs->a1;
40f05974:	02d64303          	lbu	t1,45(a2)
	args[2] = regs->a2;
40f05978:	03164883          	lbu	a7,49(a2)
	args[0] = regs->a0;
40f0597c:	02864f83          	lbu	t6,40(a2)
	args[1] = regs->a1;
40f05980:	02c64f03          	lbu	t5,44(a2)
	args[0] = regs->a0;
40f05984:	02a64803          	lbu	a6,42(a2)
	args[2] = regs->a2;
40f05988:	0304ce83          	lbu	t4,48(s1)
	args[1] = regs->a1;
40f0598c:	02e64603          	lbu	a2,46(a2)
	args[2] = regs->a2;
40f05990:	0324c703          	lbu	a4,50(s1)
	args[0] = regs->a0;
40f05994:	02b4c503          	lbu	a0,43(s1)
	args[1] = regs->a1;
40f05998:	02f4c583          	lbu	a1,47(s1)
	args[2] = regs->a2;
40f0599c:	0334c783          	lbu	a5,51(s1)
	args[0] = regs->a0;
40f059a0:	008e1e13          	slli	t3,t3,0x8
	args[1] = regs->a1;
40f059a4:	00831313          	slli	t1,t1,0x8
	args[2] = regs->a2;
40f059a8:	00889893          	slli	a7,a7,0x8
	args[0] = regs->a0;
40f059ac:	01fe6e33          	or	t3,t3,t6
	args[1] = regs->a1;
40f059b0:	01e36333          	or	t1,t1,t5
	args[2] = regs->a2;
40f059b4:	01d8e8b3          	or	a7,a7,t4
	args[0] = regs->a0;
40f059b8:	01081813          	slli	a6,a6,0x10
	args[1] = regs->a1;
40f059bc:	01061613          	slli	a2,a2,0x10
	args[2] = regs->a2;
40f059c0:	01071713          	slli	a4,a4,0x10
	args[0] = regs->a0;
40f059c4:	01c86833          	or	a6,a6,t3
	args[1] = regs->a1;
40f059c8:	00666633          	or	a2,a2,t1
	args[2] = regs->a2;
40f059cc:	01176733          	or	a4,a4,a7
	args[0] = regs->a0;
40f059d0:	01851513          	slli	a0,a0,0x18
	args[1] = regs->a1;
40f059d4:	01859593          	slli	a1,a1,0x18
	args[2] = regs->a2;
40f059d8:	01879793          	slli	a5,a5,0x18
	args[0] = regs->a0;
40f059dc:	01056533          	or	a0,a0,a6
	args[1] = regs->a1;
40f059e0:	00c5e5b3          	or	a1,a1,a2
	args[2] = regs->a2;
40f059e4:	00e7e7b3          	or	a5,a5,a4
	unsigned long extension_id = regs->a7;
40f059e8:	0444c383          	lbu	t2,68(s1)
40f059ec:	0454cf83          	lbu	t6,69(s1)
40f059f0:	0464c703          	lbu	a4,70(s1)
40f059f4:	0474c903          	lbu	s2,71(s1)
	unsigned long func_id = regs->a6;
40f059f8:	0404c283          	lbu	t0,64(s1)
40f059fc:	0414cf03          	lbu	t5,65(s1)
40f05a00:	0424c603          	lbu	a2,66(s1)
40f05a04:	0434ce83          	lbu	t4,67(s1)
	args[3] = regs->a3;
40f05a08:	0344ce03          	lbu	t3,52(s1)
40f05a0c:	0354cc03          	lbu	s8,53(s1)
40f05a10:	0364c983          	lbu	s3,54(s1)
	args[1] = regs->a1;
40f05a14:	fab42e23          	sw	a1,-68(s0)
	struct sbi_trap_info trap = {0};
40f05a18:	fa042223          	sw	zero,-92(s0)
40f05a1c:	fa042423          	sw	zero,-88(s0)
40f05a20:	fa042623          	sw	zero,-84(s0)
40f05a24:	fa042823          	sw	zero,-80(s0)
40f05a28:	fa042a23          	sw	zero,-76(s0)
	unsigned long out_val = 0;
40f05a2c:	fa042023          	sw	zero,-96(s0)
	args[0] = regs->a0;
40f05a30:	faa42c23          	sw	a0,-72(s0)
	args[2] = regs->a2;
40f05a34:	fcf42023          	sw	a5,-64(s0)
	args[4] = regs->a4;
40f05a38:	0394c303          	lbu	t1,57(s1)
	args[5] = regs->a5;
40f05a3c:	03d4c783          	lbu	a5,61(s1)
	args[4] = regs->a4;
40f05a40:	0384cb83          	lbu	s7,56(s1)
40f05a44:	03a4ca83          	lbu	s5,58(s1)
	args[5] = regs->a5;
40f05a48:	03c4cb03          	lbu	s6,60(s1)
40f05a4c:	03e4c883          	lbu	a7,62(s1)
	args[3] = regs->a3;
40f05a50:	0374ca03          	lbu	s4,55(s1)
	args[4] = regs->a4;
40f05a54:	03b4c803          	lbu	a6,59(s1)
	args[5] = regs->a5;
40f05a58:	03f4c503          	lbu	a0,63(s1)
	args[3] = regs->a3;
40f05a5c:	008c1593          	slli	a1,s8,0x8
	args[4] = regs->a4;
40f05a60:	00831313          	slli	t1,t1,0x8
	args[5] = regs->a5;
40f05a64:	00879793          	slli	a5,a5,0x8
	args[3] = regs->a3;
40f05a68:	01c5ee33          	or	t3,a1,t3
	args[5] = regs->a5;
40f05a6c:	0167e7b3          	or	a5,a5,s6
	args[3] = regs->a3;
40f05a70:	01099993          	slli	s3,s3,0x10
	args[4] = regs->a4;
40f05a74:	01736333          	or	t1,t1,s7
40f05a78:	010a9a93          	slli	s5,s5,0x10
	args[5] = regs->a5;
40f05a7c:	01089893          	slli	a7,a7,0x10
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05a80:	00005597          	auipc	a1,0x5
40f05a84:	59058593          	addi	a1,a1,1424 # 40f0b010 <ecall_exts_list>
	args[3] = regs->a3;
40f05a88:	01c9e9b3          	or	s3,s3,t3
	args[5] = regs->a5;
40f05a8c:	00f8e8b3          	or	a7,a7,a5
	unsigned long extension_id = regs->a7;
40f05a90:	008f9f93          	slli	t6,t6,0x8
	unsigned long func_id = regs->a6;
40f05a94:	008f1f13          	slli	t5,t5,0x8
	args[3] = regs->a3;
40f05a98:	018a1e13          	slli	t3,s4,0x18
	args[4] = regs->a4;
40f05a9c:	006ae333          	or	t1,s5,t1
40f05aa0:	01881813          	slli	a6,a6,0x18
	args[5] = regs->a5;
40f05aa4:	01851513          	slli	a0,a0,0x18
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05aa8:	0005a783          	lw	a5,0(a1)
	unsigned long extension_id = regs->a7;
40f05aac:	007fefb3          	or	t6,t6,t2
40f05ab0:	01071713          	slli	a4,a4,0x10
	unsigned long func_id = regs->a6;
40f05ab4:	005f6f33          	or	t5,t5,t0
40f05ab8:	01061613          	slli	a2,a2,0x10
	args[3] = regs->a3;
40f05abc:	013e6e33          	or	t3,t3,s3
	args[4] = regs->a4;
40f05ac0:	00686833          	or	a6,a6,t1
	args[5] = regs->a5;
40f05ac4:	01156533          	or	a0,a0,a7
	unsigned long extension_id = regs->a7;
40f05ac8:	01f76733          	or	a4,a4,t6
40f05acc:	01891913          	slli	s2,s2,0x18
	unsigned long func_id = regs->a6;
40f05ad0:	01e66633          	or	a2,a2,t5
40f05ad4:	018e9e93          	slli	t4,t4,0x18
	args[3] = regs->a3;
40f05ad8:	fdc42223          	sw	t3,-60(s0)
	args[4] = regs->a4;
40f05adc:	fd042423          	sw	a6,-56(s0)
	args[5] = regs->a5;
40f05ae0:	fca42623          	sw	a0,-52(s0)
	unsigned long extension_id = regs->a7;
40f05ae4:	00e96933          	or	s2,s2,a4
	unsigned long func_id = regs->a6;
40f05ae8:	00cee633          	or	a2,t4,a2
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05aec:	02b78063          	beq	a5,a1,40f05b0c <sbi_ecall_handler+0x1d0>
40f05af0:	00068993          	mv	s3,a3
		if (t->extid_start <= extid && extid <= t->extid_end) {
40f05af4:	0087a703          	lw	a4,8(a5)
40f05af8:	00e96663          	bltu	s2,a4,40f05b04 <sbi_ecall_handler+0x1c8>
40f05afc:	00c7a703          	lw	a4,12(a5)
40f05b00:	0d277063          	bgeu	a4,s2,40f05bc0 <sbi_ecall_handler+0x284>
	sbi_list_for_each_entry(t, &ecall_exts_list, head) {
40f05b04:	0007a783          	lw	a5,0(a5)
40f05b08:	feb796e3          	bne	a5,a1,40f05af4 <sbi_ecall_handler+0x1b8>
		 * between a fatal and non-fatal errors yet. That's why we treat
		 * every return value except ETRAP as non-fatal and just return
		 * accordingly for now. Once fatal errors are defined, that
		 * case should be handled differently.
		 */
		regs->mepc += 4;
40f05b0c:	0814c683          	lbu	a3,129(s1)
40f05b10:	0804c603          	lbu	a2,128(s1)
40f05b14:	0824c703          	lbu	a4,130(s1)
40f05b18:	0834c783          	lbu	a5,131(s1)
40f05b1c:	00869693          	slli	a3,a3,0x8
40f05b20:	00c6e6b3          	or	a3,a3,a2
40f05b24:	01071713          	slli	a4,a4,0x10
40f05b28:	00d76733          	or	a4,a4,a3
40f05b2c:	01879793          	slli	a5,a5,0x18
40f05b30:	00e7e7b3          	or	a5,a5,a4
40f05b34:	00478793          	addi	a5,a5,4
		regs->a0 = ret;
40f05b38:	fff00713          	li	a4,-1
		regs->mepc += 4;
40f05b3c:	0087d593          	srli	a1,a5,0x8
40f05b40:	0107d613          	srli	a2,a5,0x10
40f05b44:	0187d693          	srli	a3,a5,0x18
40f05b48:	08f48023          	sb	a5,128(s1)
		regs->a0 = ret;
40f05b4c:	ffe00793          	li	a5,-2
40f05b50:	02f48423          	sb	a5,40(s1)
		regs->mepc += 4;
40f05b54:	08b480a3          	sb	a1,129(s1)
40f05b58:	08c48123          	sb	a2,130(s1)
40f05b5c:	08d481a3          	sb	a3,131(s1)
		regs->a0 = ret;
40f05b60:	02e484a3          	sb	a4,41(s1)
40f05b64:	02e48523          	sb	a4,42(s1)
40f05b68:	02e485a3          	sb	a4,43(s1)
40f05b6c:	00000793          	li	a5,0
		if (!is_0_1_spec)
			regs->a1 = out_val;
40f05b70:	0087d613          	srli	a2,a5,0x8
40f05b74:	0107d693          	srli	a3,a5,0x10
40f05b78:	0187d713          	srli	a4,a5,0x18
40f05b7c:	02f48623          	sb	a5,44(s1)
40f05b80:	02c486a3          	sb	a2,45(s1)
40f05b84:	02d48723          	sb	a3,46(s1)
40f05b88:	02e487a3          	sb	a4,47(s1)
	}

	return 0;
}
40f05b8c:	05c12083          	lw	ra,92(sp)
40f05b90:	05812403          	lw	s0,88(sp)
40f05b94:	05412483          	lw	s1,84(sp)
40f05b98:	05012903          	lw	s2,80(sp)
40f05b9c:	04c12983          	lw	s3,76(sp)
40f05ba0:	04812a03          	lw	s4,72(sp)
40f05ba4:	04412a83          	lw	s5,68(sp)
40f05ba8:	04012b03          	lw	s6,64(sp)
40f05bac:	03c12b83          	lw	s7,60(sp)
40f05bb0:	03812c03          	lw	s8,56(sp)
40f05bb4:	00000513          	li	a0,0
40f05bb8:	06010113          	addi	sp,sp,96
40f05bbc:	00008067          	ret
	if (ext && ext->handle) {
40f05bc0:	0147a803          	lw	a6,20(a5)
40f05bc4:	f40804e3          	beqz	a6,40f05b0c <sbi_ecall_handler+0x1d0>
		ret = ext->handle(scratch, extension_id, func_id,
40f05bc8:	fa440793          	addi	a5,s0,-92
40f05bcc:	fa040713          	addi	a4,s0,-96
40f05bd0:	fb840693          	addi	a3,s0,-72
40f05bd4:	00090593          	mv	a1,s2
40f05bd8:	00098513          	mv	a0,s3
40f05bdc:	000800e7          	jalr	a6
		if (extension_id >= SBI_EXT_0_1_SET_TIMER &&
40f05be0:	00800793          	li	a5,8
40f05be4:	0814c683          	lbu	a3,129(s1)
40f05be8:	0804c603          	lbu	a2,128(s1)
40f05bec:	0824c703          	lbu	a4,130(s1)
40f05bf0:	0727e663          	bltu	a5,s2,40f05c5c <sbi_ecall_handler+0x320>
	if (ret == SBI_ETRAP) {
40f05bf4:	0834c783          	lbu	a5,131(s1)
40f05bf8:	00869693          	slli	a3,a3,0x8
40f05bfc:	00c6e6b3          	or	a3,a3,a2
40f05c00:	01071713          	slli	a4,a4,0x10
40f05c04:	00d76733          	or	a4,a4,a3
40f05c08:	01879793          	slli	a5,a5,0x18
40f05c0c:	00e7e7b3          	or	a5,a5,a4
40f05c10:	ff300693          	li	a3,-13
40f05c14:	00078713          	mv	a4,a5
40f05c18:	0ad50863          	beq	a0,a3,40f05cc8 <sbi_ecall_handler+0x38c>
		regs->mepc += 4;
40f05c1c:	00478793          	addi	a5,a5,4
40f05c20:	0087d893          	srli	a7,a5,0x8
40f05c24:	0107d813          	srli	a6,a5,0x10
40f05c28:	0187d593          	srli	a1,a5,0x18
		regs->a0 = ret;
40f05c2c:	00855613          	srli	a2,a0,0x8
40f05c30:	01055693          	srli	a3,a0,0x10
40f05c34:	01855713          	srli	a4,a0,0x18
		regs->mepc += 4;
40f05c38:	08f48023          	sb	a5,128(s1)
40f05c3c:	091480a3          	sb	a7,129(s1)
40f05c40:	09048123          	sb	a6,130(s1)
40f05c44:	08b481a3          	sb	a1,131(s1)
		regs->a0 = ret;
40f05c48:	02a48423          	sb	a0,40(s1)
40f05c4c:	02c484a3          	sb	a2,41(s1)
40f05c50:	02d48523          	sb	a3,42(s1)
40f05c54:	02e485a3          	sb	a4,43(s1)
		if (!is_0_1_spec)
40f05c58:	f35ff06f          	j	40f05b8c <sbi_ecall_handler+0x250>
	if (ret == SBI_ETRAP) {
40f05c5c:	0834c783          	lbu	a5,131(s1)
40f05c60:	00869693          	slli	a3,a3,0x8
40f05c64:	00c6e6b3          	or	a3,a3,a2
40f05c68:	01071713          	slli	a4,a4,0x10
40f05c6c:	00d76733          	or	a4,a4,a3
40f05c70:	01879793          	slli	a5,a5,0x18
40f05c74:	00e7e7b3          	or	a5,a5,a4
40f05c78:	ff300693          	li	a3,-13
40f05c7c:	00078713          	mv	a4,a5
40f05c80:	04d50463          	beq	a0,a3,40f05cc8 <sbi_ecall_handler+0x38c>
		regs->mepc += 4;
40f05c84:	00478793          	addi	a5,a5,4
40f05c88:	0087d893          	srli	a7,a5,0x8
40f05c8c:	0107d813          	srli	a6,a5,0x10
40f05c90:	0187d593          	srli	a1,a5,0x18
		regs->a0 = ret;
40f05c94:	00855613          	srli	a2,a0,0x8
40f05c98:	01055693          	srli	a3,a0,0x10
40f05c9c:	01855713          	srli	a4,a0,0x18
		regs->mepc += 4;
40f05ca0:	08f48023          	sb	a5,128(s1)
40f05ca4:	091480a3          	sb	a7,129(s1)
40f05ca8:	09048123          	sb	a6,130(s1)
40f05cac:	08b481a3          	sb	a1,131(s1)
		regs->a0 = ret;
40f05cb0:	02a48423          	sb	a0,40(s1)
40f05cb4:	02c484a3          	sb	a2,41(s1)
40f05cb8:	02d48523          	sb	a3,42(s1)
40f05cbc:	02e485a3          	sb	a4,43(s1)
		if (!is_0_1_spec)
40f05cc0:	fa042783          	lw	a5,-96(s0)
40f05cc4:	eadff06f          	j	40f05b70 <sbi_ecall_handler+0x234>
		sbi_trap_redirect(regs, &trap, scratch);
40f05cc8:	00098613          	mv	a2,s3
40f05ccc:	fa440593          	addi	a1,s0,-92
40f05cd0:	00048513          	mv	a0,s1
		trap.epc = regs->mepc;
40f05cd4:	fae42223          	sw	a4,-92(s0)
		sbi_trap_redirect(regs, &trap, scratch);
40f05cd8:	ecdfc0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
40f05cdc:	eb1ff06f          	j	40f05b8c <sbi_ecall_handler+0x250>

40f05ce0 <sbi_ecall_init>:

int sbi_ecall_init(void)
{
40f05ce0:	ff010113          	addi	sp,sp,-16
40f05ce4:	00812423          	sw	s0,8(sp)
40f05ce8:	00112623          	sw	ra,12(sp)
40f05cec:	01010413          	addi	s0,sp,16
	int ret;

	/* The order of below registrations is performance optimized */
	ret = sbi_ecall_register_extension(&ecall_time);
40f05cf0:	00005517          	auipc	a0,0x5
40f05cf4:	40c50513          	addi	a0,a0,1036 # 40f0b0fc <ecall_time>
40f05cf8:	b39ff0ef          	jal	ra,40f05830 <sbi_ecall_register_extension>
	if (ret)
40f05cfc:	00050a63          	beqz	a0,40f05d10 <sbi_ecall_init+0x30>
	ret = sbi_ecall_register_extension(&ecall_vendor);
	if (ret)
		return ret;

	return 0;
}
40f05d00:	00c12083          	lw	ra,12(sp)
40f05d04:	00812403          	lw	s0,8(sp)
40f05d08:	01010113          	addi	sp,sp,16
40f05d0c:	00008067          	ret
	ret = sbi_ecall_register_extension(&ecall_rfence);
40f05d10:	00005517          	auipc	a0,0x5
40f05d14:	3d450513          	addi	a0,a0,980 # 40f0b0e4 <ecall_rfence>
40f05d18:	b19ff0ef          	jal	ra,40f05830 <sbi_ecall_register_extension>
	if (ret)
40f05d1c:	fe0512e3          	bnez	a0,40f05d00 <sbi_ecall_init+0x20>
	ret = sbi_ecall_register_extension(&ecall_ipi);
40f05d20:	00005517          	auipc	a0,0x5
40f05d24:	3ac50513          	addi	a0,a0,940 # 40f0b0cc <ecall_ipi>
40f05d28:	b09ff0ef          	jal	ra,40f05830 <sbi_ecall_register_extension>
	if (ret)
40f05d2c:	fc051ae3          	bnez	a0,40f05d00 <sbi_ecall_init+0x20>
	ret = sbi_ecall_register_extension(&ecall_base);
40f05d30:	00005517          	auipc	a0,0x5
40f05d34:	36c50513          	addi	a0,a0,876 # 40f0b09c <ecall_base>
40f05d38:	af9ff0ef          	jal	ra,40f05830 <sbi_ecall_register_extension>
	if (ret)
40f05d3c:	fc0512e3          	bnez	a0,40f05d00 <sbi_ecall_init+0x20>
	ret = sbi_ecall_register_extension(&ecall_legacy);
40f05d40:	00005517          	auipc	a0,0x5
40f05d44:	37450513          	addi	a0,a0,884 # 40f0b0b4 <ecall_legacy>
40f05d48:	ae9ff0ef          	jal	ra,40f05830 <sbi_ecall_register_extension>
	if (ret)
40f05d4c:	fa051ae3          	bnez	a0,40f05d00 <sbi_ecall_init+0x20>
	ret = sbi_ecall_register_extension(&ecall_vendor);
40f05d50:	00005517          	auipc	a0,0x5
40f05d54:	3c450513          	addi	a0,a0,964 # 40f0b114 <ecall_vendor>
40f05d58:	ad9ff0ef          	jal	ra,40f05830 <sbi_ecall_register_extension>
	if (ret)
40f05d5c:	fa5ff06f          	j	40f05d00 <sbi_ecall_init+0x20>

40f05d60 <sbi_ecall_base_handler>:
				  unsigned long *args, unsigned long *out_val,
				  struct sbi_trap_info *out_trap)
{
	int ret = 0;

	switch (funcid) {
40f05d60:	00600793          	li	a5,6
40f05d64:	10c7e063          	bltu	a5,a2,40f05e64 <sbi_ecall_base_handler+0x104>
40f05d68:	00005597          	auipc	a1,0x5
40f05d6c:	9f058593          	addi	a1,a1,-1552 # 40f0a758 <platform_ops+0x174>
40f05d70:	00261613          	slli	a2,a2,0x2
40f05d74:	00b60633          	add	a2,a2,a1
40f05d78:	00062783          	lw	a5,0(a2)
40f05d7c:	00b787b3          	add	a5,a5,a1
40f05d80:	00078067          	jr	a5
		break;
	case SBI_EXT_BASE_GET_MVENDORID:
		*out_val = csr_read(CSR_MVENDORID);
		break;
	case SBI_EXT_BASE_GET_MARCHID:
		*out_val = csr_read(CSR_MARCHID);
40f05d84:	f12027f3          	csrr	a5,marchid
	int ret = 0;
40f05d88:	00000513          	li	a0,0
		*out_val = csr_read(CSR_MARCHID);
40f05d8c:	00f72023          	sw	a5,0(a4)
		break;
40f05d90:	00008067          	ret
	case SBI_EXT_BASE_GET_MIMPID:
		*out_val = csr_read(CSR_MIMPID);
40f05d94:	f13027f3          	csrr	a5,mimpid
	int ret = 0;
40f05d98:	00000513          	li	a0,0
		*out_val = csr_read(CSR_MIMPID);
40f05d9c:	00f72023          	sw	a5,0(a4)
		break;
40f05da0:	00008067          	ret
		*out_val = *out_val | SBI_ECALL_VERSION_MINOR;
40f05da4:	00200793          	li	a5,2
40f05da8:	00f72023          	sw	a5,0(a4)
	int ret = 0;
40f05dac:	00000513          	li	a0,0
		break;
40f05db0:	00008067          	ret
		*out_val = SBI_OPENSBI_IMPID;
40f05db4:	00100793          	li	a5,1
40f05db8:	00f72023          	sw	a5,0(a4)
	int ret = 0;
40f05dbc:	00000513          	li	a0,0
		break;
40f05dc0:	00008067          	ret
		*out_val = OPENSBI_VERSION;
40f05dc4:	00600793          	li	a5,6
40f05dc8:	00f72023          	sw	a5,0(a4)
	int ret = 0;
40f05dcc:	00000513          	li	a0,0
		break;
40f05dd0:	00008067          	ret
{
40f05dd4:	fe010113          	addi	sp,sp,-32
40f05dd8:	00812c23          	sw	s0,24(sp)
40f05ddc:	00912a23          	sw	s1,20(sp)
40f05de0:	01212823          	sw	s2,16(sp)
40f05de4:	01312623          	sw	s3,12(sp)
40f05de8:	00112e23          	sw	ra,28(sp)
40f05dec:	02010413          	addi	s0,sp,32
	case SBI_EXT_BASE_PROBE_EXT:
		ret = sbi_ecall_base_probe(scratch, args[0], out_val);
40f05df0:	0006a983          	lw	s3,0(a3)
40f05df4:	00050913          	mv	s2,a0
40f05df8:	00070493          	mv	s1,a4
	ext = sbi_ecall_find_extension(extid);
40f05dfc:	00098513          	mv	a0,s3
40f05e00:	9e9ff0ef          	jal	ra,40f057e8 <sbi_ecall_find_extension>
	if (!ext) {
40f05e04:	04050c63          	beqz	a0,40f05e5c <sbi_ecall_base_handler+0xfc>
	if (ext->probe)
40f05e08:	01052783          	lw	a5,16(a0)
40f05e0c:	04078063          	beqz	a5,40f05e4c <sbi_ecall_base_handler+0xec>
		return ext->probe(scratch, extid, out_val);
40f05e10:	00048613          	mv	a2,s1
40f05e14:	00098593          	mv	a1,s3
40f05e18:	00090513          	mv	a0,s2
40f05e1c:	000780e7          	jalr	a5
	default:
		ret = SBI_ENOTSUPP;
	}

	return ret;
}
40f05e20:	01c12083          	lw	ra,28(sp)
40f05e24:	01812403          	lw	s0,24(sp)
40f05e28:	01412483          	lw	s1,20(sp)
40f05e2c:	01012903          	lw	s2,16(sp)
40f05e30:	00c12983          	lw	s3,12(sp)
40f05e34:	02010113          	addi	sp,sp,32
40f05e38:	00008067          	ret
		*out_val = csr_read(CSR_MVENDORID);
40f05e3c:	f11027f3          	csrr	a5,mvendorid
	int ret = 0;
40f05e40:	00000513          	li	a0,0
		*out_val = csr_read(CSR_MVENDORID);
40f05e44:	00f72023          	sw	a5,0(a4)
		break;
40f05e48:	00008067          	ret
	*out_val = 1;
40f05e4c:	00100793          	li	a5,1
40f05e50:	00f4a023          	sw	a5,0(s1)
	return 0;
40f05e54:	00000513          	li	a0,0
40f05e58:	fc9ff06f          	j	40f05e20 <sbi_ecall_base_handler+0xc0>
		*out_val = 0;
40f05e5c:	0004a023          	sw	zero,0(s1)
		return 0;
40f05e60:	fc1ff06f          	j	40f05e20 <sbi_ecall_base_handler+0xc0>
		ret = SBI_ENOTSUPP;
40f05e64:	ffe00513          	li	a0,-2
}
40f05e68:	00008067          	ret

40f05e6c <sbi_load_hart_mask_unpriv>:
#include <sbi/sbi_hart.h>

static int sbi_load_hart_mask_unpriv(struct sbi_scratch *scratch,
				     ulong *pmask, ulong *hmask,
				     struct sbi_trap_info *uptrap)
{
40f05e6c:	ff010113          	addi	sp,sp,-16
40f05e70:	00812423          	sw	s0,8(sp)
40f05e74:	01212023          	sw	s2,0(sp)
40f05e78:	00112623          	sw	ra,12(sp)
40f05e7c:	00912223          	sw	s1,4(sp)
40f05e80:	01010413          	addi	s0,sp,16
40f05e84:	00060913          	mv	s2,a2
	ulong mask = 0;

	if (pmask) {
40f05e88:	04058263          	beqz	a1,40f05ecc <sbi_load_hart_mask_unpriv+0x60>
40f05e8c:	00058793          	mv	a5,a1
		mask = sbi_load_ulong(pmask, scratch, uptrap);
40f05e90:	00068613          	mv	a2,a3
40f05e94:	00050593          	mv	a1,a0
40f05e98:	00078513          	mv	a0,a5
40f05e9c:	00068493          	mv	s1,a3
40f05ea0:	548020ef          	jal	ra,40f083e8 <sbi_load_ulong>
		if (uptrap->cause)
40f05ea4:	0044a783          	lw	a5,4(s1)
40f05ea8:	02079663          	bnez	a5,40f05ed4 <sbi_load_hart_mask_unpriv+0x68>
			return SBI_ETRAP;
	} else {
		mask = sbi_hart_available_mask();
	}
	*hmask = mask;
40f05eac:	00a92023          	sw	a0,0(s2)
	return 0;
40f05eb0:	00000513          	li	a0,0
}
40f05eb4:	00c12083          	lw	ra,12(sp)
40f05eb8:	00812403          	lw	s0,8(sp)
40f05ebc:	00412483          	lw	s1,4(sp)
40f05ec0:	00012903          	lw	s2,0(sp)
40f05ec4:	01010113          	addi	sp,sp,16
40f05ec8:	00008067          	ret
		mask = sbi_hart_available_mask();
40f05ecc:	46c010ef          	jal	ra,40f07338 <sbi_hart_available_mask>
40f05ed0:	fddff06f          	j	40f05eac <sbi_load_hart_mask_unpriv+0x40>
			return SBI_ETRAP;
40f05ed4:	ff300513          	li	a0,-13
40f05ed8:	fddff06f          	j	40f05eb4 <sbi_load_hart_mask_unpriv+0x48>

40f05edc <sbi_ecall_legacy_handler>:

static int sbi_ecall_legacy_handler(struct sbi_scratch *scratch,
				    unsigned long extid, unsigned long funcid,
				    unsigned long *args, unsigned long *out_val,
				    struct sbi_trap_info *out_trap)
{
40f05edc:	fc010113          	addi	sp,sp,-64
40f05ee0:	02812c23          	sw	s0,56(sp)
40f05ee4:	02912a23          	sw	s1,52(sp)
40f05ee8:	03212823          	sw	s2,48(sp)
40f05eec:	03312623          	sw	s3,44(sp)
40f05ef0:	03412423          	sw	s4,40(sp)
40f05ef4:	04010413          	addi	s0,sp,64
40f05ef8:	02112e23          	sw	ra,60(sp)
40f05efc:	00050993          	mv	s3,a0
40f05f00:	00058493          	mv	s1,a1
40f05f04:	00068913          	mv	s2,a3
40f05f08:	00078a13          	mv	s4,a5
	int ret = 0;
	struct sbi_tlb_info tlb_info;
	u32 source_hart = sbi_current_hartid();
40f05f0c:	3ad000ef          	jal	ra,40f06ab8 <sbi_current_hartid>
	ulong hmask = 0;

	switch (extid) {
40f05f10:	00800713          	li	a4,8
	ulong hmask = 0;
40f05f14:	fc042423          	sw	zero,-56(s0)
	switch (extid) {
40f05f18:	22976263          	bltu	a4,s1,40f0613c <sbi_ecall_legacy_handler+0x260>
40f05f1c:	00005617          	auipc	a2,0x5
40f05f20:	85860613          	addi	a2,a2,-1960 # 40f0a774 <platform_ops+0x190>
40f05f24:	00249493          	slli	s1,s1,0x2
40f05f28:	00c484b3          	add	s1,s1,a2
40f05f2c:	0004a703          	lw	a4,0(s1)
40f05f30:	00c70733          	add	a4,a4,a2
40f05f34:	00070067          	jr	a4
						&hmask, out_trap);
		if (ret != SBI_ETRAP)
			ret = sbi_tlb_request(scratch, hmask, 0, &tlb_info);
		break;
	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
		tlb_info.start = (unsigned long)args[1];
40f05f38:	00492303          	lw	t1,4(s2)
		tlb_info.size  = (unsigned long)args[2];
40f05f3c:	00892883          	lw	a7,8(s2)
		tlb_info.asid  = (unsigned long)args[3];
40f05f40:	00c92803          	lw	a6,12(s2)
		tlb_info.type  = SBI_TLB_FLUSH_VMA_ASID;
		tlb_info.shart_mask = 1UL << source_hart;
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f05f44:	00092583          	lw	a1,0(s2)
		tlb_info.type  = SBI_TLB_FLUSH_VMA_ASID;
40f05f48:	00100793          	li	a5,1
		tlb_info.shart_mask = 1UL << source_hart;
40f05f4c:	00a79733          	sll	a4,a5,a0
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f05f50:	000a0693          	mv	a3,s4
40f05f54:	fc840613          	addi	a2,s0,-56
40f05f58:	00098513          	mv	a0,s3
		tlb_info.type  = SBI_TLB_FLUSH_VMA_ASID;
40f05f5c:	fcf42c23          	sw	a5,-40(s0)
		tlb_info.start = (unsigned long)args[1];
40f05f60:	fc642623          	sw	t1,-52(s0)
		tlb_info.size  = (unsigned long)args[2];
40f05f64:	fd142823          	sw	a7,-48(s0)
		tlb_info.asid  = (unsigned long)args[3];
40f05f68:	fd042a23          	sw	a6,-44(s0)
		tlb_info.shart_mask = 1UL << source_hart;
40f05f6c:	fce42e23          	sw	a4,-36(s0)
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f05f70:	efdff0ef          	jal	ra,40f05e6c <sbi_load_hart_mask_unpriv>
						&hmask, out_trap);
		if (ret != SBI_ETRAP)
40f05f74:	ff300793          	li	a5,-13
40f05f78:	10f50063          	beq	a0,a5,40f06078 <sbi_ecall_legacy_handler+0x19c>
			ret = sbi_tlb_request(scratch, hmask, 0, &tlb_info);
40f05f7c:	fc842583          	lw	a1,-56(s0)
40f05f80:	fcc40693          	addi	a3,s0,-52
40f05f84:	00000613          	li	a2,0
40f05f88:	00098513          	mv	a0,s3
40f05f8c:	9a1fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
	default:
		ret = SBI_ENOTSUPP;
	};

	return ret;
}
40f05f90:	03c12083          	lw	ra,60(sp)
40f05f94:	03812403          	lw	s0,56(sp)
40f05f98:	03412483          	lw	s1,52(sp)
40f05f9c:	03012903          	lw	s2,48(sp)
40f05fa0:	02c12983          	lw	s3,44(sp)
40f05fa4:	02812a03          	lw	s4,40(sp)
40f05fa8:	04010113          	addi	sp,sp,64
40f05fac:	00008067          	ret
		sbi_timer_event_start(scratch,
40f05fb0:	00092583          	lw	a1,0(s2)
40f05fb4:	00492603          	lw	a2,4(s2)
40f05fb8:	00098513          	mv	a0,s3
40f05fbc:	80cfc0ef          	jal	ra,40f01fc8 <sbi_timer_event_start>
}
40f05fc0:	03c12083          	lw	ra,60(sp)
40f05fc4:	03812403          	lw	s0,56(sp)
40f05fc8:	03412483          	lw	s1,52(sp)
40f05fcc:	03012903          	lw	s2,48(sp)
40f05fd0:	02c12983          	lw	s3,44(sp)
40f05fd4:	02812a03          	lw	s4,40(sp)
	int ret = 0;
40f05fd8:	00000513          	li	a0,0
}
40f05fdc:	04010113          	addi	sp,sp,64
40f05fe0:	00008067          	ret
		sbi_ipi_clear_smode(scratch);
40f05fe4:	00098513          	mv	a0,s3
40f05fe8:	c54fb0ef          	jal	ra,40f0143c <sbi_ipi_clear_smode>
}
40f05fec:	03c12083          	lw	ra,60(sp)
40f05ff0:	03812403          	lw	s0,56(sp)
40f05ff4:	03412483          	lw	s1,52(sp)
40f05ff8:	03012903          	lw	s2,48(sp)
40f05ffc:	02c12983          	lw	s3,44(sp)
40f06000:	02812a03          	lw	s4,40(sp)
	int ret = 0;
40f06004:	00000513          	li	a0,0
}
40f06008:	04010113          	addi	sp,sp,64
40f0600c:	00008067          	ret
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f06010:	00092583          	lw	a1,0(s2)
40f06014:	000a0693          	mv	a3,s4
40f06018:	fc840613          	addi	a2,s0,-56
40f0601c:	00098513          	mv	a0,s3
40f06020:	e4dff0ef          	jal	ra,40f05e6c <sbi_load_hart_mask_unpriv>
		if (ret != SBI_ETRAP)
40f06024:	ff300793          	li	a5,-13
40f06028:	04f50863          	beq	a0,a5,40f06078 <sbi_ecall_legacy_handler+0x19c>
			ret = sbi_ipi_send_smode(scratch, hmask, 0);
40f0602c:	fc842583          	lw	a1,-56(s0)
40f06030:	00000613          	li	a2,0
40f06034:	00098513          	mv	a0,s3
40f06038:	bd0fb0ef          	jal	ra,40f01408 <sbi_ipi_send_smode>
40f0603c:	f55ff06f          	j	40f05f90 <sbi_ecall_legacy_handler+0xb4>
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f06040:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f06044:	00100793          	li	a5,1
40f06048:	00a797b3          	sll	a5,a5,a0
		tlb_info.type  = SBI_ITLB_FLUSH;
40f0604c:	00600713          	li	a4,6
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f06050:	000a0693          	mv	a3,s4
40f06054:	fc840613          	addi	a2,s0,-56
40f06058:	00098513          	mv	a0,s3
		tlb_info.shart_mask = 1UL << source_hart;
40f0605c:	fcf42e23          	sw	a5,-36(s0)
		tlb_info.start  = 0;
40f06060:	fc042623          	sw	zero,-52(s0)
		tlb_info.size  = 0;
40f06064:	fc042823          	sw	zero,-48(s0)
		tlb_info.type  = SBI_ITLB_FLUSH;
40f06068:	fce42c23          	sw	a4,-40(s0)
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f0606c:	e01ff0ef          	jal	ra,40f05e6c <sbi_load_hart_mask_unpriv>
		if (ret != SBI_ETRAP)
40f06070:	ff300793          	li	a5,-13
40f06074:	f0f514e3          	bne	a0,a5,40f05f7c <sbi_ecall_legacy_handler+0xa0>
	int ret = 0;
40f06078:	ff300513          	li	a0,-13
}
40f0607c:	03c12083          	lw	ra,60(sp)
40f06080:	03812403          	lw	s0,56(sp)
40f06084:	03412483          	lw	s1,52(sp)
40f06088:	03012903          	lw	s2,48(sp)
40f0608c:	02c12983          	lw	s3,44(sp)
40f06090:	02812a03          	lw	s4,40(sp)
40f06094:	04010113          	addi	sp,sp,64
40f06098:	00008067          	ret
		tlb_info.start = (unsigned long)args[1];
40f0609c:	00492803          	lw	a6,4(s2)
		tlb_info.size  = (unsigned long)args[2];
40f060a0:	00892703          	lw	a4,8(s2)
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f060a4:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f060a8:	00100793          	li	a5,1
40f060ac:	00a797b3          	sll	a5,a5,a0
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f060b0:	000a0693          	mv	a3,s4
40f060b4:	fc840613          	addi	a2,s0,-56
40f060b8:	00098513          	mv	a0,s3
		tlb_info.shart_mask = 1UL << source_hart;
40f060bc:	fcf42e23          	sw	a5,-36(s0)
		tlb_info.start = (unsigned long)args[1];
40f060c0:	fd042623          	sw	a6,-52(s0)
		tlb_info.size  = (unsigned long)args[2];
40f060c4:	fce42823          	sw	a4,-48(s0)
		tlb_info.type  = SBI_TLB_FLUSH_VMA;
40f060c8:	fc042c23          	sw	zero,-40(s0)
		ret = sbi_load_hart_mask_unpriv(scratch, (ulong *)args[0],
40f060cc:	da1ff0ef          	jal	ra,40f05e6c <sbi_load_hart_mask_unpriv>
		if (ret != SBI_ETRAP)
40f060d0:	ff300793          	li	a5,-13
40f060d4:	eaf514e3          	bne	a0,a5,40f05f7c <sbi_ecall_legacy_handler+0xa0>
	int ret = 0;
40f060d8:	ff300513          	li	a0,-13
40f060dc:	fa1ff06f          	j	40f0607c <sbi_ecall_legacy_handler+0x1a0>
		sbi_putc(args[0]);
40f060e0:	00094503          	lbu	a0,0(s2)
40f060e4:	8d1fe0ef          	jal	ra,40f049b4 <sbi_putc>
}
40f060e8:	03c12083          	lw	ra,60(sp)
40f060ec:	03812403          	lw	s0,56(sp)
40f060f0:	03412483          	lw	s1,52(sp)
40f060f4:	03012903          	lw	s2,48(sp)
40f060f8:	02c12983          	lw	s3,44(sp)
40f060fc:	02812a03          	lw	s4,40(sp)
	int ret = 0;
40f06100:	00000513          	li	a0,0
}
40f06104:	04010113          	addi	sp,sp,64
40f06108:	00008067          	ret
		ret = sbi_getc();
40f0610c:	819fe0ef          	jal	ra,40f04924 <sbi_getc>
}
40f06110:	03c12083          	lw	ra,60(sp)
40f06114:	03812403          	lw	s0,56(sp)
40f06118:	03412483          	lw	s1,52(sp)
40f0611c:	03012903          	lw	s2,48(sp)
40f06120:	02c12983          	lw	s3,44(sp)
40f06124:	02812a03          	lw	s4,40(sp)
40f06128:	04010113          	addi	sp,sp,64
40f0612c:	00008067          	ret
		sbi_system_shutdown(scratch, 0);
40f06130:	00000593          	li	a1,0
40f06134:	00098513          	mv	a0,s3
40f06138:	bd9fb0ef          	jal	ra,40f01d10 <sbi_system_shutdown>
		ret = SBI_ENOTSUPP;
40f0613c:	ffe00513          	li	a0,-2
	return ret;
40f06140:	e51ff06f          	j	40f05f90 <sbi_ecall_legacy_handler+0xb4>

40f06144 <sbi_ecall_time_handler>:
				  unsigned long *args, unsigned long *out_val,
				  struct sbi_trap_info *out_trap)
{
	int ret = 0;

	if (funcid == SBI_EXT_TIME_SET_TIMER) {
40f06144:	02061a63          	bnez	a2,40f06178 <sbi_ecall_time_handler+0x34>
{
40f06148:	ff010113          	addi	sp,sp,-16
40f0614c:	00812423          	sw	s0,8(sp)
40f06150:	00112623          	sw	ra,12(sp)
40f06154:	01010413          	addi	s0,sp,16
#if __riscv_xlen == 32
		sbi_timer_event_start(scratch,
40f06158:	0006a583          	lw	a1,0(a3)
40f0615c:	0046a603          	lw	a2,4(a3)
40f06160:	e69fb0ef          	jal	ra,40f01fc8 <sbi_timer_event_start>
#endif
	} else
		ret = SBI_ENOTSUPP;

	return ret;
}
40f06164:	00c12083          	lw	ra,12(sp)
40f06168:	00812403          	lw	s0,8(sp)
	int ret = 0;
40f0616c:	00000513          	li	a0,0
}
40f06170:	01010113          	addi	sp,sp,16
40f06174:	00008067          	ret
		ret = SBI_ENOTSUPP;
40f06178:	ffe00513          	li	a0,-2
}
40f0617c:	00008067          	ret

40f06180 <sbi_ecall_rfence_handler>:

static int sbi_ecall_rfence_handler(struct sbi_scratch *scratch,
				    unsigned long extid, unsigned long funcid,
				    unsigned long *args, unsigned long *out_val,
				    struct sbi_trap_info *out_trap)
{
40f06180:	fc010113          	addi	sp,sp,-64
40f06184:	02812c23          	sw	s0,56(sp)
40f06188:	02912a23          	sw	s1,52(sp)
40f0618c:	03212823          	sw	s2,48(sp)
40f06190:	03312623          	sw	s3,44(sp)
40f06194:	03412423          	sw	s4,40(sp)
40f06198:	02112e23          	sw	ra,60(sp)
40f0619c:	04010413          	addi	s0,sp,64
40f061a0:	00060493          	mv	s1,a2
40f061a4:	00050a13          	mv	s4,a0
40f061a8:	00068913          	mv	s2,a3
	int ret = 0;
	struct sbi_tlb_info tlb_info;
	u32 source_hart = sbi_current_hartid();
40f061ac:	10d000ef          	jal	ra,40f06ab8 <sbi_current_hartid>

	if (funcid >= SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA &&
40f061b0:	ffd48713          	addi	a4,s1,-3
40f061b4:	00300793          	li	a5,3
	u32 source_hart = sbi_current_hartid();
40f061b8:	00050993          	mv	s3,a0
	if (funcid >= SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA &&
40f061bc:	02e7f463          	bgeu	a5,a4,40f061e4 <sbi_ecall_rfence_handler+0x64>
	    funcid <= SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID)
		if (!misa_extension('H'))
			return SBI_ENOTSUPP;

	switch (funcid) {
40f061c0:	00600793          	li	a5,6
40f061c4:	0297e663          	bltu	a5,s1,40f061f0 <sbi_ecall_rfence_handler+0x70>
40f061c8:	00004717          	auipc	a4,0x4
40f061cc:	5d070713          	addi	a4,a4,1488 # 40f0a798 <platform_ops+0x1b4>
40f061d0:	00249493          	slli	s1,s1,0x2
40f061d4:	00e484b3          	add	s1,s1,a4
40f061d8:	0004a783          	lw	a5,0(s1)
40f061dc:	00e787b3          	add	a5,a5,a4
40f061e0:	00078067          	jr	a5
		if (!misa_extension('H'))
40f061e4:	04800513          	li	a0,72
40f061e8:	dedfd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f061ec:	fc051ae3          	bnez	a0,40f061c0 <sbi_ecall_rfence_handler+0x40>
			return SBI_ENOTSUPP;
40f061f0:	ffe00513          	li	a0,-2
40f061f4:	03c0006f          	j	40f06230 <sbi_ecall_rfence_handler+0xb0>
		tlb_info.type  = SBI_TLB_FLUSH_GVMA_VMID;
		tlb_info.shart_mask = 1UL << source_hart;
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
		break;
	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
		tlb_info.start = (unsigned long)args[2];
40f061f8:	00892803          	lw	a6,8(s2)
		tlb_info.size  = (unsigned long)args[3];
40f061fc:	00c92703          	lw	a4,12(s2)
		tlb_info.type  = SBI_TLB_FLUSH_VVMA;
		tlb_info.shart_mask = 1UL << source_hart;
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06200:	00492603          	lw	a2,4(s2)
40f06204:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f06208:	00100793          	li	a5,1
40f0620c:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06210:	fcc40693          	addi	a3,s0,-52
		tlb_info.type  = SBI_TLB_FLUSH_VVMA;
40f06214:	00400793          	li	a5,4
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06218:	000a0513          	mv	a0,s4
		tlb_info.start = (unsigned long)args[2];
40f0621c:	fd042623          	sw	a6,-52(s0)
		tlb_info.size  = (unsigned long)args[3];
40f06220:	fce42823          	sw	a4,-48(s0)
		tlb_info.type  = SBI_TLB_FLUSH_VVMA;
40f06224:	fcf42c23          	sw	a5,-40(s0)
		tlb_info.shart_mask = 1UL << source_hart;
40f06228:	fd342e23          	sw	s3,-36(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f0622c:	f00fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
	default:
		ret = SBI_ENOTSUPP;
	};

	return ret;
}
40f06230:	03c12083          	lw	ra,60(sp)
40f06234:	03812403          	lw	s0,56(sp)
40f06238:	03412483          	lw	s1,52(sp)
40f0623c:	03012903          	lw	s2,48(sp)
40f06240:	02c12983          	lw	s3,44(sp)
40f06244:	02812a03          	lw	s4,40(sp)
40f06248:	04010113          	addi	sp,sp,64
40f0624c:	00008067          	ret
		tlb_info.start = (unsigned long)args[2];
40f06250:	00892883          	lw	a7,8(s2)
		tlb_info.size  = (unsigned long)args[3];
40f06254:	00c92803          	lw	a6,12(s2)
		tlb_info.asid  = (unsigned long)args[4];
40f06258:	01092703          	lw	a4,16(s2)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f0625c:	00492603          	lw	a2,4(s2)
40f06260:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f06264:	00100793          	li	a5,1
40f06268:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f0626c:	fcc40693          	addi	a3,s0,-52
40f06270:	000a0513          	mv	a0,s4
		tlb_info.type  = SBI_TLB_FLUSH_VVMA_ASID;
40f06274:	00500793          	li	a5,5
		tlb_info.shart_mask = 1UL << source_hart;
40f06278:	fd342e23          	sw	s3,-36(s0)
		tlb_info.start = (unsigned long)args[2];
40f0627c:	fd142623          	sw	a7,-52(s0)
		tlb_info.size  = (unsigned long)args[3];
40f06280:	fd042823          	sw	a6,-48(s0)
		tlb_info.asid  = (unsigned long)args[4];
40f06284:	fce42a23          	sw	a4,-44(s0)
		tlb_info.type  = SBI_TLB_FLUSH_VVMA_ASID;
40f06288:	fcf42c23          	sw	a5,-40(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f0628c:	ea0fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
}
40f06290:	03c12083          	lw	ra,60(sp)
40f06294:	03812403          	lw	s0,56(sp)
40f06298:	03412483          	lw	s1,52(sp)
40f0629c:	03012903          	lw	s2,48(sp)
40f062a0:	02c12983          	lw	s3,44(sp)
40f062a4:	02812a03          	lw	s4,40(sp)
40f062a8:	04010113          	addi	sp,sp,64
40f062ac:	00008067          	ret
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f062b0:	00492603          	lw	a2,4(s2)
40f062b4:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f062b8:	00100793          	li	a5,1
40f062bc:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f062c0:	fcc40693          	addi	a3,s0,-52
40f062c4:	000a0513          	mv	a0,s4
		tlb_info.type  = SBI_ITLB_FLUSH;
40f062c8:	00600793          	li	a5,6
		tlb_info.shart_mask = 1UL << source_hart;
40f062cc:	fd342e23          	sw	s3,-36(s0)
		tlb_info.start  = 0;
40f062d0:	fc042623          	sw	zero,-52(s0)
		tlb_info.size  = 0;
40f062d4:	fc042823          	sw	zero,-48(s0)
		tlb_info.type  = SBI_ITLB_FLUSH;
40f062d8:	fcf42c23          	sw	a5,-40(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f062dc:	e50fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
}
40f062e0:	03c12083          	lw	ra,60(sp)
40f062e4:	03812403          	lw	s0,56(sp)
40f062e8:	03412483          	lw	s1,52(sp)
40f062ec:	03012903          	lw	s2,48(sp)
40f062f0:	02c12983          	lw	s3,44(sp)
40f062f4:	02812a03          	lw	s4,40(sp)
40f062f8:	04010113          	addi	sp,sp,64
40f062fc:	00008067          	ret
		tlb_info.start = (unsigned long)args[2];
40f06300:	00892803          	lw	a6,8(s2)
		tlb_info.size  = (unsigned long)args[3];
40f06304:	00c92703          	lw	a4,12(s2)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06308:	00492603          	lw	a2,4(s2)
40f0630c:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f06310:	00100793          	li	a5,1
40f06314:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06318:	fcc40693          	addi	a3,s0,-52
40f0631c:	000a0513          	mv	a0,s4
		tlb_info.shart_mask = 1UL << source_hart;
40f06320:	fd342e23          	sw	s3,-36(s0)
		tlb_info.start = (unsigned long)args[2];
40f06324:	fd042623          	sw	a6,-52(s0)
		tlb_info.size  = (unsigned long)args[3];
40f06328:	fce42823          	sw	a4,-48(s0)
		tlb_info.type  = SBI_TLB_FLUSH_VMA;
40f0632c:	fc042c23          	sw	zero,-40(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06330:	dfcfc0ef          	jal	ra,40f0292c <sbi_tlb_request>
}
40f06334:	03c12083          	lw	ra,60(sp)
40f06338:	03812403          	lw	s0,56(sp)
40f0633c:	03412483          	lw	s1,52(sp)
40f06340:	03012903          	lw	s2,48(sp)
40f06344:	02c12983          	lw	s3,44(sp)
40f06348:	02812a03          	lw	s4,40(sp)
40f0634c:	04010113          	addi	sp,sp,64
40f06350:	00008067          	ret
		tlb_info.start = (unsigned long)args[2];
40f06354:	00892883          	lw	a7,8(s2)
		tlb_info.size  = (unsigned long)args[3];
40f06358:	00c92803          	lw	a6,12(s2)
		tlb_info.asid  = (unsigned long)args[4];
40f0635c:	01092703          	lw	a4,16(s2)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06360:	00492603          	lw	a2,4(s2)
40f06364:	00092583          	lw	a1,0(s2)
		tlb_info.type  = SBI_TLB_FLUSH_VMA_ASID;
40f06368:	00100793          	li	a5,1
		tlb_info.shart_mask = 1UL << source_hart;
40f0636c:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06370:	fcc40693          	addi	a3,s0,-52
40f06374:	000a0513          	mv	a0,s4
		tlb_info.shart_mask = 1UL << source_hart;
40f06378:	fd342e23          	sw	s3,-36(s0)
		tlb_info.start = (unsigned long)args[2];
40f0637c:	fd142623          	sw	a7,-52(s0)
		tlb_info.size  = (unsigned long)args[3];
40f06380:	fd042823          	sw	a6,-48(s0)
		tlb_info.asid  = (unsigned long)args[4];
40f06384:	fce42a23          	sw	a4,-44(s0)
		tlb_info.type  = SBI_TLB_FLUSH_VMA_ASID;
40f06388:	fcf42c23          	sw	a5,-40(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f0638c:	da0fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
}
40f06390:	03c12083          	lw	ra,60(sp)
40f06394:	03812403          	lw	s0,56(sp)
40f06398:	03412483          	lw	s1,52(sp)
40f0639c:	03012903          	lw	s2,48(sp)
40f063a0:	02c12983          	lw	s3,44(sp)
40f063a4:	02812a03          	lw	s4,40(sp)
40f063a8:	04010113          	addi	sp,sp,64
40f063ac:	00008067          	ret
		tlb_info.start = (unsigned long)args[2];
40f063b0:	00892803          	lw	a6,8(s2)
		tlb_info.size  = (unsigned long)args[3];
40f063b4:	00c92703          	lw	a4,12(s2)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f063b8:	00492603          	lw	a2,4(s2)
40f063bc:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f063c0:	00100793          	li	a5,1
40f063c4:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f063c8:	fcc40693          	addi	a3,s0,-52
40f063cc:	000a0513          	mv	a0,s4
		tlb_info.type  = SBI_TLB_FLUSH_GVMA;
40f063d0:	00200793          	li	a5,2
		tlb_info.shart_mask = 1UL << source_hart;
40f063d4:	fd342e23          	sw	s3,-36(s0)
		tlb_info.start = (unsigned long)args[2];
40f063d8:	fd042623          	sw	a6,-52(s0)
		tlb_info.size  = (unsigned long)args[3];
40f063dc:	fce42823          	sw	a4,-48(s0)
		tlb_info.type  = SBI_TLB_FLUSH_GVMA;
40f063e0:	fcf42c23          	sw	a5,-40(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f063e4:	d48fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
}
40f063e8:	03c12083          	lw	ra,60(sp)
40f063ec:	03812403          	lw	s0,56(sp)
40f063f0:	03412483          	lw	s1,52(sp)
40f063f4:	03012903          	lw	s2,48(sp)
40f063f8:	02c12983          	lw	s3,44(sp)
40f063fc:	02812a03          	lw	s4,40(sp)
40f06400:	04010113          	addi	sp,sp,64
40f06404:	00008067          	ret
		tlb_info.start = (unsigned long)args[2];
40f06408:	00892883          	lw	a7,8(s2)
		tlb_info.size  = (unsigned long)args[3];
40f0640c:	00c92803          	lw	a6,12(s2)
		tlb_info.asid  = (unsigned long)args[4];
40f06410:	01092703          	lw	a4,16(s2)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06414:	00492603          	lw	a2,4(s2)
40f06418:	00092583          	lw	a1,0(s2)
		tlb_info.shart_mask = 1UL << source_hart;
40f0641c:	00100793          	li	a5,1
40f06420:	013799b3          	sll	s3,a5,s3
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06424:	fcc40693          	addi	a3,s0,-52
40f06428:	000a0513          	mv	a0,s4
		tlb_info.type  = SBI_TLB_FLUSH_GVMA_VMID;
40f0642c:	00300793          	li	a5,3
		tlb_info.shart_mask = 1UL << source_hart;
40f06430:	fd342e23          	sw	s3,-36(s0)
		tlb_info.start = (unsigned long)args[2];
40f06434:	fd142623          	sw	a7,-52(s0)
		tlb_info.size  = (unsigned long)args[3];
40f06438:	fd042823          	sw	a6,-48(s0)
		tlb_info.asid  = (unsigned long)args[4];
40f0643c:	fce42a23          	sw	a4,-44(s0)
		tlb_info.type  = SBI_TLB_FLUSH_GVMA_VMID;
40f06440:	fcf42c23          	sw	a5,-40(s0)
		ret = sbi_tlb_request(scratch, args[0], args[1], &tlb_info);
40f06444:	ce8fc0ef          	jal	ra,40f0292c <sbi_tlb_request>
}
40f06448:	03c12083          	lw	ra,60(sp)
40f0644c:	03812403          	lw	s0,56(sp)
40f06450:	03412483          	lw	s1,52(sp)
40f06454:	03012903          	lw	s2,48(sp)
40f06458:	02c12983          	lw	s3,44(sp)
40f0645c:	02812a03          	lw	s4,40(sp)
40f06460:	04010113          	addi	sp,sp,64
40f06464:	00008067          	ret

40f06468 <sbi_ecall_ipi_handler>:
				 unsigned long *args, unsigned long *out_val,
				 struct sbi_trap_info *out_trap)
{
	int ret = 0;

	if (funcid == SBI_EXT_IPI_SEND_IPI)
40f06468:	02061863          	bnez	a2,40f06498 <sbi_ecall_ipi_handler+0x30>
{
40f0646c:	ff010113          	addi	sp,sp,-16
40f06470:	00812423          	sw	s0,8(sp)
40f06474:	00112623          	sw	ra,12(sp)
40f06478:	01010413          	addi	s0,sp,16
		ret = sbi_ipi_send_smode(scratch, args[0], args[1]);
40f0647c:	0046a603          	lw	a2,4(a3)
40f06480:	0006a583          	lw	a1,0(a3)
40f06484:	f85fa0ef          	jal	ra,40f01408 <sbi_ipi_send_smode>
	else
		ret = SBI_ENOTSUPP;

	return ret;
}
40f06488:	00c12083          	lw	ra,12(sp)
40f0648c:	00812403          	lw	s0,8(sp)
40f06490:	01010113          	addi	sp,sp,16
40f06494:	00008067          	ret
		ret = SBI_ENOTSUPP;
40f06498:	ffe00513          	li	a0,-2
}
40f0649c:	00008067          	ret

40f064a0 <sbi_ecall_vendor_probe>:

static int sbi_ecall_vendor_probe(struct sbi_scratch *scratch,
				  unsigned long extid,
				  unsigned long *out_val)
{
	*out_val = sbi_platform_vendor_ext_check(sbi_platform_ptr(scratch),
40f064a0:	01954683          	lbu	a3,25(a0)
40f064a4:	01a54703          	lbu	a4,26(a0)
40f064a8:	01854803          	lbu	a6,24(a0)
40f064ac:	01b54783          	lbu	a5,27(a0)
40f064b0:	00869693          	slli	a3,a3,0x8
40f064b4:	0106e533          	or	a0,a3,a6
40f064b8:	01071713          	slli	a4,a4,0x10
40f064bc:	00a76733          	or	a4,a4,a0
40f064c0:	01879793          	slli	a5,a5,0x18
40f064c4:	00e7e533          	or	a0,a5,a4
 * @return 0 if extid is not implemented and 1 if implemented
 */
static inline int sbi_platform_vendor_ext_check(const struct sbi_platform *plat,
						long extid)
{
	if (plat && sbi_platform_ops(plat)->vendor_ext_check)
40f064c8:	08050a63          	beqz	a0,40f0655c <sbi_ecall_vendor_probe+0xbc>
40f064cc:	06154683          	lbu	a3,97(a0)
40f064d0:	06054803          	lbu	a6,96(a0)
40f064d4:	06254703          	lbu	a4,98(a0)
40f064d8:	06354783          	lbu	a5,99(a0)
40f064dc:	00869693          	slli	a3,a3,0x8
40f064e0:	0106e6b3          	or	a3,a3,a6
40f064e4:	01071713          	slli	a4,a4,0x10
40f064e8:	00d76733          	or	a4,a4,a3
40f064ec:	01879793          	slli	a5,a5,0x18
40f064f0:	00e7e7b3          	or	a5,a5,a4
40f064f4:	0657c803          	lbu	a6,101(a5)
40f064f8:	0647c883          	lbu	a7,100(a5)
40f064fc:	0667c683          	lbu	a3,102(a5)
40f06500:	0677c703          	lbu	a4,103(a5)
40f06504:	00881793          	slli	a5,a6,0x8
40f06508:	0117e833          	or	a6,a5,a7
40f0650c:	01069793          	slli	a5,a3,0x10
40f06510:	0107e7b3          	or	a5,a5,a6
40f06514:	01871713          	slli	a4,a4,0x18
40f06518:	00f76733          	or	a4,a4,a5
40f0651c:	00000513          	li	a0,0
40f06520:	02070e63          	beqz	a4,40f0655c <sbi_ecall_vendor_probe+0xbc>
{
40f06524:	fe010113          	addi	sp,sp,-32
40f06528:	00812c23          	sw	s0,24(sp)
40f0652c:	00112e23          	sw	ra,28(sp)
40f06530:	02010413          	addi	s0,sp,32
		return sbi_platform_ops(plat)->vendor_ext_check(extid);
40f06534:	00058513          	mv	a0,a1
40f06538:	fec42623          	sw	a2,-20(s0)
40f0653c:	000700e7          	jalr	a4
40f06540:	fec42603          	lw	a2,-20(s0)
	*out_val = sbi_platform_vendor_ext_check(sbi_platform_ptr(scratch),
40f06544:	00a62023          	sw	a0,0(a2)
						 extid);
	return 0;
}
40f06548:	01c12083          	lw	ra,28(sp)
40f0654c:	01812403          	lw	s0,24(sp)
40f06550:	00000513          	li	a0,0
40f06554:	02010113          	addi	sp,sp,32
40f06558:	00008067          	ret
	*out_val = sbi_platform_vendor_ext_check(sbi_platform_ptr(scratch),
40f0655c:	00a62023          	sw	a0,0(a2)
}
40f06560:	00000513          	li	a0,0
40f06564:	00008067          	ret

40f06568 <sbi_ecall_vendor_handler>:
static int sbi_ecall_vendor_handler(struct sbi_scratch *scratch,
				    unsigned long extid, unsigned long funcid,
				    unsigned long *args, unsigned long *out_val,
				    struct sbi_trap_info *out_trap)
{
	return sbi_platform_vendor_ext_provider(sbi_platform_ptr(scratch),
40f06568:	01954303          	lbu	t1,25(a0)
40f0656c:	01854e03          	lbu	t3,24(a0)
40f06570:	01a54883          	lbu	a7,26(a0)
40f06574:	01b54803          	lbu	a6,27(a0)
40f06578:	00831313          	slli	t1,t1,0x8
40f0657c:	01c36333          	or	t1,t1,t3
40f06580:	01089893          	slli	a7,a7,0x10
40f06584:	0068e8b3          	or	a7,a7,t1
40f06588:	01881813          	slli	a6,a6,0x18
40f0658c:	01186833          	or	a6,a6,a7
					long extid, long funcid,
					unsigned long *args,
					unsigned long *out_value,
					struct sbi_trap_info *out_trap)
{
	if (plat && sbi_platform_ops(plat)->vendor_ext_provider) {
40f06590:	08080863          	beqz	a6,40f06620 <sbi_ecall_vendor_handler+0xb8>
40f06594:	06184303          	lbu	t1,97(a6)
40f06598:	06284883          	lbu	a7,98(a6)
40f0659c:	00058513          	mv	a0,a1
40f065a0:	00060593          	mv	a1,a2
40f065a4:	00068613          	mv	a2,a3
40f065a8:	00070693          	mv	a3,a4
40f065ac:	06084703          	lbu	a4,96(a6)
40f065b0:	06384803          	lbu	a6,99(a6)
40f065b4:	00831313          	slli	t1,t1,0x8
40f065b8:	00e36333          	or	t1,t1,a4
40f065bc:	01089893          	slli	a7,a7,0x10
40f065c0:	0068e8b3          	or	a7,a7,t1
40f065c4:	01881813          	slli	a6,a6,0x18
40f065c8:	01186833          	or	a6,a6,a7
40f065cc:	06984303          	lbu	t1,105(a6)
40f065d0:	06884703          	lbu	a4,104(a6)
40f065d4:	06a84883          	lbu	a7,106(a6)
40f065d8:	06b84803          	lbu	a6,107(a6)
40f065dc:	00831313          	slli	t1,t1,0x8
40f065e0:	00e36333          	or	t1,t1,a4
40f065e4:	01089893          	slli	a7,a7,0x10
40f065e8:	0068e8b3          	or	a7,a7,t1
40f065ec:	01881813          	slli	a6,a6,0x18
40f065f0:	01186833          	or	a6,a6,a7
40f065f4:	02080663          	beqz	a6,40f06620 <sbi_ecall_vendor_handler+0xb8>
{
40f065f8:	ff010113          	addi	sp,sp,-16
40f065fc:	00812423          	sw	s0,8(sp)
40f06600:	00112623          	sw	ra,12(sp)
40f06604:	01010413          	addi	s0,sp,16
40f06608:	00078713          	mv	a4,a5
		return sbi_platform_ops(plat)->vendor_ext_provider(extid,
40f0660c:	000800e7          	jalr	a6
						extid, funcid, args,
						out_val, out_trap);
}
40f06610:	00c12083          	lw	ra,12(sp)
40f06614:	00812403          	lw	s0,8(sp)
40f06618:	01010113          	addi	sp,sp,16
40f0661c:	00008067          	ret
								funcid, args,
								out_value,
								out_trap);
	}

	return SBI_ENOTSUPP;
40f06620:	ffe00513          	li	a0,-2
40f06624:	00008067          	ret

40f06628 <sbi_fifo_init>:
#include <sbi/sbi_fifo.h>
#include <sbi/sbi_string.h>

void sbi_fifo_init(struct sbi_fifo *fifo, void *queue_mem, u16 entries,
		   u16 entry_size)
{
40f06628:	00060713          	mv	a4,a2
	fifo->queue	  = queue_mem;
	fifo->num_entries = entries;
	fifo->entry_size  = entry_size;
	SPIN_LOCK_INIT(&fifo->qlock);
	fifo->avail = fifo->tail = 0;
	sbi_memset(fifo->queue, 0, (size_t)entries * entry_size);
40f0662c:	02d60633          	mul	a2,a2,a3
{
40f06630:	ff010113          	addi	sp,sp,-16
40f06634:	00812423          	sw	s0,8(sp)
40f06638:	00112623          	sw	ra,12(sp)
40f0663c:	01010413          	addi	s0,sp,16
40f06640:	00050793          	mv	a5,a0
	fifo->queue	  = queue_mem;
40f06644:	00b7a023          	sw	a1,0(a5)
{
40f06648:	00058513          	mv	a0,a1
	fifo->num_entries = entries;
40f0664c:	00e79523          	sh	a4,10(a5)
	fifo->entry_size  = entry_size;
40f06650:	00d79423          	sh	a3,8(a5)
	SPIN_LOCK_INIT(&fifo->qlock);
40f06654:	0007a223          	sw	zero,4(a5)
	fifo->avail = fifo->tail = 0;
40f06658:	0007a623          	sw	zero,12(a5)
	sbi_memset(fifo->queue, 0, (size_t)entries * entry_size);
40f0665c:	00000593          	li	a1,0
40f06660:	e50fd0ef          	jal	ra,40f03cb0 <sbi_memset>
}
40f06664:	00c12083          	lw	ra,12(sp)
40f06668:	00812403          	lw	s0,8(sp)
40f0666c:	01010113          	addi	sp,sp,16
40f06670:	00008067          	ret

40f06674 <sbi_fifo_avail>:
{
	return (fifo->avail == fifo->num_entries) ? TRUE : FALSE;
}

u16 sbi_fifo_avail(struct sbi_fifo *fifo)
{
40f06674:	ff010113          	addi	sp,sp,-16
40f06678:	00812423          	sw	s0,8(sp)
40f0667c:	00912223          	sw	s1,4(sp)
40f06680:	00112623          	sw	ra,12(sp)
40f06684:	01212023          	sw	s2,0(sp)
40f06688:	01010413          	addi	s0,sp,16
	u16 ret;

	if (!fifo)
		return 0;
40f0668c:	00000493          	li	s1,0
	if (!fifo)
40f06690:	02050063          	beqz	a0,40f066b0 <sbi_fifo_avail+0x3c>

	spin_lock(&fifo->qlock);
40f06694:	00450913          	addi	s2,a0,4
40f06698:	00050493          	mv	s1,a0
40f0669c:	00090513          	mv	a0,s2
40f066a0:	9dcfe0ef          	jal	ra,40f0487c <spin_lock>
	ret = fifo->avail;
	spin_unlock(&fifo->qlock);
40f066a4:	00090513          	mv	a0,s2
	ret = fifo->avail;
40f066a8:	00c4d483          	lhu	s1,12(s1)
	spin_unlock(&fifo->qlock);
40f066ac:	a00fe0ef          	jal	ra,40f048ac <spin_unlock>

	return ret;
}
40f066b0:	00c12083          	lw	ra,12(sp)
40f066b4:	00812403          	lw	s0,8(sp)
40f066b8:	00048513          	mv	a0,s1
40f066bc:	00012903          	lw	s2,0(sp)
40f066c0:	00412483          	lw	s1,4(sp)
40f066c4:	01010113          	addi	sp,sp,16
40f066c8:	00008067          	ret

40f066cc <sbi_fifo_is_full>:

bool sbi_fifo_is_full(struct sbi_fifo *fifo)
{
40f066cc:	fe010113          	addi	sp,sp,-32
40f066d0:	00112e23          	sw	ra,28(sp)
40f066d4:	00812c23          	sw	s0,24(sp)
40f066d8:	00912a23          	sw	s1,20(sp)
40f066dc:	01212823          	sw	s2,16(sp)
40f066e0:	01312623          	sw	s3,12(sp)
40f066e4:	02010413          	addi	s0,sp,32
	bool ret;

	spin_lock(&fifo->qlock);
40f066e8:	00450993          	addi	s3,a0,4
{
40f066ec:	00050913          	mv	s2,a0
	spin_lock(&fifo->qlock);
40f066f0:	00098513          	mv	a0,s3
40f066f4:	988fe0ef          	jal	ra,40f0487c <spin_lock>
	return (fifo->avail == fifo->num_entries) ? TRUE : FALSE;
40f066f8:	00a95783          	lhu	a5,10(s2)
40f066fc:	00c95483          	lhu	s1,12(s2)
	ret = __sbi_fifo_is_full(fifo);
	spin_unlock(&fifo->qlock);
40f06700:	00098513          	mv	a0,s3
	return (fifo->avail == fifo->num_entries) ? TRUE : FALSE;
40f06704:	40f484b3          	sub	s1,s1,a5
	spin_unlock(&fifo->qlock);
40f06708:	9a4fe0ef          	jal	ra,40f048ac <spin_unlock>

	return ret;
}
40f0670c:	01c12083          	lw	ra,28(sp)
40f06710:	01812403          	lw	s0,24(sp)
	return (fifo->avail == fifo->num_entries) ? TRUE : FALSE;
40f06714:	0014b493          	seqz	s1,s1
}
40f06718:	00048513          	mv	a0,s1
40f0671c:	01012903          	lw	s2,16(sp)
40f06720:	01412483          	lw	s1,20(sp)
40f06724:	00c12983          	lw	s3,12(sp)
40f06728:	02010113          	addi	sp,sp,32
40f0672c:	00008067          	ret

40f06730 <sbi_fifo_is_empty>:
{
	return (fifo->avail == 0) ? TRUE : FALSE;
}

bool sbi_fifo_is_empty(struct sbi_fifo *fifo)
{
40f06730:	ff010113          	addi	sp,sp,-16
40f06734:	00112623          	sw	ra,12(sp)
40f06738:	00812423          	sw	s0,8(sp)
40f0673c:	00912223          	sw	s1,4(sp)
40f06740:	01212023          	sw	s2,0(sp)
40f06744:	01010413          	addi	s0,sp,16
	bool ret;

	spin_lock(&fifo->qlock);
40f06748:	00450913          	addi	s2,a0,4
{
40f0674c:	00050493          	mv	s1,a0
	spin_lock(&fifo->qlock);
40f06750:	00090513          	mv	a0,s2
40f06754:	928fe0ef          	jal	ra,40f0487c <spin_lock>
	ret = __sbi_fifo_is_empty(fifo);
	spin_unlock(&fifo->qlock);
40f06758:	00090513          	mv	a0,s2
	return (fifo->avail == 0) ? TRUE : FALSE;
40f0675c:	00c4d483          	lhu	s1,12(s1)
	spin_unlock(&fifo->qlock);
40f06760:	94cfe0ef          	jal	ra,40f048ac <spin_unlock>

	return ret;
}
40f06764:	00c12083          	lw	ra,12(sp)
40f06768:	00812403          	lw	s0,8(sp)
	return (fifo->avail == 0) ? TRUE : FALSE;
40f0676c:	0014b493          	seqz	s1,s1
}
40f06770:	00048513          	mv	a0,s1
40f06774:	00012903          	lw	s2,0(sp)
40f06778:	00412483          	lw	s1,4(sp)
40f0677c:	01010113          	addi	sp,sp,16
40f06780:	00008067          	ret

40f06784 <sbi_fifo_reset>:
	sbi_memset(fifo->queue, 0, size);
}

bool sbi_fifo_reset(struct sbi_fifo *fifo)
{
	if (!fifo)
40f06784:	06050663          	beqz	a0,40f067f0 <sbi_fifo_reset+0x6c>
{
40f06788:	ff010113          	addi	sp,sp,-16
40f0678c:	00112623          	sw	ra,12(sp)
40f06790:	00812423          	sw	s0,8(sp)
40f06794:	00912223          	sw	s1,4(sp)
40f06798:	01010413          	addi	s0,sp,16
40f0679c:	01212023          	sw	s2,0(sp)
		return FALSE;

	spin_lock(&fifo->qlock);
40f067a0:	00450913          	addi	s2,a0,4
{
40f067a4:	00050493          	mv	s1,a0
	spin_lock(&fifo->qlock);
40f067a8:	00090513          	mv	a0,s2
40f067ac:	8d0fe0ef          	jal	ra,40f0487c <spin_lock>
	size_t size = (size_t)fifo->num_entries * fifo->entry_size;
40f067b0:	0084d783          	lhu	a5,8(s1)
40f067b4:	00a4d603          	lhu	a2,10(s1)
	sbi_memset(fifo->queue, 0, size);
40f067b8:	0004a503          	lw	a0,0(s1)
40f067bc:	00000593          	li	a1,0
40f067c0:	02f60633          	mul	a2,a2,a5
	fifo->avail = 0;
40f067c4:	0004a623          	sw	zero,12(s1)
	sbi_memset(fifo->queue, 0, size);
40f067c8:	ce8fd0ef          	jal	ra,40f03cb0 <sbi_memset>
	__sbi_fifo_reset(fifo);
	spin_unlock(&fifo->qlock);
40f067cc:	00090513          	mv	a0,s2
40f067d0:	8dcfe0ef          	jal	ra,40f048ac <spin_unlock>

	return TRUE;
}
40f067d4:	00c12083          	lw	ra,12(sp)
40f067d8:	00812403          	lw	s0,8(sp)
40f067dc:	00412483          	lw	s1,4(sp)
40f067e0:	00012903          	lw	s2,0(sp)
	return TRUE;
40f067e4:	00100513          	li	a0,1
}
40f067e8:	01010113          	addi	sp,sp,16
40f067ec:	00008067          	ret
		return FALSE;
40f067f0:	00000513          	li	a0,0
}
40f067f4:	00008067          	ret

40f067f8 <sbi_fifo_inplace_update>:
 * **Do not** invoke any other fifo function from callback. Otherwise, it will
 * lead to deadlock.
 */
int sbi_fifo_inplace_update(struct sbi_fifo *fifo, void *in,
			    int (*fptr)(void *in, void *data))
{
40f067f8:	fd010113          	addi	sp,sp,-48
40f067fc:	02812423          	sw	s0,40(sp)
40f06800:	02112623          	sw	ra,44(sp)
40f06804:	02912223          	sw	s1,36(sp)
40f06808:	03212023          	sw	s2,32(sp)
40f0680c:	01312e23          	sw	s3,28(sp)
40f06810:	01412c23          	sw	s4,24(sp)
40f06814:	01512a23          	sw	s5,20(sp)
40f06818:	01612823          	sw	s6,16(sp)
40f0681c:	01712623          	sw	s7,12(sp)
40f06820:	03010413          	addi	s0,sp,48
	int i, index = 0;
	int ret = SBI_FIFO_UNCHANGED;
	void *entry;

	if (!fifo || !in)
40f06824:	0a050663          	beqz	a0,40f068d0 <sbi_fifo_inplace_update+0xd8>
40f06828:	0a058463          	beqz	a1,40f068d0 <sbi_fifo_inplace_update+0xd8>
		return ret;

	spin_lock(&fifo->qlock);
40f0682c:	00450b13          	addi	s6,a0,4
40f06830:	00050493          	mv	s1,a0
40f06834:	000b0513          	mv	a0,s6
40f06838:	00060a13          	mv	s4,a2
40f0683c:	00058993          	mv	s3,a1
40f06840:	83cfe0ef          	jal	ra,40f0487c <spin_lock>

	if (__sbi_fifo_is_empty(fifo)) {
40f06844:	00c4d783          	lhu	a5,12(s1)
		spin_unlock(&fifo->qlock);
		return ret;
	}

	for (i = 0; i < fifo->avail; i++) {
40f06848:	00000913          	li	s2,0
		if (index >= fifo->num_entries)
			index = index - fifo->num_entries;
		entry = (void *)fifo->queue + (u32)index * fifo->entry_size;
		ret = fptr(in, entry);

		if (ret == SBI_FIFO_SKIP || ret == SBI_FIFO_UPDATED) {
40f0684c:	00100a93          	li	s5,1
	if (__sbi_fifo_is_empty(fifo)) {
40f06850:	00079863          	bnez	a5,40f06860 <sbi_fifo_inplace_update+0x68>
40f06854:	0840006f          	j	40f068d8 <sbi_fifo_inplace_update+0xe0>
	for (i = 0; i < fifo->avail; i++) {
40f06858:	00c4d783          	lhu	a5,12(s1)
40f0685c:	02f95e63          	bge	s2,a5,40f06898 <sbi_fifo_inplace_update+0xa0>
		index = fifo->tail + i;
40f06860:	00e4d783          	lhu	a5,14(s1)
		if (index >= fifo->num_entries)
40f06864:	00a4d703          	lhu	a4,10(s1)
		ret = fptr(in, entry);
40f06868:	00098513          	mv	a0,s3
		index = fifo->tail + i;
40f0686c:	012787b3          	add	a5,a5,s2
	for (i = 0; i < fifo->avail; i++) {
40f06870:	00190913          	addi	s2,s2,1
		if (index >= fifo->num_entries)
40f06874:	00e7c463          	blt	a5,a4,40f0687c <sbi_fifo_inplace_update+0x84>
			index = index - fifo->num_entries;
40f06878:	40e787b3          	sub	a5,a5,a4
		entry = (void *)fifo->queue + (u32)index * fifo->entry_size;
40f0687c:	0084d703          	lhu	a4,8(s1)
40f06880:	0004a583          	lw	a1,0(s1)
40f06884:	02f707b3          	mul	a5,a4,a5
		ret = fptr(in, entry);
40f06888:	00f585b3          	add	a1,a1,a5
40f0688c:	000a00e7          	jalr	s4
40f06890:	00050b93          	mv	s7,a0
		if (ret == SBI_FIFO_SKIP || ret == SBI_FIFO_UPDATED) {
40f06894:	fcaae2e3          	bltu	s5,a0,40f06858 <sbi_fifo_inplace_update+0x60>
			break;
		}
	}
	spin_unlock(&fifo->qlock);
40f06898:	000b0513          	mv	a0,s6
40f0689c:	810fe0ef          	jal	ra,40f048ac <spin_unlock>

	return ret;
}
40f068a0:	02c12083          	lw	ra,44(sp)
40f068a4:	02812403          	lw	s0,40(sp)
40f068a8:	000b8513          	mv	a0,s7
40f068ac:	02412483          	lw	s1,36(sp)
40f068b0:	02012903          	lw	s2,32(sp)
40f068b4:	01c12983          	lw	s3,28(sp)
40f068b8:	01812a03          	lw	s4,24(sp)
40f068bc:	01412a83          	lw	s5,20(sp)
40f068c0:	01012b03          	lw	s6,16(sp)
40f068c4:	00c12b83          	lw	s7,12(sp)
40f068c8:	03010113          	addi	sp,sp,48
40f068cc:	00008067          	ret
		return ret;
40f068d0:	00200b93          	li	s7,2
40f068d4:	fcdff06f          	j	40f068a0 <sbi_fifo_inplace_update+0xa8>
		spin_unlock(&fifo->qlock);
40f068d8:	000b0513          	mv	a0,s6
40f068dc:	fd1fd0ef          	jal	ra,40f048ac <spin_unlock>
		return ret;
40f068e0:	00200b93          	li	s7,2
40f068e4:	fbdff06f          	j	40f068a0 <sbi_fifo_inplace_update+0xa8>

40f068e8 <sbi_fifo_enqueue>:

int sbi_fifo_enqueue(struct sbi_fifo *fifo, void *data)
{
	if (!fifo || !data)
40f068e8:	0a050263          	beqz	a0,40f0698c <sbi_fifo_enqueue+0xa4>
40f068ec:	0a058063          	beqz	a1,40f0698c <sbi_fifo_enqueue+0xa4>
{
40f068f0:	fe010113          	addi	sp,sp,-32
40f068f4:	00812c23          	sw	s0,24(sp)
40f068f8:	00912a23          	sw	s1,20(sp)
40f068fc:	01212823          	sw	s2,16(sp)
40f06900:	01312623          	sw	s3,12(sp)
40f06904:	00112e23          	sw	ra,28(sp)
40f06908:	02010413          	addi	s0,sp,32
		return SBI_EINVAL;

	spin_lock(&fifo->qlock);
40f0690c:	00450993          	addi	s3,a0,4
40f06910:	00050493          	mv	s1,a0
40f06914:	00098513          	mv	a0,s3
40f06918:	00058913          	mv	s2,a1
40f0691c:	f61fd0ef          	jal	ra,40f0487c <spin_lock>
	return (fifo->avail == fifo->num_entries) ? TRUE : FALSE;
40f06920:	00c4d503          	lhu	a0,12(s1)
40f06924:	00a4d703          	lhu	a4,10(s1)

	if (__sbi_fifo_is_full(fifo)) {
40f06928:	06e50663          	beq	a0,a4,40f06994 <sbi_fifo_enqueue+0xac>
	head = (u32)fifo->tail + fifo->avail;
40f0692c:	00e4d783          	lhu	a5,14(s1)
40f06930:	00a787b3          	add	a5,a5,a0
	if (head >= fifo->num_entries)
40f06934:	04e7f863          	bgeu	a5,a4,40f06984 <sbi_fifo_enqueue+0x9c>
	sbi_memcpy(fifo->queue + head * fifo->entry_size, data, fifo->entry_size);
40f06938:	0084d603          	lhu	a2,8(s1)
40f0693c:	0004a503          	lw	a0,0(s1)
40f06940:	00090593          	mv	a1,s2
40f06944:	02f607b3          	mul	a5,a2,a5
40f06948:	00f50533          	add	a0,a0,a5
40f0694c:	b98fd0ef          	jal	ra,40f03ce4 <sbi_memcpy>
	fifo->avail++;
40f06950:	00c4d783          	lhu	a5,12(s1)
		spin_unlock(&fifo->qlock);
		return SBI_ENOSPC;
	}
	__sbi_fifo_enqueue(fifo, data);

	spin_unlock(&fifo->qlock);
40f06954:	00098513          	mv	a0,s3
	fifo->avail++;
40f06958:	00178793          	addi	a5,a5,1
40f0695c:	00f49623          	sh	a5,12(s1)
	spin_unlock(&fifo->qlock);
40f06960:	f4dfd0ef          	jal	ra,40f048ac <spin_unlock>

	return 0;
40f06964:	00000513          	li	a0,0
}
40f06968:	01c12083          	lw	ra,28(sp)
40f0696c:	01812403          	lw	s0,24(sp)
40f06970:	01412483          	lw	s1,20(sp)
40f06974:	01012903          	lw	s2,16(sp)
40f06978:	00c12983          	lw	s3,12(sp)
40f0697c:	02010113          	addi	sp,sp,32
40f06980:	00008067          	ret
		head = head - fifo->num_entries;
40f06984:	40e787b3          	sub	a5,a5,a4
40f06988:	fb1ff06f          	j	40f06938 <sbi_fifo_enqueue+0x50>
		return SBI_EINVAL;
40f0698c:	ffd00513          	li	a0,-3
}
40f06990:	00008067          	ret
		spin_unlock(&fifo->qlock);
40f06994:	00098513          	mv	a0,s3
40f06998:	f15fd0ef          	jal	ra,40f048ac <spin_unlock>
		return SBI_ENOSPC;
40f0699c:	ff500513          	li	a0,-11
40f069a0:	fc9ff06f          	j	40f06968 <sbi_fifo_enqueue+0x80>

40f069a4 <sbi_fifo_dequeue>:

int sbi_fifo_dequeue(struct sbi_fifo *fifo, void *data)
{
	if (!fifo || !data)
40f069a4:	0a050c63          	beqz	a0,40f06a5c <sbi_fifo_dequeue+0xb8>
40f069a8:	0a058a63          	beqz	a1,40f06a5c <sbi_fifo_dequeue+0xb8>
{
40f069ac:	fe010113          	addi	sp,sp,-32
40f069b0:	00812c23          	sw	s0,24(sp)
40f069b4:	00912a23          	sw	s1,20(sp)
40f069b8:	01212823          	sw	s2,16(sp)
40f069bc:	01312623          	sw	s3,12(sp)
40f069c0:	00112e23          	sw	ra,28(sp)
40f069c4:	02010413          	addi	s0,sp,32
		return SBI_EINVAL;

	spin_lock(&fifo->qlock);
40f069c8:	00450993          	addi	s3,a0,4
40f069cc:	00050493          	mv	s1,a0
40f069d0:	00098513          	mv	a0,s3
40f069d4:	00058913          	mv	s2,a1
40f069d8:	ea5fd0ef          	jal	ra,40f0487c <spin_lock>

	if (__sbi_fifo_is_empty(fifo)) {
40f069dc:	00c4d783          	lhu	a5,12(s1)
40f069e0:	08078263          	beqz	a5,40f06a64 <sbi_fifo_dequeue+0xc0>
		spin_unlock(&fifo->qlock);
		return SBI_ENOENT;
	}

	sbi_memcpy(data, fifo->queue + (u32)fifo->tail * fifo->entry_size,
40f069e4:	0084d703          	lhu	a4,8(s1)
40f069e8:	00e4d783          	lhu	a5,14(s1)
40f069ec:	0004a583          	lw	a1,0(s1)
40f069f0:	00070613          	mv	a2,a4
40f069f4:	02e787b3          	mul	a5,a5,a4
40f069f8:	00090513          	mv	a0,s2
40f069fc:	00f585b3          	add	a1,a1,a5
40f06a00:	ae4fd0ef          	jal	ra,40f03ce4 <sbi_memcpy>
	       fifo->entry_size);

	fifo->avail--;
	fifo->tail++;
40f06a04:	00e4d783          	lhu	a5,14(s1)
	fifo->avail--;
40f06a08:	00c4d703          	lhu	a4,12(s1)
	if (fifo->tail >= fifo->num_entries)
40f06a0c:	00a4d683          	lhu	a3,10(s1)
	fifo->tail++;
40f06a10:	00178793          	addi	a5,a5,1
40f06a14:	01079793          	slli	a5,a5,0x10
	fifo->avail--;
40f06a18:	fff70713          	addi	a4,a4,-1
	fifo->tail++;
40f06a1c:	0107d793          	srli	a5,a5,0x10
	fifo->avail--;
40f06a20:	00e49623          	sh	a4,12(s1)
	fifo->tail++;
40f06a24:	00f49723          	sh	a5,14(s1)
	if (fifo->tail >= fifo->num_entries)
40f06a28:	02d7f663          	bgeu	a5,a3,40f06a54 <sbi_fifo_dequeue+0xb0>
		fifo->tail = 0;

	spin_unlock(&fifo->qlock);
40f06a2c:	00098513          	mv	a0,s3
40f06a30:	e7dfd0ef          	jal	ra,40f048ac <spin_unlock>

	return 0;
40f06a34:	00000513          	li	a0,0
}
40f06a38:	01c12083          	lw	ra,28(sp)
40f06a3c:	01812403          	lw	s0,24(sp)
40f06a40:	01412483          	lw	s1,20(sp)
40f06a44:	01012903          	lw	s2,16(sp)
40f06a48:	00c12983          	lw	s3,12(sp)
40f06a4c:	02010113          	addi	sp,sp,32
40f06a50:	00008067          	ret
		fifo->tail = 0;
40f06a54:	00049723          	sh	zero,14(s1)
40f06a58:	fd5ff06f          	j	40f06a2c <sbi_fifo_dequeue+0x88>
		return SBI_EINVAL;
40f06a5c:	ffd00513          	li	a0,-3
}
40f06a60:	00008067          	ret
		spin_unlock(&fifo->qlock);
40f06a64:	00098513          	mv	a0,s3
40f06a68:	e45fd0ef          	jal	ra,40f048ac <spin_unlock>
		return SBI_ENOENT;
40f06a6c:	ff100513          	li	a0,-15
40f06a70:	fc9ff06f          	j	40f06a38 <sbi_fifo_dequeue+0x94>
40f06a74:	0000                	unimp
	...

40f06a78 <__sbi_hfence_gvma_vmid_gpa>:
40f06a78:	62a60073          	0x62a60073
	.align 3
	.global __sbi_hfence_gvma_vmid_gpa
__sbi_hfence_gvma_vmid_gpa:
	/* hfence.gvma a1, a0 */
	.word 0x62a60073
	ret
40f06a7c:	00008067          	ret

40f06a80 <__sbi_hfence_gvma_vmid>:
40f06a80:	62a00073          	0x62a00073
	.align 3
	.global __sbi_hfence_gvma_vmid
__sbi_hfence_gvma_vmid:
	/* hfence.gvma zero, a0 */
	.word 0x62a00073
	ret
40f06a84:	00008067          	ret

40f06a88 <__sbi_hfence_gvma_gpa>:
40f06a88:	62050073          	0x62050073
	.align 3
	.global __sbi_hfence_gvma_gpa
__sbi_hfence_gvma_gpa:
	/* hfence.gvma a0 */
	.word 0x62050073
	ret
40f06a8c:	00008067          	ret

40f06a90 <__sbi_hfence_gvma_all>:
40f06a90:	62000073          	0x62000073
	.align 3
	.global __sbi_hfence_gvma_all
__sbi_hfence_gvma_all:
	/* hfence.gvma */
	.word 0x62000073
	ret
40f06a94:	00008067          	ret

40f06a98 <__sbi_hfence_vvma_asid_va>:
40f06a98:	22a60073          	0x22a60073
	.align 3
	.global __sbi_hfence_vvma_asid_va
__sbi_hfence_vvma_asid_va:
	/* hfence.bvma a1, a0 */
	.word 0x22a60073
	ret
40f06a9c:	00008067          	ret

40f06aa0 <__sbi_hfence_vvma_asid>:
40f06aa0:	22a00073          	0x22a00073
	.align 3
	.global __sbi_hfence_vvma_asid
__sbi_hfence_vvma_asid:
	/* hfence.bvma zero, a0 */
	.word 0x22a00073
	ret
40f06aa4:	00008067          	ret

40f06aa8 <__sbi_hfence_vvma_va>:
40f06aa8:	22050073          	0x22050073
	.align 3
	.global __sbi_hfence_vvma_va
__sbi_hfence_vvma_va:
	/* hfence.bvma a0 */
	.word 0x22050073
	ret
40f06aac:	00008067          	ret

40f06ab0 <__sbi_hfence_vvma_all>:
40f06ab0:	22000073          	0x22000073
	.align 3
	.global __sbi_hfence_vvma_all
__sbi_hfence_vvma_all:
	/* hfence.bvma */
	.word 0x22000073
	ret
40f06ab4:	00008067          	ret

40f06ab8 <sbi_current_hartid>:

/**
 * Return HART ID of the caller.
 */
unsigned int sbi_current_hartid()
{
40f06ab8:	ff010113          	addi	sp,sp,-16
40f06abc:	00812623          	sw	s0,12(sp)
40f06ac0:	01010413          	addi	s0,sp,16
	return (u32)csr_read(CSR_MHARTID);
40f06ac4:	f1402573          	csrr	a0,mhartid
}
40f06ac8:	00c12403          	lw	s0,12(sp)
40f06acc:	01010113          	addi	sp,sp,16
40f06ad0:	00008067          	ret

40f06ad4 <sbi_hart_delegation_dump>:

	return 0;
}

void sbi_hart_delegation_dump(struct sbi_scratch *scratch)
{
40f06ad4:	ff010113          	addi	sp,sp,-16
40f06ad8:	00812423          	sw	s0,8(sp)
40f06adc:	00112623          	sw	ra,12(sp)
40f06ae0:	01010413          	addi	s0,sp,16
#if __riscv_xlen == 32
	sbi_printf("MIDELEG : 0x%08lx\n", csr_read(CSR_MIDELEG));
40f06ae4:	303025f3          	csrr	a1,mideleg
40f06ae8:	00004517          	auipc	a0,0x4
40f06aec:	ccc50513          	addi	a0,a0,-820 # 40f0a7b4 <platform_ops+0x1d0>
40f06af0:	b0dfe0ef          	jal	ra,40f055fc <sbi_printf>
	sbi_printf("MEDELEG : 0x%08lx\n", csr_read(CSR_MEDELEG));
40f06af4:	302025f3          	csrr	a1,medeleg
40f06af8:	00004517          	auipc	a0,0x4
40f06afc:	cd050513          	addi	a0,a0,-816 # 40f0a7c8 <platform_ops+0x1e4>
40f06b00:	afdfe0ef          	jal	ra,40f055fc <sbi_printf>
#else
	sbi_printf("MIDELEG : 0x%016lx\n", csr_read(CSR_MIDELEG));
	sbi_printf("MEDELEG : 0x%016lx\n", csr_read(CSR_MEDELEG));
#endif
}
40f06b04:	00c12083          	lw	ra,12(sp)
40f06b08:	00812403          	lw	s0,8(sp)
40f06b0c:	01010113          	addi	sp,sp,16
40f06b10:	00008067          	ret

40f06b14 <log2roundup>:

unsigned long log2roundup(unsigned long x)
{
40f06b14:	ff010113          	addi	sp,sp,-16
40f06b18:	00812623          	sw	s0,12(sp)
40f06b1c:	01010413          	addi	s0,sp,16
	unsigned long ret = 0;
40f06b20:	00000793          	li	a5,0

	while (ret < __riscv_xlen) {
		if (x <= (1UL << ret))
40f06b24:	00100693          	li	a3,1
	while (ret < __riscv_xlen) {
40f06b28:	02000613          	li	a2,32
40f06b2c:	00c0006f          	j	40f06b38 <log2roundup+0x24>
			break;
		ret++;
40f06b30:	00178793          	addi	a5,a5,1
	while (ret < __riscv_xlen) {
40f06b34:	00c78663          	beq	a5,a2,40f06b40 <log2roundup+0x2c>
		if (x <= (1UL << ret))
40f06b38:	00f69733          	sll	a4,a3,a5
40f06b3c:	fea76ae3          	bltu	a4,a0,40f06b30 <log2roundup+0x1c>
	}

	return ret;
}
40f06b40:	00c12403          	lw	s0,12(sp)
40f06b44:	00078513          	mv	a0,a5
40f06b48:	01010113          	addi	sp,sp,16
40f06b4c:	00008067          	ret

40f06b50 <sbi_hart_pmp_dump>:

void sbi_hart_pmp_dump(struct sbi_scratch *scratch)
{
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f06b50:	01954683          	lbu	a3,25(a0)
40f06b54:	01854603          	lbu	a2,24(a0)
40f06b58:	01a54703          	lbu	a4,26(a0)
40f06b5c:	01b54783          	lbu	a5,27(a0)
40f06b60:	00869693          	slli	a3,a3,0x8
40f06b64:	00c6e6b3          	or	a3,a3,a2
40f06b68:	01071713          	slli	a4,a4,0x10
40f06b6c:	00d76733          	or	a4,a4,a3
40f06b70:	01879793          	slli	a5,a5,0x18
40f06b74:	00e7e7b3          	or	a5,a5,a4
	unsigned long prot, addr, size, l2l;
	unsigned int i;

	if (!sbi_platform_has_pmp(plat))
40f06b78:	0487c783          	lbu	a5,72(a5)
40f06b7c:	0047f793          	andi	a5,a5,4
40f06b80:	16078663          	beqz	a5,40f06cec <sbi_hart_pmp_dump+0x19c>
{
40f06b84:	fc010113          	addi	sp,sp,-64
40f06b88:	02812c23          	sw	s0,56(sp)
40f06b8c:	02912a23          	sw	s1,52(sp)
40f06b90:	03212823          	sw	s2,48(sp)
40f06b94:	03312623          	sw	s3,44(sp)
40f06b98:	03412423          	sw	s4,40(sp)
40f06b9c:	03512223          	sw	s5,36(sp)
40f06ba0:	03612023          	sw	s6,32(sp)
40f06ba4:	01712e23          	sw	s7,28(sp)
40f06ba8:	01812c23          	sw	s8,24(sp)
40f06bac:	02112e23          	sw	ra,60(sp)
40f06bb0:	04010413          	addi	s0,sp,64
		return;

	for (i = 0; i < PMP_COUNT; i++) {
40f06bb4:	00000493          	li	s1,0
		pmp_get(i, &prot, &addr, &l2l);
		if (!(prot & PMP_A))
			continue;
		if (l2l < __riscv_xlen)
40f06bb8:	01f00a13          	li	s4,31
			size = (1UL << l2l);
		else
			size = 0;
#if __riscv_xlen == 32
		sbi_printf("PMP%d    : 0x%08lx-0x%08lx (A",
40f06bbc:	00004997          	auipc	s3,0x4
40f06bc0:	c2098993          	addi	s3,s3,-992 # 40f0a7dc <platform_ops+0x1f8>
			sbi_printf(",R");
		if (prot & PMP_W)
			sbi_printf(",W");
		if (prot & PMP_X)
			sbi_printf(",X");
		sbi_printf(")\n");
40f06bc4:	00004917          	auipc	s2,0x4
40f06bc8:	87890913          	addi	s2,s2,-1928 # 40f0a43c <__func__.1282+0xfc>
			sbi_printf(",X");
40f06bcc:	00004c17          	auipc	s8,0x4
40f06bd0:	c3cc0c13          	addi	s8,s8,-964 # 40f0a808 <platform_ops+0x224>
			sbi_printf(",W");
40f06bd4:	00004b97          	auipc	s7,0x4
40f06bd8:	c30b8b93          	addi	s7,s7,-976 # 40f0a804 <platform_ops+0x220>
			sbi_printf(",R");
40f06bdc:	00004b17          	auipc	s6,0x4
40f06be0:	c24b0b13          	addi	s6,s6,-988 # 40f0a800 <platform_ops+0x21c>
			sbi_printf(",L");
40f06be4:	00004a97          	auipc	s5,0x4
40f06be8:	c18a8a93          	addi	s5,s5,-1000 # 40f0a7fc <platform_ops+0x218>
40f06bec:	0300006f          	j	40f06c1c <sbi_hart_pmp_dump+0xcc>
		if (prot & PMP_R)
40f06bf0:	0017f713          	andi	a4,a5,1
40f06bf4:	08071a63          	bnez	a4,40f06c88 <sbi_hart_pmp_dump+0x138>
		if (prot & PMP_W)
40f06bf8:	0027f713          	andi	a4,a5,2
40f06bfc:	0a071063          	bnez	a4,40f06c9c <sbi_hart_pmp_dump+0x14c>
		if (prot & PMP_X)
40f06c00:	0047f793          	andi	a5,a5,4
40f06c04:	0a079663          	bnez	a5,40f06cb0 <sbi_hart_pmp_dump+0x160>
		sbi_printf(")\n");
40f06c08:	00090513          	mv	a0,s2
40f06c0c:	9f1fe0ef          	jal	ra,40f055fc <sbi_printf>
	for (i = 0; i < PMP_COUNT; i++) {
40f06c10:	00148493          	addi	s1,s1,1
40f06c14:	01000793          	li	a5,16
40f06c18:	0af48263          	beq	s1,a5,40f06cbc <sbi_hart_pmp_dump+0x16c>
		pmp_get(i, &prot, &addr, &l2l);
40f06c1c:	fcc40693          	addi	a3,s0,-52
40f06c20:	fc840613          	addi	a2,s0,-56
40f06c24:	fc440593          	addi	a1,s0,-60
40f06c28:	00048513          	mv	a0,s1
40f06c2c:	849fd0ef          	jal	ra,40f04474 <pmp_get>
		if (!(prot & PMP_A))
40f06c30:	fc442783          	lw	a5,-60(s0)
40f06c34:	0187f793          	andi	a5,a5,24
40f06c38:	fc078ce3          	beqz	a5,40f06c10 <sbi_hart_pmp_dump+0xc0>
		if (l2l < __riscv_xlen)
40f06c3c:	fcc42703          	lw	a4,-52(s0)
			size = 0;
40f06c40:	00000793          	li	a5,0
		if (l2l < __riscv_xlen)
40f06c44:	00ea6663          	bltu	s4,a4,40f06c50 <sbi_hart_pmp_dump+0x100>
			size = (1UL << l2l);
40f06c48:	00100793          	li	a5,1
40f06c4c:	00e797b3          	sll	a5,a5,a4
		sbi_printf("PMP%d    : 0x%08lx-0x%08lx (A",
40f06c50:	fc842603          	lw	a2,-56(s0)
40f06c54:	00048593          	mv	a1,s1
40f06c58:	00098513          	mv	a0,s3
40f06c5c:	fff60693          	addi	a3,a2,-1
40f06c60:	00f686b3          	add	a3,a3,a5
40f06c64:	999fe0ef          	jal	ra,40f055fc <sbi_printf>
		if (prot & PMP_L)
40f06c68:	fc442783          	lw	a5,-60(s0)
40f06c6c:	0807f713          	andi	a4,a5,128
40f06c70:	f80700e3          	beqz	a4,40f06bf0 <sbi_hart_pmp_dump+0xa0>
			sbi_printf(",L");
40f06c74:	000a8513          	mv	a0,s5
40f06c78:	985fe0ef          	jal	ra,40f055fc <sbi_printf>
40f06c7c:	fc442783          	lw	a5,-60(s0)
		if (prot & PMP_R)
40f06c80:	0017f713          	andi	a4,a5,1
40f06c84:	f6070ae3          	beqz	a4,40f06bf8 <sbi_hart_pmp_dump+0xa8>
			sbi_printf(",R");
40f06c88:	000b0513          	mv	a0,s6
40f06c8c:	971fe0ef          	jal	ra,40f055fc <sbi_printf>
40f06c90:	fc442783          	lw	a5,-60(s0)
		if (prot & PMP_W)
40f06c94:	0027f713          	andi	a4,a5,2
40f06c98:	f60704e3          	beqz	a4,40f06c00 <sbi_hart_pmp_dump+0xb0>
			sbi_printf(",W");
40f06c9c:	000b8513          	mv	a0,s7
40f06ca0:	95dfe0ef          	jal	ra,40f055fc <sbi_printf>
40f06ca4:	fc442783          	lw	a5,-60(s0)
		if (prot & PMP_X)
40f06ca8:	0047f793          	andi	a5,a5,4
40f06cac:	f4078ee3          	beqz	a5,40f06c08 <sbi_hart_pmp_dump+0xb8>
			sbi_printf(",X");
40f06cb0:	000c0513          	mv	a0,s8
40f06cb4:	949fe0ef          	jal	ra,40f055fc <sbi_printf>
40f06cb8:	f51ff06f          	j	40f06c08 <sbi_hart_pmp_dump+0xb8>
	}
}
40f06cbc:	03c12083          	lw	ra,60(sp)
40f06cc0:	03812403          	lw	s0,56(sp)
40f06cc4:	03412483          	lw	s1,52(sp)
40f06cc8:	03012903          	lw	s2,48(sp)
40f06ccc:	02c12983          	lw	s3,44(sp)
40f06cd0:	02812a03          	lw	s4,40(sp)
40f06cd4:	02412a83          	lw	s5,36(sp)
40f06cd8:	02012b03          	lw	s6,32(sp)
40f06cdc:	01c12b83          	lw	s7,28(sp)
40f06ce0:	01812c03          	lw	s8,24(sp)
40f06ce4:	04010113          	addi	sp,sp,64
40f06ce8:	00008067          	ret
40f06cec:	00008067          	ret

40f06cf0 <sbi_hart_init>:
}

static unsigned long trap_info_offset;

int sbi_hart_init(struct sbi_scratch *scratch, u32 hartid, bool cold_boot)
{
40f06cf0:	fd010113          	addi	sp,sp,-48
40f06cf4:	02812423          	sw	s0,40(sp)
40f06cf8:	02912223          	sw	s1,36(sp)
40f06cfc:	01312e23          	sw	s3,28(sp)
40f06d00:	02112623          	sw	ra,44(sp)
40f06d04:	03212023          	sw	s2,32(sp)
40f06d08:	01412c23          	sw	s4,24(sp)
40f06d0c:	03010413          	addi	s0,sp,48
40f06d10:	00050493          	mv	s1,a0
40f06d14:	00058993          	mv	s3,a1
	int rc;

	if (cold_boot) {
40f06d18:	02060063          	beqz	a2,40f06d38 <sbi_hart_init+0x48>
		trap_info_offset = sbi_scratch_alloc_offset(__SIZEOF_POINTER__,
40f06d1c:	00004597          	auipc	a1,0x4
40f06d20:	af058593          	addi	a1,a1,-1296 # 40f0a80c <platform_ops+0x228>
40f06d24:	00400513          	li	a0,4
40f06d28:	ad5fa0ef          	jal	ra,40f017fc <sbi_scratch_alloc_offset>
40f06d2c:	00005797          	auipc	a5,0x5
40f06d30:	30a7aa23          	sw	a0,788(a5) # 40f0c040 <trap_info_offset>
							    "HART_TRAP_INFO");
		if (!trap_info_offset)
40f06d34:	3a050063          	beqz	a0,40f070d4 <sbi_hart_init+0x3e4>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f06d38:	0194c703          	lbu	a4,25(s1)
40f06d3c:	0184c683          	lbu	a3,24(s1)
40f06d40:	01a4c783          	lbu	a5,26(s1)
40f06d44:	01b4c903          	lbu	s2,27(s1)
40f06d48:	00871713          	slli	a4,a4,0x8
40f06d4c:	00d76733          	or	a4,a4,a3
40f06d50:	01079793          	slli	a5,a5,0x10
40f06d54:	00e7e7b3          	or	a5,a5,a4
40f06d58:	01891913          	slli	s2,s2,0x18
	if (misa_extension('D') || misa_extension('F'))
40f06d5c:	04400513          	li	a0,68
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f06d60:	00f96933          	or	s2,s2,a5
	if (misa_extension('D') || misa_extension('F'))
40f06d64:	a70fd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f06d68:	32050263          	beqz	a0,40f0708c <sbi_hart_init+0x39c>
		csr_write(CSR_MSTATUS, MSTATUS_FS);
40f06d6c:	000067b7          	lui	a5,0x6
40f06d70:	30079073          	csrw	mstatus,a5
	if (misa_extension('S') && sbi_platform_has_scounteren(plat))
40f06d74:	05300513          	li	a0,83
40f06d78:	a5cfd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f06d7c:	04994683          	lbu	a3,73(s2)
40f06d80:	04894603          	lbu	a2,72(s2)
40f06d84:	04a94703          	lbu	a4,74(s2)
40f06d88:	04b94783          	lbu	a5,75(s2)
40f06d8c:	00869693          	slli	a3,a3,0x8
40f06d90:	00c6e6b3          	or	a3,a3,a2
40f06d94:	01071713          	slli	a4,a4,0x10
40f06d98:	00d76733          	or	a4,a4,a3
40f06d9c:	01879793          	slli	a5,a5,0x18
40f06da0:	00e7e7b3          	or	a5,a5,a4
40f06da4:	02050e63          	beqz	a0,40f06de0 <sbi_hart_init+0xf0>
40f06da8:	0087f713          	andi	a4,a5,8
40f06dac:	02070a63          	beqz	a4,40f06de0 <sbi_hart_init+0xf0>
		csr_write(CSR_SCOUNTEREN, -1);
40f06db0:	fff00793          	li	a5,-1
40f06db4:	10679073          	csrw	scounteren,a5
40f06db8:	04994683          	lbu	a3,73(s2)
40f06dbc:	04894603          	lbu	a2,72(s2)
40f06dc0:	04a94703          	lbu	a4,74(s2)
40f06dc4:	04b94783          	lbu	a5,75(s2)
40f06dc8:	00869693          	slli	a3,a3,0x8
40f06dcc:	00c6e6b3          	or	a3,a3,a2
40f06dd0:	01071713          	slli	a4,a4,0x10
40f06dd4:	00d76733          	or	a4,a4,a3
40f06dd8:	01879793          	slli	a5,a5,0x18
40f06ddc:	00e7e7b3          	or	a5,a5,a4
	if (sbi_platform_has_mcounteren(plat))
40f06de0:	0107f793          	andi	a5,a5,16
40f06de4:	28079663          	bnez	a5,40f07070 <sbi_hart_init+0x380>
	csr_write(CSR_MIE, 0);
40f06de8:	30405073          	csrwi	mie,0
	if (misa_extension('S'))
40f06dec:	05300513          	li	a0,83
40f06df0:	9e4fd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f06df4:	24051e63          	bnez	a0,40f07050 <sbi_hart_init+0x360>
	if (!misa_extension('D') && !misa_extension('F'))
40f06df8:	04400513          	li	a0,68
40f06dfc:	9d8fd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f06e00:	26050063          	beqz	a0,40f07060 <sbi_hart_init+0x370>
	if (!(csr_read(CSR_MSTATUS) & MSTATUS_FS))
40f06e04:	300027f3          	csrr	a5,mstatus
40f06e08:	00006737          	lui	a4,0x6
40f06e0c:	00e7f7b3          	and	a5,a5,a4
40f06e10:	2c078663          	beqz	a5,40f070dc <sbi_hart_init+0x3ec>
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f06e14:	0194c703          	lbu	a4,25(s1)
40f06e18:	0184c603          	lbu	a2,24(s1)
40f06e1c:	01a4c783          	lbu	a5,26(s1)
40f06e20:	01b4c683          	lbu	a3,27(s1)
40f06e24:	00871713          	slli	a4,a4,0x8
40f06e28:	00c76733          	or	a4,a4,a2
40f06e2c:	01079793          	slli	a5,a5,0x10
40f06e30:	00e7e7b3          	or	a5,a5,a4
	if (!misa_extension('S'))
40f06e34:	05300513          	li	a0,83
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f06e38:	01869713          	slli	a4,a3,0x18
40f06e3c:	00f76933          	or	s2,a4,a5
	if (!misa_extension('S'))
40f06e40:	994fd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f06e44:	02050663          	beqz	a0,40f06e70 <sbi_hart_init+0x180>
	if (sbi_platform_has_mfaults_delegation(plat))
40f06e48:	04894783          	lbu	a5,72(s2)
	exceptions = (1U << CAUSE_MISALIGNED_FETCH) | (1U << CAUSE_BREAKPOINT) |
40f06e4c:	10900913          	li	s2,265
	if (sbi_platform_has_mfaults_delegation(plat))
40f06e50:	0207f793          	andi	a5,a5,32
40f06e54:	24079c63          	bnez	a5,40f070ac <sbi_hart_init+0x3bc>
	if (misa_extension('H')) {
40f06e58:	04800513          	li	a0,72
40f06e5c:	978fd0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f06e60:	22051e63          	bnez	a0,40f0709c <sbi_hart_init+0x3ac>
	csr_write(CSR_MIDELEG, interrupts);
40f06e64:	22200793          	li	a5,546
40f06e68:	30379073          	csrw	mideleg,a5
	csr_write(CSR_MEDELEG, exceptions);
40f06e6c:	30291073          	csrw	medeleg,s2
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f06e70:	0194c903          	lbu	s2,25(s1)
40f06e74:	0184c683          	lbu	a3,24(s1)
40f06e78:	01a4c783          	lbu	a5,26(s1)
40f06e7c:	01b4c703          	lbu	a4,27(s1)
40f06e80:	00891913          	slli	s2,s2,0x8
40f06e84:	00d96933          	or	s2,s2,a3
40f06e88:	01079793          	slli	a5,a5,0x10
40f06e8c:	0127e7b3          	or	a5,a5,s2
40f06e90:	01871913          	slli	s2,a4,0x18
40f06e94:	00f96933          	or	s2,s2,a5
	if (!sbi_platform_has_pmp(plat))
40f06e98:	04894783          	lbu	a5,72(s2)
40f06e9c:	0047f793          	andi	a5,a5,4
40f06ea0:	18078663          	beqz	a5,40f0702c <sbi_hart_init+0x33c>
	fw_size_log2 = log2roundup(scratch->fw_size);
40f06ea4:	0054c683          	lbu	a3,5(s1)
40f06ea8:	0044c603          	lbu	a2,4(s1)
40f06eac:	0064c703          	lbu	a4,6(s1)
40f06eb0:	0074c783          	lbu	a5,7(s1)
40f06eb4:	00869693          	slli	a3,a3,0x8
40f06eb8:	00c6e6b3          	or	a3,a3,a2
40f06ebc:	01071713          	slli	a4,a4,0x10
40f06ec0:	00d76733          	or	a4,a4,a3
40f06ec4:	01879793          	slli	a5,a5,0x18
	unsigned long ret = 0;
40f06ec8:	00000693          	li	a3,0
		if (x <= (1UL << ret))
40f06ecc:	00100593          	li	a1,1
	fw_size_log2 = log2roundup(scratch->fw_size);
40f06ed0:	00e7e7b3          	or	a5,a5,a4
		if (x <= (1UL << ret))
40f06ed4:	00d59633          	sll	a2,a1,a3
	while (ret < __riscv_xlen) {
40f06ed8:	02000713          	li	a4,32
		if (x <= (1UL << ret))
40f06edc:	00f67a63          	bgeu	a2,a5,40f06ef0 <sbi_hart_init+0x200>
		ret++;
40f06ee0:	00168693          	addi	a3,a3,1
	while (ret < __riscv_xlen) {
40f06ee4:	1ee68063          	beq	a3,a4,40f070c4 <sbi_hart_init+0x3d4>
		if (x <= (1UL << ret))
40f06ee8:	00d59633          	sll	a2,a1,a3
40f06eec:	fef66ae3          	bltu	a2,a5,40f06ee0 <sbi_hart_init+0x1f0>
40f06ef0:	40c00633          	neg	a2,a2
	fw_start     = scratch->fw_start & ~((1UL << fw_size_log2) - 1UL);
40f06ef4:	0014c583          	lbu	a1,1(s1)
40f06ef8:	0004c503          	lbu	a0,0(s1)
40f06efc:	0024c703          	lbu	a4,2(s1)
40f06f00:	0034c783          	lbu	a5,3(s1)
40f06f04:	00859593          	slli	a1,a1,0x8
40f06f08:	00a5e5b3          	or	a1,a1,a0
40f06f0c:	01071713          	slli	a4,a4,0x10
40f06f10:	00b76733          	or	a4,a4,a1
40f06f14:	01879793          	slli	a5,a5,0x18
40f06f18:	00e7e7b3          	or	a5,a5,a4
	pmp_set(0, 0, fw_start, fw_size_log2);
40f06f1c:	00c7f633          	and	a2,a5,a2
40f06f20:	00000593          	li	a1,0
40f06f24:	00000513          	li	a0,0
40f06f28:	c10fd0ef          	jal	ra,40f04338 <pmp_set>
	if (plat && sbi_platform_ops(plat)->pmp_region_count)
40f06f2c:	10090063          	beqz	s2,40f0702c <sbi_hart_init+0x33c>
40f06f30:	06194683          	lbu	a3,97(s2)
40f06f34:	06094603          	lbu	a2,96(s2)
40f06f38:	06294703          	lbu	a4,98(s2)
40f06f3c:	06394783          	lbu	a5,99(s2)
40f06f40:	00869693          	slli	a3,a3,0x8
40f06f44:	00c6e6b3          	or	a3,a3,a2
40f06f48:	01071713          	slli	a4,a4,0x10
40f06f4c:	00d76733          	or	a4,a4,a3
40f06f50:	01879793          	slli	a5,a5,0x18
40f06f54:	00e7e7b3          	or	a5,a5,a4
40f06f58:	0197c683          	lbu	a3,25(a5) # 6019 <_fw_start-0x40ef9fe7>
40f06f5c:	0187c603          	lbu	a2,24(a5)
40f06f60:	01a7c703          	lbu	a4,26(a5)
40f06f64:	01b7c783          	lbu	a5,27(a5)
40f06f68:	00869693          	slli	a3,a3,0x8
40f06f6c:	00c6e6b3          	or	a3,a3,a2
40f06f70:	01071713          	slli	a4,a4,0x10
40f06f74:	00d76733          	or	a4,a4,a3
40f06f78:	01879793          	slli	a5,a5,0x18
40f06f7c:	00e7e7b3          	or	a5,a5,a4
40f06f80:	0a078663          	beqz	a5,40f0702c <sbi_hart_init+0x33c>
		return sbi_platform_ops(plat)->pmp_region_count(hartid);
40f06f84:	00098513          	mv	a0,s3
40f06f88:	000780e7          	jalr	a5
	if ((PMP_COUNT - 1) < count)
40f06f8c:	00f00793          	li	a5,15
40f06f90:	00050493          	mv	s1,a0
40f06f94:	12a7ec63          	bltu	a5,a0,40f070cc <sbi_hart_init+0x3dc>
	for (i = 0; i < count; i++) {
40f06f98:	08050a63          	beqz	a0,40f0702c <sbi_hart_init+0x33c>
40f06f9c:	00000a13          	li	s4,0
	if (plat && sbi_platform_ops(plat)->pmp_region_info)
40f06fa0:	06194683          	lbu	a3,97(s2)
40f06fa4:	06094603          	lbu	a2,96(s2)
40f06fa8:	06294703          	lbu	a4,98(s2)
40f06fac:	06394783          	lbu	a5,99(s2)
40f06fb0:	00869693          	slli	a3,a3,0x8
40f06fb4:	00c6e6b3          	or	a3,a3,a2
40f06fb8:	01071713          	slli	a4,a4,0x10
40f06fbc:	00d76733          	or	a4,a4,a3
40f06fc0:	01879793          	slli	a5,a5,0x18
40f06fc4:	00e7e7b3          	or	a5,a5,a4
40f06fc8:	01d7c703          	lbu	a4,29(a5)
40f06fcc:	01c7c683          	lbu	a3,28(a5)
40f06fd0:	01e7c883          	lbu	a7,30(a5)
40f06fd4:	01f7c783          	lbu	a5,31(a5)
40f06fd8:	00871713          	slli	a4,a4,0x8
40f06fdc:	00d76733          	or	a4,a4,a3
40f06fe0:	01089893          	slli	a7,a7,0x10
40f06fe4:	00e8e8b3          	or	a7,a7,a4
40f06fe8:	01879793          	slli	a5,a5,0x18
40f06fec:	0117e7b3          	or	a5,a5,a7
		return sbi_platform_ops(plat)->pmp_region_info(hartid, index, prot, addr,
40f06ff0:	000a0593          	mv	a1,s4
40f06ff4:	fdc40713          	addi	a4,s0,-36
40f06ff8:	fd840693          	addi	a3,s0,-40
40f06ffc:	fd440613          	addi	a2,s0,-44
40f07000:	00098513          	mv	a0,s3
40f07004:	001a0a13          	addi	s4,s4,1
	if (plat && sbi_platform_ops(plat)->pmp_region_info)
40f07008:	00078663          	beqz	a5,40f07014 <sbi_hart_init+0x324>
		return sbi_platform_ops(plat)->pmp_region_info(hartid, index, prot, addr,
40f0700c:	000780e7          	jalr	a5
		if (sbi_platform_pmp_region_info(plat, hartid, i, &prot, &addr,
40f07010:	00051c63          	bnez	a0,40f07028 <sbi_hart_init+0x338>
		pmp_set(i + 1, prot, addr, log2size);
40f07014:	fdc42683          	lw	a3,-36(s0)
40f07018:	fd842603          	lw	a2,-40(s0)
40f0701c:	fd442583          	lw	a1,-44(s0)
40f07020:	000a0513          	mv	a0,s4
40f07024:	b14fd0ef          	jal	ra,40f04338 <pmp_set>
	for (i = 0; i < count; i++) {
40f07028:	f69a6ce3          	bltu	s4,s1,40f06fa0 <sbi_hart_init+0x2b0>

	rc = delegate_traps(scratch, hartid);
	if (rc)
		return rc;

	return pmp_init(scratch, hartid);
40f0702c:	00000513          	li	a0,0
}
40f07030:	02c12083          	lw	ra,44(sp)
40f07034:	02812403          	lw	s0,40(sp)
40f07038:	02412483          	lw	s1,36(sp)
40f0703c:	02012903          	lw	s2,32(sp)
40f07040:	01c12983          	lw	s3,28(sp)
40f07044:	01812a03          	lw	s4,24(sp)
40f07048:	03010113          	addi	sp,sp,48
40f0704c:	00008067          	ret
		csr_write(CSR_SATP, 0);
40f07050:	18005073          	csrwi	satp,0
	if (!misa_extension('D') && !misa_extension('F'))
40f07054:	04400513          	li	a0,68
40f07058:	f7dfc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f0705c:	da0514e3          	bnez	a0,40f06e04 <sbi_hart_init+0x114>
40f07060:	04600513          	li	a0,70
40f07064:	f71fc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f07068:	d8051ee3          	bnez	a0,40f06e04 <sbi_hart_init+0x114>
40f0706c:	da9ff06f          	j	40f06e14 <sbi_hart_init+0x124>
		csr_write(CSR_MCOUNTEREN, -1);
40f07070:	fff00793          	li	a5,-1
40f07074:	30679073          	csrw	mcounteren,a5
	csr_write(CSR_MIE, 0);
40f07078:	30405073          	csrwi	mie,0
	if (misa_extension('S'))
40f0707c:	05300513          	li	a0,83
40f07080:	f55fc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f07084:	d6050ae3          	beqz	a0,40f06df8 <sbi_hart_init+0x108>
40f07088:	fc9ff06f          	j	40f07050 <sbi_hart_init+0x360>
	if (misa_extension('D') || misa_extension('F'))
40f0708c:	04600513          	li	a0,70
40f07090:	f45fc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f07094:	cc051ce3          	bnez	a0,40f06d6c <sbi_hart_init+0x7c>
40f07098:	cddff06f          	j	40f06d74 <sbi_hart_init+0x84>
		exceptions |= (1U << CAUSE_STORE_GUEST_PAGE_FAULT);
40f0709c:	00b007b7          	lui	a5,0xb00
40f070a0:	40078793          	addi	a5,a5,1024 # b00400 <_fw_start-0x403ffc00>
40f070a4:	00f96933          	or	s2,s2,a5
40f070a8:	dbdff06f          	j	40f06e64 <sbi_hart_init+0x174>
		exceptions |= (1U << CAUSE_FETCH_PAGE_FAULT) |
40f070ac:	0000b937          	lui	s2,0xb
	if (misa_extension('H')) {
40f070b0:	04800513          	li	a0,72
		exceptions |= (1U << CAUSE_FETCH_PAGE_FAULT) |
40f070b4:	10990913          	addi	s2,s2,265 # b109 <_fw_start-0x40ef4ef7>
	if (misa_extension('H')) {
40f070b8:	f1dfc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f070bc:	da0504e3          	beqz	a0,40f06e64 <sbi_hart_init+0x174>
40f070c0:	fddff06f          	j	40f0709c <sbi_hart_init+0x3ac>
	while (ret < __riscv_xlen) {
40f070c4:	00000613          	li	a2,0
40f070c8:	e2dff06f          	j	40f06ef4 <sbi_hart_init+0x204>
40f070cc:	00f00493          	li	s1,15
40f070d0:	ec9ff06f          	j	40f06f98 <sbi_hart_init+0x2a8>
			return SBI_ENOMEM;
40f070d4:	ff400513          	li	a0,-12
40f070d8:	f59ff06f          	j	40f07030 <sbi_hart_init+0x340>
		return SBI_EINVAL;
40f070dc:	ffd00513          	li	a0,-3
40f070e0:	f51ff06f          	j	40f07030 <sbi_hart_init+0x340>

40f070e4 <sbi_hart_get_trap_info>:

void *sbi_hart_get_trap_info(struct sbi_scratch *scratch)
{
40f070e4:	ff010113          	addi	sp,sp,-16
40f070e8:	00812623          	sw	s0,12(sp)
40f070ec:	01010413          	addi	s0,sp,16
	unsigned long *trap_info;

	if (!trap_info_offset)
40f070f0:	00005797          	auipc	a5,0x5
40f070f4:	f5078793          	addi	a5,a5,-176 # 40f0c040 <trap_info_offset>
40f070f8:	0007a783          	lw	a5,0(a5)
40f070fc:	00078c63          	beqz	a5,40f07114 <sbi_hart_get_trap_info+0x30>
		return NULL;

	trap_info = sbi_scratch_offset_ptr(scratch, trap_info_offset);

	return (void *)(*trap_info);
}
40f07100:	00c12403          	lw	s0,12(sp)
	return (void *)(*trap_info);
40f07104:	00f50533          	add	a0,a0,a5
40f07108:	00052503          	lw	a0,0(a0)
}
40f0710c:	01010113          	addi	sp,sp,16
40f07110:	00008067          	ret
40f07114:	00c12403          	lw	s0,12(sp)
		return NULL;
40f07118:	00000513          	li	a0,0
}
40f0711c:	01010113          	addi	sp,sp,16
40f07120:	00008067          	ret

40f07124 <sbi_hart_set_trap_info>:

void sbi_hart_set_trap_info(struct sbi_scratch *scratch, void *data)
{
40f07124:	ff010113          	addi	sp,sp,-16
40f07128:	00812623          	sw	s0,12(sp)
40f0712c:	01010413          	addi	s0,sp,16
	unsigned long *trap_info;

	if (!trap_info_offset)
40f07130:	00005797          	auipc	a5,0x5
40f07134:	f1078793          	addi	a5,a5,-240 # 40f0c040 <trap_info_offset>
40f07138:	0007a783          	lw	a5,0(a5)
40f0713c:	00078663          	beqz	a5,40f07148 <sbi_hart_set_trap_info+0x24>
		return;

	trap_info = sbi_scratch_offset_ptr(scratch, trap_info_offset);
	*trap_info = (unsigned long)data;
40f07140:	00f50533          	add	a0,a0,a5
40f07144:	00b52023          	sw	a1,0(a0)
}
40f07148:	00c12403          	lw	s0,12(sp)
40f0714c:	01010113          	addi	sp,sp,16
40f07150:	00008067          	ret

40f07154 <sbi_hart_hang>:

void __attribute__((noreturn)) sbi_hart_hang(void)
{
40f07154:	ff010113          	addi	sp,sp,-16
40f07158:	00812623          	sw	s0,12(sp)
40f0715c:	01010413          	addi	s0,sp,16
	while (1)
		wfi();
40f07160:	10500073          	wfi
40f07164:	10500073          	wfi
40f07168:	ff9ff06f          	j	40f07160 <sbi_hart_hang+0xc>

40f0716c <sbi_hart_switch_mode>:

void __attribute__((noreturn))
sbi_hart_switch_mode(unsigned long arg0, unsigned long arg1,
		     unsigned long next_addr, unsigned long next_mode,
		     bool next_virt)
{
40f0716c:	fe010113          	addi	sp,sp,-32
40f07170:	00812c23          	sw	s0,24(sp)
40f07174:	01212823          	sw	s2,16(sp)
40f07178:	01312623          	sw	s3,12(sp)
40f0717c:	01412423          	sw	s4,8(sp)
40f07180:	01512223          	sw	s5,4(sp)
40f07184:	01612023          	sw	s6,0(sp)
40f07188:	00112e23          	sw	ra,28(sp)
40f0718c:	00912a23          	sw	s1,20(sp)
40f07190:	02010413          	addi	s0,sp,32
	unsigned long val, valH;
#else
	unsigned long val;
#endif

	switch (next_mode) {
40f07194:	00100793          	li	a5,1
{
40f07198:	00068913          	mv	s2,a3
40f0719c:	00050a93          	mv	s5,a0
40f071a0:	00058a13          	mv	s4,a1
40f071a4:	00060993          	mv	s3,a2
40f071a8:	00070b13          	mv	s6,a4
	switch (next_mode) {
40f071ac:	00f68e63          	beq	a3,a5,40f071c8 <sbi_hart_switch_mode+0x5c>
40f071b0:	02068863          	beqz	a3,40f071e0 <sbi_hart_switch_mode+0x74>
40f071b4:	00300793          	li	a5,3
40f071b8:	04f68063          	beq	a3,a5,40f071f8 <sbi_hart_switch_mode+0x8c>
		wfi();
40f071bc:	10500073          	wfi
40f071c0:	10500073          	wfi
40f071c4:	ff9ff06f          	j	40f071bc <sbi_hart_switch_mode+0x50>
	case PRV_M:
		break;
	case PRV_S:
		if (!misa_extension('S'))
40f071c8:	05300513          	li	a0,83
40f071cc:	e09fc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f071d0:	02051463          	bnez	a0,40f071f8 <sbi_hart_switch_mode+0x8c>
		wfi();
40f071d4:	10500073          	wfi
40f071d8:	10500073          	wfi
40f071dc:	ff9ff06f          	j	40f071d4 <sbi_hart_switch_mode+0x68>
			sbi_hart_hang();
		break;
	case PRV_U:
		if (!misa_extension('U'))
40f071e0:	05500513          	li	a0,85
40f071e4:	df1fc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f071e8:	00051863          	bnez	a0,40f071f8 <sbi_hart_switch_mode+0x8c>
		wfi();
40f071ec:	10500073          	wfi
40f071f0:	10500073          	wfi
40f071f4:	ff9ff06f          	j	40f071ec <sbi_hart_switch_mode+0x80>
		break;
	default:
		sbi_hart_hang();
	}

	val = csr_read(CSR_MSTATUS);
40f071f8:	300024f3          	csrr	s1,mstatus
	val = INSERT_FIELD(val, MSTATUS_MPP, next_mode);
40f071fc:	ffffe7b7          	lui	a5,0xffffe
40f07200:	7ff78793          	addi	a5,a5,2047 # ffffe7ff <_fw_end+0xbf0f17ff>
40f07204:	00f4f4b3          	and	s1,s1,a5
40f07208:	00b91793          	slli	a5,s2,0xb
40f0720c:	00f4e4b3          	or	s1,s1,a5
	val = INSERT_FIELD(val, MSTATUS_MPIE, 0);
#if __riscv_xlen == 32
	if (misa_extension('H')) {
40f07210:	04800513          	li	a0,72
	val = INSERT_FIELD(val, MSTATUS_MPIE, 0);
40f07214:	f7f4f493          	andi	s1,s1,-129
	if (misa_extension('H')) {
40f07218:	dbdfc0ef          	jal	ra,40f03fd4 <misa_extension_imp>
40f0721c:	00050c63          	beqz	a0,40f07234 <sbi_hart_switch_mode+0xc8>
		valH = csr_read(CSR_MSTATUSH);
40f07220:	31002773          	csrr	a4,0x310
		if (next_virt)
			valH = INSERT_FIELD(valH, MSTATUSH_MPV, 1);
		else
			valH = INSERT_FIELD(valH, MSTATUSH_MPV, 0);
40f07224:	f7f77793          	andi	a5,a4,-129
		if (next_virt)
40f07228:	000b0463          	beqz	s6,40f07230 <sbi_hart_switch_mode+0xc4>
			valH = INSERT_FIELD(valH, MSTATUSH_MPV, 1);
40f0722c:	08076793          	ori	a5,a4,128
		csr_write(CSR_MSTATUSH, valH);
40f07230:	31079073          	csrw	0x310,a5
			val = INSERT_FIELD(val, MSTATUS_MPV, 1);
		else
			val = INSERT_FIELD(val, MSTATUS_MPV, 0);
	}
#endif
	csr_write(CSR_MSTATUS, val);
40f07234:	30049073          	csrw	mstatus,s1
	csr_write(CSR_MEPC, next_addr);
40f07238:	34199073          	csrw	mepc,s3

	if (next_mode == PRV_S) {
40f0723c:	00100793          	li	a5,1
40f07240:	02f90063          	beq	s2,a5,40f07260 <sbi_hart_switch_mode+0xf4>
		csr_write(CSR_STVEC, next_addr);
		csr_write(CSR_SSCRATCH, 0);
		csr_write(CSR_SIE, 0);
		csr_write(CSR_SATP, 0);
	} else if (next_mode == PRV_U) {
40f07244:	00091863          	bnez	s2,40f07254 <sbi_hart_switch_mode+0xe8>
		csr_write(CSR_UTVEC, next_addr);
40f07248:	00599073          	csrw	utvec,s3
		csr_write(CSR_USCRATCH, 0);
40f0724c:	04005073          	csrwi	uscratch,0
		csr_write(CSR_UIE, 0);
40f07250:	00405073          	csrwi	uie,0
	}

	register unsigned long a0 asm("a0") = arg0;
40f07254:	000a8513          	mv	a0,s5
	register unsigned long a1 asm("a1") = arg1;
40f07258:	000a0593          	mv	a1,s4
	__asm__ __volatile__("mret" : : "r"(a0), "r"(a1));
40f0725c:	30200073          	mret
		csr_write(CSR_STVEC, next_addr);
40f07260:	10599073          	csrw	stvec,s3
		csr_write(CSR_SSCRATCH, 0);
40f07264:	14005073          	csrwi	sscratch,0
		csr_write(CSR_SIE, 0);
40f07268:	10405073          	csrwi	sie,0
		csr_write(CSR_SATP, 0);
40f0726c:	18005073          	csrwi	satp,0
40f07270:	fe5ff06f          	j	40f07254 <sbi_hart_switch_mode+0xe8>

40f07274 <sbi_hart_mark_available>:

static spinlock_t avail_hart_mask_lock	      = SPIN_LOCK_INITIALIZER;
static volatile unsigned long avail_hart_mask = 0;

void sbi_hart_mark_available(u32 hartid)
{
40f07274:	ff010113          	addi	sp,sp,-16
40f07278:	00112623          	sw	ra,12(sp)
40f0727c:	00812423          	sw	s0,8(sp)
40f07280:	00912223          	sw	s1,4(sp)
40f07284:	01010413          	addi	s0,sp,16
40f07288:	00050493          	mv	s1,a0
	spin_lock(&avail_hart_mask_lock);
40f0728c:	00005517          	auipc	a0,0x5
40f07290:	db050513          	addi	a0,a0,-592 # 40f0c03c <avail_hart_mask_lock>
40f07294:	de8fd0ef          	jal	ra,40f0487c <spin_lock>
	avail_hart_mask |= (1UL << hartid);
40f07298:	00005717          	auipc	a4,0x5
40f0729c:	da070713          	addi	a4,a4,-608 # 40f0c038 <avail_hart_mask>
40f072a0:	00072683          	lw	a3,0(a4)
40f072a4:	00100793          	li	a5,1
40f072a8:	009797b3          	sll	a5,a5,s1
40f072ac:	00d7e7b3          	or	a5,a5,a3
	spin_unlock(&avail_hart_mask_lock);
40f072b0:	00005517          	auipc	a0,0x5
40f072b4:	d8c50513          	addi	a0,a0,-628 # 40f0c03c <avail_hart_mask_lock>
	avail_hart_mask |= (1UL << hartid);
40f072b8:	00f72023          	sw	a5,0(a4)
	spin_unlock(&avail_hart_mask_lock);
40f072bc:	df0fd0ef          	jal	ra,40f048ac <spin_unlock>
}
40f072c0:	00c12083          	lw	ra,12(sp)
40f072c4:	00812403          	lw	s0,8(sp)
40f072c8:	00412483          	lw	s1,4(sp)
40f072cc:	01010113          	addi	sp,sp,16
40f072d0:	00008067          	ret

40f072d4 <sbi_hart_unmark_available>:

void sbi_hart_unmark_available(u32 hartid)
{
40f072d4:	ff010113          	addi	sp,sp,-16
40f072d8:	00112623          	sw	ra,12(sp)
40f072dc:	00812423          	sw	s0,8(sp)
40f072e0:	00912223          	sw	s1,4(sp)
40f072e4:	01010413          	addi	s0,sp,16
40f072e8:	00050493          	mv	s1,a0
	spin_lock(&avail_hart_mask_lock);
40f072ec:	00005517          	auipc	a0,0x5
40f072f0:	d5050513          	addi	a0,a0,-688 # 40f0c03c <avail_hart_mask_lock>
40f072f4:	d88fd0ef          	jal	ra,40f0487c <spin_lock>
	avail_hart_mask &= ~(1UL << hartid);
40f072f8:	00005717          	auipc	a4,0x5
40f072fc:	d4070713          	addi	a4,a4,-704 # 40f0c038 <avail_hart_mask>
40f07300:	00072683          	lw	a3,0(a4)
40f07304:	00100793          	li	a5,1
40f07308:	009797b3          	sll	a5,a5,s1
40f0730c:	fff7c793          	not	a5,a5
40f07310:	00d7f7b3          	and	a5,a5,a3
	spin_unlock(&avail_hart_mask_lock);
40f07314:	00005517          	auipc	a0,0x5
40f07318:	d2850513          	addi	a0,a0,-728 # 40f0c03c <avail_hart_mask_lock>
	avail_hart_mask &= ~(1UL << hartid);
40f0731c:	00f72023          	sw	a5,0(a4)
	spin_unlock(&avail_hart_mask_lock);
40f07320:	d8cfd0ef          	jal	ra,40f048ac <spin_unlock>
}
40f07324:	00c12083          	lw	ra,12(sp)
40f07328:	00812403          	lw	s0,8(sp)
40f0732c:	00412483          	lw	s1,4(sp)
40f07330:	01010113          	addi	sp,sp,16
40f07334:	00008067          	ret

40f07338 <sbi_hart_available_mask>:

ulong sbi_hart_available_mask(void)
{
40f07338:	ff010113          	addi	sp,sp,-16
40f0733c:	00112623          	sw	ra,12(sp)
40f07340:	00812423          	sw	s0,8(sp)
40f07344:	00912223          	sw	s1,4(sp)
40f07348:	01010413          	addi	s0,sp,16
	ulong ret;

	spin_lock(&avail_hart_mask_lock);
40f0734c:	00005517          	auipc	a0,0x5
40f07350:	cf050513          	addi	a0,a0,-784 # 40f0c03c <avail_hart_mask_lock>
40f07354:	d28fd0ef          	jal	ra,40f0487c <spin_lock>
	ret = avail_hart_mask;
40f07358:	00005797          	auipc	a5,0x5
40f0735c:	ce078793          	addi	a5,a5,-800 # 40f0c038 <avail_hart_mask>
	spin_unlock(&avail_hart_mask_lock);
40f07360:	00005517          	auipc	a0,0x5
40f07364:	cdc50513          	addi	a0,a0,-804 # 40f0c03c <avail_hart_mask_lock>
	ret = avail_hart_mask;
40f07368:	0007a483          	lw	s1,0(a5)
	spin_unlock(&avail_hart_mask_lock);
40f0736c:	d40fd0ef          	jal	ra,40f048ac <spin_unlock>

	return ret;
}
40f07370:	00c12083          	lw	ra,12(sp)
40f07374:	00812403          	lw	s0,8(sp)
40f07378:	00048513          	mv	a0,s1
40f0737c:	00412483          	lw	s1,4(sp)
40f07380:	01010113          	addi	sp,sp,16
40f07384:	00008067          	ret

40f07388 <sbi_hart_id_to_scratch>:

typedef struct sbi_scratch *(*h2s)(ulong hartid);

struct sbi_scratch *sbi_hart_id_to_scratch(struct sbi_scratch *scratch,
					   u32 hartid)
{
40f07388:	ff010113          	addi	sp,sp,-16
40f0738c:	00812423          	sw	s0,8(sp)
40f07390:	00112623          	sw	ra,12(sp)
40f07394:	01010413          	addi	s0,sp,16
	return ((h2s)scratch->hartid_to_scratch)(hartid);
40f07398:	01d54683          	lbu	a3,29(a0)
40f0739c:	01c54603          	lbu	a2,28(a0)
40f073a0:	01e54703          	lbu	a4,30(a0)
40f073a4:	01f54783          	lbu	a5,31(a0)
40f073a8:	00869693          	slli	a3,a3,0x8
40f073ac:	00c6e6b3          	or	a3,a3,a2
40f073b0:	01071713          	slli	a4,a4,0x10
40f073b4:	00d76733          	or	a4,a4,a3
40f073b8:	01879793          	slli	a5,a5,0x18
40f073bc:	00e7e7b3          	or	a5,a5,a4
40f073c0:	00058513          	mv	a0,a1
40f073c4:	000780e7          	jalr	a5
}
40f073c8:	00c12083          	lw	ra,12(sp)
40f073cc:	00812403          	lw	s0,8(sp)
40f073d0:	01010113          	addi	sp,sp,16
40f073d4:	00008067          	ret

40f073d8 <sbi_hart_wait_for_coldboot>:
static spinlock_t coldboot_lock = SPIN_LOCK_INITIALIZER;
static unsigned long coldboot_done = 0;
static unsigned long coldboot_wait_bitmap = 0;

void sbi_hart_wait_for_coldboot(struct sbi_scratch *scratch, u32 hartid)
{
40f073d8:	fd010113          	addi	sp,sp,-48
40f073dc:	02812423          	sw	s0,40(sp)
40f073e0:	02112623          	sw	ra,44(sp)
40f073e4:	02912223          	sw	s1,36(sp)
40f073e8:	03212023          	sw	s2,32(sp)
40f073ec:	01312e23          	sw	s3,28(sp)
40f073f0:	01412c23          	sw	s4,24(sp)
40f073f4:	01512a23          	sw	s5,20(sp)
40f073f8:	01612823          	sw	s6,16(sp)
40f073fc:	01712623          	sw	s7,12(sp)
40f07400:	03010413          	addi	s0,sp,48
	unsigned long saved_mie;
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f07404:	01954703          	lbu	a4,25(a0)
40f07408:	01854483          	lbu	s1,24(a0)
40f0740c:	01a54783          	lbu	a5,26(a0)
40f07410:	01b54683          	lbu	a3,27(a0)
40f07414:	00871713          	slli	a4,a4,0x8
40f07418:	009764b3          	or	s1,a4,s1
40f0741c:	01079793          	slli	a5,a5,0x10
40f07420:	0097e7b3          	or	a5,a5,s1
40f07424:	01869493          	slli	s1,a3,0x18
40f07428:	00f4e4b3          	or	s1,s1,a5
	if (plat)
40f0742c:	02048c63          	beqz	s1,40f07464 <sbi_hart_wait_for_coldboot+0x8c>
		return plat->hart_count;
40f07430:	0514c683          	lbu	a3,81(s1)
40f07434:	0504c603          	lbu	a2,80(s1)
40f07438:	0524c703          	lbu	a4,82(s1)
40f0743c:	0534c783          	lbu	a5,83(s1)
40f07440:	00869693          	slli	a3,a3,0x8
40f07444:	00c6e6b3          	or	a3,a3,a2
40f07448:	01071713          	slli	a4,a4,0x10
40f0744c:	00d76733          	or	a4,a4,a3
40f07450:	01879793          	slli	a5,a5,0x18
40f07454:	00e7e7b3          	or	a5,a5,a4

	if ((sbi_platform_hart_count(plat) <= hartid) ||
40f07458:	00f5f663          	bgeu	a1,a5,40f07464 <sbi_hart_wait_for_coldboot+0x8c>
40f0745c:	01f00793          	li	a5,31
40f07460:	00b7f863          	bgeu	a5,a1,40f07470 <sbi_hart_wait_for_coldboot+0x98>
		wfi();
40f07464:	10500073          	wfi
40f07468:	10500073          	wfi
40f0746c:	ff9ff06f          	j	40f07464 <sbi_hart_wait_for_coldboot+0x8c>
40f07470:	00058993          	mv	s3,a1
	    (COLDBOOT_WAIT_BITMAP_SIZE <= hartid))
		sbi_hart_hang();

	/* Save MIE CSR */
	saved_mie = csr_read(CSR_MIE);
40f07474:	30402b73          	csrr	s6,mie

	/* Set MSIE bit to receive IPI */
	csr_set(CSR_MIE, MIP_MSIP);
40f07478:	30446073          	csrsi	mie,8

	/* Acquire coldboot lock */
	spin_lock(&coldboot_lock);
40f0747c:	00005517          	auipc	a0,0x5
40f07480:	bb850513          	addi	a0,a0,-1096 # 40f0c034 <coldboot_lock>
40f07484:	bf8fd0ef          	jal	ra,40f0487c <spin_lock>

	/* Mark current HART as waiting */
	coldboot_wait_bitmap |= (1UL << hartid);
40f07488:	00005a17          	auipc	s4,0x5
40f0748c:	ba4a0a13          	addi	s4,s4,-1116 # 40f0c02c <coldboot_wait_bitmap>
40f07490:	000a2783          	lw	a5,0(s4)

	/* Wait for coldboot to finish using WFI */
	while (!coldboot_done) {
40f07494:	00005b97          	auipc	s7,0x5
40f07498:	b9cb8b93          	addi	s7,s7,-1124 # 40f0c030 <coldboot_done>
	coldboot_wait_bitmap |= (1UL << hartid);
40f0749c:	00100913          	li	s2,1
40f074a0:	01391933          	sll	s2,s2,s3
	while (!coldboot_done) {
40f074a4:	000ba683          	lw	a3,0(s7)
	coldboot_wait_bitmap |= (1UL << hartid);
40f074a8:	00f96733          	or	a4,s2,a5
40f074ac:	00005797          	auipc	a5,0x5
40f074b0:	b8e7a023          	sw	a4,-1152(a5) # 40f0c02c <coldboot_wait_bitmap>
	while (!coldboot_done) {
40f074b4:	02069663          	bnez	a3,40f074e0 <sbi_hart_wait_for_coldboot+0x108>
		spin_unlock(&coldboot_lock);
40f074b8:	00005a97          	auipc	s5,0x5
40f074bc:	b7ca8a93          	addi	s5,s5,-1156 # 40f0c034 <coldboot_lock>
40f074c0:	000a8513          	mv	a0,s5
40f074c4:	be8fd0ef          	jal	ra,40f048ac <spin_unlock>
		wfi();
40f074c8:	10500073          	wfi
		spin_lock(&coldboot_lock);
40f074cc:	000a8513          	mv	a0,s5
40f074d0:	bacfd0ef          	jal	ra,40f0487c <spin_lock>
	while (!coldboot_done) {
40f074d4:	000ba783          	lw	a5,0(s7)
40f074d8:	fe0784e3          	beqz	a5,40f074c0 <sbi_hart_wait_for_coldboot+0xe8>
40f074dc:	000a2703          	lw	a4,0(s4)
	};

	/* Unmark current HART as waiting */
	coldboot_wait_bitmap &= ~(1UL << hartid);
40f074e0:	fff94793          	not	a5,s2
40f074e4:	00e7f7b3          	and	a5,a5,a4

	/* Release coldboot lock */
	spin_unlock(&coldboot_lock);
40f074e8:	00005517          	auipc	a0,0x5
40f074ec:	b4c50513          	addi	a0,a0,-1204 # 40f0c034 <coldboot_lock>
	coldboot_wait_bitmap &= ~(1UL << hartid);
40f074f0:	00005717          	auipc	a4,0x5
40f074f4:	b2f72e23          	sw	a5,-1220(a4) # 40f0c02c <coldboot_wait_bitmap>
	spin_unlock(&coldboot_lock);
40f074f8:	bb4fd0ef          	jal	ra,40f048ac <spin_unlock>

	/* Restore MIE CSR */
	csr_write(CSR_MIE, saved_mie);
40f074fc:	304b1073          	csrw	mie,s6
	if (plat && sbi_platform_ops(plat)->ipi_clear)
40f07500:	0614c683          	lbu	a3,97(s1)
40f07504:	0604c603          	lbu	a2,96(s1)
40f07508:	0624c703          	lbu	a4,98(s1)
40f0750c:	0634c783          	lbu	a5,99(s1)
40f07510:	00869693          	slli	a3,a3,0x8
40f07514:	00c6e6b3          	or	a3,a3,a2
40f07518:	01071713          	slli	a4,a4,0x10
40f0751c:	00d76733          	or	a4,a4,a3
40f07520:	01879793          	slli	a5,a5,0x18
40f07524:	00e7e7b3          	or	a5,a5,a4
40f07528:	0397c683          	lbu	a3,57(a5)
40f0752c:	0387c603          	lbu	a2,56(a5)
40f07530:	03a7c703          	lbu	a4,58(a5)
40f07534:	03b7c783          	lbu	a5,59(a5)
40f07538:	00869693          	slli	a3,a3,0x8
40f0753c:	00c6e6b3          	or	a3,a3,a2
40f07540:	01071713          	slli	a4,a4,0x10
40f07544:	00d76733          	or	a4,a4,a3
40f07548:	01879793          	slli	a5,a5,0x18
40f0754c:	00e7e7b3          	or	a5,a5,a4
40f07550:	00078663          	beqz	a5,40f0755c <sbi_hart_wait_for_coldboot+0x184>
		sbi_platform_ops(plat)->ipi_clear(target_hart);
40f07554:	00098513          	mv	a0,s3
40f07558:	000780e7          	jalr	a5

	/* Clear current HART IPI */
	sbi_platform_ipi_clear(plat, hartid);
}
40f0755c:	02c12083          	lw	ra,44(sp)
40f07560:	02812403          	lw	s0,40(sp)
40f07564:	02412483          	lw	s1,36(sp)
40f07568:	02012903          	lw	s2,32(sp)
40f0756c:	01c12983          	lw	s3,28(sp)
40f07570:	01812a03          	lw	s4,24(sp)
40f07574:	01412a83          	lw	s5,20(sp)
40f07578:	01012b03          	lw	s6,16(sp)
40f0757c:	00c12b83          	lw	s7,12(sp)
40f07580:	03010113          	addi	sp,sp,48
40f07584:	00008067          	ret

40f07588 <sbi_hart_wake_coldboot_harts>:

void sbi_hart_wake_coldboot_harts(struct sbi_scratch *scratch, u32 hartid)
{
40f07588:	fe010113          	addi	sp,sp,-32
40f0758c:	00812c23          	sw	s0,24(sp)
40f07590:	00112e23          	sw	ra,28(sp)
40f07594:	00912a23          	sw	s1,20(sp)
40f07598:	01212823          	sw	s2,16(sp)
40f0759c:	01312623          	sw	s3,12(sp)
40f075a0:	01412423          	sw	s4,8(sp)
40f075a4:	01512223          	sw	s5,4(sp)
40f075a8:	02010413          	addi	s0,sp,32
	const struct sbi_platform *plat = sbi_platform_ptr(scratch);
40f075ac:	01954703          	lbu	a4,25(a0)
40f075b0:	01854903          	lbu	s2,24(a0)
40f075b4:	01a54783          	lbu	a5,26(a0)
40f075b8:	01b54683          	lbu	a3,27(a0)
40f075bc:	00871713          	slli	a4,a4,0x8
40f075c0:	01276933          	or	s2,a4,s2
40f075c4:	01079793          	slli	a5,a5,0x10
40f075c8:	0127e7b3          	or	a5,a5,s2
40f075cc:	01869913          	slli	s2,a3,0x18
40f075d0:	00f96933          	or	s2,s2,a5
	if (plat)
40f075d4:	10090063          	beqz	s2,40f076d4 <sbi_hart_wake_coldboot_harts+0x14c>
		return plat->hart_count;
40f075d8:	05194983          	lbu	s3,81(s2)
40f075dc:	05094683          	lbu	a3,80(s2)
40f075e0:	05294783          	lbu	a5,82(s2)
40f075e4:	05394703          	lbu	a4,83(s2)
40f075e8:	00899993          	slli	s3,s3,0x8
40f075ec:	00d9e9b3          	or	s3,s3,a3
40f075f0:	01079793          	slli	a5,a5,0x10
40f075f4:	0137e7b3          	or	a5,a5,s3
	int max_hart			= sbi_platform_hart_count(plat);

	/* Acquire coldboot lock */
	spin_lock(&coldboot_lock);
40f075f8:	00005517          	auipc	a0,0x5
40f075fc:	a3c50513          	addi	a0,a0,-1476 # 40f0c034 <coldboot_lock>
40f07600:	01871993          	slli	s3,a4,0x18
40f07604:	00f9e9b3          	or	s3,s3,a5
40f07608:	00058a13          	mv	s4,a1
40f0760c:	a70fd0ef          	jal	ra,40f0487c <spin_lock>

	/* Mark coldboot done */
	coldboot_done = 1;
40f07610:	00100793          	li	a5,1
40f07614:	00005717          	auipc	a4,0x5
40f07618:	a0f72e23          	sw	a5,-1508(a4) # 40f0c030 <coldboot_done>

	/* Send an IPI to all HARTs waiting for coldboot */
	for (int i = 0; i < max_hart; i++) {
40f0761c:	00000493          	li	s1,0
		if ((i != hartid) && (coldboot_wait_bitmap & (1UL << i)))
40f07620:	00005a97          	auipc	s5,0x5
40f07624:	a0ca8a93          	addi	s5,s5,-1524 # 40f0c02c <coldboot_wait_bitmap>
	for (int i = 0; i < max_hart; i++) {
40f07628:	07305e63          	blez	s3,40f076a4 <sbi_hart_wake_coldboot_harts+0x11c>
		if ((i != hartid) && (coldboot_wait_bitmap & (1UL << i)))
40f0762c:	069a0863          	beq	s4,s1,40f0769c <sbi_hart_wake_coldboot_harts+0x114>
40f07630:	000aa783          	lw	a5,0(s5)
40f07634:	0097d7b3          	srl	a5,a5,s1
40f07638:	0017f793          	andi	a5,a5,1
40f0763c:	06078063          	beqz	a5,40f0769c <sbi_hart_wake_coldboot_harts+0x114>
	if (plat && sbi_platform_ops(plat)->ipi_send)
40f07640:	06194683          	lbu	a3,97(s2)
40f07644:	06094603          	lbu	a2,96(s2)
40f07648:	06294703          	lbu	a4,98(s2)
40f0764c:	06394783          	lbu	a5,99(s2)
40f07650:	00869693          	slli	a3,a3,0x8
40f07654:	00c6e6b3          	or	a3,a3,a2
40f07658:	01071713          	slli	a4,a4,0x10
40f0765c:	00d76733          	or	a4,a4,a3
40f07660:	01879793          	slli	a5,a5,0x18
40f07664:	00e7e7b3          	or	a5,a5,a4
40f07668:	0357c683          	lbu	a3,53(a5)
40f0766c:	0347c603          	lbu	a2,52(a5)
40f07670:	0367c703          	lbu	a4,54(a5)
40f07674:	0377c783          	lbu	a5,55(a5)
40f07678:	00869693          	slli	a3,a3,0x8
40f0767c:	00c6e6b3          	or	a3,a3,a2
40f07680:	01071713          	slli	a4,a4,0x10
40f07684:	00d76733          	or	a4,a4,a3
40f07688:	01879793          	slli	a5,a5,0x18
40f0768c:	00e7e7b3          	or	a5,a5,a4
		sbi_platform_ops(plat)->ipi_send(target_hart);
40f07690:	00048513          	mv	a0,s1
	if (plat && sbi_platform_ops(plat)->ipi_send)
40f07694:	00078463          	beqz	a5,40f0769c <sbi_hart_wake_coldboot_harts+0x114>
		sbi_platform_ops(plat)->ipi_send(target_hart);
40f07698:	000780e7          	jalr	a5
	for (int i = 0; i < max_hart; i++) {
40f0769c:	00148493          	addi	s1,s1,1
40f076a0:	f89996e3          	bne	s3,s1,40f0762c <sbi_hart_wake_coldboot_harts+0xa4>
			sbi_platform_ipi_send(plat, i);
	}

	/* Release coldboot lock */
	spin_unlock(&coldboot_lock);
40f076a4:	00005517          	auipc	a0,0x5
40f076a8:	99050513          	addi	a0,a0,-1648 # 40f0c034 <coldboot_lock>
40f076ac:	a00fd0ef          	jal	ra,40f048ac <spin_unlock>
}
40f076b0:	01c12083          	lw	ra,28(sp)
40f076b4:	01812403          	lw	s0,24(sp)
40f076b8:	01412483          	lw	s1,20(sp)
40f076bc:	01012903          	lw	s2,16(sp)
40f076c0:	00c12983          	lw	s3,12(sp)
40f076c4:	00812a03          	lw	s4,8(sp)
40f076c8:	00412a83          	lw	s5,4(sp)
40f076cc:	02010113          	addi	sp,sp,32
40f076d0:	00008067          	ret
	spin_lock(&coldboot_lock);
40f076d4:	00005517          	auipc	a0,0x5
40f076d8:	96050513          	addi	a0,a0,-1696 # 40f0c034 <coldboot_lock>
40f076dc:	9a0fd0ef          	jal	ra,40f0487c <spin_lock>
	coldboot_done = 1;
40f076e0:	00100793          	li	a5,1
40f076e4:	00005717          	auipc	a4,0x5
40f076e8:	94f72623          	sw	a5,-1716(a4) # 40f0c030 <coldboot_done>
	for (int i = 0; i < max_hart; i++) {
40f076ec:	fb9ff06f          	j	40f076a4 <sbi_hart_wake_coldboot_harts+0x11c>

40f076f0 <truly_illegal_insn>:
				 struct sbi_scratch *scratch);

static int truly_illegal_insn(ulong insn, u32 hartid, ulong mcause,
			      struct sbi_trap_regs *regs,
			      struct sbi_scratch *scratch)
{
40f076f0:	fd010113          	addi	sp,sp,-48
40f076f4:	02812423          	sw	s0,40(sp)
40f076f8:	02112623          	sw	ra,44(sp)
40f076fc:	03010413          	addi	s0,sp,48
	struct sbi_trap_info trap;

	trap.epc = regs->mepc;
40f07700:	0816c803          	lbu	a6,129(a3)
40f07704:	0806c883          	lbu	a7,128(a3)
40f07708:	0826c583          	lbu	a1,130(a3)
40f0770c:	0836c783          	lbu	a5,131(a3)
40f07710:	00881813          	slli	a6,a6,0x8
40f07714:	01186833          	or	a6,a6,a7
40f07718:	01059593          	slli	a1,a1,0x10
40f0771c:	0105e5b3          	or	a1,a1,a6
40f07720:	01879793          	slli	a5,a5,0x18
40f07724:	00b7e7b3          	or	a5,a5,a1
	trap.cause = mcause;
40f07728:	fec42023          	sw	a2,-32(s0)
	trap.tval = insn;
40f0772c:	fea42223          	sw	a0,-28(s0)
	trap.tval2 = 0;
	trap.tinst = 0;

	return sbi_trap_redirect(regs, &trap, scratch);
40f07730:	fdc40593          	addi	a1,s0,-36
40f07734:	00070613          	mv	a2,a4
40f07738:	00068513          	mv	a0,a3
	trap.epc = regs->mepc;
40f0773c:	fcf42e23          	sw	a5,-36(s0)
	trap.tval2 = 0;
40f07740:	fe042423          	sw	zero,-24(s0)
	trap.tinst = 0;
40f07744:	fe042623          	sw	zero,-20(s0)
	return sbi_trap_redirect(regs, &trap, scratch);
40f07748:	c5cfb0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
}
40f0774c:	02c12083          	lw	ra,44(sp)
40f07750:	02812403          	lw	s0,40(sp)
40f07754:	03010113          	addi	sp,sp,48
40f07758:	00008067          	ret

40f0775c <system_opcode_insn>:

static int system_opcode_insn(ulong insn, u32 hartid, ulong mcause,
			      struct sbi_trap_regs *regs,
			      struct sbi_scratch *scratch)
{
40f0775c:	fb010113          	addi	sp,sp,-80
40f07760:	04812423          	sw	s0,72(sp)
40f07764:	04912223          	sw	s1,68(sp)
40f07768:	05212023          	sw	s2,64(sp)
40f0776c:	03412c23          	sw	s4,56(sp)
40f07770:	03512a23          	sw	s5,52(sp)
40f07774:	03712623          	sw	s7,44(sp)
40f07778:	03812423          	sw	s8,40(sp)
40f0777c:	04112623          	sw	ra,76(sp)
40f07780:	03312e23          	sw	s3,60(sp)
40f07784:	03612823          	sw	s6,48(sp)
40f07788:	05010413          	addi	s0,sp,80
40f0778c:	00068493          	mv	s1,a3
	/*
	 * WFI always traps as illegal instruction when executed from
	 * VS/VU mode so we just forward it to HS-mode.
	 */
#if __riscv_xlen == 32
	if ((regs->mstatusH & MSTATUSH_MPV) &&
40f07790:	0886c683          	lbu	a3,136(a3)
	ulong rs1_val = GET_RS1(insn, regs);
40f07794:	00d55793          	srli	a5,a0,0xd
40f07798:	07c7f793          	andi	a5,a5,124
40f0779c:	009787b3          	add	a5,a5,s1
	if ((regs->mstatusH & MSTATUSH_MPV) &&
40f077a0:	0806f693          	andi	a3,a3,128
{
40f077a4:	00050913          	mv	s2,a0
40f077a8:	00058c13          	mv	s8,a1
40f077ac:	00060a13          	mv	s4,a2
40f077b0:	00070a93          	mv	s5,a4
	ulong rs1_val = GET_RS1(insn, regs);
40f077b4:	0007ab03          	lw	s6,0(a5)
	int csr_num   = (u32)insn >> 20;
40f077b8:	01455b93          	srli	s7,a0,0x14
	if ((regs->mstatusH & MSTATUSH_MPV) &&
40f077bc:	00068863          	beqz	a3,40f077cc <system_opcode_insn+0x70>
#else
	if ((regs->mstatus & MSTATUS_MPV) &&
#endif
	    (insn & INSN_MASK_WFI) == INSN_MATCH_WFI)
40f077c0:	f0057793          	andi	a5,a0,-256
	if ((regs->mstatusH & MSTATUSH_MPV) &&
40f077c4:	10500737          	lui	a4,0x10500
40f077c8:	0ee78e63          	beq	a5,a4,40f078c4 <system_opcode_insn+0x168>
		return truly_illegal_insn(insn, hartid, mcause,
					  regs, scratch);

	if (sbi_emulate_csr_read(csr_num, hartid, regs, scratch, &csr_val))
40f077cc:	fb840713          	addi	a4,s0,-72
40f077d0:	000a8693          	mv	a3,s5
40f077d4:	00048613          	mv	a2,s1
40f077d8:	000c0593          	mv	a1,s8
40f077dc:	000b8513          	mv	a0,s7
40f077e0:	200010ef          	jal	ra,40f089e0 <sbi_emulate_csr_read>
40f077e4:	00050993          	mv	s3,a0
40f077e8:	0c051e63          	bnez	a0,40f078c4 <system_opcode_insn+0x168>
		return truly_illegal_insn(insn, hartid, mcause,
					  regs, scratch);

	do_write = rs1_num;
	switch (GET_RM(insn)) {
40f077ec:	00a95793          	srli	a5,s2,0xa
40f077f0:	00003697          	auipc	a3,0x3
40f077f4:	02c68693          	addi	a3,a3,44 # 40f0a81c <platform_ops+0x238>
40f077f8:	01c7f793          	andi	a5,a5,28
40f077fc:	00d787b3          	add	a5,a5,a3
40f07800:	0007a703          	lw	a4,0(a5)
	int do_write, rs1_num = (insn >> 15) & 0x1f;
40f07804:	00f95793          	srli	a5,s2,0xf
40f07808:	01f7f793          	andi	a5,a5,31
	switch (GET_RM(insn)) {
40f0780c:	00d70733          	add	a4,a4,a3
40f07810:	00070067          	jr	a4 # 10500000 <_fw_start-0x30a00000>
		break;
	case 3:
		new_csr_val = csr_val & ~rs1_val;
		break;
	case 5:
		new_csr_val = rs1_num;
40f07814:	00078b13          	mv	s6,a5
		break;
	default:
		return truly_illegal_insn(insn, hartid, mcause, regs, scratch);
	};

	if (do_write && sbi_emulate_csr_write(csr_num, hartid, regs,
40f07818:	000b0713          	mv	a4,s6
40f0781c:	000a8693          	mv	a3,s5
40f07820:	00048613          	mv	a2,s1
40f07824:	000c0593          	mv	a1,s8
40f07828:	000b8513          	mv	a0,s7
40f0782c:	4bc010ef          	jal	ra,40f08ce8 <sbi_emulate_csr_write>
40f07830:	08051a63          	bnez	a0,40f078c4 <system_opcode_insn+0x168>
40f07834:	fb842703          	lw	a4,-72(s0)
					      scratch, new_csr_val))
		return truly_illegal_insn(insn, hartid, mcause, regs, scratch);

	SET_RD(insn, regs, csr_val);
40f07838:	00595913          	srli	s2,s2,0x5
40f0783c:	07c97913          	andi	s2,s2,124
40f07840:	01248933          	add	s2,s1,s2
40f07844:	00e92023          	sw	a4,0(s2)

	regs->mepc += 4;
40f07848:	0814c683          	lbu	a3,129(s1)
40f0784c:	0804c603          	lbu	a2,128(s1)
40f07850:	0824c703          	lbu	a4,130(s1)
40f07854:	0834c783          	lbu	a5,131(s1)
40f07858:	00869693          	slli	a3,a3,0x8
40f0785c:	00c6e6b3          	or	a3,a3,a2
40f07860:	01071713          	slli	a4,a4,0x10
40f07864:	00d76733          	or	a4,a4,a3
40f07868:	01879793          	slli	a5,a5,0x18
40f0786c:	00e7e7b3          	or	a5,a5,a4
40f07870:	00478793          	addi	a5,a5,4
40f07874:	0087d613          	srli	a2,a5,0x8
40f07878:	0107d693          	srli	a3,a5,0x10
40f0787c:	0187d713          	srli	a4,a5,0x18
40f07880:	08f48023          	sb	a5,128(s1)
40f07884:	08c480a3          	sb	a2,129(s1)
40f07888:	08d48123          	sb	a3,130(s1)
40f0788c:	08e481a3          	sb	a4,131(s1)

	return 0;
}
40f07890:	04c12083          	lw	ra,76(sp)
40f07894:	04812403          	lw	s0,72(sp)
40f07898:	00098513          	mv	a0,s3
40f0789c:	04412483          	lw	s1,68(sp)
40f078a0:	04012903          	lw	s2,64(sp)
40f078a4:	03c12983          	lw	s3,60(sp)
40f078a8:	03812a03          	lw	s4,56(sp)
40f078ac:	03412a83          	lw	s5,52(sp)
40f078b0:	03012b03          	lw	s6,48(sp)
40f078b4:	02c12b83          	lw	s7,44(sp)
40f078b8:	02812c03          	lw	s8,40(sp)
40f078bc:	05010113          	addi	sp,sp,80
40f078c0:	00008067          	ret
	trap.epc = regs->mepc;
40f078c4:	0814c683          	lbu	a3,129(s1)
40f078c8:	0804c603          	lbu	a2,128(s1)
40f078cc:	0824c703          	lbu	a4,130(s1)
40f078d0:	0834c783          	lbu	a5,131(s1)
40f078d4:	00869693          	slli	a3,a3,0x8
40f078d8:	00c6e6b3          	or	a3,a3,a2
40f078dc:	01071713          	slli	a4,a4,0x10
40f078e0:	00d76733          	or	a4,a4,a3
40f078e4:	01879793          	slli	a5,a5,0x18
40f078e8:	00e7e7b3          	or	a5,a5,a4
	return sbi_trap_redirect(regs, &trap, scratch);
40f078ec:	000a8613          	mv	a2,s5
40f078f0:	fbc40593          	addi	a1,s0,-68
40f078f4:	00048513          	mv	a0,s1
	trap.epc = regs->mepc;
40f078f8:	faf42e23          	sw	a5,-68(s0)
	trap.cause = mcause;
40f078fc:	fd442023          	sw	s4,-64(s0)
	trap.tval = insn;
40f07900:	fd242223          	sw	s2,-60(s0)
	trap.tval2 = 0;
40f07904:	fc042423          	sw	zero,-56(s0)
	trap.tinst = 0;
40f07908:	fc042623          	sw	zero,-52(s0)
	return sbi_trap_redirect(regs, &trap, scratch);
40f0790c:	a98fb0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
40f07910:	00050993          	mv	s3,a0
		return truly_illegal_insn(insn, hartid, mcause, regs, scratch);
40f07914:	f7dff06f          	j	40f07890 <system_opcode_insn+0x134>
		new_csr_val = csr_val & ~rs1_num;
40f07918:	fb842703          	lw	a4,-72(s0)
40f0791c:	fff7cb13          	not	s6,a5
40f07920:	00eb7b33          	and	s6,s6,a4
	if (do_write && sbi_emulate_csr_write(csr_num, hartid, regs,
40f07924:	f0078ae3          	beqz	a5,40f07838 <system_opcode_insn+0xdc>
40f07928:	ef1ff06f          	j	40f07818 <system_opcode_insn+0xbc>
		new_csr_val = csr_val | rs1_val;
40f0792c:	fb842703          	lw	a4,-72(s0)
40f07930:	00eb6b33          	or	s6,s6,a4
	if (do_write && sbi_emulate_csr_write(csr_num, hartid, regs,
40f07934:	f00782e3          	beqz	a5,40f07838 <system_opcode_insn+0xdc>
40f07938:	ee1ff06f          	j	40f07818 <system_opcode_insn+0xbc>
		new_csr_val = csr_val | rs1_num;
40f0793c:	fb842703          	lw	a4,-72(s0)
40f07940:	00e7eb33          	or	s6,a5,a4
	if (do_write && sbi_emulate_csr_write(csr_num, hartid, regs,
40f07944:	ee078ae3          	beqz	a5,40f07838 <system_opcode_insn+0xdc>
40f07948:	ed1ff06f          	j	40f07818 <system_opcode_insn+0xbc>
		new_csr_val = csr_val & ~rs1_val;
40f0794c:	fb842703          	lw	a4,-72(s0)
40f07950:	fffb4b13          	not	s6,s6
40f07954:	00eb7b33          	and	s6,s6,a4
	if (do_write && sbi_emulate_csr_write(csr_num, hartid, regs,
40f07958:	ee0780e3          	beqz	a5,40f07838 <system_opcode_insn+0xdc>
40f0795c:	ebdff06f          	j	40f07818 <system_opcode_insn+0xbc>

40f07960 <sbi_illegal_insn_handler>:
};

int sbi_illegal_insn_handler(u32 hartid, ulong mcause, ulong insn,
			     struct sbi_trap_regs *regs,
			     struct sbi_scratch *scratch)
{
40f07960:	fa010113          	addi	sp,sp,-96
40f07964:	04812c23          	sw	s0,88(sp)
40f07968:	04912a23          	sw	s1,84(sp)
40f0796c:	05212823          	sw	s2,80(sp)
40f07970:	05312623          	sw	s3,76(sp)
40f07974:	04112e23          	sw	ra,92(sp)
40f07978:	06010413          	addi	s0,sp,96
40f0797c:	00060793          	mv	a5,a2
	struct sbi_trap_info uptrap;

	if (unlikely((insn & 3) != 3)) {
40f07980:	00367613          	andi	a2,a2,3
40f07984:	00300493          	li	s1,3
{
40f07988:	00050993          	mv	s3,a0
40f0798c:	00058913          	mv	s2,a1
	if (unlikely((insn & 3) != 3)) {
40f07990:	04961263          	bne	a2,s1,40f079d4 <sbi_illegal_insn_handler+0x74>
		if ((insn & 3) != 3)
			return truly_illegal_insn(insn, hartid, mcause, regs,
						  scratch);
	}

	return illegal_insn_table[(insn & 0x7c) >> 2](insn, hartid, mcause,
40f07994:	07c7f593          	andi	a1,a5,124
40f07998:	00003617          	auipc	a2,0x3
40f0799c:	ea460613          	addi	a2,a2,-348 # 40f0a83c <illegal_insn_table>
40f079a0:	00b60633          	add	a2,a2,a1
40f079a4:	00062803          	lw	a6,0(a2)
40f079a8:	00098593          	mv	a1,s3
40f079ac:	00090613          	mv	a2,s2
40f079b0:	00078513          	mv	a0,a5
40f079b4:	000800e7          	jalr	a6
						      regs, scratch);
}
40f079b8:	05c12083          	lw	ra,92(sp)
40f079bc:	05812403          	lw	s0,88(sp)
40f079c0:	05412483          	lw	s1,84(sp)
40f079c4:	05012903          	lw	s2,80(sp)
40f079c8:	04c12983          	lw	s3,76(sp)
40f079cc:	06010113          	addi	sp,sp,96
40f079d0:	00008067          	ret
		if (insn == 0) {
40f079d4:	0816c583          	lbu	a1,129(a3)
40f079d8:	0806c803          	lbu	a6,128(a3)
40f079dc:	0826c603          	lbu	a2,130(a3)
40f079e0:	0836c503          	lbu	a0,131(a3)
40f079e4:	00859593          	slli	a1,a1,0x8
40f079e8:	0105e5b3          	or	a1,a1,a6
40f079ec:	01061613          	slli	a2,a2,0x10
40f079f0:	00b66633          	or	a2,a2,a1
40f079f4:	01851513          	slli	a0,a0,0x18
40f079f8:	00c56833          	or	a6,a0,a2
40f079fc:	02078663          	beqz	a5,40f07a28 <sbi_illegal_insn_handler+0xc8>
	return sbi_trap_redirect(regs, &trap, scratch);
40f07a00:	00070613          	mv	a2,a4
40f07a04:	fcc40593          	addi	a1,s0,-52
40f07a08:	00068513          	mv	a0,a3
	trap.epc = regs->mepc;
40f07a0c:	fd042623          	sw	a6,-52(s0)
	trap.cause = mcause;
40f07a10:	fd242823          	sw	s2,-48(s0)
	trap.tval = insn;
40f07a14:	fcf42a23          	sw	a5,-44(s0)
	trap.tval2 = 0;
40f07a18:	fc042c23          	sw	zero,-40(s0)
	trap.tinst = 0;
40f07a1c:	fc042e23          	sw	zero,-36(s0)
	return sbi_trap_redirect(regs, &trap, scratch);
40f07a20:	984fb0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
			return truly_illegal_insn(insn, hartid, mcause, regs,
40f07a24:	f95ff06f          	j	40f079b8 <sbi_illegal_insn_handler+0x58>
			insn = sbi_get_insn(regs->mepc, scratch, &uptrap);
40f07a28:	fb840613          	addi	a2,s0,-72
40f07a2c:	00070593          	mv	a1,a4
40f07a30:	00080513          	mv	a0,a6
40f07a34:	fad42423          	sw	a3,-88(s0)
40f07a38:	fae42623          	sw	a4,-84(s0)
40f07a3c:	345000ef          	jal	ra,40f08580 <sbi_get_insn>
			if (uptrap.cause) {
40f07a40:	fbc42603          	lw	a2,-68(s0)
			insn = sbi_get_insn(regs->mepc, scratch, &uptrap);
40f07a44:	00050793          	mv	a5,a0
			if (uptrap.cause) {
40f07a48:	fac42703          	lw	a4,-84(s0)
40f07a4c:	fa842683          	lw	a3,-88(s0)
40f07a50:	02061c63          	bnez	a2,40f07a88 <sbi_illegal_insn_handler+0x128>
		if ((insn & 3) != 3)
40f07a54:	00357613          	andi	a2,a0,3
40f07a58:	f2960ee3          	beq	a2,s1,40f07994 <sbi_illegal_insn_handler+0x34>
40f07a5c:	0816c803          	lbu	a6,129(a3)
40f07a60:	0806c583          	lbu	a1,128(a3)
40f07a64:	0826c503          	lbu	a0,130(a3)
40f07a68:	0836c603          	lbu	a2,131(a3)
40f07a6c:	00881813          	slli	a6,a6,0x8
40f07a70:	00b86833          	or	a6,a6,a1
40f07a74:	01051513          	slli	a0,a0,0x10
40f07a78:	01056533          	or	a0,a0,a6
40f07a7c:	01861613          	slli	a2,a2,0x18
40f07a80:	00a66833          	or	a6,a2,a0
40f07a84:	f7dff06f          	j	40f07a00 <sbi_illegal_insn_handler+0xa0>
				uptrap.epc = regs->mepc;
40f07a88:	0816c583          	lbu	a1,129(a3)
40f07a8c:	0806c503          	lbu	a0,128(a3)
40f07a90:	0826c603          	lbu	a2,130(a3)
40f07a94:	0836c783          	lbu	a5,131(a3)
40f07a98:	00859593          	slli	a1,a1,0x8
40f07a9c:	00a5e5b3          	or	a1,a1,a0
40f07aa0:	01061613          	slli	a2,a2,0x10
40f07aa4:	00b66633          	or	a2,a2,a1
40f07aa8:	01879793          	slli	a5,a5,0x18
40f07aac:	00c7e7b3          	or	a5,a5,a2
				return sbi_trap_redirect(regs, &uptrap,
40f07ab0:	fb840593          	addi	a1,s0,-72
40f07ab4:	00070613          	mv	a2,a4
40f07ab8:	00068513          	mv	a0,a3
				uptrap.epc = regs->mepc;
40f07abc:	faf42c23          	sw	a5,-72(s0)
				return sbi_trap_redirect(regs, &uptrap,
40f07ac0:	8e4fb0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
40f07ac4:	ef5ff06f          	j	40f079b8 <sbi_illegal_insn_handler+0x58>

40f07ac8 <sbi_misaligned_load_handler>:

int sbi_misaligned_load_handler(u32 hartid, ulong mcause,
				ulong addr, ulong tval2, ulong tinst,
				struct sbi_trap_regs *regs,
				struct sbi_scratch *scratch)
{
40f07ac8:	fa010113          	addi	sp,sp,-96
40f07acc:	04812c23          	sw	s0,88(sp)
40f07ad0:	04912a23          	sw	s1,84(sp)
40f07ad4:	05212823          	sw	s2,80(sp)
40f07ad8:	05512223          	sw	s5,68(sp)
40f07adc:	05612023          	sw	s6,64(sp)
40f07ae0:	04112e23          	sw	ra,92(sp)
40f07ae4:	05312623          	sw	s3,76(sp)
40f07ae8:	05412423          	sw	s4,72(sp)
40f07aec:	03712e23          	sw	s7,60(sp)
40f07af0:	03812c23          	sw	s8,56(sp)
40f07af4:	06010413          	addi	s0,sp,96
	ulong insn;
	union reg_data val;
	struct sbi_trap_info uptrap;
	int i, fp = 0, shift = 0, len = 0;

	if (tinst & 0x1) {
40f07af8:	00177513          	andi	a0,a4,1
{
40f07afc:	00058493          	mv	s1,a1
40f07b00:	00060913          	mv	s2,a2
40f07b04:	00078b13          	mv	s6,a5
40f07b08:	00080a93          	mv	s5,a6
	if (tinst & 0x1) {
40f07b0c:	14050263          	beqz	a0,40f07c50 <sbi_misaligned_load_handler+0x188>
		/*
		 * Bit[0] == 1 implies trapped instruction value is
		 * transformed instruction or custom instruction.
		 */
		insn = tinst | INSN_16BIT_MASK;
40f07b10:	00376b93          	ori	s7,a4,3
40f07b14:	fbc40a13          	addi	s4,s0,-68
			uptrap.epc = regs->mepc;
			return sbi_trap_redirect(regs, &uptrap, scratch);
		}
	}

	if ((insn & INSN_MASK_LW) == INSN_MATCH_LW) {
40f07b18:	000077b7          	lui	a5,0x7
40f07b1c:	07f78793          	addi	a5,a5,127 # 707f <_fw_start-0x40ef8f81>
40f07b20:	00002637          	lui	a2,0x2
40f07b24:	00fbf7b3          	and	a5,s7,a5
40f07b28:	00360613          	addi	a2,a2,3 # 2003 <_fw_start-0x40efdffd>
40f07b2c:	1ac78c63          	beq	a5,a2,40f07ce4 <sbi_misaligned_load_handler+0x21c>
		len = 8;
	} else if ((insn & INSN_MASK_FLW) == INSN_MATCH_FLW) {
		fp  = 1;
		len = 4;
#endif
	} else if ((insn & INSN_MASK_LH) == INSN_MATCH_LH) {
40f07b30:	00001637          	lui	a2,0x1
40f07b34:	00360613          	addi	a2,a2,3 # 1003 <_fw_start-0x40efeffd>
40f07b38:	10c78663          	beq	a5,a2,40f07c44 <sbi_misaligned_load_handler+0x17c>
		len   = 2;
		shift = 8 * (sizeof(ulong) - len);
	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
40f07b3c:	00005637          	lui	a2,0x5
40f07b40:	00360613          	addi	a2,a2,3 # 5003 <_fw_start-0x40efaffd>
		len = 2;
40f07b44:	00200993          	li	s3,2
	int i, fp = 0, shift = 0, len = 0;
40f07b48:	00000c13          	li	s8,0
	} else if ((insn & INSN_MASK_LHU) == INSN_MATCH_LHU) {
40f07b4c:	1ac79263          	bne	a5,a2,40f07cf0 <sbi_misaligned_load_handler+0x228>
		uptrap.tval2 = tval2;
		uptrap.tinst = tinst;
		return sbi_trap_redirect(regs, &uptrap, scratch);
	}

	val.data_u64 = 0;
40f07b50:	00000793          	li	a5,0
40f07b54:	00000813          	li	a6,0
40f07b58:	faf42823          	sw	a5,-80(s0)
40f07b5c:	fb042a23          	sw	a6,-76(s0)
	for (i = 0; i < len; i++) {
40f07b60:	012989b3          	add	s3,s3,s2
	val.data_u64 = 0;
40f07b64:	00090493          	mv	s1,s2
		val.data_bytes[i] = sbi_load_u8((void *)(addr + i),
40f07b68:	00048513          	mv	a0,s1
40f07b6c:	000a0613          	mv	a2,s4
40f07b70:	000a8593          	mv	a1,s5
40f07b74:	3fc000ef          	jal	ra,40f07f70 <sbi_load_u8>
40f07b78:	412487b3          	sub	a5,s1,s2
40f07b7c:	fb040693          	addi	a3,s0,-80
						scratch, &uptrap);
		if (uptrap.cause) {
40f07b80:	fc042703          	lw	a4,-64(s0)
		val.data_bytes[i] = sbi_load_u8((void *)(addr + i),
40f07b84:	00f687b3          	add	a5,a3,a5
40f07b88:	00a78023          	sb	a0,0(a5)
		if (uptrap.cause) {
40f07b8c:	00148493          	addi	s1,s1,1
40f07b90:	10071a63          	bnez	a4,40f07ca4 <sbi_misaligned_load_handler+0x1dc>
	for (i = 0; i < len; i++) {
40f07b94:	fd349ae3          	bne	s1,s3,40f07b68 <sbi_misaligned_load_handler+0xa0>
			return sbi_trap_redirect(regs, &uptrap, scratch);
		}
	}

	if (!fp)
		SET_RD(insn, regs, val.data_ulong << shift >> shift);
40f07b98:	fb042703          	lw	a4,-80(s0)
40f07b9c:	005bd793          	srli	a5,s7,0x5
40f07ba0:	07c7f793          	andi	a5,a5,124
40f07ba4:	01871733          	sll	a4,a4,s8
40f07ba8:	00fb07b3          	add	a5,s6,a5
40f07bac:	01875c33          	srl	s8,a4,s8
40f07bb0:	0187a023          	sw	s8,0(a5)
		SET_F64_RD(insn, regs, val.data_u64);
	else
		SET_F32_RD(insn, regs, val.data_ulong);
#endif

	regs->mepc += INSN_LEN(insn);
40f07bb4:	081b4683          	lbu	a3,129(s6)
40f07bb8:	080b4603          	lbu	a2,128(s6)
40f07bbc:	082b4703          	lbu	a4,130(s6)
40f07bc0:	083b4783          	lbu	a5,131(s6)
40f07bc4:	00869693          	slli	a3,a3,0x8
40f07bc8:	00c6e6b3          	or	a3,a3,a2
40f07bcc:	01071713          	slli	a4,a4,0x10
40f07bd0:	00d76733          	or	a4,a4,a3
40f07bd4:	01879793          	slli	a5,a5,0x18
40f07bd8:	003bfb93          	andi	s7,s7,3
40f07bdc:	00300693          	li	a3,3
40f07be0:	00e7e7b3          	or	a5,a5,a4
40f07be4:	00200713          	li	a4,2
40f07be8:	00db9463          	bne	s7,a3,40f07bf0 <sbi_misaligned_load_handler+0x128>
40f07bec:	00400713          	li	a4,4
40f07bf0:	00e787b3          	add	a5,a5,a4
40f07bf4:	0087d613          	srli	a2,a5,0x8
40f07bf8:	0107d693          	srli	a3,a5,0x10
40f07bfc:	0187d713          	srli	a4,a5,0x18
40f07c00:	08fb0023          	sb	a5,128(s6)
40f07c04:	08cb00a3          	sb	a2,129(s6)
40f07c08:	08db0123          	sb	a3,130(s6)
40f07c0c:	08eb01a3          	sb	a4,131(s6)

	return 0;
40f07c10:	00000513          	li	a0,0
}
40f07c14:	05c12083          	lw	ra,92(sp)
40f07c18:	05812403          	lw	s0,88(sp)
40f07c1c:	05412483          	lw	s1,84(sp)
40f07c20:	05012903          	lw	s2,80(sp)
40f07c24:	04c12983          	lw	s3,76(sp)
40f07c28:	04812a03          	lw	s4,72(sp)
40f07c2c:	04412a83          	lw	s5,68(sp)
40f07c30:	04012b03          	lw	s6,64(sp)
40f07c34:	03c12b83          	lw	s7,60(sp)
40f07c38:	03812c03          	lw	s8,56(sp)
40f07c3c:	06010113          	addi	sp,sp,96
40f07c40:	00008067          	ret
		len   = 2;
40f07c44:	00200993          	li	s3,2
		shift = 8 * (sizeof(ulong) - len);
40f07c48:	01000c13          	li	s8,16
40f07c4c:	f05ff06f          	j	40f07b50 <sbi_misaligned_load_handler+0x88>
		insn = sbi_get_insn(regs->mepc, scratch, &uptrap);
40f07c50:	fae42423          	sw	a4,-88(s0)
40f07c54:	fad42623          	sw	a3,-84(s0)
40f07c58:	0817c503          	lbu	a0,129(a5)
40f07c5c:	0807c583          	lbu	a1,128(a5)
40f07c60:	0827c783          	lbu	a5,130(a5)
40f07c64:	083b4603          	lbu	a2,131(s6)
40f07c68:	00851513          	slli	a0,a0,0x8
40f07c6c:	00b56533          	or	a0,a0,a1
40f07c70:	01079793          	slli	a5,a5,0x10
40f07c74:	00a7e7b3          	or	a5,a5,a0
40f07c78:	fbc40a13          	addi	s4,s0,-68
40f07c7c:	01861513          	slli	a0,a2,0x18
40f07c80:	00f56533          	or	a0,a0,a5
40f07c84:	000a0613          	mv	a2,s4
40f07c88:	00080593          	mv	a1,a6
40f07c8c:	0f5000ef          	jal	ra,40f08580 <sbi_get_insn>
		if (uptrap.cause) {
40f07c90:	fc042783          	lw	a5,-64(s0)
		insn = sbi_get_insn(regs->mepc, scratch, &uptrap);
40f07c94:	00050b93          	mv	s7,a0
		if (uptrap.cause) {
40f07c98:	fac42683          	lw	a3,-84(s0)
40f07c9c:	fa842703          	lw	a4,-88(s0)
40f07ca0:	e6078ce3          	beqz	a5,40f07b18 <sbi_misaligned_load_handler+0x50>
			uptrap.epc = regs->mepc;
40f07ca4:	081b4683          	lbu	a3,129(s6)
40f07ca8:	080b4603          	lbu	a2,128(s6)
40f07cac:	082b4703          	lbu	a4,130(s6)
40f07cb0:	083b4783          	lbu	a5,131(s6)
40f07cb4:	00869693          	slli	a3,a3,0x8
40f07cb8:	00c6e6b3          	or	a3,a3,a2
40f07cbc:	01071713          	slli	a4,a4,0x10
40f07cc0:	00d76733          	or	a4,a4,a3
40f07cc4:	01879793          	slli	a5,a5,0x18
40f07cc8:	00e7e7b3          	or	a5,a5,a4
			return sbi_trap_redirect(regs, &uptrap, scratch);
40f07ccc:	000a8613          	mv	a2,s5
40f07cd0:	000a0593          	mv	a1,s4
40f07cd4:	000b0513          	mv	a0,s6
			uptrap.epc = regs->mepc;
40f07cd8:	faf42e23          	sw	a5,-68(s0)
			return sbi_trap_redirect(regs, &uptrap, scratch);
40f07cdc:	ec9fa0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
40f07ce0:	f35ff06f          	j	40f07c14 <sbi_misaligned_load_handler+0x14c>
		len   = 4;
40f07ce4:	00400993          	li	s3,4
		shift = 8 * (sizeof(ulong) - len);
40f07ce8:	00000c13          	li	s8,0
40f07cec:	e65ff06f          	j	40f07b50 <sbi_misaligned_load_handler+0x88>
		uptrap.epc = regs->mepc;
40f07cf0:	081b4583          	lbu	a1,129(s6)
40f07cf4:	080b4503          	lbu	a0,128(s6)
40f07cf8:	082b4603          	lbu	a2,130(s6)
40f07cfc:	083b4783          	lbu	a5,131(s6)
40f07d00:	00859593          	slli	a1,a1,0x8
40f07d04:	00a5e5b3          	or	a1,a1,a0
40f07d08:	01061613          	slli	a2,a2,0x10
40f07d0c:	00b66633          	or	a2,a2,a1
40f07d10:	01879793          	slli	a5,a5,0x18
40f07d14:	00c7e7b3          	or	a5,a5,a2
		return sbi_trap_redirect(regs, &uptrap, scratch);
40f07d18:	000a0593          	mv	a1,s4
40f07d1c:	000a8613          	mv	a2,s5
40f07d20:	000b0513          	mv	a0,s6
		uptrap.epc = regs->mepc;
40f07d24:	faf42e23          	sw	a5,-68(s0)
		uptrap.cause = mcause;
40f07d28:	fc942023          	sw	s1,-64(s0)
		uptrap.tval = addr;
40f07d2c:	fd242223          	sw	s2,-60(s0)
		uptrap.tval2 = tval2;
40f07d30:	fcd42423          	sw	a3,-56(s0)
		uptrap.tinst = tinst;
40f07d34:	fce42623          	sw	a4,-52(s0)
		return sbi_trap_redirect(regs, &uptrap, scratch);
40f07d38:	e6dfa0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
40f07d3c:	ed9ff06f          	j	40f07c14 <sbi_misaligned_load_handler+0x14c>

40f07d40 <sbi_misaligned_store_handler>:

int sbi_misaligned_store_handler(u32 hartid, ulong mcause,
				 ulong addr, ulong tval2, ulong tinst,
				 struct sbi_trap_regs *regs,
				 struct sbi_scratch *scratch)
{
40f07d40:	fa010113          	addi	sp,sp,-96
40f07d44:	04812c23          	sw	s0,88(sp)
40f07d48:	04912a23          	sw	s1,84(sp)
40f07d4c:	05212823          	sw	s2,80(sp)
40f07d50:	05312623          	sw	s3,76(sp)
40f07d54:	05612023          	sw	s6,64(sp)
40f07d58:	04112e23          	sw	ra,92(sp)
40f07d5c:	05412423          	sw	s4,72(sp)
40f07d60:	05512223          	sw	s5,68(sp)
40f07d64:	03712e23          	sw	s7,60(sp)
40f07d68:	06010413          	addi	s0,sp,96
	ulong insn;
	union reg_data val;
	struct sbi_trap_info uptrap;
	int i, len = 0;

	if (tinst & 0x1) {
40f07d6c:	00177513          	andi	a0,a4,1
{
40f07d70:	00058493          	mv	s1,a1
40f07d74:	00060993          	mv	s3,a2
40f07d78:	00078913          	mv	s2,a5
40f07d7c:	00080b13          	mv	s6,a6
	if (tinst & 0x1) {
40f07d80:	14050a63          	beqz	a0,40f07ed4 <sbi_misaligned_store_handler+0x194>
		/*
		 * Bit[0] == 1 implies trapped instruction value is
		 * transformed instruction or custom instruction.
		 */
		insn = tinst | INSN_16BIT_MASK;
40f07d84:	00376b93          	ori	s7,a4,3
40f07d88:	fbc40a93          	addi	s5,s0,-68
			uptrap.epc = regs->mepc;
			return sbi_trap_redirect(regs, &uptrap, scratch);
		}
	}

	val.data_ulong = GET_RS2(insn, regs);
40f07d8c:	012bd793          	srli	a5,s7,0x12
40f07d90:	07c7f793          	andi	a5,a5,124
40f07d94:	00f907b3          	add	a5,s2,a5
40f07d98:	0007a783          	lw	a5,0(a5)

	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
40f07d9c:	00002637          	lui	a2,0x2
40f07da0:	02360613          	addi	a2,a2,35 # 2023 <_fw_start-0x40efdfdd>
	val.data_ulong = GET_RS2(insn, regs);
40f07da4:	faf42823          	sw	a5,-80(s0)
	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
40f07da8:	000077b7          	lui	a5,0x7
40f07dac:	07f78793          	addi	a5,a5,127 # 707f <_fw_start-0x40ef8f81>
40f07db0:	00fbf7b3          	and	a5,s7,a5
40f07db4:	1ac78a63          	beq	a5,a2,40f07f68 <sbi_misaligned_store_handler+0x228>
		val.data_u64 = GET_F64_RS2(insn, regs);
	} else if ((insn & INSN_MASK_FSW) == INSN_MATCH_FSW) {
		len	       = 4;
		val.data_ulong = GET_F32_RS2(insn, regs);
#endif
	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
40f07db8:	00001637          	lui	a2,0x1
40f07dbc:	02360613          	addi	a2,a2,35 # 1023 <_fw_start-0x40efefdd>
		len = 2;
40f07dc0:	00200a13          	li	s4,2
	} else if ((insn & INSN_MASK_SH) == INSN_MATCH_SH) {
40f07dc4:	08c79c63          	bne	a5,a2,40f07e5c <sbi_misaligned_store_handler+0x11c>
		len = 2;
40f07dc8:	fb040493          	addi	s1,s0,-80
40f07dcc:	009a0a33          	add	s4,s4,s1
40f07dd0:	409989b3          	sub	s3,s3,s1
		uptrap.tinst = tinst;
		return sbi_trap_redirect(regs, &uptrap, scratch);
	}

	for (i = 0; i < len; i++) {
		sbi_store_u8((void *)(addr + i), val.data_bytes[i],
40f07dd4:	0004c583          	lbu	a1,0(s1)
40f07dd8:	00998533          	add	a0,s3,s1
40f07ddc:	000a8693          	mv	a3,s5
40f07de0:	000b0613          	mv	a2,s6
40f07de4:	408000ef          	jal	ra,40f081ec <sbi_store_u8>
			     scratch, &uptrap);
		if (uptrap.cause) {
40f07de8:	fc042783          	lw	a5,-64(s0)
40f07dec:	00148493          	addi	s1,s1,1
40f07df0:	12079c63          	bnez	a5,40f07f28 <sbi_misaligned_store_handler+0x1e8>
	for (i = 0; i < len; i++) {
40f07df4:	fe9a10e3          	bne	s4,s1,40f07dd4 <sbi_misaligned_store_handler+0x94>
			uptrap.epc = regs->mepc;
			return sbi_trap_redirect(regs, &uptrap, scratch);
		}
	}

	regs->mepc += INSN_LEN(insn);
40f07df8:	08194683          	lbu	a3,129(s2)
40f07dfc:	08094603          	lbu	a2,128(s2)
40f07e00:	08294703          	lbu	a4,130(s2)
40f07e04:	08394783          	lbu	a5,131(s2)
40f07e08:	00869693          	slli	a3,a3,0x8
40f07e0c:	00c6e6b3          	or	a3,a3,a2
40f07e10:	01071713          	slli	a4,a4,0x10
40f07e14:	00d76733          	or	a4,a4,a3
40f07e18:	01879793          	slli	a5,a5,0x18
40f07e1c:	003bfb93          	andi	s7,s7,3
40f07e20:	00300693          	li	a3,3
40f07e24:	00e7e7b3          	or	a5,a5,a4
40f07e28:	00200713          	li	a4,2
40f07e2c:	00db9463          	bne	s7,a3,40f07e34 <sbi_misaligned_store_handler+0xf4>
40f07e30:	00400713          	li	a4,4
40f07e34:	00e787b3          	add	a5,a5,a4
40f07e38:	0087d613          	srli	a2,a5,0x8
40f07e3c:	0107d693          	srli	a3,a5,0x10
40f07e40:	0187d713          	srli	a4,a5,0x18
40f07e44:	08f90023          	sb	a5,128(s2)
40f07e48:	08c900a3          	sb	a2,129(s2)
40f07e4c:	08d90123          	sb	a3,130(s2)
40f07e50:	08e901a3          	sb	a4,131(s2)

	return 0;
40f07e54:	00000513          	li	a0,0
40f07e58:	0500006f          	j	40f07ea8 <sbi_misaligned_store_handler+0x168>
		uptrap.epc = regs->mepc;
40f07e5c:	08194583          	lbu	a1,129(s2)
40f07e60:	08094503          	lbu	a0,128(s2)
40f07e64:	08294603          	lbu	a2,130(s2)
40f07e68:	08394783          	lbu	a5,131(s2)
40f07e6c:	00859593          	slli	a1,a1,0x8
40f07e70:	00a5e5b3          	or	a1,a1,a0
40f07e74:	01061613          	slli	a2,a2,0x10
40f07e78:	00b66633          	or	a2,a2,a1
40f07e7c:	01879793          	slli	a5,a5,0x18
40f07e80:	00c7e7b3          	or	a5,a5,a2
		return sbi_trap_redirect(regs, &uptrap, scratch);
40f07e84:	000a8593          	mv	a1,s5
40f07e88:	000b0613          	mv	a2,s6
40f07e8c:	00090513          	mv	a0,s2
		uptrap.epc = regs->mepc;
40f07e90:	faf42e23          	sw	a5,-68(s0)
		uptrap.cause = mcause;
40f07e94:	fc942023          	sw	s1,-64(s0)
		uptrap.tval = addr;
40f07e98:	fd342223          	sw	s3,-60(s0)
		uptrap.tval2 = tval2;
40f07e9c:	fcd42423          	sw	a3,-56(s0)
		uptrap.tinst = tinst;
40f07ea0:	fce42623          	sw	a4,-52(s0)
		return sbi_trap_redirect(regs, &uptrap, scratch);
40f07ea4:	d01fa0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
}
40f07ea8:	05c12083          	lw	ra,92(sp)
40f07eac:	05812403          	lw	s0,88(sp)
40f07eb0:	05412483          	lw	s1,84(sp)
40f07eb4:	05012903          	lw	s2,80(sp)
40f07eb8:	04c12983          	lw	s3,76(sp)
40f07ebc:	04812a03          	lw	s4,72(sp)
40f07ec0:	04412a83          	lw	s5,68(sp)
40f07ec4:	04012b03          	lw	s6,64(sp)
40f07ec8:	03c12b83          	lw	s7,60(sp)
40f07ecc:	06010113          	addi	sp,sp,96
40f07ed0:	00008067          	ret
		insn = sbi_get_insn(regs->mepc, scratch, &uptrap);
40f07ed4:	fae42423          	sw	a4,-88(s0)
40f07ed8:	fad42623          	sw	a3,-84(s0)
40f07edc:	0817c503          	lbu	a0,129(a5)
40f07ee0:	0807c583          	lbu	a1,128(a5)
40f07ee4:	0827c783          	lbu	a5,130(a5)
40f07ee8:	08394603          	lbu	a2,131(s2)
40f07eec:	00851513          	slli	a0,a0,0x8
40f07ef0:	00b56533          	or	a0,a0,a1
40f07ef4:	01079793          	slli	a5,a5,0x10
40f07ef8:	00a7e7b3          	or	a5,a5,a0
40f07efc:	fbc40a93          	addi	s5,s0,-68
40f07f00:	01861513          	slli	a0,a2,0x18
40f07f04:	00f56533          	or	a0,a0,a5
40f07f08:	000a8613          	mv	a2,s5
40f07f0c:	00080593          	mv	a1,a6
40f07f10:	670000ef          	jal	ra,40f08580 <sbi_get_insn>
		if (uptrap.cause) {
40f07f14:	fc042783          	lw	a5,-64(s0)
		insn = sbi_get_insn(regs->mepc, scratch, &uptrap);
40f07f18:	00050b93          	mv	s7,a0
		if (uptrap.cause) {
40f07f1c:	fac42683          	lw	a3,-84(s0)
40f07f20:	fa842703          	lw	a4,-88(s0)
40f07f24:	e60784e3          	beqz	a5,40f07d8c <sbi_misaligned_store_handler+0x4c>
			uptrap.epc = regs->mepc;
40f07f28:	08194683          	lbu	a3,129(s2)
40f07f2c:	08094603          	lbu	a2,128(s2)
40f07f30:	08294703          	lbu	a4,130(s2)
40f07f34:	08394783          	lbu	a5,131(s2)
40f07f38:	00869693          	slli	a3,a3,0x8
40f07f3c:	00c6e6b3          	or	a3,a3,a2
40f07f40:	01071713          	slli	a4,a4,0x10
40f07f44:	00d76733          	or	a4,a4,a3
40f07f48:	01879793          	slli	a5,a5,0x18
40f07f4c:	00e7e7b3          	or	a5,a5,a4
			return sbi_trap_redirect(regs, &uptrap, scratch);
40f07f50:	000b0613          	mv	a2,s6
40f07f54:	000a8593          	mv	a1,s5
40f07f58:	00090513          	mv	a0,s2
			uptrap.epc = regs->mepc;
40f07f5c:	faf42e23          	sw	a5,-68(s0)
			return sbi_trap_redirect(regs, &uptrap, scratch);
40f07f60:	c45fa0ef          	jal	ra,40f02ba4 <sbi_trap_redirect>
40f07f64:	f45ff06f          	j	40f07ea8 <sbi_misaligned_store_handler+0x168>
		len = 4;
40f07f68:	00400a13          	li	s4,4
40f07f6c:	e5dff06f          	j	40f07dc8 <sbi_misaligned_store_handler+0x88>

40f07f70 <sbi_load_u8>:
			: "+&r"(__mstatus)                                    \
			: "r"(val), "m"(*addr), "r"(MSTATUS_MPRV));           \
		sbi_hart_set_trap_info(scratch, NULL);                        \
	}

DEFINE_UNPRIVILEGED_LOAD_FUNCTION(u8, lbu)
40f07f70:	ff010113          	addi	sp,sp,-16
40f07f74:	00812423          	sw	s0,8(sp)
40f07f78:	00912223          	sw	s1,4(sp)
40f07f7c:	01212023          	sw	s2,0(sp)
40f07f80:	00112623          	sw	ra,12(sp)
40f07f84:	01010413          	addi	s0,sp,16
40f07f88:	00058913          	mv	s2,a1
40f07f8c:	00050493          	mv	s1,a0
40f07f90:	00062023          	sw	zero,0(a2)
40f07f94:	00062223          	sw	zero,4(a2)
40f07f98:	00062423          	sw	zero,8(a2)
40f07f9c:	00062623          	sw	zero,12(a2)
40f07fa0:	00062823          	sw	zero,16(a2)
40f07fa4:	00060593          	mv	a1,a2
40f07fa8:	00090513          	mv	a0,s2
40f07fac:	978ff0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f07fb0:	000207b7          	lui	a5,0x20
40f07fb4:	3007a673          	csrrs	a2,mstatus,a5
40f07fb8:	0004c703          	lbu	a4,0(s1)
40f07fbc:	30061073          	csrw	mstatus,a2
40f07fc0:	00000593          	li	a1,0
40f07fc4:	00090513          	mv	a0,s2
40f07fc8:	0ff77493          	andi	s1,a4,255
40f07fcc:	958ff0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f07fd0:	00c12083          	lw	ra,12(sp)
40f07fd4:	00812403          	lw	s0,8(sp)
40f07fd8:	00048513          	mv	a0,s1
40f07fdc:	00012903          	lw	s2,0(sp)
40f07fe0:	00412483          	lw	s1,4(sp)
40f07fe4:	01010113          	addi	sp,sp,16
40f07fe8:	00008067          	ret

40f07fec <sbi_load_u16>:
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(u16, lhu)
40f07fec:	ff010113          	addi	sp,sp,-16
40f07ff0:	00812423          	sw	s0,8(sp)
40f07ff4:	00912223          	sw	s1,4(sp)
40f07ff8:	01212023          	sw	s2,0(sp)
40f07ffc:	00112623          	sw	ra,12(sp)
40f08000:	01010413          	addi	s0,sp,16
40f08004:	00058913          	mv	s2,a1
40f08008:	00050493          	mv	s1,a0
40f0800c:	00062023          	sw	zero,0(a2)
40f08010:	00062223          	sw	zero,4(a2)
40f08014:	00062423          	sw	zero,8(a2)
40f08018:	00062623          	sw	zero,12(a2)
40f0801c:	00062823          	sw	zero,16(a2)
40f08020:	00060593          	mv	a1,a2
40f08024:	00090513          	mv	a0,s2
40f08028:	8fcff0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f0802c:	000207b7          	lui	a5,0x20
40f08030:	3007a673          	csrrs	a2,mstatus,a5
40f08034:	0004d703          	lhu	a4,0(s1)
40f08038:	30061073          	csrw	mstatus,a2
40f0803c:	00000593          	li	a1,0
40f08040:	00090513          	mv	a0,s2
40f08044:	00070493          	mv	s1,a4
40f08048:	8dcff0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f0804c:	00c12083          	lw	ra,12(sp)
40f08050:	00812403          	lw	s0,8(sp)
40f08054:	01049493          	slli	s1,s1,0x10
40f08058:	0104d493          	srli	s1,s1,0x10
40f0805c:	00048513          	mv	a0,s1
40f08060:	00012903          	lw	s2,0(sp)
40f08064:	00412483          	lw	s1,4(sp)
40f08068:	01010113          	addi	sp,sp,16
40f0806c:	00008067          	ret

40f08070 <sbi_load_s8>:
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(s8, lb)
40f08070:	ff010113          	addi	sp,sp,-16
40f08074:	00812423          	sw	s0,8(sp)
40f08078:	00912223          	sw	s1,4(sp)
40f0807c:	01212023          	sw	s2,0(sp)
40f08080:	00112623          	sw	ra,12(sp)
40f08084:	01010413          	addi	s0,sp,16
40f08088:	00058913          	mv	s2,a1
40f0808c:	00050493          	mv	s1,a0
40f08090:	00062023          	sw	zero,0(a2)
40f08094:	00062223          	sw	zero,4(a2)
40f08098:	00062423          	sw	zero,8(a2)
40f0809c:	00062623          	sw	zero,12(a2)
40f080a0:	00062823          	sw	zero,16(a2)
40f080a4:	00060593          	mv	a1,a2
40f080a8:	00090513          	mv	a0,s2
40f080ac:	878ff0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f080b0:	000207b7          	lui	a5,0x20
40f080b4:	3007a673          	csrrs	a2,mstatus,a5
40f080b8:	00048703          	lb	a4,0(s1)
40f080bc:	30061073          	csrw	mstatus,a2
40f080c0:	00000593          	li	a1,0
40f080c4:	00090513          	mv	a0,s2
40f080c8:	0ff77493          	andi	s1,a4,255
40f080cc:	858ff0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f080d0:	00c12083          	lw	ra,12(sp)
40f080d4:	00812403          	lw	s0,8(sp)
40f080d8:	00048513          	mv	a0,s1
40f080dc:	00012903          	lw	s2,0(sp)
40f080e0:	00412483          	lw	s1,4(sp)
40f080e4:	01010113          	addi	sp,sp,16
40f080e8:	00008067          	ret

40f080ec <sbi_load_s16>:
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(s16, lh)
40f080ec:	ff010113          	addi	sp,sp,-16
40f080f0:	00812423          	sw	s0,8(sp)
40f080f4:	00912223          	sw	s1,4(sp)
40f080f8:	01212023          	sw	s2,0(sp)
40f080fc:	00112623          	sw	ra,12(sp)
40f08100:	01010413          	addi	s0,sp,16
40f08104:	00058913          	mv	s2,a1
40f08108:	00050493          	mv	s1,a0
40f0810c:	00062023          	sw	zero,0(a2)
40f08110:	00062223          	sw	zero,4(a2)
40f08114:	00062423          	sw	zero,8(a2)
40f08118:	00062623          	sw	zero,12(a2)
40f0811c:	00062823          	sw	zero,16(a2)
40f08120:	00060593          	mv	a1,a2
40f08124:	00090513          	mv	a0,s2
40f08128:	ffdfe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f0812c:	000207b7          	lui	a5,0x20
40f08130:	3007a673          	csrrs	a2,mstatus,a5
40f08134:	00049703          	lh	a4,0(s1)
40f08138:	30061073          	csrw	mstatus,a2
40f0813c:	00000593          	li	a1,0
40f08140:	00090513          	mv	a0,s2
40f08144:	00070493          	mv	s1,a4
40f08148:	fddfe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f0814c:	00c12083          	lw	ra,12(sp)
40f08150:	00812403          	lw	s0,8(sp)
40f08154:	01049493          	slli	s1,s1,0x10
40f08158:	4104d493          	srai	s1,s1,0x10
40f0815c:	00048513          	mv	a0,s1
40f08160:	00012903          	lw	s2,0(sp)
40f08164:	00412483          	lw	s1,4(sp)
40f08168:	01010113          	addi	sp,sp,16
40f0816c:	00008067          	ret

40f08170 <sbi_load_s32>:
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(s32, lw)
40f08170:	ff010113          	addi	sp,sp,-16
40f08174:	00812423          	sw	s0,8(sp)
40f08178:	00912223          	sw	s1,4(sp)
40f0817c:	01212023          	sw	s2,0(sp)
40f08180:	00112623          	sw	ra,12(sp)
40f08184:	01010413          	addi	s0,sp,16
40f08188:	00058493          	mv	s1,a1
40f0818c:	00050913          	mv	s2,a0
40f08190:	00062023          	sw	zero,0(a2)
40f08194:	00062223          	sw	zero,4(a2)
40f08198:	00062423          	sw	zero,8(a2)
40f0819c:	00062623          	sw	zero,12(a2)
40f081a0:	00062823          	sw	zero,16(a2)
40f081a4:	00060593          	mv	a1,a2
40f081a8:	00048513          	mv	a0,s1
40f081ac:	f79fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f081b0:	000207b7          	lui	a5,0x20
40f081b4:	3007a673          	csrrs	a2,mstatus,a5
40f081b8:	00092703          	lw	a4,0(s2)
40f081bc:	30061073          	csrw	mstatus,a2
40f081c0:	00000593          	li	a1,0
40f081c4:	00048513          	mv	a0,s1
40f081c8:	00070913          	mv	s2,a4
40f081cc:	f59fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f081d0:	00c12083          	lw	ra,12(sp)
40f081d4:	00812403          	lw	s0,8(sp)
40f081d8:	00090513          	mv	a0,s2
40f081dc:	00412483          	lw	s1,4(sp)
40f081e0:	00012903          	lw	s2,0(sp)
40f081e4:	01010113          	addi	sp,sp,16
40f081e8:	00008067          	ret

40f081ec <sbi_store_u8>:
DEFINE_UNPRIVILEGED_STORE_FUNCTION(u8, sb)
40f081ec:	fe010113          	addi	sp,sp,-32
40f081f0:	00812c23          	sw	s0,24(sp)
40f081f4:	00912a23          	sw	s1,20(sp)
40f081f8:	01212823          	sw	s2,16(sp)
40f081fc:	01312623          	sw	s3,12(sp)
40f08200:	00112e23          	sw	ra,28(sp)
40f08204:	02010413          	addi	s0,sp,32
40f08208:	00050993          	mv	s3,a0
40f0820c:	00058913          	mv	s2,a1
40f08210:	0006a023          	sw	zero,0(a3)
40f08214:	0006a223          	sw	zero,4(a3)
40f08218:	0006a423          	sw	zero,8(a3)
40f0821c:	0006a623          	sw	zero,12(a3)
40f08220:	0006a823          	sw	zero,16(a3)
40f08224:	00068593          	mv	a1,a3
40f08228:	00060513          	mv	a0,a2
40f0822c:	00060493          	mv	s1,a2
40f08230:	ef5fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f08234:	000207b7          	lui	a5,0x20
40f08238:	3007a6f3          	csrrs	a3,mstatus,a5
40f0823c:	01298023          	sb	s2,0(s3)
40f08240:	30069073          	csrw	mstatus,a3
40f08244:	00000593          	li	a1,0
40f08248:	00048513          	mv	a0,s1
40f0824c:	ed9fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f08250:	01c12083          	lw	ra,28(sp)
40f08254:	01812403          	lw	s0,24(sp)
40f08258:	01412483          	lw	s1,20(sp)
40f0825c:	01012903          	lw	s2,16(sp)
40f08260:	00c12983          	lw	s3,12(sp)
40f08264:	02010113          	addi	sp,sp,32
40f08268:	00008067          	ret

40f0826c <sbi_store_u16>:
DEFINE_UNPRIVILEGED_STORE_FUNCTION(u16, sh)
40f0826c:	fe010113          	addi	sp,sp,-32
40f08270:	00812c23          	sw	s0,24(sp)
40f08274:	00912a23          	sw	s1,20(sp)
40f08278:	01212823          	sw	s2,16(sp)
40f0827c:	01312623          	sw	s3,12(sp)
40f08280:	00112e23          	sw	ra,28(sp)
40f08284:	02010413          	addi	s0,sp,32
40f08288:	00050993          	mv	s3,a0
40f0828c:	00058913          	mv	s2,a1
40f08290:	0006a023          	sw	zero,0(a3)
40f08294:	0006a223          	sw	zero,4(a3)
40f08298:	0006a423          	sw	zero,8(a3)
40f0829c:	0006a623          	sw	zero,12(a3)
40f082a0:	0006a823          	sw	zero,16(a3)
40f082a4:	00068593          	mv	a1,a3
40f082a8:	00060513          	mv	a0,a2
40f082ac:	00060493          	mv	s1,a2
40f082b0:	e75fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f082b4:	000207b7          	lui	a5,0x20
40f082b8:	3007a6f3          	csrrs	a3,mstatus,a5
40f082bc:	01299023          	sh	s2,0(s3)
40f082c0:	30069073          	csrw	mstatus,a3
40f082c4:	00000593          	li	a1,0
40f082c8:	00048513          	mv	a0,s1
40f082cc:	e59fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f082d0:	01c12083          	lw	ra,28(sp)
40f082d4:	01812403          	lw	s0,24(sp)
40f082d8:	01412483          	lw	s1,20(sp)
40f082dc:	01012903          	lw	s2,16(sp)
40f082e0:	00c12983          	lw	s3,12(sp)
40f082e4:	02010113          	addi	sp,sp,32
40f082e8:	00008067          	ret

40f082ec <sbi_store_u32>:
DEFINE_UNPRIVILEGED_STORE_FUNCTION(u32, sw)
40f082ec:	fe010113          	addi	sp,sp,-32
40f082f0:	00812c23          	sw	s0,24(sp)
40f082f4:	00912a23          	sw	s1,20(sp)
40f082f8:	01212823          	sw	s2,16(sp)
40f082fc:	01312623          	sw	s3,12(sp)
40f08300:	00112e23          	sw	ra,28(sp)
40f08304:	02010413          	addi	s0,sp,32
40f08308:	00050993          	mv	s3,a0
40f0830c:	00058913          	mv	s2,a1
40f08310:	0006a023          	sw	zero,0(a3)
40f08314:	0006a223          	sw	zero,4(a3)
40f08318:	0006a423          	sw	zero,8(a3)
40f0831c:	0006a623          	sw	zero,12(a3)
40f08320:	0006a823          	sw	zero,16(a3)
40f08324:	00068593          	mv	a1,a3
40f08328:	00060513          	mv	a0,a2
40f0832c:	00060493          	mv	s1,a2
40f08330:	df5fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f08334:	000207b7          	lui	a5,0x20
40f08338:	3007a6f3          	csrrs	a3,mstatus,a5
40f0833c:	0129a023          	sw	s2,0(s3)
40f08340:	30069073          	csrw	mstatus,a3
40f08344:	00000593          	li	a1,0
40f08348:	00048513          	mv	a0,s1
40f0834c:	dd9fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f08350:	01c12083          	lw	ra,28(sp)
40f08354:	01812403          	lw	s0,24(sp)
40f08358:	01412483          	lw	s1,20(sp)
40f0835c:	01012903          	lw	s2,16(sp)
40f08360:	00c12983          	lw	s3,12(sp)
40f08364:	02010113          	addi	sp,sp,32
40f08368:	00008067          	ret

40f0836c <sbi_load_u32>:
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(u32, lwu)
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(u64, ld)
DEFINE_UNPRIVILEGED_STORE_FUNCTION(u64, sd)
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(ulong, ld)
#else
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(u32, lw)
40f0836c:	ff010113          	addi	sp,sp,-16
40f08370:	00812423          	sw	s0,8(sp)
40f08374:	00912223          	sw	s1,4(sp)
40f08378:	01212023          	sw	s2,0(sp)
40f0837c:	00112623          	sw	ra,12(sp)
40f08380:	01010413          	addi	s0,sp,16
40f08384:	00058493          	mv	s1,a1
40f08388:	00050913          	mv	s2,a0
40f0838c:	00062023          	sw	zero,0(a2)
40f08390:	00062223          	sw	zero,4(a2)
40f08394:	00062423          	sw	zero,8(a2)
40f08398:	00062623          	sw	zero,12(a2)
40f0839c:	00062823          	sw	zero,16(a2)
40f083a0:	00060593          	mv	a1,a2
40f083a4:	00048513          	mv	a0,s1
40f083a8:	d7dfe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f083ac:	000207b7          	lui	a5,0x20
40f083b0:	3007a673          	csrrs	a2,mstatus,a5
40f083b4:	00092703          	lw	a4,0(s2)
40f083b8:	30061073          	csrw	mstatus,a2
40f083bc:	00000593          	li	a1,0
40f083c0:	00048513          	mv	a0,s1
40f083c4:	00070913          	mv	s2,a4
40f083c8:	d5dfe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f083cc:	00c12083          	lw	ra,12(sp)
40f083d0:	00812403          	lw	s0,8(sp)
40f083d4:	00090513          	mv	a0,s2
40f083d8:	00412483          	lw	s1,4(sp)
40f083dc:	00012903          	lw	s2,0(sp)
40f083e0:	01010113          	addi	sp,sp,16
40f083e4:	00008067          	ret

40f083e8 <sbi_load_ulong>:
DEFINE_UNPRIVILEGED_LOAD_FUNCTION(ulong, lw)
40f083e8:	ff010113          	addi	sp,sp,-16
40f083ec:	00812423          	sw	s0,8(sp)
40f083f0:	00912223          	sw	s1,4(sp)
40f083f4:	01212023          	sw	s2,0(sp)
40f083f8:	00112623          	sw	ra,12(sp)
40f083fc:	01010413          	addi	s0,sp,16
40f08400:	00058493          	mv	s1,a1
40f08404:	00050913          	mv	s2,a0
40f08408:	00062023          	sw	zero,0(a2)
40f0840c:	00062223          	sw	zero,4(a2)
40f08410:	00062423          	sw	zero,8(a2)
40f08414:	00062623          	sw	zero,12(a2)
40f08418:	00062823          	sw	zero,16(a2)
40f0841c:	00060593          	mv	a1,a2
40f08420:	00048513          	mv	a0,s1
40f08424:	d01fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f08428:	000207b7          	lui	a5,0x20
40f0842c:	3007a673          	csrrs	a2,mstatus,a5
40f08430:	00092703          	lw	a4,0(s2)
40f08434:	30061073          	csrw	mstatus,a2
40f08438:	00000593          	li	a1,0
40f0843c:	00048513          	mv	a0,s1
40f08440:	00070913          	mv	s2,a4
40f08444:	ce1fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>
40f08448:	00c12083          	lw	ra,12(sp)
40f0844c:	00812403          	lw	s0,8(sp)
40f08450:	00090513          	mv	a0,s2
40f08454:	00412483          	lw	s1,4(sp)
40f08458:	00012903          	lw	s2,0(sp)
40f0845c:	01010113          	addi	sp,sp,16
40f08460:	00008067          	ret

40f08464 <sbi_load_u64>:

u64 sbi_load_u64(const u64 *addr,
		 struct sbi_scratch *scratch,
		 struct sbi_trap_info *trap)
{
40f08464:	fe010113          	addi	sp,sp,-32
40f08468:	00812c23          	sw	s0,24(sp)
40f0846c:	01212823          	sw	s2,16(sp)
40f08470:	01312623          	sw	s3,12(sp)
40f08474:	01412423          	sw	s4,8(sp)
40f08478:	00112e23          	sw	ra,28(sp)
40f0847c:	00912a23          	sw	s1,20(sp)
40f08480:	02010413          	addi	s0,sp,32
40f08484:	00060913          	mv	s2,a2
40f08488:	00050993          	mv	s3,a0
40f0848c:	00058a13          	mv	s4,a1
	u64 ret = sbi_load_u32((u32 *)addr, scratch, trap);
40f08490:	eddff0ef          	jal	ra,40f0836c <sbi_load_u32>

	if (trap->cause)
40f08494:	00492783          	lw	a5,4(s2)
40f08498:	02078663          	beqz	a5,40f084c4 <sbi_load_u64+0x60>
	ret |= ((u64)sbi_load_u32((u32 *)addr + 1, scratch, trap) << 32);
	if (trap->cause)
		return 0;

	return ret;
}
40f0849c:	01c12083          	lw	ra,28(sp)
40f084a0:	01812403          	lw	s0,24(sp)
40f084a4:	01412483          	lw	s1,20(sp)
40f084a8:	01012903          	lw	s2,16(sp)
40f084ac:	00c12983          	lw	s3,12(sp)
40f084b0:	00812a03          	lw	s4,8(sp)
		return 0;
40f084b4:	00000513          	li	a0,0
40f084b8:	00000593          	li	a1,0
}
40f084bc:	02010113          	addi	sp,sp,32
40f084c0:	00008067          	ret
	ret |= ((u64)sbi_load_u32((u32 *)addr + 1, scratch, trap) << 32);
40f084c4:	00050493          	mv	s1,a0
40f084c8:	000a0593          	mv	a1,s4
40f084cc:	00090613          	mv	a2,s2
40f084d0:	00498513          	addi	a0,s3,4
40f084d4:	e99ff0ef          	jal	ra,40f0836c <sbi_load_u32>
	if (trap->cause)
40f084d8:	00492783          	lw	a5,4(s2)
	ret |= ((u64)sbi_load_u32((u32 *)addr + 1, scratch, trap) << 32);
40f084dc:	00050593          	mv	a1,a0
40f084e0:	00048513          	mv	a0,s1
	if (trap->cause)
40f084e4:	fa079ce3          	bnez	a5,40f0849c <sbi_load_u64+0x38>
}
40f084e8:	01c12083          	lw	ra,28(sp)
40f084ec:	01812403          	lw	s0,24(sp)
40f084f0:	01412483          	lw	s1,20(sp)
40f084f4:	01012903          	lw	s2,16(sp)
40f084f8:	00c12983          	lw	s3,12(sp)
40f084fc:	00812a03          	lw	s4,8(sp)
40f08500:	02010113          	addi	sp,sp,32
40f08504:	00008067          	ret

40f08508 <sbi_store_u64>:

void sbi_store_u64(u64 *addr, u64 val,
		   struct sbi_scratch *scratch,
		   struct sbi_trap_info *trap)
{
40f08508:	fe010113          	addi	sp,sp,-32
40f0850c:	00812c23          	sw	s0,24(sp)
40f08510:	00912a23          	sw	s1,20(sp)
40f08514:	01212823          	sw	s2,16(sp)
40f08518:	01312623          	sw	s3,12(sp)
40f0851c:	01412423          	sw	s4,8(sp)
40f08520:	00112e23          	sw	ra,28(sp)
40f08524:	02010413          	addi	s0,sp,32
40f08528:	00068913          	mv	s2,a3
40f0852c:	00060a13          	mv	s4,a2
	sbi_store_u32((u32 *)addr, val, scratch, trap);
40f08530:	00070693          	mv	a3,a4
40f08534:	00090613          	mv	a2,s2
{
40f08538:	00070493          	mv	s1,a4
40f0853c:	00050993          	mv	s3,a0
	sbi_store_u32((u32 *)addr, val, scratch, trap);
40f08540:	dadff0ef          	jal	ra,40f082ec <sbi_store_u32>
	if (trap->cause)
40f08544:	0044a783          	lw	a5,4(s1)
40f08548:	00079c63          	bnez	a5,40f08560 <sbi_store_u64+0x58>
		return;

	sbi_store_u32((u32 *)addr + 1, val >> 32, scratch, trap);
40f0854c:	00048693          	mv	a3,s1
40f08550:	00090613          	mv	a2,s2
40f08554:	000a0593          	mv	a1,s4
40f08558:	00498513          	addi	a0,s3,4
40f0855c:	d91ff0ef          	jal	ra,40f082ec <sbi_store_u32>
	if (trap->cause)
		return;
}
40f08560:	01c12083          	lw	ra,28(sp)
40f08564:	01812403          	lw	s0,24(sp)
40f08568:	01412483          	lw	s1,20(sp)
40f0856c:	01012903          	lw	s2,16(sp)
40f08570:	00c12983          	lw	s3,12(sp)
40f08574:	00812a03          	lw	s4,8(sp)
40f08578:	02010113          	addi	sp,sp,32
40f0857c:	00008067          	ret

40f08580 <sbi_get_insn>:
#endif

ulong sbi_get_insn(ulong mepc, struct sbi_scratch *scratch,
		   struct sbi_trap_info *trap)
{
40f08580:	fe010113          	addi	sp,sp,-32
40f08584:	00112e23          	sw	ra,28(sp)
40f08588:	00812c23          	sw	s0,24(sp)
40f0858c:	00912a23          	sw	s1,20(sp)
40f08590:	01212823          	sw	s2,16(sp)
40f08594:	01312623          	sw	s3,12(sp)
40f08598:	02010413          	addi	s0,sp,32
40f0859c:	00058993          	mv	s3,a1
40f085a0:	00050913          	mv	s2,a0
	trap->epc = 0;
	trap->cause = 0;
	trap->tval = 0;
	trap->tval2 = 0;
	trap->tinst = 0;
	sbi_hart_set_trap_info(scratch, trap);
40f085a4:	00060593          	mv	a1,a2
40f085a8:	00098513          	mv	a0,s3
	trap->epc = 0;
40f085ac:	00062023          	sw	zero,0(a2)
	trap->cause = 0;
40f085b0:	00062223          	sw	zero,4(a2)
	trap->tval = 0;
40f085b4:	00062423          	sw	zero,8(a2)
	trap->tval2 = 0;
40f085b8:	00062623          	sw	zero,12(a2)
	trap->tinst = 0;
40f085bc:	00062823          	sw	zero,16(a2)
{
40f085c0:	00060493          	mv	s1,a2
	sbi_hart_set_trap_info(scratch, trap);
40f085c4:	b61fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>

#ifndef __riscv_compressed
	asm("csrrs %[mstatus], " STR(CSR_MSTATUS) ", %[mprv]\n"
40f085c8:	000a0737          	lui	a4,0xa0
	    : [mstatus] "+&r"(__mstatus), [insn] "=&r"(val), [tmp] "=&r"(tmp)
	    : [mprv] "r"(MSTATUS_MPRV | MSTATUS_MXR), [addr] "r"(mepc),
	      [rvc_mask] "r"(rvc_mask));
#endif

	sbi_hart_set_trap_info(scratch, NULL);
40f085cc:	00098513          	mv	a0,s3
40f085d0:	00000593          	li	a1,0
	asm("csrrs %[mstatus], " STR(CSR_MSTATUS) ", %[mprv]\n"
40f085d4:	00000793          	li	a5,0
40f085d8:	300727f3          	csrrs	a5,mstatus,a4
40f085dc:	00092983          	lw	s3,0(s2)
40f085e0:	30079073          	csrw	mstatus,a5
	sbi_hart_set_trap_info(scratch, NULL);
40f085e4:	b41fe0ef          	jal	ra,40f07124 <sbi_hart_set_trap_info>

	switch (trap->cause) {
40f085e8:	0044a783          	lw	a5,4(s1)
40f085ec:	00d00713          	li	a4,13
40f085f0:	02e78a63          	beq	a5,a4,40f08624 <sbi_get_insn+0xa4>
40f085f4:	01500713          	li	a4,21
40f085f8:	08e78263          	beq	a5,a4,40f0867c <sbi_get_insn+0xfc>
40f085fc:	00500713          	li	a4,5
40f08600:	04e78863          	beq	a5,a4,40f08650 <sbi_get_insn+0xd0>
	default:
		break;
	};

	return val;
}
40f08604:	01c12083          	lw	ra,28(sp)
40f08608:	01812403          	lw	s0,24(sp)
40f0860c:	00098513          	mv	a0,s3
40f08610:	01412483          	lw	s1,20(sp)
40f08614:	01012903          	lw	s2,16(sp)
40f08618:	00c12983          	lw	s3,12(sp)
40f0861c:	02010113          	addi	sp,sp,32
40f08620:	00008067          	ret
		trap->cause = CAUSE_FETCH_PAGE_FAULT;
40f08624:	00c00793          	li	a5,12
40f08628:	00f4a223          	sw	a5,4(s1)
		trap->tval = mepc;
40f0862c:	0124a423          	sw	s2,8(s1)
}
40f08630:	01c12083          	lw	ra,28(sp)
40f08634:	01812403          	lw	s0,24(sp)
40f08638:	00098513          	mv	a0,s3
40f0863c:	01412483          	lw	s1,20(sp)
40f08640:	01012903          	lw	s2,16(sp)
40f08644:	00c12983          	lw	s3,12(sp)
40f08648:	02010113          	addi	sp,sp,32
40f0864c:	00008067          	ret
		trap->cause = CAUSE_FETCH_ACCESS;
40f08650:	00100793          	li	a5,1
40f08654:	00f4a223          	sw	a5,4(s1)
		trap->tval = mepc;
40f08658:	0124a423          	sw	s2,8(s1)
}
40f0865c:	01c12083          	lw	ra,28(sp)
40f08660:	01812403          	lw	s0,24(sp)
40f08664:	00098513          	mv	a0,s3
40f08668:	01412483          	lw	s1,20(sp)
40f0866c:	01012903          	lw	s2,16(sp)
40f08670:	00c12983          	lw	s3,12(sp)
40f08674:	02010113          	addi	sp,sp,32
40f08678:	00008067          	ret
		trap->cause = CAUSE_FETCH_GUEST_PAGE_FAULT;
40f0867c:	01400793          	li	a5,20
40f08680:	00f4a223          	sw	a5,4(s1)
		trap->tval = mepc;
40f08684:	0124a423          	sw	s2,8(s1)
}
40f08688:	01c12083          	lw	ra,28(sp)
40f0868c:	01812403          	lw	s0,24(sp)
40f08690:	00098513          	mv	a0,s3
40f08694:	01412483          	lw	s1,20(sp)
40f08698:	01012903          	lw	s2,16(sp)
40f0869c:	00c12983          	lw	s3,12(sp)
40f086a0:	02010113          	addi	sp,sp,32
40f086a4:	00008067          	ret

40f086a8 <clint_time_rd32>:
	writeq_relaxed(value, addr);
}
#endif

static u64 clint_time_rd32(volatile u64 *addr)
{
40f086a8:	ff010113          	addi	sp,sp,-16
40f086ac:	00812623          	sw	s0,12(sp)
40f086b0:	01010413          	addi	s0,sp,16
40f086b4:	00050693          	mv	a3,a0
40f086b8:	00450793          	addi	a5,a0,4

static inline u32 __raw_readl(const volatile void *addr)
{
	u32 val;

	asm volatile("lw %0, 0(%1)" : "=r"(val) : "r"(addr));
40f086bc:	0007a703          	lw	a4,0(a5) # 20000 <_fw_start-0x40ee0000>
40f086c0:	0006a503          	lw	a0,0(a3)
40f086c4:	0007a583          	lw	a1,0(a5)
	u32 lo, hi;

	do {
		hi = readl_relaxed((u32 *)addr + 1);
		lo = readl_relaxed((u32 *)addr);
	} while (hi != readl_relaxed((u32 *)addr + 1));
40f086c8:	fee59ae3          	bne	a1,a4,40f086bc <clint_time_rd32+0x14>

	return ((u64)hi << 32) | (u64)lo;
}
40f086cc:	00c12403          	lw	s0,12(sp)
40f086d0:	01010113          	addi	sp,sp,16
40f086d4:	00008067          	ret

40f086d8 <clint_time_wr32>:

static void clint_time_wr32(u64 value, volatile u64 *addr)
{
40f086d8:	ff010113          	addi	sp,sp,-16
40f086dc:	00812623          	sw	s0,12(sp)
40f086e0:	01010413          	addi	s0,sp,16
	asm volatile("sw %0, 0(%1)" : : "r"(val), "r"(addr));
40f086e4:	00a62023          	sw	a0,0(a2)
	u32 mask = -1U;

	writel_relaxed(value & mask, (void *)(addr));
	writel_relaxed(value >> 32, (void *)(addr) + 0x04);
40f086e8:	00460613          	addi	a2,a2,4
40f086ec:	00b62023          	sw	a1,0(a2)
}
40f086f0:	00c12403          	lw	s0,12(sp)
40f086f4:	01010113          	addi	sp,sp,16
40f086f8:	00008067          	ret

40f086fc <clint_ipi_send>:
{
40f086fc:	ff010113          	addi	sp,sp,-16
40f08700:	00812623          	sw	s0,12(sp)
40f08704:	01010413          	addi	s0,sp,16
	if (clint_ipi_hart_count <= target_hart)
40f08708:	00004797          	auipc	a5,0x4
40f0870c:	95478793          	addi	a5,a5,-1708 # 40f0c05c <clint_ipi_hart_count>
40f08710:	0007a783          	lw	a5,0(a5)
40f08714:	02f57263          	bgeu	a0,a5,40f08738 <clint_ipi_send+0x3c>
	writel(1, &clint_ipi[target_hart]);
40f08718:	0140000f          	fence	w,o
40f0871c:	00004797          	auipc	a5,0x4
40f08720:	93878793          	addi	a5,a5,-1736 # 40f0c054 <clint_ipi>
40f08724:	0007a783          	lw	a5,0(a5)
40f08728:	00251513          	slli	a0,a0,0x2
40f0872c:	00a78533          	add	a0,a5,a0
40f08730:	00100793          	li	a5,1
40f08734:	00f52023          	sw	a5,0(a0)
}
40f08738:	00c12403          	lw	s0,12(sp)
40f0873c:	01010113          	addi	sp,sp,16
40f08740:	00008067          	ret

40f08744 <clint_ipi_clear>:
{
40f08744:	ff010113          	addi	sp,sp,-16
40f08748:	00812623          	sw	s0,12(sp)
40f0874c:	01010413          	addi	s0,sp,16
	if (clint_ipi_hart_count <= target_hart)
40f08750:	00004797          	auipc	a5,0x4
40f08754:	90c78793          	addi	a5,a5,-1780 # 40f0c05c <clint_ipi_hart_count>
40f08758:	0007a783          	lw	a5,0(a5)
40f0875c:	02f57263          	bgeu	a0,a5,40f08780 <clint_ipi_clear+0x3c>
	writel(0, &clint_ipi[target_hart]);
40f08760:	0140000f          	fence	w,o
40f08764:	00004797          	auipc	a5,0x4
40f08768:	8f078793          	addi	a5,a5,-1808 # 40f0c054 <clint_ipi>
40f0876c:	0007a783          	lw	a5,0(a5)
40f08770:	00251513          	slli	a0,a0,0x2
40f08774:	00a78533          	add	a0,a5,a0
40f08778:	00000793          	li	a5,0
40f0877c:	00f52023          	sw	a5,0(a0)
}
40f08780:	00c12403          	lw	s0,12(sp)
40f08784:	01010113          	addi	sp,sp,16
40f08788:	00008067          	ret

40f0878c <clint_warm_ipi_init>:
{
40f0878c:	ff010113          	addi	sp,sp,-16
40f08790:	00812423          	sw	s0,8(sp)
40f08794:	00112623          	sw	ra,12(sp)
40f08798:	01010413          	addi	s0,sp,16
	u32 hartid = sbi_current_hartid();
40f0879c:	b1cfe0ef          	jal	ra,40f06ab8 <sbi_current_hartid>
	if (!clint_ipi_base)
40f087a0:	00004717          	auipc	a4,0x4
40f087a4:	8b870713          	addi	a4,a4,-1864 # 40f0c058 <clint_ipi_base>
40f087a8:	00072703          	lw	a4,0(a4)
40f087ac:	04070463          	beqz	a4,40f087f4 <clint_warm_ipi_init+0x68>
	if (clint_ipi_hart_count <= target_hart)
40f087b0:	00004717          	auipc	a4,0x4
40f087b4:	8ac70713          	addi	a4,a4,-1876 # 40f0c05c <clint_ipi_hart_count>
40f087b8:	00072703          	lw	a4,0(a4)
40f087bc:	00050793          	mv	a5,a0
	return 0;
40f087c0:	00000513          	li	a0,0
	if (clint_ipi_hart_count <= target_hart)
40f087c4:	02e7f063          	bgeu	a5,a4,40f087e4 <clint_warm_ipi_init+0x58>
	writel(0, &clint_ipi[target_hart]);
40f087c8:	0140000f          	fence	w,o
40f087cc:	00004717          	auipc	a4,0x4
40f087d0:	88870713          	addi	a4,a4,-1912 # 40f0c054 <clint_ipi>
40f087d4:	00072703          	lw	a4,0(a4)
40f087d8:	00279793          	slli	a5,a5,0x2
40f087dc:	00f707b3          	add	a5,a4,a5
40f087e0:	00a7a023          	sw	a0,0(a5)
}
40f087e4:	00c12083          	lw	ra,12(sp)
40f087e8:	00812403          	lw	s0,8(sp)
40f087ec:	01010113          	addi	sp,sp,16
40f087f0:	00008067          	ret
		return -1;
40f087f4:	fff00513          	li	a0,-1
40f087f8:	fedff06f          	j	40f087e4 <clint_warm_ipi_init+0x58>

40f087fc <clint_cold_ipi_init>:
{
40f087fc:	ff010113          	addi	sp,sp,-16
40f08800:	00812623          	sw	s0,12(sp)
40f08804:	01010413          	addi	s0,sp,16
}
40f08808:	00c12403          	lw	s0,12(sp)
	clint_ipi_base	     = (void *)base;
40f0880c:	00004797          	auipc	a5,0x4
40f08810:	84a7a623          	sw	a0,-1972(a5) # 40f0c058 <clint_ipi_base>
	clint_ipi	     = (u32 *)clint_ipi_base;
40f08814:	00004797          	auipc	a5,0x4
40f08818:	84a7a023          	sw	a0,-1984(a5) # 40f0c054 <clint_ipi>
	clint_ipi_hart_count = hart_count;
40f0881c:	00004797          	auipc	a5,0x4
40f08820:	84b7a023          	sw	a1,-1984(a5) # 40f0c05c <clint_ipi_hart_count>
}
40f08824:	00000513          	li	a0,0
40f08828:	01010113          	addi	sp,sp,16
40f0882c:	00008067          	ret

40f08830 <clint_timer_value>:

static u64 (*clint_time_rd)(volatile u64 *addr) = clint_time_rd32;
static void (*clint_time_wr)(u64 value, volatile u64 *addr) = clint_time_wr32;

u64 clint_timer_value(void)
{
40f08830:	ff010113          	addi	sp,sp,-16
40f08834:	00812423          	sw	s0,8(sp)
40f08838:	00112623          	sw	ra,12(sp)
40f0883c:	01010413          	addi	s0,sp,16
	/* Read CLINT Time Value */
	return clint_time_rd(clint_time_val);
40f08840:	00004797          	auipc	a5,0x4
40f08844:	80878793          	addi	a5,a5,-2040 # 40f0c048 <clint_time_val>
40f08848:	0007a503          	lw	a0,0(a5)
40f0884c:	e5dff0ef          	jal	ra,40f086a8 <clint_time_rd32>
}
40f08850:	00c12083          	lw	ra,12(sp)
40f08854:	00812403          	lw	s0,8(sp)
40f08858:	01010113          	addi	sp,sp,16
40f0885c:	00008067          	ret

40f08860 <clint_timer_event_stop>:

void clint_timer_event_stop(void)
{
40f08860:	ff010113          	addi	sp,sp,-16
40f08864:	00812423          	sw	s0,8(sp)
40f08868:	00112623          	sw	ra,12(sp)
40f0886c:	01010413          	addi	s0,sp,16
	u32 target_hart = sbi_current_hartid();
40f08870:	a48fe0ef          	jal	ra,40f06ab8 <sbi_current_hartid>

	if (clint_time_hart_count <= target_hart)
40f08874:	00003797          	auipc	a5,0x3
40f08878:	7dc78793          	addi	a5,a5,2012 # 40f0c050 <clint_time_hart_count>
40f0887c:	0007a783          	lw	a5,0(a5)
40f08880:	02f57263          	bgeu	a0,a5,40f088a4 <clint_timer_event_stop+0x44>
		return;

	/* Clear CLINT Time Compare */
	clint_time_wr(-1ULL, &clint_time_cmp[target_hart]);
40f08884:	00003797          	auipc	a5,0x3
40f08888:	7c078793          	addi	a5,a5,1984 # 40f0c044 <clint_time_cmp>
40f0888c:	0007a783          	lw	a5,0(a5)
40f08890:	00351613          	slli	a2,a0,0x3
40f08894:	fff00593          	li	a1,-1
40f08898:	fff00513          	li	a0,-1
40f0889c:	00c78633          	add	a2,a5,a2
40f088a0:	e39ff0ef          	jal	ra,40f086d8 <clint_time_wr32>
}
40f088a4:	00c12083          	lw	ra,12(sp)
40f088a8:	00812403          	lw	s0,8(sp)
40f088ac:	01010113          	addi	sp,sp,16
40f088b0:	00008067          	ret

40f088b4 <clint_timer_event_start>:

void clint_timer_event_start(u64 next_event)
{
40f088b4:	ff010113          	addi	sp,sp,-16
40f088b8:	00812423          	sw	s0,8(sp)
40f088bc:	01212223          	sw	s2,4(sp)
40f088c0:	01312023          	sw	s3,0(sp)
40f088c4:	00112623          	sw	ra,12(sp)
40f088c8:	01010413          	addi	s0,sp,16
40f088cc:	00050913          	mv	s2,a0
40f088d0:	00058993          	mv	s3,a1
	u32 target_hart = sbi_current_hartid();
40f088d4:	9e4fe0ef          	jal	ra,40f06ab8 <sbi_current_hartid>

	if (clint_time_hart_count <= target_hart)
40f088d8:	00003797          	auipc	a5,0x3
40f088dc:	77878793          	addi	a5,a5,1912 # 40f0c050 <clint_time_hart_count>
40f088e0:	0007a783          	lw	a5,0(a5)
40f088e4:	02f57263          	bgeu	a0,a5,40f08908 <clint_timer_event_start+0x54>
		return;

	/* Program CLINT Time Compare */
	clint_time_wr(next_event, &clint_time_cmp[target_hart]);
40f088e8:	00003797          	auipc	a5,0x3
40f088ec:	75c78793          	addi	a5,a5,1884 # 40f0c044 <clint_time_cmp>
40f088f0:	0007a783          	lw	a5,0(a5)
40f088f4:	00351613          	slli	a2,a0,0x3
40f088f8:	00098593          	mv	a1,s3
40f088fc:	00090513          	mv	a0,s2
40f08900:	00c78633          	add	a2,a5,a2
40f08904:	dd5ff0ef          	jal	ra,40f086d8 <clint_time_wr32>
}
40f08908:	00c12083          	lw	ra,12(sp)
40f0890c:	00812403          	lw	s0,8(sp)
40f08910:	00412903          	lw	s2,4(sp)
40f08914:	00012983          	lw	s3,0(sp)
40f08918:	01010113          	addi	sp,sp,16
40f0891c:	00008067          	ret

40f08920 <clint_warm_timer_init>:

int clint_warm_timer_init(void)
{
40f08920:	ff010113          	addi	sp,sp,-16
40f08924:	00812423          	sw	s0,8(sp)
40f08928:	00112623          	sw	ra,12(sp)
40f0892c:	01010413          	addi	s0,sp,16
	u32 target_hart = sbi_current_hartid();
40f08930:	988fe0ef          	jal	ra,40f06ab8 <sbi_current_hartid>

	if (clint_time_hart_count <= target_hart || !clint_time_base)
40f08934:	00003797          	auipc	a5,0x3
40f08938:	71c78793          	addi	a5,a5,1820 # 40f0c050 <clint_time_hart_count>
40f0893c:	0007a783          	lw	a5,0(a5)
40f08940:	04f57463          	bgeu	a0,a5,40f08988 <clint_warm_timer_init+0x68>
40f08944:	00003797          	auipc	a5,0x3
40f08948:	70878793          	addi	a5,a5,1800 # 40f0c04c <clint_time_base>
40f0894c:	0007a783          	lw	a5,0(a5)
40f08950:	02078c63          	beqz	a5,40f08988 <clint_warm_timer_init+0x68>
		return -1;

	/* Clear CLINT Time Compare */
	clint_time_wr(-1ULL, &clint_time_cmp[target_hart]);
40f08954:	00003797          	auipc	a5,0x3
40f08958:	6f078793          	addi	a5,a5,1776 # 40f0c044 <clint_time_cmp>
40f0895c:	0007a783          	lw	a5,0(a5)
40f08960:	00351613          	slli	a2,a0,0x3
40f08964:	fff00593          	li	a1,-1
40f08968:	fff00513          	li	a0,-1
40f0896c:	00c78633          	add	a2,a5,a2
40f08970:	d69ff0ef          	jal	ra,40f086d8 <clint_time_wr32>

	return 0;
40f08974:	00000513          	li	a0,0
}
40f08978:	00c12083          	lw	ra,12(sp)
40f0897c:	00812403          	lw	s0,8(sp)
40f08980:	01010113          	addi	sp,sp,16
40f08984:	00008067          	ret
		return -1;
40f08988:	fff00513          	li	a0,-1
40f0898c:	fedff06f          	j	40f08978 <clint_warm_timer_init+0x58>

40f08990 <clint_cold_timer_init>:

int clint_cold_timer_init(unsigned long base, u32 hart_count,
			  bool has_64bit_mmio)
{
40f08990:	ff010113          	addi	sp,sp,-16
40f08994:	00812623          	sw	s0,12(sp)
40f08998:	01010413          	addi	s0,sp,16
	/* Figure-out CLINT Time register address */
	clint_time_hart_count		= hart_count;
	clint_time_base			= (void *)base;
	clint_time_val			= (u64 *)(clint_time_base + 0xbff8);
40f0899c:	0000c7b7          	lui	a5,0xc
		clint_time_wr		= clint_time_wr64;
	}
#endif

	return 0;
}
40f089a0:	00c12403          	lw	s0,12(sp)
	clint_time_val			= (u64 *)(clint_time_base + 0xbff8);
40f089a4:	ff878793          	addi	a5,a5,-8 # bff8 <_fw_start-0x40ef4008>
	clint_time_cmp			= (u64 *)(clint_time_base + 0x4000);
40f089a8:	00004737          	lui	a4,0x4
	clint_time_val			= (u64 *)(clint_time_base + 0xbff8);
40f089ac:	00f507b3          	add	a5,a0,a5
	clint_time_cmp			= (u64 *)(clint_time_base + 0x4000);
40f089b0:	00e50733          	add	a4,a0,a4
	clint_time_base			= (void *)base;
40f089b4:	00003697          	auipc	a3,0x3
40f089b8:	68a6ac23          	sw	a0,1688(a3) # 40f0c04c <clint_time_base>
	clint_time_val			= (u64 *)(clint_time_base + 0xbff8);
40f089bc:	00003697          	auipc	a3,0x3
40f089c0:	68f6a623          	sw	a5,1676(a3) # 40f0c048 <clint_time_val>
	clint_time_hart_count		= hart_count;
40f089c4:	00003697          	auipc	a3,0x3
40f089c8:	68b6a623          	sw	a1,1676(a3) # 40f0c050 <clint_time_hart_count>
	clint_time_cmp			= (u64 *)(clint_time_base + 0x4000);
40f089cc:	00003797          	auipc	a5,0x3
40f089d0:	66e7ac23          	sw	a4,1656(a5) # 40f0c044 <clint_time_cmp>
}
40f089d4:	00000513          	li	a0,0
40f089d8:	01010113          	addi	sp,sp,16
40f089dc:	00008067          	ret

40f089e0 <sbi_emulate_csr_read>:
#include <sbi/sbi_timer.h>
#include <sbi/sbi_trap.h>

int sbi_emulate_csr_read(int csr_num, u32 hartid, struct sbi_trap_regs *regs,
			 struct sbi_scratch *scratch, ulong *csr_val)
{
40f089e0:	fe010113          	addi	sp,sp,-32
40f089e4:	00812c23          	sw	s0,24(sp)
40f089e8:	00112e23          	sw	ra,28(sp)
40f089ec:	00912a23          	sw	s1,20(sp)
40f089f0:	02010413          	addi	s0,sp,32
	int ret = 0;
	ulong cen = -1UL;
	ulong prev_mode = (regs->mstatus & MSTATUS_MPP) >> MSTATUS_MPP_SHIFT;
40f089f4:	08564783          	lbu	a5,133(a2)
#if __riscv_xlen == 32
	bool virt = (regs->mstatusH & MSTATUSH_MPV) ? TRUE : FALSE;
40f089f8:	08864483          	lbu	s1,136(a2)
{
40f089fc:	00068813          	mv	a6,a3
	ulong prev_mode = (regs->mstatus & MSTATUS_MPP) >> MSTATUS_MPP_SHIFT;
40f08a00:	0037d613          	srli	a2,a5,0x3
40f08a04:	00367613          	andi	a2,a2,3
	bool virt = (regs->mstatusH & MSTATUSH_MPV) ? TRUE : FALSE;
40f08a08:	0074d493          	srli	s1,s1,0x7
#else
	bool virt = (regs->mstatus & MSTATUS_MPV) ? TRUE : FALSE;
#endif

	if (prev_mode == PRV_U)
40f08a0c:	06061063          	bnez	a2,40f08a6c <sbi_emulate_csr_read+0x8c>
		cen = csr_read(CSR_SCOUNTEREN);
40f08a10:	106026f3          	csrr	a3,scounteren

	switch (csr_num) {
40f08a14:	000017b7          	lui	a5,0x1
40f08a18:	b8378893          	addi	a7,a5,-1149 # b83 <_fw_start-0x40eff47d>
40f08a1c:	25150863          	beq	a0,a7,40f08c6c <sbi_emulate_csr_read+0x28c>
40f08a20:	16a8d263          	bge	a7,a0,40f08b84 <sbi_emulate_csr_read+0x1a4>
40f08a24:	c0278613          	addi	a2,a5,-1022
40f08a28:	1ec50e63          	beq	a0,a2,40f08c24 <sbi_emulate_csr_read+0x244>
40f08a2c:	12a64463          	blt	a2,a0,40f08b54 <sbi_emulate_csr_read+0x174>
40f08a30:	c0078613          	addi	a2,a5,-1024
40f08a34:	1cc50c63          	beq	a0,a2,40f08c0c <sbi_emulate_csr_read+0x22c>
40f08a38:	20a64463          	blt	a2,a0,40f08c40 <sbi_emulate_csr_read+0x260>
40f08a3c:	b8478793          	addi	a5,a5,-1148
40f08a40:	08f51263          	bne	a0,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
40f08a44:	0046d693          	srli	a3,a3,0x4
40f08a48:	0016f693          	andi	a3,a3,1
		if (!((cen >> (3 + CSR_MHPMCOUNTER3 - CSR_MHPMCOUNTER3)) & 1))
			return -1;
		*csr_val = csr_read(CSR_MHPMCOUNTER3H);
		break;
	case CSR_MHPMCOUNTER4H:
		if (!((cen >> (3 + CSR_MHPMCOUNTER4 - CSR_MHPMCOUNTER3)) & 1))
40f08a4c:	04069863          	bnez	a3,40f08a9c <sbi_emulate_csr_read+0xbc>
			return -1;
40f08a50:	fff00493          	li	s1,-1
	if (ret)
		sbi_dprintf(scratch, "%s: hartid%d: invalid csr_num=0x%x\n",
			    __func__, hartid, csr_num);

	return ret;
}
40f08a54:	01c12083          	lw	ra,28(sp)
40f08a58:	01812403          	lw	s0,24(sp)
40f08a5c:	00048513          	mv	a0,s1
40f08a60:	01412483          	lw	s1,20(sp)
40f08a64:	02010113          	addi	sp,sp,32
40f08a68:	00008067          	ret
	switch (csr_num) {
40f08a6c:	000017b7          	lui	a5,0x1
40f08a70:	b8378693          	addi	a3,a5,-1149 # b83 <_fw_start-0x40eff47d>
40f08a74:	20d50263          	beq	a0,a3,40f08c78 <sbi_emulate_csr_read+0x298>
40f08a78:	06a6da63          	bge	a3,a0,40f08aec <sbi_emulate_csr_read+0x10c>
40f08a7c:	c0278693          	addi	a3,a5,-1022
40f08a80:	1ad50863          	beq	a0,a3,40f08c30 <sbi_emulate_csr_read+0x250>
40f08a84:	02a6c463          	blt	a3,a0,40f08aac <sbi_emulate_csr_read+0xcc>
40f08a88:	c0078693          	addi	a3,a5,-1024
40f08a8c:	18d50463          	beq	a0,a3,40f08c14 <sbi_emulate_csr_read+0x234>
40f08a90:	1aa6ce63          	blt	a3,a0,40f08c4c <sbi_emulate_csr_read+0x26c>
40f08a94:	b8478793          	addi	a5,a5,-1148
40f08a98:	02f51663          	bne	a0,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
		*csr_val = csr_read(CSR_MHPMCOUNTER4H);
40f08a9c:	b84027f3          	csrr	a5,mhpmcounter4h
	int ret = 0;
40f08aa0:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MHPMCOUNTER4H);
40f08aa4:	00f72023          	sw	a5,0(a4) # 4000 <_fw_start-0x40efc000>
	if (ret)
40f08aa8:	fadff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
	switch (csr_num) {
40f08aac:	c8178693          	addi	a3,a5,-895
40f08ab0:	20d50063          	beq	a0,a3,40f08cb0 <sbi_emulate_csr_read+0x2d0>
40f08ab4:	c8278693          	addi	a3,a5,-894
40f08ab8:	14d50263          	beq	a0,a3,40f08bfc <sbi_emulate_csr_read+0x21c>
40f08abc:	c8078793          	addi	a5,a5,-896
40f08ac0:	0af50a63          	beq	a0,a5,40f08b74 <sbi_emulate_csr_read+0x194>
		sbi_dprintf(scratch, "%s: hartid%d: invalid csr_num=0x%x\n",
40f08ac4:	00050713          	mv	a4,a0
40f08ac8:	00058693          	mv	a3,a1
40f08acc:	00002617          	auipc	a2,0x2
40f08ad0:	df060613          	addi	a2,a2,-528 # 40f0a8bc <__func__.1168>
40f08ad4:	00002597          	auipc	a1,0x2
40f08ad8:	e1858593          	addi	a1,a1,-488 # 40f0a8ec <__func__.1203+0x18>
40f08adc:	00080513          	mv	a0,a6
40f08ae0:	ba1fc0ef          	jal	ra,40f05680 <sbi_dprintf>
40f08ae4:	ffe00493          	li	s1,-2
40f08ae8:	f6dff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
	switch (csr_num) {
40f08aec:	60500693          	li	a3,1541
40f08af0:	0cd50663          	beq	a0,a3,40f08bbc <sbi_emulate_csr_read+0x1dc>
40f08af4:	04a6d063          	bge	a3,a0,40f08b34 <sbi_emulate_csr_read+0x154>
40f08af8:	b0378693          	addi	a3,a5,-1277
40f08afc:	18d50c63          	beq	a0,a3,40f08c94 <sbi_emulate_csr_read+0x2b4>
40f08b00:	b0478793          	addi	a5,a5,-1276
40f08b04:	0af50463          	beq	a0,a5,40f08bac <sbi_emulate_csr_read+0x1cc>
40f08b08:	61500793          	li	a5,1557
40f08b0c:	faf51ce3          	bne	a0,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
40f08b10:	fee42623          	sw	a4,-20(s0)
		if (prev_mode == PRV_S && !virt)
40f08b14:	00100793          	li	a5,1
40f08b18:	faf616e3          	bne	a2,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
40f08b1c:	fa0494e3          	bnez	s1,40f08ac4 <sbi_emulate_csr_read+0xe4>
			*csr_val = sbi_timer_get_delta(scratch) >> 32;
40f08b20:	00080513          	mv	a0,a6
40f08b24:	c18f90ef          	jal	ra,40f01f3c <sbi_timer_get_delta>
40f08b28:	fec42703          	lw	a4,-20(s0)
40f08b2c:	00b72023          	sw	a1,0(a4)
	if (ret)
40f08b30:	f25ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
	switch (csr_num) {
40f08b34:	32300793          	li	a5,803
40f08b38:	0af50463          	beq	a0,a5,40f08be0 <sbi_emulate_csr_read+0x200>
40f08b3c:	32400793          	li	a5,804
40f08b40:	f8f512e3          	bne	a0,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
		*csr_val = csr_read(CSR_MHPMEVENT4);
40f08b44:	324027f3          	csrr	a5,mhpmevent4
	int ret = 0;
40f08b48:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MHPMEVENT4);
40f08b4c:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08b50:	f05ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
	switch (csr_num) {
40f08b54:	c8178613          	addi	a2,a5,-895
40f08b58:	14c50663          	beq	a0,a2,40f08ca4 <sbi_emulate_csr_read+0x2c4>
40f08b5c:	c8278613          	addi	a2,a5,-894
40f08b60:	08c50863          	beq	a0,a2,40f08bf0 <sbi_emulate_csr_read+0x210>
40f08b64:	c8078793          	addi	a5,a5,-896
40f08b68:	f4f51ee3          	bne	a0,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
40f08b6c:	0016f693          	andi	a3,a3,1
		if (!((cen >> (CSR_CYCLE - CSR_CYCLE)) & 1))
40f08b70:	ee0680e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MCYCLEH);
40f08b74:	b80027f3          	csrr	a5,mcycleh
	int ret = 0;
40f08b78:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MCYCLEH);
40f08b7c:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08b80:	ed5ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
	switch (csr_num) {
40f08b84:	60500893          	li	a7,1541
40f08b88:	03150a63          	beq	a0,a7,40f08bbc <sbi_emulate_csr_read+0x1dc>
40f08b8c:	faa8d4e3          	bge	a7,a0,40f08b34 <sbi_emulate_csr_read+0x154>
40f08b90:	b0378893          	addi	a7,a5,-1277
40f08b94:	0f150a63          	beq	a0,a7,40f08c88 <sbi_emulate_csr_read+0x2a8>
40f08b98:	b0478793          	addi	a5,a5,-1276
40f08b9c:	f6f516e3          	bne	a0,a5,40f08b08 <sbi_emulate_csr_read+0x128>
40f08ba0:	0046d693          	srli	a3,a3,0x4
40f08ba4:	0016f693          	andi	a3,a3,1
		if (!((cen >> (3 + CSR_MHPMCOUNTER4 - CSR_MHPMCOUNTER3)) & 1))
40f08ba8:	ea0684e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MHPMCOUNTER4);
40f08bac:	b04027f3          	csrr	a5,mhpmcounter4
	int ret = 0;
40f08bb0:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MHPMCOUNTER4);
40f08bb4:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08bb8:	e9dff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
40f08bbc:	fee42623          	sw	a4,-20(s0)
		if (prev_mode == PRV_S && !virt)
40f08bc0:	00100793          	li	a5,1
40f08bc4:	f0f610e3          	bne	a2,a5,40f08ac4 <sbi_emulate_csr_read+0xe4>
40f08bc8:	ee049ee3          	bnez	s1,40f08ac4 <sbi_emulate_csr_read+0xe4>
			*csr_val = sbi_timer_get_delta(scratch);
40f08bcc:	00080513          	mv	a0,a6
40f08bd0:	b6cf90ef          	jal	ra,40f01f3c <sbi_timer_get_delta>
40f08bd4:	fec42703          	lw	a4,-20(s0)
40f08bd8:	00a72023          	sw	a0,0(a4)
	if (ret)
40f08bdc:	e79ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
		*csr_val = csr_read(CSR_MHPMEVENT3);
40f08be0:	323027f3          	csrr	a5,mhpmevent3
	int ret = 0;
40f08be4:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MHPMEVENT3);
40f08be8:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08bec:	e69ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
40f08bf0:	0026d693          	srli	a3,a3,0x2
40f08bf4:	0016f693          	andi	a3,a3,1
		if (!((cen >> (CSR_INSTRET - CSR_CYCLE)) & 1))
40f08bf8:	e4068ce3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MINSTRETH);
40f08bfc:	b82027f3          	csrr	a5,minstreth
	int ret = 0;
40f08c00:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MINSTRETH);
40f08c04:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08c08:	e4dff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
		if (!((cen >> (CSR_CYCLE - CSR_CYCLE)) & 1))
40f08c0c:	0016f693          	andi	a3,a3,1
40f08c10:	e40680e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MCYCLE);
40f08c14:	b00027f3          	csrr	a5,mcycle
	int ret = 0;
40f08c18:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MCYCLE);
40f08c1c:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08c20:	e35ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
40f08c24:	0026d693          	srli	a3,a3,0x2
40f08c28:	0016f693          	andi	a3,a3,1
		if (!((cen >> (CSR_INSTRET - CSR_CYCLE)) & 1))
40f08c2c:	e20682e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MINSTRET);
40f08c30:	b02027f3          	csrr	a5,minstret
	int ret = 0;
40f08c34:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MINSTRET);
40f08c38:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08c3c:	e19ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
		if (!((cen >> (CSR_TIME - CSR_CYCLE)) & 1))
40f08c40:	0016d693          	srli	a3,a3,0x1
40f08c44:	0016f693          	andi	a3,a3,1
40f08c48:	e00684e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = (virt) ? sbi_timer_virt_value(scratch):
40f08c4c:	fee42623          	sw	a4,-20(s0)
40f08c50:	00080513          	mv	a0,a6
40f08c54:	08049463          	bnez	s1,40f08cdc <sbi_emulate_csr_read+0x2fc>
				    sbi_timer_value(scratch);
40f08c58:	9bcf90ef          	jal	ra,40f01e14 <sbi_timer_value>
40f08c5c:	fec42703          	lw	a4,-20(s0)
		*csr_val = (virt) ? sbi_timer_virt_value(scratch):
40f08c60:	00a72023          	sw	a0,0(a4)
	int ret = 0;
40f08c64:	00000493          	li	s1,0
40f08c68:	dedff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
40f08c6c:	0036d693          	srli	a3,a3,0x3
40f08c70:	0016f693          	andi	a3,a3,1
		if (!((cen >> (3 + CSR_MHPMCOUNTER3 - CSR_MHPMCOUNTER3)) & 1))
40f08c74:	dc068ee3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MHPMCOUNTER3H);
40f08c78:	b83027f3          	csrr	a5,mhpmcounter3h
	int ret = 0;
40f08c7c:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MHPMCOUNTER3H);
40f08c80:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08c84:	dd1ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
		if (!((cen >> (3 + CSR_MHPMCOUNTER3 - CSR_MHPMCOUNTER3)) & 1))
40f08c88:	0036d693          	srli	a3,a3,0x3
40f08c8c:	0016f693          	andi	a3,a3,1
40f08c90:	dc0680e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = csr_read(CSR_MHPMCOUNTER3);
40f08c94:	b03027f3          	csrr	a5,mhpmcounter3
	int ret = 0;
40f08c98:	00000493          	li	s1,0
		*csr_val = csr_read(CSR_MHPMCOUNTER3);
40f08c9c:	00f72023          	sw	a5,0(a4)
	if (ret)
40f08ca0:	db5ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
40f08ca4:	0016d693          	srli	a3,a3,0x1
40f08ca8:	0016f693          	andi	a3,a3,1
		if (!((cen >> (CSR_TIME - CSR_CYCLE)) & 1))
40f08cac:	da0682e3          	beqz	a3,40f08a50 <sbi_emulate_csr_read+0x70>
		*csr_val = (virt) ? sbi_timer_virt_value(scratch) >> 32:
40f08cb0:	fee42623          	sw	a4,-20(s0)
40f08cb4:	00080513          	mv	a0,a6
40f08cb8:	00049c63          	bnez	s1,40f08cd0 <sbi_emulate_csr_read+0x2f0>
				    sbi_timer_value(scratch) >> 32;
40f08cbc:	958f90ef          	jal	ra,40f01e14 <sbi_timer_value>
40f08cc0:	fec42703          	lw	a4,-20(s0)
		*csr_val = (virt) ? sbi_timer_virt_value(scratch) >> 32:
40f08cc4:	00b72023          	sw	a1,0(a4)
	int ret = 0;
40f08cc8:	00000493          	li	s1,0
40f08ccc:	d89ff06f          	j	40f08a54 <sbi_emulate_csr_read+0x74>
		*csr_val = (virt) ? sbi_timer_virt_value(scratch) >> 32:
40f08cd0:	a14f90ef          	jal	ra,40f01ee4 <sbi_timer_virt_value>
40f08cd4:	fec42703          	lw	a4,-20(s0)
40f08cd8:	fedff06f          	j	40f08cc4 <sbi_emulate_csr_read+0x2e4>
		*csr_val = (virt) ? sbi_timer_virt_value(scratch):
40f08cdc:	a08f90ef          	jal	ra,40f01ee4 <sbi_timer_virt_value>
40f08ce0:	fec42703          	lw	a4,-20(s0)
40f08ce4:	f7dff06f          	j	40f08c60 <sbi_emulate_csr_read+0x280>

40f08ce8 <sbi_emulate_csr_write>:

int sbi_emulate_csr_write(int csr_num, u32 hartid, struct sbi_trap_regs *regs,
			  struct sbi_scratch *scratch, ulong csr_val)
{
40f08ce8:	ff010113          	addi	sp,sp,-16
40f08cec:	00812423          	sw	s0,8(sp)
40f08cf0:	00112623          	sw	ra,12(sp)
40f08cf4:	00912223          	sw	s1,4(sp)
40f08cf8:	01010413          	addi	s0,sp,16
	int ret = 0;
	ulong prev_mode = (regs->mstatus & MSTATUS_MPP) >> MSTATUS_MPP_SHIFT;
40f08cfc:	08564783          	lbu	a5,133(a2)
#if __riscv_xlen == 32
	bool virt = (regs->mstatusH & MSTATUSH_MPV) ? TRUE : FALSE;
40f08d00:	08864483          	lbu	s1,136(a2)
#else
	bool virt = (regs->mstatus & MSTATUS_MPV) ? TRUE : FALSE;
#endif

	switch (csr_num) {
40f08d04:	00001637          	lui	a2,0x1
40f08d08:	b0460893          	addi	a7,a2,-1276 # b04 <_fw_start-0x40eff4fc>
40f08d0c:	0d150c63          	beq	a0,a7,40f08de4 <sbi_emulate_csr_write+0xfc>
40f08d10:	00068313          	mv	t1,a3
40f08d14:	08a8d063          	bge	a7,a0,40f08d94 <sbi_emulate_csr_write+0xac>
40f08d18:	c0060813          	addi	a6,a2,-1024
40f08d1c:	0d050a63          	beq	a0,a6,40f08df0 <sbi_emulate_csr_write+0x108>
40f08d20:	04a85c63          	bge	a6,a0,40f08d78 <sbi_emulate_csr_write+0x90>
40f08d24:	c8060813          	addi	a6,a2,-896
40f08d28:	0d050a63          	beq	a0,a6,40f08dfc <sbi_emulate_csr_write+0x114>
40f08d2c:	c8260813          	addi	a6,a2,-894
40f08d30:	0d050c63          	beq	a0,a6,40f08e08 <sbi_emulate_csr_write+0x120>
40f08d34:	c0260613          	addi	a2,a2,-1022
40f08d38:	0cc50e63          	beq	a0,a2,40f08e14 <sbi_emulate_csr_write+0x12c>
		ret = SBI_ENOTSUPP;
		break;
	};

	if (ret)
		sbi_dprintf(scratch, "%s: hartid%d: invalid csr_num=0x%x\n",
40f08d3c:	00050713          	mv	a4,a0
40f08d40:	00058693          	mv	a3,a1
40f08d44:	00002617          	auipc	a2,0x2
40f08d48:	b9060613          	addi	a2,a2,-1136 # 40f0a8d4 <__func__.1203>
40f08d4c:	00002597          	auipc	a1,0x2
40f08d50:	ba058593          	addi	a1,a1,-1120 # 40f0a8ec <__func__.1203+0x18>
40f08d54:	00030513          	mv	a0,t1
40f08d58:	929fc0ef          	jal	ra,40f05680 <sbi_dprintf>
40f08d5c:	ffe00493          	li	s1,-2
			    __func__, hartid, csr_num);

	return ret;
}
40f08d60:	00c12083          	lw	ra,12(sp)
40f08d64:	00812403          	lw	s0,8(sp)
40f08d68:	00048513          	mv	a0,s1
40f08d6c:	00412483          	lw	s1,4(sp)
40f08d70:	01010113          	addi	sp,sp,16
40f08d74:	00008067          	ret
	switch (csr_num) {
40f08d78:	b8360813          	addi	a6,a2,-1149
40f08d7c:	0b050263          	beq	a0,a6,40f08e20 <sbi_emulate_csr_write+0x138>
40f08d80:	b8460613          	addi	a2,a2,-1148
40f08d84:	fac51ce3          	bne	a0,a2,40f08d3c <sbi_emulate_csr_write+0x54>
		csr_write(CSR_MHPMCOUNTER4H, csr_val);
40f08d88:	b8471073          	csrw	mhpmcounter4h,a4
	int ret = 0;
40f08d8c:	00000493          	li	s1,0
40f08d90:	fd1ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
40f08d94:	0037d793          	srli	a5,a5,0x3
	switch (csr_num) {
40f08d98:	60500893          	li	a7,1541
40f08d9c:	0037f813          	andi	a6,a5,3
40f08da0:	0074d493          	srli	s1,s1,0x7
40f08da4:	09150463          	beq	a0,a7,40f08e2c <sbi_emulate_csr_write+0x144>
40f08da8:	02a8d063          	bge	a7,a0,40f08dc8 <sbi_emulate_csr_write+0xe0>
40f08dac:	61500893          	li	a7,1557
40f08db0:	09150c63          	beq	a0,a7,40f08e48 <sbi_emulate_csr_write+0x160>
40f08db4:	b0360613          	addi	a2,a2,-1277
40f08db8:	f8c512e3          	bne	a0,a2,40f08d3c <sbi_emulate_csr_write+0x54>
		csr_write(CSR_MHPMCOUNTER3, csr_val);
40f08dbc:	b0371073          	csrw	mhpmcounter3,a4
	int ret = 0;
40f08dc0:	00000493          	li	s1,0
40f08dc4:	f9dff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
	switch (csr_num) {
40f08dc8:	32300613          	li	a2,803
40f08dcc:	08c50c63          	beq	a0,a2,40f08e64 <sbi_emulate_csr_write+0x17c>
40f08dd0:	32400613          	li	a2,804
40f08dd4:	f6c514e3          	bne	a0,a2,40f08d3c <sbi_emulate_csr_write+0x54>
		csr_write(CSR_MHPMEVENT4, csr_val);
40f08dd8:	32471073          	csrw	mhpmevent4,a4
	int ret = 0;
40f08ddc:	00000493          	li	s1,0
40f08de0:	f81ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MHPMCOUNTER4, csr_val);
40f08de4:	b0471073          	csrw	mhpmcounter4,a4
	int ret = 0;
40f08de8:	00000493          	li	s1,0
40f08dec:	f75ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MCYCLE, csr_val);
40f08df0:	b0071073          	csrw	mcycle,a4
	int ret = 0;
40f08df4:	00000493          	li	s1,0
40f08df8:	f69ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MCYCLEH, csr_val);
40f08dfc:	b8071073          	csrw	mcycleh,a4
	int ret = 0;
40f08e00:	00000493          	li	s1,0
40f08e04:	f5dff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MINSTRETH, csr_val);
40f08e08:	b8271073          	csrw	minstreth,a4
	int ret = 0;
40f08e0c:	00000493          	li	s1,0
40f08e10:	f51ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MINSTRET, csr_val);
40f08e14:	b0271073          	csrw	minstret,a4
	int ret = 0;
40f08e18:	00000493          	li	s1,0
40f08e1c:	f45ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MHPMCOUNTER3H, csr_val);
40f08e20:	b8371073          	csrw	mhpmcounter3h,a4
	int ret = 0;
40f08e24:	00000493          	li	s1,0
40f08e28:	f39ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		if (prev_mode == PRV_S && !virt)
40f08e2c:	00100693          	li	a3,1
40f08e30:	f0d816e3          	bne	a6,a3,40f08d3c <sbi_emulate_csr_write+0x54>
40f08e34:	f00494e3          	bnez	s1,40f08d3c <sbi_emulate_csr_write+0x54>
			sbi_timer_set_delta(scratch, csr_val);
40f08e38:	00070593          	mv	a1,a4
40f08e3c:	00030513          	mv	a0,t1
40f08e40:	92cf90ef          	jal	ra,40f01f6c <sbi_timer_set_delta>
	if (ret)
40f08e44:	f1dff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		if (prev_mode == PRV_S && !virt)
40f08e48:	00100693          	li	a3,1
40f08e4c:	eed818e3          	bne	a6,a3,40f08d3c <sbi_emulate_csr_write+0x54>
40f08e50:	ee0496e3          	bnez	s1,40f08d3c <sbi_emulate_csr_write+0x54>
			sbi_timer_set_delta_upper(scratch, csr_val);
40f08e54:	00070593          	mv	a1,a4
40f08e58:	00030513          	mv	a0,t1
40f08e5c:	940f90ef          	jal	ra,40f01f9c <sbi_timer_set_delta_upper>
	if (ret)
40f08e60:	f01ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>
		csr_write(CSR_MHPMEVENT3, csr_val);
40f08e64:	32371073          	csrw	mhpmevent3,a4
	int ret = 0;
40f08e68:	00000493          	li	s1,0
40f08e6c:	ef5ff06f          	j	40f08d60 <sbi_emulate_csr_write+0x78>

40f08e70 <__udivdi3>:
40f08e70:	fd010113          	addi	sp,sp,-48
40f08e74:	02912223          	sw	s1,36(sp)
40f08e78:	01612823          	sw	s6,16(sp)
40f08e7c:	02112623          	sw	ra,44(sp)
40f08e80:	02812423          	sw	s0,40(sp)
40f08e84:	03212023          	sw	s2,32(sp)
40f08e88:	01312e23          	sw	s3,28(sp)
40f08e8c:	01412c23          	sw	s4,24(sp)
40f08e90:	01512a23          	sw	s5,20(sp)
40f08e94:	01712623          	sw	s7,12(sp)
40f08e98:	01812423          	sw	s8,8(sp)
40f08e9c:	01912223          	sw	s9,4(sp)
40f08ea0:	00050b13          	mv	s6,a0
40f08ea4:	00058493          	mv	s1,a1
40f08ea8:	38069c63          	bnez	a3,40f09240 <__udivdi3+0x3d0>
40f08eac:	00060413          	mv	s0,a2
40f08eb0:	00050993          	mv	s3,a0
40f08eb4:	00002917          	auipc	s2,0x2
40f08eb8:	a5c90913          	addi	s2,s2,-1444 # 40f0a910 <__clz_tab>
40f08ebc:	12c5f863          	bgeu	a1,a2,40f08fec <__udivdi3+0x17c>
40f08ec0:	000107b7          	lui	a5,0x10
40f08ec4:	00058a93          	mv	s5,a1
40f08ec8:	10f67863          	bgeu	a2,a5,40f08fd8 <__udivdi3+0x168>
40f08ecc:	0ff00693          	li	a3,255
40f08ed0:	00c6b6b3          	sltu	a3,a3,a2
40f08ed4:	00369693          	slli	a3,a3,0x3
40f08ed8:	00d657b3          	srl	a5,a2,a3
40f08edc:	00f90933          	add	s2,s2,a5
40f08ee0:	00094703          	lbu	a4,0(s2)
40f08ee4:	00d706b3          	add	a3,a4,a3
40f08ee8:	02000713          	li	a4,32
40f08eec:	40d70733          	sub	a4,a4,a3
40f08ef0:	00070c63          	beqz	a4,40f08f08 <__udivdi3+0x98>
40f08ef4:	00e494b3          	sll	s1,s1,a4
40f08ef8:	00db56b3          	srl	a3,s6,a3
40f08efc:	00e61433          	sll	s0,a2,a4
40f08f00:	0096eab3          	or	s5,a3,s1
40f08f04:	00eb19b3          	sll	s3,s6,a4
40f08f08:	01045b13          	srli	s6,s0,0x10
40f08f0c:	000b0593          	mv	a1,s6
40f08f10:	000a8513          	mv	a0,s5
40f08f14:	295000ef          	jal	ra,40f099a8 <__umodsi3>
40f08f18:	00050913          	mv	s2,a0
40f08f1c:	000b0593          	mv	a1,s6
40f08f20:	01041b93          	slli	s7,s0,0x10
40f08f24:	000a8513          	mv	a0,s5
40f08f28:	239000ef          	jal	ra,40f09960 <__udivsi3>
40f08f2c:	010bdb93          	srli	s7,s7,0x10
40f08f30:	00050493          	mv	s1,a0
40f08f34:	00050593          	mv	a1,a0
40f08f38:	000b8513          	mv	a0,s7
40f08f3c:	1f9000ef          	jal	ra,40f09934 <__mulsi3>
40f08f40:	01091913          	slli	s2,s2,0x10
40f08f44:	0109d713          	srli	a4,s3,0x10
40f08f48:	00e96733          	or	a4,s2,a4
40f08f4c:	00048a13          	mv	s4,s1
40f08f50:	00a77e63          	bgeu	a4,a0,40f08f6c <__udivdi3+0xfc>
40f08f54:	00870733          	add	a4,a4,s0
40f08f58:	fff48a13          	addi	s4,s1,-1
40f08f5c:	00876863          	bltu	a4,s0,40f08f6c <__udivdi3+0xfc>
40f08f60:	00a77663          	bgeu	a4,a0,40f08f6c <__udivdi3+0xfc>
40f08f64:	ffe48a13          	addi	s4,s1,-2
40f08f68:	00870733          	add	a4,a4,s0
40f08f6c:	40a704b3          	sub	s1,a4,a0
40f08f70:	000b0593          	mv	a1,s6
40f08f74:	00048513          	mv	a0,s1
40f08f78:	231000ef          	jal	ra,40f099a8 <__umodsi3>
40f08f7c:	00050913          	mv	s2,a0
40f08f80:	000b0593          	mv	a1,s6
40f08f84:	00048513          	mv	a0,s1
40f08f88:	1d9000ef          	jal	ra,40f09960 <__udivsi3>
40f08f8c:	01099993          	slli	s3,s3,0x10
40f08f90:	00050493          	mv	s1,a0
40f08f94:	00050593          	mv	a1,a0
40f08f98:	01091913          	slli	s2,s2,0x10
40f08f9c:	000b8513          	mv	a0,s7
40f08fa0:	0109d993          	srli	s3,s3,0x10
40f08fa4:	191000ef          	jal	ra,40f09934 <__mulsi3>
40f08fa8:	013969b3          	or	s3,s2,s3
40f08fac:	00048613          	mv	a2,s1
40f08fb0:	00a9fc63          	bgeu	s3,a0,40f08fc8 <__udivdi3+0x158>
40f08fb4:	013409b3          	add	s3,s0,s3
40f08fb8:	fff48613          	addi	a2,s1,-1
40f08fbc:	0089e663          	bltu	s3,s0,40f08fc8 <__udivdi3+0x158>
40f08fc0:	00a9f463          	bgeu	s3,a0,40f08fc8 <__udivdi3+0x158>
40f08fc4:	ffe48613          	addi	a2,s1,-2
40f08fc8:	010a1793          	slli	a5,s4,0x10
40f08fcc:	00c7e7b3          	or	a5,a5,a2
40f08fd0:	00000a13          	li	s4,0
40f08fd4:	1300006f          	j	40f09104 <__udivdi3+0x294>
40f08fd8:	010007b7          	lui	a5,0x1000
40f08fdc:	01000693          	li	a3,16
40f08fe0:	eef66ce3          	bltu	a2,a5,40f08ed8 <__udivdi3+0x68>
40f08fe4:	01800693          	li	a3,24
40f08fe8:	ef1ff06f          	j	40f08ed8 <__udivdi3+0x68>
40f08fec:	00068a13          	mv	s4,a3
40f08ff0:	00061a63          	bnez	a2,40f09004 <__udivdi3+0x194>
40f08ff4:	00000593          	li	a1,0
40f08ff8:	00100513          	li	a0,1
40f08ffc:	165000ef          	jal	ra,40f09960 <__udivsi3>
40f09000:	00050413          	mv	s0,a0
40f09004:	000107b7          	lui	a5,0x10
40f09008:	12f47c63          	bgeu	s0,a5,40f09140 <__udivdi3+0x2d0>
40f0900c:	0ff00793          	li	a5,255
40f09010:	0087f463          	bgeu	a5,s0,40f09018 <__udivdi3+0x1a8>
40f09014:	00800a13          	li	s4,8
40f09018:	014457b3          	srl	a5,s0,s4
40f0901c:	00f90933          	add	s2,s2,a5
40f09020:	00094683          	lbu	a3,0(s2)
40f09024:	02000613          	li	a2,32
40f09028:	014686b3          	add	a3,a3,s4
40f0902c:	40d60633          	sub	a2,a2,a3
40f09030:	12061263          	bnez	a2,40f09154 <__udivdi3+0x2e4>
40f09034:	408484b3          	sub	s1,s1,s0
40f09038:	00100a13          	li	s4,1
40f0903c:	01045b13          	srli	s6,s0,0x10
40f09040:	000b0593          	mv	a1,s6
40f09044:	00048513          	mv	a0,s1
40f09048:	161000ef          	jal	ra,40f099a8 <__umodsi3>
40f0904c:	00050913          	mv	s2,a0
40f09050:	000b0593          	mv	a1,s6
40f09054:	00048513          	mv	a0,s1
40f09058:	01041b93          	slli	s7,s0,0x10
40f0905c:	105000ef          	jal	ra,40f09960 <__udivsi3>
40f09060:	010bdb93          	srli	s7,s7,0x10
40f09064:	00050493          	mv	s1,a0
40f09068:	00050593          	mv	a1,a0
40f0906c:	000b8513          	mv	a0,s7
40f09070:	0c5000ef          	jal	ra,40f09934 <__mulsi3>
40f09074:	01091913          	slli	s2,s2,0x10
40f09078:	0109d713          	srli	a4,s3,0x10
40f0907c:	00e96733          	or	a4,s2,a4
40f09080:	00048a93          	mv	s5,s1
40f09084:	00a77e63          	bgeu	a4,a0,40f090a0 <__udivdi3+0x230>
40f09088:	00870733          	add	a4,a4,s0
40f0908c:	fff48a93          	addi	s5,s1,-1
40f09090:	00876863          	bltu	a4,s0,40f090a0 <__udivdi3+0x230>
40f09094:	00a77663          	bgeu	a4,a0,40f090a0 <__udivdi3+0x230>
40f09098:	ffe48a93          	addi	s5,s1,-2
40f0909c:	00870733          	add	a4,a4,s0
40f090a0:	40a704b3          	sub	s1,a4,a0
40f090a4:	000b0593          	mv	a1,s6
40f090a8:	00048513          	mv	a0,s1
40f090ac:	0fd000ef          	jal	ra,40f099a8 <__umodsi3>
40f090b0:	00050913          	mv	s2,a0
40f090b4:	000b0593          	mv	a1,s6
40f090b8:	00048513          	mv	a0,s1
40f090bc:	0a5000ef          	jal	ra,40f09960 <__udivsi3>
40f090c0:	01099993          	slli	s3,s3,0x10
40f090c4:	00050493          	mv	s1,a0
40f090c8:	00050593          	mv	a1,a0
40f090cc:	01091913          	slli	s2,s2,0x10
40f090d0:	000b8513          	mv	a0,s7
40f090d4:	0109d993          	srli	s3,s3,0x10
40f090d8:	05d000ef          	jal	ra,40f09934 <__mulsi3>
40f090dc:	013969b3          	or	s3,s2,s3
40f090e0:	00048613          	mv	a2,s1
40f090e4:	00a9fc63          	bgeu	s3,a0,40f090fc <__udivdi3+0x28c>
40f090e8:	013409b3          	add	s3,s0,s3
40f090ec:	fff48613          	addi	a2,s1,-1
40f090f0:	0089e663          	bltu	s3,s0,40f090fc <__udivdi3+0x28c>
40f090f4:	00a9f463          	bgeu	s3,a0,40f090fc <__udivdi3+0x28c>
40f090f8:	ffe48613          	addi	a2,s1,-2
40f090fc:	010a9793          	slli	a5,s5,0x10
40f09100:	00c7e7b3          	or	a5,a5,a2
40f09104:	00078513          	mv	a0,a5
40f09108:	000a0593          	mv	a1,s4
40f0910c:	02c12083          	lw	ra,44(sp)
40f09110:	02812403          	lw	s0,40(sp)
40f09114:	02412483          	lw	s1,36(sp)
40f09118:	02012903          	lw	s2,32(sp)
40f0911c:	01c12983          	lw	s3,28(sp)
40f09120:	01812a03          	lw	s4,24(sp)
40f09124:	01412a83          	lw	s5,20(sp)
40f09128:	01012b03          	lw	s6,16(sp)
40f0912c:	00c12b83          	lw	s7,12(sp)
40f09130:	00812c03          	lw	s8,8(sp)
40f09134:	00412c83          	lw	s9,4(sp)
40f09138:	03010113          	addi	sp,sp,48
40f0913c:	00008067          	ret
40f09140:	010007b7          	lui	a5,0x1000
40f09144:	01000a13          	li	s4,16
40f09148:	ecf468e3          	bltu	s0,a5,40f09018 <__udivdi3+0x1a8>
40f0914c:	01800a13          	li	s4,24
40f09150:	ec9ff06f          	j	40f09018 <__udivdi3+0x1a8>
40f09154:	00c41433          	sll	s0,s0,a2
40f09158:	00d4da33          	srl	s4,s1,a3
40f0915c:	00cb19b3          	sll	s3,s6,a2
40f09160:	00db56b3          	srl	a3,s6,a3
40f09164:	01045b13          	srli	s6,s0,0x10
40f09168:	00c494b3          	sll	s1,s1,a2
40f0916c:	000b0593          	mv	a1,s6
40f09170:	000a0513          	mv	a0,s4
40f09174:	0096eab3          	or	s5,a3,s1
40f09178:	031000ef          	jal	ra,40f099a8 <__umodsi3>
40f0917c:	00050913          	mv	s2,a0
40f09180:	000b0593          	mv	a1,s6
40f09184:	000a0513          	mv	a0,s4
40f09188:	01041b93          	slli	s7,s0,0x10
40f0918c:	7d4000ef          	jal	ra,40f09960 <__udivsi3>
40f09190:	010bdb93          	srli	s7,s7,0x10
40f09194:	00050493          	mv	s1,a0
40f09198:	00050593          	mv	a1,a0
40f0919c:	000b8513          	mv	a0,s7
40f091a0:	794000ef          	jal	ra,40f09934 <__mulsi3>
40f091a4:	01091913          	slli	s2,s2,0x10
40f091a8:	010ad713          	srli	a4,s5,0x10
40f091ac:	00e96733          	or	a4,s2,a4
40f091b0:	00048a13          	mv	s4,s1
40f091b4:	00a77e63          	bgeu	a4,a0,40f091d0 <__udivdi3+0x360>
40f091b8:	00870733          	add	a4,a4,s0
40f091bc:	fff48a13          	addi	s4,s1,-1
40f091c0:	00876863          	bltu	a4,s0,40f091d0 <__udivdi3+0x360>
40f091c4:	00a77663          	bgeu	a4,a0,40f091d0 <__udivdi3+0x360>
40f091c8:	ffe48a13          	addi	s4,s1,-2
40f091cc:	00870733          	add	a4,a4,s0
40f091d0:	40a704b3          	sub	s1,a4,a0
40f091d4:	000b0593          	mv	a1,s6
40f091d8:	00048513          	mv	a0,s1
40f091dc:	7cc000ef          	jal	ra,40f099a8 <__umodsi3>
40f091e0:	00050913          	mv	s2,a0
40f091e4:	000b0593          	mv	a1,s6
40f091e8:	00048513          	mv	a0,s1
40f091ec:	774000ef          	jal	ra,40f09960 <__udivsi3>
40f091f0:	00050493          	mv	s1,a0
40f091f4:	00050593          	mv	a1,a0
40f091f8:	000b8513          	mv	a0,s7
40f091fc:	738000ef          	jal	ra,40f09934 <__mulsi3>
40f09200:	010a9693          	slli	a3,s5,0x10
40f09204:	01091913          	slli	s2,s2,0x10
40f09208:	0106d693          	srli	a3,a3,0x10
40f0920c:	00d967b3          	or	a5,s2,a3
40f09210:	00048713          	mv	a4,s1
40f09214:	00a7fe63          	bgeu	a5,a0,40f09230 <__udivdi3+0x3c0>
40f09218:	008787b3          	add	a5,a5,s0
40f0921c:	fff48713          	addi	a4,s1,-1
40f09220:	0087e863          	bltu	a5,s0,40f09230 <__udivdi3+0x3c0>
40f09224:	00a7f663          	bgeu	a5,a0,40f09230 <__udivdi3+0x3c0>
40f09228:	ffe48713          	addi	a4,s1,-2
40f0922c:	008787b3          	add	a5,a5,s0
40f09230:	010a1a13          	slli	s4,s4,0x10
40f09234:	40a784b3          	sub	s1,a5,a0
40f09238:	00ea6a33          	or	s4,s4,a4
40f0923c:	e01ff06f          	j	40f0903c <__udivdi3+0x1cc>
40f09240:	1ed5ec63          	bltu	a1,a3,40f09438 <__udivdi3+0x5c8>
40f09244:	000107b7          	lui	a5,0x10
40f09248:	04f6f463          	bgeu	a3,a5,40f09290 <__udivdi3+0x420>
40f0924c:	0ff00593          	li	a1,255
40f09250:	00d5b533          	sltu	a0,a1,a3
40f09254:	00351513          	slli	a0,a0,0x3
40f09258:	00a6d733          	srl	a4,a3,a0
40f0925c:	00001797          	auipc	a5,0x1
40f09260:	6b478793          	addi	a5,a5,1716 # 40f0a910 <__clz_tab>
40f09264:	00e787b3          	add	a5,a5,a4
40f09268:	0007c583          	lbu	a1,0(a5)
40f0926c:	02000a13          	li	s4,32
40f09270:	00a585b3          	add	a1,a1,a0
40f09274:	40ba0a33          	sub	s4,s4,a1
40f09278:	020a1663          	bnez	s4,40f092a4 <__udivdi3+0x434>
40f0927c:	00100793          	li	a5,1
40f09280:	e896e2e3          	bltu	a3,s1,40f09104 <__udivdi3+0x294>
40f09284:	00cb3633          	sltu	a2,s6,a2
40f09288:	00164793          	xori	a5,a2,1
40f0928c:	e79ff06f          	j	40f09104 <__udivdi3+0x294>
40f09290:	010007b7          	lui	a5,0x1000
40f09294:	01000513          	li	a0,16
40f09298:	fcf6e0e3          	bltu	a3,a5,40f09258 <__udivdi3+0x3e8>
40f0929c:	01800513          	li	a0,24
40f092a0:	fb9ff06f          	j	40f09258 <__udivdi3+0x3e8>
40f092a4:	00b65ab3          	srl	s5,a2,a1
40f092a8:	014696b3          	sll	a3,a3,s4
40f092ac:	00daeab3          	or	s5,s5,a3
40f092b0:	00b4d933          	srl	s2,s1,a1
40f092b4:	014497b3          	sll	a5,s1,s4
40f092b8:	00bb55b3          	srl	a1,s6,a1
40f092bc:	010adb93          	srli	s7,s5,0x10
40f092c0:	00f5e4b3          	or	s1,a1,a5
40f092c4:	00090513          	mv	a0,s2
40f092c8:	000b8593          	mv	a1,s7
40f092cc:	014619b3          	sll	s3,a2,s4
40f092d0:	6d8000ef          	jal	ra,40f099a8 <__umodsi3>
40f092d4:	00050413          	mv	s0,a0
40f092d8:	000b8593          	mv	a1,s7
40f092dc:	00090513          	mv	a0,s2
40f092e0:	010a9c13          	slli	s8,s5,0x10
40f092e4:	67c000ef          	jal	ra,40f09960 <__udivsi3>
40f092e8:	010c5c13          	srli	s8,s8,0x10
40f092ec:	00050913          	mv	s2,a0
40f092f0:	00050593          	mv	a1,a0
40f092f4:	000c0513          	mv	a0,s8
40f092f8:	63c000ef          	jal	ra,40f09934 <__mulsi3>
40f092fc:	01041413          	slli	s0,s0,0x10
40f09300:	0104d713          	srli	a4,s1,0x10
40f09304:	00e46733          	or	a4,s0,a4
40f09308:	00090c93          	mv	s9,s2
40f0930c:	00a77e63          	bgeu	a4,a0,40f09328 <__udivdi3+0x4b8>
40f09310:	01570733          	add	a4,a4,s5
40f09314:	fff90c93          	addi	s9,s2,-1
40f09318:	01576863          	bltu	a4,s5,40f09328 <__udivdi3+0x4b8>
40f0931c:	00a77663          	bgeu	a4,a0,40f09328 <__udivdi3+0x4b8>
40f09320:	ffe90c93          	addi	s9,s2,-2
40f09324:	01570733          	add	a4,a4,s5
40f09328:	40a70933          	sub	s2,a4,a0
40f0932c:	000b8593          	mv	a1,s7
40f09330:	00090513          	mv	a0,s2
40f09334:	674000ef          	jal	ra,40f099a8 <__umodsi3>
40f09338:	00050413          	mv	s0,a0
40f0933c:	000b8593          	mv	a1,s7
40f09340:	00090513          	mv	a0,s2
40f09344:	61c000ef          	jal	ra,40f09960 <__udivsi3>
40f09348:	00050913          	mv	s2,a0
40f0934c:	00050593          	mv	a1,a0
40f09350:	000c0513          	mv	a0,s8
40f09354:	5e0000ef          	jal	ra,40f09934 <__mulsi3>
40f09358:	01049793          	slli	a5,s1,0x10
40f0935c:	01041413          	slli	s0,s0,0x10
40f09360:	0107d793          	srli	a5,a5,0x10
40f09364:	00f46733          	or	a4,s0,a5
40f09368:	00090613          	mv	a2,s2
40f0936c:	00a77e63          	bgeu	a4,a0,40f09388 <__udivdi3+0x518>
40f09370:	01570733          	add	a4,a4,s5
40f09374:	fff90613          	addi	a2,s2,-1
40f09378:	01576863          	bltu	a4,s5,40f09388 <__udivdi3+0x518>
40f0937c:	00a77663          	bgeu	a4,a0,40f09388 <__udivdi3+0x518>
40f09380:	ffe90613          	addi	a2,s2,-2
40f09384:	01570733          	add	a4,a4,s5
40f09388:	010c9793          	slli	a5,s9,0x10
40f0938c:	00010e37          	lui	t3,0x10
40f09390:	00c7e7b3          	or	a5,a5,a2
40f09394:	fffe0813          	addi	a6,t3,-1 # ffff <_fw_start-0x40ef0001>
40f09398:	0107f333          	and	t1,a5,a6
40f0939c:	0109f833          	and	a6,s3,a6
40f093a0:	40a70733          	sub	a4,a4,a0
40f093a4:	0107de93          	srli	t4,a5,0x10
40f093a8:	0109d993          	srli	s3,s3,0x10
40f093ac:	00030513          	mv	a0,t1
40f093b0:	00080593          	mv	a1,a6
40f093b4:	580000ef          	jal	ra,40f09934 <__mulsi3>
40f093b8:	00050893          	mv	a7,a0
40f093bc:	00098593          	mv	a1,s3
40f093c0:	00030513          	mv	a0,t1
40f093c4:	570000ef          	jal	ra,40f09934 <__mulsi3>
40f093c8:	00050313          	mv	t1,a0
40f093cc:	00080593          	mv	a1,a6
40f093d0:	000e8513          	mv	a0,t4
40f093d4:	560000ef          	jal	ra,40f09934 <__mulsi3>
40f093d8:	00050813          	mv	a6,a0
40f093dc:	00098593          	mv	a1,s3
40f093e0:	000e8513          	mv	a0,t4
40f093e4:	550000ef          	jal	ra,40f09934 <__mulsi3>
40f093e8:	0108d693          	srli	a3,a7,0x10
40f093ec:	01030333          	add	t1,t1,a6
40f093f0:	006686b3          	add	a3,a3,t1
40f093f4:	0106f463          	bgeu	a3,a6,40f093fc <__udivdi3+0x58c>
40f093f8:	01c50533          	add	a0,a0,t3
40f093fc:	0106d613          	srli	a2,a3,0x10
40f09400:	00a60533          	add	a0,a2,a0
40f09404:	02a76663          	bltu	a4,a0,40f09430 <__udivdi3+0x5c0>
40f09408:	bca714e3          	bne	a4,a0,40f08fd0 <__udivdi3+0x160>
40f0940c:	00010737          	lui	a4,0x10
40f09410:	fff70713          	addi	a4,a4,-1 # ffff <_fw_start-0x40ef0001>
40f09414:	00e6f6b3          	and	a3,a3,a4
40f09418:	01069693          	slli	a3,a3,0x10
40f0941c:	00e8f8b3          	and	a7,a7,a4
40f09420:	014b1633          	sll	a2,s6,s4
40f09424:	011686b3          	add	a3,a3,a7
40f09428:	00000a13          	li	s4,0
40f0942c:	ccd67ce3          	bgeu	a2,a3,40f09104 <__udivdi3+0x294>
40f09430:	fff78793          	addi	a5,a5,-1 # ffffff <_fw_start-0x3ff00001>
40f09434:	b9dff06f          	j	40f08fd0 <__udivdi3+0x160>
40f09438:	00000a13          	li	s4,0
40f0943c:	00000793          	li	a5,0
40f09440:	cc5ff06f          	j	40f09104 <__udivdi3+0x294>

40f09444 <__umoddi3>:
40f09444:	fd010113          	addi	sp,sp,-48
40f09448:	02812423          	sw	s0,40(sp)
40f0944c:	02912223          	sw	s1,36(sp)
40f09450:	01312e23          	sw	s3,28(sp)
40f09454:	01612823          	sw	s6,16(sp)
40f09458:	02112623          	sw	ra,44(sp)
40f0945c:	03212023          	sw	s2,32(sp)
40f09460:	01412c23          	sw	s4,24(sp)
40f09464:	01512a23          	sw	s5,20(sp)
40f09468:	01712623          	sw	s7,12(sp)
40f0946c:	01812423          	sw	s8,8(sp)
40f09470:	01912223          	sw	s9,4(sp)
40f09474:	01a12023          	sw	s10,0(sp)
40f09478:	00050b13          	mv	s6,a0
40f0947c:	00058993          	mv	s3,a1
40f09480:	00050413          	mv	s0,a0
40f09484:	00058493          	mv	s1,a1
40f09488:	26069c63          	bnez	a3,40f09700 <__umoddi3+0x2bc>
40f0948c:	00060913          	mv	s2,a2
40f09490:	00068a13          	mv	s4,a3
40f09494:	00001a97          	auipc	s5,0x1
40f09498:	47ca8a93          	addi	s5,s5,1148 # 40f0a910 <__clz_tab>
40f0949c:	14c5f263          	bgeu	a1,a2,40f095e0 <__umoddi3+0x19c>
40f094a0:	000107b7          	lui	a5,0x10
40f094a4:	12f67463          	bgeu	a2,a5,40f095cc <__umoddi3+0x188>
40f094a8:	0ff00793          	li	a5,255
40f094ac:	00c7f463          	bgeu	a5,a2,40f094b4 <__umoddi3+0x70>
40f094b0:	00800a13          	li	s4,8
40f094b4:	014657b3          	srl	a5,a2,s4
40f094b8:	00fa8ab3          	add	s5,s5,a5
40f094bc:	000ac703          	lbu	a4,0(s5)
40f094c0:	02000513          	li	a0,32
40f094c4:	01470733          	add	a4,a4,s4
40f094c8:	40e50a33          	sub	s4,a0,a4
40f094cc:	000a0c63          	beqz	s4,40f094e4 <__umoddi3+0xa0>
40f094d0:	014995b3          	sll	a1,s3,s4
40f094d4:	00eb5733          	srl	a4,s6,a4
40f094d8:	01461933          	sll	s2,a2,s4
40f094dc:	00b764b3          	or	s1,a4,a1
40f094e0:	014b1433          	sll	s0,s6,s4
40f094e4:	01095a93          	srli	s5,s2,0x10
40f094e8:	000a8593          	mv	a1,s5
40f094ec:	00048513          	mv	a0,s1
40f094f0:	4b8000ef          	jal	ra,40f099a8 <__umodsi3>
40f094f4:	00050993          	mv	s3,a0
40f094f8:	000a8593          	mv	a1,s5
40f094fc:	01091b13          	slli	s6,s2,0x10
40f09500:	00048513          	mv	a0,s1
40f09504:	45c000ef          	jal	ra,40f09960 <__udivsi3>
40f09508:	010b5b13          	srli	s6,s6,0x10
40f0950c:	00050593          	mv	a1,a0
40f09510:	000b0513          	mv	a0,s6
40f09514:	420000ef          	jal	ra,40f09934 <__mulsi3>
40f09518:	01099993          	slli	s3,s3,0x10
40f0951c:	01045793          	srli	a5,s0,0x10
40f09520:	00f9e7b3          	or	a5,s3,a5
40f09524:	00a7fa63          	bgeu	a5,a0,40f09538 <__umoddi3+0xf4>
40f09528:	012787b3          	add	a5,a5,s2
40f0952c:	0127e663          	bltu	a5,s2,40f09538 <__umoddi3+0xf4>
40f09530:	00a7f463          	bgeu	a5,a0,40f09538 <__umoddi3+0xf4>
40f09534:	012787b3          	add	a5,a5,s2
40f09538:	40a784b3          	sub	s1,a5,a0
40f0953c:	000a8593          	mv	a1,s5
40f09540:	00048513          	mv	a0,s1
40f09544:	464000ef          	jal	ra,40f099a8 <__umodsi3>
40f09548:	00050993          	mv	s3,a0
40f0954c:	000a8593          	mv	a1,s5
40f09550:	00048513          	mv	a0,s1
40f09554:	40c000ef          	jal	ra,40f09960 <__udivsi3>
40f09558:	01041413          	slli	s0,s0,0x10
40f0955c:	00050593          	mv	a1,a0
40f09560:	01099993          	slli	s3,s3,0x10
40f09564:	000b0513          	mv	a0,s6
40f09568:	01045413          	srli	s0,s0,0x10
40f0956c:	3c8000ef          	jal	ra,40f09934 <__mulsi3>
40f09570:	0089e433          	or	s0,s3,s0
40f09574:	00a47a63          	bgeu	s0,a0,40f09588 <__umoddi3+0x144>
40f09578:	01240433          	add	s0,s0,s2
40f0957c:	01246663          	bltu	s0,s2,40f09588 <__umoddi3+0x144>
40f09580:	00a47463          	bgeu	s0,a0,40f09588 <__umoddi3+0x144>
40f09584:	01240433          	add	s0,s0,s2
40f09588:	40a40433          	sub	s0,s0,a0
40f0958c:	01445533          	srl	a0,s0,s4
40f09590:	00000593          	li	a1,0
40f09594:	02c12083          	lw	ra,44(sp)
40f09598:	02812403          	lw	s0,40(sp)
40f0959c:	02412483          	lw	s1,36(sp)
40f095a0:	02012903          	lw	s2,32(sp)
40f095a4:	01c12983          	lw	s3,28(sp)
40f095a8:	01812a03          	lw	s4,24(sp)
40f095ac:	01412a83          	lw	s5,20(sp)
40f095b0:	01012b03          	lw	s6,16(sp)
40f095b4:	00c12b83          	lw	s7,12(sp)
40f095b8:	00812c03          	lw	s8,8(sp)
40f095bc:	00412c83          	lw	s9,4(sp)
40f095c0:	00012d03          	lw	s10,0(sp)
40f095c4:	03010113          	addi	sp,sp,48
40f095c8:	00008067          	ret
40f095cc:	010007b7          	lui	a5,0x1000
40f095d0:	01000a13          	li	s4,16
40f095d4:	eef660e3          	bltu	a2,a5,40f094b4 <__umoddi3+0x70>
40f095d8:	01800a13          	li	s4,24
40f095dc:	ed9ff06f          	j	40f094b4 <__umoddi3+0x70>
40f095e0:	00061a63          	bnez	a2,40f095f4 <__umoddi3+0x1b0>
40f095e4:	00000593          	li	a1,0
40f095e8:	00100513          	li	a0,1
40f095ec:	374000ef          	jal	ra,40f09960 <__udivsi3>
40f095f0:	00050913          	mv	s2,a0
40f095f4:	000107b7          	lui	a5,0x10
40f095f8:	0ef97a63          	bgeu	s2,a5,40f096ec <__umoddi3+0x2a8>
40f095fc:	0ff00793          	li	a5,255
40f09600:	0127f463          	bgeu	a5,s2,40f09608 <__umoddi3+0x1c4>
40f09604:	00800a13          	li	s4,8
40f09608:	014957b3          	srl	a5,s2,s4
40f0960c:	00fa8ab3          	add	s5,s5,a5
40f09610:	000ac703          	lbu	a4,0(s5)
40f09614:	02000513          	li	a0,32
40f09618:	412984b3          	sub	s1,s3,s2
40f0961c:	01470733          	add	a4,a4,s4
40f09620:	40e50a33          	sub	s4,a0,a4
40f09624:	ec0a00e3          	beqz	s4,40f094e4 <__umoddi3+0xa0>
40f09628:	01491933          	sll	s2,s2,s4
40f0962c:	00e9dab3          	srl	s5,s3,a4
40f09630:	014995b3          	sll	a1,s3,s4
40f09634:	00eb5733          	srl	a4,s6,a4
40f09638:	01095493          	srli	s1,s2,0x10
40f0963c:	00b76bb3          	or	s7,a4,a1
40f09640:	000a8513          	mv	a0,s5
40f09644:	00048593          	mv	a1,s1
40f09648:	360000ef          	jal	ra,40f099a8 <__umodsi3>
40f0964c:	00050993          	mv	s3,a0
40f09650:	00048593          	mv	a1,s1
40f09654:	014b1433          	sll	s0,s6,s4
40f09658:	000a8513          	mv	a0,s5
40f0965c:	01091b13          	slli	s6,s2,0x10
40f09660:	300000ef          	jal	ra,40f09960 <__udivsi3>
40f09664:	010b5b13          	srli	s6,s6,0x10
40f09668:	00050593          	mv	a1,a0
40f0966c:	000b0513          	mv	a0,s6
40f09670:	2c4000ef          	jal	ra,40f09934 <__mulsi3>
40f09674:	01099993          	slli	s3,s3,0x10
40f09678:	010bd793          	srli	a5,s7,0x10
40f0967c:	00f9e7b3          	or	a5,s3,a5
40f09680:	00a7fa63          	bgeu	a5,a0,40f09694 <__umoddi3+0x250>
40f09684:	012787b3          	add	a5,a5,s2
40f09688:	0127e663          	bltu	a5,s2,40f09694 <__umoddi3+0x250>
40f0968c:	00a7f463          	bgeu	a5,a0,40f09694 <__umoddi3+0x250>
40f09690:	012787b3          	add	a5,a5,s2
40f09694:	40a78ab3          	sub	s5,a5,a0
40f09698:	00048593          	mv	a1,s1
40f0969c:	000a8513          	mv	a0,s5
40f096a0:	308000ef          	jal	ra,40f099a8 <__umodsi3>
40f096a4:	00050993          	mv	s3,a0
40f096a8:	00048593          	mv	a1,s1
40f096ac:	000a8513          	mv	a0,s5
40f096b0:	2b0000ef          	jal	ra,40f09960 <__udivsi3>
40f096b4:	00050593          	mv	a1,a0
40f096b8:	000b0513          	mv	a0,s6
40f096bc:	278000ef          	jal	ra,40f09934 <__mulsi3>
40f096c0:	010b9593          	slli	a1,s7,0x10
40f096c4:	01099993          	slli	s3,s3,0x10
40f096c8:	0105d593          	srli	a1,a1,0x10
40f096cc:	00b9e5b3          	or	a1,s3,a1
40f096d0:	00a5fa63          	bgeu	a1,a0,40f096e4 <__umoddi3+0x2a0>
40f096d4:	012585b3          	add	a1,a1,s2
40f096d8:	0125e663          	bltu	a1,s2,40f096e4 <__umoddi3+0x2a0>
40f096dc:	00a5f463          	bgeu	a1,a0,40f096e4 <__umoddi3+0x2a0>
40f096e0:	012585b3          	add	a1,a1,s2
40f096e4:	40a584b3          	sub	s1,a1,a0
40f096e8:	dfdff06f          	j	40f094e4 <__umoddi3+0xa0>
40f096ec:	010007b7          	lui	a5,0x1000
40f096f0:	01000a13          	li	s4,16
40f096f4:	f0f96ae3          	bltu	s2,a5,40f09608 <__umoddi3+0x1c4>
40f096f8:	01800a13          	li	s4,24
40f096fc:	f0dff06f          	j	40f09608 <__umoddi3+0x1c4>
40f09700:	e8d5eae3          	bltu	a1,a3,40f09594 <__umoddi3+0x150>
40f09704:	000107b7          	lui	a5,0x10
40f09708:	04f6fc63          	bgeu	a3,a5,40f09760 <__umoddi3+0x31c>
40f0970c:	0ff00a93          	li	s5,255
40f09710:	00dab533          	sltu	a0,s5,a3
40f09714:	00351513          	slli	a0,a0,0x3
40f09718:	00a6d733          	srl	a4,a3,a0
40f0971c:	00001797          	auipc	a5,0x1
40f09720:	1f478793          	addi	a5,a5,500 # 40f0a910 <__clz_tab>
40f09724:	00e787b3          	add	a5,a5,a4
40f09728:	0007ca83          	lbu	s5,0(a5)
40f0972c:	02000593          	li	a1,32
40f09730:	00aa8ab3          	add	s5,s5,a0
40f09734:	41558a33          	sub	s4,a1,s5
40f09738:	020a1e63          	bnez	s4,40f09774 <__umoddi3+0x330>
40f0973c:	0136e463          	bltu	a3,s3,40f09744 <__umoddi3+0x300>
40f09740:	00cb6a63          	bltu	s6,a2,40f09754 <__umoddi3+0x310>
40f09744:	40cb0433          	sub	s0,s6,a2
40f09748:	40d986b3          	sub	a3,s3,a3
40f0974c:	008b3b33          	sltu	s6,s6,s0
40f09750:	416684b3          	sub	s1,a3,s6
40f09754:	00040513          	mv	a0,s0
40f09758:	00048593          	mv	a1,s1
40f0975c:	e39ff06f          	j	40f09594 <__umoddi3+0x150>
40f09760:	010007b7          	lui	a5,0x1000
40f09764:	01000513          	li	a0,16
40f09768:	faf6e8e3          	bltu	a3,a5,40f09718 <__umoddi3+0x2d4>
40f0976c:	01800513          	li	a0,24
40f09770:	fa9ff06f          	j	40f09718 <__umoddi3+0x2d4>
40f09774:	014696b3          	sll	a3,a3,s4
40f09778:	015657b3          	srl	a5,a2,s5
40f0977c:	00d7ebb3          	or	s7,a5,a3
40f09780:	0159d433          	srl	s0,s3,s5
40f09784:	014995b3          	sll	a1,s3,s4
40f09788:	015b54b3          	srl	s1,s6,s5
40f0978c:	010bdc13          	srli	s8,s7,0x10
40f09790:	00b4e4b3          	or	s1,s1,a1
40f09794:	00040513          	mv	a0,s0
40f09798:	000c0593          	mv	a1,s8
40f0979c:	01461d33          	sll	s10,a2,s4
40f097a0:	208000ef          	jal	ra,40f099a8 <__umodsi3>
40f097a4:	00050993          	mv	s3,a0
40f097a8:	000c0593          	mv	a1,s8
40f097ac:	00040513          	mv	a0,s0
40f097b0:	010b9c93          	slli	s9,s7,0x10
40f097b4:	1ac000ef          	jal	ra,40f09960 <__udivsi3>
40f097b8:	010cdc93          	srli	s9,s9,0x10
40f097bc:	00050413          	mv	s0,a0
40f097c0:	00050593          	mv	a1,a0
40f097c4:	000c8513          	mv	a0,s9
40f097c8:	16c000ef          	jal	ra,40f09934 <__mulsi3>
40f097cc:	01099993          	slli	s3,s3,0x10
40f097d0:	0104d713          	srli	a4,s1,0x10
40f097d4:	00e9e733          	or	a4,s3,a4
40f097d8:	014b1b33          	sll	s6,s6,s4
40f097dc:	00040993          	mv	s3,s0
40f097e0:	00a77e63          	bgeu	a4,a0,40f097fc <__umoddi3+0x3b8>
40f097e4:	01770733          	add	a4,a4,s7
40f097e8:	fff40993          	addi	s3,s0,-1
40f097ec:	01776863          	bltu	a4,s7,40f097fc <__umoddi3+0x3b8>
40f097f0:	00a77663          	bgeu	a4,a0,40f097fc <__umoddi3+0x3b8>
40f097f4:	ffe40993          	addi	s3,s0,-2
40f097f8:	01770733          	add	a4,a4,s7
40f097fc:	40a70933          	sub	s2,a4,a0
40f09800:	000c0593          	mv	a1,s8
40f09804:	00090513          	mv	a0,s2
40f09808:	1a0000ef          	jal	ra,40f099a8 <__umodsi3>
40f0980c:	00050413          	mv	s0,a0
40f09810:	000c0593          	mv	a1,s8
40f09814:	00090513          	mv	a0,s2
40f09818:	148000ef          	jal	ra,40f09960 <__udivsi3>
40f0981c:	00050593          	mv	a1,a0
40f09820:	00050913          	mv	s2,a0
40f09824:	000c8513          	mv	a0,s9
40f09828:	10c000ef          	jal	ra,40f09934 <__mulsi3>
40f0982c:	01049593          	slli	a1,s1,0x10
40f09830:	01041413          	slli	s0,s0,0x10
40f09834:	0105d593          	srli	a1,a1,0x10
40f09838:	00b465b3          	or	a1,s0,a1
40f0983c:	00090793          	mv	a5,s2
40f09840:	00a5fe63          	bgeu	a1,a0,40f0985c <__umoddi3+0x418>
40f09844:	017585b3          	add	a1,a1,s7
40f09848:	fff90793          	addi	a5,s2,-1
40f0984c:	0175e863          	bltu	a1,s7,40f0985c <__umoddi3+0x418>
40f09850:	00a5f663          	bgeu	a1,a0,40f0985c <__umoddi3+0x418>
40f09854:	ffe90793          	addi	a5,s2,-2
40f09858:	017585b3          	add	a1,a1,s7
40f0985c:	00010e37          	lui	t3,0x10
40f09860:	01099993          	slli	s3,s3,0x10
40f09864:	00f9e9b3          	or	s3,s3,a5
40f09868:	fffe0813          	addi	a6,t3,-1 # ffff <_fw_start-0x40ef0001>
40f0986c:	0109f733          	and	a4,s3,a6
40f09870:	010d7833          	and	a6,s10,a6
40f09874:	40a584b3          	sub	s1,a1,a0
40f09878:	0109d993          	srli	s3,s3,0x10
40f0987c:	010d5893          	srli	a7,s10,0x10
40f09880:	00070513          	mv	a0,a4
40f09884:	00080593          	mv	a1,a6
40f09888:	0ac000ef          	jal	ra,40f09934 <__mulsi3>
40f0988c:	00050793          	mv	a5,a0
40f09890:	00088593          	mv	a1,a7
40f09894:	00070513          	mv	a0,a4
40f09898:	09c000ef          	jal	ra,40f09934 <__mulsi3>
40f0989c:	00050313          	mv	t1,a0
40f098a0:	00080593          	mv	a1,a6
40f098a4:	00098513          	mv	a0,s3
40f098a8:	08c000ef          	jal	ra,40f09934 <__mulsi3>
40f098ac:	00050813          	mv	a6,a0
40f098b0:	00088593          	mv	a1,a7
40f098b4:	00098513          	mv	a0,s3
40f098b8:	07c000ef          	jal	ra,40f09934 <__mulsi3>
40f098bc:	0107d713          	srli	a4,a5,0x10
40f098c0:	01030333          	add	t1,t1,a6
40f098c4:	00670733          	add	a4,a4,t1
40f098c8:	01077463          	bgeu	a4,a6,40f098d0 <__umoddi3+0x48c>
40f098cc:	01c50533          	add	a0,a0,t3
40f098d0:	000106b7          	lui	a3,0x10
40f098d4:	fff68693          	addi	a3,a3,-1 # ffff <_fw_start-0x40ef0001>
40f098d8:	01075593          	srli	a1,a4,0x10
40f098dc:	00d77733          	and	a4,a4,a3
40f098e0:	01071713          	slli	a4,a4,0x10
40f098e4:	00d7f7b3          	and	a5,a5,a3
40f098e8:	00a585b3          	add	a1,a1,a0
40f098ec:	00f707b3          	add	a5,a4,a5
40f098f0:	00b4e663          	bltu	s1,a1,40f098fc <__umoddi3+0x4b8>
40f098f4:	00b49e63          	bne	s1,a1,40f09910 <__umoddi3+0x4cc>
40f098f8:	00fb7c63          	bgeu	s6,a5,40f09910 <__umoddi3+0x4cc>
40f098fc:	41a78633          	sub	a2,a5,s10
40f09900:	00c7b7b3          	sltu	a5,a5,a2
40f09904:	017787b3          	add	a5,a5,s7
40f09908:	40f585b3          	sub	a1,a1,a5
40f0990c:	00060793          	mv	a5,a2
40f09910:	40fb07b3          	sub	a5,s6,a5
40f09914:	00fb3b33          	sltu	s6,s6,a5
40f09918:	40b485b3          	sub	a1,s1,a1
40f0991c:	416585b3          	sub	a1,a1,s6
40f09920:	01559433          	sll	s0,a1,s5
40f09924:	0147d7b3          	srl	a5,a5,s4
40f09928:	00f46533          	or	a0,s0,a5
40f0992c:	0145d5b3          	srl	a1,a1,s4
40f09930:	c65ff06f          	j	40f09594 <__umoddi3+0x150>

40f09934 <__mulsi3>:
40f09934:	00050613          	mv	a2,a0
40f09938:	00000513          	li	a0,0
40f0993c:	0015f693          	andi	a3,a1,1
40f09940:	00068463          	beqz	a3,40f09948 <__mulsi3+0x14>
40f09944:	00c50533          	add	a0,a0,a2
40f09948:	0015d593          	srli	a1,a1,0x1
40f0994c:	00161613          	slli	a2,a2,0x1
40f09950:	fe0596e3          	bnez	a1,40f0993c <__mulsi3+0x8>
40f09954:	00008067          	ret

40f09958 <__divsi3>:
40f09958:	06054063          	bltz	a0,40f099b8 <__umodsi3+0x10>
40f0995c:	0605c663          	bltz	a1,40f099c8 <__umodsi3+0x20>

40f09960 <__udivsi3>:
40f09960:	00058613          	mv	a2,a1
40f09964:	00050593          	mv	a1,a0
40f09968:	fff00513          	li	a0,-1
40f0996c:	02060c63          	beqz	a2,40f099a4 <__udivsi3+0x44>
40f09970:	00100693          	li	a3,1
40f09974:	00b67a63          	bgeu	a2,a1,40f09988 <__udivsi3+0x28>
40f09978:	00c05863          	blez	a2,40f09988 <__udivsi3+0x28>
40f0997c:	00161613          	slli	a2,a2,0x1
40f09980:	00169693          	slli	a3,a3,0x1
40f09984:	feb66ae3          	bltu	a2,a1,40f09978 <__udivsi3+0x18>
40f09988:	00000513          	li	a0,0
40f0998c:	00c5e663          	bltu	a1,a2,40f09998 <__udivsi3+0x38>
40f09990:	40c585b3          	sub	a1,a1,a2
40f09994:	00d56533          	or	a0,a0,a3
40f09998:	0016d693          	srli	a3,a3,0x1
40f0999c:	00165613          	srli	a2,a2,0x1
40f099a0:	fe0696e3          	bnez	a3,40f0998c <__udivsi3+0x2c>
40f099a4:	00008067          	ret

40f099a8 <__umodsi3>:
40f099a8:	00008293          	mv	t0,ra
40f099ac:	fb5ff0ef          	jal	ra,40f09960 <__udivsi3>
40f099b0:	00058513          	mv	a0,a1
40f099b4:	00028067          	jr	t0
40f099b8:	40a00533          	neg	a0,a0
40f099bc:	0005d863          	bgez	a1,40f099cc <__umodsi3+0x24>
40f099c0:	40b005b3          	neg	a1,a1
40f099c4:	f9dff06f          	j	40f09960 <__udivsi3>
40f099c8:	40b005b3          	neg	a1,a1
40f099cc:	00008293          	mv	t0,ra
40f099d0:	f91ff0ef          	jal	ra,40f09960 <__udivsi3>
40f099d4:	40a00533          	neg	a0,a0
40f099d8:	00028067          	jr	t0

40f099dc <__modsi3>:
40f099dc:	00008293          	mv	t0,ra
40f099e0:	0005ca63          	bltz	a1,40f099f4 <__modsi3+0x18>
40f099e4:	00054c63          	bltz	a0,40f099fc <__modsi3+0x20>
40f099e8:	f79ff0ef          	jal	ra,40f09960 <__udivsi3>
40f099ec:	00058513          	mv	a0,a1
40f099f0:	00028067          	jr	t0
40f099f4:	40b005b3          	neg	a1,a1
40f099f8:	fe0558e3          	bgez	a0,40f099e8 <__modsi3+0xc>
40f099fc:	40a00533          	neg	a0,a0
40f09a00:	f61ff0ef          	jal	ra,40f09960 <__udivsi3>
40f09a04:	40b00533          	neg	a0,a1
40f09a08:	00028067          	jr	t0
40f09a0c:	0000                	unimp
	...
