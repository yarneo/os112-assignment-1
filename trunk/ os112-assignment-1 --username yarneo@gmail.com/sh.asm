
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 14             	sub    $0x14,%esp
       7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       a:	85 db                	test   %ebx,%ebx
       c:	74 05                	je     13 <nulterminate+0x13>
    return 0;
  
  switch(cmd->type){
       e:	83 3b 05             	cmpl   $0x5,(%ebx)
      11:	76 0d                	jbe    20 <nulterminate+0x20>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      13:	89 d8                	mov    %ebx,%eax
      15:	83 c4 14             	add    $0x14,%esp
      18:	5b                   	pop    %ebx
      19:	5d                   	pop    %ebp
      1a:	c3                   	ret    
      1b:	90                   	nop
      1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
  
  switch(cmd->type){
      20:	8b 03                	mov    (%ebx),%eax
      22:	ff 24 85 90 16 00 00 	jmp    *0x1690(,%eax,4)
      29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(pcmd->right);
    break;
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
      30:	8b 43 04             	mov    0x4(%ebx),%eax
      33:	89 04 24             	mov    %eax,(%esp)
      36:	e8 c5 ff ff ff       	call   0 <nulterminate>
    nulterminate(lcmd->right);
      3b:	8b 43 08             	mov    0x8(%ebx),%eax
      3e:	89 04 24             	mov    %eax,(%esp)
      41:	e8 ba ff ff ff       	call   0 <nulterminate>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      46:	89 d8                	mov    %ebx,%eax
      48:	83 c4 14             	add    $0x14,%esp
      4b:	5b                   	pop    %ebx
      4c:	5d                   	pop    %ebp
      4d:	c3                   	ret    
      4e:	66 90                	xchg   %ax,%ax
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
      50:	8b 43 04             	mov    0x4(%ebx),%eax
      53:	89 04 24             	mov    %eax,(%esp)
      56:	e8 a5 ff ff ff       	call   0 <nulterminate>
    break;
  }
  return cmd;
}
      5b:	89 d8                	mov    %ebx,%eax
      5d:	83 c4 14             	add    $0x14,%esp
      60:	5b                   	pop    %ebx
      61:	5d                   	pop    %ebp
      62:	c3                   	ret    
      63:	90                   	nop
      64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
      68:	8b 43 04             	mov    0x4(%ebx),%eax
      6b:	89 04 24             	mov    %eax,(%esp)
      6e:	e8 8d ff ff ff       	call   0 <nulterminate>
    *rcmd->efile = 0;
      73:	8b 43 0c             	mov    0xc(%ebx),%eax
      76:	c6 00 00             	movb   $0x0,(%eax)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      79:	89 d8                	mov    %ebx,%eax
      7b:	83 c4 14             	add    $0x14,%esp
      7e:	5b                   	pop    %ebx
      7f:	5d                   	pop    %ebp
      80:	c3                   	ret    
      81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      88:	8b 43 04             	mov    0x4(%ebx),%eax
      8b:	85 c0                	test   %eax,%eax
      8d:	74 84                	je     13 <nulterminate+0x13>
      8f:	89 d8                	mov    %ebx,%eax
      91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *ecmd->eargv[i] = 0;
      98:	8b 50 2c             	mov    0x2c(%eax),%edx
      9b:	c6 02 00             	movb   $0x0,(%edx)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      9e:	8b 50 08             	mov    0x8(%eax),%edx
      a1:	83 c0 04             	add    $0x4,%eax
      a4:	85 d2                	test   %edx,%edx
      a6:	75 f0                	jne    98 <nulterminate+0x98>
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
      a8:	89 d8                	mov    %ebx,%eax
      aa:	83 c4 14             	add    $0x14,%esp
      ad:	5b                   	pop    %ebx
      ae:	5d                   	pop    %ebp
      af:	c3                   	ret    

