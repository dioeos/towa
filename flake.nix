{
  description = "Towa Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      platforms = [
        "x86_64-linux"
      ];

      forAllPlatforms = f: nixpkgs.lib.genAttrs platforms (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllPlatforms (
        pkgs: {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
              rustc

              rustfmt
              clippy
              rust-analyzer

              buf
              protobuf

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
