//
//  RCTAppleHealthKit+Methods_Mindfulness.h
//  RCTAppleHealthKit
//
//

#import "RCTAppleHealthKit.h"

@interface RCTAppleHealthKit (Methods_Mindfulness)

- (void)mindfulness_getMindfulSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;
- (void)mindfulness_saveMindfulSession:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback;

@end
