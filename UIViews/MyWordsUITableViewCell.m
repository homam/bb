//
//  MyWordsUITableViewCell.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyWordsUITableViewCell.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface MyWordsUITableViewCell()

// testing delete button animation
@property (nonatomic, weak) IBOutlet UIView  *deleteButtonContainerView;
// testing delete button animation
@property (nonatomic, weak) IBOutlet UIButton  *deleteButton;

@end

@implementation MyWordsUITableViewCell

@synthesize targetLabel = _targetLabel;
@synthesize nativeLabel = _nativeLabel;
@synthesize trashButon = _trashButon;
@synthesize word = _word;
@synthesize delegate = _delegate;

// testing delete button animation
@synthesize deleteButton;
// testing delete button animation
@synthesize deleteButtonContainerView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)speakerTapped:(id)sender{
    [self.delegate myWordsUITableViewCellPlayWordAudio:self.word];
}

-(IBAction)trashTapped:(id)sender{
    self.clipsToBounds = YES;
    [UIView animateWithDuration:.8 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
        CGRect frame =  self.frame;
        frame.size.height = 0;
        self.frame = frame;
    } completion:^(BOOL done){
        [self.delegate myWordsUITableViewCellRemoveWord:self.word];
    }];
}

-(void)awakeFromNib{

    // testing delete button animation
    self.deleteButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    CGRect frame = self.deleteButtonContainerView.frame;
    self.deleteButtonContainerView.frame = CGRectMake(frame.origin.x + 42, frame.origin.y, 0, frame.size.height);
    
    UISwipeGestureRecognizer* sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
    [sgr setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:sgr];
    

    // background gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor]CGColor], (id)[[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1]CGColor], nil];
    [self.layer insertSublayer:gradient atIndex: 0];
}

- (void)cellSwiped:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        MyWordsUITableViewCell *cell = (MyWordsUITableViewCell *)gestureRecognizer.view;
        
        [cell animateDeleteButton];
    }
}


// testing delete button animation
-(void)animateDeleteButton{
    CGRect frame = self.deleteButtonContainerView.frame;
    [UIView animateWithDuration:.2 animations:^{
        self.deleteButtonContainerView.frame=  CGRectMake(frame.origin.x-42, frame.origin.y, 42, frame.size.height);
    }];
}

@end
