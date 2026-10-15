use axum::{Router, routing::get};
use towa_web::handlers;
use tower_http::services::ServeDir;
use tracing::info;
use tracing_subscriber::{EnvFilter, fmt};

pub const TOWA_HUB_ADDR: &str = "127.0.0.1:3000";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let format = fmt::format().with_level(true).with_target(true).compact();

    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("trace")),
        )
        .event_format(format)
        .init();

    let listener = tokio::net::TcpListener::bind(TOWA_HUB_ADDR).await.unwrap();

    info!(?TOWA_HUB_ADDR, "bind address");

    let app = Router::new()
        .route("/", get(handlers::index_handler))
        .nest_service(
            "/static",
            ServeDir::new(concat!(env!("CARGO_MANIFEST_DIR"), "/static")),
        );

    axum::serve(listener, app).await.unwrap();

    Ok(())
}
