//
//  SmilyView.h
//  SmilyFace
//
//  Created by Homam Hosseini on 4/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SmilyViewDataSource

-(float) getSmiliness;

@end



@interface SmilyView : UIView

@property (nonatomic) float smiliness;

@property (nonatomic) float scale;

@property (nonatomic, weak) IBOutlet id <SmilyViewDataSource> dataSource;

@end


