
//
//  ViewModel.m
//  MVVM_RAC_Test
//
//  Created by 维奕 on 2017/8/16.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "ViewModel.h"
#import "WYHttpRequest.h"
@implementation ViewModel

-(instancetype)init{
    if (self==[super init]) {
     
        [self Request];
        
    }
    return self;
    
}

-(void)Request{
    
    
    NSString *url=@"http://newsapi.sina.cn/?resource=feed&accessToken=&chwm=3023_0001&city=CHXX0008&connectionType=2&deviceId=3d91d5d90c90486cde48597325cf846b699ceb53&deviceModel=apple-iphone5&from=6053093012&idfa=7CE5628E-577A-4A0E-B9E5-283217ECA1F1&idfv=10E31C9D-59AE-4547-BDEF-5FF3EA045D86&imei=3d91d5d90c90486cde48597325cf846b699ceb53&location=39.998602%2C116.365189&osVersion=9.3.5&resolution=640x1136&token=61903050f1141245bfb85231b58e84fb586743436ceb50af9f7dfe17714ee6f7&ua=apple-iphone5__SinaNews__5.3__iphone__9.3.5&weiboSuid=&weiboUid=&wm=b207&rand=221&urlSign=3c861405dd&behavior=manual&channel=news_pic&lastTimestamp=1473578882&listCount=20&p=1&pullDirection=down&pullTimes=8&replacedFlag=1&s=20";
    
    [WYHttpRequest requestWithMethod:GET WithPath:url WithToken:nil WithParams:nil WithSuccessBlock:^(id data) {
        
        NSLog(@"%@",data);
        NSMutableArray *arr=[NSMutableArray new];
        for (NSDictionary *dic in data[@"data"][@"feed"]) {
            [arr addObject:dic];
        }
        
        NSLog(@"=====%@",arr);
        
        if (self.returnBlock) {
            self.returnBlock(arr);
        }
        

        [self.returnSubject sendNext:arr];
        
    
    } WithFailurBlock:^(NSString *error) {
        
    } WithShowHudToView:nil];
    
    
}


//- (RACSubject *)cellClickSubject {
//    
//    if (!_cellClickSubject) {
//        
//        _cellClickSubject = [RACSubject subject];
//    }
//    
//    return _cellClickSubject;
//}



@end
