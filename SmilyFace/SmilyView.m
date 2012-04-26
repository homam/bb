//
//  SmilyView.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SmilyView.h"

@implementation SmilyView

@synthesize dataSource = _dataSource;

@synthesize smiliness = _smiliness;

-(float)smiliness{
    return [self.dataSource getSmiliness];
}

@synthesize scale = _scale;

-(float)scale {
    if(!_scale)
        return .9;
    return  _scale;
}

-(void)setScale:(float)scale    {
    if(scale != _scale && scale>.1){
        _scale =scale;
        [self setNeedsDisplay];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

-(void)awakeFromNib{
    self.contentMode = UIViewContentModeRedraw;
}

-(void)drawCircleAtPoint:(CGPoint) point withRadius:(CGFloat) radius inContext: (CGContextRef) context{
    UIGraphicsPushContext(context); // save context
    
    CGContextBeginPath(context);
    CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext(); // restore context
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 5);
    [[UIColor blueColor] setStroke];
    
    CGPoint center;
    center.x = self.bounds.size.width/2.0 + self.bounds.origin.x;
    center.y = self.bounds.size.height/2.0 + self.bounds.origin.y;
    
    CGFloat size = self.bounds.size.width/2;
    if(self.bounds.size.height<self.bounds.size.width) size = self.bounds.size.height/2;
    size *= self.scale;
        
    [self drawCircleAtPoint:center withRadius:size inContext:context];
    
#define EYE_H .35
#define EYE_W .35
#define EYE_RADIUS .1
    
    
    CGPoint eyePoint = CGPointMake(center.x - size * EYE_W, center.y - size * EYE_H);
    
    [self drawCircleAtPoint:eyePoint withRadius:EYE_RADIUS *size  inContext:context];
    eyePoint.x += size * EYE_W*2;
    [self drawCircleAtPoint:eyePoint withRadius:EYE_RADIUS * size inContext:context];
    
#define MOUTH_H .45
#define MOUTH_V .45
#define MOUTH_SMILE .25
    
    CGPoint mouthStart = CGPointMake(center.x-MOUTH_H*size , center.y + MOUTH_V*size);
    CGPoint mouthEnd = CGPointMake(center.x+MOUTH_H*size, center.y+MOUTH_V*size);
    
    [self drawCircleAtPoint:mouthStart withRadius:2. inContext:context];
    [self drawCircleAtPoint:mouthEnd withRadius:2. inContext:context];
    
    float smile = self.smiliness;    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;

    
    CGPoint mouthCP1 = CGPointMake(mouthStart.x + MOUTH_H*size * .66, mouthStart.y + smileOffset);
    CGPoint mouthCP2 = CGPointMake(mouthEnd.x - MOUTH_H*size * .66, mouthEnd.y + smileOffset);
    
    [self drawCircleAtPoint:mouthCP1 withRadius:2. inContext:context];
    [self drawCircleAtPoint:mouthCP2 withRadius:2. inContext:context];
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}


@end
