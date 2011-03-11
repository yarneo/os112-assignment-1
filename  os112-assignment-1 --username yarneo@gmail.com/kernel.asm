
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
  10000f:	c7 04 24 c0 90 10 00 	movl   $0x1090c0,(%esp)
  100016:	e8 55 3f 00 00       	call   103f70 <acquire>

  b->next->prev = b->prev;
  10001b:	8b 43 10             	mov    0x10(%ebx),%eax
  10001e:	8b 53 0c             	mov    0xc(%ebx),%edx
  100021:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
  100024:	8b 43 0c             	mov    0xc(%ebx),%eax
  100027:	8b 53 10             	mov    0x10(%ebx),%edx
  10002a:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
  10002d:	a1 f4 a5 10 00       	mov    0x10a5f4,%eax
  b->prev = &bcache.head;
  100032:	c7 43 0c e4 a5 10 00 	movl   $0x10a5e4,0xc(%ebx)

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
  100039:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
  10003c:	a1 f4 a5 10 00       	mov    0x10a5f4,%eax
  100041:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
  100044:	89 1d f4 a5 10 00    	mov    %ebx,0x10a5f4

  b->flags &= ~B_BUSY;
  10004a:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
  10004d:	89 1c 24             	mov    %ebx,(%esp)
  100050:	e8 4b 32 00 00       	call   1032a0 <wakeup>

  release(&bcache.lock);
  100055:	c7 45 08 c0 90 10 00 	movl   $0x1090c0,0x8(%ebp)
}
  10005c:	83 c4 14             	add    $0x14,%esp
  10005f:	5b                   	pop    %ebx
  100060:	5d                   	pop    %ebp
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
  100061:	e9 ba 3e 00 00       	jmp    103f20 <release>
// Release the buffer b.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
  100066:	c7 04 24 c0 68 10 00 	movl   $0x1068c0,(%esp)
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
  10009e:	c7 04 24 c7 68 10 00 	movl   $0x1068c7,(%esp)
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
  1000bf:	c7 04 24 c0 90 10 00 	movl   $0x1090c0,(%esp)
  1000c6:	e8 a5 3e 00 00       	call   103f70 <acquire>

 loop:
  // Try for cached block.
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
  1000cb:	8b 1d f4 a5 10 00    	mov    0x10a5f4,%ebx
  1000d1:	81 fb e4 a5 10 00    	cmp    $0x10a5e4,%ebx
  1000d7:	75 12                	jne    1000eb <bread+0x3b>
  1000d9:	eb 35                	jmp    100110 <bread+0x60>
  1000db:	90                   	nop
  1000dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1000e0:	8b 5b 10             	mov    0x10(%ebx),%ebx
  1000e3:	81 fb e4 a5 10 00    	cmp    $0x10a5e4,%ebx
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
  1000fd:	c7 44 24 04 c0 90 10 	movl   $0x1090c0,0x4(%esp)
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
  100110:	8b 1d f0 a5 10 00    	mov    0x10a5f0,%ebx
  100116:	81 fb e4 a5 10 00    	cmp    $0x10a5e4,%ebx
  10011c:	75 0d                	jne    10012b <bread+0x7b>
  10011e:	eb 54                	jmp    100174 <bread+0xc4>
  100120:	8b 5b 0c             	mov    0xc(%ebx),%ebx
  100123:	81 fb e4 a5 10 00    	cmp    $0x10a5e4,%ebx
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
  10013e:	c7 04 24 c0 90 10 00 	movl   $0x1090c0,(%esp)
  100145:	e8 d6 3d 00 00       	call   103f20 <release>
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
  100166:	c7 04 24 c0 90 10 00 	movl   $0x1090c0,(%esp)
  10016d:	e8 ae 3d 00 00       	call   103f20 <release>
  100172:	eb d6                	jmp    10014a <bread+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
  100174:	c7 04 24 ce 68 10 00 	movl   $0x1068ce,(%esp)
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
  100186:	c7 44 24 04 df 68 10 	movl   $0x1068df,0x4(%esp)
  10018d:	00 
  10018e:	c7 04 24 c0 90 10 00 	movl   $0x1090c0,(%esp)
  100195:	e8 46 3c 00 00       	call   103de0 <initlock>
  // head.next is most recently used.
  struct buf head;
} bcache;

void
binit(void)
  10019a:	ba e4 a5 10 00       	mov    $0x10a5e4,%edx
  10019f:	b8 f4 90 10 00       	mov    $0x1090f4,%eax
  struct buf *b;

  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  1001a4:	c7 05 f0 a5 10 00 e4 	movl   $0x10a5e4,0x10a5f0
  1001ab:	a5 10 00 
  bcache.head.next = &bcache.head;
  1001ae:	c7 05 f4 a5 10 00 e4 	movl   $0x10a5e4,0x10a5f4
  1001b5:	a5 10 00 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
  1001b8:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
  1001bb:	c7 40 0c e4 a5 10 00 	movl   $0x10a5e4,0xc(%eax)
    b->dev = -1;
  1001c2:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
  1001c9:	8b 15 f4 a5 10 00    	mov    0x10a5f4,%edx
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
  1001d4:	a3 f4 a5 10 00       	mov    %eax,0x10a5f4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
  1001d9:	05 18 02 00 00       	add    $0x218,%eax
  1001de:	3d e4 a5 10 00       	cmp    $0x10a5e4,%eax
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
  1001f6:	c7 44 24 04 e6 68 10 	movl   $0x1068e6,0x4(%esp)
  1001fd:	00 
  1001fe:	c7 04 24 20 90 10 00 	movl   $0x109020,(%esp)
  100205:	e8 d6 3b 00 00       	call   103de0 <initlock>
  initlock(&input.lock, "input");
  10020a:	c7 44 24 04 ee 68 10 	movl   $0x1068ee,0x4(%esp)
  100211:	00 
  100212:	c7 04 24 00 a8 10 00 	movl   $0x10a800,(%esp)
  100219:	e8 c2 3b 00 00       	call   103de0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
  10021e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
{
  initlock(&cons.lock, "console");
  initlock(&input.lock, "input");


  devsw[CONSOLE].write = consolewrite;
  100225:	c7 05 6c b2 10 00 d0 	movl   $0x1003d0,0x10b26c
  10022c:	03 10 00 
  devsw[CONSOLE].read = consoleread;
  10022f:	c7 05 68 b2 10 00 20 	movl   $0x100620,0x10b268
  100236:	06 10 00 
  cons.locking = 1;
  100239:	c7 05 54 90 10 00 01 	movl   $0x1,0x109054
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
  10026b:	83 3d a0 89 10 00 00 	cmpl   $0x0,0x1089a0
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
  100285:	e8 86 52 00 00       	call   105510 <uartputc>
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
  100329:	e8 e2 51 00 00       	call   105510 <uartputc>
  10032e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100335:	e8 d6 51 00 00       	call   105510 <uartputc>
  10033a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  100341:	e8 ca 51 00 00       	call   105510 <uartputc>
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
  10036c:	e8 1f 3d 00 00       	call   104090 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  100371:	b8 80 07 00 00       	mov    $0x780,%eax
  100376:	29 d8                	sub    %ebx,%eax
  100378:	01 c0                	add    %eax,%eax
  10037a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10037e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100385:	00 
  100386:	89 34 24             	mov    %esi,(%esp)
  100389:	e8 82 3c 00 00       	call   104010 <memset>
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
  1003ea:	c7 04 24 20 90 10 00 	movl   $0x109020,(%esp)
  1003f1:	e8 7a 3b 00 00       	call   103f70 <acquire>
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
  100410:	c7 04 24 20 90 10 00 	movl   $0x109020,(%esp)
  100417:	e8 04 3b 00 00       	call   103f20 <release>
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
  100464:	0f b6 92 0e 69 10 00 	movzbl 0x10690e(%edx),%edx
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
  1004c9:	8b 3d 54 90 10 00    	mov    0x109054,%edi
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
  10057c:	c7 04 24 20 90 10 00 	movl   $0x109020,(%esp)
  100583:	e8 98 39 00 00       	call   103f20 <release>
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
  100600:	c7 04 24 20 90 10 00 	movl   $0x109020,(%esp)
  100607:	e8 64 39 00 00       	call   103f70 <acquire>
  10060c:	e9 c6 fe ff ff       	jmp    1004d7 <cprintf+0x17>
  100611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
  100618:	ba f4 68 10 00       	mov    $0x1068f4,%edx
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
  10063a:	c7 04 24 00 a8 10 00 	movl   $0x10a800,(%esp)
  100641:	e8 2a 39 00 00       	call   103f70 <acquire>
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
  100661:	c7 44 24 04 00 a8 10 	movl   $0x10a800,0x4(%esp)
  100668:	00 
  100669:	c7 04 24 b4 a8 10 00 	movl   $0x10a8b4,(%esp)
  100670:	e8 8b 2d 00 00       	call   103400 <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
  100675:	a1 b4 a8 10 00       	mov    0x10a8b4,%eax
  10067a:	3b 05 b8 a8 10 00    	cmp    0x10a8b8,%eax
  100680:	74 ce                	je     100650 <consoleread+0x30>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
  100682:	89 c2                	mov    %eax,%edx
  100684:	83 e2 7f             	and    $0x7f,%edx
  100687:	0f b6 92 34 a8 10 00 	movzbl 0x10a834(%edx),%edx
  10068e:	8d 78 01             	lea    0x1(%eax),%edi
  100691:	89 3d b4 a8 10 00    	mov    %edi,0x10a8b4
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
  1006b2:	8b 0d a4 89 10 00    	mov    0x1089a4,%ecx
  1006b8:	83 f9 0f             	cmp    $0xf,%ecx
  1006bb:	7e 0c                	jle    1006c9 <consoleread+0xa9>
     indexToDim1 = 0;
  1006bd:	c7 05 a4 89 10 00 00 	movl   $0x0,0x1089a4
  1006c4:	00 00 00 
  1006c7:	31 c9                	xor    %ecx,%ecx
   }
   prevCmds[indexToDim1][indexToDim2] = c;
  1006c9:	8b 3d a8 89 10 00    	mov    0x1089a8,%edi
  1006cf:	6b c9 64             	imul   $0x64,%ecx,%ecx
  1006d2:	0f b6 55 c7          	movzbl -0x39(%ebp),%edx
  1006d6:	88 94 0f c0 89 10 00 	mov    %dl,0x1089c0(%edi,%ecx,1)
   indexToDim2++;
  1006dd:	83 c7 01             	add    $0x1,%edi
  1006e0:	89 3d a8 89 10 00    	mov    %edi,0x1089a8
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
  100718:	c7 04 24 00 a8 10 00 	movl   $0x10a800,(%esp)
  10071f:	e8 fc 37 00 00       	call   103f20 <release>
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
  100740:	8b 15 a4 89 10 00    	mov    0x1089a4,%edx
   prevCmds[indexToDim1][indexToDim2] = c;
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
  100746:	6b 3d a4 89 10 00 64 	imul   $0x64,0x1089a4,%edi
  10074d:	03 3d a8 89 10 00    	add    0x1089a8,%edi
   indexToDim2=0;
   currInd1 = indexToDim1;
   indexToDim1++;
   hasInserted++;
  100753:	83 05 ac 89 10 00 01 	addl   $0x1,0x1089ac
   prevCmds[indexToDim1][indexToDim2] = c;
   indexToDim2++;
   }
   else {
   //cprintf("well %d  %s",indexToDim1,prevCmds[indexToDim1]);
   prevCmds[indexToDim1][indexToDim2] = '\0';
  10075a:	c6 87 c0 89 10 00 00 	movb   $0x0,0x1089c0(%edi)
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
  100766:	c7 05 a8 89 10 00 00 	movl   $0x0,0x1089a8
  10076d:	00 00 00 
   currInd1 = indexToDim1;
  100770:	89 15 00 90 10 00    	mov    %edx,0x109000
   indexToDim1++;
  100776:	89 3d a4 89 10 00    	mov    %edi,0x1089a4
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
  100786:	a3 b4 a8 10 00       	mov    %eax,0x10a8b4
  10078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078e:	29 d8                	sub    %ebx,%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
  100790:	c7 04 24 00 a8 10 00 	movl   $0x10a800,(%esp)
  100797:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10079a:	e8 81 37 00 00       	call   103f20 <release>
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
  1007c5:	be 30 a8 10 00       	mov    $0x10a830,%esi

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
  1007d6:	c7 04 24 00 a8 10 00 	movl   $0x10a800,(%esp)
  1007dd:	e8 8e 37 00 00       	call   103f70 <acquire>
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
  10082a:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
  10082f:	89 c2                	mov    %eax,%edx
  100831:	2b 15 b4 a8 10 00    	sub    0x10a8b4,%edx
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
  100853:	a3 bc a8 10 00       	mov    %eax,0x10a8bc
        consputc(c);
  100858:	89 f8                	mov    %edi,%eax
  10085a:	e8 01 fa ff ff       	call   100260 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
  10085f:	83 ff 04             	cmp    $0x4,%edi
  100862:	0f 84 1c 02 00 00    	je     100a84 <consoleintr+0x2c4>
  100868:	83 ff 0a             	cmp    $0xa,%edi
  10086b:	0f 84 13 02 00 00    	je     100a84 <consoleintr+0x2c4>
  100871:	8b 15 b4 a8 10 00    	mov    0x10a8b4,%edx
  100877:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
  10087c:	83 ea 80             	sub    $0xffffff80,%edx
  10087f:	39 d0                	cmp    %edx,%eax
  100881:	0f 85 61 ff ff ff    	jne    1007e8 <consoleintr+0x28>
          input.w = input.e;
  100887:	a3 b8 a8 10 00       	mov    %eax,0x10a8b8
          wakeup(&input.r);
  10088c:	c7 04 24 b4 a8 10 00 	movl   $0x10a8b4,(%esp)
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
  1008a5:	c7 45 08 00 a8 10 00 	movl   $0x10a800,0x8(%ebp)
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
  1008b3:	e9 68 36 00 00       	jmp    103f20 <release>
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
  1008d6:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
  1008db:	3b 05 b8 a8 10 00    	cmp    0x10a8b8,%eax
  1008e1:	0f 84 01 ff ff ff    	je     1007e8 <consoleintr+0x28>
  1008e7:	90                   	nop
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  1008e8:	83 e8 01             	sub    $0x1,%eax
  1008eb:	89 c2                	mov    %eax,%edx
  1008ed:	83 e2 7f             	and    $0x7f,%edx
  1008f0:	80 ba 34 a8 10 00 0a 	cmpb   $0xa,0x10a834(%edx)
  1008f7:	0f 84 eb fe ff ff    	je     1007e8 <consoleintr+0x28>
        input.e--;
  1008fd:	a3 bc a8 10 00       	mov    %eax,0x10a8bc
        consputc(BACKSPACE);
  100902:	b8 00 01 00 00       	mov    $0x100,%eax
  100907:	e8 54 f9 ff ff       	call   100260 <consputc>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
  10090c:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
  100911:	3b 05 b8 a8 10 00    	cmp    0x10a8b8,%eax
  100917:	75 cf                	jne    1008e8 <consoleintr+0x128>
  100919:	e9 ca fe ff ff       	jmp    1007e8 <consoleintr+0x28>
  10091e:	66 90                	xchg   %ax,%ax

  acquire(&input.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      procdump();
  100920:	e8 cb 33 00 00       	call   103cf0 <procdump>
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
  100930:	8b 0d ac 89 10 00    	mov    0x1089ac,%ecx
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
  100950:	80 ba 34 a8 10 00 0a 	cmpb   $0xa,0x10a834(%edx)
  100957:	74 1c                	je     100975 <consoleintr+0x1b5>
        input.e--;
  100959:	a3 bc a8 10 00       	mov    %eax,0x10a8bc
        consputc(BACKSPACE);
  10095e:	b8 00 01 00 00       	mov    $0x100,%eax
  100963:	e8 f8 f8 ff ff       	call   100260 <consputc>
        consputc(BACKSPACE);
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
	while(input.e != input.w &&
  100968:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
  10096d:	3b 05 b8 a8 10 00    	cmp    0x10a8b8,%eax
  100973:	75 d3                	jne    100948 <consoleintr+0x188>
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
	}
	//cprintf("aaaa %d aaaa",currInd1);
	while(prevCmds[currInd1][ind] != 0) {
  100975:	8b 0d 00 90 10 00    	mov    0x109000,%ecx
  10097b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  10097e:	6b c9 64             	imul   $0x64,%ecx,%ecx
  100981:	01 d9                	add    %ebx,%ecx
  100983:	0f b6 81 c0 89 10 00 	movzbl 0x1089c0(%ecx),%eax
  10098a:	84 c0                	test   %al,%al
  10098c:	74 31                	je     1009bf <consoleintr+0x1ff>
      }
      break;
    case C('I'): case 226:
	if(hasInserted) {
	while(input.e != input.w &&
        input.buf[(input.e-1) % INPUT_BUF] != '\n'){
  10098e:	8b 15 bc a8 10 00    	mov    0x10a8bc,%edx
  100994:	81 c1 c1 89 10 00    	add    $0x1089c1,%ecx
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
  1009b9:	89 15 bc a8 10 00    	mov    %edx,0x10a8bc
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
  1009c6:	83 3d ac 89 10 00 0f 	cmpl   $0xf,0x1089ac
  1009cd:	7f 51                	jg     100a20 <consoleintr+0x260>
      	cprintf("%s",prevCmds[0]);
  1009cf:	c7 44 24 04 c0 89 10 	movl   $0x1089c0,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 76 6e 10 00 	movl   $0x106e76,(%esp)
  1009de:	e8 dd fa ff ff       	call   1004c0 <cprintf>
	currInd1 = indexToDim1-1;
  1009e3:	a1 a4 89 10 00       	mov    0x1089a4,%eax
  1009e8:	83 e8 01             	sub    $0x1,%eax
  1009eb:	a3 00 90 10 00       	mov    %eax,0x109000
  1009f0:	e9 f3 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
  1009f5:	8d 76 00             	lea    0x0(%esi),%esi
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
  1009f8:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
  1009fd:	3b 05 b8 a8 10 00    	cmp    0x10a8b8,%eax
  100a03:	0f 84 df fd ff ff    	je     1007e8 <consoleintr+0x28>
        input.e--;
  100a09:	83 e8 01             	sub    $0x1,%eax
  100a0c:	a3 bc a8 10 00       	mov    %eax,0x10a8bc
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
  100a20:	c7 44 24 04 c0 89 10 	movl   $0x1089c0,0x4(%esp)
  100a27:	00 
  100a28:	c7 04 24 76 6e 10 00 	movl   $0x106e76,(%esp)
  100a2f:	e8 8c fa ff ff       	call   1004c0 <cprintf>
	currInd1 = 15;
  100a34:	c7 05 00 90 10 00 0f 	movl   $0xf,0x109000
  100a3b:	00 00 00 
  100a3e:	e9 a5 fd ff ff       	jmp    1007e8 <consoleintr+0x28>
	while(prevCmds[currInd1][ind] != 0) {
        input.buf[input.e++ % INPUT_BUF] = prevCmds[currInd1][ind];
	ind++;
	}
	if(currInd1 != 0) {
      	cprintf("%s",prevCmds[currInd1]);
  100a43:	6b 45 e0 64          	imul   $0x64,-0x20(%ebp),%eax
  100a47:	c7 04 24 76 6e 10 00 	movl   $0x106e76,(%esp)
  100a4e:	05 c0 89 10 00       	add    $0x1089c0,%eax
  100a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a57:	e8 64 fa ff ff       	call   1004c0 <cprintf>
	currInd1--;
  100a5c:	83 2d 00 90 10 00 01 	subl   $0x1,0x109000
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
  100a75:	a3 bc a8 10 00       	mov    %eax,0x10a8bc
        consputc(c);
  100a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  100a7f:	e8 dc f7 ff ff       	call   100260 <consputc>
  100a84:	a1 bc a8 10 00       	mov    0x10a8bc,%eax
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
  100aa4:	c7 05 54 90 10 00 00 	movl   $0x0,0x109054
  100aab:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
  100aae:	0f b6 00             	movzbl (%eax),%eax
  100ab1:	c7 04 24 fb 68 10 00 	movl   $0x1068fb,(%esp)
  100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abc:	e8 ff f9 ff ff       	call   1004c0 <cprintf>
  cprintf(s);
  100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac4:	89 04 24             	mov    %eax,(%esp)
  100ac7:	e8 f4 f9 ff ff       	call   1004c0 <cprintf>
  cprintf("\n");
  100acc:	c7 04 24 36 6d 10 00 	movl   $0x106d36,(%esp)
  100ad3:	e8 e8 f9 ff ff       	call   1004c0 <cprintf>
  getcallerpcs(&s, pcs);
  100ad8:	8d 45 08             	lea    0x8(%ebp),%eax
  100adb:	89 74 24 04          	mov    %esi,0x4(%esp)
  100adf:	89 04 24             	mov    %eax,(%esp)
  100ae2:	e8 19 33 00 00       	call   103e00 <getcallerpcs>
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
  100aee:	c7 04 24 0a 69 10 00 	movl   $0x10690a,(%esp)
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
  100b03:	c7 05 a0 89 10 00 01 	movl   $0x1,0x1089a0
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
  100b78:	e8 13 57 00 00       	call   106290 <setupkvm>
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
  100bfc:	e8 4f 59 00 00       	call   106550 <allocuvm>
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
  100c27:	e8 f4 59 00 00       	call   106620 <loaduvm>
  100c2c:	85 c0                	test   %eax,%eax
  100c2e:	0f 85 74 ff ff ff    	jne    100ba8 <exec+0x98>
  100c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  freevm(oldpgdir);

  return 0;

 bad:
  if(pgdir) freevm(pgdir);
  100c38:	8b 45 80             	mov    -0x80(%ebp),%eax
  100c3b:	89 04 24             	mov    %eax,(%esp)
  100c3e:	e8 cd 57 00 00       	call   106410 <freevm>
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
  100c93:	e8 b8 58 00 00       	call   106550 <allocuvm>
  100c98:	85 c0                	test   %eax,%eax
  100c9a:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  100ca0:	74 96                	je     100c38 <exec+0x128>
    goto bad;
  mem = uva2ka(pgdir, (char *)spbottom);
  100ca2:	8b 4d 84             	mov    -0x7c(%ebp),%ecx
  100ca5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ca9:	8b 45 80             	mov    -0x80(%ebp),%eax
  100cac:	89 04 24             	mov    %eax,(%esp)
  100caf:	e8 1c 55 00 00       	call   1061d0 <uva2ka>

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
  100cd6:	e8 15 35 00 00       	call   1041f0 <strlen>
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
  100d4e:	e8 9d 34 00 00       	call   1041f0 <strlen>
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
  100d73:	e8 18 33 00 00       	call   104090 <memmove>
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
  100e13:	e8 98 33 00 00       	call   1041b0 <safestrcpy>

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
  100e59:	e8 82 58 00 00       	call   1066e0 <switchuvm>

  freevm(oldpgdir);
  100e5e:	89 34 24             	mov    %esi,(%esp)
  100e61:	e8 aa 55 00 00       	call   106410 <freevm>

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
  100f57:	c7 04 24 1f 69 10 00 	movl   $0x10691f,(%esp)
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
  101007:	c7 04 24 29 69 10 00 	movl   $0x106929,(%esp)
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
  10107a:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  101081:	e8 ea 2e 00 00       	call   103f70 <acquire>
  if(f->ref < 1)
  101086:	8b 43 04             	mov    0x4(%ebx),%eax
  101089:	85 c0                	test   %eax,%eax
  10108b:	7e 1a                	jle    1010a7 <filedup+0x37>
    panic("filedup");
  f->ref++;
  10108d:	83 c0 01             	add    $0x1,%eax
  101090:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
  101093:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  10109a:	e8 81 2e 00 00       	call   103f20 <release>
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
  1010a7:	c7 04 24 32 69 10 00 	movl   $0x106932,(%esp)
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
  1010c4:	bb 0c a9 10 00       	mov    $0x10a90c,%ebx
{
  1010c9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
  1010cc:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  1010d3:	e8 98 2e 00 00       	call   103f70 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
  1010d8:	8b 15 f8 a8 10 00    	mov    0x10a8f8,%edx
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
  1010eb:	81 fb 54 b2 10 00    	cmp    $0x10b254,%ebx
  1010f1:	74 25                	je     101118 <filealloc+0x58>
    if(f->ref == 0){
  1010f3:	8b 43 04             	mov    0x4(%ebx),%eax
  1010f6:	85 c0                	test   %eax,%eax
  1010f8:	75 ee                	jne    1010e8 <filealloc+0x28>
      f->ref = 1;
  1010fa:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
  101101:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  101108:	e8 13 2e 00 00       	call   103f20 <release>
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
  10111a:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  101121:	e8 fa 2d 00 00       	call   103f20 <release>
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
  10112e:	bb f4 a8 10 00       	mov    $0x10a8f4,%ebx
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
  101152:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  101159:	e8 12 2e 00 00       	call   103f70 <acquire>
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
  101173:	c7 45 08 c0 a8 10 00 	movl   $0x10a8c0,0x8(%ebp)
  
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
  101186:	e9 95 2d 00 00       	jmp    103f20 <release>
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
  1011af:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  1011b6:	e8 65 2d 00 00       	call   103f20 <release>
  
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
  101205:	c7 04 24 3a 69 10 00 	movl   $0x10693a,(%esp)
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
  101226:	c7 44 24 04 44 69 10 	movl   $0x106944,0x4(%esp)
  10122d:	00 
  10122e:	c7 04 24 c0 a8 10 00 	movl   $0x10a8c0,(%esp)
  101235:	e8 a6 2b 00 00       	call   103de0 <initlock>
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
  10127a:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101281:	e8 ea 2c 00 00       	call   103f70 <acquire>
  ip->ref++;
  101286:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
  10128a:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101291:	e8 8a 2c 00 00       	call   103f20 <release>
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
  1012af:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  1012b6:	e8 b5 2c 00 00       	call   103f70 <acquire>
}

// Find the inode with number inum on device dev
// and return the in-memory copy.
static struct inode*
iget(uint dev, uint inum)
  1012bb:	b8 f4 b2 10 00       	mov    $0x10b2f4,%eax
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
  1012cf:	3d 94 c2 10 00       	cmp    $0x10c294,%eax
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
  1012ec:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  1012f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1012f6:	e8 25 2c 00 00       	call   103f20 <release>
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
  101311:	3d 94 c2 10 00       	cmp    $0x10c294,%eax
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
  10132f:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101336:	e8 e5 2b 00 00       	call   103f20 <release>

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
  101345:	c7 04 24 4b 69 10 00 	movl   $0x10694b,(%esp)
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
  101392:	e8 f9 2c 00 00       	call   104090 <memmove>
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
  10146b:	c7 04 24 5b 69 10 00 	movl   $0x10695b,(%esp)
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
  10151c:	c7 04 24 71 69 10 00 	movl   $0x106971,(%esp)
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
  10157b:	8b 04 c5 60 b2 10 00 	mov    0x10b260(,%eax,8),%eax
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
  101605:	e8 86 2a 00 00       	call   104090 <memmove>
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
  10169b:	e8 f0 29 00 00       	call   104090 <memmove>
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
  10170b:	8b 04 c5 64 b2 10 00 	mov    0x10b264(,%eax,8),%eax
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
  1017a5:	e8 e6 28 00 00       	call   104090 <memmove>
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
  10181b:	e8 e0 28 00 00       	call   104100 <strncmp>
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
  101923:	c7 04 24 84 69 10 00 	movl   $0x106984,(%esp)
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
  10194b:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101952:	e8 19 26 00 00       	call   103f70 <acquire>
  ip->flags &= ~I_BUSY;
  101957:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
  10195b:	89 1c 24             	mov    %ebx,(%esp)
  10195e:	e8 3d 19 00 00       	call   1032a0 <wakeup>
  release(&icache.lock);
  101963:	c7 45 08 c0 b2 10 00 	movl   $0x10b2c0,0x8(%ebp)
}
  10196a:	83 c4 14             	add    $0x14,%esp
  10196d:	5b                   	pop    %ebx
  10196e:	5d                   	pop    %ebp
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
  10196f:	e9 ac 25 00 00       	jmp    103f20 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
  101974:	c7 04 24 96 69 10 00 	movl   $0x106996,(%esp)
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
  1019b1:	e8 5a 26 00 00       	call   104010 <memset>
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
  101a32:	c7 04 24 9e 69 10 00 	movl   $0x10699e,(%esp)
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
  101a4c:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101a53:	e8 18 25 00 00       	call   103f70 <acquire>
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
  101a91:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101a98:	e8 83 24 00 00       	call   103f20 <release>
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
  101ae7:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101aee:	e8 7d 24 00 00       	call   103f70 <acquire>
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
  101b0b:	c7 45 08 c0 b2 10 00 	movl   $0x10b2c0,0x8(%ebp)
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
  101b19:	e9 02 24 00 00       	jmp    103f20 <release>
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
  101b7e:	c7 04 24 b1 69 10 00 	movl   $0x1069b1,(%esp)
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
  101c11:	e8 4a 25 00 00       	call   104160 <strncpy>
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
  101c5a:	c7 04 24 bb 69 10 00 	movl   $0x1069bb,(%esp)
  101c61:	e8 2a ee ff ff       	call   100a90 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
  101c66:	c7 04 24 a6 6f 10 00 	movl   $0x106fa6,(%esp)
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
  101d2b:	e8 e0 22 00 00       	call   104010 <memset>
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
  101d5c:	c7 04 24 c8 69 10 00 	movl   $0x1069c8,(%esp)
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
  101d8e:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101d95:	e8 d6 21 00 00       	call   103f70 <acquire>
  while(ip->flags & I_BUSY)
  101d9a:	8b 43 0c             	mov    0xc(%ebx),%eax
  101d9d:	a8 01                	test   $0x1,%al
  101d9f:	74 1e                	je     101dbf <ilock+0x4f>
  101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  101da8:	c7 44 24 04 c0 b2 10 	movl   $0x10b2c0,0x4(%esp)
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
  101dc5:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  101dcc:	e8 4f 21 00 00       	call   103f20 <release>

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
  101e40:	e8 4b 22 00 00       	call   104090 <memmove>
    brelse(bp);
  101e45:	89 34 24             	mov    %esi,(%esp)
  101e48:	e8 b3 e1 ff ff       	call   100000 <brelse>
    ip->flags |= I_VALID;
  101e4d:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
  101e51:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
  101e56:	0f 85 7b ff ff ff    	jne    101dd7 <ilock+0x67>
      panic("ilock: no type");
  101e5c:	c7 04 24 e0 69 10 00 	movl   $0x1069e0,(%esp)
  101e63:	e8 28 ec ff ff       	call   100a90 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
  101e68:	c7 04 24 da 69 10 00 	movl   $0x1069da,(%esp)
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
  101f11:	e8 7a 21 00 00       	call   104090 <memmove>
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
  101f89:	e8 02 21 00 00       	call   104090 <memmove>
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
  102036:	c7 44 24 04 ef 69 10 	movl   $0x1069ef,0x4(%esp)
  10203d:	00 
  10203e:	c7 04 24 c0 b2 10 00 	movl   $0x10b2c0,(%esp)
  102045:	e8 96 1d 00 00       	call   103de0 <initlock>
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
  1020ee:	c7 04 24 f6 69 10 00 	movl   $0x1069f6,(%esp)
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
  102127:	a1 98 90 10 00       	mov    0x109098,%eax
  10212c:	85 c0                	test   %eax,%eax
  10212e:	0f 84 7c 00 00 00    	je     1021b0 <iderw+0xb0>
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);
  102134:	c7 04 24 60 90 10 00 	movl   $0x109060,(%esp)
  10213b:	e8 30 1e 00 00       	call   103f70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)
  102140:	ba 94 90 10 00       	mov    $0x109094,%edx
    panic("idrw: ide disk 1 not present");

  acquire(&idelock);

  // Append b to idequeue.
  b->qnext = 0;
  102145:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  10214c:	a1 94 90 10 00       	mov    0x109094,%eax
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
  102164:	39 1d 94 90 10 00    	cmp    %ebx,0x109094
  10216a:	75 14                	jne    102180 <iderw+0x80>
  10216c:	eb 2d                	jmp    10219b <iderw+0x9b>
  10216e:	66 90                	xchg   %ax,%ax
    idestart(b);
  
  // Wait for request to finish.
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
    sleep(b, &idelock);
  102170:	c7 44 24 04 60 90 10 	movl   $0x109060,0x4(%esp)
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
  10218a:	c7 45 08 60 90 10 00 	movl   $0x109060,0x8(%ebp)
}
  102191:	83 c4 14             	add    $0x14,%esp
  102194:	5b                   	pop    %ebx
  102195:	5d                   	pop    %ebp
  // Assuming will not sleep too long: ignore proc->killed.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID) {
    sleep(b, &idelock);
  }

  release(&idelock);
  102196:	e9 85 1d 00 00       	jmp    103f20 <release>
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
  1021a4:	c7 04 24 ff 69 10 00 	movl   $0x1069ff,(%esp)
  1021ab:	e8 e0 e8 ff ff       	call   100a90 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("idrw: ide disk 1 not present");
  1021b0:	c7 04 24 28 6a 10 00 	movl   $0x106a28,(%esp)
  1021b7:	e8 d4 e8 ff ff       	call   100a90 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  1021bc:	c7 04 24 13 6a 10 00 	movl   $0x106a13,(%esp)
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
  1021d8:	c7 04 24 60 90 10 00 	movl   $0x109060,(%esp)
  1021df:	e8 8c 1d 00 00       	call   103f70 <acquire>
  if((b = idequeue) == 0){
  1021e4:	8b 1d 94 90 10 00    	mov    0x109094,%ebx
  1021ea:	85 db                	test   %ebx,%ebx
  1021ec:	74 7a                	je     102268 <ideintr+0x98>
    release(&idelock);
    cprintf("Spurious IDE interrupt.\n");
    return;
  }
  idequeue = b->qnext;
  1021ee:	8b 43 14             	mov    0x14(%ebx),%eax
  1021f1:	a3 94 90 10 00       	mov    %eax,0x109094

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
  10220d:	a1 94 90 10 00       	mov    0x109094,%eax
  102212:	85 c0                	test   %eax,%eax
  102214:	74 05                	je     10221b <ideintr+0x4b>
    idestart(idequeue);
  102216:	e8 35 fe ff ff       	call   102050 <idestart>

  release(&idelock);
  10221b:	c7 04 24 60 90 10 00 	movl   $0x109060,(%esp)
  102222:	e8 f9 1c 00 00       	call   103f20 <release>
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
  102268:	c7 04 24 60 90 10 00 	movl   $0x109060,(%esp)
  10226f:	e8 ac 1c 00 00       	call   103f20 <release>
    cprintf("Spurious IDE interrupt.\n");
  102274:	c7 04 24 45 6a 10 00 	movl   $0x106a45,(%esp)
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
  102296:	c7 44 24 04 5e 6a 10 	movl   $0x106a5e,0x4(%esp)
  10229d:	00 
  10229e:	c7 04 24 60 90 10 00 	movl   $0x109060,(%esp)
  1022a5:	e8 36 1b 00 00       	call   103de0 <initlock>
  picenable(IRQ_IDE);
  1022aa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
  1022b1:	e8 aa 0a 00 00       	call   102d60 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
  1022b6:	a1 e0 c8 10 00       	mov    0x10c8e0,%eax
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
  102308:	c7 05 98 90 10 00 01 	movl   $0x1,0x109098
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
  102320:	8b 15 e4 c2 10 00    	mov    0x10c2e4,%edx
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
  102330:	8b 15 94 c2 10 00    	mov    0x10c294,%edx
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
  10233f:	8b 15 94 c2 10 00    	mov    0x10c294,%edx
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
  10234b:	8b 0d 94 c2 10 00    	mov    0x10c294,%ecx

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
  102356:	a1 94 c2 10 00       	mov    0x10c294,%eax

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
  102378:	8b 0d e4 c2 10 00    	mov    0x10c2e4,%ecx
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
  1023aa:	0f b6 15 e0 c2 10 00 	movzbl 0x10c2e0,%edx
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  1023b1:	c7 05 94 c2 10 00 00 	movl   $0xfec00000,0x10c294
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
  1023cb:	c7 04 24 64 6a 10 00 	movl   $0x106a64,(%esp)
  1023d2:	e8 e9 e0 ff ff       	call   1004c0 <cprintf>
  1023d7:	8b 1d 94 c2 10 00    	mov    0x10c294,%ebx
  1023dd:	ba 10 00 00 00       	mov    $0x10,%edx
  1023e2:	31 c0                	xor    %eax,%eax
  1023e4:	eb 08                	jmp    1023ee <ioapicinit+0x7e>
  1023e6:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
  1023e8:	8b 1d 94 c2 10 00    	mov    0x10c294,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  1023ee:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
  1023f0:	8b 1d 94 c2 10 00    	mov    0x10c294,%ebx
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
  102405:	8b 0d 94 c2 10 00    	mov    0x10c294,%ecx
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
  102415:	8b 0d 94 c2 10 00    	mov    0x10c294,%ecx
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
  102437:	c7 04 24 a0 c2 10 00 	movl   $0x10c2a0,(%esp)
  10243e:	e8 2d 1b 00 00       	call   103f70 <acquire>
  r = kmem.freelist;
  102443:	8b 1d d4 c2 10 00    	mov    0x10c2d4,%ebx
  if(r)
  102449:	85 db                	test   %ebx,%ebx
  10244b:	74 07                	je     102454 <kalloc+0x24>
    kmem.freelist = r->next;
  10244d:	8b 03                	mov    (%ebx),%eax
  10244f:	a3 d4 c2 10 00       	mov    %eax,0x10c2d4
  release(&kmem.lock);
  102454:	c7 04 24 a0 c2 10 00 	movl   $0x10c2a0,(%esp)
  10245b:	e8 c0 1a 00 00       	call   103f20 <release>
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
  1024a5:	e8 66 1b 00 00       	call   104010 <memset>

  acquire(&kmem.lock);
  1024aa:	c7 04 24 a0 c2 10 00 	movl   $0x10c2a0,(%esp)
  1024b1:	e8 ba 1a 00 00       	call   103f70 <acquire>
  r = (struct run *) v;
  r->next = kmem.freelist;
  1024b6:	a1 d4 c2 10 00       	mov    0x10c2d4,%eax
  1024bb:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  1024bd:	89 1d d4 c2 10 00    	mov    %ebx,0x10c2d4
  release(&kmem.lock);
  1024c3:	c7 45 08 a0 c2 10 00 	movl   $0x10c2a0,0x8(%ebp)
}
  1024ca:	83 c4 14             	add    $0x14,%esp
  1024cd:	5b                   	pop    %ebx
  1024ce:	5d                   	pop    %ebp

  acquire(&kmem.lock);
  r = (struct run *) v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
  1024cf:	e9 4c 1a 00 00       	jmp    103f20 <release>
