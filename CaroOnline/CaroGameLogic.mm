//
//  CaroGameLogic.m
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CaroGameLogic.h"

#define NumColumn 20 
#define NumRow 20 
#define NumWin 5

@implementation CaroGameLogic

int board[NumRow][NumColumn];
int lastPlayer=1;
bool gameEnd=false;

//Declare functions
int checkBoard(int i,int j);

/** Init Game logic
 *	
 */
-(id) init{
	if ((self = [super init])) {
		//initialize here
		[self newGame];
		//Generate empty board
		
	}
	return self;
}

-(void) dealloc{
	//deallocating here
	NSLog(@"CaroGameLogic dealloc!");
	[super dealloc];	
}

/** Make a new game
 *	
 */
-(void) newGame{
	for (int i=0; i<NumColumn; i++) {
		for (int j=0; j<NumRow; j++) {
			board[i][j]=0;
		}
	}
	gameEnd=false;
	lastPlayer=1;
}

int checkBoard(int x,int y){
	

	//Check for winner p
	int p=board[x][y];
	
	int z;
	int sum=0;
	bool won=false;
	
	//Check row
	sum=0;
	for (z=1; z<NumWin; z++) if(board[x][y-z]!=p)break;
	sum+=z-1;
	for (z=1; z<NumWin; z++) if(board[x][y+z]!=p)break;
	sum+=z-1;
	//NSLog(@"sum =%d",sum);
	if (sum>=NumWin-1) won=true;
		
		
	//Check column
	sum=0;
	for (z=1; z<NumWin; z++) if(board[x-z][y]!=p)break;
	sum+=z-1;
	for (z=1; z<NumWin; z++) if(board[x+z][y]!=p)break;
	sum+=z-1;
	//NSLog(@"sum =%d",sum);
	if (sum>=NumWin-1) won=true;
		
		
	//Check diagonal
	sum=0;
	for (z=1; z<NumWin; z++) if(board[x-z][y-z]!=p)break;
	sum+=z-1;
	for (z=1; z<NumWin; z++) if(board[x+z][y+z]!=p)break;
	sum+=z-1;
	//NSLog(@"sum =%d",sum);
	if (sum>=NumWin-1) won=true;
		
	
	sum=0;
	for (z=1; z<NumWin; z++) if(board[x+z][y-z]!=p)break;
	sum+=z-1;
	for (z=1; z<NumWin; z++) if(board[x-z][y+z]!=p)break;
	sum+=z-1;
	//NSLog(@"sum =%d",sum);
	if (sum>=NumWin-1) won=true;
		
		
	if (won) {
		NSLog(@"Player %d won this game!",p);
		gameEnd=true;
		return p;
	}
				
	
	return 0;
}

/** Check a step of player P
 *	@return =0 no issue, if return <0, not succesfully!.
 */
-(int) checkPlayer:(uint)p willMakeStepAtColumn:(int)x Row:(int)y{
	if (gameEnd == true) {
		NSLog(@"This game has end! Make a new Game");
		return -1;
	}else if (lastPlayer == p || p < 1 || p >2){
		NSLog(@"Player %d is not allowed to make step!",p);
		return -2;
	}else if (board[x][y]!=0 ) {
		NSLog(@"Location %d,%d cant be step on anymore!",x,y);
		return -1;
	}else{
		return 0;
	}
}

/** Make a step for player P
 *	@return id of Winer (0 = no one win), if return <0, not succesfully!.
 */
 -(int) player:(uint)p makeStepAtColumn:(int)x Row:(int)y{
	int check =[self checkPlayer:p willMakeStepAtColumn:x Row:y];
	if (check==0){
		NSLog(@"Player %d has made a step at location %d,%d",p,x,y);
		board[x][y]=p;
		lastPlayer=p;
		return checkBoard(x,y);
	}else return check;
}

	
@end
