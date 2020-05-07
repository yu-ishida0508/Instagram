//
//  TabBarController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/07.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する。
        self.delegate = self
    }
    
    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する。
    //tabBarController(..)は指定されたVCをアクティブにするかどうかの問合せ
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //切替先がImageSelectViewControllerか判定
        if viewController is ImageSelectViewController {
            // ImageSelectViewController(写真)は、タブ切り替えではなくモーダル画面遷移する
            //instantiateViewController...SBの初期化されたデータと、識別子("ImageSelect")でVCを作成する。
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            //present(..)メソッドでモーダル画面遷移
            present(imageSelectViewController, animated: true)
            //return falseでこのメソッド戻ることで、「タブ切替え」は動作しない。
            return false
        } else {
            // その他のViewControllerは通常のタブ切り替えを実施
            return true
        }
    }

}
