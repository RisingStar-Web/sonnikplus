//
//  FavouritesViewController.m
//  drugsplus
//
//  Created by neko on 06.02.13.
//  Copyright (c) 2013 Denis Alfa. All rights reserved.
//

#import "FavoritsViewController.h"
#import "CellSeparator.h"
#import "ContentView.h"
#import "Dreams.h"

@interface FavoritsViewController ()

@end

@implementation FavoritsViewController

@synthesize favsArray = _favsArray;
@synthesize tableView = _tableView;

- (void)reloadView {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dreams" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES selector:@selector(localizedStandardCompare:)];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *searchFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"Favorits"];
    searchFetchedResultsController.delegate = self;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY number IN %@",[SharedAppDelegate.favorits objectForKey:@"name"]];
    [searchFetchedResultsController.fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil;
    if (![searchFetchedResultsController performFetch:&error])
    {
        return;
    }
    self.favsArray = nil;
    self.favsArray = searchFetchedResultsController.fetchedObjects;
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Избранное";
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 10.0, self.view.frame.size.width, self.view.frame.size.height - 10.0) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        [self.view addSubview:self.tableView];
        
        self.view.backgroundColor = [UIColor colorWithRed:0.4157 green:0.5216 blue:0.7608 alpha:1.0000];
    }
    return self;
}

- (void)viewDidLoad
{
    [self reloadView];
    [super viewDidLoad];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.favsArray count];
}

- (CellSeparator *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CellSeparator *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[CellSeparator alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        UIColor *upperLineColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        [cell.upperLine setBackgroundColor:upperLineColor];
        
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0.0, cell.frame.size.width - 20.0, 37.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    [cell.innerView addSubview:titleLabel];
    
    UILabel *prodLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 37.0, cell.frame.size.width - 20.0, 20.0)];
    prodLabel.backgroundColor = [UIColor clearColor];
    prodLabel.textAlignment = NSTextAlignmentRight;
    prodLabel.numberOfLines = 1;
    prodLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    prodLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    [cell.innerView addSubview:prodLabel];
    
    NSManagedObject *info = [self.favsArray objectAtIndex:indexPath.row];
    titleLabel.text = [info valueForKey:@"word"];
    prodLabel.text = [info valueForKey:@"dictname"];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *searchObject = [self.favsArray objectAtIndex:indexPath.row];
    NSMutableArray *exactSearch = [[NSMutableArray alloc] initWithObjects:searchObject, nil];
    ContentView *contentView = [[ContentView alloc] init];
    contentView.managedObjects = exactSearch;
    [self.navigationController pushViewController:contentView animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
