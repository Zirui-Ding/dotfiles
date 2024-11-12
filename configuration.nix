# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  console = {
    keyMap = "jp106";
    packages = with pkgs; [ terminus_font ];
   #font = "Lat2-Terminus";
  };
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Enable the Deepin Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.desktopManager.deepin.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany # web browser
    gnome.geary # email reader. Up to 24.05. Starting from 24.11 the package name is just geary.
    evince # document viewer
  ];

  hardware.opengl = {
    enable = true;
  };

  fonts = {
    enableDefaultPackages= true;
    fontDir.enable = true;
    fontconfig = {
      antialias = true;
      hinting.autohint = true;
      hinting.enable = true;
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      ubuntu_font_family
    ];
  };
  

   services.xserver.xkb.layout = "jp";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  hardware.bluetooth.enable = true;
  # Enable sound.
  hardware.pulseaudio.enable = true;
  # OR
  #services.pipewire = {
  #enable = false;
  #pulse.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jerry= {
  isNormalUser = true;
  extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  packages = with pkgs; [
  ];
  };

  security.sudo.extraRules= [
  { users = [ "jerry" ];
    commands = [
       { command = "ALL" ;
         options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }
    ];
   }
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
  mkinitcpio-nfs-utils
  neovim 
  fastfetch
  git
  wget
  google-chrome
  zsh
  gnome.dconf-editor
  gnome3.gnome-tweaks
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

