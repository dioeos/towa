use towa_proto::v1::{RegisterNodeRequest, RegisterNodeResponse, hub_service_server::HubService};

pub struct Hub {}

#[tonic::async_trait]
impl HubService for Hub {
    async fn register_node(
        &self,
        _request: tonic::Request<RegisterNodeRequest>,
    ) -> Result<tonic::Response<RegisterNodeResponse>, tonic::Status> {
        // 1) Authenticate credentias of the registration (check gRPC credentials, not fingerprint)
        // 2) Once authenticated, insert node identity into database
        // 3) Response with ack
        todo!()
    }
}
