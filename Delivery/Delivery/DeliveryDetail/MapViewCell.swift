//
//  MapViewCell.swift
//  Delivery
//
//  Created by Joe on 17/09/18.
//  Copyright © 2018 Jyothish. All rights reserved.
//

import Foundation
import MapKit

class MapViewCell : UICollectionViewCell {

    var delivery : Delivery? {
        didSet {
            if let location = self.delivery?.location {
                let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                let regionRadius: CLLocationDistance = 2000
                let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                          latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                let annotation = MKPointAnnotation()
                let centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude:location.longitude)
                annotation.coordinate = centerCoordinate
                annotation.title = delivery?.location?.address
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    lazy var mapView : MKMapView = {
       let mapView = MKMapView()
        mapView.showsTraffic = true
        mapView.isZoomEnabled = true
       return mapView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(mapView)
        mapView.anchor(top: (anchor: self.topAnchor, constant: 0.0),
                       leading: (anchor: self.leadingAnchor, constant: 0.0),
                       bottom: nil,
                       trailing: (anchor: self.trailingAnchor, constant: 0.0))
        mapView.heightAnchor.activateConstraint(equalToConstant: 300)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
