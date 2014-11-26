Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaKZAvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:51:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13428 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaKZAvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:51:16 -0500
X-AuditID: cbfee68e-f79b46d000002b74-e0-547524029bc1
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: rui.zhang@intel.com, edubezval@gmail.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, kesavan.abhilash@gmail.com,
        l.majewski@samsung.com, cw00.choi@samsung.com
Subject: [PATCH v2] thermal: exynos: add special clock support
Date: Wed, 26 Nov 2014 06:21:10 +0530
Message-id: <1416963070-5806-1-git-send-email-a.kesavan@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkSpdJpTTE4OQJPouGqyEWG2esZ7W4
	/uU5q8X8K9dYLdb8VbJ483Azo8XlXXPYLD73HmG0ePKwj82B02PnrLvsHov3vGTy6NuyitHj
	8ya5AJYoLpuU1JzMstQifbsEroy1944xFlxSrzg47ydjA+N8hS5GTg4JAROJd6/3sEDYYhIX
	7q1n62Lk4hASWMoocX/ZYyaYot6ThxghEosYJb6t+M8M4fQxSUzt/MMGUsUmoCex4N9XZhBb
	RMBNYvGif+wgRcwgHc1bvrGDJIQF7CSunDgJNIqDg0VAVWL1OR2QMK+Ai8SD3gdsIGEJAQWJ
	OZNsIBa3s0u8O+YLYrMICEh8m3yIBaJEVmLTAWaIEkmJgytusExgFFzAyLCKUTS1ILmgOCm9
	yEivODG3uDQvXS85P3cTIzB0T/971reD8eYB60OMAhyMSjy8EVKlIUKsiWXFlbmHGE2BNkxk
	lhJNzgdGSF5JvKGxmZGFqYmpsZG5pZmSOG+C1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYz9udPKFscs2hJeobNsikpwULNs6OJ7p3VFRc3ubdrgGiJeI+X/fpn+rBdhdU+kNPQN03f4
	L3G0lIhsSe1c/3Bn/8pT2hPNY56/9jL+4mqpyn7pscgGm1kPk6NL9v1RdI/U0dd+6T+5w95x
	VsLT2+ryzqrLT0b+fpTzffnkWxfZu6RTTRoyNZVYijMSDbWYi4oTAYDPnDtYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jAV0mldIQg4aLLBYNV0MsNs5Yz2px
	/ctzVov5V66xWqz5q2Tx5uFmRovLu+awWXzuPcJo8eRhH5sDp8fOWXfZPRbvecnk0bdlFaPH
	501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz1t47xlhwSb3i4Lyf
	jA2M8xW6GDk5JARMJHpPHmKEsMUkLtxbz9bFyMUhJLCIUeLbiv/MEE4fk8TUzj9sIFVsAnoS
	C/59ZQaxRQTcJBYv+scOUsQM0tG85Rs7SEJYwE7iyomTQGM5OFgEVCVWn9MBCfMKuEg86H3A
	BhKWEFCQmDPJZgIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbHxTHoH46oGi0OM
	AhyMSjy8EVKlIUKsiWXFlbmHGCU4mJVEeCUYgEK8KYmVValF+fFFpTmpxYcYTYF2T2SWEk3O
	B8ZtXkm8obGJuamxqaWJhYmZpZI4742buSFCAumJJanZqakFqUUwfUwcnFINjFNVL7hlK73U
	S2Odf3qXzEP52AQfs9Pv3nE1bjl9xGuq2S7dOY+lsya/0TPbftvDyPmoyqbZfoXfbizpVLzk
	cXiFvNGZjrzLh/9evJUwY+mqfpGNVvtXCk/6WaO3PWHZb/ENrtfeJP54V+7C4CtrVPjlk7jb
	SedP8wqfXX9rnyQ13V/lasza2+lKLMUZiYZazEXFiQCJS/MdowIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos7 has a special clock required for the functional operation
of the TMU that is not present in earlier SoCs. Add support for
this clock and update the binding documentation.

Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
Changes since v1:
	- Added a per-soc flag to indicate the presence of special clock
	- Changed the name of special clock from "tmu_sclk" to "sclk"
	- Fixed the error handling for sclk