kfree(char *v)
{
  struct run *r;

  if(((uint) v) % PGSIZE || (uint)v < 1024*1024 || (uint)v >= PHYSTOP) 
    panic("kfree");
  1024d4:	c7 04 24 96 6a 10 00 	movl   $0x106a96,(%esp)
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
  1024e4:	bb 83 04 11 00       	mov    $0x110483,%ebx
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
  1024f2:	c7 44 24 04 9c 6a 10 	movl   $0x106a9c,0x4(%esp)
  1024f9:	00 
  1024fa:	c7 04 24 a0 c2 10 00 	movl   $0x10c2a0,(%esp)
  102501:	e8 da 18 00 00       	call   103de0 <initlock>
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
  10256d:	8b 15 9c 90 10 00    	mov    0x10909c,%edx
  102573:	f6 c2 40             	test   $0x40,%dl
  102576:	75 03                	jne    10257b <kbdgetc+0x3b>
  102578:	83 e0 7f             	and    $0x7f,%eax
    shift &= ~(shiftcode[data] | E0ESC);
  10257b:	0f b6 80 c0 6a 10 00 	movzbl 0x106ac0(%eax),%eax
  102582:	83 c8 40             	or     $0x40,%eax
  102585:	0f b6 c0             	movzbl %al,%eax
  102588:	f7 d0                	not    %eax
  10258a:	21 d0                	and    %edx,%eax
  10258c:	a3 9c 90 10 00       	mov    %eax,0x10909c
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
  102598:	8b 0d 9c 90 10 00    	mov    0x10909c,%ecx
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
  1025a8:	0f b6 90 c0 6a 10 00 	movzbl 0x106ac0(%eax),%edx
  1025af:	09 ca                	or     %ecx,%edx
  1025b1:	0f b6 88 c0 6b 10 00 	movzbl 0x106bc0(%eax),%ecx
  1025b8:	31 ca                	xor    %ecx,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
  1025ba:	89 d1                	mov    %edx,%ecx
  1025bc:	83 e1 03             	and    $0x3,%ecx
  1025bf:	8b 0c 8d c0 6c 10 00 	mov    0x106cc0(,%ecx,4),%ecx
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  1025c6:	89 15 9c 90 10 00    	mov    %edx,0x10909c
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
  1025ea:	83 0d 9c 90 10 00 40 	orl    $0x40,0x10909c
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
  102630:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  102646:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  102689:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  1026a6:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1026ab:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ae:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
  1026b5:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026b8:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1026bd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026c0:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
  1026c7:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1026ca:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1026cf:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026d2:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026d8:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1026dd:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026e0:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026e6:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1026eb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026ee:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
  1026f4:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1026f9:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1026fc:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
  102702:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  10271d:	a1 a0 90 10 00       	mov    0x1090a0,%eax
  102722:	8d 50 01             	lea    0x1(%eax),%edx
  102725:	85 c0                	test   %eax,%eax
  102727:	89 15 a0 90 10 00    	mov    %edx,0x1090a0
  10272d:	74 19                	je     102748 <cpunum+0x38>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if(lapic)
  10272f:	8b 15 d8 c2 10 00    	mov    0x10c2d8,%edx
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
  10274b:	c7 04 24 d0 6c 10 00 	movl   $0x106cd0,(%esp)
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
  102766:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  10276b:	c7 04 24 fc 6c 10 00 	movl   $0x106cfc,(%esp)
  102772:	89 44 24 08          	mov    %eax,0x8(%esp)
  102776:	8b 45 08             	mov    0x8(%ebp),%eax
  102779:	89 44 24 04          	mov    %eax,0x4(%esp)
  10277d:	e8 3e dd ff ff       	call   1004c0 <cprintf>
  if(!lapic) 
  102782:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  102799:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  10279e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027a1:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
  1027a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  1027ab:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1027b0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027b3:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
  1027ba:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
  1027bd:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1027c2:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027c5:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
  1027cc:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
  1027cf:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1027d4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027d7:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
  1027de:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1027e1:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  1027e6:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  1027e9:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
  1027f0:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
  1027f3:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  102814:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  102819:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10281c:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102823:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102826:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  10282b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  10282e:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
  102835:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  102838:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  10283d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102840:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  102847:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10284a:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  10284f:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102852:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
  102859:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
  10285c:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
  102861:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
  102864:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
  10286b:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
  10286e:	8b 0d d8 c2 10 00    	mov    0x10c2d8,%ecx
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
  102891:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  1028aa:	a1 d8 c2 10 00       	mov    0x10c2d8,%eax
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
  1028d7:	e8 b4 3e 00 00       	call   106790 <ksegment>
  1028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapicinit(cpunum());
  1028e0:	e8 2b fe ff ff       	call   102710 <cpunum>
  1028e5:	89 04 24             	mov    %eax,(%esp)
  1028e8:	e8 73 fe ff ff       	call   102760 <lapicinit>
  }
  vmenable();        // turn on paging
  1028ed:	e8 9e 37 00 00       	call   106090 <vmenable>
  cprintf("cpu%d: starting\n", cpu->id);
  1028f2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1028f8:	0f b6 00             	movzbl (%eax),%eax
  1028fb:	c7 04 24 10 6d 10 00 	movl   $0x106d10,(%esp)
  102902:	89 44 24 04          	mov    %eax,0x4(%esp)
  102906:	e8 b5 db ff ff       	call   1004c0 <cprintf>
  idtinit();       // load idt register
  10290b:	e8 80 28 00 00       	call   105190 <idtinit>
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
  102940:	c7 04 24 21 6d 10 00 	movl   $0x106d21,(%esp)
  102947:	89 44 24 04          	mov    %eax,0x4(%esp)
  10294b:	e8 70 db ff ff       	call   1004c0 <cprintf>
  kvmalloc();      // initialize the kernel page table
  102950:	e8 fb 39 00 00       	call   106350 <kvmalloc>
  pinit();         // process table
  102955:	e8 66 14 00 00       	call   103dc0 <pinit>
  tvinit();        // trap vectors
  10295a:	e8 d1 2a 00 00       	call   105430 <tvinit>
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
  102975:	a1 e4 c2 10 00       	mov    0x10c2e4,%eax
  10297a:	85 c0                	test   %eax,%eax
  10297c:	0f 84 ab 00 00 00    	je     102a2d <mainc+0xfd>
    timerinit();   // uniprocessor timer
  userinit();      // first user process
  102982:	e8 79 12 00 00       	call   103c00 <userinit>
  char *stack;

  // Write bootstrap code to unused memory at 0x7000.  The linker has
  // placed the start of bootother.S there.
  code = (uchar *) 0x7000;
  memmove(code, _binary_bootother_start, (uint)_binary_bootother_size);
  102987:	c7 44 24 08 6a 00 00 	movl   $0x6a,0x8(%esp)
  10298e:	00 
  10298f:	c7 44 24 04 34 89 10 	movl   $0x108934,0x4(%esp)
  102996:	00 
  102997:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
  10299e:	e8 ed 16 00 00       	call   104090 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
  1029a3:	69 05 e0 c8 10 00 bc 	imul   $0xbc,0x10c8e0,%eax
  1029aa:	00 00 00 
  1029ad:	05 00 c3 10 00       	add    $0x10c300,%eax
  1029b2:	3d 00 c3 10 00       	cmp    $0x10c300,%eax
  1029b7:	76 6a                	jbe    102a23 <mainc+0xf3>
  1029b9:	bb 00 c3 10 00       	mov    $0x10c300,%ebx
  1029be:	66 90                	xchg   %ax,%ax
    if(c == cpus+cpunum())  // We've started already.
  1029c0:	e8 4b fd ff ff       	call   102710 <cpunum>
  1029c5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1029cb:	05 00 c3 10 00       	add    $0x10c300,%eax
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
  102a0a:	69 05 e0 c8 10 00 bc 	imul   $0xbc,0x10c8e0,%eax
  102a11:	00 00 00 
  102a14:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
  102a1a:	05 00 c3 10 00       	add    $0x10c300,%eax
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
  102a2d:	e8 fe 26 00 00       	call   105130 <timerinit>
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
  102a5b:	c7 04 24 41 6d 10 00 	movl   $0x106d41,(%esp)
  102a62:	e8 29 e0 ff ff       	call   100a90 <panic>
  102a67:	90                   	nop
void
jkstack(void)
{
  char *kstack = kalloc();
  if(!kstack)
    panic("jkstack\n");
  102a68:	c7 04 24 38 6d 10 00 	movl   $0x106d38,(%esp)
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
  102a9b:	e8 f0 3c 00 00       	call   106790 <ksegment>
  picinit();       // interrupt controller
  102aa0:	e8 eb 02 00 00       	call   102d90 <picinit>
  ioapicinit();    // another interrupt controller
  102aa5:	e8 c6 f8 ff ff       	call   102370 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
  102aaa:	e8 41 d7 ff ff       	call   1001f0 <consoleinit>
  102aaf:	90                   	nop
  uartinit();      // serial port
  102ab0:	e8 ab 2a 00 00       	call   105560 <uartinit>
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
  102ac0:	a1 a4 90 10 00       	mov    0x1090a4,%eax
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
  102ac9:	2d 00 c3 10 00       	sub    $0x10c300,%eax
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
  102af7:	c7 04 24 49 6d 10 00 	movl   $0x106d49,(%esp)
  102afe:	e8 bd d9 ff ff       	call   1004c0 <cprintf>
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
  102b03:	39 f3                	cmp    %esi,%ebx
  102b05:	73 3a                	jae    102b41 <mpsearch1+0x61>
  102b07:	90                   	nop
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
  102b08:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  102b0f:	00 
  102b10:	c7 44 24 04 5c 6d 10 	movl   $0x106d5c,0x4(%esp)
  102b17:	00 
  102b18:	89 1c 24             	mov    %ebx,(%esp)
  102b1b:	e8 10 15 00 00       	call   104030 <memcmp>
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
  102b77:	c7 05 a4 90 10 00 00 	movl   $0x10c300,0x1090a4
  102b7e:	c3 10 00 
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
  102bcb:	c7 44 24 04 61 6d 10 	movl   $0x106d61,0x4(%esp)
  102bd2:	00 
  102bd3:	89 34 24             	mov    %esi,(%esp)
  102bd6:	e8 55 14 00 00       	call   104030 <memcmp>
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
  102c11:	c7 05 e4 c2 10 00 01 	movl   $0x1,0x10c2e4
  102c18:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
  102c1b:	8b 46 24             	mov    0x24(%esi),%eax
  102c1e:	a3 d8 c2 10 00       	mov    %eax,0x10c2d8
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
  102c23:	0f b7 56 04          	movzwl 0x4(%esi),%edx
  102c27:	8d 46 2c             	lea    0x2c(%esi),%eax
  102c2a:	8d 14 16             	lea    (%esi,%edx,1),%edx
  102c2d:	39 d0                	cmp    %edx,%eax
  102c2f:	73 61                	jae    102c92 <mpinit+0x132>
  102c31:	8b 0d a4 90 10 00    	mov    0x1090a4,%ecx
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
  102c4e:	c7 04 24 88 6d 10 00 	movl   $0x106d88,(%esp)
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
  102c55:	a3 a4 90 10 00       	mov    %eax,0x1090a4
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
  102c5a:	e8 61 d8 ff ff       	call   1004c0 <cprintf>
      panic("mpinit");
  102c5f:	c7 04 24 81 6d 10 00 	movl   $0x106d81,(%esp)
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
  102c73:	ff 24 8d a8 6d 10 00 	jmp    *0x106da8(,%ecx,4)
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
  102c8c:	89 0d a4 90 10 00    	mov    %ecx,0x1090a4
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
  102cbc:	8b 3d e0 c8 10 00    	mov    0x10c8e0,%edi
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
  102cd5:	81 c7 00 c3 10 00    	add    $0x10c300,%edi
  102cdb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      cpus[ncpu].id = ncpu;
  102cde:	69 f9 bc 00 00 00    	imul   $0xbc,%ecx,%edi
      ncpu++;
  102ce4:	83 c1 01             	add    $0x1,%ecx
  102ce7:	89 0d e0 c8 10 00    	mov    %ecx,0x10c8e0
      p += sizeof(struct mpproc);
  102ced:	83 c0 14             	add    $0x14,%eax
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
        panic("mpinit");
      }
      if(proc->flags & MPBOOT)
        bcpu = &cpus[ncpu];
      cpus[ncpu].id = ncpu;
  102cf0:	88 9f 00 c3 10 00    	mov    %bl,0x10c300(%edi)
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
  102cff:	88 0d e0 c2 10 00    	mov    %cl,0x10c2e0
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
  102d3c:	c7 04 24 66 6d 10 00 	movl   $0x106d66,(%esp)
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu != proc->apicid) {
  102d43:	a3 a4 90 10 00       	mov    %eax,0x1090a4
        cprintf("mpinit: ncpu=%d apicpid=%d", ncpu, proc->apicid);
  102d48:	e8 73 d7 ff ff       	call   1004c0 <cprintf>
        panic("mpinit");
  102d4d:	c7 04 24 81 6d 10 00 	movl   $0x106d81,(%esp)
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
  102d72:	66 23 05 00 85 10 00 	and    0x108500,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
  102d79:	66 a3 00 85 10 00    	mov    %ax,0x108500
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
  102e08:	0f b7 05 00 85 10 00 	movzwl 0x108500,%eax
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
  102e42:	e8 29 11 00 00       	call   103f70 <acquire>
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
  102efb:	e8 20 10 00 00       	call   103f20 <release>
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
  102f18:	e8 03 10 00 00       	call   103f20 <release>
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
  102f45:	e8 26 10 00 00       	call   103f70 <acquire>
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
  102fed:	e8 2e 0f 00 00       	call   103f20 <release>
  return n;
  102ff2:	eb 13                	jmp    103007 <pipewrite+0xd7>
  102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE) {  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
  102ff8:	89 1c 24             	mov    %ebx,(%esp)
  102ffb:	e8 20 0f 00 00       	call   103f20 <release>
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
  103035:	e8 36 0f 00 00       	call   103f70 <acquire>
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
  103076:	e9 a5 0e 00 00       	jmp    103f20 <release>
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
  1030a3:	e8 78 0e 00 00       	call   103f20 <release>
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
  10312f:	c7 44 24 04 bc 6d 10 	movl   $0x106dbc,0x4(%esp)
  103136:	00 
  103137:	e8 a4 0c 00 00       	call   103de0 <initlock>
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
  1031b6:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
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
  1031c0:	e8 ab 0d 00 00       	call   103f70 <acquire>
  proc->priority = !(proc->priority);
  1031c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1031cb:	31 d2                	xor    %edx,%edx
  1031cd:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  1031d4:	0f 94 c2             	sete   %dl
  1031d7:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  release(&ptable.lock);
  1031dd:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1031e4:	e8 37 0d 00 00       	call   103f20 <release>
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
  proc->priority = !(proc->priority);
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
  10321a:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103221:	e8 4a 0d 00 00       	call   103f70 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
  103226:	8b 15 44 c9 10 00    	mov    0x10c944,%edx

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
  10322c:	b8 c0 c9 10 00       	mov    $0x10c9c0,%eax
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
  10323d:	3d 34 ec 10 00       	cmp    $0x10ec34,%eax
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
  103258:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10325f:	e8 bc 0c 00 00       	call   103f20 <release>
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
  103280:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103287:	e8 94 0c 00 00       	call   103f20 <release>
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
  103297:	b8 34 c9 10 00       	mov    $0x10c934,%eax
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
  1032aa:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1032b1:	e8 ba 0c 00 00       	call   103f70 <acquire>
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
  1032b6:	b8 34 c9 10 00       	mov    $0x10c934,%eax
  1032bb:	eb 0f                	jmp    1032cc <wakeup+0x2c>
  1032bd:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1032c0:	05 8c 00 00 00       	add    $0x8c,%eax
  1032c5:	3d 34 ec 10 00       	cmp    $0x10ec34,%eax
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
  1032e3:	3d 34 ec 10 00       	cmp    $0x10ec34,%eax
  1032e8:	75 e2                	jne    1032cc <wakeup+0x2c>
  1032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
  1032f0:	c7 45 08 00 c9 10 00 	movl   $0x10c900,0x8(%ebp)
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
  1032fc:	e9 1f 0c 00 00       	jmp    103f20 <release>
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
  103316:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10331d:	e8 fe 0b 00 00       	call   103f20 <release>
  
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
  103337:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  10333e:	e8 2d 0c 00 00       	call   103f70 <acquire>
 xticks = ticks;
  103343:	8b 1d 80 f4 10 00    	mov    0x10f480,%ebx
 release(&tickslock);
  103349:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  103350:	e8 cb 0b 00 00       	call   103f20 <release>
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
  103367:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10336e:	e8 ed 0a 00 00       	call   103e60 <holding>
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
  1033ad:	e8 5a 0e 00 00       	call   10420c <swtch>
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
  1033c4:	c7 04 24 c1 6d 10 00 	movl   $0x106dc1,(%esp)
  1033cb:	e8 c0 d6 ff ff       	call   100a90 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  1033d0:	c7 04 24 ed 6d 10 00 	movl   $0x106ded,(%esp)
  1033d7:	e8 b4 d6 ff ff       	call   100a90 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  1033dc:	c7 04 24 df 6d 10 00 	movl   $0x106ddf,(%esp)
  1033e3:	e8 a8 d6 ff ff       	call   100a90 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  1033e8:	c7 04 24 d3 6d 10 00 	movl   $0x106dd3,(%esp)
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
  103424:	81 fb 00 c9 10 00    	cmp    $0x10c900,%ebx
  10342a:	74 5c                	je     103488 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
  10342c:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103433:	e8 38 0b 00 00       	call   103f70 <acquire>
    release(lk);
  103438:	89 1c 24             	mov    %ebx,(%esp)
  10343b:	e8 e0 0a 00 00       	call   103f20 <release>
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
  103468:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10346f:	e8 ac 0a 00 00       	call   103f20 <release>
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
  10347d:	e9 ee 0a 00 00       	jmp    103f70 <acquire>
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
  1034b1:	c7 04 24 07 6e 10 00 	movl   $0x106e07,(%esp)
  1034b8:	e8 d3 d5 ff ff       	call   100a90 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
  1034bd:	c7 04 24 01 6e 10 00 	movl   $0x106e01,(%esp)
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
  1034d6:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1034dd:	e8 8e 0a 00 00       	call   103f70 <acquire>
  proc->state = RUNNABLE;
  1034e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1034e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
  1034ef:	e8 6c fe ff ff       	call   103360 <sched>
  release(&ptable.lock);
  1034f4:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1034fb:	e8 20 0a 00 00       	call   103f20 <release>
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
  103513:	53                   	push   %ebx
  103514:	83 ec 14             	sub    $0x14,%esp
  103517:	90                   	nop
}

static inline void
sti(void)
{
  asm volatile("sti");
  103518:	fb                   	sti    
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
  103519:	bb 34 c9 10 00       	mov    $0x10c934,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
  10351e:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103525:	e8 46 0a 00 00       	call   103f70 <acquire>
  10352a:	eb 12                	jmp    10353e <scheduler+0x2e>
  10352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103530:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103536:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  10353c:	74 5a                	je     103598 <scheduler+0x88>
	continue;
	}
	
     loop = 0;
#else
      if(p->state != RUNNABLE) 
  10353e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  103542:	75 ec                	jne    103530 <scheduler+0x20>


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
  103544:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
  10354b:	89 1c 24             	mov    %ebx,(%esp)
  10354e:	e8 8d 31 00 00       	call   1066e0 <switchuvm>
      p->state = RUNNING;

      swtch(&cpu->scheduler, proc->context);
  103553:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
  103559:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103560:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&cpu->scheduler, proc->context);
  103566:	8b 40 1c             	mov    0x1c(%eax),%eax
  103569:	89 44 24 04          	mov    %eax,0x4(%esp)
  10356d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103573:	83 c0 04             	add    $0x4,%eax
  103576:	89 04 24             	mov    %eax,(%esp)
  103579:	e8 8e 0c 00 00       	call   10420c <swtch>
      switchkvm();
  10357e:	e8 2d 2b 00 00       	call   1060b0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103583:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
  103589:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  103590:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103594:	75 a8                	jne    10353e <scheduler+0x2e>
  103596:	66 90                	xchg   %ax,%ax

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
  103598:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10359f:	e8 7c 09 00 00       	call   103f20 <release>

  }
  1035a4:	e9 6f ff ff ff       	jmp    103518 <scheduler+0x8>
  1035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001035b0 <wait2>:
  }
}

int
wait2(int* wtime, int* rtime)
{
  1035b0:	55                   	push   %ebp
  1035b1:	89 e5                	mov    %esp,%ebp
  1035b3:	57                   	push   %edi
  1035b4:	56                   	push   %esi
  1035b5:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  1035b6:	bb 34 c9 10 00       	mov    $0x10c934,%ebx
  }
}

int
wait2(int* wtime, int* rtime)
{
  1035bb:	83 ec 2c             	sub    $0x2c,%esp
  1035be:	8b 7d 08             	mov    0x8(%ebp),%edi
  1035c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p;
  int havekids, pid;
	
  acquire(&ptable.lock);
  1035c4:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1035cb:	e8 a0 09 00 00       	call   103f70 <acquire>
  1035d0:	31 c0                	xor    %eax,%eax
  1035d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1035d8:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  1035de:	72 30                	jb     103610 <wait2+0x60>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  1035e0:	85 c0                	test   %eax,%eax
  1035e2:	74 54                	je     103638 <wait2+0x88>
  1035e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1035ea:	8b 50 24             	mov    0x24(%eax),%edx
  1035ed:	85 d2                	test   %edx,%edx
  1035ef:	75 47                	jne    103638 <wait2+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  1035f1:	bb 34 c9 10 00       	mov    $0x10c934,%ebx
  1035f6:	89 04 24             	mov    %eax,(%esp)
  1035f9:	c7 44 24 04 00 c9 10 	movl   $0x10c900,0x4(%esp)
  103600:	00 
  103601:	e8 fa fd ff ff       	call   103400 <sleep>
  103606:	31 c0                	xor    %eax,%eax
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103608:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  10360e:	73 d0                	jae    1035e0 <wait2+0x30>
      if(p->parent != proc)
  103610:	8b 53 14             	mov    0x14(%ebx),%edx
  103613:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
  10361a:	74 0c                	je     103628 <wait2+0x78>
	
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  10361c:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103622:	eb b4                	jmp    1035d8 <wait2+0x28>
  103624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  103628:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  10362c:	74 23                	je     103651 <wait2+0xa1>
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
  10362e:	b8 01 00 00 00       	mov    $0x1,%eax
  103633:	eb e7                	jmp    10361c <wait2+0x6c>
  103635:	8d 76 00             	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  103638:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10363f:	e8 dc 08 00 00       	call   103f20 <release>
  103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  103649:	83 c4 2c             	add    $0x2c,%esp
  10364c:	5b                   	pop    %ebx
  10364d:	5e                   	pop    %esi
  10364e:	5f                   	pop    %edi
  10364f:	5d                   	pop    %ebp
  103650:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
  103651:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  103657:	2b 43 7c             	sub    0x7c(%ebx),%eax
  10365a:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
  103660:	89 07                	mov    %eax,(%edi)
	*rtime = (p->rtime); 
  103662:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  103668:	89 06                	mov    %eax,(%esi)
	cprintf("\nwtime: %d\n",*wtime);
  10366a:	8b 07                	mov    (%edi),%eax
  10366c:	c7 04 24 18 6e 10 00 	movl   $0x106e18,(%esp)
  103673:	89 44 24 04          	mov    %eax,0x4(%esp)
  103677:	e8 44 ce ff ff       	call   1004c0 <cprintf>
	cprintf("rtime: %d\n",*rtime);
  10367c:	8b 06                	mov    (%esi),%eax
  10367e:	c7 04 24 24 6e 10 00 	movl   $0x106e24,(%esp)
  103685:	89 44 24 04          	mov    %eax,0x4(%esp)
  103689:	e8 32 ce ff ff       	call   1004c0 <cprintf>
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
  10368e:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
  103691:	8b 53 08             	mov    0x8(%ebx),%edx
        // Found one.
	*wtime = ((p-> etime) - (p-> ctime)) - (p->rtime);
	*rtime = (p->rtime); 
	cprintf("\nwtime: %d\n",*wtime);
	cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
  103694:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  10369b:	00 00 00 
	p->ctime = 0;
  10369e:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->etime = 0;
        pid = p->pid;
        kfree(p->kstack);
  1036a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1036a8:	89 14 24             	mov    %edx,(%esp)
	*rtime = (p->rtime); 
	cprintf("\nwtime: %d\n",*wtime);
	cprintf("rtime: %d\n",*rtime);
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
  1036ab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  1036b2:	00 00 00 
        pid = p->pid;
        kfree(p->kstack);
  1036b5:	e8 b6 ed ff ff       	call   102470 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
  1036ba:	8b 53 04             	mov    0x4(%ebx),%edx
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
  1036bd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
  1036c4:	89 14 24             	mov    %edx,(%esp)
  1036c7:	e8 44 2d 00 00       	call   106410 <freevm>
        p->state = UNUSED;
  1036cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  1036d3:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  1036da:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  1036e1:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  1036e5:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->priority = 0;
  1036ec:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  1036f3:	00 00 00 
        release(&ptable.lock);
  1036f6:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1036fd:	e8 1e 08 00 00       	call   103f20 <release>
        return pid;
  103702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103705:	e9 3f ff ff ff       	jmp    103649 <wait2+0x99>
  10370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00103710 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103710:	55                   	push   %ebp
  103711:	89 e5                	mov    %esp,%ebp
  103713:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  103714:	bb 34 c9 10 00       	mov    $0x10c934,%ebx

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  103719:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  10371c:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103723:	e8 48 08 00 00       	call   103f70 <acquire>
  103728:	31 c0                	xor    %eax,%eax
  10372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103730:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  103736:	72 30                	jb     103768 <wait+0x58>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
  103738:	85 c0                	test   %eax,%eax
  10373a:	74 5c                	je     103798 <wait+0x88>
  10373c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103742:	8b 48 24             	mov    0x24(%eax),%ecx
  103745:	85 c9                	test   %ecx,%ecx
  103747:	75 4f                	jne    103798 <wait+0x88>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  103749:	bb 34 c9 10 00       	mov    $0x10c934,%ebx
  10374e:	89 04 24             	mov    %eax,(%esp)
  103751:	c7 44 24 04 00 c9 10 	movl   $0x10c900,0x4(%esp)
  103758:	00 
  103759:	e8 a2 fc ff ff       	call   103400 <sleep>
  10375e:	31 c0                	xor    %eax,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103760:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  103766:	73 d0                	jae    103738 <wait+0x28>
      if(p->parent != proc)
  103768:	8b 53 14             	mov    0x14(%ebx),%edx
  10376b:	65 3b 15 04 00 00 00 	cmp    %gs:0x4,%edx
  103772:	74 0c                	je     103780 <wait+0x70>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103774:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  10377a:	eb b4                	jmp    103730 <wait+0x20>
  10377c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
  103780:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  103784:	74 29                	je     1037af <wait+0x9f>
	p->rtime = 0;
	p->ctime = 0;
	p->etime = 0;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
  103786:	b8 01 00 00 00       	mov    $0x1,%eax
  10378b:	90                   	nop
  10378c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103790:	eb e2                	jmp    103774 <wait+0x64>
  103792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
  103798:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10379f:	e8 7c 07 00 00       	call   103f20 <release>
  1037a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
  1037a9:	83 c4 24             	add    $0x24,%esp
  1037ac:	5b                   	pop    %ebx
  1037ad:	5d                   	pop    %ebp
  1037ae:	c3                   	ret    
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
  1037af:	8b 43 10             	mov    0x10(%ebx),%eax
        kfree(p->kstack);
  1037b2:	8b 53 08             	mov    0x8(%ebx),%edx
  1037b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1037b8:	89 14 24             	mov    %edx,(%esp)
  1037bb:	e8 b0 ec ff ff       	call   102470 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
  1037c0:	8b 53 04             	mov    0x4(%ebx),%edx
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
  1037c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
  1037ca:	89 14 24             	mov    %edx,(%esp)
  1037cd:	e8 3e 2c 00 00       	call   106410 <freevm>
        p->state = UNUSED;
  1037d2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
  1037d9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
  1037e0:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
  1037e7:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
  1037eb:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
	p->rtime = 0;
  1037f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  1037f9:	00 00 00 
	p->ctime = 0;
  1037fc:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->etime = 0;
  103803:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  10380a:	00 00 00 
	p->priority = 0;
  10380d:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103814:	00 00 00 
        release(&ptable.lock);
  103817:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10381e:	e8 fd 06 00 00       	call   103f20 <release>
        return pid;
  103823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103826:	eb 81                	jmp    1037a9 <wait+0x99>
  103828:	90                   	nop
  103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00103830 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  103830:	55                   	push   %ebp
  103831:	89 e5                	mov    %esp,%ebp
  103833:	56                   	push   %esi
  103834:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
  103835:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  103837:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
  10383a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103841:	3b 15 a8 90 10 00    	cmp    0x1090a8,%edx
  103847:	0f 84 15 01 00 00    	je     103962 <exit+0x132>
  10384d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
  103850:	8d 73 08             	lea    0x8(%ebx),%esi
  103853:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
  103857:	85 c0                	test   %eax,%eax
  103859:	74 1d                	je     103878 <exit+0x48>
      fileclose(proc->ofile[fd]);
  10385b:	89 04 24             	mov    %eax,(%esp)
  10385e:	e8 dd d8 ff ff       	call   101140 <fileclose>
      proc->ofile[fd] = 0;
  103863:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103869:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
  103870:	00 
  103871:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
  103878:	83 c3 01             	add    $0x1,%ebx
  10387b:	83 fb 10             	cmp    $0x10,%ebx
  10387e:	75 d0                	jne    103850 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  103880:	8b 42 68             	mov    0x68(%edx),%eax
  103883:	89 04 24             	mov    %eax,(%esp)
  103886:	e8 b5 e1 ff ff       	call   101a40 <iput>
  proc->cwd = 0;
  10388b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103891:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
  103898:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10389f:	e8 cc 06 00 00       	call   103f70 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  1038a4:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
  1038ab:	b8 34 c9 10 00       	mov    $0x10c934,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  1038b0:	8b 51 14             	mov    0x14(%ecx),%edx
  1038b3:	eb 0f                	jmp    1038c4 <exit+0x94>
  1038b5:	8d 76 00             	lea    0x0(%esi),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1038b8:	05 8c 00 00 00       	add    $0x8c,%eax
  1038bd:	3d 34 ec 10 00       	cmp    $0x10ec34,%eax
  1038c2:	74 1e                	je     1038e2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
  1038c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  1038c8:	75 ee                	jne    1038b8 <exit+0x88>
  1038ca:	3b 50 20             	cmp    0x20(%eax),%edx
  1038cd:	75 e9                	jne    1038b8 <exit+0x88>
      p->state = RUNNABLE;
  1038cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  1038d6:	05 8c 00 00 00       	add    $0x8c,%eax
  1038db:	3d 34 ec 10 00       	cmp    $0x10ec34,%eax
  1038e0:	75 e2                	jne    1038c4 <exit+0x94>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  1038e2:	8b 1d a8 90 10 00    	mov    0x1090a8,%ebx
  1038e8:	ba 34 c9 10 00       	mov    $0x10c934,%edx
  1038ed:	eb 0f                	jmp    1038fe <exit+0xce>
  1038ef:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  1038f0:	81 c2 8c 00 00 00    	add    $0x8c,%edx
  1038f6:	81 fa 34 ec 10 00    	cmp    $0x10ec34,%edx
  1038fc:	74 3a                	je     103938 <exit+0x108>
    if(p->parent == proc){
  1038fe:	3b 4a 14             	cmp    0x14(%edx),%ecx
  103901:	75 ed                	jne    1038f0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
  103903:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
  103907:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
  10390a:	75 e4                	jne    1038f0 <exit+0xc0>
  10390c:	b8 34 c9 10 00       	mov    $0x10c934,%eax
  103911:	eb 11                	jmp    103924 <exit+0xf4>
  103913:	90                   	nop
  103914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103918:	05 8c 00 00 00       	add    $0x8c,%eax
  10391d:	3d 34 ec 10 00       	cmp    $0x10ec34,%eax
  103922:	74 cc                	je     1038f0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
  103924:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  103928:	75 ee                	jne    103918 <exit+0xe8>
  10392a:	3b 58 20             	cmp    0x20(%eax),%ebx
  10392d:	75 e9                	jne    103918 <exit+0xe8>
      p->state = RUNNABLE;
  10392f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  103936:	eb e0                	jmp    103918 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  103938:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  proc->etime = clockticks();
  10393f:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
  103946:	e8 e5 f9 ff ff       	call   103330 <clockticks>
  10394b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  sched();
  103951:	e8 0a fa ff ff       	call   103360 <sched>
  panic("zombie exit");
  103956:	c7 04 24 3c 6e 10 00 	movl   $0x106e3c,(%esp)
  10395d:	e8 2e d1 ff ff       	call   100a90 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
  103962:	c7 04 24 2f 6e 10 00 	movl   $0x106e2f,(%esp)
  103969:	e8 22 d1 ff ff       	call   100a90 <panic>
  10396e:	66 90                	xchg   %ax,%ax

00103970 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  103970:	55                   	push   %ebp
  103971:	89 e5                	mov    %esp,%ebp
  103973:	53                   	push   %ebx
  103974:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  103977:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  10397e:	e8 ed 05 00 00       	call   103f70 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
  103983:	8b 15 40 c9 10 00    	mov    0x10c940,%edx
  103989:	85 d2                	test   %edx,%edx
  10398b:	0f 84 cd 00 00 00    	je     103a5e <allocproc+0xee>

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and return it.
// Otherwise return 0.
static struct proc*
allocproc(void)
  103991:	bb c0 c9 10 00       	mov    $0x10c9c0,%ebx
  103996:	eb 12                	jmp    1039aa <allocproc+0x3a>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  103998:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  10399e:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  1039a4:	0f 84 9e 00 00 00    	je     103a48 <allocproc+0xd8>
    if(p->state == UNUSED)
  1039aa:	8b 43 0c             	mov    0xc(%ebx),%eax
  1039ad:	85 c0                	test   %eax,%eax
  1039af:	75 e7                	jne    103998 <allocproc+0x28>
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  1039b1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  1039b8:	a1 04 85 10 00       	mov    0x108504,%eax
  1039bd:	89 43 10             	mov    %eax,0x10(%ebx)
  1039c0:	83 c0 01             	add    $0x1,%eax
  1039c3:	a3 04 85 10 00       	mov    %eax,0x108504
  release(&ptable.lock);
  1039c8:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  1039cf:	e8 4c 05 00 00       	call   103f20 <release>

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
  1039d4:	e8 57 ea ff ff       	call   102430 <kalloc>
  1039d9:	85 c0                	test   %eax,%eax
  1039db:	89 43 08             	mov    %eax,0x8(%ebx)
  1039de:	0f 84 84 00 00 00    	je     103a68 <allocproc+0xf8>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  1039e4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
  1039ea:	89 53 18             	mov    %edx,0x18(%ebx)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret (see below).
  sp -= 4;
  *(uint*)sp = (uint)trapret;
  1039ed:	c7 80 b0 0f 00 00 80 	movl   $0x105180,0xfb0(%eax)
  1039f4:	51 10 00 

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  1039f7:	05 9c 0f 00 00       	add    $0xf9c,%eax
  1039fc:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
  1039ff:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  103a06:	00 
  103a07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103a0e:	00 
  103a0f:	89 04 24             	mov    %eax,(%esp)
  103a12:	e8 f9 05 00 00       	call   104010 <memset>
  p->context->eip = (uint)forkret;
  103a17:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103a1a:	c7 40 10 10 33 10 00 	movl   $0x103310,0x10(%eax)


  p->ctime = clockticks();
  103a21:	e8 0a f9 ff ff       	call   103330 <clockticks>
  p->rtime = 0;
  103a26:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  103a2d:	00 00 00 
  p->priority = 0;
  103a30:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
  103a37:	00 00 00 
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;


  p->ctime = clockticks();
  103a3a:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}
  103a3d:	89 d8                	mov    %ebx,%eax
  103a3f:	83 c4 14             	add    $0x14,%esp
  103a42:	5b                   	pop    %ebx
  103a43:	5d                   	pop    %ebp
  103a44:	c3                   	ret    
  103a45:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  103a48:	31 db                	xor    %ebx,%ebx
  103a4a:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103a51:	e8 ca 04 00 00       	call   103f20 <release>
  p->rtime = 0;
  p->priority = 0;
  //cprintf("%d",clockticks());

  return p;
}
  103a56:	89 d8                	mov    %ebx,%eax
  103a58:	83 c4 14             	add    $0x14,%esp
  103a5b:	5b                   	pop    %ebx
  103a5c:	5d                   	pop    %ebp
  103a5d:	c3                   	ret    
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  103a5e:	bb 34 c9 10 00       	mov    $0x10c934,%ebx
  103a63:	e9 49 ff ff ff       	jmp    1039b1 <allocproc+0x41>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack if possible.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
  103a68:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  103a6f:	31 db                	xor    %ebx,%ebx
    return 0;
  103a71:	eb ca                	jmp    103a3d <allocproc+0xcd>
  103a73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103a80 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103a80:	55                   	push   %ebp
  103a81:	89 e5                	mov    %esp,%ebp
  103a83:	57                   	push   %edi
  103a84:	56                   	push   %esi
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103a85:	be ff ff ff ff       	mov    $0xffffffff,%esi
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  103a8a:	53                   	push   %ebx
  103a8b:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
  103a8e:	e8 dd fe ff ff       	call   103970 <allocproc>
  103a93:	85 c0                	test   %eax,%eax
  103a95:	89 c3                	mov    %eax,%ebx
  103a97:	0f 84 be 00 00 00    	je     103b5b <fork+0xdb>
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
  103a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103aa3:	8b 10                	mov    (%eax),%edx
  103aa5:	89 54 24 04          	mov    %edx,0x4(%esp)
  103aa9:	8b 40 04             	mov    0x4(%eax),%eax
  103aac:	89 04 24             	mov    %eax,(%esp)
  103aaf:	e8 dc 29 00 00       	call   106490 <copyuvm>
  103ab4:	85 c0                	test   %eax,%eax
  103ab6:	89 43 04             	mov    %eax,0x4(%ebx)
  103ab9:	0f 84 a6 00 00 00    	je     103b65 <fork+0xe5>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  103abf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
  103ac5:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  103aca:	8b 00                	mov    (%eax),%eax
  103acc:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
  103ace:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103ad4:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
  103ad7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103ade:	8b 43 18             	mov    0x18(%ebx),%eax
  103ae1:	8b 72 18             	mov    0x18(%edx),%esi
  103ae4:	89 c7                	mov    %eax,%edi
  103ae6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  103ae8:	31 f6                	xor    %esi,%esi
  103aea:	8b 43 18             	mov    0x18(%ebx),%eax
  103aed:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  103af4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103afb:	90                   	nop
  103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
  103b00:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
  103b04:	85 c0                	test   %eax,%eax
  103b06:	74 13                	je     103b1b <fork+0x9b>
      np->ofile[i] = filedup(proc->ofile[i]);
  103b08:	89 04 24             	mov    %eax,(%esp)
  103b0b:	e8 60 d5 ff ff       	call   101070 <filedup>
  103b10:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  103b14:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
  103b1b:	83 c6 01             	add    $0x1,%esi
  103b1e:	83 fe 10             	cmp    $0x10,%esi
  103b21:	75 dd                	jne    103b00 <fork+0x80>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  103b23:	8b 42 68             	mov    0x68(%edx),%eax
  103b26:	89 04 24             	mov    %eax,(%esp)
  103b29:	e8 42 d7 ff ff       	call   101270 <idup>
 
  pid = np->pid;
  103b2e:	8b 73 10             	mov    0x10(%ebx),%esi
  np->state = RUNNABLE;
  103b31:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  103b38:	89 43 68             	mov    %eax,0x68(%ebx)
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  103b3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103b41:	83 c3 6c             	add    $0x6c,%ebx
  103b44:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103b4b:	00 
  103b4c:	89 1c 24             	mov    %ebx,(%esp)
  103b4f:	83 c0 6c             	add    $0x6c,%eax
  103b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b56:	e8 55 06 00 00       	call   1041b0 <safestrcpy>
  return pid;
}
  103b5b:	83 c4 1c             	add    $0x1c,%esp
  103b5e:	89 f0                	mov    %esi,%eax
  103b60:	5b                   	pop    %ebx
  103b61:	5e                   	pop    %esi
  103b62:	5f                   	pop    %edi
  103b63:	5d                   	pop    %ebp
  103b64:	c3                   	ret    
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if(!(np->pgdir = copyuvm(proc->pgdir, proc->sz))){
    kfree(np->kstack);
  103b65:	8b 43 08             	mov    0x8(%ebx),%eax
  103b68:	89 04 24             	mov    %eax,(%esp)
  103b6b:	e8 00 e9 ff ff       	call   102470 <kfree>
    np->kstack = 0;
  103b70:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
  103b77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
  103b7e:	eb db                	jmp    103b5b <fork+0xdb>

00103b80 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103b80:	55                   	push   %ebp
  103b81:	89 e5                	mov    %esp,%ebp
  103b83:	83 ec 18             	sub    $0x18,%esp
  uint sz = proc->sz;
  103b86:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  103b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz = proc->sz;
  103b90:	8b 02                	mov    (%edx),%eax
  if(n > 0){
  103b92:	83 f9 00             	cmp    $0x0,%ecx
  103b95:	7f 19                	jg     103bb0 <growproc+0x30>
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  } else if(n < 0){
  103b97:	75 39                	jne    103bd2 <growproc+0x52>
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
      return -1;
  }
  proc->sz = sz;
  103b99:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
  103b9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  103ba1:	89 04 24             	mov    %eax,(%esp)
  103ba4:	e8 37 2b 00 00       	call   1066e0 <switchuvm>
  103ba9:	31 c0                	xor    %eax,%eax
  return 0;
}
  103bab:	c9                   	leave  
  103bac:	c3                   	ret    
  103bad:	8d 76 00             	lea    0x0(%esi),%esi
