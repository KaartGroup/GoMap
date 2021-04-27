//
//  EnhancedHwyEditorController.h
//  Go Kaart!!
//
//  Created by Zack LaVergne on 6/20/19.
//  Copyright © 2019 Bryce. All rights reserved.
//

//#ifndef EnhancedHwyEditorController_h
//#define EnhancedHwyEditorController_h
//
//
//#endif /* EnhancedHwyEditorController_h */
#import <UIKit/UIKit.h>
#import "EnhancedHwyEditorView.h"
#import "AutocompleteTextField.h"
#import "CustomPresetController.h"
#import "CustomPresetListViewController.h"
#import "VectorMath.h"
#import "EditorMapLayer.h"
#import "MainViewController.h"
#import "TagInfo.h"

//width of the way line e.g 12, 17, 18 AND shadow width is +4 e.g 16, 21, 22
#define DEFAULT_POPUPLINEWIDTH        12


@class OsmNode;
@class OsmNotesDatabase;
@class OsmBaseObject;
@class PresetKeyUserDefined;


@interface TextPair: UITableViewCell
@property (assign, nonatomic) IBOutlet AutocompleteTextField * text1;
@property (assign, nonatomic) IBOutlet AutocompleteTextField * text2;
@end

@interface LaneCell: TextPair

@end

@interface EnhancedHwyEditorController : UIViewController
{
    NSMutableArray    * _tags;
    NSMutableArray    * _nameTags;
    NSMutableArray    * _namePresets;
    NSMutableArray    * _laneTags;
    IBOutlet UIButton * oneWayButton;
    IBOutlet UIButton * reverseButton;
    IBOutlet UITableView * tagTable;
    IBOutlet UIButton * saveButton;
    IBOutlet UIStepper * laneStepper;
    IBOutlet UIButton * closeBtn;
    IBOutlet UITextField * txtValue;
    __weak IBOutlet NSLayoutConstraint *bottomViewConstraint;
}

@property (strong,nonatomic)    NSMutableDictionary *    keyValueDict;

@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@property (strong, nonatomic) IBOutlet EnhancedHwyEditorView * highwayEditorView;
@property (strong, nonatomic) IBOutlet UILabel * highwayEditorLabel;
- (IBAction)onewayPressed;
- (IBAction)reversePressed;
- (IBAction)closeBtnPressed:(id)sender;
- (IBAction)laneStepperPressed:(UIStepper *)sender;
- (IBAction)done;

// these are used for screen calculations:
@property (assign,nonatomic)    CGPoint                parentViewCenter;
@property (assign,nonatomic)    OSMTransform           screenFromMapTransform;

@end
