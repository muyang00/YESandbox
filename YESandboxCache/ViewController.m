//
//  ViewController.m
//  YESandboxCache
//
//  Created by yongen on 2019/1/23.
//  Copyright © 2019年 yongen. All rights reserved.
//

#import "ViewController.h"
#import "YESandboxSave.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [YESandboxSave.sharedSandboxSave  insertObject:@[@1, @2] withFileName:@"numArr"];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
