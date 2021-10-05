//
//  MainNavigator.swift


import UIKit
import RxCocoa
import RxSwift

class MainNavigator: Navigator{
    
    var coordinator: Coordinator
    
    enum Destination {
        // Home
        case home
        
        //movieDetails
        case movieDetails(movie:Movie)
    }
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func viewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .home:
            let viewController = HomeVC()
            viewController.title = "Popular"
            let viewModel = HomeViewModel()
            viewController.configure(viewModel: viewModel, coordinator: self.coordinator)
            return viewController
            
        case let .movieDetails(movie):
            let viewController = MovieDetailsVC()
            viewController.modalPresentationStyle = .overFullScreen
            let viewModel = MovieDetailsViewModel(movie: movie)
            viewController.configure(viewModel: viewModel, coordinator: self.coordinator)
            return viewController
      
        }
    }
    
}
