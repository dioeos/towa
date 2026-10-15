{ ... }:

{
  microvm.interfaces = [
    {
      type = "tap";
      id = "towa-hub-vm";
      mac = "02:00:00:00:00:02";
    }
  ];

  users.users.hub = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTT6h8u0SQCQOpW0N1zPilzhsiCrE2Ls51ORmnlylJs"
    ];
  };

  systemd.network.networks."20-hub" = {
    matchConfig.MACAddress = "02:00:00:00:00:02";
    address = [ "192.168.100.11/24" ];

    networkConfig.DHCP = "no";
    networkConfig.Gateway = "192.168.100.1";
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