000000b0 <peek>:
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
      b0:	55                   	push   %ebp
      b1:	89 e5                	mov    %esp,%ebp
      b3:	57                   	push   %edi
      b4:	56                   	push   %esi
      b5:	53                   	push   %ebx
      b6:	83 ec 1c             	sub    $0x1c,%esp
      b9:	8b 7d 08             	mov    0x8(%ebp),%edi
      bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;
  
  s = *ps;
      bf:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
      c1:	39 f3                	cmp    %esi,%ebx
      c3:	72 0a                	jb     cf <peek+0x1f>
      c5:	eb 1f                	jmp    e6 <peek+0x36>
      c7:	90                   	nop
    s++;
      c8:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
      cb:	39 de                	cmp    %ebx,%esi
      cd:	76 17                	jbe    e6 <peek+0x36>
      cf:	0f be 03             	movsbl (%ebx),%eax
      d2:	c7 04 24 f8 17 00 00 	movl   $0x17f8,(%esp)
      d9:	89 44 24 04          	mov    %eax,0x4(%esp)
      dd:	e8 5e 0e 00 00       	call   f40 <strchr>
      e2:	85 c0                	test   %eax,%eax
      e4:	75 e2                	jne    c8 <peek+0x18>
    s++;
  *ps = s;
      e6:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
      e8:	0f b6 13             	movzbl (%ebx),%edx
      eb:	31 c0                	xor    %eax,%eax
      ed:	84 d2                	test   %dl,%dl
      ef:	75 0f                	jne    100 <peek+0x50>
}
      f1:	83 c4 1c             	add    $0x1c,%esp
      f4:	5b                   	pop    %ebx
      f5:	5e                   	pop    %esi
      f6:	5f                   	pop    %edi
      f7:	5d                   	pop    %ebp
      f8:	c3                   	ret    
      f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     100:	0f be d2             	movsbl %dl,%edx
     103:	89 54 24 04          	mov    %edx,0x4(%esp)
     107:	8b 45 10             	mov    0x10(%ebp),%eax
     10a:	89 04 24             	mov    %eax,(%esp)
     10d:	e8 2e 0e 00 00       	call   f40 <strchr>
     112:	85 c0                	test   %eax,%eax
     114:	0f 95 c0             	setne  %al
}
     117:	83 c4 1c             	add    $0x1c,%esp
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
     11a:	0f b6 c0             	movzbl %al,%eax
}
     11d:	5b                   	pop    %ebx
     11e:	5e                   	pop    %esi
     11f:	5f                   	pop    %edi
     120:	5d                   	pop    %ebp
     121:	c3                   	ret    
     122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	57                   	push   %edi
     134:	56                   	push   %esi
     135:	53                   	push   %ebx
     136:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;
  
  s = *ps;
     139:	8b 45 08             	mov    0x8(%ebp),%eax
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     13c:	8b 75 0c             	mov    0xc(%ebp),%esi
     13f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;
  
  s = *ps;
     142:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     144:	39 f3                	cmp    %esi,%ebx
     146:	72 0f                	jb     157 <gettoken+0x27>
     148:	eb 24                	jmp    16e <gettoken+0x3e>
     14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     150:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     153:	39 de                	cmp    %ebx,%esi
     155:	76 17                	jbe    16e <gettoken+0x3e>
     157:	0f be 03             	movsbl (%ebx),%eax
     15a:	c7 04 24 f8 17 00 00 	movl   $0x17f8,(%esp)
     161:	89 44 24 04          	mov    %eax,0x4(%esp)
     165:	e8 d6 0d 00 00       	call   f40 <strchr>
     16a:	85 c0                	test   %eax,%eax
     16c:	75 e2                	jne    150 <gettoken+0x20>
    s++;
  if(q)
     16e:	85 ff                	test   %edi,%edi
     170:	74 02                	je     174 <gettoken+0x44>
    *q = s;
     172:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     174:	0f b6 13             	movzbl (%ebx),%edx
     177:	0f be fa             	movsbl %dl,%edi
  switch(*s){
     17a:	80 fa 3c             	cmp    $0x3c,%dl
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
     17d:	89 f8                	mov    %edi,%eax
  switch(*s){
     17f:	7f 4f                	jg     1d0 <gettoken+0xa0>
     181:	80 fa 3b             	cmp    $0x3b,%dl
     184:	0f 8c a6 00 00 00    	jl     230 <gettoken+0x100>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     18a:	83 c3 01             	add    $0x1,%ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     18d:	8b 55 14             	mov    0x14(%ebp),%edx
     190:	85 d2                	test   %edx,%edx
     192:	74 05                	je     199 <gettoken+0x69>
    *eq = s;
     194:	8b 45 14             	mov    0x14(%ebp),%eax
     197:	89 18                	mov    %ebx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     199:	39 f3                	cmp    %esi,%ebx
     19b:	72 0a                	jb     1a7 <gettoken+0x77>
     19d:	eb 1f                	jmp    1be <gettoken+0x8e>
     19f:	90                   	nop
    s++;
     1a0:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     1a3:	39 de                	cmp    %ebx,%esi
     1a5:	76 17                	jbe    1be <gettoken+0x8e>
     1a7:	0f be 03             	movsbl (%ebx),%eax
     1aa:	c7 04 24 f8 17 00 00 	movl   $0x17f8,(%esp)
     1b1:	89 44 24 04          	mov    %eax,0x4(%esp)
     1b5:	e8 86 0d 00 00       	call   f40 <strchr>
     1ba:	85 c0                	test   %eax,%eax
     1bc:	75 e2                	jne    1a0 <gettoken+0x70>
    s++;
  *ps = s;
     1be:	8b 45 08             	mov    0x8(%ebp),%eax
     1c1:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     1c3:	83 c4 1c             	add    $0x1c,%esp
     1c6:	89 f8                	mov    %edi,%eax
     1c8:	5b                   	pop    %ebx
     1c9:	5e                   	pop    %esi
     1ca:	5f                   	pop    %edi
     1cb:	5d                   	pop    %ebp
     1cc:	c3                   	ret    
     1cd:	8d 76 00             	lea    0x0(%esi),%esi
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     1d0:	80 fa 3e             	cmp    $0x3e,%dl
     1d3:	0f 84 7f 00 00 00    	je     258 <gettoken+0x128>
     1d9:	80 fa 7c             	cmp    $0x7c,%dl
     1dc:	74 ac                	je     18a <gettoken+0x5a>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     1de:	39 de                	cmp    %ebx,%esi
     1e0:	77 2f                	ja     211 <gettoken+0xe1>
     1e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     1e8:	eb 3b                	jmp    225 <gettoken+0xf5>
     1ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     1f0:	0f be 03             	movsbl (%ebx),%eax
     1f3:	c7 04 24 fe 17 00 00 	movl   $0x17fe,(%esp)
     1fa:	89 44 24 04          	mov    %eax,0x4(%esp)
     1fe:	e8 3d 0d 00 00       	call   f40 <strchr>
     203:	85 c0                	test   %eax,%eax
     205:	75 1e                	jne    225 <gettoken+0xf5>
      s++;
     207:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     20a:	39 de                	cmp    %ebx,%esi
     20c:	76 17                	jbe    225 <gettoken+0xf5>
     20e:	0f be 03             	movsbl (%ebx),%eax
     211:	89 44 24 04          	mov    %eax,0x4(%esp)
     215:	c7 04 24 f8 17 00 00 	movl   $0x17f8,(%esp)
     21c:	e8 1f 0d 00 00       	call   f40 <strchr>
     221:	85 c0                	test   %eax,%eax
     223:	74 cb                	je     1f0 <gettoken+0xc0>
     225:	bf 61 00 00 00       	mov    $0x61,%edi
     22a:	e9 5e ff ff ff       	jmp    18d <gettoken+0x5d>
     22f:	90                   	nop
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
     230:	80 fa 29             	cmp    $0x29,%dl
     233:	7f a9                	jg     1de <gettoken+0xae>
     235:	80 fa 28             	cmp    $0x28,%dl
     238:	0f 8d 4c ff ff ff    	jge    18a <gettoken+0x5a>
     23e:	84 d2                	test   %dl,%dl
     240:	0f 84 47 ff ff ff    	je     18d <gettoken+0x5d>
     246:	80 fa 26             	cmp    $0x26,%dl
     249:	75 93                	jne    1de <gettoken+0xae>
     24b:	90                   	nop
     24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     250:	e9 35 ff ff ff       	jmp    18a <gettoken+0x5a>
     255:	8d 76 00             	lea    0x0(%esi),%esi
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     258:	83 c3 01             	add    $0x1,%ebx
    if(*s == '>'){
     25b:	80 3b 3e             	cmpb   $0x3e,(%ebx)
     25e:	66 90                	xchg   %ax,%ax
     260:	0f 85 27 ff ff ff    	jne    18d <gettoken+0x5d>
      ret = '+';
      s++;
     266:	83 c3 01             	add    $0x1,%ebx
     269:	bf 2b 00 00 00       	mov    $0x2b,%edi
     26e:	66 90                	xchg   %ax,%ax
     270:	e9 18 ff ff ff       	jmp    18d <gettoken+0x5d>
     275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <backcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
     280:	55                   	push   %ebp
     281:	89 e5                	mov    %esp,%ebp
     283:	53                   	push   %ebx
     284:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     287:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     28e:	e8 1d 13 00 00       	call   15b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     293:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     29a:	00 
     29b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2a2:	00 
struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2a3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2a5:	89 04 24             	mov    %eax,(%esp)
     2a8:	e8 73 0c 00 00       	call   f20 <memset>
  cmd->type = BACK;
     2ad:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     2b3:	8b 45 08             	mov    0x8(%ebp),%eax
     2b6:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     2b9:	89 d8                	mov    %ebx,%eax
     2bb:	83 c4 14             	add    $0x14,%esp
     2be:	5b                   	pop    %ebx
     2bf:	5d                   	pop    %ebp
     2c0:	c3                   	ret    
     2c1:	eb 0d                	jmp    2d0 <listcmd>
     2c3:	90                   	nop
     2c4:	90                   	nop
     2c5:	90                   	nop
     2c6:	90                   	nop
     2c7:	90                   	nop
     2c8:	90                   	nop
     2c9:	90                   	nop
     2ca:	90                   	nop
     2cb:	90                   	nop
     2cc:	90                   	nop
     2cd:	90                   	nop
     2ce:	90                   	nop
     2cf:	90                   	nop

000002d0 <listcmd>:
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2d0:	55                   	push   %ebp
     2d1:	89 e5                	mov    %esp,%ebp
     2d3:	53                   	push   %ebx
     2d4:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2d7:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2de:	e8 cd 12 00 00       	call   15b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     2e3:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     2ea:	00 
     2eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2f2:	00 
struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2f5:	89 04 24             	mov    %eax,(%esp)
     2f8:	e8 23 0c 00 00       	call   f20 <memset>
  cmd->type = LIST;
     2fd:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     303:	8b 45 08             	mov    0x8(%ebp),%eax
     306:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     309:	8b 45 0c             	mov    0xc(%ebp),%eax
     30c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     30f:	89 d8                	mov    %ebx,%eax
     311:	83 c4 14             	add    $0x14,%esp
     314:	5b                   	pop    %ebx
     315:	5d                   	pop    %ebp
     316:	c3                   	ret    
     317:	89 f6                	mov    %esi,%esi
     319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <pipecmd>:
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     320:	55                   	push   %ebp
     321:	89 e5                	mov    %esp,%ebp
     323:	53                   	push   %ebx
     324:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     327:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     32e:	e8 7d 12 00 00       	call   15b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     333:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     33a:	00 
     33b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     342:	00 
struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     343:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     345:	89 04 24             	mov    %eax,(%esp)
     348:	e8 d3 0b 00 00       	call   f20 <memset>
  cmd->type = PIPE;
     34d:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
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

00000370 <redircmd>:
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	53                   	push   %ebx
     374:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     377:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     37e:	e8 2d 12 00 00       	call   15b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     383:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     38a:	00 
     38b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     392:	00 
struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     395:	89 04 24             	mov    %eax,(%esp)
     398:	e8 83 0b 00 00       	call   f20 <memset>
  cmd->type = REDIR;
     39d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3a3:	8b 45 08             	mov    0x8(%ebp),%eax
     3a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3af:	8b 45 10             	mov    0x10(%ebp),%eax
     3b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3b5:	8b 45 14             	mov    0x14(%ebp),%eax
     3b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3bb:	8b 45 18             	mov    0x18(%ebp),%eax
     3be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3c1:	89 d8                	mov    %ebx,%eax
     3c3:	83 c4 14             	add    $0x14,%esp
     3c6:	5b                   	pop    %ebx
     3c7:	5d                   	pop    %ebp
     3c8:	c3                   	ret    
     3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	53                   	push   %ebx
     3d4:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d7:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3de:	e8 cd 11 00 00       	call   15b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3e3:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3ea:	00 
     3eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3f2:	00 
struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3f3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3f5:	89 04 24             	mov    %eax,(%esp)
     3f8:	e8 23 0b 00 00       	call   f20 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     3fd:	89 d8                	mov    %ebx,%eax
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
     3ff:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     405:	83 c4 14             	add    $0x14,%esp
     408:	5b                   	pop    %ebx
     409:	5d                   	pop    %ebp
     40a:	c3                   	ret    
     40b:	90                   	nop
     40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <panic>:
  exit();
}

void
panic(char *s)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     416:	8b 45 08             	mov    0x8(%ebp),%eax
     419:	c7 44 24 04 29 17 00 	movl   $0x1729,0x4(%esp)
     420:	00 
     421:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     428:	89 44 24 08          	mov    %eax,0x8(%esp)
     42c:	e8 df 0e 00 00       	call   1310 <printf>
  exit();
     431:	e8 82 0d 00 00       	call   11b8 <exit>
     436:	8d 76 00             	lea    0x0(%esi),%esi
     439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     440:	55                   	push   %ebp
     441:	89 e5                	mov    %esp,%ebp
     443:	57                   	push   %edi
     444:	56                   	push   %esi
     445:	53                   	push   %ebx
     446:	83 ec 3c             	sub    $0x3c,%esp
     449:	8b 7d 0c             	mov    0xc(%ebp),%edi
     44c:	8b 75 10             	mov    0x10(%ebp),%esi
     44f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     450:	c7 44 24 08 dd 16 00 	movl   $0x16dd,0x8(%esp)
     457:	00 
     458:	89 74 24 04          	mov    %esi,0x4(%esp)
     45c:	89 3c 24             	mov    %edi,(%esp)
     45f:	e8 4c fc ff ff       	call   b0 <peek>
     464:	85 c0                	test   %eax,%eax
     466:	0f 84 a4 00 00 00    	je     510 <parseredirs+0xd0>
    tok = gettoken(ps, es, 0, 0);
     46c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     473:	00 
     474:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     47b:	00 
     47c:	89 74 24 04          	mov    %esi,0x4(%esp)
     480:	89 3c 24             	mov    %edi,(%esp)
     483:	e8 a8 fc ff ff       	call   130 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     488:	89 74 24 04          	mov    %esi,0x4(%esp)
     48c:	89 3c 24             	mov    %edi,(%esp)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
     48f:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     491:	8d 45 e0             	lea    -0x20(%ebp),%eax
     494:	89 44 24 0c          	mov    %eax,0xc(%esp)
     498:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     49b:	89 44 24 08          	mov    %eax,0x8(%esp)
     49f:	e8 8c fc ff ff       	call   130 <gettoken>
     4a4:	83 f8 61             	cmp    $0x61,%eax
     4a7:	74 0c                	je     4b5 <parseredirs+0x75>
      panic("missing file for redirection");
     4a9:	c7 04 24 c0 16 00 00 	movl   $0x16c0,(%esp)
     4b0:	e8 5b ff ff ff       	call   410 <panic>
    switch(tok){
     4b5:	83 fb 3c             	cmp    $0x3c,%ebx
     4b8:	74 3e                	je     4f8 <parseredirs+0xb8>
     4ba:	83 fb 3e             	cmp    $0x3e,%ebx
     4bd:	74 05                	je     4c4 <parseredirs+0x84>
     4bf:	83 fb 2b             	cmp    $0x2b,%ebx
     4c2:	75 8c                	jne    450 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     4c4:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     4cb:	00 
     4cc:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     4d3:	00 
     4d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
     4d7:	89 44 24 08          	mov    %eax,0x8(%esp)
     4db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     4de:	89 44 24 04          	mov    %eax,0x4(%esp)
     4e2:	8b 45 08             	mov    0x8(%ebp),%eax
     4e5:	89 04 24             	mov    %eax,(%esp)
     4e8:	e8 83 fe ff ff       	call   370 <redircmd>
     4ed:	89 45 08             	mov    %eax,0x8(%ebp)
     4f0:	e9 5b ff ff ff       	jmp    450 <parseredirs+0x10>
     4f5:	8d 76 00             	lea    0x0(%esi),%esi
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4f8:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     4ff:	00 
     500:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     507:	00 
     508:	eb ca                	jmp    4d4 <parseredirs+0x94>
     50a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     510:	8b 45 08             	mov    0x8(%ebp),%eax
     513:	83 c4 3c             	add    $0x3c,%esp
     516:	5b                   	pop    %ebx
     517:	5e                   	pop    %esi
     518:	5f                   	pop    %edi
     519:	5d                   	pop    %ebp
     51a:	c3                   	ret    
     51b:	90                   	nop
     51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     520:	55                   	push   %ebp
     521:	89 e5                	mov    %esp,%ebp
     523:	57                   	push   %edi
     524:	56                   	push   %esi
     525:	53                   	push   %ebx
     526:	83 ec 3c             	sub    $0x3c,%esp
     529:	8b 75 08             	mov    0x8(%ebp),%esi
     52c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     52f:	c7 44 24 08 e0 16 00 	movl   $0x16e0,0x8(%esp)
     536:	00 
     537:	89 34 24             	mov    %esi,(%esp)
     53a:	89 7c 24 04          	mov    %edi,0x4(%esp)
     53e:	e8 6d fb ff ff       	call   b0 <peek>
     543:	85 c0                	test   %eax,%eax
     545:	0f 85 cd 00 00 00    	jne    618 <parseexec+0xf8>
    return parseblock(ps, es);

  ret = execcmd();
     54b:	e8 80 fe ff ff       	call   3d0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     550:	31 db                	xor    %ebx,%ebx
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
     552:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     555:	89 7c 24 08          	mov    %edi,0x8(%esp)
     559:	89 74 24 04          	mov    %esi,0x4(%esp)
     55d:	89 04 24             	mov    %eax,(%esp)
     560:	e8 db fe ff ff       	call   440 <parseredirs>
     565:	89 45 d0             	mov    %eax,-0x30(%ebp)
  while(!peek(ps, es, "|)&;")){
     568:	eb 1c                	jmp    586 <parseexec+0x66>
     56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     570:	89 7c 24 08          	mov    %edi,0x8(%esp)
     574:	89 74 24 04          	mov    %esi,0x4(%esp)
     578:	8b 45 d0             	mov    -0x30(%ebp),%eax
     57b:	89 04 24             	mov    %eax,(%esp)
     57e:	e8 bd fe ff ff       	call   440 <parseredirs>
     583:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     586:	c7 44 24 08 f7 16 00 	movl   $0x16f7,0x8(%esp)
     58d:	00 
     58e:	89 7c 24 04          	mov    %edi,0x4(%esp)
     592:	89 34 24             	mov    %esi,(%esp)
     595:	e8 16 fb ff ff       	call   b0 <peek>
     59a:	85 c0                	test   %eax,%eax
     59c:	75 5a                	jne    5f8 <parseexec+0xd8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     59e:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5a1:	8d 55 e4             	lea    -0x1c(%ebp),%edx
     5a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     5a8:	89 54 24 08          	mov    %edx,0x8(%esp)
     5ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
     5b0:	89 34 24             	mov    %esi,(%esp)
     5b3:	e8 78 fb ff ff       	call   130 <gettoken>
     5b8:	85 c0                	test   %eax,%eax
     5ba:	74 3c                	je     5f8 <parseexec+0xd8>
      break;
    if(tok != 'a')
     5bc:	83 f8 61             	cmp    $0x61,%eax
     5bf:	74 0c                	je     5cd <parseexec+0xad>
      panic("syntax");
     5c1:	c7 04 24 e2 16 00 00 	movl   $0x16e2,(%esp)
     5c8:	e8 43 fe ff ff       	call   410 <panic>
    cmd->argv[argc] = q;
     5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5d3:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     5d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     5da:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     5de:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     5e1:	83 fb 09             	cmp    $0x9,%ebx
     5e4:	7e 8a                	jle    570 <parseexec+0x50>
      panic("too many args");
     5e6:	c7 04 24 e9 16 00 00 	movl   $0x16e9,(%esp)
     5ed:	e8 1e fe ff ff       	call   410 <panic>
     5f2:	e9 79 ff ff ff       	jmp    570 <parseexec+0x50>
     5f7:	90                   	nop
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     5f8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     5fb:	c7 44 9a 04 00 00 00 	movl   $0x0,0x4(%edx,%ebx,4)
     602:	00 
  cmd->eargv[argc] = 0;
     603:	c7 44 9a 2c 00 00 00 	movl   $0x0,0x2c(%edx,%ebx,4)
     60a:	00 
  return ret;
}
     60b:	8b 45 d0             	mov    -0x30(%ebp),%eax
     60e:	83 c4 3c             	add    $0x3c,%esp
     611:	5b                   	pop    %ebx
     612:	5e                   	pop    %esi
     613:	5f                   	pop    %edi
     614:	5d                   	pop    %ebp
     615:	c3                   	ret    
     616:	66 90                	xchg   %ax,%ax
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    return parseblock(ps, es);
     618:	89 7c 24 04          	mov    %edi,0x4(%esp)
     61c:	89 34 24             	mov    %esi,(%esp)
     61f:	e8 6c 01 00 00       	call   790 <parseblock>
     624:	89 45 d0             	mov    %eax,-0x30(%ebp)
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     627:	8b 45 d0             	mov    -0x30(%ebp),%eax
     62a:	83 c4 3c             	add    $0x3c,%esp
     62d:	5b                   	pop    %ebx
     62e:	5e                   	pop    %esi
     62f:	5f                   	pop    %edi
     630:	5d                   	pop    %ebp
     631:	c3                   	ret    
     632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000640 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     640:	55                   	push   %ebp
     641:	89 e5                	mov    %esp,%ebp
     643:	83 ec 28             	sub    $0x28,%esp
     646:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     649:	8b 5d 08             	mov    0x8(%ebp),%ebx
     64c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     64f:	8b 75 0c             	mov    0xc(%ebp),%esi
     652:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     655:	89 1c 24             	mov    %ebx,(%esp)
     658:	89 74 24 04          	mov    %esi,0x4(%esp)
     65c:	e8 bf fe ff ff       	call   520 <parseexec>
  if(peek(ps, es, "|")){
     661:	c7 44 24 08 fc 16 00 	movl   $0x16fc,0x8(%esp)
     668:	00 
     669:	89 74 24 04          	mov    %esi,0x4(%esp)
     66d:	89 1c 24             	mov    %ebx,(%esp)
struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     670:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     672:	e8 39 fa ff ff       	call   b0 <peek>
     677:	85 c0                	test   %eax,%eax
     679:	75 15                	jne    690 <parsepipe+0x50>
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}
     67b:	89 f8                	mov    %edi,%eax
     67d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     680:	8b 75 f8             	mov    -0x8(%ebp),%esi
     683:	8b 7d fc             	mov    -0x4(%ebp),%edi
     686:	89 ec                	mov    %ebp,%esp
     688:	5d                   	pop    %ebp
     689:	c3                   	ret    
     68a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
     690:	89 74 24 04          	mov    %esi,0x4(%esp)
     694:	89 1c 24             	mov    %ebx,(%esp)
     697:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     69e:	00 
     69f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6a6:	00 
     6a7:	e8 84 fa ff ff       	call   130 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ac:	89 74 24 04          	mov    %esi,0x4(%esp)
     6b0:	89 1c 24             	mov    %ebx,(%esp)
     6b3:	e8 88 ff ff ff       	call   640 <parsepipe>
  }
  return cmd;
}
     6b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6bb:	89 7d 08             	mov    %edi,0x8(%ebp)
  }
  return cmd;
}
     6be:	8b 75 f8             	mov    -0x8(%ebp),%esi
     6c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6c4:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     6c7:	89 ec                	mov    %ebp,%esp
     6c9:	5d                   	pop    %ebp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	e9 51 fc ff ff       	jmp    320 <pipecmd>
     6cf:	90                   	nop

