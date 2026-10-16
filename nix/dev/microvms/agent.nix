{ id }:
{ ... }:

let
  name = "agent-${toString id}";
  libId = if id < 10 then "0{toString id}" else toString id;
  mac = "02:00:00:00:01:${libId}";
in
{
  environment.shellAliases = {
    run-busybox = "podman run -d --name example --label towa.name=Busybox --label towa.url=http://example.test docker.io/library/busybox:latest sleep infinity";
  };

  networking.hostName = name;

  microvm.interfaces = [
    {
      type = "tap";
      id = "towa-${name}";
      inherit mac;
    }
  ];

  virtualisation.podman.enable = true;

  users.users.${name} = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTT6h8u0SQCQOpW0N1zPilzhsiCrE2Ls51ORmnlylJs"
    ];
  };

  systemd.network.networks."20-agent" = {
    matchConfig.MACAddress = "02:00:00:00:00:01";
    address = [ "192.168.100.${toString (20 + id)}/24" ];

    networkConfig.DHCP = "no";
    networkConfig.Gateway = "192.168.100.1";
  };
  networking.firewall.allowedTCPPorts = [ 50051 ];
}
