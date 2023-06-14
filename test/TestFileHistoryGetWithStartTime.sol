// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/FileHistory.sol";

/// @title Test FileHistory contract's getEntriesStartingAt() function.  
/// @author Michal Sporek 
contract TestFileHistoryGetWithStartTime { 

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

  function testShouldReturnEntriesWithStartTime() public { 
    FileHistory historyContract = FileHistory(DeployedAddresses.FileHistory());

    historyContract.storeEntry(filePath, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1);
    historyContract.storeEntry(filePath, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2);
    historyContract.storeEntry(filePath, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3);

    FileHistoryLib.HistoryEntry[] memory fullTimeRangeEntries1 = historyContract.getEntriesStartingAt(filePath, entryTimestampMiliseconds1);
    FileHistoryLib.HistoryEntry[] memory fullTimeRangeEntries2 = historyContract.getEntriesStartingAt(filePath, entryTimestampMiliseconds1 - 1);
    FileHistoryLib.HistoryEntry[] memory twoLastEntries = historyContract.getEntriesStartingAt(filePath, entryTimestampMiliseconds2);
    FileHistoryLib.HistoryEntry[] memory onlyTheLastEntry = historyContract.getEntriesStartingAt(filePath, entryTimestampMiliseconds3);
    FileHistoryLib.HistoryEntry[] memory noEntries = historyContract.getEntriesStartingAt(filePath, entryTimestampMiliseconds3 + 1);

    Assert.equal(fullTimeRangeEntries1.length, 3, "Entries were not returned correctly for the full time range.");
    Assert.equal(fullTimeRangeEntries2.length, 3, "Entries were not returned correctly for the full time range.");
    Assert.equal(twoLastEntries.length, 2, "Entries were not returned correctly for the range with two entries.");
    Assert.equal(onlyTheLastEntry.length, 1, "Entries were not returned correctly for the range with only one entry.");
    Assert.equal(noEntries.length, 0, "Entries were not returned correctly for the range with no entries.");

    // Testing to check if no entries are returned for yet another file. 
    FileHistoryLib.HistoryEntry[] memory anotherFileEntries = historyContract.getEntries(anotherFilePath);

    Assert.equal(anotherFileEntries.length, 0, "Error on entries storage. Returned Entries that have not been stored.");
  }
}