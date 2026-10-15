use hypertext::prelude::*;

pub fn layout(title: &str, content: impl Renderable) -> impl Renderable {
    rsx! {
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="utf-8">
                <meta charset="viewport" content="width=device-width, initial-scale=1">
                <title>(title)</title>
                <script src="/static/htmx.min.js"></script>
            </head>
            <body>
                (content)
            </body>
        </html>
    }
}
