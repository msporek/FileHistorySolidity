# FileHistorySolidity
A free version of a library created for tracking history of multiple files in file systems (Solidity, JavaScript).

The smart contract allows storing information about operations executed on files in a file system and the file history is stored in the Blockchain storage. It is then possible to retrieve history entries for operations of a particular file. The logic supports returning filtered history entry operations. 

Functionalities implemented: 
- 
**FileHistoryLib** - A Solidity library that comes with basic type definitions. 

**FileHistory** - A contract that allows tracking file history changes for multiple files, individually for each file. Stores information about file path, type of change, time of change, the file system user who has made the change, and file size. It comes with functionalities that allow retrieving file history information for individual files. One can retrieve the full history from the blockchain, i.e. all history entries (```getEntries()```), or a just a piece of the history in a time range (```getEntriesInTimeRange()```) or history that starts at a given point of time (```getEntriesStartingAt()```). 

Implemented a basic coverage of unit tests in JavaScript and Solidity using the Truffle framework.

Dependencies: 
- 
- Solidity
- Truffle
