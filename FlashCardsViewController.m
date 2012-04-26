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
#import "BabelbayLevel.h"

static NSUInteger kNumberOfPages = 6;

@interface FlashCardsViewController () <UIScrollViewDelegate,SingleFlashCardViewControllerNavigationDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *contentList;

@end

@implementation FlashCardsViewController

@synthesize scrollView;
@synthesize viewControllers = _viewControllers;
@synthesize contentList = _contentList;

-(int) currentPage {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return page;
}

BOOL _gestureScrolling = NO;

-(void)loadScrollViewWithPage:(int)page{
    
    // this function will be called several times during scrolling, not necessarilty when the scrolling is finished
    
    if (page < 0 || page >= kNumberOfPages)
        return;
    
    SingleFlashCardViewController *controller = [self.viewControllers objectAtIndex:page];

    if ((NSNull *)controller == [NSNull null])
    {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SingleFlashCardViewController"]; //[[SingleFlashCardViewController alloc] init];
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
        
        //read data
         NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        controller.wordInTarget = [numberItem valueForKey:@"ar"];
        controller.wordInNative = [numberItem valueForKey:@"en"];
        controller.wid   = [numberItem valueForKey:@"wid"];

        
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
    
    BabelbayLevel *bblavel = [[BabelbayLevel alloc]init:1];
    
    // load our data from a plist file inside our app bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:@"level1" ofType:@"plist"];
    self.contentList = [NSArray arrayWithContentsOfFile:path];
    
    NSLog(@"contentList.count = %i", self.contentList.count);
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    
    self.viewControllers = controllers;
    controllers=nil;
    
    NSLog(@"*scrollView.frame.size.height (setup) = %f", scrollView.frame.size.height);
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);//CGSizeMake(360 * kNumberOfPages, 960); //
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    // NSLog(@"frame: (%0f %0f; %0f %0f)", scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
    //NSLog(@"scrollView.contentSize = %@", NSStringFromCGSize(scrollView.contentSize));
    
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    
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
    if(self.currentPage<kNumberOfPages)
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
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    
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

@end