int
growproc(int n)
{
  uint sz = proc->sz;
  if(n > 0){
    if(!(sz = allocuvm(proc->pgdir, sz, sz + n)))
  103bb0:	01 c1                	add    %eax,%ecx
  103bb2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bba:	8b 42 04             	mov    0x4(%edx),%eax
  103bbd:	89 04 24             	mov    %eax,(%esp)
  103bc0:	e8 8b 29 00 00       	call   106550 <allocuvm>
  103bc5:	85 c0                	test   %eax,%eax
  103bc7:	74 27                	je     103bf0 <growproc+0x70>
      return -1;
  } else if(n < 0){
    if(!(sz = deallocuvm(proc->pgdir, sz, sz + n)))
  103bc9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  103bd0:	eb c7                	jmp    103b99 <growproc+0x19>
  103bd2:	01 c1                	add    %eax,%ecx
  103bd4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  103bdc:	8b 42 04             	mov    0x4(%edx),%eax
  103bdf:	89 04 24             	mov    %eax,(%esp)
  103be2:	e8 89 27 00 00       	call   106370 <deallocuvm>
  103be7:	85 c0                	test   %eax,%eax
  103be9:	75 de                	jne    103bc9 <growproc+0x49>
  103beb:	90                   	nop
  103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
  103bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  103bf5:	c9                   	leave  
  103bf6:	c3                   	ret    
  103bf7:	89 f6                	mov    %esi,%esi
  103bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103c00 <userinit>:
}

// Set up first user process.
void
userinit(void)
{
  103c00:	55                   	push   %ebp
  103c01:	89 e5                	mov    %esp,%ebp
  103c03:	53                   	push   %ebx
  103c04:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  103c07:	e8 64 fd ff ff       	call   103970 <allocproc>
  103c0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
  103c0e:	a3 a8 90 10 00       	mov    %eax,0x1090a8
  if(!(p->pgdir = setupkvm()))
  103c13:	e8 78 26 00 00       	call   106290 <setupkvm>
  103c18:	85 c0                	test   %eax,%eax
  103c1a:	89 43 04             	mov    %eax,0x4(%ebx)
  103c1d:	0f 84 b6 00 00 00    	je     103cd9 <userinit+0xd9>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  103c23:	89 04 24             	mov    %eax,(%esp)
  103c26:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
  103c2d:	00 
  103c2e:	c7 44 24 04 08 89 10 	movl   $0x108908,0x4(%esp)
  103c35:	00 
  103c36:	e8 c5 25 00 00       	call   106200 <inituvm>
  p->sz = PGSIZE;
  103c3b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
  103c41:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
  103c48:	00 
  103c49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c50:	00 
  103c51:	8b 43 18             	mov    0x18(%ebx),%eax
  103c54:	89 04 24             	mov    %eax,(%esp)
  103c57:	e8 b4 03 00 00       	call   104010 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  103c5c:	8b 43 18             	mov    0x18(%ebx),%eax
  103c5f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  103c65:	8b 43 18             	mov    0x18(%ebx),%eax
  103c68:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
  103c6e:	8b 43 18             	mov    0x18(%ebx),%eax
  103c71:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  103c75:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
  103c79:	8b 43 18             	mov    0x18(%ebx),%eax
  103c7c:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
  103c80:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
  103c84:	8b 43 18             	mov    0x18(%ebx),%eax
  103c87:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
  103c8e:	8b 43 18             	mov    0x18(%ebx),%eax
  103c91:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
  103c98:	8b 43 18             	mov    0x18(%ebx),%eax
  103c9b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
  103ca2:	8d 43 6c             	lea    0x6c(%ebx),%eax
  103ca5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  103cac:	00 
  103cad:	c7 44 24 04 61 6e 10 	movl   $0x106e61,0x4(%esp)
  103cb4:	00 
  103cb5:	89 04 24             	mov    %eax,(%esp)
  103cb8:	e8 f3 04 00 00       	call   1041b0 <safestrcpy>
  p->cwd = namei("/");
  103cbd:	c7 04 24 6a 6e 10 00 	movl   $0x106e6a,(%esp)
  103cc4:	e8 47 e3 ff ff       	call   102010 <namei>

  p->state = RUNNABLE;
  103cc9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  103cd0:	89 43 68             	mov    %eax,0x68(%ebx)

  p->state = RUNNABLE;
}
  103cd3:	83 c4 14             	add    $0x14,%esp
  103cd6:	5b                   	pop    %ebx
  103cd7:	5d                   	pop    %ebp
  103cd8:	c3                   	ret    
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if(!(p->pgdir = setupkvm()))
    panic("userinit: out of memory?");
  103cd9:	c7 04 24 48 6e 10 00 	movl   $0x106e48,(%esp)
  103ce0:	e8 ab cd ff ff       	call   100a90 <panic>
  103ce5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103cf0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  103cf0:	55                   	push   %ebp
  103cf1:	89 e5                	mov    %esp,%ebp
  103cf3:	57                   	push   %edi
  103cf4:	56                   	push   %esi
  103cf5:	53                   	push   %ebx

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
  103cf6:	bb 34 c9 10 00       	mov    $0x10c934,%ebx
{
  103cfb:	83 ec 4c             	sub    $0x4c,%esp
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103cfe:	8d 7d c0             	lea    -0x40(%ebp),%edi
  103d01:	eb 4e                	jmp    103d51 <procdump+0x61>
  103d03:	90                   	nop
  103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103d08:	8b 04 85 ac 6e 10 00 	mov    0x106eac(,%eax,4),%eax
  103d0f:	85 c0                	test   %eax,%eax
  103d11:	74 4a                	je     103d5d <procdump+0x6d>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
  103d13:	8b 53 10             	mov    0x10(%ebx),%edx
  103d16:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
  103d19:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  103d1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103d21:	c7 04 24 70 6e 10 00 	movl   $0x106e70,(%esp)
  103d28:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d2c:	e8 8f c7 ff ff       	call   1004c0 <cprintf>
    if(p->state == SLEEPING){
  103d31:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
  103d35:	74 31                	je     103d68 <procdump+0x78>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  103d37:	c7 04 24 36 6d 10 00 	movl   $0x106d36,(%esp)
  103d3e:	e8 7d c7 ff ff       	call   1004c0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
  103d43:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  103d49:	81 fb 34 ec 10 00    	cmp    $0x10ec34,%ebx
  103d4f:	74 57                	je     103da8 <procdump+0xb8>
    if(p->state == UNUSED)
  103d51:	8b 43 0c             	mov    0xc(%ebx),%eax
  103d54:	85 c0                	test   %eax,%eax
  103d56:	74 eb                	je     103d43 <procdump+0x53>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
  103d58:	83 f8 05             	cmp    $0x5,%eax
  103d5b:	76 ab                	jbe    103d08 <procdump+0x18>
  103d5d:	b8 6c 6e 10 00       	mov    $0x106e6c,%eax
  103d62:	eb af                	jmp    103d13 <procdump+0x23>
  103d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
  103d68:	8b 43 1c             	mov    0x1c(%ebx),%eax
  103d6b:	31 f6                	xor    %esi,%esi
  103d6d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  103d71:	8b 40 0c             	mov    0xc(%eax),%eax
  103d74:	83 c0 08             	add    $0x8,%eax
  103d77:	89 04 24             	mov    %eax,(%esp)
  103d7a:	e8 81 00 00 00       	call   103e00 <getcallerpcs>
  103d7f:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
  103d80:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  103d83:	85 c0                	test   %eax,%eax
  103d85:	74 b0                	je     103d37 <procdump+0x47>
  103d87:	83 c6 01             	add    $0x1,%esi
        cprintf(" %p", pc[i]);
  103d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d8e:	c7 04 24 0a 69 10 00 	movl   $0x10690a,(%esp)
  103d95:	e8 26 c7 ff ff       	call   1004c0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
  103d9a:	83 fe 0a             	cmp    $0xa,%esi
  103d9d:	75 e1                	jne    103d80 <procdump+0x90>
  103d9f:	eb 96                	jmp    103d37 <procdump+0x47>
  103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
  103da8:	83 c4 4c             	add    $0x4c,%esp
  103dab:	5b                   	pop    %ebx
  103dac:	5e                   	pop    %esi
  103dad:	5f                   	pop    %edi
  103dae:	5d                   	pop    %ebp
  103daf:	90                   	nop
  103db0:	c3                   	ret    
  103db1:	eb 0d                	jmp    103dc0 <pinit>
  103db3:	90                   	nop
  103db4:	90                   	nop
  103db5:	90                   	nop
  103db6:	90                   	nop
  103db7:	90                   	nop
  103db8:	90                   	nop
  103db9:	90                   	nop
  103dba:	90                   	nop
  103dbb:	90                   	nop
  103dbc:	90                   	nop
  103dbd:	90                   	nop
  103dbe:	90                   	nop
  103dbf:	90                   	nop

00103dc0 <pinit>:
 return xticks;
}

void
pinit(void)
{
  103dc0:	55                   	push   %ebp
  103dc1:	89 e5                	mov    %esp,%ebp
  103dc3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
  103dc6:	c7 44 24 04 79 6e 10 	movl   $0x106e79,0x4(%esp)
  103dcd:	00 
  103dce:	c7 04 24 00 c9 10 00 	movl   $0x10c900,(%esp)
  103dd5:	e8 06 00 00 00       	call   103de0 <initlock>
}
  103dda:	c9                   	leave  
  103ddb:	c3                   	ret    
  103ddc:	90                   	nop
  103ddd:	90                   	nop
  103dde:	90                   	nop
  103ddf:	90                   	nop

00103de0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  103de0:	55                   	push   %ebp
  103de1:	89 e5                	mov    %esp,%ebp
  103de3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
  103de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
  103de9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
  103def:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
  103df2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
  103df9:	5d                   	pop    %ebp
  103dfa:	c3                   	ret    
  103dfb:	90                   	nop
  103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103e00 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103e00:	55                   	push   %ebp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103e01:	31 c0                	xor    %eax,%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103e03:	89 e5                	mov    %esp,%ebp
  103e05:	53                   	push   %ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103e06:	8b 55 08             	mov    0x8(%ebp),%edx
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
  103e09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  103e0c:	83 ea 08             	sub    $0x8,%edx
  103e0f:	90                   	nop
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
  103e10:	8d 8a 00 00 f0 ff    	lea    -0x100000(%edx),%ecx
  103e16:	81 f9 fe ff ef ff    	cmp    $0xffeffffe,%ecx
  103e1c:	77 1a                	ja     103e38 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
  103e1e:	8b 4a 04             	mov    0x4(%edx),%ecx
  103e21:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103e24:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103e27:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
  103e29:	83 f8 0a             	cmp    $0xa,%eax
  103e2c:	75 e2                	jne    103e10 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
  103e2e:	5b                   	pop    %ebx
  103e2f:	5d                   	pop    %ebp
  103e30:	c3                   	ret    
  103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103e38:	83 f8 09             	cmp    $0x9,%eax
  103e3b:	7f f1                	jg     103e2e <getcallerpcs+0x2e>
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  103e3d:	8d 14 83             	lea    (%ebx,%eax,4),%edx
  }
  for(; i < 10; i++)
  103e40:	83 c0 01             	add    $0x1,%eax
    pcs[i] = 0;
  103e43:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
    if(ebp == 0 || ebp < (uint *) 0x100000 || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
  103e49:	83 c2 04             	add    $0x4,%edx
  103e4c:	83 f8 0a             	cmp    $0xa,%eax
  103e4f:	75 ef                	jne    103e40 <getcallerpcs+0x40>
    pcs[i] = 0;
}
  103e51:	5b                   	pop    %ebx
  103e52:	5d                   	pop    %ebp
  103e53:	c3                   	ret    
  103e54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  103e5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00103e60 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103e60:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
  103e61:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  103e63:	89 e5                	mov    %esp,%ebp
  103e65:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
  103e68:	8b 0a                	mov    (%edx),%ecx
  103e6a:	85 c9                	test   %ecx,%ecx
  103e6c:	74 10                	je     103e7e <holding+0x1e>
  103e6e:	8b 42 08             	mov    0x8(%edx),%eax
  103e71:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103e78:	0f 94 c0             	sete   %al
  103e7b:	0f b6 c0             	movzbl %al,%eax
}
  103e7e:	5d                   	pop    %ebp
  103e7f:	c3                   	ret    

00103e80 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
  103e80:	55                   	push   %ebp
  103e81:	89 e5                	mov    %esp,%ebp
  103e83:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103e84:	9c                   	pushf  
  103e85:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103e86:	fa                   	cli    
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103e87:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103e8e:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103e94:	8d 48 01             	lea    0x1(%eax),%ecx
  103e97:	85 c0                	test   %eax,%eax
  103e99:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
  103e9f:	75 12                	jne    103eb3 <pushcli+0x33>
    cpu->intena = eflags & FL_IF;
  103ea1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103ea7:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103ead:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
  103eb3:	5b                   	pop    %ebx
  103eb4:	5d                   	pop    %ebp
  103eb5:	c3                   	ret    
  103eb6:	8d 76 00             	lea    0x0(%esi),%esi
  103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00103ec0 <popcli>:

void
popcli(void)
{
  103ec0:	55                   	push   %ebp
  103ec1:	89 e5                	mov    %esp,%ebp
  103ec3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103ec6:	9c                   	pushf  
  103ec7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
  103ec8:	f6 c4 02             	test   $0x2,%ah
  103ecb:	75 43                	jne    103f10 <popcli+0x50>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
  103ecd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103ed4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103eda:	83 e8 01             	sub    $0x1,%eax
  103edd:	85 c0                	test   %eax,%eax
  103edf:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
  103ee5:	78 1d                	js     103f04 <popcli+0x44>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
  103ee7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103eed:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
  103ef3:	85 d2                	test   %edx,%edx
  103ef5:	75 0b                	jne    103f02 <popcli+0x42>
  103ef7:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  103efd:	85 c0                	test   %eax,%eax
  103eff:	74 01                	je     103f02 <popcli+0x42>
}

static inline void
sti(void)
{
  asm volatile("sti");
  103f01:	fb                   	sti    
    sti();
}
  103f02:	c9                   	leave  
  103f03:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
  103f04:	c7 04 24 db 6e 10 00 	movl   $0x106edb,(%esp)
  103f0b:	e8 80 cb ff ff       	call   100a90 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  103f10:	c7 04 24 c4 6e 10 00 	movl   $0x106ec4,(%esp)
  103f17:	e8 74 cb ff ff       	call   100a90 <panic>
  103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00103f20 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
  103f20:	55                   	push   %ebp
  103f21:	89 e5                	mov    %esp,%ebp
  103f23:	83 ec 18             	sub    $0x18,%esp
  103f26:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103f29:	8b 0a                	mov    (%edx),%ecx
  103f2b:	85 c9                	test   %ecx,%ecx
  103f2d:	74 0c                	je     103f3b <release+0x1b>
  103f2f:	8b 42 08             	mov    0x8(%edx),%eax
  103f32:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103f39:	74 0d                	je     103f48 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
  103f3b:	c7 04 24 e2 6e 10 00 	movl   $0x106ee2,(%esp)
  103f42:	e8 49 cb ff ff       	call   100a90 <panic>
  103f47:	90                   	nop

  lk->pcs[0] = 0;
  103f48:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103f4f:	31 c0                	xor    %eax,%eax
  lk->cpu = 0;
  103f51:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
  103f58:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
}
  103f5b:	c9                   	leave  
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);

  popcli();
  103f5c:	e9 5f ff ff ff       	jmp    103ec0 <popcli>
  103f61:	eb 0d                	jmp    103f70 <acquire>
  103f63:	90                   	nop
  103f64:	90                   	nop
  103f65:	90                   	nop
  103f66:	90                   	nop
  103f67:	90                   	nop
  103f68:	90                   	nop
  103f69:	90                   	nop
  103f6a:	90                   	nop
  103f6b:	90                   	nop
  103f6c:	90                   	nop
  103f6d:	90                   	nop
  103f6e:	90                   	nop
  103f6f:	90                   	nop

00103f70 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  103f70:	55                   	push   %ebp
  103f71:	89 e5                	mov    %esp,%ebp
  103f73:	53                   	push   %ebx
  103f74:	83 ec 14             	sub    $0x14,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  103f77:	9c                   	pushf  
  103f78:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
  103f79:	fa                   	cli    
{
  int eflags;
  
  eflags = readeflags();
  cli();
  if(cpu->ncli++ == 0)
  103f7a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103f81:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
  103f87:	8d 48 01             	lea    0x1(%eax),%ecx
  103f8a:	85 c0                	test   %eax,%eax
  103f8c:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
  103f92:	75 12                	jne    103fa6 <acquire+0x36>
    cpu->intena = eflags & FL_IF;
  103f94:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  103f9a:	81 e3 00 02 00 00    	and    $0x200,%ebx
  103fa0:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
  103fa6:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
  103fa9:	8b 1a                	mov    (%edx),%ebx
  103fab:	85 db                	test   %ebx,%ebx
  103fad:	74 0c                	je     103fbb <acquire+0x4b>
  103faf:	8b 42 08             	mov    0x8(%edx),%eax
  103fb2:	65 3b 05 00 00 00 00 	cmp    %gs:0x0,%eax
  103fb9:	74 45                	je     104000 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
  103fbb:	b9 01 00 00 00       	mov    $0x1,%ecx
  103fc0:	eb 09                	jmp    103fcb <acquire+0x5b>
  103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("acquire");

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
  103fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  103fcb:	89 c8                	mov    %ecx,%eax
  103fcd:	f0 87 02             	lock xchg %eax,(%edx)
  103fd0:	85 c0                	test   %eax,%eax
  103fd2:	75 f4                	jne    103fc8 <acquire+0x58>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  103fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  103fd7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  103fde:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
  103fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  103fe4:	83 c0 0c             	add    $0xc,%eax
  103fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
  103feb:	8d 45 08             	lea    0x8(%ebp),%eax
  103fee:	89 04 24             	mov    %eax,(%esp)
  103ff1:	e8 0a fe ff ff       	call   103e00 <getcallerpcs>
}
  103ff6:	83 c4 14             	add    $0x14,%esp
  103ff9:	5b                   	pop    %ebx
  103ffa:	5d                   	pop    %ebp
  103ffb:	c3                   	ret    
  103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
acquire(struct spinlock *lk)
{
  pushcli();
  if(holding(lk))
    panic("acquire");
  104000:	c7 04 24 ea 6e 10 00 	movl   $0x106eea,(%esp)
  104007:	e8 84 ca ff ff       	call   100a90 <panic>
  10400c:	90                   	nop
  10400d:	90                   	nop
  10400e:	90                   	nop
  10400f:	90                   	nop

00104010 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
  104010:	55                   	push   %ebp
  104011:	89 e5                	mov    %esp,%ebp
  104013:	8b 55 08             	mov    0x8(%ebp),%edx
  104016:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  104017:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10401a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10401d:	89 d7                	mov    %edx,%edi
  10401f:	fc                   	cld    
  104020:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  104022:	89 d0                	mov    %edx,%eax
  104024:	5f                   	pop    %edi
  104025:	5d                   	pop    %ebp
  104026:	c3                   	ret    
  104027:	89 f6                	mov    %esi,%esi
  104029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104030 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
  104030:	55                   	push   %ebp
  104031:	89 e5                	mov    %esp,%ebp
  104033:	57                   	push   %edi
  104034:	56                   	push   %esi
  104035:	53                   	push   %ebx
  104036:	8b 55 10             	mov    0x10(%ebp),%edx
  104039:	8b 75 08             	mov    0x8(%ebp),%esi
  10403c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10403f:	85 d2                	test   %edx,%edx
  104041:	74 2d                	je     104070 <memcmp+0x40>
    if(*s1 != *s2)
  104043:	0f b6 1e             	movzbl (%esi),%ebx
  104046:	0f b6 0f             	movzbl (%edi),%ecx
  104049:	38 cb                	cmp    %cl,%bl
  10404b:	75 2b                	jne    104078 <memcmp+0x48>
      return *s1 - *s2;
  10404d:	83 ea 01             	sub    $0x1,%edx
  104050:	31 c0                	xor    %eax,%eax
  104052:	eb 18                	jmp    10406c <memcmp+0x3c>
  104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
  104058:	0f b6 5c 06 01       	movzbl 0x1(%esi,%eax,1),%ebx
  10405d:	83 ea 01             	sub    $0x1,%edx
  104060:	0f b6 4c 07 01       	movzbl 0x1(%edi,%eax,1),%ecx
  104065:	83 c0 01             	add    $0x1,%eax
  104068:	38 cb                	cmp    %cl,%bl
  10406a:	75 0c                	jne    104078 <memcmp+0x48>
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
  10406c:	85 d2                	test   %edx,%edx
  10406e:	75 e8                	jne    104058 <memcmp+0x28>
  104070:	31 c0                	xor    %eax,%eax
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
  104072:	5b                   	pop    %ebx
  104073:	5e                   	pop    %esi
  104074:	5f                   	pop    %edi
  104075:	5d                   	pop    %ebp
  104076:	c3                   	ret    
  104077:	90                   	nop
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
  104078:	0f b6 c3             	movzbl %bl,%eax
  10407b:	0f b6 c9             	movzbl %cl,%ecx
  10407e:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
  104080:	5b                   	pop    %ebx
  104081:	5e                   	pop    %esi
  104082:	5f                   	pop    %edi
  104083:	5d                   	pop    %ebp
  104084:	c3                   	ret    
  104085:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104090 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
  104090:	55                   	push   %ebp
  104091:	89 e5                	mov    %esp,%ebp
  104093:	57                   	push   %edi
  104094:	56                   	push   %esi
  104095:	53                   	push   %ebx
  104096:	8b 45 08             	mov    0x8(%ebp),%eax
  104099:	8b 75 0c             	mov    0xc(%ebp),%esi
  10409c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
  10409f:	39 c6                	cmp    %eax,%esi
  1040a1:	73 2d                	jae    1040d0 <memmove+0x40>
  1040a3:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
  1040a6:	39 f8                	cmp    %edi,%eax
  1040a8:	73 26                	jae    1040d0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
  1040aa:	85 db                	test   %ebx,%ebx
  1040ac:	74 1d                	je     1040cb <memmove+0x3b>

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
  1040ae:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  1040b1:	31 d2                	xor    %edx,%edx
  1040b3:	90                   	nop
  1040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
      *--d = *--s;
  1040b8:	0f b6 4c 17 ff       	movzbl -0x1(%edi,%edx,1),%ecx
  1040bd:	88 4c 16 ff          	mov    %cl,-0x1(%esi,%edx,1)
  1040c1:	83 ea 01             	sub    $0x1,%edx
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1040c4:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  1040c7:	85 c9                	test   %ecx,%ecx
  1040c9:	75 ed                	jne    1040b8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
  1040cb:	5b                   	pop    %ebx
  1040cc:	5e                   	pop    %esi
  1040cd:	5f                   	pop    %edi
  1040ce:	5d                   	pop    %ebp
  1040cf:	c3                   	ret    
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
  1040d0:	31 d2                	xor    %edx,%edx
      *--d = *--s;
  } else
    while(n-- > 0)
  1040d2:	85 db                	test   %ebx,%ebx
  1040d4:	74 f5                	je     1040cb <memmove+0x3b>
  1040d6:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
  1040d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  1040dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1040df:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
  1040e2:	39 d3                	cmp    %edx,%ebx
  1040e4:	75 f2                	jne    1040d8 <memmove+0x48>
      *d++ = *s++;

  return dst;
}
  1040e6:	5b                   	pop    %ebx
  1040e7:	5e                   	pop    %esi
  1040e8:	5f                   	pop    %edi
  1040e9:	5d                   	pop    %ebp
  1040ea:	c3                   	ret    
  1040eb:	90                   	nop
  1040ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001040f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  1040f0:	55                   	push   %ebp
  1040f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
  1040f3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
  1040f4:	e9 97 ff ff ff       	jmp    104090 <memmove>
  1040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104100 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
  104100:	55                   	push   %ebp
  104101:	89 e5                	mov    %esp,%ebp
  104103:	57                   	push   %edi
  104104:	56                   	push   %esi
  104105:	53                   	push   %ebx
  104106:	8b 7d 10             	mov    0x10(%ebp),%edi
  104109:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10410c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
  10410f:	85 ff                	test   %edi,%edi
  104111:	74 3d                	je     104150 <strncmp+0x50>
  104113:	0f b6 01             	movzbl (%ecx),%eax
  104116:	84 c0                	test   %al,%al
  104118:	75 18                	jne    104132 <strncmp+0x32>
  10411a:	eb 3c                	jmp    104158 <strncmp+0x58>
  10411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104120:	83 ef 01             	sub    $0x1,%edi
  104123:	74 2b                	je     104150 <strncmp+0x50>
    n--, p++, q++;
  104125:	83 c1 01             	add    $0x1,%ecx
  104128:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  10412b:	0f b6 01             	movzbl (%ecx),%eax
  10412e:	84 c0                	test   %al,%al
  104130:	74 26                	je     104158 <strncmp+0x58>
  104132:	0f b6 33             	movzbl (%ebx),%esi
  104135:	89 f2                	mov    %esi,%edx
  104137:	38 d0                	cmp    %dl,%al
  104139:	74 e5                	je     104120 <strncmp+0x20>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
  10413b:	81 e6 ff 00 00 00    	and    $0xff,%esi
  104141:	0f b6 c0             	movzbl %al,%eax
  104144:	29 f0                	sub    %esi,%eax
}
  104146:	5b                   	pop    %ebx
  104147:	5e                   	pop    %esi
  104148:	5f                   	pop    %edi
  104149:	5d                   	pop    %ebp
  10414a:	c3                   	ret    
  10414b:	90                   	nop
  10414c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104150:	31 c0                	xor    %eax,%eax
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
  104152:	5b                   	pop    %ebx
  104153:	5e                   	pop    %esi
  104154:	5f                   	pop    %edi
  104155:	5d                   	pop    %ebp
  104156:	c3                   	ret    
  104157:	90                   	nop
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  104158:	0f b6 33             	movzbl (%ebx),%esi
  10415b:	eb de                	jmp    10413b <strncmp+0x3b>
  10415d:	8d 76 00             	lea    0x0(%esi),%esi

00104160 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
  104160:	55                   	push   %ebp
  104161:	89 e5                	mov    %esp,%ebp
  104163:	8b 45 08             	mov    0x8(%ebp),%eax
  104166:	56                   	push   %esi
  104167:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10416a:	53                   	push   %ebx
  10416b:	8b 75 0c             	mov    0xc(%ebp),%esi
  10416e:	89 c3                	mov    %eax,%ebx
  104170:	eb 09                	jmp    10417b <strncpy+0x1b>
  104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104178:	83 c6 01             	add    $0x1,%esi
  10417b:	83 e9 01             	sub    $0x1,%ecx
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  10417e:	8d 51 01             	lea    0x1(%ecx),%edx
{
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
  104181:	85 d2                	test   %edx,%edx
  104183:	7e 0c                	jle    104191 <strncpy+0x31>
  104185:	0f b6 16             	movzbl (%esi),%edx
  104188:	88 13                	mov    %dl,(%ebx)
  10418a:	83 c3 01             	add    $0x1,%ebx
  10418d:	84 d2                	test   %dl,%dl
  10418f:	75 e7                	jne    104178 <strncpy+0x18>
    return 0;
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
  104191:	31 d2                	xor    %edx,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  104193:	85 c9                	test   %ecx,%ecx
  104195:	7e 0c                	jle    1041a3 <strncpy+0x43>
  104197:	90                   	nop
    *s++ = 0;
  104198:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
  10419c:	83 c2 01             	add    $0x1,%edx
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
  10419f:	39 ca                	cmp    %ecx,%edx
  1041a1:	75 f5                	jne    104198 <strncpy+0x38>
    *s++ = 0;
  return os;
}
  1041a3:	5b                   	pop    %ebx
  1041a4:	5e                   	pop    %esi
  1041a5:	5d                   	pop    %ebp
  1041a6:	c3                   	ret    
  1041a7:	89 f6                	mov    %esi,%esi
  1041a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001041b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	8b 55 10             	mov    0x10(%ebp),%edx
  1041b6:	56                   	push   %esi
  1041b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1041ba:	53                   	push   %ebx
  1041bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *os;
  
  os = s;
  if(n <= 0)
  1041be:	85 d2                	test   %edx,%edx
  1041c0:	7e 1f                	jle    1041e1 <safestrcpy+0x31>
  1041c2:	89 c1                	mov    %eax,%ecx
  1041c4:	eb 05                	jmp    1041cb <safestrcpy+0x1b>
  1041c6:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
  1041c8:	83 c6 01             	add    $0x1,%esi
  1041cb:	83 ea 01             	sub    $0x1,%edx
  1041ce:	85 d2                	test   %edx,%edx
  1041d0:	7e 0c                	jle    1041de <safestrcpy+0x2e>
  1041d2:	0f b6 1e             	movzbl (%esi),%ebx
  1041d5:	88 19                	mov    %bl,(%ecx)
  1041d7:	83 c1 01             	add    $0x1,%ecx
  1041da:	84 db                	test   %bl,%bl
  1041dc:	75 ea                	jne    1041c8 <safestrcpy+0x18>
    ;
  *s = 0;
  1041de:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
  1041e1:	5b                   	pop    %ebx
  1041e2:	5e                   	pop    %esi
  1041e3:	5d                   	pop    %ebp
  1041e4:	c3                   	ret    
  1041e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001041f0 <strlen>:

int
strlen(const char *s)
{
  1041f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
  1041f1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
  1041f3:	89 e5                	mov    %esp,%ebp
  1041f5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  1041f8:	80 3a 00             	cmpb   $0x0,(%edx)
  1041fb:	74 0c                	je     104209 <strlen+0x19>
  1041fd:	8d 76 00             	lea    0x0(%esi),%esi
  104200:	83 c0 01             	add    $0x1,%eax
  104203:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  104207:	75 f7                	jne    104200 <strlen+0x10>
    ;
  return n;
}
  104209:	5d                   	pop    %ebp
  10420a:	c3                   	ret    
  10420b:	90                   	nop

0010420c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
  10420c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
  104210:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
  104214:	55                   	push   %ebp
  pushl %ebx
  104215:	53                   	push   %ebx
  pushl %esi
  104216:	56                   	push   %esi
  pushl %edi
  104217:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
  104218:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
  10421a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
  10421c:	5f                   	pop    %edi
  popl %esi
  10421d:	5e                   	pop    %esi
  popl %ebx
  10421e:	5b                   	pop    %ebx
  popl %ebp
  10421f:	5d                   	pop    %ebp
  ret
  104220:	c3                   	ret    
  104221:	90                   	nop
  104222:	90                   	nop
  104223:	90                   	nop
  104224:	90                   	nop
  104225:	90                   	nop
  104226:	90                   	nop
  104227:	90                   	nop
  104228:	90                   	nop
  104229:	90                   	nop
  10422a:	90                   	nop
  10422b:	90                   	nop
  10422c:	90                   	nop
  10422d:	90                   	nop
  10422e:	90                   	nop
  10422f:	90                   	nop

