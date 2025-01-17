//
//  AppDelegate.m
//  掌上科大
//
//  Created by 樊樊帅 on 6/24/15.
//  Copyright (c) 2015 樊樊帅. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKNavController.h"
#import "ZKLoginController.h"
#import "ZKTabBarController.h"
#import <BmobSDK/Bmob.h>
#import "SDWebImageManager.h"
#import "WeiboSDK.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"

@interface AppDelegate () <WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UMSocialData setAppKey:@"559751f067e58e438400466d"];
    [UMSocialConfig showNotInstallPlatforms:nil];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    BmobUser *user = [BmobUser getCurrentUser];
    
    if (user) {
        ZKTabBarController *tabBarController = [[ZKTabBarController alloc] init];
        
        self.window.rootViewController = tabBarController;
    } else {
        ZKLoginController *loginController = [[ZKLoginController alloc] init];
        
        self.window.rootViewController = loginController;
    }
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr.imageCache cleanDisk];
    [mgr.imageCache clearMemory];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])//授权请求
    {
        [MBProgressHUD showMessage:@"正在登录中"];
        
        NSDictionary *dic = @{@"access_token":[(WBAuthorizeResponse *)response accessToken],@"uid":[(WBAuthorizeResponse *)response userID],@"expirationDate":[(WBAuthorizeResponse *)response expirationDate]};
        
        [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject]];
            ZKTabBarController *tabBarController = [[ZKTabBarController alloc] init];
            self.window.rootViewController = tabBarController;
        }];
    }
}

@end
