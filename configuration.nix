{ config, lib, pkgs, ... }:
{
  environment.enableDebugInfo = true;
  users = {
    users = {
      root = {
        password = "password";
      };
      user = {
        isNormalUser = true;
        description = "user";
        extraGroups = [ "wheel" "networkmanager" "user" ];
        password = "password";
      };
    };
    groups = {
      user = { };
    };
  };

  environment.systemPackages = with pkgs;
    [
      valgrind
      gdb
    ];

  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  networking = {
    hostName = "nixos-crash";
    networkmanager = {
      enable = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  services = {
    blueman.enable = true;
    xserver = {
      layout = "us";
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
      displayManager = {
        defaultSession = "xfce";
      };
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  boot = {
    kernelParams = [ "quiet" "splash" ];
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
    };

    loader = {
      timeout = lib.mkForce 1;
      grub = {
        extraConfig = ''
          set timeout_style=hidden
        '';
        splashImage = null;
      };
    };

  };

  system.stateVersion = "23.11";
}
