//
//  AppDelegate.h
//  YESandboxCache
//
//  Created by yongen on 2019/1/23.
//  Copyright © 2019年 yongen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

