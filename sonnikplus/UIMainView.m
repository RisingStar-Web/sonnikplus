//
//  UIMainView.m
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "UIMainView.h"
#import "UIHoroscopeView.h"

@implementation UIMainView

@synthesize searchBar;
@synthesize delegate = _delegate;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = horoScroll.frame.size.width;
    float fractionalPage = horoScroll.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
}

- (void)initWaitingView {
    waitingView = [[UIView alloc] initWithFrame:CGRectMake(15.0, self.searchBar.frame.origin.y + self.searchBar.frame.size.height + 10.f, self.bounds.size.width - 30.0, self.frame.size.height - (self.searchBar.frame.origin.y + self.searchBar.frame.size.height) - 40.0)];
    
    waitingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    waitingView.layer.borderWidth = 1.0;
    waitingView.layer.borderColor = [UIColor colorWithRed:0.0510 green:0.1059 blue:0.5176 alpha:0.8000].CGColor;
    waitingView.layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7].CGColor;
    waitingView.layer.cornerRadius = 15.0;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 40.0)];
    activity.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height / 2.0);
    activity.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    [waitingView addSubview:activity];
    
    [self addSubview:waitingView];
    
}

- (void)buildHoroscopeView {
    if (waitingView)
    [waitingView removeFromSuperview];
    horoScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, self.searchBar.frame.origin.y + self.searchBar.frame.size.height + 10.f, self.bounds.size.width, self.frame.size.height - (self.searchBar.frame.origin.y + self.searchBar.frame.size.height) - 40.0)];
    horoScroll.pagingEnabled = YES;
    horoScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    horoScroll.delegate = self;
    horoScroll.showsHorizontalScrollIndicator = NO;
    horoScroll.contentSize = CGSizeMake(horoScroll.frame.size.width * [[horoDict objectForKey:@"name"] count], horoScroll.frame.size.height);
    horoScroll.backgroundColor = [UIColor clearColor];
    NSMutableArray *heightsArray;
    NSNumber *height = 0;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        heightsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[horoDict objectForKey:@"name"] count]; i++) {
            NSString *cellText = [[horoDict objectForKey:@"content"] objectAtIndex:i];
            CGSize labelSize = [cellText boundingRectWithSize:CGSizeMake(self.frame.size.width - 30.0, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                                      context:nil].size;
            [heightsArray addObject:[NSNumber numberWithFloat:labelSize.height + 60.0]];
            
        }
        height = [heightsArray valueForKeyPath:@"@max.floatValue"];
    }
    for (int i = 0; i < [[horoDict objectForKey:@"name"] count]; i++) {
        UIHoroscopeView *hView = [[UIHoroscopeView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width + 15.0, 0.0, self.bounds.size.width - 30.0, horoScroll.frame.size.height) horoLabel:[[horoDict objectForKey:@"name"] objectAtIndex:i] horoContent:[[horoDict objectForKey:@"content"] objectAtIndex:i] horoIco:[NSString stringWithFormat:@"icon%i.png",i + 1]];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            hView.frame = CGRectMake(i * self.bounds.size.width + 15.0, 0.0, self.bounds.size.width - 30.0, [height floatValue]);
            hView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        }
        
        [horoScroll addSubview:hView];
    }
    [self addSubview:horoScroll];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, horoScroll.frame.origin.y + horoScroll.frame.size.height + 5.0, self.frame.size.width, 20.0)];
    pageControl.userInteractionEnabled = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageControl.frame = CGRectMake(0.0, self.searchBar.frame.origin.y + self.searchBar.frame.size.height + [height floatValue] + 10.0, self.frame.size.width, 20.0);
    }
    pageControl.numberOfPages = [[horoDict objectForKey:@"name"] count];
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
}

- (void)parserDidParseChannel:(NSDictionary *)channel {}

