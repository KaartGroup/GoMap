//
//  TristateButton.swift
//  Go Map!!
//
//  Created by Bryce Cogswell on 2/3/21.
//  Copyright © 2021 Bryce. All rights reserved.
//

import Foundation

@objc class TristateButton : UISegmentedControl{
	@objc var onSelect: ((String?) -> Void)? = nil

	@objc func stringForSelection() -> String?
	{
		return ["no", nil, "yes"][ self.selectedSegmentIndex ]
	}

	init() {
		super.init(items: [PresetsDatabase.shared.noForLocale, "-", PresetsDatabase.shared.yesForLocale])
		self.apportionsSegmentWidthsByContent = true
		setEnabled(true, forSegmentAt: 1)
		self.addTarget(self, action: #selector(self.valueChanged(_:)), for:.valueChanged)
	}

	@objc private func valueChanged(_ sender:Any?)
	{
		if let onSelect = onSelect {
			onSelect(self.stringForSelection())
		}
	}

	@objc func setSelection(forString value:String)
	{
		if OsmTags.IsOsmBooleanFalse(value) {
			super.selectedSegmentIndex = 0;
		} else if OsmTags.IsOsmBooleanTrue(value) {
			super.selectedSegmentIndex = 2;
		} else {
			super.selectedSegmentIndex = 1;
		}
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}
