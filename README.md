# FileHistorySolidity
A free version of a library created for tracking history of multiple files in file systems (Solidity, JavaScript).

Functionalities implemented: 
- 
**FileHistoryLib** - A Solidity library that comes with basic type definitions. 

**FileHistory** - A contract that allows tracking file history changes for multiple files, individually for each file. Stores information about file path, type of change, time of change, the file system user who has made the change, and file size. It comes with functionalities that allow retrieving file history information for individual files. One can retrieve the full history from the blockchain, i.e. all history entries (```getEntries()```), or a just a piece of the history in a time range (```getEntriesInTimeRange()```) or history that starts at a given point of time (```getEntriesStartingAt()```). 

Implemented a basic coverage of unit tests (Truffle).

Dependencies: 
- 
- Solidity
- Truffle
