//
//  WLJavaProxy.m
//  libjcocoa
//
//  Created by Steve Hannah on 2012-10-21.
//  Copyright (c) 2012 Web Lite Solutions. All rights reserved.
//

#import "WLJavaProxy.h"
#include <JavaNativeFoundation/JavaNativeFoundation.h>
#include "JavaUtil.h"

static JavaVM *jvm = NULL;


@implementation WLJavaProxy

-(WLJavaProxy*)init:(jobject)thePeer
{
    JNIEnv *env=0;
    
    @try {
        int attach = (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
        if ( attach == 0 ){
            //JNF_COCOA_ENTER(env);
            (*jvm)->GetEnv(jvm, (void**)&env, JNI_VERSION_1_6);
            peer = (*env)->NewGlobalRef(env,thePeer);
            jclass cls  = (*env)->GetObjectClass(env, peer);
            peerClass = (*env)->NewGlobalRef(env, cls);
            (*env)->DeleteLocalRef(env, cls);
            
            jMethodSignatureForSelector = (*env)->GetMethodID(env, peerClass, "methodSignatureForSelector", "(J)J" );
            jForwardInvocation = (*env)->GetMethodID(env, peerClass, "forwardInvocation", "(J)V" );
            jRespondsToSelector = (*env)->GetMethodID(env, peerClass, "respondsToSelector", "(J)Z" );
            //JNF_COCOA_EXIT(env);
        }
        //(*jvm)->DetachCurrentThread(jvm);
        
        return self;
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
}

-(void)dealloc
{
    JNIEnv *env=0;
    
    @try {
        int attach = (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
        
        if ( attach == 0 ){
            //JNF_COCOA_ENTER(env);
            (*env)->DeleteGlobalRef(env, peerClass);
            (*env)->DeleteGlobalRef(env, peer);
            [super dealloc];
            //JNF_COCOA_EXIT(env);
        }
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
}

+(void)setJVM:(JavaVM*)theJvm
{
    JNIEnv *env=0;
    
    @try {
        int attach = (*theJvm)->AttachCurrentThread(theJvm, (void**)&env, NULL);
        if ( attach == 0 ){
            jvm = theJvm;
        }
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
}

-(jobject)javaPeer
{
    JNIEnv *env=0;
    
    @try {
        int attach = (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
        if ( attach == 0 ){
            return peer;
        }
        return NULL;
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature* signature;
    JNIEnv *env=0;

    @try {
        int attach = (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
        if ( attach == 0 ){
            //JNF_COCOA_ENTER(env);
            signature = (NSMethodSignature*)(*env)->CallLongMethod(env, peer, jMethodSignatureForSelector, sel);

            if (!signature) {
                signature = [@"" methodSignatureForSelector:sel];
            }

            //JNF_COCOA_EXIT(env);
        }
        //(*jvm)->DetachCurrentThread(jvm);
        return signature;
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
    
//    return [NSMethodSignature methodSignatureForSelector:sel];
}

-(void)forwardInvocation:(NSInvocation *)invocation
{
    JNIEnv *env=0;
    SEL aSelector = [invocation selector];
    int attach = (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
    
    @try {
        if ( attach == 0 ) {
            //JNF_COCOA_ENTER(env);
            (*env)->CallVoidMethod(env, peer, jForwardInvocation, invocation);
            //JNF_COCOA_EXIT(env);
        }
        //(*jvm)->DetachCurrentThread(jvm);
    } @catch (NSException *e) {
        NSString *message = [NSString stringWithFormat:@"Selector '%@' caused exception: %@", NSStringFromSelector(aSelector), e.reason];
        NSLog(@"%@", message);
        [JavaUtil throwJavaException: env withMessage: [message UTF8String] ];
    }
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    return YES;
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL response = FALSE;
    JNIEnv *env=0;

    @try {
        int attach = (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
        if ( attach == 0 ){
            //JNF_COCOA_ENTER(env);
            response = (*env)->CallBooleanMethod(env, peer, jRespondsToSelector, aSelector);
            //JNF_COCOA_EXIT(env);
        }
        //(*jvm)->DetachCurrentThread(jvm);
        return response==1?TRUE:FALSE;
    } @catch (NSException *e) {
        NSLog(@"Exception: %@", e);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
    
//    return YES;
}

- (id)valueForKey:(NSString *)key {
    return [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObject: key]];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObject: key]];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObjects: value, key, nil]];
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath {
    [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObjects: value, keyPath, nil]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObjects: value, key, nil]];
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    return [super keyPathsForValuesAffectingValueForKey: key];
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {

    [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObjects: observer, keyPath, options, context, nil]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   [self forwardInvocationForSelector: _cmd withTarget:self withArguments: [NSArray arrayWithObjects: keyPath, object, change, context, nil]];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSString* message = [NSString stringWithFormat:@"Unrecognized selector called: %@", NSStringFromSelector(aSelector)];
    JNIEnv *env=0;
    (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
    [JavaUtil throwJavaException: env withMessage: [message UTF8String] ];
}


/**
 Forwards an unhandled call to the java proxy.
 */
- (id)forwardInvocationForSelector: (SEL)aSelector withTarget: (id _Nullable)aTarget withArguments: (NSArray*)args {
    @try {
        NSString* sel = NSStringFromSelector(aSelector);
        
        NSMethodSignature *aSignature = [self methodSignatureForSelector:aSelector];
        NSInvocation *anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
        
        [anInvocation setTarget:aTarget];
        [anInvocation setSelector:aSelector];
        
        int i = 2;
        for (__unsafe_unretained id arg in args) {
            [anInvocation setArgument:&arg atIndex:i];
            i++;
        }

        [anInvocation retainArguments];
        
        [self forwardInvocation:anInvocation];

        NSUInteger length = [[anInvocation methodSignature] methodReturnLength];
        
        if (length > 0 ) {
        void *result = (void *) malloc(length);
            [anInvocation getReturnValue:&result];
            return result;
        } else {
            return nil;
        }
    } @catch(NSException *e) {
        NSLog(@"Exception: %@", e);
        
        JNIEnv *env=0;
        (*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL);
        [JavaUtil throwJavaException: env withMessage: [[e reason] UTF8String] ];
    }
    
    return nil;
}

@end
