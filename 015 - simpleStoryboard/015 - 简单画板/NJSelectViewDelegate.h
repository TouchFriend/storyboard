//
//  NJSelectViewDelegate.h
//  015 - 简单画板
//
//  Created by 陈显镇 on 2016/9/26.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NJSelectView;
@protocol NJSelectViewDelegate <NSObject>
@optional
- (void)selectView:(NJSelectView *)selectView WithImage:(UIImage *)image;
@end
