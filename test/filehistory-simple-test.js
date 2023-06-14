const FileHistory = artifacts.require("FileHistory");

contract('FileHistory', (accounts) => {

  it('should get empty list of Entries on a file with no Entries (calling getEntries()).', async () => {
    const fileHistoryInstance = await FileHistory.deployed();

    const filePath = '\\\\Share\\File1.txt';
    const entries = await fileHistoryInstance.getEntries.call(filePath);

    assert.ok(entries, "Call to getEntries() has failed. Expected return value.");
    assert.equal(entries.length, 0, "Call to getEntries() has failed. Expected empty array of results.");
  });

  it('should store single file entry correctly', async () => {
    const fileHistoryInstance = await FileHistory.deployed();

    // Store file history
    const filePath = '\\\\Share\\File1.txt';
    const entryType = 0 // File Created; 
    const byUser = 'User1ID';
    const entryTimestampMiliseconds = new Date().valueOf();
    const fileSizeBytes = 1024; 

    await fileHistoryInstance.storeEntry(filePath, entryType, byUser, entryTimestampMiliseconds, fileSizeBytes, { from: accounts[0] });

    // Get the Entries to see if they have been stored. 
    const entries = await fileHistoryInstance.getEntries.call(filePath);

    assert.ok(entries, "Call to getEntries() has failed.");
    assert.equal(entries.length, 1, "Entries have not been stored correctly.");
    assert.equal(entries[0].entryType, entryType, "Entry \"entryType\" has not been stored correctly.");
    assert.equal(entries[0].byUser, byUser, "Entry \"byUser\" has not been stored correctly.");
    assert.equal(entries[0].entryTimestamp, entryTimestampMiliseconds, "Entry \"entryTimestamp\" has not been stored correctly.");
    assert.equal(entries[0].fileSize, fileSizeBytes, "Entry \"fileSize\" has not been stored correctly.");

    // Checking if nothing is returned for another file. 
    const anotherFilePath = '\\\\Share\\File2.txt';
    const anotherFileEntries = await fileHistoryInstance.getEntries.call(anotherFilePath);
    assert.ok(anotherFileEntries, "Call to getEntries() has failed.");
    assert.equal(anotherFileEntries.length, 0, "Error on Entries storage. Returned entry of another file.");
  });

});