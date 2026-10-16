{
  description = "Towa Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllPlatforms = f: nixpkgs.lib.genAttrs platforms (system: f nixpkgs.legacyPackages.${system});

      mkDevVM =
        system:
        (
          extraModules:
          nixpkgs.lib.nixosSystem {
            inherit system;

            modules = [
              inputs.microvm.nixosModules.microvm
              ./nix/dev/microvms/base.nix
            ]
            ++ extraModules;
          }
        );

      mkTowaPackages = pkgs: {
        hub = pkgs.rustPlatform.buildRustPackage {
          pname = "towa-hub";
          version = "0.1.0";

          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;

          cargoBuildFlags = [
            "-p"
            "towa-hub"
          ];

          nativeBuildInputs = [ pkgs.protobuf ];
        };
      };

      packages = forAllPlatforms (pkgs: mkTowaPackages pkgs);
    in
    {
      inherit packages;

      nixosConfigurations =
        builtins.listToAttrs (
          map
            (id: {
              name = "agent-${toString id}";
              value = mkDevVM "x86_64-linux" [
                (import ./nix/dev/microvms/agent.nix { inherit id; })
              ];
            })
            [
              1
              2
              3
              4
              5
            ]
        )
        // {
          hub-vm = mkDevVM "x86_64-linux" [
            ./nix/dev/microvms/hub.nix

            (
              { pkgs, lib, ... }:
              let
                packages = self.packages.${pkgs.stdenv.hostPlatform.system};
                apps = [
                  packages.hub
                ];
              in
              {
                environment.systemPackages = lib.unique (
                  apps
                  ++ [ pkgs.stdenv.cc ]
                  ++ lib.concatMap (package: package.nativeBuildInputs ++ package.buildInputs) apps
                );
              }
            )
          ];
        };

      devShells = forAllPlatforms (
        pkgs:
        let
          towaPackages = packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [
              towaPackages.hub
            ];

            packages = with pkgs; [
              rustfmt
              clippy
              rust-analyzer

              buf

              nixd
              nixfmt

              stdenv.cc
              gnumake
              gcc
            ];
          };
        }
      );
    };
}
