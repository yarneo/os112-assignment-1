
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
   7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   a:	eb 1c                	jmp    28 <cat+0x28>
   c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    write(1, buf, n);
  10:	89 44 24 08          	mov    %eax,0x8(%esp)
  14:	c7 44 24 04 80 09 00 	movl   $0x980,0x4(%esp)
  1b:	00 
  1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  23:	e8 48 04 00 00       	call   470 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2f:	00 
  30:	c7 44 24 04 80 09 00 	movl   $0x980,0x4(%esp)
  37:	00 
  38:	89 1c 24             	mov    %ebx,(%esp)
  3b:	e8 28 04 00 00       	call   468 <read>
  40:	83 f8 00             	cmp    $0x0,%eax
  43:	7f cb                	jg     10 <cat+0x10>
    write(1, buf, n);
  if(n < 0){
  45:	75 0a                	jne    51 <cat+0x51>
    printf(1, "cat: read error\n");
    exit();
  }
}
  47:	83 c4 14             	add    $0x14,%esp
  4a:	5b                   	pop    %ebx
  4b:	5d                   	pop    %ebp
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  50:	c3                   	ret    
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    write(1, buf, n);
  if(n < 0){
    printf(1, "cat: read error\n");
  51:	c7 44 24 04 1e 09 00 	movl   $0x91e,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 3b 05 00 00       	call   5a0 <printf>
    exit();
  65:	e8 de 03 00 00       	call   448 <exit>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000070 <main>:
  }
}

int
main(int argc, char *argv[])
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	83 e4 f0             	and    $0xfffffff0,%esp
  76:	57                   	push   %edi
  77:	56                   	push   %esi
  78:	53                   	push   %ebx
  79:	83 ec 24             	sub    $0x24,%esp
  7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
  7f:	83 ff 01             	cmp    $0x1,%edi
  82:	7e 6c                	jle    f0 <main+0x80>
    cat(0);
    exit();
  84:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  87:	be 01 00 00 00       	mov    $0x1,%esi
  8c:	83 c3 04             	add    $0x4,%ebx
  8f:	90                   	nop
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  97:	00 
  98:	8b 03                	mov    (%ebx),%eax
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 ee 03 00 00       	call   490 <open>
  a2:	85 c0                	test   %eax,%eax
  a4:	78 2a                	js     d0 <main+0x60>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  a6:	89 04 24             	mov    %eax,(%esp)
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  a9:	83 c6 01             	add    $0x1,%esi
  ac:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  af:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  b3:	e8 48 ff ff ff       	call   0 <cat>
    close(fd);
  b8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  bc:	89 04 24             	mov    %eax,(%esp)
  bf:	e8 b4 03 00 00       	call   478 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  c4:	39 f7                	cmp    %esi,%edi
  c6:	7f c8                	jg     90 <main+0x20>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  c8:	e8 7b 03 00 00       	call   448 <exit>
  cd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
  d0:	8b 03                	mov    (%ebx),%eax
  d2:	c7 44 24 04 2f 09 00 	movl   $0x92f,0x4(%esp)
  d9:	00 
  da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  e5:	e8 b6 04 00 00       	call   5a0 <printf>
      exit();
  ea:	e8 59 03 00 00       	call   448 <exit>
  ef:	90                   	nop
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    cat(0);
  f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f7:	e8 04 ff ff ff       	call   0 <cat>
    exit();
  fc:	e8 47 03 00 00       	call   448 <exit>
 101:	90                   	nop
 102:	90                   	nop
 103:	90                   	nop
 104:	90                   	nop
 105:	90                   	nop
 106:	90                   	nop
 107:	90                   	nop
 108:	90                   	nop
 109:	90                   	nop
 10a:	90                   	nop
 10b:	90                   	nop
 10c:	90                   	nop
 10d:	90                   	nop
 10e:	90                   	nop
 10f:	90                   	nop

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	31 d2                	xor    %edx,%edx
 113:	89 e5                	mov    %esp,%ebp
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	53                   	push   %ebx
 119:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 120:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 124:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 c9                	test   %cl,%cl
 12c:	75 f2                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    
 131:	eb 0d                	jmp    140 <strcmp>
 133:	90                   	nop
 134:	90                   	nop
 135:	90                   	nop
 136:	90                   	nop
 137:	90                   	nop
 138:	90                   	nop
 139:	90                   	nop
 13a:	90                   	nop
 13b:	90                   	nop
 13c:	90                   	nop
 13d:	90                   	nop
 13e:	90                   	nop
 13f:	90                   	nop

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 4d 08             	mov    0x8(%ebp),%ecx
 147:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14a:	0f b6 01             	movzbl (%ecx),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 14                	jne    165 <strcmp+0x25>
 151:	eb 25                	jmp    178 <strcmp+0x38>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 158:	83 c1 01             	add    $0x1,%ecx
 15b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15e:	0f b6 01             	movzbl (%ecx),%eax
 161:	84 c0                	test   %al,%al
 163:	74 13                	je     178 <strcmp+0x38>
 165:	0f b6 1a             	movzbl (%edx),%ebx
 168:	38 d8                	cmp    %bl,%al
 16a:	74 ec                	je     158 <strcmp+0x18>
 16c:	0f b6 db             	movzbl %bl,%ebx
 16f:	0f b6 c0             	movzbl %al,%eax
 172:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 174:	5b                   	pop    %ebx
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 178:	0f b6 1a             	movzbl (%edx),%ebx
 17b:	31 c0                	xor    %eax,%eax
 17d:	0f b6 db             	movzbl %bl,%ebx
 180:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 182:	5b                   	pop    %ebx
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 191:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 193:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 195:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 19a:	80 39 00             	cmpb   $0x0,(%ecx)
 19d:	74 0c                	je     1ab <strlen+0x1b>
 19f:	90                   	nop
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 55 08             	mov    0x8(%ebp),%edx
 1b6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bd:	89 d7                	mov    %edx,%edi
 1bf:	fc                   	cld    
 1c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c2:	89 d0                	mov    %edx,%eax
 1c4:	5f                   	pop    %edi
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    
 1c7:	89 f6                	mov    %esi,%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <strchr>:

char*
strchr(const char *s, char c)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1da:	0f b6 10             	movzbl (%eax),%edx
 1dd:	84 d2                	test   %dl,%dl
 1df:	75 11                	jne    1f2 <strchr+0x22>
 1e1:	eb 15                	jmp    1f8 <strchr+0x28>
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	0f b6 10             	movzbl (%eax),%edx
 1ee:	84 d2                	test   %dl,%dl
 1f0:	74 06                	je     1f8 <strchr+0x28>
    if(*s == c)
 1f2:	38 ca                	cmp    %cl,%dl
 1f4:	75 f2                	jne    1e8 <strchr+0x18>
      return (char*) s;
  return 0;
}
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 1fa:	5d                   	pop    %ebp
 1fb:	90                   	nop
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <atoi>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 211:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 213:	89 e5                	mov    %esp,%ebp
 215:	8b 4d 08             	mov    0x8(%ebp),%ecx
 218:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 219:	0f b6 11             	movzbl (%ecx),%edx
 21c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 21f:	80 fb 09             	cmp    $0x9,%bl
 222:	77 1c                	ja     240 <atoi+0x30>
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 228:	0f be d2             	movsbl %dl,%edx
 22b:	83 c1 01             	add    $0x1,%ecx
 22e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 231:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 235:	0f b6 11             	movzbl (%ecx),%edx
 238:	8d 5a d0             	lea    -0x30(%edx),%ebx
 23b:	80 fb 09             	cmp    $0x9,%bl
 23e:	76 e8                	jbe    228 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	56                   	push   %esi
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	53                   	push   %ebx
 258:	8b 5d 10             	mov    0x10(%ebp),%ebx
 25b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25e:	85 db                	test   %ebx,%ebx
 260:	7e 14                	jle    276 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 262:	31 d2                	xor    %edx,%edx
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 268:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 26c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 26f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 272:	39 da                	cmp    %ebx,%edx
 274:	75 f2                	jne    268 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 276:	5b                   	pop    %ebx
 277:	5e                   	pop    %esi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    
 27a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000280 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 08             	mov    0x8(%ebp),%ecx
 286:	57                   	push   %edi
 287:	56                   	push   %esi
 288:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 289:	80 39 00             	cmpb   $0x0,(%ecx)
 28c:	74 37                	je     2c5 <reverse+0x45>
 28e:	31 d2                	xor    %edx,%edx
 290:	83 c2 01             	add    $0x1,%edx
 293:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 297:	75 f7                	jne    290 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 299:	8d 7a ff             	lea    -0x1(%edx),%edi
 29c:	85 ff                	test   %edi,%edi
 29e:	7e 25                	jle    2c5 <reverse+0x45>
 2a0:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 2a3:	31 c0                	xor    %eax,%eax
 2a5:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 2a8:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2ac:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 2af:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 2b3:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 2b6:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2b8:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 2bb:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 2be:	83 ea 01             	sub    $0x1,%edx
 2c1:	39 f8                	cmp    %edi,%eax
 2c3:	7c e3                	jl     2a8 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 2c5:	5b                   	pop    %ebx
 2c6:	5e                   	pop    %esi
 2c7:	5f                   	pop    %edi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002d0 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 2d4:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 2d9:	56                   	push   %esi
 2da:	53                   	push   %ebx
 2db:	31 db                	xor    %ebx,%ebx
 2dd:	83 ec 04             	sub    $0x4,%esp
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	8b 75 0c             	mov    0xc(%ebp),%esi
 2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 2e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 2ec:	c1 f8 1f             	sar    $0x1f,%eax
 2ef:	31 c1                	xor    %eax,%ecx
 2f1:	29 c1                	sub    %eax,%ecx
 2f3:	90                   	nop
 2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	f7 ef                	imul   %edi
 2fc:	89 c8                	mov    %ecx,%eax
 2fe:	c1 f8 1f             	sar    $0x1f,%eax
 301:	c1 fa 02             	sar    $0x2,%edx
 304:	29 c2                	sub    %eax,%edx
 306:	8d 04 92             	lea    (%edx,%edx,4),%eax
 309:	01 c0                	add    %eax,%eax
 30b:	29 c1                	sub    %eax,%ecx
 30d:	83 c1 30             	add    $0x30,%ecx
 310:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 313:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 316:	85 d2                	test   %edx,%edx
 318:	89 d1                	mov    %edx,%ecx
 31a:	7f dc                	jg     2f8 <itoa+0x28>
     if (sign < 0)
 31c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 31f:	85 c0                	test   %eax,%eax
 321:	79 07                	jns    32a <itoa+0x5a>
         s[i++] = '-';
 323:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 327:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 32a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 32e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 331:	83 c4 04             	add    $0x4,%esp
 334:	5b                   	pop    %ebx
 335:	5e                   	pop    %esi
 336:	5f                   	pop    %edi
 337:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 338:	e9 43 ff ff ff       	jmp    280 <reverse>
 33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 340:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 341:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 343:	89 e5                	mov    %esp,%ebp
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	57                   	push   %edi
 349:	8b 7d 0c             	mov    0xc(%ebp),%edi
 34c:	56                   	push   %esi
 34d:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 34e:	31 db                	xor    %ebx,%ebx
 350:	80 38 00             	cmpb   $0x0,(%eax)
 353:	74 0e                	je     363 <strcat+0x23>
 355:	8d 76 00             	lea    0x0(%esi),%esi
 358:	83 c2 01             	add    $0x1,%edx
 35b:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 35f:	75 f7                	jne    358 <strcat+0x18>
 361:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 363:	0f b6 0f             	movzbl (%edi),%ecx
 366:	84 c9                	test   %cl,%cl
 368:	74 18                	je     382 <strcat+0x42>
 36a:	8d 34 10             	lea    (%eax,%edx,1),%esi
 36d:	31 db                	xor    %ebx,%ebx
 36f:	90                   	nop
 370:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 373:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 375:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 379:	83 c6 01             	add    $0x1,%esi
 37c:	84 c9                	test   %cl,%cl
 37e:	75 f0                	jne    370 <strcat+0x30>
 380:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 382:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 386:	5b                   	pop    %ebx
 387:	5e                   	pop    %esi
 388:	5f                   	pop    %edi
 389:	5d                   	pop    %ebp
 38a:	c3                   	ret    
 38b:	90                   	nop
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000390 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 396:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 399:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 39c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 39f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3ab:	00 
 3ac:	89 04 24             	mov    %eax,(%esp)
 3af:	e8 dc 00 00 00       	call   490 <open>
  if(fd < 0)
 3b4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 3b8:	78 19                	js     3d3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	89 1c 24             	mov    %ebx,(%esp)
 3c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c4:	e8 df 00 00 00       	call   4a8 <fstat>
  close(fd);
 3c9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 3cc:	89 c6                	mov    %eax,%esi
  close(fd);
 3ce:	e8 a5 00 00 00       	call   478 <close>
  return r;
}
 3d3:	89 f0                	mov    %esi,%eax
 3d5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 3d8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 3db:	89 ec                	mov    %ebp,%esp
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	90                   	nop

