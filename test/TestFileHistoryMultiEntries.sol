// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/FileHistory.sol";

/// @title Test FileHistory contract's ability to store multiple Entries for a single file and retrieving these Entries. 
/// @author Michal Sporek 
contract TestFileHistoryMultiEntries { 

  string filePath = '\\\\Share\\File1.txt';

  string anotherFilePath = '\\\\Share\\AnotherFile.txt';

  FileHistoryLib.HistoryEntryType entryType1 = FileHistoryLib.HistoryEntryType.Created; 
  FileHistoryLib.HistoryEntryType entryType2 = FileHistoryLib.HistoryEntryType.Modified;
  FileHistoryLib.HistoryEntryType entryType3 = FileHistoryLib.HistoryEntryType.Modified; 
  
  string byUser1 = 'User1ID';
  string byUser2 = 'User2ID';
  string byUser3 = 'User3ID';

  uint256 entryTimestampMiliseconds1 = 100000;
  uint256 entryTimestampMiliseconds2 = entryTimestampMiliseconds1 + 100000;
  uint256 entryTimestampMiliseconds3 = entryTimestampMiliseconds2 + 100000;

  uint64 fileSizeBytes1 = 1024; 
  uint64 fileSizeBytes2 = 2048; 
  uint64 fileSizeBytes3 = 4096; 

  function testShouldStoreMultipleEntries() public { 
    FileHistory historyContract = FileHistory(DeployedAddresses.FileHistory());

    historyContract.storeEntry(filePath, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1);
    historyContract.storeEntry(filePath, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2);
    historyContract.storeEntry(filePath, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3);

    FileHistoryLib.HistoryEntry[] memory entries = historyContract.getEntries(filePath);

    Assert.equal(entries.length, 3, "Entries have not been stored correctly.");

    Assert.equal(uint256(entries[0].entryType), uint256(entryType1), "Property \"entryType\" has not been stored correctly for the first entry.");
    Assert.equal(entries[0].byUser, byUser1, "Property \"byUser\" has not been stored correctly for the first entry.");
    Assert.equal(entries[0].entryTimestamp, entryTimestampMiliseconds1, "Property \"entryTimestamp\" has not been stored correctly for the first entry.");
    Assert.equal(entries[0].fileSize, fileSizeBytes1, "Property \"fileSize\" has not been stored correctly for the first entry.");

    Assert.equal(uint256(entries[1].entryType), uint256(entryType2), "Property \"entryType\" has not been stored correctly for the second entry.");
    Assert.equal(entries[1].byUser, byUser2, "Property \"byUser\" has not been stored correctly for the second entry.");
    Assert.equal(entries[1].entryTimestamp, entryTimestampMiliseconds2, "Property \"entryTimestamp\" has not been stored correctly for the second entry.");
    Assert.equal(entries[1].fileSize, fileSizeBytes2, "Property \"fileSize\" has not been stored correctly for the second entry.");

    Assert.equal(uint256(entries[2].entryType), uint256(entryType3), "Property \"entryType\" has not been stored correctly for the third entry.");
    Assert.equal(entries[2].byUser, byUser3, "Property \"byUser\" has not been stored correctly for the third entry.");
    Assert.equal(entries[2].entryTimestamp, entryTimestampMiliseconds3, "Property \"entryTimestamp\" has not been stored correctly for the third entry.");
    Assert.equal(entries[2].fileSize, fileSizeBytes3, "Property \"fileSize\" has not been stored correctly for the third entry.");

    // Testing to check if no Entries are returned for yet another file. 
    FileHistoryLib.HistoryEntry[] memory anotherFileEntries = historyContract.getEntries(anotherFilePath);

    Assert.equal(anotherFileEntries.length, 0, "Error on entries storage. Returned entries that have not been stored.");
  }
}