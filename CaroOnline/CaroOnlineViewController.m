//
//  CaroOnlineViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CaroOnlineViewController.h"
#import "DataSource.h"
#import "GameViewController.h"

#define NumColumn 20 
#define NumRow 20 
#define NumWin 5

@implementation CaroOnlineViewController

@synthesize player,lockPlayer,pause,roomName,chatView,getConnection,sendStepConnection;

//Time step
static float timeInterval=0.1f;
//auto request each requestInterval (s), must be devide for timeInterval
static float requestInterval=5;

/** Init a view that can play a caro game on it
 *	Provide resources by Images.
 */
- (id)initWithCaroBoard:(UIImage*)BoardImage imageX:(UIImage*)imgX imageO:(UIImage*)imgO roomName:(NSString*)room
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
		
		
		gameControl=[[CaroGameLogic alloc]init];
		player=1;
		
		
		boardImage=[BoardImage retain];
		imageX=[imgX retain];
		imageO=[imgO retain];
		
		redArrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Red_Arrow.png"]];
		
		steps=[[NSMutableArray alloc] initWithObjects: nil];
		messages=[[NSMutableArray alloc] initWithObjects: nil];
		entryDict=[[NSMutableDictionary alloc]init];
		lastEntry=[[Entry alloc]init];
		lastEntry.created=nil;
				
		//Init time counter
		time=0;
		timeOfLastRequest=0;
										
		NSLog(@"ROOM=%@",room);
		roomName=room;
		newGameRoomNameAsk=nil;
		//Request to get current board of room
		getConnection=[[GameServerConnection alloc]initToGetEntriesOfRoom:roomName maximum:0 keys_only:false types:nil tags:nil hours:0 minutes:0 timeLowerBound:nil delegate:self];

//		getConnection=[[GameServerConnection alloc]initToGetEntriesOfRoom:roomName maximum:200 tag:nil hours:0 minutes:0 delegate:self];

		[[(GameViewController*)self.parentViewController sendingIndicator] startAnimating];
		
		//init audio player
		NSString * path = [[NSBundle mainBundle]pathForResource:@"beep" ofType:@"wav"];
		NSError * error;
		beepPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];

    }
    return self;
}

/** Reload to play a new  caro game
 *	@param room=name of room to load Request from.
 */
- (void)reloadWithRoomName:(NSString*)room{
	lockPlayer=false;
	if(![room isEqualToString:roomName]){
		[gameControl newGame];
		[steps removeAllObjects];
		[messages removeAllObjects];
		[entryDict removeAllObjects];
		lastEntry.created=nil;
			
		//Init time counter
		time=0;
		timeOfLastRequest=0;
		NSLog(@"ROOM=%@",room);

		roomName=room;
		
		//Recreate board view.
		[board removeFromSuperview];
		[board release];
		board=nil;
		board=[[CaroBoard alloc]initWithImage:boardImage Column:NumColumn Row:NumRow Delegate:self];
		[board setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
		[self.view insertSubview:board atIndex:0];
		
	}
	
	//Request to get current board of room
	[getConnection release];
	getConnection = nil;
	getConnection=[[GameServerConnection alloc]initToGetEntriesOfRoom:roomName maximum:0 keys_only:false types:nil tags:nil hours:0 minutes:0 timeLowerBound:lastEntry.created delegate:self];
//    getConnection=[[GameServerConnection alloc]initToGetEntriesOfRoom:roomName maximum:200 tag:nil hours:0 minutes:0 delegate:self];
}

-(void) dealloc{
	//deallocating here

	[boardImage release];
	boardImage=nil;
	
	[imageX release];
	imageX=nil;
	[imageO	release];
	imageO=nil;
	[steps release];
	steps=nil;
	[entryDict release];
	entryDict=nil;
	
	[gameControl release];
	gameControl=nil;
	[sendingIndicator release];
	sendingIndicator=nil;
	[redArrow release];
	redArrow=nil;
	
	//NSLog(@"board retainCount=%d",[board retainCount]);
	[board release];
	//[board release];
	//[board release];
	board=nil;
	
	[super dealloc];
	NSLog(@"CaroOnlineView dealloc");	
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
	//NSLog(@"CaroOnlineView loadView!");
	self.view=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
	board=[[CaroBoard alloc]initWithImage:boardImage Column:NumColumn Row:NumRow Delegate:self];
	//Move to the center of board.
	[board setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
	[self.view addSubview:board];
	
	sendingIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[sendingIndicator startAnimating];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
}

-(void)viewDidAppear:(BOOL)animated{
	NSLog(@"CaroOnlineViewDidAppear!");
	pause=false;
	timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval
										   target:self
										 selector:@selector(updateCounter:)
										 userInfo:nil
										  repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
	NSLog(@"CaroOnlineViewWillDisappear!");
	pause=true;
	[timer invalidate];
	timer=nil;
	//Cancel any connection if they are loading
	NSLog(@"Connections cancel!");
	if ( [(GameViewController*)self.parentViewController sendingIndicator].isAnimating || getConnection.isConnecting ){
		[getConnection cancel];
		[[(GameViewController*)self.parentViewController sendingIndicator] stopAnimating];
	}
	
	if (sendStepConnection.isConnecting) {
		//Remove indicator sending
		[sendingIndicator removeFromSuperview];
		
		[sendStepConnection cancel];
	}
	
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	NSLog(@"Caro Online Game Unloaded!");
	
	
	
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return NO;
}

#pragma mark - Alert Delegate
//****************************** Alert Delegate ******************************
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
		if (newGameRoomNameAsk!=nil) {
			[self reloadWithRoomName:newGameRoomNameAsk];
			newGameRoomNameAsk=nil;
			
			GameViewController* gameView= (GameViewController*)self.parentViewController;
			gameView.roomNamePlaying=roomName;
			
		}
	}
}

