
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  18:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1c:	89 3c 24             	mov    %edi,(%esp)
  1f:	e8 3c 00 00 00       	call   60 <matchhere>
  24:	85 c0                	test   %eax,%eax
  26:	75 20                	jne    48 <matchstar+0x48>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0f b6 03             	movzbl (%ebx),%eax
  2b:	84 c0                	test   %al,%al
  2d:	74 0f                	je     3e <matchstar+0x3e>
  2f:	0f be c0             	movsbl %al,%eax
  32:	83 c3 01             	add    $0x1,%ebx
  35:	39 f0                	cmp    %esi,%eax
  37:	74 df                	je     18 <matchstar+0x18>
  39:	83 fe 2e             	cmp    $0x2e,%esi
  3c:	74 da                	je     18 <matchstar+0x18>
  return 0;
}
  3e:	83 c4 1c             	add    $0x1c,%esp
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  41:	31 c0                	xor    %eax,%eax
  return 0;
}
  43:	5b                   	pop    %ebx
  44:	5e                   	pop    %esi
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
  48:	83 c4 1c             	add    $0x1c,%esp

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  4b:	b8 01 00 00 00       	mov    $0x1,%eax
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  return 0;
}
  50:	5b                   	pop    %ebx
  51:	5e                   	pop    %esi
  52:	5f                   	pop    %edi
  53:	5d                   	pop    %ebp
  54:	c3                   	ret    
  55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000060 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	83 ec 10             	sub    $0x10,%esp
  68:	8b 55 08             	mov    0x8(%ebp),%edx
  6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  if(re[0] == '\0')
  6e:	0f b6 02             	movzbl (%edx),%eax
  71:	84 c0                	test   %al,%al
  73:	75 1c                	jne    91 <matchhere+0x31>
  75:	eb 51                	jmp    c8 <matchhere+0x68>
  77:	90                   	nop
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	0f b6 19             	movzbl (%ecx),%ebx
  7b:	84 db                	test   %bl,%bl
  7d:	74 39                	je     b8 <matchhere+0x58>
  7f:	3c 2e                	cmp    $0x2e,%al
  81:	74 04                	je     87 <matchhere+0x27>
  83:	38 d8                	cmp    %bl,%al
  85:	75 31                	jne    b8 <matchhere+0x58>
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  87:	0f b6 02             	movzbl (%edx),%eax
  8a:	84 c0                	test   %al,%al
  8c:	74 3a                	je     c8 <matchhere+0x68>
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  8e:	83 c1 01             	add    $0x1,%ecx
// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
  91:	0f b6 5a 01          	movzbl 0x1(%edx),%ebx
  95:	8d 72 01             	lea    0x1(%edx),%esi
  98:	80 fb 2a             	cmp    $0x2a,%bl
  9b:	74 3b                	je     d8 <matchhere+0x78>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
  9d:	3c 24                	cmp    $0x24,%al
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  9f:	89 f2                	mov    %esi,%edx
  if(re[0] == '$' && re[1] == '\0')
  a1:	75 d5                	jne    78 <matchhere+0x18>
  a3:	84 db                	test   %bl,%bl
  a5:	75 d1                	jne    78 <matchhere+0x18>
    return *text == '\0';
  a7:	31 c0                	xor    %eax,%eax
  a9:	80 39 00             	cmpb   $0x0,(%ecx)
  ac:	0f 94 c0             	sete   %al
  af:	eb 09                	jmp    ba <matchhere+0x5a>
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  b8:	31 c0                	xor    %eax,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  ba:	83 c4 10             	add    $0x10,%esp
  bd:	5b                   	pop    %ebx
  be:	5e                   	pop    %esi
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    
  c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  c8:	83 c4 10             	add    $0x10,%esp
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
  cb:	b8 01 00 00 00       	mov    $0x1,%eax
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  d0:	5b                   	pop    %ebx
  d1:	5e                   	pop    %esi
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int matchhere(char *re, char *text)
{
  if(re[0] == '\0')
    return 1;
  if(re[1] == '*')
    return matchstar(re[0], re+2, text);
  d8:	83 c2 02             	add    $0x2,%edx
  db:	0f be c0             	movsbl %al,%eax
  de:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 12 ff ff ff       	call   0 <matchstar>
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    return matchhere(re+1, text+1);
  return 0;
}
  ee:	83 c4 10             	add    $0x10,%esp
  f1:	5b                   	pop    %ebx
  f2:	5e                   	pop    %esi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	83 ec 10             	sub    $0x10,%esp
 108:	8b 75 08             	mov    0x8(%ebp),%esi
 10b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
 10e:	80 3e 5e             	cmpb   $0x5e,(%esi)
 111:	75 08                	jne    11b <match+0x1b>
 113:	eb 2f                	jmp    144 <match+0x44>
 115:	8d 76 00             	lea    0x0(%esi),%esi
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 118:	83 c3 01             	add    $0x1,%ebx
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
 11b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 11f:	89 34 24             	mov    %esi,(%esp)
 122:	e8 39 ff ff ff       	call   60 <matchhere>
 127:	85 c0                	test   %eax,%eax
 129:	75 0d                	jne    138 <match+0x38>
      return 1;
  }while(*text++ != '\0');
 12b:	80 3b 00             	cmpb   $0x0,(%ebx)
 12e:	75 e8                	jne    118 <match+0x18>
  return 0;
}
 130:	83 c4 10             	add    $0x10,%esp
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	90                   	nop
 138:	83 c4 10             	add    $0x10,%esp
  if(re[0] == '^')
    return matchhere(re+1, text);
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
 13b:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 144:	83 c6 01             	add    $0x1,%esi
 147:	89 75 08             	mov    %esi,0x8(%ebp)
  do{  // must look at empty string
    if(matchhere(re, text))
      return 1;
  }while(*text++ != '\0');
  return 0;
}
 14a:	83 c4 10             	add    $0x10,%esp
 14d:	5b                   	pop    %ebx
 14e:	5e                   	pop    %esi
 14f:	5d                   	pop    %ebp

