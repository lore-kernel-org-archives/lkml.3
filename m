Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3H1JQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:16:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3H1JQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:16:47 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-eb-521dbffd3ed0
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH 2/3] thermal: samsung: change base_common to more meaningful
 base_second
Date: Wed, 28 Aug 2013 14:46:48 +0530
Message-id: <1377681409-18166-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377681409-18166-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
 <1377681409-18166-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSpft3v2yQwdJnRhYNV0Ms5h85x2qx
	Zv9PJoveBVfZLC7vmsNm8bn3CKPFjPP7mCwWbfvPbPHkYR+bA6fHzll32T0W73nJ5NG3ZRWj
	x/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4Mq4v7WfreCDVMWMab0sDYx9Yl2MnBwSAiYSjUtm
	sUPYYhIX7q1n62Lk4hASWMoo8W/9fcYuRg6wolN7kiHi0xkl9v5ZwwTh9DBJnPxykwWkm03A
	TOLgotVgk0QEvCRmPbwKVsQssJ5R4tD2tcwgCWGBKImNO78zgdgsAqoS9+Z/YwWxeQVcJaZe
	uMAOsU1BYs4kG5Awp4CbxO03xxkhljUySkz/sBxsqITAJnaJFRNesEEMEpD4NvkQC0SzrMSm
	A8wQ70hKHFxxg2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIGhf/rfs/4djHcP
	WB9iTAYaN5FZSjQ5Hxg7eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgbAjd4fK1w+2HiPMWk4cLl/8PcTozmcliW/QXw3MNzHHxX9S8pCykmcsf
	3T7SwxbevrplZ/bP7xyHnpzT9pse9yTs1d2yQx+9L/jEF7benXHr4FnOzy831YY8qnLf/PlO
	arT/1WQu1RMuTe9dkg/ErDueX+8rV5RaU7xlDi9T+hr+R42z7iZ6K7EUZyQaajEXFScCAPEW
	LyuTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd2/+2WDDOYt0rBouBpiMf/IOVaL
	Nft/Mln0LrjKZnF51xw2i8+9RxgtZpzfx2SxaNt/ZosnD/vYHDg9ds66y+6xeM9LJo++LasY
	PY7f2M7k8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjPtb+9kK
	PkhVzJjWy9LA2CfWxcjBISFgInFqT3IXIyeQKSZx4d56ti5GLg4hgemMEnv/rGGCcHqYJE5+
	uckCUsUmYCZxcNFqdhBbRMBLYtbDq2BFzALrGSUObV/LDJIQFoiS2LjzOxOIzSKgKnFv/jdW
	EJtXwFVi6oUL7BCbFSTmTLIBCXMKuEncfnOcEWJZI6PE9A/LmSYw8i5gZFjFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERxZz6R2MK5ssDjEKMDBqMTDa7FZJkiINbGsuDL3EKMEB7OSCC//
	dtkgId6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HRn1eSbyhsYm5qbGppYmFiZklacJK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLYwcXBKNTBK7r+2Y1nS3HXGnTO8Imz+vppx3sfR3KgnoWGmoP02
	Y6XXHNZtHEnnlzxI44lXVnHtyxGNlVqZ52ihvppJy5NRznjlwuPCEfdO/xXZnXLGVvGc/vT9
	j2Ktdn82mBNurn9WlJux9WdDnfeMGWcCrL65fbY/eMyUtbq67Y/I4rmTZSfncltZyiqxFGck
	GmoxFxUnAgDzSB0H8AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos5440 and Exynos5420 there are registers common
across the TMU channels.

To support that, we introduced a SHARED_MEMORY flag in the
driver and the 2nd set of register base and size are provided
in the "reg" property of the node.

As per Amit's suggestion, this patch changes the base_common
to base_second.
https://lkml.org/lkml/2013/8/1/38

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++--
 drivers/thermal/samsung/exynos_tmu.c               |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

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
index d201ed8..c56f7e5 100644
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
@@ -590,7 +590,7 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	data->base_common = devm_ioremap(&pdev->dev, res.start,
+	data->base_second = devm_ioremap(&pdev->dev, res.start,
 					resource_size(&res));
 	if (!data->base) {
 		dev_err(&pdev->dev, "Failed to ioremap memory\n");
-- 
1.7.9.5

