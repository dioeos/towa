mod grpc;

use anyhow::Context;
use tracing_subscriber::{EnvFilter, fmt};

pub const BIND_ADDR: &str = "127.0.0.1:50051";

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let format = fmt::format().with_level(true).with_target(true).compact();

    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("info")),
        )
        .event_format(format)
        .init();

    let hub_url = std::env::var_os("HUB_URL").context("missing HUB_URL environment variable");

    let addr = std::env::var("BIND_ADDR")
        .unwrap_or_else(|_| BIND_ADDR.to_owned())
        .parse()?;

    Ok(())
}
