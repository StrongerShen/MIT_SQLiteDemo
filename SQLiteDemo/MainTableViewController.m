//
//  MainTableViewController.m
//  SQLiteDemo
//
//  Created by stronger on 12/11/19.
//  Copyright (c) 2012年 MobileIT. All rights reserved.
//

#import "MainTableViewController.h"
#import "myDB.h"
#import "ViewController.h"


@interface MainTableViewController ()

@end

@implementation MainTableViewController

@synthesize tableSearchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCust:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    custs = [[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    custs = [[myDB sharedInstance] queryCust];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Added methods

- (void)addNewCust:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerAdd"];
    vc.flag = 1;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [custs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",
                           [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_no"],
                           [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_name"]];
    
    
    cell.detailTextLabel.text = [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_tel"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerAdd"];
    vc.flag = 2;
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:
                          [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_no"], @"cust_no",
                          [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_name"], @"cust_name",
                          [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_tel"], @"cust_tel",
                          [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_email"], @"cust_email",
                          [[custs objectAtIndex:indexPath.row] objectForKey:@"cust_addr"], @"cust_addr",
                          nil];
    vc.dicDatas = dics;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[myDB sharedInstance] deleteCustNo:[[custs objectAtIndex:indexPath.row] objectForKey:@"cust_no"]];
        [custs removeObjectAtIndex:indexPath.row];
        // Delete the row in tableView
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString *query = tableSearchBar.text;
    
    if ([query length]==0) {
        custs = [[myDB sharedInstance] queryCust];
    } else {
        custs = [[myDB sharedInstance] queryCustName:query];
    }
    
    [self.tableView reloadData];
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *query = tableSearchBar.text;
    
    if ([query length]==0) {
        custs = [[myDB sharedInstance] queryCust];
    } else {
        custs = [[myDB sharedInstance] queryCustName:query];
    }
    
    [self.tableView reloadData];
}

@end
