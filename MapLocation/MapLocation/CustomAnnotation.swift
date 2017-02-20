//
//  CustomAnnotation.swift
//  MapLocation
//
//  Created by Bui Minh Tien on 2/14/17.
//  Copyright © 2017 Bui Minh Tien. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D, image:UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        
        super.init()
    }
    
    
    
}
