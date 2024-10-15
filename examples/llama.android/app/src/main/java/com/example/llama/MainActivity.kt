package com.example.llama

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import com.example.llama.data.AppSettings
import com.example.llama.ui.screens.MainApp
import com.example.llama.ui.theme.LocalLMTheme
import com.example.llama.data.AvailableModels


//import org.samo_lego.locallm.voice.TTSEngine


class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AppSettings.init { getSharedPreferences(it, MODE_PRIVATE) }
        AvailableModels.init(filesDir.absolutePath)

        // TODO filesDir = /data/user/0/org.samo_lego.locallm/files
        //val filesDir = filesDir.absolutePath

        setContent {
            LocalLMTheme {
                MainApp(filesDir = filesDir.toString())
            }
        }
    }


    fun requestPermissionLauncher(fn: (Boolean) -> Unit) {
        registerForActivityResult(ActivityResultContracts.RequestPermission()) {
            fn(it)
        }
    }
}
