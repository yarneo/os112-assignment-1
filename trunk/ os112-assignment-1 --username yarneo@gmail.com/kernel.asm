
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
  10000f:	c7 04 24 e0 92 10 00 	movl   $0x1092e0,(%esp)
  100016:	e8 a5 40 00 00       	call   1040c0 <acquire>

  b->next->prev = b->prev;
  10001b:	8b 43 10             	mov    0x10(%ebx),%eax
  10001e:	8b 53 0c             	mov    0xc(%ebx),%edx
  100021:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
  100024:	8b 43 0c             	mov    0xc(%ebx),%eax
  100027:	8b 53 10             	mov    0x10(%ebx),%edx
  10002a:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
  10002d:	a1 14 a8 10 00       	mov    0x10a814,%eax
  b->prev = &bcache.head;
  100032:	c7 43 0c 04 a8 10 00 	movl   $0x10a804,0xc(%ebx)

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
  10003c:	a1 14 a8 10 00       	mov    0x10a814,%eax
  100041:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
  100044:	89 1d 14 a8 10 00    	mov    %ebx,0x10a814

  b->flags &= ~B_BUSY;
  10004a:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
  10004d:	89 1c 24             	mov    %ebx,(%esp)
  100050:	e8 4b 32 00 00       	call   1032a0 <wakeup>

  release(&bcache.lock);
  100055:	c7 45 08 e0 92 10 00 	movl   $0x1092e0,0x8(%ebp)
}
  10005c:	83 c4 14             	add    $0x14,%esp
  10005f:	5b                   	pop    %ebx
  100060:	5d                   	pop    %ebp
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
  100061:	e9 0a 40 00 00       	jmp    104070 <release>
// Release the buffer b.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100066:	c7 04 24 c0 6a 10 00 	movl   $0x106ac0,(%esp)
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
  10009e:	c7 04 24 c7 6a 10 00 	movl   $0x106ac7,(%esp)
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
  1000bf:	c7 04 24 e0 92 10 00 	movl   $0x1092e0,(%esp)
  1000c6:	e8 f5 3f 00 00       	call   1040c0 <acquire>

 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  1000cb:	8b 1d 14 a8 10 00    	mov    0x10a814,%ebx
  1000d1:	81 fb 04 a8 10 00    	cmp    $0x10a804,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 35                	jmp    100110 <bread+0x60>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb 04 a8 10 00    	cmp    $0x10a804,%ebx
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
  1000fd:	c7 44 24 04 e0 92 10 	movl   $0x1092e0,0x4(%esp)
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
  100110:	8b 1d 10 a8 10 00    	mov    0x10a810,%ebx
  100116:	81 fb 04 a8 10 00    	cmp    $0x10a804,%ebx
  10011c:	75 0d                	jne    10012b <bread+0x7b>
  10011e:	eb 54                	jmp    100174 <bread+0xc4>
  100120:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  100123:	81 fb 04 a8 10 00    	cmp    $0x10a804,%ebx
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
  10013e:	c7 04 24 e0 92 10 00 	movl   $0x1092e0,(%esp)
  100145:	e8 26 3f 00 00       	call   104070 <release>
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
  100166:	c7 04 24 e0 92 10 00 	movl   $0x1092e0,(%esp)
  10016d:	e8 fe 3e 00 00       	call   104070 <release>
  100172:	eb d6                	jmp    10014a <bread+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
  100174:	c7 04 24 ce 6a 10 00 	movl   $0x106ace,(%esp)
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
  100186:	c7 44 24 04 df 6a 10 	movl   $0x106adf,0x4(%esp)
  10018d:	00 
  10018e:	c7 04 24 e0 92 10 00 	movl   $0x1092e0,(%esp)
  100195:	e8 96 3d 00 00       	call   103f30 <initlock>
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
  10019a:	ba 04 a8 10 00       	mov    $0x10a804,%edx
  10019f:	b8 14 93 10 00       	mov    $0x109314,%eax
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  1001a4:	c7 05 10 a8 10 00 04 	movl   $0x10a804,0x10a810
  1001ab:	a8 10 00 
  bcache.head.next = &bcache.head;
  1001ae:	c7 05 14 a8 10 00 04 	movl   $0x10a804,0x10a814
  1001b5:	a8 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
  1001b8:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
  1001bb:	c7 40 0c 04 a8 10 00 	movl   $0x10a804,0xc(%eax)
    b->dev = -1;
  1001c2:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
  1001c9:	8b 15 14 a8 10 00    	mov    0x10a814,%edx
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
  1001d4:	a3 14 a8 10 00       	mov    %eax,0x10a814
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  1001d9:	05 18 02 00 00       	add    $0x218,%eax
  1001de:	3d 04 a8 10 00       	cmp    $0x10a804,%eax
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
  1001f6:	c7 44 24 04 e6 6a 10 	movl   $0x106ae6,0x4(%esp)
  1001fd:	00 
  1001fe:	c7 04 24 40 92 10 00 	movl   $0x109240,(%esp)
  100205:	e8 26 3d 00 00       	call   103f30 <initlock>
  initlock(&input.lock, "input");
  10020a:	c7 44 24 04 ee 6a 10 	movl   $0x106aee,0x4(%esp)
  100211:	00 
  100212:	c7 04 24 20 aa 10 00 	movl   $0x10aa20,(%esp)
  100219:	e8 12 3d 00 00       	call   103f30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
  10021e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
{
  initlock(&cons.lock, "console");
  initlock(&input.lock, "input");


  devsw[CONSOLE].write = consolewrite;
  100225:	c7 05 8c b4 10 00 d0 	movl   $0x1003d0,0x10b48c
  10022c:	03 10 00 
  devsw[CONSOLE].read = consoleread;
  10022f:	c7 05 88 b4 10 00 20 	movl   $0x100620,0x10b488
  100236:	06 10 00 
  cons.locking = 1;
  100239:	c7 05 74 92 10 00 01 	movl   $0x1,0x109274
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
  10026b:	83 3d c0 8b 10 00 00 	cmpl   $0x0,0x108bc0
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
  100285:	e8 76 54 00 00       	call   105700 <uartputc>
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
  100329:	e8 d2 53 00 00       	call   105700 <uartputc>
  10032e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100335:	e8 c6 53 00 00       	call   105700 <uartputc>
  10033a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100341:	e8 ba 53 00 00       	call   105700 <uartputc>
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
  10036c:	e8 6f 3e 00 00       	call   1041e0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100371:	b8 80 07 00 00       	mov    $0x780,%eax
  100376:	29 d8                	sub    %ebx,%eax
  100378:	01 c0                	add    %eax,%eax
  10037a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10037e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100385:	00 
  100386:	89 34 24             	mov    %esi,(%esp)
  100389:	e8 d2 3d 00 00       	call   104160 <memset>
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
  1003ea:	c7 04 24 40 92 10 00 	movl   $0x109240,(%esp)
  1003f1:	e8 ca 3c 00 00       	call   1040c0 <acquire>
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
  100410:	c7 04 24 40 92 10 00 	movl   $0x109240,(%esp)
  100417:	e8 54 3c 00 00       	call   104070 <release>
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
  100464:	0f b6 92 0e 6b 10 00 	movzbl 0x106b0e(%edx),%edx
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
  1004c9:	8b 3d 74 92 10 00    	mov    0x109274,%edi
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
  10057c:	c7 04 24 40 92 10 00 	movl   $0x109240,(%esp)
  100583:	e8 e8 3a 00 00       	call   104070 <release>
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
  100600:	c7 04 24 40 92 10 00 	movl   $0x109240,(%esp)
  100607:	e8 b4 3a 00 00       	call   1040c0 <acquire>
  10060c:	e9 c6 fe ff ff       	jmp    1004d7 <cprintf+0x17>
  100611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  100618:	ba f4 6a 10 00       	mov    $0x106af4,%edx
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
  10063a:	c7 04 24 20 aa 10 00 	movl   $0x10aa20,(%esp)
  100641:	e8 7a 3a 00 00       	call   1040c0 <acquire>
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
  100661:	c7 44 24 04 20 aa 10 	movl   $0x10aa20,0x4(%esp)
  100668:	00 
  100669:	c7 04 24 d4 aa 10 00 	movl   $0x10aad4,(%esp)
  100670:	e8 8b 2d 00 00       	call   103400 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100675:	a1 d4 aa 10 00       	mov    0x10aad4,%eax
  10067a:	3b 05 d8 aa 10 00    	cmp    0x10aad8,%eax
  100680:	74 ce                	je     100650 <consoleread+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  100682:	89 c2                	mov    %eax,%edx
  100684:	83 e2 7f             	and    $0x7f,%edx
  100687:	0f b6 92 54 aa 10 00 	movzbl 0x10aa54(%edx),%edx
  10068e:	8d 78 01             	lea    0x1(%eax),%edi
  100691:	89 3d d4 aa 10 00    	mov    %edi,0x10aad4
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
  1006b2:	8b 0d c4 8b 10 00    	mov    0x108bc4,%ecx
  1006b8:	83 f9 0f             	cmp    $0xf,%ecx
  1006bb:	7e 0c                	jle    1006c9 <consoleread+0xa9>
     indexToDim1 = 0;
  1006bd:	c7 05 c4 8b 10 00 00 	movl   $0x0,0x108bc4
  1006c4:	00 00 00 
  1006c7:	31 c9                	xor    %ecx,%ecx
   }
   prevCmds[indexToDim1][indexToDim2] = c;
  1006c9:	8b 3d c8 8b 10 00    	mov    0x108bc8,%edi
  1006cf:	6b c9 64             	imul   $0x64,%ecx,%ecx
  1006d2:	0f b6 55 c7          	movzbl -0x39(%ebp),%edx
  1006d6:	88 94 0f e0 8b 10 00 	mov    %dl,0x108be0(%edi,%ecx,1)
   indexToDim2++;
  1006dd:	83 c7 01             	add    $0x1,%edi
  1006e0:	89 3d c8 8b 10 00    	mov    %edi,0x108bc8
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
  100718:	c7 04 24 20 aa 10 00 	movl   $0x10aa20,(%esp)
  10071f:	e8 4c 39 00 00       	call   104070 <release>
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
  100740:	8b 15 c4 8b 10 00    	mov    0x108bc4,%edx
   prevCmds[indexToDim1][indexToDim2] = c;
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
  100746:	6b 3d c4 8b 10 00 64 	imul   $0x64,0x108bc4,%edi
  10074d:	03 3d c8 8b 10 00    	add    0x108bc8,%edi
   indexToDim2=0;
   currInd1 = indexToDim1;
   indexToDim1++;
   hasInserted++;
  100753:	83 05 cc 8b 10 00 01 	addl   $0x1,0x108bcc
   prevCmds[indexToDim1][indexToDim2] = c;
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
  10075a:	c6 87 e0 8b 10 00 00 	movb   $0x0,0x108be0(%edi)
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
  100766:	c7 05 c8 8b 10 00 00 	movl   $0x0,0x108bc8
  10076d:	00 00 00 
   currInd1 = indexToDim1;
  100770:	89 15 20 92 10 00    	mov    %edx,0x109220
   indexToDim1++;
  100776:	89 3d c4 8b 10 00    	mov    %edi,0x108bc4
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
  100786:	a3 d4 aa 10 00       	mov    %eax,0x10aad4
  10078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078e:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  100790:	c7 04 24 20 aa 10 00 	movl   $0x10aa20,(%esp)
  100797:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10079a:	e8 d1 38 00 00       	call   104070 <release>
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
  1007c5:	be 50 aa 10 00       	mov    $0x10aa50,%esi

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
  1007d6:	c7 04 24 20 aa 10 00 	movl   $0x10aa20,(%esp)
  1007dd:	e8 de 38 00 00       	call   1040c0 <acquire>
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
  10082a:	a1 dc aa 10 00       	mov    0x10aadc,%eax
  10082f:	89 c2                	mov    %eax,%edx
  100831:	2b 15 d4 aa 10 00    	sub    0x10aad4,%edx
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
  100853:	a3 dc aa 10 00       	mov    %eax,0x10aadc
        consputc(c);
  100858:	89 f8                	mov    %edi,%eax
  10085a:	e8 01 fa ff ff       	call   100260 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10085f:	83 ff 04             	cmp    $0x4,%edi
  100862:	0f 84 1c 02 00 00    	je     100a84 <consoleintr+0x2c4>
  100868:	83 ff 0a             	cmp    $0xa,%edi
  10086b:	0f 84 13 02 00 00    	je     100a84 <consoleintr+0x2c4>
  100871:	8b 15 d4 aa 10 00    	mov    0x10aad4,%edx
  100877:	a1 dc aa 10 00       	mov    0x10aadc,%eax
  10087c:	83 ea 80             	sub    $0xffffff80,%edx
  10087f:	39 d0                	cmp    %edx,%eax
  100881:	0f 85 61 ff ff ff    	jne    1007e8 <consoleintr+0x28>
          input.w = input.e;
  100887:	a3 d8 aa 10 00       	mov    %eax,0x10aad8
          wakeup(&input.r);
  10088c:	c7 04 24 d4 aa 10 00 	movl   $0x10aad4,(%esp)
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
  1008a5:	c7 45 08 20 aa 10 00 	movl   $0x10aa20,0x8(%ebp)
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
  1008b3:	e9 b8 37 00 00       	jmp    104070 <release>
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
  1008d6:	a1 dc aa 10 00       	mov    0x10aadc,%eax
  1008db:	3b 05 d8 aa 10 00    	cmp    0x10aad8,%eax
  1008e1:	0f 84 01 ff ff ff    	je     1007e8 <consoleintr+0x28>
  1008e7:	90                   	nop
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1008e8:	83 e8 01             	sub    $0x1,%eax
  1008eb:	89 c2                	mov    %eax,%edx
  1008ed:	83 e2 7f             	and    $0x7f,%edx
  1008f0:	80 ba 54 aa 10 00 0a 	cmpb   $0xa,0x10aa54(%edx)
  1008f7:	0f 84 eb fe ff ff    	je     1007e8 <consoleintr+0x28>
        input.e--;
  1008fd:	a3 dc aa 10 00       	mov    %eax,0x10aadc
        consputc(BACKSPACE);
  100902:	b8 00 01 00 00       	mov    $0x100,%eax
  100907:	e8 54 f9 ff ff       	call   100260 <consputc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10090c:	a1 dc aa 10 00       	mov    0x10aadc,%eax
  100911:	3b 05 d8 aa 10 00    	cmp    0x10aad8,%eax
  100917:	75 cf                	jne    1008e8 <consoleintr+0x128>
  100919:	e9 ca fe ff ff       	jmp    1007e8 <consoleintr+0x28>
  10091e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100920:	e8 1b 35 00 00       	call   103e40 <procdump>
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
  100930:	8b 0d cc 8b 10 00    	mov    0x108bcc,%ecx
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
  100950:	80 ba 54 aa 10 00 0a 	cmpb   $0xa,0x10aa54(%edx)
  100957:	74 1c                	je     100975 <consoleintr+0x1b5>
        input.e--;
  100959:	a3 dc aa 10 00       	mov    %eax,0x10aadc
        consputc(BACKSPACE);
  10095e:	b8 00 01 00 00       	mov    $0x100,%eax
  100963:	e8 f8 f8 ff ff       	call   100260 <consputc>
        consputc(BACKSPACE);
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
	while(input.e != input.w &&
  100968:	a1 dc aa 10 00       	mov    0x10aadc,%eax
  10096d:	3b 05 d8 aa 10 00    	cmp    0x10aad8,%eax
  100973:	75 d3                	jne    100948 <consoleintr+0x188>
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
	}
	//cprintf("aaaa %d aaaa",currInd1);
	while(prevCmds[currInd1][ind] != 0) {
  100975:	8b 0d 20 92 10 00    	mov    0x109220,%ecx
  10097b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  10097e:	6b c9 64             	imul   $0x64,%ecx,%ecx
  100981:	01 d9                	add    %ebx,%ecx
  100983:	0f b6 81 e0 8b 10 00 	movzbl 0x108be0(%ecx),%eax
  10098a:	84 c0                	test   %al,%al
  10098c:	74 31                	je     1009bf <consoleintr+0x1ff>
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
	while(input.e != input.w &&
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  10098e:	8b 15 dc aa 10 00    	mov    0x10aadc,%edx
  100994:	81 c1 e1 8b 10 00    	add    $0x108be1,%ecx
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
  1009b9:	89 15 dc aa 10 00    	mov    %edx,0x10aadc
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
  1009c6:	83 3d cc 8b 10 00 0f 	cmpl   $0xf,0x108bcc
  1009cd:	7f 51                	jg     100a20 <consoleintr+0x260>
      	cprintf("%s",prevCmds[0]);
  1009cf:	c7 44 24 04 e0 8b 10 	movl   $0x108be0,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 5f 70 10 00 	movl   $0x10705f,(%esp)
  1009de:	e8 dd fa ff ff       	call   1004c0 <cprintf>
	currInd1 = indexToDim1-1;
  1009e3:	a1 c4 8b 10 00       	mov    0x108bc4,%eax
  1009e8:	83 e8 01             	sub    $0x1,%eax
  1009eb:	a3 20 92 10 00       	mov    %eax,0x109220
  1009f0:	e9 f3 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
  1009f5:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  1009f8:	a1 dc aa 10 00       	mov    0x10aadc,%eax
  1009fd:	3b 05 d8 aa 10 00    	cmp    0x10aad8,%eax
  100a03:	0f 84 df fd ff ff    	je     1007e8 <consoleintr+0x28>
        input.e--;
  100a09:	83 e8 01             	sub    $0x1,%eax
  100a0c:	a3 dc aa 10 00       	mov    %eax,0x10aadc
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
  100a20:	c7 44 24 04 e0 8b 10 	movl   $0x108be0,0x4(%esp)
  100a27:	00 
  100a28:	c7 04 24 5f 70 10 00 	movl   $0x10705f,(%esp)
  100a2f:	e8 8c fa ff ff       	call   1004c0 <cprintf>
	currInd1 = 15;
  100a34:	c7 05 20 92 10 00 0f 	movl   $0xf,0x109220
  100a3b:	00 00 00 
  100a3e:	e9 a5 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
	while(prevCmds[currInd1][ind] != 0) {
        input.buf[input.e++ % INPUT_BUF] = prevCmds[currInd1][ind];
	ind++;
	}
	if(currInd1 != 0) {
      	cprintf("%s",prevCmds[currInd1]);
  100a43:	6b 45 e0 64          	imul   $0x64,-0x20(%ebp),%eax
  100a47:	c7 04 24 5f 70 10 00 	movl   $0x10705f,(%esp)
  100a4e:	05 e0 8b 10 00       	add    $0x108be0,%eax
  100a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a57:	e8 64 fa ff ff       	call   1004c0 <cprintf>
	currInd1--;
  100a5c:	83 2d 20 92 10 00 01 	subl   $0x1,0x109220
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
  100a75:	a3 dc aa 10 00       	mov    %eax,0x10aadc
        consputc(c);
  100a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  100a7f:	e8 dc f7 ff ff       	call   100260 <consputc>
  100a84:	a1 dc aa 10 00       	mov    0x10aadc,%eax
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
  100aa4:	c7 05 74 92 10 00 00 	movl   $0x0,0x109274
  100aab:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
  100aae:	0f b6 00             	movzbl (%eax),%eax
  100ab1:	c7 04 24 fb 6a 10 00 	movl   $0x106afb,(%esp)
  100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abc:	e8 ff f9 ff ff       	call   1004c0 <cprintf>
  cprintf(s);
  100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac4:	89 04 24             	mov    %eax,(%esp)
  100ac7:	e8 f4 f9 ff ff       	call   1004c0 <cprintf>
  cprintf("\n");
  100acc:	c7 04 24 36 6f 10 00 	movl   $0x106f36,(%esp)
  100ad3:	e8 e8 f9 ff ff       	call   1004c0 <cprintf>
  getcallerpcs(&s, pcs);
  100ad8:	8d 45 08             	lea    0x8(%ebp),%eax
  100adb:	89 74 24 04          	mov    %esi,0x4(%esp)
  100adf:	89 04 24             	mov    %eax,(%esp)
  100ae2:	e8 69 34 00 00       	call   103f50 <getcallerpcs>
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
  100aee:	c7 04 24 0a 6b 10 00 	movl   $0x106b0a,(%esp)
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
  100b03:	c7 05 c0 8b 10 00 01 	movl   $0x1,0x108bc0
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
  100b78:	e8 03 59 00 00       	call   106480 <setupkvm>
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
  100bfc:	e8 3f 5b 00 00       	call   106740 <allocuvm>
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
  100c27:	e8 e4 5b 00 00       	call   106810 <loaduvm>
  100c2c:	85 c0                	test   %eax,%eax
  100c2e:	0f 85 74 ff ff ff    	jne    100ba8 <exec+0x98>
  100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  freevm(oldpgdir);

  return 0;

 bad:
  if(pgdir) freevm(pgdir);
  100c38:	8b 45 80             	mov    -0x80(%ebp),%eax
  100c3b:	89 04 24             	mov    %eax,(%esp)
  100c3e:	e8 bd 59 00 00       	call   106600 <freevm>
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
  100c93:	e8 a8 5a 00 00       	call   106740 <allocuvm>
  100c98:	85 c0                	test   %eax,%eax
  100c9a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  100ca0:	74 96                	je     100c38 <exec+0x128>
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);
  100ca2:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  100ca5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca9:	8b 45 80             	mov    -0x80(%ebp),%eax
  100cac:	89 04 24             	mov    %eax,(%esp)
  100caf:	e8 0c 57 00 00       	call   1063c0 <uva2ka>

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
  100cd6:	e8 65 36 00 00       	call   104340 <strlen>
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
  100d4e:	e8 ed 35 00 00       	call   104340 <strlen>
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
  100d73:	e8 68 34 00 00       	call   1041e0 <memmove>
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
  100e13:	e8 e8 34 00 00       	call   104300 <safestrcpy>

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
  100e59:	e8 72 5a 00 00       	call   1068d0 <switchuvm>

  freevm(oldpgdir);
  100e5e:	89 34 24             	mov    %esi,(%esp)
  100e61:	e8 9a 57 00 00       	call   106600 <freevm>

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
  100f57:	c7 04 24 1f 6b 10 00 	movl   $0x106b1f,(%esp)
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
  101007:	c7 04 24 29 6b 10 00 	movl   $0x106b29,(%esp)
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
  10107a:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  101081:	e8 3a 30 00 00       	call   1040c0 <acquire>
  if(f->ref < 1)
  101086:	8b 43 04             	mov    0x4(%ebx),%eax
  101089:	85 c0                	test   %eax,%eax
  10108b:	7e 1a                	jle    1010a7 <filedup+0x37>
    panic("filedup");
  f->ref++;
  10108d:	83 c0 01             	add    $0x1,%eax
  101090:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
  101093:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  10109a:	e8 d1 2f 00 00       	call   104070 <release>
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
  1010a7:	c7 04 24 32 6b 10 00 	movl   $0x106b32,(%esp)
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
  1010c4:	bb 2c ab 10 00       	mov    $0x10ab2c,%ebx
{
  1010c9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
  1010cc:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  1010d3:	e8 e8 2f 00 00       	call   1040c0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
  1010d8:	8b 15 18 ab 10 00    	mov    0x10ab18,%edx
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
  1010eb:	81 fb 74 b4 10 00    	cmp    $0x10b474,%ebx
  1010f1:	74 25                	je     101118 <filealloc+0x58>
    if(f->ref == 0){
  1010f3:	8b 43 04             	mov    0x4(%ebx),%eax
  1010f6:	85 c0                	test   %eax,%eax
  1010f8:	75 ee                	jne    1010e8 <filealloc+0x28>
      f->ref = 1;
  1010fa:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
  101101:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  101108:	e8 63 2f 00 00       	call   104070 <release>
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
  10111a:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  101121:	e8 4a 2f 00 00       	call   104070 <release>
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
  10112e:	bb 14 ab 10 00       	mov    $0x10ab14,%ebx
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
  101152:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  101159:	e8 62 2f 00 00       	call   1040c0 <acquire>
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
  101173:	c7 45 08 e0 aa 10 00 	movl   $0x10aae0,0x8(%ebp)
  
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
  101186:	e9 e5 2e 00 00       	jmp    104070 <release>
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
  1011af:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  1011b6:	e8 b5 2e 00 00       	call   104070 <release>
  
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
  101205:	c7 04 24 3a 6b 10 00 	movl   $0x106b3a,(%esp)
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
  101226:	c7 44 24 04 44 6b 10 	movl   $0x106b44,0x4(%esp)
  10122d:	00 
  10122e:	c7 04 24 e0 aa 10 00 	movl   $0x10aae0,(%esp)
  101235:	e8 f6 2c 00 00       	call   103f30 <initlock>
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
  10127a:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101281:	e8 3a 2e 00 00       	call   1040c0 <acquire>
  ip->ref++;
  101286:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10128a:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101291:	e8 da 2d 00 00       	call   104070 <release>
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
  1012af:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  1012b6:	e8 05 2e 00 00       	call   1040c0 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  1012bb:	b8 14 b5 10 00       	mov    $0x10b514,%eax
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
  1012cf:	3d b4 c4 10 00       	cmp    $0x10c4b4,%eax
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
  1012ec:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  1012f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1012f6:	e8 75 2d 00 00       	call   104070 <release>
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
  101311:	3d b4 c4 10 00       	cmp    $0x10c4b4,%eax
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
  10132f:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101336:	e8 35 2d 00 00       	call   104070 <release>

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
  101345:	c7 04 24 4b 6b 10 00 	movl   $0x106b4b,(%esp)
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
  101392:	e8 49 2e 00 00       	call   1041e0 <memmove>
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
  10146b:	c7 04 24 5b 6b 10 00 	movl   $0x106b5b,(%esp)
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
  10151c:	c7 04 24 71 6b 10 00 	movl   $0x106b71,(%esp)
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
  10157b:	8b 04 c5 80 b4 10 00 	mov    0x10b480(,%eax,8),%eax
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
  101605:	e8 d6 2b 00 00       	call   1041e0 <memmove>
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
  10169b:	e8 40 2b 00 00       	call   1041e0 <memmove>
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
  10170b:	8b 04 c5 84 b4 10 00 	mov    0x10b484(,%eax,8),%eax
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
  1017a5:	e8 36 2a 00 00       	call   1041e0 <memmove>
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
  10181b:	e8 30 2a 00 00       	call   104250 <strncmp>
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
  101923:	c7 04 24 84 6b 10 00 	movl   $0x106b84,(%esp)
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
  10194b:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101952:	e8 69 27 00 00       	call   1040c0 <acquire>
  ip->flags &= ~I_BUSY;
  101957:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10195b:	89 1c 24             	mov    %ebx,(%esp)
  10195e:	e8 3d 19 00 00       	call   1032a0 <wakeup>
  release(&icache.lock);
  101963:	c7 45 08 e0 b4 10 00 	movl   $0x10b4e0,0x8(%ebp)
}
  10196a:	83 c4 14             	add    $0x14,%esp
  10196d:	5b                   	pop    %ebx
  10196e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  10196f:	e9 fc 26 00 00       	jmp    104070 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101974:	c7 04 24 96 6b 10 00 	movl   $0x106b96,(%esp)
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
  1019b1:	e8 aa 27 00 00       	call   104160 <memset>
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
  101a32:	c7 04 24 9e 6b 10 00 	movl   $0x106b9e,(%esp)
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
  101a4c:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101a53:	e8 68 26 00 00       	call   1040c0 <acquire>
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
  101a91:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101a98:	e8 d3 25 00 00       	call   104070 <release>
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
  101ae7:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101aee:	e8 cd 25 00 00       	call   1040c0 <acquire>
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
  101b0b:	c7 45 08 e0 b4 10 00 	movl   $0x10b4e0,0x8(%ebp)
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
  101b19:	e9 52 25 00 00       	jmp    104070 <release>
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
  101b7e:	c7 04 24 b1 6b 10 00 	movl   $0x106bb1,(%esp)
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
  101c11:	e8 9a 26 00 00       	call   1042b0 <strncpy>
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
  101c5a:	c7 04 24 bb 6b 10 00 	movl   $0x106bbb,(%esp)
  101c61:	e8 2a ee ff ff       	call   100a90 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101c66:	c7 04 24 c6 71 10 00 	movl   $0x1071c6,(%esp)
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
  101d2b:	e8 30 24 00 00       	call   104160 <memset>
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
  101d5c:	c7 04 24 c8 6b 10 00 	movl   $0x106bc8,(%esp)
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
  101d8e:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101d95:	e8 26 23 00 00       	call   1040c0 <acquire>
  while(ip->flags & I_BUSY)
  101d9a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101d9d:	a8 01                	test   $0x1,%al
  101d9f:	74 1e                	je     101dbf <ilock+0x4f>
  101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101da8:	c7 44 24 04 e0 b4 10 	movl   $0x10b4e0,0x4(%esp)
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
  101dc5:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  101dcc:	e8 9f 22 00 00       	call   104070 <release>

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
  101e40:	e8 9b 23 00 00       	call   1041e0 <memmove>
    brelse(bp);
  101e45:	89 34 24             	mov    %esi,(%esp)
  101e48:	e8 b3 e1 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101e4d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  101e51:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  101e56:	0f 85 7b ff ff ff    	jne    101dd7 <ilock+0x67>
      panic("ilock: no type");
  101e5c:	c7 04 24 e0 6b 10 00 	movl   $0x106be0,(%esp)
  101e63:	e8 28 ec ff ff       	call   100a90 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101e68:	c7 04 24 da 6b 10 00 	movl   $0x106bda,(%esp)
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
  101f11:	e8 ca 22 00 00       	call   1041e0 <memmove>
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
  101f89:	e8 52 22 00 00       	call   1041e0 <memmove>
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
  102036:	c7 44 24 04 ef 6b 10 	movl   $0x106bef,0x4(%esp)
  10203d:	00 
  10203e:	c7 04 24 e0 b4 10 00 	movl   $0x10b4e0,(%esp)
  102045:	e8 e6 1e 00 00       	call   103f30 <initlock>
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
  1020ee:	c7 04 24 f6 6b 10 00 	movl   $0x106bf6,(%esp)
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
  102127:	a1 b8 92 10 00       	mov    0x1092b8,%eax
  10212c:	85 c0                	test   %eax,%eax
  10212e:	0f 84 7c 00 00 00    	je     1021b0 <iderw+0xb0>
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);
  102134:	c7 04 24 80 92 10 00 	movl   $0x109280,(%esp)
  10213b:	e8 80 1f 00 00       	call   1040c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  102140:	ba b4 92 10 00       	mov    $0x1092b4,%edx
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);

  // Append b to idequeue.
  b->qnext = 0;
  102145:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  10214c:	a1 b4 92 10 00       	mov    0x1092b4,%eax
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
  102164:	39 1d b4 92 10 00    	cmp    %ebx,0x1092b4
  10216a:	75 14                	jne    102180 <iderw+0x80>
  10216c:	eb 2d                	jmp    10219b <iderw+0x9b>
  10216e:	66 90                	xchg   %ax,%ax
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
    sleep(b, &idelock);
  102170:	c7 44 24 04 80 92 10 	movl   $0x109280,0x4(%esp)
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
  10218a:	c7 45 08 80 92 10 00 	movl   $0x109280,0x8(%ebp)
}
  102191:	83 c4 14             	add    $0x14,%esp
  102194:	5b                   	pop    %ebx
  102195:	5d                   	pop    %ebp
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
    sleep(b, &idelock);
  }

  release(&idelock);
  102196:	e9 d5 1e 00 00       	jmp    104070 <release>
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
  1021a4:	c7 04 24 ff 6b 10 00 	movl   $0x106bff,(%esp)
  1021ab:	e8 e0 e8 ff ff       	call   100a90 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("idrw: ide disk 1 not present");
  1021b0:	c7 04 24 28 6c 10 00 	movl   $0x106c28,(%esp)
  1021b7:	e8 d4 e8 ff ff       	call   100a90 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  1021bc:	c7 04 24 13 6c 10 00 	movl   $0x106c13,(%esp)
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
  1021d8:	c7 04 24 80 92 10 00 	movl   $0x109280,(%esp)
  1021df:	e8 dc 1e 00 00       	call   1040c0 <acquire>
  if((b = idequeue) == 0){
  1021e4:	8b 1d b4 92 10 00    	mov    0x1092b4,%ebx
  1021ea:	85 db                	test   %ebx,%ebx
  1021ec:	74 7a                	je     102268 <ideintr+0x98>
    release(&idelock);
    cprintf("Spurious IDE interrupt.\n");
    return;
  }
  idequeue = b->qnext;
  1021ee:	8b 43 14             	mov    0x14(%ebx),%eax
  1021f1:	a3 b4 92 10 00       	mov    %eax,0x1092b4

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
  10220d:	a1 b4 92 10 00       	mov    0x1092b4,%eax
  102212:	85 c0                	test   %eax,%eax
  102214:	74 05                	je     10221b <ideintr+0x4b>
    idestart(idequeue);
  102216:	e8 35 fe ff ff       	call   102050 <idestart>

  release(&idelock);
  10221b:	c7 04 24 80 92 10 00 	movl   $0x109280,(%esp)
  102222:	e8 49 1e 00 00       	call   104070 <release>
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
  102268:	c7 04 24 80 92 10 00 	movl   $0x109280,(%esp)
  10226f:	e8 fc 1d 00 00       	call   104070 <release>
    cprintf("Spurious IDE interrupt.\n");
  102274:	c7 04 24 45 6c 10 00 	movl   $0x106c45,(%esp)
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
  102296:	c7 44 24 04 5e 6c 10 	movl   $0x106c5e,0x4(%esp)
  10229d:	00 
  10229e:	c7 04 24 80 92 10 00 	movl   $0x109280,(%esp)
  1022a5:	e8 86 1c 00 00       	call   103f30 <initlock>
  picenable(IRQ_IDE);
  1022aa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022b1:	e8 aa 0a 00 00       	call   102d60 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
  1022b6:	a1 00 cb 10 00       	mov    0x10cb00,%eax
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
  102308:	c7 05 b8 92 10 00 01 	movl   $0x1,0x1092b8
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
  102320:	8b 15 04 c5 10 00    	mov    0x10c504,%edx
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
  102330:	8b 15 b4 c4 10 00    	mov    0x10c4b4,%edx
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
  10233f:	8b 15 b4 c4 10 00    	mov    0x10c4b4,%edx
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
  10234b:	8b 0d b4 c4 10 00    	mov    0x10c4b4,%ecx

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
  102356:	a1 b4 c4 10 00       	mov    0x10c4b4,%eax

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
  102378:	8b 0d 04 c5 10 00    	mov    0x10c504,%ecx
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
  1023aa:	0f b6 15 00 c5 10 00 	movzbl 0x10c500,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1023b1:	c7 05 b4 c4 10 00 00 	movl   $0xfec00000,0x10c4b4
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
  1023cb:	c7 04 24 64 6c 10 00 	movl   $0x106c64,(%esp)
  1023d2:	e8 e9 e0 ff ff       	call   1004c0 <cprintf>
  1023d7:	8b 1d b4 c4 10 00    	mov    0x10c4b4,%ebx
  1023dd:	ba 10 00 00 00       	mov    $0x10,%edx
  1023e2:	31 c0                	xor    %eax,%eax
  1023e4:	eb 08                	jmp    1023ee <ioapicinit+0x7e>
  1023e6:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023e8:	8b 1d b4 c4 10 00    	mov    0x10c4b4,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1023ee:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
  1023f0:	8b 1d b4 c4 10 00    	mov    0x10c4b4,%ebx
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
  102405:	8b 0d b4 c4 10 00    	mov    0x10c4b4,%ecx
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
  102415:	8b 0d b4 c4 10 00    	mov    0x10c4b4,%ecx
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
  102437:	c7 04 24 c0 c4 10 00 	movl   $0x10c4c0,(%esp)
  10243e:	e8 7d 1c 00 00       	call   1040c0 <acquire>
  r = kmem.freelist;
  102443:	8b 1d f4 c4 10 00    	mov    0x10c4f4,%ebx
  if(r)
  102449:	85 db                	test   %ebx,%ebx
  10244b:	74 07                	je     102454 <kalloc+0x24>
    kmem.freelist = r->next;
  10244d:	8b 03                	mov    (%ebx),%eax
  10244f:	a3 f4 c4 10 00       	mov    %eax,0x10c4f4
  release(&kmem.lock);
  102454:	c7 04 24 c0 c4 10 00 	movl   $0x10c4c0,(%esp)
  10245b:	e8 10 1c 00 00       	call   104070 <release>
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
  1024a5:	e8 b6 1c 00 00       	call   104160 <memset>

  acquire(&kmem.lock);
  1024aa:	c7 04 24 c0 c4 10 00 	movl   $0x10c4c0,(%esp)
  1024b1:	e8 0a 1c 00 00       	call   1040c0 <acquire>
  r = (struct run *) v;
  r->next = kmem.freelist;
  1024b6:	a1 f4 c4 10 00       	mov    0x10c4f4,%eax
  1024bb:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  1024bd:	89 1d f4 c4 10 00    	mov    %ebx,0x10c4f4
  release(&kmem.lock);
  1024c3:	c7 45 08 c0 c4 10 00 	movl   $0x10c4c0,0x8(%ebp)
}
  1024ca:	83 c4 14             	add    $0x14,%esp
  1024cd:	5b                   	pop    %ebx
  1024ce:	5d                   	pop    %ebp

  acquire(&kmem.lock);
  r = (struct run *) v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
  1024cf:	e9 9c 1b 00 00       	jmp    104070 <release>
