//
//  DDYLanguageTool.h
//  FireFly
//
//  Created by LingTuan on 17/9/25.
//  Copyright © 2017年 NAT. All rights reserved.
//

/**
 *  配合NSBundle+DDYExtension 使用
 */

#import <Foundation/Foundation.h>

/** 英汉双语 */
#if TARGET_IPHONE_SIMULATOR
#define DDYStr(Chinese,English) [DDYCurrentLanguage isEqualToString:IOS_9_LATER?@"zh-Hans-US":@"zh-Hans"] ? Chinese : English
#elif TARGET_OS_IPHONE
#define DDYStr(Chinese,English) [DDYCurrentLanguage isEqualToString:IOS_9_LATER?@"zh-Hans-CN":@"zh-Hans"] ? Chinese : English
#endif


extern NSErrorDomain DDYLanguageErrorDomain;
#define kDDYLanguageErrorSuccess       0  // 设置语言成功
#define kDDYLanguageErrorUnknown      -1  // 未知错误
#define kDDYLanguageErrorNil          -2  // 语言为空
#define kDDYLanguageErrorNotSupport   -3  // 不支持的语言

static NSString *const DDY_CN  = @"zh-Hans";
static NSString *const DDY_EN  = @"en";

@interface DDYLanguageTool : NSObject

/** 单例对象 */
+ (instancetype)sharedManager;

/** 获取当前语言 */
- (NSString *)localLanguage;

/** 切换语言(汉英时) */
- (void)changeLanguage;

/** 设置语言(较多语言支持时) */
- (void)setLanguage:(NSString *)language callback:(void (^)(NSError *error))callback;

@end
