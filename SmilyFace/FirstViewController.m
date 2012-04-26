//
//  FirstViewController.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "SingleFlashCardViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController


- (IBAction)postAMessagePushed:(id)sender {
    //[self performSegueWithIdentifier:@"ShowSmilyFaceView" sender:self];
    
    id v = [self.storyboard instantiateViewControllerWithIdentifier:@"FlashCardsViewController"];
    
    //id v = [self.storyboard instantiateViewControllerWithIdentifier:@"BigImageViewController"];
    [self.navigationController pushViewController:v animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"FirstViewController segue to %@", segue.destinationViewController);
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
