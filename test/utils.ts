import { ethers, network } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import {
  BaselineNounsDescriptor,
  BaselineNounsDescriptor__factory,
  MultiRleNounsDescriptor,
  MultiRleNounsDescriptor__factory,
  NounsArt__factory,
  SVGRenderer__factory,
  MultiRleSStoreNounsDescriptor,
  MultiRleSStoreNounsDescriptor__factory,
  SStoreDeflateNounsDescriptor,
  SStoreDeflateNounsDescriptor__factory,
  NounsArtDeflate__factory,
  MultiRleNounsArt__factory,
  NounsArtDeflate,
  NounsArtDeflateExternalPuff__factory,
  NounsArtDeflateExternalPuff,
} from "../typechain";
import BaselineImageData from "../files/baseline-image-data.json";
import MultiRleImageData from "../files/multi-rle-image-data.json";
import MergedImageData from "../files/merged-image-data.json";
import { Block } from "@ethersproject/abstract-provider";
import { deflateRawSync } from "zlib";

export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

export type TestSigners = {
  deployer: SignerWithAddress;
  account0: SignerWithAddress;
  account1: SignerWithAddress;
  account2: SignerWithAddress;
};

export const getSigners = async (): Promise<TestSigners> => {
  const [deployer, account0, account1, account2] = await ethers.getSigners();
  return {
    deployer,
    account0,
    account1,
    account2,
  };
};

export const deployBaselineNounsDescriptor = async (
  deployer?: SignerWithAddress
): Promise<BaselineNounsDescriptor> => {
  const signer = deployer || (await getSigners()).deployer;
  const nftDescriptorLibraryFactory = await ethers.getContractFactory(
    "contracts/baseline/libs/NFTDescriptor.sol:NFTDescriptor",
    signer
  );
  const nftDescriptorLibrary = await nftDescriptorLibraryFactory.deploy();
  const nounsDescriptorFactory = new BaselineNounsDescriptor__factory(
    {
      "contracts/baseline/libs/NFTDescriptor.sol:NFTDescriptor":
        nftDescriptorLibrary.address,
    },
    signer
  );

  return nounsDescriptorFactory.deploy();
};

export const deployMultiRleNounsDescriptor = async (
  deployer?: SignerWithAddress
): Promise<MultiRleNounsDescriptor> => {
  const signer = deployer || (await getSigners()).deployer;
  const nounsArtFactory = new MultiRleNounsArt__factory(signer);
  const nftDescriptorFactory = await ethers.getContractFactory(
    "contracts/multi-rle/libs/NFTDescriptor.sol:NFTDescriptor",
    signer
  );

  const svgRendererFactory = new SVGRenderer__factory(signer);

  const nftDescriptorLibrary = await nftDescriptorFactory.deploy();
  const nounsDescriptorFactory = new MultiRleNounsDescriptor__factory(
    {
      "contracts/multi-rle/libs/NFTDescriptor.sol:NFTDescriptor":
        nftDescriptorLibrary.address,
    },
    signer
  );

  const renderer = await svgRendererFactory.deploy();
  const descriptor = await nounsDescriptorFactory.deploy(
    ZERO_ADDRESS,
    renderer.address
  );

  // TODO: Clean up the intialization process
  const art = await nounsArtFactory.deploy(descriptor.address);
  await descriptor.setArt(art.address);

  return descriptor;
};

