Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaCLLsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:48:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65120 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaCLLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:48:16 -0400
Date: Wed, 12 Mar 2014 20:47:59 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/4] devfreq: exynos4: Support devicetree to get device id of
 Exynos4 SoC
In-reply-to: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-id: <1394624882-2989-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
DLP-Filter: Pass
X-AuditID: cbfee68f-b7f156d00000276c-51-5320497eccfa
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkULfeUyHY4HUXk8X1L89ZLc42vWG3
	6P6RbXF51xw2i8+9RxgtbjeuYLN48+Msk8XjFW/ZHTg8Fu95yeTRt2UVo8fxG9uZPD5vkgtg
	ieKySUnNySxLLdK3S+DK6NzaxlSwV6Cie4VFA+Nz3i5GTg4JAROJOa8PsUHYYhIX7q0Hsrk4
	hASWMkq8ubmPDaZoz4n1jBCJ6YwSh8+vY4JwGpkk+nvvsoBUsQloSex/cQOsQ0TAXGLX0p9g
	o5gF1jJKPPo0BywhLBAtsXbuP1YQm0VAVWL78Y1AYzk4eAVcJB43SUNsk5P4sOcRO4jNKeAq
	cXXNcUYQWwio5M/FLSwgMyUE5rFLXL7yH2qOgMS3yYdYQOZICMhKbDrADDFHUuLgihssExiF
	FzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIDPLT/57172C8e8D6EGMy0LiJzFKiyfnA
	KMkriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxz
	msvPKO+cERDjYMS584wM39oTO6eZHI54uiaTo7GTVSl56c5O+UXRWTOVt8qlrSnr6novxac9
	pZPl8LnLy3ffaKk/+c6SP+alA4t4ib7nXw3fsvAXk25subvj61YPBnfX64/vXTLapPZpZY+p
	dXHY1fI92/c1VOouWSceasow5cQB8b8szy4osRRnJBpqMRcVJwIA9mnTfogCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd06T4Vgg6XHzS2uf3nOanG26Q27
	RfePbIvLu+awWXzuPcJocbtxBZvFmx9nmSwer3jL7sDhsXjPSyaPvi2rGD2O39jO5PF5k1wA
	S1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0BlK
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozOrW1MBXsFKrpXWDQwPuft
	YuTkkBAwkdhzYj0jhC0mceHeerYuRi4OIYHpjBKHz69jgnAamST6e++ygFSxCWhJ7H9xgw3E
	FhEwl9i19CdYB7PAWkaJR5/mgCWEBaIl1s79xwpiswioSmw/vhFoBQcHr4CLxOMmaYhtchIf
	9jxiB7E5BVwlrq45DnaFEFDJn4tbWCYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	ERxDz6R2MK5ssDjEKMDBqMTDu0BTPliINbGsuDL3EKMEB7OSCO8uW4VgId6UxMqq1KL8+KLS
	nNTiQ4zJQEdNZJYSTc4HxndeSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTC2X/gs5azr4J0lNp2ngP3b5YSZty2O/WB63fx73kvZdYFC+0Wu6j8RapBTWcfz
	y5Bt3uaXZz0Ceg+YieoKX92/8PvJtS0JcqoXGuQixSN3uPitF7gp1GBhcpNt0rM9vH8ebD1/
	/PWy+X6y+n91Wed77fLRefEuaJvuDHellZylu3Y8UH1y0phfiaU4I9FQi7moOBEAUP//gOUC	AAA=
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support DT(DeviceTree) method to probe exynos4_bus and get device
id of each Exynos4 SoC by using dt helper function.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index e07b0c6..168a7c6 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -23,6 +23,7 @@
 #include <linux/devfreq.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
+#include <linux/of.h>
 #include <linux/module.h>
 
 /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
@@ -1017,6 +1018,28 @@ unlock:
 	return NOTIFY_DONE;
 }
 
+static struct of_device_id exynos4_busfreq_id_match[] = {
+	{
+		.compatible = "samsung,exynos4210-busfreq",
+		.data = (void *)TYPE_BUSF_EXYNOS4210,
+	}, {
+		.compatible = "samsung,exynos4x12-busfreq",
+		.data = (void *)TYPE_BUSF_EXYNOS4x12,
+	},
+};
+
+static int exynos4_busfreq_get_driver_data(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos4_busfreq_id_match, dev->of_node);
+	if (!match)
+		return -ENODEV;
+
+	return (int) match->data;
+}
+
 static int exynos4_busfreq_probe(struct platform_device *pdev)
 {
 	struct busfreq_data *data;
@@ -1030,7 +1053,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	data->type = pdev->id_entry->driver_data;
+	data->type = exynos4_busfreq_get_driver_data(pdev);
 	data->dmc[0].hw_base = S5P_VA_DMC0;
 	data->dmc[1].hw_base = S5P_VA_DMC1;
 	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
@@ -1135,6 +1158,7 @@ static struct platform_driver exynos4_busfreq_driver = {
 		.name	= "exynos4-busfreq",
 		.owner	= THIS_MODULE,
 		.pm	= &exynos4_busfreq_pm,
+		.of_match_table = exynos4_busfreq_id_match,
 	},
 };
 
-- 
1.8.0

