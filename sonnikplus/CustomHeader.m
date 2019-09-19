//
//  CustomHeader.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "CustomHeader.h"
#import "Common.h"

@implementation CustomHeader
@synthesize titleLabel = _titleLabel;
@synthesize lightColor = _lightColor;
@synthesize darkColor = _darkColor;

- (id)init {
    if ((self = [super init])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _titleLabel.shadowOffset = CGSizeMake(0, -1);
        [self addSubview:_titleLabel];
        self.lightColor = [UIColor colorWithRed:0.9142 green:0.8341 blue:0.5262 alpha:1.0000];
        self.darkColor = [UIColor colorWithRed:0.8052 green:0.7334 blue:0.4685 alpha:1.0000];        
    }
    return self;
}

-(void) layoutSubviews {
       
    CGFloat coloredBoxMargin = 6.0;
    CGFloat coloredBoxHeight = 29.0;
    _coloredBoxRect = CGRectMake(coloredBoxMargin, 
                                 coloredBoxMargin, 
                                 self.bounds.size.width-coloredBoxMargin*2, 
                                 coloredBoxHeight);
    
    CGFloat paperMargin = 9.0;
    _paperRect = CGRectMake(paperMargin, 
                            CGRectGetMaxY(_coloredBoxRect), 
                            self.bounds.size.width-paperMargin*2, 
                            self.bounds.size.height-CGRectGetMaxY(_coloredBoxRect));
    
    _titleLabel.frame = _coloredBoxRect;
        
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    CGColorRef greenColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0].CGColor;
        
    CGContextSetFillColorWithColor(context, redColor);
    CGContextFillRect(context, _coloredBoxRect);
    
    CGContextSetFillColorWithColor(context, greenColor);
    CGContextFillRect(context, _paperRect);
    */
        
    CGContextRef context = UIGraphicsGetCurrentContext();    

    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    CGColorRef lightColor = _lightColor.CGColor;
    CGColorRef darkColor = _darkColor.CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor;   
        
    // Draw paper
    CGContextSetFillColorWithColor(context, whiteColor);
    CGContextFillRect(context, _paperRect);

    // Draw shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
    CGContextSetFillColorWithColor(context, lightColor);
    CGContextFillRect(context, _coloredBoxRect);
    CGContextRestoreGState(context);
    
    // Draw gloss and gradient
    drawGlossAndGradient(context, _coloredBoxRect, lightColor, darkColor);  

    // Draw stroke
    CGContextSetStrokeColorWithColor(context, darkColor);
    CGContextSetLineWidth(context, 1.0);    
    CGContextStrokeRect(context, rectFor1PxStroke(_coloredBoxRect));    
    
}




@end
