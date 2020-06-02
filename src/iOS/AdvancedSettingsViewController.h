//
<<<<<<< HEAD
//  AdvancedSettingsViewController.h
=======
//  OsmServerViewController.h
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
//  Go Map!!
//
//  Created by Bryce Cogswell on 11/29/16.
//  Copyright © 2016 Bryce Cogswell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvancedSettingsViewController : UITableViewController

@property (assign,nonatomic) IBOutlet UITextField	*	hostname;
@property (retain, nonatomic) NSString				*	originalHostname;

@property (assign)	IBOutlet	UISwitch			*	switchFPS;
@property (assign)	IBOutlet	UISwitch			*	switchTouches;

@end
