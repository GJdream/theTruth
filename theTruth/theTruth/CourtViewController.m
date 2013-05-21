//
//  CourtViewController.m
//  theTruth
//
//  Created by cheonhyang on 13-3-5.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import "CourtViewController.h"
#import "recordCell.h"
#import "itemCell.h"

@interface CourtViewController ()

@end

@implementation CourtViewController
static int chapter;
static int section;
static int sentence;
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
    NSLog(@"CourtViewController: viewDidLoad");    
      //hide the table
    [self initGame];
    [self addGestures];
    [self gameController];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - add gestures
/************************************************
 ***   method: addGestures
 ***   abstract: add gestures to the view in this view controller
 ***   description: various gestures are added to the views, so user could interact with them
 *************************************************/
- (void)addGestures{  
    NSLog(@"CourtViewController: addGestures");
    //add gestures for background and also for the blockview
    //self.background need gesture of swipe left and right to show the record tables
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipe:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipe:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    self.background.userInteractionEnabled = YES;
    [self.background addGestureRecognizer:swipeleft];
    [self.background addGestureRecognizer:swiperight];
    
    //add the same kind gestures to the blockView
    //this is making sure that alos then the blockView is on screen
    //user could get the tables
    UISwipeGestureRecognizer *swipeleft2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipe:)];
    swipeleft2.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swiperight2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(imageSwipe:)];
    swiperight2.direction = UISwipeGestureRecognizerDirectionRight;
    self.blockView.userInteractionEnabled = YES;
    [self.blockView addGestureRecognizer:swipeleft2];
    [self.blockView addGestureRecognizer:swiperight2];    
    
    //add gesture for tableviewback
    //tableviewback is the half transparent black view along with a record table
    //so when tap on this tableviewback the table(either itemRecordTable or personRecordTable)
    //  should be dismissed
    UITapGestureRecognizer *tapges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableviewBack:)];
    self.tableViewBack.userInteractionEnabled = YES;
    [self.tableViewBack addGestureRecognizer:tapges2];
    
    //add gesture for helperScreen
    //helperScreen shows up in particular scene, so when user swipe up they can get rid of
    // helperScreen and continue to play
    UISwipeGestureRecognizer *swipeup3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpHelperScreen:)];
    self.helperScreen.userInteractionEnabled = YES;
    swipeup3.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer * swipedown3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGetDeveloperMode:)];
    swipedown3.direction = UISwipeGestureRecognizerDirectionDown;
    [self.helperScreen addGestureRecognizer:swipeup3];
    [self.helperScreen addGestureRecognizer:swipedown3];
    
     //add gesture for label converstion
    //user tap on conversation(UILabel) we should go to next scene
    UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapConversation:)];
    self.conversation.userInteractionEnabled = YES;
    [self.conversation addGestureRecognizer:tapges];
    
    //add gesture for answer
    //usually we have three answers sometime only first two are used
    //add tap gestures for them  so user can choose a question by tapping them
    UITapGestureRecognizer *tapOnAnswer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswer:)];
    UITapGestureRecognizer *tapOnAnswer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswer:)];
    UITapGestureRecognizer *tapOnAnswer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnswer:)];    
    self.answer1.userInteractionEnabled = YES;
    self.answer2.userInteractionEnabled = YES;
    self.answer3.userInteractionEnabled = YES;
    [self.answer1 addGestureRecognizer:tapOnAnswer1];
    [self.answer2 addGestureRecognizer:tapOnAnswer2];
    [self.answer3 addGestureRecognizer:tapOnAnswer3];
    
    //add gesture for the developer view
    UISwipeGestureRecognizer *swipedown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGetDeveloperMode:)];
    swipedown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.background addGestureRecognizer:swipedown];
    UISwipeGestureRecognizer *swipedown2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGetDeveloperMode:)];
    swipedown2.direction = UISwipeGestureRecognizerDirectionDown;
    [self.blockView addGestureRecognizer:swipedown2];
    UISwipeGestureRecognizer *swipeup = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpGetOutDeveloperMode:)];
    swipeup.direction = UISwipeGestureRecognizerDirectionUp;
    self.developerScreen.userInteractionEnabled = YES;
    [self.developerScreen addGestureRecognizer:swipeup];
    
}
#pragma mark - gesture implement
/************************************************
 ***   method: swipeUpGetDeveloperMode
 ***   abstract: to show the developerScreen
 ***   description: when user swipe up on background or blockview the developerScreen will show up
                    this only happened when user turned the develop mode on in settings
 *************************************************/
