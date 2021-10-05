//
//  CharacterDetailsVC.swift
//  MovieApp
//
//  Created by Mahmoud Ismail on 10/5/21.
//

import UIKit
import SDWebImage

class MovieDetailsVC: BaseWireFrame<MovieDetailsViewModel> {
    @IBOutlet weak var overview_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var movieImage_ImgView: UIImageView!
    @IBOutlet weak var rate_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var close_Button: UIButton!
    @IBOutlet weak var contentView_View: DesignableUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView_View.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Animator.animateBackgroundView(self.view)
        handleAnimationFade()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view =  touches.first?.view, view == self.view else {return}
        handleAnimationFade(show: false)
    }
    
    override func bind(viewModel: MovieDetailsViewModel) {
        setMovieData()
        handleClose()
    }
    
    private func setMovieData() {
        guard let movie = viewModel.outputs.movie else {return}
        self.movieImage_ImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.movieImage_ImgView.sd_setImage(with: movie.posterURL, completed: nil)
        self.movieImage_ImgView.sd_imageTransition = .fade
        self.title_label.text = movie.title
        self.rate_label.text = movie.voteAverage.flatMap{String($0)}
        self.date_label.text = movie.releaseDate
        self.overview_label.text = movie.overview
    }
    
    private func handleClose() {
        close_Button.rx.tap.subscribe { [weak self](_) in
            self?.handleAnimationFade(show: false)
        }.disposed(by: disposeBag)
    }
}
//MARK:- Handle Animation
extension MovieDetailsVC {
    private func handleAnimationFade(show: Bool = true) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) { [weak self] in
                guard let self = self else {return}
                self.contentView_View.transform = show ? .identity : CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.contentView_View.alpha = show ? 1 : 0
                if !show{
                    self.view.backgroundColor = .clear
                }
                self.view.layoutIfNeeded()
            } completion: { [weak self](_) in
                guard !show else {return}
                self?.dismiss(animated: false)
            }
            
        }
    }
}
