{ config, pkgs,inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixlab"; # Define your hostname.

  services.flatpak.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  virtualisation.docker.enable = true;

  xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };


  # Enable networking
  networking.networkmanager.enable = true;
  services.dbus.enable = true;
  
  time.timeZone = "Europe/Warsaw";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
    addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
    };
  };

  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = "maldives";
  services.xserver.windowManager.bspwm.enable = true;

  users.users.vqphd = {
    isNormalUser = true;
    description = "VqPhD";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = import (inputs.self + "/packages") { inherit pkgs; };

  programs.zsh.enable = true;
  programs.steam = {
    enable = true;
  };

  system.stateVersion = "25.05";
}
