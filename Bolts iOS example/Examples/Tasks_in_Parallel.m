//
//  Tasks_in_Parallel.m
//  Bolts iOS example
//
//  Created by Germán Pereyra on 17/07/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "Tasks_in_Parallel.h"
#import "BFTask.h"
#import "BFTaskCompletionSource.h"

@implementation Tasks_in_Parallel

- (BFTask *)makeSimpleRequest:(NSString *)strUrl{
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSURL *URL = [NSURL URLWithString:@"http://randomword.setgetgo.com/get.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               [completionSource setResult:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                           }];
    return completionSource.task;
}


- (void)test{
    
    NSMutableArray *parallelTasks = [NSMutableArray array];
    __block NSString *partialResults = @"";
    for (int i = 1; i < 5; i++){
        NSLog(@"i is :%li", (long)i);
        switch (i) {
            case 1:
                [parallelTasks addObject:[[self makeSimpleRequest:@""] continueWithBlock:^id(BFTask *task) {
                    partialResults = [partialResults ?: @"" stringByAppendingFormat:@" - %@",task.result];
                    return nil;
                }]];
                break;
            case 2:
                [parallelTasks addObject:[[self makeSimpleRequest:@""] continueWithBlock:^id(BFTask *task) {
                     partialResults = [partialResults ?: @"" stringByAppendingFormat:@" - %@",task.result];
                    return nil;
                }]];
                break;
            case 3:
                [parallelTasks addObject:[[self makeSimpleRequest:@""] continueWithBlock:^id(BFTask *task) {
                     partialResults = [partialResults ?: @"" stringByAppendingFormat:@" - %@",task.result];
                    return nil;
                }]];
                break;
            case 4:
                [parallelTasks addObject:[[self makeSimpleRequest:@""] continueWithBlock:^id(BFTask *task) {
                    partialResults = [partialResults ?: @"" stringByAppendingFormat:@" - %@",task.result];
                    return nil;
                }]];
                break;
            default:
                break;
        }
        
    }
    
    [[BFTask taskForCompletionOfAllTasks:parallelTasks] continueWithBlock:^id(BFTask *task) {
        NSLog(@"%@", partialResults);
        return nil;
    }];
    
    
}
@end
