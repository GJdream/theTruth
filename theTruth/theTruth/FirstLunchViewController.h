//
//  FirstLunchViewController.h
//  theTruth
//
//  Created by cheonhyang on 13-3-5.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLunchViewController : UIViewController
// note that I mistakenly typed FirstLunch instead of FirstLauch
// however all the codes are using FirstLunch
// it is only a little werid to read that
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIView *startGame;
//view that contains the buttons
@property (weak, nonatomic) IBOutlet UIView *welcomeInfo;
//view that contains the words
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;

- (IBAction)continueGame:(id)sender;
//action when pressed on continue button
- (IBAction)startNewGame:(id)sender;
//action when pressed on start a new game button

@end
