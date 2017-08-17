//
//  TabView.h
//  MVVM_RAC_Test
//
//  Created by 维奕 on 2017/8/16.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewModel.h"
#import "ReactiveCocoa.h"


@interface TabView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSArray *dataArr;

@property(strong,nonatomic)UITableView *TabV;

@property(strong,nonatomic)ViewModel *viewModel;

@property (nonatomic, strong) RACSubject *cellClickSubject;



@end
