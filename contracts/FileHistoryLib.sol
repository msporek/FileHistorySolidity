// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

/**
 * @title Library with basic types for storing file history entries on the blockchain. 
 * @author Michal Sporek
 */
library FileHistoryLib { 

    /**
     * @dev Enumeration represents possible values for the type of a history entry: Created, Modified, Deleted. 
     */
    enum HistoryEntryType { Created, Modified, Deleted }

    /**
     * @dev Structure wraps the details of a history entry to be stored on the blockchain. 
     */
    struct HistoryEntry { 
        HistoryEntryType entryType;
        string byUser;
        uint256 entryTimestamp;
        uint64 fileSize;
    }

    /** 
     * @dev Structure represents an array of history entries. 
     */
    struct History { 
        HistoryEntry[] entries;
    }
}