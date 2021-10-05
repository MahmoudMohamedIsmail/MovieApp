//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Mahmoud Ismail on 10/5/21.
//

import RxSwift
import RxRelay

protocol HomeViewModelInput {
    func prefetchRowsAt(indexPaths: [IndexPath])
}
protocol HomeViewModelOutput {
    var moviesObservable:Observable<[Movie]>{get}
}

class HomeViewModel:BaseViewModel, HomeViewModelInput, HomeViewModelOutput {
    
    var inputs:HomeViewModelInput{return self}
    var outputs:HomeViewModelOutput{return self}
    
    //outputs
    private var movies:BehaviorRelay<[Movie]> = .init(value: [])
    var moviesObservable: Observable<[Movie]> {
        return movies.asObservable()
    }
    
    private var pagination:Pagination!
    
     init() {
        super.init()
        pagination = Pagination()
        getMovies()

    }
    
    func prefetchRowsAt(indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.last else {return}
        if (indexPath.row  > (self.movies.value.count - 5)){
            guard !pagination.noMorePages else {
                return
            }
            guard !pagination.isFeatching else {return}
            pagination.pageNumber += 1
            getMovies()
        }
    }
    
}

extension HomeViewModel{
    private func getMovies(){
        pagination.isFeatching = true
        appServiceClint.performRequest([Movie].self, serviceGateway: .getPopularMovies(page: pagination.pageNumber)).subscribe {[weak self] (respons) in
            self?.pagination.isFeatching = false
            guard let self = self, let movies = respons.response else {return}
            
            if self.pagination.pageNumber == 1 {
                self.movies.accept(movies)
            }
            else {
                self.movies.accept(self.movies.value + movies)
            }
            
        } onError: { [weak self](error) in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)

    }
}
