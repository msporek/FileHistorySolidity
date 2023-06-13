const FileHistory = artifacts.require("FileHistory");

contract('FileHistory', (accounts) => {

  it('should get empty list of operations on a file with no operations (calling getOperations()).', async () => {
    const fileHistoryInstance = await FileHistory.deployed();

    const filePath = '\\\\Share\\File1.txt';
    const operations = await fileHistoryInstance.getOperations.call(filePath);

    assert.ok(operations, "Call to getOperations() has failed.");
    assert.equal(operations.length, 0, "Operations failed.");
  });

  it('should store single file entry correctly', async () => {
    const fileHistoryInstance = await FileHistory.deployed();

    // Store file history
    const filePath = '\\\\Share\\File1.txt';
    const entryType = 0 // File Created; 
    const byUser = 'User1ID';
    const entryTimestampMiliseconds = new Date().valueOf();
    const fileSizeBytes = 1024; 

    await fileHistoryInstance.trackOperation(filePath, entryType, byUser, entryTimestampMiliseconds, fileSizeBytes, { from: accounts[0] });

    // Get the operations to see if they have been stored. 
    const operations = await fileHistoryInstance.getOperations.call(filePath);

    assert.ok(operations, "Call to getOperations() has failed.");
    assert.equal(operations.length, 1, "Operations have not been stored correctly.");
    assert.equal(operations[0].entryType, entryType, "Operation \"entrytype\" has not been stored correctly.");
    assert.equal(operations[0].byUser, byUser, "Operation \"byUser\" has not been stored correctly.");
    assert.equal(operations[0].entryTimestamp, entryTimestampMiliseconds, "Operation \"entryTimestamp\" has not been stored correctly.");
    assert.equal(operations[0].fileSize, fileSizeBytes, "Operation \"fileSize\" has not been stored correctly.");

    // Checking if nothing is returned for another file. 
    const anotherFilePath = '\\\\Share\\File2.txt';
    const anotherFileOperations = await fileHistoryInstance.getOperations.call(anotherFilePath);
    assert.ok(anotherFileOperations, "Call to getOperations() has failed.");
    assert.equal(anotherFileOperations.length, 0, "Error on operations storage. Returned operation of another file.");
  });

});