Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3LSGF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 01:05:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:47643 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3LSGFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:05:23 -0500
X-AuditID: cbfee68e-b7fb46d00000186a-19-52b28ca1769d
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH v12 2/4] thermal: samsung: change base_common to more
 meaningful base_second
Date: Thu, 19 Dec 2013 11:36:08 +0530
Message-id: <1387433168-7831-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSpbuwZ1OQwertehYNV0MsNs5Yz2rx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjs1g/4zWLA4/H
	zll32T0W73nJ5NG3ZRWjx/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4Mr48uoVc8FrvYr7DauY
	GxivqHUxcnJICJhIHJr3nBXCFpO4cG89WxcjF4eQwFJGie3Pp7PBFC25dJkRIrGIUWLSpXcs
	EE4Pk8Sn3ZdYQKrYBMwkDi5azQ5iiwjISEy9sp8VpIhZYD6TxKE/a8ESwgJxEpNXbABrYBFQ
	lfhz/jsTiM0r4CLxcNMzFoh1ihLdzyaAreYUcJX4+PwHI4gtBFSz/+UaZpChEgKH2CV6Jr1h
	hxgkIPFt8iGgZg6ghKzEpgPMEHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CIjveLE3OLSvHS9
	5PzcTYzAyDj971nfDsabB6wPMSYDjZvILCWanA+MrLySeENjMyMLUxNTYyNzSzPShJXEeRc9
	TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwDhrkp5JVfMkmydpZ87Hhc7i+S02+eZNtmO3
	fIpqlu1bujSDd45IZp+Qzd9jge/0AhZ6Bku7PO/TYPa+JfH+ed2z6ZK6wVl6k57o3V5ifpxh
	K3tUQ7/m1CWdn/4WS+R/t/R0q3m7SXWrkXtfXcyRaZV+RW/CFiUmaS5nX9h47dbTJN7ka23R
	l5VYijMSDbWYi4oTARwVEbqiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAd2FPZuCDDbOUbVouBpisXHGelaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjC+vXjEXvNaruN+wirmB8YpaFyMnh4SAicSSS5cZIWwxiQv31rN1MXJxCAks
	YpSYdOkdC4TTwyTxafclFpAqNgEziYOLVrOD2CICMhJTr+xnBSliFpjPJHHoz1qwhLBAnMTk
	FRvAGlgEVCX+nP/OBGLzCrhIPNz0jAVinaJE97MJbCA2p4CrxMfnP8DOEAKq2f9yDfMERt4F
	jAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj7pnUDsaVDRaHGAU4GJV4eFe83BgkxJpY
	VlyZe4hRgoNZSYT3CsumICHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB6aEvJJ4Q2MTc1Nj
	U0sTCxMzS9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgZCwI5DUrmFJZ69p81lH5juw+
	p/lql5sPdPK5zpnCvC7k9t5s71sCriX2TDtFD/+0j9fY+6pFs/+1sPUxhW2pzv+LeaZ6Xfpe
	I33xwAzOyiV6y2/wrbwyJzx5s0rAo/bjDumdb16ZrDiotdjNidkjV1k8yPePcHrS1IoMz9VB
	bGs+28dsFr2sxFKckWioxVxUnAgAWCa/yP8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos5440 and Exynos5420 there are registers common
across the TMU channels.

To support that, we introduced a ADDRESS_MULTIPLE flag in the
driver and the 2nd set of register base and size are provided
in the "reg" property of the node.

As per Amit's suggestion, this patch changes the base_common
to base_second and SHARED_MEMORY to ADDRESS_MULTIPLE.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
Changes since v11:
Added Reviewed by Tomasz

Changes since v10:
Documentation rephrased as per comments from Tomasz Figa

 .../devicetree/bindings/thermal/exynos-thermal.txt       |    4 ++--
 drivers/thermal/samsung/exynos_tmu.c                     |   14 +++++++-------
 drivers/thermal/samsung/exynos_tmu.h                     |    4 ++--
 drivers/thermal/samsung/exynos_tmu_data.c                |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 284f530..a1aa602 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -11,8 +11,8 @@
 - reg : Address range of the thermal registers. For soc's which has multiple
 	instances of TMU and some registers are shared across all TMU's like
 	interrupt related then 2 set of register has to supplied. First set
-	belongs	to each instance of TMU and second set belongs to common TMU
-	registers.
+	belongs	to register set of TMU instance and second set belongs to
+	registers shared with the TMU instance.
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index c493245..bbd0fc3 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -41,7 +41,7 @@
  * @id: identifier of the one instance of the TMU controller.
  * @pdata: pointer to the tmu platform/configuration data
  * @base: base address of the single instance of the TMU controller.
- * @base_common: base address of the common registers of the TMU controller.
+ * @base_second: base address of the common registers of the TMU controller.
  * @irq: irq number of the TMU controller.
  * @soc: id of the SOC type.
  * @irq_work: pointer to the irq work structure.
@@ -56,7 +56,7 @@ struct exynos_tmu_data {
 	int id;
 	struct exynos_tmu_platform_data *pdata;
 	void __iomem *base;
-	void __iomem *base_common;
+	void __iomem *base_second;
 	int irq;
 	enum soc_type soc;
 	struct work_struct irq_work;
@@ -297,7 +297,7 @@ skip_calib_data:
 	}
 	/*Clear the PMIN in the common TMU register*/
 	if (reg->tmu_pmin && !data->id)
-		writel(0, data->base_common + reg->tmu_pmin);
+		writel(0, data->base_second + reg->tmu_pmin);
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
@@ -454,7 +454,7 @@ static void exynos_tmu_work(struct work_struct *work)
 
 	/* Find which sensor generated this interrupt */
 	if (reg->tmu_irqstatus) {
-		val_type = readl(data->base_common + reg->tmu_irqstatus);
+		val_type = readl(data->base_second + reg->tmu_irqstatus);
 		if (!((val_type >> data->id) & 0x1))
 			goto out;
 	}
@@ -579,7 +579,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 	 * Check if the TMU shares some registers and then try to map the
 	 * memory of common registers.
 	 */
-	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
+	if (!TMU_SUPPORTS(pdata, ADDRESS_MULTIPLE))
 		return 0;
 
 	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
@@ -587,9 +587,9 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	data->base_common = devm_ioremap(&pdev->dev, res.start,
+	data->base_second = devm_ioremap(&pdev->dev, res.start,
 					resource_size(&res));
-	if (!data->base_common) {
+	if (!data->base_second) {
 		dev_err(&pdev->dev, "Failed to ioremap memory\n");
 		return -ENOMEM;
 	}
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 980859a..0d6b32f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -60,7 +60,7 @@ enum soc_type {
  *			state(active/idle) can be checked.
  * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
  *			sample time.
- * TMU_SUPPORT_SHARED_MEMORY - This feature tells that the different TMU
+ * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
  *			sensors shares some common registers.
  * TMU_SUPPORT - macro to compare the above features with the supplied.
  */
@@ -70,7 +70,7 @@ enum soc_type {
 #define TMU_SUPPORT_FALLING_TRIP		BIT(3)
 #define TMU_SUPPORT_READY_STATUS		BIT(4)
 #define TMU_SUPPORT_EMUL_TIME			BIT(5)
-#define TMU_SUPPORT_SHARED_MEMORY		BIT(6)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(6)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 7cdb04e..1d27069 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -255,7 +255,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.type = SOC_ARCH_EXYNOS5440, \
 	.registers = &exynos5440_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
+			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.7.10.4

