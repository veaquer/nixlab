{
  description = "Vqphd's NixLab";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser = {
     url = "github:0xc000022070/zen-browser-flake";
    # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
    # to have it up-to-date or simply don't specify the nixpkgs input
    inputs.nixpkgs.follows = "nixpkgs";
  };
      home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; 
      };
    };

  outputs = { self, nixpkgs,home-manager, zen-browser, ... }@inputs:
  let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ (import ./overlays) ];
      };
  in{
    nixosConfigurations.nixlab = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        pkgs = pkgs;
      };
      modules = [
        ./hosts/nixlab/configuration.nix
        ./hosts/nixlab/hardware-configuration.nix
        ./fonts.nix
         home-manager.nixosModules.home-manager
         {
              home-manager.useGlobalPkgs = true;
              home-manager.backupFileExtension = "HMBackup";
              home-manager.useUserPackages = true;
              home-manager.users.vqphd = import ./hosts/nixlab/home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
         }
      ];
  };
  homeConfigurations.vqphd = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs system;
      };
      modules = [
        ./hosts/nixlab/home.nix
      ];
  };
 };
}
