//
//  UIBaseController.h
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIBaseDelegate;

@interface UIBaseController : UIViewController <NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate> {
    UISearchBar *searchBar;
    BOOL searching;    
    id <UIBaseDelegate> delegate;
    UITableView *tableView;
    
}

@property (strong, nonatomic) id <UIBaseDelegate> delegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *exactSearch;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) BOOL searching;
@property (nonatomic, strong) NSString *dictName;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchText:(NSString *)searchText;

@end

@protocol UIBaseDelegate<NSObject>

@optional

- (void)cancelAction;

@end