const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');


const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath); //removes folder and its contains

const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');

const source = fs.readFileSync(campaignPath, 'utf8');
// const output = solc.compile(source, 1).contracts;
module.exports = solc.compile(source, 1).contracts[':Campaign'];


fs.ensureDirSync(buildPath); //checks if directory exists. if not creates for us


for (let contract in module.exports) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(':', '') + '.json'),
    output[contract]
  );
}