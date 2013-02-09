//
//  ChatViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ChatViewController.h"
#import "DataSource.h"

@interface ChatViewController()


- (UITextField *)getTextFieldRounded;

@end

@implementation ChatViewController

@synthesize chatBox,chatTable,pause,chatName,delegate;

static float scale=0.5f;

static float timeInterval=0.1f;
//auto request each requestInterval (s), must be devide for timeInterval
static float requestInterval=5;


/** Init chat view to chat in a room
 * @param room = room name
 * @delegate if set to nil or it self, delegate will handle request by it self 
 * otherwhile chatView expect messages from method and send message through delegate
 */
- (id)initWithRoom:(NSString *)RoomName delegate:(id)Delegate{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
		entryDict=[[NSMutableDictionary alloc]init];
		lastEntry=[[Entry alloc]init];
		lastEntry.created=@"";
		messages=[[NSMutableArray alloc]initWithObjects: nil];
		roomName=RoomName;
		self.title=roomName;
		
		//Get chat name
		NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
		chatName=[standardUserDefaults objectForKey:@"chatName"];
		
		if (Delegate == nil) {
			delegate=self;
		}else delegate=Delegate;
		
		//Init time counter if delegate is self
		if (delegate==self) {
		time=0;
		timeOfLastRequest=-999;
		[NSTimer scheduledTimerWithTimeInterval:timeInterval
										 target:self
									   selector:@selector(updateCounter:)
									   userInfo:nil
										repeats:YES];
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
	CGRect mainViewBounds=[[UIScreen mainScreen] bounds];
	self.view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, mainViewBounds.size.width*scale, mainViewBounds.size.height*scale)];
	//NSLog(@"%f x %f , %f x %f",mainViewBounds.origin.x,mainViewBounds.origin.y,mainViewBounds.size.width,mainViewBounds.size.height);
	self.view.backgroundColor=[UIColor clearColor];
	
	//Load view here
	NSLog(@"Load subview in Chat View Controller!");
	
	//Init Text Field
	chatBox=[self getTextFieldRounded];
	chatBox.textInputView.backgroundColor = [UIColor clearColor];
	chatBox.textColor=[UIColor blackColor];
	[self.view addSubview:chatBox];
	
	//Init table view for messages
	chatTable = [[ChatMessagesTableViewController alloc]initWithStyle:UITableViewStylePlain Messages:messages];
	[self.view addSubview:chatTable.tableView];
	[self addChildViewController:chatTable];
	UIImageView * backGround = [[UIImageView alloc]initWithImage: [DataSource imageFromPath:[[NSBundle mainBundle] pathForResource:@"Paper Chat-board" ofType:@"png"]] ];
	chatTable.tableView.backgroundView=backGround;
	[backGround release];
	
	
	[self createFrames];
	
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
}
*/


-(void) dealloc{
	//deallocating here
	[entryDict release];
	entryDict = nil;
	[messages release];
	messages = nil;
	[super dealloc];
	NSLog(@"ChatView dealloc");	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	chatBox=nil;
	chatTable=nil;
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	NSLog(@"ChatView didAppear!");
	pause=false;
}

//-(void)viewWillAppear:(BOOL)animated{
//	[super viewWillAppear:animated];
//	
//	NSLog(@"ChatView willAppear!");
//	pause=false;
//}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	NSLog(@"ChatView willDisappear!");
	pause=true;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//******************** UI build functions *****************
