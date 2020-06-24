//
//  POICustomTagsViewController.m
//  Go Map!!
//
//  Created by Bryce Cogswell on 12/13/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "EnhancedHwyEditorController.h"
#import "AppDelegate.h"
#import "AutocompleteTextField.h"
#import "CommonPresetList.h"
#import "EditorMapLayer.h"
#import "MapView.h"
#import "OsmMapData.h"
#import "OsmMember.h"
#import "POIAllTagsViewController.h"
#import "POITabBarController.h"
#import "PushPinView.h"
#import "RenderInfo.h"


#define EDIT_RELATIONS 0


@implementation TextPairTableCell

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
	[super willTransitionToState:state];

	// don't allow editing text while deleting
	if ( state & (UITableViewCellStateShowingEditControlMask | UITableViewCellStateShowingDeleteConfirmationMask) ) {
		[_text1 resignFirstResponder];
		[_text2 resignFirstResponder];
	}
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end

@implementation POIAllTagsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIBarButtonItem * editButton = self.editButtonItem;
	[editButton setTarget:self];
	[editButton setAction:@selector(toggleTableRowEditing:)];
	self.navigationItem.rightBarButtonItems = @[ self.navigationItem.rightBarButtonItem, editButton ];
    
    // fetch values from tab controller
    //Loads state
	POITabBarController * tabController = (id)self.tabBarController;
    _tags        = [NSMutableArray arrayWithCapacity:tabController.keyValueDict.count];
    _relations    = [tabController.relationList mutableCopy];
    _members    = tabController.selection.isRelation ? [((OsmRelation *)tabController.selection).members mutableCopy] : nil;
    
    [tabController.keyValueDict enumerateKeysAndObjectsUsingBlock:^(NSString * tag, NSString * value, BOOL *stop) {
        [_tags addObject:[NSMutableArray arrayWithObjects:tag,value,nil]];
    }];
    
    [_tags sortUsingComparator:^NSComparisonResult( NSArray * obj1, NSArray * obj2 ) {
        NSString * tag1 = obj1[0];
        NSString * tag2 = obj2[0];
        BOOL tiger1 = [tag1 hasPrefix:@"tiger:"] || [tag1 hasPrefix:@"gnis:"];
        BOOL tiger2 = [tag2 hasPrefix:@"tiger:"] || [tag2 hasPrefix:@"gnis:"];
        if ( tiger1 == tiger2 ) {
            return [tag1 compare:tag2];
        } else {
            return tiger1 - tiger2;
        }
    }];
    
    [self.tableView reloadData];
    
	if ( tabController.selection.isNode ) {
		self.title = NSLocalizedString(@"Node tags",nil);
	} else if ( tabController.selection.isWay ) {
		self.title = NSLocalizedString(@"Way tags",nil);
	} else if ( tabController.selection.isRelation ) {
		NSString * type = tabController.keyValueDict[ @"type" ];
		if ( type.length ) {
			type = [type stringByReplacingOccurrencesOfString:@"_" withString:@" "];
			type = [type capitalizedString];
			self.title = [NSString stringWithFormat:@"%@ tags",type];
		} else {
			self.title = NSLocalizedString(@"Relation tags",nil);
		}
	} else {
		self.title = NSLocalizedString(@"All Tags",nil);
	}
    _saveButton.enabled = [tabController isTagDictChanged];
}

- (void)saveState
{
    NSMutableDictionary * dict = [self keyValueDictionary];
    POITabBarController * tabController = (id)self.tabBarController;
    tabController.keyValueDict = dict;
}


