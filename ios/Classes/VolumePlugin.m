#import "ResonancePlugin.h"
#if __has_include(<resonance/resonance-Swift.h>)
#import <resonance/resonance-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "resonance-Swift.h"
#endif

@implementation ResonancePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftResonancePlugin registerWithRegistrar:registrar];
}
@end
