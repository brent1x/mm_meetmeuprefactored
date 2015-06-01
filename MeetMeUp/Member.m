//
//  Member.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"

@implementation Member

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
    }
    return self;
}

+ (void)fetchMember: (NSString *)memberID withCompletionBlock:(void(^)(Member *member))block {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=202319351e53624c24b661e3f521916", memberID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                               block([[Member alloc]initWithDictionary:dict]);
                           }];
}

- (void)fetchMemberPhoto:(void (^)(UIImage *image))block {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:self.photoURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        block([UIImage imageWithData:data]);
    }];
}

@end







