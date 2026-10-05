use freya::prelude::*;

fn main() {
    // *Start* your app with a window and its root component
    launch(
        LaunchConfig::new()
            // .with_default_font("Plus Jakarta Sans")
            // .with_font(
            //     "Plus Jakarta Sans",
            //     Bytes::from_static(include_bytes!("./PlusJakartaSans.ttf")),
            // )
            .with_window(
                WindowConfig::new(app)
                    .with_title("AzuDM")
            )
    )
}

fn app() -> impl IntoElement {
    // Define a reactive *state*
    let mut count = use_state(|| 0);


    let wallpaper: ImageSource = (
        "wallpaper",
        include_bytes!("./assets/wallpaper.jpg"),
    )
        .into();    


    // Declare the *UI*
    rect()
        .width(Size::fill())
        .height(Size::fill())
        .color(Color::WHITE)
        .center()
        .on_mouse_up(move |_| *count.write() += 1)
        .child(ImageViewer::new(wallpaper)
            .expanded()
            .center()
            .aspect_ratio(AspectRatio::Max)
            .child(
                // .child(format!("Click to increase -> {}", count.read()))
                rect()
                    .cross_align(Alignment::Center)
                    .center()
                    .child(
                        label()
                            .text("25:00")
                            // .width(Size::fill())
                            .font_size(138.0)
                            .font_weight(FontWeight::MEDIUM)
                            .color((255, 255, 255, 0.9))
                            // .text_shadow(TextShadow::new().blur(12.0).color((0, 0, 0, 0.25)))
                            .text_shadow(TextShadow::new(Color::from_argb(64, 0, 0, 0), (0.0, 8.0), 6.0))
                    )
            )
        )
}