//
//  LobbyViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LobbyViewController.h"
#import "DataSource.h"

@interface LobbyViewController()

- (void)createToolbarItems;
- (void)createFrames;
-(void) loadTables:(id)sender;

@end

@implementation LobbyViewController

@synthesize toolbar,roomPicker,chatView;


- (id)initWithLobbyName:(NSString*)lobby{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
		lobbyName=lobby;
		self.title=NSLocalizedString(lobbyName, nil);
		
		listRoom=[[NSMutableArray alloc]initWithObjects: nil];
		
		[self loadTables:nil];
		
		//Check for standard user setting
		//Setting for User default
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		//Check chatName
		NSString* chatName=[standardUserDefaults objectForKey:@"chatName"];
		if (chatName && chatName.length) {
			NSLog(@"Chat name=%@",chatName);
			Entry * messageEntry = [[Entry alloc] init];
			messageEntry.tags=[NSArray arrayWithObjects:@"Chat", nil];
			messageEntry.content=[NSString stringWithFormat:@"<name=%@>%@",chatName,NSLocalizedString(@"Hello_", nil)];
			//Init request with entry
			[[GameServerConnection alloc] initToSendEntry:messageEntry toRoom:lobbyName delegate:chatView];
			[messageEntry release];
		}else{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Chat_Name", nil)  
															message:NSLocalizedString(@"No_Chat_Name_Message", nil) 
															delegate:self 
															cancelButtonTitle:nil
															otherButtonTitles:NSLocalizedString(@"Set_Chat_Name", nil),nil
															];
			alert.tag=1;
			[alert show];
//			[standardUserDefaults setObject:[NSString stringWithFormat:@"User%d",rand()%10000] forKey:@"chatName"];
		}
		
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	self.view=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
	CGRect mainViewBounds = self.view.frame;
	NSLog(@"%f x %f , %f x %f",mainViewBounds.origin.x,mainViewBounds.origin.y,mainViewBounds.size.width,mainViewBounds.size.height);

	//Load view here
	NSLog(@"Load subview in Lobby View Controller!");
	
	//Create roomPicker
	roomPicker = [[PickRoomTableViewController alloc] initWithStyle:UITableViewStyleGrouped List:listRoom delegate:self];
	[self.view addSubview:roomPicker.view];
	[self addChildViewController:roomPicker];
	NSLog(@"RoomPicker loaded!");
	
	// create the UIToolbar at the bottom of the view controller
	toolbar = [[UIToolbar alloc]init];
	//[toolbar setBackgroundImage:[[[UIImage alloc]init]autorelease] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	//toolbar.barStyle = UIBarStyleBlackOpaque;
	toolbar.barStyle = UIBarStyleDefault;
	//create buttons of toolbar
	[self createToolbarItems];
	[self.view addSubview:toolbar];
	NSLog(@"Toolbar loaded!");
	
	//Create chatView
	chatView = [[ChatViewController alloc]initWithRoom:lobbyName delegate:nil];
	[self.view addSubview:chatView.view];
	NSLog(@"ChatView loaded!");
	
	[self createFrames];
	//there is a toolbar frame bug but after rotate it is fixed! This line can fix the bug without rotate
	toolbar.frame = CGRectMake(toolbar.frame.origin.x,toolbar.frame.origin.y-44-20,toolbar.frame.size.width,toolbar.frame.size.height);
	
	//Create Indicator at the right of NavigationBar
	sendingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[sendingIndicator startAnimating];
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:sendingIndicator];
	//hide back button.
	self.navigationItem.hidesBackButton=true;
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//}


-(void) dealloc{
	//deallocating here
	[listRoom release];
	listRoom = nil;

	[super dealloc];	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self.toolbar release];
	self.toolbar = nil;
	[self.roomPicker release];
	self.roomPicker = nil;
	[self.chatView release];
	self.chatView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//******************************** UI quick made *********************
