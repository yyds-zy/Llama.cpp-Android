package com.example.llama.ui.navigation

import androidx.navigation.NavController

fun NavController.navigate2(route: Routes) = navigate(route.path)

enum class Routes(val path: String) {
    HOME("home"),
    SETTINGS("settings"),
    ADD_MODEL("add_model"),
}
