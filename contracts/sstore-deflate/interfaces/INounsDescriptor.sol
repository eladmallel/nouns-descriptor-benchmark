// SPDX-License-Identifier: GPL-3.0

/// @title Interface for NounsDescriptor

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

pragma solidity ^0.8.12;

import { INounsSeeder } from "./INounsSeeder.sol";
import { ISVGRenderer } from "./ISVGRenderer.sol";
import { INounsArt } from "./INounsArt.sol";

interface INounsDescriptor {
  error PartsAreLocked();

  event PartsLocked();

  event ArtUpdated(INounsArt art);

  event RendererUpdated(ISVGRenderer renderer);

  function arePartsLocked() external returns (bool);

  function art() external returns (INounsArt);

  function renderer() external returns (ISVGRenderer);

  function setArt(INounsArt art) external;

  function setRenderer(ISVGRenderer renderer) external;

  function backgroundCount() external view returns (uint256);

  function bodyCount() external view returns (uint256);

  function accessoryCount() external view returns (uint256);

  function headCount() external view returns (uint256);

  function glassesCount() external view returns (uint256);

  function setPalette(uint8 paletteIndex, bytes calldata palette) external;

  function addManyBackgrounds(string[] calldata backgrounds) external;

  function addManyBodies(INounsArt.NounArt[] calldata bodies) external;

  function addManyAccessories(INounsArt.NounArt[] calldata accessories)
    external;

  function addManyHeads(INounsArt.NounArt[] calldata heads) external;

  function addManyGlasses(INounsArt.NounArt[] calldata glasses) external;

  function addBackground(string calldata background) external;

  function addBody(INounsArt.NounArt calldata body) external;

  function setBodies(bytes calldata bodiesEncodedCompressed) external;

  function addAccessory(INounsArt.NounArt calldata accessory) external;

  function setAccessories(bytes calldata accessoriesEncodedCompressed) external;

  function addHead(INounsArt.NounArt calldata head) external;

  function setHeads(bytes calldata headsEncodedCompressed) external;

  function addGlasses(INounsArt.NounArt calldata glasses) external;

  function setGlasses(bytes calldata glassesEncodedCompressed) external;

  function lockParts() external;

  function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed)
    external
    view
    returns (string memory);

  function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed)
    external
    view
    returns (string memory);

  function genericDataURI(
    string memory name,
    string memory description,
    INounsSeeder.Seed memory seed
  ) external view returns (string memory);

  function generateSVGImage(INounsSeeder.Seed memory seed)
    external
    view
    returns (string memory);

  function getPartsForSeed(INounsSeeder.Seed memory seed)
    external
    view
    returns (ISVGRenderer.Part[] memory);
}
