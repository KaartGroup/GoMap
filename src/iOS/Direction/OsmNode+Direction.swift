//
//  OsmNode+Direction.swift
//  Go Map!!
//
//  Created by Wolfgang Timme on 4/10/19.
//  Copyright © 2019 Bryce. All rights reserved.
//

import Foundation

extension OsmNode {
<<<<<<< HEAD
<<<<<<< HEAD
    static let cardinalDictionary: [String: Float] = [
        "north": 0,
        "N": 0,
        "NNE": 22.5,
        "NE": 45,
        "ENE": 67.5,
        "east": 90,
        "E": 90,
        "ESE": 112.5,
        "SE": 135,
        "SSE": 157.5,
        "south": 180,
        "S": 180,
        "SSW": 202.5,
        "SW": 225,
        "WSW": 247.5,
        "west": 270,
        "W": 270,
        "WNW": 292.5,
        "NW": 315,
    ]
=======

    static private func cardinalDictionary() -> [String: Float] {
		return ["north": 0,
				"N": 0,
				"NNE": 22.5,
				"NE": 45,
				"ENE": 67.5,
				"east": 90,
				"E": 90,
				"ESE": 112.5,
				"SE": 135,
				"SSE": 157.5,
				"south": 180,
				"S": 180,
				"SSW": 202.5,
				"SW": 225,
				"WSW": 247.5,
				"west": 270,
				"W": 270,
				"WNW": 292.5,
				"NW": 315]
	}

	struct cardinalDirectionToDegree {
		static let dict: [String: Float] = cardinalDictionary()
	}
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added

    /// The direction in which the node is facing.
    /// Since Objective-C is not able to work with optionals, the direction is `NSNotFound`
    /// if the node does not have a direction value instead of being `nil`.
    @objc var direction: NSRange {
<<<<<<< HEAD
        let keys = ["direction", "camera:direction"]
        for directionKey in keys {
            if
                let value = tags?[directionKey],
                let direction = OsmNode.directionFromString(value)
            {
                return direction
            }
=======
=======
    
    /// The direction in which the node is facing.
    /// Since Objective-C is not able to work with optionals, the direction is `NSNotFound`
    /// if the node does not have a direction value instead of being `nil`.
    @objc var direction: Int {
>>>>>>> c5a8eed4... Revert "Lanestepper"
        get {
            let keys = ["direction", "camera:direction"]
            for directionKey in keys {
                if
                    let value = tags?[directionKey],
                    let valueAsString = value as? String,
                    let direction = direction(from: valueAsString) {
                    return direction
                }
            }
            
<<<<<<< HEAD
            return NSMakeRange(NSNotFound,0)
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
=======
            return NSNotFound
>>>>>>> c5a8eed4... Revert "Lanestepper"
        }

        return NSMakeRange(NSNotFound, 0)
    }
<<<<<<< HEAD

    private static func directionFromString(_ string: String) -> NSRange? {
        if let direction = Float(string) ?? cardinalDictionary[string] {
            return NSMakeRange(Int(direction), 0)
        } else {
            let a: [String] = string.components(separatedBy: "-")
            if a.count == 2 {
                let a0 = String(a[0])
                let a1 = String(a[1])
                if
                    let d1 = Float(a0) ?? cardinalDictionary[a0],
                    let d2 = Float(a1) ?? cardinalDictionary[a1]
                {
                    var angle = Int(d2 - d1)
                    if angle < 0 {
                        angle += 360
                    }
                    return NSMakeRange(Int(d1), angle)
                }
            }
        }
=======
    
<<<<<<< HEAD
    private func direction(from string: String) -> NSRange? {
		if let direction = Float(string) ?? cardinalDirectionToDegree.dict[string] {
			return NSMakeRange(Int(direction),0)
		} else {
			let a = string.split(separator:"-")
			if a.count == 2 {
				if
					let d1 = Float(a[0]) ?? cardinalDirectionToDegree.dict[String(a[0])],
					let d2 = Float(a[1]) ?? cardinalDirectionToDegree.dict[String(a[1])] {
					var angle = Int(d2-d1)
					if ( angle < 0 ) {
						angle += 360;
					}
					return NSMakeRange(Int(d1),angle)
				}
			}
		}
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added

=======
    private func direction(from string: String) -> Int? {
        if let direction = Int(string) {
            return direction
        }
        
        let cardinalDirectionToDegree: [String: Int] = ["N": 0,
                                                        "NE": 45,
                                                        "E": 90,
                                                        "SE": 135,
                                                        "S": 180,
                                                        "SW": 225,
                                                        "W": 270,
                                                        "NW": 315]
        if let direction = cardinalDirectionToDegree[string] {
            return direction
        }
        
>>>>>>> c5a8eed4... Revert "Lanestepper"
        return nil
    }
}
