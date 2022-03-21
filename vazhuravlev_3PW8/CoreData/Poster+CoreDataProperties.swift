//
//  Poster+CoreDataProperties.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 22.03.2022.
//
//

import Foundation
import CoreData


extension Poster {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poster> {
        return NSFetchRequest<Poster>(entityName: "Poster")
    }

    @NSManaged public var image: Data?
    @NSManaged public var movieId: Int32

}

extension Poster : Identifiable {

}
