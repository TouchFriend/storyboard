//
//  NJDrawboardView.h
//  015 - 简单画板
//
//  Created by 陈显镇 on 16/9/21.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NJDrawboardView : UIView
//清屏
- (void)clearScreen;
//撤销
- (void)undo;
//橡皮擦
- (void)eraser:(UIColor *)lineColor;
//改变线宽
- (void)changeLineWidth:(CGFloat)lineWidth;
//改变颜色
- (void)changeLineColor:(UIColor *)lineColor;
@property(nonatomic,weak)UIImage * image;
@property(nonatomic,strong, readonly)UIColor * lineColor;
@end
