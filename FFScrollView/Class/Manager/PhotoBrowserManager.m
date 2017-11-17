//
//  PhotoBrowserManager.m
//  GlobalScanner
//
//  Created by MichaelMao on 2017/8/9.
//  Copyright © 2017年 xiaojian. All rights reserved.
//

#import "PhotoBrowserManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface PhotoBrowserManager () <UIActionSheetDelegate, UIAlertViewDelegate, MJPhotoBrowserDelegate>

@property (nonatomic, strong) MJPhotoBrowser *browser;
@property (nonatomic, strong) UIImage *previewImage;/**< 要保存的预览图片 */
@property (nonatomic, strong) UIViewController *rootVC;

@end

@implementation PhotoBrowserManager

+ (instancetype)sharedManager {
    static PhotoBrowserManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)showInVc:(UIViewController *)vc imageList:(NSArray *)imageList currentIndex:(NSUInteger)currentIndex srcImageViews:(NSArray *)srcImageViews {
    if (imageList.count == 0) return;
    
    self.browser = [[MJPhotoBrowser alloc] init];
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imageList.count];
    for (int i = 0; i < imageList.count; i++) {
        
        NSString *imageName = imageList[i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = [UIImage imageNamed:imageName]; //图片路径
//        photo.url = [NSURL URLWithString:maxUrl]; //图片路径
        if (i < srcImageViews.count && srcImageViews.count > 0) {
            photo.srcImageView = srcImageViews[i];
        }
        [photos addObject:photo];
    }
    
    self.browser.photos = photos;
    self.browser.currentPhotoIndex = currentIndex;
    self.browser.delegate = self;
    [self.browser show];
}

#pragma mark - MJPhotoBrowserDelegate
// 长按预览图保存图片
- (void)didLongPressGestureInPhoto:(UIImage *)previewImage {
    self.previewImage = previewImage;
    
    UIActionSheet *photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    [photoSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self openSystemSettings];
    }
}


//打开系统设置
- (void)openSystemSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        if (self.previewImage == nil) {
            [self showMessage:@"图片不存在"];
            return;
        }
        UIImageWriteToSavedPhotosAlbum(self.previewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [self showMessage:@"保存成功"];
    } else {
        //查看相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在系统“设置”-“照片”功能中，打开照片访问" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
            [alert show];
        } else {
            [self showMessage:@"保存失败"];
        }
    }
}

- (void)showMessage:(NSString *)message {
    if (self.rootVC) {
        UIAlertController *alertAction = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertAction addAction:action];
        [self.rootVC presentViewController:alertAction animated:YES completion:nil];
    }
}

@end