int
match(char *re, char *text)
{
  if(re[0] == '^')
    return matchhere(re+1, text);
 150:	e9 0b ff ff ff       	jmp    60 <matchhere>
 155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
 165:	53                   	push   %ebx
 166:	83 ec 2c             	sub    $0x2c,%esp
 169:	8b 7d 08             	mov    0x8(%ebp),%edi
 16c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 173:	90                   	nop
 174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
 178:	b8 00 04 00 00       	mov    $0x400,%eax
 17d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
 180:	89 44 24 08          	mov    %eax,0x8(%esp)
 184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 187:	05 c0 0b 00 00       	add    $0xbc0,%eax
 18c:	89 44 24 04          	mov    %eax,0x4(%esp)
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 ed 04 00 00       	call   688 <read>
 19b:	85 c0                	test   %eax,%eax
 19d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 1a0:	0f 8e ae 00 00 00    	jle    254 <grep+0xf4>
 1a6:	be c0 0b 00 00       	mov    $0xbc0,%esi
 1ab:	90                   	nop
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
 1b0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
 1b7:	00 
 1b8:	89 34 24             	mov    %esi,(%esp)
 1bb:	e8 30 02 00 00       	call   3f0 <strchr>
 1c0:	85 c0                	test   %eax,%eax
 1c2:	89 c3                	mov    %eax,%ebx
 1c4:	74 42                	je     208 <grep+0xa8>
      *q = 0;
 1c6:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 1c9:	89 74 24 04          	mov    %esi,0x4(%esp)
 1cd:	89 3c 24             	mov    %edi,(%esp)
 1d0:	e8 2b ff ff ff       	call   100 <match>
 1d5:	85 c0                	test   %eax,%eax
 1d7:	75 07                	jne    1e0 <grep+0x80>
 1d9:	83 c3 01             	add    $0x1,%ebx
        *q = '\n';
        write(1, p, q+1 - p);
 1dc:	89 de                	mov    %ebx,%esi
 1de:	eb d0                	jmp    1b0 <grep+0x50>
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
      *q = 0;
      if(match(pattern, p)){
        *q = '\n';
 1e0:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 1e3:	83 c3 01             	add    $0x1,%ebx
 1e6:	89 d8                	mov    %ebx,%eax
 1e8:	29 f0                	sub    %esi,%eax
 1ea:	89 74 24 04          	mov    %esi,0x4(%esp)
 1ee:	89 de                	mov    %ebx,%esi
 1f0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1fb:	e8 90 04 00 00       	call   690 <write>
 200:	eb ae                	jmp    1b0 <grep+0x50>
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
      p = q+1;
    }
    if(p == buf)
 208:	81 fe c0 0b 00 00    	cmp    $0xbc0,%esi
 20e:	74 38                	je     248 <grep+0xe8>
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
 210:	8b 45 e0             	mov    -0x20(%ebp),%eax
 213:	01 45 e4             	add    %eax,-0x1c(%ebp)
      }
      p = q+1;
    }
    if(p == buf)
      m = 0;
    if(m > 0){
 216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 219:	85 c0                	test   %eax,%eax
 21b:	0f 8e 57 ff ff ff    	jle    178 <grep+0x18>
      m -= p - buf;
 221:	81 45 e4 c0 0b 00 00 	addl   $0xbc0,-0x1c(%ebp)
 228:	29 75 e4             	sub    %esi,-0x1c(%ebp)
      memmove(buf, p, m);
 22b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 22e:	89 74 24 04          	mov    %esi,0x4(%esp)
 232:	c7 04 24 c0 0b 00 00 	movl   $0xbc0,(%esp)
 239:	89 44 24 08          	mov    %eax,0x8(%esp)
 23d:	e8 2e 02 00 00       	call   470 <memmove>
 242:	e9 31 ff ff ff       	jmp    178 <grep+0x18>
 247:	90                   	nop
 248:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 24f:	e9 24 ff ff ff       	jmp    178 <grep+0x18>
    }
  }
}
 254:	83 c4 2c             	add    $0x2c,%esp
 257:	5b                   	pop    %ebx
 258:	5e                   	pop    %esi
 259:	5f                   	pop    %edi
 25a:	5d                   	pop    %ebp
 25b:	c3                   	ret    
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <main>:

