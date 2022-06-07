import chai from "chai";
import { solidity } from "ethereum-waffle";
import {
  deploySStoreDeflateNounsDescriptor,
  sStoreDeflatePopulateDescriptor,
} from "./utils";

chai.use(solidity);
const { expect } = chai;

describe("Descriptor MultiRLE SSTORE Deflate", () => {
  it("deploy and populate", async () => {
    const nounsDescriptor = await deploySStoreDeflateNounsDescriptor();

    await sStoreDeflatePopulateDescriptor(nounsDescriptor);
  });
});