000003e0 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	31 f6                	xor    %esi,%esi
 3e7:	53                   	push   %ebx
 3e8:	83 ec 2c             	sub    $0x2c,%esp
 3eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ee:	eb 06                	jmp    3f6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f0:	3c 0a                	cmp    $0xa,%al
 3f2:	74 39                	je     42d <gets+0x4d>
 3f4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f6:	8d 5e 01             	lea    0x1(%esi),%ebx
 3f9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3fc:	7d 31                	jge    42f <gets+0x4f>
    cc = read(0, &c, 1);
 3fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
 401:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 408:	00 
 409:	89 44 24 04          	mov    %eax,0x4(%esp)
 40d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 414:	e8 4f 00 00 00       	call   468 <read>
    if(cc < 1)
 419:	85 c0                	test   %eax,%eax
 41b:	7e 12                	jle    42f <gets+0x4f>
      break;
    buf[i++] = c;
 41d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 421:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 425:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 429:	3c 0d                	cmp    $0xd,%al
 42b:	75 c3                	jne    3f0 <gets+0x10>
 42d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 42f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 433:	89 f8                	mov    %edi,%eax
 435:	83 c4 2c             	add    $0x2c,%esp
 438:	5b                   	pop    %ebx
 439:	5e                   	pop    %esi
 43a:	5f                   	pop    %edi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	90                   	nop
 43e:	90                   	nop
 43f:	90                   	nop

