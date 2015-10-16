//
//  HYTTableViewRowActionView.m
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/14.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import "HYTTableViewRowActionView.h"

typedef void(^HandlerBlock)(HYTTableViewRowActionView *, NSIndexPath *);

static const CGFloat kContentViewMargin = 10;

@interface HYTTableViewRowActionView ()

@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, assign) HandlerBlock handlerBlock;

@end

@implementation HYTTableViewRowActionView

+ (instancetype)rowActionViewWithTitle:(NSString *)title handler:(void (^)(HYTTableViewRowActionView *action, NSIndexPath *indexPath))handler {
    return [[self alloc] initWithWithTitle:title handler:handler];
}
- (instancetype)initWithWithTitle:(NSString *)title handler:(void (^)(HYTTableViewRowActionView *action, NSIndexPath *indexPath))handler {

    if (self = [super init]) {
        
        _title = title;
        _handlerBlock = handler;
        
        [self.titleView setText:title];
        self.contentView = self.titleView;
        
        [self setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
    }
    return self;
}

- (UILabel *)titleView {
    
    if (_titleView == nil) {
        _titleView = [[UILabel alloc] init];
    }
    return _titleView;
}

- (void)setContentView:(UIView *)contentView {
    
    //移除以前的ContentView
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    
    [self addSubview:contentView];
}
- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    self.contentView = customView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [self.titleView setText:title];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.titleView setTextColor:titleColor];
}
- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    [_titleView setBackgroundColor:contentColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.handlerBlock();
    NSLog(@"%@", self.title);
}

//返回contentView的宽度
- (CGFloat)contentViewWidth {
    if (self.contentView == nil) return 0;
    return self.contentView.bounds.size.width;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (_contentView) {
        //布局子控件
        [_contentView setBackgroundColor:[UIColor redColor]];
        [_contentView sizeToFit];
        [_contentView setFrame:CGRectMake(kContentViewMargin, 0, CGRectGetWidth(_contentView.frame) + kContentViewMargin, CGRectGetHeight(self.frame))];
    }
}

@end
