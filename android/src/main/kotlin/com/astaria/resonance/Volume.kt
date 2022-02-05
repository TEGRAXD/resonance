package com.astaria.resonance

import android.content.Context
import android.media.AudioManager
import java.math.RoundingMode
import java.text.DecimalFormat
import java.text.DecimalFormatSymbols
import java.util.Locale
import kotlin.math.round

fun Number.twoDecimalPlaceRound(): Double {
    // 0.25 -> 0.2.
    // 0.65 -> 0.7.
    // Using [kotlin.math.round] reverts 0.25 back to 0.0 and 0.65 to 1.0
    val df = DecimalFormat("#.##", DecimalFormatSymbols(Locale.ENGLISH)).apply {
        roundingMode = RoundingMode.HALF_DOWN
    }
    return df.format(this).toDouble()
}

class Volume {
    companion object {
        private val streamTypes: List<Int> = listOf(AudioManager.STREAM_ALARM, AudioManager.STREAM_DTMF,
                                                    AudioManager.STREAM_MUSIC, AudioManager.STREAM_NOTIFICATION,
                                                    AudioManager.STREAM_RING, AudioManager.STREAM_SYSTEM,
                                                    AudioManager.STREAM_VOICE_CALL)

        private fun validateType(streamType: Int): Int = if(streamTypes.contains(streamType)) streamType else -1

        fun getCurrentVolumeLevel(context: Context, type: Int?): Double {
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val streamType: Int = validateType(type ?: -1)

            val maxValue: Double = audioManager.getStreamMaxVolume(streamType).toDouble()
            val value: Double = (audioManager.getStreamVolume(streamType).toDouble() / maxValue) * 1.0

            return if(streamType != -1) value.twoDecimalPlaceRound() else -1.0
        }

        fun getMaxVolumeLevel(context: Context, type: Int?): Double {
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val streamType: Int = validateType(type ?: -1)

            val maxValue: Double = (audioManager.getStreamMaxVolume(streamType).toDouble() / audioManager.getStreamMaxVolume(streamType).toDouble()) * 1.0

            return if (streamType != -1) maxValue.twoDecimalPlaceRound() else -1.0
        }

        fun setVolumeLevel(context: Context, type: Int?, volumeValue: Double, showVolumeUI: Int): Double {
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val streamType: Int = validateType(type ?: -1)

            val maxValue: Double = audioManager.getStreamMaxVolume(streamType).toDouble()
            val value: Int = round(volumeValue * maxValue).toInt()

            val returnValue: Double = (value.toDouble() / maxValue) * 1.0

            // Use flag AudioManager.FLAG_SHOW_UI or simply 1 and 0. (AudioManager.FLAG_SHOW_UI equivalent to 1)
            audioManager.setStreamVolume(streamType, value, if (showVolumeUI == 1) AudioManager.FLAG_SHOW_UI else 0)
            return if(streamType != -1) returnValue.twoDecimalPlaceRound() else -1.0
        }

        fun setMaxVolumeLevel(context: Context, type: Int?, showVolumeUI: Int): Double {
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val streamType: Int = validateType(type ?: -1)

            val maxValue: Double = audioManager.getStreamMaxVolume(streamType).toDouble()
            val value: Double = ((maxValue / maxValue) * 1.0)

            // Use flag AudioManager.FLAG_SHOW_UI or simply 1 and 0. (AudioManager.FLAG_SHOW_UI equivalent to 1)
            audioManager.setStreamVolume(streamType, maxValue.toInt(), if (showVolumeUI == 1) AudioManager.FLAG_SHOW_UI else 0)
            return if(streamType != -1) value.twoDecimalPlaceRound() else -1.0
        }

        fun setMuteVolumeLevel(context: Context, type: Int?, showVolumeUI: Int): Double {
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val streamType: Int = validateType(type ?: -1)

            val value = 0

            // Use flag AudioManager.FLAG_SHOW_UI or simply 1 and 0. (AudioManager.FLAG_SHOW_UI equivalent to 1)
            audioManager.setStreamVolume(streamType, value, if (showVolumeUI == 1) AudioManager.FLAG_SHOW_UI else 0)
            return if(streamType != -1) value.twoDecimalPlaceRound() else -1.0
        }

    }

}