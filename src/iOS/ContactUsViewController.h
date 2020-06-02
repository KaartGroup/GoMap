//
//  ContactUsViewController.h
//  Go Map!!
//
//  Created by Bryce on 4/11/20.
//  Copyright © 2020 Bryce. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactUsViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
	IBOutlet UITableViewCell	*	_sendMailCell;
	IBOutlet UITableViewCell    *   _testFlightCell;
	IBOutlet UITableViewCell	*	_githubCell;
<<<<<<< HEAD
	IBOutlet UITableViewCell	*	_weblateCell;
=======
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}
@end

NS_ASSUME_NONNULL_END