-(void) swipeDownGetDeveloperMode: (UISwipeGestureRecognizer *) swipeGesture{
    NSLog(@"CourtViewController: swipeDownGetDeveloperMode");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool developOn = [[defaults objectForKey:@"dev_mode"] boolValue];
    if (developOn == YES){
        self.developerScreen.hidden = NO;
        self.developerScreen.center = CGPointMake(284, -150);
        [UIView animateWithDuration:0.5 animations:^{
            self.developerScreen.center = CGPointMake(284, 150);
                            }];
    }
}
/************************************************
 ***   method: swipeUpGetOutDeveloperMode
 ***   abstract: swipe up to get rid of develoer mode
 ***   description: back to game
 *************************************************/
-(void) swipeUpGetOutDeveloperMode: (UISwipeGestureRecognizer *) swipeUp{
    NSLog(@"CourtViewController: swipeUpGetOutDeveloperMode");
    self.developerScreen.center = CGPointMake(284, 150);
    [UIView animateWithDuration:0.5 animations:^{
        self.developerScreen.center = CGPointMake(284, -150);
    }   completion:^(BOOL completed){
            self.developerScreen.hidden = YES;
            }];
}
/************************************************
 ***   method: tapConversation
 ***   abstract: the action when user tap on UILable conversation
 ***   description: when user tap on it it means that we need to go to next scene
 *************************************************/
- (void) tapConversation: (UITapGestureRecognizer *) tapGesture{
   
    NSLog(@"CourtViewController: tapConversation");
    [self movenext];
}
/************************************************
 ***   method: tapHelperScreen:(UITapGestureRecognizer *) tapGestrue
 ***   abstract: the action when user swipe up on the helperScreen
 ***   description: when user does so the UIImageView helperScreen should go up and disapprea
 *************************************************/
- (void) swipeUpHelperScreen: (UITapGestureRecognizer *) tapGestrue{
    NSLog(@"CourtViewController: tapHelperScreen");
    self.helperScreen.center = CGPointMake(284, 150);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.helperScreen.center = CGPointMake(284, -150);
                     }
                     completion:^(BOOL completed){
                          self.helperScreen.hidden = YES;
                         NSLog(@"CourtViewController: tapHelperScreen : Animation completed");
                     }];
}
/************************************************
 ***   method: tapTableviewBack
 ***   abstract: action when user tap on tableviewback
 ***   description: when user does so, table and tableviewback should go out of screen
 *************************************************/
- (void) tapTableviewBack: (UITapGestureRecognizer *) tapGesture{
    NSLog(@"CourtViewController: tapTableviewBac");
    //when itemRecordTable is showing 
    if (self.itemRecordTable.hidden == NO){        
        self.itemRecordTable.center = CGPointMake(164,self.itemRecordTable.center.y);
        self.tableViewBack.center = CGPointMake(360+88, 150);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{                             
                             self.itemRecordTable.center = CGPointMake(-164,self.itemRecordTable.center.y);
                             self.tableViewBack.center = CGPointMake(688, 150);
                         }
                         completion:^(BOOL completed){
                             NSLog(@"CourtViewController: tapTableviewBac: Animation completed");
                         }];
    }
    //when personRecord is showing 
    else if (self.personRecordTable.hidden == NO){        
        self.personRecordTable.center = CGPointMake(404,self.personRecordTable.center.y);
        self.tableViewBack.center = CGPointMake(120, 150);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{                             
                             self.personRecordTable.center = CGPointMake(480+88+164,self.personRecordTable.center.y);
                             self.tableViewBack.center = CGPointMake(-120, 150);
                         }
                         completion:^(BOOL completed){
                             NSLog(@"CourtViewController: tapTableviewBac: Animation completed");
                         }];
        
    }
}
/************************************************
 ***   method: tapAnswer: (UITapGestureRecognizer *) tapGesture
 ***   abstract: action when user tap on answers
 ***   description: check if the user choose the right answer
 *************************************************/
