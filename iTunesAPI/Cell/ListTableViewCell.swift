//
//  ListTableViewCell.swift
//  iTunesAPI
//
//  Created by 大江祥太郎 on 2021/09/06.
//

import UIKit
import SDWebImage

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    
    static let cellIdentifier = String(describing: ListTableViewCell.self)
    
    func setup(song: Song) {
        
        songNameLabel.text = song.trackCensoredName ?? ""
        artistNameLabel.text = song.artistName ?? ""
        
        if let url = song.artworkImageUrl100 {
            artistImageView.sd_setImage(with: url, completed: nil)
        } else {
            artistImageView.image = nil
        }
    }
}
