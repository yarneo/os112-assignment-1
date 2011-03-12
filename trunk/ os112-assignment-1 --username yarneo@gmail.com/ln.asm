
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	53                   	push   %ebx
   7:	83 ec 1c             	sub    $0x1c,%esp
   a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(argc != 3){
   d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
  11:	74 1d                	je     30 <main+0x30>
    printf(2, "Usage: ln old new\n");
  13:	c7 44 24 04 8e 08 00 	movl   $0x88e,0x4(%esp)
  1a:	00 
  1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  22:	e8 e9 04 00 00       	call   510 <printf>
    exit();
  27:	e8 8c 03 00 00       	call   3b8 <exit>
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  if(link(argv[1], argv[2]) < 0)
  30:	8b 43 08             	mov    0x8(%ebx),%eax
  33:	89 44 24 04          	mov    %eax,0x4(%esp)
  37:	8b 43 04             	mov    0x4(%ebx),%eax
  3a:	89 04 24             	mov    %eax,(%esp)
  3d:	e8 de 03 00 00       	call   420 <link>
  42:	85 c0                	test   %eax,%eax
  44:	78 0a                	js     50 <main+0x50>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  46:	e8 6d 03 00 00       	call   3b8 <exit>
  4b:	90                   	nop
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(argc != 3){
    printf(2, "Usage: ln old new\n");
    exit();
  }
  if(link(argv[1], argv[2]) < 0)
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  50:	8b 43 08             	mov    0x8(%ebx),%eax
  53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  57:	8b 43 04             	mov    0x4(%ebx),%eax
  5a:	c7 44 24 04 a1 08 00 	movl   $0x8a1,0x4(%esp)
  61:	00 
  62:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  69:	89 44 24 08          	mov    %eax,0x8(%esp)
  6d:	e8 9e 04 00 00       	call   510 <printf>
  72:	eb d2                	jmp    46 <main+0x46>
  74:	90                   	nop
  75:	90                   	nop
  76:	90                   	nop
  77:	90                   	nop
  78:	90                   	nop
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop
  7c:	90                   	nop
  7d:	90                   	nop
  7e:	90                   	nop
  7f:	90                   	nop

00000080 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  80:	55                   	push   %ebp
  81:	31 d2                	xor    %edx,%edx
  83:	89 e5                	mov    %esp,%ebp
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	53                   	push   %ebx
  89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  97:	83 c2 01             	add    $0x1,%edx
  9a:	84 c9                	test   %cl,%cl
  9c:	75 f2                	jne    90 <strcpy+0x10>
    ;
  return os;
}
  9e:	5b                   	pop    %ebx
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    
  a1:	eb 0d                	jmp    b0 <strcmp>
  a3:	90                   	nop
  a4:	90                   	nop
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop
  a8:	90                   	nop
  a9:	90                   	nop
  aa:	90                   	nop
  ab:	90                   	nop
  ac:	90                   	nop
  ad:	90                   	nop
  ae:	90                   	nop
  af:	90                   	nop

000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	53                   	push   %ebx
  b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  ba:	0f b6 01             	movzbl (%ecx),%eax
  bd:	84 c0                	test   %al,%al
  bf:	75 14                	jne    d5 <strcmp+0x25>
  c1:	eb 25                	jmp    e8 <strcmp+0x38>
  c3:	90                   	nop
  c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  c8:	83 c1 01             	add    $0x1,%ecx
  cb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ce:	0f b6 01             	movzbl (%ecx),%eax
  d1:	84 c0                	test   %al,%al
  d3:	74 13                	je     e8 <strcmp+0x38>
  d5:	0f b6 1a             	movzbl (%edx),%ebx
  d8:	38 d8                	cmp    %bl,%al
  da:	74 ec                	je     c8 <strcmp+0x18>
  dc:	0f b6 db             	movzbl %bl,%ebx
  df:	0f b6 c0             	movzbl %al,%eax
  e2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e8:	0f b6 1a             	movzbl (%edx),%ebx
  eb:	31 c0                	xor    %eax,%eax
  ed:	0f b6 db             	movzbl %bl,%ebx
  f0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  f2:	5b                   	pop    %ebx
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <strlen>:

