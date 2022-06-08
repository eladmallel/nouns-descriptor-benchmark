import chai from "chai";
import { solidity } from "ethereum-waffle";
import {
  deployMultiRleNounsDescriptor,
  multiRlePopulateDescriptor,
} from "./utils";

chai.use(solidity);
const { expect } = chai;

describe("Descriptor MultiRLE", () => {
  it("deploy and populate", async () => {
    const nounsDescriptor = await deployMultiRleNounsDescriptor();

    await multiRlePopulateDescriptor(nounsDescriptor);
  });
});
