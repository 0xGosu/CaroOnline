//
//  GeneralSettingViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 29/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralSettingViewController : UIViewController 

@property (assign) IBOutlet UILabel * nickNameLabel;
@property (assign) IBOutlet UITextField * nickNameTextField;

@property (assign) IBOutlet UILabel * lobbyNameLabel;
@property (assign) IBOutlet UITextField * lobbyNameTextField;

@property (assign) IBOutlet UIButton * okButton;
@property (assign) IBOutlet UIButton * cancelButton;


-(IBAction)changeSetting:(id)sender;
-(IBAction)cancel:(id)sender;

@end