kfree(char *v)
{
  struct run *r;

  if(((uint) v) % PGSIZE || (uint)v < 1024*1024 || (uint)v >= PHYSTOP) 
    panic("kfree");
  1024d4:	c7 04 24 96 6c 10 00 	movl   $0x106c96,(%esp)
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
  1024e4:	bb a3 06 11 00       	mov    $0x1106a3,%ebx
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
  1024f2:	c7 44 24 04 9c 6c 10 	movl   $0x106c9c,0x4(%esp)
  1024f9:	00 
  1024fa:	c7 04 24 c0 c4 10 00 	movl   $0x10c4c0,(%esp)
  102501:	e8 2a 1a 00 00       	call   103f30 <initlock>
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
  10256d:	8b 15 bc 92 10 00    	mov    0x1092bc,%edx
  102573:	f6 c2 40             	test   $0x40,%dl
  102576:	75 03                	jne    10257b <kbdgetc+0x3b>
  102578:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10257b:	0f b6 80 c0 6c 10 00 	movzbl 0x106cc0(%eax),%eax
  102582:	83 c8 40             	or     $0x40,%eax
  102585:	0f b6 c0             	movzbl %al,%eax
  102588:	f7 d0                	not    %eax
  10258a:	21 d0                	and    %edx,%eax
  10258c:	a3 bc 92 10 00       	mov    %eax,0x1092bc
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
  102598:	8b 0d bc 92 10 00    	mov    0x1092bc,%ecx
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
  1025a8:	0f b6 90 c0 6c 10 00 	movzbl 0x106cc0(%eax),%edx
  1025af:	09 ca                	or     %ecx,%edx
  1025b1:	0f b6 88 c0 6d 10 00 	movzbl 0x106dc0(%eax),%ecx
  1025b8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  1025ba:	89 d1                	mov    %edx,%ecx
  1025bc:	83 e1 03             	and    $0x3,%ecx
  1025bf:	8b 0c 8d c0 6e 10 00 	mov    0x106ec0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1025c6:	89 15 bc 92 10 00    	mov    %edx,0x1092bc
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
  1025ea:	83 0d bc 92 10 00 40 	orl    $0x40,0x1092bc
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
  102630:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  102646:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  102689:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  1026a6:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1026ab:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ae:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  1026b5:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026b8:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1026bd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026c0:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  1026c7:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026ca:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1026cf:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026d2:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026d8:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1026dd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026e0:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026e6:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1026eb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ee:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026f4:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1026f9:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026fc:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102702:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  10271d:	a1 c0 92 10 00       	mov    0x1092c0,%eax
  102722:	8d 50 01             	lea    0x1(%eax),%edx
  102725:	85 c0                	test   %eax,%eax
  102727:	89 15 c0 92 10 00    	mov    %edx,0x1092c0
  10272d:	74 19                	je     102748 <cpunum+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if(lapic)
  10272f:	8b 15 f8 c4 10 00    	mov    0x10c4f8,%edx
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
  10274b:	c7 04 24 d0 6e 10 00 	movl   $0x106ed0,(%esp)
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
  102766:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  10276b:	c7 04 24 fc 6e 10 00 	movl   $0x106efc,(%esp)
  102772:	89 44 24 08          	mov    %eax,0x8(%esp)
  102776:	8b 45 08             	mov    0x8(%ebp),%eax
  102779:	89 44 24 04          	mov    %eax,0x4(%esp)
  10277d:	e8 3e dd ff ff       	call   1004c0 <cprintf>
  if(!lapic) 
  102782:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  102799:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  10279e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027a1:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1027a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027ab:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1027b0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027b3:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1027ba:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  1027bd:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1027c2:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027c5:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  1027cc:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  1027cf:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1027d4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027d7:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  1027de:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1027e1:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  1027e6:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027e9:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  1027f0:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1027f3:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  102814:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  102819:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10281c:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102823:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102826:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  10282b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10282e:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102835:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102838:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  10283d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102840:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102847:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10284a:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  10284f:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102852:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  102859:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10285c:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
  102861:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102864:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  10286b:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  10286e:	8b 0d f8 c4 10 00    	mov    0x10c4f8,%ecx
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
  102891:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  1028aa:	a1 f8 c4 10 00       	mov    0x10c4f8,%eax
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
  1028d7:	e8 a4 40 00 00       	call   106980 <ksegment>
  1028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapicinit(cpunum());
  1028e0:	e8 2b fe ff ff       	call   102710 <cpunum>
  1028e5:	89 04 24             	mov    %eax,(%esp)
  1028e8:	e8 73 fe ff ff       	call   102760 <lapicinit>
  }
  vmenable();        // turn on paging
  1028ed:	e8 8e 39 00 00       	call   106280 <vmenable>
  cprintf("cpu%d: starting\n", cpu->id);
  1028f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1028f8:	0f b6 00             	movzbl (%eax),%eax
  1028fb:	c7 04 24 10 6f 10 00 	movl   $0x106f10,(%esp)
  102902:	89 44 24 04          	mov    %eax,0x4(%esp)
  102906:	e8 b5 db ff ff       	call   1004c0 <cprintf>
  idtinit();       // load idt register
  10290b:	e8 10 2a 00 00       	call   105320 <idtinit>
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
  102940:	c7 04 24 21 6f 10 00 	movl   $0x106f21,(%esp)
  102947:	89 44 24 04          	mov    %eax,0x4(%esp)
  10294b:	e8 70 db ff ff       	call   1004c0 <cprintf>
  kvmalloc();      // initialize the kernel page table
  102950:	e8 eb 3b 00 00       	call   106540 <kvmalloc>
  pinit();         // process table
  102955:	e8 b6 15 00 00       	call   103f10 <pinit>
  tvinit();        // trap vectors
  10295a:	e8 c1 2c 00 00       	call   105620 <tvinit>
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
  102975:	a1 04 c5 10 00       	mov    0x10c504,%eax
  10297a:	85 c0                	test   %eax,%eax
  10297c:	0f 84 ab 00 00 00    	je     102a2d <mainc+0xfd>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  102982:	e8 c9 13 00 00       	call   103d50 <userinit>
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.  The linker has
  // placed the start of bootother.S there.
  code = (uchar *) 0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102987:	c7 44 24 08 6a 00 00 	movl   $0x6a,0x8(%esp)
  10298e:	00 
  10298f:	c7 44 24 04 54 8b 10 	movl   $0x108b54,0x4(%esp)
  102996:	00 
  102997:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  10299e:	e8 3d 18 00 00       	call   1041e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  1029a3:	69 05 00 cb 10 00 bc 	imul   $0xbc,0x10cb00,%eax
  1029aa:	00 00 00 
  1029ad:	05 20 c5 10 00       	add    $0x10c520,%eax
  1029b2:	3d 20 c5 10 00       	cmp    $0x10c520,%eax
  1029b7:	76 6a                	jbe    102a23 <mainc+0xf3>
  1029b9:	bb 20 c5 10 00       	mov    $0x10c520,%ebx
  1029be:	66 90                	xchg   %ax,%ax
    if(c == cpus+cpunum())  // We've started already.
  1029c0:	e8 4b fd ff ff       	call   102710 <cpunum>
  1029c5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1029cb:	05 20 c5 10 00       	add    $0x10c520,%eax
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
  102a0a:	69 05 00 cb 10 00 bc 	imul   $0xbc,0x10cb00,%eax
  102a11:	00 00 00 
  102a14:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
  102a1a:	05 20 c5 10 00       	add    $0x10c520,%eax
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
  102a2d:	e8 8e 28 00 00       	call   1052c0 <timerinit>
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
  102a5b:	c7 04 24 41 6f 10 00 	movl   $0x106f41,(%esp)
  102a62:	e8 29 e0 ff ff       	call   100a90 <panic>
  102a67:	90                   	nop
void
jkstack(void)
{
  char *kstack = kalloc();
  if(!kstack)
    panic("jkstack\n");
  102a68:	c7 04 24 38 6f 10 00 	movl   $0x106f38,(%esp)
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
  102a9b:	e8 e0 3e 00 00       	call   106980 <ksegment>
  picinit();       // interrupt controller
  102aa0:	e8 eb 02 00 00       	call   102d90 <picinit>
  ioapicinit();    // another interrupt controller
  102aa5:	e8 c6 f8 ff ff       	call   102370 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
  102aaa:	e8 41 d7 ff ff       	call   1001f0 <consoleinit>
  102aaf:	90                   	nop
  uartinit();      // serial port
  102ab0:	e8 9b 2c 00 00       	call   105750 <uartinit>
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
  102ac0:	a1 c4 92 10 00       	mov    0x1092c4,%eax
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
  102ac9:	2d 20 c5 10 00       	sub    $0x10c520,%eax
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
  102af7:	c7 04 24 49 6f 10 00 	movl   $0x106f49,(%esp)
  102afe:	e8 bd d9 ff ff       	call   1004c0 <cprintf>
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b03:	39 f3                	cmp    %esi,%ebx
  102b05:	73 3a                	jae    102b41 <mpsearch1+0x61>
  102b07:	90                   	nop
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102b08:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102b0f:	00 
  102b10:	c7 44 24 04 5c 6f 10 	movl   $0x106f5c,0x4(%esp)
  102b17:	00 
  102b18:	89 1c 24             	mov    %ebx,(%esp)
  102b1b:	e8 60 16 00 00       	call   104180 <memcmp>
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
  102b77:	c7 05 c4 92 10 00 20 	movl   $0x10c520,0x1092c4
  102b7e:	c5 10 00 
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
  102bcb:	c7 44 24 04 61 6f 10 	movl   $0x106f61,0x4(%esp)
  102bd2:	00 
  102bd3:	89 34 24             	mov    %esi,(%esp)
  102bd6:	e8 a5 15 00 00       	call   104180 <memcmp>
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
  102c11:	c7 05 04 c5 10 00 01 	movl   $0x1,0x10c504
  102c18:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102c1b:	8b 46 24             	mov    0x24(%esi),%eax
  102c1e:	a3 f8 c4 10 00       	mov    %eax,0x10c4f8
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c23:	0f b7 56 04          	movzwl 0x4(%esi),%edx
  102c27:	8d 46 2c             	lea    0x2c(%esi),%eax
  102c2a:	8d 14 16             	lea    (%esi,%edx,1),%edx
  102c2d:	39 d0                	cmp    %edx,%eax
  102c2f:	73 61                	jae    102c92 <mpinit+0x132>
  102c31:	8b 0d c4 92 10 00    	mov    0x1092c4,%ecx
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
  102c4e:	c7 04 24 88 6f 10 00 	movl   $0x106f88,(%esp)
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102c55:	a3 c4 92 10 00       	mov    %eax,0x1092c4
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102c5a:	e8 61 d8 ff ff       	call   1004c0 <cprintf>
      panic("mpinit");
  102c5f:	c7 04 24 81 6f 10 00 	movl   $0x106f81,(%esp)
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
  102c73:	ff 24 8d a8 6f 10 00 	jmp    *0x106fa8(,%ecx,4)
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
  102c8c:	89 0d c4 92 10 00    	mov    %ecx,0x1092c4
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
  102cbc:	8b 3d 00 cb 10 00    	mov    0x10cb00,%edi
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
  102cd5:	81 c7 20 c5 10 00    	add    $0x10c520,%edi
  102cdb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      cpus[ncpu].id = ncpu;
  102cde:	69 f9 bc 00 00 00    	imul   $0xbc,%ecx,%edi
      ncpu++;
  102ce4:	83 c1 01             	add    $0x1,%ecx
  102ce7:	89 0d 00 cb 10 00    	mov    %ecx,0x10cb00
      p += sizeof(struct mpproc);
  102ced:	83 c0 14             	add    $0x14,%eax
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
  102cf0:	88 9f 20 c5 10 00    	mov    %bl,0x10c520(%edi)
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
  102cff:	88 0d 00 c5 10 00    	mov    %cl,0x10c500
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
  102d3c:	c7 04 24 66 6f 10 00 	movl   $0x106f66,(%esp)
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102d43:	a3 c4 92 10 00       	mov    %eax,0x1092c4
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
  102d48:	e8 73 d7 ff ff       	call   1004c0 <cprintf>
        panic("mpinit");
  102d4d:	c7 04 24 81 6f 10 00 	movl   $0x106f81,(%esp)
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
  102d72:	66 23 05 20 87 10 00 	and    0x108720,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
  102d79:	66 a3 20 87 10 00    	mov    %ax,0x108720
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
  102e08:	0f b7 05 20 87 10 00 	movzwl 0x108720,%eax
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
  102e42:	e8 79 12 00 00       	call   1040c0 <acquire>
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
  102efb:	e8 70 11 00 00       	call   104070 <release>
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
  102f18:	e8 53 11 00 00       	call   104070 <release>
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
  102f45:	e8 76 11 00 00       	call   1040c0 <acquire>
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
  102fed:	e8 7e 10 00 00       	call   104070 <release>
  return n;
  102ff2:	eb 13                	jmp    103007 <pipewrite+0xd7>
  102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
  102ff8:	89 1c 24             	mov    %ebx,(%esp)
  102ffb:	e8 70 10 00 00       	call   104070 <release>
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
  103035:	e8 86 10 00 00       	call   1040c0 <acquire>
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
  103076:	e9 f5 0f 00 00       	jmp    104070 <release>
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
  1030a3:	e8 c8 0f 00 00       	call   104070 <release>
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
  10312f:	c7 44 24 04 bc 6f 10 	movl   $0x106fbc,0x4(%esp)
  103136:	00 
  103137:	e8 f4 0d 00 00       	call   103f30 <initlock>
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
  1031b6:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
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
  1031c0:	e8 fb 0e 00 00       	call   1040c0 <acquire>
  proc->priority = (1 - (proc->priority));
  1031c5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1031cc:	b8 01 00 00 00       	mov    $0x1,%eax
  1031d1:	2b 82 88 00 00 00    	sub    0x88(%edx),%eax
  1031d7:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  release(&ptable.lock);
  1031dd:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1031e4:	e8 87 0e 00 00       	call   104070 <release>
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
  10321a:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103221:	e8 9a 0e 00 00       	call   1040c0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
  103226:	8b 15 64 cb 10 00    	mov    0x10cb64,%edx

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  10322c:	b8 e0 cb 10 00       	mov    $0x10cbe0,%eax
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
  10323d:	3d 54 ee 10 00       	cmp    $0x10ee54,%eax
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
  103258:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  10325f:	e8 0c 0e 00 00       	call   104070 <release>
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
  103280:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103287:	e8 e4 0d 00 00       	call   104070 <release>
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
  103297:	b8 54 cb 10 00       	mov    $0x10cb54,%eax
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
  1032aa:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1032b1:	e8 0a 0e 00 00       	call   1040c0 <acquire>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1032b6:	b8 54 cb 10 00       	mov    $0x10cb54,%eax
  1032bb:	eb 0f                	jmp    1032cc <wakeup+0x2c>
  1032bd:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1032c0:	05 8c 00 00 00       	add    $0x8c,%eax
  1032c5:	3d 54 ee 10 00       	cmp    $0x10ee54,%eax
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
  1032e3:	3d 54 ee 10 00       	cmp    $0x10ee54,%eax
  1032e8:	75 e2                	jne    1032cc <wakeup+0x2c>
  1032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  1032f0:	c7 45 08 20 cb 10 00 	movl   $0x10cb20,0x8(%ebp)
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
  1032fc:	e9 6f 0d 00 00       	jmp    104070 <release>
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
  103316:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  10331d:	e8 4e 0d 00 00       	call   104070 <release>
  
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
  103337:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  10333e:	e8 7d 0d 00 00       	call   1040c0 <acquire>
 xticks = ticks;
  103343:	8b 1d a0 f6 10 00    	mov    0x10f6a0,%ebx
 release(&tickslock);
  103349:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  103350:	e8 1b 0d 00 00       	call   104070 <release>
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
  103367:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  10336e:	e8 3d 0c 00 00       	call   103fb0 <holding>
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
  1033ad:	e8 aa 0f 00 00       	call   10435c <swtch>
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
  1033c4:	c7 04 24 c1 6f 10 00 	movl   $0x106fc1,(%esp)
  1033cb:	e8 c0 d6 ff ff       	call   100a90 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  1033d0:	c7 04 24 ed 6f 10 00 	movl   $0x106fed,(%esp)
  1033d7:	e8 b4 d6 ff ff       	call   100a90 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  1033dc:	c7 04 24 df 6f 10 00 	movl   $0x106fdf,(%esp)
  1033e3:	e8 a8 d6 ff ff       	call   100a90 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  1033e8:	c7 04 24 d3 6f 10 00 	movl   $0x106fd3,(%esp)
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
  103424:	81 fb 20 cb 10 00    	cmp    $0x10cb20,%ebx
  10342a:	74 5c                	je     103488 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
  10342c:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103433:	e8 88 0c 00 00       	call   1040c0 <acquire>
    release(lk);
  103438:	89 1c 24             	mov    %ebx,(%esp)
  10343b:	e8 30 0c 00 00       	call   104070 <release>
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
  103468:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  10346f:	e8 fc 0b 00 00       	call   104070 <release>
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
  10347d:	e9 3e 0c 00 00       	jmp    1040c0 <acquire>
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
  1034b1:	c7 04 24 07 70 10 00 	movl   $0x107007,(%esp)
  1034b8:	e8 d3 d5 ff ff       	call   100a90 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
  1034bd:	c7 04 24 01 70 10 00 	movl   $0x107001,(%esp)
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
  1034d6:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1034dd:	e8 de 0b 00 00       	call   1040c0 <acquire>
  proc->state = RUNNABLE;
  1034e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1034e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1034ef:	e8 6c fe ff ff       	call   103360 <sched>
  release(&ptable.lock);
  1034f4:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1034fb:	e8 70 0b 00 00       	call   104070 <release>
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
  103514:	83 cf ff             	or     $0xffffffff,%edi
  103517:	56                   	push   %esi
  103518:	31 f6                	xor    %esi,%esi
  10351a:	53                   	push   %ebx
  10351b:	31 db                	xor    %ebx,%ebx
  10351d:	83 ec 3c             	sub    $0x3c,%esp
  103520:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  103527:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  10352e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  103535:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
  103538:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
  103539:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103540:	e8 7b 0b 00 00       	call   1040c0 <acquire>
	else {
	loop = 0;
	lastHighPri = p;
	}
#elif FAIR2Q
if(k==0) {
  103545:	85 db                	test   %ebx,%ebx
  103547:	75 0c                	jne    103555 <scheduler+0x45>
cprintf("FAIRRRRRRRRRRR2QQQQQQQQQQQQQQQ");
  103549:	c7 04 24 94 70 10 00 	movl   $0x107094,(%esp)
  103550:	e8 6b cf ff ff       	call   1004c0 <cprintf>
  103555:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx
  10355a:	eb 41                	jmp    10359d <scheduler+0x8d>
  10355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	}

	loop++;
        continue;
	}
      else if(loop == 64)
  103560:	83 fe 40             	cmp    $0x40,%esi
  103563:	75 23                	jne    103588 <scheduler+0x78>
  103565:	e9 ae 00 00 00       	jmp    103618 <scheduler+0x108>
  10356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103570:	dd d8                	fstp   %st(0)
  103572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103578:	eb 0e                	jmp    103588 <scheduler+0x78>
  10357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103580:	dd d8                	fstp   %st(0)
  103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	continue;
	}
	}
      else {
        //cprintf("If4\n");
	loop++;
  103588:	83 c6 01             	add    $0x1,%esi
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  10358b:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103591:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  103597:	0f 83 e3 00 00 00    	jae    103680 <scheduler+0x170>
	   I check if its ratio is smaller than the current smallest ratio of low priority
	   if it is then I save it as the new current smallest ratio, else I continue.
	3. if I passed all of the processes I choose the process with the smallest ratio of high priority,
	   if there isnt one that was runnable, I choose the process with the smallest ratio of low priority,
	   if there isnt one I go back to step 1. */	
      if((p->state == RUNNABLE) && (p->priority == 0) && (loop<64)) {
  10359d:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  1035a1:	75 bd                	jne    103560 <scheduler+0x50>
  1035a3:	83 fe 3f             	cmp    $0x3f,%esi
  1035a6:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
  1035ac:	7f b2                	jg     103560 <scheduler+0x50>
  1035ae:	85 c0                	test   %eax,%eax
  1035b0:	0f 84 f2 00 00 00    	je     1036a8 <scheduler+0x198>
        continue;
	}
      else if((p->state == RUNNABLE) && (p->priority != 0) && (loop<64))
	{
        //cprintf("If2\n");
	mechane = clockticks() - p->ctime;
  1035b6:	e8 75 fd ff ff       	call   103330 <clockticks>
  1035bb:	2b 43 7c             	sub    0x7c(%ebx),%eax
  1035be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1035c1:	db 45 e0             	fildl  -0x20(%ebp)
	if(mechane == 0)
  1035c4:	d9 ee                	fldz   
  1035c6:	d9 c9                	fxch   %st(1)
  1035c8:	dd e1                	fucom  %st(1)
  1035ca:	df e0                	fnstsw %ax
  1035cc:	dd d9                	fstp   %st(1)
  1035ce:	9e                   	sahf   
  1035cf:	75 0a                	jne    1035db <scheduler+0xcb>
  1035d1:	7a 08                	jp     1035db <scheduler+0xcb>
  1035d3:	dd d8                	fstp   %st(0)
  1035d5:	dd 05 d0 70 10 00    	fldl   0x1070d0
	mechane = 0.01;

	ratio = p->rtime / mechane;

	if((smallLowRatio == -1) || (ratio < smallLowRatio)) {
  1035db:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
        //cprintf("If2\n");
	mechane = clockticks() - p->ctime;
	if(mechane == 0)
	mechane = 0.01;

	ratio = p->rtime / mechane;
  1035df:	db 83 84 00 00 00    	fildl  0x84(%ebx)
  1035e5:	de f1                	fdivp  %st,%st(1)

	if((smallLowRatio == -1) || (ratio < smallLowRatio)) {
  1035e7:	74 0e                	je     1035f7 <scheduler+0xe7>
  1035e9:	db 45 dc             	fildl  -0x24(%ebp)
  1035ec:	dd e9                	fucomp %st(1)
  1035ee:	df e0                	fnstsw %ax
  1035f0:	9e                   	sahf   
  1035f1:	0f 86 79 ff ff ff    	jbe    103570 <scheduler+0x60>
	smallLowRatio = ratio;
  1035f7:	d9 7d e6             	fnstcw -0x1a(%ebp)
  1035fa:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  1035fd:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  103601:	b4 0c                	mov    $0xc,%ah
  103603:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  103607:	d9 6d e4             	fldcw  -0x1c(%ebp)
  10360a:	db 5d dc             	fistpl -0x24(%ebp)
  10360d:	d9 6d e6             	fldcw  -0x1a(%ebp)
  103610:	e9 73 ff ff ff       	jmp    103588 <scheduler+0x78>
  103615:	8d 76 00             	lea    0x0(%esi),%esi
        continue;
	}
      else if(loop == 64)
	{
        //cprintf("If3\n");
	if(smallHighRatio != -1) {
  103618:	83 ff ff             	cmp    $0xffffffff,%edi
  10361b:	74 7b                	je     103698 <scheduler+0x188>
  10361d:	8b 5d d8             	mov    -0x28(%ebp),%ebx


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
  103620:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  103627:	bf ff ff ff ff       	mov    $0xffffffff,%edi

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
  10362c:	89 1c 24             	mov    %ebx,(%esp)
  10362f:	e8 9c 32 00 00       	call   1068d0 <switchuvm>
      p->state = RUNNING;
  103634:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

      swtch(&cpu->scheduler, proc->context);
  10363b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103641:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&cpu->scheduler, proc->context);
  103647:	8b 40 1c             	mov    0x1c(%eax),%eax
  10364a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10364e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103654:	83 c0 04             	add    $0x4,%eax
  103657:	89 04 24             	mov    %eax,(%esp)
  10365a:	e8 fd 0c 00 00       	call   10435c <swtch>
      switchkvm();
  10365f:	e8 3c 2c 00 00       	call   1062a0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103664:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  10366a:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  103671:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103675:	0f 82 22 ff ff ff    	jb     10359d <scheduler+0x8d>
  10367b:	90                   	nop
  10367c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

#ifdef RR2
      p=lastHighPri;
#endif
    }
    release(&ptable.lock);
  103680:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103687:	bb 01 00 00 00       	mov    $0x1,%ebx
  10368c:	e8 df 09 00 00       	call   104070 <release>

  }
  103691:	e9 a2 fe ff ff       	jmp    103538 <scheduler+0x28>
  103696:	66 90                	xchg   %ax,%ax
	if(smallHighRatio != -1) {
        //cprintf("If5\n");
	p = min_high_pri;
	smallHighRatio = -1;
	}
	else if((smallHighRatio == -1) && (smallLowRatio != -1)) {
  103698:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
  10369c:	75 72                	jne    103710 <scheduler+0x200>
  10369e:	31 f6                	xor    %esi,%esi
  1036a0:	e9 e6 fe ff ff       	jmp    10358b <scheduler+0x7b>
  1036a5:	8d 76 00             	lea    0x0(%esi),%esi
	3. if I passed all of the processes I choose the process with the smallest ratio of high priority,
	   if there isnt one that was runnable, I choose the process with the smallest ratio of low priority,
	   if there isnt one I go back to step 1. */	
      if((p->state == RUNNABLE) && (p->priority == 0) && (loop<64)) {
        //cprintf("If1\n");
	mechane = clockticks() - p->ctime;
  1036a8:	e8 83 fc ff ff       	call   103330 <clockticks>
  1036ad:	2b 43 7c             	sub    0x7c(%ebx),%eax
  1036b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1036b3:	db 45 e0             	fildl  -0x20(%ebp)
	if(mechane == 0)
  1036b6:	d9 ee                	fldz   
  1036b8:	d9 c9                	fxch   %st(1)
  1036ba:	dd e1                	fucom  %st(1)
  1036bc:	df e0                	fnstsw %ax
  1036be:	dd d9                	fstp   %st(1)
  1036c0:	9e                   	sahf   
  1036c1:	75 0a                	jne    1036cd <scheduler+0x1bd>
  1036c3:	7a 08                	jp     1036cd <scheduler+0x1bd>
  1036c5:	dd d8                	fstp   %st(0)
  1036c7:	dd 05 d0 70 10 00    	fldl   0x1070d0
	mechane = 0.01;

	ratio = p->rtime / mechane;
  1036cd:	db 83 84 00 00 00    	fildl  0x84(%ebx)

	if((smallHighRatio == -1) || (ratio < smallHighRatio)) {
  1036d3:	83 ff ff             	cmp    $0xffffffff,%edi
        //cprintf("If1\n");
	mechane = clockticks() - p->ctime;
	if(mechane == 0)
	mechane = 0.01;

	ratio = p->rtime / mechane;
  1036d6:	de f1                	fdivp  %st,%st(1)

	if((smallHighRatio == -1) || (ratio < smallHighRatio)) {
  1036d8:	74 11                	je     1036eb <scheduler+0x1db>
  1036da:	89 7d e0             	mov    %edi,-0x20(%ebp)
  1036dd:	db 45 e0             	fildl  -0x20(%ebp)
  1036e0:	dd e9                	fucomp %st(1)
  1036e2:	df e0                	fnstsw %ax
  1036e4:	9e                   	sahf   
  1036e5:	0f 86 95 fe ff ff    	jbe    103580 <scheduler+0x70>
	smallHighRatio = ratio;
  1036eb:	d9 7d e6             	fnstcw -0x1a(%ebp)
  1036ee:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  1036f1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  1036f5:	b4 0c                	mov    $0xc,%ah
  1036f7:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  1036fb:	d9 6d e4             	fldcw  -0x1c(%ebp)
  1036fe:	db 5d e0             	fistpl -0x20(%ebp)
  103701:	d9 6d e6             	fldcw  -0x1a(%ebp)
  103704:	8b 7d e0             	mov    -0x20(%ebp),%edi
  103707:	e9 7c fe ff ff       	jmp    103588 <scheduler+0x78>
  10370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	}
	}
      else {
        //cprintf("If4\n");
	loop++;
	continue;
  103710:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  103713:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  10371a:	e9 01 ff ff ff       	jmp    103620 <scheduler+0x110>
  10371f:	90                   	nop

00103720 <wait2>:
  }
}

int
wait2(int* wtime, int* rtime)
{
  103720:	55                   	push   %ebp
  103721:	89 e5                	mov    %esp,%ebp
  103723:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  103724:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx
  }
}

int
wait2(int* wtime, int* rtime)
{
  103729:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  10372c:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103733:	e8 88 09 00 00       	call   1040c0 <acquire>
  103738:	31 c0                	xor    %eax,%eax
  10373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103740:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  103746:	72 30                	jb     103778 <wait2+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  103748:	85 c0                	test   %eax,%eax
  10374a:	74 5c                	je     1037a8 <wait2+0x88>
  10374c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103752:	8b 50 24             	mov    0x24(%eax),%edx
  103755:	85 d2                	test   %edx,%edx
  103757:	75 4f                	jne    1037a8 <wait2+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  103759:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx
  10375e:	89 04 24             	mov    %eax,(%esp)
  103761:	c7 44 24 04 20 cb 10 	movl   $0x10cb20,0x4(%esp)
  103768:	00 
  103769:	e8 92 fc ff ff       	call   103400 <sleep>
  10376e:	31 c0                	xor    %eax,%eax
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103770:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  103776:	73 d0                	jae    103748 <wait2+0x28>
      if(p->parent != proc)
  103778:	8b 53 14             	mov    0x14(%ebx),%edx
  10377b:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
  103782:	74 0c                	je     103790 <wait2+0x70>
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103784:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  10378a:	eb b4                	jmp    103740 <wait2+0x20>
  10378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  103790:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  103794:	74 29                	je     1037bf <wait2+0x9f>
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
  103796:	b8 01 00 00 00       	mov    $0x1,%eax
  10379b:	90                   	nop
  10379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1037a0:	eb e2                	jmp    103784 <wait2+0x64>
  1037a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  1037a8:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1037af:	e8 bc 08 00 00       	call   104070 <release>
  1037b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  1037b9:	83 c4 24             	add    $0x24,%esp
  1037bc:	5b                   	pop    %ebx
  1037bd:	5d                   	pop    %ebp
  1037be:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
  1037bf:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  1037c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1037c8:	2b 43 7c             	sub    0x7c(%ebx),%eax
  1037cb:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
  1037d1:	89 02                	mov    %eax,(%edx)
	*rtime = (p->rtime); 
  1037d3:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
  1037d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1037dc:	89 10                	mov    %edx,(%eax)
	//cprintf("\nwtime: %d\n",*wtime);
	//cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
  1037de:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
  1037e1:	8b 53 08             	mov    0x8(%ebx),%edx
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
	*rtime = (p->rtime); 
	//cprintf("\nwtime: %d\n",*wtime);
	//cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
  1037e4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  1037eb:	00 00 00 
	p->ctime = 0;
  1037ee:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->etime = 0;
        pid = p->pid;
        kfree(p->kstack);
  1037f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1037f8:	89 14 24             	mov    %edx,(%esp)
	*rtime = (p->rtime); 
	//cprintf("\nwtime: %d\n",*wtime);
	//cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
  1037fb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  103802:	00 00 00 
        pid = p->pid;
        kfree(p->kstack);
  103805:	e8 66 ec ff ff       	call   102470 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
  10380a:	8b 53 04             	mov    0x4(%ebx),%edx
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
  10380d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
  103814:	89 14 24             	mov    %edx,(%esp)
  103817:	e8 e4 2d 00 00       	call   106600 <freevm>
        p->state = UNUSED;
  10381c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  103823:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  10382a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  103831:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  103835:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->priority = 0;
  10383c:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103843:	00 00 00 
        release(&ptable.lock);
  103846:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  10384d:	e8 1e 08 00 00       	call   104070 <release>
        return pid;
  103852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103855:	e9 5f ff ff ff       	jmp    1037b9 <wait2+0x99>
  10385a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103860 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103860:	55                   	push   %ebp
  103861:	89 e5                	mov    %esp,%ebp
  103863:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  103864:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103869:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  10386c:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103873:	e8 48 08 00 00       	call   1040c0 <acquire>
  103878:	31 c0                	xor    %eax,%eax
  10387a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103880:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  103886:	72 30                	jb     1038b8 <wait+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  103888:	85 c0                	test   %eax,%eax
  10388a:	74 5c                	je     1038e8 <wait+0x88>
  10388c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103892:	8b 48 24             	mov    0x24(%eax),%ecx
  103895:	85 c9                	test   %ecx,%ecx
  103897:	75 4f                	jne    1038e8 <wait+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  103899:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx
  10389e:	89 04 24             	mov    %eax,(%esp)
  1038a1:	c7 44 24 04 20 cb 10 	movl   $0x10cb20,0x4(%esp)
  1038a8:	00 
  1038a9:	e8 52 fb ff ff       	call   103400 <sleep>
  1038ae:	31 c0                	xor    %eax,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1038b0:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  1038b6:	73 d0                	jae    103888 <wait+0x28>
      if(p->parent != proc)
  1038b8:	8b 53 14             	mov    0x14(%ebx),%edx
  1038bb:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
  1038c2:	74 0c                	je     1038d0 <wait+0x70>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1038c4:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  1038ca:	eb b4                	jmp    103880 <wait+0x20>
  1038cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  1038d0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  1038d4:	74 29                	je     1038ff <wait+0x9f>
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
  1038d6:	b8 01 00 00 00       	mov    $0x1,%eax
  1038db:	90                   	nop
  1038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1038e0:	eb e2                	jmp    1038c4 <wait+0x64>
  1038e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  1038e8:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1038ef:	e8 7c 07 00 00       	call   104070 <release>
  1038f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  1038f9:	83 c4 24             	add    $0x24,%esp
  1038fc:	5b                   	pop    %ebx
  1038fd:	5d                   	pop    %ebp
  1038fe:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
  1038ff:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
  103902:	8b 53 08             	mov    0x8(%ebx),%edx
  103905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103908:	89 14 24             	mov    %edx,(%esp)
  10390b:	e8 60 eb ff ff       	call   102470 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
  103910:	8b 53 04             	mov    0x4(%ebx),%edx
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
  103913:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
  10391a:	89 14 24             	mov    %edx,(%esp)
  10391d:	e8 de 2c 00 00       	call   106600 <freevm>
        p->state = UNUSED;
  103922:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  103929:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  103930:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  103937:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  10393b:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->rtime = 0;
  103942:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  103949:	00 00 00 
	p->ctime = 0;
  10394c:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->etime = 0;
  103953:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  10395a:	00 00 00 
	p->priority = 0;
  10395d:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103964:	00 00 00 
        release(&ptable.lock);
  103967:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  10396e:	e8 fd 06 00 00       	call   104070 <release>
        return pid;
  103973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103976:	eb 81                	jmp    1038f9 <wait+0x99>
  103978:	90                   	nop
  103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103980 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  103980:	55                   	push   %ebp
  103981:	89 e5                	mov    %esp,%ebp
  103983:	56                   	push   %esi
  103984:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
  103985:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  103987:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
  10398a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103991:	3b 15 c8 92 10 00    	cmp    0x1092c8,%edx
  103997:	0f 84 15 01 00 00    	je     103ab2 <exit+0x132>
  10399d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
  1039a0:	8d 73 08             	lea    0x8(%ebx),%esi
  1039a3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
  1039a7:	85 c0                	test   %eax,%eax
  1039a9:	74 1d                	je     1039c8 <exit+0x48>
      fileclose(proc->ofile[fd]);
  1039ab:	89 04 24             	mov    %eax,(%esp)
  1039ae:	e8 8d d7 ff ff       	call   101140 <fileclose>
      proc->ofile[fd] = 0;
  1039b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1039b9:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
  1039c0:	00 
  1039c1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  1039c8:	83 c3 01             	add    $0x1,%ebx
  1039cb:	83 fb 10             	cmp    $0x10,%ebx
  1039ce:	75 d0                	jne    1039a0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  1039d0:	8b 42 68             	mov    0x68(%edx),%eax
  1039d3:	89 04 24             	mov    %eax,(%esp)
  1039d6:	e8 65 e0 ff ff       	call   101a40 <iput>
  proc->cwd = 0;
  1039db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1039e1:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
  1039e8:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  1039ef:	e8 cc 06 00 00       	call   1040c0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  1039f4:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
  1039fb:	b8 54 cb 10 00       	mov    $0x10cb54,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  103a00:	8b 51 14             	mov    0x14(%ecx),%edx
  103a03:	eb 0f                	jmp    103a14 <exit+0x94>
  103a05:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103a08:	05 8c 00 00 00       	add    $0x8c,%eax
  103a0d:	3d 54 ee 10 00       	cmp    $0x10ee54,%eax
  103a12:	74 1e                	je     103a32 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
  103a14:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103a18:	75 ee                	jne    103a08 <exit+0x88>
  103a1a:	3b 50 20             	cmp    0x20(%eax),%edx
  103a1d:	75 e9                	jne    103a08 <exit+0x88>
      p->state = RUNNABLE;
  103a1f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103a26:	05 8c 00 00 00       	add    $0x8c,%eax
  103a2b:	3d 54 ee 10 00       	cmp    $0x10ee54,%eax
  103a30:	75 e2                	jne    103a14 <exit+0x94>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  103a32:	8b 1d c8 92 10 00    	mov    0x1092c8,%ebx
  103a38:	ba 54 cb 10 00       	mov    $0x10cb54,%edx
  103a3d:	eb 0f                	jmp    103a4e <exit+0xce>
  103a3f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103a40:	81 c2 8c 00 00 00    	add    $0x8c,%edx
  103a46:	81 fa 54 ee 10 00    	cmp    $0x10ee54,%edx
  103a4c:	74 3a                	je     103a88 <exit+0x108>
    if(p->parent == proc){
  103a4e:	3b 4a 14             	cmp    0x14(%edx),%ecx
  103a51:	75 ed                	jne    103a40 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
  103a53:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  103a57:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
  103a5a:	75 e4                	jne    103a40 <exit+0xc0>
  103a5c:	b8 54 cb 10 00       	mov    $0x10cb54,%eax
  103a61:	eb 11                	jmp    103a74 <exit+0xf4>
  103a63:	90                   	nop
  103a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103a68:	05 8c 00 00 00       	add    $0x8c,%eax
  103a6d:	3d 54 ee 10 00       	cmp    $0x10ee54,%eax
  103a72:	74 cc                	je     103a40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
  103a74:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103a78:	75 ee                	jne    103a68 <exit+0xe8>
  103a7a:	3b 58 20             	cmp    0x20(%eax),%ebx
  103a7d:	75 e9                	jne    103a68 <exit+0xe8>
      p->state = RUNNABLE;
  103a7f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103a86:	eb e0                	jmp    103a68 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  103a88:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  proc->etime = clockticks();
  103a8f:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  103a96:	e8 95 f8 ff ff       	call   103330 <clockticks>
  103a9b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  sched();
  103aa1:	e8 ba f8 ff ff       	call   103360 <sched>
  panic("zombie exit");
  103aa6:	c7 04 24 25 70 10 00 	movl   $0x107025,(%esp)
  103aad:	e8 de cf ff ff       	call   100a90 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
  103ab2:	c7 04 24 18 70 10 00 	movl   $0x107018,(%esp)
  103ab9:	e8 d2 cf ff ff       	call   100a90 <panic>
  103abe:	66 90                	xchg   %ax,%ax

00103ac0 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103ac0:	55                   	push   %ebp
  103ac1:	89 e5                	mov    %esp,%ebp
  103ac3:	53                   	push   %ebx
  103ac4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  103ac7:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103ace:	e8 ed 05 00 00       	call   1040c0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
  103ad3:	8b 15 60 cb 10 00    	mov    0x10cb60,%edx
  103ad9:	85 d2                	test   %edx,%edx
  103adb:	0f 84 cd 00 00 00    	je     103bae <allocproc+0xee>

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
  103ae1:	bb e0 cb 10 00       	mov    $0x10cbe0,%ebx
  103ae6:	eb 12                	jmp    103afa <allocproc+0x3a>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103ae8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103aee:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  103af4:	0f 84 9e 00 00 00    	je     103b98 <allocproc+0xd8>
    if(p->state == UNUSED)
  103afa:	8b 43 0c             	mov    0xc(%ebx),%eax
  103afd:	85 c0                	test   %eax,%eax
  103aff:	75 e7                	jne    103ae8 <allocproc+0x28>
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  103b01:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  103b08:	a1 24 87 10 00       	mov    0x108724,%eax
  103b0d:	89 43 10             	mov    %eax,0x10(%ebx)
  103b10:	83 c0 01             	add    $0x1,%eax
  103b13:	a3 24 87 10 00       	mov    %eax,0x108724
  release(&ptable.lock);
  103b18:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103b1f:	e8 4c 05 00 00       	call   104070 <release>

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
  103b24:	e8 07 e9 ff ff       	call   102430 <kalloc>
  103b29:	85 c0                	test   %eax,%eax
  103b2b:	89 43 08             	mov    %eax,0x8(%ebx)
  103b2e:	0f 84 84 00 00 00    	je     103bb8 <allocproc+0xf8>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  103b34:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
  103b3a:	89 53 18             	mov    %edx,0x18(%ebx)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret (see below).
  sp -= 4;
  *(uint*)sp = (uint)trapret;
  103b3d:	c7 80 b0 0f 00 00 10 	movl   $0x105310,0xfb0(%eax)
  103b44:	53 10 00 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  103b47:	05 9c 0f 00 00       	add    $0xf9c,%eax
  103b4c:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
  103b4f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  103b56:	00 
  103b57:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103b5e:	00 
  103b5f:	89 04 24             	mov    %eax,(%esp)
  103b62:	e8 f9 05 00 00       	call   104160 <memset>
  p->context->eip = (uint)forkret;
  103b67:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103b6a:	c7 40 10 10 33 10 00 	movl   $0x103310,0x10(%eax)


  p->ctime = clockticks();
  103b71:	e8 ba f7 ff ff       	call   103330 <clockticks>
  p->rtime = 0;
  103b76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  103b7d:	00 00 00 
  p->priority = 0;
  103b80:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103b87:	00 00 00 
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;


  p->ctime = clockticks();
  103b8a:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}
  103b8d:	89 d8                	mov    %ebx,%eax
  103b8f:	83 c4 14             	add    $0x14,%esp
  103b92:	5b                   	pop    %ebx
  103b93:	5d                   	pop    %ebp
  103b94:	c3                   	ret    
  103b95:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  103b98:	31 db                	xor    %ebx,%ebx
  103b9a:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103ba1:	e8 ca 04 00 00       	call   104070 <release>
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}
  103ba6:	89 d8                	mov    %ebx,%eax
  103ba8:	83 c4 14             	add    $0x14,%esp
  103bab:	5b                   	pop    %ebx
  103bac:	5d                   	pop    %ebp
  103bad:	c3                   	ret    
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  103bae:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx
  103bb3:	e9 49 ff ff ff       	jmp    103b01 <allocproc+0x41>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
  103bb8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  103bbf:	31 db                	xor    %ebx,%ebx
    return 0;
  103bc1:	eb ca                	jmp    103b8d <allocproc+0xcd>
  103bc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103bd0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103bd0:	55                   	push   %ebp
  103bd1:	89 e5                	mov    %esp,%ebp
  103bd3:	57                   	push   %edi
  103bd4:	56                   	push   %esi
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103bd5:	be ff ff ff ff       	mov    $0xffffffff,%esi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103bda:	53                   	push   %ebx
  103bdb:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103bde:	e8 dd fe ff ff       	call   103ac0 <allocproc>
  103be3:	85 c0                	test   %eax,%eax
  103be5:	89 c3                	mov    %eax,%ebx
  103be7:	0f 84 be 00 00 00    	je     103cab <fork+0xdb>
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
  103bed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103bf3:	8b 10                	mov    (%eax),%edx
  103bf5:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bf9:	8b 40 04             	mov    0x4(%eax),%eax
  103bfc:	89 04 24             	mov    %eax,(%esp)
  103bff:	e8 7c 2a 00 00       	call   106680 <copyuvm>
  103c04:	85 c0                	test   %eax,%eax
  103c06:	89 43 04             	mov    %eax,0x4(%ebx)
  103c09:	0f 84 a6 00 00 00    	je     103cb5 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  103c0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
  103c15:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  103c1a:	8b 00                	mov    (%eax),%eax
  103c1c:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
  103c1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103c24:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
  103c27:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103c2e:	8b 43 18             	mov    0x18(%ebx),%eax
  103c31:	8b 72 18             	mov    0x18(%edx),%esi
  103c34:	89 c7                	mov    %eax,%edi
  103c36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  103c38:	31 f6                	xor    %esi,%esi
  103c3a:	8b 43 18             	mov    0x18(%ebx),%eax
  103c3d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  103c44:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103c4b:	90                   	nop
  103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
  103c50:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
  103c54:	85 c0                	test   %eax,%eax
  103c56:	74 13                	je     103c6b <fork+0x9b>
      np->ofile[i] = filedup(proc->ofile[i]);
  103c58:	89 04 24             	mov    %eax,(%esp)
  103c5b:	e8 10 d4 ff ff       	call   101070 <filedup>
  103c60:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  103c64:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
  103c6b:	83 c6 01             	add    $0x1,%esi
  103c6e:	83 fe 10             	cmp    $0x10,%esi
  103c71:	75 dd                	jne    103c50 <fork+0x80>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  103c73:	8b 42 68             	mov    0x68(%edx),%eax
  103c76:	89 04 24             	mov    %eax,(%esp)
  103c79:	e8 f2 d5 ff ff       	call   101270 <idup>
 
  pid = np->pid;
  103c7e:	8b 73 10             	mov    0x10(%ebx),%esi
  np->state = RUNNABLE;
  103c81:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  103c88:	89 43 68             	mov    %eax,0x68(%ebx)
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  103c8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103c91:	83 c3 6c             	add    $0x6c,%ebx
  103c94:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103c9b:	00 
  103c9c:	89 1c 24             	mov    %ebx,(%esp)
  103c9f:	83 c0 6c             	add    $0x6c,%eax
  103ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ca6:	e8 55 06 00 00       	call   104300 <safestrcpy>
  return pid;
}
  103cab:	83 c4 1c             	add    $0x1c,%esp
  103cae:	89 f0                	mov    %esi,%eax
  103cb0:	5b                   	pop    %ebx
  103cb1:	5e                   	pop    %esi
  103cb2:	5f                   	pop    %edi
  103cb3:	5d                   	pop    %ebp
  103cb4:	c3                   	ret    
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
    kfree(np->kstack);
  103cb5:	8b 43 08             	mov    0x8(%ebx),%eax
  103cb8:	89 04 24             	mov    %eax,(%esp)
  103cbb:	e8 b0 e7 ff ff       	call   102470 <kfree>
    np->kstack = 0;
  103cc0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
  103cc7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
  103cce:	eb db                	jmp    103cab <fork+0xdb>

00103cd0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103cd0:	55                   	push   %ebp
  103cd1:	89 e5                	mov    %esp,%ebp
  103cd3:	83 ec 18             	sub    $0x18,%esp
  uint sz = proc->sz;
  103cd6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103cdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz = proc->sz;
  103ce0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
  103ce2:	83 f9 00             	cmp    $0x0,%ecx
  103ce5:	7f 19                	jg     103d00 <growproc+0x30>
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  } else if(n < 0){
  103ce7:	75 39                	jne    103d22 <growproc+0x52>
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  }
  proc->sz = sz;
  103ce9:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
  103ceb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103cf1:	89 04 24             	mov    %eax,(%esp)
  103cf4:	e8 d7 2b 00 00       	call   1068d0 <switchuvm>
  103cf9:	31 c0                	xor    %eax,%eax
  return 0;
}
  103cfb:	c9                   	leave  
  103cfc:	c3                   	ret    
  103cfd:	8d 76 00             	lea    0x0(%esi),%esi
