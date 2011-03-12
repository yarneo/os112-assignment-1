
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	57                   	push   %edi
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	83 ec 14             	sub    $0x14,%esp
   c:	8b 75 08             	mov    0x8(%ebp),%esi
   f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 1){
  12:	85 f6                	test   %esi,%esi
  14:	7e 2a                	jle    40 <main+0x40>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  16:	83 fe 01             	cmp    $0x1,%esi
{
  int i;

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  19:	bb 01 00 00 00       	mov    $0x1,%ebx
  }
  for(i=1; i<argc; i++)
  1e:	74 1a                	je     3a <main+0x3a>
    kill(atoi(argv[i]));
  20:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  23:	83 c3 01             	add    $0x1,%ebx
    kill(atoi(argv[i]));
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 32 01 00 00       	call   160 <atoi>
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 9a 03 00 00       	call   3d0 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  36:	39 de                	cmp    %ebx,%esi
  38:	7f e6                	jg     20 <main+0x20>
    kill(atoi(argv[i]));
  exit();
  3a:	e8 59 03 00 00       	call   398 <exit>
  3f:	90                   	nop
main(int argc, char **argv)
{
  int i;

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
  40:	c7 44 24 04 6e 08 00 	movl   $0x86e,0x4(%esp)
  47:	00 
  48:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  4f:	e8 9c 04 00 00       	call   4f0 <printf>
    exit();
  54:	e8 3f 03 00 00       	call   398 <exit>
  59:	90                   	nop
  5a:	90                   	nop
  5b:	90                   	nop
  5c:	90                   	nop
  5d:	90                   	nop
  5e:	90                   	nop
  5f:	90                   	nop

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	31 d2                	xor    %edx,%edx
  63:	89 e5                	mov    %esp,%ebp
  65:	8b 45 08             	mov    0x8(%ebp),%eax
  68:	53                   	push   %ebx
  69:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 c9                	test   %cl,%cl
  7c:	75 f2                	jne    70 <strcpy+0x10>
    ;
  return os;
}
  7e:	5b                   	pop    %ebx
  7f:	5d                   	pop    %ebp
  80:	c3                   	ret    
  81:	eb 0d                	jmp    90 <strcmp>
  83:	90                   	nop
  84:	90                   	nop
  85:	90                   	nop
  86:	90                   	nop
  87:	90                   	nop
  88:	90                   	nop
  89:	90                   	nop
  8a:	90                   	nop
  8b:	90                   	nop
  8c:	90                   	nop
  8d:	90                   	nop
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9a:	0f b6 01             	movzbl (%ecx),%eax
  9d:	84 c0                	test   %al,%al
  9f:	75 14                	jne    b5 <strcmp+0x25>
  a1:	eb 25                	jmp    c8 <strcmp+0x38>
  a3:	90                   	nop
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
  a8:	83 c1 01             	add    $0x1,%ecx
  ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ae:	0f b6 01             	movzbl (%ecx),%eax
  b1:	84 c0                	test   %al,%al
  b3:	74 13                	je     c8 <strcmp+0x38>
  b5:	0f b6 1a             	movzbl (%edx),%ebx
  b8:	38 d8                	cmp    %bl,%al
  ba:	74 ec                	je     a8 <strcmp+0x18>
  bc:	0f b6 db             	movzbl %bl,%ebx
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  c4:	5b                   	pop    %ebx
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    
  c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	0f b6 1a             	movzbl (%edx),%ebx
  cb:	31 c0                	xor    %eax,%eax
  cd:	0f b6 db             	movzbl %bl,%ebx
  d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  d2:	5b                   	pop    %ebx
  d3:	5d                   	pop    %ebp
  d4:	c3                   	ret    
  d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
  e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
  e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ea:	80 39 00             	cmpb   $0x0,(%ecx)
  ed:	74 0c                	je     fb <strlen+0x1b>
  ef:	90                   	nop
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
    ;
  return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
 106:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 d7                	mov    %edx,%edi
 10f:	fc                   	cld    
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	89 d0                	mov    %edx,%eax
 114:	5f                   	pop    %edi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    
 117:	89 f6                	mov    %esi,%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 12a:	0f b6 10             	movzbl (%eax),%edx
 12d:	84 d2                	test   %dl,%dl
 12f:	75 11                	jne    142 <strchr+0x22>
 131:	eb 15                	jmp    148 <strchr+0x28>
 133:	90                   	nop
 134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 138:	83 c0 01             	add    $0x1,%eax
 13b:	0f b6 10             	movzbl (%eax),%edx
 13e:	84 d2                	test   %dl,%dl
 140:	74 06                	je     148 <strchr+0x28>
    if(*s == c)
 142:	38 ca                	cmp    %cl,%dl
 144:	75 f2                	jne    138 <strchr+0x18>
      return (char*) s;
  return 0;
}
 146:	5d                   	pop    %ebp
 147:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 148:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 14a:	5d                   	pop    %ebp
 14b:	90                   	nop
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <atoi>
 153:	90                   	nop
 154:	90                   	nop
 155:	90                   	nop
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 160:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 161:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 163:	89 e5                	mov    %esp,%ebp
 165:	8b 4d 08             	mov    0x8(%ebp),%ecx
 168:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 169:	0f b6 11             	movzbl (%ecx),%edx
 16c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 16f:	80 fb 09             	cmp    $0x9,%bl
 172:	77 1c                	ja     190 <atoi+0x30>
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 178:	0f be d2             	movsbl %dl,%edx
 17b:	83 c1 01             	add    $0x1,%ecx
 17e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 181:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 185:	0f b6 11             	movzbl (%ecx),%edx
 188:	8d 5a d0             	lea    -0x30(%edx),%ebx
 18b:	80 fb 09             	cmp    $0x9,%bl
 18e:	76 e8                	jbe    178 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	56                   	push   %esi
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	53                   	push   %ebx
 1a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 1ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1ae:	85 db                	test   %ebx,%ebx
 1b0:	7e 14                	jle    1c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 1b2:	31 d2                	xor    %edx,%edx
 1b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 1b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1c2:	39 da                	cmp    %ebx,%edx
 1c4:	75 f2                	jne    1b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    
 1ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001d0 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d6:	57                   	push   %edi
 1d7:	56                   	push   %esi
 1d8:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1d9:	80 39 00             	cmpb   $0x0,(%ecx)
 1dc:	74 37                	je     215 <reverse+0x45>
 1de:	31 d2                	xor    %edx,%edx
 1e0:	83 c2 01             	add    $0x1,%edx
 1e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1e7:	75 f7                	jne    1e0 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 1e9:	8d 7a ff             	lea    -0x1(%edx),%edi
 1ec:	85 ff                	test   %edi,%edi
 1ee:	7e 25                	jle    215 <reverse+0x45>
 1f0:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 1f3:	31 c0                	xor    %eax,%eax
 1f5:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 1f8:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 1fc:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 1ff:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 203:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 206:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 208:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 20b:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 20e:	83 ea 01             	sub    $0x1,%edx
 211:	39 f8                	cmp    %edi,%eax
 213:	7c e3                	jl     1f8 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 215:	5b                   	pop    %ebx
 216:	5e                   	pop    %esi
 217:	5f                   	pop    %edi
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000220 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 224:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 229:	56                   	push   %esi
 22a:	53                   	push   %ebx
 22b:	31 db                	xor    %ebx,%ebx
 22d:	83 ec 04             	sub    $0x4,%esp
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	8b 75 0c             	mov    0xc(%ebp),%esi
 236:	89 45 f0             	mov    %eax,-0x10(%ebp)
 239:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 23c:	c1 f8 1f             	sar    $0x1f,%eax
 23f:	31 c1                	xor    %eax,%ecx
 241:	29 c1                	sub    %eax,%ecx
 243:	90                   	nop
 244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 248:	89 c8                	mov    %ecx,%eax
 24a:	f7 ef                	imul   %edi
 24c:	89 c8                	mov    %ecx,%eax
 24e:	c1 f8 1f             	sar    $0x1f,%eax
 251:	c1 fa 02             	sar    $0x2,%edx
 254:	29 c2                	sub    %eax,%edx
 256:	8d 04 92             	lea    (%edx,%edx,4),%eax
 259:	01 c0                	add    %eax,%eax
 25b:	29 c1                	sub    %eax,%ecx
 25d:	83 c1 30             	add    $0x30,%ecx
 260:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 263:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 266:	85 d2                	test   %edx,%edx
 268:	89 d1                	mov    %edx,%ecx
 26a:	7f dc                	jg     248 <itoa+0x28>
     if (sign < 0)
 26c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 26f:	85 c0                	test   %eax,%eax
 271:	79 07                	jns    27a <itoa+0x5a>
         s[i++] = '-';
 273:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 277:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 27a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 27e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 281:	83 c4 04             	add    $0x4,%esp
 284:	5b                   	pop    %ebx
 285:	5e                   	pop    %esi
 286:	5f                   	pop    %edi
 287:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 288:	e9 43 ff ff ff       	jmp    1d0 <reverse>
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 290:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 291:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 293:	89 e5                	mov    %esp,%ebp
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	57                   	push   %edi
 299:	8b 7d 0c             	mov    0xc(%ebp),%edi
 29c:	56                   	push   %esi
 29d:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 29e:	31 db                	xor    %ebx,%ebx
 2a0:	80 38 00             	cmpb   $0x0,(%eax)
 2a3:	74 0e                	je     2b3 <strcat+0x23>
 2a5:	8d 76 00             	lea    0x0(%esi),%esi
 2a8:	83 c2 01             	add    $0x1,%edx
 2ab:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 2af:	75 f7                	jne    2a8 <strcat+0x18>
 2b1:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 2b3:	0f b6 0f             	movzbl (%edi),%ecx
 2b6:	84 c9                	test   %cl,%cl
 2b8:	74 18                	je     2d2 <strcat+0x42>
 2ba:	8d 34 10             	lea    (%eax,%edx,1),%esi
 2bd:	31 db                	xor    %ebx,%ebx
 2bf:	90                   	nop
 2c0:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 2c3:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2c5:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 2c9:	83 c6 01             	add    $0x1,%esi
 2cc:	84 c9                	test   %cl,%cl
 2ce:	75 f0                	jne    2c0 <strcat+0x30>
 2d0:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2d2:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002e0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 2e9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 2ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 2ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2fb:	00 
 2fc:	89 04 24             	mov    %eax,(%esp)
 2ff:	e8 dc 00 00 00       	call   3e0 <open>
  if(fd < 0)
 304:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 306:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 308:	78 19                	js     323 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 1c 24             	mov    %ebx,(%esp)
 310:	89 44 24 04          	mov    %eax,0x4(%esp)
 314:	e8 df 00 00 00       	call   3f8 <fstat>
  close(fd);
 319:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 31c:	89 c6                	mov    %eax,%esi
  close(fd);
 31e:	e8 a5 00 00 00       	call   3c8 <close>
  return r;
}
 323:	89 f0                	mov    %esi,%eax
 325:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 328:	8b 75 fc             	mov    -0x4(%ebp),%esi
 32b:	89 ec                	mov    %ebp,%esp
 32d:	5d                   	pop    %ebp
 32e:	c3                   	ret    
 32f:	90                   	nop

