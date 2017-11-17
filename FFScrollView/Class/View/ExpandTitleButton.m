//
//  ExpandTitleButton.m
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/13.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import "ExpandTitleButton.h"

@implementation ExpandTitleButton

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.currentTitle.length > 0) self.titleLabel.right = self.width;
}

@end
