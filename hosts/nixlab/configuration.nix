{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  programs.spicetify =
    let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      enabledExtensions = with spicePkgs.extensions; [ adblock ];
    };
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.nix-ld.enable = true;
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    xpadneo
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=1
    options hid_xpadneo disable_ff=0 enable_deadzones=1 combined_z_axis=0 trigger_rumble=1
    options v4l2loopback video_nr=10 card_label="iPadScreen" exclusive_caps=1
  '';

  nix = { settings.trusted-users = [ "root" "vqphd" ]; };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.avahi = {
    nssmdns = true;
    enable = true;
    publish = {
      enable = true;
      userServices = true;
      domain = true;
    };
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        JustWorksRepairing = true;
        ControllerMode = "dual";
      };
    };
  };
  hardware.opentabletdriver.enable = true;

  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
    _JAVA_AWT_WM_NONREPARENTING = "1"; # для Java игр
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="bluetooth", ATTRS{address}=="AC:8E:BD:78:83:99", ENV{ID_INPUT_JOYSTICK}="1"
    ATTRS{name}=="Xbox Wireless Controller", ENV{ID_INPUT_JOYSTICK}="1"
    ATTRS{name}=="Xbox Wireless Controller", ENV{BLUEZ_ENABLE_HID}="1"
  '';
  hardware.opengl.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.allowUnfree = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  environment.etc."gamescope-session" = {
    mode = "0755";
    text = ''
      #!/usr/bin/env bash
      exec /home/vqphd/Projects/nixlab/hosts/nixlab/gs.sh
    '';
  };

  hardware.xone.enable = false; # support for the xbox controller USB dongle
  environment = {
    systemPackages = (import (inputs.self + "/packages") { inherit pkgs; })
      ++ [ pkgs.mangohud ];
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && ./gs.sh
    '';
  };

  networking.hostName = "nixlab"; # Define your hostname.

  services.flatpak.enable = true;
  services.xserver = {
    enable = true;
    displayManager.setupCommands = ''
      xset s off        # Disable screen saver
      xset -dpms        # Disable DPMS (Energy Star)
      xset s noblank    # Disable screen blanking
      xsetroot -cursor_name left_ptr
    '';

    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "maldives";
    desktopManager.xfce.enable = true;
  };

  virtualisation.docker.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
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
    fcitx5 = { addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ]; };
  };

  services.xserver.windowManager.bspwm.enable = true;

  users.users.vqphd = {
    isNormalUser = true;
    description = "VqPhD";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  system.stateVersion = "25.05";
}