- (void) tapAnswer: (UITapGestureRecognizer *) tapGesture{
    NSLog(@"CourtViewController: tapAnswer");
    int selected = 0;
    if (tapGesture.view == self.answer1 ){
        NSLog(@"CourtViewController: tapAnswer: answer 1");
        selected = 1;
    }
    else if (tapGesture.view == self.answer2 ){
        NSLog(@"CourtViewController: tapAnswer: answer 2");
        selected = 2;
    }
    else if (tapGesture.view == self.answer3 ){
        NSLog(@"CourtViewController: tapAnswer: answer 3");
        selected = 3;
    }
    
    //check if it is the right answer
    //right
    if (self.rightchoice == selected){
        NSLog(@"CourtViewController: tapAnswer: right answer");
        [self movenext];
    }
    //wrong
    else{
        sentence = self.wrongnextmove;
        NSLog(@"CourtViewController: tapAnswer: wrong answer");
        [self gameController];
    }    
}
/************************************************
 ***   method: imageSwipe: (UISwipeGestureRecognizer *) swipeG
 ***   abstract: action when user swipe on background and on blockview
 ***   description: swiping left shows personRecordTable swiping right shows itemRecordTable
 *************************************************/
-(void) imageSwipe: (UISwipeGestureRecognizer *) swipeG{
    NSLog(@"CourtViewController: imageSwipe");
    if ([swipeG direction] == UISwipeGestureRecognizerDirectionRight){
        NSLog(@"CourtViewController: imageSwipe : swipe right");
        self.personRecordTable.hidden = YES;
        self.itemRecordTable.hidden = NO;
        self.tableViewBack.hidden = NO;
        self.itemRecordTable.center = CGPointMake(-164,self.itemRecordTable.center.y);
        self.tableViewBack.center = CGPointMake(688, 150);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.itemRecordTable.center = CGPointMake(164,self.itemRecordTable.center.y);
                             self.tableViewBack.center = CGPointMake(360+88, 150);
                         }
                         completion:^(BOOL completed){
                             NSLog(@"CourtViewController: imageSwipe : Animation completed");
                         }];
        
    }
    else if([swipeG direction] == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"CourtViewController: imageSwipe : swipe left");
        self.itemRecordTable.hidden = YES;
        self.personRecordTable.hidden = NO;
        self.tableViewBack.hidden = NO;        
        self.personRecordTable.center = CGPointMake(480+88+164,self.personRecordTable.center.y);
        self.tableViewBack.center = CGPointMake(-120, 150);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.personRecordTable.center = CGPointMake(404,self.personRecordTable.center.y);
                             self.tableViewBack.center = CGPointMake(120, 150);
                         }
                         completion:^(BOOL completed){
                             NSLog(@"CourtViewController: imageSwipe :Animation completed");
                         }];         
    }    
    
}

#pragma mark - view methods
/************************************************
 ***   method: updateScreen
 ***   abstract: main operations to update the screen
 ***   description: it works like redraw the screen
                    show the data change on the screen
 *************************************************/