int
growproc(int n)
{
  uint sz = proc->sz;
  if(n > 0){
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
  103d00:	01 c1                	add    %eax,%ecx
  103d02:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103d06:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d0a:	8b 42 04             	mov    0x4(%edx),%eax
  103d0d:	89 04 24             	mov    %eax,(%esp)
  103d10:	e8 2b 2a 00 00       	call   106740 <allocuvm>
  103d15:	85 c0                	test   %eax,%eax
  103d17:	74 27                	je     103d40 <growproc+0x70>
      return -1;
  } else if(n < 0){
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
  103d19:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103d20:	eb c7                	jmp    103ce9 <growproc+0x19>
  103d22:	01 c1                	add    %eax,%ecx
  103d24:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d2c:	8b 42 04             	mov    0x4(%edx),%eax
  103d2f:	89 04 24             	mov    %eax,(%esp)
  103d32:	e8 29 28 00 00       	call   106560 <deallocuvm>
  103d37:	85 c0                	test   %eax,%eax
  103d39:	75 de                	jne    103d19 <growproc+0x49>
  103d3b:	90                   	nop
  103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
  103d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  103d45:	c9                   	leave  
  103d46:	c3                   	ret    
  103d47:	89 f6                	mov    %esi,%esi
  103d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103d50 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  103d50:	55                   	push   %ebp
  103d51:	89 e5                	mov    %esp,%ebp
  103d53:	53                   	push   %ebx
  103d54:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  103d57:	e8 64 fd ff ff       	call   103ac0 <allocproc>
  103d5c:	89 c3                	mov    %eax,%ebx
  initproc = p;
  103d5e:	a3 c8 92 10 00       	mov    %eax,0x1092c8
  if(!(p->pgdir = setupkvm()))
  103d63:	e8 18 27 00 00       	call   106480 <setupkvm>
  103d68:	85 c0                	test   %eax,%eax
  103d6a:	89 43 04             	mov    %eax,0x4(%ebx)
  103d6d:	0f 84 b6 00 00 00    	je     103e29 <userinit+0xd9>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  103d73:	89 04 24             	mov    %eax,(%esp)
  103d76:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103d7d:	00 
  103d7e:	c7 44 24 04 28 8b 10 	movl   $0x108b28,0x4(%esp)
  103d85:	00 
  103d86:	e8 65 26 00 00       	call   1063f0 <inituvm>
  p->sz = PGSIZE;
  103d8b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  103d91:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
  103d98:	00 
  103d99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103da0:	00 
  103da1:	8b 43 18             	mov    0x18(%ebx),%eax
  103da4:	89 04 24             	mov    %eax,(%esp)
  103da7:	e8 b4 03 00 00       	call   104160 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103dac:	8b 43 18             	mov    0x18(%ebx),%eax
  103daf:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  103db5:	8b 43 18             	mov    0x18(%ebx),%eax
  103db8:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
  103dbe:	8b 43 18             	mov    0x18(%ebx),%eax
  103dc1:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  103dc5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
  103dc9:	8b 43 18             	mov    0x18(%ebx),%eax
  103dcc:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  103dd0:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
  103dd4:	8b 43 18             	mov    0x18(%ebx),%eax
  103dd7:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
  103dde:	8b 43 18             	mov    0x18(%ebx),%eax
  103de1:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
  103de8:	8b 43 18             	mov    0x18(%ebx),%eax
  103deb:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
  103df2:	8d 43 6c             	lea    0x6c(%ebx),%eax
  103df5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103dfc:	00 
  103dfd:	c7 44 24 04 4a 70 10 	movl   $0x10704a,0x4(%esp)
  103e04:	00 
  103e05:	89 04 24             	mov    %eax,(%esp)
  103e08:	e8 f3 04 00 00       	call   104300 <safestrcpy>
  p->cwd = namei("/");
  103e0d:	c7 04 24 53 70 10 00 	movl   $0x107053,(%esp)
  103e14:	e8 f7 e1 ff ff       	call   102010 <namei>

  p->state = RUNNABLE;
  103e19:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  103e20:	89 43 68             	mov    %eax,0x68(%ebx)

  p->state = RUNNABLE;
}
  103e23:	83 c4 14             	add    $0x14,%esp
  103e26:	5b                   	pop    %ebx
  103e27:	5d                   	pop    %ebp
  103e28:	c3                   	ret    
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if(!(p->pgdir = setupkvm()))
    panic("userinit: out of memory?");
  103e29:	c7 04 24 31 70 10 00 	movl   $0x107031,(%esp)
  103e30:	e8 5b cc ff ff       	call   100a90 <panic>
  103e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103e40 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103e40:	55                   	push   %ebp
  103e41:	89 e5                	mov    %esp,%ebp
  103e43:	57                   	push   %edi
  103e44:	56                   	push   %esi
  103e45:	53                   	push   %ebx

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103e46:	bb 54 cb 10 00       	mov    $0x10cb54,%ebx
{
  103e4b:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103e4e:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103e51:	eb 4e                	jmp    103ea1 <procdump+0x61>
  103e53:	90                   	nop
  103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103e58:	8b 04 85 b4 70 10 00 	mov    0x1070b4(,%eax,4),%eax
  103e5f:	85 c0                	test   %eax,%eax
  103e61:	74 4a                	je     103ead <procdump+0x6d>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103e63:	8b 53 10             	mov    0x10(%ebx),%edx
  103e66:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
  103e69:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  103e6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103e71:	c7 04 24 59 70 10 00 	movl   $0x107059,(%esp)
  103e78:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e7c:	e8 3f c6 ff ff       	call   1004c0 <cprintf>
    if(p->state == SLEEPING){
  103e81:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  103e85:	74 31                	je     103eb8 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  103e87:	c7 04 24 36 6f 10 00 	movl   $0x106f36,(%esp)
  103e8e:	e8 2d c6 ff ff       	call   1004c0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103e93:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103e99:	81 fb 54 ee 10 00    	cmp    $0x10ee54,%ebx
  103e9f:	74 57                	je     103ef8 <procdump+0xb8>
    if(p->state == UNUSED)
  103ea1:	8b 43 0c             	mov    0xc(%ebx),%eax
  103ea4:	85 c0                	test   %eax,%eax
  103ea6:	74 eb                	je     103e93 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103ea8:	83 f8 05             	cmp    $0x5,%eax
  103eab:	76 ab                	jbe    103e58 <procdump+0x18>
  103ead:	b8 55 70 10 00       	mov    $0x107055,%eax
  103eb2:	eb af                	jmp    103e63 <procdump+0x23>
  103eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103eb8:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103ebb:	31 f6                	xor    %esi,%esi
  103ebd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  103ec4:	83 c0 08             	add    $0x8,%eax
  103ec7:	89 04 24             	mov    %eax,(%esp)
  103eca:	e8 81 00 00 00       	call   103f50 <getcallerpcs>
  103ecf:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
  103ed0:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103ed3:	85 c0                	test   %eax,%eax
  103ed5:	74 b0                	je     103e87 <procdump+0x47>
  103ed7:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[i]);
  103eda:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ede:	c7 04 24 0a 6b 10 00 	movl   $0x106b0a,(%esp)
  103ee5:	e8 d6 c5 ff ff       	call   1004c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
  103eea:	83 fe 0a             	cmp    $0xa,%esi
  103eed:	75 e1                	jne    103ed0 <procdump+0x90>
  103eef:	eb 96                	jmp    103e87 <procdump+0x47>
  103ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
  103ef8:	83 c4 4c             	add    $0x4c,%esp
  103efb:	5b                   	pop    %ebx
  103efc:	5e                   	pop    %esi
  103efd:	5f                   	pop    %edi
  103efe:	5d                   	pop    %ebp
  103eff:	90                   	nop
  103f00:	c3                   	ret    
  103f01:	eb 0d                	jmp    103f10 <pinit>
  103f03:	90                   	nop
  103f04:	90                   	nop
  103f05:	90                   	nop
  103f06:	90                   	nop
  103f07:	90                   	nop
  103f08:	90                   	nop
  103f09:	90                   	nop
  103f0a:	90                   	nop
  103f0b:	90                   	nop
  103f0c:	90                   	nop
  103f0d:	90                   	nop
  103f0e:	90                   	nop
  103f0f:	90                   	nop

00103f10 <pinit>:
 return xticks;
}

void
pinit(void)
{
  103f10:	55                   	push   %ebp
  103f11:	89 e5                	mov    %esp,%ebp
  103f13:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
  103f16:	c7 44 24 04 62 70 10 	movl   $0x107062,0x4(%esp)
  103f1d:	00 
  103f1e:	c7 04 24 20 cb 10 00 	movl   $0x10cb20,(%esp)
  103f25:	e8 06 00 00 00       	call   103f30 <initlock>
}
  103f2a:	c9                   	leave  
  103f2b:	c3                   	ret    
  103f2c:	90                   	nop
  103f2d:	90                   	nop
  103f2e:	90                   	nop
  103f2f:	90                   	nop

00103f30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  103f30:	55                   	push   %ebp
  103f31:	89 e5                	mov    %esp,%ebp
  103f33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
  103f36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
  103f39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  103f3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
  103f42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  103f49:	5d                   	pop    %ebp
  103f4a:	c3                   	ret    
  103f4b:	90                   	nop
  103f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103f50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103f50:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103f51:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103f53:	89 e5                	mov    %esp,%ebp
  103f55:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103f56:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103f59:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103f5c:	83 ea 08             	sub    $0x8,%edx
  103f5f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
  103f60:	8d 8a 00 00 f0 ff    	lea    -0x100000(%edx),%ecx
  103f66:	81 f9 fe ff ef ff    	cmp    $0xffeffffe,%ecx
  103f6c:	77 1a                	ja     103f88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103f6e:	8b 4a 04             	mov    0x4(%edx),%ecx
  103f71:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103f74:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103f77:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103f79:	83 f8 0a             	cmp    $0xa,%eax
  103f7c:	75 e2                	jne    103f60 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  103f7e:	5b                   	pop    %ebx
  103f7f:	5d                   	pop    %ebp
  103f80:	c3                   	ret    
  103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103f88:	83 f8 09             	cmp    $0x9,%eax
  103f8b:	7f f1                	jg     103f7e <getcallerpcs+0x2e>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103f8d:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  103f90:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  103f93:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103f99:	83 c2 04             	add    $0x4,%edx
  103f9c:	83 f8 0a             	cmp    $0xa,%eax
  103f9f:	75 ef                	jne    103f90 <getcallerpcs+0x40>
    pcs[i] = 0;
}
  103fa1:	5b                   	pop    %ebx
  103fa2:	5d                   	pop    %ebp
  103fa3:	c3                   	ret    
  103fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103fb0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103fb0:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
  103fb1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103fb3:	89 e5                	mov    %esp,%ebp
  103fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
  103fb8:	8b 0a                	mov    (%edx),%ecx
  103fba:	85 c9                	test   %ecx,%ecx
  103fbc:	74 10                	je     103fce <holding+0x1e>
  103fbe:	8b 42 08             	mov    0x8(%edx),%eax
  103fc1:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103fc8:	0f 94 c0             	sete   %al
  103fcb:	0f b6 c0             	movzbl %al,%eax
}
  103fce:	5d                   	pop    %ebp
  103fcf:	c3                   	ret    

00103fd0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  103fd0:	55                   	push   %ebp
  103fd1:	89 e5                	mov    %esp,%ebp
  103fd3:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103fd4:	9c                   	pushf  
  103fd5:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103fd6:	fa                   	cli    
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103fd7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103fde:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103fe4:	8d 48 01             	lea    0x1(%eax),%ecx
  103fe7:	85 c0                	test   %eax,%eax
  103fe9:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
  103fef:	75 12                	jne    104003 <pushcli+0x33>
    cpu->intena = eflags & FL_IF;
  103ff1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ff7:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103ffd:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  104003:	5b                   	pop    %ebx
  104004:	5d                   	pop    %ebp
  104005:	c3                   	ret    
  104006:	8d 76 00             	lea    0x0(%esi),%esi
  104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104010 <popcli>:

void
popcli(void)
{
  104010:	55                   	push   %ebp
  104011:	89 e5                	mov    %esp,%ebp
  104013:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  104016:	9c                   	pushf  
  104017:	58                   	pop    %eax
  if(readeflags()&FL_IF)
  104018:	f6 c4 02             	test   $0x2,%ah
  10401b:	75 43                	jne    104060 <popcli+0x50>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
  10401d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  104024:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  10402a:	83 e8 01             	sub    $0x1,%eax
  10402d:	85 c0                	test   %eax,%eax
  10402f:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
  104035:	78 1d                	js     104054 <popcli+0x44>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
  104037:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10403d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  104043:	85 d2                	test   %edx,%edx
  104045:	75 0b                	jne    104052 <popcli+0x42>
  104047:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  10404d:	85 c0                	test   %eax,%eax
  10404f:	74 01                	je     104052 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
  104051:	fb                   	sti    
    sti();
}
  104052:	c9                   	leave  
  104053:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
  104054:	c7 04 24 ef 70 10 00 	movl   $0x1070ef,(%esp)
  10405b:	e8 30 ca ff ff       	call   100a90 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  104060:	c7 04 24 d8 70 10 00 	movl   $0x1070d8,(%esp)
  104067:	e8 24 ca ff ff       	call   100a90 <panic>
  10406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104070 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
  104070:	55                   	push   %ebp
  104071:	89 e5                	mov    %esp,%ebp
  104073:	83 ec 18             	sub    $0x18,%esp
  104076:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  104079:	8b 0a                	mov    (%edx),%ecx
  10407b:	85 c9                	test   %ecx,%ecx
  10407d:	74 0c                	je     10408b <release+0x1b>
  10407f:	8b 42 08             	mov    0x8(%edx),%eax
  104082:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  104089:	74 0d                	je     104098 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
  10408b:	c7 04 24 f6 70 10 00 	movl   $0x1070f6,(%esp)
  104092:	e8 f9 c9 ff ff       	call   100a90 <panic>
  104097:	90                   	nop

  lk->pcs[0] = 0;
  104098:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10409f:	31 c0                	xor    %eax,%eax
  lk->cpu = 0;
  1040a1:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
  1040a8:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
}
  1040ab:	c9                   	leave  
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
  1040ac:	e9 5f ff ff ff       	jmp    104010 <popcli>
  1040b1:	eb 0d                	jmp    1040c0 <acquire>
  1040b3:	90                   	nop
  1040b4:	90                   	nop
  1040b5:	90                   	nop
  1040b6:	90                   	nop
  1040b7:	90                   	nop
  1040b8:	90                   	nop
  1040b9:	90                   	nop
  1040ba:	90                   	nop
  1040bb:	90                   	nop
  1040bc:	90                   	nop
  1040bd:	90                   	nop
  1040be:	90                   	nop
  1040bf:	90                   	nop

001040c0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  1040c0:	55                   	push   %ebp
  1040c1:	89 e5                	mov    %esp,%ebp
  1040c3:	53                   	push   %ebx
  1040c4:	83 ec 14             	sub    $0x14,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  1040c7:	9c                   	pushf  
  1040c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  1040c9:	fa                   	cli    
{
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  1040ca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  1040d1:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  1040d7:	8d 48 01             	lea    0x1(%eax),%ecx
  1040da:	85 c0                	test   %eax,%eax
  1040dc:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
  1040e2:	75 12                	jne    1040f6 <acquire+0x36>
    cpu->intena = eflags & FL_IF;
  1040e4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1040ea:	81 e3 00 02 00 00    	and    $0x200,%ebx
  1040f0:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
  1040f6:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  1040f9:	8b 1a                	mov    (%edx),%ebx
  1040fb:	85 db                	test   %ebx,%ebx
  1040fd:	74 0c                	je     10410b <acquire+0x4b>
  1040ff:	8b 42 08             	mov    0x8(%edx),%eax
  104102:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  104109:	74 45                	je     104150 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  10410b:	b9 01 00 00 00       	mov    $0x1,%ecx
  104110:	eb 09                	jmp    10411b <acquire+0x5b>
  104112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
  104118:	8b 55 08             	mov    0x8(%ebp),%edx
  10411b:	89 c8                	mov    %ecx,%eax
  10411d:	f0 87 02             	lock xchg %eax,(%edx)
  104120:	85 c0                	test   %eax,%eax
  104122:	75 f4                	jne    104118 <acquire+0x58>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  104124:	8b 45 08             	mov    0x8(%ebp),%eax
  104127:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  10412e:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
  104131:	8b 45 08             	mov    0x8(%ebp),%eax
  104134:	83 c0 0c             	add    $0xc,%eax
  104137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10413b:	8d 45 08             	lea    0x8(%ebp),%eax
  10413e:	89 04 24             	mov    %eax,(%esp)
  104141:	e8 0a fe ff ff       	call   103f50 <getcallerpcs>
}
  104146:	83 c4 14             	add    $0x14,%esp
  104149:	5b                   	pop    %ebx
  10414a:	5d                   	pop    %ebp
  10414b:	c3                   	ret    
  10414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
    panic("acquire");
  104150:	c7 04 24 fe 70 10 00 	movl   $0x1070fe,(%esp)
  104157:	e8 34 c9 ff ff       	call   100a90 <panic>
  10415c:	90                   	nop
  10415d:	90                   	nop
  10415e:	90                   	nop
  10415f:	90                   	nop

00104160 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  104160:	55                   	push   %ebp
  104161:	89 e5                	mov    %esp,%ebp
  104163:	8b 55 08             	mov    0x8(%ebp),%edx
  104166:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  104167:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10416a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10416d:	89 d7                	mov    %edx,%edi
  10416f:	fc                   	cld    
  104170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  104172:	89 d0                	mov    %edx,%eax
  104174:	5f                   	pop    %edi
  104175:	5d                   	pop    %ebp
  104176:	c3                   	ret    
  104177:	89 f6                	mov    %esi,%esi
  104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104180 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104180:	55                   	push   %ebp
  104181:	89 e5                	mov    %esp,%ebp
  104183:	57                   	push   %edi
  104184:	56                   	push   %esi
  104185:	53                   	push   %ebx
  104186:	8b 55 10             	mov    0x10(%ebp),%edx
  104189:	8b 75 08             	mov    0x8(%ebp),%esi
  10418c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10418f:	85 d2                	test   %edx,%edx
  104191:	74 2d                	je     1041c0 <memcmp+0x40>
    if(*s1 != *s2)
  104193:	0f b6 1e             	movzbl (%esi),%ebx
  104196:	0f b6 0f             	movzbl (%edi),%ecx
  104199:	38 cb                	cmp    %cl,%bl
  10419b:	75 2b                	jne    1041c8 <memcmp+0x48>
      return *s1 - *s2;
  10419d:	83 ea 01             	sub    $0x1,%edx
  1041a0:	31 c0                	xor    %eax,%eax
  1041a2:	eb 18                	jmp    1041bc <memcmp+0x3c>
  1041a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  1041a8:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  1041ad:	83 ea 01             	sub    $0x1,%edx
  1041b0:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  1041b5:	83 c0 01             	add    $0x1,%eax
  1041b8:	38 cb                	cmp    %cl,%bl
  1041ba:	75 0c                	jne    1041c8 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  1041bc:	85 d2                	test   %edx,%edx
  1041be:	75 e8                	jne    1041a8 <memcmp+0x28>
  1041c0:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  1041c2:	5b                   	pop    %ebx
  1041c3:	5e                   	pop    %esi
  1041c4:	5f                   	pop    %edi
  1041c5:	5d                   	pop    %ebp
  1041c6:	c3                   	ret    
  1041c7:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  1041c8:	0f b6 c3             	movzbl %bl,%eax
  1041cb:	0f b6 c9             	movzbl %cl,%ecx
  1041ce:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  1041d0:	5b                   	pop    %ebx
  1041d1:	5e                   	pop    %esi
  1041d2:	5f                   	pop    %edi
  1041d3:	5d                   	pop    %ebp
  1041d4:	c3                   	ret    
  1041d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001041e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  1041e0:	55                   	push   %ebp
  1041e1:	89 e5                	mov    %esp,%ebp
  1041e3:	57                   	push   %edi
  1041e4:	56                   	push   %esi
  1041e5:	53                   	push   %ebx
  1041e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1041e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  1041ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  1041ef:	39 c6                	cmp    %eax,%esi
  1041f1:	73 2d                	jae    104220 <memmove+0x40>
  1041f3:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  1041f6:	39 f8                	cmp    %edi,%eax
  1041f8:	73 26                	jae    104220 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  1041fa:	85 db                	test   %ebx,%ebx
  1041fc:	74 1d                	je     10421b <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  1041fe:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  104201:	31 d2                	xor    %edx,%edx
  104203:	90                   	nop
  104204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  104208:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  10420d:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  104211:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104214:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  104217:	85 c9                	test   %ecx,%ecx
  104219:	75 ed                	jne    104208 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  10421b:	5b                   	pop    %ebx
  10421c:	5e                   	pop    %esi
  10421d:	5f                   	pop    %edi
  10421e:	5d                   	pop    %ebp
  10421f:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  104220:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  104222:	85 db                	test   %ebx,%ebx
  104224:	74 f5                	je     10421b <memmove+0x3b>
  104226:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  104228:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  10422c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  10422f:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  104232:	39 d3                	cmp    %edx,%ebx
  104234:	75 f2                	jne    104228 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  104236:	5b                   	pop    %ebx
  104237:	5e                   	pop    %esi
  104238:	5f                   	pop    %edi
  104239:	5d                   	pop    %ebp
  10423a:	c3                   	ret    
  10423b:	90                   	nop
  10423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00104240 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  104240:	55                   	push   %ebp
  104241:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
  104243:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
  104244:	e9 97 ff ff ff       	jmp    1041e0 <memmove>
  104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104250 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
  104250:	55                   	push   %ebp
  104251:	89 e5                	mov    %esp,%ebp
  104253:	57                   	push   %edi
  104254:	56                   	push   %esi
  104255:	53                   	push   %ebx
  104256:	8b 7d 10             	mov    0x10(%ebp),%edi
  104259:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10425c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  10425f:	85 ff                	test   %edi,%edi
  104261:	74 3d                	je     1042a0 <strncmp+0x50>
  104263:	0f b6 01             	movzbl (%ecx),%eax
  104266:	84 c0                	test   %al,%al
  104268:	75 18                	jne    104282 <strncmp+0x32>
  10426a:	eb 3c                	jmp    1042a8 <strncmp+0x58>
  10426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104270:	83 ef 01             	sub    $0x1,%edi
  104273:	74 2b                	je     1042a0 <strncmp+0x50>
    n--, p++, q++;
  104275:	83 c1 01             	add    $0x1,%ecx
  104278:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  10427b:	0f b6 01             	movzbl (%ecx),%eax
  10427e:	84 c0                	test   %al,%al
  104280:	74 26                	je     1042a8 <strncmp+0x58>
  104282:	0f b6 33             	movzbl (%ebx),%esi
  104285:	89 f2                	mov    %esi,%edx
  104287:	38 d0                	cmp    %dl,%al
  104289:	74 e5                	je     104270 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10428b:	81 e6 ff 00 00 00    	and    $0xff,%esi
  104291:	0f b6 c0             	movzbl %al,%eax
  104294:	29 f0                	sub    %esi,%eax
}
  104296:	5b                   	pop    %ebx
  104297:	5e                   	pop    %esi
  104298:	5f                   	pop    %edi
  104299:	5d                   	pop    %ebp
  10429a:	c3                   	ret    
  10429b:	90                   	nop
  10429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1042a0:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  1042a2:	5b                   	pop    %ebx
  1042a3:	5e                   	pop    %esi
  1042a4:	5f                   	pop    %edi
  1042a5:	5d                   	pop    %ebp
  1042a6:	c3                   	ret    
  1042a7:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  1042a8:	0f b6 33             	movzbl (%ebx),%esi
  1042ab:	eb de                	jmp    10428b <strncmp+0x3b>
  1042ad:	8d 76 00             	lea    0x0(%esi),%esi

001042b0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  1042b0:	55                   	push   %ebp
  1042b1:	89 e5                	mov    %esp,%ebp
  1042b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b6:	56                   	push   %esi
  1042b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1042ba:	53                   	push   %ebx
  1042bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  1042be:	89 c3                	mov    %eax,%ebx
  1042c0:	eb 09                	jmp    1042cb <strncpy+0x1b>
  1042c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1042c8:	83 c6 01             	add    $0x1,%esi
  1042cb:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  1042ce:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  1042d1:	85 d2                	test   %edx,%edx
  1042d3:	7e 0c                	jle    1042e1 <strncpy+0x31>
  1042d5:	0f b6 16             	movzbl (%esi),%edx
  1042d8:	88 13                	mov    %dl,(%ebx)
  1042da:	83 c3 01             	add    $0x1,%ebx
  1042dd:	84 d2                	test   %dl,%dl
  1042df:	75 e7                	jne    1042c8 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  1042e1:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1042e3:	85 c9                	test   %ecx,%ecx
  1042e5:	7e 0c                	jle    1042f3 <strncpy+0x43>
  1042e7:	90                   	nop
    *s++ = 0;
  1042e8:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  1042ec:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  1042ef:	39 ca                	cmp    %ecx,%edx
  1042f1:	75 f5                	jne    1042e8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  1042f3:	5b                   	pop    %ebx
  1042f4:	5e                   	pop    %esi
  1042f5:	5d                   	pop    %ebp
  1042f6:	c3                   	ret    
  1042f7:	89 f6                	mov    %esi,%esi
  1042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104300 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  104300:	55                   	push   %ebp
  104301:	89 e5                	mov    %esp,%ebp
  104303:	8b 55 10             	mov    0x10(%ebp),%edx
  104306:	56                   	push   %esi
  104307:	8b 45 08             	mov    0x8(%ebp),%eax
  10430a:	53                   	push   %ebx
  10430b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  10430e:	85 d2                	test   %edx,%edx
  104310:	7e 1f                	jle    104331 <safestrcpy+0x31>
  104312:	89 c1                	mov    %eax,%ecx
  104314:	eb 05                	jmp    10431b <safestrcpy+0x1b>
  104316:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  104318:	83 c6 01             	add    $0x1,%esi
  10431b:	83 ea 01             	sub    $0x1,%edx
  10431e:	85 d2                	test   %edx,%edx
  104320:	7e 0c                	jle    10432e <safestrcpy+0x2e>
  104322:	0f b6 1e             	movzbl (%esi),%ebx
  104325:	88 19                	mov    %bl,(%ecx)
  104327:	83 c1 01             	add    $0x1,%ecx
  10432a:	84 db                	test   %bl,%bl
  10432c:	75 ea                	jne    104318 <safestrcpy+0x18>
    ;
  *s = 0;
  10432e:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  104331:	5b                   	pop    %ebx
  104332:	5e                   	pop    %esi
  104333:	5d                   	pop    %ebp
  104334:	c3                   	ret    
  104335:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104340 <strlen>:

