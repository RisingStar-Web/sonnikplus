//
//  UICurrentMoonController.m
//  sonnikplus
//
//  Created by neko on 17.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "UICurrentMoonController.h"
#import "CustomHeaderMoon.h"

@interface UICurrentMoonController ()

@end

@implementation UICurrentMoonController

@synthesize moonRising = _moonRising;

- (id)initWithStyle:(UITableViewStyle)style moonInfoDict:(NSDictionary*)moonInfoDict
{
    self = [super initWithStyle:style];
    if (self) {
        moonRisingState = [[NSString alloc] init];
        currentMoonInfo = [[NSDictionary alloc] initWithDictionary:moonInfoDict];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[currentMoonInfo objectForKey:@"moonRiseState"] boolValue]) {
        moonRisingState = @"Растущая луна";
        self.moonRising = [NSString stringWithFormat:@"%@, %@", @"Растущая луна", [currentMoonInfo objectForKey:@"moonPhase"]];
    }
    else {
        moonRisingState = @"Убывающая луна";
        self.moonRising = [NSString stringWithFormat:@"%@, %@", @"Убывающая луна", [currentMoonInfo objectForKey:@"moonPhase"]];
    }
    
    if ([[currentMoonInfo objectForKey:@"moonPhase"] isEqualToString:@"Новолуние"]) {
        self.moonRising = @"Новолуние";
    } else if ([[currentMoonInfo objectForKey:@"moonPhase"] isEqualToString:@"Полнолуние"]) {
        self.moonRising = @"Полнолуние";
    }
    
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.opaque = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    contentArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSString *stringToPrint = @"";
    if ([[currentMoonInfo objectForKey:@"moonPhase"] isEqualToString:@"Новолуние"] || [[currentMoonInfo objectForKey:@"moonPhase"] isEqualToString:@"Полнолуние"]) {
        stringToPrint = [[SharedAppDelegate.moonPhaseDict objectForKey:@"phasedesc"] objectAtIndex:[[SharedAppDelegate.moonPhaseDict objectForKey:@"moonphase"] indexOfObject:[currentMoonInfo objectForKey:@"moonPhase"]]];
    } else {
        stringToPrint = [NSString stringWithFormat:@"%@\n%@",[[SharedAppDelegate.moonPhaseDict objectForKey:@"phasedesc"] objectAtIndex:[[SharedAppDelegate.moonPhaseDict objectForKey:@"moonphase"] indexOfObject:[currentMoonInfo objectForKey:@"moonPhase"]]], [[SharedAppDelegate.moonPhaseDict objectForKey:@"phasedesc"] objectAtIndex:[[SharedAppDelegate.moonPhaseDict objectForKey:@"moonphase"] indexOfObject:moonRisingState]]];
    }
    [contentArray addObject:stringToPrint];
    
    stringToPrint = [NSString stringWithFormat:@"%@\n%@", [[SharedAppDelegate.moonDaysDict objectForKey:@"dreamdesc"] objectAtIndex:[[currentMoonInfo objectForKey:@"moonDay"] intValue] - 1], [[SharedAppDelegate.moonDaysDict objectForKey:@"otherdesc"] objectAtIndex:[[currentMoonInfo objectForKey:@"moonDay"] intValue] - 1]];
    [contentArray addObject:stringToPrint];
    
    stringToPrint = [[SharedAppDelegate.zodiacNameDict objectForKey:@"zodiacdesc"] objectAtIndex:[[SharedAppDelegate.zodiacNameDict objectForKey:@"zodiacname"] indexOfObject:[currentMoonInfo objectForKey:@"zodiacName"]]];
    [contentArray addObject:stringToPrint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize labelSize = [[contentArray objectAtIndex:indexPath.section] sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(self.view.frame.size.width - 20.f, 9999.f) lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CustomHeaderMoon *header = [[CustomHeaderMoon alloc] init];
    header.lightColor = [UIColor colorWithRed:0.4245 green:0.5231 blue:0.6398 alpha:1.0000];
    header.darkColor = [UIColor colorWithRed:0.4245 green:0.5231 blue:0.6398 alpha:1.0000];
    if (section == 0) header.titleLabel.text = [NSString stringWithFormat:@"%@",self.moonRising];
    else if (section == 1) header.titleLabel.text = [NSString stringWithFormat:@"%i %@",(int)floor([[currentMoonInfo objectForKey:@"moonDay"] doubleValue]), @" лунный день"];
    else if (section == 2) header.titleLabel.text = [NSString stringWithFormat:@"Луна в знаке: %@ (%@)",[currentMoonInfo objectForKey:@"zodiacName"], [currentMoonInfo objectForKey:@"zodiacPos"]];
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    cell.textLabel.text = [contentArray objectAtIndex:indexPath.section];
    return cell;
}

@end
