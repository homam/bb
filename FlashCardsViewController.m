//
//  FlashCardsViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlashCardsViewController.h"
#import "SingleFlashCardViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "BabelbayLevel.h"
#import "BabelbayMyWords.h"



@interface FlashCardsViewController () <UIScrollViewDelegate,SingleFlashCardViewControllerNavigationDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *contentList;
@property (nonatomic, strong) BabelbayLevel *level;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong,nonatomic) BabelbayMyWords *myWords;


@end

@implementation FlashCardsViewController

@synthesize scrollView;
@synthesize viewControllers = _viewControllers;

@synthesize level = _level;

@synthesize levelNumber = _levelNumber;
-(void)setLevelNumber:(int)levelNumber{
    _levelNumber = levelNumber;
    _level = [[BabelbayLevel alloc] init:self.levelNumber];
    [self setup];
}


//plist content
@synthesize contentList = _contentList;

-(int) currentPage {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return page;
}

BOOL _gestureScrolling = NO;

-(void)loadScrollViewWithPage:(int)page{
    
    // this function will be called several times during scrolling, not necessarilty when the scrolling is finished
    
    if (page < 0 || page >= self.level.numberOfSteps)
        return;
    
    SingleFlashCardViewController *controller = [self.viewControllers objectAtIndex:page];

    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleFlashCardViewController"];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
        controller.navigationDelegate = self;
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        controller.pageNumber = page;
        [self.scrollView addSubview:controller.view];
        
        // set data
        BabelbayWord *word = [self.level.words objectAtIndex:page];
        controller.wordInTarget = [[word translations] getText:ar].target;
        controller.wordInNative = [[word translations] getText:en].native;
        controller.word   = word;

        
        //controller.pageNumber 

    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // if scrolling happened by any mean other than gesture (e.g. pushing back/next buttons)
    if(!_gestureScrolling) return;
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _gestureScrolling =YES;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _gestureScrolling =YES;
}


-(void)setup{
    
    // load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"level1" ofType:@"plist"];
    self.contentList = [NSArray arrayWithContentsOfFile:path];
    
    NSLog(@"contentList.count = %i", self.contentList.count);
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < self.level.numberOfSteps; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    controllers=nil;
    
    NSLog(@"*scrollView.frame.size.height (setup) = %f", scrollView.frame.size.height);
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * self.level.numberOfSteps, scrollView.frame.size.height);//CGSizeMake(360 * self.level.numberOfSteps, 960); //
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * self.level.numberOfSteps, scrollView.frame.size.height);
    

    
    // show and hide the navigation bar
    UITapGestureRecognizer* sgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    sgr.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:sgr];
    
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];

    
    // NSLog(@"frame: (%0f %0f; %0f %0f)", scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
    //NSLog(@"scrollView.contentSize = %@", NSStringFromCGSize(scrollView.contentSize));
    
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    
}

// show and hide the navigation bar
-(void)longPressGesture:(UIGestureRecognizer *) gstr{
    if(gstr.state == UIGestureRecognizerStateEnded){
        [[self navigationController] setNavigationBarHidden:![self navigationController].navigationBarHidden animated:YES];
    }
}

- (void)changePage:(int)page
{
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    _gestureScrolling = NO;
}

-(void)nextPage{
    if(self.currentPage<self.level.numberOfSteps)
    {
        [self changePage:self.currentPage+1];
    }
}

-(void)previousPage{
    if(self.currentPage>0)
    {
        [self changePage:self.currentPage-1];
    }    
}



-(void)viewWillAppear:(BOOL)animated{
    
    // set the contentSize (specifically height)
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * self.level.numberOfSteps, scrollView.frame.size.height);
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}

-(void)awakeFromNib{
    
    [self setup];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// audio player
@synthesize audioPlayer = _audioPlayer;
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)playedSuccessfully {
    self.audioPlayer = nil;
}

//mywords
@synthesize myWords = _myWords;
-(BabelbayMyWords *)myWords{
    if(!_myWords){
        _myWords = [[BabelbayMyWords alloc] init];
    }
    return _myWords;
}


- (IBAction)nextButtonTapped:(id)sender {
    [self nextPage];
}

- (IBAction)backButtonTapped:(id)sender {
    [self previousPage];
}

- (IBAction)speakerButtonTapped:(id)sender {
    // get the controller for the current view in scroller
     SingleFlashCardViewController *controller = [self.viewControllers objectAtIndex:[self currentPage]];
    NSError *error;    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:controller.audioData error:&error];
    AVAudioPlayer *audioPlayer = self.audioPlayer;
    audioPlayer.numberOfLoops = 0;
    audioPlayer.delegate = self;
    
    if (audioPlayer == nil)
        NSLog(@"ERROR: %@", [error description]);
    else
        [audioPlayer play];
}

- (IBAction)addToMyWordsButtonTapped:(id)sender {
    // get the controller for the current view in scroller
    SingleFlashCardViewController *controller = [self.viewControllers objectAtIndex:[self currentPage]];
    [self.myWords add:controller.word];
}

@end
