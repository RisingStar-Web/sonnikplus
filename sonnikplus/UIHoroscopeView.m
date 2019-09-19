//
//  UIHoroscopeView.m
//  sonnikplus
//
//  Created by neko on 10.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "UIHoroscopeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIHoroscopeView

- (id)initWithFrame:(CGRect)frame horoLabel:(NSString*)horoLabel horoContent:(NSString*)horoContent horoIco:(NSString*)horoIco
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.layer.borderColor = [UIColor colorWithRed:0.0510 green:0.1059 blue:0.5176 alpha:0.8000].CGColor;
        self.layer.cornerRadius = 15.0;
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40.0, 40.0)];
        [iconImage setImage:[UIImage imageNamed:horoIco]];
        [self addSubview:iconImage];
        
        UILabel *horoTitle = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 5.0, self.frame.size.width - 45.0, 40.0)];
        horoTitle.text = horoLabel;
        //horoTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        horoTitle.font = [UIFont systemFontOfSize:14.0];
        horoTitle.textAlignment = NSTextAlignmentCenter;
        horoTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:horoTitle];
        
        CGSize labelSize = [horoContent sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(self.frame.size.width - 20.0, 9999.f) lineBreakMode:NSLineBreakByWordWrapping];

        UILabel *horoText = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, self.frame.size.width - 20.0, labelSize.height)];
        horoText.text = horoContent;
        horoText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        horoText.font = [UIFont systemFontOfSize:14.0];
        horoText.lineBreakMode = NSLineBreakByWordWrapping;
        horoText.numberOfLines = 0;
        horoText.textAlignment = NSTextAlignmentLeft;
        horoText.backgroundColor = [UIColor clearColor];
        horoText.textColor = [UIColor blackColor];
        [self addSubview:horoText];
        self.contentSize = CGSizeMake(self.frame.size.width - 100.0, horoText.frame.size.height + 50.0);
        
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
