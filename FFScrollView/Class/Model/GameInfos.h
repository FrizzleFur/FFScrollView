//
//  GameInfos.h
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/13.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameInfos : NSObject

@property (nonatomic, copy) NSString *name;/**< 角色名称 */
@property (nonatomic, copy) NSString *descTitle;/**< 角色描述标题 */
@property (nonatomic, copy) NSString *descSubTitle;/**< 角色描述内容 */
@property (nonatomic, copy) NSString *avatar;/**< 角色头像 */
@property (nonatomic, copy) NSString *roleBanner;/**< 角色大图 */
@property (nonatomic, assign) BOOL showStar;/**< 是否标星 */
@property (nonatomic, assign) BOOL isTextDetailExpand;/**< 文案是否展开 */

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
