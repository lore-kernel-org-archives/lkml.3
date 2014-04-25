Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaDYLgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:36:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16194 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaDYLgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:36:35 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-e1-535a48c25f36
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 3/5] ARM: dts: Add PMU node to exynos4212 and exynos4412
Date: Fri, 25 Apr 2014 20:54:15 +0900
Message-id: <1398426857-5097-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+Zge4hj6hgg5fPBSyWTbrLZjH/yDlW
	i94FV9ksNj2+xmpxedccNosZ5/cxWSza+oXdonXvEXaL9TNes1jsaFnN4sDlsWlVJ5vH5iX1
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx4s1K9oIlXBXfF/9ibGC8xdHFyMkhIWAisfPL
	cSYIW0ziwr31bF2MXBxCAssYJRavecAOU/S2/yIjRGIRo8SBE5ehqtqYJLZu/8wIUsUmoCvx
	5P1cZpCEiEA7o8S/qw/BqpgF5jJKNLdfAJslLOAt8bt/ExuIzSKgKvH/52uwbl4Bd4mmnkes
	XYwcQPsUJOZMsgEJcwp4SJyfsY4dYlsr0NA5n8HukBBYxy5x+OJsZohBAhLfJh9igWiWldh0
	gBnibkmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIyT8J+xgvHfA+hBj
	MtC4icxSosn5wPjJK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbG4N76nWyd+flrywTP9v/v3tqkWr871aK79bZwWMbqV+cU21JLjc8vvzrbfGfr
	FkveL6mbba5WNv0+EKWzcue5yH1awrUSBtftLabeya++4t7558tHfnnn4Fu3fHVC7R5KG6v/
	Fb5Zu61icbPML1eLtee0lyVcSgjSL7LLXzmf+cbH8+7/3RcqsRRnJBpqMRcVJwIAq0q7ApUC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAd1DHlHBBite81gsm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoo3K9kL
	lnBVfF/8i7GB8RZHFyMnh4SAicTb/ouMELaYxIV769m6GLk4hAQWMUocOHEZymljkti6/TNY
	FZuArsST93OZQRIiAu2MEv+uPgSrYhaYyyjR3H6BHaRKWMBb4nf/JjYQm0VAVeL/z9dg3bwC
	7hJNPY9Yuxg5gPYpSMyZZAMS5hTwkDg/Yx07xLZWoKFzPjNOYORdwMiwilE0tSC5oDgpPddQ
	rzgxt7g0L10vOT93EyM4up5J7WBc2WBxiFGAg1GJh/eDWmSwEGtiWXFl7iFGCQ5mJRHedteo
	YCHelMTKqtSi/Pii0pzU4kOMyUBXTWSWEk3OB0Z+Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1qt
	A4UE0hNLUrNTUwtSi2C2MHFwSjUwsk3jTPwnG/VYvebXtHO2vO0yrO/Op0wottmft+1x6DpN
	ttD0jKnTNk3W1tWuv7m4yUGZq3TLfHPz7R1LAhQE1yhO8z02+/v0PEHeutoJh1O6Huxje7Jk
	6fK5f7pSTU92pFacXWntO1FlvmD1n7jrXHfXLavbYXze+AK73c3GXK0lx7wLQ+1ElViKMxIN
	tZiLihMB4IjtF/ICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pmu regnode to exynos4212 and exynos4412 dtsi to
handle PMU register access via DT.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos4212.dtsi |    6 ++++++
 arch/arm/boot/dts/exynos4412.dtsi |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 3c00e6e..b1d4768 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -29,4 +29,10 @@
 	gic: interrupt-controller@10490000 {
 		cpu-offset = <0x8000>;
 	};
+
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4212-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+		samsung,syscon-phandle = <&pmu_system_controller>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index 15d3c0a..6152e70 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -29,4 +29,10 @@
 	gic: interrupt-controller@10490000 {
 		cpu-offset = <0x4000>;
 	};
+
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4412-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+		samsung,syscon-phandle = <&pmu_system_controller>;
+	};
 };
-- 
1.7.10.4

