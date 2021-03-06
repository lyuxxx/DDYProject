//
//  DDYTools.h
//  DDYProject
//
//  Created by starain on 15/8/8.
//  Copyright © 2015年 Starain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <UIKit/UIKit.h>

@interface DDYTools : NSObject

/** 磁盘总空间 */
+ (CGFloat)ddy_AllSizeOfDiskMbytes;

/** 磁盘可用空间 */
+ (CGFloat)ddy_FreeSizeOfDiskMBytes;

/** 指定路径下某个文件的大小 */
+ (long long)ddy_FileSizeAtPath:(NSString *)filePath;

/** 获取文件夹下所有文件的大小 */
+ (long long)ddy_FolderSizeAtPath:(NSString *)folderPath;

/** 获取字符串(或汉字)首字母 */
+ (NSString *)ddy_FirstCharacterOfString:(NSString *)string;

/** 将字符串数组按照元素首字母顺序进行排序分组 */
+ (NSDictionary *)ddy_SortArray:(NSArray *)array;

/** 保存图片到相册 */
- (void)ddy_SavePicToAlbum:(NSData *)picData;

/** 保存视频到相册 */
- (void)ddy_SaveVideoToAlbum:(NSURL *)videoURL;

/** 多张图片生成gif */
+ (void)ddy_GifWithPic:(NSArray *)pics result:(void(^)(BOOL success, NSURL *path))result;

/** 视频转化gif */
+ (void)ddy_GifWithVideo:(NSURL *)videoURL loopCount:(int)loopCount result:(void(^)(NSURL *path))result;

/** 视频转化gif  */
+ (void)ddy_GifWithVideo:(NSURL *)videoURL frameCount:(int)frameCount delayTime:(float)delayTime loopCount:(int)loopCount result:(void(^)(NSURL *path))result;

/** Touch ID */
+ (void)ddy_TouchIDMessage:(NSString *)message fallBackTitle:(NSString *)title reply:(void(^)(BOOL success, NSError *error))reply;

/** AirDrop */
+ (void)ddy_AirDropShare:(NSString *)fileName currentVC:(UIViewController *)vc;

@end
