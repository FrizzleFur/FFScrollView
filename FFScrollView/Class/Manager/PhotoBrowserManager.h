//
//  PhotoBrowserManager.h
//  GlobalScanner
//
//  Created by MichaelMao on 2017/8/9.
//  Copyright © 2017年 xiaojian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoBrowserManager : NSObject

+ (instancetype)sharedManager;

/**
 *  显示照片浏览器
 *
 *  @param vc            当前viewController
 *  @param imageList     GGJImageComplex数组
 *  @param currentIndex  当前索引
 *  @param srcImageViews 原ImageView数组
 */
- (void)showInVc:(UIViewController *)vc imageList:(NSArray *)imageList currentIndex:(NSUInteger)currentIndex srcImageViews:(NSArray *)srcImageViews;

@end
