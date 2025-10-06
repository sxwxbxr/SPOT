const dbName = 'spot-offline';
const version = 1;

async function openDb() {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open(dbName, version);
    request.onupgradeneeded = () => {
      const db = request.result;
      if (!db.objectStoreNames.contains('requests')) {
        db.createObjectStore('requests', { keyPath: 'id', autoIncrement: true });
      }
    };
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

function complete(tx) {
  return new Promise((resolve, reject) => {
    tx.oncomplete = () => resolve();
    tx.onerror = () => reject(tx.error);
  });
}

export async function enqueue(storeName, payload) {
  const db = await openDb();
  const tx = db.transaction(storeName || 'requests', 'readwrite');
  tx.objectStore(storeName || 'requests').add({ payload, enqueuedAt: Date.now() });
  await complete(tx);
}

export async function dequeue(storeName) {
  const db = await openDb();
  const tx = db.transaction(storeName || 'requests', 'readwrite');
  const store = tx.objectStore(storeName || 'requests');
  const request = store.openCursor();
  return new Promise((resolve, reject) => {
    request.onsuccess = () => {
      const cursor = request.result;
      if (!cursor) {
        resolve(null);
        return;
      }
      const value = cursor.value;
      store.delete(cursor.primaryKey);
      complete(tx).then(() => resolve(value?.payload ?? null));
    };
    request.onerror = () => reject(request.error);
  });
}
