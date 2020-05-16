//
//  InputViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/12.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class InputViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addCommentsText: UITextView!
    @IBOutlet weak var captionTextView: UITextView!

//MARK:  戻るボタン押下
    @IBAction func backButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    var postData:PostData!
    var date:Date = Date()

    
//MARK: - 投稿ボタン押下
    @IBAction func addCommentButton(_ sender: Any) {
        print("DEBUG_PRINT: 投稿ボタンを押下しました")
        //テキスト未入力時には何も返さない
        guard let addComment = addCommentsText.text else{
            return
        }
        if addComment.isEmpty{
            SVProgressHUD.showError(withStatus: "コメントを入力して下さい")
            //呼び出しクラスに何もないことを返却(return)する
            return
        }
        
        // 更新データを作成する(フィールドの値)
        var updateValue: FieldValue
        //dateString,name,addCommentをまとめる変数
//        var margeString:String = ""
        var dicString: [[String:String]] = [[:]]
        
        //Firebase「posts」フォルダのドキュメントの指定idを指定
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        
        
        //自動ID付与
        //postRef.childByAutoId().setValue(comments)
        
        //name : "投稿者名" 　data:"投稿者名"と"コメント"設置
        let name = Auth.auth().currentUser?.displayName
        
        //日付データ取得
        let date = Date()
         let formatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        let dateString = formatter.string(from: date)
        
//        margeString = (dateString + "　投稿者：" + name! + "　コメント：" + addComment)
        dicString = [["コメント":addComment,"投稿者":name!,"日時":dateString]]
        
        // 今回「投稿する」を押した場合は、[name,addComment]を追加する更新データを作成
        updateValue = FieldValue.arrayUnion(dicString)
        
        postRef.updateData(["comments": updateValue]) //updateDataにて更新
        // HUDで完了を知らせる
        SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
        
        // 投稿処理が完了したので先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
        
        self.nameLabel.text = postData.name
        self.captionTextView.text = postData.caption
    }
    
    @objc func dismissKeyboard(){
    // キーボードを閉じる
    view.endEditing(true)
    }
}
