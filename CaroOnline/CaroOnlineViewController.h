//
//  CaroOnlineViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CaroBoard.h"
#import "CaroGameLogic.h"
#import "GameServerConnection.h"
#import "ChatViewController.h"


@interface CaroOnlineViewController : UIViewController <CaroBoardDelegate,GameServerConnectionDelegate,UIAlertViewDelegate>{
	UIImage* boardImage;
	UIImage* imageX; 
	UIImage* imageO;
	NSMutableArray* steps;
	NSMutableArray* messages;
	NSMutableDictionary * entryDict;
	Entry * lastEntry;
	
	float time;
	
	CaroGameLogic * gameControl;
	
	float timeOfLastRequest;
	
	NSTimer * timer;
	UIActivityIndicatorView *sendingIndicator;
	
	CaroBoard * board; 
	UIImageView * redArrow;
	
	NSString * newGameRoomNameAsk;
	
	AVAudioPlayer * beepPlayer;
}

/** Init a view that can play a caro game on it
 *	Provide resources by Images.
 *	@param room=name of room to load Request from.
 */
- (id)initWithCaroBoard:(UIImage*)BoardImage imageX:(UIImage*)imgX imageO:(UIImage*)imgO roomName:(NSString*)room;

/** Reload to play a new  caro game
 *	@param room=name of room to load Request from.
 */
- (void)reloadWithRoomName:(NSString*)room;

/** Side of player 1,2 = x,o
 */
@property (nonatomic) int player;

/** Lock player side
 */
@property (nonatomic) bool lockPlayer;

/** Connection loading
 */
@property (nonatomic, assign) GameServerConnection * getConnection;

/** Connection sending
 */
@property (nonatomic, assign) GameServerConnection * sendStepConnection;

/** Pause requesting to server!
 */
@property (nonatomic) Boolean pause;

/** Room Name
 */
@property (nonatomic, assign) NSString * roomName;

/** ChatView for push messages;
 */
@property (nonatomic, assign) ChatViewController * chatView;

@end