// return -1 if unchanged, else row to set focus
- (NSInteger)updateWithRecomendationsForFeature:(BOOL)forceReload
{
	POITabBarController * tabController = (id)self.tabBarController;
	NSString * geometry = tabController.selection.geometryName ?: GEOMETRY_NODE;
	NSDictionary * dict = [self keyValueDictionary];
	NSString * newFeature = [PresetsDatabase featureNameForObjectDict:dict geometry:geometry];

	if ( !forceReload && [newFeature isEqualToString:_featureName] )
		return -1;
	_featureName = newFeature;

	// remove all entries without key & value
	[_tags filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSArray<NSString *> * kv, id bindings) {
		return kv[0].length && kv[1].length;
	}]];

	NSInteger nextRow = _tags.count;

	// add new cell ready to be edited
	[_tags addObject:[NSMutableArray arrayWithObjects:@"", @"", nil]];

	// add placeholder keys
	if ( newFeature ) {
		PresetsForFeature * presets = [PresetsForFeature presetsForFeature:newFeature objectTags:dict geometry:geometry update:nil];
		NSMutableArray * newKeys = [NSMutableArray new];
		for ( NSInteger section = 0; section < presets.sectionCount; ++section ) {
			for ( NSInteger row = 0; row < [presets tagsInSection:section]; ++row ) {
				id preset = [presets presetAtSection:section row:row];
				if ( [preset isKindOfClass:[PresetGroup class]] ) {
					PresetGroup * group = preset;
					for ( PresetKey * presetKey in group.presetKeys ) {
						if ( presetKey.tagKey.length == 0 )
							continue;
						[newKeys addObject:presetKey.tagKey];
					}
				} else {
					PresetKey * presetKey = preset;
					if ( presetKey.tagKey.length == 0 )
						continue;
					[newKeys addObject:presetKey.tagKey];
				}
			}
		}
		[newKeys filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString * key, NSDictionary<NSString *,id> * bindings) {
			for ( NSArray<NSString *> * kv in _tags ) {
				if ( [kv[0] isEqualToString:key] )
					return NO;
			}
			return YES;
		}]];
		[newKeys sortWithOptions:0 usingComparator:^NSComparisonResult(NSString * p1, NSString * p2) {
			return [p1 compare:p2];
		}];
		for ( NSString * key in newKeys ) {
			[_tags addObject:[NSMutableArray arrayWithObjects:key, @"", nil]];
		}
	}

	[self.tableView reloadData];

	return nextRow;
}

