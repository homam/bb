//
//  SingleFlashCardViewController.h
//  SmilyFace
//
//  Created by Homam Hosseini on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabelbayLevel.h"

@protocol SingleFlashCardViewControllerNavigationDelegate

-(void)nextPage;
-(void)previousPage;

@end

@interface SingleFlashCardViewController : UIViewController

@property (nonatomic) int pageNumber;
@property (nonatomic,weak) NSString *wordInTarget;
@property (nonatomic,weak)NSString *wordInNative;
@property (nonatomic, weak) BabelbayWord *word;
@property (nonatomic, readonly) int wid;
@property id<SingleFlashCardViewControllerNavigationDelegate> navigationDelegate;
@property (weak, nonatomic) NSData *audioData;

@end
