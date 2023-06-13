const FileHistory = artifacts.require("FileHistory");

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

    await fileHistoryInstance.trackOperation(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath2, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });

    // Get the operations to see if they have been stored. 
    const operations1 = await fileHistoryInstance.getOperations.call(filePath1);

    const operations2 = await fileHistoryInstance.getOperations.call(filePath2);

    assert.ok(operations1, `Call to getOperations() has failed for file ${filePath1}.`);
    assert.equal(operations1.length, 1, `Operations for file ${filePath1} were not stored correctly.`);

    assert.ok(operations2, `Call to getOperations() has failed for file ${filePath2}.`);
    assert.equal(operations2.length, 1, `Operations for file ${filePath2} were not stored correctly.`);

    // Checking if nothing is returned for another file. 
    const filePath3 = '\\\\Share\\File3.txt';
    const operations3 = await fileHistoryInstance.getOperations.call(filePath3);
    assert.ok(operations3, `Call to getOperations() has failed for file ${filePath3}.`);
    assert.equal(operations3.length, 0, `Operations for file ${filePath3} were not stored correctly.`);
  });

});