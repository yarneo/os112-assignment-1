
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	31 ff                	xor    %edi,%edi
   6:	56                   	push   %esi
   7:	31 f6                	xor    %esi,%esi
   9:	53                   	push   %ebx
   a:	83 ec 3c             	sub    $0x3c,%esp
   d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1b:	90                   	nop
  1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	8b 45 08             	mov    0x8(%ebp),%eax
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 20 0a 00 	movl   $0xa20,0x4(%esp)
  32:	00 
  33:	89 04 24             	mov    %eax,(%esp)
  36:	e8 bd 04 00 00       	call   4f8 <read>
  3b:	83 f8 00             	cmp    $0x0,%eax
  3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  41:	7e 4f                	jle    92 <wc+0x92>
  43:	31 db                	xor    %ebx,%ebx
  45:	eb 0b                	jmp    52 <wc+0x52>
  47:	90                   	nop
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	31 ff                	xor    %edi,%edi
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  4a:	83 c3 01             	add    $0x1,%ebx
  4d:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  50:	7e 38                	jle    8a <wc+0x8a>
      c++;
      if(buf[i] == '\n')
  52:	0f be 83 20 0a 00 00 	movsbl 0xa20(%ebx),%eax
        l++;
  59:	31 d2                	xor    %edx,%edx
      if(strchr(" \r\t\n\v", buf[i]))
  5b:	c7 04 24 ae 09 00 00 	movl   $0x9ae,(%esp)
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
  62:	3c 0a                	cmp    $0xa,%al
  64:	0f 94 c2             	sete   %dl
  67:	01 d6                	add    %edx,%esi
      if(strchr(" \r\t\n\v", buf[i]))
  69:	89 44 24 04          	mov    %eax,0x4(%esp)
  6d:	e8 ee 01 00 00       	call   260 <strchr>
  72:	85 c0                	test   %eax,%eax
  74:	75 d2                	jne    48 <wc+0x48>
        inword = 0;
      else if(!inword){
  76:	85 ff                	test   %edi,%edi
  78:	75 d0                	jne    4a <wc+0x4a>
        w++;
  7a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7e:	83 c3 01             	add    $0x1,%ebx
  81:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
        w++;
  84:	66 bf 01 00          	mov    $0x1,%di
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  88:	7f c8                	jg     52 <wc+0x52>
  8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8d:	01 45 dc             	add    %eax,-0x24(%ebp)
  90:	eb 8e                	jmp    20 <wc+0x20>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  92:	75 35                	jne    c9 <wc+0xc9>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	89 74 24 08          	mov    %esi,0x8(%esp)
  9b:	c7 44 24 04 c4 09 00 	movl   $0x9c4,0x4(%esp)
  a2:	00 
  a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  aa:	89 44 24 14          	mov    %eax,0x14(%esp)
  ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  bc:	e8 6f 05 00 00       	call   630 <printf>
}
  c1:	83 c4 3c             	add    $0x3c,%esp
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5f                   	pop    %edi
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
        inword = 1;
      }
    }
  }
  if(n < 0){
    printf(1, "wc: read error\n");
  c9:	c7 44 24 04 b4 09 00 	movl   $0x9b4,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d8:	e8 53 05 00 00       	call   630 <printf>
    exit();
  dd:	e8 f6 03 00 00       	call   4d8 <exit>
  e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000f0 <main>:
  printf(1, "%d %d %d %s\n", l, w, c, name);
}

