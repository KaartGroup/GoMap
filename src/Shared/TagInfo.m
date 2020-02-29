//
//  TagInfo.m
//  OpenStreetMap
//
//  Created by Bryce Cogswell on 10/4/12.
//  Copyright (c) 2012 Bryce Cogswell. All rights reserved.
//

#import "DLog.h"
#import "TagInfo.h"

#if TARGET_OS_IPHONE
#include "DDXML.h"
#endif

@implementation TagInfo

@synthesize iconName = _iconName;



-(TagInfo *)copy
{
	TagInfo * copy = [TagInfo new];
	copy.key			= self.key;
	copy.value			= self.value;
	copy.friendlyName	= self.friendlyName;
	copy.type			= self.type;
	copy.belongsTo		= self.belongsTo;
	copy.iconName		= self.iconName;
	copy.summary		= self.summary;
	copy.lineColor		= self.lineColor;
	copy.lineWidth		= self.lineWidth;
	copy.lineColorText	= self.lineColorText;
	copy.areaColor		= self.areaColor;
	copy.areaColorText	= self.areaColorText;
	return copy;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"%@ %@=%@ %@", [super description], _key, _value, _type];
}

static TagInfo * g_AddressRender = nil;
static TagInfo * g_DefaultRender = nil;

-(BOOL)isAddressPoint
{
	return self == g_AddressRender;
}

-(NSImage *)icon
{
	if ( _icon == nil ) {
		NSString * name = self.iconName;
		if ( name.length ) {
			if ( ![name hasSuffix:@".png"] )
				name = [name stringByAppendingString:@".p.64.png"];
			_icon = [NSImage imageNamed:name];
			if ( _icon == nil ) {
				DLog(@"missing icon for path '%@'", name);
			}
		}
	}
	return _icon;
}
-(CGImageRef)cgIcon
{
	if ( _cgIcon == NULL ) {
#if TARGET_OS_IPHONE
		NSImage * image = [self icon];
		_cgIcon = image.CGImage;
#else
		NSString * name = self.iconName;
		if ( name.length ) {
			name = [name stringByAppendingString:@".p.64.png"];
			name = [[NSBundle mainBundle] pathForImageResource:name];
			CGDataProviderRef provider = CGDataProviderCreateWithFilename(name.UTF8String);
			if ( provider )  {
				_cgIcon = CGImageCreateWithPNGDataProvider( provider, nil, true, kCGRenderingIntentDefault );
				CGDataProviderRelease( provider );
			}
		}
#endif
	}
	return _cgIcon;
}

-(NSString *)friendlyName2
{
	NSString * text = [NSString stringWithFormat:@"%@ (%@)", _value, _key];
	text = [text stringByReplacingOccurrencesOfString:@"_" withString:@" "];
	text = text.capitalizedString;
	return text;
}