00000330 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	31 f6                	xor    %esi,%esi
 337:	53                   	push   %ebx
 338:	83 ec 2c             	sub    $0x2c,%esp
 33b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33e:	eb 06                	jmp    346 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 340:	3c 0a                	cmp    $0xa,%al
 342:	74 39                	je     37d <gets+0x4d>
 344:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 346:	8d 5e 01             	lea    0x1(%esi),%ebx
 349:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 34c:	7d 31                	jge    37f <gets+0x4f>
    cc = read(0, &c, 1);
 34e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 351:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 358:	00 
 359:	89 44 24 04          	mov    %eax,0x4(%esp)
 35d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 364:	e8 4f 00 00 00       	call   3b8 <read>
    if(cc < 1)
 369:	85 c0                	test   %eax,%eax
 36b:	7e 12                	jle    37f <gets+0x4f>
      break;
    buf[i++] = c;
 36d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 371:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 375:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 379:	3c 0d                	cmp    $0xd,%al
 37b:	75 c3                	jne    340 <gets+0x10>
 37d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 37f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 383:	89 f8                	mov    %edi,%eax
 385:	83 c4 2c             	add    $0x2c,%esp
 388:	5b                   	pop    %ebx
 389:	5e                   	pop    %esi
 38a:	5f                   	pop    %edi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
 38d:	90                   	nop
 38e:	90                   	nop
 38f:	90                   	nop

