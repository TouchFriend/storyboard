//
//  NJSelectView.h
//  015 - 简单画板
//
//  Created by 陈显镇 on 2016/9/26.
//  Copyright © 2016年 陈显镇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJSelectViewDelegate.h"
@interface NJSelectView : UIView
@property(nonatomic,weak)UIImage * image;
@property(nonatomic,weak)id<NJSelectViewDelegate> delegate;

@end
