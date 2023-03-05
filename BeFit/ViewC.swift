//
//  ViewC.swift
//  BeFit
//
//  Created by Sahib Anand on 05/03/23.
//

import SwiftUI

struct ViewC: View {
    var body: some View {
        ZStack{
            Color.blue
            
            Image(systemName: "figure.run")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

struct ViewC_Previews: PreviewProvider {
    static var previews: some View {
        ViewC()
    }
}
