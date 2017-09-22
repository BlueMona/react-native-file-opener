package com.fileopener;

import android.content.Intent;
import android.net.Uri;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import org.json.JSONException;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

public class FileOpener extends ReactContextBaseJavaModule {

    public FileOpener(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "FileOpener";
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        return constants;
    }

    @ReactMethod
    public void open(String fileArg, String contentType, Promise promise) throws JSONException {
        Uri path = null;
        if (fileArg.startsWith("content:")) {
            path = Uri.parse(fileArg);
        } else {
            File file = new File(fileArg);
            if (file.exists()) {
                path = Uri.fromFile(file);
            } else {
                promise.reject("FileOpener.java: File not found");
                return;
            }
        }
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setDataAndType(path, contentType);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            getReactApplicationContext().startActivity(intent);
            promise.resolve("FileOpener.java: open success");
        } catch (android.content.ActivityNotFoundException e) {
            promise.reject("FileOpener.java: open error - activity not found");
        }
    }
}