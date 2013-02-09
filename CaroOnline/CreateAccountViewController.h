//
//  CreateAccountViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 29/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateAccountViewController : UIViewController 

@property (assign) IBOutlet UILabel * accountLabel;
@property (assign) IBOutlet UITextField * accountTextField;

@property (assign) IBOutlet UILabel * passwordLabel;
@property (assign) IBOutlet UITextField * passwordTextField;

@property (assign) IBOutlet UIButton * createButton;
@property (assign) IBOutlet UIButton * cancelButton;

@property (assign) IBOutlet UIActivityIndicatorView * sendingIndicator;

-(IBAction)createAccount:(id)sender;
-(IBAction)cancel:(id)sender;

@end
