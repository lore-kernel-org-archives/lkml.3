Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaCTC7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:59:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58042 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaCTC7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:59:22 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-c0-532a5988f686
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, t.figa@samsaung.com, b.zolnierkie@samsaung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 2/5] devfreq: exynos4: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 20 Mar 2014 11:59:10 +0900
Message-id: <1395284353-22458-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkQLcjUivYYMF1G4uOnt8sFte/PGe1
	ONv0ht3i8q45bBYzzu9jsrjduILN4vGKt+wWN6fOZnLg8Fi85yWTx8/l29k9+rasYvT4vEku
	gCWKyyYlNSezLLVI3y6BK+PbvT7GgqtcFSs2L2dtYPzF0cXIySEhYCIxZfF3JghbTOLCvfVs
	XYxcHEICSxklmm42M8MUnWnpZoZILGKU6DrygBHCaWSS6F5yFKydTUBLYv+LG2wgtoiAucSu
	pT/BRjEL7GSU2H97EVAHB4ewgIvE9Q/SIDUsAqoSnw8uYQSxeQVcJV6/vcwIsU1O4sOeR+wg
	NqeAm8TRx7PBZgoB1XzoAYlzAdUsYpfYffkVM8QgAYlvkw+xgMyXEJCV2HQA6mpJiYMrbrBM
	YBRewMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMw0E//ezZxB+P9A9aHGJOBxk1klhJN
	zgdGSl5JvKGxmZGFqYmpsZG5pRlpwkrivOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MDbLMi19umfX7WAb/q/a92QuzC7Z4XChXmECI/PL364TXzeY7eJv0NXMkgr8+W9CM8t1h8LG
	pIrLqeLvirveTjOL2ee92t5QKnHpiS+hv1e5Hf65sfq1w9dXZv2yibf8y/lkX7FYBdloHrqh
	ytzXm59R6rhK0k3p563ahJavtsufPvNwqgvgVGIpzkg01GIuKk4EAKIF3RyKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd2OSK1gg7VrTS06en6zWFz/8pzV
	4mzTG3aLy7vmsFnMOL+PyeJ24wo2i8cr3rJb3Jw6m8mBw2PxnpdMHj+Xb2f36NuyitHj8ya5
	AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ3+71MRZc5apYsXk5awPj
	L44uRk4OCQETiTMt3cwQtpjEhXvr2boYuTiEBBYxSnQdecAI4TQySXQvOcoEUsUmoCWx/8UN
	NhBbRMBcYtfSn2AdzAI7GSX2314E1MHBISzgInH9gzRIDYuAqsTng0sYQWxeAVeJ128vM0Js
	k5P4sOcRO4jNKeAmcfTxbLCZQkA1H3oesU9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85
	P3cTIziOnkntYFzZYHGIUYCDUYmHd8UezWAh1sSy4srcQ4wSHMxKIrzW7lrBQrwpiZVVqUX5
	8UWlOanFhxiTga6ayCwlmpwPjPG8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqem
	FqQWwWxh4uCUamDcxRWiUf5IZvZ71q/eEmcUbSJ87TuYLFTPicomzvhsP1P7wYT9Ubed8sTv
	nzc2FdBwm6u6f+9u2UtWOber/3i/SF1wsL6tVM07TiwgsG7Pxwn2E6MSpCsulEi9vF4g8EGs
	p1alR8nx4dxHDK18Tu8cOua8WZPufP32TCmH7f3Ml+80ap9sOaXEUpyRaKjFXFScCAByUvQ3
	5wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use SIMPLE_DEV_PM_OPS macro instead of legacy method.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 4c1bbd9..5a48d16 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -1119,6 +1119,7 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int exynos4_busfreq_resume(struct device *dev)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
@@ -1126,10 +1127,9 @@ static int exynos4_busfreq_resume(struct device *dev)
 	busfreq_mon_reset(data);
 	return 0;
 }
+#endif
 
-static const struct dev_pm_ops exynos4_busfreq_pm = {
-	.resume	= exynos4_busfreq_resume,
-};
+static SIMPLE_DEV_PM_OPS(exynos4_busfreq_pm_ops, NULL, exynos4_busfreq_resume);
 
 static const struct platform_device_id exynos4_busfreq_id[] = {
 	{ "exynos4210-busfreq", TYPE_BUSF_EXYNOS4210 },
@@ -1145,7 +1145,7 @@ static struct platform_driver exynos4_busfreq_driver = {
 	.driver = {
 		.name	= "exynos4-busfreq",
 		.owner	= THIS_MODULE,
-		.pm	= &exynos4_busfreq_pm,
+		.pm	= &exynos4_busfreq_pm_ops,
 	},
 };
 
-- 
1.8.0

