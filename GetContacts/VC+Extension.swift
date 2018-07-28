//
//  VC+Extension.swift
//  Project
//
//  Created by WY on 2018/2/28.
//  Copyright © 2018年 HHCSZGD. All rights reserved.
//

import UIKit
extension UIViewController {
    
    static var userInfo: Void?
    /** key parameter of viewController */
    @IBInspectable var userInfo: Any? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.userInfo)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.userInfo, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func alert(title:String = "提示",detailTitle:String? = nil ,style :UIAlertControllerStyle = UIAlertControllerStyle.alert ,actions:[UIAlertAction] ){
        let actionVC = UIAlertController.init(title: title, message:detailTitle, preferredStyle: style)
        for action in actions{
            actionVC.addAction(action)
        }
        self.present(actionVC, animated: true, completion: nil)
    }
    func openSetting(){
        DispatchQueue.main.async {
            let url : URL = URL(string: UIApplicationOpenSettingsURLString)!
            if UIApplication.shared.canOpenURL(url ) {
                UIApplication.shared.open(url, options: [String : Any](), completionHandler: { (bool ) in
                    
                })
            }
        }
    }
    
}