int
strlen(const char *s)
{
  104340:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  104341:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  104343:	89 e5                	mov    %esp,%ebp
  104345:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  104348:	80 3a 00             	cmpb   $0x0,(%edx)
  10434b:	74 0c                	je     104359 <strlen+0x19>
  10434d:	8d 76 00             	lea    0x0(%esi),%esi
  104350:	83 c0 01             	add    $0x1,%eax
  104353:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104357:	75 f7                	jne    104350 <strlen+0x10>
    ;
  return n;
}
  104359:	5d                   	pop    %ebp
  10435a:	c3                   	ret    
  10435b:	90                   	nop

0010435c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
  10435c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
  104360:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
  104364:	55                   	push   %ebp
  pushl %ebx
  104365:	53                   	push   %ebx
  pushl %esi
  104366:	56                   	push   %esi
  pushl %edi
  104367:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
  104368:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
  10436a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
  10436c:	5f                   	pop    %edi
  popl %esi
  10436d:	5e                   	pop    %esi
  popl %ebx
  10436e:	5b                   	pop    %ebx
  popl %ebp
  10436f:	5d                   	pop    %ebp
  ret
  104370:	c3                   	ret    
  104371:	90                   	nop
  104372:	90                   	nop
  104373:	90                   	nop
  104374:	90                   	nop
  104375:	90                   	nop
  104376:	90                   	nop
  104377:	90                   	nop
  104378:	90                   	nop
  104379:	90                   	nop
  10437a:	90                   	nop
  10437b:	90                   	nop
  10437c:	90                   	nop
  10437d:	90                   	nop
  10437e:	90                   	nop
  10437f:	90                   	nop

00104380 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104380:	55                   	push   %ebp
  104381:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
  104383:	8b 55 08             	mov    0x8(%ebp),%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104386:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  104389:	8b 12                	mov    (%edx),%edx
  10438b:	39 c2                	cmp    %eax,%edx
  10438d:	77 09                	ja     104398 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
  return 0;
  10438f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104394:	5d                   	pop    %ebp
  104395:	c3                   	ret    
  104396:	66 90                	xchg   %ax,%ax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104398:	8d 48 04             	lea    0x4(%eax),%ecx
  10439b:	39 ca                	cmp    %ecx,%edx
  10439d:	72 f0                	jb     10438f <fetchint+0xf>
    return -1;
  *ip = *(int*)(addr);
  10439f:	8b 10                	mov    (%eax),%edx
  1043a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1043a4:	89 10                	mov    %edx,(%eax)
  1043a6:	31 c0                	xor    %eax,%eax
  return 0;
}
  1043a8:	5d                   	pop    %ebp
  1043a9:	c3                   	ret    
  1043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001043b0 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  1043b0:	55                   	push   %ebp
  1043b1:	89 e5                	mov    %esp,%ebp
  1043b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1043b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043b9:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  1043ba:	39 10                	cmp    %edx,(%eax)
  1043bc:	77 0a                	ja     1043c8 <fetchstr+0x18>
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  1043be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  1043c3:	5b                   	pop    %ebx
  1043c4:	5d                   	pop    %ebp
  1043c5:	c3                   	ret    
  1043c6:	66 90                	xchg   %ax,%ax
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  1043c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  1043cb:	89 11                	mov    %edx,(%ecx)
  ep = (char *) p->sz;
  1043cd:	8b 18                	mov    (%eax),%ebx
  for(s = *pp; s < ep; s++)
  1043cf:	39 da                	cmp    %ebx,%edx
  1043d1:	73 eb                	jae    1043be <fetchstr+0xe>
    if(*s == 0)
  1043d3:	31 c0                	xor    %eax,%eax
  1043d5:	89 d1                	mov    %edx,%ecx
  1043d7:	80 3a 00             	cmpb   $0x0,(%edx)
  1043da:	74 e7                	je     1043c3 <fetchstr+0x13>
  1043dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  1043e0:	83 c1 01             	add    $0x1,%ecx
  1043e3:	39 cb                	cmp    %ecx,%ebx
  1043e5:	76 d7                	jbe    1043be <fetchstr+0xe>
    if(*s == 0)
  1043e7:	80 39 00             	cmpb   $0x0,(%ecx)
  1043ea:	75 f4                	jne    1043e0 <fetchstr+0x30>
  1043ec:	89 c8                	mov    %ecx,%eax
  1043ee:	29 d0                	sub    %edx,%eax
  1043f0:	eb d1                	jmp    1043c3 <fetchstr+0x13>
  1043f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104400 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104400:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  104406:	55                   	push   %ebp
  104407:	89 e5                	mov    %esp,%ebp
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104409:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10440c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10440f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104411:	8b 52 44             	mov    0x44(%edx),%edx
  104414:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104418:	39 c2                	cmp    %eax,%edx
  10441a:	72 0c                	jb     104428 <argint+0x28>
    return -1;
  *ip = *(int*)(addr);
  10441c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  return x;
}
  104421:	5d                   	pop    %ebp
  104422:	c3                   	ret    
  104423:	90                   	nop
  104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104428:	8d 4a 04             	lea    0x4(%edx),%ecx
  10442b:	39 c8                	cmp    %ecx,%eax
  10442d:	72 ed                	jb     10441c <argint+0x1c>
    return -1;
  *ip = *(int*)(addr);
  10442f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104432:	8b 12                	mov    (%edx),%edx
  104434:	89 10                	mov    %edx,(%eax)
  104436:	31 c0                	xor    %eax,%eax
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  return x;
}
  104438:	5d                   	pop    %ebp
  104439:	c3                   	ret    
  10443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104440 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104440:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  104446:	55                   	push   %ebp
  104447:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104449:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10444c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  10444f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104451:	8b 52 44             	mov    0x44(%edx),%edx
  104454:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104458:	39 c2                	cmp    %eax,%edx
  10445a:	73 07                	jae    104463 <argptr+0x23>
  10445c:	8d 4a 04             	lea    0x4(%edx),%ecx
  10445f:	39 c8                	cmp    %ecx,%eax
  104461:	73 0d                	jae    104470 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
    return -1;
  *pp = (char *) i;
  return 0;
  104463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104468:	5d                   	pop    %ebp
  104469:	c3                   	ret    
  10446a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(addr);
  104470:	8b 12                	mov    (%edx),%edx
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
  104472:	39 c2                	cmp    %eax,%edx
  104474:	73 ed                	jae    104463 <argptr+0x23>
  104476:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104479:	01 d1                	add    %edx,%ecx
  10447b:	39 c1                	cmp    %eax,%ecx
  10447d:	73 e4                	jae    104463 <argptr+0x23>
    return -1;
  *pp = (char *) i;
  10447f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104482:	89 10                	mov    %edx,(%eax)
  104484:	31 c0                	xor    %eax,%eax
  return 0;
}
  104486:	5d                   	pop    %ebp
  104487:	c3                   	ret    
  104488:	90                   	nop
  104489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104490 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104490:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104497:	55                   	push   %ebp
  104498:	89 e5                	mov    %esp,%ebp
  10449a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  10449b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10449e:	8b 42 18             	mov    0x18(%edx),%eax
  1044a1:	8b 40 44             	mov    0x44(%eax),%eax
  1044a4:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1044a8:	8b 0a                	mov    (%edx),%ecx
  1044aa:	39 c8                	cmp    %ecx,%eax
  1044ac:	73 07                	jae    1044b5 <argstr+0x25>
  1044ae:	8d 58 04             	lea    0x4(%eax),%ebx
  1044b1:	39 d9                	cmp    %ebx,%ecx
  1044b3:	73 0b                	jae    1044c0 <argstr+0x30>

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  1044b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  1044ba:	5b                   	pop    %ebx
  1044bb:	5d                   	pop    %ebp
  1044bc:	c3                   	ret    
  1044bd:	8d 76 00             	lea    0x0(%esi),%esi
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(addr);
  1044c0:	8b 18                	mov    (%eax),%ebx
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  1044c2:	39 cb                	cmp    %ecx,%ebx
  1044c4:	73 ef                	jae    1044b5 <argstr+0x25>
    return -1;
  *pp = (char *) addr;
  1044c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1044c9:	89 d8                	mov    %ebx,%eax
  1044cb:	89 19                	mov    %ebx,(%ecx)
  ep = (char *) p->sz;
  1044cd:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
  1044cf:	39 d3                	cmp    %edx,%ebx
  1044d1:	73 e2                	jae    1044b5 <argstr+0x25>
    if(*s == 0)
  1044d3:	80 3b 00             	cmpb   $0x0,(%ebx)
  1044d6:	75 12                	jne    1044ea <argstr+0x5a>
  1044d8:	eb 1e                	jmp    1044f8 <argstr+0x68>
  1044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1044e0:	80 38 00             	cmpb   $0x0,(%eax)
  1044e3:	90                   	nop
  1044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1044e8:	74 0e                	je     1044f8 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  1044ea:	83 c0 01             	add    $0x1,%eax
  1044ed:	39 c2                	cmp    %eax,%edx
  1044ef:	90                   	nop
  1044f0:	77 ee                	ja     1044e0 <argstr+0x50>
  1044f2:	eb c1                	jmp    1044b5 <argstr+0x25>
  1044f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
  1044f8:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  1044fa:	5b                   	pop    %ebx
  1044fb:	5d                   	pop    %ebp
  1044fc:	c3                   	ret    
  1044fd:	8d 76 00             	lea    0x0(%esi),%esi

00104500 <syscall>:
[SYS_nice]    sys_nice,
};

void
syscall(void)
{
  104500:	55                   	push   %ebp
  104501:	89 e5                	mov    %esp,%ebp
  104503:	53                   	push   %ebx
  104504:	83 ec 14             	sub    $0x14,%esp
  int num;
  
  num = proc->tf->eax;
  104507:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10450e:	8b 5a 18             	mov    0x18(%edx),%ebx
  104511:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  104514:	83 f8 17             	cmp    $0x17,%eax
  104517:	77 17                	ja     104530 <syscall+0x30>
  104519:	8b 0c 85 40 71 10 00 	mov    0x107140(,%eax,4),%ecx
  104520:	85 c9                	test   %ecx,%ecx
  104522:	74 0c                	je     104530 <syscall+0x30>
    proc->tf->eax = syscalls[num]();
  104524:	ff d1                	call   *%ecx
  104526:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
  104529:	83 c4 14             	add    $0x14,%esp
  10452c:	5b                   	pop    %ebx
  10452d:	5d                   	pop    %ebp
  10452e:	c3                   	ret    
  10452f:	90                   	nop
  
  num = proc->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    proc->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  104530:	8b 4a 10             	mov    0x10(%edx),%ecx
  104533:	83 c2 6c             	add    $0x6c,%edx
  104536:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10453a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10453e:	c7 04 24 06 71 10 00 	movl   $0x107106,(%esp)
  104545:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104549:	e8 72 bf ff ff       	call   1004c0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  10454e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104554:	8b 40 18             	mov    0x18(%eax),%eax
  104557:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  10455e:	83 c4 14             	add    $0x14,%esp
  104561:	5b                   	pop    %ebx
  104562:	5d                   	pop    %ebp
  104563:	c3                   	ret    
  104564:	90                   	nop
  104565:	90                   	nop
  104566:	90                   	nop
  104567:	90                   	nop
  104568:	90                   	nop
  104569:	90                   	nop
  10456a:	90                   	nop
  10456b:	90                   	nop
  10456c:	90                   	nop
  10456d:	90                   	nop
  10456e:	90                   	nop
  10456f:	90                   	nop

00104570 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104570:	55                   	push   %ebp
  104571:	89 e5                	mov    %esp,%ebp
  104573:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104576:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104579:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10457c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  10457f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104586:	00 
  104587:	89 44 24 04          	mov    %eax,0x4(%esp)
  10458b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104592:	e8 a9 fe ff ff       	call   104440 <argptr>
  104597:	85 c0                	test   %eax,%eax
  104599:	79 15                	jns    1045b0 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  10459b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
  1045a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1045a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1045a6:	89 ec                	mov    %ebp,%esp
  1045a8:	5d                   	pop    %ebp
  1045a9:	c3                   	ret    
  1045aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  1045b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1045b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1045ba:	89 04 24             	mov    %eax,(%esp)
  1045bd:	e8 fe ea ff ff       	call   1030c0 <pipealloc>
  1045c2:	85 c0                	test   %eax,%eax
  1045c4:	78 d5                	js     10459b <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1045c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1045c9:	31 c0                	xor    %eax,%eax
  1045cb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  1045d8:	8b 5c 82 28          	mov    0x28(%edx,%eax,4),%ebx
  1045dc:	85 db                	test   %ebx,%ebx
  1045de:	74 28                	je     104608 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1045e0:	83 c0 01             	add    $0x1,%eax
  1045e3:	83 f8 10             	cmp    $0x10,%eax
  1045e6:	75 f0                	jne    1045d8 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
  1045e8:	89 0c 24             	mov    %ecx,(%esp)
  1045eb:	e8 50 cb ff ff       	call   101140 <fileclose>
    fileclose(wf);
  1045f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045f3:	89 04 24             	mov    %eax,(%esp)
  1045f6:	e8 45 cb ff ff       	call   101140 <fileclose>
  1045fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104600:	eb 9e                	jmp    1045a0 <sys_pipe+0x30>
  104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104608:	8d 58 08             	lea    0x8(%eax),%ebx
  10460b:	89 4c 9a 08          	mov    %ecx,0x8(%edx,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  10460f:	8b 75 ec             	mov    -0x14(%ebp),%esi
  104612:	31 d2                	xor    %edx,%edx
  104614:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  10461b:	90                   	nop
  10461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104620:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
  104625:	74 19                	je     104640 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104627:	83 c2 01             	add    $0x1,%edx
  10462a:	83 fa 10             	cmp    $0x10,%edx
  10462d:	75 f1                	jne    104620 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
  10462f:	c7 44 99 08 00 00 00 	movl   $0x0,0x8(%ecx,%ebx,4)
  104636:	00 
  104637:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10463a:	eb ac                	jmp    1045e8 <sys_pipe+0x78>
  10463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104640:	89 74 91 28          	mov    %esi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  104644:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  104647:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
  104649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10464c:	89 50 04             	mov    %edx,0x4(%eax)
  10464f:	31 c0                	xor    %eax,%eax
  return 0;
  104651:	e9 4a ff ff ff       	jmp    1045a0 <sys_pipe+0x30>
  104656:	8d 76 00             	lea    0x0(%esi),%esi
  104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104660 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104660:	55                   	push   %ebp
  104661:	89 e5                	mov    %esp,%ebp
  104663:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  104669:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  10466c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10466f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104672:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  104675:	89 44 24 04          	mov    %eax,0x4(%esp)
  104679:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104680:	e8 0b fe ff ff       	call   104490 <argstr>
  104685:	85 c0                	test   %eax,%eax
  104687:	79 17                	jns    1046a0 <sys_exec+0x40>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  10468e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104691:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104694:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104697:	89 ec                	mov    %ebp,%esp
  104699:	5d                   	pop    %ebp
  10469a:	c3                   	ret    
  10469b:	90                   	nop
  10469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  1046a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1046a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046ae:	e8 4d fd ff ff       	call   104400 <argint>
  1046b3:	85 c0                	test   %eax,%eax
  1046b5:	78 d2                	js     104689 <sys_exec+0x29>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  1046b7:	8d 7d 8c             	lea    -0x74(%ebp),%edi
  1046ba:	31 f6                	xor    %esi,%esi
  1046bc:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  1046c3:	00 
  1046c4:	31 db                	xor    %ebx,%ebx
  1046c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046cd:	00 
  1046ce:	89 3c 24             	mov    %edi,(%esp)
  1046d1:	e8 8a fa ff ff       	call   104160 <memset>
  1046d6:	eb 27                	jmp    1046ff <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
  1046d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1046e2:	8d 14 b7             	lea    (%edi,%esi,4),%edx
  1046e5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1046e9:	89 04 24             	mov    %eax,(%esp)
  1046ec:	e8 bf fc ff ff       	call   1043b0 <fetchstr>
  1046f1:	85 c0                	test   %eax,%eax
  1046f3:	78 94                	js     104689 <sys_exec+0x29>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1046f5:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  1046f8:	83 fb 14             	cmp    $0x14,%ebx

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1046fb:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
  1046fd:	74 8a                	je     104689 <sys_exec+0x29>
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
  1046ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  104702:	89 44 24 08          	mov    %eax,0x8(%esp)
  104706:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  10470d:	03 45 e0             	add    -0x20(%ebp),%eax
  104710:	89 44 24 04          	mov    %eax,0x4(%esp)
  104714:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10471a:	89 04 24             	mov    %eax,(%esp)
  10471d:	e8 5e fc ff ff       	call   104380 <fetchint>
  104722:	85 c0                	test   %eax,%eax
  104724:	0f 88 5f ff ff ff    	js     104689 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  10472a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10472d:	85 c0                	test   %eax,%eax
  10472f:	75 a7                	jne    1046d8 <sys_exec+0x78>
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  104731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  104734:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  10473b:	00 
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  10473c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104740:	89 04 24             	mov    %eax,(%esp)
  104743:	e8 c8 c3 ff ff       	call   100b10 <exec>
  104748:	e9 41 ff ff ff       	jmp    10468e <sys_exec+0x2e>
  10474d:	8d 76 00             	lea    0x0(%esi),%esi

00104750 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104750:	55                   	push   %ebp
  104751:	89 e5                	mov    %esp,%ebp
  104753:	53                   	push   %ebx
  104754:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104757:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10475a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10475e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104765:	e8 26 fd ff ff       	call   104490 <argstr>
  10476a:	85 c0                	test   %eax,%eax
  10476c:	79 12                	jns    104780 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  proc->cwd = ip;
  return 0;
  10476e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104773:	83 c4 24             	add    $0x24,%esp
  104776:	5b                   	pop    %ebx
  104777:	5d                   	pop    %ebp
  104778:	c3                   	ret    
  104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104783:	89 04 24             	mov    %eax,(%esp)
  104786:	e8 85 d8 ff ff       	call   102010 <namei>
  10478b:	85 c0                	test   %eax,%eax
  10478d:	89 c3                	mov    %eax,%ebx
  10478f:	74 dd                	je     10476e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104791:	89 04 24             	mov    %eax,(%esp)
  104794:	e8 d7 d5 ff ff       	call   101d70 <ilock>
  if(ip->type != T_DIR){
  104799:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10479e:	75 26                	jne    1047c6 <sys_chdir+0x76>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  1047a0:	89 1c 24             	mov    %ebx,(%esp)
  1047a3:	e8 88 d1 ff ff       	call   101930 <iunlock>
  iput(proc->cwd);
  1047a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1047ae:	8b 40 68             	mov    0x68(%eax),%eax
  1047b1:	89 04 24             	mov    %eax,(%esp)
  1047b4:	e8 87 d2 ff ff       	call   101a40 <iput>
  proc->cwd = ip;
  1047b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1047bf:	89 58 68             	mov    %ebx,0x68(%eax)
  1047c2:	31 c0                	xor    %eax,%eax
  return 0;
  1047c4:	eb ad                	jmp    104773 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  1047c6:	89 1c 24             	mov    %ebx,(%esp)
  1047c9:	e8 b2 d4 ff ff       	call   101c80 <iunlockput>
  1047ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1047d3:	eb 9e                	jmp    104773 <sys_chdir+0x23>
  1047d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001047e0 <create>:
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1047e0:	55                   	push   %ebp
  1047e1:	89 e5                	mov    %esp,%ebp
  1047e3:	83 ec 58             	sub    $0x58,%esp
  1047e6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  1047e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1047ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1047ef:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1047f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1047f5:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1047f7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1047fa:	89 d7                	mov    %edx,%edi
  1047fc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1047ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  104803:	89 04 24             	mov    %eax,(%esp)
  104806:	e8 e5 d7 ff ff       	call   101ff0 <nameiparent>
  10480b:	85 c0                	test   %eax,%eax
  10480d:	74 47                	je     104856 <create+0x76>
    return 0;
  ilock(dp);
  10480f:	89 04 24             	mov    %eax,(%esp)
  104812:	89 45 bc             	mov    %eax,-0x44(%ebp)
  104815:	e8 56 d5 ff ff       	call   101d70 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
  10481a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10481d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104820:	89 44 24 08          	mov    %eax,0x8(%esp)
  104824:	89 74 24 04          	mov    %esi,0x4(%esp)
  104828:	89 14 24             	mov    %edx,(%esp)
  10482b:	e8 00 d0 ff ff       	call   101830 <dirlookup>
  104830:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104833:	85 c0                	test   %eax,%eax
  104835:	89 c3                	mov    %eax,%ebx
  104837:	74 3f                	je     104878 <create+0x98>
    iunlockput(dp);
  104839:	89 14 24             	mov    %edx,(%esp)
  10483c:	e8 3f d4 ff ff       	call   101c80 <iunlockput>
    ilock(ip);
  104841:	89 1c 24             	mov    %ebx,(%esp)
  104844:	e8 27 d5 ff ff       	call   101d70 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
  104849:	66 83 ff 02          	cmp    $0x2,%di
  10484d:	75 19                	jne    104868 <create+0x88>
  10484f:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
  104854:	75 12                	jne    104868 <create+0x88>
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  return ip;
}
  104856:	89 d8                	mov    %ebx,%eax
  104858:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10485b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10485e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104861:	89 ec                	mov    %ebp,%esp
  104863:	5d                   	pop    %ebp
  104864:	c3                   	ret    
  104865:	8d 76 00             	lea    0x0(%esi),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
  104868:	89 1c 24             	mov    %ebx,(%esp)
  10486b:	31 db                	xor    %ebx,%ebx
  10486d:	e8 0e d4 ff ff       	call   101c80 <iunlockput>
    return 0;
  104872:	eb e2                	jmp    104856 <create+0x76>
  104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  104878:	0f bf c7             	movswl %di,%eax
  10487b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10487f:	8b 02                	mov    (%edx),%eax
  104881:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104884:	89 04 24             	mov    %eax,(%esp)
  104887:	e8 14 d4 ff ff       	call   101ca0 <ialloc>
  10488c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10488f:	85 c0                	test   %eax,%eax
  104891:	89 c3                	mov    %eax,%ebx
  104893:	0f 84 b7 00 00 00    	je     104950 <create+0x170>
    panic("create: ialloc");

  ilock(ip);
  104899:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10489c:	89 04 24             	mov    %eax,(%esp)
  10489f:	e8 cc d4 ff ff       	call   101d70 <ilock>
  ip->major = major;
  1048a4:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  1048a8:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  1048ac:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
  1048b0:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  1048b6:	66 89 4b 14          	mov    %cx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  1048ba:	89 1c 24             	mov    %ebx,(%esp)
  1048bd:	e8 6e cd ff ff       	call   101630 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
  1048c2:	66 83 ff 01          	cmp    $0x1,%di
  1048c6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1048c9:	74 2d                	je     1048f8 <create+0x118>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
  1048cb:	8b 43 04             	mov    0x4(%ebx),%eax
  1048ce:	89 14 24             	mov    %edx,(%esp)
  1048d1:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1048d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  1048d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1048dc:	e8 af d2 ff ff       	call   101b90 <dirlink>
  1048e1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1048e4:	85 c0                	test   %eax,%eax
  1048e6:	78 74                	js     10495c <create+0x17c>
    panic("create: dirlink");

  iunlockput(dp);
  1048e8:	89 14 24             	mov    %edx,(%esp)
  1048eb:	e8 90 d3 ff ff       	call   101c80 <iunlockput>
  return ip;
  1048f0:	e9 61 ff ff ff       	jmp    104856 <create+0x76>
  1048f5:	8d 76 00             	lea    0x0(%esi),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1048f8:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  1048fd:	89 14 24             	mov    %edx,(%esp)
  104900:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104903:	e8 28 cd ff ff       	call   101630 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  104908:	8b 43 04             	mov    0x4(%ebx),%eax
  10490b:	c7 44 24 04 b0 71 10 	movl   $0x1071b0,0x4(%esp)
  104912:	00 
  104913:	89 1c 24             	mov    %ebx,(%esp)
  104916:	89 44 24 08          	mov    %eax,0x8(%esp)
  10491a:	e8 71 d2 ff ff       	call   101b90 <dirlink>
  10491f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104922:	85 c0                	test   %eax,%eax
  104924:	78 1e                	js     104944 <create+0x164>
  104926:	8b 42 04             	mov    0x4(%edx),%eax
  104929:	c7 44 24 04 af 71 10 	movl   $0x1071af,0x4(%esp)
  104930:	00 
  104931:	89 1c 24             	mov    %ebx,(%esp)
  104934:	89 44 24 08          	mov    %eax,0x8(%esp)
  104938:	e8 53 d2 ff ff       	call   101b90 <dirlink>
  10493d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104940:	85 c0                	test   %eax,%eax
  104942:	79 87                	jns    1048cb <create+0xeb>
      panic("create dots");
  104944:	c7 04 24 b2 71 10 00 	movl   $0x1071b2,(%esp)
  10494b:	e8 40 c1 ff ff       	call   100a90 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
  104950:	c7 04 24 a0 71 10 00 	movl   $0x1071a0,(%esp)
  104957:	e8 34 c1 ff ff       	call   100a90 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
  10495c:	c7 04 24 be 71 10 00 	movl   $0x1071be,(%esp)
  104963:	e8 28 c1 ff ff       	call   100a90 <panic>
  104968:	90                   	nop
  104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104970 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
  104970:	55                   	push   %ebp
  104971:	89 e5                	mov    %esp,%ebp
  104973:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104976:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104979:	89 44 24 04          	mov    %eax,0x4(%esp)
  10497d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104984:	e8 07 fb ff ff       	call   104490 <argstr>
  104989:	85 c0                	test   %eax,%eax
  10498b:	79 0b                	jns    104998 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10498d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104992:	c9                   	leave  
  104993:	c3                   	ret    
  104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  104998:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10499b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10499f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049a6:	e8 55 fa ff ff       	call   104400 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1049ab:	85 c0                	test   %eax,%eax
  1049ad:	78 de                	js     10498d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  1049af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1049b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1049bd:	e8 3e fa ff ff       	call   104400 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1049c2:	85 c0                	test   %eax,%eax
  1049c4:	78 c7                	js     10498d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
  1049c6:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  1049ca:	ba 03 00 00 00       	mov    $0x3,%edx
  1049cf:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
  1049d3:	89 04 24             	mov    %eax,(%esp)
  1049d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d9:	e8 02 fe ff ff       	call   1047e0 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  1049de:	85 c0                	test   %eax,%eax
  1049e0:	74 ab                	je     10498d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  1049e2:	89 04 24             	mov    %eax,(%esp)
  1049e5:	e8 96 d2 ff ff       	call   101c80 <iunlockput>
  1049ea:	31 c0                	xor    %eax,%eax
  return 0;
}
  1049ec:	c9                   	leave  
  1049ed:	c3                   	ret    
  1049ee:	66 90                	xchg   %ax,%ax

001049f0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
  1049f0:	55                   	push   %ebp
  1049f1:	89 e5                	mov    %esp,%ebp
  1049f3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  1049f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1049f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1049fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a04:	e8 87 fa ff ff       	call   104490 <argstr>
  104a09:	85 c0                	test   %eax,%eax
  104a0b:	79 0b                	jns    104a18 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  104a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104a12:	c9                   	leave  
  104a13:	c3                   	ret    
  104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  104a18:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a22:	31 c9                	xor    %ecx,%ecx
  104a24:	ba 01 00 00 00       	mov    $0x1,%edx
  104a29:	e8 b2 fd ff ff       	call   1047e0 <create>
  104a2e:	85 c0                	test   %eax,%eax
  104a30:	74 db                	je     104a0d <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  104a32:	89 04 24             	mov    %eax,(%esp)
  104a35:	e8 46 d2 ff ff       	call   101c80 <iunlockput>
  104a3a:	31 c0                	xor    %eax,%eax
  return 0;
}
  104a3c:	c9                   	leave  
  104a3d:	c3                   	ret    
  104a3e:	66 90                	xchg   %ax,%ax

00104a40 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104a40:	55                   	push   %ebp
  104a41:	89 e5                	mov    %esp,%ebp
  104a43:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104a46:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  104a49:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104a4c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104a4f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a5d:	e8 2e fa ff ff       	call   104490 <argstr>
  104a62:	85 c0                	test   %eax,%eax
  104a64:	79 12                	jns    104a78 <sys_link+0x38>
bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104a66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104a6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104a6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104a71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104a74:	89 ec                	mov    %ebp,%esp
  104a76:	5d                   	pop    %ebp
  104a77:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104a78:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  104a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a86:	e8 05 fa ff ff       	call   104490 <argstr>
  104a8b:	85 c0                	test   %eax,%eax
  104a8d:	78 d7                	js     104a66 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  104a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a92:	89 04 24             	mov    %eax,(%esp)
  104a95:	e8 76 d5 ff ff       	call   102010 <namei>
  104a9a:	85 c0                	test   %eax,%eax
  104a9c:	89 c3                	mov    %eax,%ebx
  104a9e:	74 c6                	je     104a66 <sys_link+0x26>
    return -1;
  ilock(ip);
  104aa0:	89 04 24             	mov    %eax,(%esp)
  104aa3:	e8 c8 d2 ff ff       	call   101d70 <ilock>
  if(ip->type == T_DIR){
  104aa8:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104aad:	0f 84 86 00 00 00    	je     104b39 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104ab3:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104ab8:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  104abb:	89 1c 24             	mov    %ebx,(%esp)
  104abe:	e8 6d cb ff ff       	call   101630 <iupdate>
  iunlock(ip);
  104ac3:	89 1c 24             	mov    %ebx,(%esp)
  104ac6:	e8 65 ce ff ff       	call   101930 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  104acb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ace:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104ad2:	89 04 24             	mov    %eax,(%esp)
  104ad5:	e8 16 d5 ff ff       	call   101ff0 <nameiparent>
  104ada:	85 c0                	test   %eax,%eax
  104adc:	89 c6                	mov    %eax,%esi
  104ade:	74 44                	je     104b24 <sys_link+0xe4>
    goto bad;
  ilock(dp);
  104ae0:	89 04 24             	mov    %eax,(%esp)
  104ae3:	e8 88 d2 ff ff       	call   101d70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  104ae8:	8b 06                	mov    (%esi),%eax
  104aea:	3b 03                	cmp    (%ebx),%eax
  104aec:	75 2e                	jne    104b1c <sys_link+0xdc>
  104aee:	8b 43 04             	mov    0x4(%ebx),%eax
  104af1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104af5:	89 34 24             	mov    %esi,(%esp)
  104af8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104afc:	e8 8f d0 ff ff       	call   101b90 <dirlink>
  104b01:	85 c0                	test   %eax,%eax
  104b03:	78 17                	js     104b1c <sys_link+0xdc>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  104b05:	89 34 24             	mov    %esi,(%esp)
  104b08:	e8 73 d1 ff ff       	call   101c80 <iunlockput>
  iput(ip);
  104b0d:	89 1c 24             	mov    %ebx,(%esp)
  104b10:	e8 2b cf ff ff       	call   101a40 <iput>
  104b15:	31 c0                	xor    %eax,%eax
  return 0;
  104b17:	e9 4f ff ff ff       	jmp    104a6b <sys_link+0x2b>

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
  104b1c:	89 34 24             	mov    %esi,(%esp)
  104b1f:	e8 5c d1 ff ff       	call   101c80 <iunlockput>
  iunlockput(dp);
  iput(ip);
  return 0;

bad:
  ilock(ip);
  104b24:	89 1c 24             	mov    %ebx,(%esp)
  104b27:	e8 44 d2 ff ff       	call   101d70 <ilock>
  ip->nlink--;
  104b2c:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  104b31:	89 1c 24             	mov    %ebx,(%esp)
  104b34:	e8 f7 ca ff ff       	call   101630 <iupdate>
  iunlockput(ip);
  104b39:	89 1c 24             	mov    %ebx,(%esp)
  104b3c:	e8 3f d1 ff ff       	call   101c80 <iunlockput>
  104b41:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  104b44:	e9 22 ff ff ff       	jmp    104a6b <sys_link+0x2b>
  104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104b50 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104b50:	55                   	push   %ebp
  104b51:	89 e5                	mov    %esp,%ebp
  104b53:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104b59:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104b5c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b6a:	e8 21 f9 ff ff       	call   104490 <argstr>
  104b6f:	85 c0                	test   %eax,%eax
  104b71:	79 15                	jns    104b88 <sys_open+0x38>

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  104b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
  104b78:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104b7b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104b7e:	89 ec                	mov    %ebp,%esp
  104b80:	5d                   	pop    %ebp
  104b81:	c3                   	ret    
  104b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104b88:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b96:	e8 65 f8 ff ff       	call   104400 <argint>
  104b9b:	85 c0                	test   %eax,%eax
  104b9d:	78 d4                	js     104b73 <sys_open+0x23>
    return -1;
  if(omode & O_CREATE){
  104b9f:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  104ba3:	74 63                	je     104c08 <sys_open+0xb8>
    if((ip = create(path, T_FILE, 0, 0)) == 0)
  104ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ba8:	31 c9                	xor    %ecx,%ecx
  104baa:	ba 02 00 00 00       	mov    $0x2,%edx
  104baf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104bb6:	e8 25 fc ff ff       	call   1047e0 <create>
  104bbb:	85 c0                	test   %eax,%eax
  104bbd:	89 c3                	mov    %eax,%ebx
  104bbf:	74 b2                	je     104b73 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104bc1:	e8 fa c4 ff ff       	call   1010c0 <filealloc>
  104bc6:	85 c0                	test   %eax,%eax
  104bc8:	89 c6                	mov    %eax,%esi
  104bca:	74 24                	je     104bf0 <sys_open+0xa0>
  104bcc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104bd3:	31 c0                	xor    %eax,%eax
  104bd5:	8d 76 00             	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104bd8:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
  104bdc:	85 c9                	test   %ecx,%ecx
  104bde:	74 58                	je     104c38 <sys_open+0xe8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104be0:	83 c0 01             	add    $0x1,%eax
  104be3:	83 f8 10             	cmp    $0x10,%eax
  104be6:	75 f0                	jne    104bd8 <sys_open+0x88>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104be8:	89 34 24             	mov    %esi,(%esp)
  104beb:	e8 50 c5 ff ff       	call   101140 <fileclose>
    iunlockput(ip);
  104bf0:	89 1c 24             	mov    %ebx,(%esp)
  104bf3:	e8 88 d0 ff ff       	call   101c80 <iunlockput>
  104bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104bfd:	e9 76 ff ff ff       	jmp    104b78 <sys_open+0x28>
  104c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(omode & O_CREATE){
    if((ip = create(path, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c0b:	89 04 24             	mov    %eax,(%esp)
  104c0e:	e8 fd d3 ff ff       	call   102010 <namei>
  104c13:	85 c0                	test   %eax,%eax
  104c15:	89 c3                	mov    %eax,%ebx
  104c17:	0f 84 56 ff ff ff    	je     104b73 <sys_open+0x23>
      return -1;
    ilock(ip);
  104c1d:	89 04 24             	mov    %eax,(%esp)
  104c20:	e8 4b d1 ff ff       	call   101d70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
  104c25:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104c2a:	75 95                	jne    104bc1 <sys_open+0x71>
  104c2c:	8b 75 f0             	mov    -0x10(%ebp),%esi
  104c2f:	85 f6                	test   %esi,%esi
  104c31:	74 8e                	je     104bc1 <sys_open+0x71>
  104c33:	eb bb                	jmp    104bf0 <sys_open+0xa0>
  104c35:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104c38:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104c3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104c3f:	89 1c 24             	mov    %ebx,(%esp)
  104c42:	e8 e9 cc ff ff       	call   101930 <iunlock>

  f->type = FD_INODE;
  104c47:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  104c4d:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
  104c50:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  104c57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104c5a:	83 f2 01             	xor    $0x1,%edx
  104c5d:	83 e2 01             	and    $0x1,%edx
  104c60:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104c63:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  104c67:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
  104c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c6e:	e9 05 ff ff ff       	jmp    104b78 <sys_open+0x28>
  104c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104c80 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104c80:	55                   	push   %ebp
  104c81:	89 e5                	mov    %esp,%ebp
  104c83:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104c86:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104c89:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104c8c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104c8f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  104c96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104c9d:	e8 ee f7 ff ff       	call   104490 <argstr>
  104ca2:	85 c0                	test   %eax,%eax
  104ca4:	79 12                	jns    104cb8 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104cab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104cae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104cb1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104cb4:	89 ec                	mov    %ebp,%esp
  104cb6:	5d                   	pop    %ebp
  104cb7:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cbb:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  104cbe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104cc2:	89 04 24             	mov    %eax,(%esp)
  104cc5:	e8 26 d3 ff ff       	call   101ff0 <nameiparent>
  104cca:	85 c0                	test   %eax,%eax
  104ccc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104ccf:	74 d5                	je     104ca6 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104cd1:	89 04 24             	mov    %eax,(%esp)
  104cd4:	e8 97 d0 ff ff       	call   101d70 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104cd9:	c7 44 24 04 b0 71 10 	movl   $0x1071b0,0x4(%esp)
  104ce0:	00 
  104ce1:	89 1c 24             	mov    %ebx,(%esp)
  104ce4:	e8 17 cb ff ff       	call   101800 <namecmp>
  104ce9:	85 c0                	test   %eax,%eax
  104ceb:	0f 84 a4 00 00 00    	je     104d95 <sys_unlink+0x115>
  104cf1:	c7 44 24 04 af 71 10 	movl   $0x1071af,0x4(%esp)
  104cf8:	00 
  104cf9:	89 1c 24             	mov    %ebx,(%esp)
  104cfc:	e8 ff ca ff ff       	call   101800 <namecmp>
  104d01:	85 c0                	test   %eax,%eax
  104d03:	0f 84 8c 00 00 00    	je     104d95 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104d09:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104d10:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104d17:	89 04 24             	mov    %eax,(%esp)
  104d1a:	e8 11 cb ff ff       	call   101830 <dirlookup>
  104d1f:	85 c0                	test   %eax,%eax
  104d21:	89 c6                	mov    %eax,%esi
  104d23:	74 70                	je     104d95 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104d25:	89 04 24             	mov    %eax,(%esp)
  104d28:	e8 43 d0 ff ff       	call   101d70 <ilock>

  if(ip->nlink < 1)
  104d2d:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104d32:	0f 8e 0e 01 00 00    	jle    104e46 <sys_unlink+0x1c6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104d38:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104d3d:	75 71                	jne    104db0 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104d3f:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104d43:	76 6b                	jbe    104db0 <sys_unlink+0x130>
  104d45:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  104d48:	bb 20 00 00 00       	mov    $0x20,%ebx
  104d4d:	8d 76 00             	lea    0x0(%esi),%esi
  104d50:	eb 0e                	jmp    104d60 <sys_unlink+0xe0>
  104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104d58:	83 c3 10             	add    $0x10,%ebx
  104d5b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  104d5e:	73 50                	jae    104db0 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104d60:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104d67:	00 
  104d68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104d6c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104d70:	89 34 24             	mov    %esi,(%esp)
  104d73:	e8 b8 c7 ff ff       	call   101530 <readi>
  104d78:	83 f8 10             	cmp    $0x10,%eax
  104d7b:	0f 85 ad 00 00 00    	jne    104e2e <sys_unlink+0x1ae>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104d81:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  104d86:	74 d0                	je     104d58 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104d88:	89 34 24             	mov    %esi,(%esp)
  104d8b:	90                   	nop
  104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104d90:	e8 eb ce ff ff       	call   101c80 <iunlockput>
    iunlockput(dp);
  104d95:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104d98:	89 04 24             	mov    %eax,(%esp)
  104d9b:	e8 e0 ce ff ff       	call   101c80 <iunlockput>
  104da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104da5:	e9 01 ff ff ff       	jmp    104cab <sys_unlink+0x2b>
  104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  104db0:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  104db3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104dba:	00 
  104dbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104dc2:	00 
  104dc3:	89 1c 24             	mov    %ebx,(%esp)
  104dc6:	e8 95 f3 ff ff       	call   104160 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104dcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104dce:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104dd5:	00 
  104dd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104dda:	89 44 24 08          	mov    %eax,0x8(%esp)
  104dde:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104de1:	89 04 24             	mov    %eax,(%esp)
  104de4:	e8 d7 c8 ff ff       	call   1016c0 <writei>
  104de9:	83 f8 10             	cmp    $0x10,%eax
  104dec:	75 4c                	jne    104e3a <sys_unlink+0x1ba>
    panic("unlink: writei");
  if(ip->type == T_DIR){
  104dee:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104df3:	74 27                	je     104e1c <sys_unlink+0x19c>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
  104df5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104df8:	89 04 24             	mov    %eax,(%esp)
  104dfb:	e8 80 ce ff ff       	call   101c80 <iunlockput>

  ip->nlink--;
  104e00:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104e05:	89 34 24             	mov    %esi,(%esp)
  104e08:	e8 23 c8 ff ff       	call   101630 <iupdate>
  iunlockput(ip);
  104e0d:	89 34 24             	mov    %esi,(%esp)
  104e10:	e8 6b ce ff ff       	call   101c80 <iunlockput>
  104e15:	31 c0                	xor    %eax,%eax
  return 0;
  104e17:	e9 8f fe ff ff       	jmp    104cab <sys_unlink+0x2b>

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
  104e1c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104e1f:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
  104e24:	89 04 24             	mov    %eax,(%esp)
  104e27:	e8 04 c8 ff ff       	call   101630 <iupdate>
  104e2c:	eb c7                	jmp    104df5 <sys_unlink+0x175>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104e2e:	c7 04 24 e0 71 10 00 	movl   $0x1071e0,(%esp)
  104e35:	e8 56 bc ff ff       	call   100a90 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104e3a:	c7 04 24 f2 71 10 00 	movl   $0x1071f2,(%esp)
  104e41:	e8 4a bc ff ff       	call   100a90 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104e46:	c7 04 24 ce 71 10 00 	movl   $0x1071ce,(%esp)
  104e4d:	e8 3e bc ff ff       	call   100a90 <panic>
  104e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104e60 <T.67>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104e60:	55                   	push   %ebp
  104e61:	89 e5                	mov    %esp,%ebp
  104e63:	83 ec 28             	sub    $0x28,%esp
  104e66:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104e69:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104e6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104e6e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104e71:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104e7e:	e8 7d f5 ff ff       	call   104400 <argint>
  104e83:	85 c0                	test   %eax,%eax
  104e85:	79 11                	jns    104e98 <T.67+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104e87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104e8c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104e8f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104e92:	89 ec                	mov    %ebp,%esp
  104e94:	5d                   	pop    %ebp
  104e95:	c3                   	ret    
  104e96:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
  104e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e9b:	83 f8 0f             	cmp    $0xf,%eax
  104e9e:	77 e7                	ja     104e87 <T.67+0x27>
  104ea0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104ea7:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
  104eab:	85 d2                	test   %edx,%edx
  104ead:	74 d8                	je     104e87 <T.67+0x27>
    return -1;
  if(pfd)
  104eaf:	85 db                	test   %ebx,%ebx
  104eb1:	74 02                	je     104eb5 <T.67+0x55>
    *pfd = fd;
  104eb3:	89 03                	mov    %eax,(%ebx)
  if(pf)
  104eb5:	31 c0                	xor    %eax,%eax
  104eb7:	85 f6                	test   %esi,%esi
  104eb9:	74 d1                	je     104e8c <T.67+0x2c>
    *pf = f;
  104ebb:	89 16                	mov    %edx,(%esi)
  104ebd:	eb cd                	jmp    104e8c <T.67+0x2c>
  104ebf:	90                   	nop

00104ec0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
  104ec0:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104ec1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
  104ec3:	89 e5                	mov    %esp,%ebp
  104ec5:	53                   	push   %ebx
  104ec6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104ec9:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104ecc:	e8 8f ff ff ff       	call   104e60 <T.67>
  104ed1:	85 c0                	test   %eax,%eax
  104ed3:	79 13                	jns    104ee8 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104ed5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
  104eda:	89 d8                	mov    %ebx,%eax
  104edc:	83 c4 24             	add    $0x24,%esp
  104edf:	5b                   	pop    %ebx
  104ee0:	5d                   	pop    %ebp
  104ee1:	c3                   	ret    
  104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  104ee8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104eeb:	31 db                	xor    %ebx,%ebx
  104eed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104ef3:	eb 0b                	jmp    104f00 <sys_dup+0x40>
  104ef5:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104ef8:	83 c3 01             	add    $0x1,%ebx
  104efb:	83 fb 10             	cmp    $0x10,%ebx
  104efe:	74 d5                	je     104ed5 <sys_dup+0x15>
    if(proc->ofile[fd] == 0){
  104f00:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
  104f04:	85 c9                	test   %ecx,%ecx
  104f06:	75 f0                	jne    104ef8 <sys_dup+0x38>
      proc->ofile[fd] = f;
  104f08:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  104f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f0f:	89 04 24             	mov    %eax,(%esp)
  104f12:	e8 59 c1 ff ff       	call   101070 <filedup>
  return fd;
  104f17:	eb c1                	jmp    104eda <sys_dup+0x1a>
  104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104f20 <sys_read>:
}

int
sys_read(void)
{
  104f20:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104f21:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
  104f23:	89 e5                	mov    %esp,%ebp
  104f25:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104f28:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104f2b:	e8 30 ff ff ff       	call   104e60 <T.67>
  104f30:	85 c0                	test   %eax,%eax
  104f32:	79 0c                	jns    104f40 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  104f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104f39:	c9                   	leave  
  104f3a:	c3                   	ret    
  104f3b:	90                   	nop
  104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104f40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f47:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104f4e:	e8 ad f4 ff ff       	call   104400 <argint>
  104f53:	85 c0                	test   %eax,%eax
  104f55:	78 dd                	js     104f34 <sys_read+0x14>
  104f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f61:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f6c:	e8 cf f4 ff ff       	call   104440 <argptr>
  104f71:	85 c0                	test   %eax,%eax
  104f73:	78 bf                	js     104f34 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  104f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f78:	89 44 24 08          	mov    %eax,0x8(%esp)
  104f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f86:	89 04 24             	mov    %eax,(%esp)
  104f89:	e8 e2 bf ff ff       	call   100f70 <fileread>
}
  104f8e:	c9                   	leave  
  104f8f:	c3                   	ret    

00104f90 <sys_write>:

int
sys_write(void)
{
  104f90:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104f91:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104f93:	89 e5                	mov    %esp,%ebp
  104f95:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104f98:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104f9b:	e8 c0 fe ff ff       	call   104e60 <T.67>
  104fa0:	85 c0                	test   %eax,%eax
  104fa2:	79 0c                	jns    104fb0 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  104fa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104fa9:	c9                   	leave  
  104faa:	c3                   	ret    
  104fab:	90                   	nop
  104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104fb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fb7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104fbe:	e8 3d f4 ff ff       	call   104400 <argint>
  104fc3:	85 c0                	test   %eax,%eax
  104fc5:	78 dd                	js     104fa4 <sys_write+0x14>
  104fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  104fd5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  104fdc:	e8 5f f4 ff ff       	call   104440 <argptr>
  104fe1:	85 c0                	test   %eax,%eax
  104fe3:	78 bf                	js     104fa4 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  104fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fe8:	89 44 24 08          	mov    %eax,0x8(%esp)
  104fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fef:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ff6:	89 04 24             	mov    %eax,(%esp)
  104ff9:	e8 c2 be ff ff       	call   100ec0 <filewrite>
}
  104ffe:	c9                   	leave  
  104fff:	c3                   	ret    

00105000 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  105000:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105001:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  105003:	89 e5                	mov    %esp,%ebp
  105005:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105008:	8d 55 f4             	lea    -0xc(%ebp),%edx
  10500b:	e8 50 fe ff ff       	call   104e60 <T.67>
  105010:	85 c0                	test   %eax,%eax
  105012:	79 0c                	jns    105020 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  105014:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105019:	c9                   	leave  
  10501a:	c3                   	ret    
  10501b:	90                   	nop
  10501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  105020:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105023:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  10502a:	00 
  10502b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10502f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105036:	e8 05 f4 ff ff       	call   104440 <argptr>
  10503b:	85 c0                	test   %eax,%eax
  10503d:	78 d5                	js     105014 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  10503f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105042:	89 44 24 04          	mov    %eax,0x4(%esp)
  105046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105049:	89 04 24             	mov    %eax,(%esp)
  10504c:	e8 cf bf ff ff       	call   101020 <filestat>
}
  105051:	c9                   	leave  
  105052:	c3                   	ret    
  105053:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105060 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  105060:	55                   	push   %ebp
  105061:	89 e5                	mov    %esp,%ebp
  105063:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  105066:	8d 55 f0             	lea    -0x10(%ebp),%edx
  105069:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10506c:	e8 ef fd ff ff       	call   104e60 <T.67>
  105071:	89 c2                	mov    %eax,%edx
  105073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105078:	85 d2                	test   %edx,%edx
  10507a:	78 1e                	js     10509a <sys_close+0x3a>
    return -1;
  proc->ofile[fd] = 0;
  10507c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105082:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105085:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
  10508c:	00 
  fileclose(f);
  10508d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105090:	89 04 24             	mov    %eax,(%esp)
  105093:	e8 a8 c0 ff ff       	call   101140 <fileclose>
  105098:	31 c0                	xor    %eax,%eax
  return 0;
}
  10509a:	c9                   	leave  
  10509b:	c3                   	ret    
  10509c:	90                   	nop
  10509d:	90                   	nop
  10509e:	90                   	nop
  10509f:	90                   	nop

001050a0 <sys_getpid>:
}

int
sys_getpid(void)
{
  return proc->pid;
  1050a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
  1050a6:	55                   	push   %ebp
  1050a7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
  1050a9:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
  1050aa:	8b 40 10             	mov    0x10(%eax),%eax
}
  1050ad:	c3                   	ret    
  1050ae:	66 90                	xchg   %ax,%ax

001050b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since boot.
int
sys_uptime(void)
{
  1050b0:	55                   	push   %ebp
  1050b1:	89 e5                	mov    %esp,%ebp
  1050b3:	53                   	push   %ebx
  1050b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;
  
  acquire(&tickslock);
  1050b7:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  1050be:	e8 fd ef ff ff       	call   1040c0 <acquire>
  xticks = ticks;
  1050c3:	8b 1d a0 f6 10 00    	mov    0x10f6a0,%ebx
  release(&tickslock);
  1050c9:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  1050d0:	e8 9b ef ff ff       	call   104070 <release>
  return xticks;
}
  1050d5:	83 c4 14             	add    $0x14,%esp
  1050d8:	89 d8                	mov    %ebx,%eax
  1050da:	5b                   	pop    %ebx
  1050db:	5d                   	pop    %ebp
  1050dc:	c3                   	ret    
  1050dd:	8d 76 00             	lea    0x0(%esi),%esi

001050e0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  1050e0:	55                   	push   %ebp
  1050e1:	89 e5                	mov    %esp,%ebp
  1050e3:	53                   	push   %ebx
  1050e4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
  1050e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1050ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050f5:	e8 06 f3 ff ff       	call   104400 <argint>
  1050fa:	89 c2                	mov    %eax,%edx
  1050fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  105101:	85 d2                	test   %edx,%edx
  105103:	78 59                	js     10515e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
  105105:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  10510c:	e8 af ef ff ff       	call   1040c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  105114:	8b 1d a0 f6 10 00    	mov    0x10f6a0,%ebx
  while(ticks - ticks0 < n){
  10511a:	85 d2                	test   %edx,%edx
  10511c:	75 22                	jne    105140 <sys_sleep+0x60>
  10511e:	eb 48                	jmp    105168 <sys_sleep+0x88>
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  105120:	c7 44 24 04 60 ee 10 	movl   $0x10ee60,0x4(%esp)
  105127:	00 
  105128:	c7 04 24 a0 f6 10 00 	movl   $0x10f6a0,(%esp)
  10512f:	e8 cc e2 ff ff       	call   103400 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  105134:	a1 a0 f6 10 00       	mov    0x10f6a0,%eax
  105139:	29 d8                	sub    %ebx,%eax
  10513b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10513e:	73 28                	jae    105168 <sys_sleep+0x88>
    if(proc->killed){
  105140:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105146:	8b 40 24             	mov    0x24(%eax),%eax
  105149:	85 c0                	test   %eax,%eax
  10514b:	74 d3                	je     105120 <sys_sleep+0x40>
      release(&tickslock);
  10514d:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  105154:	e8 17 ef ff ff       	call   104070 <release>
  105159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10515e:	83 c4 24             	add    $0x24,%esp
  105161:	5b                   	pop    %ebx
  105162:	5d                   	pop    %ebp
  105163:	c3                   	ret    
  105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105168:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  10516f:	e8 fc ee ff ff       	call   104070 <release>
  return 0;
}
  105174:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105177:	31 c0                	xor    %eax,%eax
  return 0;
}
  105179:	5b                   	pop    %ebx
  10517a:	5d                   	pop    %ebp
  10517b:	c3                   	ret    
  10517c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105180 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
  105180:	55                   	push   %ebp
  105181:	89 e5                	mov    %esp,%ebp
  105183:	53                   	push   %ebx
  105184:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105187:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10518a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10518e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105195:	e8 66 f2 ff ff       	call   104400 <argint>
  10519a:	85 c0                	test   %eax,%eax
  10519c:	79 12                	jns    1051b0 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
  10519e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1051a3:	83 c4 24             	add    $0x24,%esp
  1051a6:	5b                   	pop    %ebx
  1051a7:	5d                   	pop    %ebp
  1051a8:	c3                   	ret    
  1051a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  1051b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1051b6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
  1051b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051bb:	89 04 24             	mov    %eax,(%esp)
  1051be:	e8 0d eb ff ff       	call   103cd0 <growproc>
  1051c3:	89 c2                	mov    %eax,%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  1051c5:	89 d8                	mov    %ebx,%eax
  if(growproc(n) < 0)
  1051c7:	85 d2                	test   %edx,%edx
  1051c9:	79 d8                	jns    1051a3 <sys_sbrk+0x23>
  1051cb:	eb d1                	jmp    10519e <sys_sbrk+0x1e>
  1051cd:	8d 76 00             	lea    0x0(%esi),%esi

001051d0 <sys_kill>:
  return nice();
}

int
sys_kill(void)
{
  1051d0:	55                   	push   %ebp
  1051d1:	89 e5                	mov    %esp,%ebp
  1051d3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  1051d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1051d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1051e4:	e8 17 f2 ff ff       	call   104400 <argint>
  1051e9:	89 c2                	mov    %eax,%edx
  1051eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1051f0:	85 d2                	test   %edx,%edx
  1051f2:	78 0b                	js     1051ff <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1051f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1051f7:	89 04 24             	mov    %eax,(%esp)
  1051fa:	e8 11 e0 ff ff       	call   103210 <kill>
}
  1051ff:	c9                   	leave  
  105200:	c3                   	ret    
  105201:	eb 0d                	jmp    105210 <sys_nice>
  105203:	90                   	nop
  105204:	90                   	nop
  105205:	90                   	nop
  105206:	90                   	nop
  105207:	90                   	nop
  105208:	90                   	nop
  105209:	90                   	nop
  10520a:	90                   	nop
  10520b:	90                   	nop
  10520c:	90                   	nop
  10520d:	90                   	nop
  10520e:	90                   	nop
  10520f:	90                   	nop

00105210 <sys_nice>:
  return ans;
}

int
sys_nice(void)
{ 
  105210:	55                   	push   %ebp
  105211:	89 e5                	mov    %esp,%ebp
  105213:	83 ec 08             	sub    $0x8,%esp
  return nice();
}
  105216:	c9                   	leave  
}

int
sys_nice(void)
{ 
  return nice();
  105217:	e9 84 df ff ff       	jmp    1031a0 <nice>
  10521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105220 <sys_wait2>:
  return wait();
}

int
sys_wait2(void)
{ 
  105220:	55                   	push   %ebp
  105221:	89 e5                	mov    %esp,%ebp
  105223:	83 ec 28             	sub    $0x28,%esp
  int ans;
  int wt = 0;
  int rt = 0;
  if(argint(0, &wt) < 0)
  105226:	8d 45 f4             	lea    -0xc(%ebp),%eax

int
sys_wait2(void)
{ 
  int ans;
  int wt = 0;
  105229:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int rt = 0;
  105230:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(argint(0, &wt) < 0)
  105237:	89 44 24 04          	mov    %eax,0x4(%esp)
  10523b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105242:	e8 b9 f1 ff ff       	call   104400 <argint>
  105247:	85 c0                	test   %eax,%eax
  105249:	79 0d                	jns    105258 <sys_wait2+0x38>
    return -1;
  if(argint(1, &rt) < 0)
    return -1;
  ans = wait2((int*)wt, (int*)rt);
  return ans;
  10524b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105250:	c9                   	leave  
  105251:	c3                   	ret    
  105252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int ans;
  int wt = 0;
  int rt = 0;
  if(argint(0, &wt) < 0)
    return -1;
  if(argint(1, &rt) < 0)
  105258:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10525b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10525f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105266:	e8 95 f1 ff ff       	call   104400 <argint>
  10526b:	85 c0                	test   %eax,%eax
  10526d:	78 dc                	js     10524b <sys_wait2+0x2b>
    return -1;
  ans = wait2((int*)wt, (int*)rt);
  10526f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105272:	89 44 24 04          	mov    %eax,0x4(%esp)
  105276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105279:	89 04 24             	mov    %eax,(%esp)
  10527c:	e8 9f e4 ff ff       	call   103720 <wait2>
  return ans;
}
  105281:	c9                   	leave  
  105282:	c3                   	ret    
  105283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00105290 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  105290:	55                   	push   %ebp
  105291:	89 e5                	mov    %esp,%ebp
  105293:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105296:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105297:	e9 c4 e5 ff ff       	jmp    103860 <wait>
  10529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001052a0 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
  1052a0:	55                   	push   %ebp
  1052a1:	89 e5                	mov    %esp,%ebp
  1052a3:	83 ec 08             	sub    $0x8,%esp
  exit();
  1052a6:	e8 d5 e6 ff ff       	call   103980 <exit>
  return 0;  // not reached
}
  1052ab:	31 c0                	xor    %eax,%eax
  1052ad:	c9                   	leave  
  1052ae:	c3                   	ret    
  1052af:	90                   	nop

001052b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  1052b0:	55                   	push   %ebp
  1052b1:	89 e5                	mov    %esp,%ebp
  1052b3:	83 ec 08             	sub    $0x8,%esp
  return fork();
}
  1052b6:	c9                   	leave  
#include "proc.h"

int
sys_fork(void)
{
  return fork();
  1052b7:	e9 14 e9 ff ff       	jmp    103bd0 <fork>
  1052bc:	90                   	nop
  1052bd:	90                   	nop
  1052be:	90                   	nop
  1052bf:	90                   	nop

001052c0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
  1052c0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1052c1:	ba 43 00 00 00       	mov    $0x43,%edx
  1052c6:	89 e5                	mov    %esp,%ebp
  1052c8:	83 ec 18             	sub    $0x18,%esp
  1052cb:	b8 34 00 00 00       	mov    $0x34,%eax
  1052d0:	ee                   	out    %al,(%dx)
  1052d1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  1052d6:	b2 40                	mov    $0x40,%dl
  1052d8:	ee                   	out    %al,(%dx)
  1052d9:	b8 2e 00 00 00       	mov    $0x2e,%eax
  1052de:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
  1052df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052e6:	e8 75 da ff ff       	call   102d60 <picenable>
}
  1052eb:	c9                   	leave  
  1052ec:	c3                   	ret    
  1052ed:	90                   	nop
  1052ee:	90                   	nop
  1052ef:	90                   	nop

001052f0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  1052f0:	1e                   	push   %ds
  pushl %es
  1052f1:	06                   	push   %es
  pushl %fs
  1052f2:	0f a0                	push   %fs
  pushl %gs
  1052f4:	0f a8                	push   %gs
  pushal
  1052f6:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
  1052f7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
  1052fb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
  1052fd:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
  1052ff:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
  105303:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
  105305:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
  105307:	54                   	push   %esp
  call trap
  105308:	e8 43 00 00 00       	call   105350 <trap>
  addl $4, %esp
  10530d:	83 c4 04             	add    $0x4,%esp

00105310 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  105310:	61                   	popa   
  popl %gs
  105311:	0f a9                	pop    %gs
  popl %fs
  105313:	0f a1                	pop    %fs
  popl %es
  105315:	07                   	pop    %es
  popl %ds
  105316:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
  105317:	83 c4 08             	add    $0x8,%esp
  iret
  10531a:	cf                   	iret   
  10531b:	90                   	nop
  10531c:	90                   	nop
  10531d:	90                   	nop
  10531e:	90                   	nop
  10531f:	90                   	nop

00105320 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105320:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105321:	b8 a0 ee 10 00       	mov    $0x10eea0,%eax
  105326:	89 e5                	mov    %esp,%ebp
  105328:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10532b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  105331:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  105335:	c1 e8 10             	shr    $0x10,%eax
  105338:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  10533c:	8d 45 fa             	lea    -0x6(%ebp),%eax
  10533f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  105342:	c9                   	leave  
  105343:	c3                   	ret    
  105344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10534a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105350 <trap>:

void
trap(struct trapframe *tf)
{
  105350:	55                   	push   %ebp
  105351:	89 e5                	mov    %esp,%ebp
  105353:	56                   	push   %esi
  105354:	53                   	push   %ebx
  105355:	83 ec 20             	sub    $0x20,%esp
  105358:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
  10535b:	8b 43 30             	mov    0x30(%ebx),%eax
  10535e:	83 f8 40             	cmp    $0x40,%eax
  105361:	0f 84 c9 00 00 00    	je     105430 <trap+0xe0>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105367:	8d 50 e0             	lea    -0x20(%eax),%edx
  10536a:	83 fa 1f             	cmp    $0x1f,%edx
  10536d:	0f 86 b5 00 00 00    	jbe    105428 <trap+0xd8>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
  105373:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  10537a:	85 d2                	test   %edx,%edx
  10537c:	0f 84 64 02 00 00    	je     1055e6 <trap+0x296>
  105382:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
  105386:	0f 84 5a 02 00 00    	je     1055e6 <trap+0x296>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  10538c:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
  10538f:	8b 4a 10             	mov    0x10(%edx),%ecx
  105392:	83 c2 6c             	add    $0x6c,%edx
  105395:	89 74 24 1c          	mov    %esi,0x1c(%esp)
  105399:	8b 73 38             	mov    0x38(%ebx),%esi
  10539c:	89 74 24 18          	mov    %esi,0x18(%esp)
  1053a0:	65 8b 35 00 00 00 00 	mov    %gs:0x0,%esi
  1053a7:	0f b6 36             	movzbl (%esi),%esi
  1053aa:	89 74 24 14          	mov    %esi,0x14(%esp)
  1053ae:	8b 73 34             	mov    0x34(%ebx),%esi
  1053b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1053b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1053b9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1053bd:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053c1:	c7 04 24 5c 72 10 00 	movl   $0x10725c,(%esp)
  1053c8:	e8 f3 b0 ff ff       	call   1004c0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
  1053cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1053d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  1053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  1053e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1053e6:	85 c0                	test   %eax,%eax
  1053e8:	74 68                	je     105452 <trap+0x102>
  1053ea:	8b 48 24             	mov    0x24(%eax),%ecx
  1053ed:	85 c9                	test   %ecx,%ecx
  1053ef:	74 10                	je     105401 <trap+0xb1>
  1053f1:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
  1053f5:	83 e2 03             	and    $0x3,%edx
  1053f8:	83 fa 03             	cmp    $0x3,%edx
  1053fb:	0f 84 9f 01 00 00    	je     1055a0 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  105401:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105405:	74 59                	je     105460 <trap+0x110>
    yield();
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105407:	89 c2                	mov    %eax,%edx
  105409:	8b 42 24             	mov    0x24(%edx),%eax
  10540c:	85 c0                	test   %eax,%eax
  10540e:	74 42                	je     105452 <trap+0x102>
  105410:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105414:	83 e0 03             	and    $0x3,%eax
  105417:	83 f8 03             	cmp    $0x3,%eax
  10541a:	75 36                	jne    105452 <trap+0x102>
    exit();
}
  10541c:	83 c4 20             	add    $0x20,%esp
  10541f:	5b                   	pop    %ebx
  105420:	5e                   	pop    %esi
  105421:	5d                   	pop    %ebp
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105422:	e9 59 e5 ff ff       	jmp    103980 <exit>
  105427:	90                   	nop
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  105428:	ff 24 95 ac 72 10 00 	jmp    *0x1072ac(,%edx,4)
  10542f:	90                   	nop

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
  105430:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105436:	8b 70 24             	mov    0x24(%eax),%esi
  105439:	85 f6                	test   %esi,%esi
  10543b:	75 6b                	jne    1054a8 <trap+0x158>
      exit();
    proc->tf = tf;
  10543d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
  105440:	e8 bb f0 ff ff       	call   104500 <syscall>
    if(proc->killed)
  105445:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10544b:	8b 58 24             	mov    0x24(%eax),%ebx
  10544e:	85 db                	test   %ebx,%ebx
  105450:	75 ca                	jne    10541c <trap+0xcc>
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
  105452:	83 c4 20             	add    $0x20,%esp
  105455:	5b                   	pop    %ebx
  105456:	5e                   	pop    %esi
  105457:	5d                   	pop    %ebp
  105458:	c3                   	ret    
  105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  105460:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
  105464:	75 a1                	jne    105407 <trap+0xb7>
    //cprintf("lol");
    clockticks++;
  105466:	8b 0d cc 92 10 00    	mov    0x1092cc,%ecx
  10546c:	83 c1 01             	add    $0x1,%ecx
  10546f:	89 0d cc 92 10 00    	mov    %ecx,0x1092cc
    proc->rtime++;
  105475:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
    if(clockticks == QUANTA) {
    clockticks=0;
    yield();
    }
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
  10547c:	83 f9 05             	cmp    $0x5,%ecx
  10547f:	0f 84 33 01 00 00    	je     1055b8 <trap+0x268>
    clockticks=0;
    yield();
  105485:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    }
    if((clockticks == 2*QUANTA) && (proc->priority == 1)) {
  10548b:	83 f9 0a             	cmp    $0xa,%ecx
    yield();
    }
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
    clockticks=0;
    yield();
  10548e:	89 c2                	mov    %eax,%edx
    }
    if((clockticks == 2*QUANTA) && (proc->priority == 1)) {
  105490:	0f 84 df 00 00 00    	je     105575 <trap+0x225>
  105496:	89 c2                	mov    %eax,%edx
    yield();
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105498:	85 d2                	test   %edx,%edx
  10549a:	0f 85 69 ff ff ff    	jne    105409 <trap+0xb9>
  1054a0:	eb b0                	jmp    105452 <trap+0x102>
  1054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
  1054a8:	e8 d3 e4 ff ff       	call   103980 <exit>
  1054ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1054b3:	eb 88                	jmp    10543d <trap+0xed>
  1054b5:	8d 76 00             	lea    0x0(%esi),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  1054b8:	e8 13 cd ff ff       	call   1021d0 <ideintr>
    lapiceoi();
  1054bd:	e8 6e d1 ff ff       	call   102630 <lapiceoi>
    break;
  1054c2:	e9 19 ff ff ff       	jmp    1053e0 <trap+0x90>
  1054c7:	90                   	nop
  1054c8:	90                   	nop
  1054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
  1054d0:	e8 3b d1 ff ff       	call   102610 <kbdintr>
  1054d5:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  1054d8:	e8 53 d1 ff ff       	call   102630 <lapiceoi>
  1054dd:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  1054e0:	e9 fb fe ff ff       	jmp    1053e0 <trap+0x90>
  1054e5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
  1054e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1054ee:	80 38 00             	cmpb   $0x0,(%eax)
  1054f1:	75 ca                	jne    1054bd <trap+0x16d>
      acquire(&tickslock);
  1054f3:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  1054fa:	e8 c1 eb ff ff       	call   1040c0 <acquire>
      ticks++;
  1054ff:	83 05 a0 f6 10 00 01 	addl   $0x1,0x10f6a0
      wakeup(&ticks);
  105506:	c7 04 24 a0 f6 10 00 	movl   $0x10f6a0,(%esp)
  10550d:	e8 8e dd ff ff       	call   1032a0 <wakeup>
      release(&tickslock);
  105512:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
  105519:	e8 52 eb ff ff       	call   104070 <release>
  10551e:	eb 9d                	jmp    1054bd <trap+0x16d>
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  105520:	8b 43 38             	mov    0x38(%ebx),%eax
  105523:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105527:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  10552b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10552f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  105535:	0f b6 00             	movzbl (%eax),%eax
  105538:	c7 04 24 04 72 10 00 	movl   $0x107204,(%esp)
  10553f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105543:	e8 78 af ff ff       	call   1004c0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
  105548:	e8 e3 d0 ff ff       	call   102630 <lapiceoi>
    break;
  10554d:	e9 8e fe ff ff       	jmp    1053e0 <trap+0x90>
  105552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  105558:	90                   	nop
  105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  105560:	e8 7b 01 00 00       	call   1056e0 <uartintr>
  105565:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105568:	e8 c3 d0 ff ff       	call   102630 <lapiceoi>
  10556d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105570:	e9 6b fe ff ff       	jmp    1053e0 <trap+0x90>
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
    clockticks=0;
    yield();
    }
    if((clockticks == 2*QUANTA) && (proc->priority == 1)) {
  105575:	83 b8 88 00 00 00 01 	cmpl   $0x1,0x88(%eax)
  10557c:	0f 85 16 ff ff ff    	jne    105498 <trap+0x148>
    clockticks=0;
  105582:	c7 05 cc 92 10 00 00 	movl   $0x0,0x1092cc
  105589:	00 00 00 
    yield();
  10558c:	e8 3f df ff ff       	call   1034d0 <yield>
  105591:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  105598:	e9 fb fe ff ff       	jmp    105498 <trap+0x148>
  10559d:	8d 76 00             	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  1055a0:	e8 db e3 ff ff       	call   103980 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  1055a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1055ab:	85 c0                	test   %eax,%eax
  1055ad:	0f 85 4e fe ff ff    	jne    105401 <trap+0xb1>
  1055b3:	e9 9a fe ff ff       	jmp    105452 <trap+0x102>
    if(clockticks == QUANTA) {
    clockticks=0;
    yield();
    }
#elif (RR2 || FAIR2Q)
    if((clockticks == QUANTA) && (proc->priority == 0)) {
  1055b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1055be:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
  1055c4:	85 d2                	test   %edx,%edx
  1055c6:	0f 85 ca fe ff ff    	jne    105496 <trap+0x146>
    clockticks=0;
  1055cc:	c7 05 cc 92 10 00 00 	movl   $0x0,0x1092cc
  1055d3:	00 00 00 
    yield();
  1055d6:	e8 f5 de ff ff       	call   1034d0 <yield>
  1055db:	8b 0d cc 92 10 00    	mov    0x1092cc,%ecx
  1055e1:	e9 9f fe ff ff       	jmp    105485 <trap+0x135>
  1055e6:	0f 20 d2             	mov    %cr2,%edx
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  1055e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  1055ed:	8b 53 38             	mov    0x38(%ebx),%edx
  1055f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055f4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  1055fb:	0f b6 12             	movzbl (%edx),%edx
  1055fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105602:	c7 04 24 28 72 10 00 	movl   $0x107228,(%esp)
  105609:	89 54 24 08          	mov    %edx,0x8(%esp)
  10560d:	e8 ae ae ff ff       	call   1004c0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
  105612:	c7 04 24 9f 72 10 00 	movl   $0x10729f,(%esp)
  105619:	e8 72 b4 ff ff       	call   100a90 <panic>
  10561e:	66 90                	xchg   %ax,%ax

00105620 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  105620:	55                   	push   %ebp
  105621:	31 c0                	xor    %eax,%eax
  105623:	89 e5                	mov    %esp,%ebp
  105625:	ba a0 ee 10 00       	mov    $0x10eea0,%edx
  10562a:	83 ec 18             	sub    $0x18,%esp
  10562d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105630:	8b 0c 85 28 87 10 00 	mov    0x108728(,%eax,4),%ecx
  105637:	66 89 0c c5 a0 ee 10 	mov    %cx,0x10eea0(,%eax,8)
  10563e:	00 
  10563f:	c1 e9 10             	shr    $0x10,%ecx
  105642:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105649:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  10564e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105653:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105658:	83 c0 01             	add    $0x1,%eax
  10565b:	3d 00 01 00 00       	cmp    $0x100,%eax
  105660:	75 ce                	jne    105630 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105662:	a1 28 88 10 00       	mov    0x108828,%eax
  
  initlock(&tickslock, "time");
  105667:	c7 44 24 04 a4 72 10 	movl   $0x1072a4,0x4(%esp)
  10566e:	00 
  10566f:	c7 04 24 60 ee 10 00 	movl   $0x10ee60,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105676:	66 c7 05 a2 f0 10 00 	movw   $0x8,0x10f0a2
  10567d:	08 00 
  10567f:	66 a3 a0 f0 10 00    	mov    %ax,0x10f0a0
  105685:	c1 e8 10             	shr    $0x10,%eax
  105688:	c6 05 a4 f0 10 00 00 	movb   $0x0,0x10f0a4
  10568f:	c6 05 a5 f0 10 00 ef 	movb   $0xef,0x10f0a5
  105696:	66 a3 a6 f0 10 00    	mov    %ax,0x10f0a6
  
  initlock(&tickslock, "time");
  10569c:	e8 8f e8 ff ff       	call   103f30 <initlock>
}
  1056a1:	c9                   	leave  
  1056a2:	c3                   	ret    
  1056a3:	90                   	nop
  1056a4:	90                   	nop
  1056a5:	90                   	nop
  1056a6:	90                   	nop
  1056a7:	90                   	nop
  1056a8:	90                   	nop
  1056a9:	90                   	nop
  1056aa:	90                   	nop
  1056ab:	90                   	nop
  1056ac:	90                   	nop
  1056ad:	90                   	nop
  1056ae:	90                   	nop
  1056af:	90                   	nop

001056b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
  1056b0:	a1 d0 92 10 00       	mov    0x1092d0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
  1056b5:	55                   	push   %ebp
  1056b6:	89 e5                	mov    %esp,%ebp
  if(!uart)
  1056b8:	85 c0                	test   %eax,%eax
  1056ba:	75 0c                	jne    1056c8 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
  1056bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1056c1:	5d                   	pop    %ebp
  1056c2:	c3                   	ret    
  1056c3:	90                   	nop
  1056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1056c8:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1056cd:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
  1056ce:	a8 01                	test   $0x1,%al
  1056d0:	74 ea                	je     1056bc <uartgetc+0xc>
  1056d2:	b2 f8                	mov    $0xf8,%dl
  1056d4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  1056d5:	0f b6 c0             	movzbl %al,%eax
}
  1056d8:	5d                   	pop    %ebp
  1056d9:	c3                   	ret    
  1056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001056e0 <uartintr>:

