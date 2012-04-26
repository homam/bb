//
//  BabelbayLevel.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BabelbayLevel.h"
#import "RXMLElement.h"


@implementation BabelbayText

@synthesize native = _native;
@synthesize target = _target;

-(BabelbayText *)init:(NSString *)native andTarget:(NSString *)target{
    self.native = native;
    self.target = target;
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Text native: %@, target: %@", self.native, self.target];
}


@end


@implementation BabelbayTranslationCollection

@synthesize texts = _texts;
-(NSMutableDictionary *)texts {
    if(!_texts){
        _texts = [[NSMutableDictionary alloc] init];
    }
    return _texts;
}

-(void)addTranslation:(BabelbayText *)text forLang:(BabelbayLanguage)lang{
    [self.texts setObject:text forKey:[NSNumber numberWithInt:lang]];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"TranslationCollection texts: %@", self.texts];
}

@end


@implementation BabelbayWord

@synthesize wid = _wid;
@synthesize translations = _translations;
-(BabelbayTranslationCollection *) translations{
    if(!_translations){
        _translations = [[BabelbayTranslationCollection alloc]init];
    }
    return _translations;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Word Id = %i\n\ttranslations: %@", self.wid, self.translations];
}
    
@end


@implementation BabelbayLevel

@synthesize levelNumber = _levelNumber;
@synthesize words = _words;
-(NSMutableArray *)words {
    if(!_words){
        _words = [[NSMutableArray alloc] init];
    }
    return _words;
}

-(BabelbayLevel *)init:(int)levelNumber{
    _levelNumber = [[NSNumber alloc] initWithInt: levelNumber];
    
    RXMLElement *rootXML = [RXMLElement elementFromXMLFile:@"level1.xml"];
    
    [rootXML iterate:@"steps.step" usingBlock: ^(RXMLElement *step) {
        RXMLElement *word = [step child:@"word"];
        if(word) {
            RXMLElement *translations = [word child:@"translations"];
            BabelbayWord *w = [BabelbayWord alloc];
            w.wid  =  [[word attribute:@"wid"] integerValue];
            [w.translations addTranslation:[[BabelbayText alloc] init:[translations child:@"en"].text andTarget:[translations child:@"en"].text] forLang:en];
            [w.translations addTranslation:[[BabelbayText alloc] init:[[translations child:@"ar"] child:@"x"].text andTarget:[[translations child:@"ar"]child:@"r" ].text] forLang:ar];
            
            [self.words addObject:w];
           // NSLog(@"Word = %@", w);
        }
        //NSLog(@"Player: %@ (#%@)", [player child:@"name"].text, [player attribute:@"number"]);
    }];
    
    
    
    return self;
}

@end
