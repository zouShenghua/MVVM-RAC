//
//  ViewController.m
//  MVVM_RAC_Test
//
//  Created by 维奕 on 2017/8/11.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "ViewController.h"
#import "WYHttpRequest.h"
#import "ReactiveCocoa.h"
#import "ViewModel.h"
#import "TabView.h"


@interface ViewController ()

@property(strong,nonatomic)TabView *tableView;
@property(strong,nonatomic)ViewModel *viewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.viewModel=self.viewModel;
    
    
    __weak typeof(self)__weakSelf=self;
    _viewModel.returnBlock = ^(NSArray *arr) {
        NSLog(@"%@",arr);
        __weakSelf.tableView.dataArr=arr;
        [__weakSelf.tableView.TabV reloadData];
    };
    
    
    [[_tableView.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
}


-(TabView *)tableView{

    if (_tableView==nil) {
        _tableView=[[TabView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _tableView;
}

-(ViewModel *)viewModel{

    if (_viewModel==nil) {
        _viewModel=[[ViewModel alloc]init];
    }

    return _viewModel;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
