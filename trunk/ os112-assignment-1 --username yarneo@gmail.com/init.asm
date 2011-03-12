
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  11:	00 
  12:	c7 04 24 2e 09 00 00 	movl   $0x92e,(%esp)
  19:	e8 82 04 00 00       	call   4a0 <open>
  1e:	85 c0                	test   %eax,%eax
  20:	0f 88 b7 00 00 00    	js     dd <main+0xdd>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2d:	e8 a6 04 00 00       	call   4d8 <dup>
  dup(0);  // stderr
  32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  39:	e8 9a 04 00 00       	call   4d8 <dup>
  3e:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  40:	c7 44 24 04 36 09 00 	movl   $0x936,0x4(%esp)
  47:	00 
  48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4f:	e8 5c 05 00 00       	call   5b0 <printf>
    pid = fork();
  54:	e8 f7 03 00 00       	call   450 <fork>
    if(pid < 0){
  59:	83 f8 00             	cmp    $0x0,%eax
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
  5c:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5e:	7c 30                	jl     90 <main+0x90>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  60:	74 4e                	je     b0 <main+0xb0>
  62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  68:	e8 f3 03 00 00       	call   460 <wait>
  6d:	85 c0                	test   %eax,%eax
  6f:	90                   	nop
  70:	78 ce                	js     40 <main+0x40>
  72:	39 c3                	cmp    %eax,%ebx
  74:	74 ca                	je     40 <main+0x40>
      printf(1, "zombie!\n");
  76:	c7 44 24 04 75 09 00 	movl   $0x975,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 26 05 00 00       	call   5b0 <printf>
  8a:	eb d6                	jmp    62 <main+0x62>
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 49 09 00 	movl   $0x949,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 0c 05 00 00       	call   5b0 <printf>
      exit();
  a4:	e8 af 03 00 00       	call   458 <exit>
  a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(pid == 0){
      exec("sh", argv);
  b0:	c7 44 24 04 98 09 00 	movl   $0x998,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 5c 09 00 00 	movl   $0x95c,(%esp)
  bf:	e8 d4 03 00 00       	call   498 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 5f 09 00 	movl   $0x95f,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 d8 04 00 00       	call   5b0 <printf>
      exit();
  d8:	e8 7b 03 00 00       	call   458 <exit>
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
  dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  e4:	00 
  e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  ec:	00 
  ed:	c7 04 24 2e 09 00 00 	movl   $0x92e,(%esp)
  f4:	e8 af 03 00 00       	call   4a8 <mknod>
    open("console", O_RDWR);
  f9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 100:	00 
 101:	c7 04 24 2e 09 00 00 	movl   $0x92e,(%esp)
 108:	e8 93 03 00 00       	call   4a0 <open>
 10d:	e9 14 ff ff ff       	jmp    26 <main+0x26>
 112:	90                   	nop
 113:	90                   	nop
 114:	90                   	nop
 115:	90                   	nop
 116:	90                   	nop
 117:	90                   	nop
 118:	90                   	nop
 119:	90                   	nop
 11a:	90                   	nop
 11b:	90                   	nop
 11c:	90                   	nop
 11d:	90                   	nop
 11e:	90                   	nop
 11f:	90                   	nop

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 120:	55                   	push   %ebp
 121:	31 d2                	xor    %edx,%edx
 123:	89 e5                	mov    %esp,%ebp
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	53                   	push   %ebx
 129:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 130:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 134:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 137:	83 c2 01             	add    $0x1,%edx
 13a:	84 c9                	test   %cl,%cl
 13c:	75 f2                	jne    130 <strcpy+0x10>
    ;
  return os;
}
 13e:	5b                   	pop    %ebx
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    
 141:	eb 0d                	jmp    150 <strcmp>
 143:	90                   	nop
 144:	90                   	nop
 145:	90                   	nop
 146:	90                   	nop
 147:	90                   	nop
 148:	90                   	nop
 149:	90                   	nop
 14a:	90                   	nop
 14b:	90                   	nop
 14c:	90                   	nop
 14d:	90                   	nop
 14e:	90                   	nop
 14f:	90                   	nop

00000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	8b 4d 08             	mov    0x8(%ebp),%ecx
 157:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 15a:	0f b6 01             	movzbl (%ecx),%eax
 15d:	84 c0                	test   %al,%al
 15f:	75 14                	jne    175 <strcmp+0x25>
 161:	eb 25                	jmp    188 <strcmp+0x38>
 163:	90                   	nop
 164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 168:	83 c1 01             	add    $0x1,%ecx
 16b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16e:	0f b6 01             	movzbl (%ecx),%eax
 171:	84 c0                	test   %al,%al
 173:	74 13                	je     188 <strcmp+0x38>
 175:	0f b6 1a             	movzbl (%edx),%ebx
 178:	38 d8                	cmp    %bl,%al
 17a:	74 ec                	je     168 <strcmp+0x18>
 17c:	0f b6 db             	movzbl %bl,%ebx
 17f:	0f b6 c0             	movzbl %al,%eax
 182:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 184:	5b                   	pop    %ebx
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 188:	0f b6 1a             	movzbl (%edx),%ebx
 18b:	31 c0                	xor    %eax,%eax
 18d:	0f b6 db             	movzbl %bl,%ebx
 190:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 192:	5b                   	pop    %ebx
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    
 195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <strlen>:

uint
strlen(char *s)
{
 1a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 1a1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 1a5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1aa:	80 39 00             	cmpb   $0x0,(%ecx)
 1ad:	74 0c                	je     1bb <strlen+0x1b>
 1af:	90                   	nop
 1b0:	83 c2 01             	add    $0x1,%edx
 1b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1b7:	89 d0                	mov    %edx,%eax
 1b9:	75 f5                	jne    1b0 <strlen+0x10>
    ;
  return n;
}
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
 1c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld    
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	89 d0                	mov    %edx,%eax
 1d4:	5f                   	pop    %edi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	75 11                	jne    202 <strchr+0x22>
 1f1:	eb 15                	jmp    208 <strchr+0x28>
 1f3:	90                   	nop
 1f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f8:	83 c0 01             	add    $0x1,%eax
 1fb:	0f b6 10             	movzbl (%eax),%edx
 1fe:	84 d2                	test   %dl,%dl
 200:	74 06                	je     208 <strchr+0x28>
    if(*s == c)
 202:	38 ca                	cmp    %cl,%dl
 204:	75 f2                	jne    1f8 <strchr+0x18>
      return (char*) s;
  return 0;
}
 206:	5d                   	pop    %ebp
 207:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 208:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 20a:	5d                   	pop    %ebp
 20b:	90                   	nop
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 210:	c3                   	ret    
 211:	eb 0d                	jmp    220 <atoi>
 213:	90                   	nop
 214:	90                   	nop
 215:	90                   	nop
 216:	90                   	nop
 217:	90                   	nop
 218:	90                   	nop
 219:	90                   	nop
 21a:	90                   	nop
 21b:	90                   	nop
 21c:	90                   	nop
 21d:	90                   	nop
 21e:	90                   	nop
 21f:	90                   	nop

