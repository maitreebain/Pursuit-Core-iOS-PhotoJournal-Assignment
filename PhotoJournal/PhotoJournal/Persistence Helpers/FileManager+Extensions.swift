//
//  FileManager+Extensions.swift
//  PhotoJournal
//
//  Created by Maitree Bain on 1/26/20.
//  Copyright © 2020 Maitree Bain. All rights reserved.
//

import Foundation

extension FileManager{
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    static func pathToDocumentsDirectory(with filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
    
    
}
