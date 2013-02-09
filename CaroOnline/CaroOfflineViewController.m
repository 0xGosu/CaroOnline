//
//  CaroOfflineViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CaroOfflineViewController.h"


#define NumColumn 20 
#define NumRow 20 
#define NumWin 5

@implementation CaroOfflineViewController

@synthesize board,gameControl,player;

/** Init a view that can play a caro game on it
 *	Provide resources by Images.
 */
- (id)initWithCaroBoard:(UIImage*)BoardImage imageX:(UIImage*)imgX imageO:(UIImage*)imgO
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
		
		board=[[CaroBoard alloc]initWithImage:BoardImage Column:NumColumn Row:NumRow Delegate:self];
		gameControl=[[CaroGameLogic alloc]init];
		
		imageX=[imgX retain];
		imageO=[imgO retain];
		player=2;
    }
    return self;
}

-(void) dealloc{
	//deallocating here
	[board release];
	board=nil;
	[gameControl release];
	gameControl=nil;
	[imageX release];
	imageX=nil;
	[imageO	release];
	imageO=nil;
	
	[super dealloc];	
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

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	

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

//****************************** CaroBoard Delegate ******************************

- (void)clickAtColumn:(int)column Row:(int)row{
	//Check for correct move by listen response
	int response=[gameControl player:player makeStepAtColumn:column Row:row];
	if (response<0) {
		NSLog(@"Say: Wrong move at %d %d",column,row);
	}else{
		//Create imageView
		UIImageView * cell;
		if(player==1) cell= [[UIImageView alloc]initWithImage:imageX];
		else cell=[[UIImageView alloc]initWithImage:imageO];
		//add cell
		[board addSubView:cell AtColumn:column Row:row];
		[cell release];
		//Change player
		if (player==1) {
			player=2;
		}else player=1;
		
	}
}


@end