00104230 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104230:	55                   	push   %ebp
  104231:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
  104233:	8b 55 08             	mov    0x8(%ebp),%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  104236:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(addr >= p->sz || addr+4 > p->sz)
  104239:	8b 12                	mov    (%edx),%edx
  10423b:	39 c2                	cmp    %eax,%edx
  10423d:	77 09                	ja     104248 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
  return 0;
  10423f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104244:	5d                   	pop    %ebp
  104245:	c3                   	ret    
  104246:	66 90                	xchg   %ax,%ax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104248:	8d 48 04             	lea    0x4(%eax),%ecx
  10424b:	39 ca                	cmp    %ecx,%edx
  10424d:	72 f0                	jb     10423f <fetchint+0xf>
    return -1;
  *ip = *(int*)(addr);
  10424f:	8b 10                	mov    (%eax),%edx
  104251:	8b 45 10             	mov    0x10(%ebp),%eax
  104254:	89 10                	mov    %edx,(%eax)
  104256:	31 c0                	xor    %eax,%eax
  return 0;
}
  104258:	5d                   	pop    %ebp
  104259:	c3                   	ret    
  10425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00104260 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  104260:	55                   	push   %ebp
  104261:	89 e5                	mov    %esp,%ebp
  104263:	8b 45 08             	mov    0x8(%ebp),%eax
  104266:	8b 55 0c             	mov    0xc(%ebp),%edx
  104269:	53                   	push   %ebx
  char *s, *ep;

  if(addr >= p->sz)
  10426a:	39 10                	cmp    %edx,(%eax)
  10426c:	77 0a                	ja     104278 <fetchstr+0x18>
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  10426e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    if(*s == 0)
      return s - *pp;
  return -1;
}
  104273:	5b                   	pop    %ebx
  104274:	5d                   	pop    %ebp
  104275:	c3                   	ret    
  104276:	66 90                	xchg   %ax,%ax
{
  char *s, *ep;

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  104278:	8b 4d 10             	mov    0x10(%ebp),%ecx
  10427b:	89 11                	mov    %edx,(%ecx)
  ep = (char *) p->sz;
  10427d:	8b 18                	mov    (%eax),%ebx
  for(s = *pp; s < ep; s++)
  10427f:	39 da                	cmp    %ebx,%edx
  104281:	73 eb                	jae    10426e <fetchstr+0xe>
    if(*s == 0)
  104283:	31 c0                	xor    %eax,%eax
  104285:	89 d1                	mov    %edx,%ecx
  104287:	80 3a 00             	cmpb   $0x0,(%edx)
  10428a:	74 e7                	je     104273 <fetchstr+0x13>
  10428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  104290:	83 c1 01             	add    $0x1,%ecx
  104293:	39 cb                	cmp    %ecx,%ebx
  104295:	76 d7                	jbe    10426e <fetchstr+0xe>
    if(*s == 0)
  104297:	80 39 00             	cmpb   $0x0,(%ecx)
  10429a:	75 f4                	jne    104290 <fetchstr+0x30>
  10429c:	89 c8                	mov    %ecx,%eax
  10429e:	29 d0                	sub    %edx,%eax
  1042a0:	eb d1                	jmp    104273 <fetchstr+0x13>
  1042a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

001042b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  1042b6:	55                   	push   %ebp
  1042b7:	89 e5                	mov    %esp,%ebp
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1042bc:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042bf:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042c1:	8b 52 44             	mov    0x44(%edx),%edx
  1042c4:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042c8:	39 c2                	cmp    %eax,%edx
  1042ca:	72 0c                	jb     1042d8 <argint+0x28>
    return -1;
  *ip = *(int*)(addr);
  1042cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  return x;
}
  1042d1:	5d                   	pop    %ebp
  1042d2:	c3                   	ret    
  1042d3:	90                   	nop
  1042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042d8:	8d 4a 04             	lea    0x4(%edx),%ecx
  1042db:	39 c8                	cmp    %ecx,%eax
  1042dd:	72 ed                	jb     1042cc <argint+0x1c>
    return -1;
  *ip = *(int*)(addr);
  1042df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042e2:	8b 12                	mov    (%edx),%edx
  1042e4:	89 10                	mov    %edx,(%eax)
  1042e6:	31 c0                	xor    %eax,%eax
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  return x;
}
  1042e8:	5d                   	pop    %ebp
  1042e9:	c3                   	ret    
  1042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001042f0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  1042f6:	55                   	push   %ebp
  1042f7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  1042f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1042fc:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  1042ff:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104301:	8b 52 44             	mov    0x44(%edx),%edx
  104304:	8d 54 8a 04          	lea    0x4(%edx,%ecx,4),%edx

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104308:	39 c2                	cmp    %eax,%edx
  10430a:	73 07                	jae    104313 <argptr+0x23>
  10430c:	8d 4a 04             	lea    0x4(%edx),%ecx
  10430f:	39 c8                	cmp    %ecx,%eax
  104311:	73 0d                	jae    104320 <argptr+0x30>
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
    return -1;
  *pp = (char *) i;
  return 0;
  104313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104318:	5d                   	pop    %ebp
  104319:	c3                   	ret    
  10431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(addr);
  104320:	8b 12                	mov    (%edx),%edx
{
  int i;
  
  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size >= proc->sz)
  104322:	39 c2                	cmp    %eax,%edx
  104324:	73 ed                	jae    104313 <argptr+0x23>
  104326:	8b 4d 10             	mov    0x10(%ebp),%ecx
  104329:	01 d1                	add    %edx,%ecx
  10432b:	39 c1                	cmp    %eax,%ecx
  10432d:	73 e4                	jae    104313 <argptr+0x23>
    return -1;
  *pp = (char *) i;
  10432f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104332:	89 10                	mov    %edx,(%eax)
  104334:	31 c0                	xor    %eax,%eax
  return 0;
}
  104336:	5d                   	pop    %ebp
  104337:	c3                   	ret    
  104338:	90                   	nop
  104339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104340 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  104340:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  104347:	55                   	push   %ebp
  104348:	89 e5                	mov    %esp,%ebp
  10434a:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  int x = fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
  10434b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10434e:	8b 42 18             	mov    0x18(%edx),%eax
  104351:	8b 40 44             	mov    0x44(%eax),%eax
  104354:	8d 44 88 04          	lea    0x4(%eax,%ecx,4),%eax

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
  104358:	8b 0a                	mov    (%edx),%ecx
  10435a:	39 c8                	cmp    %ecx,%eax
  10435c:	73 07                	jae    104365 <argstr+0x25>
  10435e:	8d 58 04             	lea    0x4(%eax),%ebx
  104361:	39 d9                	cmp    %ebx,%ecx
  104363:	73 0b                	jae    104370 <argstr+0x30>

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  104365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  10436a:	5b                   	pop    %ebx
  10436b:	5d                   	pop    %ebp
  10436c:	c3                   	ret    
  10436d:	8d 76 00             	lea    0x0(%esi),%esi
int
fetchint(struct proc *p, uint addr, int *ip)
{
  if(addr >= p->sz || addr+4 > p->sz)
    return -1;
  *ip = *(int*)(addr);
  104370:	8b 18                	mov    (%eax),%ebx
int
fetchstr(struct proc *p, uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= p->sz)
  104372:	39 cb                	cmp    %ecx,%ebx
  104374:	73 ef                	jae    104365 <argstr+0x25>
    return -1;
  *pp = (char *) addr;
  104376:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  104379:	89 d8                	mov    %ebx,%eax
  10437b:	89 19                	mov    %ebx,(%ecx)
  ep = (char *) p->sz;
  10437d:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
  10437f:	39 d3                	cmp    %edx,%ebx
  104381:	73 e2                	jae    104365 <argstr+0x25>
    if(*s == 0)
  104383:	80 3b 00             	cmpb   $0x0,(%ebx)
  104386:	75 12                	jne    10439a <argstr+0x5a>
  104388:	eb 1e                	jmp    1043a8 <argstr+0x68>
  10438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104390:	80 38 00             	cmpb   $0x0,(%eax)
  104393:	90                   	nop
  104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104398:	74 0e                	je     1043a8 <argstr+0x68>

  if(addr >= p->sz)
    return -1;
  *pp = (char *) addr;
  ep = (char *) p->sz;
  for(s = *pp; s < ep; s++)
  10439a:	83 c0 01             	add    $0x1,%eax
  10439d:	39 c2                	cmp    %eax,%edx
  10439f:	90                   	nop
  1043a0:	77 ee                	ja     104390 <argstr+0x50>
  1043a2:	eb c1                	jmp    104365 <argstr+0x25>
  1043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
  1043a8:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(proc, addr, pp);
}
  1043aa:	5b                   	pop    %ebx
  1043ab:	5d                   	pop    %ebp
  1043ac:	c3                   	ret    
  1043ad:	8d 76 00             	lea    0x0(%esi),%esi

001043b0 <syscall>:
[SYS_nice]	  sys_nice,
};

void
syscall(void)
{
  1043b0:	55                   	push   %ebp
  1043b1:	89 e5                	mov    %esp,%ebp
  1043b3:	53                   	push   %ebx
  1043b4:	83 ec 14             	sub    $0x14,%esp
  int num;
  
  num = proc->tf->eax;
  1043b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1043be:	8b 5a 18             	mov    0x18(%edx),%ebx
  1043c1:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
  1043c4:	83 f8 17             	cmp    $0x17,%eax
  1043c7:	77 17                	ja     1043e0 <syscall+0x30>
  1043c9:	8b 0c 85 20 6f 10 00 	mov    0x106f20(,%eax,4),%ecx
  1043d0:	85 c9                	test   %ecx,%ecx
  1043d2:	74 0c                	je     1043e0 <syscall+0x30>
    proc->tf->eax = syscalls[num]();
  1043d4:	ff d1                	call   *%ecx
  1043d6:	89 43 1c             	mov    %eax,0x1c(%ebx)
  else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
  1043d9:	83 c4 14             	add    $0x14,%esp
  1043dc:	5b                   	pop    %ebx
  1043dd:	5d                   	pop    %ebp
  1043de:	c3                   	ret    
  1043df:	90                   	nop
  
  num = proc->tf->eax;
  if(num >= 0 && num < NELEM(syscalls) && syscalls[num])
    proc->tf->eax = syscalls[num]();
  else {
    cprintf("%d %s: unknown sys call %d\n",
  1043e0:	8b 4a 10             	mov    0x10(%edx),%ecx
  1043e3:	83 c2 6c             	add    $0x6c,%edx
  1043e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1043ee:	c7 04 24 f2 6e 10 00 	movl   $0x106ef2,(%esp)
  1043f5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1043f9:	e8 c2 c0 ff ff       	call   1004c0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  1043fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104404:	8b 40 18             	mov    0x18(%eax),%eax
  104407:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
  10440e:	83 c4 14             	add    $0x14,%esp
  104411:	5b                   	pop    %ebx
  104412:	5d                   	pop    %ebp
  104413:	c3                   	ret    
  104414:	90                   	nop
  104415:	90                   	nop
  104416:	90                   	nop
  104417:	90                   	nop
  104418:	90                   	nop
  104419:	90                   	nop
  10441a:	90                   	nop
  10441b:	90                   	nop
  10441c:	90                   	nop
  10441d:	90                   	nop
  10441e:	90                   	nop
  10441f:	90                   	nop

00104420 <sys_pipe>:
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104420:	55                   	push   %ebp
  104421:	89 e5                	mov    %esp,%ebp
  104423:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  104426:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
  104429:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  10442c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
  10442f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  104436:	00 
  104437:	89 44 24 04          	mov    %eax,0x4(%esp)
  10443b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104442:	e8 a9 fe ff ff       	call   1042f0 <argptr>
  104447:	85 c0                	test   %eax,%eax
  104449:	79 15                	jns    104460 <sys_pipe+0x40>
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  10444b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
  104450:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104453:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104456:	89 ec                	mov    %ebp,%esp
  104458:	5d                   	pop    %ebp
  104459:	c3                   	ret    
  10445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
  104460:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104463:	89 44 24 04          	mov    %eax,0x4(%esp)
  104467:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10446a:	89 04 24             	mov    %eax,(%esp)
  10446d:	e8 4e ec ff ff       	call   1030c0 <pipealloc>
  104472:	85 c0                	test   %eax,%eax
  104474:	78 d5                	js     10444b <sys_pipe+0x2b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  104476:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  104479:	31 c0                	xor    %eax,%eax
  10447b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104488:	8b 5c 82 28          	mov    0x28(%edx,%eax,4),%ebx
  10448c:	85 db                	test   %ebx,%ebx
  10448e:	74 28                	je     1044b8 <sys_pipe+0x98>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104490:	83 c0 01             	add    $0x1,%eax
  104493:	83 f8 10             	cmp    $0x10,%eax
  104496:	75 f0                	jne    104488 <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
  104498:	89 0c 24             	mov    %ecx,(%esp)
  10449b:	e8 a0 cc ff ff       	call   101140 <fileclose>
    fileclose(wf);
  1044a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044a3:	89 04 24             	mov    %eax,(%esp)
  1044a6:	e8 95 cc ff ff       	call   101140 <fileclose>
  1044ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  1044b0:	eb 9e                	jmp    104450 <sys_pipe+0x30>
  1044b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  1044b8:	8d 58 08             	lea    0x8(%eax),%ebx
  1044bb:	89 4c 9a 08          	mov    %ecx,0x8(%edx,%ebx,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
  1044bf:	8b 75 ec             	mov    -0x14(%ebp),%esi
  1044c2:	31 d2                	xor    %edx,%edx
  1044c4:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
  1044cb:	90                   	nop
  1044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  1044d0:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
  1044d5:	74 19                	je     1044f0 <sys_pipe+0xd0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  1044d7:	83 c2 01             	add    $0x1,%edx
  1044da:	83 fa 10             	cmp    $0x10,%edx
  1044dd:	75 f1                	jne    1044d0 <sys_pipe+0xb0>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
  1044df:	c7 44 99 08 00 00 00 	movl   $0x0,0x8(%ecx,%ebx,4)
  1044e6:	00 
  1044e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1044ea:	eb ac                	jmp    104498 <sys_pipe+0x78>
  1044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  1044f0:	89 74 91 28          	mov    %esi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  1044f4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  1044f7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
  1044f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044fc:	89 50 04             	mov    %edx,0x4(%eax)
  1044ff:	31 c0                	xor    %eax,%eax
  return 0;
  104501:	e9 4a ff ff ff       	jmp    104450 <sys_pipe+0x30>
  104506:	8d 76 00             	lea    0x0(%esi),%esi
  104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104510 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
  104510:	55                   	push   %ebp
  104511:	89 e5                	mov    %esp,%ebp
  104513:	81 ec 88 00 00 00    	sub    $0x88,%esp
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  104519:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
  10451c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10451f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104522:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  104525:	89 44 24 04          	mov    %eax,0x4(%esp)
  104529:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104530:	e8 0b fe ff ff       	call   104340 <argstr>
  104535:	85 c0                	test   %eax,%eax
  104537:	79 17                	jns    104550 <sys_exec+0x40>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
    if(i >= NELEM(argv))
  104539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
  10453e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104541:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104544:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104547:	89 ec                	mov    %ebp,%esp
  104549:	5d                   	pop    %ebp
  10454a:	c3                   	ret    
  10454b:	90                   	nop
  10454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *path, *argv[20];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
  104550:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104553:	89 44 24 04          	mov    %eax,0x4(%esp)
  104557:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10455e:	e8 4d fd ff ff       	call   1042b0 <argint>
  104563:	85 c0                	test   %eax,%eax
  104565:	78 d2                	js     104539 <sys_exec+0x29>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  104567:	8d 7d 8c             	lea    -0x74(%ebp),%edi
  10456a:	31 f6                	xor    %esi,%esi
  10456c:	c7 44 24 08 50 00 00 	movl   $0x50,0x8(%esp)
  104573:	00 
  104574:	31 db                	xor    %ebx,%ebx
  104576:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10457d:	00 
  10457e:	89 3c 24             	mov    %edi,(%esp)
  104581:	e8 8a fa ff ff       	call   104010 <memset>
  104586:	eb 27                	jmp    1045af <sys_exec+0x9f>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
  104588:	89 44 24 04          	mov    %eax,0x4(%esp)
  10458c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104592:	8d 14 b7             	lea    (%edi,%esi,4),%edx
  104595:	89 54 24 08          	mov    %edx,0x8(%esp)
  104599:	89 04 24             	mov    %eax,(%esp)
  10459c:	e8 bf fc ff ff       	call   104260 <fetchstr>
  1045a1:	85 c0                	test   %eax,%eax
  1045a3:	78 94                	js     104539 <sys_exec+0x29>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1045a5:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
  1045a8:	83 fb 14             	cmp    $0x14,%ebx

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
  1045ab:	89 de                	mov    %ebx,%esi
    if(i >= NELEM(argv))
  1045ad:	74 8a                	je     104539 <sys_exec+0x29>
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
  1045af:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1045b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1045b6:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  1045bd:	03 45 e0             	add    -0x20(%ebp),%eax
  1045c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1045ca:	89 04 24             	mov    %eax,(%esp)
  1045cd:	e8 5e fc ff ff       	call   104230 <fetchint>
  1045d2:	85 c0                	test   %eax,%eax
  1045d4:	0f 88 5f ff ff ff    	js     104539 <sys_exec+0x29>
      return -1;
    if(uarg == 0){
  1045da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045dd:	85 c0                	test   %eax,%eax
  1045df:	75 a7                	jne    104588 <sys_exec+0x78>
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1045e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
  1045e4:	c7 44 9d 8c 00 00 00 	movl   $0x0,-0x74(%ebp,%ebx,4)
  1045eb:	00 
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
  1045ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1045f0:	89 04 24             	mov    %eax,(%esp)
  1045f3:	e8 18 c5 ff ff       	call   100b10 <exec>
  1045f8:	e9 41 ff ff ff       	jmp    10453e <sys_exec+0x2e>
  1045fd:	8d 76 00             	lea    0x0(%esi),%esi

00104600 <sys_chdir>:
  return 0;
}

int
sys_chdir(void)
{
  104600:	55                   	push   %ebp
  104601:	89 e5                	mov    %esp,%ebp
  104603:	53                   	push   %ebx
  104604:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104607:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10460a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10460e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104615:	e8 26 fd ff ff       	call   104340 <argstr>
  10461a:	85 c0                	test   %eax,%eax
  10461c:	79 12                	jns    104630 <sys_chdir+0x30>
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  proc->cwd = ip;
  return 0;
  10461e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104623:	83 c4 24             	add    $0x24,%esp
  104626:	5b                   	pop    %ebx
  104627:	5d                   	pop    %ebp
  104628:	c3                   	ret    
  104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_chdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
  104630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104633:	89 04 24             	mov    %eax,(%esp)
  104636:	e8 d5 d9 ff ff       	call   102010 <namei>
  10463b:	85 c0                	test   %eax,%eax
  10463d:	89 c3                	mov    %eax,%ebx
  10463f:	74 dd                	je     10461e <sys_chdir+0x1e>
    return -1;
  ilock(ip);
  104641:	89 04 24             	mov    %eax,(%esp)
  104644:	e8 27 d7 ff ff       	call   101d70 <ilock>
  if(ip->type != T_DIR){
  104649:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10464e:	75 26                	jne    104676 <sys_chdir+0x76>
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104650:	89 1c 24             	mov    %ebx,(%esp)
  104653:	e8 d8 d2 ff ff       	call   101930 <iunlock>
  iput(proc->cwd);
  104658:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10465e:	8b 40 68             	mov    0x68(%eax),%eax
  104661:	89 04 24             	mov    %eax,(%esp)
  104664:	e8 d7 d3 ff ff       	call   101a40 <iput>
  proc->cwd = ip;
  104669:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  10466f:	89 58 68             	mov    %ebx,0x68(%eax)
  104672:	31 c0                	xor    %eax,%eax
  return 0;
  104674:	eb ad                	jmp    104623 <sys_chdir+0x23>

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
    return -1;
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
  104676:	89 1c 24             	mov    %ebx,(%esp)
  104679:	e8 02 d6 ff ff       	call   101c80 <iunlockput>
  10467e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104683:	eb 9e                	jmp    104623 <sys_chdir+0x23>
  104685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104690 <create>:
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  104690:	55                   	push   %ebp
  104691:	89 e5                	mov    %esp,%ebp
  104693:	83 ec 58             	sub    $0x58,%esp
  104696:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  104699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  10469c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  10469f:	8d 75 d6             	lea    -0x2a(%ebp),%esi
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046a2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046a5:	31 db                	xor    %ebx,%ebx
  return 0;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
  1046a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1046aa:	89 d7                	mov    %edx,%edi
  1046ac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
  1046af:	89 74 24 04          	mov    %esi,0x4(%esp)
  1046b3:	89 04 24             	mov    %eax,(%esp)
  1046b6:	e8 35 d9 ff ff       	call   101ff0 <nameiparent>
  1046bb:	85 c0                	test   %eax,%eax
  1046bd:	74 47                	je     104706 <create+0x76>
    return 0;
  ilock(dp);
  1046bf:	89 04 24             	mov    %eax,(%esp)
  1046c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
  1046c5:	e8 a6 d6 ff ff       	call   101d70 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
  1046ca:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1046cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1046d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  1046d8:	89 14 24             	mov    %edx,(%esp)
  1046db:	e8 50 d1 ff ff       	call   101830 <dirlookup>
  1046e0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1046e3:	85 c0                	test   %eax,%eax
  1046e5:	89 c3                	mov    %eax,%ebx
  1046e7:	74 3f                	je     104728 <create+0x98>
    iunlockput(dp);
  1046e9:	89 14 24             	mov    %edx,(%esp)
  1046ec:	e8 8f d5 ff ff       	call   101c80 <iunlockput>
    ilock(ip);
  1046f1:	89 1c 24             	mov    %ebx,(%esp)
  1046f4:	e8 77 d6 ff ff       	call   101d70 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
  1046f9:	66 83 ff 02          	cmp    $0x2,%di
  1046fd:	75 19                	jne    104718 <create+0x88>
  1046ff:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
  104704:	75 12                	jne    104718 <create+0x88>
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);
  return ip;
}
  104706:	89 d8                	mov    %ebx,%eax
  104708:	8b 75 f8             	mov    -0x8(%ebp),%esi
  10470b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10470e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104711:	89 ec                	mov    %ebp,%esp
  104713:	5d                   	pop    %ebp
  104714:	c3                   	ret    
  104715:	8d 76 00             	lea    0x0(%esi),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
  104718:	89 1c 24             	mov    %ebx,(%esp)
  10471b:	31 db                	xor    %ebx,%ebx
  10471d:	e8 5e d5 ff ff       	call   101c80 <iunlockput>
    return 0;
  104722:	eb e2                	jmp    104706 <create+0x76>
  104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((ip = ialloc(dp->dev, type)) == 0)
  104728:	0f bf c7             	movswl %di,%eax
  10472b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10472f:	8b 02                	mov    (%edx),%eax
  104731:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104734:	89 04 24             	mov    %eax,(%esp)
  104737:	e8 64 d5 ff ff       	call   101ca0 <ialloc>
  10473c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10473f:	85 c0                	test   %eax,%eax
  104741:	89 c3                	mov    %eax,%ebx
  104743:	0f 84 b7 00 00 00    	je     104800 <create+0x170>
    panic("create: ialloc");

  ilock(ip);
  104749:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10474c:	89 04 24             	mov    %eax,(%esp)
  10474f:	e8 1c d6 ff ff       	call   101d70 <ilock>
  ip->major = major;
  104754:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
  104758:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
  10475c:	0f b7 4d c0          	movzwl -0x40(%ebp),%ecx
  ip->nlink = 1;
  104760:	66 c7 43 16 01 00    	movw   $0x1,0x16(%ebx)
  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");

  ilock(ip);
  ip->major = major;
  ip->minor = minor;
  104766:	66 89 4b 14          	mov    %cx,0x14(%ebx)
  ip->nlink = 1;
  iupdate(ip);
  10476a:	89 1c 24             	mov    %ebx,(%esp)
  10476d:	e8 be ce ff ff       	call   101630 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
  104772:	66 83 ff 01          	cmp    $0x1,%di
  104776:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104779:	74 2d                	je     1047a8 <create+0x118>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
  10477b:	8b 43 04             	mov    0x4(%ebx),%eax
  10477e:	89 14 24             	mov    %edx,(%esp)
  104781:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104784:	89 74 24 04          	mov    %esi,0x4(%esp)
  104788:	89 44 24 08          	mov    %eax,0x8(%esp)
  10478c:	e8 ff d3 ff ff       	call   101b90 <dirlink>
  104791:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104794:	85 c0                	test   %eax,%eax
  104796:	78 74                	js     10480c <create+0x17c>
    panic("create: dirlink");

  iunlockput(dp);
  104798:	89 14 24             	mov    %edx,(%esp)
  10479b:	e8 e0 d4 ff ff       	call   101c80 <iunlockput>
  return ip;
  1047a0:	e9 61 ff ff ff       	jmp    104706 <create+0x76>
  1047a5:	8d 76 00             	lea    0x0(%esi),%esi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
  1047a8:	66 83 42 16 01       	addw   $0x1,0x16(%edx)
    iupdate(dp);
  1047ad:	89 14 24             	mov    %edx,(%esp)
  1047b0:	89 55 bc             	mov    %edx,-0x44(%ebp)
  1047b3:	e8 78 ce ff ff       	call   101630 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
  1047b8:	8b 43 04             	mov    0x4(%ebx),%eax
  1047bb:	c7 44 24 04 90 6f 10 	movl   $0x106f90,0x4(%esp)
  1047c2:	00 
  1047c3:	89 1c 24             	mov    %ebx,(%esp)
  1047c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047ca:	e8 c1 d3 ff ff       	call   101b90 <dirlink>
  1047cf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1047d2:	85 c0                	test   %eax,%eax
  1047d4:	78 1e                	js     1047f4 <create+0x164>
  1047d6:	8b 42 04             	mov    0x4(%edx),%eax
  1047d9:	c7 44 24 04 8f 6f 10 	movl   $0x106f8f,0x4(%esp)
  1047e0:	00 
  1047e1:	89 1c 24             	mov    %ebx,(%esp)
  1047e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047e8:	e8 a3 d3 ff ff       	call   101b90 <dirlink>
  1047ed:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1047f0:	85 c0                	test   %eax,%eax
  1047f2:	79 87                	jns    10477b <create+0xeb>
      panic("create dots");
  1047f4:	c7 04 24 92 6f 10 00 	movl   $0x106f92,(%esp)
  1047fb:	e8 90 c2 ff ff       	call   100a90 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
  104800:	c7 04 24 80 6f 10 00 	movl   $0x106f80,(%esp)
  104807:	e8 84 c2 ff ff       	call   100a90 <panic>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
  10480c:	c7 04 24 9e 6f 10 00 	movl   $0x106f9e,(%esp)
  104813:	e8 78 c2 ff ff       	call   100a90 <panic>
  104818:	90                   	nop
  104819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104820 <sys_mknod>:
  return 0;
}

int
sys_mknod(void)
{
  104820:	55                   	push   %ebp
  104821:	89 e5                	mov    %esp,%ebp
  104823:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104826:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104829:	89 44 24 04          	mov    %eax,0x4(%esp)
  10482d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104834:	e8 07 fb ff ff       	call   104340 <argstr>
  104839:	85 c0                	test   %eax,%eax
  10483b:	79 0b                	jns    104848 <sys_mknod+0x28>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  return 0;
  10483d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104842:	c9                   	leave  
  104843:	c3                   	ret    
  104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
  104848:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10484b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10484f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104856:	e8 55 fa ff ff       	call   1042b0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  10485b:	85 c0                	test   %eax,%eax
  10485d:	78 de                	js     10483d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
  10485f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104862:	89 44 24 04          	mov    %eax,0x4(%esp)
  104866:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10486d:	e8 3e fa ff ff       	call   1042b0 <argint>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  104872:	85 c0                	test   %eax,%eax
  104874:	78 c7                	js     10483d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
  104876:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
  10487a:	ba 03 00 00 00       	mov    $0x3,%edx
  10487f:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
  104883:	89 04 24             	mov    %eax,(%esp)
  104886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104889:	e8 02 fe ff ff       	call   104690 <create>
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  if((len=argstr(0, &path)) < 0 ||
  10488e:	85 c0                	test   %eax,%eax
  104890:	74 ab                	je     10483d <sys_mknod+0x1d>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0)
    return -1;
  iunlockput(ip);
  104892:	89 04 24             	mov    %eax,(%esp)
  104895:	e8 e6 d3 ff ff       	call   101c80 <iunlockput>
  10489a:	31 c0                	xor    %eax,%eax
  return 0;
}
  10489c:	c9                   	leave  
  10489d:	c3                   	ret    
  10489e:	66 90                	xchg   %ax,%ax

001048a0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
  1048a0:	55                   	push   %ebp
  1048a1:	89 e5                	mov    %esp,%ebp
  1048a3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  1048a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1048a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048b4:	e8 87 fa ff ff       	call   104340 <argstr>
  1048b9:	85 c0                	test   %eax,%eax
  1048bb:	79 0b                	jns    1048c8 <sys_mkdir+0x28>
    return -1;
  iunlockput(ip);
  return 0;
  1048bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1048c2:	c9                   	leave  
  1048c3:	c3                   	ret    
  1048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_mkdir(void)
{
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
  1048c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048d2:	31 c9                	xor    %ecx,%ecx
  1048d4:	ba 01 00 00 00       	mov    $0x1,%edx
  1048d9:	e8 b2 fd ff ff       	call   104690 <create>
  1048de:	85 c0                	test   %eax,%eax
  1048e0:	74 db                	je     1048bd <sys_mkdir+0x1d>
    return -1;
  iunlockput(ip);
  1048e2:	89 04 24             	mov    %eax,(%esp)
  1048e5:	e8 96 d3 ff ff       	call   101c80 <iunlockput>
  1048ea:	31 c0                	xor    %eax,%eax
  return 0;
}
  1048ec:	c9                   	leave  
  1048ed:	c3                   	ret    
  1048ee:	66 90                	xchg   %ax,%ax

001048f0 <sys_link>:
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  1048f0:	55                   	push   %ebp
  1048f1:	89 e5                	mov    %esp,%ebp
  1048f3:	83 ec 48             	sub    $0x48,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  1048f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
  1048f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  1048fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  1048ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104902:	89 44 24 04          	mov    %eax,0x4(%esp)
  104906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10490d:	e8 2e fa ff ff       	call   104340 <argstr>
  104912:	85 c0                	test   %eax,%eax
  104914:	79 12                	jns    104928 <sys_link+0x38>
bad:
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return -1;
  104916:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10491b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10491e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104921:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104924:	89 ec                	mov    %ebp,%esp
  104926:	5d                   	pop    %ebp
  104927:	c3                   	ret    
sys_link(void)
{
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
  104928:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10492b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10492f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104936:	e8 05 fa ff ff       	call   104340 <argstr>
  10493b:	85 c0                	test   %eax,%eax
  10493d:	78 d7                	js     104916 <sys_link+0x26>
    return -1;
  if((ip = namei(old)) == 0)
  10493f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104942:	89 04 24             	mov    %eax,(%esp)
  104945:	e8 c6 d6 ff ff       	call   102010 <namei>
  10494a:	85 c0                	test   %eax,%eax
  10494c:	89 c3                	mov    %eax,%ebx
  10494e:	74 c6                	je     104916 <sys_link+0x26>
    return -1;
  ilock(ip);
  104950:	89 04 24             	mov    %eax,(%esp)
  104953:	e8 18 d4 ff ff       	call   101d70 <ilock>
  if(ip->type == T_DIR){
  104958:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  10495d:	0f 84 86 00 00 00    	je     1049e9 <sys_link+0xf9>
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  104963:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
  104968:	8d 7d d2             	lea    -0x2e(%ebp),%edi
  if(ip->type == T_DIR){
    iunlockput(ip);
    return -1;
  }
  ip->nlink++;
  iupdate(ip);
  10496b:	89 1c 24             	mov    %ebx,(%esp)
  10496e:	e8 bd cc ff ff       	call   101630 <iupdate>
  iunlock(ip);
  104973:	89 1c 24             	mov    %ebx,(%esp)
  104976:	e8 b5 cf ff ff       	call   101930 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
  10497b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10497e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104982:	89 04 24             	mov    %eax,(%esp)
  104985:	e8 66 d6 ff ff       	call   101ff0 <nameiparent>
  10498a:	85 c0                	test   %eax,%eax
  10498c:	89 c6                	mov    %eax,%esi
  10498e:	74 44                	je     1049d4 <sys_link+0xe4>
    goto bad;
  ilock(dp);
  104990:	89 04 24             	mov    %eax,(%esp)
  104993:	e8 d8 d3 ff ff       	call   101d70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
  104998:	8b 06                	mov    (%esi),%eax
  10499a:	3b 03                	cmp    (%ebx),%eax
  10499c:	75 2e                	jne    1049cc <sys_link+0xdc>
  10499e:	8b 43 04             	mov    0x4(%ebx),%eax
  1049a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  1049a5:	89 34 24             	mov    %esi,(%esp)
  1049a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1049ac:	e8 df d1 ff ff       	call   101b90 <dirlink>
  1049b1:	85 c0                	test   %eax,%eax
  1049b3:	78 17                	js     1049cc <sys_link+0xdc>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
  1049b5:	89 34 24             	mov    %esi,(%esp)
  1049b8:	e8 c3 d2 ff ff       	call   101c80 <iunlockput>
  iput(ip);
  1049bd:	89 1c 24             	mov    %ebx,(%esp)
  1049c0:	e8 7b d0 ff ff       	call   101a40 <iput>
  1049c5:	31 c0                	xor    %eax,%eax
  return 0;
  1049c7:	e9 4f ff ff ff       	jmp    10491b <sys_link+0x2b>

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
  1049cc:	89 34 24             	mov    %esi,(%esp)
  1049cf:	e8 ac d2 ff ff       	call   101c80 <iunlockput>
  iunlockput(dp);
  iput(ip);
  return 0;

bad:
  ilock(ip);
  1049d4:	89 1c 24             	mov    %ebx,(%esp)
  1049d7:	e8 94 d3 ff ff       	call   101d70 <ilock>
  ip->nlink--;
  1049dc:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
  1049e1:	89 1c 24             	mov    %ebx,(%esp)
  1049e4:	e8 47 cc ff ff       	call   101630 <iupdate>
  iunlockput(ip);
  1049e9:	89 1c 24             	mov    %ebx,(%esp)
  1049ec:	e8 8f d2 ff ff       	call   101c80 <iunlockput>
  1049f1:	83 c8 ff             	or     $0xffffffff,%eax
  return -1;
  1049f4:	e9 22 ff ff ff       	jmp    10491b <sys_link+0x2b>
  1049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104a00 <sys_open>:
  return ip;
}

int
sys_open(void)
{
  104a00:	55                   	push   %ebp
  104a01:	89 e5                	mov    %esp,%ebp
  104a03:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
  104a09:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104a0c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a1a:	e8 21 f9 ff ff       	call   104340 <argstr>
  104a1f:	85 c0                	test   %eax,%eax
  104a21:	79 15                	jns    104a38 <sys_open+0x38>

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  104a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
  104a28:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104a2b:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104a2e:	89 ec                	mov    %ebp,%esp
  104a30:	5d                   	pop    %ebp
  104a31:	c3                   	ret    
  104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
  104a38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a46:	e8 65 f8 ff ff       	call   1042b0 <argint>
  104a4b:	85 c0                	test   %eax,%eax
  104a4d:	78 d4                	js     104a23 <sys_open+0x23>
    return -1;
  if(omode & O_CREATE){
  104a4f:	f6 45 f1 02          	testb  $0x2,-0xf(%ebp)
  104a53:	74 63                	je     104ab8 <sys_open+0xb8>
    if((ip = create(path, T_FILE, 0, 0)) == 0)
  104a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a58:	31 c9                	xor    %ecx,%ecx
  104a5a:	ba 02 00 00 00       	mov    $0x2,%edx
  104a5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104a66:	e8 25 fc ff ff       	call   104690 <create>
  104a6b:	85 c0                	test   %eax,%eax
  104a6d:	89 c3                	mov    %eax,%ebx
  104a6f:	74 b2                	je     104a23 <sys_open+0x23>
      iunlockput(ip);
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
  104a71:	e8 4a c6 ff ff       	call   1010c0 <filealloc>
  104a76:	85 c0                	test   %eax,%eax
  104a78:	89 c6                	mov    %eax,%esi
  104a7a:	74 24                	je     104aa0 <sys_open+0xa0>
  104a7c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104a83:	31 c0                	xor    %eax,%eax
  104a85:	8d 76 00             	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
  104a88:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
  104a8c:	85 c9                	test   %ecx,%ecx
  104a8e:	74 58                	je     104ae8 <sys_open+0xe8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104a90:	83 c0 01             	add    $0x1,%eax
  104a93:	83 f8 10             	cmp    $0x10,%eax
  104a96:	75 f0                	jne    104a88 <sys_open+0x88>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
  104a98:	89 34 24             	mov    %esi,(%esp)
  104a9b:	e8 a0 c6 ff ff       	call   101140 <fileclose>
    iunlockput(ip);
  104aa0:	89 1c 24             	mov    %ebx,(%esp)
  104aa3:	e8 d8 d1 ff ff       	call   101c80 <iunlockput>
  104aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104aad:	e9 76 ff ff ff       	jmp    104a28 <sys_open+0x28>
  104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(omode & O_CREATE){
    if((ip = create(path, T_FILE, 0, 0)) == 0)
      return -1;
  } else {
    if((ip = namei(path)) == 0)
  104ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104abb:	89 04 24             	mov    %eax,(%esp)
  104abe:	e8 4d d5 ff ff       	call   102010 <namei>
  104ac3:	85 c0                	test   %eax,%eax
  104ac5:	89 c3                	mov    %eax,%ebx
  104ac7:	0f 84 56 ff ff ff    	je     104a23 <sys_open+0x23>
      return -1;
    ilock(ip);
  104acd:	89 04 24             	mov    %eax,(%esp)
  104ad0:	e8 9b d2 ff ff       	call   101d70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
  104ad5:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
  104ada:	75 95                	jne    104a71 <sys_open+0x71>
  104adc:	8b 75 f0             	mov    -0x10(%ebp),%esi
  104adf:	85 f6                	test   %esi,%esi
  104ae1:	74 8e                	je     104a71 <sys_open+0x71>
  104ae3:	eb bb                	jmp    104aa0 <sys_open+0xa0>
  104ae5:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
  104ae8:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
    if(f)
      fileclose(f);
    iunlockput(ip);
    return -1;
  }
  iunlock(ip);
  104aec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104aef:	89 1c 24             	mov    %ebx,(%esp)
  104af2:	e8 39 ce ff ff       	call   101930 <iunlock>

  f->type = FD_INODE;
  104af7:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  104afd:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
  104b00:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
  104b07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104b0a:	83 f2 01             	xor    $0x1,%edx
  104b0d:	83 e2 01             	and    $0x1,%edx
  104b10:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  104b13:	f6 45 f0 03          	testb  $0x3,-0x10(%ebp)
  104b17:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
  104b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b1e:	e9 05 ff ff ff       	jmp    104a28 <sys_open+0x28>
  104b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104b30 <sys_unlink>:
  return 1;
}

int
sys_unlink(void)
{
  104b30:	55                   	push   %ebp
  104b31:	89 e5                	mov    %esp,%ebp
  104b33:	83 ec 78             	sub    $0x78,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104b36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  return 1;
}

int
sys_unlink(void)
{
  104b39:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  104b3c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  104b3f:	89 7d fc             	mov    %edi,-0x4(%ebp)
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
  104b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  104b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104b4d:	e8 ee f7 ff ff       	call   104340 <argstr>
  104b52:	85 c0                	test   %eax,%eax
  104b54:	79 12                	jns    104b68 <sys_unlink+0x38>
  iunlockput(dp);

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  return 0;
  104b56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104b5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  104b5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  104b61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  104b64:	89 ec                	mov    %ebp,%esp
  104b66:	5d                   	pop    %ebp
  104b67:	c3                   	ret    
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
  if((dp = nameiparent(path, name)) == 0)
  104b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b6b:	8d 5d d2             	lea    -0x2e(%ebp),%ebx
  104b6e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104b72:	89 04 24             	mov    %eax,(%esp)
  104b75:	e8 76 d4 ff ff       	call   101ff0 <nameiparent>
  104b7a:	85 c0                	test   %eax,%eax
  104b7c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104b7f:	74 d5                	je     104b56 <sys_unlink+0x26>
    return -1;
  ilock(dp);
  104b81:	89 04 24             	mov    %eax,(%esp)
  104b84:	e8 e7 d1 ff ff       	call   101d70 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0){
  104b89:	c7 44 24 04 90 6f 10 	movl   $0x106f90,0x4(%esp)
  104b90:	00 
  104b91:	89 1c 24             	mov    %ebx,(%esp)
  104b94:	e8 67 cc ff ff       	call   101800 <namecmp>
  104b99:	85 c0                	test   %eax,%eax
  104b9b:	0f 84 a4 00 00 00    	je     104c45 <sys_unlink+0x115>
  104ba1:	c7 44 24 04 8f 6f 10 	movl   $0x106f8f,0x4(%esp)
  104ba8:	00 
  104ba9:	89 1c 24             	mov    %ebx,(%esp)
  104bac:	e8 4f cc ff ff       	call   101800 <namecmp>
  104bb1:	85 c0                	test   %eax,%eax
  104bb3:	0f 84 8c 00 00 00    	je     104c45 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }

  if((ip = dirlookup(dp, name, &off)) == 0){
  104bb9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  104bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  104bc0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104bc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104bc7:	89 04 24             	mov    %eax,(%esp)
  104bca:	e8 61 cc ff ff       	call   101830 <dirlookup>
  104bcf:	85 c0                	test   %eax,%eax
  104bd1:	89 c6                	mov    %eax,%esi
  104bd3:	74 70                	je     104c45 <sys_unlink+0x115>
    iunlockput(dp);
    return -1;
  }
  ilock(ip);
  104bd5:	89 04 24             	mov    %eax,(%esp)
  104bd8:	e8 93 d1 ff ff       	call   101d70 <ilock>

  if(ip->nlink < 1)
  104bdd:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
  104be2:	0f 8e 0e 01 00 00    	jle    104cf6 <sys_unlink+0x1c6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
  104be8:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104bed:	75 71                	jne    104c60 <sys_unlink+0x130>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
  104bef:	83 7e 18 20          	cmpl   $0x20,0x18(%esi)
  104bf3:	76 6b                	jbe    104c60 <sys_unlink+0x130>
  104bf5:	8d 7d b2             	lea    -0x4e(%ebp),%edi
  104bf8:	bb 20 00 00 00       	mov    $0x20,%ebx
  104bfd:	8d 76 00             	lea    0x0(%esi),%esi
  104c00:	eb 0e                	jmp    104c10 <sys_unlink+0xe0>
  104c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104c08:	83 c3 10             	add    $0x10,%ebx
  104c0b:	3b 5e 18             	cmp    0x18(%esi),%ebx
  104c0e:	73 50                	jae    104c60 <sys_unlink+0x130>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c10:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c17:	00 
  104c18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104c1c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  104c20:	89 34 24             	mov    %esi,(%esp)
  104c23:	e8 08 c9 ff ff       	call   101530 <readi>
  104c28:	83 f8 10             	cmp    $0x10,%eax
  104c2b:	0f 85 ad 00 00 00    	jne    104cde <sys_unlink+0x1ae>
      panic("isdirempty: readi");
    if(de.inum != 0)
  104c31:	66 83 7d b2 00       	cmpw   $0x0,-0x4e(%ebp)
  104c36:	74 d0                	je     104c08 <sys_unlink+0xd8>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
  104c38:	89 34 24             	mov    %esi,(%esp)
  104c3b:	90                   	nop
  104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  104c40:	e8 3b d0 ff ff       	call   101c80 <iunlockput>
    iunlockput(dp);
  104c45:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104c48:	89 04 24             	mov    %eax,(%esp)
  104c4b:	e8 30 d0 ff ff       	call   101c80 <iunlockput>
  104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return -1;
  104c55:	e9 01 ff ff ff       	jmp    104b5b <sys_unlink+0x2b>
  104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  memset(&de, 0, sizeof(de));
  104c60:	8d 5d c2             	lea    -0x3e(%ebp),%ebx
  104c63:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  104c6a:	00 
  104c6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c72:	00 
  104c73:	89 1c 24             	mov    %ebx,(%esp)
  104c76:	e8 95 f3 ff ff       	call   104010 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
  104c7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c7e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  104c85:	00 
  104c86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104c8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  104c8e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104c91:	89 04 24             	mov    %eax,(%esp)
  104c94:	e8 27 ca ff ff       	call   1016c0 <writei>
  104c99:	83 f8 10             	cmp    $0x10,%eax
  104c9c:	75 4c                	jne    104cea <sys_unlink+0x1ba>
    panic("unlink: writei");
  if(ip->type == T_DIR){
  104c9e:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
  104ca3:	74 27                	je     104ccc <sys_unlink+0x19c>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
  104ca5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104ca8:	89 04 24             	mov    %eax,(%esp)
  104cab:	e8 d0 cf ff ff       	call   101c80 <iunlockput>

  ip->nlink--;
  104cb0:	66 83 6e 16 01       	subw   $0x1,0x16(%esi)
  iupdate(ip);
  104cb5:	89 34 24             	mov    %esi,(%esp)
  104cb8:	e8 73 c9 ff ff       	call   101630 <iupdate>
  iunlockput(ip);
  104cbd:	89 34 24             	mov    %esi,(%esp)
  104cc0:	e8 bb cf ff ff       	call   101c80 <iunlockput>
  104cc5:	31 c0                	xor    %eax,%eax
  return 0;
  104cc7:	e9 8f fe ff ff       	jmp    104b5b <sys_unlink+0x2b>

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
  104ccc:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104ccf:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
  104cd4:	89 04 24             	mov    %eax,(%esp)
  104cd7:	e8 54 c9 ff ff       	call   101630 <iupdate>
  104cdc:	eb c7                	jmp    104ca5 <sys_unlink+0x175>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
  104cde:	c7 04 24 c0 6f 10 00 	movl   $0x106fc0,(%esp)
  104ce5:	e8 a6 bd ff ff       	call   100a90 <panic>
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  104cea:	c7 04 24 d2 6f 10 00 	movl   $0x106fd2,(%esp)
  104cf1:	e8 9a bd ff ff       	call   100a90 <panic>
    return -1;
  }
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  104cf6:	c7 04 24 ae 6f 10 00 	movl   $0x106fae,(%esp)
  104cfd:	e8 8e bd ff ff       	call   100a90 <panic>
  104d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104d10 <T.67>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104d10:	55                   	push   %ebp
  104d11:	89 e5                	mov    %esp,%ebp
  104d13:	83 ec 28             	sub    $0x28,%esp
  104d16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  104d19:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
  104d1e:	89 75 fc             	mov    %esi,-0x4(%ebp)
  104d21:	89 d6                	mov    %edx,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
  104d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104d2e:	e8 7d f5 ff ff       	call   1042b0 <argint>
  104d33:	85 c0                	test   %eax,%eax
  104d35:	79 11                	jns    104d48 <T.67+0x38>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  104d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return 0;
}
  104d3c:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  104d3f:	8b 75 fc             	mov    -0x4(%ebp),%esi
  104d42:	89 ec                	mov    %ebp,%esp
  104d44:	5d                   	pop    %ebp
  104d45:	c3                   	ret    
  104d46:	66 90                	xchg   %ax,%ax
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
  104d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d4b:	83 f8 0f             	cmp    $0xf,%eax
  104d4e:	77 e7                	ja     104d37 <T.67+0x27>
  104d50:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  104d57:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
  104d5b:	85 d2                	test   %edx,%edx
  104d5d:	74 d8                	je     104d37 <T.67+0x27>
    return -1;
  if(pfd)
  104d5f:	85 db                	test   %ebx,%ebx
  104d61:	74 02                	je     104d65 <T.67+0x55>
    *pfd = fd;
  104d63:	89 03                	mov    %eax,(%ebx)
  if(pf)
  104d65:	31 c0                	xor    %eax,%eax
  104d67:	85 f6                	test   %esi,%esi
  104d69:	74 d1                	je     104d3c <T.67+0x2c>
    *pf = f;
  104d6b:	89 16                	mov    %edx,(%esi)
  104d6d:	eb cd                	jmp    104d3c <T.67+0x2c>
  104d6f:	90                   	nop

00104d70 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
  104d70:	55                   	push   %ebp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104d71:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
  104d73:	89 e5                	mov    %esp,%ebp
  104d75:	53                   	push   %ebx
  104d76:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
  104d79:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104d7c:	e8 8f ff ff ff       	call   104d10 <T.67>
  104d81:	85 c0                	test   %eax,%eax
  104d83:	79 13                	jns    104d98 <sys_dup+0x28>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104d85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
  104d8a:	89 d8                	mov    %ebx,%eax
  104d8c:	83 c4 24             	add    $0x24,%esp
  104d8f:	5b                   	pop    %ebx
  104d90:	5d                   	pop    %ebp
  104d91:	c3                   	ret    
  104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
  104d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d9b:	31 db                	xor    %ebx,%ebx
  104d9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104da3:	eb 0b                	jmp    104db0 <sys_dup+0x40>
  104da5:	8d 76 00             	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
  104da8:	83 c3 01             	add    $0x1,%ebx
  104dab:	83 fb 10             	cmp    $0x10,%ebx
  104dae:	74 d5                	je     104d85 <sys_dup+0x15>
    if(proc->ofile[fd] == 0){
  104db0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
  104db4:	85 c9                	test   %ecx,%ecx
  104db6:	75 f0                	jne    104da8 <sys_dup+0x38>
      proc->ofile[fd] = f;
  104db8:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)
  
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  104dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dbf:	89 04 24             	mov    %eax,(%esp)
  104dc2:	e8 a9 c2 ff ff       	call   101070 <filedup>
  return fd;
  104dc7:	eb c1                	jmp    104d8a <sys_dup+0x1a>
  104dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00104dd0 <sys_read>:
}

int
sys_read(void)
{
  104dd0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104dd1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
  104dd3:	89 e5                	mov    %esp,%ebp
  104dd5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104dd8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104ddb:	e8 30 ff ff ff       	call   104d10 <T.67>
  104de0:	85 c0                	test   %eax,%eax
  104de2:	79 0c                	jns    104df0 <sys_read+0x20>
    return -1;
  return fileread(f, p, n);
  104de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104de9:	c9                   	leave  
  104dea:	c3                   	ret    
  104deb:	90                   	nop
  104dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104df0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104df3:	89 44 24 04          	mov    %eax,0x4(%esp)
  104df7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104dfe:	e8 ad f4 ff ff       	call   1042b0 <argint>
  104e03:	85 c0                	test   %eax,%eax
  104e05:	78 dd                	js     104de4 <sys_read+0x14>
  104e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e11:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e1c:	e8 cf f4 ff ff       	call   1042f0 <argptr>
  104e21:	85 c0                	test   %eax,%eax
  104e23:	78 bf                	js     104de4 <sys_read+0x14>
    return -1;
  return fileread(f, p, n);
  104e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e28:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e36:	89 04 24             	mov    %eax,(%esp)
  104e39:	e8 32 c1 ff ff       	call   100f70 <fileread>
}
  104e3e:	c9                   	leave  
  104e3f:	c3                   	ret    

00104e40 <sys_write>:

int
sys_write(void)
{
  104e40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e41:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
  104e43:	89 e5                	mov    %esp,%ebp
  104e45:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e48:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104e4b:	e8 c0 fe ff ff       	call   104d10 <T.67>
  104e50:	85 c0                	test   %eax,%eax
  104e52:	79 0c                	jns    104e60 <sys_write+0x20>
    return -1;
  return filewrite(f, p, n);
  104e54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104e59:	c9                   	leave  
  104e5a:	c3                   	ret    
  104e5b:	90                   	nop
  104e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
  104e60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e67:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104e6e:	e8 3d f4 ff ff       	call   1042b0 <argint>
  104e73:	85 c0                	test   %eax,%eax
  104e75:	78 dd                	js     104e54 <sys_write+0x14>
  104e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e81:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e85:	8d 45 ec             	lea    -0x14(%ebp),%eax
  104e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  104e8c:	e8 5f f4 ff ff       	call   1042f0 <argptr>
  104e91:	85 c0                	test   %eax,%eax
  104e93:	78 bf                	js     104e54 <sys_write+0x14>
    return -1;
  return filewrite(f, p, n);
  104e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e98:	89 44 24 08          	mov    %eax,0x8(%esp)
  104e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ea6:	89 04 24             	mov    %eax,(%esp)
  104ea9:	e8 12 c0 ff ff       	call   100ec0 <filewrite>
}
  104eae:	c9                   	leave  
  104eaf:	c3                   	ret    

00104eb0 <sys_fstat>:
  return 0;
}

int
sys_fstat(void)
{
  104eb0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104eb1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
  104eb3:	89 e5                	mov    %esp,%ebp
  104eb5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104eb8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  104ebb:	e8 50 fe ff ff       	call   104d10 <T.67>
  104ec0:	85 c0                	test   %eax,%eax
  104ec2:	79 0c                	jns    104ed0 <sys_fstat+0x20>
    return -1;
  return filestat(f, st);
  104ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  104ec9:	c9                   	leave  
  104eca:	c3                   	ret    
  104ecb:	90                   	nop
  104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
sys_fstat(void)
{
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
  104ed0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  104ed3:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
  104eda:	00 
  104edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  104edf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ee6:	e8 05 f4 ff ff       	call   1042f0 <argptr>
  104eeb:	85 c0                	test   %eax,%eax
  104eed:	78 d5                	js     104ec4 <sys_fstat+0x14>
    return -1;
  return filestat(f, st);
  104eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef2:	89 44 24 04          	mov    %eax,0x4(%esp)
  104ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ef9:	89 04 24             	mov    %eax,(%esp)
  104efc:	e8 1f c1 ff ff       	call   101020 <filestat>
}
  104f01:	c9                   	leave  
  104f02:	c3                   	ret    
  104f03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00104f10 <sys_close>:
  return filewrite(f, p, n);
}

int
sys_close(void)
{
  104f10:	55                   	push   %ebp
  104f11:	89 e5                	mov    %esp,%ebp
  104f13:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
  104f16:	8d 55 f0             	lea    -0x10(%ebp),%edx
  104f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104f1c:	e8 ef fd ff ff       	call   104d10 <T.67>
  104f21:	89 c2                	mov    %eax,%edx
  104f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104f28:	85 d2                	test   %edx,%edx
  104f2a:	78 1e                	js     104f4a <sys_close+0x3a>
    return -1;
  proc->ofile[fd] = 0;
  104f2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f35:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
  104f3c:	00 
  fileclose(f);
  104f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f40:	89 04 24             	mov    %eax,(%esp)
  104f43:	e8 f8 c1 ff ff       	call   101140 <fileclose>
  104f48:	31 c0                	xor    %eax,%eax
  return 0;
}
  104f4a:	c9                   	leave  
  104f4b:	c3                   	ret    
  104f4c:	90                   	nop
  104f4d:	90                   	nop
  104f4e:	90                   	nop
  104f4f:	90                   	nop

00104f50 <sys_getpid>:
}

int
sys_getpid(void)
{
  return proc->pid;
  104f50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
  104f56:	55                   	push   %ebp
  104f57:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
  104f59:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
  104f5a:	8b 40 10             	mov    0x10(%eax),%eax
}
  104f5d:	c3                   	ret    
  104f5e:	66 90                	xchg   %ax,%ax

00104f60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since boot.
int
sys_uptime(void)
{
  104f60:	55                   	push   %ebp
  104f61:	89 e5                	mov    %esp,%ebp
  104f63:	53                   	push   %ebx
  104f64:	83 ec 14             	sub    $0x14,%esp
  uint xticks;
  
  acquire(&tickslock);
  104f67:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  104f6e:	e8 fd ef ff ff       	call   103f70 <acquire>
  xticks = ticks;
  104f73:	8b 1d 80 f4 10 00    	mov    0x10f480,%ebx
  release(&tickslock);
  104f79:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  104f80:	e8 9b ef ff ff       	call   103f20 <release>
  return xticks;
}
  104f85:	83 c4 14             	add    $0x14,%esp
  104f88:	89 d8                	mov    %ebx,%eax
  104f8a:	5b                   	pop    %ebx
  104f8b:	5d                   	pop    %ebp
  104f8c:	c3                   	ret    
  104f8d:	8d 76 00             	lea    0x0(%esi),%esi

00104f90 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
  104f90:	55                   	push   %ebp
  104f91:	89 e5                	mov    %esp,%ebp
  104f93:	53                   	push   %ebx
  104f94:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
  104f97:	8d 45 f4             	lea    -0xc(%ebp),%eax
  104f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104fa5:	e8 06 f3 ff ff       	call   1042b0 <argint>
  104faa:	89 c2                	mov    %eax,%edx
  104fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  104fb1:	85 d2                	test   %edx,%edx
  104fb3:	78 59                	js     10500e <sys_sleep+0x7e>
    return -1;
  acquire(&tickslock);
  104fb5:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  104fbc:	e8 af ef ff ff       	call   103f70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  104fc4:	8b 1d 80 f4 10 00    	mov    0x10f480,%ebx
  while(ticks - ticks0 < n){
  104fca:	85 d2                	test   %edx,%edx
  104fcc:	75 22                	jne    104ff0 <sys_sleep+0x60>
  104fce:	eb 48                	jmp    105018 <sys_sleep+0x88>
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  104fd0:	c7 44 24 04 40 ec 10 	movl   $0x10ec40,0x4(%esp)
  104fd7:	00 
  104fd8:	c7 04 24 80 f4 10 00 	movl   $0x10f480,(%esp)
  104fdf:	e8 1c e4 ff ff       	call   103400 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
  104fe4:	a1 80 f4 10 00       	mov    0x10f480,%eax
  104fe9:	29 d8                	sub    %ebx,%eax
  104feb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104fee:	73 28                	jae    105018 <sys_sleep+0x88>
    if(proc->killed){
  104ff0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  104ff6:	8b 40 24             	mov    0x24(%eax),%eax
  104ff9:	85 c0                	test   %eax,%eax
  104ffb:	74 d3                	je     104fd0 <sys_sleep+0x40>
      release(&tickslock);
  104ffd:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  105004:	e8 17 ef ff ff       	call   103f20 <release>
  105009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
  10500e:	83 c4 24             	add    $0x24,%esp
  105011:	5b                   	pop    %ebx
  105012:	5d                   	pop    %ebp
  105013:	c3                   	ret    
  105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105018:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  10501f:	e8 fc ee ff ff       	call   103f20 <release>
  return 0;
}
  105024:	83 c4 24             	add    $0x24,%esp
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  105027:	31 c0                	xor    %eax,%eax
  return 0;
}
  105029:	5b                   	pop    %ebx
  10502a:	5d                   	pop    %ebp
  10502b:	c3                   	ret    
  10502c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105030 <sys_sbrk>:
  return proc->pid;
}

