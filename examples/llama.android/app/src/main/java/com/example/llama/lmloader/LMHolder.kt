package com.example.llama.lmloader

import android.llama.cpp.LLamaAndroid
import android.util.Log
import com.example.llama.data.LMProperties
import com.example.llama.data.SettingsKeys
import com.example.llama.data.appSettings
import com.example.llama.ui.screens.modelAvailableState
import com.example.llama.ui.screens.modelLoadedState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class LMHolder {
    companion object {
        private var currentModelProperties: LMProperties? = null

        private val suggestQueue = mutableListOf<Suggestion>()
        private var modelLoading: Job? = null

        fun suggest(
            question: String,
            onSuggestion: (String) -> Boolean = { true },
            onEnd: () -> Unit = {},
        ) {
            if (currentModelProperties != null) {
                CoroutineScope(Dispatchers.Default).launch {
                    Log.d("xuezhiyuan question:= ", question);
                    LLamaAndroid.instance().send(question, onSuggestion, onEnd)
                }
            } else {
                suggestQueue.add(Suggestion(question, onSuggestion, onEnd))
            }
        }

        private fun onModelLoaded() {
            for (question in suggestQueue) {
                suggest(
                    question.question,
                    question.onSuggestion,
                    question.onEnd,
                )
            }
            Log.d("xuezhiyuan", "model load success")
        }

        suspend fun currentModel(): LMProperties? {
            if (modelLoading != null) {
                modelLoading!!.join()
                modelLoading = null
            }

            return currentModelProperties
        }

        fun setModel(model: LMProperties) {
            Log.i("xuezhiyuan", "modelPath ${model?.modelPath}")
            Log.i("xuezhiyuan", "modelName ${model?.name}")
            if (currentModelProperties != null && currentModelProperties!!.modelPath == model.modelPath) {
                // Just switch the properties
                currentModelProperties = model
                return
            }

            modelLoadedState.value = false
            modelAvailableState.value = true
            currentModelProperties = null

            modelLoading = CoroutineScope(Dispatchers.Default).launch {
                LLamaAndroid.instance().unload()
                LLamaAndroid.instance().load(model.modelPath) {
                    currentModelProperties = model
                    appSettings.setString(SettingsKeys.LAST_MODEL, model.name)
                    modelLoadedState.value = true
                    onModelLoaded()
                }
            }
        }
    }
}

private data class Suggestion(
    val question: String,
    val onSuggestion: (String) -> Boolean = { true },
    val onEnd: () -> Unit = {},
)