- (void) updateScreen{
    NSLog(@"CourtViewController: updateScreen");
    //check if it's CG model
    if ([self.type isEqual: @"cg"]){
        //Make the name and converstion invisible
        self.developerScreen.hidden = YES;
        self.name.hidden = YES;
        self.conversation.hidden = YES;
        self.question.hidden = YES;
        self.answer1.hidden = YES;
        self.answer2.hidden = YES;
        self.answer3.hidden = YES;
        self.blockView.hidden = YES;
        self.itemRecordTable.hidden = YES;
        self.personRecordTable.hidden = YES;
        self.tableViewBack.hidden = YES;
        self.showRecord.hidden = YES;
        self.tipnext.hidden = YES;
        self.helperScreen.hidden = YES;
    }
    else if ([self.type isEqualToString:@"answer"]){
        self.developerScreen.hidden = YES;
        self.name.hidden = YES;
        self.conversation.hidden = YES;
        self.question.hidden = NO;
        self.answer1.hidden = NO ;
        self.answer2.hidden = NO;
        self.answer3.hidden = NO;
        self.blockView.hidden = NO;
        
        self.itemRecordTable.hidden = YES;
        self.personRecordTable.hidden = YES;
        self.tableViewBack.hidden = YES;
        self.question.text = self.sentenceContent;
        self.answer1.text = self.choice1;
        self.answer2.text = self.choice2;
        self.answer3.text = self.choice3;
        self.tipnext.hidden = YES;
        //if the third choice is Null
        //we don't need to show the third lable
        if ([self.choice3 isEqualToString:@"Null"]){
            self.answer3.hidden = YES;
        }
        self.showRecord.hidden = YES;        
        self.helperScreen.hidden = YES;
    }
    else if ([self.type isEqualToString:@"story"] || [self.type isEqualToString:@"storyshow"] || [self.type isEqualToString:@"ask"])
    {
        //update name and conversation
        self.developerScreen.hidden = YES;
        self.tipnext.hidden = NO;
        self.name.hidden = NO;
        self.conversation.hidden = NO;
        self.question.hidden = YES;
        self.answer1.hidden = YES;
        self.answer2.hidden = YES;
        self.answer3.hidden = YES;
        self.blockView.hidden = YES;        
        self.itemRecordTable.hidden = YES;
        self.personRecordTable.hidden = YES;
        self.tableViewBack.hidden = YES;
        self.helperScreen.hidden = YES;        
        self.name.text = self.nameContent;
        self.conversation.text = self.sentenceContent;
        //check if we need to make UIImageView showRecord visible
        if (self.showRecordNextTime == YES){
            self.showRecordNextTime = NO;
            self.showRecord.hidden = NO;            
        }
        else{
            self.showRecord.hidden = YES;
        }
        if ([self.type isEqualToString:@"storyshow"]){
            self.showRecordNextTime = YES;
        }
    }
    else{
        self.showRecord.hidden = YES;
        self.blockView.hidden = YES;
        NSLog(@"CourtViewController: updateScreen we encounter a bug");
    }
 
    //load image
    NSString *imagePath = [[NSBundle mainBundle] pathForResource: self.picture ofType:@"png"];
    NSLog(@"CourtViewController: updateScreen : load background image:%@",imagePath);
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    self.background.image = image;
}

/************************************************
 ***   method: checkAutoShowTable
 ***   abstract: this method is trying to auto show the table
 ***   description: sometimes we require the user to select a record in the table
                    so we automatically show it up instead of requiring user to do so
 *************************************************/
- (void) checkAutoShowTable{
    NSLog(@"CourtViewController: checkAutoShowTalbe");
    if (chapter == 1 && section == 4 && sentence == 169){
        NSLog(@"CourtViewController: checkAutoShowTable : auto show table");
        self.itemRecordTable.hidden = NO;
        self.tableViewBack.hidden = NO;
        self.itemRecordTable.center = CGPointMake(-164,self.itemRecordTable.center.y);
        self.tableViewBack.center = CGPointMake(688, 150);
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.itemRecordTable.center = CGPointMake(164,self.itemRecordTable.center.y);
                             self.tableViewBack.center = CGPointMake(360+88, 150);
                         }
                         completion:^(BOOL completed){
                             NSLog(@"CourtViewController: checkAutoShowTable : Animation completed");
                         }];
    }
}
/************************************************
 ***   method: checkHelperScreen
 ***   abstract: check if we need to make helperScreen visible in a certain scene
 ***   description: for particular scene instruction information needs to be shown
                    this method checks if we need to do so for a scene
 *************************************************/
