//
//  SingleFlashCardViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleFlashCardViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SingleFlashCardViewController ()

- (IBAction)playButtonPressed;
- (IBAction)nextButtonPressed;
- (IBAction)backButtonPressed;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordInTargetLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordInNativeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wordImageView;

@end

@implementation SingleFlashCardViewController

@synthesize navigationDelegate = _navigationDelegate;

@synthesize wordInTargetLabel = _wordInTargetLabel;
@synthesize wordInNativeLabel = _wordInNativeLabel;
@synthesize wordImageView = _wordImageView;
@synthesize pageNumberLabel = _pageNumberLabel;

@synthesize wid = _wid;
-(void) setWid:(NSNumber *)wid{
    _wid = wid;
    self.wordImageView.image = [UIImage imageNamed:[[self.wid stringValue] stringByAppendingString:@".jpg"]];
}

@synthesize wordInTarget = _wordInTarget;
-(void)setWordInTarget:(NSString *)wordInTarget{
    _wordInTarget = wordInTarget;
    self.wordInTargetLabel.text = wordInTarget;
    [self.view setNeedsDisplay];
}

@synthesize wordInNative = _wordInNative;
-(void)setWordInNative:(NSString *)wordInNative{
    _wordInNative = wordInNative;
    self.wordInNativeLabel.text = wordInNative;
}

@synthesize pageNumber = _pageNumber;
-(void)setPageNumber:(int)pageNumber{
    _pageNumber = pageNumber;
    self.pageNumberLabel.text = [[NSString alloc] initWithFormat:@"%i",self.pageNumber];
    [self.view setNeedsDisplay];
}

-(IBAction)playButtonPressed {
    
    NSString *widString =  [self.wid stringValue];
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundUrlRef= CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef) widString, CFSTR("mp3"), NULL);
    
    SystemSoundID soundID; 
    //AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)self.soundUrl, &soundID); 
    AudioServicesCreateSystemSoundID(soundUrlRef, &soundID); 
    AudioServicesPlaySystemSound (soundID);
    
}

- (IBAction)nextButtonPressed {
    [self.navigationDelegate nextPage];
}

- (IBAction)backButtonPressed {
    [self.navigationDelegate previousPage];
}


-(void)viewWillAppear:(BOOL)animated{
   // self.pageNumberLabel.text = [[NSString alloc] initWithFormat:@"%i",self.pageNumber];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setPageNumberLabel:nil];
    [self setWordInTargetLabel:nil];
    [self setWordImageView:nil];
    [self setWordInNativeLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
