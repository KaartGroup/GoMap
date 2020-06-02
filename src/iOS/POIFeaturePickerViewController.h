//
//  NewItemController.h
//  Go Map!!
//
//  Created by Bryce Cogswell on 12/10/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import <UIKit/UIKit.h>

<<<<<<< HEAD
@class PresetCategory;
@class PresetFeature;
@class POIFeaturePickerViewController;

@protocol POITypeViewControllerDelegate <NSObject>
-(void)typeViewController:(POIFeaturePickerViewController *)typeViewController didChangeFeatureTo:(PresetFeature *)feature;
@end

@interface POIFeaturePickerViewController : UITableViewController <UISearchBarDelegate>
{
	NSArray					*	_featureList;
=======
@class CommonPresetCategory;
@class CommonPresetFeature;
@class POIFeaturePickerViewController;

@protocol POITypeViewControllerDelegate <NSObject>
-(void)typeViewController:(POIFeaturePickerViewController *)typeViewController didChangeFeatureTo:(CommonPresetFeature *)feature;
@end

@interface POIFeaturePickerViewController : UITableViewController <UISearchBarDelegate, UIAlertViewDelegate>
{
	NSArray					*	_typeArray;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	NSArray					*	_searchArrayRecent;
	NSArray					*	_searchArrayAll;
	IBOutlet UISearchBar    *	_searchBar;
	BOOL						_isTopLevel;
}
<<<<<<< HEAD
@property (strong,nonatomic) PresetCategory				*	parentCategory;
=======
@property (strong,nonatomic) CommonPresetCategory					*	parentCategory;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
@property (assign,nonatomic) id<POITypeViewControllerDelegate>		delegate;

-(IBAction)back:(id)sender;
-(IBAction)configure:(id)sender;


+(void)loadMostRecentForGeometry:(NSString *)geometry;
<<<<<<< HEAD
+(void)updateMostRecentArrayWithSelection:(PresetFeature *)feature geometry:(NSString *)geometry;
=======
+(void)updateMostRecentArrayWithSelection:(CommonPresetFeature *)feature geometry:(NSString *)geometry;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added

@end
