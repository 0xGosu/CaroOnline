//
//  GameViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"
#import "DataSource.h"
#import "ImageProcessor.h"
#import "MenuSettingTableViewController.h"

#define chatViewHeightScale 0.66f
#define rangeRandom 10
//Private functions

@interface GameViewController()

- (void)createToolbarItems;
- (void)createFrames;
-(void) changeImageIconToPlayer:(int)p;

@end

@implementation GameViewController

@synthesize toolbar,roomName,chatView,sendingIndicator,roomNamePlaying,lobbyName;


/** Init to play at a room with name
 *	Note: game to play determine by room name;
 */
- (id)initWithRoomName:(NSString*)room{
    roomName=room;
	roomNamePlaying=room;
	refreshCount=3;
	
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
        // Custom initialization
		//NSLog(@"Init Room %@ ",room);
		self.title=room;
		
	}
	
    return self;
}

/** Reload to play a new  caro game
 *	@param room=name of room to load Request from.
 */
- (void)reloadWithRoomName:(NSString*)room{
	refreshCount=3;
	
	if ([room isEqualToString:roomName]){
		[caroOnline reloadWithRoomName:roomNamePlaying];
	}else {
		NSLog(@"Go to room=%@",room);
		[caroOnline reloadWithRoomName:room];
		self.title=room;
		roomName=room;
		roomNamePlaying=room;
		[chatView clearMessages];
		[chatView.view removeFromSuperview];
		[chatView reloadMessagesTable];
		[self submitMessage:NSLocalizedString(@"Hello_", nil)];
	}
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
	NSLog(@"Load subview in Game View Controller!");
	
	//Load image
	UIImage* boardImage=[DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"Paper Board 3" ofType:@"jpg"]];
	UIImage* imageX=[DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"X - Blue" ofType:@"png"]];
	UIImage* imageO=[DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"O - Blue" ofType:@"png"]];
	
	//Load caro online
	caroOnline = [[CaroOnlineViewController alloc]initWithCaroBoard:boardImage imageX:imageX imageO:imageO roomName:roomName];
	//set default player
	caroOnline.player=2;
	[self.view addSubview:caroOnline.view];
	[self addChildViewController:caroOnline];

	[boardImage release];
	[imageX release];
	[imageO release];
	NSLog(@"Caro game online loaded");
	
	//Load image for toolbar Button
	imageXicon = [DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"X button" ofType:@"png"]];
	imageOicon = [DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"O button" ofType:@"png"]];
	
	// create the UIToolbar at the bottom of the view controller
	toolbar = [[UIToolbar alloc]init];
	//[toolbar setBackgroundImage:[[[UIImage alloc]init]autorelease] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	//toolbar.barStyle = UIBarStyleDefault;
	
	//create buttons of toolbar
	[self createToolbarItems];
	[self.view addSubview:toolbar];
	
	chatView = [[ChatViewController alloc]initWithRoom:roomName delegate:self];
	caroOnline.chatView=chatView;
	//[self.view addSubview:chatView.view];
	[self submitMessage:NSLocalizedString(@"Hello_", nil)];
	NSLog(@"ChatView loaded!");
	
	[self createFrames];
	//there is a toolbar frame bug but after rotate it is fixed! This line can fix the bug without rotate
	toolbar.frame = CGRectMake(toolbar.frame.origin.x,toolbar.frame.origin.y-44-20,toolbar.frame.size.width,toolbar.frame.size.height);
	
	NSLog(@"Toolbar loaded!");
	
	//Create Indicator at the right of NavigationBar
	sendingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[sendingIndicator startAnimating];
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:sendingIndicator];
}



//// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//		
//
//}

-(void) dealloc{
	//deallocating here
	[imageXicon release];
	imageXicon=nil;
	[imageOicon release];
	imageOicon=nil;
	[switchSideButton release];
	switchSideButton=nil;
	[roomName release];
	roomName=nil;
	[caroOnline release];
	caroOnline = nil;
	
	[toolbar release];
	toolbar=nil;
	
	[chatView release];
	chatView=nil;
	
	[super dealloc];
	NSLog(@"GameView dealloc!");	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	NSLog(@"GameView unload!");
}

