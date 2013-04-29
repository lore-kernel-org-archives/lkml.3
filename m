Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3D2Jgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:36:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26473 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3D2Jgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:36:36 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-ad-517e3f231c70
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Date: Mon, 29 Apr 2013 18:36:34 +0900
Message-id: <001101ce44bd$0a0105f0$1e0311d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvQXfDCTMsliNR/CztebpoDhPOw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zQ11l+7pAg4ZGXos569ewWVxeeInV
	4vKuOWwWN9btY7e4NeMFqwOrx7XNYh4nZvxm8ejbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	IwuOMBZskqloOr6dvYHxlHgXIyeHhICJxMMz89ghbDGJC/fWs3UxcnEICSxjlNj37jATTNHs
	GyuYIBLTGSWO3j4IVfWLUeLAnP+MIFVsAmoSX74cBhrFwSEioC/R1qIBUsMs0AFU83QpK0hc
	WMBDYusJC5ByFgFViYMze8FaeQUsJTa07mOBsAUlfky+B2YzC2hJrN95nAnClpfYvOYtM8RB
	ChI7zr4G6xUR0JOYeuwdM0SNiMS+F+8YQfZKCOxil/jS8IMZYpmAxLfJh1hAbpAQkJXYdABq
	jqTEwRU3WCYwis1CsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxgh
	8da3g/HmAetDjMlA6ycyS4km5wPjNa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjO3RQrnHF127s+Nnse2RC4vne23LszO6bp/OdV7zTqydgL9m
	+vbCFoH9229N3f2+/12ThWxVsaHrm56bUjmV62c4N374q2TNEryPpaCy+o9J4UHJE5/c7vgI
	iyzft+HM4YtlJh5v7gZyyy22fWmikBz/9576ljPXHjHoNKekVvfOOFW4Kf/CASWW4oxEQy3m
	ouJEAEiRq+DNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQV1l+7pAg4bnHBZz1q9hs7i88BKr
	xeVdc9gsbqzbx25xa8YLVgdWj2ubxTxOzPjN4tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGUcWHGEs2CRT0XR8O3sD4ynxLkZODgkBE4nZN1YwQdhi
	EhfurWfrYuTiEBKYzihx9PZBKOcXo8SBOf8ZQarYBNQkvnw5zN7FyMEhIqAv0daiAVLDLNAB
	VPN0KStIXFjAQ2LrCQuQchYBVYmDM3vBWnkFLCU2tO5jgbAFJX5MvgdmMwtoSazfeZwJwpaX
	2LzmLTPEQQoSO86+BusVEdCTmHrsHTNEjYjEvhfvGCcwCsxCMmoWklGzkIyahaRlASPLKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgaH4mvYNxVYPFIUYBDkYlHt6AzbWBQqyJZcWVuYcY
	JTiYlUR4V1jWBQrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDR5JXEGxqbmBlZGplZGJmY
	m5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDI593N9c5Rv7ZcT6Girz/9I7a65yf+eX5
	lU2MdXa7lD0ebglz+mf//sHW+nezH3w680Z5da2JyEL+78Ztija16k+2bFD4tj1J7et5j72a
	PI++CuqqLtiZ4yn9PaUxhXPhnKVrbseVaGTsZ63/a5V27NeuC0diOVX+We+Zrh6pYuNi9Wla
	Z0TEKSWW4oxEQy3mouJEAI9VudMqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/ts72xx_wdt.c |   64 +++++++----------------------------------
 1 files changed, 11 insertions(+), 53 deletions(-)

diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index b8a9245..b19ca75 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -396,7 +396,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	struct resource *r1, *r2;
 	int error = 0;
 
-	wdt = kzalloc(sizeof(struct ts72xx_wdt), GFP_KERNEL);
+	wdt = devm_kzalloc(&pdev->dev, sizeof(struct ts72xx_wdt), GFP_KERNEL);
 	if (!wdt) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -405,44 +405,22 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r1) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		error = -ENODEV;
-		goto fail;
-	}
-
-	r1 = request_mem_region(r1->start, resource_size(r1), pdev->name);
-	if (!r1) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail;
+		return -ENODEV;
 	}
 
-	wdt->control_reg = ioremap(r1->start, resource_size(r1));
-	if (!wdt->control_reg) {
-		dev_err(&pdev->dev, "failed to map memory\n");
-		error = -ENODEV;
-		goto fail_free_control;
-	}
+	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
+	if (IS_ERR(wdt->control_reg))
+		return PTR_ERR(wdt->control_reg);
 
 	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!r2) {
 		dev_err(&pdev->dev, "failed to get memory resource\n");
-		error = -ENODEV;
-		goto fail_unmap_control;
+		return -ENODEV;
 	}
 
-	r2 = request_mem_region(r2->start, resource_size(r2), pdev->name);
-	if (!r2) {
-		dev_err(&pdev->dev, "cannot request memory region\n");
-		error = -EBUSY;
-		goto fail_unmap_control;
-	}
-
-	wdt->feed_reg = ioremap(r2->start, resource_size(r2));
-	if (!wdt->feed_reg) {
-		dev_err(&pdev->dev, "failed to map memory\n");
-		error = -ENODEV;
-		goto fail_free_feed;
-	}
+	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
+	if (IS_ERR(wdt->feed_reg))
+		return PTR_ERR(wdt->feed_reg);
 
 	platform_set_drvdata(pdev, wdt);
 	ts72xx_wdt_pdev = pdev;
@@ -455,45 +433,25 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	error = misc_register(&ts72xx_wdt_miscdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register miscdev\n");
-		goto fail_unmap_feed;
+		goto fail;
 	}
 
 	dev_info(&pdev->dev, "TS-72xx Watchdog driver\n");
 
 	return 0;
 
-fail_unmap_feed:
-	platform_set_drvdata(pdev, NULL);
-	iounmap(wdt->feed_reg);
-fail_free_feed:
-	release_mem_region(r2->start, resource_size(r2));
-fail_unmap_control:
-	iounmap(wdt->control_reg);
-fail_free_control:
-	release_mem_region(r1->start, resource_size(r1));
 fail:
-	kfree(wdt);
+	platform_set_drvdata(pdev, NULL);
 	return error;
 }
 
 static int ts72xx_wdt_remove(struct platform_device *pdev)
 {
-	struct ts72xx_wdt *wdt = platform_get_drvdata(pdev);
-	struct resource *res;
 	int error;
 
 	error = misc_deregister(&ts72xx_wdt_miscdev);
 	platform_set_drvdata(pdev, NULL);
 
-	iounmap(wdt->feed_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, resource_size(res));
-
-	iounmap(wdt->control_reg);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(wdt);
 	return error;
 }
 
-- 
1.7.2.5


