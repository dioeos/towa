fn main() {}
// use std::path::{Path, PathBuf};
//
// fn main() {
//     let proto_root = PathBuf::from("proto");
//     let protos = find_protos(&proto_root);
//
//     println!("cargo:rerun-if-changed=build.rs");
//     println!("cargo:rerun-if-changed=proto");
//
//     tonic_prost_build::configure()
//         .compile_protos(&protos, &[proto_root])
//         .unwrap();
// }
//
// fn find_protos(dir: &Path) -> Vec<PathBuf> {
//     let mut protos = Vec::new();
//
//     for entry in std::fs::read_dir(dir).unwrap() {
//         let path = entry.unwrap().path();
//
//         if path.is_dir() {
//             protos.extend(find_protos(&path));
//         } else if path.extension().is_some_and(|ext| ext == "proto") {
//             protos.push(path);
//         }
//     }
//     protos
// }