Tested on 5420 and 5800 based chromebooks, no change in existing behavior.

 .../devicetree/bindings/thermal/exynos-thermal.txt |    3 ++
 drivers/thermal/samsung/exynos_tmu.c               |   31 ++++++++++++++++----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
index ae738f5..acf4705 100644
--- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -32,10 +32,13 @@
 - clocks : The main clocks for TMU device
 	-- 1. operational clock for TMU channel
 	-- 2. optional clock to access the shared registers of TMU channel
+	-- 3. optional special clock for functional operation
 - clock-names : Thermal system clock name
 	-- "tmu_apbif" operational clock for current TMU channel
 	-- "tmu_triminfo_apbif" clock to access the shared triminfo register
 		for current TMU channel
+	-- "sclk" clock for functional operation of the current TMU
+		channel
 - vtmu-supply: This entry is optional and provides the regulator node supplying
 		voltage to TMU. If needed this entry can be placed inside
 		board/platform specific dts file.
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index d44d91d..8ed8409 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -123,11 +123,14 @@
  * @base: base address of the single instance of the TMU controller.
  * @base_second: base address of the common registers of the TMU controller.
  * @irq: irq number of the TMU controller.
+ * @needs_sclk: SoC specific flag indicating that sclk is required for
+	functional operation of the TMU controller.
  * @soc: id of the SOC type.
  * @irq_work: pointer to the irq work structure.
  * @lock: lock to implement synchronization.
  * @clk: pointer to the clock structure.
  * @clk_sec: pointer to the clock structure for accessing the base_second.
+ * @sclk: pointer to the clock structure for accessing the tmu special clock.
  * @temp_error1: fused value of the first point trim.
  * @temp_error2: fused value of the second point trim.
  * @regulator: pointer to the TMU regulator structure.
@@ -144,10 +147,11 @@ struct exynos_tmu_data {
 	void __iomem *base;
 	void __iomem *base_second;
 	int irq;
+	bool needs_sclk;
 	enum soc_type soc;
 	struct work_struct irq_work;
 	struct mutex lock;
-	struct clk *clk, *clk_sec;
+	struct clk *clk, *clk_sec, *sclk;
 	u8 temp_error1, temp_error2;
 	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
@@ -883,10 +887,24 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk_sec;
 	}
 
+	if (data->needs_sclk) {
+		data->sclk = devm_clk_get(&pdev->dev, "sclk");
+		if (IS_ERR(data->sclk)) {
+			dev_err(&pdev->dev, "Failed to get sclk\n");
+			goto err_clk;
+		} else {
+			ret = clk_prepare_enable(data->sclk);
+			if (ret) {
+				dev_err(&pdev->dev, "Failed to enable sclk\n");
+				goto err_clk;
+			}
+		}
+	}
+
 	ret = exynos_tmu_initialize(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize TMU\n");
-		goto err_clk;
+		goto err_sclk;
 	}
 
 	exynos_tmu_control(pdev, true);
@@ -896,7 +914,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 				sizeof(struct thermal_sensor_conf), GFP_KERNEL);
 	if (!sensor_conf) {
 		ret = -ENOMEM;
-		goto err_clk;
+		goto err_sclk;
 	}
 	sprintf(sensor_conf->name, "therm_zone%d", data->id);
 	sensor_conf->read_temperature = (int (*)(void *))exynos_tmu_read;
@@ -928,7 +946,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	ret = exynos_register_thermal(sensor_conf);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register thermal interface\n");
-		goto err_clk;
+		goto err_sclk;
 	}
 	data->reg_conf = sensor_conf;
 
@@ -936,10 +954,12 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
-		goto err_clk;
+		goto err_sclk;
 	}
 
 	return 0;
+err_sclk:
+	clk_disable_unprepare(data->sclk);
 err_clk:
 	clk_unprepare(data->clk);
 err_clk_sec:
@@ -956,6 +976,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, false);
 
+	clk_disable_unprepare(data->sclk);
 	clk_unprepare(data->clk);
 	if (!IS_ERR(data->clk_sec))
 		clk_unprepare(data->clk_sec);
-- 
1.7.9.5

