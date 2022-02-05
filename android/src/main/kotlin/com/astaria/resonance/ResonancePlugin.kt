package com.astaria.resonance

import android.app.Activity
import android.content.Context
import android.database.ContentObserver
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.media.AudioManager
import android.provider.Settings
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

private const val mainChannel: String = "com.astaria.resonance"

/** ResonancePlugin */
class ResonancePlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val methodChannelName: String = "${mainChannel}.method"
  private val eventChannelName: String = "${mainChannel}.event"

  private lateinit var methodChannel : MethodChannel
  private var eventChannel : EventChannel? = null

  private lateinit var context: Context
  private lateinit var activity: Activity

  private var eventSink: EventChannel.EventSink? = null
  private lateinit var contentObserver: ContentObserver

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    context = flutterPluginBinding.applicationContext
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, eventChannelName)
    eventChannel?.setStreamHandler(this)

    contentObserver = object : ContentObserver(null) {
      override fun deliverSelfNotifications(): Boolean = false

      override fun onChange(selfChange: Boolean) {
        val crntVolumeLevel = Volume.getCurrentVolumeLevel(context, AudioManager.STREAM_MUSIC)

        // use Kotlin Coroutines or Handler.post with Looper.getMainLooper()
        activity.runOnUiThread {
          eventSink?.success(crntVolumeLevel)
        }

        super.onChange(selfChange)
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }

  /// This static function is optional and equivalent to onAttachedToEngine. It supports the old
  /// pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  /// plugin registration via this function while apps migrate to use the new Android APIs
  /// post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  ///
  /// It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  /// them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  /// depending on the user's project. onAttachedToEngine or registerWith must both be defined
  /// in the same class.
  ///
  ///  companion object {
  ///    @JvmStatic
  ///    fun registerWith(registrar: PluginRegistry.Registrar) {
  ///      val channel = MethodChannel(registrar.messenger(), "volume")
  ///      channel.setMethodCallHandler { call: MethodCall, result: Result ->
  ///        if (call.method == "something") {
  ///          result.success(true)
  ///        }
  ///      }
  ///    }
  ///  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val streamTypeArg: Int = call.argument("stream_type") ?: -1
    when (call.method) {
      "getCurrentVolumeLevel" -> {
        val crntVolumeLevel: Double = Volume.getCurrentVolumeLevel(context, streamTypeArg)
        if (crntVolumeLevel != -1.0) {
          result.success(crntVolumeLevel)
        } else {
          result.error("801", "Bad Stream Type", null)
        }
      }
      "getMaxVolumeLevel" -> {
        val maxVolumeLevel: Double = Volume.getMaxVolumeLevel(context, streamTypeArg)
        if (maxVolumeLevel != -1.0) {
          result.success(maxVolumeLevel)
        } else {
          result.error("802", "Bad Stream Type", null)
        }
      }
      "setVolumeLevel" -> {
        val volumeValueArg: Double = call.argument("volume_value")!!
        val showVolumeUIValueArg: Int = call.argument("show_volume_ui")!!
        val crntVolumeLevel: Double = Volume.setVolumeLevel(context, streamTypeArg, volumeValueArg, showVolumeUIValueArg)
        if (crntVolumeLevel != -1.0) {
          result.success(crntVolumeLevel)
        } else {
          result.error("803", "Bad Stream Type", null)
        }
      }
      "setMaxVolumeLevel" -> {
        val showVolumeUIValueArg: Int = call.argument("show_volume_ui")!!
        val crntVolumeLevel: Double = Volume.setMaxVolumeLevel(context, streamTypeArg, showVolumeUIValueArg)
        if (crntVolumeLevel != -1.0) {
          result.success(crntVolumeLevel)
        } else {
          result.error("804", "Bad Stream Type", null)
        }
      }
      "setMuteVolumeLevel" -> {
        val showVolumeUIValueArg: Int = call.argument("show_volume_ui")!!
        val crntVolumeLevel: Double = Volume.setMuteVolumeLevel(context, streamTypeArg, showVolumeUIValueArg)
        if (crntVolumeLevel != -1.0) {
          result.success(crntVolumeLevel)
        } else {
          result.error("805", "Bad Stream Type", null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events

    context.contentResolver.registerContentObserver(Settings.System.CONTENT_URI, true, contentObserver)
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
    eventChannel = null
    context.contentResolver.unregisterContentObserver(contentObserver)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {}

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {}
}
