//
//  HomepageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-12.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "OtherHomepageViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "GroupSendViewController.h"
#import "CityInfo.h"
#import "TalkViewController.h"
#import "LoginViewController.h"
#import "FriendContact.h"
#import "HomePageCell.h"
#import "MailInfo.h"


enum eAlertTag {
    commentAlert = 0,
    loginAlert,
};

@interface OtherHomepageViewController ()

@end

@implementation OtherHomepageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [kAppDelegate.tabController hidesTabBar:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [kAppDelegate.tabController hidesTabBar:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"他的主页";
    
    self.preferArray = [[[NSMutableArray alloc] init] autorelease];
    self.areaArray = [[[NSMutableArray alloc] init] autorelease];
    
    //back button
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];

    [self.addFriendButton addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.messageButton setBackgroundImage:[UIImage imageNamed:@"middle_p"] forState:UIControlStateHighlighted];
    [self.mailButton setBackgroundImage:[UIImage imageNamed:@"middle_p"] forState:UIControlStateHighlighted];
    [self.telButton setBackgroundImage:[UIImage imageNamed:@"left_p"] forState:UIControlStateHighlighted];
    
    [self.telButton setImage:[UIImage imageNamed:@"tel"] forState:UIControlStateHighlighted];
    [self.messageButton setImage:[UIImage imageNamed:@"message_connect"] forState:UIControlStateHighlighted];
    [self.mailButton setImage:[UIImage imageNamed:@"mail_connect"] forState:UIControlStateHighlighted];
    [self.chatButton setImage:[UIImage imageNamed:@"chat_connect"] forState:UIControlStateHighlighted];
    
    [self.messageButton addTarget:self action:@selector(message:) forControlEvents:UIControlEventTouchUpInside];
    [self.mailButton addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headIcon.layer.cornerRadius = 8;
    self.headIcon.layer.masksToBounds = YES;
    [self.headIcon setImageWithURL:[NSURL URLWithString:self.contact.picturelinkurl] placeholderImage:[UIImage imageByName:@"avatar"]];
    //默认不是好友
    self.isFriend = NO;
    
    
    //table view source
    self.leftArray = [NSMutableArray arrayWithArray:@[@"招商代理：", @"常驻地区：", @"类别偏好：", @"他的招商代理信息："]];
    self.rightArray = [NSMutableArray array];
    
    
    [self getUserInfo];
}

- (IBAction)comment:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改备注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"备注";
    alert.tag = commentAlert;
    [alert show];
    [alert release];
}