int
main(int argc, char *argv[])
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 e4 f0             	and    $0xfffffff0,%esp
 266:	57                   	push   %edi
 267:	56                   	push   %esi
 268:	53                   	push   %ebx
 269:	83 ec 24             	sub    $0x24,%esp
 26c:	8b 7d 08             	mov    0x8(%ebp),%edi
 26f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 272:	83 ff 01             	cmp    $0x1,%edi
 275:	0f 8e 95 00 00 00    	jle    310 <main+0xb0>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 27b:	8b 43 04             	mov    0x4(%ebx),%eax
  
  if(argc <= 2){
 27e:	83 ff 02             	cmp    $0x2,%edi
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
 281:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  
  if(argc <= 2){
 285:	74 71                	je     2f8 <main+0x98>
    grep(pattern, 0);
    exit();
 287:	83 c3 08             	add    $0x8,%ebx
 28a:	be 02 00 00 00       	mov    $0x2,%esi
 28f:	90                   	nop
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 290:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 297:	00 
 298:	8b 03                	mov    (%ebx),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 0e 04 00 00       	call   6b0 <open>
 2a2:	85 c0                	test   %eax,%eax
 2a4:	78 32                	js     2d8 <main+0x78>
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 2a6:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 2aa:	83 c6 01             	add    $0x1,%esi
 2ad:	83 c3 04             	add    $0x4,%ebx
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
 2b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b4:	89 44 24 18          	mov    %eax,0x18(%esp)
 2b8:	89 14 24             	mov    %edx,(%esp)
 2bb:	e8 a0 fe ff ff       	call   160 <grep>
    close(fd);
 2c0:	8b 44 24 18          	mov    0x18(%esp),%eax
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 cc 03 00 00       	call   698 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 2cc:	39 f7                	cmp    %esi,%edi
 2ce:	7f c0                	jg     290 <main+0x30>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 2d0:	e8 93 03 00 00       	call   668 <exit>
 2d5:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
  }

  for(i = 2; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
 2d8:	8b 03                	mov    (%ebx),%eax
 2da:	c7 44 24 04 60 0b 00 	movl   $0xb60,0x4(%esp)
 2e1:	00 
 2e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2e9:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ed:	e8 ce 04 00 00       	call   7c0 <printf>
      exit();
 2f2:	e8 71 03 00 00       	call   668 <exit>
 2f7:	90                   	nop
    exit();
  }
  pattern = argv[1];
  
  if(argc <= 2){
    grep(pattern, 0);
 2f8:	89 04 24             	mov    %eax,(%esp)
 2fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 302:	00 
 303:	e8 58 fe ff ff       	call   160 <grep>
    exit();
 308:	e8 5b 03 00 00       	call   668 <exit>
 30d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    printf(2, "usage: grep pattern [file ...]\n");
 310:	c7 44 24 04 40 0b 00 	movl   $0xb40,0x4(%esp)
 317:	00 
 318:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 31f:	e8 9c 04 00 00       	call   7c0 <printf>
    exit();
 324:	e8 3f 03 00 00       	call   668 <exit>
 329:	90                   	nop
 32a:	90                   	nop
 32b:	90                   	nop
 32c:	90                   	nop
 32d:	90                   	nop
 32e:	90                   	nop
 32f:	90                   	nop

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 330:	55                   	push   %ebp
 331:	31 d2                	xor    %edx,%edx
 333:	89 e5                	mov    %esp,%ebp
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	53                   	push   %ebx
 339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 340:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 344:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 347:	83 c2 01             	add    $0x1,%edx
 34a:	84 c9                	test   %cl,%cl
 34c:	75 f2                	jne    340 <strcpy+0x10>
    ;
  return os;
}
 34e:	5b                   	pop    %ebx
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    
 351:	eb 0d                	jmp    360 <strcmp>
 353:	90                   	nop
 354:	90                   	nop
 355:	90                   	nop
 356:	90                   	nop
 357:	90                   	nop
 358:	90                   	nop
 359:	90                   	nop
 35a:	90                   	nop
 35b:	90                   	nop
 35c:	90                   	nop
 35d:	90                   	nop
 35e:	90                   	nop
 35f:	90                   	nop

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 4d 08             	mov    0x8(%ebp),%ecx
 367:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 36a:	0f b6 01             	movzbl (%ecx),%eax
 36d:	84 c0                	test   %al,%al
 36f:	75 14                	jne    385 <strcmp+0x25>
 371:	eb 25                	jmp    398 <strcmp+0x38>
 373:	90                   	nop
 374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 378:	83 c1 01             	add    $0x1,%ecx
 37b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 37e:	0f b6 01             	movzbl (%ecx),%eax
 381:	84 c0                	test   %al,%al
 383:	74 13                	je     398 <strcmp+0x38>
 385:	0f b6 1a             	movzbl (%edx),%ebx
 388:	38 d8                	cmp    %bl,%al
 38a:	74 ec                	je     378 <strcmp+0x18>
 38c:	0f b6 db             	movzbl %bl,%ebx
 38f:	0f b6 c0             	movzbl %al,%eax
 392:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 394:	5b                   	pop    %ebx
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 398:	0f b6 1a             	movzbl (%edx),%ebx
 39b:	31 c0                	xor    %eax,%eax
 39d:	0f b6 db             	movzbl %bl,%ebx
 3a0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3a2:	5b                   	pop    %ebx
 3a3:	5d                   	pop    %ebp
 3a4:	c3                   	ret    
 3a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strlen>:

uint
strlen(char *s)
{
 3b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3b1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3b3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3b5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3ba:	80 39 00             	cmpb   $0x0,(%ecx)
 3bd:	74 0c                	je     3cb <strlen+0x1b>
 3bf:	90                   	nop
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	75 f5                	jne    3c0 <strlen+0x10>
    ;
  return n;
}
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 55 08             	mov    0x8(%ebp),%edx
 3d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 d7                	mov    %edx,%edi
 3df:	fc                   	cld    
 3e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	5f                   	pop    %edi
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	75 11                	jne    412 <strchr+0x22>
 401:	eb 15                	jmp    418 <strchr+0x28>
 403:	90                   	nop
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 408:	83 c0 01             	add    $0x1,%eax
 40b:	0f b6 10             	movzbl (%eax),%edx
 40e:	84 d2                	test   %dl,%dl
 410:	74 06                	je     418 <strchr+0x28>
    if(*s == c)
 412:	38 ca                	cmp    %cl,%dl
 414:	75 f2                	jne    408 <strchr+0x18>
      return (char*) s;
  return 0;
}
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 418:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 41a:	5d                   	pop    %ebp
 41b:	90                   	nop
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 420:	c3                   	ret    
 421:	eb 0d                	jmp    430 <atoi>
 423:	90                   	nop
 424:	90                   	nop
 425:	90                   	nop
 426:	90                   	nop
 427:	90                   	nop
 428:	90                   	nop
 429:	90                   	nop
 42a:	90                   	nop
 42b:	90                   	nop
 42c:	90                   	nop
 42d:	90                   	nop
 42e:	90                   	nop
 42f:	90                   	nop

