//
//  CroppingImageProtocol.swift
//  J.Todo
//
//  Created by JinYoung Lee on 24/07/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

protocol CroppingImageProtocol {
    func onCompleteWithImage(_ image: UIImage)
    func onFail()
}
