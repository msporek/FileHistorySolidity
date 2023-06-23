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

// Testing the FileHistory contract with scenarios that involve storing multiple history entries 
// for a single file on the blockchain and retrieving them with a number of ways.  
contract('FileHistory', (accounts) => {

  it('should store multiple entries and return then correctly', async () => {
    const fileHistoryInstance = await FileHistory.new();
    const otherFileHistoryInstance = await FileHistory.new();

    // Store file history 
    await fileHistoryInstance.storeEntry(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath1, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath1, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3, { from: accounts[0] });

    // Get the entries to see if they have been stored. 
    const entries = await fileHistoryInstance.getEntries.call(filePath1);

    assert.ok(entries, `Call to getEntries() has failed for file ${filePath1}.`);
    assert.equal(entries.length, 3, `Entries for file ${filePath1} were not stored correctly.`);

    // Get the entries from the other instance of the contract. 
    const otherInstanceEntries = await otherFileHistoryInstance.getEntries.call(filePath1);
    assert.ok(otherInstanceEntries, `Call to getEntries() has failed for file ${filePath1} on the other instance of the contract.`);
    assert.equal(otherInstanceEntries.length, 0, `Entries for file ${filePath1} were not stored correctly. They are available on the other instance of the contract.`);
  });

  it('should store multiple entries and return them with a call to getEntriesInTimeRange()', async () => {
    const fileHistoryInstance = await FileHistory.new();

    // Store file history 
    await fileHistoryInstance.storeEntry(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath1, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath1, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3, { from: accounts[0] });

    // Get the Entries to see if they have been stored. 
    const fullTimeRangeEntries = await fileHistoryInstance.getEntriesInTimeRange.call(filePath1, entryTimestampMiliseconds1, entryTimestampMiliseconds3);
    const twoFirstEntries = await fileHistoryInstance.getEntriesInTimeRange.call(filePath1, entryTimestampMiliseconds1, entryTimestampMiliseconds2);
    const onlyFirstEntry = await fileHistoryInstance.getEntriesInTimeRange.call(filePath1, entryTimestampMiliseconds1, entryTimestampMiliseconds1 + 1000);
    const noEntries1 = await fileHistoryInstance.getEntriesInTimeRange.call(filePath1, entryTimestampMiliseconds3 + 100000, entryTimestampMiliseconds3 + 200000);
    const noEntries2 = await fileHistoryInstance.getEntriesInTimeRange.call(filePath1, entryTimestampMiliseconds1 - 200000, entryTimestampMiliseconds1 - 100000);

    assert.ok(fullTimeRangeEntries, `Call to getEntriesInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(fullTimeRangeEntries.length, 3, `Entries for file ${filePath1} were not returned correctly for the full time range.`);

    assert.ok(twoFirstEntries, `Call to getEntriesInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(twoFirstEntries.length, 2, `Entries for file ${filePath1} were not returned correctly for the reduced time range (expected 2 entries).`);

    assert.ok(onlyFirstEntry, `Call to getEntriesInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(onlyFirstEntry.length, 1, `Entries for file ${filePath1} were not returned correctly for the reduced time range (expected 1 entry).`);
    
    assert.ok(noEntries1, `Call to getEntriesInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(noEntries1.length, 0, `Entries for file ${filePath1} were not returned correctly for the time range with no Entries - later in time (expected 0 results).`);

    assert.ok(noEntries2, `Call to getEntriesInTimeRange() has failed for file ${filePath1}.`);
    assert.equal(noEntries2.length, 0, `Entries for file ${filePath1} were not returned correctly for the time range with no Entries - earlier in time (expected 0 results).`);
  });

  it('should store multiple entries and return them with a call to getEntriesStartingAt()', async () => {
    const fileHistoryInstance = await FileHistory.new();

    // Store file history 
    await fileHistoryInstance.storeEntry(filePath1, entryType1, byUser1, entryTimestampMiliseconds1, fileSizeBytes1, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath1, entryType2, byUser2, entryTimestampMiliseconds2, fileSizeBytes2, { from: accounts[0] });
    await fileHistoryInstance.storeEntry(filePath1, entryType3, byUser3, entryTimestampMiliseconds3, fileSizeBytes3, { from: accounts[0] });

    // Get the Entries to see if they have been stored. 
    const fullTimeRangeEntries1 = await fileHistoryInstance.getEntriesStartingAt.call(filePath1, entryTimestampMiliseconds1);
    const fullTimeRangeEntries2 = await fileHistoryInstance.getEntriesStartingAt.call(filePath1, entryTimestampMiliseconds1 - 100000);
    const twoLastEntries = await fileHistoryInstance.getEntriesStartingAt.call(filePath1, entryTimestampMiliseconds2);
    const onlyTheLastEntry = await fileHistoryInstance.getEntriesStartingAt.call(filePath1, entryTimestampMiliseconds3);
    const noEntries = await fileHistoryInstance.getEntriesStartingAt.call(filePath1, entryTimestampMiliseconds3 + 100000);

    assert.ok(fullTimeRangeEntries1, `Call to getEntriesStartingAt() has failed for file ${filePath1}.`);
    assert.equal(fullTimeRangeEntries1.length, 3, `Entries for file ${filePath1} were not returned correctly for the full time range.`);

    assert.ok(fullTimeRangeEntries2, `Call to getEntriesStartingAt() has failed for file ${filePath1}.`);
    assert.equal(fullTimeRangeEntries2.length, 3, `Entries for file ${filePath1} were not returned correctly for the full time range (earlier range).`);

    assert.ok(twoLastEntries, `Call to getEntriesStartingAt() has failed for file ${filePath1}.`);
    assert.equal(twoLastEntries.length, 2, `Entries for file ${filePath1} were not returned correctly for the reduced time range (expected 2 entry).`);

    assert.ok(onlyTheLastEntry, `Call to getEntriesStartingAt() has failed for file ${filePath1}.`);
    assert.equal(onlyTheLastEntry.length, 1, `Entries for file ${filePath1} were not returned correctly for the reduced time range (expected 1 entry).`);
    
    assert.ok(noEntries, `Call to getEntriesStartingAt() has failed for file ${filePath1}.`);
    assert.equal(noEntries.length, 0, `Entries for file ${filePath1} were not returned correctly for the time range with no Entries - later in time (expected 0 results).`);
  });

});