//
//  GirdsSettingView.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/15.
//

import SwiftUI

struct GirdsSettingView: View {
    @ObservedObject var viewModel: GirdsViewModel
    @State var columns = ""
    @State var rows = ""
    @State var mines = ""
    var body: some View {
        VStack{
            HStack{
                Text("列数   ")
                TextField("列数", text: $columns)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack{
                Text("行数   ")
                TextField("行数", text: $rows)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack{
                Text("地雷数")
                TextField("地雷数", text: $mines)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.onAppear{
                self.columns = "\(viewModel.columns)"
                self.rows = "\(viewModel.rows)"
                self.mines   = "\(viewModel.minesNumber)"
            }
            Button("restart"){
                viewModel.columns = Int(columns) ?? 10
                viewModel.rows = Int(rows) ?? 10
                viewModel.minesNumber = Int(mines) ?? 10
                viewModel.restartGame()
                viewModel.path.append(0)
            }
            Spacer()
        }.padding(20)
    }
}

struct GirdsSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GirdsSettingView(viewModel: GirdsViewModel())
    }
}
