//
//  MobileTestApp.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/20.
//

/*
 主要功能：
 1、BookingDataMananger：充当booking的数据提供者
 2、BookingDisplayView：展示数据的列表页面
 */

import SwiftUI

@main
struct MobileTestApp: App {
    var body: some Scene {
        WindowGroup {
            BookingDisplayView()
        }
    }
}
