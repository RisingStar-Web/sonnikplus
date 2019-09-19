//
//  RSSParser.h
//  RSSParser
//
//  Created by Peter Willsey on 11-08-03.
//  Copyright 2011 Peter Willsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSSParserDelegate;

@interface RSSParser : NSObject <NSXMLParserDelegate> {
	id<RSSParserDelegate> __weak delegate;
	
	@private
	NSMutableData *RSSData;
	NSMutableString *currentString;
	NSMutableDictionary *channel;
	NSMutableDictionary *currentItem;
	NSMutableArray *elements;
}

@property (nonatomic, weak) id<RSSParserDelegate> delegate;
@property (nonatomic, strong) NSMutableData *RSSData;
@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic, strong) NSMutableDictionary *channel;
@property (nonatomic, strong) NSMutableDictionary *currentItem;
@property (nonatomic, strong) NSMutableArray *elements;

- (void)downloadAndParseFeed:(NSURL *)feedURL;

@end

@protocol RSSParserDelegate <NSObject>
@optional
- (void)parserDidFinishParsing:(RSSParser *)parser;
- (void)parserDidParseChannel:(NSDictionary *)channel;
- (void)parserDidParseItem:(NSDictionary *)feedItem;
- (void)parser:(RSSParser *)parser didEncounterError:(NSError *)error;
@end