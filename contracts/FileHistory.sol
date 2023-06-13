// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 < 0.9.0;

import "./FileHistoryLib.sol";

/// @title A contract for tracking history of multiple files in Ethereum and Ethereum-compatible blockchain. 
/// @author Michal Sporek
/// @notice Allows storing info about file operations history and retrieving the entries from the blockchain. 
contract FileHistory {

    mapping(string => FileHistoryLib.History) allFileHistories; 

    /// @dev Returns an array of all history entries for given file.
    /// @param _filePath File path.  
    /// @return Array of history entries.
    function getOperations(
        string memory _filePath
    ) public view returns (FileHistoryLib.HistoryEntry[] memory) { 
        require(bytes(_filePath).length > 0);

        return allFileHistories[_filePath].entries;
    }

    /// @dev Filters provided array of history entries using the provided filter. 
    /// @param entries Array of history entries to be filtered. 
    /// @param filter Filter function to be used. 
    /// @return Dynamic array with history entries.
    function filterHistoryEntries(
        FileHistoryLib.HistoryEntry[] memory entries, 
        function(FileHistoryLib.HistoryEntry memory) internal view returns (bool) filter
    ) internal view returns (FileHistoryLib.HistoryEntry[] memory) {
            
        uint numberOfEntries = 0;
        bool[] memory entryInTimeRange = new bool[](entries.length);
        for (uint hIndex = 0; hIndex < entries.length; hIndex++) {

            bool shouldReturn = filter(entries[hIndex]);
            if (shouldReturn) { 
                entryInTimeRange[hIndex] = true;
                numberOfEntries++;
            }
        }

        FileHistoryLib.HistoryEntry[] memory returnEntries = new FileHistoryLib.HistoryEntry[](numberOfEntries);
        uint indexOfReturnEntries = 0;
        for (uint hIndex = 0; hIndex < entries.length; hIndex++) { 
            if (entryInTimeRange[hIndex]) {
                returnEntries[indexOfReturnEntries++] = entries[hIndex];
            }
        }

        return returnEntries;
    }

    /// @dev Returns a list of all history entries for given file that have happened at the given timestamp, or later. 
    /// @param _filePath File path. 
    /// @param _timeStart Start time to filter history entries. 
    /// @return Array of history entries. 
    function getOperationsStartingAt(
        string memory _filePath, 
        uint _timeStart
    ) public view returns (FileHistoryLib.HistoryEntry[] memory) {
        require(bytes(_filePath).length > 0);

        return getOperationsInTimeRange(_filePath, _timeStart, type(uint256).max);
    }

    /// @dev Returns a list of all history entries for given file that have happened in a given time range. 
    /// @param _filePath File path. 
    /// @param _timeStart Start of time range. 
    /// @param _timeEnd End of time range. 
    /// @return Array of history entries. 
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

    /// @dev Stores information about file operation in the history on the blockchain. 
    /// @param _filePath File path. 
    /// @param _entryType Type of history entry. 
    /// @param _byUser Identifier of the user who has made the change. 
    /// @param _entryTimestamp When the file operation has occured. 
    /// @param _fileSize Size of the file after the operation has completed. 
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

    /// @dev Creates a new instance of the contract. 
    constructor() { 
        // Contract initialization code goes here. 
    }
}