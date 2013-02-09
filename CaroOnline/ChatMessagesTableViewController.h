//
//  ChatMessagesTableViewController.h
//  CaroOnline
//
//  Created by V.Anh Tran on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessagesTableViewController : UITableViewController

@property (nonatomic,assign) NSArray* messages;
@property (nonatomic) Boolean reverse;

/** Init a table to pick room name
 * @param List = Array of room name
 */
- (id)initWithStyle:(UITableViewStyle)style Messages:(NSArray*)alist;

@end
