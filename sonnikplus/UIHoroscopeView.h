//
//  UIHoroscopeView.h
//  sonnikplus
//
//  Created by neko on 10.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHoroscopeView : UIScrollView

- (id)initWithFrame:(CGRect)frame horoLabel:(NSString*)horoLabel horoContent:(NSString*)horoContent horoIco:(NSString*)horoIco;

@end
