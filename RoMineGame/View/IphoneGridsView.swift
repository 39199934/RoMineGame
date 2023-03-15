//
//  IphoneGridsView.swift
//  RoMineGame
//
//  Created by rolodestar on 2023/3/15.
//
#if os(iOS)
import SwiftUI

struct IphoneGridsView: View {
    @ObservedObject var viewModel = GirdsViewModel()
   
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack(spacing:20){
                Text("扫雷游戏")
                    .font(.title)
                Button("开始游戏"){
                    viewModel.path.append(0)
                }
                Button("设置重启"){
                    viewModel.path.append(1)
                }
                .navigationDestination(for: Int.self) { value in
                    switch value{
                    case 0:
                        VStack{
                            StatusView(viewModel: self.viewModel)
                            GirdsView(viewModel: self.viewModel)
                            Spacer()
                        }
                    case 1:
                        GirdsSettingView(viewModel: self.viewModel)
                    default:
                        Text("unknow")
                    }
                }
            }
        }
    }
}

struct IphoneGridsView_Previews: PreviewProvider {
    static var previews: some View {
        IphoneGridsView()
    }
}
#endif
