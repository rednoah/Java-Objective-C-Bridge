/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jnaexample_NativeClient_Setup.h>
#include <JavaNativeFoundation/JavaNativeFoundation.h>
#include <WLJavaProxy.h>
JNIEXPORT void JNICALL Java_ca_weblite_objc_RuntimeUtils_init
  (JNIEnv *env, jclass cls)
{
    JavaVM *jvm;
    (*env)->GetJavaVM(env, &jvm);
    [WLJavaProxy setJVM:jvm];
    
}

/*
 * Class:     jnaexample_NativeClient_Setup
 * Method:    createProxy
 * Signature: (Ljnaexample/NativeClient;)J
 */
JNIEXPORT jlong JNICALL Java_ca_weblite_objc_RuntimeUtils_createProxy
(JNIEnv *env, jclass jcls, jobject jclient)
{
    return ptr_to_jlong([[WLJavaProxy alloc] init:jclient]);
}

/*
 * Class:     jnaexample_NativeClient_Setup
 * Method:    getJavaPeer
 * Signature: (Ljnaexample/NativeClient;)J
 */
JNIEXPORT jobject JNICALL Java_ca_weblite_objc_RuntimeUtils_getJavaPeer
(JNIEnv *env, jclass jcls, jlong nsObject)
{
    NSObject* proxy = (NSObject*)nsObject;
    if ( [proxy respondsToSelector:@selector(javaPeer)] ){
        WLJavaProxy* proxy2 = (WLJavaProxy*)proxy;
        return [proxy2 javaPeer];
    } else {
        return NULL;
    }
    
    
}
/*
JNIEXPORT jobject JNICALL Java_ca_weblite_objc_RuntimeUtils_invokeWithSelfAndTarget
(JNIEnv *env, jclass jcls, jlong selfPtr, jlong target, jlong invocation)
{
    id selfO = (id)selfPtr;
    id targetO = (id)target;
    NSInvocation* inv = (NSInvocation*)invocation;
    NSMethodSignature *sig = [inv methodSignature];
    NSUInteger numArgs = [sig numberOfArguments];
    const char* returnType = [sig methodReturnType];
    
    // OK  If anyone knows how to call a function with a variable number of
    // arguments, Please correct this, but I don't know how!!  So I'm just
    // going to use a Switch statement and cover most of the reasonable
    // cases
    
    IMP impl = [targetO methodForSelector:[inv selector]];
    impl(selfO, [inv selector], [inv ])
    
}
 */
