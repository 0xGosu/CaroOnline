//
//  GameViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaroOnlineViewController.h"
#import "ChatViewController.h"
#import "GameServerConnection.h"

@interface GameViewController : UIViewController <ChatDelegate>{
	UIImage * imageXicon;
	UIImage * imageOicon;
	UIButton *switchSideButton;
	
	CaroOnlineViewController* caroOnline;
	
	
	GameServerConnection * createGameRoomConnection;
	GameServerConnection * refreshGameRoomConnection;
	
	int refreshCount;
	int helpCount;
}


@property (nonatomic, assign) NSString * roomName;

@property (nonatomic, assign) NSString * roomNamePlaying;

@property (nonatomic, assign) NSString * lobbyName;

@property (nonatomic, retain)UIToolbar* toolbar;

@property (nonatomic, retain) ChatViewController* chatView;

@property (nonatomic, retain) UIActivityIndicatorView* sendingIndicator;

/** Init to play at a room with name
 *	Note: game to play determine by room name;
 */
- (id)initWithRoomName:(NSString*)room;

/** Reload to play a new  caro game
 *	@param room=name of room to load Request from.
 */
- (void)reloadWithRoomName:(NSString*)room;


-(void)makeToast:(NSString*)message Duration:(CGFloat)duration AtLocation:(CGPoint)point;
- (void)submitMessage:(NSString*)message;

@end
