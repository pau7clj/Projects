import scrapy
from thomannscraper.items import FinalCategoryLink

class DrumspiderSpider(scrapy.Spider):
    name = "drumspider"
    allowed_domains = ["thomann.de"]
    start_urls = [
       "https://www.thomann.de/ro/tobe_si_percutie.html"
    ]

    allowed_subcategory_urls = [
        "https://www.thomann.de/ro/cinele.html",
        "https://www.thomann.de/ro/tobe_acustice.html",
        "https://www.thomann.de/ro/fete_de_toba.html",
        "https://www.thomann.de/ro/stative_si_accesorii_de_toba.html",
        "https://www.thomann.de/ro/bete_si_maciuci.html"
    ]

    def parse(self, response):
        # Scope to div.fx-content-section
        content_section = response.css('div.fx-content-section')

        # Find subcategory links inside that div
        sub_links = content_section.css('a.fx-category-grid__item::attr(href)').getall()
        sub_links = [response.urljoin(link) for link in sub_links]
        sub_links = [link for link in sub_links if 'woodpecker' not in link]

        # Determine which links to follow
        if response.url in self.start_urls:
            filtered_links = [link for link in sub_links if link in self.allowed_subcategory_urls]
        else:
            filtered_links = sub_links

        if filtered_links:
            for link in filtered_links:
                yield response.follow(link, callback=self.parse)
        else:
            print(response.url)
            item = FinalCategoryLink()
            item['url'] = response.url
            yield item

    def closed(self, reason):
        self.log(f'Finished collecting links.')
                
