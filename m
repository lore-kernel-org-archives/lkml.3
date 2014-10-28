Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbaJ1EqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:46:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33597 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbaJ1EqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:46:14 -0400
X-AuditID: cbfee68d-f79296d000004278-5a-544f1f94bbc1
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        m.szyprowski@samsung.com, yj44.cho@samsung.com,
        jaewon02.kim@samsung.com, ideal.song@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 1/2] ARM: EXYNOS: Add EXYNOS4415 SoC
Date: Tue, 28 Oct 2014 13:46:09 +0900
Message-id: <1414471570-5135-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414471570-5135-1-git-send-email-cw00.choi@samsung.com>
References: <1414471570-5135-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkRHeKvH+IwbUNehZ/Jx1jt7j+5Tmr
	xa6/9xktJt2fwGKxo+EIq0XvgqtsFmeb3rBbbHp8jdXi8q45bBYzzu9jslh75C67xdLrF5ks
	Tl3/DBSb/JLNYtWuP4wWe3dOZnQQ8Fgzbw2jx+9fkxg9ds66y+6xeUm9x5UTTawefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlfH29hzGgnu8FRNbTrA2MJ7h7mLk5JAQMJE48OUIG4QtJnHh
	3nogm4tDSGApo8Sv5c0sMEW7v05jh0hMZ5SY8GU5M4TTxCSxY+11sHY2AS2J/S9ugNkiApIS
	TQ1/mEFsZoFGZomGdmEQW1jATKJj/QOwqSwCqhIb7zcwgdi8Ai4SX+5eY4fYpiCxbPlMVhCb
	U8BVYvOZiWBzhIBq3izfAbZYQuAlu8TUw5/YIAYJSHybfAhoKAdQQlZi0wFmiDmSEgdX3GCZ
	wCi8gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgVJ3+96x3B+PtA9aHGAU4GJV4eA0e
	+oUIsSaWFVfmHmI0BdowkVlKNDkfGLt5JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwzu9f02fe57fvsa7VoSj+YyI37k3ID3HsmTd9U4pJ6R3msyIM
	vmd4TjwxrDjbuE7ru7ecwd+YhbPnZ6z1XH7jXMp3QbfDYf21zowq3tOfCpYpJR6onKy7usWS
	/19n1uVfi/Yc3yfg0H1RrWnjmXxj50/hiyf6fSxL2bStr7zindWcpqJYrShhJZbijERDLeai
	4kQAhSHCWaUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jQd0p8v4hBitPqlr8nXSM3eL6l+es
	Frv+3me0mHR/AovFjoYjrBa9C66yWZxtesNusenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2Sy
	OHX9M1Bs8ks2i1W7/jBa7N05mdFBwGPNvDWMHr9/TWL02DnrLrvH5iX1HldONLF69G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtD1SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMt7fnMBbc462Y2HKC
	tYHxDHcXIyeHhICJxO6v09ghbDGJC/fWs3UxcnEICUxnlJjwZTkzhNPEJLFj7XU2kCo2AS2J
	/S9ugNkiApISTQ1/mEFsZoFGZomGdmEQW1jATKJj/QMWEJtFQFVi4/0GJhCbV8BF4svda1Db
	FCSWLZ/JCmJzCrhKbD4zEWyOEFDNm+U7mCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERyzz6R3MK5qsDjEKMDBqMTDa/jQL0SINbGsuDL3EKMEB7OSCK/XDqAQb0piZVVqUX58
	UWlOavEhRlOgqyYyS4km5wPTSV5JvKGxiZmRpZG5oYWRsbmSOO/BVutAIYH0xJLU7NTUgtQi
	mD4mDk6pBkbbw/e31WZzHtD8xBJaz/RQbv1SWQH+5+yL5u16Jvb1jnv7sQ7Hae6t16/xfuiZ
	/ed/3olp06ONm0XVlc2eynh9b+etdMrZUKW248jkjy6P5LP1OxVEFm+4tOeFkXHrE94egZat
	OQtNbkfXP5pcopKy6m3hg/q7NzfE/Xt44oCH+I3ffkdCtpsqsRRnJBpqMRcVJwIA5oYFVO8C	AAA=
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

