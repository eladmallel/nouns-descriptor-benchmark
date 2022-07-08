import chai from "chai";
import { solidity } from "ethereum-waffle";
import {
  deploySStoreDeflateNounsDescriptorExternalPuff,
  sStoreDeflatePopulateDescriptor,
} from "./utils";

chai.use(solidity);
const { expect } = chai;

describe("Deflate tokenURI", () => {
  it("tokenURITx", async () => {
    const { descriptor, art } =
      await deploySStoreDeflateNounsDescriptorExternalPuff();

    await sStoreDeflatePopulateDescriptor(descriptor);

    await descriptor.tokenURITx(
      1,
      {
        accessory: 1,
        background: 0,
        body: 2,
        glasses: 3,
        head: 4,
      },
      { gasLimit: 500_000_000 }
    );

    await descriptor.tokenURITx(
      2,
      {
        accessory: 2,
        background: 1,
        body: 3,
        glasses: 4,
        head: 5,
      },
      { gasLimit: 500_000_000 }
    );
  }).timeout(1000 * 60 * 10);
});
