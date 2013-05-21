//
//  AppDelegate.m
//  theTruth
//
//  Created by cheonhyang on 13-3-5.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];    
    NSLog(@"didFinishLaunchingWithOptions: read file : %@",filename);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    if (data == NULL){
        NSLog(@"didFinishLaunchingWithOptions: file is NULL");
        NSString *plistPathExtra = [[NSBundle mainBundle] pathForResource:@"script" ofType:@"plist"];
        data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPathExtra];
        [data writeToFile: filename atomically:YES];

    }
    else{
        NSLog(@"didFinishLaunchingWithOptions: file is NULL");
        
    } 
    // Override point for customization after application launch.
    
    [self setPreferenceDefaults];
    
    return YES;
}
- (void)setPreferenceDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSDate date] , [NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil] forKeys: [NSArray arrayWithObjects:@"initialRun",@"dev_mode",@"saved", nil]];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    NSLog(@"setPreferenceDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        // Never remind me
        NSLog(@"alertView: Tapped on Don't remind me anymore");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
        [data setObject: [NSNumber numberWithInt:0] forKey:@"rating" ];
        [data writeToFile:filename atomically:YES];
    }
    else if (buttonIndex == 1){
        //rate
        NSLog(@"alertView: Tapped on Rate");
    }
    else if (buttonIndex == 2){
        //remind me later
        NSLog(@"alertView: Tapped on Show me later");
    }
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSNumber *tmp1 = [[NSNumber alloc] initWithInt:[CourtViewController getChapter]];
    NSNumber *tmp2 = [[NSNumber alloc] initWithInt:[CourtViewController getSection]];
    
    NSNumber *tmp3 = [[NSNumber alloc] initWithInt:[CourtViewController getSentence]];
    [data setObject: tmp1 forKey:@"chapter"];
    
    [data setObject: tmp2 forKey:@"section"];
    [data setObject: tmp3 forKey:@"sentence"];
    if (!([tmp1 integerValue]==1 && [tmp2 integerValue] ==1 && [tmp3 integerValue] == 0)){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"saved"];
    }
    [data writeToFile:filename atomically:YES];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    NSLog(@"applicationWillEnterForeground");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    if (data == NULL){
        NSLog(@"applicationWillEnterForeground: Sandbox file is NULL");
        
    }
    else{
        NSLog(@"applicationWillEnterForeground: Sandbox file is read successfully");
        
        int launchnum = [[data objectForKey:@"launchnum"] integerValue];
        int rating = [[data objectForKey:@"rating"] integerValue];
        NSLog(@"Enter foreground data: %@",data);
        NSLog(@"the rating is %d",rating);
        NSLog(@"launchnum is %d and rating is %d more %@",launchnum,rating,[data objectForKey:@"chapter"]);
        launchnum ++;
        if (rating == 1){
            // show the alert view the 3rd time the user run the app
            if (launchnum == 3){
                launchnum = 0;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate our game" message:@"Do you like our games?" delegate:nil cancelButtonTitle:@"Don't remind anymore" otherButtonTitles:@"Rate",@"Remind me later",nil];
                alert.delegate = self;
                [alert show];
            }
            [data setObject: [[NSNumber alloc] initWithInt:launchnum] forKey:@"launchnum" ];
            [data writeToFile:filename atomically:YES];
        }
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //do the same thing with willEnterBackground
    //save the progress variable into the file in the sandbox
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSNumber *tmp1 = [[NSNumber alloc] initWithInt:[CourtViewController getChapter]];
    NSNumber *tmp2 = [[NSNumber alloc] initWithInt:[CourtViewController getSection]];
    
    NSNumber *tmp3 = [[NSNumber alloc] initWithInt:[CourtViewController getSentence]];
    [data setObject: tmp1 forKey:@"chapter"];
    
    [data setObject: tmp2 forKey:@"section"];
    [data setObject: tmp3 forKey:@"sentence"];
    if (!([tmp1 integerValue]==1 && [tmp2 integerValue] ==1 && [tmp3 integerValue] == 0)){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"saved"];
    }
    
    
    
    [data writeToFile:filename atomically:YES];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
