
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 10             	sub    $0x10,%esp
   8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   b:	89 1c 24             	mov    %ebx,(%esp)
   e:	e8 cd 03 00 00       	call   3e0 <strlen>
  13:	01 d8                	add    %ebx,%eax
  15:	73 10                	jae    27 <fmtname+0x27>
  17:	eb 13                	jmp    2c <fmtname+0x2c>
  19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  20:	83 e8 01             	sub    $0x1,%eax
  23:	39 c3                	cmp    %eax,%ebx
  25:	77 05                	ja     2c <fmtname+0x2c>
  27:	80 38 2f             	cmpb   $0x2f,(%eax)
  2a:	75 f4                	jne    20 <fmtname+0x20>
    ;
  p++;
  2c:	8d 58 01             	lea    0x1(%eax),%ebx
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2f:	89 1c 24             	mov    %ebx,(%esp)
  32:	e8 a9 03 00 00       	call   3e0 <strlen>
  37:	83 f8 0d             	cmp    $0xd,%eax
  3a:	77 53                	ja     8f <fmtname+0x8f>
    return p;
  memmove(buf, p, strlen(p));
  3c:	89 1c 24             	mov    %ebx,(%esp)
  3f:	e8 9c 03 00 00       	call   3e0 <strlen>
  44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  48:	c7 04 24 d0 0b 00 00 	movl   $0xbd0,(%esp)
  4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  53:	e8 48 04 00 00       	call   4a0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  58:	89 1c 24             	mov    %ebx,(%esp)
  5b:	e8 80 03 00 00       	call   3e0 <strlen>
  60:	89 1c 24             	mov    %ebx,(%esp)
  63:	bb d0 0b 00 00       	mov    $0xbd0,%ebx
  68:	89 c6                	mov    %eax,%esi
  6a:	e8 71 03 00 00       	call   3e0 <strlen>
  6f:	ba 0e 00 00 00       	mov    $0xe,%edx
  74:	29 f2                	sub    %esi,%edx
  76:	89 54 24 08          	mov    %edx,0x8(%esp)
  7a:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  81:	00 
  82:	05 d0 0b 00 00       	add    $0xbd0,%eax
  87:	89 04 24             	mov    %eax,(%esp)
  8a:	e8 71 03 00 00       	call   400 <memset>
  return buf;
}
  8f:	83 c4 10             	add    $0x10,%esp
  92:	89 d8                	mov    %ebx,%eax
  94:	5b                   	pop    %ebx
  95:	5e                   	pop    %esi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    
  98:	90                   	nop
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000a0 <ls>:

