//
//  NearbyMappersViewController.m
//  Go Map!!
//
//  Created by Bryce Cogswell on 12/26/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import "AppDelegate.h"
#import "EditorMapLayer.h"
#import "OsmMapData.h"
#import "MapView.h"
#import "NearbyMappersViewController.h"
#import "WebPageViewController.h"


@implementation NearbyMappersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableView.estimatedRowHeight = 44;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

	AppDelegate * appDelegate = AppDelegate.shared;

	OSMRect rect = [appDelegate.mapView screenLongitudeLatitude];
	_mappers = [appDelegate.mapView.editorLayer.mapData userStatisticsForRegion:rect];

	_mappers = [_mappers sortedArrayUsingComparator:^NSComparisonResult(OsmUserStatistics * s1, OsmUserStatistics * s2) {
		return -[s1.lastEdit compare:s2.lastEdit];
	}];
}

<<<<<<< HEAD
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ( _mappers.count == 0 ) {
<<<<<<< HEAD
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Data",@"Alert title")
=======
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Data",nil)
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
																		message:NSLocalizedString(@"Ensure the editor view is visible and displays objects in the local area",nil)
																 preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self.navigationController popViewControllerAnimated:YES];
		}]];
		[self presentViewController:alert animated:YES completion:^{
		}];
	}
}

=======
>>>>>>> c5a8eed4... Revert "Lanestepper"
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 	_mappers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

	OsmUserStatistics * stats = _mappers[ indexPath.row ];
	cell.textLabel.text = stats.user;
	NSString * date = [NSDateFormatter localizedStringFromDate:stats.lastEdit dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
	cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%ld edits, last active %@",@"Brief synopsis of a mapper's activity (count,last active date)"), (long)stats.editCount, date];

    return cell;
}

#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	UITableViewCell * cell = sender;
	NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
	OsmUserStatistics * stats = [_mappers objectAtIndex:indexPath.row];
	NSString * user = stats.user;

	WebPageViewController * web = segue.destinationViewController;
	web.title = NSLocalizedString(@"User",nil);
	web.url = [NSString stringWithFormat:@"https://www.openstreetmap.org/user/%@", user];

	[super prepareForSegue:segue sender:sender];
}


@end
