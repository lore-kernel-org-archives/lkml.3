Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab3BYB5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 20:57:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22709 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759464Ab3BYB5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 20:57:03 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-ad-512ac4e7174b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003201ce10e9$61e11b50$25a351f0$%han@samsung.com>
In-reply-to: <003201ce10e9$61e11b50$25a351f0$%han@samsung.com>
Subject: [PATCH V2] backlight: ams369fg06: convert ams369fg06 to dev_pm_ops
Date: Mon, 25 Feb 2013 10:56:55 +0900
Message-id: <01e601ce12fb$638142f0$2a83c8d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q6WHJS4caNLWdSOOoYhBmxaMp3gCEc/vg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ93nR7QCDSatMrC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZn9b+Zyl4LlhxpvcZcwPjO74uRk4OCQETicnrJ7NC2GISF+6t
	Z+ti5OIQEljGKPG7+QkjTNHeN3dYIRKLGCX2rm6EqprNJHFu6n8WkCo2ATWJL18Os3cxcnCI
	COhLtLVogISZBUoltj54D1YiJGAr8XvZNbBtnAJ2EkvnTWcDsYUFvCWur+lhBWllEVCVuPNI
	ECTMC1S+99g5VghbUOLH5HssECO1JNbvPM4EYctLbF7zlhmkVUJAXeLRX12QsIiAkcS5HXsZ
	IUpEJPa9eMcIcrGEwDJ2ia6P/8ESLAICEt8mH2KB6JWV2HSAGeJdSYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MULiauIOxvsHrA8xJgOtn8gs
	JZqcD4zLvJJ4Q2NjEzMTUxNzS1NzU9KElcR55S/JBAoJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgNFp8v7t/mtYMpo1Wsb4LbKZ0LptZNvPOa4NLvw1P/bmb7OKdpjKZd8WPjPwjkoWt7snT
	VjmvZdi/aJrYosZFD+Nd7Bltjttufah6jPHbi+9bJ4kkG5+2OKaaZye2KaOR599M658sUlqe
	1w02C59U/xV5c8rX889kdSvSan+bPfjo9iHu+dd4ViWW4oxEQy3mouJEADDrx+7BAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO7zI1qBBkvn6Vhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjE9r/7MUPBesONP7jLmB
	8R1fFyMnh4SAicTeN3dYIWwxiQv31rN1MXJxCAksYpTYu7oRypnNJHFu6n8WkCo2ATWJL18O
	s3cxcnCICOhLtLVogISZBUoltj54D1YiJGAr8XvZNbChnAJ2EkvnTWcDsYUFvCWur+lhBWll
	EVCVuPNIECTMC1S+99g5VghbUOLH5HssECO1JNbvPM4EYctLbF7zlhmkVUJAXeLRX12QsIiA
	kcS5HXsZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al
	6yXn525iBEftM6kdjCsbLA4xCnAwKvHwNqzUChRiTSwrrsw9xCjBwawkwqsZChTiTUmsrEot
	yo8vKs1JLT7EmAz050RmKdHkfGBCySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs
	1NSC1CKYLUwcnFINjCcP/s23d/gS/tBe74hkyddbXCkJk056PtrwS+q97oebZVGaR/fOzl/P
	veUJu7S0qNW+pXv7zR6wFd9f0rDr+d1iLuGWEnPWP/8naRpPO++a0FIi809u6zfBCR1Hrjrc
	deZeu/fjU4m5v8S+qjt27g6ZlDS7Lop35kkd5fxXLyd0/3M5tEk0I0GJpTgj0VCLuag4EQC1
	SvK3HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Remove unnecessary ifdefs.

 drivers/video/backlight/ams369fg06.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index d29e494..068194b 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -535,12 +535,12 @@ static int ams369fg06_remove(struct spi_device *spi)
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int ams369fg06_suspend(struct device *dev)
 {
-	struct ams369fg06 *lcd = spi_get_drvdata(spi);
+	struct ams369fg06 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -549,19 +549,19 @@ static int ams369fg06_suspend(struct spi_device *spi, pm_message_t mesg)
 	return ams369fg06_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ams369fg06_resume(struct spi_device *spi)
+static int ams369fg06_resume(struct device *dev)
 {
-	struct ams369fg06 *lcd = spi_get_drvdata(spi);
+	struct ams369fg06 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return ams369fg06_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ams369fg06_suspend	NULL
-#define ams369fg06_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ams369fg06_pm_ops, ams369fg06_suspend,
+			ams369fg06_resume);
+
 static void ams369fg06_shutdown(struct spi_device *spi)
 {
 	struct ams369fg06 *lcd = spi_get_drvdata(spi);
@@ -573,12 +573,11 @@ static struct spi_driver ams369fg06_driver = {
 	.driver = {
 		.name	= "ams369fg06",
 		.owner	= THIS_MODULE,
+		.pm	= &ams369fg06_pm_ops,
 	},
 	.probe		= ams369fg06_probe,
 	.remove		= ams369fg06_remove,
 	.shutdown	= ams369fg06_shutdown,
-	.suspend	= ams369fg06_suspend,
-	.resume		= ams369fg06_resume,
 };
 
 module_spi_driver(ams369fg06_driver);
-- 
1.7.2.5