000006d0 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     6d0:	55                   	push   %ebp
     6d1:	89 e5                	mov    %esp,%ebp
     6d3:	57                   	push   %edi
     6d4:	56                   	push   %esi
     6d5:	53                   	push   %ebx
     6d6:	83 ec 1c             	sub    $0x1c,%esp
     6d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     6df:	89 1c 24             	mov    %ebx,(%esp)
     6e2:	89 74 24 04          	mov    %esi,0x4(%esp)
     6e6:	e8 55 ff ff ff       	call   640 <parsepipe>
     6eb:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     6ed:	eb 27                	jmp    716 <parseline+0x46>
     6ef:	90                   	nop
    gettoken(ps, es, 0, 0);
     6f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     6f7:	00 
     6f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     6ff:	00 
     700:	89 74 24 04          	mov    %esi,0x4(%esp)
     704:	89 1c 24             	mov    %ebx,(%esp)
     707:	e8 24 fa ff ff       	call   130 <gettoken>
    cmd = backcmd(cmd);
     70c:	89 3c 24             	mov    %edi,(%esp)
     70f:	e8 6c fb ff ff       	call   280 <backcmd>
     714:	89 c7                	mov    %eax,%edi
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     716:	c7 44 24 08 fe 16 00 	movl   $0x16fe,0x8(%esp)
     71d:	00 
     71e:	89 74 24 04          	mov    %esi,0x4(%esp)
     722:	89 1c 24             	mov    %ebx,(%esp)
     725:	e8 86 f9 ff ff       	call   b0 <peek>
     72a:	85 c0                	test   %eax,%eax
     72c:	75 c2                	jne    6f0 <parseline+0x20>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     72e:	c7 44 24 08 fa 16 00 	movl   $0x16fa,0x8(%esp)
     735:	00 
     736:	89 74 24 04          	mov    %esi,0x4(%esp)
     73a:	89 1c 24             	mov    %ebx,(%esp)
     73d:	e8 6e f9 ff ff       	call   b0 <peek>
     742:	85 c0                	test   %eax,%eax
     744:	75 0a                	jne    750 <parseline+0x80>
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}
     746:	83 c4 1c             	add    $0x1c,%esp
     749:	89 f8                	mov    %edi,%eax
     74b:	5b                   	pop    %ebx
     74c:	5e                   	pop    %esi
     74d:	5f                   	pop    %edi
     74e:	5d                   	pop    %ebp
     74f:	c3                   	ret    
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
     750:	89 74 24 04          	mov    %esi,0x4(%esp)
     754:	89 1c 24             	mov    %ebx,(%esp)
     757:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     75e:	00 
     75f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     766:	00 
     767:	e8 c4 f9 ff ff       	call   130 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     76c:	89 74 24 04          	mov    %esi,0x4(%esp)
     770:	89 1c 24             	mov    %ebx,(%esp)
     773:	e8 58 ff ff ff       	call   6d0 <parseline>
     778:	89 7d 08             	mov    %edi,0x8(%ebp)
     77b:	89 45 0c             	mov    %eax,0xc(%ebp)
  }
  return cmd;
}
     77e:	83 c4 1c             	add    $0x1c,%esp
     781:	5b                   	pop    %ebx
     782:	5e                   	pop    %esi
     783:	5f                   	pop    %edi
     784:	5d                   	pop    %ebp
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
     785:	e9 46 fb ff ff       	jmp    2d0 <listcmd>
     78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000790 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     790:	55                   	push   %ebp
     791:	89 e5                	mov    %esp,%ebp
     793:	83 ec 28             	sub    $0x28,%esp
     796:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     799:	8b 5d 08             	mov    0x8(%ebp),%ebx
     79c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     79f:	8b 75 0c             	mov    0xc(%ebp),%esi
     7a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     7a5:	c7 44 24 08 e0 16 00 	movl   $0x16e0,0x8(%esp)
     7ac:	00 
     7ad:	89 1c 24             	mov    %ebx,(%esp)
     7b0:	89 74 24 04          	mov    %esi,0x4(%esp)
     7b4:	e8 f7 f8 ff ff       	call   b0 <peek>
     7b9:	85 c0                	test   %eax,%eax
     7bb:	0f 84 87 00 00 00    	je     848 <parseblock+0xb8>
    panic("parseblock");
  gettoken(ps, es, 0, 0);
     7c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7c8:	00 
     7c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7d0:	00 
     7d1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7d5:	89 1c 24             	mov    %ebx,(%esp)
     7d8:	e8 53 f9 ff ff       	call   130 <gettoken>
  cmd = parseline(ps, es);
     7dd:	89 74 24 04          	mov    %esi,0x4(%esp)
     7e1:	89 1c 24             	mov    %ebx,(%esp)
     7e4:	e8 e7 fe ff ff       	call   6d0 <parseline>
  if(!peek(ps, es, ")"))
     7e9:	c7 44 24 08 1c 17 00 	movl   $0x171c,0x8(%esp)
     7f0:	00 
     7f1:	89 74 24 04          	mov    %esi,0x4(%esp)
     7f5:	89 1c 24             	mov    %ebx,(%esp)
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
     7f8:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     7fa:	e8 b1 f8 ff ff       	call   b0 <peek>
     7ff:	85 c0                	test   %eax,%eax
     801:	75 0c                	jne    80f <parseblock+0x7f>
    panic("syntax - missing )");
     803:	c7 04 24 0b 17 00 00 	movl   $0x170b,(%esp)
     80a:	e8 01 fc ff ff       	call   410 <panic>
  gettoken(ps, es, 0, 0);
     80f:	89 74 24 04          	mov    %esi,0x4(%esp)
     813:	89 1c 24             	mov    %ebx,(%esp)
     816:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     81d:	00 
     81e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     825:	00 
     826:	e8 05 f9 ff ff       	call   130 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     82b:	89 74 24 08          	mov    %esi,0x8(%esp)
     82f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     833:	89 3c 24             	mov    %edi,(%esp)
     836:	e8 05 fc ff ff       	call   440 <parseredirs>
  return cmd;
}
     83b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     83e:	8b 75 f8             	mov    -0x8(%ebp),%esi
     841:	8b 7d fc             	mov    -0x4(%ebp),%edi
     844:	89 ec                	mov    %ebp,%esp
     846:	5d                   	pop    %ebp
     847:	c3                   	ret    
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
     848:	c7 04 24 00 17 00 00 	movl   $0x1700,(%esp)
     84f:	e8 bc fb ff ff       	call   410 <panic>
     854:	e9 68 ff ff ff       	jmp    7c1 <parseblock+0x31>
     859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000860 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	56                   	push   %esi
     864:	53                   	push   %ebx
     865:	83 ec 10             	sub    $0x10,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     868:	8b 5d 08             	mov    0x8(%ebp),%ebx
     86b:	89 1c 24             	mov    %ebx,(%esp)
     86e:	e8 8d 06 00 00       	call   f00 <strlen>
     873:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     875:	8d 45 08             	lea    0x8(%ebp),%eax
     878:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     87c:	89 04 24             	mov    %eax,(%esp)
     87f:	e8 4c fe ff ff       	call   6d0 <parseline>
  peek(&s, es, "");
     884:	c7 44 24 08 4b 17 00 	movl   $0x174b,0x8(%esp)
     88b:	00 
     88c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
     890:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     892:	8d 45 08             	lea    0x8(%ebp),%eax
     895:	89 04 24             	mov    %eax,(%esp)
     898:	e8 13 f8 ff ff       	call   b0 <peek>
  if(s != es){
     89d:	8b 45 08             	mov    0x8(%ebp),%eax
     8a0:	39 d8                	cmp    %ebx,%eax
     8a2:	74 24                	je     8c8 <parsecmd+0x68>
    printf(2, "leftovers: %s\n", s);
     8a4:	89 44 24 08          	mov    %eax,0x8(%esp)
     8a8:	c7 44 24 04 1e 17 00 	movl   $0x171e,0x4(%esp)
     8af:	00 
     8b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8b7:	e8 54 0a 00 00       	call   1310 <printf>
    panic("syntax");
     8bc:	c7 04 24 e2 16 00 00 	movl   $0x16e2,(%esp)
     8c3:	e8 48 fb ff ff       	call   410 <panic>
  }
  nulterminate(cmd);
     8c8:	89 34 24             	mov    %esi,(%esp)
     8cb:	e8 30 f7 ff ff       	call   0 <nulterminate>
  return cmd;
}
     8d0:	83 c4 10             	add    $0x10,%esp
     8d3:	89 f0                	mov    %esi,%eax
     8d5:	5b                   	pop    %ebx
     8d6:	5e                   	pop    %esi
     8d7:	5d                   	pop    %ebp
     8d8:	c3                   	ret    
     8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <fork1>:
  exit();
}

int
fork1(void)
{
     8e0:	55                   	push   %ebp
     8e1:	89 e5                	mov    %esp,%ebp
     8e3:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
     8e6:	e8 c5 08 00 00       	call   11b0 <fork>
  if(pid == -1)
     8eb:	83 f8 ff             	cmp    $0xffffffff,%eax
     8ee:	74 08                	je     8f8 <fork1+0x18>
    panic("fork");
  return pid;
}
     8f0:	c9                   	leave  
     8f1:	c3                   	ret    
     8f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    panic("fork");
     8f8:	c7 04 24 2d 17 00 00 	movl   $0x172d,(%esp)
     8ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     902:	e8 09 fb ff ff       	call   410 <panic>
     907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  return pid;
}
     90a:	c9                   	leave  
     90b:	c3                   	ret    
     90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000910 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	83 ec 18             	sub    $0x18,%esp
     916:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     919:	8b 5d 08             	mov    0x8(%ebp),%ebx
     91c:	89 75 fc             	mov    %esi,-0x4(%ebp)
     91f:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     922:	c7 44 24 04 32 17 00 	movl   $0x1732,0x4(%esp)
     929:	00 
     92a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     931:	e8 da 09 00 00       	call   1310 <printf>
  memset(buf, 0, nbuf);
     936:	89 74 24 08          	mov    %esi,0x8(%esp)
     93a:	89 1c 24             	mov    %ebx,(%esp)
     93d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     944:	00 
     945:	e8 d6 05 00 00       	call   f20 <memset>
  gets(buf, nbuf);
     94a:	89 74 24 04          	mov    %esi,0x4(%esp)
     94e:	89 1c 24             	mov    %ebx,(%esp)
     951:	e8 fa 07 00 00       	call   1150 <gets>
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     956:	8b 75 fc             	mov    -0x4(%ebp),%esi
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     959:	80 3b 01             	cmpb   $0x1,(%ebx)
    return -1;
  return 0;
}
     95c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
     95f:	19 c0                	sbb    %eax,%eax
    return -1;
  return 0;
}
     961:	89 ec                	mov    %ebp,%esp
     963:	5d                   	pop    %ebp
     964:	c3                   	ret    
     965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000970 <myexec>:
	exit();
}
return arrpath;
}

