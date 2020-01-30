//
//  PersistenceHelper.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import Foundation

enum DataPersistenceError: Error {
    case savingError(Error)
    case fileDoesNotExist(String)
    case noData
    case decodingError(Error)
    case deletingError(Error)
}

class PersistenceHelper {
    
    private var images = [ImageItem]()
    
    private var filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    private func save() throws {
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        do {
            let data = try PropertyListEncoder().encode(images)
            try data.write(to: url, options: .atomic)
            
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    
    public func create(item: ImageItem) throws {
        images.append(item)
        
        do {
            try save()
        } catch {
            throw DataPersistenceError.savingError(error)
        }
    }
    
    @discardableResult
    public func update(_ oldItem: ImageItem, _ newItem: ImageItem) -> Bool {
        if let index = images.firstIndex(of: oldItem){
            let result = update(newItem, index)
            return result
        }
        return false
    }
    
    @discardableResult
    public func update(_ item: ImageItem, _ index: Int) -> Bool{
        images[index] = item
        do {
            try save()
            return true
        } catch {
            return false
        }
    }
    
    public func loadImage() throws -> [ImageItem] {
        
        let url = FileManager.pathToDocumentsDirectory(with: filename)
        
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    images = try PropertyListDecoder().decode([ImageItem].self, from: data)
                } catch {
                    throw DataPersistenceError.decodingError(error)
                }
            } else {
                throw DataPersistenceError.noData
            }
        }
        else {
            throw DataPersistenceError.fileDoesNotExist(filename)
        }
        return images
    }
    
    public func delete(event index: Int) throws {
        images.remove(at: index)
        
        do {
            try save()
        } catch {
            throw DataPersistenceError.deletingError(error)
        }
    }
}
