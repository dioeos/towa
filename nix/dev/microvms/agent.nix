{
  environment.shellAliases = {
    run-busybox = "podman run -d --name example --label towa.name=Busybox --label towa.url=http://example.test docker.io/library/busybox:latest sleep infinity";
  };

  microvm.interfaces = [
    {
      type = "tap";
      id = "towa-agent-vm";
      mac = "02:00:00:00:00:01";
    }
  ];

  virtualisation.podman.enable = true;

  users.users.agent = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTT6h8u0SQCQOpW0N1zPilzhsiCrE2Ls51ORmnlylJs"
    ];
  };

  systemd.network.networks."20-agent" = {
    matchConfig.MACAddress = "02:00:00:00:00:01";
    address = [ "192.168.100.12/24" ];

    networkConfig.DHCP = "no";
    networkConfig.Gateway = "192.168.100.1";
  };
  networking.firewall.allowedTCPPorts = [ 50051 ];
}
