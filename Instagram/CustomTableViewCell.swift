//
//  CustomTableViewCell.swift
//  taskapp
//
//  Created by 石田悠 on 2020/04/28.
//  Copyright © 2020 yuu.ishida. All rights reserved.
//

// MARK: -　CustomでTableViewCell(コメント用)を作成
import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var myTextViewLabel: UITextView! //メッセージ内容
    @IBOutlet weak var myTextLabel: UILabel!//メッセージ件数
    @IBOutlet weak var myTextCommentorLabel: UILabel!//コメント者
    @IBOutlet weak var myDateLabel: UILabel!//コメント日
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        myTextViewLabel.layer.cornerRadius = 15
        myTextLabel.layer.cornerRadius = 15
        backgroundColor = .clear
        myTextLabel.textColor = .white
        myTextCommentorLabel.textColor = .white
        myDateLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