uint
strlen(char *s)
{
 100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 101:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 103:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 105:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 10a:	80 39 00             	cmpb   $0x0,(%ecx)
 10d:	74 0c                	je     11b <strlen+0x1b>
 10f:	90                   	nop
 110:	83 c2 01             	add    $0x1,%edx
 113:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 117:	89 d0                	mov    %edx,%eax
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	75 11                	jne    162 <strchr+0x22>
 151:	eb 15                	jmp    168 <strchr+0x28>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 158:	83 c0 01             	add    $0x1,%eax
 15b:	0f b6 10             	movzbl (%eax),%edx
 15e:	84 d2                	test   %dl,%dl
 160:	74 06                	je     168 <strchr+0x28>
    if(*s == c)
 162:	38 ca                	cmp    %cl,%dl
 164:	75 f2                	jne    158 <strchr+0x18>
      return (char*) s;
  return 0;
}
 166:	5d                   	pop    %ebp
 167:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 16a:	5d                   	pop    %ebp
 16b:	90                   	nop
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	c3                   	ret    
 171:	eb 0d                	jmp    180 <atoi>
 173:	90                   	nop
 174:	90                   	nop
 175:	90                   	nop
 176:	90                   	nop
 177:	90                   	nop
 178:	90                   	nop
 179:	90                   	nop
 17a:	90                   	nop
 17b:	90                   	nop
 17c:	90                   	nop
 17d:	90                   	nop
 17e:	90                   	nop
 17f:	90                   	nop

00000180 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 180:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 181:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 183:	89 e5                	mov    %esp,%ebp
 185:	8b 4d 08             	mov    0x8(%ebp),%ecx
 188:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 189:	0f b6 11             	movzbl (%ecx),%edx
 18c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 18f:	80 fb 09             	cmp    $0x9,%bl
 192:	77 1c                	ja     1b0 <atoi+0x30>
 194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 198:	0f be d2             	movsbl %dl,%edx
 19b:	83 c1 01             	add    $0x1,%ecx
 19e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1a1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a5:	0f b6 11             	movzbl (%ecx),%edx
 1a8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1ab:	80 fb 09             	cmp    $0x9,%bl
 1ae:	76 e8                	jbe    198 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	53                   	push   %ebx
 1c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ce:	85 db                	test   %ebx,%ebx
 1d0:	7e 14                	jle    1e6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1d2:	31 d2                	xor    %edx,%edx
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1df:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1e2:	39 da                	cmp    %ebx,%edx
 1e4:	75 f2                	jne    1d8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1e6:	5b                   	pop    %ebx
 1e7:	5e                   	pop    %esi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    
 1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001f0 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f6:	57                   	push   %edi
 1f7:	56                   	push   %esi
 1f8:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1f9:	80 39 00             	cmpb   $0x0,(%ecx)
 1fc:	74 37                	je     235 <reverse+0x45>
 1fe:	31 d2                	xor    %edx,%edx
 200:	83 c2 01             	add    $0x1,%edx
 203:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 207:	75 f7                	jne    200 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 209:	8d 7a ff             	lea    -0x1(%edx),%edi
 20c:	85 ff                	test   %edi,%edi
 20e:	7e 25                	jle    235 <reverse+0x45>
 210:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 213:	31 c0                	xor    %eax,%eax
 215:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 218:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 21c:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 21f:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 223:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 226:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 228:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 22b:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 22e:	83 ea 01             	sub    $0x1,%edx
 231:	39 f8                	cmp    %edi,%eax
 233:	7c e3                	jl     218 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 235:	5b                   	pop    %ebx
 236:	5e                   	pop    %esi
 237:	5f                   	pop    %edi
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 244:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 249:	56                   	push   %esi
 24a:	53                   	push   %ebx
 24b:	31 db                	xor    %ebx,%ebx
 24d:	83 ec 04             	sub    $0x4,%esp
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8b 75 0c             	mov    0xc(%ebp),%esi
 256:	89 45 f0             	mov    %eax,-0x10(%ebp)
 259:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 25c:	c1 f8 1f             	sar    $0x1f,%eax
 25f:	31 c1                	xor    %eax,%ecx
 261:	29 c1                	sub    %eax,%ecx
 263:	90                   	nop
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 268:	89 c8                	mov    %ecx,%eax
 26a:	f7 ef                	imul   %edi
 26c:	89 c8                	mov    %ecx,%eax
 26e:	c1 f8 1f             	sar    $0x1f,%eax
 271:	c1 fa 02             	sar    $0x2,%edx
 274:	29 c2                	sub    %eax,%edx
 276:	8d 04 92             	lea    (%edx,%edx,4),%eax
 279:	01 c0                	add    %eax,%eax
 27b:	29 c1                	sub    %eax,%ecx
 27d:	83 c1 30             	add    $0x30,%ecx
 280:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 283:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 286:	85 d2                	test   %edx,%edx
 288:	89 d1                	mov    %edx,%ecx
 28a:	7f dc                	jg     268 <itoa+0x28>
     if (sign < 0)
 28c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 28f:	85 c0                	test   %eax,%eax
 291:	79 07                	jns    29a <itoa+0x5a>
         s[i++] = '-';
 293:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 297:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 29a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 29e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 2a1:	83 c4 04             	add    $0x4,%esp
 2a4:	5b                   	pop    %ebx
 2a5:	5e                   	pop    %esi
 2a6:	5f                   	pop    %edi
 2a7:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 2a8:	e9 43 ff ff ff       	jmp    1f0 <reverse>
 2ad:	8d 76 00             	lea    0x0(%esi),%esi

