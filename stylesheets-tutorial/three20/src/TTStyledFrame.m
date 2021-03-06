#import "Three20/TTStyledFrame.h"
#import "Three20/TTStyledNode.h"
#import "Three20/TTDefaultStyleSheet.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledFrame

@synthesize element = _element, nextFrame = _nextFrame, bounds = _bounds;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithElement:(TTStyledElement*)element {
  if (self = [super init]) {
    _element = element;
    _nextFrame = nil;
    _bounds = CGRectZero;
  }
  return self;
}

- (void)dealloc {
  [_nextFrame release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (CGFloat)x {
  return _bounds.origin.x;
}

- (void)setX:(CGFloat)x {
  _bounds.origin.x = x;
}

- (CGFloat)y {
  return _bounds.origin.y;
}

- (void)setY:(CGFloat)y {
  _bounds.origin.y = y;
}

- (CGFloat)width {
  return _bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
  _bounds.size.width = width;
}

- (CGFloat)height {
  return _bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
  _bounds.size.height = height;
}

- (void)drawInRect:(CGRect)rect {
}

- (TTStyledBoxFrame*)hitTest:(CGPoint)point {
  return [_nextFrame hitTest:point];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledBoxFrame

@synthesize parentFrame = _parentFrame, firstChildFrame = _firstChildFrame, style = _style;

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

- (void)drawSubframes {
  TTStyledFrame* frame = _firstChildFrame;
  while (frame) {
    [frame drawInRect:frame.bounds];
    frame = frame.nextFrame;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    _parentFrame = nil;
    _firstChildFrame = nil;
    _style = nil;
  }
  return self;
}

- (void)dealloc {
  [_firstChildFrame release];
  [_style release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTStyleDelegate

- (void)drawLayer:(TTStyleContext*)context withStyle:(TTStyle*)style {
  if ([style isKindOfClass:[TTTextStyle class]]) {
    TTTextStyle* textStyle = (TTTextStyle*)style;
    UIFont* font = context.font;
    context.font = textStyle.font;
    if (textStyle.color) {
      CGContextRef context = UIGraphicsGetCurrentContext();
      CGContextSaveGState(context);
      [textStyle.color setFill];
      
      [self drawSubframes];
      
      CGContextRestoreGState(context);
    } else {
      [self drawSubframes];
    }
    context.font = font;
  } else {
    [self drawSubframes];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)drawInRect:(CGRect)rect {
  if (_style) {
    TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
    context.delegate = self;
    context.frame = rect;
    context.contentFrame = rect;

    [_style draw:context];
    if (context.didDrawContent) {
      return;
    }
  }

  [self drawSubframes];
}

- (TTStyledBoxFrame*)hitTest:(CGPoint)point {
  if (CGRectContainsPoint(_bounds, point)) {
    TTStyledBoxFrame* frame = [_firstChildFrame hitTest:point];
    return frame ? frame : self;
  } else if (_nextFrame) {
    return [_nextFrame hitTest:point];
  } else {
    return nil;
  }
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledInlineFrame

- (TTStyledInlineFrame*)inlineParentFrame {
  if ([_parentFrame isKindOfClass:[TTStyledInlineFrame class]]) {
    return (TTStyledInlineFrame*)_parentFrame;
  } else {
    return nil;
  }  
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledTextFrame

@synthesize node = _node, text = _text, font = _font;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithText:(NSString*)text element:(TTStyledElement*)element node:(TTStyledTextNode*)node {
  if (self = [super initWithElement:element]) {
    _text = [text retain];
    _node = node;
    _font = nil;
  }
  return self;
}

- (void)dealloc {
  [_text release];
  [_font release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)drawInRect:(CGRect)rect {
  [_text drawInRect:rect withFont:_font];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTStyledImageFrame

@synthesize imageNode = _imageNode;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithElement:(TTStyledElement*)element node:(TTStyledImageNode*)node {
  if (self = [super initWithElement:element]) {
    _imageNode = node;
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (void)drawInRect:(CGRect)rect {
  [_imageNode.image drawInRect:rect];
}

@end
