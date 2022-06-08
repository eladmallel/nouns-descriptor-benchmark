import { task } from "hardhat/config";
import HorizontalImageData from "../files/multi-rle-image-data.json";
import InvertedImageData from "../files/inverted-image-data.json";
import { promises as fs } from "fs";

import path from "path";

const DESTINATION = path.join(__dirname, "../files/merged-image-data.json");

task(
  "merge-images",
  "Creates a new image-data file with the shortest data per image"
).setAction(async (args, { ethers }) => {
  const { bgcolors, palette, images } = HorizontalImageData;
  const {
    bodies: horizontalBodies,
    accessories: horizontalAccessories,
    heads: horizontalHeads,
    glasses: horizontalGlasses,
  } = images;

  const {
    bodies: invertedBodies,
    accessories: invertedAccessories,
    heads: invertedHeads,
    glasses: invertedGlasses,
  } = InvertedImageData.images;

  const result = {
    bgcolors,
    palette,
    images: {
      bodies: {},
      accessories: {},
      heads: {},
      glasses: {},
    },
  };

  result.images.bodies = horizontalBodies.map((horizontal) => {
    const inverted = invertedBodies.find(
      (item) => item.filename === horizontal.filename
    );
    return inverted!.data.length < horizontal.data.length
      ? inverted
      : horizontal;
  });

  result.images.accessories = horizontalAccessories.map((horizontal) => {
    const inverted = invertedAccessories.find(
      (item) => item.filename === horizontal.filename
    );
    return inverted!.data.length < horizontal.data.length
      ? inverted
      : horizontal;
  });

  result.images.heads = horizontalHeads.map((horizontal) => {
    const inverted = invertedHeads.find(
      (item) => item.filename === horizontal.filename
    );
    return inverted!.data.length < horizontal.data.length
      ? inverted
      : horizontal;
  });

  result.images.glasses = horizontalGlasses.map((horizontal) => {
    const inverted = invertedGlasses.find(
      (item) => item.filename === horizontal.filename
    );
    return inverted!.data.length < horizontal.data.length
      ? inverted
      : horizontal;
  });

  await fs.writeFile(DESTINATION, JSON.stringify(result, null, 2));
});
