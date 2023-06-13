const FileHistory = artifacts.require("FileHistory");

const filePath1 = '\\\\Share\\File1.txt'; 

const entryType1 = 0 // File Created; 
const entryType2 = 1 // File Modified; 
const entryType3 = 1 // File Deleted; 

const byUser1 = 'User1ID';
const byUser2 = 'User2ID';
const byUser3 = 'User3ID';

const entryTimestampMiliseconds1 = new Date().valueOf();
const entryTimestampMiliseconds2 = entryTimestampMiliseconds1 + 30000;
const entryTimestampMiliseconds3 = entryTimestampMiliseconds1 + 60000;

const fileSizeBytes1 = 1024; 
const fileSizeBytes2 = 2048;
const fileSizeBytes3 = 4096; 

contract('FileHistory', (accounts) => {

  it('should store multiple entries and return then correctly', async () => {
    const fileHistoryInstance = await FileHistory.new();
    const otherFileHistoryInstance = await FileHistory.new();

    // Store file history 
    await fileHistoryInstance.trackOperation(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath1, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath1, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3, { from: accounts[0] });

    // Get the operations to see if they have been stored. 
    const operations = await fileHistoryInstance.getOperations.call(filePath1);

    assert.ok(operations, `Call to getOperations() has failed for file ${filePath1}.`);
    assert.equal(operations.length, 3, `Operations for file ${filePath1} were not stored correctly.`);

    // Get the operations from the other instance of the contract. 
    const otherInstanceOperations = await otherFileHistoryInstance.getOperations.call(filePath1);
    assert.ok(otherInstanceOperations, `Call to getOperations() has failed for file ${filePath1} on the other instance of the contract.`);
    assert.equal(otherInstanceOperations.length, 0, `Operations for file ${filePath1} were not stored correctly. They are available on the other instance of the contract.`);
  });

  it('should store multiple entries and return them with a call to getOperationsInTimeRange()', async () => {
    const fileHistoryInstance = await FileHistory.new();

    // Store file history 
    await fileHistoryInstance.trackOperation(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath1, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath1, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3, { from: accounts[0] });

    // Get the operations to see if they have been stored. 
    const fullTimeRangeOperations = await fileHistoryInstance.getOperationsInTimeRange.call(filePath1, entryTimestampMiliseconds1, entryTimestampMiliseconds3);
    const twoFirstOperations = await fileHistoryInstance.getOperationsInTimeRange.call(filePath1, entryTimestampMiliseconds1, entryTimestampMiliseconds2);
    const onlyFirstOperation = await fileHistoryInstance.getOperationsInTimeRange.call(filePath1, entryTimestampMiliseconds1, entryTimestampMiliseconds1 + 1000);
    const noOperations1 = await fileHistoryInstance.getOperationsInTimeRange.call(filePath1, entryTimestampMiliseconds3 + 100000, entryTimestampMiliseconds3 + 200000);
    const noOperations2 = await fileHistoryInstance.getOperationsInTimeRange.call(filePath1, entryTimestampMiliseconds1 - 200000, entryTimestampMiliseconds1 - 100000);

    assert.ok(fullTimeRangeOperations, `Call to getOperationsInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(fullTimeRangeOperations.length, 3, `Operations for file ${filePath1} were not returned correctly for the full time range.`);

    assert.ok(twoFirstOperations, `Call to getOperationsInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(twoFirstOperations.length, 2, `Operations for file ${filePath1} were not returned correctly for the reduced time range (expected 2 operation2).`);

    assert.ok(onlyFirstOperation, `Call to getOperationsInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(onlyFirstOperation.length, 1, `Operations for file ${filePath1} were not returned correctly for the reduced time range (expected 1 operation).`);
    
    assert.ok(noOperations1, `Call to getOperationsInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(noOperations1.length, 0, `Operations for file ${filePath1} were not returned correctly for the time range with no operations - later in time (expected 0 results).`);

    assert.ok(noOperations2, `Call to getOperationsInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(noOperations2.length, 0, `Operations for file ${filePath1} were not returned correctly for the time range with no operations - earlier in time (expected 0 results).`);
  });

  it('should store multiple entries and return them with a call to getOperationsStartingAt()', async () => {
    const fileHistoryInstance = await FileHistory.new();

    // Store file history 
    await fileHistoryInstance.trackOperation(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath1, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });
    await fileHistoryInstance.trackOperation(filePath1, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3, { from: accounts[0] });

    // Get the operations to see if they have been stored. 
    const fullTimeRangeOperations1 = await fileHistoryInstance.getOperationsStartingAt.call(filePath1, entryTimestampMiliseconds1);
    const fullTimeRangeOperations2 = await fileHistoryInstance.getOperationsStartingAt.call(filePath1, entryTimestampMiliseconds1 - 100000);
    const twoLastOperations = await fileHistoryInstance.getOperationsStartingAt.call(filePath1, entryTimestampMiliseconds2);
    const onlyTheLastOperation = await fileHistoryInstance.getOperationsStartingAt.call(filePath1, entryTimestampMiliseconds3);
    const noOperations = await fileHistoryInstance.getOperationsStartingAt.call(filePath1, entryTimestampMiliseconds3 + 100000);

    assert.ok(fullTimeRangeOperations1, `Call to getOperationsStartingAt() has failed for file ${filePath1}.`);
    assert.equal(fullTimeRangeOperations1.length, 3, `Operations for file ${filePath1} were not returned correctly for the full time range.`);

    assert.ok(fullTimeRangeOperations2, `Call to getOperationsStartingAt() has failed for file ${filePath1}.`);
    assert.equal(fullTimeRangeOperations2.length, 3, `Operations for file ${filePath1} were not returned correctly for the full time range (earlier range).`);

    assert.ok(twoLastOperations, `Call to getOperationsStartingAt() has failed for file ${filePath1}.`);
    assert.equal(twoLastOperations.length, 2, `Operations for file ${filePath1} were not returned correctly for the reduced time range (expected 2 operation2).`);

    assert.ok(onlyTheLastOperation, `Call to getOperationsStartingAt() has failed for file ${filePath1}.`);
    assert.equal(onlyTheLastOperation.length, 1, `Operations for file ${filePath1} were not returned correctly for the reduced time range (expected 1 operation).`);
    
    assert.ok(noOperations, `Call to getOperationsStartingAt() has failed for file ${filePath1}.`);
    assert.equal(noOperations.length, 0, `Operations for file ${filePath1} were not returned correctly for the time range with no operations - later in time (expected 0 results).`);
  });

});