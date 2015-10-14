//
//  HYTTableViewRowActionView.h
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/14.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTTableViewRowActionView;

@interface HYTTableViewRowActionView : UIButton

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *backgroundColor; // default background color is dependent on style
@property (nonatomic, copy) UIVisualEffect* backgroundEffect;

+ (instancetype)rowActionViewWithTitle:(NSString *)title handler:(void (^)(HYTTableViewRowActionView *action, NSIndexPath *indexPath))block;

@end