000002b0 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 2b0:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2b1:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	57                   	push   %edi
 2b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
 2bc:	56                   	push   %esi
 2bd:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2be:	31 db                	xor    %ebx,%ebx
 2c0:	80 38 00             	cmpb   $0x0,(%eax)
 2c3:	74 0e                	je     2d3 <strcat+0x23>
 2c5:	8d 76 00             	lea    0x0(%esi),%esi
 2c8:	83 c2 01             	add    $0x1,%edx
 2cb:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 2cf:	75 f7                	jne    2c8 <strcat+0x18>
 2d1:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 2d3:	0f b6 0f             	movzbl (%edi),%ecx
 2d6:	84 c9                	test   %cl,%cl
 2d8:	74 18                	je     2f2 <strcat+0x42>
 2da:	8d 34 10             	lea    (%eax,%edx,1),%esi
 2dd:	31 db                	xor    %ebx,%ebx
 2df:	90                   	nop
 2e0:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 2e3:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2e5:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 2e9:	83 c6 01             	add    $0x1,%esi
 2ec:	84 c9                	test   %cl,%cl
 2ee:	75 f0                	jne    2e0 <strcat+0x30>
 2f0:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2f2:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
 2fb:	90                   	nop
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 306:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 309:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 30c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 30f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 314:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 31b:	00 
 31c:	89 04 24             	mov    %eax,(%esp)
 31f:	e8 dc 00 00 00       	call   400 <open>
  if(fd < 0)
 324:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 326:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 328:	78 19                	js     343 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 1c 24             	mov    %ebx,(%esp)
 330:	89 44 24 04          	mov    %eax,0x4(%esp)
 334:	e8 df 00 00 00       	call   418 <fstat>
  close(fd);
 339:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 33c:	89 c6                	mov    %eax,%esi
  close(fd);
 33e:	e8 a5 00 00 00       	call   3e8 <close>
  return r;
}
 343:	89 f0                	mov    %esi,%eax
 345:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 348:	8b 75 fc             	mov    -0x4(%ebp),%esi
 34b:	89 ec                	mov    %ebp,%esp
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    
 34f:	90                   	nop

