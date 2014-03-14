Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbaCNFJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:09:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57274 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaCNFJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:09:37 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-39-53228f10dcae
Date: Fri, 14 Mar 2014 14:09:35 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 13/27] iommu/exynos: support for device tree
Message-id: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zY12BfqVgg1PvxSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpYdja2YIVwxf7f15kbGF/ydzFyckgImEhMm9rDCmGL
	SVy4t56ti5GLQ0hgGaPEyl3nWGCKvj5bxwyRWMQosXDzJSYIZzKTxP2nu5lAqlgEVCUeTF8H
	ZrMJaEmsnnucEaRIRKCNSeJr4yEWEIdZYC6zxMdvc4CWcHAICzhILPoVCdLAK+AosW7DS2aI
	dRYSF5o62CHighI/Jt8DO4MZaOjmbU2sELa8xOY1b8FOkhDo5ZDYte4jC8QVAhLfJoMs4wBK
	yEpsOgA1U1Li4IobLBMYRWYhGTsLydhZSMYuYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7
	iRESvRN3MN4/YH2IMRlo5URmKdHkfGD055XEGxqbGVmYmpgaG5lbmpEmrCTOm/4oKUhIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QDoyyL+HNDjaVVWunuTqdXf70iILi//aTKqwuPHynlnstP
	U87Z9KdHaMlhP5Zvar/UGhsEH/45evbctTWJczM9d/nPFX9/WurJhy9zvtV+l1oiwZW+5Yp/
	6J7Ox67Z8rfNvFgim1QWRfDN0yjZcjlL4cksTzmnK97tW/bU5ToJ5VhY11o/YA7+r8RSnJFo
	qMVcVJwIAFh/6oH0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV2BfqVgg/WNghZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PF+hmvWSxm3lrD4sDv8eTgPCaP2Q0XWTz+He5n8rhzbQ+bx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gB9oKRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMWHY2tmCFcMX+
	39eZGxhf8ncxcnJICJhIfH22jhnCFpO4cG89WxcjF4eQwCJGiYWbLzFBOJOZJO4/3c0EUsUi
	oCrxYPo6MJtNQEti9dzjjCBFIgJtTBJfGw+xgDjMAnOZJT5+mwM0i4NDWMBBYtGvSJAGXgFH
	iXUbXkKts5C40NTBDhEXlPgx+R4LiM0MNHTztiZWCFteYvOat8wTGPlmISmbhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCU8MzqR2MKxssDjEKcDAq8fA6HFYMFmJNLCuu
	zD3EKMHBrCTCWxWhFCzEm5JYWZValB9fVJqTWnyIMRno7YnMUqLJ+cC0lVcSb2hsYmZkaWRm
	YWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjHslpA2+2ikfmBTwmPGhdb/c1+8/
	etpT5t74pPJ54fE1U16vMfTV4g5/NKu/1mdHZKvShvdbT5wUmXU3tqZcyTLt9lmne4dMu8TU
	D9dVfvAtcqu6nblRXuThvd//dz9509/YfGCboP/7sM3MzUpnuVzZLBv+P2w3/mzTlRVUu+3B
	4hP7DzXOP63EUpyRaKjFXFScCAC0qTseUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds device tree support for System MMU.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/Kconfig        |    5 ++---
 drivers/iommu/exynos-iommu.c |   21 +++++++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index df56e4c..22af807 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -178,16 +178,15 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
+	depends on ARCH_EXYNOS
 	select IOMMU_API
+	default n
 	help
 	  Support for the IOMMU(System MMU) of Samsung Exynos application
 	  processor family. This enables H/W multimedia accellerators to see
 	  non-linear physical memory chunks as a linear memory in their
 	  address spaces
 
-	  If unsure, say N here.
-
 config EXYNOS_IOMMU_DEBUG
 	bool "Debugging log for Exynos IOMMU"
 	depends on EXYNOS_IOMMU
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 33b424d..34feb04 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/of.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
@@ -497,7 +498,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
-static int exynos_sysmmu_probe(struct platform_device *pdev)
+static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
 	struct device *dev = &pdev->dev;
@@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver exynos_sysmmu_driver = {
-	.probe		= exynos_sysmmu_probe,
-	.driver		= {
+#ifdef CONFIG_OF
+static struct of_device_id sysmmu_of_match[] __initconst = {
+	{ .compatible	= "samsung,sysmmu-v1", },
+	{ .compatible	= "samsung,sysmmu-v2", },
+	{ .compatible	= "samsung,sysmmu-v3.1", },
+	{ .compatible	= "samsung,sysmmu-v3.2", },
+	{ .compatible	= "samsung,sysmmu-v3.3", },
+	{ },
+};
+#endif
+
+static struct platform_driver exynos_sysmmu_driver __refdata = {
+	.probe	= exynos_sysmmu_probe,
+	.driver	= {
 		.owner		= THIS_MODULE,
 		.name		= "exynos-sysmmu",
+		.of_match_table	= of_match_ptr(sysmmu_of_match),
 	}
 };
 
-- 
1.7.9.5

