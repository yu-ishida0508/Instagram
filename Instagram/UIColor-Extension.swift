//
//  UIColor-Extension.swift
//  ChatAppWithFirebase
//
//  Created by 石田悠 on 2020/05/13.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
extension UIColor{
    
    
    //255の間の中で色を選択できるようにする
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat) ->UIColor{
        return self.init(red:red / 255, green:green / 255, blue:blue / 255, alpha: 1)
    }
}
