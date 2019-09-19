//
//  MainViewController.m
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIMainView *mainView;
@property (nonatomic, strong) UIBaseController *baseController;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];

        self.title = @"Сонник+";
        self.mainView = [[UIMainView alloc] initWithFrame:CGRectZero];
        self.mainView.delegate = self;
        self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.mainView];
        NSLayoutConstraint *leadingConstraint = [self.mainView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
        NSLayoutConstraint *topConstraint = [self.mainView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
        NSLayoutConstraint *trailingConstraint = [self.mainView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
        NSLayoutConstraint *bottomConstraint = [self.mainView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
        [NSLayoutConstraint activateConstraints:@[leadingConstraint,
                                                  topConstraint,
                                                  trailingConstraint,
                                                  bottomConstraint]];

    }
    return self;
}

- (void)searchAction:(NSString *)searchText {
    self.baseController = [[UIBaseController alloc] initWithNibName:nil bundle:nil searchText:searchText];
    self.baseController.delegate = self;
    self.baseController.view.frame = CGRectZero;
    self.baseController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.baseController.view];
    NSLayoutConstraint *leadingConstraint = [self.baseController.view.leadingAnchor constraintEqualToAnchor:self.mainView.leadingAnchor];
    NSLayoutConstraint *topConstraint = [self.mainView.topAnchor constraintEqualToAnchor:self.baseController.view.topAnchor];
    NSLayoutConstraint *trailingConstraint = [self.baseController.view.trailingAnchor constraintEqualToAnchor:self.mainView.trailingAnchor];
    NSLayoutConstraint *bottomConstraint = [self.baseController.view.bottomAnchor constraintEqualToAnchor:self.mainView.bottomAnchor];
    [NSLayoutConstraint activateConstraints:@[leadingConstraint,
                                              topConstraint,
                                              trailingConstraint,
                                              bottomConstraint]];
    
}

- (void)cancelAction {
    [self.baseController.view removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.titleView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

@end
