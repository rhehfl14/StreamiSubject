//
//  HomeCellTableViewCell.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/05/07.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit

class HomeCellTableViewCell: UITableViewCell {
    
    /// 통화쌍
    @IBOutlet weak var labelCoinName: UILabel!
    
    /// 현재가
    @IBOutlet weak var labelCoinPrice: UILabel!
    
    /// 거래량
    @IBOutlet weak var labelCoinVolume: UILabel!
    
    /// 상대통화
    @IBOutlet weak var labelQuote: UILabel!
    
    /// 기준통화
    @IBOutlet weak var labelBase: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelCoinName.text = nil
        labelCoinPrice.text = nil
        labelCoinVolume.text = nil
        labelQuote.text = nil
        labelBase.text = nil
    }
}