- (void)createFrames{
	NSLog(@"Fix toolbar & table view frame for current screen!");
	
	// size up the toolbar and set its frame to fit current screen
	[toolbar sizeToFit];
	CGRect mainViewBounds = self.view.bounds;
	//NSLog(@"%f x %f , %f x %f",mainViewBounds.origin.x,mainViewBounds.origin.y,mainViewBounds.size.width,mainViewBounds.size.height);
	//NSLog(@"%f x %f , %f x %f",toolbar.frame.origin.x,toolbar.frame.origin.y,toolbar.frame.size.width,toolbar.frame.size.height);
	
	[toolbar setFrame:CGRectMake(mainViewBounds.origin.x,
								 mainViewBounds.origin.y + mainViewBounds.size.height - toolbar.frame.size.height,
								 toolbar.frame.size.width,
								 toolbar.frame.size.height)];
	// size up the table and set its frame to fit current screen
	roomPicker.tableView.frame=CGRectMake(mainViewBounds.origin.x, 
										 mainViewBounds.origin.y , 
										 CGRectGetWidth(mainViewBounds), 
										 CGRectGetHeight(mainViewBounds) - CGRectGetHeight(self.toolbar.bounds) );
	//move chat view
	
	[chatView createFrames];
	[chatView.view setFrame:CGRectMake(mainViewBounds.size.width-chatView.view.frame.size.width, CGRectGetHeight(mainViewBounds)-chatView.view.frame.size.height-toolbar.frame.size.height-70 ,chatView.view.frame.size.width,chatView.view.frame.size.height)];
	
}

- (void)createToolbarItems{	
	NSLog(@"Create items in Toolbar!");
	// match each of the toolbar item's style match the selection in the "UIBarButtonItemStyle" segmented control
	//UIBarButtonItemStyle style = UIBarButtonItemStylePlain;
	
	// flex item used to separate the left groups items and right grouped items
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	
	// create a special tab bar item with a custom image and title
	
	//Setting button
	UIImage* image=[UIImage imageNamed:@"setting.png"] ;
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(goToSetting:) forControlEvents:UIControlEventTouchUpInside];    
	
	UIBarButtonItem *imageItemSetting = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	//NewTable button
	image=[UIImage imageNamed:@"caro-icon+.png"] ;
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(newGame:) forControlEvents:UIControlEventTouchUpInside];    
	
	UIBarButtonItem *imageItemNewGame = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	//Reload button
	image=[UIImage imageNamed:@"reload.png"] ;
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(loadTables:) forControlEvents:UIControlEventTouchUpInside];    
	
	UIBarButtonItem *imageItemReload = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	//Help button
	image=[UIImage imageNamed:@"Help.png"] ;
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showHelp:) forControlEvents:UIControlEventTouchUpInside];    
	
	UIBarButtonItem *imageItemHelp = [[UIBarButtonItem alloc] initWithCustomView:button];
	
	//Chat button
	UIImage* imageChat=[UIImage imageNamed:@"chat.png"] ;
	UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
	chatButton.bounds = CGRectMake( 0, 0, imageChat.size.width, imageChat.size.height );    
	[chatButton setImage:imageChat forState:UIControlStateNormal];
	[chatButton addTarget:self action:@selector(toggleChat:) forControlEvents:UIControlEventTouchUpInside];    
	
	UIBarButtonItem *imageItemChat = [[UIBarButtonItem alloc] initWithCustomView:chatButton];
	
	
	NSArray *items = [NSArray arrayWithObjects: imageItemSetting,imageItemNewGame, imageItemReload, imageItemHelp,  flexItem, imageItemChat, nil];
	[self.toolbar setItems:items animated:YES];
	
	[flexItem release];
	[imageItemSetting release];
	[imageItemChat release];
	[imageItemReload release];
	[imageItemNewGame release];
}

- (UITextField *)getTextFieldRounded
{
	UITextField * textFieldRounded;
	
	CGRect frame = CGRectMake(0, 0, 250, 32);
	textFieldRounded = [[UITextField alloc] initWithFrame:frame];
	
	textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
	textFieldRounded.textColor = [UIColor blackColor];
	textFieldRounded.font = [UIFont systemFontOfSize:17.0];
	textFieldRounded.placeholder = @"<Type chat here>";
	textFieldRounded.backgroundColor = [UIColor whiteColor];
	
	textFieldRounded.autocapitalizationType = UITextAutocapitalizationTypeNone; //no auto captilization
	textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textFieldRounded.keyboardType = UIKeyboardTypeDefault;
	textFieldRounded.returnKeyType = UIReturnKeyDone;
	
	textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	textFieldRounded.tag = 100;		// tag this control so we can remove it later for recycled cells
	
	//textFieldRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	// Add an accessibility label that describes what the text field is for.
	//[textFieldRounded setAccessibilityLabel:NSLocalizedString(@"RoundedTextField", @"")];
	
	return textFieldRounded;
}

