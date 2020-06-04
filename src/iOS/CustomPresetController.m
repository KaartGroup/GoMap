//
//  CustomPresetController.h
//  Go Map!!
//
//  Created by Bryce Cogswell on 8/21/14.
//  Copyright (c) 2014 Bryce Cogswell. All rights reserved.
//

<<<<<<< HEAD
<<<<<<< HEAD
=======
#import "CommonPresetList.h"
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
=======
#import "CommonTagList.h"
>>>>>>> c5a8eed4... Revert "Lanestepper"
#import "CustomPresetController.h"
#import "POICommonTagsViewController.h"

@interface CustomPresetController ()
@end

@implementation CustomPresetController

- (void)viewDidLoad
{
	[super viewDidLoad];

	_valueFieldList = @[ _value1Field, _value2Field, _value3Field, _value4Field,  _value5Field,  _value6Field,
						 _value7Field, _value8Field, _value9Field, _value10Field, _value11Field, _value12Field ];

	_nameField.text				= _customPreset.name;
	_appliesToTagField.text		= _customPreset.appliesToKey;
	_appliesToValueField.text	= _customPreset.appliesToValue;
	_keyField.text				= _customPreset.tagKey;

	NSInteger idx = 0;
	for ( UITextField * textField in _valueFieldList ) {
		if ( idx >= _customPreset.presetList.count )
			break;
<<<<<<< HEAD
<<<<<<< HEAD
		PresetValue * preset = _customPreset.presetList[ idx ];
=======
		CommonPresetValue * preset = _customPreset.presetList[ idx ];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
=======
		CommonTagValue * preset = _customPreset.presetList[ idx ];
>>>>>>> c5a8eed4... Revert "Lanestepper"
		textField.text = preset.tagValue;
		++idx;
	}
}


-(IBAction)done:(id)sender
{
	// remove white space from subdomain list
	NSString * name = [_nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString * key  = [_keyField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ( name.length == 0 || key.length == 0 )
		return;
	NSString * appliesToKey = [_appliesToTagField.text	 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString * appliesToVal = [_appliesToValueField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSMutableArray * presets = [NSMutableArray new];
	for ( UITextField * field in _valueFieldList ) {
		NSString * value = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		if ( value.length ) {
<<<<<<< HEAD
<<<<<<< HEAD
			PresetValue * preset = [[PresetValue alloc] initWithName:nil details:nil tagValue:value];
=======
			CommonPresetValue * preset = [CommonPresetValue presetWithName:nil details:nil tagValue:value];
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
=======
			CommonTagValue * preset = [CommonTagValue presetWithName:nil details:nil tagValue:value];
>>>>>>> c5a8eed4... Revert "Lanestepper"
			[presets addObject:preset];
		}
	}
	UIKeyboardType keyboard = UIKeyboardTypeDefault;
	UITextAutocapitalizationType capitalize = UITextAutocapitalizationTypeNone;
	
<<<<<<< HEAD
<<<<<<< HEAD
	_customPreset = [[PresetKeyUserDefined alloc] initWithAppliesToKey:appliesToKey appliesToValue:appliesToVal
														  name:name tagKey:key placeholder:nil keyboard:keyboard capitalize:capitalize presets:presets];
=======
	_customPreset = [[CustomPreset alloc] initWithName:name featureKey:key defaultValue:nil placeholder:nil keyboard:keyboard capitalize:capitalize presets:presets];
=======
	_customPreset = [[CustomPreset alloc] initWithName:name tagKey:key defaultValue:nil placeholder:nil keyboard:keyboard capitalize:capitalize presets:presets];
>>>>>>> c5a8eed4... Revert "Lanestepper"
	_customPreset.appliesToKey = appliesToKey;
	_customPreset.appliesToValue = appliesToVal;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	if ( _completion ) {
		_completion(_customPreset);
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cancel:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)contentChanged:(id)sender
{
	if ( _nameField.text.length > 0 && _keyField.text.length > 0 ) {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	} else {
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
}


@end
