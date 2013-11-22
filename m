Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3KVGKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:10:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38177 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3KVGKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:10:48 -0500
X-AuditID: cbfee68f-b7f836d000001b39-8a-528ef56682d9
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, hs@denx.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, naveenkrishna.ch@gmail.com
Subject: [PATCH 1/2] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
Date: Fri, 22 Nov 2013 11:42:06 +0530
Message-id: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkWjfta1+Qwd8zKhaT1h1gsthx5z6z
	RePfSIuOv18YLS7vmsNmMeP8PiaLRdv+Mzuwe8ybdYLF4++qF8weO2fdZfe40nCSzePzJrkA
	1igum5TUnMyy1CJ9uwSujK6d39kKHotWdPV9YWpgfCPYxcjJISFgItF+pYEdwhaTuHBvPVsX
	IxeHkMBSRonzV1+zwBSt//4EKjGdUWLKh9tQTg+TxMwbD5hAqtgEzCQOLloNNkpEIEfi1elV
	rCA2s4C7xJJrrWC2sICXxPNvP8GmsgioSuz71s0GYvMKuEqs/jkXapuiRPezCWALJAR+s0m8
	/HuCCaJBQOLb5ENARRxACVmJTQeYIeolJQ6uuMEygVFwASPDKkbR1ILkguKk9CJjveLE3OLS
	vHS95PzcTYzAsD3971n/Dsa7B6wPMSYDjZvILCWanA8M+7ySeENjMyMLUxNTYyNzSzPShJXE
	ee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFhsuWk376VNXFO2WoSdvMCVcWBGaAOj
	TTWf+4sTs/jZrf5+VxRT9n99XCJs2vfV5QosAdXioozP9xiZ67x/s1Lnp8q0/rnRu0TULH8q
	LpwTEFrB2vol2CrCkk9E5q11/73EQKtPXE0GGpmfD4vevazhb7n+QhjvXeWzR1/LXj7xu1pQ
	L1rnoxJLcUaioRZzUXEiABau0e1xAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQd20r31BBhcvSVtMWneAyWLHnfvM
	Fo1/Iy06/n5htLi8aw6bxYzz+5gsFm37z+zA7jFv1gkWj7+rXjB77Jx1l93jSsNJNo/Pm+QC
	WKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZ07fzOVvBYtKKr7wtTA+Mb
	wS5GTg4JAROJ9d+fsEHYYhIX7q0Hsrk4hASmM0pM+XAbyulhkph54wETSBWbgJnEwUWr2UFs
	EYEciVenV7GC2MwC7hJLrrWC2cICXhLPv/1kAbFZBFQl9n3rBtvAK+AqsfrnXBaIbYoS3c8m
	sE1g5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgqnknvYFzVYHGIUYCDUYmHd4dl
	X5AQa2JZcWXuIUYJDmYlEd5fV4FCvCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgdGbF5JvKGx
	ibmpsamliYWJmSVpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MOZ9T53DVDbJZFJ1gGrK
	pzVunKuVYrXu+um2Xm1wOJEhsHxu1+oHP4oceDckv4mwORj211f3e8KEsE3xy+/ILoqtUSo8
	lP300XXj/ksftc4EPDc9c1Vo3aL4pQFflD9b6Qgq/I3+qnrmoC6/drPKt1/ajpVVb0waDN9w
	nP2acEeKy1rglvjX9UosxRmJhlrMRcWJALrbr5nOAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible to support HSI2C module on Exynos5260
HSI2C module on Exynos5260 needs to be reset during during initialization.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 .../devicetree/bindings/i2c/i2c-exynos5.txt        |    6 +++-
 drivers/i2c/busses/i2c-exynos5.c                   |   31 ++++++++++++++++++--
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
index 056732c..704ab92 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -5,7 +5,11 @@ at various speeds ranging from 100khz to 3.4Mhz.
 
 Required properties:
   - compatible: value should be.
-      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
+	-> "samsung,exynos5-hsi2c", for i2c compatible with HSI2C available on
+				Exynos5250/5420 SoCs.
+	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5260 SoCs.
+
   - reg: physical base address of the controller and length of memory mapped
     region.
   - interrupts: interrupt number to the cpu.
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index aca3991..cbb49e2 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -184,14 +184,35 @@ struct exynos5_i2c {
 	 * 2. Fast speed upto 1Mbps
 	 */
 	int			speed_mode;
+
+	/* Version of HS-I2C Hardware */
+	unsigned int		version;
+};
+
+enum hsi2c_version {
+	EXYNOS_5,
+	EXYNOS_5260
 };
 
 static const struct of_device_id exynos5_i2c_match[] = {
-	{ .compatible = "samsung,exynos5-hsi2c" },
+	{
+		.compatible = "samsung,exynos5-hsi2c",
+		.data = (void *)EXYNOS_5 },
+	{
+		.compatible = "samsung,exynos5260-hsi2c",
+		.data = (void *)EXYNOS_5260 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
 
+static inline unsigned int exynos5_i2c_get_version(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos5_i2c_match, pdev->dev.of_node);
+	return (unsigned int)match->data;
+}
+
 static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
 {
 	writel(readl(i2c->regs + HSI2C_INT_STATUS),
@@ -692,7 +713,13 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	exynos5_i2c_init(i2c);
+	i2c->version = exynos5_i2c_get_version(pdev);
+
+	/* The HS-I2C core on Exynos5260 needs a reset to start with */
+	if (i2c->version == EXYNOS_5260)
+		exynos5_i2c_reset(i2c);
+	else
+		exynos5_i2c_init(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.10.4

