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
    @IBOutlet weak var commentorLabel1: UILabel!
    @IBOutlet weak var commentLabel1: UILabel!
    
    
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
        self.commentButton.setTitle ("コメント\(postData.comments.count)件を表示", for: .normal)
        self.commentButton.isEnabled = true //ボタンタップの有効化
        }

//MARK:- 投稿者・コメントの表示
        //トルツメでnilの場合は非表示にする
        if postData.comments[0]["コメント"] == nil {
//            self.commentorLabel1.text = nil
//            self.commentLabel1.text = nil
            self.commentorLabel1.isHidden = !self.commentorLabel1.isHidden
            self.commentLabel1.isHidden = !self.commentLabel1.isHidden
        }
        else{
            self.commentorLabel1.text = postData.comments[0]["投稿者"]
            self.commentLabel1.text = postData.comments[0]["コメント"]
        }
        
//MARK:-
    }
}