-(void) checkHelperScreen{
    NSLog(@"CourtViewController: checkHelperScreen");
        // we have three cases to show the instruction
    if (chapter == 1 && section == 1 && sentence == 10){
        self.helperScreen.hidden = NO;
        self.conversation.userInteractionEnabled = NO;
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:  @"helper1" ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        self.helperScreen.image = image;
        self.helperScreen.center = CGPointMake(284, -150);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.helperScreen.center = CGPointMake(284, 150);
                         }
                         completion:^(BOOL completed){
                             
                             self.conversation.userInteractionEnabled = YES;
                         }];
    }
    else if (chapter == 1 && section == 2 && sentence == 21){
        self.helperScreen.hidden = NO;        
        self.conversation.userInteractionEnabled = NO;
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:  @"helper2" ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        self.helperScreen.image = image;
        self.helperScreen.center = CGPointMake(284, -150);
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.helperScreen.center = CGPointMake(284, 150);
                         }
                         completion:^(BOOL completed){
                             self.conversation.userInteractionEnabled = YES;
                         }];
    }
    else if (chapter == 1 && section == 4 && sentence == 26){
        if (self.firstShowHelper3 == YES){
            self.firstShowHelper3 = NO;
            self.helperScreen.hidden = NO;
            self.conversation.userInteractionEnabled = NO;
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:  @"helper3" ofType:@"png"];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
            self.helperScreen.image = image;
            self.helperScreen.center = CGPointMake(284, -150);
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.helperScreen.center = CGPointMake(284, 150);
                         }
                         completion:^(BOOL completed){
                             self.conversation.userInteractionEnabled = YES;
                         }];
        }
    }
    
    
}

/************************************************
 ***   method: movenext
 ***   abstract: move to the next scene
 ***   description: since the game is made up of many scenes
                    so movenext simply moves it to the next scene
                    and the variables in current scene may indicate how to go to next scene
                    movenext use self.nextmove as the next scene
 *************************************************/
-(void) movenext{
    NSLog(@"CourtViewController: movenext");
    //if it's still in CourtViewController
    //nextviewcontroller = 1 means we stay in CourtViewController
    if (self.nextviewcontroller == 1){
        // section stay  not changed
        // datamethod = 1 means we stay in the same section
        if (self.datamethod == 1){
            sentence = self.nextmove;
            //if it's a cg then delay then go to next step
            if ([self.type isEqualToString:@"cg"]){
                
                [self performSelector:@selector(gameController) withObject:self afterDelay:0.5];
            }
            else if ([self.type isEqualToString:@"story"] || [self.type isEqualToString:@"answer"]
                     || [self.type isEqualToString:@"ask"] || [self.type isEqualToString:@"storyshow"] ){
                [self gameController];
            }
        }
        //datamethod = 2 means we go to next section
        // increase section reload the self.data from next section script
        else if (self.datamethod == 2){
            NSLog(@"CourtViewController: movenext : change section");
            int intsection = section;
            intsection ++;
            sentence = 0;
            section = intsection;
            [self readScriptX];//read the new script and load it into self.data
            [self gameController];//update data and refresh the screen
        }        
    }
    //it's going to anthor view controller
    //going to goodbye view controller
    // nextviewcontroller =2 means we need to go to GoodbyeViewController
    else if (self.nextviewcontroller == 2){
        GoodbyeViewController * gvc = [[self storyboard] instantiateViewControllerWithIdentifier:@"GoodbyeViewController"];        
        [self presentViewController:gvc animated:YES completion:^{NSLog(@"CourtViewController: movenext : go to GoodbyeViewController");}];       
    }
}

