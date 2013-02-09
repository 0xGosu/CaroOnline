//
//  ViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchImageView.h"
#import "CaroBoard.h"
#import "DataSource.h"
#import "CaroGameLogic.h"
#import "CaroOfflineViewController.h"
#import "CaroOnlineViewController.h"
#import "GameViewController.h"
#import "LobbyViewController.h"
#import "ChatViewController.h"

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic,retain)GameViewController * testGame ;
@property (nonatomic,retain)LobbyViewController * testLobby ;

@end
