
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <strcat>:
void panic(char*);
struct cmd *parsecmd(char*);

char *
strcat(char *dest, const char *src)
{
       0:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
       1:	31 d2                	xor    %edx,%edx
void panic(char*);
struct cmd *parsecmd(char*);

char *
strcat(char *dest, const char *src)
{
       3:	89 e5                	mov    %esp,%ebp
       5:	8b 45 08             	mov    0x8(%ebp),%eax
       8:	57                   	push   %edi
       9:	8b 7d 0c             	mov    0xc(%ebp),%edi
       c:	56                   	push   %esi
       d:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
       e:	31 db                	xor    %ebx,%ebx
      10:	80 38 00             	cmpb   $0x0,(%eax)
      13:	74 0e                	je     23 <strcat+0x23>
      15:	8d 76 00             	lea    0x0(%esi),%esi
      18:	83 c2 01             	add    $0x1,%edx
      1b:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
      1f:	75 f7                	jne    18 <strcat+0x18>
      21:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
      23:	0f b6 0f             	movzbl (%edi),%ecx
      26:	84 c9                	test   %cl,%cl
      28:	74 18                	je     42 <strcat+0x42>
      2a:	8d 34 10             	lea    (%eax,%edx,1),%esi
      2d:	31 db                	xor    %ebx,%ebx
      2f:	90                   	nop
      30:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
      33:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
      35:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
      39:	83 c6 01             	add    $0x1,%esi
      3c:	84 c9                	test   %cl,%cl
      3e:	75 f0                	jne    30 <strcat+0x30>
      40:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
      42:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
      46:	5b                   	pop    %ebx
      47:	5e                   	pop    %esi
      48:	5f                   	pop    %edi
      49:	5d                   	pop    %ebp
      4a:	c3                   	ret    
      4b:	90                   	nop
      4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000050 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
      50:	55                   	push   %ebp
      51:	89 e5                	mov    %esp,%ebp
      53:	53                   	push   %ebx
      54:	83 ec 14             	sub    $0x14,%esp
      57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
      5a:	85 db                	test   %ebx,%ebx
      5c:	74 05                	je     63 <nulterminate+0x13>
    return 0;
  
  switch(cmd->type){
      5e:	83 3b 05             	cmpl   $0x5,(%ebx)
      61:	76 0d                	jbe    70 <nulterminate+0x20>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      63:	89 d8                	mov    %ebx,%eax
      65:	83 c4 14             	add    $0x14,%esp
      68:	5b                   	pop    %ebx
      69:	5d                   	pop    %ebp
      6a:	c3                   	ret    
      6b:	90                   	nop
      6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
      70:	8b 03                	mov    (%ebx),%eax
      72:	ff 24 85 d0 15 00 00 	jmp    *0x15d0(,%eax,4)
      79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
      80:	8b 43 04             	mov    0x4(%ebx),%eax
      83:	89 04 24             	mov    %eax,(%esp)
      86:	e8 c5 ff ff ff       	call   50 <nulterminate>
    nulterminate(lcmd->right);
      8b:	8b 43 08             	mov    0x8(%ebx),%eax
      8e:	89 04 24             	mov    %eax,(%esp)
      91:	e8 ba ff ff ff       	call   50 <nulterminate>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      96:	89 d8                	mov    %ebx,%eax
      98:	83 c4 14             	add    $0x14,%esp
      9b:	5b                   	pop    %ebx
      9c:	5d                   	pop    %ebp
      9d:	c3                   	ret    
      9e:	66 90                	xchg   %ax,%ax
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
      a0:	8b 43 04             	mov    0x4(%ebx),%eax
      a3:	89 04 24             	mov    %eax,(%esp)
      a6:	e8 a5 ff ff ff       	call   50 <nulterminate>
    break;
  }
  return cmd;
}
      ab:	89 d8                	mov    %ebx,%eax
      ad:	83 c4 14             	add    $0x14,%esp
      b0:	5b                   	pop    %ebx
      b1:	5d                   	pop    %ebp
      b2:	c3                   	ret    
      b3:	90                   	nop
      b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
      b8:	8b 43 04             	mov    0x4(%ebx),%eax
      bb:	89 04 24             	mov    %eax,(%esp)
      be:	e8 8d ff ff ff       	call   50 <nulterminate>
    *rcmd->efile = 0;
      c3:	8b 43 0c             	mov    0xc(%ebx),%eax
      c6:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      c9:	89 d8                	mov    %ebx,%eax
      cb:	83 c4 14             	add    $0x14,%esp
      ce:	5b                   	pop    %ebx
      cf:	5d                   	pop    %ebp
      d0:	c3                   	ret    
      d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      d8:	8b 43 04             	mov    0x4(%ebx),%eax
      db:	85 c0                	test   %eax,%eax
      dd:	74 84                	je     63 <nulterminate+0x13>
      df:	89 d8                	mov    %ebx,%eax
      e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
      e8:	8b 50 2c             	mov    0x2c(%eax),%edx
      eb:	c6 02 00             	movb   $0x0,(%edx)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      ee:	8b 50 08             	mov    0x8(%eax),%edx
      f1:	83 c0 04             	add    $0x4,%eax
      f4:	85 d2                	test   %edx,%edx
      f6:	75 f0                	jne    e8 <nulterminate+0x98>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      f8:	89 d8                	mov    %ebx,%eax
      fa:	83 c4 14             	add    $0x14,%esp
      fd:	5b                   	pop    %ebx
      fe:	5d                   	pop    %ebp
      ff:	c3                   	ret    

00000100 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
     100:	55                   	push   %ebp
     101:	89 e5                	mov    %esp,%ebp
     103:	57                   	push   %edi
     104:	56                   	push   %esi
     105:	53                   	push   %ebx
     106:	83 ec 1c             	sub    $0x1c,%esp
     109:	8b 7d 08             	mov    0x8(%ebp),%edi
     10c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;
  
  s = *ps;
     10f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     111:	39 f3                	cmp    %esi,%ebx
     113:	72 0a                	jb     11f <peek+0x1f>
     115:	eb 1f                	jmp    136 <peek+0x36>
     117:	90                   	nop
    s++;
     118:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     11b:	39 de                	cmp    %ebx,%esi
     11d:	76 17                	jbe    136 <peek+0x36>
     11f:	0f be 03             	movsbl (%ebx),%eax
     122:	c7 04 24 38 17 00 00 	movl   $0x1738,(%esp)
     129:	89 44 24 04          	mov    %eax,0x4(%esp)
     12d:	e8 5e 0e 00 00       	call   f90 <strchr>
     132:	85 c0                	test   %eax,%eax
     134:	75 e2                	jne    118 <peek+0x18>
    s++;
  *ps = s;
     136:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     138:	0f b6 13             	movzbl (%ebx),%edx
     13b:	31 c0                	xor    %eax,%eax
     13d:	84 d2                	test   %dl,%dl
     13f:	75 0f                	jne    150 <peek+0x50>
}
     141:	83 c4 1c             	add    $0x1c,%esp
     144:	5b                   	pop    %ebx
     145:	5e                   	pop    %esi
     146:	5f                   	pop    %edi
     147:	5d                   	pop    %ebp
     148:	c3                   	ret    
     149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     150:	0f be d2             	movsbl %dl,%edx
     153:	89 54 24 04          	mov    %edx,0x4(%esp)
     157:	8b 45 10             	mov    0x10(%ebp),%eax
     15a:	89 04 24             	mov    %eax,(%esp)
     15d:	e8 2e 0e 00 00       	call   f90 <strchr>
     162:	85 c0                	test   %eax,%eax
     164:	0f 95 c0             	setne  %al
}
     167:	83 c4 1c             	add    $0x1c,%esp
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     16a:	0f b6 c0             	movzbl %al,%eax
}
     16d:	5b                   	pop    %ebx
     16e:	5e                   	pop    %esi
     16f:	5f                   	pop    %edi
     170:	5d                   	pop    %ebp
     171:	c3                   	ret    
     172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     180:	55                   	push   %ebp
     181:	89 e5                	mov    %esp,%ebp
     183:	57                   	push   %edi
     184:	56                   	push   %esi
     185:	53                   	push   %ebx
     186:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;
  
  s = *ps;
     189:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     18c:	8b 75 0c             	mov    0xc(%ebp),%esi
     18f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;
  
  s = *ps;
     192:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     194:	39 f3                	cmp    %esi,%ebx
     196:	72 0f                	jb     1a7 <gettoken+0x27>
     198:	eb 24                	jmp    1be <gettoken+0x3e>
     19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     1a0:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     1a3:	39 de                	cmp    %ebx,%esi
     1a5:	76 17                	jbe    1be <gettoken+0x3e>
     1a7:	0f be 03             	movsbl (%ebx),%eax
     1aa:	c7 04 24 38 17 00 00 	movl   $0x1738,(%esp)
     1b1:	89 44 24 04          	mov    %eax,0x4(%esp)
     1b5:	e8 d6 0d 00 00       	call   f90 <strchr>
     1ba:	85 c0                	test   %eax,%eax
     1bc:	75 e2                	jne    1a0 <gettoken+0x20>
    s++;
  if(q)
     1be:	85 ff                	test   %edi,%edi
     1c0:	74 02                	je     1c4 <gettoken+0x44>
    *q = s;
     1c2:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     1c4:	0f b6 13             	movzbl (%ebx),%edx
     1c7:	0f be fa             	movsbl %dl,%edi
  switch(*s){
     1ca:	80 fa 3c             	cmp    $0x3c,%dl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
     1cd:	89 f8                	mov    %edi,%eax
  switch(*s){
     1cf:	7f 4f                	jg     220 <gettoken+0xa0>
     1d1:	80 fa 3b             	cmp    $0x3b,%dl
     1d4:	0f 8c a6 00 00 00    	jl     280 <gettoken+0x100>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     1da:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     1dd:	8b 55 14             	mov    0x14(%ebp),%edx
     1e0:	85 d2                	test   %edx,%edx
     1e2:	74 05                	je     1e9 <gettoken+0x69>
    *eq = s;
     1e4:	8b 45 14             	mov    0x14(%ebp),%eax
     1e7:	89 18                	mov    %ebx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     1e9:	39 f3                	cmp    %esi,%ebx
     1eb:	72 0a                	jb     1f7 <gettoken+0x77>
     1ed:	eb 1f                	jmp    20e <gettoken+0x8e>
     1ef:	90                   	nop
    s++;
     1f0:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     1f3:	39 de                	cmp    %ebx,%esi
     1f5:	76 17                	jbe    20e <gettoken+0x8e>
     1f7:	0f be 03             	movsbl (%ebx),%eax
     1fa:	c7 04 24 38 17 00 00 	movl   $0x1738,(%esp)
     201:	89 44 24 04          	mov    %eax,0x4(%esp)
     205:	e8 86 0d 00 00       	call   f90 <strchr>
     20a:	85 c0                	test   %eax,%eax
     20c:	75 e2                	jne    1f0 <gettoken+0x70>
    s++;
  *ps = s;
     20e:	8b 45 08             	mov    0x8(%ebp),%eax
     211:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     213:	83 c4 1c             	add    $0x1c,%esp
     216:	89 f8                	mov    %edi,%eax
     218:	5b                   	pop    %ebx
     219:	5e                   	pop    %esi
     21a:	5f                   	pop    %edi
     21b:	5d                   	pop    %ebp
     21c:	c3                   	ret    
     21d:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     220:	80 fa 3e             	cmp    $0x3e,%dl
     223:	0f 84 7f 00 00 00    	je     2a8 <gettoken+0x128>
     229:	80 fa 7c             	cmp    $0x7c,%dl
     22c:	74 ac                	je     1da <gettoken+0x5a>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     22e:	39 de                	cmp    %ebx,%esi
     230:	77 2f                	ja     261 <gettoken+0xe1>
     232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     238:	eb 3b                	jmp    275 <gettoken+0xf5>
     23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     240:	0f be 03             	movsbl (%ebx),%eax
     243:	c7 04 24 3e 17 00 00 	movl   $0x173e,(%esp)
     24a:	89 44 24 04          	mov    %eax,0x4(%esp)
     24e:	e8 3d 0d 00 00       	call   f90 <strchr>
     253:	85 c0                	test   %eax,%eax
     255:	75 1e                	jne    275 <gettoken+0xf5>
      s++;
     257:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     25a:	39 de                	cmp    %ebx,%esi
     25c:	76 17                	jbe    275 <gettoken+0xf5>
     25e:	0f be 03             	movsbl (%ebx),%eax
     261:	89 44 24 04          	mov    %eax,0x4(%esp)
     265:	c7 04 24 38 17 00 00 	movl   $0x1738,(%esp)
     26c:	e8 1f 0d 00 00       	call   f90 <strchr>
     271:	85 c0                	test   %eax,%eax
     273:	74 cb                	je     240 <gettoken+0xc0>
     275:	bf 61 00 00 00       	mov    $0x61,%edi
     27a:	e9 5e ff ff ff       	jmp    1dd <gettoken+0x5d>
     27f:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     280:	80 fa 29             	cmp    $0x29,%dl
     283:	7f a9                	jg     22e <gettoken+0xae>
     285:	80 fa 28             	cmp    $0x28,%dl
     288:	0f 8d 4c ff ff ff    	jge    1da <gettoken+0x5a>
     28e:	84 d2                	test   %dl,%dl
     290:	0f 84 47 ff ff ff    	je     1dd <gettoken+0x5d>
     296:	80 fa 26             	cmp    $0x26,%dl
     299:	75 93                	jne    22e <gettoken+0xae>
     29b:	90                   	nop
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     2a0:	e9 35 ff ff ff       	jmp    1da <gettoken+0x5a>
     2a5:	8d 76 00             	lea    0x0(%esi),%esi
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     2a8:	83 c3 01             	add    $0x1,%ebx
    if(*s == '>'){
     2ab:	80 3b 3e             	cmpb   $0x3e,(%ebx)
     2ae:	66 90                	xchg   %ax,%ax
     2b0:	0f 85 27 ff ff ff    	jne    1dd <gettoken+0x5d>
      ret = '+';
      s++;
     2b6:	83 c3 01             	add    $0x1,%ebx
     2b9:	bf 2b 00 00 00       	mov    $0x2b,%edi
     2be:	66 90                	xchg   %ax,%ax
     2c0:	e9 18 ff ff ff       	jmp    1dd <gettoken+0x5d>
     2c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <backcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
     2d0:	55                   	push   %ebp
     2d1:	89 e5                	mov    %esp,%ebp
     2d3:	53                   	push   %ebx
     2d4:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     2de:	e8 0d 12 00 00       	call   14f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     2e3:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     2ea:	00 
     2eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2f2:	00 
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2f5:	89 04 24             	mov    %eax,(%esp)
     2f8:	e8 73 0c 00 00       	call   f70 <memset>
  cmd->type = BACK;
     2fd:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     303:	8b 45 08             	mov    0x8(%ebp),%eax
     306:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     309:	89 d8                	mov    %ebx,%eax
     30b:	83 c4 14             	add    $0x14,%esp
     30e:	5b                   	pop    %ebx
     30f:	5d                   	pop    %ebp
     310:	c3                   	ret    
     311:	eb 0d                	jmp    320 <listcmd>
     313:	90                   	nop
     314:	90                   	nop
     315:	90                   	nop
     316:	90                   	nop
     317:	90                   	nop
     318:	90                   	nop
     319:	90                   	nop
     31a:	90                   	nop
     31b:	90                   	nop
     31c:	90                   	nop
     31d:	90                   	nop
     31e:	90                   	nop
     31f:	90                   	nop

00000320 <listcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     320:	55                   	push   %ebp
     321:	89 e5                	mov    %esp,%ebp
     323:	53                   	push   %ebx
     324:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     327:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     32e:	e8 bd 11 00 00       	call   14f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     333:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     33a:	00 
     33b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     342:	00 
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     343:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     345:	89 04 24             	mov    %eax,(%esp)
     348:	e8 23 0c 00 00       	call   f70 <memset>
  cmd->type = LIST;
     34d:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     353:	8b 45 08             	mov    0x8(%ebp),%eax
     356:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     359:	8b 45 0c             	mov    0xc(%ebp),%eax
     35c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     35f:	89 d8                	mov    %ebx,%eax
     361:	83 c4 14             	add    $0x14,%esp
     364:	5b                   	pop    %ebx
     365:	5d                   	pop    %ebp
     366:	c3                   	ret    
     367:	89 f6                	mov    %esi,%esi
     369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <pipecmd>:
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	53                   	push   %ebx
     374:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     377:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     37e:	e8 6d 11 00 00       	call   14f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     383:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     38a:	00 
     38b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     392:	00 
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     395:	89 04 24             	mov    %eax,(%esp)
     398:	e8 d3 0b 00 00       	call   f70 <memset>
  cmd->type = PIPE;
     39d:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3a3:	8b 45 08             	mov    0x8(%ebp),%eax
     3a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3af:	89 d8                	mov    %ebx,%eax
     3b1:	83 c4 14             	add    $0x14,%esp
     3b4:	5b                   	pop    %ebx
     3b5:	5d                   	pop    %ebp
     3b6:	c3                   	ret    
     3b7:	89 f6                	mov    %esi,%esi
     3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <redircmd>:
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3c0:	55                   	push   %ebp
     3c1:	89 e5                	mov    %esp,%ebp
     3c3:	53                   	push   %ebx
     3c4:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3c7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3ce:	e8 1d 11 00 00       	call   14f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3d3:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3da:	00 
     3db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3e2:	00 
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e5:	89 04 24             	mov    %eax,(%esp)
     3e8:	e8 83 0b 00 00       	call   f70 <memset>
  cmd->type = REDIR;
     3ed:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3f3:	8b 45 08             	mov    0x8(%ebp),%eax
     3f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fc:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3ff:	8b 45 10             	mov    0x10(%ebp),%eax
     402:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     405:	8b 45 14             	mov    0x14(%ebp),%eax
     408:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     40b:	8b 45 18             	mov    0x18(%ebp),%eax
     40e:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     411:	89 d8                	mov    %ebx,%eax
     413:	83 c4 14             	add    $0x14,%esp
     416:	5b                   	pop    %ebx
     417:	5d                   	pop    %ebp
     418:	c3                   	ret    
     419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     420:	55                   	push   %ebp
     421:	89 e5                	mov    %esp,%ebp
     423:	53                   	push   %ebx
     424:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     427:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     42e:	e8 bd 10 00 00       	call   14f0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     433:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     43a:	00 
     43b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     442:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     443:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     445:	89 04 24             	mov    %eax,(%esp)
     448:	e8 23 0b 00 00       	call   f70 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     44d:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
     44f:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     455:	83 c4 14             	add    $0x14,%esp
     458:	5b                   	pop    %ebx
     459:	5d                   	pop    %ebp
     45a:	c3                   	ret    
     45b:	90                   	nop
     45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000460 <panic>:
  exit();
}

void
panic(char *s)
{
     460:	55                   	push   %ebp
     461:	89 e5                	mov    %esp,%ebp
     463:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     466:	8b 45 08             	mov    0x8(%ebp),%eax
     469:	c7 44 24 04 69 16 00 	movl   $0x1669,0x4(%esp)
     470:	00 
     471:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     478:	89 44 24 08          	mov    %eax,0x8(%esp)
     47c:	e8 cf 0d 00 00       	call   1250 <printf>
  exit();
     481:	e8 72 0c 00 00       	call   10f8 <exit>
     486:	8d 76 00             	lea    0x0(%esi),%esi
     489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000490 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     490:	55                   	push   %ebp
     491:	89 e5                	mov    %esp,%ebp
     493:	57                   	push   %edi
     494:	56                   	push   %esi
     495:	53                   	push   %ebx
     496:	83 ec 3c             	sub    $0x3c,%esp
     499:	8b 7d 0c             	mov    0xc(%ebp),%edi
     49c:	8b 75 10             	mov    0x10(%ebp),%esi
     49f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4a0:	c7 44 24 08 1d 16 00 	movl   $0x161d,0x8(%esp)
     4a7:	00 
     4a8:	89 74 24 04          	mov    %esi,0x4(%esp)
     4ac:	89 3c 24             	mov    %edi,(%esp)
     4af:	e8 4c fc ff ff       	call   100 <peek>
     4b4:	85 c0                	test   %eax,%eax
     4b6:	0f 84 a4 00 00 00    	je     560 <parseredirs+0xd0>
    tok = gettoken(ps, es, 0, 0);
     4bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     4c3:	00 
     4c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     4cb:	00 
     4cc:	89 74 24 04          	mov    %esi,0x4(%esp)
     4d0:	89 3c 24             	mov    %edi,(%esp)
     4d3:	e8 a8 fc ff ff       	call   180 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d8:	89 74 24 04          	mov    %esi,0x4(%esp)
     4dc:	89 3c 24             	mov    %edi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
     4df:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     4e1:	8d 45 e0             	lea    -0x20(%ebp),%eax
     4e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     4e8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     4eb:	89 44 24 08          	mov    %eax,0x8(%esp)
     4ef:	e8 8c fc ff ff       	call   180 <gettoken>
     4f4:	83 f8 61             	cmp    $0x61,%eax
     4f7:	74 0c                	je     505 <parseredirs+0x75>
      panic("missing file for redirection");
     4f9:	c7 04 24 00 16 00 00 	movl   $0x1600,(%esp)
     500:	e8 5b ff ff ff       	call   460 <panic>
    switch(tok){
     505:	83 fb 3c             	cmp    $0x3c,%ebx
     508:	74 3e                	je     548 <parseredirs+0xb8>
     50a:	83 fb 3e             	cmp    $0x3e,%ebx
     50d:	74 05                	je     514 <parseredirs+0x84>
     50f:	83 fb 2b             	cmp    $0x2b,%ebx
     512:	75 8c                	jne    4a0 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     514:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     51b:	00 
     51c:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     523:	00 
     524:	8b 45 e0             	mov    -0x20(%ebp),%eax
     527:	89 44 24 08          	mov    %eax,0x8(%esp)
     52b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     52e:	89 44 24 04          	mov    %eax,0x4(%esp)
     532:	8b 45 08             	mov    0x8(%ebp),%eax
     535:	89 04 24             	mov    %eax,(%esp)
     538:	e8 83 fe ff ff       	call   3c0 <redircmd>
     53d:	89 45 08             	mov    %eax,0x8(%ebp)
     540:	e9 5b ff ff ff       	jmp    4a0 <parseredirs+0x10>
     545:	8d 76 00             	lea    0x0(%esi),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     548:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     54f:	00 
     550:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     557:	00 
     558:	eb ca                	jmp    524 <parseredirs+0x94>
     55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     560:	8b 45 08             	mov    0x8(%ebp),%eax
     563:	83 c4 3c             	add    $0x3c,%esp
     566:	5b                   	pop    %ebx
     567:	5e                   	pop    %esi
     568:	5f                   	pop    %edi
     569:	5d                   	pop    %ebp
     56a:	c3                   	ret    
     56b:	90                   	nop
     56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000570 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     570:	55                   	push   %ebp
     571:	89 e5                	mov    %esp,%ebp
     573:	57                   	push   %edi
     574:	56                   	push   %esi
     575:	53                   	push   %ebx
     576:	83 ec 3c             	sub    $0x3c,%esp
     579:	8b 75 08             	mov    0x8(%ebp),%esi
     57c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     57f:	c7 44 24 08 20 16 00 	movl   $0x1620,0x8(%esp)
     586:	00 
     587:	89 34 24             	mov    %esi,(%esp)
     58a:	89 7c 24 04          	mov    %edi,0x4(%esp)
     58e:	e8 6d fb ff ff       	call   100 <peek>
     593:	85 c0                	test   %eax,%eax
     595:	0f 85 cd 00 00 00    	jne    668 <parseexec+0xf8>
    return parseblock(ps, es);

  ret = execcmd();
     59b:	e8 80 fe ff ff       	call   420 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5a0:	31 db                	xor    %ebx,%ebx
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     5a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5a5:	89 7c 24 08          	mov    %edi,0x8(%esp)
     5a9:	89 74 24 04          	mov    %esi,0x4(%esp)
     5ad:	89 04 24             	mov    %eax,(%esp)
     5b0:	e8 db fe ff ff       	call   490 <parseredirs>
     5b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
     5b8:	eb 1c                	jmp    5d6 <parseexec+0x66>
     5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     5c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
     5c4:	89 74 24 04          	mov    %esi,0x4(%esp)
     5c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
     5cb:	89 04 24             	mov    %eax,(%esp)
     5ce:	e8 bd fe ff ff       	call   490 <parseredirs>
     5d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     5d6:	c7 44 24 08 37 16 00 	movl   $0x1637,0x8(%esp)
     5dd:	00 
     5de:	89 7c 24 04          	mov    %edi,0x4(%esp)
     5e2:	89 34 24             	mov    %esi,(%esp)
     5e5:	e8 16 fb ff ff       	call   100 <peek>
     5ea:	85 c0                	test   %eax,%eax
     5ec:	75 5a                	jne    648 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5f1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
     5f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     5f8:	89 54 24 08          	mov    %edx,0x8(%esp)
     5fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
     600:	89 34 24             	mov    %esi,(%esp)
     603:	e8 78 fb ff ff       	call   180 <gettoken>
     608:	85 c0                	test   %eax,%eax
     60a:	74 3c                	je     648 <parseexec+0xd8>
      break;
    if(tok != 'a')
     60c:	83 f8 61             	cmp    $0x61,%eax
     60f:	74 0c                	je     61d <parseexec+0xad>
      panic("syntax");
     611:	c7 04 24 22 16 00 00 	movl   $0x1622,(%esp)
     618:	e8 43 fe ff ff       	call   460 <panic>
    cmd->argv[argc] = q;
     61d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     620:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     623:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     627:	8b 45 e0             	mov    -0x20(%ebp),%eax
     62a:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     62e:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     631:	83 fb 09             	cmp    $0x9,%ebx
     634:	7e 8a                	jle    5c0 <parseexec+0x50>
      panic("too many args");
     636:	c7 04 24 29 16 00 00 	movl   $0x1629,(%esp)
     63d:	e8 1e fe ff ff       	call   460 <panic>
     642:	e9 79 ff ff ff       	jmp    5c0 <parseexec+0x50>
     647:	90                   	nop
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     648:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     64b:	c7 44 9a 04 00 00 00 	movl   $0x0,0x4(%edx,%ebx,4)
     652:	00 
  cmd->eargv[argc] = 0;
     653:	c7 44 9a 2c 00 00 00 	movl   $0x0,0x2c(%edx,%ebx,4)
     65a:	00 
  return ret;
}
     65b:	8b 45 d0             	mov    -0x30(%ebp),%eax
     65e:	83 c4 3c             	add    $0x3c,%esp
     661:	5b                   	pop    %ebx
     662:	5e                   	pop    %esi
     663:	5f                   	pop    %edi
     664:	5d                   	pop    %ebp
     665:	c3                   	ret    
     666:	66 90                	xchg   %ax,%ax
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);
     668:	89 7c 24 04          	mov    %edi,0x4(%esp)
     66c:	89 34 24             	mov    %esi,(%esp)
     66f:	e8 6c 01 00 00       	call   7e0 <parseblock>
     674:	89 45 d0             	mov    %eax,-0x30(%ebp)
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     677:	8b 45 d0             	mov    -0x30(%ebp),%eax
     67a:	83 c4 3c             	add    $0x3c,%esp
     67d:	5b                   	pop    %ebx
     67e:	5e                   	pop    %esi
     67f:	5f                   	pop    %edi
     680:	5d                   	pop    %ebp
     681:	c3                   	ret    
     682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000690 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     690:	55                   	push   %ebp
     691:	89 e5                	mov    %esp,%ebp
     693:	83 ec 28             	sub    $0x28,%esp
     696:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     699:	8b 5d 08             	mov    0x8(%ebp),%ebx
     69c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     69f:	8b 75 0c             	mov    0xc(%ebp),%esi
     6a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     6a5:	89 1c 24             	mov    %ebx,(%esp)
     6a8:	89 74 24 04          	mov    %esi,0x4(%esp)
     6ac:	e8 bf fe ff ff       	call   570 <parseexec>
  if(peek(ps, es, "|")){
     6b1:	c7 44 24 08 3c 16 00 	movl   $0x163c,0x8(%esp)
     6b8:	00 
     6b9:	89 74 24 04          	mov    %esi,0x4(%esp)
     6bd:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     6c0:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     6c2:	e8 39 fa ff ff       	call   100 <peek>
     6c7:	85 c0                	test   %eax,%eax
     6c9:	75 15                	jne    6e0 <parsepipe+0x50>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     6cb:	89 f8                	mov    %edi,%eax
     6cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     6d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
     6d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
     6d6:	89 ec                	mov    %ebp,%esp
     6d8:	5d                   	pop    %ebp
     6d9:	c3                   	ret    
     6da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     6e0:	89 74 24 04          	mov    %esi,0x4(%esp)
     6e4:	89 1c 24             	mov    %ebx,(%esp)
     6e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6ee:	00 
     6ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6f6:	00 
     6f7:	e8 84 fa ff ff       	call   180 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6fc:	89 74 24 04          	mov    %esi,0x4(%esp)
     700:	89 1c 24             	mov    %ebx,(%esp)
     703:	e8 88 ff ff ff       	call   690 <parsepipe>
  }
  return cmd;
}
     708:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     70b:	89 7d 08             	mov    %edi,0x8(%ebp)
  }
  return cmd;
}
     70e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     711:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     714:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     717:	89 ec                	mov    %ebp,%esp
     719:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     71a:	e9 51 fc ff ff       	jmp    370 <pipecmd>
     71f:	90                   	nop

