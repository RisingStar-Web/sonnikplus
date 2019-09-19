//
//  CellSeparator.m
//  iAppNews
//
//  Created by Альф on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

@synthesize delegate = _delegate;
@synthesize contentStr = _contentStr;
@synthesize row = _row;


- (void)smsShareAction:(id)sender {
    [self.delegate smsShareAction:[sender tag]];
}

- (void)favAction:(id)sender {
    [self.delegate favAction:[sender tag]];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellText:(NSString *)cellText rowNumber:(NSInteger)rowNumber frame:(CGRect)frame number:(NSString *)number {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.row = rowNumber;
        self.contentStr = cellText;
        //self.upperLine = [[UIView alloc] init];
        //[innerView addSubview:self.upperLine];

        innerView = [[UIView alloc] init];
        innerView.layer.borderWidth = 1.0;
        innerView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:0.8].CGColor;
        innerView.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        UIFont *cellFont = [UIFont systemFontOfSize:14.0];
        CGSize constraintSize = CGSizeMake(self.frame.size.width - 10.0, MAXFLOAT);
        CGSize labelSize = [cellText boundingRectWithSize:constraintSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: cellFont}
                                                  context:nil].size;
        self.backgroundView = innerView;
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, self.frame.size.width - 10.0, labelSize.height + 5.0)];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.textColor = [UIColor blackColor];
        contentLabel.font = [UIFont systemFontOfSize:14.0];
        contentLabel.text = self.contentStr;
        [innerView addSubview:contentLabel];
        
        smsShare = [UIButton buttonWithType:UIButtonTypeCustom];
        smsShare.tag = self.row;
        smsShare.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [smsShare setBackgroundImage:[UIImage imageNamed:@"smsButton.png"] forState:UIControlStateNormal];
        [smsShare addTarget:self action:@selector(smsShareAction:) forControlEvents:UIControlEventTouchUpInside];
        smsShare.frame = CGRectMake(contentLabel.frame.origin.x + contentLabel.frame.size.width - 25.0, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5.0, 30.0, 30.0);
        [self addSubview:smsShare];
        
        favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        favButton.tag = self.row;
        favButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        if (![[SharedAppDelegate.favorits objectForKey:@"name"] containsObject:number]) {
            [favButton setBackgroundImage:[UIImage imageNamed:@"favButton.png"] forState:UIControlStateNormal];
        } else {
            [favButton setBackgroundImage:[UIImage imageNamed:@"favButtonRem.png"] forState:UIControlStateNormal];
        }
        [favButton addTarget:self action:@selector(favAction:) forControlEvents:UIControlEventTouchUpInside];
        favButton.frame = CGRectMake(contentLabel.frame.origin.x + contentLabel.frame.size.width - 60.0, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5.0, 30.0, 30.0);
        [self addSubview:favButton];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIFont *cellFont = [UIFont systemFontOfSize:14.0];
    CGSize constraintSize = CGSizeMake(self.frame.size.width - 10.0, CGFLOAT_MAX);
    CGSize labelSize = [self.contentStr boundingRectWithSize:constraintSize
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName: cellFont}
                                                               context:nil].size;

    innerView.frame = CGRectMake(5.0, 5.0, self.frame.size.width - 10.0, labelSize.height + 49.0);
    contentLabel.frame = CGRectMake(10.0, 5.0, innerView.frame.size.width - 20.0, labelSize.height + 5.0);
    favButton.frame = CGRectMake(contentLabel.frame.origin.x + contentLabel.frame.size.width - 60.0, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5.0, 30.0, 30.0);
    smsShare.frame = CGRectMake(contentLabel.frame.origin.x + contentLabel.frame.size.width - 25.0, contentLabel.frame.origin.y + contentLabel.frame.size.height + 5.0, 30.0, 30.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
