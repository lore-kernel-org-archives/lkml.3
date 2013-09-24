Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3IXJbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:31:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27868 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3IXJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:31:37 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-cf-52415bf8d576
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
In-reply-to: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
Subject: [PATCH 5/5] backlight: s6e63m0: use
 devm_{backlight,lcd}_device_register()
Date: Tue, 24 Sep 2013 18:31:36 +0900
Message-id: <007901ceb908$dd461e40$97d25ac0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65CHjKuB0v+SsdTFGS6PUVVZI9RwAAFIVg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zQ90f0Y5BBp1blC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowft7+z
	FWzjr1g1q4epgfE7TxcjJ4eEgInEkZm/mCFsMYkL99azdTFycQgJLGOUuHrvGjNM0c4/p1kg
	EtMZJU4eussO4fxilOi8v4AFpIpNQE3iy5fDQAkODhEBfYm2Fg2QMLNAjsT9J7PYQWwhAVuJ
	l5cfgw3lFLCTWLbvIpgtLBAqsXz5ViYQm0VAVeJPx2WwkbxA9Y8ufmWHsAUlfky+xwIxU0ti
	87YmVghbXmLzmrfMIGslBNQlHv3VBQmLCBhJ9Fz+B1UiIrHvxTtGkJMlBM6xS7xe9pMRYpeA
	xLfJh1ggemUlNh2A+ldS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73i
	xNzi0rx0veT83E2MkKicsIPx3gHrQ4zJQOsnMkuJJucDozqvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyuu9Z4Rvxj8Whb9+CZM3vBzyIz4/DF
	Czexz+KsT34iv/zu9w/GDV9X3lW7wiKzo8+S+czGphD7RyVb5ldE9UmGR3mxV02M0Pygmxwx
	f1L0ca9QUf036Wsmrk7JSZn1r3jJy0X5mm9qjlfr9q6c92jhMZbqzxeUvuqc/B/ptPzD5cqN
	e78durZDiaU4I9FQi7moOBEAZTOcLeACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd0f0Y5BBucey1vMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZP25/ZyvYxl+xalYPUwPjd54uRk4OCQETiZ1/TrNA2GISF+6t
	Z+ti5OIQEpjOKHHy0F12COcXo0Tn/QVgVWwCahJfvhwGSnBwiAjoS7S1aICEmQVyJO4/mcUO
	YgsJ2Eq8vPyYGcTmFLCTWLbvIpgtLBAqsXz5ViYQm0VAVeJPx2WwkbxA9Y8ufmWHsAUlfky+
	xwIxU0ti87YmVghbXmLzmrfMIGslBNQlHv3VBQmLCBhJ9Fz+B1UiIrHvxTvGCYxCs5BMmoVk
	0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjmn0ntYFzZYHGIUYCDUYmH
	d4e3Q5AQa2JZcWXuIUYJDmYlEd4bto5BQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTEd5
	JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCozbiv96btwodW
	i5KigpbfOcj9oSKvYmtpd8bx5T66tm4J+s7rhHapidq+7A91PJmzqSffb/0Nry9JgtMOaH3j
	8SrcvFZ27rfghWVTfibsWL9c82zG14CPh7dcjvi/4sqxX/MvmfzN8jrRVnK2VdrdwijovLng
	mf9X1v2/t0f78XT1yfoZD+2FlViKMxINtZiLihMBKkDXfj0DAAA=
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
 drivers/video/backlight/s6e63m0.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 4e339ad..510a1bc 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -741,7 +741,8 @@ static int s6e63m0_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	ld = lcd_device_register("s6e63m0", &spi->dev, lcd, &s6e63m0_lcd_ops);
+	ld = devm_lcd_device_register(&spi->dev, "s6e63m0", &spi->dev, lcd,
+				&s6e63m0_lcd_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -751,12 +752,11 @@ static int s6e63m0_probe(struct spi_device *spi)
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 
-	bd = backlight_device_register("s6e63m0bl-bl", &spi->dev, lcd,
-		&s6e63m0_backlight_ops, &props);
-	if (IS_ERR(bd)) {
-		ret =  PTR_ERR(bd);
-		goto out_lcd_unregister;
-	}
+	bd = devm_backlight_device_register(&spi->dev, "s6e63m0bl-bl",
+					&spi->dev, lcd, &s6e63m0_backlight_ops,
+					&props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 
 	bd->props.brightness = MAX_BRIGHTNESS;
 	lcd->bd = bd;
@@ -798,10 +798,6 @@ static int s6e63m0_probe(struct spi_device *spi)
 	dev_info(&spi->dev, "s6e63m0 panel driver has been probed.\n");
 
 	return 0;
-
-out_lcd_unregister:
-	lcd_device_unregister(ld);
-	return ret;
 }
 
 static int s6e63m0_remove(struct spi_device *spi)
@@ -811,8 +807,6 @@ static int s6e63m0_remove(struct spi_device *spi)
 	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
 	device_remove_file(&spi->dev, &dev_attr_gamma_table);
 	device_remove_file(&spi->dev, &dev_attr_gamma_mode);
-	backlight_device_unregister(lcd->bd);
-	lcd_device_unregister(lcd->ld);
 
 	return 0;
 }
-- 
1.7.10.4


