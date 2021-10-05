//
//  APIManager.swift
//
//
//

import Foundation
import Alamofire
import RxSwift

struct ResponseModel<T: Decodable>: Decodable {
    let response: T?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case response = "results"
        case message = "message"
    }
}
protocol AppServiceClientProtocol {
    
    func performRequest<T>(_ object: T.Type, serviceGateway: Gateway)-> Observable<ResponseModel<T>> where T:Decodable
    func cancelPreviousNetworkCall()
}

class AppServiceClient: AppServiceClientProtocol {
    func performRequest<T>(_ object: T.Type, serviceGateway: Gateway) -> Observable<ResponseModel<T>> where T : Decodable {
        return Observable.create { (observer) -> Disposable in
            AF.request(serviceGateway)
                .validate()
                .responseJSON{ (response) in
                    switch response.result{
                    case .success:
                        do {
                            let responseModel = try JSONDecoder().decode(ResponseModel<T>.self, from: response.data!)
                            observer.onNext(responseModel)
                        } catch let error{
                            observer.onError(error)
                        }
                    case let .failure(error):
                        if let statusCode = response.response?.statusCode{
                            switch ServiceError.init(rawValue: statusCode){
                            case .badRequest:
                                do {
                                    let failerResponseModel = try JSONDecoder().decode(ResponseModel<T>.self, from: response.data!)
                                    observer.onError(AppError(message: failerResponseModel.message ?? ""))
                                    return
                                } catch let error{
                                    observer.onError(error)
                                    return
                                }
                            default:
                                if let reason = ServiceError(rawValue: statusCode){
                                    observer.onError(reason)
                                    return
                                }
                            }
                        }
                        observer.onError(error)
                    }
                }.resume()
            return Disposables.create()
        }
    }
    
    
    func cancelPreviousNetworkCall(){
        AF.session.getAllTasks(completionHandler: {$0.forEach{$0.cancel()}})
    }
}
