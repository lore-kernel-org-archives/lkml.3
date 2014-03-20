Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaCTC7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:59:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36123 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaCTC7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:59:23 -0400
X-AuditID: cbfee68f-b7f156d00000276c-ef-532a598a098c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, t.figa@samsaung.com, b.zolnierkie@samsaung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 4/5] devfreq: exynos5: Use SIMPLE_DEV_PM_OPS macro
Date: Thu, 20 Mar 2014 11:59:12 +0900
Message-id: <1395284353-22458-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
References: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkSLcrUivY4PpvVYuOnt8sFte/PGe1
	ONv0ht3i8q45bBYzzu9jsrjduILN4vGKt+wWN6fOZnLg8Fi85yWTx8/l29k9+rasYvT4vEku
	gCWKyyYlNSezLLVI3y6BK2Pe5mb2guncFXtf/mBtYFzL2cXIySEhYCJxdfVMJghbTOLCvfVs
	XYxcHEICSxkluvasZocp6ln6mBUisYhRYtb9nUwQTiOTxImJT8Cq2AS0JPa/uMEGYosImEvs
	WvoTbBSzwE5Gif23FzF2MXJwCAu4SDTuzQepYRFQleju6WQGsXkFXCXuX70HdYacxIc9j8Bm
	cgq4SRx9PBtsphBQzYcekDgXUM0idokPa+cyQgwSkPg2+RALyHwJAVmJTQeYIeZIShxccYNl
	AqPwAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBgX7637P+HYx3D1gfYkwGGjeRWUo0
	OR8YKXkl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gbH0TnAun9cWznOpix5sOskz3+Vsav6J76tmcryc4WOT3rzzZveEhbUv+54+P2QqLLisZNfT
	dsUtOYbrCgP/erXM1NHY8yBnwlU9mz2c65deO2rxRfdYw5zDqyTyV/OcU3z+9mtw3Kx6g/3G
	Yjr+TTK9/77pOJlGcgRFnHj8+sq1MGGJA+lLF05UYinOSDTUYi4qTgQAcpHIl4oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd2uSK1gg4Nv5Cw6en6zWFz/8pzV
	4mzTG3aLy7vmsFnMOL+PyeJ24wo2i8cr3rJb3Jw6m8mBw2PxnpdMHj+Xb2f36NuyitHj8ya5
	AJaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZ8zY3sxdM567Y+/IHawPj
	Ws4uRk4OCQETiZ6lj1khbDGJC/fWs3UxcnEICSxilJh1fycThNPIJHFi4hN2kCo2AS2J/S9u
	sIHYIgLmEruW/gTrYBbYySix//Yixi5GDg5hAReJxr35IDUsAqoS3T2dzCA2r4CrxP2r95gg
	tslJfNjzCGwmp4CbxNHHs8FmCgHVfOh5xD6BkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOA4eia9g3FVg8UhRgEORiUe3hV7NIOFWBPLiitzDzFKcDArifBau2sFC/GmJFZWpRbl
	xxeV5qQWH2JMBrpqIrOUaHI+MMbzSuINjU3MjCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2a
	WpBaBLOFiYNTqoExTl37T73EojdJyXXXfhVunRKvszfChafdQ/GI1t8FTClTdALfzHM7/eJ0
	7pPooLWnZTRMI/7dvbE75eZ7tSOHn0XKCX5dcnafDfPm9K2O19YZmh+aslVm1+yA1ZbpqptX
	Z+YI7g5Qn70kPlpU1Mqs3nZCWNuGsNkneC8GzeeYWRT4MPRQ+9lfSizFGYmGWsxFxYkAAl7+
	K+cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use SIMPLE_DEV_PM_OPS macro instead of legacy method.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos5_bus.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index 6eef1f7..af6213f 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -429,6 +429,7 @@ static int exynos5_busfreq_int_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int exynos5_busfreq_int_resume(struct device *dev)
 {
 	struct platform_device *pdev = container_of(dev, struct platform_device,
@@ -438,10 +439,12 @@ static int exynos5_busfreq_int_resume(struct device *dev)
 	busfreq_mon_reset(data);
 	return 0;
 }
-
 static const struct dev_pm_ops exynos5_busfreq_int_pm = {
 	.resume	= exynos5_busfreq_int_resume,
 };
+#endif
+static SIMPLE_DEV_PM_OPS(exynos5_busfreq_int_pm_ops, NULL,
+			 exynos5_busfreq_int_resume);
 
 /* platform device pointer for exynos5 devfreq device. */
 static struct platform_device *exynos5_devfreq_pdev;
@@ -452,7 +455,7 @@ static struct platform_driver exynos5_busfreq_int_driver = {
 	.driver		= {
 		.name		= "exynos5-bus-int",
 		.owner		= THIS_MODULE,
-		.pm		= &exynos5_busfreq_int_pm,
+		.pm		= &exynos5_busfreq_int_pm_ops,
 	},
 };
 
-- 
1.8.0

