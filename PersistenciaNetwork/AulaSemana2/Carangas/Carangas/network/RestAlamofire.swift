//
//  RestAlamofire.swift
//  Carangas
//
//  Copyright © 2020 Ivan Costa. All rights reserved.
//

import Alamofire
import Foundation


class RestAlamofire{
    
    
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void){
        Alamofire.request(basePath, method:.get).validate().responseJSON{
            response in
                
                guard response.result.isSuccess else{
                    onError(.noData)
                    return
                }
                guard let data = response.data else{
                    onError(.noData)
                    return
                }
            
                do{
                    let cars = try JSONDecoder().decode([Car].self, from: data)
                    onComplete(cars)
                } catch {
                    onError(.invalidJSON)
                }
        }
    }
    
    
    class func loadBrands(onComplete: @escaping ([Brand]?) -> Void) {
        let urlFipe = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        guard URL(string: urlFipe) != nil else {
            onComplete(nil)
            return
        }
        
        Alamofire.request(urlFipe, method:.get).validate().responseJSON{
            response in
            
            guard response.result.isSuccess else{
                onComplete(nil)
                return
            }
            guard let data = response.data else{
                onComplete(nil)
                return
            }
            
            do {
                let brands = try JSONDecoder().decode([Brand].self, from: data)
                onComplete(brands)
            } catch {
                onComplete(nil)
            }
        }
    }
    

    class func save(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
    
    class func delete(car: Car, onComplete: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
   
    enum RESOperation {
        case save
        case update
        case delete
    }
    
    private class func applyOperation(car: Car, operation: RESOperation , onComplete: @escaping (Bool) -> Void ) {
        let urlString = basePath + "/" + (car._id ?? "")
        guard URL(string: urlString) != nil else {
            onComplete(false)
            return
        }
        
        var type = HTTPMethod.post
        switch operation {
        case .delete:
            type = HTTPMethod.delete
        case .save:
            type = HTTPMethod.post
        case .update:
            type = HTTPMethod.put
        }
        
        let parameters: Parameters = [
            "_id":car._id!,
            "brand": car.brand,
            "gasType": car.gasType,
            "name":car.name,
            "price": car.price
        ]
        
        Alamofire.request(urlString, method: type, parameters: parameters, encoding:  JSONEncoding.default).validate().responseJSON{
            response in
            
            if response.response?.statusCode == 200{
                 onComplete(true)
            }else{
                 onComplete(false)
            }
        }
    }
}