00000440 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 440:	b8 01 00 00 00       	mov    $0x1,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <exit>:
SYSCALL(exit)
 448:	b8 02 00 00 00       	mov    $0x2,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <wait>:
SYSCALL(wait)
 450:	b8 03 00 00 00       	mov    $0x3,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <wait2>:
SYSCALL(wait2)
 458:	b8 16 00 00 00       	mov    $0x16,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <pipe>:
SYSCALL(pipe)
 460:	b8 04 00 00 00       	mov    $0x4,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <read>:
SYSCALL(read)
 468:	b8 06 00 00 00       	mov    $0x6,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <write>:
SYSCALL(write)
 470:	b8 05 00 00 00       	mov    $0x5,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <close>:
SYSCALL(close)
 478:	b8 07 00 00 00       	mov    $0x7,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <kill>:
SYSCALL(kill)
 480:	b8 08 00 00 00       	mov    $0x8,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <exec>:
SYSCALL(exec)
 488:	b8 09 00 00 00       	mov    $0x9,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <open>:
SYSCALL(open)
 490:	b8 0a 00 00 00       	mov    $0xa,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <mknod>:
SYSCALL(mknod)
 498:	b8 0b 00 00 00       	mov    $0xb,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <unlink>:
SYSCALL(unlink)
 4a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <fstat>:
SYSCALL(fstat)
 4a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <link>:
SYSCALL(link)
 4b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <mkdir>:
SYSCALL(mkdir)
 4b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <chdir>:
SYSCALL(chdir)
 4c0:	b8 10 00 00 00       	mov    $0x10,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <dup>:
SYSCALL(dup)
 4c8:	b8 11 00 00 00       	mov    $0x11,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <getpid>:
SYSCALL(getpid)
 4d0:	b8 12 00 00 00       	mov    $0x12,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <sbrk>:
SYSCALL(sbrk)
 4d8:	b8 13 00 00 00       	mov    $0x13,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <sleep>:
SYSCALL(sleep)
 4e0:	b8 14 00 00 00       	mov    $0x14,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <uptime>:
SYSCALL(uptime)
 4e8:	b8 15 00 00 00       	mov    $0x15,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <nice>:
SYSCALL(nice)
 4f0:	b8 17 00 00 00       	mov    $0x17,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    
 4f8:	90                   	nop
 4f9:	90                   	nop
 4fa:	90                   	nop
 4fb:	90                   	nop
 4fc:	90                   	nop
 4fd:	90                   	nop
 4fe:	90                   	nop
 4ff:	90                   	nop

