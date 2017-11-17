//
//  NSDictionary+Value.h
//  
//
//  Created by Kiefer on 13-4-2.
//  Copyright (c) 2013年 windo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isDictionary(obj) (obj && [obj isKindOfClass:[NSDictionary class]] && (NSNull*)obj != [NSNull null])
#define isArray(obj)      (obj && [obj isKindOfClass:[NSArray class]] && (NSNull*)obj != [NSNull null])
#define isNull(obj)       ((NSNull*)obj == [NSNull null])

@interface NSDictionary (Value)

- (id)yh_objectForKey:(id)aKey;
- (NSDictionary *)yh_dictionaryForKey:(id)aKey;
- (NSArray *)yh_arrayForKey:(id)aKey;
- (NSString *)yh_stringForKey:(id)aKey;
- (int)yh_intForKey:(id)aKey;
- (float)yh_floatForKey:(id)aKey;
- (double)yh_doubleForKey:(id)aKey;
- (BOOL)yh_boolForKey:(id)aKey;
- (NSInteger)yh_integerForKey:(id)aKey;

@end
