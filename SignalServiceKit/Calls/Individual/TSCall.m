//
// Copyright 2017 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

#import "TSCall.h"
#import "TSContactThread.h"
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

NSString *NSStringFromCallType(RPRecentCallType callType)
{
    switch (callType) {
        case RPRecentCallTypeIncoming:
            return @"RPRecentCallTypeIncoming";
        case RPRecentCallTypeOutgoing:
            return @"RPRecentCallTypeOutgoing";
        case RPRecentCallTypeIncomingMissed:
            return @"RPRecentCallTypeIncomingMissed";
        case RPRecentCallTypeOutgoingIncomplete:
            return @"RPRecentCallTypeOutgoingIncomplete";
        case RPRecentCallTypeIncomingIncomplete:
            return @"RPRecentCallTypeIncomingIncomplete";
        case RPRecentCallTypeIncomingMissedBecauseOfChangedIdentity:
            return @"RPRecentCallTypeIncomingMissedBecauseOfChangedIdentity";
        case RPRecentCallTypeIncomingDeclined:
            return @"RPRecentCallTypeIncomingDeclined";
        case RPRecentCallTypeOutgoingMissed:
            return @"RPRecentCallTypeOutgoingMissed";
        case RPRecentCallTypeIncomingAnsweredElsewhere:
            return @"RPRecentCallTypeIncomingAnsweredElsewhere";
        case RPRecentCallTypeIncomingDeclinedElsewhere:
            return @"RPRecentCallTypeIncomingDeclinedElsewhere";
        case RPRecentCallTypeIncomingBusyElsewhere:
            return @"RPRecentCallTypeIncomingBusyElsewhere";
        case RPRecentCallTypeIncomingMissedBecauseOfDoNotDisturb:
            return @"RPRecentCallTypeIncomingMissedBecauseOfDoNotDisturb";
        case RPRecentCallTypeIncomingMissedBecauseBlockedSystemContact:
            return @"RPRecentCallTypeIncomingMissedBecauseBlockedSystemContact";
    }
}

NSUInteger TSCallCurrentSchemaVersion = 1;

@interface TSCall ()

@property (nonatomic, readonly) NSUInteger callSchemaVersion;

@property (nonatomic) TSRecentCallOfferType offerType;

@end

#pragma mark -

@implementation TSCall