00000720 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     720:	55                   	push   %ebp
     721:	89 e5                	mov    %esp,%ebp
     723:	57                   	push   %edi
     724:	56                   	push   %esi
     725:	53                   	push   %ebx
     726:	83 ec 1c             	sub    $0x1c,%esp
     729:	8b 5d 08             	mov    0x8(%ebp),%ebx
     72c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     72f:	89 1c 24             	mov    %ebx,(%esp)
     732:	89 74 24 04          	mov    %esi,0x4(%esp)
     736:	e8 55 ff ff ff       	call   690 <parsepipe>
     73b:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     73d:	eb 27                	jmp    766 <parseline+0x46>
     73f:	90                   	nop
    gettoken(ps, es, 0, 0);
     740:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     747:	00 
     748:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     74f:	00 
     750:	89 74 24 04          	mov    %esi,0x4(%esp)
     754:	89 1c 24             	mov    %ebx,(%esp)
     757:	e8 24 fa ff ff       	call   180 <gettoken>
    cmd = backcmd(cmd);
     75c:	89 3c 24             	mov    %edi,(%esp)
     75f:	e8 6c fb ff ff       	call   2d0 <backcmd>
     764:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     766:	c7 44 24 08 3e 16 00 	movl   $0x163e,0x8(%esp)
     76d:	00 
     76e:	89 74 24 04          	mov    %esi,0x4(%esp)
     772:	89 1c 24             	mov    %ebx,(%esp)
     775:	e8 86 f9 ff ff       	call   100 <peek>
     77a:	85 c0                	test   %eax,%eax
     77c:	75 c2                	jne    740 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     77e:	c7 44 24 08 3a 16 00 	movl   $0x163a,0x8(%esp)
     785:	00 
     786:	89 74 24 04          	mov    %esi,0x4(%esp)
     78a:	89 1c 24             	mov    %ebx,(%esp)
     78d:	e8 6e f9 ff ff       	call   100 <peek>
     792:	85 c0                	test   %eax,%eax
     794:	75 0a                	jne    7a0 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     796:	83 c4 1c             	add    $0x1c,%esp
     799:	89 f8                	mov    %edi,%eax
     79b:	5b                   	pop    %ebx
     79c:	5e                   	pop    %esi
     79d:	5f                   	pop    %edi
     79e:	5d                   	pop    %ebp
     79f:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     7a0:	89 74 24 04          	mov    %esi,0x4(%esp)
     7a4:	89 1c 24             	mov    %ebx,(%esp)
     7a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7ae:	00 
     7af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7b6:	00 
     7b7:	e8 c4 f9 ff ff       	call   180 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     7bc:	89 74 24 04          	mov    %esi,0x4(%esp)
     7c0:	89 1c 24             	mov    %ebx,(%esp)
     7c3:	e8 58 ff ff ff       	call   720 <parseline>
     7c8:	89 7d 08             	mov    %edi,0x8(%ebp)
     7cb:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     7ce:	83 c4 1c             	add    $0x1c,%esp
     7d1:	5b                   	pop    %ebx
     7d2:	5e                   	pop    %esi
     7d3:	5f                   	pop    %edi
     7d4:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     7d5:	e9 46 fb ff ff       	jmp    320 <listcmd>
     7da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007e0 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     7e0:	55                   	push   %ebp
     7e1:	89 e5                	mov    %esp,%ebp
     7e3:	83 ec 28             	sub    $0x28,%esp
     7e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     7e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     7ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
     7ef:	8b 75 0c             	mov    0xc(%ebp),%esi
     7f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     7f5:	c7 44 24 08 20 16 00 	movl   $0x1620,0x8(%esp)
     7fc:	00 
     7fd:	89 1c 24             	mov    %ebx,(%esp)
     800:	89 74 24 04          	mov    %esi,0x4(%esp)
     804:	e8 f7 f8 ff ff       	call   100 <peek>
     809:	85 c0                	test   %eax,%eax
     80b:	0f 84 87 00 00 00    	je     898 <parseblock+0xb8>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     811:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     818:	00 
     819:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     820:	00 
     821:	89 74 24 04          	mov    %esi,0x4(%esp)
     825:	89 1c 24             	mov    %ebx,(%esp)
     828:	e8 53 f9 ff ff       	call   180 <gettoken>
  cmd = parseline(ps, es);
     82d:	89 74 24 04          	mov    %esi,0x4(%esp)
     831:	89 1c 24             	mov    %ebx,(%esp)
     834:	e8 e7 fe ff ff       	call   720 <parseline>
  if(!peek(ps, es, ")"))
     839:	c7 44 24 08 5c 16 00 	movl   $0x165c,0x8(%esp)
     840:	00 
     841:	89 74 24 04          	mov    %esi,0x4(%esp)
     845:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     848:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     84a:	e8 b1 f8 ff ff       	call   100 <peek>
     84f:	85 c0                	test   %eax,%eax
     851:	75 0c                	jne    85f <parseblock+0x7f>
    panic("syntax - missing )");
     853:	c7 04 24 4b 16 00 00 	movl   $0x164b,(%esp)
     85a:	e8 01 fc ff ff       	call   460 <panic>
  gettoken(ps, es, 0, 0);
     85f:	89 74 24 04          	mov    %esi,0x4(%esp)
     863:	89 1c 24             	mov    %ebx,(%esp)
     866:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     86d:	00 
     86e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     875:	00 
     876:	e8 05 f9 ff ff       	call   180 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     87b:	89 74 24 08          	mov    %esi,0x8(%esp)
     87f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     883:	89 3c 24             	mov    %edi,(%esp)
     886:	e8 05 fc ff ff       	call   490 <parseredirs>
  return cmd;
}
     88b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     88e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     891:	8b 7d fc             	mov    -0x4(%ebp),%edi
     894:	89 ec                	mov    %ebp,%esp
     896:	5d                   	pop    %ebp
     897:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     898:	c7 04 24 40 16 00 00 	movl   $0x1640,(%esp)
     89f:	e8 bc fb ff ff       	call   460 <panic>
     8a4:	e9 68 ff ff ff       	jmp    811 <parseblock+0x31>
     8a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008b0 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     8b0:	55                   	push   %ebp
     8b1:	89 e5                	mov    %esp,%ebp
     8b3:	56                   	push   %esi
     8b4:	53                   	push   %ebx
     8b5:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     8b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
     8bb:	89 1c 24             	mov    %ebx,(%esp)
     8be:	e8 8d 06 00 00       	call   f50 <strlen>
     8c3:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     8c5:	8d 45 08             	lea    0x8(%ebp),%eax
     8c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     8cc:	89 04 24             	mov    %eax,(%esp)
     8cf:	e8 4c fe ff ff       	call   720 <parseline>
  peek(&s, es, "");
     8d4:	c7 44 24 08 8b 16 00 	movl   $0x168b,0x8(%esp)
     8db:	00 
     8dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
     8e0:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     8e2:	8d 45 08             	lea    0x8(%ebp),%eax
     8e5:	89 04 24             	mov    %eax,(%esp)
     8e8:	e8 13 f8 ff ff       	call   100 <peek>
  if(s != es){
     8ed:	8b 45 08             	mov    0x8(%ebp),%eax
     8f0:	39 d8                	cmp    %ebx,%eax
     8f2:	74 24                	je     918 <parsecmd+0x68>
    printf(2, "leftovers: %s\n", s);
     8f4:	89 44 24 08          	mov    %eax,0x8(%esp)
     8f8:	c7 44 24 04 5e 16 00 	movl   $0x165e,0x4(%esp)
     8ff:	00 
     900:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     907:	e8 44 09 00 00       	call   1250 <printf>
    panic("syntax");
     90c:	c7 04 24 22 16 00 00 	movl   $0x1622,(%esp)
     913:	e8 48 fb ff ff       	call   460 <panic>
  }
  nulterminate(cmd);
     918:	89 34 24             	mov    %esi,(%esp)
     91b:	e8 30 f7 ff ff       	call   50 <nulterminate>
  return cmd;
}
     920:	83 c4 10             	add    $0x10,%esp
     923:	89 f0                	mov    %esi,%eax
     925:	5b                   	pop    %ebx
     926:	5e                   	pop    %esi
     927:	5d                   	pop    %ebp
     928:	c3                   	ret    
     929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000930 <fork1>:
  exit();
}

