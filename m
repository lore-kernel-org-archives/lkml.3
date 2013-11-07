Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab3KGMlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:41:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56958 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3KGMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:40:59 -0500
X-AuditID: cbfee68d-b7fa16d0000029b0-a1-527b8a596712
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: [PATCH] thermal: exynos: handle gate clock for misplaced TRIMINFO
 register
Date: Thu, 07 Nov 2013 18:12:34 +0530
Message-id: <1383828154-428-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkSjeyqzrI4NVmTouGqyEWG2esZ7V4
	eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOXB77Jx1l91j
	8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6MC/MbWQuaZCr+75jP2sDYJ97F
	yMEhIWAiMb3JvIuRE8gUk7hwbz1bFyMXh5DAUkaJ55dAHE6wmoap81kgEosYJa5dO8wCkhAS
	6GGSaD6WC2KzCZhJHFy0mh3EFhGQkZh6ZT8rSAOzQDeTxPwV58AahAVCJU7dnMEMsplFQFWi
	Y58ASJhXwFli7rkVTBDLFCW6n00Au0JCYBG7xJIl85hBEiwCAhLfJh9igbhaVmLTAWaIekmJ
	gytusExgFFzAyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzCwT/971ruD8fYB60OMyUDj
	JjJLiSbnAyMjryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYPeR+HWudE97C6qJTqHe1ZuU894KGgwHf0h+IzWpV07TqeJvgx+0fz8PK4pjE4unw
	rNXg/IfNJZz252IqBNdKafhdmht8bfXzDYZeRWuq5t2Ukzm5fHb99tOrKlpfXS8Nubvl9nPX
	4KMK9qeeVejeXDI5X9lO99+WqgWfzXdnagv6Xj7AVbdfiaU4I9FQi7moOBEAlxLIS4ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jAd2Iruogg7XLbCwaroZYbJyxntXi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjH5sDtsXPWXXaP
	xXteMnn0bVnF6HH8xnYmj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYwZlyY38ha0CRT8X/HfNYGxj7xLkZODgkBE4mGqfNZIGwxiQv31rN1MXJxCAksYpS4du0w
	WEJIoIdJovlYLojNJmAmcXDRanYQW0RARmLqlf2sIA3MAt1MEvNXnANrEBYIlTh1cwZzFyMH
	B4uAqkTHPgGQMK+As8TccyuYIJYpSnQ/m8A2gZF7ASPDKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgyHkmvYNxVYPFIUYBDkYlHt4ZNVVBQqyJZcWVuYcYJTiYlUR4m0Oqg4R4UxIrq1KL
	8uOLSnNSiw8xJgMtn8gsJZqcD4zqvJJ4Q2MTc1NjU0sTCxMzS9KElcR5D7ZaBwoJpCeWpGan
	phakFsFsYeLglGpgzL622P+WxeX9h0LOOn98X9OnZDp3r9lSfc+GQ5/2X7fjkfOQ3q5x5fER
	Wde2X2H8Fa9bbwTbd8jfnzHt6PHPLJuNC71yrCK2ukxmS/Lf+uz4qt8391cJRKwpfLFmDYu+
	YnG79Yauz3vM516V3VDC1nDz4aJNsXctpYNjd0fvPlf+bBEP7+OlGUosxRmJhlrMRcWJANP1
	vi/gAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos5420 the TMU(4) for GPU has a seperate clock enable bit from
the other TMU channels(0 ~ 3). Hence, accessing TRIMINFO for base_second
should be acompanied by enabling the respective clock.

This patch which allow for a "clk_sec" clock to be specified in the
device-tree which will be ungated when accessing the TRIMINFO register.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index b54825a..33edd1a 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -47,6 +47,7 @@
  * @irq_work: pointer to the irq work structure.
  * @lock: lock to implement synchronization.
  * @clk: pointer to the clock structure.
+ * @clk_sec: pointer to the clock structure for accessing the base_second.
  * @temp_error1: fused value of the first point trim.
  * @temp_error2: fused value of the second point trim.
  * @regulator: pointer to the TMU regulator structure.
@@ -61,7 +62,7 @@ struct exynos_tmu_data {
 	enum soc_type soc;
 	struct work_struct irq_work;
 	struct mutex lock;
-	struct clk *clk;
+	struct clk *clk, *clk_sec;
 	u8 temp_error1, temp_error2;
 	struct regulator *regulator;
 	struct thermal_sensor_conf *reg_conf;
@@ -152,6 +153,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
+	if (!IS_ERR(data->clk_sec))
+		clk_enable(data->clk_sec);
 
 	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
 		status = readb(data->base + reg->tmu_status);
@@ -306,6 +309,8 @@ skip_calib_data:
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	if (!IS_ERR(data->clk_sec))
+		clk_disable(data->clk_sec);
 
 	return ret;
 }
@@ -457,12 +462,16 @@ static void exynos_tmu_work(struct work_struct *work)
 	const struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int val_irq, val_type;
 
+	if (!IS_ERR(data->clk_sec))
+		clk_enable(data->clk_sec);
 	/* Find which sensor generated this interrupt */
 	if (reg->tmu_irqstatus) {
 		val_type = readl(data->base_second + reg->tmu_irqstatus);
 		if (!((val_type >> data->id) & 0x1))
 			goto out;
 	}
+	if (!IS_ERR(data->clk_sec))
+		clk_disable(data->clk_sec);
 
 	exynos_report_trigger(data->reg_conf);
 	mutex_lock(&data->lock);
@@ -641,6 +650,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	data->clk_sec = devm_clk_get(&pdev->dev, "tmu_apbif_sec");
+	if (!IS_ERR(data->clk_sec)) {
+		ret = clk_prepare(data->clk_sec);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to get clock\n");
+			return  PTR_ERR(data->clk_sec);
+		}
+	}
+
 	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
 	    pdata->type == SOC_ARCH_EXYNOS4412 ||
 	    pdata->type == SOC_ARCH_EXYNOS5250 ||
@@ -713,6 +731,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	return 0;
 err_clk:
 	clk_unprepare(data->clk);
+	if (!IS_ERR(data->clk_sec))
+		clk_unprepare(data->clk_sec);
 	return ret;
 }
 
@@ -725,6 +745,8 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 	exynos_unregister_thermal(data->reg_conf);
 
 	clk_unprepare(data->clk);
+	if (!IS_ERR(data->clk_sec))
+		clk_unprepare(data->clk_sec);
 
 	if (!IS_ERR(data->regulator))
 		regulator_disable(data->regulator);
-- 
1.7.10.4