export const deployMultiRleSStoreNounsDescriptor = async (
  deployer?: SignerWithAddress
): Promise<MultiRleSStoreNounsDescriptor> => {
  const signer = deployer || (await getSigners()).deployer;
  const nounsArtFactory = new NounsArt__factory(signer);
  const nftDescriptorFactory = await ethers.getContractFactory(
    "contracts/multi-rle-sstore/libs/NFTDescriptor.sol:NFTDescriptor",
    signer
  );

  const svgRendererFactory = new SVGRenderer__factory(signer);

  const nftDescriptorLibrary = await nftDescriptorFactory.deploy();
  const nounsDescriptorFactory = new MultiRleSStoreNounsDescriptor__factory(
    {
      "contracts/multi-rle-sstore/libs/NFTDescriptor.sol:NFTDescriptor":
        nftDescriptorLibrary.address,
    },
    signer
  );

  const renderer = await svgRendererFactory.deploy();
  const descriptor = await nounsDescriptorFactory.deploy(
    ZERO_ADDRESS,
    renderer.address
  );

  // TODO: Clean up the intialization process
  const art = await nounsArtFactory.deploy(descriptor.address);
  await descriptor.setArt(art.address);

  return descriptor;
};

export const deploySStoreDeflateNounsDescriptor = async (
  deployer?: SignerWithAddress
): Promise<{
  descriptor: SStoreDeflateNounsDescriptor;
  art: NounsArtDeflate;
}> => {
  const signer = deployer || (await getSigners()).deployer;
  const nounsArtFactory = new NounsArtDeflate__factory(signer);
  const nftDescriptorFactory = await ethers.getContractFactory(
    "contracts/sstore-deflate/libs/NFTDescriptor.sol:NFTDescriptor",
    signer
  );

  const svgRendererFactory = new SVGRenderer__factory(signer);

  const nftDescriptorLibrary = await nftDescriptorFactory.deploy();
  const nounsDescriptorFactory = new SStoreDeflateNounsDescriptor__factory(
    {
      "contracts/sstore-deflate/libs/NFTDescriptor.sol:NFTDescriptor":
        nftDescriptorLibrary.address,
    },
    signer
  );

  const renderer = await svgRendererFactory.deploy();
  const descriptor = await nounsDescriptorFactory.deploy(
    ZERO_ADDRESS,
    renderer.address
  );

  // TODO: Clean up the intialization process
  const art = await nounsArtFactory.deploy(descriptor.address);
  await descriptor.setArt(art.address);

  return { descriptor, art };
};

export const deploySStoreDeflateNounsDescriptorExternalPuff = async (
  deployer?: SignerWithAddress
): Promise<{
  descriptor: SStoreDeflateNounsDescriptor;
  art: NounsArtDeflateExternalPuff;
}> => {
  const signer = deployer || (await getSigners()).deployer;
  const nounsArtFactory = new NounsArtDeflateExternalPuff__factory(signer);
  const nftDescriptorFactory = await ethers.getContractFactory(
    "contracts/sstore-deflate/libs/NFTDescriptor.sol:NFTDescriptor",
    signer
  );

  const svgRendererFactory = new SVGRenderer__factory(signer);

  const nftDescriptorLibrary = await nftDescriptorFactory.deploy();
  const nounsDescriptorFactory = new SStoreDeflateNounsDescriptor__factory(
    {
      "contracts/sstore-deflate/libs/NFTDescriptor.sol:NFTDescriptor":
        nftDescriptorLibrary.address,
    },
    signer
  );

  const renderer = await svgRendererFactory.deploy();
  const descriptor = await nounsDescriptorFactory.deploy(
    ZERO_ADDRESS,
    renderer.address
  );

  // TODO: Clean up the intialization process
  const art = await nounsArtFactory.deploy(descriptor.address);
  await descriptor.setArt(art.address);

  return { descriptor, art };
};

export const baselinePopulateDescriptor = async (
  nounsDescriptor: BaselineNounsDescriptor
): Promise<void> => {
  const { bgcolors, palette, images } = BaselineImageData;
  const { bodies, accessories, heads, glasses } = images;

  // Split up head and accessory population due to high gas usage
  await Promise.all([
    nounsDescriptor.addManyBackgrounds(bgcolors),
    nounsDescriptor.addManyColorsToPalette(0, palette),
    nounsDescriptor.addManyBodies(bodies.map(({ data }) => data)),
    chunkArray(accessories, 10).map((chunk) =>
      nounsDescriptor.addManyAccessories(chunk.map(({ data }) => data))
    ),
    chunkArray(heads, 10).map((chunk) =>
      nounsDescriptor.addManyHeads(chunk.map(({ data }) => data))
    ),
    nounsDescriptor.addManyGlasses(glasses.map(({ data }) => data)),
  ]);
};