int
fork1(void)
{
     930:	55                   	push   %ebp
     931:	89 e5                	mov    %esp,%ebp
     933:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     936:	e8 b5 07 00 00       	call   10f0 <fork>
  if(pid == -1)
     93b:	83 f8 ff             	cmp    $0xffffffff,%eax
     93e:	74 08                	je     948 <fork1+0x18>
    panic("fork");
  return pid;
}
     940:	c9                   	leave  
     941:	c3                   	ret    
     942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
     948:	c7 04 24 6d 16 00 00 	movl   $0x166d,(%esp)
     94f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     952:	e8 09 fb ff ff       	call   460 <panic>
     957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return pid;
}
     95a:	c9                   	leave  
     95b:	c3                   	ret    
     95c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000960 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	83 ec 18             	sub    $0x18,%esp
     966:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     969:	8b 5d 08             	mov    0x8(%ebp),%ebx
     96c:	89 75 fc             	mov    %esi,-0x4(%ebp)
     96f:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     972:	c7 44 24 04 72 16 00 	movl   $0x1672,0x4(%esp)
     979:	00 
     97a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     981:	e8 ca 08 00 00       	call   1250 <printf>
  memset(buf, 0, nbuf);
     986:	89 74 24 08          	mov    %esi,0x8(%esp)
     98a:	89 1c 24             	mov    %ebx,(%esp)
     98d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     994:	00 
     995:	e8 d6 05 00 00       	call   f70 <memset>
  gets(buf, nbuf);
     99a:	89 74 24 04          	mov    %esi,0x4(%esp)
     99e:	89 1c 24             	mov    %ebx,(%esp)
     9a1:	e8 ea 06 00 00       	call   1090 <gets>
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     9a6:	8b 75 fc             	mov    -0x4(%ebp),%esi
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     9a9:	80 3b 01             	cmpb   $0x1,(%ebx)
    return -1;
  return 0;
}
     9ac:	8b 5d f8             	mov    -0x8(%ebp),%ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     9af:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
     9b1:	89 ec                	mov    %ebp,%esp
     9b3:	5d                   	pop    %ebp
     9b4:	c3                   	ret    
     9b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     9b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000009c0 <myexec>:
	exit();
}
return arrpath;
}