int
sys_sbrk(void)
{
  105030:	55                   	push   %ebp
  105031:	89 e5                	mov    %esp,%ebp
  105033:	53                   	push   %ebx
  105034:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
  105037:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10503a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10503e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105045:	e8 66 f2 ff ff       	call   1042b0 <argint>
  10504a:	85 c0                	test   %eax,%eax
  10504c:	79 12                	jns    105060 <sys_sbrk+0x30>
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
  10504e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  105053:	83 c4 24             	add    $0x24,%esp
  105056:	5b                   	pop    %ebx
  105057:	5d                   	pop    %ebp
  105058:	c3                   	ret    
  105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  105060:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105066:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
  105068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10506b:	89 04 24             	mov    %eax,(%esp)
  10506e:	e8 0d eb ff ff       	call   103b80 <growproc>
  105073:	89 c2                	mov    %eax,%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  105075:	89 d8                	mov    %ebx,%eax
  if(growproc(n) < 0)
  105077:	85 d2                	test   %edx,%edx
  105079:	79 d8                	jns    105053 <sys_sbrk+0x23>
  10507b:	eb d1                	jmp    10504e <sys_sbrk+0x1e>
  10507d:	8d 76 00             	lea    0x0(%esi),%esi

00105080 <sys_kill>:

}

int
sys_kill(void)
{
  105080:	55                   	push   %ebp
  105081:	89 e5                	mov    %esp,%ebp
  105083:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
  105086:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105089:	89 44 24 04          	mov    %eax,0x4(%esp)
  10508d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105094:	e8 17 f2 ff ff       	call   1042b0 <argint>
  105099:	89 c2                	mov    %eax,%edx
  10509b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1050a0:	85 d2                	test   %edx,%edx
  1050a2:	78 0b                	js     1050af <sys_kill+0x2f>
    return -1;
  return kill(pid);
  1050a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050a7:	89 04 24             	mov    %eax,(%esp)
  1050aa:	e8 61 e1 ff ff       	call   103210 <kill>
}
  1050af:	c9                   	leave  
  1050b0:	c3                   	ret    
  1050b1:	eb 0d                	jmp    1050c0 <sys_nice>
  1050b3:	90                   	nop
  1050b4:	90                   	nop
  1050b5:	90                   	nop
  1050b6:	90                   	nop
  1050b7:	90                   	nop
  1050b8:	90                   	nop
  1050b9:	90                   	nop
  1050ba:	90                   	nop
  1050bb:	90                   	nop
  1050bc:	90                   	nop
  1050bd:	90                   	nop
  1050be:	90                   	nop
  1050bf:	90                   	nop

001050c0 <sys_nice>:

}

int
sys_nice(void)
{ 
  1050c0:	55                   	push   %ebp
  1050c1:	89 e5                	mov    %esp,%ebp
  1050c3:	83 ec 08             	sub    $0x8,%esp
  return nice();

}
  1050c6:	c9                   	leave  
}

int
sys_nice(void)
{ 
  return nice();
  1050c7:	e9 d4 e0 ff ff       	jmp    1031a0 <nice>
  1050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

001050d0 <sys_wait2>:
  return wait();
}

int
sys_wait2(void)
{ 
  1050d0:	55                   	push   %ebp
  1050d1:	89 e5                	mov    %esp,%ebp
  1050d3:	83 ec 28             	sub    $0x28,%esp
  int wt = 0;
  int rt = 0;
  return wait2(&wt, &rt);
  1050d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1050d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
}

int
sys_wait2(void)
{ 
  int wt = 0;
  1050e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int rt = 0;
  1050e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  return wait2(&wt, &rt);
  1050ee:	89 04 24             	mov    %eax,(%esp)
  1050f1:	e8 ba e4 ff ff       	call   1035b0 <wait2>

}
  1050f6:	c9                   	leave  
  1050f7:	c3                   	ret    
  1050f8:	90                   	nop
  1050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00105100 <sys_wait>:
  return 0;  // not reached
}

int
sys_wait(void)
{
  105100:	55                   	push   %ebp
  105101:	89 e5                	mov    %esp,%ebp
  105103:	83 ec 08             	sub    $0x8,%esp
  return wait();
}
  105106:	c9                   	leave  
}

int
sys_wait(void)
{
  return wait();
  105107:	e9 04 e6 ff ff       	jmp    103710 <wait>
  10510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00105110 <sys_exit>:
  return fork();
}

int
sys_exit(void)
{
  105110:	55                   	push   %ebp
  105111:	89 e5                	mov    %esp,%ebp
  105113:	83 ec 08             	sub    $0x8,%esp
  exit();
  105116:	e8 15 e7 ff ff       	call   103830 <exit>
  return 0;  // not reached
}
  10511b:	31 c0                	xor    %eax,%eax
  10511d:	c9                   	leave  
  10511e:	c3                   	ret    
  10511f:	90                   	nop

00105120 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  105120:	55                   	push   %ebp
  105121:	89 e5                	mov    %esp,%ebp
  105123:	83 ec 08             	sub    $0x8,%esp
  return fork();
}
  105126:	c9                   	leave  
#include "proc.h"

int
sys_fork(void)
{
  return fork();
  105127:	e9 54 e9 ff ff       	jmp    103a80 <fork>
  10512c:	90                   	nop
  10512d:	90                   	nop
  10512e:	90                   	nop
  10512f:	90                   	nop

00105130 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
  105130:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  105131:	ba 43 00 00 00       	mov    $0x43,%edx
  105136:	89 e5                	mov    %esp,%ebp
  105138:	83 ec 18             	sub    $0x18,%esp
  10513b:	b8 34 00 00 00       	mov    $0x34,%eax
  105140:	ee                   	out    %al,(%dx)
  105141:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
  105146:	b2 40                	mov    $0x40,%dl
  105148:	ee                   	out    %al,(%dx)
  105149:	b8 2e 00 00 00       	mov    $0x2e,%eax
  10514e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
  10514f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105156:	e8 05 dc ff ff       	call   102d60 <picenable>
}
  10515b:	c9                   	leave  
  10515c:	c3                   	ret    
  10515d:	90                   	nop
  10515e:	90                   	nop
  10515f:	90                   	nop

00105160 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  105160:	1e                   	push   %ds
  pushl %es
  105161:	06                   	push   %es
  pushl %fs
  105162:	0f a0                	push   %fs
  pushl %gs
  105164:	0f a8                	push   %gs
  pushal
  105166:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
  105167:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
  10516b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
  10516d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
  10516f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
  105173:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
  105175:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
  105177:	54                   	push   %esp
  call trap
  105178:	e8 43 00 00 00       	call   1051c0 <trap>
  addl $4, %esp
  10517d:	83 c4 04             	add    $0x4,%esp

00105180 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
  105180:	61                   	popa   
  popl %gs
  105181:	0f a9                	pop    %gs
  popl %fs
  105183:	0f a1                	pop    %fs
  popl %es
  105185:	07                   	pop    %es
  popl %ds
  105186:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
  105187:	83 c4 08             	add    $0x8,%esp
  iret
  10518a:	cf                   	iret   
  10518b:	90                   	nop
  10518c:	90                   	nop
  10518d:	90                   	nop
  10518e:	90                   	nop
  10518f:	90                   	nop

00105190 <idtinit>:
  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  105190:	55                   	push   %ebp
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  pd[1] = (uint)p;
  105191:	b8 80 ec 10 00       	mov    $0x10ec80,%eax
  105196:	89 e5                	mov    %esp,%ebp
  105198:	83 ec 10             	sub    $0x10,%esp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  10519b:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
  1051a1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
  1051a5:	c1 e8 10             	shr    $0x10,%eax
  1051a8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
  1051ac:	8d 45 fa             	lea    -0x6(%ebp),%eax
  1051af:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
  1051b2:	c9                   	leave  
  1051b3:	c3                   	ret    
  1051b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1051ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

001051c0 <trap>:

void
trap(struct trapframe *tf)
{
  1051c0:	55                   	push   %ebp
  1051c1:	89 e5                	mov    %esp,%ebp
  1051c3:	56                   	push   %esi
  1051c4:	53                   	push   %ebx
  1051c5:	83 ec 20             	sub    $0x20,%esp
  1051c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
  1051cb:	8b 43 30             	mov    0x30(%ebx),%eax
  1051ce:	83 f8 40             	cmp    $0x40,%eax
  1051d1:	0f 84 d1 00 00 00    	je     1052a8 <trap+0xe8>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1051d7:	8d 50 e0             	lea    -0x20(%eax),%edx
  1051da:	83 fa 1f             	cmp    $0x1f,%edx
  1051dd:	0f 86 bd 00 00 00    	jbe    1052a0 <trap+0xe0>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
  1051e3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  1051ea:	85 d2                	test   %edx,%edx
  1051ec:	0f 84 06 02 00 00    	je     1053f8 <trap+0x238>
  1051f2:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
  1051f6:	0f 84 fc 01 00 00    	je     1053f8 <trap+0x238>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
  1051fc:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
  1051ff:	8b 4a 10             	mov    0x10(%edx),%ecx
  105202:	83 c2 6c             	add    $0x6c,%edx
  105205:	89 74 24 1c          	mov    %esi,0x1c(%esp)
  105209:	8b 73 38             	mov    0x38(%ebx),%esi
  10520c:	89 74 24 18          	mov    %esi,0x18(%esp)
  105210:	65 8b 35 00 00 00 00 	mov    %gs:0x0,%esi
  105217:	0f b6 36             	movzbl (%esi),%esi
  10521a:	89 74 24 14          	mov    %esi,0x14(%esp)
  10521e:	8b 73 34             	mov    0x34(%ebx),%esi
  105221:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105225:	89 54 24 08          	mov    %edx,0x8(%esp)
  105229:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10522d:	89 74 24 10          	mov    %esi,0x10(%esp)
  105231:	c7 04 24 3c 70 10 00 	movl   $0x10703c,(%esp)
  105238:	e8 83 b2 ff ff       	call   1004c0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
  10523d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105243:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  10524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  105250:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  105256:	85 c0                	test   %eax,%eax
  105258:	74 70                	je     1052ca <trap+0x10a>
  10525a:	8b 50 24             	mov    0x24(%eax),%edx
  10525d:	85 d2                	test   %edx,%edx
  10525f:	74 10                	je     105271 <trap+0xb1>
  105261:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
  105265:	83 e2 03             	and    $0x3,%edx
  105268:	83 fa 03             	cmp    $0x3,%edx
  10526b:	0f 84 6f 01 00 00    	je     1053e0 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  105271:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
  105275:	0f 84 35 01 00 00    	je     1053b0 <trap+0x1f0>
    yield();
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  10527b:	8b 40 24             	mov    0x24(%eax),%eax
  10527e:	85 c0                	test   %eax,%eax
  105280:	74 48                	je     1052ca <trap+0x10a>
  105282:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  105286:	83 e0 03             	and    $0x3,%eax
  105289:	83 f8 03             	cmp    $0x3,%eax
  10528c:	75 3c                	jne    1052ca <trap+0x10a>
    exit();
}
  10528e:	83 c4 20             	add    $0x20,%esp
  105291:	5b                   	pop    %ebx
  105292:	5e                   	pop    %esi
  105293:	5d                   	pop    %ebp
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  105294:	e9 97 e5 ff ff       	jmp    103830 <exit>
  105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  1052a0:	ff 24 95 8c 70 10 00 	jmp    *0x10708c(,%edx,4)
  1052a7:	90                   	nop

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
  1052a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1052ae:	8b 70 24             	mov    0x24(%eax),%esi
  1052b1:	85 f6                	test   %esi,%esi
  1052b3:	75 23                	jne    1052d8 <trap+0x118>
      exit();
    proc->tf = tf;
  1052b5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
  1052b8:	e8 f3 f0 ff ff       	call   1043b0 <syscall>
    if(proc->killed)
  1052bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1052c3:	8b 48 24             	mov    0x24(%eax),%ecx
  1052c6:	85 c9                	test   %ecx,%ecx
  1052c8:	75 c4                	jne    10528e <trap+0xce>
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
  1052ca:	83 c4 20             	add    $0x20,%esp
  1052cd:	5b                   	pop    %ebx
  1052ce:	5e                   	pop    %esi
  1052cf:	5d                   	pop    %ebp
  1052d0:	c3                   	ret    
  1052d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
  1052d8:	e8 53 e5 ff ff       	call   103830 <exit>
  1052dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1052e3:	eb d0                	jmp    1052b5 <trap+0xf5>
  1052e5:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
  1052e8:	8b 43 38             	mov    0x38(%ebx),%eax
  1052eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1052ef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
  1052f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052f7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1052fd:	0f b6 00             	movzbl (%eax),%eax
  105300:	c7 04 24 e4 6f 10 00 	movl   $0x106fe4,(%esp)
  105307:	89 44 24 04          	mov    %eax,0x4(%esp)
  10530b:	e8 b0 b1 ff ff       	call   1004c0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
  105310:	e8 1b d3 ff ff       	call   102630 <lapiceoi>
    break;
  105315:	e9 36 ff ff ff       	jmp    105250 <trap+0x90>
  10531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
  105320:	e8 cb 01 00 00       	call   1054f0 <uartintr>
  105325:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105328:	e8 03 d3 ff ff       	call   102630 <lapiceoi>
  10532d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105330:	e9 1b ff ff ff       	jmp    105250 <trap+0x90>
  105335:	8d 76 00             	lea    0x0(%esi),%esi
  105338:	90                   	nop
  105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
  105340:	e8 8b ce ff ff       	call   1021d0 <ideintr>
  105345:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105348:	e8 e3 d2 ff ff       	call   102630 <lapiceoi>
  10534d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105350:	e9 fb fe ff ff       	jmp    105250 <trap+0x90>
  105355:	8d 76 00             	lea    0x0(%esi),%esi
  105358:	90                   	nop
  105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
  105360:	e8 ab d2 ff ff       	call   102610 <kbdintr>
  105365:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
  105368:	e8 c3 d2 ff ff       	call   102630 <lapiceoi>
  10536d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  105370:	e9 db fe ff ff       	jmp    105250 <trap+0x90>
  105375:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
  105378:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10537e:	80 38 00             	cmpb   $0x0,(%eax)
  105381:	75 c2                	jne    105345 <trap+0x185>
      acquire(&tickslock);
  105383:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  10538a:	e8 e1 eb ff ff       	call   103f70 <acquire>
      ticks++;
  10538f:	83 05 80 f4 10 00 01 	addl   $0x1,0x10f480
      wakeup(&ticks);
  105396:	c7 04 24 80 f4 10 00 	movl   $0x10f480,(%esp)
  10539d:	e8 fe de ff ff       	call   1032a0 <wakeup>
      release(&tickslock);
  1053a2:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
  1053a9:	e8 72 eb ff ff       	call   103f20 <release>
  1053ae:	eb 95                	jmp    105345 <trap+0x185>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  1053b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
  1053b4:	0f 85 c1 fe ff ff    	jne    10527b <trap+0xbb>
    //cprintf("lol");
    clockticks++;
  1053ba:	83 05 ac 90 10 00 01 	addl   $0x1,0x1090ac
    proc->rtime++;
  1053c1:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
    clockticks=0;
    yield();
    }

#else
    yield();
  1053c8:	e8 03 e1 ff ff       	call   1034d0 <yield>
#endif /*RR*/
}

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
  1053cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1053d3:	85 c0                	test   %eax,%eax
  1053d5:	0f 85 a0 fe ff ff    	jne    10527b <trap+0xbb>
  1053db:	e9 ea fe ff ff       	jmp    1052ca <trap+0x10a>

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
  1053e0:	e8 4b e4 ff ff       	call   103830 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
  1053e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  1053eb:	85 c0                	test   %eax,%eax
  1053ed:	0f 85 7e fe ff ff    	jne    105271 <trap+0xb1>
  1053f3:	e9 d2 fe ff ff       	jmp    1052ca <trap+0x10a>
  1053f8:	0f 20 d2             	mov    %cr2,%edx
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
  1053fb:	89 54 24 10          	mov    %edx,0x10(%esp)
  1053ff:	8b 53 38             	mov    0x38(%ebx),%edx
  105402:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105406:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  10540d:	0f b6 12             	movzbl (%edx),%edx
  105410:	89 44 24 04          	mov    %eax,0x4(%esp)
  105414:	c7 04 24 08 70 10 00 	movl   $0x107008,(%esp)
  10541b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10541f:	e8 9c b0 ff ff       	call   1004c0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
  105424:	c7 04 24 7f 70 10 00 	movl   $0x10707f,(%esp)
  10542b:	e8 60 b6 ff ff       	call   100a90 <panic>

00105430 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  105430:	55                   	push   %ebp
  105431:	31 c0                	xor    %eax,%eax
  105433:	89 e5                	mov    %esp,%ebp
  105435:	ba 80 ec 10 00       	mov    $0x10ec80,%edx
  10543a:	83 ec 18             	sub    $0x18,%esp
  10543d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  105440:	8b 0c 85 08 85 10 00 	mov    0x108508(,%eax,4),%ecx
  105447:	66 89 0c c5 80 ec 10 	mov    %cx,0x10ec80(,%eax,8)
  10544e:	00 
  10544f:	c1 e9 10             	shr    $0x10,%ecx
  105452:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  105459:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  10545e:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  105463:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
  105468:	83 c0 01             	add    $0x1,%eax
  10546b:	3d 00 01 00 00       	cmp    $0x100,%eax
  105470:	75 ce                	jne    105440 <tvinit+0x10>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105472:	a1 08 86 10 00       	mov    0x108608,%eax
  
  initlock(&tickslock, "time");
  105477:	c7 44 24 04 84 70 10 	movl   $0x107084,0x4(%esp)
  10547e:	00 
  10547f:	c7 04 24 40 ec 10 00 	movl   $0x10ec40,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  105486:	66 c7 05 82 ee 10 00 	movw   $0x8,0x10ee82
  10548d:	08 00 
  10548f:	66 a3 80 ee 10 00    	mov    %ax,0x10ee80
  105495:	c1 e8 10             	shr    $0x10,%eax
  105498:	c6 05 84 ee 10 00 00 	movb   $0x0,0x10ee84
  10549f:	c6 05 85 ee 10 00 ef 	movb   $0xef,0x10ee85
  1054a6:	66 a3 86 ee 10 00    	mov    %ax,0x10ee86
  
  initlock(&tickslock, "time");
  1054ac:	e8 2f e9 ff ff       	call   103de0 <initlock>
}
  1054b1:	c9                   	leave  
  1054b2:	c3                   	ret    
  1054b3:	90                   	nop
  1054b4:	90                   	nop
  1054b5:	90                   	nop
  1054b6:	90                   	nop
  1054b7:	90                   	nop
  1054b8:	90                   	nop
  1054b9:	90                   	nop
  1054ba:	90                   	nop
  1054bb:	90                   	nop
  1054bc:	90                   	nop
  1054bd:	90                   	nop
  1054be:	90                   	nop
  1054bf:	90                   	nop

