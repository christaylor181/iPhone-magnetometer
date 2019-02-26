//
//  ViewController.swift
//  magnetometer
//
//  Created by Chris Taylor on 3/20/18.
//  Copyright © 2018 Chris Taylor. All rights reserved.
//

import UIKit
import CoreMotion

@IBDesignable class ViewController: UIViewController {

    @IBOutlet weak var xlabel: UILabel!
    @IBOutlet weak var ylabel: UILabel!
    @IBOutlet weak var zlabel: UILabel!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var aMLabel: UILabel!

    let manager = CMMotionManager()
    let queue = OperationQueue()
    /*Classic permeability constant µ0, also known as the magnetic constant.
      See https://en.wikipedia.org/wiki/Permeability_(electromagnetism) */
    let µ0 = (4*Double.pi)*1e-7

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setLabel(field: CMMagneticField) {
            DispatchQueue.main.async {
            /*The magnetometer gives three vectors in µT. Let's get the values from var field.
              We can get the field strength from the vectors.
              See https://www.gmw.com/technicalnotes/magfield_vectors.html */
            let bField = sqrt((pow(field.x, 2.0)+pow(field.y, 2.0)+pow(field.z, 2.0)))
            //See http://www.magpar.net/static/magpar/doc/html/magconv.html. Check javascript source.
            let aM = bField*1e-6/self.µ0
            self.xlabel.text = String(format: "%.0f", field.x)
            self.ylabel.text = String(format: "%.0f", field.y)
            self.zlabel.text = String(format: "%.0f", field.z)
            self.bLabel.text = String(format: "%.0f", bField)
            self.aMLabel.text = String(format: "%.0f", aM)
            }
        }
        
        if manager.isMagnetometerAvailable {
        manager.magnetometerUpdateInterval = 3.0 //This seems to work well on iPhone 7
            manager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical,
                to: queue, withHandler: {(data: CMDeviceMotion?, error: Error?) in
                if let field = data?.magneticField.field {
                    setLabel(field: field)} //Pass magnetic field object to function. Not pretty, but it works.
        })} else {
            print("I guess there's nothing there")
        }
    }
}