int myexec(char* path, char** argv, char** arrpath, int len) {
     9c0:	55                   	push   %ebp
     9c1:	89 e5                	mov    %esp,%ebp
     9c3:	57                   	push   %edi
     9c4:	56                   	push   %esi
     9c5:	53                   	push   %ebx
     9c6:	83 ec 1c             	sub    $0x1c,%esp
int i=0;
while(i<=len) {
     9c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
	exit();
}
return arrpath;
}

int myexec(char* path, char** argv, char** arrpath, int len) {
     9cc:	8b 7d 08             	mov    0x8(%ebp),%edi
     9cf:	8b 75 10             	mov    0x10(%ebp),%esi
int i=0;
while(i<=len) {
     9d2:	85 c9                	test   %ecx,%ecx
     9d4:	78 2b                	js     a01 <myexec+0x41>
     9d6:	31 db                	xor    %ebx,%ebx
strcat(arrpath[i],path);
     9d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
     9dc:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
     9df:	89 04 24             	mov    %eax,(%esp)
     9e2:	e8 19 f6 ff ff       	call   0 <strcat>
exec(arrpath[i],argv);
     9e7:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ea:	89 44 24 04          	mov    %eax,0x4(%esp)
     9ee:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
i++;
     9f1:	83 c3 01             	add    $0x1,%ebx

int myexec(char* path, char** argv, char** arrpath, int len) {
int i=0;
while(i<=len) {
strcat(arrpath[i],path);
exec(arrpath[i],argv);
     9f4:	89 04 24             	mov    %eax,(%esp)
     9f7:	e8 3c 07 00 00       	call   1138 <exec>
return arrpath;
}

int myexec(char* path, char** argv, char** arrpath, int len) {
int i=0;
while(i<=len) {
     9fc:	39 5d 14             	cmp    %ebx,0x14(%ebp)
     9ff:	7d d7                	jge    9d8 <myexec+0x18>
strcat(arrpath[i],path);
exec(arrpath[i],argv);
i++;
}
return 0;
}
     a01:	83 c4 1c             	add    $0x1c,%esp
     a04:	31 c0                	xor    %eax,%eax
     a06:	5b                   	pop    %ebx
     a07:	5e                   	pop    %esi
     a08:	5f                   	pop    %edi
     a09:	5d                   	pop    %ebp
     a0a:	c3                   	ret    
     a0b:	90                   	nop
     a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000a10 <runcmd>:


// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd,char** arrpath,int len)
{
     a10:	55                   	push   %ebp
     a11:	89 e5                	mov    %esp,%ebp
     a13:	83 ec 38             	sub    $0x38,%esp
     a16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     a1f:	8b 75 0c             	mov    0xc(%ebp),%esi
     a22:	89 7d fc             	mov    %edi,-0x4(%ebp)
     a25:	8b 7d 10             	mov    0x10(%ebp),%edi
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a28:	85 db                	test   %ebx,%ebx
     a2a:	74 4a                	je     a76 <runcmd+0x66>
    exit();
  
  switch(cmd->type){
     a2c:	83 3b 05             	cmpl   $0x5,(%ebx)
     a2f:	76 4f                	jbe    a80 <runcmd+0x70>
  default:
    panic("runcmd");
     a31:	c7 04 24 75 16 00 00 	movl   $0x1675,(%esp)
     a38:	e8 23 fa ff ff       	call   460 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     a3d:	8b 43 04             	mov    0x4(%ebx),%eax
     a40:	85 c0                	test   %eax,%eax
     a42:	74 32                	je     a76 <runcmd+0x66>
      exit();
    myexec(ecmd->argv[0], ecmd->argv, arrpath, len);
     a44:	8d 53 04             	lea    0x4(%ebx),%edx
     a47:	89 7c 24 0c          	mov    %edi,0xc(%esp)
     a4b:	89 74 24 08          	mov    %esi,0x8(%esp)
     a4f:	89 54 24 04          	mov    %edx,0x4(%esp)
     a53:	89 04 24             	mov    %eax,(%esp)
     a56:	e8 65 ff ff ff       	call   9c0 <myexec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     a5b:	8b 43 04             	mov    0x4(%ebx),%eax
     a5e:	c7 44 24 04 7c 16 00 	movl   $0x167c,0x4(%esp)
     a65:	00 
     a66:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a6d:	89 44 24 08          	mov    %eax,0x8(%esp)
     a71:	e8 da 07 00 00       	call   1250 <printf>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     a76:	e8 7d 06 00 00       	call   10f8 <exit>
     a7b:	90                   	nop
     a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();
  
  switch(cmd->type){
     a80:	8b 03                	mov    (%ebx),%eax
     a82:	ff 24 85 e8 15 00 00 	jmp    *0x15e8(,%eax,4)
     a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wait();
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     a90:	e8 9b fe ff ff       	call   930 <fork1>
     a95:	85 c0                	test   %eax,%eax
     a97:	0f 84 b8 00 00 00    	je     b55 <runcmd+0x145>
     a9d:	8d 76 00             	lea    0x0(%esi),%esi
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     aa0:	e8 53 06 00 00       	call   10f8 <exit>
     aa5:	8d 76 00             	lea    0x0(%esi),%esi
    runcmd(rcmd->cmd, arrpath, len);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     aa8:	e8 83 fe ff ff       	call   930 <fork1>
     aad:	85 c0                	test   %eax,%eax
     aaf:	90                   	nop
     ab0:	0f 84 ba 00 00 00    	je     b70 <runcmd+0x160>
      runcmd(lcmd->left, arrpath, len);
    wait();
     ab6:	e8 45 06 00 00       	call   1100 <wait>
    runcmd(lcmd->right, arrpath, len);
     abb:	89 7c 24 08          	mov    %edi,0x8(%esp)
     abf:	89 74 24 04          	mov    %esi,0x4(%esp)
     ac3:	8b 43 08             	mov    0x8(%ebx),%eax
     ac6:	89 04 24             	mov    %eax,(%esp)
     ac9:	e8 42 ff ff ff       	call   a10 <runcmd>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     ace:	e8 25 06 00 00       	call   10f8 <exit>
     ad3:	90                   	nop
     ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    runcmd(lcmd->right, arrpath, len);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     ad8:	8d 45 e0             	lea    -0x20(%ebp),%eax
     adb:	89 04 24             	mov    %eax,(%esp)
     ade:	e8 2d 06 00 00       	call   1110 <pipe>
     ae3:	85 c0                	test   %eax,%eax
     ae5:	0f 88 4d 01 00 00    	js     c38 <runcmd+0x228>
      panic("pipe");
    if(fork1() == 0){
     aeb:	e8 40 fe ff ff       	call   930 <fork1>
     af0:	85 c0                	test   %eax,%eax
     af2:	0f 84 d8 00 00 00    	je     bd0 <runcmd+0x1c0>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left, arrpath, len);
    }
    if(fork1() == 0){
     af8:	e8 33 fe ff ff       	call   930 <fork1>
     afd:	85 c0                	test   %eax,%eax
     aff:	90                   	nop
     b00:	0f 84 82 00 00 00    	je     b88 <runcmd+0x178>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right, arrpath, len);
    }
    close(p[0]);
     b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b09:	89 04 24             	mov    %eax,(%esp)
     b0c:	e8 17 06 00 00       	call   1128 <close>
    close(p[1]);
     b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b14:	89 04 24             	mov    %eax,(%esp)
     b17:	e8 0c 06 00 00       	call   1128 <close>
    wait();
     b1c:	e8 df 05 00 00       	call   1100 <wait>
    wait();
     b21:	e8 da 05 00 00       	call   1100 <wait>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     b26:	e8 cd 05 00 00       	call   10f8 <exit>
     b2b:	90                   	nop
     b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     b30:	8b 43 14             	mov    0x14(%ebx),%eax
     b33:	89 04 24             	mov    %eax,(%esp)
     b36:	e8 ed 05 00 00       	call   1128 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     b3b:	8b 43 10             	mov    0x10(%ebx),%eax
     b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
     b42:	8b 43 08             	mov    0x8(%ebx),%eax
     b45:	89 04 24             	mov    %eax,(%esp)
     b48:	e8 f3 05 00 00       	call   1140 <open>
     b4d:	85 c0                	test   %eax,%eax
     b4f:	0f 88 c3 00 00 00    	js     c18 <runcmd+0x208>
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
     b55:	89 7c 24 08          	mov    %edi,0x8(%esp)
     b59:	89 74 24 04          	mov    %esi,0x4(%esp)
     b5d:	8b 43 04             	mov    0x4(%ebx),%eax
     b60:	89 04 24             	mov    %eax,(%esp)
     b63:	e8 a8 fe ff ff       	call   a10 <runcmd>
    break;
  }
  exit();
     b68:	e8 8b 05 00 00       	call   10f8 <exit>
     b6d:	8d 76 00             	lea    0x0(%esi),%esi
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left, arrpath, len);
     b70:	89 7c 24 08          	mov    %edi,0x8(%esp)
     b74:	89 74 24 04          	mov    %esi,0x4(%esp)
     b78:	8b 43 04             	mov    0x4(%ebx),%eax
     b7b:	89 04 24             	mov    %eax,(%esp)
     b7e:	e8 8d fe ff ff       	call   a10 <runcmd>
     b83:	e9 2e ff ff ff       	jmp    ab6 <runcmd+0xa6>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left, arrpath, len);
    }
    if(fork1() == 0){
      close(0);
     b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b8f:	e8 94 05 00 00       	call   1128 <close>
      dup(p[0]);
     b94:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b97:	89 04 24             	mov    %eax,(%esp)
     b9a:	e8 d9 05 00 00       	call   1178 <dup>
      close(p[0]);
     b9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ba2:	89 04 24             	mov    %eax,(%esp)
     ba5:	e8 7e 05 00 00       	call   1128 <close>
      close(p[1]);
     baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bad:	89 04 24             	mov    %eax,(%esp)
     bb0:	e8 73 05 00 00       	call   1128 <close>
      runcmd(pcmd->right, arrpath, len);
     bb5:	89 7c 24 08          	mov    %edi,0x8(%esp)
     bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
     bbd:	8b 43 08             	mov    0x8(%ebx),%eax
     bc0:	89 04 24             	mov    %eax,(%esp)
     bc3:	e8 48 fe ff ff       	call   a10 <runcmd>
     bc8:	e9 39 ff ff ff       	jmp    b06 <runcmd+0xf6>
     bcd:	8d 76 00             	lea    0x0(%esi),%esi
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
     bd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bd7:	e8 4c 05 00 00       	call   1128 <close>
      dup(p[1]);
     bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bdf:	89 04 24             	mov    %eax,(%esp)
     be2:	e8 91 05 00 00       	call   1178 <dup>
      close(p[0]);
     be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bea:	89 04 24             	mov    %eax,(%esp)
     bed:	e8 36 05 00 00       	call   1128 <close>
      close(p[1]);
     bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bf5:	89 04 24             	mov    %eax,(%esp)
     bf8:	e8 2b 05 00 00       	call   1128 <close>
      runcmd(pcmd->left, arrpath, len);
     bfd:	89 7c 24 08          	mov    %edi,0x8(%esp)
     c01:	89 74 24 04          	mov    %esi,0x4(%esp)
     c05:	8b 43 04             	mov    0x4(%ebx),%eax
     c08:	89 04 24             	mov    %eax,(%esp)
     c0b:	e8 00 fe ff ff       	call   a10 <runcmd>
     c10:	e9 e3 fe ff ff       	jmp    af8 <runcmd+0xe8>
     c15:	8d 76 00             	lea    0x0(%esi),%esi

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     c18:	8b 43 08             	mov    0x8(%ebx),%eax
     c1b:	c7 44 24 04 8c 16 00 	movl   $0x168c,0x4(%esp)
     c22:	00 
     c23:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     c2a:	89 44 24 08          	mov    %eax,0x8(%esp)
     c2e:	e8 1d 06 00 00       	call   1250 <printf>
      exit();
     c33:	e8 c0 04 00 00       	call   10f8 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     c38:	c7 04 24 9c 16 00 00 	movl   $0x169c,(%esp)
     c3f:	e8 1c f8 ff ff       	call   460 <panic>
     c44:	e9 a2 fe ff ff       	jmp    aeb <runcmd+0xdb>
     c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c50 <parsepath>:
    dest[i+j] = '\0';
    return dest;
}


