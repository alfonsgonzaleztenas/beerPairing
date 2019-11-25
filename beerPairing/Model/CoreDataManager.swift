//
//  CoreDataManager.swift
//  beerPairing
//
//  Created by iMac on 23/11/2019.
//  Copyright © 2019 Alfons Gonzalez Tenas. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "beerData")
        setupDatabase()
    }
    
    /// Inicialitzem la BD
    private func setupDatabase() {
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print ("Error loading database \(description) - \(error)")
            }
        }
        print ("Database loaded")
    }
    
    /// Guardem el context actual
    func saveContext() {
        let context = container.viewContext
        do {
            try context.save()
            print ("Context saved")
        } catch  {
            print ("Error")
        }
    }
    
    /// Insertem el menjar buscar
    /// - Parameter food: Menjar que hem buscat i volem guardar
    func insertSearch (food : String){
        let context =  container.viewContext
        let search = Search(context:context)
        search.food = food

    }
    
    /// Obtenim si ja hem guardat una cervesa amb anterioritat
    /// - Parameter name: Nom de la cervesa que volem comprovar
    func getBeer (name : String) -> Beer? {
        let fetchRequest = NSFetchRequest<Beer>(entityName: "Beer")
        let predicate = NSPredicate(format: "name ==[c] %@", name)
        fetchRequest.predicate = predicate
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result.count == 1 ? result[0] : nil
        } catch{
            print ("Error obtain food")
        }
        return nil
    }
    
    /// Creem l'objecte Beer i els seus menjars associats amb el diccionari informat
    /// - Parameter dictionary: Valors de l'objecte cervesa que volem inserir
    func createBeerEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
       
        let context =  container.viewContext
        if let beer = getBeer(name: (dictionary["name"] as? String)!)  {return beer}

        if let beerEntity = NSEntityDescription.insertNewObject(forEntityName: "Beer", into: context) as? Beer {
            beerEntity.name = dictionary["name"] as? String
            beerEntity.abv = (dictionary["abv"] as? Double)!
            beerEntity.tagline = dictionary["tagline"] as? String
            beerEntity.beerDescription = dictionary["description"] as? String
            beerEntity.image_url = dictionary["image_url"] as? String

            if let foodArray = dictionary["food_pairing"] as? [String] {
                for food in foodArray{
                    if let foodEntity = NSEntityDescription.insertNewObject(forEntityName: "Food", into: context) as? Food {
                        foodEntity.food = food
                        foodEntity.beerName = beerEntity.name
                        foodEntity.belongsTo = beerEntity
                    }
                }
            }
            print("Beer added \(beerEntity.name ?? "")")
            return beerEntity
        }

        return nil
    }
    
    /// Eliminem totes les Beer
    func removeBeers() {
        let context =  container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Beer")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print ("Remove beers error \(error.description)")
        }
    }

    /// Retornem un array de Beer amb tot el que tenim ordenat per ABV asc
    func fetchBeers() -> [Beer] {
        let fetchRequest : NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "abv", ascending: true)]
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            
            return result
        } catch{
            print ("Error obtain beers")
        }
        return []
    }
    
    /// Retornem un array de Food
    func fetchFood() -> [Food] {
        let fetchRequest : NSFetchRequest<Food> = Food.fetchRequest()
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch{
            print ("Error obtain beers")
        }
        return []
    }
    
    /// Retornem un array de Beer que estiguin relacionats amb el menjar informat
    /// - Parameter foodToSearch: Menjar a relacionar
    func fetchBeersWithFood(foodToSearch : String? = "") -> [Beer] {
        let fetchRequest = NSFetchRequest<Beer>(entityName: "Beer")
        let predicate = NSPredicate(format: "ANY food.food CONTAINS[c] %@", foodToSearch!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "abv", ascending: true)]
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch{
            print ("Error obtain food")
        }
        return []
    }
    
    /// Validem si un menjar ja està inserit
    /// - Parameter foodToSearch: Menjar a comprovar
    func fetchSearchFood(foodToSearch : String? = "") -> Bool {
        let fetchRequest = NSFetchRequest<Search>(entityName: "Search")
        let predicate = NSPredicate(format: "food ==[c] %@", foodToSearch!)
        fetchRequest.predicate = predicate
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result.count > 0
        } catch{
            print ("Error obtain food")
        }
        return false
    }
    
    
}