00000220 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 220:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 221:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 223:	89 e5                	mov    %esp,%ebp
 225:	8b 4d 08             	mov    0x8(%ebp),%ecx
 228:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 229:	0f b6 11             	movzbl (%ecx),%edx
 22c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 22f:	80 fb 09             	cmp    $0x9,%bl
 232:	77 1c                	ja     250 <atoi+0x30>
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 238:	0f be d2             	movsbl %dl,%edx
 23b:	83 c1 01             	add    $0x1,%ecx
 23e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 241:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 245:	0f b6 11             	movzbl (%ecx),%edx
 248:	8d 5a d0             	lea    -0x30(%edx),%ebx
 24b:	80 fb 09             	cmp    $0x9,%bl
 24e:	76 e8                	jbe    238 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 250:	5b                   	pop    %ebx
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	53                   	push   %ebx
 268:	8b 5d 10             	mov    0x10(%ebp),%ebx
 26b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 26e:	85 db                	test   %ebx,%ebx
 270:	7e 14                	jle    286 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 272:	31 d2                	xor    %edx,%edx
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 278:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 27c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 27f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 282:	39 da                	cmp    %ebx,%edx
 284:	75 f2                	jne    278 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 286:	5b                   	pop    %ebx
 287:	5e                   	pop    %esi
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000290 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 4d 08             	mov    0x8(%ebp),%ecx
 296:	57                   	push   %edi
 297:	56                   	push   %esi
 298:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 299:	80 39 00             	cmpb   $0x0,(%ecx)
 29c:	74 37                	je     2d5 <reverse+0x45>
 29e:	31 d2                	xor    %edx,%edx
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2a7:	75 f7                	jne    2a0 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2a9:	8d 7a ff             	lea    -0x1(%edx),%edi
 2ac:	85 ff                	test   %edi,%edi
 2ae:	7e 25                	jle    2d5 <reverse+0x45>
 2b0:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 2b3:	31 c0                	xor    %eax,%eax
 2b5:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 2b8:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2bc:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 2bf:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 2c3:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 2c6:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2c8:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 2cb:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2ce:	83 ea 01             	sub    $0x1,%edx
 2d1:	39 f8                	cmp    %edi,%eax
 2d3:	7c e3                	jl     2b8 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 2d5:	5b                   	pop    %ebx
 2d6:	5e                   	pop    %esi
 2d7:	5f                   	pop    %edi
 2d8:	5d                   	pop    %ebp
 2d9:	c3                   	ret    
 2da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002e0 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 2e4:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 2e9:	56                   	push   %esi
 2ea:	53                   	push   %ebx
 2eb:	31 db                	xor    %ebx,%ebx
 2ed:	83 ec 04             	sub    $0x4,%esp
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	8b 75 0c             	mov    0xc(%ebp),%esi
 2f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2f9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 2fc:	c1 f8 1f             	sar    $0x1f,%eax
 2ff:	31 c1                	xor    %eax,%ecx
 301:	29 c1                	sub    %eax,%ecx
 303:	90                   	nop
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 308:	89 c8                	mov    %ecx,%eax
 30a:	f7 ef                	imul   %edi
 30c:	89 c8                	mov    %ecx,%eax
 30e:	c1 f8 1f             	sar    $0x1f,%eax
 311:	c1 fa 02             	sar    $0x2,%edx
 314:	29 c2                	sub    %eax,%edx
 316:	8d 04 92             	lea    (%edx,%edx,4),%eax
 319:	01 c0                	add    %eax,%eax
 31b:	29 c1                	sub    %eax,%ecx
 31d:	83 c1 30             	add    $0x30,%ecx
 320:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 323:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 326:	85 d2                	test   %edx,%edx
 328:	89 d1                	mov    %edx,%ecx
 32a:	7f dc                	jg     308 <itoa+0x28>
     if (sign < 0)
 32c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 32f:	85 c0                	test   %eax,%eax
 331:	79 07                	jns    33a <itoa+0x5a>
         s[i++] = '-';
 333:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 337:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 33a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 33e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 341:	83 c4 04             	add    $0x4,%esp
 344:	5b                   	pop    %ebx
 345:	5e                   	pop    %esi
 346:	5f                   	pop    %edi
 347:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 348:	e9 43 ff ff ff       	jmp    290 <reverse>
 34d:	8d 76 00             	lea    0x0(%esi),%esi

