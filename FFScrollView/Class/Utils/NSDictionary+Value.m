//
//  NSDictionary+Value.m
//
//
//  Created by Kiefer on 13-4-2.
//  Copyright (c) 2013年 windo. All rights reserved.
//

#import "NSDictionary+Value.h"

@implementation NSDictionary (Value)

- (id)yh_objectForKey:(id)aKey {
    id obj = [self objectForKey:aKey];
    if (isNull(obj)) return nil;
    return obj;
}

- (NSDictionary *)yh_dictionaryForKey:(id)aKey {
    id object = [self yh_objectForKey:aKey];
    if (!isDictionary(object)) return nil;
    return object;
}

- (NSArray *)yh_arrayForKey:(id)aKey {
    id object = [self yh_objectForKey:aKey];
    if (!isArray(object)) return nil;
    return object;
}

- (NSString *)yh_stringForKey:(id)aKey {
    id obj = [self yh_objectForKey:aKey];
    if (!obj || [obj isEqual:@"null"]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", obj];
}

- (int)yh_intForKey:(id)aKey {
    id obj = [self yh_objectForKey:aKey];
    return [obj intValue];
}

- (float)yh_floatForKey:(id)aKey {
    id obj = [self yh_objectForKey:aKey];
    return [obj floatValue];
}

- (double)yh_doubleForKey:(id)aKey {
    id object = [self yh_objectForKey:aKey];
    return [object doubleValue];
}

- (BOOL)yh_boolForKey:(id)aKey {
    id object = [self yh_objectForKey:aKey];
    return [object boolValue];
}

- (NSInteger)yh_integerForKey:(id)aKey {
    id object = [self yh_objectForKey:aKey];
    return [object integerValue];
}

@end
