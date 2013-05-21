//
//  CourtViewController.h
//  theTruth
//
//  Created by cheonhyang on 13-3-5.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodbyeViewController.h"

@interface CourtViewController : UIViewController <UITableViewDelegate>




//the developerScreen and all the IBActions followed by it are the buttons used for
//developer use and for demo use
- (IBAction)dev_BeforeWinning:(id)sender;
- (IBAction)dev_Restart:(id)sender;
- (IBAction)dev_BeforeAnswer:(id)sender;
- (IBAction)dev_BeforeAutoTable:(id)sender;
- (IBAction)dev_BeforeAsk:(id)sender;
- (IBAction)dev_BeforeEndGame:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *developerScreen;
@property (weak, nonatomic) IBOutlet UIImageView *helperScreen;
//helperScreen is a image covering the whole screen
//it will show up in particular scene and user can swipe up to dismiss it
@property (weak, nonatomic) IBOutlet UIImageView *tipnext;
//tipnext is the little triangle image
//it will show up when the scene is type "story" or "storyshow"
@property (weak, nonatomic) IBOutlet UIImageView *showRecord;
//this is a 65x65 image, when a particular item or person image shows
@property (weak, nonatomic) IBOutlet UITableView *itemRecordTable;
@property (weak, nonatomic) IBOutlet UITableView *personRecordTable;
//these two tables are the court tables
//they are almost the same, but itemRecord's cell is bigger
@property (weak, nonatomic) IBOutlet UIView *tableViewBack;
//this is a transparent black view working as kind of locking view
//it shows up with one of the table above and user taps on it the table and it would disappear

@property (weak, nonatomic) IBOutlet UILabel *answer3;
@property (weak, nonatomic) IBOutlet UILabel *answer2;
@property (weak, nonatomic) IBOutlet UILabel *answer1;
//these three lables are the answers when we are in "answer" type of scene
@property (weak, nonatomic) IBOutlet UILabel *question;
//this it the question label when we are in "answer" type of scene
@property (weak, nonatomic) IBOutlet UIView *blockView;
//this is the view that contains above 4 labels covering the whole screen
//user could swipe left and right to interact with it
@property (weak, nonatomic) IBOutlet UIImageView *background;
//this is the lowest view in the storyboard
//every scene has its image for background
//user could swipe left and right to interact with it
@property (weak, nonatomic) IBOutlet UILabel *name;
//this is the label with character name
@property (weak, nonatomic) IBOutlet UILabel *conversation;
//this is the label that has conversation
//user can tap on it to go to next scene

@property (nonatomic) NSMutableArray *itemRecordData;
@property (nonatomic) NSMutableArray *personRecordData;
//these two are the arrays that contribute to the two tables
@property (nonatomic) bool showRecordNextTime;
//this is to tell the game controller to show the UIImageView showRecord in the next scene
//it is usually NO
//it is set YES when a scene is type of "storyshow"
@property (nonatomic) bool firstShowHelper3;
//this is used for helperScreen of image "helper3"
//this is needed because the scene it need to show is in "ask" loop
//so it would be annoying if the helperScreen shows up more than once

//the property below is all about data
//each scene has its state variables
//all of them stored into data
//then each time the variables in one scene are copied to the following propery
@property (strong,nonatomic) NSMutableArray *data;
@property (strong,nonatomic) NSString *choice1;
@property (strong,nonatomic) NSString *choice2;
@property (strong,nonatomic) NSString *choice3;
@property (strong,nonatomic) NSString *nameContent;
@property (strong,nonatomic) NSString *sentenceContent;
@property (strong,nonatomic) NSString *picture;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *nexttype;
//actually nexttype is deprecated
//this is introduced at first in case of later use
//but turns out to be useless
@property (nonatomic) int rightnextmove;
@property (nonatomic) int nextmove;
@property (nonatomic) int datamethod;
@property (nonatomic) int nextviewcontroller;
@property (nonatomic) int rightchoice;
@property (nonatomic) int wrongnextmove;

//these method is used to get static variable
//used in appDelegate.m
+(int)getChapter;
+(int)getSection;
+(int)getSentence;
@end