- (void)parserDidParseItem:(NSDictionary *)feedItem {
    [[horoDict objectForKey:@"name"] addObject:[feedItem objectForKey:@"title"]];
    [[horoDict objectForKey:@"content"] addObject:[feedItem objectForKey:@"description"]];
}

- (void)parserDidFinishParsing:(RSSParser *)parser {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.counter < [self.horoLinks count] - 1) {
            self.counter++;
            [self performSelectorOnMainThread:@selector(parseHoroscope:) withObject:[NSNumber numberWithInt: self.counter] waitUntilDone:YES];
        } else {
            [self buildHoroscopeView];
        }
    });
}

- (void)parser:(RSSParser *)parser didEncounterError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.counter < [self.horoLinks count] - 1) {
            self.counter++;
            [self performSelectorOnMainThread:@selector(parseHoroscope:) withObject:[NSNumber numberWithInt: self.counter] waitUntilDone:YES];
        } else {
            [self buildHoroscopeView];
        }
    });
}

- (void)parseHoroscope:(id)number {
    [rssParser downloadAndParseFeed:[NSURL URLWithString:[self.horoLinks objectAtIndex:[number intValue]]]];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        rssParser = [[RSSParser alloc] init];
        [rssParser setDelegate:self];
        NSMutableArray *nameArray = [NSMutableArray array];
        NSMutableArray *contentArray = [NSMutableArray array];
        horoDict = [[NSMutableDictionary alloc] init];
        [horoDict setObject:nameArray forKey:@"name"];
        [horoDict setObject:contentArray forKey:@"content"];
        self.counter = 0;
        self.horoLinks = [[NSArray alloc] initWithObjects:
                     @"http://hyrax.ru/rss_daily_common_aries.xml",
                     @"http://hyrax.ru/rss_daily_common_taurus.xml",
                     @"http://hyrax.ru/rss_daily_common_gemini.xml",
                     @"http://hyrax.ru/rss_daily_common_cancer.xml",
                     @"http://hyrax.ru/rss_daily_common_leo.xml",
                     @"http://hyrax.ru/rss_daily_common_virgo.xml",
                     @"http://hyrax.ru/rss_daily_common_libra.xml",
                     @"http://hyrax.ru/rss_daily_common_scorpio.xml",
                     @"http://hyrax.ru/rss_daily_common_sagittarius.xml",
                     @"http://hyrax.ru/rss_daily_common_capricorn.xml",
                     @"http://hyrax.ru/rss_daily_common_aquarius.xml",
                     @"http://hyrax.ru/rss_daily_common_pisces.xml",
                     nil];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.searchBar.placeholder = @"Поиск по основному слову";
        self.searchBar.delegate = self;
        self.searchBar.searchBarStyle = UISearchBarStyleDefault;
        self.searchBar.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
        self.searchBar.barTintColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
        self.searchBar.tintColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
        self.searchBar.translucent = NO;
        self.searchBar.layer.borderColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000].CGColor;
        self.searchBar.layer.borderWidth = 1;
        self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.searchBar];
        
        NSLayoutConstraint *leadingConstraint = [self.searchBar.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
        NSLayoutConstraint *topConstraint = [self.searchBar.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.f];
        NSLayoutConstraint *trailingConstraint = [self.searchBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
        NSLayoutConstraint *heightConstraint = [self.searchBar.heightAnchor constraintEqualToConstant:40.f];
        [NSLayoutConstraint activateConstraints:@[leadingConstraint,
                                                  topConstraint,
                                                  trailingConstraint,
                                                  heightConstraint]];
        
        self.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
        
        [self initWaitingView];
        [self parseHoroscope:[NSNumber numberWithInt:self.counter]];

    }
    return self;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.delegate searchAction:self.searchBar.text];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)resizeScrollViewContent {
    horoScroll.contentSize = CGSizeMake(horoScroll.frame.size.width * [[horoDict objectForKey:@"name"] count], horoScroll.frame.size.height);
    
}

@end
