/*import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    //location manager für kompass
    var locationManager: CLLocationManager!
    
    //motion manager für accelerometer
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.startUpdatingHeading() // Start compass updates
        
        //funktion der funktion accelerometer updates
        startAccelerometerUpdates()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.magneticHeading // Heading in degrees
        let direction = convertDegreesToCardinalDirection(degrees: heading)
        print("Heading: \(heading)°, Direction: \(direction)") // himmelsrichtung wird ausgeprintet
    }

    // konvertiren von gradzahl zu himmelsrichtung (N/O/S/W)
    func convertDegreesToCardinalDirection(degrees: CLLocationDirection) -> String {
        let directions = ["N", "NO", "O", "SO", "S", "SW", "W", "NW", "N"]
        let index = Int((degrees + 22.5)/45.0) & 7
        return directions[index]
    }
    
    // Error handling for location manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating heading: \(error.localizedDescription)")
    }
    
    
    func startAccelerometerUpdates() { //funktion um werte des accelerometers abzurufen
        motionManager.accelerometerUpdateInterval = 0.1  // Update every 0.1 seconds

        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
            guard let self = self, let accelData = data else { return }

            DispatchQueue.main.async {
                let yValue = accelData.acceleration.y
                print("Y: \(yValue)") // accel y wert printen
            }
        }
    }
    
}*/

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    //location manager für kompass
    var locationManager: CLLocationManager!
    
    //motion manager für accelerometer
    var motionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Request permission
        locationManager.startUpdatingHeading() // Start compass updates
        
        //funktion der funktion accelerometer updates
        startAccelerometerUpdates()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.magneticHeading // Heading in degrees
        let direction = convertDegreesToCardinalDirection(degrees: heading)
        //print("Heading: \(heading)°, Direction: \(direction)") // himmelsrichtung wird ausgeprintet
    }

    // konvertiren von gradzahl zu himmelsrichtung (N/O/S/W)
    func convertDegreesToCardinalDirection(degrees: CLLocationDirection) -> String {
        let directions = ["N", "NO", "O", "SO", "S", "SW", "W", "NW", "N"]
        let index = Int((degrees + 22.5)/45.0) & 7
        return directions[index]
    }
    
    // Error handling for location manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating heading: \(error.localizedDescription)")
    }
    
    
    func startAccelerometerUpdates() { //funktion um werte des accelerometers abzurufen
        motionManager.accelerometerUpdateInterval = 0.1  // Update every 0.1 seconds

        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
            guard let self = self, let accelData = data else { return }

            DispatchQueue.main.async {
                let yValue = accelData.acceleration.y * 90
                //print("Y: \(yValue)") // accel y wert mal 90 printen
                self.sendDataToServer(yValue: yValue)
            }
        }
    }

    func sendDataToServer(yValue: Double) {
        // Hier wird Ihre URL und die Anfrage konfiguriert und gesendet
        let baseUrl = "https://www.moritzstrobel.design/test_server/index.html"
        let queryItems = [URLQueryItem(name: "neigung", value: String(yValue))]
        var urlComps = URLComponents(string: baseUrl)!
        urlComps.queryItems = queryItems

        guard let url = urlComps.url else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending request: \(error)")
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response from server: \(dataString)")
            }
        }

        task.resume()
    }
}
