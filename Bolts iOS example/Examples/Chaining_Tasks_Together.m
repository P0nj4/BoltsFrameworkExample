//
//  Chaining_Tasks_Together.m
//  Bolts iOS example
//
//  Created by Germán Pereyra on 17/07/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "Chaining_Tasks_Together.h"
#import "BFTask.h"
#import "BFTaskCompletionSource.h"


@implementation Chaining_Tasks_Together


- (BFTask *)makeRequest{
    
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

- (BFTask *)getAsync:(BFTask *)task {
    NSDictionary *dict = task.result;
    NSLog(@"second task done");
    return [BFTask taskWithResult:[NSString stringWithFormat:@"%@", dict]];
}

- (BFTask *)thirdTask:(BFTask *)task{
    NSLog(@"third task done");
    return task;
}

- (void)test{
    
    [[[[self makeRequest] continueWithBlock:^id(BFTask *task) {
        return [self getAsync:task];
    }] continueWithBlock:^id(BFTask *task) {
        return [self thirdTask:task];
    }] continueWithBlock:^id(BFTask *task) {
            NSLog(@"complitely done");
        if (task.isCancelled) {
            // the save was cancelled.
        } else if (task.error) {
            // the save failed.
        } else {
            // the object was saved successfully.
            NSLog(@"%@",[task.result class]);
            //NSLog(@"%@",task.result);
        }
        return nil;
    }];
}

@end