00000390 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 390:	b8 01 00 00 00       	mov    $0x1,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <exit>:
SYSCALL(exit)
 398:	b8 02 00 00 00       	mov    $0x2,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <wait>:
SYSCALL(wait)
 3a0:	b8 03 00 00 00       	mov    $0x3,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <wait2>:
SYSCALL(wait2)
 3a8:	b8 16 00 00 00       	mov    $0x16,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <pipe>:
SYSCALL(pipe)
 3b0:	b8 04 00 00 00       	mov    $0x4,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <read>:
SYSCALL(read)
 3b8:	b8 06 00 00 00       	mov    $0x6,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <write>:
SYSCALL(write)
 3c0:	b8 05 00 00 00       	mov    $0x5,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <close>:
SYSCALL(close)
 3c8:	b8 07 00 00 00       	mov    $0x7,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <kill>:
SYSCALL(kill)
 3d0:	b8 08 00 00 00       	mov    $0x8,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <exec>:
SYSCALL(exec)
 3d8:	b8 09 00 00 00       	mov    $0x9,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <open>:
SYSCALL(open)
 3e0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mknod>:
SYSCALL(mknod)
 3e8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <unlink>:
SYSCALL(unlink)
 3f0:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <fstat>:
SYSCALL(fstat)
 3f8:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <link>:
