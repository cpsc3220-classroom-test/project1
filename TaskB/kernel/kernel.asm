
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	80010113          	addi	sp,sp,-2048 # 80008800 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00008617          	auipc	a2,0x8
    8000004e:	fb660613          	addi	a2,a2,-74 # 80008000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	8f478793          	addi	a5,a5,-1804 # 80005950 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd97e3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	c7a78793          	addi	a5,a5,-902 # 80000d20 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  timerinit();
    800000c4:	00000097          	auipc	ra,0x0
    800000c8:	f58080e7          	jalr	-168(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000cc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000d0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000d2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000d4:	30200073          	mret
}
    800000d8:	60a2                	ld	ra,8(sp)
    800000da:	6402                	ld	s0,0(sp)
    800000dc:	0141                	addi	sp,sp,16
    800000de:	8082                	ret

00000000800000e0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800000e0:	7119                	addi	sp,sp,-128
    800000e2:	fc86                	sd	ra,120(sp)
    800000e4:	f8a2                	sd	s0,112(sp)
    800000e6:	f4a6                	sd	s1,104(sp)
    800000e8:	f0ca                	sd	s2,96(sp)
    800000ea:	ecce                	sd	s3,88(sp)
    800000ec:	e8d2                	sd	s4,80(sp)
    800000ee:	e4d6                	sd	s5,72(sp)
    800000f0:	e0da                	sd	s6,64(sp)
    800000f2:	fc5e                	sd	s7,56(sp)
    800000f4:	f862                	sd	s8,48(sp)
    800000f6:	f466                	sd	s9,40(sp)
    800000f8:	f06a                	sd	s10,32(sp)
    800000fa:	ec6e                	sd	s11,24(sp)
    800000fc:	0100                	addi	s0,sp,128
    800000fe:	8b2a                	mv	s6,a0
    80000100:	8aae                	mv	s5,a1
    80000102:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000104:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000108:	00010517          	auipc	a0,0x10
    8000010c:	6f850513          	addi	a0,a0,1784 # 80010800 <cons>
    80000110:	00001097          	auipc	ra,0x1
    80000114:	9c2080e7          	jalr	-1598(ra) # 80000ad2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000118:	00010497          	auipc	s1,0x10
    8000011c:	6e848493          	addi	s1,s1,1768 # 80010800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000120:	89a6                	mv	s3,s1
    80000122:	00010917          	auipc	s2,0x10
    80000126:	77690913          	addi	s2,s2,1910 # 80010898 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000012a:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000012c:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000012e:	4da9                	li	s11,10
  while(n > 0){
    80000130:	07405863          	blez	s4,800001a0 <consoleread+0xc0>
    while(cons.r == cons.w){
    80000134:	0984a783          	lw	a5,152(s1)
    80000138:	09c4a703          	lw	a4,156(s1)
    8000013c:	02f71463          	bne	a4,a5,80000164 <consoleread+0x84>
      if(myproc()->killed){
    80000140:	00001097          	auipc	ra,0x1
    80000144:	704080e7          	jalr	1796(ra) # 80001844 <myproc>
    80000148:	591c                	lw	a5,48(a0)
    8000014a:	e7b5                	bnez	a5,800001b6 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000014c:	85ce                	mv	a1,s3
    8000014e:	854a                	mv	a0,s2
    80000150:	00002097          	auipc	ra,0x2
    80000154:	e96080e7          	jalr	-362(ra) # 80001fe6 <sleep>
    while(cons.r == cons.w){
    80000158:	0984a783          	lw	a5,152(s1)
    8000015c:	09c4a703          	lw	a4,156(s1)
    80000160:	fef700e3          	beq	a4,a5,80000140 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000164:	0017871b          	addiw	a4,a5,1
    80000168:	08e4ac23          	sw	a4,152(s1)
    8000016c:	07f7f713          	andi	a4,a5,127
    80000170:	9726                	add	a4,a4,s1
    80000172:	01874703          	lbu	a4,24(a4)
    80000176:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    8000017a:	079c0663          	beq	s8,s9,800001e6 <consoleread+0x106>
    cbuf = c;
    8000017e:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000182:	4685                	li	a3,1
    80000184:	f8f40613          	addi	a2,s0,-113
    80000188:	85d6                	mv	a1,s5
    8000018a:	855a                	mv	a0,s6
    8000018c:	00002097          	auipc	ra,0x2
    80000190:	0bc080e7          	jalr	188(ra) # 80002248 <either_copyout>
    80000194:	01a50663          	beq	a0,s10,800001a0 <consoleread+0xc0>
    dst++;
    80000198:	0a85                	addi	s5,s5,1
    --n;
    8000019a:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000019c:	f9bc1ae3          	bne	s8,s11,80000130 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001a0:	00010517          	auipc	a0,0x10
    800001a4:	66050513          	addi	a0,a0,1632 # 80010800 <cons>
    800001a8:	00001097          	auipc	ra,0x1
    800001ac:	97e080e7          	jalr	-1666(ra) # 80000b26 <release>

  return target - n;
    800001b0:	414b853b          	subw	a0,s7,s4
    800001b4:	a811                	j	800001c8 <consoleread+0xe8>
        release(&cons.lock);
    800001b6:	00010517          	auipc	a0,0x10
    800001ba:	64a50513          	addi	a0,a0,1610 # 80010800 <cons>
    800001be:	00001097          	auipc	ra,0x1
    800001c2:	968080e7          	jalr	-1688(ra) # 80000b26 <release>
        return -1;
    800001c6:	557d                	li	a0,-1
}
    800001c8:	70e6                	ld	ra,120(sp)
    800001ca:	7446                	ld	s0,112(sp)
    800001cc:	74a6                	ld	s1,104(sp)
    800001ce:	7906                	ld	s2,96(sp)
    800001d0:	69e6                	ld	s3,88(sp)
    800001d2:	6a46                	ld	s4,80(sp)
    800001d4:	6aa6                	ld	s5,72(sp)
    800001d6:	6b06                	ld	s6,64(sp)
    800001d8:	7be2                	ld	s7,56(sp)
    800001da:	7c42                	ld	s8,48(sp)
    800001dc:	7ca2                	ld	s9,40(sp)
    800001de:	7d02                	ld	s10,32(sp)
    800001e0:	6de2                	ld	s11,24(sp)
    800001e2:	6109                	addi	sp,sp,128
    800001e4:	8082                	ret
      if(n < target){
    800001e6:	000a071b          	sext.w	a4,s4
    800001ea:	fb777be3          	bgeu	a4,s7,800001a0 <consoleread+0xc0>
        cons.r--;
    800001ee:	00010717          	auipc	a4,0x10
    800001f2:	6af72523          	sw	a5,1706(a4) # 80010898 <cons+0x98>
    800001f6:	b76d                	j	800001a0 <consoleread+0xc0>

00000000800001f8 <consputc>:
  if(panicked){
    800001f8:	00025797          	auipc	a5,0x25
    800001fc:	e087a783          	lw	a5,-504(a5) # 80025000 <panicked>
    80000200:	c391                	beqz	a5,80000204 <consputc+0xc>
    for(;;)
    80000202:	a001                	j	80000202 <consputc+0xa>
{
    80000204:	1141                	addi	sp,sp,-16
    80000206:	e406                	sd	ra,8(sp)
    80000208:	e022                	sd	s0,0(sp)
    8000020a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000020c:	10000793          	li	a5,256
    80000210:	00f50a63          	beq	a0,a5,80000224 <consputc+0x2c>
    uartputc(c);
    80000214:	00000097          	auipc	ra,0x0
    80000218:	5d2080e7          	jalr	1490(ra) # 800007e6 <uartputc>
}
    8000021c:	60a2                	ld	ra,8(sp)
    8000021e:	6402                	ld	s0,0(sp)
    80000220:	0141                	addi	sp,sp,16
    80000222:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    80000224:	4521                	li	a0,8
    80000226:	00000097          	auipc	ra,0x0
    8000022a:	5c0080e7          	jalr	1472(ra) # 800007e6 <uartputc>
    8000022e:	02000513          	li	a0,32
    80000232:	00000097          	auipc	ra,0x0
    80000236:	5b4080e7          	jalr	1460(ra) # 800007e6 <uartputc>
    8000023a:	4521                	li	a0,8
    8000023c:	00000097          	auipc	ra,0x0
    80000240:	5aa080e7          	jalr	1450(ra) # 800007e6 <uartputc>
    80000244:	bfe1                	j	8000021c <consputc+0x24>

0000000080000246 <consolewrite>:
{
    80000246:	715d                	addi	sp,sp,-80
    80000248:	e486                	sd	ra,72(sp)
    8000024a:	e0a2                	sd	s0,64(sp)
    8000024c:	fc26                	sd	s1,56(sp)
    8000024e:	f84a                	sd	s2,48(sp)
    80000250:	f44e                	sd	s3,40(sp)
    80000252:	f052                	sd	s4,32(sp)
    80000254:	ec56                	sd	s5,24(sp)
    80000256:	0880                	addi	s0,sp,80
    80000258:	89aa                	mv	s3,a0
    8000025a:	84ae                	mv	s1,a1
    8000025c:	8ab2                	mv	s5,a2
  acquire(&cons.lock);
    8000025e:	00010517          	auipc	a0,0x10
    80000262:	5a250513          	addi	a0,a0,1442 # 80010800 <cons>
    80000266:	00001097          	auipc	ra,0x1
    8000026a:	86c080e7          	jalr	-1940(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    8000026e:	03505e63          	blez	s5,800002aa <consolewrite+0x64>
    80000272:	00148913          	addi	s2,s1,1
    80000276:	fffa879b          	addiw	a5,s5,-1
    8000027a:	1782                	slli	a5,a5,0x20
    8000027c:	9381                	srli	a5,a5,0x20
    8000027e:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000280:	5a7d                	li	s4,-1
    80000282:	4685                	li	a3,1
    80000284:	8626                	mv	a2,s1
    80000286:	85ce                	mv	a1,s3
    80000288:	fbf40513          	addi	a0,s0,-65
    8000028c:	00002097          	auipc	ra,0x2
    80000290:	012080e7          	jalr	18(ra) # 8000229e <either_copyin>
    80000294:	01450b63          	beq	a0,s4,800002aa <consolewrite+0x64>
    consputc(c);
    80000298:	fbf44503          	lbu	a0,-65(s0)
    8000029c:	00000097          	auipc	ra,0x0
    800002a0:	f5c080e7          	jalr	-164(ra) # 800001f8 <consputc>
  for(i = 0; i < n; i++){
    800002a4:	0485                	addi	s1,s1,1
    800002a6:	fd249ee3          	bne	s1,s2,80000282 <consolewrite+0x3c>
  release(&cons.lock);
    800002aa:	00010517          	auipc	a0,0x10
    800002ae:	55650513          	addi	a0,a0,1366 # 80010800 <cons>
    800002b2:	00001097          	auipc	ra,0x1
    800002b6:	874080e7          	jalr	-1932(ra) # 80000b26 <release>
}
    800002ba:	8556                	mv	a0,s5
    800002bc:	60a6                	ld	ra,72(sp)
    800002be:	6406                	ld	s0,64(sp)
    800002c0:	74e2                	ld	s1,56(sp)
    800002c2:	7942                	ld	s2,48(sp)
    800002c4:	79a2                	ld	s3,40(sp)
    800002c6:	7a02                	ld	s4,32(sp)
    800002c8:	6ae2                	ld	s5,24(sp)
    800002ca:	6161                	addi	sp,sp,80
    800002cc:	8082                	ret

00000000800002ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ce:	1101                	addi	sp,sp,-32
    800002d0:	ec06                	sd	ra,24(sp)
    800002d2:	e822                	sd	s0,16(sp)
    800002d4:	e426                	sd	s1,8(sp)
    800002d6:	e04a                	sd	s2,0(sp)
    800002d8:	1000                	addi	s0,sp,32
    800002da:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002dc:	00010517          	auipc	a0,0x10
    800002e0:	52450513          	addi	a0,a0,1316 # 80010800 <cons>
    800002e4:	00000097          	auipc	ra,0x0
    800002e8:	7ee080e7          	jalr	2030(ra) # 80000ad2 <acquire>

  switch(c){
    800002ec:	47d5                	li	a5,21
    800002ee:	0af48663          	beq	s1,a5,8000039a <consoleintr+0xcc>
    800002f2:	0297ca63          	blt	a5,s1,80000326 <consoleintr+0x58>
    800002f6:	47a1                	li	a5,8
    800002f8:	0ef48763          	beq	s1,a5,800003e6 <consoleintr+0x118>
    800002fc:	47c1                	li	a5,16
    800002fe:	10f49a63          	bne	s1,a5,80000412 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80000302:	00002097          	auipc	ra,0x2
    80000306:	ff2080e7          	jalr	-14(ra) # 800022f4 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000030a:	00010517          	auipc	a0,0x10
    8000030e:	4f650513          	addi	a0,a0,1270 # 80010800 <cons>
    80000312:	00001097          	auipc	ra,0x1
    80000316:	814080e7          	jalr	-2028(ra) # 80000b26 <release>
}
    8000031a:	60e2                	ld	ra,24(sp)
    8000031c:	6442                	ld	s0,16(sp)
    8000031e:	64a2                	ld	s1,8(sp)
    80000320:	6902                	ld	s2,0(sp)
    80000322:	6105                	addi	sp,sp,32
    80000324:	8082                	ret
  switch(c){
    80000326:	07f00793          	li	a5,127
    8000032a:	0af48e63          	beq	s1,a5,800003e6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000032e:	00010717          	auipc	a4,0x10
    80000332:	4d270713          	addi	a4,a4,1234 # 80010800 <cons>
    80000336:	0a072783          	lw	a5,160(a4)
    8000033a:	09872703          	lw	a4,152(a4)
    8000033e:	9f99                	subw	a5,a5,a4
    80000340:	07f00713          	li	a4,127
    80000344:	fcf763e3          	bltu	a4,a5,8000030a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000348:	47b5                	li	a5,13
    8000034a:	0cf48763          	beq	s1,a5,80000418 <consoleintr+0x14a>
      consputc(c);
    8000034e:	8526                	mv	a0,s1
    80000350:	00000097          	auipc	ra,0x0
    80000354:	ea8080e7          	jalr	-344(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000358:	00010797          	auipc	a5,0x10
    8000035c:	4a878793          	addi	a5,a5,1192 # 80010800 <cons>
    80000360:	0a07a703          	lw	a4,160(a5)
    80000364:	0017069b          	addiw	a3,a4,1
    80000368:	0006861b          	sext.w	a2,a3
    8000036c:	0ad7a023          	sw	a3,160(a5)
    80000370:	07f77713          	andi	a4,a4,127
    80000374:	97ba                	add	a5,a5,a4
    80000376:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000037a:	47a9                	li	a5,10
    8000037c:	0cf48563          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000380:	4791                	li	a5,4
    80000382:	0cf48263          	beq	s1,a5,80000446 <consoleintr+0x178>
    80000386:	00010797          	auipc	a5,0x10
    8000038a:	5127a783          	lw	a5,1298(a5) # 80010898 <cons+0x98>
    8000038e:	0807879b          	addiw	a5,a5,128
    80000392:	f6f61ce3          	bne	a2,a5,8000030a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000396:	863e                	mv	a2,a5
    80000398:	a07d                	j	80000446 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000039a:	00010717          	auipc	a4,0x10
    8000039e:	46670713          	addi	a4,a4,1126 # 80010800 <cons>
    800003a2:	0a072783          	lw	a5,160(a4)
    800003a6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003aa:	00010497          	auipc	s1,0x10
    800003ae:	45648493          	addi	s1,s1,1110 # 80010800 <cons>
    while(cons.e != cons.w &&
    800003b2:	4929                	li	s2,10
    800003b4:	f4f70be3          	beq	a4,a5,8000030a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b8:	37fd                	addiw	a5,a5,-1
    800003ba:	07f7f713          	andi	a4,a5,127
    800003be:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c0:	01874703          	lbu	a4,24(a4)
    800003c4:	f52703e3          	beq	a4,s2,8000030a <consoleintr+0x3c>
      cons.e--;
    800003c8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003cc:	10000513          	li	a0,256
    800003d0:	00000097          	auipc	ra,0x0
    800003d4:	e28080e7          	jalr	-472(ra) # 800001f8 <consputc>
    while(cons.e != cons.w &&
    800003d8:	0a04a783          	lw	a5,160(s1)
    800003dc:	09c4a703          	lw	a4,156(s1)
    800003e0:	fcf71ce3          	bne	a4,a5,800003b8 <consoleintr+0xea>
    800003e4:	b71d                	j	8000030a <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e6:	00010717          	auipc	a4,0x10
    800003ea:	41a70713          	addi	a4,a4,1050 # 80010800 <cons>
    800003ee:	0a072783          	lw	a5,160(a4)
    800003f2:	09c72703          	lw	a4,156(a4)
    800003f6:	f0f70ae3          	beq	a4,a5,8000030a <consoleintr+0x3c>
      cons.e--;
    800003fa:	37fd                	addiw	a5,a5,-1
    800003fc:	00010717          	auipc	a4,0x10
    80000400:	4af72223          	sw	a5,1188(a4) # 800108a0 <cons+0xa0>
      consputc(BACKSPACE);
    80000404:	10000513          	li	a0,256
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	df0080e7          	jalr	-528(ra) # 800001f8 <consputc>
    80000410:	bded                	j	8000030a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000412:	ee048ce3          	beqz	s1,8000030a <consoleintr+0x3c>
    80000416:	bf21                	j	8000032e <consoleintr+0x60>
      consputc(c);
    80000418:	4529                	li	a0,10
    8000041a:	00000097          	auipc	ra,0x0
    8000041e:	dde080e7          	jalr	-546(ra) # 800001f8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000422:	00010797          	auipc	a5,0x10
    80000426:	3de78793          	addi	a5,a5,990 # 80010800 <cons>
    8000042a:	0a07a703          	lw	a4,160(a5)
    8000042e:	0017069b          	addiw	a3,a4,1
    80000432:	0006861b          	sext.w	a2,a3
    80000436:	0ad7a023          	sw	a3,160(a5)
    8000043a:	07f77713          	andi	a4,a4,127
    8000043e:	97ba                	add	a5,a5,a4
    80000440:	4729                	li	a4,10
    80000442:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000446:	00010797          	auipc	a5,0x10
    8000044a:	44c7ab23          	sw	a2,1110(a5) # 8001089c <cons+0x9c>
        wakeup(&cons.r);
    8000044e:	00010517          	auipc	a0,0x10
    80000452:	44a50513          	addi	a0,a0,1098 # 80010898 <cons+0x98>
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	d16080e7          	jalr	-746(ra) # 8000216c <wakeup>
    8000045e:	b575                	j	8000030a <consoleintr+0x3c>

0000000080000460 <consoleinit>:

void
consoleinit(void)
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e406                	sd	ra,8(sp)
    80000464:	e022                	sd	s0,0(sp)
    80000466:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000468:	00006597          	auipc	a1,0x6
    8000046c:	cb058593          	addi	a1,a1,-848 # 80006118 <userret+0x88>
    80000470:	00010517          	auipc	a0,0x10
    80000474:	39050513          	addi	a0,a0,912 # 80010800 <cons>
    80000478:	00000097          	auipc	ra,0x0
    8000047c:	548080e7          	jalr	1352(ra) # 800009c0 <initlock>

  uartinit();
    80000480:	00000097          	auipc	ra,0x0
    80000484:	330080e7          	jalr	816(ra) # 800007b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000488:	00020797          	auipc	a5,0x20
    8000048c:	5b878793          	addi	a5,a5,1464 # 80020a40 <devsw>
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c5070713          	addi	a4,a4,-944 # 800000e0 <consoleread>
    80000498:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000049a:	00000717          	auipc	a4,0x0
    8000049e:	dac70713          	addi	a4,a4,-596 # 80000246 <consolewrite>
    800004a2:	ef98                	sd	a4,24(a5)
}
    800004a4:	60a2                	ld	ra,8(sp)
    800004a6:	6402                	ld	s0,0(sp)
    800004a8:	0141                	addi	sp,sp,16
    800004aa:	8082                	ret

00000000800004ac <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004ac:	7179                	addi	sp,sp,-48
    800004ae:	f406                	sd	ra,40(sp)
    800004b0:	f022                	sd	s0,32(sp)
    800004b2:	ec26                	sd	s1,24(sp)
    800004b4:	e84a                	sd	s2,16(sp)
    800004b6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b8:	c219                	beqz	a2,800004be <printint+0x12>
    800004ba:	08054663          	bltz	a0,80000546 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004be:	2501                	sext.w	a0,a0
    800004c0:	4881                	li	a7,0
    800004c2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c8:	2581                	sext.w	a1,a1
    800004ca:	00006617          	auipc	a2,0x6
    800004ce:	34660613          	addi	a2,a2,838 # 80006810 <digits>
    800004d2:	883a                	mv	a6,a4
    800004d4:	2705                	addiw	a4,a4,1
    800004d6:	02b577bb          	remuw	a5,a0,a1
    800004da:	1782                	slli	a5,a5,0x20
    800004dc:	9381                	srli	a5,a5,0x20
    800004de:	97b2                	add	a5,a5,a2
    800004e0:	0007c783          	lbu	a5,0(a5)
    800004e4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e8:	0005079b          	sext.w	a5,a0
    800004ec:	02b5553b          	divuw	a0,a0,a1
    800004f0:	0685                	addi	a3,a3,1
    800004f2:	feb7f0e3          	bgeu	a5,a1,800004d2 <printint+0x26>

  if(sign)
    800004f6:	00088b63          	beqz	a7,8000050c <printint+0x60>
    buf[i++] = '-';
    800004fa:	fe040793          	addi	a5,s0,-32
    800004fe:	973e                	add	a4,a4,a5
    80000500:	02d00793          	li	a5,45
    80000504:	fef70823          	sb	a5,-16(a4)
    80000508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000050c:	02e05763          	blez	a4,8000053a <printint+0x8e>
    80000510:	fd040793          	addi	a5,s0,-48
    80000514:	00e784b3          	add	s1,a5,a4
    80000518:	fff78913          	addi	s2,a5,-1
    8000051c:	993a                	add	s2,s2,a4
    8000051e:	377d                	addiw	a4,a4,-1
    80000520:	1702                	slli	a4,a4,0x20
    80000522:	9301                	srli	a4,a4,0x20
    80000524:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000528:	fff4c503          	lbu	a0,-1(s1)
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	ccc080e7          	jalr	-820(ra) # 800001f8 <consputc>
  while(--i >= 0)
    80000534:	14fd                	addi	s1,s1,-1
    80000536:	ff2499e3          	bne	s1,s2,80000528 <printint+0x7c>
}
    8000053a:	70a2                	ld	ra,40(sp)
    8000053c:	7402                	ld	s0,32(sp)
    8000053e:	64e2                	ld	s1,24(sp)
    80000540:	6942                	ld	s2,16(sp)
    80000542:	6145                	addi	sp,sp,48
    80000544:	8082                	ret
    x = -xx;
    80000546:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000054a:	4885                	li	a7,1
    x = -xx;
    8000054c:	bf9d                	j	800004c2 <printint+0x16>

000000008000054e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000054e:	1101                	addi	sp,sp,-32
    80000550:	ec06                	sd	ra,24(sp)
    80000552:	e822                	sd	s0,16(sp)
    80000554:	e426                	sd	s1,8(sp)
    80000556:	1000                	addi	s0,sp,32
    80000558:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000055a:	00010797          	auipc	a5,0x10
    8000055e:	3607a323          	sw	zero,870(a5) # 800108c0 <pr+0x18>
  printf("panic: ");
    80000562:	00006517          	auipc	a0,0x6
    80000566:	bbe50513          	addi	a0,a0,-1090 # 80006120 <userret+0x90>
    8000056a:	00000097          	auipc	ra,0x0
    8000056e:	02e080e7          	jalr	46(ra) # 80000598 <printf>
  printf(s);
    80000572:	8526                	mv	a0,s1
    80000574:	00000097          	auipc	ra,0x0
    80000578:	024080e7          	jalr	36(ra) # 80000598 <printf>
  printf("\n");
    8000057c:	00006517          	auipc	a0,0x6
    80000580:	c3450513          	addi	a0,a0,-972 # 800061b0 <userret+0x120>
    80000584:	00000097          	auipc	ra,0x0
    80000588:	014080e7          	jalr	20(ra) # 80000598 <printf>
  panicked = 1; // freeze other CPUs
    8000058c:	4785                	li	a5,1
    8000058e:	00025717          	auipc	a4,0x25
    80000592:	a6f72923          	sw	a5,-1422(a4) # 80025000 <panicked>
  for(;;)
    80000596:	a001                	j	80000596 <panic+0x48>

0000000080000598 <printf>:
{
    80000598:	7131                	addi	sp,sp,-192
    8000059a:	fc86                	sd	ra,120(sp)
    8000059c:	f8a2                	sd	s0,112(sp)
    8000059e:	f4a6                	sd	s1,104(sp)
    800005a0:	f0ca                	sd	s2,96(sp)
    800005a2:	ecce                	sd	s3,88(sp)
    800005a4:	e8d2                	sd	s4,80(sp)
    800005a6:	e4d6                	sd	s5,72(sp)
    800005a8:	e0da                	sd	s6,64(sp)
    800005aa:	fc5e                	sd	s7,56(sp)
    800005ac:	f862                	sd	s8,48(sp)
    800005ae:	f466                	sd	s9,40(sp)
    800005b0:	f06a                	sd	s10,32(sp)
    800005b2:	ec6e                	sd	s11,24(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00010d97          	auipc	s11,0x10
    800005ce:	2f6dad83          	lw	s11,758(s11) # 800108c0 <pr+0x18>
  if(locking)
    800005d2:	020d9b63          	bnez	s11,80000608 <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0263          	beqz	s4,8000061a <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	16050263          	beqz	a0,8000074a <printf+0x1b2>
    800005ea:	4481                	li	s1,0
    if(c != '%'){
    800005ec:	02500a93          	li	s5,37
    switch(c){
    800005f0:	07000b13          	li	s6,112
  consputc('x');
    800005f4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f6:	00006b97          	auipc	s7,0x6
    800005fa:	21ab8b93          	addi	s7,s7,538 # 80006810 <digits>
    switch(c){
    800005fe:	07300c93          	li	s9,115
    80000602:	06400c13          	li	s8,100
    80000606:	a82d                	j	80000640 <printf+0xa8>
    acquire(&pr.lock);
    80000608:	00010517          	auipc	a0,0x10
    8000060c:	2a050513          	addi	a0,a0,672 # 800108a8 <pr>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	4c2080e7          	jalr	1218(ra) # 80000ad2 <acquire>
    80000618:	bf7d                	j	800005d6 <printf+0x3e>
    panic("null fmt");
    8000061a:	00006517          	auipc	a0,0x6
    8000061e:	b1650513          	addi	a0,a0,-1258 # 80006130 <userret+0xa0>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	f2c080e7          	jalr	-212(ra) # 8000054e <panic>
      consputc(c);
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	bce080e7          	jalr	-1074(ra) # 800001f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000632:	2485                	addiw	s1,s1,1
    80000634:	009a07b3          	add	a5,s4,s1
    80000638:	0007c503          	lbu	a0,0(a5)
    8000063c:	10050763          	beqz	a0,8000074a <printf+0x1b2>
    if(c != '%'){
    80000640:	ff5515e3          	bne	a0,s5,8000062a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000644:	2485                	addiw	s1,s1,1
    80000646:	009a07b3          	add	a5,s4,s1
    8000064a:	0007c783          	lbu	a5,0(a5)
    8000064e:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000652:	cfe5                	beqz	a5,8000074a <printf+0x1b2>
    switch(c){
    80000654:	05678a63          	beq	a5,s6,800006a8 <printf+0x110>
    80000658:	02fb7663          	bgeu	s6,a5,80000684 <printf+0xec>
    8000065c:	09978963          	beq	a5,s9,800006ee <printf+0x156>
    80000660:	07800713          	li	a4,120
    80000664:	0ce79863          	bne	a5,a4,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	85ea                	mv	a1,s10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e32080e7          	jalr	-462(ra) # 800004ac <printint>
      break;
    80000682:	bf45                	j	80000632 <printf+0x9a>
    switch(c){
    80000684:	0b578263          	beq	a5,s5,80000728 <printf+0x190>
    80000688:	0b879663          	bne	a5,s8,80000734 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	45a9                	li	a1,10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e0e080e7          	jalr	-498(ra) # 800004ac <printint>
      break;
    800006a6:	b771                	j	80000632 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b8:	03000513          	li	a0,48
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	b3c080e7          	jalr	-1220(ra) # 800001f8 <consputc>
  consputc('x');
    800006c4:	07800513          	li	a0,120
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	b30080e7          	jalr	-1232(ra) # 800001f8 <consputc>
    800006d0:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	03c9d793          	srli	a5,s3,0x3c
    800006d6:	97de                	add	a5,a5,s7
    800006d8:	0007c503          	lbu	a0,0(a5)
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	b1c080e7          	jalr	-1252(ra) # 800001f8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e4:	0992                	slli	s3,s3,0x4
    800006e6:	397d                	addiw	s2,s2,-1
    800006e8:	fe0915e3          	bnez	s2,800006d2 <printf+0x13a>
    800006ec:	b799                	j	80000632 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006ee:	f8843783          	ld	a5,-120(s0)
    800006f2:	00878713          	addi	a4,a5,8
    800006f6:	f8e43423          	sd	a4,-120(s0)
    800006fa:	0007b903          	ld	s2,0(a5)
    800006fe:	00090e63          	beqz	s2,8000071a <printf+0x182>
      for(; *s; s++)
    80000702:	00094503          	lbu	a0,0(s2)
    80000706:	d515                	beqz	a0,80000632 <printf+0x9a>
        consputc(*s);
    80000708:	00000097          	auipc	ra,0x0
    8000070c:	af0080e7          	jalr	-1296(ra) # 800001f8 <consputc>
      for(; *s; s++)
    80000710:	0905                	addi	s2,s2,1
    80000712:	00094503          	lbu	a0,0(s2)
    80000716:	f96d                	bnez	a0,80000708 <printf+0x170>
    80000718:	bf29                	j	80000632 <printf+0x9a>
        s = "(null)";
    8000071a:	00006917          	auipc	s2,0x6
    8000071e:	a0e90913          	addi	s2,s2,-1522 # 80006128 <userret+0x98>
      for(; *s; s++)
    80000722:	02800513          	li	a0,40
    80000726:	b7cd                	j	80000708 <printf+0x170>
      consputc('%');
    80000728:	8556                	mv	a0,s5
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	ace080e7          	jalr	-1330(ra) # 800001f8 <consputc>
      break;
    80000732:	b701                	j	80000632 <printf+0x9a>
      consputc('%');
    80000734:	8556                	mv	a0,s5
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	ac2080e7          	jalr	-1342(ra) # 800001f8 <consputc>
      consputc(c);
    8000073e:	854a                	mv	a0,s2
    80000740:	00000097          	auipc	ra,0x0
    80000744:	ab8080e7          	jalr	-1352(ra) # 800001f8 <consputc>
      break;
    80000748:	b5ed                	j	80000632 <printf+0x9a>
  if(locking)
    8000074a:	020d9163          	bnez	s11,8000076c <printf+0x1d4>
}
    8000074e:	70e6                	ld	ra,120(sp)
    80000750:	7446                	ld	s0,112(sp)
    80000752:	74a6                	ld	s1,104(sp)
    80000754:	7906                	ld	s2,96(sp)
    80000756:	69e6                	ld	s3,88(sp)
    80000758:	6a46                	ld	s4,80(sp)
    8000075a:	6aa6                	ld	s5,72(sp)
    8000075c:	6b06                	ld	s6,64(sp)
    8000075e:	7be2                	ld	s7,56(sp)
    80000760:	7c42                	ld	s8,48(sp)
    80000762:	7ca2                	ld	s9,40(sp)
    80000764:	7d02                	ld	s10,32(sp)
    80000766:	6de2                	ld	s11,24(sp)
    80000768:	6129                	addi	sp,sp,192
    8000076a:	8082                	ret
    release(&pr.lock);
    8000076c:	00010517          	auipc	a0,0x10
    80000770:	13c50513          	addi	a0,a0,316 # 800108a8 <pr>
    80000774:	00000097          	auipc	ra,0x0
    80000778:	3b2080e7          	jalr	946(ra) # 80000b26 <release>
}
    8000077c:	bfc9                	j	8000074e <printf+0x1b6>

000000008000077e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000077e:	1101                	addi	sp,sp,-32
    80000780:	ec06                	sd	ra,24(sp)
    80000782:	e822                	sd	s0,16(sp)
    80000784:	e426                	sd	s1,8(sp)
    80000786:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000788:	00010497          	auipc	s1,0x10
    8000078c:	12048493          	addi	s1,s1,288 # 800108a8 <pr>
    80000790:	00006597          	auipc	a1,0x6
    80000794:	9b058593          	addi	a1,a1,-1616 # 80006140 <userret+0xb0>
    80000798:	8526                	mv	a0,s1
    8000079a:	00000097          	auipc	ra,0x0
    8000079e:	226080e7          	jalr	550(ra) # 800009c0 <initlock>
  pr.locking = 1;
    800007a2:	4785                	li	a5,1
    800007a4:	cc9c                	sw	a5,24(s1)
}
    800007a6:	60e2                	ld	ra,24(sp)
    800007a8:	6442                	ld	s0,16(sp)
    800007aa:	64a2                	ld	s1,8(sp)
    800007ac:	6105                	addi	sp,sp,32
    800007ae:	8082                	ret

00000000800007b0 <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007b0:	1141                	addi	sp,sp,-16
    800007b2:	e422                	sd	s0,8(sp)
    800007b4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b6:	100007b7          	lui	a5,0x10000
    800007ba:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007be:	f8000713          	li	a4,-128
    800007c2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c6:	470d                	li	a4,3
    800007c8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007d0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007d4:	471d                	li	a4,7
    800007d6:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007da:	4705                	li	a4,1
    800007dc:	00e780a3          	sb	a4,1(a5)
}
    800007e0:	6422                	ld	s0,8(sp)
    800007e2:	0141                	addi	sp,sp,16
    800007e4:	8082                	ret

00000000800007e6 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    800007e6:	1141                	addi	sp,sp,-16
    800007e8:	e422                	sd	s0,8(sp)
    800007ea:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    800007ec:	10000737          	lui	a4,0x10000
    800007f0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007f4:	0ff7f793          	andi	a5,a5,255
    800007f8:	0207f793          	andi	a5,a5,32
    800007fc:	dbf5                	beqz	a5,800007f0 <uartputc+0xa>
    ;
  WriteReg(THR, c);
    800007fe:	0ff57513          	andi	a0,a0,255
    80000802:	100007b7          	lui	a5,0x10000
    80000806:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    8000080a:	6422                	ld	s0,8(sp)
    8000080c:	0141                	addi	sp,sp,16
    8000080e:	8082                	ret

0000000080000810 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000810:	1141                	addi	sp,sp,-16
    80000812:	e422                	sd	s0,8(sp)
    80000814:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000816:	100007b7          	lui	a5,0x10000
    8000081a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000081e:	8b85                	andi	a5,a5,1
    80000820:	cb91                	beqz	a5,80000834 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000082a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000082e:	6422                	ld	s0,8(sp)
    80000830:	0141                	addi	sp,sp,16
    80000832:	8082                	ret
    return -1;
    80000834:	557d                	li	a0,-1
    80000836:	bfe5                	j	8000082e <uartgetc+0x1e>

0000000080000838 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000838:	1101                	addi	sp,sp,-32
    8000083a:	ec06                	sd	ra,24(sp)
    8000083c:	e822                	sd	s0,16(sp)
    8000083e:	e426                	sd	s1,8(sp)
    80000840:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000842:	54fd                	li	s1,-1
    int c = uartgetc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	fcc080e7          	jalr	-52(ra) # 80000810 <uartgetc>
    if(c == -1)
    8000084c:	00950763          	beq	a0,s1,8000085a <uartintr+0x22>
      break;
    consoleintr(c);
    80000850:	00000097          	auipc	ra,0x0
    80000854:	a7e080e7          	jalr	-1410(ra) # 800002ce <consoleintr>
  while(1){
    80000858:	b7f5                	j	80000844 <uartintr+0xc>
  }
}
    8000085a:	60e2                	ld	ra,24(sp)
    8000085c:	6442                	ld	s0,16(sp)
    8000085e:	64a2                	ld	s1,8(sp)
    80000860:	6105                	addi	sp,sp,32
    80000862:	8082                	ret

0000000080000864 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	e04a                	sd	s2,0(sp)
    8000086e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000870:	03451793          	slli	a5,a0,0x34
    80000874:	ebb9                	bnez	a5,800008ca <kfree+0x66>
    80000876:	84aa                	mv	s1,a0
    80000878:	00024797          	auipc	a5,0x24
    8000087c:	7a478793          	addi	a5,a5,1956 # 8002501c <end>
    80000880:	04f56563          	bltu	a0,a5,800008ca <kfree+0x66>
    80000884:	47c5                	li	a5,17
    80000886:	07ee                	slli	a5,a5,0x1b
    80000888:	04f57163          	bgeu	a0,a5,800008ca <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000088c:	6605                	lui	a2,0x1
    8000088e:	4585                	li	a1,1
    80000890:	00000097          	auipc	ra,0x0
    80000894:	2de080e7          	jalr	734(ra) # 80000b6e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000898:	00010917          	auipc	s2,0x10
    8000089c:	03090913          	addi	s2,s2,48 # 800108c8 <kmem>
    800008a0:	854a                	mv	a0,s2
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	230080e7          	jalr	560(ra) # 80000ad2 <acquire>
  r->next = kmem.freelist;
    800008aa:	01893783          	ld	a5,24(s2)
    800008ae:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008b0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800008b4:	854a                	mv	a0,s2
    800008b6:	00000097          	auipc	ra,0x0
    800008ba:	270080e7          	jalr	624(ra) # 80000b26 <release>
}
    800008be:	60e2                	ld	ra,24(sp)
    800008c0:	6442                	ld	s0,16(sp)
    800008c2:	64a2                	ld	s1,8(sp)
    800008c4:	6902                	ld	s2,0(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    panic("kfree");
    800008ca:	00006517          	auipc	a0,0x6
    800008ce:	87e50513          	addi	a0,a0,-1922 # 80006148 <userret+0xb8>
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	c7c080e7          	jalr	-900(ra) # 8000054e <panic>

00000000800008da <freerange>:
{
    800008da:	7179                	addi	sp,sp,-48
    800008dc:	f406                	sd	ra,40(sp)
    800008de:	f022                	sd	s0,32(sp)
    800008e0:	ec26                	sd	s1,24(sp)
    800008e2:	e84a                	sd	s2,16(sp)
    800008e4:	e44e                	sd	s3,8(sp)
    800008e6:	e052                	sd	s4,0(sp)
    800008e8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800008ea:	6785                	lui	a5,0x1
    800008ec:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800008f0:	94aa                	add	s1,s1,a0
    800008f2:	757d                	lui	a0,0xfffff
    800008f4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800008f6:	94be                	add	s1,s1,a5
    800008f8:	0095ee63          	bltu	a1,s1,80000914 <freerange+0x3a>
    800008fc:	892e                	mv	s2,a1
    kfree(p);
    800008fe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000900:	6985                	lui	s3,0x1
    kfree(p);
    80000902:	01448533          	add	a0,s1,s4
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	f5e080e7          	jalr	-162(ra) # 80000864 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000090e:	94ce                	add	s1,s1,s3
    80000910:	fe9979e3          	bgeu	s2,s1,80000902 <freerange+0x28>
}
    80000914:	70a2                	ld	ra,40(sp)
    80000916:	7402                	ld	s0,32(sp)
    80000918:	64e2                	ld	s1,24(sp)
    8000091a:	6942                	ld	s2,16(sp)
    8000091c:	69a2                	ld	s3,8(sp)
    8000091e:	6a02                	ld	s4,0(sp)
    80000920:	6145                	addi	sp,sp,48
    80000922:	8082                	ret

0000000080000924 <kinit>:
{
    80000924:	1141                	addi	sp,sp,-16
    80000926:	e406                	sd	ra,8(sp)
    80000928:	e022                	sd	s0,0(sp)
    8000092a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000092c:	00006597          	auipc	a1,0x6
    80000930:	82458593          	addi	a1,a1,-2012 # 80006150 <userret+0xc0>
    80000934:	00010517          	auipc	a0,0x10
    80000938:	f9450513          	addi	a0,a0,-108 # 800108c8 <kmem>
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	084080e7          	jalr	132(ra) # 800009c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000944:	45c5                	li	a1,17
    80000946:	05ee                	slli	a1,a1,0x1b
    80000948:	00024517          	auipc	a0,0x24
    8000094c:	6d450513          	addi	a0,a0,1748 # 8002501c <end>
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f8a080e7          	jalr	-118(ra) # 800008da <freerange>
}
    80000958:	60a2                	ld	ra,8(sp)
    8000095a:	6402                	ld	s0,0(sp)
    8000095c:	0141                	addi	sp,sp,16
    8000095e:	8082                	ret

0000000080000960 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000960:	1101                	addi	sp,sp,-32
    80000962:	ec06                	sd	ra,24(sp)
    80000964:	e822                	sd	s0,16(sp)
    80000966:	e426                	sd	s1,8(sp)
    80000968:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000096a:	00010497          	auipc	s1,0x10
    8000096e:	f5e48493          	addi	s1,s1,-162 # 800108c8 <kmem>
    80000972:	8526                	mv	a0,s1
    80000974:	00000097          	auipc	ra,0x0
    80000978:	15e080e7          	jalr	350(ra) # 80000ad2 <acquire>
  r = kmem.freelist;
    8000097c:	6c84                	ld	s1,24(s1)
  if(r)
    8000097e:	c885                	beqz	s1,800009ae <kalloc+0x4e>
    kmem.freelist = r->next;
    80000980:	609c                	ld	a5,0(s1)
    80000982:	00010517          	auipc	a0,0x10
    80000986:	f4650513          	addi	a0,a0,-186 # 800108c8 <kmem>
    8000098a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	19a080e7          	jalr	410(ra) # 80000b26 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000994:	6605                	lui	a2,0x1
    80000996:	4595                	li	a1,5
    80000998:	8526                	mv	a0,s1
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	1d4080e7          	jalr	468(ra) # 80000b6e <memset>
  return (void*)r;
}
    800009a2:	8526                	mv	a0,s1
    800009a4:	60e2                	ld	ra,24(sp)
    800009a6:	6442                	ld	s0,16(sp)
    800009a8:	64a2                	ld	s1,8(sp)
    800009aa:	6105                	addi	sp,sp,32
    800009ac:	8082                	ret
  release(&kmem.lock);
    800009ae:	00010517          	auipc	a0,0x10
    800009b2:	f1a50513          	addi	a0,a0,-230 # 800108c8 <kmem>
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	170080e7          	jalr	368(ra) # 80000b26 <release>
  if(r)
    800009be:	b7d5                	j	800009a2 <kalloc+0x42>

00000000800009c0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800009c0:	1141                	addi	sp,sp,-16
    800009c2:	e422                	sd	s0,8(sp)
    800009c4:	0800                	addi	s0,sp,16
  lk->name = name;
    800009c6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009c8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009cc:	00053823          	sd	zero,16(a0)
}
    800009d0:	6422                	ld	s0,8(sp)
    800009d2:	0141                	addi	sp,sp,16
    800009d4:	8082                	ret

00000000800009d6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800009e0:	100024f3          	csrr	s1,sstatus
    800009e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800009e8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800009ea:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800009ee:	00001097          	auipc	ra,0x1
    800009f2:	e3a080e7          	jalr	-454(ra) # 80001828 <mycpu>
    800009f6:	5d3c                	lw	a5,120(a0)
    800009f8:	cf89                	beqz	a5,80000a12 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800009fa:	00001097          	auipc	ra,0x1
    800009fe:	e2e080e7          	jalr	-466(ra) # 80001828 <mycpu>
    80000a02:	5d3c                	lw	a5,120(a0)
    80000a04:	2785                	addiw	a5,a5,1
    80000a06:	dd3c                	sw	a5,120(a0)
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret
    mycpu()->intena = old;
    80000a12:	00001097          	auipc	ra,0x1
    80000a16:	e16080e7          	jalr	-490(ra) # 80001828 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000a1a:	8085                	srli	s1,s1,0x1
    80000a1c:	8885                	andi	s1,s1,1
    80000a1e:	dd64                	sw	s1,124(a0)
    80000a20:	bfe9                	j	800009fa <push_off+0x24>

0000000080000a22 <pop_off>:

void
pop_off(void)
{
    80000a22:	1141                	addi	sp,sp,-16
    80000a24:	e406                	sd	ra,8(sp)
    80000a26:	e022                	sd	s0,0(sp)
    80000a28:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000a2a:	00001097          	auipc	ra,0x1
    80000a2e:	dfe080e7          	jalr	-514(ra) # 80001828 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a32:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a36:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000a38:	ef8d                	bnez	a5,80000a72 <pop_off+0x50>
    panic("pop_off - interruptible");
  c->noff -= 1;
    80000a3a:	5d3c                	lw	a5,120(a0)
    80000a3c:	37fd                	addiw	a5,a5,-1
    80000a3e:	0007871b          	sext.w	a4,a5
    80000a42:	dd3c                	sw	a5,120(a0)
  if(c->noff < 0)
    80000a44:	02079693          	slli	a3,a5,0x20
    80000a48:	0206cd63          	bltz	a3,80000a82 <pop_off+0x60>
    panic("pop_off");
  if(c->noff == 0 && c->intena)
    80000a4c:	ef19                	bnez	a4,80000a6a <pop_off+0x48>
    80000a4e:	5d7c                	lw	a5,124(a0)
    80000a50:	cf89                	beqz	a5,80000a6a <pop_off+0x48>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80000a52:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000a56:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80000a5a:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000a62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a66:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000a6a:	60a2                	ld	ra,8(sp)
    80000a6c:	6402                	ld	s0,0(sp)
    80000a6e:	0141                	addi	sp,sp,16
    80000a70:	8082                	ret
    panic("pop_off - interruptible");
    80000a72:	00005517          	auipc	a0,0x5
    80000a76:	6e650513          	addi	a0,a0,1766 # 80006158 <userret+0xc8>
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ad4080e7          	jalr	-1324(ra) # 8000054e <panic>
    panic("pop_off");
    80000a82:	00005517          	auipc	a0,0x5
    80000a86:	6ee50513          	addi	a0,a0,1774 # 80006170 <userret+0xe0>
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	ac4080e7          	jalr	-1340(ra) # 8000054e <panic>

0000000080000a92 <holding>:
{
    80000a92:	1101                	addi	sp,sp,-32
    80000a94:	ec06                	sd	ra,24(sp)
    80000a96:	e822                	sd	s0,16(sp)
    80000a98:	e426                	sd	s1,8(sp)
    80000a9a:	1000                	addi	s0,sp,32
    80000a9c:	84aa                	mv	s1,a0
  push_off();
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	f38080e7          	jalr	-200(ra) # 800009d6 <push_off>
  r = (lk->locked && lk->cpu == mycpu());
    80000aa6:	409c                	lw	a5,0(s1)
    80000aa8:	ef81                	bnez	a5,80000ac0 <holding+0x2e>
    80000aaa:	4481                	li	s1,0
  pop_off();
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	f76080e7          	jalr	-138(ra) # 80000a22 <pop_off>
}
    80000ab4:	8526                	mv	a0,s1
    80000ab6:	60e2                	ld	ra,24(sp)
    80000ab8:	6442                	ld	s0,16(sp)
    80000aba:	64a2                	ld	s1,8(sp)
    80000abc:	6105                	addi	sp,sp,32
    80000abe:	8082                	ret
  r = (lk->locked && lk->cpu == mycpu());
    80000ac0:	6884                	ld	s1,16(s1)
    80000ac2:	00001097          	auipc	ra,0x1
    80000ac6:	d66080e7          	jalr	-666(ra) # 80001828 <mycpu>
    80000aca:	8c89                	sub	s1,s1,a0
    80000acc:	0014b493          	seqz	s1,s1
    80000ad0:	bff1                	j	80000aac <holding+0x1a>

0000000080000ad2 <acquire>:
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
    80000adc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	ef8080e7          	jalr	-264(ra) # 800009d6 <push_off>
  if(holding(lk))
    80000ae6:	8526                	mv	a0,s1
    80000ae8:	00000097          	auipc	ra,0x0
    80000aec:	faa080e7          	jalr	-86(ra) # 80000a92 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000af0:	4705                	li	a4,1
  if(holding(lk))
    80000af2:	e115                	bnez	a0,80000b16 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000af4:	87ba                	mv	a5,a4
    80000af6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000afa:	2781                	sext.w	a5,a5
    80000afc:	ffe5                	bnez	a5,80000af4 <acquire+0x22>
  __sync_synchronize();
    80000afe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b02:	00001097          	auipc	ra,0x1
    80000b06:	d26080e7          	jalr	-730(ra) # 80001828 <mycpu>
    80000b0a:	e888                	sd	a0,16(s1)
}
    80000b0c:	60e2                	ld	ra,24(sp)
    80000b0e:	6442                	ld	s0,16(sp)
    80000b10:	64a2                	ld	s1,8(sp)
    80000b12:	6105                	addi	sp,sp,32
    80000b14:	8082                	ret
    panic("acquire");
    80000b16:	00005517          	auipc	a0,0x5
    80000b1a:	66250513          	addi	a0,a0,1634 # 80006178 <userret+0xe8>
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	a30080e7          	jalr	-1488(ra) # 8000054e <panic>

0000000080000b26 <release>:
{
    80000b26:	1101                	addi	sp,sp,-32
    80000b28:	ec06                	sd	ra,24(sp)
    80000b2a:	e822                	sd	s0,16(sp)
    80000b2c:	e426                	sd	s1,8(sp)
    80000b2e:	1000                	addi	s0,sp,32
    80000b30:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b32:	00000097          	auipc	ra,0x0
    80000b36:	f60080e7          	jalr	-160(ra) # 80000a92 <holding>
    80000b3a:	c115                	beqz	a0,80000b5e <release+0x38>
  lk->cpu = 0;
    80000b3c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b40:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b44:	0f50000f          	fence	iorw,ow
    80000b48:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	ed6080e7          	jalr	-298(ra) # 80000a22 <pop_off>
}
    80000b54:	60e2                	ld	ra,24(sp)
    80000b56:	6442                	ld	s0,16(sp)
    80000b58:	64a2                	ld	s1,8(sp)
    80000b5a:	6105                	addi	sp,sp,32
    80000b5c:	8082                	ret
    panic("release");
    80000b5e:	00005517          	auipc	a0,0x5
    80000b62:	62250513          	addi	a0,a0,1570 # 80006180 <userret+0xf0>
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	9e8080e7          	jalr	-1560(ra) # 8000054e <panic>

0000000080000b6e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000b6e:	1141                	addi	sp,sp,-16
    80000b70:	e422                	sd	s0,8(sp)
    80000b72:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000b74:	ce09                	beqz	a2,80000b8e <memset+0x20>
    80000b76:	87aa                	mv	a5,a0
    80000b78:	fff6071b          	addiw	a4,a2,-1
    80000b7c:	1702                	slli	a4,a4,0x20
    80000b7e:	9301                	srli	a4,a4,0x20
    80000b80:	0705                	addi	a4,a4,1
    80000b82:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000b84:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000b88:	0785                	addi	a5,a5,1
    80000b8a:	fee79de3          	bne	a5,a4,80000b84 <memset+0x16>
  }
  return dst;
}
    80000b8e:	6422                	ld	s0,8(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000b94:	1141                	addi	sp,sp,-16
    80000b96:	e422                	sd	s0,8(sp)
    80000b98:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000b9a:	ca05                	beqz	a2,80000bca <memcmp+0x36>
    80000b9c:	fff6069b          	addiw	a3,a2,-1
    80000ba0:	1682                	slli	a3,a3,0x20
    80000ba2:	9281                	srli	a3,a3,0x20
    80000ba4:	0685                	addi	a3,a3,1
    80000ba6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ba8:	00054783          	lbu	a5,0(a0)
    80000bac:	0005c703          	lbu	a4,0(a1)
    80000bb0:	00e79863          	bne	a5,a4,80000bc0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000bb4:	0505                	addi	a0,a0,1
    80000bb6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000bb8:	fed518e3          	bne	a0,a3,80000ba8 <memcmp+0x14>
  }

  return 0;
    80000bbc:	4501                	li	a0,0
    80000bbe:	a019                	j	80000bc4 <memcmp+0x30>
      return *s1 - *s2;
    80000bc0:	40e7853b          	subw	a0,a5,a4
}
    80000bc4:	6422                	ld	s0,8(sp)
    80000bc6:	0141                	addi	sp,sp,16
    80000bc8:	8082                	ret
  return 0;
    80000bca:	4501                	li	a0,0
    80000bcc:	bfe5                	j	80000bc4 <memcmp+0x30>

0000000080000bce <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000bce:	1141                	addi	sp,sp,-16
    80000bd0:	e422                	sd	s0,8(sp)
    80000bd2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000bd4:	00a5f963          	bgeu	a1,a0,80000be6 <memmove+0x18>
    80000bd8:	02061713          	slli	a4,a2,0x20
    80000bdc:	9301                	srli	a4,a4,0x20
    80000bde:	00e587b3          	add	a5,a1,a4
    80000be2:	02f56563          	bltu	a0,a5,80000c0c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000be6:	fff6069b          	addiw	a3,a2,-1
    80000bea:	ce11                	beqz	a2,80000c06 <memmove+0x38>
    80000bec:	1682                	slli	a3,a3,0x20
    80000bee:	9281                	srli	a3,a3,0x20
    80000bf0:	0685                	addi	a3,a3,1
    80000bf2:	96ae                	add	a3,a3,a1
    80000bf4:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000bf6:	0585                	addi	a1,a1,1
    80000bf8:	0785                	addi	a5,a5,1
    80000bfa:	fff5c703          	lbu	a4,-1(a1)
    80000bfe:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000c02:	fed59ae3          	bne	a1,a3,80000bf6 <memmove+0x28>

  return dst;
}
    80000c06:	6422                	ld	s0,8(sp)
    80000c08:	0141                	addi	sp,sp,16
    80000c0a:	8082                	ret
    d += n;
    80000c0c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000c0e:	fff6069b          	addiw	a3,a2,-1
    80000c12:	da75                	beqz	a2,80000c06 <memmove+0x38>
    80000c14:	02069613          	slli	a2,a3,0x20
    80000c18:	9201                	srli	a2,a2,0x20
    80000c1a:	fff64613          	not	a2,a2
    80000c1e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000c20:	17fd                	addi	a5,a5,-1
    80000c22:	177d                	addi	a4,a4,-1
    80000c24:	0007c683          	lbu	a3,0(a5)
    80000c28:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000c2c:	fec79ae3          	bne	a5,a2,80000c20 <memmove+0x52>
    80000c30:	bfd9                	j	80000c06 <memmove+0x38>

0000000080000c32 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000c32:	1141                	addi	sp,sp,-16
    80000c34:	e406                	sd	ra,8(sp)
    80000c36:	e022                	sd	s0,0(sp)
    80000c38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000c3a:	00000097          	auipc	ra,0x0
    80000c3e:	f94080e7          	jalr	-108(ra) # 80000bce <memmove>
}
    80000c42:	60a2                	ld	ra,8(sp)
    80000c44:	6402                	ld	s0,0(sp)
    80000c46:	0141                	addi	sp,sp,16
    80000c48:	8082                	ret

0000000080000c4a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000c4a:	1141                	addi	sp,sp,-16
    80000c4c:	e422                	sd	s0,8(sp)
    80000c4e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000c50:	ce11                	beqz	a2,80000c6c <strncmp+0x22>
    80000c52:	00054783          	lbu	a5,0(a0)
    80000c56:	cf89                	beqz	a5,80000c70 <strncmp+0x26>
    80000c58:	0005c703          	lbu	a4,0(a1)
    80000c5c:	00f71a63          	bne	a4,a5,80000c70 <strncmp+0x26>
    n--, p++, q++;
    80000c60:	367d                	addiw	a2,a2,-1
    80000c62:	0505                	addi	a0,a0,1
    80000c64:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000c66:	f675                	bnez	a2,80000c52 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000c68:	4501                	li	a0,0
    80000c6a:	a809                	j	80000c7c <strncmp+0x32>
    80000c6c:	4501                	li	a0,0
    80000c6e:	a039                	j	80000c7c <strncmp+0x32>
  if(n == 0)
    80000c70:	ca09                	beqz	a2,80000c82 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000c72:	00054503          	lbu	a0,0(a0)
    80000c76:	0005c783          	lbu	a5,0(a1)
    80000c7a:	9d1d                	subw	a0,a0,a5
}
    80000c7c:	6422                	ld	s0,8(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    return 0;
    80000c82:	4501                	li	a0,0
    80000c84:	bfe5                	j	80000c7c <strncmp+0x32>

0000000080000c86 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000c86:	1141                	addi	sp,sp,-16
    80000c88:	e422                	sd	s0,8(sp)
    80000c8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000c8c:	872a                	mv	a4,a0
    80000c8e:	8832                	mv	a6,a2
    80000c90:	367d                	addiw	a2,a2,-1
    80000c92:	01005963          	blez	a6,80000ca4 <strncpy+0x1e>
    80000c96:	0705                	addi	a4,a4,1
    80000c98:	0005c783          	lbu	a5,0(a1)
    80000c9c:	fef70fa3          	sb	a5,-1(a4)
    80000ca0:	0585                	addi	a1,a1,1
    80000ca2:	f7f5                	bnez	a5,80000c8e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ca4:	00c05d63          	blez	a2,80000cbe <strncpy+0x38>
    80000ca8:	86ba                	mv	a3,a4
    *s++ = 0;
    80000caa:	0685                	addi	a3,a3,1
    80000cac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000cb0:	fff6c793          	not	a5,a3
    80000cb4:	9fb9                	addw	a5,a5,a4
    80000cb6:	010787bb          	addw	a5,a5,a6
    80000cba:	fef048e3          	bgtz	a5,80000caa <strncpy+0x24>
  return os;
}
    80000cbe:	6422                	ld	s0,8(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret

0000000080000cc4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000cc4:	1141                	addi	sp,sp,-16
    80000cc6:	e422                	sd	s0,8(sp)
    80000cc8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000cca:	02c05363          	blez	a2,80000cf0 <safestrcpy+0x2c>
    80000cce:	fff6069b          	addiw	a3,a2,-1
    80000cd2:	1682                	slli	a3,a3,0x20
    80000cd4:	9281                	srli	a3,a3,0x20
    80000cd6:	96ae                	add	a3,a3,a1
    80000cd8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000cda:	00d58963          	beq	a1,a3,80000cec <safestrcpy+0x28>
    80000cde:	0585                	addi	a1,a1,1
    80000ce0:	0785                	addi	a5,a5,1
    80000ce2:	fff5c703          	lbu	a4,-1(a1)
    80000ce6:	fee78fa3          	sb	a4,-1(a5)
    80000cea:	fb65                	bnez	a4,80000cda <safestrcpy+0x16>
    ;
  *s = 0;
    80000cec:	00078023          	sb	zero,0(a5)
  return os;
}
    80000cf0:	6422                	ld	s0,8(sp)
    80000cf2:	0141                	addi	sp,sp,16
    80000cf4:	8082                	ret

0000000080000cf6 <strlen>:

int
strlen(const char *s)
{
    80000cf6:	1141                	addi	sp,sp,-16
    80000cf8:	e422                	sd	s0,8(sp)
    80000cfa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000cfc:	00054783          	lbu	a5,0(a0)
    80000d00:	cf91                	beqz	a5,80000d1c <strlen+0x26>
    80000d02:	0505                	addi	a0,a0,1
    80000d04:	87aa                	mv	a5,a0
    80000d06:	4685                	li	a3,1
    80000d08:	9e89                	subw	a3,a3,a0
    80000d0a:	00f6853b          	addw	a0,a3,a5
    80000d0e:	0785                	addi	a5,a5,1
    80000d10:	fff7c703          	lbu	a4,-1(a5)
    80000d14:	fb7d                	bnez	a4,80000d0a <strlen+0x14>
    ;
  return n;
}
    80000d16:	6422                	ld	s0,8(sp)
    80000d18:	0141                	addi	sp,sp,16
    80000d1a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000d1c:	4501                	li	a0,0
    80000d1e:	bfe5                	j	80000d16 <strlen+0x20>

0000000080000d20 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000d20:	1141                	addi	sp,sp,-16
    80000d22:	e406                	sd	ra,8(sp)
    80000d24:	e022                	sd	s0,0(sp)
    80000d26:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000d28:	00001097          	auipc	ra,0x1
    80000d2c:	af0080e7          	jalr	-1296(ra) # 80001818 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000d30:	00024717          	auipc	a4,0x24
    80000d34:	2d470713          	addi	a4,a4,724 # 80025004 <started>
  if(cpuid() == 0){
    80000d38:	c139                	beqz	a0,80000d7e <main+0x5e>
    while(started == 0)
    80000d3a:	431c                	lw	a5,0(a4)
    80000d3c:	2781                	sext.w	a5,a5
    80000d3e:	dff5                	beqz	a5,80000d3a <main+0x1a>
      ;
    __sync_synchronize();
    80000d40:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000d44:	00001097          	auipc	ra,0x1
    80000d48:	ad4080e7          	jalr	-1324(ra) # 80001818 <cpuid>
    80000d4c:	85aa                	mv	a1,a0
    80000d4e:	00005517          	auipc	a0,0x5
    80000d52:	45250513          	addi	a0,a0,1106 # 800061a0 <userret+0x110>
    80000d56:	00000097          	auipc	ra,0x0
    80000d5a:	842080e7          	jalr	-1982(ra) # 80000598 <printf>
    kvminithart();    // turn on paging
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	1e8080e7          	jalr	488(ra) # 80000f46 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000d66:	00001097          	auipc	ra,0x1
    80000d6a:	6fe080e7          	jalr	1790(ra) # 80002464 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000d6e:	00005097          	auipc	ra,0x5
    80000d72:	c22080e7          	jalr	-990(ra) # 80005990 <plicinithart>
  }

  scheduler();        
    80000d76:	00001097          	auipc	ra,0x1
    80000d7a:	fa8080e7          	jalr	-88(ra) # 80001d1e <scheduler>
    consoleinit();
    80000d7e:	fffff097          	auipc	ra,0xfffff
    80000d82:	6e2080e7          	jalr	1762(ra) # 80000460 <consoleinit>
    printfinit();
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	9f8080e7          	jalr	-1544(ra) # 8000077e <printfinit>
    printf("\n");
    80000d8e:	00005517          	auipc	a0,0x5
    80000d92:	42250513          	addi	a0,a0,1058 # 800061b0 <userret+0x120>
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	802080e7          	jalr	-2046(ra) # 80000598 <printf>
    printf("xv6 kernel is booting\n");
    80000d9e:	00005517          	auipc	a0,0x5
    80000da2:	3ea50513          	addi	a0,a0,1002 # 80006188 <userret+0xf8>
    80000da6:	fffff097          	auipc	ra,0xfffff
    80000daa:	7f2080e7          	jalr	2034(ra) # 80000598 <printf>
    printf("\n");
    80000dae:	00005517          	auipc	a0,0x5
    80000db2:	40250513          	addi	a0,a0,1026 # 800061b0 <userret+0x120>
    80000db6:	fffff097          	auipc	ra,0xfffff
    80000dba:	7e2080e7          	jalr	2018(ra) # 80000598 <printf>
    kinit();         // physical page allocator
    80000dbe:	00000097          	auipc	ra,0x0
    80000dc2:	b66080e7          	jalr	-1178(ra) # 80000924 <kinit>
    kvminit();       // create kernel page table
    80000dc6:	00000097          	auipc	ra,0x0
    80000dca:	30a080e7          	jalr	778(ra) # 800010d0 <kvminit>
    kvminithart();   // turn on paging
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	178080e7          	jalr	376(ra) # 80000f46 <kvminithart>
    procinit();      // process table
    80000dd6:	00001097          	auipc	ra,0x1
    80000dda:	972080e7          	jalr	-1678(ra) # 80001748 <procinit>
    trapinit();      // trap vectors
    80000dde:	00001097          	auipc	ra,0x1
    80000de2:	65e080e7          	jalr	1630(ra) # 8000243c <trapinit>
    trapinithart();  // install kernel trap vector
    80000de6:	00001097          	auipc	ra,0x1
    80000dea:	67e080e7          	jalr	1662(ra) # 80002464 <trapinithart>
    plicinit();      // set up interrupt controller
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	b8c080e7          	jalr	-1140(ra) # 8000597a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000df6:	00005097          	auipc	ra,0x5
    80000dfa:	b9a080e7          	jalr	-1126(ra) # 80005990 <plicinithart>
    binit();         // buffer cache
    80000dfe:	00002097          	auipc	ra,0x2
    80000e02:	d9e080e7          	jalr	-610(ra) # 80002b9c <binit>
    iinit();         // inode cache
    80000e06:	00002097          	auipc	ra,0x2
    80000e0a:	42e080e7          	jalr	1070(ra) # 80003234 <iinit>
    fileinit();      // file table
    80000e0e:	00003097          	auipc	ra,0x3
    80000e12:	3a2080e7          	jalr	930(ra) # 800041b0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	c94080e7          	jalr	-876(ra) # 80005aaa <virtio_disk_init>
    userinit();      // first user process
    80000e1e:	00001097          	auipc	ra,0x1
    80000e22:	c9a080e7          	jalr	-870(ra) # 80001ab8 <userinit>
    __sync_synchronize();
    80000e26:	0ff0000f          	fence
    started = 1;
    80000e2a:	4785                	li	a5,1
    80000e2c:	00024717          	auipc	a4,0x24
    80000e30:	1cf72c23          	sw	a5,472(a4) # 80025004 <started>
    80000e34:	b789                	j	80000d76 <main+0x56>

0000000080000e36 <walk>:
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000e36:	7139                	addi	sp,sp,-64
    80000e38:	fc06                	sd	ra,56(sp)
    80000e3a:	f822                	sd	s0,48(sp)
    80000e3c:	f426                	sd	s1,40(sp)
    80000e3e:	f04a                	sd	s2,32(sp)
    80000e40:	ec4e                	sd	s3,24(sp)
    80000e42:	e852                	sd	s4,16(sp)
    80000e44:	e456                	sd	s5,8(sp)
    80000e46:	e05a                	sd	s6,0(sp)
    80000e48:	0080                	addi	s0,sp,64
    80000e4a:	84aa                	mv	s1,a0
    80000e4c:	89ae                	mv	s3,a1
    80000e4e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000e50:	57fd                	li	a5,-1
    80000e52:	83e9                	srli	a5,a5,0x1a
    80000e54:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000e56:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000e58:	04b7f263          	bgeu	a5,a1,80000e9c <walk+0x66>
    panic("walk");
    80000e5c:	00005517          	auipc	a0,0x5
    80000e60:	35c50513          	addi	a0,a0,860 # 800061b8 <userret+0x128>
    80000e64:	fffff097          	auipc	ra,0xfffff
    80000e68:	6ea080e7          	jalr	1770(ra) # 8000054e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000e6c:	060a8663          	beqz	s5,80000ed8 <walk+0xa2>
    80000e70:	00000097          	auipc	ra,0x0
    80000e74:	af0080e7          	jalr	-1296(ra) # 80000960 <kalloc>
    80000e78:	84aa                	mv	s1,a0
    80000e7a:	c529                	beqz	a0,80000ec4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000e7c:	6605                	lui	a2,0x1
    80000e7e:	4581                	li	a1,0
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	cee080e7          	jalr	-786(ra) # 80000b6e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000e88:	00c4d793          	srli	a5,s1,0xc
    80000e8c:	07aa                	slli	a5,a5,0xa
    80000e8e:	0017e793          	ori	a5,a5,1
    80000e92:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000e96:	3a5d                	addiw	s4,s4,-9
    80000e98:	036a0063          	beq	s4,s6,80000eb8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000e9c:	0149d933          	srl	s2,s3,s4
    80000ea0:	1ff97913          	andi	s2,s2,511
    80000ea4:	090e                	slli	s2,s2,0x3
    80000ea6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000ea8:	00093483          	ld	s1,0(s2)
    80000eac:	0014f793          	andi	a5,s1,1
    80000eb0:	dfd5                	beqz	a5,80000e6c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000eb2:	80a9                	srli	s1,s1,0xa
    80000eb4:	04b2                	slli	s1,s1,0xc
    80000eb6:	b7c5                	j	80000e96 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000eb8:	00c9d513          	srli	a0,s3,0xc
    80000ebc:	1ff57513          	andi	a0,a0,511
    80000ec0:	050e                	slli	a0,a0,0x3
    80000ec2:	9526                	add	a0,a0,s1
}
    80000ec4:	70e2                	ld	ra,56(sp)
    80000ec6:	7442                	ld	s0,48(sp)
    80000ec8:	74a2                	ld	s1,40(sp)
    80000eca:	7902                	ld	s2,32(sp)
    80000ecc:	69e2                	ld	s3,24(sp)
    80000ece:	6a42                	ld	s4,16(sp)
    80000ed0:	6aa2                	ld	s5,8(sp)
    80000ed2:	6b02                	ld	s6,0(sp)
    80000ed4:	6121                	addi	sp,sp,64
    80000ed6:	8082                	ret
        return 0;
    80000ed8:	4501                	li	a0,0
    80000eda:	b7ed                	j	80000ec4 <walk+0x8e>

0000000080000edc <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void
freewalk(pagetable_t pagetable)
{
    80000edc:	7179                	addi	sp,sp,-48
    80000ede:	f406                	sd	ra,40(sp)
    80000ee0:	f022                	sd	s0,32(sp)
    80000ee2:	ec26                	sd	s1,24(sp)
    80000ee4:	e84a                	sd	s2,16(sp)
    80000ee6:	e44e                	sd	s3,8(sp)
    80000ee8:	e052                	sd	s4,0(sp)
    80000eea:	1800                	addi	s0,sp,48
    80000eec:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000eee:	84aa                	mv	s1,a0
    80000ef0:	6905                	lui	s2,0x1
    80000ef2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ef4:	4985                	li	s3,1
    80000ef6:	a821                	j	80000f0e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000ef8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000efa:	0532                	slli	a0,a0,0xc
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	fe0080e7          	jalr	-32(ra) # 80000edc <freewalk>
      pagetable[i] = 0;
    80000f04:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000f08:	04a1                	addi	s1,s1,8
    80000f0a:	03248163          	beq	s1,s2,80000f2c <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000f0e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000f10:	00f57793          	andi	a5,a0,15
    80000f14:	ff3782e3          	beq	a5,s3,80000ef8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000f18:	8905                	andi	a0,a0,1
    80000f1a:	d57d                	beqz	a0,80000f08 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000f1c:	00005517          	auipc	a0,0x5
    80000f20:	2a450513          	addi	a0,a0,676 # 800061c0 <userret+0x130>
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	62a080e7          	jalr	1578(ra) # 8000054e <panic>
    }
  }
  kfree((void*)pagetable);
    80000f2c:	8552                	mv	a0,s4
    80000f2e:	00000097          	auipc	ra,0x0
    80000f32:	936080e7          	jalr	-1738(ra) # 80000864 <kfree>
}
    80000f36:	70a2                	ld	ra,40(sp)
    80000f38:	7402                	ld	s0,32(sp)
    80000f3a:	64e2                	ld	s1,24(sp)
    80000f3c:	6942                	ld	s2,16(sp)
    80000f3e:	69a2                	ld	s3,8(sp)
    80000f40:	6a02                	ld	s4,0(sp)
    80000f42:	6145                	addi	sp,sp,48
    80000f44:	8082                	ret

0000000080000f46 <kvminithart>:
{
    80000f46:	1141                	addi	sp,sp,-16
    80000f48:	e422                	sd	s0,8(sp)
    80000f4a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f4c:	00024797          	auipc	a5,0x24
    80000f50:	0bc7b783          	ld	a5,188(a5) # 80025008 <kernel_pagetable>
    80000f54:	83b1                	srli	a5,a5,0xc
    80000f56:	577d                	li	a4,-1
    80000f58:	177e                	slli	a4,a4,0x3f
    80000f5a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f5c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f60:	12000073          	sfence.vma
}
    80000f64:	6422                	ld	s0,8(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret

0000000080000f6a <walkaddr>:
  if(va >= MAXVA)
    80000f6a:	57fd                	li	a5,-1
    80000f6c:	83e9                	srli	a5,a5,0x1a
    80000f6e:	00b7f463          	bgeu	a5,a1,80000f76 <walkaddr+0xc>
    return 0;
    80000f72:	4501                	li	a0,0
}
    80000f74:	8082                	ret
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000f7e:	4601                	li	a2,0
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	eb6080e7          	jalr	-330(ra) # 80000e36 <walk>
  if(pte == 0)
    80000f88:	c105                	beqz	a0,80000fa8 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000f8a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000f8c:	0117f693          	andi	a3,a5,17
    80000f90:	4745                	li	a4,17
    return 0;
    80000f92:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000f94:	00e68663          	beq	a3,a4,80000fa0 <walkaddr+0x36>
}
    80000f98:	60a2                	ld	ra,8(sp)
    80000f9a:	6402                	ld	s0,0(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret
  pa = PTE2PA(*pte);
    80000fa0:	00a7d513          	srli	a0,a5,0xa
    80000fa4:	0532                	slli	a0,a0,0xc
  return pa;
    80000fa6:	bfcd                	j	80000f98 <walkaddr+0x2e>
    return 0;
    80000fa8:	4501                	li	a0,0
    80000faa:	b7fd                	j	80000f98 <walkaddr+0x2e>

0000000080000fac <kvmpa>:
{
    80000fac:	1101                	addi	sp,sp,-32
    80000fae:	ec06                	sd	ra,24(sp)
    80000fb0:	e822                	sd	s0,16(sp)
    80000fb2:	e426                	sd	s1,8(sp)
    80000fb4:	1000                	addi	s0,sp,32
    80000fb6:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    80000fb8:	1552                	slli	a0,a0,0x34
    80000fba:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    80000fbe:	4601                	li	a2,0
    80000fc0:	00024517          	auipc	a0,0x24
    80000fc4:	04853503          	ld	a0,72(a0) # 80025008 <kernel_pagetable>
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	e6e080e7          	jalr	-402(ra) # 80000e36 <walk>
  if(pte == 0)
    80000fd0:	cd09                	beqz	a0,80000fea <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    80000fd2:	6108                	ld	a0,0(a0)
    80000fd4:	00157793          	andi	a5,a0,1
    80000fd8:	c38d                	beqz	a5,80000ffa <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    80000fda:	8129                	srli	a0,a0,0xa
    80000fdc:	0532                	slli	a0,a0,0xc
}
    80000fde:	9526                	add	a0,a0,s1
    80000fe0:	60e2                	ld	ra,24(sp)
    80000fe2:	6442                	ld	s0,16(sp)
    80000fe4:	64a2                	ld	s1,8(sp)
    80000fe6:	6105                	addi	sp,sp,32
    80000fe8:	8082                	ret
    panic("kvmpa");
    80000fea:	00005517          	auipc	a0,0x5
    80000fee:	1e650513          	addi	a0,a0,486 # 800061d0 <userret+0x140>
    80000ff2:	fffff097          	auipc	ra,0xfffff
    80000ff6:	55c080e7          	jalr	1372(ra) # 8000054e <panic>
    panic("kvmpa");
    80000ffa:	00005517          	auipc	a0,0x5
    80000ffe:	1d650513          	addi	a0,a0,470 # 800061d0 <userret+0x140>
    80001002:	fffff097          	auipc	ra,0xfffff
    80001006:	54c080e7          	jalr	1356(ra) # 8000054e <panic>

000000008000100a <mappages>:
{
    8000100a:	715d                	addi	sp,sp,-80
    8000100c:	e486                	sd	ra,72(sp)
    8000100e:	e0a2                	sd	s0,64(sp)
    80001010:	fc26                	sd	s1,56(sp)
    80001012:	f84a                	sd	s2,48(sp)
    80001014:	f44e                	sd	s3,40(sp)
    80001016:	f052                	sd	s4,32(sp)
    80001018:	ec56                	sd	s5,24(sp)
    8000101a:	e85a                	sd	s6,16(sp)
    8000101c:	e45e                	sd	s7,8(sp)
    8000101e:	0880                	addi	s0,sp,80
    80001020:	8aaa                	mv	s5,a0
    80001022:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001024:	777d                	lui	a4,0xfffff
    80001026:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000102a:	167d                	addi	a2,a2,-1
    8000102c:	00b609b3          	add	s3,a2,a1
    80001030:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001034:	893e                	mv	s2,a5
    80001036:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000103a:	6b85                	lui	s7,0x1
    8000103c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001040:	4605                	li	a2,1
    80001042:	85ca                	mv	a1,s2
    80001044:	8556                	mv	a0,s5
    80001046:	00000097          	auipc	ra,0x0
    8000104a:	df0080e7          	jalr	-528(ra) # 80000e36 <walk>
    8000104e:	c51d                	beqz	a0,8000107c <mappages+0x72>
    if(*pte & PTE_V)
    80001050:	611c                	ld	a5,0(a0)
    80001052:	8b85                	andi	a5,a5,1
    80001054:	ef81                	bnez	a5,8000106c <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001056:	80b1                	srli	s1,s1,0xc
    80001058:	04aa                	slli	s1,s1,0xa
    8000105a:	0164e4b3          	or	s1,s1,s6
    8000105e:	0014e493          	ori	s1,s1,1
    80001062:	e104                	sd	s1,0(a0)
    if(a == last)
    80001064:	03390863          	beq	s2,s3,80001094 <mappages+0x8a>
    a += PGSIZE;
    80001068:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000106a:	bfc9                	j	8000103c <mappages+0x32>
      panic("remap");
    8000106c:	00005517          	auipc	a0,0x5
    80001070:	16c50513          	addi	a0,a0,364 # 800061d8 <userret+0x148>
    80001074:	fffff097          	auipc	ra,0xfffff
    80001078:	4da080e7          	jalr	1242(ra) # 8000054e <panic>
      return -1;
    8000107c:	557d                	li	a0,-1
}
    8000107e:	60a6                	ld	ra,72(sp)
    80001080:	6406                	ld	s0,64(sp)
    80001082:	74e2                	ld	s1,56(sp)
    80001084:	7942                	ld	s2,48(sp)
    80001086:	79a2                	ld	s3,40(sp)
    80001088:	7a02                	ld	s4,32(sp)
    8000108a:	6ae2                	ld	s5,24(sp)
    8000108c:	6b42                	ld	s6,16(sp)
    8000108e:	6ba2                	ld	s7,8(sp)
    80001090:	6161                	addi	sp,sp,80
    80001092:	8082                	ret
  return 0;
    80001094:	4501                	li	a0,0
    80001096:	b7e5                	j	8000107e <mappages+0x74>

0000000080001098 <kvmmap>:
{
    80001098:	1141                	addi	sp,sp,-16
    8000109a:	e406                	sd	ra,8(sp)
    8000109c:	e022                	sd	s0,0(sp)
    8000109e:	0800                	addi	s0,sp,16
    800010a0:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800010a2:	86ae                	mv	a3,a1
    800010a4:	85aa                	mv	a1,a0
    800010a6:	00024517          	auipc	a0,0x24
    800010aa:	f6253503          	ld	a0,-158(a0) # 80025008 <kernel_pagetable>
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	f5c080e7          	jalr	-164(ra) # 8000100a <mappages>
    800010b6:	e509                	bnez	a0,800010c0 <kvmmap+0x28>
}
    800010b8:	60a2                	ld	ra,8(sp)
    800010ba:	6402                	ld	s0,0(sp)
    800010bc:	0141                	addi	sp,sp,16
    800010be:	8082                	ret
    panic("kvmmap");
    800010c0:	00005517          	auipc	a0,0x5
    800010c4:	12050513          	addi	a0,a0,288 # 800061e0 <userret+0x150>
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	486080e7          	jalr	1158(ra) # 8000054e <panic>

00000000800010d0 <kvminit>:
{
    800010d0:	1101                	addi	sp,sp,-32
    800010d2:	ec06                	sd	ra,24(sp)
    800010d4:	e822                	sd	s0,16(sp)
    800010d6:	e426                	sd	s1,8(sp)
    800010d8:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800010da:	00000097          	auipc	ra,0x0
    800010de:	886080e7          	jalr	-1914(ra) # 80000960 <kalloc>
    800010e2:	00024797          	auipc	a5,0x24
    800010e6:	f2a7b323          	sd	a0,-218(a5) # 80025008 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800010ea:	6605                	lui	a2,0x1
    800010ec:	4581                	li	a1,0
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	a80080e7          	jalr	-1408(ra) # 80000b6e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010f6:	4699                	li	a3,6
    800010f8:	6605                	lui	a2,0x1
    800010fa:	100005b7          	lui	a1,0x10000
    800010fe:	10000537          	lui	a0,0x10000
    80001102:	00000097          	auipc	ra,0x0
    80001106:	f96080e7          	jalr	-106(ra) # 80001098 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000110a:	4699                	li	a3,6
    8000110c:	6605                	lui	a2,0x1
    8000110e:	100015b7          	lui	a1,0x10001
    80001112:	10001537          	lui	a0,0x10001
    80001116:	00000097          	auipc	ra,0x0
    8000111a:	f82080e7          	jalr	-126(ra) # 80001098 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    8000111e:	4699                	li	a3,6
    80001120:	6641                	lui	a2,0x10
    80001122:	020005b7          	lui	a1,0x2000
    80001126:	02000537          	lui	a0,0x2000
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f6e080e7          	jalr	-146(ra) # 80001098 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001132:	4699                	li	a3,6
    80001134:	00400637          	lui	a2,0x400
    80001138:	0c0005b7          	lui	a1,0xc000
    8000113c:	0c000537          	lui	a0,0xc000
    80001140:	00000097          	auipc	ra,0x0
    80001144:	f58080e7          	jalr	-168(ra) # 80001098 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001148:	00006497          	auipc	s1,0x6
    8000114c:	eb848493          	addi	s1,s1,-328 # 80007000 <initcode>
    80001150:	46a9                	li	a3,10
    80001152:	80006617          	auipc	a2,0x80006
    80001156:	eae60613          	addi	a2,a2,-338 # 7000 <_entry-0x7fff9000>
    8000115a:	4585                	li	a1,1
    8000115c:	05fe                	slli	a1,a1,0x1f
    8000115e:	852e                	mv	a0,a1
    80001160:	00000097          	auipc	ra,0x0
    80001164:	f38080e7          	jalr	-200(ra) # 80001098 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001168:	4699                	li	a3,6
    8000116a:	4645                	li	a2,17
    8000116c:	066e                	slli	a2,a2,0x1b
    8000116e:	8e05                	sub	a2,a2,s1
    80001170:	85a6                	mv	a1,s1
    80001172:	8526                	mv	a0,s1
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f24080e7          	jalr	-220(ra) # 80001098 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000117c:	46a9                	li	a3,10
    8000117e:	6605                	lui	a2,0x1
    80001180:	00005597          	auipc	a1,0x5
    80001184:	e8058593          	addi	a1,a1,-384 # 80006000 <trampoline>
    80001188:	04000537          	lui	a0,0x4000
    8000118c:	157d                	addi	a0,a0,-1
    8000118e:	0532                	slli	a0,a0,0xc
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f08080e7          	jalr	-248(ra) # 80001098 <kvmmap>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <uvmunmap>:
{
    800011a2:	715d                	addi	sp,sp,-80
    800011a4:	e486                	sd	ra,72(sp)
    800011a6:	e0a2                	sd	s0,64(sp)
    800011a8:	fc26                	sd	s1,56(sp)
    800011aa:	f84a                	sd	s2,48(sp)
    800011ac:	f44e                	sd	s3,40(sp)
    800011ae:	f052                	sd	s4,32(sp)
    800011b0:	ec56                	sd	s5,24(sp)
    800011b2:	e85a                	sd	s6,16(sp)
    800011b4:	e45e                	sd	s7,8(sp)
    800011b6:	0880                	addi	s0,sp,80
    800011b8:	8a2a                	mv	s4,a0
    800011ba:	8ab6                	mv	s5,a3
  a = PGROUNDDOWN(va);
    800011bc:	77fd                	lui	a5,0xfffff
    800011be:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800011c2:	167d                	addi	a2,a2,-1
    800011c4:	00b609b3          	add	s3,a2,a1
    800011c8:	00f9f9b3          	and	s3,s3,a5
    if(PTE_FLAGS(*pte) == PTE_V)
    800011cc:	4b05                	li	s6,1
    a += PGSIZE;
    800011ce:	6b85                	lui	s7,0x1
    800011d0:	a8b1                	j	8000122c <uvmunmap+0x8a>
      panic("uvmunmap: walk");
    800011d2:	00005517          	auipc	a0,0x5
    800011d6:	01650513          	addi	a0,a0,22 # 800061e8 <userret+0x158>
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	374080e7          	jalr	884(ra) # 8000054e <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800011e2:	862a                	mv	a2,a0
    800011e4:	85ca                	mv	a1,s2
    800011e6:	00005517          	auipc	a0,0x5
    800011ea:	01250513          	addi	a0,a0,18 # 800061f8 <userret+0x168>
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	3aa080e7          	jalr	938(ra) # 80000598 <printf>
      panic("uvmunmap: not mapped");
    800011f6:	00005517          	auipc	a0,0x5
    800011fa:	01250513          	addi	a0,a0,18 # 80006208 <userret+0x178>
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	350080e7          	jalr	848(ra) # 8000054e <panic>
      panic("uvmunmap: not a leaf");
    80001206:	00005517          	auipc	a0,0x5
    8000120a:	01a50513          	addi	a0,a0,26 # 80006220 <userret+0x190>
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	340080e7          	jalr	832(ra) # 8000054e <panic>
      pa = PTE2PA(*pte);
    80001216:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001218:	0532                	slli	a0,a0,0xc
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	64a080e7          	jalr	1610(ra) # 80000864 <kfree>
    *pte = 0;
    80001222:	0004b023          	sd	zero,0(s1)
    if(a == last)
    80001226:	03390763          	beq	s2,s3,80001254 <uvmunmap+0xb2>
    a += PGSIZE;
    8000122a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 0)) == 0)
    8000122c:	4601                	li	a2,0
    8000122e:	85ca                	mv	a1,s2
    80001230:	8552                	mv	a0,s4
    80001232:	00000097          	auipc	ra,0x0
    80001236:	c04080e7          	jalr	-1020(ra) # 80000e36 <walk>
    8000123a:	84aa                	mv	s1,a0
    8000123c:	d959                	beqz	a0,800011d2 <uvmunmap+0x30>
    if((*pte & PTE_V) == 0){
    8000123e:	6108                	ld	a0,0(a0)
    80001240:	00157793          	andi	a5,a0,1
    80001244:	dfd9                	beqz	a5,800011e2 <uvmunmap+0x40>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001246:	3ff57793          	andi	a5,a0,1023
    8000124a:	fb678ee3          	beq	a5,s6,80001206 <uvmunmap+0x64>
    if(do_free){
    8000124e:	fc0a8ae3          	beqz	s5,80001222 <uvmunmap+0x80>
    80001252:	b7d1                	j	80001216 <uvmunmap+0x74>
}
    80001254:	60a6                	ld	ra,72(sp)
    80001256:	6406                	ld	s0,64(sp)
    80001258:	74e2                	ld	s1,56(sp)
    8000125a:	7942                	ld	s2,48(sp)
    8000125c:	79a2                	ld	s3,40(sp)
    8000125e:	7a02                	ld	s4,32(sp)
    80001260:	6ae2                	ld	s5,24(sp)
    80001262:	6b42                	ld	s6,16(sp)
    80001264:	6ba2                	ld	s7,8(sp)
    80001266:	6161                	addi	sp,sp,80
    80001268:	8082                	ret

000000008000126a <uvmcreate>:
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	6ec080e7          	jalr	1772(ra) # 80000960 <kalloc>
  if(pagetable == 0)
    8000127c:	cd11                	beqz	a0,80001298 <uvmcreate+0x2e>
    8000127e:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    80001280:	6605                	lui	a2,0x1
    80001282:	4581                	li	a1,0
    80001284:	00000097          	auipc	ra,0x0
    80001288:	8ea080e7          	jalr	-1814(ra) # 80000b6e <memset>
}
    8000128c:	8526                	mv	a0,s1
    8000128e:	60e2                	ld	ra,24(sp)
    80001290:	6442                	ld	s0,16(sp)
    80001292:	64a2                	ld	s1,8(sp)
    80001294:	6105                	addi	sp,sp,32
    80001296:	8082                	ret
    panic("uvmcreate: out of memory");
    80001298:	00005517          	auipc	a0,0x5
    8000129c:	fa050513          	addi	a0,a0,-96 # 80006238 <userret+0x1a8>
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	2ae080e7          	jalr	686(ra) # 8000054e <panic>

00000000800012a8 <uvminit>:
{
    800012a8:	7179                	addi	sp,sp,-48
    800012aa:	f406                	sd	ra,40(sp)
    800012ac:	f022                	sd	s0,32(sp)
    800012ae:	ec26                	sd	s1,24(sp)
    800012b0:	e84a                	sd	s2,16(sp)
    800012b2:	e44e                	sd	s3,8(sp)
    800012b4:	e052                	sd	s4,0(sp)
    800012b6:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800012b8:	6785                	lui	a5,0x1
    800012ba:	04f67863          	bgeu	a2,a5,8000130a <uvminit+0x62>
    800012be:	8a2a                	mv	s4,a0
    800012c0:	89ae                	mv	s3,a1
    800012c2:	84b2                	mv	s1,a2
  mem = kalloc();
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	69c080e7          	jalr	1692(ra) # 80000960 <kalloc>
    800012cc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012ce:	6605                	lui	a2,0x1
    800012d0:	4581                	li	a1,0
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	89c080e7          	jalr	-1892(ra) # 80000b6e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012da:	4779                	li	a4,30
    800012dc:	86ca                	mv	a3,s2
    800012de:	6605                	lui	a2,0x1
    800012e0:	4581                	li	a1,0
    800012e2:	8552                	mv	a0,s4
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	d26080e7          	jalr	-730(ra) # 8000100a <mappages>
  memmove(mem, src, sz);
    800012ec:	8626                	mv	a2,s1
    800012ee:	85ce                	mv	a1,s3
    800012f0:	854a                	mv	a0,s2
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	8dc080e7          	jalr	-1828(ra) # 80000bce <memmove>
}
    800012fa:	70a2                	ld	ra,40(sp)
    800012fc:	7402                	ld	s0,32(sp)
    800012fe:	64e2                	ld	s1,24(sp)
    80001300:	6942                	ld	s2,16(sp)
    80001302:	69a2                	ld	s3,8(sp)
    80001304:	6a02                	ld	s4,0(sp)
    80001306:	6145                	addi	sp,sp,48
    80001308:	8082                	ret
    panic("inituvm: more than a page");
    8000130a:	00005517          	auipc	a0,0x5
    8000130e:	f4e50513          	addi	a0,a0,-178 # 80006258 <userret+0x1c8>
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	23c080e7          	jalr	572(ra) # 8000054e <panic>

000000008000131a <uvmdealloc>:
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
    return oldsz;
    80001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001326:	00b67d63          	bgeu	a2,a1,80001340 <uvmdealloc+0x26>
    8000132a:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    8000132c:	6785                	lui	a5,0x1
    8000132e:	17fd                	addi	a5,a5,-1
    80001330:	00f60733          	add	a4,a2,a5
    80001334:	76fd                	lui	a3,0xfffff
    80001336:	8f75                	and	a4,a4,a3
  if(newup < PGROUNDUP(oldsz))
    80001338:	97ae                	add	a5,a5,a1
    8000133a:	8ff5                	and	a5,a5,a3
    8000133c:	00f76863          	bltu	a4,a5,8000134c <uvmdealloc+0x32>
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    8000134c:	4685                	li	a3,1
    8000134e:	40e58633          	sub	a2,a1,a4
    80001352:	85ba                	mv	a1,a4
    80001354:	00000097          	auipc	ra,0x0
    80001358:	e4e080e7          	jalr	-434(ra) # 800011a2 <uvmunmap>
    8000135c:	b7d5                	j	80001340 <uvmdealloc+0x26>

000000008000135e <uvmalloc>:
  if(newsz < oldsz)
    8000135e:	0ab66163          	bltu	a2,a1,80001400 <uvmalloc+0xa2>
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	f426                	sd	s1,40(sp)
    8000136a:	f04a                	sd	s2,32(sp)
    8000136c:	ec4e                	sd	s3,24(sp)
    8000136e:	e852                	sd	s4,16(sp)
    80001370:	e456                	sd	s5,8(sp)
    80001372:	0080                	addi	s0,sp,64
    80001374:	8aaa                	mv	s5,a0
    80001376:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001378:	6985                	lui	s3,0x1
    8000137a:	19fd                	addi	s3,s3,-1
    8000137c:	95ce                	add	a1,a1,s3
    8000137e:	79fd                	lui	s3,0xfffff
    80001380:	0135f9b3          	and	s3,a1,s3
  for(; a < newsz; a += PGSIZE){
    80001384:	08c9f063          	bgeu	s3,a2,80001404 <uvmalloc+0xa6>
  a = oldsz;
    80001388:	894e                	mv	s2,s3
    mem = kalloc();
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	5d6080e7          	jalr	1494(ra) # 80000960 <kalloc>
    80001392:	84aa                	mv	s1,a0
    if(mem == 0){
    80001394:	c51d                	beqz	a0,800013c2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001396:	6605                	lui	a2,0x1
    80001398:	4581                	li	a1,0
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	7d4080e7          	jalr	2004(ra) # 80000b6e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800013a2:	4779                	li	a4,30
    800013a4:	86a6                	mv	a3,s1
    800013a6:	6605                	lui	a2,0x1
    800013a8:	85ca                	mv	a1,s2
    800013aa:	8556                	mv	a0,s5
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	c5e080e7          	jalr	-930(ra) # 8000100a <mappages>
    800013b4:	e905                	bnez	a0,800013e4 <uvmalloc+0x86>
  for(; a < newsz; a += PGSIZE){
    800013b6:	6785                	lui	a5,0x1
    800013b8:	993e                	add	s2,s2,a5
    800013ba:	fd4968e3          	bltu	s2,s4,8000138a <uvmalloc+0x2c>
  return newsz;
    800013be:	8552                	mv	a0,s4
    800013c0:	a809                	j	800013d2 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800013c2:	864e                	mv	a2,s3
    800013c4:	85ca                	mv	a1,s2
    800013c6:	8556                	mv	a0,s5
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	f52080e7          	jalr	-174(ra) # 8000131a <uvmdealloc>
      return 0;
    800013d0:	4501                	li	a0,0
}
    800013d2:	70e2                	ld	ra,56(sp)
    800013d4:	7442                	ld	s0,48(sp)
    800013d6:	74a2                	ld	s1,40(sp)
    800013d8:	7902                	ld	s2,32(sp)
    800013da:	69e2                	ld	s3,24(sp)
    800013dc:	6a42                	ld	s4,16(sp)
    800013de:	6aa2                	ld	s5,8(sp)
    800013e0:	6121                	addi	sp,sp,64
    800013e2:	8082                	ret
      kfree(mem);
    800013e4:	8526                	mv	a0,s1
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	47e080e7          	jalr	1150(ra) # 80000864 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013ee:	864e                	mv	a2,s3
    800013f0:	85ca                	mv	a1,s2
    800013f2:	8556                	mv	a0,s5
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	f26080e7          	jalr	-218(ra) # 8000131a <uvmdealloc>
      return 0;
    800013fc:	4501                	li	a0,0
    800013fe:	bfd1                	j	800013d2 <uvmalloc+0x74>
    return oldsz;
    80001400:	852e                	mv	a0,a1
}
    80001402:	8082                	ret
  return newsz;
    80001404:	8532                	mv	a0,a2
    80001406:	b7f1                	j	800013d2 <uvmalloc+0x74>

0000000080001408 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001408:	1101                	addi	sp,sp,-32
    8000140a:	ec06                	sd	ra,24(sp)
    8000140c:	e822                	sd	s0,16(sp)
    8000140e:	e426                	sd	s1,8(sp)
    80001410:	1000                	addi	s0,sp,32
    80001412:	84aa                	mv	s1,a0
    80001414:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001416:	4685                	li	a3,1
    80001418:	4581                	li	a1,0
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	d88080e7          	jalr	-632(ra) # 800011a2 <uvmunmap>
  freewalk(pagetable);
    80001422:	8526                	mv	a0,s1
    80001424:	00000097          	auipc	ra,0x0
    80001428:	ab8080e7          	jalr	-1352(ra) # 80000edc <freewalk>
}
    8000142c:	60e2                	ld	ra,24(sp)
    8000142e:	6442                	ld	s0,16(sp)
    80001430:	64a2                	ld	s1,8(sp)
    80001432:	6105                	addi	sp,sp,32
    80001434:	8082                	ret

0000000080001436 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001436:	c671                	beqz	a2,80001502 <uvmcopy+0xcc>
{
    80001438:	715d                	addi	sp,sp,-80
    8000143a:	e486                	sd	ra,72(sp)
    8000143c:	e0a2                	sd	s0,64(sp)
    8000143e:	fc26                	sd	s1,56(sp)
    80001440:	f84a                	sd	s2,48(sp)
    80001442:	f44e                	sd	s3,40(sp)
    80001444:	f052                	sd	s4,32(sp)
    80001446:	ec56                	sd	s5,24(sp)
    80001448:	e85a                	sd	s6,16(sp)
    8000144a:	e45e                	sd	s7,8(sp)
    8000144c:	0880                	addi	s0,sp,80
    8000144e:	8b2a                	mv	s6,a0
    80001450:	8aae                	mv	s5,a1
    80001452:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001454:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001456:	4601                	li	a2,0
    80001458:	85ce                	mv	a1,s3
    8000145a:	855a                	mv	a0,s6
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	9da080e7          	jalr	-1574(ra) # 80000e36 <walk>
    80001464:	c531                	beqz	a0,800014b0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001466:	6118                	ld	a4,0(a0)
    80001468:	00177793          	andi	a5,a4,1
    8000146c:	cbb1                	beqz	a5,800014c0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000146e:	00a75593          	srli	a1,a4,0xa
    80001472:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001476:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000147a:	fffff097          	auipc	ra,0xfffff
    8000147e:	4e6080e7          	jalr	1254(ra) # 80000960 <kalloc>
    80001482:	892a                	mv	s2,a0
    80001484:	c939                	beqz	a0,800014da <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001486:	6605                	lui	a2,0x1
    80001488:	85de                	mv	a1,s7
    8000148a:	fffff097          	auipc	ra,0xfffff
    8000148e:	744080e7          	jalr	1860(ra) # 80000bce <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001492:	8726                	mv	a4,s1
    80001494:	86ca                	mv	a3,s2
    80001496:	6605                	lui	a2,0x1
    80001498:	85ce                	mv	a1,s3
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	b6e080e7          	jalr	-1170(ra) # 8000100a <mappages>
    800014a4:	e515                	bnez	a0,800014d0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800014a6:	6785                	lui	a5,0x1
    800014a8:	99be                	add	s3,s3,a5
    800014aa:	fb49e6e3          	bltu	s3,s4,80001456 <uvmcopy+0x20>
    800014ae:	a83d                	j	800014ec <uvmcopy+0xb6>
      panic("uvmcopy: pte should exist");
    800014b0:	00005517          	auipc	a0,0x5
    800014b4:	dc850513          	addi	a0,a0,-568 # 80006278 <userret+0x1e8>
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	096080e7          	jalr	150(ra) # 8000054e <panic>
      panic("uvmcopy: page not present");
    800014c0:	00005517          	auipc	a0,0x5
    800014c4:	dd850513          	addi	a0,a0,-552 # 80006298 <userret+0x208>
    800014c8:	fffff097          	auipc	ra,0xfffff
    800014cc:	086080e7          	jalr	134(ra) # 8000054e <panic>
      kfree(mem);
    800014d0:	854a                	mv	a0,s2
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	392080e7          	jalr	914(ra) # 80000864 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i, 1);
    800014da:	4685                	li	a3,1
    800014dc:	864e                	mv	a2,s3
    800014de:	4581                	li	a1,0
    800014e0:	8556                	mv	a0,s5
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	cc0080e7          	jalr	-832(ra) # 800011a2 <uvmunmap>
  return -1;
    800014ea:	557d                	li	a0,-1
}
    800014ec:	60a6                	ld	ra,72(sp)
    800014ee:	6406                	ld	s0,64(sp)
    800014f0:	74e2                	ld	s1,56(sp)
    800014f2:	7942                	ld	s2,48(sp)
    800014f4:	79a2                	ld	s3,40(sp)
    800014f6:	7a02                	ld	s4,32(sp)
    800014f8:	6ae2                	ld	s5,24(sp)
    800014fa:	6b42                	ld	s6,16(sp)
    800014fc:	6ba2                	ld	s7,8(sp)
    800014fe:	6161                	addi	sp,sp,80
    80001500:	8082                	ret
  return 0;
    80001502:	4501                	li	a0,0
}
    80001504:	8082                	ret

0000000080001506 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001506:	1141                	addi	sp,sp,-16
    80001508:	e406                	sd	ra,8(sp)
    8000150a:	e022                	sd	s0,0(sp)
    8000150c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000150e:	4601                	li	a2,0
    80001510:	00000097          	auipc	ra,0x0
    80001514:	926080e7          	jalr	-1754(ra) # 80000e36 <walk>
  if(pte == 0)
    80001518:	c901                	beqz	a0,80001528 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000151a:	611c                	ld	a5,0(a0)
    8000151c:	9bbd                	andi	a5,a5,-17
    8000151e:	e11c                	sd	a5,0(a0)
}
    80001520:	60a2                	ld	ra,8(sp)
    80001522:	6402                	ld	s0,0(sp)
    80001524:	0141                	addi	sp,sp,16
    80001526:	8082                	ret
    panic("uvmclear");
    80001528:	00005517          	auipc	a0,0x5
    8000152c:	d9050513          	addi	a0,a0,-624 # 800062b8 <userret+0x228>
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	01e080e7          	jalr	30(ra) # 8000054e <panic>

0000000080001538 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001538:	c6bd                	beqz	a3,800015a6 <copyout+0x6e>
{
    8000153a:	715d                	addi	sp,sp,-80
    8000153c:	e486                	sd	ra,72(sp)
    8000153e:	e0a2                	sd	s0,64(sp)
    80001540:	fc26                	sd	s1,56(sp)
    80001542:	f84a                	sd	s2,48(sp)
    80001544:	f44e                	sd	s3,40(sp)
    80001546:	f052                	sd	s4,32(sp)
    80001548:	ec56                	sd	s5,24(sp)
    8000154a:	e85a                	sd	s6,16(sp)
    8000154c:	e45e                	sd	s7,8(sp)
    8000154e:	e062                	sd	s8,0(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
    80001554:	8c2e                	mv	s8,a1
    80001556:	8a32                	mv	s4,a2
    80001558:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000155a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000155c:	6a85                	lui	s5,0x1
    8000155e:	a015                	j	80001582 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001560:	9562                	add	a0,a0,s8
    80001562:	0004861b          	sext.w	a2,s1
    80001566:	85d2                	mv	a1,s4
    80001568:	41250533          	sub	a0,a0,s2
    8000156c:	fffff097          	auipc	ra,0xfffff
    80001570:	662080e7          	jalr	1634(ra) # 80000bce <memmove>

    len -= n;
    80001574:	409989b3          	sub	s3,s3,s1
    src += n;
    80001578:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000157a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000157e:	02098263          	beqz	s3,800015a2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001582:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001586:	85ca                	mv	a1,s2
    80001588:	855a                	mv	a0,s6
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	9e0080e7          	jalr	-1568(ra) # 80000f6a <walkaddr>
    if(pa0 == 0)
    80001592:	cd01                	beqz	a0,800015aa <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001594:	418904b3          	sub	s1,s2,s8
    80001598:	94d6                	add	s1,s1,s5
    if(n > len)
    8000159a:	fc99f3e3          	bgeu	s3,s1,80001560 <copyout+0x28>
    8000159e:	84ce                	mv	s1,s3
    800015a0:	b7c1                	j	80001560 <copyout+0x28>
  }
  return 0;
    800015a2:	4501                	li	a0,0
    800015a4:	a021                	j	800015ac <copyout+0x74>
    800015a6:	4501                	li	a0,0
}
    800015a8:	8082                	ret
      return -1;
    800015aa:	557d                	li	a0,-1
}
    800015ac:	60a6                	ld	ra,72(sp)
    800015ae:	6406                	ld	s0,64(sp)
    800015b0:	74e2                	ld	s1,56(sp)
    800015b2:	7942                	ld	s2,48(sp)
    800015b4:	79a2                	ld	s3,40(sp)
    800015b6:	7a02                	ld	s4,32(sp)
    800015b8:	6ae2                	ld	s5,24(sp)
    800015ba:	6b42                	ld	s6,16(sp)
    800015bc:	6ba2                	ld	s7,8(sp)
    800015be:	6c02                	ld	s8,0(sp)
    800015c0:	6161                	addi	sp,sp,80
    800015c2:	8082                	ret

00000000800015c4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800015c4:	c6bd                	beqz	a3,80001632 <copyin+0x6e>
{
    800015c6:	715d                	addi	sp,sp,-80
    800015c8:	e486                	sd	ra,72(sp)
    800015ca:	e0a2                	sd	s0,64(sp)
    800015cc:	fc26                	sd	s1,56(sp)
    800015ce:	f84a                	sd	s2,48(sp)
    800015d0:	f44e                	sd	s3,40(sp)
    800015d2:	f052                	sd	s4,32(sp)
    800015d4:	ec56                	sd	s5,24(sp)
    800015d6:	e85a                	sd	s6,16(sp)
    800015d8:	e45e                	sd	s7,8(sp)
    800015da:	e062                	sd	s8,0(sp)
    800015dc:	0880                	addi	s0,sp,80
    800015de:	8b2a                	mv	s6,a0
    800015e0:	8a2e                	mv	s4,a1
    800015e2:	8c32                	mv	s8,a2
    800015e4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800015e6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800015e8:	6a85                	lui	s5,0x1
    800015ea:	a015                	j	8000160e <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800015ec:	9562                	add	a0,a0,s8
    800015ee:	0004861b          	sext.w	a2,s1
    800015f2:	412505b3          	sub	a1,a0,s2
    800015f6:	8552                	mv	a0,s4
    800015f8:	fffff097          	auipc	ra,0xfffff
    800015fc:	5d6080e7          	jalr	1494(ra) # 80000bce <memmove>

    len -= n;
    80001600:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001604:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001606:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000160a:	02098263          	beqz	s3,8000162e <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    8000160e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001612:	85ca                	mv	a1,s2
    80001614:	855a                	mv	a0,s6
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	954080e7          	jalr	-1708(ra) # 80000f6a <walkaddr>
    if(pa0 == 0)
    8000161e:	cd01                	beqz	a0,80001636 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001620:	418904b3          	sub	s1,s2,s8
    80001624:	94d6                	add	s1,s1,s5
    if(n > len)
    80001626:	fc99f3e3          	bgeu	s3,s1,800015ec <copyin+0x28>
    8000162a:	84ce                	mv	s1,s3
    8000162c:	b7c1                	j	800015ec <copyin+0x28>
  }
  return 0;
    8000162e:	4501                	li	a0,0
    80001630:	a021                	j	80001638 <copyin+0x74>
    80001632:	4501                	li	a0,0
}
    80001634:	8082                	ret
      return -1;
    80001636:	557d                	li	a0,-1
}
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret

0000000080001650 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001650:	c6c5                	beqz	a3,800016f8 <copyinstr+0xa8>
{
    80001652:	715d                	addi	sp,sp,-80
    80001654:	e486                	sd	ra,72(sp)
    80001656:	e0a2                	sd	s0,64(sp)
    80001658:	fc26                	sd	s1,56(sp)
    8000165a:	f84a                	sd	s2,48(sp)
    8000165c:	f44e                	sd	s3,40(sp)
    8000165e:	f052                	sd	s4,32(sp)
    80001660:	ec56                	sd	s5,24(sp)
    80001662:	e85a                	sd	s6,16(sp)
    80001664:	e45e                	sd	s7,8(sp)
    80001666:	0880                	addi	s0,sp,80
    80001668:	8a2a                	mv	s4,a0
    8000166a:	8b2e                	mv	s6,a1
    8000166c:	8bb2                	mv	s7,a2
    8000166e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001670:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001672:	6985                	lui	s3,0x1
    80001674:	a035                	j	800016a0 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001676:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000167a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000167c:	0017b793          	seqz	a5,a5
    80001680:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001684:	60a6                	ld	ra,72(sp)
    80001686:	6406                	ld	s0,64(sp)
    80001688:	74e2                	ld	s1,56(sp)
    8000168a:	7942                	ld	s2,48(sp)
    8000168c:	79a2                	ld	s3,40(sp)
    8000168e:	7a02                	ld	s4,32(sp)
    80001690:	6ae2                	ld	s5,24(sp)
    80001692:	6b42                	ld	s6,16(sp)
    80001694:	6ba2                	ld	s7,8(sp)
    80001696:	6161                	addi	sp,sp,80
    80001698:	8082                	ret
    srcva = va0 + PGSIZE;
    8000169a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    8000169e:	c8a9                	beqz	s1,800016f0 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800016a0:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800016a4:	85ca                	mv	a1,s2
    800016a6:	8552                	mv	a0,s4
    800016a8:	00000097          	auipc	ra,0x0
    800016ac:	8c2080e7          	jalr	-1854(ra) # 80000f6a <walkaddr>
    if(pa0 == 0)
    800016b0:	c131                	beqz	a0,800016f4 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800016b2:	41790833          	sub	a6,s2,s7
    800016b6:	984e                	add	a6,a6,s3
    if(n > max)
    800016b8:	0104f363          	bgeu	s1,a6,800016be <copyinstr+0x6e>
    800016bc:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800016be:	955e                	add	a0,a0,s7
    800016c0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800016c4:	fc080be3          	beqz	a6,8000169a <copyinstr+0x4a>
    800016c8:	985a                	add	a6,a6,s6
    800016ca:	87da                	mv	a5,s6
      if(*p == '\0'){
    800016cc:	41650633          	sub	a2,a0,s6
    800016d0:	14fd                	addi	s1,s1,-1
    800016d2:	9b26                	add	s6,s6,s1
    800016d4:	00f60733          	add	a4,a2,a5
    800016d8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9fe4>
    800016dc:	df49                	beqz	a4,80001676 <copyinstr+0x26>
        *dst = *p;
    800016de:	00e78023          	sb	a4,0(a5)
      --max;
    800016e2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800016e6:	0785                	addi	a5,a5,1
    while(n > 0){
    800016e8:	ff0796e3          	bne	a5,a6,800016d4 <copyinstr+0x84>
      dst++;
    800016ec:	8b42                	mv	s6,a6
    800016ee:	b775                	j	8000169a <copyinstr+0x4a>
    800016f0:	4781                	li	a5,0
    800016f2:	b769                	j	8000167c <copyinstr+0x2c>
      return -1;
    800016f4:	557d                	li	a0,-1
    800016f6:	b779                	j	80001684 <copyinstr+0x34>
  int got_null = 0;
    800016f8:	4781                	li	a5,0
  if(got_null){
    800016fa:	0017b793          	seqz	a5,a5
    800016fe:	40f00533          	neg	a0,a5
}
    80001702:	8082                	ret

0000000080001704 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001704:	1101                	addi	sp,sp,-32
    80001706:	ec06                	sd	ra,24(sp)
    80001708:	e822                	sd	s0,16(sp)
    8000170a:	e426                	sd	s1,8(sp)
    8000170c:	1000                	addi	s0,sp,32
    8000170e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	382080e7          	jalr	898(ra) # 80000a92 <holding>
    80001718:	c909                	beqz	a0,8000172a <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    8000171a:	749c                	ld	a5,40(s1)
    8000171c:	00978f63          	beq	a5,s1,8000173a <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001720:	60e2                	ld	ra,24(sp)
    80001722:	6442                	ld	s0,16(sp)
    80001724:	64a2                	ld	s1,8(sp)
    80001726:	6105                	addi	sp,sp,32
    80001728:	8082                	ret
    panic("wakeup1");
    8000172a:	00005517          	auipc	a0,0x5
    8000172e:	b9e50513          	addi	a0,a0,-1122 # 800062c8 <userret+0x238>
    80001732:	fffff097          	auipc	ra,0xfffff
    80001736:	e1c080e7          	jalr	-484(ra) # 8000054e <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000173a:	4c98                	lw	a4,24(s1)
    8000173c:	4785                	li	a5,1
    8000173e:	fef711e3          	bne	a4,a5,80001720 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001742:	4789                	li	a5,2
    80001744:	cc9c                	sw	a5,24(s1)
}
    80001746:	bfe9                	j	80001720 <wakeup1+0x1c>

0000000080001748 <procinit>:
{
    80001748:	715d                	addi	sp,sp,-80
    8000174a:	e486                	sd	ra,72(sp)
    8000174c:	e0a2                	sd	s0,64(sp)
    8000174e:	fc26                	sd	s1,56(sp)
    80001750:	f84a                	sd	s2,48(sp)
    80001752:	f44e                	sd	s3,40(sp)
    80001754:	f052                	sd	s4,32(sp)
    80001756:	ec56                	sd	s5,24(sp)
    80001758:	e85a                	sd	s6,16(sp)
    8000175a:	e45e                	sd	s7,8(sp)
    8000175c:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    8000175e:	00005597          	auipc	a1,0x5
    80001762:	b7258593          	addi	a1,a1,-1166 # 800062d0 <userret+0x240>
    80001766:	0000f517          	auipc	a0,0xf
    8000176a:	18250513          	addi	a0,a0,386 # 800108e8 <pid_lock>
    8000176e:	fffff097          	auipc	ra,0xfffff
    80001772:	252080e7          	jalr	594(ra) # 800009c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001776:	0000f917          	auipc	s2,0xf
    8000177a:	58a90913          	addi	s2,s2,1418 # 80010d00 <proc>
      initlock(&p->lock, "proc");
    8000177e:	00005b97          	auipc	s7,0x5
    80001782:	b5ab8b93          	addi	s7,s7,-1190 # 800062d8 <userret+0x248>
      uint64 va = KSTACK((int) (p - proc));
    80001786:	8b4a                	mv	s6,s2
    80001788:	00005a97          	auipc	s5,0x5
    8000178c:	198a8a93          	addi	s5,s5,408 # 80006920 <syscalls+0xb8>
    80001790:	040009b7          	lui	s3,0x4000
    80001794:	19fd                	addi	s3,s3,-1
    80001796:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001798:	00015a17          	auipc	s4,0x15
    8000179c:	f68a0a13          	addi	s4,s4,-152 # 80016700 <tickslock>
      initlock(&p->lock, "proc");
    800017a0:	85de                	mv	a1,s7
    800017a2:	854a                	mv	a0,s2
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	21c080e7          	jalr	540(ra) # 800009c0 <initlock>
      char *pa = kalloc();
    800017ac:	fffff097          	auipc	ra,0xfffff
    800017b0:	1b4080e7          	jalr	436(ra) # 80000960 <kalloc>
    800017b4:	85aa                	mv	a1,a0
      if(pa == 0)
    800017b6:	c929                	beqz	a0,80001808 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800017b8:	416904b3          	sub	s1,s2,s6
    800017bc:	848d                	srai	s1,s1,0x3
    800017be:	000ab783          	ld	a5,0(s5)
    800017c2:	02f484b3          	mul	s1,s1,a5
    800017c6:	2485                	addiw	s1,s1,1
    800017c8:	00d4949b          	slliw	s1,s1,0xd
    800017cc:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017d0:	4699                	li	a3,6
    800017d2:	6605                	lui	a2,0x1
    800017d4:	8526                	mv	a0,s1
    800017d6:	00000097          	auipc	ra,0x0
    800017da:	8c2080e7          	jalr	-1854(ra) # 80001098 <kvmmap>
      p->kstack = va;
    800017de:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e2:	16890913          	addi	s2,s2,360
    800017e6:	fb491de3          	bne	s2,s4,800017a0 <procinit+0x58>
  kvminithart();
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	75c080e7          	jalr	1884(ra) # 80000f46 <kvminithart>
}
    800017f2:	60a6                	ld	ra,72(sp)
    800017f4:	6406                	ld	s0,64(sp)
    800017f6:	74e2                	ld	s1,56(sp)
    800017f8:	7942                	ld	s2,48(sp)
    800017fa:	79a2                	ld	s3,40(sp)
    800017fc:	7a02                	ld	s4,32(sp)
    800017fe:	6ae2                	ld	s5,24(sp)
    80001800:	6b42                	ld	s6,16(sp)
    80001802:	6ba2                	ld	s7,8(sp)
    80001804:	6161                	addi	sp,sp,80
    80001806:	8082                	ret
        panic("kalloc");
    80001808:	00005517          	auipc	a0,0x5
    8000180c:	ad850513          	addi	a0,a0,-1320 # 800062e0 <userret+0x250>
    80001810:	fffff097          	auipc	ra,0xfffff
    80001814:	d3e080e7          	jalr	-706(ra) # 8000054e <panic>

0000000080001818 <cpuid>:
{
    80001818:	1141                	addi	sp,sp,-16
    8000181a:	e422                	sd	s0,8(sp)
    8000181c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000181e:	8512                	mv	a0,tp
}
    80001820:	2501                	sext.w	a0,a0
    80001822:	6422                	ld	s0,8(sp)
    80001824:	0141                	addi	sp,sp,16
    80001826:	8082                	ret

0000000080001828 <mycpu>:
mycpu(void) {
    80001828:	1141                	addi	sp,sp,-16
    8000182a:	e422                	sd	s0,8(sp)
    8000182c:	0800                	addi	s0,sp,16
    8000182e:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001830:	2781                	sext.w	a5,a5
    80001832:	079e                	slli	a5,a5,0x7
}
    80001834:	0000f517          	auipc	a0,0xf
    80001838:	0cc50513          	addi	a0,a0,204 # 80010900 <cpus>
    8000183c:	953e                	add	a0,a0,a5
    8000183e:	6422                	ld	s0,8(sp)
    80001840:	0141                	addi	sp,sp,16
    80001842:	8082                	ret

0000000080001844 <myproc>:
myproc(void) {
    80001844:	1101                	addi	sp,sp,-32
    80001846:	ec06                	sd	ra,24(sp)
    80001848:	e822                	sd	s0,16(sp)
    8000184a:	e426                	sd	s1,8(sp)
    8000184c:	1000                	addi	s0,sp,32
  push_off();
    8000184e:	fffff097          	auipc	ra,0xfffff
    80001852:	188080e7          	jalr	392(ra) # 800009d6 <push_off>
    80001856:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001858:	2781                	sext.w	a5,a5
    8000185a:	079e                	slli	a5,a5,0x7
    8000185c:	0000f717          	auipc	a4,0xf
    80001860:	08c70713          	addi	a4,a4,140 # 800108e8 <pid_lock>
    80001864:	97ba                	add	a5,a5,a4
    80001866:	6f84                	ld	s1,24(a5)
  pop_off();
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	1ba080e7          	jalr	442(ra) # 80000a22 <pop_off>
}
    80001870:	8526                	mv	a0,s1
    80001872:	60e2                	ld	ra,24(sp)
    80001874:	6442                	ld	s0,16(sp)
    80001876:	64a2                	ld	s1,8(sp)
    80001878:	6105                	addi	sp,sp,32
    8000187a:	8082                	ret

000000008000187c <forkret>:
{
    8000187c:	1141                	addi	sp,sp,-16
    8000187e:	e406                	sd	ra,8(sp)
    80001880:	e022                	sd	s0,0(sp)
    80001882:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001884:	00000097          	auipc	ra,0x0
    80001888:	fc0080e7          	jalr	-64(ra) # 80001844 <myproc>
    8000188c:	fffff097          	auipc	ra,0xfffff
    80001890:	29a080e7          	jalr	666(ra) # 80000b26 <release>
  if (first) {
    80001894:	00005797          	auipc	a5,0x5
    80001898:	7a07a783          	lw	a5,1952(a5) # 80007034 <first.1653>
    8000189c:	eb89                	bnez	a5,800018ae <forkret+0x32>
  usertrapret();
    8000189e:	00001097          	auipc	ra,0x1
    800018a2:	bde080e7          	jalr	-1058(ra) # 8000247c <usertrapret>
}
    800018a6:	60a2                	ld	ra,8(sp)
    800018a8:	6402                	ld	s0,0(sp)
    800018aa:	0141                	addi	sp,sp,16
    800018ac:	8082                	ret
    first = 0;
    800018ae:	00005797          	auipc	a5,0x5
    800018b2:	7807a323          	sw	zero,1926(a5) # 80007034 <first.1653>
    fsinit(ROOTDEV);
    800018b6:	4505                	li	a0,1
    800018b8:	00002097          	auipc	ra,0x2
    800018bc:	8fc080e7          	jalr	-1796(ra) # 800031b4 <fsinit>
    800018c0:	bff9                	j	8000189e <forkret+0x22>

00000000800018c2 <allocpid>:
allocpid() {
    800018c2:	1101                	addi	sp,sp,-32
    800018c4:	ec06                	sd	ra,24(sp)
    800018c6:	e822                	sd	s0,16(sp)
    800018c8:	e426                	sd	s1,8(sp)
    800018ca:	e04a                	sd	s2,0(sp)
    800018cc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800018ce:	0000f917          	auipc	s2,0xf
    800018d2:	01a90913          	addi	s2,s2,26 # 800108e8 <pid_lock>
    800018d6:	854a                	mv	a0,s2
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	1fa080e7          	jalr	506(ra) # 80000ad2 <acquire>
  pid = nextpid;
    800018e0:	00005797          	auipc	a5,0x5
    800018e4:	75878793          	addi	a5,a5,1880 # 80007038 <nextpid>
    800018e8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800018ea:	0014871b          	addiw	a4,s1,1
    800018ee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	234080e7          	jalr	564(ra) # 80000b26 <release>
}
    800018fa:	8526                	mv	a0,s1
    800018fc:	60e2                	ld	ra,24(sp)
    800018fe:	6442                	ld	s0,16(sp)
    80001900:	64a2                	ld	s1,8(sp)
    80001902:	6902                	ld	s2,0(sp)
    80001904:	6105                	addi	sp,sp,32
    80001906:	8082                	ret

0000000080001908 <proc_pagetable>:
{
    80001908:	1101                	addi	sp,sp,-32
    8000190a:	ec06                	sd	ra,24(sp)
    8000190c:	e822                	sd	s0,16(sp)
    8000190e:	e426                	sd	s1,8(sp)
    80001910:	e04a                	sd	s2,0(sp)
    80001912:	1000                	addi	s0,sp,32
    80001914:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001916:	00000097          	auipc	ra,0x0
    8000191a:	954080e7          	jalr	-1708(ra) # 8000126a <uvmcreate>
    8000191e:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001920:	4729                	li	a4,10
    80001922:	00004697          	auipc	a3,0x4
    80001926:	6de68693          	addi	a3,a3,1758 # 80006000 <trampoline>
    8000192a:	6605                	lui	a2,0x1
    8000192c:	040005b7          	lui	a1,0x4000
    80001930:	15fd                	addi	a1,a1,-1
    80001932:	05b2                	slli	a1,a1,0xc
    80001934:	fffff097          	auipc	ra,0xfffff
    80001938:	6d6080e7          	jalr	1750(ra) # 8000100a <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    8000193c:	4719                	li	a4,6
    8000193e:	05893683          	ld	a3,88(s2)
    80001942:	6605                	lui	a2,0x1
    80001944:	020005b7          	lui	a1,0x2000
    80001948:	15fd                	addi	a1,a1,-1
    8000194a:	05b6                	slli	a1,a1,0xd
    8000194c:	8526                	mv	a0,s1
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	6bc080e7          	jalr	1724(ra) # 8000100a <mappages>
}
    80001956:	8526                	mv	a0,s1
    80001958:	60e2                	ld	ra,24(sp)
    8000195a:	6442                	ld	s0,16(sp)
    8000195c:	64a2                	ld	s1,8(sp)
    8000195e:	6902                	ld	s2,0(sp)
    80001960:	6105                	addi	sp,sp,32
    80001962:	8082                	ret

0000000080001964 <allocproc>:
{
    80001964:	1101                	addi	sp,sp,-32
    80001966:	ec06                	sd	ra,24(sp)
    80001968:	e822                	sd	s0,16(sp)
    8000196a:	e426                	sd	s1,8(sp)
    8000196c:	e04a                	sd	s2,0(sp)
    8000196e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001970:	0000f497          	auipc	s1,0xf
    80001974:	39048493          	addi	s1,s1,912 # 80010d00 <proc>
    80001978:	00015917          	auipc	s2,0x15
    8000197c:	d8890913          	addi	s2,s2,-632 # 80016700 <tickslock>
    acquire(&p->lock);
    80001980:	8526                	mv	a0,s1
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	150080e7          	jalr	336(ra) # 80000ad2 <acquire>
    if(p->state == UNUSED) {
    8000198a:	4c9c                	lw	a5,24(s1)
    8000198c:	cf81                	beqz	a5,800019a4 <allocproc+0x40>
      release(&p->lock);
    8000198e:	8526                	mv	a0,s1
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	196080e7          	jalr	406(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001998:	16848493          	addi	s1,s1,360
    8000199c:	ff2492e3          	bne	s1,s2,80001980 <allocproc+0x1c>
  return 0;
    800019a0:	4481                	li	s1,0
    800019a2:	a0a9                	j	800019ec <allocproc+0x88>
  p->pid = allocpid();
    800019a4:	00000097          	auipc	ra,0x0
    800019a8:	f1e080e7          	jalr	-226(ra) # 800018c2 <allocpid>
    800019ac:	dc88                	sw	a0,56(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	fb2080e7          	jalr	-78(ra) # 80000960 <kalloc>
    800019b6:	892a                	mv	s2,a0
    800019b8:	eca8                	sd	a0,88(s1)
    800019ba:	c121                	beqz	a0,800019fa <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    800019bc:	8526                	mv	a0,s1
    800019be:	00000097          	auipc	ra,0x0
    800019c2:	f4a080e7          	jalr	-182(ra) # 80001908 <proc_pagetable>
    800019c6:	e8a8                	sd	a0,80(s1)
  memset(&p->context, 0, sizeof p->context);
    800019c8:	07000613          	li	a2,112
    800019cc:	4581                	li	a1,0
    800019ce:	06048513          	addi	a0,s1,96
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	19c080e7          	jalr	412(ra) # 80000b6e <memset>
  p->context.ra = (uint64)forkret;
    800019da:	00000797          	auipc	a5,0x0
    800019de:	ea278793          	addi	a5,a5,-350 # 8000187c <forkret>
    800019e2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800019e4:	60bc                	ld	a5,64(s1)
    800019e6:	6705                	lui	a4,0x1
    800019e8:	97ba                	add	a5,a5,a4
    800019ea:	f4bc                	sd	a5,104(s1)
}
    800019ec:	8526                	mv	a0,s1
    800019ee:	60e2                	ld	ra,24(sp)
    800019f0:	6442                	ld	s0,16(sp)
    800019f2:	64a2                	ld	s1,8(sp)
    800019f4:	6902                	ld	s2,0(sp)
    800019f6:	6105                	addi	sp,sp,32
    800019f8:	8082                	ret
    release(&p->lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	fffff097          	auipc	ra,0xfffff
    80001a00:	12a080e7          	jalr	298(ra) # 80000b26 <release>
    return 0;
    80001a04:	84ca                	mv	s1,s2
    80001a06:	b7dd                	j	800019ec <allocproc+0x88>

0000000080001a08 <proc_freepagetable>:
{
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	e426                	sd	s1,8(sp)
    80001a10:	e04a                	sd	s2,0(sp)
    80001a12:	1000                	addi	s0,sp,32
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001a18:	4681                	li	a3,0
    80001a1a:	6605                	lui	a2,0x1
    80001a1c:	040005b7          	lui	a1,0x4000
    80001a20:	15fd                	addi	a1,a1,-1
    80001a22:	05b2                	slli	a1,a1,0xc
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	77e080e7          	jalr	1918(ra) # 800011a2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001a2c:	4681                	li	a3,0
    80001a2e:	6605                	lui	a2,0x1
    80001a30:	020005b7          	lui	a1,0x2000
    80001a34:	15fd                	addi	a1,a1,-1
    80001a36:	05b6                	slli	a1,a1,0xd
    80001a38:	8526                	mv	a0,s1
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	768080e7          	jalr	1896(ra) # 800011a2 <uvmunmap>
  if(sz > 0)
    80001a42:	00091863          	bnez	s2,80001a52 <proc_freepagetable+0x4a>
}
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6902                	ld	s2,0(sp)
    80001a4e:	6105                	addi	sp,sp,32
    80001a50:	8082                	ret
    uvmfree(pagetable, sz);
    80001a52:	85ca                	mv	a1,s2
    80001a54:	8526                	mv	a0,s1
    80001a56:	00000097          	auipc	ra,0x0
    80001a5a:	9b2080e7          	jalr	-1614(ra) # 80001408 <uvmfree>
}
    80001a5e:	b7e5                	j	80001a46 <proc_freepagetable+0x3e>

0000000080001a60 <freeproc>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	1000                	addi	s0,sp,32
    80001a6a:	84aa                	mv	s1,a0
  if(p->tf)
    80001a6c:	6d28                	ld	a0,88(a0)
    80001a6e:	c509                	beqz	a0,80001a78 <freeproc+0x18>
    kfree((void*)p->tf);
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	df4080e7          	jalr	-524(ra) # 80000864 <kfree>
  p->tf = 0;
    80001a78:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a7c:	68a8                	ld	a0,80(s1)
    80001a7e:	c511                	beqz	a0,80001a8a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001a80:	64ac                	ld	a1,72(s1)
    80001a82:	00000097          	auipc	ra,0x0
    80001a86:	f86080e7          	jalr	-122(ra) # 80001a08 <proc_freepagetable>
  p->pagetable = 0;
    80001a8a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a8e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a92:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001a96:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001a9a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001a9e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001aa2:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001aa6:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001aaa:	0004ac23          	sw	zero,24(s1)
}
    80001aae:	60e2                	ld	ra,24(sp)
    80001ab0:	6442                	ld	s0,16(sp)
    80001ab2:	64a2                	ld	s1,8(sp)
    80001ab4:	6105                	addi	sp,sp,32
    80001ab6:	8082                	ret

0000000080001ab8 <userinit>:
{
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ac2:	00000097          	auipc	ra,0x0
    80001ac6:	ea2080e7          	jalr	-350(ra) # 80001964 <allocproc>
    80001aca:	84aa                	mv	s1,a0
  initproc = p;
    80001acc:	00023797          	auipc	a5,0x23
    80001ad0:	54a7b223          	sd	a0,1348(a5) # 80025010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001ad4:	03300613          	li	a2,51
    80001ad8:	00005597          	auipc	a1,0x5
    80001adc:	52858593          	addi	a1,a1,1320 # 80007000 <initcode>
    80001ae0:	6928                	ld	a0,80(a0)
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	7c6080e7          	jalr	1990(ra) # 800012a8 <uvminit>
  p->sz = PGSIZE;
    80001aea:	6785                	lui	a5,0x1
    80001aec:	e4bc                	sd	a5,72(s1)
  p->tf->epc = 0;      // user program counter
    80001aee:	6cb8                	ld	a4,88(s1)
    80001af0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001af4:	6cb8                	ld	a4,88(s1)
    80001af6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001af8:	4641                	li	a2,16
    80001afa:	00004597          	auipc	a1,0x4
    80001afe:	7ee58593          	addi	a1,a1,2030 # 800062e8 <userret+0x258>
    80001b02:	15848513          	addi	a0,s1,344
    80001b06:	fffff097          	auipc	ra,0xfffff
    80001b0a:	1be080e7          	jalr	446(ra) # 80000cc4 <safestrcpy>
  p->cwd = namei("/");
    80001b0e:	00004517          	auipc	a0,0x4
    80001b12:	7ea50513          	addi	a0,a0,2026 # 800062f8 <userret+0x268>
    80001b16:	00002097          	auipc	ra,0x2
    80001b1a:	0a0080e7          	jalr	160(ra) # 80003bb6 <namei>
    80001b1e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001b22:	4789                	li	a5,2
    80001b24:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001b26:	8526                	mv	a0,s1
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	ffe080e7          	jalr	-2(ra) # 80000b26 <release>
}
    80001b30:	60e2                	ld	ra,24(sp)
    80001b32:	6442                	ld	s0,16(sp)
    80001b34:	64a2                	ld	s1,8(sp)
    80001b36:	6105                	addi	sp,sp,32
    80001b38:	8082                	ret

0000000080001b3a <growproc>:
{
    80001b3a:	1101                	addi	sp,sp,-32
    80001b3c:	ec06                	sd	ra,24(sp)
    80001b3e:	e822                	sd	s0,16(sp)
    80001b40:	e426                	sd	s1,8(sp)
    80001b42:	e04a                	sd	s2,0(sp)
    80001b44:	1000                	addi	s0,sp,32
    80001b46:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b48:	00000097          	auipc	ra,0x0
    80001b4c:	cfc080e7          	jalr	-772(ra) # 80001844 <myproc>
    80001b50:	892a                	mv	s2,a0
  sz = p->sz;
    80001b52:	652c                	ld	a1,72(a0)
    80001b54:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001b58:	00904f63          	bgtz	s1,80001b76 <growproc+0x3c>
  } else if(n < 0){
    80001b5c:	0204cc63          	bltz	s1,80001b94 <growproc+0x5a>
  p->sz = sz;
    80001b60:	1602                	slli	a2,a2,0x20
    80001b62:	9201                	srli	a2,a2,0x20
    80001b64:	04c93423          	sd	a2,72(s2)
  return 0;
    80001b68:	4501                	li	a0,0
}
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6902                	ld	s2,0(sp)
    80001b72:	6105                	addi	sp,sp,32
    80001b74:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001b76:	9e25                	addw	a2,a2,s1
    80001b78:	1602                	slli	a2,a2,0x20
    80001b7a:	9201                	srli	a2,a2,0x20
    80001b7c:	1582                	slli	a1,a1,0x20
    80001b7e:	9181                	srli	a1,a1,0x20
    80001b80:	6928                	ld	a0,80(a0)
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	7dc080e7          	jalr	2012(ra) # 8000135e <uvmalloc>
    80001b8a:	0005061b          	sext.w	a2,a0
    80001b8e:	fa69                	bnez	a2,80001b60 <growproc+0x26>
      return -1;
    80001b90:	557d                	li	a0,-1
    80001b92:	bfe1                	j	80001b6a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001b94:	9e25                	addw	a2,a2,s1
    80001b96:	1602                	slli	a2,a2,0x20
    80001b98:	9201                	srli	a2,a2,0x20
    80001b9a:	1582                	slli	a1,a1,0x20
    80001b9c:	9181                	srli	a1,a1,0x20
    80001b9e:	6928                	ld	a0,80(a0)
    80001ba0:	fffff097          	auipc	ra,0xfffff
    80001ba4:	77a080e7          	jalr	1914(ra) # 8000131a <uvmdealloc>
    80001ba8:	0005061b          	sext.w	a2,a0
    80001bac:	bf55                	j	80001b60 <growproc+0x26>

0000000080001bae <fork>:
{
    80001bae:	7179                	addi	sp,sp,-48
    80001bb0:	f406                	sd	ra,40(sp)
    80001bb2:	f022                	sd	s0,32(sp)
    80001bb4:	ec26                	sd	s1,24(sp)
    80001bb6:	e84a                	sd	s2,16(sp)
    80001bb8:	e44e                	sd	s3,8(sp)
    80001bba:	e052                	sd	s4,0(sp)
    80001bbc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001bbe:	00000097          	auipc	ra,0x0
    80001bc2:	c86080e7          	jalr	-890(ra) # 80001844 <myproc>
    80001bc6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	d9c080e7          	jalr	-612(ra) # 80001964 <allocproc>
    80001bd0:	c175                	beqz	a0,80001cb4 <fork+0x106>
    80001bd2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001bd4:	04893603          	ld	a2,72(s2)
    80001bd8:	692c                	ld	a1,80(a0)
    80001bda:	05093503          	ld	a0,80(s2)
    80001bde:	00000097          	auipc	ra,0x0
    80001be2:	858080e7          	jalr	-1960(ra) # 80001436 <uvmcopy>
    80001be6:	04054863          	bltz	a0,80001c36 <fork+0x88>
  np->sz = p->sz;
    80001bea:	04893783          	ld	a5,72(s2)
    80001bee:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001bf2:	0329b023          	sd	s2,32(s3)
  *(np->tf) = *(p->tf);
    80001bf6:	05893683          	ld	a3,88(s2)
    80001bfa:	87b6                	mv	a5,a3
    80001bfc:	0589b703          	ld	a4,88(s3)
    80001c00:	12068693          	addi	a3,a3,288
    80001c04:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001c08:	6788                	ld	a0,8(a5)
    80001c0a:	6b8c                	ld	a1,16(a5)
    80001c0c:	6f90                	ld	a2,24(a5)
    80001c0e:	01073023          	sd	a6,0(a4)
    80001c12:	e708                	sd	a0,8(a4)
    80001c14:	eb0c                	sd	a1,16(a4)
    80001c16:	ef10                	sd	a2,24(a4)
    80001c18:	02078793          	addi	a5,a5,32
    80001c1c:	02070713          	addi	a4,a4,32
    80001c20:	fed792e3          	bne	a5,a3,80001c04 <fork+0x56>
  np->tf->a0 = 0;
    80001c24:	0589b783          	ld	a5,88(s3)
    80001c28:	0607b823          	sd	zero,112(a5)
    80001c2c:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001c30:	15000a13          	li	s4,336
    80001c34:	a03d                	j	80001c62 <fork+0xb4>
    freeproc(np);
    80001c36:	854e                	mv	a0,s3
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	e28080e7          	jalr	-472(ra) # 80001a60 <freeproc>
    release(&np->lock);
    80001c40:	854e                	mv	a0,s3
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	ee4080e7          	jalr	-284(ra) # 80000b26 <release>
    return -1;
    80001c4a:	54fd                	li	s1,-1
    80001c4c:	a899                	j	80001ca2 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001c4e:	00002097          	auipc	ra,0x2
    80001c52:	5f4080e7          	jalr	1524(ra) # 80004242 <filedup>
    80001c56:	009987b3          	add	a5,s3,s1
    80001c5a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001c5c:	04a1                	addi	s1,s1,8
    80001c5e:	01448763          	beq	s1,s4,80001c6c <fork+0xbe>
    if(p->ofile[i])
    80001c62:	009907b3          	add	a5,s2,s1
    80001c66:	6388                	ld	a0,0(a5)
    80001c68:	f17d                	bnez	a0,80001c4e <fork+0xa0>
    80001c6a:	bfcd                	j	80001c5c <fork+0xae>
  np->cwd = idup(p->cwd);
    80001c6c:	15093503          	ld	a0,336(s2)
    80001c70:	00001097          	auipc	ra,0x1
    80001c74:	77e080e7          	jalr	1918(ra) # 800033ee <idup>
    80001c78:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001c7c:	4641                	li	a2,16
    80001c7e:	15890593          	addi	a1,s2,344
    80001c82:	15898513          	addi	a0,s3,344
    80001c86:	fffff097          	auipc	ra,0xfffff
    80001c8a:	03e080e7          	jalr	62(ra) # 80000cc4 <safestrcpy>
  pid = np->pid;
    80001c8e:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001c92:	4789                	li	a5,2
    80001c94:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001c98:	854e                	mv	a0,s3
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	e8c080e7          	jalr	-372(ra) # 80000b26 <release>
}
    80001ca2:	8526                	mv	a0,s1
    80001ca4:	70a2                	ld	ra,40(sp)
    80001ca6:	7402                	ld	s0,32(sp)
    80001ca8:	64e2                	ld	s1,24(sp)
    80001caa:	6942                	ld	s2,16(sp)
    80001cac:	69a2                	ld	s3,8(sp)
    80001cae:	6a02                	ld	s4,0(sp)
    80001cb0:	6145                	addi	sp,sp,48
    80001cb2:	8082                	ret
    return -1;
    80001cb4:	54fd                	li	s1,-1
    80001cb6:	b7f5                	j	80001ca2 <fork+0xf4>

0000000080001cb8 <reparent>:
{
    80001cb8:	7179                	addi	sp,sp,-48
    80001cba:	f406                	sd	ra,40(sp)
    80001cbc:	f022                	sd	s0,32(sp)
    80001cbe:	ec26                	sd	s1,24(sp)
    80001cc0:	e84a                	sd	s2,16(sp)
    80001cc2:	e44e                	sd	s3,8(sp)
    80001cc4:	e052                	sd	s4,0(sp)
    80001cc6:	1800                	addi	s0,sp,48
    80001cc8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cca:	0000f497          	auipc	s1,0xf
    80001cce:	03648493          	addi	s1,s1,54 # 80010d00 <proc>
      pp->parent = initproc;
    80001cd2:	00023a17          	auipc	s4,0x23
    80001cd6:	33ea0a13          	addi	s4,s4,830 # 80025010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cda:	00015997          	auipc	s3,0x15
    80001cde:	a2698993          	addi	s3,s3,-1498 # 80016700 <tickslock>
    80001ce2:	a029                	j	80001cec <reparent+0x34>
    80001ce4:	16848493          	addi	s1,s1,360
    80001ce8:	03348363          	beq	s1,s3,80001d0e <reparent+0x56>
    if(pp->parent == p){
    80001cec:	709c                	ld	a5,32(s1)
    80001cee:	ff279be3          	bne	a5,s2,80001ce4 <reparent+0x2c>
      acquire(&pp->lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	dde080e7          	jalr	-546(ra) # 80000ad2 <acquire>
      pp->parent = initproc;
    80001cfc:	000a3783          	ld	a5,0(s4)
    80001d00:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001d02:	8526                	mv	a0,s1
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	e22080e7          	jalr	-478(ra) # 80000b26 <release>
    80001d0c:	bfe1                	j	80001ce4 <reparent+0x2c>
}
    80001d0e:	70a2                	ld	ra,40(sp)
    80001d10:	7402                	ld	s0,32(sp)
    80001d12:	64e2                	ld	s1,24(sp)
    80001d14:	6942                	ld	s2,16(sp)
    80001d16:	69a2                	ld	s3,8(sp)
    80001d18:	6a02                	ld	s4,0(sp)
    80001d1a:	6145                	addi	sp,sp,48
    80001d1c:	8082                	ret

0000000080001d1e <scheduler>:
{
    80001d1e:	7139                	addi	sp,sp,-64
    80001d20:	fc06                	sd	ra,56(sp)
    80001d22:	f822                	sd	s0,48(sp)
    80001d24:	f426                	sd	s1,40(sp)
    80001d26:	f04a                	sd	s2,32(sp)
    80001d28:	ec4e                	sd	s3,24(sp)
    80001d2a:	e852                	sd	s4,16(sp)
    80001d2c:	e456                	sd	s5,8(sp)
    80001d2e:	e05a                	sd	s6,0(sp)
    80001d30:	0080                	addi	s0,sp,64
    80001d32:	8792                	mv	a5,tp
  int id = r_tp();
    80001d34:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d36:	00779a93          	slli	s5,a5,0x7
    80001d3a:	0000f717          	auipc	a4,0xf
    80001d3e:	bae70713          	addi	a4,a4,-1106 # 800108e8 <pid_lock>
    80001d42:	9756                	add	a4,a4,s5
    80001d44:	00073c23          	sd	zero,24(a4)
        swtch(&c->scheduler, &p->context);
    80001d48:	0000f717          	auipc	a4,0xf
    80001d4c:	bc070713          	addi	a4,a4,-1088 # 80010908 <cpus+0x8>
    80001d50:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001d52:	4989                	li	s3,2
        p->state = RUNNING;
    80001d54:	4b0d                	li	s6,3
        c->proc = p;
    80001d56:	079e                	slli	a5,a5,0x7
    80001d58:	0000fa17          	auipc	s4,0xf
    80001d5c:	b90a0a13          	addi	s4,s4,-1136 # 800108e8 <pid_lock>
    80001d60:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001d62:	00015917          	auipc	s2,0x15
    80001d66:	99e90913          	addi	s2,s2,-1634 # 80016700 <tickslock>
  asm volatile("csrr %0, sie" : "=r" (x) );
    80001d6a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80001d6e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80001d72:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d76:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d7a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7e:	10079073          	csrw	sstatus,a5
    80001d82:	0000f497          	auipc	s1,0xf
    80001d86:	f7e48493          	addi	s1,s1,-130 # 80010d00 <proc>
    80001d8a:	a03d                	j	80001db8 <scheduler+0x9a>
        p->state = RUNNING;
    80001d8c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001d90:	009a3c23          	sd	s1,24(s4)
        swtch(&c->scheduler, &p->context);
    80001d94:	06048593          	addi	a1,s1,96
    80001d98:	8556                	mv	a0,s5
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	638080e7          	jalr	1592(ra) # 800023d2 <swtch>
        c->proc = 0;
    80001da2:	000a3c23          	sd	zero,24(s4)
      release(&p->lock);
    80001da6:	8526                	mv	a0,s1
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	d7e080e7          	jalr	-642(ra) # 80000b26 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001db0:	16848493          	addi	s1,s1,360
    80001db4:	fb248be3          	beq	s1,s2,80001d6a <scheduler+0x4c>
      acquire(&p->lock);
    80001db8:	8526                	mv	a0,s1
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	d18080e7          	jalr	-744(ra) # 80000ad2 <acquire>
      if(p->state == RUNNABLE) {
    80001dc2:	4c9c                	lw	a5,24(s1)
    80001dc4:	ff3791e3          	bne	a5,s3,80001da6 <scheduler+0x88>
    80001dc8:	b7d1                	j	80001d8c <scheduler+0x6e>

0000000080001dca <sched>:
{
    80001dca:	7179                	addi	sp,sp,-48
    80001dcc:	f406                	sd	ra,40(sp)
    80001dce:	f022                	sd	s0,32(sp)
    80001dd0:	ec26                	sd	s1,24(sp)
    80001dd2:	e84a                	sd	s2,16(sp)
    80001dd4:	e44e                	sd	s3,8(sp)
    80001dd6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	a6c080e7          	jalr	-1428(ra) # 80001844 <myproc>
    80001de0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001de2:	fffff097          	auipc	ra,0xfffff
    80001de6:	cb0080e7          	jalr	-848(ra) # 80000a92 <holding>
    80001dea:	c93d                	beqz	a0,80001e60 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001dec:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001dee:	2781                	sext.w	a5,a5
    80001df0:	079e                	slli	a5,a5,0x7
    80001df2:	0000f717          	auipc	a4,0xf
    80001df6:	af670713          	addi	a4,a4,-1290 # 800108e8 <pid_lock>
    80001dfa:	97ba                	add	a5,a5,a4
    80001dfc:	0907a703          	lw	a4,144(a5)
    80001e00:	4785                	li	a5,1
    80001e02:	06f71763          	bne	a4,a5,80001e70 <sched+0xa6>
  if(p->state == RUNNING)
    80001e06:	4c98                	lw	a4,24(s1)
    80001e08:	478d                	li	a5,3
    80001e0a:	06f70b63          	beq	a4,a5,80001e80 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e12:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001e14:	efb5                	bnez	a5,80001e90 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e16:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e18:	0000f917          	auipc	s2,0xf
    80001e1c:	ad090913          	addi	s2,s2,-1328 # 800108e8 <pid_lock>
    80001e20:	2781                	sext.w	a5,a5
    80001e22:	079e                	slli	a5,a5,0x7
    80001e24:	97ca                	add	a5,a5,s2
    80001e26:	0947a983          	lw	s3,148(a5)
    80001e2a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80001e2c:	2781                	sext.w	a5,a5
    80001e2e:	079e                	slli	a5,a5,0x7
    80001e30:	0000f597          	auipc	a1,0xf
    80001e34:	ad858593          	addi	a1,a1,-1320 # 80010908 <cpus+0x8>
    80001e38:	95be                	add	a1,a1,a5
    80001e3a:	06048513          	addi	a0,s1,96
    80001e3e:	00000097          	auipc	ra,0x0
    80001e42:	594080e7          	jalr	1428(ra) # 800023d2 <swtch>
    80001e46:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e48:	2781                	sext.w	a5,a5
    80001e4a:	079e                	slli	a5,a5,0x7
    80001e4c:	97ca                	add	a5,a5,s2
    80001e4e:	0937aa23          	sw	s3,148(a5)
}
    80001e52:	70a2                	ld	ra,40(sp)
    80001e54:	7402                	ld	s0,32(sp)
    80001e56:	64e2                	ld	s1,24(sp)
    80001e58:	6942                	ld	s2,16(sp)
    80001e5a:	69a2                	ld	s3,8(sp)
    80001e5c:	6145                	addi	sp,sp,48
    80001e5e:	8082                	ret
    panic("sched p->lock");
    80001e60:	00004517          	auipc	a0,0x4
    80001e64:	4a050513          	addi	a0,a0,1184 # 80006300 <userret+0x270>
    80001e68:	ffffe097          	auipc	ra,0xffffe
    80001e6c:	6e6080e7          	jalr	1766(ra) # 8000054e <panic>
    panic("sched locks");
    80001e70:	00004517          	auipc	a0,0x4
    80001e74:	4a050513          	addi	a0,a0,1184 # 80006310 <userret+0x280>
    80001e78:	ffffe097          	auipc	ra,0xffffe
    80001e7c:	6d6080e7          	jalr	1750(ra) # 8000054e <panic>
    panic("sched running");
    80001e80:	00004517          	auipc	a0,0x4
    80001e84:	4a050513          	addi	a0,a0,1184 # 80006320 <userret+0x290>
    80001e88:	ffffe097          	auipc	ra,0xffffe
    80001e8c:	6c6080e7          	jalr	1734(ra) # 8000054e <panic>
    panic("sched interruptible");
    80001e90:	00004517          	auipc	a0,0x4
    80001e94:	4a050513          	addi	a0,a0,1184 # 80006330 <userret+0x2a0>
    80001e98:	ffffe097          	auipc	ra,0xffffe
    80001e9c:	6b6080e7          	jalr	1718(ra) # 8000054e <panic>

0000000080001ea0 <exit>:
{
    80001ea0:	7179                	addi	sp,sp,-48
    80001ea2:	f406                	sd	ra,40(sp)
    80001ea4:	f022                	sd	s0,32(sp)
    80001ea6:	ec26                	sd	s1,24(sp)
    80001ea8:	e84a                	sd	s2,16(sp)
    80001eaa:	e44e                	sd	s3,8(sp)
    80001eac:	e052                	sd	s4,0(sp)
    80001eae:	1800                	addi	s0,sp,48
    80001eb0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	992080e7          	jalr	-1646(ra) # 80001844 <myproc>
    80001eba:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ebc:	00023797          	auipc	a5,0x23
    80001ec0:	1547b783          	ld	a5,340(a5) # 80025010 <initproc>
    80001ec4:	0d050493          	addi	s1,a0,208
    80001ec8:	15050913          	addi	s2,a0,336
    80001ecc:	02a79363          	bne	a5,a0,80001ef2 <exit+0x52>
    panic("init exiting");
    80001ed0:	00004517          	auipc	a0,0x4
    80001ed4:	47850513          	addi	a0,a0,1144 # 80006348 <userret+0x2b8>
    80001ed8:	ffffe097          	auipc	ra,0xffffe
    80001edc:	676080e7          	jalr	1654(ra) # 8000054e <panic>
      fileclose(f);
    80001ee0:	00002097          	auipc	ra,0x2
    80001ee4:	3b4080e7          	jalr	948(ra) # 80004294 <fileclose>
      p->ofile[fd] = 0;
    80001ee8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001eec:	04a1                	addi	s1,s1,8
    80001eee:	01248563          	beq	s1,s2,80001ef8 <exit+0x58>
    if(p->ofile[fd]){
    80001ef2:	6088                	ld	a0,0(s1)
    80001ef4:	f575                	bnez	a0,80001ee0 <exit+0x40>
    80001ef6:	bfdd                	j	80001eec <exit+0x4c>
  begin_op();
    80001ef8:	00002097          	auipc	ra,0x2
    80001efc:	eca080e7          	jalr	-310(ra) # 80003dc2 <begin_op>
  iput(p->cwd);
    80001f00:	1509b503          	ld	a0,336(s3)
    80001f04:	00001097          	auipc	ra,0x1
    80001f08:	636080e7          	jalr	1590(ra) # 8000353a <iput>
  end_op();
    80001f0c:	00002097          	auipc	ra,0x2
    80001f10:	f36080e7          	jalr	-202(ra) # 80003e42 <end_op>
  p->cwd = 0;
    80001f14:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    80001f18:	00023497          	auipc	s1,0x23
    80001f1c:	0f848493          	addi	s1,s1,248 # 80025010 <initproc>
    80001f20:	6088                	ld	a0,0(s1)
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	bb0080e7          	jalr	-1104(ra) # 80000ad2 <acquire>
  wakeup1(initproc);
    80001f2a:	6088                	ld	a0,0(s1)
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	7d8080e7          	jalr	2008(ra) # 80001704 <wakeup1>
  release(&initproc->lock);
    80001f34:	6088                	ld	a0,0(s1)
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	bf0080e7          	jalr	-1040(ra) # 80000b26 <release>
  acquire(&p->lock);
    80001f3e:	854e                	mv	a0,s3
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	b92080e7          	jalr	-1134(ra) # 80000ad2 <acquire>
  struct proc *original_parent = p->parent;
    80001f48:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80001f4c:	854e                	mv	a0,s3
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	bd8080e7          	jalr	-1064(ra) # 80000b26 <release>
  acquire(&original_parent->lock);
    80001f56:	8526                	mv	a0,s1
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	b7a080e7          	jalr	-1158(ra) # 80000ad2 <acquire>
  acquire(&p->lock);
    80001f60:	854e                	mv	a0,s3
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	b70080e7          	jalr	-1168(ra) # 80000ad2 <acquire>
  reparent(p);
    80001f6a:	854e                	mv	a0,s3
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	d4c080e7          	jalr	-692(ra) # 80001cb8 <reparent>
  wakeup1(original_parent);
    80001f74:	8526                	mv	a0,s1
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	78e080e7          	jalr	1934(ra) # 80001704 <wakeup1>
  p->xstate = status;
    80001f7e:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001f82:	4791                	li	a5,4
    80001f84:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80001f88:	8526                	mv	a0,s1
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	b9c080e7          	jalr	-1124(ra) # 80000b26 <release>
  sched();
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	e38080e7          	jalr	-456(ra) # 80001dca <sched>
  panic("zombie exit");
    80001f9a:	00004517          	auipc	a0,0x4
    80001f9e:	3be50513          	addi	a0,a0,958 # 80006358 <userret+0x2c8>
    80001fa2:	ffffe097          	auipc	ra,0xffffe
    80001fa6:	5ac080e7          	jalr	1452(ra) # 8000054e <panic>

0000000080001faa <yield>:
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	890080e7          	jalr	-1904(ra) # 80001844 <myproc>
    80001fbc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	b14080e7          	jalr	-1260(ra) # 80000ad2 <acquire>
  p->state = RUNNABLE;
    80001fc6:	4789                	li	a5,2
    80001fc8:	cc9c                	sw	a5,24(s1)
  sched();
    80001fca:	00000097          	auipc	ra,0x0
    80001fce:	e00080e7          	jalr	-512(ra) # 80001dca <sched>
  release(&p->lock);
    80001fd2:	8526                	mv	a0,s1
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	b52080e7          	jalr	-1198(ra) # 80000b26 <release>
}
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6105                	addi	sp,sp,32
    80001fe4:	8082                	ret

0000000080001fe6 <sleep>:
{
    80001fe6:	7179                	addi	sp,sp,-48
    80001fe8:	f406                	sd	ra,40(sp)
    80001fea:	f022                	sd	s0,32(sp)
    80001fec:	ec26                	sd	s1,24(sp)
    80001fee:	e84a                	sd	s2,16(sp)
    80001ff0:	e44e                	sd	s3,8(sp)
    80001ff2:	1800                	addi	s0,sp,48
    80001ff4:	89aa                	mv	s3,a0
    80001ff6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	84c080e7          	jalr	-1972(ra) # 80001844 <myproc>
    80002000:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002002:	05250663          	beq	a0,s2,8000204e <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	acc080e7          	jalr	-1332(ra) # 80000ad2 <acquire>
    release(lk);
    8000200e:	854a                	mv	a0,s2
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	b16080e7          	jalr	-1258(ra) # 80000b26 <release>
  p->chan = chan;
    80002018:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000201c:	4785                	li	a5,1
    8000201e:	cc9c                	sw	a5,24(s1)
  sched();
    80002020:	00000097          	auipc	ra,0x0
    80002024:	daa080e7          	jalr	-598(ra) # 80001dca <sched>
  p->chan = 0;
    80002028:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000202c:	8526                	mv	a0,s1
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	af8080e7          	jalr	-1288(ra) # 80000b26 <release>
    acquire(lk);
    80002036:	854a                	mv	a0,s2
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	a9a080e7          	jalr	-1382(ra) # 80000ad2 <acquire>
}
    80002040:	70a2                	ld	ra,40(sp)
    80002042:	7402                	ld	s0,32(sp)
    80002044:	64e2                	ld	s1,24(sp)
    80002046:	6942                	ld	s2,16(sp)
    80002048:	69a2                	ld	s3,8(sp)
    8000204a:	6145                	addi	sp,sp,48
    8000204c:	8082                	ret
  p->chan = chan;
    8000204e:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002052:	4785                	li	a5,1
    80002054:	cd1c                	sw	a5,24(a0)
  sched();
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	d74080e7          	jalr	-652(ra) # 80001dca <sched>
  p->chan = 0;
    8000205e:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002062:	bff9                	j	80002040 <sleep+0x5a>

0000000080002064 <wait>:
{
    80002064:	715d                	addi	sp,sp,-80
    80002066:	e486                	sd	ra,72(sp)
    80002068:	e0a2                	sd	s0,64(sp)
    8000206a:	fc26                	sd	s1,56(sp)
    8000206c:	f84a                	sd	s2,48(sp)
    8000206e:	f44e                	sd	s3,40(sp)
    80002070:	f052                	sd	s4,32(sp)
    80002072:	ec56                	sd	s5,24(sp)
    80002074:	e85a                	sd	s6,16(sp)
    80002076:	e45e                	sd	s7,8(sp)
    80002078:	e062                	sd	s8,0(sp)
    8000207a:	0880                	addi	s0,sp,80
    8000207c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	7c6080e7          	jalr	1990(ra) # 80001844 <myproc>
    80002086:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002088:	8c2a                	mv	s8,a0
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	a48080e7          	jalr	-1464(ra) # 80000ad2 <acquire>
    havekids = 0;
    80002092:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002094:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002096:	00014997          	auipc	s3,0x14
    8000209a:	66a98993          	addi	s3,s3,1642 # 80016700 <tickslock>
        havekids = 1;
    8000209e:	4a85                	li	s5,1
    havekids = 0;
    800020a0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800020a2:	0000f497          	auipc	s1,0xf
    800020a6:	c5e48493          	addi	s1,s1,-930 # 80010d00 <proc>
    800020aa:	a08d                	j	8000210c <wait+0xa8>
          pid = np->pid;
    800020ac:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800020b0:	000b0e63          	beqz	s6,800020cc <wait+0x68>
    800020b4:	4691                	li	a3,4
    800020b6:	03448613          	addi	a2,s1,52
    800020ba:	85da                	mv	a1,s6
    800020bc:	05093503          	ld	a0,80(s2)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	478080e7          	jalr	1144(ra) # 80001538 <copyout>
    800020c8:	02054263          	bltz	a0,800020ec <wait+0x88>
          freeproc(np);
    800020cc:	8526                	mv	a0,s1
    800020ce:	00000097          	auipc	ra,0x0
    800020d2:	992080e7          	jalr	-1646(ra) # 80001a60 <freeproc>
          release(&np->lock);
    800020d6:	8526                	mv	a0,s1
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	a4e080e7          	jalr	-1458(ra) # 80000b26 <release>
          release(&p->lock);
    800020e0:	854a                	mv	a0,s2
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	a44080e7          	jalr	-1468(ra) # 80000b26 <release>
          return pid;
    800020ea:	a8a9                	j	80002144 <wait+0xe0>
            release(&np->lock);
    800020ec:	8526                	mv	a0,s1
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	a38080e7          	jalr	-1480(ra) # 80000b26 <release>
            release(&p->lock);
    800020f6:	854a                	mv	a0,s2
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	a2e080e7          	jalr	-1490(ra) # 80000b26 <release>
            return -1;
    80002100:	59fd                	li	s3,-1
    80002102:	a089                	j	80002144 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002104:	16848493          	addi	s1,s1,360
    80002108:	03348463          	beq	s1,s3,80002130 <wait+0xcc>
      if(np->parent == p){
    8000210c:	709c                	ld	a5,32(s1)
    8000210e:	ff279be3          	bne	a5,s2,80002104 <wait+0xa0>
        acquire(&np->lock);
    80002112:	8526                	mv	a0,s1
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	9be080e7          	jalr	-1602(ra) # 80000ad2 <acquire>
        if(np->state == ZOMBIE){
    8000211c:	4c9c                	lw	a5,24(s1)
    8000211e:	f94787e3          	beq	a5,s4,800020ac <wait+0x48>
        release(&np->lock);
    80002122:	8526                	mv	a0,s1
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	a02080e7          	jalr	-1534(ra) # 80000b26 <release>
        havekids = 1;
    8000212c:	8756                	mv	a4,s5
    8000212e:	bfd9                	j	80002104 <wait+0xa0>
    if(!havekids || p->killed){
    80002130:	c701                	beqz	a4,80002138 <wait+0xd4>
    80002132:	03092783          	lw	a5,48(s2)
    80002136:	c785                	beqz	a5,8000215e <wait+0xfa>
      release(&p->lock);
    80002138:	854a                	mv	a0,s2
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	9ec080e7          	jalr	-1556(ra) # 80000b26 <release>
      return -1;
    80002142:	59fd                	li	s3,-1
}
    80002144:	854e                	mv	a0,s3
    80002146:	60a6                	ld	ra,72(sp)
    80002148:	6406                	ld	s0,64(sp)
    8000214a:	74e2                	ld	s1,56(sp)
    8000214c:	7942                	ld	s2,48(sp)
    8000214e:	79a2                	ld	s3,40(sp)
    80002150:	7a02                	ld	s4,32(sp)
    80002152:	6ae2                	ld	s5,24(sp)
    80002154:	6b42                	ld	s6,16(sp)
    80002156:	6ba2                	ld	s7,8(sp)
    80002158:	6c02                	ld	s8,0(sp)
    8000215a:	6161                	addi	sp,sp,80
    8000215c:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000215e:	85e2                	mv	a1,s8
    80002160:	854a                	mv	a0,s2
    80002162:	00000097          	auipc	ra,0x0
    80002166:	e84080e7          	jalr	-380(ra) # 80001fe6 <sleep>
    havekids = 0;
    8000216a:	bf1d                	j	800020a0 <wait+0x3c>

000000008000216c <wakeup>:
{
    8000216c:	7139                	addi	sp,sp,-64
    8000216e:	fc06                	sd	ra,56(sp)
    80002170:	f822                	sd	s0,48(sp)
    80002172:	f426                	sd	s1,40(sp)
    80002174:	f04a                	sd	s2,32(sp)
    80002176:	ec4e                	sd	s3,24(sp)
    80002178:	e852                	sd	s4,16(sp)
    8000217a:	e456                	sd	s5,8(sp)
    8000217c:	0080                	addi	s0,sp,64
    8000217e:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002180:	0000f497          	auipc	s1,0xf
    80002184:	b8048493          	addi	s1,s1,-1152 # 80010d00 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002188:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000218a:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000218c:	00014917          	auipc	s2,0x14
    80002190:	57490913          	addi	s2,s2,1396 # 80016700 <tickslock>
    80002194:	a821                	j	800021ac <wakeup+0x40>
      p->state = RUNNABLE;
    80002196:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    8000219a:	8526                	mv	a0,s1
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	98a080e7          	jalr	-1654(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021a4:	16848493          	addi	s1,s1,360
    800021a8:	01248e63          	beq	s1,s2,800021c4 <wakeup+0x58>
    acquire(&p->lock);
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	924080e7          	jalr	-1756(ra) # 80000ad2 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800021b6:	4c9c                	lw	a5,24(s1)
    800021b8:	ff3791e3          	bne	a5,s3,8000219a <wakeup+0x2e>
    800021bc:	749c                	ld	a5,40(s1)
    800021be:	fd479ee3          	bne	a5,s4,8000219a <wakeup+0x2e>
    800021c2:	bfd1                	j	80002196 <wakeup+0x2a>
}
    800021c4:	70e2                	ld	ra,56(sp)
    800021c6:	7442                	ld	s0,48(sp)
    800021c8:	74a2                	ld	s1,40(sp)
    800021ca:	7902                	ld	s2,32(sp)
    800021cc:	69e2                	ld	s3,24(sp)
    800021ce:	6a42                	ld	s4,16(sp)
    800021d0:	6aa2                	ld	s5,8(sp)
    800021d2:	6121                	addi	sp,sp,64
    800021d4:	8082                	ret

00000000800021d6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	e44e                	sd	s3,8(sp)
    800021e2:	1800                	addi	s0,sp,48
    800021e4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800021e6:	0000f497          	auipc	s1,0xf
    800021ea:	b1a48493          	addi	s1,s1,-1254 # 80010d00 <proc>
    800021ee:	00014997          	auipc	s3,0x14
    800021f2:	51298993          	addi	s3,s3,1298 # 80016700 <tickslock>
    acquire(&p->lock);
    800021f6:	8526                	mv	a0,s1
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	8da080e7          	jalr	-1830(ra) # 80000ad2 <acquire>
    if(p->pid == pid){
    80002200:	5c9c                	lw	a5,56(s1)
    80002202:	01278d63          	beq	a5,s2,8000221c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002206:	8526                	mv	a0,s1
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	91e080e7          	jalr	-1762(ra) # 80000b26 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002210:	16848493          	addi	s1,s1,360
    80002214:	ff3491e3          	bne	s1,s3,800021f6 <kill+0x20>
  }
  return -1;
    80002218:	557d                	li	a0,-1
    8000221a:	a829                	j	80002234 <kill+0x5e>
      p->killed = 1;
    8000221c:	4785                	li	a5,1
    8000221e:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002220:	4c98                	lw	a4,24(s1)
    80002222:	4785                	li	a5,1
    80002224:	00f70f63          	beq	a4,a5,80002242 <kill+0x6c>
      release(&p->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	8fc080e7          	jalr	-1796(ra) # 80000b26 <release>
      return 0;
    80002232:	4501                	li	a0,0
}
    80002234:	70a2                	ld	ra,40(sp)
    80002236:	7402                	ld	s0,32(sp)
    80002238:	64e2                	ld	s1,24(sp)
    8000223a:	6942                	ld	s2,16(sp)
    8000223c:	69a2                	ld	s3,8(sp)
    8000223e:	6145                	addi	sp,sp,48
    80002240:	8082                	ret
        p->state = RUNNABLE;
    80002242:	4789                	li	a5,2
    80002244:	cc9c                	sw	a5,24(s1)
    80002246:	b7cd                	j	80002228 <kill+0x52>

0000000080002248 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	e052                	sd	s4,0(sp)
    80002256:	1800                	addi	s0,sp,48
    80002258:	84aa                	mv	s1,a0
    8000225a:	892e                	mv	s2,a1
    8000225c:	89b2                	mv	s3,a2
    8000225e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	5e4080e7          	jalr	1508(ra) # 80001844 <myproc>
  if(user_dst){
    80002268:	c08d                	beqz	s1,8000228a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000226a:	86d2                	mv	a3,s4
    8000226c:	864e                	mv	a2,s3
    8000226e:	85ca                	mv	a1,s2
    80002270:	6928                	ld	a0,80(a0)
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	2c6080e7          	jalr	710(ra) # 80001538 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000227a:	70a2                	ld	ra,40(sp)
    8000227c:	7402                	ld	s0,32(sp)
    8000227e:	64e2                	ld	s1,24(sp)
    80002280:	6942                	ld	s2,16(sp)
    80002282:	69a2                	ld	s3,8(sp)
    80002284:	6a02                	ld	s4,0(sp)
    80002286:	6145                	addi	sp,sp,48
    80002288:	8082                	ret
    memmove((char *)dst, src, len);
    8000228a:	000a061b          	sext.w	a2,s4
    8000228e:	85ce                	mv	a1,s3
    80002290:	854a                	mv	a0,s2
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	93c080e7          	jalr	-1732(ra) # 80000bce <memmove>
    return 0;
    8000229a:	8526                	mv	a0,s1
    8000229c:	bff9                	j	8000227a <either_copyout+0x32>

000000008000229e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000229e:	7179                	addi	sp,sp,-48
    800022a0:	f406                	sd	ra,40(sp)
    800022a2:	f022                	sd	s0,32(sp)
    800022a4:	ec26                	sd	s1,24(sp)
    800022a6:	e84a                	sd	s2,16(sp)
    800022a8:	e44e                	sd	s3,8(sp)
    800022aa:	e052                	sd	s4,0(sp)
    800022ac:	1800                	addi	s0,sp,48
    800022ae:	892a                	mv	s2,a0
    800022b0:	84ae                	mv	s1,a1
    800022b2:	89b2                	mv	s3,a2
    800022b4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	58e080e7          	jalr	1422(ra) # 80001844 <myproc>
  if(user_src){
    800022be:	c08d                	beqz	s1,800022e0 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800022c0:	86d2                	mv	a3,s4
    800022c2:	864e                	mv	a2,s3
    800022c4:	85ca                	mv	a1,s2
    800022c6:	6928                	ld	a0,80(a0)
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	2fc080e7          	jalr	764(ra) # 800015c4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800022d0:	70a2                	ld	ra,40(sp)
    800022d2:	7402                	ld	s0,32(sp)
    800022d4:	64e2                	ld	s1,24(sp)
    800022d6:	6942                	ld	s2,16(sp)
    800022d8:	69a2                	ld	s3,8(sp)
    800022da:	6a02                	ld	s4,0(sp)
    800022dc:	6145                	addi	sp,sp,48
    800022de:	8082                	ret
    memmove(dst, (char*)src, len);
    800022e0:	000a061b          	sext.w	a2,s4
    800022e4:	85ce                	mv	a1,s3
    800022e6:	854a                	mv	a0,s2
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	8e6080e7          	jalr	-1818(ra) # 80000bce <memmove>
    return 0;
    800022f0:	8526                	mv	a0,s1
    800022f2:	bff9                	j	800022d0 <either_copyin+0x32>

00000000800022f4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022f4:	715d                	addi	sp,sp,-80
    800022f6:	e486                	sd	ra,72(sp)
    800022f8:	e0a2                	sd	s0,64(sp)
    800022fa:	fc26                	sd	s1,56(sp)
    800022fc:	f84a                	sd	s2,48(sp)
    800022fe:	f44e                	sd	s3,40(sp)
    80002300:	f052                	sd	s4,32(sp)
    80002302:	ec56                	sd	s5,24(sp)
    80002304:	e85a                	sd	s6,16(sp)
    80002306:	e45e                	sd	s7,8(sp)
    80002308:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000230a:	00004517          	auipc	a0,0x4
    8000230e:	ea650513          	addi	a0,a0,-346 # 800061b0 <userret+0x120>
    80002312:	ffffe097          	auipc	ra,0xffffe
    80002316:	286080e7          	jalr	646(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000231a:	0000f497          	auipc	s1,0xf
    8000231e:	b3e48493          	addi	s1,s1,-1218 # 80010e58 <proc+0x158>
    80002322:	00014917          	auipc	s2,0x14
    80002326:	53690913          	addi	s2,s2,1334 # 80016858 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000232a:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000232c:	00004997          	auipc	s3,0x4
    80002330:	03c98993          	addi	s3,s3,60 # 80006368 <userret+0x2d8>
    printf("%d %s %s", p->pid, state, p->name);
    80002334:	00004a97          	auipc	s5,0x4
    80002338:	03ca8a93          	addi	s5,s5,60 # 80006370 <userret+0x2e0>
    printf("\n");
    8000233c:	00004a17          	auipc	s4,0x4
    80002340:	e74a0a13          	addi	s4,s4,-396 # 800061b0 <userret+0x120>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002344:	00004b97          	auipc	s7,0x4
    80002348:	4e4b8b93          	addi	s7,s7,1252 # 80006828 <states.1693>
    8000234c:	a00d                	j	8000236e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000234e:	ee06a583          	lw	a1,-288(a3)
    80002352:	8556                	mv	a0,s5
    80002354:	ffffe097          	auipc	ra,0xffffe
    80002358:	244080e7          	jalr	580(ra) # 80000598 <printf>
    printf("\n");
    8000235c:	8552                	mv	a0,s4
    8000235e:	ffffe097          	auipc	ra,0xffffe
    80002362:	23a080e7          	jalr	570(ra) # 80000598 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002366:	16848493          	addi	s1,s1,360
    8000236a:	03248163          	beq	s1,s2,8000238c <procdump+0x98>
    if(p->state == UNUSED)
    8000236e:	86a6                	mv	a3,s1
    80002370:	ec04a783          	lw	a5,-320(s1)
    80002374:	dbed                	beqz	a5,80002366 <procdump+0x72>
      state = "???";
    80002376:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002378:	fcfb6be3          	bltu	s6,a5,8000234e <procdump+0x5a>
    8000237c:	1782                	slli	a5,a5,0x20
    8000237e:	9381                	srli	a5,a5,0x20
    80002380:	078e                	slli	a5,a5,0x3
    80002382:	97de                	add	a5,a5,s7
    80002384:	6390                	ld	a2,0(a5)
    80002386:	f661                	bnez	a2,8000234e <procdump+0x5a>
      state = "???";
    80002388:	864e                	mv	a2,s3
    8000238a:	b7d1                	j	8000234e <procdump+0x5a>
  }
}
    8000238c:	60a6                	ld	ra,72(sp)
    8000238e:	6406                	ld	s0,64(sp)
    80002390:	74e2                	ld	s1,56(sp)
    80002392:	7942                	ld	s2,48(sp)
    80002394:	79a2                	ld	s3,40(sp)
    80002396:	7a02                	ld	s4,32(sp)
    80002398:	6ae2                	ld	s5,24(sp)
    8000239a:	6b42                	ld	s6,16(sp)
    8000239c:	6ba2                	ld	s7,8(sp)
    8000239e:	6161                	addi	sp,sp,80
    800023a0:	8082                	ret

00000000800023a2 <sys_getprocs>:


uint64 sys_getprocs()
{
    800023a2:	1141                	addi	sp,sp,-16
    800023a4:	e422                	sd	s0,8(sp)
    800023a6:	0800                	addi	s0,sp,16
	struct proc* p;
	int i = 0;
    800023a8:	4501                	li	a0,0
	for(p=proc; p< &proc[NPROC];p++)
    800023aa:	0000f797          	auipc	a5,0xf
    800023ae:	95678793          	addi	a5,a5,-1706 # 80010d00 <proc>
    800023b2:	00014697          	auipc	a3,0x14
    800023b6:	34e68693          	addi	a3,a3,846 # 80016700 <tickslock>
    800023ba:	a029                	j	800023c4 <sys_getprocs+0x22>
    800023bc:	16878793          	addi	a5,a5,360
    800023c0:	00d78663          	beq	a5,a3,800023cc <sys_getprocs+0x2a>
	{
		if(p->state !=UNUSED)
    800023c4:	4f98                	lw	a4,24(a5)
    800023c6:	db7d                	beqz	a4,800023bc <sys_getprocs+0x1a>
		{
			i++;
    800023c8:	2505                	addiw	a0,a0,1
    800023ca:	bfcd                	j	800023bc <sys_getprocs+0x1a>
		}
	}
return i;
}
    800023cc:	6422                	ld	s0,8(sp)
    800023ce:	0141                	addi	sp,sp,16
    800023d0:	8082                	ret

00000000800023d2 <swtch>:
    800023d2:	00153023          	sd	ra,0(a0)
    800023d6:	00253423          	sd	sp,8(a0)
    800023da:	e900                	sd	s0,16(a0)
    800023dc:	ed04                	sd	s1,24(a0)
    800023de:	03253023          	sd	s2,32(a0)
    800023e2:	03353423          	sd	s3,40(a0)
    800023e6:	03453823          	sd	s4,48(a0)
    800023ea:	03553c23          	sd	s5,56(a0)
    800023ee:	05653023          	sd	s6,64(a0)
    800023f2:	05753423          	sd	s7,72(a0)
    800023f6:	05853823          	sd	s8,80(a0)
    800023fa:	05953c23          	sd	s9,88(a0)
    800023fe:	07a53023          	sd	s10,96(a0)
    80002402:	07b53423          	sd	s11,104(a0)
    80002406:	0005b083          	ld	ra,0(a1)
    8000240a:	0085b103          	ld	sp,8(a1)
    8000240e:	6980                	ld	s0,16(a1)
    80002410:	6d84                	ld	s1,24(a1)
    80002412:	0205b903          	ld	s2,32(a1)
    80002416:	0285b983          	ld	s3,40(a1)
    8000241a:	0305ba03          	ld	s4,48(a1)
    8000241e:	0385ba83          	ld	s5,56(a1)
    80002422:	0405bb03          	ld	s6,64(a1)
    80002426:	0485bb83          	ld	s7,72(a1)
    8000242a:	0505bc03          	ld	s8,80(a1)
    8000242e:	0585bc83          	ld	s9,88(a1)
    80002432:	0605bd03          	ld	s10,96(a1)
    80002436:	0685bd83          	ld	s11,104(a1)
    8000243a:	8082                	ret

000000008000243c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000243c:	1141                	addi	sp,sp,-16
    8000243e:	e406                	sd	ra,8(sp)
    80002440:	e022                	sd	s0,0(sp)
    80002442:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002444:	00004597          	auipc	a1,0x4
    80002448:	f6458593          	addi	a1,a1,-156 # 800063a8 <userret+0x318>
    8000244c:	00014517          	auipc	a0,0x14
    80002450:	2b450513          	addi	a0,a0,692 # 80016700 <tickslock>
    80002454:	ffffe097          	auipc	ra,0xffffe
    80002458:	56c080e7          	jalr	1388(ra) # 800009c0 <initlock>
}
    8000245c:	60a2                	ld	ra,8(sp)
    8000245e:	6402                	ld	s0,0(sp)
    80002460:	0141                	addi	sp,sp,16
    80002462:	8082                	ret

0000000080002464 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002464:	1141                	addi	sp,sp,-16
    80002466:	e422                	sd	s0,8(sp)
    80002468:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000246a:	00003797          	auipc	a5,0x3
    8000246e:	45678793          	addi	a5,a5,1110 # 800058c0 <kernelvec>
    80002472:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002476:	6422                	ld	s0,8(sp)
    80002478:	0141                	addi	sp,sp,16
    8000247a:	8082                	ret

000000008000247c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000247c:	1141                	addi	sp,sp,-16
    8000247e:	e406                	sd	ra,8(sp)
    80002480:	e022                	sd	s0,0(sp)
    80002482:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002484:	fffff097          	auipc	ra,0xfffff
    80002488:	3c0080e7          	jalr	960(ra) # 80001844 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000248c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002490:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002492:	10079073          	csrw	sstatus,a5
  // turn off interrupts, since we're switching
  // now from kerneltrap() to usertrap().
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002496:	00004617          	auipc	a2,0x4
    8000249a:	b6a60613          	addi	a2,a2,-1174 # 80006000 <trampoline>
    8000249e:	00004697          	auipc	a3,0x4
    800024a2:	b6268693          	addi	a3,a3,-1182 # 80006000 <trampoline>
    800024a6:	8e91                	sub	a3,a3,a2
    800024a8:	040007b7          	lui	a5,0x4000
    800024ac:	17fd                	addi	a5,a5,-1
    800024ae:	07b2                	slli	a5,a5,0xc
    800024b0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024b2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->tf->kernel_satp = r_satp();         // kernel page table
    800024b6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800024b8:	180026f3          	csrr	a3,satp
    800024bc:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024be:	6d38                	ld	a4,88(a0)
    800024c0:	6134                	ld	a3,64(a0)
    800024c2:	6585                	lui	a1,0x1
    800024c4:	96ae                	add	a3,a3,a1
    800024c6:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    800024c8:	6d38                	ld	a4,88(a0)
    800024ca:	00000697          	auipc	a3,0x0
    800024ce:	12268693          	addi	a3,a3,290 # 800025ec <usertrap>
    800024d2:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp();         // hartid for cpuid()
    800024d4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800024d6:	8692                	mv	a3,tp
    800024d8:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024da:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024de:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024e2:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800024e6:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->tf->epc);
    800024ea:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800024ec:	6f18                	ld	a4,24(a4)
    800024ee:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800024f2:	692c                	ld	a1,80(a0)
    800024f4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800024f6:	00004717          	auipc	a4,0x4
    800024fa:	b9a70713          	addi	a4,a4,-1126 # 80006090 <userret>
    800024fe:	8f11                	sub	a4,a4,a2
    80002500:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002502:	577d                	li	a4,-1
    80002504:	177e                	slli	a4,a4,0x3f
    80002506:	8dd9                	or	a1,a1,a4
    80002508:	02000537          	lui	a0,0x2000
    8000250c:	157d                	addi	a0,a0,-1
    8000250e:	0536                	slli	a0,a0,0xd
    80002510:	9782                	jalr	a5
}
    80002512:	60a2                	ld	ra,8(sp)
    80002514:	6402                	ld	s0,0(sp)
    80002516:	0141                	addi	sp,sp,16
    80002518:	8082                	ret

000000008000251a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	e426                	sd	s1,8(sp)
    80002522:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002524:	00014497          	auipc	s1,0x14
    80002528:	1dc48493          	addi	s1,s1,476 # 80016700 <tickslock>
    8000252c:	8526                	mv	a0,s1
    8000252e:	ffffe097          	auipc	ra,0xffffe
    80002532:	5a4080e7          	jalr	1444(ra) # 80000ad2 <acquire>
  ticks++;
    80002536:	00023517          	auipc	a0,0x23
    8000253a:	ae250513          	addi	a0,a0,-1310 # 80025018 <ticks>
    8000253e:	411c                	lw	a5,0(a0)
    80002540:	2785                	addiw	a5,a5,1
    80002542:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002544:	00000097          	auipc	ra,0x0
    80002548:	c28080e7          	jalr	-984(ra) # 8000216c <wakeup>
  release(&tickslock);
    8000254c:	8526                	mv	a0,s1
    8000254e:	ffffe097          	auipc	ra,0xffffe
    80002552:	5d8080e7          	jalr	1496(ra) # 80000b26 <release>
}
    80002556:	60e2                	ld	ra,24(sp)
    80002558:	6442                	ld	s0,16(sp)
    8000255a:	64a2                	ld	s1,8(sp)
    8000255c:	6105                	addi	sp,sp,32
    8000255e:	8082                	ret

0000000080002560 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002560:	1101                	addi	sp,sp,-32
    80002562:	ec06                	sd	ra,24(sp)
    80002564:	e822                	sd	s0,16(sp)
    80002566:	e426                	sd	s1,8(sp)
    80002568:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000256a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000256e:	00074d63          	bltz	a4,80002588 <devintr+0x28>
      virtio_disk_intr();
    }

    plic_complete(irq);
    return 1;
  } else if(scause == 0x8000000000000001L){
    80002572:	57fd                	li	a5,-1
    80002574:	17fe                	slli	a5,a5,0x3f
    80002576:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002578:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000257a:	04f70863          	beq	a4,a5,800025ca <devintr+0x6a>
  }
}
    8000257e:	60e2                	ld	ra,24(sp)
    80002580:	6442                	ld	s0,16(sp)
    80002582:	64a2                	ld	s1,8(sp)
    80002584:	6105                	addi	sp,sp,32
    80002586:	8082                	ret
     (scause & 0xff) == 9){
    80002588:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000258c:	46a5                	li	a3,9
    8000258e:	fed792e3          	bne	a5,a3,80002572 <devintr+0x12>
    int irq = plic_claim();
    80002592:	00003097          	auipc	ra,0x3
    80002596:	448080e7          	jalr	1096(ra) # 800059da <plic_claim>
    8000259a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000259c:	47a9                	li	a5,10
    8000259e:	00f50c63          	beq	a0,a5,800025b6 <devintr+0x56>
    } else if(irq == VIRTIO0_IRQ){
    800025a2:	4785                	li	a5,1
    800025a4:	00f50e63          	beq	a0,a5,800025c0 <devintr+0x60>
    plic_complete(irq);
    800025a8:	8526                	mv	a0,s1
    800025aa:	00003097          	auipc	ra,0x3
    800025ae:	454080e7          	jalr	1108(ra) # 800059fe <plic_complete>
    return 1;
    800025b2:	4505                	li	a0,1
    800025b4:	b7e9                	j	8000257e <devintr+0x1e>
      uartintr();
    800025b6:	ffffe097          	auipc	ra,0xffffe
    800025ba:	282080e7          	jalr	642(ra) # 80000838 <uartintr>
    800025be:	b7ed                	j	800025a8 <devintr+0x48>
      virtio_disk_intr();
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	8d8080e7          	jalr	-1832(ra) # 80005e98 <virtio_disk_intr>
    800025c8:	b7c5                	j	800025a8 <devintr+0x48>
    if(cpuid() == 0){
    800025ca:	fffff097          	auipc	ra,0xfffff
    800025ce:	24e080e7          	jalr	590(ra) # 80001818 <cpuid>
    800025d2:	c901                	beqz	a0,800025e2 <devintr+0x82>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800025d4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800025d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800025da:	14479073          	csrw	sip,a5
    return 2;
    800025de:	4509                	li	a0,2
    800025e0:	bf79                	j	8000257e <devintr+0x1e>
      clockintr();
    800025e2:	00000097          	auipc	ra,0x0
    800025e6:	f38080e7          	jalr	-200(ra) # 8000251a <clockintr>
    800025ea:	b7ed                	j	800025d4 <devintr+0x74>

00000000800025ec <usertrap>:
{
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	e04a                	sd	s2,0(sp)
    800025f6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025f8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800025fc:	1007f793          	andi	a5,a5,256
    80002600:	e7bd                	bnez	a5,8000266e <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002602:	00003797          	auipc	a5,0x3
    80002606:	2be78793          	addi	a5,a5,702 # 800058c0 <kernelvec>
    8000260a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000260e:	fffff097          	auipc	ra,0xfffff
    80002612:	236080e7          	jalr	566(ra) # 80001844 <myproc>
    80002616:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    80002618:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000261a:	14102773          	csrr	a4,sepc
    8000261e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002620:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002624:	47a1                	li	a5,8
    80002626:	06f71263          	bne	a4,a5,8000268a <usertrap+0x9e>
    if(p->killed)
    8000262a:	591c                	lw	a5,48(a0)
    8000262c:	eba9                	bnez	a5,8000267e <usertrap+0x92>
    p->tf->epc += 4;
    8000262e:	6cb8                	ld	a4,88(s1)
    80002630:	6f1c                	ld	a5,24(a4)
    80002632:	0791                	addi	a5,a5,4
    80002634:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sie" : "=r" (x) );
    80002636:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000263a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000263e:	10479073          	csrw	sie,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002642:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002646:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000264a:	10079073          	csrw	sstatus,a5
    syscall();
    8000264e:	00000097          	auipc	ra,0x0
    80002652:	2e0080e7          	jalr	736(ra) # 8000292e <syscall>
  if(p->killed)
    80002656:	589c                	lw	a5,48(s1)
    80002658:	ebc1                	bnez	a5,800026e8 <usertrap+0xfc>
  usertrapret();
    8000265a:	00000097          	auipc	ra,0x0
    8000265e:	e22080e7          	jalr	-478(ra) # 8000247c <usertrapret>
}
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6902                	ld	s2,0(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
    panic("usertrap: not from user mode");
    8000266e:	00004517          	auipc	a0,0x4
    80002672:	d4250513          	addi	a0,a0,-702 # 800063b0 <userret+0x320>
    80002676:	ffffe097          	auipc	ra,0xffffe
    8000267a:	ed8080e7          	jalr	-296(ra) # 8000054e <panic>
      exit(-1);
    8000267e:	557d                	li	a0,-1
    80002680:	00000097          	auipc	ra,0x0
    80002684:	820080e7          	jalr	-2016(ra) # 80001ea0 <exit>
    80002688:	b75d                	j	8000262e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	ed6080e7          	jalr	-298(ra) # 80002560 <devintr>
    80002692:	892a                	mv	s2,a0
    80002694:	c501                	beqz	a0,8000269c <usertrap+0xb0>
  if(p->killed)
    80002696:	589c                	lw	a5,48(s1)
    80002698:	c3a1                	beqz	a5,800026d8 <usertrap+0xec>
    8000269a:	a815                	j	800026ce <usertrap+0xe2>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000269c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800026a0:	5c90                	lw	a2,56(s1)
    800026a2:	00004517          	auipc	a0,0x4
    800026a6:	d2e50513          	addi	a0,a0,-722 # 800063d0 <userret+0x340>
    800026aa:	ffffe097          	auipc	ra,0xffffe
    800026ae:	eee080e7          	jalr	-274(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026b2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026b6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800026ba:	00004517          	auipc	a0,0x4
    800026be:	d4650513          	addi	a0,a0,-698 # 80006400 <userret+0x370>
    800026c2:	ffffe097          	auipc	ra,0xffffe
    800026c6:	ed6080e7          	jalr	-298(ra) # 80000598 <printf>
    p->killed = 1;
    800026ca:	4785                	li	a5,1
    800026cc:	d89c                	sw	a5,48(s1)
    exit(-1);
    800026ce:	557d                	li	a0,-1
    800026d0:	fffff097          	auipc	ra,0xfffff
    800026d4:	7d0080e7          	jalr	2000(ra) # 80001ea0 <exit>
  if(which_dev == 2)
    800026d8:	4789                	li	a5,2
    800026da:	f8f910e3          	bne	s2,a5,8000265a <usertrap+0x6e>
    yield();
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	8cc080e7          	jalr	-1844(ra) # 80001faa <yield>
    800026e6:	bf95                	j	8000265a <usertrap+0x6e>
  int which_dev = 0;
    800026e8:	4901                	li	s2,0
    800026ea:	b7d5                	j	800026ce <usertrap+0xe2>

00000000800026ec <kerneltrap>:
{
    800026ec:	7179                	addi	sp,sp,-48
    800026ee:	f406                	sd	ra,40(sp)
    800026f0:	f022                	sd	s0,32(sp)
    800026f2:	ec26                	sd	s1,24(sp)
    800026f4:	e84a                	sd	s2,16(sp)
    800026f6:	e44e                	sd	s3,8(sp)
    800026f8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800026fa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026fe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002702:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002706:	1004f793          	andi	a5,s1,256
    8000270a:	cb85                	beqz	a5,8000273a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000270c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002710:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002712:	ef85                	bnez	a5,8000274a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002714:	00000097          	auipc	ra,0x0
    80002718:	e4c080e7          	jalr	-436(ra) # 80002560 <devintr>
    8000271c:	cd1d                	beqz	a0,8000275a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000271e:	4789                	li	a5,2
    80002720:	06f50a63          	beq	a0,a5,80002794 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002724:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002728:	10049073          	csrw	sstatus,s1
}
    8000272c:	70a2                	ld	ra,40(sp)
    8000272e:	7402                	ld	s0,32(sp)
    80002730:	64e2                	ld	s1,24(sp)
    80002732:	6942                	ld	s2,16(sp)
    80002734:	69a2                	ld	s3,8(sp)
    80002736:	6145                	addi	sp,sp,48
    80002738:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000273a:	00004517          	auipc	a0,0x4
    8000273e:	ce650513          	addi	a0,a0,-794 # 80006420 <userret+0x390>
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	e0c080e7          	jalr	-500(ra) # 8000054e <panic>
    panic("kerneltrap: interrupts enabled");
    8000274a:	00004517          	auipc	a0,0x4
    8000274e:	cfe50513          	addi	a0,a0,-770 # 80006448 <userret+0x3b8>
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	dfc080e7          	jalr	-516(ra) # 8000054e <panic>
    printf("scause %p\n", scause);
    8000275a:	85ce                	mv	a1,s3
    8000275c:	00004517          	auipc	a0,0x4
    80002760:	d0c50513          	addi	a0,a0,-756 # 80006468 <userret+0x3d8>
    80002764:	ffffe097          	auipc	ra,0xffffe
    80002768:	e34080e7          	jalr	-460(ra) # 80000598 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000276c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002770:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002774:	00004517          	auipc	a0,0x4
    80002778:	d0450513          	addi	a0,a0,-764 # 80006478 <userret+0x3e8>
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	e1c080e7          	jalr	-484(ra) # 80000598 <printf>
    panic("kerneltrap");
    80002784:	00004517          	auipc	a0,0x4
    80002788:	d0c50513          	addi	a0,a0,-756 # 80006490 <userret+0x400>
    8000278c:	ffffe097          	auipc	ra,0xffffe
    80002790:	dc2080e7          	jalr	-574(ra) # 8000054e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002794:	fffff097          	auipc	ra,0xfffff
    80002798:	0b0080e7          	jalr	176(ra) # 80001844 <myproc>
    8000279c:	d541                	beqz	a0,80002724 <kerneltrap+0x38>
    8000279e:	fffff097          	auipc	ra,0xfffff
    800027a2:	0a6080e7          	jalr	166(ra) # 80001844 <myproc>
    800027a6:	4d18                	lw	a4,24(a0)
    800027a8:	478d                	li	a5,3
    800027aa:	f6f71de3          	bne	a4,a5,80002724 <kerneltrap+0x38>
    yield();
    800027ae:	fffff097          	auipc	ra,0xfffff
    800027b2:	7fc080e7          	jalr	2044(ra) # 80001faa <yield>
    800027b6:	b7bd                	j	80002724 <kerneltrap+0x38>

00000000800027b8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800027b8:	1101                	addi	sp,sp,-32
    800027ba:	ec06                	sd	ra,24(sp)
    800027bc:	e822                	sd	s0,16(sp)
    800027be:	e426                	sd	s1,8(sp)
    800027c0:	1000                	addi	s0,sp,32
    800027c2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027c4:	fffff097          	auipc	ra,0xfffff
    800027c8:	080080e7          	jalr	128(ra) # 80001844 <myproc>
  switch (n) {
    800027cc:	4795                	li	a5,5
    800027ce:	0497e163          	bltu	a5,s1,80002810 <argraw+0x58>
    800027d2:	048a                	slli	s1,s1,0x2
    800027d4:	00004717          	auipc	a4,0x4
    800027d8:	07c70713          	addi	a4,a4,124 # 80006850 <states.1693+0x28>
    800027dc:	94ba                	add	s1,s1,a4
    800027de:	409c                	lw	a5,0(s1)
    800027e0:	97ba                	add	a5,a5,a4
    800027e2:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    800027e4:	6d3c                	ld	a5,88(a0)
    800027e6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    800027e8:	60e2                	ld	ra,24(sp)
    800027ea:	6442                	ld	s0,16(sp)
    800027ec:	64a2                	ld	s1,8(sp)
    800027ee:	6105                	addi	sp,sp,32
    800027f0:	8082                	ret
    return p->tf->a1;
    800027f2:	6d3c                	ld	a5,88(a0)
    800027f4:	7fa8                	ld	a0,120(a5)
    800027f6:	bfcd                	j	800027e8 <argraw+0x30>
    return p->tf->a2;
    800027f8:	6d3c                	ld	a5,88(a0)
    800027fa:	63c8                	ld	a0,128(a5)
    800027fc:	b7f5                	j	800027e8 <argraw+0x30>
    return p->tf->a3;
    800027fe:	6d3c                	ld	a5,88(a0)
    80002800:	67c8                	ld	a0,136(a5)
    80002802:	b7dd                	j	800027e8 <argraw+0x30>
    return p->tf->a4;
    80002804:	6d3c                	ld	a5,88(a0)
    80002806:	6bc8                	ld	a0,144(a5)
    80002808:	b7c5                	j	800027e8 <argraw+0x30>
    return p->tf->a5;
    8000280a:	6d3c                	ld	a5,88(a0)
    8000280c:	6fc8                	ld	a0,152(a5)
    8000280e:	bfe9                	j	800027e8 <argraw+0x30>
  panic("argraw");
    80002810:	00004517          	auipc	a0,0x4
    80002814:	c9050513          	addi	a0,a0,-880 # 800064a0 <userret+0x410>
    80002818:	ffffe097          	auipc	ra,0xffffe
    8000281c:	d36080e7          	jalr	-714(ra) # 8000054e <panic>

0000000080002820 <fetchaddr>:
{
    80002820:	1101                	addi	sp,sp,-32
    80002822:	ec06                	sd	ra,24(sp)
    80002824:	e822                	sd	s0,16(sp)
    80002826:	e426                	sd	s1,8(sp)
    80002828:	e04a                	sd	s2,0(sp)
    8000282a:	1000                	addi	s0,sp,32
    8000282c:	84aa                	mv	s1,a0
    8000282e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002830:	fffff097          	auipc	ra,0xfffff
    80002834:	014080e7          	jalr	20(ra) # 80001844 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002838:	653c                	ld	a5,72(a0)
    8000283a:	02f4f863          	bgeu	s1,a5,8000286a <fetchaddr+0x4a>
    8000283e:	00848713          	addi	a4,s1,8
    80002842:	02e7e663          	bltu	a5,a4,8000286e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002846:	46a1                	li	a3,8
    80002848:	8626                	mv	a2,s1
    8000284a:	85ca                	mv	a1,s2
    8000284c:	6928                	ld	a0,80(a0)
    8000284e:	fffff097          	auipc	ra,0xfffff
    80002852:	d76080e7          	jalr	-650(ra) # 800015c4 <copyin>
    80002856:	00a03533          	snez	a0,a0
    8000285a:	40a00533          	neg	a0,a0
}
    8000285e:	60e2                	ld	ra,24(sp)
    80002860:	6442                	ld	s0,16(sp)
    80002862:	64a2                	ld	s1,8(sp)
    80002864:	6902                	ld	s2,0(sp)
    80002866:	6105                	addi	sp,sp,32
    80002868:	8082                	ret
    return -1;
    8000286a:	557d                	li	a0,-1
    8000286c:	bfcd                	j	8000285e <fetchaddr+0x3e>
    8000286e:	557d                	li	a0,-1
    80002870:	b7fd                	j	8000285e <fetchaddr+0x3e>

0000000080002872 <fetchstr>:
{
    80002872:	7179                	addi	sp,sp,-48
    80002874:	f406                	sd	ra,40(sp)
    80002876:	f022                	sd	s0,32(sp)
    80002878:	ec26                	sd	s1,24(sp)
    8000287a:	e84a                	sd	s2,16(sp)
    8000287c:	e44e                	sd	s3,8(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	892a                	mv	s2,a0
    80002882:	84ae                	mv	s1,a1
    80002884:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002886:	fffff097          	auipc	ra,0xfffff
    8000288a:	fbe080e7          	jalr	-66(ra) # 80001844 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000288e:	86ce                	mv	a3,s3
    80002890:	864a                	mv	a2,s2
    80002892:	85a6                	mv	a1,s1
    80002894:	6928                	ld	a0,80(a0)
    80002896:	fffff097          	auipc	ra,0xfffff
    8000289a:	dba080e7          	jalr	-582(ra) # 80001650 <copyinstr>
  if(err < 0)
    8000289e:	00054763          	bltz	a0,800028ac <fetchstr+0x3a>
  return strlen(buf);
    800028a2:	8526                	mv	a0,s1
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	452080e7          	jalr	1106(ra) # 80000cf6 <strlen>
}
    800028ac:	70a2                	ld	ra,40(sp)
    800028ae:	7402                	ld	s0,32(sp)
    800028b0:	64e2                	ld	s1,24(sp)
    800028b2:	6942                	ld	s2,16(sp)
    800028b4:	69a2                	ld	s3,8(sp)
    800028b6:	6145                	addi	sp,sp,48
    800028b8:	8082                	ret

00000000800028ba <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800028ba:	1101                	addi	sp,sp,-32
    800028bc:	ec06                	sd	ra,24(sp)
    800028be:	e822                	sd	s0,16(sp)
    800028c0:	e426                	sd	s1,8(sp)
    800028c2:	1000                	addi	s0,sp,32
    800028c4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	ef2080e7          	jalr	-270(ra) # 800027b8 <argraw>
    800028ce:	c088                	sw	a0,0(s1)
  return 0;
}
    800028d0:	4501                	li	a0,0
    800028d2:	60e2                	ld	ra,24(sp)
    800028d4:	6442                	ld	s0,16(sp)
    800028d6:	64a2                	ld	s1,8(sp)
    800028d8:	6105                	addi	sp,sp,32
    800028da:	8082                	ret

00000000800028dc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800028dc:	1101                	addi	sp,sp,-32
    800028de:	ec06                	sd	ra,24(sp)
    800028e0:	e822                	sd	s0,16(sp)
    800028e2:	e426                	sd	s1,8(sp)
    800028e4:	1000                	addi	s0,sp,32
    800028e6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	ed0080e7          	jalr	-304(ra) # 800027b8 <argraw>
    800028f0:	e088                	sd	a0,0(s1)
  return 0;
}
    800028f2:	4501                	li	a0,0
    800028f4:	60e2                	ld	ra,24(sp)
    800028f6:	6442                	ld	s0,16(sp)
    800028f8:	64a2                	ld	s1,8(sp)
    800028fa:	6105                	addi	sp,sp,32
    800028fc:	8082                	ret

00000000800028fe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028fe:	1101                	addi	sp,sp,-32
    80002900:	ec06                	sd	ra,24(sp)
    80002902:	e822                	sd	s0,16(sp)
    80002904:	e426                	sd	s1,8(sp)
    80002906:	e04a                	sd	s2,0(sp)
    80002908:	1000                	addi	s0,sp,32
    8000290a:	84ae                	mv	s1,a1
    8000290c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000290e:	00000097          	auipc	ra,0x0
    80002912:	eaa080e7          	jalr	-342(ra) # 800027b8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002916:	864a                	mv	a2,s2
    80002918:	85a6                	mv	a1,s1
    8000291a:	00000097          	auipc	ra,0x0
    8000291e:	f58080e7          	jalr	-168(ra) # 80002872 <fetchstr>
}
    80002922:	60e2                	ld	ra,24(sp)
    80002924:	6442                	ld	s0,16(sp)
    80002926:	64a2                	ld	s1,8(sp)
    80002928:	6902                	ld	s2,0(sp)
    8000292a:	6105                	addi	sp,sp,32
    8000292c:	8082                	ret

000000008000292e <syscall>:
[SYS_getprocs]	sys_getprocs
};

void
syscall(void)
{
    8000292e:	1101                	addi	sp,sp,-32
    80002930:	ec06                	sd	ra,24(sp)
    80002932:	e822                	sd	s0,16(sp)
    80002934:	e426                	sd	s1,8(sp)
    80002936:	e04a                	sd	s2,0(sp)
    80002938:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000293a:	fffff097          	auipc	ra,0xfffff
    8000293e:	f0a080e7          	jalr	-246(ra) # 80001844 <myproc>
    80002942:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002944:	05853903          	ld	s2,88(a0)
    80002948:	0a893783          	ld	a5,168(s2)
    8000294c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002950:	37fd                	addiw	a5,a5,-1
    80002952:	4755                	li	a4,21
    80002954:	00f76f63          	bltu	a4,a5,80002972 <syscall+0x44>
    80002958:	00369713          	slli	a4,a3,0x3
    8000295c:	00004797          	auipc	a5,0x4
    80002960:	f0c78793          	addi	a5,a5,-244 # 80006868 <syscalls>
    80002964:	97ba                	add	a5,a5,a4
    80002966:	639c                	ld	a5,0(a5)
    80002968:	c789                	beqz	a5,80002972 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    8000296a:	9782                	jalr	a5
    8000296c:	06a93823          	sd	a0,112(s2)
    80002970:	a839                	j	8000298e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002972:	15848613          	addi	a2,s1,344
    80002976:	5c8c                	lw	a1,56(s1)
    80002978:	00004517          	auipc	a0,0x4
    8000297c:	b3050513          	addi	a0,a0,-1232 # 800064a8 <userret+0x418>
    80002980:	ffffe097          	auipc	ra,0xffffe
    80002984:	c18080e7          	jalr	-1000(ra) # 80000598 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002988:	6cbc                	ld	a5,88(s1)
    8000298a:	577d                	li	a4,-1
    8000298c:	fbb8                	sd	a4,112(a5)
  }
}
    8000298e:	60e2                	ld	ra,24(sp)
    80002990:	6442                	ld	s0,16(sp)
    80002992:	64a2                	ld	s1,8(sp)
    80002994:	6902                	ld	s2,0(sp)
    80002996:	6105                	addi	sp,sp,32
    80002998:	8082                	ret

000000008000299a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000299a:	1101                	addi	sp,sp,-32
    8000299c:	ec06                	sd	ra,24(sp)
    8000299e:	e822                	sd	s0,16(sp)
    800029a0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800029a2:	fec40593          	addi	a1,s0,-20
    800029a6:	4501                	li	a0,0
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	f12080e7          	jalr	-238(ra) # 800028ba <argint>
    return -1;
    800029b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800029b2:	00054963          	bltz	a0,800029c4 <sys_exit+0x2a>
  exit(n);
    800029b6:	fec42503          	lw	a0,-20(s0)
    800029ba:	fffff097          	auipc	ra,0xfffff
    800029be:	4e6080e7          	jalr	1254(ra) # 80001ea0 <exit>
  return 0;  // not reached
    800029c2:	4781                	li	a5,0
}
    800029c4:	853e                	mv	a0,a5
    800029c6:	60e2                	ld	ra,24(sp)
    800029c8:	6442                	ld	s0,16(sp)
    800029ca:	6105                	addi	sp,sp,32
    800029cc:	8082                	ret

00000000800029ce <sys_getpid>:

uint64
sys_getpid(void)
{
    800029ce:	1141                	addi	sp,sp,-16
    800029d0:	e406                	sd	ra,8(sp)
    800029d2:	e022                	sd	s0,0(sp)
    800029d4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800029d6:	fffff097          	auipc	ra,0xfffff
    800029da:	e6e080e7          	jalr	-402(ra) # 80001844 <myproc>
}
    800029de:	5d08                	lw	a0,56(a0)
    800029e0:	60a2                	ld	ra,8(sp)
    800029e2:	6402                	ld	s0,0(sp)
    800029e4:	0141                	addi	sp,sp,16
    800029e6:	8082                	ret

00000000800029e8 <sys_fork>:

uint64
sys_fork(void)
{
    800029e8:	1141                	addi	sp,sp,-16
    800029ea:	e406                	sd	ra,8(sp)
    800029ec:	e022                	sd	s0,0(sp)
    800029ee:	0800                	addi	s0,sp,16
  return fork();
    800029f0:	fffff097          	auipc	ra,0xfffff
    800029f4:	1be080e7          	jalr	446(ra) # 80001bae <fork>
}
    800029f8:	60a2                	ld	ra,8(sp)
    800029fa:	6402                	ld	s0,0(sp)
    800029fc:	0141                	addi	sp,sp,16
    800029fe:	8082                	ret

0000000080002a00 <sys_wait>:

uint64
sys_wait(void)
{
    80002a00:	1101                	addi	sp,sp,-32
    80002a02:	ec06                	sd	ra,24(sp)
    80002a04:	e822                	sd	s0,16(sp)
    80002a06:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002a08:	fe840593          	addi	a1,s0,-24
    80002a0c:	4501                	li	a0,0
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	ece080e7          	jalr	-306(ra) # 800028dc <argaddr>
    80002a16:	87aa                	mv	a5,a0
    return -1;
    80002a18:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002a1a:	0007c863          	bltz	a5,80002a2a <sys_wait+0x2a>
  return wait(p);
    80002a1e:	fe843503          	ld	a0,-24(s0)
    80002a22:	fffff097          	auipc	ra,0xfffff
    80002a26:	642080e7          	jalr	1602(ra) # 80002064 <wait>
}
    80002a2a:	60e2                	ld	ra,24(sp)
    80002a2c:	6442                	ld	s0,16(sp)
    80002a2e:	6105                	addi	sp,sp,32
    80002a30:	8082                	ret

0000000080002a32 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002a32:	7179                	addi	sp,sp,-48
    80002a34:	f406                	sd	ra,40(sp)
    80002a36:	f022                	sd	s0,32(sp)
    80002a38:	ec26                	sd	s1,24(sp)
    80002a3a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002a3c:	fdc40593          	addi	a1,s0,-36
    80002a40:	4501                	li	a0,0
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	e78080e7          	jalr	-392(ra) # 800028ba <argint>
    80002a4a:	87aa                	mv	a5,a0
    return -1;
    80002a4c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002a4e:	0207c063          	bltz	a5,80002a6e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002a52:	fffff097          	auipc	ra,0xfffff
    80002a56:	df2080e7          	jalr	-526(ra) # 80001844 <myproc>
    80002a5a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002a5c:	fdc42503          	lw	a0,-36(s0)
    80002a60:	fffff097          	auipc	ra,0xfffff
    80002a64:	0da080e7          	jalr	218(ra) # 80001b3a <growproc>
    80002a68:	00054863          	bltz	a0,80002a78 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002a6c:	8526                	mv	a0,s1
}
    80002a6e:	70a2                	ld	ra,40(sp)
    80002a70:	7402                	ld	s0,32(sp)
    80002a72:	64e2                	ld	s1,24(sp)
    80002a74:	6145                	addi	sp,sp,48
    80002a76:	8082                	ret
    return -1;
    80002a78:	557d                	li	a0,-1
    80002a7a:	bfd5                	j	80002a6e <sys_sbrk+0x3c>

0000000080002a7c <sys_sleep>:

uint64
sys_sleep(void)
{
    80002a7c:	7139                	addi	sp,sp,-64
    80002a7e:	fc06                	sd	ra,56(sp)
    80002a80:	f822                	sd	s0,48(sp)
    80002a82:	f426                	sd	s1,40(sp)
    80002a84:	f04a                	sd	s2,32(sp)
    80002a86:	ec4e                	sd	s3,24(sp)
    80002a88:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002a8a:	fcc40593          	addi	a1,s0,-52
    80002a8e:	4501                	li	a0,0
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	e2a080e7          	jalr	-470(ra) # 800028ba <argint>
    return -1;
    80002a98:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002a9a:	06054563          	bltz	a0,80002b04 <sys_sleep+0x88>
  acquire(&tickslock);
    80002a9e:	00014517          	auipc	a0,0x14
    80002aa2:	c6250513          	addi	a0,a0,-926 # 80016700 <tickslock>
    80002aa6:	ffffe097          	auipc	ra,0xffffe
    80002aaa:	02c080e7          	jalr	44(ra) # 80000ad2 <acquire>
  ticks0 = ticks;
    80002aae:	00022917          	auipc	s2,0x22
    80002ab2:	56a92903          	lw	s2,1386(s2) # 80025018 <ticks>
  while(ticks - ticks0 < n){
    80002ab6:	fcc42783          	lw	a5,-52(s0)
    80002aba:	cf85                	beqz	a5,80002af2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002abc:	00014997          	auipc	s3,0x14
    80002ac0:	c4498993          	addi	s3,s3,-956 # 80016700 <tickslock>
    80002ac4:	00022497          	auipc	s1,0x22
    80002ac8:	55448493          	addi	s1,s1,1364 # 80025018 <ticks>
    if(myproc()->killed){
    80002acc:	fffff097          	auipc	ra,0xfffff
    80002ad0:	d78080e7          	jalr	-648(ra) # 80001844 <myproc>
    80002ad4:	591c                	lw	a5,48(a0)
    80002ad6:	ef9d                	bnez	a5,80002b14 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002ad8:	85ce                	mv	a1,s3
    80002ada:	8526                	mv	a0,s1
    80002adc:	fffff097          	auipc	ra,0xfffff
    80002ae0:	50a080e7          	jalr	1290(ra) # 80001fe6 <sleep>
  while(ticks - ticks0 < n){
    80002ae4:	409c                	lw	a5,0(s1)
    80002ae6:	412787bb          	subw	a5,a5,s2
    80002aea:	fcc42703          	lw	a4,-52(s0)
    80002aee:	fce7efe3          	bltu	a5,a4,80002acc <sys_sleep+0x50>
  }
  release(&tickslock);
    80002af2:	00014517          	auipc	a0,0x14
    80002af6:	c0e50513          	addi	a0,a0,-1010 # 80016700 <tickslock>
    80002afa:	ffffe097          	auipc	ra,0xffffe
    80002afe:	02c080e7          	jalr	44(ra) # 80000b26 <release>
  return 0;
    80002b02:	4781                	li	a5,0
}
    80002b04:	853e                	mv	a0,a5
    80002b06:	70e2                	ld	ra,56(sp)
    80002b08:	7442                	ld	s0,48(sp)
    80002b0a:	74a2                	ld	s1,40(sp)
    80002b0c:	7902                	ld	s2,32(sp)
    80002b0e:	69e2                	ld	s3,24(sp)
    80002b10:	6121                	addi	sp,sp,64
    80002b12:	8082                	ret
      release(&tickslock);
    80002b14:	00014517          	auipc	a0,0x14
    80002b18:	bec50513          	addi	a0,a0,-1044 # 80016700 <tickslock>
    80002b1c:	ffffe097          	auipc	ra,0xffffe
    80002b20:	00a080e7          	jalr	10(ra) # 80000b26 <release>
      return -1;
    80002b24:	57fd                	li	a5,-1
    80002b26:	bff9                	j	80002b04 <sys_sleep+0x88>

0000000080002b28 <sys_kill>:

uint64
sys_kill(void)
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002b30:	fec40593          	addi	a1,s0,-20
    80002b34:	4501                	li	a0,0
    80002b36:	00000097          	auipc	ra,0x0
    80002b3a:	d84080e7          	jalr	-636(ra) # 800028ba <argint>
    80002b3e:	87aa                	mv	a5,a0
    return -1;
    80002b40:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002b42:	0007c863          	bltz	a5,80002b52 <sys_kill+0x2a>
  return kill(pid);
    80002b46:	fec42503          	lw	a0,-20(s0)
    80002b4a:	fffff097          	auipc	ra,0xfffff
    80002b4e:	68c080e7          	jalr	1676(ra) # 800021d6 <kill>
}
    80002b52:	60e2                	ld	ra,24(sp)
    80002b54:	6442                	ld	s0,16(sp)
    80002b56:	6105                	addi	sp,sp,32
    80002b58:	8082                	ret

0000000080002b5a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b5a:	1101                	addi	sp,sp,-32
    80002b5c:	ec06                	sd	ra,24(sp)
    80002b5e:	e822                	sd	s0,16(sp)
    80002b60:	e426                	sd	s1,8(sp)
    80002b62:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b64:	00014517          	auipc	a0,0x14
    80002b68:	b9c50513          	addi	a0,a0,-1124 # 80016700 <tickslock>
    80002b6c:	ffffe097          	auipc	ra,0xffffe
    80002b70:	f66080e7          	jalr	-154(ra) # 80000ad2 <acquire>
  xticks = ticks;
    80002b74:	00022497          	auipc	s1,0x22
    80002b78:	4a44a483          	lw	s1,1188(s1) # 80025018 <ticks>
  release(&tickslock);
    80002b7c:	00014517          	auipc	a0,0x14
    80002b80:	b8450513          	addi	a0,a0,-1148 # 80016700 <tickslock>
    80002b84:	ffffe097          	auipc	ra,0xffffe
    80002b88:	fa2080e7          	jalr	-94(ra) # 80000b26 <release>
  return xticks;
}
    80002b8c:	02049513          	slli	a0,s1,0x20
    80002b90:	9101                	srli	a0,a0,0x20
    80002b92:	60e2                	ld	ra,24(sp)
    80002b94:	6442                	ld	s0,16(sp)
    80002b96:	64a2                	ld	s1,8(sp)
    80002b98:	6105                	addi	sp,sp,32
    80002b9a:	8082                	ret

0000000080002b9c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b9c:	7179                	addi	sp,sp,-48
    80002b9e:	f406                	sd	ra,40(sp)
    80002ba0:	f022                	sd	s0,32(sp)
    80002ba2:	ec26                	sd	s1,24(sp)
    80002ba4:	e84a                	sd	s2,16(sp)
    80002ba6:	e44e                	sd	s3,8(sp)
    80002ba8:	e052                	sd	s4,0(sp)
    80002baa:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002bac:	00004597          	auipc	a1,0x4
    80002bb0:	91c58593          	addi	a1,a1,-1764 # 800064c8 <userret+0x438>
    80002bb4:	00014517          	auipc	a0,0x14
    80002bb8:	b6450513          	addi	a0,a0,-1180 # 80016718 <bcache>
    80002bbc:	ffffe097          	auipc	ra,0xffffe
    80002bc0:	e04080e7          	jalr	-508(ra) # 800009c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002bc4:	0001c797          	auipc	a5,0x1c
    80002bc8:	b5478793          	addi	a5,a5,-1196 # 8001e718 <bcache+0x8000>
    80002bcc:	0001c717          	auipc	a4,0x1c
    80002bd0:	ea470713          	addi	a4,a4,-348 # 8001ea70 <bcache+0x8358>
    80002bd4:	3ae7b023          	sd	a4,928(a5)
  bcache.head.next = &bcache.head;
    80002bd8:	3ae7b423          	sd	a4,936(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002bdc:	00014497          	auipc	s1,0x14
    80002be0:	b5448493          	addi	s1,s1,-1196 # 80016730 <bcache+0x18>
    b->next = bcache.head.next;
    80002be4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002be6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002be8:	00004a17          	auipc	s4,0x4
    80002bec:	8e8a0a13          	addi	s4,s4,-1816 # 800064d0 <userret+0x440>
    b->next = bcache.head.next;
    80002bf0:	3a893783          	ld	a5,936(s2)
    80002bf4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bf6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bfa:	85d2                	mv	a1,s4
    80002bfc:	01048513          	addi	a0,s1,16
    80002c00:	00001097          	auipc	ra,0x1
    80002c04:	486080e7          	jalr	1158(ra) # 80004086 <initsleeplock>
    bcache.head.next->prev = b;
    80002c08:	3a893783          	ld	a5,936(s2)
    80002c0c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002c0e:	3a993423          	sd	s1,936(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c12:	46048493          	addi	s1,s1,1120
    80002c16:	fd349de3          	bne	s1,s3,80002bf0 <binit+0x54>
  }
}
    80002c1a:	70a2                	ld	ra,40(sp)
    80002c1c:	7402                	ld	s0,32(sp)
    80002c1e:	64e2                	ld	s1,24(sp)
    80002c20:	6942                	ld	s2,16(sp)
    80002c22:	69a2                	ld	s3,8(sp)
    80002c24:	6a02                	ld	s4,0(sp)
    80002c26:	6145                	addi	sp,sp,48
    80002c28:	8082                	ret

0000000080002c2a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002c2a:	7179                	addi	sp,sp,-48
    80002c2c:	f406                	sd	ra,40(sp)
    80002c2e:	f022                	sd	s0,32(sp)
    80002c30:	ec26                	sd	s1,24(sp)
    80002c32:	e84a                	sd	s2,16(sp)
    80002c34:	e44e                	sd	s3,8(sp)
    80002c36:	1800                	addi	s0,sp,48
    80002c38:	89aa                	mv	s3,a0
    80002c3a:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002c3c:	00014517          	auipc	a0,0x14
    80002c40:	adc50513          	addi	a0,a0,-1316 # 80016718 <bcache>
    80002c44:	ffffe097          	auipc	ra,0xffffe
    80002c48:	e8e080e7          	jalr	-370(ra) # 80000ad2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002c4c:	0001c497          	auipc	s1,0x1c
    80002c50:	e744b483          	ld	s1,-396(s1) # 8001eac0 <bcache+0x83a8>
    80002c54:	0001c797          	auipc	a5,0x1c
    80002c58:	e1c78793          	addi	a5,a5,-484 # 8001ea70 <bcache+0x8358>
    80002c5c:	02f48f63          	beq	s1,a5,80002c9a <bread+0x70>
    80002c60:	873e                	mv	a4,a5
    80002c62:	a021                	j	80002c6a <bread+0x40>
    80002c64:	68a4                	ld	s1,80(s1)
    80002c66:	02e48a63          	beq	s1,a4,80002c9a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002c6a:	449c                	lw	a5,8(s1)
    80002c6c:	ff379ce3          	bne	a5,s3,80002c64 <bread+0x3a>
    80002c70:	44dc                	lw	a5,12(s1)
    80002c72:	ff2799e3          	bne	a5,s2,80002c64 <bread+0x3a>
      b->refcnt++;
    80002c76:	40bc                	lw	a5,64(s1)
    80002c78:	2785                	addiw	a5,a5,1
    80002c7a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c7c:	00014517          	auipc	a0,0x14
    80002c80:	a9c50513          	addi	a0,a0,-1380 # 80016718 <bcache>
    80002c84:	ffffe097          	auipc	ra,0xffffe
    80002c88:	ea2080e7          	jalr	-350(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002c8c:	01048513          	addi	a0,s1,16
    80002c90:	00001097          	auipc	ra,0x1
    80002c94:	430080e7          	jalr	1072(ra) # 800040c0 <acquiresleep>
      return b;
    80002c98:	a8b9                	j	80002cf6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002c9a:	0001c497          	auipc	s1,0x1c
    80002c9e:	e1e4b483          	ld	s1,-482(s1) # 8001eab8 <bcache+0x83a0>
    80002ca2:	0001c797          	auipc	a5,0x1c
    80002ca6:	dce78793          	addi	a5,a5,-562 # 8001ea70 <bcache+0x8358>
    80002caa:	00f48863          	beq	s1,a5,80002cba <bread+0x90>
    80002cae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002cb0:	40bc                	lw	a5,64(s1)
    80002cb2:	cf81                	beqz	a5,80002cca <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002cb4:	64a4                	ld	s1,72(s1)
    80002cb6:	fee49de3          	bne	s1,a4,80002cb0 <bread+0x86>
  panic("bget: no buffers");
    80002cba:	00004517          	auipc	a0,0x4
    80002cbe:	81e50513          	addi	a0,a0,-2018 # 800064d8 <userret+0x448>
    80002cc2:	ffffe097          	auipc	ra,0xffffe
    80002cc6:	88c080e7          	jalr	-1908(ra) # 8000054e <panic>
      b->dev = dev;
    80002cca:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002cce:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002cd2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002cd6:	4785                	li	a5,1
    80002cd8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002cda:	00014517          	auipc	a0,0x14
    80002cde:	a3e50513          	addi	a0,a0,-1474 # 80016718 <bcache>
    80002ce2:	ffffe097          	auipc	ra,0xffffe
    80002ce6:	e44080e7          	jalr	-444(ra) # 80000b26 <release>
      acquiresleep(&b->lock);
    80002cea:	01048513          	addi	a0,s1,16
    80002cee:	00001097          	auipc	ra,0x1
    80002cf2:	3d2080e7          	jalr	978(ra) # 800040c0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002cf6:	409c                	lw	a5,0(s1)
    80002cf8:	cb89                	beqz	a5,80002d0a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cfa:	8526                	mv	a0,s1
    80002cfc:	70a2                	ld	ra,40(sp)
    80002cfe:	7402                	ld	s0,32(sp)
    80002d00:	64e2                	ld	s1,24(sp)
    80002d02:	6942                	ld	s2,16(sp)
    80002d04:	69a2                	ld	s3,8(sp)
    80002d06:	6145                	addi	sp,sp,48
    80002d08:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d0a:	4581                	li	a1,0
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	ee0080e7          	jalr	-288(ra) # 80005bee <virtio_disk_rw>
    b->valid = 1;
    80002d16:	4785                	li	a5,1
    80002d18:	c09c                	sw	a5,0(s1)
  return b;
    80002d1a:	b7c5                	j	80002cfa <bread+0xd0>

0000000080002d1c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	1000                	addi	s0,sp,32
    80002d26:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d28:	0541                	addi	a0,a0,16
    80002d2a:	00001097          	auipc	ra,0x1
    80002d2e:	430080e7          	jalr	1072(ra) # 8000415a <holdingsleep>
    80002d32:	cd01                	beqz	a0,80002d4a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002d34:	4585                	li	a1,1
    80002d36:	8526                	mv	a0,s1
    80002d38:	00003097          	auipc	ra,0x3
    80002d3c:	eb6080e7          	jalr	-330(ra) # 80005bee <virtio_disk_rw>
}
    80002d40:	60e2                	ld	ra,24(sp)
    80002d42:	6442                	ld	s0,16(sp)
    80002d44:	64a2                	ld	s1,8(sp)
    80002d46:	6105                	addi	sp,sp,32
    80002d48:	8082                	ret
    panic("bwrite");
    80002d4a:	00003517          	auipc	a0,0x3
    80002d4e:	7a650513          	addi	a0,a0,1958 # 800064f0 <userret+0x460>
    80002d52:	ffffd097          	auipc	ra,0xffffd
    80002d56:	7fc080e7          	jalr	2044(ra) # 8000054e <panic>

0000000080002d5a <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    80002d5a:	1101                	addi	sp,sp,-32
    80002d5c:	ec06                	sd	ra,24(sp)
    80002d5e:	e822                	sd	s0,16(sp)
    80002d60:	e426                	sd	s1,8(sp)
    80002d62:	e04a                	sd	s2,0(sp)
    80002d64:	1000                	addi	s0,sp,32
    80002d66:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002d68:	01050913          	addi	s2,a0,16
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	3ec080e7          	jalr	1004(ra) # 8000415a <holdingsleep>
    80002d76:	c92d                	beqz	a0,80002de8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002d78:	854a                	mv	a0,s2
    80002d7a:	00001097          	auipc	ra,0x1
    80002d7e:	39c080e7          	jalr	924(ra) # 80004116 <releasesleep>

  acquire(&bcache.lock);
    80002d82:	00014517          	auipc	a0,0x14
    80002d86:	99650513          	addi	a0,a0,-1642 # 80016718 <bcache>
    80002d8a:	ffffe097          	auipc	ra,0xffffe
    80002d8e:	d48080e7          	jalr	-696(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80002d92:	40bc                	lw	a5,64(s1)
    80002d94:	37fd                	addiw	a5,a5,-1
    80002d96:	0007871b          	sext.w	a4,a5
    80002d9a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d9c:	eb05                	bnez	a4,80002dcc <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d9e:	68bc                	ld	a5,80(s1)
    80002da0:	64b8                	ld	a4,72(s1)
    80002da2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002da4:	64bc                	ld	a5,72(s1)
    80002da6:	68b8                	ld	a4,80(s1)
    80002da8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002daa:	0001c797          	auipc	a5,0x1c
    80002dae:	96e78793          	addi	a5,a5,-1682 # 8001e718 <bcache+0x8000>
    80002db2:	3a87b703          	ld	a4,936(a5)
    80002db6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002db8:	0001c717          	auipc	a4,0x1c
    80002dbc:	cb870713          	addi	a4,a4,-840 # 8001ea70 <bcache+0x8358>
    80002dc0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002dc2:	3a87b703          	ld	a4,936(a5)
    80002dc6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002dc8:	3a97b423          	sd	s1,936(a5)
  }
  
  release(&bcache.lock);
    80002dcc:	00014517          	auipc	a0,0x14
    80002dd0:	94c50513          	addi	a0,a0,-1716 # 80016718 <bcache>
    80002dd4:	ffffe097          	auipc	ra,0xffffe
    80002dd8:	d52080e7          	jalr	-686(ra) # 80000b26 <release>
}
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	64a2                	ld	s1,8(sp)
    80002de2:	6902                	ld	s2,0(sp)
    80002de4:	6105                	addi	sp,sp,32
    80002de6:	8082                	ret
    panic("brelse");
    80002de8:	00003517          	auipc	a0,0x3
    80002dec:	71050513          	addi	a0,a0,1808 # 800064f8 <userret+0x468>
    80002df0:	ffffd097          	auipc	ra,0xffffd
    80002df4:	75e080e7          	jalr	1886(ra) # 8000054e <panic>

0000000080002df8 <bpin>:

void
bpin(struct buf *b) {
    80002df8:	1101                	addi	sp,sp,-32
    80002dfa:	ec06                	sd	ra,24(sp)
    80002dfc:	e822                	sd	s0,16(sp)
    80002dfe:	e426                	sd	s1,8(sp)
    80002e00:	1000                	addi	s0,sp,32
    80002e02:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e04:	00014517          	auipc	a0,0x14
    80002e08:	91450513          	addi	a0,a0,-1772 # 80016718 <bcache>
    80002e0c:	ffffe097          	auipc	ra,0xffffe
    80002e10:	cc6080e7          	jalr	-826(ra) # 80000ad2 <acquire>
  b->refcnt++;
    80002e14:	40bc                	lw	a5,64(s1)
    80002e16:	2785                	addiw	a5,a5,1
    80002e18:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e1a:	00014517          	auipc	a0,0x14
    80002e1e:	8fe50513          	addi	a0,a0,-1794 # 80016718 <bcache>
    80002e22:	ffffe097          	auipc	ra,0xffffe
    80002e26:	d04080e7          	jalr	-764(ra) # 80000b26 <release>
}
    80002e2a:	60e2                	ld	ra,24(sp)
    80002e2c:	6442                	ld	s0,16(sp)
    80002e2e:	64a2                	ld	s1,8(sp)
    80002e30:	6105                	addi	sp,sp,32
    80002e32:	8082                	ret

0000000080002e34 <bunpin>:

void
bunpin(struct buf *b) {
    80002e34:	1101                	addi	sp,sp,-32
    80002e36:	ec06                	sd	ra,24(sp)
    80002e38:	e822                	sd	s0,16(sp)
    80002e3a:	e426                	sd	s1,8(sp)
    80002e3c:	1000                	addi	s0,sp,32
    80002e3e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e40:	00014517          	auipc	a0,0x14
    80002e44:	8d850513          	addi	a0,a0,-1832 # 80016718 <bcache>
    80002e48:	ffffe097          	auipc	ra,0xffffe
    80002e4c:	c8a080e7          	jalr	-886(ra) # 80000ad2 <acquire>
  b->refcnt--;
    80002e50:	40bc                	lw	a5,64(s1)
    80002e52:	37fd                	addiw	a5,a5,-1
    80002e54:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e56:	00014517          	auipc	a0,0x14
    80002e5a:	8c250513          	addi	a0,a0,-1854 # 80016718 <bcache>
    80002e5e:	ffffe097          	auipc	ra,0xffffe
    80002e62:	cc8080e7          	jalr	-824(ra) # 80000b26 <release>
}
    80002e66:	60e2                	ld	ra,24(sp)
    80002e68:	6442                	ld	s0,16(sp)
    80002e6a:	64a2                	ld	s1,8(sp)
    80002e6c:	6105                	addi	sp,sp,32
    80002e6e:	8082                	ret

0000000080002e70 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002e70:	1101                	addi	sp,sp,-32
    80002e72:	ec06                	sd	ra,24(sp)
    80002e74:	e822                	sd	s0,16(sp)
    80002e76:	e426                	sd	s1,8(sp)
    80002e78:	e04a                	sd	s2,0(sp)
    80002e7a:	1000                	addi	s0,sp,32
    80002e7c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002e7e:	00d5d59b          	srliw	a1,a1,0xd
    80002e82:	0001c797          	auipc	a5,0x1c
    80002e86:	06a7a783          	lw	a5,106(a5) # 8001eeec <sb+0x1c>
    80002e8a:	9dbd                	addw	a1,a1,a5
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	d9e080e7          	jalr	-610(ra) # 80002c2a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e94:	0074f713          	andi	a4,s1,7
    80002e98:	4785                	li	a5,1
    80002e9a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002e9e:	14ce                	slli	s1,s1,0x33
    80002ea0:	90d9                	srli	s1,s1,0x36
    80002ea2:	00950733          	add	a4,a0,s1
    80002ea6:	06074703          	lbu	a4,96(a4)
    80002eaa:	00e7f6b3          	and	a3,a5,a4
    80002eae:	c69d                	beqz	a3,80002edc <bfree+0x6c>
    80002eb0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002eb2:	94aa                	add	s1,s1,a0
    80002eb4:	fff7c793          	not	a5,a5
    80002eb8:	8ff9                	and	a5,a5,a4
    80002eba:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002ebe:	00001097          	auipc	ra,0x1
    80002ec2:	0da080e7          	jalr	218(ra) # 80003f98 <log_write>
  brelse(bp);
    80002ec6:	854a                	mv	a0,s2
    80002ec8:	00000097          	auipc	ra,0x0
    80002ecc:	e92080e7          	jalr	-366(ra) # 80002d5a <brelse>
}
    80002ed0:	60e2                	ld	ra,24(sp)
    80002ed2:	6442                	ld	s0,16(sp)
    80002ed4:	64a2                	ld	s1,8(sp)
    80002ed6:	6902                	ld	s2,0(sp)
    80002ed8:	6105                	addi	sp,sp,32
    80002eda:	8082                	ret
    panic("freeing free block");
    80002edc:	00003517          	auipc	a0,0x3
    80002ee0:	62450513          	addi	a0,a0,1572 # 80006500 <userret+0x470>
    80002ee4:	ffffd097          	auipc	ra,0xffffd
    80002ee8:	66a080e7          	jalr	1642(ra) # 8000054e <panic>

0000000080002eec <balloc>:
{
    80002eec:	711d                	addi	sp,sp,-96
    80002eee:	ec86                	sd	ra,88(sp)
    80002ef0:	e8a2                	sd	s0,80(sp)
    80002ef2:	e4a6                	sd	s1,72(sp)
    80002ef4:	e0ca                	sd	s2,64(sp)
    80002ef6:	fc4e                	sd	s3,56(sp)
    80002ef8:	f852                	sd	s4,48(sp)
    80002efa:	f456                	sd	s5,40(sp)
    80002efc:	f05a                	sd	s6,32(sp)
    80002efe:	ec5e                	sd	s7,24(sp)
    80002f00:	e862                	sd	s8,16(sp)
    80002f02:	e466                	sd	s9,8(sp)
    80002f04:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f06:	0001c797          	auipc	a5,0x1c
    80002f0a:	fce7a783          	lw	a5,-50(a5) # 8001eed4 <sb+0x4>
    80002f0e:	cbd1                	beqz	a5,80002fa2 <balloc+0xb6>
    80002f10:	8baa                	mv	s7,a0
    80002f12:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f14:	0001cb17          	auipc	s6,0x1c
    80002f18:	fbcb0b13          	addi	s6,s6,-68 # 8001eed0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f1c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002f1e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f20:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f22:	6c89                	lui	s9,0x2
    80002f24:	a831                	j	80002f40 <balloc+0x54>
    brelse(bp);
    80002f26:	854a                	mv	a0,s2
    80002f28:	00000097          	auipc	ra,0x0
    80002f2c:	e32080e7          	jalr	-462(ra) # 80002d5a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002f30:	015c87bb          	addw	a5,s9,s5
    80002f34:	00078a9b          	sext.w	s5,a5
    80002f38:	004b2703          	lw	a4,4(s6)
    80002f3c:	06eaf363          	bgeu	s5,a4,80002fa2 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002f40:	41fad79b          	sraiw	a5,s5,0x1f
    80002f44:	0137d79b          	srliw	a5,a5,0x13
    80002f48:	015787bb          	addw	a5,a5,s5
    80002f4c:	40d7d79b          	sraiw	a5,a5,0xd
    80002f50:	01cb2583          	lw	a1,28(s6)
    80002f54:	9dbd                	addw	a1,a1,a5
    80002f56:	855e                	mv	a0,s7
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	cd2080e7          	jalr	-814(ra) # 80002c2a <bread>
    80002f60:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f62:	004b2503          	lw	a0,4(s6)
    80002f66:	000a849b          	sext.w	s1,s5
    80002f6a:	8662                	mv	a2,s8
    80002f6c:	faa4fde3          	bgeu	s1,a0,80002f26 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002f70:	41f6579b          	sraiw	a5,a2,0x1f
    80002f74:	01d7d69b          	srliw	a3,a5,0x1d
    80002f78:	00c6873b          	addw	a4,a3,a2
    80002f7c:	00777793          	andi	a5,a4,7
    80002f80:	9f95                	subw	a5,a5,a3
    80002f82:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002f86:	4037571b          	sraiw	a4,a4,0x3
    80002f8a:	00e906b3          	add	a3,s2,a4
    80002f8e:	0606c683          	lbu	a3,96(a3)
    80002f92:	00d7f5b3          	and	a1,a5,a3
    80002f96:	cd91                	beqz	a1,80002fb2 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f98:	2605                	addiw	a2,a2,1
    80002f9a:	2485                	addiw	s1,s1,1
    80002f9c:	fd4618e3          	bne	a2,s4,80002f6c <balloc+0x80>
    80002fa0:	b759                	j	80002f26 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002fa2:	00003517          	auipc	a0,0x3
    80002fa6:	57650513          	addi	a0,a0,1398 # 80006518 <userret+0x488>
    80002faa:	ffffd097          	auipc	ra,0xffffd
    80002fae:	5a4080e7          	jalr	1444(ra) # 8000054e <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002fb2:	974a                	add	a4,a4,s2
    80002fb4:	8fd5                	or	a5,a5,a3
    80002fb6:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002fba:	854a                	mv	a0,s2
    80002fbc:	00001097          	auipc	ra,0x1
    80002fc0:	fdc080e7          	jalr	-36(ra) # 80003f98 <log_write>
        brelse(bp);
    80002fc4:	854a                	mv	a0,s2
    80002fc6:	00000097          	auipc	ra,0x0
    80002fca:	d94080e7          	jalr	-620(ra) # 80002d5a <brelse>
  bp = bread(dev, bno);
    80002fce:	85a6                	mv	a1,s1
    80002fd0:	855e                	mv	a0,s7
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	c58080e7          	jalr	-936(ra) # 80002c2a <bread>
    80002fda:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002fdc:	40000613          	li	a2,1024
    80002fe0:	4581                	li	a1,0
    80002fe2:	06050513          	addi	a0,a0,96
    80002fe6:	ffffe097          	auipc	ra,0xffffe
    80002fea:	b88080e7          	jalr	-1144(ra) # 80000b6e <memset>
  log_write(bp);
    80002fee:	854a                	mv	a0,s2
    80002ff0:	00001097          	auipc	ra,0x1
    80002ff4:	fa8080e7          	jalr	-88(ra) # 80003f98 <log_write>
  brelse(bp);
    80002ff8:	854a                	mv	a0,s2
    80002ffa:	00000097          	auipc	ra,0x0
    80002ffe:	d60080e7          	jalr	-672(ra) # 80002d5a <brelse>
}
    80003002:	8526                	mv	a0,s1
    80003004:	60e6                	ld	ra,88(sp)
    80003006:	6446                	ld	s0,80(sp)
    80003008:	64a6                	ld	s1,72(sp)
    8000300a:	6906                	ld	s2,64(sp)
    8000300c:	79e2                	ld	s3,56(sp)
    8000300e:	7a42                	ld	s4,48(sp)
    80003010:	7aa2                	ld	s5,40(sp)
    80003012:	7b02                	ld	s6,32(sp)
    80003014:	6be2                	ld	s7,24(sp)
    80003016:	6c42                	ld	s8,16(sp)
    80003018:	6ca2                	ld	s9,8(sp)
    8000301a:	6125                	addi	sp,sp,96
    8000301c:	8082                	ret

000000008000301e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000301e:	7179                	addi	sp,sp,-48
    80003020:	f406                	sd	ra,40(sp)
    80003022:	f022                	sd	s0,32(sp)
    80003024:	ec26                	sd	s1,24(sp)
    80003026:	e84a                	sd	s2,16(sp)
    80003028:	e44e                	sd	s3,8(sp)
    8000302a:	e052                	sd	s4,0(sp)
    8000302c:	1800                	addi	s0,sp,48
    8000302e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003030:	47ad                	li	a5,11
    80003032:	04b7fe63          	bgeu	a5,a1,8000308e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003036:	ff45849b          	addiw	s1,a1,-12
    8000303a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000303e:	0ff00793          	li	a5,255
    80003042:	0ae7e363          	bltu	a5,a4,800030e8 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003046:	08052583          	lw	a1,128(a0)
    8000304a:	c5ad                	beqz	a1,800030b4 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000304c:	00092503          	lw	a0,0(s2)
    80003050:	00000097          	auipc	ra,0x0
    80003054:	bda080e7          	jalr	-1062(ra) # 80002c2a <bread>
    80003058:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000305a:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    8000305e:	02049593          	slli	a1,s1,0x20
    80003062:	9181                	srli	a1,a1,0x20
    80003064:	058a                	slli	a1,a1,0x2
    80003066:	00b784b3          	add	s1,a5,a1
    8000306a:	0004a983          	lw	s3,0(s1)
    8000306e:	04098d63          	beqz	s3,800030c8 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003072:	8552                	mv	a0,s4
    80003074:	00000097          	auipc	ra,0x0
    80003078:	ce6080e7          	jalr	-794(ra) # 80002d5a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000307c:	854e                	mv	a0,s3
    8000307e:	70a2                	ld	ra,40(sp)
    80003080:	7402                	ld	s0,32(sp)
    80003082:	64e2                	ld	s1,24(sp)
    80003084:	6942                	ld	s2,16(sp)
    80003086:	69a2                	ld	s3,8(sp)
    80003088:	6a02                	ld	s4,0(sp)
    8000308a:	6145                	addi	sp,sp,48
    8000308c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000308e:	02059493          	slli	s1,a1,0x20
    80003092:	9081                	srli	s1,s1,0x20
    80003094:	048a                	slli	s1,s1,0x2
    80003096:	94aa                	add	s1,s1,a0
    80003098:	0504a983          	lw	s3,80(s1)
    8000309c:	fe0990e3          	bnez	s3,8000307c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800030a0:	4108                	lw	a0,0(a0)
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	e4a080e7          	jalr	-438(ra) # 80002eec <balloc>
    800030aa:	0005099b          	sext.w	s3,a0
    800030ae:	0534a823          	sw	s3,80(s1)
    800030b2:	b7e9                	j	8000307c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800030b4:	4108                	lw	a0,0(a0)
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	e36080e7          	jalr	-458(ra) # 80002eec <balloc>
    800030be:	0005059b          	sext.w	a1,a0
    800030c2:	08b92023          	sw	a1,128(s2)
    800030c6:	b759                	j	8000304c <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800030c8:	00092503          	lw	a0,0(s2)
    800030cc:	00000097          	auipc	ra,0x0
    800030d0:	e20080e7          	jalr	-480(ra) # 80002eec <balloc>
    800030d4:	0005099b          	sext.w	s3,a0
    800030d8:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800030dc:	8552                	mv	a0,s4
    800030de:	00001097          	auipc	ra,0x1
    800030e2:	eba080e7          	jalr	-326(ra) # 80003f98 <log_write>
    800030e6:	b771                	j	80003072 <bmap+0x54>
  panic("bmap: out of range");
    800030e8:	00003517          	auipc	a0,0x3
    800030ec:	44850513          	addi	a0,a0,1096 # 80006530 <userret+0x4a0>
    800030f0:	ffffd097          	auipc	ra,0xffffd
    800030f4:	45e080e7          	jalr	1118(ra) # 8000054e <panic>

00000000800030f8 <iget>:
{
    800030f8:	7179                	addi	sp,sp,-48
    800030fa:	f406                	sd	ra,40(sp)
    800030fc:	f022                	sd	s0,32(sp)
    800030fe:	ec26                	sd	s1,24(sp)
    80003100:	e84a                	sd	s2,16(sp)
    80003102:	e44e                	sd	s3,8(sp)
    80003104:	e052                	sd	s4,0(sp)
    80003106:	1800                	addi	s0,sp,48
    80003108:	89aa                	mv	s3,a0
    8000310a:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    8000310c:	0001c517          	auipc	a0,0x1c
    80003110:	de450513          	addi	a0,a0,-540 # 8001eef0 <icache>
    80003114:	ffffe097          	auipc	ra,0xffffe
    80003118:	9be080e7          	jalr	-1602(ra) # 80000ad2 <acquire>
  empty = 0;
    8000311c:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000311e:	0001c497          	auipc	s1,0x1c
    80003122:	dea48493          	addi	s1,s1,-534 # 8001ef08 <icache+0x18>
    80003126:	0001e697          	auipc	a3,0x1e
    8000312a:	87268693          	addi	a3,a3,-1934 # 80020998 <log>
    8000312e:	a039                	j	8000313c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003130:	02090b63          	beqz	s2,80003166 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003134:	08848493          	addi	s1,s1,136
    80003138:	02d48a63          	beq	s1,a3,8000316c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000313c:	449c                	lw	a5,8(s1)
    8000313e:	fef059e3          	blez	a5,80003130 <iget+0x38>
    80003142:	4098                	lw	a4,0(s1)
    80003144:	ff3716e3          	bne	a4,s3,80003130 <iget+0x38>
    80003148:	40d8                	lw	a4,4(s1)
    8000314a:	ff4713e3          	bne	a4,s4,80003130 <iget+0x38>
      ip->ref++;
    8000314e:	2785                	addiw	a5,a5,1
    80003150:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003152:	0001c517          	auipc	a0,0x1c
    80003156:	d9e50513          	addi	a0,a0,-610 # 8001eef0 <icache>
    8000315a:	ffffe097          	auipc	ra,0xffffe
    8000315e:	9cc080e7          	jalr	-1588(ra) # 80000b26 <release>
      return ip;
    80003162:	8926                	mv	s2,s1
    80003164:	a03d                	j	80003192 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003166:	f7f9                	bnez	a5,80003134 <iget+0x3c>
    80003168:	8926                	mv	s2,s1
    8000316a:	b7e9                	j	80003134 <iget+0x3c>
  if(empty == 0)
    8000316c:	02090c63          	beqz	s2,800031a4 <iget+0xac>
  ip->dev = dev;
    80003170:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003174:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003178:	4785                	li	a5,1
    8000317a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000317e:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    80003182:	0001c517          	auipc	a0,0x1c
    80003186:	d6e50513          	addi	a0,a0,-658 # 8001eef0 <icache>
    8000318a:	ffffe097          	auipc	ra,0xffffe
    8000318e:	99c080e7          	jalr	-1636(ra) # 80000b26 <release>
}
    80003192:	854a                	mv	a0,s2
    80003194:	70a2                	ld	ra,40(sp)
    80003196:	7402                	ld	s0,32(sp)
    80003198:	64e2                	ld	s1,24(sp)
    8000319a:	6942                	ld	s2,16(sp)
    8000319c:	69a2                	ld	s3,8(sp)
    8000319e:	6a02                	ld	s4,0(sp)
    800031a0:	6145                	addi	sp,sp,48
    800031a2:	8082                	ret
    panic("iget: no inodes");
    800031a4:	00003517          	auipc	a0,0x3
    800031a8:	3a450513          	addi	a0,a0,932 # 80006548 <userret+0x4b8>
    800031ac:	ffffd097          	auipc	ra,0xffffd
    800031b0:	3a2080e7          	jalr	930(ra) # 8000054e <panic>

00000000800031b4 <fsinit>:
fsinit(int dev) {
    800031b4:	7179                	addi	sp,sp,-48
    800031b6:	f406                	sd	ra,40(sp)
    800031b8:	f022                	sd	s0,32(sp)
    800031ba:	ec26                	sd	s1,24(sp)
    800031bc:	e84a                	sd	s2,16(sp)
    800031be:	e44e                	sd	s3,8(sp)
    800031c0:	1800                	addi	s0,sp,48
    800031c2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800031c4:	4585                	li	a1,1
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	a64080e7          	jalr	-1436(ra) # 80002c2a <bread>
    800031ce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800031d0:	0001c997          	auipc	s3,0x1c
    800031d4:	d0098993          	addi	s3,s3,-768 # 8001eed0 <sb>
    800031d8:	02000613          	li	a2,32
    800031dc:	06050593          	addi	a1,a0,96
    800031e0:	854e                	mv	a0,s3
    800031e2:	ffffe097          	auipc	ra,0xffffe
    800031e6:	9ec080e7          	jalr	-1556(ra) # 80000bce <memmove>
  brelse(bp);
    800031ea:	8526                	mv	a0,s1
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	b6e080e7          	jalr	-1170(ra) # 80002d5a <brelse>
  if(sb.magic != FSMAGIC)
    800031f4:	0009a703          	lw	a4,0(s3)
    800031f8:	102037b7          	lui	a5,0x10203
    800031fc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003200:	02f71263          	bne	a4,a5,80003224 <fsinit+0x70>
  initlog(dev, &sb);
    80003204:	0001c597          	auipc	a1,0x1c
    80003208:	ccc58593          	addi	a1,a1,-820 # 8001eed0 <sb>
    8000320c:	854a                	mv	a0,s2
    8000320e:	00001097          	auipc	ra,0x1
    80003212:	b12080e7          	jalr	-1262(ra) # 80003d20 <initlog>
}
    80003216:	70a2                	ld	ra,40(sp)
    80003218:	7402                	ld	s0,32(sp)
    8000321a:	64e2                	ld	s1,24(sp)
    8000321c:	6942                	ld	s2,16(sp)
    8000321e:	69a2                	ld	s3,8(sp)
    80003220:	6145                	addi	sp,sp,48
    80003222:	8082                	ret
    panic("invalid file system");
    80003224:	00003517          	auipc	a0,0x3
    80003228:	33450513          	addi	a0,a0,820 # 80006558 <userret+0x4c8>
    8000322c:	ffffd097          	auipc	ra,0xffffd
    80003230:	322080e7          	jalr	802(ra) # 8000054e <panic>

0000000080003234 <iinit>:
{
    80003234:	7179                	addi	sp,sp,-48
    80003236:	f406                	sd	ra,40(sp)
    80003238:	f022                	sd	s0,32(sp)
    8000323a:	ec26                	sd	s1,24(sp)
    8000323c:	e84a                	sd	s2,16(sp)
    8000323e:	e44e                	sd	s3,8(sp)
    80003240:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003242:	00003597          	auipc	a1,0x3
    80003246:	32e58593          	addi	a1,a1,814 # 80006570 <userret+0x4e0>
    8000324a:	0001c517          	auipc	a0,0x1c
    8000324e:	ca650513          	addi	a0,a0,-858 # 8001eef0 <icache>
    80003252:	ffffd097          	auipc	ra,0xffffd
    80003256:	76e080e7          	jalr	1902(ra) # 800009c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000325a:	0001c497          	auipc	s1,0x1c
    8000325e:	cbe48493          	addi	s1,s1,-834 # 8001ef18 <icache+0x28>
    80003262:	0001d997          	auipc	s3,0x1d
    80003266:	74698993          	addi	s3,s3,1862 # 800209a8 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000326a:	00003917          	auipc	s2,0x3
    8000326e:	30e90913          	addi	s2,s2,782 # 80006578 <userret+0x4e8>
    80003272:	85ca                	mv	a1,s2
    80003274:	8526                	mv	a0,s1
    80003276:	00001097          	auipc	ra,0x1
    8000327a:	e10080e7          	jalr	-496(ra) # 80004086 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000327e:	08848493          	addi	s1,s1,136
    80003282:	ff3498e3          	bne	s1,s3,80003272 <iinit+0x3e>
}
    80003286:	70a2                	ld	ra,40(sp)
    80003288:	7402                	ld	s0,32(sp)
    8000328a:	64e2                	ld	s1,24(sp)
    8000328c:	6942                	ld	s2,16(sp)
    8000328e:	69a2                	ld	s3,8(sp)
    80003290:	6145                	addi	sp,sp,48
    80003292:	8082                	ret

0000000080003294 <ialloc>:
{
    80003294:	715d                	addi	sp,sp,-80
    80003296:	e486                	sd	ra,72(sp)
    80003298:	e0a2                	sd	s0,64(sp)
    8000329a:	fc26                	sd	s1,56(sp)
    8000329c:	f84a                	sd	s2,48(sp)
    8000329e:	f44e                	sd	s3,40(sp)
    800032a0:	f052                	sd	s4,32(sp)
    800032a2:	ec56                	sd	s5,24(sp)
    800032a4:	e85a                	sd	s6,16(sp)
    800032a6:	e45e                	sd	s7,8(sp)
    800032a8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800032aa:	0001c717          	auipc	a4,0x1c
    800032ae:	c3272703          	lw	a4,-974(a4) # 8001eedc <sb+0xc>
    800032b2:	4785                	li	a5,1
    800032b4:	04e7fa63          	bgeu	a5,a4,80003308 <ialloc+0x74>
    800032b8:	8aaa                	mv	s5,a0
    800032ba:	8bae                	mv	s7,a1
    800032bc:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800032be:	0001ca17          	auipc	s4,0x1c
    800032c2:	c12a0a13          	addi	s4,s4,-1006 # 8001eed0 <sb>
    800032c6:	00048b1b          	sext.w	s6,s1
    800032ca:	0044d593          	srli	a1,s1,0x4
    800032ce:	018a2783          	lw	a5,24(s4)
    800032d2:	9dbd                	addw	a1,a1,a5
    800032d4:	8556                	mv	a0,s5
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	954080e7          	jalr	-1708(ra) # 80002c2a <bread>
    800032de:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800032e0:	06050993          	addi	s3,a0,96
    800032e4:	00f4f793          	andi	a5,s1,15
    800032e8:	079a                	slli	a5,a5,0x6
    800032ea:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800032ec:	00099783          	lh	a5,0(s3)
    800032f0:	c785                	beqz	a5,80003318 <ialloc+0x84>
    brelse(bp);
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	a68080e7          	jalr	-1432(ra) # 80002d5a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800032fa:	0485                	addi	s1,s1,1
    800032fc:	00ca2703          	lw	a4,12(s4)
    80003300:	0004879b          	sext.w	a5,s1
    80003304:	fce7e1e3          	bltu	a5,a4,800032c6 <ialloc+0x32>
  panic("ialloc: no inodes");
    80003308:	00003517          	auipc	a0,0x3
    8000330c:	27850513          	addi	a0,a0,632 # 80006580 <userret+0x4f0>
    80003310:	ffffd097          	auipc	ra,0xffffd
    80003314:	23e080e7          	jalr	574(ra) # 8000054e <panic>
      memset(dip, 0, sizeof(*dip));
    80003318:	04000613          	li	a2,64
    8000331c:	4581                	li	a1,0
    8000331e:	854e                	mv	a0,s3
    80003320:	ffffe097          	auipc	ra,0xffffe
    80003324:	84e080e7          	jalr	-1970(ra) # 80000b6e <memset>
      dip->type = type;
    80003328:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000332c:	854a                	mv	a0,s2
    8000332e:	00001097          	auipc	ra,0x1
    80003332:	c6a080e7          	jalr	-918(ra) # 80003f98 <log_write>
      brelse(bp);
    80003336:	854a                	mv	a0,s2
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	a22080e7          	jalr	-1502(ra) # 80002d5a <brelse>
      return iget(dev, inum);
    80003340:	85da                	mv	a1,s6
    80003342:	8556                	mv	a0,s5
    80003344:	00000097          	auipc	ra,0x0
    80003348:	db4080e7          	jalr	-588(ra) # 800030f8 <iget>
}
    8000334c:	60a6                	ld	ra,72(sp)
    8000334e:	6406                	ld	s0,64(sp)
    80003350:	74e2                	ld	s1,56(sp)
    80003352:	7942                	ld	s2,48(sp)
    80003354:	79a2                	ld	s3,40(sp)
    80003356:	7a02                	ld	s4,32(sp)
    80003358:	6ae2                	ld	s5,24(sp)
    8000335a:	6b42                	ld	s6,16(sp)
    8000335c:	6ba2                	ld	s7,8(sp)
    8000335e:	6161                	addi	sp,sp,80
    80003360:	8082                	ret

0000000080003362 <iupdate>:
{
    80003362:	1101                	addi	sp,sp,-32
    80003364:	ec06                	sd	ra,24(sp)
    80003366:	e822                	sd	s0,16(sp)
    80003368:	e426                	sd	s1,8(sp)
    8000336a:	e04a                	sd	s2,0(sp)
    8000336c:	1000                	addi	s0,sp,32
    8000336e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003370:	415c                	lw	a5,4(a0)
    80003372:	0047d79b          	srliw	a5,a5,0x4
    80003376:	0001c597          	auipc	a1,0x1c
    8000337a:	b725a583          	lw	a1,-1166(a1) # 8001eee8 <sb+0x18>
    8000337e:	9dbd                	addw	a1,a1,a5
    80003380:	4108                	lw	a0,0(a0)
    80003382:	00000097          	auipc	ra,0x0
    80003386:	8a8080e7          	jalr	-1880(ra) # 80002c2a <bread>
    8000338a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000338c:	06050793          	addi	a5,a0,96
    80003390:	40c8                	lw	a0,4(s1)
    80003392:	893d                	andi	a0,a0,15
    80003394:	051a                	slli	a0,a0,0x6
    80003396:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003398:	04449703          	lh	a4,68(s1)
    8000339c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800033a0:	04649703          	lh	a4,70(s1)
    800033a4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800033a8:	04849703          	lh	a4,72(s1)
    800033ac:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800033b0:	04a49703          	lh	a4,74(s1)
    800033b4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800033b8:	44f8                	lw	a4,76(s1)
    800033ba:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800033bc:	03400613          	li	a2,52
    800033c0:	05048593          	addi	a1,s1,80
    800033c4:	0531                	addi	a0,a0,12
    800033c6:	ffffe097          	auipc	ra,0xffffe
    800033ca:	808080e7          	jalr	-2040(ra) # 80000bce <memmove>
  log_write(bp);
    800033ce:	854a                	mv	a0,s2
    800033d0:	00001097          	auipc	ra,0x1
    800033d4:	bc8080e7          	jalr	-1080(ra) # 80003f98 <log_write>
  brelse(bp);
    800033d8:	854a                	mv	a0,s2
    800033da:	00000097          	auipc	ra,0x0
    800033de:	980080e7          	jalr	-1664(ra) # 80002d5a <brelse>
}
    800033e2:	60e2                	ld	ra,24(sp)
    800033e4:	6442                	ld	s0,16(sp)
    800033e6:	64a2                	ld	s1,8(sp)
    800033e8:	6902                	ld	s2,0(sp)
    800033ea:	6105                	addi	sp,sp,32
    800033ec:	8082                	ret

00000000800033ee <idup>:
{
    800033ee:	1101                	addi	sp,sp,-32
    800033f0:	ec06                	sd	ra,24(sp)
    800033f2:	e822                	sd	s0,16(sp)
    800033f4:	e426                	sd	s1,8(sp)
    800033f6:	1000                	addi	s0,sp,32
    800033f8:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800033fa:	0001c517          	auipc	a0,0x1c
    800033fe:	af650513          	addi	a0,a0,-1290 # 8001eef0 <icache>
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	6d0080e7          	jalr	1744(ra) # 80000ad2 <acquire>
  ip->ref++;
    8000340a:	449c                	lw	a5,8(s1)
    8000340c:	2785                	addiw	a5,a5,1
    8000340e:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003410:	0001c517          	auipc	a0,0x1c
    80003414:	ae050513          	addi	a0,a0,-1312 # 8001eef0 <icache>
    80003418:	ffffd097          	auipc	ra,0xffffd
    8000341c:	70e080e7          	jalr	1806(ra) # 80000b26 <release>
}
    80003420:	8526                	mv	a0,s1
    80003422:	60e2                	ld	ra,24(sp)
    80003424:	6442                	ld	s0,16(sp)
    80003426:	64a2                	ld	s1,8(sp)
    80003428:	6105                	addi	sp,sp,32
    8000342a:	8082                	ret

000000008000342c <ilock>:
{
    8000342c:	1101                	addi	sp,sp,-32
    8000342e:	ec06                	sd	ra,24(sp)
    80003430:	e822                	sd	s0,16(sp)
    80003432:	e426                	sd	s1,8(sp)
    80003434:	e04a                	sd	s2,0(sp)
    80003436:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003438:	c115                	beqz	a0,8000345c <ilock+0x30>
    8000343a:	84aa                	mv	s1,a0
    8000343c:	451c                	lw	a5,8(a0)
    8000343e:	00f05f63          	blez	a5,8000345c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003442:	0541                	addi	a0,a0,16
    80003444:	00001097          	auipc	ra,0x1
    80003448:	c7c080e7          	jalr	-900(ra) # 800040c0 <acquiresleep>
  if(ip->valid == 0){
    8000344c:	40bc                	lw	a5,64(s1)
    8000344e:	cf99                	beqz	a5,8000346c <ilock+0x40>
}
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	64a2                	ld	s1,8(sp)
    80003456:	6902                	ld	s2,0(sp)
    80003458:	6105                	addi	sp,sp,32
    8000345a:	8082                	ret
    panic("ilock");
    8000345c:	00003517          	auipc	a0,0x3
    80003460:	13c50513          	addi	a0,a0,316 # 80006598 <userret+0x508>
    80003464:	ffffd097          	auipc	ra,0xffffd
    80003468:	0ea080e7          	jalr	234(ra) # 8000054e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000346c:	40dc                	lw	a5,4(s1)
    8000346e:	0047d79b          	srliw	a5,a5,0x4
    80003472:	0001c597          	auipc	a1,0x1c
    80003476:	a765a583          	lw	a1,-1418(a1) # 8001eee8 <sb+0x18>
    8000347a:	9dbd                	addw	a1,a1,a5
    8000347c:	4088                	lw	a0,0(s1)
    8000347e:	fffff097          	auipc	ra,0xfffff
    80003482:	7ac080e7          	jalr	1964(ra) # 80002c2a <bread>
    80003486:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003488:	06050593          	addi	a1,a0,96
    8000348c:	40dc                	lw	a5,4(s1)
    8000348e:	8bbd                	andi	a5,a5,15
    80003490:	079a                	slli	a5,a5,0x6
    80003492:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003494:	00059783          	lh	a5,0(a1)
    80003498:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000349c:	00259783          	lh	a5,2(a1)
    800034a0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800034a4:	00459783          	lh	a5,4(a1)
    800034a8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800034ac:	00659783          	lh	a5,6(a1)
    800034b0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800034b4:	459c                	lw	a5,8(a1)
    800034b6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800034b8:	03400613          	li	a2,52
    800034bc:	05b1                	addi	a1,a1,12
    800034be:	05048513          	addi	a0,s1,80
    800034c2:	ffffd097          	auipc	ra,0xffffd
    800034c6:	70c080e7          	jalr	1804(ra) # 80000bce <memmove>
    brelse(bp);
    800034ca:	854a                	mv	a0,s2
    800034cc:	00000097          	auipc	ra,0x0
    800034d0:	88e080e7          	jalr	-1906(ra) # 80002d5a <brelse>
    ip->valid = 1;
    800034d4:	4785                	li	a5,1
    800034d6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800034d8:	04449783          	lh	a5,68(s1)
    800034dc:	fbb5                	bnez	a5,80003450 <ilock+0x24>
      panic("ilock: no type");
    800034de:	00003517          	auipc	a0,0x3
    800034e2:	0c250513          	addi	a0,a0,194 # 800065a0 <userret+0x510>
    800034e6:	ffffd097          	auipc	ra,0xffffd
    800034ea:	068080e7          	jalr	104(ra) # 8000054e <panic>

00000000800034ee <iunlock>:
{
    800034ee:	1101                	addi	sp,sp,-32
    800034f0:	ec06                	sd	ra,24(sp)
    800034f2:	e822                	sd	s0,16(sp)
    800034f4:	e426                	sd	s1,8(sp)
    800034f6:	e04a                	sd	s2,0(sp)
    800034f8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800034fa:	c905                	beqz	a0,8000352a <iunlock+0x3c>
    800034fc:	84aa                	mv	s1,a0
    800034fe:	01050913          	addi	s2,a0,16
    80003502:	854a                	mv	a0,s2
    80003504:	00001097          	auipc	ra,0x1
    80003508:	c56080e7          	jalr	-938(ra) # 8000415a <holdingsleep>
    8000350c:	cd19                	beqz	a0,8000352a <iunlock+0x3c>
    8000350e:	449c                	lw	a5,8(s1)
    80003510:	00f05d63          	blez	a5,8000352a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003514:	854a                	mv	a0,s2
    80003516:	00001097          	auipc	ra,0x1
    8000351a:	c00080e7          	jalr	-1024(ra) # 80004116 <releasesleep>
}
    8000351e:	60e2                	ld	ra,24(sp)
    80003520:	6442                	ld	s0,16(sp)
    80003522:	64a2                	ld	s1,8(sp)
    80003524:	6902                	ld	s2,0(sp)
    80003526:	6105                	addi	sp,sp,32
    80003528:	8082                	ret
    panic("iunlock");
    8000352a:	00003517          	auipc	a0,0x3
    8000352e:	08650513          	addi	a0,a0,134 # 800065b0 <userret+0x520>
    80003532:	ffffd097          	auipc	ra,0xffffd
    80003536:	01c080e7          	jalr	28(ra) # 8000054e <panic>

000000008000353a <iput>:
{
    8000353a:	7139                	addi	sp,sp,-64
    8000353c:	fc06                	sd	ra,56(sp)
    8000353e:	f822                	sd	s0,48(sp)
    80003540:	f426                	sd	s1,40(sp)
    80003542:	f04a                	sd	s2,32(sp)
    80003544:	ec4e                	sd	s3,24(sp)
    80003546:	e852                	sd	s4,16(sp)
    80003548:	e456                	sd	s5,8(sp)
    8000354a:	0080                	addi	s0,sp,64
    8000354c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000354e:	0001c517          	auipc	a0,0x1c
    80003552:	9a250513          	addi	a0,a0,-1630 # 8001eef0 <icache>
    80003556:	ffffd097          	auipc	ra,0xffffd
    8000355a:	57c080e7          	jalr	1404(ra) # 80000ad2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000355e:	4498                	lw	a4,8(s1)
    80003560:	4785                	li	a5,1
    80003562:	02f70663          	beq	a4,a5,8000358e <iput+0x54>
  ip->ref--;
    80003566:	449c                	lw	a5,8(s1)
    80003568:	37fd                	addiw	a5,a5,-1
    8000356a:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    8000356c:	0001c517          	auipc	a0,0x1c
    80003570:	98450513          	addi	a0,a0,-1660 # 8001eef0 <icache>
    80003574:	ffffd097          	auipc	ra,0xffffd
    80003578:	5b2080e7          	jalr	1458(ra) # 80000b26 <release>
}
    8000357c:	70e2                	ld	ra,56(sp)
    8000357e:	7442                	ld	s0,48(sp)
    80003580:	74a2                	ld	s1,40(sp)
    80003582:	7902                	ld	s2,32(sp)
    80003584:	69e2                	ld	s3,24(sp)
    80003586:	6a42                	ld	s4,16(sp)
    80003588:	6aa2                	ld	s5,8(sp)
    8000358a:	6121                	addi	sp,sp,64
    8000358c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000358e:	40bc                	lw	a5,64(s1)
    80003590:	dbf9                	beqz	a5,80003566 <iput+0x2c>
    80003592:	04a49783          	lh	a5,74(s1)
    80003596:	fbe1                	bnez	a5,80003566 <iput+0x2c>
    acquiresleep(&ip->lock);
    80003598:	01048a13          	addi	s4,s1,16
    8000359c:	8552                	mv	a0,s4
    8000359e:	00001097          	auipc	ra,0x1
    800035a2:	b22080e7          	jalr	-1246(ra) # 800040c0 <acquiresleep>
    release(&icache.lock);
    800035a6:	0001c517          	auipc	a0,0x1c
    800035aa:	94a50513          	addi	a0,a0,-1718 # 8001eef0 <icache>
    800035ae:	ffffd097          	auipc	ra,0xffffd
    800035b2:	578080e7          	jalr	1400(ra) # 80000b26 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800035b6:	05048913          	addi	s2,s1,80
    800035ba:	08048993          	addi	s3,s1,128
    800035be:	a819                	j	800035d4 <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    800035c0:	4088                	lw	a0,0(s1)
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	8ae080e7          	jalr	-1874(ra) # 80002e70 <bfree>
      ip->addrs[i] = 0;
    800035ca:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    800035ce:	0911                	addi	s2,s2,4
    800035d0:	01390663          	beq	s2,s3,800035dc <iput+0xa2>
    if(ip->addrs[i]){
    800035d4:	00092583          	lw	a1,0(s2)
    800035d8:	d9fd                	beqz	a1,800035ce <iput+0x94>
    800035da:	b7dd                	j	800035c0 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    800035dc:	0804a583          	lw	a1,128(s1)
    800035e0:	ed9d                	bnez	a1,8000361e <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800035e2:	0404a623          	sw	zero,76(s1)
  iupdate(ip);
    800035e6:	8526                	mv	a0,s1
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	d7a080e7          	jalr	-646(ra) # 80003362 <iupdate>
    ip->type = 0;
    800035f0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800035f4:	8526                	mv	a0,s1
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	d6c080e7          	jalr	-660(ra) # 80003362 <iupdate>
    ip->valid = 0;
    800035fe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003602:	8552                	mv	a0,s4
    80003604:	00001097          	auipc	ra,0x1
    80003608:	b12080e7          	jalr	-1262(ra) # 80004116 <releasesleep>
    acquire(&icache.lock);
    8000360c:	0001c517          	auipc	a0,0x1c
    80003610:	8e450513          	addi	a0,a0,-1820 # 8001eef0 <icache>
    80003614:	ffffd097          	auipc	ra,0xffffd
    80003618:	4be080e7          	jalr	1214(ra) # 80000ad2 <acquire>
    8000361c:	b7a9                	j	80003566 <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000361e:	4088                	lw	a0,0(s1)
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	60a080e7          	jalr	1546(ra) # 80002c2a <bread>
    80003628:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    8000362a:	06050913          	addi	s2,a0,96
    8000362e:	46050993          	addi	s3,a0,1120
    80003632:	a809                	j	80003644 <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003634:	4088                	lw	a0,0(s1)
    80003636:	00000097          	auipc	ra,0x0
    8000363a:	83a080e7          	jalr	-1990(ra) # 80002e70 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000363e:	0911                	addi	s2,s2,4
    80003640:	01390663          	beq	s2,s3,8000364c <iput+0x112>
      if(a[j])
    80003644:	00092583          	lw	a1,0(s2)
    80003648:	d9fd                	beqz	a1,8000363e <iput+0x104>
    8000364a:	b7ed                	j	80003634 <iput+0xfa>
    brelse(bp);
    8000364c:	8556                	mv	a0,s5
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	70c080e7          	jalr	1804(ra) # 80002d5a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003656:	0804a583          	lw	a1,128(s1)
    8000365a:	4088                	lw	a0,0(s1)
    8000365c:	00000097          	auipc	ra,0x0
    80003660:	814080e7          	jalr	-2028(ra) # 80002e70 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003664:	0804a023          	sw	zero,128(s1)
    80003668:	bfad                	j	800035e2 <iput+0xa8>

000000008000366a <iunlockput>:
{
    8000366a:	1101                	addi	sp,sp,-32
    8000366c:	ec06                	sd	ra,24(sp)
    8000366e:	e822                	sd	s0,16(sp)
    80003670:	e426                	sd	s1,8(sp)
    80003672:	1000                	addi	s0,sp,32
    80003674:	84aa                	mv	s1,a0
  iunlock(ip);
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	e78080e7          	jalr	-392(ra) # 800034ee <iunlock>
  iput(ip);
    8000367e:	8526                	mv	a0,s1
    80003680:	00000097          	auipc	ra,0x0
    80003684:	eba080e7          	jalr	-326(ra) # 8000353a <iput>
}
    80003688:	60e2                	ld	ra,24(sp)
    8000368a:	6442                	ld	s0,16(sp)
    8000368c:	64a2                	ld	s1,8(sp)
    8000368e:	6105                	addi	sp,sp,32
    80003690:	8082                	ret

0000000080003692 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003692:	1141                	addi	sp,sp,-16
    80003694:	e422                	sd	s0,8(sp)
    80003696:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003698:	411c                	lw	a5,0(a0)
    8000369a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000369c:	415c                	lw	a5,4(a0)
    8000369e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800036a0:	04451783          	lh	a5,68(a0)
    800036a4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800036a8:	04a51783          	lh	a5,74(a0)
    800036ac:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800036b0:	04c56783          	lwu	a5,76(a0)
    800036b4:	e99c                	sd	a5,16(a1)
}
    800036b6:	6422                	ld	s0,8(sp)
    800036b8:	0141                	addi	sp,sp,16
    800036ba:	8082                	ret

00000000800036bc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800036bc:	457c                	lw	a5,76(a0)
    800036be:	0ed7e563          	bltu	a5,a3,800037a8 <readi+0xec>
{
    800036c2:	7159                	addi	sp,sp,-112
    800036c4:	f486                	sd	ra,104(sp)
    800036c6:	f0a2                	sd	s0,96(sp)
    800036c8:	eca6                	sd	s1,88(sp)
    800036ca:	e8ca                	sd	s2,80(sp)
    800036cc:	e4ce                	sd	s3,72(sp)
    800036ce:	e0d2                	sd	s4,64(sp)
    800036d0:	fc56                	sd	s5,56(sp)
    800036d2:	f85a                	sd	s6,48(sp)
    800036d4:	f45e                	sd	s7,40(sp)
    800036d6:	f062                	sd	s8,32(sp)
    800036d8:	ec66                	sd	s9,24(sp)
    800036da:	e86a                	sd	s10,16(sp)
    800036dc:	e46e                	sd	s11,8(sp)
    800036de:	1880                	addi	s0,sp,112
    800036e0:	8baa                	mv	s7,a0
    800036e2:	8c2e                	mv	s8,a1
    800036e4:	8ab2                	mv	s5,a2
    800036e6:	8936                	mv	s2,a3
    800036e8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800036ea:	9f35                	addw	a4,a4,a3
    800036ec:	0cd76063          	bltu	a4,a3,800037ac <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    800036f0:	00e7f463          	bgeu	a5,a4,800036f8 <readi+0x3c>
    n = ip->size - off;
    800036f4:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800036f8:	080b0763          	beqz	s6,80003786 <readi+0xca>
    800036fc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800036fe:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003702:	5cfd                	li	s9,-1
    80003704:	a82d                	j	8000373e <readi+0x82>
    80003706:	02099d93          	slli	s11,s3,0x20
    8000370a:	020ddd93          	srli	s11,s11,0x20
    8000370e:	06048613          	addi	a2,s1,96
    80003712:	86ee                	mv	a3,s11
    80003714:	963a                	add	a2,a2,a4
    80003716:	85d6                	mv	a1,s5
    80003718:	8562                	mv	a0,s8
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	b2e080e7          	jalr	-1234(ra) # 80002248 <either_copyout>
    80003722:	05950d63          	beq	a0,s9,8000377c <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003726:	8526                	mv	a0,s1
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	632080e7          	jalr	1586(ra) # 80002d5a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003730:	01498a3b          	addw	s4,s3,s4
    80003734:	0129893b          	addw	s2,s3,s2
    80003738:	9aee                	add	s5,s5,s11
    8000373a:	056a7663          	bgeu	s4,s6,80003786 <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000373e:	000ba483          	lw	s1,0(s7)
    80003742:	00a9559b          	srliw	a1,s2,0xa
    80003746:	855e                	mv	a0,s7
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	8d6080e7          	jalr	-1834(ra) # 8000301e <bmap>
    80003750:	0005059b          	sext.w	a1,a0
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	4d4080e7          	jalr	1236(ra) # 80002c2a <bread>
    8000375e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003760:	3ff97713          	andi	a4,s2,1023
    80003764:	40ed07bb          	subw	a5,s10,a4
    80003768:	414b06bb          	subw	a3,s6,s4
    8000376c:	89be                	mv	s3,a5
    8000376e:	2781                	sext.w	a5,a5
    80003770:	0006861b          	sext.w	a2,a3
    80003774:	f8f679e3          	bgeu	a2,a5,80003706 <readi+0x4a>
    80003778:	89b6                	mv	s3,a3
    8000377a:	b771                	j	80003706 <readi+0x4a>
      brelse(bp);
    8000377c:	8526                	mv	a0,s1
    8000377e:	fffff097          	auipc	ra,0xfffff
    80003782:	5dc080e7          	jalr	1500(ra) # 80002d5a <brelse>
  }
  return n;
    80003786:	000b051b          	sext.w	a0,s6
}
    8000378a:	70a6                	ld	ra,104(sp)
    8000378c:	7406                	ld	s0,96(sp)
    8000378e:	64e6                	ld	s1,88(sp)
    80003790:	6946                	ld	s2,80(sp)
    80003792:	69a6                	ld	s3,72(sp)
    80003794:	6a06                	ld	s4,64(sp)
    80003796:	7ae2                	ld	s5,56(sp)
    80003798:	7b42                	ld	s6,48(sp)
    8000379a:	7ba2                	ld	s7,40(sp)
    8000379c:	7c02                	ld	s8,32(sp)
    8000379e:	6ce2                	ld	s9,24(sp)
    800037a0:	6d42                	ld	s10,16(sp)
    800037a2:	6da2                	ld	s11,8(sp)
    800037a4:	6165                	addi	sp,sp,112
    800037a6:	8082                	ret
    return -1;
    800037a8:	557d                	li	a0,-1
}
    800037aa:	8082                	ret
    return -1;
    800037ac:	557d                	li	a0,-1
    800037ae:	bff1                	j	8000378a <readi+0xce>

00000000800037b0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037b0:	457c                	lw	a5,76(a0)
    800037b2:	10d7e663          	bltu	a5,a3,800038be <writei+0x10e>
{
    800037b6:	7159                	addi	sp,sp,-112
    800037b8:	f486                	sd	ra,104(sp)
    800037ba:	f0a2                	sd	s0,96(sp)
    800037bc:	eca6                	sd	s1,88(sp)
    800037be:	e8ca                	sd	s2,80(sp)
    800037c0:	e4ce                	sd	s3,72(sp)
    800037c2:	e0d2                	sd	s4,64(sp)
    800037c4:	fc56                	sd	s5,56(sp)
    800037c6:	f85a                	sd	s6,48(sp)
    800037c8:	f45e                	sd	s7,40(sp)
    800037ca:	f062                	sd	s8,32(sp)
    800037cc:	ec66                	sd	s9,24(sp)
    800037ce:	e86a                	sd	s10,16(sp)
    800037d0:	e46e                	sd	s11,8(sp)
    800037d2:	1880                	addi	s0,sp,112
    800037d4:	8baa                	mv	s7,a0
    800037d6:	8c2e                	mv	s8,a1
    800037d8:	8ab2                	mv	s5,a2
    800037da:	8936                	mv	s2,a3
    800037dc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800037de:	00e687bb          	addw	a5,a3,a4
    800037e2:	0ed7e063          	bltu	a5,a3,800038c2 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800037e6:	00043737          	lui	a4,0x43
    800037ea:	0cf76e63          	bltu	a4,a5,800038c6 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800037ee:	0a0b0763          	beqz	s6,8000389c <writei+0xec>
    800037f2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800037f4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037f8:	5cfd                	li	s9,-1
    800037fa:	a091                	j	8000383e <writei+0x8e>
    800037fc:	02099d93          	slli	s11,s3,0x20
    80003800:	020ddd93          	srli	s11,s11,0x20
    80003804:	06048513          	addi	a0,s1,96
    80003808:	86ee                	mv	a3,s11
    8000380a:	8656                	mv	a2,s5
    8000380c:	85e2                	mv	a1,s8
    8000380e:	953a                	add	a0,a0,a4
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	a8e080e7          	jalr	-1394(ra) # 8000229e <either_copyin>
    80003818:	07950263          	beq	a0,s9,8000387c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000381c:	8526                	mv	a0,s1
    8000381e:	00000097          	auipc	ra,0x0
    80003822:	77a080e7          	jalr	1914(ra) # 80003f98 <log_write>
    brelse(bp);
    80003826:	8526                	mv	a0,s1
    80003828:	fffff097          	auipc	ra,0xfffff
    8000382c:	532080e7          	jalr	1330(ra) # 80002d5a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003830:	01498a3b          	addw	s4,s3,s4
    80003834:	0129893b          	addw	s2,s3,s2
    80003838:	9aee                	add	s5,s5,s11
    8000383a:	056a7663          	bgeu	s4,s6,80003886 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000383e:	000ba483          	lw	s1,0(s7)
    80003842:	00a9559b          	srliw	a1,s2,0xa
    80003846:	855e                	mv	a0,s7
    80003848:	fffff097          	auipc	ra,0xfffff
    8000384c:	7d6080e7          	jalr	2006(ra) # 8000301e <bmap>
    80003850:	0005059b          	sext.w	a1,a0
    80003854:	8526                	mv	a0,s1
    80003856:	fffff097          	auipc	ra,0xfffff
    8000385a:	3d4080e7          	jalr	980(ra) # 80002c2a <bread>
    8000385e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003860:	3ff97713          	andi	a4,s2,1023
    80003864:	40ed07bb          	subw	a5,s10,a4
    80003868:	414b06bb          	subw	a3,s6,s4
    8000386c:	89be                	mv	s3,a5
    8000386e:	2781                	sext.w	a5,a5
    80003870:	0006861b          	sext.w	a2,a3
    80003874:	f8f674e3          	bgeu	a2,a5,800037fc <writei+0x4c>
    80003878:	89b6                	mv	s3,a3
    8000387a:	b749                	j	800037fc <writei+0x4c>
      brelse(bp);
    8000387c:	8526                	mv	a0,s1
    8000387e:	fffff097          	auipc	ra,0xfffff
    80003882:	4dc080e7          	jalr	1244(ra) # 80002d5a <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003886:	04cba783          	lw	a5,76(s7)
    8000388a:	0127f463          	bgeu	a5,s2,80003892 <writei+0xe2>
      ip->size = off;
    8000388e:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003892:	855e                	mv	a0,s7
    80003894:	00000097          	auipc	ra,0x0
    80003898:	ace080e7          	jalr	-1330(ra) # 80003362 <iupdate>
  }

  return n;
    8000389c:	000b051b          	sext.w	a0,s6
}
    800038a0:	70a6                	ld	ra,104(sp)
    800038a2:	7406                	ld	s0,96(sp)
    800038a4:	64e6                	ld	s1,88(sp)
    800038a6:	6946                	ld	s2,80(sp)
    800038a8:	69a6                	ld	s3,72(sp)
    800038aa:	6a06                	ld	s4,64(sp)
    800038ac:	7ae2                	ld	s5,56(sp)
    800038ae:	7b42                	ld	s6,48(sp)
    800038b0:	7ba2                	ld	s7,40(sp)
    800038b2:	7c02                	ld	s8,32(sp)
    800038b4:	6ce2                	ld	s9,24(sp)
    800038b6:	6d42                	ld	s10,16(sp)
    800038b8:	6da2                	ld	s11,8(sp)
    800038ba:	6165                	addi	sp,sp,112
    800038bc:	8082                	ret
    return -1;
    800038be:	557d                	li	a0,-1
}
    800038c0:	8082                	ret
    return -1;
    800038c2:	557d                	li	a0,-1
    800038c4:	bff1                	j	800038a0 <writei+0xf0>
    return -1;
    800038c6:	557d                	li	a0,-1
    800038c8:	bfe1                	j	800038a0 <writei+0xf0>

00000000800038ca <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800038ca:	1141                	addi	sp,sp,-16
    800038cc:	e406                	sd	ra,8(sp)
    800038ce:	e022                	sd	s0,0(sp)
    800038d0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800038d2:	4639                	li	a2,14
    800038d4:	ffffd097          	auipc	ra,0xffffd
    800038d8:	376080e7          	jalr	886(ra) # 80000c4a <strncmp>
}
    800038dc:	60a2                	ld	ra,8(sp)
    800038de:	6402                	ld	s0,0(sp)
    800038e0:	0141                	addi	sp,sp,16
    800038e2:	8082                	ret

00000000800038e4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800038e4:	7139                	addi	sp,sp,-64
    800038e6:	fc06                	sd	ra,56(sp)
    800038e8:	f822                	sd	s0,48(sp)
    800038ea:	f426                	sd	s1,40(sp)
    800038ec:	f04a                	sd	s2,32(sp)
    800038ee:	ec4e                	sd	s3,24(sp)
    800038f0:	e852                	sd	s4,16(sp)
    800038f2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800038f4:	04451703          	lh	a4,68(a0)
    800038f8:	4785                	li	a5,1
    800038fa:	00f71a63          	bne	a4,a5,8000390e <dirlookup+0x2a>
    800038fe:	892a                	mv	s2,a0
    80003900:	89ae                	mv	s3,a1
    80003902:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003904:	457c                	lw	a5,76(a0)
    80003906:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003908:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000390a:	e79d                	bnez	a5,80003938 <dirlookup+0x54>
    8000390c:	a8a5                	j	80003984 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000390e:	00003517          	auipc	a0,0x3
    80003912:	caa50513          	addi	a0,a0,-854 # 800065b8 <userret+0x528>
    80003916:	ffffd097          	auipc	ra,0xffffd
    8000391a:	c38080e7          	jalr	-968(ra) # 8000054e <panic>
      panic("dirlookup read");
    8000391e:	00003517          	auipc	a0,0x3
    80003922:	cb250513          	addi	a0,a0,-846 # 800065d0 <userret+0x540>
    80003926:	ffffd097          	auipc	ra,0xffffd
    8000392a:	c28080e7          	jalr	-984(ra) # 8000054e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000392e:	24c1                	addiw	s1,s1,16
    80003930:	04c92783          	lw	a5,76(s2)
    80003934:	04f4f763          	bgeu	s1,a5,80003982 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003938:	4741                	li	a4,16
    8000393a:	86a6                	mv	a3,s1
    8000393c:	fc040613          	addi	a2,s0,-64
    80003940:	4581                	li	a1,0
    80003942:	854a                	mv	a0,s2
    80003944:	00000097          	auipc	ra,0x0
    80003948:	d78080e7          	jalr	-648(ra) # 800036bc <readi>
    8000394c:	47c1                	li	a5,16
    8000394e:	fcf518e3          	bne	a0,a5,8000391e <dirlookup+0x3a>
    if(de.inum == 0)
    80003952:	fc045783          	lhu	a5,-64(s0)
    80003956:	dfe1                	beqz	a5,8000392e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003958:	fc240593          	addi	a1,s0,-62
    8000395c:	854e                	mv	a0,s3
    8000395e:	00000097          	auipc	ra,0x0
    80003962:	f6c080e7          	jalr	-148(ra) # 800038ca <namecmp>
    80003966:	f561                	bnez	a0,8000392e <dirlookup+0x4a>
      if(poff)
    80003968:	000a0463          	beqz	s4,80003970 <dirlookup+0x8c>
        *poff = off;
    8000396c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003970:	fc045583          	lhu	a1,-64(s0)
    80003974:	00092503          	lw	a0,0(s2)
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	780080e7          	jalr	1920(ra) # 800030f8 <iget>
    80003980:	a011                	j	80003984 <dirlookup+0xa0>
  return 0;
    80003982:	4501                	li	a0,0
}
    80003984:	70e2                	ld	ra,56(sp)
    80003986:	7442                	ld	s0,48(sp)
    80003988:	74a2                	ld	s1,40(sp)
    8000398a:	7902                	ld	s2,32(sp)
    8000398c:	69e2                	ld	s3,24(sp)
    8000398e:	6a42                	ld	s4,16(sp)
    80003990:	6121                	addi	sp,sp,64
    80003992:	8082                	ret

0000000080003994 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003994:	711d                	addi	sp,sp,-96
    80003996:	ec86                	sd	ra,88(sp)
    80003998:	e8a2                	sd	s0,80(sp)
    8000399a:	e4a6                	sd	s1,72(sp)
    8000399c:	e0ca                	sd	s2,64(sp)
    8000399e:	fc4e                	sd	s3,56(sp)
    800039a0:	f852                	sd	s4,48(sp)
    800039a2:	f456                	sd	s5,40(sp)
    800039a4:	f05a                	sd	s6,32(sp)
    800039a6:	ec5e                	sd	s7,24(sp)
    800039a8:	e862                	sd	s8,16(sp)
    800039aa:	e466                	sd	s9,8(sp)
    800039ac:	1080                	addi	s0,sp,96
    800039ae:	84aa                	mv	s1,a0
    800039b0:	8b2e                	mv	s6,a1
    800039b2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800039b4:	00054703          	lbu	a4,0(a0)
    800039b8:	02f00793          	li	a5,47
    800039bc:	02f70363          	beq	a4,a5,800039e2 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800039c0:	ffffe097          	auipc	ra,0xffffe
    800039c4:	e84080e7          	jalr	-380(ra) # 80001844 <myproc>
    800039c8:	15053503          	ld	a0,336(a0)
    800039cc:	00000097          	auipc	ra,0x0
    800039d0:	a22080e7          	jalr	-1502(ra) # 800033ee <idup>
    800039d4:	89aa                	mv	s3,a0
  while(*path == '/')
    800039d6:	02f00913          	li	s2,47
  len = path - s;
    800039da:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800039dc:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800039de:	4c05                	li	s8,1
    800039e0:	a865                	j	80003a98 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800039e2:	4585                	li	a1,1
    800039e4:	4505                	li	a0,1
    800039e6:	fffff097          	auipc	ra,0xfffff
    800039ea:	712080e7          	jalr	1810(ra) # 800030f8 <iget>
    800039ee:	89aa                	mv	s3,a0
    800039f0:	b7dd                	j	800039d6 <namex+0x42>
      iunlockput(ip);
    800039f2:	854e                	mv	a0,s3
    800039f4:	00000097          	auipc	ra,0x0
    800039f8:	c76080e7          	jalr	-906(ra) # 8000366a <iunlockput>
      return 0;
    800039fc:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800039fe:	854e                	mv	a0,s3
    80003a00:	60e6                	ld	ra,88(sp)
    80003a02:	6446                	ld	s0,80(sp)
    80003a04:	64a6                	ld	s1,72(sp)
    80003a06:	6906                	ld	s2,64(sp)
    80003a08:	79e2                	ld	s3,56(sp)
    80003a0a:	7a42                	ld	s4,48(sp)
    80003a0c:	7aa2                	ld	s5,40(sp)
    80003a0e:	7b02                	ld	s6,32(sp)
    80003a10:	6be2                	ld	s7,24(sp)
    80003a12:	6c42                	ld	s8,16(sp)
    80003a14:	6ca2                	ld	s9,8(sp)
    80003a16:	6125                	addi	sp,sp,96
    80003a18:	8082                	ret
      iunlock(ip);
    80003a1a:	854e                	mv	a0,s3
    80003a1c:	00000097          	auipc	ra,0x0
    80003a20:	ad2080e7          	jalr	-1326(ra) # 800034ee <iunlock>
      return ip;
    80003a24:	bfe9                	j	800039fe <namex+0x6a>
      iunlockput(ip);
    80003a26:	854e                	mv	a0,s3
    80003a28:	00000097          	auipc	ra,0x0
    80003a2c:	c42080e7          	jalr	-958(ra) # 8000366a <iunlockput>
      return 0;
    80003a30:	89d2                	mv	s3,s4
    80003a32:	b7f1                	j	800039fe <namex+0x6a>
  len = path - s;
    80003a34:	40b48633          	sub	a2,s1,a1
    80003a38:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003a3c:	094cd463          	bge	s9,s4,80003ac4 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003a40:	4639                	li	a2,14
    80003a42:	8556                	mv	a0,s5
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	18a080e7          	jalr	394(ra) # 80000bce <memmove>
  while(*path == '/')
    80003a4c:	0004c783          	lbu	a5,0(s1)
    80003a50:	01279763          	bne	a5,s2,80003a5e <namex+0xca>
    path++;
    80003a54:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a56:	0004c783          	lbu	a5,0(s1)
    80003a5a:	ff278de3          	beq	a5,s2,80003a54 <namex+0xc0>
    ilock(ip);
    80003a5e:	854e                	mv	a0,s3
    80003a60:	00000097          	auipc	ra,0x0
    80003a64:	9cc080e7          	jalr	-1588(ra) # 8000342c <ilock>
    if(ip->type != T_DIR){
    80003a68:	04499783          	lh	a5,68(s3)
    80003a6c:	f98793e3          	bne	a5,s8,800039f2 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003a70:	000b0563          	beqz	s6,80003a7a <namex+0xe6>
    80003a74:	0004c783          	lbu	a5,0(s1)
    80003a78:	d3cd                	beqz	a5,80003a1a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003a7a:	865e                	mv	a2,s7
    80003a7c:	85d6                	mv	a1,s5
    80003a7e:	854e                	mv	a0,s3
    80003a80:	00000097          	auipc	ra,0x0
    80003a84:	e64080e7          	jalr	-412(ra) # 800038e4 <dirlookup>
    80003a88:	8a2a                	mv	s4,a0
    80003a8a:	dd51                	beqz	a0,80003a26 <namex+0x92>
    iunlockput(ip);
    80003a8c:	854e                	mv	a0,s3
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	bdc080e7          	jalr	-1060(ra) # 8000366a <iunlockput>
    ip = next;
    80003a96:	89d2                	mv	s3,s4
  while(*path == '/')
    80003a98:	0004c783          	lbu	a5,0(s1)
    80003a9c:	05279763          	bne	a5,s2,80003aea <namex+0x156>
    path++;
    80003aa0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003aa2:	0004c783          	lbu	a5,0(s1)
    80003aa6:	ff278de3          	beq	a5,s2,80003aa0 <namex+0x10c>
  if(*path == 0)
    80003aaa:	c79d                	beqz	a5,80003ad8 <namex+0x144>
    path++;
    80003aac:	85a6                	mv	a1,s1
  len = path - s;
    80003aae:	8a5e                	mv	s4,s7
    80003ab0:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003ab2:	01278963          	beq	a5,s2,80003ac4 <namex+0x130>
    80003ab6:	dfbd                	beqz	a5,80003a34 <namex+0xa0>
    path++;
    80003ab8:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003aba:	0004c783          	lbu	a5,0(s1)
    80003abe:	ff279ce3          	bne	a5,s2,80003ab6 <namex+0x122>
    80003ac2:	bf8d                	j	80003a34 <namex+0xa0>
    memmove(name, s, len);
    80003ac4:	2601                	sext.w	a2,a2
    80003ac6:	8556                	mv	a0,s5
    80003ac8:	ffffd097          	auipc	ra,0xffffd
    80003acc:	106080e7          	jalr	262(ra) # 80000bce <memmove>
    name[len] = 0;
    80003ad0:	9a56                	add	s4,s4,s5
    80003ad2:	000a0023          	sb	zero,0(s4)
    80003ad6:	bf9d                	j	80003a4c <namex+0xb8>
  if(nameiparent){
    80003ad8:	f20b03e3          	beqz	s6,800039fe <namex+0x6a>
    iput(ip);
    80003adc:	854e                	mv	a0,s3
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	a5c080e7          	jalr	-1444(ra) # 8000353a <iput>
    return 0;
    80003ae6:	4981                	li	s3,0
    80003ae8:	bf19                	j	800039fe <namex+0x6a>
  if(*path == 0)
    80003aea:	d7fd                	beqz	a5,80003ad8 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003aec:	0004c783          	lbu	a5,0(s1)
    80003af0:	85a6                	mv	a1,s1
    80003af2:	b7d1                	j	80003ab6 <namex+0x122>

0000000080003af4 <dirlink>:
{
    80003af4:	7139                	addi	sp,sp,-64
    80003af6:	fc06                	sd	ra,56(sp)
    80003af8:	f822                	sd	s0,48(sp)
    80003afa:	f426                	sd	s1,40(sp)
    80003afc:	f04a                	sd	s2,32(sp)
    80003afe:	ec4e                	sd	s3,24(sp)
    80003b00:	e852                	sd	s4,16(sp)
    80003b02:	0080                	addi	s0,sp,64
    80003b04:	892a                	mv	s2,a0
    80003b06:	8a2e                	mv	s4,a1
    80003b08:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003b0a:	4601                	li	a2,0
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	dd8080e7          	jalr	-552(ra) # 800038e4 <dirlookup>
    80003b14:	e93d                	bnez	a0,80003b8a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b16:	04c92483          	lw	s1,76(s2)
    80003b1a:	c49d                	beqz	s1,80003b48 <dirlink+0x54>
    80003b1c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b1e:	4741                	li	a4,16
    80003b20:	86a6                	mv	a3,s1
    80003b22:	fc040613          	addi	a2,s0,-64
    80003b26:	4581                	li	a1,0
    80003b28:	854a                	mv	a0,s2
    80003b2a:	00000097          	auipc	ra,0x0
    80003b2e:	b92080e7          	jalr	-1134(ra) # 800036bc <readi>
    80003b32:	47c1                	li	a5,16
    80003b34:	06f51163          	bne	a0,a5,80003b96 <dirlink+0xa2>
    if(de.inum == 0)
    80003b38:	fc045783          	lhu	a5,-64(s0)
    80003b3c:	c791                	beqz	a5,80003b48 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b3e:	24c1                	addiw	s1,s1,16
    80003b40:	04c92783          	lw	a5,76(s2)
    80003b44:	fcf4ede3          	bltu	s1,a5,80003b1e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003b48:	4639                	li	a2,14
    80003b4a:	85d2                	mv	a1,s4
    80003b4c:	fc240513          	addi	a0,s0,-62
    80003b50:	ffffd097          	auipc	ra,0xffffd
    80003b54:	136080e7          	jalr	310(ra) # 80000c86 <strncpy>
  de.inum = inum;
    80003b58:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b5c:	4741                	li	a4,16
    80003b5e:	86a6                	mv	a3,s1
    80003b60:	fc040613          	addi	a2,s0,-64
    80003b64:	4581                	li	a1,0
    80003b66:	854a                	mv	a0,s2
    80003b68:	00000097          	auipc	ra,0x0
    80003b6c:	c48080e7          	jalr	-952(ra) # 800037b0 <writei>
    80003b70:	872a                	mv	a4,a0
    80003b72:	47c1                	li	a5,16
  return 0;
    80003b74:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b76:	02f71863          	bne	a4,a5,80003ba6 <dirlink+0xb2>
}
    80003b7a:	70e2                	ld	ra,56(sp)
    80003b7c:	7442                	ld	s0,48(sp)
    80003b7e:	74a2                	ld	s1,40(sp)
    80003b80:	7902                	ld	s2,32(sp)
    80003b82:	69e2                	ld	s3,24(sp)
    80003b84:	6a42                	ld	s4,16(sp)
    80003b86:	6121                	addi	sp,sp,64
    80003b88:	8082                	ret
    iput(ip);
    80003b8a:	00000097          	auipc	ra,0x0
    80003b8e:	9b0080e7          	jalr	-1616(ra) # 8000353a <iput>
    return -1;
    80003b92:	557d                	li	a0,-1
    80003b94:	b7dd                	j	80003b7a <dirlink+0x86>
      panic("dirlink read");
    80003b96:	00003517          	auipc	a0,0x3
    80003b9a:	a4a50513          	addi	a0,a0,-1462 # 800065e0 <userret+0x550>
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	9b0080e7          	jalr	-1616(ra) # 8000054e <panic>
    panic("dirlink");
    80003ba6:	00003517          	auipc	a0,0x3
    80003baa:	b5a50513          	addi	a0,a0,-1190 # 80006700 <userret+0x670>
    80003bae:	ffffd097          	auipc	ra,0xffffd
    80003bb2:	9a0080e7          	jalr	-1632(ra) # 8000054e <panic>

0000000080003bb6 <namei>:

struct inode*
namei(char *path)
{
    80003bb6:	1101                	addi	sp,sp,-32
    80003bb8:	ec06                	sd	ra,24(sp)
    80003bba:	e822                	sd	s0,16(sp)
    80003bbc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003bbe:	fe040613          	addi	a2,s0,-32
    80003bc2:	4581                	li	a1,0
    80003bc4:	00000097          	auipc	ra,0x0
    80003bc8:	dd0080e7          	jalr	-560(ra) # 80003994 <namex>
}
    80003bcc:	60e2                	ld	ra,24(sp)
    80003bce:	6442                	ld	s0,16(sp)
    80003bd0:	6105                	addi	sp,sp,32
    80003bd2:	8082                	ret

0000000080003bd4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003bd4:	1141                	addi	sp,sp,-16
    80003bd6:	e406                	sd	ra,8(sp)
    80003bd8:	e022                	sd	s0,0(sp)
    80003bda:	0800                	addi	s0,sp,16
    80003bdc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003bde:	4585                	li	a1,1
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	db4080e7          	jalr	-588(ra) # 80003994 <namex>
}
    80003be8:	60a2                	ld	ra,8(sp)
    80003bea:	6402                	ld	s0,0(sp)
    80003bec:	0141                	addi	sp,sp,16
    80003bee:	8082                	ret

0000000080003bf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003bf0:	1101                	addi	sp,sp,-32
    80003bf2:	ec06                	sd	ra,24(sp)
    80003bf4:	e822                	sd	s0,16(sp)
    80003bf6:	e426                	sd	s1,8(sp)
    80003bf8:	e04a                	sd	s2,0(sp)
    80003bfa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003bfc:	0001d917          	auipc	s2,0x1d
    80003c00:	d9c90913          	addi	s2,s2,-612 # 80020998 <log>
    80003c04:	01892583          	lw	a1,24(s2)
    80003c08:	02892503          	lw	a0,40(s2)
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	01e080e7          	jalr	30(ra) # 80002c2a <bread>
    80003c14:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003c16:	02c92683          	lw	a3,44(s2)
    80003c1a:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003c1c:	02d05763          	blez	a3,80003c4a <write_head+0x5a>
    80003c20:	0001d797          	auipc	a5,0x1d
    80003c24:	da878793          	addi	a5,a5,-600 # 800209c8 <log+0x30>
    80003c28:	06450713          	addi	a4,a0,100
    80003c2c:	36fd                	addiw	a3,a3,-1
    80003c2e:	1682                	slli	a3,a3,0x20
    80003c30:	9281                	srli	a3,a3,0x20
    80003c32:	068a                	slli	a3,a3,0x2
    80003c34:	0001d617          	auipc	a2,0x1d
    80003c38:	d9860613          	addi	a2,a2,-616 # 800209cc <log+0x34>
    80003c3c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003c3e:	4390                	lw	a2,0(a5)
    80003c40:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c42:	0791                	addi	a5,a5,4
    80003c44:	0711                	addi	a4,a4,4
    80003c46:	fed79ce3          	bne	a5,a3,80003c3e <write_head+0x4e>
  }
  bwrite(buf);
    80003c4a:	8526                	mv	a0,s1
    80003c4c:	fffff097          	auipc	ra,0xfffff
    80003c50:	0d0080e7          	jalr	208(ra) # 80002d1c <bwrite>
  brelse(buf);
    80003c54:	8526                	mv	a0,s1
    80003c56:	fffff097          	auipc	ra,0xfffff
    80003c5a:	104080e7          	jalr	260(ra) # 80002d5a <brelse>
}
    80003c5e:	60e2                	ld	ra,24(sp)
    80003c60:	6442                	ld	s0,16(sp)
    80003c62:	64a2                	ld	s1,8(sp)
    80003c64:	6902                	ld	s2,0(sp)
    80003c66:	6105                	addi	sp,sp,32
    80003c68:	8082                	ret

0000000080003c6a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c6a:	0001d797          	auipc	a5,0x1d
    80003c6e:	d5a7a783          	lw	a5,-678(a5) # 800209c4 <log+0x2c>
    80003c72:	0af05663          	blez	a5,80003d1e <install_trans+0xb4>
{
    80003c76:	7139                	addi	sp,sp,-64
    80003c78:	fc06                	sd	ra,56(sp)
    80003c7a:	f822                	sd	s0,48(sp)
    80003c7c:	f426                	sd	s1,40(sp)
    80003c7e:	f04a                	sd	s2,32(sp)
    80003c80:	ec4e                	sd	s3,24(sp)
    80003c82:	e852                	sd	s4,16(sp)
    80003c84:	e456                	sd	s5,8(sp)
    80003c86:	0080                	addi	s0,sp,64
    80003c88:	0001da97          	auipc	s5,0x1d
    80003c8c:	d40a8a93          	addi	s5,s5,-704 # 800209c8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c90:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c92:	0001d997          	auipc	s3,0x1d
    80003c96:	d0698993          	addi	s3,s3,-762 # 80020998 <log>
    80003c9a:	0189a583          	lw	a1,24(s3)
    80003c9e:	014585bb          	addw	a1,a1,s4
    80003ca2:	2585                	addiw	a1,a1,1
    80003ca4:	0289a503          	lw	a0,40(s3)
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	f82080e7          	jalr	-126(ra) # 80002c2a <bread>
    80003cb0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003cb2:	000aa583          	lw	a1,0(s5)
    80003cb6:	0289a503          	lw	a0,40(s3)
    80003cba:	fffff097          	auipc	ra,0xfffff
    80003cbe:	f70080e7          	jalr	-144(ra) # 80002c2a <bread>
    80003cc2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003cc4:	40000613          	li	a2,1024
    80003cc8:	06090593          	addi	a1,s2,96
    80003ccc:	06050513          	addi	a0,a0,96
    80003cd0:	ffffd097          	auipc	ra,0xffffd
    80003cd4:	efe080e7          	jalr	-258(ra) # 80000bce <memmove>
    bwrite(dbuf);  // write dst to disk
    80003cd8:	8526                	mv	a0,s1
    80003cda:	fffff097          	auipc	ra,0xfffff
    80003cde:	042080e7          	jalr	66(ra) # 80002d1c <bwrite>
    bunpin(dbuf);
    80003ce2:	8526                	mv	a0,s1
    80003ce4:	fffff097          	auipc	ra,0xfffff
    80003ce8:	150080e7          	jalr	336(ra) # 80002e34 <bunpin>
    brelse(lbuf);
    80003cec:	854a                	mv	a0,s2
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	06c080e7          	jalr	108(ra) # 80002d5a <brelse>
    brelse(dbuf);
    80003cf6:	8526                	mv	a0,s1
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	062080e7          	jalr	98(ra) # 80002d5a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d00:	2a05                	addiw	s4,s4,1
    80003d02:	0a91                	addi	s5,s5,4
    80003d04:	02c9a783          	lw	a5,44(s3)
    80003d08:	f8fa49e3          	blt	s4,a5,80003c9a <install_trans+0x30>
}
    80003d0c:	70e2                	ld	ra,56(sp)
    80003d0e:	7442                	ld	s0,48(sp)
    80003d10:	74a2                	ld	s1,40(sp)
    80003d12:	7902                	ld	s2,32(sp)
    80003d14:	69e2                	ld	s3,24(sp)
    80003d16:	6a42                	ld	s4,16(sp)
    80003d18:	6aa2                	ld	s5,8(sp)
    80003d1a:	6121                	addi	sp,sp,64
    80003d1c:	8082                	ret
    80003d1e:	8082                	ret

0000000080003d20 <initlog>:
{
    80003d20:	7179                	addi	sp,sp,-48
    80003d22:	f406                	sd	ra,40(sp)
    80003d24:	f022                	sd	s0,32(sp)
    80003d26:	ec26                	sd	s1,24(sp)
    80003d28:	e84a                	sd	s2,16(sp)
    80003d2a:	e44e                	sd	s3,8(sp)
    80003d2c:	1800                	addi	s0,sp,48
    80003d2e:	892a                	mv	s2,a0
    80003d30:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d32:	0001d497          	auipc	s1,0x1d
    80003d36:	c6648493          	addi	s1,s1,-922 # 80020998 <log>
    80003d3a:	00003597          	auipc	a1,0x3
    80003d3e:	8b658593          	addi	a1,a1,-1866 # 800065f0 <userret+0x560>
    80003d42:	8526                	mv	a0,s1
    80003d44:	ffffd097          	auipc	ra,0xffffd
    80003d48:	c7c080e7          	jalr	-900(ra) # 800009c0 <initlock>
  log.start = sb->logstart;
    80003d4c:	0149a583          	lw	a1,20(s3)
    80003d50:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003d52:	0109a783          	lw	a5,16(s3)
    80003d56:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003d58:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003d5c:	854a                	mv	a0,s2
    80003d5e:	fffff097          	auipc	ra,0xfffff
    80003d62:	ecc080e7          	jalr	-308(ra) # 80002c2a <bread>
  log.lh.n = lh->n;
    80003d66:	513c                	lw	a5,96(a0)
    80003d68:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003d6a:	02f05563          	blez	a5,80003d94 <initlog+0x74>
    80003d6e:	06450713          	addi	a4,a0,100
    80003d72:	0001d697          	auipc	a3,0x1d
    80003d76:	c5668693          	addi	a3,a3,-938 # 800209c8 <log+0x30>
    80003d7a:	37fd                	addiw	a5,a5,-1
    80003d7c:	1782                	slli	a5,a5,0x20
    80003d7e:	9381                	srli	a5,a5,0x20
    80003d80:	078a                	slli	a5,a5,0x2
    80003d82:	06850613          	addi	a2,a0,104
    80003d86:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003d88:	4310                	lw	a2,0(a4)
    80003d8a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003d8c:	0711                	addi	a4,a4,4
    80003d8e:	0691                	addi	a3,a3,4
    80003d90:	fef71ce3          	bne	a4,a5,80003d88 <initlog+0x68>
  brelse(buf);
    80003d94:	fffff097          	auipc	ra,0xfffff
    80003d98:	fc6080e7          	jalr	-58(ra) # 80002d5a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	ece080e7          	jalr	-306(ra) # 80003c6a <install_trans>
  log.lh.n = 0;
    80003da4:	0001d797          	auipc	a5,0x1d
    80003da8:	c207a023          	sw	zero,-992(a5) # 800209c4 <log+0x2c>
  write_head(); // clear the log
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	e44080e7          	jalr	-444(ra) # 80003bf0 <write_head>
}
    80003db4:	70a2                	ld	ra,40(sp)
    80003db6:	7402                	ld	s0,32(sp)
    80003db8:	64e2                	ld	s1,24(sp)
    80003dba:	6942                	ld	s2,16(sp)
    80003dbc:	69a2                	ld	s3,8(sp)
    80003dbe:	6145                	addi	sp,sp,48
    80003dc0:	8082                	ret

0000000080003dc2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003dc2:	1101                	addi	sp,sp,-32
    80003dc4:	ec06                	sd	ra,24(sp)
    80003dc6:	e822                	sd	s0,16(sp)
    80003dc8:	e426                	sd	s1,8(sp)
    80003dca:	e04a                	sd	s2,0(sp)
    80003dcc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003dce:	0001d517          	auipc	a0,0x1d
    80003dd2:	bca50513          	addi	a0,a0,-1078 # 80020998 <log>
    80003dd6:	ffffd097          	auipc	ra,0xffffd
    80003dda:	cfc080e7          	jalr	-772(ra) # 80000ad2 <acquire>
  while(1){
    if(log.committing){
    80003dde:	0001d497          	auipc	s1,0x1d
    80003de2:	bba48493          	addi	s1,s1,-1094 # 80020998 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003de6:	4979                	li	s2,30
    80003de8:	a039                	j	80003df6 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003dea:	85a6                	mv	a1,s1
    80003dec:	8526                	mv	a0,s1
    80003dee:	ffffe097          	auipc	ra,0xffffe
    80003df2:	1f8080e7          	jalr	504(ra) # 80001fe6 <sleep>
    if(log.committing){
    80003df6:	50dc                	lw	a5,36(s1)
    80003df8:	fbed                	bnez	a5,80003dea <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003dfa:	509c                	lw	a5,32(s1)
    80003dfc:	0017871b          	addiw	a4,a5,1
    80003e00:	0007069b          	sext.w	a3,a4
    80003e04:	0027179b          	slliw	a5,a4,0x2
    80003e08:	9fb9                	addw	a5,a5,a4
    80003e0a:	0017979b          	slliw	a5,a5,0x1
    80003e0e:	54d8                	lw	a4,44(s1)
    80003e10:	9fb9                	addw	a5,a5,a4
    80003e12:	00f95963          	bge	s2,a5,80003e24 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003e16:	85a6                	mv	a1,s1
    80003e18:	8526                	mv	a0,s1
    80003e1a:	ffffe097          	auipc	ra,0xffffe
    80003e1e:	1cc080e7          	jalr	460(ra) # 80001fe6 <sleep>
    80003e22:	bfd1                	j	80003df6 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003e24:	0001d517          	auipc	a0,0x1d
    80003e28:	b7450513          	addi	a0,a0,-1164 # 80020998 <log>
    80003e2c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003e2e:	ffffd097          	auipc	ra,0xffffd
    80003e32:	cf8080e7          	jalr	-776(ra) # 80000b26 <release>
      break;
    }
  }
}
    80003e36:	60e2                	ld	ra,24(sp)
    80003e38:	6442                	ld	s0,16(sp)
    80003e3a:	64a2                	ld	s1,8(sp)
    80003e3c:	6902                	ld	s2,0(sp)
    80003e3e:	6105                	addi	sp,sp,32
    80003e40:	8082                	ret

0000000080003e42 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003e42:	7139                	addi	sp,sp,-64
    80003e44:	fc06                	sd	ra,56(sp)
    80003e46:	f822                	sd	s0,48(sp)
    80003e48:	f426                	sd	s1,40(sp)
    80003e4a:	f04a                	sd	s2,32(sp)
    80003e4c:	ec4e                	sd	s3,24(sp)
    80003e4e:	e852                	sd	s4,16(sp)
    80003e50:	e456                	sd	s5,8(sp)
    80003e52:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003e54:	0001d497          	auipc	s1,0x1d
    80003e58:	b4448493          	addi	s1,s1,-1212 # 80020998 <log>
    80003e5c:	8526                	mv	a0,s1
    80003e5e:	ffffd097          	auipc	ra,0xffffd
    80003e62:	c74080e7          	jalr	-908(ra) # 80000ad2 <acquire>
  log.outstanding -= 1;
    80003e66:	509c                	lw	a5,32(s1)
    80003e68:	37fd                	addiw	a5,a5,-1
    80003e6a:	0007891b          	sext.w	s2,a5
    80003e6e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003e70:	50dc                	lw	a5,36(s1)
    80003e72:	efb9                	bnez	a5,80003ed0 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003e74:	06091663          	bnez	s2,80003ee0 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003e78:	0001d497          	auipc	s1,0x1d
    80003e7c:	b2048493          	addi	s1,s1,-1248 # 80020998 <log>
    80003e80:	4785                	li	a5,1
    80003e82:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e84:	8526                	mv	a0,s1
    80003e86:	ffffd097          	auipc	ra,0xffffd
    80003e8a:	ca0080e7          	jalr	-864(ra) # 80000b26 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e8e:	54dc                	lw	a5,44(s1)
    80003e90:	06f04763          	bgtz	a5,80003efe <end_op+0xbc>
    acquire(&log.lock);
    80003e94:	0001d497          	auipc	s1,0x1d
    80003e98:	b0448493          	addi	s1,s1,-1276 # 80020998 <log>
    80003e9c:	8526                	mv	a0,s1
    80003e9e:	ffffd097          	auipc	ra,0xffffd
    80003ea2:	c34080e7          	jalr	-972(ra) # 80000ad2 <acquire>
    log.committing = 0;
    80003ea6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003eaa:	8526                	mv	a0,s1
    80003eac:	ffffe097          	auipc	ra,0xffffe
    80003eb0:	2c0080e7          	jalr	704(ra) # 8000216c <wakeup>
    release(&log.lock);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	ffffd097          	auipc	ra,0xffffd
    80003eba:	c70080e7          	jalr	-912(ra) # 80000b26 <release>
}
    80003ebe:	70e2                	ld	ra,56(sp)
    80003ec0:	7442                	ld	s0,48(sp)
    80003ec2:	74a2                	ld	s1,40(sp)
    80003ec4:	7902                	ld	s2,32(sp)
    80003ec6:	69e2                	ld	s3,24(sp)
    80003ec8:	6a42                	ld	s4,16(sp)
    80003eca:	6aa2                	ld	s5,8(sp)
    80003ecc:	6121                	addi	sp,sp,64
    80003ece:	8082                	ret
    panic("log.committing");
    80003ed0:	00002517          	auipc	a0,0x2
    80003ed4:	72850513          	addi	a0,a0,1832 # 800065f8 <userret+0x568>
    80003ed8:	ffffc097          	auipc	ra,0xffffc
    80003edc:	676080e7          	jalr	1654(ra) # 8000054e <panic>
    wakeup(&log);
    80003ee0:	0001d497          	auipc	s1,0x1d
    80003ee4:	ab848493          	addi	s1,s1,-1352 # 80020998 <log>
    80003ee8:	8526                	mv	a0,s1
    80003eea:	ffffe097          	auipc	ra,0xffffe
    80003eee:	282080e7          	jalr	642(ra) # 8000216c <wakeup>
  release(&log.lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	c32080e7          	jalr	-974(ra) # 80000b26 <release>
  if(do_commit){
    80003efc:	b7c9                	j	80003ebe <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003efe:	0001da97          	auipc	s5,0x1d
    80003f02:	acaa8a93          	addi	s5,s5,-1334 # 800209c8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003f06:	0001da17          	auipc	s4,0x1d
    80003f0a:	a92a0a13          	addi	s4,s4,-1390 # 80020998 <log>
    80003f0e:	018a2583          	lw	a1,24(s4)
    80003f12:	012585bb          	addw	a1,a1,s2
    80003f16:	2585                	addiw	a1,a1,1
    80003f18:	028a2503          	lw	a0,40(s4)
    80003f1c:	fffff097          	auipc	ra,0xfffff
    80003f20:	d0e080e7          	jalr	-754(ra) # 80002c2a <bread>
    80003f24:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003f26:	000aa583          	lw	a1,0(s5)
    80003f2a:	028a2503          	lw	a0,40(s4)
    80003f2e:	fffff097          	auipc	ra,0xfffff
    80003f32:	cfc080e7          	jalr	-772(ra) # 80002c2a <bread>
    80003f36:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f38:	40000613          	li	a2,1024
    80003f3c:	06050593          	addi	a1,a0,96
    80003f40:	06048513          	addi	a0,s1,96
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	c8a080e7          	jalr	-886(ra) # 80000bce <memmove>
    bwrite(to);  // write the log
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	fffff097          	auipc	ra,0xfffff
    80003f52:	dce080e7          	jalr	-562(ra) # 80002d1c <bwrite>
    brelse(from);
    80003f56:	854e                	mv	a0,s3
    80003f58:	fffff097          	auipc	ra,0xfffff
    80003f5c:	e02080e7          	jalr	-510(ra) # 80002d5a <brelse>
    brelse(to);
    80003f60:	8526                	mv	a0,s1
    80003f62:	fffff097          	auipc	ra,0xfffff
    80003f66:	df8080e7          	jalr	-520(ra) # 80002d5a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f6a:	2905                	addiw	s2,s2,1
    80003f6c:	0a91                	addi	s5,s5,4
    80003f6e:	02ca2783          	lw	a5,44(s4)
    80003f72:	f8f94ee3          	blt	s2,a5,80003f0e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003f76:	00000097          	auipc	ra,0x0
    80003f7a:	c7a080e7          	jalr	-902(ra) # 80003bf0 <write_head>
    install_trans(); // Now install writes to home locations
    80003f7e:	00000097          	auipc	ra,0x0
    80003f82:	cec080e7          	jalr	-788(ra) # 80003c6a <install_trans>
    log.lh.n = 0;
    80003f86:	0001d797          	auipc	a5,0x1d
    80003f8a:	a207af23          	sw	zero,-1474(a5) # 800209c4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003f8e:	00000097          	auipc	ra,0x0
    80003f92:	c62080e7          	jalr	-926(ra) # 80003bf0 <write_head>
    80003f96:	bdfd                	j	80003e94 <end_op+0x52>

0000000080003f98 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f98:	1101                	addi	sp,sp,-32
    80003f9a:	ec06                	sd	ra,24(sp)
    80003f9c:	e822                	sd	s0,16(sp)
    80003f9e:	e426                	sd	s1,8(sp)
    80003fa0:	e04a                	sd	s2,0(sp)
    80003fa2:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003fa4:	0001d717          	auipc	a4,0x1d
    80003fa8:	a2072703          	lw	a4,-1504(a4) # 800209c4 <log+0x2c>
    80003fac:	47f5                	li	a5,29
    80003fae:	08e7c063          	blt	a5,a4,8000402e <log_write+0x96>
    80003fb2:	84aa                	mv	s1,a0
    80003fb4:	0001d797          	auipc	a5,0x1d
    80003fb8:	a007a783          	lw	a5,-1536(a5) # 800209b4 <log+0x1c>
    80003fbc:	37fd                	addiw	a5,a5,-1
    80003fbe:	06f75863          	bge	a4,a5,8000402e <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003fc2:	0001d797          	auipc	a5,0x1d
    80003fc6:	9f67a783          	lw	a5,-1546(a5) # 800209b8 <log+0x20>
    80003fca:	06f05a63          	blez	a5,8000403e <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    80003fce:	0001d917          	auipc	s2,0x1d
    80003fd2:	9ca90913          	addi	s2,s2,-1590 # 80020998 <log>
    80003fd6:	854a                	mv	a0,s2
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	afa080e7          	jalr	-1286(ra) # 80000ad2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80003fe0:	02c92603          	lw	a2,44(s2)
    80003fe4:	06c05563          	blez	a2,8000404e <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80003fe8:	44cc                	lw	a1,12(s1)
    80003fea:	0001d717          	auipc	a4,0x1d
    80003fee:	9de70713          	addi	a4,a4,-1570 # 800209c8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ff2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80003ff4:	4314                	lw	a3,0(a4)
    80003ff6:	04b68d63          	beq	a3,a1,80004050 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80003ffa:	2785                	addiw	a5,a5,1
    80003ffc:	0711                	addi	a4,a4,4
    80003ffe:	fec79be3          	bne	a5,a2,80003ff4 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004002:	0621                	addi	a2,a2,8
    80004004:	060a                	slli	a2,a2,0x2
    80004006:	0001d797          	auipc	a5,0x1d
    8000400a:	99278793          	addi	a5,a5,-1646 # 80020998 <log>
    8000400e:	963e                	add	a2,a2,a5
    80004010:	44dc                	lw	a5,12(s1)
    80004012:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004014:	8526                	mv	a0,s1
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	de2080e7          	jalr	-542(ra) # 80002df8 <bpin>
    log.lh.n++;
    8000401e:	0001d717          	auipc	a4,0x1d
    80004022:	97a70713          	addi	a4,a4,-1670 # 80020998 <log>
    80004026:	575c                	lw	a5,44(a4)
    80004028:	2785                	addiw	a5,a5,1
    8000402a:	d75c                	sw	a5,44(a4)
    8000402c:	a83d                	j	8000406a <log_write+0xd2>
    panic("too big a transaction");
    8000402e:	00002517          	auipc	a0,0x2
    80004032:	5da50513          	addi	a0,a0,1498 # 80006608 <userret+0x578>
    80004036:	ffffc097          	auipc	ra,0xffffc
    8000403a:	518080e7          	jalr	1304(ra) # 8000054e <panic>
    panic("log_write outside of trans");
    8000403e:	00002517          	auipc	a0,0x2
    80004042:	5e250513          	addi	a0,a0,1506 # 80006620 <userret+0x590>
    80004046:	ffffc097          	auipc	ra,0xffffc
    8000404a:	508080e7          	jalr	1288(ra) # 8000054e <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000404e:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004050:	00878713          	addi	a4,a5,8
    80004054:	00271693          	slli	a3,a4,0x2
    80004058:	0001d717          	auipc	a4,0x1d
    8000405c:	94070713          	addi	a4,a4,-1728 # 80020998 <log>
    80004060:	9736                	add	a4,a4,a3
    80004062:	44d4                	lw	a3,12(s1)
    80004064:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004066:	faf607e3          	beq	a2,a5,80004014 <log_write+0x7c>
  }
  release(&log.lock);
    8000406a:	0001d517          	auipc	a0,0x1d
    8000406e:	92e50513          	addi	a0,a0,-1746 # 80020998 <log>
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	ab4080e7          	jalr	-1356(ra) # 80000b26 <release>
}
    8000407a:	60e2                	ld	ra,24(sp)
    8000407c:	6442                	ld	s0,16(sp)
    8000407e:	64a2                	ld	s1,8(sp)
    80004080:	6902                	ld	s2,0(sp)
    80004082:	6105                	addi	sp,sp,32
    80004084:	8082                	ret

0000000080004086 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004086:	1101                	addi	sp,sp,-32
    80004088:	ec06                	sd	ra,24(sp)
    8000408a:	e822                	sd	s0,16(sp)
    8000408c:	e426                	sd	s1,8(sp)
    8000408e:	e04a                	sd	s2,0(sp)
    80004090:	1000                	addi	s0,sp,32
    80004092:	84aa                	mv	s1,a0
    80004094:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004096:	00002597          	auipc	a1,0x2
    8000409a:	5aa58593          	addi	a1,a1,1450 # 80006640 <userret+0x5b0>
    8000409e:	0521                	addi	a0,a0,8
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	920080e7          	jalr	-1760(ra) # 800009c0 <initlock>
  lk->name = name;
    800040a8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800040ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800040b0:	0204a423          	sw	zero,40(s1)
}
    800040b4:	60e2                	ld	ra,24(sp)
    800040b6:	6442                	ld	s0,16(sp)
    800040b8:	64a2                	ld	s1,8(sp)
    800040ba:	6902                	ld	s2,0(sp)
    800040bc:	6105                	addi	sp,sp,32
    800040be:	8082                	ret

00000000800040c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800040c0:	1101                	addi	sp,sp,-32
    800040c2:	ec06                	sd	ra,24(sp)
    800040c4:	e822                	sd	s0,16(sp)
    800040c6:	e426                	sd	s1,8(sp)
    800040c8:	e04a                	sd	s2,0(sp)
    800040ca:	1000                	addi	s0,sp,32
    800040cc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040ce:	00850913          	addi	s2,a0,8
    800040d2:	854a                	mv	a0,s2
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	9fe080e7          	jalr	-1538(ra) # 80000ad2 <acquire>
  while (lk->locked) {
    800040dc:	409c                	lw	a5,0(s1)
    800040de:	cb89                	beqz	a5,800040f0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800040e0:	85ca                	mv	a1,s2
    800040e2:	8526                	mv	a0,s1
    800040e4:	ffffe097          	auipc	ra,0xffffe
    800040e8:	f02080e7          	jalr	-254(ra) # 80001fe6 <sleep>
  while (lk->locked) {
    800040ec:	409c                	lw	a5,0(s1)
    800040ee:	fbed                	bnez	a5,800040e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800040f0:	4785                	li	a5,1
    800040f2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	750080e7          	jalr	1872(ra) # 80001844 <myproc>
    800040fc:	5d1c                	lw	a5,56(a0)
    800040fe:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004100:	854a                	mv	a0,s2
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	a24080e7          	jalr	-1500(ra) # 80000b26 <release>
}
    8000410a:	60e2                	ld	ra,24(sp)
    8000410c:	6442                	ld	s0,16(sp)
    8000410e:	64a2                	ld	s1,8(sp)
    80004110:	6902                	ld	s2,0(sp)
    80004112:	6105                	addi	sp,sp,32
    80004114:	8082                	ret

0000000080004116 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004116:	1101                	addi	sp,sp,-32
    80004118:	ec06                	sd	ra,24(sp)
    8000411a:	e822                	sd	s0,16(sp)
    8000411c:	e426                	sd	s1,8(sp)
    8000411e:	e04a                	sd	s2,0(sp)
    80004120:	1000                	addi	s0,sp,32
    80004122:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004124:	00850913          	addi	s2,a0,8
    80004128:	854a                	mv	a0,s2
    8000412a:	ffffd097          	auipc	ra,0xffffd
    8000412e:	9a8080e7          	jalr	-1624(ra) # 80000ad2 <acquire>
  lk->locked = 0;
    80004132:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004136:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000413a:	8526                	mv	a0,s1
    8000413c:	ffffe097          	auipc	ra,0xffffe
    80004140:	030080e7          	jalr	48(ra) # 8000216c <wakeup>
  release(&lk->lk);
    80004144:	854a                	mv	a0,s2
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	9e0080e7          	jalr	-1568(ra) # 80000b26 <release>
}
    8000414e:	60e2                	ld	ra,24(sp)
    80004150:	6442                	ld	s0,16(sp)
    80004152:	64a2                	ld	s1,8(sp)
    80004154:	6902                	ld	s2,0(sp)
    80004156:	6105                	addi	sp,sp,32
    80004158:	8082                	ret

000000008000415a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000415a:	7179                	addi	sp,sp,-48
    8000415c:	f406                	sd	ra,40(sp)
    8000415e:	f022                	sd	s0,32(sp)
    80004160:	ec26                	sd	s1,24(sp)
    80004162:	e84a                	sd	s2,16(sp)
    80004164:	e44e                	sd	s3,8(sp)
    80004166:	1800                	addi	s0,sp,48
    80004168:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000416a:	00850913          	addi	s2,a0,8
    8000416e:	854a                	mv	a0,s2
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	962080e7          	jalr	-1694(ra) # 80000ad2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004178:	409c                	lw	a5,0(s1)
    8000417a:	ef99                	bnez	a5,80004198 <holdingsleep+0x3e>
    8000417c:	4481                	li	s1,0
  release(&lk->lk);
    8000417e:	854a                	mv	a0,s2
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	9a6080e7          	jalr	-1626(ra) # 80000b26 <release>
  return r;
}
    80004188:	8526                	mv	a0,s1
    8000418a:	70a2                	ld	ra,40(sp)
    8000418c:	7402                	ld	s0,32(sp)
    8000418e:	64e2                	ld	s1,24(sp)
    80004190:	6942                	ld	s2,16(sp)
    80004192:	69a2                	ld	s3,8(sp)
    80004194:	6145                	addi	sp,sp,48
    80004196:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004198:	0284a983          	lw	s3,40(s1)
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	6a8080e7          	jalr	1704(ra) # 80001844 <myproc>
    800041a4:	5d04                	lw	s1,56(a0)
    800041a6:	413484b3          	sub	s1,s1,s3
    800041aa:	0014b493          	seqz	s1,s1
    800041ae:	bfc1                	j	8000417e <holdingsleep+0x24>

00000000800041b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800041b0:	1141                	addi	sp,sp,-16
    800041b2:	e406                	sd	ra,8(sp)
    800041b4:	e022                	sd	s0,0(sp)
    800041b6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800041b8:	00002597          	auipc	a1,0x2
    800041bc:	49858593          	addi	a1,a1,1176 # 80006650 <userret+0x5c0>
    800041c0:	0001d517          	auipc	a0,0x1d
    800041c4:	92050513          	addi	a0,a0,-1760 # 80020ae0 <ftable>
    800041c8:	ffffc097          	auipc	ra,0xffffc
    800041cc:	7f8080e7          	jalr	2040(ra) # 800009c0 <initlock>
}
    800041d0:	60a2                	ld	ra,8(sp)
    800041d2:	6402                	ld	s0,0(sp)
    800041d4:	0141                	addi	sp,sp,16
    800041d6:	8082                	ret

00000000800041d8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800041d8:	1101                	addi	sp,sp,-32
    800041da:	ec06                	sd	ra,24(sp)
    800041dc:	e822                	sd	s0,16(sp)
    800041de:	e426                	sd	s1,8(sp)
    800041e0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800041e2:	0001d517          	auipc	a0,0x1d
    800041e6:	8fe50513          	addi	a0,a0,-1794 # 80020ae0 <ftable>
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	8e8080e7          	jalr	-1816(ra) # 80000ad2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041f2:	0001d497          	auipc	s1,0x1d
    800041f6:	90648493          	addi	s1,s1,-1786 # 80020af8 <ftable+0x18>
    800041fa:	0001e717          	auipc	a4,0x1e
    800041fe:	89e70713          	addi	a4,a4,-1890 # 80021a98 <ftable+0xfb8>
    if(f->ref == 0){
    80004202:	40dc                	lw	a5,4(s1)
    80004204:	cf99                	beqz	a5,80004222 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004206:	02848493          	addi	s1,s1,40
    8000420a:	fee49ce3          	bne	s1,a4,80004202 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000420e:	0001d517          	auipc	a0,0x1d
    80004212:	8d250513          	addi	a0,a0,-1838 # 80020ae0 <ftable>
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	910080e7          	jalr	-1776(ra) # 80000b26 <release>
  return 0;
    8000421e:	4481                	li	s1,0
    80004220:	a819                	j	80004236 <filealloc+0x5e>
      f->ref = 1;
    80004222:	4785                	li	a5,1
    80004224:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004226:	0001d517          	auipc	a0,0x1d
    8000422a:	8ba50513          	addi	a0,a0,-1862 # 80020ae0 <ftable>
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	8f8080e7          	jalr	-1800(ra) # 80000b26 <release>
}
    80004236:	8526                	mv	a0,s1
    80004238:	60e2                	ld	ra,24(sp)
    8000423a:	6442                	ld	s0,16(sp)
    8000423c:	64a2                	ld	s1,8(sp)
    8000423e:	6105                	addi	sp,sp,32
    80004240:	8082                	ret

0000000080004242 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004242:	1101                	addi	sp,sp,-32
    80004244:	ec06                	sd	ra,24(sp)
    80004246:	e822                	sd	s0,16(sp)
    80004248:	e426                	sd	s1,8(sp)
    8000424a:	1000                	addi	s0,sp,32
    8000424c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000424e:	0001d517          	auipc	a0,0x1d
    80004252:	89250513          	addi	a0,a0,-1902 # 80020ae0 <ftable>
    80004256:	ffffd097          	auipc	ra,0xffffd
    8000425a:	87c080e7          	jalr	-1924(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    8000425e:	40dc                	lw	a5,4(s1)
    80004260:	02f05263          	blez	a5,80004284 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004264:	2785                	addiw	a5,a5,1
    80004266:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004268:	0001d517          	auipc	a0,0x1d
    8000426c:	87850513          	addi	a0,a0,-1928 # 80020ae0 <ftable>
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	8b6080e7          	jalr	-1866(ra) # 80000b26 <release>
  return f;
}
    80004278:	8526                	mv	a0,s1
    8000427a:	60e2                	ld	ra,24(sp)
    8000427c:	6442                	ld	s0,16(sp)
    8000427e:	64a2                	ld	s1,8(sp)
    80004280:	6105                	addi	sp,sp,32
    80004282:	8082                	ret
    panic("filedup");
    80004284:	00002517          	auipc	a0,0x2
    80004288:	3d450513          	addi	a0,a0,980 # 80006658 <userret+0x5c8>
    8000428c:	ffffc097          	auipc	ra,0xffffc
    80004290:	2c2080e7          	jalr	706(ra) # 8000054e <panic>

0000000080004294 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004294:	7139                	addi	sp,sp,-64
    80004296:	fc06                	sd	ra,56(sp)
    80004298:	f822                	sd	s0,48(sp)
    8000429a:	f426                	sd	s1,40(sp)
    8000429c:	f04a                	sd	s2,32(sp)
    8000429e:	ec4e                	sd	s3,24(sp)
    800042a0:	e852                	sd	s4,16(sp)
    800042a2:	e456                	sd	s5,8(sp)
    800042a4:	0080                	addi	s0,sp,64
    800042a6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042a8:	0001d517          	auipc	a0,0x1d
    800042ac:	83850513          	addi	a0,a0,-1992 # 80020ae0 <ftable>
    800042b0:	ffffd097          	auipc	ra,0xffffd
    800042b4:	822080e7          	jalr	-2014(ra) # 80000ad2 <acquire>
  if(f->ref < 1)
    800042b8:	40dc                	lw	a5,4(s1)
    800042ba:	06f05163          	blez	a5,8000431c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800042be:	37fd                	addiw	a5,a5,-1
    800042c0:	0007871b          	sext.w	a4,a5
    800042c4:	c0dc                	sw	a5,4(s1)
    800042c6:	06e04363          	bgtz	a4,8000432c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800042ca:	0004a903          	lw	s2,0(s1)
    800042ce:	0094ca83          	lbu	s5,9(s1)
    800042d2:	0104ba03          	ld	s4,16(s1)
    800042d6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800042da:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800042de:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800042e2:	0001c517          	auipc	a0,0x1c
    800042e6:	7fe50513          	addi	a0,a0,2046 # 80020ae0 <ftable>
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	83c080e7          	jalr	-1988(ra) # 80000b26 <release>

  if(ff.type == FD_PIPE){
    800042f2:	4785                	li	a5,1
    800042f4:	04f90d63          	beq	s2,a5,8000434e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800042f8:	3979                	addiw	s2,s2,-2
    800042fa:	4785                	li	a5,1
    800042fc:	0527e063          	bltu	a5,s2,8000433c <fileclose+0xa8>
    begin_op();
    80004300:	00000097          	auipc	ra,0x0
    80004304:	ac2080e7          	jalr	-1342(ra) # 80003dc2 <begin_op>
    iput(ff.ip);
    80004308:	854e                	mv	a0,s3
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	230080e7          	jalr	560(ra) # 8000353a <iput>
    end_op();
    80004312:	00000097          	auipc	ra,0x0
    80004316:	b30080e7          	jalr	-1232(ra) # 80003e42 <end_op>
    8000431a:	a00d                	j	8000433c <fileclose+0xa8>
    panic("fileclose");
    8000431c:	00002517          	auipc	a0,0x2
    80004320:	34450513          	addi	a0,a0,836 # 80006660 <userret+0x5d0>
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	22a080e7          	jalr	554(ra) # 8000054e <panic>
    release(&ftable.lock);
    8000432c:	0001c517          	auipc	a0,0x1c
    80004330:	7b450513          	addi	a0,a0,1972 # 80020ae0 <ftable>
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	7f2080e7          	jalr	2034(ra) # 80000b26 <release>
  }
}
    8000433c:	70e2                	ld	ra,56(sp)
    8000433e:	7442                	ld	s0,48(sp)
    80004340:	74a2                	ld	s1,40(sp)
    80004342:	7902                	ld	s2,32(sp)
    80004344:	69e2                	ld	s3,24(sp)
    80004346:	6a42                	ld	s4,16(sp)
    80004348:	6aa2                	ld	s5,8(sp)
    8000434a:	6121                	addi	sp,sp,64
    8000434c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000434e:	85d6                	mv	a1,s5
    80004350:	8552                	mv	a0,s4
    80004352:	00000097          	auipc	ra,0x0
    80004356:	372080e7          	jalr	882(ra) # 800046c4 <pipeclose>
    8000435a:	b7cd                	j	8000433c <fileclose+0xa8>

000000008000435c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000435c:	715d                	addi	sp,sp,-80
    8000435e:	e486                	sd	ra,72(sp)
    80004360:	e0a2                	sd	s0,64(sp)
    80004362:	fc26                	sd	s1,56(sp)
    80004364:	f84a                	sd	s2,48(sp)
    80004366:	f44e                	sd	s3,40(sp)
    80004368:	0880                	addi	s0,sp,80
    8000436a:	84aa                	mv	s1,a0
    8000436c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	4d6080e7          	jalr	1238(ra) # 80001844 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004376:	409c                	lw	a5,0(s1)
    80004378:	37f9                	addiw	a5,a5,-2
    8000437a:	4705                	li	a4,1
    8000437c:	04f76763          	bltu	a4,a5,800043ca <filestat+0x6e>
    80004380:	892a                	mv	s2,a0
    ilock(f->ip);
    80004382:	6c88                	ld	a0,24(s1)
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	0a8080e7          	jalr	168(ra) # 8000342c <ilock>
    stati(f->ip, &st);
    8000438c:	fb840593          	addi	a1,s0,-72
    80004390:	6c88                	ld	a0,24(s1)
    80004392:	fffff097          	auipc	ra,0xfffff
    80004396:	300080e7          	jalr	768(ra) # 80003692 <stati>
    iunlock(f->ip);
    8000439a:	6c88                	ld	a0,24(s1)
    8000439c:	fffff097          	auipc	ra,0xfffff
    800043a0:	152080e7          	jalr	338(ra) # 800034ee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800043a4:	46e1                	li	a3,24
    800043a6:	fb840613          	addi	a2,s0,-72
    800043aa:	85ce                	mv	a1,s3
    800043ac:	05093503          	ld	a0,80(s2)
    800043b0:	ffffd097          	auipc	ra,0xffffd
    800043b4:	188080e7          	jalr	392(ra) # 80001538 <copyout>
    800043b8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800043bc:	60a6                	ld	ra,72(sp)
    800043be:	6406                	ld	s0,64(sp)
    800043c0:	74e2                	ld	s1,56(sp)
    800043c2:	7942                	ld	s2,48(sp)
    800043c4:	79a2                	ld	s3,40(sp)
    800043c6:	6161                	addi	sp,sp,80
    800043c8:	8082                	ret
  return -1;
    800043ca:	557d                	li	a0,-1
    800043cc:	bfc5                	j	800043bc <filestat+0x60>

00000000800043ce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800043ce:	7179                	addi	sp,sp,-48
    800043d0:	f406                	sd	ra,40(sp)
    800043d2:	f022                	sd	s0,32(sp)
    800043d4:	ec26                	sd	s1,24(sp)
    800043d6:	e84a                	sd	s2,16(sp)
    800043d8:	e44e                	sd	s3,8(sp)
    800043da:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800043dc:	00854783          	lbu	a5,8(a0)
    800043e0:	c3d5                	beqz	a5,80004484 <fileread+0xb6>
    800043e2:	84aa                	mv	s1,a0
    800043e4:	89ae                	mv	s3,a1
    800043e6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800043e8:	411c                	lw	a5,0(a0)
    800043ea:	4705                	li	a4,1
    800043ec:	04e78963          	beq	a5,a4,8000443e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800043f0:	470d                	li	a4,3
    800043f2:	04e78d63          	beq	a5,a4,8000444c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800043f6:	4709                	li	a4,2
    800043f8:	06e79e63          	bne	a5,a4,80004474 <fileread+0xa6>
    ilock(f->ip);
    800043fc:	6d08                	ld	a0,24(a0)
    800043fe:	fffff097          	auipc	ra,0xfffff
    80004402:	02e080e7          	jalr	46(ra) # 8000342c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004406:	874a                	mv	a4,s2
    80004408:	5094                	lw	a3,32(s1)
    8000440a:	864e                	mv	a2,s3
    8000440c:	4585                	li	a1,1
    8000440e:	6c88                	ld	a0,24(s1)
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	2ac080e7          	jalr	684(ra) # 800036bc <readi>
    80004418:	892a                	mv	s2,a0
    8000441a:	00a05563          	blez	a0,80004424 <fileread+0x56>
      f->off += r;
    8000441e:	509c                	lw	a5,32(s1)
    80004420:	9fa9                	addw	a5,a5,a0
    80004422:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004424:	6c88                	ld	a0,24(s1)
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	0c8080e7          	jalr	200(ra) # 800034ee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000442e:	854a                	mv	a0,s2
    80004430:	70a2                	ld	ra,40(sp)
    80004432:	7402                	ld	s0,32(sp)
    80004434:	64e2                	ld	s1,24(sp)
    80004436:	6942                	ld	s2,16(sp)
    80004438:	69a2                	ld	s3,8(sp)
    8000443a:	6145                	addi	sp,sp,48
    8000443c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000443e:	6908                	ld	a0,16(a0)
    80004440:	00000097          	auipc	ra,0x0
    80004444:	408080e7          	jalr	1032(ra) # 80004848 <piperead>
    80004448:	892a                	mv	s2,a0
    8000444a:	b7d5                	j	8000442e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000444c:	02451783          	lh	a5,36(a0)
    80004450:	03079693          	slli	a3,a5,0x30
    80004454:	92c1                	srli	a3,a3,0x30
    80004456:	4725                	li	a4,9
    80004458:	02d76863          	bltu	a4,a3,80004488 <fileread+0xba>
    8000445c:	0792                	slli	a5,a5,0x4
    8000445e:	0001c717          	auipc	a4,0x1c
    80004462:	5e270713          	addi	a4,a4,1506 # 80020a40 <devsw>
    80004466:	97ba                	add	a5,a5,a4
    80004468:	639c                	ld	a5,0(a5)
    8000446a:	c38d                	beqz	a5,8000448c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000446c:	4505                	li	a0,1
    8000446e:	9782                	jalr	a5
    80004470:	892a                	mv	s2,a0
    80004472:	bf75                	j	8000442e <fileread+0x60>
    panic("fileread");
    80004474:	00002517          	auipc	a0,0x2
    80004478:	1fc50513          	addi	a0,a0,508 # 80006670 <userret+0x5e0>
    8000447c:	ffffc097          	auipc	ra,0xffffc
    80004480:	0d2080e7          	jalr	210(ra) # 8000054e <panic>
    return -1;
    80004484:	597d                	li	s2,-1
    80004486:	b765                	j	8000442e <fileread+0x60>
      return -1;
    80004488:	597d                	li	s2,-1
    8000448a:	b755                	j	8000442e <fileread+0x60>
    8000448c:	597d                	li	s2,-1
    8000448e:	b745                	j	8000442e <fileread+0x60>

0000000080004490 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004490:	00954783          	lbu	a5,9(a0)
    80004494:	14078563          	beqz	a5,800045de <filewrite+0x14e>
{
    80004498:	715d                	addi	sp,sp,-80
    8000449a:	e486                	sd	ra,72(sp)
    8000449c:	e0a2                	sd	s0,64(sp)
    8000449e:	fc26                	sd	s1,56(sp)
    800044a0:	f84a                	sd	s2,48(sp)
    800044a2:	f44e                	sd	s3,40(sp)
    800044a4:	f052                	sd	s4,32(sp)
    800044a6:	ec56                	sd	s5,24(sp)
    800044a8:	e85a                	sd	s6,16(sp)
    800044aa:	e45e                	sd	s7,8(sp)
    800044ac:	e062                	sd	s8,0(sp)
    800044ae:	0880                	addi	s0,sp,80
    800044b0:	892a                	mv	s2,a0
    800044b2:	8aae                	mv	s5,a1
    800044b4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800044b6:	411c                	lw	a5,0(a0)
    800044b8:	4705                	li	a4,1
    800044ba:	02e78263          	beq	a5,a4,800044de <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044be:	470d                	li	a4,3
    800044c0:	02e78563          	beq	a5,a4,800044ea <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800044c4:	4709                	li	a4,2
    800044c6:	10e79463          	bne	a5,a4,800045ce <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800044ca:	0ec05e63          	blez	a2,800045c6 <filewrite+0x136>
    int i = 0;
    800044ce:	4981                	li	s3,0
    800044d0:	6b05                	lui	s6,0x1
    800044d2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800044d6:	6b85                	lui	s7,0x1
    800044d8:	c00b8b9b          	addiw	s7,s7,-1024
    800044dc:	a851                	j	80004570 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800044de:	6908                	ld	a0,16(a0)
    800044e0:	00000097          	auipc	ra,0x0
    800044e4:	254080e7          	jalr	596(ra) # 80004734 <pipewrite>
    800044e8:	a85d                	j	8000459e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800044ea:	02451783          	lh	a5,36(a0)
    800044ee:	03079693          	slli	a3,a5,0x30
    800044f2:	92c1                	srli	a3,a3,0x30
    800044f4:	4725                	li	a4,9
    800044f6:	0ed76663          	bltu	a4,a3,800045e2 <filewrite+0x152>
    800044fa:	0792                	slli	a5,a5,0x4
    800044fc:	0001c717          	auipc	a4,0x1c
    80004500:	54470713          	addi	a4,a4,1348 # 80020a40 <devsw>
    80004504:	97ba                	add	a5,a5,a4
    80004506:	679c                	ld	a5,8(a5)
    80004508:	cff9                	beqz	a5,800045e6 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    8000450a:	4505                	li	a0,1
    8000450c:	9782                	jalr	a5
    8000450e:	a841                	j	8000459e <filewrite+0x10e>
    80004510:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004514:	00000097          	auipc	ra,0x0
    80004518:	8ae080e7          	jalr	-1874(ra) # 80003dc2 <begin_op>
      ilock(f->ip);
    8000451c:	01893503          	ld	a0,24(s2)
    80004520:	fffff097          	auipc	ra,0xfffff
    80004524:	f0c080e7          	jalr	-244(ra) # 8000342c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004528:	8762                	mv	a4,s8
    8000452a:	02092683          	lw	a3,32(s2)
    8000452e:	01598633          	add	a2,s3,s5
    80004532:	4585                	li	a1,1
    80004534:	01893503          	ld	a0,24(s2)
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	278080e7          	jalr	632(ra) # 800037b0 <writei>
    80004540:	84aa                	mv	s1,a0
    80004542:	02a05f63          	blez	a0,80004580 <filewrite+0xf0>
        f->off += r;
    80004546:	02092783          	lw	a5,32(s2)
    8000454a:	9fa9                	addw	a5,a5,a0
    8000454c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004550:	01893503          	ld	a0,24(s2)
    80004554:	fffff097          	auipc	ra,0xfffff
    80004558:	f9a080e7          	jalr	-102(ra) # 800034ee <iunlock>
      end_op();
    8000455c:	00000097          	auipc	ra,0x0
    80004560:	8e6080e7          	jalr	-1818(ra) # 80003e42 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004564:	049c1963          	bne	s8,s1,800045b6 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004568:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000456c:	0349d663          	bge	s3,s4,80004598 <filewrite+0x108>
      int n1 = n - i;
    80004570:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004574:	84be                	mv	s1,a5
    80004576:	2781                	sext.w	a5,a5
    80004578:	f8fb5ce3          	bge	s6,a5,80004510 <filewrite+0x80>
    8000457c:	84de                	mv	s1,s7
    8000457e:	bf49                	j	80004510 <filewrite+0x80>
      iunlock(f->ip);
    80004580:	01893503          	ld	a0,24(s2)
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	f6a080e7          	jalr	-150(ra) # 800034ee <iunlock>
      end_op();
    8000458c:	00000097          	auipc	ra,0x0
    80004590:	8b6080e7          	jalr	-1866(ra) # 80003e42 <end_op>
      if(r < 0)
    80004594:	fc04d8e3          	bgez	s1,80004564 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004598:	8552                	mv	a0,s4
    8000459a:	033a1863          	bne	s4,s3,800045ca <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000459e:	60a6                	ld	ra,72(sp)
    800045a0:	6406                	ld	s0,64(sp)
    800045a2:	74e2                	ld	s1,56(sp)
    800045a4:	7942                	ld	s2,48(sp)
    800045a6:	79a2                	ld	s3,40(sp)
    800045a8:	7a02                	ld	s4,32(sp)
    800045aa:	6ae2                	ld	s5,24(sp)
    800045ac:	6b42                	ld	s6,16(sp)
    800045ae:	6ba2                	ld	s7,8(sp)
    800045b0:	6c02                	ld	s8,0(sp)
    800045b2:	6161                	addi	sp,sp,80
    800045b4:	8082                	ret
        panic("short filewrite");
    800045b6:	00002517          	auipc	a0,0x2
    800045ba:	0ca50513          	addi	a0,a0,202 # 80006680 <userret+0x5f0>
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	f90080e7          	jalr	-112(ra) # 8000054e <panic>
    int i = 0;
    800045c6:	4981                	li	s3,0
    800045c8:	bfc1                	j	80004598 <filewrite+0x108>
    ret = (i == n ? n : -1);
    800045ca:	557d                	li	a0,-1
    800045cc:	bfc9                	j	8000459e <filewrite+0x10e>
    panic("filewrite");
    800045ce:	00002517          	auipc	a0,0x2
    800045d2:	0c250513          	addi	a0,a0,194 # 80006690 <userret+0x600>
    800045d6:	ffffc097          	auipc	ra,0xffffc
    800045da:	f78080e7          	jalr	-136(ra) # 8000054e <panic>
    return -1;
    800045de:	557d                	li	a0,-1
}
    800045e0:	8082                	ret
      return -1;
    800045e2:	557d                	li	a0,-1
    800045e4:	bf6d                	j	8000459e <filewrite+0x10e>
    800045e6:	557d                	li	a0,-1
    800045e8:	bf5d                	j	8000459e <filewrite+0x10e>

00000000800045ea <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045ea:	7179                	addi	sp,sp,-48
    800045ec:	f406                	sd	ra,40(sp)
    800045ee:	f022                	sd	s0,32(sp)
    800045f0:	ec26                	sd	s1,24(sp)
    800045f2:	e84a                	sd	s2,16(sp)
    800045f4:	e44e                	sd	s3,8(sp)
    800045f6:	e052                	sd	s4,0(sp)
    800045f8:	1800                	addi	s0,sp,48
    800045fa:	84aa                	mv	s1,a0
    800045fc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045fe:	0005b023          	sd	zero,0(a1)
    80004602:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004606:	00000097          	auipc	ra,0x0
    8000460a:	bd2080e7          	jalr	-1070(ra) # 800041d8 <filealloc>
    8000460e:	e088                	sd	a0,0(s1)
    80004610:	c551                	beqz	a0,8000469c <pipealloc+0xb2>
    80004612:	00000097          	auipc	ra,0x0
    80004616:	bc6080e7          	jalr	-1082(ra) # 800041d8 <filealloc>
    8000461a:	00aa3023          	sd	a0,0(s4)
    8000461e:	c92d                	beqz	a0,80004690 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	340080e7          	jalr	832(ra) # 80000960 <kalloc>
    80004628:	892a                	mv	s2,a0
    8000462a:	c125                	beqz	a0,8000468a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000462c:	4985                	li	s3,1
    8000462e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004632:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004636:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000463a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000463e:	00002597          	auipc	a1,0x2
    80004642:	06258593          	addi	a1,a1,98 # 800066a0 <userret+0x610>
    80004646:	ffffc097          	auipc	ra,0xffffc
    8000464a:	37a080e7          	jalr	890(ra) # 800009c0 <initlock>
  (*f0)->type = FD_PIPE;
    8000464e:	609c                	ld	a5,0(s1)
    80004650:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004654:	609c                	ld	a5,0(s1)
    80004656:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000465a:	609c                	ld	a5,0(s1)
    8000465c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004660:	609c                	ld	a5,0(s1)
    80004662:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004666:	000a3783          	ld	a5,0(s4)
    8000466a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000466e:	000a3783          	ld	a5,0(s4)
    80004672:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004676:	000a3783          	ld	a5,0(s4)
    8000467a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000467e:	000a3783          	ld	a5,0(s4)
    80004682:	0127b823          	sd	s2,16(a5)
  return 0;
    80004686:	4501                	li	a0,0
    80004688:	a025                	j	800046b0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000468a:	6088                	ld	a0,0(s1)
    8000468c:	e501                	bnez	a0,80004694 <pipealloc+0xaa>
    8000468e:	a039                	j	8000469c <pipealloc+0xb2>
    80004690:	6088                	ld	a0,0(s1)
    80004692:	c51d                	beqz	a0,800046c0 <pipealloc+0xd6>
    fileclose(*f0);
    80004694:	00000097          	auipc	ra,0x0
    80004698:	c00080e7          	jalr	-1024(ra) # 80004294 <fileclose>
  if(*f1)
    8000469c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800046a0:	557d                	li	a0,-1
  if(*f1)
    800046a2:	c799                	beqz	a5,800046b0 <pipealloc+0xc6>
    fileclose(*f1);
    800046a4:	853e                	mv	a0,a5
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	bee080e7          	jalr	-1042(ra) # 80004294 <fileclose>
  return -1;
    800046ae:	557d                	li	a0,-1
}
    800046b0:	70a2                	ld	ra,40(sp)
    800046b2:	7402                	ld	s0,32(sp)
    800046b4:	64e2                	ld	s1,24(sp)
    800046b6:	6942                	ld	s2,16(sp)
    800046b8:	69a2                	ld	s3,8(sp)
    800046ba:	6a02                	ld	s4,0(sp)
    800046bc:	6145                	addi	sp,sp,48
    800046be:	8082                	ret
  return -1;
    800046c0:	557d                	li	a0,-1
    800046c2:	b7fd                	j	800046b0 <pipealloc+0xc6>

00000000800046c4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800046c4:	1101                	addi	sp,sp,-32
    800046c6:	ec06                	sd	ra,24(sp)
    800046c8:	e822                	sd	s0,16(sp)
    800046ca:	e426                	sd	s1,8(sp)
    800046cc:	e04a                	sd	s2,0(sp)
    800046ce:	1000                	addi	s0,sp,32
    800046d0:	84aa                	mv	s1,a0
    800046d2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800046d4:	ffffc097          	auipc	ra,0xffffc
    800046d8:	3fe080e7          	jalr	1022(ra) # 80000ad2 <acquire>
  if(writable){
    800046dc:	02090d63          	beqz	s2,80004716 <pipeclose+0x52>
    pi->writeopen = 0;
    800046e0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800046e4:	21848513          	addi	a0,s1,536
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	a84080e7          	jalr	-1404(ra) # 8000216c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800046f0:	2204b783          	ld	a5,544(s1)
    800046f4:	eb95                	bnez	a5,80004728 <pipeclose+0x64>
    release(&pi->lock);
    800046f6:	8526                	mv	a0,s1
    800046f8:	ffffc097          	auipc	ra,0xffffc
    800046fc:	42e080e7          	jalr	1070(ra) # 80000b26 <release>
    kfree((char*)pi);
    80004700:	8526                	mv	a0,s1
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	162080e7          	jalr	354(ra) # 80000864 <kfree>
  } else
    release(&pi->lock);
}
    8000470a:	60e2                	ld	ra,24(sp)
    8000470c:	6442                	ld	s0,16(sp)
    8000470e:	64a2                	ld	s1,8(sp)
    80004710:	6902                	ld	s2,0(sp)
    80004712:	6105                	addi	sp,sp,32
    80004714:	8082                	ret
    pi->readopen = 0;
    80004716:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000471a:	21c48513          	addi	a0,s1,540
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	a4e080e7          	jalr	-1458(ra) # 8000216c <wakeup>
    80004726:	b7e9                	j	800046f0 <pipeclose+0x2c>
    release(&pi->lock);
    80004728:	8526                	mv	a0,s1
    8000472a:	ffffc097          	auipc	ra,0xffffc
    8000472e:	3fc080e7          	jalr	1020(ra) # 80000b26 <release>
}
    80004732:	bfe1                	j	8000470a <pipeclose+0x46>

0000000080004734 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004734:	7159                	addi	sp,sp,-112
    80004736:	f486                	sd	ra,104(sp)
    80004738:	f0a2                	sd	s0,96(sp)
    8000473a:	eca6                	sd	s1,88(sp)
    8000473c:	e8ca                	sd	s2,80(sp)
    8000473e:	e4ce                	sd	s3,72(sp)
    80004740:	e0d2                	sd	s4,64(sp)
    80004742:	fc56                	sd	s5,56(sp)
    80004744:	f85a                	sd	s6,48(sp)
    80004746:	f45e                	sd	s7,40(sp)
    80004748:	f062                	sd	s8,32(sp)
    8000474a:	ec66                	sd	s9,24(sp)
    8000474c:	1880                	addi	s0,sp,112
    8000474e:	84aa                	mv	s1,a0
    80004750:	8b2e                	mv	s6,a1
    80004752:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004754:	ffffd097          	auipc	ra,0xffffd
    80004758:	0f0080e7          	jalr	240(ra) # 80001844 <myproc>
    8000475c:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    8000475e:	8526                	mv	a0,s1
    80004760:	ffffc097          	auipc	ra,0xffffc
    80004764:	372080e7          	jalr	882(ra) # 80000ad2 <acquire>
  for(i = 0; i < n; i++){
    80004768:	0b505063          	blez	s5,80004808 <pipewrite+0xd4>
    8000476c:	8926                	mv	s2,s1
    8000476e:	fffa8b9b          	addiw	s7,s5,-1
    80004772:	1b82                	slli	s7,s7,0x20
    80004774:	020bdb93          	srli	s7,s7,0x20
    80004778:	001b0793          	addi	a5,s6,1
    8000477c:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    8000477e:	21848a13          	addi	s4,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004782:	21c48993          	addi	s3,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004786:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004788:	2184a783          	lw	a5,536(s1)
    8000478c:	21c4a703          	lw	a4,540(s1)
    80004790:	2007879b          	addiw	a5,a5,512
    80004794:	02f71e63          	bne	a4,a5,800047d0 <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004798:	2204a783          	lw	a5,544(s1)
    8000479c:	c3d9                	beqz	a5,80004822 <pipewrite+0xee>
    8000479e:	ffffd097          	auipc	ra,0xffffd
    800047a2:	0a6080e7          	jalr	166(ra) # 80001844 <myproc>
    800047a6:	591c                	lw	a5,48(a0)
    800047a8:	efad                	bnez	a5,80004822 <pipewrite+0xee>
      wakeup(&pi->nread);
    800047aa:	8552                	mv	a0,s4
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	9c0080e7          	jalr	-1600(ra) # 8000216c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800047b4:	85ca                	mv	a1,s2
    800047b6:	854e                	mv	a0,s3
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	82e080e7          	jalr	-2002(ra) # 80001fe6 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800047c0:	2184a783          	lw	a5,536(s1)
    800047c4:	21c4a703          	lw	a4,540(s1)
    800047c8:	2007879b          	addiw	a5,a5,512
    800047cc:	fcf706e3          	beq	a4,a5,80004798 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800047d0:	4685                	li	a3,1
    800047d2:	865a                	mv	a2,s6
    800047d4:	f9f40593          	addi	a1,s0,-97
    800047d8:	050c3503          	ld	a0,80(s8)
    800047dc:	ffffd097          	auipc	ra,0xffffd
    800047e0:	de8080e7          	jalr	-536(ra) # 800015c4 <copyin>
    800047e4:	03950263          	beq	a0,s9,80004808 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800047e8:	21c4a783          	lw	a5,540(s1)
    800047ec:	0017871b          	addiw	a4,a5,1
    800047f0:	20e4ae23          	sw	a4,540(s1)
    800047f4:	1ff7f793          	andi	a5,a5,511
    800047f8:	97a6                	add	a5,a5,s1
    800047fa:	f9f44703          	lbu	a4,-97(s0)
    800047fe:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004802:	0b05                	addi	s6,s6,1
    80004804:	f97b12e3          	bne	s6,s7,80004788 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004808:	21848513          	addi	a0,s1,536
    8000480c:	ffffe097          	auipc	ra,0xffffe
    80004810:	960080e7          	jalr	-1696(ra) # 8000216c <wakeup>
  release(&pi->lock);
    80004814:	8526                	mv	a0,s1
    80004816:	ffffc097          	auipc	ra,0xffffc
    8000481a:	310080e7          	jalr	784(ra) # 80000b26 <release>
  return n;
    8000481e:	8556                	mv	a0,s5
    80004820:	a039                	j	8000482e <pipewrite+0xfa>
        release(&pi->lock);
    80004822:	8526                	mv	a0,s1
    80004824:	ffffc097          	auipc	ra,0xffffc
    80004828:	302080e7          	jalr	770(ra) # 80000b26 <release>
        return -1;
    8000482c:	557d                	li	a0,-1
}
    8000482e:	70a6                	ld	ra,104(sp)
    80004830:	7406                	ld	s0,96(sp)
    80004832:	64e6                	ld	s1,88(sp)
    80004834:	6946                	ld	s2,80(sp)
    80004836:	69a6                	ld	s3,72(sp)
    80004838:	6a06                	ld	s4,64(sp)
    8000483a:	7ae2                	ld	s5,56(sp)
    8000483c:	7b42                	ld	s6,48(sp)
    8000483e:	7ba2                	ld	s7,40(sp)
    80004840:	7c02                	ld	s8,32(sp)
    80004842:	6ce2                	ld	s9,24(sp)
    80004844:	6165                	addi	sp,sp,112
    80004846:	8082                	ret

0000000080004848 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004848:	715d                	addi	sp,sp,-80
    8000484a:	e486                	sd	ra,72(sp)
    8000484c:	e0a2                	sd	s0,64(sp)
    8000484e:	fc26                	sd	s1,56(sp)
    80004850:	f84a                	sd	s2,48(sp)
    80004852:	f44e                	sd	s3,40(sp)
    80004854:	f052                	sd	s4,32(sp)
    80004856:	ec56                	sd	s5,24(sp)
    80004858:	e85a                	sd	s6,16(sp)
    8000485a:	0880                	addi	s0,sp,80
    8000485c:	84aa                	mv	s1,a0
    8000485e:	892e                	mv	s2,a1
    80004860:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004862:	ffffd097          	auipc	ra,0xffffd
    80004866:	fe2080e7          	jalr	-30(ra) # 80001844 <myproc>
    8000486a:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    8000486c:	8b26                	mv	s6,s1
    8000486e:	8526                	mv	a0,s1
    80004870:	ffffc097          	auipc	ra,0xffffc
    80004874:	262080e7          	jalr	610(ra) # 80000ad2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004878:	2184a703          	lw	a4,536(s1)
    8000487c:	21c4a783          	lw	a5,540(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004880:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004884:	02f71763          	bne	a4,a5,800048b2 <piperead+0x6a>
    80004888:	2244a783          	lw	a5,548(s1)
    8000488c:	c39d                	beqz	a5,800048b2 <piperead+0x6a>
    if(myproc()->killed){
    8000488e:	ffffd097          	auipc	ra,0xffffd
    80004892:	fb6080e7          	jalr	-74(ra) # 80001844 <myproc>
    80004896:	591c                	lw	a5,48(a0)
    80004898:	ebc1                	bnez	a5,80004928 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000489a:	85da                	mv	a1,s6
    8000489c:	854e                	mv	a0,s3
    8000489e:	ffffd097          	auipc	ra,0xffffd
    800048a2:	748080e7          	jalr	1864(ra) # 80001fe6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800048a6:	2184a703          	lw	a4,536(s1)
    800048aa:	21c4a783          	lw	a5,540(s1)
    800048ae:	fcf70de3          	beq	a4,a5,80004888 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800048b2:	09405263          	blez	s4,80004936 <piperead+0xee>
    800048b6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800048b8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800048ba:	2184a783          	lw	a5,536(s1)
    800048be:	21c4a703          	lw	a4,540(s1)
    800048c2:	02f70d63          	beq	a4,a5,800048fc <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800048c6:	0017871b          	addiw	a4,a5,1
    800048ca:	20e4ac23          	sw	a4,536(s1)
    800048ce:	1ff7f793          	andi	a5,a5,511
    800048d2:	97a6                	add	a5,a5,s1
    800048d4:	0187c783          	lbu	a5,24(a5)
    800048d8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800048dc:	4685                	li	a3,1
    800048de:	fbf40613          	addi	a2,s0,-65
    800048e2:	85ca                	mv	a1,s2
    800048e4:	050ab503          	ld	a0,80(s5)
    800048e8:	ffffd097          	auipc	ra,0xffffd
    800048ec:	c50080e7          	jalr	-944(ra) # 80001538 <copyout>
    800048f0:	01650663          	beq	a0,s6,800048fc <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800048f4:	2985                	addiw	s3,s3,1
    800048f6:	0905                	addi	s2,s2,1
    800048f8:	fd3a11e3          	bne	s4,s3,800048ba <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800048fc:	21c48513          	addi	a0,s1,540
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	86c080e7          	jalr	-1940(ra) # 8000216c <wakeup>
  release(&pi->lock);
    80004908:	8526                	mv	a0,s1
    8000490a:	ffffc097          	auipc	ra,0xffffc
    8000490e:	21c080e7          	jalr	540(ra) # 80000b26 <release>
  return i;
}
    80004912:	854e                	mv	a0,s3
    80004914:	60a6                	ld	ra,72(sp)
    80004916:	6406                	ld	s0,64(sp)
    80004918:	74e2                	ld	s1,56(sp)
    8000491a:	7942                	ld	s2,48(sp)
    8000491c:	79a2                	ld	s3,40(sp)
    8000491e:	7a02                	ld	s4,32(sp)
    80004920:	6ae2                	ld	s5,24(sp)
    80004922:	6b42                	ld	s6,16(sp)
    80004924:	6161                	addi	sp,sp,80
    80004926:	8082                	ret
      release(&pi->lock);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffc097          	auipc	ra,0xffffc
    8000492e:	1fc080e7          	jalr	508(ra) # 80000b26 <release>
      return -1;
    80004932:	59fd                	li	s3,-1
    80004934:	bff9                	j	80004912 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004936:	4981                	li	s3,0
    80004938:	b7d1                	j	800048fc <piperead+0xb4>

000000008000493a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000493a:	df010113          	addi	sp,sp,-528
    8000493e:	20113423          	sd	ra,520(sp)
    80004942:	20813023          	sd	s0,512(sp)
    80004946:	ffa6                	sd	s1,504(sp)
    80004948:	fbca                	sd	s2,496(sp)
    8000494a:	f7ce                	sd	s3,488(sp)
    8000494c:	f3d2                	sd	s4,480(sp)
    8000494e:	efd6                	sd	s5,472(sp)
    80004950:	ebda                	sd	s6,464(sp)
    80004952:	e7de                	sd	s7,456(sp)
    80004954:	e3e2                	sd	s8,448(sp)
    80004956:	ff66                	sd	s9,440(sp)
    80004958:	fb6a                	sd	s10,432(sp)
    8000495a:	f76e                	sd	s11,424(sp)
    8000495c:	0c00                	addi	s0,sp,528
    8000495e:	84aa                	mv	s1,a0
    80004960:	dea43c23          	sd	a0,-520(s0)
    80004964:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004968:	ffffd097          	auipc	ra,0xffffd
    8000496c:	edc080e7          	jalr	-292(ra) # 80001844 <myproc>
    80004970:	892a                	mv	s2,a0

  begin_op();
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	450080e7          	jalr	1104(ra) # 80003dc2 <begin_op>

  if((ip = namei(path)) == 0){
    8000497a:	8526                	mv	a0,s1
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	23a080e7          	jalr	570(ra) # 80003bb6 <namei>
    80004984:	c92d                	beqz	a0,800049f6 <exec+0xbc>
    80004986:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	aa4080e7          	jalr	-1372(ra) # 8000342c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004990:	04000713          	li	a4,64
    80004994:	4681                	li	a3,0
    80004996:	e4840613          	addi	a2,s0,-440
    8000499a:	4581                	li	a1,0
    8000499c:	8526                	mv	a0,s1
    8000499e:	fffff097          	auipc	ra,0xfffff
    800049a2:	d1e080e7          	jalr	-738(ra) # 800036bc <readi>
    800049a6:	04000793          	li	a5,64
    800049aa:	00f51a63          	bne	a0,a5,800049be <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800049ae:	e4842703          	lw	a4,-440(s0)
    800049b2:	464c47b7          	lui	a5,0x464c4
    800049b6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800049ba:	04f70463          	beq	a4,a5,80004a02 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800049be:	8526                	mv	a0,s1
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	caa080e7          	jalr	-854(ra) # 8000366a <iunlockput>
    end_op();
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	47a080e7          	jalr	1146(ra) # 80003e42 <end_op>
  }
  return -1;
    800049d0:	557d                	li	a0,-1
}
    800049d2:	20813083          	ld	ra,520(sp)
    800049d6:	20013403          	ld	s0,512(sp)
    800049da:	74fe                	ld	s1,504(sp)
    800049dc:	795e                	ld	s2,496(sp)
    800049de:	79be                	ld	s3,488(sp)
    800049e0:	7a1e                	ld	s4,480(sp)
    800049e2:	6afe                	ld	s5,472(sp)
    800049e4:	6b5e                	ld	s6,464(sp)
    800049e6:	6bbe                	ld	s7,456(sp)
    800049e8:	6c1e                	ld	s8,448(sp)
    800049ea:	7cfa                	ld	s9,440(sp)
    800049ec:	7d5a                	ld	s10,432(sp)
    800049ee:	7dba                	ld	s11,424(sp)
    800049f0:	21010113          	addi	sp,sp,528
    800049f4:	8082                	ret
    end_op();
    800049f6:	fffff097          	auipc	ra,0xfffff
    800049fa:	44c080e7          	jalr	1100(ra) # 80003e42 <end_op>
    return -1;
    800049fe:	557d                	li	a0,-1
    80004a00:	bfc9                	j	800049d2 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004a02:	854a                	mv	a0,s2
    80004a04:	ffffd097          	auipc	ra,0xffffd
    80004a08:	f04080e7          	jalr	-252(ra) # 80001908 <proc_pagetable>
    80004a0c:	8c2a                	mv	s8,a0
    80004a0e:	d945                	beqz	a0,800049be <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a10:	e6842983          	lw	s3,-408(s0)
    80004a14:	e8045783          	lhu	a5,-384(s0)
    80004a18:	c7fd                	beqz	a5,80004b06 <exec+0x1cc>
  sz = 0;
    80004a1a:	e0043423          	sd	zero,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a1e:	4b81                	li	s7,0
    if(ph.vaddr % PGSIZE != 0)
    80004a20:	6b05                	lui	s6,0x1
    80004a22:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004a26:	def43823          	sd	a5,-528(s0)
    80004a2a:	a0a5                	j	80004a92 <exec+0x158>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004a2c:	00002517          	auipc	a0,0x2
    80004a30:	c7c50513          	addi	a0,a0,-900 # 800066a8 <userret+0x618>
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	b1a080e7          	jalr	-1254(ra) # 8000054e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004a3c:	8756                	mv	a4,s5
    80004a3e:	012d86bb          	addw	a3,s11,s2
    80004a42:	4581                	li	a1,0
    80004a44:	8526                	mv	a0,s1
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	c76080e7          	jalr	-906(ra) # 800036bc <readi>
    80004a4e:	2501                	sext.w	a0,a0
    80004a50:	10aa9163          	bne	s5,a0,80004b52 <exec+0x218>
  for(i = 0; i < sz; i += PGSIZE){
    80004a54:	6785                	lui	a5,0x1
    80004a56:	0127893b          	addw	s2,a5,s2
    80004a5a:	77fd                	lui	a5,0xfffff
    80004a5c:	01478a3b          	addw	s4,a5,s4
    80004a60:	03997263          	bgeu	s2,s9,80004a84 <exec+0x14a>
    pa = walkaddr(pagetable, va + i);
    80004a64:	02091593          	slli	a1,s2,0x20
    80004a68:	9181                	srli	a1,a1,0x20
    80004a6a:	95ea                	add	a1,a1,s10
    80004a6c:	8562                	mv	a0,s8
    80004a6e:	ffffc097          	auipc	ra,0xffffc
    80004a72:	4fc080e7          	jalr	1276(ra) # 80000f6a <walkaddr>
    80004a76:	862a                	mv	a2,a0
    if(pa == 0)
    80004a78:	d955                	beqz	a0,80004a2c <exec+0xf2>
      n = PGSIZE;
    80004a7a:	8ada                	mv	s5,s6
    if(sz - i < PGSIZE)
    80004a7c:	fd6a70e3          	bgeu	s4,s6,80004a3c <exec+0x102>
      n = sz - i;
    80004a80:	8ad2                	mv	s5,s4
    80004a82:	bf6d                	j	80004a3c <exec+0x102>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a84:	2b85                	addiw	s7,s7,1
    80004a86:	0389899b          	addiw	s3,s3,56
    80004a8a:	e8045783          	lhu	a5,-384(s0)
    80004a8e:	06fbde63          	bge	s7,a5,80004b0a <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004a92:	2981                	sext.w	s3,s3
    80004a94:	03800713          	li	a4,56
    80004a98:	86ce                	mv	a3,s3
    80004a9a:	e1040613          	addi	a2,s0,-496
    80004a9e:	4581                	li	a1,0
    80004aa0:	8526                	mv	a0,s1
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	c1a080e7          	jalr	-998(ra) # 800036bc <readi>
    80004aaa:	03800793          	li	a5,56
    80004aae:	0af51263          	bne	a0,a5,80004b52 <exec+0x218>
    if(ph.type != ELF_PROG_LOAD)
    80004ab2:	e1042783          	lw	a5,-496(s0)
    80004ab6:	4705                	li	a4,1
    80004ab8:	fce796e3          	bne	a5,a4,80004a84 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80004abc:	e3843603          	ld	a2,-456(s0)
    80004ac0:	e3043783          	ld	a5,-464(s0)
    80004ac4:	08f66763          	bltu	a2,a5,80004b52 <exec+0x218>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004ac8:	e2043783          	ld	a5,-480(s0)
    80004acc:	963e                	add	a2,a2,a5
    80004ace:	08f66263          	bltu	a2,a5,80004b52 <exec+0x218>
    if((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004ad2:	e0843583          	ld	a1,-504(s0)
    80004ad6:	8562                	mv	a0,s8
    80004ad8:	ffffd097          	auipc	ra,0xffffd
    80004adc:	886080e7          	jalr	-1914(ra) # 8000135e <uvmalloc>
    80004ae0:	e0a43423          	sd	a0,-504(s0)
    80004ae4:	c53d                	beqz	a0,80004b52 <exec+0x218>
    if(ph.vaddr % PGSIZE != 0)
    80004ae6:	e2043d03          	ld	s10,-480(s0)
    80004aea:	df043783          	ld	a5,-528(s0)
    80004aee:	00fd77b3          	and	a5,s10,a5
    80004af2:	e3a5                	bnez	a5,80004b52 <exec+0x218>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004af4:	e1842d83          	lw	s11,-488(s0)
    80004af8:	e3042c83          	lw	s9,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004afc:	f80c84e3          	beqz	s9,80004a84 <exec+0x14a>
    80004b00:	8a66                	mv	s4,s9
    80004b02:	4901                	li	s2,0
    80004b04:	b785                	j	80004a64 <exec+0x12a>
  sz = 0;
    80004b06:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	b5e080e7          	jalr	-1186(ra) # 8000366a <iunlockput>
  end_op();
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	32e080e7          	jalr	814(ra) # 80003e42 <end_op>
  p = myproc();
    80004b1c:	ffffd097          	auipc	ra,0xffffd
    80004b20:	d28080e7          	jalr	-728(ra) # 80001844 <myproc>
    80004b24:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004b26:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004b2a:	6585                	lui	a1,0x1
    80004b2c:	15fd                	addi	a1,a1,-1
    80004b2e:	e0843783          	ld	a5,-504(s0)
    80004b32:	00b78b33          	add	s6,a5,a1
    80004b36:	75fd                	lui	a1,0xfffff
    80004b38:	00bb75b3          	and	a1,s6,a1
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004b3c:	6609                	lui	a2,0x2
    80004b3e:	962e                	add	a2,a2,a1
    80004b40:	8562                	mv	a0,s8
    80004b42:	ffffd097          	auipc	ra,0xffffd
    80004b46:	81c080e7          	jalr	-2020(ra) # 8000135e <uvmalloc>
    80004b4a:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    80004b4e:	4481                	li	s1,0
  if((sz = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004b50:	ed01                	bnez	a0,80004b68 <exec+0x22e>
    proc_freepagetable(pagetable, sz);
    80004b52:	e0843583          	ld	a1,-504(s0)
    80004b56:	8562                	mv	a0,s8
    80004b58:	ffffd097          	auipc	ra,0xffffd
    80004b5c:	eb0080e7          	jalr	-336(ra) # 80001a08 <proc_freepagetable>
  if(ip){
    80004b60:	e4049fe3          	bnez	s1,800049be <exec+0x84>
  return -1;
    80004b64:	557d                	li	a0,-1
    80004b66:	b5b5                	j	800049d2 <exec+0x98>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004b68:	75f9                	lui	a1,0xffffe
    80004b6a:	84aa                	mv	s1,a0
    80004b6c:	95aa                	add	a1,a1,a0
    80004b6e:	8562                	mv	a0,s8
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	996080e7          	jalr	-1642(ra) # 80001506 <uvmclear>
  stackbase = sp - PGSIZE;
    80004b78:	7afd                	lui	s5,0xfffff
    80004b7a:	9aa6                	add	s5,s5,s1
  for(argc = 0; argv[argc]; argc++) {
    80004b7c:	e0043783          	ld	a5,-512(s0)
    80004b80:	6388                	ld	a0,0(a5)
    80004b82:	c135                	beqz	a0,80004be6 <exec+0x2ac>
    80004b84:	e8840993          	addi	s3,s0,-376
    80004b88:	f8840c93          	addi	s9,s0,-120
    80004b8c:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    80004b8e:	ffffc097          	auipc	ra,0xffffc
    80004b92:	168080e7          	jalr	360(ra) # 80000cf6 <strlen>
    80004b96:	2505                	addiw	a0,a0,1
    80004b98:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004b9a:	98c1                	andi	s1,s1,-16
    if(sp < stackbase)
    80004b9c:	0f54ea63          	bltu	s1,s5,80004c90 <exec+0x356>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004ba0:	e0043b03          	ld	s6,-512(s0)
    80004ba4:	000b3a03          	ld	s4,0(s6)
    80004ba8:	8552                	mv	a0,s4
    80004baa:	ffffc097          	auipc	ra,0xffffc
    80004bae:	14c080e7          	jalr	332(ra) # 80000cf6 <strlen>
    80004bb2:	0015069b          	addiw	a3,a0,1
    80004bb6:	8652                	mv	a2,s4
    80004bb8:	85a6                	mv	a1,s1
    80004bba:	8562                	mv	a0,s8
    80004bbc:	ffffd097          	auipc	ra,0xffffd
    80004bc0:	97c080e7          	jalr	-1668(ra) # 80001538 <copyout>
    80004bc4:	0c054863          	bltz	a0,80004c94 <exec+0x35a>
    ustack[argc] = sp;
    80004bc8:	0099b023          	sd	s1,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004bcc:	0905                	addi	s2,s2,1
    80004bce:	008b0793          	addi	a5,s6,8
    80004bd2:	e0f43023          	sd	a5,-512(s0)
    80004bd6:	008b3503          	ld	a0,8(s6)
    80004bda:	c909                	beqz	a0,80004bec <exec+0x2b2>
    if(argc >= MAXARG)
    80004bdc:	09a1                	addi	s3,s3,8
    80004bde:	fb3c98e3          	bne	s9,s3,80004b8e <exec+0x254>
  ip = 0;
    80004be2:	4481                	li	s1,0
    80004be4:	b7bd                	j	80004b52 <exec+0x218>
  sp = sz;
    80004be6:	e0843483          	ld	s1,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004bea:	4901                	li	s2,0
  ustack[argc] = 0;
    80004bec:	00391793          	slli	a5,s2,0x3
    80004bf0:	f9040713          	addi	a4,s0,-112
    80004bf4:	97ba                	add	a5,a5,a4
    80004bf6:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd9edc>
  sp -= (argc+1) * sizeof(uint64);
    80004bfa:	00190693          	addi	a3,s2,1
    80004bfe:	068e                	slli	a3,a3,0x3
    80004c00:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80004c02:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80004c06:	4481                	li	s1,0
  if(sp < stackbase)
    80004c08:	f559e5e3          	bltu	s3,s5,80004b52 <exec+0x218>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004c0c:	e8840613          	addi	a2,s0,-376
    80004c10:	85ce                	mv	a1,s3
    80004c12:	8562                	mv	a0,s8
    80004c14:	ffffd097          	auipc	ra,0xffffd
    80004c18:	924080e7          	jalr	-1756(ra) # 80001538 <copyout>
    80004c1c:	06054e63          	bltz	a0,80004c98 <exec+0x35e>
  p->tf->a1 = sp;
    80004c20:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004c24:	0737bc23          	sd	s3,120(a5)
  for(last=s=path; *s; s++)
    80004c28:	df843783          	ld	a5,-520(s0)
    80004c2c:	0007c703          	lbu	a4,0(a5)
    80004c30:	cf11                	beqz	a4,80004c4c <exec+0x312>
    80004c32:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004c34:	02f00693          	li	a3,47
    80004c38:	a029                	j	80004c42 <exec+0x308>
  for(last=s=path; *s; s++)
    80004c3a:	0785                	addi	a5,a5,1
    80004c3c:	fff7c703          	lbu	a4,-1(a5)
    80004c40:	c711                	beqz	a4,80004c4c <exec+0x312>
    if(*s == '/')
    80004c42:	fed71ce3          	bne	a4,a3,80004c3a <exec+0x300>
      last = s+1;
    80004c46:	def43c23          	sd	a5,-520(s0)
    80004c4a:	bfc5                	j	80004c3a <exec+0x300>
  safestrcpy(p->name, last, sizeof(p->name));
    80004c4c:	4641                	li	a2,16
    80004c4e:	df843583          	ld	a1,-520(s0)
    80004c52:	158b8513          	addi	a0,s7,344
    80004c56:	ffffc097          	auipc	ra,0xffffc
    80004c5a:	06e080e7          	jalr	110(ra) # 80000cc4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004c5e:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004c62:	058bb823          	sd	s8,80(s7)
  p->sz = sz;
    80004c66:	e0843783          	ld	a5,-504(s0)
    80004c6a:	04fbb423          	sd	a5,72(s7)
  p->tf->epc = elf.entry;  // initial program counter = main
    80004c6e:	058bb783          	ld	a5,88(s7)
    80004c72:	e6043703          	ld	a4,-416(s0)
    80004c76:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp; // initial stack pointer
    80004c78:	058bb783          	ld	a5,88(s7)
    80004c7c:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004c80:	85ea                	mv	a1,s10
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	d86080e7          	jalr	-634(ra) # 80001a08 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004c8a:	0009051b          	sext.w	a0,s2
    80004c8e:	b391                	j	800049d2 <exec+0x98>
  ip = 0;
    80004c90:	4481                	li	s1,0
    80004c92:	b5c1                	j	80004b52 <exec+0x218>
    80004c94:	4481                	li	s1,0
    80004c96:	bd75                	j	80004b52 <exec+0x218>
    80004c98:	4481                	li	s1,0
    80004c9a:	bd65                	j	80004b52 <exec+0x218>

0000000080004c9c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c9c:	7179                	addi	sp,sp,-48
    80004c9e:	f406                	sd	ra,40(sp)
    80004ca0:	f022                	sd	s0,32(sp)
    80004ca2:	ec26                	sd	s1,24(sp)
    80004ca4:	e84a                	sd	s2,16(sp)
    80004ca6:	1800                	addi	s0,sp,48
    80004ca8:	892e                	mv	s2,a1
    80004caa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004cac:	fdc40593          	addi	a1,s0,-36
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	c0a080e7          	jalr	-1014(ra) # 800028ba <argint>
    80004cb8:	04054063          	bltz	a0,80004cf8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004cbc:	fdc42703          	lw	a4,-36(s0)
    80004cc0:	47bd                	li	a5,15
    80004cc2:	02e7ed63          	bltu	a5,a4,80004cfc <argfd+0x60>
    80004cc6:	ffffd097          	auipc	ra,0xffffd
    80004cca:	b7e080e7          	jalr	-1154(ra) # 80001844 <myproc>
    80004cce:	fdc42703          	lw	a4,-36(s0)
    80004cd2:	01a70793          	addi	a5,a4,26
    80004cd6:	078e                	slli	a5,a5,0x3
    80004cd8:	953e                	add	a0,a0,a5
    80004cda:	611c                	ld	a5,0(a0)
    80004cdc:	c395                	beqz	a5,80004d00 <argfd+0x64>
    return -1;
  if(pfd)
    80004cde:	00090463          	beqz	s2,80004ce6 <argfd+0x4a>
    *pfd = fd;
    80004ce2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004ce6:	4501                	li	a0,0
  if(pf)
    80004ce8:	c091                	beqz	s1,80004cec <argfd+0x50>
    *pf = f;
    80004cea:	e09c                	sd	a5,0(s1)
}
    80004cec:	70a2                	ld	ra,40(sp)
    80004cee:	7402                	ld	s0,32(sp)
    80004cf0:	64e2                	ld	s1,24(sp)
    80004cf2:	6942                	ld	s2,16(sp)
    80004cf4:	6145                	addi	sp,sp,48
    80004cf6:	8082                	ret
    return -1;
    80004cf8:	557d                	li	a0,-1
    80004cfa:	bfcd                	j	80004cec <argfd+0x50>
    return -1;
    80004cfc:	557d                	li	a0,-1
    80004cfe:	b7fd                	j	80004cec <argfd+0x50>
    80004d00:	557d                	li	a0,-1
    80004d02:	b7ed                	j	80004cec <argfd+0x50>

0000000080004d04 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004d04:	1101                	addi	sp,sp,-32
    80004d06:	ec06                	sd	ra,24(sp)
    80004d08:	e822                	sd	s0,16(sp)
    80004d0a:	e426                	sd	s1,8(sp)
    80004d0c:	1000                	addi	s0,sp,32
    80004d0e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004d10:	ffffd097          	auipc	ra,0xffffd
    80004d14:	b34080e7          	jalr	-1228(ra) # 80001844 <myproc>
    80004d18:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004d1a:	0d050793          	addi	a5,a0,208
    80004d1e:	4501                	li	a0,0
    80004d20:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004d22:	6398                	ld	a4,0(a5)
    80004d24:	cb19                	beqz	a4,80004d3a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004d26:	2505                	addiw	a0,a0,1
    80004d28:	07a1                	addi	a5,a5,8
    80004d2a:	fed51ce3          	bne	a0,a3,80004d22 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004d2e:	557d                	li	a0,-1
}
    80004d30:	60e2                	ld	ra,24(sp)
    80004d32:	6442                	ld	s0,16(sp)
    80004d34:	64a2                	ld	s1,8(sp)
    80004d36:	6105                	addi	sp,sp,32
    80004d38:	8082                	ret
      p->ofile[fd] = f;
    80004d3a:	01a50793          	addi	a5,a0,26
    80004d3e:	078e                	slli	a5,a5,0x3
    80004d40:	963e                	add	a2,a2,a5
    80004d42:	e204                	sd	s1,0(a2)
      return fd;
    80004d44:	b7f5                	j	80004d30 <fdalloc+0x2c>

0000000080004d46 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004d46:	715d                	addi	sp,sp,-80
    80004d48:	e486                	sd	ra,72(sp)
    80004d4a:	e0a2                	sd	s0,64(sp)
    80004d4c:	fc26                	sd	s1,56(sp)
    80004d4e:	f84a                	sd	s2,48(sp)
    80004d50:	f44e                	sd	s3,40(sp)
    80004d52:	f052                	sd	s4,32(sp)
    80004d54:	ec56                	sd	s5,24(sp)
    80004d56:	0880                	addi	s0,sp,80
    80004d58:	89ae                	mv	s3,a1
    80004d5a:	8ab2                	mv	s5,a2
    80004d5c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004d5e:	fb040593          	addi	a1,s0,-80
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	e72080e7          	jalr	-398(ra) # 80003bd4 <nameiparent>
    80004d6a:	892a                	mv	s2,a0
    80004d6c:	12050f63          	beqz	a0,80004eaa <create+0x164>
    return 0;

  ilock(dp);
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	6bc080e7          	jalr	1724(ra) # 8000342c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004d78:	4601                	li	a2,0
    80004d7a:	fb040593          	addi	a1,s0,-80
    80004d7e:	854a                	mv	a0,s2
    80004d80:	fffff097          	auipc	ra,0xfffff
    80004d84:	b64080e7          	jalr	-1180(ra) # 800038e4 <dirlookup>
    80004d88:	84aa                	mv	s1,a0
    80004d8a:	c921                	beqz	a0,80004dda <create+0x94>
    iunlockput(dp);
    80004d8c:	854a                	mv	a0,s2
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	8dc080e7          	jalr	-1828(ra) # 8000366a <iunlockput>
    ilock(ip);
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	694080e7          	jalr	1684(ra) # 8000342c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004da0:	2981                	sext.w	s3,s3
    80004da2:	4789                	li	a5,2
    80004da4:	02f99463          	bne	s3,a5,80004dcc <create+0x86>
    80004da8:	0444d783          	lhu	a5,68(s1)
    80004dac:	37f9                	addiw	a5,a5,-2
    80004dae:	17c2                	slli	a5,a5,0x30
    80004db0:	93c1                	srli	a5,a5,0x30
    80004db2:	4705                	li	a4,1
    80004db4:	00f76c63          	bltu	a4,a5,80004dcc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004db8:	8526                	mv	a0,s1
    80004dba:	60a6                	ld	ra,72(sp)
    80004dbc:	6406                	ld	s0,64(sp)
    80004dbe:	74e2                	ld	s1,56(sp)
    80004dc0:	7942                	ld	s2,48(sp)
    80004dc2:	79a2                	ld	s3,40(sp)
    80004dc4:	7a02                	ld	s4,32(sp)
    80004dc6:	6ae2                	ld	s5,24(sp)
    80004dc8:	6161                	addi	sp,sp,80
    80004dca:	8082                	ret
    iunlockput(ip);
    80004dcc:	8526                	mv	a0,s1
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	89c080e7          	jalr	-1892(ra) # 8000366a <iunlockput>
    return 0;
    80004dd6:	4481                	li	s1,0
    80004dd8:	b7c5                	j	80004db8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004dda:	85ce                	mv	a1,s3
    80004ddc:	00092503          	lw	a0,0(s2)
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	4b4080e7          	jalr	1204(ra) # 80003294 <ialloc>
    80004de8:	84aa                	mv	s1,a0
    80004dea:	c529                	beqz	a0,80004e34 <create+0xee>
  ilock(ip);
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	640080e7          	jalr	1600(ra) # 8000342c <ilock>
  ip->major = major;
    80004df4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004df8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004dfc:	4785                	li	a5,1
    80004dfe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e02:	8526                	mv	a0,s1
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	55e080e7          	jalr	1374(ra) # 80003362 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004e0c:	2981                	sext.w	s3,s3
    80004e0e:	4785                	li	a5,1
    80004e10:	02f98a63          	beq	s3,a5,80004e44 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004e14:	40d0                	lw	a2,4(s1)
    80004e16:	fb040593          	addi	a1,s0,-80
    80004e1a:	854a                	mv	a0,s2
    80004e1c:	fffff097          	auipc	ra,0xfffff
    80004e20:	cd8080e7          	jalr	-808(ra) # 80003af4 <dirlink>
    80004e24:	06054b63          	bltz	a0,80004e9a <create+0x154>
  iunlockput(dp);
    80004e28:	854a                	mv	a0,s2
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	840080e7          	jalr	-1984(ra) # 8000366a <iunlockput>
  return ip;
    80004e32:	b759                	j	80004db8 <create+0x72>
    panic("create: ialloc");
    80004e34:	00002517          	auipc	a0,0x2
    80004e38:	89450513          	addi	a0,a0,-1900 # 800066c8 <userret+0x638>
    80004e3c:	ffffb097          	auipc	ra,0xffffb
    80004e40:	712080e7          	jalr	1810(ra) # 8000054e <panic>
    dp->nlink++;  // for ".."
    80004e44:	04a95783          	lhu	a5,74(s2)
    80004e48:	2785                	addiw	a5,a5,1
    80004e4a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004e4e:	854a                	mv	a0,s2
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	512080e7          	jalr	1298(ra) # 80003362 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004e58:	40d0                	lw	a2,4(s1)
    80004e5a:	00002597          	auipc	a1,0x2
    80004e5e:	87e58593          	addi	a1,a1,-1922 # 800066d8 <userret+0x648>
    80004e62:	8526                	mv	a0,s1
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	c90080e7          	jalr	-880(ra) # 80003af4 <dirlink>
    80004e6c:	00054f63          	bltz	a0,80004e8a <create+0x144>
    80004e70:	00492603          	lw	a2,4(s2)
    80004e74:	00002597          	auipc	a1,0x2
    80004e78:	86c58593          	addi	a1,a1,-1940 # 800066e0 <userret+0x650>
    80004e7c:	8526                	mv	a0,s1
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	c76080e7          	jalr	-906(ra) # 80003af4 <dirlink>
    80004e86:	f80557e3          	bgez	a0,80004e14 <create+0xce>
      panic("create dots");
    80004e8a:	00002517          	auipc	a0,0x2
    80004e8e:	85e50513          	addi	a0,a0,-1954 # 800066e8 <userret+0x658>
    80004e92:	ffffb097          	auipc	ra,0xffffb
    80004e96:	6bc080e7          	jalr	1724(ra) # 8000054e <panic>
    panic("create: dirlink");
    80004e9a:	00002517          	auipc	a0,0x2
    80004e9e:	85e50513          	addi	a0,a0,-1954 # 800066f8 <userret+0x668>
    80004ea2:	ffffb097          	auipc	ra,0xffffb
    80004ea6:	6ac080e7          	jalr	1708(ra) # 8000054e <panic>
    return 0;
    80004eaa:	84aa                	mv	s1,a0
    80004eac:	b731                	j	80004db8 <create+0x72>

0000000080004eae <sys_dup>:
{
    80004eae:	7179                	addi	sp,sp,-48
    80004eb0:	f406                	sd	ra,40(sp)
    80004eb2:	f022                	sd	s0,32(sp)
    80004eb4:	ec26                	sd	s1,24(sp)
    80004eb6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004eb8:	fd840613          	addi	a2,s0,-40
    80004ebc:	4581                	li	a1,0
    80004ebe:	4501                	li	a0,0
    80004ec0:	00000097          	auipc	ra,0x0
    80004ec4:	ddc080e7          	jalr	-548(ra) # 80004c9c <argfd>
    return -1;
    80004ec8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004eca:	02054363          	bltz	a0,80004ef0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004ece:	fd843503          	ld	a0,-40(s0)
    80004ed2:	00000097          	auipc	ra,0x0
    80004ed6:	e32080e7          	jalr	-462(ra) # 80004d04 <fdalloc>
    80004eda:	84aa                	mv	s1,a0
    return -1;
    80004edc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004ede:	00054963          	bltz	a0,80004ef0 <sys_dup+0x42>
  filedup(f);
    80004ee2:	fd843503          	ld	a0,-40(s0)
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	35c080e7          	jalr	860(ra) # 80004242 <filedup>
  return fd;
    80004eee:	87a6                	mv	a5,s1
}
    80004ef0:	853e                	mv	a0,a5
    80004ef2:	70a2                	ld	ra,40(sp)
    80004ef4:	7402                	ld	s0,32(sp)
    80004ef6:	64e2                	ld	s1,24(sp)
    80004ef8:	6145                	addi	sp,sp,48
    80004efa:	8082                	ret

0000000080004efc <sys_read>:
{
    80004efc:	7179                	addi	sp,sp,-48
    80004efe:	f406                	sd	ra,40(sp)
    80004f00:	f022                	sd	s0,32(sp)
    80004f02:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f04:	fe840613          	addi	a2,s0,-24
    80004f08:	4581                	li	a1,0
    80004f0a:	4501                	li	a0,0
    80004f0c:	00000097          	auipc	ra,0x0
    80004f10:	d90080e7          	jalr	-624(ra) # 80004c9c <argfd>
    return -1;
    80004f14:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f16:	04054163          	bltz	a0,80004f58 <sys_read+0x5c>
    80004f1a:	fe440593          	addi	a1,s0,-28
    80004f1e:	4509                	li	a0,2
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	99a080e7          	jalr	-1638(ra) # 800028ba <argint>
    return -1;
    80004f28:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f2a:	02054763          	bltz	a0,80004f58 <sys_read+0x5c>
    80004f2e:	fd840593          	addi	a1,s0,-40
    80004f32:	4505                	li	a0,1
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	9a8080e7          	jalr	-1624(ra) # 800028dc <argaddr>
    return -1;
    80004f3c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f3e:	00054d63          	bltz	a0,80004f58 <sys_read+0x5c>
  return fileread(f, p, n);
    80004f42:	fe442603          	lw	a2,-28(s0)
    80004f46:	fd843583          	ld	a1,-40(s0)
    80004f4a:	fe843503          	ld	a0,-24(s0)
    80004f4e:	fffff097          	auipc	ra,0xfffff
    80004f52:	480080e7          	jalr	1152(ra) # 800043ce <fileread>
    80004f56:	87aa                	mv	a5,a0
}
    80004f58:	853e                	mv	a0,a5
    80004f5a:	70a2                	ld	ra,40(sp)
    80004f5c:	7402                	ld	s0,32(sp)
    80004f5e:	6145                	addi	sp,sp,48
    80004f60:	8082                	ret

0000000080004f62 <sys_write>:
{
    80004f62:	7179                	addi	sp,sp,-48
    80004f64:	f406                	sd	ra,40(sp)
    80004f66:	f022                	sd	s0,32(sp)
    80004f68:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f6a:	fe840613          	addi	a2,s0,-24
    80004f6e:	4581                	li	a1,0
    80004f70:	4501                	li	a0,0
    80004f72:	00000097          	auipc	ra,0x0
    80004f76:	d2a080e7          	jalr	-726(ra) # 80004c9c <argfd>
    return -1;
    80004f7a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f7c:	04054163          	bltz	a0,80004fbe <sys_write+0x5c>
    80004f80:	fe440593          	addi	a1,s0,-28
    80004f84:	4509                	li	a0,2
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	934080e7          	jalr	-1740(ra) # 800028ba <argint>
    return -1;
    80004f8e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004f90:	02054763          	bltz	a0,80004fbe <sys_write+0x5c>
    80004f94:	fd840593          	addi	a1,s0,-40
    80004f98:	4505                	li	a0,1
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	942080e7          	jalr	-1726(ra) # 800028dc <argaddr>
    return -1;
    80004fa2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004fa4:	00054d63          	bltz	a0,80004fbe <sys_write+0x5c>
  return filewrite(f, p, n);
    80004fa8:	fe442603          	lw	a2,-28(s0)
    80004fac:	fd843583          	ld	a1,-40(s0)
    80004fb0:	fe843503          	ld	a0,-24(s0)
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	4dc080e7          	jalr	1244(ra) # 80004490 <filewrite>
    80004fbc:	87aa                	mv	a5,a0
}
    80004fbe:	853e                	mv	a0,a5
    80004fc0:	70a2                	ld	ra,40(sp)
    80004fc2:	7402                	ld	s0,32(sp)
    80004fc4:	6145                	addi	sp,sp,48
    80004fc6:	8082                	ret

0000000080004fc8 <sys_close>:
{
    80004fc8:	1101                	addi	sp,sp,-32
    80004fca:	ec06                	sd	ra,24(sp)
    80004fcc:	e822                	sd	s0,16(sp)
    80004fce:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004fd0:	fe040613          	addi	a2,s0,-32
    80004fd4:	fec40593          	addi	a1,s0,-20
    80004fd8:	4501                	li	a0,0
    80004fda:	00000097          	auipc	ra,0x0
    80004fde:	cc2080e7          	jalr	-830(ra) # 80004c9c <argfd>
    return -1;
    80004fe2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004fe4:	02054463          	bltz	a0,8000500c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	85c080e7          	jalr	-1956(ra) # 80001844 <myproc>
    80004ff0:	fec42783          	lw	a5,-20(s0)
    80004ff4:	07e9                	addi	a5,a5,26
    80004ff6:	078e                	slli	a5,a5,0x3
    80004ff8:	97aa                	add	a5,a5,a0
    80004ffa:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004ffe:	fe043503          	ld	a0,-32(s0)
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	292080e7          	jalr	658(ra) # 80004294 <fileclose>
  return 0;
    8000500a:	4781                	li	a5,0
}
    8000500c:	853e                	mv	a0,a5
    8000500e:	60e2                	ld	ra,24(sp)
    80005010:	6442                	ld	s0,16(sp)
    80005012:	6105                	addi	sp,sp,32
    80005014:	8082                	ret

0000000080005016 <sys_fstat>:
{
    80005016:	1101                	addi	sp,sp,-32
    80005018:	ec06                	sd	ra,24(sp)
    8000501a:	e822                	sd	s0,16(sp)
    8000501c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000501e:	fe840613          	addi	a2,s0,-24
    80005022:	4581                	li	a1,0
    80005024:	4501                	li	a0,0
    80005026:	00000097          	auipc	ra,0x0
    8000502a:	c76080e7          	jalr	-906(ra) # 80004c9c <argfd>
    return -1;
    8000502e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005030:	02054563          	bltz	a0,8000505a <sys_fstat+0x44>
    80005034:	fe040593          	addi	a1,s0,-32
    80005038:	4505                	li	a0,1
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	8a2080e7          	jalr	-1886(ra) # 800028dc <argaddr>
    return -1;
    80005042:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005044:	00054b63          	bltz	a0,8000505a <sys_fstat+0x44>
  return filestat(f, st);
    80005048:	fe043583          	ld	a1,-32(s0)
    8000504c:	fe843503          	ld	a0,-24(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	30c080e7          	jalr	780(ra) # 8000435c <filestat>
    80005058:	87aa                	mv	a5,a0
}
    8000505a:	853e                	mv	a0,a5
    8000505c:	60e2                	ld	ra,24(sp)
    8000505e:	6442                	ld	s0,16(sp)
    80005060:	6105                	addi	sp,sp,32
    80005062:	8082                	ret

0000000080005064 <sys_link>:
{
    80005064:	7169                	addi	sp,sp,-304
    80005066:	f606                	sd	ra,296(sp)
    80005068:	f222                	sd	s0,288(sp)
    8000506a:	ee26                	sd	s1,280(sp)
    8000506c:	ea4a                	sd	s2,272(sp)
    8000506e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005070:	08000613          	li	a2,128
    80005074:	ed040593          	addi	a1,s0,-304
    80005078:	4501                	li	a0,0
    8000507a:	ffffe097          	auipc	ra,0xffffe
    8000507e:	884080e7          	jalr	-1916(ra) # 800028fe <argstr>
    return -1;
    80005082:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005084:	10054e63          	bltz	a0,800051a0 <sys_link+0x13c>
    80005088:	08000613          	li	a2,128
    8000508c:	f5040593          	addi	a1,s0,-176
    80005090:	4505                	li	a0,1
    80005092:	ffffe097          	auipc	ra,0xffffe
    80005096:	86c080e7          	jalr	-1940(ra) # 800028fe <argstr>
    return -1;
    8000509a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000509c:	10054263          	bltz	a0,800051a0 <sys_link+0x13c>
  begin_op();
    800050a0:	fffff097          	auipc	ra,0xfffff
    800050a4:	d22080e7          	jalr	-734(ra) # 80003dc2 <begin_op>
  if((ip = namei(old)) == 0){
    800050a8:	ed040513          	addi	a0,s0,-304
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	b0a080e7          	jalr	-1270(ra) # 80003bb6 <namei>
    800050b4:	84aa                	mv	s1,a0
    800050b6:	c551                	beqz	a0,80005142 <sys_link+0xde>
  ilock(ip);
    800050b8:	ffffe097          	auipc	ra,0xffffe
    800050bc:	374080e7          	jalr	884(ra) # 8000342c <ilock>
  if(ip->type == T_DIR){
    800050c0:	04449703          	lh	a4,68(s1)
    800050c4:	4785                	li	a5,1
    800050c6:	08f70463          	beq	a4,a5,8000514e <sys_link+0xea>
  ip->nlink++;
    800050ca:	04a4d783          	lhu	a5,74(s1)
    800050ce:	2785                	addiw	a5,a5,1
    800050d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800050d4:	8526                	mv	a0,s1
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	28c080e7          	jalr	652(ra) # 80003362 <iupdate>
  iunlock(ip);
    800050de:	8526                	mv	a0,s1
    800050e0:	ffffe097          	auipc	ra,0xffffe
    800050e4:	40e080e7          	jalr	1038(ra) # 800034ee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800050e8:	fd040593          	addi	a1,s0,-48
    800050ec:	f5040513          	addi	a0,s0,-176
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	ae4080e7          	jalr	-1308(ra) # 80003bd4 <nameiparent>
    800050f8:	892a                	mv	s2,a0
    800050fa:	c935                	beqz	a0,8000516e <sys_link+0x10a>
  ilock(dp);
    800050fc:	ffffe097          	auipc	ra,0xffffe
    80005100:	330080e7          	jalr	816(ra) # 8000342c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005104:	00092703          	lw	a4,0(s2)
    80005108:	409c                	lw	a5,0(s1)
    8000510a:	04f71d63          	bne	a4,a5,80005164 <sys_link+0x100>
    8000510e:	40d0                	lw	a2,4(s1)
    80005110:	fd040593          	addi	a1,s0,-48
    80005114:	854a                	mv	a0,s2
    80005116:	fffff097          	auipc	ra,0xfffff
    8000511a:	9de080e7          	jalr	-1570(ra) # 80003af4 <dirlink>
    8000511e:	04054363          	bltz	a0,80005164 <sys_link+0x100>
  iunlockput(dp);
    80005122:	854a                	mv	a0,s2
    80005124:	ffffe097          	auipc	ra,0xffffe
    80005128:	546080e7          	jalr	1350(ra) # 8000366a <iunlockput>
  iput(ip);
    8000512c:	8526                	mv	a0,s1
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	40c080e7          	jalr	1036(ra) # 8000353a <iput>
  end_op();
    80005136:	fffff097          	auipc	ra,0xfffff
    8000513a:	d0c080e7          	jalr	-756(ra) # 80003e42 <end_op>
  return 0;
    8000513e:	4781                	li	a5,0
    80005140:	a085                	j	800051a0 <sys_link+0x13c>
    end_op();
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	d00080e7          	jalr	-768(ra) # 80003e42 <end_op>
    return -1;
    8000514a:	57fd                	li	a5,-1
    8000514c:	a891                	j	800051a0 <sys_link+0x13c>
    iunlockput(ip);
    8000514e:	8526                	mv	a0,s1
    80005150:	ffffe097          	auipc	ra,0xffffe
    80005154:	51a080e7          	jalr	1306(ra) # 8000366a <iunlockput>
    end_op();
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	cea080e7          	jalr	-790(ra) # 80003e42 <end_op>
    return -1;
    80005160:	57fd                	li	a5,-1
    80005162:	a83d                	j	800051a0 <sys_link+0x13c>
    iunlockput(dp);
    80005164:	854a                	mv	a0,s2
    80005166:	ffffe097          	auipc	ra,0xffffe
    8000516a:	504080e7          	jalr	1284(ra) # 8000366a <iunlockput>
  ilock(ip);
    8000516e:	8526                	mv	a0,s1
    80005170:	ffffe097          	auipc	ra,0xffffe
    80005174:	2bc080e7          	jalr	700(ra) # 8000342c <ilock>
  ip->nlink--;
    80005178:	04a4d783          	lhu	a5,74(s1)
    8000517c:	37fd                	addiw	a5,a5,-1
    8000517e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005182:	8526                	mv	a0,s1
    80005184:	ffffe097          	auipc	ra,0xffffe
    80005188:	1de080e7          	jalr	478(ra) # 80003362 <iupdate>
  iunlockput(ip);
    8000518c:	8526                	mv	a0,s1
    8000518e:	ffffe097          	auipc	ra,0xffffe
    80005192:	4dc080e7          	jalr	1244(ra) # 8000366a <iunlockput>
  end_op();
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	cac080e7          	jalr	-852(ra) # 80003e42 <end_op>
  return -1;
    8000519e:	57fd                	li	a5,-1
}
    800051a0:	853e                	mv	a0,a5
    800051a2:	70b2                	ld	ra,296(sp)
    800051a4:	7412                	ld	s0,288(sp)
    800051a6:	64f2                	ld	s1,280(sp)
    800051a8:	6952                	ld	s2,272(sp)
    800051aa:	6155                	addi	sp,sp,304
    800051ac:	8082                	ret

00000000800051ae <sys_unlink>:
{
    800051ae:	7151                	addi	sp,sp,-240
    800051b0:	f586                	sd	ra,232(sp)
    800051b2:	f1a2                	sd	s0,224(sp)
    800051b4:	eda6                	sd	s1,216(sp)
    800051b6:	e9ca                	sd	s2,208(sp)
    800051b8:	e5ce                	sd	s3,200(sp)
    800051ba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800051bc:	08000613          	li	a2,128
    800051c0:	f3040593          	addi	a1,s0,-208
    800051c4:	4501                	li	a0,0
    800051c6:	ffffd097          	auipc	ra,0xffffd
    800051ca:	738080e7          	jalr	1848(ra) # 800028fe <argstr>
    800051ce:	18054163          	bltz	a0,80005350 <sys_unlink+0x1a2>
  begin_op();
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	bf0080e7          	jalr	-1040(ra) # 80003dc2 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800051da:	fb040593          	addi	a1,s0,-80
    800051de:	f3040513          	addi	a0,s0,-208
    800051e2:	fffff097          	auipc	ra,0xfffff
    800051e6:	9f2080e7          	jalr	-1550(ra) # 80003bd4 <nameiparent>
    800051ea:	84aa                	mv	s1,a0
    800051ec:	c979                	beqz	a0,800052c2 <sys_unlink+0x114>
  ilock(dp);
    800051ee:	ffffe097          	auipc	ra,0xffffe
    800051f2:	23e080e7          	jalr	574(ra) # 8000342c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800051f6:	00001597          	auipc	a1,0x1
    800051fa:	4e258593          	addi	a1,a1,1250 # 800066d8 <userret+0x648>
    800051fe:	fb040513          	addi	a0,s0,-80
    80005202:	ffffe097          	auipc	ra,0xffffe
    80005206:	6c8080e7          	jalr	1736(ra) # 800038ca <namecmp>
    8000520a:	14050a63          	beqz	a0,8000535e <sys_unlink+0x1b0>
    8000520e:	00001597          	auipc	a1,0x1
    80005212:	4d258593          	addi	a1,a1,1234 # 800066e0 <userret+0x650>
    80005216:	fb040513          	addi	a0,s0,-80
    8000521a:	ffffe097          	auipc	ra,0xffffe
    8000521e:	6b0080e7          	jalr	1712(ra) # 800038ca <namecmp>
    80005222:	12050e63          	beqz	a0,8000535e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005226:	f2c40613          	addi	a2,s0,-212
    8000522a:	fb040593          	addi	a1,s0,-80
    8000522e:	8526                	mv	a0,s1
    80005230:	ffffe097          	auipc	ra,0xffffe
    80005234:	6b4080e7          	jalr	1716(ra) # 800038e4 <dirlookup>
    80005238:	892a                	mv	s2,a0
    8000523a:	12050263          	beqz	a0,8000535e <sys_unlink+0x1b0>
  ilock(ip);
    8000523e:	ffffe097          	auipc	ra,0xffffe
    80005242:	1ee080e7          	jalr	494(ra) # 8000342c <ilock>
  if(ip->nlink < 1)
    80005246:	04a91783          	lh	a5,74(s2)
    8000524a:	08f05263          	blez	a5,800052ce <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000524e:	04491703          	lh	a4,68(s2)
    80005252:	4785                	li	a5,1
    80005254:	08f70563          	beq	a4,a5,800052de <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005258:	4641                	li	a2,16
    8000525a:	4581                	li	a1,0
    8000525c:	fc040513          	addi	a0,s0,-64
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	90e080e7          	jalr	-1778(ra) # 80000b6e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005268:	4741                	li	a4,16
    8000526a:	f2c42683          	lw	a3,-212(s0)
    8000526e:	fc040613          	addi	a2,s0,-64
    80005272:	4581                	li	a1,0
    80005274:	8526                	mv	a0,s1
    80005276:	ffffe097          	auipc	ra,0xffffe
    8000527a:	53a080e7          	jalr	1338(ra) # 800037b0 <writei>
    8000527e:	47c1                	li	a5,16
    80005280:	0af51563          	bne	a0,a5,8000532a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005284:	04491703          	lh	a4,68(s2)
    80005288:	4785                	li	a5,1
    8000528a:	0af70863          	beq	a4,a5,8000533a <sys_unlink+0x18c>
  iunlockput(dp);
    8000528e:	8526                	mv	a0,s1
    80005290:	ffffe097          	auipc	ra,0xffffe
    80005294:	3da080e7          	jalr	986(ra) # 8000366a <iunlockput>
  ip->nlink--;
    80005298:	04a95783          	lhu	a5,74(s2)
    8000529c:	37fd                	addiw	a5,a5,-1
    8000529e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800052a2:	854a                	mv	a0,s2
    800052a4:	ffffe097          	auipc	ra,0xffffe
    800052a8:	0be080e7          	jalr	190(ra) # 80003362 <iupdate>
  iunlockput(ip);
    800052ac:	854a                	mv	a0,s2
    800052ae:	ffffe097          	auipc	ra,0xffffe
    800052b2:	3bc080e7          	jalr	956(ra) # 8000366a <iunlockput>
  end_op();
    800052b6:	fffff097          	auipc	ra,0xfffff
    800052ba:	b8c080e7          	jalr	-1140(ra) # 80003e42 <end_op>
  return 0;
    800052be:	4501                	li	a0,0
    800052c0:	a84d                	j	80005372 <sys_unlink+0x1c4>
    end_op();
    800052c2:	fffff097          	auipc	ra,0xfffff
    800052c6:	b80080e7          	jalr	-1152(ra) # 80003e42 <end_op>
    return -1;
    800052ca:	557d                	li	a0,-1
    800052cc:	a05d                	j	80005372 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800052ce:	00001517          	auipc	a0,0x1
    800052d2:	43a50513          	addi	a0,a0,1082 # 80006708 <userret+0x678>
    800052d6:	ffffb097          	auipc	ra,0xffffb
    800052da:	278080e7          	jalr	632(ra) # 8000054e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800052de:	04c92703          	lw	a4,76(s2)
    800052e2:	02000793          	li	a5,32
    800052e6:	f6e7f9e3          	bgeu	a5,a4,80005258 <sys_unlink+0xaa>
    800052ea:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052ee:	4741                	li	a4,16
    800052f0:	86ce                	mv	a3,s3
    800052f2:	f1840613          	addi	a2,s0,-232
    800052f6:	4581                	li	a1,0
    800052f8:	854a                	mv	a0,s2
    800052fa:	ffffe097          	auipc	ra,0xffffe
    800052fe:	3c2080e7          	jalr	962(ra) # 800036bc <readi>
    80005302:	47c1                	li	a5,16
    80005304:	00f51b63          	bne	a0,a5,8000531a <sys_unlink+0x16c>
    if(de.inum != 0)
    80005308:	f1845783          	lhu	a5,-232(s0)
    8000530c:	e7a1                	bnez	a5,80005354 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000530e:	29c1                	addiw	s3,s3,16
    80005310:	04c92783          	lw	a5,76(s2)
    80005314:	fcf9ede3          	bltu	s3,a5,800052ee <sys_unlink+0x140>
    80005318:	b781                	j	80005258 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000531a:	00001517          	auipc	a0,0x1
    8000531e:	40650513          	addi	a0,a0,1030 # 80006720 <userret+0x690>
    80005322:	ffffb097          	auipc	ra,0xffffb
    80005326:	22c080e7          	jalr	556(ra) # 8000054e <panic>
    panic("unlink: writei");
    8000532a:	00001517          	auipc	a0,0x1
    8000532e:	40e50513          	addi	a0,a0,1038 # 80006738 <userret+0x6a8>
    80005332:	ffffb097          	auipc	ra,0xffffb
    80005336:	21c080e7          	jalr	540(ra) # 8000054e <panic>
    dp->nlink--;
    8000533a:	04a4d783          	lhu	a5,74(s1)
    8000533e:	37fd                	addiw	a5,a5,-1
    80005340:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005344:	8526                	mv	a0,s1
    80005346:	ffffe097          	auipc	ra,0xffffe
    8000534a:	01c080e7          	jalr	28(ra) # 80003362 <iupdate>
    8000534e:	b781                	j	8000528e <sys_unlink+0xe0>
    return -1;
    80005350:	557d                	li	a0,-1
    80005352:	a005                	j	80005372 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005354:	854a                	mv	a0,s2
    80005356:	ffffe097          	auipc	ra,0xffffe
    8000535a:	314080e7          	jalr	788(ra) # 8000366a <iunlockput>
  iunlockput(dp);
    8000535e:	8526                	mv	a0,s1
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	30a080e7          	jalr	778(ra) # 8000366a <iunlockput>
  end_op();
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	ada080e7          	jalr	-1318(ra) # 80003e42 <end_op>
  return -1;
    80005370:	557d                	li	a0,-1
}
    80005372:	70ae                	ld	ra,232(sp)
    80005374:	740e                	ld	s0,224(sp)
    80005376:	64ee                	ld	s1,216(sp)
    80005378:	694e                	ld	s2,208(sp)
    8000537a:	69ae                	ld	s3,200(sp)
    8000537c:	616d                	addi	sp,sp,240
    8000537e:	8082                	ret

0000000080005380 <sys_open>:

uint64
sys_open(void)
{
    80005380:	7131                	addi	sp,sp,-192
    80005382:	fd06                	sd	ra,184(sp)
    80005384:	f922                	sd	s0,176(sp)
    80005386:	f526                	sd	s1,168(sp)
    80005388:	f14a                	sd	s2,160(sp)
    8000538a:	ed4e                	sd	s3,152(sp)
    8000538c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000538e:	08000613          	li	a2,128
    80005392:	f5040593          	addi	a1,s0,-176
    80005396:	4501                	li	a0,0
    80005398:	ffffd097          	auipc	ra,0xffffd
    8000539c:	566080e7          	jalr	1382(ra) # 800028fe <argstr>
    return -1;
    800053a0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800053a2:	0a054763          	bltz	a0,80005450 <sys_open+0xd0>
    800053a6:	f4c40593          	addi	a1,s0,-180
    800053aa:	4505                	li	a0,1
    800053ac:	ffffd097          	auipc	ra,0xffffd
    800053b0:	50e080e7          	jalr	1294(ra) # 800028ba <argint>
    800053b4:	08054e63          	bltz	a0,80005450 <sys_open+0xd0>

  begin_op();
    800053b8:	fffff097          	auipc	ra,0xfffff
    800053bc:	a0a080e7          	jalr	-1526(ra) # 80003dc2 <begin_op>

  if(omode & O_CREATE){
    800053c0:	f4c42783          	lw	a5,-180(s0)
    800053c4:	2007f793          	andi	a5,a5,512
    800053c8:	c3cd                	beqz	a5,8000546a <sys_open+0xea>
    ip = create(path, T_FILE, 0, 0);
    800053ca:	4681                	li	a3,0
    800053cc:	4601                	li	a2,0
    800053ce:	4589                	li	a1,2
    800053d0:	f5040513          	addi	a0,s0,-176
    800053d4:	00000097          	auipc	ra,0x0
    800053d8:	972080e7          	jalr	-1678(ra) # 80004d46 <create>
    800053dc:	892a                	mv	s2,a0
    if(ip == 0){
    800053de:	c149                	beqz	a0,80005460 <sys_open+0xe0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800053e0:	04491703          	lh	a4,68(s2)
    800053e4:	478d                	li	a5,3
    800053e6:	00f71763          	bne	a4,a5,800053f4 <sys_open+0x74>
    800053ea:	04695703          	lhu	a4,70(s2)
    800053ee:	47a5                	li	a5,9
    800053f0:	0ce7e263          	bltu	a5,a4,800054b4 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800053f4:	fffff097          	auipc	ra,0xfffff
    800053f8:	de4080e7          	jalr	-540(ra) # 800041d8 <filealloc>
    800053fc:	89aa                	mv	s3,a0
    800053fe:	c175                	beqz	a0,800054e2 <sys_open+0x162>
    80005400:	00000097          	auipc	ra,0x0
    80005404:	904080e7          	jalr	-1788(ra) # 80004d04 <fdalloc>
    80005408:	84aa                	mv	s1,a0
    8000540a:	0c054763          	bltz	a0,800054d8 <sys_open+0x158>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000540e:	04491703          	lh	a4,68(s2)
    80005412:	478d                	li	a5,3
    80005414:	0af70b63          	beq	a4,a5,800054ca <sys_open+0x14a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005418:	4789                	li	a5,2
    8000541a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000541e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005422:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005426:	f4c42783          	lw	a5,-180(s0)
    8000542a:	0017c713          	xori	a4,a5,1
    8000542e:	8b05                	andi	a4,a4,1
    80005430:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005434:	8b8d                	andi	a5,a5,3
    80005436:	00f037b3          	snez	a5,a5
    8000543a:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    8000543e:	854a                	mv	a0,s2
    80005440:	ffffe097          	auipc	ra,0xffffe
    80005444:	0ae080e7          	jalr	174(ra) # 800034ee <iunlock>
  end_op();
    80005448:	fffff097          	auipc	ra,0xfffff
    8000544c:	9fa080e7          	jalr	-1542(ra) # 80003e42 <end_op>

  return fd;
}
    80005450:	8526                	mv	a0,s1
    80005452:	70ea                	ld	ra,184(sp)
    80005454:	744a                	ld	s0,176(sp)
    80005456:	74aa                	ld	s1,168(sp)
    80005458:	790a                	ld	s2,160(sp)
    8000545a:	69ea                	ld	s3,152(sp)
    8000545c:	6129                	addi	sp,sp,192
    8000545e:	8082                	ret
      end_op();
    80005460:	fffff097          	auipc	ra,0xfffff
    80005464:	9e2080e7          	jalr	-1566(ra) # 80003e42 <end_op>
      return -1;
    80005468:	b7e5                	j	80005450 <sys_open+0xd0>
    if((ip = namei(path)) == 0){
    8000546a:	f5040513          	addi	a0,s0,-176
    8000546e:	ffffe097          	auipc	ra,0xffffe
    80005472:	748080e7          	jalr	1864(ra) # 80003bb6 <namei>
    80005476:	892a                	mv	s2,a0
    80005478:	c905                	beqz	a0,800054a8 <sys_open+0x128>
    ilock(ip);
    8000547a:	ffffe097          	auipc	ra,0xffffe
    8000547e:	fb2080e7          	jalr	-78(ra) # 8000342c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005482:	04491703          	lh	a4,68(s2)
    80005486:	4785                	li	a5,1
    80005488:	f4f71ce3          	bne	a4,a5,800053e0 <sys_open+0x60>
    8000548c:	f4c42783          	lw	a5,-180(s0)
    80005490:	d3b5                	beqz	a5,800053f4 <sys_open+0x74>
      iunlockput(ip);
    80005492:	854a                	mv	a0,s2
    80005494:	ffffe097          	auipc	ra,0xffffe
    80005498:	1d6080e7          	jalr	470(ra) # 8000366a <iunlockput>
      end_op();
    8000549c:	fffff097          	auipc	ra,0xfffff
    800054a0:	9a6080e7          	jalr	-1626(ra) # 80003e42 <end_op>
      return -1;
    800054a4:	54fd                	li	s1,-1
    800054a6:	b76d                	j	80005450 <sys_open+0xd0>
      end_op();
    800054a8:	fffff097          	auipc	ra,0xfffff
    800054ac:	99a080e7          	jalr	-1638(ra) # 80003e42 <end_op>
      return -1;
    800054b0:	54fd                	li	s1,-1
    800054b2:	bf79                	j	80005450 <sys_open+0xd0>
    iunlockput(ip);
    800054b4:	854a                	mv	a0,s2
    800054b6:	ffffe097          	auipc	ra,0xffffe
    800054ba:	1b4080e7          	jalr	436(ra) # 8000366a <iunlockput>
    end_op();
    800054be:	fffff097          	auipc	ra,0xfffff
    800054c2:	984080e7          	jalr	-1660(ra) # 80003e42 <end_op>
    return -1;
    800054c6:	54fd                	li	s1,-1
    800054c8:	b761                	j	80005450 <sys_open+0xd0>
    f->type = FD_DEVICE;
    800054ca:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800054ce:	04691783          	lh	a5,70(s2)
    800054d2:	02f99223          	sh	a5,36(s3)
    800054d6:	b7b1                	j	80005422 <sys_open+0xa2>
      fileclose(f);
    800054d8:	854e                	mv	a0,s3
    800054da:	fffff097          	auipc	ra,0xfffff
    800054de:	dba080e7          	jalr	-582(ra) # 80004294 <fileclose>
    iunlockput(ip);
    800054e2:	854a                	mv	a0,s2
    800054e4:	ffffe097          	auipc	ra,0xffffe
    800054e8:	186080e7          	jalr	390(ra) # 8000366a <iunlockput>
    end_op();
    800054ec:	fffff097          	auipc	ra,0xfffff
    800054f0:	956080e7          	jalr	-1706(ra) # 80003e42 <end_op>
    return -1;
    800054f4:	54fd                	li	s1,-1
    800054f6:	bfa9                	j	80005450 <sys_open+0xd0>

00000000800054f8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800054f8:	7175                	addi	sp,sp,-144
    800054fa:	e506                	sd	ra,136(sp)
    800054fc:	e122                	sd	s0,128(sp)
    800054fe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005500:	fffff097          	auipc	ra,0xfffff
    80005504:	8c2080e7          	jalr	-1854(ra) # 80003dc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005508:	08000613          	li	a2,128
    8000550c:	f7040593          	addi	a1,s0,-144
    80005510:	4501                	li	a0,0
    80005512:	ffffd097          	auipc	ra,0xffffd
    80005516:	3ec080e7          	jalr	1004(ra) # 800028fe <argstr>
    8000551a:	02054963          	bltz	a0,8000554c <sys_mkdir+0x54>
    8000551e:	4681                	li	a3,0
    80005520:	4601                	li	a2,0
    80005522:	4585                	li	a1,1
    80005524:	f7040513          	addi	a0,s0,-144
    80005528:	00000097          	auipc	ra,0x0
    8000552c:	81e080e7          	jalr	-2018(ra) # 80004d46 <create>
    80005530:	cd11                	beqz	a0,8000554c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	138080e7          	jalr	312(ra) # 8000366a <iunlockput>
  end_op();
    8000553a:	fffff097          	auipc	ra,0xfffff
    8000553e:	908080e7          	jalr	-1784(ra) # 80003e42 <end_op>
  return 0;
    80005542:	4501                	li	a0,0
}
    80005544:	60aa                	ld	ra,136(sp)
    80005546:	640a                	ld	s0,128(sp)
    80005548:	6149                	addi	sp,sp,144
    8000554a:	8082                	ret
    end_op();
    8000554c:	fffff097          	auipc	ra,0xfffff
    80005550:	8f6080e7          	jalr	-1802(ra) # 80003e42 <end_op>
    return -1;
    80005554:	557d                	li	a0,-1
    80005556:	b7fd                	j	80005544 <sys_mkdir+0x4c>

0000000080005558 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005558:	7135                	addi	sp,sp,-160
    8000555a:	ed06                	sd	ra,152(sp)
    8000555c:	e922                	sd	s0,144(sp)
    8000555e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005560:	fffff097          	auipc	ra,0xfffff
    80005564:	862080e7          	jalr	-1950(ra) # 80003dc2 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005568:	08000613          	li	a2,128
    8000556c:	f7040593          	addi	a1,s0,-144
    80005570:	4501                	li	a0,0
    80005572:	ffffd097          	auipc	ra,0xffffd
    80005576:	38c080e7          	jalr	908(ra) # 800028fe <argstr>
    8000557a:	04054a63          	bltz	a0,800055ce <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000557e:	f6c40593          	addi	a1,s0,-148
    80005582:	4505                	li	a0,1
    80005584:	ffffd097          	auipc	ra,0xffffd
    80005588:	336080e7          	jalr	822(ra) # 800028ba <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000558c:	04054163          	bltz	a0,800055ce <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005590:	f6840593          	addi	a1,s0,-152
    80005594:	4509                	li	a0,2
    80005596:	ffffd097          	auipc	ra,0xffffd
    8000559a:	324080e7          	jalr	804(ra) # 800028ba <argint>
     argint(1, &major) < 0 ||
    8000559e:	02054863          	bltz	a0,800055ce <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800055a2:	f6841683          	lh	a3,-152(s0)
    800055a6:	f6c41603          	lh	a2,-148(s0)
    800055aa:	458d                	li	a1,3
    800055ac:	f7040513          	addi	a0,s0,-144
    800055b0:	fffff097          	auipc	ra,0xfffff
    800055b4:	796080e7          	jalr	1942(ra) # 80004d46 <create>
     argint(2, &minor) < 0 ||
    800055b8:	c919                	beqz	a0,800055ce <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800055ba:	ffffe097          	auipc	ra,0xffffe
    800055be:	0b0080e7          	jalr	176(ra) # 8000366a <iunlockput>
  end_op();
    800055c2:	fffff097          	auipc	ra,0xfffff
    800055c6:	880080e7          	jalr	-1920(ra) # 80003e42 <end_op>
  return 0;
    800055ca:	4501                	li	a0,0
    800055cc:	a031                	j	800055d8 <sys_mknod+0x80>
    end_op();
    800055ce:	fffff097          	auipc	ra,0xfffff
    800055d2:	874080e7          	jalr	-1932(ra) # 80003e42 <end_op>
    return -1;
    800055d6:	557d                	li	a0,-1
}
    800055d8:	60ea                	ld	ra,152(sp)
    800055da:	644a                	ld	s0,144(sp)
    800055dc:	610d                	addi	sp,sp,160
    800055de:	8082                	ret

00000000800055e0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800055e0:	7135                	addi	sp,sp,-160
    800055e2:	ed06                	sd	ra,152(sp)
    800055e4:	e922                	sd	s0,144(sp)
    800055e6:	e526                	sd	s1,136(sp)
    800055e8:	e14a                	sd	s2,128(sp)
    800055ea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800055ec:	ffffc097          	auipc	ra,0xffffc
    800055f0:	258080e7          	jalr	600(ra) # 80001844 <myproc>
    800055f4:	892a                	mv	s2,a0
  
  begin_op();
    800055f6:	ffffe097          	auipc	ra,0xffffe
    800055fa:	7cc080e7          	jalr	1996(ra) # 80003dc2 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800055fe:	08000613          	li	a2,128
    80005602:	f6040593          	addi	a1,s0,-160
    80005606:	4501                	li	a0,0
    80005608:	ffffd097          	auipc	ra,0xffffd
    8000560c:	2f6080e7          	jalr	758(ra) # 800028fe <argstr>
    80005610:	04054b63          	bltz	a0,80005666 <sys_chdir+0x86>
    80005614:	f6040513          	addi	a0,s0,-160
    80005618:	ffffe097          	auipc	ra,0xffffe
    8000561c:	59e080e7          	jalr	1438(ra) # 80003bb6 <namei>
    80005620:	84aa                	mv	s1,a0
    80005622:	c131                	beqz	a0,80005666 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005624:	ffffe097          	auipc	ra,0xffffe
    80005628:	e08080e7          	jalr	-504(ra) # 8000342c <ilock>
  if(ip->type != T_DIR){
    8000562c:	04449703          	lh	a4,68(s1)
    80005630:	4785                	li	a5,1
    80005632:	04f71063          	bne	a4,a5,80005672 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005636:	8526                	mv	a0,s1
    80005638:	ffffe097          	auipc	ra,0xffffe
    8000563c:	eb6080e7          	jalr	-330(ra) # 800034ee <iunlock>
  iput(p->cwd);
    80005640:	15093503          	ld	a0,336(s2)
    80005644:	ffffe097          	auipc	ra,0xffffe
    80005648:	ef6080e7          	jalr	-266(ra) # 8000353a <iput>
  end_op();
    8000564c:	ffffe097          	auipc	ra,0xffffe
    80005650:	7f6080e7          	jalr	2038(ra) # 80003e42 <end_op>
  p->cwd = ip;
    80005654:	14993823          	sd	s1,336(s2)
  return 0;
    80005658:	4501                	li	a0,0
}
    8000565a:	60ea                	ld	ra,152(sp)
    8000565c:	644a                	ld	s0,144(sp)
    8000565e:	64aa                	ld	s1,136(sp)
    80005660:	690a                	ld	s2,128(sp)
    80005662:	610d                	addi	sp,sp,160
    80005664:	8082                	ret
    end_op();
    80005666:	ffffe097          	auipc	ra,0xffffe
    8000566a:	7dc080e7          	jalr	2012(ra) # 80003e42 <end_op>
    return -1;
    8000566e:	557d                	li	a0,-1
    80005670:	b7ed                	j	8000565a <sys_chdir+0x7a>
    iunlockput(ip);
    80005672:	8526                	mv	a0,s1
    80005674:	ffffe097          	auipc	ra,0xffffe
    80005678:	ff6080e7          	jalr	-10(ra) # 8000366a <iunlockput>
    end_op();
    8000567c:	ffffe097          	auipc	ra,0xffffe
    80005680:	7c6080e7          	jalr	1990(ra) # 80003e42 <end_op>
    return -1;
    80005684:	557d                	li	a0,-1
    80005686:	bfd1                	j	8000565a <sys_chdir+0x7a>

0000000080005688 <sys_exec>:

uint64
sys_exec(void)
{
    80005688:	7145                	addi	sp,sp,-464
    8000568a:	e786                	sd	ra,456(sp)
    8000568c:	e3a2                	sd	s0,448(sp)
    8000568e:	ff26                	sd	s1,440(sp)
    80005690:	fb4a                	sd	s2,432(sp)
    80005692:	f74e                	sd	s3,424(sp)
    80005694:	f352                	sd	s4,416(sp)
    80005696:	ef56                	sd	s5,408(sp)
    80005698:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000569a:	08000613          	li	a2,128
    8000569e:	f4040593          	addi	a1,s0,-192
    800056a2:	4501                	li	a0,0
    800056a4:	ffffd097          	auipc	ra,0xffffd
    800056a8:	25a080e7          	jalr	602(ra) # 800028fe <argstr>
    800056ac:	0e054663          	bltz	a0,80005798 <sys_exec+0x110>
    800056b0:	e3840593          	addi	a1,s0,-456
    800056b4:	4505                	li	a0,1
    800056b6:	ffffd097          	auipc	ra,0xffffd
    800056ba:	226080e7          	jalr	550(ra) # 800028dc <argaddr>
    800056be:	0e054763          	bltz	a0,800057ac <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    800056c2:	10000613          	li	a2,256
    800056c6:	4581                	li	a1,0
    800056c8:	e4040513          	addi	a0,s0,-448
    800056cc:	ffffb097          	auipc	ra,0xffffb
    800056d0:	4a2080e7          	jalr	1186(ra) # 80000b6e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800056d4:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    800056d8:	89ca                	mv	s3,s2
    800056da:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    800056dc:	02000a13          	li	s4,32
    800056e0:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800056e4:	00349513          	slli	a0,s1,0x3
    800056e8:	e3040593          	addi	a1,s0,-464
    800056ec:	e3843783          	ld	a5,-456(s0)
    800056f0:	953e                	add	a0,a0,a5
    800056f2:	ffffd097          	auipc	ra,0xffffd
    800056f6:	12e080e7          	jalr	302(ra) # 80002820 <fetchaddr>
    800056fa:	02054a63          	bltz	a0,8000572e <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800056fe:	e3043783          	ld	a5,-464(s0)
    80005702:	c7a1                	beqz	a5,8000574a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005704:	ffffb097          	auipc	ra,0xffffb
    80005708:	25c080e7          	jalr	604(ra) # 80000960 <kalloc>
    8000570c:	85aa                	mv	a1,a0
    8000570e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005712:	c92d                	beqz	a0,80005784 <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005714:	6605                	lui	a2,0x1
    80005716:	e3043503          	ld	a0,-464(s0)
    8000571a:	ffffd097          	auipc	ra,0xffffd
    8000571e:	158080e7          	jalr	344(ra) # 80002872 <fetchstr>
    80005722:	00054663          	bltz	a0,8000572e <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005726:	0485                	addi	s1,s1,1
    80005728:	09a1                	addi	s3,s3,8
    8000572a:	fb449be3          	bne	s1,s4,800056e0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000572e:	10090493          	addi	s1,s2,256
    80005732:	00093503          	ld	a0,0(s2)
    80005736:	cd39                	beqz	a0,80005794 <sys_exec+0x10c>
    kfree(argv[i]);
    80005738:	ffffb097          	auipc	ra,0xffffb
    8000573c:	12c080e7          	jalr	300(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005740:	0921                	addi	s2,s2,8
    80005742:	fe9918e3          	bne	s2,s1,80005732 <sys_exec+0xaa>
  return -1;
    80005746:	557d                	li	a0,-1
    80005748:	a889                	j	8000579a <sys_exec+0x112>
      argv[i] = 0;
    8000574a:	0a8e                	slli	s5,s5,0x3
    8000574c:	fc040793          	addi	a5,s0,-64
    80005750:	9abe                	add	s5,s5,a5
    80005752:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd9e64>
  int ret = exec(path, argv);
    80005756:	e4040593          	addi	a1,s0,-448
    8000575a:	f4040513          	addi	a0,s0,-192
    8000575e:	fffff097          	auipc	ra,0xfffff
    80005762:	1dc080e7          	jalr	476(ra) # 8000493a <exec>
    80005766:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005768:	10090993          	addi	s3,s2,256
    8000576c:	00093503          	ld	a0,0(s2)
    80005770:	c901                	beqz	a0,80005780 <sys_exec+0xf8>
    kfree(argv[i]);
    80005772:	ffffb097          	auipc	ra,0xffffb
    80005776:	0f2080e7          	jalr	242(ra) # 80000864 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000577a:	0921                	addi	s2,s2,8
    8000577c:	ff3918e3          	bne	s2,s3,8000576c <sys_exec+0xe4>
  return ret;
    80005780:	8526                	mv	a0,s1
    80005782:	a821                	j	8000579a <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005784:	00001517          	auipc	a0,0x1
    80005788:	fc450513          	addi	a0,a0,-60 # 80006748 <userret+0x6b8>
    8000578c:	ffffb097          	auipc	ra,0xffffb
    80005790:	dc2080e7          	jalr	-574(ra) # 8000054e <panic>
  return -1;
    80005794:	557d                	li	a0,-1
    80005796:	a011                	j	8000579a <sys_exec+0x112>
    return -1;
    80005798:	557d                	li	a0,-1
}
    8000579a:	60be                	ld	ra,456(sp)
    8000579c:	641e                	ld	s0,448(sp)
    8000579e:	74fa                	ld	s1,440(sp)
    800057a0:	795a                	ld	s2,432(sp)
    800057a2:	79ba                	ld	s3,424(sp)
    800057a4:	7a1a                	ld	s4,416(sp)
    800057a6:	6afa                	ld	s5,408(sp)
    800057a8:	6179                	addi	sp,sp,464
    800057aa:	8082                	ret
    return -1;
    800057ac:	557d                	li	a0,-1
    800057ae:	b7f5                	j	8000579a <sys_exec+0x112>

00000000800057b0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800057b0:	7139                	addi	sp,sp,-64
    800057b2:	fc06                	sd	ra,56(sp)
    800057b4:	f822                	sd	s0,48(sp)
    800057b6:	f426                	sd	s1,40(sp)
    800057b8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800057ba:	ffffc097          	auipc	ra,0xffffc
    800057be:	08a080e7          	jalr	138(ra) # 80001844 <myproc>
    800057c2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800057c4:	fd840593          	addi	a1,s0,-40
    800057c8:	4501                	li	a0,0
    800057ca:	ffffd097          	auipc	ra,0xffffd
    800057ce:	112080e7          	jalr	274(ra) # 800028dc <argaddr>
    return -1;
    800057d2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800057d4:	0e054063          	bltz	a0,800058b4 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800057d8:	fc840593          	addi	a1,s0,-56
    800057dc:	fd040513          	addi	a0,s0,-48
    800057e0:	fffff097          	auipc	ra,0xfffff
    800057e4:	e0a080e7          	jalr	-502(ra) # 800045ea <pipealloc>
    return -1;
    800057e8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800057ea:	0c054563          	bltz	a0,800058b4 <sys_pipe+0x104>
  fd0 = -1;
    800057ee:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800057f2:	fd043503          	ld	a0,-48(s0)
    800057f6:	fffff097          	auipc	ra,0xfffff
    800057fa:	50e080e7          	jalr	1294(ra) # 80004d04 <fdalloc>
    800057fe:	fca42223          	sw	a0,-60(s0)
    80005802:	08054c63          	bltz	a0,8000589a <sys_pipe+0xea>
    80005806:	fc843503          	ld	a0,-56(s0)
    8000580a:	fffff097          	auipc	ra,0xfffff
    8000580e:	4fa080e7          	jalr	1274(ra) # 80004d04 <fdalloc>
    80005812:	fca42023          	sw	a0,-64(s0)
    80005816:	06054863          	bltz	a0,80005886 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000581a:	4691                	li	a3,4
    8000581c:	fc440613          	addi	a2,s0,-60
    80005820:	fd843583          	ld	a1,-40(s0)
    80005824:	68a8                	ld	a0,80(s1)
    80005826:	ffffc097          	auipc	ra,0xffffc
    8000582a:	d12080e7          	jalr	-750(ra) # 80001538 <copyout>
    8000582e:	02054063          	bltz	a0,8000584e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005832:	4691                	li	a3,4
    80005834:	fc040613          	addi	a2,s0,-64
    80005838:	fd843583          	ld	a1,-40(s0)
    8000583c:	0591                	addi	a1,a1,4
    8000583e:	68a8                	ld	a0,80(s1)
    80005840:	ffffc097          	auipc	ra,0xffffc
    80005844:	cf8080e7          	jalr	-776(ra) # 80001538 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005848:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000584a:	06055563          	bgez	a0,800058b4 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000584e:	fc442783          	lw	a5,-60(s0)
    80005852:	07e9                	addi	a5,a5,26
    80005854:	078e                	slli	a5,a5,0x3
    80005856:	97a6                	add	a5,a5,s1
    80005858:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000585c:	fc042503          	lw	a0,-64(s0)
    80005860:	0569                	addi	a0,a0,26
    80005862:	050e                	slli	a0,a0,0x3
    80005864:	9526                	add	a0,a0,s1
    80005866:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000586a:	fd043503          	ld	a0,-48(s0)
    8000586e:	fffff097          	auipc	ra,0xfffff
    80005872:	a26080e7          	jalr	-1498(ra) # 80004294 <fileclose>
    fileclose(wf);
    80005876:	fc843503          	ld	a0,-56(s0)
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	a1a080e7          	jalr	-1510(ra) # 80004294 <fileclose>
    return -1;
    80005882:	57fd                	li	a5,-1
    80005884:	a805                	j	800058b4 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005886:	fc442783          	lw	a5,-60(s0)
    8000588a:	0007c863          	bltz	a5,8000589a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000588e:	01a78513          	addi	a0,a5,26
    80005892:	050e                	slli	a0,a0,0x3
    80005894:	9526                	add	a0,a0,s1
    80005896:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000589a:	fd043503          	ld	a0,-48(s0)
    8000589e:	fffff097          	auipc	ra,0xfffff
    800058a2:	9f6080e7          	jalr	-1546(ra) # 80004294 <fileclose>
    fileclose(wf);
    800058a6:	fc843503          	ld	a0,-56(s0)
    800058aa:	fffff097          	auipc	ra,0xfffff
    800058ae:	9ea080e7          	jalr	-1558(ra) # 80004294 <fileclose>
    return -1;
    800058b2:	57fd                	li	a5,-1
}
    800058b4:	853e                	mv	a0,a5
    800058b6:	70e2                	ld	ra,56(sp)
    800058b8:	7442                	ld	s0,48(sp)
    800058ba:	74a2                	ld	s1,40(sp)
    800058bc:	6121                	addi	sp,sp,64
    800058be:	8082                	ret

00000000800058c0 <kernelvec>:
    800058c0:	7111                	addi	sp,sp,-256
    800058c2:	e006                	sd	ra,0(sp)
    800058c4:	e40a                	sd	sp,8(sp)
    800058c6:	e80e                	sd	gp,16(sp)
    800058c8:	ec12                	sd	tp,24(sp)
    800058ca:	f016                	sd	t0,32(sp)
    800058cc:	f41a                	sd	t1,40(sp)
    800058ce:	f81e                	sd	t2,48(sp)
    800058d0:	fc22                	sd	s0,56(sp)
    800058d2:	e0a6                	sd	s1,64(sp)
    800058d4:	e4aa                	sd	a0,72(sp)
    800058d6:	e8ae                	sd	a1,80(sp)
    800058d8:	ecb2                	sd	a2,88(sp)
    800058da:	f0b6                	sd	a3,96(sp)
    800058dc:	f4ba                	sd	a4,104(sp)
    800058de:	f8be                	sd	a5,112(sp)
    800058e0:	fcc2                	sd	a6,120(sp)
    800058e2:	e146                	sd	a7,128(sp)
    800058e4:	e54a                	sd	s2,136(sp)
    800058e6:	e94e                	sd	s3,144(sp)
    800058e8:	ed52                	sd	s4,152(sp)
    800058ea:	f156                	sd	s5,160(sp)
    800058ec:	f55a                	sd	s6,168(sp)
    800058ee:	f95e                	sd	s7,176(sp)
    800058f0:	fd62                	sd	s8,184(sp)
    800058f2:	e1e6                	sd	s9,192(sp)
    800058f4:	e5ea                	sd	s10,200(sp)
    800058f6:	e9ee                	sd	s11,208(sp)
    800058f8:	edf2                	sd	t3,216(sp)
    800058fa:	f1f6                	sd	t4,224(sp)
    800058fc:	f5fa                	sd	t5,232(sp)
    800058fe:	f9fe                	sd	t6,240(sp)
    80005900:	dedfc0ef          	jal	ra,800026ec <kerneltrap>
    80005904:	6082                	ld	ra,0(sp)
    80005906:	6122                	ld	sp,8(sp)
    80005908:	61c2                	ld	gp,16(sp)
    8000590a:	7282                	ld	t0,32(sp)
    8000590c:	7322                	ld	t1,40(sp)
    8000590e:	73c2                	ld	t2,48(sp)
    80005910:	7462                	ld	s0,56(sp)
    80005912:	6486                	ld	s1,64(sp)
    80005914:	6526                	ld	a0,72(sp)
    80005916:	65c6                	ld	a1,80(sp)
    80005918:	6666                	ld	a2,88(sp)
    8000591a:	7686                	ld	a3,96(sp)
    8000591c:	7726                	ld	a4,104(sp)
    8000591e:	77c6                	ld	a5,112(sp)
    80005920:	7866                	ld	a6,120(sp)
    80005922:	688a                	ld	a7,128(sp)
    80005924:	692a                	ld	s2,136(sp)
    80005926:	69ca                	ld	s3,144(sp)
    80005928:	6a6a                	ld	s4,152(sp)
    8000592a:	7a8a                	ld	s5,160(sp)
    8000592c:	7b2a                	ld	s6,168(sp)
    8000592e:	7bca                	ld	s7,176(sp)
    80005930:	7c6a                	ld	s8,184(sp)
    80005932:	6c8e                	ld	s9,192(sp)
    80005934:	6d2e                	ld	s10,200(sp)
    80005936:	6dce                	ld	s11,208(sp)
    80005938:	6e6e                	ld	t3,216(sp)
    8000593a:	7e8e                	ld	t4,224(sp)
    8000593c:	7f2e                	ld	t5,232(sp)
    8000593e:	7fce                	ld	t6,240(sp)
    80005940:	6111                	addi	sp,sp,256
    80005942:	10200073          	sret
    80005946:	00000013          	nop
    8000594a:	00000013          	nop
    8000594e:	0001                	nop

0000000080005950 <timervec>:
    80005950:	34051573          	csrrw	a0,mscratch,a0
    80005954:	e10c                	sd	a1,0(a0)
    80005956:	e510                	sd	a2,8(a0)
    80005958:	e914                	sd	a3,16(a0)
    8000595a:	710c                	ld	a1,32(a0)
    8000595c:	7510                	ld	a2,40(a0)
    8000595e:	6194                	ld	a3,0(a1)
    80005960:	96b2                	add	a3,a3,a2
    80005962:	e194                	sd	a3,0(a1)
    80005964:	4589                	li	a1,2
    80005966:	14459073          	csrw	sip,a1
    8000596a:	6914                	ld	a3,16(a0)
    8000596c:	6510                	ld	a2,8(a0)
    8000596e:	610c                	ld	a1,0(a0)
    80005970:	34051573          	csrrw	a0,mscratch,a0
    80005974:	30200073          	mret
	...

000000008000597a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000597a:	1141                	addi	sp,sp,-16
    8000597c:	e422                	sd	s0,8(sp)
    8000597e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005980:	0c0007b7          	lui	a5,0xc000
    80005984:	4705                	li	a4,1
    80005986:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005988:	c3d8                	sw	a4,4(a5)
}
    8000598a:	6422                	ld	s0,8(sp)
    8000598c:	0141                	addi	sp,sp,16
    8000598e:	8082                	ret

0000000080005990 <plicinithart>:

void
plicinithart(void)
{
    80005990:	1141                	addi	sp,sp,-16
    80005992:	e406                	sd	ra,8(sp)
    80005994:	e022                	sd	s0,0(sp)
    80005996:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005998:	ffffc097          	auipc	ra,0xffffc
    8000599c:	e80080e7          	jalr	-384(ra) # 80001818 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800059a0:	0085171b          	slliw	a4,a0,0x8
    800059a4:	0c0027b7          	lui	a5,0xc002
    800059a8:	97ba                	add	a5,a5,a4
    800059aa:	40200713          	li	a4,1026
    800059ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800059b2:	00d5151b          	slliw	a0,a0,0xd
    800059b6:	0c2017b7          	lui	a5,0xc201
    800059ba:	953e                	add	a0,a0,a5
    800059bc:	00052023          	sw	zero,0(a0)
}
    800059c0:	60a2                	ld	ra,8(sp)
    800059c2:	6402                	ld	s0,0(sp)
    800059c4:	0141                	addi	sp,sp,16
    800059c6:	8082                	ret

00000000800059c8 <plic_pending>:

// return a bitmap of which IRQs are waiting
// to be served.
uint64
plic_pending(void)
{
    800059c8:	1141                	addi	sp,sp,-16
    800059ca:	e422                	sd	s0,8(sp)
    800059cc:	0800                	addi	s0,sp,16
  //mask = *(uint32*)(PLIC + 0x1000);
  //mask |= (uint64)*(uint32*)(PLIC + 0x1004) << 32;
  mask = *(uint64*)PLIC_PENDING;

  return mask;
}
    800059ce:	0c0017b7          	lui	a5,0xc001
    800059d2:	6388                	ld	a0,0(a5)
    800059d4:	6422                	ld	s0,8(sp)
    800059d6:	0141                	addi	sp,sp,16
    800059d8:	8082                	ret

00000000800059da <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800059da:	1141                	addi	sp,sp,-16
    800059dc:	e406                	sd	ra,8(sp)
    800059de:	e022                	sd	s0,0(sp)
    800059e0:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800059e2:	ffffc097          	auipc	ra,0xffffc
    800059e6:	e36080e7          	jalr	-458(ra) # 80001818 <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800059ea:	00d5179b          	slliw	a5,a0,0xd
    800059ee:	0c201537          	lui	a0,0xc201
    800059f2:	953e                	add	a0,a0,a5
  return irq;
}
    800059f4:	4148                	lw	a0,4(a0)
    800059f6:	60a2                	ld	ra,8(sp)
    800059f8:	6402                	ld	s0,0(sp)
    800059fa:	0141                	addi	sp,sp,16
    800059fc:	8082                	ret

00000000800059fe <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800059fe:	1101                	addi	sp,sp,-32
    80005a00:	ec06                	sd	ra,24(sp)
    80005a02:	e822                	sd	s0,16(sp)
    80005a04:	e426                	sd	s1,8(sp)
    80005a06:	1000                	addi	s0,sp,32
    80005a08:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005a0a:	ffffc097          	auipc	ra,0xffffc
    80005a0e:	e0e080e7          	jalr	-498(ra) # 80001818 <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005a12:	00d5151b          	slliw	a0,a0,0xd
    80005a16:	0c2017b7          	lui	a5,0xc201
    80005a1a:	97aa                	add	a5,a5,a0
    80005a1c:	c3c4                	sw	s1,4(a5)
}
    80005a1e:	60e2                	ld	ra,24(sp)
    80005a20:	6442                	ld	s0,16(sp)
    80005a22:	64a2                	ld	s1,8(sp)
    80005a24:	6105                	addi	sp,sp,32
    80005a26:	8082                	ret

0000000080005a28 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005a28:	1141                	addi	sp,sp,-16
    80005a2a:	e406                	sd	ra,8(sp)
    80005a2c:	e022                	sd	s0,0(sp)
    80005a2e:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005a30:	479d                	li	a5,7
    80005a32:	04a7cc63          	blt	a5,a0,80005a8a <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005a36:	0001c797          	auipc	a5,0x1c
    80005a3a:	5ca78793          	addi	a5,a5,1482 # 80022000 <disk>
    80005a3e:	00a78733          	add	a4,a5,a0
    80005a42:	6789                	lui	a5,0x2
    80005a44:	97ba                	add	a5,a5,a4
    80005a46:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005a4a:	eba1                	bnez	a5,80005a9a <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005a4c:	00451713          	slli	a4,a0,0x4
    80005a50:	0001e797          	auipc	a5,0x1e
    80005a54:	5b07b783          	ld	a5,1456(a5) # 80024000 <disk+0x2000>
    80005a58:	97ba                	add	a5,a5,a4
    80005a5a:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005a5e:	0001c797          	auipc	a5,0x1c
    80005a62:	5a278793          	addi	a5,a5,1442 # 80022000 <disk>
    80005a66:	97aa                	add	a5,a5,a0
    80005a68:	6509                	lui	a0,0x2
    80005a6a:	953e                	add	a0,a0,a5
    80005a6c:	4785                	li	a5,1
    80005a6e:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005a72:	0001e517          	auipc	a0,0x1e
    80005a76:	5a650513          	addi	a0,a0,1446 # 80024018 <disk+0x2018>
    80005a7a:	ffffc097          	auipc	ra,0xffffc
    80005a7e:	6f2080e7          	jalr	1778(ra) # 8000216c <wakeup>
}
    80005a82:	60a2                	ld	ra,8(sp)
    80005a84:	6402                	ld	s0,0(sp)
    80005a86:	0141                	addi	sp,sp,16
    80005a88:	8082                	ret
    panic("virtio_disk_intr 1");
    80005a8a:	00001517          	auipc	a0,0x1
    80005a8e:	cce50513          	addi	a0,a0,-818 # 80006758 <userret+0x6c8>
    80005a92:	ffffb097          	auipc	ra,0xffffb
    80005a96:	abc080e7          	jalr	-1348(ra) # 8000054e <panic>
    panic("virtio_disk_intr 2");
    80005a9a:	00001517          	auipc	a0,0x1
    80005a9e:	cd650513          	addi	a0,a0,-810 # 80006770 <userret+0x6e0>
    80005aa2:	ffffb097          	auipc	ra,0xffffb
    80005aa6:	aac080e7          	jalr	-1364(ra) # 8000054e <panic>

0000000080005aaa <virtio_disk_init>:
{
    80005aaa:	1101                	addi	sp,sp,-32
    80005aac:	ec06                	sd	ra,24(sp)
    80005aae:	e822                	sd	s0,16(sp)
    80005ab0:	e426                	sd	s1,8(sp)
    80005ab2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005ab4:	00001597          	auipc	a1,0x1
    80005ab8:	cd458593          	addi	a1,a1,-812 # 80006788 <userret+0x6f8>
    80005abc:	0001e517          	auipc	a0,0x1e
    80005ac0:	5ec50513          	addi	a0,a0,1516 # 800240a8 <disk+0x20a8>
    80005ac4:	ffffb097          	auipc	ra,0xffffb
    80005ac8:	efc080e7          	jalr	-260(ra) # 800009c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005acc:	100017b7          	lui	a5,0x10001
    80005ad0:	4398                	lw	a4,0(a5)
    80005ad2:	2701                	sext.w	a4,a4
    80005ad4:	747277b7          	lui	a5,0x74727
    80005ad8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005adc:	0ef71163          	bne	a4,a5,80005bbe <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005ae0:	100017b7          	lui	a5,0x10001
    80005ae4:	43dc                	lw	a5,4(a5)
    80005ae6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005ae8:	4705                	li	a4,1
    80005aea:	0ce79a63          	bne	a5,a4,80005bbe <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005aee:	100017b7          	lui	a5,0x10001
    80005af2:	479c                	lw	a5,8(a5)
    80005af4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005af6:	4709                	li	a4,2
    80005af8:	0ce79363          	bne	a5,a4,80005bbe <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005afc:	100017b7          	lui	a5,0x10001
    80005b00:	47d8                	lw	a4,12(a5)
    80005b02:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005b04:	554d47b7          	lui	a5,0x554d4
    80005b08:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005b0c:	0af71963          	bne	a4,a5,80005bbe <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b10:	100017b7          	lui	a5,0x10001
    80005b14:	4705                	li	a4,1
    80005b16:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b18:	470d                	li	a4,3
    80005b1a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005b1c:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005b1e:	c7ffe737          	lui	a4,0xc7ffe
    80005b22:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9743>
    80005b26:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005b28:	2701                	sext.w	a4,a4
    80005b2a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b2c:	472d                	li	a4,11
    80005b2e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b30:	473d                	li	a4,15
    80005b32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005b34:	6705                	lui	a4,0x1
    80005b36:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005b38:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005b3c:	5bdc                	lw	a5,52(a5)
    80005b3e:	2781                	sext.w	a5,a5
  if(max == 0)
    80005b40:	c7d9                	beqz	a5,80005bce <virtio_disk_init+0x124>
  if(max < NUM)
    80005b42:	471d                	li	a4,7
    80005b44:	08f77d63          	bgeu	a4,a5,80005bde <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005b48:	100014b7          	lui	s1,0x10001
    80005b4c:	47a1                	li	a5,8
    80005b4e:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005b50:	6609                	lui	a2,0x2
    80005b52:	4581                	li	a1,0
    80005b54:	0001c517          	auipc	a0,0x1c
    80005b58:	4ac50513          	addi	a0,a0,1196 # 80022000 <disk>
    80005b5c:	ffffb097          	auipc	ra,0xffffb
    80005b60:	012080e7          	jalr	18(ra) # 80000b6e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005b64:	0001c717          	auipc	a4,0x1c
    80005b68:	49c70713          	addi	a4,a4,1180 # 80022000 <disk>
    80005b6c:	00c75793          	srli	a5,a4,0xc
    80005b70:	2781                	sext.w	a5,a5
    80005b72:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005b74:	0001e797          	auipc	a5,0x1e
    80005b78:	48c78793          	addi	a5,a5,1164 # 80024000 <disk+0x2000>
    80005b7c:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005b7e:	0001c717          	auipc	a4,0x1c
    80005b82:	50270713          	addi	a4,a4,1282 # 80022080 <disk+0x80>
    80005b86:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005b88:	0001d717          	auipc	a4,0x1d
    80005b8c:	47870713          	addi	a4,a4,1144 # 80023000 <disk+0x1000>
    80005b90:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005b92:	4705                	li	a4,1
    80005b94:	00e78c23          	sb	a4,24(a5)
    80005b98:	00e78ca3          	sb	a4,25(a5)
    80005b9c:	00e78d23          	sb	a4,26(a5)
    80005ba0:	00e78da3          	sb	a4,27(a5)
    80005ba4:	00e78e23          	sb	a4,28(a5)
    80005ba8:	00e78ea3          	sb	a4,29(a5)
    80005bac:	00e78f23          	sb	a4,30(a5)
    80005bb0:	00e78fa3          	sb	a4,31(a5)
}
    80005bb4:	60e2                	ld	ra,24(sp)
    80005bb6:	6442                	ld	s0,16(sp)
    80005bb8:	64a2                	ld	s1,8(sp)
    80005bba:	6105                	addi	sp,sp,32
    80005bbc:	8082                	ret
    panic("could not find virtio disk");
    80005bbe:	00001517          	auipc	a0,0x1
    80005bc2:	bda50513          	addi	a0,a0,-1062 # 80006798 <userret+0x708>
    80005bc6:	ffffb097          	auipc	ra,0xffffb
    80005bca:	988080e7          	jalr	-1656(ra) # 8000054e <panic>
    panic("virtio disk has no queue 0");
    80005bce:	00001517          	auipc	a0,0x1
    80005bd2:	bea50513          	addi	a0,a0,-1046 # 800067b8 <userret+0x728>
    80005bd6:	ffffb097          	auipc	ra,0xffffb
    80005bda:	978080e7          	jalr	-1672(ra) # 8000054e <panic>
    panic("virtio disk max queue too short");
    80005bde:	00001517          	auipc	a0,0x1
    80005be2:	bfa50513          	addi	a0,a0,-1030 # 800067d8 <userret+0x748>
    80005be6:	ffffb097          	auipc	ra,0xffffb
    80005bea:	968080e7          	jalr	-1688(ra) # 8000054e <panic>

0000000080005bee <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005bee:	7119                	addi	sp,sp,-128
    80005bf0:	fc86                	sd	ra,120(sp)
    80005bf2:	f8a2                	sd	s0,112(sp)
    80005bf4:	f4a6                	sd	s1,104(sp)
    80005bf6:	f0ca                	sd	s2,96(sp)
    80005bf8:	ecce                	sd	s3,88(sp)
    80005bfa:	e8d2                	sd	s4,80(sp)
    80005bfc:	e4d6                	sd	s5,72(sp)
    80005bfe:	e0da                	sd	s6,64(sp)
    80005c00:	fc5e                	sd	s7,56(sp)
    80005c02:	f862                	sd	s8,48(sp)
    80005c04:	f466                	sd	s9,40(sp)
    80005c06:	f06a                	sd	s10,32(sp)
    80005c08:	0100                	addi	s0,sp,128
    80005c0a:	892a                	mv	s2,a0
    80005c0c:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005c0e:	00c52c83          	lw	s9,12(a0)
    80005c12:	001c9c9b          	slliw	s9,s9,0x1
    80005c16:	1c82                	slli	s9,s9,0x20
    80005c18:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005c1c:	0001e517          	auipc	a0,0x1e
    80005c20:	48c50513          	addi	a0,a0,1164 # 800240a8 <disk+0x20a8>
    80005c24:	ffffb097          	auipc	ra,0xffffb
    80005c28:	eae080e7          	jalr	-338(ra) # 80000ad2 <acquire>
  for(int i = 0; i < 3; i++){
    80005c2c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005c2e:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005c30:	0001cb97          	auipc	s7,0x1c
    80005c34:	3d0b8b93          	addi	s7,s7,976 # 80022000 <disk>
    80005c38:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005c3a:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005c3c:	8a4e                	mv	s4,s3
    80005c3e:	a051                	j	80005cc2 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005c40:	00fb86b3          	add	a3,s7,a5
    80005c44:	96da                	add	a3,a3,s6
    80005c46:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005c4a:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005c4c:	0207c563          	bltz	a5,80005c76 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005c50:	2485                	addiw	s1,s1,1
    80005c52:	0711                	addi	a4,a4,4
    80005c54:	23548d63          	beq	s1,s5,80005e8e <virtio_disk_rw+0x2a0>
    idx[i] = alloc_desc();
    80005c58:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005c5a:	0001e697          	auipc	a3,0x1e
    80005c5e:	3be68693          	addi	a3,a3,958 # 80024018 <disk+0x2018>
    80005c62:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005c64:	0006c583          	lbu	a1,0(a3)
    80005c68:	fde1                	bnez	a1,80005c40 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005c6a:	2785                	addiw	a5,a5,1
    80005c6c:	0685                	addi	a3,a3,1
    80005c6e:	ff879be3          	bne	a5,s8,80005c64 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005c72:	57fd                	li	a5,-1
    80005c74:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005c76:	02905a63          	blez	s1,80005caa <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005c7a:	f9042503          	lw	a0,-112(s0)
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	daa080e7          	jalr	-598(ra) # 80005a28 <free_desc>
      for(int j = 0; j < i; j++)
    80005c86:	4785                	li	a5,1
    80005c88:	0297d163          	bge	a5,s1,80005caa <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005c8c:	f9442503          	lw	a0,-108(s0)
    80005c90:	00000097          	auipc	ra,0x0
    80005c94:	d98080e7          	jalr	-616(ra) # 80005a28 <free_desc>
      for(int j = 0; j < i; j++)
    80005c98:	4789                	li	a5,2
    80005c9a:	0097d863          	bge	a5,s1,80005caa <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005c9e:	f9842503          	lw	a0,-104(s0)
    80005ca2:	00000097          	auipc	ra,0x0
    80005ca6:	d86080e7          	jalr	-634(ra) # 80005a28 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005caa:	0001e597          	auipc	a1,0x1e
    80005cae:	3fe58593          	addi	a1,a1,1022 # 800240a8 <disk+0x20a8>
    80005cb2:	0001e517          	auipc	a0,0x1e
    80005cb6:	36650513          	addi	a0,a0,870 # 80024018 <disk+0x2018>
    80005cba:	ffffc097          	auipc	ra,0xffffc
    80005cbe:	32c080e7          	jalr	812(ra) # 80001fe6 <sleep>
  for(int i = 0; i < 3; i++){
    80005cc2:	f9040713          	addi	a4,s0,-112
    80005cc6:	84ce                	mv	s1,s3
    80005cc8:	bf41                	j	80005c58 <virtio_disk_rw+0x6a>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    80005cca:	4785                	li	a5,1
    80005ccc:	f8f42023          	sw	a5,-128(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    80005cd0:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80005cd4:	f9943423          	sd	s9,-120(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80005cd8:	f9042983          	lw	s3,-112(s0)
    80005cdc:	00499493          	slli	s1,s3,0x4
    80005ce0:	0001ea17          	auipc	s4,0x1e
    80005ce4:	320a0a13          	addi	s4,s4,800 # 80024000 <disk+0x2000>
    80005ce8:	000a3a83          	ld	s5,0(s4)
    80005cec:	9aa6                	add	s5,s5,s1
    80005cee:	f8040513          	addi	a0,s0,-128
    80005cf2:	ffffb097          	auipc	ra,0xffffb
    80005cf6:	2ba080e7          	jalr	698(ra) # 80000fac <kvmpa>
    80005cfa:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    80005cfe:	000a3783          	ld	a5,0(s4)
    80005d02:	97a6                	add	a5,a5,s1
    80005d04:	4741                	li	a4,16
    80005d06:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005d08:	000a3783          	ld	a5,0(s4)
    80005d0c:	97a6                	add	a5,a5,s1
    80005d0e:	4705                	li	a4,1
    80005d10:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005d14:	f9442703          	lw	a4,-108(s0)
    80005d18:	000a3783          	ld	a5,0(s4)
    80005d1c:	97a6                	add	a5,a5,s1
    80005d1e:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005d22:	0712                	slli	a4,a4,0x4
    80005d24:	000a3783          	ld	a5,0(s4)
    80005d28:	97ba                	add	a5,a5,a4
    80005d2a:	06090693          	addi	a3,s2,96
    80005d2e:	e394                	sd	a3,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    80005d30:	000a3783          	ld	a5,0(s4)
    80005d34:	97ba                	add	a5,a5,a4
    80005d36:	40000693          	li	a3,1024
    80005d3a:	c794                	sw	a3,8(a5)
  if(write)
    80005d3c:	100d0a63          	beqz	s10,80005e50 <virtio_disk_rw+0x262>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005d40:	0001e797          	auipc	a5,0x1e
    80005d44:	2c07b783          	ld	a5,704(a5) # 80024000 <disk+0x2000>
    80005d48:	97ba                	add	a5,a5,a4
    80005d4a:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005d4e:	0001c517          	auipc	a0,0x1c
    80005d52:	2b250513          	addi	a0,a0,690 # 80022000 <disk>
    80005d56:	0001e797          	auipc	a5,0x1e
    80005d5a:	2aa78793          	addi	a5,a5,682 # 80024000 <disk+0x2000>
    80005d5e:	6394                	ld	a3,0(a5)
    80005d60:	96ba                	add	a3,a3,a4
    80005d62:	00c6d603          	lhu	a2,12(a3)
    80005d66:	00166613          	ori	a2,a2,1
    80005d6a:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005d6e:	f9842683          	lw	a3,-104(s0)
    80005d72:	6390                	ld	a2,0(a5)
    80005d74:	9732                	add	a4,a4,a2
    80005d76:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0;
    80005d7a:	20098613          	addi	a2,s3,512
    80005d7e:	0612                	slli	a2,a2,0x4
    80005d80:	962a                	add	a2,a2,a0
    80005d82:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005d86:	00469713          	slli	a4,a3,0x4
    80005d8a:	6394                	ld	a3,0(a5)
    80005d8c:	96ba                	add	a3,a3,a4
    80005d8e:	6589                	lui	a1,0x2
    80005d90:	03058593          	addi	a1,a1,48 # 2030 <_entry-0x7fffdfd0>
    80005d94:	94ae                	add	s1,s1,a1
    80005d96:	94aa                	add	s1,s1,a0
    80005d98:	e284                	sd	s1,0(a3)
  disk.desc[idx[2]].len = 1;
    80005d9a:	6394                	ld	a3,0(a5)
    80005d9c:	96ba                	add	a3,a3,a4
    80005d9e:	4585                	li	a1,1
    80005da0:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005da2:	6394                	ld	a3,0(a5)
    80005da4:	96ba                	add	a3,a3,a4
    80005da6:	4509                	li	a0,2
    80005da8:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005dac:	6394                	ld	a3,0(a5)
    80005dae:	9736                	add	a4,a4,a3
    80005db0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005db4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005db8:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005dbc:	6794                	ld	a3,8(a5)
    80005dbe:	0026d703          	lhu	a4,2(a3)
    80005dc2:	8b1d                	andi	a4,a4,7
    80005dc4:	2709                	addiw	a4,a4,2
    80005dc6:	0706                	slli	a4,a4,0x1
    80005dc8:	9736                	add	a4,a4,a3
    80005dca:	01371023          	sh	s3,0(a4)
  __sync_synchronize();
    80005dce:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80005dd2:	6798                	ld	a4,8(a5)
    80005dd4:	00275783          	lhu	a5,2(a4)
    80005dd8:	2785                	addiw	a5,a5,1
    80005dda:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005dde:	100017b7          	lui	a5,0x10001
    80005de2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005de6:	00492703          	lw	a4,4(s2)
    80005dea:	4785                	li	a5,1
    80005dec:	02f71163          	bne	a4,a5,80005e0e <virtio_disk_rw+0x220>
    sleep(b, &disk.vdisk_lock);
    80005df0:	0001e997          	auipc	s3,0x1e
    80005df4:	2b898993          	addi	s3,s3,696 # 800240a8 <disk+0x20a8>
  while(b->disk == 1) {
    80005df8:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005dfa:	85ce                	mv	a1,s3
    80005dfc:	854a                	mv	a0,s2
    80005dfe:	ffffc097          	auipc	ra,0xffffc
    80005e02:	1e8080e7          	jalr	488(ra) # 80001fe6 <sleep>
  while(b->disk == 1) {
    80005e06:	00492783          	lw	a5,4(s2)
    80005e0a:	fe9788e3          	beq	a5,s1,80005dfa <virtio_disk_rw+0x20c>
  }

  disk.info[idx[0]].b = 0;
    80005e0e:	f9042483          	lw	s1,-112(s0)
    80005e12:	20048793          	addi	a5,s1,512 # 10001200 <_entry-0x6fffee00>
    80005e16:	00479713          	slli	a4,a5,0x4
    80005e1a:	0001c797          	auipc	a5,0x1c
    80005e1e:	1e678793          	addi	a5,a5,486 # 80022000 <disk>
    80005e22:	97ba                	add	a5,a5,a4
    80005e24:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005e28:	0001e917          	auipc	s2,0x1e
    80005e2c:	1d890913          	addi	s2,s2,472 # 80024000 <disk+0x2000>
    free_desc(i);
    80005e30:	8526                	mv	a0,s1
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	bf6080e7          	jalr	-1034(ra) # 80005a28 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005e3a:	0492                	slli	s1,s1,0x4
    80005e3c:	00093783          	ld	a5,0(s2)
    80005e40:	94be                	add	s1,s1,a5
    80005e42:	00c4d783          	lhu	a5,12(s1)
    80005e46:	8b85                	andi	a5,a5,1
    80005e48:	cf89                	beqz	a5,80005e62 <virtio_disk_rw+0x274>
      i = disk.desc[i].next;
    80005e4a:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80005e4e:	b7cd                	j	80005e30 <virtio_disk_rw+0x242>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005e50:	0001e797          	auipc	a5,0x1e
    80005e54:	1b07b783          	ld	a5,432(a5) # 80024000 <disk+0x2000>
    80005e58:	97ba                	add	a5,a5,a4
    80005e5a:	4689                	li	a3,2
    80005e5c:	00d79623          	sh	a3,12(a5)
    80005e60:	b5fd                	j	80005d4e <virtio_disk_rw+0x160>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005e62:	0001e517          	auipc	a0,0x1e
    80005e66:	24650513          	addi	a0,a0,582 # 800240a8 <disk+0x20a8>
    80005e6a:	ffffb097          	auipc	ra,0xffffb
    80005e6e:	cbc080e7          	jalr	-836(ra) # 80000b26 <release>
}
    80005e72:	70e6                	ld	ra,120(sp)
    80005e74:	7446                	ld	s0,112(sp)
    80005e76:	74a6                	ld	s1,104(sp)
    80005e78:	7906                	ld	s2,96(sp)
    80005e7a:	69e6                	ld	s3,88(sp)
    80005e7c:	6a46                	ld	s4,80(sp)
    80005e7e:	6aa6                	ld	s5,72(sp)
    80005e80:	6b06                	ld	s6,64(sp)
    80005e82:	7be2                	ld	s7,56(sp)
    80005e84:	7c42                	ld	s8,48(sp)
    80005e86:	7ca2                	ld	s9,40(sp)
    80005e88:	7d02                	ld	s10,32(sp)
    80005e8a:	6109                	addi	sp,sp,128
    80005e8c:	8082                	ret
  if(write)
    80005e8e:	e20d1ee3          	bnez	s10,80005cca <virtio_disk_rw+0xdc>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    80005e92:	f8042023          	sw	zero,-128(s0)
    80005e96:	bd2d                	j	80005cd0 <virtio_disk_rw+0xe2>

0000000080005e98 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005e98:	1101                	addi	sp,sp,-32
    80005e9a:	ec06                	sd	ra,24(sp)
    80005e9c:	e822                	sd	s0,16(sp)
    80005e9e:	e426                	sd	s1,8(sp)
    80005ea0:	e04a                	sd	s2,0(sp)
    80005ea2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005ea4:	0001e517          	auipc	a0,0x1e
    80005ea8:	20450513          	addi	a0,a0,516 # 800240a8 <disk+0x20a8>
    80005eac:	ffffb097          	auipc	ra,0xffffb
    80005eb0:	c26080e7          	jalr	-986(ra) # 80000ad2 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80005eb4:	0001e717          	auipc	a4,0x1e
    80005eb8:	14c70713          	addi	a4,a4,332 # 80024000 <disk+0x2000>
    80005ebc:	02075783          	lhu	a5,32(a4)
    80005ec0:	6b18                	ld	a4,16(a4)
    80005ec2:	00275683          	lhu	a3,2(a4)
    80005ec6:	8ebd                	xor	a3,a3,a5
    80005ec8:	8a9d                	andi	a3,a3,7
    80005eca:	cab9                	beqz	a3,80005f20 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    80005ecc:	0001c917          	auipc	s2,0x1c
    80005ed0:	13490913          	addi	s2,s2,308 # 80022000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80005ed4:	0001e497          	auipc	s1,0x1e
    80005ed8:	12c48493          	addi	s1,s1,300 # 80024000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80005edc:	078e                	slli	a5,a5,0x3
    80005ede:	97ba                	add	a5,a5,a4
    80005ee0:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80005ee2:	20078713          	addi	a4,a5,512
    80005ee6:	0712                	slli	a4,a4,0x4
    80005ee8:	974a                	add	a4,a4,s2
    80005eea:	03074703          	lbu	a4,48(a4)
    80005eee:	e739                	bnez	a4,80005f3c <virtio_disk_intr+0xa4>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80005ef0:	20078793          	addi	a5,a5,512
    80005ef4:	0792                	slli	a5,a5,0x4
    80005ef6:	97ca                	add	a5,a5,s2
    80005ef8:	7798                	ld	a4,40(a5)
    80005efa:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80005efe:	7788                	ld	a0,40(a5)
    80005f00:	ffffc097          	auipc	ra,0xffffc
    80005f04:	26c080e7          	jalr	620(ra) # 8000216c <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80005f08:	0204d783          	lhu	a5,32(s1)
    80005f0c:	2785                	addiw	a5,a5,1
    80005f0e:	8b9d                	andi	a5,a5,7
    80005f10:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80005f14:	6898                	ld	a4,16(s1)
    80005f16:	00275683          	lhu	a3,2(a4)
    80005f1a:	8a9d                	andi	a3,a3,7
    80005f1c:	fcf690e3          	bne	a3,a5,80005edc <virtio_disk_intr+0x44>
  }

  release(&disk.vdisk_lock);
    80005f20:	0001e517          	auipc	a0,0x1e
    80005f24:	18850513          	addi	a0,a0,392 # 800240a8 <disk+0x20a8>
    80005f28:	ffffb097          	auipc	ra,0xffffb
    80005f2c:	bfe080e7          	jalr	-1026(ra) # 80000b26 <release>
}
    80005f30:	60e2                	ld	ra,24(sp)
    80005f32:	6442                	ld	s0,16(sp)
    80005f34:	64a2                	ld	s1,8(sp)
    80005f36:	6902                	ld	s2,0(sp)
    80005f38:	6105                	addi	sp,sp,32
    80005f3a:	8082                	ret
      panic("virtio_disk_intr status");
    80005f3c:	00001517          	auipc	a0,0x1
    80005f40:	8bc50513          	addi	a0,a0,-1860 # 800067f8 <userret+0x768>
    80005f44:	ffffa097          	auipc	ra,0xffffa
    80005f48:	60a080e7          	jalr	1546(ra) # 8000054e <panic>
	...

0000000080006000 <trampoline>:
    80006000:	14051573          	csrrw	a0,sscratch,a0
    80006004:	02153423          	sd	ra,40(a0)
    80006008:	02253823          	sd	sp,48(a0)
    8000600c:	02353c23          	sd	gp,56(a0)
    80006010:	04453023          	sd	tp,64(a0)
    80006014:	04553423          	sd	t0,72(a0)
    80006018:	04653823          	sd	t1,80(a0)
    8000601c:	04753c23          	sd	t2,88(a0)
    80006020:	f120                	sd	s0,96(a0)
    80006022:	f524                	sd	s1,104(a0)
    80006024:	fd2c                	sd	a1,120(a0)
    80006026:	e150                	sd	a2,128(a0)
    80006028:	e554                	sd	a3,136(a0)
    8000602a:	e958                	sd	a4,144(a0)
    8000602c:	ed5c                	sd	a5,152(a0)
    8000602e:	0b053023          	sd	a6,160(a0)
    80006032:	0b153423          	sd	a7,168(a0)
    80006036:	0b253823          	sd	s2,176(a0)
    8000603a:	0b353c23          	sd	s3,184(a0)
    8000603e:	0d453023          	sd	s4,192(a0)
    80006042:	0d553423          	sd	s5,200(a0)
    80006046:	0d653823          	sd	s6,208(a0)
    8000604a:	0d753c23          	sd	s7,216(a0)
    8000604e:	0f853023          	sd	s8,224(a0)
    80006052:	0f953423          	sd	s9,232(a0)
    80006056:	0fa53823          	sd	s10,240(a0)
    8000605a:	0fb53c23          	sd	s11,248(a0)
    8000605e:	11c53023          	sd	t3,256(a0)
    80006062:	11d53423          	sd	t4,264(a0)
    80006066:	11e53823          	sd	t5,272(a0)
    8000606a:	11f53c23          	sd	t6,280(a0)
    8000606e:	140022f3          	csrr	t0,sscratch
    80006072:	06553823          	sd	t0,112(a0)
    80006076:	00853103          	ld	sp,8(a0)
    8000607a:	02053203          	ld	tp,32(a0)
    8000607e:	01053283          	ld	t0,16(a0)
    80006082:	00053303          	ld	t1,0(a0)
    80006086:	18031073          	csrw	satp,t1
    8000608a:	12000073          	sfence.vma
    8000608e:	8282                	jr	t0

0000000080006090 <userret>:
    80006090:	18059073          	csrw	satp,a1
    80006094:	12000073          	sfence.vma
    80006098:	07053283          	ld	t0,112(a0)
    8000609c:	14029073          	csrw	sscratch,t0
    800060a0:	02853083          	ld	ra,40(a0)
    800060a4:	03053103          	ld	sp,48(a0)
    800060a8:	03853183          	ld	gp,56(a0)
    800060ac:	04053203          	ld	tp,64(a0)
    800060b0:	04853283          	ld	t0,72(a0)
    800060b4:	05053303          	ld	t1,80(a0)
    800060b8:	05853383          	ld	t2,88(a0)
    800060bc:	7120                	ld	s0,96(a0)
    800060be:	7524                	ld	s1,104(a0)
    800060c0:	7d2c                	ld	a1,120(a0)
    800060c2:	6150                	ld	a2,128(a0)
    800060c4:	6554                	ld	a3,136(a0)
    800060c6:	6958                	ld	a4,144(a0)
    800060c8:	6d5c                	ld	a5,152(a0)
    800060ca:	0a053803          	ld	a6,160(a0)
    800060ce:	0a853883          	ld	a7,168(a0)
    800060d2:	0b053903          	ld	s2,176(a0)
    800060d6:	0b853983          	ld	s3,184(a0)
    800060da:	0c053a03          	ld	s4,192(a0)
    800060de:	0c853a83          	ld	s5,200(a0)
    800060e2:	0d053b03          	ld	s6,208(a0)
    800060e6:	0d853b83          	ld	s7,216(a0)
    800060ea:	0e053c03          	ld	s8,224(a0)
    800060ee:	0e853c83          	ld	s9,232(a0)
    800060f2:	0f053d03          	ld	s10,240(a0)
    800060f6:	0f853d83          	ld	s11,248(a0)
    800060fa:	10053e03          	ld	t3,256(a0)
    800060fe:	10853e83          	ld	t4,264(a0)
    80006102:	11053f03          	ld	t5,272(a0)
    80006106:	11853f83          	ld	t6,280(a0)
    8000610a:	14051573          	csrrw	a0,sscratch,a0
    8000610e:	10200073          	sret
