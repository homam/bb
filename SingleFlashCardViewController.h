//
//  SingleFlashCardViewController.h
//  SmilyFace
//
//  Created by Homam Hosseini on 4/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SingleFlashCardViewControllerNavigationDelegate

-(void)nextPage;
-(void)previousPage;

@end

@interface SingleFlashCardViewController : UIViewController

@property (nonatomic) int pageNumber;
@property (nonatomic,weak) NSString *wordInTarget;
@property (nonatomic,weak)NSString *wordInNative;
@property (nonatomic, weak) NSNumber *wid;
@property id<SingleFlashCardViewControllerNavigationDelegate> navigationDelegate;


@end
