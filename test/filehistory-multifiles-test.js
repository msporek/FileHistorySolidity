const FileHistory = artifacts.require("FileHistory");

// Testing the FileHistory contract with scenarios that involve storing multiple history entries 
// for multiple files on the blockchain and retrieving them with a number of ways.  
contract('FileHistory', (accounts) => {

  it('should store entries for multiple files correctly', async () => {
    const fileHistoryInstance = await FileHistory.new();

    // Store file history
    const filePath1 = '\\\\Share\\File1.txt';
    const filePath2 = '\\\\Share\\File2.txt';
    const entryType1 = 0 // File Created; 
    const entryType2 = 1 // File Modified;
    const byUser1 = 'User1ID';
    const byUser2 = 'User2ID';
    const entryTimestampMiliseconds1 = new Date().valueOf();
    const entryTimestampMiliseconds2 = new Date().valueOf();
    const fileSizeBytes1 = 1024; 
    const fileSizeBytes2 = 1024; 

    await fileHistoryInstance.storeEntry(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath2, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });

    // Get the Entries to see if they have been stored. 
    const entries1 = await fileHistoryInstance.getEntries.call(filePath1);

    const entries2 = await fileHistoryInstance.getEntries.call(filePath2);

    assert.ok(entries1, `Call to getEntries() has failed for file ${filePath1}.`);
    assert.equal(entries1.length, 1, `Entries for file ${filePath1} were not stored correctly.`);

    assert.ok(entries2, `Call to getEntries() has failed for file ${filePath2}.`);
    assert.equal(entries2.length, 1, `Entries for file ${filePath2} were not stored correctly.`);

    // Checking if nothing is returned for another file. 
    const filePath3 = '\\\\Share\\File3.txt';
    const entries3 = await fileHistoryInstance.getEntries.call(filePath3);
    assert.ok(entries3, `Call to getEntries() has failed for file ${filePath3}.`);
    assert.equal(entries3.length, 0, `Entries for file ${filePath3} were not stored correctly.`);
  });

});