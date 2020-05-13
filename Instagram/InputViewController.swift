//
//  InputViewController.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/12.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import Firebase

class InputViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var addCommentsText: UITextView!
    
    var addNameLabel = ""
    var addCaptionLabel = ""
    
    //投稿ボタン押下時
    @IBAction func addCommentButton(_ sender: Any) {
        //テキスト未入力時には何も返さない
        guard let addComment = addCommentsText.text else{
            return
        }
        //name : "投稿者"の名前 data:"投稿者名"と"コメント"設置
        let name = Auth.auth().currentUser?.displayName
        let comments = ["postName":name,"message":addComment]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
    self.view.addGestureRecognizer(tapGesture)
        nameLabel.text = addNameLabel
        captionLabel.text = addCaptionLabel
    }
    
    @objc func dismissKeyboard(){
    // キーボードを閉じる
    view.endEditing(true)
    }
}