-(void) viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];
	NSLog(@"GameviewDidAppear!");
}
-(void) viewWillDisappear:(BOOL)animated{
	
	[super viewWillDisappear:animated];
	NSLog(@"GameviewWillDisappear!");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	//Fix frame of subviews for current screen
	[self createFrames];
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
	
	//refresh button
//	image=[UIImage imageNamed:@"refresh.png"] ;
//	button = [UIButton buttonWithType:UIButtonTypeCustom];
//	button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
//	[button setImage:image forState:UIControlStateNormal];
//	[button addTarget:self action:@selector(refreshGame:) forControlEvents:UIControlEventTouchUpInside];    
//	
//	UIBarButtonItem *imageItemRefresh = [[UIBarButtonItem alloc] initWithCustomView:button];
	
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
	
	
	
	switchSideButton = [UIButton buttonWithType:UIButtonTypeCustom];
	switchSideButton.bounds = CGRectMake( 0, 0, imageOicon.size.width, imageOicon.size.height );    
	[switchSideButton setImage:imageOicon forState:UIControlStateNormal];
	[switchSideButton addTarget:self action:@selector(changePlayer:) forControlEvents:UIControlEventTouchUpInside]; 
	
	[self changeImageIconToPlayer:caroOnline.player];
	
	UIBarButtonItem *imageItemSwitchSide = [[UIBarButtonItem alloc] initWithCustomView:switchSideButton];
	
	
	NSArray *items = [NSArray arrayWithObjects: imageItemSetting, imageItemNewGame, imageItemHelp, flexItem, imageItemSwitchSide,  imageItemChat, nil];
	[toolbar setItems:items animated:NO];
	
	[flexItem release];
	[imageItemSetting release];
	[imageItemChat release];
	[imageItemSwitchSide release];
	[imageItemNewGame release];
}

-(void) changeImageIconToPlayer:(int)p{
	if (p == 1)[switchSideButton setImage:imageXicon forState:UIControlStateNormal];
	else if (p == 2)[switchSideButton setImage:imageOicon forState:UIControlStateNormal];
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
	
	if (createGameRoomConnection.isConnecting) {
		NSLog(@"Creating!");
		return;
	}
	
	NSLog(@"Create a new table!");
	//Show an arlert to notify user
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New_Game", nil) 
														  message:NSLocalizedString(@"New_Game_Message", nil)
														 delegate:self
												cancelButtonTitle:NSLocalizedString(@"Cancel_", nil) 
												otherButtonTitles:NSLocalizedString(@"Create_", nil),nil
								];
	
	[myAlertView show];
	[myAlertView release];
	
}
-(void)showHelp:(id)sender{
	NSLog(@"Show help using toast!");
	helpCount++;
	if (helpCount==7) helpCount=1;
	if(helpCount==1){
		[self makeToast:NSLocalizedString(@"Help_Setting", nil) Duration:4 AtLocation:CGPointMake(35, 390)];
	}
	if(helpCount==2){
		[self makeToast:NSLocalizedString(@"Help_AskNewGame", nil) Duration:4 AtLocation:CGPointMake(75, 390)];
	}
	if(helpCount==3){
		[self makeToast:NSLocalizedString(@"Help_Tip", nil) Duration:4 AtLocation:CGPointMake(115, 390)];
	}
	if(helpCount==4){
		[self makeToast:NSLocalizedString(@"Help_Tip", nil) Duration:8 AtLocation:CGPointMake(155, 390)];
	}
	if(helpCount==5){
		[self makeToast:NSLocalizedString(@"Help_ChangePlayer", nil) Duration:6 AtLocation:CGPointMake(245, 390)];
	}
	if(helpCount==6){
		[self makeToast:NSLocalizedString(@"Help_Chat", nil) Duration:4 AtLocation:CGPointMake(275, 390)];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//buttonIndex start at 0 from cancelButton to the most right button
	if (buttonIndex==1) {
		Entry * newTable = [[Entry alloc]init];
		
		newTable.tags=[NSArray arrayWithObjects:@"NewGame", nil] ;
		newTable.content=[NSString stringWithFormat:@"<type=Caro><roomTitle=%@>",self.title];
		
		createGameRoomConnection=[[GameServerConnection alloc] initToSendEntry:newTable toRoom:roomName delegate:caroOnline];
		
	}
}

-(void) refreshGame:(id)sender{

	if (refreshGameRoomConnection.isConnecting) {
		NSLog(@"Refreshing!");
		return;
	}
	if (refreshCount>0) {
		refreshCount--;
		NSLog(@"Refresh game to get player!");
		Entry * newTable = [[Entry alloc]init];
		
		newTable.tags=[NSArray arrayWithObjects:@"ShowGame", nil];
		newTable.content=[NSString stringWithFormat:@"<type=Caro><roomTitle=%@><roomName=%@>",self.title,roomNamePlaying];
		
		refreshGameRoomConnection=[[GameServerConnection alloc] initToSendEntry:newTable toRoom:lobbyName delegate:nil];
	}
}

-(void) changePlayer:(id)sender{
	if (!caroOnline.lockPlayer) {
		caroOnline.player++;
		if(caroOnline.player>2)caroOnline.player=1;
		[self changeImageIconToPlayer:caroOnline.player];
		NSLog(@"Player change to %d",caroOnline.player);
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


#pragma mark - Chat delegate
//********************* Chat Delegate ***************************
- (void)submitMessage:(NSString*)message{
	NSLog(@"User has submit a message %@",message);
	Entry * messageEntry = [[Entry alloc] init];
	messageEntry.tags=[NSArray arrayWithObjects:@"Chat", nil];
	messageEntry.content=[NSString stringWithFormat:@"<name=%@>%@",chatView.chatName,message];
	//Init request with entry
	[[GameServerConnection alloc] initToSendEntry:messageEntry toRoom:roomNamePlaying delegate:caroOnline];
	[messageEntry release];
}


@end
