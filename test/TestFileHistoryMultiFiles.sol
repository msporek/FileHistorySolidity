// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/FileHistory.sol";

/// @title Test FileHistory contract's ability to store Entries for multiple files and retrieving these Entries. 
/// @author Michal Sporek 
contract TestFileHistoryMultiFiles { 

  string filePath1 = '\\\\Share\\File1.txt';
  string filePath2 = '\\\\Share\\File2.txt';
  string filePath3 = '\\\\Share\\File3.txt';

  string anotherFilePath = '\\\\Share\\AnotherFile.txt';

  FileHistoryLib.HistoryEntryType entryType1 = FileHistoryLib.HistoryEntryType.Created; 
  FileHistoryLib.HistoryEntryType entryType2 = FileHistoryLib.HistoryEntryType.Modified;
  FileHistoryLib.HistoryEntryType entryType3 = FileHistoryLib.HistoryEntryType.Modified; 
  
  string byUser1 = 'User1ID';
  string byUser2 = 'User2ID';
  string byUser3 = 'User3ID';

  uint256 entryTimestampMiliseconds1 = 100000;
  uint256 entryTimestampMiliseconds2 = 200000;
  uint256 entryTimestampMiliseconds3 = 400000;

  uint64 fileSizeBytes1 = 1024; 
  uint64 fileSizeBytes2 = 2048; 
  uint64 fileSizeBytes3 = 4096; 

  function testShouldStoreEntriesForMultipleFiles() public { 
    FileHistory historyContract = FileHistory(DeployedAddresses.FileHistory());

    historyContract.storeEntry(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1);
    historyContract.storeEntry(filePath2, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2);
    historyContract.storeEntry(filePath3, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3);

    FileHistoryLib.HistoryEntry[] memory entries1 = historyContract.getEntries(filePath1);
    FileHistoryLib.HistoryEntry[] memory entries2 = historyContract.getEntries(filePath2);
    FileHistoryLib.HistoryEntry[] memory entries3 = historyContract.getEntries(filePath3);

    Assert.equal(entries1.length, 1, "Entries for the first file have not been stored correctly.");
    Assert.equal(uint256(entries1[0].entryType), uint256(entryType1), "Entry \"entryType\" has not been stored correctly for the first file.");
    Assert.equal(entries1[0].byUser, byUser1, "Entry \"byUser\" has not been stored correctly for the first file.");
    Assert.equal(entries1[0].entryTimestamp, entryTimestampMiliseconds1, "Entry \"entryTimestamp\" has not been stored correctly for the first file.");
    Assert.equal(entries1[0].fileSize, fileSizeBytes1, "Entry \"fileSize\" has not been stored correctly for the first file.");

    Assert.equal(entries2.length, 1, "Entries for the second file have not been stored correctly.");
    Assert.equal(uint256(entries2[0].entryType), uint256(entryType2), "Entry \"entryType\" has not been stored correctly for the second file.");
    Assert.equal(entries2[0].byUser, byUser2, "Entry \"byUser\" has not been stored correctly for the second file.");
    Assert.equal(entries2[0].entryTimestamp, entryTimestampMiliseconds2, "Entry \"entryTimestamp\" has not been stored correctly for the second file.");
    Assert.equal(entries2[0].fileSize, fileSizeBytes2, "Entry \"fileSize\" has not been stored correctly for the second file.");

    Assert.equal(entries3.length, 1, "Entries for the third file have not been stored correctly.");
    Assert.equal(uint256(entries3[0].entryType), uint256(entryType3), "Entry \"entryType\" has not been stored correctly for the third file.");
    Assert.equal(entries3[0].byUser, byUser3, "Entry \"byUser\" has not been stored correctly for the third file.");
    Assert.equal(entries3[0].entryTimestamp, entryTimestampMiliseconds3, "Entry \"entryTimestamp\" has not been stored correctly for the third file.");
    Assert.equal(entries3[0].fileSize, fileSizeBytes3, "Entry \"fileSize\" has not been stored correctly for the third file.");

    // Testing to check if no Entries are returned for yet another file. 
    FileHistoryLib.HistoryEntry[] memory anotherFileEntries = historyContract.getEntries(anotherFilePath);

    Assert.equal(anotherFileEntries.length, 0, "Error on Entries storage. Returned Entries that have not been stored.");
  }
}