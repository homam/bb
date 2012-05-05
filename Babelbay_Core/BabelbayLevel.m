//
//  BabelbayLevel.m
//  SmilyFace
//
//  Created by Homam Hosseini on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BabelbayLevel.h"
#import "RXMLElement.h"


#pragma mark - BabelbayText

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


#pragma mark - BabelbayTranslationCollection

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

-(BabelbayText *)getText:(BabelbayLanguage)lang{
    return [self.texts objectForKey:[NSNumber numberWithInt:lang]];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"TranslationCollection texts: %@", self.texts];
}

+(BabelbayTranslationCollection *) byRXMLElement: (RXMLElement *)translations{
    BabelbayTranslationCollection *btc = [[BabelbayTranslationCollection alloc] init];
    [btc addTranslation:[[BabelbayText alloc] init:[translations child:@"en"].text andTarget:[translations child:@"en"].text] forLang:en];
    [btc addTranslation:[[BabelbayText alloc] init:[[translations child:@"ar"] child:@"x"].text andTarget:[[translations child:@"ar"]child:@"r" ].text] forLang:ar];
    return btc;
}

@end


#pragma mark - BabelbayWord

@implementation BabelbayWord

@synthesize levelNumber = _levelNumber;
@synthesize wid = _wid;
@synthesize translations = _translations;
-(BabelbayTranslationCollection *) translations{
    if(!_translations){
        _translations = [[BabelbayTranslationCollection alloc]init];
    }
    return _translations;
}

@synthesize image = _image;
-(UIImage *)image {
    if(!_image) {
        NSString *imageName = [NSString stringWithFormat:@"http://mob.babelbay.com/LevelsMedia/Set%i/%i.jpg",self.levelNumber, self.wid]; //[[[NSNumber numberWithInt:self.wid] stringValue] stringByAppendingString:@".jpg"];
        NSURL *imageUrl = [NSURL URLWithString:imageName];
        NSLog(@"Image Url = %@", imageUrl);
        NSData *data = [[NSData alloc] initWithContentsOfURL:imageUrl];
        _image = [[UIImage alloc] initWithData:data];
    }
    return _image;
}

@synthesize audio = _audio;
-(NSData *) audio{
    if(!_audio) {
       // NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mob.babelbay.com/services/tts.ashx?lang=ar&level=%i&gender=&id=%i", self.levelNumber, self.wid]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mob.babelbay.com/LevelsMedia/audio/ar/L-%i/Words/%i.mp3",
                                           self.levelNumber, self.wid]];
        _audio = [[NSData alloc] initWithContentsOfURL:url];
    }
    return _audio;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Word Id = %i\n\ttranslations: %@", self.wid, self.translations];
}
    
@end


#pragma mark - BabelbayLevel

@implementation BabelbayLevel

@synthesize levelNumber = _levelNumber;
@synthesize name = _name;
@synthesize words = _words;
-(NSMutableArray *)words {
    if(!_words){
        _words = [[NSMutableArray alloc] init];
    }
    return _words;
}

@synthesize numberOfSteps;
-(NSUInteger)numberOfSteps{
    return self.words.count;
}

-(BabelbayWord *)findWord:(int)wid{
    __block BabelbayWord *foundWord = nil;
    [self.words enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop){
        BabelbayWord *word = (BabelbayWord *)obj;
        if(word.wid == wid){
            foundWord = word;
            *stop  = YES;
        }
    }];
    return foundWord;
}

-(BabelbayLevel *)init:(int)levelNumber{

    self.levelNumber = [[NSNumber alloc] initWithInt: levelNumber];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat: @"Level%i", levelNumber] ofType:@"xml"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    if (!myData) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"error %@", filePath] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return self;
    }

    
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:myData];
    
    //RXMLElement *rootXML = [RXMLElement elementFromXMLFile:[NSString stringWithFormat:@"level%i.xml", levelNumber]];
    
    [rootXML iterate:@"steps.step" usingBlock: ^(RXMLElement *step) {
        RXMLElement *word = [step child:@"word"];
        if(word) {
            RXMLElement *translations = [word child:@"translations"];
            BabelbayWord *w = [BabelbayWord alloc];
            w.wid  =  [[word attribute:@"wid"] integerValue];
            w.translations = [BabelbayTranslationCollection byRXMLElement:translations];
            w.levelNumber = levelNumber;
            
            [self.words addObject:w];
        }
    }];
    
    RXMLElement *levelInfoXML = [rootXML child:@"levelInfo"];
    self.name = [BabelbayTranslationCollection byRXMLElement:[levelInfoXML child:@"name"]];
    
    
    return self;
}

@end
