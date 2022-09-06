
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
       0:	00007797          	auipc	a5,0x7
       4:	a9878793          	addi	a5,a5,-1384 # 6a98 <uninit>
       8:	00009697          	auipc	a3,0x9
       c:	1a068693          	addi	a3,a3,416 # 91a8 <buf>
    if(uninit[i] != '\0'){
      10:	0007c703          	lbu	a4,0(a5)
      14:	e709                	bnez	a4,1e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      16:	0785                	addi	a5,a5,1
      18:	fed79ce3          	bne	a5,a3,10 <bsstest+0x10>
      1c:	8082                	ret
{
      1e:	1141                	addi	sp,sp,-16
      20:	e406                	sd	ra,8(sp)
      22:	e022                	sd	s0,0(sp)
      24:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      26:	85aa                	mv	a1,a0
      28:	00005517          	auipc	a0,0x5
      2c:	b3050513          	addi	a0,a0,-1232 # 4b58 <malloc+0x370>
      30:	00004097          	auipc	ra,0x4
      34:	6fa080e7          	jalr	1786(ra) # 472a <printf>
      exit(1);
      38:	4505                	li	a0,1
      3a:	00004097          	auipc	ra,0x4
      3e:	370080e7          	jalr	880(ra) # 43aa <exit>

0000000000000042 <iputtest>:
{
      42:	1101                	addi	sp,sp,-32
      44:	ec06                	sd	ra,24(sp)
      46:	e822                	sd	s0,16(sp)
      48:	e426                	sd	s1,8(sp)
      4a:	1000                	addi	s0,sp,32
      4c:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
      4e:	00005517          	auipc	a0,0x5
      52:	b2250513          	addi	a0,a0,-1246 # 4b70 <malloc+0x388>
      56:	00004097          	auipc	ra,0x4
      5a:	3bc080e7          	jalr	956(ra) # 4412 <mkdir>
      5e:	04054563          	bltz	a0,a8 <iputtest+0x66>
  if(chdir("iputdir") < 0){
      62:	00005517          	auipc	a0,0x5
      66:	b0e50513          	addi	a0,a0,-1266 # 4b70 <malloc+0x388>
      6a:	00004097          	auipc	ra,0x4
      6e:	3b0080e7          	jalr	944(ra) # 441a <chdir>
      72:	04054963          	bltz	a0,c4 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
      76:	00005517          	auipc	a0,0x5
      7a:	b3a50513          	addi	a0,a0,-1222 # 4bb0 <malloc+0x3c8>
      7e:	00004097          	auipc	ra,0x4
      82:	37c080e7          	jalr	892(ra) # 43fa <unlink>
      86:	04054d63          	bltz	a0,e0 <iputtest+0x9e>
  if(chdir("/") < 0){
      8a:	00005517          	auipc	a0,0x5
      8e:	b5650513          	addi	a0,a0,-1194 # 4be0 <malloc+0x3f8>
      92:	00004097          	auipc	ra,0x4
      96:	388080e7          	jalr	904(ra) # 441a <chdir>
      9a:	06054163          	bltz	a0,fc <iputtest+0xba>
}
      9e:	60e2                	ld	ra,24(sp)
      a0:	6442                	ld	s0,16(sp)
      a2:	64a2                	ld	s1,8(sp)
      a4:	6105                	addi	sp,sp,32
      a6:	8082                	ret
    printf("%s: mkdir failed\n", s);
      a8:	85a6                	mv	a1,s1
      aa:	00005517          	auipc	a0,0x5
      ae:	ace50513          	addi	a0,a0,-1330 # 4b78 <malloc+0x390>
      b2:	00004097          	auipc	ra,0x4
      b6:	678080e7          	jalr	1656(ra) # 472a <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	00004097          	auipc	ra,0x4
      c0:	2ee080e7          	jalr	750(ra) # 43aa <exit>
    printf("%s: chdir iputdir failed\n", s);
      c4:	85a6                	mv	a1,s1
      c6:	00005517          	auipc	a0,0x5
      ca:	aca50513          	addi	a0,a0,-1334 # 4b90 <malloc+0x3a8>
      ce:	00004097          	auipc	ra,0x4
      d2:	65c080e7          	jalr	1628(ra) # 472a <printf>
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00004097          	auipc	ra,0x4
      dc:	2d2080e7          	jalr	722(ra) # 43aa <exit>
    printf("%s: unlink ../iputdir failed\n", s);
      e0:	85a6                	mv	a1,s1
      e2:	00005517          	auipc	a0,0x5
      e6:	ade50513          	addi	a0,a0,-1314 # 4bc0 <malloc+0x3d8>
      ea:	00004097          	auipc	ra,0x4
      ee:	640080e7          	jalr	1600(ra) # 472a <printf>
    exit(1);
      f2:	4505                	li	a0,1
      f4:	00004097          	auipc	ra,0x4
      f8:	2b6080e7          	jalr	694(ra) # 43aa <exit>
    printf("%s: chdir / failed\n", s);
      fc:	85a6                	mv	a1,s1
      fe:	00005517          	auipc	a0,0x5
     102:	aea50513          	addi	a0,a0,-1302 # 4be8 <malloc+0x400>
     106:	00004097          	auipc	ra,0x4
     10a:	624080e7          	jalr	1572(ra) # 472a <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00004097          	auipc	ra,0x4
     114:	29a080e7          	jalr	666(ra) # 43aa <exit>

0000000000000118 <rmdot>:
{
     118:	1101                	addi	sp,sp,-32
     11a:	ec06                	sd	ra,24(sp)
     11c:	e822                	sd	s0,16(sp)
     11e:	e426                	sd	s1,8(sp)
     120:	1000                	addi	s0,sp,32
     122:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
     124:	00005517          	auipc	a0,0x5
     128:	adc50513          	addi	a0,a0,-1316 # 4c00 <malloc+0x418>
     12c:	00004097          	auipc	ra,0x4
     130:	2e6080e7          	jalr	742(ra) # 4412 <mkdir>
     134:	e549                	bnez	a0,1be <rmdot+0xa6>
  if(chdir("dots") != 0){
     136:	00005517          	auipc	a0,0x5
     13a:	aca50513          	addi	a0,a0,-1334 # 4c00 <malloc+0x418>
     13e:	00004097          	auipc	ra,0x4
     142:	2dc080e7          	jalr	732(ra) # 441a <chdir>
     146:	e951                	bnez	a0,1da <rmdot+0xc2>
  if(unlink(".") == 0){
     148:	00005517          	auipc	a0,0x5
     14c:	af050513          	addi	a0,a0,-1296 # 4c38 <malloc+0x450>
     150:	00004097          	auipc	ra,0x4
     154:	2aa080e7          	jalr	682(ra) # 43fa <unlink>
     158:	cd59                	beqz	a0,1f6 <rmdot+0xde>
  if(unlink("..") == 0){
     15a:	00005517          	auipc	a0,0x5
     15e:	afe50513          	addi	a0,a0,-1282 # 4c58 <malloc+0x470>
     162:	00004097          	auipc	ra,0x4
     166:	298080e7          	jalr	664(ra) # 43fa <unlink>
     16a:	c545                	beqz	a0,212 <rmdot+0xfa>
  if(chdir("/") != 0){
     16c:	00005517          	auipc	a0,0x5
     170:	a7450513          	addi	a0,a0,-1420 # 4be0 <malloc+0x3f8>
     174:	00004097          	auipc	ra,0x4
     178:	2a6080e7          	jalr	678(ra) # 441a <chdir>
     17c:	e94d                	bnez	a0,22e <rmdot+0x116>
  if(unlink("dots/.") == 0){
     17e:	00005517          	auipc	a0,0x5
     182:	afa50513          	addi	a0,a0,-1286 # 4c78 <malloc+0x490>
     186:	00004097          	auipc	ra,0x4
     18a:	274080e7          	jalr	628(ra) # 43fa <unlink>
     18e:	cd55                	beqz	a0,24a <rmdot+0x132>
  if(unlink("dots/..") == 0){
     190:	00005517          	auipc	a0,0x5
     194:	b1050513          	addi	a0,a0,-1264 # 4ca0 <malloc+0x4b8>
     198:	00004097          	auipc	ra,0x4
     19c:	262080e7          	jalr	610(ra) # 43fa <unlink>
     1a0:	c179                	beqz	a0,266 <rmdot+0x14e>
  if(unlink("dots") != 0){
     1a2:	00005517          	auipc	a0,0x5
     1a6:	a5e50513          	addi	a0,a0,-1442 # 4c00 <malloc+0x418>
     1aa:	00004097          	auipc	ra,0x4
     1ae:	250080e7          	jalr	592(ra) # 43fa <unlink>
     1b2:	e961                	bnez	a0,282 <rmdot+0x16a>
}
     1b4:	60e2                	ld	ra,24(sp)
     1b6:	6442                	ld	s0,16(sp)
     1b8:	64a2                	ld	s1,8(sp)
     1ba:	6105                	addi	sp,sp,32
     1bc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
     1be:	85a6                	mv	a1,s1
     1c0:	00005517          	auipc	a0,0x5
     1c4:	a4850513          	addi	a0,a0,-1464 # 4c08 <malloc+0x420>
     1c8:	00004097          	auipc	ra,0x4
     1cc:	562080e7          	jalr	1378(ra) # 472a <printf>
    exit(1);
     1d0:	4505                	li	a0,1
     1d2:	00004097          	auipc	ra,0x4
     1d6:	1d8080e7          	jalr	472(ra) # 43aa <exit>
    printf("%s: chdir dots failed\n", s);
     1da:	85a6                	mv	a1,s1
     1dc:	00005517          	auipc	a0,0x5
     1e0:	a4450513          	addi	a0,a0,-1468 # 4c20 <malloc+0x438>
     1e4:	00004097          	auipc	ra,0x4
     1e8:	546080e7          	jalr	1350(ra) # 472a <printf>
    exit(1);
     1ec:	4505                	li	a0,1
     1ee:	00004097          	auipc	ra,0x4
     1f2:	1bc080e7          	jalr	444(ra) # 43aa <exit>
    printf("%s: rm . worked!\n", s);
     1f6:	85a6                	mv	a1,s1
     1f8:	00005517          	auipc	a0,0x5
     1fc:	a4850513          	addi	a0,a0,-1464 # 4c40 <malloc+0x458>
     200:	00004097          	auipc	ra,0x4
     204:	52a080e7          	jalr	1322(ra) # 472a <printf>
    exit(1);
     208:	4505                	li	a0,1
     20a:	00004097          	auipc	ra,0x4
     20e:	1a0080e7          	jalr	416(ra) # 43aa <exit>
    printf("%s: rm .. worked!\n", s);
     212:	85a6                	mv	a1,s1
     214:	00005517          	auipc	a0,0x5
     218:	a4c50513          	addi	a0,a0,-1460 # 4c60 <malloc+0x478>
     21c:	00004097          	auipc	ra,0x4
     220:	50e080e7          	jalr	1294(ra) # 472a <printf>
    exit(1);
     224:	4505                	li	a0,1
     226:	00004097          	auipc	ra,0x4
     22a:	184080e7          	jalr	388(ra) # 43aa <exit>
    printf("%s: chdir / failed\n", s);
     22e:	85a6                	mv	a1,s1
     230:	00005517          	auipc	a0,0x5
     234:	9b850513          	addi	a0,a0,-1608 # 4be8 <malloc+0x400>
     238:	00004097          	auipc	ra,0x4
     23c:	4f2080e7          	jalr	1266(ra) # 472a <printf>
    exit(1);
     240:	4505                	li	a0,1
     242:	00004097          	auipc	ra,0x4
     246:	168080e7          	jalr	360(ra) # 43aa <exit>
    printf("%s: unlink dots/. worked!\n", s);
     24a:	85a6                	mv	a1,s1
     24c:	00005517          	auipc	a0,0x5
     250:	a3450513          	addi	a0,a0,-1484 # 4c80 <malloc+0x498>
     254:	00004097          	auipc	ra,0x4
     258:	4d6080e7          	jalr	1238(ra) # 472a <printf>
    exit(1);
     25c:	4505                	li	a0,1
     25e:	00004097          	auipc	ra,0x4
     262:	14c080e7          	jalr	332(ra) # 43aa <exit>
    printf("%s: unlink dots/.. worked!\n", s);
     266:	85a6                	mv	a1,s1
     268:	00005517          	auipc	a0,0x5
     26c:	a4050513          	addi	a0,a0,-1472 # 4ca8 <malloc+0x4c0>
     270:	00004097          	auipc	ra,0x4
     274:	4ba080e7          	jalr	1210(ra) # 472a <printf>
    exit(1);
     278:	4505                	li	a0,1
     27a:	00004097          	auipc	ra,0x4
     27e:	130080e7          	jalr	304(ra) # 43aa <exit>
    printf("%s: unlink dots failed!\n", s);
     282:	85a6                	mv	a1,s1
     284:	00005517          	auipc	a0,0x5
     288:	a4450513          	addi	a0,a0,-1468 # 4cc8 <malloc+0x4e0>
     28c:	00004097          	auipc	ra,0x4
     290:	49e080e7          	jalr	1182(ra) # 472a <printf>
    exit(1);
     294:	4505                	li	a0,1
     296:	00004097          	auipc	ra,0x4
     29a:	114080e7          	jalr	276(ra) # 43aa <exit>

000000000000029e <exitiputtest>:
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	1800                	addi	s0,sp,48
     2a8:	84aa                	mv	s1,a0
  pid = fork();
     2aa:	00004097          	auipc	ra,0x4
     2ae:	0f8080e7          	jalr	248(ra) # 43a2 <fork>
  if(pid < 0){
     2b2:	04054663          	bltz	a0,2fe <exitiputtest+0x60>
  if(pid == 0){
     2b6:	ed45                	bnez	a0,36e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     2b8:	00005517          	auipc	a0,0x5
     2bc:	8b850513          	addi	a0,a0,-1864 # 4b70 <malloc+0x388>
     2c0:	00004097          	auipc	ra,0x4
     2c4:	152080e7          	jalr	338(ra) # 4412 <mkdir>
     2c8:	04054963          	bltz	a0,31a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
     2cc:	00005517          	auipc	a0,0x5
     2d0:	8a450513          	addi	a0,a0,-1884 # 4b70 <malloc+0x388>
     2d4:	00004097          	auipc	ra,0x4
     2d8:	146080e7          	jalr	326(ra) # 441a <chdir>
     2dc:	04054d63          	bltz	a0,336 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
     2e0:	00005517          	auipc	a0,0x5
     2e4:	8d050513          	addi	a0,a0,-1840 # 4bb0 <malloc+0x3c8>
     2e8:	00004097          	auipc	ra,0x4
     2ec:	112080e7          	jalr	274(ra) # 43fa <unlink>
     2f0:	06054163          	bltz	a0,352 <exitiputtest+0xb4>
    exit(0);
     2f4:	4501                	li	a0,0
     2f6:	00004097          	auipc	ra,0x4
     2fa:	0b4080e7          	jalr	180(ra) # 43aa <exit>
    printf("%s: fork failed\n", s);
     2fe:	85a6                	mv	a1,s1
     300:	00005517          	auipc	a0,0x5
     304:	9e850513          	addi	a0,a0,-1560 # 4ce8 <malloc+0x500>
     308:	00004097          	auipc	ra,0x4
     30c:	422080e7          	jalr	1058(ra) # 472a <printf>
    exit(1);
     310:	4505                	li	a0,1
     312:	00004097          	auipc	ra,0x4
     316:	098080e7          	jalr	152(ra) # 43aa <exit>
      printf("%s: mkdir failed\n", s);
     31a:	85a6                	mv	a1,s1
     31c:	00005517          	auipc	a0,0x5
     320:	85c50513          	addi	a0,a0,-1956 # 4b78 <malloc+0x390>
     324:	00004097          	auipc	ra,0x4
     328:	406080e7          	jalr	1030(ra) # 472a <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00004097          	auipc	ra,0x4
     332:	07c080e7          	jalr	124(ra) # 43aa <exit>
      printf("%s: child chdir failed\n", s);
     336:	85a6                	mv	a1,s1
     338:	00005517          	auipc	a0,0x5
     33c:	9c850513          	addi	a0,a0,-1592 # 4d00 <malloc+0x518>
     340:	00004097          	auipc	ra,0x4
     344:	3ea080e7          	jalr	1002(ra) # 472a <printf>
      exit(1);
     348:	4505                	li	a0,1
     34a:	00004097          	auipc	ra,0x4
     34e:	060080e7          	jalr	96(ra) # 43aa <exit>
      printf("%s: unlink ../iputdir failed\n", s);
     352:	85a6                	mv	a1,s1
     354:	00005517          	auipc	a0,0x5
     358:	86c50513          	addi	a0,a0,-1940 # 4bc0 <malloc+0x3d8>
     35c:	00004097          	auipc	ra,0x4
     360:	3ce080e7          	jalr	974(ra) # 472a <printf>
      exit(1);
     364:	4505                	li	a0,1
     366:	00004097          	auipc	ra,0x4
     36a:	044080e7          	jalr	68(ra) # 43aa <exit>
  wait(&xstatus);
     36e:	fdc40513          	addi	a0,s0,-36
     372:	00004097          	auipc	ra,0x4
     376:	040080e7          	jalr	64(ra) # 43b2 <wait>
  exit(xstatus);
     37a:	fdc42503          	lw	a0,-36(s0)
     37e:	00004097          	auipc	ra,0x4
     382:	02c080e7          	jalr	44(ra) # 43aa <exit>

0000000000000386 <exitwait>:
{
     386:	7139                	addi	sp,sp,-64
     388:	fc06                	sd	ra,56(sp)
     38a:	f822                	sd	s0,48(sp)
     38c:	f426                	sd	s1,40(sp)
     38e:	f04a                	sd	s2,32(sp)
     390:	ec4e                	sd	s3,24(sp)
     392:	e852                	sd	s4,16(sp)
     394:	0080                	addi	s0,sp,64
     396:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     398:	4901                	li	s2,0
     39a:	06400993          	li	s3,100
    pid = fork();
     39e:	00004097          	auipc	ra,0x4
     3a2:	004080e7          	jalr	4(ra) # 43a2 <fork>
     3a6:	84aa                	mv	s1,a0
    if(pid < 0){
     3a8:	02054a63          	bltz	a0,3dc <exitwait+0x56>
    if(pid){
     3ac:	c151                	beqz	a0,430 <exitwait+0xaa>
      if(wait(&xstate) != pid){
     3ae:	fcc40513          	addi	a0,s0,-52
     3b2:	00004097          	auipc	ra,0x4
     3b6:	000080e7          	jalr	ra # 43b2 <wait>
     3ba:	02951f63          	bne	a0,s1,3f8 <exitwait+0x72>
      if(i != xstate) {
     3be:	fcc42783          	lw	a5,-52(s0)
     3c2:	05279963          	bne	a5,s2,414 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     3c6:	2905                	addiw	s2,s2,1
     3c8:	fd391be3          	bne	s2,s3,39e <exitwait+0x18>
}
     3cc:	70e2                	ld	ra,56(sp)
     3ce:	7442                	ld	s0,48(sp)
     3d0:	74a2                	ld	s1,40(sp)
     3d2:	7902                	ld	s2,32(sp)
     3d4:	69e2                	ld	s3,24(sp)
     3d6:	6a42                	ld	s4,16(sp)
     3d8:	6121                	addi	sp,sp,64
     3da:	8082                	ret
      printf("%s: fork failed\n", s);
     3dc:	85d2                	mv	a1,s4
     3de:	00005517          	auipc	a0,0x5
     3e2:	90a50513          	addi	a0,a0,-1782 # 4ce8 <malloc+0x500>
     3e6:	00004097          	auipc	ra,0x4
     3ea:	344080e7          	jalr	836(ra) # 472a <printf>
      exit(1);
     3ee:	4505                	li	a0,1
     3f0:	00004097          	auipc	ra,0x4
     3f4:	fba080e7          	jalr	-70(ra) # 43aa <exit>
        printf("%s: wait wrong pid\n", s);
     3f8:	85d2                	mv	a1,s4
     3fa:	00005517          	auipc	a0,0x5
     3fe:	91e50513          	addi	a0,a0,-1762 # 4d18 <malloc+0x530>
     402:	00004097          	auipc	ra,0x4
     406:	328080e7          	jalr	808(ra) # 472a <printf>
        exit(1);
     40a:	4505                	li	a0,1
     40c:	00004097          	auipc	ra,0x4
     410:	f9e080e7          	jalr	-98(ra) # 43aa <exit>
        printf("%s: wait wrong exit status\n", s);
     414:	85d2                	mv	a1,s4
     416:	00005517          	auipc	a0,0x5
     41a:	91a50513          	addi	a0,a0,-1766 # 4d30 <malloc+0x548>
     41e:	00004097          	auipc	ra,0x4
     422:	30c080e7          	jalr	780(ra) # 472a <printf>
        exit(1);
     426:	4505                	li	a0,1
     428:	00004097          	auipc	ra,0x4
     42c:	f82080e7          	jalr	-126(ra) # 43aa <exit>
      exit(i);
     430:	854a                	mv	a0,s2
     432:	00004097          	auipc	ra,0x4
     436:	f78080e7          	jalr	-136(ra) # 43aa <exit>

000000000000043a <twochildren>:
{
     43a:	1101                	addi	sp,sp,-32
     43c:	ec06                	sd	ra,24(sp)
     43e:	e822                	sd	s0,16(sp)
     440:	e426                	sd	s1,8(sp)
     442:	e04a                	sd	s2,0(sp)
     444:	1000                	addi	s0,sp,32
     446:	892a                	mv	s2,a0
     448:	3e800493          	li	s1,1000
    int pid1 = fork();
     44c:	00004097          	auipc	ra,0x4
     450:	f56080e7          	jalr	-170(ra) # 43a2 <fork>
    if(pid1 < 0){
     454:	02054c63          	bltz	a0,48c <twochildren+0x52>
    if(pid1 == 0){
     458:	c921                	beqz	a0,4a8 <twochildren+0x6e>
      int pid2 = fork();
     45a:	00004097          	auipc	ra,0x4
     45e:	f48080e7          	jalr	-184(ra) # 43a2 <fork>
      if(pid2 < 0){
     462:	04054763          	bltz	a0,4b0 <twochildren+0x76>
      if(pid2 == 0){
     466:	c13d                	beqz	a0,4cc <twochildren+0x92>
        wait(0);
     468:	4501                	li	a0,0
     46a:	00004097          	auipc	ra,0x4
     46e:	f48080e7          	jalr	-184(ra) # 43b2 <wait>
        wait(0);
     472:	4501                	li	a0,0
     474:	00004097          	auipc	ra,0x4
     478:	f3e080e7          	jalr	-194(ra) # 43b2 <wait>
  for(int i = 0; i < 1000; i++){
     47c:	34fd                	addiw	s1,s1,-1
     47e:	f4f9                	bnez	s1,44c <twochildren+0x12>
}
     480:	60e2                	ld	ra,24(sp)
     482:	6442                	ld	s0,16(sp)
     484:	64a2                	ld	s1,8(sp)
     486:	6902                	ld	s2,0(sp)
     488:	6105                	addi	sp,sp,32
     48a:	8082                	ret
      printf("%s: fork failed\n", s);
     48c:	85ca                	mv	a1,s2
     48e:	00005517          	auipc	a0,0x5
     492:	85a50513          	addi	a0,a0,-1958 # 4ce8 <malloc+0x500>
     496:	00004097          	auipc	ra,0x4
     49a:	294080e7          	jalr	660(ra) # 472a <printf>
      exit(1);
     49e:	4505                	li	a0,1
     4a0:	00004097          	auipc	ra,0x4
     4a4:	f0a080e7          	jalr	-246(ra) # 43aa <exit>
      exit(0);
     4a8:	00004097          	auipc	ra,0x4
     4ac:	f02080e7          	jalr	-254(ra) # 43aa <exit>
        printf("%s: fork failed\n", s);
     4b0:	85ca                	mv	a1,s2
     4b2:	00005517          	auipc	a0,0x5
     4b6:	83650513          	addi	a0,a0,-1994 # 4ce8 <malloc+0x500>
     4ba:	00004097          	auipc	ra,0x4
     4be:	270080e7          	jalr	624(ra) # 472a <printf>
        exit(1);
     4c2:	4505                	li	a0,1
     4c4:	00004097          	auipc	ra,0x4
     4c8:	ee6080e7          	jalr	-282(ra) # 43aa <exit>
        exit(0);
     4cc:	00004097          	auipc	ra,0x4
     4d0:	ede080e7          	jalr	-290(ra) # 43aa <exit>

00000000000004d4 <forkfork>:
{
     4d4:	7179                	addi	sp,sp,-48
     4d6:	f406                	sd	ra,40(sp)
     4d8:	f022                	sd	s0,32(sp)
     4da:	ec26                	sd	s1,24(sp)
     4dc:	1800                	addi	s0,sp,48
     4de:	84aa                	mv	s1,a0
    int pid = fork();
     4e0:	00004097          	auipc	ra,0x4
     4e4:	ec2080e7          	jalr	-318(ra) # 43a2 <fork>
    if(pid < 0){
     4e8:	04054163          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4ec:	cd29                	beqz	a0,546 <forkfork+0x72>
    int pid = fork();
     4ee:	00004097          	auipc	ra,0x4
     4f2:	eb4080e7          	jalr	-332(ra) # 43a2 <fork>
    if(pid < 0){
     4f6:	02054a63          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4fa:	c531                	beqz	a0,546 <forkfork+0x72>
    wait(&xstatus);
     4fc:	fdc40513          	addi	a0,s0,-36
     500:	00004097          	auipc	ra,0x4
     504:	eb2080e7          	jalr	-334(ra) # 43b2 <wait>
    if(xstatus != 0) {
     508:	fdc42783          	lw	a5,-36(s0)
     50c:	ebbd                	bnez	a5,582 <forkfork+0xae>
    wait(&xstatus);
     50e:	fdc40513          	addi	a0,s0,-36
     512:	00004097          	auipc	ra,0x4
     516:	ea0080e7          	jalr	-352(ra) # 43b2 <wait>
    if(xstatus != 0) {
     51a:	fdc42783          	lw	a5,-36(s0)
     51e:	e3b5                	bnez	a5,582 <forkfork+0xae>
}
     520:	70a2                	ld	ra,40(sp)
     522:	7402                	ld	s0,32(sp)
     524:	64e2                	ld	s1,24(sp)
     526:	6145                	addi	sp,sp,48
     528:	8082                	ret
      printf("%s: fork failed", s);
     52a:	85a6                	mv	a1,s1
     52c:	00005517          	auipc	a0,0x5
     530:	82450513          	addi	a0,a0,-2012 # 4d50 <malloc+0x568>
     534:	00004097          	auipc	ra,0x4
     538:	1f6080e7          	jalr	502(ra) # 472a <printf>
      exit(1);
     53c:	4505                	li	a0,1
     53e:	00004097          	auipc	ra,0x4
     542:	e6c080e7          	jalr	-404(ra) # 43aa <exit>
{
     546:	0c800493          	li	s1,200
        int pid1 = fork();
     54a:	00004097          	auipc	ra,0x4
     54e:	e58080e7          	jalr	-424(ra) # 43a2 <fork>
        if(pid1 < 0){
     552:	00054f63          	bltz	a0,570 <forkfork+0x9c>
        if(pid1 == 0){
     556:	c115                	beqz	a0,57a <forkfork+0xa6>
        wait(0);
     558:	4501                	li	a0,0
     55a:	00004097          	auipc	ra,0x4
     55e:	e58080e7          	jalr	-424(ra) # 43b2 <wait>
      for(int j = 0; j < 200; j++){
     562:	34fd                	addiw	s1,s1,-1
     564:	f0fd                	bnez	s1,54a <forkfork+0x76>
      exit(0);
     566:	4501                	li	a0,0
     568:	00004097          	auipc	ra,0x4
     56c:	e42080e7          	jalr	-446(ra) # 43aa <exit>
          exit(1);
     570:	4505                	li	a0,1
     572:	00004097          	auipc	ra,0x4
     576:	e38080e7          	jalr	-456(ra) # 43aa <exit>
          exit(0);
     57a:	00004097          	auipc	ra,0x4
     57e:	e30080e7          	jalr	-464(ra) # 43aa <exit>
      printf("%s: fork in child failed", s);
     582:	85a6                	mv	a1,s1
     584:	00004517          	auipc	a0,0x4
     588:	7dc50513          	addi	a0,a0,2012 # 4d60 <malloc+0x578>
     58c:	00004097          	auipc	ra,0x4
     590:	19e080e7          	jalr	414(ra) # 472a <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	00004097          	auipc	ra,0x4
     59a:	e14080e7          	jalr	-492(ra) # 43aa <exit>

000000000000059e <reparent2>:
{
     59e:	1101                	addi	sp,sp,-32
     5a0:	ec06                	sd	ra,24(sp)
     5a2:	e822                	sd	s0,16(sp)
     5a4:	e426                	sd	s1,8(sp)
     5a6:	1000                	addi	s0,sp,32
     5a8:	32000493          	li	s1,800
    int pid1 = fork();
     5ac:	00004097          	auipc	ra,0x4
     5b0:	df6080e7          	jalr	-522(ra) # 43a2 <fork>
    if(pid1 < 0){
     5b4:	00054f63          	bltz	a0,5d2 <reparent2+0x34>
    if(pid1 == 0){
     5b8:	c915                	beqz	a0,5ec <reparent2+0x4e>
    wait(0);
     5ba:	4501                	li	a0,0
     5bc:	00004097          	auipc	ra,0x4
     5c0:	df6080e7          	jalr	-522(ra) # 43b2 <wait>
  for(int i = 0; i < 800; i++){
     5c4:	34fd                	addiw	s1,s1,-1
     5c6:	f0fd                	bnez	s1,5ac <reparent2+0xe>
  exit(0);
     5c8:	4501                	li	a0,0
     5ca:	00004097          	auipc	ra,0x4
     5ce:	de0080e7          	jalr	-544(ra) # 43aa <exit>
      printf("fork failed\n");
     5d2:	00005517          	auipc	a0,0x5
     5d6:	01650513          	addi	a0,a0,22 # 55e8 <malloc+0xe00>
     5da:	00004097          	auipc	ra,0x4
     5de:	150080e7          	jalr	336(ra) # 472a <printf>
      exit(1);
     5e2:	4505                	li	a0,1
     5e4:	00004097          	auipc	ra,0x4
     5e8:	dc6080e7          	jalr	-570(ra) # 43aa <exit>
      fork();
     5ec:	00004097          	auipc	ra,0x4
     5f0:	db6080e7          	jalr	-586(ra) # 43a2 <fork>
      fork();
     5f4:	00004097          	auipc	ra,0x4
     5f8:	dae080e7          	jalr	-594(ra) # 43a2 <fork>
      exit(0);
     5fc:	4501                	li	a0,0
     5fe:	00004097          	auipc	ra,0x4
     602:	dac080e7          	jalr	-596(ra) # 43aa <exit>

0000000000000606 <forktest>:
{
     606:	7179                	addi	sp,sp,-48
     608:	f406                	sd	ra,40(sp)
     60a:	f022                	sd	s0,32(sp)
     60c:	ec26                	sd	s1,24(sp)
     60e:	e84a                	sd	s2,16(sp)
     610:	e44e                	sd	s3,8(sp)
     612:	1800                	addi	s0,sp,48
     614:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     616:	4481                	li	s1,0
     618:	3e800913          	li	s2,1000
    pid = fork();
     61c:	00004097          	auipc	ra,0x4
     620:	d86080e7          	jalr	-634(ra) # 43a2 <fork>
    if(pid < 0)
     624:	02054863          	bltz	a0,654 <forktest+0x4e>
    if(pid == 0)
     628:	c115                	beqz	a0,64c <forktest+0x46>
  for(n=0; n<N; n++){
     62a:	2485                	addiw	s1,s1,1
     62c:	ff2498e3          	bne	s1,s2,61c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     630:	85ce                	mv	a1,s3
     632:	00004517          	auipc	a0,0x4
     636:	76650513          	addi	a0,a0,1894 # 4d98 <malloc+0x5b0>
     63a:	00004097          	auipc	ra,0x4
     63e:	0f0080e7          	jalr	240(ra) # 472a <printf>
    exit(1);
     642:	4505                	li	a0,1
     644:	00004097          	auipc	ra,0x4
     648:	d66080e7          	jalr	-666(ra) # 43aa <exit>
      exit(0);
     64c:	00004097          	auipc	ra,0x4
     650:	d5e080e7          	jalr	-674(ra) # 43aa <exit>
  if (n == 0) {
     654:	cc9d                	beqz	s1,692 <forktest+0x8c>
  if(n == N){
     656:	3e800793          	li	a5,1000
     65a:	fcf48be3          	beq	s1,a5,630 <forktest+0x2a>
  for(; n > 0; n--){
     65e:	00905b63          	blez	s1,674 <forktest+0x6e>
    if(wait(0) < 0){
     662:	4501                	li	a0,0
     664:	00004097          	auipc	ra,0x4
     668:	d4e080e7          	jalr	-690(ra) # 43b2 <wait>
     66c:	04054163          	bltz	a0,6ae <forktest+0xa8>
  for(; n > 0; n--){
     670:	34fd                	addiw	s1,s1,-1
     672:	f8e5                	bnez	s1,662 <forktest+0x5c>
  if(wait(0) != -1){
     674:	4501                	li	a0,0
     676:	00004097          	auipc	ra,0x4
     67a:	d3c080e7          	jalr	-708(ra) # 43b2 <wait>
     67e:	57fd                	li	a5,-1
     680:	04f51563          	bne	a0,a5,6ca <forktest+0xc4>
}
     684:	70a2                	ld	ra,40(sp)
     686:	7402                	ld	s0,32(sp)
     688:	64e2                	ld	s1,24(sp)
     68a:	6942                	ld	s2,16(sp)
     68c:	69a2                	ld	s3,8(sp)
     68e:	6145                	addi	sp,sp,48
     690:	8082                	ret
    printf("%s: no fork at all!\n", s);
     692:	85ce                	mv	a1,s3
     694:	00004517          	auipc	a0,0x4
     698:	6ec50513          	addi	a0,a0,1772 # 4d80 <malloc+0x598>
     69c:	00004097          	auipc	ra,0x4
     6a0:	08e080e7          	jalr	142(ra) # 472a <printf>
    exit(1);
     6a4:	4505                	li	a0,1
     6a6:	00004097          	auipc	ra,0x4
     6aa:	d04080e7          	jalr	-764(ra) # 43aa <exit>
      printf("%s: wait stopped early\n", s);
     6ae:	85ce                	mv	a1,s3
     6b0:	00004517          	auipc	a0,0x4
     6b4:	71050513          	addi	a0,a0,1808 # 4dc0 <malloc+0x5d8>
     6b8:	00004097          	auipc	ra,0x4
     6bc:	072080e7          	jalr	114(ra) # 472a <printf>
      exit(1);
     6c0:	4505                	li	a0,1
     6c2:	00004097          	auipc	ra,0x4
     6c6:	ce8080e7          	jalr	-792(ra) # 43aa <exit>
    printf("%s: wait got too many\n", s);
     6ca:	85ce                	mv	a1,s3
     6cc:	00004517          	auipc	a0,0x4
     6d0:	70c50513          	addi	a0,a0,1804 # 4dd8 <malloc+0x5f0>
     6d4:	00004097          	auipc	ra,0x4
     6d8:	056080e7          	jalr	86(ra) # 472a <printf>
    exit(1);
     6dc:	4505                	li	a0,1
     6de:	00004097          	auipc	ra,0x4
     6e2:	ccc080e7          	jalr	-820(ra) # 43aa <exit>

00000000000006e6 <kernmem>:
{
     6e6:	715d                	addi	sp,sp,-80
     6e8:	e486                	sd	ra,72(sp)
     6ea:	e0a2                	sd	s0,64(sp)
     6ec:	fc26                	sd	s1,56(sp)
     6ee:	f84a                	sd	s2,48(sp)
     6f0:	f44e                	sd	s3,40(sp)
     6f2:	f052                	sd	s4,32(sp)
     6f4:	ec56                	sd	s5,24(sp)
     6f6:	0880                	addi	s0,sp,80
     6f8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     6fa:	4485                	li	s1,1
     6fc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
     6fe:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     700:	69b1                	lui	s3,0xc
     702:	35098993          	addi	s3,s3,848 # c350 <__BSS_END__+0x198>
     706:	1003d937          	lui	s2,0x1003d
     70a:	090e                	slli	s2,s2,0x3
     70c:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x100312c8>
    pid = fork();
     710:	00004097          	auipc	ra,0x4
     714:	c92080e7          	jalr	-878(ra) # 43a2 <fork>
    if(pid < 0){
     718:	02054963          	bltz	a0,74a <kernmem+0x64>
    if(pid == 0){
     71c:	c529                	beqz	a0,766 <kernmem+0x80>
    wait(&xstatus);
     71e:	fbc40513          	addi	a0,s0,-68
     722:	00004097          	auipc	ra,0x4
     726:	c90080e7          	jalr	-880(ra) # 43b2 <wait>
    if(xstatus != -1)  // did kernel kill child?
     72a:	fbc42783          	lw	a5,-68(s0)
     72e:	05579c63          	bne	a5,s5,786 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     732:	94ce                	add	s1,s1,s3
     734:	fd249ee3          	bne	s1,s2,710 <kernmem+0x2a>
}
     738:	60a6                	ld	ra,72(sp)
     73a:	6406                	ld	s0,64(sp)
     73c:	74e2                	ld	s1,56(sp)
     73e:	7942                	ld	s2,48(sp)
     740:	79a2                	ld	s3,40(sp)
     742:	7a02                	ld	s4,32(sp)
     744:	6ae2                	ld	s5,24(sp)
     746:	6161                	addi	sp,sp,80
     748:	8082                	ret
      printf("%s: fork failed\n", s);
     74a:	85d2                	mv	a1,s4
     74c:	00004517          	auipc	a0,0x4
     750:	59c50513          	addi	a0,a0,1436 # 4ce8 <malloc+0x500>
     754:	00004097          	auipc	ra,0x4
     758:	fd6080e7          	jalr	-42(ra) # 472a <printf>
      exit(1);
     75c:	4505                	li	a0,1
     75e:	00004097          	auipc	ra,0x4
     762:	c4c080e7          	jalr	-948(ra) # 43aa <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
     766:	0004c603          	lbu	a2,0(s1)
     76a:	85a6                	mv	a1,s1
     76c:	00004517          	auipc	a0,0x4
     770:	68450513          	addi	a0,a0,1668 # 4df0 <malloc+0x608>
     774:	00004097          	auipc	ra,0x4
     778:	fb6080e7          	jalr	-74(ra) # 472a <printf>
      exit(1);
     77c:	4505                	li	a0,1
     77e:	00004097          	auipc	ra,0x4
     782:	c2c080e7          	jalr	-980(ra) # 43aa <exit>
      exit(1);
     786:	4505                	li	a0,1
     788:	00004097          	auipc	ra,0x4
     78c:	c22080e7          	jalr	-990(ra) # 43aa <exit>

0000000000000790 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
     790:	7179                	addi	sp,sp,-48
     792:	f406                	sd	ra,40(sp)
     794:	f022                	sd	s0,32(sp)
     796:	ec26                	sd	s1,24(sp)
     798:	1800                	addi	s0,sp,48
     79a:	84aa                	mv	s1,a0
  int pid;
  int xstatus;
  
  pid = fork();
     79c:	00004097          	auipc	ra,0x4
     7a0:	c06080e7          	jalr	-1018(ra) # 43a2 <fork>
  if(pid == 0) {
     7a4:	c115                	beqz	a0,7c8 <stacktest+0x38>
    char *sp = (char *) r_sp();
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", *sp);
    exit(1);
  } else if(pid < 0){
     7a6:	04054363          	bltz	a0,7ec <stacktest+0x5c>
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
     7aa:	fdc40513          	addi	a0,s0,-36
     7ae:	00004097          	auipc	ra,0x4
     7b2:	c04080e7          	jalr	-1020(ra) # 43b2 <wait>
  if(xstatus == -1)  // kernel killed child?
     7b6:	fdc42503          	lw	a0,-36(s0)
     7ba:	57fd                	li	a5,-1
     7bc:	04f50663          	beq	a0,a5,808 <stacktest+0x78>
    exit(0);
  else
    exit(xstatus);
     7c0:	00004097          	auipc	ra,0x4
     7c4:	bea080e7          	jalr	-1046(ra) # 43aa <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
     7c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
     7ca:	77fd                	lui	a5,0xfffff
     7cc:	97ba                	add	a5,a5,a4
     7ce:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff2e48>
     7d2:	00004517          	auipc	a0,0x4
     7d6:	63e50513          	addi	a0,a0,1598 # 4e10 <malloc+0x628>
     7da:	00004097          	auipc	ra,0x4
     7de:	f50080e7          	jalr	-176(ra) # 472a <printf>
    exit(1);
     7e2:	4505                	li	a0,1
     7e4:	00004097          	auipc	ra,0x4
     7e8:	bc6080e7          	jalr	-1082(ra) # 43aa <exit>
    printf("%s: fork failed\n", s);
     7ec:	85a6                	mv	a1,s1
     7ee:	00004517          	auipc	a0,0x4
     7f2:	4fa50513          	addi	a0,a0,1274 # 4ce8 <malloc+0x500>
     7f6:	00004097          	auipc	ra,0x4
     7fa:	f34080e7          	jalr	-204(ra) # 472a <printf>
    exit(1);
     7fe:	4505                	li	a0,1
     800:	00004097          	auipc	ra,0x4
     804:	baa080e7          	jalr	-1110(ra) # 43aa <exit>
    exit(0);
     808:	4501                	li	a0,0
     80a:	00004097          	auipc	ra,0x4
     80e:	ba0080e7          	jalr	-1120(ra) # 43aa <exit>

0000000000000812 <openiputtest>:
{
     812:	7179                	addi	sp,sp,-48
     814:	f406                	sd	ra,40(sp)
     816:	f022                	sd	s0,32(sp)
     818:	ec26                	sd	s1,24(sp)
     81a:	1800                	addi	s0,sp,48
     81c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
     81e:	00004517          	auipc	a0,0x4
     822:	61a50513          	addi	a0,a0,1562 # 4e38 <malloc+0x650>
     826:	00004097          	auipc	ra,0x4
     82a:	bec080e7          	jalr	-1044(ra) # 4412 <mkdir>
     82e:	04054263          	bltz	a0,872 <openiputtest+0x60>
  pid = fork();
     832:	00004097          	auipc	ra,0x4
     836:	b70080e7          	jalr	-1168(ra) # 43a2 <fork>
  if(pid < 0){
     83a:	04054a63          	bltz	a0,88e <openiputtest+0x7c>
  if(pid == 0){
     83e:	e93d                	bnez	a0,8b4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
     840:	4589                	li	a1,2
     842:	00004517          	auipc	a0,0x4
     846:	5f650513          	addi	a0,a0,1526 # 4e38 <malloc+0x650>
     84a:	00004097          	auipc	ra,0x4
     84e:	ba0080e7          	jalr	-1120(ra) # 43ea <open>
    if(fd >= 0){
     852:	04054c63          	bltz	a0,8aa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
     856:	85a6                	mv	a1,s1
     858:	00004517          	auipc	a0,0x4
     85c:	60050513          	addi	a0,a0,1536 # 4e58 <malloc+0x670>
     860:	00004097          	auipc	ra,0x4
     864:	eca080e7          	jalr	-310(ra) # 472a <printf>
      exit(1);
     868:	4505                	li	a0,1
     86a:	00004097          	auipc	ra,0x4
     86e:	b40080e7          	jalr	-1216(ra) # 43aa <exit>
    printf("%s: mkdir oidir failed\n", s);
     872:	85a6                	mv	a1,s1
     874:	00004517          	auipc	a0,0x4
     878:	5cc50513          	addi	a0,a0,1484 # 4e40 <malloc+0x658>
     87c:	00004097          	auipc	ra,0x4
     880:	eae080e7          	jalr	-338(ra) # 472a <printf>
    exit(1);
     884:	4505                	li	a0,1
     886:	00004097          	auipc	ra,0x4
     88a:	b24080e7          	jalr	-1244(ra) # 43aa <exit>
    printf("%s: fork failed\n", s);
     88e:	85a6                	mv	a1,s1
     890:	00004517          	auipc	a0,0x4
     894:	45850513          	addi	a0,a0,1112 # 4ce8 <malloc+0x500>
     898:	00004097          	auipc	ra,0x4
     89c:	e92080e7          	jalr	-366(ra) # 472a <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00004097          	auipc	ra,0x4
     8a6:	b08080e7          	jalr	-1272(ra) # 43aa <exit>
    exit(0);
     8aa:	4501                	li	a0,0
     8ac:	00004097          	auipc	ra,0x4
     8b0:	afe080e7          	jalr	-1282(ra) # 43aa <exit>
  sleep(1);
     8b4:	4505                	li	a0,1
     8b6:	00004097          	auipc	ra,0x4
     8ba:	b84080e7          	jalr	-1148(ra) # 443a <sleep>
  if(unlink("oidir") != 0){
     8be:	00004517          	auipc	a0,0x4
     8c2:	57a50513          	addi	a0,a0,1402 # 4e38 <malloc+0x650>
     8c6:	00004097          	auipc	ra,0x4
     8ca:	b34080e7          	jalr	-1228(ra) # 43fa <unlink>
     8ce:	cd19                	beqz	a0,8ec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
     8d0:	85a6                	mv	a1,s1
     8d2:	00004517          	auipc	a0,0x4
     8d6:	5ae50513          	addi	a0,a0,1454 # 4e80 <malloc+0x698>
     8da:	00004097          	auipc	ra,0x4
     8de:	e50080e7          	jalr	-432(ra) # 472a <printf>
    exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00004097          	auipc	ra,0x4
     8e8:	ac6080e7          	jalr	-1338(ra) # 43aa <exit>
  wait(&xstatus);
     8ec:	fdc40513          	addi	a0,s0,-36
     8f0:	00004097          	auipc	ra,0x4
     8f4:	ac2080e7          	jalr	-1342(ra) # 43b2 <wait>
  exit(xstatus);
     8f8:	fdc42503          	lw	a0,-36(s0)
     8fc:	00004097          	auipc	ra,0x4
     900:	aae080e7          	jalr	-1362(ra) # 43aa <exit>

0000000000000904 <opentest>:
{
     904:	1101                	addi	sp,sp,-32
     906:	ec06                	sd	ra,24(sp)
     908:	e822                	sd	s0,16(sp)
     90a:	e426                	sd	s1,8(sp)
     90c:	1000                	addi	s0,sp,32
     90e:	84aa                	mv	s1,a0
  fd = open("echo", 0);
     910:	4581                	li	a1,0
     912:	00004517          	auipc	a0,0x4
     916:	58650513          	addi	a0,a0,1414 # 4e98 <malloc+0x6b0>
     91a:	00004097          	auipc	ra,0x4
     91e:	ad0080e7          	jalr	-1328(ra) # 43ea <open>
  if(fd < 0){
     922:	02054663          	bltz	a0,94e <opentest+0x4a>
  close(fd);
     926:	00004097          	auipc	ra,0x4
     92a:	aac080e7          	jalr	-1364(ra) # 43d2 <close>
  fd = open("doesnotexist", 0);
     92e:	4581                	li	a1,0
     930:	00004517          	auipc	a0,0x4
     934:	58850513          	addi	a0,a0,1416 # 4eb8 <malloc+0x6d0>
     938:	00004097          	auipc	ra,0x4
     93c:	ab2080e7          	jalr	-1358(ra) # 43ea <open>
  if(fd >= 0){
     940:	02055563          	bgez	a0,96a <opentest+0x66>
}
     944:	60e2                	ld	ra,24(sp)
     946:	6442                	ld	s0,16(sp)
     948:	64a2                	ld	s1,8(sp)
     94a:	6105                	addi	sp,sp,32
     94c:	8082                	ret
    printf("%s: open echo failed!\n", s);
     94e:	85a6                	mv	a1,s1
     950:	00004517          	auipc	a0,0x4
     954:	55050513          	addi	a0,a0,1360 # 4ea0 <malloc+0x6b8>
     958:	00004097          	auipc	ra,0x4
     95c:	dd2080e7          	jalr	-558(ra) # 472a <printf>
    exit(1);
     960:	4505                	li	a0,1
     962:	00004097          	auipc	ra,0x4
     966:	a48080e7          	jalr	-1464(ra) # 43aa <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     96a:	85a6                	mv	a1,s1
     96c:	00004517          	auipc	a0,0x4
     970:	55c50513          	addi	a0,a0,1372 # 4ec8 <malloc+0x6e0>
     974:	00004097          	auipc	ra,0x4
     978:	db6080e7          	jalr	-586(ra) # 472a <printf>
    exit(1);
     97c:	4505                	li	a0,1
     97e:	00004097          	auipc	ra,0x4
     982:	a2c080e7          	jalr	-1492(ra) # 43aa <exit>

0000000000000986 <createtest>:
{
     986:	7179                	addi	sp,sp,-48
     988:	f406                	sd	ra,40(sp)
     98a:	f022                	sd	s0,32(sp)
     98c:	ec26                	sd	s1,24(sp)
     98e:	e84a                	sd	s2,16(sp)
     990:	e44e                	sd	s3,8(sp)
     992:	1800                	addi	s0,sp,48
  name[0] = 'a';
     994:	00006797          	auipc	a5,0x6
     998:	ff478793          	addi	a5,a5,-12 # 6988 <name>
     99c:	06100713          	li	a4,97
     9a0:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9a4:	00078123          	sb	zero,2(a5)
     9a8:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ac:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9ae:	06400993          	li	s3,100
    name[1] = '0' + i;
     9b2:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     9b6:	20200593          	li	a1,514
     9ba:	854a                	mv	a0,s2
     9bc:	00004097          	auipc	ra,0x4
     9c0:	a2e080e7          	jalr	-1490(ra) # 43ea <open>
    close(fd);
     9c4:	00004097          	auipc	ra,0x4
     9c8:	a0e080e7          	jalr	-1522(ra) # 43d2 <close>
  for(i = 0; i < N; i++){
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0ff4f493          	andi	s1,s1,255
     9d2:	ff3490e3          	bne	s1,s3,9b2 <createtest+0x2c>
  name[0] = 'a';
     9d6:	00006797          	auipc	a5,0x6
     9da:	fb278793          	addi	a5,a5,-78 # 6988 <name>
     9de:	06100713          	li	a4,97
     9e2:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9e6:	00078123          	sb	zero,2(a5)
     9ea:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ee:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9f0:	06400993          	li	s3,100
    name[1] = '0' + i;
     9f4:	009900a3          	sb	s1,1(s2)
    unlink(name);
     9f8:	854a                	mv	a0,s2
     9fa:	00004097          	auipc	ra,0x4
     9fe:	a00080e7          	jalr	-1536(ra) # 43fa <unlink>
  for(i = 0; i < N; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	0ff4f493          	andi	s1,s1,255
     a08:	ff3496e3          	bne	s1,s3,9f4 <createtest+0x6e>
}
     a0c:	70a2                	ld	ra,40(sp)
     a0e:	7402                	ld	s0,32(sp)
     a10:	64e2                	ld	s1,24(sp)
     a12:	6942                	ld	s2,16(sp)
     a14:	69a2                	ld	s3,8(sp)
     a16:	6145                	addi	sp,sp,48
     a18:	8082                	ret

0000000000000a1a <forkforkfork>:
{
     a1a:	1101                	addi	sp,sp,-32
     a1c:	ec06                	sd	ra,24(sp)
     a1e:	e822                	sd	s0,16(sp)
     a20:	e426                	sd	s1,8(sp)
     a22:	1000                	addi	s0,sp,32
     a24:	84aa                	mv	s1,a0
  unlink("stopforking");
     a26:	00004517          	auipc	a0,0x4
     a2a:	4ca50513          	addi	a0,a0,1226 # 4ef0 <malloc+0x708>
     a2e:	00004097          	auipc	ra,0x4
     a32:	9cc080e7          	jalr	-1588(ra) # 43fa <unlink>
  int pid = fork();
     a36:	00004097          	auipc	ra,0x4
     a3a:	96c080e7          	jalr	-1684(ra) # 43a2 <fork>
  if(pid < 0){
     a3e:	04054563          	bltz	a0,a88 <forkforkfork+0x6e>
  if(pid == 0){
     a42:	c12d                	beqz	a0,aa4 <forkforkfork+0x8a>
  sleep(20); // two seconds
     a44:	4551                	li	a0,20
     a46:	00004097          	auipc	ra,0x4
     a4a:	9f4080e7          	jalr	-1548(ra) # 443a <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     a4e:	20200593          	li	a1,514
     a52:	00004517          	auipc	a0,0x4
     a56:	49e50513          	addi	a0,a0,1182 # 4ef0 <malloc+0x708>
     a5a:	00004097          	auipc	ra,0x4
     a5e:	990080e7          	jalr	-1648(ra) # 43ea <open>
     a62:	00004097          	auipc	ra,0x4
     a66:	970080e7          	jalr	-1680(ra) # 43d2 <close>
  wait(0);
     a6a:	4501                	li	a0,0
     a6c:	00004097          	auipc	ra,0x4
     a70:	946080e7          	jalr	-1722(ra) # 43b2 <wait>
  sleep(10); // one second
     a74:	4529                	li	a0,10
     a76:	00004097          	auipc	ra,0x4
     a7a:	9c4080e7          	jalr	-1596(ra) # 443a <sleep>
}
     a7e:	60e2                	ld	ra,24(sp)
     a80:	6442                	ld	s0,16(sp)
     a82:	64a2                	ld	s1,8(sp)
     a84:	6105                	addi	sp,sp,32
     a86:	8082                	ret
    printf("%s: fork failed", s);
     a88:	85a6                	mv	a1,s1
     a8a:	00004517          	auipc	a0,0x4
     a8e:	2c650513          	addi	a0,a0,710 # 4d50 <malloc+0x568>
     a92:	00004097          	auipc	ra,0x4
     a96:	c98080e7          	jalr	-872(ra) # 472a <printf>
    exit(1);
     a9a:	4505                	li	a0,1
     a9c:	00004097          	auipc	ra,0x4
     aa0:	90e080e7          	jalr	-1778(ra) # 43aa <exit>
      int fd = open("stopforking", 0);
     aa4:	00004497          	auipc	s1,0x4
     aa8:	44c48493          	addi	s1,s1,1100 # 4ef0 <malloc+0x708>
     aac:	4581                	li	a1,0
     aae:	8526                	mv	a0,s1
     ab0:	00004097          	auipc	ra,0x4
     ab4:	93a080e7          	jalr	-1734(ra) # 43ea <open>
      if(fd >= 0){
     ab8:	02055463          	bgez	a0,ae0 <forkforkfork+0xc6>
      if(fork() < 0){
     abc:	00004097          	auipc	ra,0x4
     ac0:	8e6080e7          	jalr	-1818(ra) # 43a2 <fork>
     ac4:	fe0554e3          	bgez	a0,aac <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
     ac8:	20200593          	li	a1,514
     acc:	8526                	mv	a0,s1
     ace:	00004097          	auipc	ra,0x4
     ad2:	91c080e7          	jalr	-1764(ra) # 43ea <open>
     ad6:	00004097          	auipc	ra,0x4
     ada:	8fc080e7          	jalr	-1796(ra) # 43d2 <close>
     ade:	b7f9                	j	aac <forkforkfork+0x92>
        exit(0);
     ae0:	4501                	li	a0,0
     ae2:	00004097          	auipc	ra,0x4
     ae6:	8c8080e7          	jalr	-1848(ra) # 43aa <exit>

0000000000000aea <createdelete>:
{
     aea:	7175                	addi	sp,sp,-144
     aec:	e506                	sd	ra,136(sp)
     aee:	e122                	sd	s0,128(sp)
     af0:	fca6                	sd	s1,120(sp)
     af2:	f8ca                	sd	s2,112(sp)
     af4:	f4ce                	sd	s3,104(sp)
     af6:	f0d2                	sd	s4,96(sp)
     af8:	ecd6                	sd	s5,88(sp)
     afa:	e8da                	sd	s6,80(sp)
     afc:	e4de                	sd	s7,72(sp)
     afe:	e0e2                	sd	s8,64(sp)
     b00:	fc66                	sd	s9,56(sp)
     b02:	0900                	addi	s0,sp,144
     b04:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
     b06:	4901                	li	s2,0
     b08:	4991                	li	s3,4
    pid = fork();
     b0a:	00004097          	auipc	ra,0x4
     b0e:	898080e7          	jalr	-1896(ra) # 43a2 <fork>
     b12:	84aa                	mv	s1,a0
    if(pid < 0){
     b14:	02054f63          	bltz	a0,b52 <createdelete+0x68>
    if(pid == 0){
     b18:	c939                	beqz	a0,b6e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
     b1a:	2905                	addiw	s2,s2,1
     b1c:	ff3917e3          	bne	s2,s3,b0a <createdelete+0x20>
     b20:	4491                	li	s1,4
    wait(&xstatus);
     b22:	f7c40513          	addi	a0,s0,-132
     b26:	00004097          	auipc	ra,0x4
     b2a:	88c080e7          	jalr	-1908(ra) # 43b2 <wait>
    if(xstatus != 0)
     b2e:	f7c42903          	lw	s2,-132(s0)
     b32:	0e091263          	bnez	s2,c16 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
     b36:	34fd                	addiw	s1,s1,-1
     b38:	f4ed                	bnez	s1,b22 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
     b3a:	f8040123          	sb	zero,-126(s0)
     b3e:	03000993          	li	s3,48
     b42:	5a7d                	li	s4,-1
     b44:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
     b48:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
     b4a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
     b4c:	07400a93          	li	s5,116
     b50:	a29d                	j	cb6 <createdelete+0x1cc>
      printf("fork failed\n", s);
     b52:	85e6                	mv	a1,s9
     b54:	00005517          	auipc	a0,0x5
     b58:	a9450513          	addi	a0,a0,-1388 # 55e8 <malloc+0xe00>
     b5c:	00004097          	auipc	ra,0x4
     b60:	bce080e7          	jalr	-1074(ra) # 472a <printf>
      exit(1);
     b64:	4505                	li	a0,1
     b66:	00004097          	auipc	ra,0x4
     b6a:	844080e7          	jalr	-1980(ra) # 43aa <exit>
      name[0] = 'p' + pi;
     b6e:	0709091b          	addiw	s2,s2,112
     b72:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
     b76:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
     b7a:	4951                	li	s2,20
     b7c:	a015                	j	ba0 <createdelete+0xb6>
          printf("%s: create failed\n", s);
     b7e:	85e6                	mv	a1,s9
     b80:	00004517          	auipc	a0,0x4
     b84:	38050513          	addi	a0,a0,896 # 4f00 <malloc+0x718>
     b88:	00004097          	auipc	ra,0x4
     b8c:	ba2080e7          	jalr	-1118(ra) # 472a <printf>
          exit(1);
     b90:	4505                	li	a0,1
     b92:	00004097          	auipc	ra,0x4
     b96:	818080e7          	jalr	-2024(ra) # 43aa <exit>
      for(i = 0; i < N; i++){
     b9a:	2485                	addiw	s1,s1,1
     b9c:	07248863          	beq	s1,s2,c0c <createdelete+0x122>
        name[1] = '0' + i;
     ba0:	0304879b          	addiw	a5,s1,48
     ba4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
     ba8:	20200593          	li	a1,514
     bac:	f8040513          	addi	a0,s0,-128
     bb0:	00004097          	auipc	ra,0x4
     bb4:	83a080e7          	jalr	-1990(ra) # 43ea <open>
        if(fd < 0){
     bb8:	fc0543e3          	bltz	a0,b7e <createdelete+0x94>
        close(fd);
     bbc:	00004097          	auipc	ra,0x4
     bc0:	816080e7          	jalr	-2026(ra) # 43d2 <close>
        if(i > 0 && (i % 2 ) == 0){
     bc4:	fc905be3          	blez	s1,b9a <createdelete+0xb0>
     bc8:	0014f793          	andi	a5,s1,1
     bcc:	f7f9                	bnez	a5,b9a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
     bce:	01f4d79b          	srliw	a5,s1,0x1f
     bd2:	9fa5                	addw	a5,a5,s1
     bd4:	4017d79b          	sraiw	a5,a5,0x1
     bd8:	0307879b          	addiw	a5,a5,48
     bdc:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
     be0:	f8040513          	addi	a0,s0,-128
     be4:	00004097          	auipc	ra,0x4
     be8:	816080e7          	jalr	-2026(ra) # 43fa <unlink>
     bec:	fa0557e3          	bgez	a0,b9a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
     bf0:	85e6                	mv	a1,s9
     bf2:	00004517          	auipc	a0,0x4
     bf6:	28e50513          	addi	a0,a0,654 # 4e80 <malloc+0x698>
     bfa:	00004097          	auipc	ra,0x4
     bfe:	b30080e7          	jalr	-1232(ra) # 472a <printf>
            exit(1);
     c02:	4505                	li	a0,1
     c04:	00003097          	auipc	ra,0x3
     c08:	7a6080e7          	jalr	1958(ra) # 43aa <exit>
      exit(0);
     c0c:	4501                	li	a0,0
     c0e:	00003097          	auipc	ra,0x3
     c12:	79c080e7          	jalr	1948(ra) # 43aa <exit>
      exit(1);
     c16:	4505                	li	a0,1
     c18:	00003097          	auipc	ra,0x3
     c1c:	792080e7          	jalr	1938(ra) # 43aa <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
     c20:	f8040613          	addi	a2,s0,-128
     c24:	85e6                	mv	a1,s9
     c26:	00004517          	auipc	a0,0x4
     c2a:	2f250513          	addi	a0,a0,754 # 4f18 <malloc+0x730>
     c2e:	00004097          	auipc	ra,0x4
     c32:	afc080e7          	jalr	-1284(ra) # 472a <printf>
        exit(1);
     c36:	4505                	li	a0,1
     c38:	00003097          	auipc	ra,0x3
     c3c:	772080e7          	jalr	1906(ra) # 43aa <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c40:	054b7163          	bgeu	s6,s4,c82 <createdelete+0x198>
      if(fd >= 0)
     c44:	02055a63          	bgez	a0,c78 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
     c48:	2485                	addiw	s1,s1,1
     c4a:	0ff4f493          	andi	s1,s1,255
     c4e:	05548c63          	beq	s1,s5,ca6 <createdelete+0x1bc>
      name[0] = 'p' + pi;
     c52:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
     c56:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
     c5a:	4581                	li	a1,0
     c5c:	f8040513          	addi	a0,s0,-128
     c60:	00003097          	auipc	ra,0x3
     c64:	78a080e7          	jalr	1930(ra) # 43ea <open>
      if((i == 0 || i >= N/2) && fd < 0){
     c68:	00090463          	beqz	s2,c70 <createdelete+0x186>
     c6c:	fd2bdae3          	bge	s7,s2,c40 <createdelete+0x156>
     c70:	fa0548e3          	bltz	a0,c20 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c74:	014b7963          	bgeu	s6,s4,c86 <createdelete+0x19c>
        close(fd);
     c78:	00003097          	auipc	ra,0x3
     c7c:	75a080e7          	jalr	1882(ra) # 43d2 <close>
     c80:	b7e1                	j	c48 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c82:	fc0543e3          	bltz	a0,c48 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
     c86:	f8040613          	addi	a2,s0,-128
     c8a:	85e6                	mv	a1,s9
     c8c:	00004517          	auipc	a0,0x4
     c90:	2b450513          	addi	a0,a0,692 # 4f40 <malloc+0x758>
     c94:	00004097          	auipc	ra,0x4
     c98:	a96080e7          	jalr	-1386(ra) # 472a <printf>
        exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00003097          	auipc	ra,0x3
     ca2:	70c080e7          	jalr	1804(ra) # 43aa <exit>
  for(i = 0; i < N; i++){
     ca6:	2905                	addiw	s2,s2,1
     ca8:	2a05                	addiw	s4,s4,1
     caa:	2985                	addiw	s3,s3,1
     cac:	0ff9f993          	andi	s3,s3,255
     cb0:	47d1                	li	a5,20
     cb2:	02f90a63          	beq	s2,a5,ce6 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
     cb6:	84e2                	mv	s1,s8
     cb8:	bf69                	j	c52 <createdelete+0x168>
  for(i = 0; i < N; i++){
     cba:	2905                	addiw	s2,s2,1
     cbc:	0ff97913          	andi	s2,s2,255
     cc0:	2985                	addiw	s3,s3,1
     cc2:	0ff9f993          	andi	s3,s3,255
     cc6:	03490863          	beq	s2,s4,cf6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
     cca:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
     ccc:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
     cd0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
     cd4:	f8040513          	addi	a0,s0,-128
     cd8:	00003097          	auipc	ra,0x3
     cdc:	722080e7          	jalr	1826(ra) # 43fa <unlink>
    for(pi = 0; pi < NCHILD; pi++){
     ce0:	34fd                	addiw	s1,s1,-1
     ce2:	f4ed                	bnez	s1,ccc <createdelete+0x1e2>
     ce4:	bfd9                	j	cba <createdelete+0x1d0>
     ce6:	03000993          	li	s3,48
     cea:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
     cee:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
     cf0:	08400a13          	li	s4,132
     cf4:	bfd9                	j	cca <createdelete+0x1e0>
}
     cf6:	60aa                	ld	ra,136(sp)
     cf8:	640a                	ld	s0,128(sp)
     cfa:	74e6                	ld	s1,120(sp)
     cfc:	7946                	ld	s2,112(sp)
     cfe:	79a6                	ld	s3,104(sp)
     d00:	7a06                	ld	s4,96(sp)
     d02:	6ae6                	ld	s5,88(sp)
     d04:	6b46                	ld	s6,80(sp)
     d06:	6ba6                	ld	s7,72(sp)
     d08:	6c06                	ld	s8,64(sp)
     d0a:	7ce2                	ld	s9,56(sp)
     d0c:	6149                	addi	sp,sp,144
     d0e:	8082                	ret

0000000000000d10 <fourteen>:
{
     d10:	1101                	addi	sp,sp,-32
     d12:	ec06                	sd	ra,24(sp)
     d14:	e822                	sd	s0,16(sp)
     d16:	e426                	sd	s1,8(sp)
     d18:	1000                	addi	s0,sp,32
     d1a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
     d1c:	00004517          	auipc	a0,0x4
     d20:	41c50513          	addi	a0,a0,1052 # 5138 <malloc+0x950>
     d24:	00003097          	auipc	ra,0x3
     d28:	6ee080e7          	jalr	1774(ra) # 4412 <mkdir>
     d2c:	e141                	bnez	a0,dac <fourteen+0x9c>
  if(mkdir("12345678901234/123456789012345") != 0){
     d2e:	00004517          	auipc	a0,0x4
     d32:	26250513          	addi	a0,a0,610 # 4f90 <malloc+0x7a8>
     d36:	00003097          	auipc	ra,0x3
     d3a:	6dc080e7          	jalr	1756(ra) # 4412 <mkdir>
     d3e:	e549                	bnez	a0,dc8 <fourteen+0xb8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     d40:	20000593          	li	a1,512
     d44:	00004517          	auipc	a0,0x4
     d48:	2a450513          	addi	a0,a0,676 # 4fe8 <malloc+0x800>
     d4c:	00003097          	auipc	ra,0x3
     d50:	69e080e7          	jalr	1694(ra) # 43ea <open>
  if(fd < 0){
     d54:	08054863          	bltz	a0,de4 <fourteen+0xd4>
  close(fd);
     d58:	00003097          	auipc	ra,0x3
     d5c:	67a080e7          	jalr	1658(ra) # 43d2 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     d60:	4581                	li	a1,0
     d62:	00004517          	auipc	a0,0x4
     d66:	2fe50513          	addi	a0,a0,766 # 5060 <malloc+0x878>
     d6a:	00003097          	auipc	ra,0x3
     d6e:	680080e7          	jalr	1664(ra) # 43ea <open>
  if(fd < 0){
     d72:	08054763          	bltz	a0,e00 <fourteen+0xf0>
  close(fd);
     d76:	00003097          	auipc	ra,0x3
     d7a:	65c080e7          	jalr	1628(ra) # 43d2 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
     d7e:	00004517          	auipc	a0,0x4
     d82:	35250513          	addi	a0,a0,850 # 50d0 <malloc+0x8e8>
     d86:	00003097          	auipc	ra,0x3
     d8a:	68c080e7          	jalr	1676(ra) # 4412 <mkdir>
     d8e:	c559                	beqz	a0,e1c <fourteen+0x10c>
  if(mkdir("123456789012345/12345678901234") == 0){
     d90:	00004517          	auipc	a0,0x4
     d94:	39850513          	addi	a0,a0,920 # 5128 <malloc+0x940>
     d98:	00003097          	auipc	ra,0x3
     d9c:	67a080e7          	jalr	1658(ra) # 4412 <mkdir>
     da0:	cd41                	beqz	a0,e38 <fourteen+0x128>
}
     da2:	60e2                	ld	ra,24(sp)
     da4:	6442                	ld	s0,16(sp)
     da6:	64a2                	ld	s1,8(sp)
     da8:	6105                	addi	sp,sp,32
     daa:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
     dac:	85a6                	mv	a1,s1
     dae:	00004517          	auipc	a0,0x4
     db2:	1ba50513          	addi	a0,a0,442 # 4f68 <malloc+0x780>
     db6:	00004097          	auipc	ra,0x4
     dba:	974080e7          	jalr	-1676(ra) # 472a <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	00003097          	auipc	ra,0x3
     dc4:	5ea080e7          	jalr	1514(ra) # 43aa <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
     dc8:	85a6                	mv	a1,s1
     dca:	00004517          	auipc	a0,0x4
     dce:	1e650513          	addi	a0,a0,486 # 4fb0 <malloc+0x7c8>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	958080e7          	jalr	-1704(ra) # 472a <printf>
    exit(1);
     dda:	4505                	li	a0,1
     ddc:	00003097          	auipc	ra,0x3
     de0:	5ce080e7          	jalr	1486(ra) # 43aa <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
     de4:	85a6                	mv	a1,s1
     de6:	00004517          	auipc	a0,0x4
     dea:	23250513          	addi	a0,a0,562 # 5018 <malloc+0x830>
     dee:	00004097          	auipc	ra,0x4
     df2:	93c080e7          	jalr	-1732(ra) # 472a <printf>
    exit(1);
     df6:	4505                	li	a0,1
     df8:	00003097          	auipc	ra,0x3
     dfc:	5b2080e7          	jalr	1458(ra) # 43aa <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
     e00:	85a6                	mv	a1,s1
     e02:	00004517          	auipc	a0,0x4
     e06:	28e50513          	addi	a0,a0,654 # 5090 <malloc+0x8a8>
     e0a:	00004097          	auipc	ra,0x4
     e0e:	920080e7          	jalr	-1760(ra) # 472a <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	00003097          	auipc	ra,0x3
     e18:	596080e7          	jalr	1430(ra) # 43aa <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
     e1c:	85a6                	mv	a1,s1
     e1e:	00004517          	auipc	a0,0x4
     e22:	2d250513          	addi	a0,a0,722 # 50f0 <malloc+0x908>
     e26:	00004097          	auipc	ra,0x4
     e2a:	904080e7          	jalr	-1788(ra) # 472a <printf>
    exit(1);
     e2e:	4505                	li	a0,1
     e30:	00003097          	auipc	ra,0x3
     e34:	57a080e7          	jalr	1402(ra) # 43aa <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
     e38:	85a6                	mv	a1,s1
     e3a:	00004517          	auipc	a0,0x4
     e3e:	30e50513          	addi	a0,a0,782 # 5148 <malloc+0x960>
     e42:	00004097          	auipc	ra,0x4
     e46:	8e8080e7          	jalr	-1816(ra) # 472a <printf>
    exit(1);
     e4a:	4505                	li	a0,1
     e4c:	00003097          	auipc	ra,0x3
     e50:	55e080e7          	jalr	1374(ra) # 43aa <exit>

0000000000000e54 <bigwrite>:
{
     e54:	715d                	addi	sp,sp,-80
     e56:	e486                	sd	ra,72(sp)
     e58:	e0a2                	sd	s0,64(sp)
     e5a:	fc26                	sd	s1,56(sp)
     e5c:	f84a                	sd	s2,48(sp)
     e5e:	f44e                	sd	s3,40(sp)
     e60:	f052                	sd	s4,32(sp)
     e62:	ec56                	sd	s5,24(sp)
     e64:	e85a                	sd	s6,16(sp)
     e66:	e45e                	sd	s7,8(sp)
     e68:	0880                	addi	s0,sp,80
     e6a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     e6c:	00004517          	auipc	a0,0x4
     e70:	b9c50513          	addi	a0,a0,-1124 # 4a08 <malloc+0x220>
     e74:	00003097          	auipc	ra,0x3
     e78:	586080e7          	jalr	1414(ra) # 43fa <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e7c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e80:	00004a97          	auipc	s5,0x4
     e84:	b88a8a93          	addi	s5,s5,-1144 # 4a08 <malloc+0x220>
      int cc = write(fd, buf, sz);
     e88:	00008a17          	auipc	s4,0x8
     e8c:	320a0a13          	addi	s4,s4,800 # 91a8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e90:	6b0d                	lui	s6,0x3
     e92:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirfile+0x2b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e96:	20200593          	li	a1,514
     e9a:	8556                	mv	a0,s5
     e9c:	00003097          	auipc	ra,0x3
     ea0:	54e080e7          	jalr	1358(ra) # 43ea <open>
     ea4:	892a                	mv	s2,a0
    if(fd < 0){
     ea6:	04054d63          	bltz	a0,f00 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     eaa:	8626                	mv	a2,s1
     eac:	85d2                	mv	a1,s4
     eae:	00003097          	auipc	ra,0x3
     eb2:	51c080e7          	jalr	1308(ra) # 43ca <write>
     eb6:	89aa                	mv	s3,a0
      if(cc != sz){
     eb8:	06a49463          	bne	s1,a0,f20 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     ebc:	8626                	mv	a2,s1
     ebe:	85d2                	mv	a1,s4
     ec0:	854a                	mv	a0,s2
     ec2:	00003097          	auipc	ra,0x3
     ec6:	508080e7          	jalr	1288(ra) # 43ca <write>
      if(cc != sz){
     eca:	04951963          	bne	a0,s1,f1c <bigwrite+0xc8>
    close(fd);
     ece:	854a                	mv	a0,s2
     ed0:	00003097          	auipc	ra,0x3
     ed4:	502080e7          	jalr	1282(ra) # 43d2 <close>
    unlink("bigwrite");
     ed8:	8556                	mv	a0,s5
     eda:	00003097          	auipc	ra,0x3
     ede:	520080e7          	jalr	1312(ra) # 43fa <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     ee2:	1d74849b          	addiw	s1,s1,471
     ee6:	fb6498e3          	bne	s1,s6,e96 <bigwrite+0x42>
}
     eea:	60a6                	ld	ra,72(sp)
     eec:	6406                	ld	s0,64(sp)
     eee:	74e2                	ld	s1,56(sp)
     ef0:	7942                	ld	s2,48(sp)
     ef2:	79a2                	ld	s3,40(sp)
     ef4:	7a02                	ld	s4,32(sp)
     ef6:	6ae2                	ld	s5,24(sp)
     ef8:	6b42                	ld	s6,16(sp)
     efa:	6ba2                	ld	s7,8(sp)
     efc:	6161                	addi	sp,sp,80
     efe:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     f00:	85de                	mv	a1,s7
     f02:	00004517          	auipc	a0,0x4
     f06:	27e50513          	addi	a0,a0,638 # 5180 <malloc+0x998>
     f0a:	00004097          	auipc	ra,0x4
     f0e:	820080e7          	jalr	-2016(ra) # 472a <printf>
      exit(1);
     f12:	4505                	li	a0,1
     f14:	00003097          	auipc	ra,0x3
     f18:	496080e7          	jalr	1174(ra) # 43aa <exit>
     f1c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     f1e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     f20:	86ce                	mv	a3,s3
     f22:	8626                	mv	a2,s1
     f24:	85de                	mv	a1,s7
     f26:	00004517          	auipc	a0,0x4
     f2a:	27a50513          	addi	a0,a0,634 # 51a0 <malloc+0x9b8>
     f2e:	00003097          	auipc	ra,0x3
     f32:	7fc080e7          	jalr	2044(ra) # 472a <printf>
        exit(1);
     f36:	4505                	li	a0,1
     f38:	00003097          	auipc	ra,0x3
     f3c:	472080e7          	jalr	1138(ra) # 43aa <exit>

0000000000000f40 <writetest>:
{
     f40:	7139                	addi	sp,sp,-64
     f42:	fc06                	sd	ra,56(sp)
     f44:	f822                	sd	s0,48(sp)
     f46:	f426                	sd	s1,40(sp)
     f48:	f04a                	sd	s2,32(sp)
     f4a:	ec4e                	sd	s3,24(sp)
     f4c:	e852                	sd	s4,16(sp)
     f4e:	e456                	sd	s5,8(sp)
     f50:	e05a                	sd	s6,0(sp)
     f52:	0080                	addi	s0,sp,64
     f54:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     f56:	20200593          	li	a1,514
     f5a:	00004517          	auipc	a0,0x4
     f5e:	25e50513          	addi	a0,a0,606 # 51b8 <malloc+0x9d0>
     f62:	00003097          	auipc	ra,0x3
     f66:	488080e7          	jalr	1160(ra) # 43ea <open>
  if(fd < 0){
     f6a:	0a054d63          	bltz	a0,1024 <writetest+0xe4>
     f6e:	892a                	mv	s2,a0
     f70:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f72:	00004997          	auipc	s3,0x4
     f76:	26e98993          	addi	s3,s3,622 # 51e0 <malloc+0x9f8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f7a:	00004a97          	auipc	s5,0x4
     f7e:	29ea8a93          	addi	s5,s5,670 # 5218 <malloc+0xa30>
  for(i = 0; i < N; i++){
     f82:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f86:	4629                	li	a2,10
     f88:	85ce                	mv	a1,s3
     f8a:	854a                	mv	a0,s2
     f8c:	00003097          	auipc	ra,0x3
     f90:	43e080e7          	jalr	1086(ra) # 43ca <write>
     f94:	47a9                	li	a5,10
     f96:	0af51563          	bne	a0,a5,1040 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f9a:	4629                	li	a2,10
     f9c:	85d6                	mv	a1,s5
     f9e:	854a                	mv	a0,s2
     fa0:	00003097          	auipc	ra,0x3
     fa4:	42a080e7          	jalr	1066(ra) # 43ca <write>
     fa8:	47a9                	li	a5,10
     faa:	0af51963          	bne	a0,a5,105c <writetest+0x11c>
  for(i = 0; i < N; i++){
     fae:	2485                	addiw	s1,s1,1
     fb0:	fd449be3          	bne	s1,s4,f86 <writetest+0x46>
  close(fd);
     fb4:	854a                	mv	a0,s2
     fb6:	00003097          	auipc	ra,0x3
     fba:	41c080e7          	jalr	1052(ra) # 43d2 <close>
  fd = open("small", O_RDONLY);
     fbe:	4581                	li	a1,0
     fc0:	00004517          	auipc	a0,0x4
     fc4:	1f850513          	addi	a0,a0,504 # 51b8 <malloc+0x9d0>
     fc8:	00003097          	auipc	ra,0x3
     fcc:	422080e7          	jalr	1058(ra) # 43ea <open>
     fd0:	84aa                	mv	s1,a0
  if(fd < 0){
     fd2:	0a054363          	bltz	a0,1078 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     fd6:	7d000613          	li	a2,2000
     fda:	00008597          	auipc	a1,0x8
     fde:	1ce58593          	addi	a1,a1,462 # 91a8 <buf>
     fe2:	00003097          	auipc	ra,0x3
     fe6:	3e0080e7          	jalr	992(ra) # 43c2 <read>
  if(i != N*SZ*2){
     fea:	7d000793          	li	a5,2000
     fee:	0af51363          	bne	a0,a5,1094 <writetest+0x154>
  close(fd);
     ff2:	8526                	mv	a0,s1
     ff4:	00003097          	auipc	ra,0x3
     ff8:	3de080e7          	jalr	990(ra) # 43d2 <close>
  if(unlink("small") < 0){
     ffc:	00004517          	auipc	a0,0x4
    1000:	1bc50513          	addi	a0,a0,444 # 51b8 <malloc+0x9d0>
    1004:	00003097          	auipc	ra,0x3
    1008:	3f6080e7          	jalr	1014(ra) # 43fa <unlink>
    100c:	0a054263          	bltz	a0,10b0 <writetest+0x170>
}
    1010:	70e2                	ld	ra,56(sp)
    1012:	7442                	ld	s0,48(sp)
    1014:	74a2                	ld	s1,40(sp)
    1016:	7902                	ld	s2,32(sp)
    1018:	69e2                	ld	s3,24(sp)
    101a:	6a42                	ld	s4,16(sp)
    101c:	6aa2                	ld	s5,8(sp)
    101e:	6b02                	ld	s6,0(sp)
    1020:	6121                	addi	sp,sp,64
    1022:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    1024:	85da                	mv	a1,s6
    1026:	00004517          	auipc	a0,0x4
    102a:	19a50513          	addi	a0,a0,410 # 51c0 <malloc+0x9d8>
    102e:	00003097          	auipc	ra,0x3
    1032:	6fc080e7          	jalr	1788(ra) # 472a <printf>
    exit(1);
    1036:	4505                	li	a0,1
    1038:	00003097          	auipc	ra,0x3
    103c:	372080e7          	jalr	882(ra) # 43aa <exit>
      printf("%s: error: write aa %d new file failed\n", i);
    1040:	85a6                	mv	a1,s1
    1042:	00004517          	auipc	a0,0x4
    1046:	1ae50513          	addi	a0,a0,430 # 51f0 <malloc+0xa08>
    104a:	00003097          	auipc	ra,0x3
    104e:	6e0080e7          	jalr	1760(ra) # 472a <printf>
      exit(1);
    1052:	4505                	li	a0,1
    1054:	00003097          	auipc	ra,0x3
    1058:	356080e7          	jalr	854(ra) # 43aa <exit>
      printf("%s: error: write bb %d new file failed\n", i);
    105c:	85a6                	mv	a1,s1
    105e:	00004517          	auipc	a0,0x4
    1062:	1ca50513          	addi	a0,a0,458 # 5228 <malloc+0xa40>
    1066:	00003097          	auipc	ra,0x3
    106a:	6c4080e7          	jalr	1732(ra) # 472a <printf>
      exit(1);
    106e:	4505                	li	a0,1
    1070:	00003097          	auipc	ra,0x3
    1074:	33a080e7          	jalr	826(ra) # 43aa <exit>
    printf("%s: error: open small failed!\n", s);
    1078:	85da                	mv	a1,s6
    107a:	00004517          	auipc	a0,0x4
    107e:	1d650513          	addi	a0,a0,470 # 5250 <malloc+0xa68>
    1082:	00003097          	auipc	ra,0x3
    1086:	6a8080e7          	jalr	1704(ra) # 472a <printf>
    exit(1);
    108a:	4505                	li	a0,1
    108c:	00003097          	auipc	ra,0x3
    1090:	31e080e7          	jalr	798(ra) # 43aa <exit>
    printf("%s: read failed\n", s);
    1094:	85da                	mv	a1,s6
    1096:	00004517          	auipc	a0,0x4
    109a:	1da50513          	addi	a0,a0,474 # 5270 <malloc+0xa88>
    109e:	00003097          	auipc	ra,0x3
    10a2:	68c080e7          	jalr	1676(ra) # 472a <printf>
    exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00003097          	auipc	ra,0x3
    10ac:	302080e7          	jalr	770(ra) # 43aa <exit>
    printf("%s: unlink small failed\n", s);
    10b0:	85da                	mv	a1,s6
    10b2:	00004517          	auipc	a0,0x4
    10b6:	1d650513          	addi	a0,a0,470 # 5288 <malloc+0xaa0>
    10ba:	00003097          	auipc	ra,0x3
    10be:	670080e7          	jalr	1648(ra) # 472a <printf>
    exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00003097          	auipc	ra,0x3
    10c8:	2e6080e7          	jalr	742(ra) # 43aa <exit>

00000000000010cc <writebig>:
{
    10cc:	7139                	addi	sp,sp,-64
    10ce:	fc06                	sd	ra,56(sp)
    10d0:	f822                	sd	s0,48(sp)
    10d2:	f426                	sd	s1,40(sp)
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	ec4e                	sd	s3,24(sp)
    10d8:	e852                	sd	s4,16(sp)
    10da:	e456                	sd	s5,8(sp)
    10dc:	0080                	addi	s0,sp,64
    10de:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    10e0:	20200593          	li	a1,514
    10e4:	00004517          	auipc	a0,0x4
    10e8:	1c450513          	addi	a0,a0,452 # 52a8 <malloc+0xac0>
    10ec:	00003097          	auipc	ra,0x3
    10f0:	2fe080e7          	jalr	766(ra) # 43ea <open>
    10f4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    10f6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    10f8:	00008917          	auipc	s2,0x8
    10fc:	0b090913          	addi	s2,s2,176 # 91a8 <buf>
  for(i = 0; i < MAXFILE; i++){
    1100:	10c00a13          	li	s4,268
  if(fd < 0){
    1104:	06054c63          	bltz	a0,117c <writebig+0xb0>
    ((int*)buf)[0] = i;
    1108:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    110c:	40000613          	li	a2,1024
    1110:	85ca                	mv	a1,s2
    1112:	854e                	mv	a0,s3
    1114:	00003097          	auipc	ra,0x3
    1118:	2b6080e7          	jalr	694(ra) # 43ca <write>
    111c:	40000793          	li	a5,1024
    1120:	06f51c63          	bne	a0,a5,1198 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    1124:	2485                	addiw	s1,s1,1
    1126:	ff4491e3          	bne	s1,s4,1108 <writebig+0x3c>
  close(fd);
    112a:	854e                	mv	a0,s3
    112c:	00003097          	auipc	ra,0x3
    1130:	2a6080e7          	jalr	678(ra) # 43d2 <close>
  fd = open("big", O_RDONLY);
    1134:	4581                	li	a1,0
    1136:	00004517          	auipc	a0,0x4
    113a:	17250513          	addi	a0,a0,370 # 52a8 <malloc+0xac0>
    113e:	00003097          	auipc	ra,0x3
    1142:	2ac080e7          	jalr	684(ra) # 43ea <open>
    1146:	89aa                	mv	s3,a0
  n = 0;
    1148:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    114a:	00008917          	auipc	s2,0x8
    114e:	05e90913          	addi	s2,s2,94 # 91a8 <buf>
  if(fd < 0){
    1152:	06054163          	bltz	a0,11b4 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
    1156:	40000613          	li	a2,1024
    115a:	85ca                	mv	a1,s2
    115c:	854e                	mv	a0,s3
    115e:	00003097          	auipc	ra,0x3
    1162:	264080e7          	jalr	612(ra) # 43c2 <read>
    if(i == 0){
    1166:	c52d                	beqz	a0,11d0 <writebig+0x104>
    } else if(i != BSIZE){
    1168:	40000793          	li	a5,1024
    116c:	0af51d63          	bne	a0,a5,1226 <writebig+0x15a>
    if(((int*)buf)[0] != n){
    1170:	00092603          	lw	a2,0(s2)
    1174:	0c961763          	bne	a2,s1,1242 <writebig+0x176>
    n++;
    1178:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    117a:	bff1                	j	1156 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    117c:	85d6                	mv	a1,s5
    117e:	00004517          	auipc	a0,0x4
    1182:	13250513          	addi	a0,a0,306 # 52b0 <malloc+0xac8>
    1186:	00003097          	auipc	ra,0x3
    118a:	5a4080e7          	jalr	1444(ra) # 472a <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	00003097          	auipc	ra,0x3
    1194:	21a080e7          	jalr	538(ra) # 43aa <exit>
      printf("%s: error: write big file failed\n", i);
    1198:	85a6                	mv	a1,s1
    119a:	00004517          	auipc	a0,0x4
    119e:	13650513          	addi	a0,a0,310 # 52d0 <malloc+0xae8>
    11a2:	00003097          	auipc	ra,0x3
    11a6:	588080e7          	jalr	1416(ra) # 472a <printf>
      exit(1);
    11aa:	4505                	li	a0,1
    11ac:	00003097          	auipc	ra,0x3
    11b0:	1fe080e7          	jalr	510(ra) # 43aa <exit>
    printf("%s: error: open big failed!\n", s);
    11b4:	85d6                	mv	a1,s5
    11b6:	00004517          	auipc	a0,0x4
    11ba:	14250513          	addi	a0,a0,322 # 52f8 <malloc+0xb10>
    11be:	00003097          	auipc	ra,0x3
    11c2:	56c080e7          	jalr	1388(ra) # 472a <printf>
    exit(1);
    11c6:	4505                	li	a0,1
    11c8:	00003097          	auipc	ra,0x3
    11cc:	1e2080e7          	jalr	482(ra) # 43aa <exit>
      if(n == MAXFILE - 1){
    11d0:	10b00793          	li	a5,267
    11d4:	02f48a63          	beq	s1,a5,1208 <writebig+0x13c>
  close(fd);
    11d8:	854e                	mv	a0,s3
    11da:	00003097          	auipc	ra,0x3
    11de:	1f8080e7          	jalr	504(ra) # 43d2 <close>
  if(unlink("big") < 0){
    11e2:	00004517          	auipc	a0,0x4
    11e6:	0c650513          	addi	a0,a0,198 # 52a8 <malloc+0xac0>
    11ea:	00003097          	auipc	ra,0x3
    11ee:	210080e7          	jalr	528(ra) # 43fa <unlink>
    11f2:	06054663          	bltz	a0,125e <writebig+0x192>
}
    11f6:	70e2                	ld	ra,56(sp)
    11f8:	7442                	ld	s0,48(sp)
    11fa:	74a2                	ld	s1,40(sp)
    11fc:	7902                	ld	s2,32(sp)
    11fe:	69e2                	ld	s3,24(sp)
    1200:	6a42                	ld	s4,16(sp)
    1202:	6aa2                	ld	s5,8(sp)
    1204:	6121                	addi	sp,sp,64
    1206:	8082                	ret
        printf("%s: read only %d blocks from big", n);
    1208:	10b00593          	li	a1,267
    120c:	00004517          	auipc	a0,0x4
    1210:	10c50513          	addi	a0,a0,268 # 5318 <malloc+0xb30>
    1214:	00003097          	auipc	ra,0x3
    1218:	516080e7          	jalr	1302(ra) # 472a <printf>
        exit(1);
    121c:	4505                	li	a0,1
    121e:	00003097          	auipc	ra,0x3
    1222:	18c080e7          	jalr	396(ra) # 43aa <exit>
      printf("%s: read failed %d\n", i);
    1226:	85aa                	mv	a1,a0
    1228:	00004517          	auipc	a0,0x4
    122c:	11850513          	addi	a0,a0,280 # 5340 <malloc+0xb58>
    1230:	00003097          	auipc	ra,0x3
    1234:	4fa080e7          	jalr	1274(ra) # 472a <printf>
      exit(1);
    1238:	4505                	li	a0,1
    123a:	00003097          	auipc	ra,0x3
    123e:	170080e7          	jalr	368(ra) # 43aa <exit>
      printf("%s: read content of block %d is %d\n",
    1242:	85a6                	mv	a1,s1
    1244:	00004517          	auipc	a0,0x4
    1248:	11450513          	addi	a0,a0,276 # 5358 <malloc+0xb70>
    124c:	00003097          	auipc	ra,0x3
    1250:	4de080e7          	jalr	1246(ra) # 472a <printf>
      exit(1);
    1254:	4505                	li	a0,1
    1256:	00003097          	auipc	ra,0x3
    125a:	154080e7          	jalr	340(ra) # 43aa <exit>
    printf("%s: unlink big failed\n", s);
    125e:	85d6                	mv	a1,s5
    1260:	00004517          	auipc	a0,0x4
    1264:	12050513          	addi	a0,a0,288 # 5380 <malloc+0xb98>
    1268:	00003097          	auipc	ra,0x3
    126c:	4c2080e7          	jalr	1218(ra) # 472a <printf>
    exit(1);
    1270:	4505                	li	a0,1
    1272:	00003097          	auipc	ra,0x3
    1276:	138080e7          	jalr	312(ra) # 43aa <exit>

000000000000127a <unlinkread>:
{
    127a:	7179                	addi	sp,sp,-48
    127c:	f406                	sd	ra,40(sp)
    127e:	f022                	sd	s0,32(sp)
    1280:	ec26                	sd	s1,24(sp)
    1282:	e84a                	sd	s2,16(sp)
    1284:	e44e                	sd	s3,8(sp)
    1286:	1800                	addi	s0,sp,48
    1288:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    128a:	20200593          	li	a1,514
    128e:	00003517          	auipc	a0,0x3
    1292:	71250513          	addi	a0,a0,1810 # 49a0 <malloc+0x1b8>
    1296:	00003097          	auipc	ra,0x3
    129a:	154080e7          	jalr	340(ra) # 43ea <open>
  if(fd < 0){
    129e:	0e054563          	bltz	a0,1388 <unlinkread+0x10e>
    12a2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    12a4:	4615                	li	a2,5
    12a6:	00004597          	auipc	a1,0x4
    12aa:	11258593          	addi	a1,a1,274 # 53b8 <malloc+0xbd0>
    12ae:	00003097          	auipc	ra,0x3
    12b2:	11c080e7          	jalr	284(ra) # 43ca <write>
  close(fd);
    12b6:	8526                	mv	a0,s1
    12b8:	00003097          	auipc	ra,0x3
    12bc:	11a080e7          	jalr	282(ra) # 43d2 <close>
  fd = open("unlinkread", O_RDWR);
    12c0:	4589                	li	a1,2
    12c2:	00003517          	auipc	a0,0x3
    12c6:	6de50513          	addi	a0,a0,1758 # 49a0 <malloc+0x1b8>
    12ca:	00003097          	auipc	ra,0x3
    12ce:	120080e7          	jalr	288(ra) # 43ea <open>
    12d2:	84aa                	mv	s1,a0
  if(fd < 0){
    12d4:	0c054863          	bltz	a0,13a4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    12d8:	00003517          	auipc	a0,0x3
    12dc:	6c850513          	addi	a0,a0,1736 # 49a0 <malloc+0x1b8>
    12e0:	00003097          	auipc	ra,0x3
    12e4:	11a080e7          	jalr	282(ra) # 43fa <unlink>
    12e8:	ed61                	bnez	a0,13c0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12ea:	20200593          	li	a1,514
    12ee:	00003517          	auipc	a0,0x3
    12f2:	6b250513          	addi	a0,a0,1714 # 49a0 <malloc+0x1b8>
    12f6:	00003097          	auipc	ra,0x3
    12fa:	0f4080e7          	jalr	244(ra) # 43ea <open>
    12fe:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1300:	460d                	li	a2,3
    1302:	00004597          	auipc	a1,0x4
    1306:	0fe58593          	addi	a1,a1,254 # 5400 <malloc+0xc18>
    130a:	00003097          	auipc	ra,0x3
    130e:	0c0080e7          	jalr	192(ra) # 43ca <write>
  close(fd1);
    1312:	854a                	mv	a0,s2
    1314:	00003097          	auipc	ra,0x3
    1318:	0be080e7          	jalr	190(ra) # 43d2 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    131c:	660d                	lui	a2,0x3
    131e:	00008597          	auipc	a1,0x8
    1322:	e8a58593          	addi	a1,a1,-374 # 91a8 <buf>
    1326:	8526                	mv	a0,s1
    1328:	00003097          	auipc	ra,0x3
    132c:	09a080e7          	jalr	154(ra) # 43c2 <read>
    1330:	4795                	li	a5,5
    1332:	0af51563          	bne	a0,a5,13dc <unlinkread+0x162>
  if(buf[0] != 'h'){
    1336:	00008717          	auipc	a4,0x8
    133a:	e7274703          	lbu	a4,-398(a4) # 91a8 <buf>
    133e:	06800793          	li	a5,104
    1342:	0af71b63          	bne	a4,a5,13f8 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    1346:	4629                	li	a2,10
    1348:	00008597          	auipc	a1,0x8
    134c:	e6058593          	addi	a1,a1,-416 # 91a8 <buf>
    1350:	8526                	mv	a0,s1
    1352:	00003097          	auipc	ra,0x3
    1356:	078080e7          	jalr	120(ra) # 43ca <write>
    135a:	47a9                	li	a5,10
    135c:	0af51c63          	bne	a0,a5,1414 <unlinkread+0x19a>
  close(fd);
    1360:	8526                	mv	a0,s1
    1362:	00003097          	auipc	ra,0x3
    1366:	070080e7          	jalr	112(ra) # 43d2 <close>
  unlink("unlinkread");
    136a:	00003517          	auipc	a0,0x3
    136e:	63650513          	addi	a0,a0,1590 # 49a0 <malloc+0x1b8>
    1372:	00003097          	auipc	ra,0x3
    1376:	088080e7          	jalr	136(ra) # 43fa <unlink>
}
    137a:	70a2                	ld	ra,40(sp)
    137c:	7402                	ld	s0,32(sp)
    137e:	64e2                	ld	s1,24(sp)
    1380:	6942                	ld	s2,16(sp)
    1382:	69a2                	ld	s3,8(sp)
    1384:	6145                	addi	sp,sp,48
    1386:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    1388:	85ce                	mv	a1,s3
    138a:	00004517          	auipc	a0,0x4
    138e:	00e50513          	addi	a0,a0,14 # 5398 <malloc+0xbb0>
    1392:	00003097          	auipc	ra,0x3
    1396:	398080e7          	jalr	920(ra) # 472a <printf>
    exit(1);
    139a:	4505                	li	a0,1
    139c:	00003097          	auipc	ra,0x3
    13a0:	00e080e7          	jalr	14(ra) # 43aa <exit>
    printf("%s: open unlinkread failed\n", s);
    13a4:	85ce                	mv	a1,s3
    13a6:	00004517          	auipc	a0,0x4
    13aa:	01a50513          	addi	a0,a0,26 # 53c0 <malloc+0xbd8>
    13ae:	00003097          	auipc	ra,0x3
    13b2:	37c080e7          	jalr	892(ra) # 472a <printf>
    exit(1);
    13b6:	4505                	li	a0,1
    13b8:	00003097          	auipc	ra,0x3
    13bc:	ff2080e7          	jalr	-14(ra) # 43aa <exit>
    printf("%s: unlink unlinkread failed\n", s);
    13c0:	85ce                	mv	a1,s3
    13c2:	00004517          	auipc	a0,0x4
    13c6:	01e50513          	addi	a0,a0,30 # 53e0 <malloc+0xbf8>
    13ca:	00003097          	auipc	ra,0x3
    13ce:	360080e7          	jalr	864(ra) # 472a <printf>
    exit(1);
    13d2:	4505                	li	a0,1
    13d4:	00003097          	auipc	ra,0x3
    13d8:	fd6080e7          	jalr	-42(ra) # 43aa <exit>
    printf("%s: unlinkread read failed", s);
    13dc:	85ce                	mv	a1,s3
    13de:	00004517          	auipc	a0,0x4
    13e2:	02a50513          	addi	a0,a0,42 # 5408 <malloc+0xc20>
    13e6:	00003097          	auipc	ra,0x3
    13ea:	344080e7          	jalr	836(ra) # 472a <printf>
    exit(1);
    13ee:	4505                	li	a0,1
    13f0:	00003097          	auipc	ra,0x3
    13f4:	fba080e7          	jalr	-70(ra) # 43aa <exit>
    printf("%s: unlinkread wrong data\n", s);
    13f8:	85ce                	mv	a1,s3
    13fa:	00004517          	auipc	a0,0x4
    13fe:	02e50513          	addi	a0,a0,46 # 5428 <malloc+0xc40>
    1402:	00003097          	auipc	ra,0x3
    1406:	328080e7          	jalr	808(ra) # 472a <printf>
    exit(1);
    140a:	4505                	li	a0,1
    140c:	00003097          	auipc	ra,0x3
    1410:	f9e080e7          	jalr	-98(ra) # 43aa <exit>
    printf("%s: unlinkread write failed\n", s);
    1414:	85ce                	mv	a1,s3
    1416:	00004517          	auipc	a0,0x4
    141a:	03250513          	addi	a0,a0,50 # 5448 <malloc+0xc60>
    141e:	00003097          	auipc	ra,0x3
    1422:	30c080e7          	jalr	780(ra) # 472a <printf>
    exit(1);
    1426:	4505                	li	a0,1
    1428:	00003097          	auipc	ra,0x3
    142c:	f82080e7          	jalr	-126(ra) # 43aa <exit>

0000000000001430 <exectest>:
{
    1430:	715d                	addi	sp,sp,-80
    1432:	e486                	sd	ra,72(sp)
    1434:	e0a2                	sd	s0,64(sp)
    1436:	fc26                	sd	s1,56(sp)
    1438:	f84a                	sd	s2,48(sp)
    143a:	0880                	addi	s0,sp,80
    143c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    143e:	00004797          	auipc	a5,0x4
    1442:	a5a78793          	addi	a5,a5,-1446 # 4e98 <malloc+0x6b0>
    1446:	fcf43023          	sd	a5,-64(s0)
    144a:	00004797          	auipc	a5,0x4
    144e:	01e78793          	addi	a5,a5,30 # 5468 <malloc+0xc80>
    1452:	fcf43423          	sd	a5,-56(s0)
    1456:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    145a:	00004517          	auipc	a0,0x4
    145e:	01650513          	addi	a0,a0,22 # 5470 <malloc+0xc88>
    1462:	00003097          	auipc	ra,0x3
    1466:	f98080e7          	jalr	-104(ra) # 43fa <unlink>
  pid = fork();
    146a:	00003097          	auipc	ra,0x3
    146e:	f38080e7          	jalr	-200(ra) # 43a2 <fork>
  if(pid < 0) {
    1472:	04054663          	bltz	a0,14be <exectest+0x8e>
    1476:	84aa                	mv	s1,a0
  if(pid == 0) {
    1478:	e959                	bnez	a0,150e <exectest+0xde>
    close(1);
    147a:	4505                	li	a0,1
    147c:	00003097          	auipc	ra,0x3
    1480:	f56080e7          	jalr	-170(ra) # 43d2 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1484:	20100593          	li	a1,513
    1488:	00004517          	auipc	a0,0x4
    148c:	fe850513          	addi	a0,a0,-24 # 5470 <malloc+0xc88>
    1490:	00003097          	auipc	ra,0x3
    1494:	f5a080e7          	jalr	-166(ra) # 43ea <open>
    if(fd < 0) {
    1498:	04054163          	bltz	a0,14da <exectest+0xaa>
    if(fd != 1) {
    149c:	4785                	li	a5,1
    149e:	04f50c63          	beq	a0,a5,14f6 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    14a2:	85ca                	mv	a1,s2
    14a4:	00004517          	auipc	a0,0x4
    14a8:	fd450513          	addi	a0,a0,-44 # 5478 <malloc+0xc90>
    14ac:	00003097          	auipc	ra,0x3
    14b0:	27e080e7          	jalr	638(ra) # 472a <printf>
      exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00003097          	auipc	ra,0x3
    14ba:	ef4080e7          	jalr	-268(ra) # 43aa <exit>
     printf("%s: fork failed\n", s);
    14be:	85ca                	mv	a1,s2
    14c0:	00004517          	auipc	a0,0x4
    14c4:	82850513          	addi	a0,a0,-2008 # 4ce8 <malloc+0x500>
    14c8:	00003097          	auipc	ra,0x3
    14cc:	262080e7          	jalr	610(ra) # 472a <printf>
     exit(1);
    14d0:	4505                	li	a0,1
    14d2:	00003097          	auipc	ra,0x3
    14d6:	ed8080e7          	jalr	-296(ra) # 43aa <exit>
      printf("%s: create failed\n", s);
    14da:	85ca                	mv	a1,s2
    14dc:	00004517          	auipc	a0,0x4
    14e0:	a2450513          	addi	a0,a0,-1500 # 4f00 <malloc+0x718>
    14e4:	00003097          	auipc	ra,0x3
    14e8:	246080e7          	jalr	582(ra) # 472a <printf>
      exit(1);
    14ec:	4505                	li	a0,1
    14ee:	00003097          	auipc	ra,0x3
    14f2:	ebc080e7          	jalr	-324(ra) # 43aa <exit>
    if(exec("echo", echoargv) < 0){
    14f6:	fc040593          	addi	a1,s0,-64
    14fa:	00004517          	auipc	a0,0x4
    14fe:	99e50513          	addi	a0,a0,-1634 # 4e98 <malloc+0x6b0>
    1502:	00003097          	auipc	ra,0x3
    1506:	ee0080e7          	jalr	-288(ra) # 43e2 <exec>
    150a:	02054163          	bltz	a0,152c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    150e:	fdc40513          	addi	a0,s0,-36
    1512:	00003097          	auipc	ra,0x3
    1516:	ea0080e7          	jalr	-352(ra) # 43b2 <wait>
    151a:	02951763          	bne	a0,s1,1548 <exectest+0x118>
  if(xstatus != 0)
    151e:	fdc42503          	lw	a0,-36(s0)
    1522:	cd0d                	beqz	a0,155c <exectest+0x12c>
    exit(xstatus);
    1524:	00003097          	auipc	ra,0x3
    1528:	e86080e7          	jalr	-378(ra) # 43aa <exit>
      printf("%s: exec echo failed\n", s);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	f5a50513          	addi	a0,a0,-166 # 5488 <malloc+0xca0>
    1536:	00003097          	auipc	ra,0x3
    153a:	1f4080e7          	jalr	500(ra) # 472a <printf>
      exit(1);
    153e:	4505                	li	a0,1
    1540:	00003097          	auipc	ra,0x3
    1544:	e6a080e7          	jalr	-406(ra) # 43aa <exit>
    printf("%s: wait failed!\n", s);
    1548:	85ca                	mv	a1,s2
    154a:	00004517          	auipc	a0,0x4
    154e:	f5650513          	addi	a0,a0,-170 # 54a0 <malloc+0xcb8>
    1552:	00003097          	auipc	ra,0x3
    1556:	1d8080e7          	jalr	472(ra) # 472a <printf>
    155a:	b7d1                	j	151e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    155c:	4581                	li	a1,0
    155e:	00004517          	auipc	a0,0x4
    1562:	f1250513          	addi	a0,a0,-238 # 5470 <malloc+0xc88>
    1566:	00003097          	auipc	ra,0x3
    156a:	e84080e7          	jalr	-380(ra) # 43ea <open>
  if(fd < 0) {
    156e:	02054a63          	bltz	a0,15a2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1572:	4609                	li	a2,2
    1574:	fb840593          	addi	a1,s0,-72
    1578:	00003097          	auipc	ra,0x3
    157c:	e4a080e7          	jalr	-438(ra) # 43c2 <read>
    1580:	4789                	li	a5,2
    1582:	02f50e63          	beq	a0,a5,15be <exectest+0x18e>
    printf("%s: read failed\n", s);
    1586:	85ca                	mv	a1,s2
    1588:	00004517          	auipc	a0,0x4
    158c:	ce850513          	addi	a0,a0,-792 # 5270 <malloc+0xa88>
    1590:	00003097          	auipc	ra,0x3
    1594:	19a080e7          	jalr	410(ra) # 472a <printf>
    exit(1);
    1598:	4505                	li	a0,1
    159a:	00003097          	auipc	ra,0x3
    159e:	e10080e7          	jalr	-496(ra) # 43aa <exit>
    printf("%s: open failed\n", s);
    15a2:	85ca                	mv	a1,s2
    15a4:	00004517          	auipc	a0,0x4
    15a8:	f1450513          	addi	a0,a0,-236 # 54b8 <malloc+0xcd0>
    15ac:	00003097          	auipc	ra,0x3
    15b0:	17e080e7          	jalr	382(ra) # 472a <printf>
    exit(1);
    15b4:	4505                	li	a0,1
    15b6:	00003097          	auipc	ra,0x3
    15ba:	df4080e7          	jalr	-524(ra) # 43aa <exit>
  unlink("echo-ok");
    15be:	00004517          	auipc	a0,0x4
    15c2:	eb250513          	addi	a0,a0,-334 # 5470 <malloc+0xc88>
    15c6:	00003097          	auipc	ra,0x3
    15ca:	e34080e7          	jalr	-460(ra) # 43fa <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    15ce:	fb844703          	lbu	a4,-72(s0)
    15d2:	04f00793          	li	a5,79
    15d6:	00f71863          	bne	a4,a5,15e6 <exectest+0x1b6>
    15da:	fb944703          	lbu	a4,-71(s0)
    15de:	04b00793          	li	a5,75
    15e2:	02f70063          	beq	a4,a5,1602 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    15e6:	85ca                	mv	a1,s2
    15e8:	00004517          	auipc	a0,0x4
    15ec:	ee850513          	addi	a0,a0,-280 # 54d0 <malloc+0xce8>
    15f0:	00003097          	auipc	ra,0x3
    15f4:	13a080e7          	jalr	314(ra) # 472a <printf>
    exit(1);
    15f8:	4505                	li	a0,1
    15fa:	00003097          	auipc	ra,0x3
    15fe:	db0080e7          	jalr	-592(ra) # 43aa <exit>
    exit(0);
    1602:	4501                	li	a0,0
    1604:	00003097          	auipc	ra,0x3
    1608:	da6080e7          	jalr	-602(ra) # 43aa <exit>

000000000000160c <bigargtest>:
{
    160c:	7179                	addi	sp,sp,-48
    160e:	f406                	sd	ra,40(sp)
    1610:	f022                	sd	s0,32(sp)
    1612:	ec26                	sd	s1,24(sp)
    1614:	1800                	addi	s0,sp,48
    1616:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    1618:	00004517          	auipc	a0,0x4
    161c:	ed050513          	addi	a0,a0,-304 # 54e8 <malloc+0xd00>
    1620:	00003097          	auipc	ra,0x3
    1624:	dda080e7          	jalr	-550(ra) # 43fa <unlink>
  pid = fork();
    1628:	00003097          	auipc	ra,0x3
    162c:	d7a080e7          	jalr	-646(ra) # 43a2 <fork>
  if(pid == 0){
    1630:	c121                	beqz	a0,1670 <bigargtest+0x64>
  } else if(pid < 0){
    1632:	0a054063          	bltz	a0,16d2 <bigargtest+0xc6>
  wait(&xstatus);
    1636:	fdc40513          	addi	a0,s0,-36
    163a:	00003097          	auipc	ra,0x3
    163e:	d78080e7          	jalr	-648(ra) # 43b2 <wait>
  if(xstatus != 0)
    1642:	fdc42503          	lw	a0,-36(s0)
    1646:	e545                	bnez	a0,16ee <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    1648:	4581                	li	a1,0
    164a:	00004517          	auipc	a0,0x4
    164e:	e9e50513          	addi	a0,a0,-354 # 54e8 <malloc+0xd00>
    1652:	00003097          	auipc	ra,0x3
    1656:	d98080e7          	jalr	-616(ra) # 43ea <open>
  if(fd < 0){
    165a:	08054e63          	bltz	a0,16f6 <bigargtest+0xea>
  close(fd);
    165e:	00003097          	auipc	ra,0x3
    1662:	d74080e7          	jalr	-652(ra) # 43d2 <close>
}
    1666:	70a2                	ld	ra,40(sp)
    1668:	7402                	ld	s0,32(sp)
    166a:	64e2                	ld	s1,24(sp)
    166c:	6145                	addi	sp,sp,48
    166e:	8082                	ret
    1670:	00005797          	auipc	a5,0x5
    1674:	32878793          	addi	a5,a5,808 # 6998 <args.1692>
    1678:	00005697          	auipc	a3,0x5
    167c:	41868693          	addi	a3,a3,1048 # 6a90 <args.1692+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1680:	00004717          	auipc	a4,0x4
    1684:	e7870713          	addi	a4,a4,-392 # 54f8 <malloc+0xd10>
    1688:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    168a:	07a1                	addi	a5,a5,8
    168c:	fed79ee3          	bne	a5,a3,1688 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    1690:	00005597          	auipc	a1,0x5
    1694:	30858593          	addi	a1,a1,776 # 6998 <args.1692>
    1698:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    169c:	00003517          	auipc	a0,0x3
    16a0:	7fc50513          	addi	a0,a0,2044 # 4e98 <malloc+0x6b0>
    16a4:	00003097          	auipc	ra,0x3
    16a8:	d3e080e7          	jalr	-706(ra) # 43e2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    16ac:	20000593          	li	a1,512
    16b0:	00004517          	auipc	a0,0x4
    16b4:	e3850513          	addi	a0,a0,-456 # 54e8 <malloc+0xd00>
    16b8:	00003097          	auipc	ra,0x3
    16bc:	d32080e7          	jalr	-718(ra) # 43ea <open>
    close(fd);
    16c0:	00003097          	auipc	ra,0x3
    16c4:	d12080e7          	jalr	-750(ra) # 43d2 <close>
    exit(0);
    16c8:	4501                	li	a0,0
    16ca:	00003097          	auipc	ra,0x3
    16ce:	ce0080e7          	jalr	-800(ra) # 43aa <exit>
    printf("%s: bigargtest: fork failed\n", s);
    16d2:	85a6                	mv	a1,s1
    16d4:	00004517          	auipc	a0,0x4
    16d8:	f0450513          	addi	a0,a0,-252 # 55d8 <malloc+0xdf0>
    16dc:	00003097          	auipc	ra,0x3
    16e0:	04e080e7          	jalr	78(ra) # 472a <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00003097          	auipc	ra,0x3
    16ea:	cc4080e7          	jalr	-828(ra) # 43aa <exit>
    exit(xstatus);
    16ee:	00003097          	auipc	ra,0x3
    16f2:	cbc080e7          	jalr	-836(ra) # 43aa <exit>
    printf("%s: bigarg test failed!\n", s);
    16f6:	85a6                	mv	a1,s1
    16f8:	00004517          	auipc	a0,0x4
    16fc:	f0050513          	addi	a0,a0,-256 # 55f8 <malloc+0xe10>
    1700:	00003097          	auipc	ra,0x3
    1704:	02a080e7          	jalr	42(ra) # 472a <printf>
    exit(1);
    1708:	4505                	li	a0,1
    170a:	00003097          	auipc	ra,0x3
    170e:	ca0080e7          	jalr	-864(ra) # 43aa <exit>

0000000000001712 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1712:	7139                	addi	sp,sp,-64
    1714:	fc06                	sd	ra,56(sp)
    1716:	f822                	sd	s0,48(sp)
    1718:	f426                	sd	s1,40(sp)
    171a:	f04a                	sd	s2,32(sp)
    171c:	ec4e                	sd	s3,24(sp)
    171e:	0080                	addi	s0,sp,64
    1720:	64b1                	lui	s1,0xc
    1722:	35048493          	addi	s1,s1,848 # c350 <__BSS_END__+0x198>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1726:	597d                	li	s2,-1
    1728:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    172c:	00003997          	auipc	s3,0x3
    1730:	76c98993          	addi	s3,s3,1900 # 4e98 <malloc+0x6b0>
    argv[0] = (char*)0xffffffff;
    1734:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1738:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    173c:	fc040593          	addi	a1,s0,-64
    1740:	854e                	mv	a0,s3
    1742:	00003097          	auipc	ra,0x3
    1746:	ca0080e7          	jalr	-864(ra) # 43e2 <exec>
  for(int i = 0; i < 50000; i++){
    174a:	34fd                	addiw	s1,s1,-1
    174c:	f4e5                	bnez	s1,1734 <badarg+0x22>
  }
  
  exit(0);
    174e:	4501                	li	a0,0
    1750:	00003097          	auipc	ra,0x3
    1754:	c5a080e7          	jalr	-934(ra) # 43aa <exit>

0000000000001758 <pipe1>:
{
    1758:	711d                	addi	sp,sp,-96
    175a:	ec86                	sd	ra,88(sp)
    175c:	e8a2                	sd	s0,80(sp)
    175e:	e4a6                	sd	s1,72(sp)
    1760:	e0ca                	sd	s2,64(sp)
    1762:	fc4e                	sd	s3,56(sp)
    1764:	f852                	sd	s4,48(sp)
    1766:	f456                	sd	s5,40(sp)
    1768:	f05a                	sd	s6,32(sp)
    176a:	ec5e                	sd	s7,24(sp)
    176c:	1080                	addi	s0,sp,96
    176e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1770:	fa840513          	addi	a0,s0,-88
    1774:	00003097          	auipc	ra,0x3
    1778:	c46080e7          	jalr	-954(ra) # 43ba <pipe>
    177c:	ed25                	bnez	a0,17f4 <pipe1+0x9c>
    177e:	84aa                	mv	s1,a0
  pid = fork();
    1780:	00003097          	auipc	ra,0x3
    1784:	c22080e7          	jalr	-990(ra) # 43a2 <fork>
    1788:	8a2a                	mv	s4,a0
  if(pid == 0){
    178a:	c159                	beqz	a0,1810 <pipe1+0xb8>
  } else if(pid > 0){
    178c:	16a05e63          	blez	a0,1908 <pipe1+0x1b0>
    close(fds[1]);
    1790:	fac42503          	lw	a0,-84(s0)
    1794:	00003097          	auipc	ra,0x3
    1798:	c3e080e7          	jalr	-962(ra) # 43d2 <close>
    total = 0;
    179c:	8a26                	mv	s4,s1
    cc = 1;
    179e:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    17a0:	00008a97          	auipc	s5,0x8
    17a4:	a08a8a93          	addi	s5,s5,-1528 # 91a8 <buf>
      if(cc > sizeof(buf))
    17a8:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17aa:	864e                	mv	a2,s3
    17ac:	85d6                	mv	a1,s5
    17ae:	fa842503          	lw	a0,-88(s0)
    17b2:	00003097          	auipc	ra,0x3
    17b6:	c10080e7          	jalr	-1008(ra) # 43c2 <read>
    17ba:	10a05263          	blez	a0,18be <pipe1+0x166>
      for(i = 0; i < n; i++){
    17be:	00008717          	auipc	a4,0x8
    17c2:	9ea70713          	addi	a4,a4,-1558 # 91a8 <buf>
    17c6:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ca:	00074683          	lbu	a3,0(a4)
    17ce:	0ff4f793          	andi	a5,s1,255
    17d2:	2485                	addiw	s1,s1,1
    17d4:	0cf69163          	bne	a3,a5,1896 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17d8:	0705                	addi	a4,a4,1
    17da:	fec498e3          	bne	s1,a2,17ca <pipe1+0x72>
      total += n;
    17de:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17e2:	0019979b          	slliw	a5,s3,0x1
    17e6:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ea:	013b7363          	bgeu	s6,s3,17f0 <pipe1+0x98>
        cc = sizeof(buf);
    17ee:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17f0:	84b2                	mv	s1,a2
    17f2:	bf65                	j	17aa <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17f4:	85ca                	mv	a1,s2
    17f6:	00004517          	auipc	a0,0x4
    17fa:	e2250513          	addi	a0,a0,-478 # 5618 <malloc+0xe30>
    17fe:	00003097          	auipc	ra,0x3
    1802:	f2c080e7          	jalr	-212(ra) # 472a <printf>
    exit(1);
    1806:	4505                	li	a0,1
    1808:	00003097          	auipc	ra,0x3
    180c:	ba2080e7          	jalr	-1118(ra) # 43aa <exit>
    close(fds[0]);
    1810:	fa842503          	lw	a0,-88(s0)
    1814:	00003097          	auipc	ra,0x3
    1818:	bbe080e7          	jalr	-1090(ra) # 43d2 <close>
    for(n = 0; n < N; n++){
    181c:	00008b17          	auipc	s6,0x8
    1820:	98cb0b13          	addi	s6,s6,-1652 # 91a8 <buf>
    1824:	416004bb          	negw	s1,s6
    1828:	0ff4f493          	andi	s1,s1,255
    182c:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1830:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1832:	6a85                	lui	s5,0x1
    1834:	42da8a93          	addi	s5,s5,1069 # 142d <unlinkread+0x1b3>
{
    1838:	87da                	mv	a5,s6
        buf[i] = seq++;
    183a:	0097873b          	addw	a4,a5,s1
    183e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1842:	0785                	addi	a5,a5,1
    1844:	fef99be3          	bne	s3,a5,183a <pipe1+0xe2>
    1848:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    184c:	40900613          	li	a2,1033
    1850:	85de                	mv	a1,s7
    1852:	fac42503          	lw	a0,-84(s0)
    1856:	00003097          	auipc	ra,0x3
    185a:	b74080e7          	jalr	-1164(ra) # 43ca <write>
    185e:	40900793          	li	a5,1033
    1862:	00f51c63          	bne	a0,a5,187a <pipe1+0x122>
    for(n = 0; n < N; n++){
    1866:	24a5                	addiw	s1,s1,9
    1868:	0ff4f493          	andi	s1,s1,255
    186c:	fd5a16e3          	bne	s4,s5,1838 <pipe1+0xe0>
    exit(0);
    1870:	4501                	li	a0,0
    1872:	00003097          	auipc	ra,0x3
    1876:	b38080e7          	jalr	-1224(ra) # 43aa <exit>
        printf("%s: pipe1 oops 1\n", s);
    187a:	85ca                	mv	a1,s2
    187c:	00004517          	auipc	a0,0x4
    1880:	db450513          	addi	a0,a0,-588 # 5630 <malloc+0xe48>
    1884:	00003097          	auipc	ra,0x3
    1888:	ea6080e7          	jalr	-346(ra) # 472a <printf>
        exit(1);
    188c:	4505                	li	a0,1
    188e:	00003097          	auipc	ra,0x3
    1892:	b1c080e7          	jalr	-1252(ra) # 43aa <exit>
          printf("%s: pipe1 oops 2\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00004517          	auipc	a0,0x4
    189c:	db050513          	addi	a0,a0,-592 # 5648 <malloc+0xe60>
    18a0:	00003097          	auipc	ra,0x3
    18a4:	e8a080e7          	jalr	-374(ra) # 472a <printf>
}
    18a8:	60e6                	ld	ra,88(sp)
    18aa:	6446                	ld	s0,80(sp)
    18ac:	64a6                	ld	s1,72(sp)
    18ae:	6906                	ld	s2,64(sp)
    18b0:	79e2                	ld	s3,56(sp)
    18b2:	7a42                	ld	s4,48(sp)
    18b4:	7aa2                	ld	s5,40(sp)
    18b6:	7b02                	ld	s6,32(sp)
    18b8:	6be2                	ld	s7,24(sp)
    18ba:	6125                	addi	sp,sp,96
    18bc:	8082                	ret
    if(total != N * SZ){
    18be:	6785                	lui	a5,0x1
    18c0:	42d78793          	addi	a5,a5,1069 # 142d <unlinkread+0x1b3>
    18c4:	02fa0063          	beq	s4,a5,18e4 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18c8:	85d2                	mv	a1,s4
    18ca:	00004517          	auipc	a0,0x4
    18ce:	d9650513          	addi	a0,a0,-618 # 5660 <malloc+0xe78>
    18d2:	00003097          	auipc	ra,0x3
    18d6:	e58080e7          	jalr	-424(ra) # 472a <printf>
      exit(1);
    18da:	4505                	li	a0,1
    18dc:	00003097          	auipc	ra,0x3
    18e0:	ace080e7          	jalr	-1330(ra) # 43aa <exit>
    close(fds[0]);
    18e4:	fa842503          	lw	a0,-88(s0)
    18e8:	00003097          	auipc	ra,0x3
    18ec:	aea080e7          	jalr	-1302(ra) # 43d2 <close>
    wait(&xstatus);
    18f0:	fa440513          	addi	a0,s0,-92
    18f4:	00003097          	auipc	ra,0x3
    18f8:	abe080e7          	jalr	-1346(ra) # 43b2 <wait>
    exit(xstatus);
    18fc:	fa442503          	lw	a0,-92(s0)
    1900:	00003097          	auipc	ra,0x3
    1904:	aaa080e7          	jalr	-1366(ra) # 43aa <exit>
    printf("%s: fork() failed\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00004517          	auipc	a0,0x4
    190e:	d7650513          	addi	a0,a0,-650 # 5680 <malloc+0xe98>
    1912:	00003097          	auipc	ra,0x3
    1916:	e18080e7          	jalr	-488(ra) # 472a <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00003097          	auipc	ra,0x3
    1920:	a8e080e7          	jalr	-1394(ra) # 43aa <exit>

0000000000001924 <pgbug>:
{
    1924:	7179                	addi	sp,sp,-48
    1926:	f406                	sd	ra,40(sp)
    1928:	f022                	sd	s0,32(sp)
    192a:	ec26                	sd	s1,24(sp)
    192c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    192e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1932:	00005497          	auipc	s1,0x5
    1936:	0464b483          	ld	s1,70(s1) # 6978 <__SDATA_BEGIN__>
    193a:	fd840593          	addi	a1,s0,-40
    193e:	8526                	mv	a0,s1
    1940:	00003097          	auipc	ra,0x3
    1944:	aa2080e7          	jalr	-1374(ra) # 43e2 <exec>
  pipe((int*)0xeaeb0b5b00002f5e);
    1948:	8526                	mv	a0,s1
    194a:	00003097          	auipc	ra,0x3
    194e:	a70080e7          	jalr	-1424(ra) # 43ba <pipe>
  exit(0);
    1952:	4501                	li	a0,0
    1954:	00003097          	auipc	ra,0x3
    1958:	a56080e7          	jalr	-1450(ra) # 43aa <exit>

000000000000195c <preempt>:
{
    195c:	7139                	addi	sp,sp,-64
    195e:	fc06                	sd	ra,56(sp)
    1960:	f822                	sd	s0,48(sp)
    1962:	f426                	sd	s1,40(sp)
    1964:	f04a                	sd	s2,32(sp)
    1966:	ec4e                	sd	s3,24(sp)
    1968:	e852                	sd	s4,16(sp)
    196a:	0080                	addi	s0,sp,64
    196c:	8a2a                	mv	s4,a0
  pid1 = fork();
    196e:	00003097          	auipc	ra,0x3
    1972:	a34080e7          	jalr	-1484(ra) # 43a2 <fork>
  if(pid1 < 0) {
    1976:	00054563          	bltz	a0,1980 <preempt+0x24>
    197a:	89aa                	mv	s3,a0
  if(pid1 == 0)
    197c:	ed19                	bnez	a0,199a <preempt+0x3e>
    for(;;)
    197e:	a001                	j	197e <preempt+0x22>
    printf("%s: fork failed");
    1980:	00003517          	auipc	a0,0x3
    1984:	3d050513          	addi	a0,a0,976 # 4d50 <malloc+0x568>
    1988:	00003097          	auipc	ra,0x3
    198c:	da2080e7          	jalr	-606(ra) # 472a <printf>
    exit(1);
    1990:	4505                	li	a0,1
    1992:	00003097          	auipc	ra,0x3
    1996:	a18080e7          	jalr	-1512(ra) # 43aa <exit>
  pid2 = fork();
    199a:	00003097          	auipc	ra,0x3
    199e:	a08080e7          	jalr	-1528(ra) # 43a2 <fork>
    19a2:	892a                	mv	s2,a0
  if(pid2 < 0) {
    19a4:	00054463          	bltz	a0,19ac <preempt+0x50>
  if(pid2 == 0)
    19a8:	e105                	bnez	a0,19c8 <preempt+0x6c>
    for(;;)
    19aa:	a001                	j	19aa <preempt+0x4e>
    printf("%s: fork failed\n", s);
    19ac:	85d2                	mv	a1,s4
    19ae:	00003517          	auipc	a0,0x3
    19b2:	33a50513          	addi	a0,a0,826 # 4ce8 <malloc+0x500>
    19b6:	00003097          	auipc	ra,0x3
    19ba:	d74080e7          	jalr	-652(ra) # 472a <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	00003097          	auipc	ra,0x3
    19c4:	9ea080e7          	jalr	-1558(ra) # 43aa <exit>
  pipe(pfds);
    19c8:	fc840513          	addi	a0,s0,-56
    19cc:	00003097          	auipc	ra,0x3
    19d0:	9ee080e7          	jalr	-1554(ra) # 43ba <pipe>
  pid3 = fork();
    19d4:	00003097          	auipc	ra,0x3
    19d8:	9ce080e7          	jalr	-1586(ra) # 43a2 <fork>
    19dc:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    19de:	02054e63          	bltz	a0,1a1a <preempt+0xbe>
  if(pid3 == 0){
    19e2:	e13d                	bnez	a0,1a48 <preempt+0xec>
    close(pfds[0]);
    19e4:	fc842503          	lw	a0,-56(s0)
    19e8:	00003097          	auipc	ra,0x3
    19ec:	9ea080e7          	jalr	-1558(ra) # 43d2 <close>
    if(write(pfds[1], "x", 1) != 1)
    19f0:	4605                	li	a2,1
    19f2:	00004597          	auipc	a1,0x4
    19f6:	ca658593          	addi	a1,a1,-858 # 5698 <malloc+0xeb0>
    19fa:	fcc42503          	lw	a0,-52(s0)
    19fe:	00003097          	auipc	ra,0x3
    1a02:	9cc080e7          	jalr	-1588(ra) # 43ca <write>
    1a06:	4785                	li	a5,1
    1a08:	02f51763          	bne	a0,a5,1a36 <preempt+0xda>
    close(pfds[1]);
    1a0c:	fcc42503          	lw	a0,-52(s0)
    1a10:	00003097          	auipc	ra,0x3
    1a14:	9c2080e7          	jalr	-1598(ra) # 43d2 <close>
    for(;;)
    1a18:	a001                	j	1a18 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    1a1a:	85d2                	mv	a1,s4
    1a1c:	00003517          	auipc	a0,0x3
    1a20:	2cc50513          	addi	a0,a0,716 # 4ce8 <malloc+0x500>
    1a24:	00003097          	auipc	ra,0x3
    1a28:	d06080e7          	jalr	-762(ra) # 472a <printf>
     exit(1);
    1a2c:	4505                	li	a0,1
    1a2e:	00003097          	auipc	ra,0x3
    1a32:	97c080e7          	jalr	-1668(ra) # 43aa <exit>
      printf("%s: preempt write error");
    1a36:	00004517          	auipc	a0,0x4
    1a3a:	c6a50513          	addi	a0,a0,-918 # 56a0 <malloc+0xeb8>
    1a3e:	00003097          	auipc	ra,0x3
    1a42:	cec080e7          	jalr	-788(ra) # 472a <printf>
    1a46:	b7d9                	j	1a0c <preempt+0xb0>
  close(pfds[1]);
    1a48:	fcc42503          	lw	a0,-52(s0)
    1a4c:	00003097          	auipc	ra,0x3
    1a50:	986080e7          	jalr	-1658(ra) # 43d2 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1a54:	660d                	lui	a2,0x3
    1a56:	00007597          	auipc	a1,0x7
    1a5a:	75258593          	addi	a1,a1,1874 # 91a8 <buf>
    1a5e:	fc842503          	lw	a0,-56(s0)
    1a62:	00003097          	auipc	ra,0x3
    1a66:	960080e7          	jalr	-1696(ra) # 43c2 <read>
    1a6a:	4785                	li	a5,1
    1a6c:	02f50263          	beq	a0,a5,1a90 <preempt+0x134>
    printf("%s: preempt read error");
    1a70:	00004517          	auipc	a0,0x4
    1a74:	c4850513          	addi	a0,a0,-952 # 56b8 <malloc+0xed0>
    1a78:	00003097          	auipc	ra,0x3
    1a7c:	cb2080e7          	jalr	-846(ra) # 472a <printf>
}
    1a80:	70e2                	ld	ra,56(sp)
    1a82:	7442                	ld	s0,48(sp)
    1a84:	74a2                	ld	s1,40(sp)
    1a86:	7902                	ld	s2,32(sp)
    1a88:	69e2                	ld	s3,24(sp)
    1a8a:	6a42                	ld	s4,16(sp)
    1a8c:	6121                	addi	sp,sp,64
    1a8e:	8082                	ret
  close(pfds[0]);
    1a90:	fc842503          	lw	a0,-56(s0)
    1a94:	00003097          	auipc	ra,0x3
    1a98:	93e080e7          	jalr	-1730(ra) # 43d2 <close>
  printf("kill... ");
    1a9c:	00004517          	auipc	a0,0x4
    1aa0:	c3450513          	addi	a0,a0,-972 # 56d0 <malloc+0xee8>
    1aa4:	00003097          	auipc	ra,0x3
    1aa8:	c86080e7          	jalr	-890(ra) # 472a <printf>
  kill(pid1);
    1aac:	854e                	mv	a0,s3
    1aae:	00003097          	auipc	ra,0x3
    1ab2:	92c080e7          	jalr	-1748(ra) # 43da <kill>
  kill(pid2);
    1ab6:	854a                	mv	a0,s2
    1ab8:	00003097          	auipc	ra,0x3
    1abc:	922080e7          	jalr	-1758(ra) # 43da <kill>
  kill(pid3);
    1ac0:	8526                	mv	a0,s1
    1ac2:	00003097          	auipc	ra,0x3
    1ac6:	918080e7          	jalr	-1768(ra) # 43da <kill>
  printf("wait... ");
    1aca:	00004517          	auipc	a0,0x4
    1ace:	c1650513          	addi	a0,a0,-1002 # 56e0 <malloc+0xef8>
    1ad2:	00003097          	auipc	ra,0x3
    1ad6:	c58080e7          	jalr	-936(ra) # 472a <printf>
  wait(0);
    1ada:	4501                	li	a0,0
    1adc:	00003097          	auipc	ra,0x3
    1ae0:	8d6080e7          	jalr	-1834(ra) # 43b2 <wait>
  wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00003097          	auipc	ra,0x3
    1aea:	8cc080e7          	jalr	-1844(ra) # 43b2 <wait>
  wait(0);
    1aee:	4501                	li	a0,0
    1af0:	00003097          	auipc	ra,0x3
    1af4:	8c2080e7          	jalr	-1854(ra) # 43b2 <wait>
    1af8:	b761                	j	1a80 <preempt+0x124>

0000000000001afa <reparent>:
{
    1afa:	7179                	addi	sp,sp,-48
    1afc:	f406                	sd	ra,40(sp)
    1afe:	f022                	sd	s0,32(sp)
    1b00:	ec26                	sd	s1,24(sp)
    1b02:	e84a                	sd	s2,16(sp)
    1b04:	e44e                	sd	s3,8(sp)
    1b06:	e052                	sd	s4,0(sp)
    1b08:	1800                	addi	s0,sp,48
    1b0a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    1b0c:	00003097          	auipc	ra,0x3
    1b10:	91e080e7          	jalr	-1762(ra) # 442a <getpid>
    1b14:	8a2a                	mv	s4,a0
    1b16:	0c800913          	li	s2,200
    int pid = fork();
    1b1a:	00003097          	auipc	ra,0x3
    1b1e:	888080e7          	jalr	-1912(ra) # 43a2 <fork>
    1b22:	84aa                	mv	s1,a0
    if(pid < 0){
    1b24:	02054263          	bltz	a0,1b48 <reparent+0x4e>
    if(pid){
    1b28:	cd21                	beqz	a0,1b80 <reparent+0x86>
      if(wait(0) != pid){
    1b2a:	4501                	li	a0,0
    1b2c:	00003097          	auipc	ra,0x3
    1b30:	886080e7          	jalr	-1914(ra) # 43b2 <wait>
    1b34:	02951863          	bne	a0,s1,1b64 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    1b38:	397d                	addiw	s2,s2,-1
    1b3a:	fe0910e3          	bnez	s2,1b1a <reparent+0x20>
  exit(0);
    1b3e:	4501                	li	a0,0
    1b40:	00003097          	auipc	ra,0x3
    1b44:	86a080e7          	jalr	-1942(ra) # 43aa <exit>
      printf("%s: fork failed\n", s);
    1b48:	85ce                	mv	a1,s3
    1b4a:	00003517          	auipc	a0,0x3
    1b4e:	19e50513          	addi	a0,a0,414 # 4ce8 <malloc+0x500>
    1b52:	00003097          	auipc	ra,0x3
    1b56:	bd8080e7          	jalr	-1064(ra) # 472a <printf>
      exit(1);
    1b5a:	4505                	li	a0,1
    1b5c:	00003097          	auipc	ra,0x3
    1b60:	84e080e7          	jalr	-1970(ra) # 43aa <exit>
        printf("%s: wait wrong pid\n", s);
    1b64:	85ce                	mv	a1,s3
    1b66:	00003517          	auipc	a0,0x3
    1b6a:	1b250513          	addi	a0,a0,434 # 4d18 <malloc+0x530>
    1b6e:	00003097          	auipc	ra,0x3
    1b72:	bbc080e7          	jalr	-1092(ra) # 472a <printf>
        exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	832080e7          	jalr	-1998(ra) # 43aa <exit>
      int pid2 = fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	822080e7          	jalr	-2014(ra) # 43a2 <fork>
      if(pid2 < 0){
    1b88:	00054763          	bltz	a0,1b96 <reparent+0x9c>
      exit(0);
    1b8c:	4501                	li	a0,0
    1b8e:	00003097          	auipc	ra,0x3
    1b92:	81c080e7          	jalr	-2020(ra) # 43aa <exit>
        kill(master_pid);
    1b96:	8552                	mv	a0,s4
    1b98:	00003097          	auipc	ra,0x3
    1b9c:	842080e7          	jalr	-1982(ra) # 43da <kill>
        exit(1);
    1ba0:	4505                	li	a0,1
    1ba2:	00003097          	auipc	ra,0x3
    1ba6:	808080e7          	jalr	-2040(ra) # 43aa <exit>

0000000000001baa <mem>:
{
    1baa:	7139                	addi	sp,sp,-64
    1bac:	fc06                	sd	ra,56(sp)
    1bae:	f822                	sd	s0,48(sp)
    1bb0:	f426                	sd	s1,40(sp)
    1bb2:	f04a                	sd	s2,32(sp)
    1bb4:	ec4e                	sd	s3,24(sp)
    1bb6:	0080                	addi	s0,sp,64
    1bb8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    1bba:	00002097          	auipc	ra,0x2
    1bbe:	7e8080e7          	jalr	2024(ra) # 43a2 <fork>
    m1 = 0;
    1bc2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    1bc4:	6909                	lui	s2,0x2
    1bc6:	71190913          	addi	s2,s2,1809 # 2711 <concreate+0x2b1>
  if((pid = fork()) == 0){
    1bca:	ed39                	bnez	a0,1c28 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    1bcc:	854a                	mv	a0,s2
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	c1a080e7          	jalr	-998(ra) # 47e8 <malloc>
    1bd6:	c501                	beqz	a0,1bde <mem+0x34>
      *(char**)m2 = m1;
    1bd8:	e104                	sd	s1,0(a0)
      m1 = m2;
    1bda:	84aa                	mv	s1,a0
    1bdc:	bfc5                	j	1bcc <mem+0x22>
    while(m1){
    1bde:	c881                	beqz	s1,1bee <mem+0x44>
      m2 = *(char**)m1;
    1be0:	8526                	mv	a0,s1
    1be2:	6084                	ld	s1,0(s1)
      free(m1);
    1be4:	00003097          	auipc	ra,0x3
    1be8:	b7c080e7          	jalr	-1156(ra) # 4760 <free>
    while(m1){
    1bec:	f8f5                	bnez	s1,1be0 <mem+0x36>
    m1 = malloc(1024*20);
    1bee:	6515                	lui	a0,0x5
    1bf0:	00003097          	auipc	ra,0x3
    1bf4:	bf8080e7          	jalr	-1032(ra) # 47e8 <malloc>
    if(m1 == 0){
    1bf8:	c911                	beqz	a0,1c0c <mem+0x62>
    free(m1);
    1bfa:	00003097          	auipc	ra,0x3
    1bfe:	b66080e7          	jalr	-1178(ra) # 4760 <free>
    exit(0);
    1c02:	4501                	li	a0,0
    1c04:	00002097          	auipc	ra,0x2
    1c08:	7a6080e7          	jalr	1958(ra) # 43aa <exit>
      printf("couldn't allocate mem?!!\n", s);
    1c0c:	85ce                	mv	a1,s3
    1c0e:	00004517          	auipc	a0,0x4
    1c12:	ae250513          	addi	a0,a0,-1310 # 56f0 <malloc+0xf08>
    1c16:	00003097          	auipc	ra,0x3
    1c1a:	b14080e7          	jalr	-1260(ra) # 472a <printf>
      exit(1);
    1c1e:	4505                	li	a0,1
    1c20:	00002097          	auipc	ra,0x2
    1c24:	78a080e7          	jalr	1930(ra) # 43aa <exit>
    wait(&xstatus);
    1c28:	fcc40513          	addi	a0,s0,-52
    1c2c:	00002097          	auipc	ra,0x2
    1c30:	786080e7          	jalr	1926(ra) # 43b2 <wait>
    exit(xstatus);
    1c34:	fcc42503          	lw	a0,-52(s0)
    1c38:	00002097          	auipc	ra,0x2
    1c3c:	772080e7          	jalr	1906(ra) # 43aa <exit>

0000000000001c40 <sharedfd>:
{
    1c40:	7159                	addi	sp,sp,-112
    1c42:	f486                	sd	ra,104(sp)
    1c44:	f0a2                	sd	s0,96(sp)
    1c46:	eca6                	sd	s1,88(sp)
    1c48:	e8ca                	sd	s2,80(sp)
    1c4a:	e4ce                	sd	s3,72(sp)
    1c4c:	e0d2                	sd	s4,64(sp)
    1c4e:	fc56                	sd	s5,56(sp)
    1c50:	f85a                	sd	s6,48(sp)
    1c52:	f45e                	sd	s7,40(sp)
    1c54:	1880                	addi	s0,sp,112
    1c56:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    1c58:	00003517          	auipc	a0,0x3
    1c5c:	d8050513          	addi	a0,a0,-640 # 49d8 <malloc+0x1f0>
    1c60:	00002097          	auipc	ra,0x2
    1c64:	79a080e7          	jalr	1946(ra) # 43fa <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1c68:	20200593          	li	a1,514
    1c6c:	00003517          	auipc	a0,0x3
    1c70:	d6c50513          	addi	a0,a0,-660 # 49d8 <malloc+0x1f0>
    1c74:	00002097          	auipc	ra,0x2
    1c78:	776080e7          	jalr	1910(ra) # 43ea <open>
  if(fd < 0){
    1c7c:	04054a63          	bltz	a0,1cd0 <sharedfd+0x90>
    1c80:	892a                	mv	s2,a0
  pid = fork();
    1c82:	00002097          	auipc	ra,0x2
    1c86:	720080e7          	jalr	1824(ra) # 43a2 <fork>
    1c8a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1c8c:	06300593          	li	a1,99
    1c90:	c119                	beqz	a0,1c96 <sharedfd+0x56>
    1c92:	07000593          	li	a1,112
    1c96:	4629                	li	a2,10
    1c98:	fa040513          	addi	a0,s0,-96
    1c9c:	00002097          	auipc	ra,0x2
    1ca0:	58a080e7          	jalr	1418(ra) # 4226 <memset>
    1ca4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1ca8:	4629                	li	a2,10
    1caa:	fa040593          	addi	a1,s0,-96
    1cae:	854a                	mv	a0,s2
    1cb0:	00002097          	auipc	ra,0x2
    1cb4:	71a080e7          	jalr	1818(ra) # 43ca <write>
    1cb8:	47a9                	li	a5,10
    1cba:	02f51963          	bne	a0,a5,1cec <sharedfd+0xac>
  for(i = 0; i < N; i++){
    1cbe:	34fd                	addiw	s1,s1,-1
    1cc0:	f4e5                	bnez	s1,1ca8 <sharedfd+0x68>
  if(pid == 0) {
    1cc2:	04099363          	bnez	s3,1d08 <sharedfd+0xc8>
    exit(0);
    1cc6:	4501                	li	a0,0
    1cc8:	00002097          	auipc	ra,0x2
    1ccc:	6e2080e7          	jalr	1762(ra) # 43aa <exit>
    printf("%s: cannot open sharedfd for writing", s);
    1cd0:	85d2                	mv	a1,s4
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	a3e50513          	addi	a0,a0,-1474 # 5710 <malloc+0xf28>
    1cda:	00003097          	auipc	ra,0x3
    1cde:	a50080e7          	jalr	-1456(ra) # 472a <printf>
    exit(1);
    1ce2:	4505                	li	a0,1
    1ce4:	00002097          	auipc	ra,0x2
    1ce8:	6c6080e7          	jalr	1734(ra) # 43aa <exit>
      printf("%s: write sharedfd failed\n", s);
    1cec:	85d2                	mv	a1,s4
    1cee:	00004517          	auipc	a0,0x4
    1cf2:	a4a50513          	addi	a0,a0,-1462 # 5738 <malloc+0xf50>
    1cf6:	00003097          	auipc	ra,0x3
    1cfa:	a34080e7          	jalr	-1484(ra) # 472a <printf>
      exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00002097          	auipc	ra,0x2
    1d04:	6aa080e7          	jalr	1706(ra) # 43aa <exit>
    wait(&xstatus);
    1d08:	f9c40513          	addi	a0,s0,-100
    1d0c:	00002097          	auipc	ra,0x2
    1d10:	6a6080e7          	jalr	1702(ra) # 43b2 <wait>
    if(xstatus != 0)
    1d14:	f9c42983          	lw	s3,-100(s0)
    1d18:	00098763          	beqz	s3,1d26 <sharedfd+0xe6>
      exit(xstatus);
    1d1c:	854e                	mv	a0,s3
    1d1e:	00002097          	auipc	ra,0x2
    1d22:	68c080e7          	jalr	1676(ra) # 43aa <exit>
  close(fd);
    1d26:	854a                	mv	a0,s2
    1d28:	00002097          	auipc	ra,0x2
    1d2c:	6aa080e7          	jalr	1706(ra) # 43d2 <close>
  fd = open("sharedfd", 0);
    1d30:	4581                	li	a1,0
    1d32:	00003517          	auipc	a0,0x3
    1d36:	ca650513          	addi	a0,a0,-858 # 49d8 <malloc+0x1f0>
    1d3a:	00002097          	auipc	ra,0x2
    1d3e:	6b0080e7          	jalr	1712(ra) # 43ea <open>
    1d42:	8baa                	mv	s7,a0
  nc = np = 0;
    1d44:	8ace                	mv	s5,s3
  if(fd < 0){
    1d46:	02054563          	bltz	a0,1d70 <sharedfd+0x130>
    1d4a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    1d4e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    1d52:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1d56:	4629                	li	a2,10
    1d58:	fa040593          	addi	a1,s0,-96
    1d5c:	855e                	mv	a0,s7
    1d5e:	00002097          	auipc	ra,0x2
    1d62:	664080e7          	jalr	1636(ra) # 43c2 <read>
    1d66:	02a05f63          	blez	a0,1da4 <sharedfd+0x164>
    1d6a:	fa040793          	addi	a5,s0,-96
    1d6e:	a01d                	j	1d94 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    1d70:	85d2                	mv	a1,s4
    1d72:	00004517          	auipc	a0,0x4
    1d76:	9e650513          	addi	a0,a0,-1562 # 5758 <malloc+0xf70>
    1d7a:	00003097          	auipc	ra,0x3
    1d7e:	9b0080e7          	jalr	-1616(ra) # 472a <printf>
    exit(1);
    1d82:	4505                	li	a0,1
    1d84:	00002097          	auipc	ra,0x2
    1d88:	626080e7          	jalr	1574(ra) # 43aa <exit>
        nc++;
    1d8c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    1d8e:	0785                	addi	a5,a5,1
    1d90:	fd2783e3          	beq	a5,s2,1d56 <sharedfd+0x116>
      if(buf[i] == 'c')
    1d94:	0007c703          	lbu	a4,0(a5)
    1d98:	fe970ae3          	beq	a4,s1,1d8c <sharedfd+0x14c>
      if(buf[i] == 'p')
    1d9c:	ff6719e3          	bne	a4,s6,1d8e <sharedfd+0x14e>
        np++;
    1da0:	2a85                	addiw	s5,s5,1
    1da2:	b7f5                	j	1d8e <sharedfd+0x14e>
  close(fd);
    1da4:	855e                	mv	a0,s7
    1da6:	00002097          	auipc	ra,0x2
    1daa:	62c080e7          	jalr	1580(ra) # 43d2 <close>
  unlink("sharedfd");
    1dae:	00003517          	auipc	a0,0x3
    1db2:	c2a50513          	addi	a0,a0,-982 # 49d8 <malloc+0x1f0>
    1db6:	00002097          	auipc	ra,0x2
    1dba:	644080e7          	jalr	1604(ra) # 43fa <unlink>
  if(nc == N*SZ && np == N*SZ){
    1dbe:	6789                	lui	a5,0x2
    1dc0:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2b0>
    1dc4:	00f99763          	bne	s3,a5,1dd2 <sharedfd+0x192>
    1dc8:	6789                	lui	a5,0x2
    1dca:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2b0>
    1dce:	02fa8063          	beq	s5,a5,1dee <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    1dd2:	85d2                	mv	a1,s4
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	9ac50513          	addi	a0,a0,-1620 # 5780 <malloc+0xf98>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	94e080e7          	jalr	-1714(ra) # 472a <printf>
    exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00002097          	auipc	ra,0x2
    1dea:	5c4080e7          	jalr	1476(ra) # 43aa <exit>
    exit(0);
    1dee:	4501                	li	a0,0
    1df0:	00002097          	auipc	ra,0x2
    1df4:	5ba080e7          	jalr	1466(ra) # 43aa <exit>

0000000000001df8 <fourfiles>:
{
    1df8:	7171                	addi	sp,sp,-176
    1dfa:	f506                	sd	ra,168(sp)
    1dfc:	f122                	sd	s0,160(sp)
    1dfe:	ed26                	sd	s1,152(sp)
    1e00:	e94a                	sd	s2,144(sp)
    1e02:	e54e                	sd	s3,136(sp)
    1e04:	e152                	sd	s4,128(sp)
    1e06:	fcd6                	sd	s5,120(sp)
    1e08:	f8da                	sd	s6,112(sp)
    1e0a:	f4de                	sd	s7,104(sp)
    1e0c:	f0e2                	sd	s8,96(sp)
    1e0e:	ece6                	sd	s9,88(sp)
    1e10:	e8ea                	sd	s10,80(sp)
    1e12:	e4ee                	sd	s11,72(sp)
    1e14:	1900                	addi	s0,sp,176
    1e16:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e18:	00003797          	auipc	a5,0x3
    1e1c:	ab878793          	addi	a5,a5,-1352 # 48d0 <malloc+0xe8>
    1e20:	f6f43823          	sd	a5,-144(s0)
    1e24:	00003797          	auipc	a5,0x3
    1e28:	ab478793          	addi	a5,a5,-1356 # 48d8 <malloc+0xf0>
    1e2c:	f6f43c23          	sd	a5,-136(s0)
    1e30:	00003797          	auipc	a5,0x3
    1e34:	ab078793          	addi	a5,a5,-1360 # 48e0 <malloc+0xf8>
    1e38:	f8f43023          	sd	a5,-128(s0)
    1e3c:	00003797          	auipc	a5,0x3
    1e40:	aac78793          	addi	a5,a5,-1364 # 48e8 <malloc+0x100>
    1e44:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    1e48:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e4c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    1e4e:	4481                	li	s1,0
    1e50:	4a11                	li	s4,4
    fname = names[pi];
    1e52:	00093983          	ld	s3,0(s2)
    unlink(fname);
    1e56:	854e                	mv	a0,s3
    1e58:	00002097          	auipc	ra,0x2
    1e5c:	5a2080e7          	jalr	1442(ra) # 43fa <unlink>
    pid = fork();
    1e60:	00002097          	auipc	ra,0x2
    1e64:	542080e7          	jalr	1346(ra) # 43a2 <fork>
    if(pid < 0){
    1e68:	04054563          	bltz	a0,1eb2 <fourfiles+0xba>
    if(pid == 0){
    1e6c:	c12d                	beqz	a0,1ece <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    1e6e:	2485                	addiw	s1,s1,1
    1e70:	0921                	addi	s2,s2,8
    1e72:	ff4490e3          	bne	s1,s4,1e52 <fourfiles+0x5a>
    1e76:	4491                	li	s1,4
    wait(&xstatus);
    1e78:	f6c40513          	addi	a0,s0,-148
    1e7c:	00002097          	auipc	ra,0x2
    1e80:	536080e7          	jalr	1334(ra) # 43b2 <wait>
    if(xstatus != 0)
    1e84:	f6c42503          	lw	a0,-148(s0)
    1e88:	ed69                	bnez	a0,1f62 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    1e8a:	34fd                	addiw	s1,s1,-1
    1e8c:	f4f5                	bnez	s1,1e78 <fourfiles+0x80>
    1e8e:	03000b13          	li	s6,48
    total = 0;
    1e92:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1e96:	00007a17          	auipc	s4,0x7
    1e9a:	312a0a13          	addi	s4,s4,786 # 91a8 <buf>
    1e9e:	00007a97          	auipc	s5,0x7
    1ea2:	30ba8a93          	addi	s5,s5,779 # 91a9 <buf+0x1>
    if(total != N*SZ){
    1ea6:	6d05                	lui	s10,0x1
    1ea8:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x18>
  for(i = 0; i < NCHILD; i++){
    1eac:	03400d93          	li	s11,52
    1eb0:	a23d                	j	1fde <fourfiles+0x1e6>
      printf("fork failed\n", s);
    1eb2:	85e6                	mv	a1,s9
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	73450513          	addi	a0,a0,1844 # 55e8 <malloc+0xe00>
    1ebc:	00003097          	auipc	ra,0x3
    1ec0:	86e080e7          	jalr	-1938(ra) # 472a <printf>
      exit(1);
    1ec4:	4505                	li	a0,1
    1ec6:	00002097          	auipc	ra,0x2
    1eca:	4e4080e7          	jalr	1252(ra) # 43aa <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1ece:	20200593          	li	a1,514
    1ed2:	854e                	mv	a0,s3
    1ed4:	00002097          	auipc	ra,0x2
    1ed8:	516080e7          	jalr	1302(ra) # 43ea <open>
    1edc:	892a                	mv	s2,a0
      if(fd < 0){
    1ede:	04054763          	bltz	a0,1f2c <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    1ee2:	1f400613          	li	a2,500
    1ee6:	0304859b          	addiw	a1,s1,48
    1eea:	00007517          	auipc	a0,0x7
    1eee:	2be50513          	addi	a0,a0,702 # 91a8 <buf>
    1ef2:	00002097          	auipc	ra,0x2
    1ef6:	334080e7          	jalr	820(ra) # 4226 <memset>
    1efa:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    1efc:	00007997          	auipc	s3,0x7
    1f00:	2ac98993          	addi	s3,s3,684 # 91a8 <buf>
    1f04:	1f400613          	li	a2,500
    1f08:	85ce                	mv	a1,s3
    1f0a:	854a                	mv	a0,s2
    1f0c:	00002097          	auipc	ra,0x2
    1f10:	4be080e7          	jalr	1214(ra) # 43ca <write>
    1f14:	85aa                	mv	a1,a0
    1f16:	1f400793          	li	a5,500
    1f1a:	02f51763          	bne	a0,a5,1f48 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    1f1e:	34fd                	addiw	s1,s1,-1
    1f20:	f0f5                	bnez	s1,1f04 <fourfiles+0x10c>
      exit(0);
    1f22:	4501                	li	a0,0
    1f24:	00002097          	auipc	ra,0x2
    1f28:	486080e7          	jalr	1158(ra) # 43aa <exit>
        printf("create failed\n", s);
    1f2c:	85e6                	mv	a1,s9
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	86a50513          	addi	a0,a0,-1942 # 5798 <malloc+0xfb0>
    1f36:	00002097          	auipc	ra,0x2
    1f3a:	7f4080e7          	jalr	2036(ra) # 472a <printf>
        exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	00002097          	auipc	ra,0x2
    1f44:	46a080e7          	jalr	1130(ra) # 43aa <exit>
          printf("write failed %d\n", n);
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	86050513          	addi	a0,a0,-1952 # 57a8 <malloc+0xfc0>
    1f50:	00002097          	auipc	ra,0x2
    1f54:	7da080e7          	jalr	2010(ra) # 472a <printf>
          exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00002097          	auipc	ra,0x2
    1f5e:	450080e7          	jalr	1104(ra) # 43aa <exit>
      exit(xstatus);
    1f62:	00002097          	auipc	ra,0x2
    1f66:	448080e7          	jalr	1096(ra) # 43aa <exit>
          printf("wrong char\n", s);
    1f6a:	85e6                	mv	a1,s9
    1f6c:	00004517          	auipc	a0,0x4
    1f70:	85450513          	addi	a0,a0,-1964 # 57c0 <malloc+0xfd8>
    1f74:	00002097          	auipc	ra,0x2
    1f78:	7b6080e7          	jalr	1974(ra) # 472a <printf>
          exit(1);
    1f7c:	4505                	li	a0,1
    1f7e:	00002097          	auipc	ra,0x2
    1f82:	42c080e7          	jalr	1068(ra) # 43aa <exit>
      total += n;
    1f86:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f8a:	660d                	lui	a2,0x3
    1f8c:	85d2                	mv	a1,s4
    1f8e:	854e                	mv	a0,s3
    1f90:	00002097          	auipc	ra,0x2
    1f94:	432080e7          	jalr	1074(ra) # 43c2 <read>
    1f98:	02a05363          	blez	a0,1fbe <fourfiles+0x1c6>
    1f9c:	00007797          	auipc	a5,0x7
    1fa0:	20c78793          	addi	a5,a5,524 # 91a8 <buf>
    1fa4:	fff5069b          	addiw	a3,a0,-1
    1fa8:	1682                	slli	a3,a3,0x20
    1faa:	9281                	srli	a3,a3,0x20
    1fac:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    1fae:	0007c703          	lbu	a4,0(a5)
    1fb2:	fa971ce3          	bne	a4,s1,1f6a <fourfiles+0x172>
      for(j = 0; j < n; j++){
    1fb6:	0785                	addi	a5,a5,1
    1fb8:	fed79be3          	bne	a5,a3,1fae <fourfiles+0x1b6>
    1fbc:	b7e9                	j	1f86 <fourfiles+0x18e>
    close(fd);
    1fbe:	854e                	mv	a0,s3
    1fc0:	00002097          	auipc	ra,0x2
    1fc4:	412080e7          	jalr	1042(ra) # 43d2 <close>
    if(total != N*SZ){
    1fc8:	03a91963          	bne	s2,s10,1ffa <fourfiles+0x202>
    unlink(fname);
    1fcc:	8562                	mv	a0,s8
    1fce:	00002097          	auipc	ra,0x2
    1fd2:	42c080e7          	jalr	1068(ra) # 43fa <unlink>
  for(i = 0; i < NCHILD; i++){
    1fd6:	0ba1                	addi	s7,s7,8
    1fd8:	2b05                	addiw	s6,s6,1
    1fda:	03bb0e63          	beq	s6,s11,2016 <fourfiles+0x21e>
    fname = names[i];
    1fde:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1fe2:	4581                	li	a1,0
    1fe4:	8562                	mv	a0,s8
    1fe6:	00002097          	auipc	ra,0x2
    1fea:	404080e7          	jalr	1028(ra) # 43ea <open>
    1fee:	89aa                	mv	s3,a0
    total = 0;
    1ff0:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    1ff4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1ff8:	bf49                	j	1f8a <fourfiles+0x192>
      printf("wrong length %d\n", total);
    1ffa:	85ca                	mv	a1,s2
    1ffc:	00003517          	auipc	a0,0x3
    2000:	7d450513          	addi	a0,a0,2004 # 57d0 <malloc+0xfe8>
    2004:	00002097          	auipc	ra,0x2
    2008:	726080e7          	jalr	1830(ra) # 472a <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00002097          	auipc	ra,0x2
    2012:	39c080e7          	jalr	924(ra) # 43aa <exit>
}
    2016:	70aa                	ld	ra,168(sp)
    2018:	740a                	ld	s0,160(sp)
    201a:	64ea                	ld	s1,152(sp)
    201c:	694a                	ld	s2,144(sp)
    201e:	69aa                	ld	s3,136(sp)
    2020:	6a0a                	ld	s4,128(sp)
    2022:	7ae6                	ld	s5,120(sp)
    2024:	7b46                	ld	s6,112(sp)
    2026:	7ba6                	ld	s7,104(sp)
    2028:	7c06                	ld	s8,96(sp)
    202a:	6ce6                	ld	s9,88(sp)
    202c:	6d46                	ld	s10,80(sp)
    202e:	6da6                	ld	s11,72(sp)
    2030:	614d                	addi	sp,sp,176
    2032:	8082                	ret

0000000000002034 <bigfile>:
{
    2034:	7139                	addi	sp,sp,-64
    2036:	fc06                	sd	ra,56(sp)
    2038:	f822                	sd	s0,48(sp)
    203a:	f426                	sd	s1,40(sp)
    203c:	f04a                	sd	s2,32(sp)
    203e:	ec4e                	sd	s3,24(sp)
    2040:	e852                	sd	s4,16(sp)
    2042:	e456                	sd	s5,8(sp)
    2044:	0080                	addi	s0,sp,64
    2046:	8aaa                	mv	s5,a0
  unlink("bigfile");
    2048:	00003517          	auipc	a0,0x3
    204c:	ae050513          	addi	a0,a0,-1312 # 4b28 <malloc+0x340>
    2050:	00002097          	auipc	ra,0x2
    2054:	3aa080e7          	jalr	938(ra) # 43fa <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2058:	20200593          	li	a1,514
    205c:	00003517          	auipc	a0,0x3
    2060:	acc50513          	addi	a0,a0,-1332 # 4b28 <malloc+0x340>
    2064:	00002097          	auipc	ra,0x2
    2068:	386080e7          	jalr	902(ra) # 43ea <open>
    206c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    206e:	4481                	li	s1,0
    memset(buf, i, SZ);
    2070:	00007917          	auipc	s2,0x7
    2074:	13890913          	addi	s2,s2,312 # 91a8 <buf>
  for(i = 0; i < N; i++){
    2078:	4a51                	li	s4,20
  if(fd < 0){
    207a:	0a054063          	bltz	a0,211a <bigfile+0xe6>
    memset(buf, i, SZ);
    207e:	25800613          	li	a2,600
    2082:	85a6                	mv	a1,s1
    2084:	854a                	mv	a0,s2
    2086:	00002097          	auipc	ra,0x2
    208a:	1a0080e7          	jalr	416(ra) # 4226 <memset>
    if(write(fd, buf, SZ) != SZ){
    208e:	25800613          	li	a2,600
    2092:	85ca                	mv	a1,s2
    2094:	854e                	mv	a0,s3
    2096:	00002097          	auipc	ra,0x2
    209a:	334080e7          	jalr	820(ra) # 43ca <write>
    209e:	25800793          	li	a5,600
    20a2:	08f51a63          	bne	a0,a5,2136 <bigfile+0x102>
  for(i = 0; i < N; i++){
    20a6:	2485                	addiw	s1,s1,1
    20a8:	fd449be3          	bne	s1,s4,207e <bigfile+0x4a>
  close(fd);
    20ac:	854e                	mv	a0,s3
    20ae:	00002097          	auipc	ra,0x2
    20b2:	324080e7          	jalr	804(ra) # 43d2 <close>
  fd = open("bigfile", 0);
    20b6:	4581                	li	a1,0
    20b8:	00003517          	auipc	a0,0x3
    20bc:	a7050513          	addi	a0,a0,-1424 # 4b28 <malloc+0x340>
    20c0:	00002097          	auipc	ra,0x2
    20c4:	32a080e7          	jalr	810(ra) # 43ea <open>
    20c8:	8a2a                	mv	s4,a0
  total = 0;
    20ca:	4981                	li	s3,0
  for(i = 0; ; i++){
    20cc:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    20ce:	00007917          	auipc	s2,0x7
    20d2:	0da90913          	addi	s2,s2,218 # 91a8 <buf>
  if(fd < 0){
    20d6:	06054e63          	bltz	a0,2152 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    20da:	12c00613          	li	a2,300
    20de:	85ca                	mv	a1,s2
    20e0:	8552                	mv	a0,s4
    20e2:	00002097          	auipc	ra,0x2
    20e6:	2e0080e7          	jalr	736(ra) # 43c2 <read>
    if(cc < 0){
    20ea:	08054263          	bltz	a0,216e <bigfile+0x13a>
    if(cc == 0)
    20ee:	c971                	beqz	a0,21c2 <bigfile+0x18e>
    if(cc != SZ/2){
    20f0:	12c00793          	li	a5,300
    20f4:	08f51b63          	bne	a0,a5,218a <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    20f8:	01f4d79b          	srliw	a5,s1,0x1f
    20fc:	9fa5                	addw	a5,a5,s1
    20fe:	4017d79b          	sraiw	a5,a5,0x1
    2102:	00094703          	lbu	a4,0(s2)
    2106:	0af71063          	bne	a4,a5,21a6 <bigfile+0x172>
    210a:	12b94703          	lbu	a4,299(s2)
    210e:	08f71c63          	bne	a4,a5,21a6 <bigfile+0x172>
    total += cc;
    2112:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    2116:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    2118:	b7c9                	j	20da <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    211a:	85d6                	mv	a1,s5
    211c:	00003517          	auipc	a0,0x3
    2120:	6cc50513          	addi	a0,a0,1740 # 57e8 <malloc+0x1000>
    2124:	00002097          	auipc	ra,0x2
    2128:	606080e7          	jalr	1542(ra) # 472a <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	00002097          	auipc	ra,0x2
    2132:	27c080e7          	jalr	636(ra) # 43aa <exit>
      printf("%s: write bigfile failed\n", s);
    2136:	85d6                	mv	a1,s5
    2138:	00003517          	auipc	a0,0x3
    213c:	6d050513          	addi	a0,a0,1744 # 5808 <malloc+0x1020>
    2140:	00002097          	auipc	ra,0x2
    2144:	5ea080e7          	jalr	1514(ra) # 472a <printf>
      exit(1);
    2148:	4505                	li	a0,1
    214a:	00002097          	auipc	ra,0x2
    214e:	260080e7          	jalr	608(ra) # 43aa <exit>
    printf("%s: cannot open bigfile\n", s);
    2152:	85d6                	mv	a1,s5
    2154:	00003517          	auipc	a0,0x3
    2158:	6d450513          	addi	a0,a0,1748 # 5828 <malloc+0x1040>
    215c:	00002097          	auipc	ra,0x2
    2160:	5ce080e7          	jalr	1486(ra) # 472a <printf>
    exit(1);
    2164:	4505                	li	a0,1
    2166:	00002097          	auipc	ra,0x2
    216a:	244080e7          	jalr	580(ra) # 43aa <exit>
      printf("%s: read bigfile failed\n", s);
    216e:	85d6                	mv	a1,s5
    2170:	00003517          	auipc	a0,0x3
    2174:	6d850513          	addi	a0,a0,1752 # 5848 <malloc+0x1060>
    2178:	00002097          	auipc	ra,0x2
    217c:	5b2080e7          	jalr	1458(ra) # 472a <printf>
      exit(1);
    2180:	4505                	li	a0,1
    2182:	00002097          	auipc	ra,0x2
    2186:	228080e7          	jalr	552(ra) # 43aa <exit>
      printf("%s: short read bigfile\n", s);
    218a:	85d6                	mv	a1,s5
    218c:	00003517          	auipc	a0,0x3
    2190:	6dc50513          	addi	a0,a0,1756 # 5868 <malloc+0x1080>
    2194:	00002097          	auipc	ra,0x2
    2198:	596080e7          	jalr	1430(ra) # 472a <printf>
      exit(1);
    219c:	4505                	li	a0,1
    219e:	00002097          	auipc	ra,0x2
    21a2:	20c080e7          	jalr	524(ra) # 43aa <exit>
      printf("%s: read bigfile wrong data\n", s);
    21a6:	85d6                	mv	a1,s5
    21a8:	00003517          	auipc	a0,0x3
    21ac:	6d850513          	addi	a0,a0,1752 # 5880 <malloc+0x1098>
    21b0:	00002097          	auipc	ra,0x2
    21b4:	57a080e7          	jalr	1402(ra) # 472a <printf>
      exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00002097          	auipc	ra,0x2
    21be:	1f0080e7          	jalr	496(ra) # 43aa <exit>
  close(fd);
    21c2:	8552                	mv	a0,s4
    21c4:	00002097          	auipc	ra,0x2
    21c8:	20e080e7          	jalr	526(ra) # 43d2 <close>
  if(total != N*SZ){
    21cc:	678d                	lui	a5,0x3
    21ce:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x508>
    21d2:	02f99363          	bne	s3,a5,21f8 <bigfile+0x1c4>
  unlink("bigfile");
    21d6:	00003517          	auipc	a0,0x3
    21da:	95250513          	addi	a0,a0,-1710 # 4b28 <malloc+0x340>
    21de:	00002097          	auipc	ra,0x2
    21e2:	21c080e7          	jalr	540(ra) # 43fa <unlink>
}
    21e6:	70e2                	ld	ra,56(sp)
    21e8:	7442                	ld	s0,48(sp)
    21ea:	74a2                	ld	s1,40(sp)
    21ec:	7902                	ld	s2,32(sp)
    21ee:	69e2                	ld	s3,24(sp)
    21f0:	6a42                	ld	s4,16(sp)
    21f2:	6aa2                	ld	s5,8(sp)
    21f4:	6121                	addi	sp,sp,64
    21f6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    21f8:	85d6                	mv	a1,s5
    21fa:	00003517          	auipc	a0,0x3
    21fe:	6a650513          	addi	a0,a0,1702 # 58a0 <malloc+0x10b8>
    2202:	00002097          	auipc	ra,0x2
    2206:	528080e7          	jalr	1320(ra) # 472a <printf>
    exit(1);
    220a:	4505                	li	a0,1
    220c:	00002097          	auipc	ra,0x2
    2210:	19e080e7          	jalr	414(ra) # 43aa <exit>

0000000000002214 <linktest>:
{
    2214:	1101                	addi	sp,sp,-32
    2216:	ec06                	sd	ra,24(sp)
    2218:	e822                	sd	s0,16(sp)
    221a:	e426                	sd	s1,8(sp)
    221c:	e04a                	sd	s2,0(sp)
    221e:	1000                	addi	s0,sp,32
    2220:	892a                	mv	s2,a0
  unlink("lf1");
    2222:	00003517          	auipc	a0,0x3
    2226:	69e50513          	addi	a0,a0,1694 # 58c0 <malloc+0x10d8>
    222a:	00002097          	auipc	ra,0x2
    222e:	1d0080e7          	jalr	464(ra) # 43fa <unlink>
  unlink("lf2");
    2232:	00003517          	auipc	a0,0x3
    2236:	69650513          	addi	a0,a0,1686 # 58c8 <malloc+0x10e0>
    223a:	00002097          	auipc	ra,0x2
    223e:	1c0080e7          	jalr	448(ra) # 43fa <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    2242:	20200593          	li	a1,514
    2246:	00003517          	auipc	a0,0x3
    224a:	67a50513          	addi	a0,a0,1658 # 58c0 <malloc+0x10d8>
    224e:	00002097          	auipc	ra,0x2
    2252:	19c080e7          	jalr	412(ra) # 43ea <open>
  if(fd < 0){
    2256:	10054763          	bltz	a0,2364 <linktest+0x150>
    225a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    225c:	4615                	li	a2,5
    225e:	00003597          	auipc	a1,0x3
    2262:	15a58593          	addi	a1,a1,346 # 53b8 <malloc+0xbd0>
    2266:	00002097          	auipc	ra,0x2
    226a:	164080e7          	jalr	356(ra) # 43ca <write>
    226e:	4795                	li	a5,5
    2270:	10f51863          	bne	a0,a5,2380 <linktest+0x16c>
  close(fd);
    2274:	8526                	mv	a0,s1
    2276:	00002097          	auipc	ra,0x2
    227a:	15c080e7          	jalr	348(ra) # 43d2 <close>
  if(link("lf1", "lf2") < 0){
    227e:	00003597          	auipc	a1,0x3
    2282:	64a58593          	addi	a1,a1,1610 # 58c8 <malloc+0x10e0>
    2286:	00003517          	auipc	a0,0x3
    228a:	63a50513          	addi	a0,a0,1594 # 58c0 <malloc+0x10d8>
    228e:	00002097          	auipc	ra,0x2
    2292:	17c080e7          	jalr	380(ra) # 440a <link>
    2296:	10054363          	bltz	a0,239c <linktest+0x188>
  unlink("lf1");
    229a:	00003517          	auipc	a0,0x3
    229e:	62650513          	addi	a0,a0,1574 # 58c0 <malloc+0x10d8>
    22a2:	00002097          	auipc	ra,0x2
    22a6:	158080e7          	jalr	344(ra) # 43fa <unlink>
  if(open("lf1", 0) >= 0){
    22aa:	4581                	li	a1,0
    22ac:	00003517          	auipc	a0,0x3
    22b0:	61450513          	addi	a0,a0,1556 # 58c0 <malloc+0x10d8>
    22b4:	00002097          	auipc	ra,0x2
    22b8:	136080e7          	jalr	310(ra) # 43ea <open>
    22bc:	0e055e63          	bgez	a0,23b8 <linktest+0x1a4>
  fd = open("lf2", 0);
    22c0:	4581                	li	a1,0
    22c2:	00003517          	auipc	a0,0x3
    22c6:	60650513          	addi	a0,a0,1542 # 58c8 <malloc+0x10e0>
    22ca:	00002097          	auipc	ra,0x2
    22ce:	120080e7          	jalr	288(ra) # 43ea <open>
    22d2:	84aa                	mv	s1,a0
  if(fd < 0){
    22d4:	10054063          	bltz	a0,23d4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    22d8:	660d                	lui	a2,0x3
    22da:	00007597          	auipc	a1,0x7
    22de:	ece58593          	addi	a1,a1,-306 # 91a8 <buf>
    22e2:	00002097          	auipc	ra,0x2
    22e6:	0e0080e7          	jalr	224(ra) # 43c2 <read>
    22ea:	4795                	li	a5,5
    22ec:	10f51263          	bne	a0,a5,23f0 <linktest+0x1dc>
  close(fd);
    22f0:	8526                	mv	a0,s1
    22f2:	00002097          	auipc	ra,0x2
    22f6:	0e0080e7          	jalr	224(ra) # 43d2 <close>
  if(link("lf2", "lf2") >= 0){
    22fa:	00003597          	auipc	a1,0x3
    22fe:	5ce58593          	addi	a1,a1,1486 # 58c8 <malloc+0x10e0>
    2302:	852e                	mv	a0,a1
    2304:	00002097          	auipc	ra,0x2
    2308:	106080e7          	jalr	262(ra) # 440a <link>
    230c:	10055063          	bgez	a0,240c <linktest+0x1f8>
  unlink("lf2");
    2310:	00003517          	auipc	a0,0x3
    2314:	5b850513          	addi	a0,a0,1464 # 58c8 <malloc+0x10e0>
    2318:	00002097          	auipc	ra,0x2
    231c:	0e2080e7          	jalr	226(ra) # 43fa <unlink>
  if(link("lf2", "lf1") >= 0){
    2320:	00003597          	auipc	a1,0x3
    2324:	5a058593          	addi	a1,a1,1440 # 58c0 <malloc+0x10d8>
    2328:	00003517          	auipc	a0,0x3
    232c:	5a050513          	addi	a0,a0,1440 # 58c8 <malloc+0x10e0>
    2330:	00002097          	auipc	ra,0x2
    2334:	0da080e7          	jalr	218(ra) # 440a <link>
    2338:	0e055863          	bgez	a0,2428 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    233c:	00003597          	auipc	a1,0x3
    2340:	58458593          	addi	a1,a1,1412 # 58c0 <malloc+0x10d8>
    2344:	00003517          	auipc	a0,0x3
    2348:	8f450513          	addi	a0,a0,-1804 # 4c38 <malloc+0x450>
    234c:	00002097          	auipc	ra,0x2
    2350:	0be080e7          	jalr	190(ra) # 440a <link>
    2354:	0e055863          	bgez	a0,2444 <linktest+0x230>
}
    2358:	60e2                	ld	ra,24(sp)
    235a:	6442                	ld	s0,16(sp)
    235c:	64a2                	ld	s1,8(sp)
    235e:	6902                	ld	s2,0(sp)
    2360:	6105                	addi	sp,sp,32
    2362:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    2364:	85ca                	mv	a1,s2
    2366:	00003517          	auipc	a0,0x3
    236a:	56a50513          	addi	a0,a0,1386 # 58d0 <malloc+0x10e8>
    236e:	00002097          	auipc	ra,0x2
    2372:	3bc080e7          	jalr	956(ra) # 472a <printf>
    exit(1);
    2376:	4505                	li	a0,1
    2378:	00002097          	auipc	ra,0x2
    237c:	032080e7          	jalr	50(ra) # 43aa <exit>
    printf("%s: write lf1 failed\n", s);
    2380:	85ca                	mv	a1,s2
    2382:	00003517          	auipc	a0,0x3
    2386:	56650513          	addi	a0,a0,1382 # 58e8 <malloc+0x1100>
    238a:	00002097          	auipc	ra,0x2
    238e:	3a0080e7          	jalr	928(ra) # 472a <printf>
    exit(1);
    2392:	4505                	li	a0,1
    2394:	00002097          	auipc	ra,0x2
    2398:	016080e7          	jalr	22(ra) # 43aa <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    239c:	85ca                	mv	a1,s2
    239e:	00003517          	auipc	a0,0x3
    23a2:	56250513          	addi	a0,a0,1378 # 5900 <malloc+0x1118>
    23a6:	00002097          	auipc	ra,0x2
    23aa:	384080e7          	jalr	900(ra) # 472a <printf>
    exit(1);
    23ae:	4505                	li	a0,1
    23b0:	00002097          	auipc	ra,0x2
    23b4:	ffa080e7          	jalr	-6(ra) # 43aa <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    23b8:	85ca                	mv	a1,s2
    23ba:	00003517          	auipc	a0,0x3
    23be:	56650513          	addi	a0,a0,1382 # 5920 <malloc+0x1138>
    23c2:	00002097          	auipc	ra,0x2
    23c6:	368080e7          	jalr	872(ra) # 472a <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	00002097          	auipc	ra,0x2
    23d0:	fde080e7          	jalr	-34(ra) # 43aa <exit>
    printf("%s: open lf2 failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00003517          	auipc	a0,0x3
    23da:	57a50513          	addi	a0,a0,1402 # 5950 <malloc+0x1168>
    23de:	00002097          	auipc	ra,0x2
    23e2:	34c080e7          	jalr	844(ra) # 472a <printf>
    exit(1);
    23e6:	4505                	li	a0,1
    23e8:	00002097          	auipc	ra,0x2
    23ec:	fc2080e7          	jalr	-62(ra) # 43aa <exit>
    printf("%s: read lf2 failed\n", s);
    23f0:	85ca                	mv	a1,s2
    23f2:	00003517          	auipc	a0,0x3
    23f6:	57650513          	addi	a0,a0,1398 # 5968 <malloc+0x1180>
    23fa:	00002097          	auipc	ra,0x2
    23fe:	330080e7          	jalr	816(ra) # 472a <printf>
    exit(1);
    2402:	4505                	li	a0,1
    2404:	00002097          	auipc	ra,0x2
    2408:	fa6080e7          	jalr	-90(ra) # 43aa <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    240c:	85ca                	mv	a1,s2
    240e:	00003517          	auipc	a0,0x3
    2412:	57250513          	addi	a0,a0,1394 # 5980 <malloc+0x1198>
    2416:	00002097          	auipc	ra,0x2
    241a:	314080e7          	jalr	788(ra) # 472a <printf>
    exit(1);
    241e:	4505                	li	a0,1
    2420:	00002097          	auipc	ra,0x2
    2424:	f8a080e7          	jalr	-118(ra) # 43aa <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    2428:	85ca                	mv	a1,s2
    242a:	00003517          	auipc	a0,0x3
    242e:	57e50513          	addi	a0,a0,1406 # 59a8 <malloc+0x11c0>
    2432:	00002097          	auipc	ra,0x2
    2436:	2f8080e7          	jalr	760(ra) # 472a <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	00002097          	auipc	ra,0x2
    2440:	f6e080e7          	jalr	-146(ra) # 43aa <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    2444:	85ca                	mv	a1,s2
    2446:	00003517          	auipc	a0,0x3
    244a:	58a50513          	addi	a0,a0,1418 # 59d0 <malloc+0x11e8>
    244e:	00002097          	auipc	ra,0x2
    2452:	2dc080e7          	jalr	732(ra) # 472a <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00002097          	auipc	ra,0x2
    245c:	f52080e7          	jalr	-174(ra) # 43aa <exit>

0000000000002460 <concreate>:
{
    2460:	7135                	addi	sp,sp,-160
    2462:	ed06                	sd	ra,152(sp)
    2464:	e922                	sd	s0,144(sp)
    2466:	e526                	sd	s1,136(sp)
    2468:	e14a                	sd	s2,128(sp)
    246a:	fcce                	sd	s3,120(sp)
    246c:	f8d2                	sd	s4,112(sp)
    246e:	f4d6                	sd	s5,104(sp)
    2470:	f0da                	sd	s6,96(sp)
    2472:	ecde                	sd	s7,88(sp)
    2474:	1100                	addi	s0,sp,160
    2476:	89aa                	mv	s3,a0
  file[0] = 'C';
    2478:	04300793          	li	a5,67
    247c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    2480:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    2484:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    2486:	4b0d                	li	s6,3
    2488:	4a85                	li	s5,1
      link("C0", file);
    248a:	00003b97          	auipc	s7,0x3
    248e:	566b8b93          	addi	s7,s7,1382 # 59f0 <malloc+0x1208>
  for(i = 0; i < N; i++){
    2492:	02800a13          	li	s4,40
    2496:	a471                	j	2722 <concreate+0x2c2>
      link("C0", file);
    2498:	fa840593          	addi	a1,s0,-88
    249c:	855e                	mv	a0,s7
    249e:	00002097          	auipc	ra,0x2
    24a2:	f6c080e7          	jalr	-148(ra) # 440a <link>
    if(pid == 0) {
    24a6:	a48d                	j	2708 <concreate+0x2a8>
    } else if(pid == 0 && (i % 5) == 1){
    24a8:	4795                	li	a5,5
    24aa:	02f9693b          	remw	s2,s2,a5
    24ae:	4785                	li	a5,1
    24b0:	02f90b63          	beq	s2,a5,24e6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    24b4:	20200593          	li	a1,514
    24b8:	fa840513          	addi	a0,s0,-88
    24bc:	00002097          	auipc	ra,0x2
    24c0:	f2e080e7          	jalr	-210(ra) # 43ea <open>
      if(fd < 0){
    24c4:	22055963          	bgez	a0,26f6 <concreate+0x296>
        printf("concreate create %s failed\n", file);
    24c8:	fa840593          	addi	a1,s0,-88
    24cc:	00003517          	auipc	a0,0x3
    24d0:	52c50513          	addi	a0,a0,1324 # 59f8 <malloc+0x1210>
    24d4:	00002097          	auipc	ra,0x2
    24d8:	256080e7          	jalr	598(ra) # 472a <printf>
        exit(1);
    24dc:	4505                	li	a0,1
    24de:	00002097          	auipc	ra,0x2
    24e2:	ecc080e7          	jalr	-308(ra) # 43aa <exit>
      link("C0", file);
    24e6:	fa840593          	addi	a1,s0,-88
    24ea:	00003517          	auipc	a0,0x3
    24ee:	50650513          	addi	a0,a0,1286 # 59f0 <malloc+0x1208>
    24f2:	00002097          	auipc	ra,0x2
    24f6:	f18080e7          	jalr	-232(ra) # 440a <link>
      exit(0);
    24fa:	4501                	li	a0,0
    24fc:	00002097          	auipc	ra,0x2
    2500:	eae080e7          	jalr	-338(ra) # 43aa <exit>
        exit(1);
    2504:	4505                	li	a0,1
    2506:	00002097          	auipc	ra,0x2
    250a:	ea4080e7          	jalr	-348(ra) # 43aa <exit>
  memset(fa, 0, sizeof(fa));
    250e:	02800613          	li	a2,40
    2512:	4581                	li	a1,0
    2514:	f8040513          	addi	a0,s0,-128
    2518:	00002097          	auipc	ra,0x2
    251c:	d0e080e7          	jalr	-754(ra) # 4226 <memset>
  fd = open(".", 0);
    2520:	4581                	li	a1,0
    2522:	00002517          	auipc	a0,0x2
    2526:	71650513          	addi	a0,a0,1814 # 4c38 <malloc+0x450>
    252a:	00002097          	auipc	ra,0x2
    252e:	ec0080e7          	jalr	-320(ra) # 43ea <open>
    2532:	892a                	mv	s2,a0
  n = 0;
    2534:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2536:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    253a:	02700b13          	li	s6,39
      fa[i] = 1;
    253e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    2540:	a03d                	j	256e <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    2542:	f7240613          	addi	a2,s0,-142
    2546:	85ce                	mv	a1,s3
    2548:	00003517          	auipc	a0,0x3
    254c:	4d050513          	addi	a0,a0,1232 # 5a18 <malloc+0x1230>
    2550:	00002097          	auipc	ra,0x2
    2554:	1da080e7          	jalr	474(ra) # 472a <printf>
        exit(1);
    2558:	4505                	li	a0,1
    255a:	00002097          	auipc	ra,0x2
    255e:	e50080e7          	jalr	-432(ra) # 43aa <exit>
      fa[i] = 1;
    2562:	fb040793          	addi	a5,s0,-80
    2566:	973e                	add	a4,a4,a5
    2568:	fd770823          	sb	s7,-48(a4)
      n++;
    256c:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    256e:	4641                	li	a2,16
    2570:	f7040593          	addi	a1,s0,-144
    2574:	854a                	mv	a0,s2
    2576:	00002097          	auipc	ra,0x2
    257a:	e4c080e7          	jalr	-436(ra) # 43c2 <read>
    257e:	04a05a63          	blez	a0,25d2 <concreate+0x172>
    if(de.inum == 0)
    2582:	f7045783          	lhu	a5,-144(s0)
    2586:	d7e5                	beqz	a5,256e <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2588:	f7244783          	lbu	a5,-142(s0)
    258c:	ff4791e3          	bne	a5,s4,256e <concreate+0x10e>
    2590:	f7444783          	lbu	a5,-140(s0)
    2594:	ffe9                	bnez	a5,256e <concreate+0x10e>
      i = de.name[1] - '0';
    2596:	f7344783          	lbu	a5,-141(s0)
    259a:	fd07879b          	addiw	a5,a5,-48
    259e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    25a2:	faeb60e3          	bltu	s6,a4,2542 <concreate+0xe2>
      if(fa[i]){
    25a6:	fb040793          	addi	a5,s0,-80
    25aa:	97ba                	add	a5,a5,a4
    25ac:	fd07c783          	lbu	a5,-48(a5)
    25b0:	dbcd                	beqz	a5,2562 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    25b2:	f7240613          	addi	a2,s0,-142
    25b6:	85ce                	mv	a1,s3
    25b8:	00003517          	auipc	a0,0x3
    25bc:	48050513          	addi	a0,a0,1152 # 5a38 <malloc+0x1250>
    25c0:	00002097          	auipc	ra,0x2
    25c4:	16a080e7          	jalr	362(ra) # 472a <printf>
        exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00002097          	auipc	ra,0x2
    25ce:	de0080e7          	jalr	-544(ra) # 43aa <exit>
  close(fd);
    25d2:	854a                	mv	a0,s2
    25d4:	00002097          	auipc	ra,0x2
    25d8:	dfe080e7          	jalr	-514(ra) # 43d2 <close>
  if(n != N){
    25dc:	02800793          	li	a5,40
    25e0:	00fa9763          	bne	s5,a5,25ee <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    25e4:	4a8d                	li	s5,3
    25e6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    25e8:	02800a13          	li	s4,40
    25ec:	a05d                	j	2692 <concreate+0x232>
    printf("%s: concreate not enough files in directory listing\n", s);
    25ee:	85ce                	mv	a1,s3
    25f0:	00003517          	auipc	a0,0x3
    25f4:	47050513          	addi	a0,a0,1136 # 5a60 <malloc+0x1278>
    25f8:	00002097          	auipc	ra,0x2
    25fc:	132080e7          	jalr	306(ra) # 472a <printf>
    exit(1);
    2600:	4505                	li	a0,1
    2602:	00002097          	auipc	ra,0x2
    2606:	da8080e7          	jalr	-600(ra) # 43aa <exit>
      printf("%s: fork failed\n", s);
    260a:	85ce                	mv	a1,s3
    260c:	00002517          	auipc	a0,0x2
    2610:	6dc50513          	addi	a0,a0,1756 # 4ce8 <malloc+0x500>
    2614:	00002097          	auipc	ra,0x2
    2618:	116080e7          	jalr	278(ra) # 472a <printf>
      exit(1);
    261c:	4505                	li	a0,1
    261e:	00002097          	auipc	ra,0x2
    2622:	d8c080e7          	jalr	-628(ra) # 43aa <exit>
      close(open(file, 0));
    2626:	4581                	li	a1,0
    2628:	fa840513          	addi	a0,s0,-88
    262c:	00002097          	auipc	ra,0x2
    2630:	dbe080e7          	jalr	-578(ra) # 43ea <open>
    2634:	00002097          	auipc	ra,0x2
    2638:	d9e080e7          	jalr	-610(ra) # 43d2 <close>
      close(open(file, 0));
    263c:	4581                	li	a1,0
    263e:	fa840513          	addi	a0,s0,-88
    2642:	00002097          	auipc	ra,0x2
    2646:	da8080e7          	jalr	-600(ra) # 43ea <open>
    264a:	00002097          	auipc	ra,0x2
    264e:	d88080e7          	jalr	-632(ra) # 43d2 <close>
      close(open(file, 0));
    2652:	4581                	li	a1,0
    2654:	fa840513          	addi	a0,s0,-88
    2658:	00002097          	auipc	ra,0x2
    265c:	d92080e7          	jalr	-622(ra) # 43ea <open>
    2660:	00002097          	auipc	ra,0x2
    2664:	d72080e7          	jalr	-654(ra) # 43d2 <close>
      close(open(file, 0));
    2668:	4581                	li	a1,0
    266a:	fa840513          	addi	a0,s0,-88
    266e:	00002097          	auipc	ra,0x2
    2672:	d7c080e7          	jalr	-644(ra) # 43ea <open>
    2676:	00002097          	auipc	ra,0x2
    267a:	d5c080e7          	jalr	-676(ra) # 43d2 <close>
    if(pid == 0)
    267e:	06090763          	beqz	s2,26ec <concreate+0x28c>
      wait(0);
    2682:	4501                	li	a0,0
    2684:	00002097          	auipc	ra,0x2
    2688:	d2e080e7          	jalr	-722(ra) # 43b2 <wait>
  for(i = 0; i < N; i++){
    268c:	2485                	addiw	s1,s1,1
    268e:	0d448963          	beq	s1,s4,2760 <concreate+0x300>
    file[1] = '0' + i;
    2692:	0304879b          	addiw	a5,s1,48
    2696:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    269a:	00002097          	auipc	ra,0x2
    269e:	d08080e7          	jalr	-760(ra) # 43a2 <fork>
    26a2:	892a                	mv	s2,a0
    if(pid < 0){
    26a4:	f60543e3          	bltz	a0,260a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    26a8:	0354e73b          	remw	a4,s1,s5
    26ac:	00a767b3          	or	a5,a4,a0
    26b0:	2781                	sext.w	a5,a5
    26b2:	dbb5                	beqz	a5,2626 <concreate+0x1c6>
    26b4:	01671363          	bne	a4,s6,26ba <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
    26b8:	f53d                	bnez	a0,2626 <concreate+0x1c6>
      unlink(file);
    26ba:	fa840513          	addi	a0,s0,-88
    26be:	00002097          	auipc	ra,0x2
    26c2:	d3c080e7          	jalr	-708(ra) # 43fa <unlink>
      unlink(file);
    26c6:	fa840513          	addi	a0,s0,-88
    26ca:	00002097          	auipc	ra,0x2
    26ce:	d30080e7          	jalr	-720(ra) # 43fa <unlink>
      unlink(file);
    26d2:	fa840513          	addi	a0,s0,-88
    26d6:	00002097          	auipc	ra,0x2
    26da:	d24080e7          	jalr	-732(ra) # 43fa <unlink>
      unlink(file);
    26de:	fa840513          	addi	a0,s0,-88
    26e2:	00002097          	auipc	ra,0x2
    26e6:	d18080e7          	jalr	-744(ra) # 43fa <unlink>
    26ea:	bf51                	j	267e <concreate+0x21e>
      exit(0);
    26ec:	4501                	li	a0,0
    26ee:	00002097          	auipc	ra,0x2
    26f2:	cbc080e7          	jalr	-836(ra) # 43aa <exit>
      close(fd);
    26f6:	00002097          	auipc	ra,0x2
    26fa:	cdc080e7          	jalr	-804(ra) # 43d2 <close>
    if(pid == 0) {
    26fe:	bbf5                	j	24fa <concreate+0x9a>
      close(fd);
    2700:	00002097          	auipc	ra,0x2
    2704:	cd2080e7          	jalr	-814(ra) # 43d2 <close>
      wait(&xstatus);
    2708:	f6c40513          	addi	a0,s0,-148
    270c:	00002097          	auipc	ra,0x2
    2710:	ca6080e7          	jalr	-858(ra) # 43b2 <wait>
      if(xstatus != 0)
    2714:	f6c42483          	lw	s1,-148(s0)
    2718:	de0496e3          	bnez	s1,2504 <concreate+0xa4>
  for(i = 0; i < N; i++){
    271c:	2905                	addiw	s2,s2,1
    271e:	df4908e3          	beq	s2,s4,250e <concreate+0xae>
    file[1] = '0' + i;
    2722:	0309079b          	addiw	a5,s2,48
    2726:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    272a:	fa840513          	addi	a0,s0,-88
    272e:	00002097          	auipc	ra,0x2
    2732:	ccc080e7          	jalr	-820(ra) # 43fa <unlink>
    pid = fork();
    2736:	00002097          	auipc	ra,0x2
    273a:	c6c080e7          	jalr	-916(ra) # 43a2 <fork>
    if(pid && (i % 3) == 1){
    273e:	d60505e3          	beqz	a0,24a8 <concreate+0x48>
    2742:	036967bb          	remw	a5,s2,s6
    2746:	d55789e3          	beq	a5,s5,2498 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    274a:	20200593          	li	a1,514
    274e:	fa840513          	addi	a0,s0,-88
    2752:	00002097          	auipc	ra,0x2
    2756:	c98080e7          	jalr	-872(ra) # 43ea <open>
      if(fd < 0){
    275a:	fa0553e3          	bgez	a0,2700 <concreate+0x2a0>
    275e:	b3ad                	j	24c8 <concreate+0x68>
}
    2760:	60ea                	ld	ra,152(sp)
    2762:	644a                	ld	s0,144(sp)
    2764:	64aa                	ld	s1,136(sp)
    2766:	690a                	ld	s2,128(sp)
    2768:	79e6                	ld	s3,120(sp)
    276a:	7a46                	ld	s4,112(sp)
    276c:	7aa6                	ld	s5,104(sp)
    276e:	7b06                	ld	s6,96(sp)
    2770:	6be6                	ld	s7,88(sp)
    2772:	610d                	addi	sp,sp,160
    2774:	8082                	ret

0000000000002776 <linkunlink>:
{
    2776:	711d                	addi	sp,sp,-96
    2778:	ec86                	sd	ra,88(sp)
    277a:	e8a2                	sd	s0,80(sp)
    277c:	e4a6                	sd	s1,72(sp)
    277e:	e0ca                	sd	s2,64(sp)
    2780:	fc4e                	sd	s3,56(sp)
    2782:	f852                	sd	s4,48(sp)
    2784:	f456                	sd	s5,40(sp)
    2786:	f05a                	sd	s6,32(sp)
    2788:	ec5e                	sd	s7,24(sp)
    278a:	e862                	sd	s8,16(sp)
    278c:	e466                	sd	s9,8(sp)
    278e:	1080                	addi	s0,sp,96
    2790:	84aa                	mv	s1,a0
  unlink("x");
    2792:	00003517          	auipc	a0,0x3
    2796:	f0650513          	addi	a0,a0,-250 # 5698 <malloc+0xeb0>
    279a:	00002097          	auipc	ra,0x2
    279e:	c60080e7          	jalr	-928(ra) # 43fa <unlink>
  pid = fork();
    27a2:	00002097          	auipc	ra,0x2
    27a6:	c00080e7          	jalr	-1024(ra) # 43a2 <fork>
  if(pid < 0){
    27aa:	02054b63          	bltz	a0,27e0 <linkunlink+0x6a>
    27ae:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    27b0:	4c85                	li	s9,1
    27b2:	e119                	bnez	a0,27b8 <linkunlink+0x42>
    27b4:	06100c93          	li	s9,97
    27b8:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    27bc:	41c659b7          	lui	s3,0x41c65
    27c0:	e6d9899b          	addiw	s3,s3,-403
    27c4:	690d                	lui	s2,0x3
    27c6:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    27ca:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    27cc:	4b05                	li	s6,1
      unlink("x");
    27ce:	00003a97          	auipc	s5,0x3
    27d2:	ecaa8a93          	addi	s5,s5,-310 # 5698 <malloc+0xeb0>
      link("cat", "x");
    27d6:	00003b97          	auipc	s7,0x3
    27da:	2c2b8b93          	addi	s7,s7,706 # 5a98 <malloc+0x12b0>
    27de:	a091                	j	2822 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    27e0:	85a6                	mv	a1,s1
    27e2:	00002517          	auipc	a0,0x2
    27e6:	50650513          	addi	a0,a0,1286 # 4ce8 <malloc+0x500>
    27ea:	00002097          	auipc	ra,0x2
    27ee:	f40080e7          	jalr	-192(ra) # 472a <printf>
    exit(1);
    27f2:	4505                	li	a0,1
    27f4:	00002097          	auipc	ra,0x2
    27f8:	bb6080e7          	jalr	-1098(ra) # 43aa <exit>
      close(open("x", O_RDWR | O_CREATE));
    27fc:	20200593          	li	a1,514
    2800:	8556                	mv	a0,s5
    2802:	00002097          	auipc	ra,0x2
    2806:	be8080e7          	jalr	-1048(ra) # 43ea <open>
    280a:	00002097          	auipc	ra,0x2
    280e:	bc8080e7          	jalr	-1080(ra) # 43d2 <close>
    2812:	a031                	j	281e <linkunlink+0xa8>
      unlink("x");
    2814:	8556                	mv	a0,s5
    2816:	00002097          	auipc	ra,0x2
    281a:	be4080e7          	jalr	-1052(ra) # 43fa <unlink>
  for(i = 0; i < 100; i++){
    281e:	34fd                	addiw	s1,s1,-1
    2820:	c09d                	beqz	s1,2846 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2822:	033c87bb          	mulw	a5,s9,s3
    2826:	012787bb          	addw	a5,a5,s2
    282a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    282e:	0347f7bb          	remuw	a5,a5,s4
    2832:	d7e9                	beqz	a5,27fc <linkunlink+0x86>
    } else if((x % 3) == 1){
    2834:	ff6790e3          	bne	a5,s6,2814 <linkunlink+0x9e>
      link("cat", "x");
    2838:	85d6                	mv	a1,s5
    283a:	855e                	mv	a0,s7
    283c:	00002097          	auipc	ra,0x2
    2840:	bce080e7          	jalr	-1074(ra) # 440a <link>
    2844:	bfe9                	j	281e <linkunlink+0xa8>
  if(pid)
    2846:	020c0463          	beqz	s8,286e <linkunlink+0xf8>
    wait(0);
    284a:	4501                	li	a0,0
    284c:	00002097          	auipc	ra,0x2
    2850:	b66080e7          	jalr	-1178(ra) # 43b2 <wait>
}
    2854:	60e6                	ld	ra,88(sp)
    2856:	6446                	ld	s0,80(sp)
    2858:	64a6                	ld	s1,72(sp)
    285a:	6906                	ld	s2,64(sp)
    285c:	79e2                	ld	s3,56(sp)
    285e:	7a42                	ld	s4,48(sp)
    2860:	7aa2                	ld	s5,40(sp)
    2862:	7b02                	ld	s6,32(sp)
    2864:	6be2                	ld	s7,24(sp)
    2866:	6c42                	ld	s8,16(sp)
    2868:	6ca2                	ld	s9,8(sp)
    286a:	6125                	addi	sp,sp,96
    286c:	8082                	ret
    exit(0);
    286e:	4501                	li	a0,0
    2870:	00002097          	auipc	ra,0x2
    2874:	b3a080e7          	jalr	-1222(ra) # 43aa <exit>

0000000000002878 <bigdir>:
{
    2878:	715d                	addi	sp,sp,-80
    287a:	e486                	sd	ra,72(sp)
    287c:	e0a2                	sd	s0,64(sp)
    287e:	fc26                	sd	s1,56(sp)
    2880:	f84a                	sd	s2,48(sp)
    2882:	f44e                	sd	s3,40(sp)
    2884:	f052                	sd	s4,32(sp)
    2886:	ec56                	sd	s5,24(sp)
    2888:	e85a                	sd	s6,16(sp)
    288a:	0880                	addi	s0,sp,80
    288c:	89aa                	mv	s3,a0
  unlink("bd");
    288e:	00003517          	auipc	a0,0x3
    2892:	21250513          	addi	a0,a0,530 # 5aa0 <malloc+0x12b8>
    2896:	00002097          	auipc	ra,0x2
    289a:	b64080e7          	jalr	-1180(ra) # 43fa <unlink>
  fd = open("bd", O_CREATE);
    289e:	20000593          	li	a1,512
    28a2:	00003517          	auipc	a0,0x3
    28a6:	1fe50513          	addi	a0,a0,510 # 5aa0 <malloc+0x12b8>
    28aa:	00002097          	auipc	ra,0x2
    28ae:	b40080e7          	jalr	-1216(ra) # 43ea <open>
  if(fd < 0){
    28b2:	0c054963          	bltz	a0,2984 <bigdir+0x10c>
  close(fd);
    28b6:	00002097          	auipc	ra,0x2
    28ba:	b1c080e7          	jalr	-1252(ra) # 43d2 <close>
  for(i = 0; i < N; i++){
    28be:	4901                	li	s2,0
    name[0] = 'x';
    28c0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    28c4:	00003a17          	auipc	s4,0x3
    28c8:	1dca0a13          	addi	s4,s4,476 # 5aa0 <malloc+0x12b8>
  for(i = 0; i < N; i++){
    28cc:	1f400b13          	li	s6,500
    name[0] = 'x';
    28d0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    28d4:	41f9579b          	sraiw	a5,s2,0x1f
    28d8:	01a7d71b          	srliw	a4,a5,0x1a
    28dc:	012707bb          	addw	a5,a4,s2
    28e0:	4067d69b          	sraiw	a3,a5,0x6
    28e4:	0306869b          	addiw	a3,a3,48
    28e8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    28ec:	03f7f793          	andi	a5,a5,63
    28f0:	9f99                	subw	a5,a5,a4
    28f2:	0307879b          	addiw	a5,a5,48
    28f6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    28fa:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    28fe:	fb040593          	addi	a1,s0,-80
    2902:	8552                	mv	a0,s4
    2904:	00002097          	auipc	ra,0x2
    2908:	b06080e7          	jalr	-1274(ra) # 440a <link>
    290c:	84aa                	mv	s1,a0
    290e:	e949                	bnez	a0,29a0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    2910:	2905                	addiw	s2,s2,1
    2912:	fb691fe3          	bne	s2,s6,28d0 <bigdir+0x58>
  unlink("bd");
    2916:	00003517          	auipc	a0,0x3
    291a:	18a50513          	addi	a0,a0,394 # 5aa0 <malloc+0x12b8>
    291e:	00002097          	auipc	ra,0x2
    2922:	adc080e7          	jalr	-1316(ra) # 43fa <unlink>
    name[0] = 'x';
    2926:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    292a:	1f400a13          	li	s4,500
    name[0] = 'x';
    292e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    2932:	41f4d79b          	sraiw	a5,s1,0x1f
    2936:	01a7d71b          	srliw	a4,a5,0x1a
    293a:	009707bb          	addw	a5,a4,s1
    293e:	4067d69b          	sraiw	a3,a5,0x6
    2942:	0306869b          	addiw	a3,a3,48
    2946:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    294a:	03f7f793          	andi	a5,a5,63
    294e:	9f99                	subw	a5,a5,a4
    2950:	0307879b          	addiw	a5,a5,48
    2954:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    2958:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    295c:	fb040513          	addi	a0,s0,-80
    2960:	00002097          	auipc	ra,0x2
    2964:	a9a080e7          	jalr	-1382(ra) # 43fa <unlink>
    2968:	e931                	bnez	a0,29bc <bigdir+0x144>
  for(i = 0; i < N; i++){
    296a:	2485                	addiw	s1,s1,1
    296c:	fd4491e3          	bne	s1,s4,292e <bigdir+0xb6>
}
    2970:	60a6                	ld	ra,72(sp)
    2972:	6406                	ld	s0,64(sp)
    2974:	74e2                	ld	s1,56(sp)
    2976:	7942                	ld	s2,48(sp)
    2978:	79a2                	ld	s3,40(sp)
    297a:	7a02                	ld	s4,32(sp)
    297c:	6ae2                	ld	s5,24(sp)
    297e:	6b42                	ld	s6,16(sp)
    2980:	6161                	addi	sp,sp,80
    2982:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    2984:	85ce                	mv	a1,s3
    2986:	00003517          	auipc	a0,0x3
    298a:	12250513          	addi	a0,a0,290 # 5aa8 <malloc+0x12c0>
    298e:	00002097          	auipc	ra,0x2
    2992:	d9c080e7          	jalr	-612(ra) # 472a <printf>
    exit(1);
    2996:	4505                	li	a0,1
    2998:	00002097          	auipc	ra,0x2
    299c:	a12080e7          	jalr	-1518(ra) # 43aa <exit>
      printf("%s: bigdir link failed\n", s);
    29a0:	85ce                	mv	a1,s3
    29a2:	00003517          	auipc	a0,0x3
    29a6:	12650513          	addi	a0,a0,294 # 5ac8 <malloc+0x12e0>
    29aa:	00002097          	auipc	ra,0x2
    29ae:	d80080e7          	jalr	-640(ra) # 472a <printf>
      exit(1);
    29b2:	4505                	li	a0,1
    29b4:	00002097          	auipc	ra,0x2
    29b8:	9f6080e7          	jalr	-1546(ra) # 43aa <exit>
      printf("%s: bigdir unlink failed", s);
    29bc:	85ce                	mv	a1,s3
    29be:	00003517          	auipc	a0,0x3
    29c2:	12250513          	addi	a0,a0,290 # 5ae0 <malloc+0x12f8>
    29c6:	00002097          	auipc	ra,0x2
    29ca:	d64080e7          	jalr	-668(ra) # 472a <printf>
      exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00002097          	auipc	ra,0x2
    29d4:	9da080e7          	jalr	-1574(ra) # 43aa <exit>

00000000000029d8 <subdir>:
{
    29d8:	1101                	addi	sp,sp,-32
    29da:	ec06                	sd	ra,24(sp)
    29dc:	e822                	sd	s0,16(sp)
    29de:	e426                	sd	s1,8(sp)
    29e0:	e04a                	sd	s2,0(sp)
    29e2:	1000                	addi	s0,sp,32
    29e4:	892a                	mv	s2,a0
  unlink("ff");
    29e6:	00003517          	auipc	a0,0x3
    29ea:	24a50513          	addi	a0,a0,586 # 5c30 <malloc+0x1448>
    29ee:	00002097          	auipc	ra,0x2
    29f2:	a0c080e7          	jalr	-1524(ra) # 43fa <unlink>
  if(mkdir("dd") != 0){
    29f6:	00003517          	auipc	a0,0x3
    29fa:	10a50513          	addi	a0,a0,266 # 5b00 <malloc+0x1318>
    29fe:	00002097          	auipc	ra,0x2
    2a02:	a14080e7          	jalr	-1516(ra) # 4412 <mkdir>
    2a06:	38051663          	bnez	a0,2d92 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2a0a:	20200593          	li	a1,514
    2a0e:	00003517          	auipc	a0,0x3
    2a12:	11250513          	addi	a0,a0,274 # 5b20 <malloc+0x1338>
    2a16:	00002097          	auipc	ra,0x2
    2a1a:	9d4080e7          	jalr	-1580(ra) # 43ea <open>
    2a1e:	84aa                	mv	s1,a0
  if(fd < 0){
    2a20:	38054763          	bltz	a0,2dae <subdir+0x3d6>
  write(fd, "ff", 2);
    2a24:	4609                	li	a2,2
    2a26:	00003597          	auipc	a1,0x3
    2a2a:	20a58593          	addi	a1,a1,522 # 5c30 <malloc+0x1448>
    2a2e:	00002097          	auipc	ra,0x2
    2a32:	99c080e7          	jalr	-1636(ra) # 43ca <write>
  close(fd);
    2a36:	8526                	mv	a0,s1
    2a38:	00002097          	auipc	ra,0x2
    2a3c:	99a080e7          	jalr	-1638(ra) # 43d2 <close>
  if(unlink("dd") >= 0){
    2a40:	00003517          	auipc	a0,0x3
    2a44:	0c050513          	addi	a0,a0,192 # 5b00 <malloc+0x1318>
    2a48:	00002097          	auipc	ra,0x2
    2a4c:	9b2080e7          	jalr	-1614(ra) # 43fa <unlink>
    2a50:	36055d63          	bgez	a0,2dca <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2a54:	00003517          	auipc	a0,0x3
    2a58:	12450513          	addi	a0,a0,292 # 5b78 <malloc+0x1390>
    2a5c:	00002097          	auipc	ra,0x2
    2a60:	9b6080e7          	jalr	-1610(ra) # 4412 <mkdir>
    2a64:	38051163          	bnez	a0,2de6 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2a68:	20200593          	li	a1,514
    2a6c:	00003517          	auipc	a0,0x3
    2a70:	13450513          	addi	a0,a0,308 # 5ba0 <malloc+0x13b8>
    2a74:	00002097          	auipc	ra,0x2
    2a78:	976080e7          	jalr	-1674(ra) # 43ea <open>
    2a7c:	84aa                	mv	s1,a0
  if(fd < 0){
    2a7e:	38054263          	bltz	a0,2e02 <subdir+0x42a>
  write(fd, "FF", 2);
    2a82:	4609                	li	a2,2
    2a84:	00003597          	auipc	a1,0x3
    2a88:	14c58593          	addi	a1,a1,332 # 5bd0 <malloc+0x13e8>
    2a8c:	00002097          	auipc	ra,0x2
    2a90:	93e080e7          	jalr	-1730(ra) # 43ca <write>
  close(fd);
    2a94:	8526                	mv	a0,s1
    2a96:	00002097          	auipc	ra,0x2
    2a9a:	93c080e7          	jalr	-1732(ra) # 43d2 <close>
  fd = open("dd/dd/../ff", 0);
    2a9e:	4581                	li	a1,0
    2aa0:	00003517          	auipc	a0,0x3
    2aa4:	13850513          	addi	a0,a0,312 # 5bd8 <malloc+0x13f0>
    2aa8:	00002097          	auipc	ra,0x2
    2aac:	942080e7          	jalr	-1726(ra) # 43ea <open>
    2ab0:	84aa                	mv	s1,a0
  if(fd < 0){
    2ab2:	36054663          	bltz	a0,2e1e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2ab6:	660d                	lui	a2,0x3
    2ab8:	00006597          	auipc	a1,0x6
    2abc:	6f058593          	addi	a1,a1,1776 # 91a8 <buf>
    2ac0:	00002097          	auipc	ra,0x2
    2ac4:	902080e7          	jalr	-1790(ra) # 43c2 <read>
  if(cc != 2 || buf[0] != 'f'){
    2ac8:	4789                	li	a5,2
    2aca:	36f51863          	bne	a0,a5,2e3a <subdir+0x462>
    2ace:	00006717          	auipc	a4,0x6
    2ad2:	6da74703          	lbu	a4,1754(a4) # 91a8 <buf>
    2ad6:	06600793          	li	a5,102
    2ada:	36f71063          	bne	a4,a5,2e3a <subdir+0x462>
  close(fd);
    2ade:	8526                	mv	a0,s1
    2ae0:	00002097          	auipc	ra,0x2
    2ae4:	8f2080e7          	jalr	-1806(ra) # 43d2 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ae8:	00003597          	auipc	a1,0x3
    2aec:	14058593          	addi	a1,a1,320 # 5c28 <malloc+0x1440>
    2af0:	00003517          	auipc	a0,0x3
    2af4:	0b050513          	addi	a0,a0,176 # 5ba0 <malloc+0x13b8>
    2af8:	00002097          	auipc	ra,0x2
    2afc:	912080e7          	jalr	-1774(ra) # 440a <link>
    2b00:	34051b63          	bnez	a0,2e56 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2b04:	00003517          	auipc	a0,0x3
    2b08:	09c50513          	addi	a0,a0,156 # 5ba0 <malloc+0x13b8>
    2b0c:	00002097          	auipc	ra,0x2
    2b10:	8ee080e7          	jalr	-1810(ra) # 43fa <unlink>
    2b14:	34051f63          	bnez	a0,2e72 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2b18:	4581                	li	a1,0
    2b1a:	00003517          	auipc	a0,0x3
    2b1e:	08650513          	addi	a0,a0,134 # 5ba0 <malloc+0x13b8>
    2b22:	00002097          	auipc	ra,0x2
    2b26:	8c8080e7          	jalr	-1848(ra) # 43ea <open>
    2b2a:	36055263          	bgez	a0,2e8e <subdir+0x4b6>
  if(chdir("dd") != 0){
    2b2e:	00003517          	auipc	a0,0x3
    2b32:	fd250513          	addi	a0,a0,-46 # 5b00 <malloc+0x1318>
    2b36:	00002097          	auipc	ra,0x2
    2b3a:	8e4080e7          	jalr	-1820(ra) # 441a <chdir>
    2b3e:	36051663          	bnez	a0,2eaa <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2b42:	00003517          	auipc	a0,0x3
    2b46:	17e50513          	addi	a0,a0,382 # 5cc0 <malloc+0x14d8>
    2b4a:	00002097          	auipc	ra,0x2
    2b4e:	8d0080e7          	jalr	-1840(ra) # 441a <chdir>
    2b52:	36051a63          	bnez	a0,2ec6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2b56:	00003517          	auipc	a0,0x3
    2b5a:	19a50513          	addi	a0,a0,410 # 5cf0 <malloc+0x1508>
    2b5e:	00002097          	auipc	ra,0x2
    2b62:	8bc080e7          	jalr	-1860(ra) # 441a <chdir>
    2b66:	36051e63          	bnez	a0,2ee2 <subdir+0x50a>
  if(chdir("./..") != 0){
    2b6a:	00003517          	auipc	a0,0x3
    2b6e:	1b650513          	addi	a0,a0,438 # 5d20 <malloc+0x1538>
    2b72:	00002097          	auipc	ra,0x2
    2b76:	8a8080e7          	jalr	-1880(ra) # 441a <chdir>
    2b7a:	38051263          	bnez	a0,2efe <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2b7e:	4581                	li	a1,0
    2b80:	00003517          	auipc	a0,0x3
    2b84:	0a850513          	addi	a0,a0,168 # 5c28 <malloc+0x1440>
    2b88:	00002097          	auipc	ra,0x2
    2b8c:	862080e7          	jalr	-1950(ra) # 43ea <open>
    2b90:	84aa                	mv	s1,a0
  if(fd < 0){
    2b92:	38054463          	bltz	a0,2f1a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2b96:	660d                	lui	a2,0x3
    2b98:	00006597          	auipc	a1,0x6
    2b9c:	61058593          	addi	a1,a1,1552 # 91a8 <buf>
    2ba0:	00002097          	auipc	ra,0x2
    2ba4:	822080e7          	jalr	-2014(ra) # 43c2 <read>
    2ba8:	4789                	li	a5,2
    2baa:	38f51663          	bne	a0,a5,2f36 <subdir+0x55e>
  close(fd);
    2bae:	8526                	mv	a0,s1
    2bb0:	00002097          	auipc	ra,0x2
    2bb4:	822080e7          	jalr	-2014(ra) # 43d2 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2bb8:	4581                	li	a1,0
    2bba:	00003517          	auipc	a0,0x3
    2bbe:	fe650513          	addi	a0,a0,-26 # 5ba0 <malloc+0x13b8>
    2bc2:	00002097          	auipc	ra,0x2
    2bc6:	828080e7          	jalr	-2008(ra) # 43ea <open>
    2bca:	38055463          	bgez	a0,2f52 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2bce:	20200593          	li	a1,514
    2bd2:	00003517          	auipc	a0,0x3
    2bd6:	1de50513          	addi	a0,a0,478 # 5db0 <malloc+0x15c8>
    2bda:	00002097          	auipc	ra,0x2
    2bde:	810080e7          	jalr	-2032(ra) # 43ea <open>
    2be2:	38055663          	bgez	a0,2f6e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2be6:	20200593          	li	a1,514
    2bea:	00003517          	auipc	a0,0x3
    2bee:	1f650513          	addi	a0,a0,502 # 5de0 <malloc+0x15f8>
    2bf2:	00001097          	auipc	ra,0x1
    2bf6:	7f8080e7          	jalr	2040(ra) # 43ea <open>
    2bfa:	38055863          	bgez	a0,2f8a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2bfe:	20000593          	li	a1,512
    2c02:	00003517          	auipc	a0,0x3
    2c06:	efe50513          	addi	a0,a0,-258 # 5b00 <malloc+0x1318>
    2c0a:	00001097          	auipc	ra,0x1
    2c0e:	7e0080e7          	jalr	2016(ra) # 43ea <open>
    2c12:	38055a63          	bgez	a0,2fa6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2c16:	4589                	li	a1,2
    2c18:	00003517          	auipc	a0,0x3
    2c1c:	ee850513          	addi	a0,a0,-280 # 5b00 <malloc+0x1318>
    2c20:	00001097          	auipc	ra,0x1
    2c24:	7ca080e7          	jalr	1994(ra) # 43ea <open>
    2c28:	38055d63          	bgez	a0,2fc2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2c2c:	4585                	li	a1,1
    2c2e:	00003517          	auipc	a0,0x3
    2c32:	ed250513          	addi	a0,a0,-302 # 5b00 <malloc+0x1318>
    2c36:	00001097          	auipc	ra,0x1
    2c3a:	7b4080e7          	jalr	1972(ra) # 43ea <open>
    2c3e:	3a055063          	bgez	a0,2fde <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2c42:	00003597          	auipc	a1,0x3
    2c46:	22e58593          	addi	a1,a1,558 # 5e70 <malloc+0x1688>
    2c4a:	00003517          	auipc	a0,0x3
    2c4e:	16650513          	addi	a0,a0,358 # 5db0 <malloc+0x15c8>
    2c52:	00001097          	auipc	ra,0x1
    2c56:	7b8080e7          	jalr	1976(ra) # 440a <link>
    2c5a:	3a050063          	beqz	a0,2ffa <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2c5e:	00003597          	auipc	a1,0x3
    2c62:	21258593          	addi	a1,a1,530 # 5e70 <malloc+0x1688>
    2c66:	00003517          	auipc	a0,0x3
    2c6a:	17a50513          	addi	a0,a0,378 # 5de0 <malloc+0x15f8>
    2c6e:	00001097          	auipc	ra,0x1
    2c72:	79c080e7          	jalr	1948(ra) # 440a <link>
    2c76:	3a050063          	beqz	a0,3016 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2c7a:	00003597          	auipc	a1,0x3
    2c7e:	fae58593          	addi	a1,a1,-82 # 5c28 <malloc+0x1440>
    2c82:	00003517          	auipc	a0,0x3
    2c86:	e9e50513          	addi	a0,a0,-354 # 5b20 <malloc+0x1338>
    2c8a:	00001097          	auipc	ra,0x1
    2c8e:	780080e7          	jalr	1920(ra) # 440a <link>
    2c92:	3a050063          	beqz	a0,3032 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2c96:	00003517          	auipc	a0,0x3
    2c9a:	11a50513          	addi	a0,a0,282 # 5db0 <malloc+0x15c8>
    2c9e:	00001097          	auipc	ra,0x1
    2ca2:	774080e7          	jalr	1908(ra) # 4412 <mkdir>
    2ca6:	3a050463          	beqz	a0,304e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2caa:	00003517          	auipc	a0,0x3
    2cae:	13650513          	addi	a0,a0,310 # 5de0 <malloc+0x15f8>
    2cb2:	00001097          	auipc	ra,0x1
    2cb6:	760080e7          	jalr	1888(ra) # 4412 <mkdir>
    2cba:	3a050863          	beqz	a0,306a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2cbe:	00003517          	auipc	a0,0x3
    2cc2:	f6a50513          	addi	a0,a0,-150 # 5c28 <malloc+0x1440>
    2cc6:	00001097          	auipc	ra,0x1
    2cca:	74c080e7          	jalr	1868(ra) # 4412 <mkdir>
    2cce:	3a050c63          	beqz	a0,3086 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2cd2:	00003517          	auipc	a0,0x3
    2cd6:	10e50513          	addi	a0,a0,270 # 5de0 <malloc+0x15f8>
    2cda:	00001097          	auipc	ra,0x1
    2cde:	720080e7          	jalr	1824(ra) # 43fa <unlink>
    2ce2:	3c050063          	beqz	a0,30a2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2ce6:	00003517          	auipc	a0,0x3
    2cea:	0ca50513          	addi	a0,a0,202 # 5db0 <malloc+0x15c8>
    2cee:	00001097          	auipc	ra,0x1
    2cf2:	70c080e7          	jalr	1804(ra) # 43fa <unlink>
    2cf6:	3c050463          	beqz	a0,30be <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2cfa:	00003517          	auipc	a0,0x3
    2cfe:	e2650513          	addi	a0,a0,-474 # 5b20 <malloc+0x1338>
    2d02:	00001097          	auipc	ra,0x1
    2d06:	718080e7          	jalr	1816(ra) # 441a <chdir>
    2d0a:	3c050863          	beqz	a0,30da <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2d0e:	00003517          	auipc	a0,0x3
    2d12:	2b250513          	addi	a0,a0,690 # 5fc0 <malloc+0x17d8>
    2d16:	00001097          	auipc	ra,0x1
    2d1a:	704080e7          	jalr	1796(ra) # 441a <chdir>
    2d1e:	3c050c63          	beqz	a0,30f6 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    2d22:	00003517          	auipc	a0,0x3
    2d26:	f0650513          	addi	a0,a0,-250 # 5c28 <malloc+0x1440>
    2d2a:	00001097          	auipc	ra,0x1
    2d2e:	6d0080e7          	jalr	1744(ra) # 43fa <unlink>
    2d32:	3e051063          	bnez	a0,3112 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    2d36:	00003517          	auipc	a0,0x3
    2d3a:	dea50513          	addi	a0,a0,-534 # 5b20 <malloc+0x1338>
    2d3e:	00001097          	auipc	ra,0x1
    2d42:	6bc080e7          	jalr	1724(ra) # 43fa <unlink>
    2d46:	3e051463          	bnez	a0,312e <subdir+0x756>
  if(unlink("dd") == 0){
    2d4a:	00003517          	auipc	a0,0x3
    2d4e:	db650513          	addi	a0,a0,-586 # 5b00 <malloc+0x1318>
    2d52:	00001097          	auipc	ra,0x1
    2d56:	6a8080e7          	jalr	1704(ra) # 43fa <unlink>
    2d5a:	3e050863          	beqz	a0,314a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2d5e:	00003517          	auipc	a0,0x3
    2d62:	2d250513          	addi	a0,a0,722 # 6030 <malloc+0x1848>
    2d66:	00001097          	auipc	ra,0x1
    2d6a:	694080e7          	jalr	1684(ra) # 43fa <unlink>
    2d6e:	3e054c63          	bltz	a0,3166 <subdir+0x78e>
  if(unlink("dd") < 0){
    2d72:	00003517          	auipc	a0,0x3
    2d76:	d8e50513          	addi	a0,a0,-626 # 5b00 <malloc+0x1318>
    2d7a:	00001097          	auipc	ra,0x1
    2d7e:	680080e7          	jalr	1664(ra) # 43fa <unlink>
    2d82:	40054063          	bltz	a0,3182 <subdir+0x7aa>
}
    2d86:	60e2                	ld	ra,24(sp)
    2d88:	6442                	ld	s0,16(sp)
    2d8a:	64a2                	ld	s1,8(sp)
    2d8c:	6902                	ld	s2,0(sp)
    2d8e:	6105                	addi	sp,sp,32
    2d90:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2d92:	85ca                	mv	a1,s2
    2d94:	00003517          	auipc	a0,0x3
    2d98:	d7450513          	addi	a0,a0,-652 # 5b08 <malloc+0x1320>
    2d9c:	00002097          	auipc	ra,0x2
    2da0:	98e080e7          	jalr	-1650(ra) # 472a <printf>
    exit(1);
    2da4:	4505                	li	a0,1
    2da6:	00001097          	auipc	ra,0x1
    2daa:	604080e7          	jalr	1540(ra) # 43aa <exit>
    printf("%s: create dd/ff failed\n", s);
    2dae:	85ca                	mv	a1,s2
    2db0:	00003517          	auipc	a0,0x3
    2db4:	d7850513          	addi	a0,a0,-648 # 5b28 <malloc+0x1340>
    2db8:	00002097          	auipc	ra,0x2
    2dbc:	972080e7          	jalr	-1678(ra) # 472a <printf>
    exit(1);
    2dc0:	4505                	li	a0,1
    2dc2:	00001097          	auipc	ra,0x1
    2dc6:	5e8080e7          	jalr	1512(ra) # 43aa <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2dca:	85ca                	mv	a1,s2
    2dcc:	00003517          	auipc	a0,0x3
    2dd0:	d7c50513          	addi	a0,a0,-644 # 5b48 <malloc+0x1360>
    2dd4:	00002097          	auipc	ra,0x2
    2dd8:	956080e7          	jalr	-1706(ra) # 472a <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00001097          	auipc	ra,0x1
    2de2:	5cc080e7          	jalr	1484(ra) # 43aa <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    2de6:	85ca                	mv	a1,s2
    2de8:	00003517          	auipc	a0,0x3
    2dec:	d9850513          	addi	a0,a0,-616 # 5b80 <malloc+0x1398>
    2df0:	00002097          	auipc	ra,0x2
    2df4:	93a080e7          	jalr	-1734(ra) # 472a <printf>
    exit(1);
    2df8:	4505                	li	a0,1
    2dfa:	00001097          	auipc	ra,0x1
    2dfe:	5b0080e7          	jalr	1456(ra) # 43aa <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2e02:	85ca                	mv	a1,s2
    2e04:	00003517          	auipc	a0,0x3
    2e08:	dac50513          	addi	a0,a0,-596 # 5bb0 <malloc+0x13c8>
    2e0c:	00002097          	auipc	ra,0x2
    2e10:	91e080e7          	jalr	-1762(ra) # 472a <printf>
    exit(1);
    2e14:	4505                	li	a0,1
    2e16:	00001097          	auipc	ra,0x1
    2e1a:	594080e7          	jalr	1428(ra) # 43aa <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2e1e:	85ca                	mv	a1,s2
    2e20:	00003517          	auipc	a0,0x3
    2e24:	dc850513          	addi	a0,a0,-568 # 5be8 <malloc+0x1400>
    2e28:	00002097          	auipc	ra,0x2
    2e2c:	902080e7          	jalr	-1790(ra) # 472a <printf>
    exit(1);
    2e30:	4505                	li	a0,1
    2e32:	00001097          	auipc	ra,0x1
    2e36:	578080e7          	jalr	1400(ra) # 43aa <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2e3a:	85ca                	mv	a1,s2
    2e3c:	00003517          	auipc	a0,0x3
    2e40:	dcc50513          	addi	a0,a0,-564 # 5c08 <malloc+0x1420>
    2e44:	00002097          	auipc	ra,0x2
    2e48:	8e6080e7          	jalr	-1818(ra) # 472a <printf>
    exit(1);
    2e4c:	4505                	li	a0,1
    2e4e:	00001097          	auipc	ra,0x1
    2e52:	55c080e7          	jalr	1372(ra) # 43aa <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    2e56:	85ca                	mv	a1,s2
    2e58:	00003517          	auipc	a0,0x3
    2e5c:	de050513          	addi	a0,a0,-544 # 5c38 <malloc+0x1450>
    2e60:	00002097          	auipc	ra,0x2
    2e64:	8ca080e7          	jalr	-1846(ra) # 472a <printf>
    exit(1);
    2e68:	4505                	li	a0,1
    2e6a:	00001097          	auipc	ra,0x1
    2e6e:	540080e7          	jalr	1344(ra) # 43aa <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2e72:	85ca                	mv	a1,s2
    2e74:	00003517          	auipc	a0,0x3
    2e78:	dec50513          	addi	a0,a0,-532 # 5c60 <malloc+0x1478>
    2e7c:	00002097          	auipc	ra,0x2
    2e80:	8ae080e7          	jalr	-1874(ra) # 472a <printf>
    exit(1);
    2e84:	4505                	li	a0,1
    2e86:	00001097          	auipc	ra,0x1
    2e8a:	524080e7          	jalr	1316(ra) # 43aa <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2e8e:	85ca                	mv	a1,s2
    2e90:	00003517          	auipc	a0,0x3
    2e94:	df050513          	addi	a0,a0,-528 # 5c80 <malloc+0x1498>
    2e98:	00002097          	auipc	ra,0x2
    2e9c:	892080e7          	jalr	-1902(ra) # 472a <printf>
    exit(1);
    2ea0:	4505                	li	a0,1
    2ea2:	00001097          	auipc	ra,0x1
    2ea6:	508080e7          	jalr	1288(ra) # 43aa <exit>
    printf("%s: chdir dd failed\n", s);
    2eaa:	85ca                	mv	a1,s2
    2eac:	00003517          	auipc	a0,0x3
    2eb0:	dfc50513          	addi	a0,a0,-516 # 5ca8 <malloc+0x14c0>
    2eb4:	00002097          	auipc	ra,0x2
    2eb8:	876080e7          	jalr	-1930(ra) # 472a <printf>
    exit(1);
    2ebc:	4505                	li	a0,1
    2ebe:	00001097          	auipc	ra,0x1
    2ec2:	4ec080e7          	jalr	1260(ra) # 43aa <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00003517          	auipc	a0,0x3
    2ecc:	e0850513          	addi	a0,a0,-504 # 5cd0 <malloc+0x14e8>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	85a080e7          	jalr	-1958(ra) # 472a <printf>
    exit(1);
    2ed8:	4505                	li	a0,1
    2eda:	00001097          	auipc	ra,0x1
    2ede:	4d0080e7          	jalr	1232(ra) # 43aa <exit>
    printf("chdir dd/../../dd failed\n", s);
    2ee2:	85ca                	mv	a1,s2
    2ee4:	00003517          	auipc	a0,0x3
    2ee8:	e1c50513          	addi	a0,a0,-484 # 5d00 <malloc+0x1518>
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	83e080e7          	jalr	-1986(ra) # 472a <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	00001097          	auipc	ra,0x1
    2efa:	4b4080e7          	jalr	1204(ra) # 43aa <exit>
    printf("%s: chdir ./.. failed\n", s);
    2efe:	85ca                	mv	a1,s2
    2f00:	00003517          	auipc	a0,0x3
    2f04:	e2850513          	addi	a0,a0,-472 # 5d28 <malloc+0x1540>
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	822080e7          	jalr	-2014(ra) # 472a <printf>
    exit(1);
    2f10:	4505                	li	a0,1
    2f12:	00001097          	auipc	ra,0x1
    2f16:	498080e7          	jalr	1176(ra) # 43aa <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f1a:	85ca                	mv	a1,s2
    2f1c:	00003517          	auipc	a0,0x3
    2f20:	e2450513          	addi	a0,a0,-476 # 5d40 <malloc+0x1558>
    2f24:	00002097          	auipc	ra,0x2
    2f28:	806080e7          	jalr	-2042(ra) # 472a <printf>
    exit(1);
    2f2c:	4505                	li	a0,1
    2f2e:	00001097          	auipc	ra,0x1
    2f32:	47c080e7          	jalr	1148(ra) # 43aa <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	e2850513          	addi	a0,a0,-472 # 5d60 <malloc+0x1578>
    2f40:	00001097          	auipc	ra,0x1
    2f44:	7ea080e7          	jalr	2026(ra) # 472a <printf>
    exit(1);
    2f48:	4505                	li	a0,1
    2f4a:	00001097          	auipc	ra,0x1
    2f4e:	460080e7          	jalr	1120(ra) # 43aa <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2f52:	85ca                	mv	a1,s2
    2f54:	00003517          	auipc	a0,0x3
    2f58:	e2c50513          	addi	a0,a0,-468 # 5d80 <malloc+0x1598>
    2f5c:	00001097          	auipc	ra,0x1
    2f60:	7ce080e7          	jalr	1998(ra) # 472a <printf>
    exit(1);
    2f64:	4505                	li	a0,1
    2f66:	00001097          	auipc	ra,0x1
    2f6a:	444080e7          	jalr	1092(ra) # 43aa <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2f6e:	85ca                	mv	a1,s2
    2f70:	00003517          	auipc	a0,0x3
    2f74:	e5050513          	addi	a0,a0,-432 # 5dc0 <malloc+0x15d8>
    2f78:	00001097          	auipc	ra,0x1
    2f7c:	7b2080e7          	jalr	1970(ra) # 472a <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	00001097          	auipc	ra,0x1
    2f86:	428080e7          	jalr	1064(ra) # 43aa <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2f8a:	85ca                	mv	a1,s2
    2f8c:	00003517          	auipc	a0,0x3
    2f90:	e6450513          	addi	a0,a0,-412 # 5df0 <malloc+0x1608>
    2f94:	00001097          	auipc	ra,0x1
    2f98:	796080e7          	jalr	1942(ra) # 472a <printf>
    exit(1);
    2f9c:	4505                	li	a0,1
    2f9e:	00001097          	auipc	ra,0x1
    2fa2:	40c080e7          	jalr	1036(ra) # 43aa <exit>
    printf("%s: create dd succeeded!\n", s);
    2fa6:	85ca                	mv	a1,s2
    2fa8:	00003517          	auipc	a0,0x3
    2fac:	e6850513          	addi	a0,a0,-408 # 5e10 <malloc+0x1628>
    2fb0:	00001097          	auipc	ra,0x1
    2fb4:	77a080e7          	jalr	1914(ra) # 472a <printf>
    exit(1);
    2fb8:	4505                	li	a0,1
    2fba:	00001097          	auipc	ra,0x1
    2fbe:	3f0080e7          	jalr	1008(ra) # 43aa <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	e6c50513          	addi	a0,a0,-404 # 5e30 <malloc+0x1648>
    2fcc:	00001097          	auipc	ra,0x1
    2fd0:	75e080e7          	jalr	1886(ra) # 472a <printf>
    exit(1);
    2fd4:	4505                	li	a0,1
    2fd6:	00001097          	auipc	ra,0x1
    2fda:	3d4080e7          	jalr	980(ra) # 43aa <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2fde:	85ca                	mv	a1,s2
    2fe0:	00003517          	auipc	a0,0x3
    2fe4:	e7050513          	addi	a0,a0,-400 # 5e50 <malloc+0x1668>
    2fe8:	00001097          	auipc	ra,0x1
    2fec:	742080e7          	jalr	1858(ra) # 472a <printf>
    exit(1);
    2ff0:	4505                	li	a0,1
    2ff2:	00001097          	auipc	ra,0x1
    2ff6:	3b8080e7          	jalr	952(ra) # 43aa <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2ffa:	85ca                	mv	a1,s2
    2ffc:	00003517          	auipc	a0,0x3
    3000:	e8450513          	addi	a0,a0,-380 # 5e80 <malloc+0x1698>
    3004:	00001097          	auipc	ra,0x1
    3008:	726080e7          	jalr	1830(ra) # 472a <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	00001097          	auipc	ra,0x1
    3012:	39c080e7          	jalr	924(ra) # 43aa <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3016:	85ca                	mv	a1,s2
    3018:	00003517          	auipc	a0,0x3
    301c:	e9050513          	addi	a0,a0,-368 # 5ea8 <malloc+0x16c0>
    3020:	00001097          	auipc	ra,0x1
    3024:	70a080e7          	jalr	1802(ra) # 472a <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	00001097          	auipc	ra,0x1
    302e:	380080e7          	jalr	896(ra) # 43aa <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3032:	85ca                	mv	a1,s2
    3034:	00003517          	auipc	a0,0x3
    3038:	e9c50513          	addi	a0,a0,-356 # 5ed0 <malloc+0x16e8>
    303c:	00001097          	auipc	ra,0x1
    3040:	6ee080e7          	jalr	1774(ra) # 472a <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	00001097          	auipc	ra,0x1
    304a:	364080e7          	jalr	868(ra) # 43aa <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00003517          	auipc	a0,0x3
    3054:	ea850513          	addi	a0,a0,-344 # 5ef8 <malloc+0x1710>
    3058:	00001097          	auipc	ra,0x1
    305c:	6d2080e7          	jalr	1746(ra) # 472a <printf>
    exit(1);
    3060:	4505                	li	a0,1
    3062:	00001097          	auipc	ra,0x1
    3066:	348080e7          	jalr	840(ra) # 43aa <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    306a:	85ca                	mv	a1,s2
    306c:	00003517          	auipc	a0,0x3
    3070:	eac50513          	addi	a0,a0,-340 # 5f18 <malloc+0x1730>
    3074:	00001097          	auipc	ra,0x1
    3078:	6b6080e7          	jalr	1718(ra) # 472a <printf>
    exit(1);
    307c:	4505                	li	a0,1
    307e:	00001097          	auipc	ra,0x1
    3082:	32c080e7          	jalr	812(ra) # 43aa <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3086:	85ca                	mv	a1,s2
    3088:	00003517          	auipc	a0,0x3
    308c:	eb050513          	addi	a0,a0,-336 # 5f38 <malloc+0x1750>
    3090:	00001097          	auipc	ra,0x1
    3094:	69a080e7          	jalr	1690(ra) # 472a <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	00001097          	auipc	ra,0x1
    309e:	310080e7          	jalr	784(ra) # 43aa <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30a2:	85ca                	mv	a1,s2
    30a4:	00003517          	auipc	a0,0x3
    30a8:	ebc50513          	addi	a0,a0,-324 # 5f60 <malloc+0x1778>
    30ac:	00001097          	auipc	ra,0x1
    30b0:	67e080e7          	jalr	1662(ra) # 472a <printf>
    exit(1);
    30b4:	4505                	li	a0,1
    30b6:	00001097          	auipc	ra,0x1
    30ba:	2f4080e7          	jalr	756(ra) # 43aa <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30be:	85ca                	mv	a1,s2
    30c0:	00003517          	auipc	a0,0x3
    30c4:	ec050513          	addi	a0,a0,-320 # 5f80 <malloc+0x1798>
    30c8:	00001097          	auipc	ra,0x1
    30cc:	662080e7          	jalr	1634(ra) # 472a <printf>
    exit(1);
    30d0:	4505                	li	a0,1
    30d2:	00001097          	auipc	ra,0x1
    30d6:	2d8080e7          	jalr	728(ra) # 43aa <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00003517          	auipc	a0,0x3
    30e0:	ec450513          	addi	a0,a0,-316 # 5fa0 <malloc+0x17b8>
    30e4:	00001097          	auipc	ra,0x1
    30e8:	646080e7          	jalr	1606(ra) # 472a <printf>
    exit(1);
    30ec:	4505                	li	a0,1
    30ee:	00001097          	auipc	ra,0x1
    30f2:	2bc080e7          	jalr	700(ra) # 43aa <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30f6:	85ca                	mv	a1,s2
    30f8:	00003517          	auipc	a0,0x3
    30fc:	ed050513          	addi	a0,a0,-304 # 5fc8 <malloc+0x17e0>
    3100:	00001097          	auipc	ra,0x1
    3104:	62a080e7          	jalr	1578(ra) # 472a <printf>
    exit(1);
    3108:	4505                	li	a0,1
    310a:	00001097          	auipc	ra,0x1
    310e:	2a0080e7          	jalr	672(ra) # 43aa <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3112:	85ca                	mv	a1,s2
    3114:	00003517          	auipc	a0,0x3
    3118:	b4c50513          	addi	a0,a0,-1204 # 5c60 <malloc+0x1478>
    311c:	00001097          	auipc	ra,0x1
    3120:	60e080e7          	jalr	1550(ra) # 472a <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	00001097          	auipc	ra,0x1
    312a:	284080e7          	jalr	644(ra) # 43aa <exit>
    printf("%s: unlink dd/ff failed\n", s);
    312e:	85ca                	mv	a1,s2
    3130:	00003517          	auipc	a0,0x3
    3134:	eb850513          	addi	a0,a0,-328 # 5fe8 <malloc+0x1800>
    3138:	00001097          	auipc	ra,0x1
    313c:	5f2080e7          	jalr	1522(ra) # 472a <printf>
    exit(1);
    3140:	4505                	li	a0,1
    3142:	00001097          	auipc	ra,0x1
    3146:	268080e7          	jalr	616(ra) # 43aa <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    314a:	85ca                	mv	a1,s2
    314c:	00003517          	auipc	a0,0x3
    3150:	ebc50513          	addi	a0,a0,-324 # 6008 <malloc+0x1820>
    3154:	00001097          	auipc	ra,0x1
    3158:	5d6080e7          	jalr	1494(ra) # 472a <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	00001097          	auipc	ra,0x1
    3162:	24c080e7          	jalr	588(ra) # 43aa <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00003517          	auipc	a0,0x3
    316c:	ed050513          	addi	a0,a0,-304 # 6038 <malloc+0x1850>
    3170:	00001097          	auipc	ra,0x1
    3174:	5ba080e7          	jalr	1466(ra) # 472a <printf>
    exit(1);
    3178:	4505                	li	a0,1
    317a:	00001097          	auipc	ra,0x1
    317e:	230080e7          	jalr	560(ra) # 43aa <exit>
    printf("%s: unlink dd failed\n", s);
    3182:	85ca                	mv	a1,s2
    3184:	00003517          	auipc	a0,0x3
    3188:	ed450513          	addi	a0,a0,-300 # 6058 <malloc+0x1870>
    318c:	00001097          	auipc	ra,0x1
    3190:	59e080e7          	jalr	1438(ra) # 472a <printf>
    exit(1);
    3194:	4505                	li	a0,1
    3196:	00001097          	auipc	ra,0x1
    319a:	214080e7          	jalr	532(ra) # 43aa <exit>

000000000000319e <dirfile>:
{
    319e:	1101                	addi	sp,sp,-32
    31a0:	ec06                	sd	ra,24(sp)
    31a2:	e822                	sd	s0,16(sp)
    31a4:	e426                	sd	s1,8(sp)
    31a6:	e04a                	sd	s2,0(sp)
    31a8:	1000                	addi	s0,sp,32
    31aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    31ac:	20000593          	li	a1,512
    31b0:	00002517          	auipc	a0,0x2
    31b4:	98050513          	addi	a0,a0,-1664 # 4b30 <malloc+0x348>
    31b8:	00001097          	auipc	ra,0x1
    31bc:	232080e7          	jalr	562(ra) # 43ea <open>
  if(fd < 0){
    31c0:	0e054d63          	bltz	a0,32ba <dirfile+0x11c>
  close(fd);
    31c4:	00001097          	auipc	ra,0x1
    31c8:	20e080e7          	jalr	526(ra) # 43d2 <close>
  if(chdir("dirfile") == 0){
    31cc:	00002517          	auipc	a0,0x2
    31d0:	96450513          	addi	a0,a0,-1692 # 4b30 <malloc+0x348>
    31d4:	00001097          	auipc	ra,0x1
    31d8:	246080e7          	jalr	582(ra) # 441a <chdir>
    31dc:	cd6d                	beqz	a0,32d6 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    31de:	4581                	li	a1,0
    31e0:	00003517          	auipc	a0,0x3
    31e4:	ed050513          	addi	a0,a0,-304 # 60b0 <malloc+0x18c8>
    31e8:	00001097          	auipc	ra,0x1
    31ec:	202080e7          	jalr	514(ra) # 43ea <open>
  if(fd >= 0){
    31f0:	10055163          	bgez	a0,32f2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    31f4:	20000593          	li	a1,512
    31f8:	00003517          	auipc	a0,0x3
    31fc:	eb850513          	addi	a0,a0,-328 # 60b0 <malloc+0x18c8>
    3200:	00001097          	auipc	ra,0x1
    3204:	1ea080e7          	jalr	490(ra) # 43ea <open>
  if(fd >= 0){
    3208:	10055363          	bgez	a0,330e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    320c:	00003517          	auipc	a0,0x3
    3210:	ea450513          	addi	a0,a0,-348 # 60b0 <malloc+0x18c8>
    3214:	00001097          	auipc	ra,0x1
    3218:	1fe080e7          	jalr	510(ra) # 4412 <mkdir>
    321c:	10050763          	beqz	a0,332a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3220:	00003517          	auipc	a0,0x3
    3224:	e9050513          	addi	a0,a0,-368 # 60b0 <malloc+0x18c8>
    3228:	00001097          	auipc	ra,0x1
    322c:	1d2080e7          	jalr	466(ra) # 43fa <unlink>
    3230:	10050b63          	beqz	a0,3346 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3234:	00003597          	auipc	a1,0x3
    3238:	e7c58593          	addi	a1,a1,-388 # 60b0 <malloc+0x18c8>
    323c:	00003517          	auipc	a0,0x3
    3240:	efc50513          	addi	a0,a0,-260 # 6138 <malloc+0x1950>
    3244:	00001097          	auipc	ra,0x1
    3248:	1c6080e7          	jalr	454(ra) # 440a <link>
    324c:	10050b63          	beqz	a0,3362 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3250:	00002517          	auipc	a0,0x2
    3254:	8e050513          	addi	a0,a0,-1824 # 4b30 <malloc+0x348>
    3258:	00001097          	auipc	ra,0x1
    325c:	1a2080e7          	jalr	418(ra) # 43fa <unlink>
    3260:	10051f63          	bnez	a0,337e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3264:	4589                	li	a1,2
    3266:	00002517          	auipc	a0,0x2
    326a:	9d250513          	addi	a0,a0,-1582 # 4c38 <malloc+0x450>
    326e:	00001097          	auipc	ra,0x1
    3272:	17c080e7          	jalr	380(ra) # 43ea <open>
  if(fd >= 0){
    3276:	12055263          	bgez	a0,339a <dirfile+0x1fc>
  fd = open(".", 0);
    327a:	4581                	li	a1,0
    327c:	00002517          	auipc	a0,0x2
    3280:	9bc50513          	addi	a0,a0,-1604 # 4c38 <malloc+0x450>
    3284:	00001097          	auipc	ra,0x1
    3288:	166080e7          	jalr	358(ra) # 43ea <open>
    328c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    328e:	4605                	li	a2,1
    3290:	00002597          	auipc	a1,0x2
    3294:	40858593          	addi	a1,a1,1032 # 5698 <malloc+0xeb0>
    3298:	00001097          	auipc	ra,0x1
    329c:	132080e7          	jalr	306(ra) # 43ca <write>
    32a0:	10a04b63          	bgtz	a0,33b6 <dirfile+0x218>
  close(fd);
    32a4:	8526                	mv	a0,s1
    32a6:	00001097          	auipc	ra,0x1
    32aa:	12c080e7          	jalr	300(ra) # 43d2 <close>
}
    32ae:	60e2                	ld	ra,24(sp)
    32b0:	6442                	ld	s0,16(sp)
    32b2:	64a2                	ld	s1,8(sp)
    32b4:	6902                	ld	s2,0(sp)
    32b6:	6105                	addi	sp,sp,32
    32b8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    32ba:	85ca                	mv	a1,s2
    32bc:	00003517          	auipc	a0,0x3
    32c0:	db450513          	addi	a0,a0,-588 # 6070 <malloc+0x1888>
    32c4:	00001097          	auipc	ra,0x1
    32c8:	466080e7          	jalr	1126(ra) # 472a <printf>
    exit(1);
    32cc:	4505                	li	a0,1
    32ce:	00001097          	auipc	ra,0x1
    32d2:	0dc080e7          	jalr	220(ra) # 43aa <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    32d6:	85ca                	mv	a1,s2
    32d8:	00003517          	auipc	a0,0x3
    32dc:	db850513          	addi	a0,a0,-584 # 6090 <malloc+0x18a8>
    32e0:	00001097          	auipc	ra,0x1
    32e4:	44a080e7          	jalr	1098(ra) # 472a <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	00001097          	auipc	ra,0x1
    32ee:	0c0080e7          	jalr	192(ra) # 43aa <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    32f2:	85ca                	mv	a1,s2
    32f4:	00003517          	auipc	a0,0x3
    32f8:	dcc50513          	addi	a0,a0,-564 # 60c0 <malloc+0x18d8>
    32fc:	00001097          	auipc	ra,0x1
    3300:	42e080e7          	jalr	1070(ra) # 472a <printf>
    exit(1);
    3304:	4505                	li	a0,1
    3306:	00001097          	auipc	ra,0x1
    330a:	0a4080e7          	jalr	164(ra) # 43aa <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    330e:	85ca                	mv	a1,s2
    3310:	00003517          	auipc	a0,0x3
    3314:	db050513          	addi	a0,a0,-592 # 60c0 <malloc+0x18d8>
    3318:	00001097          	auipc	ra,0x1
    331c:	412080e7          	jalr	1042(ra) # 472a <printf>
    exit(1);
    3320:	4505                	li	a0,1
    3322:	00001097          	auipc	ra,0x1
    3326:	088080e7          	jalr	136(ra) # 43aa <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    332a:	85ca                	mv	a1,s2
    332c:	00003517          	auipc	a0,0x3
    3330:	dbc50513          	addi	a0,a0,-580 # 60e8 <malloc+0x1900>
    3334:	00001097          	auipc	ra,0x1
    3338:	3f6080e7          	jalr	1014(ra) # 472a <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	00001097          	auipc	ra,0x1
    3342:	06c080e7          	jalr	108(ra) # 43aa <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3346:	85ca                	mv	a1,s2
    3348:	00003517          	auipc	a0,0x3
    334c:	dc850513          	addi	a0,a0,-568 # 6110 <malloc+0x1928>
    3350:	00001097          	auipc	ra,0x1
    3354:	3da080e7          	jalr	986(ra) # 472a <printf>
    exit(1);
    3358:	4505                	li	a0,1
    335a:	00001097          	auipc	ra,0x1
    335e:	050080e7          	jalr	80(ra) # 43aa <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3362:	85ca                	mv	a1,s2
    3364:	00003517          	auipc	a0,0x3
    3368:	ddc50513          	addi	a0,a0,-548 # 6140 <malloc+0x1958>
    336c:	00001097          	auipc	ra,0x1
    3370:	3be080e7          	jalr	958(ra) # 472a <printf>
    exit(1);
    3374:	4505                	li	a0,1
    3376:	00001097          	auipc	ra,0x1
    337a:	034080e7          	jalr	52(ra) # 43aa <exit>
    printf("%s: unlink dirfile failed!\n", s);
    337e:	85ca                	mv	a1,s2
    3380:	00003517          	auipc	a0,0x3
    3384:	de850513          	addi	a0,a0,-536 # 6168 <malloc+0x1980>
    3388:	00001097          	auipc	ra,0x1
    338c:	3a2080e7          	jalr	930(ra) # 472a <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	00001097          	auipc	ra,0x1
    3396:	018080e7          	jalr	24(ra) # 43aa <exit>
    printf("%s: open . for writing succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00003517          	auipc	a0,0x3
    33a0:	dec50513          	addi	a0,a0,-532 # 6188 <malloc+0x19a0>
    33a4:	00001097          	auipc	ra,0x1
    33a8:	386080e7          	jalr	902(ra) # 472a <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	00001097          	auipc	ra,0x1
    33b2:	ffc080e7          	jalr	-4(ra) # 43aa <exit>
    printf("%s: write . succeeded!\n", s);
    33b6:	85ca                	mv	a1,s2
    33b8:	00003517          	auipc	a0,0x3
    33bc:	df850513          	addi	a0,a0,-520 # 61b0 <malloc+0x19c8>
    33c0:	00001097          	auipc	ra,0x1
    33c4:	36a080e7          	jalr	874(ra) # 472a <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	00001097          	auipc	ra,0x1
    33ce:	fe0080e7          	jalr	-32(ra) # 43aa <exit>

00000000000033d2 <iref>:
{
    33d2:	7139                	addi	sp,sp,-64
    33d4:	fc06                	sd	ra,56(sp)
    33d6:	f822                	sd	s0,48(sp)
    33d8:	f426                	sd	s1,40(sp)
    33da:	f04a                	sd	s2,32(sp)
    33dc:	ec4e                	sd	s3,24(sp)
    33de:	e852                	sd	s4,16(sp)
    33e0:	e456                	sd	s5,8(sp)
    33e2:	e05a                	sd	s6,0(sp)
    33e4:	0080                	addi	s0,sp,64
    33e6:	8b2a                	mv	s6,a0
    33e8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    33ec:	00003a17          	auipc	s4,0x3
    33f0:	ddca0a13          	addi	s4,s4,-548 # 61c8 <malloc+0x19e0>
    mkdir("");
    33f4:	00003497          	auipc	s1,0x3
    33f8:	9b448493          	addi	s1,s1,-1612 # 5da8 <malloc+0x15c0>
    link("README", "");
    33fc:	00003a97          	auipc	s5,0x3
    3400:	d3ca8a93          	addi	s5,s5,-708 # 6138 <malloc+0x1950>
    fd = open("xx", O_CREATE);
    3404:	00003997          	auipc	s3,0x3
    3408:	cb498993          	addi	s3,s3,-844 # 60b8 <malloc+0x18d0>
    340c:	a891                	j	3460 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    340e:	85da                	mv	a1,s6
    3410:	00003517          	auipc	a0,0x3
    3414:	dc050513          	addi	a0,a0,-576 # 61d0 <malloc+0x19e8>
    3418:	00001097          	auipc	ra,0x1
    341c:	312080e7          	jalr	786(ra) # 472a <printf>
      exit(1);
    3420:	4505                	li	a0,1
    3422:	00001097          	auipc	ra,0x1
    3426:	f88080e7          	jalr	-120(ra) # 43aa <exit>
      printf("%s: chdir irefd failed\n", s);
    342a:	85da                	mv	a1,s6
    342c:	00003517          	auipc	a0,0x3
    3430:	dbc50513          	addi	a0,a0,-580 # 61e8 <malloc+0x1a00>
    3434:	00001097          	auipc	ra,0x1
    3438:	2f6080e7          	jalr	758(ra) # 472a <printf>
      exit(1);
    343c:	4505                	li	a0,1
    343e:	00001097          	auipc	ra,0x1
    3442:	f6c080e7          	jalr	-148(ra) # 43aa <exit>
      close(fd);
    3446:	00001097          	auipc	ra,0x1
    344a:	f8c080e7          	jalr	-116(ra) # 43d2 <close>
    344e:	a889                	j	34a0 <iref+0xce>
    unlink("xx");
    3450:	854e                	mv	a0,s3
    3452:	00001097          	auipc	ra,0x1
    3456:	fa8080e7          	jalr	-88(ra) # 43fa <unlink>
  for(i = 0; i < NINODE + 1; i++){
    345a:	397d                	addiw	s2,s2,-1
    345c:	06090063          	beqz	s2,34bc <iref+0xea>
    if(mkdir("irefd") != 0){
    3460:	8552                	mv	a0,s4
    3462:	00001097          	auipc	ra,0x1
    3466:	fb0080e7          	jalr	-80(ra) # 4412 <mkdir>
    346a:	f155                	bnez	a0,340e <iref+0x3c>
    if(chdir("irefd") != 0){
    346c:	8552                	mv	a0,s4
    346e:	00001097          	auipc	ra,0x1
    3472:	fac080e7          	jalr	-84(ra) # 441a <chdir>
    3476:	f955                	bnez	a0,342a <iref+0x58>
    mkdir("");
    3478:	8526                	mv	a0,s1
    347a:	00001097          	auipc	ra,0x1
    347e:	f98080e7          	jalr	-104(ra) # 4412 <mkdir>
    link("README", "");
    3482:	85a6                	mv	a1,s1
    3484:	8556                	mv	a0,s5
    3486:	00001097          	auipc	ra,0x1
    348a:	f84080e7          	jalr	-124(ra) # 440a <link>
    fd = open("", O_CREATE);
    348e:	20000593          	li	a1,512
    3492:	8526                	mv	a0,s1
    3494:	00001097          	auipc	ra,0x1
    3498:	f56080e7          	jalr	-170(ra) # 43ea <open>
    if(fd >= 0)
    349c:	fa0555e3          	bgez	a0,3446 <iref+0x74>
    fd = open("xx", O_CREATE);
    34a0:	20000593          	li	a1,512
    34a4:	854e                	mv	a0,s3
    34a6:	00001097          	auipc	ra,0x1
    34aa:	f44080e7          	jalr	-188(ra) # 43ea <open>
    if(fd >= 0)
    34ae:	fa0541e3          	bltz	a0,3450 <iref+0x7e>
      close(fd);
    34b2:	00001097          	auipc	ra,0x1
    34b6:	f20080e7          	jalr	-224(ra) # 43d2 <close>
    34ba:	bf59                	j	3450 <iref+0x7e>
  chdir("/");
    34bc:	00001517          	auipc	a0,0x1
    34c0:	72450513          	addi	a0,a0,1828 # 4be0 <malloc+0x3f8>
    34c4:	00001097          	auipc	ra,0x1
    34c8:	f56080e7          	jalr	-170(ra) # 441a <chdir>
}
    34cc:	70e2                	ld	ra,56(sp)
    34ce:	7442                	ld	s0,48(sp)
    34d0:	74a2                	ld	s1,40(sp)
    34d2:	7902                	ld	s2,32(sp)
    34d4:	69e2                	ld	s3,24(sp)
    34d6:	6a42                	ld	s4,16(sp)
    34d8:	6aa2                	ld	s5,8(sp)
    34da:	6b02                	ld	s6,0(sp)
    34dc:	6121                	addi	sp,sp,64
    34de:	8082                	ret

00000000000034e0 <validatetest>:
{
    34e0:	7139                	addi	sp,sp,-64
    34e2:	fc06                	sd	ra,56(sp)
    34e4:	f822                	sd	s0,48(sp)
    34e6:	f426                	sd	s1,40(sp)
    34e8:	f04a                	sd	s2,32(sp)
    34ea:	ec4e                	sd	s3,24(sp)
    34ec:	e852                	sd	s4,16(sp)
    34ee:	e456                	sd	s5,8(sp)
    34f0:	e05a                	sd	s6,0(sp)
    34f2:	0080                	addi	s0,sp,64
    34f4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    34f6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    34f8:	00003997          	auipc	s3,0x3
    34fc:	d0898993          	addi	s3,s3,-760 # 6200 <malloc+0x1a18>
    3500:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3502:	6a85                	lui	s5,0x1
    3504:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    3508:	85a6                	mv	a1,s1
    350a:	854e                	mv	a0,s3
    350c:	00001097          	auipc	ra,0x1
    3510:	efe080e7          	jalr	-258(ra) # 440a <link>
    3514:	01251f63          	bne	a0,s2,3532 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3518:	94d6                	add	s1,s1,s5
    351a:	ff4497e3          	bne	s1,s4,3508 <validatetest+0x28>
}
    351e:	70e2                	ld	ra,56(sp)
    3520:	7442                	ld	s0,48(sp)
    3522:	74a2                	ld	s1,40(sp)
    3524:	7902                	ld	s2,32(sp)
    3526:	69e2                	ld	s3,24(sp)
    3528:	6a42                	ld	s4,16(sp)
    352a:	6aa2                	ld	s5,8(sp)
    352c:	6b02                	ld	s6,0(sp)
    352e:	6121                	addi	sp,sp,64
    3530:	8082                	ret
      printf("%s: link should not succeed\n", s);
    3532:	85da                	mv	a1,s6
    3534:	00003517          	auipc	a0,0x3
    3538:	cdc50513          	addi	a0,a0,-804 # 6210 <malloc+0x1a28>
    353c:	00001097          	auipc	ra,0x1
    3540:	1ee080e7          	jalr	494(ra) # 472a <printf>
      exit(1);
    3544:	4505                	li	a0,1
    3546:	00001097          	auipc	ra,0x1
    354a:	e64080e7          	jalr	-412(ra) # 43aa <exit>

000000000000354e <sbrkbasic>:
{
    354e:	715d                	addi	sp,sp,-80
    3550:	e486                	sd	ra,72(sp)
    3552:	e0a2                	sd	s0,64(sp)
    3554:	fc26                	sd	s1,56(sp)
    3556:	f84a                	sd	s2,48(sp)
    3558:	f44e                	sd	s3,40(sp)
    355a:	f052                	sd	s4,32(sp)
    355c:	ec56                	sd	s5,24(sp)
    355e:	0880                	addi	s0,sp,80
    3560:	8a2a                	mv	s4,a0
  a = sbrk(TOOMUCH);
    3562:	40000537          	lui	a0,0x40000
    3566:	00001097          	auipc	ra,0x1
    356a:	ecc080e7          	jalr	-308(ra) # 4432 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    356e:	57fd                	li	a5,-1
    3570:	02f50063          	beq	a0,a5,3590 <sbrkbasic+0x42>
    3574:	85aa                	mv	a1,a0
    printf("%s: sbrk(<toomuch>) returned %p\n", a);
    3576:	00003517          	auipc	a0,0x3
    357a:	cba50513          	addi	a0,a0,-838 # 6230 <malloc+0x1a48>
    357e:	00001097          	auipc	ra,0x1
    3582:	1ac080e7          	jalr	428(ra) # 472a <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	00001097          	auipc	ra,0x1
    358c:	e22080e7          	jalr	-478(ra) # 43aa <exit>
  a = sbrk(0);
    3590:	4501                	li	a0,0
    3592:	00001097          	auipc	ra,0x1
    3596:	ea0080e7          	jalr	-352(ra) # 4432 <sbrk>
    359a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    359c:	4901                	li	s2,0
    *b = 1;
    359e:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    35a0:	6985                	lui	s3,0x1
    35a2:	38898993          	addi	s3,s3,904 # 1388 <unlinkread+0x10e>
    35a6:	a011                	j	35aa <sbrkbasic+0x5c>
    a = b + 1;
    35a8:	84be                	mv	s1,a5
    b = sbrk(1);
    35aa:	4505                	li	a0,1
    35ac:	00001097          	auipc	ra,0x1
    35b0:	e86080e7          	jalr	-378(ra) # 4432 <sbrk>
    if(b != a){
    35b4:	04951b63          	bne	a0,s1,360a <sbrkbasic+0xbc>
    *b = 1;
    35b8:	01548023          	sb	s5,0(s1)
    a = b + 1;
    35bc:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    35c0:	2905                	addiw	s2,s2,1
    35c2:	ff3913e3          	bne	s2,s3,35a8 <sbrkbasic+0x5a>
  pid = fork();
    35c6:	00001097          	auipc	ra,0x1
    35ca:	ddc080e7          	jalr	-548(ra) # 43a2 <fork>
    35ce:	892a                	mv	s2,a0
  if(pid < 0){
    35d0:	04054d63          	bltz	a0,362a <sbrkbasic+0xdc>
  c = sbrk(1);
    35d4:	4505                	li	a0,1
    35d6:	00001097          	auipc	ra,0x1
    35da:	e5c080e7          	jalr	-420(ra) # 4432 <sbrk>
  c = sbrk(1);
    35de:	4505                	li	a0,1
    35e0:	00001097          	auipc	ra,0x1
    35e4:	e52080e7          	jalr	-430(ra) # 4432 <sbrk>
  if(c != a + 1){
    35e8:	0489                	addi	s1,s1,2
    35ea:	04a48e63          	beq	s1,a0,3646 <sbrkbasic+0xf8>
    printf("%s: sbrk test failed post-fork\n", s);
    35ee:	85d2                	mv	a1,s4
    35f0:	00003517          	auipc	a0,0x3
    35f4:	ca850513          	addi	a0,a0,-856 # 6298 <malloc+0x1ab0>
    35f8:	00001097          	auipc	ra,0x1
    35fc:	132080e7          	jalr	306(ra) # 472a <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00001097          	auipc	ra,0x1
    3606:	da8080e7          	jalr	-600(ra) # 43aa <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    360a:	86aa                	mv	a3,a0
    360c:	8626                	mv	a2,s1
    360e:	85ca                	mv	a1,s2
    3610:	00003517          	auipc	a0,0x3
    3614:	c4850513          	addi	a0,a0,-952 # 6258 <malloc+0x1a70>
    3618:	00001097          	auipc	ra,0x1
    361c:	112080e7          	jalr	274(ra) # 472a <printf>
      exit(1);
    3620:	4505                	li	a0,1
    3622:	00001097          	auipc	ra,0x1
    3626:	d88080e7          	jalr	-632(ra) # 43aa <exit>
    printf("%s: sbrk test fork failed\n", s);
    362a:	85d2                	mv	a1,s4
    362c:	00003517          	auipc	a0,0x3
    3630:	c4c50513          	addi	a0,a0,-948 # 6278 <malloc+0x1a90>
    3634:	00001097          	auipc	ra,0x1
    3638:	0f6080e7          	jalr	246(ra) # 472a <printf>
    exit(1);
    363c:	4505                	li	a0,1
    363e:	00001097          	auipc	ra,0x1
    3642:	d6c080e7          	jalr	-660(ra) # 43aa <exit>
  if(pid == 0)
    3646:	00091763          	bnez	s2,3654 <sbrkbasic+0x106>
    exit(0);
    364a:	4501                	li	a0,0
    364c:	00001097          	auipc	ra,0x1
    3650:	d5e080e7          	jalr	-674(ra) # 43aa <exit>
  wait(&xstatus);
    3654:	fbc40513          	addi	a0,s0,-68
    3658:	00001097          	auipc	ra,0x1
    365c:	d5a080e7          	jalr	-678(ra) # 43b2 <wait>
  exit(xstatus);
    3660:	fbc42503          	lw	a0,-68(s0)
    3664:	00001097          	auipc	ra,0x1
    3668:	d46080e7          	jalr	-698(ra) # 43aa <exit>

000000000000366c <sbrkmuch>:
{
    366c:	7179                	addi	sp,sp,-48
    366e:	f406                	sd	ra,40(sp)
    3670:	f022                	sd	s0,32(sp)
    3672:	ec26                	sd	s1,24(sp)
    3674:	e84a                	sd	s2,16(sp)
    3676:	e44e                	sd	s3,8(sp)
    3678:	e052                	sd	s4,0(sp)
    367a:	1800                	addi	s0,sp,48
    367c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    367e:	4501                	li	a0,0
    3680:	00001097          	auipc	ra,0x1
    3684:	db2080e7          	jalr	-590(ra) # 4432 <sbrk>
    3688:	892a                	mv	s2,a0
  a = sbrk(0);
    368a:	4501                	li	a0,0
    368c:	00001097          	auipc	ra,0x1
    3690:	da6080e7          	jalr	-602(ra) # 4432 <sbrk>
    3694:	84aa                	mv	s1,a0
  p = sbrk(amt);
    3696:	06400537          	lui	a0,0x6400
    369a:	9d05                	subw	a0,a0,s1
    369c:	00001097          	auipc	ra,0x1
    36a0:	d96080e7          	jalr	-618(ra) # 4432 <sbrk>
  if (p != a) {
    36a4:	0aa49963          	bne	s1,a0,3756 <sbrkmuch+0xea>
  *lastaddr = 99;
    36a8:	064007b7          	lui	a5,0x6400
    36ac:	06300713          	li	a4,99
    36b0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3e47>
  a = sbrk(0);
    36b4:	4501                	li	a0,0
    36b6:	00001097          	auipc	ra,0x1
    36ba:	d7c080e7          	jalr	-644(ra) # 4432 <sbrk>
    36be:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    36c0:	757d                	lui	a0,0xfffff
    36c2:	00001097          	auipc	ra,0x1
    36c6:	d70080e7          	jalr	-656(ra) # 4432 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    36ca:	57fd                	li	a5,-1
    36cc:	0af50363          	beq	a0,a5,3772 <sbrkmuch+0x106>
  c = sbrk(0);
    36d0:	4501                	li	a0,0
    36d2:	00001097          	auipc	ra,0x1
    36d6:	d60080e7          	jalr	-672(ra) # 4432 <sbrk>
  if(c != a - PGSIZE){
    36da:	77fd                	lui	a5,0xfffff
    36dc:	97a6                	add	a5,a5,s1
    36de:	0af51863          	bne	a0,a5,378e <sbrkmuch+0x122>
  a = sbrk(0);
    36e2:	4501                	li	a0,0
    36e4:	00001097          	auipc	ra,0x1
    36e8:	d4e080e7          	jalr	-690(ra) # 4432 <sbrk>
    36ec:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    36ee:	6505                	lui	a0,0x1
    36f0:	00001097          	auipc	ra,0x1
    36f4:	d42080e7          	jalr	-702(ra) # 4432 <sbrk>
    36f8:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    36fa:	0aa49963          	bne	s1,a0,37ac <sbrkmuch+0x140>
    36fe:	4501                	li	a0,0
    3700:	00001097          	auipc	ra,0x1
    3704:	d32080e7          	jalr	-718(ra) # 4432 <sbrk>
    3708:	6785                	lui	a5,0x1
    370a:	97a6                	add	a5,a5,s1
    370c:	0af51063          	bne	a0,a5,37ac <sbrkmuch+0x140>
  if(*lastaddr == 99){
    3710:	064007b7          	lui	a5,0x6400
    3714:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3e47>
    3718:	06300793          	li	a5,99
    371c:	0af70763          	beq	a4,a5,37ca <sbrkmuch+0x15e>
  a = sbrk(0);
    3720:	4501                	li	a0,0
    3722:	00001097          	auipc	ra,0x1
    3726:	d10080e7          	jalr	-752(ra) # 4432 <sbrk>
    372a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    372c:	4501                	li	a0,0
    372e:	00001097          	auipc	ra,0x1
    3732:	d04080e7          	jalr	-764(ra) # 4432 <sbrk>
    3736:	40a9053b          	subw	a0,s2,a0
    373a:	00001097          	auipc	ra,0x1
    373e:	cf8080e7          	jalr	-776(ra) # 4432 <sbrk>
  if(c != a){
    3742:	0aa49263          	bne	s1,a0,37e6 <sbrkmuch+0x17a>
}
    3746:	70a2                	ld	ra,40(sp)
    3748:	7402                	ld	s0,32(sp)
    374a:	64e2                	ld	s1,24(sp)
    374c:	6942                	ld	s2,16(sp)
    374e:	69a2                	ld	s3,8(sp)
    3750:	6a02                	ld	s4,0(sp)
    3752:	6145                	addi	sp,sp,48
    3754:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    3756:	85ce                	mv	a1,s3
    3758:	00003517          	auipc	a0,0x3
    375c:	b6050513          	addi	a0,a0,-1184 # 62b8 <malloc+0x1ad0>
    3760:	00001097          	auipc	ra,0x1
    3764:	fca080e7          	jalr	-54(ra) # 472a <printf>
    exit(1);
    3768:	4505                	li	a0,1
    376a:	00001097          	auipc	ra,0x1
    376e:	c40080e7          	jalr	-960(ra) # 43aa <exit>
    printf("%s: sbrk could not deallocate\n", s);
    3772:	85ce                	mv	a1,s3
    3774:	00003517          	auipc	a0,0x3
    3778:	b8c50513          	addi	a0,a0,-1140 # 6300 <malloc+0x1b18>
    377c:	00001097          	auipc	ra,0x1
    3780:	fae080e7          	jalr	-82(ra) # 472a <printf>
    exit(1);
    3784:	4505                	li	a0,1
    3786:	00001097          	auipc	ra,0x1
    378a:	c24080e7          	jalr	-988(ra) # 43aa <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    378e:	862a                	mv	a2,a0
    3790:	85a6                	mv	a1,s1
    3792:	00003517          	auipc	a0,0x3
    3796:	b8e50513          	addi	a0,a0,-1138 # 6320 <malloc+0x1b38>
    379a:	00001097          	auipc	ra,0x1
    379e:	f90080e7          	jalr	-112(ra) # 472a <printf>
    exit(1);
    37a2:	4505                	li	a0,1
    37a4:	00001097          	auipc	ra,0x1
    37a8:	c06080e7          	jalr	-1018(ra) # 43aa <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    37ac:	8652                	mv	a2,s4
    37ae:	85a6                	mv	a1,s1
    37b0:	00003517          	auipc	a0,0x3
    37b4:	bb050513          	addi	a0,a0,-1104 # 6360 <malloc+0x1b78>
    37b8:	00001097          	auipc	ra,0x1
    37bc:	f72080e7          	jalr	-142(ra) # 472a <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00001097          	auipc	ra,0x1
    37c6:	be8080e7          	jalr	-1048(ra) # 43aa <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    37ca:	85ce                	mv	a1,s3
    37cc:	00003517          	auipc	a0,0x3
    37d0:	bc450513          	addi	a0,a0,-1084 # 6390 <malloc+0x1ba8>
    37d4:	00001097          	auipc	ra,0x1
    37d8:	f56080e7          	jalr	-170(ra) # 472a <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00001097          	auipc	ra,0x1
    37e2:	bcc080e7          	jalr	-1076(ra) # 43aa <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    37e6:	862a                	mv	a2,a0
    37e8:	85a6                	mv	a1,s1
    37ea:	00003517          	auipc	a0,0x3
    37ee:	bde50513          	addi	a0,a0,-1058 # 63c8 <malloc+0x1be0>
    37f2:	00001097          	auipc	ra,0x1
    37f6:	f38080e7          	jalr	-200(ra) # 472a <printf>
    exit(1);
    37fa:	4505                	li	a0,1
    37fc:	00001097          	auipc	ra,0x1
    3800:	bae080e7          	jalr	-1106(ra) # 43aa <exit>

0000000000003804 <sbrkfail>:
{
    3804:	7119                	addi	sp,sp,-128
    3806:	fc86                	sd	ra,120(sp)
    3808:	f8a2                	sd	s0,112(sp)
    380a:	f4a6                	sd	s1,104(sp)
    380c:	f0ca                	sd	s2,96(sp)
    380e:	ecce                	sd	s3,88(sp)
    3810:	e8d2                	sd	s4,80(sp)
    3812:	e4d6                	sd	s5,72(sp)
    3814:	0100                	addi	s0,sp,128
    3816:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    3818:	fb040513          	addi	a0,s0,-80
    381c:	00001097          	auipc	ra,0x1
    3820:	b9e080e7          	jalr	-1122(ra) # 43ba <pipe>
    3824:	e901                	bnez	a0,3834 <sbrkfail+0x30>
    3826:	f8040493          	addi	s1,s0,-128
    382a:	fa840a13          	addi	s4,s0,-88
    382e:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    3830:	5afd                	li	s5,-1
    3832:	a08d                	j	3894 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00002517          	auipc	a0,0x2
    383a:	de250513          	addi	a0,a0,-542 # 5618 <malloc+0xe30>
    383e:	00001097          	auipc	ra,0x1
    3842:	eec080e7          	jalr	-276(ra) # 472a <printf>
    exit(1);
    3846:	4505                	li	a0,1
    3848:	00001097          	auipc	ra,0x1
    384c:	b62080e7          	jalr	-1182(ra) # 43aa <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3850:	4501                	li	a0,0
    3852:	00001097          	auipc	ra,0x1
    3856:	be0080e7          	jalr	-1056(ra) # 4432 <sbrk>
    385a:	064007b7          	lui	a5,0x6400
    385e:	40a7853b          	subw	a0,a5,a0
    3862:	00001097          	auipc	ra,0x1
    3866:	bd0080e7          	jalr	-1072(ra) # 4432 <sbrk>
      write(fds[1], "x", 1);
    386a:	4605                	li	a2,1
    386c:	00002597          	auipc	a1,0x2
    3870:	e2c58593          	addi	a1,a1,-468 # 5698 <malloc+0xeb0>
    3874:	fb442503          	lw	a0,-76(s0)
    3878:	00001097          	auipc	ra,0x1
    387c:	b52080e7          	jalr	-1198(ra) # 43ca <write>
      for(;;) sleep(1000);
    3880:	3e800513          	li	a0,1000
    3884:	00001097          	auipc	ra,0x1
    3888:	bb6080e7          	jalr	-1098(ra) # 443a <sleep>
    388c:	bfd5                	j	3880 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    388e:	0991                	addi	s3,s3,4
    3890:	03498563          	beq	s3,s4,38ba <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    3894:	00001097          	auipc	ra,0x1
    3898:	b0e080e7          	jalr	-1266(ra) # 43a2 <fork>
    389c:	00a9a023          	sw	a0,0(s3)
    38a0:	d945                	beqz	a0,3850 <sbrkfail+0x4c>
    if(pids[i] != -1)
    38a2:	ff5506e3          	beq	a0,s5,388e <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    38a6:	4605                	li	a2,1
    38a8:	faf40593          	addi	a1,s0,-81
    38ac:	fb042503          	lw	a0,-80(s0)
    38b0:	00001097          	auipc	ra,0x1
    38b4:	b12080e7          	jalr	-1262(ra) # 43c2 <read>
    38b8:	bfd9                	j	388e <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    38ba:	6505                	lui	a0,0x1
    38bc:	00001097          	auipc	ra,0x1
    38c0:	b76080e7          	jalr	-1162(ra) # 4432 <sbrk>
    38c4:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    38c6:	5afd                	li	s5,-1
    38c8:	a021                	j	38d0 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    38ca:	0491                	addi	s1,s1,4
    38cc:	01448f63          	beq	s1,s4,38ea <sbrkfail+0xe6>
    if(pids[i] == -1)
    38d0:	4088                	lw	a0,0(s1)
    38d2:	ff550ce3          	beq	a0,s5,38ca <sbrkfail+0xc6>
    kill(pids[i]);
    38d6:	00001097          	auipc	ra,0x1
    38da:	b04080e7          	jalr	-1276(ra) # 43da <kill>
    wait(0);
    38de:	4501                	li	a0,0
    38e0:	00001097          	auipc	ra,0x1
    38e4:	ad2080e7          	jalr	-1326(ra) # 43b2 <wait>
    38e8:	b7cd                	j	38ca <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    38ea:	57fd                	li	a5,-1
    38ec:	02f98e63          	beq	s3,a5,3928 <sbrkfail+0x124>
  pid = fork();
    38f0:	00001097          	auipc	ra,0x1
    38f4:	ab2080e7          	jalr	-1358(ra) # 43a2 <fork>
    38f8:	84aa                	mv	s1,a0
  if(pid < 0){
    38fa:	04054563          	bltz	a0,3944 <sbrkfail+0x140>
  if(pid == 0){
    38fe:	c12d                	beqz	a0,3960 <sbrkfail+0x15c>
  wait(&xstatus);
    3900:	fbc40513          	addi	a0,s0,-68
    3904:	00001097          	auipc	ra,0x1
    3908:	aae080e7          	jalr	-1362(ra) # 43b2 <wait>
  if(xstatus != -1)
    390c:	fbc42703          	lw	a4,-68(s0)
    3910:	57fd                	li	a5,-1
    3912:	08f71c63          	bne	a4,a5,39aa <sbrkfail+0x1a6>
}
    3916:	70e6                	ld	ra,120(sp)
    3918:	7446                	ld	s0,112(sp)
    391a:	74a6                	ld	s1,104(sp)
    391c:	7906                	ld	s2,96(sp)
    391e:	69e6                	ld	s3,88(sp)
    3920:	6a46                	ld	s4,80(sp)
    3922:	6aa6                	ld	s5,72(sp)
    3924:	6109                	addi	sp,sp,128
    3926:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3928:	85ca                	mv	a1,s2
    392a:	00003517          	auipc	a0,0x3
    392e:	ac650513          	addi	a0,a0,-1338 # 63f0 <malloc+0x1c08>
    3932:	00001097          	auipc	ra,0x1
    3936:	df8080e7          	jalr	-520(ra) # 472a <printf>
    exit(1);
    393a:	4505                	li	a0,1
    393c:	00001097          	auipc	ra,0x1
    3940:	a6e080e7          	jalr	-1426(ra) # 43aa <exit>
    printf("%s: fork failed\n", s);
    3944:	85ca                	mv	a1,s2
    3946:	00001517          	auipc	a0,0x1
    394a:	3a250513          	addi	a0,a0,930 # 4ce8 <malloc+0x500>
    394e:	00001097          	auipc	ra,0x1
    3952:	ddc080e7          	jalr	-548(ra) # 472a <printf>
    exit(1);
    3956:	4505                	li	a0,1
    3958:	00001097          	auipc	ra,0x1
    395c:	a52080e7          	jalr	-1454(ra) # 43aa <exit>
    a = sbrk(0);
    3960:	4501                	li	a0,0
    3962:	00001097          	auipc	ra,0x1
    3966:	ad0080e7          	jalr	-1328(ra) # 4432 <sbrk>
    396a:	892a                	mv	s2,a0
    sbrk(10*BIG);
    396c:	3e800537          	lui	a0,0x3e800
    3970:	00001097          	auipc	ra,0x1
    3974:	ac2080e7          	jalr	-1342(ra) # 4432 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3978:	874a                	mv	a4,s2
    397a:	3e8007b7          	lui	a5,0x3e800
    397e:	97ca                	add	a5,a5,s2
    3980:	6685                	lui	a3,0x1
      n += *(a+i);
    3982:	00074603          	lbu	a2,0(a4)
    3986:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3988:	9736                	add	a4,a4,a3
    398a:	fef71ce3          	bne	a4,a5,3982 <sbrkfail+0x17e>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    398e:	85a6                	mv	a1,s1
    3990:	00003517          	auipc	a0,0x3
    3994:	a8050513          	addi	a0,a0,-1408 # 6410 <malloc+0x1c28>
    3998:	00001097          	auipc	ra,0x1
    399c:	d92080e7          	jalr	-622(ra) # 472a <printf>
    exit(1);
    39a0:	4505                	li	a0,1
    39a2:	00001097          	auipc	ra,0x1
    39a6:	a08080e7          	jalr	-1528(ra) # 43aa <exit>
    exit(1);
    39aa:	4505                	li	a0,1
    39ac:	00001097          	auipc	ra,0x1
    39b0:	9fe080e7          	jalr	-1538(ra) # 43aa <exit>

00000000000039b4 <sbrkarg>:
{
    39b4:	7179                	addi	sp,sp,-48
    39b6:	f406                	sd	ra,40(sp)
    39b8:	f022                	sd	s0,32(sp)
    39ba:	ec26                	sd	s1,24(sp)
    39bc:	e84a                	sd	s2,16(sp)
    39be:	e44e                	sd	s3,8(sp)
    39c0:	1800                	addi	s0,sp,48
    39c2:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    39c4:	6505                	lui	a0,0x1
    39c6:	00001097          	auipc	ra,0x1
    39ca:	a6c080e7          	jalr	-1428(ra) # 4432 <sbrk>
    39ce:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    39d0:	20100593          	li	a1,513
    39d4:	00003517          	auipc	a0,0x3
    39d8:	a6c50513          	addi	a0,a0,-1428 # 6440 <malloc+0x1c58>
    39dc:	00001097          	auipc	ra,0x1
    39e0:	a0e080e7          	jalr	-1522(ra) # 43ea <open>
    39e4:	84aa                	mv	s1,a0
  unlink("sbrk");
    39e6:	00003517          	auipc	a0,0x3
    39ea:	a5a50513          	addi	a0,a0,-1446 # 6440 <malloc+0x1c58>
    39ee:	00001097          	auipc	ra,0x1
    39f2:	a0c080e7          	jalr	-1524(ra) # 43fa <unlink>
  if(fd < 0)  {
    39f6:	0404c163          	bltz	s1,3a38 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    39fa:	6605                	lui	a2,0x1
    39fc:	85ca                	mv	a1,s2
    39fe:	8526                	mv	a0,s1
    3a00:	00001097          	auipc	ra,0x1
    3a04:	9ca080e7          	jalr	-1590(ra) # 43ca <write>
    3a08:	04054663          	bltz	a0,3a54 <sbrkarg+0xa0>
  close(fd);
    3a0c:	8526                	mv	a0,s1
    3a0e:	00001097          	auipc	ra,0x1
    3a12:	9c4080e7          	jalr	-1596(ra) # 43d2 <close>
  a = sbrk(PGSIZE);
    3a16:	6505                	lui	a0,0x1
    3a18:	00001097          	auipc	ra,0x1
    3a1c:	a1a080e7          	jalr	-1510(ra) # 4432 <sbrk>
  if(pipe((int *) a) != 0){
    3a20:	00001097          	auipc	ra,0x1
    3a24:	99a080e7          	jalr	-1638(ra) # 43ba <pipe>
    3a28:	e521                	bnez	a0,3a70 <sbrkarg+0xbc>
}
    3a2a:	70a2                	ld	ra,40(sp)
    3a2c:	7402                	ld	s0,32(sp)
    3a2e:	64e2                	ld	s1,24(sp)
    3a30:	6942                	ld	s2,16(sp)
    3a32:	69a2                	ld	s3,8(sp)
    3a34:	6145                	addi	sp,sp,48
    3a36:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    3a38:	85ce                	mv	a1,s3
    3a3a:	00003517          	auipc	a0,0x3
    3a3e:	a0e50513          	addi	a0,a0,-1522 # 6448 <malloc+0x1c60>
    3a42:	00001097          	auipc	ra,0x1
    3a46:	ce8080e7          	jalr	-792(ra) # 472a <printf>
    exit(1);
    3a4a:	4505                	li	a0,1
    3a4c:	00001097          	auipc	ra,0x1
    3a50:	95e080e7          	jalr	-1698(ra) # 43aa <exit>
    printf("%s: write sbrk failed\n", s);
    3a54:	85ce                	mv	a1,s3
    3a56:	00003517          	auipc	a0,0x3
    3a5a:	a0a50513          	addi	a0,a0,-1526 # 6460 <malloc+0x1c78>
    3a5e:	00001097          	auipc	ra,0x1
    3a62:	ccc080e7          	jalr	-820(ra) # 472a <printf>
    exit(1);
    3a66:	4505                	li	a0,1
    3a68:	00001097          	auipc	ra,0x1
    3a6c:	942080e7          	jalr	-1726(ra) # 43aa <exit>
    printf("%s: pipe() failed\n", s);
    3a70:	85ce                	mv	a1,s3
    3a72:	00002517          	auipc	a0,0x2
    3a76:	ba650513          	addi	a0,a0,-1114 # 5618 <malloc+0xe30>
    3a7a:	00001097          	auipc	ra,0x1
    3a7e:	cb0080e7          	jalr	-848(ra) # 472a <printf>
    exit(1);
    3a82:	4505                	li	a0,1
    3a84:	00001097          	auipc	ra,0x1
    3a88:	926080e7          	jalr	-1754(ra) # 43aa <exit>

0000000000003a8c <argptest>:
{
    3a8c:	1101                	addi	sp,sp,-32
    3a8e:	ec06                	sd	ra,24(sp)
    3a90:	e822                	sd	s0,16(sp)
    3a92:	e426                	sd	s1,8(sp)
    3a94:	e04a                	sd	s2,0(sp)
    3a96:	1000                	addi	s0,sp,32
    3a98:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3a9a:	4581                	li	a1,0
    3a9c:	00003517          	auipc	a0,0x3
    3aa0:	9dc50513          	addi	a0,a0,-1572 # 6478 <malloc+0x1c90>
    3aa4:	00001097          	auipc	ra,0x1
    3aa8:	946080e7          	jalr	-1722(ra) # 43ea <open>
  if (fd < 0) {
    3aac:	02054b63          	bltz	a0,3ae2 <argptest+0x56>
    3ab0:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3ab2:	4501                	li	a0,0
    3ab4:	00001097          	auipc	ra,0x1
    3ab8:	97e080e7          	jalr	-1666(ra) # 4432 <sbrk>
    3abc:	567d                	li	a2,-1
    3abe:	fff50593          	addi	a1,a0,-1
    3ac2:	8526                	mv	a0,s1
    3ac4:	00001097          	auipc	ra,0x1
    3ac8:	8fe080e7          	jalr	-1794(ra) # 43c2 <read>
  close(fd);
    3acc:	8526                	mv	a0,s1
    3ace:	00001097          	auipc	ra,0x1
    3ad2:	904080e7          	jalr	-1788(ra) # 43d2 <close>
}
    3ad6:	60e2                	ld	ra,24(sp)
    3ad8:	6442                	ld	s0,16(sp)
    3ada:	64a2                	ld	s1,8(sp)
    3adc:	6902                	ld	s2,0(sp)
    3ade:	6105                	addi	sp,sp,32
    3ae0:	8082                	ret
    printf("%s: open failed\n", s);
    3ae2:	85ca                	mv	a1,s2
    3ae4:	00002517          	auipc	a0,0x2
    3ae8:	9d450513          	addi	a0,a0,-1580 # 54b8 <malloc+0xcd0>
    3aec:	00001097          	auipc	ra,0x1
    3af0:	c3e080e7          	jalr	-962(ra) # 472a <printf>
    exit(1);
    3af4:	4505                	li	a0,1
    3af6:	00001097          	auipc	ra,0x1
    3afa:	8b4080e7          	jalr	-1868(ra) # 43aa <exit>

0000000000003afe <sbrkbugs>:
{
    3afe:	1141                	addi	sp,sp,-16
    3b00:	e406                	sd	ra,8(sp)
    3b02:	e022                	sd	s0,0(sp)
    3b04:	0800                	addi	s0,sp,16
  int pid = fork();
    3b06:	00001097          	auipc	ra,0x1
    3b0a:	89c080e7          	jalr	-1892(ra) # 43a2 <fork>
  if(pid < 0){
    3b0e:	02054263          	bltz	a0,3b32 <sbrkbugs+0x34>
  if(pid == 0){
    3b12:	ed0d                	bnez	a0,3b4c <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    3b14:	00001097          	auipc	ra,0x1
    3b18:	91e080e7          	jalr	-1762(ra) # 4432 <sbrk>
    sbrk(-sz);
    3b1c:	40a0053b          	negw	a0,a0
    3b20:	00001097          	auipc	ra,0x1
    3b24:	912080e7          	jalr	-1774(ra) # 4432 <sbrk>
    exit(0);
    3b28:	4501                	li	a0,0
    3b2a:	00001097          	auipc	ra,0x1
    3b2e:	880080e7          	jalr	-1920(ra) # 43aa <exit>
    printf("fork failed\n");
    3b32:	00002517          	auipc	a0,0x2
    3b36:	ab650513          	addi	a0,a0,-1354 # 55e8 <malloc+0xe00>
    3b3a:	00001097          	auipc	ra,0x1
    3b3e:	bf0080e7          	jalr	-1040(ra) # 472a <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00001097          	auipc	ra,0x1
    3b48:	866080e7          	jalr	-1946(ra) # 43aa <exit>
  wait(0);
    3b4c:	4501                	li	a0,0
    3b4e:	00001097          	auipc	ra,0x1
    3b52:	864080e7          	jalr	-1948(ra) # 43b2 <wait>
  pid = fork();
    3b56:	00001097          	auipc	ra,0x1
    3b5a:	84c080e7          	jalr	-1972(ra) # 43a2 <fork>
  if(pid < 0){
    3b5e:	02054563          	bltz	a0,3b88 <sbrkbugs+0x8a>
  if(pid == 0){
    3b62:	e121                	bnez	a0,3ba2 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    3b64:	00001097          	auipc	ra,0x1
    3b68:	8ce080e7          	jalr	-1842(ra) # 4432 <sbrk>
    sbrk(-(sz - 3500));
    3b6c:	6785                	lui	a5,0x1
    3b6e:	dac7879b          	addiw	a5,a5,-596
    3b72:	40a7853b          	subw	a0,a5,a0
    3b76:	00001097          	auipc	ra,0x1
    3b7a:	8bc080e7          	jalr	-1860(ra) # 4432 <sbrk>
    exit(0);
    3b7e:	4501                	li	a0,0
    3b80:	00001097          	auipc	ra,0x1
    3b84:	82a080e7          	jalr	-2006(ra) # 43aa <exit>
    printf("fork failed\n");
    3b88:	00002517          	auipc	a0,0x2
    3b8c:	a6050513          	addi	a0,a0,-1440 # 55e8 <malloc+0xe00>
    3b90:	00001097          	auipc	ra,0x1
    3b94:	b9a080e7          	jalr	-1126(ra) # 472a <printf>
    exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	00001097          	auipc	ra,0x1
    3b9e:	810080e7          	jalr	-2032(ra) # 43aa <exit>
  wait(0);
    3ba2:	4501                	li	a0,0
    3ba4:	00001097          	auipc	ra,0x1
    3ba8:	80e080e7          	jalr	-2034(ra) # 43b2 <wait>
  pid = fork();
    3bac:	00000097          	auipc	ra,0x0
    3bb0:	7f6080e7          	jalr	2038(ra) # 43a2 <fork>
  if(pid < 0){
    3bb4:	02054a63          	bltz	a0,3be8 <sbrkbugs+0xea>
  if(pid == 0){
    3bb8:	e529                	bnez	a0,3c02 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    3bba:	00001097          	auipc	ra,0x1
    3bbe:	878080e7          	jalr	-1928(ra) # 4432 <sbrk>
    3bc2:	67ad                	lui	a5,0xb
    3bc4:	8007879b          	addiw	a5,a5,-2048
    3bc8:	40a7853b          	subw	a0,a5,a0
    3bcc:	00001097          	auipc	ra,0x1
    3bd0:	866080e7          	jalr	-1946(ra) # 4432 <sbrk>
    sbrk(-10);
    3bd4:	5559                	li	a0,-10
    3bd6:	00001097          	auipc	ra,0x1
    3bda:	85c080e7          	jalr	-1956(ra) # 4432 <sbrk>
    exit(0);
    3bde:	4501                	li	a0,0
    3be0:	00000097          	auipc	ra,0x0
    3be4:	7ca080e7          	jalr	1994(ra) # 43aa <exit>
    printf("fork failed\n");
    3be8:	00002517          	auipc	a0,0x2
    3bec:	a0050513          	addi	a0,a0,-1536 # 55e8 <malloc+0xe00>
    3bf0:	00001097          	auipc	ra,0x1
    3bf4:	b3a080e7          	jalr	-1222(ra) # 472a <printf>
    exit(1);
    3bf8:	4505                	li	a0,1
    3bfa:	00000097          	auipc	ra,0x0
    3bfe:	7b0080e7          	jalr	1968(ra) # 43aa <exit>
  wait(0);
    3c02:	4501                	li	a0,0
    3c04:	00000097          	auipc	ra,0x0
    3c08:	7ae080e7          	jalr	1966(ra) # 43b2 <wait>
  exit(0);
    3c0c:	4501                	li	a0,0
    3c0e:	00000097          	auipc	ra,0x0
    3c12:	79c080e7          	jalr	1948(ra) # 43aa <exit>

0000000000003c16 <dirtest>:
{
    3c16:	1101                	addi	sp,sp,-32
    3c18:	ec06                	sd	ra,24(sp)
    3c1a:	e822                	sd	s0,16(sp)
    3c1c:	e426                	sd	s1,8(sp)
    3c1e:	1000                	addi	s0,sp,32
    3c20:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    3c22:	00003517          	auipc	a0,0x3
    3c26:	85e50513          	addi	a0,a0,-1954 # 6480 <malloc+0x1c98>
    3c2a:	00001097          	auipc	ra,0x1
    3c2e:	b00080e7          	jalr	-1280(ra) # 472a <printf>
  if(mkdir("dir0") < 0){
    3c32:	00003517          	auipc	a0,0x3
    3c36:	85e50513          	addi	a0,a0,-1954 # 6490 <malloc+0x1ca8>
    3c3a:	00000097          	auipc	ra,0x0
    3c3e:	7d8080e7          	jalr	2008(ra) # 4412 <mkdir>
    3c42:	04054d63          	bltz	a0,3c9c <dirtest+0x86>
  if(chdir("dir0") < 0){
    3c46:	00003517          	auipc	a0,0x3
    3c4a:	84a50513          	addi	a0,a0,-1974 # 6490 <malloc+0x1ca8>
    3c4e:	00000097          	auipc	ra,0x0
    3c52:	7cc080e7          	jalr	1996(ra) # 441a <chdir>
    3c56:	06054163          	bltz	a0,3cb8 <dirtest+0xa2>
  if(chdir("..") < 0){
    3c5a:	00001517          	auipc	a0,0x1
    3c5e:	ffe50513          	addi	a0,a0,-2 # 4c58 <malloc+0x470>
    3c62:	00000097          	auipc	ra,0x0
    3c66:	7b8080e7          	jalr	1976(ra) # 441a <chdir>
    3c6a:	06054563          	bltz	a0,3cd4 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    3c6e:	00003517          	auipc	a0,0x3
    3c72:	82250513          	addi	a0,a0,-2014 # 6490 <malloc+0x1ca8>
    3c76:	00000097          	auipc	ra,0x0
    3c7a:	784080e7          	jalr	1924(ra) # 43fa <unlink>
    3c7e:	06054963          	bltz	a0,3cf0 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    3c82:	00003517          	auipc	a0,0x3
    3c86:	85e50513          	addi	a0,a0,-1954 # 64e0 <malloc+0x1cf8>
    3c8a:	00001097          	auipc	ra,0x1
    3c8e:	aa0080e7          	jalr	-1376(ra) # 472a <printf>
}
    3c92:	60e2                	ld	ra,24(sp)
    3c94:	6442                	ld	s0,16(sp)
    3c96:	64a2                	ld	s1,8(sp)
    3c98:	6105                	addi	sp,sp,32
    3c9a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3c9c:	85a6                	mv	a1,s1
    3c9e:	00001517          	auipc	a0,0x1
    3ca2:	eda50513          	addi	a0,a0,-294 # 4b78 <malloc+0x390>
    3ca6:	00001097          	auipc	ra,0x1
    3caa:	a84080e7          	jalr	-1404(ra) # 472a <printf>
    exit(1);
    3cae:	4505                	li	a0,1
    3cb0:	00000097          	auipc	ra,0x0
    3cb4:	6fa080e7          	jalr	1786(ra) # 43aa <exit>
    printf("%s: chdir dir0 failed\n", s);
    3cb8:	85a6                	mv	a1,s1
    3cba:	00002517          	auipc	a0,0x2
    3cbe:	7de50513          	addi	a0,a0,2014 # 6498 <malloc+0x1cb0>
    3cc2:	00001097          	auipc	ra,0x1
    3cc6:	a68080e7          	jalr	-1432(ra) # 472a <printf>
    exit(1);
    3cca:	4505                	li	a0,1
    3ccc:	00000097          	auipc	ra,0x0
    3cd0:	6de080e7          	jalr	1758(ra) # 43aa <exit>
    printf("%s: chdir .. failed\n", s);
    3cd4:	85a6                	mv	a1,s1
    3cd6:	00002517          	auipc	a0,0x2
    3cda:	7da50513          	addi	a0,a0,2010 # 64b0 <malloc+0x1cc8>
    3cde:	00001097          	auipc	ra,0x1
    3ce2:	a4c080e7          	jalr	-1460(ra) # 472a <printf>
    exit(1);
    3ce6:	4505                	li	a0,1
    3ce8:	00000097          	auipc	ra,0x0
    3cec:	6c2080e7          	jalr	1730(ra) # 43aa <exit>
    printf("%s: unlink dir0 failed\n", s);
    3cf0:	85a6                	mv	a1,s1
    3cf2:	00002517          	auipc	a0,0x2
    3cf6:	7d650513          	addi	a0,a0,2006 # 64c8 <malloc+0x1ce0>
    3cfa:	00001097          	auipc	ra,0x1
    3cfe:	a30080e7          	jalr	-1488(ra) # 472a <printf>
    exit(1);
    3d02:	4505                	li	a0,1
    3d04:	00000097          	auipc	ra,0x0
    3d08:	6a6080e7          	jalr	1702(ra) # 43aa <exit>

0000000000003d0c <fsfull>:
{
    3d0c:	7171                	addi	sp,sp,-176
    3d0e:	f506                	sd	ra,168(sp)
    3d10:	f122                	sd	s0,160(sp)
    3d12:	ed26                	sd	s1,152(sp)
    3d14:	e94a                	sd	s2,144(sp)
    3d16:	e54e                	sd	s3,136(sp)
    3d18:	e152                	sd	s4,128(sp)
    3d1a:	fcd6                	sd	s5,120(sp)
    3d1c:	f8da                	sd	s6,112(sp)
    3d1e:	f4de                	sd	s7,104(sp)
    3d20:	f0e2                	sd	s8,96(sp)
    3d22:	ece6                	sd	s9,88(sp)
    3d24:	e8ea                	sd	s10,80(sp)
    3d26:	e4ee                	sd	s11,72(sp)
    3d28:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    3d2a:	00002517          	auipc	a0,0x2
    3d2e:	7ce50513          	addi	a0,a0,1998 # 64f8 <malloc+0x1d10>
    3d32:	00001097          	auipc	ra,0x1
    3d36:	9f8080e7          	jalr	-1544(ra) # 472a <printf>
  for(nfiles = 0; ; nfiles++){
    3d3a:	4481                	li	s1,0
    name[0] = 'f';
    3d3c:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    3d40:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3d44:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    3d48:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    3d4a:	00002c97          	auipc	s9,0x2
    3d4e:	7bec8c93          	addi	s9,s9,1982 # 6508 <malloc+0x1d20>
    int total = 0;
    3d52:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    3d54:	00005a17          	auipc	s4,0x5
    3d58:	454a0a13          	addi	s4,s4,1108 # 91a8 <buf>
    name[0] = 'f';
    3d5c:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3d60:	0384c7bb          	divw	a5,s1,s8
    3d64:	0307879b          	addiw	a5,a5,48
    3d68:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3d6c:	0384e7bb          	remw	a5,s1,s8
    3d70:	0377c7bb          	divw	a5,a5,s7
    3d74:	0307879b          	addiw	a5,a5,48
    3d78:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3d7c:	0374e7bb          	remw	a5,s1,s7
    3d80:	0367c7bb          	divw	a5,a5,s6
    3d84:	0307879b          	addiw	a5,a5,48
    3d88:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3d8c:	0364e7bb          	remw	a5,s1,s6
    3d90:	0307879b          	addiw	a5,a5,48
    3d94:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3d98:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    3d9c:	f5040593          	addi	a1,s0,-176
    3da0:	8566                	mv	a0,s9
    3da2:	00001097          	auipc	ra,0x1
    3da6:	988080e7          	jalr	-1656(ra) # 472a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3daa:	20200593          	li	a1,514
    3dae:	f5040513          	addi	a0,s0,-176
    3db2:	00000097          	auipc	ra,0x0
    3db6:	638080e7          	jalr	1592(ra) # 43ea <open>
    3dba:	892a                	mv	s2,a0
    if(fd < 0){
    3dbc:	0a055663          	bgez	a0,3e68 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    3dc0:	f5040593          	addi	a1,s0,-176
    3dc4:	00002517          	auipc	a0,0x2
    3dc8:	75450513          	addi	a0,a0,1876 # 6518 <malloc+0x1d30>
    3dcc:	00001097          	auipc	ra,0x1
    3dd0:	95e080e7          	jalr	-1698(ra) # 472a <printf>
  while(nfiles >= 0){
    3dd4:	0604c363          	bltz	s1,3e3a <fsfull+0x12e>
    name[0] = 'f';
    3dd8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    3ddc:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3de0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3de4:	4929                	li	s2,10
  while(nfiles >= 0){
    3de6:	5afd                	li	s5,-1
    name[0] = 'f';
    3de8:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3dec:	0344c7bb          	divw	a5,s1,s4
    3df0:	0307879b          	addiw	a5,a5,48
    3df4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3df8:	0344e7bb          	remw	a5,s1,s4
    3dfc:	0337c7bb          	divw	a5,a5,s3
    3e00:	0307879b          	addiw	a5,a5,48
    3e04:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3e08:	0334e7bb          	remw	a5,s1,s3
    3e0c:	0327c7bb          	divw	a5,a5,s2
    3e10:	0307879b          	addiw	a5,a5,48
    3e14:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3e18:	0324e7bb          	remw	a5,s1,s2
    3e1c:	0307879b          	addiw	a5,a5,48
    3e20:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3e24:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    3e28:	f5040513          	addi	a0,s0,-176
    3e2c:	00000097          	auipc	ra,0x0
    3e30:	5ce080e7          	jalr	1486(ra) # 43fa <unlink>
    nfiles--;
    3e34:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    3e36:	fb5499e3          	bne	s1,s5,3de8 <fsfull+0xdc>
  printf("fsfull test finished\n");
    3e3a:	00002517          	auipc	a0,0x2
    3e3e:	70e50513          	addi	a0,a0,1806 # 6548 <malloc+0x1d60>
    3e42:	00001097          	auipc	ra,0x1
    3e46:	8e8080e7          	jalr	-1816(ra) # 472a <printf>
}
    3e4a:	70aa                	ld	ra,168(sp)
    3e4c:	740a                	ld	s0,160(sp)
    3e4e:	64ea                	ld	s1,152(sp)
    3e50:	694a                	ld	s2,144(sp)
    3e52:	69aa                	ld	s3,136(sp)
    3e54:	6a0a                	ld	s4,128(sp)
    3e56:	7ae6                	ld	s5,120(sp)
    3e58:	7b46                	ld	s6,112(sp)
    3e5a:	7ba6                	ld	s7,104(sp)
    3e5c:	7c06                	ld	s8,96(sp)
    3e5e:	6ce6                	ld	s9,88(sp)
    3e60:	6d46                	ld	s10,80(sp)
    3e62:	6da6                	ld	s11,72(sp)
    3e64:	614d                	addi	sp,sp,176
    3e66:	8082                	ret
    int total = 0;
    3e68:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3e6a:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3e6e:	40000613          	li	a2,1024
    3e72:	85d2                	mv	a1,s4
    3e74:	854a                	mv	a0,s2
    3e76:	00000097          	auipc	ra,0x0
    3e7a:	554080e7          	jalr	1364(ra) # 43ca <write>
      if(cc < BSIZE)
    3e7e:	00aad563          	bge	s5,a0,3e88 <fsfull+0x17c>
      total += cc;
    3e82:	00a989bb          	addw	s3,s3,a0
    while(1){
    3e86:	b7e5                	j	3e6e <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    3e88:	85ce                	mv	a1,s3
    3e8a:	00002517          	auipc	a0,0x2
    3e8e:	6a650513          	addi	a0,a0,1702 # 6530 <malloc+0x1d48>
    3e92:	00001097          	auipc	ra,0x1
    3e96:	898080e7          	jalr	-1896(ra) # 472a <printf>
    close(fd);
    3e9a:	854a                	mv	a0,s2
    3e9c:	00000097          	auipc	ra,0x0
    3ea0:	536080e7          	jalr	1334(ra) # 43d2 <close>
    if(total == 0)
    3ea4:	f20988e3          	beqz	s3,3dd4 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3ea8:	2485                	addiw	s1,s1,1
    3eaa:	bd4d                	j	3d5c <fsfull+0x50>

0000000000003eac <rand>:
{
    3eac:	1141                	addi	sp,sp,-16
    3eae:	e422                	sd	s0,8(sp)
    3eb0:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3eb2:	00003717          	auipc	a4,0x3
    3eb6:	ace70713          	addi	a4,a4,-1330 # 6980 <randstate>
    3eba:	6308                	ld	a0,0(a4)
    3ebc:	001967b7          	lui	a5,0x196
    3ec0:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18a455>
    3ec4:	02f50533          	mul	a0,a0,a5
    3ec8:	3c6ef7b7          	lui	a5,0x3c6ef
    3ecc:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e31a7>
    3ed0:	953e                	add	a0,a0,a5
    3ed2:	e308                	sd	a0,0(a4)
}
    3ed4:	2501                	sext.w	a0,a0
    3ed6:	6422                	ld	s0,8(sp)
    3ed8:	0141                	addi	sp,sp,16
    3eda:	8082                	ret

0000000000003edc <badwrite>:
{
    3edc:	7179                	addi	sp,sp,-48
    3ede:	f406                	sd	ra,40(sp)
    3ee0:	f022                	sd	s0,32(sp)
    3ee2:	ec26                	sd	s1,24(sp)
    3ee4:	e84a                	sd	s2,16(sp)
    3ee6:	e44e                	sd	s3,8(sp)
    3ee8:	e052                	sd	s4,0(sp)
    3eea:	1800                	addi	s0,sp,48
  unlink("junk");
    3eec:	00002517          	auipc	a0,0x2
    3ef0:	67450513          	addi	a0,a0,1652 # 6560 <malloc+0x1d78>
    3ef4:	00000097          	auipc	ra,0x0
    3ef8:	506080e7          	jalr	1286(ra) # 43fa <unlink>
    3efc:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f00:	00002997          	auipc	s3,0x2
    3f04:	66098993          	addi	s3,s3,1632 # 6560 <malloc+0x1d78>
    write(fd, (char*)0xffffffffffL, 1);
    3f08:	5a7d                	li	s4,-1
    3f0a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f0e:	20100593          	li	a1,513
    3f12:	854e                	mv	a0,s3
    3f14:	00000097          	auipc	ra,0x0
    3f18:	4d6080e7          	jalr	1238(ra) # 43ea <open>
    3f1c:	84aa                	mv	s1,a0
    if(fd < 0){
    3f1e:	06054b63          	bltz	a0,3f94 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    3f22:	4605                	li	a2,1
    3f24:	85d2                	mv	a1,s4
    3f26:	00000097          	auipc	ra,0x0
    3f2a:	4a4080e7          	jalr	1188(ra) # 43ca <write>
    close(fd);
    3f2e:	8526                	mv	a0,s1
    3f30:	00000097          	auipc	ra,0x0
    3f34:	4a2080e7          	jalr	1186(ra) # 43d2 <close>
    unlink("junk");
    3f38:	854e                	mv	a0,s3
    3f3a:	00000097          	auipc	ra,0x0
    3f3e:	4c0080e7          	jalr	1216(ra) # 43fa <unlink>
  for(int i = 0; i < assumed_free; i++){
    3f42:	397d                	addiw	s2,s2,-1
    3f44:	fc0915e3          	bnez	s2,3f0e <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    3f48:	20100593          	li	a1,513
    3f4c:	00002517          	auipc	a0,0x2
    3f50:	61450513          	addi	a0,a0,1556 # 6560 <malloc+0x1d78>
    3f54:	00000097          	auipc	ra,0x0
    3f58:	496080e7          	jalr	1174(ra) # 43ea <open>
    3f5c:	84aa                	mv	s1,a0
  if(fd < 0){
    3f5e:	04054863          	bltz	a0,3fae <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    3f62:	4605                	li	a2,1
    3f64:	00001597          	auipc	a1,0x1
    3f68:	73458593          	addi	a1,a1,1844 # 5698 <malloc+0xeb0>
    3f6c:	00000097          	auipc	ra,0x0
    3f70:	45e080e7          	jalr	1118(ra) # 43ca <write>
    3f74:	4785                	li	a5,1
    3f76:	04f50963          	beq	a0,a5,3fc8 <badwrite+0xec>
    printf("write failed\n");
    3f7a:	00002517          	auipc	a0,0x2
    3f7e:	60650513          	addi	a0,a0,1542 # 6580 <malloc+0x1d98>
    3f82:	00000097          	auipc	ra,0x0
    3f86:	7a8080e7          	jalr	1960(ra) # 472a <printf>
    exit(1);
    3f8a:	4505                	li	a0,1
    3f8c:	00000097          	auipc	ra,0x0
    3f90:	41e080e7          	jalr	1054(ra) # 43aa <exit>
      printf("open junk failed\n");
    3f94:	00002517          	auipc	a0,0x2
    3f98:	5d450513          	addi	a0,a0,1492 # 6568 <malloc+0x1d80>
    3f9c:	00000097          	auipc	ra,0x0
    3fa0:	78e080e7          	jalr	1934(ra) # 472a <printf>
      exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	00000097          	auipc	ra,0x0
    3faa:	404080e7          	jalr	1028(ra) # 43aa <exit>
    printf("open junk failed\n");
    3fae:	00002517          	auipc	a0,0x2
    3fb2:	5ba50513          	addi	a0,a0,1466 # 6568 <malloc+0x1d80>
    3fb6:	00000097          	auipc	ra,0x0
    3fba:	774080e7          	jalr	1908(ra) # 472a <printf>
    exit(1);
    3fbe:	4505                	li	a0,1
    3fc0:	00000097          	auipc	ra,0x0
    3fc4:	3ea080e7          	jalr	1002(ra) # 43aa <exit>
  close(fd);
    3fc8:	8526                	mv	a0,s1
    3fca:	00000097          	auipc	ra,0x0
    3fce:	408080e7          	jalr	1032(ra) # 43d2 <close>
  unlink("junk");
    3fd2:	00002517          	auipc	a0,0x2
    3fd6:	58e50513          	addi	a0,a0,1422 # 6560 <malloc+0x1d78>
    3fda:	00000097          	auipc	ra,0x0
    3fde:	420080e7          	jalr	1056(ra) # 43fa <unlink>
  exit(0);
    3fe2:	4501                	li	a0,0
    3fe4:	00000097          	auipc	ra,0x0
    3fe8:	3c6080e7          	jalr	966(ra) # 43aa <exit>

0000000000003fec <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    3fec:	7179                	addi	sp,sp,-48
    3fee:	f406                	sd	ra,40(sp)
    3ff0:	f022                	sd	s0,32(sp)
    3ff2:	ec26                	sd	s1,24(sp)
    3ff4:	e84a                	sd	s2,16(sp)
    3ff6:	1800                	addi	s0,sp,48
    3ff8:	892a                	mv	s2,a0
    3ffa:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("test %s: ", s);
    3ffc:	00002517          	auipc	a0,0x2
    4000:	59450513          	addi	a0,a0,1428 # 6590 <malloc+0x1da8>
    4004:	00000097          	auipc	ra,0x0
    4008:	726080e7          	jalr	1830(ra) # 472a <printf>
  if((pid = fork()) < 0) {
    400c:	00000097          	auipc	ra,0x0
    4010:	396080e7          	jalr	918(ra) # 43a2 <fork>
    4014:	02054f63          	bltz	a0,4052 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4018:	c931                	beqz	a0,406c <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    401a:	fdc40513          	addi	a0,s0,-36
    401e:	00000097          	auipc	ra,0x0
    4022:	394080e7          	jalr	916(ra) # 43b2 <wait>
    if(xstatus != 0) 
    4026:	fdc42783          	lw	a5,-36(s0)
    402a:	cba1                	beqz	a5,407a <run+0x8e>
      printf("FAILED\n", s);
    402c:	85a6                	mv	a1,s1
    402e:	00002517          	auipc	a0,0x2
    4032:	58a50513          	addi	a0,a0,1418 # 65b8 <malloc+0x1dd0>
    4036:	00000097          	auipc	ra,0x0
    403a:	6f4080e7          	jalr	1780(ra) # 472a <printf>
    else
      printf("OK\n", s);
    return xstatus == 0;
    403e:	fdc42503          	lw	a0,-36(s0)
  }
}
    4042:	00153513          	seqz	a0,a0
    4046:	70a2                	ld	ra,40(sp)
    4048:	7402                	ld	s0,32(sp)
    404a:	64e2                	ld	s1,24(sp)
    404c:	6942                	ld	s2,16(sp)
    404e:	6145                	addi	sp,sp,48
    4050:	8082                	ret
    printf("runtest: fork error\n");
    4052:	00002517          	auipc	a0,0x2
    4056:	54e50513          	addi	a0,a0,1358 # 65a0 <malloc+0x1db8>
    405a:	00000097          	auipc	ra,0x0
    405e:	6d0080e7          	jalr	1744(ra) # 472a <printf>
    exit(1);
    4062:	4505                	li	a0,1
    4064:	00000097          	auipc	ra,0x0
    4068:	346080e7          	jalr	838(ra) # 43aa <exit>
    f(s);
    406c:	8526                	mv	a0,s1
    406e:	9902                	jalr	s2
    exit(0);
    4070:	4501                	li	a0,0
    4072:	00000097          	auipc	ra,0x0
    4076:	338080e7          	jalr	824(ra) # 43aa <exit>
      printf("OK\n", s);
    407a:	85a6                	mv	a1,s1
    407c:	00002517          	auipc	a0,0x2
    4080:	54450513          	addi	a0,a0,1348 # 65c0 <malloc+0x1dd8>
    4084:	00000097          	auipc	ra,0x0
    4088:	6a6080e7          	jalr	1702(ra) # 472a <printf>
    408c:	bf4d                	j	403e <run+0x52>

000000000000408e <main>:

int
main(int argc, char *argv[])
{
    408e:	ce010113          	addi	sp,sp,-800
    4092:	30113c23          	sd	ra,792(sp)
    4096:	30813823          	sd	s0,784(sp)
    409a:	30913423          	sd	s1,776(sp)
    409e:	31213023          	sd	s2,768(sp)
    40a2:	2f313c23          	sd	s3,760(sp)
    40a6:	2f413823          	sd	s4,752(sp)
    40aa:	1600                	addi	s0,sp,800
  char *n = 0;
  if(argc > 1) {
    40ac:	4785                	li	a5,1
  char *n = 0;
    40ae:	4901                	li	s2,0
  if(argc > 1) {
    40b0:	00a7d463          	bge	a5,a0,40b8 <main+0x2a>
    n = argv[1];
    40b4:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    40b8:	00002797          	auipc	a5,0x2
    40bc:	5b078793          	addi	a5,a5,1456 # 6668 <malloc+0x1e80>
    40c0:	ce040713          	addi	a4,s0,-800
    40c4:	00003817          	auipc	a6,0x3
    40c8:	88480813          	addi	a6,a6,-1916 # 6948 <malloc+0x2160>
    40cc:	6388                	ld	a0,0(a5)
    40ce:	678c                	ld	a1,8(a5)
    40d0:	6b90                	ld	a2,16(a5)
    40d2:	6f94                	ld	a3,24(a5)
    40d4:	e308                	sd	a0,0(a4)
    40d6:	e70c                	sd	a1,8(a4)
    40d8:	eb10                	sd	a2,16(a4)
    40da:	ef14                	sd	a3,24(a4)
    40dc:	02078793          	addi	a5,a5,32
    40e0:	02070713          	addi	a4,a4,32
    40e4:	ff0794e3          	bne	a5,a6,40cc <main+0x3e>
    40e8:	6394                	ld	a3,0(a5)
    40ea:	679c                	ld	a5,8(a5)
    40ec:	e314                	sd	a3,0(a4)
    40ee:	e71c                	sd	a5,8(a4)
    {forktest, "forktest"},
    {bigdir, "bigdir"}, // slow
    { 0, 0},
  };
    
  printf("usertests starting\n");
    40f0:	00002517          	auipc	a0,0x2
    40f4:	4d850513          	addi	a0,a0,1240 # 65c8 <malloc+0x1de0>
    40f8:	00000097          	auipc	ra,0x0
    40fc:	632080e7          	jalr	1586(ra) # 472a <printf>

  if(open("usertests.ran", 0) >= 0){
    4100:	4581                	li	a1,0
    4102:	00002517          	auipc	a0,0x2
    4106:	4de50513          	addi	a0,a0,1246 # 65e0 <malloc+0x1df8>
    410a:	00000097          	auipc	ra,0x0
    410e:	2e0080e7          	jalr	736(ra) # 43ea <open>
    4112:	00054f63          	bltz	a0,4130 <main+0xa2>
    printf("already ran user tests -- rebuild fs.img (rm fs.img; make fs.img)\n");
    4116:	00002517          	auipc	a0,0x2
    411a:	4da50513          	addi	a0,a0,1242 # 65f0 <malloc+0x1e08>
    411e:	00000097          	auipc	ra,0x0
    4122:	60c080e7          	jalr	1548(ra) # 472a <printf>
    exit(1);
    4126:	4505                	li	a0,1
    4128:	00000097          	auipc	ra,0x0
    412c:	282080e7          	jalr	642(ra) # 43aa <exit>
  }
  close(open("usertests.ran", O_CREATE));
    4130:	20000593          	li	a1,512
    4134:	00002517          	auipc	a0,0x2
    4138:	4ac50513          	addi	a0,a0,1196 # 65e0 <malloc+0x1df8>
    413c:	00000097          	auipc	ra,0x0
    4140:	2ae080e7          	jalr	686(ra) # 43ea <open>
    4144:	00000097          	auipc	ra,0x0
    4148:	28e080e7          	jalr	654(ra) # 43d2 <close>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    414c:	ce843503          	ld	a0,-792(s0)
    4150:	c529                	beqz	a0,419a <main+0x10c>
    4152:	ce040493          	addi	s1,s0,-800
  int fail = 0;
    4156:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4158:	4a05                	li	s4,1
    415a:	a021                	j	4162 <main+0xd4>
  for (struct test *t = tests; t->s != 0; t++) {
    415c:	04c1                	addi	s1,s1,16
    415e:	6488                	ld	a0,8(s1)
    4160:	c115                	beqz	a0,4184 <main+0xf6>
    if((n == 0) || strcmp(t->s, n) == 0) {
    4162:	00090863          	beqz	s2,4172 <main+0xe4>
    4166:	85ca                	mv	a1,s2
    4168:	00000097          	auipc	ra,0x0
    416c:	068080e7          	jalr	104(ra) # 41d0 <strcmp>
    4170:	f575                	bnez	a0,415c <main+0xce>
      if(!run(t->f, t->s))
    4172:	648c                	ld	a1,8(s1)
    4174:	6088                	ld	a0,0(s1)
    4176:	00000097          	auipc	ra,0x0
    417a:	e76080e7          	jalr	-394(ra) # 3fec <run>
    417e:	fd79                	bnez	a0,415c <main+0xce>
        fail = 1;
    4180:	89d2                	mv	s3,s4
    4182:	bfe9                	j	415c <main+0xce>
    }
  }
  if(!fail)
    4184:	00098b63          	beqz	s3,419a <main+0x10c>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
    4188:	00002517          	auipc	a0,0x2
    418c:	4c850513          	addi	a0,a0,1224 # 6650 <malloc+0x1e68>
    4190:	00000097          	auipc	ra,0x0
    4194:	59a080e7          	jalr	1434(ra) # 472a <printf>
    4198:	a809                	j	41aa <main+0x11c>
    printf("ALL TESTS PASSED\n");
    419a:	00002517          	auipc	a0,0x2
    419e:	49e50513          	addi	a0,a0,1182 # 6638 <malloc+0x1e50>
    41a2:	00000097          	auipc	ra,0x0
    41a6:	588080e7          	jalr	1416(ra) # 472a <printf>
  exit(1);   // not reached.
    41aa:	4505                	li	a0,1
    41ac:	00000097          	auipc	ra,0x0
    41b0:	1fe080e7          	jalr	510(ra) # 43aa <exit>

00000000000041b4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    41b4:	1141                	addi	sp,sp,-16
    41b6:	e422                	sd	s0,8(sp)
    41b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    41ba:	87aa                	mv	a5,a0
    41bc:	0585                	addi	a1,a1,1
    41be:	0785                	addi	a5,a5,1
    41c0:	fff5c703          	lbu	a4,-1(a1)
    41c4:	fee78fa3          	sb	a4,-1(a5)
    41c8:	fb75                	bnez	a4,41bc <strcpy+0x8>
    ;
  return os;
}
    41ca:	6422                	ld	s0,8(sp)
    41cc:	0141                	addi	sp,sp,16
    41ce:	8082                	ret

00000000000041d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    41d0:	1141                	addi	sp,sp,-16
    41d2:	e422                	sd	s0,8(sp)
    41d4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    41d6:	00054783          	lbu	a5,0(a0)
    41da:	cb91                	beqz	a5,41ee <strcmp+0x1e>
    41dc:	0005c703          	lbu	a4,0(a1)
    41e0:	00f71763          	bne	a4,a5,41ee <strcmp+0x1e>
    p++, q++;
    41e4:	0505                	addi	a0,a0,1
    41e6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    41e8:	00054783          	lbu	a5,0(a0)
    41ec:	fbe5                	bnez	a5,41dc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    41ee:	0005c503          	lbu	a0,0(a1)
}
    41f2:	40a7853b          	subw	a0,a5,a0
    41f6:	6422                	ld	s0,8(sp)
    41f8:	0141                	addi	sp,sp,16
    41fa:	8082                	ret

00000000000041fc <strlen>:

uint
strlen(const char *s)
{
    41fc:	1141                	addi	sp,sp,-16
    41fe:	e422                	sd	s0,8(sp)
    4200:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4202:	00054783          	lbu	a5,0(a0)
    4206:	cf91                	beqz	a5,4222 <strlen+0x26>
    4208:	0505                	addi	a0,a0,1
    420a:	87aa                	mv	a5,a0
    420c:	4685                	li	a3,1
    420e:	9e89                	subw	a3,a3,a0
    4210:	00f6853b          	addw	a0,a3,a5
    4214:	0785                	addi	a5,a5,1
    4216:	fff7c703          	lbu	a4,-1(a5)
    421a:	fb7d                	bnez	a4,4210 <strlen+0x14>
    ;
  return n;
}
    421c:	6422                	ld	s0,8(sp)
    421e:	0141                	addi	sp,sp,16
    4220:	8082                	ret
  for(n = 0; s[n]; n++)
    4222:	4501                	li	a0,0
    4224:	bfe5                	j	421c <strlen+0x20>

0000000000004226 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4226:	1141                	addi	sp,sp,-16
    4228:	e422                	sd	s0,8(sp)
    422a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    422c:	ce09                	beqz	a2,4246 <memset+0x20>
    422e:	87aa                	mv	a5,a0
    4230:	fff6071b          	addiw	a4,a2,-1
    4234:	1702                	slli	a4,a4,0x20
    4236:	9301                	srli	a4,a4,0x20
    4238:	0705                	addi	a4,a4,1
    423a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    423c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4240:	0785                	addi	a5,a5,1
    4242:	fee79de3          	bne	a5,a4,423c <memset+0x16>
  }
  return dst;
}
    4246:	6422                	ld	s0,8(sp)
    4248:	0141                	addi	sp,sp,16
    424a:	8082                	ret

000000000000424c <strchr>:

char*
strchr(const char *s, char c)
{
    424c:	1141                	addi	sp,sp,-16
    424e:	e422                	sd	s0,8(sp)
    4250:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4252:	00054783          	lbu	a5,0(a0)
    4256:	cb99                	beqz	a5,426c <strchr+0x20>
    if(*s == c)
    4258:	00f58763          	beq	a1,a5,4266 <strchr+0x1a>
  for(; *s; s++)
    425c:	0505                	addi	a0,a0,1
    425e:	00054783          	lbu	a5,0(a0)
    4262:	fbfd                	bnez	a5,4258 <strchr+0xc>
      return (char*)s;
  return 0;
    4264:	4501                	li	a0,0
}
    4266:	6422                	ld	s0,8(sp)
    4268:	0141                	addi	sp,sp,16
    426a:	8082                	ret
  return 0;
    426c:	4501                	li	a0,0
    426e:	bfe5                	j	4266 <strchr+0x1a>

0000000000004270 <gets>:

char*
gets(char *buf, int max)
{
    4270:	711d                	addi	sp,sp,-96
    4272:	ec86                	sd	ra,88(sp)
    4274:	e8a2                	sd	s0,80(sp)
    4276:	e4a6                	sd	s1,72(sp)
    4278:	e0ca                	sd	s2,64(sp)
    427a:	fc4e                	sd	s3,56(sp)
    427c:	f852                	sd	s4,48(sp)
    427e:	f456                	sd	s5,40(sp)
    4280:	f05a                	sd	s6,32(sp)
    4282:	ec5e                	sd	s7,24(sp)
    4284:	1080                	addi	s0,sp,96
    4286:	8baa                	mv	s7,a0
    4288:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    428a:	892a                	mv	s2,a0
    428c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    428e:	4aa9                	li	s5,10
    4290:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4292:	89a6                	mv	s3,s1
    4294:	2485                	addiw	s1,s1,1
    4296:	0344d863          	bge	s1,s4,42c6 <gets+0x56>
    cc = read(0, &c, 1);
    429a:	4605                	li	a2,1
    429c:	faf40593          	addi	a1,s0,-81
    42a0:	4501                	li	a0,0
    42a2:	00000097          	auipc	ra,0x0
    42a6:	120080e7          	jalr	288(ra) # 43c2 <read>
    if(cc < 1)
    42aa:	00a05e63          	blez	a0,42c6 <gets+0x56>
    buf[i++] = c;
    42ae:	faf44783          	lbu	a5,-81(s0)
    42b2:	00f90023          	sb	a5,0(s2) # 3000 <subdir+0x628>
    if(c == '\n' || c == '\r')
    42b6:	01578763          	beq	a5,s5,42c4 <gets+0x54>
    42ba:	0905                	addi	s2,s2,1
    42bc:	fd679be3          	bne	a5,s6,4292 <gets+0x22>
  for(i=0; i+1 < max; ){
    42c0:	89a6                	mv	s3,s1
    42c2:	a011                	j	42c6 <gets+0x56>
    42c4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    42c6:	99de                	add	s3,s3,s7
    42c8:	00098023          	sb	zero,0(s3)
  return buf;
}
    42cc:	855e                	mv	a0,s7
    42ce:	60e6                	ld	ra,88(sp)
    42d0:	6446                	ld	s0,80(sp)
    42d2:	64a6                	ld	s1,72(sp)
    42d4:	6906                	ld	s2,64(sp)
    42d6:	79e2                	ld	s3,56(sp)
    42d8:	7a42                	ld	s4,48(sp)
    42da:	7aa2                	ld	s5,40(sp)
    42dc:	7b02                	ld	s6,32(sp)
    42de:	6be2                	ld	s7,24(sp)
    42e0:	6125                	addi	sp,sp,96
    42e2:	8082                	ret

00000000000042e4 <stat>:

int
stat(const char *n, struct stat *st)
{
    42e4:	1101                	addi	sp,sp,-32
    42e6:	ec06                	sd	ra,24(sp)
    42e8:	e822                	sd	s0,16(sp)
    42ea:	e426                	sd	s1,8(sp)
    42ec:	e04a                	sd	s2,0(sp)
    42ee:	1000                	addi	s0,sp,32
    42f0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    42f2:	4581                	li	a1,0
    42f4:	00000097          	auipc	ra,0x0
    42f8:	0f6080e7          	jalr	246(ra) # 43ea <open>
  if(fd < 0)
    42fc:	02054563          	bltz	a0,4326 <stat+0x42>
    4300:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4302:	85ca                	mv	a1,s2
    4304:	00000097          	auipc	ra,0x0
    4308:	0fe080e7          	jalr	254(ra) # 4402 <fstat>
    430c:	892a                	mv	s2,a0
  close(fd);
    430e:	8526                	mv	a0,s1
    4310:	00000097          	auipc	ra,0x0
    4314:	0c2080e7          	jalr	194(ra) # 43d2 <close>
  return r;
}
    4318:	854a                	mv	a0,s2
    431a:	60e2                	ld	ra,24(sp)
    431c:	6442                	ld	s0,16(sp)
    431e:	64a2                	ld	s1,8(sp)
    4320:	6902                	ld	s2,0(sp)
    4322:	6105                	addi	sp,sp,32
    4324:	8082                	ret
    return -1;
    4326:	597d                	li	s2,-1
    4328:	bfc5                	j	4318 <stat+0x34>

000000000000432a <atoi>:

int
atoi(const char *s)
{
    432a:	1141                	addi	sp,sp,-16
    432c:	e422                	sd	s0,8(sp)
    432e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4330:	00054603          	lbu	a2,0(a0)
    4334:	fd06079b          	addiw	a5,a2,-48
    4338:	0ff7f793          	andi	a5,a5,255
    433c:	4725                	li	a4,9
    433e:	02f76963          	bltu	a4,a5,4370 <atoi+0x46>
    4342:	86aa                	mv	a3,a0
  n = 0;
    4344:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    4346:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    4348:	0685                	addi	a3,a3,1
    434a:	0025179b          	slliw	a5,a0,0x2
    434e:	9fa9                	addw	a5,a5,a0
    4350:	0017979b          	slliw	a5,a5,0x1
    4354:	9fb1                	addw	a5,a5,a2
    4356:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    435a:	0006c603          	lbu	a2,0(a3) # 1000 <writetest+0xc0>
    435e:	fd06071b          	addiw	a4,a2,-48
    4362:	0ff77713          	andi	a4,a4,255
    4366:	fee5f1e3          	bgeu	a1,a4,4348 <atoi+0x1e>
  return n;
}
    436a:	6422                	ld	s0,8(sp)
    436c:	0141                	addi	sp,sp,16
    436e:	8082                	ret
  n = 0;
    4370:	4501                	li	a0,0
    4372:	bfe5                	j	436a <atoi+0x40>

0000000000004374 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4374:	1141                	addi	sp,sp,-16
    4376:	e422                	sd	s0,8(sp)
    4378:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    437a:	02c05163          	blez	a2,439c <memmove+0x28>
    437e:	fff6071b          	addiw	a4,a2,-1
    4382:	1702                	slli	a4,a4,0x20
    4384:	9301                	srli	a4,a4,0x20
    4386:	0705                	addi	a4,a4,1
    4388:	972a                	add	a4,a4,a0
  dst = vdst;
    438a:	87aa                	mv	a5,a0
    *dst++ = *src++;
    438c:	0585                	addi	a1,a1,1
    438e:	0785                	addi	a5,a5,1
    4390:	fff5c683          	lbu	a3,-1(a1)
    4394:	fed78fa3          	sb	a3,-1(a5)
  while(n-- > 0)
    4398:	fee79ae3          	bne	a5,a4,438c <memmove+0x18>
  return vdst;
}
    439c:	6422                	ld	s0,8(sp)
    439e:	0141                	addi	sp,sp,16
    43a0:	8082                	ret

00000000000043a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    43a2:	4885                	li	a7,1
 ecall
    43a4:	00000073          	ecall
 ret
    43a8:	8082                	ret

00000000000043aa <exit>:
.global exit
exit:
 li a7, SYS_exit
    43aa:	4889                	li	a7,2
 ecall
    43ac:	00000073          	ecall
 ret
    43b0:	8082                	ret

00000000000043b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    43b2:	488d                	li	a7,3
 ecall
    43b4:	00000073          	ecall
 ret
    43b8:	8082                	ret

00000000000043ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    43ba:	4891                	li	a7,4
 ecall
    43bc:	00000073          	ecall
 ret
    43c0:	8082                	ret

00000000000043c2 <read>:
.global read
read:
 li a7, SYS_read
    43c2:	4895                	li	a7,5
 ecall
    43c4:	00000073          	ecall
 ret
    43c8:	8082                	ret

00000000000043ca <write>:
.global write
write:
 li a7, SYS_write
    43ca:	48c1                	li	a7,16
 ecall
    43cc:	00000073          	ecall
 ret
    43d0:	8082                	ret

00000000000043d2 <close>:
.global close
close:
 li a7, SYS_close
    43d2:	48d5                	li	a7,21
 ecall
    43d4:	00000073          	ecall
 ret
    43d8:	8082                	ret

00000000000043da <kill>:
.global kill
kill:
 li a7, SYS_kill
    43da:	4899                	li	a7,6
 ecall
    43dc:	00000073          	ecall
 ret
    43e0:	8082                	ret

00000000000043e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    43e2:	489d                	li	a7,7
 ecall
    43e4:	00000073          	ecall
 ret
    43e8:	8082                	ret

00000000000043ea <open>:
.global open
open:
 li a7, SYS_open
    43ea:	48bd                	li	a7,15
 ecall
    43ec:	00000073          	ecall
 ret
    43f0:	8082                	ret

00000000000043f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    43f2:	48c5                	li	a7,17
 ecall
    43f4:	00000073          	ecall
 ret
    43f8:	8082                	ret

00000000000043fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    43fa:	48c9                	li	a7,18
 ecall
    43fc:	00000073          	ecall
 ret
    4400:	8082                	ret

0000000000004402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4402:	48a1                	li	a7,8
 ecall
    4404:	00000073          	ecall
 ret
    4408:	8082                	ret

000000000000440a <link>:
.global link
link:
 li a7, SYS_link
    440a:	48cd                	li	a7,19
 ecall
    440c:	00000073          	ecall
 ret
    4410:	8082                	ret

0000000000004412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4412:	48d1                	li	a7,20
 ecall
    4414:	00000073          	ecall
 ret
    4418:	8082                	ret

000000000000441a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    441a:	48a5                	li	a7,9
 ecall
    441c:	00000073          	ecall
 ret
    4420:	8082                	ret

0000000000004422 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4422:	48a9                	li	a7,10
 ecall
    4424:	00000073          	ecall
 ret
    4428:	8082                	ret

000000000000442a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    442a:	48ad                	li	a7,11
 ecall
    442c:	00000073          	ecall
 ret
    4430:	8082                	ret

0000000000004432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4432:	48b1                	li	a7,12
 ecall
    4434:	00000073          	ecall
 ret
    4438:	8082                	ret

000000000000443a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    443a:	48b5                	li	a7,13
 ecall
    443c:	00000073          	ecall
 ret
    4440:	8082                	ret

0000000000004442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4442:	48b9                	li	a7,14
 ecall
    4444:	00000073          	ecall
 ret
    4448:	8082                	ret

000000000000444a <getprocs>:
.global getprocs
getprocs:
 li a7, SYS_getprocs
    444a:	48d9                	li	a7,22
 ecall
    444c:	00000073          	ecall
 ret
    4450:	8082                	ret

0000000000004452 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4452:	1101                	addi	sp,sp,-32
    4454:	ec06                	sd	ra,24(sp)
    4456:	e822                	sd	s0,16(sp)
    4458:	1000                	addi	s0,sp,32
    445a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    445e:	4605                	li	a2,1
    4460:	fef40593          	addi	a1,s0,-17
    4464:	00000097          	auipc	ra,0x0
    4468:	f66080e7          	jalr	-154(ra) # 43ca <write>
}
    446c:	60e2                	ld	ra,24(sp)
    446e:	6442                	ld	s0,16(sp)
    4470:	6105                	addi	sp,sp,32
    4472:	8082                	ret

0000000000004474 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4474:	7139                	addi	sp,sp,-64
    4476:	fc06                	sd	ra,56(sp)
    4478:	f822                	sd	s0,48(sp)
    447a:	f426                	sd	s1,40(sp)
    447c:	f04a                	sd	s2,32(sp)
    447e:	ec4e                	sd	s3,24(sp)
    4480:	0080                	addi	s0,sp,64
    4482:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4484:	c299                	beqz	a3,448a <printint+0x16>
    4486:	0805c863          	bltz	a1,4516 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    448a:	2581                	sext.w	a1,a1
  neg = 0;
    448c:	4881                	li	a7,0
    448e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4492:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4494:	2601                	sext.w	a2,a2
    4496:	00002517          	auipc	a0,0x2
    449a:	4ca50513          	addi	a0,a0,1226 # 6960 <digits>
    449e:	883a                	mv	a6,a4
    44a0:	2705                	addiw	a4,a4,1
    44a2:	02c5f7bb          	remuw	a5,a1,a2
    44a6:	1782                	slli	a5,a5,0x20
    44a8:	9381                	srli	a5,a5,0x20
    44aa:	97aa                	add	a5,a5,a0
    44ac:	0007c783          	lbu	a5,0(a5)
    44b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    44b4:	0005879b          	sext.w	a5,a1
    44b8:	02c5d5bb          	divuw	a1,a1,a2
    44bc:	0685                	addi	a3,a3,1
    44be:	fec7f0e3          	bgeu	a5,a2,449e <printint+0x2a>
  if(neg)
    44c2:	00088b63          	beqz	a7,44d8 <printint+0x64>
    buf[i++] = '-';
    44c6:	fd040793          	addi	a5,s0,-48
    44ca:	973e                	add	a4,a4,a5
    44cc:	02d00793          	li	a5,45
    44d0:	fef70823          	sb	a5,-16(a4)
    44d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    44d8:	02e05863          	blez	a4,4508 <printint+0x94>
    44dc:	fc040793          	addi	a5,s0,-64
    44e0:	00e78933          	add	s2,a5,a4
    44e4:	fff78993          	addi	s3,a5,-1
    44e8:	99ba                	add	s3,s3,a4
    44ea:	377d                	addiw	a4,a4,-1
    44ec:	1702                	slli	a4,a4,0x20
    44ee:	9301                	srli	a4,a4,0x20
    44f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    44f4:	fff94583          	lbu	a1,-1(s2)
    44f8:	8526                	mv	a0,s1
    44fa:	00000097          	auipc	ra,0x0
    44fe:	f58080e7          	jalr	-168(ra) # 4452 <putc>
  while(--i >= 0)
    4502:	197d                	addi	s2,s2,-1
    4504:	ff3918e3          	bne	s2,s3,44f4 <printint+0x80>
}
    4508:	70e2                	ld	ra,56(sp)
    450a:	7442                	ld	s0,48(sp)
    450c:	74a2                	ld	s1,40(sp)
    450e:	7902                	ld	s2,32(sp)
    4510:	69e2                	ld	s3,24(sp)
    4512:	6121                	addi	sp,sp,64
    4514:	8082                	ret
    x = -xx;
    4516:	40b005bb          	negw	a1,a1
    neg = 1;
    451a:	4885                	li	a7,1
    x = -xx;
    451c:	bf8d                	j	448e <printint+0x1a>

000000000000451e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    451e:	7119                	addi	sp,sp,-128
    4520:	fc86                	sd	ra,120(sp)
    4522:	f8a2                	sd	s0,112(sp)
    4524:	f4a6                	sd	s1,104(sp)
    4526:	f0ca                	sd	s2,96(sp)
    4528:	ecce                	sd	s3,88(sp)
    452a:	e8d2                	sd	s4,80(sp)
    452c:	e4d6                	sd	s5,72(sp)
    452e:	e0da                	sd	s6,64(sp)
    4530:	fc5e                	sd	s7,56(sp)
    4532:	f862                	sd	s8,48(sp)
    4534:	f466                	sd	s9,40(sp)
    4536:	f06a                	sd	s10,32(sp)
    4538:	ec6e                	sd	s11,24(sp)
    453a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    453c:	0005c903          	lbu	s2,0(a1)
    4540:	18090f63          	beqz	s2,46de <vprintf+0x1c0>
    4544:	8aaa                	mv	s5,a0
    4546:	8b32                	mv	s6,a2
    4548:	00158493          	addi	s1,a1,1
  state = 0;
    454c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    454e:	02500a13          	li	s4,37
      if(c == 'd'){
    4552:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    4556:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    455a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    455e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4562:	00002b97          	auipc	s7,0x2
    4566:	3feb8b93          	addi	s7,s7,1022 # 6960 <digits>
    456a:	a839                	j	4588 <vprintf+0x6a>
        putc(fd, c);
    456c:	85ca                	mv	a1,s2
    456e:	8556                	mv	a0,s5
    4570:	00000097          	auipc	ra,0x0
    4574:	ee2080e7          	jalr	-286(ra) # 4452 <putc>
    4578:	a019                	j	457e <vprintf+0x60>
    } else if(state == '%'){
    457a:	01498f63          	beq	s3,s4,4598 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    457e:	0485                	addi	s1,s1,1
    4580:	fff4c903          	lbu	s2,-1(s1)
    4584:	14090d63          	beqz	s2,46de <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    4588:	0009079b          	sext.w	a5,s2
    if(state == 0){
    458c:	fe0997e3          	bnez	s3,457a <vprintf+0x5c>
      if(c == '%'){
    4590:	fd479ee3          	bne	a5,s4,456c <vprintf+0x4e>
        state = '%';
    4594:	89be                	mv	s3,a5
    4596:	b7e5                	j	457e <vprintf+0x60>
      if(c == 'd'){
    4598:	05878063          	beq	a5,s8,45d8 <vprintf+0xba>
      } else if(c == 'l') {
    459c:	05978c63          	beq	a5,s9,45f4 <vprintf+0xd6>
      } else if(c == 'x') {
    45a0:	07a78863          	beq	a5,s10,4610 <vprintf+0xf2>
      } else if(c == 'p') {
    45a4:	09b78463          	beq	a5,s11,462c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    45a8:	07300713          	li	a4,115
    45ac:	0ce78663          	beq	a5,a4,4678 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    45b0:	06300713          	li	a4,99
    45b4:	0ee78e63          	beq	a5,a4,46b0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    45b8:	11478863          	beq	a5,s4,46c8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    45bc:	85d2                	mv	a1,s4
    45be:	8556                	mv	a0,s5
    45c0:	00000097          	auipc	ra,0x0
    45c4:	e92080e7          	jalr	-366(ra) # 4452 <putc>
        putc(fd, c);
    45c8:	85ca                	mv	a1,s2
    45ca:	8556                	mv	a0,s5
    45cc:	00000097          	auipc	ra,0x0
    45d0:	e86080e7          	jalr	-378(ra) # 4452 <putc>
      }
      state = 0;
    45d4:	4981                	li	s3,0
    45d6:	b765                	j	457e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    45d8:	008b0913          	addi	s2,s6,8
    45dc:	4685                	li	a3,1
    45de:	4629                	li	a2,10
    45e0:	000b2583          	lw	a1,0(s6)
    45e4:	8556                	mv	a0,s5
    45e6:	00000097          	auipc	ra,0x0
    45ea:	e8e080e7          	jalr	-370(ra) # 4474 <printint>
    45ee:	8b4a                	mv	s6,s2
      state = 0;
    45f0:	4981                	li	s3,0
    45f2:	b771                	j	457e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    45f4:	008b0913          	addi	s2,s6,8
    45f8:	4681                	li	a3,0
    45fa:	4629                	li	a2,10
    45fc:	000b2583          	lw	a1,0(s6)
    4600:	8556                	mv	a0,s5
    4602:	00000097          	auipc	ra,0x0
    4606:	e72080e7          	jalr	-398(ra) # 4474 <printint>
    460a:	8b4a                	mv	s6,s2
      state = 0;
    460c:	4981                	li	s3,0
    460e:	bf85                	j	457e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    4610:	008b0913          	addi	s2,s6,8
    4614:	4681                	li	a3,0
    4616:	4641                	li	a2,16
    4618:	000b2583          	lw	a1,0(s6)
    461c:	8556                	mv	a0,s5
    461e:	00000097          	auipc	ra,0x0
    4622:	e56080e7          	jalr	-426(ra) # 4474 <printint>
    4626:	8b4a                	mv	s6,s2
      state = 0;
    4628:	4981                	li	s3,0
    462a:	bf91                	j	457e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    462c:	008b0793          	addi	a5,s6,8
    4630:	f8f43423          	sd	a5,-120(s0)
    4634:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    4638:	03000593          	li	a1,48
    463c:	8556                	mv	a0,s5
    463e:	00000097          	auipc	ra,0x0
    4642:	e14080e7          	jalr	-492(ra) # 4452 <putc>
  putc(fd, 'x');
    4646:	85ea                	mv	a1,s10
    4648:	8556                	mv	a0,s5
    464a:	00000097          	auipc	ra,0x0
    464e:	e08080e7          	jalr	-504(ra) # 4452 <putc>
    4652:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4654:	03c9d793          	srli	a5,s3,0x3c
    4658:	97de                	add	a5,a5,s7
    465a:	0007c583          	lbu	a1,0(a5)
    465e:	8556                	mv	a0,s5
    4660:	00000097          	auipc	ra,0x0
    4664:	df2080e7          	jalr	-526(ra) # 4452 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4668:	0992                	slli	s3,s3,0x4
    466a:	397d                	addiw	s2,s2,-1
    466c:	fe0914e3          	bnez	s2,4654 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    4670:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    4674:	4981                	li	s3,0
    4676:	b721                	j	457e <vprintf+0x60>
        s = va_arg(ap, char*);
    4678:	008b0993          	addi	s3,s6,8
    467c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    4680:	02090163          	beqz	s2,46a2 <vprintf+0x184>
        while(*s != 0){
    4684:	00094583          	lbu	a1,0(s2)
    4688:	c9a1                	beqz	a1,46d8 <vprintf+0x1ba>
          putc(fd, *s);
    468a:	8556                	mv	a0,s5
    468c:	00000097          	auipc	ra,0x0
    4690:	dc6080e7          	jalr	-570(ra) # 4452 <putc>
          s++;
    4694:	0905                	addi	s2,s2,1
        while(*s != 0){
    4696:	00094583          	lbu	a1,0(s2)
    469a:	f9e5                	bnez	a1,468a <vprintf+0x16c>
        s = va_arg(ap, char*);
    469c:	8b4e                	mv	s6,s3
      state = 0;
    469e:	4981                	li	s3,0
    46a0:	bdf9                	j	457e <vprintf+0x60>
          s = "(null)";
    46a2:	00002917          	auipc	s2,0x2
    46a6:	2b690913          	addi	s2,s2,694 # 6958 <malloc+0x2170>
        while(*s != 0){
    46aa:	02800593          	li	a1,40
    46ae:	bff1                	j	468a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    46b0:	008b0913          	addi	s2,s6,8
    46b4:	000b4583          	lbu	a1,0(s6)
    46b8:	8556                	mv	a0,s5
    46ba:	00000097          	auipc	ra,0x0
    46be:	d98080e7          	jalr	-616(ra) # 4452 <putc>
    46c2:	8b4a                	mv	s6,s2
      state = 0;
    46c4:	4981                	li	s3,0
    46c6:	bd65                	j	457e <vprintf+0x60>
        putc(fd, c);
    46c8:	85d2                	mv	a1,s4
    46ca:	8556                	mv	a0,s5
    46cc:	00000097          	auipc	ra,0x0
    46d0:	d86080e7          	jalr	-634(ra) # 4452 <putc>
      state = 0;
    46d4:	4981                	li	s3,0
    46d6:	b565                	j	457e <vprintf+0x60>
        s = va_arg(ap, char*);
    46d8:	8b4e                	mv	s6,s3
      state = 0;
    46da:	4981                	li	s3,0
    46dc:	b54d                	j	457e <vprintf+0x60>
    }
  }
}
    46de:	70e6                	ld	ra,120(sp)
    46e0:	7446                	ld	s0,112(sp)
    46e2:	74a6                	ld	s1,104(sp)
    46e4:	7906                	ld	s2,96(sp)
    46e6:	69e6                	ld	s3,88(sp)
    46e8:	6a46                	ld	s4,80(sp)
    46ea:	6aa6                	ld	s5,72(sp)
    46ec:	6b06                	ld	s6,64(sp)
    46ee:	7be2                	ld	s7,56(sp)
    46f0:	7c42                	ld	s8,48(sp)
    46f2:	7ca2                	ld	s9,40(sp)
    46f4:	7d02                	ld	s10,32(sp)
    46f6:	6de2                	ld	s11,24(sp)
    46f8:	6109                	addi	sp,sp,128
    46fa:	8082                	ret

00000000000046fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    46fc:	715d                	addi	sp,sp,-80
    46fe:	ec06                	sd	ra,24(sp)
    4700:	e822                	sd	s0,16(sp)
    4702:	1000                	addi	s0,sp,32
    4704:	e010                	sd	a2,0(s0)
    4706:	e414                	sd	a3,8(s0)
    4708:	e818                	sd	a4,16(s0)
    470a:	ec1c                	sd	a5,24(s0)
    470c:	03043023          	sd	a6,32(s0)
    4710:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4714:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4718:	8622                	mv	a2,s0
    471a:	00000097          	auipc	ra,0x0
    471e:	e04080e7          	jalr	-508(ra) # 451e <vprintf>
}
    4722:	60e2                	ld	ra,24(sp)
    4724:	6442                	ld	s0,16(sp)
    4726:	6161                	addi	sp,sp,80
    4728:	8082                	ret

000000000000472a <printf>:

void
printf(const char *fmt, ...)
{
    472a:	711d                	addi	sp,sp,-96
    472c:	ec06                	sd	ra,24(sp)
    472e:	e822                	sd	s0,16(sp)
    4730:	1000                	addi	s0,sp,32
    4732:	e40c                	sd	a1,8(s0)
    4734:	e810                	sd	a2,16(s0)
    4736:	ec14                	sd	a3,24(s0)
    4738:	f018                	sd	a4,32(s0)
    473a:	f41c                	sd	a5,40(s0)
    473c:	03043823          	sd	a6,48(s0)
    4740:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4744:	00840613          	addi	a2,s0,8
    4748:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    474c:	85aa                	mv	a1,a0
    474e:	4505                	li	a0,1
    4750:	00000097          	auipc	ra,0x0
    4754:	dce080e7          	jalr	-562(ra) # 451e <vprintf>
}
    4758:	60e2                	ld	ra,24(sp)
    475a:	6442                	ld	s0,16(sp)
    475c:	6125                	addi	sp,sp,96
    475e:	8082                	ret

0000000000004760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4760:	1141                	addi	sp,sp,-16
    4762:	e422                	sd	s0,8(sp)
    4764:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4766:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    476a:	00002797          	auipc	a5,0x2
    476e:	2267b783          	ld	a5,550(a5) # 6990 <freep>
    4772:	a805                	j	47a2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4774:	4618                	lw	a4,8(a2)
    4776:	9db9                	addw	a1,a1,a4
    4778:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    477c:	6398                	ld	a4,0(a5)
    477e:	6318                	ld	a4,0(a4)
    4780:	fee53823          	sd	a4,-16(a0)
    4784:	a091                	j	47c8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4786:	ff852703          	lw	a4,-8(a0)
    478a:	9e39                	addw	a2,a2,a4
    478c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    478e:	ff053703          	ld	a4,-16(a0)
    4792:	e398                	sd	a4,0(a5)
    4794:	a099                	j	47da <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4796:	6398                	ld	a4,0(a5)
    4798:	00e7e463          	bltu	a5,a4,47a0 <free+0x40>
    479c:	00e6ea63          	bltu	a3,a4,47b0 <free+0x50>
{
    47a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    47a2:	fed7fae3          	bgeu	a5,a3,4796 <free+0x36>
    47a6:	6398                	ld	a4,0(a5)
    47a8:	00e6e463          	bltu	a3,a4,47b0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    47ac:	fee7eae3          	bltu	a5,a4,47a0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    47b0:	ff852583          	lw	a1,-8(a0)
    47b4:	6390                	ld	a2,0(a5)
    47b6:	02059713          	slli	a4,a1,0x20
    47ba:	9301                	srli	a4,a4,0x20
    47bc:	0712                	slli	a4,a4,0x4
    47be:	9736                	add	a4,a4,a3
    47c0:	fae60ae3          	beq	a2,a4,4774 <free+0x14>
    bp->s.ptr = p->s.ptr;
    47c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    47c8:	4790                	lw	a2,8(a5)
    47ca:	02061713          	slli	a4,a2,0x20
    47ce:	9301                	srli	a4,a4,0x20
    47d0:	0712                	slli	a4,a4,0x4
    47d2:	973e                	add	a4,a4,a5
    47d4:	fae689e3          	beq	a3,a4,4786 <free+0x26>
  } else
    p->s.ptr = bp;
    47d8:	e394                	sd	a3,0(a5)
  freep = p;
    47da:	00002717          	auipc	a4,0x2
    47de:	1af73b23          	sd	a5,438(a4) # 6990 <freep>
}
    47e2:	6422                	ld	s0,8(sp)
    47e4:	0141                	addi	sp,sp,16
    47e6:	8082                	ret

00000000000047e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    47e8:	7139                	addi	sp,sp,-64
    47ea:	fc06                	sd	ra,56(sp)
    47ec:	f822                	sd	s0,48(sp)
    47ee:	f426                	sd	s1,40(sp)
    47f0:	f04a                	sd	s2,32(sp)
    47f2:	ec4e                	sd	s3,24(sp)
    47f4:	e852                	sd	s4,16(sp)
    47f6:	e456                	sd	s5,8(sp)
    47f8:	e05a                	sd	s6,0(sp)
    47fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    47fc:	02051493          	slli	s1,a0,0x20
    4800:	9081                	srli	s1,s1,0x20
    4802:	04bd                	addi	s1,s1,15
    4804:	8091                	srli	s1,s1,0x4
    4806:	0014899b          	addiw	s3,s1,1
    480a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    480c:	00002517          	auipc	a0,0x2
    4810:	18453503          	ld	a0,388(a0) # 6990 <freep>
    4814:	c515                	beqz	a0,4840 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4816:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4818:	4798                	lw	a4,8(a5)
    481a:	02977f63          	bgeu	a4,s1,4858 <malloc+0x70>
    481e:	8a4e                	mv	s4,s3
    4820:	0009871b          	sext.w	a4,s3
    4824:	6685                	lui	a3,0x1
    4826:	00d77363          	bgeu	a4,a3,482c <malloc+0x44>
    482a:	6a05                	lui	s4,0x1
    482c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4830:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4834:	00002917          	auipc	s2,0x2
    4838:	15c90913          	addi	s2,s2,348 # 6990 <freep>
  if(p == (char*)-1)
    483c:	5afd                	li	s5,-1
    483e:	a88d                	j	48b0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    4840:	00008797          	auipc	a5,0x8
    4844:	96878793          	addi	a5,a5,-1688 # c1a8 <base>
    4848:	00002717          	auipc	a4,0x2
    484c:	14f73423          	sd	a5,328(a4) # 6990 <freep>
    4850:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4852:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4856:	b7e1                	j	481e <malloc+0x36>
      if(p->s.size == nunits)
    4858:	02e48b63          	beq	s1,a4,488e <malloc+0xa6>
        p->s.size -= nunits;
    485c:	4137073b          	subw	a4,a4,s3
    4860:	c798                	sw	a4,8(a5)
        p += p->s.size;
    4862:	1702                	slli	a4,a4,0x20
    4864:	9301                	srli	a4,a4,0x20
    4866:	0712                	slli	a4,a4,0x4
    4868:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    486a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    486e:	00002717          	auipc	a4,0x2
    4872:	12a73123          	sd	a0,290(a4) # 6990 <freep>
      return (void*)(p + 1);
    4876:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    487a:	70e2                	ld	ra,56(sp)
    487c:	7442                	ld	s0,48(sp)
    487e:	74a2                	ld	s1,40(sp)
    4880:	7902                	ld	s2,32(sp)
    4882:	69e2                	ld	s3,24(sp)
    4884:	6a42                	ld	s4,16(sp)
    4886:	6aa2                	ld	s5,8(sp)
    4888:	6b02                	ld	s6,0(sp)
    488a:	6121                	addi	sp,sp,64
    488c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    488e:	6398                	ld	a4,0(a5)
    4890:	e118                	sd	a4,0(a0)
    4892:	bff1                	j	486e <malloc+0x86>
  hp->s.size = nu;
    4894:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4898:	0541                	addi	a0,a0,16
    489a:	00000097          	auipc	ra,0x0
    489e:	ec6080e7          	jalr	-314(ra) # 4760 <free>
  return freep;
    48a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    48a6:	d971                	beqz	a0,487a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    48a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    48aa:	4798                	lw	a4,8(a5)
    48ac:	fa9776e3          	bgeu	a4,s1,4858 <malloc+0x70>
    if(p == freep)
    48b0:	00093703          	ld	a4,0(s2)
    48b4:	853e                	mv	a0,a5
    48b6:	fef719e3          	bne	a4,a5,48a8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    48ba:	8552                	mv	a0,s4
    48bc:	00000097          	auipc	ra,0x0
    48c0:	b76080e7          	jalr	-1162(ra) # 4432 <sbrk>
  if(p == (char*)-1)
    48c4:	fd5518e3          	bne	a0,s5,4894 <malloc+0xac>
        return 0;
    48c8:	4501                	li	a0,0
    48ca:	bf45                	j	487a <malloc+0x92>