00000430 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 431:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 433:	89 e5                	mov    %esp,%ebp
 435:	8b 4d 08             	mov    0x8(%ebp),%ecx
 438:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 439:	0f b6 11             	movzbl (%ecx),%edx
 43c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 43f:	80 fb 09             	cmp    $0x9,%bl
 442:	77 1c                	ja     460 <atoi+0x30>
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 448:	0f be d2             	movsbl %dl,%edx
 44b:	83 c1 01             	add    $0x1,%ecx
 44e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 451:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 455:	0f b6 11             	movzbl (%ecx),%edx
 458:	8d 5a d0             	lea    -0x30(%edx),%ebx
 45b:	80 fb 09             	cmp    $0x9,%bl
 45e:	76 e8                	jbe    448 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 460:	5b                   	pop    %ebx
 461:	5d                   	pop    %ebp
 462:	c3                   	ret    
 463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	56                   	push   %esi
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	53                   	push   %ebx
 478:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 db                	test   %ebx,%ebx
 480:	7e 14                	jle    496 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 482:	31 d2                	xor    %edx,%edx
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 488:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 48c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 48f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 492:	39 da                	cmp    %ebx,%edx
 494:	75 f2                	jne    488 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5d                   	pop    %ebp
 499:	c3                   	ret    
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004a0 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4a6:	57                   	push   %edi
 4a7:	56                   	push   %esi
 4a8:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 4a9:	80 39 00             	cmpb   $0x0,(%ecx)
 4ac:	74 37                	je     4e5 <reverse+0x45>
 4ae:	31 d2                	xor    %edx,%edx
 4b0:	83 c2 01             	add    $0x1,%edx
 4b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 4b7:	75 f7                	jne    4b0 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 4b9:	8d 7a ff             	lea    -0x1(%edx),%edi
 4bc:	85 ff                	test   %edi,%edi
 4be:	7e 25                	jle    4e5 <reverse+0x45>
 4c0:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 4c3:	31 c0                	xor    %eax,%eax
 4c5:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 4c8:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 4cc:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 4cf:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 4d3:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 4d6:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 4d8:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 4db:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 4de:	83 ea 01             	sub    $0x1,%edx
 4e1:	39 f8                	cmp    %edi,%eax
 4e3:	7c e3                	jl     4c8 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 4e5:	5b                   	pop    %ebx
 4e6:	5e                   	pop    %esi
 4e7:	5f                   	pop    %edi
 4e8:	5d                   	pop    %ebp
 4e9:	c3                   	ret    
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004f0 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 4f4:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 4f9:	56                   	push   %esi
 4fa:	53                   	push   %ebx
 4fb:	31 db                	xor    %ebx,%ebx
 4fd:	83 ec 04             	sub    $0x4,%esp
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	8b 75 0c             	mov    0xc(%ebp),%esi
 506:	89 45 f0             	mov    %eax,-0x10(%ebp)
 509:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 50c:	c1 f8 1f             	sar    $0x1f,%eax
 50f:	31 c1                	xor    %eax,%ecx
 511:	29 c1                	sub    %eax,%ecx
 513:	90                   	nop
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 518:	89 c8                	mov    %ecx,%eax
 51a:	f7 ef                	imul   %edi
 51c:	89 c8                	mov    %ecx,%eax
 51e:	c1 f8 1f             	sar    $0x1f,%eax
 521:	c1 fa 02             	sar    $0x2,%edx
 524:	29 c2                	sub    %eax,%edx
 526:	8d 04 92             	lea    (%edx,%edx,4),%eax
 529:	01 c0                	add    %eax,%eax
 52b:	29 c1                	sub    %eax,%ecx
 52d:	83 c1 30             	add    $0x30,%ecx
 530:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 533:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 536:	85 d2                	test   %edx,%edx
 538:	89 d1                	mov    %edx,%ecx
 53a:	7f dc                	jg     518 <itoa+0x28>
     if (sign < 0)
 53c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 53f:	85 c0                	test   %eax,%eax
 541:	79 07                	jns    54a <itoa+0x5a>
         s[i++] = '-';
 543:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 547:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 54a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 54e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 551:	83 c4 04             	add    $0x4,%esp
 554:	5b                   	pop    %ebx
 555:	5e                   	pop    %esi
 556:	5f                   	pop    %edi
 557:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 558:	e9 43 ff ff ff       	jmp    4a0 <reverse>
 55d:	8d 76 00             	lea    0x0(%esi),%esi

