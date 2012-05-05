//
//  BabelbayMyWords.h
//  SmilyFace
//
//  Created by Homam Hosseini on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BabelbayLevel.h"



@interface BabelbayMyWords : NSObject

-(BOOL)add:(BabelbayWord *) word;
-(BOOL)remove:(BabelbayWord *)word;
-(NSArray *)getAllForLevel:(int) levelNumber; // array of BabelbayWord s
-(NSDictionary *)getAll; // key: NSString (levelNumber), value: mutable array of BabelbayWord
// array if int s
@property (readonly,nonatomic,strong) NSArray *levelNumbers;

@end
