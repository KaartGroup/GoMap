//
//  ContactUsViewController.swift
//  Go Map!!
//
//  Created by Wolfgang Timme on 4/16/19.
//  Copyright © 2019 Bryce. All rights reserved.
//

import Foundation

extension ContactUsViewController {
<<<<<<< HEAD
    override open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
=======
    
    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
        let isLastSection = tableView.numberOfSections == section + 1
        if isLastSection {
            return createVersionDetailsString()
        }
<<<<<<< HEAD

        return nil
    }

    // MARK: Private methods

=======
        
        return nil
    }
    
    // MARK: Private methods
    
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
    private func createVersionDetailsString() -> String? {
        guard
            let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let appName = appDelegate.appName(),
            let appVersion = appDelegate.appVersion(),
            let appBuildNumber = appDelegate.appBuildNumber()
        else {
            assertionFailure("Unable to determine the app version details")
            return nil
        }
<<<<<<< HEAD

        return "\(appName) \(appVersion) (\(appBuildNumber))"
    }

    @objc func openTestFlightURL() {
        guard let url = URL(string: "https://testflight.apple.com/join/T96F9wYq") else { return }

		UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
=======
        
        return "\(appName) \(appVersion) (\(appBuildNumber))"
    }
    
    @objc func openTestFlightURL() {
        guard let url = URL(string: "https://testflight.apple.com/join/T96F9wYq") else { return }
        
        UIApplication.shared.openURL(url)
    }
    
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
}
