// SPDX-License-Identifier: MIT

pragma solidity >=0.8.20 < 0.9.0;

/// @title Library with basic types for storing file history entries on the blockchain. 
/// @author Michal Sporek
library FileHistoryLib { 

    enum HistoryEntryType { Created, Modified, Deleted }

    struct HistoryEntry { 
        HistoryEntryType entryType;
        string byUser;
        uint entryTimestamp;
        uint fileSize;
    }

    struct History { 
        HistoryEntry[] entries;
    }
}