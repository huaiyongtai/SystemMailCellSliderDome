//
//  HYTTableViewCell.m
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/9.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import "HYTTableViewCell.h"
#import "UIView+Extension.h"

typedef NS_ENUM(NSInteger, CellMoveDirectionType) {
    CellMoveDirectionHorizontalDefault, //默认移动方向水平
    CellMoveDirectionHorizontalRight,   //移动方向水平向右
    CellMoveDirectionHorizontalLeft = CellMoveDirectionHorizontalDefault //移动方向水平向做
};

typedef NS_ENUM(NSInteger, CellSpreadState) {
    CellSpreadStateDefault,     //默认展开关闭
    CellSpreadStateOpen,        //展开状态打开
    CellSpreadStateDeleteSpread,//展开删除

    CellSpreadStateClose = CellSpreadStateDefault//展开状态关闭
};

@interface HYTTableViewCell ()

/**
 *  上次拖动的位置
 */
@property (nonatomic, assign) CGFloat lastPointX;

/**
 *  Cell的展开状体
 */
@property (nonatomic, assign) CellSpreadState spreadState;

/**
 *  展开的宽度值
 */
@property (nonatomic, assign) CGFloat spreadWidth;

/**
 *  actionView的Rect
 */
@property (nonatomic, assign) CGRect actionViewRect;

/**
 *  contentView的X值
 */
@property (nonatomic, assign) CGFloat contentViewX;

/**
 *  打开ActionView的范围
 */
@property (nonatomic, assign) CGFloat actionViewMin;
@property (nonatomic, assign) CGFloat actionViewMax;

@property (nonatomic, strong) NSArray *rowActionViews;

@end

@implementation HYTTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.width-20, 3, 20, self.contentView.height+50)];
        [view setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:view];
        
        _spreadState = CellSpreadStateDefault;
        
        _actionViewRect = CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, 100, CGRectGetHeight(self.contentView.frame));
        _spreadWidth = [UIScreen mainScreen].bounds.size.width * 0.5;
        _actionViewMin = [UIScreen mainScreen].bounds.size.width * 0.1;
        _actionViewMax = [UIScreen mainScreen].bounds.size.width * 0.8;
        
        
        [self.contentView setBackgroundColor:[UIColor grayColor]];
        [self.contentView setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        //为Cell添加手势
        
        /****************************给tableViewCell添加手势***************************/
        //其他手势都可以，唯不能添加UIPanGestureRecognizer这个手势，将和tableView滑动冲突
//        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGestureRecognizern:)]];
    }
    
    return self;
}