char** parsepath(int* i) {
     c50:	55                   	push   %ebp
     c51:	89 e5                	mov    %esp,%ebp
     c53:	57                   	push   %edi
     c54:	56                   	push   %esi
     c55:	53                   	push   %ebx
     c56:	83 ec 2c             	sub    $0x2c,%esp
     c59:	8b 7d 08             	mov    0x8(%ebp),%edi
int fd = open(".env",O_RDONLY);
     c5c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c63:	00 
     c64:	c7 04 24 a1 16 00 00 	movl   $0x16a1,(%esp)
     c6b:	e8 d0 04 00 00       	call   1140 <open>
char* buf = malloc(100);
     c70:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    return dest;
}


char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
     c77:	89 c6                	mov    %eax,%esi
char* buf = malloc(100);
     c79:	e8 72 08 00 00       	call   14f0 <malloc>
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
     c7e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
}


char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
     c85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
     c88:	e8 63 08 00 00       	call   14f0 <malloc>
char** arrpath = malloc(4);
     c8d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
     c94:	89 c3                	mov    %eax,%ebx
char** arrpath = malloc(4);
     c96:	e8 55 08 00 00       	call   14f0 <malloc>
if(fd < 0) {
     c9b:	85 f6                	test   %esi,%esi
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
char** arrpath = malloc(4);
     c9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
if(fd < 0) {
     ca0:	0f 88 c7 00 00 00    	js     d6d <parsepath+0x11d>
	printf(1,"no environment file: %d",fd);
	exit();
}
else {
	read(fd,pathstrt,5);
     ca6:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
     cad:	00 
     cae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     cb2:	89 34 24             	mov    %esi,(%esp)
     cb5:	e8 5e 04 00 00       	call   1118 <read>
	pathstrt[5] = '\0';
     cba:	c6 43 05 00          	movb   $0x0,0x5(%ebx)
	if(strcmp(pathstrt,"PATH=") == 0) {
     cbe:	c7 44 24 04 be 16 00 	movl   $0x16be,0x4(%esp)
     cc5:	00 
     cc6:	89 1c 24             	mov    %ebx,(%esp)
     cc9:	e8 32 02 00 00       	call   f00 <strcmp>
     cce:	85 c0                	test   %eax,%eax
     cd0:	0f 85 cd 00 00 00    	jne    da3 <parsepath+0x153>
}


char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
     cd6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
     cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
else {
	read(fd,pathstrt,5);
	pathstrt[5] = '\0';
	if(strcmp(pathstrt,"PATH=") == 0) {
		while(read(fd,buf,count)) {
     ce0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     ce7:	00 
     ce8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     cec:	89 34 24             	mov    %esi,(%esp)
     cef:	e8 24 04 00 00       	call   1118 <read>
     cf4:	85 c0                	test   %eax,%eax
     cf6:	74 50                	je     d48 <parsepath+0xf8>
			if((*buf) != ':') {
     cf8:	80 3b 3a             	cmpb   $0x3a,(%ebx)
     cfb:	74 0b                	je     d08 <parsepath+0xb8>
				//printf(1,"char: %c",*buf);
				buf+=1;
     cfd:	83 c3 01             	add    $0x1,%ebx
     d00:	eb de                	jmp    ce0 <parsepath+0x90>
     d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			}
			else {
				*buf = '\0';
     d08:	c6 03 00             	movb   $0x0,(%ebx)
				//printf(1," startis=%s ",start);
				arrpath[(*i)] = start;
     d0b:	8b 07                	mov    (%edi),%eax
     d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     d10:	8b 55 e0             	mov    -0x20(%ebp),%edx
     d13:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
				(*i)++;
     d16:	8b 1f                	mov    (%edi),%ebx
     d18:	83 c3 01             	add    $0x1,%ebx
     d1b:	89 1f                	mov    %ebx,(%edi)
				arrpath[(*i)] = malloc(4);
     d1d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     d24:	e8 c7 07 00 00       	call   14f0 <malloc>
     d29:	8b 55 e0             	mov    -0x20(%ebp),%edx
     d2c:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
				buf = start+100;
				buf = malloc(100);
     d2f:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     d36:	e8 b5 07 00 00       	call   14f0 <malloc>
     d3b:	89 c3                	mov    %eax,%ebx
     d3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     d40:	eb 9e                	jmp    ce0 <parsepath+0x90>
     d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				start = buf;
			}
		}
		*buf = '\0';
     d48:	c6 03 00             	movb   $0x0,(%ebx)
		arrpath[(*i)] = start;
     d4b:	8b 07                	mov    (%edi),%eax
     d4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     d50:	8b 4d e0             	mov    -0x20(%ebp),%ecx
     d53:	89 14 81             	mov    %edx,(%ecx,%eax,4)
	else {
		printf(1,".env isnt defined correctly");
		exit();
	}
}
if(close(fd) != 0) {
     d56:	89 34 24             	mov    %esi,(%esp)
     d59:	e8 ca 03 00 00       	call   1128 <close>
     d5e:	85 c0                	test   %eax,%eax
     d60:	75 28                	jne    d8a <parsepath+0x13a>
	printf(1,"error in closing the file descriptor");
	exit();
}
return arrpath;
}
     d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d65:	83 c4 2c             	add    $0x2c,%esp
     d68:	5b                   	pop    %ebx
     d69:	5e                   	pop    %esi
     d6a:	5f                   	pop    %edi
     d6b:	5d                   	pop    %ebp
     d6c:	c3                   	ret    
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
char** arrpath = malloc(4);
if(fd < 0) {
	printf(1,"no environment file: %d",fd);
     d6d:	89 74 24 08          	mov    %esi,0x8(%esp)
     d71:	c7 44 24 04 a6 16 00 	movl   $0x16a6,0x4(%esp)
     d78:	00 
     d79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d80:	e8 cb 04 00 00       	call   1250 <printf>
	exit();
     d85:	e8 6e 03 00 00       	call   10f8 <exit>
		printf(1,".env isnt defined correctly");
		exit();
	}
}
if(close(fd) != 0) {
	printf(1,"error in closing the file descriptor");
     d8a:	c7 44 24 04 f8 16 00 	movl   $0x16f8,0x4(%esp)
     d91:	00 
     d92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d99:	e8 b2 04 00 00       	call   1250 <printf>
	exit();
     d9e:	e8 55 03 00 00       	call   10f8 <exit>
		}
		*buf = '\0';
		arrpath[(*i)] = start;
	}
	else {
		printf(1,".env isnt defined correctly");
     da3:	c7 44 24 04 c4 16 00 	movl   $0x16c4,0x4(%esp)
     daa:	00 
     dab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     db2:	e8 99 04 00 00       	call   1250 <printf>
		exit();
     db7:	e8 3c 03 00 00       	call   10f8 <exit>
     dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000dc0 <main>:
  return 0;
}

