
//
//  TabView.m
//  MVVM_RAC_Test
//
//  Created by 维奕 on 2017/8/16.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "TabView.h"


@interface TabView ()

@end


@implementation TabView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        
        [self addSubview:self.TabV];
        
    }
    return self;

}

#pragma mark 表格创建
-(UITableView *)TabV{
    if (_TabV==nil) {
        _TabV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _TabV.delegate=self;
        _TabV.dataSource=self;
    }
    return _TabV;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView=[UIView new];
    headView.backgroundColor=[UIColor redColor];
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld---%ld",(long)indexPath.section,(long)indexPath.row);    
  
    
    NSLog(@"%@",self.dataArr[indexPath.row]);
    
    [self.cellClickSubject sendNext:self.dataArr[indexPath.row]];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellStr=@"cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr];
    cell.textLabel.text=self.dataArr[indexPath.row][@"category"];
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    
}



- (RACSubject *)cellClickSubject {
    
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}



@end