#pragma mark - Toast
-(void)makeToast:(NSString*)message Duration:(CGFloat)duration AtLocation:(CGPoint)point{
	UIView * toast= [[UIView alloc]init];
	//"@pink",@"purple",@"yellow",
//	NSArray *colors =[NSArray arrayWithObjects:@"aqua",@"brown",@"graphite",@"green",@"orange", nil];
//	NSString* color= [colors objectAtIndex:arc4random() % [colors count]];
	NSString* color=@"aqua";
	NSString * imageName = [NSString stringWithFormat:@"%@.png",color];;
	if (point.x <= 160) {
		imageName = [NSString stringWithFormat:@"%@_right.png",color];
	}
	UIImage * balloon = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
	UIImageView * balloonView = [[UIImageView alloc]initWithImage:balloon];
	
	UILabel * label=[[UILabel alloc]init];
	label.text=message;
	[label setLineBreakMode:UILineBreakModeWordWrap];
	label.textColor=[UIColor whiteColor];
	label.backgroundColor=[UIColor clearColor];
	[label setFont:[UIFont systemFontOfSize:12]];
	label.numberOfLines=0;
	if(message.length<19)
		[label setFrame:CGRectMake(10, 10, 12+message.length*7, 14)];
	else
		[label setFrame:CGRectMake(10, 10, 12+18*7, (message.length/18+1)*14)];
	
	[balloonView setFrame:CGRectMake(0, 0, label.frame.size.width+20, label.frame.size.height+20)];
	[toast addSubview:balloonView];
	[toast addSubview:label];
	
	if (point.x <= 160) {
		[toast setFrame:CGRectMake(point.x, point.y-balloonView.frame.size.height, balloonView.frame.size.width , balloonView.frame.size.height)];
	}
	else{
		[toast setFrame:CGRectMake(point.x-balloonView.frame.size.width, point.y-balloonView.frame.size.height, balloonView.frame.size.width , balloonView.frame.size.height)];
	}	
	[self.view addSubview:toast];
	
	[NSTimer scheduledTimerWithTimeInterval:duration
									 target:toast
								   selector:@selector(removeFromSuperview)
								   userInfo:nil
									repeats:NO];
}

#pragma mark - UI handle
//******************************** UI handle *********************
-(void) goToSetting:(id)sender{
	NSLog(@"Go To Setting!");
	MenuSettingTableViewController* setting = [[MenuSettingTableViewController alloc]initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:setting animated:TRUE];
	[setting release];
	setting=nil;
}
-(void) newGame:(id)sender{
	NSLog(@"Create a new table!");


	
	//Show an arlert to get roomtitle + notify user
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create_New_Game", nil) 
														  message:[NSString stringWithFormat:@"\n%@", NSLocalizedString(@"Create_New_Game_Message", nil) ]
														  delegate:self
														  cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
														  otherButtonTitles:NSLocalizedString(@"Create", nil),nil
														  ];
	myAlertView.tag=2;
	if(!myTextField)myTextField=[self getTextFieldRounded];
	[myTextField setFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	myTextField.placeholder=NSLocalizedString(@"Room_Title", nil);
	
	[myAlertView addSubview:myTextField];
	[myAlertView show];
	[myAlertView release];
	
}

