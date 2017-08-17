//
//  WYHttpRequest.m
//  qiankuang
//
//  Created by 维奕 on 2017/7/28.
//  Copyright © 2017年 维奕. All rights reserved.
//

#import "WYHttpRequest.h"
#import "MBProgressHUD.h"
@implementation WYHttpRequest


+ (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
                WithToken:(NSString *)token
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(void (^)(id data))success
          WithFailurBlock:(void (^)(NSString *error))failure
        WithShowHudToView:(UIView *)view
{
    //状态栏菊花显示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    MBProgressHUD *hub;
    if (view) {
        hub  =   [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"charset=utf-8",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/plain", nil];
    //设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
     manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSString *tokerStr=[NSString stringWithFormat:@"%@",token];
    [manager.requestSerializer setValue:tokerStr forHTTPHeaderField:@"Authorization"];

    switch (method) {
        case GET:{
            //状态栏菊花
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [manager GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (view) {
                    [MBProgressHUD hideHUDForView:view animated:YES];
                }
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                success(dic);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (hub) {
                    [hub hideAnimated:YES afterDelay:0.5];
                }
                NSString *ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSData* errorData = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"错误消息为:%@",dic[@"error"]);
            
//                [WarnWindow WarnText:@"网络连接失败"];
                
            }];
            break;
        }
        case POST:{
            //状态栏菊花
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            [manager POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (view) {
                 [MBProgressHUD hideHUDForView:view animated:YES];
                }
                //代码块传值
                success(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (hub) {
                    [hub hideAnimated:YES afterDelay:0.5];
                }
                NSString *ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                NSData* errorData = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"错误消息为:%@",dic[@"error"]);
                
//                [WarnWindow WarnText:@"网络连接失败"];
                
            }];
            break;
        }
        case DELETE:{
            //状态栏菊花
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [manager DELETE:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (view) {
                    [MBProgressHUD hideHUDForView:view animated:YES];
                }
                success(responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                
//                [WarnWindow WarnText:@"网络连接失败"];
                
            }];
        }break;
        case PUT:{
            [manager PUT:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dict = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:NULL];
                if (success) {
                    //成功的操作
                    NSLog(@"%@",dict);
                    success(dict);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"Error: %@", error);
                // failure(error);
                
//                [WarnWindow WarnText:@"网络连接失败"];
                
            }];
            
            
        }break;
        default:
            break;
    }
}


+(NSData *)imagesSynRequest:(NSString *)urlStr{
    //构建url对象
    NSURL *url=[NSURL URLWithString:urlStr];
    //2.构建请求基本配置
    NSURLRequest *requset=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    //3.链接服务器  请求数据
    //sendSynchronousRequest  同步
    NSError *error = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:requset returningResponse:nil error:&error];
    if (error!=nil) {
        //请求错误
        NSLog(@"%@",error);
    }else{
        return data;
    }
    
    return nil;
}

+(void)postSynRequest:(NSString *)urlStr
   andtimeoutInterval:(NSTimeInterval)times
            andParams:(NSDictionary *)paramDict
          andSucBlock:(SuccessBlock)sucBlock
         andFailBlock:(FailBlock)failBlock
{
    if (urlStr == nil || urlStr.length == 0)
    {
        return;
    }
    //构建url
    NSURL *url = [NSURL URLWithString:urlStr];
    //构建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:times];
    //设置请求类型
    request.HTTPMethod = @"POST";
    //设置参数
    request.HTTPBody = [self dictToData:paramDict];
    
    //第三步，连接服务器
    
    NSError *error = nil;
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error!=nil) {
        //请求错误，调用错误代码块
        failBlock(error);
    }else{
        //请求成功 -- 数据解析-json
        //请求成功---解析数据
        id obj = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:&error];
        if (error) {
            NSLog(@"解析出错！！");
        }else{
            //调用成功代码块
            sucBlock(obj);
        }
    }
}

+(NSData *)dictToData:(NSDictionary *)dict
{
    NSMutableString *paramStr = [NSMutableString new];
    NSArray *allKeys = [dict allKeys];
    //通过遍历，获取字典中的所有key 和 value
    for (int i=0; i<allKeys.count; i++)
    {
        NSString *strKey = allKeys[i];//获取key
        id value = dict[strKey];//通过key 获取值
        //字符串拼接
        NSString *str = [NSString stringWithFormat:@"%@=%@&",strKey,value];
        [paramStr appendString:str];
    }
    //移除字符串中最后一位 &
    NSRange range = NSMakeRange(paramStr.length - 1, 1);
    [paramStr deleteCharactersInRange:range];
    //字符串转成数据流对象
    return [paramStr dataUsingEncoding:NSUTF8StringEncoding];
}



#pragma 监测网络的可链接性
+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}

@end
