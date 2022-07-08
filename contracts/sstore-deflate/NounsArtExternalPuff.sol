// SPDX-License-Identifier: GPL-3.0

/// @title The Nouns art storage contract

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

import { INounsArt } from "./interfaces/INounsArt.sol";
import { Inflator } from "./Inflator.sol";
import { SSTORE2 } from "./libs/SSTORE2.sol";

contract NounsArtDeflateExternalPuff is INounsArt {
  // prettier-ignore
  // https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt
  bytes32 constant COPYRIGHT_CC0_1_0_UNIVERSAL_LICENSE = 0xa2010f343487d3f7618affe54f789f5487602331c0a8d03f49e9a7c547cf0499;

  // Noun Color Palette Pointers (Palette Index => Pointer)
  mapping(uint8 => address) public palettes;

  // Noun Backgrounds (Hex Colors)
  string[] public backgrounds;

  NounArtPointer private _headsPointer;
  NounArtPointer private _glassesPointer;
  NounArtPointer private _accessoriesPointer;
  NounArtPointer private _bodiesPointer;

  // Current Nouns Descriptor address
  address public descriptor;

  // Pending Nouns Descriptor address
  address public pendingDescriptor;

  Inflator public inflator;

  /**
   * @notice Require that the sender is the descriptor.
   */
  modifier onlyDescriptor() {
    if (msg.sender != descriptor) {
      revert SenderIsNotDescriptor();
    }
    _;
  }

  constructor(address _descriptor) {
    descriptor = _descriptor;
    inflator = new Inflator();
  }

  /**
   * @notice Set the pending descriptor, which can be confirmed
   * by calling `confirmDescriptor`.
   * @dev This function can only be called by the current descriptor.
   */
  function setDescriptor(address _pendingDescriptor) external onlyDescriptor {
    pendingDescriptor = _pendingDescriptor;
  }

  /**
   * @notice Confirm the pending descriptor.
   * @dev This function can only be called by the pending descriptor.
   */
  function confirmDescriptor() external {
    if (msg.sender != pendingDescriptor) {
      revert SenderIsNotPendingDescriptor();
    }

    address oldDescriptor = descriptor;
    descriptor = pendingDescriptor;
    delete pendingDescriptor;

    emit DescriptorUpdated(oldDescriptor, descriptor);
  }

  /**
   * @notice Get a Noun body by `index`.
   */
  function bodies(uint256 index) external view returns (bytes memory) {
    NounArtPointer storage artPointer = _bodiesPointer;

    bytes memory deflatedBytes = SSTORE2.read(artPointer.pointer);
    bytes memory inflatedBytes = decompress(deflatedBytes, artPointer.length);

    bytes[] memory art = abi.decode(inflatedBytes, (bytes[]));
    return art[index];
  }

  /**
   * @notice Get a Noun accessory by `index`.
   */
  function accessories(uint256 index) external view returns (bytes memory) {
    NounArtPointer storage artPointer = _accessoriesPointer;

    bytes memory deflatedBytes = SSTORE2.read(artPointer.pointer);
    bytes memory inflatedBytes = decompress(deflatedBytes, artPointer.length);

    bytes[] memory art = abi.decode(inflatedBytes, (bytes[]));
    return art[index];
  }

  /**
   * @notice Get a Noun head by `index`.
   */
  function heads(uint256 index) external view returns (bytes memory) {
    NounArtPointer storage artPointer = _headsPointer;

    bytes memory deflatedBytes = SSTORE2.read(artPointer.pointer);
    bytes memory inflatedBytes = decompress(deflatedBytes, artPointer.length);

    bytes[] memory art = abi.decode(inflatedBytes, (bytes[]));
    return art[index];
  }

  /**
   * @notice Get Noun glasses by `index`.
   */
  function glasses(uint256 index) external view returns (bytes memory) {
    NounArtPointer storage artPointer = _glassesPointer;

    bytes memory deflatedBytes = SSTORE2.read(artPointer.pointer);
    bytes memory inflatedBytes = decompress(deflatedBytes, artPointer.length);

    bytes[] memory art = abi.decode(inflatedBytes, (bytes[]));
    return art[index];
  }

  /**
   * @notice Get the number of available Noun `backgrounds`.
   */
  function backgroundCount() external view returns (uint256) {
    return backgrounds.length;
  }

  /**
   * @notice Get the number of available Noun `bodies`.
   */
  function bodyCount() external view returns (uint256) {
    return _bodiesPointer.count;
  }

  /**
   * @notice Get the number of available Noun `accessories`.
   */
  function accessoryCount() external view returns (uint256) {
    return _accessoriesPointer.count;
  }

  /**
   * @notice Get the number of available Noun `heads`.
   */
  function headCount() external view returns (uint256) {
    return _headsPointer.count;
  }

  /**
   * @notice Get the number of available Noun `glasses`.
   */
  function glassesCount() external view returns (uint256) {
    return _glassesPointer.count;
  }

  /**
   * @notice Decompress a DEFLATE-compressed data stream.
   */
  function decompress(bytes memory input, uint256 len)
    public
    view
    returns (bytes memory)
  {
    (, bytes memory decompressed) = inflator.puff(input, len);
    return decompressed;
  }

  /**
   * @notice Update a single color palette. This function can be used to
   * add a new color palette or update an existing palette.
   * @dev This function can only be called by the descriptor.
   */
  function setPalette(uint8 paletteIndex, bytes calldata palette)
    external
    onlyDescriptor
  {
    if (palette.length == 0) {
      revert EmptyPalette();
    }
    if (palette.length % 3 != 0 || palette.length > 768) {
      revert BadPaletteLength();
    }
    palettes[paletteIndex] = SSTORE2.write(palette);
  }

  /**
   * @notice Batch add Noun backgrounds.
   * @dev This function can only be called by the descriptor.
   */
  function addManyBackgrounds(string[] calldata backgrounds_)
    external
    onlyDescriptor
  {
    for (uint256 i = 0; i < backgrounds_.length; i++) {
      _addBackground(backgrounds_[i]);
    }
  }

  function setHeads(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyDescriptor {
    _headsPointer = NounArtPointer({
      pointer: SSTORE2.write(encodedCompressed),
      length: originalLength,
      count: itemCount
    });
  }

  function setGlasses(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyDescriptor {
    _glassesPointer = NounArtPointer({
      pointer: SSTORE2.write(encodedCompressed),
      length: originalLength,
      count: itemCount
    });
  }

  function setAccessories(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyDescriptor {
    _accessoriesPointer = NounArtPointer({
      pointer: SSTORE2.write(encodedCompressed),
      length: originalLength,
      count: itemCount
    });
  }

  function setBodies(
    bytes calldata encodedCompressed,
    uint80 originalLength,
    uint16 itemCount
  ) external onlyDescriptor {
    _bodiesPointer = NounArtPointer({
      pointer: SSTORE2.write(encodedCompressed),
      length: originalLength,
      count: itemCount
    });
  }

  /**
   * @notice Add a Noun background.
   */
  function _addBackground(string calldata background_) internal {
    backgrounds.push(background_);
  }

  // /**
  //  * @notice Add a Noun body.
  //  */
  // function _addBody(NounArt calldata body_) internal {
  //   _bodies.push(
  //     NounArtPointer({
  //       length: body_.length,
  //       pointer: SSTORE2.write((body_.data))
  //     })
  //   );
  // }

  // /**
  //  * @notice Add a Noun accessory.
  //  */
  // function _addAccessory(NounArt calldata accessory_) internal {
  //   _accessories.push(
  //     NounArtPointer({
  //       length: accessory_.length,
  //       pointer: SSTORE2.write((accessory_.data))
  //     })
  //   );
  // }

  // /**
  //  * @notice Add a Noun head.
  //  */
  // function _addHead(NounArt calldata head_) internal {
  //   _heads.push(
  //     NounArtPointer({
  //       length: head_.length,
  //       pointer: SSTORE2.write((head_.data))
  //     })
  //   );
  // }

  // /**
  //  * @notice Add Noun glasses.
  //  */
  // function _addGlasses(NounArt calldata glasses_) internal {
  //   _glasses.push(
  //     NounArtPointer({
  //       length: glasses_.length,
  //       pointer: SSTORE2.write((glasses_.data))
  //     })
  //   );
  // }
}
