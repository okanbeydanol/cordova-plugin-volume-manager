declare namespace CordovaPlugins {
  interface VolumeControl {
    /**
     * Gets the current volume (0.0 - 1.0).
     */
    getVolume(
      success: (volume: number) => void,
      error?: (err: string | Error) => void
    ): void;

    /**
     * Toggles mute/unmute.
     */
    toggleMute(
      success?: () => void,
      error?: (err: string | Error) => void
    ): void;

    /**
     * Checks if muted.
     */
    isMuted(
      success: (muted: boolean) => void,
      error?: (err: string | Error) => void
    ): void;

    /**
     * Sets the volume (0.0 - 1.0).
     */
    setVolume(
      volume: number,
      success?: () => void,
      error?: (err: string | Error) => void
    ): void;

    /**
     * Subscribes to volume changes.
     */
    subscribeToVolumeChanges(
      success: (volume: number) => void,
      error?: (err: string | Error) => void
    ): void;
  }
}

interface CordovaPlugins {
  VolumeControl: CordovaPlugins.VolumeControl;
}

interface Cordova {
  plugins: CordovaPlugins;
}

declare let cordova: Cordova;

export const VolumeControl: CordovaPlugins.VolumeControl;
export as namespace VolumeControl;
declare const _default: CordovaPlugins.VolumeControl;
export default _default;