+(NSColor *)colorForString:(NSString *)text
{
	if ( text == nil )
		return nil;
	int r = 0, g = 0, b = 0;
	sscanf( text.UTF8String, "%2x%2x%2x", &r, &g, &b);
#if TARGET_OS_IPHONE
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
#else
	return [NSColor colorWithCalibratedRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
#endif
}
+(NSString *)stringForColor:(NSColor *)color
{
	if ( color == nil )
		return nil;
	CGFloat r,g,b,a;
	[color getRed:&r green:&g blue:&b alpha:&a];
	return [NSString stringWithFormat:@"%02lX%02lX%02lX",lround(r*255),lround(g*255),lround(b*255)];
}

-(NSString *)lineColorText
{
	if ( self.lineColor == nil )
		return nil;
	return [TagInfo stringForColor:self.lineColor];
}
-(void)setLineColorText:(NSString *)lineColorText
{
	self.lineColor = [TagInfo colorForString:lineColorText];
}
-(NSString *)areaColorText
{
	if ( self.areaColor == nil )
		return nil;
	return [TagInfo stringForColor:self.areaColor];
}
-(void)setAreaColorText:(NSString *)areaColorText
{
	self.areaColor = [TagInfo colorForString:areaColorText];
}

-(NSString *)iconName
{
	return _iconName;
}
-(void)setIconName:(NSString *)iconName
{
	_iconName = iconName;
	_icon = nil;
	_cgIcon = NULL;
}


-(NSInteger)renderSize:(OsmBaseObject *)object
{
	static NSDictionary * highwayDict = nil;
	if ( highwayDict == nil ) {
		highwayDict = @{
			@"motorway"			: @4000,
			@"trunk"			: @3000,
			@"motorway_link"	: @2100,
			@"primary"			: @2000,
			@"trunk_link"		: @1000,
			@"primary_link"		: @1200,
			@"secondary"		: @1500,
			@"tertiary"			: @1400,
			@"residential"		: @1200,
			@"raceway"			: @1110,
			@"secondary_link"	: @1100,
			@"tertiary_link"	: @1050,
			@"living_street"	: @1020,
			@"road"				: @1000,
			@"unclassified"		: @900,
			@"service"			: @710,
			@"bus_guideway"		: @700,
			@"track"			: @500,
			@"pedestrian"		: @200,
			@"cycleway"			: @130,
			@"path"				: @120,
			@"bridleway"		: @110,
			@"footway"			: @100,
			@"steps"			: @90,
			@"construction"		: @80,
			@"proposed"			: @70,
		};
	}

	if ( _renderSize ) {
		if ( object.isWay || object.isRelation.isMultipolygon )
			return _renderSize + 2;
		if ( object.isRelation )
			return _renderSize + 1;
		return _renderSize;
	}

	if ( [_key isEqualToString:@"natural"] && [_value isEqualToString:@"coastline"] ) {
		return _renderSize = 10000;
	}
	if ( [_key isEqualToString:@"natural"] && [_value isEqualToString:@"water"] ) {
		return _renderSize = 9000;
	}
	if ( [_key isEqualToString:@"waterway"] && [_value isEqualToString:@"riverbank"] ) {
		return _renderSize = 5000;
	}
	if ( [_key isEqualToString:@"highway"] ) {
		if ( _value ) {
			id priority = highwayDict[_value];
			_renderSize = [priority integerValue];
			if ( _renderSize )
				return _renderSize;
		}
	}
	if ( [_key isEqualToString:@"railway"] ) {
		return _renderSize = 1250;
	}

	// address points are extra low priority
	if ( self == g_AddressRender ) {
		return _renderSize = 40;
	}

	// get a default value
	_renderSize = 50;
	return [self renderSize:object];
}

@end


@implementation TagInfoDatabase

+(TagInfoDatabase *)sharedTagInfoDatabase
{
	static TagInfoDatabase * _database = nil;
	if ( _database == nil ) {
		_database = [self new];
	}
	return _database;
}

+(NSMutableArray *)readXml
{
	NSError * error = nil;
	NSMutableArray * tagList = [NSMutableArray new];
	NSMutableArray * defaults = [NSMutableArray new];
	NSString * text = [NSString stringWithContentsOfFile:@"TagInfo.xml" encoding:NSUTF8StringEncoding error:&error];
	if ( text == nil ) {
		NSString * path = [[NSBundle mainBundle] pathForResource:@"TagInfo" ofType:@"xml"];
		text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	}
	NSXMLDocument * doc = [[NSXMLDocument alloc] initWithXMLString:text options:0 error:&error];
	NSXMLElement * root = [doc rootElement];
	for ( NSXMLElement * tag in root.children ) {

		TagInfo * tagType = [TagInfo new];
		tagType.key				= [tag attributeForName:@"key"].stringValue;
		tagType.value			= [tag attributeForName:@"value"].stringValue;
		tagType.friendlyName	= [tag attributeForName:@"name"].stringValue;
		tagType.summary			= [tag attributeForName:@"description"].stringValue;
		tagType.type			= [tag attributeForName:@"type"].stringValue;
		tagType.belongsTo		= [tag attributeForName:@"belongsTo"].stringValue;
		tagType.iconName		= [tag attributeForName:@"iconName"].stringValue;
		tagType.lineColor		= [TagInfo colorForString:[tag attributeForName:@"lineColor"].stringValue];
		tagType.areaColor		= [TagInfo colorForString:[tag attributeForName:@"areaColor"].stringValue];
		tagType.lineWidth		= [tag attributeForName:@"lineWidth"].stringValue.doubleValue;

		if ( [tag.name isEqualToString:@"tag"] ) {
			[tagList addObject:tagType];
		} else if ( [tag.name isEqualToString:@"default"] ) {
			assert( tagType.value == nil );	// not implemented
			[defaults addObject:tagType];
		} else {
			assert(NO);
		}
	}
	for ( TagInfo * def in defaults ) {
		for ( TagInfo * tag in tagList ) {
			if ( [tag.key isEqualToString:def.key] ) {
				if ( tag.iconName == nil )
					tag.iconName = def.iconName;
				if ( tag.areaColor == nil )
					tag.areaColor = def.areaColor;
				if ( tag.lineColor == nil )
					tag.lineColor = def.lineColor;
				if ( tag.lineWidth == 0.0 )
					tag.lineWidth = def.lineWidth;
			}
		}
	}
	return tagList;
}

-(id)initWithXmlFile:(NSString *)file
{
	self = [super init];
	if ( self ) {
		_allTags = [TagInfoDatabase readXml];
		_keyDict = [NSMutableDictionary new];
		for ( TagInfo * tag in _allTags ) {
			NSMutableDictionary * valDict = [_keyDict objectForKey:tag.key];
			if ( valDict == nil ) {
				valDict = [NSMutableDictionary dictionaryWithObject:tag forKey:tag.value];
				[_keyDict setObject:valDict forKey:tag.key];
			} else {
				[valDict setObject:tag forKey:tag.value];
			}
		}
	}
	return self;
}

-(id)init
{
	NSString * path = [[NSBundle mainBundle] pathForResource:@"TagInfo.menu" ofType:@"xml"];
	self = [self initWithXmlFile:path];
	return self;
}

-(NSArray *)tagsBelongTo:(NSString *)parentItem type:(NSString *)type
{
	__block NSMutableArray * list = [NSMutableArray new];
	[_keyDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSDictionary * valDict, BOOL *stop1) {
		[valDict enumerateKeysAndObjectsUsingBlock:^(NSString * value, TagInfo * tagInfo, BOOL *stop2) {
			if ( [tagInfo.type rangeOfString:type].length > 0 ) {
				if ( parentItem ? [tagInfo.belongsTo rangeOfString:parentItem].length > 0 : tagInfo.belongsTo.length == 0 ) {
					[list addObject:tagInfo];
					*stop2 = YES;
				}
			}
		}];
	}];
	return list;
}