00000350 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 350:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 351:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 353:	89 e5                	mov    %esp,%ebp
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	57                   	push   %edi
 359:	8b 7d 0c             	mov    0xc(%ebp),%edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 35e:	31 db                	xor    %ebx,%ebx
 360:	80 38 00             	cmpb   $0x0,(%eax)
 363:	74 0e                	je     373 <strcat+0x23>
 365:	8d 76 00             	lea    0x0(%esi),%esi
 368:	83 c2 01             	add    $0x1,%edx
 36b:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 36f:	75 f7                	jne    368 <strcat+0x18>
 371:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 373:	0f b6 0f             	movzbl (%edi),%ecx
 376:	84 c9                	test   %cl,%cl
 378:	74 18                	je     392 <strcat+0x42>
 37a:	8d 34 10             	lea    (%eax,%edx,1),%esi
 37d:	31 db                	xor    %ebx,%ebx
 37f:	90                   	nop
 380:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 383:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 385:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 389:	83 c6 01             	add    $0x1,%esi
 38c:	84 c9                	test   %cl,%cl
 38e:	75 f0                	jne    380 <strcat+0x30>
 390:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 392:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 396:	5b                   	pop    %ebx
 397:	5e                   	pop    %esi
 398:	5f                   	pop    %edi
 399:	5d                   	pop    %ebp
 39a:	c3                   	ret    
 39b:	90                   	nop
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 3a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 3ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 3af:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3bb:	00 
 3bc:	89 04 24             	mov    %eax,(%esp)
 3bf:	e8 dc 00 00 00       	call   4a0 <open>
  if(fd < 0)
 3c4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 3c8:	78 19                	js     3e3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 1c 24             	mov    %ebx,(%esp)
 3d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d4:	e8 df 00 00 00       	call   4b8 <fstat>
  close(fd);
 3d9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 3dc:	89 c6                	mov    %eax,%esi
  close(fd);
 3de:	e8 a5 00 00 00       	call   488 <close>
  return r;
}
 3e3:	89 f0                	mov    %esi,%eax
 3e5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 3e8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 3eb:	89 ec                	mov    %ebp,%esp
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    
 3ef:	90                   	nop

