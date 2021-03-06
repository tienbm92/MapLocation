//
//  ViewController.swift
//  MapLocation
//
//  Created by Bui Minh Tien on 2/14/17.
//  Copyright © 2017 Bui Minh Tien. All rights reserved.
//

import UIKit
import MapKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationManage = CLLocationManager()
    var locationArr:[CustomAnnotation] = [CustomAnnotation]()
    var userArr:[UserInfom] = [UserInfom]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManage.delegate = self
        mapView.delegate = self
        locationManage.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManage.requestWhenInUseAuthorization()
        locationManage.startUpdatingLocation()
        mapView.showsUserLocation = true
        self.addAnnnotationOnMapView()
        
//        let curentLocation = locationManage.location?.coordinate
//        
//        let annotation = CustomAnnotation(title: "Education Framgia", subtitle: "Bui Minh Tien", coordinate: CLLocationCoordinate2D(latitude: (curentLocation?.latitude)!, longitude: (curentLocation?.longitude)!), image: UIImage(named: "01-bull-icon")!)
        
//        mapView.addAnnotation(annotation)
        mapView.addAnnotations(self.locationArr)
        self.addDataInFirebase()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAnnnotationOnMapView() {
        let curentLocation = locationManage.location?.coordinate
        
        let sourceAnnotation = CustomAnnotation(title: "Education Framgia", subtitle: "Bui Minh Tien", coordinate: CLLocationCoordinate2D(latitude: (curentLocation?.latitude)!, longitude: (curentLocation?.longitude)!), image: UIImage(named: "01-bull-icon")!)
        
        self.locationArr.append(sourceAnnotation)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: 21.005297, longitude: 105.802700)
        
        let destinationAnnotation = CustomAnnotation(title: "Education Framgia", subtitle: "Bui Minh Tien", coordinate: destinationLocation, image: UIImage(named: "01-bird-icon")!)
        
        self.locationArr.append(destinationAnnotation)
        
        drawLineTowLocation(sourceLocation: curentLocation!, destination: destinationLocation)
    }
    func drawLineTowLocation(sourceLocation: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        // tao the hien tren ban do
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destination, addressDictionary: nil)
        
        // cap tao do cho the hien
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // tim duong
        
        let directRequest = MKDirectionsRequest()
        directRequest.source = sourceMapItem
        directRequest.destination = destinationMapItem
        directRequest.transportType = .automobile
        
        // ve duong di 
        
        let directions = MKDirections(request: directRequest)
        directions.calculate { (response, error) in
            if error == nil{
                if let route = response?.routes.first{
                    self.mapView.add(route.polyline, level: .aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsetsMake(40, 40, 20, 20), animated: true)
                }
            }else{
                print(error?.localizedDescription ?? "nil")
            }
        }
    }
    func addDataInFirebase() {
        let currentLocation = locationManage.location?.coordinate
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        let myLatitude = "\(currentLocation?.latitude ?? 0)"
        let myLongtitude = "\(currentLocation?.longitude ?? 0)"
        
        let myLocation = UserInfom(name: "Tien", latitude: myLatitude, longtitude: myLongtitude)
        
        self.userArr.append(myLocation)
//        ref.child("TienBM").setValue(userArr as NSArray)
        
        ref.child("TienBM").setValue(self.userArr)
//        ref.child("TienBM").child("Tien").setValue("1123")
        
        
    }

}
extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        let region = MKCoordinateRegion(center: (currentLocation?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        mapView.setRegion(region, animated: true)
        locationManage.stopUpdatingLocation()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let myAnnotation = annotation as? CustomAnnotation{
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation")
            if pinView == nil{
                pinView = MKAnnotationView(annotation: myAnnotation, reuseIdentifier: "CustomAnnotation")
                pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                pinView?.canShowCallout = true
                pinView?.calloutOffset = CGPoint(x: 0, y: 4)
                pinView?.contentMode = .scaleAspectFill
                
            } else{
                pinView?.annotation = annotation
            }
            pinView?.image = myAnnotation.image
            return pinView
        }
    return nil
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
        
    }
}




