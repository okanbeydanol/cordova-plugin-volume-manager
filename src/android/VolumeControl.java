package com.okanbeydanol.volumeControl;

import android.content.Context;
import android.database.ContentObserver;
import android.media.AudioManager;
import android.os.Handler;
import android.provider.Settings;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class VolumeControl extends CordovaPlugin {

    public static final String SET = "setVolume";
    public static final String GET = "getVolume";
    public static final String MUT = "toggleMute";
    public static final String ISM = "isMuted";
    public static final String SUBSCRIBE = "subscribeToVolumeChanges";

    private static final String TAG = "VolumeControl";

    private Context context;
    private AudioManager manager;
    private VolumeObserver volumeObserver;
    private CallbackContext volumeChangeCallbackContext;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        boolean actionState = true;
        context = cordova.getActivity().getApplicationContext();
        manager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);

        if (SET.equals(action)) {
            try {
                // Get the volume value to set
                int volumeToSet = (int) Math.round(args.getDouble(0) * 100.0f);
                int volume = getVolumeToSet(volumeToSet);
                boolean play_sound;

                if (args.length() > 1 && !args.isNull(1)) {
                    play_sound = args.getBoolean(1);
                } else {
                    play_sound = true;
                }

                // Set the volume
                manager.setStreamVolume(AudioManager.STREAM_MUSIC, volume, (play_sound ? AudioManager.FLAG_PLAY_SOUND : 0));
                callbackContext.success();
            } catch (Exception e) {
                LOG.d(TAG, "Error setting volume " + e);
                actionState = false;
            }
        } else if (GET.equals(action)) {
            try {
                // Get current system volume
                int _currVol = getCurrentVolume();
                float currVol = _currVol / 100.0f;
                String strVol = String.valueOf(currVol);
                LOG.d(TAG, "Volume changed: " + strVol);
                callbackContext.success(strVol);
            } catch (Exception e) {
                LOG.d(TAG, "Error getting volume " + e);
                actionState = false;
            }
        } else if (MUT.equals(action)) {
            try {
                // Mute or Unmute volume
                int volume = getCurrentVolume();
                float _volumeToSet = (float) args.getDouble(0);
                int volumeToSet = (int) Math.round(_volumeToSet * 100.0f);

                if (volume > 1) {
                    // Mute: Set volume to 0
                    volume = 0;
                } else {
                    // Unmute: Set volume to previous value
                    volume = getVolumeToSet(volumeToSet);
                }
                manager.setStreamVolume(AudioManager.STREAM_MUSIC, volume, AudioManager.FLAG_PLAY_SOUND);
                callbackContext.success(volume);

            } catch (Exception e) {
                LOG.d(TAG, "Error setting mute/unmute " + e);
                actionState = false;
            }
        } else if (ISM.equals(action)) {
            try {
                // Check if volume is muted
                int volume = getCurrentVolume();
                callbackContext.success(volume == 0 ? 0 : 1);
            } catch (Exception e) {
                LOG.d(TAG, "Error checking mute volume " + e);
                actionState = false;
            }
        } else if (SUBSCRIBE.equals(action)) {
            // Subscribe to volume changes
            volumeChangeCallbackContext = callbackContext;
            if (volumeObserver == null) {
                volumeObserver = new VolumeObserver(new Handler());
                context.getContentResolver().registerContentObserver(Settings.System.CONTENT_URI, true, volumeObserver);
            }
            // Keep the callback active
            PluginResult pluginResult = new PluginResult(PluginResult.Status.NO_RESULT);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        } else {
            actionState = false;
        }
        return actionState;
    }

    private int getVolumeToSet(int percent) {
        try {
            int volLevel;
            int maxVolume = manager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            volLevel = (percent * maxVolume) / 100;

            return volLevel;
        } catch (Exception e) {
            LOG.d(TAG, "Error getting VolumeToSet: " + e);
            return 1;
        }
    }

    private int getCurrentVolume() {
        try {
            int volLevel;
            int maxVolume = manager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            int currSystemVol = manager.getStreamVolume(AudioManager.STREAM_MUSIC);
            volLevel = (currSystemVol * 100) / maxVolume;

            return volLevel;
        } catch (Exception e) {
            LOG.d(TAG, "Error getting CurrentVolume: " + e);
            return 1;
        }
    }

    private class VolumeObserver extends ContentObserver {
        public VolumeObserver(Handler handler) {
            super(handler);
        }

        @Override
        public void onChange(boolean selfChange) {
            super.onChange(selfChange);
            int _currVol = getCurrentVolume();
            float currVol = _currVol / 100.0f;
            String strVol = String.valueOf(currVol);
            LOG.d(TAG, "Volume changed: " + strVol);
            if (volumeChangeCallbackContext != null) {
                PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, strVol);
                pluginResult.setKeepCallback(true);
                volumeChangeCallbackContext.sendPluginResult(pluginResult);
            }
        }
    }
}