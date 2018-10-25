//
//  RCTAppleHealthKit+Methods_Mindfulness.m
//  RCTAppleHealthKit
//
//


#import "RCTAppleHealthKit+Methods_Mindfulness.h"
#import "RCTAppleHealthKit+Queries.h"
#import "RCTAppleHealthKit+Utils.h"

@implementation RCTAppleHealthKit (Methods_Sleep)


- (void)mindfulness_saveMindfulSession:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    double value = [RCTAppleHealthKit doubleFromOptions:input key:@"value" withDefault:(double)0];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];

    if(startDate == nil || endDate == nil){
        callback(@[RCTMakeError(@"startDate and endDate are required in options", nil, nil)]);
        return;
    }

    HKCategoryType *type = [HKCategoryType categoryTypeForIdentifier: HKCategoryTypeIdentifierMindfulSession];
    HKCategorySample *sample = [HKCategorySample categorySampleWithType:type value:value startDate:startDate endDate:endDate];


    [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving the mindful session sample %@. The error was: %@.", sample, error);
            callback(@[RCTMakeError(@"An error occured saving the mindful session sample", error, nil)]);
            return;
        }
        callback(@[[NSNull null], @(value)]);
    }];

}

- (void)mindfulness_getMindfulSamples:(NSDictionary *)input callback:(RCTResponseSenderBlock)callback
{
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:
        HKCategoryTypeIdentifierMindfulSession];
    HKUnit *unit = [RCTAppleHealthKit hkUnitFromOptions:input key:@"unit" withDefault:[HKUnit minuteUnit]];
    NSUInteger limit = [RCTAppleHealthKit uintFromOptions:input key:@"limit" withDefault:HKObjectQueryNoLimit];
    BOOL ascending = [RCTAppleHealthKit boolFromOptions:input key:@"ascending" withDefault:false];
    NSDate *startDate = [RCTAppleHealthKit dateFromOptions:input key:@"startDate" withDefault:nil];
    NSDate *endDate = [RCTAppleHealthKit dateFromOptions:input key:@"endDate" withDefault:[NSDate date]];
    
    if(startDate == nil){
        callback(@[RCTMakeError(@"startDate is required in options", nil, nil)]);
        return;
    }
    NSPredicate *predicate = [RCTAppleHealthKit predicateForSamplesBetweenDates:startDate endDate:endDate];
    
    [self fetchQuantitySamplesOfType:type unit:unit predicate:predicate ascending:ascending limit:limit completion:^(NSArray *results, NSError *error) {
        if (results) {
            callback(@[[NSNull null], results]);
            return;
        } else {
            NSLog(@"error getting mindfulsamples samples: %@", error);
            callback(@[RCTMakeError(@"error getting mindfulsamples samples", nil, nil)]);
            return;
        }
    }];
}


@end
