//
//  ErrorAlert.swift
//  iTunesAPI
//
//  Created by 大江祥太郎 on 2021/09/06.
//

import UIKit

class ErrorAlert {
    
    private static func errorAlert(title: String, message: String = "") -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: title, message : message, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        return alert
    }
    
    static func wrongWordError() -> UIAlertController {
        return errorAlert(title: "不正なワードが入力されました", message: "検索ワードを確認してください")
    }
    
    static func networkError() -> UIAlertController {
        return errorAlert(title: "インターネットに接続されていません", message: "接続状況を確認してください")
    }
    
    static func parseError() -> UIAlertController {
        return errorAlert(title: "データの表示に失敗しました")
    }
}