000003f0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	31 f6                	xor    %esi,%esi
 3f7:	53                   	push   %ebx
 3f8:	83 ec 2c             	sub    $0x2c,%esp
 3fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fe:	eb 06                	jmp    406 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 400:	3c 0a                	cmp    $0xa,%al
 402:	74 39                	je     43d <gets+0x4d>
 404:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 406:	8d 5e 01             	lea    0x1(%esi),%ebx
 409:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 40c:	7d 31                	jge    43f <gets+0x4f>
    cc = read(0, &c, 1);
 40e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 411:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 418:	00 
 419:	89 44 24 04          	mov    %eax,0x4(%esp)
 41d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 424:	e8 4f 00 00 00       	call   478 <read>
    if(cc < 1)
 429:	85 c0                	test   %eax,%eax
 42b:	7e 12                	jle    43f <gets+0x4f>
      break;
    buf[i++] = c;
 42d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 431:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 435:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 439:	3c 0d                	cmp    $0xd,%al
 43b:	75 c3                	jne    400 <gets+0x10>
 43d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 43f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 443:	89 f8                	mov    %edi,%eax
 445:	83 c4 2c             	add    $0x2c,%esp
 448:	5b                   	pop    %ebx
 449:	5e                   	pop    %esi
 44a:	5f                   	pop    %edi
 44b:	5d                   	pop    %ebp
 44c:	c3                   	ret    
 44d:	90                   	nop
 44e:	90                   	nop
 44f:	90                   	nop

00000450 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 450:	b8 01 00 00 00       	mov    $0x1,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <exit>:
SYSCALL(exit)
 458:	b8 02 00 00 00       	mov    $0x2,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <wait>:
SYSCALL(wait)
 460:	b8 03 00 00 00       	mov    $0x3,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <wait2>:
SYSCALL(wait2)
 468:	b8 16 00 00 00       	mov    $0x16,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <pipe>:
SYSCALL(pipe)
 470:	b8 04 00 00 00       	mov    $0x4,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <read>:
SYSCALL(read)
 478:	b8 06 00 00 00       	mov    $0x6,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <write>:
