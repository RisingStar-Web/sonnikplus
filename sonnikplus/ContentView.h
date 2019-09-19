//
//  ContentView.h
//  drugsplus
//
//  Created by neko on 31.01.13.
//  Copyright (c) 2013 Denis Alfa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ContentCell.h"

@class MainViewController;

@interface ContentView : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIContentCellDelegate, MFMessageComposeViewControllerDelegate> {
    UITableView *drugsTable;
    NSMutableArray *managedObjects;
}

@property (nonatomic, strong) NSMutableArray *managedObjects;

@end
