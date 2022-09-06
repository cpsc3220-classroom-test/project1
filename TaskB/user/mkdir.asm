
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	2ac080e7          	jalr	684(ra) # 2d6 <mkdir>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00000597          	auipc	a1,0x0
  42:	75258593          	addi	a1,a1,1874 # 790 <malloc+0xe4>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	578080e7          	jalr	1400(ra) # 5c0 <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	21c080e7          	jalr	540(ra) # 26e <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00000597          	auipc	a1,0x0
  60:	74c58593          	addi	a1,a1,1868 # 7a8 <malloc+0xfc>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	55a080e7          	jalr	1370(ra) # 5c0 <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	1fe080e7          	jalr	510(ra) # 26e <exit>

0000000000000078 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	4685                	li	a3,1
  d2:	9e89                	subw	a3,a3,a0
  d4:	00f6853b          	addw	a0,a3,a5
  d8:	0785                	addi	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	fb7d                	bnez	a4,d4 <strlen+0x14>
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ce09                	beqz	a2,10a <memset+0x20>
  f2:	87aa                	mv	a5,a0
  f4:	fff6071b          	addiw	a4,a2,-1
  f8:	1702                	slli	a4,a4,0x20
  fa:	9301                	srli	a4,a4,0x20
  fc:	0705                	addi	a4,a4,1
  fe:	972a                	add	a4,a4,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 104:	0785                	addi	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x16>
  }
  return dst;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	addi	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	addi	s0,sp,16
  for(; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb99                	beqz	a5,130 <strchr+0x20>
    if(*s == c)
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1a>
  for(; *s; s++)
 120:	0505                	addi	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xc>
      return (char*)s;
  return 0;
 128:	4501                	li	a0,0
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strchr+0x1a>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	711d                	addi	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	1080                	addi	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 152:	4aa9                	li	s5,10
 154:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 156:	89a6                	mv	s3,s1
 158:	2485                	addiw	s1,s1,1
 15a:	0344d863          	bge	s1,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 15e:	4605                	li	a2,1
 160:	faf40593          	addi	a1,s0,-81
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	120080e7          	jalr	288(ra) # 286 <read>
    if(cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x56>
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	01578763          	beq	a5,s5,188 <gets+0x54>
 17e:	0905                	addi	s2,s2,1
 180:	fd679be3          	bne	a5,s6,156 <gets+0x22>
  for(i=0; i+1 < max; ){
 184:	89a6                	mv	s3,s1
 186:	a011                	j	18a <gets+0x56>
 188:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18a:	99de                	add	s3,s3,s7
 18c:	00098023          	sb	zero,0(s3)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6125                	addi	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	addi	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e426                	sd	s1,8(sp)
 1b0:	e04a                	sd	s2,0(sp)
 1b2:	1000                	addi	s0,sp,32
 1b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b6:	4581                	li	a1,0
 1b8:	00000097          	auipc	ra,0x0
 1bc:	0f6080e7          	jalr	246(ra) # 2ae <open>
  if(fd < 0)
 1c0:	02054563          	bltz	a0,1ea <stat+0x42>
 1c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	0fe080e7          	jalr	254(ra) # 2c6 <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	0c2080e7          	jalr	194(ra) # 296 <close>
  return r;
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	64a2                	ld	s1,8(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfc5                	j	1dc <stat+0x34>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054603          	lbu	a2,0(a0)
 1f8:	fd06079b          	addiw	a5,a2,-48
 1fc:	0ff7f793          	andi	a5,a5,255
 200:	4725                	li	a4,9
 202:	02f76963          	bltu	a4,a5,234 <atoi+0x46>
 206:	86aa                	mv	a3,a0
  n = 0;
 208:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 20a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 20c:	0685                	addi	a3,a3,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb1                	addw	a5,a5,a2
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	0006c603          	lbu	a2,0(a3)
 222:	fd06071b          	addiw	a4,a2,-48
 226:	0ff77713          	andi	a4,a4,255
 22a:	fee5f1e3          	bgeu	a1,a4,20c <atoi+0x1e>
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x40>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 23e:	02c05163          	blez	a2,260 <memmove+0x28>
 242:	fff6071b          	addiw	a4,a2,-1
 246:	1702                	slli	a4,a4,0x20
 248:	9301                	srli	a4,a4,0x20
 24a:	0705                	addi	a4,a4,1
 24c:	972a                	add	a4,a4,a0
  dst = vdst;
 24e:	87aa                	mv	a5,a0
    *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0785                	addi	a5,a5,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
  return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 266:	4885                	li	a7,1
 ecall
 268:	00000073          	ecall
 ret
 26c:	8082                	ret

000000000000026e <exit>:
.global exit
exit:
 li a7, SYS_exit
 26e:	4889                	li	a7,2
 ecall
 270:	00000073          	ecall
 ret
 274:	8082                	ret

0000000000000276 <wait>:
.global wait
wait:
 li a7, SYS_wait
 276:	488d                	li	a7,3
 ecall
 278:	00000073          	ecall
 ret
 27c:	8082                	ret

000000000000027e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 27e:	4891                	li	a7,4
 ecall
 280:	00000073          	ecall
 ret
 284:	8082                	ret

0000000000000286 <read>:
.global read
read:
 li a7, SYS_read
 286:	4895                	li	a7,5
 ecall
 288:	00000073          	ecall
 ret
 28c:	8082                	ret

000000000000028e <write>:
.global write
write:
 li a7, SYS_write
 28e:	48c1                	li	a7,16
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <close>:
.global close
close:
 li a7, SYS_close
 296:	48d5                	li	a7,21
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <kill>:
.global kill
kill:
 li a7, SYS_kill
 29e:	4899                	li	a7,6
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2a6:	489d                	li	a7,7
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <open>:
.global open
open:
 li a7, SYS_open
 2ae:	48bd                	li	a7,15
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2b6:	48c5                	li	a7,17
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2be:	48c9                	li	a7,18
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2c6:	48a1                	li	a7,8
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <link>:
.global link
link:
 li a7, SYS_link
 2ce:	48cd                	li	a7,19
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2d6:	48d1                	li	a7,20
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2de:	48a5                	li	a7,9
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 2e6:	48a9                	li	a7,10
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 2ee:	48ad                	li	a7,11
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 2f6:	48b1                	li	a7,12
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 2fe:	48b5                	li	a7,13
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 306:	48b9                	li	a7,14
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
 30e:	48d9                	li	a7,22
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 316:	1101                	addi	sp,sp,-32
 318:	ec06                	sd	ra,24(sp)
 31a:	e822                	sd	s0,16(sp)
 31c:	1000                	addi	s0,sp,32
 31e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 322:	4605                	li	a2,1
 324:	fef40593          	addi	a1,s0,-17
 328:	00000097          	auipc	ra,0x0
 32c:	f66080e7          	jalr	-154(ra) # 28e <write>
}
 330:	60e2                	ld	ra,24(sp)
 332:	6442                	ld	s0,16(sp)
 334:	6105                	addi	sp,sp,32
 336:	8082                	ret

0000000000000338 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 338:	7139                	addi	sp,sp,-64
 33a:	fc06                	sd	ra,56(sp)
 33c:	f822                	sd	s0,48(sp)
 33e:	f426                	sd	s1,40(sp)
 340:	f04a                	sd	s2,32(sp)
 342:	ec4e                	sd	s3,24(sp)
 344:	0080                	addi	s0,sp,64
 346:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 348:	c299                	beqz	a3,34e <printint+0x16>
 34a:	0805c863          	bltz	a1,3da <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 34e:	2581                	sext.w	a1,a1
  neg = 0;
 350:	4881                	li	a7,0
 352:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 356:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 358:	2601                	sext.w	a2,a2
 35a:	00000517          	auipc	a0,0x0
 35e:	47650513          	addi	a0,a0,1142 # 7d0 <digits>
 362:	883a                	mv	a6,a4
 364:	2705                	addiw	a4,a4,1
 366:	02c5f7bb          	remuw	a5,a1,a2
 36a:	1782                	slli	a5,a5,0x20
 36c:	9381                	srli	a5,a5,0x20
 36e:	97aa                	add	a5,a5,a0
 370:	0007c783          	lbu	a5,0(a5)
 374:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 378:	0005879b          	sext.w	a5,a1
 37c:	02c5d5bb          	divuw	a1,a1,a2
 380:	0685                	addi	a3,a3,1
 382:	fec7f0e3          	bgeu	a5,a2,362 <printint+0x2a>
  if(neg)
 386:	00088b63          	beqz	a7,39c <printint+0x64>
    buf[i++] = '-';
 38a:	fd040793          	addi	a5,s0,-48
 38e:	973e                	add	a4,a4,a5
 390:	02d00793          	li	a5,45
 394:	fef70823          	sb	a5,-16(a4)
 398:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 39c:	02e05863          	blez	a4,3cc <printint+0x94>
 3a0:	fc040793          	addi	a5,s0,-64
 3a4:	00e78933          	add	s2,a5,a4
 3a8:	fff78993          	addi	s3,a5,-1
 3ac:	99ba                	add	s3,s3,a4
 3ae:	377d                	addiw	a4,a4,-1
 3b0:	1702                	slli	a4,a4,0x20
 3b2:	9301                	srli	a4,a4,0x20
 3b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3b8:	fff94583          	lbu	a1,-1(s2)
 3bc:	8526                	mv	a0,s1
 3be:	00000097          	auipc	ra,0x0
 3c2:	f58080e7          	jalr	-168(ra) # 316 <putc>
  while(--i >= 0)
 3c6:	197d                	addi	s2,s2,-1
 3c8:	ff3918e3          	bne	s2,s3,3b8 <printint+0x80>
}
 3cc:	70e2                	ld	ra,56(sp)
 3ce:	7442                	ld	s0,48(sp)
 3d0:	74a2                	ld	s1,40(sp)
 3d2:	7902                	ld	s2,32(sp)
 3d4:	69e2                	ld	s3,24(sp)
 3d6:	6121                	addi	sp,sp,64
 3d8:	8082                	ret
    x = -xx;
 3da:	40b005bb          	negw	a1,a1
    neg = 1;
 3de:	4885                	li	a7,1
    x = -xx;
 3e0:	bf8d                	j	352 <printint+0x1a>

00000000000003e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3e2:	7119                	addi	sp,sp,-128
 3e4:	fc86                	sd	ra,120(sp)
 3e6:	f8a2                	sd	s0,112(sp)
 3e8:	f4a6                	sd	s1,104(sp)
 3ea:	f0ca                	sd	s2,96(sp)
 3ec:	ecce                	sd	s3,88(sp)
 3ee:	e8d2                	sd	s4,80(sp)
 3f0:	e4d6                	sd	s5,72(sp)
 3f2:	e0da                	sd	s6,64(sp)
 3f4:	fc5e                	sd	s7,56(sp)
 3f6:	f862                	sd	s8,48(sp)
 3f8:	f466                	sd	s9,40(sp)
 3fa:	f06a                	sd	s10,32(sp)
 3fc:	ec6e                	sd	s11,24(sp)
 3fe:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 400:	0005c903          	lbu	s2,0(a1)
 404:	18090f63          	beqz	s2,5a2 <vprintf+0x1c0>
 408:	8aaa                	mv	s5,a0
 40a:	8b32                	mv	s6,a2
 40c:	00158493          	addi	s1,a1,1
  state = 0;
 410:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 412:	02500a13          	li	s4,37
      if(c == 'd'){
 416:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 41a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 41e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 422:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 426:	00000b97          	auipc	s7,0x0
 42a:	3aab8b93          	addi	s7,s7,938 # 7d0 <digits>
 42e:	a839                	j	44c <vprintf+0x6a>
        putc(fd, c);
 430:	85ca                	mv	a1,s2
 432:	8556                	mv	a0,s5
 434:	00000097          	auipc	ra,0x0
 438:	ee2080e7          	jalr	-286(ra) # 316 <putc>
 43c:	a019                	j	442 <vprintf+0x60>
    } else if(state == '%'){
 43e:	01498f63          	beq	s3,s4,45c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 442:	0485                	addi	s1,s1,1
 444:	fff4c903          	lbu	s2,-1(s1)
 448:	14090d63          	beqz	s2,5a2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 44c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 450:	fe0997e3          	bnez	s3,43e <vprintf+0x5c>
      if(c == '%'){
 454:	fd479ee3          	bne	a5,s4,430 <vprintf+0x4e>
        state = '%';
 458:	89be                	mv	s3,a5
 45a:	b7e5                	j	442 <vprintf+0x60>
      if(c == 'd'){
 45c:	05878063          	beq	a5,s8,49c <vprintf+0xba>
      } else if(c == 'l') {
 460:	05978c63          	beq	a5,s9,4b8 <vprintf+0xd6>
      } else if(c == 'x') {
 464:	07a78863          	beq	a5,s10,4d4 <vprintf+0xf2>
      } else if(c == 'p') {
 468:	09b78463          	beq	a5,s11,4f0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 46c:	07300713          	li	a4,115
 470:	0ce78663          	beq	a5,a4,53c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 474:	06300713          	li	a4,99
 478:	0ee78e63          	beq	a5,a4,574 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 47c:	11478863          	beq	a5,s4,58c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 480:	85d2                	mv	a1,s4
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	e92080e7          	jalr	-366(ra) # 316 <putc>
        putc(fd, c);
 48c:	85ca                	mv	a1,s2
 48e:	8556                	mv	a0,s5
 490:	00000097          	auipc	ra,0x0
 494:	e86080e7          	jalr	-378(ra) # 316 <putc>
      }
      state = 0;
 498:	4981                	li	s3,0
 49a:	b765                	j	442 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 49c:	008b0913          	addi	s2,s6,8
 4a0:	4685                	li	a3,1
 4a2:	4629                	li	a2,10
 4a4:	000b2583          	lw	a1,0(s6)
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	e8e080e7          	jalr	-370(ra) # 338 <printint>
 4b2:	8b4a                	mv	s6,s2
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	b771                	j	442 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4b8:	008b0913          	addi	s2,s6,8
 4bc:	4681                	li	a3,0
 4be:	4629                	li	a2,10
 4c0:	000b2583          	lw	a1,0(s6)
 4c4:	8556                	mv	a0,s5
 4c6:	00000097          	auipc	ra,0x0
 4ca:	e72080e7          	jalr	-398(ra) # 338 <printint>
 4ce:	8b4a                	mv	s6,s2
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	bf85                	j	442 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 4d4:	008b0913          	addi	s2,s6,8
 4d8:	4681                	li	a3,0
 4da:	4641                	li	a2,16
 4dc:	000b2583          	lw	a1,0(s6)
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	e56080e7          	jalr	-426(ra) # 338 <printint>
 4ea:	8b4a                	mv	s6,s2
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	bf91                	j	442 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 4f0:	008b0793          	addi	a5,s6,8
 4f4:	f8f43423          	sd	a5,-120(s0)
 4f8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 4fc:	03000593          	li	a1,48
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	e14080e7          	jalr	-492(ra) # 316 <putc>
  putc(fd, 'x');
 50a:	85ea                	mv	a1,s10
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	e08080e7          	jalr	-504(ra) # 316 <putc>
 516:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 518:	03c9d793          	srli	a5,s3,0x3c
 51c:	97de                	add	a5,a5,s7
 51e:	0007c583          	lbu	a1,0(a5)
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	df2080e7          	jalr	-526(ra) # 316 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 52c:	0992                	slli	s3,s3,0x4
 52e:	397d                	addiw	s2,s2,-1
 530:	fe0914e3          	bnez	s2,518 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 534:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 538:	4981                	li	s3,0
 53a:	b721                	j	442 <vprintf+0x60>
        s = va_arg(ap, char*);
 53c:	008b0993          	addi	s3,s6,8
 540:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 544:	02090163          	beqz	s2,566 <vprintf+0x184>
        while(*s != 0){
 548:	00094583          	lbu	a1,0(s2)
 54c:	c9a1                	beqz	a1,59c <vprintf+0x1ba>
          putc(fd, *s);
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	dc6080e7          	jalr	-570(ra) # 316 <putc>
          s++;
 558:	0905                	addi	s2,s2,1
        while(*s != 0){
 55a:	00094583          	lbu	a1,0(s2)
 55e:	f9e5                	bnez	a1,54e <vprintf+0x16c>
        s = va_arg(ap, char*);
 560:	8b4e                	mv	s6,s3
      state = 0;
 562:	4981                	li	s3,0
 564:	bdf9                	j	442 <vprintf+0x60>
          s = "(null)";
 566:	00000917          	auipc	s2,0x0
 56a:	26290913          	addi	s2,s2,610 # 7c8 <malloc+0x11c>
        while(*s != 0){
 56e:	02800593          	li	a1,40
 572:	bff1                	j	54e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 574:	008b0913          	addi	s2,s6,8
 578:	000b4583          	lbu	a1,0(s6)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	d98080e7          	jalr	-616(ra) # 316 <putc>
 586:	8b4a                	mv	s6,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	bd65                	j	442 <vprintf+0x60>
        putc(fd, c);
 58c:	85d2                	mv	a1,s4
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	d86080e7          	jalr	-634(ra) # 316 <putc>
      state = 0;
 598:	4981                	li	s3,0
 59a:	b565                	j	442 <vprintf+0x60>
        s = va_arg(ap, char*);
 59c:	8b4e                	mv	s6,s3
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b54d                	j	442 <vprintf+0x60>
    }
  }
}
 5a2:	70e6                	ld	ra,120(sp)
 5a4:	7446                	ld	s0,112(sp)
 5a6:	74a6                	ld	s1,104(sp)
 5a8:	7906                	ld	s2,96(sp)
 5aa:	69e6                	ld	s3,88(sp)
 5ac:	6a46                	ld	s4,80(sp)
 5ae:	6aa6                	ld	s5,72(sp)
 5b0:	6b06                	ld	s6,64(sp)
 5b2:	7be2                	ld	s7,56(sp)
 5b4:	7c42                	ld	s8,48(sp)
 5b6:	7ca2                	ld	s9,40(sp)
 5b8:	7d02                	ld	s10,32(sp)
 5ba:	6de2                	ld	s11,24(sp)
 5bc:	6109                	addi	sp,sp,128
 5be:	8082                	ret

00000000000005c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5c0:	715d                	addi	sp,sp,-80
 5c2:	ec06                	sd	ra,24(sp)
 5c4:	e822                	sd	s0,16(sp)
 5c6:	1000                	addi	s0,sp,32
 5c8:	e010                	sd	a2,0(s0)
 5ca:	e414                	sd	a3,8(s0)
 5cc:	e818                	sd	a4,16(s0)
 5ce:	ec1c                	sd	a5,24(s0)
 5d0:	03043023          	sd	a6,32(s0)
 5d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5dc:	8622                	mv	a2,s0
 5de:	00000097          	auipc	ra,0x0
 5e2:	e04080e7          	jalr	-508(ra) # 3e2 <vprintf>
}
 5e6:	60e2                	ld	ra,24(sp)
 5e8:	6442                	ld	s0,16(sp)
 5ea:	6161                	addi	sp,sp,80
 5ec:	8082                	ret

00000000000005ee <printf>:

void
printf(const char *fmt, ...)
{
 5ee:	711d                	addi	sp,sp,-96
 5f0:	ec06                	sd	ra,24(sp)
 5f2:	e822                	sd	s0,16(sp)
 5f4:	1000                	addi	s0,sp,32
 5f6:	e40c                	sd	a1,8(s0)
 5f8:	e810                	sd	a2,16(s0)
 5fa:	ec14                	sd	a3,24(s0)
 5fc:	f018                	sd	a4,32(s0)
 5fe:	f41c                	sd	a5,40(s0)
 600:	03043823          	sd	a6,48(s0)
 604:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 608:	00840613          	addi	a2,s0,8
 60c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 610:	85aa                	mv	a1,a0
 612:	4505                	li	a0,1
 614:	00000097          	auipc	ra,0x0
 618:	dce080e7          	jalr	-562(ra) # 3e2 <vprintf>
}
 61c:	60e2                	ld	ra,24(sp)
 61e:	6442                	ld	s0,16(sp)
 620:	6125                	addi	sp,sp,96
 622:	8082                	ret

0000000000000624 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 624:	1141                	addi	sp,sp,-16
 626:	e422                	sd	s0,8(sp)
 628:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62e:	00000797          	auipc	a5,0x0
 632:	1ba7b783          	ld	a5,442(a5) # 7e8 <freep>
 636:	a805                	j	666 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 638:	4618                	lw	a4,8(a2)
 63a:	9db9                	addw	a1,a1,a4
 63c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 640:	6398                	ld	a4,0(a5)
 642:	6318                	ld	a4,0(a4)
 644:	fee53823          	sd	a4,-16(a0)
 648:	a091                	j	68c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 64a:	ff852703          	lw	a4,-8(a0)
 64e:	9e39                	addw	a2,a2,a4
 650:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 652:	ff053703          	ld	a4,-16(a0)
 656:	e398                	sd	a4,0(a5)
 658:	a099                	j	69e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65a:	6398                	ld	a4,0(a5)
 65c:	00e7e463          	bltu	a5,a4,664 <free+0x40>
 660:	00e6ea63          	bltu	a3,a4,674 <free+0x50>
{
 664:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 666:	fed7fae3          	bgeu	a5,a3,65a <free+0x36>
 66a:	6398                	ld	a4,0(a5)
 66c:	00e6e463          	bltu	a3,a4,674 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	fee7eae3          	bltu	a5,a4,664 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 674:	ff852583          	lw	a1,-8(a0)
 678:	6390                	ld	a2,0(a5)
 67a:	02059713          	slli	a4,a1,0x20
 67e:	9301                	srli	a4,a4,0x20
 680:	0712                	slli	a4,a4,0x4
 682:	9736                	add	a4,a4,a3
 684:	fae60ae3          	beq	a2,a4,638 <free+0x14>
    bp->s.ptr = p->s.ptr;
 688:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 68c:	4790                	lw	a2,8(a5)
 68e:	02061713          	slli	a4,a2,0x20
 692:	9301                	srli	a4,a4,0x20
 694:	0712                	slli	a4,a4,0x4
 696:	973e                	add	a4,a4,a5
 698:	fae689e3          	beq	a3,a4,64a <free+0x26>
  } else
    p->s.ptr = bp;
 69c:	e394                	sd	a3,0(a5)
  freep = p;
 69e:	00000717          	auipc	a4,0x0
 6a2:	14f73523          	sd	a5,330(a4) # 7e8 <freep>
}
 6a6:	6422                	ld	s0,8(sp)
 6a8:	0141                	addi	sp,sp,16
 6aa:	8082                	ret

00000000000006ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ac:	7139                	addi	sp,sp,-64
 6ae:	fc06                	sd	ra,56(sp)
 6b0:	f822                	sd	s0,48(sp)
 6b2:	f426                	sd	s1,40(sp)
 6b4:	f04a                	sd	s2,32(sp)
 6b6:	ec4e                	sd	s3,24(sp)
 6b8:	e852                	sd	s4,16(sp)
 6ba:	e456                	sd	s5,8(sp)
 6bc:	e05a                	sd	s6,0(sp)
 6be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c0:	02051493          	slli	s1,a0,0x20
 6c4:	9081                	srli	s1,s1,0x20
 6c6:	04bd                	addi	s1,s1,15
 6c8:	8091                	srli	s1,s1,0x4
 6ca:	0014899b          	addiw	s3,s1,1
 6ce:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6d0:	00000517          	auipc	a0,0x0
 6d4:	11853503          	ld	a0,280(a0) # 7e8 <freep>
 6d8:	c515                	beqz	a0,704 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6dc:	4798                	lw	a4,8(a5)
 6de:	02977f63          	bgeu	a4,s1,71c <malloc+0x70>
 6e2:	8a4e                	mv	s4,s3
 6e4:	0009871b          	sext.w	a4,s3
 6e8:	6685                	lui	a3,0x1
 6ea:	00d77363          	bgeu	a4,a3,6f0 <malloc+0x44>
 6ee:	6a05                	lui	s4,0x1
 6f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6f8:	00000917          	auipc	s2,0x0
 6fc:	0f090913          	addi	s2,s2,240 # 7e8 <freep>
  if(p == (char*)-1)
 700:	5afd                	li	s5,-1
 702:	a88d                	j	774 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 704:	00000797          	auipc	a5,0x0
 708:	0ec78793          	addi	a5,a5,236 # 7f0 <base>
 70c:	00000717          	auipc	a4,0x0
 710:	0cf73e23          	sd	a5,220(a4) # 7e8 <freep>
 714:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 716:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 71a:	b7e1                	j	6e2 <malloc+0x36>
      if(p->s.size == nunits)
 71c:	02e48b63          	beq	s1,a4,752 <malloc+0xa6>
        p->s.size -= nunits;
 720:	4137073b          	subw	a4,a4,s3
 724:	c798                	sw	a4,8(a5)
        p += p->s.size;
 726:	1702                	slli	a4,a4,0x20
 728:	9301                	srli	a4,a4,0x20
 72a:	0712                	slli	a4,a4,0x4
 72c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 72e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 732:	00000717          	auipc	a4,0x0
 736:	0aa73b23          	sd	a0,182(a4) # 7e8 <freep>
      return (void*)(p + 1);
 73a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 73e:	70e2                	ld	ra,56(sp)
 740:	7442                	ld	s0,48(sp)
 742:	74a2                	ld	s1,40(sp)
 744:	7902                	ld	s2,32(sp)
 746:	69e2                	ld	s3,24(sp)
 748:	6a42                	ld	s4,16(sp)
 74a:	6aa2                	ld	s5,8(sp)
 74c:	6b02                	ld	s6,0(sp)
 74e:	6121                	addi	sp,sp,64
 750:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 752:	6398                	ld	a4,0(a5)
 754:	e118                	sd	a4,0(a0)
 756:	bff1                	j	732 <malloc+0x86>
  hp->s.size = nu;
 758:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 75c:	0541                	addi	a0,a0,16
 75e:	00000097          	auipc	ra,0x0
 762:	ec6080e7          	jalr	-314(ra) # 624 <free>
  return freep;
 766:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 76a:	d971                	beqz	a0,73e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76e:	4798                	lw	a4,8(a5)
 770:	fa9776e3          	bgeu	a4,s1,71c <malloc+0x70>
    if(p == freep)
 774:	00093703          	ld	a4,0(s2)
 778:	853e                	mv	a0,a5
 77a:	fef719e3          	bne	a4,a5,76c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 77e:	8552                	mv	a0,s4
 780:	00000097          	auipc	ra,0x0
 784:	b76080e7          	jalr	-1162(ra) # 2f6 <sbrk>
  if(p == (char*)-1)
 788:	fd5518e3          	bne	a0,s5,758 <malloc+0xac>
        return 0;
 78c:	4501                	li	a0,0
 78e:	bf45                	j	73e <malloc+0x92>
