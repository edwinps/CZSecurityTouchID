//
//  PinButton.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "PinButton.h"

@implementation PinButton

- (void)setHighlighted:(BOOL)highlighted {
    if (super.highlighted != highlighted) {
        super.highlighted = highlighted;
        
        [self setNeedsDisplay];
    }
}

-(void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

-(void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];

    CGFloat height = CGRectGetHeight(rect);
    CGRect  inset  = CGRectInset(CGRectMake(0, 0, height, height), 1, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef colorRef  = [self tintColor].CGColor;
    CGColorRef strokecolorRef  = [self strokeColor].CGColor;
    UIControlState state = [self state];
    
    CGContextSetLineWidth(context, self.strokeWidth);
    if (state == UIControlStateHighlighted) {
        CGContextSetFillColorWithColor(context, colorRef);
        CGContextFillEllipseInRect (context, inset);
        CGContextFillPath(context);
    }
    else {
        CGContextSetStrokeColorWithColor(context, strokecolorRef);
        CGContextAddEllipseInRect(context, inset);
        CGContextStrokePath(context);
    }
}

@end
