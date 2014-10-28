# DetachablePopoverExample

This example application shows the [new behavior](https://developer.apple.com/library/mac/releasenotes/AppKit/RN-AppKit/#10_10ViewController) for detaching popovers in OS X Yosemite. Its goal is to modernize the outdated sample application [Popover](https://developer.apple.com/library/mac/samplecode/Popover/Introduction/Intro.html) developed by Apple. This was achieved by using the new API of [`NSPopover`](https://developer.apple.com/library/mac/documentation/AppKit/Reference/NSPopover_Class/index.html) (`NSAppearance` & default detach windows), Swift and OS X Storyboards.

**Default detach windows:** When using the default behavior of `NSPopover` an implicit detach window is created. This has the same appearance as the popover and reuses the content view controller of the popover.

**Custom detach windows:** Additionally, a custom detach window can be provided to `NSPopover`. In this case the content of the popover represented by the view controller is not moved to the new window and the developer has the responsibility to adjust the content of the custom window. Moreover the content view controller of the popover can't be reused for this purpose and a new instance has to be created.

![Screenshot](Screenshot.png)
