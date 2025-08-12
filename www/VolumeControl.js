function VolumeControl() { }

VolumeControl.prototype.toggleMute = function (success, error) {
    cordova.exec(success, error, 'VolumeControl', 'toggleMute', []);
};

VolumeControl.prototype.isMuted = function (success, error) {
    cordova.exec(success, error, 'VolumeControl', 'isMuted', []);
};

VolumeControl.prototype.getVolume = function (success, error) {
    cordova.exec(success, error, 'VolumeControl', 'getVolume', []);
};

VolumeControl.prototype.setVolume = function (volume, success, error) {
    if (volume > 1) {
        volume /= 100; // Normalize to 0-1 range
    }
    cordova.exec(success, error, 'VolumeControl', 'setVolume', [volume]);
};

VolumeControl.prototype.subscribeToVolumeChanges = function (success, error) {
    cordova.exec(success, error, 'VolumeControl', 'subscribeToVolumeChanges', []);
};

module.exports = new VolumeControl();
module.exports.VolumeControl = module.exports; // Add this line

// For ES module import support
if (typeof window !== 'undefined' && window.cordova && window.cordova.plugins) {
    window.cordova.plugins.VolumeControl = module.exports;
}