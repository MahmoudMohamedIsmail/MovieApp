//
//  HomeVC.swift
//  MovieApp
//
//  Created by Mahmoud Ismail on 10/5/21.
//

import RxCocoa
import RxSwift

class HomeVC: BaseWireFrame<HomeViewModel> {
        
    @IBOutlet weak var movies_CollectionView: UICollectionView!{
        didSet{
            movies_CollectionView.registerCellNib(cellClass: MovieCell.self)
            movies_CollectionView.contentInset = .init(top: 10, left: 0, bottom: 35, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    override func bind(viewModel: HomeViewModel) {
        handleMovies_CollectionView()
    }
    
    private func handleMovies_CollectionView(){
        // set delegate to self#imageLiteral(resourceName: "simulator_screenshot_00A81A2E-A4E5-49D8-9AF4-8B44EA00B29E.png")
        movies_CollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // bind viewModel banners data to banner_CollectionView
        viewModel.outputs.moviesObservable.bind(to: movies_CollectionView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)){ [weak self](row, model, cell) in
            cell.movieModel = model
        }.disposed(by: disposeBag)
        
        // handle pagination (featch more data)
        movies_CollectionView.rx.prefetchItems.subscribe {[weak self] (indexPaths) in
            self?.viewModel.prefetchRowsAt(indexPaths: indexPaths)
        }.disposed(by: disposeBag)
        
        //handle selected cell
        movies_CollectionView.rx.modelSelected(Movie.self).subscribe { [weak self](movie) in
            self?.coordinator.mainNavigator.navigate(to: .movieDetails(movie: movie), with: .present(animated: false))
        }.disposed(by: disposeBag)


    }
    

    
}
//MARK:- UICollectionViewDelegateFlowLayout + set size for BannerCell to Banner_CollectionView size
extension HomeVC:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    
}
