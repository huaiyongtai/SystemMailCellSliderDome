//
//  HYTTableViewRowActionView.h
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/14.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTTableViewRowActionView;

@interface HYTTableViewRowActionView : UIView

/**
 *  显示的标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  内容颜色
 */
@property (nonatomic, strong) UIColor *contentColor;

/**
 *  用户自定义View
 */
@property (nonatomic, strong) UIView *customView;



+ (instancetype)rowActionViewWithTitle:(NSString *)title handler:(void (^)(HYTTableViewRowActionView *action, NSIndexPath *indexPath))handler;
- (instancetype)initWithWithTitle:(NSString *)title handler:(void (^)(HYTTableViewRowActionView *action, NSIndexPath *indexPath))handler;
@end
