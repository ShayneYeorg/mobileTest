//
//  BookingDisplayView.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/20.
//

/*
 主要逻辑：
 1、进入页面，通过BookingDataMananger获取数据（数据来源是 服务器 还是 缓存 由BDM去处理）
 2、下拉刷新向BookingDataMananger强制要求获取 服务器数据
 3、展示数据，在控制台打印出数据
 4、出错的情况下弹窗提示
 */

import SwiftUI

struct BookingDisplayView: View {
    
    @State private var model: BookingModel?
    @State private var isLoading = true
    
    var body: some View {
        
        Group {
            if (!isLoading) {
                VStack(alignment: .leading, spacing: 20) {
                    if let mdl = model {
                        List(mdl.segments) { segment in
                            SegmentRow(segment: segment)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .refreshable {
            model = await loadBookings(isRefresh: true)
            CommonTool.printLog("\(String(describing: model))")
        }
        .task {
            model = await loadBookings(isRefresh: false)
            isLoading = false
            CommonTool.printLog("\(String(describing: model))")
        }
    }
    
    func loadBookings(isRefresh: Bool) async -> BookingModel? {
        do {
            if !isRefresh {
                return try await BookingDataManager.shared.provideData()
            }
            return try await BookingDataManager.shared.provideData(forceFromServer: true)
        }
        catch {
            let msg = error.localizedDescription
            CommonTool.printLog("错误信息：\(msg)")
            UITool.alert(msg: msg) // 弹窗提示Error信息
        }
        return model // 获取数据出错的情况下，保持当前显示
    }
}

struct SegmentRow: View {
    
    let segment: Segment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(segment.originAndDestinationPair.origin.code)
            Text(segment.originAndDestinationPair.origin.displayName)
            Text(segment.originAndDestinationPair.originCity)
            
            Spacer()
            
            Text(segment.originAndDestinationPair.destination.code)
            Text(segment.originAndDestinationPair.destination.displayName)
            Text(segment.originAndDestinationPair.destinationCity)
        }
        .padding()
    }
}

struct BookingDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDisplayView()
    }
}
