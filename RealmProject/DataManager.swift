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
        if !UserDefaults.standard.bool(forKey: "eck") {
            let shopingList = Tasks()
            shopingList.name = "What to buy"
            
            
            let productToBuy = Task()
            productToBuy.name = "Apple"
            productToBuy.note = "2 kg"
            
            shopingList.tasks.append(productToBuy)
            
            print(shopingList)
            
            let filmsToWatch = Tasks()
            
            filmsToWatch.name = "Films to watch"
            
            let film = Task()
            film.name = "Film"
            film.note = "Hard"
            
            filmsToWatch.tasks.append(film)
            
            print(filmsToWatch)
            
            DispatchQueue.main.async {
                StorageManager.shared.save(filmsToWatch)
                StorageManager.shared.save(shopingList)
                UserDefaults.standard.set(true, forKey: "eck")
                completion()
            }
        }
    }
    
    private init(){}
}
