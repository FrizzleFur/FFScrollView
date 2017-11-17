//
//  GameInfosTableViewCell.h
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/13.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat bannerWidth = 110;
static const CGFloat bannerHeight = 60;


@class GameInfos;

@protocol GameInfosTableViewCellDelegate;

@interface GameInfosTableViewCell : UITableViewCell

@property (nonatomic, strong) GameInfos *gameInfos;
@property (nonatomic, weak) id <GameInfosTableViewCellDelegate> delegate;

+ (CGFloat)cellHeightWithModel:(GameInfos *)gameInfos cellWidth:(CGFloat)cellWidth;

@end

@protocol GameInfosTableViewCellDelegate <NSObject>

//文案展开
- (void)clickTextExpend:(GameInfos *)selectGameInfos;/**< 点击文案展开收起 */

@end
