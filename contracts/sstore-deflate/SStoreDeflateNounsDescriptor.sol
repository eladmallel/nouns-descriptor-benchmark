// SPDX-License-Identifier: GPL-3.0

/// @title The Nouns NFT descriptor

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

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { INounsDescriptor } from "./interfaces/INounsDescriptor.sol";
import { INounsSeeder } from "./interfaces/INounsSeeder.sol";
import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NFTDescriptor } from "./libs/NFTDescriptor.sol";
import { INounsArt } from "./interfaces/INounsArt.sol";

contract SStoreDeflateNounsDescriptor is INounsDescriptor, Ownable {
  using Strings for uint256;

  // The contract responsible for holding compressed Noun art
  INounsArt public art;

  // The contract responsible for constructing SVGs
  ISVGRenderer public renderer;

  // Whether or not new Noun parts can be added
  bool public arePartsLocked;

  /**
   * @notice Require that the parts have not been locked.
   */
  modifier whenPartsNotLocked() {
    if (arePartsLocked) {
      revert PartsAreLocked();
    }
    _;
  }

  constructor(INounsArt _art, ISVGRenderer _renderer) {
    art = _art;
    renderer = _renderer;
  }

  /**
   * @notice Set the Noun's art contract.
   * Only callable by the owner when not locked.
   */
  function setArt(INounsArt _art) external onlyOwner whenPartsNotLocked {
    art = _art;

    emit ArtUpdated(_art);
  }

  /**
   * @notice Set the SVG renderer.
   * @dev Only callable by the owner.
   */
  function setRenderer(ISVGRenderer _renderer) external onlyOwner {
    renderer = _renderer;

    emit RendererUpdated(_renderer);
  }

  /**
   * @notice Get the number of available Noun `backgrounds`.
   */
  function backgroundCount() external view returns (uint256) {
    return art.backgroundCount();
  }

  /**
   * @notice Get the number of available Noun `bodies`.
   */
  function bodyCount() external view returns (uint256) {
    return art.bodyCount();
  }

  /**
   * @notice Get the number of available Noun `accessories`.
   */
  function accessoryCount() external view returns (uint256) {
    return art.accessoryCount();
  }

  /**
   * @notice Get the number of available Noun `heads`.
   */
  function headCount() external view returns (uint256) {
    return art.headCount();
  }

  /**
   * @notice Get the number of available Noun `glasses`.
   */
  function glassesCount() external view returns (uint256) {
    return art.glassesCount();
  }

  /**
   * @notice Update a single color palette. This function can be used to add a new
   * color palette or update an existing palette.
   * @dev This function can only be called by the owner.
   */
  function setPalette(uint8 paletteIndex, bytes calldata palette)
    external
    onlyOwner
  {
    art.setPalette(paletteIndex, palette);
  }

  /**
   * @notice Batch add Noun backgrounds.
   * @dev This function can only be called by the owner when not locked.
   */
  function addManyBackgrounds(string[] calldata backgrounds)
    external
    onlyOwner
    whenPartsNotLocked
  {
    art.addManyBackgrounds(backgrounds);
  }

  function setHeads(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyOwner whenPartsNotLocked {
    art.setHeads(encodedCompressed, originalLength, itemCount);
  }

  function setGlasses(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyOwner whenPartsNotLocked {
    art.setGlasses(encodedCompressed, originalLength, itemCount);
  }

  function setAccessories(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyOwner whenPartsNotLocked {
    art.setAccessories(encodedCompressed, originalLength, itemCount);
  }

  function setBodies(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyOwner whenPartsNotLocked {
    art.setBodies(encodedCompressed, originalLength, itemCount);
  }

  /**
   * @notice Lock all Noun parts.
   * @dev This cannot be reversed and can only be called by the owner when not locked.
   */
  function lockParts() external onlyOwner whenPartsNotLocked {
    arePartsLocked = true;

    emit PartsLocked();
  }

  function tokenURITx(uint256 tokenId, INounsSeeder.Seed memory seed)
    external
    returns (string memory)
  {
    return dataURI(tokenId, seed);
  }

  /**
   * @notice Given a token ID and seed, construct a data URI for an official Nouns DAO noun.
   * @dev The returned value is a base64 encoded data URI.
   */
  function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed)
    external
    view
    returns (string memory)
  {
    return dataURI(tokenId, seed);
  }

  /**
   * @notice Given a token ID and seed, construct a data URI for an official Nouns DAO noun.
   * @dev This function exists to maintain backwards compatibility.
   */
  function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed)
    public
    view
    returns (string memory)
  {
    string memory nounId = tokenId.toString();
    string memory name = string(abi.encodePacked("Noun ", nounId));
    string memory description = string(
      abi.encodePacked("Noun ", nounId, " is a member of the Nouns DAO")
    );

    return genericDataURI(name, description, seed);
  }

  /**
   * @notice Given a name, description, and seed, construct a base64 encoded data URI.
   */
  function genericDataURI(
    string memory name,
    string memory description,
    INounsSeeder.Seed memory seed
  ) public view returns (string memory) {
    NFTDescriptor.TokenURIParams memory params = NFTDescriptor.TokenURIParams({
      name: name,
      description: description,
      parts: getPartsForSeed(seed),
      background: art.backgrounds(seed.background)
    });
    return NFTDescriptor.constructTokenURI(renderer, params);
  }

  /**
   * @notice Given a seed, construct a base64 encoded SVG image.
   */
  function generateSVGImage(INounsSeeder.Seed memory seed)
    external
    view
    returns (string memory)
  {
    ISVGRenderer.SVGParams memory params = ISVGRenderer.SVGParams({
      parts: getPartsForSeed(seed),
      background: art.backgrounds(seed.background)
    });
    return NFTDescriptor.generateSVGImage(renderer, params);
  }

  /**
   * @notice Get all Noun parts for the passed `seed`.
   */
  function getPartsForSeed(INounsSeeder.Seed memory seed)
    public
    view
    returns (ISVGRenderer.Part[] memory)
  {
    bytes memory _body = art.bodies(seed.body);
    bytes memory _accessory = art.accessories(seed.accessory);
    bytes memory _head = art.heads(seed.head);
    bytes memory _glasses = art.glasses(seed.glasses);

    ISVGRenderer.Part[] memory _parts = new ISVGRenderer.Part[](4);
    _parts[0] = ISVGRenderer.Part({
      image: _body,
      palette: _getPalette(_body)
    });
    _parts[1] = ISVGRenderer.Part({
      image: _accessory,
      palette: _getPalette(_accessory)
    });
    _parts[2] = ISVGRenderer.Part({
      image: _head,
      palette: _getPalette(_head)
    });
    _parts[3] = ISVGRenderer.Part({
      image: _glasses,
      palette: _getPalette(_glasses)
    });
    return _parts;
  }

  /**
   * @notice Get the color palette pointer for the passed part.
   */
  function _getPalette(bytes memory part) private view returns (address) {
    return art.palettes(uint8(part[0]));
  }
}
