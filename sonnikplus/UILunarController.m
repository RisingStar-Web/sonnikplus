//
//  UILunarController.m
//  sonnikplus
//
//  Created by neko on 15.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "UILunarController.h"
#import "LunarInfoCalculator.h"
#import "UICurrentMoonController.h"

@interface UILunarController ()

@end

@implementation UILunarController

@synthesize dateToCalculate = _dateToCalculate;
@synthesize currentLocation = _currentLocation;
@synthesize pageControl = _pageControl;
@synthesize moonScroll = _moonScroll;
@synthesize cityName = _cityName;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.moonScroll.frame.size.width;
    float fractionalPage = self.moonScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (UILabel *)buildTitleViewForDate:(NSDate *)date frame:(CGRect)frame {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString = [dateFormatter stringFromDate:date];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    titleLabel.text = [NSString stringWithFormat:@"%@, %@", dateString, self.cityName];
    return titleLabel;
}

- (NSDate *)getForDays:(int)days fromDate:(NSDate *)date
{
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:date options:0];
}

- (void)buildMoonsView {
    self.moonScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.moonScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.moonScroll.pagingEnabled = YES;
    self.moonScroll.delegate = self;
    self.moonScroll.showsHorizontalScrollIndicator = NO;
    self.moonScroll.contentSize = CGSizeMake(self.moonScroll.frame.size.width * 5, self.moonScroll.bounds.size.height - 90.0);
    self.moonScroll.backgroundColor = [UIColor clearColor];
    
    int k = -2;
    int l = 3;
    
    UIView *contentView;
    
    self.moonScroll.backgroundColor = [UIColor clearColor];
    
    for (int i = k; i < l; i++) {
        NSDate * newDate = [self getForDays:i fromDate:self.dateToCalculate];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self.dateToCalculate];
        
        LunarInfoCalculator *lunarDict = [[LunarInfoCalculator alloc] initWithGeoposAndDate:(int)[components year]
                                                                                      month:(int)[components month]
                                                                                        day:(int)[components day] + i
                                                                                      hours:(int)[components hour]
                                                                                    minutes:(int)[components minute]
                                                                                    seconds:(int)[components second]
                                                                                  longitude:self.currentLocation.coordinate.longitude
                                                                                   latitude:self.currentLocation.coordinate.latitude];
        UILabel *tLabel = [self buildTitleViewForDate:newDate frame:CGRectMake(self.view.frame.size.width * (i + 2)+ 10.0, 20.0, self.view.frame.size.width - 20.0, 40.0)];
        [self.moonScroll addSubview:tLabel];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (i + 2) + 10.0, 50.0, self.view.frame.size.width - 20.0, self.view.frame.size.height - 90.0)];

        
        contentView.backgroundColor = [UIColor clearColor];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        contentView.layer.masksToBounds = NO;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 20.0, contentView.frame.size.width, 90)];
        UICurrentMoonController *moonController = [[UICurrentMoonController new] initWithStyle:UITableViewStylePlain moonInfoDict:lunarDict];
        [self addChildViewController:moonController];
        moonController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [moonController.tableView setFrame:CGRectMake(0.0, topView.frame.size.height + topView.frame.origin.y + 10.0, contentView.frame.size.width, contentView.frame.size.height - 105.0)];
        moonController.tableView.layer.borderColor = [UIColor colorWithRed:0.4245 green:0.5231 blue:0.6398 alpha:1.0000].CGColor;
        moonController.tableView.layer.borderWidth = 1.0;
        [contentView addSubview:moonController.tableView];
        
        UIImageView *moonImage = [[UIImageView alloc] initWithFrame:CGRectMake(topView.frame.size.width / 2.0 - 30.0, 25.0, 60.0, 60.0)];
        moonImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"moon%@.png",[lunarDict objectForKey:@"moonImage"]]];
        [topView addSubview:moonImage];
        //        [moonImage release];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        // = [[NSDate alloc] init];
        NSDate *dateFromString = [dateFormatter dateFromString:[lunarDict objectForKey:@"newMoonFuture"]];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
        NSString *visib = [NSString stringWithFormat:@"%3.1f%@", [[lunarDict objectForKey:@"illuminaty"] floatValue]*100, @"%"];
        UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, topView.frame.size.width, 25.0)];
        sumLabel.backgroundColor = [UIColor clearColor];
        sumLabel.textAlignment = NSTextAlignmentCenter;
        sumLabel.textColor = [UIColor whiteColor];
        sumLabel.text = [NSString stringWithFormat:
                         @"Видимая часть: %@", visib];
        sumLabel.lineBreakMode = NSLineBreakByWordWrapping;
        sumLabel.numberOfLines = 0;
        sumLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [topView addSubview:sumLabel];
        
        UILabel *newMoonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 25.0, topView.frame.size.width / 2.0 - 30.0, 65.0)];
        newMoonLabel.backgroundColor = [UIColor clearColor];
        newMoonLabel.textAlignment = NSTextAlignmentCenter;
        newMoonLabel.textColor = [UIColor whiteColor];
        newMoonLabel.text = [NSString stringWithFormat:
                             @"Новолуние:\n%@", [dateFormatter stringFromDate:dateFromString]];
        newMoonLabel.lineBreakMode = NSLineBreakByWordWrapping;
        newMoonLabel.numberOfLines = 0;
        newMoonLabel.font = [UIFont systemFontOfSize:13.0];
        [topView addSubview:newMoonLabel];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFromString = [dateFormatter dateFromString:[lunarDict objectForKey:@"fullMoonFuture"]];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
        
        UILabel *fullMoonLabel = [[UILabel alloc] initWithFrame:CGRectMake(topView.frame.size.width / 2.0 + 30.0, 25.0, topView.frame.size.width / 2.0 - 30.0, 65.0)];
        fullMoonLabel.backgroundColor = [UIColor clearColor];
        fullMoonLabel.textAlignment = NSTextAlignmentCenter;
        fullMoonLabel.textColor = [UIColor whiteColor];
        fullMoonLabel.text = [NSString stringWithFormat:
                              @"Полнолуние:\n%@", [dateFormatter stringFromDate:dateFromString]];
        fullMoonLabel.lineBreakMode = NSLineBreakByWordWrapping;
        fullMoonLabel.numberOfLines = 0;
        fullMoonLabel.font = [UIFont systemFontOfSize:13.0];
        [topView addSubview:fullMoonLabel];
        
        topView.backgroundColor = [UIColor colorWithRed:0.4245 green:0.5231 blue:0.6398 alpha:1.0000];
        topView.layer.shadowColor = [UIColor blackColor].CGColor;
        topView.layer.shadowOpacity = 1.0;
        topView.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        topView.layer.shadowRadius = 2.0;
        topView.layer.masksToBounds = NO;
        topView.clipsToBounds = NO;
        
        [contentView addSubview:topView];
        
        [self.moonScroll addSubview:contentView];
        [moonController.tableView reloadData];
    }
    
    [self.moonScroll setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0.0)];
    
    self.moonScroll.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.moonScroll];
    
    NSLayoutConstraint *leadingConstraint = [self.moonScroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    NSLayoutConstraint *topConstraint = [self.moonScroll.topAnchor constraintEqualToAnchor:self.view.topAnchor];
    NSLayoutConstraint *trailingConstraint = [self.moonScroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    NSLayoutConstraint *bottomConstraint = [self.moonScroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    [NSLayoutConstraint activateConstraints:@[leadingConstraint,
                                              topConstraint,
                                              trailingConstraint,
                                              bottomConstraint]];

    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateButton addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [dateButton setImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
    [dateButton setFrame:CGRectMake(self.view.frame.size.width - 35.0, 25.0, 30.0, 30.0)];
    [self.view addSubview:dateButton];
    self.pageControl.frame = CGRectMake(0.0, self.view.frame.size.height - 20.0, self.view.frame.size.width, 20.0);
    
}

- (void)reloadMoons {
    [self.moonScroll removeFromSuperview];
    [self buildMoonsView];
}

- (void)setDate:(id)sender {
    RMAction<UIDatePicker *> *selectAction = [RMAction<UIDatePicker *> actionWithTitle:@"Выбрать" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        self.dateToCalculate = controller.contentView.date;
        [self.moonScroll removeFromSuperview];
        [self buildMoonsView];
    }];
    
    RMAction<UIDatePicker *> *cancelAction = [RMAction<UIDatePicker *> actionWithTitle:@"Отмена" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite title:nil message:nil selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.contentView.datePickerMode = UIDatePickerModeDate;
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Луна";
        
        self.dateToCalculate = [NSDate date];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height - 20.0, 320.0, 20.0)];
        self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.pageControl.numberOfPages = 5;
        self.pageControl.currentPage = 2;
        [self.view addSubview:self.pageControl];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // 100 m
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
        self.view.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
    self.currentLocation = locations.lastObject;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       if ([self.cityName length] == 0) {
                           self.cityName = placemark.locality;
                           [self buildMoonsView];
                       }
                   }];

    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    self.cityName = @"Лондон";
    [self buildMoonsView];
    self.currentLocation = [[CLLocation alloc] initWithLatitude:51.4788854 longitude:-0.0106342];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Не удалось получить текущие координаты.\nБудут использованы координаты нулевого меридиана" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    self.moonScroll.contentSize = CGSizeMake(self.moonScroll.frame.size.width * 5, self.view.bounds.size.height - 50.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
