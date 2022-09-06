
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1b2080e7          	jalr	434(ra) # 1da <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	25a080e7          	jalr	602(ra) # 28a <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	21a080e7          	jalr	538(ra) # 25a <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	73858593          	addi	a1,a1,1848 # 780 <malloc+0xe8>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	55a080e7          	jalr	1370(ra) # 5ac <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	1fe080e7          	jalr	510(ra) # 25a <exit>

0000000000000064 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x26>
  b8:	0505                	addi	a0,a0,1
  ba:	87aa                	mv	a5,a0
  bc:	4685                	li	a3,1
  be:	9e89                	subw	a3,a3,a0
  c0:	00f6853b          	addw	a0,a3,a5
  c4:	0785                	addi	a5,a5,1
  c6:	fff7c703          	lbu	a4,-1(a5)
  ca:	fb7d                	bnez	a4,c0 <strlen+0x14>
    ;
  return n;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret
  for(n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfe5                	j	cc <strlen+0x20>

00000000000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  dc:	ce09                	beqz	a2,f6 <memset+0x20>
  de:	87aa                	mv	a5,a0
  e0:	fff6071b          	addiw	a4,a2,-1
  e4:	1702                	slli	a4,a4,0x20
  e6:	9301                	srli	a4,a4,0x20
  e8:	0705                	addi	a4,a4,1
  ea:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f0:	0785                	addi	a5,a5,1
  f2:	fee79de3          	bne	a5,a4,ec <memset+0x16>
  }
  return dst;
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
  for(; *s; s++)
 102:	00054783          	lbu	a5,0(a0)
 106:	cb99                	beqz	a5,11c <strchr+0x20>
    if(*s == c)
 108:	00f58763          	beq	a1,a5,116 <strchr+0x1a>
  for(; *s; s++)
 10c:	0505                	addi	a0,a0,1
 10e:	00054783          	lbu	a5,0(a0)
 112:	fbfd                	bnez	a5,108 <strchr+0xc>
      return (char*)s;
  return 0;
 114:	4501                	li	a0,0
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  return 0;
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strchr+0x1a>

0000000000000120 <gets>:

char*
gets(char *buf, int max)
{
 120:	711d                	addi	sp,sp,-96
 122:	ec86                	sd	ra,88(sp)
 124:	e8a2                	sd	s0,80(sp)
 126:	e4a6                	sd	s1,72(sp)
 128:	e0ca                	sd	s2,64(sp)
 12a:	fc4e                	sd	s3,56(sp)
 12c:	f852                	sd	s4,48(sp)
 12e:	f456                	sd	s5,40(sp)
 130:	f05a                	sd	s6,32(sp)
 132:	ec5e                	sd	s7,24(sp)
 134:	1080                	addi	s0,sp,96
 136:	8baa                	mv	s7,a0
 138:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	892a                	mv	s2,a0
 13c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13e:	4aa9                	li	s5,10
 140:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 142:	89a6                	mv	s3,s1
 144:	2485                	addiw	s1,s1,1
 146:	0344d863          	bge	s1,s4,176 <gets+0x56>
    cc = read(0, &c, 1);
 14a:	4605                	li	a2,1
 14c:	faf40593          	addi	a1,s0,-81
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	120080e7          	jalr	288(ra) # 272 <read>
    if(cc < 1)
 15a:	00a05e63          	blez	a0,176 <gets+0x56>
    buf[i++] = c;
 15e:	faf44783          	lbu	a5,-81(s0)
 162:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 166:	01578763          	beq	a5,s5,174 <gets+0x54>
 16a:	0905                	addi	s2,s2,1
 16c:	fd679be3          	bne	a5,s6,142 <gets+0x22>
  for(i=0; i+1 < max; ){
 170:	89a6                	mv	s3,s1
 172:	a011                	j	176 <gets+0x56>
 174:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 176:	99de                	add	s3,s3,s7
 178:	00098023          	sb	zero,0(s3)
  return buf;
}
 17c:	855e                	mv	a0,s7
 17e:	60e6                	ld	ra,88(sp)
 180:	6446                	ld	s0,80(sp)
 182:	64a6                	ld	s1,72(sp)
 184:	6906                	ld	s2,64(sp)
 186:	79e2                	ld	s3,56(sp)
 188:	7a42                	ld	s4,48(sp)
 18a:	7aa2                	ld	s5,40(sp)
 18c:	7b02                	ld	s6,32(sp)
 18e:	6be2                	ld	s7,24(sp)
 190:	6125                	addi	sp,sp,96
 192:	8082                	ret

0000000000000194 <stat>:

int
stat(const char *n, struct stat *st)
{
 194:	1101                	addi	sp,sp,-32
 196:	ec06                	sd	ra,24(sp)
 198:	e822                	sd	s0,16(sp)
 19a:	e426                	sd	s1,8(sp)
 19c:	e04a                	sd	s2,0(sp)
 19e:	1000                	addi	s0,sp,32
 1a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	4581                	li	a1,0
 1a4:	00000097          	auipc	ra,0x0
 1a8:	0f6080e7          	jalr	246(ra) # 29a <open>
  if(fd < 0)
 1ac:	02054563          	bltz	a0,1d6 <stat+0x42>
 1b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b2:	85ca                	mv	a1,s2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	0fe080e7          	jalr	254(ra) # 2b2 <fstat>
 1bc:	892a                	mv	s2,a0
  close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	0c2080e7          	jalr	194(ra) # 282 <close>
  return r;
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	64a2                	ld	s1,8(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfc5                	j	1c8 <stat+0x34>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054603          	lbu	a2,0(a0)
 1e4:	fd06079b          	addiw	a5,a2,-48
 1e8:	0ff7f793          	andi	a5,a5,255
 1ec:	4725                	li	a4,9
 1ee:	02f76963          	bltu	a4,a5,220 <atoi+0x46>
 1f2:	86aa                	mv	a3,a0
  n = 0;
 1f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f8:	0685                	addi	a3,a3,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb1                	addw	a5,a5,a2
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	0006c603          	lbu	a2,0(a3)
 20e:	fd06071b          	addiw	a4,a2,-48
 212:	0ff77713          	andi	a4,a4,255
 216:	fee5f1e3          	bgeu	a1,a4,1f8 <atoi+0x1e>
  return n;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
  n = 0;
 220:	4501                	li	a0,0
 222:	bfe5                	j	21a <atoi+0x40>

0000000000000224 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22a:	02c05163          	blez	a2,24c <memmove+0x28>
 22e:	fff6071b          	addiw	a4,a2,-1
 232:	1702                	slli	a4,a4,0x20
 234:	9301                	srli	a4,a4,0x20
 236:	0705                	addi	a4,a4,1
 238:	972a                	add	a4,a4,a0
  dst = vdst;
 23a:	87aa                	mv	a5,a0
    *dst++ = *src++;
 23c:	0585                	addi	a1,a1,1
 23e:	0785                	addi	a5,a5,1
 240:	fff5c683          	lbu	a3,-1(a1)
 244:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 248:	fee79ae3          	bne	a5,a4,23c <memmove+0x18>
  return vdst;
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret

0000000000000252 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 252:	4885                	li	a7,1
 ecall
 254:	00000073          	ecall
 ret
 258:	8082                	ret

000000000000025a <exit>:
.global exit
exit:
 li a7, SYS_exit
 25a:	4889                	li	a7,2
 ecall
 25c:	00000073          	ecall
 ret
 260:	8082                	ret

0000000000000262 <wait>:
.global wait
wait:
 li a7, SYS_wait
 262:	488d                	li	a7,3
 ecall
 264:	00000073          	ecall
 ret
 268:	8082                	ret

000000000000026a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 26a:	4891                	li	a7,4
 ecall
 26c:	00000073          	ecall
 ret
 270:	8082                	ret

0000000000000272 <read>:
.global read
read:
 li a7, SYS_read
 272:	4895                	li	a7,5
 ecall
 274:	00000073          	ecall
 ret
 278:	8082                	ret

000000000000027a <write>:
.global write
write:
 li a7, SYS_write
 27a:	48c1                	li	a7,16
 ecall
 27c:	00000073          	ecall
 ret
 280:	8082                	ret

0000000000000282 <close>:
.global close
close:
 li a7, SYS_close
 282:	48d5                	li	a7,21
 ecall
 284:	00000073          	ecall
 ret
 288:	8082                	ret

000000000000028a <kill>:
.global kill
kill:
 li a7, SYS_kill
 28a:	4899                	li	a7,6
 ecall
 28c:	00000073          	ecall
 ret
 290:	8082                	ret

0000000000000292 <exec>:
.global exec
exec:
 li a7, SYS_exec
 292:	489d                	li	a7,7
 ecall
 294:	00000073          	ecall
 ret
 298:	8082                	ret

000000000000029a <open>:
.global open
open:
 li a7, SYS_open
 29a:	48bd                	li	a7,15
 ecall
 29c:	00000073          	ecall
 ret
 2a0:	8082                	ret

00000000000002a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2a2:	48c5                	li	a7,17
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2aa:	48c9                	li	a7,18
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2b2:	48a1                	li	a7,8
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <link>:
.global link
link:
 li a7, SYS_link
 2ba:	48cd                	li	a7,19
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2c2:	48d1                	li	a7,20
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2ca:	48a5                	li	a7,9
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2d2:	48a9                	li	a7,10
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2da:	48ad                	li	a7,11
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2e2:	48b1                	li	a7,12
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2ea:	48b5                	li	a7,13
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 2f2:	48b9                	li	a7,14
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 2fa:	48d9                	li	a7,22
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 302:	1101                	addi	sp,sp,-32
 304:	ec06                	sd	ra,24(sp)
 306:	e822                	sd	s0,16(sp)
 308:	1000                	addi	s0,sp,32
 30a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 30e:	4605                	li	a2,1
 310:	fef40593          	addi	a1,s0,-17
 314:	00000097          	auipc	ra,0x0
 318:	f66080e7          	jalr	-154(ra) # 27a <write>
}
 31c:	60e2                	ld	ra,24(sp)
 31e:	6442                	ld	s0,16(sp)
 320:	6105                	addi	sp,sp,32
 322:	8082                	ret

0000000000000324 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 324:	7139                	addi	sp,sp,-64
 326:	fc06                	sd	ra,56(sp)
 328:	f822                	sd	s0,48(sp)
 32a:	f426                	sd	s1,40(sp)
 32c:	f04a                	sd	s2,32(sp)
 32e:	ec4e                	sd	s3,24(sp)
 330:	0080                	addi	s0,sp,64
 332:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 334:	c299                	beqz	a3,33a <printint+0x16>
 336:	0805c863          	bltz	a1,3c6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 33a:	2581                	sext.w	a1,a1
  neg = 0;
 33c:	4881                	li	a7,0
 33e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 342:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 344:	2601                	sext.w	a2,a2
 346:	00000517          	auipc	a0,0x0
 34a:	45a50513          	addi	a0,a0,1114 # 7a0 <digits>
 34e:	883a                	mv	a6,a4
 350:	2705                	addiw	a4,a4,1
 352:	02c5f7bb          	remuw	a5,a1,a2
 356:	1782                	slli	a5,a5,0x20
 358:	9381                	srli	a5,a5,0x20
 35a:	97aa                	add	a5,a5,a0
 35c:	0007c783          	lbu	a5,0(a5)
 360:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 364:	0005879b          	sext.w	a5,a1
 368:	02c5d5bb          	divuw	a1,a1,a2
 36c:	0685                	addi	a3,a3,1
 36e:	fec7f0e3          	bgeu	a5,a2,34e <printint+0x2a>
  if(neg)
 372:	00088b63          	beqz	a7,388 <printint+0x64>
    buf[i++] = '-';
 376:	fd040793          	addi	a5,s0,-48
 37a:	973e                	add	a4,a4,a5
 37c:	02d00793          	li	a5,45
 380:	fef70823          	sb	a5,-16(a4)
 384:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 388:	02e05863          	blez	a4,3b8 <printint+0x94>
 38c:	fc040793          	addi	a5,s0,-64
 390:	00e78933          	add	s2,a5,a4
 394:	fff78993          	addi	s3,a5,-1
 398:	99ba                	add	s3,s3,a4
 39a:	377d                	addiw	a4,a4,-1
 39c:	1702                	slli	a4,a4,0x20
 39e:	9301                	srli	a4,a4,0x20
 3a0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3a4:	fff94583          	lbu	a1,-1(s2)
 3a8:	8526                	mv	a0,s1
 3aa:	00000097          	auipc	ra,0x0
 3ae:	f58080e7          	jalr	-168(ra) # 302 <putc>
  while(--i >= 0)
 3b2:	197d                	addi	s2,s2,-1
 3b4:	ff3918e3          	bne	s2,s3,3a4 <printint+0x80>
}
 3b8:	70e2                	ld	ra,56(sp)
 3ba:	7442                	ld	s0,48(sp)
 3bc:	74a2                	ld	s1,40(sp)
 3be:	7902                	ld	s2,32(sp)
 3c0:	69e2                	ld	s3,24(sp)
 3c2:	6121                	addi	sp,sp,64
 3c4:	8082                	ret
    x = -xx;
 3c6:	40b005bb          	negw	a1,a1
    neg = 1;
 3ca:	4885                	li	a7,1
    x = -xx;
 3cc:	bf8d                	j	33e <printint+0x1a>

00000000000003ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3ce:	7119                	addi	sp,sp,-128
 3d0:	fc86                	sd	ra,120(sp)
 3d2:	f8a2                	sd	s0,112(sp)
 3d4:	f4a6                	sd	s1,104(sp)
 3d6:	f0ca                	sd	s2,96(sp)
 3d8:	ecce                	sd	s3,88(sp)
 3da:	e8d2                	sd	s4,80(sp)
 3dc:	e4d6                	sd	s5,72(sp)
 3de:	e0da                	sd	s6,64(sp)
 3e0:	fc5e                	sd	s7,56(sp)
 3e2:	f862                	sd	s8,48(sp)
 3e4:	f466                	sd	s9,40(sp)
 3e6:	f06a                	sd	s10,32(sp)
 3e8:	ec6e                	sd	s11,24(sp)
 3ea:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3ec:	0005c903          	lbu	s2,0(a1)
 3f0:	18090f63          	beqz	s2,58e <vprintf+0x1c0>
 3f4:	8aaa                	mv	s5,a0
 3f6:	8b32                	mv	s6,a2
 3f8:	00158493          	addi	s1,a1,1
  state = 0;
 3fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3fe:	02500a13          	li	s4,37
      if(c == 'd'){
 402:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 406:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 40a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 40e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 412:	00000b97          	auipc	s7,0x0
 416:	38eb8b93          	addi	s7,s7,910 # 7a0 <digits>
 41a:	a839                	j	438 <vprintf+0x6a>
        putc(fd, c);
 41c:	85ca                	mv	a1,s2
 41e:	8556                	mv	a0,s5
 420:	00000097          	auipc	ra,0x0
 424:	ee2080e7          	jalr	-286(ra) # 302 <putc>
 428:	a019                	j	42e <vprintf+0x60>
    } else if(state == '%'){
 42a:	01498f63          	beq	s3,s4,448 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 42e:	0485                	addi	s1,s1,1
 430:	fff4c903          	lbu	s2,-1(s1)
 434:	14090d63          	beqz	s2,58e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 438:	0009079b          	sext.w	a5,s2
    if(state == 0){
 43c:	fe0997e3          	bnez	s3,42a <vprintf+0x5c>
      if(c == '%'){
 440:	fd479ee3          	bne	a5,s4,41c <vprintf+0x4e>
        state = '%';
 444:	89be                	mv	s3,a5
 446:	b7e5                	j	42e <vprintf+0x60>
      if(c == 'd'){
 448:	05878063          	beq	a5,s8,488 <vprintf+0xba>
      } else if(c == 'l') {
 44c:	05978c63          	beq	a5,s9,4a4 <vprintf+0xd6>
      } else if(c == 'x') {
 450:	07a78863          	beq	a5,s10,4c0 <vprintf+0xf2>
      } else if(c == 'p') {
 454:	09b78463          	beq	a5,s11,4dc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 458:	07300713          	li	a4,115
 45c:	0ce78663          	beq	a5,a4,528 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 460:	06300713          	li	a4,99
 464:	0ee78e63          	beq	a5,a4,560 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 468:	11478863          	beq	a5,s4,578 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 46c:	85d2                	mv	a1,s4
 46e:	8556                	mv	a0,s5
 470:	00000097          	auipc	ra,0x0
 474:	e92080e7          	jalr	-366(ra) # 302 <putc>
        putc(fd, c);
 478:	85ca                	mv	a1,s2
 47a:	8556                	mv	a0,s5
 47c:	00000097          	auipc	ra,0x0
 480:	e86080e7          	jalr	-378(ra) # 302 <putc>
      }
      state = 0;
 484:	4981                	li	s3,0
 486:	b765                	j	42e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 488:	008b0913          	addi	s2,s6,8
 48c:	4685                	li	a3,1
 48e:	4629                	li	a2,10
 490:	000b2583          	lw	a1,0(s6)
 494:	8556                	mv	a0,s5
 496:	00000097          	auipc	ra,0x0
 49a:	e8e080e7          	jalr	-370(ra) # 324 <printint>
 49e:	8b4a                	mv	s6,s2
      state = 0;
 4a0:	4981                	li	s3,0
 4a2:	b771                	j	42e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4a4:	008b0913          	addi	s2,s6,8
 4a8:	4681                	li	a3,0
 4aa:	4629                	li	a2,10
 4ac:	000b2583          	lw	a1,0(s6)
 4b0:	8556                	mv	a0,s5
 4b2:	00000097          	auipc	ra,0x0
 4b6:	e72080e7          	jalr	-398(ra) # 324 <printint>
 4ba:	8b4a                	mv	s6,s2
      state = 0;
 4bc:	4981                	li	s3,0
 4be:	bf85                	j	42e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4c0:	008b0913          	addi	s2,s6,8
 4c4:	4681                	li	a3,0
 4c6:	4641                	li	a2,16
 4c8:	000b2583          	lw	a1,0(s6)
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	e56080e7          	jalr	-426(ra) # 324 <printint>
 4d6:	8b4a                	mv	s6,s2
      state = 0;
 4d8:	4981                	li	s3,0
 4da:	bf91                	j	42e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4dc:	008b0793          	addi	a5,s6,8
 4e0:	f8f43423          	sd	a5,-120(s0)
 4e4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4e8:	03000593          	li	a1,48
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	e14080e7          	jalr	-492(ra) # 302 <putc>
  putc(fd, 'x');
 4f6:	85ea                	mv	a1,s10
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	e08080e7          	jalr	-504(ra) # 302 <putc>
 502:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 504:	03c9d793          	srli	a5,s3,0x3c
 508:	97de                	add	a5,a5,s7
 50a:	0007c583          	lbu	a1,0(a5)
 50e:	8556                	mv	a0,s5
 510:	00000097          	auipc	ra,0x0
 514:	df2080e7          	jalr	-526(ra) # 302 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 518:	0992                	slli	s3,s3,0x4
 51a:	397d                	addiw	s2,s2,-1
 51c:	fe0914e3          	bnez	s2,504 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 520:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 524:	4981                	li	s3,0
 526:	b721                	j	42e <vprintf+0x60>
        s = va_arg(ap, char*);
 528:	008b0993          	addi	s3,s6,8
 52c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 530:	02090163          	beqz	s2,552 <vprintf+0x184>
        while(*s != 0){
 534:	00094583          	lbu	a1,0(s2)
 538:	c9a1                	beqz	a1,588 <vprintf+0x1ba>
          putc(fd, *s);
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	dc6080e7          	jalr	-570(ra) # 302 <putc>
          s++;
 544:	0905                	addi	s2,s2,1
        while(*s != 0){
 546:	00094583          	lbu	a1,0(s2)
 54a:	f9e5                	bnez	a1,53a <vprintf+0x16c>
        s = va_arg(ap, char*);
 54c:	8b4e                	mv	s6,s3
      state = 0;
 54e:	4981                	li	s3,0
 550:	bdf9                	j	42e <vprintf+0x60>
          s = "(null)";
 552:	00000917          	auipc	s2,0x0
 556:	24690913          	addi	s2,s2,582 # 798 <malloc+0x100>
        while(*s != 0){
 55a:	02800593          	li	a1,40
 55e:	bff1                	j	53a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 560:	008b0913          	addi	s2,s6,8
 564:	000b4583          	lbu	a1,0(s6)
 568:	8556                	mv	a0,s5
 56a:	00000097          	auipc	ra,0x0
 56e:	d98080e7          	jalr	-616(ra) # 302 <putc>
 572:	8b4a                	mv	s6,s2
      state = 0;
 574:	4981                	li	s3,0
 576:	bd65                	j	42e <vprintf+0x60>
        putc(fd, c);
 578:	85d2                	mv	a1,s4
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	d86080e7          	jalr	-634(ra) # 302 <putc>
      state = 0;
 584:	4981                	li	s3,0
 586:	b565                	j	42e <vprintf+0x60>
        s = va_arg(ap, char*);
 588:	8b4e                	mv	s6,s3
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b54d                	j	42e <vprintf+0x60>
    }
  }
}
 58e:	70e6                	ld	ra,120(sp)
 590:	7446                	ld	s0,112(sp)
 592:	74a6                	ld	s1,104(sp)
 594:	7906                	ld	s2,96(sp)
 596:	69e6                	ld	s3,88(sp)
 598:	6a46                	ld	s4,80(sp)
 59a:	6aa6                	ld	s5,72(sp)
 59c:	6b06                	ld	s6,64(sp)
 59e:	7be2                	ld	s7,56(sp)
 5a0:	7c42                	ld	s8,48(sp)
 5a2:	7ca2                	ld	s9,40(sp)
 5a4:	7d02                	ld	s10,32(sp)
 5a6:	6de2                	ld	s11,24(sp)
 5a8:	6109                	addi	sp,sp,128
 5aa:	8082                	ret

00000000000005ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5ac:	715d                	addi	sp,sp,-80
 5ae:	ec06                	sd	ra,24(sp)
 5b0:	e822                	sd	s0,16(sp)
 5b2:	1000                	addi	s0,sp,32
 5b4:	e010                	sd	a2,0(s0)
 5b6:	e414                	sd	a3,8(s0)
 5b8:	e818                	sd	a4,16(s0)
 5ba:	ec1c                	sd	a5,24(s0)
 5bc:	03043023          	sd	a6,32(s0)
 5c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5c4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5c8:	8622                	mv	a2,s0
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e04080e7          	jalr	-508(ra) # 3ce <vprintf>
}
 5d2:	60e2                	ld	ra,24(sp)
 5d4:	6442                	ld	s0,16(sp)
 5d6:	6161                	addi	sp,sp,80
 5d8:	8082                	ret

00000000000005da <printf>:

void
printf(const char *fmt, ...)
{
 5da:	711d                	addi	sp,sp,-96
 5dc:	ec06                	sd	ra,24(sp)
 5de:	e822                	sd	s0,16(sp)
 5e0:	1000                	addi	s0,sp,32
 5e2:	e40c                	sd	a1,8(s0)
 5e4:	e810                	sd	a2,16(s0)
 5e6:	ec14                	sd	a3,24(s0)
 5e8:	f018                	sd	a4,32(s0)
 5ea:	f41c                	sd	a5,40(s0)
 5ec:	03043823          	sd	a6,48(s0)
 5f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 5f4:	00840613          	addi	a2,s0,8
 5f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 5fc:	85aa                	mv	a1,a0
 5fe:	4505                	li	a0,1
 600:	00000097          	auipc	ra,0x0
 604:	dce080e7          	jalr	-562(ra) # 3ce <vprintf>
}
 608:	60e2                	ld	ra,24(sp)
 60a:	6442                	ld	s0,16(sp)
 60c:	6125                	addi	sp,sp,96
 60e:	8082                	ret

0000000000000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	1141                	addi	sp,sp,-16
 612:	e422                	sd	s0,8(sp)
 614:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 616:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	00000797          	auipc	a5,0x0
 61e:	19e7b783          	ld	a5,414(a5) # 7b8 <freep>
 622:	a805                	j	652 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 624:	4618                	lw	a4,8(a2)
 626:	9db9                	addw	a1,a1,a4
 628:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 62c:	6398                	ld	a4,0(a5)
 62e:	6318                	ld	a4,0(a4)
 630:	fee53823          	sd	a4,-16(a0)
 634:	a091                	j	678 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 636:	ff852703          	lw	a4,-8(a0)
 63a:	9e39                	addw	a2,a2,a4
 63c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 63e:	ff053703          	ld	a4,-16(a0)
 642:	e398                	sd	a4,0(a5)
 644:	a099                	j	68a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 646:	6398                	ld	a4,0(a5)
 648:	00e7e463          	bltu	a5,a4,650 <free+0x40>
 64c:	00e6ea63          	bltu	a3,a4,660 <free+0x50>
{
 650:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	fed7fae3          	bgeu	a5,a3,646 <free+0x36>
 656:	6398                	ld	a4,0(a5)
 658:	00e6e463          	bltu	a3,a4,660 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	fee7eae3          	bltu	a5,a4,650 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 660:	ff852583          	lw	a1,-8(a0)
 664:	6390                	ld	a2,0(a5)
 666:	02059713          	slli	a4,a1,0x20
 66a:	9301                	srli	a4,a4,0x20
 66c:	0712                	slli	a4,a4,0x4
 66e:	9736                	add	a4,a4,a3
 670:	fae60ae3          	beq	a2,a4,624 <free+0x14>
    bp->s.ptr = p->s.ptr;
 674:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 678:	4790                	lw	a2,8(a5)
 67a:	02061713          	slli	a4,a2,0x20
 67e:	9301                	srli	a4,a4,0x20
 680:	0712                	slli	a4,a4,0x4
 682:	973e                	add	a4,a4,a5
 684:	fae689e3          	beq	a3,a4,636 <free+0x26>
  } else
    p->s.ptr = bp;
 688:	e394                	sd	a3,0(a5)
  freep = p;
 68a:	00000717          	auipc	a4,0x0
 68e:	12f73723          	sd	a5,302(a4) # 7b8 <freep>
}
 692:	6422                	ld	s0,8(sp)
 694:	0141                	addi	sp,sp,16
 696:	8082                	ret

0000000000000698 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 698:	7139                	addi	sp,sp,-64
 69a:	fc06                	sd	ra,56(sp)
 69c:	f822                	sd	s0,48(sp)
 69e:	f426                	sd	s1,40(sp)
 6a0:	f04a                	sd	s2,32(sp)
 6a2:	ec4e                	sd	s3,24(sp)
 6a4:	e852                	sd	s4,16(sp)
 6a6:	e456                	sd	s5,8(sp)
 6a8:	e05a                	sd	s6,0(sp)
 6aa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ac:	02051493          	slli	s1,a0,0x20
 6b0:	9081                	srli	s1,s1,0x20
 6b2:	04bd                	addi	s1,s1,15
 6b4:	8091                	srli	s1,s1,0x4
 6b6:	0014899b          	addiw	s3,s1,1
 6ba:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6bc:	00000517          	auipc	a0,0x0
 6c0:	0fc53503          	ld	a0,252(a0) # 7b8 <freep>
 6c4:	c515                	beqz	a0,6f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6c8:	4798                	lw	a4,8(a5)
 6ca:	02977f63          	bgeu	a4,s1,708 <malloc+0x70>
 6ce:	8a4e                	mv	s4,s3
 6d0:	0009871b          	sext.w	a4,s3
 6d4:	6685                	lui	a3,0x1
 6d6:	00d77363          	bgeu	a4,a3,6dc <malloc+0x44>
 6da:	6a05                	lui	s4,0x1
 6dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e4:	00000917          	auipc	s2,0x0
 6e8:	0d490913          	addi	s2,s2,212 # 7b8 <freep>
  if(p == (char*)-1)
 6ec:	5afd                	li	s5,-1
 6ee:	a88d                	j	760 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 6f0:	00000797          	auipc	a5,0x0
 6f4:	0d078793          	addi	a5,a5,208 # 7c0 <base>
 6f8:	00000717          	auipc	a4,0x0
 6fc:	0cf73023          	sd	a5,192(a4) # 7b8 <freep>
 700:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 702:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 706:	b7e1                	j	6ce <malloc+0x36>
      if(p->s.size == nunits)
 708:	02e48b63          	beq	s1,a4,73e <malloc+0xa6>
        p->s.size -= nunits;
 70c:	4137073b          	subw	a4,a4,s3
 710:	c798                	sw	a4,8(a5)
        p += p->s.size;
 712:	1702                	slli	a4,a4,0x20
 714:	9301                	srli	a4,a4,0x20
 716:	0712                	slli	a4,a4,0x4
 718:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 71a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 71e:	00000717          	auipc	a4,0x0
 722:	08a73d23          	sd	a0,154(a4) # 7b8 <freep>
      return (void*)(p + 1);
 726:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 72a:	70e2                	ld	ra,56(sp)
 72c:	7442                	ld	s0,48(sp)
 72e:	74a2                	ld	s1,40(sp)
 730:	7902                	ld	s2,32(sp)
 732:	69e2                	ld	s3,24(sp)
 734:	6a42                	ld	s4,16(sp)
 736:	6aa2                	ld	s5,8(sp)
 738:	6b02                	ld	s6,0(sp)
 73a:	6121                	addi	sp,sp,64
 73c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 73e:	6398                	ld	a4,0(a5)
 740:	e118                	sd	a4,0(a0)
 742:	bff1                	j	71e <malloc+0x86>
  hp->s.size = nu;
 744:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 748:	0541                	addi	a0,a0,16
 74a:	00000097          	auipc	ra,0x0
 74e:	ec6080e7          	jalr	-314(ra) # 610 <free>
  return freep;
 752:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 756:	d971                	beqz	a0,72a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 758:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 75a:	4798                	lw	a4,8(a5)
 75c:	fa9776e3          	bgeu	a4,s1,708 <malloc+0x70>
    if(p == freep)
 760:	00093703          	ld	a4,0(s2)
 764:	853e                	mv	a0,a5
 766:	fef719e3          	bne	a4,a5,758 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 76a:	8552                	mv	a0,s4
 76c:	00000097          	auipc	ra,0x0
 770:	b76080e7          	jalr	-1162(ra) # 2e2 <sbrk>
  if(p == (char*)-1)
 774:	fd5518e3          	bne	a0,s5,744 <malloc+0xac>
        return 0;
 778:	4501                	li	a0,0
 77a:	bf45                	j	72a <malloc+0x92>