00000560 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 560:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 561:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 563:	89 e5                	mov    %esp,%ebp
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	57                   	push   %edi
 569:	8b 7d 0c             	mov    0xc(%ebp),%edi
 56c:	56                   	push   %esi
 56d:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 56e:	31 db                	xor    %ebx,%ebx
 570:	80 38 00             	cmpb   $0x0,(%eax)
 573:	74 0e                	je     583 <strcat+0x23>
 575:	8d 76 00             	lea    0x0(%esi),%esi
 578:	83 c2 01             	add    $0x1,%edx
 57b:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 57f:	75 f7                	jne    578 <strcat+0x18>
 581:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 583:	0f b6 0f             	movzbl (%edi),%ecx
 586:	84 c9                	test   %cl,%cl
 588:	74 18                	je     5a2 <strcat+0x42>
 58a:	8d 34 10             	lea    (%eax,%edx,1),%esi
 58d:	31 db                	xor    %ebx,%ebx
 58f:	90                   	nop
 590:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 593:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 595:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 599:	83 c6 01             	add    $0x1,%esi
 59c:	84 c9                	test   %cl,%cl
 59e:	75 f0                	jne    590 <strcat+0x30>
 5a0:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 5a2:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 5a6:	5b                   	pop    %ebx
 5a7:	5e                   	pop    %esi
 5a8:	5f                   	pop    %edi
 5a9:	5d                   	pop    %ebp
 5aa:	c3                   	ret    
 5ab:	90                   	nop
 5ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005b0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 5b9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 5bc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 5bf:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5cb:	00 
 5cc:	89 04 24             	mov    %eax,(%esp)
 5cf:	e8 dc 00 00 00       	call   6b0 <open>
  if(fd < 0)
 5d4:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5d6:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 5d8:	78 19                	js     5f3 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 5da:	8b 45 0c             	mov    0xc(%ebp),%eax
 5dd:	89 1c 24             	mov    %ebx,(%esp)
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	e8 df 00 00 00       	call   6c8 <fstat>
  close(fd);
 5e9:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 5ec:	89 c6                	mov    %eax,%esi
  close(fd);
 5ee:	e8 a5 00 00 00       	call   698 <close>
  return r;
}
 5f3:	89 f0                	mov    %esi,%eax
 5f5:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 5f8:	8b 75 fc             	mov    -0x4(%ebp),%esi
 5fb:	89 ec                	mov    %ebp,%esp
 5fd:	5d                   	pop    %ebp
 5fe:	c3                   	ret    
 5ff:	90                   	nop

00000600 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	31 f6                	xor    %esi,%esi
 607:	53                   	push   %ebx
 608:	83 ec 2c             	sub    $0x2c,%esp
 60b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 60e:	eb 06                	jmp    616 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 610:	3c 0a                	cmp    $0xa,%al
 612:	74 39                	je     64d <gets+0x4d>
 614:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 616:	8d 5e 01             	lea    0x1(%esi),%ebx
 619:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 61c:	7d 31                	jge    64f <gets+0x4f>
    cc = read(0, &c, 1);
 61e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 621:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 628:	00 
 629:	89 44 24 04          	mov    %eax,0x4(%esp)
 62d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 634:	e8 4f 00 00 00       	call   688 <read>
    if(cc < 1)
 639:	85 c0                	test   %eax,%eax
 63b:	7e 12                	jle    64f <gets+0x4f>
      break;
    buf[i++] = c;
 63d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 641:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 645:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 649:	3c 0d                	cmp    $0xd,%al
 64b:	75 c3                	jne    610 <gets+0x10>
 64d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 64f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 653:	89 f8                	mov    %edi,%eax
 655:	83 c4 2c             	add    $0x2c,%esp
 658:	5b                   	pop    %ebx
 659:	5e                   	pop    %esi
 65a:	5f                   	pop    %edi
 65b:	5d                   	pop    %ebp
 65c:	c3                   	ret    
 65d:	90                   	nop
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 660:	b8 01 00 00 00       	mov    $0x1,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <exit>:
SYSCALL(exit)
 668:	b8 02 00 00 00       	mov    $0x2,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <wait>:
SYSCALL(wait)
 670:	b8 03 00 00 00       	mov    $0x3,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <wait2>:
SYSCALL(wait2)
 678:	b8 16 00 00 00       	mov    $0x16,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <pipe>:
SYSCALL(pipe)
 680:	b8 04 00 00 00       	mov    $0x4,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <read>:
SYSCALL(read)
 688:	b8 06 00 00 00       	mov    $0x6,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <write>:
SYSCALL(write)
 690:	b8 05 00 00 00       	mov    $0x5,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <close>:
SYSCALL(close)
 698:	b8 07 00 00 00       	mov    $0x7,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <kill>:
SYSCALL(kill)
 6a0:	b8 08 00 00 00       	mov    $0x8,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <exec>:
SYSCALL(exec)
 6a8:	b8 09 00 00 00       	mov    $0x9,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <open>:
SYSCALL(open)
 6b0:	b8 0a 00 00 00       	mov    $0xa,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <mknod>:
SYSCALL(mknod)
 6b8:	b8 0b 00 00 00       	mov    $0xb,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <unlink>:
