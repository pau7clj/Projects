# Scrapy settings for thomannscraper project

LOG_ENABLED = True
LOG_LEVEL = 'INFO'

BOT_NAME = "thomannscraper"
SPIDER_MODULES = ["thomannscraper.spiders"]
NEWSPIDER_MODULE = "thomannscraper.spiders"
TWISTED_REACTOR = "twisted.internet.asyncioreactor.AsyncioSelectorReactor"

# ScrapeOps (fake headers / user-agents)
SCRAPEOPS_API_KEY = '2390a56c-e51a-4568-842c-1be5e918c508'
SCRAPEOPS_FAKE_USER_AGENT_ENDPOINT = 'https://headers.scrapeops.io/v1/user-agents'
SCRAPEOPS_FAKE_USER_AGENT_ENABLED = True
SCRAPEOPS_NUM_RESULTS = 100

# Playwright settings
PLAYWRIGHT_LAUNCH_OPTIONS = {
    "headless": True,
}
PLAYWRIGHT_PAGE_GOTO_OPTIONS = {"wait_until": "domcontentloaded"}  # don’t wait for full load
PLAYWRIGHT_DEFAULT_NAVIGATION_TIMEOUT = 60000  # 60s max
PLAYWRIGHT_MAX_CONTEXTS = 6      # parallel browser instances
PLAYWRIGHT_MAX_PAGES = 24        # tabs per context

# Block heavy resources (speed boost)
PLAYWRIGHT_ABORT_REQUEST = "thomannscraper.middlewares.should_abort_request"

# Robots.txt ignored
ROBOTSTXT_OBEY = False

# Concurrency & throttling
CONCURRENT_REQUESTS = 64
CONCURRENT_REQUESTS_PER_DOMAIN = 32
DOWNLOAD_DELAY = 4

# AutoThrottle (dynamic speed control)
AUTOTHROTTLE_ENABLED = True
AUTOTHROTTLE_START_DELAY = 4
AUTOTHROTTLE_MAX_DELAY = 8
AUTOTHROTTLE_TARGET_CONCURRENCY = 4.0
AUTOTHROTTLE_DEBUG = False

# Retry failed requests
RETRY_ENABLED = True
RETRY_TIMES = 5
RETRY_HTTP_CODES = [500, 502, 503, 504, 522, 524, 408, 429]

# Downloader middlewares
DOWNLOADER_MIDDLEWARES = {
   "thomannscraper.middlewares.ScrapeOpsFakeBrowserHeaderAgentMiddleware": 400,
}

# Scrapy-Playwright download handlers
DOWNLOAD_HANDLERS = {
    "http": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
    "https": "scrapy_playwright.handler.ScrapyPlaywrightDownloadHandler",
}

# Feed export encoding
FEED_EXPORT_ENCODING = "utf-8"
