//
//  HYTTableViewCell.m
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/9.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import "HYTTableViewCell.h"
#import "UIView+Extension.h"

@interface HYTTableViewCell ()

@property (nonatomic, strong) UILabel *deleteView;

//上次拖动的位置
@property (nonatomic, assign) CGFloat lastPointX;

@property (nonatomic, strong) NSArray *rowActionViews;

@property (nonatomic, assign) CGFloat actionViewWidth;

@end

@implementation HYTTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width-20, 3, 20, self.contentView.height+50)];
        [view setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:view];
        
        [self.contentView setBackgroundColor:[UIColor grayColor]];
        [self.contentView setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        //为Cell添加手势
        
        /****************************给tableViewCell添加手势***************************/
        //其他手势都可以，唯不能添加UIPanGestureRecognizer这个手势，将和tableView滑动冲突
//        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureRecognizern:)]];
    }
    
    return self;
}

- (void)setDelegate:(id<HYTTableViewCellDelegate>)delegate {
    _delegate = delegate;
    
    if ([self.delegate respondsToSelector:@selector(tableViewCell:)]) {
        self.rowActionViews = [self.delegate tableViewCell:self];
    }
}

#pragma mark - touch事件拖动监听
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    UITouch *beginTouch = [touches anyObject];
    CGFloat beginTouchX = [beginTouch locationInView:self].x;
    self.lastPointX = beginTouchX;
    
//    [super touchesBegan:touches withEvent:event];
    [self autoAdjustDisplayPosition];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    [super touchesMoved:touches withEvent:event];

    UITouch *moveTouch = [touches anyObject];
    CGFloat moveTouchX = [moveTouch locationInView:self].x;
    CGFloat delta = moveTouchX - self.lastPointX;
    if (delta == 0) return; //本次移动为0, 不操作
    
    //移动动画
    [self moveByAnimationView:delta];
    
    NSLog(@"touchesMoved:touches- delta:%f", delta);
    //设置最后一次移动X
    self.lastPointX = moveTouchX;
}

- (void)moveByAnimationView:(CGFloat)deltaX {

    [UIView animateWithDuration:0.2 animations:^{
        //修改contentView的Frame
        self.contentView.x = self.contentView.x + deltaX;
        
        //每个ActionView的移动量
        CGFloat moveX = deltaX / self.rowActionViews.count;
        [self.rowActionViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSAssert([obj isKindOfClass:[UIView class]], @"HYTTableViewCell-中的rowActionViews不为UIView及子控件");
            UIView *actionView = (UIView *)obj;
            actionView.x += (moveX * (idx+1));
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)moveToAnimationView:(CGFloat)locationX {
    
    [UIView animateWithDuration:0.2 animations:^{
        //修改contentView的Frame
        self.contentView.x = locationX;
        
        //每个ActionView的移动量
        CGFloat moveX = locationX / self.rowActionViews.count;
        [self.rowActionViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSAssert([obj isKindOfClass:[UIView class]], @"HYTTableViewCell-中的rowActionViews不为UIView及子控件");
            UIView *actionView = (UIView *)obj;
            actionView.x = -locationX + -moveX*(2-idx);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *endTouch = [touches anyObject];
    CGFloat endTouchX = [endTouch locationInView:self].x;
    self.lastPointX = endTouchX;
    [super touchesEnded:touches withEvent:event];
    
    [self moveToAnimationView:-160];
}

#pragma mark - 调整ActionView的显示位置
- (void)autoAdjustDisplayPosition {
    
}

#pragma mark - 手势拖动监听
- (void)dragGestureRecognizern:(UIPanGestureRecognizer *)panGestureRecoginzer {
    
    //本次拖拽偏移量
    CGFloat deltaX = [panGestureRecoginzer translationInView:panGestureRecoginzer.view].x;
    
    
    if (panGestureRecoginzer.state == UIGestureRecognizerStateBegan) {
        
        
    } else if (panGestureRecoginzer.state == UIGestureRecognizerStateChanged) {
        
        self.contentView.x = self.contentView.x + deltaX;
//        [self setFrame:CGRectMake(-50, 100, self.bounds.size.width, self.bounds.size.height)];

    } else if (panGestureRecoginzer.state == UIGestureRecognizerStateEnded) {

        
    }
    
    //清楚本次拖动值
    [panGestureRecoginzer setTranslation:CGPointZero inView:panGestureRecoginzer.view];
}

#pragma mark -
- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSLog(@"layoutSubviews -- %@", NSStringFromCGRect(self.contentView.frame));
    
    
    for (UIView *view in self.rowActionViews) {
//        CGRect rect = view.frame;
//        rect.size.width = self.width;
//        
//        view.frame = rect;

        [view setOrigin:CGPointMake(CGRectGetWidth(self.contentView.frame), 0)];
        [view setSize:CGSizeMake(100, CGRectGetHeight(self.contentView.frame))];
        
        [self addSubview:view];
    }
    
    [self.rowActionViews enumerateObjectsWithOptions:NSEnumerationReverse
                                          usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                              [self addSubview:obj];
                                          }];
    
}



@end
