// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/FileHistory.sol";

/// @title Test FileHistory contract storage and retrieval of history entries. 
/// @author Michal Sporek 
contract TestFileHistorySimple { 

  function testInitialEmptyListOfEntries() public {
    FileHistory historyContract = FileHistory(DeployedAddresses.FileHistory());

    string memory filePath1 = "\\\\Share\\File1.txt";

    Assert.equal(historyContract.getEntries(filePath1).length, 0, "Call to getEntries() has failed. Expected empty array of results.");
  }

  function testShouldStoreSingleFileEntry() public { 
    FileHistory historyContract = FileHistory(DeployedAddresses.FileHistory());

    string memory filePath = '\\\\Share\\File1.txt';
    FileHistoryLib.HistoryEntryType entryType = FileHistoryLib.HistoryEntryType.Created; 
    string memory byUser = 'User1ID';
    uint256 entryTimestampMiliseconds = 1000000;
    uint64 fileSizeBytes = 1024; 

    historyContract.storeEntry(filePath, entryType, byUser, entryTimestampMiliseconds, fileSizeBytes);

    FileHistoryLib.HistoryEntry[] memory Entries = historyContract.getEntries(filePath);

    Assert.equal(Entries.length, 1, "Entries have not been stored correctly.");
    Assert.equal(uint256(Entries[0].entryType), uint256(entryType), "Entry \"entryType\" has not been stored correctly.");
    Assert.equal(Entries[0].byUser, byUser, "Entry \"byUser\" has not been stored correctly.");
    Assert.equal(Entries[0].entryTimestamp, entryTimestampMiliseconds, "Entry \"entryTimestamp\" has not been stored correctly.");
    Assert.equal(Entries[0].fileSize, fileSizeBytes, "Entry \"fileSize\" has not been stored correctly.");

    string memory anotherFilePath = '\\\\Share\\File2.txt';
    FileHistoryLib.HistoryEntry[] memory anotherFileEntries = historyContract.getEntries(anotherFilePath);

    Assert.equal(anotherFileEntries.length, 0, "Error on Entries storage. Returned Entries that have not been stored.");
  }
}