import chai from "chai";
import { solidity } from "ethereum-waffle";
import {
  deployBaselineNounsDescriptor,
  baselinePopulateDescriptor,
} from "./utils";

chai.use(solidity);
const { expect } = chai;

describe("Descriptor baseline", () => {
  it("deploy and populate", async () => {
    const nounsDescriptor = await deployBaselineNounsDescriptor();

    await baselinePopulateDescriptor(nounsDescriptor);
  });
});