int
main(int argc, char *argv[])
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	83 e4 f0             	and    $0xfffffff0,%esp
  f6:	57                   	push   %edi
  f7:	56                   	push   %esi
  f8:	53                   	push   %ebx
  f9:	83 ec 24             	sub    $0x24,%esp
  fc:	8b 7d 08             	mov    0x8(%ebp),%edi
  int fd, i;

  if(argc <= 1){
  ff:	83 ff 01             	cmp    $0x1,%edi
 102:	7e 74                	jle    178 <main+0x88>
    wc(0, "");
    exit();
 104:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 107:	be 01 00 00 00       	mov    $0x1,%esi
 10c:	83 c3 04             	add    $0x4,%ebx
 10f:	90                   	nop
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 110:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 117:	00 
 118:	8b 03                	mov    (%ebx),%eax
 11a:	89 04 24             	mov    %eax,(%esp)
 11d:	e8 fe 03 00 00       	call   520 <open>
 122:	85 c0                	test   %eax,%eax
 124:	78 32                	js     158 <main+0x68>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 126:	8b 13                	mov    (%ebx),%edx
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 128:	83 c6 01             	add    $0x1,%esi
 12b:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 12e:	89 04 24             	mov    %eax,(%esp)
 131:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 135:	89 54 24 04          	mov    %edx,0x4(%esp)
 139:	e8 c2 fe ff ff       	call   0 <wc>
    close(fd);
 13e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 142:	89 04 24             	mov    %eax,(%esp)
 145:	e8 be 03 00 00       	call   508 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 14a:	39 f7                	cmp    %esi,%edi
 14c:	7f c2                	jg     110 <main+0x20>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 14e:	e8 85 03 00 00       	call   4d8 <exit>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
 158:	8b 03                	mov    (%ebx),%eax
 15a:	c7 44 24 04 d1 09 00 	movl   $0x9d1,0x4(%esp)
 161:	00 
 162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 169:	89 44 24 08          	mov    %eax,0x8(%esp)
 16d:	e8 be 04 00 00       	call   630 <printf>
      exit();
 172:	e8 61 03 00 00       	call   4d8 <exit>
 177:	90                   	nop
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    wc(0, "");
 178:	c7 44 24 04 c3 09 00 	movl   $0x9c3,0x4(%esp)
 17f:	00 
 180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 187:	e8 74 fe ff ff       	call   0 <wc>
    exit();
 18c:	e8 47 03 00 00       	call   4d8 <exit>
 191:	90                   	nop
 192:	90                   	nop
 193:	90                   	nop
 194:	90                   	nop
 195:	90                   	nop
 196:	90                   	nop
 197:	90                   	nop
 198:	90                   	nop
 199:	90                   	nop
 19a:	90                   	nop
 19b:	90                   	nop
 19c:	90                   	nop
 19d:	90                   	nop
 19e:	90                   	nop
 19f:	90                   	nop

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	31 d2                	xor    %edx,%edx
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	53                   	push   %ebx
 1a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 1b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	84 c9                	test   %cl,%cl
 1bc:	75 f2                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1be:	5b                   	pop    %ebx
 1bf:	5d                   	pop    %ebp
 1c0:	c3                   	ret    
 1c1:	eb 0d                	jmp    1d0 <strcmp>
 1c3:	90                   	nop
 1c4:	90                   	nop
 1c5:	90                   	nop
 1c6:	90                   	nop
 1c7:	90                   	nop
 1c8:	90                   	nop
 1c9:	90                   	nop
 1ca:	90                   	nop
 1cb:	90                   	nop
 1cc:	90                   	nop
 1cd:	90                   	nop
 1ce:	90                   	nop
 1cf:	90                   	nop

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1da:	0f b6 01             	movzbl (%ecx),%eax
 1dd:	84 c0                	test   %al,%al
 1df:	75 14                	jne    1f5 <strcmp+0x25>
 1e1:	eb 25                	jmp    208 <strcmp+0x38>
 1e3:	90                   	nop
 1e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 1e8:	83 c1 01             	add    $0x1,%ecx
 1eb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ee:	0f b6 01             	movzbl (%ecx),%eax
 1f1:	84 c0                	test   %al,%al
 1f3:	74 13                	je     208 <strcmp+0x38>
 1f5:	0f b6 1a             	movzbl (%edx),%ebx
 1f8:	38 d8                	cmp    %bl,%al
 1fa:	74 ec                	je     1e8 <strcmp+0x18>
 1fc:	0f b6 db             	movzbl %bl,%ebx
 1ff:	0f b6 c0             	movzbl %al,%eax
 202:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 204:	5b                   	pop    %ebx
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 208:	0f b6 1a             	movzbl (%edx),%ebx
 20b:	31 c0                	xor    %eax,%eax
 20d:	0f b6 db             	movzbl %bl,%ebx
 210:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 212:	5b                   	pop    %ebx
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strlen>:

uint
strlen(char *s)
{
 220:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 221:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 223:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 225:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 227:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 22a:	80 39 00             	cmpb   $0x0,(%ecx)
 22d:	74 0c                	je     23b <strlen+0x1b>
 22f:	90                   	nop
 230:	83 c2 01             	add    $0x1,%edx
 233:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 237:	89 d0                	mov    %edx,%eax
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi

00000240 <memset>:

void*
memset(void *dst, int c, uint n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 55 08             	mov    0x8(%ebp),%edx
 246:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 247:	8b 4d 10             	mov    0x10(%ebp),%ecx
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 d7                	mov    %edx,%edi
 24f:	fc                   	cld    
 250:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 252:	89 d0                	mov    %edx,%eax
 254:	5f                   	pop    %edi
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <strchr>:

char*
strchr(const char *s, char c)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 26a:	0f b6 10             	movzbl (%eax),%edx
 26d:	84 d2                	test   %dl,%dl
 26f:	75 11                	jne    282 <strchr+0x22>
 271:	eb 15                	jmp    288 <strchr+0x28>
 273:	90                   	nop
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 278:	83 c0 01             	add    $0x1,%eax
 27b:	0f b6 10             	movzbl (%eax),%edx
 27e:	84 d2                	test   %dl,%dl
 280:	74 06                	je     288 <strchr+0x28>
    if(*s == c)
 282:	38 ca                	cmp    %cl,%dl
 284:	75 f2                	jne    278 <strchr+0x18>
      return (char*) s;
  return 0;
}
 286:	5d                   	pop    %ebp
 287:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 288:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 28a:	5d                   	pop    %ebp
 28b:	90                   	nop
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 290:	c3                   	ret    
 291:	eb 0d                	jmp    2a0 <atoi>
 293:	90                   	nop
 294:	90                   	nop
 295:	90                   	nop
 296:	90                   	nop
 297:	90                   	nop
 298:	90                   	nop
 299:	90                   	nop
 29a:	90                   	nop
 29b:	90                   	nop
 29c:	90                   	nop
 29d:	90                   	nop
 29e:	90                   	nop
 29f:	90                   	nop

000002a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2a8:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a9:	0f b6 11             	movzbl (%ecx),%edx
 2ac:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2af:	80 fb 09             	cmp    $0x9,%bl
 2b2:	77 1c                	ja     2d0 <atoi+0x30>
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 2b8:	0f be d2             	movsbl %dl,%edx
 2bb:	83 c1 01             	add    $0x1,%ecx
 2be:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2c1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c5:	0f b6 11             	movzbl (%ecx),%edx
 2c8:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2cb:	80 fb 09             	cmp    $0x9,%bl
 2ce:	76 e8                	jbe    2b8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2d0:	5b                   	pop    %ebx
 2d1:	5d                   	pop    %ebp
 2d2:	c3                   	ret    
 2d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	56                   	push   %esi
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	53                   	push   %ebx
 2e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ee:	85 db                	test   %ebx,%ebx
 2f0:	7e 14                	jle    306 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 2f2:	31 d2                	xor    %edx,%edx
 2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 2f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ff:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 302:	39 da                	cmp    %ebx,%edx
 304:	75 f2                	jne    2f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 306:	5b                   	pop    %ebx
 307:	5e                   	pop    %esi
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000310 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 08             	mov    0x8(%ebp),%ecx
 316:	57                   	push   %edi
 317:	56                   	push   %esi
 318:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 319:	80 39 00             	cmpb   $0x0,(%ecx)
 31c:	74 37                	je     355 <reverse+0x45>
 31e:	31 d2                	xor    %edx,%edx
 320:	83 c2 01             	add    $0x1,%edx
 323:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 327:	75 f7                	jne    320 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 329:	8d 7a ff             	lea    -0x1(%edx),%edi
 32c:	85 ff                	test   %edi,%edi
 32e:	7e 25                	jle    355 <reverse+0x45>
 330:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 333:	31 c0                	xor    %eax,%eax
 335:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 338:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 33c:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 33f:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 343:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 346:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 348:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 34b:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 34e:	83 ea 01             	sub    $0x1,%edx
 351:	39 f8                	cmp    %edi,%eax
 353:	7c e3                	jl     338 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 355:	5b                   	pop    %ebx
 356:	5e                   	pop    %esi
 357:	5f                   	pop    %edi
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000360 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 364:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 369:	56                   	push   %esi
 36a:	53                   	push   %ebx
 36b:	31 db                	xor    %ebx,%ebx
 36d:	83 ec 04             	sub    $0x4,%esp
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	8b 75 0c             	mov    0xc(%ebp),%esi
 376:	89 45 f0             	mov    %eax,-0x10(%ebp)
 379:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 37c:	c1 f8 1f             	sar    $0x1f,%eax
 37f:	31 c1                	xor    %eax,%ecx
 381:	29 c1                	sub    %eax,%ecx
 383:	90                   	nop
 384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 388:	89 c8                	mov    %ecx,%eax
 38a:	f7 ef                	imul   %edi
 38c:	89 c8                	mov    %ecx,%eax
 38e:	c1 f8 1f             	sar    $0x1f,%eax
 391:	c1 fa 02             	sar    $0x2,%edx
 394:	29 c2                	sub    %eax,%edx
 396:	8d 04 92             	lea    (%edx,%edx,4),%eax
 399:	01 c0                	add    %eax,%eax
 39b:	29 c1                	sub    %eax,%ecx
 39d:	83 c1 30             	add    $0x30,%ecx
 3a0:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 3a3:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 3a6:	85 d2                	test   %edx,%edx
 3a8:	89 d1                	mov    %edx,%ecx
 3aa:	7f dc                	jg     388 <itoa+0x28>
     if (sign < 0)
 3ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 3af:	85 c0                	test   %eax,%eax
 3b1:	79 07                	jns    3ba <itoa+0x5a>
         s[i++] = '-';
 3b3:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 3b7:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 3ba:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 3be:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 3c1:	83 c4 04             	add    $0x4,%esp
 3c4:	5b                   	pop    %ebx
 3c5:	5e                   	pop    %esi
 3c6:	5f                   	pop    %edi
 3c7:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 3c8:	e9 43 ff ff ff       	jmp    310 <reverse>
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 3d0:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3d1:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	57                   	push   %edi
 3d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
 3dc:	56                   	push   %esi
 3dd:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3de:	31 db                	xor    %ebx,%ebx
 3e0:	80 38 00             	cmpb   $0x0,(%eax)
 3e3:	74 0e                	je     3f3 <strcat+0x23>
 3e5:	8d 76 00             	lea    0x0(%esi),%esi
 3e8:	83 c2 01             	add    $0x1,%edx
 3eb:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 3ef:	75 f7                	jne    3e8 <strcat+0x18>
 3f1:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 3f3:	0f b6 0f             	movzbl (%edi),%ecx
 3f6:	84 c9                	test   %cl,%cl
 3f8:	74 18                	je     412 <strcat+0x42>
 3fa:	8d 34 10             	lea    (%eax,%edx,1),%esi
 3fd:	31 db                	xor    %ebx,%ebx
 3ff:	90                   	nop
 400:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 403:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 405:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 409:	83 c6 01             	add    $0x1,%esi
 40c:	84 c9                	test   %cl,%cl
 40e:	75 f0                	jne    400 <strcat+0x30>
 410:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 412:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 416:	5b                   	pop    %ebx
 417:	5e                   	pop    %esi
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    
 41b:	90                   	nop
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000420 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 426:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 429:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 42c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 42f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 434:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 43b:	00 
 43c:	89 04 24             	mov    %eax,(%esp)
 43f:	e8 dc 00 00 00       	call   520 <open>
  if(fd < 0)
 444:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 446:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 448:	78 19                	js     463 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 44a:	8b 45 0c             	mov    0xc(%ebp),%eax
 44d:	89 1c 24             	mov    %ebx,(%esp)
 450:	89 44 24 04          	mov    %eax,0x4(%esp)
 454:	e8 df 00 00 00       	call   538 <fstat>
  close(fd);
 459:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 45c:	89 c6                	mov    %eax,%esi
  close(fd);
 45e:	e8 a5 00 00 00       	call   508 <close>
  return r;
}
 463:	89 f0                	mov    %esi,%eax
 465:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 468:	8b 75 fc             	mov    -0x4(%ebp),%esi
 46b:	89 ec                	mov    %ebp,%esp
 46d:	5d                   	pop    %ebp
 46e:	c3                   	ret    
 46f:	90                   	nop

00000470 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	31 f6                	xor    %esi,%esi
 477:	53                   	push   %ebx
 478:	83 ec 2c             	sub    $0x2c,%esp
 47b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47e:	eb 06                	jmp    486 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 480:	3c 0a                	cmp    $0xa,%al
 482:	74 39                	je     4bd <gets+0x4d>
 484:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 486:	8d 5e 01             	lea    0x1(%esi),%ebx
 489:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 48c:	7d 31                	jge    4bf <gets+0x4f>
    cc = read(0, &c, 1);
 48e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 491:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 498:	00 
 499:	89 44 24 04          	mov    %eax,0x4(%esp)
 49d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a4:	e8 4f 00 00 00       	call   4f8 <read>
    if(cc < 1)
 4a9:	85 c0                	test   %eax,%eax
 4ab:	7e 12                	jle    4bf <gets+0x4f>
      break;
    buf[i++] = c;
 4ad:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4b1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 4b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4b9:	3c 0d                	cmp    $0xd,%al
 4bb:	75 c3                	jne    480 <gets+0x10>
 4bd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 4bf:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 4c3:	89 f8                	mov    %edi,%eax
 4c5:	83 c4 2c             	add    $0x2c,%esp
 4c8:	5b                   	pop    %ebx
 4c9:	5e                   	pop    %esi
 4ca:	5f                   	pop    %edi
 4cb:	5d                   	pop    %ebp
 4cc:	c3                   	ret    
 4cd:	90                   	nop
 4ce:	90                   	nop
 4cf:	90                   	nop

000004d0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d0:	b8 01 00 00 00       	mov    $0x1,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <exit>:
SYSCALL(exit)
 4d8:	b8 02 00 00 00       	mov    $0x2,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <wait>:
SYSCALL(wait)
 4e0:	b8 03 00 00 00       	mov    $0x3,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <wait2>:
SYSCALL(wait2)
 4e8:	b8 16 00 00 00       	mov    $0x16,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <pipe>:
SYSCALL(pipe)
 4f0:	b8 04 00 00 00       	mov    $0x4,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <read>:
SYSCALL(read)
 4f8:	b8 06 00 00 00       	mov    $0x6,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <write>:
SYSCALL(write)
 500:	b8 05 00 00 00       	mov    $0x5,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <close>:
SYSCALL(close)
 508:	b8 07 00 00 00       	mov    $0x7,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <kill>:
SYSCALL(kill)
 510:	b8 08 00 00 00       	mov    $0x8,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <exec>:
SYSCALL(exec)
 518:	b8 09 00 00 00       	mov    $0x9,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <open>:
SYSCALL(open)
 520:	b8 0a 00 00 00       	mov    $0xa,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <mknod>:
SYSCALL(mknod)
 528:	b8 0b 00 00 00       	mov    $0xb,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <unlink>:
SYSCALL(unlink)
 530:	b8 0c 00 00 00       	mov    $0xc,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <fstat>:
SYSCALL(fstat)
 538:	b8 0d 00 00 00       	mov    $0xd,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <link>:
SYSCALL(link)
 540:	b8 0e 00 00 00       	mov    $0xe,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <mkdir>:
SYSCALL(mkdir)
 548:	b8 0f 00 00 00       	mov    $0xf,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <chdir>:
SYSCALL(chdir)
 550:	b8 10 00 00 00       	mov    $0x10,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <dup>:
SYSCALL(dup)
 558:	b8 11 00 00 00       	mov    $0x11,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <getpid>:
SYSCALL(getpid)
 560:	b8 12 00 00 00       	mov    $0x12,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <sbrk>:
SYSCALL(sbrk)
 568:	b8 13 00 00 00       	mov    $0x13,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <sleep>:
SYSCALL(sleep)
 570:	b8 14 00 00 00       	mov    $0x14,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <uptime>:
SYSCALL(uptime)
 578:	b8 15 00 00 00       	mov    $0x15,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <nice>:
SYSCALL(nice)
 580:	b8 17 00 00 00       	mov    $0x17,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    
 588:	90                   	nop
 589:	90                   	nop
 58a:	90                   	nop
 58b:	90                   	nop
 58c:	90                   	nop
 58d:	90                   	nop
 58e:	90                   	nop
 58f:	90                   	nop

00000590 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	57                   	push   %edi
 594:	89 cf                	mov    %ecx,%edi
 596:	56                   	push   %esi
 597:	89 c6                	mov    %eax,%esi
 599:	53                   	push   %ebx
 59a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5a0:	85 c9                	test   %ecx,%ecx
 5a2:	74 04                	je     5a8 <printint+0x18>
 5a4:	85 d2                	test   %edx,%edx
 5a6:	78 70                	js     618 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5a8:	89 d0                	mov    %edx,%eax
 5aa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5b1:	31 c9                	xor    %ecx,%ecx
 5b3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5b6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 5b8:	31 d2                	xor    %edx,%edx
 5ba:	f7 f7                	div    %edi
 5bc:	0f b6 92 ed 09 00 00 	movzbl 0x9ed(%edx),%edx
 5c3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 5c6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 5c9:	85 c0                	test   %eax,%eax
 5cb:	75 eb                	jne    5b8 <printint+0x28>
  if(neg)
 5cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5d0:	85 c0                	test   %eax,%eax
 5d2:	74 08                	je     5dc <printint+0x4c>
    buf[i++] = '-';
 5d4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 5d9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 5dc:	8d 79 ff             	lea    -0x1(%ecx),%edi
 5df:	01 fb                	add    %edi,%ebx
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5e8:	0f b6 03             	movzbl (%ebx),%eax
 5eb:	83 ef 01             	sub    $0x1,%edi
 5ee:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f8:	00 
 5f9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5fc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ff:	8d 45 e7             	lea    -0x19(%ebp),%eax
 602:	89 44 24 04          	mov    %eax,0x4(%esp)
 606:	e8 f5 fe ff ff       	call   500 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 60b:	83 ff ff             	cmp    $0xffffffff,%edi
 60e:	75 d8                	jne    5e8 <printint+0x58>
    putc(fd, buf[i]);
}
 610:	83 c4 4c             	add    $0x4c,%esp
 613:	5b                   	pop    %ebx
 614:	5e                   	pop    %esi
 615:	5f                   	pop    %edi
 616:	5d                   	pop    %ebp
 617:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 618:	89 d0                	mov    %edx,%eax
 61a:	f7 d8                	neg    %eax
 61c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 623:	eb 8c                	jmp    5b1 <printint+0x21>
 625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000630 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 639:	8b 45 0c             	mov    0xc(%ebp),%eax
 63c:	0f b6 10             	movzbl (%eax),%edx
 63f:	84 d2                	test   %dl,%dl
 641:	0f 84 c9 00 00 00    	je     710 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 647:	8d 4d 10             	lea    0x10(%ebp),%ecx
 64a:	31 ff                	xor    %edi,%edi
 64c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 64f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 651:	8d 75 e7             	lea    -0x19(%ebp),%esi
 654:	eb 1e                	jmp    674 <printf+0x44>
 656:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 658:	83 fa 25             	cmp    $0x25,%edx
 65b:	0f 85 b7 00 00 00    	jne    718 <printf+0xe8>
 661:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 665:	83 c3 01             	add    $0x1,%ebx
 668:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 66c:	84 d2                	test   %dl,%dl
 66e:	0f 84 9c 00 00 00    	je     710 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 674:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 676:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 679:	74 dd                	je     658 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 67b:	83 ff 25             	cmp    $0x25,%edi
 67e:	75 e5                	jne    665 <printf+0x35>
      if(c == 'd'){
 680:	83 fa 64             	cmp    $0x64,%edx
 683:	0f 84 57 01 00 00    	je     7e0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 689:	83 fa 70             	cmp    $0x70,%edx
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 690:	0f 84 aa 00 00 00    	je     740 <printf+0x110>
 696:	83 fa 78             	cmp    $0x78,%edx
 699:	0f 84 a1 00 00 00    	je     740 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 69f:	83 fa 73             	cmp    $0x73,%edx
 6a2:	0f 84 c0 00 00 00    	je     768 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a8:	83 fa 63             	cmp    $0x63,%edx
 6ab:	90                   	nop
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6b0:	0f 84 52 01 00 00    	je     808 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6b6:	83 fa 25             	cmp    $0x25,%edx
 6b9:	0f 84 f9 00 00 00    	je     7b8 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c2:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6c5:	31 ff                	xor    %edi,%edi
 6c7:	89 55 cc             	mov    %edx,-0x34(%ebp)
 6ca:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6d5:	00 
 6d6:	89 0c 24             	mov    %ecx,(%esp)
 6d9:	89 74 24 04          	mov    %esi,0x4(%esp)
 6dd:	e8 1e fe ff ff       	call   500 <write>
 6e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ef:	00 
 6f0:	89 74 24 04          	mov    %esi,0x4(%esp)
 6f4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 01 fe ff ff       	call   500 <write>
 6ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 702:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 706:	84 d2                	test   %dl,%dl
 708:	0f 85 66 ff ff ff    	jne    674 <printf+0x44>
 70e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 710:	83 c4 3c             	add    $0x3c,%esp
 713:	5b                   	pop    %ebx
 714:	5e                   	pop    %esi
 715:	5f                   	pop    %edi
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 718:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 71b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 71e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 725:	00 
 726:	89 74 24 04          	mov    %esi,0x4(%esp)
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 ce fd ff ff       	call   500 <write>
 732:	8b 45 0c             	mov    0xc(%ebp),%eax
 735:	e9 2b ff ff ff       	jmp    665 <printf+0x35>
 73a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 740:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 743:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 748:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 74a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	e8 35 fe ff ff       	call   590 <printint>
 75b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 75e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 762:	e9 fe fe ff ff       	jmp    665 <printf+0x35>
 767:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 768:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 76b:	8b 3a                	mov    (%edx),%edi
        ap++;
 76d:	83 c2 04             	add    $0x4,%edx
 770:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 773:	85 ff                	test   %edi,%edi
 775:	0f 84 ba 00 00 00    	je     835 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 77b:	0f b6 17             	movzbl (%edi),%edx
 77e:	84 d2                	test   %dl,%dl
 780:	74 2d                	je     7af <printf+0x17f>
 782:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 785:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 788:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 78b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 78e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 795:	00 
 796:	89 74 24 04          	mov    %esi,0x4(%esp)
 79a:	89 1c 24             	mov    %ebx,(%esp)
 79d:	e8 5e fd ff ff       	call   500 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7a2:	0f b6 17             	movzbl (%edi),%edx
 7a5:	84 d2                	test   %dl,%dl
 7a7:	75 df                	jne    788 <printf+0x158>
 7a9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7ac:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7af:	31 ff                	xor    %edi,%edi
 7b1:	e9 af fe ff ff       	jmp    665 <printf+0x35>
 7b6:	66 90                	xchg   %ax,%ax
 7b8:	8b 55 08             	mov    0x8(%ebp),%edx
 7bb:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7bd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7c8:	00 
 7c9:	89 74 24 04          	mov    %esi,0x4(%esp)
 7cd:	89 14 24             	mov    %edx,(%esp)
 7d0:	e8 2b fd ff ff       	call   500 <write>
 7d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d8:	e9 88 fe ff ff       	jmp    665 <printf+0x35>
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 7e8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 7eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7f2:	8b 10                	mov    (%eax),%edx
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	e8 94 fd ff ff       	call   590 <printint>
 7fc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 7ff:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 803:	e9 5d fe ff ff       	jmp    665 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 808:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 80b:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 80d:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 80f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 816:	00 
 817:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 81b:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	89 04 24             	mov    %eax,(%esp)
 824:	e8 d7 fc ff ff       	call   500 <write>
 829:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 82c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 830:	e9 30 fe ff ff       	jmp    665 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 835:	bf e6 09 00 00       	mov    $0x9e6,%edi
 83a:	e9 3c ff ff ff       	jmp    77b <printf+0x14b>
 83f:	90                   	nop

00000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 841:	a1 08 0a 00 00       	mov    0xa08,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 846:	89 e5                	mov    %esp,%ebp
 848:	57                   	push   %edi
 849:	56                   	push   %esi
 84a:	53                   	push   %ebx
 84b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 84e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 851:	39 c8                	cmp    %ecx,%eax
 853:	73 1d                	jae    872 <free+0x32>
 855:	8d 76 00             	lea    0x0(%esi),%esi
 858:	8b 10                	mov    (%eax),%edx
 85a:	39 d1                	cmp    %edx,%ecx
 85c:	72 1a                	jb     878 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	39 d0                	cmp    %edx,%eax
 860:	72 08                	jb     86a <free+0x2a>
 862:	39 c8                	cmp    %ecx,%eax
 864:	72 12                	jb     878 <free+0x38>
 866:	39 d1                	cmp    %edx,%ecx
 868:	72 0e                	jb     878 <free+0x38>
 86a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	39 c8                	cmp    %ecx,%eax
 86e:	66 90                	xchg   %ax,%ax
 870:	72 e6                	jb     858 <free+0x18>
 872:	8b 10                	mov    (%eax),%edx
 874:	eb e8                	jmp    85e <free+0x1e>
 876:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 878:	8b 71 04             	mov    0x4(%ecx),%esi
 87b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 87e:	39 d7                	cmp    %edx,%edi
 880:	74 19                	je     89b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 882:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 885:	8b 50 04             	mov    0x4(%eax),%edx
 888:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 88b:	39 ce                	cmp    %ecx,%esi
 88d:	74 23                	je     8b2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 88f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 891:	a3 08 0a 00 00       	mov    %eax,0xa08
}
 896:	5b                   	pop    %ebx
 897:	5e                   	pop    %esi
 898:	5f                   	pop    %edi
 899:	5d                   	pop    %ebp
 89a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 89b:	03 72 04             	add    0x4(%edx),%esi
 89e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a1:	8b 10                	mov    (%eax),%edx
 8a3:	8b 12                	mov    (%edx),%edx
 8a5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8a8:	8b 50 04             	mov    0x4(%eax),%edx
 8ab:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8ae:	39 ce                	cmp    %ecx,%esi
 8b0:	75 dd                	jne    88f <free+0x4f>
    p->s.size += bp->s.size;
 8b2:	03 51 04             	add    0x4(%ecx),%edx
 8b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8b8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8bb:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 8bd:	a3 08 0a 00 00       	mov    %eax,0xa08
}
 8c2:	5b                   	pop    %ebx
 8c3:	5e                   	pop    %esi
 8c4:	5f                   	pop    %edi
 8c5:	5d                   	pop    %ebp
 8c6:	c3                   	ret    
 8c7:	89 f6                	mov    %esi,%esi
 8c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
 8d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 8dc:	8b 0d 08 0a 00 00    	mov    0xa08,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	83 c3 07             	add    $0x7,%ebx
 8e5:	c1 eb 03             	shr    $0x3,%ebx
 8e8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 8eb:	85 c9                	test   %ecx,%ecx
 8ed:	0f 84 93 00 00 00    	je     986 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 8f5:	8b 50 04             	mov    0x4(%eax),%edx
 8f8:	39 d3                	cmp    %edx,%ebx
 8fa:	76 1f                	jbe    91b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 8fc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 903:	90                   	nop
 904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 908:	3b 05 08 0a 00 00    	cmp    0xa08,%eax
 90e:	74 30                	je     940 <malloc+0x70>
 910:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 912:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 914:	8b 50 04             	mov    0x4(%eax),%edx
 917:	39 d3                	cmp    %edx,%ebx
 919:	77 ed                	ja     908 <malloc+0x38>
      if(p->s.size == nunits)
 91b:	39 d3                	cmp    %edx,%ebx
 91d:	74 61                	je     980 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 91f:	29 da                	sub    %ebx,%edx
 921:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 924:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 927:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 92a:	89 0d 08 0a 00 00    	mov    %ecx,0xa08
      return (void*) (p + 1);
 930:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 933:	83 c4 1c             	add    $0x1c,%esp
 936:	5b                   	pop    %ebx
 937:	5e                   	pop    %esi
 938:	5f                   	pop    %edi
 939:	5d                   	pop    %ebp
 93a:	c3                   	ret    
 93b:	90                   	nop
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 940:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 946:	b8 00 80 00 00       	mov    $0x8000,%eax
 94b:	bf 00 10 00 00       	mov    $0x1000,%edi
 950:	76 04                	jbe    956 <malloc+0x86>
 952:	89 f0                	mov    %esi,%eax
 954:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 956:	89 04 24             	mov    %eax,(%esp)
 959:	e8 0a fc ff ff       	call   568 <sbrk>
  if(p == (char*) -1)
 95e:	83 f8 ff             	cmp    $0xffffffff,%eax
 961:	74 18                	je     97b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 963:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 966:	83 c0 08             	add    $0x8,%eax
 969:	89 04 24             	mov    %eax,(%esp)
 96c:	e8 cf fe ff ff       	call   840 <free>
  return freep;
 971:	8b 0d 08 0a 00 00    	mov    0xa08,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 977:	85 c9                	test   %ecx,%ecx
 979:	75 97                	jne    912 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 97b:	31 c0                	xor    %eax,%eax
 97d:	eb b4                	jmp    933 <malloc+0x63>
 97f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 980:	8b 10                	mov    (%eax),%edx
 982:	89 11                	mov    %edx,(%ecx)
 984:	eb a4                	jmp    92a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 986:	c7 05 08 0a 00 00 00 	movl   $0xa00,0xa08
 98d:	0a 00 00 
    base.s.size = 0;
 990:	b9 00 0a 00 00       	mov    $0xa00,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 995:	c7 05 00 0a 00 00 00 	movl   $0xa00,0xa00
 99c:	0a 00 00 
    base.s.size = 0;
 99f:	c7 05 04 0a 00 00 00 	movl   $0x0,0xa04
 9a6:	00 00 00 
 9a9:	e9 45 ff ff ff       	jmp    8f3 <malloc+0x23>
