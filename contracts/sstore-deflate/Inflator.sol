// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.12;

import { Inflate } from "./libs/Inflate.sol";

contract Inflator {
  function puff(bytes memory source, uint256 destlen)
    external
    pure
    returns (Inflate.ErrorCode, bytes memory)
  {
    return Inflate.puff(source, destlen);
  }
}
