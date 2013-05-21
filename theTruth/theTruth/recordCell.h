//
//  recordCell.h
//  theTruth
//
//  Created by cheonhyang on 13-3-13.
//  Copyright (c) 2013年 Tianxiang Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
//this custom cell is used for personRecordTable
@interface recordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *details;

@end
