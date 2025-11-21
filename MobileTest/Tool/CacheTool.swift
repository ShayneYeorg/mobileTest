//
//  CacheTool.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/21.
//

import Foundation

class CacheTool {
    
    static let shared = CacheTool()
    var model: BookingModel?
    
    private let fileName = "test_mobile_booking.json" // 存文件
    private var fileURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
    }
    
    func fetch() -> (BookingModel?) {
        // 如果当前已有保存的model，并且model没有过期，就直接返回
        if let mdl = model, !self.isCacheExpired(mdl) {
            return mdl
        }
        
        // 如果当前没有保存的model，去读取文件
        // 如果读取到文件，判断没有过期后，返回
        if let data = try? Data(contentsOf: fileURL),
           let mdl = try? JSONDecoder().decode(BookingModel.self, from: data) {
            
            if !isCacheExpired(mdl) {
                model = mdl
                return mdl
            }
        }
        
        // 其他情况，返回空
        clear()
        return nil
    }
    
    // 保存缓存
    func save(_ mdl: BookingModel) {
        model = mdl
        if let encoded = try? JSONEncoder().encode(mdl) {
            try? encoded.write(to: fileURL)
        }
    }
    
    // 清理缓存
    func clear() {
        model = nil
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    private func isCacheExpired(_ mdl: BookingModel) -> Bool {
        guard let expiredTimestamp = TimeInterval(mdl.expiryTime) else {
            return true
        }
        let expiredDate = Date(timeIntervalSince1970: expiredTimestamp)
        return Date() > expiredDate
    }
    
}