00000500 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	89 cf                	mov    %ecx,%edi
 506:	56                   	push   %esi
 507:	89 c6                	mov    %eax,%esi
 509:	53                   	push   %ebx
 50a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 510:	85 c9                	test   %ecx,%ecx
 512:	74 04                	je     518 <printint+0x18>
 514:	85 d2                	test   %edx,%edx
 516:	78 70                	js     588 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 518:	89 d0                	mov    %edx,%eax
 51a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 521:	31 c9                	xor    %ecx,%ecx
 523:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 526:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 528:	31 d2                	xor    %edx,%edx
 52a:	f7 f7                	div    %edi
 52c:	0f b6 92 4b 09 00 00 	movzbl 0x94b(%edx),%edx
 533:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 536:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 539:	85 c0                	test   %eax,%eax
 53b:	75 eb                	jne    528 <printint+0x28>
  if(neg)
 53d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 540:	85 c0                	test   %eax,%eax
 542:	74 08                	je     54c <printint+0x4c>
    buf[i++] = '-';
 544:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 549:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 54c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 54f:	01 fb                	add    %edi,%ebx
 551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 558:	0f b6 03             	movzbl (%ebx),%eax
 55b:	83 ef 01             	sub    $0x1,%edi
 55e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 568:	00 
 569:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 56c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	e8 f5 fe ff ff       	call   470 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 57b:	83 ff ff             	cmp    $0xffffffff,%edi
 57e:	75 d8                	jne    558 <printint+0x58>
    putc(fd, buf[i]);
}
 580:	83 c4 4c             	add    $0x4c,%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 588:	89 d0                	mov    %edx,%eax
 58a:	f7 d8                	neg    %eax
 58c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 593:	eb 8c                	jmp    521 <printint+0x21>
 595:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ac:	0f b6 10             	movzbl (%eax),%edx
 5af:	84 d2                	test   %dl,%dl
 5b1:	0f 84 c9 00 00 00    	je     680 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5b7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 5ba:	31 ff                	xor    %edi,%edi
 5bc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 5bf:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 5c4:	eb 1e                	jmp    5e4 <printf+0x44>
 5c6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5c8:	83 fa 25             	cmp    $0x25,%edx
 5cb:	0f 85 b7 00 00 00    	jne    688 <printf+0xe8>
 5d1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d5:	83 c3 01             	add    $0x1,%ebx
 5d8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 5dc:	84 d2                	test   %dl,%dl
 5de:	0f 84 9c 00 00 00    	je     680 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 5e4:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5e6:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 5e9:	74 dd                	je     5c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5eb:	83 ff 25             	cmp    $0x25,%edi
 5ee:	75 e5                	jne    5d5 <printf+0x35>
      if(c == 'd'){
 5f0:	83 fa 64             	cmp    $0x64,%edx
 5f3:	0f 84 57 01 00 00    	je     750 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5f9:	83 fa 70             	cmp    $0x70,%edx
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 600:	0f 84 aa 00 00 00    	je     6b0 <printf+0x110>
 606:	83 fa 78             	cmp    $0x78,%edx
 609:	0f 84 a1 00 00 00    	je     6b0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 60f:	83 fa 73             	cmp    $0x73,%edx
 612:	0f 84 c0 00 00 00    	je     6d8 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 618:	83 fa 63             	cmp    $0x63,%edx
 61b:	90                   	nop
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 620:	0f 84 52 01 00 00    	je     778 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 626:	83 fa 25             	cmp    $0x25,%edx
 629:	0f 84 f9 00 00 00    	je     728 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 632:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 635:	31 ff                	xor    %edi,%edi
 637:	89 55 cc             	mov    %edx,-0x34(%ebp)
 63a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 63e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 645:	00 
 646:	89 0c 24             	mov    %ecx,(%esp)
 649:	89 74 24 04          	mov    %esi,0x4(%esp)
 64d:	e8 1e fe ff ff       	call   470 <write>
 652:	8b 55 cc             	mov    -0x34(%ebp),%edx
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 65f:	00 
 660:	89 74 24 04          	mov    %esi,0x4(%esp)
 664:	88 55 e7             	mov    %dl,-0x19(%ebp)
 667:	89 04 24             	mov    %eax,(%esp)
 66a:	e8 01 fe ff ff       	call   470 <write>
 66f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 672:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 676:	84 d2                	test   %dl,%dl
 678:	0f 85 66 ff ff ff    	jne    5e4 <printf+0x44>
 67e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 680:	83 c4 3c             	add    $0x3c,%esp
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 688:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 68b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 68e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 695:	00 
 696:	89 74 24 04          	mov    %esi,0x4(%esp)
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 ce fd ff ff       	call   470 <write>
 6a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a5:	e9 2b ff ff ff       	jmp    5d5 <printf+0x35>
 6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 6b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6b3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 6b8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 6ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6c1:	8b 10                	mov    (%eax),%edx
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	e8 35 fe ff ff       	call   500 <printint>
 6cb:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 6ce:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6d2:	e9 fe fe ff ff       	jmp    5d5 <printf+0x35>
 6d7:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 6d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 6db:	8b 3a                	mov    (%edx),%edi
        ap++;
 6dd:	83 c2 04             	add    $0x4,%edx
 6e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 6e3:	85 ff                	test   %edi,%edi
 6e5:	0f 84 ba 00 00 00    	je     7a5 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 6eb:	0f b6 17             	movzbl (%edi),%edx
 6ee:	84 d2                	test   %dl,%dl
 6f0:	74 2d                	je     71f <printf+0x17f>
 6f2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 6f8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 705:	00 
 706:	89 74 24 04          	mov    %esi,0x4(%esp)
 70a:	89 1c 24             	mov    %ebx,(%esp)
 70d:	e8 5e fd ff ff       	call   470 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 712:	0f b6 17             	movzbl (%edi),%edx
 715:	84 d2                	test   %dl,%dl
 717:	75 df                	jne    6f8 <printf+0x158>
 719:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 71c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 71f:	31 ff                	xor    %edi,%edi
 721:	e9 af fe ff ff       	jmp    5d5 <printf+0x35>
 726:	66 90                	xchg   %ax,%ax
 728:	8b 55 08             	mov    0x8(%ebp),%edx
 72b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 72d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 731:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 738:	00 
 739:	89 74 24 04          	mov    %esi,0x4(%esp)
 73d:	89 14 24             	mov    %edx,(%esp)
 740:	e8 2b fd ff ff       	call   470 <write>
 745:	8b 45 0c             	mov    0xc(%ebp),%eax
 748:	e9 88 fe ff ff       	jmp    5d5 <printf+0x35>
 74d:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 753:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 758:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 75b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 762:	8b 10                	mov    (%eax),%edx
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	e8 94 fd ff ff       	call   500 <printint>
 76c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 76f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 773:	e9 5d fe ff ff       	jmp    5d5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 778:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 77b:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 77d:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 77f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 786:	00 
 787:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78b:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 78e:	8b 45 08             	mov    0x8(%ebp),%eax
 791:	89 04 24             	mov    %eax,(%esp)
 794:	e8 d7 fc ff ff       	call   470 <write>
 799:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 79c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 7a0:	e9 30 fe ff ff       	jmp    5d5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 7a5:	bf 44 09 00 00       	mov    $0x944,%edi
 7aa:	e9 3c ff ff ff       	jmp    6eb <printf+0x14b>
 7af:	90                   	nop

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b1:	a1 68 09 00 00       	mov    0x968,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b6:	89 e5                	mov    %esp,%ebp
 7b8:	57                   	push   %edi
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 7be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	39 c8                	cmp    %ecx,%eax
 7c3:	73 1d                	jae    7e2 <free+0x32>
 7c5:	8d 76 00             	lea    0x0(%esi),%esi
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	39 d1                	cmp    %edx,%ecx
 7cc:	72 1a                	jb     7e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	39 d0                	cmp    %edx,%eax
 7d0:	72 08                	jb     7da <free+0x2a>
 7d2:	39 c8                	cmp    %ecx,%eax
 7d4:	72 12                	jb     7e8 <free+0x38>
 7d6:	39 d1                	cmp    %edx,%ecx
 7d8:	72 0e                	jb     7e8 <free+0x38>
 7da:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	39 c8                	cmp    %ecx,%eax
 7de:	66 90                	xchg   %ax,%ax
 7e0:	72 e6                	jb     7c8 <free+0x18>
 7e2:	8b 10                	mov    (%eax),%edx
 7e4:	eb e8                	jmp    7ce <free+0x1e>
 7e6:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 71 04             	mov    0x4(%ecx),%esi
 7eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ee:	39 d7                	cmp    %edx,%edi
 7f0:	74 19                	je     80b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7f5:	8b 50 04             	mov    0x4(%eax),%edx
 7f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7fb:	39 ce                	cmp    %ecx,%esi
 7fd:	74 23                	je     822 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
 801:	a3 68 09 00 00       	mov    %eax,0x968
}
 806:	5b                   	pop    %ebx
 807:	5e                   	pop    %esi
 808:	5f                   	pop    %edi
 809:	5d                   	pop    %ebp
 80a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 80b:	03 72 04             	add    0x4(%edx),%esi
 80e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 811:	8b 10                	mov    (%eax),%edx
 813:	8b 12                	mov    (%edx),%edx
 815:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 818:	8b 50 04             	mov    0x4(%eax),%edx
 81b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 81e:	39 ce                	cmp    %ecx,%esi
 820:	75 dd                	jne    7ff <free+0x4f>
    p->s.size += bp->s.size;
 822:	03 51 04             	add    0x4(%ecx),%edx
 825:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 828:	8b 53 f8             	mov    -0x8(%ebx),%edx
 82b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 82d:	a3 68 09 00 00       	mov    %eax,0x968
}
 832:	5b                   	pop    %ebx
 833:	5e                   	pop    %esi
 834:	5f                   	pop    %edi
 835:	5d                   	pop    %ebp
 836:	c3                   	ret    
 837:	89 f6                	mov    %esi,%esi
 839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 84c:	8b 0d 68 09 00 00    	mov    0x968,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 852:	83 c3 07             	add    $0x7,%ebx
 855:	c1 eb 03             	shr    $0x3,%ebx
 858:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 85b:	85 c9                	test   %ecx,%ecx
 85d:	0f 84 93 00 00 00    	je     8f6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 863:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 865:	8b 50 04             	mov    0x4(%eax),%edx
 868:	39 d3                	cmp    %edx,%ebx
 86a:	76 1f                	jbe    88b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 86c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 873:	90                   	nop
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 878:	3b 05 68 09 00 00    	cmp    0x968,%eax
 87e:	74 30                	je     8b0 <malloc+0x70>
 880:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 884:	8b 50 04             	mov    0x4(%eax),%edx
 887:	39 d3                	cmp    %edx,%ebx
 889:	77 ed                	ja     878 <malloc+0x38>
      if(p->s.size == nunits)
 88b:	39 d3                	cmp    %edx,%ebx
 88d:	74 61                	je     8f0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 88f:	29 da                	sub    %ebx,%edx
 891:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 894:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 897:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 89a:	89 0d 68 09 00 00    	mov    %ecx,0x968
      return (void*) (p + 1);
 8a0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a3:	83 c4 1c             	add    $0x1c,%esp
 8a6:	5b                   	pop    %ebx
 8a7:	5e                   	pop    %esi
 8a8:	5f                   	pop    %edi
 8a9:	5d                   	pop    %ebp
 8aa:	c3                   	ret    
 8ab:	90                   	nop
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 8b0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 8b6:	b8 00 80 00 00       	mov    $0x8000,%eax
 8bb:	bf 00 10 00 00       	mov    $0x1000,%edi
 8c0:	76 04                	jbe    8c6 <malloc+0x86>
 8c2:	89 f0                	mov    %esi,%eax
 8c4:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8c6:	89 04 24             	mov    %eax,(%esp)
 8c9:	e8 0a fc ff ff       	call   4d8 <sbrk>
  if(p == (char*) -1)
 8ce:	83 f8 ff             	cmp    $0xffffffff,%eax
 8d1:	74 18                	je     8eb <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8d3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 8d6:	83 c0 08             	add    $0x8,%eax
 8d9:	89 04 24             	mov    %eax,(%esp)
 8dc:	e8 cf fe ff ff       	call   7b0 <free>
  return freep;
 8e1:	8b 0d 68 09 00 00    	mov    0x968,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8e7:	85 c9                	test   %ecx,%ecx
 8e9:	75 97                	jne    882 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8eb:	31 c0                	xor    %eax,%eax
 8ed:	eb b4                	jmp    8a3 <malloc+0x63>
 8ef:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 8f0:	8b 10                	mov    (%eax),%edx
 8f2:	89 11                	mov    %edx,(%ecx)
 8f4:	eb a4                	jmp    89a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8f6:	c7 05 68 09 00 00 60 	movl   $0x960,0x968
 8fd:	09 00 00 
    base.s.size = 0;
 900:	b9 60 09 00 00       	mov    $0x960,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 905:	c7 05 60 09 00 00 60 	movl   $0x960,0x960
 90c:	09 00 00 
    base.s.size = 0;
 90f:	c7 05 64 09 00 00 00 	movl   $0x0,0x964
 916:	00 00 00 
 919:	e9 45 ff ff ff       	jmp    863 <malloc+0x23>
