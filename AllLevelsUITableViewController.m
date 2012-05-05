//
//  AllLevelsUITableViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllLevelsUITableViewController.h"
#import "FlashCardsViewController.h"
#import "BabelbayLevel.h"
#import <QuartzCore/QuartzCore.h>

@interface AllLevelsUITableViewController ()

@property (nonatomic, strong, readonly) NSArray *allLevels; 

@end

@implementation AllLevelsUITableViewController

@synthesize allLevels = _allLevels;
-(NSArray *)allLevels{
    if(!_allLevels){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:20]; // 20 levels
        for (int num = 1; num<=20; num++) {
            [arr addObject:[[BabelbayLevel alloc] init:num]];
        }
        _allLevels = arr;
    }
    return _allLevels;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;//self.allLevels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Level";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    BabelbayLevel *level = [self.allLevels objectAtIndex:indexPath.row];
    cell.textLabel.text = [level.name getText:en].native;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Level %@", level.levelNumber];


    
    // background gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor]CGColor], (id)[[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1]CGColor], nil];
    [cell.layer insertSublayer:gradient atIndex: 0];
    
    cell.textLabel.backgroundColor= [UIColor colorWithWhite:1 alpha:0];
    cell.detailTextLabel.backgroundColor= [UIColor colorWithWhite:1 alpha:0];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

int _selectedLevel;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedLevel = indexPath.row+1;
    [self performSegueWithIdentifier:@"Start Level" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"AllLevelsUITableViewController segue to %@", segue.destinationViewController);
    
    if( [segue.identifier isEqualToString:@"Start Level"]){
        FlashCardsViewController *vc = segue.destinationViewController;
        [vc setLevelNumber:_selectedLevel];
    }
}

@end
