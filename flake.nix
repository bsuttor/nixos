{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixpkgs-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, ... }@inputs:
    let
      pkgs = import nixpkgs {
        localSystem = "x86_64-linux";
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        localSystem = "aarch64-darwin";
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/default/configuration.nix
          sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
