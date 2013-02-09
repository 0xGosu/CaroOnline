//
//  ViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

@synthesize testGame,testLobby;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.view setFrame:[[UIScreen mainScreen] bounds]];
	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	//Check chatName
	NSString* lobbyName=[standardUserDefaults objectForKey:@"lobbyName"];
	if (!lobbyName || lobbyName.length==0) {
		lobbyName=@"testServer";
	}

	//testGame = [[GameViewController alloc]initWithRoomName:@"testRoomCaro101"];
	
	testLobby = [[LobbyViewController alloc]initWithLobbyName:lobbyName];
	//ChatViewController * testChat=[[ChatViewController alloc]initWithRoom:@"" delegate:nil];
	
//	UIImage* boardImage=[DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"Board20x20" ofType:@"png"]];
//	UIImage* imageX=[DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"black-copy" ofType:@"png"]];
//	UIImage* imageO=[DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"white-copy" ofType:@"png"]];
//	//Load caro online
//	CaroOnlineViewController * caroOnline = [[CaroOnlineViewController alloc]initWithCaroBoard:boardImage imageX:imageX imageO:imageO roomName:@"testRoomCaro105"];
//	
	
	[self.navigationController pushViewController:testLobby animated:true];
//	[testGame release];
	[testLobby release];
//	testGame = nil;
//	//[self.view addSubview:testChat.view];
	
//	//Setting for User default
//	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//	NSString* chatName=[standardUserDefaults objectForKey:@"chatName"];
//	if (chatName) {
//		NSLog(@"Chat name=%@",chatName);
//	}else{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Chat_Name", nil)  message:NSLocalizedString(@"No_Chat_Name_message", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//		[alert show];
//		
//	}
	
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	if (buttonIndex==0) {
//		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//		[standardUserDefaults setObject:@"TVA" forKey:@"chatName"];
//		NSLog(@"Create chatname = %d", [standardUserDefaults synchronize]);
//	}
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"viewDidAppear!");
	[super viewDidAppear:animated];
		
	//[self.navigationController pushViewController:testGame animated:true];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	return YES;
}

@end