-(void)showHelp:(id)sender{
	NSLog(@"Show help using toast!");
	helpCount++;
	if (helpCount==6) helpCount=1;
	if(helpCount==1){
		[self makeToast:NSLocalizedString(@"Help_Setting", nil) Duration:4 AtLocation:CGPointMake(35, 390)];
	}
	if(helpCount==2){
		[self makeToast:NSLocalizedString(@"Help_NewGame", nil) Duration:4 AtLocation:CGPointMake(75, 390)];
	}
	if(helpCount==3){
		[self makeToast:NSLocalizedString(@"Help_Refresh", nil) Duration:4 AtLocation:CGPointMake(115, 390)];
	}
	if(helpCount==4){
		[self makeToast:NSLocalizedString(@"Help_Intro", nil) Duration:8 AtLocation:CGPointMake(155, 390)];
	}
	if(helpCount==5){
		[self makeToast:NSLocalizedString(@"Help_Chat", nil) Duration:4 AtLocation:CGPointMake(275, 390)];
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//buttonIndex start at 0 from cancelButton to the most right button
	if (alertView.tag==1 && buttonIndex==1) {
		[self goToSetting:nil];
	}
	if (alertView.tag==2 && buttonIndex==1) {
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		NSString* chatName=[standardUserDefaults objectForKey:@"chatName"];
		Entry * newTable = [[Entry alloc]init];
		
		newTable.tags=[NSArray arrayWithObjects:@"NewGame", nil];
		newTable.content=[NSString stringWithFormat:@"<type=Caro><roomTitle=(%@)%@>",chatName,myTextField.text];
		
		createGameRoomConnection=[[GameServerConnection alloc] initToSendEntry:newTable toRoom:lobbyName delegate:self];
		createGameRoomConnection.tag = @"createGameRoom";
		//Can't Go to room imediately unless got result success of connection to get id
	}
}

-(void) loadTables:(id)sender{
	if (!getGameRoomConnection.isConnecting) {
		NSLog(@"Load table from servers!");
		[getGameRoomConnection cancel];
		[getGameRoomConnection release];
		getGameRoomConnection=nil;
		getGameRoomConnection = [[GameServerConnection alloc]initToGetEntriesOfRoom:lobbyName maximum:16 keys_only:false types:nil tags:nil hours:0 minutes:8 timeLowerBound:nil delegate:self];
//		getGameRoomConnection=[[GameServerConnection alloc]initToGetEntriesOfRoom:lobbyName maximum:30 tag:nil hours:0 minutes:40 delegate:self];
		[sendingIndicator startAnimating];
		
	}else{
		NSLog(@"Loadding table from server!");
	}
	
}
-(void) toggleChat:(id)sender{
	NSLog(@"Toggled chat!");
	if (chatView.view.superview) {
		[chatView.view removeFromSuperview];
	}else{
		[self.view addSubview:chatView.view];
	}
	
}
//******************************** UI Delegate handle *********************
- (void)pickRoom:(Entry*)room{
	NSString* roomName;
	if([room.tags indexOfObject:@"ShowGame"]!=NSNotFound ){
		roomName=[DataSource firstDataWithSingleTag:@"roomName" InDataString:room.content];
	}else{
		roomName=room.ID;
	}
	NSLog(@"Room name=%@ has been pick up!",roomName);
	if(game==nil){
		game=[[GameViewController alloc] initWithRoomName:roomName];
		game.lobbyName=lobbyName;
	}else [game reloadWithRoomName:roomName];
	
	game.title=[DataSource firstDataWithSingleTag:@"roomTitle" InDataString:room.content];
	
	[self.navigationController pushViewController:game animated:true];
	//Hide chat
	if (chatView.view.superview)[chatView.view removeFromSuperview];
	
}
//********************* GameServerConnection Delegate ***************************

/** Handle entries data when Connection finished loading.
 *  @param entries, NSArray of type: Entry 
 *	
 */
- (void)connection:(GameServerConnection *)connection completedWithResultEntries:(NSArray *)entries{
	if ([connection.tag isEqualToString:@"createGameRoom"]) {
		NSLog(@"Create game room completed!");
		Entry * newTable = [entries objectAtIndex:0];
		//Add newRoom to current listRoom
		[listRoom addObject:newTable];
		[roomPicker.tableView reloadData];
		[roomPicker.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].selected=true;
		//Jump to newRoom immediately
		[self pickRoom:newTable];
		
		
	}else{
	
		NSLog(@"Number Entries = %d",[entries count]);
		[listRoom removeAllObjects];
		
		for (Entry * entry in entries) {
			if ([entry.tags indexOfObject:@"NewGame"]!=NSNotFound || [entry.tags indexOfObject:@"ShowGame"]!=NSNotFound) {
				[listRoom addObject:entry];
			}
		}
		[roomPicker.tableView reloadData];
		
		[sendingIndicator stopAnimating];
	}
}

/** Handle error when request.
 *	
 */
-(void)connection:(GameServerConnection *)connection failedWithError:(NSError *)error{
	NSLog(@"Request has failed!");
	//Handle error here
	[sendingIndicator stopAnimating];
	[self makeToast:NSLocalizedString(@"Warn_ConnectionError", nil) Duration:5 AtLocation:CGPointMake(145, 260)];
}

/** Handle users data when Connection finished loading.
 *  @param users, NSArray of type: User 
 *	
 */
- (void)connection:(GameServerConnection *)connection completedWithResultUsers:(NSArray *)users{
	NSLog(@"Request not yet handle!");
}

/** Handle list id data when Connection finished loading.
 *  @param IDs, NSArray of 64bit id string 
 *	
 */
- (void)connection:(GameServerConnection *)connection completedWithResultIDs:(NSArray *)IDs{
	NSLog(@"Request not yet handle!");
}

/** Handle img_id data when Connection finished loading.
 *  @param img_id, 64bit id string 
 *	
 */
- (void)connection:(GameServerConnection *)connection completedWithImageID:(NSString*)imd_id{
	NSLog(@"Request not yet handle!");
}

@end
