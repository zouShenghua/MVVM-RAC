//
//  WYHttpRequest.h
//  qiankuang
//
//  Created by 维奕 on 2017/7/28.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
//请求成功代码块
typedef void(^SuccessBlock)(id obj);
//请求失败代码块
typedef void(^FailBlock)(NSError *error);


typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD,
} HTTPMethod;



@interface WYHttpRequest : NSObject

+ (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
                WithToken:(NSString *)token
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void (^)(id data))success
          WithFailurBlock:(void (^)(NSString *error))failure
        WithShowHudToView:(UIView *)view;

//同步
+(NSData *)imagesSynRequest:(NSString *)urlStr;

//post同步
+(void)postSynRequest:(NSString *)urlStr
   andtimeoutInterval:(NSTimeInterval)times
            andParams:(NSDictionary *)paramDict
          andSucBlock:(SuccessBlock)sucBlock
         andFailBlock:(FailBlock)failBlock;



#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl;



@end