export const multiRlePopulateDescriptor = async (
  nounsDescriptor: MultiRleNounsDescriptor
): Promise<void> => {
  const { bgcolors, palette, images } = MultiRleImageData;
  const { bodies, accessories, heads, glasses } = images;

  // Split up head and accessory population due to high gas usage
  await Promise.all([
    nounsDescriptor.addManyBackgrounds(bgcolors),
    nounsDescriptor.setPalette(0, `0x000000${palette.join("")}`),
    nounsDescriptor.addManyBodies(bodies.map(({ data }) => data)),
    chunkArray(accessories, 10).map((chunk) =>
      nounsDescriptor.addManyAccessories(chunk.map(({ data }) => data))
    ),
    chunkArray(heads, 10).map((chunk) =>
      nounsDescriptor.addManyHeads(chunk.map(({ data }) => data))
    ),
    nounsDescriptor.addManyGlasses(glasses.map(({ data }) => data)),
  ]);
};

export const multiRleSStorePopulateDescriptor = async (
  nounsDescriptor: MultiRleSStoreNounsDescriptor
): Promise<void> => {
  const { bgcolors, palette, images } = MultiRleImageData;
  const { bodies, accessories, heads, glasses } = images;

  const headsEncoded = ethers.utils.defaultAbiCoder.encode(
    ["bytes[]"],
    [heads.map(({ data }) => data)]
  );
  const accessoriesEncoded = ethers.utils.defaultAbiCoder.encode(
    ["bytes[]"],
    [accessories.map(({ data }) => data)]
  );

  await Promise.all([
    nounsDescriptor.setHeads(headsEncoded),
    nounsDescriptor.setAccessories(accessoriesEncoded),
    nounsDescriptor.addManyBackgrounds(bgcolors),
    nounsDescriptor.setPalette(0, `0x000000${palette.join("")}`),
    nounsDescriptor.addManyBodies(bodies.map(({ data }) => data)),
    nounsDescriptor.addManyGlasses(glasses.map(({ data }) => data)),
  ]);
};

export const sStoreDeflatePopulateDescriptor = async (
  nounsDescriptor: SStoreDeflateNounsDescriptor
): Promise<void> => {
  const { bgcolors, palette, images } = MultiRleImageData;
  await populateDeflate(nounsDescriptor, bgcolors, palette, images);
};

export const sStoreDeflatePopulateDescriptorWithMultiDirRLE = async (
  nounsDescriptor: SStoreDeflateNounsDescriptor
): Promise<void> => {
  const { bgcolors, palette, images } = MergedImageData;
  await populateDeflate(nounsDescriptor, bgcolors, palette, images);
};

const populateDeflate = async (
  nounsDescriptor: SStoreDeflateNounsDescriptor,
  bgcolors: string[],
  palette: string[],
  images: {
    bodies: { filename: string; data: string }[];
    accessories: { filename: string; data: string }[];
    heads: { filename: string; data: string }[];
    glasses: { filename: string; data: string }[];
  }
): Promise<void> => {
  const { bodies, accessories, heads, glasses } = images;

  const {
    encodedCompressed: headsCompressed,
    originalLength: headsLength,
    itemCount: headsCount,
  } = dataToDescriptorInput(heads.map(({ data }) => data));

  const {
    encodedCompressed: bodiesCompressed,
    originalLength: bodiesLength,
    itemCount: bodiesCount,
  } = dataToDescriptorInput(bodies.map(({ data }) => data));

  const {
    encodedCompressed: accessoriesCompressed,
    originalLength: accessoriesLength,
    itemCount: accessoriesCount,
  } = dataToDescriptorInput(accessories.map(({ data }) => data));

  const {
    encodedCompressed: glassesCompressed,
    originalLength: glassesLength,
    itemCount: glassesCount,
  } = dataToDescriptorInput(glasses.map(({ data }) => data));

  // Split up head and accessory population due to high gas usage

  await nounsDescriptor.addManyBackgrounds(bgcolors);
  await nounsDescriptor.setPalette(0, `0x000000${palette.join("")}`);
  await nounsDescriptor.setHeads(headsCompressed, headsLength, headsCount);
  await nounsDescriptor.setBodies(bodiesCompressed, bodiesLength, bodiesCount);
  await nounsDescriptor.setAccessories(
    accessoriesCompressed,
    accessoriesLength,
    accessoriesCount
  );
  await nounsDescriptor.setGlasses(
    glassesCompressed,
    glassesLength,
    glassesCount
  );
};

