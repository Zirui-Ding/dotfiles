{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;

   networking.hostName = "nixos"; # Define your hostname.
   networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
   time.timeZone = "Asia/Tokyo";
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     keyMap = "jp106";
   };
   services.libinput.enable = true;
   services.xserver.xkb.layout = "jp";

   i18n.inputMethod = {
    enable = true;
    type= "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      rime
      mozc
    ];
   };

   programs.zsh = {
     enable = true;
     ohMyZsh = {
       enable = true;
       theme = "gentoo";
     };
   };
   users.defaultUserShell = pkgs.zsh;

   nix.settings.experimental-features = [ "nix-command" "flakes" ];

   hardware.graphics.enable = true;

   services.xserver.enable = true;
   services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia.open = false;

   services.displayManager.sddm.enable = true;
   services.displayManager.sddm.wayland.enable = true;
   services.displayManager.sddm.settings = {
    Autologin = {
    Session = "plasma.desktop";
    User = "jerry";
   }; 

   };
   services.desktopManager.plasma6.enable = true;

   services.printing.enable = true;
   services.printing.drivers = [ pkgs.brlaser ];

   hardware.bluetooth.enable = true; 
   hardware.bluetooth.powerOnBoot = true;

  # hardware.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };


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
  security.pam.services."sddm".enableKwallet = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
     w3m
     neovim 
     fastfetch
     google-chrome
     git
     wget
     aria2
     tela-icon-theme
     zsh
     oh-my-zsh
     nordic
   ];

  fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
  ];

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