#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homePageCell";
    HomePageCell *cell = (HomePageCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomePageCell" owner:self options:nil] lastObject];
    }
    
    switch (indexPath.row) {
        case 0:{
            int inva = self.contact.invagency.intValue;
            NSString *strInva = nil;
            switch (inva) {
                case 1:
                    strInva = @"招商";
                    break;
                case 2:
                    strInva = @"代理";
                    break;
                case 3:
                    strInva = @"招商、代理";
                    break;
                default:
                    break;
            }
            cell.detailLabel.text = strInva;
        }
            
            break;
        case 1:
            cell.detailLabel.text = self.residentArea;
            break;
            
        case 2:
            cell.detailLabel.text = self.pharmacologyCategory;
            break;
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.separatorImage.hidden = YES;
            CGRect frame = cell.nameLabel.frame;
            frame.size.width = 150;
            cell.nameLabel.frame = frame;
            cell.detailLabel.hidden = YES;
            break;
            
        default:
            break;
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    cell.nameLabel.textColor = kContentBlueColor;
    
    if (indexPath.row == self.leftArray.count-1) {
        cell.separatorImage.image = nil;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void)getUserInfo
{
    NSString *peoperid = self.contact.userid;   //好友id
    NSString *userid = [kAppDelegate userId];
    NSString *cityName = [PersistenceHelper dataForKey:kCityName];
    NSString *cityid = [[Utility getCityIdByCityName:cityName] cityId];
    NSString *provinceid = [[Utility getCityIdByCityName:cityName] proId];
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:peoperid, @"peoperid",
                                                                        userid, @"userid",
                                                                        cityid, @"cityid",
                                                                        provinceid, @"provinceid",
                                                                        @"getUserpageDetail.json", @"path", nil];
    
    DLog(@"para Dict: %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取用户信息";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        if ([[[json objectForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            NSLog(@"friend json data: %@", json);
            
            
            NSMutableString *areaString = [[NSMutableString alloc] init];
            NSArray *areaList = [json objectForKey:@"AreaList"];
            [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {

                [self.areaArray addObject:[cityDict objForKey:@"cityname"]];
                [areaString appendFormat:@"%@、", [cityDict objForKey:@"cityname"]];
                
            }];
            
            if ([areaString isValid]) {
                areaString = (NSMutableString *)[areaString substringToIndex:[areaString length]-1];
                self.residentArea = areaString;
            }

            
            NSMutableString *preferString = [[NSMutableString alloc] init];
            NSArray *preferList = [json objectForKey:@"PreferList"];
            [preferList enumerateObjectsUsingBlock:^(NSDictionary *preferDict, NSUInteger idx, BOOL *stop) {

                [self.preferArray addObject:[preferDict objForKey:@"prefername"]];
                [preferString appendFormat:@"%@、", [preferDict objForKey:@"prefername"]];
            }];

            if ([preferString isValid]) {
                preferString = (NSMutableString *)[preferString substringToIndex:[preferString length]-1];
                self.pharmacologyCategory = preferString;
            }
            
            NSDictionary *userDetail = [json objectForKey:@"UserDetail"];
            self.contact.autograph = [userDetail objForKey:@"autograph"];
            self.contact.col1 = [userDetail objForKey:@"col1"];
            self.contact.col2 = [userDetail objForKey:@"col2"];
            self.contact.col3 = [userDetail objForKey:@"col3"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.invagency = [[userDetail objForKey:@"invagency"] stringValue];
            self.contact.mailbox = [userDetail objForKey:@"mailbox"];
            self.contact.picturelinkurl = [userDetail objForKey:@"picturelinkurl"];
            self.contact.remark = [userDetail objForKey:@"remark"];
            self.contact.tel = [userDetail objForKey:@"tel"];
            self.contact.type = [[userDetail objForKey:@"type"] stringValue];
            self.contact.username = [userDetail objForKey:@"username"];
            self.contact.userid = [[userDetail objForKey:@"id"] stringValue];
            self.contact.isreal = [[userDetail objForKey:@"isreal"] stringValue];
            
            if (self.contact.type.intValue == 0) {
                self.isFriend = NO;
                [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
            }
            else{
                self.isFriend = YES;
                [self.addFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
            }
            
            self.useridLabel.text = self.contact.userid;
            self.nameLabel.text = self.contact.username;
            
            if ([self.contact.col2 isEqualToString:@"1"]) {
                self.xun_VImage.hidden = NO;
            }
            else{
                self.xun_VImage.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        DLog(@"他的招商代理信息");
    }
}


- (void)addFriend:(UIButton *)sender
{
    if ([self showLoginAlert]) {
        return;
    }
    
    if (!self.isFriend) {
        NSLog(@"添加好友");
        
        //添加关注, addZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid =  self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"addZsAttentionUser.json", @"path", nil];
        
//        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"添加好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.isFriend = YES;
                [self.addFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
                
                [self updateIsFriend:self.isFriend];
                
            }
            else{
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
    else{
        NSLog(@"删除好友");
        
        //添加关注, delZsAttentionUser.json, userid, attentionid provinceid cityid
        
        NSString *attentionid = self.contact.userid;
        NSString *userid = [kAppDelegate userId];
        NSString *cityid = [PersistenceHelper dataForKey:kCityId];
        NSString *provinceid = [PersistenceHelper dataForKey:kProvinceId];
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:attentionid, @"attentionid",
                                  userid, @"userid",
                                  cityid, @"cityid",
                                  provinceid, @"provinceid",
                                  @"delZsAttentionUser.json", @"path", nil];
        
//        NSLog(@"para Dict: %@", paraDict);
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        hud.labelText = @"删除好友";
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            long returnCode = [[json objectForKey:@"returnCode"] longValue];
            NSLog(@"returnCode: %ld", returnCode);
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
                self.isFriend = NO;
                [self.addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
                [self updateIsFriend:self.isFriend];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
    }
}

- (void)updateIsFriend:(BOOL)isFriend
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userid == %@ AND loginid == %@ AND cityid == %@", self.contact.userid, [kAppDelegate userId], [PersistenceHelper dataForKey:kCityId]];
    FriendContact *friendContact = [FriendContact findFirstWithPredicate:pred];
    if (friendContact == nil) {
        friendContact = [FriendContact createEntity];
        friendContact.autograph = self.contact.autograph;
        friendContact.cityid = [PersistenceHelper dataForKey:kCityId];
        friendContact.col1 = self.contact.col1;
        friendContact.col2 = self.contact.col2;
        friendContact.col3 = self.contact.col3;
        friendContact.invagency = self.contact.invagency;
        friendContact.loginid = kAppDelegate.userId;
        friendContact.mailbox = self.contact.mailbox;
        friendContact.picturelinkurl = self.contact.picturelinkurl;
//        friendContact.remark = self.commentTextField.text;
        friendContact.sectionkey = self.contact.sectionkey;
        friendContact.tel = self.contact.tel;
        friendContact.userid = self.contact.userid;
        friendContact.username = self.contact.username;
        friendContact.username_p = self.contact.username_p;
    }

    if (self.isFriend) {
        friendContact.type = @"1";
    }
    else
    {
        friendContact.type = @"0";
    }

    DB_SAVE();

}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    if ([kAppDelegate.userId isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请登录修改备注" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [[alert textFieldAtIndex:0] setPlaceholder:@"备注"];
        alert.tag = loginAlert;
        [alert show];
        [alert release];
        [self.view endEditing:YES];
        return;
    }
    
    
    if ([self.contact.remark isValid]) {
        textField.text = self.contact.remark;
    }
    
    
    textField.returnKeyType = UIReturnKeyDone;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"text field edit end");
    

    NSString *destid = self.contact.userid;
    NSString *userid = kAppDelegate.userId;
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:userid, @"userid",
                              destid, @"destid",
                              textField.text, @"remark",
                              @"changeuserremark.json", @"path", nil];
    
//        NSLog(@"comment para dict: %@", paraDict);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
            hud.labelText = @"修改成功";
            [hud hide:YES afterDelay:.3];
            
            if (![textField.text isValid]) {
                self.contact.remark = @"";
            }
            else{
                self.contact.remark = textField.text;
                NSString *remark = [NSString stringWithFormat:@"(%@)", self.contact.remark];
                textField.text = remark;
            }
            self.contact.loginid = [kAppDelegate userId];
            
            DB_SAVE();
        }
        else{
            [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - contact method

- (void)message:(UIButton *)sender
{
    NSLog(@"send message");

    if ([self showLoginAlert]) {
        return;
    }
    
    SendMessageViewController *smVC = [[SendMessageViewController alloc] init];
    smVC.currentContact = self.contact;
    [self.navigationController pushViewController:smVC animated:YES];
    [smVC release];
}

- (void)email:(UIButton *)sender
{
    NSLog(@"send email");
    if ([self showLoginAlert]) {
        return;
    }
    
//    @dynamic userid;
//    @dynamic username;
//    @dynamic loginid;
//    @dynamic thirdaddress;
//    @dynamic address;
//    @dynamic foldername;
//    @dynamic subject;
//    @dynamic content;
//    @dynamic date;
//    @dynamic flags;         //0 未读 1 已读
//    @dynamic messageid;
//    @dynamic state;         //0 发送失败 1 发送成功
//    @dynamic picturelinkurl;
    
    
    
    

    
    
    if ([self.contact.isreal isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户只接受短信" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    MailInfo *mail = [MailInfo createEntity];
    mail.userid = self.contact.userid;
    mail.username = self.contact.username;
    mail.loginid = kAppDelegate.userId;
    mail.thirdaddress = self.contact.mailbox;
    mail.address = self.contact.col1;
    mail.foldername = @"OUTBOX";
    mail.subject = @"";
    mail.content = @"";
    mail.date = @"";
    mail.flags = @"";
    mail.messageid = @"";
    mail.state = @"";
    mail.picturelinkurl = self.contact.picturelinkurl;
    
    SendEmailViewController *seVC = [[SendEmailViewController alloc] init];
    seVC.mail = mail;
//    seVC.currentContact = self.contact;
    [self.navigationController pushViewController:seVC animated:YES];
    [seVC release];
}

- (void)chat:(UIButton *)sender
{
    NSLog(@"chat");
    if ([self showLoginAlert]) {
        return;
    }
    
    if ([self.contact.isreal isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该用户只接受短信" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    
    TalkViewController *talk = [[[TalkViewController alloc] initWithNibName:@"TalkViewController" bundle:nil] autorelease];
    talk.username = self.contact.username;
    talk.fid = self.contact.userid;
    talk.fAvatarUrl = self.contact.picturelinkurl;
    NSLog(@"talk.fid %@", talk.fid);
    [self.navigationController pushViewController:talk animated:YES];
    
}

- (BOOL)showLoginAlert
{
    BOOL shouldShow = NO;
    if ([[kAppDelegate userId] isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alert.tag = loginAlert;
        [alert show];
        [alert release];
        shouldShow = YES;
    }
    return shouldShow;
}

#pragma mark - alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == loginAlert) {
        if (buttonIndex == 1) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
            [loginVC release];
        }
    }else if (alertView.tag == commentAlert){
        if (buttonIndex == 1) {
            NSString *comment = [[alertView textFieldAtIndex:0] text];
            if ([comment isValid]) {
                NSString *name = [NSString stringWithFormat:@"%@(%@)", self.contact.username, comment];
                self.contact.remark = comment;
                self.nameLabel.text = name;
                DB_SAVE();
            }
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_nameLabel release];
    [_messageButton release];
    [_mailButton release];
    [_chatButton release];
    [_addFriendButton release];
    [_headIcon release];
    [_tableView release];
    [_xunImage release];
    [_xun_VImage release];
    [_xun_BImage release];
    [_useridLabel release];
    [_telButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setXunImage:nil];
    [self setXun_VImage:nil];
    [self setXun_BImage:nil];
    [self setUseridLabel:nil];
    [self setTelButton:nil];
    [super viewDidUnload];
}

@end
