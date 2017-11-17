//
//  UIImage+DDYExtension.m
//  DDYProject
//
//  Created by Rain Dou on 15/5/18.
//  Copyright © 2015年 634778311 All rights reserved.
//

/**
 *  获取图片元数据(属性信息)需要引入 <AssetsLibrary/AssetsLibrary.h>、<ImageIO/ImageIO.h>
 *
 *
 *
 *
 *
 */

#import "UIImage+DDYExtension.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>

@implementation UIImage (DDYExtension)

#pragma mark - 绘制
#pragma mark 绘制矩形图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制矩形框
+ (UIImage *)rectBorderWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, rect);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制圆形图片
+ (UIImage *)circleImageWithColor:(UIColor *)color radius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, radius*2.0, radius*2.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制圆形框
+ (UIImage *)circleBorderWithColor:(UIColor *)color radius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, radius*2.0, radius*2.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, radius, radius, radius-1, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextStrokePath(context);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark 绘制渐变色图片
+ (UIImage *)gradientImg:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    rect.size.height += 20;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    NSArray *colors = @[(__bridge id)(startColor.CGColor), (__bridge id)(endColor.CGColor)];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path.CGPath);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    return image;
}

#pragma mark - 获取元数据
#pragma mark 获取JPG格式图片元数据
- (NSDictionary *)JPEGmetaData
{
    if (self == nil)
    {
        return nil;
    }
    // 转换成jpegData,信息要多一些
    NSData *jpegData = UIImageJPEGRepresentation(self, 1.0);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpegData, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    CFRelease(source);
    NSDictionary *metaDataInfo = CFBridgingRelease(imageMetaData);
    return metaDataInfo;
}
#pragma mark 获取PNG格式图片元数据
- (NSDictionary *)PNGmetaData
{
    if (self == nil)
    {
        return nil;
    }
    
    NSData *pngData = UIImagePNGRepresentation(self);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)pngData , NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    CFRelease(source);
    NSDictionary *metaDataInfo = CFBridgingRelease(imageMetaData);
    return metaDataInfo;
}

#pragma mark 裁剪成正方形
+ (UIImage *)squareImgFromImg:(UIImage *)image scaledToSize:(CGFloat)newSize
{
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height)
    {
        // 缩放比
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    }
    else
    {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark 将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
    UIGraphicsEndImageContext() ;
    
    return image ;
}

