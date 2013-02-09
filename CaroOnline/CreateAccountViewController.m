//
//  CreateAccountViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 29/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CreateAccountViewController.h"

@implementation CreateAccountViewController

@synthesize createButton,cancelButton,accountLabel,accountTextField,passwordLabel,passwordTextField,sendingIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.title=NSLocalizedString(@"Create_Account", Nil);
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
	accountLabel.text=NSLocalizedString(@"Account_", Nil);
	passwordLabel.text=NSLocalizedString(@"Password_", Nil);
	accountTextField.placeholder=NSLocalizedString(@"Type_Here", Nil);
	passwordTextField.placeholder=NSLocalizedString(@"Type_Here", Nil);
	createButton.titleLabel.text=NSLocalizedString(@"Create_", nil);
	cancelButton.titleLabel.text=NSLocalizedString(@"Cancel_", nil);
	//[createButton addTarget:self action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
	//[cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	
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

-(IBAction)createAccount:(id)sender{
	[sendingIndicator startAnimating];
}
-(IBAction)cancel:(id)sender{
	[sendingIndicator stopAnimating];
}
@end
