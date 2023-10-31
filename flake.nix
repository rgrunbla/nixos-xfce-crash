# Copyright (c) 2019 lassulus and the nixos-generators contributors
#
# Copyright Capes-OS Contributors:
#
# - Rémy Grünblatt <remy@grunblatt.org>
#
# Licensed under the EUPL, Version 1.2 or – as soon they will be approved by
# the European Commission - subsequent versions of the EUPL (the "Licence");
# You may not use this work except in compliance with the Licence.
# You may obtain a copy of the Licence at:
#
# https://joinup.ec.europa.eu/software/page/eupl
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the Licence is distributed on an "AS IS" basis,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the Licence for the specific language governing permissions and
# limitations under the Licence.

{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... } @ inputs:
    let
      system = "x86_64-linux";
      sourceInfo = inputs.self.sourceInfo;
    in
    {
      nixosModules.os = { config, ... }: {
        imports = [
          nixos-generators.nixosModules.all-formats
          ./configuration.nix
          {
            nix.settings = {
              experimental-features = [ "nix-command" "flakes" ];
              auto-optimise-store = true;
            };
            nixpkgs.config.allowUnfree = true;
          }
        ];

        nixpkgs.hostPlatform = "x86_64-linux";

        # customize an existing format
        formatConfigs =
          {
            vm = { };
          };
      };

      # the evaluated machine
      nixosConfigurations.os = nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.os ];
      };

      packages.${system} =
        with import nixpkgs { inherit system; };
        let
          vm = self.nixosConfigurations.os.config.formats.vm;
        in
        {
          inherit vm;
          default = vm;
        };
    };
}
