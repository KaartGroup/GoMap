//
//  POIDetailsViewController.m
//  Go Map!!
//
//  Created by Bryce Cogswell on 12/10/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import "AppDelegate.h"
#import "AutocompleteTextField.h"
<<<<<<< HEAD
#import "DLog.h"
#import "EditorMapLayer.h"
#import "HeightViewController.h"
#import "MapView.h"
#import "OsmMapData.h"
#import "POIFeaturePresetsViewController.h"
#import "POIPresetValuePickerController.h"
=======
#import "CommonPresetList.h"
#import "DLog.h"
#import "EditorMapLayer.h"
#import "MapView.h"
#import "OsmMapData.h"
#import "POIFeaturePresetsViewController.h"
#import "POIPresetValuesViewController.h"
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
#import "POITabBarController.h"
#import "POIFeaturePickerViewController.h"
#import "RenderInfo.h"


@interface FeaturePresetCell : UITableViewCell
@property (assign,nonatomic)	IBOutlet	UILabel						*	nameLabel;
@property (assign,nonatomic)	IBOutlet	AutocompleteTextField		*	valueField;
<<<<<<< HEAD
@property (strong,nonatomic)				PresetKey					*	presetKey;
=======
@property (strong,nonatomic)				CommonPresetKey				*	presetKeyInfo;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
@end

@implementation FeaturePresetCell
@end

<<<<<<< HEAD
=======
@interface POIFeaturePresetsViewController() <DirectionViewControllerDelegate>

@end

>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
@implementation POIFeaturePresetsViewController