void
ls(char *path)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	57                   	push   %edi
  a4:	56                   	push   %esi
  a5:	53                   	push   %ebx
  a6:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
  ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  b6:	00 
  b7:	89 3c 24             	mov    %edi,(%esp)
  ba:	e8 21 06 00 00       	call   6e0 <open>
  bf:	85 c0                	test   %eax,%eax
  c1:	89 c3                	mov    %eax,%ebx
  c3:	0f 88 c7 01 00 00    	js     290 <ls+0x1f0>
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
  c9:	8d 75 c4             	lea    -0x3c(%ebp),%esi
  cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 20 06 00 00       	call   6f8 <fstat>
  d8:	85 c0                	test   %eax,%eax
  da:	0f 88 00 02 00 00    	js     2e0 <ls+0x240>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type){
  e0:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  e4:	66 83 f8 01          	cmp    $0x1,%ax
  e8:	74 66                	je     150 <ls+0xb0>
  ea:	66 83 f8 02          	cmp    $0x2,%ax
  ee:	66 90                	xchg   %ax,%ax
  f0:	74 16                	je     108 <ls+0x68>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
  f2:	89 1c 24             	mov    %ebx,(%esp)
  f5:	e8 ce 05 00 00       	call   6c8 <close>
}
  fa:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 100:	5b                   	pop    %ebx
 101:	5e                   	pop    %esi
 102:	5f                   	pop    %edi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }
  
  switch(st.type){
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 108:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 10b:	8b 75 cc             	mov    -0x34(%ebp),%esi
 10e:	89 3c 24             	mov    %edi,(%esp)
 111:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 117:	e8 e4 fe ff ff       	call   0 <fmtname>
 11c:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 122:	89 74 24 10          	mov    %esi,0x10(%esp)
 126:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
 12d:	00 
 12e:	c7 44 24 04 96 0b 00 	movl   $0xb96,0x4(%esp)
 135:	00 
 136:	89 54 24 14          	mov    %edx,0x14(%esp)
 13a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 141:	89 44 24 08          	mov    %eax,0x8(%esp)
 145:	e8 a6 06 00 00       	call   7f0 <printf>
    break;
 14a:	eb a6                	jmp    f2 <ls+0x52>
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 150:	89 3c 24             	mov    %edi,(%esp)
 153:	e8 88 02 00 00       	call   3e0 <strlen>
 158:	83 c0 10             	add    $0x10,%eax
 15b:	3d 00 02 00 00       	cmp    $0x200,%eax
 160:	0f 87 0a 01 00 00    	ja     270 <ls+0x1d0>
      printf(1, "ls: path too long\n");
      break;
    }
    strcpy(buf, path);
 166:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 16c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 170:	8d 7d d8             	lea    -0x28(%ebp),%edi
 173:	89 04 24             	mov    %eax,(%esp)
 176:	e8 e5 01 00 00       	call   360 <strcpy>
    p = buf+strlen(buf);
 17b:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
 181:	89 14 24             	mov    %edx,(%esp)
 184:	e8 57 02 00 00       	call   3e0 <strlen>
 189:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
 18f:	8d 04 02             	lea    (%edx,%eax,1),%eax
    *p++ = '/';
 192:	c6 00 2f             	movb   $0x2f,(%eax)
 195:	83 c0 01             	add    $0x1,%eax
 198:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 19e:	66 90                	xchg   %ax,%ax
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 1a7:	00 
 1a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1ac:	89 1c 24             	mov    %ebx,(%esp)
 1af:	e8 04 05 00 00       	call   6b8 <read>
 1b4:	83 f8 10             	cmp    $0x10,%eax
 1b7:	0f 85 35 ff ff ff    	jne    f2 <ls+0x52>
      if(de.inum == 0)
 1bd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
 1c2:	74 dc                	je     1a0 <ls+0x100>
        continue;
      memmove(p, de.name, DIRSIZ);
 1c4:	8d 45 da             	lea    -0x26(%ebp),%eax
 1c7:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 1ce:	00 
 1cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d3:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1d9:	89 14 24             	mov    %edx,(%esp)
 1dc:	e8 bf 02 00 00       	call   4a0 <memmove>
      p[DIRSIZ] = 0;
 1e1:	8b 85 b4 fd ff ff    	mov    -0x24c(%ebp),%eax
      if(stat(buf, &st) < 0){
 1e7:	8d 95 c4 fd ff ff    	lea    -0x23c(%ebp),%edx
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
 1ed:	c6 40 0e 00          	movb   $0x0,0xe(%eax)
      if(stat(buf, &st) < 0){
 1f1:	89 74 24 04          	mov    %esi,0x4(%esp)
 1f5:	89 14 24             	mov    %edx,(%esp)
 1f8:	e8 e3 03 00 00       	call   5e0 <stat>
 1fd:	85 c0                	test   %eax,%eax
 1ff:	0f 88 b3 00 00 00    	js     2b8 <ls+0x218>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 205:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
 209:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 20c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 20f:	89 85 b0 fd ff ff    	mov    %eax,-0x250(%ebp)
 215:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 21b:	89 04 24             	mov    %eax,(%esp)
 21e:	89 95 ac fd ff ff    	mov    %edx,-0x254(%ebp)
 224:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
 22a:	e8 d1 fd ff ff       	call   0 <fmtname>
 22f:	8b 95 ac fd ff ff    	mov    -0x254(%ebp),%edx
 235:	89 54 24 14          	mov    %edx,0x14(%esp)
 239:	8b 8d a8 fd ff ff    	mov    -0x258(%ebp),%ecx
 23f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 243:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 249:	89 44 24 08          	mov    %eax,0x8(%esp)
 24d:	c7 44 24 04 96 0b 00 	movl   $0xb96,0x4(%esp)
 254:	00 
 255:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25c:	89 54 24 0c          	mov    %edx,0xc(%esp)
 260:	e8 8b 05 00 00       	call   7f0 <printf>
 265:	e9 36 ff ff ff       	jmp    1a0 <ls+0x100>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    break;
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "ls: path too long\n");
 270:	c7 44 24 04 a3 0b 00 	movl   $0xba3,0x4(%esp)
 277:	00 
 278:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 27f:	e8 6c 05 00 00       	call   7f0 <printf>
      break;
 284:	e9 69 fe ff ff       	jmp    f2 <ls+0x52>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    printf(2, "ls: cannot open %s\n", path);
 290:	89 7c 24 08          	mov    %edi,0x8(%esp)
 294:	c7 44 24 04 6e 0b 00 	movl   $0xb6e,0x4(%esp)
 29b:	00 
 29c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2a3:	e8 48 05 00 00       	call   7f0 <printf>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
}
 2a8:	81 c4 6c 02 00 00    	add    $0x26c,%esp
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	90                   	nop
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf(1, "ls: cannot stat %s\n", buf);
 2b8:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 2be:	89 44 24 08          	mov    %eax,0x8(%esp)
 2c2:	c7 44 24 04 82 0b 00 	movl   $0xb82,0x4(%esp)
 2c9:	00 
 2ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d1:	e8 1a 05 00 00       	call   7f0 <printf>
        continue;
 2d6:	e9 c5 fe ff ff       	jmp    1a0 <ls+0x100>
 2db:	90                   	nop
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
    printf(2, "ls: cannot stat %s\n", path);
 2e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
 2e4:	c7 44 24 04 82 0b 00 	movl   $0xb82,0x4(%esp)
 2eb:	00 
 2ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2f3:	e8 f8 04 00 00       	call   7f0 <printf>
    close(fd);
 2f8:	89 1c 24             	mov    %ebx,(%esp)
 2fb:	e8 c8 03 00 00       	call   6c8 <close>
    return;
 300:	e9 f5 fd ff ff       	jmp    fa <ls+0x5a>
 305:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 e4 f0             	and    $0xfffffff0,%esp
 316:	57                   	push   %edi
 317:	56                   	push   %esi
 318:	53                   	push   %ebx
  int i;

  if(argc < 2){
    ls(".");
    exit();
 319:	bb 01 00 00 00       	mov    $0x1,%ebx
  close(fd);
}

