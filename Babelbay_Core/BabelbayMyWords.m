//
//  BabelbayMyWords.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BabelbayMyWords.h"
#import "BabelbayLevel.h"
#import "NSArray+Enumerable.h"

#pragma mark BabelbayMyWords

@interface BabelbayMyWords() 

@property (nonatomic, strong) NSMutableDictionary *datasource;

@end

@implementation BabelbayMyWords

#define MYWORDS_KEY @"BabelbayMyWords.datasource"

NSArray *_levelNumbers;

// update runtime cached instance variables
-(void)changed {
    _levelNumbers = [[[self.datasource allKeys] collect: ^(id o){ 
        return [NSNumber numberWithInt: [(NSString *)o intValue]]; } ] sortedArrayUsingComparator:^(id a, id b){
            return [(NSNumber *)a compare:(NSNumber *)b];
        }];
}

@synthesize datasource = _datasource;
-(NSMutableDictionary *)datasource {
    if(!_datasource){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *ds = nil;
        id cache = [[defaults objectForKey:MYWORDS_KEY] mutableCopy];
        if(cache && [cache isKindOfClass: [NSDictionary class]])
            ds = cache;
        if(!ds) ds= [NSMutableDictionary dictionary];
        _datasource = ds;
    }
    return  _datasource;
}

-(NSMutableArray *)levelArrayByLevelNumber:(int) level{
    NSString *levelNumber = [[NSNumber numberWithInt:level] stringValue];
    NSMutableArray *levelArray = nil;
    id cache = [self.datasource objectForKey:levelNumber];
    if([cache isKindOfClass:[NSArray class]]){
        levelArray = [cache mutableCopy];
    }
    if(!levelArray)
    {
        levelArray = [NSMutableArray array];
    } 
    return levelArray;
}


-(BOOL)add:(BabelbayWord *)word{
    if(word)
    {
        NSString *levelNumber = [[NSNumber numberWithInt:word.levelNumber] stringValue];
        NSNumber *wid = [NSNumber numberWithInt:word.wid];
        NSMutableArray *levelArray = [self levelArrayByLevelNumber:word.levelNumber];
        
        
        for(int i = 0; i<levelArray.count;i++) {
            NSNumber *oldWid = [levelArray objectAtIndex:i];
            if(oldWid){
                if(wid == oldWid){
                    return NO;
                }
            }
        }
        
        [levelArray addObject:wid];
        [self.datasource setValue: (NSArray *) levelArray forKey:levelNumber];
        [self changed];
        [self sync];
        return YES;
    }
    return NO;
}

-(BOOL)remove:(BabelbayWord *)word{
    NSString *levelNumber = [[NSNumber numberWithInt:word.levelNumber] stringValue];
    
    NSMutableArray *levelArray = [self levelArrayByLevelNumber:word.levelNumber];
    
    for(int i = 0; i<levelArray.count;i++) {
        NSNumber *oldWid = [levelArray objectAtIndex:i];
        if(oldWid){
            if(word.wid == [oldWid intValue]){
                [levelArray removeObjectAtIndex:i];
                [self.datasource setValue: (NSArray *) levelArray forKey:levelNumber];
                [self changed];
                [self sync];
                return YES;
                
            }
        }
    }
    
    return NO;
}

-(NSDictionary *)getAll{
    return self.datasource;
}

// returns an array of BabelbayWord s
-(NSArray *)getAllForLevel:(int)levelNumber{
    [[self.datasource allKeys] enumerateObjectsUsingBlock:^(id x, NSUInteger index, BOOL *stop){
        NSLog(@"key = %@, val = %@", x, [self.datasource valueForKey:x]);
    }];    
    return [self.datasource objectForKey:[[NSNumber numberWithInt:levelNumber]stringValue]];
}

-(NSArray *)levelNumbers{
    if(!_levelNumbers) [self changed];
    return _levelNumbers;
}

-(void)sync{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: self.datasource forKey:MYWORDS_KEY];
    [defaults synchronize];
}


@end