-(TagInfo *)tagInfoForKey:(NSString *)key value:(NSString *)value
{
	NSDictionary * valDict = [_keyDict objectForKey:key];
	return [valDict objectForKey:value];
}

-(TagInfo *)tagInfoForObject:(OsmBaseObject *)object
{
#if 0
	if ( [[object.tags objectForKey:@"seamark:type"] isEqualToString:@"buoy_lateral"] ) {
		int i = 1;
		++i;
		--i;
	}
#endif

	// try exact match
	__block TagInfo * best = nil;
	[object.tags enumerateKeysAndObjectsUsingBlock:^(NSString * key,NSString * value,BOOL * stop){
		NSDictionary * valDict = [_keyDict objectForKey:key];
		if ( valDict ) {
			TagInfo * render = [valDict objectForKey:value];
			if ( render == nil )
				return;
			if ( best == nil || (best.lineColor == nil && render.lineColor) || (!best.iconName && render.iconName) )
				best = render;
			if ( render.lineColor == nil && render.iconName == nil )
				return;
			// DLog(@"render %@=%@",key,value);
			*stop = YES;
		}
	}];
	if ( best ) {
		return best;
	}

	// check if it is an address point
	BOOL isAddress = object.isNode && object.tags.count > 0;
	if ( isAddress ) {
		for ( NSString * key in object.tags ) {
			if ( ![key hasPrefix:@"addr:"] ) {
				isAddress = NO;
				break;
			}
		}
		if ( isAddress ) {
			if ( g_AddressRender == nil ) {
				g_AddressRender = [TagInfo new];
				g_AddressRender.key = @"ADDRESS";
				g_AddressRender.lineWidth = 0.0;
			}
			return g_AddressRender;
		}
	}

	if ( g_DefaultRender == nil ) {
		g_DefaultRender = [TagInfo new];
		g_DefaultRender.key = @"DEFAULT";
#if TARGET_OS_IPHONE
		g_DefaultRender.lineColor = [NSColor colorWithRed:0 green:0 blue:0 alpha:1];
#else
		g_DefaultRender.lineColor = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:1];
#endif
		g_DefaultRender.lineWidth = 0.0;
	}
	return g_DefaultRender;
}

-(NSArray *)cuisineStyleValues
{
	NSArray * _cuisineStyleArray = nil;
	if ( _cuisineStyleArray == nil ) {
		_cuisineStyleArray = @[
			@"bagel",
			@"barbecue",
			@"bougatsa",
			@"burger",
			@"cake",
			@"chicken",
			@"coffee_shop",
			@"crepe",
			@"couscous",
			@"curry",
			@"doughnut",
			@"fish_and_chips",
			@"fried_food",
			@"friture",
			@"ice_cream",
			@"kebab",
			@"mediterranean",
			@"noodle",
			@"pasta",
			@"pie",
			@"pizza",
			@"regional",
			@"sandwich",
			@"sausage",
			//		@"savory_pancakes",
			@"seafood",
			@"steak_house",
			@"sushi",
			];
	}
	return _cuisineStyleArray;
}

-(NSArray *)cuisineEthnicValues
{
	static NSArray * _ethnicArray = nil;
	if ( _ethnicArray == nil ) {
		_ethnicArray = @[
			@"african",
			@"american",
			@"arab",
			@"argentinian",
			@"asian",
			@"balkan",
			@"basque",
			@"brazilian",
			@"chinese",
			@"croatian",
			@"czech",
			@"french",
			@"german",
			@"greek",
			@"hawaiian",
			@"indian",
			@"iranian",
			@"italian",
			@"japanese",
			@"korean",
			@"latin_american",
			@"lebanese",
			@"mexican",
			@"peruvian",
			@"portuguese",
			@"spanish",
			@"thai",
			@"turkish",
			@"vietnamese"
		];
	}
	return _ethnicArray;
}

-(NSArray *)wifiValues
{
	return @[
			@"free",
			@"yes",
			@"no",
	  ];
}

-(NSArray *)fixmeValues
{
	return @[
			@"resurvey",
			@"name",
			@"continue",
	];
}

-(NSArray *)sourceValues
{
	return @[
			@"survey",
			@"local_knowledge",
			@"Bing",
			@"Yahoo",
	 ];
}

@end
