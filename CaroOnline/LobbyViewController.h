//
//  LobbyViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickRoomTableViewController.h"
#import "GameViewController.h"
#import "ChatViewController.h"
#import "GameServerConnection.h"
#import "MenuSettingTableViewController.h"

@interface LobbyViewController : UIViewController <PickRoomDelegate,GameServerConnectionDelegate,UIAlertViewDelegate>{
	
	NSMutableArray * listRoom;
	
	NSString * lobbyName;
	GameViewController* game;
	
	
	UIActivityIndicatorView* sendingIndicator;
	GameServerConnection* getGameRoomConnection;
	GameServerConnection* createGameRoomConnection;
	
	UITextField * myTextField;
	
	int helpCount;
}

@property (nonatomic, retain) UIToolbar* toolbar;
@property (nonatomic, retain) PickRoomTableViewController* roomPicker;
@property (nonatomic, retain) ChatViewController* chatView;

/** Init a lobby to pick table game and chat
 * @param ServerName
 */
- (id)initWithLobbyName:(NSString*)lobby;

@end