00000350 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	31 f6                	xor    %esi,%esi
 357:	53                   	push   %ebx
 358:	83 ec 2c             	sub    $0x2c,%esp
 35b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35e:	eb 06                	jmp    366 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 360:	3c 0a                	cmp    $0xa,%al
 362:	74 39                	je     39d <gets+0x4d>
 364:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	8d 5e 01             	lea    0x1(%esi),%ebx
 369:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 36c:	7d 31                	jge    39f <gets+0x4f>
    cc = read(0, &c, 1);
 36e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 371:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 378:	00 
 379:	89 44 24 04          	mov    %eax,0x4(%esp)
 37d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 384:	e8 4f 00 00 00       	call   3d8 <read>
    if(cc < 1)
 389:	85 c0                	test   %eax,%eax
 38b:	7e 12                	jle    39f <gets+0x4f>
      break;
    buf[i++] = c;
 38d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 391:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 395:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 399:	3c 0d                	cmp    $0xd,%al
 39b:	75 c3                	jne    360 <gets+0x10>
 39d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 39f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3a3:	89 f8                	mov    %edi,%eax
 3a5:	83 c4 2c             	add    $0x2c,%esp
 3a8:	5b                   	pop    %ebx
 3a9:	5e                   	pop    %esi
 3aa:	5f                   	pop    %edi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	90                   	nop
 3ae:	90                   	nop
 3af:	90                   	nop

000003b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <exit>:
SYSCALL(exit)
 3b8:	b8 02 00 00 00       	mov    $0x2,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <wait>:
SYSCALL(wait)
 3c0:	b8 03 00 00 00       	mov    $0x3,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <wait2>:
SYSCALL(wait2)
 3c8:	b8 16 00 00 00       	mov    $0x16,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <pipe>:
SYSCALL(pipe)
 3d0:	b8 04 00 00 00       	mov    $0x4,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <read>:
SYSCALL(read)
 3d8:	b8 06 00 00 00       	mov    $0x6,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <write>:
SYSCALL(write)
 3e0:	b8 05 00 00 00       	mov    $0x5,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <close>:
SYSCALL(close)
 3e8:	b8 07 00 00 00       	mov    $0x7,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <kill>:
SYSCALL(kill)
 3f0:	b8 08 00 00 00       	mov    $0x8,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <exec>:
SYSCALL(exec)
 3f8:	b8 09 00 00 00       	mov    $0x9,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <open>:
SYSCALL(open)
 400:	b8 0a 00 00 00       	mov    $0xa,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <mknod>:
SYSCALL(mknod)
 408:	b8 0b 00 00 00       	mov    $0xb,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <unlink>:
SYSCALL(unlink)
 410:	b8 0c 00 00 00       	mov    $0xc,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <fstat>:
SYSCALL(fstat)
 418:	b8 0d 00 00 00       	mov    $0xd,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <link>:
SYSCALL(link)
 420:	b8 0e 00 00 00       	mov    $0xe,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <mkdir>:
SYSCALL(mkdir)
 428:	b8 0f 00 00 00       	mov    $0xf,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <chdir>:
SYSCALL(chdir)
 430:	b8 10 00 00 00       	mov    $0x10,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <dup>:
SYSCALL(dup)
 438:	b8 11 00 00 00       	mov    $0x11,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <getpid>:
SYSCALL(getpid)
 440:	b8 12 00 00 00       	mov    $0x12,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <sbrk>:
SYSCALL(sbrk)
 448:	b8 13 00 00 00       	mov    $0x13,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <sleep>:
SYSCALL(sleep)
 450:	b8 14 00 00 00       	mov    $0x14,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <uptime>:
SYSCALL(uptime)
 458:	b8 15 00 00 00       	mov    $0x15,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <nice>:
SYSCALL(nice)
 460:	b8 17 00 00 00       	mov    $0x17,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    
 468:	90                   	nop
 469:	90                   	nop
 46a:	90                   	nop
 46b:	90                   	nop
 46c:	90                   	nop
 46d:	90                   	nop
 46e:	90                   	nop
 46f:	90                   	nop

