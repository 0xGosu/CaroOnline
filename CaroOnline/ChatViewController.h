//
//  ChatViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessagesTableViewController.h"
#import "GameServerConnection.h"

@protocol ChatDelegate <NSObject>

/** Event user submit a message
 *	
 */
- (void)submitMessage:(NSString*)message;


@end

@interface ChatViewController : UIViewController <UITextFieldDelegate, GameServerConnectionDelegate>{
	NSMutableDictionary * entryDict;
	Entry * lastEntry;
	NSMutableArray * messages;
	NSString * roomName;

	float time;
	float timeOfLastRequest;
	
	GameServerConnection * getChatMessageConnection;
	GameServerConnection * sendChatMessageConnection;
	GameServerConnection * getChatEntryIDConnection;
}

@property (nonatomic,retain) UITextField * chatBox;
@property (nonatomic,retain) ChatMessagesTableViewController * chatTable;

@property (nonatomic,assign)id delegate;

/** Pause requesting to server!
 */
@property (nonatomic) Boolean pause;

/** Chat name to chat!
 */
@property (nonatomic,assign) NSString* chatName;

/** Init chat view to chat in a room
 * @param room = room name, if room=nil, chatView expect messages from parent through method
 */
- (id)initWithRoom:(NSString *)RoomName delegate:(id)Delegate;

/** Methods to add message
 */
-(void)clearMessages;
-(void)pushMessage:(NSString*)message;
-(void)pushMessages:(NSArray*)Messages;

/** Reload messages table and scroll to bottom
 */
-(void)reloadMessagesTable;

/** Resize subview
 */
- (void)createFrames;

@end
