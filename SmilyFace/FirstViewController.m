//
//  FirstViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "SingleFlashCardViewController.h"
#import "FlashCardsViewController.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (IBAction)viewAllLevelsTapped:(id)sender {
    [self performSegueWithIdentifier:@"View All Levels" sender:self];
}

- (IBAction)startCurrentLevelTapped:(id)sender {
    [self performSegueWithIdentifier:@"Start Current Level" sender:self];
}

- (IBAction)myWordsTapped:(id)sender {
    [self performSegueWithIdentifier:@"View My Words" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"FirstViewController segue to %@", segue.destinationViewController);
    
    if( [segue.identifier isEqualToString:@"Start Current Level"]){
        FlashCardsViewController *vc = segue.destinationViewController;
        [vc setLevelNumber:2];
    }
}



-(void)awakeFromNib{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:.8 green:.8 blue:.2 alpha:1]]; 

    // background image
    CGRect frame = self.view.frame;
    frame.size.height=200;
    frame.origin.y = self.view.frame.size.height-200;
    UIView *v = [[UIView alloc]initWithFrame:frame];
    v.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"world.jpg"]];
    [self.view insertSubview:v atIndex:0];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