SYSCALL(write)
 480:	b8 05 00 00 00       	mov    $0x5,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <close>:
SYSCALL(close)
 488:	b8 07 00 00 00       	mov    $0x7,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <kill>:
SYSCALL(kill)
 490:	b8 08 00 00 00       	mov    $0x8,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <exec>:
SYSCALL(exec)
 498:	b8 09 00 00 00       	mov    $0x9,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <open>:
SYSCALL(open)
 4a0:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <mknod>:
SYSCALL(mknod)
 4a8:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <unlink>:
SYSCALL(unlink)
 4b0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <fstat>:
SYSCALL(fstat)
 4b8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <link>:
SYSCALL(link)
 4c0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <mkdir>:
SYSCALL(mkdir)
 4c8:	b8 0f 00 00 00       	mov    $0xf,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <chdir>:
SYSCALL(chdir)
 4d0:	b8 10 00 00 00       	mov    $0x10,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <dup>:
SYSCALL(dup)
 4d8:	b8 11 00 00 00       	mov    $0x11,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <getpid>:
SYSCALL(getpid)
 4e0:	b8 12 00 00 00       	mov    $0x12,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <sbrk>:
SYSCALL(sbrk)
 4e8:	b8 13 00 00 00       	mov    $0x13,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <sleep>:
SYSCALL(sleep)
 4f0:	b8 14 00 00 00       	mov    $0x14,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <uptime>:
SYSCALL(uptime)
 4f8:	b8 15 00 00 00       	mov    $0x15,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <nice>:
