package com.example.llama.ui.components

import android.util.Log
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.Stop
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.IconButtonDefaults
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun Input(
    onTextSend: (String) -> Unit = {},
    onForceStopGeneration: () -> Unit = {},
    isGenerating: Boolean
) {
    var text by rememberSaveable {
        mutableStateOf("")
    }

    Column(
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        TextField(
            modifier = Modifier.fillMaxWidth(),
            value = text,
            onValueChange = { text = it },
            trailingIcon = {
                IconButton(
                    colors = IconButtonDefaults.filledIconButtonColors(),
                    modifier = Modifier.padding(8.dp),
                    onClick = {
                        if (isGenerating) {
                            onForceStopGeneration()
                        }

                        if (text.isNotEmpty()) {
                            Log.d("xuezhiyuan",text)
                            onTextSend(text)
                            text = ""
                        }
                    },
                ) {
                    Icon(
                        if (isGenerating) Icons.Default.Stop else Icons.AutoMirrored.Filled.Send,
                        contentDescription = "Button",
                    )
                }
            },
        )
    }
}

@Preview
@Composable
fun InputPreview() {
    Input(isGenerating = false)
}

@Preview
@Composable
fun InputPreviewGenerating() {
    Input(isGenerating = true)
}