SYSCALL(link)
 400:	b8 0e 00 00 00       	mov    $0xe,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <mkdir>:
SYSCALL(mkdir)
 408:	b8 0f 00 00 00       	mov    $0xf,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <chdir>:
SYSCALL(chdir)
 410:	b8 10 00 00 00       	mov    $0x10,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <dup>:
SYSCALL(dup)
 418:	b8 11 00 00 00       	mov    $0x11,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getpid>:
SYSCALL(getpid)
 420:	b8 12 00 00 00       	mov    $0x12,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <sbrk>:
SYSCALL(sbrk)
 428:	b8 13 00 00 00       	mov    $0x13,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sleep>:
SYSCALL(sleep)
 430:	b8 14 00 00 00       	mov    $0x14,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <uptime>:
SYSCALL(uptime)
 438:	b8 15 00 00 00       	mov    $0x15,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <nice>:
SYSCALL(nice)
 440:	b8 17 00 00 00       	mov    $0x17,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    
 448:	90                   	nop
 449:	90                   	nop
 44a:	90                   	nop
 44b:	90                   	nop
 44c:	90                   	nop
 44d:	90                   	nop
 44e:	90                   	nop
 44f:	90                   	nop

00000450 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	89 cf                	mov    %ecx,%edi
 456:	56                   	push   %esi
 457:	89 c6                	mov    %eax,%esi
 459:	53                   	push   %ebx
 45a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 460:	85 c9                	test   %ecx,%ecx
 462:	74 04                	je     468 <printint+0x18>
 464:	85 d2                	test   %edx,%edx
 466:	78 70                	js     4d8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 468:	89 d0                	mov    %edx,%eax
 46a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 471:	31 c9                	xor    %ecx,%ecx
 473:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 476:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 478:	31 d2                	xor    %edx,%edx
 47a:	f7 f7                	div    %edi
 47c:	0f b6 92 89 08 00 00 	movzbl 0x889(%edx),%edx
 483:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 486:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 489:	85 c0                	test   %eax,%eax
 48b:	75 eb                	jne    478 <printint+0x28>
  if(neg)
 48d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 490:	85 c0                	test   %eax,%eax
 492:	74 08                	je     49c <printint+0x4c>
    buf[i++] = '-';
 494:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 499:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 49c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 49f:	01 fb                	add    %edi,%ebx
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4a8:	0f b6 03             	movzbl (%ebx),%eax
 4ab:	83 ef 01             	sub    $0x1,%edi
 4ae:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b8:	00 
 4b9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4bc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4bf:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c6:	e8 f5 fe ff ff       	call   3c0 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4cb:	83 ff ff             	cmp    $0xffffffff,%edi
 4ce:	75 d8                	jne    4a8 <printint+0x58>
    putc(fd, buf[i]);
}
 4d0:	83 c4 4c             	add    $0x4c,%esp
 4d3:	5b                   	pop    %ebx
 4d4:	5e                   	pop    %esi
 4d5:	5f                   	pop    %edi
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4d8:	89 d0                	mov    %edx,%eax
 4da:	f7 d8                	neg    %eax
 4dc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4e3:	eb 8c                	jmp    471 <printint+0x21>
 4e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004f0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	0f b6 10             	movzbl (%eax),%edx
 4ff:	84 d2                	test   %dl,%dl
 501:	0f 84 c9 00 00 00    	je     5d0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 507:	8d 4d 10             	lea    0x10(%ebp),%ecx
 50a:	31 ff                	xor    %edi,%edi
 50c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 50f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 511:	8d 75 e7             	lea    -0x19(%ebp),%esi
 514:	eb 1e                	jmp    534 <printf+0x44>
 516:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 518:	83 fa 25             	cmp    $0x25,%edx
 51b:	0f 85 b7 00 00 00    	jne    5d8 <printf+0xe8>
 521:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 525:	83 c3 01             	add    $0x1,%ebx
 528:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 52c:	84 d2                	test   %dl,%dl
 52e:	0f 84 9c 00 00 00    	je     5d0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 534:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 536:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 539:	74 dd                	je     518 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 53b:	83 ff 25             	cmp    $0x25,%edi
 53e:	75 e5                	jne    525 <printf+0x35>
      if(c == 'd'){
 540:	83 fa 64             	cmp    $0x64,%edx
 543:	0f 84 57 01 00 00    	je     6a0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 549:	83 fa 70             	cmp    $0x70,%edx
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 550:	0f 84 aa 00 00 00    	je     600 <printf+0x110>
 556:	83 fa 78             	cmp    $0x78,%edx
 559:	0f 84 a1 00 00 00    	je     600 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 55f:	83 fa 73             	cmp    $0x73,%edx
 562:	0f 84 c0 00 00 00    	je     628 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 568:	83 fa 63             	cmp    $0x63,%edx
 56b:	90                   	nop
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 570:	0f 84 52 01 00 00    	je     6c8 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 576:	83 fa 25             	cmp    $0x25,%edx
 579:	0f 84 f9 00 00 00    	je     678 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 57f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 582:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 585:	31 ff                	xor    %edi,%edi
 587:	89 55 cc             	mov    %edx,-0x34(%ebp)
 58a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 58e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 595:	00 
 596:	89 0c 24             	mov    %ecx,(%esp)
 599:	89 74 24 04          	mov    %esi,0x4(%esp)
 59d:	e8 1e fe ff ff       	call   3c0 <write>
 5a2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5af:	00 
 5b0:	89 74 24 04          	mov    %esi,0x4(%esp)
 5b4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5b7:	89 04 24             	mov    %eax,(%esp)
 5ba:	e8 01 fe ff ff       	call   3c0 <write>
 5bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5c2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 5c6:	84 d2                	test   %dl,%dl
 5c8:	0f 85 66 ff ff ff    	jne    534 <printf+0x44>
 5ce:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d0:	83 c4 3c             	add    $0x3c,%esp
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5db:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e5:	00 
 5e6:	89 74 24 04          	mov    %esi,0x4(%esp)
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 ce fd ff ff       	call   3c0 <write>
 5f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f5:	e9 2b ff ff ff       	jmp    525 <printf+0x35>
 5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 603:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 608:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 60a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 611:	8b 10                	mov    (%eax),%edx
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	e8 35 fe ff ff       	call   450 <printint>
 61b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 61e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 622:	e9 fe fe ff ff       	jmp    525 <printf+0x35>
 627:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 628:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 62b:	8b 3a                	mov    (%edx),%edi
        ap++;
 62d:	83 c2 04             	add    $0x4,%edx
 630:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 633:	85 ff                	test   %edi,%edi
 635:	0f 84 ba 00 00 00    	je     6f5 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 63b:	0f b6 17             	movzbl (%edi),%edx
 63e:	84 d2                	test   %dl,%dl
 640:	74 2d                	je     66f <printf+0x17f>
 642:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 645:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 648:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 655:	00 
 656:	89 74 24 04          	mov    %esi,0x4(%esp)
 65a:	89 1c 24             	mov    %ebx,(%esp)
 65d:	e8 5e fd ff ff       	call   3c0 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 662:	0f b6 17             	movzbl (%edi),%edx
 665:	84 d2                	test   %dl,%dl
 667:	75 df                	jne    648 <printf+0x158>
 669:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 66c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66f:	31 ff                	xor    %edi,%edi
 671:	e9 af fe ff ff       	jmp    525 <printf+0x35>
 676:	66 90                	xchg   %ax,%ax
 678:	8b 55 08             	mov    0x8(%ebp),%edx
 67b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 67d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 681:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 688:	00 
 689:	89 74 24 04          	mov    %esi,0x4(%esp)
 68d:	89 14 24             	mov    %edx,(%esp)
 690:	e8 2b fd ff ff       	call   3c0 <write>
 695:	8b 45 0c             	mov    0xc(%ebp),%eax
 698:	e9 88 fe ff ff       	jmp    525 <printf+0x35>
 69d:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 6a8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	e8 94 fd ff ff       	call   450 <printint>
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 6bf:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6c3:	e9 5d fe ff ff       	jmp    525 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 6cb:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cd:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6d6:	00 
 6d7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6db:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 d7 fc ff ff       	call   3c0 <write>
 6e9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6ec:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6f0:	e9 30 fe ff ff       	jmp    525 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 6f5:	bf 82 08 00 00       	mov    $0x882,%edi
 6fa:	e9 3c ff ff ff       	jmp    63b <printf+0x14b>
 6ff:	90                   	nop

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 a4 08 00 00       	mov    0x8a4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 70e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 711:	39 c8                	cmp    %ecx,%eax
 713:	73 1d                	jae    732 <free+0x32>
 715:	8d 76 00             	lea    0x0(%esi),%esi
 718:	8b 10                	mov    (%eax),%edx
 71a:	39 d1                	cmp    %edx,%ecx
 71c:	72 1a                	jb     738 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71e:	39 d0                	cmp    %edx,%eax
 720:	72 08                	jb     72a <free+0x2a>
 722:	39 c8                	cmp    %ecx,%eax
 724:	72 12                	jb     738 <free+0x38>
 726:	39 d1                	cmp    %edx,%ecx
 728:	72 0e                	jb     738 <free+0x38>
 72a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	39 c8                	cmp    %ecx,%eax
 72e:	66 90                	xchg   %ax,%ax
 730:	72 e6                	jb     718 <free+0x18>
 732:	8b 10                	mov    (%eax),%edx
 734:	eb e8                	jmp    71e <free+0x1e>
 736:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 738:	8b 71 04             	mov    0x4(%ecx),%esi
 73b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 73e:	39 d7                	cmp    %edx,%edi
 740:	74 19                	je     75b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 742:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 745:	8b 50 04             	mov    0x4(%eax),%edx
 748:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 74b:	39 ce                	cmp    %ecx,%esi
 74d:	74 23                	je     772 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 74f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 751:	a3 a4 08 00 00       	mov    %eax,0x8a4
}
 756:	5b                   	pop    %ebx
 757:	5e                   	pop    %esi
 758:	5f                   	pop    %edi
 759:	5d                   	pop    %ebp
 75a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75b:	03 72 04             	add    0x4(%edx),%esi
 75e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 12                	mov    (%edx),%edx
 765:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 768:	8b 50 04             	mov    0x4(%eax),%edx
 76b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76e:	39 ce                	cmp    %ecx,%esi
 770:	75 dd                	jne    74f <free+0x4f>
    p->s.size += bp->s.size;
 772:	03 51 04             	add    0x4(%ecx),%edx
 775:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 778:	8b 53 f8             	mov    -0x8(%ebx),%edx
 77b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 77d:	a3 a4 08 00 00       	mov    %eax,0x8a4
}
 782:	5b                   	pop    %ebx
 783:	5e                   	pop    %esi
 784:	5f                   	pop    %edi
 785:	5d                   	pop    %ebp
 786:	c3                   	ret    
 787:	89 f6                	mov    %esi,%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 79c:	8b 0d a4 08 00 00    	mov    0x8a4,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	83 c3 07             	add    $0x7,%ebx
 7a5:	c1 eb 03             	shr    $0x3,%ebx
 7a8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7ab:	85 c9                	test   %ecx,%ecx
 7ad:	0f 84 93 00 00 00    	je     846 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 7b5:	8b 50 04             	mov    0x4(%eax),%edx
 7b8:	39 d3                	cmp    %edx,%ebx
 7ba:	76 1f                	jbe    7db <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 7bc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7c3:	90                   	nop
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 7c8:	3b 05 a4 08 00 00    	cmp    0x8a4,%eax
 7ce:	74 30                	je     800 <malloc+0x70>
 7d0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 7d4:	8b 50 04             	mov    0x4(%eax),%edx
 7d7:	39 d3                	cmp    %edx,%ebx
 7d9:	77 ed                	ja     7c8 <malloc+0x38>
      if(p->s.size == nunits)
 7db:	39 d3                	cmp    %edx,%ebx
 7dd:	74 61                	je     840 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7df:	29 da                	sub    %ebx,%edx
 7e1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 7e7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7ea:	89 0d a4 08 00 00    	mov    %ecx,0x8a4
      return (void*) (p + 1);
 7f0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f3:	83 c4 1c             	add    $0x1c,%esp
 7f6:	5b                   	pop    %ebx
 7f7:	5e                   	pop    %esi
 7f8:	5f                   	pop    %edi
 7f9:	5d                   	pop    %ebp
 7fa:	c3                   	ret    
 7fb:	90                   	nop
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 800:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 806:	b8 00 80 00 00       	mov    $0x8000,%eax
 80b:	bf 00 10 00 00       	mov    $0x1000,%edi
 810:	76 04                	jbe    816 <malloc+0x86>
 812:	89 f0                	mov    %esi,%eax
 814:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 816:	89 04 24             	mov    %eax,(%esp)
 819:	e8 0a fc ff ff       	call   428 <sbrk>
  if(p == (char*) -1)
 81e:	83 f8 ff             	cmp    $0xffffffff,%eax
 821:	74 18                	je     83b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 823:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 826:	83 c0 08             	add    $0x8,%eax
 829:	89 04 24             	mov    %eax,(%esp)
 82c:	e8 cf fe ff ff       	call   700 <free>
  return freep;
 831:	8b 0d a4 08 00 00    	mov    0x8a4,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 837:	85 c9                	test   %ecx,%ecx
 839:	75 97                	jne    7d2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 83b:	31 c0                	xor    %eax,%eax
 83d:	eb b4                	jmp    7f3 <malloc+0x63>
 83f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 840:	8b 10                	mov    (%eax),%edx
 842:	89 11                	mov    %edx,(%ecx)
 844:	eb a4                	jmp    7ea <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 846:	c7 05 a4 08 00 00 9c 	movl   $0x89c,0x8a4
 84d:	08 00 00 
    base.s.size = 0;
 850:	b9 9c 08 00 00       	mov    $0x89c,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 855:	c7 05 9c 08 00 00 9c 	movl   $0x89c,0x89c
 85c:	08 00 00 
    base.s.size = 0;
 85f:	c7 05 a0 08 00 00 00 	movl   $0x0,0x8a0
 866:	00 00 00 
 869:	e9 45 ff ff ff       	jmp    7b3 <malloc+0x23>
