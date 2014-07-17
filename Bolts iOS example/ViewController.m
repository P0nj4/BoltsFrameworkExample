//
//  ViewController.m
//  Bolts iOS example
//
//  Created by Germán Pereyra on 17/07/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ViewController.h"
#import "BFTask.h"
#import "BFTaskCompletionSource.h"

@interface ViewController ()

@end

@implementation ViewController


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
    
    BFTask *successful = [BFTask taskWithResult:responce];
    return successful;
}

- (BFTask *)getAsync {
    // Let's suppose getNumberAsync returns a BFTask whose result is an NSNumber.
    return [[self getMakeRequest] continueWithBlock:^id(BFTask *task) {
        // This continuation block takes the NSNumber BFTask as input,
        // and provides an NSString as output.
        
        NSDictionary *dict = task.result;
        return [NSString stringWithFormat:@"%@", dict];
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
