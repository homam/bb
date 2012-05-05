//
//  MyWordsTableViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyWordsTableViewController.h"
#import "BabelbayMyWords.h"
#import "MyWordsUITableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface MyWordsTableViewController () <MyWordsUITableViewCellProtocol, AVAudioPlayerDelegate>

// there must be only one strong pointer to BabelbayMyWords throughout the application
@property (nonatomic, strong, readonly) BabelbayMyWords *myWords;
// cache
@property (nonatomic, strong, readonly) NSMutableDictionary *levels;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation MyWordsTableViewController

-(void)doAsync:(id(^)())task then:(void(^)(id)) continuation{
    dispatch_queue_t downloadQ = dispatch_queue_create("doAsync", NULL);
    dispatch_async(downloadQ, ^(void) {
        
        id result = task();
        dispatch_async(dispatch_get_main_queue(), ^{
            continuation(result);
        });
        
    });
    dispatch_release(downloadQ);
}

@synthesize audioPlayer = _audioPlayer;

@synthesize myWords = _myWords;
-(BabelbayMyWords *)myWords{
    if(!_myWords){
        _myWords = [[BabelbayMyWords alloc] init];
    }
    return _myWords;
}

// cache
@synthesize levels = _levels;
-(NSMutableDictionary *)levels{
    if(!_levels){
        _levels = [[NSMutableDictionary alloc]init];
    }
    return _levels;
}

-(BabelbayLevel *) getLevel:(int)number {
    NSNumber *levelNumber = [NSNumber numberWithInt:number];
    BabelbayLevel *level = [self.levels objectForKey:levelNumber];
    if(!level) {
        level = [[BabelbayLevel alloc] init:number];
        [self.levels setObject:level forKey:levelNumber];
    }
    return level;
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

-(int)levelNumberForSection:(int)section{
    return [(NSNumber *) [self.myWords.levelNumbers objectAtIndex: section] intValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.myWords.levelNumbers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *words = [self.myWords getAllForLevel:[self levelNumberForSection:section]];
    return words.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Word";
    MyWordsUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    int levelNumber =[(NSNumber *) [self.myWords.levelNumbers objectAtIndex: indexPath.section] intValue];
    NSArray *words = [self.myWords getAllForLevel:levelNumber];
    NSNumber *wid = [words objectAtIndex:indexPath.row];
    BabelbayLevel *level = [self getLevel:levelNumber];
    BabelbayWord *word = [level findWord:[wid integerValue ]];
    
    cell.targetLabel.text = [word.translations getText:ar].target;
    cell.nativeLabel.text = [word.translations getText:en].native;
    cell.word = word;
    cell.delegate = self;
    
    
    // Configure the cell...
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Level %@", [self.myWords.levelNumbers objectAtIndex:section]];
}

-(void)myWordsUITableViewCellPlayWordAudio:(BabelbayWord *)word{
    //block__ MyWordsTableViewController *bself = self;
    [self doAsync:^(){return word.audio;} then:^(id aud){ 
        NSError *error;    
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:aud error:&error];//initWithContentsOfURL:url error:&error];
        AVAudioPlayer *audioPlayer = self.audioPlayer;
        audioPlayer.numberOfLoops = 0;
        audioPlayer.delegate = self;
        
        if (audioPlayer == nil)
            NSLog(@"ERROR: %@", [error description]);
        else
            [audioPlayer play];
    }];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)playedSuccessfully {
    self.audioPlayer = nil;
}

-(void)myWordsUITableViewCellRemoveWord:(BabelbayWord *)word{
    [self.myWords remove:word];
    [self.tableView reloadData];
}

/* if you define this method and then comment awakeFromNib() in the UITableCellView - not attach a swipe gesture to it, it shows the
 Delete button
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
     // Delete the row from the data source
     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }   
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }   
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
