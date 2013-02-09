//
//  PickRoomTableViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameServerConnection.h"

@protocol PickRoomDelegate <NSObject>

/** Event pick a room.
 *	
 */
- (void)pickRoom:(Entry*)room;

@end

@interface PickRoomTableViewController : UITableViewController{
	
}

/** array of NewGame entry
 *	
 */
@property (nonatomic,assign) NSArray* listRoom;

/** array of icon game;
 *	
 */
@property (nonatomic,assign) NSArray* listIcon;

/** will present in reverse way;
 *	
 */
@property (nonatomic) Boolean reverse;

/** delegate of PickRoomDelegate;
 *	
 */
@property (nonatomic,assign)id delegate;

/** Init a table to pick room name
 * @param List = Array of room name
 */
- (id)initWithStyle:(UITableViewStyle)style List:(NSArray*)alist delegate:(id)Delegate;

@end
