{ ... }:

{
  system.stateVersion = "26.05";

  environment.extraInit = ''
    export CARGO_TARGET_DIR="$HOME/target/towa"
  '';

  networking.nameservers = [ "1.1.1.1" ];

  microvm = {
    hypervisor = "cloud-hypervisor";
    vcpu = 8;
    mem = 4096;
    virtiofsd.group = "kvm";

    shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        readOnly = true;
      }
      {
        proto = "virtiofs";
        tag = "towa-src";
        source = "/home/dio/projects/towa/";
        mountPoint = "/workspace/towa";
        readOnly = true;
      }
    ];

    volumes = [
      {
        image = "ssh-host-keys.img";
        mountPoint = "/etc/ssh/host-keys";
        size = 64;
      }
    ];
  };

  systemd.network.enable = true;

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/host-keys/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

  };
}
