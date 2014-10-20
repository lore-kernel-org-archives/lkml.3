Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaJTDdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 23:33:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10053 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaJTDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 23:32:39 -0400
X-AuditID: cbfee691-f79b86d000004a5a-18-5444824fa791
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org, linux@arm.linux.org.uk,
        mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, mturquette@linaro.org,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, jh80.chung@samsung.com,
        cw00.choi@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com
Subject: [PATCH 1/5] ARM: EXYNOS: Add EXYNOS4415 SoC ID
Date: Mon, 20 Oct 2014 12:32:11 +0900
Message-id: <1413775935-17743-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsWyRsSkRNe/ySXE4OJePYu/k46xW0xad4DJ
	4vqX56wWfya0slns+nuf0WLS/QksFjsajrBa3PjVxmrRu+Aqm8XZpjfsFlP+LGey2PT4GqvF
	5V1z2CxmnN/HZHH7Mq/F0usXmSyeTrjIZnHq+meg+OSXbBbHZixhtFi16w+jxd6dkxkdxDzW
	zFvD6NHS3MPm8fvXJEaPv6teMHvsnHWX3ePOtT1sHpuX1HtcOdHE6tG3ZRWjx+dNcgFcUVw2
	Kak5mWWpRfp2CVwZS34tYCu4K1GxbpFsA+MG0S5GTg4JAROJji/PmSBsMYkL99azdTFycQgJ
	LGWUeHT9OCNM0YdpU5ggEtMZJc5NOwhV1cQkse3/fLB2NgEtif0vbrCB2CIC2RJXGu8zgxQx
	Cxxklvj4qYcdJCEsYC5xavY1VhCbRUBVYuPFrWBxXgFXifcfP0DdISfxYc8jsDingJvE4a7/
	QHEOoG2uEjM2q4LMlBBYyiHRtfobI8QcAYlvkw+xgNRICMhKbDrADDFGUuLgihssExiFFzAy
	rGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIjNXT/55N3MF4/4D1IUYBDkYlHt4dZi4hQqyJ
	ZcWVuYcYTYE2TGSWEk3OByaEvJJ4Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGI2q45TrHLg2d+nt2P55nkrYgnSjY9Hhb21efHrTvvDDD9/IXaYpKUdO
	dew4rPZQdoNBy+89YtuK9z69LpbGzeO7JGzuD8/Wk2220Ud/uS8oTWI5IpnPsGfJNJN35UZH
	zli072/udksIVC0uOPV22zrz+8GaTW+X7wmZmj3RXz/5VXzC5PlOsUosxRmJhlrMRcWJAM3I
	WlvQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoK5/k0uIwcvHihZ/Jx1jt5i07gCT
	xfUvz1kt/kxoZbPY9fc+o8Wk+xNYLHY0HGG1uPGrjdWid8FVNouzTW/YLab8Wc5ksenxNVaL
	y7vmsFnMOL+PyeL2ZV6LpdcvMlk8nXCRzeLU9c9A8ckv2SyOzVjCaLFq1x9Gi707JzM6iHms
	mbeG0aOluYfN4/evSYwef1e9YPbYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5AK4ohoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZiz5tYCt4K5ExbpFsg2MG0S7GDk5
	JARMJD5Mm8IEYYtJXLi3nq2LkYtDSGA6o8S5aQehnCYmiW3/54NVsQloSex/cYMNxBYRyJa4
	0nifGaSIWeAgs8THTz3sIAlhAXOJU7OvsYLYLAKqEhsvbgWL8wq4Srz/+AFqnZzEhz2PwOKc
	Am4Sh7v+A8U5gLa5SszYrDqBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBE8Exq
	B+PKBotDjAIcjEo8vDvMXEKEWBPLiitzDzFKcDArifD+ywAK8aYkVlalFuXHF5XmpBYfYjQF
	Omois5Rocj4wSeWVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamBc
	c6f7z8IKUZEbp+9+cLnUpBo1N+EdzyOtRyJxm3Yu2bDmh7FxiKaGG0fnLjEuLu1plSpT1rUb
	71v0Zplg/IQ5RyMkCs7azdzJlvZp09zVE/hj7gZVuO9oWrqbMzCGO3jNt06lORWXF2U1iMbb
	/3wleaB8qenBdUad+5ZINX5j+LZ54p7qtk/JSizFGYmGWsxFxYkAajcoXxoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Exynos4415's SoC ID. Exynos4415 is based on the 32-bit RISC
