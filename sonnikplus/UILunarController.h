//
//  UILunarController.h
//  sonnikplus
//
//  Created by neko on 15.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "UICurrentMoonController.h"
#import "RMDateSelectionViewController.h"

@interface UILunarController : UIViewController <CLLocationManagerDelegate, UIActionSheetDelegate, UIScrollViewDelegate, UIPopoverControllerDelegate> {
    CLLocationManager *locationManager;
    NSDate *dateToCalculate;
    UIActionSheet *actionSheet;
    UILabel *summaryLabel;
    CLLocation *currentLocation;
    UIScrollView *moonScroll;
    UIPageControl *pageControl;
    NSString *cityName;
}

@property (nonatomic, strong) NSDate *dateToCalculate;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) UIScrollView *moonScroll;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSString *cityName;

- (void)reloadMoons;

@end
