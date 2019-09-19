//
//  UIBaseController.m
//  sonnikplus
//
//  Created by neko on 02.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "UIBaseController.h"
#import "Dreams.h"
#import "MainViewController.h"
#import "CellSeparator.h"
#import "ContentView.h"

@interface UIBaseController ()

@end

@implementation UIBaseController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchResults, searchBar, exactSearch;
@synthesize searching = _searching;
@synthesize delegate = _delegate;
@synthesize tableView = _tableView;

- (void)cancelAction {
    [self.delegate cancelAction];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil searchText:(NSString *)searchText
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.exactSearch = [NSMutableArray array];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        
        [self.searchBar sizeToFit];
        self.searchBar.text = searchText;
        for (UIView *subview in self.searchBar.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [subview removeFromSuperview];
                break;
            }
        }
        self.searchBar.delegate = self;
        self.searchBar.backgroundColor = [UIColor clearColor];
        MainViewController *mvc = [[SharedAppDelegate.tabBarController childViewControllers][0] childViewControllers][0];
        mvc.navigationItem.titleView = self.searchBar;
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Закрыть" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        mvc.navigationItem.rightBarButtonItem = cancelButton;
        
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.tableView];
        
        NSLayoutConstraint *leadingConstraint = [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
        NSLayoutConstraint *topConstraint = [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor];
        NSLayoutConstraint *trailingConstraint = [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
        NSLayoutConstraint *bottomConstraint = [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
        [NSLayoutConstraint activateConstraints:@[leadingConstraint,
                                                  topConstraint,
                                                  trailingConstraint,
                                                  bottomConstraint]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searching = YES;
    self.dictName = @"ANY";
    
    self.searchResults = [NSMutableArray array];
    
    [self sortSearchResultsBy];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searching)
    {
        return [self.searchResults count];
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
}

- (CellSeparator *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CellSeparator *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[CellSeparator alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIColor *upperLineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        [cell.upperLine setBackgroundColor:upperLineColor];
        
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.frame.size.width - 20.0, 37.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    //titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [cell.innerView addSubview:titleLabel];
    
    UILabel *prodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 37.0, self.tableView.frame.size.width - 10.0, 20.0)];
    prodLabel.backgroundColor = [UIColor clearColor];
    prodLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    prodLabel.textAlignment = NSTextAlignmentLeft;
    //prodLabel.numberOfLines = 2;
    prodLabel.numberOfLines = 1;
    //[prodLabel sizeToFit];
    //prodLabel.lineBreakMode = NSLineBreakByWordWrapping;
    prodLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    prodLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    [cell.innerView addSubview:prodLabel];
    
    if (self.searching) {
        NSManagedObject *info = [self.searchResults objectAtIndex:indexPath.row];
        titleLabel.text = [info valueForKey:@"word"];
        prodLabel.text = [info valueForKey:@"dictname"];
    } else {
        Dreams *dicts = nil;
        dicts = (Dreams *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        titleLabel.text = dicts.word;
        prodLabel.text = dicts.dictname;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.exactSearch removeAllObjects];
    NSManagedObject *info = [self.searchResults objectAtIndex:indexPath.row];
    NSString *exactSearchStr = [info valueForKey:@"word"];
    NSString *selectedDictName = [info valueForKey:@"dictname"];
    for (int i = 0; i < [self.searchResults count]; i++) {
        NSManagedObject *searchObject = [self.searchResults objectAtIndex:i];
        if ([[searchObject valueForKey:@"word"] isEqualToString:exactSearchStr] && [[searchObject valueForKey:@"dictname"] isEqualToString:selectedDictName]) {
            [self.exactSearch insertObject:searchObject atIndex:0];
        }
        else if ([[searchObject valueForKey:@"word"] isEqualToString:exactSearchStr] && ![[searchObject valueForKey:@"dictname"] isEqualToString:selectedDictName]) {
            [self.exactSearch addObject:searchObject];
        }
    }
    
    ContentView *contentView = [[ContentView alloc] initWithNibName:nil bundle:nil];
    contentView.managedObjects = self.exactSearch;

    MainViewController *mvc = [[SharedAppDelegate.tabBarController childViewControllers][0] childViewControllers][0];
    [mvc.navigationController pushViewController:contentView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sortSearchResultsBy {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //self.searchResults = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES  selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dreams" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSFetchedResultsController *searchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    searchFetchedResultsController.delegate = self;
    // We use an NSPredicate combined with the fetchedResultsController to perform the search
    NSPredicate *predicate;
    if ([self.searchBar.text length] > 0)
    {
        if (![self.dictName isEqualToString:@"ANY"]) {
            predicate =[NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@ AND dictname = %@", self.searchBar.text, self.dictName];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@", self.searchBar.text];
        }
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"dictname = %@", self.dictName];
    }
    [searchFetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    if (![searchFetchedResultsController performFetch:&error])
        return;
    
    [self.searchResults addObjectsFromArray: searchFetchedResultsController.fetchedObjects];
    NSLog(@"dddddd %@",searchFetchedResultsController.fetchedObjects);
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchResults removeAllObjects];
    self.searching = YES;
    [self.searchBar resignFirstResponder];
    self.dictName = @"ANY";
    [self performSelectorInBackground:@selector(sortSearchResultsBy) withObject:nil];
}

-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Dreams" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    //    fetchRequest.fetchLimit = fetchLimit;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES selector:@selector(localizedStandardCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                         managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil
                                                    cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