00000470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	89 cf                	mov    %ecx,%edi
 476:	56                   	push   %esi
 477:	89 c6                	mov    %eax,%esi
 479:	53                   	push   %ebx
 47a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 480:	85 c9                	test   %ecx,%ecx
 482:	74 04                	je     488 <printint+0x18>
 484:	85 d2                	test   %edx,%edx
 486:	78 70                	js     4f8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 488:	89 d0                	mov    %edx,%eax
 48a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 491:	31 c9                	xor    %ecx,%ecx
 493:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 496:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 498:	31 d2                	xor    %edx,%edx
 49a:	f7 f7                	div    %edi
 49c:	0f b6 92 bc 08 00 00 	movzbl 0x8bc(%edx),%edx
 4a3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 4a6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 4a9:	85 c0                	test   %eax,%eax
 4ab:	75 eb                	jne    498 <printint+0x28>
  if(neg)
 4ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4b0:	85 c0                	test   %eax,%eax
 4b2:	74 08                	je     4bc <printint+0x4c>
    buf[i++] = '-';
 4b4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 4b9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 4bc:	8d 79 ff             	lea    -0x1(%ecx),%edi
 4bf:	01 fb                	add    %edi,%ebx
 4c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4c8:	0f b6 03             	movzbl (%ebx),%eax
 4cb:	83 ef 01             	sub    $0x1,%edi
 4ce:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d8:	00 
 4d9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4dc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4df:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	e8 f5 fe ff ff       	call   3e0 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4eb:	83 ff ff             	cmp    $0xffffffff,%edi
 4ee:	75 d8                	jne    4c8 <printint+0x58>
    putc(fd, buf[i]);
}
 4f0:	83 c4 4c             	add    $0x4c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4f8:	89 d0                	mov    %edx,%eax
 4fa:	f7 d8                	neg    %eax
 4fc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 503:	eb 8c                	jmp    491 <printint+0x21>
 505:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000510 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	0f b6 10             	movzbl (%eax),%edx
 51f:	84 d2                	test   %dl,%dl
 521:	0f 84 c9 00 00 00    	je     5f0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 527:	8d 4d 10             	lea    0x10(%ebp),%ecx
 52a:	31 ff                	xor    %edi,%edi
 52c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 52f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 531:	8d 75 e7             	lea    -0x19(%ebp),%esi
 534:	eb 1e                	jmp    554 <printf+0x44>
 536:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 538:	83 fa 25             	cmp    $0x25,%edx
 53b:	0f 85 b7 00 00 00    	jne    5f8 <printf+0xe8>
 541:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 545:	83 c3 01             	add    $0x1,%ebx
 548:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 54c:	84 d2                	test   %dl,%dl
 54e:	0f 84 9c 00 00 00    	je     5f0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 554:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 556:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 559:	74 dd                	je     538 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55b:	83 ff 25             	cmp    $0x25,%edi
 55e:	75 e5                	jne    545 <printf+0x35>
      if(c == 'd'){
 560:	83 fa 64             	cmp    $0x64,%edx
 563:	0f 84 57 01 00 00    	je     6c0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 569:	83 fa 70             	cmp    $0x70,%edx
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 570:	0f 84 aa 00 00 00    	je     620 <printf+0x110>
 576:	83 fa 78             	cmp    $0x78,%edx
 579:	0f 84 a1 00 00 00    	je     620 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 57f:	83 fa 73             	cmp    $0x73,%edx
 582:	0f 84 c0 00 00 00    	je     648 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 588:	83 fa 63             	cmp    $0x63,%edx
 58b:	90                   	nop
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 590:	0f 84 52 01 00 00    	je     6e8 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 596:	83 fa 25             	cmp    $0x25,%edx
 599:	0f 84 f9 00 00 00    	je     698 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a2:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a5:	31 ff                	xor    %edi,%edi
 5a7:	89 55 cc             	mov    %edx,-0x34(%ebp)
 5aa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b5:	00 
 5b6:	89 0c 24             	mov    %ecx,(%esp)
 5b9:	89 74 24 04          	mov    %esi,0x4(%esp)
 5bd:	e8 1e fe ff ff       	call   3e0 <write>
 5c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5cf:	00 
 5d0:	89 74 24 04          	mov    %esi,0x4(%esp)
 5d4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 01 fe ff ff       	call   3e0 <write>
 5df:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 5e6:	84 d2                	test   %dl,%dl
 5e8:	0f 85 66 ff ff ff    	jne    554 <printf+0x44>
 5ee:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f0:	83 c4 3c             	add    $0x3c,%esp
 5f3:	5b                   	pop    %ebx
 5f4:	5e                   	pop    %esi
 5f5:	5f                   	pop    %edi
 5f6:	5d                   	pop    %ebp
 5f7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 605:	00 
 606:	89 74 24 04          	mov    %esi,0x4(%esp)
 60a:	89 04 24             	mov    %eax,(%esp)
 60d:	e8 ce fd ff ff       	call   3e0 <write>
 612:	8b 45 0c             	mov    0xc(%ebp),%eax
 615:	e9 2b ff ff ff       	jmp    545 <printf+0x35>
 61a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 620:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 623:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 628:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 62a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 631:	8b 10                	mov    (%eax),%edx
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	e8 35 fe ff ff       	call   470 <printint>
 63b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 63e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 642:	e9 fe fe ff ff       	jmp    545 <printf+0x35>
 647:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 64b:	8b 3a                	mov    (%edx),%edi
        ap++;
 64d:	83 c2 04             	add    $0x4,%edx
 650:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 653:	85 ff                	test   %edi,%edi
 655:	0f 84 ba 00 00 00    	je     715 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 65b:	0f b6 17             	movzbl (%edi),%edx
 65e:	84 d2                	test   %dl,%dl
 660:	74 2d                	je     68f <printf+0x17f>
 662:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 665:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 668:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 66b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 675:	00 
 676:	89 74 24 04          	mov    %esi,0x4(%esp)
 67a:	89 1c 24             	mov    %ebx,(%esp)
 67d:	e8 5e fd ff ff       	call   3e0 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 682:	0f b6 17             	movzbl (%edi),%edx
 685:	84 d2                	test   %dl,%dl
 687:	75 df                	jne    668 <printf+0x158>
 689:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 68c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 68f:	31 ff                	xor    %edi,%edi
 691:	e9 af fe ff ff       	jmp    545 <printf+0x35>
 696:	66 90                	xchg   %ax,%ax
 698:	8b 55 08             	mov    0x8(%ebp),%edx
 69b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 69d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a8:	00 
 6a9:	89 74 24 04          	mov    %esi,0x4(%esp)
 6ad:	89 14 24             	mov    %edx,(%esp)
 6b0:	e8 2b fd ff ff       	call   3e0 <write>
 6b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b8:	e9 88 fe ff ff       	jmp    545 <printf+0x35>
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 6c8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	e8 94 fd ff ff       	call   470 <printint>
 6dc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 6df:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6e3:	e9 5d fe ff ff       	jmp    545 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 6eb:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ed:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6f6:	00 
 6f7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fb:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 d7 fc ff ff       	call   3e0 <write>
 709:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 70c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 710:	e9 30 fe ff ff       	jmp    545 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 715:	bf b5 08 00 00       	mov    $0x8b5,%edi
 71a:	e9 3c ff ff ff       	jmp    65b <printf+0x14b>
 71f:	90                   	nop

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 d8 08 00 00       	mov    0x8d8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	39 c8                	cmp    %ecx,%eax
 733:	73 1d                	jae    752 <free+0x32>
 735:	8d 76 00             	lea    0x0(%esi),%esi
 738:	8b 10                	mov    (%eax),%edx
 73a:	39 d1                	cmp    %edx,%ecx
 73c:	72 1a                	jb     758 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73e:	39 d0                	cmp    %edx,%eax
 740:	72 08                	jb     74a <free+0x2a>
 742:	39 c8                	cmp    %ecx,%eax
 744:	72 12                	jb     758 <free+0x38>
 746:	39 d1                	cmp    %edx,%ecx
 748:	72 0e                	jb     758 <free+0x38>
 74a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74c:	39 c8                	cmp    %ecx,%eax
 74e:	66 90                	xchg   %ax,%ax
 750:	72 e6                	jb     738 <free+0x18>
 752:	8b 10                	mov    (%eax),%edx
 754:	eb e8                	jmp    73e <free+0x1e>
 756:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 71 04             	mov    0x4(%ecx),%esi
 75b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75e:	39 d7                	cmp    %edx,%edi
 760:	74 19                	je     77b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 762:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 765:	8b 50 04             	mov    0x4(%eax),%edx
 768:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76b:	39 ce                	cmp    %ecx,%esi
 76d:	74 23                	je     792 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 76f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 771:	a3 d8 08 00 00       	mov    %eax,0x8d8
}
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77b:	03 72 04             	add    0x4(%edx),%esi
 77e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 781:	8b 10                	mov    (%eax),%edx
 783:	8b 12                	mov    (%edx),%edx
 785:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 788:	8b 50 04             	mov    0x4(%eax),%edx
 78b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 78e:	39 ce                	cmp    %ecx,%esi
 790:	75 dd                	jne    76f <free+0x4f>
    p->s.size += bp->s.size;
 792:	03 51 04             	add    0x4(%ecx),%edx
 795:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 798:	8b 53 f8             	mov    -0x8(%ebx),%edx
 79b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 79d:	a3 d8 08 00 00       	mov    %eax,0x8d8
}
 7a2:	5b                   	pop    %ebx
 7a3:	5e                   	pop    %esi
 7a4:	5f                   	pop    %edi
 7a5:	5d                   	pop    %ebp
 7a6:	c3                   	ret    
 7a7:	89 f6                	mov    %esi,%esi
 7a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 7bc:	8b 0d d8 08 00 00    	mov    0x8d8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	83 c3 07             	add    $0x7,%ebx
 7c5:	c1 eb 03             	shr    $0x3,%ebx
 7c8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7cb:	85 c9                	test   %ecx,%ecx
 7cd:	0f 84 93 00 00 00    	je     866 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	39 d3                	cmp    %edx,%ebx
 7da:	76 1f                	jbe    7fb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 7dc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7e3:	90                   	nop
 7e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 7e8:	3b 05 d8 08 00 00    	cmp    0x8d8,%eax
 7ee:	74 30                	je     820 <malloc+0x70>
 7f0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 7f4:	8b 50 04             	mov    0x4(%eax),%edx
 7f7:	39 d3                	cmp    %edx,%ebx
 7f9:	77 ed                	ja     7e8 <malloc+0x38>
      if(p->s.size == nunits)
 7fb:	39 d3                	cmp    %edx,%ebx
 7fd:	74 61                	je     860 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7ff:	29 da                	sub    %ebx,%edx
 801:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 804:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 807:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 80a:	89 0d d8 08 00 00    	mov    %ecx,0x8d8
      return (void*) (p + 1);
 810:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 813:	83 c4 1c             	add    $0x1c,%esp
 816:	5b                   	pop    %ebx
 817:	5e                   	pop    %esi
 818:	5f                   	pop    %edi
 819:	5d                   	pop    %ebp
 81a:	c3                   	ret    
 81b:	90                   	nop
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 820:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 826:	b8 00 80 00 00       	mov    $0x8000,%eax
 82b:	bf 00 10 00 00       	mov    $0x1000,%edi
 830:	76 04                	jbe    836 <malloc+0x86>
 832:	89 f0                	mov    %esi,%eax
 834:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 836:	89 04 24             	mov    %eax,(%esp)
 839:	e8 0a fc ff ff       	call   448 <sbrk>
  if(p == (char*) -1)
 83e:	83 f8 ff             	cmp    $0xffffffff,%eax
 841:	74 18                	je     85b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 843:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 846:	83 c0 08             	add    $0x8,%eax
 849:	89 04 24             	mov    %eax,(%esp)
 84c:	e8 cf fe ff ff       	call   720 <free>
  return freep;
 851:	8b 0d d8 08 00 00    	mov    0x8d8,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 857:	85 c9                	test   %ecx,%ecx
 859:	75 97                	jne    7f2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 85b:	31 c0                	xor    %eax,%eax
 85d:	eb b4                	jmp    813 <malloc+0x63>
 85f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 860:	8b 10                	mov    (%eax),%edx
 862:	89 11                	mov    %edx,(%ecx)
 864:	eb a4                	jmp    80a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 866:	c7 05 d8 08 00 00 d0 	movl   $0x8d0,0x8d8
 86d:	08 00 00 
    base.s.size = 0;
 870:	b9 d0 08 00 00       	mov    $0x8d0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 875:	c7 05 d0 08 00 00 d0 	movl   $0x8d0,0x8d0
 87c:	08 00 00 
    base.s.size = 0;
 87f:	c7 05 d4 08 00 00 00 	movl   $0x0,0x8d4
 886:	00 00 00 
 889:	e9 45 ff ff ff       	jmp    7d3 <malloc+0x23>
