//
//  BookingModel.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/21.
//

import Foundation

struct BookingModel: Codable {
    
    let shipReference: String
    let shipToken: String
    let canIssueTicketChecking: Bool
    let expiryTime: String
    let duration: Int
    let segments: [Segment]
    
}
struct Segment: Codable, Identifiable {
    
    let id: Int
    let originAndDestinationPair: OriginDestinationPair
    
}

struct OriginDestinationPair: Codable {
    
    let destination: Location
    let destinationCity: String
    let origin: Location
    let originCity: String
    
}

struct Location: Codable {
    
    let code: String
    let displayName: String
    let url: String
    
}