- (NSArray *)rowActionViews {
    if (_rowActionViews == nil) {
        if ([self.delegate respondsToSelector:@selector(tableViewCell:)]) {
            _rowActionViews = [self.delegate tableViewCell:self];
            
            [_rowActionViews enumerateObjectsWithOptions:NSEnumerationReverse
                                              usingBlock:^(UIView *actionView, NSUInteger idx, BOOL *stop) {
                                                  NSAssert([actionView isKindOfClass:[UIView class]], @"%@, %@ 中 加入了一个不是UIView", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                                                  [self addSubview:actionView];
                                              }];
        }
    }
    return _rowActionViews;
}

#pragma mark - touch事件拖动监听
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    UITouch *beginTouch = [touches anyObject];
    CGFloat beginTouchX = [beginTouch locationInView:self].x;
    self.lastPointX = beginTouchX;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *moveTouch = [touches anyObject];
    CGFloat moveTouchX = [moveTouch locationInView:self].x;
    CGFloat delta = moveTouchX - self.lastPointX;
    if (delta == 0) return; //本次移动为0, 不操作
    
    //移动动画
    [self animationMoveBy:delta];
    
    NSLog(@"touchesMoved:touches- delta:%f", delta);
    //设置最后一次移动X
    self.lastPointX = moveTouchX;
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *endTouch = [touches anyObject];
    CGFloat endTouchX = [endTouch locationInView:self].x;
    self.lastPointX = endTouchX;
    
    NSLog(@"%@", NSStringFromSelector(_cmd));

    //拖动结束使用ContentView的最大X值判断是否展开
    CGFloat contentViewMaxX = CGRectGetMaxX(self.contentView.frame);
    
    if (contentViewMaxX < self.actionViewMin) {//self.spreadWidth) {
        self.spreadState = CellSpreadStateDeleteSpread;
    } else if (contentViewMaxX > self.actionViewMin && contentViewMaxX < self.actionViewMax) {
        self.spreadState = CellSpreadStateOpen;
    } else {
        self.spreadState = CellSpreadStateClose;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)setSpreadState:(CellSpreadState)spreadState {
    
    _spreadState = spreadState;

    //动画展示
    CGFloat slideX = 0;
    switch (spreadState) {
        case CellSpreadStateDefault: {
            slideX = 0;
            break;
        }
        case CellSpreadStateOpen: {
            slideX = - self.spreadWidth;
            break;
        }
        case CellSpreadStateDeleteSpread: {
            slideX = -[UIScreen mainScreen].bounds.size.width;
            break;
        }
        default: {
            break;
        }
    }
    [self animationMoveTo:slideX];
}

//在上次的基础上移动deltaX值
- (void)animationMoveBy:(CGFloat)deltaX {
    NSLog(@"animationMoveBy:%f", deltaX);
    [UIView animateWithDuration:0.2 animations:^{
        //修改contentView的Frame
        self.contentView.x += deltaX;
        self.contentViewX = self.contentView.x;;
        //每个ActionView的移动量
        CGFloat moveX = deltaX / self.rowActionViews.count;
        [self.rowActionViews enumerateObjectsUsingBlock:^(UIView *actionView, NSUInteger idx, BOOL *stop) {
            NSAssert([actionView isKindOfClass:[UIView class]], @"HYTTableViewCell-中的rowActionViews不为UIView及子控件");
            
            //ContentView的最大X值判断是否展开
            actionView.x += (moveX * (idx+1));
            
            
            CGFloat contentViewMaxX = CGRectGetMaxX(self.contentView.frame);
            if (contentViewMaxX > self.actionViewMin) {
                actionView.width = 100;
                
            } else {
                actionView.x = CGRectGetMaxX(self.contentView.frame);
                actionView.width = self.width - actionView.x;
            }
            
            self.actionViewRect = actionView.frame;
        }];
    } completion:^(BOOL finished) {
    }];
}

//移动到指定的X值
- (void)animationMoveTo:(CGFloat)loactionX {
    
    //动画展示
    [UIView animateWithDuration:0.2 animations:^{
        //修改contentView的Frame
        self.contentView.x = loactionX;
        self.contentViewX = loactionX;
        NSInteger actionViewsCount = self.rowActionViews.count;
        
        //每个ActionView的移动量
        CGFloat moveX = loactionX / actionViewsCount;
        [self.rowActionViews enumerateObjectsUsingBlock:^(UIView *actionView, NSUInteger idx, BOOL *stop) {
            NSAssert([actionView isKindOfClass:[UIView class]], @"HYTTableViewCell-方法%@中的rowActionViews不为UIView及子控件", NSStringFromSelector(_cmd));
            actionView.x = CGRectGetMaxX(self.contentView.frame) - moveX*((actionViewsCount-1)-idx);
            
//            if () {
//                <#statements#>
//            }
            
//            actionView.width = moveX;
            //ContentView的最大X值判断是否展开
            CGFloat contentViewMaxX = CGRectGetMaxX(self.contentView.frame);
            if (contentViewMaxX < self.actionViewMin && idx == 0) {
                actionView.x = CGRectGetMaxX(self.contentView.frame);
                actionView.width = self.width - actionView.x;
            }
            
            self.actionViewRect = actionView.frame;
        }];
    } completion:^(BOOL finished) {
        
    }];

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
    
    NSLog(@"layoutSubviews contentView-- %@", NSStringFromCGRect(self.contentView.frame));
    
    /**注意
     1.有子控件添加到View上，将调用
     2.当子控件的Width或者Height改变时调用（x, y改变时不调用）
     */
    
    //切记要在这里初始化子控件的位置
    self.contentView.x = self.contentViewX;
        
    [self.rowActionViews enumerateObjectsUsingBlock:^(UIView *actionView, NSUInteger idx, BOOL *stop) {
        NSAssert([actionView isKindOfClass:[UIView class]], @"%@, %@ 中 加入了一个不是UIView", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        
//        if (self.spreadState == CellSpreadStateDeleteSpread) {
//            [UIView animateWithDuration:0.2 animations:^{
//                actionView.frame = self.actionViewRect;
//            } completion:^(BOOL finished) {
//                
////                    actionView.frame = CGRectZero;
//                
//            }];
//            *stop = YES;
//        }
        actionView.frame = self.actionViewRect;
    }];
    
}



@end
