//
//  UIImage+DDYExtension.h
//  DDYProject
//
//  Created by Rain Dou on 15/5/18.
//  Copyright © 2015年 634778311 All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (DDYExtension)

/** 绘制矩形图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/** 绘制矩形框 */
+ (UIImage *)rectBorderWithColor:(UIColor *)color size:(CGSize)size;

/** 绘制圆形图片 */
+ (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius;

/** 绘制圆形框 */
+ (UIImage *)circleBorderWithColor:(UIColor *)color radius:(CGFloat)radius;

/** 绘制渐变色图片 */
+ (UIImage *)gradientImg:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/** 获取jpg格式图片元数据 */
- (NSDictionary *)JPEGmetaData;

/** 获取png格式图片元数据 */
- (NSDictionary *)PNGmetaData;

/** 裁剪成正方形 */
+ (UIImage *)squareImgFromImg:(UIImage *)image scaledToSize:(CGFloat)newSize;

/** 将UIView转成UIImage */
+ (UIImage *)getImageFromView:(UIView *)theView;

/** 返回一张不超过屏幕尺寸的 image */
- (UIImage *)imageSizeInScreen;

/** 拍照后图片旋转或者颠倒解决 */
+ (UIImage *)ddy_fixOrientation:(UIImage *)aImage;

/** 改变亮度、饱和度、对比度 */
+ (UIImage *)changeImg:(UIImage *)img Bright:(CGFloat)b saturation:(CGFloat)s contrast:(CGFloat)c;

/** 图片小圆角裁剪 */
- (UIImage*)imageCornerRadius:(CGFloat)radius;

/** 加加文字水印 */
+ (UIImage *)addText:(NSString *)text inImage:(UIImage *)image fontSize:(CGFloat)fontSize angle:(CGFloat)angle endImgSize:(CGSize)endImgSize;

@end
