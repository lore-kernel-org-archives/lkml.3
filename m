Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaJ1LBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:01:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64325 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ1LBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:01:50 -0400
X-AuditID: cbfee68e-f79b46d000002b74-cf-544f779c42c4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 1/2] ARM: EXYNOS: Add EXYNOS4415 SoC
Date: Tue, 28 Oct 2014 20:01:45 +0900
Message-id: <1414494106-16584-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414494106-16584-1-git-send-email-cw00.choi@samsung.com>
References: <1414494106-16584-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkRHdOuX+Iwc11qhZ/Jx1jt7j+5Tmr
	xa6/9xktJt2fwGKxo+EIq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ks
	Tl3/DBSb/JLNYtWuP4wWe3dOZnQQ8Fgzbw2jx+9fkxg9ds66y+6xeUm9x5UTTawefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlfH29hzGgnu8FRNbTrA2MJ7h7mLk5JAQMJFY0nSNBcIWk7hw
	bz1bFyMXh5DAUkaJyxvmssIUHXi0nx0iMZ1R4vDdP+wgCSGBJiaJOzutQGw2AS2J/S9usIHY
	IgKSEk0Nf5hBbGaBRmaJhnZhEFtYwEyit7GBEcRmEVCVOHf2N1ANBwevgKtE10x2iF0KEsuW
	zwTbyyngJrHr0hOoVa4SK9ZcYga5QULgJbvElPVvmSDmCEh8m3yIBWSOhICsxKYDzBBzJCUO
	rrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwIg6/e9Z3w7GmwesDzEKcDAq
	8fAaPPQLEWJNLCuuzD3EaAq0YSKzlGhyPjBu80riDY3NjCxMTUyNjcwtzZTEeROkfgYLCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYFzE/Vn35b0ztS9V5O8pLedYzvtdwTz/6pyACHf+o5c9
	nywJm5IcManq/5KZ1rxXLhZtyBd50HxlUrvaPnfrSckH6z7O9lt98frtaY5223Y2Mh84psZ/
	gnfhpHJXaxvml42z4kqni93qm844b82TR++lLydPP93ku2p1eiu3866Ut+EZn5WY9k1UYinO
	SDTUYi4qTgQAfOJCBKMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd055f4hBucXy1j8nXSM3eL6l+es
	Frv+3me0mHR/AovFjoYjrBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	OHX9M1Bs8ks2i1W7/jBa7N05mdFBwGPNvDWMHr9/TWL02DnrLrvH5iX1HldONLF69G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtD1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMt7fnMBbc462Y2HKC
	tYHxDHcXIyeHhICJxIFH+9khbDGJC/fWs3UxcnEICUxnlDh89w9YQkigiUnizk4rEJtNQEti
	/4sbbCC2iICkRFPDH2YQm1mgkVmioV0YxBYWMJPobWxgBLFZBFQlzp39DVTDwcEr4CrRNRNq
	l4LEsuUzWUFsTgE3iV2XnkCtcpVYseYS8wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxguP1mdQOxpUNFocYBTgYlXh4DR76hQixJpYVV+YeYpTgYFYS4Y2I8Q8R4k1JrKxKLcqP
	LyrNSS0+xGgKdNREZinR5HxgKskriTc0NjEzsjQyN7QwMjZXEuc90GodKCSQnliSmp2aWpBa
	BNPHxMEp1cC4/+k558R1j73NFtQ3bpl56dqt64tflx3+/1jvybq3XTGvm5s+5zy6W7TZNjbq
	16QvTU2b/JUr97ZnxYqXGpbH5mQGS9nvFsj4nfJv9a5EK+5/D7VWf26udYtZyzHT/5Vx0hO2
	d6qcK50veGtkZ3LJcvczFR0vslO2T8hV6+MOri9Tz+0X3qTEUpyRaKjFXFScCACbX8pY7QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Exynos4415's SoC. Exynos4415 is based on the 32-bit RISC
processor for Smartphone. Exynos4415 uses Cortex A9 quad-cores and has a target
speed of 1.6GHz and provides 8.5GB/s memory bandwidth.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/Kconfig  | 5 +++++
 arch/arm/mach-exynos/exynos.c | 2 ++
 2 files changed, 7 insertions(+)

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
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 1b46460..1da531f 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -252,6 +252,7 @@ static const struct of_device_id exynos_dt_pmu_match[] = {
 	{ .compatible = "samsung,exynos4210-pmu" },
 	{ .compatible = "samsung,exynos4212-pmu" },
 	{ .compatible = "samsung,exynos4412-pmu" },
+	{ .compatible = "samsung,exynos4415-pmu" },
 	{ .compatible = "samsung,exynos5250-pmu" },
 	{ .compatible = "samsung,exynos5260-pmu" },
 	{ .compatible = "samsung,exynos5410-pmu" },
@@ -359,6 +360,7 @@ static char const *exynos_dt_compat[] __initconst = {
 	"samsung,exynos4210",
 	"samsung,exynos4212",
 	"samsung,exynos4412",
+	"samsung,exynos4415",
 	"samsung,exynos5",
 	"samsung,exynos5250",
 	"samsung,exynos5260",
-- 
1.8.5.5

