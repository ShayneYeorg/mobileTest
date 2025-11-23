//
//  CommonTool.swift
//  MobileTest
//
//  Created by 杨淳引 on 2025/11/21.
//

import Foundation
import UIKit

class UITool {
    
    static func alert(msg: String!, completion: (()->Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .cancel) { _ in
                if let completion = completion {
                    completion()
                }
            }
            alert.addAction(action)
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                let currentViewController = rootViewController
                currentViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