void
uartintr(void)
{
  1056e0:	55                   	push   %ebp
  1056e1:	89 e5                	mov    %esp,%ebp
  1056e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
  1056e6:	c7 04 24 b0 56 10 00 	movl   $0x1056b0,(%esp)
  1056ed:	e8 ce b0 ff ff       	call   1007c0 <consoleintr>
}
  1056f2:	c9                   	leave  
  1056f3:	c3                   	ret    
  1056f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1056fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105700 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
  105700:	55                   	push   %ebp
  105701:	89 e5                	mov    %esp,%ebp
  105703:	56                   	push   %esi
  105704:	be fd 03 00 00       	mov    $0x3fd,%esi
  105709:	53                   	push   %ebx
  int i;

  if(!uart)
  10570a:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
  10570c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  10570f:	8b 15 d0 92 10 00    	mov    0x1092d0,%edx
  105715:	85 d2                	test   %edx,%edx
  105717:	75 1e                	jne    105737 <uartputc+0x37>
  105719:	eb 2c                	jmp    105747 <uartputc+0x47>
  10571b:	90                   	nop
  10571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  105720:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
  105723:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10572a:	e8 21 cf ff ff       	call   102650 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  10572f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  105735:	74 07                	je     10573e <uartputc+0x3e>
  105737:	89 f2                	mov    %esi,%edx
  105739:	ec                   	in     (%dx),%al
  10573a:	a8 20                	test   $0x20,%al
  10573c:	74 e2                	je     105720 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10573e:	ba f8 03 00 00       	mov    $0x3f8,%edx
  105743:	8b 45 08             	mov    0x8(%ebp),%eax
  105746:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
  105747:	83 c4 10             	add    $0x10,%esp
  10574a:	5b                   	pop    %ebx
  10574b:	5e                   	pop    %esi
  10574c:	5d                   	pop    %ebp
  10574d:	c3                   	ret    
  10574e:	66 90                	xchg   %ax,%ax

00105750 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  105750:	55                   	push   %ebp
  105751:	31 c9                	xor    %ecx,%ecx
  105753:	89 e5                	mov    %esp,%ebp
  105755:	89 c8                	mov    %ecx,%eax
  105757:	57                   	push   %edi
  105758:	bf fa 03 00 00       	mov    $0x3fa,%edi
  10575d:	56                   	push   %esi
  10575e:	89 fa                	mov    %edi,%edx
  105760:	53                   	push   %ebx
  105761:	83 ec 1c             	sub    $0x1c,%esp
  105764:	ee                   	out    %al,(%dx)
  105765:	bb fb 03 00 00       	mov    $0x3fb,%ebx
  10576a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  10576f:	89 da                	mov    %ebx,%edx
  105771:	ee                   	out    %al,(%dx)
  105772:	b8 0c 00 00 00       	mov    $0xc,%eax
  105777:	b2 f8                	mov    $0xf8,%dl
  105779:	ee                   	out    %al,(%dx)
  10577a:	be f9 03 00 00       	mov    $0x3f9,%esi
  10577f:	89 c8                	mov    %ecx,%eax
  105781:	89 f2                	mov    %esi,%edx
  105783:	ee                   	out    %al,(%dx)
  105784:	b8 03 00 00 00       	mov    $0x3,%eax
  105789:	89 da                	mov    %ebx,%edx
  10578b:	ee                   	out    %al,(%dx)
  10578c:	b2 fc                	mov    $0xfc,%dl
  10578e:	89 c8                	mov    %ecx,%eax
  105790:	ee                   	out    %al,(%dx)
  105791:	b8 01 00 00 00       	mov    $0x1,%eax
  105796:	89 f2                	mov    %esi,%edx
  105798:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  105799:	b2 fd                	mov    $0xfd,%dl
  10579b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  10579c:	3c ff                	cmp    $0xff,%al
  10579e:	74 55                	je     1057f5 <uartinit+0xa5>
    return;
  uart = 1;
  1057a0:	c7 05 d0 92 10 00 01 	movl   $0x1,0x1092d0
  1057a7:	00 00 00 
  1057aa:	89 fa                	mov    %edi,%edx
  1057ac:	ec                   	in     (%dx),%al
  1057ad:	b2 f8                	mov    $0xf8,%dl
  1057af:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  1057b0:	bb 2c 73 10 00       	mov    $0x10732c,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  1057b5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1057bc:	e8 9f d5 ff ff       	call   102d60 <picenable>
  ioapicenable(IRQ_COM1, 0);
  1057c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1057c8:	00 
  1057c9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1057d0:	e8 4b cb ff ff       	call   102320 <ioapicenable>
  1057d5:	b8 78 00 00 00       	mov    $0x78,%eax
  1057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
  1057e0:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1057e3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
  1057e6:	89 04 24             	mov    %eax,(%esp)
  1057e9:	e8 12 ff ff ff       	call   105700 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1057ee:	0f b6 03             	movzbl (%ebx),%eax
  1057f1:	84 c0                	test   %al,%al
  1057f3:	75 eb                	jne    1057e0 <uartinit+0x90>
    uartputc(*p);
}
  1057f5:	83 c4 1c             	add    $0x1c,%esp
  1057f8:	5b                   	pop    %ebx
  1057f9:	5e                   	pop    %esi
  1057fa:	5f                   	pop    %edi
  1057fb:	5d                   	pop    %ebp
  1057fc:	c3                   	ret    
  1057fd:	90                   	nop
  1057fe:	90                   	nop
  1057ff:	90                   	nop

00105800 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  105800:	6a 00                	push   $0x0
  pushl $0
  105802:	6a 00                	push   $0x0
  jmp alltraps
  105804:	e9 e7 fa ff ff       	jmp    1052f0 <alltraps>

00105809 <vector1>:
.globl vector1
vector1:
  pushl $0
  105809:	6a 00                	push   $0x0
  pushl $1
  10580b:	6a 01                	push   $0x1
  jmp alltraps
  10580d:	e9 de fa ff ff       	jmp    1052f0 <alltraps>

00105812 <vector2>:
.globl vector2
vector2:
  pushl $0
  105812:	6a 00                	push   $0x0
  pushl $2
  105814:	6a 02                	push   $0x2
  jmp alltraps
  105816:	e9 d5 fa ff ff       	jmp    1052f0 <alltraps>

0010581b <vector3>:
.globl vector3
vector3:
  pushl $0
  10581b:	6a 00                	push   $0x0
  pushl $3
  10581d:	6a 03                	push   $0x3
  jmp alltraps
  10581f:	e9 cc fa ff ff       	jmp    1052f0 <alltraps>

00105824 <vector4>:
.globl vector4
vector4:
  pushl $0
  105824:	6a 00                	push   $0x0
  pushl $4
  105826:	6a 04                	push   $0x4
  jmp alltraps
  105828:	e9 c3 fa ff ff       	jmp    1052f0 <alltraps>

0010582d <vector5>:
.globl vector5
vector5:
  pushl $0
  10582d:	6a 00                	push   $0x0
  pushl $5
  10582f:	6a 05                	push   $0x5
  jmp alltraps
  105831:	e9 ba fa ff ff       	jmp    1052f0 <alltraps>

00105836 <vector6>:
.globl vector6
vector6:
  pushl $0
  105836:	6a 00                	push   $0x0
  pushl $6
  105838:	6a 06                	push   $0x6
  jmp alltraps
  10583a:	e9 b1 fa ff ff       	jmp    1052f0 <alltraps>

0010583f <vector7>:
.globl vector7
vector7:
  pushl $0
  10583f:	6a 00                	push   $0x0
  pushl $7
  105841:	6a 07                	push   $0x7
  jmp alltraps
  105843:	e9 a8 fa ff ff       	jmp    1052f0 <alltraps>

00105848 <vector8>:
.globl vector8
vector8:
  pushl $8
  105848:	6a 08                	push   $0x8
  jmp alltraps
  10584a:	e9 a1 fa ff ff       	jmp    1052f0 <alltraps>

0010584f <vector9>:
.globl vector9
vector9:
  pushl $0
  10584f:	6a 00                	push   $0x0
  pushl $9
  105851:	6a 09                	push   $0x9
  jmp alltraps
  105853:	e9 98 fa ff ff       	jmp    1052f0 <alltraps>

00105858 <vector10>:
.globl vector10
vector10:
  pushl $10
  105858:	6a 0a                	push   $0xa
  jmp alltraps
  10585a:	e9 91 fa ff ff       	jmp    1052f0 <alltraps>

0010585f <vector11>:
.globl vector11
vector11:
  pushl $11
  10585f:	6a 0b                	push   $0xb
  jmp alltraps
  105861:	e9 8a fa ff ff       	jmp    1052f0 <alltraps>

00105866 <vector12>:
.globl vector12
vector12:
  pushl $12
  105866:	6a 0c                	push   $0xc
  jmp alltraps
  105868:	e9 83 fa ff ff       	jmp    1052f0 <alltraps>

0010586d <vector13>:
.globl vector13
vector13:
  pushl $13
  10586d:	6a 0d                	push   $0xd
  jmp alltraps
  10586f:	e9 7c fa ff ff       	jmp    1052f0 <alltraps>

00105874 <vector14>:
.globl vector14
vector14:
  pushl $14
  105874:	6a 0e                	push   $0xe
  jmp alltraps
  105876:	e9 75 fa ff ff       	jmp    1052f0 <alltraps>

0010587b <vector15>:
.globl vector15
vector15:
  pushl $0
  10587b:	6a 00                	push   $0x0
  pushl $15
  10587d:	6a 0f                	push   $0xf
  jmp alltraps
  10587f:	e9 6c fa ff ff       	jmp    1052f0 <alltraps>

00105884 <vector16>:
.globl vector16
vector16:
  pushl $0
  105884:	6a 00                	push   $0x0
  pushl $16
  105886:	6a 10                	push   $0x10
  jmp alltraps
  105888:	e9 63 fa ff ff       	jmp    1052f0 <alltraps>

0010588d <vector17>:
.globl vector17
vector17:
  pushl $17
  10588d:	6a 11                	push   $0x11
  jmp alltraps
  10588f:	e9 5c fa ff ff       	jmp    1052f0 <alltraps>

00105894 <vector18>:
.globl vector18
vector18:
  pushl $0
  105894:	6a 00                	push   $0x0
  pushl $18
  105896:	6a 12                	push   $0x12
  jmp alltraps
  105898:	e9 53 fa ff ff       	jmp    1052f0 <alltraps>

0010589d <vector19>:
.globl vector19
vector19:
  pushl $0
  10589d:	6a 00                	push   $0x0
  pushl $19
  10589f:	6a 13                	push   $0x13
  jmp alltraps
  1058a1:	e9 4a fa ff ff       	jmp    1052f0 <alltraps>

001058a6 <vector20>:
.globl vector20
vector20:
  pushl $0
  1058a6:	6a 00                	push   $0x0
  pushl $20
  1058a8:	6a 14                	push   $0x14
  jmp alltraps
  1058aa:	e9 41 fa ff ff       	jmp    1052f0 <alltraps>

001058af <vector21>:
.globl vector21
vector21:
  pushl $0
  1058af:	6a 00                	push   $0x0
  pushl $21
  1058b1:	6a 15                	push   $0x15
  jmp alltraps
  1058b3:	e9 38 fa ff ff       	jmp    1052f0 <alltraps>

001058b8 <vector22>:
.globl vector22
vector22:
  pushl $0
  1058b8:	6a 00                	push   $0x0
  pushl $22
  1058ba:	6a 16                	push   $0x16
  jmp alltraps
  1058bc:	e9 2f fa ff ff       	jmp    1052f0 <alltraps>

001058c1 <vector23>:
.globl vector23
vector23:
  pushl $0
  1058c1:	6a 00                	push   $0x0
  pushl $23
  1058c3:	6a 17                	push   $0x17
  jmp alltraps
  1058c5:	e9 26 fa ff ff       	jmp    1052f0 <alltraps>

001058ca <vector24>:
.globl vector24
vector24:
  pushl $0
  1058ca:	6a 00                	push   $0x0
  pushl $24
  1058cc:	6a 18                	push   $0x18
  jmp alltraps
  1058ce:	e9 1d fa ff ff       	jmp    1052f0 <alltraps>

001058d3 <vector25>:
.globl vector25
vector25:
  pushl $0
  1058d3:	6a 00                	push   $0x0
  pushl $25
  1058d5:	6a 19                	push   $0x19
  jmp alltraps
  1058d7:	e9 14 fa ff ff       	jmp    1052f0 <alltraps>

001058dc <vector26>:
.globl vector26
vector26:
  pushl $0
  1058dc:	6a 00                	push   $0x0
  pushl $26
  1058de:	6a 1a                	push   $0x1a
  jmp alltraps
  1058e0:	e9 0b fa ff ff       	jmp    1052f0 <alltraps>

001058e5 <vector27>:
.globl vector27
vector27:
  pushl $0
  1058e5:	6a 00                	push   $0x0
  pushl $27
  1058e7:	6a 1b                	push   $0x1b
  jmp alltraps
  1058e9:	e9 02 fa ff ff       	jmp    1052f0 <alltraps>

001058ee <vector28>:
.globl vector28
vector28:
  pushl $0
  1058ee:	6a 00                	push   $0x0
  pushl $28
  1058f0:	6a 1c                	push   $0x1c
  jmp alltraps
  1058f2:	e9 f9 f9 ff ff       	jmp    1052f0 <alltraps>

001058f7 <vector29>:
.globl vector29
vector29:
  pushl $0
  1058f7:	6a 00                	push   $0x0
  pushl $29
  1058f9:	6a 1d                	push   $0x1d
  jmp alltraps
  1058fb:	e9 f0 f9 ff ff       	jmp    1052f0 <alltraps>

00105900 <vector30>:
.globl vector30
vector30:
  pushl $0
  105900:	6a 00                	push   $0x0
  pushl $30
  105902:	6a 1e                	push   $0x1e
  jmp alltraps
  105904:	e9 e7 f9 ff ff       	jmp    1052f0 <alltraps>

00105909 <vector31>:
.globl vector31
vector31:
  pushl $0
  105909:	6a 00                	push   $0x0
  pushl $31
  10590b:	6a 1f                	push   $0x1f
  jmp alltraps
  10590d:	e9 de f9 ff ff       	jmp    1052f0 <alltraps>

00105912 <vector32>:
.globl vector32
vector32:
  pushl $0
  105912:	6a 00                	push   $0x0
  pushl $32
  105914:	6a 20                	push   $0x20
  jmp alltraps
  105916:	e9 d5 f9 ff ff       	jmp    1052f0 <alltraps>

0010591b <vector33>:
.globl vector33
vector33:
  pushl $0
  10591b:	6a 00                	push   $0x0
  pushl $33
  10591d:	6a 21                	push   $0x21
  jmp alltraps
  10591f:	e9 cc f9 ff ff       	jmp    1052f0 <alltraps>

00105924 <vector34>:
.globl vector34
vector34:
  pushl $0
  105924:	6a 00                	push   $0x0
  pushl $34
  105926:	6a 22                	push   $0x22
  jmp alltraps
  105928:	e9 c3 f9 ff ff       	jmp    1052f0 <alltraps>

0010592d <vector35>:
.globl vector35
vector35:
  pushl $0
  10592d:	6a 00                	push   $0x0
  pushl $35
  10592f:	6a 23                	push   $0x23
  jmp alltraps
  105931:	e9 ba f9 ff ff       	jmp    1052f0 <alltraps>

00105936 <vector36>:
.globl vector36
vector36:
  pushl $0
  105936:	6a 00                	push   $0x0
  pushl $36
  105938:	6a 24                	push   $0x24
  jmp alltraps
  10593a:	e9 b1 f9 ff ff       	jmp    1052f0 <alltraps>

0010593f <vector37>:
.globl vector37
vector37:
  pushl $0
  10593f:	6a 00                	push   $0x0
  pushl $37
  105941:	6a 25                	push   $0x25
  jmp alltraps
  105943:	e9 a8 f9 ff ff       	jmp    1052f0 <alltraps>

00105948 <vector38>:
.globl vector38
vector38:
  pushl $0
  105948:	6a 00                	push   $0x0
  pushl $38
  10594a:	6a 26                	push   $0x26
  jmp alltraps
  10594c:	e9 9f f9 ff ff       	jmp    1052f0 <alltraps>

00105951 <vector39>:
.globl vector39
vector39:
  pushl $0
  105951:	6a 00                	push   $0x0
  pushl $39
  105953:	6a 27                	push   $0x27
  jmp alltraps
  105955:	e9 96 f9 ff ff       	jmp    1052f0 <alltraps>

0010595a <vector40>:
.globl vector40
vector40:
  pushl $0
  10595a:	6a 00                	push   $0x0
  pushl $40
  10595c:	6a 28                	push   $0x28
  jmp alltraps
  10595e:	e9 8d f9 ff ff       	jmp    1052f0 <alltraps>

00105963 <vector41>:
.globl vector41
vector41:
  pushl $0
  105963:	6a 00                	push   $0x0
  pushl $41
  105965:	6a 29                	push   $0x29
  jmp alltraps
  105967:	e9 84 f9 ff ff       	jmp    1052f0 <alltraps>

0010596c <vector42>:
.globl vector42
vector42:
  pushl $0
  10596c:	6a 00                	push   $0x0
  pushl $42
  10596e:	6a 2a                	push   $0x2a
  jmp alltraps
  105970:	e9 7b f9 ff ff       	jmp    1052f0 <alltraps>

00105975 <vector43>:
.globl vector43
vector43:
  pushl $0
  105975:	6a 00                	push   $0x0
  pushl $43
  105977:	6a 2b                	push   $0x2b
  jmp alltraps
  105979:	e9 72 f9 ff ff       	jmp    1052f0 <alltraps>

0010597e <vector44>:
.globl vector44
vector44:
  pushl $0
  10597e:	6a 00                	push   $0x0
  pushl $44
  105980:	6a 2c                	push   $0x2c
  jmp alltraps
  105982:	e9 69 f9 ff ff       	jmp    1052f0 <alltraps>

00105987 <vector45>:
.globl vector45
vector45:
  pushl $0
  105987:	6a 00                	push   $0x0
  pushl $45
  105989:	6a 2d                	push   $0x2d
  jmp alltraps
  10598b:	e9 60 f9 ff ff       	jmp    1052f0 <alltraps>

00105990 <vector46>:
.globl vector46
vector46:
  pushl $0
  105990:	6a 00                	push   $0x0
  pushl $46
  105992:	6a 2e                	push   $0x2e
  jmp alltraps
  105994:	e9 57 f9 ff ff       	jmp    1052f0 <alltraps>

00105999 <vector47>:
.globl vector47
vector47:
  pushl $0
  105999:	6a 00                	push   $0x0
  pushl $47
  10599b:	6a 2f                	push   $0x2f
  jmp alltraps
  10599d:	e9 4e f9 ff ff       	jmp    1052f0 <alltraps>

001059a2 <vector48>:
.globl vector48
vector48:
  pushl $0
  1059a2:	6a 00                	push   $0x0
  pushl $48
  1059a4:	6a 30                	push   $0x30
  jmp alltraps
  1059a6:	e9 45 f9 ff ff       	jmp    1052f0 <alltraps>

001059ab <vector49>:
.globl vector49
vector49:
  pushl $0
  1059ab:	6a 00                	push   $0x0
  pushl $49
  1059ad:	6a 31                	push   $0x31
  jmp alltraps
  1059af:	e9 3c f9 ff ff       	jmp    1052f0 <alltraps>

001059b4 <vector50>:
.globl vector50
vector50:
  pushl $0
  1059b4:	6a 00                	push   $0x0
  pushl $50
  1059b6:	6a 32                	push   $0x32
  jmp alltraps
  1059b8:	e9 33 f9 ff ff       	jmp    1052f0 <alltraps>

001059bd <vector51>:
.globl vector51
vector51:
  pushl $0
  1059bd:	6a 00                	push   $0x0
  pushl $51
  1059bf:	6a 33                	push   $0x33
  jmp alltraps
  1059c1:	e9 2a f9 ff ff       	jmp    1052f0 <alltraps>

001059c6 <vector52>:
.globl vector52
vector52:
  pushl $0
  1059c6:	6a 00                	push   $0x0
  pushl $52
  1059c8:	6a 34                	push   $0x34
  jmp alltraps
  1059ca:	e9 21 f9 ff ff       	jmp    1052f0 <alltraps>

001059cf <vector53>:
.globl vector53
vector53:
  pushl $0
  1059cf:	6a 00                	push   $0x0
  pushl $53
  1059d1:	6a 35                	push   $0x35
  jmp alltraps
  1059d3:	e9 18 f9 ff ff       	jmp    1052f0 <alltraps>

001059d8 <vector54>:
.globl vector54
vector54:
  pushl $0
  1059d8:	6a 00                	push   $0x0
  pushl $54
  1059da:	6a 36                	push   $0x36
  jmp alltraps
  1059dc:	e9 0f f9 ff ff       	jmp    1052f0 <alltraps>

001059e1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1059e1:	6a 00                	push   $0x0
  pushl $55
  1059e3:	6a 37                	push   $0x37
  jmp alltraps
  1059e5:	e9 06 f9 ff ff       	jmp    1052f0 <alltraps>

001059ea <vector56>:
.globl vector56
vector56:
  pushl $0
  1059ea:	6a 00                	push   $0x0
  pushl $56
  1059ec:	6a 38                	push   $0x38
  jmp alltraps
  1059ee:	e9 fd f8 ff ff       	jmp    1052f0 <alltraps>

001059f3 <vector57>:
.globl vector57
vector57:
  pushl $0
  1059f3:	6a 00                	push   $0x0
  pushl $57
  1059f5:	6a 39                	push   $0x39
  jmp alltraps
  1059f7:	e9 f4 f8 ff ff       	jmp    1052f0 <alltraps>

001059fc <vector58>:
.globl vector58
vector58:
  pushl $0
  1059fc:	6a 00                	push   $0x0
  pushl $58
  1059fe:	6a 3a                	push   $0x3a
  jmp alltraps
  105a00:	e9 eb f8 ff ff       	jmp    1052f0 <alltraps>

00105a05 <vector59>:
.globl vector59
vector59:
  pushl $0
  105a05:	6a 00                	push   $0x0
  pushl $59
  105a07:	6a 3b                	push   $0x3b
  jmp alltraps
  105a09:	e9 e2 f8 ff ff       	jmp    1052f0 <alltraps>

00105a0e <vector60>:
.globl vector60
vector60:
  pushl $0
  105a0e:	6a 00                	push   $0x0
  pushl $60
  105a10:	6a 3c                	push   $0x3c
  jmp alltraps
  105a12:	e9 d9 f8 ff ff       	jmp    1052f0 <alltraps>

00105a17 <vector61>:
.globl vector61
vector61:
  pushl $0
  105a17:	6a 00                	push   $0x0
  pushl $61
  105a19:	6a 3d                	push   $0x3d
  jmp alltraps
  105a1b:	e9 d0 f8 ff ff       	jmp    1052f0 <alltraps>

00105a20 <vector62>:
.globl vector62
vector62:
  pushl $0
  105a20:	6a 00                	push   $0x0
  pushl $62
  105a22:	6a 3e                	push   $0x3e
  jmp alltraps
  105a24:	e9 c7 f8 ff ff       	jmp    1052f0 <alltraps>

00105a29 <vector63>:
.globl vector63
vector63:
  pushl $0
  105a29:	6a 00                	push   $0x0
  pushl $63
  105a2b:	6a 3f                	push   $0x3f
  jmp alltraps
  105a2d:	e9 be f8 ff ff       	jmp    1052f0 <alltraps>

00105a32 <vector64>:
.globl vector64
vector64:
  pushl $0
  105a32:	6a 00                	push   $0x0
  pushl $64
  105a34:	6a 40                	push   $0x40
  jmp alltraps
  105a36:	e9 b5 f8 ff ff       	jmp    1052f0 <alltraps>

00105a3b <vector65>:
.globl vector65
vector65:
  pushl $0
  105a3b:	6a 00                	push   $0x0
  pushl $65
  105a3d:	6a 41                	push   $0x41
  jmp alltraps
  105a3f:	e9 ac f8 ff ff       	jmp    1052f0 <alltraps>

00105a44 <vector66>:
.globl vector66
vector66:
  pushl $0
  105a44:	6a 00                	push   $0x0
  pushl $66
  105a46:	6a 42                	push   $0x42
  jmp alltraps
  105a48:	e9 a3 f8 ff ff       	jmp    1052f0 <alltraps>

00105a4d <vector67>:
.globl vector67
vector67:
  pushl $0
  105a4d:	6a 00                	push   $0x0
  pushl $67
  105a4f:	6a 43                	push   $0x43
  jmp alltraps
  105a51:	e9 9a f8 ff ff       	jmp    1052f0 <alltraps>

00105a56 <vector68>:
.globl vector68
vector68:
  pushl $0
  105a56:	6a 00                	push   $0x0
  pushl $68
  105a58:	6a 44                	push   $0x44
  jmp alltraps
  105a5a:	e9 91 f8 ff ff       	jmp    1052f0 <alltraps>

00105a5f <vector69>:
.globl vector69
vector69:
  pushl $0
  105a5f:	6a 00                	push   $0x0
  pushl $69
  105a61:	6a 45                	push   $0x45
  jmp alltraps
  105a63:	e9 88 f8 ff ff       	jmp    1052f0 <alltraps>

00105a68 <vector70>:
.globl vector70
vector70:
  pushl $0
  105a68:	6a 00                	push   $0x0
  pushl $70
  105a6a:	6a 46                	push   $0x46
  jmp alltraps
  105a6c:	e9 7f f8 ff ff       	jmp    1052f0 <alltraps>

00105a71 <vector71>:
.globl vector71
vector71:
  pushl $0
  105a71:	6a 00                	push   $0x0
  pushl $71
  105a73:	6a 47                	push   $0x47
  jmp alltraps
  105a75:	e9 76 f8 ff ff       	jmp    1052f0 <alltraps>

00105a7a <vector72>:
.globl vector72
vector72:
  pushl $0
  105a7a:	6a 00                	push   $0x0
  pushl $72
  105a7c:	6a 48                	push   $0x48
  jmp alltraps
  105a7e:	e9 6d f8 ff ff       	jmp    1052f0 <alltraps>

00105a83 <vector73>:
.globl vector73
vector73:
  pushl $0
  105a83:	6a 00                	push   $0x0
  pushl $73
  105a85:	6a 49                	push   $0x49
  jmp alltraps
  105a87:	e9 64 f8 ff ff       	jmp    1052f0 <alltraps>

00105a8c <vector74>:
.globl vector74
vector74:
  pushl $0
  105a8c:	6a 00                	push   $0x0
  pushl $74
  105a8e:	6a 4a                	push   $0x4a
  jmp alltraps
  105a90:	e9 5b f8 ff ff       	jmp    1052f0 <alltraps>

00105a95 <vector75>:
.globl vector75
vector75:
  pushl $0
  105a95:	6a 00                	push   $0x0
  pushl $75
  105a97:	6a 4b                	push   $0x4b
  jmp alltraps
  105a99:	e9 52 f8 ff ff       	jmp    1052f0 <alltraps>

00105a9e <vector76>:
.globl vector76
vector76:
  pushl $0
  105a9e:	6a 00                	push   $0x0
  pushl $76
  105aa0:	6a 4c                	push   $0x4c
  jmp alltraps
  105aa2:	e9 49 f8 ff ff       	jmp    1052f0 <alltraps>

00105aa7 <vector77>:
.globl vector77
vector77:
  pushl $0
  105aa7:	6a 00                	push   $0x0
  pushl $77
  105aa9:	6a 4d                	push   $0x4d
  jmp alltraps
  105aab:	e9 40 f8 ff ff       	jmp    1052f0 <alltraps>

00105ab0 <vector78>:
.globl vector78
vector78:
  pushl $0
  105ab0:	6a 00                	push   $0x0
  pushl $78
  105ab2:	6a 4e                	push   $0x4e
  jmp alltraps
  105ab4:	e9 37 f8 ff ff       	jmp    1052f0 <alltraps>

00105ab9 <vector79>:
.globl vector79
vector79:
  pushl $0
  105ab9:	6a 00                	push   $0x0
  pushl $79
  105abb:	6a 4f                	push   $0x4f
  jmp alltraps
  105abd:	e9 2e f8 ff ff       	jmp    1052f0 <alltraps>

00105ac2 <vector80>:
.globl vector80
vector80:
  pushl $0
  105ac2:	6a 00                	push   $0x0
  pushl $80
  105ac4:	6a 50                	push   $0x50
  jmp alltraps
  105ac6:	e9 25 f8 ff ff       	jmp    1052f0 <alltraps>

00105acb <vector81>:
.globl vector81
vector81:
  pushl $0
  105acb:	6a 00                	push   $0x0
  pushl $81
  105acd:	6a 51                	push   $0x51
  jmp alltraps
  105acf:	e9 1c f8 ff ff       	jmp    1052f0 <alltraps>

00105ad4 <vector82>:
.globl vector82
vector82:
  pushl $0
  105ad4:	6a 00                	push   $0x0
  pushl $82
  105ad6:	6a 52                	push   $0x52
  jmp alltraps
  105ad8:	e9 13 f8 ff ff       	jmp    1052f0 <alltraps>

00105add <vector83>:
.globl vector83
vector83:
  pushl $0
  105add:	6a 00                	push   $0x0
  pushl $83
  105adf:	6a 53                	push   $0x53
  jmp alltraps
  105ae1:	e9 0a f8 ff ff       	jmp    1052f0 <alltraps>

00105ae6 <vector84>:
.globl vector84
vector84:
  pushl $0
  105ae6:	6a 00                	push   $0x0
  pushl $84
  105ae8:	6a 54                	push   $0x54
  jmp alltraps
  105aea:	e9 01 f8 ff ff       	jmp    1052f0 <alltraps>

00105aef <vector85>:
.globl vector85
vector85:
  pushl $0
  105aef:	6a 00                	push   $0x0
  pushl $85
  105af1:	6a 55                	push   $0x55
  jmp alltraps
  105af3:	e9 f8 f7 ff ff       	jmp    1052f0 <alltraps>

00105af8 <vector86>:
.globl vector86
vector86:
  pushl $0
  105af8:	6a 00                	push   $0x0
  pushl $86
  105afa:	6a 56                	push   $0x56
  jmp alltraps
  105afc:	e9 ef f7 ff ff       	jmp    1052f0 <alltraps>

00105b01 <vector87>:
.globl vector87
vector87:
  pushl $0
  105b01:	6a 00                	push   $0x0
  pushl $87
  105b03:	6a 57                	push   $0x57
  jmp alltraps
  105b05:	e9 e6 f7 ff ff       	jmp    1052f0 <alltraps>

00105b0a <vector88>:
.globl vector88
vector88:
  pushl $0
  105b0a:	6a 00                	push   $0x0
  pushl $88
  105b0c:	6a 58                	push   $0x58
  jmp alltraps
  105b0e:	e9 dd f7 ff ff       	jmp    1052f0 <alltraps>

00105b13 <vector89>:
.globl vector89
vector89:
  pushl $0
  105b13:	6a 00                	push   $0x0
  pushl $89
  105b15:	6a 59                	push   $0x59
  jmp alltraps
  105b17:	e9 d4 f7 ff ff       	jmp    1052f0 <alltraps>

00105b1c <vector90>:
.globl vector90
vector90:
  pushl $0
  105b1c:	6a 00                	push   $0x0
  pushl $90
  105b1e:	6a 5a                	push   $0x5a
  jmp alltraps
  105b20:	e9 cb f7 ff ff       	jmp    1052f0 <alltraps>

00105b25 <vector91>:
.globl vector91
vector91:
  pushl $0
  105b25:	6a 00                	push   $0x0
  pushl $91
  105b27:	6a 5b                	push   $0x5b
  jmp alltraps
  105b29:	e9 c2 f7 ff ff       	jmp    1052f0 <alltraps>

00105b2e <vector92>:
.globl vector92
vector92:
  pushl $0
  105b2e:	6a 00                	push   $0x0
  pushl $92
  105b30:	6a 5c                	push   $0x5c
  jmp alltraps
  105b32:	e9 b9 f7 ff ff       	jmp    1052f0 <alltraps>

00105b37 <vector93>:
.globl vector93
vector93:
  pushl $0
  105b37:	6a 00                	push   $0x0
  pushl $93
  105b39:	6a 5d                	push   $0x5d
  jmp alltraps
  105b3b:	e9 b0 f7 ff ff       	jmp    1052f0 <alltraps>

00105b40 <vector94>:
.globl vector94
vector94:
  pushl $0
  105b40:	6a 00                	push   $0x0
  pushl $94
  105b42:	6a 5e                	push   $0x5e
  jmp alltraps
  105b44:	e9 a7 f7 ff ff       	jmp    1052f0 <alltraps>

00105b49 <vector95>:
.globl vector95
vector95:
  pushl $0
  105b49:	6a 00                	push   $0x0
  pushl $95
  105b4b:	6a 5f                	push   $0x5f
  jmp alltraps
  105b4d:	e9 9e f7 ff ff       	jmp    1052f0 <alltraps>

00105b52 <vector96>:
.globl vector96
vector96:
  pushl $0
  105b52:	6a 00                	push   $0x0
  pushl $96
  105b54:	6a 60                	push   $0x60
  jmp alltraps
  105b56:	e9 95 f7 ff ff       	jmp    1052f0 <alltraps>

00105b5b <vector97>:
.globl vector97
vector97:
  pushl $0
  105b5b:	6a 00                	push   $0x0
  pushl $97
  105b5d:	6a 61                	push   $0x61
  jmp alltraps
  105b5f:	e9 8c f7 ff ff       	jmp    1052f0 <alltraps>

00105b64 <vector98>:
.globl vector98
vector98:
  pushl $0
  105b64:	6a 00                	push   $0x0
  pushl $98
  105b66:	6a 62                	push   $0x62
  jmp alltraps
  105b68:	e9 83 f7 ff ff       	jmp    1052f0 <alltraps>

00105b6d <vector99>:
.globl vector99
vector99:
  pushl $0
  105b6d:	6a 00                	push   $0x0
  pushl $99
  105b6f:	6a 63                	push   $0x63
  jmp alltraps
  105b71:	e9 7a f7 ff ff       	jmp    1052f0 <alltraps>

00105b76 <vector100>:
.globl vector100
vector100:
  pushl $0
  105b76:	6a 00                	push   $0x0
  pushl $100
  105b78:	6a 64                	push   $0x64
  jmp alltraps
  105b7a:	e9 71 f7 ff ff       	jmp    1052f0 <alltraps>

00105b7f <vector101>:
.globl vector101
vector101:
  pushl $0
  105b7f:	6a 00                	push   $0x0
  pushl $101
  105b81:	6a 65                	push   $0x65
  jmp alltraps
  105b83:	e9 68 f7 ff ff       	jmp    1052f0 <alltraps>

00105b88 <vector102>:
.globl vector102
vector102:
  pushl $0
  105b88:	6a 00                	push   $0x0
  pushl $102
  105b8a:	6a 66                	push   $0x66
  jmp alltraps
  105b8c:	e9 5f f7 ff ff       	jmp    1052f0 <alltraps>

