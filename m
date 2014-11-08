Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaKHNWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:22:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39375 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaKHNWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:22:45 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f9-545e19231ec5
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v2 4/6] soc: samsung: exynos-pmu: Register exynos-pmu driver as
 a mfd driver
Date: Sat, 08 Nov 2014 18:46:39 +0530
Message-id: <1415452601-13078-5-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWyRsSkTldZMi7EYEmjukXD1RCL3gVX2Szu
	fz3KaLHp8TVWi8u75rBZzDi/j8ni8Jt2Vgd2jzvX9rB5bF5S79G3ZRWjx+dNcgEsUVw2Kak5
	mWWpRfp2CVwZv2fxF7RIVtz/otnA2CbaxcjJISFgIvH58j92CFtM4sK99WxdjFwcQgJLGSWm
	zHrPDlO0/PYWMFtIYDqjxKHdVRBFE5gklj3tB0uwCRhL/Ny5H8jm4BAR8JZYfk0RpIZZYAaj
	RE93KyNIjbBAnMT1lllg9SwCqhIdR3eBxXkF3CVurZ3FAtIrIaAgMWeSDUiYU8BDYsHebhaI
	ve4Smx7+YwSZKSHQzS6xZXkPC8QcAYlvkw9B9cpKbDrADHGzpMTBFTdYJjAKL2BkWMUomlqQ
	XFCclF5kolecmFtcmpeul5yfu4kRGNKn/z2bsIPx3gHrQ4wCHIxKPLw3WmJDhFgTy4orcw8x
	mgJtmMgsJZqcD4ycvJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MGpvj5VjVAl4JyV/IPVrfcVCw/8/bJjjs1WYVM/Z7mzOrF+olHf9oVSYbLmqzKq4
	z5/bJy/VrD7MKHJAh8mIyfj6zsJdDvcXz12U+8fxdsm9BWvc7P4krN1/7Gm2249zjA/505Y3
	KE9jDVk8nSM2U3tP+2e/f09Uul8cO2Itc2DCSq2wFckLkpVYijMSDbWYi4oTAaxErDxkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t9jQV1lybgQg4NrZS0aroZY9C64ymZx
	/+tRRotNj6+xWlzeNYfNYsb5fUwWh9+0szqwe9y5tofNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmPF7Fn9Bi2TF/S+aDYxtol2MnBwSAiYS
	y29vYYewxSQu3FvPBmILCUxnlDi0u6qLkQvInsAksexpP1gRm4CxxM+d+4FsDg4RAW+J5dcU
	QWqYBWYwSvR0tzKC1AgLxElcb5kFVs8ioCrRcXQXWJxXwF3i1tpZLCC9EgIKEnMm2YCEOQU8
	JBbs7WaB2OsusenhP8YJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRHzDOpHYwr
	GywOMQpwMCrx8N5oiQ0RYk0sK67MPcQowcGsJMLbex4oxJuSWFmVWpQfX1Sak1p8iNEU6KiJ
	zFKiyfnAaM4riTc0NjE3NTa1NLEwMbNUEuc90GodKCSQnliSmp2aWpBaBNPHxMEp1cAYfGTV
	nv0XGDgVHdiSOG8/Xrnm9sGzf270/nm/hKeMg+mBxVSrtwye6RfZtwpNuaMwZZbfwiC+8p7s
	abfTnGWyjHrF0+I2nN98Roxp1oajJYLM2ZdvLljTVDcr0FY7f8qVs7IFvNvdz/7WUZUOjtt5
	KXjTL4FGVrclIr29jc/NZ86Yu6ZUz+CzEktxRqKhFnNRcSIAvdhp6q4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be used later to probe and configure PMU client drivers
like pm domain, pm sleep etc. A global structure pmu_dev_client_data is
created to pass exynos-pmu platform data to all the clients. Currently
the data passed is register base addresses.
Although the exynos-pmu driver also provides the sysreg interfaces to
provide register base addresses but this is costlier than readl/writel,
so both the interfaces are provided to mfd based exynos-pmu client
drivers.

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/soc/samsung/exynos-pmu.c       |   24 ++++++++++++++++++++++++
 include/linux/soc/samsung/exynos-pmu.h |    5 +++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 3832cda..4a5eb50 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -12,11 +12,17 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/core.h>
 #include <linux/soc/samsung/exynos-regs-pmu.h>
 #include <linux/soc/samsung/exynos-pmu.h>
 
 #define PMU_TABLE_END	(-1U)
 
+enum pmu_mfd_list {
+	MFD_POWER_DOMAIN,
+	MFD_MAX,
+};
+
 struct exynos_pmu_conf {
 	unsigned int offset;
 	unsigned int val[NUM_SYS_POWERDOWN];
@@ -33,6 +39,8 @@ struct exynos_pmu_data {
 struct exynos_pmu_context {
 	struct device *dev;
 	const struct exynos_pmu_data *pmu_data;
+	struct mfd_cell cells[MFD_MAX];
+	struct pmu_dev_client_data mfd_data;
 };
 
 static void __iomem *pmu_base_addr;
@@ -482,6 +490,8 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	struct mfd_cell *cell;
+	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	pmu_base_addr = devm_ioremap_resource(dev, res);
@@ -506,6 +516,20 @@ static int exynos_pmu_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pmu_context);
 
+	/* Initialize and invoke mfd clients */
+	cell = &pmu_context->cells[MFD_POWER_DOMAIN];
+	cell->name = "exynos-pmu-sleep";
+	pmu_context->mfd_data.mem_base_addr = pmu_base_addr;
+	pmu_context->mfd_data.mem_size = resource_size(res);
+	cell->platform_data = &pmu_context->mfd_data;
+	cell->pdata_size = sizeof(pmu_context->mfd_data);
+	ret = mfd_add_devices(&pdev->dev, pdev->id, pmu_context->cells, MFD_MAX,
+				NULL, 0, NULL);
+	if (ret) {
+		dev_err(&pdev->dev, "fail to register client devices\n");
+		return ret;
+	}
+
 	dev_dbg(dev, "Exynos PMU Driver probe done\n");
 	return 0;
 }
diff --git a/include/linux/soc/samsung/exynos-pmu.h b/include/linux/soc/samsung/exynos-pmu.h
index a2ab0d5..d2f4083 100644
--- a/include/linux/soc/samsung/exynos-pmu.h
+++ b/include/linux/soc/samsung/exynos-pmu.h
@@ -19,6 +19,11 @@ enum sys_powerdown {
 	NUM_SYS_POWERDOWN,
 };
 
+struct pmu_dev_client_data {
+	void __iomem *mem_base_addr;
+	unsigned int mem_size;
+};
+
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
 
 #endif /* __EXYNOS_PMU_H */
-- 
1.7.9.5