SYSCALL(nice)
 500:	b8 17 00 00 00       	mov    $0x17,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    
 508:	90                   	nop
 509:	90                   	nop
 50a:	90                   	nop
 50b:	90                   	nop
 50c:	90                   	nop
 50d:	90                   	nop
 50e:	90                   	nop
 50f:	90                   	nop

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	89 cf                	mov    %ecx,%edi
 516:	56                   	push   %esi
 517:	89 c6                	mov    %eax,%esi
 519:	53                   	push   %ebx
 51a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 520:	85 c9                	test   %ecx,%ecx
 522:	74 04                	je     528 <printint+0x18>
 524:	85 d2                	test   %edx,%edx
 526:	78 70                	js     598 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 528:	89 d0                	mov    %edx,%eax
 52a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 531:	31 c9                	xor    %ecx,%ecx
 533:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 536:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 538:	31 d2                	xor    %edx,%edx
 53a:	f7 f7                	div    %edi
 53c:	0f b6 92 85 09 00 00 	movzbl 0x985(%edx),%edx
 543:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 546:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 549:	85 c0                	test   %eax,%eax
 54b:	75 eb                	jne    538 <printint+0x28>
  if(neg)
 54d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 550:	85 c0                	test   %eax,%eax
 552:	74 08                	je     55c <printint+0x4c>
    buf[i++] = '-';
 554:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 559:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 55c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 55f:	01 fb                	add    %edi,%ebx
 561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 568:	0f b6 03             	movzbl (%ebx),%eax
 56b:	83 ef 01             	sub    $0x1,%edi
 56e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 571:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 578:	00 
 579:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 57c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	e8 f5 fe ff ff       	call   480 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58b:	83 ff ff             	cmp    $0xffffffff,%edi
 58e:	75 d8                	jne    568 <printint+0x58>
    putc(fd, buf[i]);
}
 590:	83 c4 4c             	add    $0x4c,%esp
 593:	5b                   	pop    %ebx
 594:	5e                   	pop    %esi
 595:	5f                   	pop    %edi
 596:	5d                   	pop    %ebp
 597:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 598:	89 d0                	mov    %edx,%eax
 59a:	f7 d8                	neg    %eax
 59c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 5a3:	eb 8c                	jmp    531 <printint+0x21>
 5a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005b0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bc:	0f b6 10             	movzbl (%eax),%edx
 5bf:	84 d2                	test   %dl,%dl
 5c1:	0f 84 c9 00 00 00    	je     690 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5c7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5ca:	31 ff                	xor    %edi,%edi
 5cc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 5cf:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 5d4:	eb 1e                	jmp    5f4 <printf+0x44>
 5d6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5d8:	83 fa 25             	cmp    $0x25,%edx
 5db:	0f 85 b7 00 00 00    	jne    698 <printf+0xe8>
 5e1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e5:	83 c3 01             	add    $0x1,%ebx
 5e8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 5ec:	84 d2                	test   %dl,%dl
 5ee:	0f 84 9c 00 00 00    	je     690 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 5f4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5f6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 5f9:	74 dd                	je     5d8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fb:	83 ff 25             	cmp    $0x25,%edi
 5fe:	75 e5                	jne    5e5 <printf+0x35>
      if(c == 'd'){
 600:	83 fa 64             	cmp    $0x64,%edx
 603:	0f 84 57 01 00 00    	je     760 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 609:	83 fa 70             	cmp    $0x70,%edx
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 610:	0f 84 aa 00 00 00    	je     6c0 <printf+0x110>
 616:	83 fa 78             	cmp    $0x78,%edx
 619:	0f 84 a1 00 00 00    	je     6c0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 61f:	83 fa 73             	cmp    $0x73,%edx
 622:	0f 84 c0 00 00 00    	je     6e8 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 628:	83 fa 63             	cmp    $0x63,%edx
 62b:	90                   	nop
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 630:	0f 84 52 01 00 00    	je     788 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 636:	83 fa 25             	cmp    $0x25,%edx
 639:	0f 84 f9 00 00 00    	je     738 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 642:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 645:	31 ff                	xor    %edi,%edi
 647:	89 55 cc             	mov    %edx,-0x34(%ebp)
 64a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 64e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 655:	00 
 656:	89 0c 24             	mov    %ecx,(%esp)
 659:	89 74 24 04          	mov    %esi,0x4(%esp)
 65d:	e8 1e fe ff ff       	call   480 <write>
 662:	8b 55 cc             	mov    -0x34(%ebp),%edx
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 66f:	00 
 670:	89 74 24 04          	mov    %esi,0x4(%esp)
 674:	88 55 e7             	mov    %dl,-0x19(%ebp)
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 01 fe ff ff       	call   480 <write>
 67f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 682:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 686:	84 d2                	test   %dl,%dl
 688:	0f 85 66 ff ff ff    	jne    5f4 <printf+0x44>
 68e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 690:	83 c4 3c             	add    $0x3c,%esp
 693:	5b                   	pop    %ebx
 694:	5e                   	pop    %esi
 695:	5f                   	pop    %edi
 696:	5d                   	pop    %ebp
 697:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 698:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 69b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 69e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a5:	00 
 6a6:	89 74 24 04          	mov    %esi,0x4(%esp)
 6aa:	89 04 24             	mov    %eax,(%esp)
 6ad:	e8 ce fd ff ff       	call   480 <write>
 6b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b5:	e9 2b ff ff ff       	jmp    5e5 <printf+0x35>
 6ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 6c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6c3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 6c8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 6ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	e8 35 fe ff ff       	call   510 <printint>
 6db:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 6de:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6e2:	e9 fe fe ff ff       	jmp    5e5 <printf+0x35>
 6e7:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 6e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6eb:	8b 3a                	mov    (%edx),%edi
        ap++;
 6ed:	83 c2 04             	add    $0x4,%edx
 6f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 6f3:	85 ff                	test   %edi,%edi
 6f5:	0f 84 ba 00 00 00    	je     7b5 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 6fb:	0f b6 17             	movzbl (%edi),%edx
 6fe:	84 d2                	test   %dl,%dl
 700:	74 2d                	je     72f <printf+0x17f>
 702:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 705:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 708:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 70e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 715:	00 
 716:	89 74 24 04          	mov    %esi,0x4(%esp)
 71a:	89 1c 24             	mov    %ebx,(%esp)
 71d:	e8 5e fd ff ff       	call   480 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 722:	0f b6 17             	movzbl (%edi),%edx
 725:	84 d2                	test   %dl,%dl
 727:	75 df                	jne    708 <printf+0x158>
 729:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 72c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 72f:	31 ff                	xor    %edi,%edi
 731:	e9 af fe ff ff       	jmp    5e5 <printf+0x35>
 736:	66 90                	xchg   %ax,%ax
 738:	8b 55 08             	mov    0x8(%ebp),%edx
 73b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 73d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 741:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 748:	00 
 749:	89 74 24 04          	mov    %esi,0x4(%esp)
 74d:	89 14 24             	mov    %edx,(%esp)
 750:	e8 2b fd ff ff       	call   480 <write>
 755:	8b 45 0c             	mov    0xc(%ebp),%eax
 758:	e9 88 fe ff ff       	jmp    5e5 <printf+0x35>
 75d:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 760:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 763:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 768:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 76b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 772:	8b 10                	mov    (%eax),%edx
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	e8 94 fd ff ff       	call   510 <printint>
 77c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 77f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 783:	e9 5d fe ff ff       	jmp    5e5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 788:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 78b:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78d:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 78f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 796:	00 
 797:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79b:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 79e:	8b 45 08             	mov    0x8(%ebp),%eax
 7a1:	89 04 24             	mov    %eax,(%esp)
 7a4:	e8 d7 fc ff ff       	call   480 <write>
 7a9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 7ac:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 7b0:	e9 30 fe ff ff       	jmp    5e5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 7b5:	bf 7e 09 00 00       	mov    $0x97e,%edi
 7ba:	e9 3c ff ff ff       	jmp    6fb <printf+0x14b>
 7bf:	90                   	nop

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	a1 a8 09 00 00       	mov    0x9a8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	57                   	push   %edi
 7c9:	56                   	push   %esi
 7ca:	53                   	push   %ebx
 7cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 7ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	39 c8                	cmp    %ecx,%eax
 7d3:	73 1d                	jae    7f2 <free+0x32>
 7d5:	8d 76 00             	lea    0x0(%esi),%esi
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	39 d1                	cmp    %edx,%ecx
 7dc:	72 1a                	jb     7f8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	39 d0                	cmp    %edx,%eax
 7e0:	72 08                	jb     7ea <free+0x2a>
 7e2:	39 c8                	cmp    %ecx,%eax
 7e4:	72 12                	jb     7f8 <free+0x38>
 7e6:	39 d1                	cmp    %edx,%ecx
 7e8:	72 0e                	jb     7f8 <free+0x38>
 7ea:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	39 c8                	cmp    %ecx,%eax
 7ee:	66 90                	xchg   %ax,%ax
 7f0:	72 e6                	jb     7d8 <free+0x18>
 7f2:	8b 10                	mov    (%eax),%edx
 7f4:	eb e8                	jmp    7de <free+0x1e>
 7f6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f8:	8b 71 04             	mov    0x4(%ecx),%esi
 7fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7fe:	39 d7                	cmp    %edx,%edi
 800:	74 19                	je     81b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 802:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 805:	8b 50 04             	mov    0x4(%eax),%edx
 808:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 80b:	39 ce                	cmp    %ecx,%esi
 80d:	74 23                	je     832 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 80f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 811:	a3 a8 09 00 00       	mov    %eax,0x9a8
}
 816:	5b                   	pop    %ebx
 817:	5e                   	pop    %esi
 818:	5f                   	pop    %edi
 819:	5d                   	pop    %ebp
 81a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81b:	03 72 04             	add    0x4(%edx),%esi
 81e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 821:	8b 10                	mov    (%eax),%edx
 823:	8b 12                	mov    (%edx),%edx
 825:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 828:	8b 50 04             	mov    0x4(%eax),%edx
 82b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 82e:	39 ce                	cmp    %ecx,%esi
 830:	75 dd                	jne    80f <free+0x4f>
    p->s.size += bp->s.size;
 832:	03 51 04             	add    0x4(%ecx),%edx
 835:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 838:	8b 53 f8             	mov    -0x8(%ebx),%edx
 83b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 83d:	a3 a8 09 00 00       	mov    %eax,0x9a8
}
 842:	5b                   	pop    %ebx
 843:	5e                   	pop    %esi
 844:	5f                   	pop    %edi
 845:	5d                   	pop    %ebp
 846:	c3                   	ret    
 847:	89 f6                	mov    %esi,%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 85c:	8b 0d a8 09 00 00    	mov    0x9a8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	83 c3 07             	add    $0x7,%ebx
 865:	c1 eb 03             	shr    $0x3,%ebx
 868:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 86b:	85 c9                	test   %ecx,%ecx
 86d:	0f 84 93 00 00 00    	je     906 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 873:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 875:	8b 50 04             	mov    0x4(%eax),%edx
 878:	39 d3                	cmp    %edx,%ebx
 87a:	76 1f                	jbe    89b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 87c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 883:	90                   	nop
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 888:	3b 05 a8 09 00 00    	cmp    0x9a8,%eax
 88e:	74 30                	je     8c0 <malloc+0x70>
 890:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 894:	8b 50 04             	mov    0x4(%eax),%edx
 897:	39 d3                	cmp    %edx,%ebx
 899:	77 ed                	ja     888 <malloc+0x38>
      if(p->s.size == nunits)
 89b:	39 d3                	cmp    %edx,%ebx
 89d:	74 61                	je     900 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 89f:	29 da                	sub    %ebx,%edx
 8a1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 8a7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 8aa:	89 0d a8 09 00 00    	mov    %ecx,0x9a8
      return (void*) (p + 1);
 8b0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8b3:	83 c4 1c             	add    $0x1c,%esp
 8b6:	5b                   	pop    %ebx
 8b7:	5e                   	pop    %esi
 8b8:	5f                   	pop    %edi
 8b9:	5d                   	pop    %ebp
 8ba:	c3                   	ret    
 8bb:	90                   	nop
 8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 8c0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 8c6:	b8 00 80 00 00       	mov    $0x8000,%eax
 8cb:	bf 00 10 00 00       	mov    $0x1000,%edi
 8d0:	76 04                	jbe    8d6 <malloc+0x86>
 8d2:	89 f0                	mov    %esi,%eax
 8d4:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8d6:	89 04 24             	mov    %eax,(%esp)
 8d9:	e8 0a fc ff ff       	call   4e8 <sbrk>
  if(p == (char*) -1)
 8de:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e1:	74 18                	je     8fb <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8e3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 8e6:	83 c0 08             	add    $0x8,%eax
 8e9:	89 04 24             	mov    %eax,(%esp)
 8ec:	e8 cf fe ff ff       	call   7c0 <free>
  return freep;
 8f1:	8b 0d a8 09 00 00    	mov    0x9a8,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8f7:	85 c9                	test   %ecx,%ecx
 8f9:	75 97                	jne    892 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8fb:	31 c0                	xor    %eax,%eax
 8fd:	eb b4                	jmp    8b3 <malloc+0x63>
 8ff:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 900:	8b 10                	mov    (%eax),%edx
 902:	89 11                	mov    %edx,(%ecx)
 904:	eb a4                	jmp    8aa <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 906:	c7 05 a8 09 00 00 a0 	movl   $0x9a0,0x9a8
 90d:	09 00 00 
    base.s.size = 0;
 910:	b9 a0 09 00 00       	mov    $0x9a0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 915:	c7 05 a0 09 00 00 a0 	movl   $0x9a0,0x9a0
 91c:	09 00 00 
    base.s.size = 0;
 91f:	c7 05 a4 09 00 00 00 	movl   $0x0,0x9a4
 926:	00 00 00 
 929:	e9 45 ff ff ff       	jmp    873 <malloc+0x23>
