{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, sops-nix, home-manager, ... }@inputs:
    let
      pkgs = import nixpkgs {
        localSystem = "x86_64-linux";
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        localSystem = "x86_64-linux";
        config.allowUnfree = true;
      };
    in {
      homeConfigurations = {
        bsuttor = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          #system = "x86_64-linux";
          extraSpecialArgs = {inherit inputs;};
          modules = [
            ./home-manager/home.nix
            #sops-nix.nixosModules.sops
            #inputs.home-manager.nixosModules.default
          ];
        };
    };
  };
}