processor for Smartphone. Exynos4415 uses Cortex A9 quad-cores and has a target
speed of 1.6GHz and provides 8.5GB/s memory bandwidth.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/Kconfig  | 5 +++++
 arch/arm/mach-exynos/common.h | 8 ++++++++
 arch/arm/mach-exynos/exynos.c | 2 ++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 46f3c0d..349c867 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -75,6 +75,11 @@ config SOC_EXYNOS4412
 	default y
 	depends on ARCH_EXYNOS4
 
+config SOC_EXYNOS4415
+	bool "SAMSUNG EXYNOS4415"
+	default y
+	depends on ARCH_EXYNOS4
+
 config SOC_EXYNOS5250
 	bool "SAMSUNG EXYNOS5250"
 	default y
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index d4d09bc..ffc0c22 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -21,6 +21,7 @@
 #define EXYNOS4210_CPU_ID	0x43210000
 #define EXYNOS4212_CPU_ID	0x43220000
 #define EXYNOS4412_CPU_ID	0xE4412200
+#define EXYNOS4415_CPU_ID	0xE4415000
 #define EXYNOS4_CPU_MASK	0xFFFE0000
 
 #define EXYNOS5250_SOC_ID	0x43520000
@@ -42,6 +43,7 @@ IS_SAMSUNG_CPU(exynos3250, EXYNOS3250_SOC_ID, EXYNOS3_SOC_MASK)
 IS_SAMSUNG_CPU(exynos4210, EXYNOS4210_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4212, EXYNOS4212_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos4412, EXYNOS4412_CPU_ID, EXYNOS4_CPU_MASK)
+IS_SAMSUNG_CPU(exynos4415, EXYNOS4415_CPU_ID, EXYNOS4_CPU_MASK)
 IS_SAMSUNG_CPU(exynos5250, EXYNOS5250_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5410, EXYNOS5410_SOC_ID, EXYNOS5_SOC_MASK)
 IS_SAMSUNG_CPU(exynos5420, EXYNOS5420_SOC_ID, EXYNOS5_SOC_MASK)
@@ -72,6 +74,12 @@ IS_SAMSUNG_CPU(exynos5800, EXYNOS5800_SOC_ID, EXYNOS5_SOC_MASK)
 # define soc_is_exynos4412()	0
 #endif
 
+#if defined(CONFIG_SOC_EXYNOS4415)
+# define soc_is_exynos4415()	is_samsung_exynos4415()
+#else
+# define soc_is_exynos4415()	0
+#endif
+
 #define EXYNOS4210_REV_0	(0x0)
 #define EXYNOS4210_REV_1_0	(0x10)
 #define EXYNOS4210_REV_1_1	(0x11)
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 2f2f7b2..52bca8e 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -253,6 +253,7 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
 	{ .compatible = "samsung,exynos4210-pmu" },
 	{ .compatible = "samsung,exynos4212-pmu" },
 	{ .compatible = "samsung,exynos4412-pmu" },
+	{ .compatible = "samsung,exynos4415-pmu" },
 	{ .compatible = "samsung,exynos5250-pmu" },
 	{ .compatible = "samsung,exynos5260-pmu" },
 	{ .compatible = "samsung,exynos5410-pmu" },
@@ -337,6 +338,7 @@ static char const *exynos_dt_compat[] __initconst = {
 	"samsung,exynos4210",
 	"samsung,exynos4212",
 	"samsung,exynos4412",
+	"samsung,exynos4415",
 	"samsung,exynos5",
 	"samsung,exynos5250",
 	"samsung,exynos5260",
-- 
1.8.0

