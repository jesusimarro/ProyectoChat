//
//  CeldaEnviados.swift
//  ProyectoChat
//
//  Created by estech on 9/2/23.
//

import UIKit

class CeldaEnviados: UITableViewCell {

    @IBOutlet weak var enviadoText: UILabel!
    @IBOutlet weak var enviadoView: UIView!
    @IBOutlet weak var enviadoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        enviadoView.layer.cornerRadius = 20
        
        enviadoImg.layer.borderWidth = 1
        enviadoImg.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
