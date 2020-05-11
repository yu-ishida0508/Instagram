//
//  SettingViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/06.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    @IBOutlet weak var displayNameTextField: UITextField!
//MARK: - 「表示名を変更」ボタン押下時
    @IBAction func handleChangeButton(_ sender: Any) {
        //if let displayName = displayNameTextField.textとは
        //displayNameTextField.textがnilでない時、
        //「displayName = displayNameTextField.text」を実行する
        //is.Emptyは付箋は貼ってあり、文字が無い、nilはそもそも何もない、ここで(if let〜)は処理されることはない。
        //しかし、if let でdisplayName = displayNameTextField.text!とアンラップしているため必要であり、万が一のnil対策
        if let displayName = displayNameTextField.text {

            // 表示名が入力されていない時はHUDを出して何もしない
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                //呼び出しクラスに何もないことを返却(return)する
                return
            }

            // 表示名を設定する
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")

                    // HUDで完了を知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        // キーボードを閉じる
        self.view.endEditing(true)
    }
//MARK: -ログアウトボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleLogoutButton(_ sender: Any) {
        // ログアウトする
        try! Auth.auth().signOut()

        // ログイン画面を表示する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        //present(..)メソッドでモーダル画面遷移(segueのコード版)
        self.present(loginViewController!, animated: true, completion: nil)

        // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく（0がタブの一番左）

        tabBarController?.selectedIndex = 0
    }
    
//MARK: - 表示名を取得してTextFieldに設定する
    //このクラスの画面が表示される「前」に呼び出される
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

            // 表示名を取得してTextFieldに設定する
            let user = Auth.auth().currentUser
            //(左辺)user(=Auth.auth().currentUser)がnilでなければ、以下の処理を行う
            if let user = user {
                displayNameTextField.text = user.displayName
            }
        }
    override func viewDidLoad() {
           super.viewDidLoad()
       
       }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
