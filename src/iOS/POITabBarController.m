//
//  POITabBarController.m
//  Go Map!!
//
//  Created by Bryce Cogswell on 12/14/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import "AppDelegate.h"
#import "EditorMapLayer.h"
#import "MapView.h"
#import "OsmMapData.h"
#import "OsmObjects.h"
#import "POICommonTagsViewController.h"
#import "POITabBarController.h"
#import "POIAttributesViewController.h"

@implementation POITabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

<<<<<<< HEAD
	AppDelegate * appDelegate = AppDelegate.shared;
=======
	AppDelegate * appDelegate = [AppDelegate getAppDelegate];
>>>>>>> c5a8eed4... Revert "Lanestepper"
	OsmBaseObject * selection = appDelegate.mapView.editorLayer.selectedPrimary;
	self.selection = selection;
	self.keyValueDict = [NSMutableDictionary new];
	self.relationList = [NSMutableArray new];
	if ( selection ) {
		[selection.tags enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
			[_keyValueDict setObject:obj forKey:key];
		}];

		self.relationList = [selection.parentRelations mutableCopy];
	}

	NSInteger tabIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"POITabIndex"];
	self.selectedIndex = tabIndex;
<<<<<<< HEAD

	// hide attributes tab on new objects
=======
    
>>>>>>> c5a8eed4... Revert "Lanestepper"
    [self updatePOIAttributesTabBarItemVisibilityWithSelectedObject:selection];
}

- (NSArray *) keyCommands
{
	UIKeyCommand *esc = [UIKeyCommand keyCommandWithInput:UIKeyInputEscape modifierFlags:0 action:@selector(escapeKeyPress:)];
	return @[esc];
}

- (void) escapeKeyPress:(UIKeyCommand *)keyCommand
{
	UIViewController * vc = self.selectedViewController;
	[vc.view endEditing:YES];
	[vc dismissViewControllerAnimated:YES completion:nil];
}

/**
 Hides the POI attributes tab bar item when the user is adding a new item, since it doesn't have any attributes yet.

 @param selectedObject The object that the user selected on the map.
 */
- (void)updatePOIAttributesTabBarItemVisibilityWithSelectedObject:(nullable OsmBaseObject *)selectedObject
{
    BOOL isAddingNewItem = selectedObject == nil;
    if (isAddingNewItem) {
        // Remove the `POIAttributesViewController`.
        NSMutableArray<UIViewController *> *viewControllersToKeep = [NSMutableArray array];
        [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)obj viewControllers].firstObject isKindOfClass:[POIAttributesViewController class]]) {
                // For new objects, the navigation controller that contains the view controller
                // for POI attributes is not needed; ignore it.
                return;
            } else {
                [viewControllersToKeep addObject:obj];
            }
        }];
        
        [self setViewControllers:viewControllersToKeep animated:NO];
    }
}

- (void)setFeatureKey:(NSString *)key value:(NSString *)value
{
	if ( value ) {
		[_keyValueDict setObject:value forKey:key];
	} else {
		[_keyValueDict removeObjectForKey:key];
	}
}

- (void)commitChanges
{
<<<<<<< HEAD
	AppDelegate * appDelegate = AppDelegate.shared;
	[appDelegate.mapView setTagsForCurrentObject:self.keyValueDict];
    [appDelegate.mapView updateEditControl];
=======
	AppDelegate * appDelegate = [AppDelegate getAppDelegate];
	[appDelegate.mapView setTagsForCurrentObject:self.keyValueDict];
>>>>>>> c5a8eed4... Revert "Lanestepper"
}

- (BOOL)isTagDictChanged:(NSDictionary *)newDictionary
{
<<<<<<< HEAD
	AppDelegate * appDelegate = AppDelegate.shared;
=======
	AppDelegate * appDelegate = [AppDelegate getAppDelegate];
>>>>>>> c5a8eed4... Revert "Lanestepper"

	NSDictionary * tags = appDelegate.mapView.editorLayer.selectedPrimary.tags;
	if ( tags.count == 0 )
		return newDictionary.count != 0;

	return ![newDictionary isEqual:tags];
}

- (BOOL)isTagDictChanged
{
	return [self isTagDictChanged:self.keyValueDict];
}



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	NSInteger tabIndex = [tabBar.items indexOfObject:item];
	[[NSUserDefaults standardUserDefaults] setInteger:tabIndex forKey:@"POITabIndex"];
}


@end