int
main(int argc, char *argv[])
{
 31e:	83 ec 14             	sub    $0x14,%esp
 321:	8b 75 08             	mov    0x8(%ebp),%esi
 324:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  if(argc < 2){
 327:	83 fe 01             	cmp    $0x1,%esi
 32a:	7e 1c                	jle    348 <main+0x38>
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 330:	8b 04 9f             	mov    (%edi,%ebx,4),%eax

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 333:	83 c3 01             	add    $0x1,%ebx
    ls(argv[i]);
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 62 fd ff ff       	call   a0 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 33e:	39 de                	cmp    %ebx,%esi
 340:	7f ee                	jg     330 <main+0x20>
    ls(argv[i]);
  exit();
 342:	e8 51 03 00 00       	call   698 <exit>
 347:	90                   	nop
main(int argc, char *argv[])
{
  int i;

  if(argc < 2){
    ls(".");
 348:	c7 04 24 b6 0b 00 00 	movl   $0xbb6,(%esp)
 34f:	e8 4c fd ff ff       	call   a0 <ls>
    exit();
 354:	e8 3f 03 00 00       	call   698 <exit>
 359:	90                   	nop
 35a:	90                   	nop
 35b:	90                   	nop
 35c:	90                   	nop
 35d:	90                   	nop
 35e:	90                   	nop
 35f:	90                   	nop

00000360 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 360:	55                   	push   %ebp
 361:	31 d2                	xor    %edx,%edx
 363:	89 e5                	mov    %esp,%ebp
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	53                   	push   %ebx
 369:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 370:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 374:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 377:	83 c2 01             	add    $0x1,%edx
 37a:	84 c9                	test   %cl,%cl
 37c:	75 f2                	jne    370 <strcpy+0x10>
    ;
  return os;
}
 37e:	5b                   	pop    %ebx
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
 381:	eb 0d                	jmp    390 <strcmp>
 383:	90                   	nop
 384:	90                   	nop
 385:	90                   	nop
 386:	90                   	nop
 387:	90                   	nop
 388:	90                   	nop
 389:	90                   	nop
 38a:	90                   	nop
 38b:	90                   	nop
 38c:	90                   	nop
 38d:	90                   	nop
 38e:	90                   	nop
 38f:	90                   	nop

00000390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
 397:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 39a:	0f b6 01             	movzbl (%ecx),%eax
 39d:	84 c0                	test   %al,%al
 39f:	75 14                	jne    3b5 <strcmp+0x25>
 3a1:	eb 25                	jmp    3c8 <strcmp+0x38>
 3a3:	90                   	nop
 3a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
 3a8:	83 c1 01             	add    $0x1,%ecx
 3ab:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3ae:	0f b6 01             	movzbl (%ecx),%eax
 3b1:	84 c0                	test   %al,%al
 3b3:	74 13                	je     3c8 <strcmp+0x38>
 3b5:	0f b6 1a             	movzbl (%edx),%ebx
 3b8:	38 d8                	cmp    %bl,%al
 3ba:	74 ec                	je     3a8 <strcmp+0x18>
 3bc:	0f b6 db             	movzbl %bl,%ebx
 3bf:	0f b6 c0             	movzbl %al,%eax
 3c2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3c4:	5b                   	pop    %ebx
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3c8:	0f b6 1a             	movzbl (%edx),%ebx
 3cb:	31 c0                	xor    %eax,%eax
 3cd:	0f b6 db             	movzbl %bl,%ebx
 3d0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3d2:	5b                   	pop    %ebx
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strlen>:

uint
strlen(char *s)
{
 3e0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e3:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
 3e5:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 3e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3ea:	80 39 00             	cmpb   $0x0,(%ecx)
 3ed:	74 0c                	je     3fb <strlen+0x1b>
 3ef:	90                   	nop
 3f0:	83 c2 01             	add    $0x1,%edx
 3f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3f7:	89 d0                	mov    %edx,%eax
 3f9:	75 f5                	jne    3f0 <strlen+0x10>
    ;
  return n;
}
 3fb:	5d                   	pop    %ebp
 3fc:	c3                   	ret    
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	8b 55 08             	mov    0x8(%ebp),%edx
 406:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	89 d0                	mov    %edx,%eax
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	89 f6                	mov    %esi,%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	8b 45 08             	mov    0x8(%ebp),%eax
 426:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42a:	0f b6 10             	movzbl (%eax),%edx
 42d:	84 d2                	test   %dl,%dl
 42f:	75 11                	jne    442 <strchr+0x22>
 431:	eb 15                	jmp    448 <strchr+0x28>
 433:	90                   	nop
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 438:	83 c0 01             	add    $0x1,%eax
 43b:	0f b6 10             	movzbl (%eax),%edx
 43e:	84 d2                	test   %dl,%dl
 440:	74 06                	je     448 <strchr+0x28>
    if(*s == c)
 442:	38 ca                	cmp    %cl,%dl
 444:	75 f2                	jne    438 <strchr+0x18>
      return (char*) s;
  return 0;
}
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 448:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
 44a:	5d                   	pop    %ebp
 44b:	90                   	nop
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 450:	c3                   	ret    
 451:	eb 0d                	jmp    460 <atoi>
 453:	90                   	nop
 454:	90                   	nop
 455:	90                   	nop
 456:	90                   	nop
 457:	90                   	nop
 458:	90                   	nop
 459:	90                   	nop
 45a:	90                   	nop
 45b:	90                   	nop
 45c:	90                   	nop
 45d:	90                   	nop
 45e:	90                   	nop
 45f:	90                   	nop

00000460 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 460:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 461:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
 463:	89 e5                	mov    %esp,%ebp
 465:	8b 4d 08             	mov    0x8(%ebp),%ecx
 468:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 469:	0f b6 11             	movzbl (%ecx),%edx
 46c:	8d 5a d0             	lea    -0x30(%edx),%ebx
 46f:	80 fb 09             	cmp    $0x9,%bl
 472:	77 1c                	ja     490 <atoi+0x30>
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
 478:	0f be d2             	movsbl %dl,%edx
 47b:	83 c1 01             	add    $0x1,%ecx
 47e:	8d 04 80             	lea    (%eax,%eax,4),%eax
 481:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 485:	0f b6 11             	movzbl (%ecx),%edx
 488:	8d 5a d0             	lea    -0x30(%edx),%ebx
 48b:	80 fb 09             	cmp    $0x9,%bl
 48e:	76 e8                	jbe    478 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 490:	5b                   	pop    %ebx
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
 493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	53                   	push   %ebx
 4a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ae:	85 db                	test   %ebx,%ebx
 4b0:	7e 14                	jle    4c6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
 4b2:	31 d2                	xor    %edx,%edx
 4b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
 4b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4c2:	39 da                	cmp    %ebx,%edx
 4c4:	75 f2                	jne    4b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 4c6:	5b                   	pop    %ebx
 4c7:	5e                   	pop    %esi
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004d0 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4d6:	57                   	push   %edi
 4d7:	56                   	push   %esi
 4d8:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 4d9:	80 39 00             	cmpb   $0x0,(%ecx)
 4dc:	74 37                	je     515 <reverse+0x45>
 4de:	31 d2                	xor    %edx,%edx
 4e0:	83 c2 01             	add    $0x1,%edx
 4e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 4e7:	75 f7                	jne    4e0 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 4e9:	8d 7a ff             	lea    -0x1(%edx),%edi
 4ec:	85 ff                	test   %edi,%edi
 4ee:	7e 25                	jle    515 <reverse+0x45>
 4f0:	8d 14 11             	lea    (%ecx,%edx,1),%edx
 4f3:	31 c0                	xor    %eax,%eax
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
 4f8:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 4fc:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
 4ff:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
 503:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
 506:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 508:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
 50b:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 50e:	83 ea 01             	sub    $0x1,%edx
 511:	39 f8                	cmp    %edi,%eax
 513:	7c e3                	jl     4f8 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 515:	5b                   	pop    %ebx
 516:	5e                   	pop    %esi
 517:	5f                   	pop    %edi
 518:	5d                   	pop    %ebp
 519:	c3                   	ret    
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000520 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 524:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
 529:	56                   	push   %esi
 52a:	53                   	push   %ebx
 52b:	31 db                	xor    %ebx,%ebx
 52d:	83 ec 04             	sub    $0x4,%esp
 530:	8b 45 08             	mov    0x8(%ebp),%eax
 533:	8b 75 0c             	mov    0xc(%ebp),%esi
 536:	89 45 f0             	mov    %eax,-0x10(%ebp)
 539:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 53c:	c1 f8 1f             	sar    $0x1f,%eax
 53f:	31 c1                	xor    %eax,%ecx
 541:	29 c1                	sub    %eax,%ecx
 543:	90                   	nop
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 548:	89 c8                	mov    %ecx,%eax
 54a:	f7 ef                	imul   %edi
 54c:	89 c8                	mov    %ecx,%eax
 54e:	c1 f8 1f             	sar    $0x1f,%eax
 551:	c1 fa 02             	sar    $0x2,%edx
 554:	29 c2                	sub    %eax,%edx
 556:	8d 04 92             	lea    (%edx,%edx,4),%eax
 559:	01 c0                	add    %eax,%eax
 55b:	29 c1                	sub    %eax,%ecx
 55d:	83 c1 30             	add    $0x30,%ecx
 560:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
 563:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
 566:	85 d2                	test   %edx,%edx
 568:	89 d1                	mov    %edx,%ecx
 56a:	7f dc                	jg     548 <itoa+0x28>
     if (sign < 0)
 56c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56f:	85 c0                	test   %eax,%eax
 571:	79 07                	jns    57a <itoa+0x5a>
         s[i++] = '-';
 573:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
 577:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
 57a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
 57e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
 581:	83 c4 04             	add    $0x4,%esp
 584:	5b                   	pop    %ebx
 585:	5e                   	pop    %esi
 586:	5f                   	pop    %edi
 587:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
 588:	e9 43 ff ff ff       	jmp    4d0 <reverse>
 58d:	8d 76 00             	lea    0x0(%esi),%esi

00000590 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
 590:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 591:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
 593:	89 e5                	mov    %esp,%ebp
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	57                   	push   %edi
 599:	8b 7d 0c             	mov    0xc(%ebp),%edi
 59c:	56                   	push   %esi
 59d:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 59e:	31 db                	xor    %ebx,%ebx
 5a0:	80 38 00             	cmpb   $0x0,(%eax)
 5a3:	74 0e                	je     5b3 <strcat+0x23>
 5a5:	8d 76 00             	lea    0x0(%esi),%esi
 5a8:	83 c2 01             	add    $0x1,%edx
 5ab:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
 5af:	75 f7                	jne    5a8 <strcat+0x18>
 5b1:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
 5b3:	0f b6 0f             	movzbl (%edi),%ecx
 5b6:	84 c9                	test   %cl,%cl
 5b8:	74 18                	je     5d2 <strcat+0x42>
 5ba:	8d 34 10             	lea    (%eax,%edx,1),%esi
 5bd:	31 db                	xor    %ebx,%ebx
 5bf:	90                   	nop
 5c0:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
 5c3:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 5c5:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
 5c9:	83 c6 01             	add    $0x1,%esi
 5cc:	84 c9                	test   %cl,%cl
 5ce:	75 f0                	jne    5c0 <strcat+0x30>
 5d0:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 5d2:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    
 5db:	90                   	nop
 5dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005e0 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
 5e9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 5ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
 5ef:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5fb:	00 
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 dc 00 00 00       	call   6e0 <open>
  if(fd < 0)
 604:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 606:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 608:	78 19                	js     623 <stat+0x43>
    return -1;
  r = fstat(fd, st);
 60a:	8b 45 0c             	mov    0xc(%ebp),%eax
 60d:	89 1c 24             	mov    %ebx,(%esp)
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	e8 df 00 00 00       	call   6f8 <fstat>
  close(fd);
 619:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 61c:	89 c6                	mov    %eax,%esi
  close(fd);
 61e:	e8 a5 00 00 00       	call   6c8 <close>
  return r;
}
 623:	89 f0                	mov    %esi,%eax
 625:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 628:	8b 75 fc             	mov    -0x4(%ebp),%esi
 62b:	89 ec                	mov    %ebp,%esp
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    
 62f:	90                   	nop

00000630 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	31 f6                	xor    %esi,%esi
 637:	53                   	push   %ebx
 638:	83 ec 2c             	sub    $0x2c,%esp
 63b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 63e:	eb 06                	jmp    646 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 640:	3c 0a                	cmp    $0xa,%al
 642:	74 39                	je     67d <gets+0x4d>
 644:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 646:	8d 5e 01             	lea    0x1(%esi),%ebx
 649:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 64c:	7d 31                	jge    67f <gets+0x4f>
    cc = read(0, &c, 1);
 64e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 651:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 658:	00 
 659:	89 44 24 04          	mov    %eax,0x4(%esp)
 65d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 664:	e8 4f 00 00 00       	call   6b8 <read>
    if(cc < 1)
 669:	85 c0                	test   %eax,%eax
 66b:	7e 12                	jle    67f <gets+0x4f>
      break;
    buf[i++] = c;
 66d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 671:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 675:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 679:	3c 0d                	cmp    $0xd,%al
 67b:	75 c3                	jne    640 <gets+0x10>
 67d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 67f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 683:	89 f8                	mov    %edi,%eax
 685:	83 c4 2c             	add    $0x2c,%esp
 688:	5b                   	pop    %ebx
 689:	5e                   	pop    %esi
 68a:	5f                   	pop    %edi
 68b:	5d                   	pop    %ebp
 68c:	c3                   	ret    
 68d:	90                   	nop
 68e:	90                   	nop
 68f:	90                   	nop

00000690 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 690:	b8 01 00 00 00       	mov    $0x1,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <exit>:
SYSCALL(exit)
 698:	b8 02 00 00 00       	mov    $0x2,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <wait>:
SYSCALL(wait)
 6a0:	b8 03 00 00 00       	mov    $0x3,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <wait2>:
SYSCALL(wait2)
 6a8:	b8 16 00 00 00       	mov    $0x16,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <pipe>:
SYSCALL(pipe)
 6b0:	b8 04 00 00 00       	mov    $0x4,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <read>:
SYSCALL(read)
 6b8:	b8 06 00 00 00       	mov    $0x6,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <write>:
SYSCALL(write)
 6c0:	b8 05 00 00 00       	mov    $0x5,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <close>:
SYSCALL(close)
 6c8:	b8 07 00 00 00       	mov    $0x7,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <kill>:
SYSCALL(kill)
 6d0:	b8 08 00 00 00       	mov    $0x8,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <exec>:
SYSCALL(exec)
 6d8:	b8 09 00 00 00       	mov    $0x9,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <open>:
SYSCALL(open)
 6e0:	b8 0a 00 00 00       	mov    $0xa,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <mknod>:
SYSCALL(mknod)
 6e8:	b8 0b 00 00 00       	mov    $0xb,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <unlink>:
SYSCALL(unlink)
 6f0:	b8 0c 00 00 00       	mov    $0xc,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <fstat>:
SYSCALL(fstat)
 6f8:	b8 0d 00 00 00       	mov    $0xd,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <link>:
SYSCALL(link)
 700:	b8 0e 00 00 00       	mov    $0xe,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <mkdir>:
SYSCALL(mkdir)
 708:	b8 0f 00 00 00       	mov    $0xf,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <chdir>:
SYSCALL(chdir)
 710:	b8 10 00 00 00       	mov    $0x10,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <dup>:
SYSCALL(dup)
 718:	b8 11 00 00 00       	mov    $0x11,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <getpid>:
SYSCALL(getpid)
 720:	b8 12 00 00 00       	mov    $0x12,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <sbrk>:
SYSCALL(sbrk)
 728:	b8 13 00 00 00       	mov    $0x13,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <sleep>:
SYSCALL(sleep)
 730:	b8 14 00 00 00       	mov    $0x14,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <uptime>:
SYSCALL(uptime)
 738:	b8 15 00 00 00       	mov    $0x15,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <nice>:
SYSCALL(nice)
 740:	b8 17 00 00 00       	mov    $0x17,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    
 748:	90                   	nop
 749:	90                   	nop
 74a:	90                   	nop
 74b:	90                   	nop
 74c:	90                   	nop
 74d:	90                   	nop
 74e:	90                   	nop
 74f:	90                   	nop

00000750 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	57                   	push   %edi
 754:	89 cf                	mov    %ecx,%edi
 756:	56                   	push   %esi
 757:	89 c6                	mov    %eax,%esi
 759:	53                   	push   %ebx
 75a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 75d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 760:	85 c9                	test   %ecx,%ecx
 762:	74 04                	je     768 <printint+0x18>
 764:	85 d2                	test   %edx,%edx
 766:	78 70                	js     7d8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 768:	89 d0                	mov    %edx,%eax
 76a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 771:	31 c9                	xor    %ecx,%ecx
 773:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 776:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 778:	31 d2                	xor    %edx,%edx
 77a:	f7 f7                	div    %edi
 77c:	0f b6 92 bf 0b 00 00 	movzbl 0xbbf(%edx),%edx
 783:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
 786:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
 789:	85 c0                	test   %eax,%eax
 78b:	75 eb                	jne    778 <printint+0x28>
  if(neg)
 78d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 790:	85 c0                	test   %eax,%eax
 792:	74 08                	je     79c <printint+0x4c>
    buf[i++] = '-';
 794:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
 799:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
 79c:	8d 79 ff             	lea    -0x1(%ecx),%edi
 79f:	01 fb                	add    %edi,%ebx
 7a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7a8:	0f b6 03             	movzbl (%ebx),%eax
 7ab:	83 ef 01             	sub    $0x1,%edi
 7ae:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7b8:	00 
 7b9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7bc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7bf:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c6:	e8 f5 fe ff ff       	call   6c0 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7cb:	83 ff ff             	cmp    $0xffffffff,%edi
 7ce:	75 d8                	jne    7a8 <printint+0x58>
    putc(fd, buf[i]);
}
 7d0:	83 c4 4c             	add    $0x4c,%esp
 7d3:	5b                   	pop    %ebx
 7d4:	5e                   	pop    %esi
 7d5:	5f                   	pop    %edi
 7d6:	5d                   	pop    %ebp
 7d7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 7d8:	89 d0                	mov    %edx,%eax
 7da:	f7 d8                	neg    %eax
 7dc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 7e3:	eb 8c                	jmp    771 <printint+0x21>
 7e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007f0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	57                   	push   %edi
 7f4:	56                   	push   %esi
 7f5:	53                   	push   %ebx
 7f6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fc:	0f b6 10             	movzbl (%eax),%edx
 7ff:	84 d2                	test   %dl,%dl
 801:	0f 84 c9 00 00 00    	je     8d0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 807:	8d 4d 10             	lea    0x10(%ebp),%ecx
 80a:	31 ff                	xor    %edi,%edi
 80c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 80f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 811:	8d 75 e7             	lea    -0x19(%ebp),%esi
 814:	eb 1e                	jmp    834 <printf+0x44>
 816:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 818:	83 fa 25             	cmp    $0x25,%edx
 81b:	0f 85 b7 00 00 00    	jne    8d8 <printf+0xe8>
 821:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 825:	83 c3 01             	add    $0x1,%ebx
 828:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 82c:	84 d2                	test   %dl,%dl
 82e:	0f 84 9c 00 00 00    	je     8d0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
 834:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 836:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
 839:	74 dd                	je     818 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 83b:	83 ff 25             	cmp    $0x25,%edi
 83e:	75 e5                	jne    825 <printf+0x35>
      if(c == 'd'){
 840:	83 fa 64             	cmp    $0x64,%edx
 843:	0f 84 57 01 00 00    	je     9a0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 849:	83 fa 70             	cmp    $0x70,%edx
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 850:	0f 84 aa 00 00 00    	je     900 <printf+0x110>
 856:	83 fa 78             	cmp    $0x78,%edx
 859:	0f 84 a1 00 00 00    	je     900 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 85f:	83 fa 73             	cmp    $0x73,%edx
 862:	0f 84 c0 00 00 00    	je     928 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 868:	83 fa 63             	cmp    $0x63,%edx
 86b:	90                   	nop
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 870:	0f 84 52 01 00 00    	je     9c8 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 876:	83 fa 25             	cmp    $0x25,%edx
 879:	0f 84 f9 00 00 00    	je     978 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 87f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 882:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 885:	31 ff                	xor    %edi,%edi
 887:	89 55 cc             	mov    %edx,-0x34(%ebp)
 88a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 88e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 895:	00 
 896:	89 0c 24             	mov    %ecx,(%esp)
 899:	89 74 24 04          	mov    %esi,0x4(%esp)
 89d:	e8 1e fe ff ff       	call   6c0 <write>
 8a2:	8b 55 cc             	mov    -0x34(%ebp),%edx
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8af:	00 
 8b0:	89 74 24 04          	mov    %esi,0x4(%esp)
 8b4:	88 55 e7             	mov    %dl,-0x19(%ebp)
 8b7:	89 04 24             	mov    %eax,(%esp)
 8ba:	e8 01 fe ff ff       	call   6c0 <write>
 8bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8c2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
 8c6:	84 d2                	test   %dl,%dl
 8c8:	0f 85 66 ff ff ff    	jne    834 <printf+0x44>
 8ce:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8d0:	83 c4 3c             	add    $0x3c,%esp
 8d3:	5b                   	pop    %ebx
 8d4:	5e                   	pop    %esi
 8d5:	5f                   	pop    %edi
 8d6:	5d                   	pop    %ebp
 8d7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8db:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 8de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8e5:	00 
 8e6:	89 74 24 04          	mov    %esi,0x4(%esp)
 8ea:	89 04 24             	mov    %eax,(%esp)
 8ed:	e8 ce fd ff ff       	call   6c0 <write>
 8f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8f5:	e9 2b ff ff ff       	jmp    825 <printf+0x35>
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 903:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
 908:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 90a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 911:	8b 10                	mov    (%eax),%edx
 913:	8b 45 08             	mov    0x8(%ebp),%eax
 916:	e8 35 fe ff ff       	call   750 <printint>
 91b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 91e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 922:	e9 fe fe ff ff       	jmp    825 <printf+0x35>
 927:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
 928:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 92b:	8b 3a                	mov    (%edx),%edi
        ap++;
 92d:	83 c2 04             	add    $0x4,%edx
 930:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
 933:	85 ff                	test   %edi,%edi
 935:	0f 84 ba 00 00 00    	je     9f5 <printf+0x205>
          s = "(null)";
        while(*s != 0){
 93b:	0f b6 17             	movzbl (%edi),%edx
 93e:	84 d2                	test   %dl,%dl
 940:	74 2d                	je     96f <printf+0x17f>
 942:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 945:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
 948:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 94b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 94e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 955:	00 
 956:	89 74 24 04          	mov    %esi,0x4(%esp)
 95a:	89 1c 24             	mov    %ebx,(%esp)
 95d:	e8 5e fd ff ff       	call   6c0 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 962:	0f b6 17             	movzbl (%edi),%edx
 965:	84 d2                	test   %dl,%dl
 967:	75 df                	jne    948 <printf+0x158>
 969:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 96c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 96f:	31 ff                	xor    %edi,%edi
 971:	e9 af fe ff ff       	jmp    825 <printf+0x35>
 976:	66 90                	xchg   %ax,%ax
 978:	8b 55 08             	mov    0x8(%ebp),%edx
 97b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 97d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 981:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 988:	00 
 989:	89 74 24 04          	mov    %esi,0x4(%esp)
 98d:	89 14 24             	mov    %edx,(%esp)
 990:	e8 2b fd ff ff       	call   6c0 <write>
 995:	8b 45 0c             	mov    0xc(%ebp),%eax
 998:	e9 88 fe ff ff       	jmp    825 <printf+0x35>
 99d:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 9a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 9a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
 9a8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 9ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9b2:	8b 10                	mov    (%eax),%edx
 9b4:	8b 45 08             	mov    0x8(%ebp),%eax
 9b7:	e8 94 fd ff ff       	call   750 <printint>
 9bc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
 9bf:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 9c3:	e9 5d fe ff ff       	jmp    825 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9c8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
 9cb:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9cd:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9d6:	00 
 9d7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9db:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 9de:	8b 45 08             	mov    0x8(%ebp),%eax
 9e1:	89 04 24             	mov    %eax,(%esp)
 9e4:	e8 d7 fc ff ff       	call   6c0 <write>
 9e9:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 9ec:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 9f0:	e9 30 fe ff ff       	jmp    825 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
 9f5:	bf b8 0b 00 00       	mov    $0xbb8,%edi
 9fa:	e9 3c ff ff ff       	jmp    93b <printf+0x14b>
 9ff:	90                   	nop

00000a00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a00:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a01:	a1 e8 0b 00 00       	mov    0xbe8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 a06:	89 e5                	mov    %esp,%ebp
 a08:	57                   	push   %edi
 a09:	56                   	push   %esi
 a0a:	53                   	push   %ebx
 a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
 a0e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a11:	39 c8                	cmp    %ecx,%eax
 a13:	73 1d                	jae    a32 <free+0x32>
 a15:	8d 76 00             	lea    0x0(%esi),%esi
 a18:	8b 10                	mov    (%eax),%edx
 a1a:	39 d1                	cmp    %edx,%ecx
 a1c:	72 1a                	jb     a38 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a1e:	39 d0                	cmp    %edx,%eax
 a20:	72 08                	jb     a2a <free+0x2a>
 a22:	39 c8                	cmp    %ecx,%eax
 a24:	72 12                	jb     a38 <free+0x38>
 a26:	39 d1                	cmp    %edx,%ecx
 a28:	72 0e                	jb     a38 <free+0x38>
 a2a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2c:	39 c8                	cmp    %ecx,%eax
 a2e:	66 90                	xchg   %ax,%ax
 a30:	72 e6                	jb     a18 <free+0x18>
 a32:	8b 10                	mov    (%eax),%edx
 a34:	eb e8                	jmp    a1e <free+0x1e>
 a36:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a38:	8b 71 04             	mov    0x4(%ecx),%esi
 a3b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a3e:	39 d7                	cmp    %edx,%edi
 a40:	74 19                	je     a5b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 a42:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 a45:	8b 50 04             	mov    0x4(%eax),%edx
 a48:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a4b:	39 ce                	cmp    %ecx,%esi
 a4d:	74 23                	je     a72 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 a4f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 a51:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 a56:	5b                   	pop    %ebx
 a57:	5e                   	pop    %esi
 a58:	5f                   	pop    %edi
 a59:	5d                   	pop    %ebp
 a5a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a5b:	03 72 04             	add    0x4(%edx),%esi
 a5e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a61:	8b 10                	mov    (%eax),%edx
 a63:	8b 12                	mov    (%edx),%edx
 a65:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a68:	8b 50 04             	mov    0x4(%eax),%edx
 a6b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a6e:	39 ce                	cmp    %ecx,%esi
 a70:	75 dd                	jne    a4f <free+0x4f>
    p->s.size += bp->s.size;
 a72:	03 51 04             	add    0x4(%ecx),%edx
 a75:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a78:	8b 53 f8             	mov    -0x8(%ebx),%edx
 a7b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
 a7d:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 a82:	5b                   	pop    %ebx
 a83:	5e                   	pop    %esi
 a84:	5f                   	pop    %edi
 a85:	5d                   	pop    %ebp
 a86:	c3                   	ret    
 a87:	89 f6                	mov    %esi,%esi
 a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	57                   	push   %edi
 a94:	56                   	push   %esi
 a95:	53                   	push   %ebx
 a96:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
 a9c:	8b 0d e8 0b 00 00    	mov    0xbe8,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa2:	83 c3 07             	add    $0x7,%ebx
 aa5:	c1 eb 03             	shr    $0x3,%ebx
 aa8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 aab:	85 c9                	test   %ecx,%ecx
 aad:	0f 84 93 00 00 00    	je     b46 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 ab5:	8b 50 04             	mov    0x4(%eax),%edx
 ab8:	39 d3                	cmp    %edx,%ebx
 aba:	76 1f                	jbe    adb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
 abc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 ac3:	90                   	nop
 ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
 ac8:	3b 05 e8 0b 00 00    	cmp    0xbe8,%eax
 ace:	74 30                	je     b00 <malloc+0x70>
 ad0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
 ad4:	8b 50 04             	mov    0x4(%eax),%edx
 ad7:	39 d3                	cmp    %edx,%ebx
 ad9:	77 ed                	ja     ac8 <malloc+0x38>
      if(p->s.size == nunits)
 adb:	39 d3                	cmp    %edx,%ebx
 add:	74 61                	je     b40 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 adf:	29 da                	sub    %ebx,%edx
 ae1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ae4:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 ae7:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 aea:	89 0d e8 0b 00 00    	mov    %ecx,0xbe8
      return (void*) (p + 1);
 af0:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 af3:	83 c4 1c             	add    $0x1c,%esp
 af6:	5b                   	pop    %ebx
 af7:	5e                   	pop    %esi
 af8:	5f                   	pop    %edi
 af9:	5d                   	pop    %ebp
 afa:	c3                   	ret    
 afb:	90                   	nop
 afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 b00:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
 b06:	b8 00 80 00 00       	mov    $0x8000,%eax
 b0b:	bf 00 10 00 00       	mov    $0x1000,%edi
 b10:	76 04                	jbe    b16 <malloc+0x86>
 b12:	89 f0                	mov    %esi,%eax
 b14:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 b16:	89 04 24             	mov    %eax,(%esp)
 b19:	e8 0a fc ff ff       	call   728 <sbrk>
  if(p == (char*) -1)
 b1e:	83 f8 ff             	cmp    $0xffffffff,%eax
 b21:	74 18                	je     b3b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 b23:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 b26:	83 c0 08             	add    $0x8,%eax
 b29:	89 04 24             	mov    %eax,(%esp)
 b2c:	e8 cf fe ff ff       	call   a00 <free>
  return freep;
 b31:	8b 0d e8 0b 00 00    	mov    0xbe8,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 b37:	85 c9                	test   %ecx,%ecx
 b39:	75 97                	jne    ad2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b3b:	31 c0                	xor    %eax,%eax
 b3d:	eb b4                	jmp    af3 <malloc+0x63>
 b3f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 b40:	8b 10                	mov    (%eax),%edx
 b42:	89 11                	mov    %edx,(%ecx)
 b44:	eb a4                	jmp    aea <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 b46:	c7 05 e8 0b 00 00 e0 	movl   $0xbe0,0xbe8
 b4d:	0b 00 00 
    base.s.size = 0;
 b50:	b9 e0 0b 00 00       	mov    $0xbe0,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 b55:	c7 05 e0 0b 00 00 e0 	movl   $0xbe0,0xbe0
 b5c:	0b 00 00 
    base.s.size = 0;
 b5f:	c7 05 e4 0b 00 00 00 	movl   $0x0,0xbe4
 b66:	00 00 00 
 b69:	e9 45 ff ff ff       	jmp    ab3 <malloc+0x23>
