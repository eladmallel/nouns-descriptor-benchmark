import chai from "chai";
import { solidity } from "ethereum-waffle";
import {
  deployMultiRleSStoreNounsDescriptor,
  multiRleSStorePopulateDescriptor,
} from "./utils";

chai.use(solidity);
const { expect } = chai;

describe("Descriptor MultiRLE SSTORE", () => {
  it("deploy and populate", async () => {
    const nounsDescriptor = await deployMultiRleSStoreNounsDescriptor();

    await multiRleSStorePopulateDescriptor(nounsDescriptor);
  });
});
