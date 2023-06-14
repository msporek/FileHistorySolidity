// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/FileHistory.sol";

/// @title Test FileHistory contract's getEntriesInTimeRange() function.  
/// @author Michal Sporek 
contract TestFileHistoryGetWithTimeRange { 

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

  function testShouldReturnEntriesWithTimeRange() public { 
    FileHistory historyContract = FileHistory(DeployedAddresses.FileHistory());

    historyContract.storeEntry(filePath, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1);
    historyContract.storeEntry(filePath, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2);
    historyContract.storeEntry(filePath, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3);

    FileHistoryLib.HistoryEntry[] memory fullTimeRangeEntries = historyContract.getEntriesInTimeRange(filePath, entryTimestampMiliseconds1, entryTimestampMiliseconds3);
    FileHistoryLib.HistoryEntry[] memory twoFirstEntries = historyContract.getEntriesInTimeRange(filePath, entryTimestampMiliseconds1, entryTimestampMiliseconds2);
    FileHistoryLib.HistoryEntry[] memory onlyFirstEntry = historyContract.getEntriesInTimeRange(filePath, entryTimestampMiliseconds1, entryTimestampMiliseconds1 + 1000);
    FileHistoryLib.HistoryEntry[] memory noEntries1 = historyContract.getEntriesInTimeRange(filePath, entryTimestampMiliseconds3 + 1, entryTimestampMiliseconds3 + 2);
    FileHistoryLib.HistoryEntry[] memory noEntries2 = historyContract.getEntriesInTimeRange(filePath, 0, entryTimestampMiliseconds1 - 1);

    Assert.equal(fullTimeRangeEntries.length, 3, "Entries were not returned correctly for the full time range.");
    Assert.equal(twoFirstEntries.length, 2, "Entries were not returned correctly for the range with two entries.");
    Assert.equal(onlyFirstEntry.length, 1, "Entries were not returned correctly for the range with a single entry.");
    Assert.equal(noEntries1.length, 0, "Entries were not returned correctly for the range with no entries.");
    Assert.equal(noEntries2.length, 0, "Entries were not returned correctly for the range with no entries.");

    // Testing to check if no eEntries are returned for yet another file. 
    FileHistoryLib.HistoryEntry[] memory anotherFileEntries = historyContract.getEntries(anotherFilePath);

    Assert.equal(anotherFileEntries.length, 0, "Error on Entries storage. Returned entries that have not been stored.");
  }
}