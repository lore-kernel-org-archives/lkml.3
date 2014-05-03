Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaECFyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 01:54:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54537 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaECFxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 01:53:37 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-b1-5364846094e7
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: [PATCH 1/4] ARM: EXYNOS: remove soc_is_exynos4/5 from exynos.c
Date: Sat, 03 May 2014 15:11:37 +0900
Message-id: <1399097500-4052-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+Zvm5CS0qwwbtr/Bb/H71mtehdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8WxGUsYHTg9Wpp72DzuXNvD5rF5Sb1H
	35ZVjB7br81j9vi8SS6ALYrLJiU1J7MstUjfLoErY+LKJcwF18Urbi3SaGD8L9zFyMkhIWAi
	8byngRXCFpO4cG89WxcjF4eQwDJGiQWrrzHBFC3/0sQEkZjOKDH70UNmCKeNSeL2om2MIFVs
	AroST97PZQaxRQSyJa403gcrYhY4wCjx7clhsFHCAu4SH3e9B2rg4GARUJXo2isEYvIChc/N
	jwYxJQQUJOZMsgEp5hTwkPjycBcbiC0EVDF7/kRGkIkSApvYJa4tXAh2NYuAgMS3yYdYIHpl
	JTYdYIa4WVLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECAn+iTsY7x+w
	PsSYDDRuIrOUaHI+MHrySuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoFxy+5ZrLe71vxxDvJfZHTL+9vq6WZ2kffn6soI2gl83329695rWZ0OsY/5
	RU7Vex1v/3VZmH/P6vtt87/Ry1b1LkwvW6wb32a6s2lOo1e3Q95c6amNPEe7Ipa9lqo9ajxr
	kiNj/gmhk+cNopY6LVvE62pdkVHZyexheOvMrvLuJdMX9IfVNs5VYinOSDTUYi4qTgQAnfqe
	xZQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd2ElpRgg0PTuSz+P3rNatG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFotjM5YwOnB6tDT3sHncubaHzWPzknqP
	vi2rGD22X5vH7PF5k1wAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyJ
	K5cwF1wXr7i1SKOB8b9wFyMnh4SAicTyL01MELaYxIV769m6GLk4hASmM0rMfvSQGcJpY5K4
	vWgbI0gVm4CuxJP3c5lBbBGBbIkrjffBipgFDjBKfHtyGGyUsIC7xMdd74EaODhYBFQluvYK
	gZi8QOFz86NBTAkBBYk5k2xAijkFPCS+PNzFBmILAVXMnj+RcQIj7wJGhlWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwbH1THoH46oGi0OMAhyMSjy8CneTg4VYE8uKK3MPMUpwMCuJ8LJo
	pgQL8aYkVlalFuXHF5XmpBYfYkwGOmkis5Rocj4w7vNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Y
	ah0oJJCeWJKanZpakFoEs4WJg1OqgTH/CFOww5XqfcqFSS2p1zbNDzfyyL9Z8P72Dfv1hh9v
	OOse33T1NreW6K/0ZnfZzadeT7+zoPfHdMWz24vWbs7/3mIRznmpTf/BIS4eozUSW21sNh04
	ybSin42rYPbujBVs/ieVX4hYffiS+yimx46r+ndWSovb3zUK9z4vWu4flRDetbZD5p4SS3FG
	oqEWc1FxIgDgEUUu8QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for checking soc compatibility based on
compatibility match. It will help us in removing soc_is_exynos4
and soc_is_exynos5 function usage and definition.

CC: Russell King <linux@arm.linux.org.uk>
CC: Heiko Stuebner <heiko@sntech.de>
CC: Thomas Abraham <thomas.abraham@linaro.org>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c            |   30 +++++++++++++++++++++++++++---
 arch/arm/plat-samsung/include/plat/cpu.h |    3 ---
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 59eb1f1..93ae076 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -212,6 +212,30 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
 	{},
 };
 
+static const struct of_device_id exynos5_device_ids[] = {
+	{ .compatible = "samsung,exynos5250", },
+	{ .compatible = "samsung,exynos5420", },
+	{},
+};
+
+static const struct of_device_id exynos4_device_ids[] = {
+	{ .compatible = "samsung,exynos4210", },
+	{ .compatible = "samsung,exynos4212", },
+	{ .compatible = "samsung,exynos4412", },
+	{},
+};
+
+static inline bool soc_is_compatible(const struct of_device_id *device_ids)
+{
+	unsigned long root = of_get_flat_dt_root();
+	const struct of_device_id *matches = device_ids;
+	for (; matches->compatible[0]; matches++) {
+		if (of_flat_dt_is_compatible(root, matches->compatible))
+			return true;
+	}
+	return false;
+}
+
 /*
  * exynos_map_io
  *
@@ -219,10 +243,10 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
  */
 static void __init exynos_map_io(void)
 {
-	if (soc_is_exynos4())
+	if (soc_is_compatible(exynos4_device_ids))
 		iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
 
-	if (soc_is_exynos5())
+	if (soc_is_compatible(exynos5_device_ids))
 		iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
 }
 
@@ -306,7 +330,7 @@ static void __init exynos_dt_machine_init(void)
 	 * are available then re-configure the interrupts via the
 	 * system register.
 	 */
-	if (soc_is_exynos5()) {
+	if (soc_is_compatible(exynos5_device_ids)) {
 		for_each_compatible_node(i2c_np, NULL, i2c_compat) {
 			if (of_device_is_available(i2c_np)) {
 				id = of_alias_get_id(i2c_np, "i2c");
diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
index 5992b8d..18a9a00 100644
--- a/arch/arm/plat-samsung/include/plat/cpu.h
+++ b/arch/arm/plat-samsung/include/plat/cpu.h
@@ -166,9 +166,6 @@ IS_SAMSUNG_CPU(exynos5440, EXYNOS5440_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos5440()	0
 #endif
 
-#define soc_is_exynos4() (soc_is_exynos4210() || soc_is_exynos4212() || \
-			  soc_is_exynos4412())
-#define soc_is_exynos5() (soc_is_exynos5250() || soc_is_exynos5420())
 
 #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }
 
-- 
1.7.10.4