00105b91 <vector103>:
.globl vector103
vector103:
  pushl $0
  105b91:	6a 00                	push   $0x0
  pushl $103
  105b93:	6a 67                	push   $0x67
  jmp alltraps
  105b95:	e9 56 f7 ff ff       	jmp    1052f0 <alltraps>

00105b9a <vector104>:
.globl vector104
vector104:
  pushl $0
  105b9a:	6a 00                	push   $0x0
  pushl $104
  105b9c:	6a 68                	push   $0x68
  jmp alltraps
  105b9e:	e9 4d f7 ff ff       	jmp    1052f0 <alltraps>

00105ba3 <vector105>:
.globl vector105
vector105:
  pushl $0
  105ba3:	6a 00                	push   $0x0
  pushl $105
  105ba5:	6a 69                	push   $0x69
  jmp alltraps
  105ba7:	e9 44 f7 ff ff       	jmp    1052f0 <alltraps>

00105bac <vector106>:
.globl vector106
vector106:
  pushl $0
  105bac:	6a 00                	push   $0x0
  pushl $106
  105bae:	6a 6a                	push   $0x6a
  jmp alltraps
  105bb0:	e9 3b f7 ff ff       	jmp    1052f0 <alltraps>

00105bb5 <vector107>:
.globl vector107
vector107:
  pushl $0
  105bb5:	6a 00                	push   $0x0
  pushl $107
  105bb7:	6a 6b                	push   $0x6b
  jmp alltraps
  105bb9:	e9 32 f7 ff ff       	jmp    1052f0 <alltraps>

00105bbe <vector108>:
.globl vector108
vector108:
  pushl $0
  105bbe:	6a 00                	push   $0x0
  pushl $108
  105bc0:	6a 6c                	push   $0x6c
  jmp alltraps
  105bc2:	e9 29 f7 ff ff       	jmp    1052f0 <alltraps>

00105bc7 <vector109>:
.globl vector109
vector109:
  pushl $0
  105bc7:	6a 00                	push   $0x0
  pushl $109
  105bc9:	6a 6d                	push   $0x6d
  jmp alltraps
  105bcb:	e9 20 f7 ff ff       	jmp    1052f0 <alltraps>

00105bd0 <vector110>:
.globl vector110
vector110:
  pushl $0
  105bd0:	6a 00                	push   $0x0
  pushl $110
  105bd2:	6a 6e                	push   $0x6e
  jmp alltraps
  105bd4:	e9 17 f7 ff ff       	jmp    1052f0 <alltraps>

00105bd9 <vector111>:
.globl vector111
vector111:
  pushl $0
  105bd9:	6a 00                	push   $0x0
  pushl $111
  105bdb:	6a 6f                	push   $0x6f
  jmp alltraps
  105bdd:	e9 0e f7 ff ff       	jmp    1052f0 <alltraps>

00105be2 <vector112>:
.globl vector112
vector112:
  pushl $0
  105be2:	6a 00                	push   $0x0
  pushl $112
  105be4:	6a 70                	push   $0x70
  jmp alltraps
  105be6:	e9 05 f7 ff ff       	jmp    1052f0 <alltraps>

00105beb <vector113>:
.globl vector113
vector113:
  pushl $0
  105beb:	6a 00                	push   $0x0
  pushl $113
  105bed:	6a 71                	push   $0x71
  jmp alltraps
  105bef:	e9 fc f6 ff ff       	jmp    1052f0 <alltraps>

00105bf4 <vector114>:
.globl vector114
vector114:
  pushl $0
  105bf4:	6a 00                	push   $0x0
  pushl $114
  105bf6:	6a 72                	push   $0x72
  jmp alltraps
  105bf8:	e9 f3 f6 ff ff       	jmp    1052f0 <alltraps>

00105bfd <vector115>:
.globl vector115
vector115:
  pushl $0
  105bfd:	6a 00                	push   $0x0
  pushl $115
  105bff:	6a 73                	push   $0x73
  jmp alltraps
  105c01:	e9 ea f6 ff ff       	jmp    1052f0 <alltraps>

00105c06 <vector116>:
.globl vector116
vector116:
  pushl $0
  105c06:	6a 00                	push   $0x0
  pushl $116
  105c08:	6a 74                	push   $0x74
  jmp alltraps
  105c0a:	e9 e1 f6 ff ff       	jmp    1052f0 <alltraps>

00105c0f <vector117>:
.globl vector117
vector117:
  pushl $0
  105c0f:	6a 00                	push   $0x0
  pushl $117
  105c11:	6a 75                	push   $0x75
  jmp alltraps
  105c13:	e9 d8 f6 ff ff       	jmp    1052f0 <alltraps>

00105c18 <vector118>:
.globl vector118
vector118:
  pushl $0
  105c18:	6a 00                	push   $0x0
  pushl $118
  105c1a:	6a 76                	push   $0x76
  jmp alltraps
  105c1c:	e9 cf f6 ff ff       	jmp    1052f0 <alltraps>

00105c21 <vector119>:
.globl vector119
vector119:
  pushl $0
  105c21:	6a 00                	push   $0x0
  pushl $119
  105c23:	6a 77                	push   $0x77
  jmp alltraps
  105c25:	e9 c6 f6 ff ff       	jmp    1052f0 <alltraps>

00105c2a <vector120>:
.globl vector120
vector120:
  pushl $0
  105c2a:	6a 00                	push   $0x0
  pushl $120
  105c2c:	6a 78                	push   $0x78
  jmp alltraps
  105c2e:	e9 bd f6 ff ff       	jmp    1052f0 <alltraps>

00105c33 <vector121>:
.globl vector121
vector121:
  pushl $0
  105c33:	6a 00                	push   $0x0
  pushl $121
  105c35:	6a 79                	push   $0x79
  jmp alltraps
  105c37:	e9 b4 f6 ff ff       	jmp    1052f0 <alltraps>

00105c3c <vector122>:
.globl vector122
vector122:
  pushl $0
  105c3c:	6a 00                	push   $0x0
  pushl $122
  105c3e:	6a 7a                	push   $0x7a
  jmp alltraps
  105c40:	e9 ab f6 ff ff       	jmp    1052f0 <alltraps>

00105c45 <vector123>:
.globl vector123
vector123:
  pushl $0
  105c45:	6a 00                	push   $0x0
  pushl $123
  105c47:	6a 7b                	push   $0x7b
  jmp alltraps
  105c49:	e9 a2 f6 ff ff       	jmp    1052f0 <alltraps>

00105c4e <vector124>:
.globl vector124
vector124:
  pushl $0
  105c4e:	6a 00                	push   $0x0
  pushl $124
  105c50:	6a 7c                	push   $0x7c
  jmp alltraps
  105c52:	e9 99 f6 ff ff       	jmp    1052f0 <alltraps>

00105c57 <vector125>:
.globl vector125
vector125:
  pushl $0
  105c57:	6a 00                	push   $0x0
  pushl $125
  105c59:	6a 7d                	push   $0x7d
  jmp alltraps
  105c5b:	e9 90 f6 ff ff       	jmp    1052f0 <alltraps>

00105c60 <vector126>:
.globl vector126
vector126:
  pushl $0
  105c60:	6a 00                	push   $0x0
  pushl $126
  105c62:	6a 7e                	push   $0x7e
  jmp alltraps
  105c64:	e9 87 f6 ff ff       	jmp    1052f0 <alltraps>

00105c69 <vector127>:
.globl vector127
vector127:
  pushl $0
  105c69:	6a 00                	push   $0x0
  pushl $127
  105c6b:	6a 7f                	push   $0x7f
  jmp alltraps
  105c6d:	e9 7e f6 ff ff       	jmp    1052f0 <alltraps>

00105c72 <vector128>:
.globl vector128
vector128:
  pushl $0
  105c72:	6a 00                	push   $0x0
  pushl $128
  105c74:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  105c79:	e9 72 f6 ff ff       	jmp    1052f0 <alltraps>

00105c7e <vector129>:
.globl vector129
vector129:
  pushl $0
  105c7e:	6a 00                	push   $0x0
  pushl $129
  105c80:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  105c85:	e9 66 f6 ff ff       	jmp    1052f0 <alltraps>

00105c8a <vector130>:
.globl vector130
vector130:
  pushl $0
  105c8a:	6a 00                	push   $0x0
  pushl $130
  105c8c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  105c91:	e9 5a f6 ff ff       	jmp    1052f0 <alltraps>

00105c96 <vector131>:
.globl vector131
vector131:
  pushl $0
  105c96:	6a 00                	push   $0x0
  pushl $131
  105c98:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  105c9d:	e9 4e f6 ff ff       	jmp    1052f0 <alltraps>

00105ca2 <vector132>:
.globl vector132
vector132:
  pushl $0
  105ca2:	6a 00                	push   $0x0
  pushl $132
  105ca4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  105ca9:	e9 42 f6 ff ff       	jmp    1052f0 <alltraps>

00105cae <vector133>:
.globl vector133
vector133:
  pushl $0
  105cae:	6a 00                	push   $0x0
  pushl $133
  105cb0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  105cb5:	e9 36 f6 ff ff       	jmp    1052f0 <alltraps>

00105cba <vector134>:
.globl vector134
vector134:
  pushl $0
  105cba:	6a 00                	push   $0x0
  pushl $134
  105cbc:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  105cc1:	e9 2a f6 ff ff       	jmp    1052f0 <alltraps>

00105cc6 <vector135>:
.globl vector135
vector135:
  pushl $0
  105cc6:	6a 00                	push   $0x0
  pushl $135
  105cc8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  105ccd:	e9 1e f6 ff ff       	jmp    1052f0 <alltraps>

00105cd2 <vector136>:
.globl vector136
vector136:
  pushl $0
  105cd2:	6a 00                	push   $0x0
  pushl $136
  105cd4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  105cd9:	e9 12 f6 ff ff       	jmp    1052f0 <alltraps>

00105cde <vector137>:
.globl vector137
vector137:
  pushl $0
  105cde:	6a 00                	push   $0x0
  pushl $137
  105ce0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  105ce5:	e9 06 f6 ff ff       	jmp    1052f0 <alltraps>

00105cea <vector138>:
.globl vector138
vector138:
  pushl $0
  105cea:	6a 00                	push   $0x0
  pushl $138
  105cec:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  105cf1:	e9 fa f5 ff ff       	jmp    1052f0 <alltraps>

00105cf6 <vector139>:
.globl vector139
vector139:
  pushl $0
  105cf6:	6a 00                	push   $0x0
  pushl $139
  105cf8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  105cfd:	e9 ee f5 ff ff       	jmp    1052f0 <alltraps>

00105d02 <vector140>:
.globl vector140
vector140:
  pushl $0
  105d02:	6a 00                	push   $0x0
  pushl $140
  105d04:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  105d09:	e9 e2 f5 ff ff       	jmp    1052f0 <alltraps>

00105d0e <vector141>:
.globl vector141
vector141:
  pushl $0
  105d0e:	6a 00                	push   $0x0
  pushl $141
  105d10:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  105d15:	e9 d6 f5 ff ff       	jmp    1052f0 <alltraps>

00105d1a <vector142>:
.globl vector142
vector142:
  pushl $0
  105d1a:	6a 00                	push   $0x0
  pushl $142
  105d1c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  105d21:	e9 ca f5 ff ff       	jmp    1052f0 <alltraps>

00105d26 <vector143>:
.globl vector143
vector143:
  pushl $0
  105d26:	6a 00                	push   $0x0
  pushl $143
  105d28:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  105d2d:	e9 be f5 ff ff       	jmp    1052f0 <alltraps>

00105d32 <vector144>:
.globl vector144
vector144:
  pushl $0
  105d32:	6a 00                	push   $0x0
  pushl $144
  105d34:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  105d39:	e9 b2 f5 ff ff       	jmp    1052f0 <alltraps>

00105d3e <vector145>:
.globl vector145
vector145:
  pushl $0
  105d3e:	6a 00                	push   $0x0
  pushl $145
  105d40:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  105d45:	e9 a6 f5 ff ff       	jmp    1052f0 <alltraps>

00105d4a <vector146>:
.globl vector146
vector146:
  pushl $0
  105d4a:	6a 00                	push   $0x0
  pushl $146
  105d4c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  105d51:	e9 9a f5 ff ff       	jmp    1052f0 <alltraps>

00105d56 <vector147>:
.globl vector147
vector147:
  pushl $0
  105d56:	6a 00                	push   $0x0
  pushl $147
  105d58:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  105d5d:	e9 8e f5 ff ff       	jmp    1052f0 <alltraps>

00105d62 <vector148>:
.globl vector148
vector148:
  pushl $0
  105d62:	6a 00                	push   $0x0
  pushl $148
  105d64:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  105d69:	e9 82 f5 ff ff       	jmp    1052f0 <alltraps>

00105d6e <vector149>:
.globl vector149
vector149:
  pushl $0
  105d6e:	6a 00                	push   $0x0
  pushl $149
  105d70:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  105d75:	e9 76 f5 ff ff       	jmp    1052f0 <alltraps>

00105d7a <vector150>:
.globl vector150
vector150:
  pushl $0
  105d7a:	6a 00                	push   $0x0
  pushl $150
  105d7c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  105d81:	e9 6a f5 ff ff       	jmp    1052f0 <alltraps>

00105d86 <vector151>:
.globl vector151
vector151:
  pushl $0
  105d86:	6a 00                	push   $0x0
  pushl $151
  105d88:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  105d8d:	e9 5e f5 ff ff       	jmp    1052f0 <alltraps>

00105d92 <vector152>:
.globl vector152
vector152:
  pushl $0
  105d92:	6a 00                	push   $0x0
  pushl $152
  105d94:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  105d99:	e9 52 f5 ff ff       	jmp    1052f0 <alltraps>

00105d9e <vector153>:
.globl vector153
vector153:
  pushl $0
  105d9e:	6a 00                	push   $0x0
  pushl $153
  105da0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  105da5:	e9 46 f5 ff ff       	jmp    1052f0 <alltraps>

00105daa <vector154>:
.globl vector154
vector154:
  pushl $0
  105daa:	6a 00                	push   $0x0
  pushl $154
  105dac:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  105db1:	e9 3a f5 ff ff       	jmp    1052f0 <alltraps>

00105db6 <vector155>:
.globl vector155
vector155:
  pushl $0
  105db6:	6a 00                	push   $0x0
  pushl $155
  105db8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  105dbd:	e9 2e f5 ff ff       	jmp    1052f0 <alltraps>

00105dc2 <vector156>:
.globl vector156
vector156:
  pushl $0
  105dc2:	6a 00                	push   $0x0
  pushl $156
  105dc4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  105dc9:	e9 22 f5 ff ff       	jmp    1052f0 <alltraps>

00105dce <vector157>:
.globl vector157
vector157:
  pushl $0
  105dce:	6a 00                	push   $0x0
  pushl $157
  105dd0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  105dd5:	e9 16 f5 ff ff       	jmp    1052f0 <alltraps>

00105dda <vector158>:
.globl vector158
vector158:
  pushl $0
  105dda:	6a 00                	push   $0x0
  pushl $158
  105ddc:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  105de1:	e9 0a f5 ff ff       	jmp    1052f0 <alltraps>

00105de6 <vector159>:
.globl vector159
vector159:
  pushl $0
  105de6:	6a 00                	push   $0x0
  pushl $159
  105de8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  105ded:	e9 fe f4 ff ff       	jmp    1052f0 <alltraps>

00105df2 <vector160>:
.globl vector160
vector160:
  pushl $0
  105df2:	6a 00                	push   $0x0
  pushl $160
  105df4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  105df9:	e9 f2 f4 ff ff       	jmp    1052f0 <alltraps>

00105dfe <vector161>:
.globl vector161
vector161:
  pushl $0
  105dfe:	6a 00                	push   $0x0
  pushl $161
  105e00:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  105e05:	e9 e6 f4 ff ff       	jmp    1052f0 <alltraps>

00105e0a <vector162>:
.globl vector162
vector162:
  pushl $0
  105e0a:	6a 00                	push   $0x0
  pushl $162
  105e0c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  105e11:	e9 da f4 ff ff       	jmp    1052f0 <alltraps>

00105e16 <vector163>:
.globl vector163
vector163:
  pushl $0
  105e16:	6a 00                	push   $0x0
  pushl $163
  105e18:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  105e1d:	e9 ce f4 ff ff       	jmp    1052f0 <alltraps>

00105e22 <vector164>:
.globl vector164
vector164:
  pushl $0
  105e22:	6a 00                	push   $0x0
  pushl $164
  105e24:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  105e29:	e9 c2 f4 ff ff       	jmp    1052f0 <alltraps>

00105e2e <vector165>:
.globl vector165
vector165:
  pushl $0
  105e2e:	6a 00                	push   $0x0
  pushl $165
  105e30:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  105e35:	e9 b6 f4 ff ff       	jmp    1052f0 <alltraps>

00105e3a <vector166>:
.globl vector166
vector166:
  pushl $0
  105e3a:	6a 00                	push   $0x0
  pushl $166
  105e3c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  105e41:	e9 aa f4 ff ff       	jmp    1052f0 <alltraps>

00105e46 <vector167>:
.globl vector167
vector167:
  pushl $0
  105e46:	6a 00                	push   $0x0
  pushl $167
  105e48:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  105e4d:	e9 9e f4 ff ff       	jmp    1052f0 <alltraps>

00105e52 <vector168>:
.globl vector168
vector168:
  pushl $0
  105e52:	6a 00                	push   $0x0
  pushl $168
  105e54:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  105e59:	e9 92 f4 ff ff       	jmp    1052f0 <alltraps>

00105e5e <vector169>:
.globl vector169
vector169:
  pushl $0
  105e5e:	6a 00                	push   $0x0
  pushl $169
  105e60:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  105e65:	e9 86 f4 ff ff       	jmp    1052f0 <alltraps>

00105e6a <vector170>:
.globl vector170
vector170:
  pushl $0
  105e6a:	6a 00                	push   $0x0
  pushl $170
  105e6c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  105e71:	e9 7a f4 ff ff       	jmp    1052f0 <alltraps>

00105e76 <vector171>:
.globl vector171
vector171:
  pushl $0
  105e76:	6a 00                	push   $0x0
  pushl $171
  105e78:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  105e7d:	e9 6e f4 ff ff       	jmp    1052f0 <alltraps>

00105e82 <vector172>:
.globl vector172
vector172:
  pushl $0
  105e82:	6a 00                	push   $0x0
  pushl $172
  105e84:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  105e89:	e9 62 f4 ff ff       	jmp    1052f0 <alltraps>

00105e8e <vector173>:
.globl vector173
vector173:
  pushl $0
  105e8e:	6a 00                	push   $0x0
  pushl $173
  105e90:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  105e95:	e9 56 f4 ff ff       	jmp    1052f0 <alltraps>

00105e9a <vector174>:
.globl vector174
vector174:
  pushl $0
  105e9a:	6a 00                	push   $0x0
  pushl $174
  105e9c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  105ea1:	e9 4a f4 ff ff       	jmp    1052f0 <alltraps>

00105ea6 <vector175>:
.globl vector175
vector175:
  pushl $0
  105ea6:	6a 00                	push   $0x0
  pushl $175
  105ea8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  105ead:	e9 3e f4 ff ff       	jmp    1052f0 <alltraps>

00105eb2 <vector176>:
.globl vector176
vector176:
  pushl $0
  105eb2:	6a 00                	push   $0x0
  pushl $176
  105eb4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  105eb9:	e9 32 f4 ff ff       	jmp    1052f0 <alltraps>

00105ebe <vector177>:
.globl vector177
vector177:
  pushl $0
  105ebe:	6a 00                	push   $0x0
  pushl $177
  105ec0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  105ec5:	e9 26 f4 ff ff       	jmp    1052f0 <alltraps>

00105eca <vector178>:
.globl vector178
vector178:
  pushl $0
  105eca:	6a 00                	push   $0x0
  pushl $178
  105ecc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  105ed1:	e9 1a f4 ff ff       	jmp    1052f0 <alltraps>

00105ed6 <vector179>:
.globl vector179
vector179:
  pushl $0
  105ed6:	6a 00                	push   $0x0
  pushl $179
  105ed8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  105edd:	e9 0e f4 ff ff       	jmp    1052f0 <alltraps>

00105ee2 <vector180>:
.globl vector180
vector180:
  pushl $0
  105ee2:	6a 00                	push   $0x0
  pushl $180
  105ee4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  105ee9:	e9 02 f4 ff ff       	jmp    1052f0 <alltraps>

00105eee <vector181>:
.globl vector181
vector181:
  pushl $0
  105eee:	6a 00                	push   $0x0
  pushl $181
  105ef0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  105ef5:	e9 f6 f3 ff ff       	jmp    1052f0 <alltraps>

00105efa <vector182>:
.globl vector182
vector182:
  pushl $0
  105efa:	6a 00                	push   $0x0
  pushl $182
  105efc:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  105f01:	e9 ea f3 ff ff       	jmp    1052f0 <alltraps>

00105f06 <vector183>:
.globl vector183
vector183:
  pushl $0
  105f06:	6a 00                	push   $0x0
  pushl $183
  105f08:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  105f0d:	e9 de f3 ff ff       	jmp    1052f0 <alltraps>

00105f12 <vector184>:
.globl vector184
vector184:
  pushl $0
  105f12:	6a 00                	push   $0x0
  pushl $184
  105f14:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  105f19:	e9 d2 f3 ff ff       	jmp    1052f0 <alltraps>

00105f1e <vector185>:
.globl vector185
vector185:
  pushl $0
  105f1e:	6a 00                	push   $0x0
  pushl $185
  105f20:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  105f25:	e9 c6 f3 ff ff       	jmp    1052f0 <alltraps>

00105f2a <vector186>:
.globl vector186
vector186:
  pushl $0
  105f2a:	6a 00                	push   $0x0
  pushl $186
  105f2c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  105f31:	e9 ba f3 ff ff       	jmp    1052f0 <alltraps>

00105f36 <vector187>:
.globl vector187
vector187:
  pushl $0
  105f36:	6a 00                	push   $0x0
  pushl $187
  105f38:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  105f3d:	e9 ae f3 ff ff       	jmp    1052f0 <alltraps>

00105f42 <vector188>:
.globl vector188
vector188:
  pushl $0
  105f42:	6a 00                	push   $0x0
  pushl $188
  105f44:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  105f49:	e9 a2 f3 ff ff       	jmp    1052f0 <alltraps>

00105f4e <vector189>:
.globl vector189
vector189:
  pushl $0
  105f4e:	6a 00                	push   $0x0
  pushl $189
  105f50:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  105f55:	e9 96 f3 ff ff       	jmp    1052f0 <alltraps>

00105f5a <vector190>:
.globl vector190
vector190:
  pushl $0
  105f5a:	6a 00                	push   $0x0
  pushl $190
  105f5c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  105f61:	e9 8a f3 ff ff       	jmp    1052f0 <alltraps>

00105f66 <vector191>:
.globl vector191
vector191:
  pushl $0
  105f66:	6a 00                	push   $0x0
  pushl $191
  105f68:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  105f6d:	e9 7e f3 ff ff       	jmp    1052f0 <alltraps>

00105f72 <vector192>:
.globl vector192
vector192:
  pushl $0
  105f72:	6a 00                	push   $0x0
  pushl $192
  105f74:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  105f79:	e9 72 f3 ff ff       	jmp    1052f0 <alltraps>

00105f7e <vector193>:
.globl vector193
vector193:
  pushl $0
  105f7e:	6a 00                	push   $0x0
  pushl $193
  105f80:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  105f85:	e9 66 f3 ff ff       	jmp    1052f0 <alltraps>

00105f8a <vector194>:
.globl vector194
vector194:
  pushl $0
  105f8a:	6a 00                	push   $0x0
  pushl $194
  105f8c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  105f91:	e9 5a f3 ff ff       	jmp    1052f0 <alltraps>

00105f96 <vector195>:
.globl vector195
vector195:
  pushl $0
  105f96:	6a 00                	push   $0x0
  pushl $195
  105f98:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  105f9d:	e9 4e f3 ff ff       	jmp    1052f0 <alltraps>

00105fa2 <vector196>:
.globl vector196
vector196:
  pushl $0
  105fa2:	6a 00                	push   $0x0
  pushl $196
  105fa4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  105fa9:	e9 42 f3 ff ff       	jmp    1052f0 <alltraps>

00105fae <vector197>:
.globl vector197
vector197:
  pushl $0
  105fae:	6a 00                	push   $0x0
  pushl $197
  105fb0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  105fb5:	e9 36 f3 ff ff       	jmp    1052f0 <alltraps>

00105fba <vector198>:
.globl vector198
vector198:
  pushl $0
  105fba:	6a 00                	push   $0x0
  pushl $198
  105fbc:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  105fc1:	e9 2a f3 ff ff       	jmp    1052f0 <alltraps>

00105fc6 <vector199>:
.globl vector199
vector199:
  pushl $0
  105fc6:	6a 00                	push   $0x0
  pushl $199
  105fc8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  105fcd:	e9 1e f3 ff ff       	jmp    1052f0 <alltraps>

00105fd2 <vector200>:
.globl vector200
vector200:
  pushl $0
  105fd2:	6a 00                	push   $0x0
  pushl $200
  105fd4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  105fd9:	e9 12 f3 ff ff       	jmp    1052f0 <alltraps>

00105fde <vector201>:
.globl vector201
vector201:
  pushl $0
  105fde:	6a 00                	push   $0x0
  pushl $201
  105fe0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  105fe5:	e9 06 f3 ff ff       	jmp    1052f0 <alltraps>

00105fea <vector202>:
.globl vector202
vector202:
  pushl $0
  105fea:	6a 00                	push   $0x0
  pushl $202
  105fec:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  105ff1:	e9 fa f2 ff ff       	jmp    1052f0 <alltraps>

00105ff6 <vector203>:
.globl vector203
vector203:
  pushl $0
  105ff6:	6a 00                	push   $0x0
  pushl $203
  105ff8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  105ffd:	e9 ee f2 ff ff       	jmp    1052f0 <alltraps>

00106002 <vector204>:
.globl vector204
vector204:
  pushl $0
  106002:	6a 00                	push   $0x0
  pushl $204
  106004:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  106009:	e9 e2 f2 ff ff       	jmp    1052f0 <alltraps>

0010600e <vector205>:
.globl vector205
vector205:
  pushl $0
  10600e:	6a 00                	push   $0x0
  pushl $205
  106010:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  106015:	e9 d6 f2 ff ff       	jmp    1052f0 <alltraps>

0010601a <vector206>:
.globl vector206
vector206:
  pushl $0
  10601a:	6a 00                	push   $0x0
  pushl $206
  10601c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  106021:	e9 ca f2 ff ff       	jmp    1052f0 <alltraps>

00106026 <vector207>:
.globl vector207
vector207:
  pushl $0
  106026:	6a 00                	push   $0x0
  pushl $207
  106028:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  10602d:	e9 be f2 ff ff       	jmp    1052f0 <alltraps>

00106032 <vector208>:
.globl vector208
vector208:
  pushl $0
  106032:	6a 00                	push   $0x0
  pushl $208
  106034:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  106039:	e9 b2 f2 ff ff       	jmp    1052f0 <alltraps>

0010603e <vector209>:
.globl vector209
vector209:
  pushl $0
  10603e:	6a 00                	push   $0x0
  pushl $209
  106040:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  106045:	e9 a6 f2 ff ff       	jmp    1052f0 <alltraps>

0010604a <vector210>:
.globl vector210
vector210:
  pushl $0
  10604a:	6a 00                	push   $0x0
  pushl $210
  10604c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  106051:	e9 9a f2 ff ff       	jmp    1052f0 <alltraps>

00106056 <vector211>:
.globl vector211
vector211:
  pushl $0
  106056:	6a 00                	push   $0x0
  pushl $211
  106058:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  10605d:	e9 8e f2 ff ff       	jmp    1052f0 <alltraps>

00106062 <vector212>:
.globl vector212
vector212:
  pushl $0
  106062:	6a 00                	push   $0x0
  pushl $212
  106064:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  106069:	e9 82 f2 ff ff       	jmp    1052f0 <alltraps>

0010606e <vector213>:
.globl vector213
vector213:
  pushl $0
  10606e:	6a 00                	push   $0x0
  pushl $213
  106070:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  106075:	e9 76 f2 ff ff       	jmp    1052f0 <alltraps>

0010607a <vector214>:
.globl vector214
vector214:
  pushl $0
  10607a:	6a 00                	push   $0x0
  pushl $214
  10607c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  106081:	e9 6a f2 ff ff       	jmp    1052f0 <alltraps>

00106086 <vector215>:
.globl vector215
vector215:
  pushl $0
  106086:	6a 00                	push   $0x0
  pushl $215
  106088:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  10608d:	e9 5e f2 ff ff       	jmp    1052f0 <alltraps>

00106092 <vector216>:
.globl vector216
vector216:
  pushl $0
  106092:	6a 00                	push   $0x0
  pushl $216
  106094:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  106099:	e9 52 f2 ff ff       	jmp    1052f0 <alltraps>

0010609e <vector217>:
.globl vector217
vector217:
  pushl $0
  10609e:	6a 00                	push   $0x0
  pushl $217
  1060a0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  1060a5:	e9 46 f2 ff ff       	jmp    1052f0 <alltraps>

001060aa <vector218>:
.globl vector218
vector218:
  pushl $0
  1060aa:	6a 00                	push   $0x0
  pushl $218
  1060ac:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  1060b1:	e9 3a f2 ff ff       	jmp    1052f0 <alltraps>

001060b6 <vector219>:
.globl vector219
vector219:
  pushl $0
  1060b6:	6a 00                	push   $0x0
  pushl $219
  1060b8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  1060bd:	e9 2e f2 ff ff       	jmp    1052f0 <alltraps>

001060c2 <vector220>:
.globl vector220
vector220:
  pushl $0
  1060c2:	6a 00                	push   $0x0
  pushl $220
  1060c4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  1060c9:	e9 22 f2 ff ff       	jmp    1052f0 <alltraps>

001060ce <vector221>:
.globl vector221
vector221:
  pushl $0
  1060ce:	6a 00                	push   $0x0
  pushl $221
  1060d0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  1060d5:	e9 16 f2 ff ff       	jmp    1052f0 <alltraps>

001060da <vector222>:
.globl vector222
vector222:
  pushl $0
  1060da:	6a 00                	push   $0x0
  pushl $222
  1060dc:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  1060e1:	e9 0a f2 ff ff       	jmp    1052f0 <alltraps>

001060e6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1060e6:	6a 00                	push   $0x0
  pushl $223
  1060e8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  1060ed:	e9 fe f1 ff ff       	jmp    1052f0 <alltraps>

001060f2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1060f2:	6a 00                	push   $0x0
  pushl $224
  1060f4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  1060f9:	e9 f2 f1 ff ff       	jmp    1052f0 <alltraps>

001060fe <vector225>:
.globl vector225
vector225:
  pushl $0
  1060fe:	6a 00                	push   $0x0
  pushl $225
  106100:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  106105:	e9 e6 f1 ff ff       	jmp    1052f0 <alltraps>

0010610a <vector226>:
.globl vector226
vector226:
  pushl $0
  10610a:	6a 00                	push   $0x0
  pushl $226
  10610c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  106111:	e9 da f1 ff ff       	jmp    1052f0 <alltraps>

00106116 <vector227>:
.globl vector227
vector227:
  pushl $0
  106116:	6a 00                	push   $0x0
  pushl $227
  106118:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  10611d:	e9 ce f1 ff ff       	jmp    1052f0 <alltraps>

00106122 <vector228>:
.globl vector228
vector228:
  pushl $0
  106122:	6a 00                	push   $0x0
  pushl $228
  106124:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  106129:	e9 c2 f1 ff ff       	jmp    1052f0 <alltraps>

0010612e <vector229>:
.globl vector229
vector229:
  pushl $0
  10612e:	6a 00                	push   $0x0
  pushl $229
  106130:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  106135:	e9 b6 f1 ff ff       	jmp    1052f0 <alltraps>

0010613a <vector230>:
.globl vector230
vector230:
  pushl $0
  10613a:	6a 00                	push   $0x0
  pushl $230
  10613c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  106141:	e9 aa f1 ff ff       	jmp    1052f0 <alltraps>

00106146 <vector231>:
.globl vector231
vector231:
  pushl $0
  106146:	6a 00                	push   $0x0
  pushl $231
  106148:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  10614d:	e9 9e f1 ff ff       	jmp    1052f0 <alltraps>

00106152 <vector232>:
.globl vector232
vector232:
  pushl $0
  106152:	6a 00                	push   $0x0
  pushl $232
  106154:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  106159:	e9 92 f1 ff ff       	jmp    1052f0 <alltraps>

0010615e <vector233>:
.globl vector233
vector233:
  pushl $0
  10615e:	6a 00                	push   $0x0
  pushl $233
  106160:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  106165:	e9 86 f1 ff ff       	jmp    1052f0 <alltraps>

0010616a <vector234>:
.globl vector234
vector234:
  pushl $0
  10616a:	6a 00                	push   $0x0
  pushl $234
  10616c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  106171:	e9 7a f1 ff ff       	jmp    1052f0 <alltraps>

00106176 <vector235>:
.globl vector235
vector235:
  pushl $0
  106176:	6a 00                	push   $0x0
  pushl $235
  106178:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  10617d:	e9 6e f1 ff ff       	jmp    1052f0 <alltraps>

00106182 <vector236>:
.globl vector236
vector236:
  pushl $0
  106182:	6a 00                	push   $0x0
  pushl $236
  106184:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  106189:	e9 62 f1 ff ff       	jmp    1052f0 <alltraps>

0010618e <vector237>:
.globl vector237
vector237:
  pushl $0
  10618e:	6a 00                	push   $0x0
  pushl $237
  106190:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  106195:	e9 56 f1 ff ff       	jmp    1052f0 <alltraps>

0010619a <vector238>:
.globl vector238
vector238:
  pushl $0
  10619a:	6a 00                	push   $0x0
  pushl $238
  10619c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  1061a1:	e9 4a f1 ff ff       	jmp    1052f0 <alltraps>

001061a6 <vector239>:
.globl vector239
vector239:
  pushl $0
  1061a6:	6a 00                	push   $0x0
  pushl $239
  1061a8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  1061ad:	e9 3e f1 ff ff       	jmp    1052f0 <alltraps>

001061b2 <vector240>:
.globl vector240
vector240:
  pushl $0
  1061b2:	6a 00                	push   $0x0
  pushl $240
  1061b4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  1061b9:	e9 32 f1 ff ff       	jmp    1052f0 <alltraps>

001061be <vector241>:
.globl vector241
vector241:
  pushl $0
  1061be:	6a 00                	push   $0x0
  pushl $241
  1061c0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  1061c5:	e9 26 f1 ff ff       	jmp    1052f0 <alltraps>

001061ca <vector242>:
.globl vector242
vector242:
  pushl $0
  1061ca:	6a 00                	push   $0x0
  pushl $242
  1061cc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  1061d1:	e9 1a f1 ff ff       	jmp    1052f0 <alltraps>

001061d6 <vector243>:
.globl vector243
vector243:
  pushl $0
  1061d6:	6a 00                	push   $0x0
  pushl $243
  1061d8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  1061dd:	e9 0e f1 ff ff       	jmp    1052f0 <alltraps>

001061e2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1061e2:	6a 00                	push   $0x0
  pushl $244
  1061e4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  1061e9:	e9 02 f1 ff ff       	jmp    1052f0 <alltraps>

001061ee <vector245>:
.globl vector245
vector245:
  pushl $0
  1061ee:	6a 00                	push   $0x0
  pushl $245
  1061f0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  1061f5:	e9 f6 f0 ff ff       	jmp    1052f0 <alltraps>

001061fa <vector246>:
.globl vector246
vector246:
  pushl $0
  1061fa:	6a 00                	push   $0x0
  pushl $246
  1061fc:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  106201:	e9 ea f0 ff ff       	jmp    1052f0 <alltraps>

00106206 <vector247>:
.globl vector247
vector247:
  pushl $0
  106206:	6a 00                	push   $0x0
  pushl $247
  106208:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  10620d:	e9 de f0 ff ff       	jmp    1052f0 <alltraps>

00106212 <vector248>:
.globl vector248
vector248:
  pushl $0
  106212:	6a 00                	push   $0x0
  pushl $248
  106214:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  106219:	e9 d2 f0 ff ff       	jmp    1052f0 <alltraps>

0010621e <vector249>:
.globl vector249
vector249:
  pushl $0
  10621e:	6a 00                	push   $0x0
  pushl $249
  106220:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  106225:	e9 c6 f0 ff ff       	jmp    1052f0 <alltraps>

0010622a <vector250>:
.globl vector250
vector250:
  pushl $0
  10622a:	6a 00                	push   $0x0
  pushl $250
  10622c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  106231:	e9 ba f0 ff ff       	jmp    1052f0 <alltraps>

00106236 <vector251>:
.globl vector251
vector251:
  pushl $0
  106236:	6a 00                	push   $0x0
  pushl $251
  106238:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  10623d:	e9 ae f0 ff ff       	jmp    1052f0 <alltraps>