- (void)loadState
{
	POITabBarController * tabController = (id)self.tabBarController;

	// fetch values from tab controller
	_tags		= [NSMutableArray arrayWithCapacity:tabController.keyValueDict.count];
	_relations	= [tabController.relationList mutableCopy];
	_members	= tabController.selection.isRelation ? [((OsmRelation *)tabController.selection).members mutableCopy] : nil;

	[tabController.keyValueDict enumerateKeysAndObjectsUsingBlock:^(NSString * tag, NSString * value, BOOL *stop) {
		[_tags addObject:[NSMutableArray arrayWithObjects:tag,value,nil]];
	}];

	[_tags sortUsingComparator:^NSComparisonResult( NSArray * obj1, NSArray * obj2 ) {
		NSString * tag1 = obj1[0];
		NSString * tag2 = obj2[0];
		BOOL tiger1 = [tag1 hasPrefix:@"tiger:"] || [tag1 hasPrefix:@"gnis:"];
		BOOL tiger2 = [tag2 hasPrefix:@"tiger:"] || [tag2 hasPrefix:@"gnis:"];
		if ( tiger1 == tiger2 ) {
			return [tag1 compare:tag2];
		} else {
			return tiger1 - tiger2;
		}
	}];

	[self updateWithRecomendationsForFeature:YES];

	_saveButton.enabled = [tabController isTagDictChanged];
	if (@available(iOS 13.0, *)) {
		self.tabBarController.modalInPresentation = _saveButton.enabled;
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if ( _showingWikiLink ) {
		_showingWikiLink = NO;
	} else {
		[self loadState];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self saveState];
	[super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ( _tags.count == 0 && _members.count == 0 ) {
		// if there are no tags then start editing the first one
		[self addTagCellAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	POITabBarController * tabController = (id)self.tabBarController;
    if (tabController.selection.isRelation) {
		return 3;
    } else if (_relations.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ( section == 0 ) {
		return NSLocalizedString(@"Tags",nil);
	} else if ( section == 1 ) {
		return NSLocalizedString(@"Relations",nil);
	} else {
		return NSLocalizedString(@"Members",nil);
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if ( section == 2 ) {
		return NSLocalizedString(@"You can navigate to a relation member only if it is already downloaded.\nThese members are marked with '>'.", nil);
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( section == 0 ) {
		// tags
		return _tags.count;
	} else if ( section == 1 ) {
		// relations
		return _relations.count;
	} else {
#if EDIT_RELATIONS
		return _members.count + 1;
#else
		return _members.count;
#endif
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( [cell.text1.text isEqualToString:@"colour"] ||
		 [cell.text1.text isEqualToString:@"color"] ||
		 [cell.text1.text hasSuffix:@":colour"] ||
		 [cell.text1.text hasSuffix:@":color"] )
	{
		UIColor * color = [Colors cssColorForColorName:cell.text2.text];
		if ( color ) {
			CGFloat size = cell.text2.bounds.size.height;
			size = round( size * 0.5 );
			UIView * square = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
			square.backgroundColor = color;
			square.layer.borderColor = UIColor.blackColor.CGColor;
			square.layer.borderWidth = 1.0;
			UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size+6, size)];
			view.backgroundColor = UIColor.clearColor;
			[view addSubview:square];
			cell.text2.rightView = view;
			cell.text2.rightViewMode = UITextFieldViewModeAlways;
			return;
		}
	}
	cell.text2.rightView = nil;
	cell.text2.rightViewMode = UITextFieldViewModeNever;
}

-(IBAction)openWebsite:(id)sender
{
	TextPairTableCell * pair = (id)sender;
	while ( pair && ![pair isKindOfClass:[UITableViewCell class]])
		pair = (id)pair.superview;

	NSString * string = nil;
	if ( [pair.text1.text isEqualToString:@"wikipedia"] ||
		 [pair.text1.text hasSuffix:@":wikipedia"] )
	{
		NSArray<NSString *> * a = [pair.text2.text componentsSeparatedByString:@":"];
		NSString * lang = [a[0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
		NSString * page = [a[1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
		string = [NSString stringWithFormat:@"https://%@.wikipedia.org/wiki/%@",lang,page];
	} else if ( [pair.text1.text isEqualToString:@"wikidata"] ||
				[pair.text1.text hasSuffix:@":wikidata"] )
	{
		NSString * page = [pair.text2.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
		string = [NSString stringWithFormat:@"https://www.wikidata.org/wiki/%@",page];
	} else if ( [pair.text2.text hasPrefix:@"http://"] ||
				[pair.text2.text hasPrefix:@"https://"] )
	{
		string = pair.text2.text;
	}
	if ( string ) {
		NSURL * url = [NSURL URLWithString:string];
		if ( url ) {
			SFSafariViewController * viewController = [[SFSafariViewController alloc] initWithURL:url];
			[self presentViewController:viewController animated:YES completion:nil];
		} else {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid URL", nil)
																			message:nil
																	 preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:alert animated:YES completion:nil];
		}
	}
}

		TextPairTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
		NSArray * kv = _tags[ indexPath.row ];
		// assign text contents of fields
		cell.text1.enabled = YES;
		cell.text2.enabled = YES;
		cell.text1.text = kv[0];
		cell.text2.text = kv[1];

- (void)addTagCell:(id)sender
{
    UITableViewCell * cell = sender;    // starts out as UIButton
    while ( cell && ![cell isKindOfClass:[UITableViewCell class]] )
        cell = (id)[cell superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if ( indexPath.section == 0 ) {
        [_tags addObject:[NSMutableArray arrayWithObjects:@"",@"",nil]];
    } else if ( indexPath.section == 2 ) {
        [_members addObject:[NSMutableArray arrayWithObjects:@"",@"",nil]];
    } else {
        return;
    }
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];

    // set new cell to show keyboard
    TextPair *newCell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
    [newCell.text1 becomeFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 ) {

        // Tags
        if ( indexPath.row == _tags.count ) {
            // Add new tag
            AddNewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
            [cell.button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
            [cell.button addTarget:self action:@selector(addTagCell:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }

        TextPair * cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell" forIndexPath:indexPath];
        NSArray * kv = _tags[ indexPath.row ];
        // assign text contents of fields
        cell.text1.enabled = YES;
        cell.text2.enabled = YES;
        cell.text1.text = kv[0];
        cell.text2.text = kv[1];

        cell.text1.didSelectAutocomplete = ^{ [cell.text2 becomeFirstResponder]; };
        cell.text2.didSelectAutocomplete = ^{};

		return cell;

    } else if ( indexPath.section == 1 ) {

		// Relations
		if ( indexPath.row == _relations.count ) {
			UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
			return cell;
		}
		TextPairTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelationCell" forIndexPath:indexPath];
		cell.text1.enabled = NO;
		cell.text2.enabled = NO;
		OsmRelation	* relation = _relations[ indexPath.row ];
		cell.text1.text = relation.ident.stringValue;
		cell.text2.text = [relation friendlyDescription];

        return cell;

    } else {

		// Members
		if ( indexPath.row == _members.count ) {
			AddNewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell" forIndexPath:indexPath];
			[cell.button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
			[cell.button addTarget:self action:@selector(addTagCell:) forControlEvents:UIControlEventTouchUpInside];
			return cell;
		}
		TextPairTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
#if EDIT_RELATIONS
        cell.text1.enabled = YES;
        cell.text2.enabled = YES;
#else
        cell.text1.enabled = NO;
        cell.text2.enabled = NO;
#endif
		OsmMember	* member = _members[ indexPath.row ];
		if ( [member isKindOfClass:[OsmMember class]] ) {
			OsmBaseObject * ref = member.ref;
			NSString * memberName = [ref isKindOfClass:[OsmBaseObject class]] ? ref.friendlyDescriptionWithDetails : [NSString stringWithFormat:@"%@ %@",member.type, member.ref];
			cell.text1.text = member.role;
			cell.text2.text = memberName;
		} else {
			NSArray * values = (id)member;
			cell.text1.text = values[0];
			cell.text2.text = values[1];
		}

		return cell;
	}
}

- (IBAction)toggleEditing:(id)sender
{
    POITabBarController * tabController = (id)self.tabBarController;

    BOOL editing = !self.tableView.editing;
    self.navigationItem.leftBarButtonItem.enabled = !editing;
    self.navigationItem.rightBarButtonItem.enabled = !editing && [tabController isTagDictChanged];
    [self.tableView setEditing:editing animated:YES];
    UIBarButtonItem * button = sender;
    button.title = editing ? NSLocalizedString(@"Done",nil) : NSLocalizedString(@"Edit",nil);
    button.style = editing ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
}

-(NSMutableDictionary *)keyValueDictionary
{
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:_tags.count];
	for ( NSArray * kv in _tags ) {

		// strip whitespace around text
		NSString * key = kv[0];
		NSString * val = kv[1];

		key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

		if ( key.length && val.length ) {
			[dict setObject:val forKey:key];
		}
	}
	return dict;
}

#pragma mark Cell editing

- (IBAction)textFieldReturn:(id)sender
{
	TextPairTableCell * cell = (id)sender;
	while ( cell && ![cell isKindOfClass:[UITableViewCell class]])
		cell = (id)cell.superview;

	[sender resignFirstResponder];
	[self updateWithRecomendationsForFeature:YES];
}

- (IBAction)textFieldEditingDidBegin:(AutocompleteTextField *)textField
{
	UITableViewCell * cell = (id)textField.superview;
	while ( cell && ![cell isKindOfClass:[UITableViewCell class]])
		cell = (id)cell.superview;
	TextPairTableCell * pair = (id)cell;
	BOOL isValue = textField == pair.text2;

	TextPairTableCell * pair = (id)textField.superview;
	while ( pair && ![pair isKindOfClass:[UITableViewCell class]])
		pair = (id)pair.superview;
	NSIndexPath * indexPath = [self.tableView indexPathForCell:pair];

	if ( indexPath.section == 0 ) {

		BOOL isValue = textField == pair.text2;
		NSMutableArray * kv = _tags[ indexPath.row ];

		if ( isValue ) {
			// get list of values for current key
			NSString * key = kv[0];
			NSSet * set = [CommonPresetList allTagValuesForKey:key];
			AppDelegate * appDelegate = [AppDelegate getAppDelegate];
			NSMutableSet<NSString *> * values = [appDelegate.mapView.editorLayer.mapData tagValuesForKey:key];
			[values addObjectsFromArray:[set allObjects]];
			NSArray * list = [values allObjects];
			textField.strings = list;
		} else {
			// get list of keys
			NSSet * set = [CommonPresetList allTagKeys];
			NSArray * list = [set allObjects];
			textField.strings = list;
		}
	}
}

-(NSString *)convertWikiUrlToReferenceWithKey:(NSString *)key value:(NSString *)url
{
	if ( [key hasPrefix:@"wikipedia"] ) {
		// if the value is for wikipedia then convert the URL to the correct format
		// format is https://en.wikipedia.org/wiki/Nova_Scotia
		NSScanner * scanner = [NSScanner scannerWithString:url];
		NSString *languageCode, *pageName;
		if ( ([scanner scanString:@"https://" intoString:nil] || [scanner scanString:@"http://" intoString:nil]) &&
			[scanner scanUpToString:@"." intoString:&languageCode] &&
			([scanner scanString:@".m" intoString:nil] || YES) &&
			[scanner scanString:@".wikipedia.org/wiki/" intoString:nil] &&
			[scanner scanUpToString:@"/" intoString:&pageName] &&
			[scanner isAtEnd] &&
			languageCode.length == 2 &&
			pageName.length > 0 )
		{
			return [NSString stringWithFormat:@"%@:%@",languageCode,pageName];
		}
	} else if ( [key hasPrefix:@"wikidata"] ) {
		// https://www.wikidata.org/wiki/Q90000000
		NSScanner * scanner = [NSScanner scannerWithString:url];
		NSString *pageName;
		if ( ([scanner scanString:@"https://" intoString:nil] || [scanner scanString:@"http://" intoString:nil]) &&
			([scanner scanString:@"www.wikidata.org/wiki/" intoString:nil] || [scanner scanString:@"m.wikidata.org/wiki/" intoString:nil]) &&
			[scanner scanUpToString:@"/" intoString:&pageName] &&
			[scanner isAtEnd] &&
			pageName.length > 0 )
		{
			return pageName;
		}
	}
	return nil;
}

-(void)textFieldEditingDidEnd:(UITextField *)textField
{
	TextPairTableCell * pair = (id)textField.superview;
	while ( pair && ![pair isKindOfClass:[UITableViewCell class]])
		pair = (id)pair.superview;

	NSIndexPath * indexPath = [self.tableView indexPathForCell:pair];
	if ( indexPath.section == 0 ) {
		NSMutableArray<NSString *> * kv = _tags[ indexPath.row ];

		[self setAssociatedColorForCell:pair];
		[self setWebsiteButtonForCell:pair];

		if ( kv[0].length && kv[1].length ) {

			// do wikipedia conversion
			NSString * newValue = [self convertWikiUrlToReferenceWithKey:kv[0] value:kv[1]];
			if ( newValue ) {
				kv[1] = newValue;
				pair.text2.text = newValue;
			}

			// move the edited row up
			for ( NSInteger i = 0; i < indexPath.row; ++i ) {
				NSArray<NSString *> * a = _tags[i];
				if ( a[0].length == 0 || a[1].length == 0 ) {
					[_tags removeObjectAtIndex:indexPath.row];
					[_tags insertObject:kv atIndex:i];
					[self.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
					break;
				}
			}

			// if we created a row that defines a key that duplicates a row witht the same key elsewhere then delete the other row
			for ( NSInteger i = 0; i < _tags.count; ++i ) {
				NSArray<NSString *> * a = _tags[i];
				if ( a != kv && [a[0] isEqualToString:kv[0]] ) {
					[_tags removeObjectAtIndex:i];
					[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
				}
			}

			// update recommended tags
			NSInteger nextRow = [self updateWithRecomendationsForFeature:NO];
			if ( nextRow >= 0 ) {
				// a new feature was defined
				NSIndexPath * newPath = [NSIndexPath indexPathForRow:nextRow inSection:0];
				[self.tableView scrollToRowAtIndexPath:newPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

				// move focus to next empty cell
				TextPairTableCell * nextCell = [self.tableView cellForRowAtIndexPath:newPath];
				[nextCell.text1 becomeFirstResponder];
			}

		} else if ( kv[0].length || kv[1].length ) {

			// ensure there's a blank line either elsewhere, or create one below us
			BOOL haveBlank = NO;
			for ( NSArray<NSString *> * a in _tags ) {
				haveBlank = a != kv && a[0].length == 0 && a[1].length == 0;
				if ( haveBlank )
					break;
			}
			if ( !haveBlank ) {
				NSIndexPath * newPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
				[_tags insertObject:[NSMutableArray arrayWithObjects:@"", @"", nil] atIndex:newPath.row];
				[self.tableView insertRowsAtIndexPaths:@[newPath] withRowAnimation:UITableViewRowAnimationNone];
			}
		}
	}
}

-(void)textFieldEditingDidEnd:(UITextField *)textField
{
	UITableViewCell * cell = (id)textField.superview;
	while ( cell && ![cell isKindOfClass:[UITableViewCell class]])
		cell = (id)cell.superview;
	TextPairTableCell * pair = (id)cell;
	BOOL isValue = textField == pair.text2;

	NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
	if ( indexPath.section == 0 ) {
		if ( isValue ) {
			NSMutableArray<NSString *> * kv = _tags[ indexPath.row ];
			if ( [kv[0] hasPrefix:@"wikipedia"] ) {
				// if the value is for wikipedia then convert the a URL to the correct format
				// format is https://en.wikipedia.org/wiki/Nova_Scotia
				NSScanner * scanner = [NSScanner scannerWithString:kv[1]];
				NSString *languageCode, *pageName;
				if ( ([scanner scanString:@"https://" intoString:nil] || [scanner scanString:@"http://" intoString:nil]) &&
					[scanner scanUpToString:@"." intoString:&languageCode] &&
					([scanner scanString:@".m" intoString:nil] || YES) &&
					[scanner scanString:@".wikipedia.org/wiki/" intoString:nil] &&
					[scanner scanUpToString:@"/" intoString:&pageName] &&
					[scanner isAtEnd] &&
					languageCode.length == 2 &&
					pageName.length > 0 )
				{
					kv[1] = [NSString stringWithFormat:@"%@:%@",languageCode,pageName];
					pair.text2.text = kv[1];
				}
			} else if ( [kv[0] hasPrefix:@"wikidata"] ) {
				// https://www.wikidata.org/wiki/Q90000000
				NSScanner * scanner = [NSScanner scannerWithString:kv[1]];
				NSString *pageName;
				if ( ([scanner scanString:@"https://" intoString:nil] || [scanner scanString:@"http://" intoString:nil]) &&
					([scanner scanString:@"www.wikidata.org/wiki/" intoString:nil] || [scanner scanString:@"m.wikidata.org/wiki/" intoString:nil]) &&
					[scanner scanUpToString:@"/" intoString:&pageName] &&
					[scanner isAtEnd] &&
					pageName.length > 0 )
				{
					kv[1] = pageName;
					pair.text2.text = kv[1];
				}
			}
		} else {
			// editing key
		}
	}
}

- (IBAction)textFieldChanged:(UITextField *)textField
{
	UITableViewCell * cell = (id)textField.superview;
	while ( cell && ![cell isKindOfClass:[UITableViewCell class]])
		cell = (id)cell.superview;
	NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];

	POITabBarController * tabController = (id)self.tabBarController;

	if ( indexPath.section == 0 ) {
		// edited tags
		TextPairTableCell * pair = (id)cell;
		NSMutableArray * kv = _tags[ indexPath.row ];
		BOOL isValue = textField == pair.text2;

		if ( isValue ) {
			// new value
			kv[1] = textField.text;
		} else {
			// new key name
			kv[0] = textField.text;
		}
		
		NSMutableDictionary * dict = [self keyValueDictionary];
		_saveButton.enabled = [tabController isTagDictChanged:dict];
		if (@available(iOS 13.0, *)) {
			self.tabBarController.modalInPresentation = _saveButton.enabled;
		}
	}
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

- (IBAction)toggleEditing:(id)sender
{
	POITabBarController * tabController = (id)self.tabBarController;

	BOOL editing = !self.tableView.editing;
	self.navigationItem.leftBarButtonItem.enabled = !editing;
	self.navigationItem.rightBarButtonItem.enabled = !editing && [tabController isTagDictChanged];
	[self.tableView setEditing:editing animated:YES];
	UIBarButtonItem * button = sender;
	button.title = editing ? NSLocalizedString(@"Done",nil) : NSLocalizedString(@"Edit",nil);
	button.style = editing ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
}


// Don't allow deleting the "Add Tag" row
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 0 ) {
		return indexPath.row < _tags.count;
	} else if ( indexPath.section == 1 ) {
		// don't allow editing relations here
		return NO;
	} else {
#if EDIT_RELATIONS
		return indexPath.row < _members.count;
#else
		return NO;
#endif
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( editingStyle == UITableViewCellEditingStyleDelete ) {
		// Delete the row from the data source
		POITabBarController * tabController = (id)self.tabBarController;
		if ( indexPath.section == 0 ) {
			NSArray * kv = _tags[ indexPath.row ];
			NSString * tag = kv[0];
			[tabController.keyValueDict removeObjectForKey:tag];
			[_tags removeObjectAtIndex:indexPath.row];
		} else if ( indexPath.section == 1 ) {
			[_relations removeObjectAtIndex:indexPath.row];
		} else  {
			[_members removeObjectAtIndex:indexPath.row];
		}
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

		_saveButton.enabled = [tabController isTagDictChanged];

	} else if ( editingStyle == UITableViewCellEditingStyleInsert ) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}

#pragma mark - Table view delegate

- (void)addTagCellAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 0 ) {
		[_tags addObject:[NSMutableArray arrayWithObjects:@"",@"",nil]];
	} else if ( indexPath.section == 2 ) {
		[_members addObject:[NSMutableArray arrayWithObjects:@"",@"",nil]];
	} else {
		return;
	}
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];

	// set new cell to show keyboard
	TextPairTableCell * newCell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
	[newCell.text1 becomeFirstResponder];
}

- (void)addTagCell:(id)sender
{
	UITableViewCell * cell = sender;	// starts out as UIButton
	while ( cell && ![cell isKindOfClass:[UITableViewCell class]] )
		cell = (id)[cell superview];
	NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
	[self addTagCellAtIndexPath:indexPath];
}

-(IBAction)cancel:(id)sender
{
    [self.view endEditing:YES];
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
	[self saveState];

	POITabBarController * tabController = (id)self.tabBarController;
	[tabController commitChanges];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( indexPath.section == 0 ) {
		// show OSM wiki page
		TextPairTableCell * cell = [tableView cellForRowAtIndexPath:indexPath];
		NSString * key = cell.text1.text;
		NSString * value = cell.text2.text;
		if ( key.length == 0 )
			return;
		PresetLanguages * presetLanguages = [PresetLanguages new];
		NSString * languageCode = presetLanguages.preferredLanguageCode;

		UIActivityIndicatorView * progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		progress.bounds = CGRectMake(0, 0, 24, 24);
		cell.accessoryView = progress;
		[progress startAnimating];
		[WikiPage.shared bestWikiPageForKey:key value:value language:languageCode completion:^(NSURL * url) {
			cell.accessoryView = nil;
			if ( url && self.view.window ) {
				SFSafariViewController * viewController = [[SFSafariViewController alloc] initWithURL:url];
				_showingWikiLink = YES;
				[self presentViewController:viewController animated:YES completion:nil];
			}
		}];
	}
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // don't allow switching to relation if current selection is modified
    POITabBarController * tabController = (id)self.tabBarController;
    NSMutableDictionary * dict = [self keyValueDictionary];
    if ( [tabController isTagDictChanged:dict] ) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Object modified",nil)
                                                                        message:NSLocalizedString(@"You must save or discard changes to the current object before editing its associated relation",nil)
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    // switch to relation or relation member
    UITableViewCell * cell = sender;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    OsmBaseObject	* object = nil;
    if ( indexPath.section == 1 ) {
        // change the selected object in the editor to the relation
        object = _relations[ indexPath.row ];
    } else if ( indexPath.section == 2 ) {
        OsmMember	* member = _members[ indexPath.row ];
        object = member.ref;
        if ( ![object isKindOfClass:[OsmBaseObject class]] ) {
            return NO;
        }
    } else {
        return NO;
    }
    MapView * mapView = [AppDelegate getAppDelegate].mapView;
    [mapView.editorLayer setSelectedNode:object.isNode];
    [mapView.editorLayer setSelectedWay:object.isWay];
    [mapView.editorLayer setSelectedRelation:object.isRelation];
    
    CGPoint newPoint = mapView.pushpinView.arrowPoint;
    CLLocationCoordinate2D clLatLon = [mapView longitudeLatitudeForScreenPoint:newPoint birdsEye:YES];
    OSMPoint latLon = { clLatLon.longitude, clLatLon.latitude };
    latLon = [object pointOnObjectForPoint:latLon];
    newPoint = [mapView screenPointForLatitude:latLon.y longitude:latLon.x birdsEye:YES];
    if ( !CGRectContainsPoint( mapView.bounds, newPoint ) ) {
        // new object is far away
        [mapView placePushpinForSelection];
    } else {
        [mapView placePushpinAtPoint:newPoint object:object];
    }
    
    // dismiss ourself and switch to the relation
    UIViewController * topController = (id)mapView.viewController;
    [mapView refreshPushpinText];	// update pushpin description to the relation
    [self dismissViewControllerAnimated:YES completion:^{
        [topController performSegueWithIdentifier:@"poiSegue" sender:nil];
    }];
    return NO;
}

@end
