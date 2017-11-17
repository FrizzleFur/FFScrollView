//
//  GameInfos.m
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/13.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import "GameInfos.h"

@implementation GameInfos

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if (!isDictionary(dict)) return self;
        self.name = [dict yh_stringForKey:@"name"];
        self.descTitle = [dict yh_stringForKey:@"descTitle"];
        self.descSubTitle = [dict yh_stringForKey:@"descSubTitle"];
        self.avatar = [dict yh_stringForKey:@"avatar"];
        self.roleBanner = [dict yh_stringForKey:@"roleBanner"];
        self.showStar = [dict yh_boolForKey:@"showStar"];
    }
    return self;
}

@end
