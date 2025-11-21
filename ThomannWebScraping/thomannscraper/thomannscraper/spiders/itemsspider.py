import scrapy
import json
import logging
from scrapy_playwright.page import PageMethod

# Suppress Playwright debug logs
logging.getLogger("scrapy_playwright").setLevel(logging.WARNING)
logging.getLogger("playwright").setLevel(logging.WARNING)
logging.getLogger("asyncio").setLevel(logging.WARNING)


class ItemsspiderSpider(scrapy.Spider):
    name = "itemsspider"
    allowed_domains = ["thomann.de"]

    async def start(self):
        # Load listing URLs from JSON
        json_path = r"C:\ThomannWebScraping\thomannscraper\thomannscraper\final_links.json"
        with open(json_path, 'r', encoding='utf-8') as f:
            links = json.load(f)

        for entry in links:
            url = entry.get("url")
            if url:
                # Only use Playwright for listing pages
                yield scrapy.Request(
                    url=url,
                    callback=self.parse_page,
                    meta={
                        "playwright": True,
                        "playwright_page_methods": [
                            PageMethod("wait_for_load_state", "networkidle", timeout=60000)
                        ],
                        "max_page": None,
                    },
                )

    def parse_page(self, response):
        """Parse a product listing page and follow product links."""
        products = response.css("div.fx-product-list-entry a.product__content::attr(href)").getall()
        if not products:
            self.logger.info(f"No products found on {response.url}")
            return

        for link in products:
            yield response.follow(
                link,
                callback=self.parse_product,
                meta={"listing_page_url": response.url},
            )

        # Handle pagination
        max_page = response.meta.get("max_page")
        if not max_page:
            page_buttons = response.css("button.fx-pagination__pages-button::text").getall()
            max_page = max(int(p.strip()) for p in page_buttons if p.strip().isdigit()) if page_buttons else 1
            self.logger.info(f"Detected max page = {max_page}")

        current_page = int(response.url.split("?pg=")[-1]) if "?pg=" in response.url else 1

        if current_page < max_page:
            next_page_url = f"{response.url.split('?')[0]}?pg={current_page + 1}"
            yield scrapy.Request(
                next_page_url,
                callback=self.parse_page,
                meta={
                    "playwright": True,
                    "playwright_page_methods": [
                        PageMethod("wait_for_load_state", "networkidle", timeout=60000)
                    ],
                    "max_page": max_page,
                },
            )

    def parse_product(self, response):
        """Parse product details from static HTML."""
        listing_page_url = response.meta.get("listing_page_url")

        product_name = response.css('h1[itemprop="name"]::text').get()
        product_name = product_name.strip() if product_name else None

        rating = response.css('span.sr-only::text').get()
        rating = rating.strip() if rating else None

        description_spans = []
        wrapper_divs = response.css("div.keyfeature__wrapper")
        for wrapper in wrapper_divs:
            spans = wrapper.css("span::text").getall()
            if len(spans) > 1:
                second_span = spans[1].strip()
                if second_span:
                    description_spans.append(second_span)
        description = " / ".join(description_spans) if description_spans else None

        price = response.css('div.price::text').get()
        price = price.strip() if price else None

        availability = response.css('span.fx-availability::text').get()
        availability = availability.strip() if availability else None

        product = {
            "name": product_name,
            "description": description,
            "rating": rating,
            "price": price,
            "availability": availability,
            "product_url": response.url,
            "listing_page_url": listing_page_url,
        }

        print(product)
        yield product