- (void)createFrames{
	NSLog(@"Fix toolbar & table view frame for current screen!");
	// size up the toolbar and set its frame to fit current screen
	[chatBox sizeToFit];
	CGRect mainViewBounds = self.view.bounds;
	//NSLog(@"%f x %f , %f x %f",mainViewBounds.origin.x,mainViewBounds.origin.y,mainViewBounds.size.width,mainViewBounds.size.height);
	//NSLog(@"%f x %f , %f x %f",toolbar.frame.origin.x,toolbar.frame.origin.y,toolbar.frame.size.width,toolbar.frame.size.height);
	
	
	
	//+ CGRectGetHeight(self.navigationController.navigationBar.bounds)
	
	// size up the table and set its frame to fit current screen
	chatTable.tableView.frame=CGRectMake(mainViewBounds.origin.x, 
										 mainViewBounds.origin.y, 
										 CGRectGetWidth(mainViewBounds), 
										 CGRectGetHeight(mainViewBounds) - CGRectGetHeight(self.chatBox.bounds) -5 );
	
	[chatBox setFrame:CGRectMake(mainViewBounds.origin.x,
								 mainViewBounds.origin.y+CGRectGetHeight(chatTable.tableView.bounds) + 5,
								 CGRectGetWidth(mainViewBounds),
								 chatBox.frame.size.height)];
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
	
	textFieldRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	// Add an accessibility label that describes what the text field is for.
	//[textFieldRounded setAccessibilityLabel:NSLocalizedString(@"RoundedTextField", @"")];
	
	return textFieldRounded;
}
//********************************** UI event delegate ************************************
- (BOOL)textFieldShouldReturn:(UITextField *)textField	{
	[textField resignFirstResponder];
	if(textField.text.length>0){
		NSString* message=[NSString stringWithFormat:@"%@",textField.text];
		textField.text=@"";
		
		//This 2 line will push message before send, and after receive message, an exactly same message will be added (Duplicated) 
		//[self pushMessage:message];
		//[self reloadMessagesTable];
		
		//call delegate
		[delegate submitMessage:message];
	}
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	NSLog(@"User want to chat!");
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-170, self.view.frame.size.width, self.view.frame.size.height)];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+170, self.view.frame.size.width, self.view.frame.size.height)];
}
//********************************** Method **************************************
-(void)clearMessages{
	[entryDict removeAllObjects];
	[messages removeAllObjects];
}
-(void)pushMessage:(NSString*)message{
	[messages addObject:message];
}
-(void)pushMessages:(NSArray*)Messages{
	[messages addObjectsFromArray:Messages];
}
/** Reload messages table and scroll to bottom
 */
-(void)reloadMessagesTable{
	[chatTable.tableView reloadData];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[messages count]-1 inSection:0];
	if(indexPath.row>0)[chatTable.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
//****************************** Time Event Handle ******************************

- (void)updateCounter:(NSTimer *)theTimer {
	//Count time;
	time += timeInterval;
	//Dont do anything if paused
	if (pause) {
		return;
	}
	//NSLog(@"Count time=%f",time);
	
	if (time>=timeOfLastRequest+requestInterval && ![sendChatMessageConnection isConnecting]) {
		//NSLog(@"Send request!");
		//[[ICTchatConnection alloc] initToGetEntriesOfRoom:roomName maximum:20 delegate:self];
		if (getChatMessageConnection.isConnecting) {
			[getChatMessageConnection cancel];
		}
		[getChatMessageConnection release];
		getChatMessageConnection=nil;
		getChatMessageConnection=[[GameServerConnection alloc]initToGetEntriesOfRoom:roomName maximum:10 keys_only:false types:nil tags:[NSArray arrayWithObjects:@"Chat", nil] hours:0 minutes:10 timeLowerBound:lastEntry.created delegate:self];
//		getChatMessageConnection=[[GameServerConnection alloc]initToGetEntriesWithIDnotInIDdict:entryDict OfRoom:roomName maximum:20 tag:@"Chat" hours:0 minutes:0 delegate:self];
		timeOfLastRequest=time;
	}
}
//********************* Chat Delegate ***************************
- (void)submitMessage:(NSString*)message{
	NSLog(@"User has submit a message %@",message);
	Entry * messageEntry = [[Entry alloc] init];
	messageEntry.tags=[NSArray arrayWithObjects:@"Chat", nil];
	messageEntry.content=[NSString stringWithFormat:@"<name=%@>%@",chatName,message];
	//Init request with entry
	sendChatMessageConnection=[[GameServerConnection alloc]initToSendEntry:messageEntry toRoom:roomName delegate:self];
	[messageEntry release];
}
//********************* GameServerConnection Delegate ***************************

/** Handle entries data when Connection finished loading.
 *  @param entries, NSArray of type: Entry 
 *	
 */
- (void)connection:(GameServerConnection *)connection completedWithResultEntries:(NSArray *)entries{
	NSLog(@"Number Entries = %d",[entries count]);
	int countMessages=[messages count];
	for (Entry * entry in entries) {
		//Avoid duplicated
		if ([entryDict objectForKey:entry.ID]!=nil) {
			continue;
		}
		//Save to entrydict 
		[entryDict setObject:entry forKey:entry.ID];
		lastEntry = entry;
		
		if ([entry.tags indexOfObject:@"Chat"]!=NSNotFound) {
			NSString * name=[DataSource firstDataWithSingleTag:@"name" InDataString:entry.content];
			NSString * text=[DataSource firstNonTagDataAfterSingleTag:@"name" InDataString:entry.content];
			if(name && text)[messages addObject:[NSString stringWithFormat:@"%@: %@",name,text] ];
			else if(text)[messages addObject:text];
		}
		
	}	

	if([messages count]>countMessages)[self reloadMessagesTable];
}

/** Handle error when request.
 *	
 */
-(void)connection:(GameServerConnection *)connection failedWithError:(NSError *)error{
	NSLog(@"Request has failed!");
	//Handle error here
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