00106242 <vector252>:
.globl vector252
vector252:
  pushl $0
  106242:	6a 00                	push   $0x0
  pushl $252
  106244:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  106249:	e9 a2 f0 ff ff       	jmp    1052f0 <alltraps>

0010624e <vector253>:
.globl vector253
vector253:
  pushl $0
  10624e:	6a 00                	push   $0x0
  pushl $253
  106250:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  106255:	e9 96 f0 ff ff       	jmp    1052f0 <alltraps>

0010625a <vector254>:
.globl vector254
vector254:
  pushl $0
  10625a:	6a 00                	push   $0x0
  pushl $254
  10625c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  106261:	e9 8a f0 ff ff       	jmp    1052f0 <alltraps>

00106266 <vector255>:
.globl vector255
vector255:
  pushl $0
  106266:	6a 00                	push   $0x0
  pushl $255
  106268:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  10626d:	e9 7e f0 ff ff       	jmp    1052f0 <alltraps>
  106272:	90                   	nop
  106273:	90                   	nop
  106274:	90                   	nop
  106275:	90                   	nop
  106276:	90                   	nop
  106277:	90                   	nop
  106278:	90                   	nop
  106279:	90                   	nop
  10627a:	90                   	nop
  10627b:	90                   	nop
  10627c:	90                   	nop
  10627d:	90                   	nop
  10627e:	90                   	nop
  10627f:	90                   	nop

00106280 <vmenable>:
}

// Turn on paging.
void
vmenable(void)
{
  106280:	55                   	push   %ebp
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  106281:	a1 d4 92 10 00       	mov    0x1092d4,%eax
  106286:	89 e5                	mov    %esp,%ebp
  106288:	0f 22 d8             	mov    %eax,%cr3

static inline uint
rcr0(void)
{
  uint val;
  asm volatile("movl %%cr0,%0" : "=r" (val));
  10628b:	0f 20 c0             	mov    %cr0,%eax
}

static inline void
lcr0(uint val)
{
  asm volatile("movl %0,%%cr0" : : "r" (val));
  10628e:	0d 00 00 00 80       	or     $0x80000000,%eax
  106293:	0f 22 c0             	mov    %eax,%cr0

  switchkvm(); // load kpgdir into cr3
  cr0 = rcr0();
  cr0 |= CR0_PG;
  lcr0(cr0);
}
  106296:	5d                   	pop    %ebp
  106297:	c3                   	ret    
  106298:	90                   	nop
  106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001062a0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm()
{
  1062a0:	55                   	push   %ebp
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  1062a1:	a1 d4 92 10 00       	mov    0x1092d4,%eax
  1062a6:	89 e5                	mov    %esp,%ebp
  1062a8:	0f 22 d8             	mov    %eax,%cr3
  lcr3(PADDR(kpgdir));   // switch to the kernel page table
}
  1062ab:	5d                   	pop    %ebp
  1062ac:	c3                   	ret    
  1062ad:	8d 76 00             	lea    0x0(%esi),%esi

001062b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to linear address va.  If create!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int create)
{
  1062b0:	55                   	push   %ebp
  1062b1:	89 e5                	mov    %esp,%ebp
  1062b3:	83 ec 28             	sub    $0x28,%esp
  1062b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  uint r;
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  1062b9:	89 d3                	mov    %edx,%ebx
  1062bb:	c1 eb 16             	shr    $0x16,%ebx
  1062be:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
// Return the address of the PTE in page table pgdir
// that corresponds to linear address va.  If create!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int create)
{
  1062c1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  uint r;
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
  1062c4:	8b 33                	mov    (%ebx),%esi
  1062c6:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1062cc:	74 22                	je     1062f0 <walkpgdir+0x40>
    pgtab = (pte_t*) PTE_ADDR(*pde);
  1062ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
  1062d4:	c1 ea 0a             	shr    $0xa,%edx
  1062d7:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
  1062dd:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
  1062e0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1062e3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1062e6:	89 ec                	mov    %ebp,%esp
  1062e8:	5d                   	pop    %ebp
  1062e9:	c3                   	ret    
  1062ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*) PTE_ADDR(*pde);
  } else if(!create || !(r = (uint) kalloc()))
  1062f0:	85 c9                	test   %ecx,%ecx
  1062f2:	75 04                	jne    1062f8 <walkpgdir+0x48>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
  1062f4:	31 c0                	xor    %eax,%eax
  1062f6:	eb e8                	jmp    1062e0 <walkpgdir+0x30>
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*) PTE_ADDR(*pde);
  } else if(!create || !(r = (uint) kalloc()))
  1062f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1062fb:	90                   	nop
  1062fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106300:	e8 2b c1 ff ff       	call   102430 <kalloc>
  106305:	85 c0                	test   %eax,%eax
  106307:	74 eb                	je     1062f4 <walkpgdir+0x44>
    return 0;
  else {
    pgtab = (pte_t*) r;
  106309:	89 c6                	mov    %eax,%esi
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
  10630b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106312:	00 
  106313:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10631a:	00 
  10631b:	89 04 24             	mov    %eax,(%esp)
  10631e:	e8 3d de ff ff       	call   104160 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  106323:	89 f0                	mov    %esi,%eax
  106325:	83 c8 07             	or     $0x7,%eax
  106328:	89 03                	mov    %eax,(%ebx)
  10632a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10632d:	eb a5                	jmp    1062d4 <walkpgdir+0x24>
  10632f:	90                   	nop

00106330 <mappages>:
// Create PTEs for linear addresses starting at la that refer to
// physical addresses starting at pa. la and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *la, uint size, uint pa, int perm)
{
  106330:	55                   	push   %ebp
  106331:	89 e5                	mov    %esp,%ebp
  106333:	57                   	push   %edi
  106334:	56                   	push   %esi
  106335:	53                   	push   %ebx
  char *a = PGROUNDDOWN(la);
  106336:	89 d3                	mov    %edx,%ebx
  char *last = PGROUNDDOWN(la + size - 1);
  106338:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
// Create PTEs for linear addresses starting at la that refer to
// physical addresses starting at pa. la and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *la, uint size, uint pa, int perm)
{
  10633c:	83 ec 2c             	sub    $0x2c,%esp
  10633f:	8b 75 08             	mov    0x8(%ebp),%esi
  106342:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a = PGROUNDDOWN(la);
  106345:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(la + size - 1);
  10634b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
  106351:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  106355:	eb 1d                	jmp    106374 <mappages+0x44>
  106357:	90                   	nop

  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
  106358:	f6 00 01             	testb  $0x1,(%eax)
  10635b:	75 48                	jne    1063a5 <mappages+0x75>
      panic("remap");
    *pte = pa | perm | PTE_P;
  10635d:	8b 55 0c             	mov    0xc(%ebp),%edx
  106360:	09 f2                	or     %esi,%edx
    if(a == last)
  106362:	39 fb                	cmp    %edi,%ebx
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
  106364:	89 10                	mov    %edx,(%eax)
    if(a == last)
  106366:	74 30                	je     106398 <mappages+0x68>
      break;
    a += PGSIZE;
  106368:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
  10636e:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
  char *a = PGROUNDDOWN(la);
  char *last = PGROUNDDOWN(la + size - 1);

  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
  106374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106377:	b9 01 00 00 00       	mov    $0x1,%ecx
  10637c:	89 da                	mov    %ebx,%edx
  10637e:	e8 2d ff ff ff       	call   1062b0 <walkpgdir>
    if(pte == 0)
  106383:	85 c0                	test   %eax,%eax
  106385:	75 d1                	jne    106358 <mappages+0x28>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 1;
}
  106387:	83 c4 2c             	add    $0x2c,%esp
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  10638a:	31 c0                	xor    %eax,%eax
  return 1;
}
  10638c:	5b                   	pop    %ebx
  10638d:	5e                   	pop    %esi
  10638e:	5f                   	pop    %edi
  10638f:	5d                   	pop    %ebp
  106390:	c3                   	ret    
  106391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106398:	83 c4 2c             	add    $0x2c,%esp
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
  10639b:	b8 01 00 00 00       	mov    $0x1,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 1;
}
  1063a0:	5b                   	pop    %ebx
  1063a1:	5e                   	pop    %esi
  1063a2:	5f                   	pop    %edi
  1063a3:	5d                   	pop    %ebp
  1063a4:	c3                   	ret    
  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
  1063a5:	c7 04 24 34 73 10 00 	movl   $0x107334,(%esp)
  1063ac:	e8 df a6 ff ff       	call   100a90 <panic>
  1063b1:	eb 0d                	jmp    1063c0 <uva2ka>
  1063b3:	90                   	nop
  1063b4:	90                   	nop
  1063b5:	90                   	nop
  1063b6:	90                   	nop
  1063b7:	90                   	nop
  1063b8:	90                   	nop
  1063b9:	90                   	nop
  1063ba:	90                   	nop
  1063bb:	90                   	nop
  1063bc:	90                   	nop
  1063bd:	90                   	nop
  1063be:	90                   	nop
  1063bf:	90                   	nop

001063c0 <uva2ka>:
// maps to.  The result is also a kernel logical address,
// since the kernel maps the physical memory allocated to user
// processes directly.
char*
uva2ka(pde_t *pgdir, char *uva)
{    
  1063c0:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, uva, 0);
  1063c1:	31 c9                	xor    %ecx,%ecx
// maps to.  The result is also a kernel logical address,
// since the kernel maps the physical memory allocated to user
// processes directly.
char*
uva2ka(pde_t *pgdir, char *uva)
{    
  1063c3:	89 e5                	mov    %esp,%ebp
  1063c5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, uva, 0);
  1063c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1063cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1063ce:	e8 dd fe ff ff       	call   1062b0 <walkpgdir>
  1063d3:	89 c2                	mov    %eax,%edx
  if(pte == 0) return 0;
  1063d5:	31 c0                	xor    %eax,%eax
  1063d7:	85 d2                	test   %edx,%edx
  1063d9:	74 07                	je     1063e2 <uva2ka+0x22>
  uint pa = PTE_ADDR(*pte);
  return (char *)pa;
  1063db:	8b 02                	mov    (%edx),%eax
  1063dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
  1063e2:	c9                   	leave  
  1063e3:	c3                   	ret    
  1063e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1063ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001063f0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  1063f0:	55                   	push   %ebp
  1063f1:	89 e5                	mov    %esp,%ebp
  1063f3:	83 ec 38             	sub    $0x38,%esp
  1063f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1063f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1063fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1063ff:	8b 75 10             	mov    0x10(%ebp),%esi
  106402:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106405:	8b 7d 0c             	mov    0xc(%ebp),%edi
  106408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem = kalloc();
  10640b:	e8 20 c0 ff ff       	call   102430 <kalloc>
  if (sz >= PGSIZE)
  106410:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = kalloc();
  106416:	89 c3                	mov    %eax,%ebx
  if (sz >= PGSIZE)
  106418:	77 4c                	ja     106466 <inituvm+0x76>
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  10641a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106421:	00 
  106422:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106429:	00 
  10642a:	89 04 24             	mov    %eax,(%esp)
  10642d:	e8 2e dd ff ff       	call   104160 <memset>
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  106432:	b9 00 10 00 00       	mov    $0x1000,%ecx
  106437:	31 d2                	xor    %edx,%edx
  106439:	89 1c 24             	mov    %ebx,(%esp)
  10643c:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  106443:	00 
  106444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106447:	e8 e4 fe ff ff       	call   106330 <mappages>
  memmove(mem, init, sz);
  10644c:	89 75 10             	mov    %esi,0x10(%ebp)
}
  10644f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106452:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
  106455:	8b 7d fc             	mov    -0x4(%ebp),%edi
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106458:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10645b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10645e:	89 ec                	mov    %ebp,%esp
  106460:	5d                   	pop    %ebp
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106461:	e9 7a dd ff ff       	jmp    1041e0 <memmove>
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  106466:	c7 04 24 3a 73 10 00 	movl   $0x10733a,(%esp)
  10646d:	e8 1e a6 ff ff       	call   100a90 <panic>
  106472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106480 <setupkvm>:
}

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  106480:	55                   	push   %ebp
  106481:	89 e5                	mov    %esp,%ebp
  106483:	53                   	push   %ebx
  106484:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
  106487:	e8 a4 bf ff ff       	call   102430 <kalloc>
  10648c:	85 c0                	test   %eax,%eax
  10648e:	89 c3                	mov    %eax,%ebx
  106490:	75 0e                	jne    1064a0 <setupkvm+0x20>
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
    return 0;
  return pgdir;
}
  106492:	89 d8                	mov    %ebx,%eax
  106494:	83 c4 14             	add    $0x14,%esp
  106497:	5b                   	pop    %ebx
  106498:	5d                   	pop    %ebp
  106499:	c3                   	ret    
  10649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde_t *pgdir;

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  1064a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1064a7:	00 
  1064a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1064af:	00 
  1064b0:	89 04 24             	mov    %eax,(%esp)
  1064b3:	e8 a8 dc ff ff       	call   104160 <memset>
  if(// Map IO space from 640K to 1Mbyte
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
  1064b8:	b9 00 00 06 00       	mov    $0x60000,%ecx
  1064bd:	ba 00 00 0a 00       	mov    $0xa0000,%edx
  1064c2:	89 d8                	mov    %ebx,%eax
  1064c4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1064cb:	00 
  1064cc:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  1064d3:	e8 58 fe ff ff       	call   106330 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  1064d8:	85 c0                	test   %eax,%eax
  1064da:	75 0a                	jne    1064e6 <setupkvm+0x66>
  1064dc:	31 db                	xor    %ebx,%ebx
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
    return 0;
  return pgdir;
}
  1064de:	83 c4 14             	add    $0x14,%esp
  1064e1:	89 d8                	mov    %ebx,%eax
  1064e3:	5b                   	pop    %ebx
  1064e4:	5d                   	pop    %ebp
  1064e5:	c3                   	ret    
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
     // Map kernel and free memory pool
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
  1064e6:	b9 00 00 f0 00       	mov    $0xf00000,%ecx
  1064eb:	ba 00 00 10 00       	mov    $0x100000,%edx
  1064f0:	89 d8                	mov    %ebx,%eax
  1064f2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1064f9:	00 
  1064fa:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
  106501:	e8 2a fe ff ff       	call   106330 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  106506:	85 c0                	test   %eax,%eax
  106508:	74 d2                	je     1064dc <setupkvm+0x5c>
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
     // Map kernel and free memory pool
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
  10650a:	b9 00 00 00 02       	mov    $0x2000000,%ecx
  10650f:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
  106514:	89 d8                	mov    %ebx,%eax
  106516:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10651d:	00 
  10651e:	c7 04 24 00 00 00 fe 	movl   $0xfe000000,(%esp)
  106525:	e8 06 fe ff ff       	call   106330 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  10652a:	85 c0                	test   %eax,%eax
  10652c:	0f 85 60 ff ff ff    	jne    106492 <setupkvm+0x12>
  106532:	eb a8                	jmp    1064dc <setupkvm+0x5c>
  106534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10653a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106540 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  106540:	55                   	push   %ebp
  106541:	89 e5                	mov    %esp,%ebp
  106543:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
  106546:	e8 35 ff ff ff       	call   106480 <setupkvm>
  10654b:	a3 d4 92 10 00       	mov    %eax,0x1092d4
}
  106550:	c9                   	leave  
  106551:	c3                   	ret    
  106552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106560 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106560:	55                   	push   %ebp
  106561:	89 e5                	mov    %esp,%ebp
  106563:	57                   	push   %edi
  106564:	56                   	push   %esi
  106565:	53                   	push   %ebx
  106566:	83 ec 2c             	sub    $0x2c,%esp
  char *a = (char *)PGROUNDUP(newsz);
  106569:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  10656c:	8b 75 0c             	mov    0xc(%ebp),%esi
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  10656f:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a = (char *)PGROUNDUP(newsz);
  106572:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  106578:	83 ee 01             	sub    $0x1,%esi
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  10657b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  106581:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a <= last; a += PGSIZE){
  106587:	39 f3                	cmp    %esi,%ebx
  106589:	77 41                	ja     1065cc <deallocuvm+0x6c>
  10658b:	90                   	nop
  10658c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte_t *pte = walkpgdir(pgdir, a, 0);
  106590:	31 c9                	xor    %ecx,%ecx
  106592:	89 da                	mov    %ebx,%edx
  106594:	89 f8                	mov    %edi,%eax
  106596:	e8 15 fd ff ff       	call   1062b0 <walkpgdir>
    if(pte && (*pte & PTE_P) != 0){
  10659b:	85 c0                	test   %eax,%eax
  10659d:	74 23                	je     1065c2 <deallocuvm+0x62>
  10659f:	8b 10                	mov    (%eax),%edx
  1065a1:	f6 c2 01             	test   $0x1,%dl
  1065a4:	74 1c                	je     1065c2 <deallocuvm+0x62>
      uint pa = PTE_ADDR(*pte);
      if(pa == 0)
  1065a6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1065ac:	74 3d                	je     1065eb <deallocuvm+0x8b>
        panic("kfree");
      kfree((void *) pa);
  1065ae:	89 14 24             	mov    %edx,(%esp)
  1065b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1065b4:	e8 b7 be ff ff       	call   102470 <kfree>
      *pte = 0;
  1065b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1065bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  char *last = PGROUNDDOWN(oldsz - 1);
  for(; a <= last; a += PGSIZE){
  1065c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  1065c8:	39 de                	cmp    %ebx,%esi
  1065ca:	73 c4                	jae    106590 <deallocuvm+0x30>
  1065cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1065cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1065d2:	77 0c                	ja     1065e0 <deallocuvm+0x80>
      kfree((void *) pa);
      *pte = 0;
    }
  }
  return newsz < oldsz ? newsz : oldsz;
}
  1065d4:	83 c4 2c             	add    $0x2c,%esp
  1065d7:	5b                   	pop    %ebx
  1065d8:	5e                   	pop    %esi
  1065d9:	5f                   	pop    %edi
  1065da:	5d                   	pop    %ebp
  1065db:	c3                   	ret    
  1065dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  char *last = PGROUNDDOWN(oldsz - 1);
  for(; a <= last; a += PGSIZE){
  1065e0:	8b 45 0c             	mov    0xc(%ebp),%eax
      kfree((void *) pa);
      *pte = 0;
    }
  }
  return newsz < oldsz ? newsz : oldsz;
}
  1065e3:	83 c4 2c             	add    $0x2c,%esp
  1065e6:	5b                   	pop    %ebx
  1065e7:	5e                   	pop    %esi
  1065e8:	5f                   	pop    %edi
  1065e9:	5d                   	pop    %ebp
  1065ea:	c3                   	ret    
  for(; a <= last; a += PGSIZE){
    pte_t *pte = walkpgdir(pgdir, a, 0);
    if(pte && (*pte & PTE_P) != 0){
      uint pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
  1065eb:	c7 04 24 96 6c 10 00 	movl   $0x106c96,(%esp)
  1065f2:	e8 99 a4 ff ff       	call   100a90 <panic>
  1065f7:	89 f6                	mov    %esi,%esi
  1065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106600 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  106600:	55                   	push   %ebp
  106601:	89 e5                	mov    %esp,%ebp
  106603:	56                   	push   %esi
  106604:	53                   	push   %ebx
  106605:	83 ec 10             	sub    $0x10,%esp
  106608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(!pgdir)
  10660b:	85 db                	test   %ebx,%ebx
  10660d:	74 59                	je     106668 <freevm+0x68>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  10660f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  106616:	00 
  106617:	31 f6                	xor    %esi,%esi
  106619:	c7 44 24 04 00 00 0a 	movl   $0xa0000,0x4(%esp)
  106620:	00 
  106621:	89 1c 24             	mov    %ebx,(%esp)
  106624:	e8 37 ff ff ff       	call   106560 <deallocuvm>
  106629:	eb 10                	jmp    10663b <freevm+0x3b>
  10662b:	90                   	nop
  10662c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
  106630:	83 c6 01             	add    $0x1,%esi
  106633:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106639:	74 1f                	je     10665a <freevm+0x5a>
    if(pgdir[i] & PTE_P)
  10663b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  10663e:	a8 01                	test   $0x1,%al
  106640:	74 ee                	je     106630 <freevm+0x30>
      kfree((void *) PTE_ADDR(pgdir[i]));
  106642:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
  106647:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  10664a:	89 04 24             	mov    %eax,(%esp)
  10664d:	e8 1e be ff ff       	call   102470 <kfree>
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
  106652:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106658:	75 e1                	jne    10663b <freevm+0x3b>
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  }
  kfree((void *) pgdir);
  10665a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10665d:	83 c4 10             	add    $0x10,%esp
  106660:	5b                   	pop    %ebx
  106661:	5e                   	pop    %esi
  106662:	5d                   	pop    %ebp
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  }
  kfree((void *) pgdir);
  106663:	e9 08 be ff ff       	jmp    102470 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  106668:	c7 04 24 54 73 10 00 	movl   $0x107354,(%esp)
  10666f:	e8 1c a4 ff ff       	call   100a90 <panic>
  106674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10667a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106680 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  106680:	55                   	push   %ebp
  106681:	89 e5                	mov    %esp,%ebp
  106683:	57                   	push   %edi
  106684:	56                   	push   %esi
  106685:	53                   	push   %ebx
  106686:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d = setupkvm();
  106689:	e8 f2 fd ff ff       	call   106480 <setupkvm>
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  10668e:	85 c0                	test   %eax,%eax
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d = setupkvm();
  106690:	89 c6                	mov    %eax,%esi
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  106692:	0f 84 84 00 00 00    	je     10671c <copyuvm+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
  106698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10669b:	85 c0                	test   %eax,%eax
  10669d:	74 7d                	je     10671c <copyuvm+0x9c>
  10669f:	31 db                	xor    %ebx,%ebx
  1066a1:	eb 47                	jmp    1066ea <copyuvm+0x6a>
  1066a3:	90                   	nop
  1066a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present\n");
    pa = PTE_ADDR(*pte);
    if(!(mem = kalloc()))
      goto bad;
    memmove(mem, (char *)pa, PGSIZE);
  1066a8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1066ae:	89 54 24 04          	mov    %edx,0x4(%esp)
  1066b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1066b9:	00 
  1066ba:	89 04 24             	mov    %eax,(%esp)
  1066bd:	e8 1e db ff ff       	call   1041e0 <memmove>
    if(!mappages(d, (void *)i, PGSIZE, PADDR(mem), PTE_W|PTE_U))
  1066c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  1066c7:	89 da                	mov    %ebx,%edx
  1066c9:	89 f0                	mov    %esi,%eax
  1066cb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  1066d2:	00 
  1066d3:	89 3c 24             	mov    %edi,(%esp)
  1066d6:	e8 55 fc ff ff       	call   106330 <mappages>
  1066db:	85 c0                	test   %eax,%eax
  1066dd:	74 33                	je     106712 <copyuvm+0x92>
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  for(i = 0; i < sz; i += PGSIZE){
  1066df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  1066e5:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  1066e8:	76 32                	jbe    10671c <copyuvm+0x9c>
    if(!(pte = walkpgdir(pgdir, (void *)i, 0)))
  1066ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1066ed:	31 c9                	xor    %ecx,%ecx
  1066ef:	89 da                	mov    %ebx,%edx
  1066f1:	e8 ba fb ff ff       	call   1062b0 <walkpgdir>
  1066f6:	85 c0                	test   %eax,%eax
  1066f8:	74 2c                	je     106726 <copyuvm+0xa6>
      panic("copyuvm: pte should exist\n");
    if(!(*pte & PTE_P))
  1066fa:	8b 10                	mov    (%eax),%edx
  1066fc:	f6 c2 01             	test   $0x1,%dl
  1066ff:	74 31                	je     106732 <copyuvm+0xb2>
      panic("copyuvm: page not present\n");
    pa = PTE_ADDR(*pte);
    if(!(mem = kalloc()))
  106701:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106704:	e8 27 bd ff ff       	call   102430 <kalloc>
  106709:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10670c:	85 c0                	test   %eax,%eax
  10670e:	89 c7                	mov    %eax,%edi
  106710:	75 96                	jne    1066a8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
  106712:	89 34 24             	mov    %esi,(%esp)
  106715:	31 f6                	xor    %esi,%esi
  106717:	e8 e4 fe ff ff       	call   106600 <freevm>
  return 0;
}
  10671c:	83 c4 2c             	add    $0x2c,%esp
  10671f:	89 f0                	mov    %esi,%eax
  106721:	5b                   	pop    %ebx
  106722:	5e                   	pop    %esi
  106723:	5f                   	pop    %edi
  106724:	5d                   	pop    %ebp
  106725:	c3                   	ret    
  char *mem;

  if(!d) return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, (void *)i, 0)))
      panic("copyuvm: pte should exist\n");
  106726:	c7 04 24 65 73 10 00 	movl   $0x107365,(%esp)
  10672d:	e8 5e a3 ff ff       	call   100a90 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present\n");
  106732:	c7 04 24 80 73 10 00 	movl   $0x107380,(%esp)
  106739:	e8 52 a3 ff ff       	call   100a90 <panic>
  10673e:	66 90                	xchg   %ax,%ax

00106740 <allocuvm>:
// newsz. Allocates physical memory and page table entries. oldsz and
// newsz need not be page-aligned, nor does newsz have to be larger
// than oldsz.  Returns the new process size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106740:	55                   	push   %ebp
  if(newsz > USERTOP)
  106741:	31 c0                	xor    %eax,%eax
// newsz. Allocates physical memory and page table entries. oldsz and
// newsz need not be page-aligned, nor does newsz have to be larger
// than oldsz.  Returns the new process size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106743:	89 e5                	mov    %esp,%ebp
  106745:	57                   	push   %edi
  106746:	56                   	push   %esi
  106747:	53                   	push   %ebx
  106748:	83 ec 2c             	sub    $0x2c,%esp
  10674b:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz > USERTOP)
  10674e:	81 7d 10 00 00 0a 00 	cmpl   $0xa0000,0x10(%ebp)
  106755:	0f 87 93 00 00 00    	ja     1067ee <allocuvm+0xae>
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  10675b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  10675e:	8b 75 10             	mov    0x10(%ebp),%esi
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  106761:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  106767:	83 ee 01             	sub    $0x1,%esi
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  10676a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  106770:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a <= last; a += PGSIZE){
  106776:	39 f3                	cmp    %esi,%ebx
  106778:	76 47                	jbe    1067c1 <allocuvm+0x81>
  10677a:	eb 7c                	jmp    1067f8 <allocuvm+0xb8>
  10677c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
  106780:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106787:	00 
  106788:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10678f:	00 
  106790:	89 04 24             	mov    %eax,(%esp)
  106793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  106796:	e8 c5 d9 ff ff       	call   104160 <memset>
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  10679b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  1067a0:	89 f8                	mov    %edi,%eax
  1067a2:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  1067a9:	00 
  1067aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1067ad:	89 14 24             	mov    %edx,(%esp)
  1067b0:	89 da                	mov    %ebx,%edx
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  char *last = PGROUNDDOWN(newsz - 1);
  for (; a <= last; a += PGSIZE){
  1067b2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  1067b8:	e8 73 fb ff ff       	call   106330 <mappages>
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  char *last = PGROUNDDOWN(newsz - 1);
  for (; a <= last; a += PGSIZE){
  1067bd:	39 de                	cmp    %ebx,%esi
  1067bf:	72 37                	jb     1067f8 <allocuvm+0xb8>
    char *mem = kalloc();
  1067c1:	e8 6a bc ff ff       	call   102430 <kalloc>
    if(mem == 0){
  1067c6:	85 c0                	test   %eax,%eax
  1067c8:	75 b6                	jne    106780 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
  1067ca:	c7 04 24 9b 73 10 00 	movl   $0x10739b,(%esp)
  1067d1:	e8 ea 9c ff ff       	call   1004c0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
  1067d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1067d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1067dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1067e0:	89 3c 24             	mov    %edi,(%esp)
  1067e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1067e7:	e8 74 fd ff ff       	call   106560 <deallocuvm>
  1067ec:	31 c0                	xor    %eax,%eax
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  }
  return newsz > oldsz ? newsz : oldsz;
}
  1067ee:	83 c4 2c             	add    $0x2c,%esp
  1067f1:	5b                   	pop    %ebx
  1067f2:	5e                   	pop    %esi
  1067f3:	5f                   	pop    %edi
  1067f4:	5d                   	pop    %ebp
  1067f5:	c3                   	ret    
  1067f6:	66 90                	xchg   %ax,%ax
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  }
  return newsz > oldsz ? newsz : oldsz;
  1067f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1067fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1067fe:	73 ee                	jae    1067ee <allocuvm+0xae>
  106800:	8b 45 0c             	mov    0xc(%ebp),%eax
}
  106803:	83 c4 2c             	add    $0x2c,%esp
  106806:	5b                   	pop    %ebx
  106807:	5e                   	pop    %esi
  106808:	5f                   	pop    %edi
  106809:	5d                   	pop    %ebp
  10680a:	c3                   	ret    
  10680b:	90                   	nop
  10680c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106810 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  106810:	55                   	push   %ebp
  106811:	89 e5                	mov    %esp,%ebp
  106813:	57                   	push   %edi
  106814:	56                   	push   %esi
  106815:	53                   	push   %ebx
  106816:	83 ec 3c             	sub    $0x3c,%esp
  106819:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
  10681c:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  106822:	0f 85 99 00 00 00    	jne    1068c1 <loaduvm+0xb1>
    panic("loaduvm: addr must be page aligned\n");
  106828:	8b 75 18             	mov    0x18(%ebp),%esi
  10682b:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < sz; i += PGSIZE){
  10682d:	85 f6                	test   %esi,%esi
  10682f:	74 77                	je     1068a8 <loaduvm+0x98>
  106831:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  106834:	eb 13                	jmp    106849 <loaduvm+0x39>
  106836:	66 90                	xchg   %ax,%ax
  106838:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  10683e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  106844:	39 5d 18             	cmp    %ebx,0x18(%ebp)
  106847:	76 5f                	jbe    1068a8 <loaduvm+0x98>
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
  106849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10684c:	31 c9                	xor    %ecx,%ecx
  10684e:	8b 45 08             	mov    0x8(%ebp),%eax
  106851:	01 da                	add    %ebx,%edx
  106853:	e8 58 fa ff ff       	call   1062b0 <walkpgdir>
  106858:	85 c0                	test   %eax,%eax
  10685a:	74 59                	je     1068b5 <loaduvm+0xa5>
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE) n = sz - i;
  10685c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
  106862:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE) n = sz - i;
  106864:	ba 00 10 00 00       	mov    $0x1000,%edx
  106869:	77 02                	ja     10686d <loaduvm+0x5d>
  10686b:	89 f2                	mov    %esi,%edx
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
  10686d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106871:	8b 7d 14             	mov    0x14(%ebp),%edi
  106874:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  106879:	89 44 24 04          	mov    %eax,0x4(%esp)
  10687d:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
  106880:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  106884:	8b 45 10             	mov    0x10(%ebp),%eax
  106887:	89 04 24             	mov    %eax,(%esp)
  10688a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10688d:	e8 9e ac ff ff       	call   101530 <readi>
  106892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106895:	39 d0                	cmp    %edx,%eax
  106897:	74 9f                	je     106838 <loaduvm+0x28>
      return 0;
  }
  return 1;
}
  106899:	83 c4 3c             	add    $0x3c,%esp
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE) n = sz - i;
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
  10689c:	31 c0                	xor    %eax,%eax
      return 0;
  }
  return 1;
}
  10689e:	5b                   	pop    %ebx
  10689f:	5e                   	pop    %esi
  1068a0:	5f                   	pop    %edi
  1068a1:	5d                   	pop    %ebp
  1068a2:	c3                   	ret    
  1068a3:	90                   	nop
  1068a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1068a8:	83 c4 3c             	add    $0x3c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
  1068ab:	b8 01 00 00 00       	mov    $0x1,%eax
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
      return 0;
  }
  return 1;
}
  1068b0:	5b                   	pop    %ebx
  1068b1:	5e                   	pop    %esi
  1068b2:	5f                   	pop    %edi
  1068b3:	5d                   	pop    %ebp
  1068b4:	c3                   	ret    

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
  1068b5:	c7 04 24 ec 73 10 00 	movl   $0x1073ec,(%esp)
  1068bc:	e8 cf a1 ff ff       	call   100a90 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  1068c1:	c7 04 24 c8 73 10 00 	movl   $0x1073c8,(%esp)
  1068c8:	e8 c3 a1 ff ff       	call   100a90 <panic>
  1068cd:	8d 76 00             	lea    0x0(%esi),%esi

001068d0 <switchuvm>:
}

// Switch h/w page table and TSS registers to point to process p.
void
switchuvm(struct proc *p)
{
  1068d0:	55                   	push   %ebp
  1068d1:	89 e5                	mov    %esp,%ebp
  1068d3:	53                   	push   %ebx
  1068d4:	83 ec 14             	sub    $0x14,%esp
  1068d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
  1068da:	e8 f1 d6 ff ff       	call   103fd0 <pushcli>

  // Setup TSS
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  1068df:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1068e5:	8d 50 08             	lea    0x8(%eax),%edx
  1068e8:	89 d1                	mov    %edx,%ecx
  1068ea:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
  1068f1:	c1 e9 10             	shr    $0x10,%ecx
  1068f4:	c1 ea 18             	shr    $0x18,%edx
  1068f7:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  1068fd:	c6 80 a5 00 00 00 99 	movb   $0x99,0xa5(%eax)
  106904:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  10690a:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
  106911:	67 00 
  106913:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  10691a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106920:	80 a0 a5 00 00 00 ef 	andb   $0xef,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  106927:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10692d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  106933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  106939:	8b 50 08             	mov    0x8(%eax),%edx
  10693c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106942:	81 c2 00 10 00 00    	add    $0x1000,%edx
  106948:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  10694b:	b8 30 00 00 00       	mov    $0x30,%eax
  106950:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);

  if(p->pgdir == 0)
  106953:	8b 43 04             	mov    0x4(%ebx),%eax
  106956:	85 c0                	test   %eax,%eax
  106958:	74 0d                	je     106967 <switchuvm+0x97>
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  10695a:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir\n");

  lcr3(PADDR(p->pgdir));  // switch to new address space
  popcli();
}
  10695d:	83 c4 14             	add    $0x14,%esp
  106960:	5b                   	pop    %ebx
  106961:	5d                   	pop    %ebp

  if(p->pgdir == 0)
    panic("switchuvm: no pgdir\n");

  lcr3(PADDR(p->pgdir));  // switch to new address space
  popcli();
  106962:	e9 a9 d6 ff ff       	jmp    104010 <popcli>
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);

  if(p->pgdir == 0)
    panic("switchuvm: no pgdir\n");
  106967:	c7 04 24 b3 73 10 00 	movl   $0x1073b3,(%esp)
  10696e:	e8 1d a1 ff ff       	call   100a90 <panic>
  106973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106980 <ksegment>:

// Set up CPU's kernel segment descriptors.
// Run once at boot time on each CPU.
void
ksegment(void)
{
  106980:	55                   	push   %ebp
  106981:	89 e5                	mov    %esp,%ebp
  106983:	83 ec 18             	sub    $0x18,%esp

  // Map virtual addresses to linear addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  106986:	e8 85 bd ff ff       	call   102710 <cpunum>
  10698b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  106991:	05 20 c5 10 00       	add    $0x10c520,%eax
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  106996:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  10699c:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
  1069a3:	89 d1                	mov    %edx,%ecx
  1069a5:	c1 ea 18             	shr    $0x18,%edx
  1069a8:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
  1069ae:	c1 e9 10             	shr    $0x10,%ecx

  lgdt(c->gdt, sizeof(c->gdt));
  1069b1:	8d 50 70             	lea    0x70(%eax),%edx
  // Map virtual addresses to linear addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  1069b4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
  1069ba:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
  1069c0:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
  1069c4:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
  1069c8:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  1069cc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  1069d0:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
  1069d7:	ff ff 
  1069d9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
  1069e0:	00 00 
  1069e2:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  1069e9:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
  1069f0:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  1069f7:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  1069fe:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
  106a05:	ff ff 
  106a07:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
  106a0e:	00 00 
  106a10:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
  106a17:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
  106a1e:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  106a25:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  106a2c:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
  106a33:	ff ff 
  106a35:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  106a3c:	00 00 
  106a3e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  106a45:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
  106a4c:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)
  106a53:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  106a5a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
  106a61:	00 00 
  106a63:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
  106a69:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
  106a70:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  106a77:	66 c7 45 f2 37 00    	movw   $0x37,-0xe(%ebp)
  pd[1] = (uint)p;
  106a7d:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
  106a81:	c1 ea 10             	shr    $0x10,%edx
  106a84:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  106a88:	8d 55 f2             	lea    -0xe(%ebp),%edx
  106a8b:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
  106a8e:	ba 18 00 00 00       	mov    $0x18,%edx
  106a93:	8e ea                	mov    %edx,%gs

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  106a95:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
  106a9b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  106aa2:	00 00 00 00 
}
  106aa6:	c9                   	leave  
  106aa7:	c3                   	ret    
