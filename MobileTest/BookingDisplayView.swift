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
                
                Text(model.canIssueTicketChecking ? "可检票" : "未可检票").padding(20)
                
                VStack {
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
            UITool.alert(msg: error.localizedDescription + (model == nil ? "，点击重试" : "")) {
                // 没有数据可展示的话，点击"确定"就重新获取数据
                if model == nil {
                    reloadTrigger.toggle()
                }
            }
        }
        // 其他情况，保持当前显示
        return model
    }
}

struct SegmentRow: View {
    
    let segment: Segment
    
    var body: some View {
        VStack() {
            HStack {
                Text(segment.originAndDestinationPair.originCity).font(.system(size: 25, design: .default))
                Text("至")
                Text(segment.originAndDestinationPair.destinationCity).font(.system(size: 25, design: .default))
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("出发: " + segment.originAndDestinationPair.origin.displayName + " (" + segment.originAndDestinationPair.origin.code + ")")
                
                Text("到达: " + segment.originAndDestinationPair.destination.displayName + " (" + segment.originAndDestinationPair.destination.code + ")")
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}

struct BookingDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDisplayView()
    }
}
