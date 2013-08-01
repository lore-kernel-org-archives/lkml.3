Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3HAKlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:41:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14628 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3HAKlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:41:11 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-b9-51fa3b441ed7
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com
Subject: [PATCH v2] thermal: exynos: Handle the misplaced TRIMINFO register
Date: Thu, 01 Aug 2013 16:06:07 +0530
Message-id: <1375353367-20346-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkStfV+legwYSNLBYNV0Ms1uz/yWTR
	u+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjc+Dw2DnrLrvH4j0vmTz6tqxi9Dh+YzuT
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZK35kFzzXrPj8cB1bA+NkpS5GTg4JAROJ5e27WCFsMYkL
	99azdTFycQgJLGWU+HrnJxNM0acza5ghEosYJXom7GeCcHqYJF5+ecUCUsUmYCZxcNFqdhBb
	RMBLYtbDq2BFzAITGSXurj3G2MXIwSEs4C3x66MPSA2LgKrEpO61LCBhXgFXiRcXUkBMCQEF
	iTmTbEAqOAXcJF4s2wd2gxBIxa+Z7BD3LGOX6FpQDjFFQOLb5EMsEK2yEpsOMEOUSEocXHGD
	ZQKj8AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgYF++t+z3h2Mtw9YH2JMBho3kVlK
	NDkfGCl5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amA872lRcaNn++4/H6e9/PR1XsrJWzPM8ndImd0SfiTwnSlhdzWD0Q/f9MrNsbqzWn6ZTOPt
	FNWe9kz4q++xnOC/ydu/V9psTcw7e81ulZ+UA7NjMJ9p1ORb23KY0qe1RdnZJR95+NM081fs
	57BnsdG/6oL8ZZV/HVl+b+WWCVFCjlknLp+uqkpQYinOSDTUYi4qTgQAYc+WTIoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV0X61+BBi9vWVg0XA2xWLP/J5NF
	74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzYHDY+esu+wei/e8ZPLo27KK0eP4je1M
	Hp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFjxI7vguWbF54fr
	2BoYJyt1MXJySAiYSHw6s4YZwhaTuHBvPVsXIxeHkMAiRomeCfuZIJweJomXX16xgFSxCZhJ
	HFy0mh3EFhHwkpj18CpYEbPAREaJu2uPMXYxcnAIC3hL/ProA1LDIqAqMal7LQtImFfAVeLF
	hRQQU0JAQWLOJBuQCk4BN4kXy/YxgdhCIBW/ZrJPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4kp5J72Bc1WBxiFGAg1GJhzdj689AIdbEsuLK3EOMEhzMSiK8jzV+BQrxpiRW
	VqUW5ccXleakFh9iTAa6aSKzlGhyPjDK80riDY1NzE2NTS1NLEzMLEkTVhLnPdhqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBcdFEhu0hG5pdDgY55wq2HI+Scig6+7RondmO07HFF1axsiw4ILQ5
	IDavXVH24KVj6X8zVjFbvgj3FI/vXFWbcWmucdY1wwUsUs8mPlPY4LMyL04o0M/h4a4nFw4K
	cbemLRWdUBD79VFFohnnNg8b8abNZWYxWv8lmZdyi+jV3FWNOHI59MxpJZbijERDLeai4kQA
	JqaTLOgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to handle the misplaced TRIMINFO register
incase of Exynos5420.

On Exynos5420 we have a TRIMINFO register being misplaced for
TMU channels 2, 3 and 4

TRIMINFO at 0x1006c000 contains data for TMU channel 3
TRIMINFO at 0x100a0000 contains data for TMU channel 4
TRIMINFO at 0x10068000 contains data for TMU channel 2

The misplaced register address is passed through devicetree and
map it seperately during probe.
Also, adds the documentation under devicetree/bindings/thermal/

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
Changes since v1:
Rebased on http://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git

 .../devicetree/bindings/thermal/exynos-thermal.txt |   48 ++++++++++++++++++++
 drivers/thermal/exynos_thermal.c                   |   26 ++++++++++-
 2 files changed, 72 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt

diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
new file mode 100644
index 0000000..1db279e
--- /dev/null
+++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
@@ -0,0 +1,48 @@
+* Exynos Thermal
+
+Required properties:
+- compatible: should be one of the following.
+    * "samsung,exynos4210-tmu" - for controllers compatible with exynos4210 tmu.
+    * "samsung,exynos5250-tmu" - for controllers compatible with exynos5250 tmu.
+    * "samsung,exynos5420-tmu" - for controllers compatible with exynos5420 tmu.
+
+- reg: physical base address of the controller and length of
+  memory mapped region.
+
+    ** NOTE FOR EXYNOS5420 **
+    TRIMINFO register is being misplaced for TMU channels 2, 3 and 4
+
+    TERMINFO for TMU channel 2 is present in address space of TMU channel 3
+    TERMINFO for TMU channel 3 is present in address space of TMU channel 4
+    TERMINFO for TMU channel 4 is present in address space of TMU channel 2
+
+    * In such cases the reg property contains the misplaced register address and
+      range as the second parameter.
+
+- interrupts : interrupt number to the cpu.
+- clocks : Clock number as per common clock framework for the cpu.
+- clock-names : clock name to be used in the driver
+
+Example:
+
+	/* tmu for CPU0 */
+	tmu@10060000 {
+		compatible = "samsung,exynos5420-tmu";
+		reg = <0x10060000 0x100>;
+		interrupts = <0 65 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
+Example: In case of Exynos5420 TMU channel 3
+
+	/* tmu for CPU3 */
+	tmu@1006c000 {
+		compatible = "samsung,exynos5420-tmu";
+		/* 2nd reg is for the misplaced TRIMINFO register */
+		reg = <0x1006c000 0x100>, <0x100a0000 0x4>;
+		interrupts = <0 185 0>;
+		clocks = <&clock 318>;
+		clock-names = "tmu_apbif";
+	};
+
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index d20ce9e..1ad9005 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -38,6 +38,7 @@
 #include <linux/cpufreq.h>
 #include <linux/cpu_cooling.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 
 /* Exynos generic registers */
 #define EXYNOS_TMU_REG_TRIMINFO		0x0
@@ -120,7 +121,7 @@
 struct exynos_tmu_data {
 	struct exynos_tmu_platform_data *pdata;
 	struct resource *mem;
-	void __iomem *base;
+	void __iomem *base, *triminfo_base;
 	int irq;
 	enum soc_type soc;
 	struct work_struct irq_work;
@@ -593,8 +594,14 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		__raw_writel(EXYNOS_TRIMINFO_RELOAD,
 				data->base + EXYNOS_TMU_TRIMINFO_CON);
 	}
+
 	/* Save trimming info in order to perform calibration */
-	trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
+	if (data->triminfo_base)
+		/* On exynos5420 TRIMINFO is misplaced for some channels */
+		trim_info = readl(data->triminfo_base);
+	else
+		trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
+
 	data->temp_error1 = trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
 	data->temp_error2 = ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK);
 
@@ -941,6 +948,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* For Exynos5420 The misplaced TERMINFO register address will be
+	 * passed from device tree node.
+	 *
+	 * We cannot use devm_request_and_ioremap, as the base address
+	 * over laps with the address space of the other TMU channel.
+	 * Check Documentation for details
+	 */
+	data->triminfo_base = of_iomap(pdev->dev.of_node, 1);
+
 	data->clk = devm_clk_get(&pdev->dev, "tmu_apbif");
 	if (IS_ERR(data->clk)) {
 		dev_err(&pdev->dev, "Failed to get clock\n");
@@ -1001,6 +1017,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 
 	return 0;
 err_clk:
+	if (data->triminfo_base)
+		iounmap(data->triminfo_base);
+
 	platform_set_drvdata(pdev, NULL);
 	clk_unprepare(data->clk);
 	return ret;
@@ -1014,6 +1033,9 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_unregister_thermal();
 
+	if (data->triminfo_base)
+		iounmap(data->triminfo_base);
+
 	clk_unprepare(data->clk);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.9.5

