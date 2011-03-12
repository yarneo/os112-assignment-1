
kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <brelse>:
}

// Release the buffer b.
void
brelse(struct buf *b)
{
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	53                   	push   %ebx
  100004:	83 ec 14             	sub    $0x14,%esp
  100007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
  10000a:	f6 03 01             	testb  $0x1,(%ebx)
  10000d:	74 57                	je     100066 <brelse+0x66>
    panic("brelse");

  acquire(&bcache.lock);
  10000f:	c7 04 24 c0 91 10 00 	movl   $0x1091c0,(%esp)
  100016:	e8 d5 3f 00 00       	call   103ff0 <acquire>

  b->next->prev = b->prev;
  10001b:	8b 43 10             	mov    0x10(%ebx),%eax
  10001e:	8b 53 0c             	mov    0xc(%ebx),%edx
  100021:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
  100024:	8b 43 0c             	mov    0xc(%ebx),%eax
  100027:	8b 53 10             	mov    0x10(%ebx),%edx
  10002a:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
  10002d:	a1 f4 a6 10 00       	mov    0x10a6f4,%eax
  b->prev = &bcache.head;
  100032:	c7 43 0c e4 a6 10 00 	movl   $0x10a6e4,0xc(%ebx)

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
  10003c:	a1 f4 a6 10 00       	mov    0x10a6f4,%eax
  100041:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
  100044:	89 1d f4 a6 10 00    	mov    %ebx,0x10a6f4

  b->flags &= ~B_BUSY;
  10004a:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
  10004d:	89 1c 24             	mov    %ebx,(%esp)
  100050:	e8 4b 32 00 00       	call   1032a0 <wakeup>

  release(&bcache.lock);
  100055:	c7 45 08 c0 91 10 00 	movl   $0x1091c0,0x8(%ebp)
}
  10005c:	83 c4 14             	add    $0x14,%esp
  10005f:	5b                   	pop    %ebx
  100060:	5d                   	pop    %ebp
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
  100061:	e9 3a 3f 00 00       	jmp    103fa0 <release>
// Release the buffer b.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100066:	c7 04 24 e0 69 10 00 	movl   $0x1069e0,(%esp)
  10006d:	e8 1e 0a 00 00       	call   100a90 <panic>
  100072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100080 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  100080:	55                   	push   %ebp
  100081:	89 e5                	mov    %esp,%ebp
  100083:	83 ec 18             	sub    $0x18,%esp
  100086:	8b 45 08             	mov    0x8(%ebp),%eax
  if((b->flags & B_BUSY) == 0)
  100089:	8b 10                	mov    (%eax),%edx
  10008b:	f6 c2 01             	test   $0x1,%dl
  10008e:	74 0e                	je     10009e <bwrite+0x1e>
    panic("bwrite");
  b->flags |= B_DIRTY;
  100090:	83 ca 04             	or     $0x4,%edx
  100093:	89 10                	mov    %edx,(%eax)
  iderw(b);
  100095:	89 45 08             	mov    %eax,0x8(%ebp)
}
  100098:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
  100099:	e9 62 20 00 00       	jmp    102100 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  10009e:	c7 04 24 e7 69 10 00 	movl   $0x1069e7,(%esp)
  1000a5:	e8 e6 09 00 00       	call   100a90 <panic>
  1000aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001000b0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
  1000b0:	55                   	push   %ebp
  1000b1:	89 e5                	mov    %esp,%ebp
  1000b3:	57                   	push   %edi
  1000b4:	56                   	push   %esi
  1000b5:	53                   	push   %ebx
  1000b6:	83 ec 1c             	sub    $0x1c,%esp
  1000b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1000bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint sector)
{
  struct buf *b;

  acquire(&bcache.lock);
  1000bf:	c7 04 24 c0 91 10 00 	movl   $0x1091c0,(%esp)
  1000c6:	e8 25 3f 00 00       	call   103ff0 <acquire>

 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  1000cb:	8b 1d f4 a6 10 00    	mov    0x10a6f4,%ebx
  1000d1:	81 fb e4 a6 10 00    	cmp    $0x10a6e4,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 35                	jmp    100110 <bread+0x60>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb e4 a6 10 00    	cmp    $0x10a6e4,%ebx
  1000e9:	74 25                	je     100110 <bread+0x60>
    if(b->dev == dev && b->sector == sector){
  1000eb:	3b 73 04             	cmp    0x4(%ebx),%esi
  1000ee:	66 90                	xchg   %ax,%ax
  1000f0:	75 ee                	jne    1000e0 <bread+0x30>
  1000f2:	3b 7b 08             	cmp    0x8(%ebx),%edi
  1000f5:	75 e9                	jne    1000e0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
  1000f7:	8b 03                	mov    (%ebx),%eax
  1000f9:	a8 01                	test   $0x1,%al
  1000fb:	74 64                	je     100161 <bread+0xb1>
        b->flags |= B_BUSY;
        release(&bcache.lock);
        return b;
      }
      sleep(b, &bcache.lock);
  1000fd:	c7 44 24 04 c0 91 10 	movl   $0x1091c0,0x4(%esp)
  100104:	00 
  100105:	89 1c 24             	mov    %ebx,(%esp)
  100108:	e8 f3 32 00 00       	call   103400 <sleep>
  10010d:	eb bc                	jmp    1000cb <bread+0x1b>
  10010f:	90                   	nop
      goto loop;
    }
  }

  // Allocate fresh block.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
  100110:	8b 1d f0 a6 10 00    	mov    0x10a6f0,%ebx
  100116:	81 fb e4 a6 10 00    	cmp    $0x10a6e4,%ebx
  10011c:	75 0d                	jne    10012b <bread+0x7b>
  10011e:	eb 54                	jmp    100174 <bread+0xc4>
  100120:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  100123:	81 fb e4 a6 10 00    	cmp    $0x10a6e4,%ebx
  100129:	74 49                	je     100174 <bread+0xc4>
    if((b->flags & B_BUSY) == 0){
  10012b:	f6 03 01             	testb  $0x1,(%ebx)
  10012e:	66 90                	xchg   %ax,%ax
  100130:	75 ee                	jne    100120 <bread+0x70>
      b->dev = dev;
  100132:	89 73 04             	mov    %esi,0x4(%ebx)
      b->sector = sector;
  100135:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
  100138:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
  10013e:	c7 04 24 c0 91 10 00 	movl   $0x1091c0,(%esp)
  100145:	e8 56 3e 00 00       	call   103fa0 <release>
bread(uint dev, uint sector)
{
  struct buf *b;

  b = bget(dev, sector);
  if(!(b->flags & B_VALID))
  10014a:	f6 03 02             	testb  $0x2,(%ebx)
  10014d:	75 08                	jne    100157 <bread+0xa7>
    iderw(b);
  10014f:	89 1c 24             	mov    %ebx,(%esp)
  100152:	e8 a9 1f 00 00       	call   102100 <iderw>
  return b;
}
  100157:	83 c4 1c             	add    $0x1c,%esp
  10015a:	89 d8                	mov    %ebx,%eax
  10015c:	5b                   	pop    %ebx
  10015d:	5e                   	pop    %esi
  10015e:	5f                   	pop    %edi
  10015f:	5d                   	pop    %ebp
  100160:	c3                   	ret    
 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->sector == sector){
      if(!(b->flags & B_BUSY)){
        b->flags |= B_BUSY;
  100161:	83 c8 01             	or     $0x1,%eax
  100164:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
  100166:	c7 04 24 c0 91 10 00 	movl   $0x1091c0,(%esp)
  10016d:	e8 2e 3e 00 00       	call   103fa0 <release>
  100172:	eb d6                	jmp    10014a <bread+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
  100174:	c7 04 24 ee 69 10 00 	movl   $0x1069ee,(%esp)
  10017b:	e8 10 09 00 00       	call   100a90 <panic>

00100180 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
  100180:	55                   	push   %ebp
  100181:	89 e5                	mov    %esp,%ebp
  100183:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  100186:	c7 44 24 04 ff 69 10 	movl   $0x1069ff,0x4(%esp)
  10018d:	00 
  10018e:	c7 04 24 c0 91 10 00 	movl   $0x1091c0,(%esp)
  100195:	e8 c6 3c 00 00       	call   103e60 <initlock>
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
  10019a:	ba e4 a6 10 00       	mov    $0x10a6e4,%edx
  10019f:	b8 f4 91 10 00       	mov    $0x1091f4,%eax
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  1001a4:	c7 05 f0 a6 10 00 e4 	movl   $0x10a6e4,0x10a6f0
  1001ab:	a6 10 00 
  bcache.head.next = &bcache.head;
  1001ae:	c7 05 f4 a6 10 00 e4 	movl   $0x10a6e4,0x10a6f4
  1001b5:	a6 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
  1001b8:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
  1001bb:	c7 40 0c e4 a6 10 00 	movl   $0x10a6e4,0xc(%eax)
    b->dev = -1;
  1001c2:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
  1001c9:	8b 15 f4 a6 10 00    	mov    0x10a6f4,%edx
  1001cf:	89 42 0c             	mov    %eax,0xc(%edx)
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  1001d2:	89 c2                	mov    %eax,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  1001d4:	a3 f4 a6 10 00       	mov    %eax,0x10a6f4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  1001d9:	05 18 02 00 00       	add    $0x218,%eax
  1001de:	3d e4 a6 10 00       	cmp    $0x10a6e4,%eax
  1001e3:	75 d3                	jne    1001b8 <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
  1001e5:	c9                   	leave  
  1001e6:	c3                   	ret    
  1001e7:	90                   	nop
  1001e8:	90                   	nop
  1001e9:	90                   	nop
  1001ea:	90                   	nop
  1001eb:	90                   	nop
  1001ec:	90                   	nop
  1001ed:	90                   	nop
  1001ee:	90                   	nop
  1001ef:	90                   	nop

001001f0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
  1001f3:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
  1001f6:	c7 44 24 04 06 6a 10 	movl   $0x106a06,0x4(%esp)
  1001fd:	00 
  1001fe:	c7 04 24 20 91 10 00 	movl   $0x109120,(%esp)
  100205:	e8 56 3c 00 00       	call   103e60 <initlock>
  initlock(&input.lock, "input");
  10020a:	c7 44 24 04 0e 6a 10 	movl   $0x106a0e,0x4(%esp)
  100211:	00 
  100212:	c7 04 24 00 a9 10 00 	movl   $0x10a900,(%esp)
  100219:	e8 42 3c 00 00       	call   103e60 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
  10021e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
{
  initlock(&cons.lock, "console");
  initlock(&input.lock, "input");


  devsw[CONSOLE].write = consolewrite;
  100225:	c7 05 6c b3 10 00 d0 	movl   $0x1003d0,0x10b36c
  10022c:	03 10 00 
  devsw[CONSOLE].read = consoleread;
  10022f:	c7 05 68 b3 10 00 20 	movl   $0x100620,0x10b368
  100236:	06 10 00 
  cons.locking = 1;
  100239:	c7 05 54 91 10 00 01 	movl   $0x1,0x109154
  100240:	00 00 00 

  picenable(IRQ_KBD);
  100243:	e8 18 2b 00 00       	call   102d60 <picenable>
  ioapicenable(IRQ_KBD, 0);
  100248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10024f:	00 
  100250:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  100257:	e8 c4 20 00 00       	call   102320 <ioapicenable>
}
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    
  10025e:	66 90                	xchg   %ax,%ax

00100260 <consputc>:
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
  100260:	55                   	push   %ebp
  100261:	89 e5                	mov    %esp,%ebp
  100263:	57                   	push   %edi
  100264:	56                   	push   %esi
  100265:	89 c6                	mov    %eax,%esi
  100267:	53                   	push   %ebx
  100268:	83 ec 1c             	sub    $0x1c,%esp
  if(panicked){
  10026b:	83 3d a0 8a 10 00 00 	cmpl   $0x0,0x108aa0
  100272:	74 03                	je     100277 <consputc+0x17>
}

static inline void
cli(void)
{
  asm volatile("cli");
  100274:	fa                   	cli    
  100275:	eb fe                	jmp    100275 <consputc+0x15>
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
  100277:	3d 00 01 00 00       	cmp    $0x100,%eax
  10027c:	0f 84 a0 00 00 00    	je     100322 <consputc+0xc2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 a6 53 00 00       	call   105630 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10028a:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
  10028f:	b8 0e 00 00 00       	mov    $0xe,%eax
  100294:	89 ca                	mov    %ecx,%edx
  100296:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  100297:	bf d5 03 00 00       	mov    $0x3d5,%edi
  10029c:	89 fa                	mov    %edi,%edx
  10029e:	ec                   	in     (%dx),%al
{
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  10029f:	0f b6 d8             	movzbl %al,%ebx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1002a2:	89 ca                	mov    %ecx,%edx
  1002a4:	c1 e3 08             	shl    $0x8,%ebx
  1002a7:	b8 0f 00 00 00       	mov    $0xf,%eax
  1002ac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1002ad:	89 fa                	mov    %edi,%edx
  1002af:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
  1002b0:	0f b6 c0             	movzbl %al,%eax
  1002b3:	09 c3                	or     %eax,%ebx

  if(c == '\n')
  1002b5:	83 fe 0a             	cmp    $0xa,%esi
  1002b8:	0f 84 ee 00 00 00    	je     1003ac <consputc+0x14c>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
  1002be:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  1002c4:	0f 84 cb 00 00 00    	je     100395 <consputc+0x135>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  1002ca:	66 81 e6 ff 00       	and    $0xff,%si
  1002cf:	66 81 ce 00 07       	or     $0x700,%si
  1002d4:	66 89 b4 1b 00 80 0b 	mov    %si,0xb8000(%ebx,%ebx,1)
  1002db:	00 
  1002dc:	83 c3 01             	add    $0x1,%ebx
  
  if((pos/80) >= 24){  // Scroll up.
  1002df:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
  1002e5:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  1002ec:	7f 5d                	jg     10034b <consputc+0xeb>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1002ee:	be d4 03 00 00       	mov    $0x3d4,%esi
  1002f3:	b8 0e 00 00 00       	mov    $0xe,%eax
  1002f8:	89 f2                	mov    %esi,%edx
  1002fa:	ee                   	out    %al,(%dx)
  1002fb:	bf d5 03 00 00       	mov    $0x3d5,%edi
  100300:	89 d8                	mov    %ebx,%eax
  100302:	c1 f8 08             	sar    $0x8,%eax
  100305:	89 fa                	mov    %edi,%edx
  100307:	ee                   	out    %al,(%dx)
  100308:	b8 0f 00 00 00       	mov    $0xf,%eax
  10030d:	89 f2                	mov    %esi,%edx
  10030f:	ee                   	out    %al,(%dx)
  100310:	89 d8                	mov    %ebx,%eax
  100312:	89 fa                	mov    %edi,%edx
  100314:	ee                   	out    %al,(%dx)
  
  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
  100315:	66 c7 01 20 07       	movw   $0x720,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
  10031a:	83 c4 1c             	add    $0x1c,%esp
  10031d:	5b                   	pop    %ebx
  10031e:	5e                   	pop    %esi
  10031f:	5f                   	pop    %edi
  100320:	5d                   	pop    %ebp
  100321:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  100322:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100329:	e8 02 53 00 00       	call   105630 <uartputc>
  10032e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100335:	e8 f6 52 00 00       	call   105630 <uartputc>
  10033a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100341:	e8 ea 52 00 00       	call   105630 <uartputc>
  100346:	e9 3f ff ff ff       	jmp    10028a <consputc+0x2a>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
  10034b:	83 eb 50             	sub    $0x50,%ebx
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  10034e:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
  100355:	00 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100356:	8d b4 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%esi
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
  
  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
  10035d:	c7 44 24 04 a0 80 0b 	movl   $0xb80a0,0x4(%esp)
  100364:	00 
  100365:	c7 04 24 00 80 0b 00 	movl   $0xb8000,(%esp)
  10036c:	e8 9f 3d 00 00       	call   104110 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100371:	b8 80 07 00 00       	mov    $0x780,%eax
  100376:	29 d8                	sub    %ebx,%eax
  100378:	01 c0                	add    %eax,%eax
  10037a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10037e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100385:	00 
  100386:	89 34 24             	mov    %esi,(%esp)
  100389:	e8 02 3d 00 00       	call   104090 <memset>
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
  10038e:	89 f1                	mov    %esi,%ecx
  100390:	e9 59 ff ff ff       	jmp    1002ee <consputc+0x8e>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  100395:	85 db                	test   %ebx,%ebx
  100397:	8d 8c 1b 00 80 0b 00 	lea    0xb8000(%ebx,%ebx,1),%ecx
  10039e:	0f 8e 4a ff ff ff    	jle    1002ee <consputc+0x8e>
  1003a4:	83 eb 01             	sub    $0x1,%ebx
  1003a7:	e9 33 ff ff ff       	jmp    1002df <consputc+0x7f>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  1003ac:	89 da                	mov    %ebx,%edx
  1003ae:	89 d8                	mov    %ebx,%eax
  1003b0:	b9 50 00 00 00       	mov    $0x50,%ecx
  1003b5:	83 c3 50             	add    $0x50,%ebx
  1003b8:	c1 fa 1f             	sar    $0x1f,%edx
  1003bb:	f7 f9                	idiv   %ecx
  1003bd:	29 d3                	sub    %edx,%ebx
  1003bf:	e9 1b ff ff ff       	jmp    1002df <consputc+0x7f>
  1003c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1003ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001003d0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  1003d0:	55                   	push   %ebp
  1003d1:	89 e5                	mov    %esp,%ebp
  1003d3:	57                   	push   %edi
  1003d4:	56                   	push   %esi
  1003d5:	53                   	push   %ebx
  1003d6:	83 ec 1c             	sub    $0x1c,%esp
  int i;
  iunlock(ip);
  1003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  1003dc:	8b 75 10             	mov    0x10(%ebp),%esi
  1003df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;
  iunlock(ip);
  1003e2:	89 04 24             	mov    %eax,(%esp)
  1003e5:	e8 46 15 00 00       	call   101930 <iunlock>
  acquire(&cons.lock);
  1003ea:	c7 04 24 20 91 10 00 	movl   $0x109120,(%esp)
  1003f1:	e8 fa 3b 00 00       	call   103ff0 <acquire>
  for(i = 0; i < n; i++) {
  1003f6:	85 f6                	test   %esi,%esi
  1003f8:	7e 16                	jle    100410 <consolewrite+0x40>
  1003fa:	31 db                	xor    %ebx,%ebx
  1003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i] & 0xff);
  100400:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;
  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++) {
  100404:	83 c3 01             	add    $0x1,%ebx
    consputc(buf[i] & 0xff);
  100407:	e8 54 fe ff ff       	call   100260 <consputc>
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;
  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++) {
  10040c:	39 de                	cmp    %ebx,%esi
  10040e:	7f f0                	jg     100400 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  }
  release(&cons.lock);
  100410:	c7 04 24 20 91 10 00 	movl   $0x109120,(%esp)
  100417:	e8 84 3b 00 00       	call   103fa0 <release>
  ilock(ip);
  10041c:	8b 45 08             	mov    0x8(%ebp),%eax
  10041f:	89 04 24             	mov    %eax,(%esp)
  100422:	e8 49 19 00 00       	call   101d70 <ilock>

  return n;
}
  100427:	83 c4 1c             	add    $0x1c,%esp
  10042a:	89 f0                	mov    %esi,%eax
  10042c:	5b                   	pop    %ebx
  10042d:	5e                   	pop    %esi
  10042e:	5f                   	pop    %edi
  10042f:	5d                   	pop    %ebp
  100430:	c3                   	ret    
  100431:	eb 0d                	jmp    100440 <printint>
  100433:	90                   	nop
  100434:	90                   	nop
  100435:	90                   	nop
  100436:	90                   	nop
  100437:	90                   	nop
  100438:	90                   	nop
  100439:	90                   	nop
  10043a:	90                   	nop
  10043b:	90                   	nop
  10043c:	90                   	nop
  10043d:	90                   	nop
  10043e:	90                   	nop
  10043f:	90                   	nop

00100440 <printint>:
} cons;


static void
printint(int xx, int base, int sgn)
{
  100440:	55                   	push   %ebp
  100441:	89 e5                	mov    %esp,%ebp
  100443:	57                   	push   %edi
  100444:	56                   	push   %esi
  100445:	89 d6                	mov    %edx,%esi
  100447:	53                   	push   %ebx
  100448:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
  10044b:	85 c9                	test   %ecx,%ecx
  10044d:	74 04                	je     100453 <printint+0x13>
  10044f:	85 c0                	test   %eax,%eax
  100451:	78 55                	js     1004a8 <printint+0x68>
    neg = 1;
    x = -xx;
  } else
    x = xx;
  100453:	31 ff                	xor    %edi,%edi
  100455:	31 c9                	xor    %ecx,%ecx
  100457:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  10045a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  do{
    buf[i++] = digits[x % base];
  100460:	31 d2                	xor    %edx,%edx
  100462:	f7 f6                	div    %esi
  100464:	0f b6 92 2e 6a 10 00 	movzbl 0x106a2e(%edx),%edx
  10046b:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  10046e:	83 c1 01             	add    $0x1,%ecx
  }while((x /= base) != 0);
  100471:	85 c0                	test   %eax,%eax
  100473:	75 eb                	jne    100460 <printint+0x20>
  if(neg)
  100475:	85 ff                	test   %edi,%edi
  100477:	74 08                	je     100481 <printint+0x41>
    buf[i++] = '-';
  100479:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
  10047e:	83 c1 01             	add    $0x1,%ecx

  while(--i >= 0)
  100481:	8d 71 ff             	lea    -0x1(%ecx),%esi
  100484:	01 f3                	add    %esi,%ebx
  100486:	66 90                	xchg   %ax,%ax
    consputc(buf[i]);
  100488:	0f be 03             	movsbl (%ebx),%eax
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  10048b:	83 ee 01             	sub    $0x1,%esi
  10048e:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
  100491:	e8 ca fd ff ff       	call   100260 <consputc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
  100496:	83 fe ff             	cmp    $0xffffffff,%esi
  100499:	75 ed                	jne    100488 <printint+0x48>
    consputc(buf[i]);
}
  10049b:	83 c4 1c             	add    $0x1c,%esp
  10049e:	5b                   	pop    %ebx
  10049f:	5e                   	pop    %esi
  1004a0:	5f                   	pop    %edi
  1004a1:	5d                   	pop    %ebp
  1004a2:	c3                   	ret    
  1004a3:	90                   	nop
  1004a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i = 0, neg = 0;
  uint x;

  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  1004a8:	f7 d8                	neg    %eax
  1004aa:	bf 01 00 00 00       	mov    $0x1,%edi
  1004af:	eb a4                	jmp    100455 <printint+0x15>
  1004b1:	eb 0d                	jmp    1004c0 <cprintf>
  1004b3:	90                   	nop
  1004b4:	90                   	nop
  1004b5:	90                   	nop
  1004b6:	90                   	nop
  1004b7:	90                   	nop
  1004b8:	90                   	nop
  1004b9:	90                   	nop
  1004ba:	90                   	nop
  1004bb:	90                   	nop
  1004bc:	90                   	nop
  1004bd:	90                   	nop
  1004be:	90                   	nop
  1004bf:	90                   	nop

001004c0 <cprintf>:
}

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  1004c0:	55                   	push   %ebp
  1004c1:	89 e5                	mov    %esp,%ebp
  1004c3:	57                   	push   %edi
  1004c4:	56                   	push   %esi
  1004c5:	53                   	push   %ebx
  1004c6:	83 ec 2c             	sub    $0x2c,%esp
  int i, c, state, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  1004c9:	8b 3d 54 91 10 00    	mov    0x109154,%edi
  if(locking)
  1004cf:	85 ff                	test   %edi,%edi
  1004d1:	0f 85 29 01 00 00    	jne    100600 <cprintf+0x140>
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  1004d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1004da:	0f b6 01             	movzbl (%ecx),%eax
  1004dd:	85 c0                	test   %eax,%eax
  1004df:	0f 84 93 00 00 00    	je     100578 <cprintf+0xb8>

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  1004e5:	8d 75 0c             	lea    0xc(%ebp),%esi
  1004e8:	31 db                	xor    %ebx,%ebx
  1004ea:	eb 3f                	jmp    10052b <cprintf+0x6b>
  1004ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
  1004f0:	83 fa 25             	cmp    $0x25,%edx
  1004f3:	0f 84 b7 00 00 00    	je     1005b0 <cprintf+0xf0>
  1004f9:	83 fa 64             	cmp    $0x64,%edx
  1004fc:	0f 84 8e 00 00 00    	je     100590 <cprintf+0xd0>
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
  100502:	b8 25 00 00 00       	mov    $0x25,%eax
  100507:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10050a:	e8 51 fd ff ff       	call   100260 <consputc>
      consputc(c);
  10050f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100512:	89 d0                	mov    %edx,%eax
  100514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  100518:	e8 43 fd ff ff       	call   100260 <consputc>
  10051d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100520:	83 c3 01             	add    $0x1,%ebx
  100523:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
  100527:	85 c0                	test   %eax,%eax
  100529:	74 4d                	je     100578 <cprintf+0xb8>
    if(c != '%'){
  10052b:	83 f8 25             	cmp    $0x25,%eax
  10052e:	75 e8                	jne    100518 <cprintf+0x58>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
  100530:	83 c3 01             	add    $0x1,%ebx
  100533:	0f b6 14 19          	movzbl (%ecx,%ebx,1),%edx
    if(c == 0)
  100537:	85 d2                	test   %edx,%edx
  100539:	74 3d                	je     100578 <cprintf+0xb8>
      break;
    switch(c){
  10053b:	83 fa 70             	cmp    $0x70,%edx
  10053e:	74 12                	je     100552 <cprintf+0x92>
  100540:	7e ae                	jle    1004f0 <cprintf+0x30>
  100542:	83 fa 73             	cmp    $0x73,%edx
  100545:	8d 76 00             	lea    0x0(%esi),%esi
  100548:	74 7e                	je     1005c8 <cprintf+0x108>
  10054a:	83 fa 78             	cmp    $0x78,%edx
  10054d:	8d 76 00             	lea    0x0(%esi),%esi
  100550:	75 b0                	jne    100502 <cprintf+0x42>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  100552:	8b 06                	mov    (%esi),%eax
  100554:	31 c9                	xor    %ecx,%ecx
  100556:	ba 10 00 00 00       	mov    $0x10,%edx
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  10055b:	83 c3 01             	add    $0x1,%ebx
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
  10055e:	83 c6 04             	add    $0x4,%esi
  100561:	e8 da fe ff ff       	call   100440 <printint>
  100566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if(locking)
    acquire(&cons.lock);

  argp = (uint*)(void*)(&fmt + 1);
  state = 0;
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
  100569:	0f b6 04 19          	movzbl (%ecx,%ebx,1),%eax
  10056d:	85 c0                	test   %eax,%eax
  10056f:	75 ba                	jne    10052b <cprintf+0x6b>
  100571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc(c);
      break;
    }
  }

  if(locking)
  100578:	85 ff                	test   %edi,%edi
  10057a:	74 0c                	je     100588 <cprintf+0xc8>
    release(&cons.lock);
  10057c:	c7 04 24 20 91 10 00 	movl   $0x109120,(%esp)
  100583:	e8 18 3a 00 00       	call   103fa0 <release>
}
  100588:	83 c4 2c             	add    $0x2c,%esp
  10058b:	5b                   	pop    %ebx
  10058c:	5e                   	pop    %esi
  10058d:	5f                   	pop    %edi
  10058e:	5d                   	pop    %ebp
  10058f:	c3                   	ret    
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
  100590:	8b 06                	mov    (%esi),%eax
  100592:	b9 01 00 00 00       	mov    $0x1,%ecx
  100597:	ba 0a 00 00 00       	mov    $0xa,%edx
  10059c:	83 c6 04             	add    $0x4,%esi
  10059f:	e8 9c fe ff ff       	call   100440 <printint>
  1005a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
  1005a7:	e9 74 ff ff ff       	jmp    100520 <cprintf+0x60>
  1005ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
  1005b0:	b8 25 00 00 00       	mov    $0x25,%eax
  1005b5:	e8 a6 fc ff ff       	call   100260 <consputc>
  1005ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
      break;
  1005bd:	e9 5e ff ff ff       	jmp    100520 <cprintf+0x60>
  1005c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  1005c8:	8b 16                	mov    (%esi),%edx
  1005ca:	83 c6 04             	add    $0x4,%esi
  1005cd:	85 d2                	test   %edx,%edx
  1005cf:	74 47                	je     100618 <cprintf+0x158>
        s = "(null)";
      for(; *s; s++)
  1005d1:	0f b6 02             	movzbl (%edx),%eax
  1005d4:	84 c0                	test   %al,%al
  1005d6:	0f 84 44 ff ff ff    	je     100520 <cprintf+0x60>
  1005dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        consputc(*s);
  1005e0:	0f be c0             	movsbl %al,%eax
  1005e3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1005e6:	e8 75 fc ff ff       	call   100260 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
  1005eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1005ee:	83 c2 01             	add    $0x1,%edx
  1005f1:	0f b6 02             	movzbl (%edx),%eax
  1005f4:	84 c0                	test   %al,%al
  1005f6:	75 e8                	jne    1005e0 <cprintf+0x120>
  1005f8:	e9 20 ff ff ff       	jmp    10051d <cprintf+0x5d>
  1005fd:	8d 76 00             	lea    0x0(%esi),%esi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
  100600:	c7 04 24 20 91 10 00 	movl   $0x109120,(%esp)
  100607:	e8 e4 39 00 00       	call   103ff0 <acquire>
  10060c:	e9 c6 fe ff ff       	jmp    1004d7 <cprintf+0x17>
  100611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  100618:	ba 14 6a 10 00       	mov    $0x106a14,%edx
  10061d:	eb b2                	jmp    1005d1 <cprintf+0x111>
  10061f:	90                   	nop

00100620 <consoleread>:
  release(&input.lock);
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  100620:	55                   	push   %ebp
  100621:	89 e5                	mov    %esp,%ebp
  100623:	57                   	push   %edi
  100624:	56                   	push   %esi
  100625:	53                   	push   %ebx
  100626:	83 ec 5c             	sub    $0x5c,%esp
  100629:	8b 5d 10             	mov    0x10(%ebp),%ebx
  10062c:	8b 75 08             	mov    0x8(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
  10062f:	89 34 24             	mov    %esi,(%esp)
  100632:	e8 f9 12 00 00       	call   101930 <iunlock>
  target = n;
  100637:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&input.lock);
  10063a:	c7 04 24 00 a9 10 00 	movl   $0x10a900,(%esp)
  100641:	e8 aa 39 00 00       	call   103ff0 <acquire>
  while(n > 0){
  100646:	85 db                	test   %ebx,%ebx
  100648:	7f 2b                	jg     100675 <consoleread+0x55>
  10064a:	e9 63 01 00 00       	jmp    1007b2 <consoleread+0x192>
  10064f:	90                   	nop
    while(input.r == input.w){
      if(proc->killed){
  100650:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100656:	8b 40 24             	mov    0x24(%eax),%eax
  100659:	85 c0                	test   %eax,%eax
  10065b:	0f 85 b7 00 00 00    	jne    100718 <consoleread+0xf8>
        release(&input.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
  100661:	c7 44 24 04 00 a9 10 	movl   $0x10a900,0x4(%esp)
  100668:	00 
  100669:	c7 04 24 b4 a9 10 00 	movl   $0x10a9b4,(%esp)
  100670:	e8 8b 2d 00 00       	call   103400 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100675:	a1 b4 a9 10 00       	mov    0x10a9b4,%eax
  10067a:	3b 05 b8 a9 10 00    	cmp    0x10a9b8,%eax
  100680:	74 ce                	je     100650 <consoleread+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  100682:	89 c2                	mov    %eax,%edx
  100684:	83 e2 7f             	and    $0x7f,%edx
  100687:	0f b6 92 34 a9 10 00 	movzbl 0x10a934(%edx),%edx
  10068e:	8d 78 01             	lea    0x1(%eax),%edi
  100691:	89 3d b4 a9 10 00    	mov    %edi,0x10a9b4
  100697:	88 55 c7             	mov    %dl,-0x39(%ebp)
  10069a:	0f be d2             	movsbl %dl,%edx

   if((c != C('D')) && (c != '\n')) {
  10069d:	83 fa 0a             	cmp    $0xa,%edx
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  1006a0:	89 55 b4             	mov    %edx,-0x4c(%ebp)

   if((c != C('D')) && (c != '\n')) {
  1006a3:	0f 84 97 00 00 00    	je     100740 <consoleread+0x120>
  1006a9:	83 fa 04             	cmp    $0x4,%edx
  1006ac:	0f 84 8e 00 00 00    	je     100740 <consoleread+0x120>
   //cprintf("aaaaaaaaa %d aaaaaaaaa",c);
   if(indexToDim1 >= HISTORY_SIZE) {
  1006b2:	8b 0d a4 8a 10 00    	mov    0x108aa4,%ecx
  1006b8:	83 f9 0f             	cmp    $0xf,%ecx
  1006bb:	7e 0c                	jle    1006c9 <consoleread+0xa9>
     indexToDim1 = 0;
  1006bd:	c7 05 a4 8a 10 00 00 	movl   $0x0,0x108aa4
  1006c4:	00 00 00 
  1006c7:	31 c9                	xor    %ecx,%ecx
   }
   prevCmds[indexToDim1][indexToDim2] = c;
  1006c9:	8b 3d a8 8a 10 00    	mov    0x108aa8,%edi
  1006cf:	6b c9 64             	imul   $0x64,%ecx,%ecx
  1006d2:	0f b6 55 c7          	movzbl -0x39(%ebp),%edx
  1006d6:	88 94 0f c0 8a 10 00 	mov    %dl,0x108ac0(%edi,%ecx,1)
   indexToDim2++;
  1006dd:	83 c7 01             	add    $0x1,%edi
  1006e0:	89 3d a8 8a 10 00    	mov    %edi,0x108aa8
   currInd1 = indexToDim1;
   indexToDim1++;
   hasInserted++;
   }

    if(c == C('D')){  // EOF
  1006e6:	83 7d b4 04          	cmpl   $0x4,-0x4c(%ebp)
  1006ea:	0f 84 91 00 00 00    	je     100781 <consoleread+0x161>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1006f0:	0f b6 4d c7          	movzbl -0x39(%ebp),%ecx
    --n;
  1006f4:	83 eb 01             	sub    $0x1,%ebx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  1006f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  1006fa:	88 0f                	mov    %cl,(%edi)
    --n;
    if(c == '\n')
  1006fc:	83 7d b4 0a          	cmpl   $0xa,-0x4c(%ebp)
  100700:	0f 84 85 00 00 00    	je     10078b <consoleread+0x16b>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
  100706:	85 db                	test   %ebx,%ebx
  100708:	0f 8e 7d 00 00 00    	jle    10078b <consoleread+0x16b>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
  10070e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  100712:	e9 5e ff ff ff       	jmp    100675 <consoleread+0x55>
  100717:	90                   	nop
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
  100718:	c7 04 24 00 a9 10 00 	movl   $0x10a900,(%esp)
  10071f:	e8 7c 38 00 00       	call   103fa0 <release>
        ilock(ip);
  100724:	89 34 24             	mov    %esi,(%esp)
  100727:	e8 44 16 00 00       	call   101d70 <ilock>
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  10072c:	83 c4 5c             	add    $0x5c,%esp
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&input.lock);
        ilock(ip);
  10072f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&input.lock);
  ilock(ip);

  return target - n;
}
  100734:	5b                   	pop    %ebx
  100735:	5e                   	pop    %esi
  100736:	5f                   	pop    %edi
  100737:	5d                   	pop    %ebp
  100738:	c3                   	ret    
  100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
   indexToDim2=0;
   currInd1 = indexToDim1;
  100740:	8b 15 a4 8a 10 00    	mov    0x108aa4,%edx
   prevCmds[indexToDim1][indexToDim2] = c;
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
  100746:	6b 3d a4 8a 10 00 64 	imul   $0x64,0x108aa4,%edi
  10074d:	03 3d a8 8a 10 00    	add    0x108aa8,%edi
   indexToDim2=0;
   currInd1 = indexToDim1;
   indexToDim1++;
   hasInserted++;
  100753:	83 05 ac 8a 10 00 01 	addl   $0x1,0x108aac
   prevCmds[indexToDim1][indexToDim2] = c;
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
  10075a:	c6 87 c0 8a 10 00 00 	movb   $0x0,0x108ac0(%edi)
   indexToDim2=0;
   currInd1 = indexToDim1;
   indexToDim1++;
  100761:	89 d7                	mov    %edx,%edi
  100763:	83 c7 01             	add    $0x1,%edi
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
   indexToDim2=0;
  100766:	c7 05 a8 8a 10 00 00 	movl   $0x0,0x108aa8
  10076d:	00 00 00 
   currInd1 = indexToDim1;
  100770:	89 15 00 91 10 00    	mov    %edx,0x109100
   indexToDim1++;
  100776:	89 3d a4 8a 10 00    	mov    %edi,0x108aa4
  10077c:	e9 65 ff ff ff       	jmp    1006e6 <consoleread+0xc6>
   hasInserted++;
   }

    if(c == C('D')){  // EOF
      if(n < target){
  100781:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  100784:	76 05                	jbe    10078b <consoleread+0x16b>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
  100786:	a3 b4 a9 10 00       	mov    %eax,0x10a9b4
  10078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078e:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  100790:	c7 04 24 00 a9 10 00 	movl   $0x10a900,(%esp)
  100797:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10079a:	e8 01 38 00 00       	call   103fa0 <release>
  ilock(ip);
  10079f:	89 34 24             	mov    %esi,(%esp)
  1007a2:	e8 c9 15 00 00       	call   101d70 <ilock>
  1007a7:	8b 45 e0             	mov    -0x20(%ebp),%eax

  return target - n;
}
  1007aa:	83 c4 5c             	add    $0x5c,%esp
  1007ad:	5b                   	pop    %ebx
  1007ae:	5e                   	pop    %esi
  1007af:	5f                   	pop    %edi
  1007b0:	5d                   	pop    %ebp
  1007b1:	c3                   	ret    
  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
  1007b2:	31 c0                	xor    %eax,%eax
  1007b4:	eb da                	jmp    100790 <consoleread+0x170>
  1007b6:	8d 76 00             	lea    0x0(%esi),%esi
  1007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001007c0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  1007c0:	55                   	push   %ebp
  1007c1:	89 e5                	mov    %esp,%ebp
  1007c3:	57                   	push   %edi
  1007c4:	56                   	push   %esi
	}
    break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
  1007c5:	be 30 a9 10 00       	mov    $0x10a930,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  1007ca:	53                   	push   %ebx
  int c;
  int ind=0;	

  acquire(&input.lock);
  1007cb:	31 db                	xor    %ebx,%ebx

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
  1007cd:	83 ec 2c             	sub    $0x2c,%esp
  1007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1007d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int c;
  int ind=0;	

  acquire(&input.lock);
  1007d6:	c7 04 24 00 a9 10 00 	movl   $0x10a900,(%esp)
  1007dd:	e8 0e 38 00 00       	call   103ff0 <acquire>
  1007e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
  1007e8:	ff 55 e4             	call   *-0x1c(%ebp)
  1007eb:	85 c0                	test   %eax,%eax
  1007ed:	89 c7                	mov    %eax,%edi
  1007ef:	0f 88 b0 00 00 00    	js     1008a5 <consoleintr+0xe5>
    switch(c){
  1007f5:	83 ff 10             	cmp    $0x10,%edi
  1007f8:	0f 84 22 01 00 00    	je     100920 <consoleintr+0x160>
  1007fe:	66 90                	xchg   %ax,%ax
  100800:	0f 8f b2 00 00 00    	jg     1008b8 <consoleintr+0xf8>
  100806:	83 ff 08             	cmp    $0x8,%edi
  100809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100810:	0f 84 e2 01 00 00    	je     1009f8 <consoleintr+0x238>
  100816:	83 ff 09             	cmp    $0x9,%edi
  100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100820:	0f 84 0a 01 00 00    	je     100930 <consoleintr+0x170>
	currInd1 = 15;
	}
	}
    break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
  100826:	85 ff                	test   %edi,%edi
  100828:	74 be                	je     1007e8 <consoleintr+0x28>
  10082a:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  10082f:	89 c2                	mov    %eax,%edx
  100831:	2b 15 b4 a9 10 00    	sub    0x10a9b4,%edx
  100837:	83 fa 7f             	cmp    $0x7f,%edx
  10083a:	77 ac                	ja     1007e8 <consoleintr+0x28>
        c = (c == '\r') ? '\n' : c;
  10083c:	83 ff 0d             	cmp    $0xd,%edi
  10083f:	0f 84 23 02 00 00    	je     100a68 <consoleintr+0x2a8>
        input.buf[input.e++ % INPUT_BUF] = c;
  100845:	89 c2                	mov    %eax,%edx
  100847:	89 f9                	mov    %edi,%ecx
  100849:	83 e2 7f             	and    $0x7f,%edx
  10084c:	83 c0 01             	add    $0x1,%eax
  10084f:	88 4c 16 04          	mov    %cl,0x4(%esi,%edx,1)
  100853:	a3 bc a9 10 00       	mov    %eax,0x10a9bc
        consputc(c);
  100858:	89 f8                	mov    %edi,%eax
  10085a:	e8 01 fa ff ff       	call   100260 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10085f:	83 ff 04             	cmp    $0x4,%edi
  100862:	0f 84 1c 02 00 00    	je     100a84 <consoleintr+0x2c4>
  100868:	83 ff 0a             	cmp    $0xa,%edi
  10086b:	0f 84 13 02 00 00    	je     100a84 <consoleintr+0x2c4>
  100871:	8b 15 b4 a9 10 00    	mov    0x10a9b4,%edx
  100877:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  10087c:	83 ea 80             	sub    $0xffffff80,%edx
  10087f:	39 d0                	cmp    %edx,%eax
  100881:	0f 85 61 ff ff ff    	jne    1007e8 <consoleintr+0x28>
          input.w = input.e;
  100887:	a3 b8 a9 10 00       	mov    %eax,0x10a9b8
          wakeup(&input.r);
  10088c:	c7 04 24 b4 a9 10 00 	movl   $0x10a9b4,(%esp)
  100893:	e8 08 2a 00 00       	call   1032a0 <wakeup>
{
  int c;
  int ind=0;	

  acquire(&input.lock);
  while((c = getc()) >= 0){
  100898:	ff 55 e4             	call   *-0x1c(%ebp)
  10089b:	85 c0                	test   %eax,%eax
  10089d:	89 c7                	mov    %eax,%edi
  10089f:	0f 89 50 ff ff ff    	jns    1007f5 <consoleintr+0x35>
        }
      }
      break;
    }
  }
  release(&input.lock);
  1008a5:	c7 45 08 00 a9 10 00 	movl   $0x10a900,0x8(%ebp)
}
  1008ac:	83 c4 2c             	add    $0x2c,%esp
  1008af:	5b                   	pop    %ebx
  1008b0:	5e                   	pop    %esi
  1008b1:	5f                   	pop    %edi
  1008b2:	5d                   	pop    %ebp
        }
      }
      break;
    }
  }
  release(&input.lock);
  1008b3:	e9 e8 36 00 00       	jmp    103fa0 <release>
  int c;
  int ind=0;	

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
  1008b8:	83 ff 7f             	cmp    $0x7f,%edi
  1008bb:	0f 84 37 01 00 00    	je     1009f8 <consoleintr+0x238>
  1008c1:	81 ff e2 00 00 00    	cmp    $0xe2,%edi
  1008c7:	74 67                	je     100930 <consoleintr+0x170>
  1008c9:	83 ff 15             	cmp    $0x15,%edi
  1008cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1008d0:	0f 85 50 ff ff ff    	jne    100826 <consoleintr+0x66>
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  1008d6:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  1008db:	3b 05 b8 a9 10 00    	cmp    0x10a9b8,%eax
  1008e1:	0f 84 01 ff ff ff    	je     1007e8 <consoleintr+0x28>
  1008e7:	90                   	nop
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1008e8:	83 e8 01             	sub    $0x1,%eax
  1008eb:	89 c2                	mov    %eax,%edx
  1008ed:	83 e2 7f             	and    $0x7f,%edx
  1008f0:	80 ba 34 a9 10 00 0a 	cmpb   $0xa,0x10a934(%edx)
  1008f7:	0f 84 eb fe ff ff    	je     1007e8 <consoleintr+0x28>
        input.e--;
  1008fd:	a3 bc a9 10 00       	mov    %eax,0x10a9bc
        consputc(BACKSPACE);
  100902:	b8 00 01 00 00       	mov    $0x100,%eax
  100907:	e8 54 f9 ff ff       	call   100260 <consputc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10090c:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  100911:	3b 05 b8 a9 10 00    	cmp    0x10a9b8,%eax
  100917:	75 cf                	jne    1008e8 <consoleintr+0x128>
  100919:	e9 ca fe ff ff       	jmp    1007e8 <consoleintr+0x28>
  10091e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100920:	e8 4b 34 00 00       	call   103d70 <procdump>
  100925:	8d 76 00             	lea    0x0(%esi),%esi
      break;
  100928:	e9 bb fe ff ff       	jmp    1007e8 <consoleintr+0x28>
  10092d:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
  100930:	8b 0d ac 8a 10 00    	mov    0x108aac,%ecx
  100936:	85 c9                	test   %ecx,%ecx
  100938:	0f 84 aa fe ff ff    	je     1007e8 <consoleintr+0x28>
  10093e:	66 90                	xchg   %ax,%ax
  100940:	eb 26                	jmp    100968 <consoleintr+0x1a8>
  100942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while(input.e != input.w &&
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  100948:	83 e8 01             	sub    $0x1,%eax
  10094b:	89 c2                	mov    %eax,%edx
  10094d:	83 e2 7f             	and    $0x7f,%edx
  100950:	80 ba 34 a9 10 00 0a 	cmpb   $0xa,0x10a934(%edx)
  100957:	74 1c                	je     100975 <consoleintr+0x1b5>
        input.e--;
  100959:	a3 bc a9 10 00       	mov    %eax,0x10a9bc
        consputc(BACKSPACE);
  10095e:	b8 00 01 00 00       	mov    $0x100,%eax
  100963:	e8 f8 f8 ff ff       	call   100260 <consputc>
        consputc(BACKSPACE);
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
	while(input.e != input.w &&
  100968:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  10096d:	3b 05 b8 a9 10 00    	cmp    0x10a9b8,%eax
  100973:	75 d3                	jne    100948 <consoleintr+0x188>
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
	}
	//cprintf("aaaa %d aaaa",currInd1);
	while(prevCmds[currInd1][ind] != 0) {
  100975:	8b 0d 00 91 10 00    	mov    0x109100,%ecx
  10097b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  10097e:	6b c9 64             	imul   $0x64,%ecx,%ecx
  100981:	01 d9                	add    %ebx,%ecx
  100983:	0f b6 81 c0 8a 10 00 	movzbl 0x108ac0(%ecx),%eax
  10098a:	84 c0                	test   %al,%al
  10098c:	74 31                	je     1009bf <consoleintr+0x1ff>
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
	while(input.e != input.w &&
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  10098e:	8b 15 bc a9 10 00    	mov    0x10a9bc,%edx
  100994:	81 c1 c1 8a 10 00    	add    $0x108ac1,%ecx
  10099a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
        consputc(BACKSPACE);
	}
	//cprintf("aaaa %d aaaa",currInd1);
	while(prevCmds[currInd1][ind] != 0) {
        input.buf[input.e++ % INPUT_BUF] = prevCmds[currInd1][ind];
  1009a0:	89 d7                	mov    %edx,%edi
	ind++;
  1009a2:	83 c3 01             	add    $0x1,%ebx
        input.e--;
        consputc(BACKSPACE);
	}
	//cprintf("aaaa %d aaaa",currInd1);
	while(prevCmds[currInd1][ind] != 0) {
        input.buf[input.e++ % INPUT_BUF] = prevCmds[currInd1][ind];
  1009a5:	83 e7 7f             	and    $0x7f,%edi
  1009a8:	83 c2 01             	add    $0x1,%edx
  1009ab:	88 44 3e 04          	mov    %al,0x4(%esi,%edi,1)
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
	}
	//cprintf("aaaa %d aaaa",currInd1);
	while(prevCmds[currInd1][ind] != 0) {
  1009af:	0f b6 01             	movzbl (%ecx),%eax
  1009b2:	83 c1 01             	add    $0x1,%ecx
  1009b5:	84 c0                	test   %al,%al
  1009b7:	75 e7                	jne    1009a0 <consoleintr+0x1e0>
  1009b9:	89 15 bc a9 10 00    	mov    %edx,0x10a9bc
        input.buf[input.e++ % INPUT_BUF] = prevCmds[currInd1][ind];
	ind++;
	}
	if(currInd1 != 0) {
  1009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009c2:	85 d2                	test   %edx,%edx
  1009c4:	75 7d                	jne    100a43 <consoleintr+0x283>
      	cprintf("%s",prevCmds[currInd1]);
	currInd1--;
	}
	else if(hasInserted < 16) {
  1009c6:	83 3d ac 8a 10 00 0f 	cmpl   $0xf,0x108aac
  1009cd:	7f 51                	jg     100a20 <consoleintr+0x260>
      	cprintf("%s",prevCmds[0]);
  1009cf:	c7 44 24 04 c0 8a 10 	movl   $0x108ac0,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 7f 6f 10 00 	movl   $0x106f7f,(%esp)
  1009de:	e8 dd fa ff ff       	call   1004c0 <cprintf>
	currInd1 = indexToDim1-1;
  1009e3:	a1 a4 8a 10 00       	mov    0x108aa4,%eax
  1009e8:	83 e8 01             	sub    $0x1,%eax
  1009eb:	a3 00 91 10 00       	mov    %eax,0x109100
  1009f0:	e9 f3 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
  1009f5:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  1009f8:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  1009fd:	3b 05 b8 a9 10 00    	cmp    0x10a9b8,%eax
  100a03:	0f 84 df fd ff ff    	je     1007e8 <consoleintr+0x28>
        input.e--;
  100a09:	83 e8 01             	sub    $0x1,%eax
  100a0c:	a3 bc a9 10 00       	mov    %eax,0x10a9bc
        consputc(BACKSPACE);
  100a11:	b8 00 01 00 00       	mov    $0x100,%eax
  100a16:	e8 45 f8 ff ff       	call   100260 <consputc>
  100a1b:	e9 c8 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
	else if(hasInserted < 16) {
      	cprintf("%s",prevCmds[0]);
	currInd1 = indexToDim1-1;
	}
	else {
	cprintf("%s",prevCmds[0]);
  100a20:	c7 44 24 04 c0 8a 10 	movl   $0x108ac0,0x4(%esp)
  100a27:	00 
  100a28:	c7 04 24 7f 6f 10 00 	movl   $0x106f7f,(%esp)
  100a2f:	e8 8c fa ff ff       	call   1004c0 <cprintf>
	currInd1 = 15;
  100a34:	c7 05 00 91 10 00 0f 	movl   $0xf,0x109100
  100a3b:	00 00 00 
  100a3e:	e9 a5 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
	while(prevCmds[currInd1][ind] != 0) {
        input.buf[input.e++ % INPUT_BUF] = prevCmds[currInd1][ind];
	ind++;
	}
	if(currInd1 != 0) {
      	cprintf("%s",prevCmds[currInd1]);
  100a43:	6b 45 e0 64          	imul   $0x64,-0x20(%ebp),%eax
  100a47:	c7 04 24 7f 6f 10 00 	movl   $0x106f7f,(%esp)
  100a4e:	05 c0 8a 10 00       	add    $0x108ac0,%eax
  100a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a57:	e8 64 fa ff ff       	call   1004c0 <cprintf>
	currInd1--;
  100a5c:	83 2d 00 91 10 00 01 	subl   $0x1,0x109100
  100a63:	e9 80 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
	}
    break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
  100a68:	89 c2                	mov    %eax,%edx
  100a6a:	83 c0 01             	add    $0x1,%eax
  100a6d:	83 e2 7f             	and    $0x7f,%edx
  100a70:	c6 44 16 04 0a       	movb   $0xa,0x4(%esi,%edx,1)
  100a75:	a3 bc a9 10 00       	mov    %eax,0x10a9bc
        consputc(c);
  100a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  100a7f:	e8 dc f7 ff ff       	call   100260 <consputc>
  100a84:	a1 bc a9 10 00       	mov    0x10a9bc,%eax
  100a89:	e9 f9 fd ff ff       	jmp    100887 <consoleintr+0xc7>
  100a8e:	66 90                	xchg   %ax,%ax

00100a90 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
  100a90:	55                   	push   %ebp
  100a91:	89 e5                	mov    %esp,%ebp
  100a93:	56                   	push   %esi
  100a94:	53                   	push   %ebx
  100a95:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
  100a98:	fa                   	cli    
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  100a99:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  100a9f:	8d 75 d0             	lea    -0x30(%ebp),%esi
  100aa2:	31 db                	xor    %ebx,%ebx
{
  int i;
  uint pcs[10];
  
  cli();
  cons.locking = 0;
  100aa4:	c7 05 54 91 10 00 00 	movl   $0x0,0x109154
  100aab:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
  100aae:	0f b6 00             	movzbl (%eax),%eax
  100ab1:	c7 04 24 1b 6a 10 00 	movl   $0x106a1b,(%esp)
  100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abc:	e8 ff f9 ff ff       	call   1004c0 <cprintf>
  cprintf(s);
  100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac4:	89 04 24             	mov    %eax,(%esp)
  100ac7:	e8 f4 f9 ff ff       	call   1004c0 <cprintf>
  cprintf("\n");
  100acc:	c7 04 24 56 6e 10 00 	movl   $0x106e56,(%esp)
  100ad3:	e8 e8 f9 ff ff       	call   1004c0 <cprintf>
  getcallerpcs(&s, pcs);
  100ad8:	8d 45 08             	lea    0x8(%ebp),%eax
  100adb:	89 74 24 04          	mov    %esi,0x4(%esp)
  100adf:	89 04 24             	mov    %eax,(%esp)
  100ae2:	e8 99 33 00 00       	call   103e80 <getcallerpcs>
  100ae7:	90                   	nop
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  100ae8:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  100aeb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" %p", pcs[i]);
  100aee:	c7 04 24 2a 6a 10 00 	movl   $0x106a2a,(%esp)
  100af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af9:	e8 c2 f9 ff ff       	call   1004c0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
  100afe:	83 fb 0a             	cmp    $0xa,%ebx
  100b01:	75 e5                	jne    100ae8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  100b03:	c7 05 a0 8a 10 00 01 	movl   $0x1,0x108aa0
  100b0a:	00 00 00 
  100b0d:	eb fe                	jmp    100b0d <panic+0x7d>
  100b0f:	90                   	nop

00100b10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
  100b10:	55                   	push   %ebp
  100b11:	89 e5                	mov    %esp,%ebp
  100b13:	57                   	push   %edi
  100b14:	56                   	push   %esi
  100b15:	53                   	push   %ebx
  100b16:	81 ec ac 00 00 00    	sub    $0xac,%esp
  pde_t *pgdir, *oldpgdir;

  pgdir = 0;
  sz = 0;

  if((ip = namei(path)) == 0)
  100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1f:	89 04 24             	mov    %eax,(%esp)
  100b22:	e8 e9 14 00 00       	call   102010 <namei>
  100b27:	89 c7                	mov    %eax,%edi
  100b29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100b2e:	85 ff                	test   %edi,%edi
  100b30:	0f 84 1a 01 00 00    	je     100c50 <exec+0x140>
    return -1;
  ilock(ip);
  100b36:	89 3c 24             	mov    %edi,(%esp)
  100b39:	e8 32 12 00 00       	call   101d70 <ilock>

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
  100b3e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  100b41:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
  100b48:	00 
  100b49:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100b50:	00 
  100b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b55:	89 3c 24             	mov    %edi,(%esp)
  100b58:	e8 d3 09 00 00       	call   101530 <readi>
  100b5d:	83 f8 33             	cmp    $0x33,%eax
  100b60:	0f 86 dd 00 00 00    	jbe    100c43 <exec+0x133>
    goto bad;
  if(elf.magic != ELF_MAGIC)
  100b66:	81 7d 94 7f 45 4c 46 	cmpl   $0x464c457f,-0x6c(%ebp)
  100b6d:	0f 85 d0 00 00 00    	jne    100c43 <exec+0x133>
  100b73:	90                   	nop
  100b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    goto bad;

  if(!(pgdir = setupkvm()))
  100b78:	e8 33 58 00 00       	call   1063b0 <setupkvm>
  100b7d:	85 c0                	test   %eax,%eax
  100b7f:	89 45 80             	mov    %eax,-0x80(%ebp)
  100b82:	0f 84 bb 00 00 00    	je     100c43 <exec+0x133>
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100b88:	66 83 7d c0 00       	cmpw   $0x0,-0x40(%ebp)
  100b8d:	8b 75 b0             	mov    -0x50(%ebp),%esi
  100b90:	0f 84 0d 03 00 00    	je     100ea3 <exec+0x393>
  100b96:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  100b9d:	31 db                	xor    %ebx,%ebx
  100b9f:	eb 19                	jmp    100bba <exec+0xaa>
  100ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  100ba8:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
  100bac:	83 c3 01             	add    $0x1,%ebx
  100baf:	39 d8                	cmp    %ebx,%eax
  100bb1:	0f 8e a9 00 00 00    	jle    100c60 <exec+0x150>
  100bb7:	83 c6 20             	add    $0x20,%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
  100bba:	8d 55 c8             	lea    -0x38(%ebp),%edx
  100bbd:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
  100bc4:	00 
  100bc5:	89 74 24 08          	mov    %esi,0x8(%esp)
  100bc9:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bcd:	89 3c 24             	mov    %edi,(%esp)
  100bd0:	e8 5b 09 00 00       	call   101530 <readi>
  100bd5:	83 f8 20             	cmp    $0x20,%eax
  100bd8:	75 5e                	jne    100c38 <exec+0x128>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
  100bda:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  100bde:	75 c8                	jne    100ba8 <exec+0x98>
      continue;
    if(ph.memsz < ph.filesz)
  100be0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100be3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  100be6:	72 50                	jb     100c38 <exec+0x128>
      goto bad;
    if(!(sz = allocuvm(pgdir, sz, ph.va + ph.memsz)))
  100be8:	03 45 d0             	add    -0x30(%ebp),%eax
  100beb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100bef:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  100bf2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bf6:	8b 45 80             	mov    -0x80(%ebp),%eax
  100bf9:	89 04 24             	mov    %eax,(%esp)
  100bfc:	e8 6f 5a 00 00       	call   106670 <allocuvm>
  100c01:	85 c0                	test   %eax,%eax
  100c03:	89 45 84             	mov    %eax,-0x7c(%ebp)
  100c06:	74 30                	je     100c38 <exec+0x128>
      goto bad;
    if(!loaduvm(pgdir, (char *)ph.va, ip, ph.offset, ph.filesz))
  100c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100c0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  100c0f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  100c12:	89 7c 24 08          	mov    %edi,0x8(%esp)
  100c16:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100c1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c21:	8b 55 80             	mov    -0x80(%ebp),%edx
  100c24:	89 14 24             	mov    %edx,(%esp)
  100c27:	e8 14 5b 00 00       	call   106740 <loaduvm>
  100c2c:	85 c0                	test   %eax,%eax
  100c2e:	0f 85 74 ff ff ff    	jne    100ba8 <exec+0x98>
  100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  freevm(oldpgdir);

  return 0;

 bad:
  if(pgdir) freevm(pgdir);
  100c38:	8b 45 80             	mov    -0x80(%ebp),%eax
  100c3b:	89 04 24             	mov    %eax,(%esp)
  100c3e:	e8 ed 58 00 00       	call   106530 <freevm>
  iunlockput(ip);
  100c43:	89 3c 24             	mov    %edi,(%esp)
  100c46:	e8 35 10 00 00       	call   101c80 <iunlockput>
  100c4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  100c50:	81 c4 ac 00 00 00    	add    $0xac,%esp
  100c56:	5b                   	pop    %ebx
  100c57:	5e                   	pop    %esi
  100c58:	5f                   	pop    %edi
  100c59:	5d                   	pop    %ebp
  100c5a:	c3                   	ret    
  100c5b:	90                   	nop
  100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(!(pgdir = setupkvm()))
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100c60:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  100c63:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
  100c69:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  100c6f:	89 cb                	mov    %ecx,%ebx
  100c71:	89 4d 84             	mov    %ecx,-0x7c(%ebp)
  100c74:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(!(sz = allocuvm(pgdir, sz, ph.va + ph.memsz)))
      goto bad;
    if(!loaduvm(pgdir, (char *)ph.va, ip, ph.offset, ph.filesz))
      goto bad;
  }
  iunlockput(ip);
  100c7a:	89 3c 24             	mov    %edi,(%esp)
  100c7d:	e8 fe 0f 00 00       	call   101c80 <iunlockput>

  // Allocate and initialize stack at sz
  sz = spbottom = PGROUNDUP(sz);
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
  100c82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  100c86:	8b 45 84             	mov    -0x7c(%ebp),%eax
  100c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8d:	8b 55 80             	mov    -0x80(%ebp),%edx
  100c90:	89 14 24             	mov    %edx,(%esp)
  100c93:	e8 d8 59 00 00       	call   106670 <allocuvm>
  100c98:	85 c0                	test   %eax,%eax
  100c9a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  100ca0:	74 96                	je     100c38 <exec+0x128>
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);
  100ca2:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  100ca5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca9:	8b 45 80             	mov    -0x80(%ebp),%eax
  100cac:	89 04 24             	mov    %eax,(%esp)
  100caf:	e8 3c 56 00 00       	call   1062f0 <uva2ka>

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx

  // Allocate and initialize stack at sz
  sz = spbottom = PGROUNDUP(sz);
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);
  100cb7:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100cbd:	8b 11                	mov    (%ecx),%edx
  100cbf:	85 d2                	test   %edx,%edx
  100cc1:	0f 84 ac 01 00 00    	je     100e73 <exec+0x363>
  100cc7:	31 f6                	xor    %esi,%esi
  100cc9:	31 db                	xor    %ebx,%ebx
  100ccb:	89 cf                	mov    %ecx,%edi
  100ccd:	8d 76 00             	lea    0x0(%esi),%esi
    arglen += strlen(argv[argc]) + 1;
  100cd0:	89 14 24             	mov    %edx,(%esp)
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100cd3:	83 c3 01             	add    $0x1,%ebx
    arglen += strlen(argv[argc]) + 1;
  100cd6:	e8 95 35 00 00       	call   104270 <strlen>
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100cdb:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
    arglen += strlen(argv[argc]) + 1;
  100cde:	01 f0                	add    %esi,%eax
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100ce0:	85 d2                	test   %edx,%edx
    arglen += strlen(argv[argc]) + 1;
  100ce2:	8d 70 01             	lea    0x1(%eax),%esi
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100ce5:	75 e9                	jne    100cd0 <exec+0x1c0>
    arglen += strlen(argv[argc]) + 1;
  arglen = (arglen+3) & ~3;

  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100ce7:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100ced:	89 da                	mov    %ebx,%edx
  100cef:	83 c0 04             	add    $0x4,%eax
  100cf2:	f7 d2                	not    %edx
    arglen += strlen(argv[argc]) + 1;
  arglen = (arglen+3) & ~3;

  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100cf4:	83 e0 fc             	and    $0xfffffffc,%eax
  100cf7:	89 9d 70 ff ff ff    	mov    %ebx,-0x90(%ebp)
  if(!(sz = allocuvm(pgdir, sz, sz + PGSIZE)))
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);

  arglen = 0;
  for(argc=0; argv[argc]; argc++)
  100cfd:	89 df                	mov    %ebx,%edi
  100cff:	83 ef 01             	sub    $0x1,%edi
    arglen += strlen(argv[argc]) + 1;
  arglen = (arglen+3) & ~3;

  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100d02:	8d 14 91             	lea    (%ecx,%edx,4),%edx
  100d05:	29 c2                	sub    %eax,%edx
  100d07:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  100d0d:	89 d1                	mov    %edx,%ecx
  100d0f:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  100d15:	2b 4d 84             	sub    -0x7c(%ebp),%ecx
  100d18:	8d 04 99             	lea    (%ecx,%ebx,4),%eax
  100d1b:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
  100d22:	8b 75 0c             	mov    0xc(%ebp),%esi
  100d25:	8d 14 bd 00 00 00 00 	lea    0x0(,%edi,4),%edx
  100d2c:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
  100d32:	01 d6                	add    %edx,%esi
  100d34:	8d 14 11             	lea    (%ecx,%edx,1),%edx
  100d37:	03 95 7c ff ff ff    	add    -0x84(%ebp),%edx
  100d3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=argc-1; i>=0; i--){
    len = strlen(argv[i]) + 1;
  100d40:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100d42:	83 ef 01             	sub    $0x1,%edi
    len = strlen(argv[i]) + 1;
  100d45:	89 04 24             	mov    %eax,(%esp)
  100d48:	89 95 6c ff ff ff    	mov    %edx,-0x94(%ebp)
  100d4e:	e8 1d 35 00 00       	call   104270 <strlen>
    sp -= len;
  100d53:	83 c0 01             	add    $0x1,%eax
  100d56:	29 c3                	sub    %eax,%ebx
    memmove(mem+sp-spbottom, argv[i], len);
  100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d5c:	8b 06                	mov    (%esi),%eax
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100d5e:	83 ee 04             	sub    $0x4,%esi
    len = strlen(argv[i]) + 1;
    sp -= len;
    memmove(mem+sp-spbottom, argv[i], len);
  100d61:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d65:	89 d8                	mov    %ebx,%eax
  100d67:	2b 45 84             	sub    -0x7c(%ebp),%eax
  100d6a:	03 85 7c ff ff ff    	add    -0x84(%ebp),%eax
  100d70:	89 04 24             	mov    %eax,(%esp)
  100d73:	e8 98 33 00 00       	call   104110 <memmove>
    *(uint*)(mem+argp-spbottom + 4*i) = sp;  // argv[i]
  100d78:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  100d7e:	89 1a                	mov    %ebx,(%edx)
  sp = sz;
  argp = sz - arglen - 4*(argc+1);

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  for(i=argc-1; i>=0; i--){
  100d80:	83 ea 04             	sub    $0x4,%edx
  100d83:	83 ff ff             	cmp    $0xffffffff,%edi
  100d86:	75 b8                	jne    100d40 <exec+0x230>
    *(uint*)(mem+argp-spbottom + 4*i) = sp;  // argv[i]
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  100d88:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  *(uint*)(mem+sp-spbottom) = argp;
  100d8e:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  100d94:	8b 8d 7c ff ff ff    	mov    -0x84(%ebp),%ecx
    *(uint*)(mem+argp-spbottom + 4*i) = sp;  // argv[i]
  }

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  100d9a:	83 e8 04             	sub    $0x4,%eax
  *(uint*)(mem+sp-spbottom) = argp;
  100d9d:	2b 45 84             	sub    -0x7c(%ebp),%eax
  100da0:	89 14 01             	mov    %edx,(%ecx,%eax,1)
  sp -= 4;
  100da3:	89 d0                	mov    %edx,%eax
  *(uint*)(mem+sp-spbottom) = argc;
  100da5:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx

  // Stack frame for main(argc, argv), below arguments.
  sp = argp;
  sp -= 4;
  *(uint*)(mem+sp-spbottom) = argp;
  sp -= 4;
  100dab:	83 e8 08             	sub    $0x8,%eax
  *(uint*)(mem+sp-spbottom) = argc;
  100dae:	2b 45 84             	sub    -0x7c(%ebp),%eax
  100db1:	89 14 01             	mov    %edx,(%ecx,%eax,1)
  sp -= 4;
  100db4:	8b 9d 78 ff ff ff    	mov    -0x88(%ebp),%ebx
  100dba:	83 eb 0c             	sub    $0xc,%ebx
  *(uint*)(mem+sp-spbottom) = 0xffffffff;   // fake return pc
  100dbd:	89 d8                	mov    %ebx,%eax
  100dbf:	2b 45 84             	sub    -0x7c(%ebp),%eax
  100dc2:	c7 04 01 ff ff ff ff 	movl   $0xffffffff,(%ecx,%eax,1)

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  100dcc:	0f b6 11             	movzbl (%ecx),%edx
  100dcf:	84 d2                	test   %dl,%dl
  100dd1:	74 28                	je     100dfb <exec+0x2eb>
  100dd3:	89 c8                	mov    %ecx,%eax
  100dd5:	83 c0 01             	add    $0x1,%eax
  100dd8:	eb 10                	jmp    100dea <exec+0x2da>
  100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100de0:	0f b6 10             	movzbl (%eax),%edx
  100de3:	83 c0 01             	add    $0x1,%eax
  100de6:	84 d2                	test   %dl,%dl
  100de8:	74 11                	je     100dfb <exec+0x2eb>
    if(*s == '/')
  100dea:	80 fa 2f             	cmp    $0x2f,%dl
  100ded:	75 f1                	jne    100de0 <exec+0x2d0>
  *(uint*)(mem+sp-spbottom) = argc;
  sp -= 4;
  *(uint*)(mem+sp-spbottom) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100def:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
  100df2:	89 c1                	mov    %eax,%ecx
  *(uint*)(mem+sp-spbottom) = argc;
  sp -= 4;
  *(uint*)(mem+sp-spbottom) = 0xffffffff;   // fake return pc

  // Save program name for debugging.
  for(last=s=path; *s; s++)
  100df4:	83 c0 01             	add    $0x1,%eax
  100df7:	84 d2                	test   %dl,%dl
  100df9:	75 ef                	jne    100dea <exec+0x2da>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
  100dfb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100e01:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100e05:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  100e0c:	00 
  100e0d:	83 c0 6c             	add    $0x6c,%eax
  100e10:	89 04 24             	mov    %eax,(%esp)
  100e13:	e8 18 34 00 00       	call   104230 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
  100e18:	8b 55 80             	mov    -0x80(%ebp),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  100e1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100e21:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
  100e24:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
  100e27:	8b 8d 74 ff ff ff    	mov    -0x8c(%ebp),%ecx
  100e2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100e33:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
  100e35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100e3b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  100e3e:	8b 40 18             	mov    0x18(%eax),%eax
  100e41:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
  100e44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100e4a:	8b 40 18             	mov    0x18(%eax),%eax
  100e4d:	89 58 44             	mov    %ebx,0x44(%eax)

  switchuvm(proc); 
  100e50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  100e56:	89 04 24             	mov    %eax,(%esp)
  100e59:	e8 a2 59 00 00       	call   106800 <switchuvm>

  freevm(oldpgdir);
  100e5e:	89 34 24             	mov    %esi,(%esp)
  100e61:	e8 ca 56 00 00       	call   106530 <freevm>

 bad:
  if(pgdir) freevm(pgdir);
  iunlockput(ip);
  return -1;
}
  100e66:	81 c4 ac 00 00 00    	add    $0xac,%esp
  proc->tf->eip = elf.entry;  // main
  proc->tf->esp = sp;

  switchuvm(proc); 

  freevm(oldpgdir);
  100e6c:	31 c0                	xor    %eax,%eax

 bad:
  if(pgdir) freevm(pgdir);
  iunlockput(ip);
  return -1;
}
  100e6e:	5b                   	pop    %ebx
  100e6f:	5e                   	pop    %esi
  100e70:	5f                   	pop    %edi
  100e71:	5d                   	pop    %ebp
  100e72:	c3                   	ret    
  for(argc=0; argv[argc]; argc++)
    arglen += strlen(argv[argc]) + 1;
  arglen = (arglen+3) & ~3;

  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100e73:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  100e79:	8b 8d 7c ff ff ff    	mov    -0x84(%ebp),%ecx
  for(argc=0; argv[argc]; argc++)
    arglen += strlen(argv[argc]) + 1;
  arglen = (arglen+3) & ~3;

  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100e7f:	83 ea 04             	sub    $0x4,%edx

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  100e82:	89 d0                	mov    %edx,%eax
  100e84:	2b 45 84             	sub    -0x7c(%ebp),%eax
  for(argc=0; argv[argc]; argc++)
    arglen += strlen(argv[argc]) + 1;
  arglen = (arglen+3) & ~3;

  sp = sz;
  argp = sz - arglen - 4*(argc+1);
  100e87:	89 95 78 ff ff ff    	mov    %edx,-0x88(%ebp)

  // Copy argv strings and pointers to stack.
  *(uint*)(mem+argp-spbottom + 4*argc) = 0;  // argv[argc]
  100e8d:	c7 04 01 00 00 00 00 	movl   $0x0,(%ecx,%eax,1)
  100e94:	c7 85 70 ff ff ff 00 	movl   $0x0,-0x90(%ebp)
  100e9b:	00 00 00 
  100e9e:	e9 e5 fe ff ff       	jmp    100d88 <exec+0x278>

  if(!(pgdir = setupkvm()))
    goto bad;

  // Load program into memory.
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
  100ea3:	bb 00 10 00 00       	mov    $0x1000,%ebx
  100ea8:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
  100eaf:	e9 c6 fd ff ff       	jmp    100c7a <exec+0x16a>
  100eb4:	90                   	nop
  100eb5:	90                   	nop
  100eb6:	90                   	nop
  100eb7:	90                   	nop
  100eb8:	90                   	nop
  100eb9:	90                   	nop
  100eba:	90                   	nop
  100ebb:	90                   	nop
  100ebc:	90                   	nop
  100ebd:	90                   	nop
  100ebe:	90                   	nop
  100ebf:	90                   	nop

00100ec0 <filewrite>:
}

// Write to file f.  Addr is kernel address.
int
filewrite(struct file *f, char *addr, int n)
{
  100ec0:	55                   	push   %ebp
  100ec1:	89 e5                	mov    %esp,%ebp
  100ec3:	83 ec 38             	sub    $0x38,%esp
  100ec6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100ecc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100ecf:	8b 75 0c             	mov    0xc(%ebp),%esi
  100ed2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100ed5:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->writable == 0)
  100ed8:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
  100edc:	74 5a                	je     100f38 <filewrite+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100ede:	8b 03                	mov    (%ebx),%eax
  100ee0:	83 f8 01             	cmp    $0x1,%eax
  100ee3:	74 5b                	je     100f40 <filewrite+0x80>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100ee5:	83 f8 02             	cmp    $0x2,%eax
  100ee8:	75 6d                	jne    100f57 <filewrite+0x97>
    ilock(f->ip);
  100eea:	8b 43 10             	mov    0x10(%ebx),%eax
  100eed:	89 04 24             	mov    %eax,(%esp)
  100ef0:	e8 7b 0e 00 00       	call   101d70 <ilock>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
  100ef5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100ef9:	8b 43 14             	mov    0x14(%ebx),%eax
  100efc:	89 74 24 04          	mov    %esi,0x4(%esp)
  100f00:	89 44 24 08          	mov    %eax,0x8(%esp)
  100f04:	8b 43 10             	mov    0x10(%ebx),%eax
  100f07:	89 04 24             	mov    %eax,(%esp)
  100f0a:	e8 b1 07 00 00       	call   1016c0 <writei>
  100f0f:	85 c0                	test   %eax,%eax
  100f11:	7e 03                	jle    100f16 <filewrite+0x56>
      f->off += r;
  100f13:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100f16:	8b 53 10             	mov    0x10(%ebx),%edx
  100f19:	89 14 24             	mov    %edx,(%esp)
  100f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100f1f:	e8 0c 0a 00 00       	call   101930 <iunlock>
    return r;
  100f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("filewrite");
}
  100f27:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f2a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f2d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100f30:	89 ec                	mov    %ebp,%esp
  100f32:	5d                   	pop    %ebp
  100f33:	c3                   	ret    
  100f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100f3d:	eb e8                	jmp    100f27 <filewrite+0x67>
  100f3f:	90                   	nop
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100f40:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100f43:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100f46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100f49:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100f4c:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
}
  100f4f:	89 ec                	mov    %ebp,%esp
  100f51:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  100f52:	e9 d9 1f 00 00       	jmp    102f30 <pipewrite>
    if((r = writei(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("filewrite");
  100f57:	c7 04 24 3f 6a 10 00 	movl   $0x106a3f,(%esp)
  100f5e:	e8 2d fb ff ff       	call   100a90 <panic>
  100f63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  100f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00100f70 <fileread>:
}

// Read from file f.  Addr is kernel address.
int
fileread(struct file *f, char *addr, int n)
{
  100f70:	55                   	push   %ebp
  100f71:	89 e5                	mov    %esp,%ebp
  100f73:	83 ec 38             	sub    $0x38,%esp
  100f76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  100f7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  100f7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  100f82:	89 7d fc             	mov    %edi,-0x4(%ebp)
  100f85:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
  100f88:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
  100f8c:	74 5a                	je     100fe8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
  100f8e:	8b 03                	mov    (%ebx),%eax
  100f90:	83 f8 01             	cmp    $0x1,%eax
  100f93:	74 5b                	je     100ff0 <fileread+0x80>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
  100f95:	83 f8 02             	cmp    $0x2,%eax
  100f98:	75 6d                	jne    101007 <fileread+0x97>
    ilock(f->ip);
  100f9a:	8b 43 10             	mov    0x10(%ebx),%eax
  100f9d:	89 04 24             	mov    %eax,(%esp)
  100fa0:	e8 cb 0d 00 00       	call   101d70 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
  100fa5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  100fa9:	8b 43 14             	mov    0x14(%ebx),%eax
  100fac:	89 74 24 04          	mov    %esi,0x4(%esp)
  100fb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100fb4:	8b 43 10             	mov    0x10(%ebx),%eax
  100fb7:	89 04 24             	mov    %eax,(%esp)
  100fba:	e8 71 05 00 00       	call   101530 <readi>
  100fbf:	85 c0                	test   %eax,%eax
  100fc1:	7e 03                	jle    100fc6 <fileread+0x56>
      f->off += r;
  100fc3:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
  100fc6:	8b 53 10             	mov    0x10(%ebx),%edx
  100fc9:	89 14 24             	mov    %edx,(%esp)
  100fcc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  100fcf:	e8 5c 09 00 00       	call   101930 <iunlock>
    return r;
  100fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
  100fd7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100fda:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100fdd:	8b 7d fc             	mov    -0x4(%ebp),%edi
  100fe0:	89 ec                	mov    %ebp,%esp
  100fe2:	5d                   	pop    %ebp
  100fe3:	c3                   	ret    
  100fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  100fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100fed:	eb e8                	jmp    100fd7 <fileread+0x67>
  100fef:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100ff3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  100ff6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  100ff9:	8b 7d fc             	mov    -0x4(%ebp),%edi
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  100ffc:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
  100fff:	89 ec                	mov    %ebp,%esp
  101001:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  101002:	e9 29 1e 00 00       	jmp    102e30 <piperead>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
  101007:	c7 04 24 49 6a 10 00 	movl   $0x106a49,(%esp)
  10100e:	e8 7d fa ff ff       	call   100a90 <panic>
  101013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101020 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  101020:	55                   	push   %ebp
  if(f->type == FD_INODE){
  101021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  101026:	89 e5                	mov    %esp,%ebp
  101028:	53                   	push   %ebx
  101029:	83 ec 14             	sub    $0x14,%esp
  10102c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
  10102f:	83 3b 02             	cmpl   $0x2,(%ebx)
  101032:	74 0c                	je     101040 <filestat+0x20>
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
  101034:	83 c4 14             	add    $0x14,%esp
  101037:	5b                   	pop    %ebx
  101038:	5d                   	pop    %ebp
  101039:	c3                   	ret    
  10103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
  101040:	8b 43 10             	mov    0x10(%ebx),%eax
  101043:	89 04 24             	mov    %eax,(%esp)
  101046:	e8 25 0d 00 00       	call   101d70 <ilock>
    stati(f->ip, st);
  10104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10104e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101052:	8b 43 10             	mov    0x10(%ebx),%eax
  101055:	89 04 24             	mov    %eax,(%esp)
  101058:	e8 e3 01 00 00       	call   101240 <stati>
    iunlock(f->ip);
  10105d:	8b 43 10             	mov    0x10(%ebx),%eax
  101060:	89 04 24             	mov    %eax,(%esp)
  101063:	e8 c8 08 00 00       	call   101930 <iunlock>
    return 0;
  }
  return -1;
}
  101068:	83 c4 14             	add    $0x14,%esp
filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
  10106b:	31 c0                	xor    %eax,%eax
    return 0;
  }
  return -1;
}
  10106d:	5b                   	pop    %ebx
  10106e:	5d                   	pop    %ebp
  10106f:	c3                   	ret    

00101070 <filedup>:
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  101070:	55                   	push   %ebp
  101071:	89 e5                	mov    %esp,%ebp
  101073:	53                   	push   %ebx
  101074:	83 ec 14             	sub    $0x14,%esp
  101077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
  10107a:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  101081:	e8 6a 2f 00 00       	call   103ff0 <acquire>
  if(f->ref < 1)
  101086:	8b 43 04             	mov    0x4(%ebx),%eax
  101089:	85 c0                	test   %eax,%eax
  10108b:	7e 1a                	jle    1010a7 <filedup+0x37>
    panic("filedup");
  f->ref++;
  10108d:	83 c0 01             	add    $0x1,%eax
  101090:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
  101093:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  10109a:	e8 01 2f 00 00       	call   103fa0 <release>
  return f;
}
  10109f:	89 d8                	mov    %ebx,%eax
  1010a1:	83 c4 14             	add    $0x14,%esp
  1010a4:	5b                   	pop    %ebx
  1010a5:	5d                   	pop    %ebp
  1010a6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  1010a7:	c7 04 24 52 6a 10 00 	movl   $0x106a52,(%esp)
  1010ae:	e8 dd f9 ff ff       	call   100a90 <panic>
  1010b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1010b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001010c0 <filealloc>:
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  1010c0:	55                   	push   %ebp
  1010c1:	89 e5                	mov    %esp,%ebp
  1010c3:	53                   	push   %ebx
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
  1010c4:	bb 0c aa 10 00       	mov    $0x10aa0c,%ebx
{
  1010c9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
  1010cc:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  1010d3:	e8 18 2f 00 00       	call   103ff0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
  1010d8:	8b 15 f8 a9 10 00    	mov    0x10a9f8,%edx
  1010de:	85 d2                	test   %edx,%edx
  1010e0:	75 11                	jne    1010f3 <filealloc+0x33>
  1010e2:	eb 4a                	jmp    10112e <filealloc+0x6e>
  1010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
  1010e8:	83 c3 18             	add    $0x18,%ebx
  1010eb:	81 fb 54 b3 10 00    	cmp    $0x10b354,%ebx
  1010f1:	74 25                	je     101118 <filealloc+0x58>
    if(f->ref == 0){
  1010f3:	8b 43 04             	mov    0x4(%ebx),%eax
  1010f6:	85 c0                	test   %eax,%eax
  1010f8:	75 ee                	jne    1010e8 <filealloc+0x28>
      f->ref = 1;
  1010fa:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
  101101:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  101108:	e8 93 2e 00 00       	call   103fa0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
  10110d:	89 d8                	mov    %ebx,%eax
  10110f:	83 c4 14             	add    $0x14,%esp
  101112:	5b                   	pop    %ebx
  101113:	5d                   	pop    %ebp
  101114:	c3                   	ret    
  101115:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  101118:	31 db                	xor    %ebx,%ebx
  10111a:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  101121:	e8 7a 2e 00 00       	call   103fa0 <release>
  return 0;
}
  101126:	89 d8                	mov    %ebx,%eax
  101128:	83 c4 14             	add    $0x14,%esp
  10112b:	5b                   	pop    %ebx
  10112c:	5d                   	pop    %ebp
  10112d:	c3                   	ret    
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
  10112e:	bb f4 a9 10 00       	mov    $0x10a9f4,%ebx
  101133:	eb c5                	jmp    1010fa <filealloc+0x3a>
  101135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101140 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  101140:	55                   	push   %ebp
  101141:	89 e5                	mov    %esp,%ebp
  101143:	83 ec 38             	sub    $0x38,%esp
  101146:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101149:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10114c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10114f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct file ff;

  acquire(&ftable.lock);
  101152:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  101159:	e8 92 2e 00 00       	call   103ff0 <acquire>
  if(f->ref < 1)
  10115e:	8b 43 04             	mov    0x4(%ebx),%eax
  101161:	85 c0                	test   %eax,%eax
  101163:	0f 8e 9c 00 00 00    	jle    101205 <fileclose+0xc5>
    panic("fileclose");
  if(--f->ref > 0){
  101169:	83 e8 01             	sub    $0x1,%eax
  10116c:	85 c0                	test   %eax,%eax
  10116e:	89 43 04             	mov    %eax,0x4(%ebx)
  101171:	74 1d                	je     101190 <fileclose+0x50>
    release(&ftable.lock);
  101173:	c7 45 08 c0 a9 10 00 	movl   $0x10a9c0,0x8(%ebp)
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
}
  10117a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10117d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101180:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101183:	89 ec                	mov    %ebp,%esp
  101185:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
  101186:	e9 15 2e 00 00       	jmp    103fa0 <release>
  10118b:	90                   	nop
  10118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
  101190:	8b 43 0c             	mov    0xc(%ebx),%eax
  101193:	8b 7b 10             	mov    0x10(%ebx),%edi
  101196:	89 45 e0             	mov    %eax,-0x20(%ebp)
  101199:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  10119d:	88 45 e7             	mov    %al,-0x19(%ebp)
  1011a0:	8b 33                	mov    (%ebx),%esi
  f->ref = 0;
  1011a2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
  1011a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
  1011af:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  1011b6:	e8 e5 2d 00 00       	call   103fa0 <release>
  
  if(ff.type == FD_PIPE)
  1011bb:	83 fe 01             	cmp    $0x1,%esi
  1011be:	74 30                	je     1011f0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
  1011c0:	83 fe 02             	cmp    $0x2,%esi
  1011c3:	74 13                	je     1011d8 <fileclose+0x98>
    iput(ff.ip);
}
  1011c5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1011c8:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1011cb:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1011ce:	89 ec                	mov    %ebp,%esp
  1011d0:	5d                   	pop    %ebp
  1011d1:	c3                   	ret    
  1011d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  1011d8:	89 7d 08             	mov    %edi,0x8(%ebp)
}
  1011db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1011de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1011e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1011e4:	89 ec                	mov    %ebp,%esp
  1011e6:	5d                   	pop    %ebp
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE)
    iput(ff.ip);
  1011e7:	e9 54 08 00 00       	jmp    101a40 <iput>
  1011ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
  
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  1011f0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  1011f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1011f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1011fb:	89 04 24             	mov    %eax,(%esp)
  1011fe:	e8 1d 1e 00 00       	call   103020 <pipeclose>
  101203:	eb c0                	jmp    1011c5 <fileclose+0x85>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  101205:	c7 04 24 5a 6a 10 00 	movl   $0x106a5a,(%esp)
  10120c:	e8 7f f8 ff ff       	call   100a90 <panic>
  101211:	eb 0d                	jmp    101220 <fileinit>
  101213:	90                   	nop
  101214:	90                   	nop
  101215:	90                   	nop
  101216:	90                   	nop
  101217:	90                   	nop
  101218:	90                   	nop
  101219:	90                   	nop
  10121a:	90                   	nop
  10121b:	90                   	nop
  10121c:	90                   	nop
  10121d:	90                   	nop
  10121e:	90                   	nop
  10121f:	90                   	nop

00101220 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
  101220:	55                   	push   %ebp
  101221:	89 e5                	mov    %esp,%ebp
  101223:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
  101226:	c7 44 24 04 64 6a 10 	movl   $0x106a64,0x4(%esp)
  10122d:	00 
  10122e:	c7 04 24 c0 a9 10 00 	movl   $0x10a9c0,(%esp)
  101235:	e8 26 2c 00 00       	call   103e60 <initlock>
}
  10123a:	c9                   	leave  
  10123b:	c3                   	ret    
  10123c:	90                   	nop
  10123d:	90                   	nop
  10123e:	90                   	nop
  10123f:	90                   	nop

00101240 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
  101240:	55                   	push   %ebp
  101241:	89 e5                	mov    %esp,%ebp
  101243:	8b 55 08             	mov    0x8(%ebp),%edx
  101246:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
  101249:	8b 0a                	mov    (%edx),%ecx
  10124b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
  10124e:	8b 4a 04             	mov    0x4(%edx),%ecx
  101251:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
  101254:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
  101258:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
  10125b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
  10125f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
  101263:	8b 52 18             	mov    0x18(%edx),%edx
  101266:	89 50 10             	mov    %edx,0x10(%eax)
}
  101269:	5d                   	pop    %ebp
  10126a:	c3                   	ret    
  10126b:	90                   	nop
  10126c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00101270 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  101270:	55                   	push   %ebp
  101271:	89 e5                	mov    %esp,%ebp
  101273:	53                   	push   %ebx
  101274:	83 ec 14             	sub    $0x14,%esp
  101277:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
  10127a:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101281:	e8 6a 2d 00 00       	call   103ff0 <acquire>
  ip->ref++;
  101286:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10128a:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101291:	e8 0a 2d 00 00       	call   103fa0 <release>
  return ip;
}
  101296:	89 d8                	mov    %ebx,%eax
  101298:	83 c4 14             	add    $0x14,%esp
  10129b:	5b                   	pop    %ebx
  10129c:	5d                   	pop    %ebp
  10129d:	c3                   	ret    
  10129e:	66 90                	xchg   %ax,%ax

001012a0 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
{
  1012a0:	55                   	push   %ebp
  1012a1:	89 e5                	mov    %esp,%ebp
  1012a3:	57                   	push   %edi
  1012a4:	89 d7                	mov    %edx,%edi
  1012a6:	56                   	push   %esi
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  1012a7:	31 f6                	xor    %esi,%esi
{
  1012a9:	53                   	push   %ebx
  1012aa:	89 c3                	mov    %eax,%ebx
  1012ac:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
  1012af:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  1012b6:	e8 35 2d 00 00       	call   103ff0 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  1012bb:	b8 f4 b3 10 00       	mov    $0x10b3f4,%eax
  1012c0:	eb 14                	jmp    1012d6 <iget+0x36>
  1012c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  1012c8:	85 f6                	test   %esi,%esi
  1012ca:	74 3c                	je     101308 <iget+0x68>

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  1012cc:	83 c0 50             	add    $0x50,%eax
  1012cf:	3d 94 c3 10 00       	cmp    $0x10c394,%eax
  1012d4:	74 42                	je     101318 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
  1012d6:	8b 48 08             	mov    0x8(%eax),%ecx
  1012d9:	85 c9                	test   %ecx,%ecx
  1012db:	7e eb                	jle    1012c8 <iget+0x28>
  1012dd:	39 18                	cmp    %ebx,(%eax)
  1012df:	75 e7                	jne    1012c8 <iget+0x28>
  1012e1:	39 78 04             	cmp    %edi,0x4(%eax)
  1012e4:	75 e2                	jne    1012c8 <iget+0x28>
      ip->ref++;
  1012e6:	83 c1 01             	add    $0x1,%ecx
  1012e9:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
  1012ec:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  1012f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1012f6:	e8 a5 2c 00 00       	call   103fa0 <release>
      return ip;
  1012fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
  1012fe:	83 c4 2c             	add    $0x2c,%esp
  101301:	5b                   	pop    %ebx
  101302:	5e                   	pop    %esi
  101303:	5f                   	pop    %edi
  101304:	5d                   	pop    %ebp
  101305:	c3                   	ret    
  101306:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
  101308:	85 c9                	test   %ecx,%ecx
  10130a:	75 c0                	jne    1012cc <iget+0x2c>
  10130c:	89 c6                	mov    %eax,%esi

  acquire(&icache.lock);

  // Try for cached inode.
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
  10130e:	83 c0 50             	add    $0x50,%eax
  101311:	3d 94 c3 10 00       	cmp    $0x10c394,%eax
  101316:	75 be                	jne    1012d6 <iget+0x36>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
  101318:	85 f6                	test   %esi,%esi
  10131a:	74 29                	je     101345 <iget+0xa5>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
  10131c:	89 1e                	mov    %ebx,(%esi)
  ip->inum = inum;
  10131e:	89 7e 04             	mov    %edi,0x4(%esi)
  ip->ref = 1;
  101321:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
  101328:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
  10132f:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101336:	e8 65 2c 00 00       	call   103fa0 <release>

  return ip;
}
  10133b:	83 c4 2c             	add    $0x2c,%esp
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
  10133e:	89 f0                	mov    %esi,%eax

  return ip;
}
  101340:	5b                   	pop    %ebx
  101341:	5e                   	pop    %esi
  101342:	5f                   	pop    %edi
  101343:	5d                   	pop    %ebp
  101344:	c3                   	ret    
      empty = ip;
  }

  // Allocate fresh inode.
  if(empty == 0)
    panic("iget: no inodes");
  101345:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  10134c:	e8 3f f7 ff ff       	call   100a90 <panic>
  101351:	eb 0d                	jmp    101360 <readsb>
  101353:	90                   	nop
  101354:	90                   	nop
  101355:	90                   	nop
  101356:	90                   	nop
  101357:	90                   	nop
  101358:	90                   	nop
  101359:	90                   	nop
  10135a:	90                   	nop
  10135b:	90                   	nop
  10135c:	90                   	nop
  10135d:	90                   	nop
  10135e:	90                   	nop
  10135f:	90                   	nop

00101360 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  101360:	55                   	push   %ebp
  101361:	89 e5                	mov    %esp,%ebp
  101363:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
  101366:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10136d:	00 
static void itrunc(struct inode*);

// Read the super block.
static void
readsb(int dev, struct superblock *sb)
{
  10136e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  101371:	89 75 fc             	mov    %esi,-0x4(%ebp)
  101374:	89 d6                	mov    %edx,%esi
  struct buf *bp;
  
  bp = bread(dev, 1);
  101376:	89 04 24             	mov    %eax,(%esp)
  101379:	e8 32 ed ff ff       	call   1000b0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
  10137e:	89 34 24             	mov    %esi,(%esp)
  101381:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
  101388:	00 
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;
  
  bp = bread(dev, 1);
  101389:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
  10138b:	8d 40 18             	lea    0x18(%eax),%eax
  10138e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101392:	e8 79 2d 00 00       	call   104110 <memmove>
  brelse(bp);
  101397:	89 1c 24             	mov    %ebx,(%esp)
  10139a:	e8 61 ec ff ff       	call   100000 <brelse>
}
  10139f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1013a2:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1013a5:	89 ec                	mov    %ebp,%esp
  1013a7:	5d                   	pop    %ebp
  1013a8:	c3                   	ret    
  1013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001013b0 <balloc>:
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  1013b0:	55                   	push   %ebp
  1013b1:	89 e5                	mov    %esp,%ebp
  1013b3:	57                   	push   %edi
  1013b4:	56                   	push   %esi
  1013b5:	53                   	push   %ebx
  1013b6:	83 ec 3c             	sub    $0x3c,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  1013b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
// Blocks. 

// Allocate a disk block.
static uint
balloc(uint dev)
{
  1013bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  1013bf:	e8 9c ff ff ff       	call   101360 <readsb>
  for(b = 0; b < sb.size; b += BPB){
  1013c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1013c7:	85 c0                	test   %eax,%eax
  1013c9:	0f 84 9c 00 00 00    	je     10146b <balloc+0xbb>
  1013cf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    bp = bread(dev, BBLOCK(b, sb.ninodes));
  1013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1013d9:	31 db                	xor    %ebx,%ebx
  1013db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1013de:	c1 e8 03             	shr    $0x3,%eax
  1013e1:	c1 fa 0c             	sar    $0xc,%edx
  1013e4:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  1013e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1013ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1013ef:	89 04 24             	mov    %eax,(%esp)
  1013f2:	e8 b9 ec ff ff       	call   1000b0 <bread>
  1013f7:	89 c6                	mov    %eax,%esi
  1013f9:	eb 10                	jmp    10140b <balloc+0x5b>
  1013fb:	90                   	nop
  1013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(bi = 0; bi < BPB; bi++){
  101400:	83 c3 01             	add    $0x1,%ebx
  101403:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  101409:	74 45                	je     101450 <balloc+0xa0>
      m = 1 << (bi % 8);
  10140b:	89 d9                	mov    %ebx,%ecx
  10140d:	ba 01 00 00 00       	mov    $0x1,%edx
  101412:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101415:	89 d8                	mov    %ebx,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  101417:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  101419:	c1 f8 03             	sar    $0x3,%eax
  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
  10141c:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
  10141e:	0f b6 54 06 18       	movzbl 0x18(%esi,%eax,1),%edx
  101423:	0f b6 fa             	movzbl %dl,%edi
  101426:	85 cf                	test   %ecx,%edi
  101428:	75 d6                	jne    101400 <balloc+0x50>
        bp->data[bi/8] |= m;  // Mark block in use on disk.
  10142a:	09 d1                	or     %edx,%ecx
  10142c:	88 4c 06 18          	mov    %cl,0x18(%esi,%eax,1)
        bwrite(bp);
  101430:	89 34 24             	mov    %esi,(%esp)
  101433:	e8 48 ec ff ff       	call   100080 <bwrite>
        brelse(bp);
  101438:	89 34 24             	mov    %esi,(%esp)
  10143b:	e8 c0 eb ff ff       	call   100000 <brelse>
  101440:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101443:	83 c4 3c             	add    $0x3c,%esp
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use on disk.
        bwrite(bp);
        brelse(bp);
  101446:	8d 04 13             	lea    (%ebx,%edx,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
  101449:	5b                   	pop    %ebx
  10144a:	5e                   	pop    %esi
  10144b:	5f                   	pop    %edi
  10144c:	5d                   	pop    %ebp
  10144d:	c3                   	ret    
  10144e:	66 90                	xchg   %ax,%ax
        bwrite(bp);
        brelse(bp);
        return b + bi;
      }
    }
    brelse(bp);
  101450:	89 34 24             	mov    %esi,(%esp)
  101453:	e8 a8 eb ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
  101458:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
  10145f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  101462:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101465:	0f 87 6b ff ff ff    	ja     1013d6 <balloc+0x26>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
  10146b:	c7 04 24 7b 6a 10 00 	movl   $0x106a7b,(%esp)
  101472:	e8 19 f6 ff ff       	call   100a90 <panic>
  101477:	89 f6                	mov    %esi,%esi
  101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101480 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  101480:	55                   	push   %ebp
  101481:	89 e5                	mov    %esp,%ebp
  101483:	83 ec 38             	sub    $0x38,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101486:	83 fa 0b             	cmp    $0xb,%edx

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
  101489:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10148c:	89 c3                	mov    %eax,%ebx
  10148e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  101491:	89 7d fc             	mov    %edi,-0x4(%ebp)
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
  101494:	77 1a                	ja     1014b0 <bmap+0x30>
    if((addr = ip->addrs[bn]) == 0)
  101496:	8d 7a 04             	lea    0x4(%edx),%edi
  101499:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
  10149d:	85 c0                	test   %eax,%eax
  10149f:	74 5f                	je     101500 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
  1014a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1014a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1014a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1014aa:	89 ec                	mov    %ebp,%esp
  1014ac:	5d                   	pop    %ebp
  1014ad:	c3                   	ret    
  1014ae:	66 90                	xchg   %ax,%ax
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
  1014b0:	8d 7a f4             	lea    -0xc(%edx),%edi

  if(bn < NINDIRECT){
  1014b3:	83 ff 7f             	cmp    $0x7f,%edi
  1014b6:	77 64                	ja     10151c <bmap+0x9c>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
  1014b8:	8b 40 4c             	mov    0x4c(%eax),%eax
  1014bb:	85 c0                	test   %eax,%eax
  1014bd:	74 51                	je     101510 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
  1014bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1014c3:	8b 03                	mov    (%ebx),%eax
  1014c5:	89 04 24             	mov    %eax,(%esp)
  1014c8:	e8 e3 eb ff ff       	call   1000b0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
  1014cd:	8d 7c b8 18          	lea    0x18(%eax,%edi,4),%edi

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
  1014d1:	89 c6                	mov    %eax,%esi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
  1014d3:	8b 07                	mov    (%edi),%eax
  1014d5:	85 c0                	test   %eax,%eax
  1014d7:	75 17                	jne    1014f0 <bmap+0x70>
      a[bn] = addr = balloc(ip->dev);
  1014d9:	8b 03                	mov    (%ebx),%eax
  1014db:	e8 d0 fe ff ff       	call   1013b0 <balloc>
  1014e0:	89 07                	mov    %eax,(%edi)
      bwrite(bp);
  1014e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1014e5:	89 34 24             	mov    %esi,(%esp)
  1014e8:	e8 93 eb ff ff       	call   100080 <bwrite>
  1014ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    }
    brelse(bp);
  1014f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1014f3:	89 34 24             	mov    %esi,(%esp)
  1014f6:	e8 05 eb ff ff       	call   100000 <brelse>
    return addr;
  1014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1014fe:	eb a1                	jmp    1014a1 <bmap+0x21>
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
  101500:	8b 03                	mov    (%ebx),%eax
  101502:	e8 a9 fe ff ff       	call   1013b0 <balloc>
  101507:	89 44 bb 0c          	mov    %eax,0xc(%ebx,%edi,4)
  10150b:	eb 94                	jmp    1014a1 <bmap+0x21>
  10150d:	8d 76 00             	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
  101510:	8b 03                	mov    (%ebx),%eax
  101512:	e8 99 fe ff ff       	call   1013b0 <balloc>
  101517:	89 43 4c             	mov    %eax,0x4c(%ebx)
  10151a:	eb a3                	jmp    1014bf <bmap+0x3f>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
  10151c:	c7 04 24 91 6a 10 00 	movl   $0x106a91,(%esp)
  101523:	e8 68 f5 ff ff       	call   100a90 <panic>
  101528:	90                   	nop
  101529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101530 <readi>:
}

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
  101530:	55                   	push   %ebp
  101531:	89 e5                	mov    %esp,%ebp
  101533:	83 ec 38             	sub    $0x38,%esp
  101536:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  101539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10153c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10153f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  101542:	89 7d fc             	mov    %edi,-0x4(%ebp)
  101545:	8b 75 10             	mov    0x10(%ebp),%esi
  101548:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  10154b:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
  101550:	74 1e                	je     101570 <readi+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
  101552:	8b 43 18             	mov    0x18(%ebx),%eax
  101555:	39 f0                	cmp    %esi,%eax
  101557:	73 3f                	jae    101598 <readi+0x68>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101559:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10155e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  101561:	8b 75 f8             	mov    -0x8(%ebp),%esi
  101564:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101567:	89 ec                	mov    %ebp,%esp
  101569:	5d                   	pop    %ebp
  10156a:	c3                   	ret    
  10156b:	90                   	nop
  10156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
  101570:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101574:	66 83 f8 09          	cmp    $0x9,%ax
  101578:	77 df                	ja     101559 <readi+0x29>
  10157a:	98                   	cwtl   
  10157b:	8b 04 c5 60 b3 10 00 	mov    0x10b360(,%eax,8),%eax
  101582:	85 c0                	test   %eax,%eax
  101584:	74 d3                	je     101559 <readi+0x29>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101586:	89 4d 10             	mov    %ecx,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
  101589:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10158c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10158f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101592:	89 ec                	mov    %ebp,%esp
  101594:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  101595:	ff e0                	jmp    *%eax
  101597:	90                   	nop
  }

  if(off > ip->size || off + n < off)
  101598:	89 ca                	mov    %ecx,%edx
  10159a:	01 f2                	add    %esi,%edx
  10159c:	72 bb                	jb     101559 <readi+0x29>
    return -1;
  if(off + n > ip->size)
  10159e:	39 d0                	cmp    %edx,%eax
  1015a0:	73 04                	jae    1015a6 <readi+0x76>
    n = ip->size - off;
  1015a2:	89 c1                	mov    %eax,%ecx
  1015a4:	29 f1                	sub    %esi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1015a6:	85 c9                	test   %ecx,%ecx
  1015a8:	74 7c                	je     101626 <readi+0xf6>
  1015aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
  1015b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
  1015b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  1015b7:	90                   	nop
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1015b8:	89 f2                	mov    %esi,%edx
  1015ba:	89 d8                	mov    %ebx,%eax
  1015bc:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1015bf:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1015c4:	e8 b7 fe ff ff       	call   101480 <bmap>
  1015c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015cd:	8b 03                	mov    (%ebx),%eax
  1015cf:	89 04 24             	mov    %eax,(%esp)
  1015d2:	e8 d9 ea ff ff       	call   1000b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  1015d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1015da:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  1015dd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  1015df:	89 f0                	mov    %esi,%eax
  1015e1:	25 ff 01 00 00       	and    $0x1ff,%eax
  1015e6:	29 c7                	sub    %eax,%edi
  1015e8:	39 cf                	cmp    %ecx,%edi
  1015ea:	76 02                	jbe    1015ee <readi+0xbe>
  1015ec:	89 cf                	mov    %ecx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
  1015ee:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  1015f2:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
  1015f4:	89 7c 24 08          	mov    %edi,0x8(%esp)
  1015f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1015fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1015ff:	89 04 24             	mov    %eax,(%esp)
  101602:	89 55 d8             	mov    %edx,-0x28(%ebp)
  101605:	e8 06 2b 00 00       	call   104110 <memmove>
    brelse(bp);
  10160a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10160d:	89 14 24             	mov    %edx,(%esp)
  101610:	e8 eb e9 ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
  101615:	01 7d e4             	add    %edi,-0x1c(%ebp)
  101618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10161b:	01 7d e0             	add    %edi,-0x20(%ebp)
  10161e:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  101621:	77 95                	ja     1015b8 <readi+0x88>
  101623:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
  101626:	89 c8                	mov    %ecx,%eax
  101628:	e9 31 ff ff ff       	jmp    10155e <readi+0x2e>
  10162d:	8d 76 00             	lea    0x0(%esi),%esi

00101630 <iupdate>:
}

// Copy inode, which has changed, from memory to disk.
void
iupdate(struct inode *ip)
{
  101630:	55                   	push   %ebp
  101631:	89 e5                	mov    %esp,%ebp
  101633:	56                   	push   %esi
  101634:	53                   	push   %ebx
  101635:	83 ec 10             	sub    $0x10,%esp
  101638:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  10163b:	8b 43 04             	mov    0x4(%ebx),%eax
  10163e:	c1 e8 03             	shr    $0x3,%eax
  101641:	83 c0 02             	add    $0x2,%eax
  101644:	89 44 24 04          	mov    %eax,0x4(%esp)
  101648:	8b 03                	mov    (%ebx),%eax
  10164a:	89 04 24             	mov    %eax,(%esp)
  10164d:	e8 5e ea ff ff       	call   1000b0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  101652:	0f b7 53 10          	movzwl 0x10(%ebx),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
  101656:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  101658:	8b 43 04             	mov    0x4(%ebx),%eax
  10165b:	83 e0 07             	and    $0x7,%eax
  10165e:	c1 e0 06             	shl    $0x6,%eax
  101661:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
  101665:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
  101668:	0f b7 53 12          	movzwl 0x12(%ebx),%edx
  10166c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
  101670:	0f b7 53 14          	movzwl 0x14(%ebx),%edx
  101674:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
  101678:	0f b7 53 16          	movzwl 0x16(%ebx),%edx
  10167c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
  101680:	8b 53 18             	mov    0x18(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101683:	83 c3 1c             	add    $0x1c,%ebx
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  101686:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  101689:	83 c0 0c             	add    $0xc,%eax
  10168c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101690:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101697:	00 
  101698:	89 04 24             	mov    %eax,(%esp)
  10169b:	e8 70 2a 00 00       	call   104110 <memmove>
  bwrite(bp);
  1016a0:	89 34 24             	mov    %esi,(%esp)
  1016a3:	e8 d8 e9 ff ff       	call   100080 <bwrite>
  brelse(bp);
  1016a8:	89 75 08             	mov    %esi,0x8(%ebp)
}
  1016ab:	83 c4 10             	add    $0x10,%esp
  1016ae:	5b                   	pop    %ebx
  1016af:	5e                   	pop    %esi
  1016b0:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  bwrite(bp);
  brelse(bp);
  1016b1:	e9 4a e9 ff ff       	jmp    100000 <brelse>
  1016b6:	8d 76 00             	lea    0x0(%esi),%esi
  1016b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001016c0 <writei>:
}

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
  1016c0:	55                   	push   %ebp
  1016c1:	89 e5                	mov    %esp,%ebp
  1016c3:	83 ec 38             	sub    $0x38,%esp
  1016c6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1016c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  1016cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1016cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  1016d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1016d5:	8b 75 10             	mov    0x10(%ebp),%esi
  1016d8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
  1016db:	66 83 7b 10 03       	cmpw   $0x3,0x10(%ebx)
  1016e0:	74 1e                	je     101700 <writei+0x40>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
  1016e2:	39 73 18             	cmp    %esi,0x18(%ebx)
  1016e5:	73 41                	jae    101728 <writei+0x68>

  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1016e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1016ec:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1016ef:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1016f2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1016f5:	89 ec                	mov    %ebp,%esp
  1016f7:	5d                   	pop    %ebp
  1016f8:	c3                   	ret    
  1016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
  101700:	0f b7 43 12          	movzwl 0x12(%ebx),%eax
  101704:	66 83 f8 09          	cmp    $0x9,%ax
  101708:	77 dd                	ja     1016e7 <writei+0x27>
  10170a:	98                   	cwtl   
  10170b:	8b 04 c5 64 b3 10 00 	mov    0x10b364(,%eax,8),%eax
  101712:	85 c0                	test   %eax,%eax
  101714:	74 d1                	je     1016e7 <writei+0x27>
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101716:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
  101719:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10171c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10171f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  101722:	89 ec                	mov    %ebp,%esp
  101724:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  101725:	ff e0                	jmp    *%eax
  101727:	90                   	nop
  }

  if(off > ip->size || off + n < off)
  101728:	89 c8                	mov    %ecx,%eax
  10172a:	01 f0                	add    %esi,%eax
  10172c:	72 b9                	jb     1016e7 <writei+0x27>
    return -1;
  if(off + n > MAXFILE*BSIZE)
  10172e:	3d 00 18 01 00       	cmp    $0x11800,%eax
  101733:	76 07                	jbe    10173c <writei+0x7c>
    n = MAXFILE*BSIZE - off;
  101735:	b9 00 18 01 00       	mov    $0x11800,%ecx
  10173a:	29 f1                	sub    %esi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10173c:	85 c9                	test   %ecx,%ecx
  10173e:	0f 84 92 00 00 00    	je     1017d6 <writei+0x116>
  101744:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
  10174b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  10174e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  101751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  101758:	89 f2                	mov    %esi,%edx
  10175a:	89 d8                	mov    %ebx,%eax
  10175c:	c1 ea 09             	shr    $0x9,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10175f:	bf 00 02 00 00       	mov    $0x200,%edi
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  101764:	e8 17 fd ff ff       	call   101480 <bmap>
  101769:	89 44 24 04          	mov    %eax,0x4(%esp)
  10176d:	8b 03                	mov    (%ebx),%eax
  10176f:	89 04 24             	mov    %eax,(%esp)
  101772:	e8 39 e9 ff ff       	call   1000b0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
  101777:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10177a:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
  10177d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
  10177f:	89 f0                	mov    %esi,%eax
  101781:	25 ff 01 00 00       	and    $0x1ff,%eax
  101786:	29 c7                	sub    %eax,%edi
  101788:	39 cf                	cmp    %ecx,%edi
  10178a:	76 02                	jbe    10178e <writei+0xce>
  10178c:	89 cf                	mov    %ecx,%edi
    memmove(bp->data + off%BSIZE, src, m);
  10178e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  101792:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101795:	8d 44 02 18          	lea    0x18(%edx,%eax,1),%eax
  101799:	89 04 24             	mov    %eax,(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  10179c:	01 fe                	add    %edi,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
  10179e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1017a2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1017a5:	e8 66 29 00 00       	call   104110 <memmove>
    bwrite(bp);
  1017aa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1017ad:	89 14 24             	mov    %edx,(%esp)
  1017b0:	e8 cb e8 ff ff       	call   100080 <bwrite>
    brelse(bp);
  1017b5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1017b8:	89 14 24             	mov    %edx,(%esp)
  1017bb:	e8 40 e8 ff ff       	call   100000 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
  1017c0:	01 7d e4             	add    %edi,-0x1c(%ebp)
  1017c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1017c6:	01 7d e0             	add    %edi,-0x20(%ebp)
  1017c9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1017cc:	77 8a                	ja     101758 <writei+0x98>
    memmove(bp->data + off%BSIZE, src, m);
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
  1017ce:	3b 73 18             	cmp    0x18(%ebx),%esi
  1017d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1017d4:	77 07                	ja     1017dd <writei+0x11d>
    ip->size = off;
    iupdate(ip);
  }
  return n;
  1017d6:	89 c8                	mov    %ecx,%eax
  1017d8:	e9 0f ff ff ff       	jmp    1016ec <writei+0x2c>
    bwrite(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
  1017dd:	89 73 18             	mov    %esi,0x18(%ebx)
    iupdate(ip);
  1017e0:	89 1c 24             	mov    %ebx,(%esp)
  1017e3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1017e6:	e8 45 fe ff ff       	call   101630 <iupdate>
  1017eb:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  }
  return n;
  1017ee:	89 c8                	mov    %ecx,%eax
  1017f0:	e9 f7 fe ff ff       	jmp    1016ec <writei+0x2c>
  1017f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1017f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101800 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
  101800:	55                   	push   %ebp
  101801:	89 e5                	mov    %esp,%ebp
  101803:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
  101806:	8b 45 0c             	mov    0xc(%ebp),%eax
  101809:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101810:	00 
  101811:	89 44 24 04          	mov    %eax,0x4(%esp)
  101815:	8b 45 08             	mov    0x8(%ebp),%eax
  101818:	89 04 24             	mov    %eax,(%esp)
  10181b:	e8 60 29 00 00       	call   104180 <strncmp>
}
  101820:	c9                   	leave  
  101821:	c3                   	ret    
  101822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101830 <dirlookup>:
// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  101830:	55                   	push   %ebp
  101831:	89 e5                	mov    %esp,%ebp
  101833:	57                   	push   %edi
  101834:	56                   	push   %esi
  101835:	53                   	push   %ebx
  101836:	83 ec 3c             	sub    $0x3c,%esp
  101839:	8b 45 08             	mov    0x8(%ebp),%eax
  10183c:	8b 55 10             	mov    0x10(%ebp),%edx
  10183f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  101842:	89 45 dc             	mov    %eax,-0x24(%ebp)
  101845:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
  101848:	66 83 78 10 01       	cmpw   $0x1,0x10(%eax)
  10184d:	0f 85 d0 00 00 00    	jne    101923 <dirlookup+0xf3>
    panic("dirlookup not DIR");
  101853:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

  for(off = 0; off < dp->size; off += BSIZE){
  10185a:	8b 48 18             	mov    0x18(%eax),%ecx
  10185d:	85 c9                	test   %ecx,%ecx
  10185f:	0f 84 b4 00 00 00    	je     101919 <dirlookup+0xe9>
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
  101865:	8b 55 e0             	mov    -0x20(%ebp),%edx
  101868:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10186b:	c1 ea 09             	shr    $0x9,%edx
  10186e:	e8 0d fc ff ff       	call   101480 <bmap>
  101873:	89 44 24 04          	mov    %eax,0x4(%esp)
  101877:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10187a:	8b 01                	mov    (%ecx),%eax
  10187c:	89 04 24             	mov    %eax,(%esp)
  10187f:	e8 2c e8 ff ff       	call   1000b0 <bread>
  101884:	89 45 e4             	mov    %eax,-0x1c(%ebp)

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101887:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
    for(de = (struct dirent*)bp->data;
  10188a:	83 c0 18             	add    $0x18,%eax
  10188d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  101890:	89 c6                	mov    %eax,%esi

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// Caller must have already locked dp.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
  101892:	81 c7 18 02 00 00    	add    $0x218,%edi
  101898:	eb 0d                	jmp    1018a7 <dirlookup+0x77>
  10189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
    for(de = (struct dirent*)bp->data;
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
  1018a0:	83 c6 10             	add    $0x10,%esi
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
    bp = bread(dp->dev, bmap(dp, off / BSIZE));
    for(de = (struct dirent*)bp->data;
  1018a3:	39 fe                	cmp    %edi,%esi
  1018a5:	74 51                	je     1018f8 <dirlookup+0xc8>
        de < (struct dirent*)(bp->data + BSIZE);
        de++){
      if(de->inum == 0)
  1018a7:	66 83 3e 00          	cmpw   $0x0,(%esi)
  1018ab:	74 f3                	je     1018a0 <dirlookup+0x70>
        continue;
      if(namecmp(name, de->name) == 0){
  1018ad:	8d 46 02             	lea    0x2(%esi),%eax
  1018b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018b4:	89 1c 24             	mov    %ebx,(%esp)
  1018b7:	e8 44 ff ff ff       	call   101800 <namecmp>
  1018bc:	85 c0                	test   %eax,%eax
  1018be:	75 e0                	jne    1018a0 <dirlookup+0x70>
        // entry matches path element
        if(poff)
  1018c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1018c3:	85 d2                	test   %edx,%edx
  1018c5:	74 0e                	je     1018d5 <dirlookup+0xa5>
          *poff = off + (uchar*)de - bp->data;
  1018c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1018ca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1018cd:	8d 04 16             	lea    (%esi,%edx,1),%eax
  1018d0:	2b 45 d8             	sub    -0x28(%ebp),%eax
  1018d3:	89 01                	mov    %eax,(%ecx)
        inum = de->inum;
        brelse(bp);
  1018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        continue;
      if(namecmp(name, de->name) == 0){
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
  1018d8:	0f b7 1e             	movzwl (%esi),%ebx
        brelse(bp);
  1018db:	89 04 24             	mov    %eax,(%esp)
  1018de:	e8 1d e7 ff ff       	call   100000 <brelse>
        return iget(dp->dev, inum);
  1018e3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1018e6:	89 da                	mov    %ebx,%edx
  1018e8:	8b 01                	mov    (%ecx),%eax
      }
    }
    brelse(bp);
  }
  return 0;
}
  1018ea:	83 c4 3c             	add    $0x3c,%esp
  1018ed:	5b                   	pop    %ebx
  1018ee:	5e                   	pop    %esi
  1018ef:	5f                   	pop    %edi
  1018f0:	5d                   	pop    %ebp
        // entry matches path element
        if(poff)
          *poff = off + (uchar*)de - bp->data;
        inum = de->inum;
        brelse(bp);
        return iget(dp->dev, inum);
  1018f1:	e9 aa f9 ff ff       	jmp    1012a0 <iget>
  1018f6:	66 90                	xchg   %ax,%ax
      }
    }
    brelse(bp);
  1018f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1018fb:	89 04 24             	mov    %eax,(%esp)
  1018fe:	e8 fd e6 ff ff       	call   100000 <brelse>
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += BSIZE){
  101903:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101906:	81 45 e0 00 02 00 00 	addl   $0x200,-0x20(%ebp)
  10190d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  101910:	39 4a 18             	cmp    %ecx,0x18(%edx)
  101913:	0f 87 4c ff ff ff    	ja     101865 <dirlookup+0x35>
      }
    }
    brelse(bp);
  }
  return 0;
}
  101919:	83 c4 3c             	add    $0x3c,%esp
  10191c:	31 c0                	xor    %eax,%eax
  10191e:	5b                   	pop    %ebx
  10191f:	5e                   	pop    %esi
  101920:	5f                   	pop    %edi
  101921:	5d                   	pop    %ebp
  101922:	c3                   	ret    
  uint off, inum;
  struct buf *bp;
  struct dirent *de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
  101923:	c7 04 24 a4 6a 10 00 	movl   $0x106aa4,(%esp)
  10192a:	e8 61 f1 ff ff       	call   100a90 <panic>
  10192f:	90                   	nop

00101930 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  101930:	55                   	push   %ebp
  101931:	89 e5                	mov    %esp,%ebp
  101933:	53                   	push   %ebx
  101934:	83 ec 14             	sub    $0x14,%esp
  101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
  10193a:	85 db                	test   %ebx,%ebx
  10193c:	74 36                	je     101974 <iunlock+0x44>
  10193e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
  101942:	74 30                	je     101974 <iunlock+0x44>
  101944:	8b 43 08             	mov    0x8(%ebx),%eax
  101947:	85 c0                	test   %eax,%eax
  101949:	7e 29                	jle    101974 <iunlock+0x44>
    panic("iunlock");

  acquire(&icache.lock);
  10194b:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101952:	e8 99 26 00 00       	call   103ff0 <acquire>
  ip->flags &= ~I_BUSY;
  101957:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10195b:	89 1c 24             	mov    %ebx,(%esp)
  10195e:	e8 3d 19 00 00       	call   1032a0 <wakeup>
  release(&icache.lock);
  101963:	c7 45 08 c0 b3 10 00 	movl   $0x10b3c0,0x8(%ebp)
}
  10196a:	83 c4 14             	add    $0x14,%esp
  10196d:	5b                   	pop    %ebx
  10196e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  10196f:	e9 2c 26 00 00       	jmp    103fa0 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101974:	c7 04 24 b6 6a 10 00 	movl   $0x106ab6,(%esp)
  10197b:	e8 10 f1 ff ff       	call   100a90 <panic>

00101980 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
  101980:	55                   	push   %ebp
  101981:	89 e5                	mov    %esp,%ebp
  101983:	57                   	push   %edi
  101984:	56                   	push   %esi
  101985:	89 c6                	mov    %eax,%esi
  101987:	53                   	push   %ebx
  101988:	89 d3                	mov    %edx,%ebx
  10198a:	83 ec 2c             	sub    $0x2c,%esp
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  10198d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101991:	89 04 24             	mov    %eax,(%esp)
  101994:	e8 17 e7 ff ff       	call   1000b0 <bread>
  memset(bp->data, 0, BSIZE);
  101999:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  1019a0:	00 
  1019a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1019a8:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;
  
  bp = bread(dev, bno);
  1019a9:	89 c7                	mov    %eax,%edi
  memset(bp->data, 0, BSIZE);
  1019ab:	8d 40 18             	lea    0x18(%eax),%eax
  1019ae:	89 04 24             	mov    %eax,(%esp)
  1019b1:	e8 da 26 00 00       	call   104090 <memset>
  bwrite(bp);
  1019b6:	89 3c 24             	mov    %edi,(%esp)
  1019b9:	e8 c2 e6 ff ff       	call   100080 <bwrite>
  brelse(bp);
  1019be:	89 3c 24             	mov    %edi,(%esp)
  1019c1:	e8 3a e6 ff ff       	call   100000 <brelse>
  struct superblock sb;
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  1019c6:	89 f0                	mov    %esi,%eax
  1019c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1019cb:	e8 90 f9 ff ff       	call   101360 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  1019d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1019d3:	89 da                	mov    %ebx,%edx
  1019d5:	c1 ea 0c             	shr    $0xc,%edx
  1019d8:	89 34 24             	mov    %esi,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
  1019db:	be 01 00 00 00       	mov    $0x1,%esi
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  1019e0:	c1 e8 03             	shr    $0x3,%eax
  1019e3:	8d 44 10 03          	lea    0x3(%eax,%edx,1),%eax
  1019e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019eb:	e8 c0 e6 ff ff       	call   1000b0 <bread>
  bi = b % BPB;
  1019f0:	89 da                	mov    %ebx,%edx
  m = 1 << (bi % 8);
  1019f2:	89 d9                	mov    %ebx,%ecx

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  1019f4:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
  1019fa:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
  1019fd:	c1 fa 03             	sar    $0x3,%edx
  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  101a00:	d3 e6                	shl    %cl,%esi
  if((bp->data[bi/8] & m) == 0)
  101a02:	0f b6 4c 10 18       	movzbl 0x18(%eax,%edx,1),%ecx
  int bi, m;

  bzero(dev, b);

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  101a07:	89 c7                	mov    %eax,%edi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
  101a09:	0f b6 c1             	movzbl %cl,%eax
  101a0c:	85 f0                	test   %esi,%eax
  101a0e:	74 22                	je     101a32 <bfree+0xb2>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;  // Mark block free on disk.
  101a10:	89 f0                	mov    %esi,%eax
  101a12:	f7 d0                	not    %eax
  101a14:	21 c8                	and    %ecx,%eax
  101a16:	88 44 17 18          	mov    %al,0x18(%edi,%edx,1)
  bwrite(bp);
  101a1a:	89 3c 24             	mov    %edi,(%esp)
  101a1d:	e8 5e e6 ff ff       	call   100080 <bwrite>
  brelse(bp);
  101a22:	89 3c 24             	mov    %edi,(%esp)
  101a25:	e8 d6 e5 ff ff       	call   100000 <brelse>
}
  101a2a:	83 c4 2c             	add    $0x2c,%esp
  101a2d:	5b                   	pop    %ebx
  101a2e:	5e                   	pop    %esi
  101a2f:	5f                   	pop    %edi
  101a30:	5d                   	pop    %ebp
  101a31:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb.ninodes));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  101a32:	c7 04 24 be 6a 10 00 	movl   $0x106abe,(%esp)
  101a39:	e8 52 f0 ff ff       	call   100a90 <panic>
  101a3e:	66 90                	xchg   %ax,%ax

00101a40 <iput>:
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
{
  101a40:	55                   	push   %ebp
  101a41:	89 e5                	mov    %esp,%ebp
  101a43:	57                   	push   %edi
  101a44:	56                   	push   %esi
  101a45:	53                   	push   %ebx
  101a46:	83 ec 2c             	sub    $0x2c,%esp
  101a49:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
  101a4c:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101a53:	e8 98 25 00 00       	call   103ff0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
  101a58:	8b 46 08             	mov    0x8(%esi),%eax
  101a5b:	83 f8 01             	cmp    $0x1,%eax
  101a5e:	0f 85 a1 00 00 00    	jne    101b05 <iput+0xc5>
  101a64:	8b 56 0c             	mov    0xc(%esi),%edx
  101a67:	f6 c2 02             	test   $0x2,%dl
  101a6a:	0f 84 95 00 00 00    	je     101b05 <iput+0xc5>
  101a70:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  101a75:	0f 85 8a 00 00 00    	jne    101b05 <iput+0xc5>
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
  101a7b:	f6 c2 01             	test   $0x1,%dl
  101a7e:	66 90                	xchg   %ax,%ax
  101a80:	0f 85 f8 00 00 00    	jne    101b7e <iput+0x13e>
      panic("iput busy");
    ip->flags |= I_BUSY;
  101a86:	83 ca 01             	or     $0x1,%edx
    release(&icache.lock);
  101a89:	89 f3                	mov    %esi,%ebx
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
  101a8b:	89 56 0c             	mov    %edx,0xc(%esi)
  release(&icache.lock);
}

// Caller holds reference to unlocked ip.  Drop reference.
void
iput(struct inode *ip)
  101a8e:	8d 7e 30             	lea    0x30(%esi),%edi
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
  101a91:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101a98:	e8 03 25 00 00       	call   103fa0 <release>
  101a9d:	eb 08                	jmp    101aa7 <iput+0x67>
  101a9f:	90                   	nop
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
  101aa0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101aa3:	39 fb                	cmp    %edi,%ebx
  101aa5:	74 1c                	je     101ac3 <iput+0x83>
    if(ip->addrs[i]){
  101aa7:	8b 53 1c             	mov    0x1c(%ebx),%edx
  101aaa:	85 d2                	test   %edx,%edx
  101aac:	74 f2                	je     101aa0 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
  101aae:	8b 06                	mov    (%esi),%eax
  101ab0:	e8 cb fe ff ff       	call   101980 <bfree>
      ip->addrs[i] = 0;
  101ab5:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
  101abc:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
  101abf:	39 fb                	cmp    %edi,%ebx
  101ac1:	75 e4                	jne    101aa7 <iput+0x67>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
  101ac3:	8b 46 4c             	mov    0x4c(%esi),%eax
  101ac6:	85 c0                	test   %eax,%eax
  101ac8:	75 56                	jne    101b20 <iput+0xe0>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  101aca:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
  101ad1:	89 34 24             	mov    %esi,(%esp)
  101ad4:	e8 57 fb ff ff       	call   101630 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
  101ad9:	66 c7 46 10 00 00    	movw   $0x0,0x10(%esi)
    iupdate(ip);
  101adf:	89 34 24             	mov    %esi,(%esp)
  101ae2:	e8 49 fb ff ff       	call   101630 <iupdate>
    acquire(&icache.lock);
  101ae7:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101aee:	e8 fd 24 00 00       	call   103ff0 <acquire>
    ip->flags = 0;
  101af3:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
  101afa:	89 34 24             	mov    %esi,(%esp)
  101afd:	e8 9e 17 00 00       	call   1032a0 <wakeup>
  101b02:	8b 46 08             	mov    0x8(%esi),%eax
  }
  ip->ref--;
  101b05:	83 e8 01             	sub    $0x1,%eax
  101b08:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
  101b0b:	c7 45 08 c0 b3 10 00 	movl   $0x10b3c0,0x8(%ebp)
}
  101b12:	83 c4 2c             	add    $0x2c,%esp
  101b15:	5b                   	pop    %ebx
  101b16:	5e                   	pop    %esi
  101b17:	5f                   	pop    %edi
  101b18:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
  101b19:	e9 82 24 00 00       	jmp    103fa0 <release>
  101b1e:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b24:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
  101b26:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101b28:	89 04 24             	mov    %eax,(%esp)
  101b2b:	e8 80 e5 ff ff       	call   1000b0 <bread>
    a = (uint*)bp->data;
  101b30:	89 c7                	mov    %eax,%edi
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
  101b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
  101b35:	83 c7 18             	add    $0x18,%edi
  101b38:	31 c0                	xor    %eax,%eax
  101b3a:	eb 11                	jmp    101b4d <iput+0x10d>
  101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(j = 0; j < NINDIRECT; j++){
  101b40:	83 c3 01             	add    $0x1,%ebx
  101b43:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  101b49:	89 d8                	mov    %ebx,%eax
  101b4b:	74 10                	je     101b5d <iput+0x11d>
      if(a[j])
  101b4d:	8b 14 87             	mov    (%edi,%eax,4),%edx
  101b50:	85 d2                	test   %edx,%edx
  101b52:	74 ec                	je     101b40 <iput+0x100>
        bfree(ip->dev, a[j]);
  101b54:	8b 06                	mov    (%esi),%eax
  101b56:	e8 25 fe ff ff       	call   101980 <bfree>
  101b5b:	eb e3                	jmp    101b40 <iput+0x100>
    }
    brelse(bp);
  101b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101b60:	89 04 24             	mov    %eax,(%esp)
  101b63:	e8 98 e4 ff ff       	call   100000 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
  101b68:	8b 56 4c             	mov    0x4c(%esi),%edx
  101b6b:	8b 06                	mov    (%esi),%eax
  101b6d:	e8 0e fe ff ff       	call   101980 <bfree>
    ip->addrs[NDIRECT] = 0;
  101b72:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  101b79:	e9 4c ff ff ff       	jmp    101aca <iput+0x8a>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode is no longer used: truncate and free inode.
    if(ip->flags & I_BUSY)
      panic("iput busy");
  101b7e:	c7 04 24 d1 6a 10 00 	movl   $0x106ad1,(%esp)
  101b85:	e8 06 ef ff ff       	call   100a90 <panic>
  101b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00101b90 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
  101b90:	55                   	push   %ebp
  101b91:	89 e5                	mov    %esp,%ebp
  101b93:	57                   	push   %edi
  101b94:	56                   	push   %esi
  101b95:	53                   	push   %ebx
  101b96:	83 ec 2c             	sub    $0x2c,%esp
  101b99:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
  101b9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  101b9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101ba6:	00 
  101ba7:	89 34 24             	mov    %esi,(%esp)
  101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bae:	e8 7d fc ff ff       	call   101830 <dirlookup>
  101bb3:	85 c0                	test   %eax,%eax
  101bb5:	0f 85 89 00 00 00    	jne    101c44 <dirlink+0xb4>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101bbb:	8b 56 18             	mov    0x18(%esi),%edx
  101bbe:	85 d2                	test   %edx,%edx
  101bc0:	0f 84 8d 00 00 00    	je     101c53 <dirlink+0xc3>
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
    return -1;
  101bc6:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101bc9:	31 db                	xor    %ebx,%ebx
  101bcb:	eb 0b                	jmp    101bd8 <dirlink+0x48>
  101bcd:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101bd0:	83 c3 10             	add    $0x10,%ebx
  101bd3:	39 5e 18             	cmp    %ebx,0x18(%esi)
  101bd6:	76 24                	jbe    101bfc <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101bd8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101bdf:	00 
  101be0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101be4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101be8:	89 34 24             	mov    %esi,(%esp)
  101beb:	e8 40 f9 ff ff       	call   101530 <readi>
  101bf0:	83 f8 10             	cmp    $0x10,%eax
  101bf3:	75 65                	jne    101c5a <dirlink+0xca>
      panic("dirlink read");
    if(de.inum == 0)
  101bf5:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
  101bfa:	75 d4                	jne    101bd0 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  101bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  101bff:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101c06:	00 
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	8d 45 da             	lea    -0x26(%ebp),%eax
  101c0e:	89 04 24             	mov    %eax,(%esp)
  101c11:	e8 ca 25 00 00       	call   1041e0 <strncpy>
  de.inum = inum;
  101c16:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101c19:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  101c20:	00 
  101c21:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  101c25:	89 7c 24 04          	mov    %edi,0x4(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  101c29:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  101c2d:	89 34 24             	mov    %esi,(%esp)
  101c30:	e8 8b fa ff ff       	call   1016c0 <writei>
  101c35:	83 f8 10             	cmp    $0x10,%eax
  101c38:	75 2c                	jne    101c66 <dirlink+0xd6>
    panic("dirlink");
  101c3a:	31 c0                	xor    %eax,%eax
  
  return 0;
}
  101c3c:	83 c4 2c             	add    $0x2c,%esp
  101c3f:	5b                   	pop    %ebx
  101c40:	5e                   	pop    %esi
  101c41:	5f                   	pop    %edi
  101c42:	5d                   	pop    %ebp
  101c43:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
  101c44:	89 04 24             	mov    %eax,(%esp)
  101c47:	e8 f4 fd ff ff       	call   101a40 <iput>
  101c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  101c51:	eb e9                	jmp    101c3c <dirlink+0xac>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
  101c53:	8d 7d d8             	lea    -0x28(%ebp),%edi
  101c56:	31 db                	xor    %ebx,%ebx
  101c58:	eb a2                	jmp    101bfc <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
  101c5a:	c7 04 24 db 6a 10 00 	movl   $0x106adb,(%esp)
  101c61:	e8 2a ee ff ff       	call   100a90 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101c66:	c7 04 24 a6 70 10 00 	movl   $0x1070a6,(%esp)
  101c6d:	e8 1e ee ff ff       	call   100a90 <panic>
  101c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101c80 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  101c80:	55                   	push   %ebp
  101c81:	89 e5                	mov    %esp,%ebp
  101c83:	53                   	push   %ebx
  101c84:	83 ec 14             	sub    $0x14,%esp
  101c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
  101c8a:	89 1c 24             	mov    %ebx,(%esp)
  101c8d:	e8 9e fc ff ff       	call   101930 <iunlock>
  iput(ip);
  101c92:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  101c95:	83 c4 14             	add    $0x14,%esp
  101c98:	5b                   	pop    %ebx
  101c99:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
  101c9a:	e9 a1 fd ff ff       	jmp    101a40 <iput>
  101c9f:	90                   	nop

00101ca0 <ialloc>:
static struct inode* iget(uint dev, uint inum);

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101ca0:	55                   	push   %ebp
  101ca1:	89 e5                	mov    %esp,%ebp
  101ca3:	57                   	push   %edi
  101ca4:	56                   	push   %esi
  101ca5:	53                   	push   %ebx
  101ca6:	83 ec 3c             	sub    $0x3c,%esp
  101ca9:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101cad:	8d 55 dc             	lea    -0x24(%ebp),%edx
static struct inode* iget(uint dev, uint inum);

// Allocate a new inode with the given type on device dev.
struct inode*
ialloc(uint dev, short type)
{
  101cb0:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  101cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb7:	e8 a4 f6 ff ff       	call   101360 <readsb>
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101cbc:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  101cc0:	0f 86 96 00 00 00    	jbe    101d5c <ialloc+0xbc>
  101cc6:	be 01 00 00 00       	mov    $0x1,%esi
  101ccb:	bb 01 00 00 00       	mov    $0x1,%ebx
  101cd0:	eb 18                	jmp    101cea <ialloc+0x4a>
  101cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101cd8:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101cdb:	89 3c 24             	mov    %edi,(%esp)
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101cde:	89 de                	mov    %ebx,%esi
      dip->type = type;
      bwrite(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  101ce0:	e8 1b e3 ff ff       	call   100000 <brelse>
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
  for(inum = 1; inum < sb.ninodes; inum++){  // loop over inode blocks
  101ce5:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  101ce8:	76 72                	jbe    101d5c <ialloc+0xbc>
    bp = bread(dev, IBLOCK(inum));
  101cea:	89 f0                	mov    %esi,%eax
  101cec:	c1 e8 03             	shr    $0x3,%eax
  101cef:	83 c0 02             	add    $0x2,%eax
  101cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf9:	89 04 24             	mov    %eax,(%esp)
  101cfc:	e8 af e3 ff ff       	call   1000b0 <bread>
  101d01:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
  101d03:	89 f0                	mov    %esi,%eax
  101d05:	83 e0 07             	and    $0x7,%eax
  101d08:	c1 e0 06             	shl    $0x6,%eax
  101d0b:	8d 54 07 18          	lea    0x18(%edi,%eax,1),%edx
    if(dip->type == 0){  // a free inode
  101d0f:	66 83 3a 00          	cmpw   $0x0,(%edx)
  101d13:	75 c3                	jne    101cd8 <ialloc+0x38>
      memset(dip, 0, sizeof(*dip));
  101d15:	89 14 24             	mov    %edx,(%esp)
  101d18:	89 55 d0             	mov    %edx,-0x30(%ebp)
  101d1b:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
  101d22:	00 
  101d23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  101d2a:	00 
  101d2b:	e8 60 23 00 00       	call   104090 <memset>
      dip->type = type;
  101d30:	8b 55 d0             	mov    -0x30(%ebp),%edx
  101d33:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101d37:	66 89 02             	mov    %ax,(%edx)
      bwrite(bp);   // mark it allocated on the disk
  101d3a:	89 3c 24             	mov    %edi,(%esp)
  101d3d:	e8 3e e3 ff ff       	call   100080 <bwrite>
      brelse(bp);
  101d42:	89 3c 24             	mov    %edi,(%esp)
  101d45:	e8 b6 e2 ff ff       	call   100000 <brelse>
      return iget(dev, inum);
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	89 f2                	mov    %esi,%edx
  101d4f:	e8 4c f5 ff ff       	call   1012a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
  101d54:	83 c4 3c             	add    $0x3c,%esp
  101d57:	5b                   	pop    %ebx
  101d58:	5e                   	pop    %esi
  101d59:	5f                   	pop    %edi
  101d5a:	5d                   	pop    %ebp
  101d5b:	c3                   	ret    
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
  101d5c:	c7 04 24 e8 6a 10 00 	movl   $0x106ae8,(%esp)
  101d63:	e8 28 ed ff ff       	call   100a90 <panic>
  101d68:	90                   	nop
  101d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00101d70 <ilock>:
}

// Lock the given inode.
void
ilock(struct inode *ip)
{
  101d70:	55                   	push   %ebp
  101d71:	89 e5                	mov    %esp,%ebp
  101d73:	56                   	push   %esi
  101d74:	53                   	push   %ebx
  101d75:	83 ec 10             	sub    $0x10,%esp
  101d78:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
  101d7b:	85 db                	test   %ebx,%ebx
  101d7d:	0f 84 e5 00 00 00    	je     101e68 <ilock+0xf8>
  101d83:	8b 4b 08             	mov    0x8(%ebx),%ecx
  101d86:	85 c9                	test   %ecx,%ecx
  101d88:	0f 8e da 00 00 00    	jle    101e68 <ilock+0xf8>
    panic("ilock");

  acquire(&icache.lock);
  101d8e:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101d95:	e8 56 22 00 00       	call   103ff0 <acquire>
  while(ip->flags & I_BUSY)
  101d9a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101d9d:	a8 01                	test   $0x1,%al
  101d9f:	74 1e                	je     101dbf <ilock+0x4f>
  101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101da8:	c7 44 24 04 c0 b3 10 	movl   $0x10b3c0,0x4(%esp)
  101daf:	00 
  101db0:	89 1c 24             	mov    %ebx,(%esp)
  101db3:	e8 48 16 00 00       	call   103400 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
  101db8:	8b 43 0c             	mov    0xc(%ebx),%eax
  101dbb:	a8 01                	test   $0x1,%al
  101dbd:	75 e9                	jne    101da8 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  101dbf:	83 c8 01             	or     $0x1,%eax
  101dc2:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
  101dc5:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  101dcc:	e8 cf 21 00 00       	call   103fa0 <release>

  if(!(ip->flags & I_VALID)){
  101dd1:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
  101dd5:	74 09                	je     101de0 <ilock+0x70>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
  101dd7:	83 c4 10             	add    $0x10,%esp
  101dda:	5b                   	pop    %ebx
  101ddb:	5e                   	pop    %esi
  101ddc:	5d                   	pop    %ebp
  101ddd:	c3                   	ret    
  101dde:	66 90                	xchg   %ax,%ax
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum));
  101de0:	8b 43 04             	mov    0x4(%ebx),%eax
  101de3:	c1 e8 03             	shr    $0x3,%eax
  101de6:	83 c0 02             	add    $0x2,%eax
  101de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ded:	8b 03                	mov    (%ebx),%eax
  101def:	89 04 24             	mov    %eax,(%esp)
  101df2:	e8 b9 e2 ff ff       	call   1000b0 <bread>
  101df7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
  101df9:	8b 43 04             	mov    0x4(%ebx),%eax
  101dfc:	83 e0 07             	and    $0x7,%eax
  101dff:	c1 e0 06             	shl    $0x6,%eax
  101e02:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
  101e06:	0f b7 10             	movzwl (%eax),%edx
  101e09:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
  101e0d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
  101e11:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
  101e15:	0f b7 50 04          	movzwl 0x4(%eax),%edx
  101e19:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
  101e1d:	0f b7 50 06          	movzwl 0x6(%eax),%edx
  101e21:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
  101e25:	8b 50 08             	mov    0x8(%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101e28:	83 c0 0c             	add    $0xc,%eax
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
  101e2b:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
  101e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e32:	8d 43 1c             	lea    0x1c(%ebx),%eax
  101e35:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
  101e3c:	00 
  101e3d:	89 04 24             	mov    %eax,(%esp)
  101e40:	e8 cb 22 00 00       	call   104110 <memmove>
    brelse(bp);
  101e45:	89 34 24             	mov    %esi,(%esp)
  101e48:	e8 b3 e1 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101e4d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  101e51:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  101e56:	0f 85 7b ff ff ff    	jne    101dd7 <ilock+0x67>
      panic("ilock: no type");
  101e5c:	c7 04 24 00 6b 10 00 	movl   $0x106b00,(%esp)
  101e63:	e8 28 ec ff ff       	call   100a90 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101e68:	c7 04 24 fa 6a 10 00 	movl   $0x106afa,(%esp)
  101e6f:	e8 1c ec ff ff       	call   100a90 <panic>
  101e74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101e7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00101e80 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  101e80:	55                   	push   %ebp
  101e81:	89 e5                	mov    %esp,%ebp
  101e83:	57                   	push   %edi
  101e84:	56                   	push   %esi
  101e85:	53                   	push   %ebx
  101e86:	89 c3                	mov    %eax,%ebx
  101e88:	83 ec 2c             	sub    $0x2c,%esp
  101e8b:	89 55 e0             	mov    %edx,-0x20(%ebp)
  101e8e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
  101e91:	80 38 2f             	cmpb   $0x2f,(%eax)
  101e94:	0f 84 14 01 00 00    	je     101fae <namex+0x12e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
  101e9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  101ea0:	8b 40 68             	mov    0x68(%eax),%eax
  101ea3:	89 04 24             	mov    %eax,(%esp)
  101ea6:	e8 c5 f3 ff ff       	call   101270 <idup>
  101eab:	89 c7                	mov    %eax,%edi
  101ead:	eb 04                	jmp    101eb3 <namex+0x33>
  101eaf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  101eb0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
  101eb3:	0f b6 03             	movzbl (%ebx),%eax
  101eb6:	3c 2f                	cmp    $0x2f,%al
  101eb8:	74 f6                	je     101eb0 <namex+0x30>
    path++;
  if(*path == 0)
  101eba:	84 c0                	test   %al,%al
  101ebc:	75 1a                	jne    101ed8 <namex+0x58>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
  101ebe:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  101ec1:	85 db                	test   %ebx,%ebx
  101ec3:	0f 85 0d 01 00 00    	jne    101fd6 <namex+0x156>
    iput(ip);
    return 0;
  }
  return ip;
}
  101ec9:	83 c4 2c             	add    $0x2c,%esp
  101ecc:	89 f8                	mov    %edi,%eax
  101ece:	5b                   	pop    %ebx
  101ecf:	5e                   	pop    %esi
  101ed0:	5f                   	pop    %edi
  101ed1:	5d                   	pop    %ebp
  101ed2:	c3                   	ret    
  101ed3:	90                   	nop
  101ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101ed8:	3c 2f                	cmp    $0x2f,%al
  101eda:	0f 84 94 00 00 00    	je     101f74 <namex+0xf4>
  101ee0:	89 de                	mov    %ebx,%esi
  101ee2:	eb 08                	jmp    101eec <namex+0x6c>
  101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101ee8:	3c 2f                	cmp    $0x2f,%al
  101eea:	74 0a                	je     101ef6 <namex+0x76>
    path++;
  101eec:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
  101eef:	0f b6 06             	movzbl (%esi),%eax
  101ef2:	84 c0                	test   %al,%al
  101ef4:	75 f2                	jne    101ee8 <namex+0x68>
  101ef6:	89 f2                	mov    %esi,%edx
  101ef8:	29 da                	sub    %ebx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
  101efa:	83 fa 0d             	cmp    $0xd,%edx
  101efd:	7e 79                	jle    101f78 <namex+0xf8>
    memmove(name, s, DIRSIZ);
  101eff:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
  101f06:	00 
  101f07:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f0e:	89 04 24             	mov    %eax,(%esp)
  101f11:	e8 fa 21 00 00       	call   104110 <memmove>
  101f16:	eb 03                	jmp    101f1b <namex+0x9b>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  101f18:	83 c6 01             	add    $0x1,%esi
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101f1b:	80 3e 2f             	cmpb   $0x2f,(%esi)
  101f1e:	74 f8                	je     101f18 <namex+0x98>
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
  101f20:	85 f6                	test   %esi,%esi
  101f22:	74 9a                	je     101ebe <namex+0x3e>
    ilock(ip);
  101f24:	89 3c 24             	mov    %edi,(%esp)
  101f27:	e8 44 fe ff ff       	call   101d70 <ilock>
    if(ip->type != T_DIR){
  101f2c:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
  101f31:	75 67                	jne    101f9a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
  101f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  101f36:	85 c0                	test   %eax,%eax
  101f38:	74 0c                	je     101f46 <namex+0xc6>
  101f3a:	80 3e 00             	cmpb   $0x0,(%esi)
  101f3d:	8d 76 00             	lea    0x0(%esi),%esi
  101f40:	0f 84 7e 00 00 00    	je     101fc4 <namex+0x144>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
  101f46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  101f4d:	00 
  101f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f51:	89 3c 24             	mov    %edi,(%esp)
  101f54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101f58:	e8 d3 f8 ff ff       	call   101830 <dirlookup>
  101f5d:	85 c0                	test   %eax,%eax
  101f5f:	89 c3                	mov    %eax,%ebx
  101f61:	74 37                	je     101f9a <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
  101f63:	89 3c 24             	mov    %edi,(%esp)
  101f66:	89 df                	mov    %ebx,%edi
  101f68:	89 f3                	mov    %esi,%ebx
  101f6a:	e8 11 fd ff ff       	call   101c80 <iunlockput>
  101f6f:	e9 3f ff ff ff       	jmp    101eb3 <namex+0x33>
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
  101f74:	89 de                	mov    %ebx,%esi
  101f76:	31 d2                	xor    %edx,%edx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
  101f78:	89 54 24 08          	mov    %edx,0x8(%esp)
  101f7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  101f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f83:	89 04 24             	mov    %eax,(%esp)
  101f86:	89 55 dc             	mov    %edx,-0x24(%ebp)
  101f89:	e8 82 21 00 00       	call   104110 <memmove>
    name[len] = 0;
  101f8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  101f91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  101f94:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
  101f98:	eb 81                	jmp    101f1b <namex+0x9b>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
  101f9a:	89 3c 24             	mov    %edi,(%esp)
  101f9d:	31 ff                	xor    %edi,%edi
  101f9f:	e8 dc fc ff ff       	call   101c80 <iunlockput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101fa4:	83 c4 2c             	add    $0x2c,%esp
  101fa7:	89 f8                	mov    %edi,%eax
  101fa9:	5b                   	pop    %ebx
  101faa:	5e                   	pop    %esi
  101fab:	5f                   	pop    %edi
  101fac:	5d                   	pop    %ebp
  101fad:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  101fae:	ba 01 00 00 00       	mov    $0x1,%edx
  101fb3:	b8 01 00 00 00       	mov    $0x1,%eax
  101fb8:	e8 e3 f2 ff ff       	call   1012a0 <iget>
  101fbd:	89 c7                	mov    %eax,%edi
  101fbf:	e9 ef fe ff ff       	jmp    101eb3 <namex+0x33>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
  101fc4:	89 3c 24             	mov    %edi,(%esp)
  101fc7:	e8 64 f9 ff ff       	call   101930 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
  101fcc:	83 c4 2c             	add    $0x2c,%esp
  101fcf:	89 f8                	mov    %edi,%eax
  101fd1:	5b                   	pop    %ebx
  101fd2:	5e                   	pop    %esi
  101fd3:	5f                   	pop    %edi
  101fd4:	5d                   	pop    %ebp
  101fd5:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
  101fd6:	89 3c 24             	mov    %edi,(%esp)
  101fd9:	31 ff                	xor    %edi,%edi
  101fdb:	e8 60 fa ff ff       	call   101a40 <iput>
    return 0;
  101fe0:	e9 e4 fe ff ff       	jmp    101ec9 <namex+0x49>
  101fe5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00101ff0 <nameiparent>:
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101ff0:	55                   	push   %ebp
  return namex(path, 1, name);
  101ff1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  101ff6:	89 e5                	mov    %esp,%ebp
  101ff8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
  101ffb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  101ffe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102001:	c9                   	leave  
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
  102002:	e9 79 fe ff ff       	jmp    101e80 <namex>
  102007:	89 f6                	mov    %esi,%esi
  102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102010 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
  102010:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
  102011:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
  102013:	89 e5                	mov    %esp,%ebp
  102015:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
  102018:	8b 45 08             	mov    0x8(%ebp),%eax
  10201b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
  10201e:	e8 5d fe ff ff       	call   101e80 <namex>
}
  102023:	c9                   	leave  
  102024:	c3                   	ret    
  102025:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102030 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
  102030:	55                   	push   %ebp
  102031:	89 e5                	mov    %esp,%ebp
  102033:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
  102036:	c7 44 24 04 0f 6b 10 	movl   $0x106b0f,0x4(%esp)
  10203d:	00 
  10203e:	c7 04 24 c0 b3 10 00 	movl   $0x10b3c0,(%esp)
  102045:	e8 16 1e 00 00       	call   103e60 <initlock>
}
  10204a:	c9                   	leave  
  10204b:	c3                   	ret    
  10204c:	90                   	nop
  10204d:	90                   	nop
  10204e:	90                   	nop
  10204f:	90                   	nop

00102050 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  102050:	55                   	push   %ebp
  102051:	89 e5                	mov    %esp,%ebp
  102053:	56                   	push   %esi
  102054:	89 c6                	mov    %eax,%esi
  102056:	83 ec 14             	sub    $0x14,%esp
  if(b == 0)
  102059:	85 c0                	test   %eax,%eax
  10205b:	0f 84 8d 00 00 00    	je     1020ee <idestart+0x9e>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102061:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102066:	66 90                	xchg   %ax,%ax
  102068:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  102069:	25 c0 00 00 00       	and    $0xc0,%eax
  10206e:	83 f8 40             	cmp    $0x40,%eax
  102071:	75 f5                	jne    102068 <idestart+0x18>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102073:	ba f6 03 00 00       	mov    $0x3f6,%edx
  102078:	31 c0                	xor    %eax,%eax
  10207a:	ee                   	out    %al,(%dx)
  10207b:	ba f2 01 00 00       	mov    $0x1f2,%edx
  102080:	b8 01 00 00 00       	mov    $0x1,%eax
  102085:	ee                   	out    %al,(%dx)
    panic("idestart");

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, 1);  // number of sectors
  outb(0x1f3, b->sector & 0xff);
  102086:	8b 4e 08             	mov    0x8(%esi),%ecx
  102089:	b2 f3                	mov    $0xf3,%dl
  10208b:	89 c8                	mov    %ecx,%eax
  10208d:	ee                   	out    %al,(%dx)
  10208e:	89 c8                	mov    %ecx,%eax
  102090:	b2 f4                	mov    $0xf4,%dl
  102092:	c1 e8 08             	shr    $0x8,%eax
  102095:	ee                   	out    %al,(%dx)
  102096:	89 c8                	mov    %ecx,%eax
  102098:	b2 f5                	mov    $0xf5,%dl
  10209a:	c1 e8 10             	shr    $0x10,%eax
  10209d:	ee                   	out    %al,(%dx)
  10209e:	8b 46 04             	mov    0x4(%esi),%eax
  1020a1:	c1 e9 18             	shr    $0x18,%ecx
  1020a4:	b2 f6                	mov    $0xf6,%dl
  1020a6:	83 e1 0f             	and    $0xf,%ecx
  1020a9:	83 e0 01             	and    $0x1,%eax
  1020ac:	c1 e0 04             	shl    $0x4,%eax
  1020af:	09 c8                	or     %ecx,%eax
  1020b1:	83 c8 e0             	or     $0xffffffe0,%eax
  1020b4:	ee                   	out    %al,(%dx)
  outb(0x1f4, (b->sector >> 8) & 0xff);
  outb(0x1f5, (b->sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
  1020b5:	f6 06 04             	testb  $0x4,(%esi)
  1020b8:	75 16                	jne    1020d0 <idestart+0x80>
  1020ba:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1020bf:	b8 20 00 00 00       	mov    $0x20,%eax
  1020c4:	ee                   	out    %al,(%dx)
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, 512/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
  1020c5:	83 c4 14             	add    $0x14,%esp
  1020c8:	5e                   	pop    %esi
  1020c9:	5d                   	pop    %ebp
  1020ca:	c3                   	ret    
  1020cb:	90                   	nop
  1020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1020d0:	b2 f7                	mov    $0xf7,%dl
  1020d2:	b8 30 00 00 00       	mov    $0x30,%eax
  1020d7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
  1020d8:	b9 80 00 00 00       	mov    $0x80,%ecx
  1020dd:	83 c6 18             	add    $0x18,%esi
  1020e0:	ba f0 01 00 00       	mov    $0x1f0,%edx
  1020e5:	fc                   	cld    
  1020e6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  1020e8:	83 c4 14             	add    $0x14,%esp
  1020eb:	5e                   	pop    %esi
  1020ec:	5d                   	pop    %ebp
  1020ed:	c3                   	ret    
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  1020ee:	c7 04 24 16 6b 10 00 	movl   $0x106b16,(%esp)
  1020f5:	e8 96 e9 ff ff       	call   100a90 <panic>
  1020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00102100 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
  102100:	55                   	push   %ebp
  102101:	89 e5                	mov    %esp,%ebp
  102103:	53                   	push   %ebx
  102104:	83 ec 14             	sub    $0x14,%esp
  102107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
  10210a:	8b 03                	mov    (%ebx),%eax
  10210c:	a8 01                	test   $0x1,%al
  10210e:	0f 84 90 00 00 00    	je     1021a4 <iderw+0xa4>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
  102114:	83 e0 06             	and    $0x6,%eax
  102117:	83 f8 02             	cmp    $0x2,%eax
  10211a:	0f 84 9c 00 00 00    	je     1021bc <iderw+0xbc>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
  102120:	8b 53 04             	mov    0x4(%ebx),%edx
  102123:	85 d2                	test   %edx,%edx
  102125:	74 0d                	je     102134 <iderw+0x34>
  102127:	a1 98 91 10 00       	mov    0x109198,%eax
  10212c:	85 c0                	test   %eax,%eax
  10212e:	0f 84 7c 00 00 00    	je     1021b0 <iderw+0xb0>
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);
  102134:	c7 04 24 60 91 10 00 	movl   $0x109160,(%esp)
  10213b:	e8 b0 1e 00 00       	call   103ff0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  102140:	ba 94 91 10 00       	mov    $0x109194,%edx
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);

  // Append b to idequeue.
  b->qnext = 0;
  102145:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  10214c:	a1 94 91 10 00       	mov    0x109194,%eax
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  102151:	85 c0                	test   %eax,%eax
  102153:	74 0d                	je     102162 <iderw+0x62>
  102155:	8d 76 00             	lea    0x0(%esi),%esi
  102158:	8d 50 14             	lea    0x14(%eax),%edx
  10215b:	8b 40 14             	mov    0x14(%eax),%eax
  10215e:	85 c0                	test   %eax,%eax
  102160:	75 f6                	jne    102158 <iderw+0x58>
    ;
  *pp = b;
  102162:	89 1a                	mov    %ebx,(%edx)
  
  // Start disk if necessary.
  if(idequeue == b)
  102164:	39 1d 94 91 10 00    	cmp    %ebx,0x109194
  10216a:	75 14                	jne    102180 <iderw+0x80>
  10216c:	eb 2d                	jmp    10219b <iderw+0x9b>
  10216e:	66 90                	xchg   %ax,%ax
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
    sleep(b, &idelock);
  102170:	c7 44 24 04 60 91 10 	movl   $0x109160,0x4(%esp)
  102177:	00 
  102178:	89 1c 24             	mov    %ebx,(%esp)
  10217b:	e8 80 12 00 00       	call   103400 <sleep>
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
  102180:	8b 03                	mov    (%ebx),%eax
  102182:	83 e0 06             	and    $0x6,%eax
  102185:	83 f8 02             	cmp    $0x2,%eax
  102188:	75 e6                	jne    102170 <iderw+0x70>
    sleep(b, &idelock);
  }

  release(&idelock);
  10218a:	c7 45 08 60 91 10 00 	movl   $0x109160,0x8(%ebp)
}
  102191:	83 c4 14             	add    $0x14,%esp
  102194:	5b                   	pop    %ebx
  102195:	5d                   	pop    %ebp
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
    sleep(b, &idelock);
  }

  release(&idelock);
  102196:	e9 05 1e 00 00       	jmp    103fa0 <release>
    ;
  *pp = b;
  
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  10219b:	89 d8                	mov    %ebx,%eax
  10219d:	e8 ae fe ff ff       	call   102050 <idestart>
  1021a2:	eb dc                	jmp    102180 <iderw+0x80>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  1021a4:	c7 04 24 1f 6b 10 00 	movl   $0x106b1f,(%esp)
  1021ab:	e8 e0 e8 ff ff       	call   100a90 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("idrw: ide disk 1 not present");
  1021b0:	c7 04 24 48 6b 10 00 	movl   $0x106b48,(%esp)
  1021b7:	e8 d4 e8 ff ff       	call   100a90 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  1021bc:	c7 04 24 33 6b 10 00 	movl   $0x106b33,(%esp)
  1021c3:	e8 c8 e8 ff ff       	call   100a90 <panic>
  1021c8:	90                   	nop
  1021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001021d0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
  1021d0:	55                   	push   %ebp
  1021d1:	89 e5                	mov    %esp,%ebp
  1021d3:	57                   	push   %edi
  1021d4:	53                   	push   %ebx
  1021d5:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  // Take first buffer off queue.
  acquire(&idelock);
  1021d8:	c7 04 24 60 91 10 00 	movl   $0x109160,(%esp)
  1021df:	e8 0c 1e 00 00       	call   103ff0 <acquire>
  if((b = idequeue) == 0){
  1021e4:	8b 1d 94 91 10 00    	mov    0x109194,%ebx
  1021ea:	85 db                	test   %ebx,%ebx
  1021ec:	74 7a                	je     102268 <ideintr+0x98>
    release(&idelock);
    cprintf("Spurious IDE interrupt.\n");
    return;
  }
  idequeue = b->qnext;
  1021ee:	8b 43 14             	mov    0x14(%ebx),%eax
  1021f1:	a3 94 91 10 00       	mov    %eax,0x109194

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
  1021f6:	8b 0b                	mov    (%ebx),%ecx
  1021f8:	f6 c1 04             	test   $0x4,%cl
  1021fb:	74 33                	je     102230 <ideintr+0x60>
    insl(0x1f0, b->data, 512/4);
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
  1021fd:	83 c9 02             	or     $0x2,%ecx
  102200:	83 e1 fb             	and    $0xfffffffb,%ecx
  102203:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
  102205:	89 1c 24             	mov    %ebx,(%esp)
  102208:	e8 93 10 00 00       	call   1032a0 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
  10220d:	a1 94 91 10 00       	mov    0x109194,%eax
  102212:	85 c0                	test   %eax,%eax
  102214:	74 05                	je     10221b <ideintr+0x4b>
    idestart(idequeue);
  102216:	e8 35 fe ff ff       	call   102050 <idestart>

  release(&idelock);
  10221b:	c7 04 24 60 91 10 00 	movl   $0x109160,(%esp)
  102222:	e8 79 1d 00 00       	call   103fa0 <release>
}
  102227:	83 c4 10             	add    $0x10,%esp
  10222a:	5b                   	pop    %ebx
  10222b:	5f                   	pop    %edi
  10222c:	5d                   	pop    %ebp
  10222d:	c3                   	ret    
  10222e:	66 90                	xchg   %ax,%ax
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102230:	ba f7 01 00 00       	mov    $0x1f7,%edx
  102235:	8d 76 00             	lea    0x0(%esi),%esi
  102238:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  102239:	0f b6 c0             	movzbl %al,%eax
  10223c:	89 c7                	mov    %eax,%edi
  10223e:	81 e7 c0 00 00 00    	and    $0xc0,%edi
  102244:	83 ff 40             	cmp    $0x40,%edi
  102247:	75 ef                	jne    102238 <ideintr+0x68>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
  102249:	a8 21                	test   $0x21,%al
  10224b:	75 b0                	jne    1021fd <ideintr+0x2d>
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
  10224d:	8d 7b 18             	lea    0x18(%ebx),%edi
  102250:	b9 80 00 00 00       	mov    $0x80,%ecx
  102255:	ba f0 01 00 00       	mov    $0x1f0,%edx
  10225a:	fc                   	cld    
  10225b:	f3 6d                	rep insl (%dx),%es:(%edi)
  10225d:	8b 0b                	mov    (%ebx),%ecx
  10225f:	eb 9c                	jmp    1021fd <ideintr+0x2d>
  102261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct buf *b;

  // Take first buffer off queue.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
  102268:	c7 04 24 60 91 10 00 	movl   $0x109160,(%esp)
  10226f:	e8 2c 1d 00 00       	call   103fa0 <release>
    cprintf("Spurious IDE interrupt.\n");
  102274:	c7 04 24 65 6b 10 00 	movl   $0x106b65,(%esp)
  10227b:	e8 40 e2 ff ff       	call   1004c0 <cprintf>
    return;
  102280:	eb a5                	jmp    102227 <ideintr+0x57>
  102282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102290 <ideinit>:
  return 0;
}

void
ideinit(void)
{
  102290:	55                   	push   %ebp
  102291:	89 e5                	mov    %esp,%ebp
  102293:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
  102296:	c7 44 24 04 7e 6b 10 	movl   $0x106b7e,0x4(%esp)
  10229d:	00 
  10229e:	c7 04 24 60 91 10 00 	movl   $0x109160,(%esp)
  1022a5:	e8 b6 1b 00 00       	call   103e60 <initlock>
  picenable(IRQ_IDE);
  1022aa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022b1:	e8 aa 0a 00 00       	call   102d60 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
  1022b6:	a1 e0 c9 10 00       	mov    0x10c9e0,%eax
  1022bb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022c2:	83 e8 01             	sub    $0x1,%eax
  1022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1022c9:	e8 52 00 00 00       	call   102320 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1022ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
  1022d3:	90                   	nop
  1022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1022d8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
  1022d9:	25 c0 00 00 00       	and    $0xc0,%eax
  1022de:	83 f8 40             	cmp    $0x40,%eax
  1022e1:	75 f5                	jne    1022d8 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1022e3:	ba f6 01 00 00       	mov    $0x1f6,%edx
  1022e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  1022ed:	ee                   	out    %al,(%dx)
  1022ee:	31 c9                	xor    %ecx,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1022f0:	b2 f7                	mov    $0xf7,%dl
  1022f2:	eb 0f                	jmp    102303 <ideinit+0x73>
  1022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
  1022f8:	83 c1 01             	add    $0x1,%ecx
  1022fb:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  102301:	74 0f                	je     102312 <ideinit+0x82>
  102303:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
  102304:	84 c0                	test   %al,%al
  102306:	74 f0                	je     1022f8 <ideinit+0x68>
      havedisk1 = 1;
  102308:	c7 05 98 91 10 00 01 	movl   $0x1,0x109198
  10230f:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102312:	ba f6 01 00 00       	mov    $0x1f6,%edx
  102317:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  10231c:	ee                   	out    %al,(%dx)
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
  10231d:	c9                   	leave  
  10231e:	c3                   	ret    
  10231f:	90                   	nop

00102320 <ioapicenable>:
}

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
  102320:	8b 15 e4 c3 10 00    	mov    0x10c3e4,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
  102326:	55                   	push   %ebp
  102327:	89 e5                	mov    %esp,%ebp
  102329:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
  10232c:	85 d2                	test   %edx,%edx
  10232e:	74 31                	je     102361 <ioapicenable+0x41>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102330:	8b 15 94 c3 10 00    	mov    0x10c394,%edx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  102336:	8d 48 20             	lea    0x20(%eax),%ecx
  102339:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  10233d:	89 02                	mov    %eax,(%edx)
  ioapic->data = data;
  10233f:	8b 15 94 c3 10 00    	mov    0x10c394,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102345:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
  102348:	89 4a 10             	mov    %ecx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  10234b:	8b 0d 94 c3 10 00    	mov    0x10c394,%ecx

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  102351:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102354:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
  102356:	a1 94 c3 10 00       	mov    0x10c394,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
  10235b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  10235e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
  102361:	5d                   	pop    %ebp
  102362:	c3                   	ret    
  102363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102370 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
  102370:	55                   	push   %ebp
  102371:	89 e5                	mov    %esp,%ebp
  102373:	56                   	push   %esi
  102374:	53                   	push   %ebx
  102375:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
  102378:	8b 0d e4 c3 10 00    	mov    0x10c3e4,%ecx
  10237e:	85 c9                	test   %ecx,%ecx
  102380:	0f 84 9e 00 00 00    	je     102424 <ioapicinit+0xb4>
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  102386:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
  10238d:	00 00 00 
  return ioapic->data;
  102390:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  102396:	bb 00 00 c0 fe       	mov    $0xfec00000,%ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  10239b:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
  1023a2:	00 00 00 
  return ioapic->data;
  1023a5:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  1023aa:	0f b6 15 e0 c3 10 00 	movzbl 0x10c3e0,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1023b1:	c7 05 94 c3 10 00 00 	movl   $0xfec00000,0x10c394
  1023b8:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  1023bb:	c1 ee 10             	shr    $0x10,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  1023be:	c1 e8 18             	shr    $0x18,%eax

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  1023c1:	81 e6 ff 00 00 00    	and    $0xff,%esi
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
  1023c7:	39 c2                	cmp    %eax,%edx
  1023c9:	74 12                	je     1023dd <ioapicinit+0x6d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
  1023cb:	c7 04 24 84 6b 10 00 	movl   $0x106b84,(%esp)
  1023d2:	e8 e9 e0 ff ff       	call   1004c0 <cprintf>
  1023d7:	8b 1d 94 c3 10 00    	mov    0x10c394,%ebx
  1023dd:	ba 10 00 00 00       	mov    $0x10,%edx
  1023e2:	31 c0                	xor    %eax,%eax
  1023e4:	eb 08                	jmp    1023ee <ioapicinit+0x7e>
  1023e6:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023e8:	8b 1d 94 c3 10 00    	mov    0x10c394,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1023ee:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
  1023f0:	8b 1d 94 c3 10 00    	mov    0x10c394,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
  1023f6:	8d 48 20             	lea    0x20(%eax),%ecx
  1023f9:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023ff:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
  102402:	89 4b 10             	mov    %ecx,0x10(%ebx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102405:	8b 0d 94 c3 10 00    	mov    0x10c394,%ecx
  10240b:	8d 5a 01             	lea    0x1(%edx),%ebx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  10240e:	83 c2 02             	add    $0x2,%edx
  102411:	39 c6                	cmp    %eax,%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  102413:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
  102415:	8b 0d 94 c3 10 00    	mov    0x10c394,%ecx
  10241b:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  102422:	7d c4                	jge    1023e8 <ioapicinit+0x78>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
  102424:	83 c4 10             	add    $0x10,%esp
  102427:	5b                   	pop    %ebx
  102428:	5e                   	pop    %esi
  102429:	5d                   	pop    %ebp
  10242a:	c3                   	ret    
  10242b:	90                   	nop
  10242c:	90                   	nop
  10242d:	90                   	nop
  10242e:	90                   	nop
  10242f:	90                   	nop

00102430 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc()
{
  102430:	55                   	push   %ebp
  102431:	89 e5                	mov    %esp,%ebp
  102433:	53                   	push   %ebx
  102434:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  acquire(&kmem.lock);
  102437:	c7 04 24 a0 c3 10 00 	movl   $0x10c3a0,(%esp)
  10243e:	e8 ad 1b 00 00       	call   103ff0 <acquire>
  r = kmem.freelist;
  102443:	8b 1d d4 c3 10 00    	mov    0x10c3d4,%ebx
  if(r)
  102449:	85 db                	test   %ebx,%ebx
  10244b:	74 07                	je     102454 <kalloc+0x24>
    kmem.freelist = r->next;
  10244d:	8b 03                	mov    (%ebx),%eax
  10244f:	a3 d4 c3 10 00       	mov    %eax,0x10c3d4
  release(&kmem.lock);
  102454:	c7 04 24 a0 c3 10 00 	movl   $0x10c3a0,(%esp)
  10245b:	e8 40 1b 00 00       	call   103fa0 <release>
  return (char*) r;
}
  102460:	89 d8                	mov    %ebx,%eax
  102462:	83 c4 14             	add    $0x14,%esp
  102465:	5b                   	pop    %ebx
  102466:	5d                   	pop    %ebp
  102467:	c3                   	ret    
  102468:	90                   	nop
  102469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  102470:	55                   	push   %ebp
  102471:	89 e5                	mov    %esp,%ebp
  102473:	53                   	push   %ebx
  102474:	83 ec 14             	sub    $0x14,%esp
  102477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if(((uint) v) % PGSIZE || (uint)v < 1024*1024 || (uint)v >= PHYSTOP) 
  10247a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
  102480:	75 52                	jne    1024d4 <kfree+0x64>
  102482:	81 fb ff ff 0f 00    	cmp    $0xfffff,%ebx
  102488:	76 4a                	jbe    1024d4 <kfree+0x64>
  10248a:	81 fb ff ff ff 00    	cmp    $0xffffff,%ebx
  102490:	77 42                	ja     1024d4 <kfree+0x64>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
  102492:	89 1c 24             	mov    %ebx,(%esp)
  102495:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10249c:	00 
  10249d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1024a4:	00 
  1024a5:	e8 e6 1b 00 00       	call   104090 <memset>

  acquire(&kmem.lock);
  1024aa:	c7 04 24 a0 c3 10 00 	movl   $0x10c3a0,(%esp)
  1024b1:	e8 3a 1b 00 00       	call   103ff0 <acquire>
  r = (struct run *) v;
  r->next = kmem.freelist;
  1024b6:	a1 d4 c3 10 00       	mov    0x10c3d4,%eax
  1024bb:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  1024bd:	89 1d d4 c3 10 00    	mov    %ebx,0x10c3d4
  release(&kmem.lock);
  1024c3:	c7 45 08 a0 c3 10 00 	movl   $0x10c3a0,0x8(%ebp)
}
  1024ca:	83 c4 14             	add    $0x14,%esp
  1024cd:	5b                   	pop    %ebx
  1024ce:	5d                   	pop    %ebp

  acquire(&kmem.lock);
  r = (struct run *) v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
  1024cf:	e9 cc 1a 00 00       	jmp    103fa0 <release>
kfree(char *v)
{
  struct run *r;

  if(((uint) v) % PGSIZE || (uint)v < 1024*1024 || (uint)v >= PHYSTOP) 
    panic("kfree");
  1024d4:	c7 04 24 b6 6b 10 00 	movl   $0x106bb6,(%esp)
  1024db:	e8 b0 e5 ff ff       	call   100a90 <panic>

001024e0 <kinit>:
} kmem;

// Initialize free list of physical pages.
void
kinit(void)
{
  1024e0:	55                   	push   %ebp
  1024e1:	89 e5                	mov    %esp,%ebp
  1024e3:	53                   	push   %ebx
  extern char end[];

  initlock(&kmem.lock, "kmem");
  char *p = (char*)PGROUNDUP((uint)end);
  1024e4:	bb 83 05 11 00       	mov    $0x110583,%ebx
} kmem;

// Initialize free list of physical pages.
void
kinit(void)
{
  1024e9:	83 ec 14             	sub    $0x14,%esp
  extern char end[];

  initlock(&kmem.lock, "kmem");
  char *p = (char*)PGROUNDUP((uint)end);
  1024ec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
void
kinit(void)
{
  extern char end[];

  initlock(&kmem.lock, "kmem");
  1024f2:	c7 44 24 04 bc 6b 10 	movl   $0x106bbc,0x4(%esp)
  1024f9:	00 
  1024fa:	c7 04 24 a0 c3 10 00 	movl   $0x10c3a0,(%esp)
  102501:	e8 5a 19 00 00       	call   103e60 <initlock>
  char *p = (char*)PGROUNDUP((uint)end);
  for( ; p + PGSIZE - 1 < (char*) PHYSTOP; p += PGSIZE)
  102506:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  10250c:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  102511:	77 20                	ja     102533 <kinit+0x53>
  102513:	90                   	nop
  102514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
  102518:	89 1c 24             	mov    %ebx,(%esp)
{
  extern char end[];

  initlock(&kmem.lock, "kmem");
  char *p = (char*)PGROUNDUP((uint)end);
  for( ; p + PGSIZE - 1 < (char*) PHYSTOP; p += PGSIZE)
  10251b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
  102521:	e8 4a ff ff ff       	call   102470 <kfree>
{
  extern char end[];

  initlock(&kmem.lock, "kmem");
  char *p = (char*)PGROUNDUP((uint)end);
  for( ; p + PGSIZE - 1 < (char*) PHYSTOP; p += PGSIZE)
  102526:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  10252c:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  102531:	76 e5                	jbe    102518 <kinit+0x38>
    kfree(p);
}
  102533:	83 c4 14             	add    $0x14,%esp
  102536:	5b                   	pop    %ebx
  102537:	5d                   	pop    %ebp
  102538:	c3                   	ret    
  102539:	90                   	nop
  10253a:	90                   	nop
  10253b:	90                   	nop
  10253c:	90                   	nop
  10253d:	90                   	nop
  10253e:	90                   	nop
  10253f:	90                   	nop

00102540 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
  102540:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102541:	ba 64 00 00 00       	mov    $0x64,%edx
  102546:	89 e5                	mov    %esp,%ebp
  102548:	ec                   	in     (%dx),%al
  102549:	89 c2                	mov    %eax,%edx
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
  10254b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102550:	83 e2 01             	and    $0x1,%edx
  102553:	74 3e                	je     102593 <kbdgetc+0x53>
  102555:	ba 60 00 00 00       	mov    $0x60,%edx
  10255a:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
  10255b:	0f b6 c0             	movzbl %al,%eax

  if(data == 0xE0){
  10255e:	3d e0 00 00 00       	cmp    $0xe0,%eax
  102563:	0f 84 7f 00 00 00    	je     1025e8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
  102569:	84 c0                	test   %al,%al
  10256b:	79 2b                	jns    102598 <kbdgetc+0x58>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
  10256d:	8b 15 9c 91 10 00    	mov    0x10919c,%edx
  102573:	f6 c2 40             	test   $0x40,%dl
  102576:	75 03                	jne    10257b <kbdgetc+0x3b>
  102578:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10257b:	0f b6 80 e0 6b 10 00 	movzbl 0x106be0(%eax),%eax
  102582:	83 c8 40             	or     $0x40,%eax
  102585:	0f b6 c0             	movzbl %al,%eax
  102588:	f7 d0                	not    %eax
  10258a:	21 d0                	and    %edx,%eax
  10258c:	a3 9c 91 10 00       	mov    %eax,0x10919c
  102591:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  102593:	5d                   	pop    %ebp
  102594:	c3                   	ret    
  102595:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
  102598:	8b 0d 9c 91 10 00    	mov    0x10919c,%ecx
  10259e:	f6 c1 40             	test   $0x40,%cl
  1025a1:	74 05                	je     1025a8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
  1025a3:	0c 80                	or     $0x80,%al
    shift &= ~E0ESC;
  1025a5:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1025a8:	0f b6 90 e0 6b 10 00 	movzbl 0x106be0(%eax),%edx
  1025af:	09 ca                	or     %ecx,%edx
  1025b1:	0f b6 88 e0 6c 10 00 	movzbl 0x106ce0(%eax),%ecx
  1025b8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  1025ba:	89 d1                	mov    %edx,%ecx
  1025bc:	83 e1 03             	and    $0x3,%ecx
  1025bf:	8b 0c 8d e0 6d 10 00 	mov    0x106de0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1025c6:	89 15 9c 91 10 00    	mov    %edx,0x10919c
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
  1025cc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  1025cf:	0f b6 04 01          	movzbl (%ecx,%eax,1),%eax
  if(shift & CAPSLOCK){
  1025d3:	74 be                	je     102593 <kbdgetc+0x53>
    if('a' <= c && c <= 'z')
  1025d5:	8d 50 9f             	lea    -0x61(%eax),%edx
  1025d8:	83 fa 19             	cmp    $0x19,%edx
  1025db:	77 1b                	ja     1025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
  1025dd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1025e0:	5d                   	pop    %ebp
  1025e1:	c3                   	ret    
  1025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
  1025e8:	30 c0                	xor    %al,%al
  1025ea:	83 0d 9c 91 10 00 40 	orl    $0x40,0x10919c
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
  1025f1:	5d                   	pop    %ebp
  1025f2:	c3                   	ret    
  1025f3:	90                   	nop
  1025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
  1025f8:	8d 50 bf             	lea    -0x41(%eax),%edx
  1025fb:	83 fa 19             	cmp    $0x19,%edx
  1025fe:	77 93                	ja     102593 <kbdgetc+0x53>
      c += 'a' - 'A';
  102600:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
  102603:	5d                   	pop    %ebp
  102604:	c3                   	ret    
  102605:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102610 <kbdintr>:

void
kbdintr(void)
{
  102610:	55                   	push   %ebp
  102611:	89 e5                	mov    %esp,%ebp
  102613:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
  102616:	c7 04 24 40 25 10 00 	movl   $0x102540,(%esp)
  10261d:	e8 9e e1 ff ff       	call   1007c0 <consoleintr>
}
  102622:	c9                   	leave  
  102623:	c3                   	ret    
  102624:	90                   	nop
  102625:	90                   	nop
  102626:	90                   	nop
  102627:	90                   	nop
  102628:	90                   	nop
  102629:	90                   	nop
  10262a:	90                   	nop
  10262b:	90                   	nop
  10262c:	90                   	nop
  10262d:	90                   	nop
  10262e:	90                   	nop
  10262f:	90                   	nop

00102630 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
  102630:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
  102635:	55                   	push   %ebp
  102636:	89 e5                	mov    %esp,%ebp
  if(lapic)
  102638:	85 c0                	test   %eax,%eax
  10263a:	74 12                	je     10264e <lapiceoi+0x1e>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10263c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102643:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102646:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10264b:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
  10264e:	5d                   	pop    %ebp
  10264f:	c3                   	ret    

00102650 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
  102650:	55                   	push   %ebp
  102651:	89 e5                	mov    %esp,%ebp
}
  102653:	5d                   	pop    %ebp
  102654:	c3                   	ret    
  102655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102660 <lapicstartap>:

// Start additional processor running bootstrap code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
  102660:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102661:	ba 70 00 00 00       	mov    $0x70,%edx
  102666:	89 e5                	mov    %esp,%ebp
  102668:	b8 0f 00 00 00       	mov    $0xf,%eax
  10266d:	53                   	push   %ebx
  10266e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102671:	0f b6 5d 08          	movzbl 0x8(%ebp),%ebx
  102675:	ee                   	out    %al,(%dx)
  102676:	b8 0a 00 00 00       	mov    $0xa,%eax
  10267b:	b2 71                	mov    $0x71,%dl
  10267d:	ee                   	out    %al,(%dx)
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
  10267e:	89 c8                	mov    %ecx,%eax
  102680:	c1 e8 04             	shr    $0x4,%eax
  102683:	66 a3 69 04 00 00    	mov    %ax,0x469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102689:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10268e:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
  outb(IO_RTC+1, 0x0A);
  wrv = (ushort*)(0x40<<4 | 0x67);  // Warm reset vector
  wrv[0] = 0;
  102691:	66 c7 05 67 04 00 00 	movw   $0x0,0x467
  102698:	00 00 

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  10269a:	c1 e9 0c             	shr    $0xc,%ecx
  10269d:	80 cd 06             	or     $0x6,%ch
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026a0:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026a6:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1026ab:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ae:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  1026b5:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026b8:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1026bd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026c0:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  1026c7:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026ca:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1026cf:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026d2:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026d8:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1026dd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026e0:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026e6:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1026eb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ee:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026f4:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1026f9:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026fc:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102702:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  102707:	5b                   	pop    %ebx
  102708:	5d                   	pop    %ebp

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  lapic[ID];  // wait for write to finish, by reading
  102709:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
  10270c:	c3                   	ret    
  10270d:	8d 76 00             	lea    0x0(%esi),%esi

00102710 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
  102710:	55                   	push   %ebp
  102711:	89 e5                	mov    %esp,%ebp
  102713:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  102716:	9c                   	pushf  
  102717:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
  102718:	f6 c4 02             	test   $0x2,%ah
  10271b:	74 12                	je     10272f <cpunum+0x1f>
    static int n;
    if(n++ == 0)
  10271d:	a1 a0 91 10 00       	mov    0x1091a0,%eax
  102722:	8d 50 01             	lea    0x1(%eax),%edx
  102725:	85 c0                	test   %eax,%eax
  102727:	89 15 a0 91 10 00    	mov    %edx,0x1091a0
  10272d:	74 19                	je     102748 <cpunum+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if(lapic)
  10272f:	8b 15 d8 c3 10 00    	mov    0x10c3d8,%edx
  102735:	31 c0                	xor    %eax,%eax
  102737:	85 d2                	test   %edx,%edx
  102739:	74 06                	je     102741 <cpunum+0x31>
    return lapic[ID]>>24;
  10273b:	8b 42 20             	mov    0x20(%edx),%eax
  10273e:	c1 e8 18             	shr    $0x18,%eax
  return 0;
}
  102741:	c9                   	leave  
  102742:	c3                   	ret    
  102743:	90                   	nop
  102744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
  102748:	8b 45 04             	mov    0x4(%ebp),%eax
  10274b:	c7 04 24 f0 6d 10 00 	movl   $0x106df0,(%esp)
  102752:	89 44 24 04          	mov    %eax,0x4(%esp)
  102756:	e8 65 dd ff ff       	call   1004c0 <cprintf>
  10275b:	eb d2                	jmp    10272f <cpunum+0x1f>
  10275d:	8d 76 00             	lea    0x0(%esi),%esi

00102760 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(int c)
{
  102760:	55                   	push   %ebp
  102761:	89 e5                	mov    %esp,%ebp
  102763:	83 ec 18             	sub    $0x18,%esp
  cprintf("lapicinit: %d 0x%x\n", c, lapic);
  102766:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10276b:	c7 04 24 1c 6e 10 00 	movl   $0x106e1c,(%esp)
  102772:	89 44 24 08          	mov    %eax,0x8(%esp)
  102776:	8b 45 08             	mov    0x8(%ebp),%eax
  102779:	89 44 24 04          	mov    %eax,0x4(%esp)
  10277d:	e8 3e dd ff ff       	call   1004c0 <cprintf>
  if(!lapic) 
  102782:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  102787:	85 c0                	test   %eax,%eax
  102789:	0f 84 0a 01 00 00    	je     102899 <lapicinit+0x139>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10278f:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
  102796:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102799:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10279e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027a1:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1027a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027ab:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1027b0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027b3:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1027ba:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  1027bd:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1027c2:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027c5:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  1027cc:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  1027cf:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1027d4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027d7:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  1027de:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1027e1:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1027e6:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027e9:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  1027f0:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1027f3:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1027f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
  1027fb:	8b 50 30             	mov    0x30(%eax),%edx
  1027fe:	c1 ea 10             	shr    $0x10,%edx
  102801:	80 fa 03             	cmp    $0x3,%dl
  102804:	0f 87 96 00 00 00    	ja     1028a0 <lapicinit+0x140>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10280a:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
  102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102814:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  102819:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10281c:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102823:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102826:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10282b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10282e:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102835:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102838:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10283d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102840:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102847:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10284a:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  10284f:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102852:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  102859:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10285c:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  102861:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102864:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  10286b:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  10286e:	8b 0d d8 c3 10 00    	mov    0x10c3d8,%ecx
  102874:	8b 41 20             	mov    0x20(%ecx),%eax
  102877:	8d 91 00 03 00 00    	lea    0x300(%ecx),%edx
  10287d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
  102880:	8b 02                	mov    (%edx),%eax
  102882:	f6 c4 10             	test   $0x10,%ah
  102885:	75 f9                	jne    102880 <lapicinit+0x120>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102887:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
  10288e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102891:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  102896:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
  102899:	c9                   	leave  
  10289a:	c3                   	ret    
  10289b:	90                   	nop
  10289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1028a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
  1028a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1028aa:	a1 d8 c3 10 00       	mov    0x10c3d8,%eax
  1028af:	8b 50 20             	mov    0x20(%eax),%edx
  1028b2:	e9 53 ff ff ff       	jmp    10280a <lapicinit+0xaa>
  1028b7:	90                   	nop
  1028b8:	90                   	nop
  1028b9:	90                   	nop
  1028ba:	90                   	nop
  1028bb:	90                   	nop
  1028bc:	90                   	nop
  1028bd:	90                   	nop
  1028be:	90                   	nop
  1028bf:	90                   	nop

001028c0 <mpmain>:
// Common CPU setup code.
// Bootstrap CPU comes here from mainc().
// Other CPUs jump here from bootother.S.
static void
mpmain(void)
{
  1028c0:	55                   	push   %ebp
  1028c1:	89 e5                	mov    %esp,%ebp
  1028c3:	53                   	push   %ebx
  1028c4:	83 ec 14             	sub    $0x14,%esp
  if(cpunum() != mpbcpu()) {
  1028c7:	e8 44 fe ff ff       	call   102710 <cpunum>
  1028cc:	89 c3                	mov    %eax,%ebx
  1028ce:	e8 ed 01 00 00       	call   102ac0 <mpbcpu>
  1028d3:	39 c3                	cmp    %eax,%ebx
  1028d5:	74 16                	je     1028ed <mpmain+0x2d>
    ksegment();
  1028d7:	e8 d4 3f 00 00       	call   1068b0 <ksegment>
  1028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapicinit(cpunum());
  1028e0:	e8 2b fe ff ff       	call   102710 <cpunum>
  1028e5:	89 04 24             	mov    %eax,(%esp)
  1028e8:	e8 73 fe ff ff       	call   102760 <lapicinit>
  }
  vmenable();        // turn on paging
  1028ed:	e8 be 38 00 00       	call   1061b0 <vmenable>
  cprintf("cpu%d: starting\n", cpu->id);
  1028f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1028f8:	0f b6 00             	movzbl (%eax),%eax
  1028fb:	c7 04 24 30 6e 10 00 	movl   $0x106e30,(%esp)
  102902:	89 44 24 04          	mov    %eax,0x4(%esp)
  102906:	e8 b5 db ff ff       	call   1004c0 <cprintf>
  idtinit();       // load idt register
  10290b:	e8 40 29 00 00       	call   105250 <idtinit>
  xchg(&cpu->booted, 1);
  102910:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  102917:	b8 01 00 00 00       	mov    $0x1,%eax
  10291c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
  102923:	e8 e8 0b 00 00       	call   103510 <scheduler>
  102928:	90                   	nop
  102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102930 <mainc>:
  panic("jkstack");
}

void
mainc(void)
{
  102930:	55                   	push   %ebp
  102931:	89 e5                	mov    %esp,%ebp
  102933:	53                   	push   %ebx
  102934:	83 ec 14             	sub    $0x14,%esp
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
  102937:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10293d:	0f b6 00             	movzbl (%eax),%eax
  102940:	c7 04 24 41 6e 10 00 	movl   $0x106e41,(%esp)
  102947:	89 44 24 04          	mov    %eax,0x4(%esp)
  10294b:	e8 70 db ff ff       	call   1004c0 <cprintf>
  kvmalloc();      // initialize the kernel page table
  102950:	e8 1b 3b 00 00       	call   106470 <kvmalloc>
  pinit();         // process table
  102955:	e8 e6 14 00 00       	call   103e40 <pinit>
  tvinit();        // trap vectors
  10295a:	e8 f1 2b 00 00       	call   105550 <tvinit>
  10295f:	90                   	nop
  binit();         // buffer cache
  102960:	e8 1b d8 ff ff       	call   100180 <binit>
  fileinit();      // file table
  102965:	e8 b6 e8 ff ff       	call   101220 <fileinit>
  iinit();         // inode cache
  10296a:	e8 c1 f6 ff ff       	call   102030 <iinit>
  10296f:	90                   	nop
  ideinit();       // disk
  102970:	e8 1b f9 ff ff       	call   102290 <ideinit>
  if(!ismp)
  102975:	a1 e4 c3 10 00       	mov    0x10c3e4,%eax
  10297a:	85 c0                	test   %eax,%eax
  10297c:	0f 84 ab 00 00 00    	je     102a2d <mainc+0xfd>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  102982:	e8 f9 12 00 00       	call   103c80 <userinit>
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.  The linker has
  // placed the start of bootother.S there.
  code = (uchar *) 0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102987:	c7 44 24 08 6a 00 00 	movl   $0x6a,0x8(%esp)
  10298e:	00 
  10298f:	c7 44 24 04 34 8a 10 	movl   $0x108a34,0x4(%esp)
  102996:	00 
  102997:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  10299e:	e8 6d 17 00 00       	call   104110 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  1029a3:	69 05 e0 c9 10 00 bc 	imul   $0xbc,0x10c9e0,%eax
  1029aa:	00 00 00 
  1029ad:	05 00 c4 10 00       	add    $0x10c400,%eax
  1029b2:	3d 00 c4 10 00       	cmp    $0x10c400,%eax
  1029b7:	76 6a                	jbe    102a23 <mainc+0xf3>
  1029b9:	bb 00 c4 10 00       	mov    $0x10c400,%ebx
  1029be:	66 90                	xchg   %ax,%ax
    if(c == cpus+cpunum())  // We've started already.
  1029c0:	e8 4b fd ff ff       	call   102710 <cpunum>
  1029c5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1029cb:	05 00 c4 10 00       	add    $0x10c400,%eax
  1029d0:	39 c3                	cmp    %eax,%ebx
  1029d2:	74 36                	je     102a0a <mainc+0xda>
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc();
  1029d4:	e8 57 fa ff ff       	call   102430 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpmain;
  1029d9:	c7 05 f8 6f 00 00 c0 	movl   $0x1028c0,0x6ff8
  1029e0:	28 10 00 
    if(c == cpus+cpunum())  // We've started already.
      continue;

    // Fill in %esp, %eip and start code on cpu.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
  1029e3:	05 00 10 00 00       	add    $0x1000,%eax
  1029e8:	a3 fc 6f 00 00       	mov    %eax,0x6ffc
    *(void**)(code-8) = mpmain;
    lapicstartap(c->id, (uint)code);
  1029ed:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
  1029f4:	00 
  1029f5:	0f b6 03             	movzbl (%ebx),%eax
  1029f8:	89 04 24             	mov    %eax,(%esp)
  1029fb:	e8 60 fc ff ff       	call   102660 <lapicstartap>

    // Wait for cpu to finish mpmain()
    while(c->booted == 0)
  102a00:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
  102a06:	85 c0                	test   %eax,%eax
  102a08:	74 f6                	je     102a00 <mainc+0xd0>
  // Write bootstrap code to unused memory at 0x7000.  The linker has
  // placed the start of bootother.S there.
  code = (uchar *) 0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);

  for(c = cpus; c < cpus+ncpu; c++){
  102a0a:	69 05 e0 c9 10 00 bc 	imul   $0xbc,0x10c9e0,%eax
  102a11:	00 00 00 
  102a14:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
  102a1a:	05 00 c4 10 00       	add    $0x10c400,%eax
  102a1f:	39 c3                	cmp    %eax,%ebx
  102a21:	72 9d                	jb     1029c0 <mainc+0x90>
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
}
  102a23:	83 c4 14             	add    $0x14,%esp
  102a26:	5b                   	pop    %ebx
  102a27:	5d                   	pop    %ebp
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  bootothers();    // start other processors

  // Finish setting up this processor in mpmain.
  mpmain();
  102a28:	e9 93 fe ff ff       	jmp    1028c0 <mpmain>
  binit();         // buffer cache
  fileinit();      // file table
  iinit();         // inode cache
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  102a2d:	e8 be 27 00 00       	call   1051f0 <timerinit>
  102a32:	e9 4b ff ff ff       	jmp    102982 <mainc+0x52>
  102a37:	89 f6                	mov    %esi,%esi
  102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102a40 <jkstack>:
  jkstack();       // call mainc() on a properly-allocated stack 
}

void
jkstack(void)
{
  102a40:	55                   	push   %ebp
  102a41:	89 e5                	mov    %esp,%ebp
  102a43:	83 ec 18             	sub    $0x18,%esp
  char *kstack = kalloc();
  102a46:	e8 e5 f9 ff ff       	call   102430 <kalloc>
  if(!kstack)
  102a4b:	85 c0                	test   %eax,%eax
  102a4d:	74 19                	je     102a68 <jkstack+0x28>
    panic("jkstack\n");
  char *top = kstack + PGSIZE;
  asm volatile("movl %0,%%esp" : : "r" (top));
  102a4f:	05 00 10 00 00       	add    $0x1000,%eax
  102a54:	89 c4                	mov    %eax,%esp
  asm volatile("call mainc");
  102a56:	e8 d5 fe ff ff       	call   102930 <mainc>
  panic("jkstack");
  102a5b:	c7 04 24 61 6e 10 00 	movl   $0x106e61,(%esp)
  102a62:	e8 29 e0 ff ff       	call   100a90 <panic>
  102a67:	90                   	nop
void
jkstack(void)
{
  char *kstack = kalloc();
  if(!kstack)
    panic("jkstack\n");
  102a68:	c7 04 24 58 6e 10 00 	movl   $0x106e58,(%esp)
  102a6f:	e8 1c e0 ff ff       	call   100a90 <panic>
  102a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00102a80 <main>:
void mainc(void);

// Bootstrap processor starts running C code here.
int
main(void)
{
  102a80:	55                   	push   %ebp
  102a81:	89 e5                	mov    %esp,%ebp
  102a83:	83 e4 f0             	and    $0xfffffff0,%esp
  102a86:	83 ec 10             	sub    $0x10,%esp
  mpinit();        // collect info about this machine
  102a89:	e8 d2 00 00 00       	call   102b60 <mpinit>
  lapicinit(mpbcpu());
  102a8e:	e8 2d 00 00 00       	call   102ac0 <mpbcpu>
  102a93:	89 04 24             	mov    %eax,(%esp)
  102a96:	e8 c5 fc ff ff       	call   102760 <lapicinit>
  ksegment();      // set up segments
  102a9b:	e8 10 3e 00 00       	call   1068b0 <ksegment>
  picinit();       // interrupt controller
  102aa0:	e8 eb 02 00 00       	call   102d90 <picinit>
  ioapicinit();    // another interrupt controller
  102aa5:	e8 c6 f8 ff ff       	call   102370 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
  102aaa:	e8 41 d7 ff ff       	call   1001f0 <consoleinit>
  102aaf:	90                   	nop
  uartinit();      // serial port
  102ab0:	e8 cb 2b 00 00       	call   105680 <uartinit>
  kinit();         // initialize memory allocator
  102ab5:	e8 26 fa ff ff       	call   1024e0 <kinit>
  jkstack();       // call mainc() on a properly-allocated stack 
  102aba:	e8 81 ff ff ff       	call   102a40 <jkstack>
  102abf:	90                   	nop

00102ac0 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  102ac0:	a1 a4 91 10 00       	mov    0x1091a4,%eax
  102ac5:	55                   	push   %ebp
  102ac6:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
}
  102ac8:	5d                   	pop    %ebp
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
  102ac9:	2d 00 c4 10 00       	sub    $0x10c400,%eax
  102ace:	c1 f8 02             	sar    $0x2,%eax
  102ad1:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
  return bcpu-cpus;
}
  102ad7:	c3                   	ret    
  102ad8:	90                   	nop
  102ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102ae0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uchar *addr, int len)
{
  102ae0:	55                   	push   %ebp
  102ae1:	89 e5                	mov    %esp,%ebp
  102ae3:	56                   	push   %esi
  102ae4:	89 d6                	mov    %edx,%esi
  102ae6:	53                   	push   %ebx
  102ae7:	89 c3                	mov    %eax,%ebx
  102ae9:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p;

  cprintf("mpsearch1 0x%x %d\n", addr, len);
  e = addr+len;
  102aec:	8d 34 33             	lea    (%ebx,%esi,1),%esi
static struct mp*
mpsearch1(uchar *addr, int len)
{
  uchar *e, *p;

  cprintf("mpsearch1 0x%x %d\n", addr, len);
  102aef:	89 54 24 08          	mov    %edx,0x8(%esp)
  102af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102af7:	c7 04 24 69 6e 10 00 	movl   $0x106e69,(%esp)
  102afe:	e8 bd d9 ff ff       	call   1004c0 <cprintf>
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b03:	39 f3                	cmp    %esi,%ebx
  102b05:	73 3a                	jae    102b41 <mpsearch1+0x61>
  102b07:	90                   	nop
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102b08:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102b0f:	00 
  102b10:	c7 44 24 04 7c 6e 10 	movl   $0x106e7c,0x4(%esp)
  102b17:	00 
  102b18:	89 1c 24             	mov    %ebx,(%esp)
  102b1b:	e8 90 15 00 00       	call   1040b0 <memcmp>
  102b20:	85 c0                	test   %eax,%eax
  102b22:	75 16                	jne    102b3a <mpsearch1+0x5a>
  102b24:	31 d2                	xor    %edx,%edx
  102b26:	66 90                	xchg   %ax,%ax
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
  102b28:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b2c:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102b2f:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102b31:	83 f8 10             	cmp    $0x10,%eax
  102b34:	75 f2                	jne    102b28 <mpsearch1+0x48>
  uchar *e, *p;

  cprintf("mpsearch1 0x%x %d\n", addr, len);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102b36:	84 d2                	test   %dl,%dl
  102b38:	74 10                	je     102b4a <mpsearch1+0x6a>
{
  uchar *e, *p;

  cprintf("mpsearch1 0x%x %d\n", addr, len);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b3a:	83 c3 10             	add    $0x10,%ebx
  102b3d:	39 de                	cmp    %ebx,%esi
  102b3f:	77 c7                	ja     102b08 <mpsearch1+0x28>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102b41:	83 c4 10             	add    $0x10,%esp
{
  uchar *e, *p;

  cprintf("mpsearch1 0x%x %d\n", addr, len);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b44:	31 c0                	xor    %eax,%eax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
  102b46:	5b                   	pop    %ebx
  102b47:	5e                   	pop    %esi
  102b48:	5d                   	pop    %ebp
  102b49:	c3                   	ret    
  102b4a:	83 c4 10             	add    $0x10,%esp

  cprintf("mpsearch1 0x%x %d\n", addr, len);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  102b4d:	89 d8                	mov    %ebx,%eax
  return 0;
}
  102b4f:	5b                   	pop    %ebx
  102b50:	5e                   	pop    %esi
  102b51:	5d                   	pop    %ebp
  102b52:	c3                   	ret    
  102b53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00102b60 <mpinit>:
  return conf;
}

void
mpinit(void)
{
  102b60:	55                   	push   %ebp
  102b61:	89 e5                	mov    %esp,%ebp
  102b63:	57                   	push   %edi
  102b64:	56                   	push   %esi
  102b65:	53                   	push   %ebx
  102b66:	83 ec 2c             	sub    $0x2c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102b69:	0f b6 05 0f 04 00 00 	movzbl 0x40f,%eax
  102b70:	0f b6 15 0e 04 00 00 	movzbl 0x40e,%edx
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  102b77:	c7 05 a4 91 10 00 00 	movl   $0x10c400,0x1091a4
  102b7e:	c4 10 00 
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar*)0x400;
  if((p = ((bda[0x0F]<<8)|bda[0x0E]) << 4)){
  102b81:	c1 e0 08             	shl    $0x8,%eax
  102b84:	09 d0                	or     %edx,%eax
  102b86:	c1 e0 04             	shl    $0x4,%eax
  102b89:	85 c0                	test   %eax,%eax
  102b8b:	75 1b                	jne    102ba8 <mpinit+0x48>
    if((mp = mpsearch1((uchar*)p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
  102b8d:	0f b6 05 14 04 00 00 	movzbl 0x414,%eax
  102b94:	0f b6 15 13 04 00 00 	movzbl 0x413,%edx
  102b9b:	c1 e0 08             	shl    $0x8,%eax
  102b9e:	09 d0                	or     %edx,%eax
  102ba0:	c1 e0 0a             	shl    $0xa,%eax
  102ba3:	2d 00 04 00 00       	sub    $0x400,%eax
  102ba8:	ba 00 04 00 00       	mov    $0x400,%edx
  102bad:	e8 2e ff ff ff       	call   102ae0 <mpsearch1>
  102bb2:	85 c0                	test   %eax,%eax
  102bb4:	89 c3                	mov    %eax,%ebx
  102bb6:	0f 84 54 01 00 00    	je     102d10 <mpinit+0x1b0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102bbc:	8b 73 04             	mov    0x4(%ebx),%esi
  102bbf:	85 f6                	test   %esi,%esi
  102bc1:	74 1c                	je     102bdf <mpinit+0x7f>
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
  102bc3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102bca:	00 
  102bcb:	c7 44 24 04 81 6e 10 	movl   $0x106e81,0x4(%esp)
  102bd2:	00 
  102bd3:	89 34 24             	mov    %esi,(%esp)
  102bd6:	e8 d5 14 00 00       	call   1040b0 <memcmp>
  102bdb:	85 c0                	test   %eax,%eax
  102bdd:	74 09                	je     102be8 <mpinit+0x88>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102bdf:	83 c4 2c             	add    $0x2c,%esp
  102be2:	5b                   	pop    %ebx
  102be3:	5e                   	pop    %esi
  102be4:	5f                   	pop    %edi
  102be5:	5d                   	pop    %ebp
  102be6:	c3                   	ret    
  102be7:	90                   	nop
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
  102be8:	0f b6 46 06          	movzbl 0x6(%esi),%eax
  102bec:	3c 04                	cmp    $0x4,%al
  102bee:	74 04                	je     102bf4 <mpinit+0x94>
  102bf0:	3c 01                	cmp    $0x1,%al
  102bf2:	75 eb                	jne    102bdf <mpinit+0x7f>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102bf4:	0f b7 7e 04          	movzwl 0x4(%esi),%edi
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102bf8:	85 ff                	test   %edi,%edi
  102bfa:	74 15                	je     102c11 <mpinit+0xb1>
  102bfc:	31 d2                	xor    %edx,%edx
  102bfe:	31 c0                	xor    %eax,%eax
    sum += addr[i];
  102c00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102c04:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
  102c07:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
  102c09:	39 c7                	cmp    %eax,%edi
  102c0b:	7f f3                	jg     102c00 <mpinit+0xa0>
  conf = (struct mpconf*)mp->physaddr;
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
  102c0d:	84 d2                	test   %dl,%dl
  102c0f:	75 ce                	jne    102bdf <mpinit+0x7f>
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  102c11:	c7 05 e4 c3 10 00 01 	movl   $0x1,0x10c3e4
  102c18:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102c1b:	8b 46 24             	mov    0x24(%esi),%eax
  102c1e:	a3 d8 c3 10 00       	mov    %eax,0x10c3d8
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c23:	0f b7 56 04          	movzwl 0x4(%esi),%edx
  102c27:	8d 46 2c             	lea    0x2c(%esi),%eax
  102c2a:	8d 14 16             	lea    (%esi,%edx,1),%edx
  102c2d:	39 d0                	cmp    %edx,%eax
  102c2f:	73 61                	jae    102c92 <mpinit+0x132>
  102c31:	8b 0d a4 91 10 00    	mov    0x1091a4,%ecx
  102c37:	89 de                	mov    %ebx,%esi
  102c39:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    switch(*p){
  102c3c:	0f b6 08             	movzbl (%eax),%ecx
  102c3f:	80 f9 04             	cmp    $0x4,%cl
  102c42:	76 2c                	jbe    102c70 <mpinit+0x110>
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102c44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102c47:	0f b6 c9             	movzbl %cl,%ecx
  102c4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102c4e:	c7 04 24 a8 6e 10 00 	movl   $0x106ea8,(%esp)
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102c55:	a3 a4 91 10 00       	mov    %eax,0x1091a4
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102c5a:	e8 61 d8 ff ff       	call   1004c0 <cprintf>
      panic("mpinit");
  102c5f:	c7 04 24 a1 6e 10 00 	movl   $0x106ea1,(%esp)
  102c66:	e8 25 de ff ff       	call   100a90 <panic>
  102c6b:	90                   	nop
  102c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
  102c70:	0f b6 c9             	movzbl %cl,%ecx
  102c73:	ff 24 8d c8 6e 10 00 	jmp    *0x106ec8(,%ecx,4)
  102c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
  102c80:	83 c0 08             	add    $0x8,%eax
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c83:	39 c2                	cmp    %eax,%edx
  102c85:	77 b5                	ja     102c3c <mpinit+0xdc>
  102c87:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  102c8a:	89 f3                	mov    %esi,%ebx
  102c8c:	89 0d a4 91 10 00    	mov    %ecx,0x1091a4
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      panic("mpinit");
    }
  }
  if(mp->imcrp){
  102c92:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
  102c96:	0f 84 43 ff ff ff    	je     102bdf <mpinit+0x7f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102c9c:	ba 22 00 00 00       	mov    $0x22,%edx
  102ca1:	b8 70 00 00 00       	mov    $0x70,%eax
  102ca6:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  102ca7:	b2 23                	mov    $0x23,%dl
  102ca9:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  102caa:	83 c8 01             	or     $0x1,%eax
  102cad:	ee                   	out    %al,(%dx)
  102cae:	e9 2c ff ff ff       	jmp    102bdf <mpinit+0x7f>
  102cb3:	90                   	nop
  102cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102cb8:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
  102cbc:	8b 3d e0 c9 10 00    	mov    0x10c9e0,%edi
  102cc2:	0f b6 cb             	movzbl %bl,%ecx
  102cc5:	39 f9                	cmp    %edi,%ecx
  102cc7:	75 68                	jne    102d31 <mpinit+0x1d1>
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
  102cc9:	f6 40 03 02          	testb  $0x2,0x3(%eax)
  102ccd:	74 0f                	je     102cde <mpinit+0x17e>
        bcpu = &cpus[ncpu];
  102ccf:	69 f9 bc 00 00 00    	imul   $0xbc,%ecx,%edi
  102cd5:	81 c7 00 c4 10 00    	add    $0x10c400,%edi
  102cdb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      cpus[ncpu].id = ncpu;
  102cde:	69 f9 bc 00 00 00    	imul   $0xbc,%ecx,%edi
      ncpu++;
  102ce4:	83 c1 01             	add    $0x1,%ecx
  102ce7:	89 0d e0 c9 10 00    	mov    %ecx,0x10c9e0
      p += sizeof(struct mpproc);
  102ced:	83 c0 14             	add    $0x14,%eax
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
  102cf0:	88 9f 00 c4 10 00    	mov    %bl,0x10c400(%edi)
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
  102cf6:	eb 8b                	jmp    102c83 <mpinit+0x123>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
  102cf8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
  102cfc:	83 c0 08             	add    $0x8,%eax
      ncpu++;
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
  102cff:	88 0d e0 c3 10 00    	mov    %cl,0x10c3e0
      p += sizeof(struct mpioapic);
      continue;
  102d05:	e9 79 ff ff ff       	jmp    102c83 <mpinit+0x123>
  102d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mpsearch1((uchar*)0xF0000, 0x10000);
  102d10:	ba 00 00 01 00       	mov    $0x10000,%edx
  102d15:	b8 00 00 0f 00       	mov    $0xf0000,%eax
  102d1a:	e8 c1 fd ff ff       	call   102ae0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102d1f:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1((uchar*)p-1024, 1024)))
      return mp;
  }
  return mpsearch1((uchar*)0xF0000, 0x10000);
  102d21:	89 c3                	mov    %eax,%ebx
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
  102d23:	0f 85 93 fe ff ff    	jne    102bbc <mpinit+0x5c>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
  102d29:	83 c4 2c             	add    $0x2c,%esp
  102d2c:	5b                   	pop    %ebx
  102d2d:	5e                   	pop    %esi
  102d2e:	5f                   	pop    %edi
  102d2f:	5d                   	pop    %ebp
  102d30:	c3                   	ret    
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
  102d34:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  102d38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  102d3c:	c7 04 24 86 6e 10 00 	movl   $0x106e86,(%esp)
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102d43:	a3 a4 91 10 00       	mov    %eax,0x1091a4
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
  102d48:	e8 73 d7 ff ff       	call   1004c0 <cprintf>
        panic("mpinit");
  102d4d:	c7 04 24 a1 6e 10 00 	movl   $0x106ea1,(%esp)
  102d54:	e8 37 dd ff ff       	call   100a90 <panic>
  102d59:	90                   	nop
  102d5a:	90                   	nop
  102d5b:	90                   	nop
  102d5c:	90                   	nop
  102d5d:	90                   	nop
  102d5e:	90                   	nop
  102d5f:	90                   	nop

00102d60 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
  102d60:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
  102d61:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
  102d66:	89 e5                	mov    %esp,%ebp
  102d68:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
  102d6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  102d70:	d3 c0                	rol    %cl,%eax
  102d72:	66 23 05 00 86 10 00 	and    0x108600,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
  102d79:	66 a3 00 86 10 00    	mov    %ax,0x108600
  102d7f:	ee                   	out    %al,(%dx)
  102d80:	66 c1 e8 08          	shr    $0x8,%ax
  102d84:	b2 a1                	mov    $0xa1,%dl
  102d86:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
  102d87:	5d                   	pop    %ebp
  102d88:	c3                   	ret    
  102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00102d90 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
  102d90:	55                   	push   %ebp
  102d91:	b9 21 00 00 00       	mov    $0x21,%ecx
  102d96:	89 e5                	mov    %esp,%ebp
  102d98:	83 ec 0c             	sub    $0xc,%esp
  102d9b:	89 1c 24             	mov    %ebx,(%esp)
  102d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  102da3:	89 ca                	mov    %ecx,%edx
  102da5:	89 74 24 04          	mov    %esi,0x4(%esp)
  102da9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  102dad:	ee                   	out    %al,(%dx)
  102dae:	bb a1 00 00 00       	mov    $0xa1,%ebx
  102db3:	89 da                	mov    %ebx,%edx
  102db5:	ee                   	out    %al,(%dx)
  102db6:	be 11 00 00 00       	mov    $0x11,%esi
  102dbb:	b2 20                	mov    $0x20,%dl
  102dbd:	89 f0                	mov    %esi,%eax
  102dbf:	ee                   	out    %al,(%dx)
  102dc0:	b8 20 00 00 00       	mov    $0x20,%eax
  102dc5:	89 ca                	mov    %ecx,%edx
  102dc7:	ee                   	out    %al,(%dx)
  102dc8:	b8 04 00 00 00       	mov    $0x4,%eax
  102dcd:	ee                   	out    %al,(%dx)
  102dce:	bf 03 00 00 00       	mov    $0x3,%edi
  102dd3:	89 f8                	mov    %edi,%eax
  102dd5:	ee                   	out    %al,(%dx)
  102dd6:	b1 a0                	mov    $0xa0,%cl
  102dd8:	89 f0                	mov    %esi,%eax
  102dda:	89 ca                	mov    %ecx,%edx
  102ddc:	ee                   	out    %al,(%dx)
  102ddd:	b8 28 00 00 00       	mov    $0x28,%eax
  102de2:	89 da                	mov    %ebx,%edx
  102de4:	ee                   	out    %al,(%dx)
  102de5:	b8 02 00 00 00       	mov    $0x2,%eax
  102dea:	ee                   	out    %al,(%dx)
  102deb:	89 f8                	mov    %edi,%eax
  102ded:	ee                   	out    %al,(%dx)
  102dee:	be 68 00 00 00       	mov    $0x68,%esi
  102df3:	b2 20                	mov    $0x20,%dl
  102df5:	89 f0                	mov    %esi,%eax
  102df7:	ee                   	out    %al,(%dx)
  102df8:	bb 0a 00 00 00       	mov    $0xa,%ebx
  102dfd:	89 d8                	mov    %ebx,%eax
  102dff:	ee                   	out    %al,(%dx)
  102e00:	89 f0                	mov    %esi,%eax
  102e02:	89 ca                	mov    %ecx,%edx
  102e04:	ee                   	out    %al,(%dx)
  102e05:	89 d8                	mov    %ebx,%eax
  102e07:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
  102e08:	0f b7 05 00 86 10 00 	movzwl 0x108600,%eax
  102e0f:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  102e13:	74 0a                	je     102e1f <picinit+0x8f>
  102e15:	b2 21                	mov    $0x21,%dl
  102e17:	ee                   	out    %al,(%dx)
  102e18:	66 c1 e8 08          	shr    $0x8,%ax
  102e1c:	b2 a1                	mov    $0xa1,%dl
  102e1e:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
  102e1f:	8b 1c 24             	mov    (%esp),%ebx
  102e22:	8b 74 24 04          	mov    0x4(%esp),%esi
  102e26:	8b 7c 24 08          	mov    0x8(%esp),%edi
  102e2a:	89 ec                	mov    %ebp,%esp
  102e2c:	5d                   	pop    %ebp
  102e2d:	c3                   	ret    
  102e2e:	90                   	nop
  102e2f:	90                   	nop

00102e30 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
  102e30:	55                   	push   %ebp
  102e31:	89 e5                	mov    %esp,%ebp
  102e33:	57                   	push   %edi
  102e34:	56                   	push   %esi
  102e35:	53                   	push   %ebx
  102e36:	83 ec 1c             	sub    $0x1c,%esp
  102e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  102e3c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
  102e3f:	89 1c 24             	mov    %ebx,(%esp)
  102e42:	e8 a9 11 00 00       	call   103ff0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102e47:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
  102e4d:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
  102e53:	75 58                	jne    102ead <piperead+0x7d>
  102e55:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
  102e5b:	85 f6                	test   %esi,%esi
  102e5d:	74 4e                	je     102ead <piperead+0x7d>
    if(proc->killed){
  102e5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  102e65:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
  102e6b:	8b 48 24             	mov    0x24(%eax),%ecx
  102e6e:	85 c9                	test   %ecx,%ecx
  102e70:	74 21                	je     102e93 <piperead+0x63>
  102e72:	e9 99 00 00 00       	jmp    102f10 <piperead+0xe0>
  102e77:	90                   	nop
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102e78:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
  102e7e:	85 c0                	test   %eax,%eax
  102e80:	74 2b                	je     102ead <piperead+0x7d>
    if(proc->killed){
  102e82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102e88:	8b 50 24             	mov    0x24(%eax),%edx
  102e8b:	85 d2                	test   %edx,%edx
  102e8d:	0f 85 7d 00 00 00    	jne    102f10 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  102e93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102e97:	89 34 24             	mov    %esi,(%esp)
  102e9a:	e8 61 05 00 00       	call   103400 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
  102e9f:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
  102ea5:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
  102eab:	74 cb                	je     102e78 <piperead+0x48>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102ead:	85 ff                	test   %edi,%edi
  102eaf:	7e 76                	jle    102f27 <piperead+0xf7>
    if(p->nread == p->nwrite)
  102eb1:	31 f6                	xor    %esi,%esi
  102eb3:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
  102eb9:	75 0d                	jne    102ec8 <piperead+0x98>
  102ebb:	eb 6a                	jmp    102f27 <piperead+0xf7>
  102ebd:	8d 76 00             	lea    0x0(%esi),%esi
  102ec0:	39 93 38 02 00 00    	cmp    %edx,0x238(%ebx)
  102ec6:	74 22                	je     102eea <piperead+0xba>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  102ec8:	89 d0                	mov    %edx,%eax
  102eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  102ecd:	83 c2 01             	add    $0x1,%edx
  102ed0:	25 ff 01 00 00       	and    $0x1ff,%eax
  102ed5:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
  102eda:	88 04 31             	mov    %al,(%ecx,%esi,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102edd:	83 c6 01             	add    $0x1,%esi
  102ee0:	39 f7                	cmp    %esi,%edi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  102ee2:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102ee8:	7f d6                	jg     102ec0 <piperead+0x90>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  102eea:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  102ef0:	89 04 24             	mov    %eax,(%esp)
  102ef3:	e8 a8 03 00 00       	call   1032a0 <wakeup>
  release(&p->lock);
  102ef8:	89 1c 24             	mov    %ebx,(%esp)
  102efb:	e8 a0 10 00 00       	call   103fa0 <release>
  return i;
}
  102f00:	83 c4 1c             	add    $0x1c,%esp
  102f03:	89 f0                	mov    %esi,%eax
  102f05:	5b                   	pop    %ebx
  102f06:	5e                   	pop    %esi
  102f07:	5f                   	pop    %edi
  102f08:	5d                   	pop    %ebp
  102f09:	c3                   	ret    
  102f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
  102f10:	be ff ff ff ff       	mov    $0xffffffff,%esi
  102f15:	89 1c 24             	mov    %ebx,(%esp)
  102f18:	e8 83 10 00 00       	call   103fa0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
  102f1d:	83 c4 1c             	add    $0x1c,%esp
  102f20:	89 f0                	mov    %esi,%eax
  102f22:	5b                   	pop    %ebx
  102f23:	5e                   	pop    %esi
  102f24:	5f                   	pop    %edi
  102f25:	5d                   	pop    %ebp
  102f26:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
  102f27:	31 f6                	xor    %esi,%esi
  102f29:	eb bf                	jmp    102eea <piperead+0xba>
  102f2b:	90                   	nop
  102f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00102f30 <pipewrite>:
    release(&p->lock);
}

int
pipewrite(struct pipe *p, char *addr, int n)
{
  102f30:	55                   	push   %ebp
  102f31:	89 e5                	mov    %esp,%ebp
  102f33:	57                   	push   %edi
  102f34:	56                   	push   %esi
  102f35:	53                   	push   %ebx
  102f36:	83 ec 3c             	sub    $0x3c,%esp
  102f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
  102f3c:	89 1c 24             	mov    %ebx,(%esp)
  102f3f:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
  102f45:	e8 a6 10 00 00       	call   103ff0 <acquire>
  for(i = 0; i < n; i++){
  102f4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  102f4d:	85 c9                	test   %ecx,%ecx
  102f4f:	0f 8e 8d 00 00 00    	jle    102fe2 <pipewrite+0xb2>
  102f55:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102f5b:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
  102f61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  102f68:	eb 37                	jmp    102fa1 <pipewrite+0x71>
  102f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
  102f70:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
  102f76:	85 c0                	test   %eax,%eax
  102f78:	74 7e                	je     102ff8 <pipewrite+0xc8>
  102f7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  102f80:	8b 50 24             	mov    0x24(%eax),%edx
  102f83:	85 d2                	test   %edx,%edx
  102f85:	75 71                	jne    102ff8 <pipewrite+0xc8>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
  102f87:	89 34 24             	mov    %esi,(%esp)
  102f8a:	e8 11 03 00 00       	call   1032a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
  102f8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102f93:	89 3c 24             	mov    %edi,(%esp)
  102f96:	e8 65 04 00 00       	call   103400 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
  102f9b:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
  102fa1:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
  102fa7:	81 c2 00 02 00 00    	add    $0x200,%edx
  102fad:	39 d0                	cmp    %edx,%eax
  102faf:	74 bf                	je     102f70 <pipewrite+0x40>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  102fb1:	89 c2                	mov    %eax,%edx
  102fb3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  102fb6:	83 c0 01             	add    $0x1,%eax
  102fb9:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  102fbf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  102fc5:	0f b6 0c 0a          	movzbl (%edx,%ecx,1),%ecx
  102fc9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fcc:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  102fd0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
  102fd6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  102fda:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  102fdd:	39 4d 10             	cmp    %ecx,0x10(%ebp)
  102fe0:	7f bf                	jg     102fa1 <pipewrite+0x71>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  102fe2:	89 34 24             	mov    %esi,(%esp)
  102fe5:	e8 b6 02 00 00       	call   1032a0 <wakeup>
  release(&p->lock);
  102fea:	89 1c 24             	mov    %ebx,(%esp)
  102fed:	e8 ae 0f 00 00       	call   103fa0 <release>
  return n;
  102ff2:	eb 13                	jmp    103007 <pipewrite+0xd7>
  102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
  102ff8:	89 1c 24             	mov    %ebx,(%esp)
  102ffb:	e8 a0 0f 00 00       	call   103fa0 <release>
  103000:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
  103007:	8b 45 10             	mov    0x10(%ebp),%eax
  10300a:	83 c4 3c             	add    $0x3c,%esp
  10300d:	5b                   	pop    %ebx
  10300e:	5e                   	pop    %esi
  10300f:	5f                   	pop    %edi
  103010:	5d                   	pop    %ebp
  103011:	c3                   	ret    
  103012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103020 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
  103020:	55                   	push   %ebp
  103021:	89 e5                	mov    %esp,%ebp
  103023:	83 ec 18             	sub    $0x18,%esp
  103026:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  103029:	8b 5d 08             	mov    0x8(%ebp),%ebx
  10302c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  10302f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
  103032:	89 1c 24             	mov    %ebx,(%esp)
  103035:	e8 b6 0f 00 00       	call   103ff0 <acquire>
  if(writable){
  10303a:	85 f6                	test   %esi,%esi
  10303c:	74 42                	je     103080 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
  10303e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
  103044:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
  10304b:	00 00 00 
    wakeup(&p->nread);
  10304e:	89 04 24             	mov    %eax,(%esp)
  103051:	e8 4a 02 00 00       	call   1032a0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
  103056:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
  10305c:	85 c0                	test   %eax,%eax
  10305e:	75 0a                	jne    10306a <pipeclose+0x4a>
  103060:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
  103066:	85 f6                	test   %esi,%esi
  103068:	74 36                	je     1030a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
  10306a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10306d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  103070:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  103073:	89 ec                	mov    %ebp,%esp
  103075:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
  103076:	e9 25 0f 00 00       	jmp    103fa0 <release>
  10307b:	90                   	nop
  10307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  103080:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
  103086:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
  10308d:	00 00 00 
    wakeup(&p->nwrite);
  103090:	89 04 24             	mov    %eax,(%esp)
  103093:	e8 08 02 00 00       	call   1032a0 <wakeup>
  103098:	eb bc                	jmp    103056 <pipeclose+0x36>
  10309a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
  1030a0:	89 1c 24             	mov    %ebx,(%esp)
  1030a3:	e8 f8 0e 00 00       	call   103fa0 <release>
    kfree((char*)p);
  } else
    release(&p->lock);
}
  1030a8:	8b 75 fc             	mov    -0x4(%ebp),%esi
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p);
  1030ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
  1030ae:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1030b1:	89 ec                	mov    %ebp,%esp
  1030b3:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0) {
    release(&p->lock);
    kfree((char*)p);
  1030b4:	e9 b7 f3 ff ff       	jmp    102470 <kfree>
  1030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001030c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
  1030c0:	55                   	push   %ebp
  1030c1:	89 e5                	mov    %esp,%ebp
  1030c3:	57                   	push   %edi
  1030c4:	56                   	push   %esi
  1030c5:	53                   	push   %ebx
  1030c6:	83 ec 1c             	sub    $0x1c,%esp
  1030c9:	8b 75 08             	mov    0x8(%ebp),%esi
  1030cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
  1030cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  1030d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
  1030db:	e8 e0 df ff ff       	call   1010c0 <filealloc>
  1030e0:	85 c0                	test   %eax,%eax
  1030e2:	89 06                	mov    %eax,(%esi)
  1030e4:	0f 84 9c 00 00 00    	je     103186 <pipealloc+0xc6>
  1030ea:	e8 d1 df ff ff       	call   1010c0 <filealloc>
  1030ef:	85 c0                	test   %eax,%eax
  1030f1:	89 03                	mov    %eax,(%ebx)
  1030f3:	0f 84 7f 00 00 00    	je     103178 <pipealloc+0xb8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
  1030f9:	e8 32 f3 ff ff       	call   102430 <kalloc>
  1030fe:	85 c0                	test   %eax,%eax
  103100:	89 c7                	mov    %eax,%edi
  103102:	74 74                	je     103178 <pipealloc+0xb8>
    goto bad;
  p->readopen = 1;
  103104:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
  10310b:	00 00 00 
  p->writeopen = 1;
  10310e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
  103115:	00 00 00 
  p->nwrite = 0;
  103118:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
  10311f:	00 00 00 
  p->nread = 0;
  103122:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
  103129:	00 00 00 
  initlock(&p->lock, "pipe");
  10312c:	89 04 24             	mov    %eax,(%esp)
  10312f:	c7 44 24 04 dc 6e 10 	movl   $0x106edc,0x4(%esp)
  103136:	00 
  103137:	e8 24 0d 00 00       	call   103e60 <initlock>
  (*f0)->type = FD_PIPE;
  10313c:	8b 06                	mov    (%esi),%eax
  10313e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
  103144:	8b 06                	mov    (%esi),%eax
  103146:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
  10314a:	8b 06                	mov    (%esi),%eax
  10314c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
  103150:	8b 06                	mov    (%esi),%eax
  103152:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
  103155:	8b 03                	mov    (%ebx),%eax
  103157:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
  10315d:	8b 03                	mov    (%ebx),%eax
  10315f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
  103163:	8b 03                	mov    (%ebx),%eax
  103165:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
  103169:	8b 03                	mov    (%ebx),%eax
  10316b:	89 78 0c             	mov    %edi,0xc(%eax)
  10316e:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
  103170:	83 c4 1c             	add    $0x1c,%esp
  103173:	5b                   	pop    %ebx
  103174:	5e                   	pop    %esi
  103175:	5f                   	pop    %edi
  103176:	5d                   	pop    %ebp
  103177:	c3                   	ret    
  return 0;

 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
  103178:	8b 06                	mov    (%esi),%eax
  10317a:	85 c0                	test   %eax,%eax
  10317c:	74 08                	je     103186 <pipealloc+0xc6>
    fileclose(*f0);
  10317e:	89 04 24             	mov    %eax,(%esp)
  103181:	e8 ba df ff ff       	call   101140 <fileclose>
  if(*f1)
  103186:	8b 13                	mov    (%ebx),%edx
  103188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10318d:	85 d2                	test   %edx,%edx
  10318f:	74 df                	je     103170 <pipealloc+0xb0>
    fileclose(*f1);
  103191:	89 14 24             	mov    %edx,(%esp)
  103194:	e8 a7 df ff ff       	call   101140 <fileclose>
  103199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10319e:	eb d0                	jmp    103170 <pipealloc+0xb0>

001031a0 <nice>:
  return -1;
}

int
nice()
{
  1031a0:	55                   	push   %ebp
  1031a1:	89 e5                	mov    %esp,%ebp
  1031a3:	53                   	push   %ebx
  1031a4:	31 db                	xor    %ebx,%ebx
  1031a6:	83 ec 14             	sub    $0x14,%esp
  1031a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1031af:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  int bef = proc->priority;
  if(bef == 0)
  bef = 1;
  else 
  bef = 0;
  acquire(&ptable.lock);
  1031b6:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  return -1;
}

int
nice()
{
  1031bd:	0f 94 c3             	sete   %bl
  int bef = proc->priority;
  if(bef == 0)
  bef = 1;
  else 
  bef = 0;
  acquire(&ptable.lock);
  1031c0:	e8 2b 0e 00 00       	call   103ff0 <acquire>
  proc->priority = (1 - (proc->priority));
  1031c5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1031cc:	b8 01 00 00 00       	mov    $0x1,%eax
  1031d1:	2b 82 88 00 00 00    	sub    0x88(%edx),%eax
  1031d7:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  release(&ptable.lock);
  1031dd:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1031e4:	e8 b7 0d 00 00       	call   103fa0 <release>
  1031e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1031ef:	39 98 88 00 00 00    	cmp    %ebx,0x88(%eax)
  1031f5:	0f 94 c0             	sete   %al
  return (proc->priority == bef);  
}
  1031f8:	83 c4 14             	add    $0x14,%esp
  bef = 1;
  else 
  bef = 0;
  acquire(&ptable.lock);
  proc->priority = (1 - (proc->priority));
  release(&ptable.lock);
  1031fb:	0f b6 c0             	movzbl %al,%eax
  return (proc->priority == bef);  
}
  1031fe:	5b                   	pop    %ebx
  1031ff:	5d                   	pop    %ebp
  103200:	c3                   	ret    
  103201:	eb 0d                	jmp    103210 <kill>
  103203:	90                   	nop
  103204:	90                   	nop
  103205:	90                   	nop
  103206:	90                   	nop
  103207:	90                   	nop
  103208:	90                   	nop
  103209:	90                   	nop
  10320a:	90                   	nop
  10320b:	90                   	nop
  10320c:	90                   	nop
  10320d:	90                   	nop
  10320e:	90                   	nop
  10320f:	90                   	nop

00103210 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  103210:	55                   	push   %ebp
  103211:	89 e5                	mov    %esp,%ebp
  103213:	53                   	push   %ebx
  103214:	83 ec 14             	sub    $0x14,%esp
  103217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
  10321a:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103221:	e8 ca 0d 00 00       	call   103ff0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
  103226:	8b 15 44 ca 10 00    	mov    0x10ca44,%edx

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  10322c:	b8 c0 ca 10 00       	mov    $0x10cac0,%eax
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
  103231:	39 da                	cmp    %ebx,%edx
  103233:	75 0f                	jne    103244 <kill+0x34>
  103235:	eb 60                	jmp    103297 <kill+0x87>
  103237:	90                   	nop
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103238:	05 8c 00 00 00       	add    $0x8c,%eax
  10323d:	3d 34 ed 10 00       	cmp    $0x10ed34,%eax
  103242:	74 3c                	je     103280 <kill+0x70>
    if(p->pid == pid){
  103244:	8b 50 10             	mov    0x10(%eax),%edx
  103247:	39 da                	cmp    %ebx,%edx
  103249:	75 ed                	jne    103238 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  10324b:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
  10324f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
  103256:	74 18                	je     103270 <kill+0x60>
        p->state = RUNNABLE;
      release(&ptable.lock);
  103258:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10325f:	e8 3c 0d 00 00       	call   103fa0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
  103264:	83 c4 14             	add    $0x14,%esp
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
  103267:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
  103269:	5b                   	pop    %ebx
  10326a:	5d                   	pop    %ebp
  10326b:	c3                   	ret    
  10326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
  103270:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103277:	eb df                	jmp    103258 <kill+0x48>
  103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  103280:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103287:	e8 14 0d 00 00       	call   103fa0 <release>
  return -1;
}
  10328c:	83 c4 14             	add    $0x14,%esp
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  10328f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return -1;
}
  103294:	5b                   	pop    %ebx
  103295:	5d                   	pop    %ebp
  103296:	c3                   	ret    
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
  103297:	b8 34 ca 10 00       	mov    $0x10ca34,%eax
  10329c:	eb ad                	jmp    10324b <kill+0x3b>
  10329e:	66 90                	xchg   %ax,%ax

001032a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  1032a0:	55                   	push   %ebp
  1032a1:	89 e5                	mov    %esp,%ebp
  1032a3:	53                   	push   %ebx
  1032a4:	83 ec 14             	sub    $0x14,%esp
  1032a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
  1032aa:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1032b1:	e8 3a 0d 00 00       	call   103ff0 <acquire>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1032b6:	b8 34 ca 10 00       	mov    $0x10ca34,%eax
  1032bb:	eb 0f                	jmp    1032cc <wakeup+0x2c>
  1032bd:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1032c0:	05 8c 00 00 00       	add    $0x8c,%eax
  1032c5:	3d 34 ed 10 00       	cmp    $0x10ed34,%eax
  1032ca:	74 24                	je     1032f0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
  1032cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1032d0:	75 ee                	jne    1032c0 <wakeup+0x20>
  1032d2:	3b 58 20             	cmp    0x20(%eax),%ebx
  1032d5:	75 e9                	jne    1032c0 <wakeup+0x20>
      p->state = RUNNABLE;
  1032d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1032de:	05 8c 00 00 00       	add    $0x8c,%eax
  1032e3:	3d 34 ed 10 00       	cmp    $0x10ed34,%eax
  1032e8:	75 e2                	jne    1032cc <wakeup+0x2c>
  1032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  1032f0:	c7 45 08 00 ca 10 00 	movl   $0x10ca00,0x8(%ebp)
}
  1032f7:	83 c4 14             	add    $0x14,%esp
  1032fa:	5b                   	pop    %ebx
  1032fb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  1032fc:	e9 9f 0c 00 00       	jmp    103fa0 <release>
  103301:	eb 0d                	jmp    103310 <forkret>
  103303:	90                   	nop
  103304:	90                   	nop
  103305:	90                   	nop
  103306:	90                   	nop
  103307:	90                   	nop
  103308:	90                   	nop
  103309:	90                   	nop
  10330a:	90                   	nop
  10330b:	90                   	nop
  10330c:	90                   	nop
  10330d:	90                   	nop
  10330e:	90                   	nop
  10330f:	90                   	nop

00103310 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  103310:	55                   	push   %ebp
  103311:	89 e5                	mov    %esp,%ebp
  103313:	83 ec 18             	sub    $0x18,%esp
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
  103316:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10331d:	e8 7e 0c 00 00       	call   103fa0 <release>
  
  // Return to "caller", actually trapret (see allocproc).
}
  103322:	c9                   	leave  
  103323:	c3                   	ret    
  103324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10332a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103330 <clockticks>:

static void wakeup1(void *chan);


int
clockticks(void) {
  103330:	55                   	push   %ebp
  103331:	89 e5                	mov    %esp,%ebp
  103333:	53                   	push   %ebx
  103334:	83 ec 14             	sub    $0x14,%esp
 uint xticks;
 acquire(&tickslock);
  103337:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  10333e:	e8 ad 0c 00 00       	call   103ff0 <acquire>
 xticks = ticks;
  103343:	8b 1d 80 f5 10 00    	mov    0x10f580,%ebx
 release(&tickslock);
  103349:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  103350:	e8 4b 0c 00 00       	call   103fa0 <release>
 return xticks;
}
  103355:	83 c4 14             	add    $0x14,%esp
  103358:	89 d8                	mov    %ebx,%eax
  10335a:	5b                   	pop    %ebx
  10335b:	5d                   	pop    %ebp
  10335c:	c3                   	ret    
  10335d:	8d 76 00             	lea    0x0(%esi),%esi

00103360 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  103360:	55                   	push   %ebp
  103361:	89 e5                	mov    %esp,%ebp
  103363:	53                   	push   %ebx
  103364:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
  103367:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10336e:	e8 6d 0b 00 00       	call   103ee0 <holding>
  103373:	85 c0                	test   %eax,%eax
  103375:	74 4d                	je     1033c4 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
  103377:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10337d:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
  103384:	75 62                	jne    1033e8 <sched+0x88>
    panic("sched locks");
  if(proc->state == RUNNING)
  103386:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10338d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
  103391:	74 49                	je     1033dc <sched+0x7c>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103393:	9c                   	pushf  
  103394:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
  103395:	80 e5 02             	and    $0x2,%ch
  103398:	75 36                	jne    1033d0 <sched+0x70>
    panic("sched interruptible");
  intena = cpu->intena;
  10339a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler);
  1033a0:	83 c2 1c             	add    $0x1c,%edx
  1033a3:	8b 40 04             	mov    0x4(%eax),%eax
  1033a6:	89 14 24             	mov    %edx,(%esp)
  1033a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ad:	e8 da 0e 00 00       	call   10428c <swtch>
  cpu->intena = intena;
  1033b2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1033b8:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  1033be:	83 c4 14             	add    $0x14,%esp
  1033c1:	5b                   	pop    %ebx
  1033c2:	5d                   	pop    %ebp
  1033c3:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  1033c4:	c7 04 24 e1 6e 10 00 	movl   $0x106ee1,(%esp)
  1033cb:	e8 c0 d6 ff ff       	call   100a90 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  1033d0:	c7 04 24 0d 6f 10 00 	movl   $0x106f0d,(%esp)
  1033d7:	e8 b4 d6 ff ff       	call   100a90 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  1033dc:	c7 04 24 ff 6e 10 00 	movl   $0x106eff,(%esp)
  1033e3:	e8 a8 d6 ff ff       	call   100a90 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  1033e8:	c7 04 24 f3 6e 10 00 	movl   $0x106ef3,(%esp)
  1033ef:	e8 9c d6 ff ff       	call   100a90 <panic>
  1033f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1033fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103400 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  103400:	55                   	push   %ebp
  103401:	89 e5                	mov    %esp,%ebp
  103403:	56                   	push   %esi
  103404:	53                   	push   %ebx
  103405:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
  103408:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  10340e:	8b 75 08             	mov    0x8(%ebp),%esi
  103411:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
  103414:	85 c0                	test   %eax,%eax
  103416:	0f 84 a1 00 00 00    	je     1034bd <sleep+0xbd>
    panic("sleep");

  if(lk == 0)
  10341c:	85 db                	test   %ebx,%ebx
  10341e:	0f 84 8d 00 00 00    	je     1034b1 <sleep+0xb1>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
  103424:	81 fb 00 ca 10 00    	cmp    $0x10ca00,%ebx
  10342a:	74 5c                	je     103488 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
  10342c:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103433:	e8 b8 0b 00 00       	call   103ff0 <acquire>
    release(lk);
  103438:	89 1c 24             	mov    %ebx,(%esp)
  10343b:	e8 60 0b 00 00       	call   103fa0 <release>
  }

  // Go to sleep.
  proc->chan = chan;
  103440:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103446:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
  103449:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10344f:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103456:	e8 05 ff ff ff       	call   103360 <sched>

  // Tidy up.
  proc->chan = 0;
  10345b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103461:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
  103468:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10346f:	e8 2c 0b 00 00       	call   103fa0 <release>
    acquire(lk);
  103474:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
  103477:	83 c4 10             	add    $0x10,%esp
  10347a:	5b                   	pop    %ebx
  10347b:	5e                   	pop    %esi
  10347c:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  10347d:	e9 6e 0b 00 00       	jmp    103ff0 <acquire>
  103482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  103488:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
  10348b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103491:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
  103498:	e8 c3 fe ff ff       	call   103360 <sched>

  // Tidy up.
  proc->chan = 0;
  10349d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1034a3:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
  1034aa:	83 c4 10             	add    $0x10,%esp
  1034ad:	5b                   	pop    %ebx
  1034ae:	5e                   	pop    %esi
  1034af:	5d                   	pop    %ebp
  1034b0:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
  1034b1:	c7 04 24 27 6f 10 00 	movl   $0x106f27,(%esp)
  1034b8:	e8 d3 d5 ff ff       	call   100a90 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
  1034bd:	c7 04 24 21 6f 10 00 	movl   $0x106f21,(%esp)
  1034c4:	e8 c7 d5 ff ff       	call   100a90 <panic>
  1034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001034d0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  1034d0:	55                   	push   %ebp
  1034d1:	89 e5                	mov    %esp,%ebp
  1034d3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
  1034d6:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1034dd:	e8 0e 0b 00 00       	call   103ff0 <acquire>
  proc->state = RUNNABLE;
  1034e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1034e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1034ef:	e8 6c fe ff ff       	call   103360 <sched>
  release(&ptable.lock);
  1034f4:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1034fb:	e8 a0 0a 00 00       	call   103fa0 <release>
}
  103500:	c9                   	leave  
  103501:	c3                   	ret    
  103502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  103509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103510 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  103510:	55                   	push   %ebp
  103511:	89 e5                	mov    %esp,%ebp
  103513:	57                   	push   %edi
  103514:	56                   	push   %esi
  103515:	31 f6                	xor    %esi,%esi
  103517:	53                   	push   %ebx
  103518:	83 ec 2c             	sub    $0x2c,%esp
  10351b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  103522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103528:	fb                   	sti    
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103529:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
  10352e:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103535:	e8 b6 0a 00 00       	call   103ff0 <acquire>
  10353a:	eb 68                	jmp    1035a4 <scheduler+0x94>
  10353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	so then I can return to that index when needed */
      if((p->state != RUNNABLE) && (p->priority == 0)) {
	loop++;
        continue;
	}
      else if((p->priority != 0) && loop < 64)
  103540:	83 fe 3f             	cmp    $0x3f,%esi
  103543:	7e 6f                	jle    1035b4 <scheduler+0xa4>
	{
	loop++;
	continue;
	}
      else if(loop == 64)
  103545:	83 fe 40             	cmp    $0x40,%esi
  103548:	89 df                	mov    %ebx,%edi
  10354a:	0f 84 a1 00 00 00    	je     1035f1 <scheduler+0xe1>


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
  103550:	65 89 3d 04 00 00 00 	mov    %edi,%gs:0x4
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103557:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  10355d:	31 f6                	xor    %esi,%esi

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
  10355f:	89 3c 24             	mov    %edi,(%esp)
  103562:	e8 99 32 00 00       	call   106800 <switchuvm>
      p->state = RUNNING;
  103567:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)

      swtch(&cpu->scheduler, proc->context);
  10356e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103574:	8b 40 1c             	mov    0x1c(%eax),%eax
  103577:	89 44 24 04          	mov    %eax,0x4(%esp)
  10357b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103581:	83 c0 04             	add    $0x4,%eax
  103584:	89 04 24             	mov    %eax,(%esp)
  103587:	e8 00 0d 00 00       	call   10428c <swtch>
      switchkvm();
  10358c:	e8 3f 2c 00 00       	call   1061d0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103591:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  103597:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  10359e:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1035a2:	74 21                	je     1035c5 <scheduler+0xb5>
	   if none are runnable I will go back to step 1.
	   if i get one that is runnable and low priority i will choose him then go back to step 1 

	I must keep a mechanism that saves the last low priority I was at and the last High priority I was at
	so then I can return to that index when needed */
      if((p->state != RUNNABLE) && (p->priority == 0)) {
  1035a4:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  1035a8:	74 2e                	je     1035d8 <scheduler+0xc8>
  1035aa:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  1035b0:	85 c0                	test   %eax,%eax
  1035b2:	75 8c                	jne    103540 <scheduler+0x30>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1035b4:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
	loop++;
        continue;
	}
      else if((p->priority != 0) && loop < 64)
	{
	loop++;
  1035ba:	83 c6 01             	add    $0x1,%esi
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1035bd:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  1035c3:	75 df                	jne    1035a4 <scheduler+0x94>

#ifdef RR2
      p=lastHighPri;
#endif
    }
    release(&ptable.lock);
  1035c5:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1035cc:	e8 cf 09 00 00       	call   103fa0 <release>

  }
  1035d1:	e9 52 ff ff ff       	jmp    103528 <scheduler+0x18>
  1035d6:	66 90                	xchg   %ax,%ax

	I must keep a mechanism that saves the last low priority I was at and the last High priority I was at
	so then I can return to that index when needed */
      if((p->state != RUNNABLE) && (p->priority == 0)) {
	loop++;
        continue;
  1035d8:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
	}
      else if((p->priority != 0) && loop < 64)
  1035de:	85 c0                	test   %eax,%eax
  1035e0:	0f 85 5a ff ff ff    	jne    103540 <scheduler+0x30>
	{
	loop++;
	continue;
	}
      else if(loop == 64)
  1035e6:	83 fe 40             	cmp    $0x40,%esi
  1035e9:	89 df                	mov    %ebx,%edi
  1035eb:	0f 85 5f ff ff ff    	jne    103550 <scheduler+0x40>
	{
	lastHighPri = p;
	if(lastLowPri == 0) {
  1035f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	lowPriorityRunnable = lastLowPri;
	}
	while(!((lowPriorityRunnable->priority !=0) && (lowPriorityRunnable->state == RUNNABLE))) {
	lowPriorityRunnable++;
	loop++;
	if(loop == 128)
  1035f4:	89 da                	mov    %ebx,%edx
	continue;
	}
      else if(loop == 64)
	{
	lastHighPri = p;
	if(lastLowPri == 0) {
  1035f6:	85 c9                	test   %ecx,%ecx
  1035f8:	74 14                	je     10360e <scheduler+0xfe>
  1035fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1035fd:	8b 82 88 00 00 00    	mov    0x88(%edx),%eax
  103603:	eb 09                	jmp    10360e <scheduler+0xfe>
  103605:	8d 76 00             	lea    0x0(%esi),%esi
	lowPriorityRunnable = lastLowPri;
	}
	while(!((lowPriorityRunnable->priority !=0) && (lowPriorityRunnable->state == RUNNABLE))) {
	lowPriorityRunnable++;
	loop++;
	if(loop == 128)
  103608:	8b 82 88 00 00 00    	mov    0x88(%edx),%eax
	lowPriorityRunnable = p;
	}
	else {
	lowPriorityRunnable = lastLowPri;
	}
	while(!((lowPriorityRunnable->priority !=0) && (lowPriorityRunnable->state == RUNNABLE))) {
  10360e:	85 c0                	test   %eax,%eax
  103610:	74 06                	je     103618 <scheduler+0x108>
  103612:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
  103616:	74 20                	je     103638 <scheduler+0x128>
	lowPriorityRunnable++;
	loop++;
  103618:	83 c6 01             	add    $0x1,%esi
	}
	else {
	lowPriorityRunnable = lastLowPri;
	}
	while(!((lowPriorityRunnable->priority !=0) && (lowPriorityRunnable->state == RUNNABLE))) {
	lowPriorityRunnable++;
  10361b:	81 c2 8c 00 00 00    	add    $0x8c,%edx
	loop++;
	if(loop == 128)
  103621:	81 fe 80 00 00 00    	cmp    $0x80,%esi
  103627:	75 df                	jne    103608 <scheduler+0xf8>
	break;
	}
	if(loop < 128)
  103629:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10362c:	89 df                	mov    %ebx,%edi
  10362e:	e9 1d ff ff ff       	jmp    103550 <scheduler+0x40>
  103633:	90                   	nop
  103634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103638:	83 fe 7f             	cmp    $0x7f,%esi
  10363b:	7f ec                	jg     103629 <scheduler+0x119>
  10363d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103640:	89 d7                	mov    %edx,%edi
  103642:	e9 09 ff ff ff       	jmp    103550 <scheduler+0x40>
  103647:	89 f6                	mov    %esi,%esi
  103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103650 <wait2>:
  }
}

int
wait2(int* wtime, int* rtime)
{
  103650:	55                   	push   %ebp
  103651:	89 e5                	mov    %esp,%ebp
  103653:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  103654:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx
  }
}

int
wait2(int* wtime, int* rtime)
{
  103659:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  10365c:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103663:	e8 88 09 00 00       	call   103ff0 <acquire>
  103668:	31 c0                	xor    %eax,%eax
  10366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103670:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  103676:	72 30                	jb     1036a8 <wait2+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  103678:	85 c0                	test   %eax,%eax
  10367a:	74 5c                	je     1036d8 <wait2+0x88>
  10367c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103682:	8b 58 24             	mov    0x24(%eax),%ebx
  103685:	85 db                	test   %ebx,%ebx
  103687:	75 4f                	jne    1036d8 <wait2+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  103689:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx
  10368e:	89 04 24             	mov    %eax,(%esp)
  103691:	c7 44 24 04 00 ca 10 	movl   $0x10ca00,0x4(%esp)
  103698:	00 
  103699:	e8 62 fd ff ff       	call   103400 <sleep>
  10369e:	31 c0                	xor    %eax,%eax
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1036a0:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  1036a6:	73 d0                	jae    103678 <wait2+0x28>
      if(p->parent != proc)
  1036a8:	8b 53 14             	mov    0x14(%ebx),%edx
  1036ab:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
  1036b2:	74 0c                	je     1036c0 <wait2+0x70>
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1036b4:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  1036ba:	eb b4                	jmp    103670 <wait2+0x20>
  1036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  1036c0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  1036c4:	74 29                	je     1036ef <wait2+0x9f>
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
  1036c6:	b8 01 00 00 00       	mov    $0x1,%eax
  1036cb:	90                   	nop
  1036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1036d0:	eb e2                	jmp    1036b4 <wait2+0x64>
  1036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  1036d8:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1036df:	e8 bc 08 00 00       	call   103fa0 <release>
  1036e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  1036e9:	83 c4 24             	add    $0x24,%esp
  1036ec:	5b                   	pop    %ebx
  1036ed:	5d                   	pop    %ebp
  1036ee:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
  1036ef:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  1036f5:	8b 55 08             	mov    0x8(%ebp),%edx
  1036f8:	2b 43 7c             	sub    0x7c(%ebx),%eax
  1036fb:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
  103701:	89 02                	mov    %eax,(%edx)
	*rtime = (p->rtime); 
  103703:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
  103709:	8b 45 0c             	mov    0xc(%ebp),%eax
  10370c:	89 10                	mov    %edx,(%eax)
	//cprintf("\nwtime: %d\n",*wtime);
	//cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
  10370e:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
  103711:	8b 53 08             	mov    0x8(%ebx),%edx
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
	*rtime = (p->rtime); 
	//cprintf("\nwtime: %d\n",*wtime);
	//cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
  103714:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  10371b:	00 00 00 
	p->ctime = 0;
  10371e:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->etime = 0;
  103725:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  10372c:	00 00 00 
        pid = p->pid;
        kfree(p->kstack);
  10372f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103732:	89 14 24             	mov    %edx,(%esp)
  103735:	e8 36 ed ff ff       	call   102470 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
  10373a:	8b 53 04             	mov    0x4(%ebx),%edx
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
  10373d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
  103744:	89 14 24             	mov    %edx,(%esp)
  103747:	e8 e4 2d 00 00       	call   106530 <freevm>
        p->state = UNUSED;
  10374c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  103753:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  10375a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  103761:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  103765:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->priority = 0;
  10376c:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103773:	00 00 00 
        release(&ptable.lock);
  103776:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10377d:	e8 1e 08 00 00       	call   103fa0 <release>
        return pid;
  103782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103785:	e9 5f ff ff ff       	jmp    1036e9 <wait2+0x99>
  10378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103790 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103790:	55                   	push   %ebp
  103791:	89 e5                	mov    %esp,%ebp
  103793:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  103794:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103799:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  10379c:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1037a3:	e8 48 08 00 00       	call   103ff0 <acquire>
  1037a8:	31 c0                	xor    %eax,%eax
  1037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1037b0:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  1037b6:	72 30                	jb     1037e8 <wait+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  1037b8:	85 c0                	test   %eax,%eax
  1037ba:	74 5c                	je     103818 <wait+0x88>
  1037bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1037c2:	8b 50 24             	mov    0x24(%eax),%edx
  1037c5:	85 d2                	test   %edx,%edx
  1037c7:	75 4f                	jne    103818 <wait+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  1037c9:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx
  1037ce:	89 04 24             	mov    %eax,(%esp)
  1037d1:	c7 44 24 04 00 ca 10 	movl   $0x10ca00,0x4(%esp)
  1037d8:	00 
  1037d9:	e8 22 fc ff ff       	call   103400 <sleep>
  1037de:	31 c0                	xor    %eax,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1037e0:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  1037e6:	73 d0                	jae    1037b8 <wait+0x28>
      if(p->parent != proc)
  1037e8:	8b 53 14             	mov    0x14(%ebx),%edx
  1037eb:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
  1037f2:	74 0c                	je     103800 <wait+0x70>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1037f4:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  1037fa:	eb b4                	jmp    1037b0 <wait+0x20>
  1037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  103800:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  103804:	74 29                	je     10382f <wait+0x9f>
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
  103806:	b8 01 00 00 00       	mov    $0x1,%eax
  10380b:	90                   	nop
  10380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103810:	eb e2                	jmp    1037f4 <wait+0x64>
  103812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  103818:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10381f:	e8 7c 07 00 00       	call   103fa0 <release>
  103824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  103829:	83 c4 24             	add    $0x24,%esp
  10382c:	5b                   	pop    %ebx
  10382d:	5d                   	pop    %ebp
  10382e:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
  10382f:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
  103832:	8b 53 08             	mov    0x8(%ebx),%edx
  103835:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103838:	89 14 24             	mov    %edx,(%esp)
  10383b:	e8 30 ec ff ff       	call   102470 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
  103840:	8b 53 04             	mov    0x4(%ebx),%edx
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
  103843:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
  10384a:	89 14 24             	mov    %edx,(%esp)
  10384d:	e8 de 2c 00 00       	call   106530 <freevm>
        p->state = UNUSED;
  103852:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  103859:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  103860:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  103867:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  10386b:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->rtime = 0;
  103872:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  103879:	00 00 00 
	p->ctime = 0;
  10387c:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->etime = 0;
  103883:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  10388a:	00 00 00 
	p->priority = 0;
  10388d:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103894:	00 00 00 
        release(&ptable.lock);
  103897:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10389e:	e8 fd 06 00 00       	call   103fa0 <release>
        return pid;
  1038a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038a6:	eb 81                	jmp    103829 <wait+0x99>
  1038a8:	90                   	nop
  1038a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001038b0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  1038b0:	55                   	push   %ebp
  1038b1:	89 e5                	mov    %esp,%ebp
  1038b3:	56                   	push   %esi
  1038b4:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
  1038b5:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  1038b7:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
  1038ba:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1038c1:	3b 15 a8 91 10 00    	cmp    0x1091a8,%edx
  1038c7:	0f 84 15 01 00 00    	je     1039e2 <exit+0x132>
  1038cd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
  1038d0:	8d 73 08             	lea    0x8(%ebx),%esi
  1038d3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
  1038d7:	85 c0                	test   %eax,%eax
  1038d9:	74 1d                	je     1038f8 <exit+0x48>
      fileclose(proc->ofile[fd]);
  1038db:	89 04 24             	mov    %eax,(%esp)
  1038de:	e8 5d d8 ff ff       	call   101140 <fileclose>
      proc->ofile[fd] = 0;
  1038e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1038e9:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
  1038f0:	00 
  1038f1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  1038f8:	83 c3 01             	add    $0x1,%ebx
  1038fb:	83 fb 10             	cmp    $0x10,%ebx
  1038fe:	75 d0                	jne    1038d0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  103900:	8b 42 68             	mov    0x68(%edx),%eax
  103903:	89 04 24             	mov    %eax,(%esp)
  103906:	e8 35 e1 ff ff       	call   101a40 <iput>
  proc->cwd = 0;
  10390b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103911:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
  103918:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  10391f:	e8 cc 06 00 00       	call   103ff0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  103924:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
  10392b:	b8 34 ca 10 00       	mov    $0x10ca34,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  103930:	8b 51 14             	mov    0x14(%ecx),%edx
  103933:	eb 0f                	jmp    103944 <exit+0x94>
  103935:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103938:	05 8c 00 00 00       	add    $0x8c,%eax
  10393d:	3d 34 ed 10 00       	cmp    $0x10ed34,%eax
  103942:	74 1e                	je     103962 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
  103944:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103948:	75 ee                	jne    103938 <exit+0x88>
  10394a:	3b 50 20             	cmp    0x20(%eax),%edx
  10394d:	75 e9                	jne    103938 <exit+0x88>
      p->state = RUNNABLE;
  10394f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103956:	05 8c 00 00 00       	add    $0x8c,%eax
  10395b:	3d 34 ed 10 00       	cmp    $0x10ed34,%eax
  103960:	75 e2                	jne    103944 <exit+0x94>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  103962:	8b 1d a8 91 10 00    	mov    0x1091a8,%ebx
  103968:	ba 34 ca 10 00       	mov    $0x10ca34,%edx
  10396d:	eb 0f                	jmp    10397e <exit+0xce>
  10396f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103970:	81 c2 8c 00 00 00    	add    $0x8c,%edx
  103976:	81 fa 34 ed 10 00    	cmp    $0x10ed34,%edx
  10397c:	74 3a                	je     1039b8 <exit+0x108>
    if(p->parent == proc){
  10397e:	3b 4a 14             	cmp    0x14(%edx),%ecx
  103981:	75 ed                	jne    103970 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
  103983:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  103987:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
  10398a:	75 e4                	jne    103970 <exit+0xc0>
  10398c:	b8 34 ca 10 00       	mov    $0x10ca34,%eax
  103991:	eb 11                	jmp    1039a4 <exit+0xf4>
  103993:	90                   	nop
  103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103998:	05 8c 00 00 00       	add    $0x8c,%eax
  10399d:	3d 34 ed 10 00       	cmp    $0x10ed34,%eax
  1039a2:	74 cc                	je     103970 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
  1039a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1039a8:	75 ee                	jne    103998 <exit+0xe8>
  1039aa:	3b 58 20             	cmp    0x20(%eax),%ebx
  1039ad:	75 e9                	jne    103998 <exit+0xe8>
      p->state = RUNNABLE;
  1039af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  1039b6:	eb e0                	jmp    103998 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  1039b8:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  proc->etime = clockticks();
  1039bf:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  1039c6:	e8 65 f9 ff ff       	call   103330 <clockticks>
  1039cb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  sched();
  1039d1:	e8 8a f9 ff ff       	call   103360 <sched>
  panic("zombie exit");
  1039d6:	c7 04 24 45 6f 10 00 	movl   $0x106f45,(%esp)
  1039dd:	e8 ae d0 ff ff       	call   100a90 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
  1039e2:	c7 04 24 38 6f 10 00 	movl   $0x106f38,(%esp)
  1039e9:	e8 a2 d0 ff ff       	call   100a90 <panic>
  1039ee:	66 90                	xchg   %ax,%ax

001039f0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  1039f0:	55                   	push   %ebp
  1039f1:	89 e5                	mov    %esp,%ebp
  1039f3:	53                   	push   %ebx
  1039f4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  1039f7:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  1039fe:	e8 ed 05 00 00       	call   103ff0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
  103a03:	8b 1d 40 ca 10 00    	mov    0x10ca40,%ebx
  103a09:	85 db                	test   %ebx,%ebx
  103a0b:	0f 84 cd 00 00 00    	je     103ade <allocproc+0xee>

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
  103a11:	bb c0 ca 10 00       	mov    $0x10cac0,%ebx
  103a16:	eb 12                	jmp    103a2a <allocproc+0x3a>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103a18:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103a1e:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  103a24:	0f 84 9e 00 00 00    	je     103ac8 <allocproc+0xd8>
    if(p->state == UNUSED)
  103a2a:	8b 4b 0c             	mov    0xc(%ebx),%ecx
  103a2d:	85 c9                	test   %ecx,%ecx
  103a2f:	75 e7                	jne    103a18 <allocproc+0x28>
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  103a31:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  103a38:	a1 04 86 10 00       	mov    0x108604,%eax
  103a3d:	89 43 10             	mov    %eax,0x10(%ebx)
  103a40:	83 c0 01             	add    $0x1,%eax
  103a43:	a3 04 86 10 00       	mov    %eax,0x108604
  release(&ptable.lock);
  103a48:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103a4f:	e8 4c 05 00 00       	call   103fa0 <release>

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
  103a54:	e8 d7 e9 ff ff       	call   102430 <kalloc>
  103a59:	85 c0                	test   %eax,%eax
  103a5b:	89 43 08             	mov    %eax,0x8(%ebx)
  103a5e:	0f 84 84 00 00 00    	je     103ae8 <allocproc+0xf8>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  103a64:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
  103a6a:	89 53 18             	mov    %edx,0x18(%ebx)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret (see below).
  sp -= 4;
  *(uint*)sp = (uint)trapret;
  103a6d:	c7 80 b0 0f 00 00 40 	movl   $0x105240,0xfb0(%eax)
  103a74:	52 10 00 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  103a77:	05 9c 0f 00 00       	add    $0xf9c,%eax
  103a7c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
  103a7f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  103a86:	00 
  103a87:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a8e:	00 
  103a8f:	89 04 24             	mov    %eax,(%esp)
  103a92:	e8 f9 05 00 00       	call   104090 <memset>
  p->context->eip = (uint)forkret;
  103a97:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103a9a:	c7 40 10 10 33 10 00 	movl   $0x103310,0x10(%eax)


  p->ctime = clockticks();
  103aa1:	e8 8a f8 ff ff       	call   103330 <clockticks>
  p->rtime = 0;
  103aa6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  103aad:	00 00 00 
  p->priority = 0;
  103ab0:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103ab7:	00 00 00 
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;


  p->ctime = clockticks();
  103aba:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}
  103abd:	89 d8                	mov    %ebx,%eax
  103abf:	83 c4 14             	add    $0x14,%esp
  103ac2:	5b                   	pop    %ebx
  103ac3:	5d                   	pop    %ebp
  103ac4:	c3                   	ret    
  103ac5:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  103ac8:	31 db                	xor    %ebx,%ebx
  103aca:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103ad1:	e8 ca 04 00 00       	call   103fa0 <release>
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}
  103ad6:	89 d8                	mov    %ebx,%eax
  103ad8:	83 c4 14             	add    $0x14,%esp
  103adb:	5b                   	pop    %ebx
  103adc:	5d                   	pop    %ebp
  103add:	c3                   	ret    
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  103ade:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx
  103ae3:	e9 49 ff ff ff       	jmp    103a31 <allocproc+0x41>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
  103ae8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  103aef:	31 db                	xor    %ebx,%ebx
    return 0;
  103af1:	eb ca                	jmp    103abd <allocproc+0xcd>
  103af3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103b00 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103b00:	55                   	push   %ebp
  103b01:	89 e5                	mov    %esp,%ebp
  103b03:	57                   	push   %edi
  103b04:	56                   	push   %esi
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103b05:	be ff ff ff ff       	mov    $0xffffffff,%esi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103b0a:	53                   	push   %ebx
  103b0b:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103b0e:	e8 dd fe ff ff       	call   1039f0 <allocproc>
  103b13:	85 c0                	test   %eax,%eax
  103b15:	89 c3                	mov    %eax,%ebx
  103b17:	0f 84 be 00 00 00    	je     103bdb <fork+0xdb>
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
  103b1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b23:	8b 10                	mov    (%eax),%edx
  103b25:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b29:	8b 40 04             	mov    0x4(%eax),%eax
  103b2c:	89 04 24             	mov    %eax,(%esp)
  103b2f:	e8 7c 2a 00 00       	call   1065b0 <copyuvm>
  103b34:	85 c0                	test   %eax,%eax
  103b36:	89 43 04             	mov    %eax,0x4(%ebx)
  103b39:	0f 84 a6 00 00 00    	je     103be5 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  103b3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
  103b45:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  103b4a:	8b 00                	mov    (%eax),%eax
  103b4c:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
  103b4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b54:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
  103b57:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103b5e:	8b 43 18             	mov    0x18(%ebx),%eax
  103b61:	8b 72 18             	mov    0x18(%edx),%esi
  103b64:	89 c7                	mov    %eax,%edi
  103b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  103b68:	31 f6                	xor    %esi,%esi
  103b6a:	8b 43 18             	mov    0x18(%ebx),%eax
  103b6d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  103b74:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103b7b:	90                   	nop
  103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
  103b80:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
  103b84:	85 c0                	test   %eax,%eax
  103b86:	74 13                	je     103b9b <fork+0x9b>
      np->ofile[i] = filedup(proc->ofile[i]);
  103b88:	89 04 24             	mov    %eax,(%esp)
  103b8b:	e8 e0 d4 ff ff       	call   101070 <filedup>
  103b90:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  103b94:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
  103b9b:	83 c6 01             	add    $0x1,%esi
  103b9e:	83 fe 10             	cmp    $0x10,%esi
  103ba1:	75 dd                	jne    103b80 <fork+0x80>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  103ba3:	8b 42 68             	mov    0x68(%edx),%eax
  103ba6:	89 04 24             	mov    %eax,(%esp)
  103ba9:	e8 c2 d6 ff ff       	call   101270 <idup>
 
  pid = np->pid;
  103bae:	8b 73 10             	mov    0x10(%ebx),%esi
  np->state = RUNNABLE;
  103bb1:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  103bb8:	89 43 68             	mov    %eax,0x68(%ebx)
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  103bbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103bc1:	83 c3 6c             	add    $0x6c,%ebx
  103bc4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103bcb:	00 
  103bcc:	89 1c 24             	mov    %ebx,(%esp)
  103bcf:	83 c0 6c             	add    $0x6c,%eax
  103bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bd6:	e8 55 06 00 00       	call   104230 <safestrcpy>
  return pid;
}
  103bdb:	83 c4 1c             	add    $0x1c,%esp
  103bde:	89 f0                	mov    %esi,%eax
  103be0:	5b                   	pop    %ebx
  103be1:	5e                   	pop    %esi
  103be2:	5f                   	pop    %edi
  103be3:	5d                   	pop    %ebp
  103be4:	c3                   	ret    
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
    kfree(np->kstack);
  103be5:	8b 43 08             	mov    0x8(%ebx),%eax
  103be8:	89 04 24             	mov    %eax,(%esp)
  103beb:	e8 80 e8 ff ff       	call   102470 <kfree>
    np->kstack = 0;
  103bf0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
  103bf7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
  103bfe:	eb db                	jmp    103bdb <fork+0xdb>

00103c00 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103c00:	55                   	push   %ebp
  103c01:	89 e5                	mov    %esp,%ebp
  103c03:	83 ec 18             	sub    $0x18,%esp
  uint sz = proc->sz;
  103c06:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103c0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz = proc->sz;
  103c10:	8b 02                	mov    (%edx),%eax
  if(n > 0){
  103c12:	83 f9 00             	cmp    $0x0,%ecx
  103c15:	7f 19                	jg     103c30 <growproc+0x30>
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  } else if(n < 0){
  103c17:	75 39                	jne    103c52 <growproc+0x52>
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  }
  proc->sz = sz;
  103c19:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
  103c1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103c21:	89 04 24             	mov    %eax,(%esp)
  103c24:	e8 d7 2b 00 00       	call   106800 <switchuvm>
  103c29:	31 c0                	xor    %eax,%eax
  return 0;
}
  103c2b:	c9                   	leave  
  103c2c:	c3                   	ret    
  103c2d:	8d 76 00             	lea    0x0(%esi),%esi
int
growproc(int n)
{
  uint sz = proc->sz;
  if(n > 0){
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
  103c30:	01 c1                	add    %eax,%ecx
  103c32:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103c36:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c3a:	8b 42 04             	mov    0x4(%edx),%eax
  103c3d:	89 04 24             	mov    %eax,(%esp)
  103c40:	e8 2b 2a 00 00       	call   106670 <allocuvm>
  103c45:	85 c0                	test   %eax,%eax
  103c47:	74 27                	je     103c70 <growproc+0x70>
      return -1;
  } else if(n < 0){
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
  103c49:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103c50:	eb c7                	jmp    103c19 <growproc+0x19>
  103c52:	01 c1                	add    %eax,%ecx
  103c54:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c5c:	8b 42 04             	mov    0x4(%edx),%eax
  103c5f:	89 04 24             	mov    %eax,(%esp)
  103c62:	e8 29 28 00 00       	call   106490 <deallocuvm>
  103c67:	85 c0                	test   %eax,%eax
  103c69:	75 de                	jne    103c49 <growproc+0x49>
  103c6b:	90                   	nop
  103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
  103c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  103c75:	c9                   	leave  
  103c76:	c3                   	ret    
  103c77:	89 f6                	mov    %esi,%esi
  103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103c80 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  103c80:	55                   	push   %ebp
  103c81:	89 e5                	mov    %esp,%ebp
  103c83:	53                   	push   %ebx
  103c84:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  103c87:	e8 64 fd ff ff       	call   1039f0 <allocproc>
  103c8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
  103c8e:	a3 a8 91 10 00       	mov    %eax,0x1091a8
  if(!(p->pgdir = setupkvm()))
  103c93:	e8 18 27 00 00       	call   1063b0 <setupkvm>
  103c98:	85 c0                	test   %eax,%eax
  103c9a:	89 43 04             	mov    %eax,0x4(%ebx)
  103c9d:	0f 84 b6 00 00 00    	je     103d59 <userinit+0xd9>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  103ca3:	89 04 24             	mov    %eax,(%esp)
  103ca6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103cad:	00 
  103cae:	c7 44 24 04 08 8a 10 	movl   $0x108a08,0x4(%esp)
  103cb5:	00 
  103cb6:	e8 65 26 00 00       	call   106320 <inituvm>
  p->sz = PGSIZE;
  103cbb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  103cc1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
  103cc8:	00 
  103cc9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103cd0:	00 
  103cd1:	8b 43 18             	mov    0x18(%ebx),%eax
  103cd4:	89 04 24             	mov    %eax,(%esp)
  103cd7:	e8 b4 03 00 00       	call   104090 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103cdc:	8b 43 18             	mov    0x18(%ebx),%eax
  103cdf:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  103ce5:	8b 43 18             	mov    0x18(%ebx),%eax
  103ce8:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
  103cee:	8b 43 18             	mov    0x18(%ebx),%eax
  103cf1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  103cf5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
  103cf9:	8b 43 18             	mov    0x18(%ebx),%eax
  103cfc:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  103d00:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
  103d04:	8b 43 18             	mov    0x18(%ebx),%eax
  103d07:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
  103d0e:	8b 43 18             	mov    0x18(%ebx),%eax
  103d11:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
  103d18:	8b 43 18             	mov    0x18(%ebx),%eax
  103d1b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
  103d22:	8d 43 6c             	lea    0x6c(%ebx),%eax
  103d25:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103d2c:	00 
  103d2d:	c7 44 24 04 6a 6f 10 	movl   $0x106f6a,0x4(%esp)
  103d34:	00 
  103d35:	89 04 24             	mov    %eax,(%esp)
  103d38:	e8 f3 04 00 00       	call   104230 <safestrcpy>
  p->cwd = namei("/");
  103d3d:	c7 04 24 73 6f 10 00 	movl   $0x106f73,(%esp)
  103d44:	e8 c7 e2 ff ff       	call   102010 <namei>

  p->state = RUNNABLE;
  103d49:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  103d50:	89 43 68             	mov    %eax,0x68(%ebx)

  p->state = RUNNABLE;
}
  103d53:	83 c4 14             	add    $0x14,%esp
  103d56:	5b                   	pop    %ebx
  103d57:	5d                   	pop    %ebp
  103d58:	c3                   	ret    
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if(!(p->pgdir = setupkvm()))
    panic("userinit: out of memory?");
  103d59:	c7 04 24 51 6f 10 00 	movl   $0x106f51,(%esp)
  103d60:	e8 2b cd ff ff       	call   100a90 <panic>
  103d65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103d70 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103d70:	55                   	push   %ebp
  103d71:	89 e5                	mov    %esp,%ebp
  103d73:	57                   	push   %edi
  103d74:	56                   	push   %esi
  103d75:	53                   	push   %ebx

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103d76:	bb 34 ca 10 00       	mov    $0x10ca34,%ebx
{
  103d7b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103d7e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103d81:	eb 4e                	jmp    103dd1 <procdump+0x61>
  103d83:	90                   	nop
  103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103d88:	8b 04 85 b4 6f 10 00 	mov    0x106fb4(,%eax,4),%eax
  103d8f:	85 c0                	test   %eax,%eax
  103d91:	74 4a                	je     103ddd <procdump+0x6d>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103d93:	8b 53 10             	mov    0x10(%ebx),%edx
  103d96:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
  103d99:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  103d9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103da1:	c7 04 24 79 6f 10 00 	movl   $0x106f79,(%esp)
  103da8:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dac:	e8 0f c7 ff ff       	call   1004c0 <cprintf>
    if(p->state == SLEEPING){
  103db1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  103db5:	74 31                	je     103de8 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  103db7:	c7 04 24 56 6e 10 00 	movl   $0x106e56,(%esp)
  103dbe:	e8 fd c6 ff ff       	call   1004c0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103dc3:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103dc9:	81 fb 34 ed 10 00    	cmp    $0x10ed34,%ebx
  103dcf:	74 57                	je     103e28 <procdump+0xb8>
    if(p->state == UNUSED)
  103dd1:	8b 43 0c             	mov    0xc(%ebx),%eax
  103dd4:	85 c0                	test   %eax,%eax
  103dd6:	74 eb                	je     103dc3 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103dd8:	83 f8 05             	cmp    $0x5,%eax
  103ddb:	76 ab                	jbe    103d88 <procdump+0x18>
  103ddd:	b8 75 6f 10 00       	mov    $0x106f75,%eax
  103de2:	eb af                	jmp    103d93 <procdump+0x23>
  103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103de8:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103deb:	31 f6                	xor    %esi,%esi
  103ded:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103df1:	8b 40 0c             	mov    0xc(%eax),%eax
  103df4:	83 c0 08             	add    $0x8,%eax
  103df7:	89 04 24             	mov    %eax,(%esp)
  103dfa:	e8 81 00 00 00       	call   103e80 <getcallerpcs>
  103dff:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
  103e00:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103e03:	85 c0                	test   %eax,%eax
  103e05:	74 b0                	je     103db7 <procdump+0x47>
  103e07:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[i]);
  103e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e0e:	c7 04 24 2a 6a 10 00 	movl   $0x106a2a,(%esp)
  103e15:	e8 a6 c6 ff ff       	call   1004c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
  103e1a:	83 fe 0a             	cmp    $0xa,%esi
  103e1d:	75 e1                	jne    103e00 <procdump+0x90>
  103e1f:	eb 96                	jmp    103db7 <procdump+0x47>
  103e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
  103e28:	83 c4 4c             	add    $0x4c,%esp
  103e2b:	5b                   	pop    %ebx
  103e2c:	5e                   	pop    %esi
  103e2d:	5f                   	pop    %edi
  103e2e:	5d                   	pop    %ebp
  103e2f:	90                   	nop
  103e30:	c3                   	ret    
  103e31:	eb 0d                	jmp    103e40 <pinit>
  103e33:	90                   	nop
  103e34:	90                   	nop
  103e35:	90                   	nop
  103e36:	90                   	nop
  103e37:	90                   	nop
  103e38:	90                   	nop
  103e39:	90                   	nop
  103e3a:	90                   	nop
  103e3b:	90                   	nop
  103e3c:	90                   	nop
  103e3d:	90                   	nop
  103e3e:	90                   	nop
  103e3f:	90                   	nop

00103e40 <pinit>:
 return xticks;
}

void
pinit(void)
{
  103e40:	55                   	push   %ebp
  103e41:	89 e5                	mov    %esp,%ebp
  103e43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
  103e46:	c7 44 24 04 82 6f 10 	movl   $0x106f82,0x4(%esp)
  103e4d:	00 
  103e4e:	c7 04 24 00 ca 10 00 	movl   $0x10ca00,(%esp)
  103e55:	e8 06 00 00 00       	call   103e60 <initlock>
}
  103e5a:	c9                   	leave  
  103e5b:	c3                   	ret    
  103e5c:	90                   	nop
  103e5d:	90                   	nop
  103e5e:	90                   	nop
  103e5f:	90                   	nop

00103e60 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  103e60:	55                   	push   %ebp
  103e61:	89 e5                	mov    %esp,%ebp
  103e63:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
  103e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
  103e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  103e6f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
  103e72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  103e79:	5d                   	pop    %ebp
  103e7a:	c3                   	ret    
  103e7b:	90                   	nop
  103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103e80 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103e80:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103e81:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103e83:	89 e5                	mov    %esp,%ebp
  103e85:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103e86:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103e89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103e8c:	83 ea 08             	sub    $0x8,%edx
  103e8f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
  103e90:	8d 8a 00 00 f0 ff    	lea    -0x100000(%edx),%ecx
  103e96:	81 f9 fe ff ef ff    	cmp    $0xffeffffe,%ecx
  103e9c:	77 1a                	ja     103eb8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103e9e:	8b 4a 04             	mov    0x4(%edx),%ecx
  103ea1:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103ea4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103ea7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103ea9:	83 f8 0a             	cmp    $0xa,%eax
  103eac:	75 e2                	jne    103e90 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  103eae:	5b                   	pop    %ebx
  103eaf:	5d                   	pop    %ebp
  103eb0:	c3                   	ret    
  103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103eb8:	83 f8 09             	cmp    $0x9,%eax
  103ebb:	7f f1                	jg     103eae <getcallerpcs+0x2e>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103ebd:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  103ec0:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  103ec3:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103ec9:	83 c2 04             	add    $0x4,%edx
  103ecc:	83 f8 0a             	cmp    $0xa,%eax
  103ecf:	75 ef                	jne    103ec0 <getcallerpcs+0x40>
    pcs[i] = 0;
}
  103ed1:	5b                   	pop    %ebx
  103ed2:	5d                   	pop    %ebp
  103ed3:	c3                   	ret    
  103ed4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103eda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103ee0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103ee0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
  103ee1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103ee3:	89 e5                	mov    %esp,%ebp
  103ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
  103ee8:	8b 0a                	mov    (%edx),%ecx
  103eea:	85 c9                	test   %ecx,%ecx
  103eec:	74 10                	je     103efe <holding+0x1e>
  103eee:	8b 42 08             	mov    0x8(%edx),%eax
  103ef1:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103ef8:	0f 94 c0             	sete   %al
  103efb:	0f b6 c0             	movzbl %al,%eax
}
  103efe:	5d                   	pop    %ebp
  103eff:	c3                   	ret    

00103f00 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  103f00:	55                   	push   %ebp
  103f01:	89 e5                	mov    %esp,%ebp
  103f03:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103f04:	9c                   	pushf  
  103f05:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103f06:	fa                   	cli    
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103f07:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103f0e:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103f14:	8d 48 01             	lea    0x1(%eax),%ecx
  103f17:	85 c0                	test   %eax,%eax
  103f19:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
  103f1f:	75 12                	jne    103f33 <pushcli+0x33>
    cpu->intena = eflags & FL_IF;
  103f21:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103f27:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103f2d:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  103f33:	5b                   	pop    %ebx
  103f34:	5d                   	pop    %ebp
  103f35:	c3                   	ret    
  103f36:	8d 76 00             	lea    0x0(%esi),%esi
  103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103f40 <popcli>:

void
popcli(void)
{
  103f40:	55                   	push   %ebp
  103f41:	89 e5                	mov    %esp,%ebp
  103f43:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103f46:	9c                   	pushf  
  103f47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
  103f48:	f6 c4 02             	test   $0x2,%ah
  103f4b:	75 43                	jne    103f90 <popcli+0x50>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
  103f4d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103f54:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103f5a:	83 e8 01             	sub    $0x1,%eax
  103f5d:	85 c0                	test   %eax,%eax
  103f5f:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
  103f65:	78 1d                	js     103f84 <popcli+0x44>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
  103f67:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103f6d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  103f73:	85 d2                	test   %edx,%edx
  103f75:	75 0b                	jne    103f82 <popcli+0x42>
  103f77:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  103f7d:	85 c0                	test   %eax,%eax
  103f7f:	74 01                	je     103f82 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
  103f81:	fb                   	sti    
    sti();
}
  103f82:	c9                   	leave  
  103f83:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
  103f84:	c7 04 24 e3 6f 10 00 	movl   $0x106fe3,(%esp)
  103f8b:	e8 00 cb ff ff       	call   100a90 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  103f90:	c7 04 24 cc 6f 10 00 	movl   $0x106fcc,(%esp)
  103f97:	e8 f4 ca ff ff       	call   100a90 <panic>
  103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103fa0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
  103fa0:	55                   	push   %ebp
  103fa1:	89 e5                	mov    %esp,%ebp
  103fa3:	83 ec 18             	sub    $0x18,%esp
  103fa6:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103fa9:	8b 0a                	mov    (%edx),%ecx
  103fab:	85 c9                	test   %ecx,%ecx
  103fad:	74 0c                	je     103fbb <release+0x1b>
  103faf:	8b 42 08             	mov    0x8(%edx),%eax
  103fb2:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103fb9:	74 0d                	je     103fc8 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
  103fbb:	c7 04 24 ea 6f 10 00 	movl   $0x106fea,(%esp)
  103fc2:	e8 c9 ca ff ff       	call   100a90 <panic>
  103fc7:	90                   	nop

  lk->pcs[0] = 0;
  103fc8:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103fcf:	31 c0                	xor    %eax,%eax
  lk->cpu = 0;
  103fd1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
  103fd8:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
}
  103fdb:	c9                   	leave  
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
  103fdc:	e9 5f ff ff ff       	jmp    103f40 <popcli>
  103fe1:	eb 0d                	jmp    103ff0 <acquire>
  103fe3:	90                   	nop
  103fe4:	90                   	nop
  103fe5:	90                   	nop
  103fe6:	90                   	nop
  103fe7:	90                   	nop
  103fe8:	90                   	nop
  103fe9:	90                   	nop
  103fea:	90                   	nop
  103feb:	90                   	nop
  103fec:	90                   	nop
  103fed:	90                   	nop
  103fee:	90                   	nop
  103fef:	90                   	nop

00103ff0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  103ff0:	55                   	push   %ebp
  103ff1:	89 e5                	mov    %esp,%ebp
  103ff3:	53                   	push   %ebx
  103ff4:	83 ec 14             	sub    $0x14,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103ff7:	9c                   	pushf  
  103ff8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103ff9:	fa                   	cli    
{
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103ffa:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  104001:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  104007:	8d 48 01             	lea    0x1(%eax),%ecx
  10400a:	85 c0                	test   %eax,%eax
  10400c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
  104012:	75 12                	jne    104026 <acquire+0x36>
    cpu->intena = eflags & FL_IF;
  104014:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10401a:	81 e3 00 02 00 00    	and    $0x200,%ebx
  104020:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
  104026:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  104029:	8b 1a                	mov    (%edx),%ebx
  10402b:	85 db                	test   %ebx,%ebx
  10402d:	74 0c                	je     10403b <acquire+0x4b>
  10402f:	8b 42 08             	mov    0x8(%edx),%eax
  104032:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  104039:	74 45                	je     104080 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10403b:	b9 01 00 00 00       	mov    $0x1,%ecx
  104040:	eb 09                	jmp    10404b <acquire+0x5b>
  104042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
  104048:	8b 55 08             	mov    0x8(%ebp),%edx
  10404b:	89 c8                	mov    %ecx,%eax
  10404d:	f0 87 02             	lock xchg %eax,(%edx)
  104050:	85 c0                	test   %eax,%eax
  104052:	75 f4                	jne    104048 <acquire+0x58>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  104054:	8b 45 08             	mov    0x8(%ebp),%eax
  104057:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  10405e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
  104061:	8b 45 08             	mov    0x8(%ebp),%eax
  104064:	83 c0 0c             	add    $0xc,%eax
  104067:	89 44 24 04          	mov    %eax,0x4(%esp)
  10406b:	8d 45 08             	lea    0x8(%ebp),%eax
  10406e:	89 04 24             	mov    %eax,(%esp)
  104071:	e8 0a fe ff ff       	call   103e80 <getcallerpcs>
}
  104076:	83 c4 14             	add    $0x14,%esp
  104079:	5b                   	pop    %ebx
  10407a:	5d                   	pop    %ebp
  10407b:	c3                   	ret    
  10407c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
    panic("acquire");
  104080:	c7 04 24 f2 6f 10 00 	movl   $0x106ff2,(%esp)
  104087:	e8 04 ca ff ff       	call   100a90 <panic>
  10408c:	90                   	nop
  10408d:	90                   	nop
  10408e:	90                   	nop
  10408f:	90                   	nop

00104090 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  104090:	55                   	push   %ebp
  104091:	89 e5                	mov    %esp,%ebp
  104093:	8b 55 08             	mov    0x8(%ebp),%edx
  104096:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  104097:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10409a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10409d:	89 d7                	mov    %edx,%edi
  10409f:	fc                   	cld    
  1040a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  1040a2:	89 d0                	mov    %edx,%eax
  1040a4:	5f                   	pop    %edi
  1040a5:	5d                   	pop    %ebp
  1040a6:	c3                   	ret    
  1040a7:	89 f6                	mov    %esi,%esi
  1040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001040b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  1040b0:	55                   	push   %ebp
  1040b1:	89 e5                	mov    %esp,%ebp
  1040b3:	57                   	push   %edi
  1040b4:	56                   	push   %esi
  1040b5:	53                   	push   %ebx
  1040b6:	8b 55 10             	mov    0x10(%ebp),%edx
  1040b9:	8b 75 08             	mov    0x8(%ebp),%esi
  1040bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1040bf:	85 d2                	test   %edx,%edx
  1040c1:	74 2d                	je     1040f0 <memcmp+0x40>
    if(*s1 != *s2)
  1040c3:	0f b6 1e             	movzbl (%esi),%ebx
  1040c6:	0f b6 0f             	movzbl (%edi),%ecx
  1040c9:	38 cb                	cmp    %cl,%bl
  1040cb:	75 2b                	jne    1040f8 <memcmp+0x48>
      return *s1 - *s2;
  1040cd:	83 ea 01             	sub    $0x1,%edx
  1040d0:	31 c0                	xor    %eax,%eax
  1040d2:	eb 18                	jmp    1040ec <memcmp+0x3c>
  1040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1040d8:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  1040dd:	83 ea 01             	sub    $0x1,%edx
  1040e0:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  1040e5:	83 c0 01             	add    $0x1,%eax
  1040e8:	38 cb                	cmp    %cl,%bl
  1040ea:	75 0c                	jne    1040f8 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1040ec:	85 d2                	test   %edx,%edx
  1040ee:	75 e8                	jne    1040d8 <memcmp+0x28>
  1040f0:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1040f2:	5b                   	pop    %ebx
  1040f3:	5e                   	pop    %esi
  1040f4:	5f                   	pop    %edi
  1040f5:	5d                   	pop    %ebp
  1040f6:	c3                   	ret    
  1040f7:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1040f8:	0f b6 c3             	movzbl %bl,%eax
  1040fb:	0f b6 c9             	movzbl %cl,%ecx
  1040fe:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104100:	5b                   	pop    %ebx
  104101:	5e                   	pop    %esi
  104102:	5f                   	pop    %edi
  104103:	5d                   	pop    %ebp
  104104:	c3                   	ret    
  104105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104110 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104110:	55                   	push   %ebp
  104111:	89 e5                	mov    %esp,%ebp
  104113:	57                   	push   %edi
  104114:	56                   	push   %esi
  104115:	53                   	push   %ebx
  104116:	8b 45 08             	mov    0x8(%ebp),%eax
  104119:	8b 75 0c             	mov    0xc(%ebp),%esi
  10411c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10411f:	39 c6                	cmp    %eax,%esi
  104121:	73 2d                	jae    104150 <memmove+0x40>
  104123:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  104126:	39 f8                	cmp    %edi,%eax
  104128:	73 26                	jae    104150 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  10412a:	85 db                	test   %ebx,%ebx
  10412c:	74 1d                	je     10414b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  10412e:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  104131:	31 d2                	xor    %edx,%edx
  104133:	90                   	nop
  104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104138:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  10413d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  104141:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104144:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  104147:	85 c9                	test   %ecx,%ecx
  104149:	75 ed                	jne    104138 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10414b:	5b                   	pop    %ebx
  10414c:	5e                   	pop    %esi
  10414d:	5f                   	pop    %edi
  10414e:	5d                   	pop    %ebp
  10414f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104150:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104152:	85 db                	test   %ebx,%ebx
  104154:	74 f5                	je     10414b <memmove+0x3b>
  104156:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104158:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  10415c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  10415f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104162:	39 d3                	cmp    %edx,%ebx
  104164:	75 f2                	jne    104158 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  104166:	5b                   	pop    %ebx
  104167:	5e                   	pop    %esi
  104168:	5f                   	pop    %edi
  104169:	5d                   	pop    %ebp
  10416a:	c3                   	ret    
  10416b:	90                   	nop
  10416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104170 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  104170:	55                   	push   %ebp
  104171:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
  104173:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
  104174:	e9 97 ff ff ff       	jmp    104110 <memmove>
  104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104180 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
  104180:	55                   	push   %ebp
  104181:	89 e5                	mov    %esp,%ebp
  104183:	57                   	push   %edi
  104184:	56                   	push   %esi
  104185:	53                   	push   %ebx
  104186:	8b 7d 10             	mov    0x10(%ebp),%edi
  104189:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10418c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  10418f:	85 ff                	test   %edi,%edi
  104191:	74 3d                	je     1041d0 <strncmp+0x50>
  104193:	0f b6 01             	movzbl (%ecx),%eax
  104196:	84 c0                	test   %al,%al
  104198:	75 18                	jne    1041b2 <strncmp+0x32>
  10419a:	eb 3c                	jmp    1041d8 <strncmp+0x58>
  10419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1041a0:	83 ef 01             	sub    $0x1,%edi
  1041a3:	74 2b                	je     1041d0 <strncmp+0x50>
    n--, p++, q++;
  1041a5:	83 c1 01             	add    $0x1,%ecx
  1041a8:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1041ab:	0f b6 01             	movzbl (%ecx),%eax
  1041ae:	84 c0                	test   %al,%al
  1041b0:	74 26                	je     1041d8 <strncmp+0x58>
  1041b2:	0f b6 33             	movzbl (%ebx),%esi
  1041b5:	89 f2                	mov    %esi,%edx
  1041b7:	38 d0                	cmp    %dl,%al
  1041b9:	74 e5                	je     1041a0 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  1041bb:	81 e6 ff 00 00 00    	and    $0xff,%esi
  1041c1:	0f b6 c0             	movzbl %al,%eax
  1041c4:	29 f0                	sub    %esi,%eax
}
  1041c6:	5b                   	pop    %ebx
  1041c7:	5e                   	pop    %esi
  1041c8:	5f                   	pop    %edi
  1041c9:	5d                   	pop    %ebp
  1041ca:	c3                   	ret    
  1041cb:	90                   	nop
  1041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1041d0:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1041d2:	5b                   	pop    %ebx
  1041d3:	5e                   	pop    %esi
  1041d4:	5f                   	pop    %edi
  1041d5:	5d                   	pop    %ebp
  1041d6:	c3                   	ret    
  1041d7:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1041d8:	0f b6 33             	movzbl (%ebx),%esi
  1041db:	eb de                	jmp    1041bb <strncmp+0x3b>
  1041dd:	8d 76 00             	lea    0x0(%esi),%esi

001041e0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  1041e0:	55                   	push   %ebp
  1041e1:	89 e5                	mov    %esp,%ebp
  1041e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1041e6:	56                   	push   %esi
  1041e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1041ea:	53                   	push   %ebx
  1041eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  1041ee:	89 c3                	mov    %eax,%ebx
  1041f0:	eb 09                	jmp    1041fb <strncpy+0x1b>
  1041f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1041f8:	83 c6 01             	add    $0x1,%esi
  1041fb:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  1041fe:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104201:	85 d2                	test   %edx,%edx
  104203:	7e 0c                	jle    104211 <strncpy+0x31>
  104205:	0f b6 16             	movzbl (%esi),%edx
  104208:	88 13                	mov    %dl,(%ebx)
  10420a:	83 c3 01             	add    $0x1,%ebx
  10420d:	84 d2                	test   %dl,%dl
  10420f:	75 e7                	jne    1041f8 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104211:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104213:	85 c9                	test   %ecx,%ecx
  104215:	7e 0c                	jle    104223 <strncpy+0x43>
  104217:	90                   	nop
    *s++ = 0;
  104218:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10421c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10421f:	39 ca                	cmp    %ecx,%edx
  104221:	75 f5                	jne    104218 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  104223:	5b                   	pop    %ebx
  104224:	5e                   	pop    %esi
  104225:	5d                   	pop    %ebp
  104226:	c3                   	ret    
  104227:	89 f6                	mov    %esi,%esi
  104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104230 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104230:	55                   	push   %ebp
  104231:	89 e5                	mov    %esp,%ebp
  104233:	8b 55 10             	mov    0x10(%ebp),%edx
  104236:	56                   	push   %esi
  104237:	8b 45 08             	mov    0x8(%ebp),%eax
  10423a:	53                   	push   %ebx
  10423b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10423e:	85 d2                	test   %edx,%edx
  104240:	7e 1f                	jle    104261 <safestrcpy+0x31>
  104242:	89 c1                	mov    %eax,%ecx
  104244:	eb 05                	jmp    10424b <safestrcpy+0x1b>
  104246:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104248:	83 c6 01             	add    $0x1,%esi
  10424b:	83 ea 01             	sub    $0x1,%edx
  10424e:	85 d2                	test   %edx,%edx
  104250:	7e 0c                	jle    10425e <safestrcpy+0x2e>
  104252:	0f b6 1e             	movzbl (%esi),%ebx
  104255:	88 19                	mov    %bl,(%ecx)
  104257:	83 c1 01             	add    $0x1,%ecx
  10425a:	84 db                	test   %bl,%bl
  10425c:	75 ea                	jne    104248 <safestrcpy+0x18>
    ;
  *s = 0;
  10425e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  104261:	5b                   	pop    %ebx
  104262:	5e                   	pop    %esi
  104263:	5d                   	pop    %ebp
  104264:	c3                   	ret    
  104265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104270 <strlen>:

int
strlen(const char *s)
{
  104270:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104271:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104273:	89 e5                	mov    %esp,%ebp
  104275:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104278:	80 3a 00             	cmpb   $0x0,(%edx)
  10427b:	74 0c                	je     104289 <strlen+0x19>
  10427d:	8d 76 00             	lea    0x0(%esi),%esi
  104280:	83 c0 01             	add    $0x1,%eax
  104283:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104287:	75 f7                	jne    104280 <strlen+0x10>
    ;
  return n;
}
  104289:	5d                   	pop    %ebp
  10428a:	c3                   	ret    
  10428b:	90                   	nop

0010428c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
  10428c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
  104290:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
  104294:	55                   	push   %ebp
  pushl %ebx
  104295:	53                   	push   %ebx
  pushl %esi
  104296:	56                   	push   %esi
  pushl %edi
  104297:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
  104298:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
  10429a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
  10429c:	5f                   	pop    %edi
  popl %esi
  10429d:	5e                   	pop    %esi
  popl %ebx
  10429e:	5b                   	pop    %ebx
  popl %ebp
  10429f:	5d                   	pop    %ebp
  ret
  1042a0:	c3                   	ret    
  1042a1:	90                   	nop
  1042a2:	90                   	nop
  1042a3:	90                   	nop
  1042a4:	90                   	nop
  1042a5:	90                   	nop
  1042a6:	90                   	nop
  1042a7:	90                   	nop
  1042a8:	90                   	nop
  1042a9:	90                   	nop
  1042aa:	90                   	nop
  1042ab:	90                   	nop
  1042ac:	90                   	nop
  1042ad:	90                   	nop
  1042ae:	90                   	nop
  1042af:	90                   	nop

001042b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1042b0:	55                   	push   %ebp
  1042b1:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
  1042b3:	8b 55 08             	mov    0x8(%ebp),%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  1042b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  1042b9:	8b 12                	mov    (%edx),%edx
  1042bb:	39 c2                	cmp    %eax,%edx
  1042bd:	77 09                	ja     1042c8 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
  return 0;
  1042bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1042c4:	5d                   	pop    %ebp
  1042c5:	c3                   	ret    
  1042c6:	66 90                	xchg   %ax,%ax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042c8:	8d 48 04             	lea    0x4(%eax),%ecx
  1042cb:	39 ca                	cmp    %ecx,%edx
  1042cd:	72 f0                	jb     1042bf <fetchint+0xf>
    return -1;
  *ip = *(int*)(addr);
  1042cf:	8b 10                	mov    (%eax),%edx
  1042d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1042d4:	89 10                	mov    %edx,(%eax)
  1042d6:	31 c0                	xor    %eax,%eax
  return 0;
}
  1042d8:	5d                   	pop    %ebp
  1042d9:	c3                   	ret    
  1042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001042e0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1042e0:	55                   	push   %ebp
  1042e1:	89 e5                	mov    %esp,%ebp
  1042e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1042e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042e9:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  1042ea:	39 10                	cmp    %edx,(%eax)
  1042ec:	77 0a                	ja     1042f8 <fetchstr+0x18>
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  1042ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1042f3:	5b                   	pop    %ebx
  1042f4:	5d                   	pop    %ebp
  1042f5:	c3                   	ret    
  1042f6:	66 90                	xchg   %ax,%ax
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  1042f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1042fb:	89 11                	mov    %edx,(%ecx)
  ep = (char *) p->sz;
  1042fd:	8b 18                	mov    (%eax),%ebx
  for(s = *pp; s < ep; s++)
  1042ff:	39 da                	cmp    %ebx,%edx
  104301:	73 eb                	jae    1042ee <fetchstr+0xe>
    if(*s == 0)
  104303:	31 c0                	xor    %eax,%eax
  104305:	89 d1                	mov    %edx,%ecx
  104307:	80 3a 00             	cmpb   $0x0,(%edx)
  10430a:	74 e7                	je     1042f3 <fetchstr+0x13>
  10430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  104310:	83 c1 01             	add    $0x1,%ecx
  104313:	39 cb                	cmp    %ecx,%ebx
  104315:	76 d7                	jbe    1042ee <fetchstr+0xe>
    if(*s == 0)
  104317:	80 39 00             	cmpb   $0x0,(%ecx)
  10431a:	75 f4                	jne    104310 <fetchstr+0x30>
  10431c:	89 c8                	mov    %ecx,%eax
  10431e:	29 d0                	sub    %edx,%eax
  104320:	eb d1                	jmp    1042f3 <fetchstr+0x13>
  104322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104330 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104330:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104336:	55                   	push   %ebp
  104337:	89 e5                	mov    %esp,%ebp
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104339:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10433c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10433f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104341:	8b 52 44             	mov    0x44(%edx),%edx
  104344:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104348:	39 c2                	cmp    %eax,%edx
  10434a:	72 0c                	jb     104358 <argint+0x28>
    return -1;
  *ip = *(int*)(addr);
  10434c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  return x;
}
  104351:	5d                   	pop    %ebp
  104352:	c3                   	ret    
  104353:	90                   	nop
  104354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104358:	8d 4a 04             	lea    0x4(%edx),%ecx
  10435b:	39 c8                	cmp    %ecx,%eax
  10435d:	72 ed                	jb     10434c <argint+0x1c>
    return -1;
  *ip = *(int*)(addr);
  10435f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104362:	8b 12                	mov    (%edx),%edx
  104364:	89 10                	mov    %edx,(%eax)
  104366:	31 c0                	xor    %eax,%eax
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  return x;
}
  104368:	5d                   	pop    %ebp
  104369:	c3                   	ret    
  10436a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104370 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104370:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104376:	55                   	push   %ebp
  104377:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10437c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10437f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104381:	8b 52 44             	mov    0x44(%edx),%edx
  104384:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104388:	39 c2                	cmp    %eax,%edx
  10438a:	73 07                	jae    104393 <argptr+0x23>
  10438c:	8d 4a 04             	lea    0x4(%edx),%ecx
  10438f:	39 c8                	cmp    %ecx,%eax
  104391:	73 0d                	jae    1043a0 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
    return -1;
  *pp = (char *) i;
  return 0;
  104393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104398:	5d                   	pop    %ebp
  104399:	c3                   	ret    
  10439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(addr);
  1043a0:	8b 12                	mov    (%edx),%edx
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
  1043a2:	39 c2                	cmp    %eax,%edx
  1043a4:	73 ed                	jae    104393 <argptr+0x23>
  1043a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1043a9:	01 d1                	add    %edx,%ecx
  1043ab:	39 c1                	cmp    %eax,%ecx
  1043ad:	73 e4                	jae    104393 <argptr+0x23>
    return -1;
  *pp = (char *) i;
  1043af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043b2:	89 10                	mov    %edx,(%eax)
  1043b4:	31 c0                	xor    %eax,%eax
  return 0;
}
  1043b6:	5d                   	pop    %ebp
  1043b7:	c3                   	ret    
  1043b8:	90                   	nop
  1043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001043c0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1043c0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  1043c7:	55                   	push   %ebp
  1043c8:	89 e5                	mov    %esp,%ebp
  1043ca:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1043cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1043ce:	8b 42 18             	mov    0x18(%edx),%eax
  1043d1:	8b 40 44             	mov    0x44(%eax),%eax
  1043d4:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1043d8:	8b 0a                	mov    (%edx),%ecx
  1043da:	39 c8                	cmp    %ecx,%eax
  1043dc:	73 07                	jae    1043e5 <argstr+0x25>
  1043de:	8d 58 04             	lea    0x4(%eax),%ebx
  1043e1:	39 d9                	cmp    %ebx,%ecx
  1043e3:	73 0b                	jae    1043f0 <argstr+0x30>

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  1043e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  1043ea:	5b                   	pop    %ebx
  1043eb:	5d                   	pop    %ebp
  1043ec:	c3                   	ret    
  1043ed:	8d 76 00             	lea    0x0(%esi),%esi
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(addr);
  1043f0:	8b 18                	mov    (%eax),%ebx
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  1043f2:	39 cb                	cmp    %ecx,%ebx
  1043f4:	73 ef                	jae    1043e5 <argstr+0x25>
    return -1;
  *pp = (char *) addr;
  1043f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1043f9:	89 d8                	mov    %ebx,%eax
  1043fb:	89 19                	mov    %ebx,(%ecx)
  ep = (char *) p->sz;
  1043fd:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
  1043ff:	39 d3                	cmp    %edx,%ebx
  104401:	73 e2                	jae    1043e5 <argstr+0x25>
    if(*s == 0)
  104403:	80 3b 00             	cmpb   $0x0,(%ebx)
  104406:	75 12                	jne    10441a <argstr+0x5a>
  104408:	eb 1e                	jmp    104428 <argstr+0x68>
  10440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104410:	80 38 00             	cmpb   $0x0,(%eax)
  104413:	90                   	nop
  104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104418:	74 0e                	je     104428 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  10441a:	83 c0 01             	add    $0x1,%eax
  10441d:	39 c2                	cmp    %eax,%edx
  10441f:	90                   	nop
  104420:	77 ee                	ja     104410 <argstr+0x50>
  104422:	eb c1                	jmp    1043e5 <argstr+0x25>
  104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
  104428:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  10442a:	5b                   	pop    %ebx
  10442b:	5d                   	pop    %ebp
  10442c:	c3                   	ret    
  10442d:	8d 76 00             	lea    0x0(%esi),%esi

00104430 <syscall>:
[SYS_nice]    sys_nice,
};

void
syscall(void)
{
  104430:	55                   	push   %ebp
  104431:	89 e5                	mov    %esp,%ebp
  104433:	53                   	push   %ebx
  104434:	83 ec 14             	sub    $0x14,%esp
  int num;
  
  num = proc->tf->eax;
  104437:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10443e:	8b 5a 18             	mov    0x18(%edx),%ebx
  104441:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104444:	83 f8 17             	cmp    $0x17,%eax
  104447:	77 17                	ja     104460 <syscall+0x30>
  104449:	8b 0c 85 20 70 10 00 	mov    0x107020(,%eax,4),%ecx
  104450:	85 c9                	test   %ecx,%ecx
  104452:	74 0c                	je     104460 <syscall+0x30>
    proc->tf->eax = syscalls[num]();
  104454:	ff d1                	call   *%ecx
  104456:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
  104459:	83 c4 14             	add    $0x14,%esp
  10445c:	5b                   	pop    %ebx
  10445d:	5d                   	pop    %ebp
  10445e:	c3                   	ret    
  10445f:	90                   	nop
  
  num = proc->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    proc->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104460:	8b 4a 10             	mov    0x10(%edx),%ecx
  104463:	83 c2 6c             	add    $0x6c,%edx
  104466:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10446a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10446e:	c7 04 24 fa 6f 10 00 	movl   $0x106ffa,(%esp)
  104475:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104479:	e8 42 c0 ff ff       	call   1004c0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  10447e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104484:	8b 40 18             	mov    0x18(%eax),%eax
  104487:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  10448e:	83 c4 14             	add    $0x14,%esp
  104491:	5b                   	pop    %ebx
  104492:	5d                   	pop    %ebp
  104493:	c3                   	ret    
  104494:	90                   	nop
  104495:	90                   	nop
  104496:	90                   	nop
  104497:	90                   	nop
  104498:	90                   	nop
  104499:	90                   	nop
  10449a:	90                   	nop
  10449b:	90                   	nop
  10449c:	90                   	nop
  10449d:	90                   	nop
  10449e:	90                   	nop
  10449f:	90                   	nop

001044a0 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  1044a0:	55                   	push   %ebp
  1044a1:	89 e5                	mov    %esp,%ebp
  1044a3:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  1044a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
  1044a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  1044ac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  1044af:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  1044b6:	00 
  1044b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1044c2:	e8 a9 fe ff ff       	call   104370 <argptr>
  1044c7:	85 c0                	test   %eax,%eax
  1044c9:	79 15                	jns    1044e0 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  1044cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
  1044d0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1044d3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1044d6:	89 ec                	mov    %ebp,%esp
  1044d8:	5d                   	pop    %ebp
  1044d9:	c3                   	ret    
  1044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  1044e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1044e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1044ea:	89 04 24             	mov    %eax,(%esp)
  1044ed:	e8 ce eb ff ff       	call   1030c0 <pipealloc>
  1044f2:	85 c0                	test   %eax,%eax
  1044f4:	78 d5                	js     1044cb <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1044f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1044f9:	31 c0                	xor    %eax,%eax
  1044fb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104508:	8b 5c 82 28          	mov    0x28(%edx,%eax,4),%ebx
  10450c:	85 db                	test   %ebx,%ebx
  10450e:	74 28                	je     104538 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104510:	83 c0 01             	add    $0x1,%eax
  104513:	83 f8 10             	cmp    $0x10,%eax
  104516:	75 f0                	jne    104508 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
  104518:	89 0c 24             	mov    %ecx,(%esp)
  10451b:	e8 20 cc ff ff       	call   101140 <fileclose>
    fileclose(wf);
  104520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104523:	89 04 24             	mov    %eax,(%esp)
  104526:	e8 15 cc ff ff       	call   101140 <fileclose>
  10452b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104530:	eb 9e                	jmp    1044d0 <sys_pipe+0x30>
  104532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104538:	8d 58 08             	lea    0x8(%eax),%ebx
  10453b:	89 4c 9a 08          	mov    %ecx,0x8(%edx,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  10453f:	8b 75 ec             	mov    -0x14(%ebp),%esi
  104542:	31 d2                	xor    %edx,%edx
  104544:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  10454b:	90                   	nop
  10454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104550:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
  104555:	74 19                	je     104570 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104557:	83 c2 01             	add    $0x1,%edx
  10455a:	83 fa 10             	cmp    $0x10,%edx
  10455d:	75 f1                	jne    104550 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
  10455f:	c7 44 99 08 00 00 00 	movl   $0x0,0x8(%ecx,%ebx,4)
  104566:	00 
  104567:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10456a:	eb ac                	jmp    104518 <sys_pipe+0x78>
  10456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104570:	89 74 91 28          	mov    %esi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104574:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  104577:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
  104579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10457c:	89 50 04             	mov    %edx,0x4(%eax)
  10457f:	31 c0                	xor    %eax,%eax
  return 0;
  104581:	e9 4a ff ff ff       	jmp    1044d0 <sys_pipe+0x30>
  104586:	8d 76 00             	lea    0x0(%esi),%esi
  104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104590 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104590:	55                   	push   %ebp
  104591:	89 e5                	mov    %esp,%ebp
  104593:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  104599:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  10459c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10459f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1045a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  1045a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1045b0:	e8 0b fe ff ff       	call   1043c0 <argstr>
  1045b5:	85 c0                	test   %eax,%eax
  1045b7:	79 17                	jns    1045d0 <sys_exec+0x40>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  1045b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  1045be:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  1045c1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1045c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1045c7:	89 ec                	mov    %ebp,%esp
  1045c9:	5d                   	pop    %ebp
  1045ca:	c3                   	ret    
  1045cb:	90                   	nop
  1045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  1045d0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1045d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045de:	e8 4d fd ff ff       	call   104330 <argint>
  1045e3:	85 c0                	test   %eax,%eax
  1045e5:	78 d2                	js     1045b9 <sys_exec+0x29>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  1045e7:	8d 7d 8c             	lea    -0x74(%ebp),%edi
  1045ea:	31 f6                	xor    %esi,%esi
  1045ec:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  1045f3:	00 
  1045f4:	31 db                	xor    %ebx,%ebx
  1045f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045fd:	00 
  1045fe:	89 3c 24             	mov    %edi,(%esp)
  104601:	e8 8a fa ff ff       	call   104090 <memset>
  104606:	eb 27                	jmp    10462f <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
  104608:	89 44 24 04          	mov    %eax,0x4(%esp)
  10460c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104612:	8d 14 b7             	lea    (%edi,%esi,4),%edx
  104615:	89 54 24 08          	mov    %edx,0x8(%esp)
  104619:	89 04 24             	mov    %eax,(%esp)
  10461c:	e8 bf fc ff ff       	call   1042e0 <fetchstr>
  104621:	85 c0                	test   %eax,%eax
  104623:	78 94                	js     1045b9 <sys_exec+0x29>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  104625:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  104628:	83 fb 14             	cmp    $0x14,%ebx

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  10462b:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
  10462d:	74 8a                	je     1045b9 <sys_exec+0x29>
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
  10462f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  104632:	89 44 24 08          	mov    %eax,0x8(%esp)
  104636:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  10463d:	03 45 e0             	add    -0x20(%ebp),%eax
  104640:	89 44 24 04          	mov    %eax,0x4(%esp)
  104644:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10464a:	89 04 24             	mov    %eax,(%esp)
  10464d:	e8 5e fc ff ff       	call   1042b0 <fetchint>
  104652:	85 c0                	test   %eax,%eax
  104654:	0f 88 5f ff ff ff    	js     1045b9 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  10465a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10465d:	85 c0                	test   %eax,%eax
  10465f:	75 a7                	jne    104608 <sys_exec+0x78>
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104664:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  10466b:	00 
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  10466c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104670:	89 04 24             	mov    %eax,(%esp)
  104673:	e8 98 c4 ff ff       	call   100b10 <exec>
  104678:	e9 41 ff ff ff       	jmp    1045be <sys_exec+0x2e>
  10467d:	8d 76 00             	lea    0x0(%esi),%esi

00104680 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104680:	55                   	push   %ebp
  104681:	89 e5                	mov    %esp,%ebp
  104683:	53                   	push   %ebx
  104684:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104687:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10468a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10468e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104695:	e8 26 fd ff ff       	call   1043c0 <argstr>
  10469a:	85 c0                	test   %eax,%eax
  10469c:	79 12                	jns    1046b0 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  proc->cwd = ip;
  return 0;
  10469e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1046a3:	83 c4 24             	add    $0x24,%esp
  1046a6:	5b                   	pop    %ebx
  1046a7:	5d                   	pop    %ebp
  1046a8:	c3                   	ret    
  1046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  1046b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046b3:	89 04 24             	mov    %eax,(%esp)
  1046b6:	e8 55 d9 ff ff       	call   102010 <namei>
  1046bb:	85 c0                	test   %eax,%eax
  1046bd:	89 c3                	mov    %eax,%ebx
  1046bf:	74 dd                	je     10469e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  1046c1:	89 04 24             	mov    %eax,(%esp)
  1046c4:	e8 a7 d6 ff ff       	call   101d70 <ilock>
  if(ip->type != T_DIR){
  1046c9:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1046ce:	75 26                	jne    1046f6 <sys_chdir+0x76>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1046d0:	89 1c 24             	mov    %ebx,(%esp)
  1046d3:	e8 58 d2 ff ff       	call   101930 <iunlock>
  iput(proc->cwd);
  1046d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1046de:	8b 40 68             	mov    0x68(%eax),%eax
  1046e1:	89 04 24             	mov    %eax,(%esp)
  1046e4:	e8 57 d3 ff ff       	call   101a40 <iput>
  proc->cwd = ip;
  1046e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1046ef:	89 58 68             	mov    %ebx,0x68(%eax)
  1046f2:	31 c0                	xor    %eax,%eax
  return 0;
  1046f4:	eb ad                	jmp    1046a3 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  1046f6:	89 1c 24             	mov    %ebx,(%esp)
  1046f9:	e8 82 d5 ff ff       	call   101c80 <iunlockput>
  1046fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104703:	eb 9e                	jmp    1046a3 <sys_chdir+0x23>
  104705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104710 <create>:
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  104710:	55                   	push   %ebp
  104711:	89 e5                	mov    %esp,%ebp
  104713:	83 ec 58             	sub    $0x58,%esp
  104716:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  104719:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10471c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  10471f:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  104722:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  104725:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  104727:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10472a:	89 d7                	mov    %edx,%edi
  10472c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  10472f:	89 74 24 04          	mov    %esi,0x4(%esp)
  104733:	89 04 24             	mov    %eax,(%esp)
  104736:	e8 b5 d8 ff ff       	call   101ff0 <nameiparent>
  10473b:	85 c0                	test   %eax,%eax
  10473d:	74 47                	je     104786 <create+0x76>
    return 0;
  ilock(dp);
  10473f:	89 04 24             	mov    %eax,(%esp)
  104742:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104745:	e8 26 d6 ff ff       	call   101d70 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
  10474a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10474d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104750:	89 44 24 08          	mov    %eax,0x8(%esp)
  104754:	89 74 24 04          	mov    %esi,0x4(%esp)
  104758:	89 14 24             	mov    %edx,(%esp)
  10475b:	e8 d0 d0 ff ff       	call   101830 <dirlookup>
  104760:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104763:	85 c0                	test   %eax,%eax
  104765:	89 c3                	mov    %eax,%ebx
  104767:	74 3f                	je     1047a8 <create+0x98>
    iunlockput(dp);
  104769:	89 14 24             	mov    %edx,(%esp)
  10476c:	e8 0f d5 ff ff       	call   101c80 <iunlockput>
    ilock(ip);
  104771:	89 1c 24             	mov    %ebx,(%esp)
  104774:	e8 f7 d5 ff ff       	call   101d70 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
  104779:	66 83 ff 02          	cmp    $0x2,%di
  10477d:	75 19                	jne    104798 <create+0x88>
  10477f:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
  104784:	75 12                	jne    104798 <create+0x88>
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  return ip;
}
  104786:	89 d8                	mov    %ebx,%eax
  104788:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10478b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10478e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104791:	89 ec                	mov    %ebp,%esp
  104793:	5d                   	pop    %ebp
  104794:	c3                   	ret    
  104795:	8d 76 00             	lea    0x0(%esi),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
  104798:	89 1c 24             	mov    %ebx,(%esp)
  10479b:	31 db                	xor    %ebx,%ebx
  10479d:	e8 de d4 ff ff       	call   101c80 <iunlockput>
    return 0;
  1047a2:	eb e2                	jmp    104786 <create+0x76>
  1047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  1047a8:	0f bf c7             	movswl %di,%eax
  1047ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047af:	8b 02                	mov    (%edx),%eax
  1047b1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1047b4:	89 04 24             	mov    %eax,(%esp)
  1047b7:	e8 e4 d4 ff ff       	call   101ca0 <ialloc>
  1047bc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1047bf:	85 c0                	test   %eax,%eax
  1047c1:	89 c3                	mov    %eax,%ebx
  1047c3:	0f 84 b7 00 00 00    	je     104880 <create+0x170>
    panic("create: ialloc");

  ilock(ip);
  1047c9:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1047cc:	89 04 24             	mov    %eax,(%esp)
  1047cf:	e8 9c d5 ff ff       	call   101d70 <ilock>
  ip->major = major;
  1047d4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  1047d8:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  1047dc:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
  1047e0:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  1047e6:	66 89 4b 14          	mov    %cx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  1047ea:	89 1c 24             	mov    %ebx,(%esp)
  1047ed:	e8 3e ce ff ff       	call   101630 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
  1047f2:	66 83 ff 01          	cmp    $0x1,%di
  1047f6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1047f9:	74 2d                	je     104828 <create+0x118>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
  1047fb:	8b 43 04             	mov    0x4(%ebx),%eax
  1047fe:	89 14 24             	mov    %edx,(%esp)
  104801:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104804:	89 74 24 04          	mov    %esi,0x4(%esp)
  104808:	89 44 24 08          	mov    %eax,0x8(%esp)
  10480c:	e8 7f d3 ff ff       	call   101b90 <dirlink>
  104811:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104814:	85 c0                	test   %eax,%eax
  104816:	78 74                	js     10488c <create+0x17c>
    panic("create: dirlink");

  iunlockput(dp);
  104818:	89 14 24             	mov    %edx,(%esp)
  10481b:	e8 60 d4 ff ff       	call   101c80 <iunlockput>
  return ip;
  104820:	e9 61 ff ff ff       	jmp    104786 <create+0x76>
  104825:	8d 76 00             	lea    0x0(%esi),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  104828:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  10482d:	89 14 24             	mov    %edx,(%esp)
  104830:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104833:	e8 f8 cd ff ff       	call   101630 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104838:	8b 43 04             	mov    0x4(%ebx),%eax
  10483b:	c7 44 24 04 90 70 10 	movl   $0x107090,0x4(%esp)
  104842:	00 
  104843:	89 1c 24             	mov    %ebx,(%esp)
  104846:	89 44 24 08          	mov    %eax,0x8(%esp)
  10484a:	e8 41 d3 ff ff       	call   101b90 <dirlink>
  10484f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104852:	85 c0                	test   %eax,%eax
  104854:	78 1e                	js     104874 <create+0x164>
  104856:	8b 42 04             	mov    0x4(%edx),%eax
  104859:	c7 44 24 04 8f 70 10 	movl   $0x10708f,0x4(%esp)
  104860:	00 
  104861:	89 1c 24             	mov    %ebx,(%esp)
  104864:	89 44 24 08          	mov    %eax,0x8(%esp)
  104868:	e8 23 d3 ff ff       	call   101b90 <dirlink>
  10486d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104870:	85 c0                	test   %eax,%eax
  104872:	79 87                	jns    1047fb <create+0xeb>
      panic("create dots");
  104874:	c7 04 24 92 70 10 00 	movl   $0x107092,(%esp)
  10487b:	e8 10 c2 ff ff       	call   100a90 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
  104880:	c7 04 24 80 70 10 00 	movl   $0x107080,(%esp)
  104887:	e8 04 c2 ff ff       	call   100a90 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
  10488c:	c7 04 24 9e 70 10 00 	movl   $0x10709e,(%esp)
  104893:	e8 f8 c1 ff ff       	call   100a90 <panic>
  104898:	90                   	nop
  104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001048a0 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
  1048a0:	55                   	push   %ebp
  1048a1:	89 e5                	mov    %esp,%ebp
  1048a3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1048a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1048a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048b4:	e8 07 fb ff ff       	call   1043c0 <argstr>
  1048b9:	85 c0                	test   %eax,%eax
  1048bb:	79 0b                	jns    1048c8 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  1048bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048c2:	c9                   	leave  
  1048c3:	c3                   	ret    
  1048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  1048c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1048cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048d6:	e8 55 fa ff ff       	call   104330 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1048db:	85 c0                	test   %eax,%eax
  1048dd:	78 de                	js     1048bd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  1048df:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1048e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1048ed:	e8 3e fa ff ff       	call   104330 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1048f2:	85 c0                	test   %eax,%eax
  1048f4:	78 c7                	js     1048bd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
  1048f6:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  1048fa:	ba 03 00 00 00       	mov    $0x3,%edx
  1048ff:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
  104903:	89 04 24             	mov    %eax,(%esp)
  104906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104909:	e8 02 fe ff ff       	call   104710 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  10490e:	85 c0                	test   %eax,%eax
  104910:	74 ab                	je     1048bd <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104912:	89 04 24             	mov    %eax,(%esp)
  104915:	e8 66 d3 ff ff       	call   101c80 <iunlockput>
  10491a:	31 c0                	xor    %eax,%eax
  return 0;
}
  10491c:	c9                   	leave  
  10491d:	c3                   	ret    
  10491e:	66 90                	xchg   %ax,%ax

00104920 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
  104920:	55                   	push   %ebp
  104921:	89 e5                	mov    %esp,%ebp
  104923:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  104926:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104929:	89 44 24 04          	mov    %eax,0x4(%esp)
  10492d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104934:	e8 87 fa ff ff       	call   1043c0 <argstr>
  104939:	85 c0                	test   %eax,%eax
  10493b:	79 0b                	jns    104948 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  10493d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104942:	c9                   	leave  
  104943:	c3                   	ret    
  104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  104948:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104952:	31 c9                	xor    %ecx,%ecx
  104954:	ba 01 00 00 00       	mov    $0x1,%edx
  104959:	e8 b2 fd ff ff       	call   104710 <create>
  10495e:	85 c0                	test   %eax,%eax
  104960:	74 db                	je     10493d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104962:	89 04 24             	mov    %eax,(%esp)
  104965:	e8 16 d3 ff ff       	call   101c80 <iunlockput>
  10496a:	31 c0                	xor    %eax,%eax
  return 0;
}
  10496c:	c9                   	leave  
  10496d:	c3                   	ret    
  10496e:	66 90                	xchg   %ax,%ax

00104970 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104970:	55                   	push   %ebp
  104971:	89 e5                	mov    %esp,%ebp
  104973:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104976:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104979:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10497c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10497f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104982:	89 44 24 04          	mov    %eax,0x4(%esp)
  104986:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10498d:	e8 2e fa ff ff       	call   1043c0 <argstr>
  104992:	85 c0                	test   %eax,%eax
  104994:	79 12                	jns    1049a8 <sys_link+0x38>
bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104996:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10499b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10499e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  1049a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1049a4:	89 ec                	mov    %ebp,%esp
  1049a6:	5d                   	pop    %ebp
  1049a7:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  1049a8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1049ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049b6:	e8 05 fa ff ff       	call   1043c0 <argstr>
  1049bb:	85 c0                	test   %eax,%eax
  1049bd:	78 d7                	js     104996 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  1049bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1049c2:	89 04 24             	mov    %eax,(%esp)
  1049c5:	e8 46 d6 ff ff       	call   102010 <namei>
  1049ca:	85 c0                	test   %eax,%eax
  1049cc:	89 c3                	mov    %eax,%ebx
  1049ce:	74 c6                	je     104996 <sys_link+0x26>
    return -1;
  ilock(ip);
  1049d0:	89 04 24             	mov    %eax,(%esp)
  1049d3:	e8 98 d3 ff ff       	call   101d70 <ilock>
  if(ip->type == T_DIR){
  1049d8:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  1049dd:	0f 84 86 00 00 00    	je     104a69 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  1049e3:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  1049e8:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  1049eb:	89 1c 24             	mov    %ebx,(%esp)
  1049ee:	e8 3d cc ff ff       	call   101630 <iupdate>
  iunlock(ip);
  1049f3:	89 1c 24             	mov    %ebx,(%esp)
  1049f6:	e8 35 cf ff ff       	call   101930 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  1049fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104a02:	89 04 24             	mov    %eax,(%esp)
  104a05:	e8 e6 d5 ff ff       	call   101ff0 <nameiparent>
  104a0a:	85 c0                	test   %eax,%eax
  104a0c:	89 c6                	mov    %eax,%esi
  104a0e:	74 44                	je     104a54 <sys_link+0xe4>
    goto bad;
  ilock(dp);
  104a10:	89 04 24             	mov    %eax,(%esp)
  104a13:	e8 58 d3 ff ff       	call   101d70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  104a18:	8b 06                	mov    (%esi),%eax
  104a1a:	3b 03                	cmp    (%ebx),%eax
  104a1c:	75 2e                	jne    104a4c <sys_link+0xdc>
  104a1e:	8b 43 04             	mov    0x4(%ebx),%eax
  104a21:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104a25:	89 34 24             	mov    %esi,(%esp)
  104a28:	89 44 24 08          	mov    %eax,0x8(%esp)
  104a2c:	e8 5f d1 ff ff       	call   101b90 <dirlink>
  104a31:	85 c0                	test   %eax,%eax
  104a33:	78 17                	js     104a4c <sys_link+0xdc>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  104a35:	89 34 24             	mov    %esi,(%esp)
  104a38:	e8 43 d2 ff ff       	call   101c80 <iunlockput>
  iput(ip);
  104a3d:	89 1c 24             	mov    %ebx,(%esp)
  104a40:	e8 fb cf ff ff       	call   101a40 <iput>
  104a45:	31 c0                	xor    %eax,%eax
  return 0;
  104a47:	e9 4f ff ff ff       	jmp    10499b <sys_link+0x2b>

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
  104a4c:	89 34 24             	mov    %esi,(%esp)
  104a4f:	e8 2c d2 ff ff       	call   101c80 <iunlockput>
  iunlockput(dp);
  iput(ip);
  return 0;

bad:
  ilock(ip);
  104a54:	89 1c 24             	mov    %ebx,(%esp)
  104a57:	e8 14 d3 ff ff       	call   101d70 <ilock>
  ip->nlink--;
  104a5c:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104a61:	89 1c 24             	mov    %ebx,(%esp)
  104a64:	e8 c7 cb ff ff       	call   101630 <iupdate>
  iunlockput(ip);
  104a69:	89 1c 24             	mov    %ebx,(%esp)
  104a6c:	e8 0f d2 ff ff       	call   101c80 <iunlockput>
  104a71:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104a74:	e9 22 ff ff ff       	jmp    10499b <sys_link+0x2b>
  104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104a80 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104a80:	55                   	push   %ebp
  104a81:	89 e5                	mov    %esp,%ebp
  104a83:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104a89:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104a8c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a9a:	e8 21 f9 ff ff       	call   1043c0 <argstr>
  104a9f:	85 c0                	test   %eax,%eax
  104aa1:	79 15                	jns    104ab8 <sys_open+0x38>

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  104aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
  104aa8:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104aab:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104aae:	89 ec                	mov    %ebp,%esp
  104ab0:	5d                   	pop    %ebp
  104ab1:	c3                   	ret    
  104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104ab8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104abf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ac6:	e8 65 f8 ff ff       	call   104330 <argint>
  104acb:	85 c0                	test   %eax,%eax
  104acd:	78 d4                	js     104aa3 <sys_open+0x23>
    return -1;
  if(omode & O_CREATE){
  104acf:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  104ad3:	74 63                	je     104b38 <sys_open+0xb8>
    if((ip = create(path, T_FILE, 0, 0)) == 0)
  104ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ad8:	31 c9                	xor    %ecx,%ecx
  104ada:	ba 02 00 00 00       	mov    $0x2,%edx
  104adf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104ae6:	e8 25 fc ff ff       	call   104710 <create>
  104aeb:	85 c0                	test   %eax,%eax
  104aed:	89 c3                	mov    %eax,%ebx
  104aef:	74 b2                	je     104aa3 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104af1:	e8 ca c5 ff ff       	call   1010c0 <filealloc>
  104af6:	85 c0                	test   %eax,%eax
  104af8:	89 c6                	mov    %eax,%esi
  104afa:	74 24                	je     104b20 <sys_open+0xa0>
  104afc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104b03:	31 c0                	xor    %eax,%eax
  104b05:	8d 76 00             	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104b08:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
  104b0c:	85 c9                	test   %ecx,%ecx
  104b0e:	74 58                	je     104b68 <sys_open+0xe8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104b10:	83 c0 01             	add    $0x1,%eax
  104b13:	83 f8 10             	cmp    $0x10,%eax
  104b16:	75 f0                	jne    104b08 <sys_open+0x88>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104b18:	89 34 24             	mov    %esi,(%esp)
  104b1b:	e8 20 c6 ff ff       	call   101140 <fileclose>
    iunlockput(ip);
  104b20:	89 1c 24             	mov    %ebx,(%esp)
  104b23:	e8 58 d1 ff ff       	call   101c80 <iunlockput>
  104b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104b2d:	e9 76 ff ff ff       	jmp    104aa8 <sys_open+0x28>
  104b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(omode & O_CREATE){
    if((ip = create(path, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b3b:	89 04 24             	mov    %eax,(%esp)
  104b3e:	e8 cd d4 ff ff       	call   102010 <namei>
  104b43:	85 c0                	test   %eax,%eax
  104b45:	89 c3                	mov    %eax,%ebx
  104b47:	0f 84 56 ff ff ff    	je     104aa3 <sys_open+0x23>
      return -1;
    ilock(ip);
  104b4d:	89 04 24             	mov    %eax,(%esp)
  104b50:	e8 1b d2 ff ff       	call   101d70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
  104b55:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104b5a:	75 95                	jne    104af1 <sys_open+0x71>
  104b5c:	8b 75 f0             	mov    -0x10(%ebp),%esi
  104b5f:	85 f6                	test   %esi,%esi
  104b61:	74 8e                	je     104af1 <sys_open+0x71>
  104b63:	eb bb                	jmp    104b20 <sys_open+0xa0>
  104b65:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104b68:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104b6f:	89 1c 24             	mov    %ebx,(%esp)
  104b72:	e8 b9 cd ff ff       	call   101930 <iunlock>

  f->type = FD_INODE;
  104b77:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  104b7d:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
  104b80:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  104b87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104b8a:	83 f2 01             	xor    $0x1,%edx
  104b8d:	83 e2 01             	and    $0x1,%edx
  104b90:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104b93:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  104b97:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
  104b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b9e:	e9 05 ff ff ff       	jmp    104aa8 <sys_open+0x28>
  104ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104bb0 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104bb0:	55                   	push   %ebp
  104bb1:	89 e5                	mov    %esp,%ebp
  104bb3:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104bb6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104bb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104bbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104bbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104bc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104bcd:	e8 ee f7 ff ff       	call   1043c0 <argstr>
  104bd2:	85 c0                	test   %eax,%eax
  104bd4:	79 12                	jns    104be8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104bdb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104bde:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104be1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104be4:	89 ec                	mov    %ebp,%esp
  104be6:	5d                   	pop    %ebp
  104be7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104be8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104beb:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  104bee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104bf2:	89 04 24             	mov    %eax,(%esp)
  104bf5:	e8 f6 d3 ff ff       	call   101ff0 <nameiparent>
  104bfa:	85 c0                	test   %eax,%eax
  104bfc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104bff:	74 d5                	je     104bd6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104c01:	89 04 24             	mov    %eax,(%esp)
  104c04:	e8 67 d1 ff ff       	call   101d70 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104c09:	c7 44 24 04 90 70 10 	movl   $0x107090,0x4(%esp)
  104c10:	00 
  104c11:	89 1c 24             	mov    %ebx,(%esp)
  104c14:	e8 e7 cb ff ff       	call   101800 <namecmp>
  104c19:	85 c0                	test   %eax,%eax
  104c1b:	0f 84 a4 00 00 00    	je     104cc5 <sys_unlink+0x115>
  104c21:	c7 44 24 04 8f 70 10 	movl   $0x10708f,0x4(%esp)
  104c28:	00 
  104c29:	89 1c 24             	mov    %ebx,(%esp)
  104c2c:	e8 cf cb ff ff       	call   101800 <namecmp>
  104c31:	85 c0                	test   %eax,%eax
  104c33:	0f 84 8c 00 00 00    	je     104cc5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104c39:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104c3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c40:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104c43:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104c47:	89 04 24             	mov    %eax,(%esp)
  104c4a:	e8 e1 cb ff ff       	call   101830 <dirlookup>
  104c4f:	85 c0                	test   %eax,%eax
  104c51:	89 c6                	mov    %eax,%esi
  104c53:	74 70                	je     104cc5 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104c55:	89 04 24             	mov    %eax,(%esp)
  104c58:	e8 13 d1 ff ff       	call   101d70 <ilock>

  if(ip->nlink < 1)
  104c5d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104c62:	0f 8e 0e 01 00 00    	jle    104d76 <sys_unlink+0x1c6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104c68:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104c6d:	75 71                	jne    104ce0 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104c6f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104c73:	76 6b                	jbe    104ce0 <sys_unlink+0x130>
  104c75:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  104c78:	bb 20 00 00 00       	mov    $0x20,%ebx
  104c7d:	8d 76 00             	lea    0x0(%esi),%esi
  104c80:	eb 0e                	jmp    104c90 <sys_unlink+0xe0>
  104c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c88:	83 c3 10             	add    $0x10,%ebx
  104c8b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  104c8e:	73 50                	jae    104ce0 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c90:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c97:	00 
  104c98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104c9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104ca0:	89 34 24             	mov    %esi,(%esp)
  104ca3:	e8 88 c8 ff ff       	call   101530 <readi>
  104ca8:	83 f8 10             	cmp    $0x10,%eax
  104cab:	0f 85 ad 00 00 00    	jne    104d5e <sys_unlink+0x1ae>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104cb1:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  104cb6:	74 d0                	je     104c88 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104cb8:	89 34 24             	mov    %esi,(%esp)
  104cbb:	90                   	nop
  104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104cc0:	e8 bb cf ff ff       	call   101c80 <iunlockput>
    iunlockput(dp);
  104cc5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104cc8:	89 04 24             	mov    %eax,(%esp)
  104ccb:	e8 b0 cf ff ff       	call   101c80 <iunlockput>
  104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104cd5:	e9 01 ff ff ff       	jmp    104bdb <sys_unlink+0x2b>
  104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  104ce0:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  104ce3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104cea:	00 
  104ceb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cf2:	00 
  104cf3:	89 1c 24             	mov    %ebx,(%esp)
  104cf6:	e8 95 f3 ff ff       	call   104090 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cfe:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104d05:	00 
  104d06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104d0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d0e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d11:	89 04 24             	mov    %eax,(%esp)
  104d14:	e8 a7 c9 ff ff       	call   1016c0 <writei>
  104d19:	83 f8 10             	cmp    $0x10,%eax
  104d1c:	75 4c                	jne    104d6a <sys_unlink+0x1ba>
    panic("unlink: writei");
  if(ip->type == T_DIR){
  104d1e:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104d23:	74 27                	je     104d4c <sys_unlink+0x19c>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
  104d25:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d28:	89 04 24             	mov    %eax,(%esp)
  104d2b:	e8 50 cf ff ff       	call   101c80 <iunlockput>

  ip->nlink--;
  104d30:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104d35:	89 34 24             	mov    %esi,(%esp)
  104d38:	e8 f3 c8 ff ff       	call   101630 <iupdate>
  iunlockput(ip);
  104d3d:	89 34 24             	mov    %esi,(%esp)
  104d40:	e8 3b cf ff ff       	call   101c80 <iunlockput>
  104d45:	31 c0                	xor    %eax,%eax
  return 0;
  104d47:	e9 8f fe ff ff       	jmp    104bdb <sys_unlink+0x2b>

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
  104d4c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d4f:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
  104d54:	89 04 24             	mov    %eax,(%esp)
  104d57:	e8 d4 c8 ff ff       	call   101630 <iupdate>
  104d5c:	eb c7                	jmp    104d25 <sys_unlink+0x175>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104d5e:	c7 04 24 c0 70 10 00 	movl   $0x1070c0,(%esp)
  104d65:	e8 26 bd ff ff       	call   100a90 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104d6a:	c7 04 24 d2 70 10 00 	movl   $0x1070d2,(%esp)
  104d71:	e8 1a bd ff ff       	call   100a90 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104d76:	c7 04 24 ae 70 10 00 	movl   $0x1070ae,(%esp)
  104d7d:	e8 0e bd ff ff       	call   100a90 <panic>
  104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d90 <T.67>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104d90:	55                   	push   %ebp
  104d91:	89 e5                	mov    %esp,%ebp
  104d93:	83 ec 28             	sub    $0x28,%esp
  104d96:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104d99:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104d9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104d9e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104da1:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104da7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104dae:	e8 7d f5 ff ff       	call   104330 <argint>
  104db3:	85 c0                	test   %eax,%eax
  104db5:	79 11                	jns    104dc8 <T.67+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104dbc:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104dbf:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104dc2:	89 ec                	mov    %ebp,%esp
  104dc4:	5d                   	pop    %ebp
  104dc5:	c3                   	ret    
  104dc6:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
  104dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dcb:	83 f8 0f             	cmp    $0xf,%eax
  104dce:	77 e7                	ja     104db7 <T.67+0x27>
  104dd0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104dd7:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
  104ddb:	85 d2                	test   %edx,%edx
  104ddd:	74 d8                	je     104db7 <T.67+0x27>
    return -1;
  if(pfd)
  104ddf:	85 db                	test   %ebx,%ebx
  104de1:	74 02                	je     104de5 <T.67+0x55>
    *pfd = fd;
  104de3:	89 03                	mov    %eax,(%ebx)
  if(pf)
  104de5:	31 c0                	xor    %eax,%eax
  104de7:	85 f6                	test   %esi,%esi
  104de9:	74 d1                	je     104dbc <T.67+0x2c>
    *pf = f;
  104deb:	89 16                	mov    %edx,(%esi)
  104ded:	eb cd                	jmp    104dbc <T.67+0x2c>
  104def:	90                   	nop

00104df0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
  104df0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104df1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
  104df3:	89 e5                	mov    %esp,%ebp
  104df5:	53                   	push   %ebx
  104df6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104df9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104dfc:	e8 8f ff ff ff       	call   104d90 <T.67>
  104e01:	85 c0                	test   %eax,%eax
  104e03:	79 13                	jns    104e18 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e05:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
  104e0a:	89 d8                	mov    %ebx,%eax
  104e0c:	83 c4 24             	add    $0x24,%esp
  104e0f:	5b                   	pop    %ebx
  104e10:	5d                   	pop    %ebp
  104e11:	c3                   	ret    
  104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  104e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e1b:	31 db                	xor    %ebx,%ebx
  104e1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104e23:	eb 0b                	jmp    104e30 <sys_dup+0x40>
  104e25:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104e28:	83 c3 01             	add    $0x1,%ebx
  104e2b:	83 fb 10             	cmp    $0x10,%ebx
  104e2e:	74 d5                	je     104e05 <sys_dup+0x15>
    if(proc->ofile[fd] == 0){
  104e30:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
  104e34:	85 c9                	test   %ecx,%ecx
  104e36:	75 f0                	jne    104e28 <sys_dup+0x38>
      proc->ofile[fd] = f;
  104e38:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  104e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e3f:	89 04 24             	mov    %eax,(%esp)
  104e42:	e8 29 c2 ff ff       	call   101070 <filedup>
  return fd;
  104e47:	eb c1                	jmp    104e0a <sys_dup+0x1a>
  104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104e50 <sys_read>:
}

int
sys_read(void)
{
  104e50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e51:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
  104e53:	89 e5                	mov    %esp,%ebp
  104e55:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e58:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104e5b:	e8 30 ff ff ff       	call   104d90 <T.67>
  104e60:	85 c0                	test   %eax,%eax
  104e62:	79 0c                	jns    104e70 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  104e64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e69:	c9                   	leave  
  104e6a:	c3                   	ret    
  104e6b:	90                   	nop
  104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e77:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104e7e:	e8 ad f4 ff ff       	call   104330 <argint>
  104e83:	85 c0                	test   %eax,%eax
  104e85:	78 dd                	js     104e64 <sys_read+0x14>
  104e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e91:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e9c:	e8 cf f4 ff ff       	call   104370 <argptr>
  104ea1:	85 c0                	test   %eax,%eax
  104ea3:	78 bf                	js     104e64 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  104ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104eaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  104eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eb6:	89 04 24             	mov    %eax,(%esp)
  104eb9:	e8 b2 c0 ff ff       	call   100f70 <fileread>
}
  104ebe:	c9                   	leave  
  104ebf:	c3                   	ret    

00104ec0 <sys_write>:

int
sys_write(void)
{
  104ec0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104ec1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104ec3:	89 e5                	mov    %esp,%ebp
  104ec5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104ec8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104ecb:	e8 c0 fe ff ff       	call   104d90 <T.67>
  104ed0:	85 c0                	test   %eax,%eax
  104ed2:	79 0c                	jns    104ee0 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  104ed4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104ed9:	c9                   	leave  
  104eda:	c3                   	ret    
  104edb:	90                   	nop
  104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104ee0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ee7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104eee:	e8 3d f4 ff ff       	call   104330 <argint>
  104ef3:	85 c0                	test   %eax,%eax
  104ef5:	78 dd                	js     104ed4 <sys_write+0x14>
  104ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104efa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f01:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f0c:	e8 5f f4 ff ff       	call   104370 <argptr>
  104f11:	85 c0                	test   %eax,%eax
  104f13:	78 bf                	js     104ed4 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  104f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f18:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f26:	89 04 24             	mov    %eax,(%esp)
  104f29:	e8 92 bf ff ff       	call   100ec0 <filewrite>
}
  104f2e:	c9                   	leave  
  104f2f:	c3                   	ret    

00104f30 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  104f30:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104f31:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  104f33:	89 e5                	mov    %esp,%ebp
  104f35:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104f38:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104f3b:	e8 50 fe ff ff       	call   104d90 <T.67>
  104f40:	85 c0                	test   %eax,%eax
  104f42:	79 0c                	jns    104f50 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  104f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104f49:	c9                   	leave  
  104f4a:	c3                   	ret    
  104f4b:	90                   	nop
  104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104f50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104f53:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  104f5a:	00 
  104f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f66:	e8 05 f4 ff ff       	call   104370 <argptr>
  104f6b:	85 c0                	test   %eax,%eax
  104f6d:	78 d5                	js     104f44 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  104f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f72:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f79:	89 04 24             	mov    %eax,(%esp)
  104f7c:	e8 9f c0 ff ff       	call   101020 <filestat>
}
  104f81:	c9                   	leave  
  104f82:	c3                   	ret    
  104f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104f90 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  104f90:	55                   	push   %ebp
  104f91:	89 e5                	mov    %esp,%ebp
  104f93:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104f96:	8d 55 f0             	lea    -0x10(%ebp),%edx
  104f99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104f9c:	e8 ef fd ff ff       	call   104d90 <T.67>
  104fa1:	89 c2                	mov    %eax,%edx
  104fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104fa8:	85 d2                	test   %edx,%edx
  104faa:	78 1e                	js     104fca <sys_close+0x3a>
    return -1;
  proc->ofile[fd] = 0;
  104fac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104fb5:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
  104fbc:	00 
  fileclose(f);
  104fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fc0:	89 04 24             	mov    %eax,(%esp)
  104fc3:	e8 78 c1 ff ff       	call   101140 <fileclose>
  104fc8:	31 c0                	xor    %eax,%eax
  return 0;
}
  104fca:	c9                   	leave  
  104fcb:	c3                   	ret    
  104fcc:	90                   	nop
  104fcd:	90                   	nop
  104fce:	90                   	nop
  104fcf:	90                   	nop

00104fd0 <sys_getpid>:
}

int
sys_getpid(void)
{
  return proc->pid;
  104fd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
  104fd6:	55                   	push   %ebp
  104fd7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
  104fd9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
  104fda:	8b 40 10             	mov    0x10(%eax),%eax
}
  104fdd:	c3                   	ret    
  104fde:	66 90                	xchg   %ax,%ax

00104fe0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since boot.
int
sys_uptime(void)
{
  104fe0:	55                   	push   %ebp
  104fe1:	89 e5                	mov    %esp,%ebp
  104fe3:	53                   	push   %ebx
  104fe4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;
  
  acquire(&tickslock);
  104fe7:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  104fee:	e8 fd ef ff ff       	call   103ff0 <acquire>
  xticks = ticks;
  104ff3:	8b 1d 80 f5 10 00    	mov    0x10f580,%ebx
  release(&tickslock);
  104ff9:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  105000:	e8 9b ef ff ff       	call   103fa0 <release>
  return xticks;
}
  105005:	83 c4 14             	add    $0x14,%esp
  105008:	89 d8                	mov    %ebx,%eax
  10500a:	5b                   	pop    %ebx
  10500b:	5d                   	pop    %ebp
  10500c:	c3                   	ret    
  10500d:	8d 76 00             	lea    0x0(%esi),%esi

00105010 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  105010:	55                   	push   %ebp
  105011:	89 e5                	mov    %esp,%ebp
  105013:	53                   	push   %ebx
  105014:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
  105017:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10501a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10501e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105025:	e8 06 f3 ff ff       	call   104330 <argint>
  10502a:	89 c2                	mov    %eax,%edx
  10502c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105031:	85 d2                	test   %edx,%edx
  105033:	78 59                	js     10508e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
  105035:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  10503c:	e8 af ef ff ff       	call   103ff0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105044:	8b 1d 80 f5 10 00    	mov    0x10f580,%ebx
  while(ticks - ticks0 < n){
  10504a:	85 d2                	test   %edx,%edx
  10504c:	75 22                	jne    105070 <sys_sleep+0x60>
  10504e:	eb 48                	jmp    105098 <sys_sleep+0x88>
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105050:	c7 44 24 04 40 ed 10 	movl   $0x10ed40,0x4(%esp)
  105057:	00 
  105058:	c7 04 24 80 f5 10 00 	movl   $0x10f580,(%esp)
  10505f:	e8 9c e3 ff ff       	call   103400 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105064:	a1 80 f5 10 00       	mov    0x10f580,%eax
  105069:	29 d8                	sub    %ebx,%eax
  10506b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10506e:	73 28                	jae    105098 <sys_sleep+0x88>
    if(proc->killed){
  105070:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105076:	8b 40 24             	mov    0x24(%eax),%eax
  105079:	85 c0                	test   %eax,%eax
  10507b:	74 d3                	je     105050 <sys_sleep+0x40>
      release(&tickslock);
  10507d:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  105084:	e8 17 ef ff ff       	call   103fa0 <release>
  105089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10508e:	83 c4 24             	add    $0x24,%esp
  105091:	5b                   	pop    %ebx
  105092:	5d                   	pop    %ebp
  105093:	c3                   	ret    
  105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105098:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  10509f:	e8 fc ee ff ff       	call   103fa0 <release>
  return 0;
}
  1050a4:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  1050a7:	31 c0                	xor    %eax,%eax
  return 0;
}
  1050a9:	5b                   	pop    %ebx
  1050aa:	5d                   	pop    %ebp
  1050ab:	c3                   	ret    
  1050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001050b0 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
  1050b0:	55                   	push   %ebp
  1050b1:	89 e5                	mov    %esp,%ebp
  1050b3:	53                   	push   %ebx
  1050b4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  1050b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1050ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050c5:	e8 66 f2 ff ff       	call   104330 <argint>
  1050ca:	85 c0                	test   %eax,%eax
  1050cc:	79 12                	jns    1050e0 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
  1050ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1050d3:	83 c4 24             	add    $0x24,%esp
  1050d6:	5b                   	pop    %ebx
  1050d7:	5d                   	pop    %ebp
  1050d8:	c3                   	ret    
  1050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  1050e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1050e6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
  1050e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050eb:	89 04 24             	mov    %eax,(%esp)
  1050ee:	e8 0d eb ff ff       	call   103c00 <growproc>
  1050f3:	89 c2                	mov    %eax,%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  1050f5:	89 d8                	mov    %ebx,%eax
  if(growproc(n) < 0)
  1050f7:	85 d2                	test   %edx,%edx
  1050f9:	79 d8                	jns    1050d3 <sys_sbrk+0x23>
  1050fb:	eb d1                	jmp    1050ce <sys_sbrk+0x1e>
  1050fd:	8d 76 00             	lea    0x0(%esi),%esi

00105100 <sys_kill>:
  return nice();
}

int
sys_kill(void)
{
  105100:	55                   	push   %ebp
  105101:	89 e5                	mov    %esp,%ebp
  105103:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105106:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105109:	89 44 24 04          	mov    %eax,0x4(%esp)
  10510d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105114:	e8 17 f2 ff ff       	call   104330 <argint>
  105119:	89 c2                	mov    %eax,%edx
  10511b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105120:	85 d2                	test   %edx,%edx
  105122:	78 0b                	js     10512f <sys_kill+0x2f>
    return -1;
  return kill(pid);
  105124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105127:	89 04 24             	mov    %eax,(%esp)
  10512a:	e8 e1 e0 ff ff       	call   103210 <kill>
}
  10512f:	c9                   	leave  
  105130:	c3                   	ret    
  105131:	eb 0d                	jmp    105140 <sys_nice>
  105133:	90                   	nop
  105134:	90                   	nop
  105135:	90                   	nop
  105136:	90                   	nop
  105137:	90                   	nop
  105138:	90                   	nop
  105139:	90                   	nop
  10513a:	90                   	nop
  10513b:	90                   	nop
  10513c:	90                   	nop
  10513d:	90                   	nop
  10513e:	90                   	nop
  10513f:	90                   	nop

00105140 <sys_nice>:
  return ans;
}

int
sys_nice(void)
{ 
  105140:	55                   	push   %ebp
  105141:	89 e5                	mov    %esp,%ebp
  105143:	83 ec 08             	sub    $0x8,%esp
  return nice();
}
  105146:	c9                   	leave  
}

int
sys_nice(void)
{ 
  return nice();
  105147:	e9 54 e0 ff ff       	jmp    1031a0 <nice>
  10514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105150 <sys_wait2>:
  return wait();
}

int
sys_wait2(void)
{ 
  105150:	55                   	push   %ebp
  105151:	89 e5                	mov    %esp,%ebp
  105153:	83 ec 28             	sub    $0x28,%esp
  int ans;
  int wt = 0;
  int rt = 0;
  if(argint(0, &wt) < 0)
  105156:	8d 45 f4             	lea    -0xc(%ebp),%eax

int
sys_wait2(void)
{ 
  int ans;
  int wt = 0;
  105159:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int rt = 0;
  105160:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(argint(0, &wt) < 0)
  105167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10516b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105172:	e8 b9 f1 ff ff       	call   104330 <argint>
  105177:	85 c0                	test   %eax,%eax
  105179:	79 0d                	jns    105188 <sys_wait2+0x38>
    return -1;
  if(argint(1, &rt) < 0)
    return -1;
  ans = wait2((int*)wt, (int*)rt);
  return ans;
  10517b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105180:	c9                   	leave  
  105181:	c3                   	ret    
  105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int ans;
  int wt = 0;
  int rt = 0;
  if(argint(0, &wt) < 0)
    return -1;
  if(argint(1, &rt) < 0)
  105188:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10518b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10518f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105196:	e8 95 f1 ff ff       	call   104330 <argint>
  10519b:	85 c0                	test   %eax,%eax
  10519d:	78 dc                	js     10517b <sys_wait2+0x2b>
    return -1;
  ans = wait2((int*)wt, (int*)rt);
  10519f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051a9:	89 04 24             	mov    %eax,(%esp)
  1051ac:	e8 9f e4 ff ff       	call   103650 <wait2>
  return ans;
}
  1051b1:	c9                   	leave  
  1051b2:	c3                   	ret    
  1051b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001051c0 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  1051c0:	55                   	push   %ebp
  1051c1:	89 e5                	mov    %esp,%ebp
  1051c3:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  1051c6:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  1051c7:	e9 c4 e5 ff ff       	jmp    103790 <wait>
  1051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001051d0 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
  1051d0:	55                   	push   %ebp
  1051d1:	89 e5                	mov    %esp,%ebp
  1051d3:	83 ec 08             	sub    $0x8,%esp
  exit();
  1051d6:	e8 d5 e6 ff ff       	call   1038b0 <exit>
  return 0;  // not reached
}
  1051db:	31 c0                	xor    %eax,%eax
  1051dd:	c9                   	leave  
  1051de:	c3                   	ret    
  1051df:	90                   	nop

001051e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  1051e0:	55                   	push   %ebp
  1051e1:	89 e5                	mov    %esp,%ebp
  1051e3:	83 ec 08             	sub    $0x8,%esp
  return fork();
}
  1051e6:	c9                   	leave  
#include "proc.h"

int
sys_fork(void)
{
  return fork();
  1051e7:	e9 14 e9 ff ff       	jmp    103b00 <fork>
  1051ec:	90                   	nop
  1051ed:	90                   	nop
  1051ee:	90                   	nop
  1051ef:	90                   	nop

001051f0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
  1051f0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1051f1:	ba 43 00 00 00       	mov    $0x43,%edx
  1051f6:	89 e5                	mov    %esp,%ebp
  1051f8:	83 ec 18             	sub    $0x18,%esp
  1051fb:	b8 34 00 00 00       	mov    $0x34,%eax
  105200:	ee                   	out    %al,(%dx)
  105201:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105206:	b2 40                	mov    $0x40,%dl
  105208:	ee                   	out    %al,(%dx)
  105209:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10520e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
  10520f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105216:	e8 45 db ff ff       	call   102d60 <picenable>
}
  10521b:	c9                   	leave  
  10521c:	c3                   	ret    
  10521d:	90                   	nop
  10521e:	90                   	nop
  10521f:	90                   	nop

00105220 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  105220:	1e                   	push   %ds
  pushl %es
  105221:	06                   	push   %es
  pushl %fs
  105222:	0f a0                	push   %fs
  pushl %gs
  105224:	0f a8                	push   %gs
  pushal
  105226:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
  105227:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
  10522b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
  10522d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
  10522f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
  105233:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
  105235:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
  105237:	54                   	push   %esp
  call trap
  105238:	e8 43 00 00 00       	call   105280 <trap>
  addl $4, %esp
  10523d:	83 c4 04             	add    $0x4,%esp

00105240 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  105240:	61                   	popa   
  popl %gs
  105241:	0f a9                	pop    %gs
  popl %fs
  105243:	0f a1                	pop    %fs
  popl %es
  105245:	07                   	pop    %es
  popl %ds
  105246:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
  105247:	83 c4 08             	add    $0x8,%esp
  iret
  10524a:	cf                   	iret   
  10524b:	90                   	nop
  10524c:	90                   	nop
  10524d:	90                   	nop
  10524e:	90                   	nop
  10524f:	90                   	nop

00105250 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105250:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105251:	b8 80 ed 10 00       	mov    $0x10ed80,%eax
  105256:	89 e5                	mov    %esp,%ebp
  105258:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10525b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105261:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105265:	c1 e8 10             	shr    $0x10,%eax
  105268:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10526c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10526f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105272:	c9                   	leave  
  105273:	c3                   	ret    
  105274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10527a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105280 <trap>:

void
trap(struct trapframe *tf)
{
  105280:	55                   	push   %ebp
  105281:	89 e5                	mov    %esp,%ebp
  105283:	56                   	push   %esi
  105284:	53                   	push   %ebx
  105285:	83 ec 20             	sub    $0x20,%esp
  105288:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
  10528b:	8b 43 30             	mov    0x30(%ebx),%eax
  10528e:	83 f8 40             	cmp    $0x40,%eax
  105291:	0f 84 c9 00 00 00    	je     105360 <trap+0xe0>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105297:	8d 50 e0             	lea    -0x20(%eax),%edx
  10529a:	83 fa 1f             	cmp    $0x1f,%edx
  10529d:	0f 86 b5 00 00 00    	jbe    105358 <trap+0xd8>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
  1052a3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1052aa:	85 d2                	test   %edx,%edx
  1052ac:	0f 84 64 02 00 00    	je     105516 <trap+0x296>
  1052b2:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
  1052b6:	0f 84 5a 02 00 00    	je     105516 <trap+0x296>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  1052bc:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
  1052bf:	8b 4a 10             	mov    0x10(%edx),%ecx
  1052c2:	83 c2 6c             	add    $0x6c,%edx
  1052c5:	89 74 24 1c          	mov    %esi,0x1c(%esp)
  1052c9:	8b 73 38             	mov    0x38(%ebx),%esi
  1052cc:	89 74 24 18          	mov    %esi,0x18(%esp)
  1052d0:	65 8b 35 00 00 00 00 	mov    %gs:0x0,%esi
  1052d7:	0f b6 36             	movzbl (%esi),%esi
  1052da:	89 74 24 14          	mov    %esi,0x14(%esp)
  1052de:	8b 73 34             	mov    0x34(%ebx),%esi
  1052e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1052e5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1052e9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1052ed:	89 74 24 10          	mov    %esi,0x10(%esp)
  1052f1:	c7 04 24 3c 71 10 00 	movl   $0x10713c,(%esp)
  1052f8:	e8 c3 b1 ff ff       	call   1004c0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
  1052fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105303:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  10530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105310:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105316:	85 c0                	test   %eax,%eax
  105318:	74 68                	je     105382 <trap+0x102>
  10531a:	8b 48 24             	mov    0x24(%eax),%ecx
  10531d:	85 c9                	test   %ecx,%ecx
  10531f:	74 10                	je     105331 <trap+0xb1>
  105321:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
  105325:	83 e2 03             	and    $0x3,%edx
  105328:	83 fa 03             	cmp    $0x3,%edx
  10532b:	0f 84 9f 01 00 00    	je     1054d0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  105331:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105335:	74 59                	je     105390 <trap+0x110>
    yield();
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105337:	89 c2                	mov    %eax,%edx
  105339:	8b 42 24             	mov    0x24(%edx),%eax
  10533c:	85 c0                	test   %eax,%eax
  10533e:	74 42                	je     105382 <trap+0x102>
  105340:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105344:	83 e0 03             	and    $0x3,%eax
  105347:	83 f8 03             	cmp    $0x3,%eax
  10534a:	75 36                	jne    105382 <trap+0x102>
    exit();
}
  10534c:	83 c4 20             	add    $0x20,%esp
  10534f:	5b                   	pop    %ebx
  105350:	5e                   	pop    %esi
  105351:	5d                   	pop    %ebp
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105352:	e9 59 e5 ff ff       	jmp    1038b0 <exit>
  105357:	90                   	nop
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105358:	ff 24 95 8c 71 10 00 	jmp    *0x10718c(,%edx,4)
  10535f:	90                   	nop

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
  105360:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105366:	8b 70 24             	mov    0x24(%eax),%esi
  105369:	85 f6                	test   %esi,%esi
  10536b:	75 6b                	jne    1053d8 <trap+0x158>
      exit();
    proc->tf = tf;
  10536d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
  105370:	e8 bb f0 ff ff       	call   104430 <syscall>
    if(proc->killed)
  105375:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10537b:	8b 58 24             	mov    0x24(%eax),%ebx
  10537e:	85 db                	test   %ebx,%ebx
  105380:	75 ca                	jne    10534c <trap+0xcc>
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
  105382:	83 c4 20             	add    $0x20,%esp
  105385:	5b                   	pop    %ebx
  105386:	5e                   	pop    %esi
  105387:	5d                   	pop    %ebp
  105388:	c3                   	ret    
  105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  105390:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
  105394:	75 a1                	jne    105337 <trap+0xb7>
    //cprintf("lol");
    clockticks++;
  105396:	8b 0d ac 91 10 00    	mov    0x1091ac,%ecx
  10539c:	83 c1 01             	add    $0x1,%ecx
  10539f:	89 0d ac 91 10 00    	mov    %ecx,0x1091ac
    proc->rtime++;
  1053a5:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
    if(clockticks == QUANTA) {
    clockticks=0;
    yield();
    }
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
  1053ac:	83 f9 05             	cmp    $0x5,%ecx
  1053af:	0f 84 33 01 00 00    	je     1054e8 <trap+0x268>
    clockticks=0;
    yield();
  1053b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    }
    if((clockticks == 2*QUANTA) && (proc->priority == 1)) {
  1053bb:	83 f9 0a             	cmp    $0xa,%ecx
    yield();
    }
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
    clockticks=0;
    yield();
  1053be:	89 c2                	mov    %eax,%edx
    }
    if((clockticks == 2*QUANTA) && (proc->priority == 1)) {
  1053c0:	0f 84 df 00 00 00    	je     1054a5 <trap+0x225>
  1053c6:	89 c2                	mov    %eax,%edx
    yield();
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  1053c8:	85 d2                	test   %edx,%edx
  1053ca:	0f 85 69 ff ff ff    	jne    105339 <trap+0xb9>
  1053d0:	eb b0                	jmp    105382 <trap+0x102>
  1053d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
  1053d8:	e8 d3 e4 ff ff       	call   1038b0 <exit>
  1053dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1053e3:	eb 88                	jmp    10536d <trap+0xed>
  1053e5:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  1053e8:	e8 e3 cd ff ff       	call   1021d0 <ideintr>
    lapiceoi();
  1053ed:	e8 3e d2 ff ff       	call   102630 <lapiceoi>
    break;
  1053f2:	e9 19 ff ff ff       	jmp    105310 <trap+0x90>
  1053f7:	90                   	nop
  1053f8:	90                   	nop
  1053f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
  105400:	e8 0b d2 ff ff       	call   102610 <kbdintr>
  105405:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105408:	e8 23 d2 ff ff       	call   102630 <lapiceoi>
  10540d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105410:	e9 fb fe ff ff       	jmp    105310 <trap+0x90>
  105415:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
  105418:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10541e:	80 38 00             	cmpb   $0x0,(%eax)
  105421:	75 ca                	jne    1053ed <trap+0x16d>
      acquire(&tickslock);
  105423:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  10542a:	e8 c1 eb ff ff       	call   103ff0 <acquire>
      ticks++;
  10542f:	83 05 80 f5 10 00 01 	addl   $0x1,0x10f580
      wakeup(&ticks);
  105436:	c7 04 24 80 f5 10 00 	movl   $0x10f580,(%esp)
  10543d:	e8 5e de ff ff       	call   1032a0 <wakeup>
      release(&tickslock);
  105442:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
  105449:	e8 52 eb ff ff       	call   103fa0 <release>
  10544e:	eb 9d                	jmp    1053ed <trap+0x16d>
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105450:	8b 43 38             	mov    0x38(%ebx),%eax
  105453:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105457:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  10545b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10545f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  105465:	0f b6 00             	movzbl (%eax),%eax
  105468:	c7 04 24 e4 70 10 00 	movl   $0x1070e4,(%esp)
  10546f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105473:	e8 48 b0 ff ff       	call   1004c0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
  105478:	e8 b3 d1 ff ff       	call   102630 <lapiceoi>
    break;
  10547d:	e9 8e fe ff ff       	jmp    105310 <trap+0x90>
  105482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105488:	90                   	nop
  105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  105490:	e8 7b 01 00 00       	call   105610 <uartintr>
  105495:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105498:	e8 93 d1 ff ff       	call   102630 <lapiceoi>
  10549d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  1054a0:	e9 6b fe ff ff       	jmp    105310 <trap+0x90>
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
    clockticks=0;
    yield();
    }
    if((clockticks == 2*QUANTA) && (proc->priority == 1)) {
  1054a5:	83 b8 88 00 00 00 01 	cmpl   $0x1,0x88(%eax)
  1054ac:	0f 85 16 ff ff ff    	jne    1053c8 <trap+0x148>
    clockticks=0;
  1054b2:	c7 05 ac 91 10 00 00 	movl   $0x0,0x1091ac
  1054b9:	00 00 00 
    yield();
  1054bc:	e8 0f e0 ff ff       	call   1034d0 <yield>
  1054c1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1054c8:	e9 fb fe ff ff       	jmp    1053c8 <trap+0x148>
  1054cd:	8d 76 00             	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  1054d0:	e8 db e3 ff ff       	call   1038b0 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  1054d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1054db:	85 c0                	test   %eax,%eax
  1054dd:	0f 85 4e fe ff ff    	jne    105331 <trap+0xb1>
  1054e3:	e9 9a fe ff ff       	jmp    105382 <trap+0x102>
    if(clockticks == QUANTA) {
    clockticks=0;
    yield();
    }
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
  1054e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1054ee:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
  1054f4:	85 d2                	test   %edx,%edx
  1054f6:	0f 85 ca fe ff ff    	jne    1053c6 <trap+0x146>
    clockticks=0;
  1054fc:	c7 05 ac 91 10 00 00 	movl   $0x0,0x1091ac
  105503:	00 00 00 
    yield();
  105506:	e8 c5 df ff ff       	call   1034d0 <yield>
  10550b:	8b 0d ac 91 10 00    	mov    0x1091ac,%ecx
  105511:	e9 9f fe ff ff       	jmp    1053b5 <trap+0x135>
  105516:	0f 20 d2             	mov    %cr2,%edx
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  105519:	89 54 24 10          	mov    %edx,0x10(%esp)
  10551d:	8b 53 38             	mov    0x38(%ebx),%edx
  105520:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105524:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  10552b:	0f b6 12             	movzbl (%edx),%edx
  10552e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105532:	c7 04 24 08 71 10 00 	movl   $0x107108,(%esp)
  105539:	89 54 24 08          	mov    %edx,0x8(%esp)
  10553d:	e8 7e af ff ff       	call   1004c0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
  105542:	c7 04 24 7f 71 10 00 	movl   $0x10717f,(%esp)
  105549:	e8 42 b5 ff ff       	call   100a90 <panic>
  10554e:	66 90                	xchg   %ax,%ax

00105550 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  105550:	55                   	push   %ebp
  105551:	31 c0                	xor    %eax,%eax
  105553:	89 e5                	mov    %esp,%ebp
  105555:	ba 80 ed 10 00       	mov    $0x10ed80,%edx
  10555a:	83 ec 18             	sub    $0x18,%esp
  10555d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105560:	8b 0c 85 08 86 10 00 	mov    0x108608(,%eax,4),%ecx
  105567:	66 89 0c c5 80 ed 10 	mov    %cx,0x10ed80(,%eax,8)
  10556e:	00 
  10556f:	c1 e9 10             	shr    $0x10,%ecx
  105572:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105579:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  10557e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105583:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105588:	83 c0 01             	add    $0x1,%eax
  10558b:	3d 00 01 00 00       	cmp    $0x100,%eax
  105590:	75 ce                	jne    105560 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105592:	a1 08 87 10 00       	mov    0x108708,%eax
  
  initlock(&tickslock, "time");
  105597:	c7 44 24 04 84 71 10 	movl   $0x107184,0x4(%esp)
  10559e:	00 
  10559f:	c7 04 24 40 ed 10 00 	movl   $0x10ed40,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  1055a6:	66 c7 05 82 ef 10 00 	movw   $0x8,0x10ef82
  1055ad:	08 00 
  1055af:	66 a3 80 ef 10 00    	mov    %ax,0x10ef80
  1055b5:	c1 e8 10             	shr    $0x10,%eax
  1055b8:	c6 05 84 ef 10 00 00 	movb   $0x0,0x10ef84
  1055bf:	c6 05 85 ef 10 00 ef 	movb   $0xef,0x10ef85
  1055c6:	66 a3 86 ef 10 00    	mov    %ax,0x10ef86
  
  initlock(&tickslock, "time");
  1055cc:	e8 8f e8 ff ff       	call   103e60 <initlock>
}
  1055d1:	c9                   	leave  
  1055d2:	c3                   	ret    
  1055d3:	90                   	nop
  1055d4:	90                   	nop
  1055d5:	90                   	nop
  1055d6:	90                   	nop
  1055d7:	90                   	nop
  1055d8:	90                   	nop
  1055d9:	90                   	nop
  1055da:	90                   	nop
  1055db:	90                   	nop
  1055dc:	90                   	nop
  1055dd:	90                   	nop
  1055de:	90                   	nop
  1055df:	90                   	nop

001055e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
  1055e0:	a1 b0 91 10 00       	mov    0x1091b0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
  1055e5:	55                   	push   %ebp
  1055e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
  1055e8:	85 c0                	test   %eax,%eax
  1055ea:	75 0c                	jne    1055f8 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
  1055ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1055f1:	5d                   	pop    %ebp
  1055f2:	c3                   	ret    
  1055f3:	90                   	nop
  1055f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1055f8:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1055fd:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
  1055fe:	a8 01                	test   $0x1,%al
  105600:	74 ea                	je     1055ec <uartgetc+0xc>
  105602:	b2 f8                	mov    $0xf8,%dl
  105604:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  105605:	0f b6 c0             	movzbl %al,%eax
}
  105608:	5d                   	pop    %ebp
  105609:	c3                   	ret    
  10560a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00105610 <uartintr>:

void
uartintr(void)
{
  105610:	55                   	push   %ebp
  105611:	89 e5                	mov    %esp,%ebp
  105613:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
  105616:	c7 04 24 e0 55 10 00 	movl   $0x1055e0,(%esp)
  10561d:	e8 9e b1 ff ff       	call   1007c0 <consoleintr>
}
  105622:	c9                   	leave  
  105623:	c3                   	ret    
  105624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10562a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105630 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
  105630:	55                   	push   %ebp
  105631:	89 e5                	mov    %esp,%ebp
  105633:	56                   	push   %esi
  105634:	be fd 03 00 00       	mov    $0x3fd,%esi
  105639:	53                   	push   %ebx
  int i;

  if(!uart)
  10563a:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
  10563c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  10563f:	8b 15 b0 91 10 00    	mov    0x1091b0,%edx
  105645:	85 d2                	test   %edx,%edx
  105647:	75 1e                	jne    105667 <uartputc+0x37>
  105649:	eb 2c                	jmp    105677 <uartputc+0x47>
  10564b:	90                   	nop
  10564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  105650:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
  105653:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10565a:	e8 f1 cf ff ff       	call   102650 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  10565f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  105665:	74 07                	je     10566e <uartputc+0x3e>
  105667:	89 f2                	mov    %esi,%edx
  105669:	ec                   	in     (%dx),%al
  10566a:	a8 20                	test   $0x20,%al
  10566c:	74 e2                	je     105650 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10566e:	ba f8 03 00 00       	mov    $0x3f8,%edx
  105673:	8b 45 08             	mov    0x8(%ebp),%eax
  105676:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
  105677:	83 c4 10             	add    $0x10,%esp
  10567a:	5b                   	pop    %ebx
  10567b:	5e                   	pop    %esi
  10567c:	5d                   	pop    %ebp
  10567d:	c3                   	ret    
  10567e:	66 90                	xchg   %ax,%ax

00105680 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  105680:	55                   	push   %ebp
  105681:	31 c9                	xor    %ecx,%ecx
  105683:	89 e5                	mov    %esp,%ebp
  105685:	89 c8                	mov    %ecx,%eax
  105687:	57                   	push   %edi
  105688:	bf fa 03 00 00       	mov    $0x3fa,%edi
  10568d:	56                   	push   %esi
  10568e:	89 fa                	mov    %edi,%edx
  105690:	53                   	push   %ebx
  105691:	83 ec 1c             	sub    $0x1c,%esp
  105694:	ee                   	out    %al,(%dx)
  105695:	bb fb 03 00 00       	mov    $0x3fb,%ebx
  10569a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  10569f:	89 da                	mov    %ebx,%edx
  1056a1:	ee                   	out    %al,(%dx)
  1056a2:	b8 0c 00 00 00       	mov    $0xc,%eax
  1056a7:	b2 f8                	mov    $0xf8,%dl
  1056a9:	ee                   	out    %al,(%dx)
  1056aa:	be f9 03 00 00       	mov    $0x3f9,%esi
  1056af:	89 c8                	mov    %ecx,%eax
  1056b1:	89 f2                	mov    %esi,%edx
  1056b3:	ee                   	out    %al,(%dx)
  1056b4:	b8 03 00 00 00       	mov    $0x3,%eax
  1056b9:	89 da                	mov    %ebx,%edx
  1056bb:	ee                   	out    %al,(%dx)
  1056bc:	b2 fc                	mov    $0xfc,%dl
  1056be:	89 c8                	mov    %ecx,%eax
  1056c0:	ee                   	out    %al,(%dx)
  1056c1:	b8 01 00 00 00       	mov    $0x1,%eax
  1056c6:	89 f2                	mov    %esi,%edx
  1056c8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1056c9:	b2 fd                	mov    $0xfd,%dl
  1056cb:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  1056cc:	3c ff                	cmp    $0xff,%al
  1056ce:	74 55                	je     105725 <uartinit+0xa5>
    return;
  uart = 1;
  1056d0:	c7 05 b0 91 10 00 01 	movl   $0x1,0x1091b0
  1056d7:	00 00 00 
  1056da:	89 fa                	mov    %edi,%edx
  1056dc:	ec                   	in     (%dx),%al
  1056dd:	b2 f8                	mov    $0xf8,%dl
  1056df:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  1056e0:	bb 0c 72 10 00       	mov    $0x10720c,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  1056e5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1056ec:	e8 6f d6 ff ff       	call   102d60 <picenable>
  ioapicenable(IRQ_COM1, 0);
  1056f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1056f8:	00 
  1056f9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105700:	e8 1b cc ff ff       	call   102320 <ioapicenable>
  105705:	b8 78 00 00 00       	mov    $0x78,%eax
  10570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
  105710:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  105713:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
  105716:	89 04 24             	mov    %eax,(%esp)
  105719:	e8 12 ff ff ff       	call   105630 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  10571e:	0f b6 03             	movzbl (%ebx),%eax
  105721:	84 c0                	test   %al,%al
  105723:	75 eb                	jne    105710 <uartinit+0x90>
    uartputc(*p);
}
  105725:	83 c4 1c             	add    $0x1c,%esp
  105728:	5b                   	pop    %ebx
  105729:	5e                   	pop    %esi
  10572a:	5f                   	pop    %edi
  10572b:	5d                   	pop    %ebp
  10572c:	c3                   	ret    
  10572d:	90                   	nop
  10572e:	90                   	nop
  10572f:	90                   	nop

00105730 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  105730:	6a 00                	push   $0x0
  pushl $0
  105732:	6a 00                	push   $0x0
  jmp alltraps
  105734:	e9 e7 fa ff ff       	jmp    105220 <alltraps>

00105739 <vector1>:
.globl vector1
vector1:
  pushl $0
  105739:	6a 00                	push   $0x0
  pushl $1
  10573b:	6a 01                	push   $0x1
  jmp alltraps
  10573d:	e9 de fa ff ff       	jmp    105220 <alltraps>

00105742 <vector2>:
.globl vector2
vector2:
  pushl $0
  105742:	6a 00                	push   $0x0
  pushl $2
  105744:	6a 02                	push   $0x2
  jmp alltraps
  105746:	e9 d5 fa ff ff       	jmp    105220 <alltraps>

0010574b <vector3>:
.globl vector3
vector3:
  pushl $0
  10574b:	6a 00                	push   $0x0
  pushl $3
  10574d:	6a 03                	push   $0x3
  jmp alltraps
  10574f:	e9 cc fa ff ff       	jmp    105220 <alltraps>

00105754 <vector4>:
.globl vector4
vector4:
  pushl $0
  105754:	6a 00                	push   $0x0
  pushl $4
  105756:	6a 04                	push   $0x4
  jmp alltraps
  105758:	e9 c3 fa ff ff       	jmp    105220 <alltraps>

0010575d <vector5>:
.globl vector5
vector5:
  pushl $0
  10575d:	6a 00                	push   $0x0
  pushl $5
  10575f:	6a 05                	push   $0x5
  jmp alltraps
  105761:	e9 ba fa ff ff       	jmp    105220 <alltraps>

00105766 <vector6>:
.globl vector6
vector6:
  pushl $0
  105766:	6a 00                	push   $0x0
  pushl $6
  105768:	6a 06                	push   $0x6
  jmp alltraps
  10576a:	e9 b1 fa ff ff       	jmp    105220 <alltraps>

0010576f <vector7>:
.globl vector7
vector7:
  pushl $0
  10576f:	6a 00                	push   $0x0
  pushl $7
  105771:	6a 07                	push   $0x7
  jmp alltraps
  105773:	e9 a8 fa ff ff       	jmp    105220 <alltraps>

00105778 <vector8>:
.globl vector8
vector8:
  pushl $8
  105778:	6a 08                	push   $0x8
  jmp alltraps
  10577a:	e9 a1 fa ff ff       	jmp    105220 <alltraps>

0010577f <vector9>:
.globl vector9
vector9:
  pushl $0
  10577f:	6a 00                	push   $0x0
  pushl $9
  105781:	6a 09                	push   $0x9
  jmp alltraps
  105783:	e9 98 fa ff ff       	jmp    105220 <alltraps>

00105788 <vector10>:
.globl vector10
vector10:
  pushl $10
  105788:	6a 0a                	push   $0xa
  jmp alltraps
  10578a:	e9 91 fa ff ff       	jmp    105220 <alltraps>

0010578f <vector11>:
.globl vector11
vector11:
  pushl $11
  10578f:	6a 0b                	push   $0xb
  jmp alltraps
  105791:	e9 8a fa ff ff       	jmp    105220 <alltraps>

00105796 <vector12>:
.globl vector12
vector12:
  pushl $12
  105796:	6a 0c                	push   $0xc
  jmp alltraps
  105798:	e9 83 fa ff ff       	jmp    105220 <alltraps>

0010579d <vector13>:
.globl vector13
vector13:
  pushl $13
  10579d:	6a 0d                	push   $0xd
  jmp alltraps
  10579f:	e9 7c fa ff ff       	jmp    105220 <alltraps>

001057a4 <vector14>:
.globl vector14
vector14:
  pushl $14
  1057a4:	6a 0e                	push   $0xe
  jmp alltraps
  1057a6:	e9 75 fa ff ff       	jmp    105220 <alltraps>

001057ab <vector15>:
.globl vector15
vector15:
  pushl $0
  1057ab:	6a 00                	push   $0x0
  pushl $15
  1057ad:	6a 0f                	push   $0xf
  jmp alltraps
  1057af:	e9 6c fa ff ff       	jmp    105220 <alltraps>

001057b4 <vector16>:
.globl vector16
vector16:
  pushl $0
  1057b4:	6a 00                	push   $0x0
  pushl $16
  1057b6:	6a 10                	push   $0x10
  jmp alltraps
  1057b8:	e9 63 fa ff ff       	jmp    105220 <alltraps>

001057bd <vector17>:
.globl vector17
vector17:
  pushl $17
  1057bd:	6a 11                	push   $0x11
  jmp alltraps
  1057bf:	e9 5c fa ff ff       	jmp    105220 <alltraps>

001057c4 <vector18>:
.globl vector18
vector18:
  pushl $0
  1057c4:	6a 00                	push   $0x0
  pushl $18
  1057c6:	6a 12                	push   $0x12
  jmp alltraps
  1057c8:	e9 53 fa ff ff       	jmp    105220 <alltraps>

001057cd <vector19>:
.globl vector19
vector19:
  pushl $0
  1057cd:	6a 00                	push   $0x0
  pushl $19
  1057cf:	6a 13                	push   $0x13
  jmp alltraps
  1057d1:	e9 4a fa ff ff       	jmp    105220 <alltraps>

001057d6 <vector20>:
.globl vector20
vector20:
  pushl $0
  1057d6:	6a 00                	push   $0x0
  pushl $20
  1057d8:	6a 14                	push   $0x14
  jmp alltraps
  1057da:	e9 41 fa ff ff       	jmp    105220 <alltraps>

001057df <vector21>:
.globl vector21
vector21:
  pushl $0
  1057df:	6a 00                	push   $0x0
  pushl $21
  1057e1:	6a 15                	push   $0x15
  jmp alltraps
  1057e3:	e9 38 fa ff ff       	jmp    105220 <alltraps>

001057e8 <vector22>:
.globl vector22
vector22:
  pushl $0
  1057e8:	6a 00                	push   $0x0
  pushl $22
  1057ea:	6a 16                	push   $0x16
  jmp alltraps
  1057ec:	e9 2f fa ff ff       	jmp    105220 <alltraps>

001057f1 <vector23>:
.globl vector23
vector23:
  pushl $0
  1057f1:	6a 00                	push   $0x0
  pushl $23
  1057f3:	6a 17                	push   $0x17
  jmp alltraps
  1057f5:	e9 26 fa ff ff       	jmp    105220 <alltraps>

001057fa <vector24>:
.globl vector24
vector24:
  pushl $0
  1057fa:	6a 00                	push   $0x0
  pushl $24
  1057fc:	6a 18                	push   $0x18
  jmp alltraps
  1057fe:	e9 1d fa ff ff       	jmp    105220 <alltraps>

00105803 <vector25>:
.globl vector25
vector25:
  pushl $0
  105803:	6a 00                	push   $0x0
  pushl $25
  105805:	6a 19                	push   $0x19
  jmp alltraps
  105807:	e9 14 fa ff ff       	jmp    105220 <alltraps>

0010580c <vector26>:
.globl vector26
vector26:
  pushl $0
  10580c:	6a 00                	push   $0x0
  pushl $26
  10580e:	6a 1a                	push   $0x1a
  jmp alltraps
  105810:	e9 0b fa ff ff       	jmp    105220 <alltraps>

00105815 <vector27>:
.globl vector27
vector27:
  pushl $0
  105815:	6a 00                	push   $0x0
  pushl $27
  105817:	6a 1b                	push   $0x1b
  jmp alltraps
  105819:	e9 02 fa ff ff       	jmp    105220 <alltraps>

0010581e <vector28>:
.globl vector28
vector28:
  pushl $0
  10581e:	6a 00                	push   $0x0
  pushl $28
  105820:	6a 1c                	push   $0x1c
  jmp alltraps
  105822:	e9 f9 f9 ff ff       	jmp    105220 <alltraps>

00105827 <vector29>:
.globl vector29
vector29:
  pushl $0
  105827:	6a 00                	push   $0x0
  pushl $29
  105829:	6a 1d                	push   $0x1d
  jmp alltraps
  10582b:	e9 f0 f9 ff ff       	jmp    105220 <alltraps>

00105830 <vector30>:
.globl vector30
vector30:
  pushl $0
  105830:	6a 00                	push   $0x0
  pushl $30
  105832:	6a 1e                	push   $0x1e
  jmp alltraps
  105834:	e9 e7 f9 ff ff       	jmp    105220 <alltraps>

00105839 <vector31>:
.globl vector31
vector31:
  pushl $0
  105839:	6a 00                	push   $0x0
  pushl $31
  10583b:	6a 1f                	push   $0x1f
  jmp alltraps
  10583d:	e9 de f9 ff ff       	jmp    105220 <alltraps>

00105842 <vector32>:
.globl vector32
vector32:
  pushl $0
  105842:	6a 00                	push   $0x0
  pushl $32
  105844:	6a 20                	push   $0x20
  jmp alltraps
  105846:	e9 d5 f9 ff ff       	jmp    105220 <alltraps>

0010584b <vector33>:
.globl vector33
vector33:
  pushl $0
  10584b:	6a 00                	push   $0x0
  pushl $33
  10584d:	6a 21                	push   $0x21
  jmp alltraps
  10584f:	e9 cc f9 ff ff       	jmp    105220 <alltraps>

00105854 <vector34>:
.globl vector34
vector34:
  pushl $0
  105854:	6a 00                	push   $0x0
  pushl $34
  105856:	6a 22                	push   $0x22
  jmp alltraps
  105858:	e9 c3 f9 ff ff       	jmp    105220 <alltraps>

0010585d <vector35>:
.globl vector35
vector35:
  pushl $0
  10585d:	6a 00                	push   $0x0
  pushl $35
  10585f:	6a 23                	push   $0x23
  jmp alltraps
  105861:	e9 ba f9 ff ff       	jmp    105220 <alltraps>

00105866 <vector36>:
.globl vector36
vector36:
  pushl $0
  105866:	6a 00                	push   $0x0
  pushl $36
  105868:	6a 24                	push   $0x24
  jmp alltraps
  10586a:	e9 b1 f9 ff ff       	jmp    105220 <alltraps>

0010586f <vector37>:
.globl vector37
vector37:
  pushl $0
  10586f:	6a 00                	push   $0x0
  pushl $37
  105871:	6a 25                	push   $0x25
  jmp alltraps
  105873:	e9 a8 f9 ff ff       	jmp    105220 <alltraps>

00105878 <vector38>:
.globl vector38
vector38:
  pushl $0
  105878:	6a 00                	push   $0x0
  pushl $38
  10587a:	6a 26                	push   $0x26
  jmp alltraps
  10587c:	e9 9f f9 ff ff       	jmp    105220 <alltraps>

00105881 <vector39>:
.globl vector39
vector39:
  pushl $0
  105881:	6a 00                	push   $0x0
  pushl $39
  105883:	6a 27                	push   $0x27
  jmp alltraps
  105885:	e9 96 f9 ff ff       	jmp    105220 <alltraps>

0010588a <vector40>:
.globl vector40
vector40:
  pushl $0
  10588a:	6a 00                	push   $0x0
  pushl $40
  10588c:	6a 28                	push   $0x28
  jmp alltraps
  10588e:	e9 8d f9 ff ff       	jmp    105220 <alltraps>

00105893 <vector41>:
.globl vector41
vector41:
  pushl $0
  105893:	6a 00                	push   $0x0
  pushl $41
  105895:	6a 29                	push   $0x29
  jmp alltraps
  105897:	e9 84 f9 ff ff       	jmp    105220 <alltraps>

0010589c <vector42>:
.globl vector42
vector42:
  pushl $0
  10589c:	6a 00                	push   $0x0
  pushl $42
  10589e:	6a 2a                	push   $0x2a
  jmp alltraps
  1058a0:	e9 7b f9 ff ff       	jmp    105220 <alltraps>

001058a5 <vector43>:
.globl vector43
vector43:
  pushl $0
  1058a5:	6a 00                	push   $0x0
  pushl $43
  1058a7:	6a 2b                	push   $0x2b
  jmp alltraps
  1058a9:	e9 72 f9 ff ff       	jmp    105220 <alltraps>

001058ae <vector44>:
.globl vector44
vector44:
  pushl $0
  1058ae:	6a 00                	push   $0x0
  pushl $44
  1058b0:	6a 2c                	push   $0x2c
  jmp alltraps
  1058b2:	e9 69 f9 ff ff       	jmp    105220 <alltraps>

001058b7 <vector45>:
.globl vector45
vector45:
  pushl $0
  1058b7:	6a 00                	push   $0x0
  pushl $45
  1058b9:	6a 2d                	push   $0x2d
  jmp alltraps
  1058bb:	e9 60 f9 ff ff       	jmp    105220 <alltraps>

001058c0 <vector46>:
.globl vector46
vector46:
  pushl $0
  1058c0:	6a 00                	push   $0x0
  pushl $46
  1058c2:	6a 2e                	push   $0x2e
  jmp alltraps
  1058c4:	e9 57 f9 ff ff       	jmp    105220 <alltraps>

001058c9 <vector47>:
.globl vector47
vector47:
  pushl $0
  1058c9:	6a 00                	push   $0x0
  pushl $47
  1058cb:	6a 2f                	push   $0x2f
  jmp alltraps
  1058cd:	e9 4e f9 ff ff       	jmp    105220 <alltraps>

001058d2 <vector48>:
.globl vector48
vector48:
  pushl $0
  1058d2:	6a 00                	push   $0x0
  pushl $48
  1058d4:	6a 30                	push   $0x30
  jmp alltraps
  1058d6:	e9 45 f9 ff ff       	jmp    105220 <alltraps>

001058db <vector49>:
.globl vector49
vector49:
  pushl $0
  1058db:	6a 00                	push   $0x0
  pushl $49
  1058dd:	6a 31                	push   $0x31
  jmp alltraps
  1058df:	e9 3c f9 ff ff       	jmp    105220 <alltraps>

001058e4 <vector50>:
.globl vector50
vector50:
  pushl $0
  1058e4:	6a 00                	push   $0x0
  pushl $50
  1058e6:	6a 32                	push   $0x32
  jmp alltraps
  1058e8:	e9 33 f9 ff ff       	jmp    105220 <alltraps>

001058ed <vector51>:
.globl vector51
vector51:
  pushl $0
  1058ed:	6a 00                	push   $0x0
  pushl $51
  1058ef:	6a 33                	push   $0x33
  jmp alltraps
  1058f1:	e9 2a f9 ff ff       	jmp    105220 <alltraps>

001058f6 <vector52>:
.globl vector52
vector52:
  pushl $0
  1058f6:	6a 00                	push   $0x0
  pushl $52
  1058f8:	6a 34                	push   $0x34
  jmp alltraps
  1058fa:	e9 21 f9 ff ff       	jmp    105220 <alltraps>

001058ff <vector53>:
.globl vector53
vector53:
  pushl $0
  1058ff:	6a 00                	push   $0x0
  pushl $53
  105901:	6a 35                	push   $0x35
  jmp alltraps
  105903:	e9 18 f9 ff ff       	jmp    105220 <alltraps>

00105908 <vector54>:
.globl vector54
vector54:
  pushl $0
  105908:	6a 00                	push   $0x0
  pushl $54
  10590a:	6a 36                	push   $0x36
  jmp alltraps
  10590c:	e9 0f f9 ff ff       	jmp    105220 <alltraps>

00105911 <vector55>:
.globl vector55
vector55:
  pushl $0
  105911:	6a 00                	push   $0x0
  pushl $55
  105913:	6a 37                	push   $0x37
  jmp alltraps
  105915:	e9 06 f9 ff ff       	jmp    105220 <alltraps>

0010591a <vector56>:
.globl vector56
vector56:
  pushl $0
  10591a:	6a 00                	push   $0x0
  pushl $56
  10591c:	6a 38                	push   $0x38
  jmp alltraps
  10591e:	e9 fd f8 ff ff       	jmp    105220 <alltraps>

00105923 <vector57>:
.globl vector57
vector57:
  pushl $0
  105923:	6a 00                	push   $0x0
  pushl $57
  105925:	6a 39                	push   $0x39
  jmp alltraps
  105927:	e9 f4 f8 ff ff       	jmp    105220 <alltraps>

0010592c <vector58>:
.globl vector58
vector58:
  pushl $0
  10592c:	6a 00                	push   $0x0
  pushl $58
  10592e:	6a 3a                	push   $0x3a
  jmp alltraps
  105930:	e9 eb f8 ff ff       	jmp    105220 <alltraps>

00105935 <vector59>:
.globl vector59
vector59:
  pushl $0
  105935:	6a 00                	push   $0x0
  pushl $59
  105937:	6a 3b                	push   $0x3b
  jmp alltraps
  105939:	e9 e2 f8 ff ff       	jmp    105220 <alltraps>

0010593e <vector60>:
.globl vector60
vector60:
  pushl $0
  10593e:	6a 00                	push   $0x0
  pushl $60
  105940:	6a 3c                	push   $0x3c
  jmp alltraps
  105942:	e9 d9 f8 ff ff       	jmp    105220 <alltraps>

00105947 <vector61>:
.globl vector61
vector61:
  pushl $0
  105947:	6a 00                	push   $0x0
  pushl $61
  105949:	6a 3d                	push   $0x3d
  jmp alltraps
  10594b:	e9 d0 f8 ff ff       	jmp    105220 <alltraps>

00105950 <vector62>:
.globl vector62
vector62:
  pushl $0
  105950:	6a 00                	push   $0x0
  pushl $62
  105952:	6a 3e                	push   $0x3e
  jmp alltraps
  105954:	e9 c7 f8 ff ff       	jmp    105220 <alltraps>

00105959 <vector63>:
.globl vector63
vector63:
  pushl $0
  105959:	6a 00                	push   $0x0
  pushl $63
  10595b:	6a 3f                	push   $0x3f
  jmp alltraps
  10595d:	e9 be f8 ff ff       	jmp    105220 <alltraps>

00105962 <vector64>:
.globl vector64
vector64:
  pushl $0
  105962:	6a 00                	push   $0x0
  pushl $64
  105964:	6a 40                	push   $0x40
  jmp alltraps
  105966:	e9 b5 f8 ff ff       	jmp    105220 <alltraps>

0010596b <vector65>:
.globl vector65
vector65:
  pushl $0
  10596b:	6a 00                	push   $0x0
  pushl $65
  10596d:	6a 41                	push   $0x41
  jmp alltraps
  10596f:	e9 ac f8 ff ff       	jmp    105220 <alltraps>

00105974 <vector66>:
.globl vector66
vector66:
  pushl $0
  105974:	6a 00                	push   $0x0
  pushl $66
  105976:	6a 42                	push   $0x42
  jmp alltraps
  105978:	e9 a3 f8 ff ff       	jmp    105220 <alltraps>

0010597d <vector67>:
.globl vector67
vector67:
  pushl $0
  10597d:	6a 00                	push   $0x0
  pushl $67
  10597f:	6a 43                	push   $0x43
  jmp alltraps
  105981:	e9 9a f8 ff ff       	jmp    105220 <alltraps>

00105986 <vector68>:
.globl vector68
vector68:
  pushl $0
  105986:	6a 00                	push   $0x0
  pushl $68
  105988:	6a 44                	push   $0x44
  jmp alltraps
  10598a:	e9 91 f8 ff ff       	jmp    105220 <alltraps>

0010598f <vector69>:
.globl vector69
vector69:
  pushl $0
  10598f:	6a 00                	push   $0x0
  pushl $69
  105991:	6a 45                	push   $0x45
  jmp alltraps
  105993:	e9 88 f8 ff ff       	jmp    105220 <alltraps>

00105998 <vector70>:
.globl vector70
vector70:
  pushl $0
  105998:	6a 00                	push   $0x0
  pushl $70
  10599a:	6a 46                	push   $0x46
  jmp alltraps
  10599c:	e9 7f f8 ff ff       	jmp    105220 <alltraps>

001059a1 <vector71>:
.globl vector71
vector71:
  pushl $0
  1059a1:	6a 00                	push   $0x0
  pushl $71
  1059a3:	6a 47                	push   $0x47
  jmp alltraps
  1059a5:	e9 76 f8 ff ff       	jmp    105220 <alltraps>

001059aa <vector72>:
.globl vector72
vector72:
  pushl $0
  1059aa:	6a 00                	push   $0x0
  pushl $72
  1059ac:	6a 48                	push   $0x48
  jmp alltraps
  1059ae:	e9 6d f8 ff ff       	jmp    105220 <alltraps>

001059b3 <vector73>:
.globl vector73
vector73:
  pushl $0
  1059b3:	6a 00                	push   $0x0
  pushl $73
  1059b5:	6a 49                	push   $0x49
  jmp alltraps
  1059b7:	e9 64 f8 ff ff       	jmp    105220 <alltraps>

001059bc <vector74>:
.globl vector74
vector74:
  pushl $0
  1059bc:	6a 00                	push   $0x0
  pushl $74
  1059be:	6a 4a                	push   $0x4a
  jmp alltraps
  1059c0:	e9 5b f8 ff ff       	jmp    105220 <alltraps>

001059c5 <vector75>:
.globl vector75
vector75:
  pushl $0
  1059c5:	6a 00                	push   $0x0
  pushl $75
  1059c7:	6a 4b                	push   $0x4b
  jmp alltraps
  1059c9:	e9 52 f8 ff ff       	jmp    105220 <alltraps>

001059ce <vector76>:
.globl vector76
vector76:
  pushl $0
  1059ce:	6a 00                	push   $0x0
  pushl $76
  1059d0:	6a 4c                	push   $0x4c
  jmp alltraps
  1059d2:	e9 49 f8 ff ff       	jmp    105220 <alltraps>

001059d7 <vector77>:
.globl vector77
vector77:
  pushl $0
  1059d7:	6a 00                	push   $0x0
  pushl $77
  1059d9:	6a 4d                	push   $0x4d
  jmp alltraps
  1059db:	e9 40 f8 ff ff       	jmp    105220 <alltraps>

001059e0 <vector78>:
.globl vector78
vector78:
  pushl $0
  1059e0:	6a 00                	push   $0x0
  pushl $78
  1059e2:	6a 4e                	push   $0x4e
  jmp alltraps
  1059e4:	e9 37 f8 ff ff       	jmp    105220 <alltraps>

001059e9 <vector79>:
.globl vector79
vector79:
  pushl $0
  1059e9:	6a 00                	push   $0x0
  pushl $79
  1059eb:	6a 4f                	push   $0x4f
  jmp alltraps
  1059ed:	e9 2e f8 ff ff       	jmp    105220 <alltraps>

001059f2 <vector80>:
.globl vector80
vector80:
  pushl $0
  1059f2:	6a 00                	push   $0x0
  pushl $80
  1059f4:	6a 50                	push   $0x50
  jmp alltraps
  1059f6:	e9 25 f8 ff ff       	jmp    105220 <alltraps>

001059fb <vector81>:
.globl vector81
vector81:
  pushl $0
  1059fb:	6a 00                	push   $0x0
  pushl $81
  1059fd:	6a 51                	push   $0x51
  jmp alltraps
  1059ff:	e9 1c f8 ff ff       	jmp    105220 <alltraps>

00105a04 <vector82>:
.globl vector82
vector82:
  pushl $0
  105a04:	6a 00                	push   $0x0
  pushl $82
  105a06:	6a 52                	push   $0x52
  jmp alltraps
  105a08:	e9 13 f8 ff ff       	jmp    105220 <alltraps>

00105a0d <vector83>:
.globl vector83
vector83:
  pushl $0
  105a0d:	6a 00                	push   $0x0
  pushl $83
  105a0f:	6a 53                	push   $0x53
  jmp alltraps
  105a11:	e9 0a f8 ff ff       	jmp    105220 <alltraps>

00105a16 <vector84>:
.globl vector84
vector84:
  pushl $0
  105a16:	6a 00                	push   $0x0
  pushl $84
  105a18:	6a 54                	push   $0x54
  jmp alltraps
  105a1a:	e9 01 f8 ff ff       	jmp    105220 <alltraps>

00105a1f <vector85>:
.globl vector85
vector85:
  pushl $0
  105a1f:	6a 00                	push   $0x0
  pushl $85
  105a21:	6a 55                	push   $0x55
  jmp alltraps
  105a23:	e9 f8 f7 ff ff       	jmp    105220 <alltraps>

00105a28 <vector86>:
.globl vector86
vector86:
  pushl $0
  105a28:	6a 00                	push   $0x0
  pushl $86
  105a2a:	6a 56                	push   $0x56
  jmp alltraps
  105a2c:	e9 ef f7 ff ff       	jmp    105220 <alltraps>

00105a31 <vector87>:
.globl vector87
vector87:
  pushl $0
  105a31:	6a 00                	push   $0x0
  pushl $87
  105a33:	6a 57                	push   $0x57
  jmp alltraps
  105a35:	e9 e6 f7 ff ff       	jmp    105220 <alltraps>

00105a3a <vector88>:
.globl vector88
vector88:
  pushl $0
  105a3a:	6a 00                	push   $0x0
  pushl $88
  105a3c:	6a 58                	push   $0x58
  jmp alltraps
  105a3e:	e9 dd f7 ff ff       	jmp    105220 <alltraps>

00105a43 <vector89>:
.globl vector89
vector89:
  pushl $0
  105a43:	6a 00                	push   $0x0
  pushl $89
  105a45:	6a 59                	push   $0x59
  jmp alltraps
  105a47:	e9 d4 f7 ff ff       	jmp    105220 <alltraps>

00105a4c <vector90>:
.globl vector90
vector90:
  pushl $0
  105a4c:	6a 00                	push   $0x0
  pushl $90
  105a4e:	6a 5a                	push   $0x5a
  jmp alltraps
  105a50:	e9 cb f7 ff ff       	jmp    105220 <alltraps>

00105a55 <vector91>:
.globl vector91
vector91:
  pushl $0
  105a55:	6a 00                	push   $0x0
  pushl $91
  105a57:	6a 5b                	push   $0x5b
  jmp alltraps
  105a59:	e9 c2 f7 ff ff       	jmp    105220 <alltraps>

00105a5e <vector92>:
.globl vector92
vector92:
  pushl $0
  105a5e:	6a 00                	push   $0x0
  pushl $92
  105a60:	6a 5c                	push   $0x5c
  jmp alltraps
  105a62:	e9 b9 f7 ff ff       	jmp    105220 <alltraps>

00105a67 <vector93>:
.globl vector93
vector93:
  pushl $0
  105a67:	6a 00                	push   $0x0
  pushl $93
  105a69:	6a 5d                	push   $0x5d
  jmp alltraps
  105a6b:	e9 b0 f7 ff ff       	jmp    105220 <alltraps>

00105a70 <vector94>:
.globl vector94
vector94:
  pushl $0
  105a70:	6a 00                	push   $0x0
  pushl $94
  105a72:	6a 5e                	push   $0x5e
  jmp alltraps
  105a74:	e9 a7 f7 ff ff       	jmp    105220 <alltraps>

00105a79 <vector95>:
.globl vector95
vector95:
  pushl $0
  105a79:	6a 00                	push   $0x0
  pushl $95
  105a7b:	6a 5f                	push   $0x5f
  jmp alltraps
  105a7d:	e9 9e f7 ff ff       	jmp    105220 <alltraps>

00105a82 <vector96>:
.globl vector96
vector96:
  pushl $0
  105a82:	6a 00                	push   $0x0
  pushl $96
  105a84:	6a 60                	push   $0x60
  jmp alltraps
  105a86:	e9 95 f7 ff ff       	jmp    105220 <alltraps>

00105a8b <vector97>:
.globl vector97
vector97:
  pushl $0
  105a8b:	6a 00                	push   $0x0
  pushl $97
  105a8d:	6a 61                	push   $0x61
  jmp alltraps
  105a8f:	e9 8c f7 ff ff       	jmp    105220 <alltraps>

00105a94 <vector98>:
.globl vector98
vector98:
  pushl $0
  105a94:	6a 00                	push   $0x0
  pushl $98
  105a96:	6a 62                	push   $0x62
  jmp alltraps
  105a98:	e9 83 f7 ff ff       	jmp    105220 <alltraps>

00105a9d <vector99>:
.globl vector99
vector99:
  pushl $0
  105a9d:	6a 00                	push   $0x0
  pushl $99
  105a9f:	6a 63                	push   $0x63
  jmp alltraps
  105aa1:	e9 7a f7 ff ff       	jmp    105220 <alltraps>

00105aa6 <vector100>:
.globl vector100
vector100:
  pushl $0
  105aa6:	6a 00                	push   $0x0
  pushl $100
  105aa8:	6a 64                	push   $0x64
  jmp alltraps
  105aaa:	e9 71 f7 ff ff       	jmp    105220 <alltraps>

00105aaf <vector101>:
.globl vector101
vector101:
  pushl $0
  105aaf:	6a 00                	push   $0x0
  pushl $101
  105ab1:	6a 65                	push   $0x65
  jmp alltraps
  105ab3:	e9 68 f7 ff ff       	jmp    105220 <alltraps>

00105ab8 <vector102>:
.globl vector102
vector102:
  pushl $0
  105ab8:	6a 00                	push   $0x0
  pushl $102
  105aba:	6a 66                	push   $0x66
  jmp alltraps
  105abc:	e9 5f f7 ff ff       	jmp    105220 <alltraps>

00105ac1 <vector103>:
.globl vector103
vector103:
  pushl $0
  105ac1:	6a 00                	push   $0x0
  pushl $103
  105ac3:	6a 67                	push   $0x67
  jmp alltraps
  105ac5:	e9 56 f7 ff ff       	jmp    105220 <alltraps>

00105aca <vector104>:
.globl vector104
vector104:
  pushl $0
  105aca:	6a 00                	push   $0x0
  pushl $104
  105acc:	6a 68                	push   $0x68
  jmp alltraps
  105ace:	e9 4d f7 ff ff       	jmp    105220 <alltraps>

00105ad3 <vector105>:
.globl vector105
vector105:
  pushl $0
  105ad3:	6a 00                	push   $0x0
  pushl $105
  105ad5:	6a 69                	push   $0x69
  jmp alltraps
  105ad7:	e9 44 f7 ff ff       	jmp    105220 <alltraps>

00105adc <vector106>:
.globl vector106
vector106:
  pushl $0
  105adc:	6a 00                	push   $0x0
  pushl $106
  105ade:	6a 6a                	push   $0x6a
  jmp alltraps
  105ae0:	e9 3b f7 ff ff       	jmp    105220 <alltraps>

00105ae5 <vector107>:
.globl vector107
vector107:
  pushl $0
  105ae5:	6a 00                	push   $0x0
  pushl $107
  105ae7:	6a 6b                	push   $0x6b
  jmp alltraps
  105ae9:	e9 32 f7 ff ff       	jmp    105220 <alltraps>

00105aee <vector108>:
.globl vector108
vector108:
  pushl $0
  105aee:	6a 00                	push   $0x0
  pushl $108
  105af0:	6a 6c                	push   $0x6c
  jmp alltraps
  105af2:	e9 29 f7 ff ff       	jmp    105220 <alltraps>

00105af7 <vector109>:
.globl vector109
vector109:
  pushl $0
  105af7:	6a 00                	push   $0x0
  pushl $109
  105af9:	6a 6d                	push   $0x6d
  jmp alltraps
  105afb:	e9 20 f7 ff ff       	jmp    105220 <alltraps>

00105b00 <vector110>:
.globl vector110
vector110:
  pushl $0
  105b00:	6a 00                	push   $0x0
  pushl $110
  105b02:	6a 6e                	push   $0x6e
  jmp alltraps
  105b04:	e9 17 f7 ff ff       	jmp    105220 <alltraps>

00105b09 <vector111>:
.globl vector111
vector111:
  pushl $0
  105b09:	6a 00                	push   $0x0
  pushl $111
  105b0b:	6a 6f                	push   $0x6f
  jmp alltraps
  105b0d:	e9 0e f7 ff ff       	jmp    105220 <alltraps>

00105b12 <vector112>:
.globl vector112
vector112:
  pushl $0
  105b12:	6a 00                	push   $0x0
  pushl $112
  105b14:	6a 70                	push   $0x70
  jmp alltraps
  105b16:	e9 05 f7 ff ff       	jmp    105220 <alltraps>

00105b1b <vector113>:
.globl vector113
vector113:
  pushl $0
  105b1b:	6a 00                	push   $0x0
  pushl $113
  105b1d:	6a 71                	push   $0x71
  jmp alltraps
  105b1f:	e9 fc f6 ff ff       	jmp    105220 <alltraps>

00105b24 <vector114>:
.globl vector114
vector114:
  pushl $0
  105b24:	6a 00                	push   $0x0
  pushl $114
  105b26:	6a 72                	push   $0x72
  jmp alltraps
  105b28:	e9 f3 f6 ff ff       	jmp    105220 <alltraps>

00105b2d <vector115>:
.globl vector115
vector115:
  pushl $0
  105b2d:	6a 00                	push   $0x0
  pushl $115
  105b2f:	6a 73                	push   $0x73
  jmp alltraps
  105b31:	e9 ea f6 ff ff       	jmp    105220 <alltraps>

00105b36 <vector116>:
.globl vector116
vector116:
  pushl $0
  105b36:	6a 00                	push   $0x0
  pushl $116
  105b38:	6a 74                	push   $0x74
  jmp alltraps
  105b3a:	e9 e1 f6 ff ff       	jmp    105220 <alltraps>

00105b3f <vector117>:
.globl vector117
vector117:
  pushl $0
  105b3f:	6a 00                	push   $0x0
  pushl $117
  105b41:	6a 75                	push   $0x75
  jmp alltraps
  105b43:	e9 d8 f6 ff ff       	jmp    105220 <alltraps>

00105b48 <vector118>:
.globl vector118
vector118:
  pushl $0
  105b48:	6a 00                	push   $0x0
  pushl $118
  105b4a:	6a 76                	push   $0x76
  jmp alltraps
  105b4c:	e9 cf f6 ff ff       	jmp    105220 <alltraps>

00105b51 <vector119>:
.globl vector119
vector119:
  pushl $0
  105b51:	6a 00                	push   $0x0
  pushl $119
  105b53:	6a 77                	push   $0x77
  jmp alltraps
  105b55:	e9 c6 f6 ff ff       	jmp    105220 <alltraps>

00105b5a <vector120>:
.globl vector120
vector120:
  pushl $0
  105b5a:	6a 00                	push   $0x0
  pushl $120
  105b5c:	6a 78                	push   $0x78
  jmp alltraps
  105b5e:	e9 bd f6 ff ff       	jmp    105220 <alltraps>

00105b63 <vector121>:
.globl vector121
vector121:
  pushl $0
  105b63:	6a 00                	push   $0x0
  pushl $121
  105b65:	6a 79                	push   $0x79
  jmp alltraps
  105b67:	e9 b4 f6 ff ff       	jmp    105220 <alltraps>

00105b6c <vector122>:
.globl vector122
vector122:
  pushl $0
  105b6c:	6a 00                	push   $0x0
  pushl $122
  105b6e:	6a 7a                	push   $0x7a
  jmp alltraps
  105b70:	e9 ab f6 ff ff       	jmp    105220 <alltraps>

00105b75 <vector123>:
.globl vector123
vector123:
  pushl $0
  105b75:	6a 00                	push   $0x0
  pushl $123
  105b77:	6a 7b                	push   $0x7b
  jmp alltraps
  105b79:	e9 a2 f6 ff ff       	jmp    105220 <alltraps>

00105b7e <vector124>:
.globl vector124
vector124:
  pushl $0
  105b7e:	6a 00                	push   $0x0
  pushl $124
  105b80:	6a 7c                	push   $0x7c
  jmp alltraps
  105b82:	e9 99 f6 ff ff       	jmp    105220 <alltraps>

00105b87 <vector125>:
.globl vector125
vector125:
  pushl $0
  105b87:	6a 00                	push   $0x0
  pushl $125
  105b89:	6a 7d                	push   $0x7d
  jmp alltraps
  105b8b:	e9 90 f6 ff ff       	jmp    105220 <alltraps>

00105b90 <vector126>:
.globl vector126
vector126:
  pushl $0
  105b90:	6a 00                	push   $0x0
  pushl $126
  105b92:	6a 7e                	push   $0x7e
  jmp alltraps
  105b94:	e9 87 f6 ff ff       	jmp    105220 <alltraps>

00105b99 <vector127>:
.globl vector127
vector127:
  pushl $0
  105b99:	6a 00                	push   $0x0
  pushl $127
  105b9b:	6a 7f                	push   $0x7f
  jmp alltraps
  105b9d:	e9 7e f6 ff ff       	jmp    105220 <alltraps>

00105ba2 <vector128>:
.globl vector128
vector128:
  pushl $0
  105ba2:	6a 00                	push   $0x0
  pushl $128
  105ba4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  105ba9:	e9 72 f6 ff ff       	jmp    105220 <alltraps>

00105bae <vector129>:
.globl vector129
vector129:
  pushl $0
  105bae:	6a 00                	push   $0x0
  pushl $129
  105bb0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  105bb5:	e9 66 f6 ff ff       	jmp    105220 <alltraps>

00105bba <vector130>:
.globl vector130
vector130:
  pushl $0
  105bba:	6a 00                	push   $0x0
  pushl $130
  105bbc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  105bc1:	e9 5a f6 ff ff       	jmp    105220 <alltraps>

00105bc6 <vector131>:
.globl vector131
vector131:
  pushl $0
  105bc6:	6a 00                	push   $0x0
  pushl $131
  105bc8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  105bcd:	e9 4e f6 ff ff       	jmp    105220 <alltraps>

00105bd2 <vector132>:
.globl vector132
vector132:
  pushl $0
  105bd2:	6a 00                	push   $0x0
  pushl $132
  105bd4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  105bd9:	e9 42 f6 ff ff       	jmp    105220 <alltraps>

00105bde <vector133>:
.globl vector133
vector133:
  pushl $0
  105bde:	6a 00                	push   $0x0
  pushl $133
  105be0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  105be5:	e9 36 f6 ff ff       	jmp    105220 <alltraps>

00105bea <vector134>:
.globl vector134
vector134:
  pushl $0
  105bea:	6a 00                	push   $0x0
  pushl $134
  105bec:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  105bf1:	e9 2a f6 ff ff       	jmp    105220 <alltraps>

00105bf6 <vector135>:
.globl vector135
vector135:
  pushl $0
  105bf6:	6a 00                	push   $0x0
  pushl $135
  105bf8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  105bfd:	e9 1e f6 ff ff       	jmp    105220 <alltraps>

00105c02 <vector136>:
.globl vector136
vector136:
  pushl $0
  105c02:	6a 00                	push   $0x0
  pushl $136
  105c04:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  105c09:	e9 12 f6 ff ff       	jmp    105220 <alltraps>

00105c0e <vector137>:
.globl vector137
vector137:
  pushl $0
  105c0e:	6a 00                	push   $0x0
  pushl $137
  105c10:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  105c15:	e9 06 f6 ff ff       	jmp    105220 <alltraps>

00105c1a <vector138>:
.globl vector138
vector138:
  pushl $0
  105c1a:	6a 00                	push   $0x0
  pushl $138
  105c1c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  105c21:	e9 fa f5 ff ff       	jmp    105220 <alltraps>

00105c26 <vector139>:
.globl vector139
vector139:
  pushl $0
  105c26:	6a 00                	push   $0x0
  pushl $139
  105c28:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  105c2d:	e9 ee f5 ff ff       	jmp    105220 <alltraps>

00105c32 <vector140>:
.globl vector140
vector140:
  pushl $0
  105c32:	6a 00                	push   $0x0
  pushl $140
  105c34:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  105c39:	e9 e2 f5 ff ff       	jmp    105220 <alltraps>

00105c3e <vector141>:
.globl vector141
vector141:
  pushl $0
  105c3e:	6a 00                	push   $0x0
  pushl $141
  105c40:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  105c45:	e9 d6 f5 ff ff       	jmp    105220 <alltraps>

00105c4a <vector142>:
.globl vector142
vector142:
  pushl $0
  105c4a:	6a 00                	push   $0x0
  pushl $142
  105c4c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  105c51:	e9 ca f5 ff ff       	jmp    105220 <alltraps>

00105c56 <vector143>:
.globl vector143
vector143:
  pushl $0
  105c56:	6a 00                	push   $0x0
  pushl $143
  105c58:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  105c5d:	e9 be f5 ff ff       	jmp    105220 <alltraps>

00105c62 <vector144>:
.globl vector144
vector144:
  pushl $0
  105c62:	6a 00                	push   $0x0
  pushl $144
  105c64:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  105c69:	e9 b2 f5 ff ff       	jmp    105220 <alltraps>

00105c6e <vector145>:
.globl vector145
vector145:
  pushl $0
  105c6e:	6a 00                	push   $0x0
  pushl $145
  105c70:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  105c75:	e9 a6 f5 ff ff       	jmp    105220 <alltraps>

00105c7a <vector146>:
.globl vector146
vector146:
  pushl $0
  105c7a:	6a 00                	push   $0x0
  pushl $146
  105c7c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  105c81:	e9 9a f5 ff ff       	jmp    105220 <alltraps>

00105c86 <vector147>:
.globl vector147
vector147:
  pushl $0
  105c86:	6a 00                	push   $0x0
  pushl $147
  105c88:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  105c8d:	e9 8e f5 ff ff       	jmp    105220 <alltraps>

00105c92 <vector148>:
.globl vector148
vector148:
  pushl $0
  105c92:	6a 00                	push   $0x0
  pushl $148
  105c94:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  105c99:	e9 82 f5 ff ff       	jmp    105220 <alltraps>

00105c9e <vector149>:
.globl vector149
vector149:
  pushl $0
  105c9e:	6a 00                	push   $0x0
  pushl $149
  105ca0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  105ca5:	e9 76 f5 ff ff       	jmp    105220 <alltraps>

00105caa <vector150>:
.globl vector150
vector150:
  pushl $0
  105caa:	6a 00                	push   $0x0
  pushl $150
  105cac:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  105cb1:	e9 6a f5 ff ff       	jmp    105220 <alltraps>

00105cb6 <vector151>:
.globl vector151
vector151:
  pushl $0
  105cb6:	6a 00                	push   $0x0
  pushl $151
  105cb8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  105cbd:	e9 5e f5 ff ff       	jmp    105220 <alltraps>

00105cc2 <vector152>:
.globl vector152
vector152:
  pushl $0
  105cc2:	6a 00                	push   $0x0
  pushl $152
  105cc4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  105cc9:	e9 52 f5 ff ff       	jmp    105220 <alltraps>

00105cce <vector153>:
.globl vector153
vector153:
  pushl $0
  105cce:	6a 00                	push   $0x0
  pushl $153
  105cd0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  105cd5:	e9 46 f5 ff ff       	jmp    105220 <alltraps>

00105cda <vector154>:
.globl vector154
vector154:
  pushl $0
  105cda:	6a 00                	push   $0x0
  pushl $154
  105cdc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  105ce1:	e9 3a f5 ff ff       	jmp    105220 <alltraps>

00105ce6 <vector155>:
.globl vector155
vector155:
  pushl $0
  105ce6:	6a 00                	push   $0x0
  pushl $155
  105ce8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  105ced:	e9 2e f5 ff ff       	jmp    105220 <alltraps>

00105cf2 <vector156>:
.globl vector156
vector156:
  pushl $0
  105cf2:	6a 00                	push   $0x0
  pushl $156
  105cf4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  105cf9:	e9 22 f5 ff ff       	jmp    105220 <alltraps>

00105cfe <vector157>:
.globl vector157
vector157:
  pushl $0
  105cfe:	6a 00                	push   $0x0
  pushl $157
  105d00:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  105d05:	e9 16 f5 ff ff       	jmp    105220 <alltraps>

00105d0a <vector158>:
.globl vector158
vector158:
  pushl $0
  105d0a:	6a 00                	push   $0x0
  pushl $158
  105d0c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  105d11:	e9 0a f5 ff ff       	jmp    105220 <alltraps>

00105d16 <vector159>:
.globl vector159
vector159:
  pushl $0
  105d16:	6a 00                	push   $0x0
  pushl $159
  105d18:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  105d1d:	e9 fe f4 ff ff       	jmp    105220 <alltraps>

00105d22 <vector160>:
.globl vector160
vector160:
  pushl $0
  105d22:	6a 00                	push   $0x0
  pushl $160
  105d24:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  105d29:	e9 f2 f4 ff ff       	jmp    105220 <alltraps>

00105d2e <vector161>:
.globl vector161
vector161:
  pushl $0
  105d2e:	6a 00                	push   $0x0
  pushl $161
  105d30:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  105d35:	e9 e6 f4 ff ff       	jmp    105220 <alltraps>

00105d3a <vector162>:
.globl vector162
vector162:
  pushl $0
  105d3a:	6a 00                	push   $0x0
  pushl $162
  105d3c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  105d41:	e9 da f4 ff ff       	jmp    105220 <alltraps>

00105d46 <vector163>:
.globl vector163
vector163:
  pushl $0
  105d46:	6a 00                	push   $0x0
  pushl $163
  105d48:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  105d4d:	e9 ce f4 ff ff       	jmp    105220 <alltraps>

00105d52 <vector164>:
.globl vector164
vector164:
  pushl $0
  105d52:	6a 00                	push   $0x0
  pushl $164
  105d54:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  105d59:	e9 c2 f4 ff ff       	jmp    105220 <alltraps>

00105d5e <vector165>:
.globl vector165
vector165:
  pushl $0
  105d5e:	6a 00                	push   $0x0
  pushl $165
  105d60:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  105d65:	e9 b6 f4 ff ff       	jmp    105220 <alltraps>

00105d6a <vector166>:
.globl vector166
vector166:
  pushl $0
  105d6a:	6a 00                	push   $0x0
  pushl $166
  105d6c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  105d71:	e9 aa f4 ff ff       	jmp    105220 <alltraps>

00105d76 <vector167>:
.globl vector167
vector167:
  pushl $0
  105d76:	6a 00                	push   $0x0
  pushl $167
  105d78:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  105d7d:	e9 9e f4 ff ff       	jmp    105220 <alltraps>

00105d82 <vector168>:
.globl vector168
vector168:
  pushl $0
  105d82:	6a 00                	push   $0x0
  pushl $168
  105d84:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  105d89:	e9 92 f4 ff ff       	jmp    105220 <alltraps>

00105d8e <vector169>:
.globl vector169
vector169:
  pushl $0
  105d8e:	6a 00                	push   $0x0
  pushl $169
  105d90:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  105d95:	e9 86 f4 ff ff       	jmp    105220 <alltraps>

00105d9a <vector170>:
.globl vector170
vector170:
  pushl $0
  105d9a:	6a 00                	push   $0x0
  pushl $170
  105d9c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  105da1:	e9 7a f4 ff ff       	jmp    105220 <alltraps>

00105da6 <vector171>:
.globl vector171
vector171:
  pushl $0
  105da6:	6a 00                	push   $0x0
  pushl $171
  105da8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  105dad:	e9 6e f4 ff ff       	jmp    105220 <alltraps>

00105db2 <vector172>:
.globl vector172
vector172:
  pushl $0
  105db2:	6a 00                	push   $0x0
  pushl $172
  105db4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  105db9:	e9 62 f4 ff ff       	jmp    105220 <alltraps>

00105dbe <vector173>:
.globl vector173
vector173:
  pushl $0
  105dbe:	6a 00                	push   $0x0
  pushl $173
  105dc0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  105dc5:	e9 56 f4 ff ff       	jmp    105220 <alltraps>

00105dca <vector174>:
.globl vector174
vector174:
  pushl $0
  105dca:	6a 00                	push   $0x0
  pushl $174
  105dcc:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  105dd1:	e9 4a f4 ff ff       	jmp    105220 <alltraps>

00105dd6 <vector175>:
.globl vector175
vector175:
  pushl $0
  105dd6:	6a 00                	push   $0x0
  pushl $175
  105dd8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  105ddd:	e9 3e f4 ff ff       	jmp    105220 <alltraps>

00105de2 <vector176>:
.globl vector176
vector176:
  pushl $0
  105de2:	6a 00                	push   $0x0
  pushl $176
  105de4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  105de9:	e9 32 f4 ff ff       	jmp    105220 <alltraps>

00105dee <vector177>:
.globl vector177
vector177:
  pushl $0
  105dee:	6a 00                	push   $0x0
  pushl $177
  105df0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  105df5:	e9 26 f4 ff ff       	jmp    105220 <alltraps>

00105dfa <vector178>:
.globl vector178
vector178:
  pushl $0
  105dfa:	6a 00                	push   $0x0
  pushl $178
  105dfc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  105e01:	e9 1a f4 ff ff       	jmp    105220 <alltraps>

00105e06 <vector179>:
.globl vector179
vector179:
  pushl $0
  105e06:	6a 00                	push   $0x0
  pushl $179
  105e08:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  105e0d:	e9 0e f4 ff ff       	jmp    105220 <alltraps>

00105e12 <vector180>:
.globl vector180
vector180:
  pushl $0
  105e12:	6a 00                	push   $0x0
  pushl $180
  105e14:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  105e19:	e9 02 f4 ff ff       	jmp    105220 <alltraps>

00105e1e <vector181>:
.globl vector181
vector181:
  pushl $0
  105e1e:	6a 00                	push   $0x0
  pushl $181
  105e20:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  105e25:	e9 f6 f3 ff ff       	jmp    105220 <alltraps>

00105e2a <vector182>:
.globl vector182
vector182:
  pushl $0
  105e2a:	6a 00                	push   $0x0
  pushl $182
  105e2c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  105e31:	e9 ea f3 ff ff       	jmp    105220 <alltraps>

00105e36 <vector183>:
.globl vector183
vector183:
  pushl $0
  105e36:	6a 00                	push   $0x0
  pushl $183
  105e38:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  105e3d:	e9 de f3 ff ff       	jmp    105220 <alltraps>

00105e42 <vector184>:
.globl vector184
vector184:
  pushl $0
  105e42:	6a 00                	push   $0x0
  pushl $184
  105e44:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  105e49:	e9 d2 f3 ff ff       	jmp    105220 <alltraps>

00105e4e <vector185>:
.globl vector185
vector185:
  pushl $0
  105e4e:	6a 00                	push   $0x0
  pushl $185
  105e50:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  105e55:	e9 c6 f3 ff ff       	jmp    105220 <alltraps>

00105e5a <vector186>:
.globl vector186
vector186:
  pushl $0
  105e5a:	6a 00                	push   $0x0
  pushl $186
  105e5c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  105e61:	e9 ba f3 ff ff       	jmp    105220 <alltraps>

00105e66 <vector187>:
.globl vector187
vector187:
  pushl $0
  105e66:	6a 00                	push   $0x0
  pushl $187
  105e68:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  105e6d:	e9 ae f3 ff ff       	jmp    105220 <alltraps>

00105e72 <vector188>:
.globl vector188
vector188:
  pushl $0
  105e72:	6a 00                	push   $0x0
  pushl $188
  105e74:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  105e79:	e9 a2 f3 ff ff       	jmp    105220 <alltraps>

00105e7e <vector189>:
.globl vector189
vector189:
  pushl $0
  105e7e:	6a 00                	push   $0x0
  pushl $189
  105e80:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  105e85:	e9 96 f3 ff ff       	jmp    105220 <alltraps>

00105e8a <vector190>:
.globl vector190
vector190:
  pushl $0
  105e8a:	6a 00                	push   $0x0
  pushl $190
  105e8c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  105e91:	e9 8a f3 ff ff       	jmp    105220 <alltraps>

00105e96 <vector191>:
.globl vector191
vector191:
  pushl $0
  105e96:	6a 00                	push   $0x0
  pushl $191
  105e98:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  105e9d:	e9 7e f3 ff ff       	jmp    105220 <alltraps>

00105ea2 <vector192>:
.globl vector192
vector192:
  pushl $0
  105ea2:	6a 00                	push   $0x0
  pushl $192
  105ea4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  105ea9:	e9 72 f3 ff ff       	jmp    105220 <alltraps>

00105eae <vector193>:
.globl vector193
vector193:
  pushl $0
  105eae:	6a 00                	push   $0x0
  pushl $193
  105eb0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  105eb5:	e9 66 f3 ff ff       	jmp    105220 <alltraps>

00105eba <vector194>:
.globl vector194
vector194:
  pushl $0
  105eba:	6a 00                	push   $0x0
  pushl $194
  105ebc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  105ec1:	e9 5a f3 ff ff       	jmp    105220 <alltraps>

00105ec6 <vector195>:
.globl vector195
vector195:
  pushl $0
  105ec6:	6a 00                	push   $0x0
  pushl $195
  105ec8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  105ecd:	e9 4e f3 ff ff       	jmp    105220 <alltraps>

00105ed2 <vector196>:
.globl vector196
vector196:
  pushl $0
  105ed2:	6a 00                	push   $0x0
  pushl $196
  105ed4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  105ed9:	e9 42 f3 ff ff       	jmp    105220 <alltraps>

00105ede <vector197>:
.globl vector197
vector197:
  pushl $0
  105ede:	6a 00                	push   $0x0
  pushl $197
  105ee0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  105ee5:	e9 36 f3 ff ff       	jmp    105220 <alltraps>

00105eea <vector198>:
.globl vector198
vector198:
  pushl $0
  105eea:	6a 00                	push   $0x0
  pushl $198
  105eec:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  105ef1:	e9 2a f3 ff ff       	jmp    105220 <alltraps>

00105ef6 <vector199>:
.globl vector199
vector199:
  pushl $0
  105ef6:	6a 00                	push   $0x0
  pushl $199
  105ef8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  105efd:	e9 1e f3 ff ff       	jmp    105220 <alltraps>

00105f02 <vector200>:
.globl vector200
vector200:
  pushl $0
  105f02:	6a 00                	push   $0x0
  pushl $200
  105f04:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  105f09:	e9 12 f3 ff ff       	jmp    105220 <alltraps>

00105f0e <vector201>:
.globl vector201
vector201:
  pushl $0
  105f0e:	6a 00                	push   $0x0
  pushl $201
  105f10:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  105f15:	e9 06 f3 ff ff       	jmp    105220 <alltraps>

00105f1a <vector202>:
.globl vector202
vector202:
  pushl $0
  105f1a:	6a 00                	push   $0x0
  pushl $202
  105f1c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  105f21:	e9 fa f2 ff ff       	jmp    105220 <alltraps>

00105f26 <vector203>:
.globl vector203
vector203:
  pushl $0
  105f26:	6a 00                	push   $0x0
  pushl $203
  105f28:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  105f2d:	e9 ee f2 ff ff       	jmp    105220 <alltraps>

00105f32 <vector204>:
.globl vector204
vector204:
  pushl $0
  105f32:	6a 00                	push   $0x0
  pushl $204
  105f34:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  105f39:	e9 e2 f2 ff ff       	jmp    105220 <alltraps>

00105f3e <vector205>:
.globl vector205
vector205:
  pushl $0
  105f3e:	6a 00                	push   $0x0
  pushl $205
  105f40:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  105f45:	e9 d6 f2 ff ff       	jmp    105220 <alltraps>

00105f4a <vector206>:
.globl vector206
vector206:
  pushl $0
  105f4a:	6a 00                	push   $0x0
  pushl $206
  105f4c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  105f51:	e9 ca f2 ff ff       	jmp    105220 <alltraps>

00105f56 <vector207>:
.globl vector207
vector207:
  pushl $0
  105f56:	6a 00                	push   $0x0
  pushl $207
  105f58:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  105f5d:	e9 be f2 ff ff       	jmp    105220 <alltraps>

00105f62 <vector208>:
.globl vector208
vector208:
  pushl $0
  105f62:	6a 00                	push   $0x0
  pushl $208
  105f64:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  105f69:	e9 b2 f2 ff ff       	jmp    105220 <alltraps>

00105f6e <vector209>:
.globl vector209
vector209:
  pushl $0
  105f6e:	6a 00                	push   $0x0
  pushl $209
  105f70:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  105f75:	e9 a6 f2 ff ff       	jmp    105220 <alltraps>

00105f7a <vector210>:
.globl vector210
vector210:
  pushl $0
  105f7a:	6a 00                	push   $0x0
  pushl $210
  105f7c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  105f81:	e9 9a f2 ff ff       	jmp    105220 <alltraps>

00105f86 <vector211>:
.globl vector211
vector211:
  pushl $0
  105f86:	6a 00                	push   $0x0
  pushl $211
  105f88:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  105f8d:	e9 8e f2 ff ff       	jmp    105220 <alltraps>

00105f92 <vector212>:
.globl vector212
vector212:
  pushl $0
  105f92:	6a 00                	push   $0x0
  pushl $212
  105f94:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  105f99:	e9 82 f2 ff ff       	jmp    105220 <alltraps>

00105f9e <vector213>:
.globl vector213
vector213:
  pushl $0
  105f9e:	6a 00                	push   $0x0
  pushl $213
  105fa0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  105fa5:	e9 76 f2 ff ff       	jmp    105220 <alltraps>

00105faa <vector214>:
.globl vector214
vector214:
  pushl $0
  105faa:	6a 00                	push   $0x0
  pushl $214
  105fac:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  105fb1:	e9 6a f2 ff ff       	jmp    105220 <alltraps>

00105fb6 <vector215>:
.globl vector215
vector215:
  pushl $0
  105fb6:	6a 00                	push   $0x0
  pushl $215
  105fb8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  105fbd:	e9 5e f2 ff ff       	jmp    105220 <alltraps>

00105fc2 <vector216>:
.globl vector216
vector216:
  pushl $0
  105fc2:	6a 00                	push   $0x0
  pushl $216
  105fc4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  105fc9:	e9 52 f2 ff ff       	jmp    105220 <alltraps>

00105fce <vector217>:
.globl vector217
vector217:
  pushl $0
  105fce:	6a 00                	push   $0x0
  pushl $217
  105fd0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  105fd5:	e9 46 f2 ff ff       	jmp    105220 <alltraps>

00105fda <vector218>:
.globl vector218
vector218:
  pushl $0
  105fda:	6a 00                	push   $0x0
  pushl $218
  105fdc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  105fe1:	e9 3a f2 ff ff       	jmp    105220 <alltraps>

00105fe6 <vector219>:
.globl vector219
vector219:
  pushl $0
  105fe6:	6a 00                	push   $0x0
  pushl $219
  105fe8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  105fed:	e9 2e f2 ff ff       	jmp    105220 <alltraps>

00105ff2 <vector220>:
.globl vector220
vector220:
  pushl $0
  105ff2:	6a 00                	push   $0x0
  pushl $220
  105ff4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  105ff9:	e9 22 f2 ff ff       	jmp    105220 <alltraps>

00105ffe <vector221>:
.globl vector221
vector221:
  pushl $0
  105ffe:	6a 00                	push   $0x0
  pushl $221
  106000:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  106005:	e9 16 f2 ff ff       	jmp    105220 <alltraps>

0010600a <vector222>:
.globl vector222
vector222:
  pushl $0
  10600a:	6a 00                	push   $0x0
  pushl $222
  10600c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  106011:	e9 0a f2 ff ff       	jmp    105220 <alltraps>

00106016 <vector223>:
.globl vector223
vector223:
  pushl $0
  106016:	6a 00                	push   $0x0
  pushl $223
  106018:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  10601d:	e9 fe f1 ff ff       	jmp    105220 <alltraps>

00106022 <vector224>:
.globl vector224
vector224:
  pushl $0
  106022:	6a 00                	push   $0x0
  pushl $224
  106024:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  106029:	e9 f2 f1 ff ff       	jmp    105220 <alltraps>

0010602e <vector225>:
.globl vector225
vector225:
  pushl $0
  10602e:	6a 00                	push   $0x0
  pushl $225
  106030:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  106035:	e9 e6 f1 ff ff       	jmp    105220 <alltraps>

0010603a <vector226>:
.globl vector226
vector226:
  pushl $0
  10603a:	6a 00                	push   $0x0
  pushl $226
  10603c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  106041:	e9 da f1 ff ff       	jmp    105220 <alltraps>

00106046 <vector227>:
.globl vector227
vector227:
  pushl $0
  106046:	6a 00                	push   $0x0
  pushl $227
  106048:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  10604d:	e9 ce f1 ff ff       	jmp    105220 <alltraps>

00106052 <vector228>:
.globl vector228
vector228:
  pushl $0
  106052:	6a 00                	push   $0x0
  pushl $228
  106054:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  106059:	e9 c2 f1 ff ff       	jmp    105220 <alltraps>

0010605e <vector229>:
.globl vector229
vector229:
  pushl $0
  10605e:	6a 00                	push   $0x0
  pushl $229
  106060:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  106065:	e9 b6 f1 ff ff       	jmp    105220 <alltraps>

0010606a <vector230>:
.globl vector230
vector230:
  pushl $0
  10606a:	6a 00                	push   $0x0
  pushl $230
  10606c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  106071:	e9 aa f1 ff ff       	jmp    105220 <alltraps>

00106076 <vector231>:
.globl vector231
vector231:
  pushl $0
  106076:	6a 00                	push   $0x0
  pushl $231
  106078:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  10607d:	e9 9e f1 ff ff       	jmp    105220 <alltraps>

00106082 <vector232>:
.globl vector232
vector232:
  pushl $0
  106082:	6a 00                	push   $0x0
  pushl $232
  106084:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  106089:	e9 92 f1 ff ff       	jmp    105220 <alltraps>

0010608e <vector233>:
.globl vector233
vector233:
  pushl $0
  10608e:	6a 00                	push   $0x0
  pushl $233
  106090:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  106095:	e9 86 f1 ff ff       	jmp    105220 <alltraps>

0010609a <vector234>:
.globl vector234
vector234:
  pushl $0
  10609a:	6a 00                	push   $0x0
  pushl $234
  10609c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  1060a1:	e9 7a f1 ff ff       	jmp    105220 <alltraps>

001060a6 <vector235>:
.globl vector235
vector235:
  pushl $0
  1060a6:	6a 00                	push   $0x0
  pushl $235
  1060a8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  1060ad:	e9 6e f1 ff ff       	jmp    105220 <alltraps>

001060b2 <vector236>:
.globl vector236
vector236:
  pushl $0
  1060b2:	6a 00                	push   $0x0
  pushl $236
  1060b4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  1060b9:	e9 62 f1 ff ff       	jmp    105220 <alltraps>

001060be <vector237>:
.globl vector237
vector237:
  pushl $0
  1060be:	6a 00                	push   $0x0
  pushl $237
  1060c0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  1060c5:	e9 56 f1 ff ff       	jmp    105220 <alltraps>

001060ca <vector238>:
.globl vector238
vector238:
  pushl $0
  1060ca:	6a 00                	push   $0x0
  pushl $238
  1060cc:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  1060d1:	e9 4a f1 ff ff       	jmp    105220 <alltraps>

001060d6 <vector239>:
.globl vector239
vector239:
  pushl $0
  1060d6:	6a 00                	push   $0x0
  pushl $239
  1060d8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  1060dd:	e9 3e f1 ff ff       	jmp    105220 <alltraps>

001060e2 <vector240>:
.globl vector240
vector240:
  pushl $0
  1060e2:	6a 00                	push   $0x0
  pushl $240
  1060e4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  1060e9:	e9 32 f1 ff ff       	jmp    105220 <alltraps>

001060ee <vector241>:
.globl vector241
vector241:
  pushl $0
  1060ee:	6a 00                	push   $0x0
  pushl $241
  1060f0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  1060f5:	e9 26 f1 ff ff       	jmp    105220 <alltraps>

001060fa <vector242>:
.globl vector242
vector242:
  pushl $0
  1060fa:	6a 00                	push   $0x0
  pushl $242
  1060fc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  106101:	e9 1a f1 ff ff       	jmp    105220 <alltraps>

00106106 <vector243>:
.globl vector243
vector243:
  pushl $0
  106106:	6a 00                	push   $0x0
  pushl $243
  106108:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  10610d:	e9 0e f1 ff ff       	jmp    105220 <alltraps>

00106112 <vector244>:
.globl vector244
vector244:
  pushl $0
  106112:	6a 00                	push   $0x0
  pushl $244
  106114:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  106119:	e9 02 f1 ff ff       	jmp    105220 <alltraps>

0010611e <vector245>:
.globl vector245
vector245:
  pushl $0
  10611e:	6a 00                	push   $0x0
  pushl $245
  106120:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  106125:	e9 f6 f0 ff ff       	jmp    105220 <alltraps>

0010612a <vector246>:
.globl vector246
vector246:
  pushl $0
  10612a:	6a 00                	push   $0x0
  pushl $246
  10612c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  106131:	e9 ea f0 ff ff       	jmp    105220 <alltraps>

00106136 <vector247>:
.globl vector247
vector247:
  pushl $0
  106136:	6a 00                	push   $0x0
  pushl $247
  106138:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  10613d:	e9 de f0 ff ff       	jmp    105220 <alltraps>

00106142 <vector248>:
.globl vector248
vector248:
  pushl $0
  106142:	6a 00                	push   $0x0
  pushl $248
  106144:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  106149:	e9 d2 f0 ff ff       	jmp    105220 <alltraps>

0010614e <vector249>:
.globl vector249
vector249:
  pushl $0
  10614e:	6a 00                	push   $0x0
  pushl $249
  106150:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  106155:	e9 c6 f0 ff ff       	jmp    105220 <alltraps>

0010615a <vector250>:
.globl vector250
vector250:
  pushl $0
  10615a:	6a 00                	push   $0x0
  pushl $250
  10615c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  106161:	e9 ba f0 ff ff       	jmp    105220 <alltraps>

00106166 <vector251>:
.globl vector251
vector251:
  pushl $0
  106166:	6a 00                	push   $0x0
  pushl $251
  106168:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  10616d:	e9 ae f0 ff ff       	jmp    105220 <alltraps>

00106172 <vector252>:
.globl vector252
vector252:
  pushl $0
  106172:	6a 00                	push   $0x0
  pushl $252
  106174:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  106179:	e9 a2 f0 ff ff       	jmp    105220 <alltraps>

0010617e <vector253>:
.globl vector253
vector253:
  pushl $0
  10617e:	6a 00                	push   $0x0
  pushl $253
  106180:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  106185:	e9 96 f0 ff ff       	jmp    105220 <alltraps>

0010618a <vector254>:
.globl vector254
vector254:
  pushl $0
  10618a:	6a 00                	push   $0x0
  pushl $254
  10618c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  106191:	e9 8a f0 ff ff       	jmp    105220 <alltraps>

00106196 <vector255>:
.globl vector255
vector255:
  pushl $0
  106196:	6a 00                	push   $0x0
  pushl $255
  106198:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  10619d:	e9 7e f0 ff ff       	jmp    105220 <alltraps>
  1061a2:	90                   	nop
  1061a3:	90                   	nop
  1061a4:	90                   	nop
  1061a5:	90                   	nop
  1061a6:	90                   	nop
  1061a7:	90                   	nop
  1061a8:	90                   	nop
  1061a9:	90                   	nop
  1061aa:	90                   	nop
  1061ab:	90                   	nop
  1061ac:	90                   	nop
  1061ad:	90                   	nop
  1061ae:	90                   	nop
  1061af:	90                   	nop

001061b0 <vmenable>:
}

// Turn on paging.
void
vmenable(void)
{
  1061b0:	55                   	push   %ebp
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  1061b1:	a1 b4 91 10 00       	mov    0x1091b4,%eax
  1061b6:	89 e5                	mov    %esp,%ebp
  1061b8:	0f 22 d8             	mov    %eax,%cr3

static inline uint
rcr0(void)
{
  uint val;
  asm volatile("movl %%cr0,%0" : "=r" (val));
  1061bb:	0f 20 c0             	mov    %cr0,%eax
}

static inline void
lcr0(uint val)
{
  asm volatile("movl %0,%%cr0" : : "r" (val));
  1061be:	0d 00 00 00 80       	or     $0x80000000,%eax
  1061c3:	0f 22 c0             	mov    %eax,%cr0

  switchkvm(); // load kpgdir into cr3
  cr0 = rcr0();
  cr0 |= CR0_PG;
  lcr0(cr0);
}
  1061c6:	5d                   	pop    %ebp
  1061c7:	c3                   	ret    
  1061c8:	90                   	nop
  1061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001061d0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm()
{
  1061d0:	55                   	push   %ebp
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  1061d1:	a1 b4 91 10 00       	mov    0x1091b4,%eax
  1061d6:	89 e5                	mov    %esp,%ebp
  1061d8:	0f 22 d8             	mov    %eax,%cr3
  lcr3(PADDR(kpgdir));   // switch to the kernel page table
}
  1061db:	5d                   	pop    %ebp
  1061dc:	c3                   	ret    
  1061dd:	8d 76 00             	lea    0x0(%esi),%esi

001061e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to linear address va.  If create!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int create)
{
  1061e0:	55                   	push   %ebp
  1061e1:	89 e5                	mov    %esp,%ebp
  1061e3:	83 ec 28             	sub    $0x28,%esp
  1061e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  uint r;
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  1061e9:	89 d3                	mov    %edx,%ebx
  1061eb:	c1 eb 16             	shr    $0x16,%ebx
  1061ee:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
// Return the address of the PTE in page table pgdir
// that corresponds to linear address va.  If create!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int create)
{
  1061f1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  uint r;
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
  1061f4:	8b 33                	mov    (%ebx),%esi
  1061f6:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1061fc:	74 22                	je     106220 <walkpgdir+0x40>
    pgtab = (pte_t*) PTE_ADDR(*pde);
  1061fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
  106204:	c1 ea 0a             	shr    $0xa,%edx
  106207:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
  10620d:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
  106210:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  106213:	8b 75 fc             	mov    -0x4(%ebp),%esi
  106216:	89 ec                	mov    %ebp,%esp
  106218:	5d                   	pop    %ebp
  106219:	c3                   	ret    
  10621a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*) PTE_ADDR(*pde);
  } else if(!create || !(r = (uint) kalloc()))
  106220:	85 c9                	test   %ecx,%ecx
  106222:	75 04                	jne    106228 <walkpgdir+0x48>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
  106224:	31 c0                	xor    %eax,%eax
  106226:	eb e8                	jmp    106210 <walkpgdir+0x30>
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*) PTE_ADDR(*pde);
  } else if(!create || !(r = (uint) kalloc()))
  106228:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10622b:	90                   	nop
  10622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106230:	e8 fb c1 ff ff       	call   102430 <kalloc>
  106235:	85 c0                	test   %eax,%eax
  106237:	74 eb                	je     106224 <walkpgdir+0x44>
    return 0;
  else {
    pgtab = (pte_t*) r;
  106239:	89 c6                	mov    %eax,%esi
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
  10623b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106242:	00 
  106243:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10624a:	00 
  10624b:	89 04 24             	mov    %eax,(%esp)
  10624e:	e8 3d de ff ff       	call   104090 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  106253:	89 f0                	mov    %esi,%eax
  106255:	83 c8 07             	or     $0x7,%eax
  106258:	89 03                	mov    %eax,(%ebx)
  10625a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10625d:	eb a5                	jmp    106204 <walkpgdir+0x24>
  10625f:	90                   	nop

00106260 <mappages>:
// Create PTEs for linear addresses starting at la that refer to
// physical addresses starting at pa. la and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *la, uint size, uint pa, int perm)
{
  106260:	55                   	push   %ebp
  106261:	89 e5                	mov    %esp,%ebp
  106263:	57                   	push   %edi
  106264:	56                   	push   %esi
  106265:	53                   	push   %ebx
  char *a = PGROUNDDOWN(la);
  106266:	89 d3                	mov    %edx,%ebx
  char *last = PGROUNDDOWN(la + size - 1);
  106268:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
// Create PTEs for linear addresses starting at la that refer to
// physical addresses starting at pa. la and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *la, uint size, uint pa, int perm)
{
  10626c:	83 ec 2c             	sub    $0x2c,%esp
  10626f:	8b 75 08             	mov    0x8(%ebp),%esi
  106272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a = PGROUNDDOWN(la);
  106275:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(la + size - 1);
  10627b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
  106281:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  106285:	eb 1d                	jmp    1062a4 <mappages+0x44>
  106287:	90                   	nop

  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
  106288:	f6 00 01             	testb  $0x1,(%eax)
  10628b:	75 48                	jne    1062d5 <mappages+0x75>
      panic("remap");
    *pte = pa | perm | PTE_P;
  10628d:	8b 55 0c             	mov    0xc(%ebp),%edx
  106290:	09 f2                	or     %esi,%edx
    if(a == last)
  106292:	39 fb                	cmp    %edi,%ebx
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
  106294:	89 10                	mov    %edx,(%eax)
    if(a == last)
  106296:	74 30                	je     1062c8 <mappages+0x68>
      break;
    a += PGSIZE;
  106298:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
  10629e:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
  char *a = PGROUNDDOWN(la);
  char *last = PGROUNDDOWN(la + size - 1);

  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
  1062a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1062a7:	b9 01 00 00 00       	mov    $0x1,%ecx
  1062ac:	89 da                	mov    %ebx,%edx
  1062ae:	e8 2d ff ff ff       	call   1061e0 <walkpgdir>
    if(pte == 0)
  1062b3:	85 c0                	test   %eax,%eax
  1062b5:	75 d1                	jne    106288 <mappages+0x28>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 1;
}
  1062b7:	83 c4 2c             	add    $0x2c,%esp
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  1062ba:	31 c0                	xor    %eax,%eax
  return 1;
}
  1062bc:	5b                   	pop    %ebx
  1062bd:	5e                   	pop    %esi
  1062be:	5f                   	pop    %edi
  1062bf:	5d                   	pop    %ebp
  1062c0:	c3                   	ret    
  1062c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1062c8:	83 c4 2c             	add    $0x2c,%esp
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
  1062cb:	b8 01 00 00 00       	mov    $0x1,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 1;
}
  1062d0:	5b                   	pop    %ebx
  1062d1:	5e                   	pop    %esi
  1062d2:	5f                   	pop    %edi
  1062d3:	5d                   	pop    %ebp
  1062d4:	c3                   	ret    
  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
  1062d5:	c7 04 24 14 72 10 00 	movl   $0x107214,(%esp)
  1062dc:	e8 af a7 ff ff       	call   100a90 <panic>
  1062e1:	eb 0d                	jmp    1062f0 <uva2ka>
  1062e3:	90                   	nop
  1062e4:	90                   	nop
  1062e5:	90                   	nop
  1062e6:	90                   	nop
  1062e7:	90                   	nop
  1062e8:	90                   	nop
  1062e9:	90                   	nop
  1062ea:	90                   	nop
  1062eb:	90                   	nop
  1062ec:	90                   	nop
  1062ed:	90                   	nop
  1062ee:	90                   	nop
  1062ef:	90                   	nop

001062f0 <uva2ka>:
// maps to.  The result is also a kernel logical address,
// since the kernel maps the physical memory allocated to user
// processes directly.
char*
uva2ka(pde_t *pgdir, char *uva)
{    
  1062f0:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, uva, 0);
  1062f1:	31 c9                	xor    %ecx,%ecx
// maps to.  The result is also a kernel logical address,
// since the kernel maps the physical memory allocated to user
// processes directly.
char*
uva2ka(pde_t *pgdir, char *uva)
{    
  1062f3:	89 e5                	mov    %esp,%ebp
  1062f5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, uva, 0);
  1062f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1062fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1062fe:	e8 dd fe ff ff       	call   1061e0 <walkpgdir>
  106303:	89 c2                	mov    %eax,%edx
  if(pte == 0) return 0;
  106305:	31 c0                	xor    %eax,%eax
  106307:	85 d2                	test   %edx,%edx
  106309:	74 07                	je     106312 <uva2ka+0x22>
  uint pa = PTE_ADDR(*pte);
  return (char *)pa;
  10630b:	8b 02                	mov    (%edx),%eax
  10630d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
  106312:	c9                   	leave  
  106313:	c3                   	ret    
  106314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10631a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106320 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  106320:	55                   	push   %ebp
  106321:	89 e5                	mov    %esp,%ebp
  106323:	83 ec 38             	sub    $0x38,%esp
  106326:	8b 45 08             	mov    0x8(%ebp),%eax
  106329:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10632c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10632f:	8b 75 10             	mov    0x10(%ebp),%esi
  106332:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106335:	8b 7d 0c             	mov    0xc(%ebp),%edi
  106338:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem = kalloc();
  10633b:	e8 f0 c0 ff ff       	call   102430 <kalloc>
  if (sz >= PGSIZE)
  106340:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = kalloc();
  106346:	89 c3                	mov    %eax,%ebx
  if (sz >= PGSIZE)
  106348:	77 4c                	ja     106396 <inituvm+0x76>
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  10634a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106351:	00 
  106352:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106359:	00 
  10635a:	89 04 24             	mov    %eax,(%esp)
  10635d:	e8 2e dd ff ff       	call   104090 <memset>
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  106362:	b9 00 10 00 00       	mov    $0x1000,%ecx
  106367:	31 d2                	xor    %edx,%edx
  106369:	89 1c 24             	mov    %ebx,(%esp)
  10636c:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  106373:	00 
  106374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106377:	e8 e4 fe ff ff       	call   106260 <mappages>
  memmove(mem, init, sz);
  10637c:	89 75 10             	mov    %esi,0x10(%ebp)
}
  10637f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106382:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
  106385:	8b 7d fc             	mov    -0x4(%ebp),%edi
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106388:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10638b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10638e:	89 ec                	mov    %ebp,%esp
  106390:	5d                   	pop    %ebp
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106391:	e9 7a dd ff ff       	jmp    104110 <memmove>
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  106396:	c7 04 24 1a 72 10 00 	movl   $0x10721a,(%esp)
  10639d:	e8 ee a6 ff ff       	call   100a90 <panic>
  1063a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001063b0 <setupkvm>:
}

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  1063b0:	55                   	push   %ebp
  1063b1:	89 e5                	mov    %esp,%ebp
  1063b3:	53                   	push   %ebx
  1063b4:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
  1063b7:	e8 74 c0 ff ff       	call   102430 <kalloc>
  1063bc:	85 c0                	test   %eax,%eax
  1063be:	89 c3                	mov    %eax,%ebx
  1063c0:	75 0e                	jne    1063d0 <setupkvm+0x20>
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
    return 0;
  return pgdir;
}
  1063c2:	89 d8                	mov    %ebx,%eax
  1063c4:	83 c4 14             	add    $0x14,%esp
  1063c7:	5b                   	pop    %ebx
  1063c8:	5d                   	pop    %ebp
  1063c9:	c3                   	ret    
  1063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde_t *pgdir;

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  1063d0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1063d7:	00 
  1063d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1063df:	00 
  1063e0:	89 04 24             	mov    %eax,(%esp)
  1063e3:	e8 a8 dc ff ff       	call   104090 <memset>
  if(// Map IO space from 640K to 1Mbyte
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
  1063e8:	b9 00 00 06 00       	mov    $0x60000,%ecx
  1063ed:	ba 00 00 0a 00       	mov    $0xa0000,%edx
  1063f2:	89 d8                	mov    %ebx,%eax
  1063f4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1063fb:	00 
  1063fc:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  106403:	e8 58 fe ff ff       	call   106260 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  106408:	85 c0                	test   %eax,%eax
  10640a:	75 0a                	jne    106416 <setupkvm+0x66>
  10640c:	31 db                	xor    %ebx,%ebx
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
    return 0;
  return pgdir;
}
  10640e:	83 c4 14             	add    $0x14,%esp
  106411:	89 d8                	mov    %ebx,%eax
  106413:	5b                   	pop    %ebx
  106414:	5d                   	pop    %ebp
  106415:	c3                   	ret    
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
     // Map kernel and free memory pool
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
  106416:	b9 00 00 f0 00       	mov    $0xf00000,%ecx
  10641b:	ba 00 00 10 00       	mov    $0x100000,%edx
  106420:	89 d8                	mov    %ebx,%eax
  106422:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  106429:	00 
  10642a:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
  106431:	e8 2a fe ff ff       	call   106260 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  106436:	85 c0                	test   %eax,%eax
  106438:	74 d2                	je     10640c <setupkvm+0x5c>
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
     // Map kernel and free memory pool
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
  10643a:	b9 00 00 00 02       	mov    $0x2000000,%ecx
  10643f:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
  106444:	89 d8                	mov    %ebx,%eax
  106446:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10644d:	00 
  10644e:	c7 04 24 00 00 00 fe 	movl   $0xfe000000,(%esp)
  106455:	e8 06 fe ff ff       	call   106260 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  10645a:	85 c0                	test   %eax,%eax
  10645c:	0f 85 60 ff ff ff    	jne    1063c2 <setupkvm+0x12>
  106462:	eb a8                	jmp    10640c <setupkvm+0x5c>
  106464:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10646a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106470 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  106470:	55                   	push   %ebp
  106471:	89 e5                	mov    %esp,%ebp
  106473:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
  106476:	e8 35 ff ff ff       	call   1063b0 <setupkvm>
  10647b:	a3 b4 91 10 00       	mov    %eax,0x1091b4
}
  106480:	c9                   	leave  
  106481:	c3                   	ret    
  106482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106490 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106490:	55                   	push   %ebp
  106491:	89 e5                	mov    %esp,%ebp
  106493:	57                   	push   %edi
  106494:	56                   	push   %esi
  106495:	53                   	push   %ebx
  106496:	83 ec 2c             	sub    $0x2c,%esp
  char *a = (char *)PGROUNDUP(newsz);
  106499:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  10649c:	8b 75 0c             	mov    0xc(%ebp),%esi
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  10649f:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a = (char *)PGROUNDUP(newsz);
  1064a2:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  1064a8:	83 ee 01             	sub    $0x1,%esi
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  1064ab:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  1064b1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a <= last; a += PGSIZE){
  1064b7:	39 f3                	cmp    %esi,%ebx
  1064b9:	77 41                	ja     1064fc <deallocuvm+0x6c>
  1064bb:	90                   	nop
  1064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte_t *pte = walkpgdir(pgdir, a, 0);
  1064c0:	31 c9                	xor    %ecx,%ecx
  1064c2:	89 da                	mov    %ebx,%edx
  1064c4:	89 f8                	mov    %edi,%eax
  1064c6:	e8 15 fd ff ff       	call   1061e0 <walkpgdir>
    if(pte && (*pte & PTE_P) != 0){
  1064cb:	85 c0                	test   %eax,%eax
  1064cd:	74 23                	je     1064f2 <deallocuvm+0x62>
  1064cf:	8b 10                	mov    (%eax),%edx
  1064d1:	f6 c2 01             	test   $0x1,%dl
  1064d4:	74 1c                	je     1064f2 <deallocuvm+0x62>
      uint pa = PTE_ADDR(*pte);
      if(pa == 0)
  1064d6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1064dc:	74 3d                	je     10651b <deallocuvm+0x8b>
        panic("kfree");
      kfree((void *) pa);
  1064de:	89 14 24             	mov    %edx,(%esp)
  1064e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1064e4:	e8 87 bf ff ff       	call   102470 <kfree>
      *pte = 0;
  1064e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1064ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  char *last = PGROUNDDOWN(oldsz - 1);
  for(; a <= last; a += PGSIZE){
  1064f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  1064f8:	39 de                	cmp    %ebx,%esi
  1064fa:	73 c4                	jae    1064c0 <deallocuvm+0x30>
  1064fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1064ff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  106502:	77 0c                	ja     106510 <deallocuvm+0x80>
      kfree((void *) pa);
      *pte = 0;
    }
  }
  return newsz < oldsz ? newsz : oldsz;
}
  106504:	83 c4 2c             	add    $0x2c,%esp
  106507:	5b                   	pop    %ebx
  106508:	5e                   	pop    %esi
  106509:	5f                   	pop    %edi
  10650a:	5d                   	pop    %ebp
  10650b:	c3                   	ret    
  10650c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  char *last = PGROUNDDOWN(oldsz - 1);
  for(; a <= last; a += PGSIZE){
  106510:	8b 45 0c             	mov    0xc(%ebp),%eax
      kfree((void *) pa);
      *pte = 0;
    }
  }
  return newsz < oldsz ? newsz : oldsz;
}
  106513:	83 c4 2c             	add    $0x2c,%esp
  106516:	5b                   	pop    %ebx
  106517:	5e                   	pop    %esi
  106518:	5f                   	pop    %edi
  106519:	5d                   	pop    %ebp
  10651a:	c3                   	ret    
  for(; a <= last; a += PGSIZE){
    pte_t *pte = walkpgdir(pgdir, a, 0);
    if(pte && (*pte & PTE_P) != 0){
      uint pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
  10651b:	c7 04 24 b6 6b 10 00 	movl   $0x106bb6,(%esp)
  106522:	e8 69 a5 ff ff       	call   100a90 <panic>
  106527:	89 f6                	mov    %esi,%esi
  106529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106530 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  106530:	55                   	push   %ebp
  106531:	89 e5                	mov    %esp,%ebp
  106533:	56                   	push   %esi
  106534:	53                   	push   %ebx
  106535:	83 ec 10             	sub    $0x10,%esp
  106538:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(!pgdir)
  10653b:	85 db                	test   %ebx,%ebx
  10653d:	74 59                	je     106598 <freevm+0x68>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  10653f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  106546:	00 
  106547:	31 f6                	xor    %esi,%esi
  106549:	c7 44 24 04 00 00 0a 	movl   $0xa0000,0x4(%esp)
  106550:	00 
  106551:	89 1c 24             	mov    %ebx,(%esp)
  106554:	e8 37 ff ff ff       	call   106490 <deallocuvm>
  106559:	eb 10                	jmp    10656b <freevm+0x3b>
  10655b:	90                   	nop
  10655c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
  106560:	83 c6 01             	add    $0x1,%esi
  106563:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106569:	74 1f                	je     10658a <freevm+0x5a>
    if(pgdir[i] & PTE_P)
  10656b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  10656e:	a8 01                	test   $0x1,%al
  106570:	74 ee                	je     106560 <freevm+0x30>
      kfree((void *) PTE_ADDR(pgdir[i]));
  106572:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
  106577:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  10657a:	89 04 24             	mov    %eax,(%esp)
  10657d:	e8 ee be ff ff       	call   102470 <kfree>
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
  106582:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106588:	75 e1                	jne    10656b <freevm+0x3b>
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  }
  kfree((void *) pgdir);
  10658a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10658d:	83 c4 10             	add    $0x10,%esp
  106590:	5b                   	pop    %ebx
  106591:	5e                   	pop    %esi
  106592:	5d                   	pop    %ebp
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  }
  kfree((void *) pgdir);
  106593:	e9 d8 be ff ff       	jmp    102470 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  106598:	c7 04 24 34 72 10 00 	movl   $0x107234,(%esp)
  10659f:	e8 ec a4 ff ff       	call   100a90 <panic>
  1065a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1065aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001065b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  1065b0:	55                   	push   %ebp
  1065b1:	89 e5                	mov    %esp,%ebp
  1065b3:	57                   	push   %edi
  1065b4:	56                   	push   %esi
  1065b5:	53                   	push   %ebx
  1065b6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d = setupkvm();
  1065b9:	e8 f2 fd ff ff       	call   1063b0 <setupkvm>
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  1065be:	85 c0                	test   %eax,%eax
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d = setupkvm();
  1065c0:	89 c6                	mov    %eax,%esi
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  1065c2:	0f 84 84 00 00 00    	je     10664c <copyuvm+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
  1065c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065cb:	85 c0                	test   %eax,%eax
  1065cd:	74 7d                	je     10664c <copyuvm+0x9c>
  1065cf:	31 db                	xor    %ebx,%ebx
  1065d1:	eb 47                	jmp    10661a <copyuvm+0x6a>
  1065d3:	90                   	nop
  1065d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present\n");
    pa = PTE_ADDR(*pte);
    if(!(mem = kalloc()))
      goto bad;
    memmove(mem, (char *)pa, PGSIZE);
  1065d8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1065de:	89 54 24 04          	mov    %edx,0x4(%esp)
  1065e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1065e9:	00 
  1065ea:	89 04 24             	mov    %eax,(%esp)
  1065ed:	e8 1e db ff ff       	call   104110 <memmove>
    if(!mappages(d, (void *)i, PGSIZE, PADDR(mem), PTE_W|PTE_U))
  1065f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  1065f7:	89 da                	mov    %ebx,%edx
  1065f9:	89 f0                	mov    %esi,%eax
  1065fb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  106602:	00 
  106603:	89 3c 24             	mov    %edi,(%esp)
  106606:	e8 55 fc ff ff       	call   106260 <mappages>
  10660b:	85 c0                	test   %eax,%eax
  10660d:	74 33                	je     106642 <copyuvm+0x92>
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  for(i = 0; i < sz; i += PGSIZE){
  10660f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  106615:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  106618:	76 32                	jbe    10664c <copyuvm+0x9c>
    if(!(pte = walkpgdir(pgdir, (void *)i, 0)))
  10661a:	8b 45 08             	mov    0x8(%ebp),%eax
  10661d:	31 c9                	xor    %ecx,%ecx
  10661f:	89 da                	mov    %ebx,%edx
  106621:	e8 ba fb ff ff       	call   1061e0 <walkpgdir>
  106626:	85 c0                	test   %eax,%eax
  106628:	74 2c                	je     106656 <copyuvm+0xa6>
      panic("copyuvm: pte should exist\n");
    if(!(*pte & PTE_P))
  10662a:	8b 10                	mov    (%eax),%edx
  10662c:	f6 c2 01             	test   $0x1,%dl
  10662f:	74 31                	je     106662 <copyuvm+0xb2>
      panic("copyuvm: page not present\n");
    pa = PTE_ADDR(*pte);
    if(!(mem = kalloc()))
  106631:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106634:	e8 f7 bd ff ff       	call   102430 <kalloc>
  106639:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10663c:	85 c0                	test   %eax,%eax
  10663e:	89 c7                	mov    %eax,%edi
  106640:	75 96                	jne    1065d8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
  106642:	89 34 24             	mov    %esi,(%esp)
  106645:	31 f6                	xor    %esi,%esi
  106647:	e8 e4 fe ff ff       	call   106530 <freevm>
  return 0;
}
  10664c:	83 c4 2c             	add    $0x2c,%esp
  10664f:	89 f0                	mov    %esi,%eax
  106651:	5b                   	pop    %ebx
  106652:	5e                   	pop    %esi
  106653:	5f                   	pop    %edi
  106654:	5d                   	pop    %ebp
  106655:	c3                   	ret    
  char *mem;

  if(!d) return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, (void *)i, 0)))
      panic("copyuvm: pte should exist\n");
  106656:	c7 04 24 45 72 10 00 	movl   $0x107245,(%esp)
  10665d:	e8 2e a4 ff ff       	call   100a90 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present\n");
  106662:	c7 04 24 60 72 10 00 	movl   $0x107260,(%esp)
  106669:	e8 22 a4 ff ff       	call   100a90 <panic>
  10666e:	66 90                	xchg   %ax,%ax

00106670 <allocuvm>:
// newsz. Allocates physical memory and page table entries. oldsz and
// newsz need not be page-aligned, nor does newsz have to be larger
// than oldsz.  Returns the new process size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106670:	55                   	push   %ebp
  if(newsz > USERTOP)
  106671:	31 c0                	xor    %eax,%eax
// newsz. Allocates physical memory and page table entries. oldsz and
// newsz need not be page-aligned, nor does newsz have to be larger
// than oldsz.  Returns the new process size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106673:	89 e5                	mov    %esp,%ebp
  106675:	57                   	push   %edi
  106676:	56                   	push   %esi
  106677:	53                   	push   %ebx
  106678:	83 ec 2c             	sub    $0x2c,%esp
  10667b:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz > USERTOP)
  10667e:	81 7d 10 00 00 0a 00 	cmpl   $0xa0000,0x10(%ebp)
  106685:	0f 87 93 00 00 00    	ja     10671e <allocuvm+0xae>
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  10668b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  10668e:	8b 75 10             	mov    0x10(%ebp),%esi
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  106691:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  106697:	83 ee 01             	sub    $0x1,%esi
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  10669a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  1066a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a <= last; a += PGSIZE){
  1066a6:	39 f3                	cmp    %esi,%ebx
  1066a8:	76 47                	jbe    1066f1 <allocuvm+0x81>
  1066aa:	eb 7c                	jmp    106728 <allocuvm+0xb8>
  1066ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
  1066b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1066b7:	00 
  1066b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1066bf:	00 
  1066c0:	89 04 24             	mov    %eax,(%esp)
  1066c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1066c6:	e8 c5 d9 ff ff       	call   104090 <memset>
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  1066cb:	b9 00 10 00 00       	mov    $0x1000,%ecx
  1066d0:	89 f8                	mov    %edi,%eax
  1066d2:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  1066d9:	00 
  1066da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1066dd:	89 14 24             	mov    %edx,(%esp)
  1066e0:	89 da                	mov    %ebx,%edx
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  char *last = PGROUNDDOWN(newsz - 1);
  for (; a <= last; a += PGSIZE){
  1066e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  1066e8:	e8 73 fb ff ff       	call   106260 <mappages>
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  char *last = PGROUNDDOWN(newsz - 1);
  for (; a <= last; a += PGSIZE){
  1066ed:	39 de                	cmp    %ebx,%esi
  1066ef:	72 37                	jb     106728 <allocuvm+0xb8>
    char *mem = kalloc();
  1066f1:	e8 3a bd ff ff       	call   102430 <kalloc>
    if(mem == 0){
  1066f6:	85 c0                	test   %eax,%eax
  1066f8:	75 b6                	jne    1066b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
  1066fa:	c7 04 24 7b 72 10 00 	movl   $0x10727b,(%esp)
  106701:	e8 ba 9d ff ff       	call   1004c0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
  106706:	8b 45 0c             	mov    0xc(%ebp),%eax
  106709:	89 44 24 08          	mov    %eax,0x8(%esp)
  10670d:	8b 45 10             	mov    0x10(%ebp),%eax
  106710:	89 3c 24             	mov    %edi,(%esp)
  106713:	89 44 24 04          	mov    %eax,0x4(%esp)
  106717:	e8 74 fd ff ff       	call   106490 <deallocuvm>
  10671c:	31 c0                	xor    %eax,%eax
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  }
  return newsz > oldsz ? newsz : oldsz;
}
  10671e:	83 c4 2c             	add    $0x2c,%esp
  106721:	5b                   	pop    %ebx
  106722:	5e                   	pop    %esi
  106723:	5f                   	pop    %edi
  106724:	5d                   	pop    %ebp
  106725:	c3                   	ret    
  106726:	66 90                	xchg   %ax,%ax
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  }
  return newsz > oldsz ? newsz : oldsz;
  106728:	8b 45 10             	mov    0x10(%ebp),%eax
  10672b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10672e:	73 ee                	jae    10671e <allocuvm+0xae>
  106730:	8b 45 0c             	mov    0xc(%ebp),%eax
}
  106733:	83 c4 2c             	add    $0x2c,%esp
  106736:	5b                   	pop    %ebx
  106737:	5e                   	pop    %esi
  106738:	5f                   	pop    %edi
  106739:	5d                   	pop    %ebp
  10673a:	c3                   	ret    
  10673b:	90                   	nop
  10673c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106740 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  106740:	55                   	push   %ebp
  106741:	89 e5                	mov    %esp,%ebp
  106743:	57                   	push   %edi
  106744:	56                   	push   %esi
  106745:	53                   	push   %ebx
  106746:	83 ec 3c             	sub    $0x3c,%esp
  106749:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
  10674c:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  106752:	0f 85 99 00 00 00    	jne    1067f1 <loaduvm+0xb1>
    panic("loaduvm: addr must be page aligned\n");
  106758:	8b 75 18             	mov    0x18(%ebp),%esi
  10675b:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < sz; i += PGSIZE){
  10675d:	85 f6                	test   %esi,%esi
  10675f:	74 77                	je     1067d8 <loaduvm+0x98>
  106761:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  106764:	eb 13                	jmp    106779 <loaduvm+0x39>
  106766:	66 90                	xchg   %ax,%ax
  106768:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  10676e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  106774:	39 5d 18             	cmp    %ebx,0x18(%ebp)
  106777:	76 5f                	jbe    1067d8 <loaduvm+0x98>
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
  106779:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10677c:	31 c9                	xor    %ecx,%ecx
  10677e:	8b 45 08             	mov    0x8(%ebp),%eax
  106781:	01 da                	add    %ebx,%edx
  106783:	e8 58 fa ff ff       	call   1061e0 <walkpgdir>
  106788:	85 c0                	test   %eax,%eax
  10678a:	74 59                	je     1067e5 <loaduvm+0xa5>
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE) n = sz - i;
  10678c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
  106792:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE) n = sz - i;
  106794:	ba 00 10 00 00       	mov    $0x1000,%edx
  106799:	77 02                	ja     10679d <loaduvm+0x5d>
  10679b:	89 f2                	mov    %esi,%edx
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
  10679d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1067a1:	8b 7d 14             	mov    0x14(%ebp),%edi
  1067a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1067a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067ad:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
  1067b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1067b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1067b7:	89 04 24             	mov    %eax,(%esp)
  1067ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1067bd:	e8 6e ad ff ff       	call   101530 <readi>
  1067c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1067c5:	39 d0                	cmp    %edx,%eax
  1067c7:	74 9f                	je     106768 <loaduvm+0x28>
      return 0;
  }
  return 1;
}
  1067c9:	83 c4 3c             	add    $0x3c,%esp
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE) n = sz - i;
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
  1067cc:	31 c0                	xor    %eax,%eax
      return 0;
  }
  return 1;
}
  1067ce:	5b                   	pop    %ebx
  1067cf:	5e                   	pop    %esi
  1067d0:	5f                   	pop    %edi
  1067d1:	5d                   	pop    %ebp
  1067d2:	c3                   	ret    
  1067d3:	90                   	nop
  1067d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1067d8:	83 c4 3c             	add    $0x3c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
  1067db:	b8 01 00 00 00       	mov    $0x1,%eax
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
      return 0;
  }
  return 1;
}
  1067e0:	5b                   	pop    %ebx
  1067e1:	5e                   	pop    %esi
  1067e2:	5f                   	pop    %edi
  1067e3:	5d                   	pop    %ebp
  1067e4:	c3                   	ret    

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
  1067e5:	c7 04 24 cc 72 10 00 	movl   $0x1072cc,(%esp)
  1067ec:	e8 9f a2 ff ff       	call   100a90 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  1067f1:	c7 04 24 a8 72 10 00 	movl   $0x1072a8,(%esp)
  1067f8:	e8 93 a2 ff ff       	call   100a90 <panic>
  1067fd:	8d 76 00             	lea    0x0(%esi),%esi

00106800 <switchuvm>:
}

// Switch h/w page table and TSS registers to point to process p.
void
switchuvm(struct proc *p)
{
  106800:	55                   	push   %ebp
  106801:	89 e5                	mov    %esp,%ebp
  106803:	53                   	push   %ebx
  106804:	83 ec 14             	sub    $0x14,%esp
  106807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
  10680a:	e8 f1 d6 ff ff       	call   103f00 <pushcli>

  // Setup TSS
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  10680f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106815:	8d 50 08             	lea    0x8(%eax),%edx
  106818:	89 d1                	mov    %edx,%ecx
  10681a:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
  106821:	c1 e9 10             	shr    $0x10,%ecx
  106824:	c1 ea 18             	shr    $0x18,%edx
  106827:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  10682d:	c6 80 a5 00 00 00 99 	movb   $0x99,0xa5(%eax)
  106834:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  10683a:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
  106841:	67 00 
  106843:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  10684a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106850:	80 a0 a5 00 00 00 ef 	andb   $0xef,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  106857:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10685d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  106863:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  106869:	8b 50 08             	mov    0x8(%eax),%edx
  10686c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106872:	81 c2 00 10 00 00    	add    $0x1000,%edx
  106878:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  10687b:	b8 30 00 00 00       	mov    $0x30,%eax
  106880:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);

  if(p->pgdir == 0)
  106883:	8b 43 04             	mov    0x4(%ebx),%eax
  106886:	85 c0                	test   %eax,%eax
  106888:	74 0d                	je     106897 <switchuvm+0x97>
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  10688a:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir\n");

  lcr3(PADDR(p->pgdir));  // switch to new address space
  popcli();
}
  10688d:	83 c4 14             	add    $0x14,%esp
  106890:	5b                   	pop    %ebx
  106891:	5d                   	pop    %ebp

  if(p->pgdir == 0)
    panic("switchuvm: no pgdir\n");

  lcr3(PADDR(p->pgdir));  // switch to new address space
  popcli();
  106892:	e9 a9 d6 ff ff       	jmp    103f40 <popcli>
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);

  if(p->pgdir == 0)
    panic("switchuvm: no pgdir\n");
  106897:	c7 04 24 93 72 10 00 	movl   $0x107293,(%esp)
  10689e:	e8 ed a1 ff ff       	call   100a90 <panic>
  1068a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001068b0 <ksegment>:

// Set up CPU's kernel segment descriptors.
// Run once at boot time on each CPU.
void
ksegment(void)
{
  1068b0:	55                   	push   %ebp
  1068b1:	89 e5                	mov    %esp,%ebp
  1068b3:	83 ec 18             	sub    $0x18,%esp

  // Map virtual addresses to linear addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  1068b6:	e8 55 be ff ff       	call   102710 <cpunum>
  1068bb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1068c1:	05 00 c4 10 00       	add    $0x10c400,%eax
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  1068c6:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  1068cc:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
  1068d3:	89 d1                	mov    %edx,%ecx
  1068d5:	c1 ea 18             	shr    $0x18,%edx
  1068d8:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
  1068de:	c1 e9 10             	shr    $0x10,%ecx

  lgdt(c->gdt, sizeof(c->gdt));
  1068e1:	8d 50 70             	lea    0x70(%eax),%edx
  // Map virtual addresses to linear addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  1068e4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
  1068ea:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
  1068f0:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
  1068f4:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
  1068f8:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  1068fc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  106900:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
  106907:	ff ff 
  106909:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
  106910:	00 00 
  106912:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  106919:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
  106920:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  106927:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  10692e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
  106935:	ff ff 
  106937:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
  10693e:	00 00 
  106940:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
  106947:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
  10694e:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  106955:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  10695c:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
  106963:	ff ff 
  106965:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  10696c:	00 00 
  10696e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  106975:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
  10697c:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)
  106983:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  10698a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
  106991:	00 00 
  106993:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
  106999:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
  1069a0:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  1069a7:	66 c7 45 f2 37 00    	movw   $0x37,-0xe(%ebp)
  pd[1] = (uint)p;
  1069ad:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
  1069b1:	c1 ea 10             	shr    $0x10,%edx
  1069b4:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  1069b8:	8d 55 f2             	lea    -0xe(%ebp),%edx
  1069bb:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
  1069be:	ba 18 00 00 00       	mov    $0x18,%edx
  1069c3:	8e ea                	mov    %edx,%gs

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  1069c5:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
  1069cb:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  1069d2:	00 00 00 00 
}
  1069d6:	c9                   	leave  
  1069d7:	c3                   	ret    