int myexec(char* path, char** argv, char** arrpath, int len) {
     970:	55                   	push   %ebp
     971:	89 e5                	mov    %esp,%ebp
     973:	57                   	push   %edi
     974:	56                   	push   %esi
     975:	53                   	push   %ebx
     976:	83 ec 1c             	sub    $0x1c,%esp
int i=0;
while(i<=len) {
     979:	8b 4d 14             	mov    0x14(%ebp),%ecx
	exit();
}
return arrpath;
}

int myexec(char* path, char** argv, char** arrpath, int len) {
     97c:	8b 7d 08             	mov    0x8(%ebp),%edi
     97f:	8b 75 10             	mov    0x10(%ebp),%esi
int i=0;
while(i<=len) {
     982:	85 c9                	test   %ecx,%ecx
     984:	78 2b                	js     9b1 <myexec+0x41>
     986:	31 db                	xor    %ebx,%ebx
strcat(arrpath[i],path);
     988:	89 7c 24 04          	mov    %edi,0x4(%esp)
     98c:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
     98f:	89 04 24             	mov    %eax,(%esp)
     992:	e8 19 07 00 00       	call   10b0 <strcat>
exec(arrpath[i],argv);
     997:	8b 45 0c             	mov    0xc(%ebp),%eax
     99a:	89 44 24 04          	mov    %eax,0x4(%esp)
     99e:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
i++;
     9a1:	83 c3 01             	add    $0x1,%ebx

int myexec(char* path, char** argv, char** arrpath, int len) {
int i=0;
while(i<=len) {
strcat(arrpath[i],path);
exec(arrpath[i],argv);
     9a4:	89 04 24             	mov    %eax,(%esp)
     9a7:	e8 4c 08 00 00       	call   11f8 <exec>
return arrpath;
}

int myexec(char* path, char** argv, char** arrpath, int len) {
int i=0;
while(i<=len) {
     9ac:	39 5d 14             	cmp    %ebx,0x14(%ebp)
     9af:	7d d7                	jge    988 <myexec+0x18>
strcat(arrpath[i],path);
exec(arrpath[i],argv);
i++;
}
return 0;
}
     9b1:	83 c4 1c             	add    $0x1c,%esp
     9b4:	31 c0                	xor    %eax,%eax
     9b6:	5b                   	pop    %ebx
     9b7:	5e                   	pop    %esi
     9b8:	5f                   	pop    %edi
     9b9:	5d                   	pop    %ebp
     9ba:	c3                   	ret    
     9bb:	90                   	nop
     9bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009c0 <runcmd>:


// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd,char** arrpath,int len)
{
     9c0:	55                   	push   %ebp
     9c1:	89 e5                	mov    %esp,%ebp
     9c3:	83 ec 38             	sub    $0x38,%esp
     9c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     9c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
     9cf:	8b 75 0c             	mov    0xc(%ebp),%esi
     9d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
     9d5:	8b 7d 10             	mov    0x10(%ebp),%edi
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     9d8:	85 db                	test   %ebx,%ebx
     9da:	74 4a                	je     a26 <runcmd+0x66>
    exit();
  
  switch(cmd->type){
     9dc:	83 3b 05             	cmpl   $0x5,(%ebx)
     9df:	76 4f                	jbe    a30 <runcmd+0x70>
  default:
    panic("runcmd");
     9e1:	c7 04 24 35 17 00 00 	movl   $0x1735,(%esp)
     9e8:	e8 23 fa ff ff       	call   410 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     9ed:	8b 43 04             	mov    0x4(%ebx),%eax
     9f0:	85 c0                	test   %eax,%eax
     9f2:	74 32                	je     a26 <runcmd+0x66>
      exit();
    myexec(ecmd->argv[0], ecmd->argv, arrpath, len);
     9f4:	8d 53 04             	lea    0x4(%ebx),%edx
     9f7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
     9fb:	89 74 24 08          	mov    %esi,0x8(%esp)
     9ff:	89 54 24 04          	mov    %edx,0x4(%esp)
     a03:	89 04 24             	mov    %eax,(%esp)
     a06:	e8 65 ff ff ff       	call   970 <myexec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     a0b:	8b 43 04             	mov    0x4(%ebx),%eax
     a0e:	c7 44 24 04 3c 17 00 	movl   $0x173c,0x4(%esp)
     a15:	00 
     a16:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     a1d:	89 44 24 08          	mov    %eax,0x8(%esp)
     a21:	e8 ea 08 00 00       	call   1310 <printf>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     a26:	e8 8d 07 00 00       	call   11b8 <exit>
     a2b:	90                   	nop
     a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct redircmd *rcmd;

  if(cmd == 0)
    exit();
  
  switch(cmd->type){
     a30:	8b 03                	mov    (%ebx),%eax
     a32:	ff 24 85 a8 16 00 00 	jmp    *0x16a8(,%eax,4)
     a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wait();
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     a40:	e8 9b fe ff ff       	call   8e0 <fork1>
     a45:	85 c0                	test   %eax,%eax
     a47:	0f 84 b8 00 00 00    	je     b05 <runcmd+0x145>
     a4d:	8d 76 00             	lea    0x0(%esi),%esi
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     a50:	e8 63 07 00 00       	call   11b8 <exit>
     a55:	8d 76 00             	lea    0x0(%esi),%esi
    runcmd(rcmd->cmd, arrpath, len);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     a58:	e8 83 fe ff ff       	call   8e0 <fork1>
     a5d:	85 c0                	test   %eax,%eax
     a5f:	90                   	nop
     a60:	0f 84 ba 00 00 00    	je     b20 <runcmd+0x160>
      runcmd(lcmd->left, arrpath, len);
    wait();
     a66:	e8 55 07 00 00       	call   11c0 <wait>
    runcmd(lcmd->right, arrpath, len);
     a6b:	89 7c 24 08          	mov    %edi,0x8(%esp)
     a6f:	89 74 24 04          	mov    %esi,0x4(%esp)
     a73:	8b 43 08             	mov    0x8(%ebx),%eax
     a76:	89 04 24             	mov    %eax,(%esp)
     a79:	e8 42 ff ff ff       	call   9c0 <runcmd>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     a7e:	e8 35 07 00 00       	call   11b8 <exit>
     a83:	90                   	nop
     a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    runcmd(lcmd->right, arrpath, len);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     a88:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a8b:	89 04 24             	mov    %eax,(%esp)
     a8e:	e8 3d 07 00 00       	call   11d0 <pipe>
     a93:	85 c0                	test   %eax,%eax
     a95:	0f 88 4d 01 00 00    	js     be8 <runcmd+0x228>
      panic("pipe");
    if(fork1() == 0){
     a9b:	e8 40 fe ff ff       	call   8e0 <fork1>
     aa0:	85 c0                	test   %eax,%eax
     aa2:	0f 84 d8 00 00 00    	je     b80 <runcmd+0x1c0>
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left, arrpath, len);
    }
    if(fork1() == 0){
     aa8:	e8 33 fe ff ff       	call   8e0 <fork1>
     aad:	85 c0                	test   %eax,%eax
     aaf:	90                   	nop
     ab0:	0f 84 82 00 00 00    	je     b38 <runcmd+0x178>
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right, arrpath, len);
    }
    close(p[0]);
     ab6:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ab9:	89 04 24             	mov    %eax,(%esp)
     abc:	e8 27 07 00 00       	call   11e8 <close>
    close(p[1]);
     ac1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ac4:	89 04 24             	mov    %eax,(%esp)
     ac7:	e8 1c 07 00 00       	call   11e8 <close>
    wait();
     acc:	e8 ef 06 00 00       	call   11c0 <wait>
    wait();
     ad1:	e8 ea 06 00 00       	call   11c0 <wait>
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
    break;
  }
  exit();
     ad6:	e8 dd 06 00 00       	call   11b8 <exit>
     adb:	90                   	nop
     adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     ae0:	8b 43 14             	mov    0x14(%ebx),%eax
     ae3:	89 04 24             	mov    %eax,(%esp)
     ae6:	e8 fd 06 00 00       	call   11e8 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     aeb:	8b 43 10             	mov    0x10(%ebx),%eax
     aee:	89 44 24 04          	mov    %eax,0x4(%esp)
     af2:	8b 43 08             	mov    0x8(%ebx),%eax
     af5:	89 04 24             	mov    %eax,(%esp)
     af8:	e8 03 07 00 00       	call   1200 <open>
     afd:	85 c0                	test   %eax,%eax
     aff:	0f 88 c3 00 00 00    	js     bc8 <runcmd+0x208>
    break;
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd, arrpath, len);
     b05:	89 7c 24 08          	mov    %edi,0x8(%esp)
     b09:	89 74 24 04          	mov    %esi,0x4(%esp)
     b0d:	8b 43 04             	mov    0x4(%ebx),%eax
     b10:	89 04 24             	mov    %eax,(%esp)
     b13:	e8 a8 fe ff ff       	call   9c0 <runcmd>
    break;
  }
  exit();
     b18:	e8 9b 06 00 00       	call   11b8 <exit>
     b1d:	8d 76 00             	lea    0x0(%esi),%esi
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left, arrpath, len);
     b20:	89 7c 24 08          	mov    %edi,0x8(%esp)
     b24:	89 74 24 04          	mov    %esi,0x4(%esp)
     b28:	8b 43 04             	mov    0x4(%ebx),%eax
     b2b:	89 04 24             	mov    %eax,(%esp)
     b2e:	e8 8d fe ff ff       	call   9c0 <runcmd>
     b33:	e9 2e ff ff ff       	jmp    a66 <runcmd+0xa6>
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left, arrpath, len);
    }
    if(fork1() == 0){
      close(0);
     b38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     b3f:	e8 a4 06 00 00       	call   11e8 <close>
      dup(p[0]);
     b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b47:	89 04 24             	mov    %eax,(%esp)
     b4a:	e8 e9 06 00 00       	call   1238 <dup>
      close(p[0]);
     b4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b52:	89 04 24             	mov    %eax,(%esp)
     b55:	e8 8e 06 00 00       	call   11e8 <close>
      close(p[1]);
     b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b5d:	89 04 24             	mov    %eax,(%esp)
     b60:	e8 83 06 00 00       	call   11e8 <close>
      runcmd(pcmd->right, arrpath, len);
     b65:	89 7c 24 08          	mov    %edi,0x8(%esp)
     b69:	89 74 24 04          	mov    %esi,0x4(%esp)
     b6d:	8b 43 08             	mov    0x8(%ebx),%eax
     b70:	89 04 24             	mov    %eax,(%esp)
     b73:	e8 48 fe ff ff       	call   9c0 <runcmd>
     b78:	e9 39 ff ff ff       	jmp    ab6 <runcmd+0xf6>
     b7d:	8d 76 00             	lea    0x0(%esi),%esi
  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
     b80:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b87:	e8 5c 06 00 00       	call   11e8 <close>
      dup(p[1]);
     b8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     b8f:	89 04 24             	mov    %eax,(%esp)
     b92:	e8 a1 06 00 00       	call   1238 <dup>
      close(p[0]);
     b97:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b9a:	89 04 24             	mov    %eax,(%esp)
     b9d:	e8 46 06 00 00       	call   11e8 <close>
      close(p[1]);
     ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ba5:	89 04 24             	mov    %eax,(%esp)
     ba8:	e8 3b 06 00 00       	call   11e8 <close>
      runcmd(pcmd->left, arrpath, len);
     bad:	89 7c 24 08          	mov    %edi,0x8(%esp)
     bb1:	89 74 24 04          	mov    %esi,0x4(%esp)
     bb5:	8b 43 04             	mov    0x4(%ebx),%eax
     bb8:	89 04 24             	mov    %eax,(%esp)
     bbb:	e8 00 fe ff ff       	call   9c0 <runcmd>
     bc0:	e9 e3 fe ff ff       	jmp    aa8 <runcmd+0xe8>
     bc5:	8d 76 00             	lea    0x0(%esi),%esi

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
     bc8:	8b 43 08             	mov    0x8(%ebx),%eax
     bcb:	c7 44 24 04 4c 17 00 	movl   $0x174c,0x4(%esp)
     bd2:	00 
     bd3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     bda:	89 44 24 08          	mov    %eax,0x8(%esp)
     bde:	e8 2d 07 00 00       	call   1310 <printf>
      exit();
     be3:	e8 d0 05 00 00       	call   11b8 <exit>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
     be8:	c7 04 24 5c 17 00 00 	movl   $0x175c,(%esp)
     bef:	e8 1c f8 ff ff       	call   410 <panic>
     bf4:	e9 a2 fe ff ff       	jmp    a9b <runcmd+0xdb>
     bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c00 <parsepath>:
int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct cmd *parsecmd(char*);


char** parsepath(int* i) {
     c00:	55                   	push   %ebp
     c01:	89 e5                	mov    %esp,%ebp
     c03:	57                   	push   %edi
     c04:	56                   	push   %esi
     c05:	53                   	push   %ebx
     c06:	83 ec 2c             	sub    $0x2c,%esp
     c09:	8b 7d 08             	mov    0x8(%ebp),%edi
int fd = open(".env",O_RDONLY);
     c0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c13:	00 
     c14:	c7 04 24 61 17 00 00 	movl   $0x1761,(%esp)
     c1b:	e8 e0 05 00 00       	call   1200 <open>
char* buf = malloc(100);
     c20:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
void panic(char*);
struct cmd *parsecmd(char*);


char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
     c27:	89 c6                	mov    %eax,%esi
char* buf = malloc(100);
     c29:	e8 82 09 00 00       	call   15b0 <malloc>
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
     c2e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
struct cmd *parsecmd(char*);


char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
     c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
     c38:	e8 73 09 00 00       	call   15b0 <malloc>
char** arrpath = malloc(4);
     c3d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
     c44:	89 c3                	mov    %eax,%ebx
char** arrpath = malloc(4);
     c46:	e8 65 09 00 00       	call   15b0 <malloc>
if(fd < 0) {
     c4b:	85 f6                	test   %esi,%esi
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
char** arrpath = malloc(4);
     c4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
if(fd < 0) {
     c50:	0f 88 c7 00 00 00    	js     d1d <parsepath+0x11d>
	printf(1,"no environment file: %d",fd);
	exit();
}
else {
	read(fd,pathstrt,5);
     c56:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
     c5d:	00 
     c5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     c62:	89 34 24             	mov    %esi,(%esp)
     c65:	e8 6e 05 00 00       	call   11d8 <read>
	pathstrt[5] = '\0';
     c6a:	c6 43 05 00          	movb   $0x0,0x5(%ebx)
	if(strcmp(pathstrt,"PATH=") == 0) {
     c6e:	c7 44 24 04 7e 17 00 	movl   $0x177e,0x4(%esp)
     c75:	00 
     c76:	89 1c 24             	mov    %ebx,(%esp)
     c79:	e8 32 02 00 00       	call   eb0 <strcmp>
     c7e:	85 c0                	test   %eax,%eax
     c80:	0f 85 cd 00 00 00    	jne    d53 <parsepath+0x153>
struct cmd *parsecmd(char*);


char** parsepath(int* i) {
int fd = open(".env",O_RDONLY);
char* buf = malloc(100);
     c86:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
     c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
else {
	read(fd,pathstrt,5);
	pathstrt[5] = '\0';
	if(strcmp(pathstrt,"PATH=") == 0) {
		while(read(fd,buf,count)) {
     c90:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c97:	00 
     c98:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     c9c:	89 34 24             	mov    %esi,(%esp)
     c9f:	e8 34 05 00 00       	call   11d8 <read>
     ca4:	85 c0                	test   %eax,%eax
     ca6:	74 50                	je     cf8 <parsepath+0xf8>
			if((*buf) != ':') {
     ca8:	80 3b 3a             	cmpb   $0x3a,(%ebx)
     cab:	74 0b                	je     cb8 <parsepath+0xb8>
				//printf(1,"char: %c",*buf);
				buf+=1;
     cad:	83 c3 01             	add    $0x1,%ebx
     cb0:	eb de                	jmp    c90 <parsepath+0x90>
     cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			}
			else {
				*buf = '\0';
     cb8:	c6 03 00             	movb   $0x0,(%ebx)
				//printf(1," startis=%s ",start);
				arrpath[(*i)] = start;
     cbb:	8b 07                	mov    (%edi),%eax
     cbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     cc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
     cc3:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
				(*i)++;
     cc6:	8b 1f                	mov    (%edi),%ebx
     cc8:	83 c3 01             	add    $0x1,%ebx
     ccb:	89 1f                	mov    %ebx,(%edi)
				arrpath[(*i)] = malloc(4);
     ccd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     cd4:	e8 d7 08 00 00       	call   15b0 <malloc>
     cd9:	8b 55 e0             	mov    -0x20(%ebp),%edx
     cdc:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
				buf = start+100;
				buf = malloc(100);
     cdf:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     ce6:	e8 c5 08 00 00       	call   15b0 <malloc>
     ceb:	89 c3                	mov    %eax,%ebx
     ced:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     cf0:	eb 9e                	jmp    c90 <parsepath+0x90>
     cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				start = buf;
			}
		}
		*buf = '\0';
     cf8:	c6 03 00             	movb   $0x0,(%ebx)
		arrpath[(*i)] = start;
     cfb:	8b 07                	mov    (%edi),%eax
     cfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     d00:	8b 4d e0             	mov    -0x20(%ebp),%ecx
     d03:	89 14 81             	mov    %edx,(%ecx,%eax,4)
	else {
		printf(1,".env isnt defined correctly");
		exit();
	}
}
if(close(fd) != 0) {
     d06:	89 34 24             	mov    %esi,(%esp)
     d09:	e8 da 04 00 00       	call   11e8 <close>
     d0e:	85 c0                	test   %eax,%eax
     d10:	75 28                	jne    d3a <parsepath+0x13a>
	printf(1,"error in closing the file descriptor");
	exit();
}
return arrpath;
}
     d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d15:	83 c4 2c             	add    $0x2c,%esp
     d18:	5b                   	pop    %ebx
     d19:	5e                   	pop    %esi
     d1a:	5f                   	pop    %edi
     d1b:	5d                   	pop    %ebp
     d1c:	c3                   	ret    
int count = 1;
char* start = buf;
char* pathstrt = malloc(6);
char** arrpath = malloc(4);
if(fd < 0) {
	printf(1,"no environment file: %d",fd);
     d1d:	89 74 24 08          	mov    %esi,0x8(%esp)
     d21:	c7 44 24 04 66 17 00 	movl   $0x1766,0x4(%esp)
     d28:	00 
     d29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d30:	e8 db 05 00 00       	call   1310 <printf>
	exit();
     d35:	e8 7e 04 00 00       	call   11b8 <exit>
		printf(1,".env isnt defined correctly");
		exit();
	}
}
if(close(fd) != 0) {
	printf(1,"error in closing the file descriptor");
     d3a:	c7 44 24 04 b8 17 00 	movl   $0x17b8,0x4(%esp)
     d41:	00 
     d42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d49:	e8 c2 05 00 00       	call   1310 <printf>
	exit();
     d4e:	e8 65 04 00 00       	call   11b8 <exit>
		}
		*buf = '\0';
		arrpath[(*i)] = start;
	}
	else {
		printf(1,".env isnt defined correctly");
     d53:	c7 44 24 04 84 17 00 	movl   $0x1784,0x4(%esp)
     d5a:	00 
     d5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d62:	e8 a9 05 00 00       	call   1310 <printf>
		exit();
     d67:	e8 4c 04 00 00       	call   11b8 <exit>
     d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d70 <main>:
  return 0;
}

int
main(void)
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	83 e4 f0             	and    $0xfffffff0,%esp
     d76:	56                   	push   %esi
     d77:	53                   	push   %ebx
     d78:	83 ec 28             	sub    $0x28,%esp
     d7b:	90                   	nop
     d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     d80:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     d87:	00 
     d88:	c7 04 24 a0 17 00 00 	movl   $0x17a0,(%esp)
     d8f:	e8 6c 04 00 00       	call   1200 <open>
     d94:	85 c0                	test   %eax,%eax
     d96:	78 0d                	js     da5 <main+0x35>
    if(fd >= 3){
     d98:	83 f8 02             	cmp    $0x2,%eax
     d9b:	7e e3                	jle    d80 <main+0x10>
      close(fd);
     d9d:	89 04 24             	mov    %eax,(%esp)
     da0:	e8 43 04 00 00       	call   11e8 <close>
      break;
    }
  }
int len = 0;
char** arrpath = parsepath(&len);
     da5:	8d 44 24 1c          	lea    0x1c(%esp),%eax
    if(fd >= 3){
      close(fd);
      break;
    }
  }
int len = 0;
     da9:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
     db0:	00 
char** arrpath = parsepath(&len);
     db1:	89 04 24             	mov    %eax,(%esp)
     db4:	e8 47 fe ff ff       	call   c00 <parsepath>
     db9:	89 c6                	mov    %eax,%esi
//printf(1,"path: %s",arrpath[i]);
//i++;
//}

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     dbb:	eb 08                	jmp    dc5 <main+0x55>
     dbd:	8d 76 00             	lea    0x0(%esi),%esi
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf),arrpath,len);
    wait();
     dc0:	e8 fb 03 00 00       	call   11c0 <wait>