SYSCALL(unlink)
 6c0:	b8 0c 00 00 00       	mov    $0xc,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <fstat>:
SYSCALL(fstat)
 6c8:	b8 0d 00 00 00       	mov    $0xd,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <link>:
SYSCALL(link)
 6d0:	b8 0e 00 00 00       	mov    $0xe,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <mkdir>:
SYSCALL(mkdir)
 6d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <chdir>:
SYSCALL(chdir)
 6e0:	b8 10 00 00 00       	mov    $0x10,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <dup>:
SYSCALL(dup)
 6e8:	b8 11 00 00 00       	mov    $0x11,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <getpid>:
SYSCALL(getpid)
 6f0:	b8 12 00 00 00       	mov    $0x12,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <sbrk>:
SYSCALL(sbrk)
 6f8:	b8 13 00 00 00       	mov    $0x13,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <sleep>:
SYSCALL(sleep)
 700:	b8 14 00 00 00       	mov    $0x14,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <uptime>:
SYSCALL(uptime)
 708:	b8 15 00 00 00       	mov    $0x15,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <nice>:
SYSCALL(nice)
 710:	b8 17 00 00 00       	mov    $0x17,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    
 718:	90                   	nop
 719:	90                   	nop
 71a:	90                   	nop
 71b:	90                   	nop
 71c:	90                   	nop
 71d:	90                   	nop
 71e:	90                   	nop
 71f:	90                   	nop

