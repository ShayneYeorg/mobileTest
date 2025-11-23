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
    @State var reloadTrigger = false
    
    var body: some View {
        
        Group {
            if let model = model {
                VStack(alignment: .leading, spacing: 20) {
                    List(model.segments) { segment in
                        SegmentRow(segment: segment)
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
        .task (id: reloadTrigger) {
            model = await loadBookings(isRefresh: false)
            CommonTool.printLog("\(String(describing: model))")
        }
    }
    
    func loadBookings(isRefresh: Bool) async -> BookingModel? {
        do {
            return try await BookingDataManager.shared.provideData(forceFromServer: isRefresh)
        }
        catch {
            // 弹窗提示Error信息
            UITool.alert(msg: error.localizedDescription) {
                // 没有数据可展示，就重新获取
                if model == nil {
                    reloadTrigger.toggle()
                }
            }
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
