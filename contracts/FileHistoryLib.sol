// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 < 0.9.0;

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