//printf(1,"path: %s",arrpath[i]);
//i++;
//}

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     dc5:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     dcc:	00 
     dcd:	c7 04 24 20 18 00 00 	movl   $0x1820,(%esp)
     dd4:	e8 37 fb ff ff       	call   910 <getcmd>
     dd9:	85 c0                	test   %eax,%eax
     ddb:	0f 88 97 00 00 00    	js     e78 <main+0x108>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     de1:	80 3d 20 18 00 00 63 	cmpb   $0x63,0x1820
     de8:	75 09                	jne    df3 <main+0x83>
     dea:	80 3d 21 18 00 00 64 	cmpb   $0x64,0x1821
     df1:	74 2d                	je     e20 <main+0xb0>
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0)
     df3:	e8 e8 fa ff ff       	call   8e0 <fork1>
     df8:	85 c0                	test   %eax,%eax
     dfa:	75 c4                	jne    dc0 <main+0x50>
      runcmd(parsecmd(buf),arrpath,len);
     dfc:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
     e00:	c7 04 24 20 18 00 00 	movl   $0x1820,(%esp)
     e07:	e8 54 fa ff ff       	call   860 <parsecmd>
     e0c:	89 74 24 04          	mov    %esi,0x4(%esp)
     e10:	89 5c 24 08          	mov    %ebx,0x8(%esp)
     e14:	89 04 24             	mov    %eax,(%esp)
     e17:	e8 a4 fb ff ff       	call   9c0 <runcmd>
     e1c:	eb a2                	jmp    dc0 <main+0x50>
     e1e:	66 90                	xchg   %ax,%ax
//i++;
//}

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e20:	80 3d 22 18 00 00 20 	cmpb   $0x20,0x1822
     e27:	75 ca                	jne    df3 <main+0x83>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     e29:	c7 04 24 20 18 00 00 	movl   $0x1820,(%esp)
     e30:	e8 cb 00 00 00       	call   f00 <strlen>
      if(chdir(buf+3) < 0)
     e35:	c7 04 24 23 18 00 00 	movl   $0x1823,(%esp)
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     e3c:	c6 80 1f 18 00 00 00 	movb   $0x0,0x181f(%eax)
      if(chdir(buf+3) < 0)
     e43:	e8 e8 03 00 00       	call   1230 <chdir>
     e48:	85 c0                	test   %eax,%eax
     e4a:	0f 89 75 ff ff ff    	jns    dc5 <main+0x55>
        printf(2, "cannot cd %s\n", buf+3);
     e50:	c7 44 24 08 23 18 00 	movl   $0x1823,0x8(%esp)
     e57:	00 
     e58:	c7 44 24 04 a8 17 00 	movl   $0x17a8,0x4(%esp)
     e5f:	00 
     e60:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     e67:	e8 a4 04 00 00       	call   1310 <printf>
     e6c:	e9 54 ff ff ff       	jmp    dc5 <main+0x55>
     e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf),arrpath,len);
    wait();
  }
  exit();
     e78:	e8 3b 03 00 00       	call   11b8 <exit>
     e7d:	90                   	nop
     e7e:	90                   	nop
     e7f:	90                   	nop

00000e80 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     e80:	55                   	push   %ebp
     e81:	31 d2                	xor    %edx,%edx
     e83:	89 e5                	mov    %esp,%ebp
     e85:	8b 45 08             	mov    0x8(%ebp),%eax
     e88:	53                   	push   %ebx
     e89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     e90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     e94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     e97:	83 c2 01             	add    $0x1,%edx
     e9a:	84 c9                	test   %cl,%cl
     e9c:	75 f2                	jne    e90 <strcpy+0x10>
    ;
  return os;
}
     e9e:	5b                   	pop    %ebx
     e9f:	5d                   	pop    %ebp
     ea0:	c3                   	ret    
     ea1:	eb 0d                	jmp    eb0 <strcmp>
     ea3:	90                   	nop
     ea4:	90                   	nop
     ea5:	90                   	nop
     ea6:	90                   	nop
     ea7:	90                   	nop
     ea8:	90                   	nop
     ea9:	90                   	nop
     eaa:	90                   	nop
     eab:	90                   	nop
     eac:	90                   	nop
     ead:	90                   	nop
     eae:	90                   	nop
     eaf:	90                   	nop

00000eb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     eb0:	55                   	push   %ebp
     eb1:	89 e5                	mov    %esp,%ebp
     eb3:	53                   	push   %ebx
     eb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
     eb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     eba:	0f b6 01             	movzbl (%ecx),%eax
     ebd:	84 c0                	test   %al,%al
     ebf:	75 14                	jne    ed5 <strcmp+0x25>
     ec1:	eb 25                	jmp    ee8 <strcmp+0x38>
     ec3:	90                   	nop
     ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p++, q++;
     ec8:	83 c1 01             	add    $0x1,%ecx
     ecb:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ece:	0f b6 01             	movzbl (%ecx),%eax
     ed1:	84 c0                	test   %al,%al
     ed3:	74 13                	je     ee8 <strcmp+0x38>
     ed5:	0f b6 1a             	movzbl (%edx),%ebx
     ed8:	38 d8                	cmp    %bl,%al
     eda:	74 ec                	je     ec8 <strcmp+0x18>
     edc:	0f b6 db             	movzbl %bl,%ebx
     edf:	0f b6 c0             	movzbl %al,%eax
     ee2:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     ee4:	5b                   	pop    %ebx
     ee5:	5d                   	pop    %ebp
     ee6:	c3                   	ret    
     ee7:	90                   	nop
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ee8:	0f b6 1a             	movzbl (%edx),%ebx
     eeb:	31 c0                	xor    %eax,%eax
     eed:	0f b6 db             	movzbl %bl,%ebx
     ef0:	29 d8                	sub    %ebx,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
     ef2:	5b                   	pop    %ebx
     ef3:	5d                   	pop    %ebp
     ef4:	c3                   	ret    
     ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f00 <strlen>:

