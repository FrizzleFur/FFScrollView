//
//  YHRollTabBar.h
//  GlobalScanner
//
//  Created by MichaelMao on 16/8/18.
//  Copyright © 2016年 xiaojian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YHRollTabBar;
@protocol YHRollTabBarDelegate <NSObject>
@required
- (NSInteger)numberOfRowsInView:(YHRollTabBar *)rollTabBar;
- (NSString *)rollTabBarView:(YHRollTabBar *)rollTabBarView titleForRow:(NSInteger)row;
@optional
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface YHRollTabBar : UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    UIView *_selectLine;
    UIView *_bottomLine;
}

@property(nonatomic, weak) id<YHRollTabBarDelegate> delegate;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) UIFont *titleFont;//标题字号，默认14
@property(nonatomic, assign) CGFloat itemSpacing;
@property(nonatomic, assign) CGFloat sectionLeft;
@property(nonatomic, assign) CGFloat sectionRight;
//@property(nonatomic, assign) BOOL isTitleFontBold;//标题是否是粗体

- (void)reloadData;
- (void)reloadDataToRow:(NSInteger)row;
- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated;

@end
