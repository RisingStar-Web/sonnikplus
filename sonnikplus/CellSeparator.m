//
//  CellSeparator.m
//  iAppNews
//
//  Created by Альф on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CellSeparator.h"

@implementation CellSeparator

@synthesize upperLine;
@synthesize innerView;
//@synthesize lowerLine;
//@synthesize middleLine;
//@synthesize whatBar;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        innerView = [[UIView alloc] init];
        innerView.layer.borderWidth = 1.0;
        innerView.layer.borderColor = [UIColor colorWithRed:0.1973 green:0.2112 blue:0.5297 alpha:1.0000].CGColor;
        innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        innerView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];

        self.backgroundView = innerView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [innerView setFrame: CGRectMake(5.0, 0.0, self.contentView.frame.size.width - 10.0, self.contentView.frame.size.height - 3.0)];
}

@end