#pragma mark - tableviewMethod
/************************************************
 ***   method: loadRecord
 ***   abstract: load data for the use of tables
 ***   description: the method reads data from scriptx_person and scriptx_item
                    (x stands for a number)
                    into personRecordData and itemRecordData
                    which are used to fill the two tables
 
 *************************************************/
- (void) loadRecord{
    NSLog(@"CourtViewController: loadRecord");
    NSString *plistPathStr = @"script";
    plistPathStr = [plistPathStr stringByAppendingFormat:@"%d",chapter];
    plistPathStr = [plistPathStr stringByAppendingString: @"_person"];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource: plistPathStr ofType:@"plist"];
    NSLog(@"CourtViewController: loadRecord load file %@",plistPath);
    self.personRecordData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    plistPathStr = @"script";
    plistPathStr = [plistPathStr stringByAppendingFormat:@"%d",chapter];
    plistPathStr = [plistPathStr stringByAppendingString: @"_item"];
    plistPath = [[NSBundle mainBundle] pathForResource: plistPathStr ofType:@"plist"];
    NSLog(@"CourtViewController: loadRecord load file %@",plistPath);
    self.itemRecordData = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - gameController
/************************************************
 ***   method: initGame
 ***   abstract: all the initialization for game
 ***   description: made initial value for view.hidden load images and do other settings
 *************************************************/
