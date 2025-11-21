//
//  BookingDataMananger.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/20.
//

/*
 主要逻辑：
 1、获取预订数据的方法provideData()和provideData(forceFromServer)
  （1)、如果要求从缓存获取Booking数据（缓存是否过期的逻辑由CacheTool自己去处理）,获取并返回
  （2)、如果要求从服务器获取 或者 缓存获取为空，则向服务器获取数据，获取并返回
 */

import Foundation

class BookingDataManager {
    
    static let shared = BookingDataManager()
    private let mockDataFileName = "booking"
    
    func provideData() async throws -> BookingModel? {
        return try await self.provideData(forceFromServer: false)
    }
    
    /// 获取Booking的数据列表
    /// - Parameter forceFromServer: 是否强制从服务器拉取数据。false的时候优先从缓存获取，缓存获取失败再向服务器拉取
    /// - Returns: models: Booking数据列表
    func provideData(forceFromServer: Bool) async throws -> BookingModel? {
        
        // 1、如果要求从缓存获取Booking数据（缓存是否过期的逻辑由CacheTool自己去处理）,获取并返回
        if !forceFromServer {
            if let model = CacheTool.shared.fetch() {
                return (model)
            }
        }
        
        // 2、如果 缓存获取为空 或者 要求从服务器获取，则向服务器获取数据，获取并返回
        if let model = try await fetchFromServer() {
            CacheTool.shared.save(model)
            return (model)
        }
        return nil
    }
    
    func fetchFromServer() async throws -> BookingModel?  {
        
        guard let url = Bundle.main.url(forResource: mockDataFileName, withExtension: "json") else {
            throw BookingError.serverFetch
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(BookingModel.self, from: data)
        } catch {
            throw BookingError.parseFormat
        }
    }
    
}
