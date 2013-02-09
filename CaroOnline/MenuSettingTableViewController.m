//
//  MenuTableViewController.m
//  CaroOnline
//
//  Created by V.Anh Tran on 24/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuSettingTableViewController.h"

#import "CreateAccountViewController.h"
#import "GeneralSettingViewController.h"

@implementation MenuSettingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		self.title=NSLocalizedString(@"Setting_And_Account", NULL);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"MenuButton";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.textLabel.textColor=[UIColor blueColor];
		//cell.textLabel.backgroundColor=[UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
		//Align all subview to the middle 
		cell.indentationLevel=5;
		//setBackGroundImage for all cells
		//[cell setBackgroundView: [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_background.png"] ] ];
		
	}
    // Configure the cel..
	if (indexPath.row < 3) {
		//Title
		NSString* title= [NSString stringWithFormat: @"titleOfMenuSettingTableView_Cell%d",indexPath.row];
		cell.textLabel.text=NSLocalizedString(title, nil);
		//Icon on the left
		if (indexPath.row==0) {
			cell.imageView.image=[UIImage imageNamed:@"user.png"];
		}else if (indexPath.row==1) {
			cell.imageView.image=[UIImage imageNamed:@"user.png"];
		}else if (indexPath.row==2) {
			cell.imageView.image=[UIImage imageNamed:@"user.png"];
		}
		
	}else{
		cell.textLabel.text=@"";
		cell.imageView.image=nil;
	}
    
	return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	if (indexPath.row == 0) {
     GeneralSettingViewController *detailViewController = [[GeneralSettingViewController alloc] initWithNibName:@"GeneralSettingViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
	 
	 }

	if (indexPath.row == 2) {
     CreateAccountViewController *detailViewController = [[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
	 
	 }
     
}

@end