- (void) initGame{
    NSLog(@"CourtViewController: initGame");
    //helper bool value
    self.showRecordNextTime = NO;
    self.firstShowHelper3 = YES;
    //hidden value for views
    self.personRecordTable.hidden = YES;
    self.itemRecordTable.hidden = YES;
    self.tableViewBack.hidden = YES;
    
    //init tip image
    //this makes the little triangle moving in the dialogue
    NSString *imagePath1 = [[NSBundle mainBundle] pathForResource: @"tapnext1"ofType:@"gif"];
    UIImage *image1 = [[UIImage alloc] initWithContentsOfFile:imagePath1];
    NSString *imagePath2 = [[NSBundle mainBundle] pathForResource: @"tapnext2"ofType:@"gif"];
    UIImage *image2 = [[UIImage alloc] initWithContentsOfFile:imagePath2];
    NSString *imagePath3 = [[NSBundle mainBundle] pathForResource: @"tapnext3"ofType:@"gif"];
    UIImage *image3 = [[UIImage alloc] initWithContentsOfFile:imagePath3];
    self.tipnext.animationImages = [NSArray arrayWithObjects:
                                    image1,
                                    image2,
                                    image3,nil];
    self.tipnext.animationRepeatCount = 0;
    self.tipnext.animationDuration = 0.5f;
    [self.tipnext startAnimating];    
    
    
    //load the script
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *filename = [plistPath stringByAppendingPathComponent:@"script.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"CourtViewController: initGame: data: %@",data);
    chapter = [[data objectForKey:@"chapter"] integerValue];
    section = [[data objectForKey:@"section"]integerValue];
    sentence = [[data objectForKey:@"sentence"] integerValue];
    
    [self loadRecord];// load record data
    [self readScriptX];// read specific script
}
/************************************************
 ***   method: gameController
 ***   abstract: the operations do on every scene
 ***   description: operations include update data, refresh screen
                    check if should show table automatically and if show helperScreen
                    also for "cg" we should automatically call movenext 
 *************************************************/
- (void) gameController{
    NSLog(@"CourtViewController: gameController");
    [self updateData];
    [self updateScreen];
    [self checkAutoShowTable];
    [self checkHelperScreen];
    // we have to call movenext for cg
    // because cg is an self motivitated cycle
    // other things we have buttons or things like that to trigger movenext
    if ([self.type isEqualToString:@"cg"]){
        [self movenext];
    }    
}

#pragma mark - data management
/************************************************
 ***   method: getChapter
 ***   abstract: get the static int chapter
 ***   description: for use in appDelegate
 *************************************************/
+ (int) getChapter{
    NSLog(@"CourtViewController: getChapter");
    return chapter;
}
/************************************************
 ***   method: getSection
 ***   abstract: get the static int section
 ***   description: for use in appDelegate
 *************************************************/
+ (int) getSection{
    NSLog(@"CourtViewController: getSection");
    return section;
}
/************************************************
 ***   method: getChapter
 ***   abstract: get the static int sentence
 ***   description: for use in appDelegate
 *************************************************/
+ (int) getSentence{
    NSLog(@"CourtViewController: getSentence");
    return sentence;
}
/************************************************
 ***   method: updateData
 ***   abstract: get the information in data into specific state variables
 ***   description: assign state variables with the variables in current scene
 *************************************************/
- (void) updateData{
    NSLog(@"CourtViewController: updateData");
    // copy scene information into the viewcontroller variable
    self.nameContent = [[self.data objectAtIndex: sentence] objectForKey:@"name"];
    self.sentenceContent = [[self.data objectAtIndex:sentence] objectForKey:@"sentence"];
    self.picture = [[self.data objectAtIndex:sentence] objectForKey:@"picture"];
    self.type = [[self.data objectAtIndex:sentence] objectForKey:@"type"];
    self.nexttype = [[self.data objectAtIndex:sentence] objectForKey:@"nexttype"];
    //actually nexttype is deprecated
    //this is introduced at first in case of later use
    //but turns out to be useless
    self.nextmove = [[[self.data objectAtIndex:sentence] objectForKey:@"nextmove"] integerValue];
    self.datamethod = [[[self.data objectAtIndex:sentence] objectForKey:@"datamethod"] integerValue];
    self.nextviewcontroller = [[[self.data objectAtIndex:sentence] objectForKey:@"nextviewcontroller"] integerValue];
    self.wrongnextmove = [[[self.data objectAtIndex:sentence] objectForKey:@"wrongnextmove"] integerValue];
    self.rightchoice = [[[self.data objectAtIndex:sentence] objectForKey:@"rightChoice"] integerValue];
    
    
    //for scene type "answer" extra variables are needed
    if ([self.type isEqualToString:@"answer"]){
        self.choice1 = [[self.data objectAtIndex:sentence] objectForKey:@"choice1"];
        self.choice2 = [[self.data objectAtIndex:sentence] objectForKey:@"choice2"];
        self.choice3 = [[self.data objectAtIndex:sentence] objectForKey:@"choice3"];
    }
    //for scene type "ask" extra variables are needed
    if ([self.type isEqualToString:@"ask"]){
        self.rightnextmove = [[[self.data objectAtIndex:sentence] objectForKey:@"rightnextmove"] integerValue];
    }
    
}
/************************************************
 ***   method: readScriptX
 ***   abstract: read a specific script
 ***   description: according to chapter and section read the current used script
 *************************************************/
- (void) readScriptX{
    NSLog(@"CourtViewController: readScriptX");
    // read scene information
    NSString *plistPathStr = @"script";
    plistPathStr = [plistPathStr stringByAppendingFormat:@"%d", chapter];
    plistPathStr = [plistPathStr stringByAppendingString: @"_"];
    plistPathStr = [plistPathStr stringByAppendingFormat:@"%d", section];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource: plistPathStr ofType:@"plist"];
    NSLog(@"CourtViewController: readScriptX : read file from : %@",plistPathStr);
    self.data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

#pragma mark - table view delegate
//all methods in this pragma mark are tableView delegate methods
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"CourtViewController: tableView: didSelectRowAtIndexPath called");
    if ([self.type isEqualToString:@"ask"]){          
        int selectedId = 0;
        selectedId = indexPath.row;
        // 0, 1, 2, ... indicate itemRecordTable
        // 100, 101, 102,... indicate personRecordTable
        if (tableView == self.itemRecordTable){
            NSLog(@"CourtViewController: tableView: itemRecordTable row %d selected",indexPath.row);
            self.showRecord.image = ((itemCell *)[tableView cellForRowAtIndexPath:indexPath]).image.image;
        }
        else if( tableView == self.personRecordTable){
            NSLog(@"CourtViewController: tableView: personRecordTable row %d selected",indexPath.row);
            selectedId += 100;
            self.showRecord.image = ((recordCell *)[tableView cellForRowAtIndexPath:indexPath]).image.image;
        }
    
        if (self.rightchoice == selectedId){
            //Right answer so we go next using rightnextmove
            NSLog(@"CourtViewController: tableView: right match with material evidence");
            sentence = self.rightnextmove;
        }
        else{
            //wrong answer so we go next using wrongnextmove
            NSLog(@"CourtViewController: tableView: wrong match with material evidence");
            sentence = self.wrongnextmove;
            self.showRecordNextTime = YES;
        }                
        [self gameController];// need to call gameController to refresh data and screen
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // we do the right thing for both the two tables
    if (tableView == self.personRecordTable){
    return [self.personRecordData count];
    }
    else if (tableView == self.itemRecordTable){
        return [self.itemRecordData count];
    }
    return 1;// this line is meaningless actually put here just to get rid of the warning 
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.personRecordTable){
        static NSString *CellIdentifier = @"recordCell";
        recordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [[self.personRecordData objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.details.text = [[self.personRecordData objectAtIndex:indexPath.row] objectForKey:@"details"];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:  [[self.personRecordData objectAtIndex:indexPath.row] objectForKey:@"image"] ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        NSLog(@"CourtViewController: tableView: cellforRowAtIndexPath: : load image %@",imagePath);
        cell.image.image = image;
        return cell;
    }
    else if (tableView == self.itemRecordTable){
        static NSString *CellIdentifier = @"itemCell";
        itemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.title.text = [[self.itemRecordData objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.details.text = [[self.itemRecordData objectAtIndex:indexPath.row] objectForKey:@"details"];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:  [[self.itemRecordData objectAtIndex:indexPath.row] objectForKey:@"image"] ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];        
        NSLog(@"CourtViewController: tableView: cellforRowAtIndexPath: : load image %@",imagePath);
        cell.image.image = image;
        return cell;
    }
    return NULL;// this line is meaningless actually put here just to get rid of the warning 
    
}

#pragma mark - developer use buttons
/************************************************
 ***   method: dev_...
 ***   abstract: all the method below is to be usef for developer to go to a certain scene for particular use
 ***   description: the buttons are in the developerScreen so 
                    they would only be available when user truned on this feature in settings
 *************************************************/
- (IBAction)dev_Restart:(id)sender {
    chapter = 1;
    section = 1;
    sentence = 0;
    [self readScriptX];
    [self gameController];
}

- (IBAction)dev_BeforeAnswer:(id)sender {
    chapter = 1;
    section = 2;
    sentence = 9;
    [self readScriptX];
    [self gameController];
}

- (IBAction)dev_BeforeAutoTable:(id)sender {
    chapter = 1;
    section = 4;
    sentence = 167;
    [self readScriptX];
    [self gameController];
}

- (IBAction)dev_BeforeAsk:(id)sender {
    chapter = 1;
    section = 4;
    sentence = 24;
    [self readScriptX];
    [self gameController];
    
}
- (IBAction)dev_BeforeWinning:(id)sender {
    chapter = 1;
    section = 4;
    sentence = 201;
    [self readScriptX];
    [self gameController];
}
- (IBAction)dev_BeforeEndGame:(id)sender {
    chapter = 1;
    section = 5;
    sentence = 23;
    [self readScriptX];
    [self gameController];
}
@end
