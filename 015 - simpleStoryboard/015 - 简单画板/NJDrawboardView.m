//
//  NJDrawboardView.m
//  015 - 简单画板
//
//  Created by 陈显镇 on 16/9/21.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import "NJDrawboardView.h"
#import "NJBezierPath.h"
@interface NJDrawboardView ()
@property(nonatomic,strong)NSMutableArray * pathes;
@property(nonatomic,strong)NJBezierPath * path;
@property (nonatomic,assign)CGFloat lineWidth ;

@end
@implementation NJDrawboardView
//懒加载
- (NSMutableArray *)pathes
{
    if(_pathes == nil)
    {
        _pathes = [NSMutableArray array];
    }
    return _pathes;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    self.lineWidth = 1;
    _lineColor = [UIColor blackColor];
}
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    if(panGesture.state == UIGestureRecognizerStateBegan)
    {
        //开始
        CGPoint startP = [panGesture locationInView:self];
        NJBezierPath * path = [NJBezierPath bezierPath];
        [path moveToPoint:startP];
        self.path = path;
        [self.path setLineJoinStyle:kCGLineJoinRound];
        [self.path setLineCapStyle:kCGLineCapRound];
        [self.path setLineWidth:self.lineWidth];
        [self.path setLineColor:self.lineColor];
        [self.pathes addObject:path];
    }
    else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        //移动中
        CGPoint currentP = [panGesture locationInView:self];
        [self.path addLineToPoint:currentP];
        //重绘
        [self setNeedsDisplay];
    }
}
- (void)drawRect:(CGRect)rect
{
    for (NJBezierPath * path in self.pathes) {
        //判断路径的真是数据类型
        if([path isKindOfClass:[UIImage class]])
        {
            UIImage * image = (UIImage *)path;
            [image drawInRect:rect];
        }
        else
        {
            [path.lineColor set];
            [path stroke];
        }

    }
}
- (void)clearScreen
{
    [self.pathes removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}
- (void)undo
{
    [self.pathes removeLastObject];
    //重绘
    [self setNeedsDisplay];
}
- (void)eraser:(UIColor *)lineColor
{
    _lineColor = lineColor;
}
- (void)changeLineWidth:(CGFloat)lineWidth
{
    self.lineWidth = lineWidth;
}
- (void)changeLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.pathes addObject:image];
    //重绘
    [self setNeedsDisplay];
}
@end
