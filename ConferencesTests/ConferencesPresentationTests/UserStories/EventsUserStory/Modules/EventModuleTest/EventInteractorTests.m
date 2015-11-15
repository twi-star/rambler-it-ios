//
//  EventInteractorTests.m
//  Conferences
//
//  Created by Karpushin Artem on 15/11/15.
//  Copyright © 2015 Rambler. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "EventInteractor.h"
#import "EventService.h"
#import "PlainEvent.h"
#import "PrototypeMapper.h"
#import "EventTypeDeterminator.h"

@interface EventInteractorTests : XCTestCase

@property (strong, nonatomic) EventInteractor *interactor;
@property (strong, nonatomic) id <EventService> mockEventService;
@property (strong, nonatomic) id <PrototypeMapper> mockPrototypeMapper;
@property (strong, nonatomic) EventTypeDeterminator *mockEventTypeDeterminator;

@end

@implementation EventInteractorTests

- (void)setUp {
    [super setUp];

    self.interactor = [EventInteractor new];
    self.mockEventService = OCMProtocolMock(@protocol(EventService));
    self.mockPrototypeMapper = OCMProtocolMock(@protocol(PrototypeMapper));
    self.mockEventTypeDeterminator = OCMClassMock([EventTypeDeterminator class]);
    
    self.interactor.eventService = self.mockEventService;
    self.interactor.eventPrototypeMapper = self.mockPrototypeMapper;
    self.interactor.eventTypeDeterminator = self.mockEventTypeDeterminator;
}

- (void)tearDown {
    self.interactor = nil;
    self.mockEventService = nil;
    self.mockPrototypeMapper = nil;
    self.mockEventTypeDeterminator = nil;
    
    [super tearDown];
}

- (void)testSuccessObtainEventByObjectId {
    // given
    NSObject *event = [NSObject new];
    NSArray *events = @[event];
    
    OCMStub([self.mockEventService obtainEventWithPredicate:OCMOCK_ANY]).andReturn(events);
    
    // when
    [self.interactor obtainEventByObjectId:OCMOCK_ANY];
    
    // then
    OCMVerify([self.mockPrototypeMapper fillObject:OCMOCK_ANY withObject:event]);
    OCMVerify([self.mockEventTypeDeterminator determinateTypeForEvent:OCMOCK_ANY]);
}

@end
