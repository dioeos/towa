use crate::layout::layout;
use axum::response::Html;
use hypertext::prelude::*;


pub async fn index_handler() -> Html<String> {
    Html(
        layout("Dashboard",
            rsx! {
                <h1>Dashboard</h1>
            }
        )
        .render()
        .into_inner()
    )
}
