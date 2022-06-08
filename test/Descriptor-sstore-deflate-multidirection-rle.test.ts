import chai from "chai";
import { solidity } from "ethereum-waffle";
import {
  deploySStoreDeflateNounsDescriptor,
  sStoreDeflatePopulateDescriptorWithMultiDirRLE,
} from "./utils";

chai.use(solidity);
const { expect } = chai;

describe("Descriptor SSTORE Deflate multi-direction RLE", () => {
  it("deploy and populate", async () => {
    const { descriptor } = await deploySStoreDeflateNounsDescriptor();

    await sStoreDeflatePopulateDescriptorWithMultiDirRLE(descriptor);
  });
});
