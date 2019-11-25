//
//  MapUI.swift
//  
//
//  Created by 이재성 on 2019/11/25.
//

import UIKit
import MapKit

public protocol MapUIImplementable {
    /**
     ```Swift
     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
         guard let place = view.annotation as? Place else { return }
         
         performSegue(withIdentifier: "myPlaceDetail", sender: place)
     }
     ```
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView)
    
    /**
    ```Swift
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.updateAnnotation()
    }
     
    func updateAnnotation() {
        MapUI.updateAnnotation(of: places, on: mapView)
    }
    ```
    */
    func updateAnnotation()
}

public protocol MapUINavigatable {
    /**
     ```Swift
     func drawRoute(from:to:named:on:)
     ```
     */
    func drawRoute()
    
    /**
     ```Swift
     func configureRoute(_:) -> MKOverlayRenderer
     ```
     */
    func configureRoute()
}


/**
 Before use this class, you need to declare `MKMapView` as a variable first.
 */
public class MapUI {
    // MARK: - CLLocationManagerDelegate
    // TODO: Required??
    public static func setupMapView(_ mapView: MKMapView, on viewController: UIViewController & MKMapViewDelegate, isShowUserLocation: Bool) {
        mapView.delegate = viewController
        mapView.showsUserLocation = isShowUserLocation
    }
    
    
    public static func configureLocationManager(_ locationManager: CLLocationManager, on viewController: CLLocationManagerDelegate) {
        locationManager.delegate = viewController
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public static func locationManger(_ locationManager: CLLocationManager, updated locations: [CLLocation], on mapView: MKMapView) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1 / 500, longitudeDelta: 1 / 500))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}


extension MapUI {
    
    public func annotationView(for annotation: MKAnnotation, identifier: String, pinImage: UIImage) -> MKAnnotationView {
        let identifier = "place"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        
        annotationView.image = pinImage
        
        annotationView.centerOffset = CGPoint(x: 0, y: -27.0)
        
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: 0, y: -10)
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        annotationView.tintColor = PlaceUI.color(.purple)
        
        return annotationView
    }
    
    public func updateAnnotation(of places: [MKAnnotation], on mapView: MKMapView) {
        for i in 0 ..< places.count {
            mapView.addAnnotation(places[i])
        }
    }
}


// Draw Route
@available(iOS 10.0, *)
extension MapUI {
    public func drawRoute(from startLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, named title: String, on mapView: MKMapView) {
        let startPlacemark = MKPlacemark(coordinate: startLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.title = "I am here"
        
        if let location = startPlacemark.location {
            startAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = title
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        mapView.showAnnotations([startAnnotation, destinationAnnotation], animated: true)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = startMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    public func configureRoute(_ overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = PlaceUI.color(.purple)
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