uint
strlen(char *s)
{
     f00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
     f01:	31 d2                	xor    %edx,%edx
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     f03:	89 e5                	mov    %esp,%ebp
  int n;

  for(n = 0; s[n]; n++)
     f05:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
     f07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     f0a:	80 39 00             	cmpb   $0x0,(%ecx)
     f0d:	74 0c                	je     f1b <strlen+0x1b>
     f0f:	90                   	nop
     f10:	83 c2 01             	add    $0x1,%edx
     f13:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     f17:	89 d0                	mov    %edx,%eax
     f19:	75 f5                	jne    f10 <strlen+0x10>
    ;
  return n;
}
     f1b:	5d                   	pop    %ebp
     f1c:	c3                   	ret    
     f1d:	8d 76 00             	lea    0x0(%esi),%esi

00000f20 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f20:	55                   	push   %ebp
     f21:	89 e5                	mov    %esp,%ebp
     f23:	8b 55 08             	mov    0x8(%ebp),%edx
     f26:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     f27:	8b 4d 10             	mov    0x10(%ebp),%ecx
     f2a:	8b 45 0c             	mov    0xc(%ebp),%eax
     f2d:	89 d7                	mov    %edx,%edi
     f2f:	fc                   	cld    
     f30:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     f32:	89 d0                	mov    %edx,%eax
     f34:	5f                   	pop    %edi
     f35:	5d                   	pop    %ebp
     f36:	c3                   	ret    
     f37:	89 f6                	mov    %esi,%esi
     f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000f40 <strchr>:

char*
strchr(const char *s, char c)
{
     f40:	55                   	push   %ebp
     f41:	89 e5                	mov    %esp,%ebp
     f43:	8b 45 08             	mov    0x8(%ebp),%eax
     f46:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     f4a:	0f b6 10             	movzbl (%eax),%edx
     f4d:	84 d2                	test   %dl,%dl
     f4f:	75 11                	jne    f62 <strchr+0x22>
     f51:	eb 15                	jmp    f68 <strchr+0x28>
     f53:	90                   	nop
     f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f58:	83 c0 01             	add    $0x1,%eax
     f5b:	0f b6 10             	movzbl (%eax),%edx
     f5e:	84 d2                	test   %dl,%dl
     f60:	74 06                	je     f68 <strchr+0x28>
    if(*s == c)
     f62:	38 ca                	cmp    %cl,%dl
     f64:	75 f2                	jne    f58 <strchr+0x18>
      return (char*) s;
  return 0;
}
     f66:	5d                   	pop    %ebp
     f67:	c3                   	ret    
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     f68:	31 c0                	xor    %eax,%eax
    if(*s == c)
      return (char*) s;
  return 0;
}
     f6a:	5d                   	pop    %ebp
     f6b:	90                   	nop
     f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f70:	c3                   	ret    
     f71:	eb 0d                	jmp    f80 <atoi>
     f73:	90                   	nop
     f74:	90                   	nop
     f75:	90                   	nop
     f76:	90                   	nop
     f77:	90                   	nop
     f78:	90                   	nop
     f79:	90                   	nop
     f7a:	90                   	nop
     f7b:	90                   	nop
     f7c:	90                   	nop
     f7d:	90                   	nop
     f7e:	90                   	nop
     f7f:	90                   	nop

00000f80 <atoi>:
  return r;
}

int
atoi(const char *s)
{
     f80:	55                   	push   %ebp
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f81:	31 c0                	xor    %eax,%eax
  return r;
}

int
atoi(const char *s)
{
     f83:	89 e5                	mov    %esp,%ebp
     f85:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f88:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f89:	0f b6 11             	movzbl (%ecx),%edx
     f8c:	8d 5a d0             	lea    -0x30(%edx),%ebx
     f8f:	80 fb 09             	cmp    $0x9,%bl
     f92:	77 1c                	ja     fb0 <atoi+0x30>
     f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n = n*10 + *s++ - '0';
     f98:	0f be d2             	movsbl %dl,%edx
     f9b:	83 c1 01             	add    $0x1,%ecx
     f9e:	8d 04 80             	lea    (%eax,%eax,4),%eax
     fa1:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fa5:	0f b6 11             	movzbl (%ecx),%edx
     fa8:	8d 5a d0             	lea    -0x30(%edx),%ebx
     fab:	80 fb 09             	cmp    $0x9,%bl
     fae:	76 e8                	jbe    f98 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
     fb0:	5b                   	pop    %ebx
     fb1:	5d                   	pop    %ebp
     fb2:	c3                   	ret    
     fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000fc0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     fc0:	55                   	push   %ebp
     fc1:	89 e5                	mov    %esp,%ebp
     fc3:	56                   	push   %esi
     fc4:	8b 45 08             	mov    0x8(%ebp),%eax
     fc7:	53                   	push   %ebx
     fc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
     fcb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     fce:	85 db                	test   %ebx,%ebx
     fd0:	7e 14                	jle    fe6 <memmove+0x26>
    n = n*10 + *s++ - '0';
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
     fd2:	31 d2                	xor    %edx,%edx
     fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
     fd8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     fdc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     fdf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     fe2:	39 da                	cmp    %ebx,%edx
     fe4:	75 f2                	jne    fd8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
     fe6:	5b                   	pop    %ebx
     fe7:	5e                   	pop    %esi
     fe8:	5d                   	pop    %ebp
     fe9:	c3                   	ret    
     fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000ff0 <reverse>:

  /* reverse:  reverse string s in place */
 void reverse(char s[])
 {
     ff0:	55                   	push   %ebp
     ff1:	89 e5                	mov    %esp,%ebp
     ff3:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ff6:	57                   	push   %edi
     ff7:	56                   	push   %esi
     ff8:	53                   	push   %ebx
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
     ff9:	80 39 00             	cmpb   $0x0,(%ecx)
     ffc:	74 37                	je     1035 <reverse+0x45>
     ffe:	31 d2                	xor    %edx,%edx
    1000:	83 c2 01             	add    $0x1,%edx
    1003:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1007:	75 f7                	jne    1000 <reverse+0x10>
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
    1009:	8d 7a ff             	lea    -0x1(%edx),%edi
    100c:	85 ff                	test   %edi,%edi
    100e:	7e 25                	jle    1035 <reverse+0x45>
    1010:	8d 14 11             	lea    (%ecx,%edx,1),%edx
    1013:	31 c0                	xor    %eax,%eax
    1015:	8d 76 00             	lea    0x0(%esi),%esi
         c = s[i];
    1018:	0f b6 34 01          	movzbl (%ecx,%eax,1),%esi
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
    101c:	83 ef 01             	sub    $0x1,%edi
         c = s[i];
         s[i] = s[j];
    101f:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
    1023:	88 1c 01             	mov    %bl,(%ecx,%eax,1)
         s[j] = c;
    1026:	89 f3                	mov    %esi,%ebx
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
    1028:	83 c0 01             	add    $0x1,%eax
         c = s[i];
         s[i] = s[j];
         s[j] = c;
    102b:	88 5a ff             	mov    %bl,-0x1(%edx)
 void reverse(char s[])
 {
     int i, j;
     char c;
 
     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
    102e:	83 ea 01             	sub    $0x1,%edx
    1031:	39 f8                	cmp    %edi,%eax
    1033:	7c e3                	jl     1018 <reverse+0x28>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
    1035:	5b                   	pop    %ebx
    1036:	5e                   	pop    %esi
    1037:	5f                   	pop    %edi
    1038:	5d                   	pop    %ebp
    1039:	c3                   	ret    
    103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001040 <itoa>:

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	57                   	push   %edi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
    1044:	bf 67 66 66 66       	mov    $0x66666667,%edi
     }
 }

 /* itoa:  convert n to characters in s */
 void itoa(int n, char s[])
 {
    1049:	56                   	push   %esi
    104a:	53                   	push   %ebx
    104b:	31 db                	xor    %ebx,%ebx
    104d:	83 ec 04             	sub    $0x4,%esp
    1050:	8b 45 08             	mov    0x8(%ebp),%eax
    1053:	8b 75 0c             	mov    0xc(%ebp),%esi
    1056:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1059:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    105c:	c1 f8 1f             	sar    $0x1f,%eax
    105f:	31 c1                	xor    %eax,%ecx
    1061:	29 c1                	sub    %eax,%ecx
    1063:	90                   	nop
    1064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 
     if ((sign = n) < 0)  /* record sign */
         n = -n;          /* make n positive */
     i = 0;
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
    1068:	89 c8                	mov    %ecx,%eax
    106a:	f7 ef                	imul   %edi
    106c:	89 c8                	mov    %ecx,%eax
    106e:	c1 f8 1f             	sar    $0x1f,%eax
    1071:	c1 fa 02             	sar    $0x2,%edx
    1074:	29 c2                	sub    %eax,%edx
    1076:	8d 04 92             	lea    (%edx,%edx,4),%eax
    1079:	01 c0                	add    %eax,%eax
    107b:	29 c1                	sub    %eax,%ecx
    107d:	83 c1 30             	add    $0x30,%ecx
    1080:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    1083:	83 c3 01             	add    $0x1,%ebx
     } while ((n /= 10) > 0);     /* delete it */
    1086:	85 d2                	test   %edx,%edx
    1088:	89 d1                	mov    %edx,%ecx
    108a:	7f dc                	jg     1068 <itoa+0x28>
     if (sign < 0)
    108c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    108f:	85 c0                	test   %eax,%eax
    1091:	79 07                	jns    109a <itoa+0x5a>
         s[i++] = '-';
    1093:	c6 04 1e 2d          	movb   $0x2d,(%esi,%ebx,1)
    1097:	83 c3 01             	add    $0x1,%ebx
     s[i] = '\0';
    109a:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
     reverse(s);
    109e:	89 75 08             	mov    %esi,0x8(%ebp)
 }
    10a1:	83 c4 04             	add    $0x4,%esp
    10a4:	5b                   	pop    %ebx
    10a5:	5e                   	pop    %esi
    10a6:	5f                   	pop    %edi
    10a7:	5d                   	pop    %ebp
         s[i++] = n % 10 + '0';   /* get next digit */
     } while ((n /= 10) > 0);     /* delete it */
     if (sign < 0)
         s[i++] = '-';
     s[i] = '\0';
     reverse(s);
    10a8:	e9 43 ff ff ff       	jmp    ff0 <reverse>
    10ad:	8d 76 00             	lea    0x0(%esi),%esi

000010b0 <strcat>:
 }
 
 char *
strcat(char *dest, const char *src)
{
    10b0:	55                   	push   %ebp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
    10b1:	31 d2                	xor    %edx,%edx
     reverse(s);
 }
 
 char *
strcat(char *dest, const char *src)
{
    10b3:	89 e5                	mov    %esp,%ebp
    10b5:	8b 45 08             	mov    0x8(%ebp),%eax
    10b8:	57                   	push   %edi
    10b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
    10bc:	56                   	push   %esi
    10bd:	53                   	push   %ebx
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
    10be:	31 db                	xor    %ebx,%ebx
    10c0:	80 38 00             	cmpb   $0x0,(%eax)
    10c3:	74 0e                	je     10d3 <strcat+0x23>
    10c5:	8d 76 00             	lea    0x0(%esi),%esi
    10c8:	83 c2 01             	add    $0x1,%edx
    10cb:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
    10cf:	75 f7                	jne    10c8 <strcat+0x18>
    10d1:	89 d3                	mov    %edx,%ebx
        ;
    for (j = 0; src[j] != '\0'; j++)
    10d3:	0f b6 0f             	movzbl (%edi),%ecx
    10d6:	84 c9                	test   %cl,%cl
    10d8:	74 18                	je     10f2 <strcat+0x42>
    10da:	8d 34 10             	lea    (%eax,%edx,1),%esi
    10dd:	31 db                	xor    %ebx,%ebx
    10df:	90                   	nop
    10e0:	83 c3 01             	add    $0x1,%ebx
        dest[i+j] = src[j];
    10e3:	88 0e                	mov    %cl,(%esi)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
    10e5:	0f b6 0c 1f          	movzbl (%edi,%ebx,1),%ecx
    10e9:	83 c6 01             	add    $0x1,%esi
    10ec:	84 c9                	test   %cl,%cl
    10ee:	75 f0                	jne    10e0 <strcat+0x30>
    10f0:	01 d3                	add    %edx,%ebx
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    10f2:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
    return dest;
}
    10f6:	5b                   	pop    %ebx
    10f7:	5e                   	pop    %esi
    10f8:	5f                   	pop    %edi
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    
    10fb:	90                   	nop
    10fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001100 <stat>:
  return buf;
}

