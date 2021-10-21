//
//  MovieViewController.swift
//  SeSSAC_TrendMediaPrj
//
//  Created by ChanhoHwang on 2021/10/20.
//

import UIKit
import CoreLocation
import CoreLocationUI
import MapKit

class MovieViewController: UIViewController {
    
    static let identifier = "MovieViewController"
    
    let locationManager = CLLocationManager()
    let mapAnno = MapManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        self.setAnnotation(title: "전체보기")
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func removeAnnotation() {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
    }
    
    func setAnnotation(title: String) {
        if title == "전체보기" {
            self.mapAnno.mapAnnotations.forEach {
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                annotation.title = $0.type
                annotation.coordinate = coordinate
                
                self.mapView.addAnnotation(annotation)
            }
        } else {
            for i in 0 ..< self.mapAnno.mapAnnotations.count {
                if self.mapAnno.mapAnnotations[i].type  == title {
                    let annotation = MKPointAnnotation()
                    let coordinate = CLLocationCoordinate2D(latitude: self.mapAnno.mapAnnotations[i].latitude, longitude: self.mapAnno.mapAnnotations[i].longitude)
                    annotation.title = self.mapAnno.mapAnnotations[i].type
                    annotation.coordinate = coordinate
                    
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
    }
    
    @IBAction func circleButtonPressed(_ sender: UIButton) {
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let megabox = UIAlertAction(title: "메가박스", style: .default) {_ in
            self.removeAnnotation()
            self.setAnnotation(title: "메가박스")
        }
        
        let lotte = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            self.removeAnnotation()
            self.setAnnotation(title: "롯데시네마")
        }
        
        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
            self.removeAnnotation()
            self.setAnnotation(title: "CGV")
        }
        
        let filterFree = UIAlertAction(title: "전체보기", style: .default) { _ in
            self.removeAnnotation()
            self.setAnnotation(title: "전체보기")
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [megabox, lotte, cgv, filterFree, cancel].forEach { actionAlert.addAction($0) }
        
        present(actionAlert, animated: true, completion: nil)
    }
    
}

extension MovieViewController: CLLocationManagerDelegate {
    
    // iOS 버전에 따른 분기 처리와 iOS 위치 서비스 여부 확인
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus // iOS14 이상
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus() // iOS14 미만
        }
        
        //iOS 위치 서비스 확인
        if CLLocationManager.locationServicesEnabled() {
            // 권한 상태 확인 및 권한 요청 가능(8번 메서드 실행)
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("iOS 위치 서비스를 켜주세요")
        }
    }
    
    // 사용자의 권한 상태 확인(UDF. 사용자 정의 함수로 프로토콜 내 메서드가 아님!!!!)
    // 사용자의 위치권한 여부 확인 (단, iOS 위치 서비스가 가능한 지 확인)
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            locationManager.startUpdatingLocation() // 위치 접근 시작
            print("notDetermined")
        case .restricted, .denied:
            print("DENIED")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("Always")
        case .authorizedAlways:
            locationManager.startUpdatingLocation() // 위치 접근 시작
            print("authorizedAlways")
        @unknown default:
            print("Default")
        }
        
        if #available(iOS 14.0, *) {
            // 정확도 체크: 정확도 감소가 되어 있을경우, 배터리 up
            let accurancyState = locationManager.accuracyAuthorization
            
            switch accurancyState {
            case .fullAccuracy:
                print("FULL")
            case .reducedAccuracy:
                print("REDUCE")
            @unknown default:
                print("DEFAULT")
            }
        }
    }
    
    // 사용자가 위치 허용을 한 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print("??? : \(locations)")
        
        if let coordinate = locations.last?.coordinate {
            print("Location Allowed")
            let annotation = MKPointAnnotation()
            
            annotation.title = "현재 위치"
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            findAddress(lat: coordinate.latitude, long: coordinate.longitude)
            
            // 10.(중요)
            locationManager.stopUpdatingLocation()
            
        } else {
            print("Location CanNot Find")
            setLocation(latitude: 37.56649078671157, longitude: 126.97798268981745)
            findAddress(lat: 37.56649078671157, long: 126.97798268981745)
        }
    }
    
    // 위치 접근이 실패했을 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // IOS14 미만: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 떄 대리자에게 승인 상태를 알려줌.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }
    
    // IOS14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    // 주소 찾기
    func findAddress(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr") //원하는 언어의 나라 코드를 넣어주시면 됩니다.
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name {
                    print(name)
                    self.navigationItem.title = name
                } //전체 주소
            }
        })
    }
}

extension MovieViewController: MKMapViewDelegate {
    // 맵 어노테이션 클릭 시 이벤트 핸들링
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Museum")
        
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Museum")
            annotationView?.image = UIImage(named: "Japan_small_icon.png")
            annotationView?.canShowCallout = false
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}


