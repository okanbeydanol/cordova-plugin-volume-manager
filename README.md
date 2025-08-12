# [Cordova Volume Control](https://github.com/okanbeydanol/cordova-plugin-volume-manager) [![Release](https://img.shields.io/npm/v/cordova-plugin-volume-manager.svg?style=flat)](https://github.com/okanbeydanol/cordova-plugin-volume-manager/releases)

This plugin provides a simple way to interact with the volume of your `UIWebView`.

* This plugin is built for `cordova@^3.6`.

* This plugin currently supports Android and iOS.


## Plugin setup

Using this plugin requires [Cordova iOS](https://github.com/apache/cordova-ios) and [Cordova Android](https://github.com/apache/cordova-android).

1. `cordova plugin add cordova-plugin-volume-manager`--save



### Usage

Usage
JavaScript (Global Cordova)
After the device is ready, you can use the plugin via the global `cordova.plugins.VolumeControl` object:

```javascript
var VolumeControl = cordova.plugins.VolumeControl;

// Get current volume
VolumeControl.getVolume(console.log.bind(console));

// Toggle mute
VolumeControl.toggleMute();

// Check if muted
VolumeControl.isMuted(console.log.bind(console));

// Set volume
VolumeControl.setVolume(1.0); //Float between 0.0 and 1.0

// Subscribe to volume changes
VolumeControl.subscribeToVolumeChanges(console.log.bind(console));
```

* Check the [JavaScript source](https://github.com/okanbeydanol/cordova-plugin-volume-manager/tree/master/www/VolumeControl.js) for additional configuration.


TypeScript / ES Module / Ionic
You can also use ES module imports (with TypeScript support):

```typescript
import { VolumeControl } from 'cordova-plugin-volume-manager';

// Get current volume
VolumeControl.getVolume((volume) => {
  console.log('Current volume:', volume);
});

// Set volume
VolumeControl.setVolume(0.5);

// Toggle mute
VolumeControl.toggleMute();

// Check if muted
VolumeControl.isMuted((muted) => {
  console.log('Muted:', muted);
});

// Subscribe to volume changes
VolumeControl.subscribeToVolumeChanges((volume) => {
  console.log('Volume changed:', volume);
});
```
TypeScript Types
Type definitions are included. You get full autocompletion and type safety in TypeScript/Ionic projects.


* Check the [Typescript definitions](https://github.com/okanbeydanol/cordova-plugin-volume-manager/tree/master/www/VolumeControl.d.ts) for additional configuration.


## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cordova). (Tag `cordova`)
- If you **found a bug** or **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.



## Contributing

Patches welcome! Please submit all pull requests against the master branch. If your pull request contains JavaScript patches or features, include relevant unit tests. Thanks!

## Copyright and license

    The MIT License (MIT)

    Copyright (c) 2024 Okan Beydanol

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