001054c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
  1054c0:	a1 b0 90 10 00       	mov    0x1090b0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
  1054c5:	55                   	push   %ebp
  1054c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
  1054c8:	85 c0                	test   %eax,%eax
  1054ca:	75 0c                	jne    1054d8 <uartgetc+0x18>
    return -1;
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
  1054cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  1054d1:	5d                   	pop    %ebp
  1054d2:	c3                   	ret    
  1054d3:	90                   	nop
  1054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1054d8:	ba fd 03 00 00       	mov    $0x3fd,%edx
  1054dd:	ec                   	in     (%dx),%al
static int
uartgetc(void)
{
  if(!uart)
    return -1;
  if(!(inb(COM1+5) & 0x01))
  1054de:	a8 01                	test   $0x1,%al
  1054e0:	74 ea                	je     1054cc <uartgetc+0xc>
  1054e2:	b2 f8                	mov    $0xf8,%dl
  1054e4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
  1054e5:	0f b6 c0             	movzbl %al,%eax
}
  1054e8:	5d                   	pop    %ebp
  1054e9:	c3                   	ret    
  1054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

001054f0 <uartintr>:

void
uartintr(void)
{
  1054f0:	55                   	push   %ebp
  1054f1:	89 e5                	mov    %esp,%ebp
  1054f3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
  1054f6:	c7 04 24 c0 54 10 00 	movl   $0x1054c0,(%esp)
  1054fd:	e8 be b2 ff ff       	call   1007c0 <consoleintr>
}
  105502:	c9                   	leave  
  105503:	c3                   	ret    
  105504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10550a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00105510 <uartputc>:
    uartputc(*p);
}

void
uartputc(int c)
{
  105510:	55                   	push   %ebp
  105511:	89 e5                	mov    %esp,%ebp
  105513:	56                   	push   %esi
  105514:	be fd 03 00 00       	mov    $0x3fd,%esi
  105519:	53                   	push   %ebx
  int i;

  if(!uart)
  10551a:	31 db                	xor    %ebx,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
  10551c:	83 ec 10             	sub    $0x10,%esp
  int i;

  if(!uart)
  10551f:	8b 15 b0 90 10 00    	mov    0x1090b0,%edx
  105525:	85 d2                	test   %edx,%edx
  105527:	75 1e                	jne    105547 <uartputc+0x37>
  105529:	eb 2c                	jmp    105557 <uartputc+0x47>
  10552b:	90                   	nop
  10552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  105530:	83 c3 01             	add    $0x1,%ebx
    microdelay(10);
  105533:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10553a:	e8 11 d1 ff ff       	call   102650 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
  10553f:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
  105545:	74 07                	je     10554e <uartputc+0x3e>
  105547:	89 f2                	mov    %esi,%edx
  105549:	ec                   	in     (%dx),%al
  10554a:	a8 20                	test   $0x20,%al
  10554c:	74 e2                	je     105530 <uartputc+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  10554e:	ba f8 03 00 00       	mov    $0x3f8,%edx
  105553:	8b 45 08             	mov    0x8(%ebp),%eax
  105556:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
  105557:	83 c4 10             	add    $0x10,%esp
  10555a:	5b                   	pop    %ebx
  10555b:	5e                   	pop    %esi
  10555c:	5d                   	pop    %ebp
  10555d:	c3                   	ret    
  10555e:	66 90                	xchg   %ax,%ax

00105560 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
  105560:	55                   	push   %ebp
  105561:	31 c9                	xor    %ecx,%ecx
  105563:	89 e5                	mov    %esp,%ebp
  105565:	89 c8                	mov    %ecx,%eax
  105567:	57                   	push   %edi
  105568:	bf fa 03 00 00       	mov    $0x3fa,%edi
  10556d:	56                   	push   %esi
  10556e:	89 fa                	mov    %edi,%edx
  105570:	53                   	push   %ebx
  105571:	83 ec 1c             	sub    $0x1c,%esp
  105574:	ee                   	out    %al,(%dx)
  105575:	bb fb 03 00 00       	mov    $0x3fb,%ebx
  10557a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
  10557f:	89 da                	mov    %ebx,%edx
  105581:	ee                   	out    %al,(%dx)
  105582:	b8 0c 00 00 00       	mov    $0xc,%eax
  105587:	b2 f8                	mov    $0xf8,%dl
  105589:	ee                   	out    %al,(%dx)
  10558a:	be f9 03 00 00       	mov    $0x3f9,%esi
  10558f:	89 c8                	mov    %ecx,%eax
  105591:	89 f2                	mov    %esi,%edx
  105593:	ee                   	out    %al,(%dx)
  105594:	b8 03 00 00 00       	mov    $0x3,%eax
  105599:	89 da                	mov    %ebx,%edx
  10559b:	ee                   	out    %al,(%dx)
  10559c:	b2 fc                	mov    $0xfc,%dl
  10559e:	89 c8                	mov    %ecx,%eax
  1055a0:	ee                   	out    %al,(%dx)
  1055a1:	b8 01 00 00 00       	mov    $0x1,%eax
  1055a6:	89 f2                	mov    %esi,%edx
  1055a8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
  1055a9:	b2 fd                	mov    $0xfd,%dl
  1055ab:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
  1055ac:	3c ff                	cmp    $0xff,%al
  1055ae:	74 55                	je     105605 <uartinit+0xa5>
    return;
  uart = 1;
  1055b0:	c7 05 b0 90 10 00 01 	movl   $0x1,0x1090b0
  1055b7:	00 00 00 
  1055ba:	89 fa                	mov    %edi,%edx
  1055bc:	ec                   	in     (%dx),%al
  1055bd:	b2 f8                	mov    $0xf8,%dl
  1055bf:	ec                   	in     (%dx),%al
  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  1055c0:	bb 0c 71 10 00       	mov    $0x10710c,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
  1055c5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1055cc:	e8 8f d7 ff ff       	call   102d60 <picenable>
  ioapicenable(IRQ_COM1, 0);
  1055d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1055d8:	00 
  1055d9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1055e0:	e8 3b cd ff ff       	call   102320 <ioapicenable>
  1055e5:	b8 78 00 00 00       	mov    $0x78,%eax
  1055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
  1055f0:	0f be c0             	movsbl %al,%eax
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1055f3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
  1055f6:	89 04 24             	mov    %eax,(%esp)
  1055f9:	e8 12 ff ff ff       	call   105510 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
  1055fe:	0f b6 03             	movzbl (%ebx),%eax
  105601:	84 c0                	test   %al,%al
  105603:	75 eb                	jne    1055f0 <uartinit+0x90>
    uartputc(*p);
}
  105605:	83 c4 1c             	add    $0x1c,%esp
  105608:	5b                   	pop    %ebx
  105609:	5e                   	pop    %esi
  10560a:	5f                   	pop    %edi
  10560b:	5d                   	pop    %ebp
  10560c:	c3                   	ret    
  10560d:	90                   	nop
  10560e:	90                   	nop
  10560f:	90                   	nop

00105610 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
  105610:	6a 00                	push   $0x0
  pushl $0
  105612:	6a 00                	push   $0x0
  jmp alltraps
  105614:	e9 47 fb ff ff       	jmp    105160 <alltraps>

00105619 <vector1>:
.globl vector1
vector1:
  pushl $0
  105619:	6a 00                	push   $0x0
  pushl $1
  10561b:	6a 01                	push   $0x1
  jmp alltraps
  10561d:	e9 3e fb ff ff       	jmp    105160 <alltraps>

00105622 <vector2>:
.globl vector2
vector2:
  pushl $0
  105622:	6a 00                	push   $0x0
  pushl $2
  105624:	6a 02                	push   $0x2
  jmp alltraps
  105626:	e9 35 fb ff ff       	jmp    105160 <alltraps>

0010562b <vector3>:
.globl vector3
vector3:
  pushl $0
  10562b:	6a 00                	push   $0x0
  pushl $3
  10562d:	6a 03                	push   $0x3
  jmp alltraps
  10562f:	e9 2c fb ff ff       	jmp    105160 <alltraps>

00105634 <vector4>:
.globl vector4
vector4:
  pushl $0
  105634:	6a 00                	push   $0x0
  pushl $4
  105636:	6a 04                	push   $0x4
  jmp alltraps
  105638:	e9 23 fb ff ff       	jmp    105160 <alltraps>

0010563d <vector5>:
.globl vector5
vector5:
  pushl $0
  10563d:	6a 00                	push   $0x0
  pushl $5
  10563f:	6a 05                	push   $0x5
  jmp alltraps
  105641:	e9 1a fb ff ff       	jmp    105160 <alltraps>

00105646 <vector6>:
.globl vector6
vector6:
  pushl $0
  105646:	6a 00                	push   $0x0
  pushl $6
  105648:	6a 06                	push   $0x6
  jmp alltraps
  10564a:	e9 11 fb ff ff       	jmp    105160 <alltraps>

0010564f <vector7>:
.globl vector7
vector7:
  pushl $0
  10564f:	6a 00                	push   $0x0
  pushl $7
  105651:	6a 07                	push   $0x7
  jmp alltraps
  105653:	e9 08 fb ff ff       	jmp    105160 <alltraps>

00105658 <vector8>:
.globl vector8
vector8:
  pushl $8
  105658:	6a 08                	push   $0x8
  jmp alltraps
  10565a:	e9 01 fb ff ff       	jmp    105160 <alltraps>

0010565f <vector9>:
.globl vector9
vector9:
  pushl $0
  10565f:	6a 00                	push   $0x0
  pushl $9
  105661:	6a 09                	push   $0x9
  jmp alltraps
  105663:	e9 f8 fa ff ff       	jmp    105160 <alltraps>

00105668 <vector10>:
.globl vector10
vector10:
  pushl $10
  105668:	6a 0a                	push   $0xa
  jmp alltraps
  10566a:	e9 f1 fa ff ff       	jmp    105160 <alltraps>

0010566f <vector11>:
.globl vector11
vector11:
  pushl $11
  10566f:	6a 0b                	push   $0xb
  jmp alltraps
  105671:	e9 ea fa ff ff       	jmp    105160 <alltraps>

00105676 <vector12>:
.globl vector12
vector12:
  pushl $12
  105676:	6a 0c                	push   $0xc
  jmp alltraps
  105678:	e9 e3 fa ff ff       	jmp    105160 <alltraps>

0010567d <vector13>:
.globl vector13
vector13:
  pushl $13
  10567d:	6a 0d                	push   $0xd
  jmp alltraps
  10567f:	e9 dc fa ff ff       	jmp    105160 <alltraps>

00105684 <vector14>:
.globl vector14
vector14:
  pushl $14
  105684:	6a 0e                	push   $0xe
  jmp alltraps
  105686:	e9 d5 fa ff ff       	jmp    105160 <alltraps>

0010568b <vector15>:
.globl vector15
vector15:
  pushl $0
  10568b:	6a 00                	push   $0x0
  pushl $15
  10568d:	6a 0f                	push   $0xf
  jmp alltraps
  10568f:	e9 cc fa ff ff       	jmp    105160 <alltraps>

00105694 <vector16>:
.globl vector16
vector16:
  pushl $0
  105694:	6a 00                	push   $0x0
  pushl $16
  105696:	6a 10                	push   $0x10
  jmp alltraps
  105698:	e9 c3 fa ff ff       	jmp    105160 <alltraps>

0010569d <vector17>:
.globl vector17
vector17:
  pushl $17
  10569d:	6a 11                	push   $0x11
  jmp alltraps
  10569f:	e9 bc fa ff ff       	jmp    105160 <alltraps>

001056a4 <vector18>:
.globl vector18
vector18:
  pushl $0
  1056a4:	6a 00                	push   $0x0
  pushl $18
  1056a6:	6a 12                	push   $0x12
  jmp alltraps
  1056a8:	e9 b3 fa ff ff       	jmp    105160 <alltraps>

001056ad <vector19>:
.globl vector19
vector19:
  pushl $0
  1056ad:	6a 00                	push   $0x0
  pushl $19
  1056af:	6a 13                	push   $0x13
  jmp alltraps
  1056b1:	e9 aa fa ff ff       	jmp    105160 <alltraps>

001056b6 <vector20>:
.globl vector20
vector20:
  pushl $0
  1056b6:	6a 00                	push   $0x0
  pushl $20
  1056b8:	6a 14                	push   $0x14
  jmp alltraps
  1056ba:	e9 a1 fa ff ff       	jmp    105160 <alltraps>

001056bf <vector21>:
.globl vector21
vector21:
  pushl $0
  1056bf:	6a 00                	push   $0x0
  pushl $21
  1056c1:	6a 15                	push   $0x15
  jmp alltraps
  1056c3:	e9 98 fa ff ff       	jmp    105160 <alltraps>

001056c8 <vector22>:
.globl vector22
vector22:
  pushl $0
  1056c8:	6a 00                	push   $0x0
  pushl $22
  1056ca:	6a 16                	push   $0x16
  jmp alltraps
  1056cc:	e9 8f fa ff ff       	jmp    105160 <alltraps>

001056d1 <vector23>:
.globl vector23
vector23:
  pushl $0
  1056d1:	6a 00                	push   $0x0
  pushl $23
  1056d3:	6a 17                	push   $0x17
  jmp alltraps
  1056d5:	e9 86 fa ff ff       	jmp    105160 <alltraps>

001056da <vector24>:
.globl vector24
vector24:
  pushl $0
  1056da:	6a 00                	push   $0x0
  pushl $24
  1056dc:	6a 18                	push   $0x18
  jmp alltraps
  1056de:	e9 7d fa ff ff       	jmp    105160 <alltraps>

001056e3 <vector25>:
.globl vector25
vector25:
  pushl $0
  1056e3:	6a 00                	push   $0x0
  pushl $25
  1056e5:	6a 19                	push   $0x19
  jmp alltraps
  1056e7:	e9 74 fa ff ff       	jmp    105160 <alltraps>

001056ec <vector26>:
.globl vector26
vector26:
  pushl $0
  1056ec:	6a 00                	push   $0x0
  pushl $26
  1056ee:	6a 1a                	push   $0x1a
  jmp alltraps
  1056f0:	e9 6b fa ff ff       	jmp    105160 <alltraps>

001056f5 <vector27>:
.globl vector27
vector27:
  pushl $0
  1056f5:	6a 00                	push   $0x0
  pushl $27
  1056f7:	6a 1b                	push   $0x1b
  jmp alltraps
  1056f9:	e9 62 fa ff ff       	jmp    105160 <alltraps>

001056fe <vector28>:
.globl vector28
vector28:
  pushl $0
  1056fe:	6a 00                	push   $0x0
  pushl $28
  105700:	6a 1c                	push   $0x1c
  jmp alltraps
  105702:	e9 59 fa ff ff       	jmp    105160 <alltraps>

00105707 <vector29>:
.globl vector29
vector29:
  pushl $0
  105707:	6a 00                	push   $0x0
  pushl $29
  105709:	6a 1d                	push   $0x1d
  jmp alltraps
  10570b:	e9 50 fa ff ff       	jmp    105160 <alltraps>

00105710 <vector30>:
.globl vector30
vector30:
  pushl $0
  105710:	6a 00                	push   $0x0
  pushl $30
  105712:	6a 1e                	push   $0x1e
  jmp alltraps
  105714:	e9 47 fa ff ff       	jmp    105160 <alltraps>

00105719 <vector31>:
.globl vector31
vector31:
  pushl $0
  105719:	6a 00                	push   $0x0
  pushl $31
  10571b:	6a 1f                	push   $0x1f
  jmp alltraps
  10571d:	e9 3e fa ff ff       	jmp    105160 <alltraps>

00105722 <vector32>:
.globl vector32
vector32:
  pushl $0
  105722:	6a 00                	push   $0x0
  pushl $32
  105724:	6a 20                	push   $0x20
  jmp alltraps
  105726:	e9 35 fa ff ff       	jmp    105160 <alltraps>

0010572b <vector33>:
.globl vector33
vector33:
  pushl $0
  10572b:	6a 00                	push   $0x0
  pushl $33
  10572d:	6a 21                	push   $0x21
  jmp alltraps
  10572f:	e9 2c fa ff ff       	jmp    105160 <alltraps>

00105734 <vector34>:
.globl vector34
vector34:
  pushl $0
  105734:	6a 00                	push   $0x0
  pushl $34
  105736:	6a 22                	push   $0x22
  jmp alltraps
  105738:	e9 23 fa ff ff       	jmp    105160 <alltraps>

0010573d <vector35>:
.globl vector35
vector35:
  pushl $0
  10573d:	6a 00                	push   $0x0
  pushl $35
  10573f:	6a 23                	push   $0x23
  jmp alltraps
  105741:	e9 1a fa ff ff       	jmp    105160 <alltraps>

00105746 <vector36>:
.globl vector36
vector36:
  pushl $0
  105746:	6a 00                	push   $0x0
  pushl $36
  105748:	6a 24                	push   $0x24
  jmp alltraps
  10574a:	e9 11 fa ff ff       	jmp    105160 <alltraps>

0010574f <vector37>:
.globl vector37
vector37:
  pushl $0
  10574f:	6a 00                	push   $0x0
  pushl $37
  105751:	6a 25                	push   $0x25
  jmp alltraps
  105753:	e9 08 fa ff ff       	jmp    105160 <alltraps>

00105758 <vector38>:
.globl vector38
vector38:
  pushl $0
  105758:	6a 00                	push   $0x0
  pushl $38
  10575a:	6a 26                	push   $0x26
  jmp alltraps
  10575c:	e9 ff f9 ff ff       	jmp    105160 <alltraps>

00105761 <vector39>:
.globl vector39
vector39:
  pushl $0
  105761:	6a 00                	push   $0x0
  pushl $39
  105763:	6a 27                	push   $0x27
  jmp alltraps
  105765:	e9 f6 f9 ff ff       	jmp    105160 <alltraps>

0010576a <vector40>:
.globl vector40
vector40:
  pushl $0
  10576a:	6a 00                	push   $0x0
  pushl $40
  10576c:	6a 28                	push   $0x28
  jmp alltraps
  10576e:	e9 ed f9 ff ff       	jmp    105160 <alltraps>

00105773 <vector41>:
.globl vector41
vector41:
  pushl $0
  105773:	6a 00                	push   $0x0
  pushl $41
  105775:	6a 29                	push   $0x29
  jmp alltraps
  105777:	e9 e4 f9 ff ff       	jmp    105160 <alltraps>

0010577c <vector42>:
.globl vector42
vector42:
  pushl $0
  10577c:	6a 00                	push   $0x0
  pushl $42
  10577e:	6a 2a                	push   $0x2a
  jmp alltraps
  105780:	e9 db f9 ff ff       	jmp    105160 <alltraps>

00105785 <vector43>:
.globl vector43
vector43:
  pushl $0
  105785:	6a 00                	push   $0x0
  pushl $43
  105787:	6a 2b                	push   $0x2b
  jmp alltraps
  105789:	e9 d2 f9 ff ff       	jmp    105160 <alltraps>

0010578e <vector44>:
.globl vector44
vector44:
  pushl $0
  10578e:	6a 00                	push   $0x0
  pushl $44
  105790:	6a 2c                	push   $0x2c
  jmp alltraps
  105792:	e9 c9 f9 ff ff       	jmp    105160 <alltraps>

00105797 <vector45>:
.globl vector45
vector45:
  pushl $0
  105797:	6a 00                	push   $0x0
  pushl $45
  105799:	6a 2d                	push   $0x2d
  jmp alltraps
  10579b:	e9 c0 f9 ff ff       	jmp    105160 <alltraps>

001057a0 <vector46>:
.globl vector46
vector46:
  pushl $0
  1057a0:	6a 00                	push   $0x0
  pushl $46
  1057a2:	6a 2e                	push   $0x2e
  jmp alltraps
  1057a4:	e9 b7 f9 ff ff       	jmp    105160 <alltraps>

001057a9 <vector47>:
.globl vector47
vector47:
  pushl $0
  1057a9:	6a 00                	push   $0x0
  pushl $47
  1057ab:	6a 2f                	push   $0x2f
  jmp alltraps
  1057ad:	e9 ae f9 ff ff       	jmp    105160 <alltraps>

001057b2 <vector48>:
.globl vector48
vector48:
  pushl $0
  1057b2:	6a 00                	push   $0x0
  pushl $48
  1057b4:	6a 30                	push   $0x30
  jmp alltraps
  1057b6:	e9 a5 f9 ff ff       	jmp    105160 <alltraps>

001057bb <vector49>:
.globl vector49
vector49:
  pushl $0
  1057bb:	6a 00                	push   $0x0
  pushl $49
  1057bd:	6a 31                	push   $0x31
  jmp alltraps
  1057bf:	e9 9c f9 ff ff       	jmp    105160 <alltraps>

001057c4 <vector50>:
.globl vector50
vector50:
  pushl $0
  1057c4:	6a 00                	push   $0x0
  pushl $50
  1057c6:	6a 32                	push   $0x32
  jmp alltraps
  1057c8:	e9 93 f9 ff ff       	jmp    105160 <alltraps>

001057cd <vector51>:
.globl vector51
vector51:
  pushl $0
  1057cd:	6a 00                	push   $0x0
  pushl $51
  1057cf:	6a 33                	push   $0x33
  jmp alltraps
  1057d1:	e9 8a f9 ff ff       	jmp    105160 <alltraps>

001057d6 <vector52>:
.globl vector52
vector52:
  pushl $0
  1057d6:	6a 00                	push   $0x0
  pushl $52
  1057d8:	6a 34                	push   $0x34
  jmp alltraps
  1057da:	e9 81 f9 ff ff       	jmp    105160 <alltraps>

001057df <vector53>:
.globl vector53
vector53:
  pushl $0
  1057df:	6a 00                	push   $0x0
  pushl $53
  1057e1:	6a 35                	push   $0x35
  jmp alltraps
  1057e3:	e9 78 f9 ff ff       	jmp    105160 <alltraps>

001057e8 <vector54>:
.globl vector54
vector54:
  pushl $0
  1057e8:	6a 00                	push   $0x0
  pushl $54
  1057ea:	6a 36                	push   $0x36
  jmp alltraps
  1057ec:	e9 6f f9 ff ff       	jmp    105160 <alltraps>

001057f1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1057f1:	6a 00                	push   $0x0
  pushl $55
  1057f3:	6a 37                	push   $0x37
  jmp alltraps
  1057f5:	e9 66 f9 ff ff       	jmp    105160 <alltraps>

001057fa <vector56>:
.globl vector56
vector56:
  pushl $0
  1057fa:	6a 00                	push   $0x0
  pushl $56
  1057fc:	6a 38                	push   $0x38
  jmp alltraps
  1057fe:	e9 5d f9 ff ff       	jmp    105160 <alltraps>

00105803 <vector57>:
.globl vector57
vector57:
  pushl $0
  105803:	6a 00                	push   $0x0
  pushl $57
  105805:	6a 39                	push   $0x39
  jmp alltraps
  105807:	e9 54 f9 ff ff       	jmp    105160 <alltraps>

0010580c <vector58>:
.globl vector58
vector58:
  pushl $0
  10580c:	6a 00                	push   $0x0
  pushl $58
  10580e:	6a 3a                	push   $0x3a
  jmp alltraps
  105810:	e9 4b f9 ff ff       	jmp    105160 <alltraps>

00105815 <vector59>:
.globl vector59
vector59:
  pushl $0
  105815:	6a 00                	push   $0x0
  pushl $59
  105817:	6a 3b                	push   $0x3b
  jmp alltraps
  105819:	e9 42 f9 ff ff       	jmp    105160 <alltraps>

0010581e <vector60>:
.globl vector60
vector60:
  pushl $0
  10581e:	6a 00                	push   $0x0
  pushl $60
  105820:	6a 3c                	push   $0x3c
  jmp alltraps
  105822:	e9 39 f9 ff ff       	jmp    105160 <alltraps>

00105827 <vector61>:
.globl vector61
vector61:
  pushl $0
  105827:	6a 00                	push   $0x0
  pushl $61
  105829:	6a 3d                	push   $0x3d
  jmp alltraps
  10582b:	e9 30 f9 ff ff       	jmp    105160 <alltraps>

00105830 <vector62>:
.globl vector62
vector62:
  pushl $0
  105830:	6a 00                	push   $0x0
  pushl $62
  105832:	6a 3e                	push   $0x3e
  jmp alltraps
  105834:	e9 27 f9 ff ff       	jmp    105160 <alltraps>

00105839 <vector63>:
.globl vector63
vector63:
  pushl $0
  105839:	6a 00                	push   $0x0
  pushl $63
  10583b:	6a 3f                	push   $0x3f
  jmp alltraps
  10583d:	e9 1e f9 ff ff       	jmp    105160 <alltraps>

00105842 <vector64>:
.globl vector64
vector64:
  pushl $0
  105842:	6a 00                	push   $0x0
  pushl $64
  105844:	6a 40                	push   $0x40
  jmp alltraps
  105846:	e9 15 f9 ff ff       	jmp    105160 <alltraps>

0010584b <vector65>:
.globl vector65
vector65:
  pushl $0
  10584b:	6a 00                	push   $0x0
  pushl $65
  10584d:	6a 41                	push   $0x41
  jmp alltraps
  10584f:	e9 0c f9 ff ff       	jmp    105160 <alltraps>

00105854 <vector66>:
.globl vector66
vector66:
  pushl $0
  105854:	6a 00                	push   $0x0
  pushl $66
  105856:	6a 42                	push   $0x42
  jmp alltraps
  105858:	e9 03 f9 ff ff       	jmp    105160 <alltraps>

0010585d <vector67>:
.globl vector67
vector67:
  pushl $0
  10585d:	6a 00                	push   $0x0
  pushl $67
  10585f:	6a 43                	push   $0x43
  jmp alltraps
  105861:	e9 fa f8 ff ff       	jmp    105160 <alltraps>

00105866 <vector68>:
.globl vector68
vector68:
  pushl $0
  105866:	6a 00                	push   $0x0
  pushl $68
  105868:	6a 44                	push   $0x44
  jmp alltraps
  10586a:	e9 f1 f8 ff ff       	jmp    105160 <alltraps>

0010586f <vector69>:
.globl vector69
vector69:
  pushl $0
  10586f:	6a 00                	push   $0x0
  pushl $69
  105871:	6a 45                	push   $0x45
  jmp alltraps
  105873:	e9 e8 f8 ff ff       	jmp    105160 <alltraps>

00105878 <vector70>:
.globl vector70
vector70:
  pushl $0
  105878:	6a 00                	push   $0x0
  pushl $70
  10587a:	6a 46                	push   $0x46
  jmp alltraps
  10587c:	e9 df f8 ff ff       	jmp    105160 <alltraps>

00105881 <vector71>:
.globl vector71
vector71:
  pushl $0
  105881:	6a 00                	push   $0x0
  pushl $71
  105883:	6a 47                	push   $0x47
  jmp alltraps
  105885:	e9 d6 f8 ff ff       	jmp    105160 <alltraps>

0010588a <vector72>:
.globl vector72
vector72:
  pushl $0
  10588a:	6a 00                	push   $0x0
  pushl $72
  10588c:	6a 48                	push   $0x48
  jmp alltraps
  10588e:	e9 cd f8 ff ff       	jmp    105160 <alltraps>

00105893 <vector73>:
.globl vector73
vector73:
  pushl $0
  105893:	6a 00                	push   $0x0
  pushl $73
  105895:	6a 49                	push   $0x49
  jmp alltraps
  105897:	e9 c4 f8 ff ff       	jmp    105160 <alltraps>

0010589c <vector74>:
.globl vector74
vector74:
  pushl $0
  10589c:	6a 00                	push   $0x0
  pushl $74
  10589e:	6a 4a                	push   $0x4a
  jmp alltraps
  1058a0:	e9 bb f8 ff ff       	jmp    105160 <alltraps>

001058a5 <vector75>:
.globl vector75
vector75:
  pushl $0
  1058a5:	6a 00                	push   $0x0
  pushl $75
  1058a7:	6a 4b                	push   $0x4b
  jmp alltraps
  1058a9:	e9 b2 f8 ff ff       	jmp    105160 <alltraps>

001058ae <vector76>:
.globl vector76
vector76:
  pushl $0
  1058ae:	6a 00                	push   $0x0
  pushl $76
  1058b0:	6a 4c                	push   $0x4c
  jmp alltraps
  1058b2:	e9 a9 f8 ff ff       	jmp    105160 <alltraps>

001058b7 <vector77>:
.globl vector77
vector77:
  pushl $0
  1058b7:	6a 00                	push   $0x0
  pushl $77
  1058b9:	6a 4d                	push   $0x4d
  jmp alltraps
  1058bb:	e9 a0 f8 ff ff       	jmp    105160 <alltraps>

001058c0 <vector78>:
.globl vector78
vector78:
  pushl $0
  1058c0:	6a 00                	push   $0x0
  pushl $78
  1058c2:	6a 4e                	push   $0x4e
  jmp alltraps
  1058c4:	e9 97 f8 ff ff       	jmp    105160 <alltraps>

001058c9 <vector79>:
.globl vector79
vector79:
  pushl $0
  1058c9:	6a 00                	push   $0x0
  pushl $79
  1058cb:	6a 4f                	push   $0x4f
  jmp alltraps
  1058cd:	e9 8e f8 ff ff       	jmp    105160 <alltraps>

001058d2 <vector80>:
.globl vector80
vector80:
  pushl $0
  1058d2:	6a 00                	push   $0x0
  pushl $80
  1058d4:	6a 50                	push   $0x50
  jmp alltraps
  1058d6:	e9 85 f8 ff ff       	jmp    105160 <alltraps>

001058db <vector81>:
.globl vector81
vector81:
  pushl $0
  1058db:	6a 00                	push   $0x0
  pushl $81
  1058dd:	6a 51                	push   $0x51
  jmp alltraps
  1058df:	e9 7c f8 ff ff       	jmp    105160 <alltraps>

001058e4 <vector82>:
.globl vector82
vector82:
  pushl $0
  1058e4:	6a 00                	push   $0x0
  pushl $82
  1058e6:	6a 52                	push   $0x52
  jmp alltraps
  1058e8:	e9 73 f8 ff ff       	jmp    105160 <alltraps>

001058ed <vector83>:
.globl vector83
vector83:
  pushl $0
  1058ed:	6a 00                	push   $0x0
  pushl $83
  1058ef:	6a 53                	push   $0x53
  jmp alltraps
  1058f1:	e9 6a f8 ff ff       	jmp    105160 <alltraps>

001058f6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1058f6:	6a 00                	push   $0x0
  pushl $84
  1058f8:	6a 54                	push   $0x54
  jmp alltraps
  1058fa:	e9 61 f8 ff ff       	jmp    105160 <alltraps>

001058ff <vector85>:
.globl vector85
vector85:
  pushl $0
  1058ff:	6a 00                	push   $0x0
  pushl $85
  105901:	6a 55                	push   $0x55
  jmp alltraps
  105903:	e9 58 f8 ff ff       	jmp    105160 <alltraps>

00105908 <vector86>:
.globl vector86
vector86:
  pushl $0
  105908:	6a 00                	push   $0x0
  pushl $86
  10590a:	6a 56                	push   $0x56
  jmp alltraps
  10590c:	e9 4f f8 ff ff       	jmp    105160 <alltraps>

00105911 <vector87>:
.globl vector87
vector87:
  pushl $0
  105911:	6a 00                	push   $0x0
  pushl $87
  105913:	6a 57                	push   $0x57
  jmp alltraps
  105915:	e9 46 f8 ff ff       	jmp    105160 <alltraps>

0010591a <vector88>:
.globl vector88
vector88:
  pushl $0
  10591a:	6a 00                	push   $0x0
  pushl $88
  10591c:	6a 58                	push   $0x58
  jmp alltraps
  10591e:	e9 3d f8 ff ff       	jmp    105160 <alltraps>

00105923 <vector89>:
.globl vector89
vector89:
  pushl $0
  105923:	6a 00                	push   $0x0
  pushl $89
  105925:	6a 59                	push   $0x59
  jmp alltraps
  105927:	e9 34 f8 ff ff       	jmp    105160 <alltraps>

0010592c <vector90>:
.globl vector90
vector90:
  pushl $0
  10592c:	6a 00                	push   $0x0
  pushl $90
  10592e:	6a 5a                	push   $0x5a
  jmp alltraps
  105930:	e9 2b f8 ff ff       	jmp    105160 <alltraps>

00105935 <vector91>:
.globl vector91
vector91:
  pushl $0
  105935:	6a 00                	push   $0x0
  pushl $91
  105937:	6a 5b                	push   $0x5b
  jmp alltraps
  105939:	e9 22 f8 ff ff       	jmp    105160 <alltraps>

0010593e <vector92>:
.globl vector92
vector92:
  pushl $0
  10593e:	6a 00                	push   $0x0
  pushl $92
  105940:	6a 5c                	push   $0x5c
  jmp alltraps
  105942:	e9 19 f8 ff ff       	jmp    105160 <alltraps>

00105947 <vector93>:
.globl vector93
vector93:
  pushl $0
  105947:	6a 00                	push   $0x0
  pushl $93
  105949:	6a 5d                	push   $0x5d
  jmp alltraps
  10594b:	e9 10 f8 ff ff       	jmp    105160 <alltraps>

00105950 <vector94>:
.globl vector94
vector94:
  pushl $0
  105950:	6a 00                	push   $0x0
  pushl $94
  105952:	6a 5e                	push   $0x5e
  jmp alltraps
  105954:	e9 07 f8 ff ff       	jmp    105160 <alltraps>

00105959 <vector95>:
.globl vector95
vector95:
  pushl $0
  105959:	6a 00                	push   $0x0
  pushl $95
  10595b:	6a 5f                	push   $0x5f
  jmp alltraps
  10595d:	e9 fe f7 ff ff       	jmp    105160 <alltraps>

00105962 <vector96>:
.globl vector96
vector96:
  pushl $0
  105962:	6a 00                	push   $0x0
  pushl $96
  105964:	6a 60                	push   $0x60
  jmp alltraps
  105966:	e9 f5 f7 ff ff       	jmp    105160 <alltraps>

0010596b <vector97>:
.globl vector97
vector97:
  pushl $0
  10596b:	6a 00                	push   $0x0
  pushl $97
  10596d:	6a 61                	push   $0x61
  jmp alltraps
  10596f:	e9 ec f7 ff ff       	jmp    105160 <alltraps>

00105974 <vector98>:
.globl vector98
vector98:
  pushl $0
  105974:	6a 00                	push   $0x0
  pushl $98
  105976:	6a 62                	push   $0x62
  jmp alltraps
  105978:	e9 e3 f7 ff ff       	jmp    105160 <alltraps>

0010597d <vector99>:
.globl vector99
vector99:
  pushl $0
  10597d:	6a 00                	push   $0x0
  pushl $99
  10597f:	6a 63                	push   $0x63
  jmp alltraps
  105981:	e9 da f7 ff ff       	jmp    105160 <alltraps>

00105986 <vector100>:
.globl vector100
vector100:
  pushl $0
  105986:	6a 00                	push   $0x0
  pushl $100
  105988:	6a 64                	push   $0x64
  jmp alltraps
  10598a:	e9 d1 f7 ff ff       	jmp    105160 <alltraps>

0010598f <vector101>:
.globl vector101
vector101:
  pushl $0
  10598f:	6a 00                	push   $0x0
  pushl $101
  105991:	6a 65                	push   $0x65
  jmp alltraps
  105993:	e9 c8 f7 ff ff       	jmp    105160 <alltraps>

00105998 <vector102>:
.globl vector102
vector102:
  pushl $0
  105998:	6a 00                	push   $0x0
  pushl $102
  10599a:	6a 66                	push   $0x66
  jmp alltraps
  10599c:	e9 bf f7 ff ff       	jmp    105160 <alltraps>

001059a1 <vector103>:
.globl vector103
vector103:
  pushl $0
  1059a1:	6a 00                	push   $0x0
  pushl $103
  1059a3:	6a 67                	push   $0x67
  jmp alltraps
  1059a5:	e9 b6 f7 ff ff       	jmp    105160 <alltraps>

001059aa <vector104>:
.globl vector104
vector104:
  pushl $0
  1059aa:	6a 00                	push   $0x0
  pushl $104
  1059ac:	6a 68                	push   $0x68
  jmp alltraps
  1059ae:	e9 ad f7 ff ff       	jmp    105160 <alltraps>

001059b3 <vector105>:
.globl vector105
vector105:
  pushl $0
  1059b3:	6a 00                	push   $0x0
  pushl $105
  1059b5:	6a 69                	push   $0x69
  jmp alltraps
  1059b7:	e9 a4 f7 ff ff       	jmp    105160 <alltraps>

001059bc <vector106>:
.globl vector106
vector106:
  pushl $0
  1059bc:	6a 00                	push   $0x0
  pushl $106
  1059be:	6a 6a                	push   $0x6a
  jmp alltraps
  1059c0:	e9 9b f7 ff ff       	jmp    105160 <alltraps>

001059c5 <vector107>:
.globl vector107
vector107:
  pushl $0
  1059c5:	6a 00                	push   $0x0
  pushl $107
  1059c7:	6a 6b                	push   $0x6b
  jmp alltraps
  1059c9:	e9 92 f7 ff ff       	jmp    105160 <alltraps>

001059ce <vector108>:
.globl vector108
vector108:
  pushl $0
  1059ce:	6a 00                	push   $0x0
  pushl $108
  1059d0:	6a 6c                	push   $0x6c
  jmp alltraps
  1059d2:	e9 89 f7 ff ff       	jmp    105160 <alltraps>

