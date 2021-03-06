//
//  MyProfileViewControllerViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfo.h"

@interface MyProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UILabel *telLabel;
@property (retain, nonatomic) IBOutlet UILabel *mailLabel;

@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunVImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunBImage;

@property (nonatomic, retain) IBOutlet UIView *attentView;
@property (nonatomic, retain) IBOutlet UIView *starView;
@property (nonatomic, retain) IBOutlet UIView *blacklistView;

- (IBAction)message:(UIButton *)sender;
- (IBAction)mail:(UIButton *)sender;
- (IBAction)chat:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UITableView *tableView_1;
@property (retain, nonatomic) IBOutlet UITableView *tableView_2;

@property (nonatomic, retain) MyInfo *myInfo;
@property (nonatomic, retain) NSArray *leftArray_1;
@property (nonatomic, retain) NSArray *leftArray_2;
@property (nonatomic, retain) NSMutableArray *selectorArray_1;
@property (nonatomic, retain) NSMutableArray *selectorArray_2;

@end
