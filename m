Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3IXJ2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:28:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24511 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3IXJ2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:28:49 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-34-52415b50e614
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] backlight: ams369fg06: use
 devm_{backlight,lcd}_device_register()
Date: Tue, 24 Sep 2013 18:28:47 +0900
Message-id: <007501ceb908$78df7370$6a9e5a50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65CHjKuB0v+SsdTFGS6PUVVZI9Rw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zY92AaMcgg3XnuS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozpc+6x
	FBzgr2g++Z2pgfEXTxcjJ4eEgInE6huv2CFsMYkL99azdTFycQgJLGOU+Pm+gRWmaMOWTSwQ
	iemMEnN6NrCAJIQEfjFKvF2UDGKzCahJfPlyGGgSB4eIgL5EW4sGSJhZIEfi/pNZYAuEBSIk
	TizbCDaTRUBVouXsQSYQm1fAVuL+julQtqDEj8n3WCB6tSQ2b2tihbDlJTavecsMMl5CQF3i
	0V9dkLCIgJ7E3d7r7BAlIhL7XrxjBDlTQmAXu8TNo5OYIXYJSHybfIgFoldWYtMBZoi3JCUO
	rrjBMoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJsf4d
	jHcPWB9iTAZaP5FZSjQ5HxijeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphak
	FsUXleakFh9iZOLglGpgXJvkrF1sKGZRZRjuyfnpns276b9bWOeaJN88qhmc8ITBMU/ALlpk
	1z4R4Wup7IVR/fu0lVebPpcK2TUhLd/D+JRC0Ky/88+yzioUPpd7X6r6wc2rX80WeF7Z9zXk
	8/VeDv8t1cy8/8LTfrxSiAvzP3SayUMsRO51ncYUTXbXFVtWvGrw85igxFKckWioxVxUnAgA
	l0T+/scCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd2AaMcggxc/2S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM6XPusRQc4K9oPvmdqYHxF08XIyeHhICJxIYtm1ggbDGJC/fW
	s3UxcnEICUxnlJjTswEsISTwi1Hi7aJkEJtNQE3iy5fD7F2MHBwiAvoSbS0aIGFmgRyJ+09m
	sYPYwgIREieWbWQFsVkEVCVazh5kArF5BWwl7u+YDmULSvyYfI8FoldLYvO2JlYIW15i85q3
	zCDjJQTUJR791QUJiwjoSdztvc4OUSIise/FO8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOIKfSe9gXNVgcYhRgINRiYf3QoJDkBBrYllxZe4hRgkO
	ZiUR3hu2jkFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MLnkl8YbGJmZGlkZmFkYm5uak
	CSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNhbLsHbmalRp1jRXeJ/+b7Oj8niFgLZRy3b
	Mo9vbHf9WHxUgsliy7ydm78tZX/k+0BiTyPnMen9q//ETaw4eMOv39NH3/HwhynrWJ9oT+bs
	K5M7euz53mmuyvytd1ZkH9URvGDp9//Mnh8qHRlf39/9yqvs0DhnQp7YBfkTMz633+NmMXyc
	f0OJpTgj0VCLuag4EQC6PfDjJAMAAA==
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
 drivers/video/backlight/ams369fg06.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index df5507b..d8952c4 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -477,8 +477,8 @@ static int ams369fg06_probe(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	ld = lcd_device_register("ams369fg06", &spi->dev, lcd,
-		&ams369fg06_lcd_ops);
+	ld = devm_lcd_device_register(&spi->dev, "ams369fg06", &spi->dev, lcd,
+					&ams369fg06_lcd_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -488,12 +488,11 @@ static int ams369fg06_probe(struct spi_device *spi)
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
 
-	bd = backlight_device_register("ams369fg06-bl", &spi->dev, lcd,
-		&ams369fg06_backlight_ops, &props);
-	if (IS_ERR(bd)) {
-		ret =  PTR_ERR(bd);
-		goto out_lcd_unregister;
-	}
+	bd = devm_backlight_device_register(&spi->dev, "ams369fg06-bl",
+					&spi->dev, lcd,
+					&ams369fg06_backlight_ops, &props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 
 	bd->props.brightness = DEFAULT_BRIGHTNESS;
 	lcd->bd = bd;
@@ -516,10 +515,6 @@ static int ams369fg06_probe(struct spi_device *spi)
 	dev_info(&spi->dev, "ams369fg06 panel driver has been probed.\n");
 
 	return 0;
-
-out_lcd_unregister:
-	lcd_device_unregister(ld);
-	return ret;
 }
 
 static int ams369fg06_remove(struct spi_device *spi)
@@ -527,9 +522,6 @@ static int ams369fg06_remove(struct spi_device *spi)
 	struct ams369fg06 *lcd = spi_get_drvdata(spi);
 
 	ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
-	backlight_device_unregister(lcd->bd);
-	lcd_device_unregister(lcd->ld);
-
 	return 0;
 }
 
-- 
1.7.10.4