#pragma mark 返回一张不超过屏幕尺寸的 image
- (UIImage *)imageSizeInScreen {
    CGFloat imageWidth = self.size.width;
    CGFloat imageHeight = self.size.height;
    
    if (imageWidth <= DDYSCREENW && imageHeight <= DDYSCREENH) {
        return self;
    }
    CGFloat max = MAX(imageWidth, imageHeight);
    CGFloat scale = max / (DDYSCREENH * 2.0);
    
    CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 拍照后图片旋转或者颠倒解决
+ (UIImage *)ddy_fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark 改变亮度、饱和度、对比度
+ (UIImage *)changeImg:(UIImage *)img Bright:(CGFloat)b saturation:(CGFloat)s contrast:(CGFloat)c
{
    UIImage *myImage = img;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *superImage = [CIImage imageWithCGImage:myImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:superImage forKey:kCIInputImageKey];
    // 修改亮度   -1---1   数越大越亮
    if (b>=-1 && b<=1) { [filter setValue:[NSNumber numberWithFloat:b] forKey:@"inputBrightness"]; }
    // 修改饱和度  0---2
    if (s>=0 && s<=2) { [filter setValue:[NSNumber numberWithFloat:s] forKey:@"inputSaturation"]; }
    // 修改对比度  0---4
    if (c>=0 && c<=4) { [filter setValue:[NSNumber numberWithFloat:c] forKey:@"inputContrast"]; }
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
    myImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return myImage;
}

#pragma mark 图片小圆角裁剪
- (UIImage*)imageCornerRadius:(CGFloat)radius {
    // 半径小于0和大于短边/2.
    radius = radius<0 ? 0 : (MIN(MIN(self.size.width, self.size.height)/2, radius));
    CGRect imageFrame = CGRectMake(0., 0., self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:radius] addClip];
    [self drawInRect:imageFrame];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 {
 CGFloat imageWidth = self.size.width;
 CGFloat imageHeight = self.size.height;
 
 if (imageWidth <= DDYSCREENW && imageHeight <= DDYSCREENH) {
 return self;
 }
 CGFloat max = MAX(imageWidth, imageHeight);
 CGFloat scale = max / (DDYSCREENH * 2.0);
 
 CGSize size = CGSizeMake(imageWidth / scale, imageHeight / scale);
 UIGraphicsBeginImageContext(size);
 [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 return newImage;
 }
 */
#pragma mark 加文字水印
+ (UIImage *)addText:(NSString *)text inImage:(UIImage *)image fontSize:(CGFloat)fontSize angle:(CGFloat)angle endImgSize:(CGSize)endImgSize
{
    // 开启上下文
    UIGraphicsBeginImageContext(endImgSize);
    // 绘制图片
    [image drawInRect:CGRectMake(0, 0, endImgSize.width, endImgSize.height)];
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 旋转
    CGContextRotateCTM(context, angle*M_PI/180);
    // 水印图片
    UIImage *waterMarkImg = [self addText:text fontSize:fontSize angle:angle endImgSize:endImgSize];
    // 绘制水印
    [waterMarkImg drawInRect:CGRectMake(-endImgSize.height, -endImgSize.height, endImgSize.height*4, endImgSize.height*4)];
    // 生成图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 结束画布
    UIGraphicsEndImageContext();
    // 返回图片
    return newImg;
}
#pragma mark 水印图片生成
+ (UIImage *)addText:(NSString *)text fontSize:(CGFloat)fontSize angle:(CGFloat)angle endImgSize:(CGSize)endImgSize {
    // 比例系数
    CGFloat scale = 4;
    // 扩大字体
    CGFloat font = fontSize*1;
    // 正方形画布高宽
    CGFloat wh = MAX(endImgSize.width, endImgSize.height)*scale;
    // 开启画布
    UIGraphicsBeginImageContext(CGSizeMake(wh, wh));
    // 设置颜色
    [[UIColor clearColor] set];
    // 文字size
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:DDYFont(font)}];
    // 文字绘制区域长度
    CGFloat textW = textSize.width+20;
    // 文字绘制区域高度
    CGFloat textH = textSize.height*1.3;
    // 绘制文字
    for (int i=0; i<floor(wh/(font*2)); i++) {
        for (int j=0; j<ceil(wh/textW); j++) {
            [text drawInRect:CGRectMake(textW*j, textH*i, textSize.width, font+4) withAttributes:@{NSFontAttributeName:DDYFont(font), NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        }
    }
    // 生成水印图片
    UIImage *waterMarkImg = UIGraphicsGetImageFromCurrentImageContext();
    // 结束画布
    UIGraphicsEndImageContext();
    // 返回图片
    return waterMarkImg;
}

//+ (UIImage *)addText:(NSString *)text inImage:(UIImage *)image fontSize:(CGFloat)size scaleRate:(CGFloat)scaleRate angle:(CGFloat)angle
//{
//    UIGraphicsBeginImageContext(image.size);
//    // 绘制图片
//    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//    // 获取上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 比例系数
//    CGFloat scale = MAX(1.5*image.size.width/DDYSCREENW, 1.5*image.size.height/DDYSCREENH);
//    // 放大
//    CGContextScaleCTM(context, 1.5, 1.5);
//    // 旋转
//    CGContextRotateCTM(context, M_PI_4);
//    // 移动
//    CGContextTranslateCTM(context,  image.size.width/2., -image.size.height/2.);
//    
//    // 绘制文字
//    NSInteger line = MAX(image.size.width, image.size.height)*3/ 150;
//    NSInteger row = 8;
//    for (int i = 0; i < line; i ++) {
//        for (int j = 0; j < row; j ++) {
//            [text drawInRect:CGRectMake(j * (MIN(image.size.width, image.size.height)/3.5), i*150, 90, 25) withAttributes:@{NSFontAttributeName:DDYFont(40), NSForegroundColorAttributeName:[UIColor redColor]}];
//        }
//    }
//    
//    
//    
//    
//    //4.获取绘制到得图片
//    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
//    //5.结束图片的绘制
//    UIGraphicsEndImageContext();
//    
//    return watermarkImg;
//}

//{
//    //get image width and height
//    int w = image.size.width;
//    int h = image.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create a graphic context with CGBitmapContextCreate
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
//    
//    // 放大
//    CGContextScaleCTM(context, 1.5, 1.5);
//    // 移动
//    CGContextTranslateCTM(context,  image.size.width/2., -image.size.height/2.);
//    // 旋转
//    CGContextRotateCTM(context, M_PI_4);
//    
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
//    const char* textChar = [text UTF8String];
//    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
//    CGContextShowTextAtPoint(context, w/2-strlen(textChar)*5, h/2, textChar, strlen(textChar));
//    //Create image ref from the context
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return [UIImage imageWithCGImage:imageMasked];
//}



//{
//    UIGraphicsBeginImageContext(image.size);
//    // 绘制图片
//    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//    // 获取上下文
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 放大
//    CGContextScaleCTM(context, 1.5, 1.5);
//    // 旋转
//    CGContextRotateCTM(context, M_PI_4);
//    // 移动
//    CGContextTranslateCTM(context,  image.size.width/2., -image.size.height/2.);
//    
//    // 绘制文字
//    NSInteger line = MAX(image.size.width, image.size.height)*3/ 150;
//    NSInteger row = 8;
//    for (int i = 0; i < line; i ++) {
//        for (int j = 0; j < row; j ++) {
//            [text drawInRect:CGRectMake(j * (MIN(image.size.width, image.size.height)/3.5), i*150, 90, 25) withAttributes:@{NSFontAttributeName:DDYFont(40), NSForegroundColorAttributeName:[UIColor redColor]}];
//        }
//    }
//    
//    
//    
//    
//    //4.获取绘制到得图片
//    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
//    //5.结束图片的绘制
//    UIGraphicsEndImageContext();
//    
//    return watermarkImg;
//}

@end
