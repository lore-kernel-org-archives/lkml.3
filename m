Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3CKJjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:39:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41477 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3CKJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:39:33 -0400
X-AuditID: cbfee68e-b7f946d000001e37-49-513da654de02
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c901ce1e3c$26d976a0$748c63e0$%han@samsung.com>
In-reply-to: <00c901ce1e3c$26d976a0$748c63e0$%han@samsung.com>
Subject: [PATCH 3/3] backlight: generic_bl: use dev_info() instead of pr_info()
Date: Mon, 11 Mar 2013 18:39:32 +0900
Message-id: <00cb01ce1e3c$558ba810$00a2f830$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ePCa8v3pUfLowT1qxE3rZdWcGSgAACPKA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY92QZbaBBpffyVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MXS+uMBbc4qi48K+ogXE+excjJ4eEgIlE69OlrBC2mMSFe+vZ
	uhi5OIQEljFKfFt2gAmm6OSL24wQiUWMEuebLzNBOLOZJE53bAJrZxNQk/jy5TDQWA4OEQF9
	ibYWDZAws0CpxNYH71lAbCEBW4nzE98xg9icAnYSH/8cArtCWMBfovnxW0YQm0VAVWJmw0Sw
	OC9Q/fpLixkhbEGJH5PvsUDM1JLYvK2JFcKWl9i85i0zyFoJAXWJR391QcIiAkYSR7dNYoQo
	EZHY9+Id2P0SAovYJWZe7meF2CUg8W3yIRaIXlmJTQeYIf6VlDi44gbLBEaJWUg2z0KyeRaS
	zbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySu+nYw3jxgfYgxGWj9RGYp0eR8
	YFzmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx
	ZetslZNFX3e33tT1ftDKKGbk3VERJz1lxrVikROXT9k+3tVw1eP5k+YQb+GpwXJ+H7dUT39n
	d+/puqCr3/NnuvFuXpR6S+HfnH/9L5x+/3adJS525Vd04MKEkNLwqYtSm94d2rz7md3rg4Gq
	fyYkKcjHpC7h5lQMucvBftgjTGzK+xSB5uZaJZbijERDLeai4kQAO0RqUsECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7IMttAgyvfJS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxq4XVxgLbnFUXPhX1MA4
	n72LkZNDQsBE4uSL24wQtpjEhXvr2boYuTiEBBYxSpxvvswE4cxmkjjdsYkVpIpNQE3iy5fD
	QN0cHCIC+hJtLRogYWaBUomtD96zgNhCArYS5ye+YwaxOQXsJD7+OQS2TFjAX6L58VuwZSwC
	qhIzGyaCxXmB6tdfWswIYQtK/Jh8jwVippbE5m1NrBC2vMTmNW+ZQdZKCKhLPPqrCxIWETCS
	OLptEiNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgqH0mtYNxZYPFIUYBDkYlHt4JOraBQqyJZcWVuYcYJTiYlUR4V26yCRTiTUmsrEot
	yo8vKs1JLT7EmAz06ERmKdHkfGBCySuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGRivl50ve5J5/YqS6P9PWzOdU1sLakCXHFx5Im6Sb+92qLGpyuRJXRv5r
	RxX5OYb3gpeIKQoI9J9P/9oosjF3SbnTUXG1/arxE5bOURFZOn/Sr2tWKWub/up1PpNvmtnm
	OKkrf8bfl+f0mtTuiQTlt9/eErKyVqF25v33C/8671wX4CA40cjpsRJLcUaioRZzUXEiAJ4D
	Jm4eAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_info() is more preferred than pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/generic_bl.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 0ae155b..19e393b 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -9,8 +9,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -108,7 +106,7 @@ static int genericbl_probe(struct platform_device *pdev)
 
 	generic_backlight_device = bd;
 
-	pr_info("Generic Backlight Driver Initialized.\n");
+	dev_info(&pdev->dev, "Generic Backlight Driver Initialized.\n");
 	return 0;
 }
 
@@ -122,7 +120,7 @@ static int genericbl_remove(struct platform_device *pdev)
 
 	backlight_device_unregister(bd);
 
-	pr_info("Generic Backlight Driver Unloaded\n");
+	dev_info(&pdev->dev, "Generic Backlight Driver Unloaded\n");
 	return 0;
 }
 
-- 
1.7.2.5


