Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3JGB53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:57:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13775 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3JGB5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:57:24 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-dc-5252150207eb
Date: Mon, 07 Oct 2013 10:57:22 +0900
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
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 12/20] iommu/exynos: support for device tree
Message-id: <20131007105722.ee6ef0ae648bb7f5ad093174@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t8zY10m0aAgg6c/LSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbH4wTf2gitiFS//L2JrYNwl1MXIySEhYCLx
	58MONghbTOLCvfVANheHkMAyRonve26ydzFygBV9+sYPEZ/OKLHteSsrhDOJSaL3ewczSDeL
	gKrEhrcHwSaxCWhJrJ57nBGkSESgjUnia+MhFhCHWeA0s8Sq3SvAOoQFHCTeHO8B6+AVcJS4
	s7ybHeIOC4kLTR3sEHFBiR+T77GA2MxAUzdva2KFsOUlNq95ywwyVEJgIofE3CedrBBnCEh8
	mwyyDeRuWYlNB5ghZkpKHFxxg2UCo8gsJGNnIRk7C8nYBYzMqxhFUwuSC4qT0otM9IoTc4tL
	89L1kvNzNzFCInnCDsZ7B6wPMSYDrZzILCWanA9MBHkl8YbGZkYWpiamxkbmlmakCSuJ86q3
	WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNSZqT75QM3cHOcLnM/PN75p/NO2ZWmEmV0p
	j6Gctd6ziq1hIr7f9YrjK33E1nRybXo2W2izf8LM6yt2uR5y3TnROfOobOGuRVWMquHT5KQn
	WRfHK2Rued38N+JCuZ6dt1O28KdDa61kOMpEv/++nyj1dsa7SWFK6nvuLnzDx552pz8vpuzj
	JCWW4oxEQy3mouJEAKzVHjv6AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQV0m0aAgg39TTSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj8YNv
	7AVXxCpe/l/E1sC4S6iLkYNDQsBE4tM3/i5GTiBTTOLCvfVsXYxcHEIC0xkltj1vZYVwJjFJ
	9H7vYAapYhFQldjw9iAbiM0moCWxeu5xRpAiEYE2JomvjYdYQBxmgdPMEqt2rwDrEBZwkHhz
	vAesg1fAUeLO8m52iH0WEheaOtgh4oISPybfYwGxmYGmbt7WxAphy0tsXvOWeQIj3ywkZbOQ
	lM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCaeCa9g3FVg8UhRgEORiUe3h33
	A4OEWBPLiitzDzFKcDArifBeqgMK8aYkVlalFuXHF5XmpBYfYkwG+nsis5Rocj4wheWVxBsa
	m5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+OaLBnpyy9d2aLfLzqX
	vq5un5ilDofp/Q9uVot+92uXn6g8z6+ju3/uPvlibj7xFUk6d9QMrrq4l/R06JZ4PHDKmsPj
	fI5FY5LzsjrbdvVZvU1PjWU59uqrffhufnhPQN7aykfhvjJ+71veHDvOqHahSmbGinkm3cb5
	ZgIKvituc04X6yxTUmIpzkg01GIuKk4EAMTJkTVXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds device tree support for System MMU.
This also include the following changes and enhancements:

* use managed device helper functions.
Simplyfies System MMU device driver.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/Kconfig        |    5 ++---
 drivers/iommu/exynos-iommu.c |   20 ++++++++++++++------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index fe302e3..062b71d 100644
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
index 6fdb3836..cf30519 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/export.h>
+#include <linux/of.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
@@ -342,7 +343,6 @@ static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
 {
 	unsigned long flags;
 	bool disabled = false;
-	int i;
 
 	write_lock_irqsave(&data->lock, flags);
 
@@ -378,7 +378,7 @@ finish:
 static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 			unsigned long pgtable, struct iommu_domain *domain)
 {
-	int i, ret = 0;
+	int ret = 0;
 	unsigned long flags;
 
 	write_lock_irqsave(&data->lock, flags);
@@ -508,7 +508,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
 	read_unlock_irqrestore(&data->lock, flags);
 }
 
-static int exynos_sysmmu_probe(struct platform_device *pdev)
+static int __init exynos_sysmmu_probe(struct platform_device *pdev)
 {
 	int irq, ret;
 	struct device *dev = &pdev->dev;
@@ -568,11 +568,19 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver exynos_sysmmu_driver = {
-	.probe		= exynos_sysmmu_probe,
-	.driver		= {
+#ifdef CONFIG_OF
+static struct of_device_id sysmmu_of_match[] __initconst = {
+	{ .compatible	= "samsung,exynos4210-sysmmu", },
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
1.7.2.5

