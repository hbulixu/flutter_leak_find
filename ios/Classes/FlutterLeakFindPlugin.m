#import "FlutterLeakFindPlugin.h"
#if __has_include(<flutter_leak_find/flutter_leak_find-Swift.h>)
#import <flutter_leak_find/flutter_leak_find-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_leak_find-Swift.h"
#endif

@implementation FlutterLeakFindPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLeakFindPlugin registerWithRegistrar:registrar];
}
@end
