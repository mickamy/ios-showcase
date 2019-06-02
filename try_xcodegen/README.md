# Try XcodeGen

Life with .xcodeproj is hell.
Manage it with [XcodeGen](https://github.com/yonaskolb/XcodeGen) and have happy life!

## Install XcodeGen

Just follow the instruction in the [repo](https://github.com/yonaskolb/XcodeGen).

## Extract current configuration to xcconfig with xcconfig-extractor

Again, just follow the instruction in the [repo](https://github.com/toshi0383/xcconfig-extractor/).
Once it finished, hit 

`$ xcconfig-extractor sample.xcodeproj config`

This will extract current configs in `.xcodeproj` into `.xcconfig` files.
With `.xconfig`s, we can slim `project.yml` up, which is the config file for `XcodeGen`.

## Add configuration file for XcodeGen

Now we write down Xcode project configurations with `project.yml`, which is the file name and format `XcodeGen` expects.

`$ touch project.yml`

The `project.yml` of simple project would be like this.

```project.yml
name: TryXcodeGen # name of your project
fileGroups:
  - config # path to your directory contains .xcconfigs
configFiles:
  Debug: config/Debug.xcconfig # you know what it means, right?
  Release: config/Release.xcconfig
targets:
  TryXcodeGen:
    type: application
    platform: iOS
    sources: src # path to your directory contains codes (namely where .swift files are exit)
    configFiles:
      Debug: config/try_xcodegen-Debug.xcconfig
      Release: config/try_xcodegen-Release.xcconfig
    settings:
      base:
        INFOPLIST_FILE: src/resource/Info.plist
      CURRENT_PROJECT_VERSION: 1
    scheme:
      testTargets:
        - TryXcodeGenTests
  TryXcodeGenTests:
    type: bundle.unit-test
    platform: iOS
    sources: test
    configFiles:
      Debug: config/try_xcodegenTests-Debug.xcconfig
      Release: config/try_xcodegenTests-Release.xcconfig
    settings:
      base:
        INFOPLIST_FILE: test/resource/Info.plist
    dependencies:
      - target: TryXcodeGen
```

## With CocoaPods

You need to include `.xcconfig` created by CocoaPods in your project `.xcconfig`.

```
#include "try_xcodegen.xcconfig"
#include "Pods/Target Support Files/Pods-TryXcodeGen/Pods-TryXcodeGen.debug.xcconfig" # <- Added!
```

See [this commit](https://github.com/mickamy/ios_showcase/pull/1/commits/f6132fe67aaa446eedf54365bad5695ff57c9d1e) for more details.
