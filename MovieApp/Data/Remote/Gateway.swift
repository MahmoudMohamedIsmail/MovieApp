//
//  APIRouter.swift
//
//

import Foundation
import Alamofire

enum Gateway: URLRequestConvertible{
    
    //MARK:- Home
    case getPopularMovies(page:Int)

    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String{
        
        switch self {
        //MARK:- General
        case .getPopularMovies:
            return "movie/popular"
          
        }
        
       
    }
    
    
    var parameters: Parameters?{
        
        switch self {
        //MARK:- General
        case let .getPopularMovies(page):
            return ["page":page, "api_key":Constants.api_Key]
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
        
    }
    
    var encoding: ParameterEncoding{
        switch self{
        default: return URLEncoding.queryString
        }
    }
    
   
    func asURLRequest() throws -> URLRequest {
        
        let url = try Constants.baseURL.asURL().appendingPathComponent(self.path)
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        if let headers = headers {
            headers.forEach{
                request.setValue($0.value, forHTTPHeaderField: $0.name)
            }
        }
        if let parameters = parameters {
            return try encoding.encode(request, with: parameters)
        }
        return request
    }
    
    
}
