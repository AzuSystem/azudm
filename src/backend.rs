
// /// The bridge definition for our QObject
// #[cxx_qt::bridge]
// pub mod qobject {

//     unsafe extern "C++" {
//         include!("cxx-qt-lib/qstring.h");
//         /// An alias to the QString type
//         type QString = cxx_qt_lib::QString;
//     }

//     extern "RustQt" {
//         // The QObject definition
//         // We tell CXX-Qt that we want a QObject class with the name MyObject
//         // based on the Rust struct MyObjectRust.
//         #[qobject]
//         #[qml_element]
//         type DesktopList = super::DesktopListRust;

//         // Declare the invokable methods we want to expose on the QObject
//         #[qinvokable]
//         #[cxx_name = "fetchDesktop"]
//         fn fetch_desktop(self: &DesktopList) -> QString;

//         #[qinvokable]
//         #[cxx_name = "launchEntry"]
//         fn launch_entry(self: &DesktopList, exec: &QString, entry_type: &QString);


//     }
// }

// use core::pin::Pin;
// use cxx_qt_lib::QString;
// use directories::UserDirs;
// use std::fs;
// use freedesktop_icons;
// use freedesktop_desktop_entry::DesktopEntry;
// use serde::Serialize;

// #[derive(Default)]
// pub struct DesktopListRust;

// /// The Rust struct for the QObject
// #[derive(Clone, Serialize)]
// struct DesktopIcon {
//     name: String,
//     entry_type: String,
//     icon: String,
//     path: String,
// }

// impl qobject::DesktopList {
//     pub fn fetch_desktop(&self) -> QString {
//         let mut icons: Vec<DesktopIcon> = Vec::new();

//         if let Some(user_path) = UserDirs::new() {
//             if let Some(desktop_path) = user_path.desktop_dir() {
//                 for entry in fs::read_dir(desktop_path).unwrap() {
//                     let entry = entry.unwrap();
//                     if entry.path().extension().is_some_and(|ext|ext == "desktop") {
//                         let file = DesktopEntry::from_path(entry.path(), None::<&[&str]>).unwrap();

//                         let file_name = file.name(&["en"]).unwrap_or_default().to_string();
//                         let file_icon = freedesktop_icons::lookup(file.icon().unwrap_or_default().to_string().as_str())
//                             .with_size(64)
//                             .find()
//                             .map(|path|path.to_string_lossy().into_owned())
//                             .unwrap_or_else(|| "qrc:/assets/config.svg".to_string());
//                         // let file_exec = file.exec().unwrap_or_default().to_string();

//                         let app = DesktopIcon {
//                             name: file_name,
//                             entry_type: "app".to_string(),
//                             icon: "file://".to_string() + &file_icon,
//                             path: entry.path().to_string_lossy().to_string(),
//                         };

//                         icons.push(app);
//                     }
//                 }
//             }
//         }

//         QString::from(serde_json::to_string(&icons).unwrap())
//     }

//     pub fn launch_entry(&self, file: &QString, entry_type: &QString) {
//         std::process::Command::new("dex")
//             .arg(file.to_string())
//             .spawn()
//             .unwrap();
//     }
// }
