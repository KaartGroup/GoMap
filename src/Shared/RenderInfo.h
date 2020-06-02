//
//  RenderInfo.h
//  OpenStreetMap
//
//  Created by Bryce Cogswell on 10/4/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OsmBaseObject;

<<<<<<< HEAD
static const NSInteger RenderInfoMaxPriority = (33+1)*3;


=======
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
@interface RenderInfo : NSObject
{
	NSInteger	_renderPriority;
}
@property (strong,nonatomic)	NSString	*	key;
@property (strong,nonatomic)	NSString	*	value;
<<<<<<< HEAD
=======
@property (strong,nonatomic)	NSString	*	geometry;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
@property (strong,nonatomic)	NSColor		*	lineColor;
@property (assign,nonatomic)	CGFloat			lineWidth;
@property (strong,nonatomic)	NSColor		*	areaColor;

-(BOOL)isAddressPoint;

<<<<<<< HEAD
-(NSInteger)renderPriorityForObject:(OsmBaseObject *)object;
=======
-(NSInteger)renderPriority:(OsmBaseObject *)object;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added

@end



@interface RenderInfoDatabase : NSObject
{
<<<<<<< HEAD
	NSArray				*	_allFeatures;
=======
	NSArray				*	_allTags;
>>>>>>> 4d4c9d7a... Lanestepper, explicit close button, and iPad StoryBoard added
	NSMutableDictionary *	_keyDict;
}
+(RenderInfoDatabase *)sharedRenderInfoDatabase;

-(RenderInfo *)renderInfoForObject:(OsmBaseObject *)object;

@end
