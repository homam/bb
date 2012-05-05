//
//  BabelbayLevel.h
//  SmilyFace
//
//  Created by Homam Hosseini on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    en=1,
    ar=2
}BabelbayLanguage;

@interface BabelbayText : NSObject

@property (nonatomic, strong) NSString *native;
@property (nonatomic, strong) NSString *target;

@end


@interface BabelbayTranslationCollection : NSObject

@property (nonatomic, strong) NSMutableDictionary *texts;
-(void)addTranslation:(BabelbayText *)text forLang:(BabelbayLanguage)lang;
-(BabelbayText *)getText:(BabelbayLanguage)lang;

@end


@interface BabelbayWord : NSObject
@property (nonatomic) NSInteger levelNumber;
@property (nonatomic) NSInteger wid;
@property (nonatomic, strong) BabelbayTranslationCollection *translations;
@property (nonatomic, readonly, strong) UIImage *image;
@property (nonatomic, readonly, strong) NSData *audio;
@end



@interface BabelbayLevel : NSObject

@property (nonatomic, strong) NSNumber *levelNumber;
@property (nonatomic, strong) BabelbayTranslationCollection *name;
-(BabelbayLevel *)init:(int)levelNumber;
@property (nonatomic, strong) NSMutableArray *words;
@property (nonatomic) NSUInteger numberOfSteps;

-(BabelbayWord *) findWord:(int)wid;

@end