int
main(void)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	83 e4 f0             	and    $0xfffffff0,%esp
     dc6:	56                   	push   %esi
     dc7:	53                   	push   %ebx
     dc8:	83 ec 28             	sub    $0x28,%esp
     dcb:	90                   	nop
     dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     dd0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     dd7:	00 
     dd8:	c7 04 24 e0 16 00 00 	movl   $0x16e0,(%esp)
     ddf:	e8 5c 03 00 00       	call   1140 <open>
     de4:	85 c0                	test   %eax,%eax
     de6:	78 0d                	js     df5 <main+0x35>
    if(fd >= 3){
     de8:	83 f8 02             	cmp    $0x2,%eax
     deb:	7e e3                	jle    dd0 <main+0x10>
      close(fd);
     ded:	89 04 24             	mov    %eax,(%esp)
     df0:	e8 33 03 00 00       	call   1128 <close>
      break;
    }
  }
int len = 0;
char** arrpath = parsepath(&len);
     df5:	8d 44 24 1c          	lea    0x1c(%esp),%eax
    if(fd >= 3){
      close(fd);
      break;
    }
  }
int len = 0;
     df9:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     e00:	00 
char** arrpath = parsepath(&len);
     e01:	89 04 24             	mov    %eax,(%esp)
     e04:	e8 47 fe ff ff       	call   c50 <parsepath>
     e09:	89 c6                	mov    %eax,%esi
//printf(1,"path: %s",arrpath[i]);
//i++;
//}

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     e0b:	eb 08                	jmp    e15 <main+0x55>
     e0d:	8d 76 00             	lea    0x0(%esi),%esi
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf),arrpath,len);
    wait();
     e10:	e8 eb 02 00 00       	call   1100 <wait>
//printf(1,"path: %s",arrpath[i]);
//i++;
//}

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     e15:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     e1c:	00 
     e1d:	c7 04 24 60 17 00 00 	movl   $0x1760,(%esp)
     e24:	e8 37 fb ff ff       	call   960 <getcmd>
     e29:	85 c0                	test   %eax,%eax
     e2b:	0f 88 97 00 00 00    	js     ec8 <main+0x108>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e31:	80 3d 60 17 00 00 63 	cmpb   $0x63,0x1760
     e38:	75 09                	jne    e43 <main+0x83>
     e3a:	80 3d 61 17 00 00 64 	cmpb   $0x64,0x1761
     e41:	74 2d                	je     e70 <main+0xb0>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
     e43:	e8 e8 fa ff ff       	call   930 <fork1>
     e48:	85 c0                	test   %eax,%eax
     e4a:	75 c4                	jne    e10 <main+0x50>
      runcmd(parsecmd(buf),arrpath,len);
     e4c:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
     e50:	c7 04 24 60 17 00 00 	movl   $0x1760,(%esp)
     e57:	e8 54 fa ff ff       	call   8b0 <parsecmd>
     e5c:	89 74 24 04          	mov    %esi,0x4(%esp)
     e60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     e64:	89 04 24             	mov    %eax,(%esp)
     e67:	e8 a4 fb ff ff       	call   a10 <runcmd>
     e6c:	eb a2                	jmp    e10 <main+0x50>
     e6e:	66 90                	xchg   %ax,%ax
//i++;
//}

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e70:	80 3d 62 17 00 00 20 	cmpb   $0x20,0x1762
     e77:	75 ca                	jne    e43 <main+0x83>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     e79:	c7 04 24 60 17 00 00 	movl   $0x1760,(%esp)
     e80:	e8 cb 00 00 00       	call   f50 <strlen>
      if(chdir(buf+3) < 0)
     e85:	c7 04 24 63 17 00 00 	movl   $0x1763,(%esp)
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     e8c:	c6 80 5f 17 00 00 00 	movb   $0x0,0x175f(%eax)
      if(chdir(buf+3) < 0)
     e93:	e8 d8 02 00 00       	call   1170 <chdir>
     e98:	85 c0                	test   %eax,%eax
     e9a:	0f 89 75 ff ff ff    	jns    e15 <main+0x55>
        printf(2, "cannot cd %s\n", buf+3);
     ea0:	c7 44 24 08 63 17 00 	movl   $0x1763,0x8(%esp)
     ea7:	00 
     ea8:	c7 44 24 04 e8 16 00 	movl   $0x16e8,0x4(%esp)
     eaf:	00 
     eb0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     eb7:	e8 94 03 00 00       	call   1250 <printf>
     ebc:	e9 54 ff ff ff       	jmp    e15 <main+0x55>
     ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf),arrpath,len);
    wait();
  }
  exit();
     ec8:	e8 2b 02 00 00       	call   10f8 <exit>
     ecd:	90                   	nop
     ece:	90                   	nop
     ecf:	90                   	nop

00000ed0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     ed0:	55                   	push   %ebp
     ed1:	31 d2                	xor    %edx,%edx
     ed3:	89 e5                	mov    %esp,%ebp
     ed5:	8b 45 08             	mov    0x8(%ebp),%eax
     ed8:	53                   	push   %ebx
     ed9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ee0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     ee4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     ee7:	83 c2 01             	add    $0x1,%edx
     eea:	84 c9                	test   %cl,%cl
     eec:	75 f2                	jne    ee0 <strcpy+0x10>
    ;
  return os;
}
     eee:	5b                   	pop    %ebx
     eef:	5d                   	pop    %ebp
     ef0:	c3                   	ret    
     ef1:	eb 0d                	jmp    f00 <strcmp>
     ef3:	90                   	nop
     ef4:	90                   	nop
     ef5:	90                   	nop
     ef6:	90                   	nop
     ef7:	90                   	nop
     ef8:	90                   	nop
     ef9:	90                   	nop
     efa:	90                   	nop
     efb:	90                   	nop
     efc:	90                   	nop
     efd:	90                   	nop
     efe:	90                   	nop
     eff:	90                   	nop

00000f00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f00:	55                   	push   %ebp
     f01:	89 e5                	mov    %esp,%ebp
     f03:	53                   	push   %ebx
     f04:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     f0a:	0f b6 01             	movzbl (%ecx),%eax
     f0d:	84 c0                	test   %al,%al
     f0f:	75 14                	jne    f25 <strcmp+0x25>
     f11:	eb 25                	jmp    f38 <strcmp+0x38>
     f13:	90                   	nop
     f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
     f18:	83 c1 01             	add    $0x1,%ecx
     f1b:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     f1e:	0f b6 01             	movzbl (%ecx),%eax
     f21:	84 c0                	test   %al,%al
     f23:	74 13                	je     f38 <strcmp+0x38>
     f25:	0f b6 1a             	movzbl (%edx),%ebx
     f28:	38 d8                	cmp    %bl,%al
     f2a:	74 ec                	je     f18 <strcmp+0x18>
     f2c:	0f b6 db             	movzbl %bl,%ebx
     f2f:	0f b6 c0             	movzbl %al,%eax
     f32:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     f34:	5b                   	pop    %ebx
     f35:	5d                   	pop    %ebp
     f36:	c3                   	ret    
     f37:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     f38:	0f b6 1a             	movzbl (%edx),%ebx
     f3b:	31 c0                	xor    %eax,%eax
     f3d:	0f b6 db             	movzbl %bl,%ebx
     f40:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     f42:	5b                   	pop    %ebx
     f43:	5d                   	pop    %ebp
     f44:	c3                   	ret    
     f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f50 <strlen>:

uint
strlen(char *s)
{
     f50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
     f51:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     f53:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
     f55:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     f57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     f5a:	80 39 00             	cmpb   $0x0,(%ecx)
     f5d:	74 0c                	je     f6b <strlen+0x1b>
     f5f:	90                   	nop
     f60:	83 c2 01             	add    $0x1,%edx
     f63:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     f67:	89 d0                	mov    %edx,%eax
     f69:	75 f5                	jne    f60 <strlen+0x10>
    ;
  return n;
}
     f6b:	5d                   	pop    %ebp
     f6c:	c3                   	ret    
     f6d:	8d 76 00             	lea    0x0(%esi),%esi

00000f70 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	8b 55 08             	mov    0x8(%ebp),%edx
     f76:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     f77:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7d:	89 d7                	mov    %edx,%edi
     f7f:	fc                   	cld    
     f80:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     f82:	89 d0                	mov    %edx,%eax
     f84:	5f                   	pop    %edi
     f85:	5d                   	pop    %ebp
     f86:	c3                   	ret    
     f87:	89 f6                	mov    %esi,%esi
     f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f90 <strchr>:

char*
strchr(const char *s, char c)
{
     f90:	55                   	push   %ebp
     f91:	89 e5                	mov    %esp,%ebp
     f93:	8b 45 08             	mov    0x8(%ebp),%eax
     f96:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     f9a:	0f b6 10             	movzbl (%eax),%edx
     f9d:	84 d2                	test   %dl,%dl
     f9f:	75 11                	jne    fb2 <strchr+0x22>
     fa1:	eb 15                	jmp    fb8 <strchr+0x28>
     fa3:	90                   	nop
     fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fa8:	83 c0 01             	add    $0x1,%eax
     fab:	0f b6 10             	movzbl (%eax),%edx
     fae:	84 d2                	test   %dl,%dl
     fb0:	74 06                	je     fb8 <strchr+0x28>
    if(*s == c)
     fb2:	38 ca                	cmp    %cl,%dl
     fb4:	75 f2                	jne    fa8 <strchr+0x18>
      return (char*) s;
  return 0;
}
     fb6:	5d                   	pop    %ebp
     fb7:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     fb8:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
     fba:	5d                   	pop    %ebp
     fbb:	90                   	nop
     fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fc0:	c3                   	ret    
     fc1:	eb 0d                	jmp    fd0 <atoi>
     fc3:	90                   	nop
     fc4:	90                   	nop
     fc5:	90                   	nop
     fc6:	90                   	nop
     fc7:	90                   	nop
     fc8:	90                   	nop
     fc9:	90                   	nop
     fca:	90                   	nop
     fcb:	90                   	nop
     fcc:	90                   	nop
     fcd:	90                   	nop
     fce:	90                   	nop
     fcf:	90                   	nop

