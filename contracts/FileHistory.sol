// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 < 0.9.0;

import "./FileHistoryLib.sol";

contract FileHistory {

    mapping(string => FileHistoryLib.History) allFileHistories; 

    function getOperations(
        string memory _filePath
    ) public view returns (FileHistoryLib.HistoryEntry[] memory) { 
        require(bytes(_filePath).length > 0);

        return allFileHistories[_filePath].entries;
    }

    function getOperationsInTimeRange(
        string memory _filePath, 
        uint _timeStart, 
        uint _timeEnd
    ) public view returns (FileHistoryLib.HistoryEntry[] memory) {
        require(bytes(_filePath).length > 0);
        require(_timeStart < _timeEnd);

        FileHistoryLib.History memory history = allFileHistories[_filePath];

        uint numberOfEntries = 0;
        bool[] memory entryInTimeRange = new bool[](history.entries.length);
        for (uint hIndex = 0; hIndex < history.entries.length; hIndex++) {
            bool shouldReturn = 
                history.entries[hIndex].entryTimestamp >= _timeStart && 
                history.entries[hIndex].entryTimestamp <= _timeEnd;

            if (shouldReturn) { 
                entryInTimeRange[hIndex] = true;
                numberOfEntries++;
            }
        }

        FileHistoryLib.HistoryEntry[] memory returnEntries = new FileHistoryLib.HistoryEntry[](numberOfEntries);
        uint indexOfReturnEntries = 0;
        for (uint hIndex = 0; hIndex < history.entries.length; hIndex++) { 
            if (entryInTimeRange[hIndex]) {
                returnEntries[indexOfReturnEntries++] = history.entries[hIndex];
            }
        }
        return returnEntries;
    }

    function trackOperation(
        string memory _filePath,
        FileHistoryLib.HistoryEntryType _entryType, 
        string memory _byUser,
        uint _entryTimestamp, 
        uint _fileSize
    ) public { 
        require(bytes(_filePath).length > 0);
        require(bytes(_byUser).length > 0);

        FileHistoryLib.History storage history = allFileHistories[_filePath];
        history.entries.push(FileHistoryLib.HistoryEntry(_entryType, _byUser, _entryTimestamp, _fileSize));
    }

    constructor() { 
        // Contract initialization code goes here. 
    }
}