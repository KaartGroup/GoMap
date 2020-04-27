//
//  TagInfo.h
//  OpenStreetMap
//
//  Created by Bryce Cogswell on 10/4/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OsmBaseObject;

@interface TagInfo : NSObject
{
	NSInteger	_renderSize;
}
@property (strong,nonatomic)	NSString	*	key;
@property (strong,nonatomic)	NSString	*	value;
@property (strong,nonatomic)	NSString	*	type;
@property (strong,nonatomic)	NSColor		*	lineColor;
@property (assign,nonatomic)	NSString	*	lineColorText;
@property (assign,nonatomic)	CGFloat			lineWidth;
@property (strong,nonatomic)	NSColor		*	areaColor;
@property (assign,nonatomic)	NSString	*	areaColorText;

-(NSString *)friendlyName2;

-(BOOL)isAddressPoint;

-(NSInteger)renderSize:(OsmBaseObject *)object;

@end



@interface TagInfoDatabase : NSObject
{
	NSArray				*	_allTags;
	NSMutableDictionary *	_keyDict;
}
+(TagInfoDatabase *)sharedTagInfoDatabase;

-(TagInfo *)tagInfoForKey:(NSString *)key value:(NSString *)value;
-(TagInfo *)tagInfoForObject:(OsmBaseObject *)object;

@end
