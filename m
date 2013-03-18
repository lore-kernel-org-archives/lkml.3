Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3CRJcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:32:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48742 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3CRJbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:31:51 -0400
X-AuditID: cbfee690-b7f656d0000007e3-5f-5146df06e92b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 07/10] rtc: rtc-wm8350: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:31:50 +0900
Message-id: <01bd01ce23bb$6b2115f0$416341d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAAEMPA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY122+26BBlseq1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MHVefMhZc5ap4vWcrUwPjB44uRk4OCQETiTNfV7BD2GISF+6t
	Z+ti5OIQEljGKLFw6zRWmKK+l1OZIBKLGCV+vTzGCOHMZpI4f/A9G0gVm4CaxJcvh4FGcXCI
	COhLtLVogNQwC/QySpzp3Q22QkjAVmLetcWMIDangJ3E1v5JrCD1wgKeEhOWOIOEWQRUJb5e
	ugkW5gUq//EgGyTMKyAo8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lByiUE1CUe/dUFCYsIGEls
	ajrBDFEiIrHvxTuwiyUEVrFLzHs5ixVilYDEt8mHWCB6ZSU2HWCGeFdS4uCKGywTGCVmIdk8
	C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkLiasIPx3gHrQ4zJQOsn
	MkuJJucD4zKvJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYzSaVJvp12TUz1qw3JST3/KiT8F87queq6bNGet8buTfDWn53jraFQevPHwxvNP56+y
	L8kvEOK60eoc5xN+cMKLu+5uiSsvhnjqSxebJzc3iK66V9lx/P/FDNZJRe9a3jpmJzFzuEoy
	u/FMWHzKS/2H/vY02eCVqjI5zNPX232PMVnHlS3OOUmJpTgj0VCLuag4EQA2UGsIwQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgC7bfbdAg61zFCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxo6rTxkLrnJVvN6zlamB
	8QNHFyMnh4SAiUTfy6lMELaYxIV769m6GLk4hAQWMUr8enmMEcKZzSRx/uB7NpAqNgE1iS9f
	DrN3MXJwiAjoS7S1aIDUMAv0Mkqc6d3NDlIjJGArMe/aYkYQm1PATmJr/yRWkHphAU+JCUuc
	QcIsAqoSXy/dBAvzApX/eJANEuYVEJT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCDlEgLqEo/+
	6oKERQSMJDY1nWCGKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRHLXPpHcwrmqwOMQowMGoxMO7Y71boBBrYllxZe4hRgkOZiURXsfbQCHe
	lMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OByaUvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgTPwX82fZu8lOc0/e6Jyv9+u7HPtrl2lvtTfJ/BFNyMt/HPft
	2UqJnP9r3pVcsK2p+ZjI8mbG/+y/Cyd8TLtzIKj+7uGTDP+mF5dcn8Cd2r8uiGnBL0kz6blC
	rxZM9lzVvNBn60LZ6ujGSQkx8lfUN8Wu548XX/Uv7pG2tPOXAP/PjNv6cvO9YpVYijMSDbWY
	i4oTAalSb2ceAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-wm8350.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 8ad86ae..26581ea 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -339,7 +339,7 @@ static const struct rtc_class_ops wm8350_rtc_ops = {
 	.alarm_irq_enable = wm8350_rtc_alarm_irq_enable,
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int wm8350_rtc_suspend(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -375,10 +375,6 @@ static int wm8350_rtc_resume(struct device *dev)
 
 	return 0;
 }
-
-#else
-#define wm8350_rtc_suspend NULL
-#define wm8350_rtc_resume NULL
 #endif
 
 static int wm8350_rtc_probe(struct platform_device *pdev)
@@ -472,10 +468,8 @@ static int wm8350_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct dev_pm_ops wm8350_rtc_pm_ops = {
-	.suspend = wm8350_rtc_suspend,
-	.resume = wm8350_rtc_resume,
-};
+static SIMPLE_DEV_PM_OPS(wm8350_rtc_pm_ops, wm8350_rtc_suspend,
+			wm8350_rtc_resume);
 
 static struct platform_driver wm8350_rtc_driver = {
 	.probe = wm8350_rtc_probe,
-- 
1.7.2.5


