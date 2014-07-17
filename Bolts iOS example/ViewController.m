//
//  ViewController.m
//  Bolts iOS example
//
//  Created by Germán Pereyra on 17/07/14.
//  Copyright (c) 2014 P0nj4. All rights reserved.
//

#import "ViewController.h"
#import "Simple.h"
#import "Chaining_Tasks_Together.h"
#import "Tasks_in_Parallel.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //[[[Simple alloc] init] test];
    //[[[Chaining_Tasks_Together alloc] init] test];
    [[[Tasks_in_Parallel alloc] init] test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
