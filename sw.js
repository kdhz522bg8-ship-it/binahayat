const CACHE="binahayat-v91-cloud-offline";
const ASSETS=["./","./index.html","./manifest.webmanifest","https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"];
self.addEventListener("install",e=>e.waitUntil(caches.open(CACHE).then(async c=>{
  for(const u of ASSETS){try{await c.add(u)}catch(e){}}
  return self.skipWaiting();
})));
self.addEventListener("activate",e=>e.waitUntil(self.clients.claim()));
self.addEventListener("fetch",e=>{
  if(e.request.method!=="GET") return;
  e.respondWith(caches.match(e.request).then(cached=>{
    const net=fetch(e.request).then(r=>{
      if(r.ok){caches.open(CACHE).then(c=>c.put(e.request,r.clone())).catch(()=>{});}
      return r;
    }).catch(()=>cached);
    return cached||net;
  }));
});