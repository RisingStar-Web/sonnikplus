//
//  CellSeparator.h
//  iAppNews
//
//  Created by Альф on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CellSeparator : UITableViewCell {
    UIView *upperLine;
//    UIView *lowerLine;
//    NSInteger whatBar;
    UIView *innerView;
    BOOL row;
}

@property (nonatomic, strong) UIView *upperLine;
@property (nonatomic, strong) UIView *innerView;
//@property (nonatomic, strong) UIView *lowerLine;
//@property (nonatomic, strong) UIView *middleLine;
//@property (nonatomic) NSInteger whatBar;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier lastRow:(BOOL)lastRow;

@end