001059d7 <vector109>:
.globl vector109
vector109:
  pushl $0
  1059d7:	6a 00                	push   $0x0
  pushl $109
  1059d9:	6a 6d                	push   $0x6d
  jmp alltraps
  1059db:	e9 80 f7 ff ff       	jmp    105160 <alltraps>

001059e0 <vector110>:
.globl vector110
vector110:
  pushl $0
  1059e0:	6a 00                	push   $0x0
  pushl $110
  1059e2:	6a 6e                	push   $0x6e
  jmp alltraps
  1059e4:	e9 77 f7 ff ff       	jmp    105160 <alltraps>

001059e9 <vector111>:
.globl vector111
vector111:
  pushl $0
  1059e9:	6a 00                	push   $0x0
  pushl $111
  1059eb:	6a 6f                	push   $0x6f
  jmp alltraps
  1059ed:	e9 6e f7 ff ff       	jmp    105160 <alltraps>

001059f2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1059f2:	6a 00                	push   $0x0
  pushl $112
  1059f4:	6a 70                	push   $0x70
  jmp alltraps
  1059f6:	e9 65 f7 ff ff       	jmp    105160 <alltraps>

001059fb <vector113>:
.globl vector113
vector113:
  pushl $0
  1059fb:	6a 00                	push   $0x0
  pushl $113
  1059fd:	6a 71                	push   $0x71
  jmp alltraps
  1059ff:	e9 5c f7 ff ff       	jmp    105160 <alltraps>

00105a04 <vector114>:
.globl vector114
vector114:
  pushl $0
  105a04:	6a 00                	push   $0x0
  pushl $114
  105a06:	6a 72                	push   $0x72
  jmp alltraps
  105a08:	e9 53 f7 ff ff       	jmp    105160 <alltraps>

00105a0d <vector115>:
.globl vector115
vector115:
  pushl $0
  105a0d:	6a 00                	push   $0x0
  pushl $115
  105a0f:	6a 73                	push   $0x73
  jmp alltraps
  105a11:	e9 4a f7 ff ff       	jmp    105160 <alltraps>

00105a16 <vector116>:
.globl vector116
vector116:
  pushl $0
  105a16:	6a 00                	push   $0x0
  pushl $116
  105a18:	6a 74                	push   $0x74
  jmp alltraps
  105a1a:	e9 41 f7 ff ff       	jmp    105160 <alltraps>

00105a1f <vector117>:
.globl vector117
vector117:
  pushl $0
  105a1f:	6a 00                	push   $0x0
  pushl $117
  105a21:	6a 75                	push   $0x75
  jmp alltraps
  105a23:	e9 38 f7 ff ff       	jmp    105160 <alltraps>

00105a28 <vector118>:
.globl vector118
vector118:
  pushl $0
  105a28:	6a 00                	push   $0x0
  pushl $118
  105a2a:	6a 76                	push   $0x76
  jmp alltraps
  105a2c:	e9 2f f7 ff ff       	jmp    105160 <alltraps>

00105a31 <vector119>:
.globl vector119
vector119:
  pushl $0
  105a31:	6a 00                	push   $0x0
  pushl $119
  105a33:	6a 77                	push   $0x77
  jmp alltraps
  105a35:	e9 26 f7 ff ff       	jmp    105160 <alltraps>

00105a3a <vector120>:
.globl vector120
vector120:
  pushl $0
  105a3a:	6a 00                	push   $0x0
  pushl $120
  105a3c:	6a 78                	push   $0x78
  jmp alltraps
  105a3e:	e9 1d f7 ff ff       	jmp    105160 <alltraps>

00105a43 <vector121>:
.globl vector121
vector121:
  pushl $0
  105a43:	6a 00                	push   $0x0
  pushl $121
  105a45:	6a 79                	push   $0x79
  jmp alltraps
  105a47:	e9 14 f7 ff ff       	jmp    105160 <alltraps>

00105a4c <vector122>:
.globl vector122
vector122:
  pushl $0
  105a4c:	6a 00                	push   $0x0
  pushl $122
  105a4e:	6a 7a                	push   $0x7a
  jmp alltraps
  105a50:	e9 0b f7 ff ff       	jmp    105160 <alltraps>

00105a55 <vector123>:
.globl vector123
vector123:
  pushl $0
  105a55:	6a 00                	push   $0x0
  pushl $123
  105a57:	6a 7b                	push   $0x7b
  jmp alltraps
  105a59:	e9 02 f7 ff ff       	jmp    105160 <alltraps>

00105a5e <vector124>:
.globl vector124
vector124:
  pushl $0
  105a5e:	6a 00                	push   $0x0
  pushl $124
  105a60:	6a 7c                	push   $0x7c
  jmp alltraps
  105a62:	e9 f9 f6 ff ff       	jmp    105160 <alltraps>

00105a67 <vector125>:
.globl vector125
vector125:
  pushl $0
  105a67:	6a 00                	push   $0x0
  pushl $125
  105a69:	6a 7d                	push   $0x7d
  jmp alltraps
  105a6b:	e9 f0 f6 ff ff       	jmp    105160 <alltraps>

00105a70 <vector126>:
.globl vector126
vector126:
  pushl $0
  105a70:	6a 00                	push   $0x0
  pushl $126
  105a72:	6a 7e                	push   $0x7e
  jmp alltraps
  105a74:	e9 e7 f6 ff ff       	jmp    105160 <alltraps>

00105a79 <vector127>:
.globl vector127
vector127:
  pushl $0
  105a79:	6a 00                	push   $0x0
  pushl $127
  105a7b:	6a 7f                	push   $0x7f
  jmp alltraps
  105a7d:	e9 de f6 ff ff       	jmp    105160 <alltraps>

00105a82 <vector128>:
.globl vector128
vector128:
  pushl $0
  105a82:	6a 00                	push   $0x0
  pushl $128
  105a84:	68 80 00 00 00       	push   $0x80
  jmp alltraps
  105a89:	e9 d2 f6 ff ff       	jmp    105160 <alltraps>

00105a8e <vector129>:
.globl vector129
vector129:
  pushl $0
  105a8e:	6a 00                	push   $0x0
  pushl $129
  105a90:	68 81 00 00 00       	push   $0x81
  jmp alltraps
  105a95:	e9 c6 f6 ff ff       	jmp    105160 <alltraps>

00105a9a <vector130>:
.globl vector130
vector130:
  pushl $0
  105a9a:	6a 00                	push   $0x0
  pushl $130
  105a9c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
  105aa1:	e9 ba f6 ff ff       	jmp    105160 <alltraps>

00105aa6 <vector131>:
.globl vector131
vector131:
  pushl $0
  105aa6:	6a 00                	push   $0x0
  pushl $131
  105aa8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
  105aad:	e9 ae f6 ff ff       	jmp    105160 <alltraps>

00105ab2 <vector132>:
.globl vector132
vector132:
  pushl $0
  105ab2:	6a 00                	push   $0x0
  pushl $132
  105ab4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
  105ab9:	e9 a2 f6 ff ff       	jmp    105160 <alltraps>

00105abe <vector133>:
.globl vector133
vector133:
  pushl $0
  105abe:	6a 00                	push   $0x0
  pushl $133
  105ac0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
  105ac5:	e9 96 f6 ff ff       	jmp    105160 <alltraps>

00105aca <vector134>:
.globl vector134
vector134:
  pushl $0
  105aca:	6a 00                	push   $0x0
  pushl $134
  105acc:	68 86 00 00 00       	push   $0x86
  jmp alltraps
  105ad1:	e9 8a f6 ff ff       	jmp    105160 <alltraps>

00105ad6 <vector135>:
.globl vector135
vector135:
  pushl $0
  105ad6:	6a 00                	push   $0x0
  pushl $135
  105ad8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
  105add:	e9 7e f6 ff ff       	jmp    105160 <alltraps>

00105ae2 <vector136>:
.globl vector136
vector136:
  pushl $0
  105ae2:	6a 00                	push   $0x0
  pushl $136
  105ae4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
  105ae9:	e9 72 f6 ff ff       	jmp    105160 <alltraps>

00105aee <vector137>:
.globl vector137
vector137:
  pushl $0
  105aee:	6a 00                	push   $0x0
  pushl $137
  105af0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
  105af5:	e9 66 f6 ff ff       	jmp    105160 <alltraps>

00105afa <vector138>:
.globl vector138
vector138:
  pushl $0
  105afa:	6a 00                	push   $0x0
  pushl $138
  105afc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
  105b01:	e9 5a f6 ff ff       	jmp    105160 <alltraps>

00105b06 <vector139>:
.globl vector139
vector139:
  pushl $0
  105b06:	6a 00                	push   $0x0
  pushl $139
  105b08:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
  105b0d:	e9 4e f6 ff ff       	jmp    105160 <alltraps>

00105b12 <vector140>:
.globl vector140
vector140:
  pushl $0
  105b12:	6a 00                	push   $0x0
  pushl $140
  105b14:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
  105b19:	e9 42 f6 ff ff       	jmp    105160 <alltraps>

00105b1e <vector141>:
.globl vector141
vector141:
  pushl $0
  105b1e:	6a 00                	push   $0x0
  pushl $141
  105b20:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
  105b25:	e9 36 f6 ff ff       	jmp    105160 <alltraps>

00105b2a <vector142>:
.globl vector142
vector142:
  pushl $0
  105b2a:	6a 00                	push   $0x0
  pushl $142
  105b2c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
  105b31:	e9 2a f6 ff ff       	jmp    105160 <alltraps>

00105b36 <vector143>:
.globl vector143
vector143:
  pushl $0
  105b36:	6a 00                	push   $0x0
  pushl $143
  105b38:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
  105b3d:	e9 1e f6 ff ff       	jmp    105160 <alltraps>

00105b42 <vector144>:
.globl vector144
vector144:
  pushl $0
  105b42:	6a 00                	push   $0x0
  pushl $144
  105b44:	68 90 00 00 00       	push   $0x90
  jmp alltraps
  105b49:	e9 12 f6 ff ff       	jmp    105160 <alltraps>

00105b4e <vector145>:
.globl vector145
vector145:
  pushl $0
  105b4e:	6a 00                	push   $0x0
  pushl $145
  105b50:	68 91 00 00 00       	push   $0x91
  jmp alltraps
  105b55:	e9 06 f6 ff ff       	jmp    105160 <alltraps>

00105b5a <vector146>:
.globl vector146
vector146:
  pushl $0
  105b5a:	6a 00                	push   $0x0
  pushl $146
  105b5c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
  105b61:	e9 fa f5 ff ff       	jmp    105160 <alltraps>

00105b66 <vector147>:
.globl vector147
vector147:
  pushl $0
  105b66:	6a 00                	push   $0x0
  pushl $147
  105b68:	68 93 00 00 00       	push   $0x93
  jmp alltraps
  105b6d:	e9 ee f5 ff ff       	jmp    105160 <alltraps>

00105b72 <vector148>:
.globl vector148
vector148:
  pushl $0
  105b72:	6a 00                	push   $0x0
  pushl $148
  105b74:	68 94 00 00 00       	push   $0x94
  jmp alltraps
  105b79:	e9 e2 f5 ff ff       	jmp    105160 <alltraps>

00105b7e <vector149>:
.globl vector149
vector149:
  pushl $0
  105b7e:	6a 00                	push   $0x0
  pushl $149
  105b80:	68 95 00 00 00       	push   $0x95
  jmp alltraps
  105b85:	e9 d6 f5 ff ff       	jmp    105160 <alltraps>

00105b8a <vector150>:
.globl vector150
vector150:
  pushl $0
  105b8a:	6a 00                	push   $0x0
  pushl $150
  105b8c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
  105b91:	e9 ca f5 ff ff       	jmp    105160 <alltraps>

00105b96 <vector151>:
.globl vector151
vector151:
  pushl $0
  105b96:	6a 00                	push   $0x0
  pushl $151
  105b98:	68 97 00 00 00       	push   $0x97
  jmp alltraps
  105b9d:	e9 be f5 ff ff       	jmp    105160 <alltraps>

00105ba2 <vector152>:
.globl vector152
vector152:
  pushl $0
  105ba2:	6a 00                	push   $0x0
  pushl $152
  105ba4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
  105ba9:	e9 b2 f5 ff ff       	jmp    105160 <alltraps>

00105bae <vector153>:
.globl vector153
vector153:
  pushl $0
  105bae:	6a 00                	push   $0x0
  pushl $153
  105bb0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
  105bb5:	e9 a6 f5 ff ff       	jmp    105160 <alltraps>

00105bba <vector154>:
.globl vector154
vector154:
  pushl $0
  105bba:	6a 00                	push   $0x0
  pushl $154
  105bbc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
  105bc1:	e9 9a f5 ff ff       	jmp    105160 <alltraps>

00105bc6 <vector155>:
.globl vector155
vector155:
  pushl $0
  105bc6:	6a 00                	push   $0x0
  pushl $155
  105bc8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
  105bcd:	e9 8e f5 ff ff       	jmp    105160 <alltraps>

00105bd2 <vector156>:
.globl vector156
vector156:
  pushl $0
  105bd2:	6a 00                	push   $0x0
  pushl $156
  105bd4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
  105bd9:	e9 82 f5 ff ff       	jmp    105160 <alltraps>

00105bde <vector157>:
.globl vector157
vector157:
  pushl $0
  105bde:	6a 00                	push   $0x0
  pushl $157
  105be0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
  105be5:	e9 76 f5 ff ff       	jmp    105160 <alltraps>

00105bea <vector158>:
.globl vector158
vector158:
  pushl $0
  105bea:	6a 00                	push   $0x0
  pushl $158
  105bec:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
  105bf1:	e9 6a f5 ff ff       	jmp    105160 <alltraps>

00105bf6 <vector159>:
.globl vector159
vector159:
  pushl $0
  105bf6:	6a 00                	push   $0x0
  pushl $159
  105bf8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
  105bfd:	e9 5e f5 ff ff       	jmp    105160 <alltraps>

00105c02 <vector160>:
.globl vector160
vector160:
  pushl $0
  105c02:	6a 00                	push   $0x0
  pushl $160
  105c04:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
  105c09:	e9 52 f5 ff ff       	jmp    105160 <alltraps>

00105c0e <vector161>:
.globl vector161
vector161:
  pushl $0
  105c0e:	6a 00                	push   $0x0
  pushl $161
  105c10:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
  105c15:	e9 46 f5 ff ff       	jmp    105160 <alltraps>

00105c1a <vector162>:
.globl vector162
vector162:
  pushl $0
  105c1a:	6a 00                	push   $0x0
  pushl $162
  105c1c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
  105c21:	e9 3a f5 ff ff       	jmp    105160 <alltraps>

00105c26 <vector163>:
.globl vector163
vector163:
  pushl $0
  105c26:	6a 00                	push   $0x0
  pushl $163
  105c28:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
  105c2d:	e9 2e f5 ff ff       	jmp    105160 <alltraps>

00105c32 <vector164>:
.globl vector164
vector164:
  pushl $0
  105c32:	6a 00                	push   $0x0
  pushl $164
  105c34:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
  105c39:	e9 22 f5 ff ff       	jmp    105160 <alltraps>

00105c3e <vector165>:
.globl vector165
vector165:
  pushl $0
  105c3e:	6a 00                	push   $0x0
  pushl $165
  105c40:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
  105c45:	e9 16 f5 ff ff       	jmp    105160 <alltraps>

00105c4a <vector166>:
.globl vector166
vector166:
  pushl $0
  105c4a:	6a 00                	push   $0x0
  pushl $166
  105c4c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
  105c51:	e9 0a f5 ff ff       	jmp    105160 <alltraps>

00105c56 <vector167>:
.globl vector167
vector167:
  pushl $0
  105c56:	6a 00                	push   $0x0
  pushl $167
  105c58:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
  105c5d:	e9 fe f4 ff ff       	jmp    105160 <alltraps>

00105c62 <vector168>:
.globl vector168
vector168:
  pushl $0
  105c62:	6a 00                	push   $0x0
  pushl $168
  105c64:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
  105c69:	e9 f2 f4 ff ff       	jmp    105160 <alltraps>

00105c6e <vector169>:
.globl vector169
vector169:
  pushl $0
  105c6e:	6a 00                	push   $0x0
  pushl $169
  105c70:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
  105c75:	e9 e6 f4 ff ff       	jmp    105160 <alltraps>

00105c7a <vector170>:
.globl vector170
vector170:
  pushl $0
  105c7a:	6a 00                	push   $0x0
  pushl $170
  105c7c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
  105c81:	e9 da f4 ff ff       	jmp    105160 <alltraps>

00105c86 <vector171>:
.globl vector171
vector171:
  pushl $0
  105c86:	6a 00                	push   $0x0
  pushl $171
  105c88:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
  105c8d:	e9 ce f4 ff ff       	jmp    105160 <alltraps>

00105c92 <vector172>:
.globl vector172
vector172:
  pushl $0
  105c92:	6a 00                	push   $0x0
  pushl $172
  105c94:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
  105c99:	e9 c2 f4 ff ff       	jmp    105160 <alltraps>

00105c9e <vector173>:
.globl vector173
vector173:
  pushl $0
  105c9e:	6a 00                	push   $0x0
  pushl $173
  105ca0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
  105ca5:	e9 b6 f4 ff ff       	jmp    105160 <alltraps>

00105caa <vector174>:
.globl vector174
vector174:
  pushl $0
  105caa:	6a 00                	push   $0x0
  pushl $174
  105cac:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
  105cb1:	e9 aa f4 ff ff       	jmp    105160 <alltraps>

00105cb6 <vector175>:
.globl vector175
vector175:
  pushl $0
  105cb6:	6a 00                	push   $0x0
  pushl $175
  105cb8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
  105cbd:	e9 9e f4 ff ff       	jmp    105160 <alltraps>

00105cc2 <vector176>:
.globl vector176
vector176:
  pushl $0
  105cc2:	6a 00                	push   $0x0
  pushl $176
  105cc4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
  105cc9:	e9 92 f4 ff ff       	jmp    105160 <alltraps>

00105cce <vector177>:
.globl vector177
vector177:
  pushl $0
  105cce:	6a 00                	push   $0x0
  pushl $177
  105cd0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
  105cd5:	e9 86 f4 ff ff       	jmp    105160 <alltraps>

00105cda <vector178>:
.globl vector178
vector178:
  pushl $0
  105cda:	6a 00                	push   $0x0
  pushl $178
  105cdc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
  105ce1:	e9 7a f4 ff ff       	jmp    105160 <alltraps>

00105ce6 <vector179>:
.globl vector179
vector179:
  pushl $0
  105ce6:	6a 00                	push   $0x0
  pushl $179
  105ce8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
  105ced:	e9 6e f4 ff ff       	jmp    105160 <alltraps>

00105cf2 <vector180>:
.globl vector180
vector180:
  pushl $0
  105cf2:	6a 00                	push   $0x0
  pushl $180
  105cf4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
  105cf9:	e9 62 f4 ff ff       	jmp    105160 <alltraps>

00105cfe <vector181>:
.globl vector181
vector181:
  pushl $0
  105cfe:	6a 00                	push   $0x0
  pushl $181
  105d00:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
  105d05:	e9 56 f4 ff ff       	jmp    105160 <alltraps>

00105d0a <vector182>:
.globl vector182
vector182:
  pushl $0
  105d0a:	6a 00                	push   $0x0
  pushl $182
  105d0c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
  105d11:	e9 4a f4 ff ff       	jmp    105160 <alltraps>

00105d16 <vector183>:
.globl vector183
vector183:
  pushl $0
  105d16:	6a 00                	push   $0x0
  pushl $183
  105d18:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
  105d1d:	e9 3e f4 ff ff       	jmp    105160 <alltraps>

00105d22 <vector184>:
.globl vector184
vector184:
  pushl $0
  105d22:	6a 00                	push   $0x0
  pushl $184
  105d24:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
  105d29:	e9 32 f4 ff ff       	jmp    105160 <alltraps>

00105d2e <vector185>:
.globl vector185
vector185:
  pushl $0
  105d2e:	6a 00                	push   $0x0
  pushl $185
  105d30:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
  105d35:	e9 26 f4 ff ff       	jmp    105160 <alltraps>

00105d3a <vector186>:
.globl vector186
vector186:
  pushl $0
  105d3a:	6a 00                	push   $0x0
  pushl $186
  105d3c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
  105d41:	e9 1a f4 ff ff       	jmp    105160 <alltraps>

00105d46 <vector187>:
.globl vector187
vector187:
  pushl $0
  105d46:	6a 00                	push   $0x0
  pushl $187
  105d48:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
  105d4d:	e9 0e f4 ff ff       	jmp    105160 <alltraps>

00105d52 <vector188>:
.globl vector188
vector188:
  pushl $0
  105d52:	6a 00                	push   $0x0
  pushl $188
  105d54:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
  105d59:	e9 02 f4 ff ff       	jmp    105160 <alltraps>

00105d5e <vector189>:
.globl vector189
vector189:
  pushl $0
  105d5e:	6a 00                	push   $0x0
  pushl $189
  105d60:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
  105d65:	e9 f6 f3 ff ff       	jmp    105160 <alltraps>

00105d6a <vector190>:
.globl vector190
vector190:
  pushl $0
  105d6a:	6a 00                	push   $0x0
  pushl $190
  105d6c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
  105d71:	e9 ea f3 ff ff       	jmp    105160 <alltraps>

00105d76 <vector191>:
.globl vector191
vector191:
  pushl $0
  105d76:	6a 00                	push   $0x0
  pushl $191
  105d78:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
  105d7d:	e9 de f3 ff ff       	jmp    105160 <alltraps>

00105d82 <vector192>:
.globl vector192
vector192:
  pushl $0
  105d82:	6a 00                	push   $0x0
  pushl $192
  105d84:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
  105d89:	e9 d2 f3 ff ff       	jmp    105160 <alltraps>

00105d8e <vector193>:
.globl vector193
vector193:
  pushl $0
  105d8e:	6a 00                	push   $0x0
  pushl $193
  105d90:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
  105d95:	e9 c6 f3 ff ff       	jmp    105160 <alltraps>

00105d9a <vector194>:
.globl vector194
vector194:
  pushl $0
  105d9a:	6a 00                	push   $0x0
  pushl $194
  105d9c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
  105da1:	e9 ba f3 ff ff       	jmp    105160 <alltraps>

00105da6 <vector195>:
.globl vector195
vector195:
  pushl $0
  105da6:	6a 00                	push   $0x0
  pushl $195
  105da8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
  105dad:	e9 ae f3 ff ff       	jmp    105160 <alltraps>

00105db2 <vector196>:
.globl vector196
vector196:
  pushl $0
  105db2:	6a 00                	push   $0x0
  pushl $196
  105db4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
  105db9:	e9 a2 f3 ff ff       	jmp    105160 <alltraps>

00105dbe <vector197>:
.globl vector197
vector197:
  pushl $0
  105dbe:	6a 00                	push   $0x0
  pushl $197
  105dc0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
  105dc5:	e9 96 f3 ff ff       	jmp    105160 <alltraps>

00105dca <vector198>:
.globl vector198
vector198:
  pushl $0
  105dca:	6a 00                	push   $0x0
  pushl $198
  105dcc:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
  105dd1:	e9 8a f3 ff ff       	jmp    105160 <alltraps>

00105dd6 <vector199>:
.globl vector199
vector199:
  pushl $0
  105dd6:	6a 00                	push   $0x0
  pushl $199
  105dd8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
  105ddd:	e9 7e f3 ff ff       	jmp    105160 <alltraps>

00105de2 <vector200>:
.globl vector200
vector200:
  pushl $0
  105de2:	6a 00                	push   $0x0
  pushl $200
  105de4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
  105de9:	e9 72 f3 ff ff       	jmp    105160 <alltraps>

00105dee <vector201>:
.globl vector201
vector201:
  pushl $0
  105dee:	6a 00                	push   $0x0
  pushl $201
  105df0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
  105df5:	e9 66 f3 ff ff       	jmp    105160 <alltraps>

00105dfa <vector202>:
.globl vector202
vector202:
  pushl $0
  105dfa:	6a 00                	push   $0x0
  pushl $202
  105dfc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
  105e01:	e9 5a f3 ff ff       	jmp    105160 <alltraps>

00105e06 <vector203>:
.globl vector203
vector203:
  pushl $0
  105e06:	6a 00                	push   $0x0
  pushl $203
  105e08:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
  105e0d:	e9 4e f3 ff ff       	jmp    105160 <alltraps>

00105e12 <vector204>:
.globl vector204
vector204:
  pushl $0
  105e12:	6a 00                	push   $0x0
  pushl $204
  105e14:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
  105e19:	e9 42 f3 ff ff       	jmp    105160 <alltraps>

00105e1e <vector205>:
.globl vector205
vector205:
  pushl $0
  105e1e:	6a 00                	push   $0x0
  pushl $205
  105e20:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
  105e25:	e9 36 f3 ff ff       	jmp    105160 <alltraps>

00105e2a <vector206>:
.globl vector206
vector206:
  pushl $0
  105e2a:	6a 00                	push   $0x0
  pushl $206
  105e2c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
  105e31:	e9 2a f3 ff ff       	jmp    105160 <alltraps>

00105e36 <vector207>:
.globl vector207
vector207:
  pushl $0
  105e36:	6a 00                	push   $0x0
  pushl $207
  105e38:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
  105e3d:	e9 1e f3 ff ff       	jmp    105160 <alltraps>

00105e42 <vector208>:
.globl vector208
vector208:
  pushl $0
  105e42:	6a 00                	push   $0x0
  pushl $208
  105e44:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
  105e49:	e9 12 f3 ff ff       	jmp    105160 <alltraps>

00105e4e <vector209>:
.globl vector209
vector209:
  pushl $0
  105e4e:	6a 00                	push   $0x0
  pushl $209
  105e50:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
  105e55:	e9 06 f3 ff ff       	jmp    105160 <alltraps>

00105e5a <vector210>:
.globl vector210
vector210:
  pushl $0
  105e5a:	6a 00                	push   $0x0
  pushl $210
  105e5c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
  105e61:	e9 fa f2 ff ff       	jmp    105160 <alltraps>

00105e66 <vector211>:
.globl vector211
vector211:
  pushl $0
  105e66:	6a 00                	push   $0x0
  pushl $211
  105e68:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
  105e6d:	e9 ee f2 ff ff       	jmp    105160 <alltraps>

00105e72 <vector212>:
.globl vector212
vector212:
  pushl $0
  105e72:	6a 00                	push   $0x0
  pushl $212
  105e74:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
  105e79:	e9 e2 f2 ff ff       	jmp    105160 <alltraps>

00105e7e <vector213>:
.globl vector213
vector213:
  pushl $0
  105e7e:	6a 00                	push   $0x0
  pushl $213
  105e80:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
  105e85:	e9 d6 f2 ff ff       	jmp    105160 <alltraps>

00105e8a <vector214>:
.globl vector214
vector214:
  pushl $0
  105e8a:	6a 00                	push   $0x0
  pushl $214
  105e8c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
  105e91:	e9 ca f2 ff ff       	jmp    105160 <alltraps>

00105e96 <vector215>:
.globl vector215
vector215:
  pushl $0
  105e96:	6a 00                	push   $0x0
  pushl $215
  105e98:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
  105e9d:	e9 be f2 ff ff       	jmp    105160 <alltraps>

00105ea2 <vector216>:
.globl vector216
vector216:
  pushl $0
  105ea2:	6a 00                	push   $0x0
  pushl $216
  105ea4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
  105ea9:	e9 b2 f2 ff ff       	jmp    105160 <alltraps>

00105eae <vector217>:
.globl vector217
vector217:
  pushl $0
  105eae:	6a 00                	push   $0x0
  pushl $217
  105eb0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
  105eb5:	e9 a6 f2 ff ff       	jmp    105160 <alltraps>

00105eba <vector218>:
.globl vector218
vector218:
  pushl $0
  105eba:	6a 00                	push   $0x0
  pushl $218
  105ebc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
  105ec1:	e9 9a f2 ff ff       	jmp    105160 <alltraps>

00105ec6 <vector219>:
.globl vector219
vector219:
  pushl $0
  105ec6:	6a 00                	push   $0x0
  pushl $219
  105ec8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
  105ecd:	e9 8e f2 ff ff       	jmp    105160 <alltraps>

00105ed2 <vector220>:
.globl vector220
vector220:
  pushl $0
  105ed2:	6a 00                	push   $0x0
  pushl $220
  105ed4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
  105ed9:	e9 82 f2 ff ff       	jmp    105160 <alltraps>

00105ede <vector221>:
.globl vector221
vector221:
  pushl $0
  105ede:	6a 00                	push   $0x0
  pushl $221
  105ee0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
  105ee5:	e9 76 f2 ff ff       	jmp    105160 <alltraps>

00105eea <vector222>:
.globl vector222
vector222:
  pushl $0
  105eea:	6a 00                	push   $0x0
  pushl $222
  105eec:	68 de 00 00 00       	push   $0xde
  jmp alltraps
  105ef1:	e9 6a f2 ff ff       	jmp    105160 <alltraps>

00105ef6 <vector223>:
.globl vector223
vector223:
  pushl $0
  105ef6:	6a 00                	push   $0x0
  pushl $223
  105ef8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
  105efd:	e9 5e f2 ff ff       	jmp    105160 <alltraps>

00105f02 <vector224>:
.globl vector224
vector224:
  pushl $0
  105f02:	6a 00                	push   $0x0
  pushl $224
  105f04:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
  105f09:	e9 52 f2 ff ff       	jmp    105160 <alltraps>

00105f0e <vector225>:
.globl vector225
vector225:
  pushl $0
  105f0e:	6a 00                	push   $0x0
  pushl $225
  105f10:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
  105f15:	e9 46 f2 ff ff       	jmp    105160 <alltraps>

00105f1a <vector226>:
.globl vector226
vector226:
  pushl $0
  105f1a:	6a 00                	push   $0x0
  pushl $226
  105f1c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
  105f21:	e9 3a f2 ff ff       	jmp    105160 <alltraps>

00105f26 <vector227>:
.globl vector227
vector227:
  pushl $0
  105f26:	6a 00                	push   $0x0
  pushl $227
  105f28:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
  105f2d:	e9 2e f2 ff ff       	jmp    105160 <alltraps>

00105f32 <vector228>:
.globl vector228
vector228:
  pushl $0
  105f32:	6a 00                	push   $0x0
  pushl $228
  105f34:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
  105f39:	e9 22 f2 ff ff       	jmp    105160 <alltraps>

00105f3e <vector229>:
.globl vector229
vector229:
  pushl $0
  105f3e:	6a 00                	push   $0x0
  pushl $229
  105f40:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
  105f45:	e9 16 f2 ff ff       	jmp    105160 <alltraps>

00105f4a <vector230>:
.globl vector230
vector230:
  pushl $0
  105f4a:	6a 00                	push   $0x0
  pushl $230
  105f4c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
  105f51:	e9 0a f2 ff ff       	jmp    105160 <alltraps>

00105f56 <vector231>:
.globl vector231
vector231:
  pushl $0
  105f56:	6a 00                	push   $0x0
  pushl $231
  105f58:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
  105f5d:	e9 fe f1 ff ff       	jmp    105160 <alltraps>

00105f62 <vector232>:
.globl vector232
vector232:
  pushl $0
  105f62:	6a 00                	push   $0x0
  pushl $232
  105f64:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
  105f69:	e9 f2 f1 ff ff       	jmp    105160 <alltraps>

00105f6e <vector233>:
.globl vector233
vector233:
  pushl $0
  105f6e:	6a 00                	push   $0x0
  pushl $233
  105f70:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
  105f75:	e9 e6 f1 ff ff       	jmp    105160 <alltraps>

00105f7a <vector234>:
.globl vector234
vector234:
  pushl $0
  105f7a:	6a 00                	push   $0x0
  pushl $234
  105f7c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
  105f81:	e9 da f1 ff ff       	jmp    105160 <alltraps>

00105f86 <vector235>:
.globl vector235
vector235:
  pushl $0
  105f86:	6a 00                	push   $0x0
  pushl $235
  105f88:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
  105f8d:	e9 ce f1 ff ff       	jmp    105160 <alltraps>

00105f92 <vector236>:
.globl vector236
vector236:
  pushl $0
  105f92:	6a 00                	push   $0x0
  pushl $236
  105f94:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
  105f99:	e9 c2 f1 ff ff       	jmp    105160 <alltraps>

00105f9e <vector237>:
.globl vector237
vector237:
  pushl $0
  105f9e:	6a 00                	push   $0x0
  pushl $237
  105fa0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
  105fa5:	e9 b6 f1 ff ff       	jmp    105160 <alltraps>

00105faa <vector238>:
.globl vector238
vector238:
  pushl $0
  105faa:	6a 00                	push   $0x0
  pushl $238
  105fac:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
  105fb1:	e9 aa f1 ff ff       	jmp    105160 <alltraps>

00105fb6 <vector239>:
.globl vector239
vector239:
  pushl $0
  105fb6:	6a 00                	push   $0x0
  pushl $239
  105fb8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
  105fbd:	e9 9e f1 ff ff       	jmp    105160 <alltraps>

00105fc2 <vector240>:
.globl vector240
vector240:
  pushl $0
  105fc2:	6a 00                	push   $0x0
  pushl $240
  105fc4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
  105fc9:	e9 92 f1 ff ff       	jmp    105160 <alltraps>

00105fce <vector241>:
.globl vector241
vector241:
  pushl $0
  105fce:	6a 00                	push   $0x0
  pushl $241
  105fd0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
  105fd5:	e9 86 f1 ff ff       	jmp    105160 <alltraps>

00105fda <vector242>:
.globl vector242
vector242:
  pushl $0
  105fda:	6a 00                	push   $0x0
  pushl $242
  105fdc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
  105fe1:	e9 7a f1 ff ff       	jmp    105160 <alltraps>

00105fe6 <vector243>:
.globl vector243
vector243:
  pushl $0
  105fe6:	6a 00                	push   $0x0
  pushl $243
  105fe8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
  105fed:	e9 6e f1 ff ff       	jmp    105160 <alltraps>

00105ff2 <vector244>:
.globl vector244
vector244:
  pushl $0
  105ff2:	6a 00                	push   $0x0
  pushl $244
  105ff4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
  105ff9:	e9 62 f1 ff ff       	jmp    105160 <alltraps>

00105ffe <vector245>:
.globl vector245
vector245:
  pushl $0
  105ffe:	6a 00                	push   $0x0
  pushl $245
  106000:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
  106005:	e9 56 f1 ff ff       	jmp    105160 <alltraps>

0010600a <vector246>:
.globl vector246
vector246:
  pushl $0
  10600a:	6a 00                	push   $0x0
  pushl $246
  10600c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
  106011:	e9 4a f1 ff ff       	jmp    105160 <alltraps>

00106016 <vector247>:
.globl vector247
vector247:
  pushl $0
  106016:	6a 00                	push   $0x0
  pushl $247
  106018:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
  10601d:	e9 3e f1 ff ff       	jmp    105160 <alltraps>

00106022 <vector248>:
.globl vector248
vector248:
  pushl $0
  106022:	6a 00                	push   $0x0
  pushl $248
  106024:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
  106029:	e9 32 f1 ff ff       	jmp    105160 <alltraps>

0010602e <vector249>:
.globl vector249
vector249:
  pushl $0
  10602e:	6a 00                	push   $0x0
  pushl $249
  106030:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
  106035:	e9 26 f1 ff ff       	jmp    105160 <alltraps>

0010603a <vector250>:
.globl vector250
vector250:
  pushl $0
  10603a:	6a 00                	push   $0x0
  pushl $250
  10603c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
  106041:	e9 1a f1 ff ff       	jmp    105160 <alltraps>

00106046 <vector251>:
.globl vector251
vector251:
  pushl $0
  106046:	6a 00                	push   $0x0
  pushl $251
  106048:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
  10604d:	e9 0e f1 ff ff       	jmp    105160 <alltraps>

00106052 <vector252>:
.globl vector252
vector252:
  pushl $0
  106052:	6a 00                	push   $0x0
  pushl $252
  106054:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
  106059:	e9 02 f1 ff ff       	jmp    105160 <alltraps>

0010605e <vector253>:
.globl vector253
vector253:
  pushl $0
  10605e:	6a 00                	push   $0x0
  pushl $253
  106060:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
  106065:	e9 f6 f0 ff ff       	jmp    105160 <alltraps>

0010606a <vector254>:
.globl vector254
vector254:
  pushl $0
  10606a:	6a 00                	push   $0x0
  pushl $254
  10606c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
  106071:	e9 ea f0 ff ff       	jmp    105160 <alltraps>

00106076 <vector255>:
.globl vector255
vector255:
  pushl $0
  106076:	6a 00                	push   $0x0
  pushl $255
  106078:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
  10607d:	e9 de f0 ff ff       	jmp    105160 <alltraps>
  106082:	90                   	nop
  106083:	90                   	nop
  106084:	90                   	nop
  106085:	90                   	nop
  106086:	90                   	nop
  106087:	90                   	nop
  106088:	90                   	nop
  106089:	90                   	nop
  10608a:	90                   	nop
  10608b:	90                   	nop
  10608c:	90                   	nop
  10608d:	90                   	nop
  10608e:	90                   	nop
  10608f:	90                   	nop

00106090 <vmenable>:
}

