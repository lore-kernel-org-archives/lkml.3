Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3IXJ3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:29:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31497 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3IXJ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:29:36 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-2f-52415b7fd02b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
In-reply-to: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
Subject: [PATCH 2/5] backlight: ld9040: use
 devm_{backlight,lcd}_device_register()
Date: Tue, 24 Sep 2013 18:29:35 +0900
Message-id: <007601ceb908$95288260$bf798720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65CHjKuB0v+SsdTFGS6PUVVZI9RwAAAixA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zQ936aMcgg12nlS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyZHXeY
	C+7zVcxt/sXUwLiQp4uRk0NCwETi3ZrvTBC2mMSFe+vZuhi5OIQEljFKPDg/lQWmaN/ng+wQ
	iUWMEnt3XmIESQgJ/GKUaH9vD2KzCahJfPlyGKiIg0NEQF+irUUDJMwskCNx/8ksdohyW4mX
	lx8zg9icAnYSy/ZdBLOFBUIkrrfsAKthEVCVONg8GWwML1D96V9OIGFeAUGJH5PvsUCM1JLY
	vK2JFcKWl9i85i0zSLmEgLrEo7+6IGERASOJ5onfmCFKRCT2vXjHCPHJOXaJBy94IDYJSHyb
	fIgFolVWYtMBZogSSYmDK26wTGCUmIVk8Swki2chWTwLyYYFjCyrGEVTC5ILipPSiwz1ihNz
	i0vz0vWS83M3MULisXcH4+0D1ocYk4HWT2SWEk3OB8ZzXkm8obGZkYWpiamxkbmlGWnCSuK8
	ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY1dS/SqR6l/TcDl/hLL/80cIKy88nFksu
	daw2j7jN+sjURYCxqcz2TV3plAylrPo74gFyHwJerr5+y6M+pUsszFN17b6jHLyaiccXfmRT
	4HvPz7U9bH/jKrZYn+vcxeGiKWHXv+8U+ni/wEjikgZz7e8/dR4eYUdf7FXeabjpEkfasaav
	TRpKLMUZiYZazEXFiQDozHHn3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd36aMcgg7aX8hZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGzI47zAX3+SrmNv9iamBcyNPFyMkhIWAise/zQXYIW0ziwr31
	bF2MXBxCAosYJfbuvMQIkhAS+MUo0f7eHsRmE1CT+PLlMFADB4eIgL5EW4sGSJhZIEfi/pNZ
	7BDlthIvLz9mBrE5Bewklu27CGYLC4RIXG/ZAVbDIqAqcbB5MtgYXqD607+cQMK8AoISPybf
	Y4EYqSWxeVsTK4QtL7F5zVtmkHIJAXWJR391QcIiAkYSzRO/MUOUiEjse/GOcQKj0Cwkk2Yh
	mTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO92fSOxhXNVgcYhTgYFTi
	4b2Q4BAkxJpYVlyZe4hRgoNZSYT3hq1jkBBvSmJlVWpRfnxRaU5q8SHGZKA/JzJLiSbnA1NR
	Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwJnyse5o0c3JI
	8+uog7Xr97+62jTV2zF6guSkSaoS019XvpP5fOsu36Z82zsJOYwMSWaf85w8gw+fsou0KQl6
	GF/Z/+qoyM98oweFGXPNBN9kRH00qLzCcXaZwZMLrzcu5rnldulq19pylaUl8d80ckNPvNpu
	skW0l6Wr4P3Mg0djVdgzM/dGKbEUZyQaajEXFScCAJ9m4M07AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() and devm_lcd_device_register()
to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ld9040.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 26d5139..506a6c2 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -716,7 +716,8 @@ static int ld9040_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
+	ld = devm_lcd_device_register(&spi->dev, "ld9040", &spi->dev, lcd,
+					&ld9040_lcd_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -726,12 +727,10 @@ static int ld9040_probe(struct spi_device *spi)
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 
-	bd = backlight_device_register("ld9040-bl", &spi->dev,
-		lcd, &ld9040_backlight_ops, &props);
-	if (IS_ERR(bd)) {
-		ret = PTR_ERR(bd);
-		goto out_unregister_lcd;
-	}
+	bd = devm_backlight_device_register(&spi->dev, "ld9040-bl", &spi->dev,
+					lcd, &ld9040_backlight_ops, &props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 
 	bd->props.brightness = MAX_BRIGHTNESS;
 	lcd->bd = bd;
@@ -757,11 +756,6 @@ static int ld9040_probe(struct spi_device *spi)
 
 	dev_info(&spi->dev, "ld9040 panel driver has been probed.\n");
 	return 0;
-
-out_unregister_lcd:
-	lcd_device_unregister(lcd->ld);
-
-	return ret;
 }
 
 static int ld9040_remove(struct spi_device *spi)
@@ -769,9 +763,6 @@ static int ld9040_remove(struct spi_device *spi)
 	struct ld9040 *lcd = spi_get_drvdata(spi);
 
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
-	backlight_device_unregister(lcd->bd);
-	lcd_device_unregister(lcd->ld);
-
 	return 0;
 }
 
-- 
1.7.10.4


