//
//  Simple.m
//  Bolts iOS example
//
//  Created by Germán Pereyra on 17/07/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "Simple.h"
#import "BFTask.h"
#import "BFTaskCompletionSource.h"

@implementation Simple

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

- (BFTask *)getAsync {
    // Let's suppose getNumberAsync returns a BFTask whose result is an NSNumber.
    return [[self makeRequest] continueWithBlock:^id(BFTask *task) {
        // This continuation block takes the NSNumber BFTask as input,
        // and provides an NSString as output.
        
        NSDictionary *dict = task.result;
        return [NSString stringWithFormat:@"%@", dict];
    }];
}

- (void)test{
    
    [[self getAsync] continueWithBlock:^id(BFTask *task) {
        if (task.isCancelled) {
            // the save was cancelled.
        } else if (task.error) {
            // the save failed.
        } else {
            // the object was saved successfully.
            NSLog(@"%@",[task.result class]);
            NSLog(@"%@",task.result);
        }
        return nil;
    }];
}

@end
