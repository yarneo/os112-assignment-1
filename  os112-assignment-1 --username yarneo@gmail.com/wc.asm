
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
  2b:	c7 44 24 04 00 09 00 	movl   $0x900,0x4(%esp)
  32:	00 
  33:	89 04 24             	mov    %eax,(%esp)
  36:	e8 ad 03 00 00       	call   3e8 <read>
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
  52:	0f be 83 00 09 00 00 	movsbl 0x900(%ebx),%eax
        l++;
  59:	31 d2                	xor    %edx,%edx
      if(strchr(" \r\t\n\v", buf[i]))
  5b:	c7 04 24 8e 08 00 00 	movl   $0x88e,(%esp)
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
  9b:	c7 44 24 04 a4 08 00 	movl   $0x8a4,0x4(%esp)
  a2:	00 
  a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  aa:	89 44 24 14          	mov    %eax,0x14(%esp)
  ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  bc:	e8 4f 04 00 00       	call   510 <printf>
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
  c9:	c7 44 24 04 94 08 00 	movl   $0x894,0x4(%esp)
  d0:	00 
  d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d8:	e8 33 04 00 00       	call   510 <printf>
    exit();
  dd:	e8 e6 02 00 00       	call   3c8 <exit>
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
 11d:	e8 ee 02 00 00       	call   410 <open>
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
 145:	e8 ae 02 00 00       	call   3f8 <close>
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
 14e:	e8 75 02 00 00       	call   3c8 <exit>
 153:	90                   	nop
 154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
 158:	8b 03                	mov    (%ebx),%eax
 15a:	c7 44 24 04 b1 08 00 	movl   $0x8b1,0x4(%esp)
 161:	00 
 162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 169:	89 44 24 08          	mov    %eax,0x8(%esp)
 16d:	e8 9e 03 00 00       	call   510 <printf>
      exit();
 172:	e8 51 02 00 00       	call   3c8 <exit>
 177:	90                   	nop
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    wc(0, "");
 178:	c7 44 24 04 a3 08 00 	movl   $0x8a3,0x4(%esp)
 17f:	00 
 180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 187:	e8 74 fe ff ff       	call   0 <wc>
    exit();
 18c:	e8 37 02 00 00       	call   3c8 <exit>
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

00000310 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 316:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 319:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 31c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 31f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 32b:	00 
 32c:	89 04 24             	mov    %eax,(%esp)
 32f:	e8 dc 00 00 00       	call   410 <open>
  if(fd < 0)
 334:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 336:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 338:	78 19                	js     353 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 33a:	8b 45 0c             	mov    0xc(%ebp),%eax
 33d:	89 1c 24             	mov    %ebx,(%esp)
 340:	89 44 24 04          	mov    %eax,0x4(%esp)
 344:	e8 df 00 00 00       	call   428 <fstat>
  close(fd);
 349:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 34c:	89 c6                	mov    %eax,%esi
  close(fd);
 34e:	e8 a5 00 00 00       	call   3f8 <close>
  return r;
}
 353:	89 f0                	mov    %esi,%eax
 355:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 358:	8b 75 fc             	mov    -0x4(%ebp),%esi
 35b:	89 ec                	mov    %ebp,%esp
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    
 35f:	90                   	nop

00000360 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	31 f6                	xor    %esi,%esi
 367:	53                   	push   %ebx
 368:	83 ec 2c             	sub    $0x2c,%esp
 36b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36e:	eb 06                	jmp    376 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 370:	3c 0a                	cmp    $0xa,%al
 372:	74 39                	je     3ad <gets+0x4d>
 374:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 376:	8d 5e 01             	lea    0x1(%esi),%ebx
 379:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 37c:	7d 31                	jge    3af <gets+0x4f>
    cc = read(0, &c, 1);
 37e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 381:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 388:	00 
 389:	89 44 24 04          	mov    %eax,0x4(%esp)
 38d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 394:	e8 4f 00 00 00       	call   3e8 <read>
    if(cc < 1)
 399:	85 c0                	test   %eax,%eax
 39b:	7e 12                	jle    3af <gets+0x4f>
      break;
    buf[i++] = c;
 39d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3a1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 3a5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3a9:	3c 0d                	cmp    $0xd,%al
 3ab:	75 c3                	jne    370 <gets+0x10>
 3ad:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3af:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3b3:	89 f8                	mov    %edi,%eax
 3b5:	83 c4 2c             	add    $0x2c,%esp
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5f                   	pop    %edi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	90                   	nop
 3be:	90                   	nop
 3bf:	90                   	nop

