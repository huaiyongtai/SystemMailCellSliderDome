//
//  HYTTableViewController.m
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/9.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

/**************************TableView编辑与选择**************************
 *
 *  TableView有默认的选择模式(selection mode)（默认开启）、还有一个编辑模式(editing mode)（默认关闭）。两个默认默认只能开启一个
 *  选择模式：可以选择行（默认只能选择一行）
 *  //开始选择模式（默认开启）
 *  @property (nonatomic) BOOL allowsSelection;  // default is YES. Controls whether rows can be selected when not in editing mode
 *
 *  编辑模式：在编辑模式中可实现删除，插入，多选，重排序等。 （Editing. When set, rows show insert/delete/reorder controls based on data source queries）
 *  下列两个方法用来开启编辑模式
 *  @property (nonatomic, getter=isEditing) BOOL editing;      // default is NO. setting is not animated.
 *  - (void)setEditing:(BOOL)editing animated:(BOOL)animated;
 *
 *  当然我们可以更改默认情况（使两个模式共存）
 *  @property (nonatomic) BOOL allowsSelectionDuringEditing;           // default is NO. Controls whether rows can be selected when in editing mode
 *  @property (nonatomic) BOOL allowsMultipleSelection;                // default is NO. Controls whether multiple rows can be selected simultaneously
 *  @property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;   // default is NO. Controls whether multiple rows can be selected simultaneously in editing mode
 *
 *********************************************************************/
#import "HYTTableViewController.h"
#import "HYTTableViewCell.h"
#import "HYTTableViewRowActionView.h"

@interface HYTTableViewController () <HYTTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceDate;

@end

@implementation HYTTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigationController.view
    [self.navigationController.view setBackgroundColor:[UIColor blueColor]];
    //navigationController.navigationBar遮盖在navigationController.view的上面
    [self.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    //navigationController.navigationBar默认是透明色的
    [self.navigationController.navigationBar setTranslucent:NO];
    UIButton *editModel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
    [editModel setTitle:@"编辑" forState:UIControlStateNormal];
//    [editModel addTarget:self action:@selector(tableViewCellEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:editModel]];
    
    self.title = @"仿邮件滑动Cell";
    
    self.dataSourceDate = [NSMutableArray arrayWithArray:@[@"魁拔", @"蛮吉", @"幽冥框", @"大仓", @"卡拉肖克·潘", @"蛮小满", @"雪伦", @"海问香", @"卡拉肖克·玲", @"雷光", @"秋落木"]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];

}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceDate.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CEllID";
    HYTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[HYTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.textLabel.text = self.dataSourceDate[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSArray *)tableViewCell:(HYTTableViewCell *)tableViewCell {
    
    HYTTableViewRowActionView *deleteRowAction = [HYTTableViewRowActionView rowActionViewWithTitle:@"删除"
                                                                                           handler:^(HYTTableViewRowActionView *action, NSIndexPath *indexPath) {
        
                                                                                           }];
    HYTTableViewRowActionView *collectRowAction = [HYTTableViewRowActionView rowActionViewWithTitle:@"快快收藏"
                                                                                           handler:^(HYTTableViewRowActionView *action, NSIndexPath *indexPath) {
                                                                                               
                                                                                           }];
    HYTTableViewRowActionView *topRowAction = [HYTTableViewRowActionView rowActionViewWithTitle:@"置顶"
                                                                                           handler:^(HYTTableViewRowActionView *action, NSIndexPath *indexPath) {
                                                                                               
                                                                                           }];
    
    return @[deleteRowAction, collectRowAction, topRowAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

/**************************编辑概述**************************
 *
 *  左滑动:滑动cell出现右侧删除
 *        tableView:canEditRowAtIndexPath:可不实现（默认是可编辑的）
 *        tableView:commitEditingStyle:forRowAtIndexPath:（必须实现）
 *
 *  编辑模式下：不支持做滑动编辑
 *
 ***********************************************************/

//指定行是否可编辑   If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"正在编辑第selection:%i个的：第%i个Cell", indexPath.section, indexPath.row);
    return YES;
}

//方式一 类似微信、QQ中，且适用于iOS8+
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //设置删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"删除"
                                                                             handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
                                                                                 
                                                                                 [self.dataSourceDate removeObjectAtIndex:indexPath.row];
                                                                                 [tableView deleteRowsAtIndexPaths:@[indexPath]
                                                                                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                                 [tableView reloadRowsAtIndexPaths:@[indexPath]
                                                                                                  withRowAnimation:UITableViewRowAnimationNone];
                                                                             }];
    
    //设置收藏按钮
    UITableViewRowAction *collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                                title:@"快收藏"
                                                                              handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
                                                                                  
                                                                                  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收藏"
                                                                                                                                     message:@"收藏成功"
                                                                                                                                    delegate:self
                                                                                                                           cancelButtonTitle:@"确定"
                                                                                                                           otherButtonTitles:nil, nil];
                                                                                  [alertView show];
                                                                                  [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                                                                                        withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                              }];
    
    //设置置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"置顶"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                              
                                                                              [self.dataSourceDate exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
                                                                              
                                                                              NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
                                                                              [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
                                                                              
                                                                              [tableView reloadRowsAtIndexPaths:@[firstIndexPath, indexPath]
                                                                                               withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                          }];
    
    //    collectRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [deleteRowAction setBackgroundColor:[UIColor redColor]];
    [collectRowAction setBackgroundColor:[UIColor greenColor]];
    [topRowAction setBackgroundColor:[UIColor blueColor]];
    
    return  @[deleteRowAction, collectRowAction, topRowAction];
}
*/

