//
//  ViewModel.h
//  MVVM_RAC_Test
//
//  Created by 维奕 on 2017/8/16.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

typedef void(^returnBlock)(NSArray *);

@interface ViewModel : NSObject

@property(strong,nonatomic)returnBlock returnBlock;

@property (nonatomic, strong) RACSubject *returnSubject;



@end
