{
  description = "Vqphd's NixLab";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
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

  outputs =
    { self, nixpkgs, home-manager, zen-browser, spicetify-nix, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
        overlays = [ (import ./overlays) ];
      };

      baseModules = [
        ./hosts/nixlab/configuration.nix
        ./hosts/nixlab/hardware-configuration.nix
        ./fonts.nix
        inputs.spicetify-nix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "HMBackup";
          home-manager.useUserPackages = true;
          home-manager.users.vqphd = import ./hosts/nixlab/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs system; };
        }
      ];

    in {
      nixosConfigurations = {
        nixlab = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = baseModules;
        };

        nixlab-iso = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = baseModules ++ [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];
        };
      };

      homeConfigurations.vqphd = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs system; };
        modules = [ ./hosts/nixlab/home.nix ];
      };

      # 💽 ISO build target
      packages.${system}.iso =
        self.nixosConfigurations.nixlab-iso.config.system.build.isoImage;
    };
}
