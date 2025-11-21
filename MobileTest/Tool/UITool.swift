//
//  CommonTool.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/21.
//

import Foundation
import UIKit

class UITool {
    
    static func alert(msg: String!) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel)
            alert.addAction(cancelAction)
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                let currentViewController = rootViewController
                currentViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