000003c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c0:	b8 01 00 00 00       	mov    $0x1,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <exit>:
SYSCALL(exit)
 3c8:	b8 02 00 00 00       	mov    $0x2,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <wait>:
SYSCALL(wait)
 3d0:	b8 03 00 00 00       	mov    $0x3,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <wait2>:
SYSCALL(wait2)
 3d8:	b8 16 00 00 00       	mov    $0x16,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <pipe>:
SYSCALL(pipe)
 3e0:	b8 04 00 00 00       	mov    $0x4,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <read>:
SYSCALL(read)
 3e8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <write>:
SYSCALL(write)
 3f0:	b8 05 00 00 00       	mov    $0x5,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <close>:
SYSCALL(close)
 3f8:	b8 07 00 00 00       	mov    $0x7,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <kill>:
SYSCALL(kill)
 400:	b8 08 00 00 00       	mov    $0x8,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <exec>:
SYSCALL(exec)
 408:	b8 09 00 00 00       	mov    $0x9,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <open>:
SYSCALL(open)
 410:	b8 0a 00 00 00       	mov    $0xa,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <mknod>:
SYSCALL(mknod)
 418:	b8 0b 00 00 00       	mov    $0xb,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <unlink>:
SYSCALL(unlink)
 420:	b8 0c 00 00 00       	mov    $0xc,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <fstat>:
SYSCALL(fstat)
 428:	b8 0d 00 00 00       	mov    $0xd,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <link>:
SYSCALL(link)
 430:	b8 0e 00 00 00       	mov    $0xe,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <mkdir>:
SYSCALL(mkdir)
 438:	b8 0f 00 00 00       	mov    $0xf,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <chdir>:
SYSCALL(chdir)
 440:	b8 10 00 00 00       	mov    $0x10,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <dup>:
SYSCALL(dup)
 448:	b8 11 00 00 00       	mov    $0x11,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <getpid>:
SYSCALL(getpid)
 450:	b8 12 00 00 00       	mov    $0x12,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <sbrk>:
SYSCALL(sbrk)
 458:	b8 13 00 00 00       	mov    $0x13,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <sleep>:
SYSCALL(sleep)
 460:	b8 14 00 00 00       	mov    $0x14,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <uptime>:
SYSCALL(uptime)
 468:	b8 15 00 00 00       	mov    $0x15,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

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
 49c:	0f b6 92 cd 08 00 00 	movzbl 0x8cd(%edx),%edx
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
 4e6:	e8 05 ff ff ff       	call   3f0 <write>
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
 5bd:	e8 2e fe ff ff       	call   3f0 <write>
 5c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5cf:	00 
 5d0:	89 74 24 04          	mov    %esi,0x4(%esp)
 5d4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 5d7:	89 04 24             	mov    %eax,(%esp)
 5da:	e8 11 fe ff ff       	call   3f0 <write>
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
 60d:	e8 de fd ff ff       	call   3f0 <write>
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
 67d:	e8 6e fd ff ff       	call   3f0 <write>
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
 6b0:	e8 3b fd ff ff       	call   3f0 <write>
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
 704:	e8 e7 fc ff ff       	call   3f0 <write>
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
 715:	bf c6 08 00 00       	mov    $0x8c6,%edi
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
 721:	a1 e8 08 00 00       	mov    0x8e8,%eax
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
 771:	a3 e8 08 00 00       	mov    %eax,0x8e8
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
 79d:	a3 e8 08 00 00       	mov    %eax,0x8e8
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
 7bc:	8b 0d e8 08 00 00    	mov    0x8e8,%ecx
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
 7e8:	3b 05 e8 08 00 00    	cmp    0x8e8,%eax
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
 80a:	89 0d e8 08 00 00    	mov    %ecx,0x8e8
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
 839:	e8 1a fc ff ff       	call   458 <sbrk>
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
 851:	8b 0d e8 08 00 00    	mov    0x8e8,%ecx
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
 866:	c7 05 e8 08 00 00 e0 	movl   $0x8e0,0x8e8
 86d:	08 00 00 
    base.s.size = 0;
 870:	b9 e0 08 00 00       	mov    $0x8e0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 875:	c7 05 e0 08 00 00 e0 	movl   $0x8e0,0x8e0
 87c:	08 00 00 
    base.s.size = 0;
 87f:	c7 05 e4 08 00 00 00 	movl   $0x0,0x8e4
 886:	00 00 00 
 889:	e9 45 ff ff ff       	jmp    7d3 <malloc+0x23>
