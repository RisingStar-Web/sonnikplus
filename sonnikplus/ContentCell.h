//
//  CellSeparator.h
//  iAppNews
//
//  Created by Альф on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol UIContentCellDelegate;

@interface ContentCell : UITableViewCell {
    UIView *innerView;
    UILabel *contentLabel;
    UIButton *favButton;
    UIButton *smsShare;
}

@property (nonatomic, strong) NSString *contentStr;
@property (strong, nonatomic) id <UIContentCellDelegate> delegate;
@property (nonatomic) NSInteger row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellText:(NSString *)cellText rowNumber:(NSInteger)rowNumber frame:(CGRect)frame number:(NSString *)number;

@end

@protocol UIContentCellDelegate<NSObject>

@optional

- (void)favAction:(NSInteger)rowNumber;
- (void)smsShareAction:(NSInteger)rowNumber;

@end
