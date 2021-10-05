//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Mahmoud Ismail on 10/5/21.
//

import RxSwift
import RxRelay

protocol MovieDetailsViewModelInput {
    
}
protocol MovieDetailsViewModelOutput {
    var movie:Movie? {get}
}

class MovieDetailsViewModel: BaseViewModel, MovieDetailsViewModelInput, MovieDetailsViewModelOutput {
    
    var inputs:MovieDetailsViewModelInput{return self}
    var outputs:MovieDetailsViewModelOutput{return self}
    
    var movie: Movie?
    
    init(movie:Movie) {
        super.init()
        self.movie = movie
    }
    
}
