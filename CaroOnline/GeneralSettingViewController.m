//
//  CreateAccountViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 29/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GeneralSettingViewController.h"

@implementation GeneralSettingViewController

@synthesize okButton,cancelButton,nickNameLabel,nickNameTextField,lobbyNameLabel,lobbyNameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title=NSLocalizedString(@"General_Setting", Nil);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	nickNameLabel.text=NSLocalizedString(@"Nick_Name", Nil);
	lobbyNameLabel.text=NSLocalizedString(@"Lobby_Name", Nil);
	nickNameTextField.placeholder=NSLocalizedString(@"Type_Here", Nil);
	lobbyNameTextField.placeholder=NSLocalizedString(@"Type_Here", Nil);
	okButton.titleLabel.text=NSLocalizedString(@"OK_", nil);
	cancelButton.titleLabel.text=NSLocalizedString(@"Cancel_", nil);
	//[createButton addTarget:self action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
	//[cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString * nickName = [standardUserDefaults objectForKey:@"nickName"];
	if (!nickName) {
		nickName=@"";
	}
	nickNameTextField.text=nickName;
	
	NSString * lobbyName = [standardUserDefaults objectForKey:@"lobbyName"];
	if (!lobbyName) {
		lobbyName=@"";
	}
	lobbyNameTextField.text=lobbyName;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma -mark Handle Push Button

-(IBAction)changeSetting:(id)sender{
	//change setting here
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	[standardUserDefaults setObject:nickNameTextField.text forKey:@"chatName"];
	[standardUserDefaults setObject:nickNameTextField.text forKey:@"nickName"];
	[standardUserDefaults setObject:lobbyNameTextField.text forKey:@"lobbyName"];
	[standardUserDefaults synchronize];
	
	[self.navigationController popViewControllerAnimated:true];
}
-(IBAction)cancel:(id)sender{
	[self.navigationController popViewControllerAnimated:true];
}
@end
