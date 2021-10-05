//
//  MovieCell.swift
//  MovieApp
//
//  Created by Mahmoud Ismail on 10/5/21.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var movieImage_ImgView: DesignableUIImageView!
    @IBOutlet weak var rate_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    var movieModel:Movie?{
        didSet{
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func configure(){
        guard let movie = movieModel else {return}
        movieImage_ImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        movieImage_ImgView.sd_setImage(with: movie.posterURL, completed: nil)
        movieImage_ImgView.sd_imageTransition = .fade
        title_label.text = movie.title
        rate_label.text = movie.voteAverage.flatMap{String($0)}
        date_label.text = movie.releaseDate
    }
    
}