- (instancetype)initWithCallType:(RPRecentCallType)callType
                       offerType:(TSRecentCallOfferType)offerType
                          thread:(TSContactThread *)thread
                 sentAtTimestamp:(uint64_t)sentAtTimestamp
{
    self = [super initWithTimestamp:sentAtTimestamp
                receivedAtTimestamp:[NSDate ows_millisecondTimeStamp]
                             thread:thread];

    if (!self) {
        return self;
    }

    _callSchemaVersion = TSCallCurrentSchemaVersion;
    _callType = callType;
    _offerType = offerType;

    // Ensure users are notified of missed calls.
    switch (callType) {
        case RPRecentCallTypeIncomingMissed:
        case RPRecentCallTypeIncomingMissedBecauseOfChangedIdentity:
        case RPRecentCallTypeIncomingMissedBecauseOfDoNotDisturb:
        case RPRecentCallTypeIncomingMissedBecauseBlockedSystemContact:
            _read = NO;
            break;
        default:
            _read = YES;
            break;
    }

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithGrdbId:(int64_t)grdbId
                      uniqueId:(NSString *)uniqueId
             receivedAtTimestamp:(uint64_t)receivedAtTimestamp
                          sortId:(uint64_t)sortId
                       timestamp:(uint64_t)timestamp
                  uniqueThreadId:(NSString *)uniqueThreadId
                        callType:(RPRecentCallType)callType
                       offerType:(TSRecentCallOfferType)offerType
                            read:(BOOL)read
{
    self = [super initWithGrdbId:grdbId
                        uniqueId:uniqueId
               receivedAtTimestamp:receivedAtTimestamp
                            sortId:sortId
                         timestamp:timestamp
                    uniqueThreadId:uniqueThreadId];

    if (!self) {
        return self;
    }

    _callType = callType;
    _offerType = offerType;
    _read = read;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (!self) {
        return self;
    }

    if (self.callSchemaVersion < 1) {
        // Assume user has already seen any call that predate read-tracking
        _read = YES;
    }

    _callSchemaVersion = TSCallCurrentSchemaVersion;

    return self;
}

- (OWSInteractionType)interactionType
{
    return OWSInteractionType_Call;
}

- (NSString *)previewTextWithTransaction:(SDSAnyReadTransaction *)transaction
{
    // We don't actually use the `transaction` but other sibling classes do.
    switch (_callType) {
        case RPRecentCallTypeIncoming:
        case RPRecentCallTypeIncomingIncomplete:
        case RPRecentCallTypeIncomingAnsweredElsewhere: {
            switch (_offerType) {
                case TSRecentCallOfferTypeAudio:
                    return OWSLocalizedString(@"INCOMING_VOICE_CALL", @"info message text in conversation view");
                case TSRecentCallOfferTypeVideo:
                    return OWSLocalizedString(@"INCOMING_VIDEO_CALL", @"info message text in conversation view");
            }
        }
        case RPRecentCallTypeOutgoing:
        case RPRecentCallTypeOutgoingIncomplete: {
            switch (_offerType) {
                case TSRecentCallOfferTypeAudio:
                    return OWSLocalizedString(@"OUTGOING_VOICE_CALL", @"info message text in conversation view");
                case TSRecentCallOfferTypeVideo:
                    return OWSLocalizedString(@"OUTGOING_VIDEO_CALL", @"info message text in conversation view");
            }
        }
        case RPRecentCallTypeOutgoingMissed: {
            switch (_offerType) {
                case TSRecentCallOfferTypeAudio:
                    return OWSLocalizedString(@"OUTGOING_MISSED_VOICE_CALL", @"info message text in conversation view");
                case TSRecentCallOfferTypeVideo:
                    return OWSLocalizedString(@"OUTGOING_MISSED_VIDEO_CALL", @"info message text in conversation view");
            }
        }
        case RPRecentCallTypeIncomingMissed:
        case RPRecentCallTypeIncomingMissedBecauseOfChangedIdentity:
        case RPRecentCallTypeIncomingBusyElsewhere: {
            switch (_offerType) {
                case TSRecentCallOfferTypeAudio:
                    return OWSLocalizedString(@"MISSED_VOICE_CALL", @"info message text in conversation view");
                case TSRecentCallOfferTypeVideo:
                    return OWSLocalizedString(@"MISSED_VIDEO_CALL", @"info message text in conversation view");
            }
        }
        case RPRecentCallTypeIncomingDeclined:
        case RPRecentCallTypeIncomingDeclinedElsewhere: {
            switch (_offerType) {
                case TSRecentCallOfferTypeAudio:
                    return OWSLocalizedString(@"DECLINED_VOICE_CALL", @"info message text in conversation view");
                case TSRecentCallOfferTypeVideo:
                    return OWSLocalizedString(@"DECLINED_VIDEO_CALL", @"info message text in conversation view");
            }
        }
        case RPRecentCallTypeIncomingMissedBecauseOfDoNotDisturb:
            return OWSLocalizedString(
                @"MISSED_CALL_FOCUS_MODE", @"info message text in conversation view (use Apple's name for 'Focus')");
        case RPRecentCallTypeIncomingMissedBecauseBlockedSystemContact:
            return OWSLocalizedString(@"MISSED_CALL_BLOCKED_SYSTEM_CONTACT",
                @"info message text in conversation view for when a call was dropped because the contact is blocked in "
                @"iOS settings");
    }
}

@end

NS_ASSUME_NONNULL_END
