Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbbAVLSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:18:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52737 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbbAVLSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:18:32 -0500
X-AuditID: cbfee691-f79b86d000004a5a-4e-54c0dc7ddd5b
From: Inha Song <ideal.song@samsung.com>
To: alsa-devel@alsa-project.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        s.nawrocki@samsung.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        ideal.song@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [alsa-devel] [PATCH v3 3/4] ARM: dts: set clock out parent to XUSBXTI
Date: Thu, 22 Jan 2015 20:18:01 +0900
Message-id: <1421925482-15861-4-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkSLf2zoEQg2NT+C2uXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDLuv/nGUrCeteJY1y7mBsaDLF2MnBwSAiYSvbvPsEHYYhIX7q0H
	srk4hASWMkrMWTqHEabo35wbLBCJRYwS73tmMUM4c5gkNs18ygxSxSagIfH982Ygm4NDREBe
	4tD7PJAaZoErzBIfV8wCiwsL+ElsmZwGUs4ioCqxeMdSVpAwr4CbxOMtuRC7tCX2NcwEO4hT
	wF3i5t2tYLYQUMnavkmMICMlBNZySOw4PIsRYo6AxLfJh1hA5kgIyEpsOsAMMUdS4uCKGywT
	GIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiM2NP/nk3cwXj/gPUhRgEORiUe3ozi
	AyFCrIllxZW5hxhNgTZMZJYSTc4HpoW8knhDYzMjC1MTU2Mjc0szJXFeHemfwUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoYvctnLBBK3dEpq5KYe+ibR9Fcfr8Nl/g2LL1oPdHguumpCfry
	1ddrkndt0hJ8KGn1y517ccTZ+HkbNTecXLd0mlJ9wN19Aqnr78v+KDi0iklrLa9uy11fzbcp
	dQ2HEx9bPTmWPmHmxfal5ZtusbVyT55VtOM5b+bM85WTmZX3T4rf+1i7plp8thJLcUaioRZz
	UXEiAG3zLu7TAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG7tnQMhBgcPs1lcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuP/mG0vBetaKY127mBsY
	D7J0MXJySAiYSPybcwPKFpO4cG89WxcjF4eQwCJGifc9s5ghnDlMEptmPmUGqWIT0JD4/nkz
	kM3BISIgL3HofR5IDbPAFWaJjytmgcWFBfwktkxOAylnEVCVWLxjKStImFfATeLxllyIXdoS
	+xpmsoHYnALuEjfvbgWzhYBK1vZNYpzAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4m
	RnA6eCa9g3FVg8UhRgEORiUe3oziAyFCrIllxZW5hxglOJiVRHhNTwCFeFMSK6tSi/Lji0pz
	UosPMZoCHTWRWUo0OR+YqvJK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqY
	ODilGhgX/egN2cZiatu0Yoag1MRkkTut7HfX3HENSQzInaIw9ZRF6dN7/dwu35YvD/7Tmbdp
	3bw1YWc3nfpv6aoufWzvlPjFC6/PmVmwfUtM3/wF4myzjROZd3SJTDzloChx0XrP80enb7m4
	/19245l1wPKynTb9sxImdUzWWv/104X+S6oXA2/v8eq7psRSnJFoqMVcVJwIABQdY7gdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set clock out parent to XUSBXTI.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index b8168f1..020bbaf 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -141,6 +141,8 @@
 	pmu_system_controller: system-controller@10020000 {
 		compatible = "samsung,exynos4210-pmu", "syscon";
 		reg = <0x10020000 0x4000>;
+		assigned-clocks = <&pmu_system_controller 0>;
+		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
 	};
 
 	dsi_0: dsi@11C80000 {
-- 
2.0.0.390.gcb682f8