00000fd0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     fd0:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fd1:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
     fd3:	89 e5                	mov    %esp,%ebp
     fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     fd8:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fd9:	0f b6 11             	movzbl (%ecx),%edx
     fdc:	8d 5a d0             	lea    -0x30(%edx),%ebx
     fdf:	80 fb 09             	cmp    $0x9,%bl
     fe2:	77 1c                	ja     1000 <atoi+0x30>
     fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
     fe8:	0f be d2             	movsbl %dl,%edx
     feb:	83 c1 01             	add    $0x1,%ecx
     fee:	8d 04 80             	lea    (%eax,%eax,4),%eax
     ff1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ff5:	0f b6 11             	movzbl (%ecx),%edx
     ff8:	8d 5a d0             	lea    -0x30(%edx),%ebx
     ffb:	80 fb 09             	cmp    $0x9,%bl
     ffe:	76 e8                	jbe    fe8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    1000:	5b                   	pop    %ebx
    1001:	5d                   	pop    %ebp
    1002:	c3                   	ret    
    1003:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001010 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	56                   	push   %esi
    1014:	8b 45 08             	mov    0x8(%ebp),%eax
    1017:	53                   	push   %ebx
    1018:	8b 5d 10             	mov    0x10(%ebp),%ebx
    101b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    101e:	85 db                	test   %ebx,%ebx
    1020:	7e 14                	jle    1036 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
    1022:	31 d2                	xor    %edx,%edx
    1024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
    1028:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    102c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    102f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1032:	39 da                	cmp    %ebx,%edx
    1034:	75 f2                	jne    1028 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1036:	5b                   	pop    %ebx
    1037:	5e                   	pop    %esi
    1038:	5d                   	pop    %ebp
    1039:	c3                   	ret    
    103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001040 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1046:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    1049:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    104c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    104f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1054:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    105b:	00 
    105c:	89 04 24             	mov    %eax,(%esp)
    105f:	e8 dc 00 00 00       	call   1140 <open>
  if(fd < 0)
    1064:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1066:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    1068:	78 19                	js     1083 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    106a:	8b 45 0c             	mov    0xc(%ebp),%eax
    106d:	89 1c 24             	mov    %ebx,(%esp)
    1070:	89 44 24 04          	mov    %eax,0x4(%esp)
    1074:	e8 df 00 00 00       	call   1158 <fstat>
  close(fd);
    1079:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    107c:	89 c6                	mov    %eax,%esi
  close(fd);
    107e:	e8 a5 00 00 00       	call   1128 <close>
  return r;
}
    1083:	89 f0                	mov    %esi,%eax
    1085:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    1088:	8b 75 fc             	mov    -0x4(%ebp),%esi
    108b:	89 ec                	mov    %ebp,%esp
    108d:	5d                   	pop    %ebp
    108e:	c3                   	ret    
    108f:	90                   	nop

00001090 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	57                   	push   %edi
    1094:	56                   	push   %esi
    1095:	31 f6                	xor    %esi,%esi
    1097:	53                   	push   %ebx
    1098:	83 ec 2c             	sub    $0x2c,%esp
    109b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    109e:	eb 06                	jmp    10a6 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    10a0:	3c 0a                	cmp    $0xa,%al
    10a2:	74 39                	je     10dd <gets+0x4d>
    10a4:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    10a6:	8d 5e 01             	lea    0x1(%esi),%ebx
    10a9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    10ac:	7d 31                	jge    10df <gets+0x4f>
    cc = read(0, &c, 1);
    10ae:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    10b8:	00 
    10b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    10bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10c4:	e8 4f 00 00 00       	call   1118 <read>
    if(cc < 1)
    10c9:	85 c0                	test   %eax,%eax
    10cb:	7e 12                	jle    10df <gets+0x4f>
      break;
    buf[i++] = c;
    10cd:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10d1:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    10d5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10d9:	3c 0d                	cmp    $0xd,%al
    10db:	75 c3                	jne    10a0 <gets+0x10>
    10dd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    10df:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    10e3:	89 f8                	mov    %edi,%eax
    10e5:	83 c4 2c             	add    $0x2c,%esp
    10e8:	5b                   	pop    %ebx
    10e9:	5e                   	pop    %esi
    10ea:	5f                   	pop    %edi
    10eb:	5d                   	pop    %ebp
    10ec:	c3                   	ret    
    10ed:	90                   	nop
    10ee:	90                   	nop
    10ef:	90                   	nop

000010f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    10f0:	b8 01 00 00 00       	mov    $0x1,%eax
    10f5:	cd 40                	int    $0x40
    10f7:	c3                   	ret    

000010f8 <exit>:
SYSCALL(exit)
    10f8:	b8 02 00 00 00       	mov    $0x2,%eax
    10fd:	cd 40                	int    $0x40
    10ff:	c3                   	ret    

00001100 <wait>:
SYSCALL(wait)
    1100:	b8 03 00 00 00       	mov    $0x3,%eax
    1105:	cd 40                	int    $0x40
    1107:	c3                   	ret    

00001108 <wait2>:
SYSCALL(wait2)
    1108:	b8 16 00 00 00       	mov    $0x16,%eax
    110d:	cd 40                	int    $0x40
    110f:	c3                   	ret    

00001110 <pipe>:
SYSCALL(pipe)
    1110:	b8 04 00 00 00       	mov    $0x4,%eax
    1115:	cd 40                	int    $0x40
    1117:	c3                   	ret    

00001118 <read>:
SYSCALL(read)
    1118:	b8 06 00 00 00       	mov    $0x6,%eax
    111d:	cd 40                	int    $0x40
    111f:	c3                   	ret    

00001120 <write>:
SYSCALL(write)
    1120:	b8 05 00 00 00       	mov    $0x5,%eax
    1125:	cd 40                	int    $0x40
    1127:	c3                   	ret    

00001128 <close>:
SYSCALL(close)
    1128:	b8 07 00 00 00       	mov    $0x7,%eax
    112d:	cd 40                	int    $0x40
    112f:	c3                   	ret    

00001130 <kill>:
SYSCALL(kill)
    1130:	b8 08 00 00 00       	mov    $0x8,%eax
    1135:	cd 40                	int    $0x40
    1137:	c3                   	ret    

00001138 <exec>:
SYSCALL(exec)
    1138:	b8 09 00 00 00       	mov    $0x9,%eax
    113d:	cd 40                	int    $0x40
    113f:	c3                   	ret    

00001140 <open>:
SYSCALL(open)
    1140:	b8 0a 00 00 00       	mov    $0xa,%eax
    1145:	cd 40                	int    $0x40
    1147:	c3                   	ret    

00001148 <mknod>:
SYSCALL(mknod)
    1148:	b8 0b 00 00 00       	mov    $0xb,%eax
    114d:	cd 40                	int    $0x40
    114f:	c3                   	ret    

00001150 <unlink>:
SYSCALL(unlink)
    1150:	b8 0c 00 00 00       	mov    $0xc,%eax
    1155:	cd 40                	int    $0x40
    1157:	c3                   	ret    

00001158 <fstat>:
SYSCALL(fstat)
    1158:	b8 0d 00 00 00       	mov    $0xd,%eax
    115d:	cd 40                	int    $0x40
    115f:	c3                   	ret    

00001160 <link>:
SYSCALL(link)
    1160:	b8 0e 00 00 00       	mov    $0xe,%eax
    1165:	cd 40                	int    $0x40
    1167:	c3                   	ret    

00001168 <mkdir>:
SYSCALL(mkdir)
    1168:	b8 0f 00 00 00       	mov    $0xf,%eax
    116d:	cd 40                	int    $0x40
    116f:	c3                   	ret    

00001170 <chdir>:
SYSCALL(chdir)
    1170:	b8 10 00 00 00       	mov    $0x10,%eax
    1175:	cd 40                	int    $0x40
    1177:	c3                   	ret    

00001178 <dup>:
SYSCALL(dup)
    1178:	b8 11 00 00 00       	mov    $0x11,%eax
    117d:	cd 40                	int    $0x40
    117f:	c3                   	ret    

00001180 <getpid>:
SYSCALL(getpid)
    1180:	b8 12 00 00 00       	mov    $0x12,%eax
    1185:	cd 40                	int    $0x40
    1187:	c3                   	ret    

00001188 <sbrk>:
SYSCALL(sbrk)
    1188:	b8 13 00 00 00       	mov    $0x13,%eax
    118d:	cd 40                	int    $0x40
    118f:	c3                   	ret    

00001190 <sleep>:
SYSCALL(sleep)
    1190:	b8 14 00 00 00       	mov    $0x14,%eax
    1195:	cd 40                	int    $0x40
    1197:	c3                   	ret    

00001198 <uptime>:
SYSCALL(uptime)
    1198:	b8 15 00 00 00       	mov    $0x15,%eax
    119d:	cd 40                	int    $0x40
    119f:	c3                   	ret    

000011a0 <nice>:
SYSCALL(nice)
    11a0:	b8 17 00 00 00       	mov    $0x17,%eax
    11a5:	cd 40                	int    $0x40
    11a7:	c3                   	ret    
    11a8:	90                   	nop
    11a9:	90                   	nop
    11aa:	90                   	nop
    11ab:	90                   	nop
    11ac:	90                   	nop
    11ad:	90                   	nop
    11ae:	90                   	nop
    11af:	90                   	nop

