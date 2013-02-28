Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3B1EFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:05:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36242 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3B1EFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:05:08 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-76-512ed76b6596
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: atmel-pwm-bl: remove erroneous __exit annotation
Date: Thu, 28 Feb 2013 13:04:59 +0900
Message-id: <009801ce1568$c6832a70$53897f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4VaMZK/2U6vu2+TDmktd1woodJ1A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI93s63qBBm2/xCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowz82aw
	FDRyVEzo/sTawHibrYuRk0NCwETi7okmFghbTOLCvfVgcSGBZYwSS5c6w9SsvdvIChGfzihx
	659aFyMXkP2LUeLflc+MIAk2ATWJL18Os3cxcnCICOhLtLVogISZBUoltj54DzZfWMBHYtrd
	l2BzWARUJdrbZ7GD2LwCthJ7uvYyQ9iCEj8m32OB6NWSWL/zOBOELS+xec1bZpDxEgLqEo/+
	6oKERQT0JF7N3MYIUSIise/FO0aQ0yQEtrFLTNv5khFil4DEt8mHWCB6ZSU2HWCGeEtS4uCK
	GywTGMVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkAjr28F4
	84D1IcZkoPUTmaVEk/OBEZpXEm9obGxiZmJqYm5pam5KmrCSOK/8JZlAIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYyrpIWNu/3Z5hW/f9xWvql00e1G7U+Fhq3GKg0FhyxZCt0f7srVe1+5
	wLjkO/vJtx9L1X3yOfqKGd6Ydb+8kzE13iMkeaX7jHqlOzc0Ij8Gv6k+pu60YvImHnUDYcvf
	r6y+OZ399tG307D2eWfdhinL4xob4ips1t/KlFaO+9zxjin0zdSIyUosxRmJhlrMRcWJAIdR
	m5LGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd3s63qBBruuCVnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZZ+bNYClo5KiY0P2JtYHxNlsXIyeHhICJxNq7jawQtpjEhXvr
	weJCAtMZJW79U+ti5AKyfzFK/LvymREkwSagJvHly2H2LkYODhEBfYm2Fg2QMLNAqcTWB+9Z
	QGxhAR+JaXdfgs1kEVCVaG+fxQ5i8wrYSuzp2ssMYQtK/Jh8jwWiV0ti/c7jTBC2vMTmNW+Z
	QcZLCKhLPPqrCxIWEdCTeDVzGyNEiYjEvhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILk
	guKk9FxDveLE3OLSvHS95PzcTYzgCH4mtYNxZYPFIUYBDkYlHt4OE71AIdbEsuLK3EOMEhzM
	SiK82+qAQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTC55JfGGxiZmRpZGZhZGJubmpAkr
	ifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoEx88z/tbmFYvfmv4x8JH9hXc/imx1iQh+OzMyc
	UVUac3CH4D8ZyQ1u02sqjV81tk/YEh13eOnB3f+N/j+6eE7gx2EnwT27bk/y2Fy00dLEe1/6
	jivPeLO3/9ubfkTE12bDjw2r/sakfPX9F6Dptcoi2O45d82sVkfGezEntXqvmxYu8Uj58v5x
	hhJLcUaioRZzUXEiAJ3jJackAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_HOTPLUG was removed, so __devexit or __exit of remove()
should not be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index de5e5e7..24b90fa 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -203,7 +203,7 @@ err_free_mem:
 	return retval;
 }
 
-static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
+static int atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
@@ -222,7 +222,7 @@ static struct platform_driver atmel_pwm_bl_driver = {
 		.name = "atmel-pwm-bl",
 	},
 	/* REVISIT add suspend() and resume() */
-	.remove = __exit_p(atmel_pwm_bl_remove),
+	.remove = atmel_pwm_bl_remove,
 };
 
 static int __init atmel_pwm_bl_init(void)
-- 
1.7.2.5


