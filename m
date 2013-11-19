Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3KSNDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:03:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:13669 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3KSND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:03:28 -0500
X-AuditID: cbfee68e-b7f416d0000020d6-ba-528b619e5bca
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH 2/4 v10] thermal: samsung: change base_common to more
 meaningful base_second
Date: Tue, 19 Nov 2013 18:34:51 +0530
Message-id: <1384866291-16034-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSozsvsTvIYP1HA4uGqyEWG2esZ7V4
	eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxWayf8ZrFgcdj
	56y77B6L97xk8ujbsorR4/iN7UwenzfJBbBGcdmkpOZklqUW6dslcGUc+L6IpeCDbsWME3kN
	jC9Vuxg5OSQETCROfj7KAmGLSVy4t56ti5GLQ0hgKaPE0dnLWWGKDj8DKQJJLGKUaPtxjx3C
	6WGSuDx9PjNIFZuAmcTBRavZQWwRARmJqVf2s4IUMQvMZ5I49GctWEJYIE7i575PQDs4OFgE
	VCUWdWSChHkFXCVu3L3ABLFNUaL72QQ2EJsTKP7x+Q9GEFtIwEVi/8s1zCAzJQQOsUs8e/IF
	rIhFQEDi2+RDLCAzJQRkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al
	6yXn525iBEbF6X/P+nYw3jxgfYgxGWjcRGYp0eR8YFTllcQbGpsZWZiamBobmVuakSasJM67
	6GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGvVNua8vON/n1c7vmL+7W15P7HemoJBcT
	cMyW7eEH95+lIpe4JvM+u3fkT/3LlHinuR2Tghf6/3l5OfDuu8TUR56FLQl8+UcDf097bbF4
	1luVpR5bF16z/jEjbof+/3i/7Z+ZQ7h9WRwstwZm+4Y+YT1p9eTfuRNXp0Q8rpL0sk572K17
	pqJWiaU4I9FQi7moOBEADQS1HqACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAd15id1BBnteq1s0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzWL9jNcsDjwe
	O2fdZfdYvOclk0ffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxoHvi1gKPuhWzDiR18D4UrWLkZNDQsBE4vCzoywQtpjEhXvr2boYuTiEBBYx
	SrT9uMcO4fQwSVyePp8ZpIpNwEzi4KLV7CC2iICMxNQr+1lBipgF5jNJHPqzFiwhLBAn8XPf
	J6BRHBwsAqoSizoyQcK8Aq4SN+5eYILYpijR/WwCG4jNCRT/+PwHI4gtJOAisf/lGuYJjLwL
	GBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH3DPpHYyrGiwOMQpwMCrx8E5w7woSYk0s
	K67MPcQowcGsJMJrHNQdJMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wHSQVxJvaGxibmps
	amliYWJmSZqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MMuuFm6eaCcQ9Z/wY8/7DCqtv
	36fsO6HxMLZq7TahVMenzyM27dF0esUhll9TsSC+RT7jCle9xYITxnXHt7YoTGP6etg1Vjpr
	WquV0ZMVmtFfLO5oBLYv4o1eNq1T7ubTr2ue/+/faO7O8k3vpa5i1sFjU5TCpodMbLVODZ/+
	IUV9QsRM0+BrSizFGYmGWsxFxYkAzpDkgP0CAAA=
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
---
Changes since v9:
Just respinning

Changes since v8:
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