000011b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	57                   	push   %edi
    11b4:	89 cf                	mov    %ecx,%edi
    11b6:	56                   	push   %esi
    11b7:	89 c6                	mov    %eax,%esi
    11b9:	53                   	push   %ebx
    11ba:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    11bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11c0:	85 c9                	test   %ecx,%ecx
    11c2:	74 04                	je     11c8 <printint+0x18>
    11c4:	85 d2                	test   %edx,%edx
    11c6:	78 70                	js     1238 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    11c8:	89 d0                	mov    %edx,%eax
    11ca:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    11d1:	31 c9                	xor    %ecx,%ecx
    11d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    11d6:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    11d8:	31 d2                	xor    %edx,%edx
    11da:	f7 f7                	div    %edi
    11dc:	0f b6 92 27 17 00 00 	movzbl 0x1727(%edx),%edx
    11e3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    11e6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
    11e9:	85 c0                	test   %eax,%eax
    11eb:	75 eb                	jne    11d8 <printint+0x28>
  if(neg)
    11ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    11f0:	85 c0                	test   %eax,%eax
    11f2:	74 08                	je     11fc <printint+0x4c>
    buf[i++] = '-';
    11f4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
    11f9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
    11fc:	8d 79 ff             	lea    -0x1(%ecx),%edi
    11ff:	01 fb                	add    %edi,%ebx
    1201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1208:	0f b6 03             	movzbl (%ebx),%eax
    120b:	83 ef 01             	sub    $0x1,%edi
    120e:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1211:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1218:	00 
    1219:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    121c:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    121f:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1222:	89 44 24 04          	mov    %eax,0x4(%esp)
    1226:	e8 f5 fe ff ff       	call   1120 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    122b:	83 ff ff             	cmp    $0xffffffff,%edi
    122e:	75 d8                	jne    1208 <printint+0x58>
    putc(fd, buf[i]);
}
    1230:	83 c4 4c             	add    $0x4c,%esp
    1233:	5b                   	pop    %ebx
    1234:	5e                   	pop    %esi
    1235:	5f                   	pop    %edi
    1236:	5d                   	pop    %ebp
    1237:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1238:	89 d0                	mov    %edx,%eax
    123a:	f7 d8                	neg    %eax
    123c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    1243:	eb 8c                	jmp    11d1 <printint+0x21>
    1245:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001250 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	57                   	push   %edi
    1254:	56                   	push   %esi
    1255:	53                   	push   %ebx
    1256:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1259:	8b 45 0c             	mov    0xc(%ebp),%eax
    125c:	0f b6 10             	movzbl (%eax),%edx
    125f:	84 d2                	test   %dl,%dl
    1261:	0f 84 c9 00 00 00    	je     1330 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1267:	8d 4d 10             	lea    0x10(%ebp),%ecx
    126a:	31 ff                	xor    %edi,%edi
    126c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    126f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1271:	8d 75 e7             	lea    -0x19(%ebp),%esi
    1274:	eb 1e                	jmp    1294 <printf+0x44>
    1276:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1278:	83 fa 25             	cmp    $0x25,%edx
    127b:	0f 85 b7 00 00 00    	jne    1338 <printf+0xe8>
    1281:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1285:	83 c3 01             	add    $0x1,%ebx
    1288:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    128c:	84 d2                	test   %dl,%dl
    128e:	0f 84 9c 00 00 00    	je     1330 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
    1294:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    1296:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
    1299:	74 dd                	je     1278 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    129b:	83 ff 25             	cmp    $0x25,%edi
    129e:	75 e5                	jne    1285 <printf+0x35>
      if(c == 'd'){
    12a0:	83 fa 64             	cmp    $0x64,%edx
    12a3:	0f 84 57 01 00 00    	je     1400 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    12a9:	83 fa 70             	cmp    $0x70,%edx
    12ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12b0:	0f 84 aa 00 00 00    	je     1360 <printf+0x110>
    12b6:	83 fa 78             	cmp    $0x78,%edx
    12b9:	0f 84 a1 00 00 00    	je     1360 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    12bf:	83 fa 73             	cmp    $0x73,%edx
    12c2:	0f 84 c0 00 00 00    	je     1388 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12c8:	83 fa 63             	cmp    $0x63,%edx
    12cb:	90                   	nop
    12cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12d0:	0f 84 52 01 00 00    	je     1428 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    12d6:	83 fa 25             	cmp    $0x25,%edx
    12d9:	0f 84 f9 00 00 00    	je     13d8 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    12df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    12e2:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    12e5:	31 ff                	xor    %edi,%edi
    12e7:	89 55 cc             	mov    %edx,-0x34(%ebp)
    12ea:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    12ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12f5:	00 
    12f6:	89 0c 24             	mov    %ecx,(%esp)
    12f9:	89 74 24 04          	mov    %esi,0x4(%esp)
    12fd:	e8 1e fe ff ff       	call   1120 <write>
    1302:	8b 55 cc             	mov    -0x34(%ebp),%edx
    1305:	8b 45 08             	mov    0x8(%ebp),%eax
    1308:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    130f:	00 
    1310:	89 74 24 04          	mov    %esi,0x4(%esp)
    1314:	88 55 e7             	mov    %dl,-0x19(%ebp)
    1317:	89 04 24             	mov    %eax,(%esp)
    131a:	e8 01 fe ff ff       	call   1120 <write>
    131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1322:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    1326:	84 d2                	test   %dl,%dl
    1328:	0f 85 66 ff ff ff    	jne    1294 <printf+0x44>
    132e:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1330:	83 c4 3c             	add    $0x3c,%esp
    1333:	5b                   	pop    %ebx
    1334:	5e                   	pop    %esi
    1335:	5f                   	pop    %edi
    1336:	5d                   	pop    %ebp
    1337:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1338:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    133b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    133e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1345:	00 
    1346:	89 74 24 04          	mov    %esi,0x4(%esp)
    134a:	89 04 24             	mov    %eax,(%esp)
    134d:	e8 ce fd ff ff       	call   1120 <write>
    1352:	8b 45 0c             	mov    0xc(%ebp),%eax
    1355:	e9 2b ff ff ff       	jmp    1285 <printf+0x35>
    135a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    1360:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1363:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    1368:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    136a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1371:	8b 10                	mov    (%eax),%edx
    1373:	8b 45 08             	mov    0x8(%ebp),%eax
    1376:	e8 35 fe ff ff       	call   11b0 <printint>
    137b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    137e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1382:	e9 fe fe ff ff       	jmp    1285 <printf+0x35>
    1387:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
    1388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    138b:	8b 3a                	mov    (%edx),%edi
        ap++;
    138d:	83 c2 04             	add    $0x4,%edx
    1390:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    1393:	85 ff                	test   %edi,%edi
    1395:	0f 84 ba 00 00 00    	je     1455 <printf+0x205>
          s = "(null)";
        while(*s != 0){
    139b:	0f b6 17             	movzbl (%edi),%edx
    139e:	84 d2                	test   %dl,%dl
    13a0:	74 2d                	je     13cf <printf+0x17f>
    13a2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    13a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
    13a8:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    13ab:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13b5:	00 
    13b6:	89 74 24 04          	mov    %esi,0x4(%esp)
    13ba:	89 1c 24             	mov    %ebx,(%esp)
    13bd:	e8 5e fd ff ff       	call   1120 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    13c2:	0f b6 17             	movzbl (%edi),%edx
    13c5:	84 d2                	test   %dl,%dl
    13c7:	75 df                	jne    13a8 <printf+0x158>
    13c9:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    13cc:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13cf:	31 ff                	xor    %edi,%edi
    13d1:	e9 af fe ff ff       	jmp    1285 <printf+0x35>
    13d6:	66 90                	xchg   %ax,%ax
    13d8:	8b 55 08             	mov    0x8(%ebp),%edx
    13db:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13dd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13e8:	00 
    13e9:	89 74 24 04          	mov    %esi,0x4(%esp)
    13ed:	89 14 24             	mov    %edx,(%esp)
    13f0:	e8 2b fd ff ff       	call   1120 <write>
    13f5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f8:	e9 88 fe ff ff       	jmp    1285 <printf+0x35>
    13fd:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1400:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1403:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    1408:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    140b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1412:	8b 10                	mov    (%eax),%edx
    1414:	8b 45 08             	mov    0x8(%ebp),%eax
    1417:	e8 94 fd ff ff       	call   11b0 <printint>
    141c:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    141f:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1423:	e9 5d fe ff ff       	jmp    1285 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1428:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
    142b:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    142d:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    142f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1436:	00 
    1437:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    143b:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    143e:	8b 45 08             	mov    0x8(%ebp),%eax
    1441:	89 04 24             	mov    %eax,(%esp)
    1444:	e8 d7 fc ff ff       	call   1120 <write>
    1449:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    144c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1450:	e9 30 fe ff ff       	jmp    1285 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
    1455:	bf 20 17 00 00       	mov    $0x1720,%edi
    145a:	e9 3c ff ff ff       	jmp    139b <printf+0x14b>
    145f:	90                   	nop

00001460 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1460:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1461:	a1 cc 17 00 00       	mov    0x17cc,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    1466:	89 e5                	mov    %esp,%ebp
    1468:	57                   	push   %edi
    1469:	56                   	push   %esi
    146a:	53                   	push   %ebx
    146b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
    146e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1471:	39 c8                	cmp    %ecx,%eax
    1473:	73 1d                	jae    1492 <free+0x32>
    1475:	8d 76 00             	lea    0x0(%esi),%esi
    1478:	8b 10                	mov    (%eax),%edx
    147a:	39 d1                	cmp    %edx,%ecx
    147c:	72 1a                	jb     1498 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    147e:	39 d0                	cmp    %edx,%eax
    1480:	72 08                	jb     148a <free+0x2a>
    1482:	39 c8                	cmp    %ecx,%eax
    1484:	72 12                	jb     1498 <free+0x38>
    1486:	39 d1                	cmp    %edx,%ecx
    1488:	72 0e                	jb     1498 <free+0x38>
    148a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    148c:	39 c8                	cmp    %ecx,%eax
    148e:	66 90                	xchg   %ax,%ax
    1490:	72 e6                	jb     1478 <free+0x18>
    1492:	8b 10                	mov    (%eax),%edx
    1494:	eb e8                	jmp    147e <free+0x1e>
    1496:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1498:	8b 71 04             	mov    0x4(%ecx),%esi
    149b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    149e:	39 d7                	cmp    %edx,%edi
    14a0:	74 19                	je     14bb <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    14a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    14a5:	8b 50 04             	mov    0x4(%eax),%edx
    14a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    14ab:	39 ce                	cmp    %ecx,%esi
    14ad:	74 23                	je     14d2 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    14af:	89 08                	mov    %ecx,(%eax)
  freep = p;
    14b1:	a3 cc 17 00 00       	mov    %eax,0x17cc
}
    14b6:	5b                   	pop    %ebx
    14b7:	5e                   	pop    %esi
    14b8:	5f                   	pop    %edi
    14b9:	5d                   	pop    %ebp
    14ba:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    14bb:	03 72 04             	add    0x4(%edx),%esi
    14be:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    14c1:	8b 10                	mov    (%eax),%edx
    14c3:	8b 12                	mov    (%edx),%edx
    14c5:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    14c8:	8b 50 04             	mov    0x4(%eax),%edx
    14cb:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    14ce:	39 ce                	cmp    %ecx,%esi
    14d0:	75 dd                	jne    14af <free+0x4f>
    p->s.size += bp->s.size;
    14d2:	03 51 04             	add    0x4(%ecx),%edx
    14d5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    14d8:	8b 53 f8             	mov    -0x8(%ebx),%edx
    14db:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    14dd:	a3 cc 17 00 00       	mov    %eax,0x17cc
}
    14e2:	5b                   	pop    %ebx
    14e3:	5e                   	pop    %esi
    14e4:	5f                   	pop    %edi
    14e5:	5d                   	pop    %ebp
    14e6:	c3                   	ret    
    14e7:	89 f6                	mov    %esi,%esi
    14e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000014f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    14f0:	55                   	push   %ebp
    14f1:	89 e5                	mov    %esp,%ebp
    14f3:	57                   	push   %edi
    14f4:	56                   	push   %esi
    14f5:	53                   	push   %ebx
    14f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    14f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    14fc:	8b 0d cc 17 00 00    	mov    0x17cc,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1502:	83 c3 07             	add    $0x7,%ebx
    1505:	c1 eb 03             	shr    $0x3,%ebx
    1508:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    150b:	85 c9                	test   %ecx,%ecx
    150d:	0f 84 93 00 00 00    	je     15a6 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1513:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    1515:	8b 50 04             	mov    0x4(%eax),%edx
    1518:	39 d3                	cmp    %edx,%ebx
    151a:	76 1f                	jbe    153b <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    151c:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    1523:	90                   	nop
    1524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
    1528:	3b 05 cc 17 00 00    	cmp    0x17cc,%eax
    152e:	74 30                	je     1560 <malloc+0x70>
    1530:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1532:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    1534:	8b 50 04             	mov    0x4(%eax),%edx
    1537:	39 d3                	cmp    %edx,%ebx
    1539:	77 ed                	ja     1528 <malloc+0x38>
      if(p->s.size == nunits)
    153b:	39 d3                	cmp    %edx,%ebx
    153d:	74 61                	je     15a0 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    153f:	29 da                	sub    %ebx,%edx
    1541:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1544:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    1547:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    154a:	89 0d cc 17 00 00    	mov    %ecx,0x17cc
      return (void*) (p + 1);
    1550:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1553:	83 c4 1c             	add    $0x1c,%esp
    1556:	5b                   	pop    %ebx
    1557:	5e                   	pop    %esi
    1558:	5f                   	pop    %edi
    1559:	5d                   	pop    %ebp
    155a:	c3                   	ret    
    155b:	90                   	nop
    155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1560:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    1566:	b8 00 80 00 00       	mov    $0x8000,%eax
    156b:	bf 00 10 00 00       	mov    $0x1000,%edi
    1570:	76 04                	jbe    1576 <malloc+0x86>
    1572:	89 f0                	mov    %esi,%eax
    1574:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    1576:	89 04 24             	mov    %eax,(%esp)
    1579:	e8 0a fc ff ff       	call   1188 <sbrk>
  if(p == (char*) -1)
    157e:	83 f8 ff             	cmp    $0xffffffff,%eax
    1581:	74 18                	je     159b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1583:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1586:	83 c0 08             	add    $0x8,%eax
    1589:	89 04 24             	mov    %eax,(%esp)
    158c:	e8 cf fe ff ff       	call   1460 <free>
  return freep;
    1591:	8b 0d cc 17 00 00    	mov    0x17cc,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1597:	85 c9                	test   %ecx,%ecx
    1599:	75 97                	jne    1532 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    159b:	31 c0                	xor    %eax,%eax
    159d:	eb b4                	jmp    1553 <malloc+0x63>
    159f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    15a0:	8b 10                	mov    (%eax),%edx
    15a2:	89 11                	mov    %edx,(%ecx)
    15a4:	eb a4                	jmp    154a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    15a6:	c7 05 cc 17 00 00 c4 	movl   $0x17c4,0x17cc
    15ad:	17 00 00 
    base.s.size = 0;
    15b0:	b9 c4 17 00 00       	mov    $0x17c4,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    15b5:	c7 05 c4 17 00 00 c4 	movl   $0x17c4,0x17c4
    15bc:	17 00 00 
    base.s.size = 0;
    15bf:	c7 05 c8 17 00 00 00 	movl   $0x0,0x17c8
    15c6:	00 00 00 
    15c9:	e9 45 ff ff ff       	jmp    1513 <malloc+0x23>
