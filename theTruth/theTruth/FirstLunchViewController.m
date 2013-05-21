//
//  FirstLunchViewController.m
//  theTruth
//
//  Created by cheonhyang on 13-3-5.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "FirstLunchViewController.h"
#import "CourtViewController.h"


@interface FirstLunchViewController ()

@end

@implementation FirstLunchViewController

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
    NSLog(@"FirstLunchViewController: viewDidload");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Add tap gesture for firstImage and welcomeinfo
    //add the same selector for two is just to guarantee tap on any place on screen can continue
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.firstImage addGestureRecognizer:tap];
    [self.welcomeInfo addGestureRecognizer:tap2];    
}
/************************************************
 ***   method: tapAction:(UITapGestureRecognizer*)gestureRec
 ***   abstract: tapped to make welcome lable go up and show the buttons
 ***   description: actual operations are done by calling welcomInfoGoUp
 *************************************************/
-(void) tapAction:(UITapGestureRecognizer*)gestureRec{
    NSLog(@"FirstLunchViewController: tapAction");
    [self welcomeInfoGoUp];
}

/************************************************
 ***   method: welcomeInfoGoUp
 ***   abstract: make an animation of the words go up out of screen and buttons go up in screen
 ***   description: make animations 
 *************************************************/
-(void) welcomeInfoGoUp{
    NSLog(@"FirstLunchViewController: welcomeInfoGoUp");
    [UIView animateWithDuration:0.5 delay:0.25 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.welcomeInfo.center = CGPointMake(self.welcomeInfo.center.x
                                                               , -100);
                         self.startGame.center = CGPointMake(self.startGame.center.x, 150);
                     }
                     completion:^(BOOL completed){
                         NSLog(@"FirstLunchViewController: Animation completed");
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/************************************************
 ***   method: continueGame:(id)sender
 ***   abstract: action taken when pressed on continue button
 ***   description: go to the CourtViewController and resume the game
 *************************************************/
- (IBAction)continueGame:(id)sender {
    NSLog(@"FirstLaunchViewController: continueGame");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool saved = [[defaults objectForKey:@"saved"] boolValue];
    
    if (saved == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No saved game found" message:@"Please start a new game!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
    }
    else{
        [self goToCourtViewController];
    }
    
    
}
/************************************************
 ***   method: startNewGame:(id)sender
 ***   abstract: actions taken when pressed on start a new game button
 ***   description: rewrite the file in the sandbox make the script be the start of game
 *************************************************/
- (IBAction)startNewGame:(id)sender {
    NSLog(@"FirstLaunchViewController: startNewGame");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
    NSLog(@"FirstLaunchViewController: read file %@",filename);
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    // rewrite the state to be chapter 1 section 1 and sentence 0
    [data setObject:@"1" forKey:@"chapter"];
    [data setObject:@"1" forKey:@"section"];
    [data setObject:@"0" forKey:@"sentence"];    
    [data writeToFile:filename atomically:YES];    
    data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    [self goToCourtViewController];
}
/************************************************
 ***   method: goToCourtViewController
 ***   abstract: go to CourtViewController
 ***   description: go to CourtViewController
 *************************************************/
- (void) goToCourtViewController{
    NSLog(@"FirstLaunchViewController: goToCourtViewController");    
    CourtViewController * cvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"CourtViewController"];
    [self presentViewController:cvc animated:YES completion:^{ NSLog(@"FirstLaunchViewController: Go to CourtViewController");}];
    
}
@end