// Turn on paging.
void
vmenable(void)
{
  106090:	55                   	push   %ebp
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  106091:	a1 b4 90 10 00       	mov    0x1090b4,%eax
  106096:	89 e5                	mov    %esp,%ebp
  106098:	0f 22 d8             	mov    %eax,%cr3

static inline uint
rcr0(void)
{
  uint val;
  asm volatile("movl %%cr0,%0" : "=r" (val));
  10609b:	0f 20 c0             	mov    %cr0,%eax
}

static inline void
lcr0(uint val)
{
  asm volatile("movl %0,%%cr0" : : "r" (val));
  10609e:	0d 00 00 00 80       	or     $0x80000000,%eax
  1060a3:	0f 22 c0             	mov    %eax,%cr0

  switchkvm(); // load kpgdir into cr3
  cr0 = rcr0();
  cr0 |= CR0_PG;
  lcr0(cr0);
}
  1060a6:	5d                   	pop    %ebp
  1060a7:	c3                   	ret    
  1060a8:	90                   	nop
  1060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

001060b0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm()
{
  1060b0:	55                   	push   %ebp
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  1060b1:	a1 b4 90 10 00       	mov    0x1090b4,%eax
  1060b6:	89 e5                	mov    %esp,%ebp
  1060b8:	0f 22 d8             	mov    %eax,%cr3
  lcr3(PADDR(kpgdir));   // switch to the kernel page table
}
  1060bb:	5d                   	pop    %ebp
  1060bc:	c3                   	ret    
  1060bd:	8d 76 00             	lea    0x0(%esi),%esi

001060c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to linear address va.  If create!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int create)
{
  1060c0:	55                   	push   %ebp
  1060c1:	89 e5                	mov    %esp,%ebp
  1060c3:	83 ec 28             	sub    $0x28,%esp
  1060c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  uint r;
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  1060c9:	89 d3                	mov    %edx,%ebx
  1060cb:	c1 eb 16             	shr    $0x16,%ebx
  1060ce:	8d 1c 98             	lea    (%eax,%ebx,4),%ebx
// Return the address of the PTE in page table pgdir
// that corresponds to linear address va.  If create!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int create)
{
  1060d1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  uint r;
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
  1060d4:	8b 33                	mov    (%ebx),%esi
  1060d6:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1060dc:	74 22                	je     106100 <walkpgdir+0x40>
    pgtab = (pte_t*) PTE_ADDR(*pde);
  1060de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
  1060e4:	c1 ea 0a             	shr    $0xa,%edx
  1060e7:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
  1060ed:	8d 04 16             	lea    (%esi,%edx,1),%eax
}
  1060f0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  1060f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  1060f6:	89 ec                	mov    %ebp,%esp
  1060f8:	5d                   	pop    %ebp
  1060f9:	c3                   	ret    
  1060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*) PTE_ADDR(*pde);
  } else if(!create || !(r = (uint) kalloc()))
  106100:	85 c9                	test   %ecx,%ecx
  106102:	75 04                	jne    106108 <walkpgdir+0x48>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
  106104:	31 c0                	xor    %eax,%eax
  106106:	eb e8                	jmp    1060f0 <walkpgdir+0x30>
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*) PTE_ADDR(*pde);
  } else if(!create || !(r = (uint) kalloc()))
  106108:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10610b:	90                   	nop
  10610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  106110:	e8 1b c3 ff ff       	call   102430 <kalloc>
  106115:	85 c0                	test   %eax,%eax
  106117:	74 eb                	je     106104 <walkpgdir+0x44>
    return 0;
  else {
    pgtab = (pte_t*) r;
  106119:	89 c6                	mov    %eax,%esi
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
  10611b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106122:	00 
  106123:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10612a:	00 
  10612b:	89 04 24             	mov    %eax,(%esp)
  10612e:	e8 dd de ff ff       	call   104010 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = PADDR(r) | PTE_P | PTE_W | PTE_U;
  106133:	89 f0                	mov    %esi,%eax
  106135:	83 c8 07             	or     $0x7,%eax
  106138:	89 03                	mov    %eax,(%ebx)
  10613a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10613d:	eb a5                	jmp    1060e4 <walkpgdir+0x24>
  10613f:	90                   	nop

00106140 <mappages>:
// Create PTEs for linear addresses starting at la that refer to
// physical addresses starting at pa. la and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *la, uint size, uint pa, int perm)
{
  106140:	55                   	push   %ebp
  106141:	89 e5                	mov    %esp,%ebp
  106143:	57                   	push   %edi
  106144:	56                   	push   %esi
  106145:	53                   	push   %ebx
  char *a = PGROUNDDOWN(la);
  106146:	89 d3                	mov    %edx,%ebx
  char *last = PGROUNDDOWN(la + size - 1);
  106148:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
// Create PTEs for linear addresses starting at la that refer to
// physical addresses starting at pa. la and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *la, uint size, uint pa, int perm)
{
  10614c:	83 ec 2c             	sub    $0x2c,%esp
  10614f:	8b 75 08             	mov    0x8(%ebp),%esi
  106152:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a = PGROUNDDOWN(la);
  106155:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(la + size - 1);
  10615b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
  106161:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  106165:	eb 1d                	jmp    106184 <mappages+0x44>
  106167:	90                   	nop

  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
  106168:	f6 00 01             	testb  $0x1,(%eax)
  10616b:	75 48                	jne    1061b5 <mappages+0x75>
      panic("remap");
    *pte = pa | perm | PTE_P;
  10616d:	8b 55 0c             	mov    0xc(%ebp),%edx
  106170:	09 f2                	or     %esi,%edx
    if(a == last)
  106172:	39 fb                	cmp    %edi,%ebx
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
  106174:	89 10                	mov    %edx,(%eax)
    if(a == last)
  106176:	74 30                	je     1061a8 <mappages+0x68>
      break;
    a += PGSIZE;
  106178:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
  10617e:	81 c6 00 10 00 00    	add    $0x1000,%esi
{
  char *a = PGROUNDDOWN(la);
  char *last = PGROUNDDOWN(la + size - 1);

  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
  106184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106187:	b9 01 00 00 00       	mov    $0x1,%ecx
  10618c:	89 da                	mov    %ebx,%edx
  10618e:	e8 2d ff ff ff       	call   1060c0 <walkpgdir>
    if(pte == 0)
  106193:	85 c0                	test   %eax,%eax
  106195:	75 d1                	jne    106168 <mappages+0x28>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 1;
}
  106197:	83 c4 2c             	add    $0x2c,%esp
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  10619a:	31 c0                	xor    %eax,%eax
  return 1;
}
  10619c:	5b                   	pop    %ebx
  10619d:	5e                   	pop    %esi
  10619e:	5f                   	pop    %edi
  10619f:	5d                   	pop    %ebp
  1061a0:	c3                   	ret    
  1061a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1061a8:	83 c4 2c             	add    $0x2c,%esp
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
  1061ab:	b8 01 00 00 00       	mov    $0x1,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 1;
}
  1061b0:	5b                   	pop    %ebx
  1061b1:	5e                   	pop    %esi
  1061b2:	5f                   	pop    %edi
  1061b3:	5d                   	pop    %ebp
  1061b4:	c3                   	ret    
  while(1){
    pte_t *pte = walkpgdir(pgdir, a, 1);
    if(pte == 0)
      return 0;
    if(*pte & PTE_P)
      panic("remap");
  1061b5:	c7 04 24 14 71 10 00 	movl   $0x107114,(%esp)
  1061bc:	e8 cf a8 ff ff       	call   100a90 <panic>
  1061c1:	eb 0d                	jmp    1061d0 <uva2ka>
  1061c3:	90                   	nop
  1061c4:	90                   	nop
  1061c5:	90                   	nop
  1061c6:	90                   	nop
  1061c7:	90                   	nop
  1061c8:	90                   	nop
  1061c9:	90                   	nop
  1061ca:	90                   	nop
  1061cb:	90                   	nop
  1061cc:	90                   	nop
  1061cd:	90                   	nop
  1061ce:	90                   	nop
  1061cf:	90                   	nop

001061d0 <uva2ka>:
// maps to.  The result is also a kernel logical address,
// since the kernel maps the physical memory allocated to user
// processes directly.
char*
uva2ka(pde_t *pgdir, char *uva)
{    
  1061d0:	55                   	push   %ebp
  pte_t *pte = walkpgdir(pgdir, uva, 0);
  1061d1:	31 c9                	xor    %ecx,%ecx
// maps to.  The result is also a kernel logical address,
// since the kernel maps the physical memory allocated to user
// processes directly.
char*
uva2ka(pde_t *pgdir, char *uva)
{    
  1061d3:	89 e5                	mov    %esp,%ebp
  1061d5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte = walkpgdir(pgdir, uva, 0);
  1061d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1061db:	8b 45 08             	mov    0x8(%ebp),%eax
  1061de:	e8 dd fe ff ff       	call   1060c0 <walkpgdir>
  1061e3:	89 c2                	mov    %eax,%edx
  if(pte == 0) return 0;
  1061e5:	31 c0                	xor    %eax,%eax
  1061e7:	85 d2                	test   %edx,%edx
  1061e9:	74 07                	je     1061f2 <uva2ka+0x22>
  uint pa = PTE_ADDR(*pte);
  return (char *)pa;
  1061eb:	8b 02                	mov    (%edx),%eax
  1061ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
  1061f2:	c9                   	leave  
  1061f3:	c3                   	ret    
  1061f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1061fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106200 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  106200:	55                   	push   %ebp
  106201:	89 e5                	mov    %esp,%ebp
  106203:	83 ec 38             	sub    $0x38,%esp
  106206:	8b 45 08             	mov    0x8(%ebp),%eax
  106209:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  10620c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  10620f:	8b 75 10             	mov    0x10(%ebp),%esi
  106212:	89 7d fc             	mov    %edi,-0x4(%ebp)
  106215:	8b 7d 0c             	mov    0xc(%ebp),%edi
  106218:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem = kalloc();
  10621b:	e8 10 c2 ff ff       	call   102430 <kalloc>
  if (sz >= PGSIZE)
  106220:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = kalloc();
  106226:	89 c3                	mov    %eax,%ebx
  if (sz >= PGSIZE)
  106228:	77 4c                	ja     106276 <inituvm+0x76>
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  10622a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106231:	00 
  106232:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  106239:	00 
  10623a:	89 04 24             	mov    %eax,(%esp)
  10623d:	e8 ce dd ff ff       	call   104010 <memset>
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  106242:	b9 00 10 00 00       	mov    $0x1000,%ecx
  106247:	31 d2                	xor    %edx,%edx
  106249:	89 1c 24             	mov    %ebx,(%esp)
  10624c:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  106253:	00 
  106254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106257:	e8 e4 fe ff ff       	call   106140 <mappages>
  memmove(mem, init, sz);
  10625c:	89 75 10             	mov    %esi,0x10(%ebp)
}
  10625f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106262:	89 7d 0c             	mov    %edi,0xc(%ebp)
}
  106265:	8b 7d fc             	mov    -0x4(%ebp),%edi
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106268:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10626b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  10626e:	89 ec                	mov    %ebp,%esp
  106270:	5d                   	pop    %ebp
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  106271:	e9 1a de ff ff       	jmp    104090 <memmove>
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem = kalloc();
  if (sz >= PGSIZE)
    panic("inituvm: more than a page");
  106276:	c7 04 24 1a 71 10 00 	movl   $0x10711a,(%esp)
  10627d:	e8 0e a8 ff ff       	call   100a90 <panic>
  106282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106290 <setupkvm>:
}

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  106290:	55                   	push   %ebp
  106291:	89 e5                	mov    %esp,%ebp
  106293:	53                   	push   %ebx
  106294:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
  106297:	e8 94 c1 ff ff       	call   102430 <kalloc>
  10629c:	85 c0                	test   %eax,%eax
  10629e:	89 c3                	mov    %eax,%ebx
  1062a0:	75 0e                	jne    1062b0 <setupkvm+0x20>
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
    return 0;
  return pgdir;
}
  1062a2:	89 d8                	mov    %ebx,%eax
  1062a4:	83 c4 14             	add    $0x14,%esp
  1062a7:	5b                   	pop    %ebx
  1062a8:	5d                   	pop    %ebp
  1062a9:	c3                   	ret    
  1062aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pde_t *pgdir;

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  1062b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1062b7:	00 
  1062b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1062bf:	00 
  1062c0:	89 04 24             	mov    %eax,(%esp)
  1062c3:	e8 48 dd ff ff       	call   104010 <memset>
  if(// Map IO space from 640K to 1Mbyte
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
  1062c8:	b9 00 00 06 00       	mov    $0x60000,%ecx
  1062cd:	ba 00 00 0a 00       	mov    $0xa0000,%edx
  1062d2:	89 d8                	mov    %ebx,%eax
  1062d4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1062db:	00 
  1062dc:	c7 04 24 00 00 0a 00 	movl   $0xa0000,(%esp)
  1062e3:	e8 58 fe ff ff       	call   106140 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  1062e8:	85 c0                	test   %eax,%eax
  1062ea:	75 0a                	jne    1062f6 <setupkvm+0x66>
  1062ec:	31 db                	xor    %ebx,%ebx
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
    return 0;
  return pgdir;
}
  1062ee:	83 c4 14             	add    $0x14,%esp
  1062f1:	89 d8                	mov    %ebx,%eax
  1062f3:	5b                   	pop    %ebx
  1062f4:	5d                   	pop    %ebp
  1062f5:	c3                   	ret    
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
     // Map kernel and free memory pool
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
  1062f6:	b9 00 00 f0 00       	mov    $0xf00000,%ecx
  1062fb:	ba 00 00 10 00       	mov    $0x100000,%edx
  106300:	89 d8                	mov    %ebx,%eax
  106302:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  106309:	00 
  10630a:	c7 04 24 00 00 10 00 	movl   $0x100000,(%esp)
  106311:	e8 2a fe ff ff       	call   106140 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  106316:	85 c0                	test   %eax,%eax
  106318:	74 d2                	je     1062ec <setupkvm+0x5c>
     !mappages(pgdir, (void *)USERTOP, 0x60000, USERTOP, PTE_W) ||
     // Map kernel and free memory pool
     !mappages(pgdir, (void *)0x100000, PHYSTOP-0x100000, 0x100000, PTE_W) ||
     // Map devices such as ioapic, lapic, ...
     !mappages(pgdir, (void *)0xFE000000, 0x2000000, 0xFE000000, PTE_W))
  10631a:	b9 00 00 00 02       	mov    $0x2000000,%ecx
  10631f:	ba 00 00 00 fe       	mov    $0xfe000000,%edx
  106324:	89 d8                	mov    %ebx,%eax
  106326:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10632d:	00 
  10632e:	c7 04 24 00 00 00 fe 	movl   $0xfe000000,(%esp)
  106335:	e8 06 fe ff ff       	call   106140 <mappages>

  // Allocate page directory
  if(!(pgdir = (pde_t *) kalloc()))
    return 0;
  memset(pgdir, 0, PGSIZE);
  if(// Map IO space from 640K to 1Mbyte
  10633a:	85 c0                	test   %eax,%eax
  10633c:	0f 85 60 ff ff ff    	jne    1062a2 <setupkvm+0x12>
  106342:	eb a8                	jmp    1062ec <setupkvm+0x5c>
  106344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10634a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106350 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  106350:	55                   	push   %ebp
  106351:	89 e5                	mov    %esp,%ebp
  106353:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
  106356:	e8 35 ff ff ff       	call   106290 <setupkvm>
  10635b:	a3 b4 90 10 00       	mov    %eax,0x1090b4
}
  106360:	c9                   	leave  
  106361:	c3                   	ret    
  106362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  106369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106370 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106370:	55                   	push   %ebp
  106371:	89 e5                	mov    %esp,%ebp
  106373:	57                   	push   %edi
  106374:	56                   	push   %esi
  106375:	53                   	push   %ebx
  106376:	83 ec 2c             	sub    $0x2c,%esp
  char *a = (char *)PGROUNDUP(newsz);
  106379:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  10637c:	8b 75 0c             	mov    0xc(%ebp),%esi
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  10637f:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a = (char *)PGROUNDUP(newsz);
  106382:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  106388:	83 ee 01             	sub    $0x1,%esi
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  10638b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(oldsz - 1);
  106391:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a <= last; a += PGSIZE){
  106397:	39 f3                	cmp    %esi,%ebx
  106399:	77 41                	ja     1063dc <deallocuvm+0x6c>
  10639b:	90                   	nop
  10639c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte_t *pte = walkpgdir(pgdir, a, 0);
  1063a0:	31 c9                	xor    %ecx,%ecx
  1063a2:	89 da                	mov    %ebx,%edx
  1063a4:	89 f8                	mov    %edi,%eax
  1063a6:	e8 15 fd ff ff       	call   1060c0 <walkpgdir>
    if(pte && (*pte & PTE_P) != 0){
  1063ab:	85 c0                	test   %eax,%eax
  1063ad:	74 23                	je     1063d2 <deallocuvm+0x62>
  1063af:	8b 10                	mov    (%eax),%edx
  1063b1:	f6 c2 01             	test   $0x1,%dl
  1063b4:	74 1c                	je     1063d2 <deallocuvm+0x62>
      uint pa = PTE_ADDR(*pte);
      if(pa == 0)
  1063b6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1063bc:	74 3d                	je     1063fb <deallocuvm+0x8b>
        panic("kfree");
      kfree((void *) pa);
  1063be:	89 14 24             	mov    %edx,(%esp)
  1063c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1063c4:	e8 a7 c0 ff ff       	call   102470 <kfree>
      *pte = 0;
  1063c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1063cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  char *last = PGROUNDDOWN(oldsz - 1);
  for(; a <= last; a += PGSIZE){
  1063d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  1063d8:	39 de                	cmp    %ebx,%esi
  1063da:	73 c4                	jae    1063a0 <deallocuvm+0x30>
  1063dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1063df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1063e2:	77 0c                	ja     1063f0 <deallocuvm+0x80>
      kfree((void *) pa);
      *pte = 0;
    }
  }
  return newsz < oldsz ? newsz : oldsz;
}
  1063e4:	83 c4 2c             	add    $0x2c,%esp
  1063e7:	5b                   	pop    %ebx
  1063e8:	5e                   	pop    %esi
  1063e9:	5f                   	pop    %edi
  1063ea:	5d                   	pop    %ebp
  1063eb:	c3                   	ret    
  1063ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *a = (char *)PGROUNDUP(newsz);
  char *last = PGROUNDDOWN(oldsz - 1);
  for(; a <= last; a += PGSIZE){
  1063f0:	8b 45 0c             	mov    0xc(%ebp),%eax
      kfree((void *) pa);
      *pte = 0;
    }
  }
  return newsz < oldsz ? newsz : oldsz;
}
  1063f3:	83 c4 2c             	add    $0x2c,%esp
  1063f6:	5b                   	pop    %ebx
  1063f7:	5e                   	pop    %esi
  1063f8:	5f                   	pop    %edi
  1063f9:	5d                   	pop    %ebp
  1063fa:	c3                   	ret    
  for(; a <= last; a += PGSIZE){
    pte_t *pte = walkpgdir(pgdir, a, 0);
    if(pte && (*pte & PTE_P) != 0){
      uint pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
  1063fb:	c7 04 24 96 6a 10 00 	movl   $0x106a96,(%esp)
  106402:	e8 89 a6 ff ff       	call   100a90 <panic>
  106407:	89 f6                	mov    %esi,%esi
  106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106410 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  106410:	55                   	push   %ebp
  106411:	89 e5                	mov    %esp,%ebp
  106413:	56                   	push   %esi
  106414:	53                   	push   %ebx
  106415:	83 ec 10             	sub    $0x10,%esp
  106418:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint i;

  if(!pgdir)
  10641b:	85 db                	test   %ebx,%ebx
  10641d:	74 59                	je     106478 <freevm+0x68>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  10641f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  106426:	00 
  106427:	31 f6                	xor    %esi,%esi
  106429:	c7 44 24 04 00 00 0a 	movl   $0xa0000,0x4(%esp)
  106430:	00 
  106431:	89 1c 24             	mov    %ebx,(%esp)
  106434:	e8 37 ff ff ff       	call   106370 <deallocuvm>
  106439:	eb 10                	jmp    10644b <freevm+0x3b>
  10643b:	90                   	nop
  10643c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < NPDENTRIES; i++){
  106440:	83 c6 01             	add    $0x1,%esi
  106443:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106449:	74 1f                	je     10646a <freevm+0x5a>
    if(pgdir[i] & PTE_P)
  10644b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  10644e:	a8 01                	test   $0x1,%al
  106450:	74 ee                	je     106440 <freevm+0x30>
      kfree((void *) PTE_ADDR(pgdir[i]));
  106452:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
  106457:	83 c6 01             	add    $0x1,%esi
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  10645a:	89 04 24             	mov    %eax,(%esp)
  10645d:	e8 0e c0 ff ff       	call   102470 <kfree>
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
  106462:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  106468:	75 e1                	jne    10644b <freevm+0x3b>
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  }
  kfree((void *) pgdir);
  10646a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
  10646d:	83 c4 10             	add    $0x10,%esp
  106470:	5b                   	pop    %ebx
  106471:	5e                   	pop    %esi
  106472:	5d                   	pop    %ebp
  deallocuvm(pgdir, USERTOP, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P)
      kfree((void *) PTE_ADDR(pgdir[i]));
  }
  kfree((void *) pgdir);
  106473:	e9 f8 bf ff ff       	jmp    102470 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(!pgdir)
    panic("freevm: no pgdir");
  106478:	c7 04 24 34 71 10 00 	movl   $0x107134,(%esp)
  10647f:	e8 0c a6 ff ff       	call   100a90 <panic>
  106484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  10648a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00106490 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  106490:	55                   	push   %ebp
  106491:	89 e5                	mov    %esp,%ebp
  106493:	57                   	push   %edi
  106494:	56                   	push   %esi
  106495:	53                   	push   %ebx
  106496:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d = setupkvm();
  106499:	e8 f2 fd ff ff       	call   106290 <setupkvm>
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  10649e:	85 c0                	test   %eax,%eax
// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d = setupkvm();
  1064a0:	89 c6                	mov    %eax,%esi
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  1064a2:	0f 84 84 00 00 00    	je     10652c <copyuvm+0x9c>
  for(i = 0; i < sz; i += PGSIZE){
  1064a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1064ab:	85 c0                	test   %eax,%eax
  1064ad:	74 7d                	je     10652c <copyuvm+0x9c>
  1064af:	31 db                	xor    %ebx,%ebx
  1064b1:	eb 47                	jmp    1064fa <copyuvm+0x6a>
  1064b3:	90                   	nop
  1064b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present\n");
    pa = PTE_ADDR(*pte);
    if(!(mem = kalloc()))
      goto bad;
    memmove(mem, (char *)pa, PGSIZE);
  1064b8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1064be:	89 54 24 04          	mov    %edx,0x4(%esp)
  1064c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1064c9:	00 
  1064ca:	89 04 24             	mov    %eax,(%esp)
  1064cd:	e8 be db ff ff       	call   104090 <memmove>
    if(!mappages(d, (void *)i, PGSIZE, PADDR(mem), PTE_W|PTE_U))
  1064d2:	b9 00 10 00 00       	mov    $0x1000,%ecx
  1064d7:	89 da                	mov    %ebx,%edx
  1064d9:	89 f0                	mov    %esi,%eax
  1064db:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  1064e2:	00 
  1064e3:	89 3c 24             	mov    %edi,(%esp)
  1064e6:	e8 55 fc ff ff       	call   106140 <mappages>
  1064eb:	85 c0                	test   %eax,%eax
  1064ed:	74 33                	je     106522 <copyuvm+0x92>
  pte_t *pte;
  uint pa, i;
  char *mem;

  if(!d) return 0;
  for(i = 0; i < sz; i += PGSIZE){
  1064ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  1064f5:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  1064f8:	76 32                	jbe    10652c <copyuvm+0x9c>
    if(!(pte = walkpgdir(pgdir, (void *)i, 0)))
  1064fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1064fd:	31 c9                	xor    %ecx,%ecx
  1064ff:	89 da                	mov    %ebx,%edx
  106501:	e8 ba fb ff ff       	call   1060c0 <walkpgdir>
  106506:	85 c0                	test   %eax,%eax
  106508:	74 2c                	je     106536 <copyuvm+0xa6>
      panic("copyuvm: pte should exist\n");
    if(!(*pte & PTE_P))
  10650a:	8b 10                	mov    (%eax),%edx
  10650c:	f6 c2 01             	test   $0x1,%dl
  10650f:	74 31                	je     106542 <copyuvm+0xb2>
      panic("copyuvm: page not present\n");
    pa = PTE_ADDR(*pte);
    if(!(mem = kalloc()))
  106511:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  106514:	e8 17 bf ff ff       	call   102430 <kalloc>
  106519:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10651c:	85 c0                	test   %eax,%eax
  10651e:	89 c7                	mov    %eax,%edi
  106520:	75 96                	jne    1064b8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
  106522:	89 34 24             	mov    %esi,(%esp)
  106525:	31 f6                	xor    %esi,%esi
  106527:	e8 e4 fe ff ff       	call   106410 <freevm>
  return 0;
}
  10652c:	83 c4 2c             	add    $0x2c,%esp
  10652f:	89 f0                	mov    %esi,%eax
  106531:	5b                   	pop    %ebx
  106532:	5e                   	pop    %esi
  106533:	5f                   	pop    %edi
  106534:	5d                   	pop    %ebp
  106535:	c3                   	ret    
  char *mem;

  if(!d) return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, (void *)i, 0)))
      panic("copyuvm: pte should exist\n");
  106536:	c7 04 24 45 71 10 00 	movl   $0x107145,(%esp)
  10653d:	e8 4e a5 ff ff       	call   100a90 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present\n");
  106542:	c7 04 24 60 71 10 00 	movl   $0x107160,(%esp)
  106549:	e8 42 a5 ff ff       	call   100a90 <panic>
  10654e:	66 90                	xchg   %ax,%ax

00106550 <allocuvm>:
// newsz. Allocates physical memory and page table entries. oldsz and
// newsz need not be page-aligned, nor does newsz have to be larger
// than oldsz.  Returns the new process size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106550:	55                   	push   %ebp
  if(newsz > USERTOP)
  106551:	31 c0                	xor    %eax,%eax
// newsz. Allocates physical memory and page table entries. oldsz and
// newsz need not be page-aligned, nor does newsz have to be larger
// than oldsz.  Returns the new process size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  106553:	89 e5                	mov    %esp,%ebp
  106555:	57                   	push   %edi
  106556:	56                   	push   %esi
  106557:	53                   	push   %ebx
  106558:	83 ec 2c             	sub    $0x2c,%esp
  10655b:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz > USERTOP)
  10655e:	81 7d 10 00 00 0a 00 	cmpl   $0xa0000,0x10(%ebp)
  106565:	0f 87 93 00 00 00    	ja     1065fe <allocuvm+0xae>
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  10656b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  10656e:	8b 75 10             	mov    0x10(%ebp),%esi
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  106571:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  106577:	83 ee 01             	sub    $0x1,%esi
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  10657a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  char *last = PGROUNDDOWN(newsz - 1);
  106580:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for (; a <= last; a += PGSIZE){
  106586:	39 f3                	cmp    %esi,%ebx
  106588:	76 47                	jbe    1065d1 <allocuvm+0x81>
  10658a:	eb 7c                	jmp    106608 <allocuvm+0xb8>
  10658c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
  106590:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  106597:	00 
  106598:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10659f:	00 
  1065a0:	89 04 24             	mov    %eax,(%esp)
  1065a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1065a6:	e8 65 da ff ff       	call   104010 <memset>
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  1065ab:	b9 00 10 00 00       	mov    $0x1000,%ecx
  1065b0:	89 f8                	mov    %edi,%eax
  1065b2:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
  1065b9:	00 
  1065ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1065bd:	89 14 24             	mov    %edx,(%esp)
  1065c0:	89 da                	mov    %ebx,%edx
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  char *last = PGROUNDDOWN(newsz - 1);
  for (; a <= last; a += PGSIZE){
  1065c2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  1065c8:	e8 73 fb ff ff       	call   106140 <mappages>
{
  if(newsz > USERTOP)
    return 0;
  char *a = (char *)PGROUNDUP(oldsz);
  char *last = PGROUNDDOWN(newsz - 1);
  for (; a <= last; a += PGSIZE){
  1065cd:	39 de                	cmp    %ebx,%esi
  1065cf:	72 37                	jb     106608 <allocuvm+0xb8>
    char *mem = kalloc();
  1065d1:	e8 5a be ff ff       	call   102430 <kalloc>
    if(mem == 0){
  1065d6:	85 c0                	test   %eax,%eax
  1065d8:	75 b6                	jne    106590 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
  1065da:	c7 04 24 7b 71 10 00 	movl   $0x10717b,(%esp)
  1065e1:	e8 da 9e ff ff       	call   1004c0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
  1065e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1065e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1065ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1065f0:	89 3c 24             	mov    %edi,(%esp)
  1065f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1065f7:	e8 74 fd ff ff       	call   106370 <deallocuvm>
  1065fc:	31 c0                	xor    %eax,%eax
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  }
  return newsz > oldsz ? newsz : oldsz;
}
  1065fe:	83 c4 2c             	add    $0x2c,%esp
  106601:	5b                   	pop    %ebx
  106602:	5e                   	pop    %esi
  106603:	5f                   	pop    %edi
  106604:	5d                   	pop    %ebp
  106605:	c3                   	ret    
  106606:	66 90                	xchg   %ax,%ax
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, a, PGSIZE, PADDR(mem), PTE_W|PTE_U);
  }
  return newsz > oldsz ? newsz : oldsz;
  106608:	8b 45 10             	mov    0x10(%ebp),%eax
  10660b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10660e:	73 ee                	jae    1065fe <allocuvm+0xae>
  106610:	8b 45 0c             	mov    0xc(%ebp),%eax
}
  106613:	83 c4 2c             	add    $0x2c,%esp
  106616:	5b                   	pop    %ebx
  106617:	5e                   	pop    %esi
  106618:	5f                   	pop    %edi
  106619:	5d                   	pop    %ebp
  10661a:	c3                   	ret    
  10661b:	90                   	nop
  10661c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00106620 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  106620:	55                   	push   %ebp
  106621:	89 e5                	mov    %esp,%ebp
  106623:	57                   	push   %edi
  106624:	56                   	push   %esi
  106625:	53                   	push   %ebx
  106626:	83 ec 3c             	sub    $0x3c,%esp
  106629:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
  10662c:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
  106632:	0f 85 99 00 00 00    	jne    1066d1 <loaduvm+0xb1>
    panic("loaduvm: addr must be page aligned\n");
  106638:	8b 75 18             	mov    0x18(%ebp),%esi
  10663b:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < sz; i += PGSIZE){
  10663d:	85 f6                	test   %esi,%esi
  10663f:	74 77                	je     1066b8 <loaduvm+0x98>
  106641:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  106644:	eb 13                	jmp    106659 <loaduvm+0x39>
  106646:	66 90                	xchg   %ax,%ax
  106648:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  10664e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  106654:	39 5d 18             	cmp    %ebx,0x18(%ebp)
  106657:	76 5f                	jbe    1066b8 <loaduvm+0x98>
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
  106659:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10665c:	31 c9                	xor    %ecx,%ecx
  10665e:	8b 45 08             	mov    0x8(%ebp),%eax
  106661:	01 da                	add    %ebx,%edx
  106663:	e8 58 fa ff ff       	call   1060c0 <walkpgdir>
  106668:	85 c0                	test   %eax,%eax
  10666a:	74 59                	je     1066c5 <loaduvm+0xa5>
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE) n = sz - i;
  10666c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
  106672:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE) n = sz - i;
  106674:	ba 00 10 00 00       	mov    $0x1000,%edx
  106679:	77 02                	ja     10667d <loaduvm+0x5d>
  10667b:	89 f2                	mov    %esi,%edx
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
  10667d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  106681:	8b 7d 14             	mov    0x14(%ebp),%edi
  106684:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  106689:	89 44 24 04          	mov    %eax,0x4(%esp)
  10668d:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
  106690:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  106694:	8b 45 10             	mov    0x10(%ebp),%eax
  106697:	89 04 24             	mov    %eax,(%esp)
  10669a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10669d:	e8 8e ae ff ff       	call   101530 <readi>
  1066a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1066a5:	39 d0                	cmp    %edx,%eax
  1066a7:	74 9f                	je     106648 <loaduvm+0x28>
      return 0;
  }
  return 1;
}
  1066a9:	83 c4 3c             	add    $0x3c,%esp
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE) n = sz - i;
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
  1066ac:	31 c0                	xor    %eax,%eax
      return 0;
  }
  return 1;
}
  1066ae:	5b                   	pop    %ebx
  1066af:	5e                   	pop    %esi
  1066b0:	5f                   	pop    %edi
  1066b1:	5d                   	pop    %ebp
  1066b2:	c3                   	ret    
  1066b3:	90                   	nop
  1066b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  1066b8:	83 c4 3c             	add    $0x3c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
  1066bb:	b8 01 00 00 00       	mov    $0x1,%eax
    else n = PGSIZE;
    if(readi(ip, (char *)pa, offset+i, n) != n)
      return 0;
  }
  return 1;
}
  1066c0:	5b                   	pop    %ebx
  1066c1:	5e                   	pop    %esi
  1066c2:	5f                   	pop    %edi
  1066c3:	5d                   	pop    %ebp
  1066c4:	c3                   	ret    

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  for(i = 0; i < sz; i += PGSIZE){
    if(!(pte = walkpgdir(pgdir, addr+i, 0)))
      panic("loaduvm: address should exist\n");
  1066c5:	c7 04 24 cc 71 10 00 	movl   $0x1071cc,(%esp)
  1066cc:	e8 bf a3 ff ff       	call   100a90 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint)addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned\n");
  1066d1:	c7 04 24 a8 71 10 00 	movl   $0x1071a8,(%esp)
  1066d8:	e8 b3 a3 ff ff       	call   100a90 <panic>
  1066dd:	8d 76 00             	lea    0x0(%esi),%esi

001066e0 <switchuvm>:
}

// Switch h/w page table and TSS registers to point to process p.
void
switchuvm(struct proc *p)
{
  1066e0:	55                   	push   %ebp
  1066e1:	89 e5                	mov    %esp,%ebp
  1066e3:	53                   	push   %ebx
  1066e4:	83 ec 14             	sub    $0x14,%esp
  1066e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
  1066ea:	e8 91 d7 ff ff       	call   103e80 <pushcli>

  // Setup TSS
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  1066ef:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  1066f5:	8d 50 08             	lea    0x8(%eax),%edx
  1066f8:	89 d1                	mov    %edx,%ecx
  1066fa:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
  106701:	c1 e9 10             	shr    $0x10,%ecx
  106704:	c1 ea 18             	shr    $0x18,%edx
  106707:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  10670d:	c6 80 a5 00 00 00 99 	movb   $0x99,0xa5(%eax)
  106714:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  10671a:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
  106721:	67 00 
  106723:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  10672a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106730:	80 a0 a5 00 00 00 ef 	andb   $0xef,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  106737:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  10673d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  106743:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  106749:	8b 50 08             	mov    0x8(%eax),%edx
  10674c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  106752:	81 c2 00 10 00 00    	add    $0x1000,%edx
  106758:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
  10675b:	b8 30 00 00 00       	mov    $0x30,%eax
  106760:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);

  if(p->pgdir == 0)
  106763:	8b 43 04             	mov    0x4(%ebx),%eax
  106766:	85 c0                	test   %eax,%eax
  106768:	74 0d                	je     106777 <switchuvm+0x97>
}

static inline void
lcr3(uint val) 
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
  10676a:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir\n");

  lcr3(PADDR(p->pgdir));  // switch to new address space
  popcli();
}
  10676d:	83 c4 14             	add    $0x14,%esp
  106770:	5b                   	pop    %ebx
  106771:	5d                   	pop    %ebp

  if(p->pgdir == 0)
    panic("switchuvm: no pgdir\n");

  lcr3(PADDR(p->pgdir));  // switch to new address space
  popcli();
  106772:	e9 49 d7 ff ff       	jmp    103ec0 <popcli>
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  ltr(SEG_TSS << 3);

  if(p->pgdir == 0)
    panic("switchuvm: no pgdir\n");
  106777:	c7 04 24 93 71 10 00 	movl   $0x107193,(%esp)
  10677e:	e8 0d a3 ff ff       	call   100a90 <panic>
  106783:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  106789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00106790 <ksegment>:

// Set up CPU's kernel segment descriptors.
// Run once at boot time on each CPU.
void
ksegment(void)
{
  106790:	55                   	push   %ebp
  106791:	89 e5                	mov    %esp,%ebp
  106793:	83 ec 18             	sub    $0x18,%esp

  // Map virtual addresses to linear addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  106796:	e8 75 bf ff ff       	call   102710 <cpunum>
  10679b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
  1067a1:	05 00 c3 10 00       	add    $0x10c300,%eax
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  1067a6:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  1067ac:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
  1067b3:	89 d1                	mov    %edx,%ecx
  1067b5:	c1 ea 18             	shr    $0x18,%edx
  1067b8:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)
  1067be:	c1 e9 10             	shr    $0x10,%ecx

  lgdt(c->gdt, sizeof(c->gdt));
  1067c1:	8d 50 70             	lea    0x70(%eax),%edx
  // Map virtual addresses to linear addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  1067c4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
  1067ca:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
  1067d0:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
  1067d4:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
  1067d8:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  1067dc:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  1067e0:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
  1067e7:	ff ff 
  1067e9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
  1067f0:	00 00 
  1067f2:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
  1067f9:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
  106800:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  106807:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  10680e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
  106815:	ff ff 
  106817:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
  10681e:	00 00 
  106820:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
  106827:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
  10682e:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  106835:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  10683c:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
  106843:	ff ff 
  106845:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
  10684c:	00 00 
  10684e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
  106855:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
  10685c:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)
  106863:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
  10686a:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
  106871:	00 00 
  106873:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
  106879:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
  106880:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
  106887:	66 c7 45 f2 37 00    	movw   $0x37,-0xe(%ebp)
  pd[1] = (uint)p;
  10688d:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
  106891:	c1 ea 10             	shr    $0x10,%edx
  106894:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
  106898:	8d 55 f2             	lea    -0xe(%ebp),%edx
  10689b:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
  10689e:	ba 18 00 00 00       	mov    $0x18,%edx
  1068a3:	8e ea                	mov    %edx,%gs

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);
  
  // Initialize cpu-local storage.
  cpu = c;
  1068a5:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
  1068ab:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
  1068b2:	00 00 00 00 
}
  1068b6:	c9                   	leave  
  1068b7:	c3                   	ret    
