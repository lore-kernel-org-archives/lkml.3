Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaJ0BgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:36:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22380 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaJ0BgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:36:02 -0400
X-AuditID: cbfee68e-f79b46d000002b74-38-544da1803123
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        tomasz.figa@gmail.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com
Subject: [PATCHv2 1/2] ARM: EXYNOS: Add EXYNOS4415 SoC ID
Date: Mon, 27 Oct 2014 10:35:58 +0900
Message-id: <1414373759-4362-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
References: <1414373759-4362-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkRLdhoW+IQeNvKYu/k46xW1z/8pzV
	Ytff+4wWk+5PYLHY0XCE1aJ3wVU2i7NNb9gtNj2+xmpxedccNosZ5/cxWaw9cpfdYun1i0wW
	p65/BopNfslmsWrXH0aLvTsnMzoIeKyZt4bR4/evSYweO2fdZffYvKTe48qJJlaPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgynj18ix7wUPeir2XGhkbGM9xdzFyckgImEjcm/eQGcIWk7hw
	bz1bFyMXh5DAUkaJKWt/snQxcoAVTW5XhIgvYpQ4/WYJWIOQQBOTRNOzehCbTUBLYv+LG2wg
	tohAtsSVxvvMIA3MAmuZJCZ8ecIKkhAWsJT4f34JC4jNIqAqsXrSTDCbV8BFYnFnFxvEFQoS
	y5bPBKvnFHCVWHX1FxPEMheJ21cbWCFq3rJL3LzCBzFHQOLb5ENQh8pKbDoA9YykxMEVN1gm
	MAovYGRYxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iREYUaf/PevbwXjzgPUhRgEORiUeXotC
	3xAh1sSy4srcQ4ymQBsmMkuJJucD4zavJN7Q2MzIwtTE1NjI3NJMSZw3QepnsJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQbG5SdusZ99eFJjPts5aYbPEnpvC9sq+D9tMt7y3Ej9e6/bhac8
	a01ke1s23P643c3sYoNe8M+gsiqjd/9apnJcZnt99wuTx2+W2vch3xNLNqt4nlEyK9mgEF5x
	sdY5SWXn1LL5yR6KMzxeKSW8jvwctdCjoyuvc4Zs+ddLD1rWMsU/DOna++KGEktxRqKhFnNR
	cSIAVs0mXKMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd2Ghb4hBu+mCln8nXSM3eL6l+es
	Frv+3me0mHR/AovFjoYjrBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	OHX9M1Bs8ks2i1W7/jBa7N05mdFBwGPNvDWMHr9/TWL02DnrLrvH5iX1HldONLF69G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtD1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMVy/Pshc85K3Ye6mR
	sYHxHHcXIweHhICJxOR2xS5GTiBTTOLCvfVsXYxcHEICixglTr9ZwgySEBJoYpJoelYPYrMJ
	aEnsf3GDDcQWEciWuNJ4nxmkgVlgLZPEhC9PWEESwgKWEv/PL2EBsVkEVCVWT5oJZvMKuEgs
	7uxig9imILFs+Uywek4BV4lVV38xQSxzkbh9tYF1AiPvAkaGVYyiqQXJBcVJ6blGesWJucWl
	eel6yfm5mxjBEftMegfjqgaLQ4wCHIxKPLwWhb4hQqyJZcWVuYcYJTiYlUR4RfOBQrwpiZVV
	qUX58UWlOanFhxhNga6ayCwlmpwPTCZ5JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNT
	UwtSi2D6mDg4pRoY05U+68wyPd81M9F1Zldv2J/JLlPSE+I3xS8IKGj57b5+k+KSnTXu9j4p
	J1c9r+x4dzA8q4rzV4ruA7V9yoc+7n6rOkfj5Zvnf/212bZu/l81Jdx6yaLnLho5q67M2VAn
	3JLUMGHi5D3v82dHC73WO6vc6rCn90N4UMxGudJvlwW/GCnOdXMVU2Ipzkg01GIuKk4EAGAj
	DELuAgAA
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

