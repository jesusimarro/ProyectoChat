//
//  ViewController.swift
//  ProyectoChat
//
//  Created by estech on 3/2/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var mensajes: [[String]] = []
    let iphone = "ac0adf5b470791098fde0bc41a33e199bb177f3ed0091e3a393997feac9788c3"
    let iphone1 = "4a0e14b4280075a7f13625da7ce88aa2158ec1c963dcfaea7ac443d492754b64"
    let iphone4 = "760f3d3615219e792c5a9be57ae663c9989c4addcb5688755230efecb099f7d7"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //Establecer conexión con AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.viewController = self
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        mensajes = UserDefaults.standard.object(forKey: "Array") as! [[String]] //Recuperar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(mensajes, forKey: "Array") //Guardar
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mensajes[indexPath.row][0] == "env" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellmsg1", for: indexPath) as! CeldaEnviados
            cell.enviadoText.text! = mensajes[indexPath.row][1]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellmsg2", for: indexPath) as! CeldaRecibidos
            cell.textoRecibido.text! = mensajes[indexPath.row][1]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensajes.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    @IBAction func sendButtonAction(_ sender: Any) {
        if textField.text != "" {
            let msg = textField.text!
            mensajes.append(["env", msg])
            textField.text = ""
            tableView.reloadData()
            print(mensajes)
            
            let mnsj = msg.replacingOccurrences(of: " ", with: "%20")
            
            let urlString = "https://test3.qastusoft.com.es/JesusSimarro/push.php?TokenPush=\(iphone4)&message=\(mnsj)"
            
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    print(data)
                } else {
                    print ("error")
                }
            }.resume()
        }
    }
    
    
    
    //Eliminar un mensaje
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.delegate = self
        mensajes.remove(at: indexPath.row)
        tableView.reloadData()
        
        print(mensajes)
    }



    // Funciones de teclado
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(mostrarTeclado), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(ocultarTeclado), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func mostrarTeclado(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let seleccionado = view.selectedTextField {
                if seleccionado.frame.origin.y + seleccionado.frame.height > UIScreen.main.bounds.size.height - keyboardSize.height {
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= keyboardSize.height
                    }
                }
            }
        }
    }

    @objc func ocultarTeclado(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}


extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter({ !($0 is UITextField) })
            .reduce((subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }

    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
}
