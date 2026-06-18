(function () {
  const config = {
    url: "https://qxpmvntnsolfinbmsnrg.supabase.co",
    publishableKey: "sb_publishable_FIOKaSde2S3oYaJ-MwKPKg_WTz0ipAJ",
    bucket: "catalog"
  };

  window.BRAVA_SUPABASE_CONFIG = config;
  window.bravaSupabase = window.supabase?.createClient
    ? window.supabase.createClient(config.url, config.publishableKey)
    : null;
})();