#pragma mark - Toast
-(void)makeToast:(NSString*)message Duration:(CGFloat)duration AtLocation:(CGPoint)point{
	NSLog(@"Make toast!");
	UIView * toast= [[UIView alloc]init];
	//"@pink.png",@"purple.png",@"yellow.png",
//	NSArray *colors =[NSArray arrayWithObjects:@"aqua.png",@"brown.png",@"graphite.png",@"green.png",@"orange.png", nil];
	NSString* color= @"green.png";
	UIImage * balloon = [[UIImage imageNamed:color] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
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
	[toast setFrame:CGRectMake(point.x-balloonView.frame.size.width, point.y-balloonView.frame.size.height, balloonView.frame.size.width , balloonView.frame.size.height)];
	[self.view addSubview:toast];
	[toast release];
	[label release];
	[balloonView release];
	[NSTimer scheduledTimerWithTimeInterval:duration
										 target:toast
									   selector:@selector(removeFromSuperview)
									   userInfo:nil
										repeats:NO];
}

#pragma mark - Time Event Handle
//****************************** Time Event Handle ******************************

- (void)updateCounter:(NSTimer *)theTimer {
	//Count time;
	time += timeInterval;
	//Dont do anything if paused
	if (pause) {
		return;
	}
	//NSLog(@"Count time=%f",time);
	
	if (time>=timeOfLastRequest+requestInterval && !sendStepConnection.isConnecting) {
		//NSLog(@"Send request!");
		
		getConnection=[[GameServerConnection alloc] initToGetEntriesOfRoom:roomName maximum:0 keys_only:false types:nil tags:nil hours:0 minutes:0 timeLowerBound:lastEntry.created delegate:self];
		
//		getConnection=[[GameServerConnection alloc] initToGetEntriesWithIDnotInIDdict:entryDict OfRoom:roomName maximum:20 tag:nil hours:0 minutes:0 delegate:self];
		
		timeOfLastRequest=time;
		[[(GameViewController*)self.parentViewController sendingIndicator] startAnimating];
	}
}

#pragma mark - CaroBoard Delegate
//****************************** CaroBoard Delegate ******************************

- (void)clickAtColumn:(int)column Row:(int)row{
	//Check if there is a sending step, user have to wait.
	if (sendStepConnection.isConnecting) {
		NSLog(@"There is a commiting step!");
		return;
	}
	//Check for correct move by listen response
	int response=[gameControl checkPlayer:player willMakeStepAtColumn:column Row:row];
	if (response<0) {
		NSLog(@"Say: Wrong move at %d %d",column,row);
	}else{
		lockPlayer=true;
		//generate entry
		Entry* step= [[Entry alloc]init];
		if (player==1) {
			step.tags=[NSArray arrayWithObjects:@"Xplay", nil];
		}else step.tags=[NSArray arrayWithObjects:@"Oplay", nil];
		
		step.content=[NSString stringWithFormat:@"<column=%d><row=%d>",column,row];
		//Init request with entry
		sendStepConnection=[[GameServerConnection alloc] initToSendEntry:step toRoom:roomName delegate:self];
		sendStepConnection.tag=@"sendStep";
		[step release];
		
		//add sendingIndicator at column , row of caro board
		CGPoint point= [CaroBoard convertCellLocationAtColumn:column Row:row];		
		[sendingIndicator setFrame:CGRectMake(point.x, point.y, [CaroBoard CellSize], [CaroBoard CellSize])];
		[board addSubview:sendingIndicator];//Not use addSubViewAtColumn:Row so we dont need to keep Column and Row value;

	}
}

#pragma mark - ICTchatConnetion Delegate
//********************* ICTchatConnetion Delegate ***************************

/** Handle entries data when Connection finished loading.
 *  @param entries, NSArray of type: Entry 
 *	
 */
- (void)connection:(GameServerConnection *)connection completedWithResultEntries:(NSArray *)entries;{
	NSLog(@"Number Entries = %d",[entries count]);
	int countMessages=[messages count];
	int countSteps=[steps count];
	for (Entry * entry in entries) {
		//Avoid duplicated
		if ([entryDict objectForKey:entry.ID]!=nil) {
			continue;
		}
		//Save to entrydict 
		[entryDict setObject:entry forKey:entry.ID];
		lastEntry = entry;
		
		//Extract value from text		
		//*********catch tag=Xplay or Oplay (a step of player)
		if ([entry.tags indexOfObject:@"Xplay"]!=NSNotFound || [entry.tags indexOfObject:@"Oplay"]!=NSNotFound ) {
			//NSLog(@"New Step = %@",entry.text);
			//catch column
			int column=[[DataSource firstDataWithSingleTag:@"column" InDataString:entry.content] intValue];
			//catch row
			int row=[[DataSource firstDataWithSingleTag:@"row" InDataString:entry.content] intValue];
			
			int p;
			if ([entry.tags indexOfObject:@"Xplay"]!=NSNotFound) {
				p=1;
			}else if ([entry.tags indexOfObject:@"Oplay"]!=NSNotFound) {
				p=2;
			}
			
			
			int response=[gameControl player:p makeStepAtColumn:column Row:row];
			if (response<0) {
				NSLog(@"Request has a wrong step at %d %d",column,row);
			}else{
				//Create imageView
				UIImageView * cell;
				if(p==1) cell= [[UIImageView alloc]initWithImage:imageX];
				else cell=[[UIImageView alloc]initWithImage:imageO];
				
				//add cell at column row
				[board addSubView:cell AtColumn:column Row:row];
				[cell release];
				
				//Move the red arrow to new step
				if([redArrow superview]==Nil){
					[board addSubview:redArrow];
				}
				CGPoint point= [CaroBoard convertCellLocationAtColumn:column Row:row];		
				[redArrow setFrame:CGRectMake(point.x, point.y, [CaroBoard CellSize], [CaroBoard CellSize])];
				
				//Add entry to steps (only valid step are keep in steps)
				[steps addObject:entry];
				
				if ([connection.tag isEqualToString:@"sendStep"]) {
					//Remove indicator sending
					[sendingIndicator removeFromSuperview];
				}
				
				//Play sound effect
				[beepPlayer play];
				
				//Checking winning
				if (response>0) {
					NSLog(@"Game end=%d",response);
					if (countSteps==0) {
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game_End", nil)  message:NSLocalizedString(@"Find_Other_Game", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss_", nil) otherButtonTitles:nil];
						[alert show];
						[alert release];
					}else if(response==player){
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game_End", nil)  message:NSLocalizedString(@"You_Won", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss_", nil) otherButtonTitles:nil];
						[alert show];
						[alert release];
					}else{
						UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Game_End", nil)  message:NSLocalizedString(@"You_Lost", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss_", nil) otherButtonTitles:nil];
						[alert show];
						[alert release];
					}
					
				}
				
			}
		}
		//***********Catch Chat message
		
		if (chatView!=nil && [entry.tags indexOfObject:@"Chat"]!=NSNotFound){
			NSString * name=[DataSource firstDataWithSingleTag:@"name" InDataString:entry.content];
			NSString * text=[DataSource firstNonTagDataAfterSingleTag:@"name" InDataString:entry.content];
			NSString * message;
			if(name && text)message= [NSString stringWithFormat:@"%@: %@",name,text];
			else if(text)message=text;
			
			[chatView pushMessage:message];
			[self makeToast:message Duration:2+0.2*message.length AtLocation:CGPointMake(292, 371)];
			
			//Add entry to messages (only valid message are keep in messages)
			[messages addObject:entry];
		}
		//**********Catch NewGame ask
		
		if ([entry.tags indexOfObject:@"NewGame"]!=NSNotFound) {
			NSString * type=[DataSource firstDataWithSingleTag:@"Type" InDataString:entry.content];
			if ([type isEqualToString:@"Caro"]) {
				newGameRoomNameAsk=entry.ID;
				NSLog(@"NewGameRoomNameAsk=%@",newGameRoomNameAsk);
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Notify_", nil)  
																message:NSLocalizedString(@"New_Game_Ask", nil) 
																delegate:self 
																cancelButtonTitle:nil
																otherButtonTitles:NSLocalizedString(@"OK_", nil), nil];
				
				[alert show];
				[alert release];
				
			}
		}
	
	}//End for
	
	if ([messages count]>countMessages) {
		NSLog(@"Receive %d new message:",[messages count]-countMessages);
		[chatView reloadMessagesTable];
	}
	//stop parent sendingIndicator
	[[(GameViewController*)self.parentViewController sendingIndicator] stopAnimating];
}

/** Handle error when request.
 *	
 */
-(void)connection:(GameServerConnection *)connection failedWithError:(NSError *)error{
	NSLog(@"Request has failed!");
	//Handle error here
	if ([connection.tag isEqualToString:@"sendStep"]) {
		//Remove indicator sending
		[sendingIndicator removeFromSuperview];
	}
	[[(GameViewController*)self.parentViewController sendingIndicator] stopAnimating];
	[(GameViewController*)self.parentViewController makeToast:NSLocalizedString(@"Warn_ConnectionError", nil) Duration:5 AtLocation:CGPointMake(145, 260)];
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

- (void)connection:(GameServerConnection *)connection completedWithImageID:(NSString*)imd_id{
	NSLog(@"Request not yet handle!");
}


@end
