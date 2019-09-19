//
//  UIMainView.h
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RSSParser.h"
#import <CFNetwork/CFNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>

@protocol UISearchDelegate;

@interface UIMainView : UIView <UISearchBarDelegate, RSSParserDelegate, UIScrollViewDelegate> {
    UISearchBar *searchBar;
    id <UISearchDelegate> delegate;
    NSMutableDictionary *horoDict;
    RSSParser *rssParser;
    UIView *horoscopeView;
    UIPageControl *pageControl;
    UIScrollView *horoScroll;
    UIView *waitingView;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) id <UISearchDelegate> delegate;
@property (nonatomic) int counter;
@property (strong, nonatomic) NSArray *horoLinks;

- (void)resizeScrollViewContent;

@end

@protocol UISearchDelegate<NSObject>

@optional

- (void)searchAction:(NSString *)searchText;

@end
