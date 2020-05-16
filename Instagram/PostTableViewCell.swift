//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 石田悠 on 2020/05/10.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

import UIKit
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var inputCommentButton: UIButton!
    @IBOutlet weak var commentorLabel1: UILabel! //投稿者1
    @IBOutlet weak var commentLabel1: UILabel!
    @IBOutlet weak var commentorLabel2: UILabel! //投稿者2
    @IBOutlet weak var commentLabel2: UILabel!
    @IBOutlet weak var commentorLabel3: UILabel!
    @IBOutlet weak var commentLabel3: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

//MARK:- PostDataの内容をセルに表示
// PostDataの内容をセルに表示 HomeVCから呼出される
    func setPostData(_ postData: PostData) {
        // 画像の表示
        //sd_...プロパティはFirebaseUIをインポートすることでUIImageに追加されたメソッド
        //sd_imageIndicatorはCloud Storageから画像をダウン中を表すインジケータ
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
       //sd_setImage引数にCloud Storageの画像保存先指定で自動的にダウンロードしImgVに表示
       //imageRefはPostVCで指定したFirebaseの投稿データ保存先
        postImageView.sd_setImage(with: imageRef)

//MARK: キャプションの表示 (「投稿者名 」:「 キャプション情報」)
        //「投稿者名 : キャプション情報」を一つの文字列そとして表示
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"

//MARK: 日時の表示
        self.dateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            //"yyyy-MM-dd HH:mm"　2019-09-15 09:41といった文字列に変換
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }

//MARK:- いいね数の表示
        //「postData.likes」はいいねを押したuid一覧が格納
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"

//MARK:- いいねボタンの表示
        //postData.isLiked == true {　(省略されている)
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
//MARK:- コメント数の表示
        //「postData.comments」はコメントを記入した配列の中に辞書型
    //    let commentNumber = postData.comments.count
    //    self.commentButton.setTitle ("コメント\(commentNumber)件を表示", for: .normal)
        //コメントがされていない場合の処理
        if postData.comments[0]["コメント"] == nil{
//        self.commentButton.isHidden = true //コメント件数ボタン非表示
        self.commentButton.setTitle ("コメントはまだありません", for: .normal)
        self.commentButton.isEnabled = false //ボタンタップの無効化
        }
        else{
//        self.commentButton.isHidden = false //コメント件数ボタン表示
        self.commentButton.setTitle ("コメント全\(postData.comments.count)件を表示", for: .normal)
        self.commentButton.isEnabled = true //ボタンタップの有効化
        }

//MARK:- 投稿者・コメントの表示
        //ラベルを表示させトルツメをさせるかBool関数
        func LabelFunc(label11:Bool,label12:Bool,label21:Bool,label22:Bool,label31:Bool,label32:Bool){
            self.commentorLabel1.isHidden = label11
            self.commentLabel1.isHidden = label12
            self.commentorLabel2.isHidden = label21
            self.commentLabel2.isHidden = label22
            self.commentorLabel3.isHidden = label31
            self.commentLabel3.isHidden = label32
        }
        if postData.comments.count == 1 { //コメント１件の場合
            if postData.comments[0]["コメント"] == nil { //1件がnilの場合
                
                LabelFunc(label11: true, label12: true, label21: true, label22: true, label31: true, label32: true)

            }else{//1件がnilでない場合
                LabelFunc(label11: false, label12: false, label21: true, label22: true, label31: true, label32: true)

                self.commentorLabel1.text = postData.comments[0]["投稿者"]
                self.commentLabel1.text = postData.comments[0]["コメント"]
            }
        }
        
            if postData.comments.count == 2 { //2件の場合
                LabelFunc(label11: false, label12: false, label21: false, label22: false, label31: true, label32: true)
                
                self.commentorLabel1.text = postData.comments[0]["投稿者"]
                self.commentLabel1.text = postData.comments[0]["コメント"]
                self.commentorLabel2.text = postData.comments[1]["投稿者"]
                self.commentLabel2.text = postData.comments[1]["コメント"]
            }
            else if postData.comments.count >= 3 { //3件以上の場合
                LabelFunc(label11: false, label12: false, label21: false, label22: false, label31: false, label32: false)
                self.commentorLabel1.text = postData.comments[0]["投稿者"]
                self.commentLabel1.text = postData.comments[0]["コメント"]
                self.commentorLabel2.text = postData.comments[1]["投稿者"]
                self.commentLabel2.text = postData.comments[1]["コメント"]
                self.commentorLabel3.text = postData.comments[2]["投稿者"]
                self.commentLabel3.text = postData.comments[2]["コメント"]
            }
          
        
//MARK:-
    }
}
