Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3IXJXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:23:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23625 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3IXJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:23:31 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-17-52415a124944
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 3/8] backlight: ili9320: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:23:30 +0900
Message-id: <006401ceb907$bb9b7480$32d25d80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAABmdw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA12hKMcggwM9KhZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aPKc8Z
	C85wVXw/cpWxgfE+RxcjJ4eEgInElx2PmCFsMYkL99azdTFycQgJLGOUWNt7mw2m6NKe88wQ
	iemMEi3rH7NDOL8YJY5N/c8OUsUmoCbx5cthIJuDQ0RAX6KtRQMkzCyQI3H/ySywEiEBW4nV
	M6+C2ZwCdhLvp55hAbGFBdwl1r9fDbaMRUBVomFuC1icF6j+7rSzjBC2oMSPyfdYIGZqSWze
	1sQKYctLbF7zlhlkrYSAusSjv7ogYREBI4mds94yQpSISOx78Y4R5GQJgXPsEl+Pb2aE2CUg
	8W3yIRaIXlmJTQegASEpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnqRoV5x
	Ym5xaV66XnJ+7iZGSFT27mC8fcD6EGMy0PqJzFKiyfnAqM4riTc0NjOyMDUxNTYytzQjTVhJ
	nFetxTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyOr/a9CUZ3eZ7bmaRcELz5sye09v3f5
	5sCtyu9L1rDJbVIWuCrMHFFapKdyxtI/pujYRIeAG6eOK/sZf35WonrX2MG35+SFqJoDfeZb
	0mNDJuuXvWorij6TqHKw6p1A9uVF6xdHWvVq5i36xZenlS+bphL8PuExz0fRu4f+3DqhpiZ8
	7eFtcyWW4oxEQy3mouJEABM+6obgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQV2hKMcggxurFSzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMH1OeMxac4ar4fuQqYwPjfY4uRk4OCQETiUt7zjND2GISF+6t
	Z+ti5OIQEpjOKNGy/jE7hPOLUeLY1P/sIFVsAmoSX74cBrI5OEQE9CXaWjRAwswCORL3n8wC
	KxESsJVYPfMqmM0pYCfxfuoZFhBbWMBdYv371WwgNouAqkTD3BawOC9Q/d1pZxkhbEGJH5Pv
	sUDM1JLYvK2JFcKWl9i85i0zyFoJAXWJR391QcIiAkYSO2e9ZYQoEZHY9+Id4wRGoVlIJs1C
	MmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc88+kdzCuarA4xCjAwajE
	w3shwSFIiDWxrLgy9xCjBAezkgjvDVvHICHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6aj
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgzJ+3U/lbi+zJ
	hStiOO4va881OcfC9dh2vbjH4xkFjq0ZnkWtNpMXa/yPldfU+R0REsm5ebXaLV/uYsso0aMp
	slr/WQ2nvpc9dP79fNf4znXnt1Y0ff90WHHmzNSmWb8OR+gHrLv9/8IHvaTZxn3H2c7Gz3bT
	XnL761lpgYw17KF18+8/WG8/TYmlOCPRUIu5qDgRAD/A4909AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili9320.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index 4dd43e0..e2b8b40 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -235,7 +235,8 @@ int ili9320_probe_spi(struct spi_device *spi,
 
 	ili9320_setup_spi(ili, spi);
 
-	lcd = lcd_device_register("ili9320", dev, ili, &ili9320_ops);
+	lcd = devm_lcd_device_register(&spi->dev, "ili9320", dev, ili,
+					&ili9320_ops);
 	if (IS_ERR(lcd)) {
 		dev_err(dev, "failed to register lcd device\n");
 		return PTR_ERR(lcd);
@@ -248,24 +249,16 @@ int ili9320_probe_spi(struct spi_device *spi,
 	ret = ili9320_power(ili, FB_BLANK_UNBLANK);
 	if (ret != 0) {
 		dev_err(dev, "failed to set lcd power state\n");
-		goto err_unregister;
+		return ret;
 	}
 
 	return 0;
-
- err_unregister:
-	lcd_device_unregister(lcd);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(ili9320_probe_spi);
 
 int ili9320_remove(struct ili9320 *ili)
 {
 	ili9320_power(ili, FB_BLANK_POWERDOWN);
-
-	lcd_device_unregister(ili->lcd);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ili9320_remove);
-- 
1.7.10.4


