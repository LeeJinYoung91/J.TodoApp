//
//  TodoDetailViewController.swift
//  J.Todo
//
//  Created by JinYoung Lee on 24/07/2019.
//  Copyright © 2019 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class TodoDetailViewController: UIViewController {
    private var dataModel: TodoDataModel?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var registerDateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    private var modelDisposable: Disposable?
    
    func setUpWithModel(_ model: TodoDataModel) {
        dataModel = model
    }
    
    override func viewDidLoad() {
        setUpNavigationBar()
        setImageView()
        
        modelDisposable = dataModel?.ModelData.subscribe({ (data) in
            self.titleTextField.text = data.element?.title
            self.contentTextView.text = data.element?.content
            self.registerDateLabel.text = data.element?.getRegistedDate()
            if let imageData = data.element?.imageData {
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.image = UIImage(data: imageData)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        modelDisposable?.dispose()
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = dataModel?.ModelData.value.title
        let rightNavigationItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(updateData))
        navigationItem.rightBarButtonItem = rightNavigationItem
        titleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        titleTextField.isUserInteractionEnabled = false
        contentTextView.isUserInteractionEnabled = false
        imageView.isUserInteractionEnabled = false
    }
    
    private func setImageView() {
        imageView.contentMode = .center
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateImage)))
    }
    
    @objc private func updateData() {
        let rightNavigationItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(finishUpdate))
        navigationItem.rightBarButtonItem = rightNavigationItem
        titleTextField.isUserInteractionEnabled = true
        contentTextView.isUserInteractionEnabled = true
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func finishUpdate() {
        dataModel?.updateData(data: TodoDataModel.TodoData(title: titleTextField.text, content: contentTextView.text, registedDate: dataModel?.registedDate))
        setUpNavigationBar()
        Util.createToastMessage(title: "Update", message: "Update Success")
    }
    
    @objc private func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK :- ImagePicker Delegate
extension TodoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let cropView = Bundle.main.loadNibNamed("PhotoCropView", owner: self, options: nil)?.first as? PhotoCropView {
                cropView.ProcessListener = self
                cropView.setImageInfo(info)
                UIApplication.shared.keyWindow?.addSubview(cropView)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK :- CropImage Delegate Protocol
extension TodoDetailViewController: CroppingImageProtocol {
    func onCompleteWithImage(_ image: UIImage) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        dataModel?.ImageData = image.pngData()
    }
    
    func onFail() {
        imageView.contentMode = .center
        imageView.image = UIImage(named: "picture")
    }
}