int
stat(char *n, struct stat *st)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1106:	8b 45 08             	mov    0x8(%ebp),%eax
  return buf;
}

int
stat(char *n, struct stat *st)
{
    1109:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    110c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    110f:	be ff ff ff ff       	mov    $0xffffffff,%esi
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1114:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    111b:	00 
    111c:	89 04 24             	mov    %eax,(%esp)
    111f:	e8 dc 00 00 00       	call   1200 <open>
  if(fd < 0)
    1124:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1126:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    1128:	78 19                	js     1143 <stat+0x43>
    return -1;
  r = fstat(fd, st);
    112a:	8b 45 0c             	mov    0xc(%ebp),%eax
    112d:	89 1c 24             	mov    %ebx,(%esp)
    1130:	89 44 24 04          	mov    %eax,0x4(%esp)
    1134:	e8 df 00 00 00       	call   1218 <fstat>
  close(fd);
    1139:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    113c:	89 c6                	mov    %eax,%esi
  close(fd);
    113e:	e8 a5 00 00 00       	call   11e8 <close>
  return r;
}
    1143:	89 f0                	mov    %esi,%eax
    1145:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    1148:	8b 75 fc             	mov    -0x4(%ebp),%esi
    114b:	89 ec                	mov    %ebp,%esp
    114d:	5d                   	pop    %ebp
    114e:	c3                   	ret    
    114f:	90                   	nop

00001150 <gets>:
  return 0;
}