00000720 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	89 cf                	mov    %ecx,%edi
 726:	56                   	push   %esi
 727:	89 c6                	mov    %eax,%esi
 729:	53                   	push   %ebx
 72a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 72d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 730:	85 c9                	test   %ecx,%ecx
 732:	74 04                	je     738 <printint+0x18>
 734:	85 d2                	test   %edx,%edx
 736:	78 70                	js     7a8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 738:	89 d0                	mov    %edx,%eax
 73a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 741:	31 c9                	xor    %ecx,%ecx
 743:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 746:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 748:	31 d2                	xor    %edx,%edx
 74a:	f7 f7                	div    %edi
 74c:	0f b6 92 7d 0b 00 00 	movzbl 0xb7d(%edx),%edx
 753:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 756:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 759:	85 c0                	test   %eax,%eax
 75b:	75 eb                	jne    748 <printint+0x28>
  if(neg)
 75d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 760:	85 c0                	test   %eax,%eax
 762:	74 08                	je     76c <printint+0x4c>
    buf[i++] = '-';
 764:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 769:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 76c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 76f:	01 fb                	add    %edi,%ebx
 771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 778:	0f b6 03             	movzbl (%ebx),%eax
 77b:	83 ef 01             	sub    $0x1,%edi
 77e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 781:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 788:	00 
 789:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 78c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 78f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 792:	89 44 24 04          	mov    %eax,0x4(%esp)
 796:	e8 f5 fe ff ff       	call   690 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 79b:	83 ff ff             	cmp    $0xffffffff,%edi
 79e:	75 d8                	jne    778 <printint+0x58>
    putc(fd, buf[i]);
}
 7a0:	83 c4 4c             	add    $0x4c,%esp
 7a3:	5b                   	pop    %ebx
 7a4:	5e                   	pop    %esi
 7a5:	5f                   	pop    %edi
 7a6:	5d                   	pop    %ebp
 7a7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 7a8:	89 d0                	mov    %edx,%eax
 7aa:	f7 d8                	neg    %eax
 7ac:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 7b3:	eb 8c                	jmp    741 <printint+0x21>
 7b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007c0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	57                   	push   %edi
 7c4:	56                   	push   %esi
 7c5:	53                   	push   %ebx
 7c6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cc:	0f b6 10             	movzbl (%eax),%edx
 7cf:	84 d2                	test   %dl,%dl
 7d1:	0f 84 c9 00 00 00    	je     8a0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7d7:	8d 4d 10             	lea    0x10(%ebp),%ecx
 7da:	31 ff                	xor    %edi,%edi
 7dc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 7df:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7e1:	8d 75 e7             	lea    -0x19(%ebp),%esi
 7e4:	eb 1e                	jmp    804 <printf+0x44>
 7e6:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 7e8:	83 fa 25             	cmp    $0x25,%edx
 7eb:	0f 85 b7 00 00 00    	jne    8a8 <printf+0xe8>
 7f1:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f5:	83 c3 01             	add    $0x1,%ebx
 7f8:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 7fc:	84 d2                	test   %dl,%dl
 7fe:	0f 84 9c 00 00 00    	je     8a0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 804:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 806:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 809:	74 dd                	je     7e8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 80b:	83 ff 25             	cmp    $0x25,%edi
 80e:	75 e5                	jne    7f5 <printf+0x35>
      if(c == 'd'){
 810:	83 fa 64             	cmp    $0x64,%edx
 813:	0f 84 57 01 00 00    	je     970 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 819:	83 fa 70             	cmp    $0x70,%edx
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 820:	0f 84 aa 00 00 00    	je     8d0 <printf+0x110>
 826:	83 fa 78             	cmp    $0x78,%edx
 829:	0f 84 a1 00 00 00    	je     8d0 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 82f:	83 fa 73             	cmp    $0x73,%edx
 832:	0f 84 c0 00 00 00    	je     8f8 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 838:	83 fa 63             	cmp    $0x63,%edx
 83b:	90                   	nop
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 840:	0f 84 52 01 00 00    	je     998 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 846:	83 fa 25             	cmp    $0x25,%edx
 849:	0f 84 f9 00 00 00    	je     948 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 84f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 852:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 855:	31 ff                	xor    %edi,%edi
 857:	89 55 cc             	mov    %edx,-0x34(%ebp)
 85a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 85e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 865:	00 
 866:	89 0c 24             	mov    %ecx,(%esp)
 869:	89 74 24 04          	mov    %esi,0x4(%esp)
 86d:	e8 1e fe ff ff       	call   690 <write>
 872:	8b 55 cc             	mov    -0x34(%ebp),%edx
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 87f:	00 
 880:	89 74 24 04          	mov    %esi,0x4(%esp)
 884:	88 55 e7             	mov    %dl,-0x19(%ebp)
 887:	89 04 24             	mov    %eax,(%esp)
 88a:	e8 01 fe ff ff       	call   690 <write>
 88f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 892:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 896:	84 d2                	test   %dl,%dl
 898:	0f 85 66 ff ff ff    	jne    804 <printf+0x44>
 89e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8a0:	83 c4 3c             	add    $0x3c,%esp
 8a3:	5b                   	pop    %ebx
 8a4:	5e                   	pop    %esi
 8a5:	5f                   	pop    %edi
 8a6:	5d                   	pop    %ebp
 8a7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8a8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8ab:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8b5:	00 
 8b6:	89 74 24 04          	mov    %esi,0x4(%esp)
 8ba:	89 04 24             	mov    %eax,(%esp)
 8bd:	e8 ce fd ff ff       	call   690 <write>
 8c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8c5:	e9 2b ff ff ff       	jmp    7f5 <printf+0x35>
 8ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 8d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8d3:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 8d8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 8da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8e1:	8b 10                	mov    (%eax),%edx
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
 8e6:	e8 35 fe ff ff       	call   720 <printint>
 8eb:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 8ee:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 8f2:	e9 fe fe ff ff       	jmp    7f5 <printf+0x35>
 8f7:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 8f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 8fb:	8b 3a                	mov    (%edx),%edi
        ap++;
 8fd:	83 c2 04             	add    $0x4,%edx
 900:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 903:	85 ff                	test   %edi,%edi
 905:	0f 84 ba 00 00 00    	je     9c5 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 90b:	0f b6 17             	movzbl (%edi),%edx
 90e:	84 d2                	test   %dl,%dl
 910:	74 2d                	je     93f <printf+0x17f>
 912:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 915:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 918:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 91b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 91e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 925:	00 
 926:	89 74 24 04          	mov    %esi,0x4(%esp)
 92a:	89 1c 24             	mov    %ebx,(%esp)
 92d:	e8 5e fd ff ff       	call   690 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 932:	0f b6 17             	movzbl (%edi),%edx
 935:	84 d2                	test   %dl,%dl
 937:	75 df                	jne    918 <printf+0x158>
 939:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 93c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 93f:	31 ff                	xor    %edi,%edi
 941:	e9 af fe ff ff       	jmp    7f5 <printf+0x35>
 946:	66 90                	xchg   %ax,%ax
 948:	8b 55 08             	mov    0x8(%ebp),%edx
 94b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 94d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 951:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 958:	00 
 959:	89 74 24 04          	mov    %esi,0x4(%esp)
 95d:	89 14 24             	mov    %edx,(%esp)
 960:	e8 2b fd ff ff       	call   690 <write>
 965:	8b 45 0c             	mov    0xc(%ebp),%eax
 968:	e9 88 fe ff ff       	jmp    7f5 <printf+0x35>
 96d:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 970:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 973:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 978:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 97b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 982:	8b 10                	mov    (%eax),%edx
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	e8 94 fd ff ff       	call   720 <printint>
 98c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 98f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 993:	e9 5d fe ff ff       	jmp    7f5 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 998:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 99b:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 99d:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 99f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9a6:	00 
 9a7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9ab:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9ae:	8b 45 08             	mov    0x8(%ebp),%eax
 9b1:	89 04 24             	mov    %eax,(%esp)
 9b4:	e8 d7 fc ff ff       	call   690 <write>
 9b9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 9bc:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 9c0:	e9 30 fe ff ff       	jmp    7f5 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 9c5:	bf 76 0b 00 00       	mov    $0xb76,%edi
 9ca:	e9 3c ff ff ff       	jmp    90b <printf+0x14b>
 9cf:	90                   	nop

000009d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d1:	a1 a8 0b 00 00       	mov    0xba8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 9d6:	89 e5                	mov    %esp,%ebp
 9d8:	57                   	push   %edi
 9d9:	56                   	push   %esi
 9da:	53                   	push   %ebx
 9db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 9de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e1:	39 c8                	cmp    %ecx,%eax
 9e3:	73 1d                	jae    a02 <free+0x32>
 9e5:	8d 76 00             	lea    0x0(%esi),%esi
 9e8:	8b 10                	mov    (%eax),%edx
 9ea:	39 d1                	cmp    %edx,%ecx
 9ec:	72 1a                	jb     a08 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ee:	39 d0                	cmp    %edx,%eax
 9f0:	72 08                	jb     9fa <free+0x2a>
 9f2:	39 c8                	cmp    %ecx,%eax
 9f4:	72 12                	jb     a08 <free+0x38>
 9f6:	39 d1                	cmp    %edx,%ecx
 9f8:	72 0e                	jb     a08 <free+0x38>
 9fa:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fc:	39 c8                	cmp    %ecx,%eax
 9fe:	66 90                	xchg   %ax,%ax
 a00:	72 e6                	jb     9e8 <free+0x18>
 a02:	8b 10                	mov    (%eax),%edx
 a04:	eb e8                	jmp    9ee <free+0x1e>
 a06:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a08:	8b 71 04             	mov    0x4(%ecx),%esi
 a0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a0e:	39 d7                	cmp    %edx,%edi
 a10:	74 19                	je     a2b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 a12:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 a15:	8b 50 04             	mov    0x4(%eax),%edx
 a18:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a1b:	39 ce                	cmp    %ecx,%esi
 a1d:	74 23                	je     a42 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 a1f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 a21:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 a26:	5b                   	pop    %ebx
 a27:	5e                   	pop    %esi
 a28:	5f                   	pop    %edi
 a29:	5d                   	pop    %ebp
 a2a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a2b:	03 72 04             	add    0x4(%edx),%esi
 a2e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a31:	8b 10                	mov    (%eax),%edx
 a33:	8b 12                	mov    (%edx),%edx
 a35:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a38:	8b 50 04             	mov    0x4(%eax),%edx
 a3b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a3e:	39 ce                	cmp    %ecx,%esi
 a40:	75 dd                	jne    a1f <free+0x4f>
    p->s.size += bp->s.size;
 a42:	03 51 04             	add    0x4(%ecx),%edx
 a45:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a48:	8b 53 f8             	mov    -0x8(%ebx),%edx
 a4b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 a4d:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 a52:	5b                   	pop    %ebx
 a53:	5e                   	pop    %esi
 a54:	5f                   	pop    %edi
 a55:	5d                   	pop    %ebp
 a56:	c3                   	ret    
 a57:	89 f6                	mov    %esi,%esi
 a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	57                   	push   %edi
 a64:	56                   	push   %esi
 a65:	53                   	push   %ebx
 a66:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 a6c:	8b 0d a8 0b 00 00    	mov    0xba8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a72:	83 c3 07             	add    $0x7,%ebx
 a75:	c1 eb 03             	shr    $0x3,%ebx
 a78:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 a7b:	85 c9                	test   %ecx,%ecx
 a7d:	0f 84 93 00 00 00    	je     b16 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a83:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 a85:	8b 50 04             	mov    0x4(%eax),%edx
 a88:	39 d3                	cmp    %edx,%ebx
 a8a:	76 1f                	jbe    aab <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 a8c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 a93:	90                   	nop
 a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 a98:	3b 05 a8 0b 00 00    	cmp    0xba8,%eax
 a9e:	74 30                	je     ad0 <malloc+0x70>
 aa0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 aa4:	8b 50 04             	mov    0x4(%eax),%edx
 aa7:	39 d3                	cmp    %edx,%ebx
 aa9:	77 ed                	ja     a98 <malloc+0x38>
      if(p->s.size == nunits)
 aab:	39 d3                	cmp    %edx,%ebx
 aad:	74 61                	je     b10 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 aaf:	29 da                	sub    %ebx,%edx
 ab1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ab4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 ab7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 aba:	89 0d a8 0b 00 00    	mov    %ecx,0xba8
      return (void*) (p + 1);
 ac0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ac3:	83 c4 1c             	add    $0x1c,%esp
 ac6:	5b                   	pop    %ebx
 ac7:	5e                   	pop    %esi
 ac8:	5f                   	pop    %edi
 ac9:	5d                   	pop    %ebp
 aca:	c3                   	ret    
 acb:	90                   	nop
 acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 ad0:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 ad6:	b8 00 80 00 00       	mov    $0x8000,%eax
 adb:	bf 00 10 00 00       	mov    $0x1000,%edi
 ae0:	76 04                	jbe    ae6 <malloc+0x86>
 ae2:	89 f0                	mov    %esi,%eax
 ae4:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 ae6:	89 04 24             	mov    %eax,(%esp)
 ae9:	e8 0a fc ff ff       	call   6f8 <sbrk>
  if(p == (char*) -1)
 aee:	83 f8 ff             	cmp    $0xffffffff,%eax
 af1:	74 18                	je     b0b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 af3:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 af6:	83 c0 08             	add    $0x8,%eax
 af9:	89 04 24             	mov    %eax,(%esp)
 afc:	e8 cf fe ff ff       	call   9d0 <free>
  return freep;
 b01:	8b 0d a8 0b 00 00    	mov    0xba8,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 b07:	85 c9                	test   %ecx,%ecx
 b09:	75 97                	jne    aa2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b0b:	31 c0                	xor    %eax,%eax
 b0d:	eb b4                	jmp    ac3 <malloc+0x63>
 b0f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 b10:	8b 10                	mov    (%eax),%edx
 b12:	89 11                	mov    %edx,(%ecx)
 b14:	eb a4                	jmp    aba <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 b16:	c7 05 a8 0b 00 00 a0 	movl   $0xba0,0xba8
 b1d:	0b 00 00 
    base.s.size = 0;
 b20:	b9 a0 0b 00 00       	mov    $0xba0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 b25:	c7 05 a0 0b 00 00 a0 	movl   $0xba0,0xba0
 b2c:	0b 00 00 
    base.s.size = 0;
 b2f:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 b36:	00 00 00 
 b39:	e9 45 ff ff ff       	jmp    a83 <malloc+0x23>