//方式二 滑动删除（只有删除）
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"提交编辑第selection:%i个的：第%i个Cell", indexPath.section, indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        
        NSUInteger row = [indexPath row];
        [self.dataSourceDate removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSUInteger row = [indexPath row];
        //我们实现的是在所选行的位置插入一行，因此直接使用了参数indexPath
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath,nil];
        //同样，将数据加到dataSourceDate中，用的row
        [self.dataSourceDate insertObject:@"新添加的行" atIndex:row];
        [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    }
}
//修改删除按钮文字（默认显示英文Delete，可在project->info->localization加入本地语言即可为中文删除）
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"定制删除按钮文字";
}
*/

//方式三 开启编辑模式 指定编辑项目
/*
//编辑模式开关
- (void)tableViewCellEdit:(UIButton *)editBtn {
    editBtn.selected = !editBtn.selected;
    
    //启动表格的编辑模式(编辑模式开启后无法选择行 tableView:didSelectRowAtIndexPath:方法不会执行
    [self.tableView setEditing:editBtn.selected animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"提交编辑第selection:%i个的：第%i个Cell", indexPath.section, indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView beginUpdates];
        
        NSUInteger row = [indexPath row];
        [self.dataSourceDate removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        NSUInteger row = [indexPath row];
        //我们实现的是在所选行的位置插入一行，因此直接使用了参数indexPath
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:indexPath,nil];
        //同样，将数据加到dataSourceDate中，用的row
        [self.dataSourceDate insertObject:@"新添加的行" atIndex:row];
        [tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    }
}
//修改删除按钮文字（默认显示英文Delete，可在project->info->localization加入本地语言即可为中文删除）
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"定制删除按钮文字";
}
 
//打开编辑模式后，cell的右边会默认出现一个现红的删除按钮编辑样式（本方法的编辑样式为None）
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//这个方法就是执行移动操作的(Override to support rearranging-重新布局 the tableView)
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    id object = [self.dataSourceDate objectAtIndex:fromIndexPath.row];
    [self.dataSourceDate removeObjectAtIndex:fromIndexPath.row];
    [self.dataSourceDate insertObject:object atIndex:toIndexPath.row];
}
 
//这个方法用来告诉表格 indexPath所在的selction的row行是否可以移动,YES右侧会出现默认移动视图，NO不会
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    return YES;
}
*/

@end
