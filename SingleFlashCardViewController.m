//
//  SingleFlashCardViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SingleFlashCardViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "BabelbayMyWords.h"

@interface SingleFlashCardViewController () 

@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordInTargetLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordInNativeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *wordImageView;


@end

@implementation SingleFlashCardViewController 

-(void)downloadAsyncAndExecMain:(NSURL *)url then: (void(^)(NSData *)) continuation{
    dispatch_queue_t downloadQ = dispatch_queue_create("download-image", NULL);
    dispatch_async(downloadQ, ^(void) {
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            continuation(data);
        });
        
    });
    dispatch_release(downloadQ);
}

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


@synthesize navigationDelegate = _navigationDelegate;

@synthesize word = _word;
-(void)setWord:(BabelbayWord *)word{
    _word = word;
    [self doAsync:^(){return word.image;} then:^(id img){ self.wordImageView.image = img; }];
    [self doAsync:^(){return word.audio;} then:^(id aud){ self.audioData = aud; }];
}

@synthesize audioData = _audioData;
@synthesize wordInTargetLabel = _wordInTargetLabel;
@synthesize wordInNativeLabel = _wordInNativeLabel;
@synthesize wordImageView = _wordImageView;
@synthesize pageNumberLabel = _pageNumberLabel;



@synthesize wid = _wid;
-(int)wid{
    return self.word.wid;
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




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.nextButton.backgroundColor = [UIColor blackColor];
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
