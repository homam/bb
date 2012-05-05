//
//  MyWordsUITableViewCell.h
//  SmilyFace
//
//  Created by Homam Hosseini on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabelbayLevel.h"

@protocol MyWordsUITableViewCellProtocol <NSObject>

-(void)myWordsUITableViewCellPlayWordAudio:(BabelbayWord *)word;
-(void)myWordsUITableViewCellRemoveWord:(BabelbayWord *)word;

@end

@interface MyWordsUITableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *targetLabel;
@property (nonatomic, weak) IBOutlet UILabel *nativeLabel;
@property (nonatomic, weak) IBOutlet UIButton *trashButon;


@property (nonatomic, weak) BabelbayWord *word;
-(IBAction)speakerTapped:(id)sender;

@property (nonatomic, weak) id <MyWordsUITableViewCellProtocol>  delegate;

// testing delete button animation
-(void)animateDeleteButton;

@end
