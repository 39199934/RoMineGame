//
//  GirdItemView.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/13.
//

import SwiftUI

struct GirdItemView: View {
    @EnvironmentObject var viewModel: GirdsViewModel
    @Binding var girdItem: GirdItemModel
    var body: some View {
        girdItem
            .onTapGesture {
                viewModel.onClicked(at: girdItem)
            }
            .onLongPressGesture {
                viewModel.onLongTag(at: girdItem)
            }
            
            
            
//            .background(.red)
    }
}

struct GirdItemView_Previews: PreviewProvider {
    static var previews: some View {
        GirdItemView(girdItem: .constant( GirdItemModel(x: 1, y: 1,  id: UUID(), isHaveMine: false, girdStatus: GirdStatus.open(openStatus: .bombed))))
    }
}
