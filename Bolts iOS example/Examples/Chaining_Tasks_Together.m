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


- (BFTask *)getMakeRequest{
    __block NSDictionary *responce = nil;
    NSURL *URL = [NSURL URLWithString:@"https://api.mercadolibre.com/sites/MLA/search?q=ipod"];
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             URL];
    NSURLResponse *responseRequest;
    NSError *errorRequest;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseRequest error:&errorRequest];
    
    if (errorRequest) {
        return [BFTask taskWithError:errorRequest];
    }
    
    NSError *jsonError;
    NSDictionary *notesJSON =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingAllowFragments
                                      error:&jsonError];
    
    if (jsonError) {
        return [BFTask taskWithError:jsonError];
    }
    
    responce = notesJSON;
    NSLog(@"initial task done");
    BFTask *successful = [BFTask taskWithResult:responce];
    return successful;
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
    
    [[[[self getMakeRequest] continueWithBlock:^id(BFTask *task) {
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
