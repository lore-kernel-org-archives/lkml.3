Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299Ab3IDEYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:24:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58275 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab3IDEXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:23:54 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-8d-5226b5d28446
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 2/3] thermal: samsung: change base_common to more meaningful
 base_second
Date: Wed, 04 Sep 2013 09:53:48 +0530
Message-id: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378268629-2886-1-git-send-email-ch.naveen@samsung.com>
References: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
 <1378268629-2886-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSp3tpq1qQwdoPohYNV0MsNs5Yz2ox
	/8g5Vos1+38yWfQuuMpmcXnXHDaLz71HGC1mnN/HZLFo239miycP+9gcuDx2zrrL7rF4z0sm
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8ayKdNYCy7rVFzc/oO9gfGPShcjB4eE
	gInEux0CXYycQKaYxIV769m6GLk4hASWMkrc2LyRDSJhIjHvah8jRGI6o8TtA8tZIZweJomj
	106yg1SxCZhJHFy0GswWEfCSmPXwKhNIEbPASUaJy7/uMYIkhAWiJDbu/M4EYrMIqEqc2fwS
	rIFXwEXi28dnbBAnKUjMmWQDEuYUcJVobd3GAmILCdRLvD15lB1kpoTANnaJm6ensULMEZD4
	NvkQC0SvrMSmA8wQV0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIEx
	cPrfswk7GO8dsD7EmAw0biKzlGhyPjCG8kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8s
	Sc1OTS1ILYovKs1JLT7EyMTBKdXAGFVrZaNo4341P8KKYe7VHYZ7v72bNX27YGSW8Iz9VXe8
	33AYX3ITr/ef1f0z3+0Le13E+ZptVlpKBt6mh4KDlvsF+xd9413pIx6d1vHu2sfd7zXObKnz
	P/JrycsJSY/fd74N2hzPGLpI5UKY1vsd61k6p+lZnbresjp4f0DzzAChj29zD6RfVWIpzkg0
	1GIuKk4EAFT5j/6XAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd1LW9WCDOZ/4bZouBpisXHGelaL
	+UfOsVqs2f+TyaJ3wVU2i8u75rBZfO49wmgx4/w+JotF2/4zWzx52MfmwOWxc9Zddo/Fe14y
	efRtWcXocfzGdiaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	LJsyjbXgsk7Fxe0/2BsY/6h0MXJySAiYSMy72scIYYtJXLi3nq2LkYtDSGA6o8TtA8tZIZwe
	Jomj106yg1SxCZhJHFy0GswWEfCSmPXwKhNIEbPASUaJy7/ugY0SFoiS2LjzOxOIzSKgKnFm
	80uwBl4BF4lvH58BreAAWqcgMWeSDUiYU8BVorV1GwuILSRQL/H25FH2CYy8CxgZVjGKphYk
	FxQnpeca6RUn5haX5qXrJefnbmIEx9gz6R2MqxosDjEKcDAq8fAetFcLEmJNLCuuzD3EKMHB
	rCTCm+ADFOJNSaysSi3Kjy8qzUktPsSYDHTURGYp0eR8YPznlcQbGpuYmxqbWppYmJhZkias
	JM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANjbVbLBNXH67a8cdIKm8aqs/bTq4+hrkukcxtZ
	X9zv/LRCIsxY9GtarvzZJ26nLa9/+b9wU6nLj6jquyVWsy2uTVhcmfjNjKMz9dazou8b+coC
	/S5OdBe1MjV4o5A54+zE33rteeq2TG0pT2yiNjxZd/WJzeId8e3hkzmMxcxnrT/96JxHYetj
	JZbijERDLeai4kQA1jlgkvUCAAA=
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
Changes since v2:
Changed the flag name from SHARED_MEMORY to ADDRESS_MULTIPLE.
https://lkml.org/lkml/2013/8/1/38

 .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++--
 drivers/thermal/samsung/exynos_tmu.c               |   12 ++++++------
 drivers/thermal/samsung/exynos_tmu.h               |    4 ++--
 drivers/thermal/samsung/exynos_tmu_data.c          |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

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
index d201ed8..3a55caf 100644
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
@@ -451,7 +451,7 @@ static void exynos_tmu_work(struct work_struct *work)
 
 	/* Find which sensor generated this interrupt */
 	if (reg->tmu_irqstatus) {
-		val_type = readl(data->base_common + reg->tmu_irqstatus);
+		val_type = readl(data->base_second + reg->tmu_irqstatus);
 		if (!((val_type >> data->id) & 0x1))
 			goto out;
 	}
@@ -582,7 +582,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 	 * Check if the TMU shares some registers and then try to map the
 	 * memory of common registers.
 	 */
-	if (!TMU_SUPPORTS(pdata, SHARED_MEMORY))
+	if (!TMU_SUPPORTS(pdata, ADDRESS_MULTIPLE))
 		return 0;
 
 	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
@@ -590,7 +590,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	data->base_common = devm_ioremap(&pdev->dev, res.start,
+	data->base_second = devm_ioremap(&pdev->dev, res.start,
 					resource_size(&res));
 	if (!data->base) {
 		dev_err(&pdev->dev, "Failed to ioremap memory\n");
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 7c6c34a..ebd2ec1 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -59,7 +59,7 @@ enum soc_type {
  *			state(active/idle) can be checked.
  * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
  *			sample time.
- * TMU_SUPPORT_SHARED_MEMORY - This feature tells that the different TMU
+ * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
  *			sensors shares some common registers.
  * TMU_SUPPORT - macro to compare the above features with the supplied.
  */
@@ -69,7 +69,7 @@ enum soc_type {
 #define TMU_SUPPORT_FALLING_TRIP		BIT(3)
 #define TMU_SUPPORT_READY_STATUS		BIT(4)
 #define TMU_SUPPORT_EMUL_TIME			BIT(5)
-#define TMU_SUPPORT_SHARED_MEMORY		BIT(6)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(6)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 23fea23..58570d0 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -239,7 +239,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.type = SOC_ARCH_EXYNOS5440, \
 	.registers = &exynos5440_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
-			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
+			TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.7.9.5