char*
gets(char *buf, int max)
{
    1150:	55                   	push   %ebp
    1151:	89 e5                	mov    %esp,%ebp
    1153:	57                   	push   %edi
    1154:	56                   	push   %esi
    1155:	31 f6                	xor    %esi,%esi
    1157:	53                   	push   %ebx
    1158:	83 ec 2c             	sub    $0x2c,%esp
    115b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    115e:	eb 06                	jmp    1166 <gets+0x16>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1160:	3c 0a                	cmp    $0xa,%al
    1162:	74 39                	je     119d <gets+0x4d>
    1164:	89 de                	mov    %ebx,%esi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1166:	8d 5e 01             	lea    0x1(%esi),%ebx
    1169:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    116c:	7d 31                	jge    119f <gets+0x4f>
    cc = read(0, &c, 1);
    116e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1171:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1178:	00 
    1179:	89 44 24 04          	mov    %eax,0x4(%esp)
    117d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1184:	e8 4f 00 00 00       	call   11d8 <read>
    if(cc < 1)
    1189:	85 c0                	test   %eax,%eax
    118b:	7e 12                	jle    119f <gets+0x4f>
      break;
    buf[i++] = c;
    118d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1191:	88 44 1f ff          	mov    %al,-0x1(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    1195:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1199:	3c 0d                	cmp    $0xd,%al
    119b:	75 c3                	jne    1160 <gets+0x10>
    119d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    119f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    11a3:	89 f8                	mov    %edi,%eax
    11a5:	83 c4 2c             	add    $0x2c,%esp
    11a8:	5b                   	pop    %ebx
    11a9:	5e                   	pop    %esi
    11aa:	5f                   	pop    %edi
    11ab:	5d                   	pop    %ebp
    11ac:	c3                   	ret    
    11ad:	90                   	nop
    11ae:	90                   	nop
    11af:	90                   	nop

000011b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11b0:	b8 01 00 00 00       	mov    $0x1,%eax
    11b5:	cd 40                	int    $0x40
    11b7:	c3                   	ret    

000011b8 <exit>:
SYSCALL(exit)
    11b8:	b8 02 00 00 00       	mov    $0x2,%eax
    11bd:	cd 40                	int    $0x40
    11bf:	c3                   	ret    

000011c0 <wait>:
SYSCALL(wait)
    11c0:	b8 03 00 00 00       	mov    $0x3,%eax
    11c5:	cd 40                	int    $0x40
    11c7:	c3                   	ret    

000011c8 <wait2>:
SYSCALL(wait2)
    11c8:	b8 16 00 00 00       	mov    $0x16,%eax
    11cd:	cd 40                	int    $0x40
    11cf:	c3                   	ret    

000011d0 <pipe>:
SYSCALL(pipe)
    11d0:	b8 04 00 00 00       	mov    $0x4,%eax
    11d5:	cd 40                	int    $0x40
    11d7:	c3                   	ret    

000011d8 <read>:
SYSCALL(read)
    11d8:	b8 06 00 00 00       	mov    $0x6,%eax
    11dd:	cd 40                	int    $0x40
    11df:	c3                   	ret    

000011e0 <write>:
SYSCALL(write)
    11e0:	b8 05 00 00 00       	mov    $0x5,%eax
    11e5:	cd 40                	int    $0x40
    11e7:	c3                   	ret    

000011e8 <close>:
SYSCALL(close)
    11e8:	b8 07 00 00 00       	mov    $0x7,%eax
    11ed:	cd 40                	int    $0x40
    11ef:	c3                   	ret    

000011f0 <kill>:
SYSCALL(kill)
    11f0:	b8 08 00 00 00       	mov    $0x8,%eax
    11f5:	cd 40                	int    $0x40
    11f7:	c3                   	ret    

000011f8 <exec>:
SYSCALL(exec)
    11f8:	b8 09 00 00 00       	mov    $0x9,%eax
    11fd:	cd 40                	int    $0x40
    11ff:	c3                   	ret    

00001200 <open>:
SYSCALL(open)
    1200:	b8 0a 00 00 00       	mov    $0xa,%eax
    1205:	cd 40                	int    $0x40
    1207:	c3                   	ret    

00001208 <mknod>:
SYSCALL(mknod)
    1208:	b8 0b 00 00 00       	mov    $0xb,%eax
    120d:	cd 40                	int    $0x40
    120f:	c3                   	ret    

00001210 <unlink>:
SYSCALL(unlink)
    1210:	b8 0c 00 00 00       	mov    $0xc,%eax
    1215:	cd 40                	int    $0x40
    1217:	c3                   	ret    

00001218 <fstat>:
SYSCALL(fstat)
    1218:	b8 0d 00 00 00       	mov    $0xd,%eax
    121d:	cd 40                	int    $0x40
    121f:	c3                   	ret    

00001220 <link>:
SYSCALL(link)
    1220:	b8 0e 00 00 00       	mov    $0xe,%eax
    1225:	cd 40                	int    $0x40
    1227:	c3                   	ret    

00001228 <mkdir>:
SYSCALL(mkdir)
    1228:	b8 0f 00 00 00       	mov    $0xf,%eax
    122d:	cd 40                	int    $0x40
    122f:	c3                   	ret    

00001230 <chdir>:
SYSCALL(chdir)
    1230:	b8 10 00 00 00       	mov    $0x10,%eax
    1235:	cd 40                	int    $0x40
    1237:	c3                   	ret    

00001238 <dup>:
SYSCALL(dup)
    1238:	b8 11 00 00 00       	mov    $0x11,%eax
    123d:	cd 40                	int    $0x40
    123f:	c3                   	ret    

00001240 <getpid>:
SYSCALL(getpid)
    1240:	b8 12 00 00 00       	mov    $0x12,%eax
    1245:	cd 40                	int    $0x40
    1247:	c3                   	ret    

00001248 <sbrk>:
SYSCALL(sbrk)
    1248:	b8 13 00 00 00       	mov    $0x13,%eax
    124d:	cd 40                	int    $0x40
    124f:	c3                   	ret    

00001250 <sleep>:
SYSCALL(sleep)
    1250:	b8 14 00 00 00       	mov    $0x14,%eax
    1255:	cd 40                	int    $0x40
    1257:	c3                   	ret    

00001258 <uptime>:
SYSCALL(uptime)
    1258:	b8 15 00 00 00       	mov    $0x15,%eax
    125d:	cd 40                	int    $0x40
    125f:	c3                   	ret    

00001260 <nice>:
SYSCALL(nice)
    1260:	b8 17 00 00 00       	mov    $0x17,%eax
    1265:	cd 40                	int    $0x40
    1267:	c3                   	ret    
    1268:	90                   	nop
    1269:	90                   	nop
    126a:	90                   	nop
    126b:	90                   	nop
    126c:	90                   	nop
    126d:	90                   	nop
    126e:	90                   	nop
    126f:	90                   	nop

00001270 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1270:	55                   	push   %ebp
    1271:	89 e5                	mov    %esp,%ebp
    1273:	57                   	push   %edi
    1274:	89 cf                	mov    %ecx,%edi
    1276:	56                   	push   %esi
    1277:	89 c6                	mov    %eax,%esi
    1279:	53                   	push   %ebx
    127a:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    127d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1280:	85 c9                	test   %ecx,%ecx
    1282:	74 04                	je     1288 <printint+0x18>
    1284:	85 d2                	test   %edx,%edx
    1286:	78 70                	js     12f8 <printint+0x88>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1288:	89 d0                	mov    %edx,%eax
    128a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1291:	31 c9                	xor    %ecx,%ecx
    1293:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    1296:	66 90                	xchg   %ax,%ax
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1298:	31 d2                	xor    %edx,%edx
    129a:	f7 f7                	div    %edi
    129c:	0f b6 92 e7 17 00 00 	movzbl 0x17e7(%edx),%edx
    12a3:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
    12a6:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
    12a9:	85 c0                	test   %eax,%eax
    12ab:	75 eb                	jne    1298 <printint+0x28>
  if(neg)
    12ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    12b0:	85 c0                	test   %eax,%eax
    12b2:	74 08                	je     12bc <printint+0x4c>
    buf[i++] = '-';
    12b4:	c6 44 0d d7 2d       	movb   $0x2d,-0x29(%ebp,%ecx,1)
    12b9:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
    12bc:	8d 79 ff             	lea    -0x1(%ecx),%edi
    12bf:	01 fb                	add    %edi,%ebx
    12c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12c8:	0f b6 03             	movzbl (%ebx),%eax
    12cb:	83 ef 01             	sub    $0x1,%edi
    12ce:	83 eb 01             	sub    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    12d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12d8:	00 
    12d9:	89 34 24             	mov    %esi,(%esp)
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    12dc:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    12df:	8d 45 e7             	lea    -0x19(%ebp),%eax
    12e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    12e6:	e8 f5 fe ff ff       	call   11e0 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    12eb:	83 ff ff             	cmp    $0xffffffff,%edi
    12ee:	75 d8                	jne    12c8 <printint+0x58>
    putc(fd, buf[i]);
}
    12f0:	83 c4 4c             	add    $0x4c,%esp
    12f3:	5b                   	pop    %ebx
    12f4:	5e                   	pop    %esi
    12f5:	5f                   	pop    %edi
    12f6:	5d                   	pop    %ebp
    12f7:	c3                   	ret    
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    12f8:	89 d0                	mov    %edx,%eax
    12fa:	f7 d8                	neg    %eax
    12fc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    1303:	eb 8c                	jmp    1291 <printint+0x21>
    1305:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001310 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	57                   	push   %edi
    1314:	56                   	push   %esi
    1315:	53                   	push   %ebx
    1316:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1319:	8b 45 0c             	mov    0xc(%ebp),%eax
    131c:	0f b6 10             	movzbl (%eax),%edx
    131f:	84 d2                	test   %dl,%dl
    1321:	0f 84 c9 00 00 00    	je     13f0 <printf+0xe0>
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    1327:	8d 4d 10             	lea    0x10(%ebp),%ecx
    132a:	31 ff                	xor    %edi,%edi
    132c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    132f:	31 db                	xor    %ebx,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1331:	8d 75 e7             	lea    -0x19(%ebp),%esi
    1334:	eb 1e                	jmp    1354 <printf+0x44>
    1336:	66 90                	xchg   %ax,%ax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1338:	83 fa 25             	cmp    $0x25,%edx
    133b:	0f 85 b7 00 00 00    	jne    13f8 <printf+0xe8>
    1341:	66 bf 25 00          	mov    $0x25,%di
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1345:	83 c3 01             	add    $0x1,%ebx
    1348:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    134c:	84 d2                	test   %dl,%dl
    134e:	0f 84 9c 00 00 00    	je     13f0 <printf+0xe0>
    c = fmt[i] & 0xff;
    if(state == 0){
    1354:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    1356:	0f b6 d2             	movzbl %dl,%edx
    if(state == 0){
    1359:	74 dd                	je     1338 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    135b:	83 ff 25             	cmp    $0x25,%edi
    135e:	75 e5                	jne    1345 <printf+0x35>
      if(c == 'd'){
    1360:	83 fa 64             	cmp    $0x64,%edx
    1363:	0f 84 57 01 00 00    	je     14c0 <printf+0x1b0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1369:	83 fa 70             	cmp    $0x70,%edx
    136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1370:	0f 84 aa 00 00 00    	je     1420 <printf+0x110>
    1376:	83 fa 78             	cmp    $0x78,%edx
    1379:	0f 84 a1 00 00 00    	je     1420 <printf+0x110>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    137f:	83 fa 73             	cmp    $0x73,%edx
    1382:	0f 84 c0 00 00 00    	je     1448 <printf+0x138>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1388:	83 fa 63             	cmp    $0x63,%edx
    138b:	90                   	nop
    138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1390:	0f 84 52 01 00 00    	je     14e8 <printf+0x1d8>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1396:	83 fa 25             	cmp    $0x25,%edx
    1399:	0f 84 f9 00 00 00    	je     1498 <printf+0x188>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    139f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13a2:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13a5:	31 ff                	xor    %edi,%edi
    13a7:	89 55 cc             	mov    %edx,-0x34(%ebp)
    13aa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    13ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13b5:	00 
    13b6:	89 0c 24             	mov    %ecx,(%esp)
    13b9:	89 74 24 04          	mov    %esi,0x4(%esp)
    13bd:	e8 1e fe ff ff       	call   11e0 <write>
    13c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
    13c5:	8b 45 08             	mov    0x8(%ebp),%eax
    13c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13cf:	00 
    13d0:	89 74 24 04          	mov    %esi,0x4(%esp)
    13d4:	88 55 e7             	mov    %dl,-0x19(%ebp)
    13d7:	89 04 24             	mov    %eax,(%esp)
    13da:	e8 01 fe ff ff       	call   11e0 <write>
    13df:	8b 45 0c             	mov    0xc(%ebp),%eax
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13e2:	0f b6 14 18          	movzbl (%eax,%ebx,1),%edx
    13e6:	84 d2                	test   %dl,%dl
    13e8:	0f 85 66 ff ff ff    	jne    1354 <printf+0x44>
    13ee:	66 90                	xchg   %ax,%ax
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    13f0:	83 c4 3c             	add    $0x3c,%esp
    13f3:	5b                   	pop    %ebx
    13f4:	5e                   	pop    %esi
    13f5:	5f                   	pop    %edi
    13f6:	5d                   	pop    %ebp
    13f7:	c3                   	ret    
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13f8:	8b 45 08             	mov    0x8(%ebp),%eax
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    13fb:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1405:	00 
    1406:	89 74 24 04          	mov    %esi,0x4(%esp)
    140a:	89 04 24             	mov    %eax,(%esp)
    140d:	e8 ce fd ff ff       	call   11e0 <write>
    1412:	8b 45 0c             	mov    0xc(%ebp),%eax
    1415:	e9 2b ff ff ff       	jmp    1345 <printf+0x35>
    141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    1420:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1423:	b9 10 00 00 00       	mov    $0x10,%ecx
        ap++;
    1428:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    142a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1431:	8b 10                	mov    (%eax),%edx
    1433:	8b 45 08             	mov    0x8(%ebp),%eax
    1436:	e8 35 fe ff ff       	call   1270 <printint>
    143b:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    143e:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1442:	e9 fe fe ff ff       	jmp    1345 <printf+0x35>
    1447:	90                   	nop
      } else if(c == 's'){
        s = (char*)*ap;
    1448:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    144b:	8b 3a                	mov    (%edx),%edi
        ap++;
    144d:	83 c2 04             	add    $0x4,%edx
    1450:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        if(s == 0)
    1453:	85 ff                	test   %edi,%edi
    1455:	0f 84 ba 00 00 00    	je     1515 <printf+0x205>
          s = "(null)";
        while(*s != 0){
    145b:	0f b6 17             	movzbl (%edi),%edx
    145e:	84 d2                	test   %dl,%dl
    1460:	74 2d                	je     148f <printf+0x17f>
    1462:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    1465:	8b 5d 08             	mov    0x8(%ebp),%ebx
          putc(fd, *s);
          s++;
    1468:	83 c7 01             	add    $0x1,%edi
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    146b:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    146e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1475:	00 
    1476:	89 74 24 04          	mov    %esi,0x4(%esp)
    147a:	89 1c 24             	mov    %ebx,(%esp)
    147d:	e8 5e fd ff ff       	call   11e0 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1482:	0f b6 17             	movzbl (%edi),%edx
    1485:	84 d2                	test   %dl,%dl
    1487:	75 df                	jne    1468 <printf+0x158>
    1489:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    148c:	8b 45 0c             	mov    0xc(%ebp),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    148f:	31 ff                	xor    %edi,%edi
    1491:	e9 af fe ff ff       	jmp    1345 <printf+0x35>
    1496:	66 90                	xchg   %ax,%ax
    1498:	8b 55 08             	mov    0x8(%ebp),%edx
    149b:	31 ff                	xor    %edi,%edi
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    149d:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    14a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14a8:	00 
    14a9:	89 74 24 04          	mov    %esi,0x4(%esp)
    14ad:	89 14 24             	mov    %edx,(%esp)
    14b0:	e8 2b fd ff ff       	call   11e0 <write>
    14b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b8:	e9 88 fe ff ff       	jmp    1345 <printf+0x35>
    14bd:	8d 76 00             	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    14c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    14c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
        ap++;
    14c8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    14cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14d2:	8b 10                	mov    (%eax),%edx
    14d4:	8b 45 08             	mov    0x8(%ebp),%eax
    14d7:	e8 94 fd ff ff       	call   1270 <printint>
    14dc:	8b 45 0c             	mov    0xc(%ebp),%eax
        ap++;
    14df:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    14e3:	e9 5d fe ff ff       	jmp    1345 <printf+0x35>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
        putc(fd, *ap);
        ap++;
    14eb:	31 ff                	xor    %edi,%edi
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14ed:	8b 01                	mov    (%ecx),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    14ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14f6:	00 
    14f7:	89 74 24 04          	mov    %esi,0x4(%esp)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14fb:	88 45 e7             	mov    %al,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    14fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1501:	89 04 24             	mov    %eax,(%esp)
    1504:	e8 d7 fc ff ff       	call   11e0 <write>
    1509:	8b 45 0c             	mov    0xc(%ebp),%eax
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    150c:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    1510:	e9 30 fe ff ff       	jmp    1345 <printf+0x35>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
    1515:	bf e0 17 00 00       	mov    $0x17e0,%edi
    151a:	e9 3c ff ff ff       	jmp    145b <printf+0x14b>
    151f:	90                   	nop

00001520 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1520:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1521:	a1 8c 18 00 00       	mov    0x188c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    1526:	89 e5                	mov    %esp,%ebp
    1528:	57                   	push   %edi
    1529:	56                   	push   %esi
    152a:	53                   	push   %ebx
    152b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*) ap - 1;
    152e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1531:	39 c8                	cmp    %ecx,%eax
    1533:	73 1d                	jae    1552 <free+0x32>
    1535:	8d 76 00             	lea    0x0(%esi),%esi
    1538:	8b 10                	mov    (%eax),%edx
    153a:	39 d1                	cmp    %edx,%ecx
    153c:	72 1a                	jb     1558 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    153e:	39 d0                	cmp    %edx,%eax
    1540:	72 08                	jb     154a <free+0x2a>
    1542:	39 c8                	cmp    %ecx,%eax
    1544:	72 12                	jb     1558 <free+0x38>
    1546:	39 d1                	cmp    %edx,%ecx
    1548:	72 0e                	jb     1558 <free+0x38>
    154a:	89 d0                	mov    %edx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    154c:	39 c8                	cmp    %ecx,%eax
    154e:	66 90                	xchg   %ax,%ax
    1550:	72 e6                	jb     1538 <free+0x18>
    1552:	8b 10                	mov    (%eax),%edx
    1554:	eb e8                	jmp    153e <free+0x1e>
    1556:	66 90                	xchg   %ax,%ax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1558:	8b 71 04             	mov    0x4(%ecx),%esi
    155b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    155e:	39 d7                	cmp    %edx,%edi
    1560:	74 19                	je     157b <free+0x5b>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1562:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1565:	8b 50 04             	mov    0x4(%eax),%edx
    1568:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    156b:	39 ce                	cmp    %ecx,%esi
    156d:	74 23                	je     1592 <free+0x72>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    156f:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1571:	a3 8c 18 00 00       	mov    %eax,0x188c
}
    1576:	5b                   	pop    %ebx
    1577:	5e                   	pop    %esi
    1578:	5f                   	pop    %edi
    1579:	5d                   	pop    %ebp
    157a:	c3                   	ret    
  bp = (Header*) ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    157b:	03 72 04             	add    0x4(%edx),%esi
    157e:	89 71 04             	mov    %esi,0x4(%ecx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1581:	8b 10                	mov    (%eax),%edx
    1583:	8b 12                	mov    (%edx),%edx
    1585:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1588:	8b 50 04             	mov    0x4(%eax),%edx
    158b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    158e:	39 ce                	cmp    %ecx,%esi
    1590:	75 dd                	jne    156f <free+0x4f>
    p->s.size += bp->s.size;
    1592:	03 51 04             	add    0x4(%ecx),%edx
    1595:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1598:	8b 53 f8             	mov    -0x8(%ebx),%edx
    159b:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
    159d:	a3 8c 18 00 00       	mov    %eax,0x188c
}
    15a2:	5b                   	pop    %ebx
    15a3:	5e                   	pop    %esi
    15a4:	5f                   	pop    %edi
    15a5:	5d                   	pop    %ebp
    15a6:	c3                   	ret    
    15a7:	89 f6                	mov    %esi,%esi
    15a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000015b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    15b0:	55                   	push   %ebp
    15b1:	89 e5                	mov    %esp,%ebp
    15b3:	57                   	push   %edi
    15b4:	56                   	push   %esi
    15b5:	53                   	push   %ebx
    15b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((prevp = freep) == 0){
    15bc:	8b 0d 8c 18 00 00    	mov    0x188c,%ecx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15c2:	83 c3 07             	add    $0x7,%ebx
    15c5:	c1 eb 03             	shr    $0x3,%ebx
    15c8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15cb:	85 c9                	test   %ecx,%ecx
    15cd:	0f 84 93 00 00 00    	je     1666 <malloc+0xb6>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15d3:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    15d5:	8b 50 04             	mov    0x4(%eax),%edx
    15d8:	39 d3                	cmp    %edx,%ebx
    15da:	76 1f                	jbe    15fb <malloc+0x4b>
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*) (p + 1);
    15dc:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    15e3:	90                   	nop
    15e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if(p == freep)
    15e8:	3b 05 8c 18 00 00    	cmp    0x188c,%eax
    15ee:	74 30                	je     1620 <malloc+0x70>
    15f0:	89 c1                	mov    %eax,%ecx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15f2:	8b 01                	mov    (%ecx),%eax
    if(p->s.size >= nunits){
    15f4:	8b 50 04             	mov    0x4(%eax),%edx
    15f7:	39 d3                	cmp    %edx,%ebx
    15f9:	77 ed                	ja     15e8 <malloc+0x38>
      if(p->s.size == nunits)
    15fb:	39 d3                	cmp    %edx,%ebx
    15fd:	74 61                	je     1660 <malloc+0xb0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    15ff:	29 da                	sub    %ebx,%edx
    1601:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1604:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    1607:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    160a:	89 0d 8c 18 00 00    	mov    %ecx,0x188c
      return (void*) (p + 1);
    1610:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1613:	83 c4 1c             	add    $0x1c,%esp
    1616:	5b                   	pop    %ebx
    1617:	5e                   	pop    %esi
    1618:	5f                   	pop    %edi
    1619:	5d                   	pop    %ebp
    161a:	c3                   	ret    
    161b:	90                   	nop
    161c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1620:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
    1626:	b8 00 80 00 00       	mov    $0x8000,%eax
    162b:	bf 00 10 00 00       	mov    $0x1000,%edi
    1630:	76 04                	jbe    1636 <malloc+0x86>
    1632:	89 f0                	mov    %esi,%eax
    1634:	89 df                	mov    %ebx,%edi
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    1636:	89 04 24             	mov    %eax,(%esp)
    1639:	e8 0a fc ff ff       	call   1248 <sbrk>
  if(p == (char*) -1)
    163e:	83 f8 ff             	cmp    $0xffffffff,%eax
    1641:	74 18                	je     165b <malloc+0xab>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1643:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    1646:	83 c0 08             	add    $0x8,%eax
    1649:	89 04 24             	mov    %eax,(%esp)
    164c:	e8 cf fe ff ff       	call   1520 <free>
  return freep;
    1651:	8b 0d 8c 18 00 00    	mov    0x188c,%ecx
      }
      freep = prevp;
      return (void*) (p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    1657:	85 c9                	test   %ecx,%ecx
    1659:	75 97                	jne    15f2 <malloc+0x42>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    165b:	31 c0                	xor    %eax,%eax
    165d:	eb b4                	jmp    1613 <malloc+0x63>
    165f:	90                   	nop
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1660:	8b 10                	mov    (%eax),%edx
    1662:	89 11                	mov    %edx,(%ecx)
    1664:	eb a4                	jmp    160a <malloc+0x5a>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1666:	c7 05 8c 18 00 00 84 	movl   $0x1884,0x188c
    166d:	18 00 00 
    base.s.size = 0;
    1670:	b9 84 18 00 00       	mov    $0x1884,%ecx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    1675:	c7 05 84 18 00 00 84 	movl   $0x1884,0x1884
    167c:	18 00 00 
    base.s.size = 0;
    167f:	c7 05 88 18 00 00 00 	movl   $0x0,0x1888
    1686:	00 00 00 
    1689:	e9 45 ff ff ff       	jmp    15d3 <malloc+0x23>
