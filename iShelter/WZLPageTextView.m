//
//  WZLPageTextView.m
//  iShelter
//
//  Created by wangzhilong on 15/7/20.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "WZLPageTextView.h"
#import <CoreText/CoreText.h>
@implementation WZLPageTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollEnabled = NO;
        self.editable = NO;
        
    }
    return self;
}
- (void)setText:(NSAttributedString *)text {
    self.attributedText = text;
    self.attString = text;
    //通知重绘
    [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // Flip the coordinate system
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CTFramesetterRef childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
//    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:rect];
//    CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
//    CTFrameDraw(frame, context);
//    CFRelease(frame);
//    CFRelease(childFramesetter);
//}


@end
