//
//  DataManager.swift
//  RealmProject
//
//  Created by Сергей Веретенников on 03/05/2022.
//

import Foundation


class DataManager {
    static var shared = DataManager()
    
    func createSomething(completion: @escaping() -> ()) {
        if !UserDefaults.standard.bool(forKey: "heck") {
            let shopingList = Tasks()
            shopingList.name = "What to buy"
            
            
            let productToBuy = Task()
            productToBuy.name = "Apple"
            productToBuy.note = "2 kg"
            
            shopingList.tasks.append(productToBuy)
            
            print(shopingList)
            
            let filmsToWatch = Tasks()
            
            let film = Task()
            film.name = "Film"
            film.note = "Hard"
            
            filmsToWatch.tasks.append(film)
            
            DispatchQueue.main.async {
                StorageManager.shared.save(filmsToWatch)
                StorageManager.shared.save(shopingList)
                UserDefaults.standard.set(true, forKey: "heck")
                completion()
            }
        }
    }
    
    private init(){}
}
