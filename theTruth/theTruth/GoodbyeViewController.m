//
//  GoodbyeViewController.m
//  theTruth
//
//  Created by cheonhyang on 13-3-18.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "GoodbyeViewController.h"
#import "FirstLunchViewController.h"

@interface GoodbyeViewController ()

@end

@implementation GoodbyeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //add gesture for the image
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.goodbyeimage addGestureRecognizer:tap];
}
/************************************************
 ***   method: tapAction: (UITapGestureRecognizer *) tapges
 ***   abstract: actions taken when tapped on the image
 ***   description: just go to the FirstLunchViewController
 *************************************************/
- (void) tapAction: (UITapGestureRecognizer *) tapges{
    NSLog(@"GoodbyeViewController: tapAction");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"GoodbyeViewController: tapAction read file: %@",filename);
    [data setObject: @"1"  forKey:@"chapter"];
    [data setObject: @"1" forKey:@"section"];
    [data setObject: @"0"   forKey:@"sentence"];
    [data writeToFile:filename atomically:YES];
    
    FirstLunchViewController * fvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"FirstLunchViewController"];    
    [self presentViewController:fvc animated:YES completion:^{ NSLog(@"Go to FirstLunchViewController");}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
