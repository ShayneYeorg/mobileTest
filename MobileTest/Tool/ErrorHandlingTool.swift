//
//  ErrorHandlingTool.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/21.
//

import Foundation

enum BookingError: Error {
    case parseFormat // 数据解析失败
    case serverFetch // 服务器获取数据失败
}

extension BookingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .parseFormat:
            return "解析服务器数据失败"
        case .serverFetch:
            return "获取服务器数据失败"
        }
    }
}

