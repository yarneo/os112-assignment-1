
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	89 1c 24             	mov    %ebx,(%esp)
   d:	e8 8e 01 00 00       	call   1a0 <strlen>
  12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  16:	89 44 24 08          	mov    %eax,0x8(%esp)
  1a:	8b 45 08             	mov    0x8(%ebp),%eax
  1d:	89 04 24             	mov    %eax,(%esp)
  20:	e8 5b 04 00 00       	call   480 <write>
}
  25:	83 c4 14             	add    $0x14,%esp
  28:	5b                   	pop    %ebx
  29:	5d                   	pop    %ebp
  2a:	c3                   	ret    
  2b:	90                   	nop
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000030 <forktest>:

void
forktest(void)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  int n, pid;

  printf(1, "fork test\n");
  34:	31 db                	xor    %ebx,%ebx
  write(fd, s, strlen(s));
}

void
forktest(void)
{
  36:	83 ec 14             	sub    $0x14,%esp
  int n, pid;

  printf(1, "fork test\n");
  39:	c7 44 24 04 08 05 00 	movl   $0x508,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 b3 ff ff ff       	call   0 <printf>
  4d:	eb 13                	jmp    62 <forktest+0x32>
  4f:	90                   	nop

  for(n=0; n<N; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0)
  50:	74 7a                	je     cc <forktest+0x9c>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  52:	83 c3 01             	add    $0x1,%ebx
  55:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  5b:	90                   	nop
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  60:	74 4e                	je     b0 <forktest+0x80>
  62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = fork();
  68:	e8 e3 03 00 00       	call   450 <fork>
    if(pid < 0)
  6d:	83 f8 00             	cmp    $0x0,%eax
  70:	7d de                	jge    50 <forktest+0x20>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  72:	85 db                	test   %ebx,%ebx
  74:	74 11                	je     87 <forktest+0x57>
  76:	66 90                	xchg   %ax,%ax
    if(wait() < 0){
  78:	e8 e3 03 00 00       	call   460 <wait>
  7d:	85 c0                	test   %eax,%eax
  7f:	90                   	nop
  80:	78 4f                	js     d1 <forktest+0xa1>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  82:	83 eb 01             	sub    $0x1,%ebx
  85:	75 f1                	jne    78 <forktest+0x48>
  87:	90                   	nop
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  88:	e8 d3 03 00 00       	call   460 <wait>
  8d:	83 f8 ff             	cmp    $0xffffffff,%eax
  90:	75 58                	jne    ea <forktest+0xba>
    printf(1, "wait got too many\n");
    exit();
  }
  
  printf(1, "fork test OK\n");
  92:	c7 44 24 04 3a 05 00 	movl   $0x53a,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 5a ff ff ff       	call   0 <printf>
}
  a6:	83 c4 14             	add    $0x14,%esp
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid == 0)
      exit();
  }
  
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
  b0:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  b7:	00 
  b8:	c7 44 24 04 48 05 00 	movl   $0x548,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 34 ff ff ff       	call   0 <printf>
    exit();
  cc:	e8 87 03 00 00       	call   458 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
      printf(1, "wait stopped early\n");
  d1:	c7 44 24 04 13 05 00 	movl   $0x513,0x4(%esp)
  d8:	00 
  d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e0:	e8 1b ff ff ff       	call   0 <printf>
      exit();
  e5:	e8 6e 03 00 00       	call   458 <exit>
    }
  }
  
  if(wait() != -1){
    printf(1, "wait got too many\n");
  ea:	c7 44 24 04 27 05 00 	movl   $0x527,0x4(%esp)
  f1:	00 
  f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f9:	e8 02 ff ff ff       	call   0 <printf>
    exit();
  fe:	e8 55 03 00 00       	call   458 <exit>
 103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 116:	e8 15 ff ff ff       	call   30 <forktest>
  exit();
 11b:	e8 38 03 00 00       	call   458 <exit>

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