function dataToDescriptorInput(data: string[]): {
  encodedCompressed: string;
  originalLength: number;
  itemCount: number;
} {
  const abiEncoded = ethers.utils.defaultAbiCoder.encode(["bytes[]"], [data]);
  const encodedCompressed = `0x${deflateRawSync(
    Buffer.from(abiEncoded.substring(2), "hex")
  ).toString("hex")}`;

  const originalLength = abiEncoded.substring(2).length / 2;
  const itemCount = data.length;

  return {
    encodedCompressed,
    originalLength,
    itemCount,
  };
}

const rpc = <T = unknown>({
  method,
  params,
}: {
  method: string;
  params?: unknown[];
}): Promise<T> => {
  return network.provider.send(method, params);
};

export const encodeParameters = (
  types: string[],
  values: unknown[]
): string => {
  const abi = new ethers.utils.AbiCoder();
  return abi.encode(types, values);
};

export const blockByNumber = async (n: number | string): Promise<Block> => {
  return rpc({ method: "eth_getBlockByNumber", params: [n, false] });
};

export const increaseTime = async (seconds: number): Promise<unknown> => {
  await rpc({ method: "evm_increaseTime", params: [seconds] });
  return rpc({ method: "evm_mine" });
};

export const freezeTime = async (seconds: number): Promise<unknown> => {
  await rpc({ method: "evm_increaseTime", params: [-1 * seconds] });
  return rpc({ method: "evm_mine" });
};

export const advanceBlocks = async (blocks: number): Promise<void> => {
  for (let i = 0; i < blocks; i++) {
    await mineBlock();
  }
};

export const blockNumber = async (parse = true): Promise<number> => {
  const result = await rpc<number>({ method: "eth_blockNumber" });
  return parse ? parseInt(result.toString()) : result;
};

export const blockTimestamp = async (
  n: number | string,
  parse = true
): Promise<number | string> => {
  const block = await blockByNumber(n);
  return parse ? parseInt(block.timestamp.toString()) : block.timestamp;
};

export const setNextBlockTimestamp = async (
  n: number,
  mine = true
): Promise<void> => {
  await rpc({ method: "evm_setNextBlockTimestamp", params: [n] });
  if (mine) await mineBlock();
};

export const minerStop = async (): Promise<void> => {
  await network.provider.send("evm_setAutomine", [false]);
  await network.provider.send("evm_setIntervalMining", [0]);
};

export const minerStart = async (): Promise<void> => {
  await network.provider.send("evm_setAutomine", [true]);
};

export const mineBlock = async (): Promise<void> => {
  await network.provider.send("evm_mine");
};

export const chainId = async (): Promise<number> => {
  return parseInt(await network.provider.send("eth_chainId"), 16);
};

export const address = (n: number): string => {
  return `0x${n.toString(16).padStart(40, "0")}`;
};

/**
 * Split an array into smaller chunks
 * @param array The array
 * @param size The chunk size
 */
export const chunkArray = <T>(array: T[], size: number): T[][] => {
  const chunk: T[][] = [];
  for (let i = 0; i < array.length; i += size) {
    chunk.push(array.slice(i, i + size));
  }
  return chunk;
};
