Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab3KFN02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:26:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52458 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab3KFN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:26:24 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-83-527a437f6b13
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: [PATCH 2/3 v7] thermal: samsung: change base_common to more meaningful
 base_second
Date: Wed, 06 Nov 2013 18:58:02 +0530
Message-id: <1383744482-22791-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSp1vvXBVksLZR1qLhaojFxhnrWS1e
	HtK0mH/kHKvFmv0/mSx6F1xls7i8aw6bxefeI4wWM87vY7JYtO0/s8WTh31sDtweO2fdZfdY
	vOclk0ffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugStjw+FP7AX39Spe9yY3MG5T62Lk
	5JAQMJE4f+kNI4QtJnHh3nq2LkYuDiGBpYwSCzs/snYxcoAVPZ+QAhFfxCjx5PtWFginh0ni
	6KmtrCDdbAJmEgcXrWYHsUUEZCSmXtnPClLELNDNJDF/xTkWkISwQKzEldczGUGmsgioSqxY
	AVbPK+AqcbhvAzPEFYoS3c8msIHYnEDxj89/gF0nJOAisf/lGqiafewSU3cUgNgsAgIS3yYf
	YoE4VFZi0wGoEkmJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzAOTv97
	1reD8eYB60OMyUDjJjJLiSbnA+MoryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwMjiWZRvvrS3u+RNasHB1nvmaNSf4pQTUZBc+mBP4r37fR+bH
	9oV7/Tbyz2tTvbYkU9S5csOmjUyWF9K266o6nJzVXiF0okAk0tD/3l2Gha2ca9/c2Om25L3z
	DefD9x35zm8/+DNpQxHbZnlrBnOr4C9/K38yKe6teD5BPvrc4oqX89XUXqfPVWIpzkg01GIu
	Kk4EAItqY6OZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd1656ogg8Nt/BYNV0MsNs5Yz2rx
	8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjc+D22DnrLrvH
	4j0vmTz6tqxi9Dh+YzuTx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CWsYMzYc/sRecF+v4nVvcgPjNrUuRg4OCQETiecTUroYOYFMMYkL99azdTFycQgJLGKUePJ9
	KwuE08MkcfTUVlaQKjYBM4mDi1azg9giAjISU6/sZwUpYhboZpKYv+IcC0hCWCBW4srrmYwg
	G1gEVCVWrACr5xVwlTjct4EZYpuiRPezCWwgNidQ/OPzH4wgtpCAi8T+l2uYJzDyLmBkWMUo
	mlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHGfPpHYwrmywOMQowMGoxMObIF8ZJMSaWFZcmXuI
	UYKDWUmE18qgKkiINyWxsiq1KD++qDQntfgQYzLQUROZpUST84EpIK8k3tDYxNzU2NTSxMLE
	zJI0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGFlqbu2zreHdLLh96dZa9ajpRzlvb3tT
	+sro85eK6dGvHc/UfN17e0XmnS/L4//81PjjlaN4lO/UmkmqRjvvzY7Tazz26CiHXUfdTcNz
	Qudd1lWZBckXnL3/T+K4cPHdOvPEPWf0v17S71w8MTHwYljwb/kFxwyLEqNtWq3+b2Y6VvZn
	kVrmtUlKLMUZiYZazEXFiQAfMPjJ9wIAAA==
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
---
Changes since v1:
 None
Changes since v2:
 Changed the flag name from SHARED_MEMORY to ADDRESS_MULTIPLE.
 https://lkml.org/lkml/2013/8/1/38
Changes since v3:
 None
Changes since v4:
 Corrected a compilation error, undeclared variable
Changes since v5:
 None
Changes since v6:
 None


 .../devicetree/bindings/thermal/exynos-thermal.txt       |    4 ++--
 drivers/thermal/samsung/exynos_tmu.c                     |   14 +++++++-------
 drivers/thermal/samsung/exynos_tmu.h                     |    4 ++--
 drivers/thermal/samsung/exynos_tmu_data.c                |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index 284f530..116cca0 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -11,8 +11,8 @@
 - reg : Address range of the thermal registers. For soc's which has multiple
 	instances of TMU and some registers are shared across all TMU's like
 	interrupt related then 2 set of register has to supplied. First set
-	belongs	to each instance of TMU and second set belongs to common TMU
-	registers.
+	belongs	to each instance of TMU and second set belongs to second set
+	of common TMU registers.
 - interrupts : Should contain interrupt for thermal system
 - clocks : The main clock for TMU device
 - clock-names : Thermal system clock name
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b2202fa..ae80a87 100644
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
index 5f4fe6c..d79264f 100644
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
index c6e67e9..ad424ad 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -257,7 +257,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.type = SOC_ARCH_EXYNOS5440, \
 	.registers = &exynos5440_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
+			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.7.10.4

