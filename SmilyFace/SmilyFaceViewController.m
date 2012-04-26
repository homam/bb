//
//  SmilyFaceViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SmilyFaceViewController.h"
#import "SmilyView.h"

@interface SmilyFaceViewController () <SmilyViewDataSource>

@property (nonatomic, weak) IBOutlet SmilyView *smilyView;

@property (nonatomic) float smiliness;

@end

@implementation SmilyFaceViewController

@synthesize smiliness = _smiliness;

-(float)getSmiliness{
    return _smiliness;
}

-(void)setSmiliness:(float)smiliness   {
    if(fabs( smiliness)>2.0)return;
    _smiliness = smiliness;
    [self.smilyView setNeedsDisplay];
    
}

// view:
@synthesize smilyView = _smilyView;

-(void)setSmilyView:(SmilyView *)smilyView{
    _smilyView = smilyView;
    _smilyView.dataSource = self;
    [self.smilyView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.smilyView action:@selector(pinch:)]];
    [self.smilyView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)]];
    
}

-(void)panHandler:(UIPanGestureRecognizer *) gesture{
    
    if(gesture.state == UIGestureRecognizerStateChanged ||
       gesture.state == UIGestureRecognizerStateEnded){
    
        CGPoint translation = [gesture translationInView:self.smilyView];
        self.smiliness += translation.y/200;
        [gesture setTranslation:CGPointZero inView:self.smilyView];
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
