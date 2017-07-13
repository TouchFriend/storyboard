//
//  NJSelectView.m
//  015 - 简单画板
//
//  Created by 陈显镇 on 2016/9/26.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import "NJSelectView.h"
@interface NJSelectView () <UIGestureRecognizerDelegate>
@property(nonatomic,weak)UIImageView * imageView;

@end
@implementation NJSelectView
//懒加载
- (UIImageView *)imageView
{
    if(_imageView == nil)
    {
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = self.bounds;
        imageView.userInteractionEnabled = YES;
        _imageView = imageView;
        [self addSubview:imageView];
    }
    return _imageView;
}
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self addGesture];
}
- (void)addGesture
{
    //拖拽手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.imageView addGestureRecognizer:panGesture];
    //捏合手势
    UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    pinchGesture.delegate = self;
    [self.imageView addGestureRecognizer:pinchGesture];
    //旋转手势
    UIRotationGestureRecognizer * rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationActiono:)];
    rotationGesture.delegate = self;
    [self.imageView addGestureRecognizer:rotationGesture];
    //长按手势
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [self.imageView addGestureRecognizer:longPressGesture];
}
//拖调用的方法
- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint  currentP = [panGesture translationInView:panGesture.view];
    panGesture.view.transform = CGAffineTransformTranslate(panGesture.view.transform, currentP.x, currentP.y);
    //复位
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}
//捏合调用的方法
- (void)pinchAction:(UIPinchGestureRecognizer *)pinchGesture
{
    CGFloat scale = pinchGesture.scale;
    pinchGesture.view.transform = CGAffineTransformScale(pinchGesture.view.transform, scale, scale);
    //复位
    pinchGesture.scale = 1;
}
//旋转手势
- (void)rotationActiono:(UIRotationGestureRecognizer *)rotationGesture
{
    rotationGesture.view.transform = CGAffineTransformRotate(rotationGesture.view.transform, rotationGesture.rotation);
    [rotationGesture setRotation:0];
}
//长按调用的方法
- (void)longPressAction:(UILongPressGestureRecognizer *)longPressGesture
{
    [UIView  animateWithDuration:0.5 animations:^{
        longPressGesture.view.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            longPressGesture.view.alpha = 1;
        } completion:^(BOOL finished) {
            //开启上下文
            UIGraphicsBeginImageContext(self.frame.size);
            //将view渲染到上下文中
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.layer renderInContext:context];
            //从上下文中生成一张图片
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            //关闭上下文
            UIGraphicsEndImageContext();

            if([self.delegate respondsToSelector:@selector(selectView:WithImage:)])
            {
                [self.delegate selectView:self WithImage:image];
            }
            //去除view
            [self removeFromSuperview];
        }];
    }];
}
#pragma  mark - gesture的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
