Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3CLFs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:48:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56497 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3CLFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:48:56 -0400
X-AuditID: cbfee68e-b7f946d000001e37-c8-513ec1c71b89
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/14] backlight: ld9040: convert ld9040 to dev_pm_ops
Date: Tue, 12 Mar 2013 14:48:55 +0900
Message-id: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t8zI93jB+0CDfo+qltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9hmTWAp2C1SceRLSwHiKt4uRk0NCwERiyteJ7BC2mMSFe+vZ
	QGwhgWWMEl3zmLoYOcBq7lz26mLkAgovYpTYcW0VC4Qzm0niS8sesGY2ATWJL18Os4M0iAjo
	S7S1aICEmQVKJbY+eM8CYgsLuElM2bUTbD6LgKrE9r+7wWxeAVuJqR/OQ9mCEj8m32OB6NWS
	WL/zOBOELS+xec1bZoh71CUe/dUFCYsI6EnMeH0QqlxEYt+Ld4wgp0kINLNLbPmzkBlil4DE
	t8mHWCB6ZSU2HWCGeFdS4uCKGywTGMVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiI73i
	xNzi0rx0veT83E2MkBjp28F484D1IcZkoPUTmaVEk/OBMZZXEm9obGZkYWpiamxkbmlGmrCS
	OK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbyVkE299x7/oVvP23Y65z6e/ebBQan
	M03rvtfd8jyS+XGh2sraL1dnLdxvE7dW4MAz7Uwl5RNN8gpHBD8rR/34tFvhuFVv7xmlZx+M
	Ehwi5eYJHVu6Srh4XfcmvkUxMx+3LZvwttp6zRnOfxM12Szqtvn3LxLfUMzt8JhhoXXrop+L
	wrmvzCxTYinOSDTUYi4qTgQAEqkCMKcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAd3jB+0CDf4uVrG4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGe0zJrEU7BaoOPMkpIHx
	FG8XIweHhICJxJ3LXl2MnECmmMSFe+vZuhi5OIQEFjFK7Li2igXCmc0k8aVlDztIFZuAmsSX
	L4fZQZpFBPQl2lo0QMLMAqUSWx+8ZwGxhQXcJKbs2skGYrMIqEps/7sbzOYVsJWY+uE8lC0o
	8WPyPRaIXi2J9TuPM0HY8hKb17xlhrhNXeLRX12QsIiAnsSM1wehykUk9r14xziBUWAWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx+Az6R2MqxosDjEKcDAq
	8fAqfLMNFGJNLCuuzD3EKMHBrCTCm7HZLlCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84Hp
	Ia8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGPuUpp6p4Fuy
	nrFmDpdgffa6bkXdWsnZvIo7DGey2y9NEEteG166XVrIQ2Tdfv6bNdMbHx/sUN7QJLfw8wT3
	GjNPjs647cuuTZe4LyaWzeF+2/hl1+anmVMmasT0tUzu+TVlqkUdx1d7tSkH8s1zdrnE83j5
	BmjPWTo3KoFnj/v8NSI7/vxtUWIpzkg01GIuKk4EAEiIX+QFAwAA
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
 drivers/video/backlight/ld9040.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 1b642f5f..1e0a309 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -775,12 +775,12 @@ static int ld9040_remove(struct spi_device *spi)
 	return 0;
 }
 
-#if defined(CONFIG_PM)
-static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int ld9040_suspend(struct device *dev)
 {
-	struct ld9040 *lcd = spi_get_drvdata(spi);
+	struct ld9040 *lcd = dev_get_drvdata(dev);
 
-	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+	dev_dbg(dev, "lcd->power = %d\n", lcd->power);
 
 	/*
 	 * when lcd panel is suspend, lcd panel becomes off
@@ -789,19 +789,18 @@ static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
 	return ld9040_power(lcd, FB_BLANK_POWERDOWN);
 }
 
-static int ld9040_resume(struct spi_device *spi)
+static int ld9040_resume(struct device *dev)
 {
-	struct ld9040 *lcd = spi_get_drvdata(spi);
+	struct ld9040 *lcd = dev_get_drvdata(dev);
 
 	lcd->power = FB_BLANK_POWERDOWN;
 
 	return ld9040_power(lcd, FB_BLANK_UNBLANK);
 }
-#else
-#define ld9040_suspend		NULL
-#define ld9040_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ld9040_pm_ops, ld9040_suspend, ld9040_resume);
+
 /* Power down all displays on reboot, poweroff or halt. */
 static void ld9040_shutdown(struct spi_device *spi)
 {
@@ -814,12 +813,11 @@ static struct spi_driver ld9040_driver = {
 	.driver = {
 		.name	= "ld9040",
 		.owner	= THIS_MODULE,
+		.pm	= &ld9040_pm_ops,
 	},
 	.probe		= ld9040_probe,
 	.remove		= ld9040_remove,
 	.shutdown	= ld9040_shutdown,
-	.suspend	= ld9040_suspend,
-	.resume		= ld9040_resume,
 };
 
 module_spi_driver(ld9040_driver);
-- 
1.7.2.5