- (void)viewDidLoad
{
	// have to update presets before call super because super asks for the number of sections
	[self updatePresets];

	[super viewDidLoad];

	self.tableView.estimatedRowHeight = 44.0; // or could use UITableViewAutomaticDimension;
	self.tableView.rowHeight = UITableViewAutomaticDimension;

<<<<<<< HEAD
=======
	_tags = [CommonPresetList sharedList];

>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	if ( _drillDownGroup ) {
		self.navigationItem.leftItemsSupplementBackButton = YES;
		self.navigationItem.leftBarButtonItem = nil;
		self.navigationItem.title = _drillDownGroup.name;
	}
<<<<<<< HEAD
=======

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
	[center addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[center removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardDidShow
{
	_keyboardShowing = YES;
}
-(void)keyboardDidHide
{
	_keyboardShowing = NO;
	dispatch_async(dispatch_get_main_queue(), ^{
		[self updatePresets];
	});
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

-(void)updatePresets
{
	POITabBarController * tabController = (id)self.tabBarController;

	_saveButton.enabled = [tabController isTagDictChanged];
<<<<<<< HEAD
	if (@available(iOS 13.0, *)) {
		self.tabBarController.modalInPresentation = _saveButton.enabled;
	}
=======
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added

	if ( _drillDownGroup == nil ) {

		NSDictionary * dict = tabController.keyValueDict;
		OsmBaseObject * object = tabController.selection;
		NSString * geometry = object ? [object geometryName] : GEOMETRY_NODE;

		// update most recent feature
<<<<<<< HEAD
		PresetFeature * feature = _selectedFeature ?: [PresetsDatabase.shared matchObjectTagsToFeature:dict
																				   geometry:geometry
																				  includeNSI:YES];
		if ( feature ) {
=======
		NSString * featureName = _selectedFeature ? _selectedFeature.featureName : [CommonPresetList featureNameForObjectDict:dict geometry:geometry];
		if ( featureName ) {
			CommonPresetFeature * feature = [CommonPresetFeature commonPresetFeatureWithName:featureName];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
			[POIFeaturePickerViewController loadMostRecentForGeometry:geometry];
			[POIFeaturePickerViewController updateMostRecentArrayWithSelection:feature geometry:geometry];
		}

		__weak POIFeaturePresetsViewController * weakSelf = self;
<<<<<<< HEAD

		_allPresets = [[PresetsForFeature alloc] initWithFeature:feature objectTags:dict geometry:geometry update:^{
				// this may complete much later, even after we've been dismissed
				POIFeaturePresetsViewController * mySelf = weakSelf;
				if ( mySelf && !mySelf->_isEditing ) {
					mySelf->_allPresets = [[PresetsForFeature alloc] initWithFeature:feature objectTags:dict geometry:geometry update:nil];
					[mySelf.tableView reloadData];
				}
			}];
=======
		__weak CommonPresetList * weakTags = _tags;
		[_tags setPresetsForFeature:featureName tags:dict geometry:geometry update:^{
			// this may complete much later, even after we've been dismissed
			POIFeaturePresetsViewController * mySelf = weakSelf;
			if ( mySelf && !mySelf->_keyboardShowing ) {
				[weakTags setPresetsForFeature:featureName tags:dict geometry:geometry update:nil];
				[mySelf.tableView reloadData];
			}
		}];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	}

	[self.tableView reloadData];
}

#pragma mark display

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if ( [self isMovingToParentViewController] ) {
	} else {
		[self updatePresets];
	}
}
-(void)viewWillDisappear:(BOOL)animated
{
	[self resignAll];
	[super viewWillDisappear:animated];
	_selectedFeature = nil;
	_childPushed = YES;
}

<<<<<<< HEAD
- (void)viewDidAppear:(BOOL)animated
{
=======
- (void)viewDidAppear:(BOOL)animated {
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
    [super viewDidAppear:animated];
    
    if (![self isMovingToParentViewController]) {
        // special case: if this is a new object and the user just selected the feature to be shop/amenity,
        // then automatically select the Name field as the first responder
		POITabBarController * tabController = (id)self.tabBarController;
        if ( tabController.isTagDictChanged ) {
            NSDictionary * dict = tabController.keyValueDict;
            if ( dict.count == 1 && (dict[@"shop"] || dict[@"amenity"]) && dict[@"name"] == nil ) {
                // find name field and make it first responder
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath * index = [NSIndexPath indexPathForRow:1 inSection:0];
                    FeaturePresetCell * cell = [self.tableView cellForRowAtIndexPath:index];
<<<<<<< HEAD
                    if ( cell && [cell.presetKey.tagKey isEqualToString:@"name"] ) {
=======
                    if ( cell && [cell.presetKeyInfo.tagKey isEqualToString:@"name"] ) {
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
                        [cell.valueField becomeFirstResponder];
                    }
                });
            }
<<<<<<< HEAD
		} else if ( !_childPushed &&
				   tabController.selection.ident.longLongValue <= 0 &&
				   tabController.keyValueDict.count == 0 )
		{
=======
		} else if ( !_childPushed && tabController.keyValueDict.count == 0 ) {
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
			// if we're being displayed for a newly created node then go straight to the Type picker
			[self performSegueWithIdentifier:@"POITypeSegue" sender:nil];
		}
	}
}

<<<<<<< HEAD
-(void)typeViewController:(POIFeaturePickerViewController *)typeViewController didChangeFeatureTo:(PresetFeature *)newFeature
{
	_selectedFeature = newFeature;
	POITabBarController * tabController = (id) self.tabBarController;
	NSString * geometry = tabController.selection ? [tabController.selection geometryName] : GEOMETRY_NODE;
	PresetFeature * oldFeature = [PresetsDatabase.shared matchObjectTagsToFeature:tabController.keyValueDict
																		 geometry:geometry
																	   includeNSI:YES];

	// remove previous feature tags
	NSMutableDictionary * removeTags = [oldFeature.removeTags mutableCopy];
	[removeTags removeObjectsForKeys:newFeature.addTags.allKeys];
	[removeTags enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL *stop) {
=======
-(void)typeViewController:(POIFeaturePickerViewController *)typeViewController didChangeFeatureTo:(CommonPresetFeature *)feature
{
	_selectedFeature = feature;
	POITabBarController * tabController = (id) self.tabBarController;
	NSString * geometry = tabController.selection ? [tabController.selection geometryName] : GEOMETRY_NODE;
	NSString * oldFeatureName = [CommonPresetList featureNameForObjectDict:tabController.keyValueDict geometry:geometry];
	CommonPresetFeature * oldFeature = [CommonPresetFeature commonPresetFeatureWithName:oldFeatureName];

	// remove previous feature tags
	[oldFeature.removeTags enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL *stop) {
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
		[tabController setFeatureKey:key value:nil];
	}];

	// add new feature tags
<<<<<<< HEAD
	[newFeature.addTags enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL *stop) {
		if ( [value isEqualToString:@"*"] ) {
			if ( tabController.keyValueDict[key] == nil ) {
				[tabController setFeatureKey:key value:@"yes"];
			} else {
				// already has a value
			}
		} else {
			[tabController setFeatureKey:key value:value];
		}
	}];

	// add default values of new feature fields
	NSDictionary * defaults = [newFeature defaultValuesForGeometry:geometry];
=======
	NSDictionary * defaults = [feature defaultValuesForGeometry:geometry];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	[defaults enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL *stop) {
		if ( tabController.keyValueDict[key] == nil ) {
			[tabController setFeatureKey:key value:value];
		}
	}];
<<<<<<< HEAD
=======
	NSDictionary * addTags = feature.addTags;
	[addTags enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL *stop) {
		if ( [value isEqualToString:@"*"] )
			value = @"yes";
		[tabController setFeatureKey:key value:value];
	}];
}

- (NSString *)featureKeyForDict:(NSDictionary *)dict
{
	for ( NSString * tag in [OsmBaseObject featureKeys] ) {
		NSString * value = dict[ tag ];
		if ( value.length ) {
			return tag;
		}
	}
	return nil;
}
- (NSString *)featureStringForDict:(NSDictionary *)dict
{
	NSString * key = [self featureKeyForDict:dict];
	NSString * value = dict[ key ];
	if ( value.length ) {
		NSString * text = [NSString stringWithFormat:@"%@ (%@)", value, key];
		text = [text stringByReplacingOccurrencesOfString:@"_" withString:@" "];
		text = text.capitalizedString;
		return text;
	}
	return nil;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
<<<<<<< HEAD
	return _drillDownGroup ? 1 : _allPresets.sectionCount + 1;
=======
	return _drillDownGroup ? 1 : _tags.sectionCount + 1;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ( _drillDownGroup )
		return _drillDownGroup.name;
<<<<<<< HEAD
	if ( section == _allPresets.sectionCount )
		return nil;
	if ( section > _allPresets.sectionCount )
		return nil;
	PresetGroup * group = [_allPresets groupAtIndex:section];
=======
	if ( section == _tags.sectionCount )
		return nil;
	if ( section > _tags.sectionCount )
		return nil;
	CommonPresetGroup * group = [_tags groupAtIndex:section];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	return group.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( _drillDownGroup )
		return _drillDownGroup.presetKeys.count;
<<<<<<< HEAD
	if ( section == _allPresets.sectionCount )
		return 1;
	if ( section > _allPresets.sectionCount )
		return 0;
	return [_allPresets tagsInSection:section];
=======
	if ( section == _tags.sectionCount )
		return 1;
	if ( section > _tags.sectionCount )
		return 0;
	return [_tags tagsInSection:section];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( _drillDownGroup == nil ) {
<<<<<<< HEAD
		if ( indexPath.section == _allPresets.sectionCount ) {
=======
		if ( indexPath.section == _tags.sectionCount ) {
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
			UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomizePresets" forIndexPath:indexPath];
			return cell;
		}
	}

<<<<<<< HEAD
	POITabBarController	* tabController = (id)self.tabBarController;
	NSDictionary * keyValueDict = tabController.keyValueDict;

	id rowObject = _drillDownGroup ? _drillDownGroup.presetKeys[ indexPath.row ] : [_allPresets presetAtIndexPath:indexPath];
	if ( [rowObject isKindOfClass:[PresetKey class]] ) {

		PresetKey 	* presetKey	= rowObject;
		NSString * key = presetKey.tagKey;
		NSString * cellName = key.length == 0 ? @"CommonTagType"
							: [key isEqualToString:@"name"] ? @"CommonTagName"
							: @"CommonTagSingle";
=======
	id rowObject = _drillDownGroup ? _drillDownGroup.presetKeys[ indexPath.row ] : [_tags tagAtIndexPath:indexPath];
	if ( [rowObject isKindOfClass:[CommonPresetKey class]] ) {

		CommonPresetKey 	* presetKey	= rowObject;
		NSString * key = presetKey.tagKey;
		NSString * cellName = key == nil || [key isEqualToString:@"name"] ? @"CommonTagType" : @"CommonTagSingle";
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added

		FeaturePresetCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
		cell.nameLabel.text = presetKey.name;
		cell.valueField.placeholder = presetKey.placeholder;
		cell.valueField.delegate = self;
<<<<<<< HEAD
		cell.presetKey = presetKey;

		cell.valueField.keyboardType = presetKey.keyboardType;
		cell.valueField.autocapitalizationType = presetKey.autocapitalizationType;

=======
		cell.presetKeyInfo = presetKey;

		cell.valueField.keyboardType = presetKey.keyboardType;
		cell.valueField.autocapitalizationType = presetKey.autocapitalizationType;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
		[cell.valueField removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
		[cell.valueField addTarget:self action:@selector(textFieldReturn:)			forControlEvents:UIControlEventEditingDidEndOnExit];
		[cell.valueField addTarget:self action:@selector(textFieldChanged:)			forControlEvents:UIControlEventEditingChanged];
		[cell.valueField addTarget:self action:@selector(textFieldEditingDidBegin:)	forControlEvents:UIControlEventEditingDidBegin];
		[cell.valueField addTarget:self action:@selector(textFieldDidEndEditing:)	forControlEvents:UIControlEventEditingDidEnd];
<<<<<<< HEAD

		cell.valueField.rightView 	 = nil;

		if ( presetKey.isYesNo ) {
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else if ( presetKey.presetList.count > 0 || key.length == 0 ) {
			// The user can select from a list of presets.
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if ( [self canMeasureDirectionForKey:presetKey] ) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if ( [self canMeasureHeightForKey:presetKey] ) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

		if ( _drillDownGroup == nil && indexPath.section == 0 && indexPath.row == 0 ) {
			// Type cell
			NSString * text = [_allPresets featureName];
			cell.valueField.text = text;
			cell.valueField.enabled = NO;
		} else if ( presetKey.isYesNo ) {
			// special case for yes/no tristate
			TristateButton * button = [TristateButton new];
			NSString * value = keyValueDict[ presetKey.tagKey ];
			if ( [presetKey.tagKey isEqualToString:@"tunnel"] && keyValueDict[@"waterway"] && [value isEqualToString:@"culvert"] ) {
				// Special hack for tunnel=culvert when used with waterways:
				value = @"yes";
			}
			[button setSelectionForString:value];
			if ( [button stringForSelection] == nil ) {
				// display the string iff we don't recognize it (or it's nil)
				cell.valueField.text = [presetKey prettyNameForTagValue:value];
			} else {
				cell.valueField.text = nil;
			}
			cell.valueField.enabled = YES;
			cell.valueField.rightView = button;
			cell.valueField.rightViewMode = UITextFieldViewModeAlways;
			cell.valueField.placeholder = nil;
			button.onSelect = ^(NSString * newValue) {
				if ( [presetKey.tagKey isEqualToString:@"tunnel"] && keyValueDict[@"waterway"] ) {
					// Special hack for tunnel=culvert when used with waterways:
					// See https://github.com/openstreetmap/iD/blob/1ee45ee1f03f0fe4d452012c65ac6ff7649e229f/modules/ui/fields/radio.js#L307
					if ( [newValue isEqualToString:@"yes"] ) {
						newValue = @"culvert";
					} else {
						newValue = nil;	// "no" isn't allowed
					}
				}
				[self updateTagWithValue:newValue forKey:cell.presetKey.tagKey];
				cell.valueField.text = nil;
				[cell.valueField resignFirstResponder];
			};
		} else {
			// Regular cell
			NSString * value = keyValueDict[ presetKey.tagKey ];
			value = [presetKey prettyNameForTagValue:value];
=======
        
        if ([self canUseDirectionViewControllerToMeasureValueForTagWithKey:presetKey.tagKey]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (presetKey.presetList.count > 0) {
            // The user can select from a list of presets.
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

		POITabBarController	* tabController = (id)self.tabBarController;
		NSDictionary * objectDict = tabController.keyValueDict;

		if ( _drillDownGroup == nil && indexPath.section == 0 && indexPath.row == 0 ) {
			// Type cell
			NSString * text = [_tags featureName];
			if ( text == nil )
				text = [self featureStringForDict:objectDict];
			cell.valueField.text = text;
			cell.valueField.enabled = NO;
		} else {
			// Regular cell
			NSString * value = objectDict[ presetKey.tagKey ];
			value = [CommonPresetList friendlyValueNameForKey:presetKey.tagKey value:value geometry:nil];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
			cell.valueField.text = value;
			cell.valueField.enabled = YES;
		}

		return cell;

	} else {

		// drill down cell
<<<<<<< HEAD
		PresetGroup * drillDownGroup = rowObject;
		FeaturePresetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTagSingle" forIndexPath:indexPath];
		cell.nameLabel.text = drillDownGroup.name;
		cell.valueField.text = [drillDownGroup multiComboSummaryOfDict:keyValueDict isPlaceholder:NO];
		cell.valueField.placeholder = [drillDownGroup multiComboSummaryOfDict:nil isPlaceholder:YES];
		cell.valueField.enabled = NO;
		cell.valueField.rightView = nil;
		cell.presetKey = (id)drillDownGroup;
=======
		CommonPresetGroup * drillDownGroup = rowObject;
		FeaturePresetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommonTagDrillDown" forIndexPath:indexPath];
		cell.nameLabel.text = drillDownGroup.name;
		cell.presetKeyInfo = (id)drillDownGroup;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		return cell;
	}
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	FeaturePresetCell * cell = (id) [tableView cellForRowAtIndexPath:indexPath];
	if ( cell.accessoryType == UITableViewCellAccessoryNone )
		return;
    
    // This workaround is necessary because `tableView:cellForRowAtIndexPath:`
    // currently sets `cell.commonPreset` to an instance of `CommonPresetGroup` by casting it to `id`.
<<<<<<< HEAD
    PresetKey *presetKey = nil;
    if ([cell.presetKey isKindOfClass:[PresetKey class]]) {
        presetKey = cell.presetKey;
=======
    CommonPresetKey *presetKey = nil;
    if ([cell.presetKeyInfo isKindOfClass:[CommonPresetKey class]]) {
        presetKey = cell.presetKeyInfo;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
    }

	if ( _drillDownGroup == nil && indexPath.section == 0 && indexPath.row == 0 ) {
		[self performSegueWithIdentifier:@"POITypeSegue" sender:cell];
<<<<<<< HEAD
	} else if ( [cell.presetKey isKindOfClass:[PresetGroup class]] ) {
		// special case for drill down
		PresetGroup * group = (id)cell.presetKey;
		POIFeaturePresetsViewController * sub = [self.storyboard instantiateViewControllerWithIdentifier:@"PoiCommonTagsViewController"];
		sub.drillDownGroup = group;
		[self.navigationController pushViewController:sub animated:YES];
	} else if ([self canMeasureDirectionForKey:presetKey]) {
		[self measureDirectionForKey:cell.presetKey.tagKey
							   value:cell.valueField.text];
	} else if ([self canMeasureHeightForKey:presetKey]) {
		[self measureHeightForKey:cell.presetKey.tagKey];
	} else if ([self canRecognizeOpeningHoursForKey:presetKey]) {
		[self recognizeOpeningHoursForKey:cell.presetKey.tagKey];
=======
    } else if ([self canUseDirectionViewControllerToMeasureValueForTagWithKey:presetKey.tagKey]) {
        [self presentDirectionViewControllerForTagWithKey:cell.presetKeyInfo.tagKey
                                                    value:cell.valueField.text];
	} else if ( [cell.presetKeyInfo isKindOfClass:[CommonPresetGroup class]] ) {
		// special case for drill down
		CommonPresetGroup * group = (id)cell.presetKeyInfo;
		POIFeaturePresetsViewController * sub = [self.storyboard instantiateViewControllerWithIdentifier:@"PoiCommonTagsViewController"];
		sub.drillDownGroup = group;
		[self.navigationController pushViewController:sub animated:YES];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	} else {
		[self performSegueWithIdentifier:@"POIPresetSegue" sender:cell];
	}
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	FeaturePresetCell * cell = sender;
<<<<<<< HEAD
	if ( [segue.destinationViewController isKindOfClass:[POIPresetValuePickerController class]] ) {
		POIPresetValuePickerController * preset = segue.destinationViewController;
		preset.tag = cell.presetKey.tagKey;
		preset.valueDefinitions = cell.presetKey.presetList;
		preset.navigationItem.title = cell.presetKey.name;
=======
	if ( [segue.destinationViewController isKindOfClass:[POIPresetValuesViewController class]] ) {
		POIPresetValuesViewController * preset = segue.destinationViewController;
		preset.tag = cell.presetKeyInfo.tagKey;
		preset.valueDefinitions = cell.presetKeyInfo.presetList;
		preset.navigationItem.title = cell.presetKeyInfo.name;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	} else if ( [segue.destinationViewController isKindOfClass:[POIFeaturePickerViewController class]] ) {
		POIFeaturePickerViewController * dest = (id)segue.destinationViewController;
		dest.delegate = self;
	}
}

-(IBAction)cancel:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)done:(id)sender
{
	[self resignAll];
	[self dismissViewControllerAnimated:YES completion:nil];

	POITabBarController * tabController = (id)self.tabBarController;
	[tabController commitChanges];
}

#pragma mark - Table view delegate


- (void)resignAll
{
	if ( self.tableView.window == nil )
		return;
	for (FeaturePresetCell * cell in self.tableView.visibleCells) {
		[cell.valueField resignFirstResponder];
	}
}


- (IBAction)textFieldReturn:(id)sender
{
	[sender resignFirstResponder];
}

-(FeaturePresetCell *)cellForTextField:(UITextField *)textField
{
	FeaturePresetCell * cell = (id) [textField superview];
	while ( cell && ![cell isKindOfClass:[FeaturePresetCell class]] ) {
		cell = (id)cell.superview;
	}
	return cell;
}

<<<<<<< HEAD
- (IBAction)textFieldEditingDidBegin:(AutocompleteTextField *)textField
=======
- (IBAction)textFieldEditingDidBegin:(UITextField *)textField
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
{
	if ( [textField isKindOfClass:[AutocompleteTextField class]] ) {

		// get list of values for current key
		FeaturePresetCell * cell = [self cellForTextField:textField];
<<<<<<< HEAD
		NSString * key = cell.presetKey.tagKey;
		if ( key == nil )
			return;	// should never happen
		if ( [PresetsDatabase.shared eligibleForAutocomplete:key] ) {
			NSSet * set = [PresetsDatabase.shared allTagValuesForKey:key];
			AppDelegate * appDelegate = AppDelegate.shared;
			NSMutableSet<NSString *> * values = [appDelegate.mapView.editorLayer.mapData tagValuesForKey:key];
			[values addObjectsFromArray:[set allObjects]];
			NSArray * list = [values allObjects];
			textField.autocompleteStrings = list;
		}
	}
	_isEditing = YES;
=======
		NSString * key = cell.presetKeyInfo.tagKey;
		if ( key == nil )
			return;	// should never happen
		NSSet * set = [CommonPresetList allTagValuesForKey:key];
		AppDelegate * appDelegate = [AppDelegate getAppDelegate];
		NSMutableSet<NSString *> * values = [appDelegate.mapView.editorLayer.mapData tagValuesForKey:key];
		[values addObjectsFromArray:[set allObjects]];
		NSArray * list = [values allObjects];
		[(AutocompleteTextField *)textField setCompletions:list];
	}
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

- (IBAction)textFieldChanged:(UITextField *)textField
{
	_saveButton.enabled = YES;
<<<<<<< HEAD
	if (@available(iOS 13.0, *)) {
		self.tabBarController.modalInPresentation = _saveButton.enabled;
	}
=======
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
	FeaturePresetCell * cell = [self cellForTextField:textField];
<<<<<<< HEAD
	NSString * key = cell.presetKey.tagKey;
	if ( key == nil )
		return;	// should never happen

	NSString * prettyValue = textField.text;
	prettyValue = [prettyValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	textField.text = prettyValue;

	// convert to raw value if necessary
	NSString * tagValue = [cell.presetKey tagValueForPrettyName:prettyValue];
	_isEditing = NO;
    [self updateTagWithValue:tagValue forKey:key];

	if ( cell.presetKey.isYesNo ) {
		TristateButton * tri = (id)cell.valueField.rightView;
		if ( [tri isKindOfClass:[TristateButton class]] ) {
			[tri setSelectionForString:textField.text];
		}
	}
=======
	NSString * key = cell.presetKeyInfo.tagKey;
	if ( key == nil )
		return;	// should never happen
	NSString * value = textField.text;
	value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	textField.text = value;

    [self updateTagWithValue:value forKey:key];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

- (void)updateTagWithValue:(NSString *)value forKey:(NSString *)key {
    POITabBarController * tabController = (id)self.tabBarController;
    
    if ( value.length ) {
        [tabController.keyValueDict setObject:value forKey:key];
    } else {
        [tabController.keyValueDict removeObjectForKey:key];
    }
    
    _saveButton.enabled = [tabController isTagDictChanged];
<<<<<<< HEAD
	if (@available(iOS 13.0, *)) {
		self.tabBarController.modalInPresentation = _saveButton.enabled;
	}
=======
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	const int MAX_LENGTH = 255;
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    return newLength <= MAX_LENGTH || returnKey;
}

/**
 Determines whether the `DirectionViewController` can be used to measure the value for the tag with the given key.
 
 @param key The key of the tag that should be measured.
 @return YES if the key can be measured using the `DirectionViewController`, NO if not.
 */
<<<<<<< HEAD
- (BOOL)canMeasureDirectionForKey:(PresetKey *)key
{
	if ( key.presetList.count > 0 )
		return NO;
    NSArray<NSString *> *keys = @[@"direction", @"camera:direction"];
    if ( [keys containsObject:key.tagKey] )
		return YES;
	return NO;
}

- (void)measureDirectionForKey:(NSString *)key value:(NSString *)value
{
    DirectionViewController *directionViewController = [[DirectionViewController alloc] initWithKey:key
                                                                                              value:value
																						   setValue:^(NSString * newValue) {
		[self updateTagWithValue:newValue forKey:key];
	}];
    [self.navigationController pushViewController:directionViewController animated:YES];
}

- (BOOL)canMeasureHeightForKey:(PresetKey *)key
{
	return key.presetList.count == 0 && [key.tagKey isEqualToString:@"height"];
}
- (void)measureHeightForKey:(NSString *)key
{
	if ( [HeightViewController unableToInstantiateWithUserWarning:self] ) {
		return;
	}
	HeightViewController * vc = [HeightViewController instantiate];
	vc.callback = ^(NSString *newValue) {
		[self updateTagWithValue:newValue forKey:key];
	};
	[self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)canRecognizeOpeningHoursForKey:(PresetKey *)key
{
#if !TARGET_OS_MACCATALYST
#if __LP64__	// old architectures don't support SwiftUI
	if (@available(iOS 14.0, *)) {
		return [key.tagKey isEqualToString:@"opening_hours"] ||
			   [key.tagKey hasSuffix:@":opening_hours"];
	}
#endif
#endif
	return NO;
}

- (void)recognizeOpeningHoursForKey:(NSString *)key
{
#if __LP64__	// old architectures don't support SwiftUI
	if (@available(iOS 14.0, *)) {
		UINotificationFeedbackGenerator * feedback = [UINotificationFeedbackGenerator new];
		[feedback prepare];
		UIViewController * vc = [OpeningHoursRecognizerController withOnAccept:^(NSString * _Nonnull newValue) {
			[self updateTagWithValue:newValue forKey:key];
			[self.navigationController popViewControllerAnimated:YES];
		} onCancel:^{
			[self.navigationController popViewControllerAnimated:YES];
		} onRecognize:^(NSString * _Nonnull newValue) {
			[feedback notificationOccurred:UINotificationFeedbackTypeSuccess];
			[feedback prepare];
		}];
		[self.navigationController pushViewController:vc animated:YES];
	}
#endif
=======
- (BOOL)canUseDirectionViewControllerToMeasureValueForTagWithKey:(NSString *)key {
    NSArray<NSString *> *keys = @[@"direction", @"camera:direction"];
    
    return [keys containsObject:key];
}

- (void)presentDirectionViewControllerForTagWithKey:(NSString *)key value:(NSString *)value {
    DirectionViewController *directionViewController = [[DirectionViewController alloc] initWithKey:key
                                                                                              value:value];
    directionViewController.delegate = self;
    
    [self.navigationController pushViewController:directionViewController animated:YES];
}

#pragma mark - <DirectionViewControllerDelegate>

- (void)directionViewControllerDidUpdateTagWithKey:(NSString *)key value:(NSString *)value {
    [self updateTagWithValue:value forKey:key];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}

@end
