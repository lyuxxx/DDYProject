//
//  DDYPulseView.h
//  DDYProject
//
//  Created by LingTuan on 17/10/12.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import <UIKit/UIKit.h>

//------------------------ 圆形视图 ------------------------//
@interface DDYPulseCircleView : UIView

@end

//------------------------ 脉冲视图 ------------------------//
@interface DDYPulseView : UIView

/** 填充颜色 */
@property (nonatomic, strong) UIColor *fillColor;
/** 线条颜色 */
@property (nonatomic, strong) UIColor *strokeColor;
/** 最小圆半径 */
@property (nonatomic, assign) CGFloat minRadius;

/** 创建对象 */
+ (instancetype)pulseView;

/** 开始动画 */
- (void)startAnimation;

/** 结束动画 */
 - (void)stopAnimation;

@end
