Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaKNKD5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:03:57 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43287 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaKNKDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:03:54 -0500
X-AuditID: cbfee61a-f79c06d000004e71-b9-5465d3884de6
From: Lukasz Majewski <l.majewski@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [RESEND PATCH 1/2] ARM: dts: exynos4x12: Device tree node definition
 for TMU on Exynos4x12
Date: Fri, 14 Nov 2014 11:03:24 +0100
Message-id: <1415959405-14157-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1381300194-13134-5-git-send-email-l.majewski@samsung.com>
References: <1381300194-13134-5-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd2Oy6khBt3bOSw2zljPajFp3QEm
	i/lHzrFa9L9ZyGpx7tVKRoveBVfZLN483MxosenxNVaLy7vmsFnMOL+PyeL2ZV6LpdcvMllM
	mL6WxaJ17xF2i1W7/jA68HusmbeG0aOluYfN43JfL5PH31UvmD12zrrL7rFy+Rc2j02rOtk8
	Ni+p9+jbsorR4/MmuQCuKC6blNSczLLUIn27BK6MTbOvMxdMY69YcuYWcwNjE1sXIyeHhICJ
	xN79/5kgbDGJC/fWA8W5OIQEpjNK3Nu7CcrpYpJon/cOrINNQE/i892nYB0iAmoSPYu3MoLY
	zAIzWSQO/ikAsYUFUiXamtawgNgsAqoSc490sYLYvAJuEjt7+pghtilKdD+bADSTg4NTwF1i
	0jYDkLAQUMnRP10sExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDulnUjsYVzZY
	HGIU4GBU4uFlcEsNEWJNLCuuzD3EKMHBrCTCG3oeKMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	QKt1oJBAemJJanZqakFqEUyWiYNTqoFR6fg8yZi7GcePnrrLUZr6a4v4kZ9n27IXv7zuI7CY
	/43oJ5mI64Jssn/mnPjxJvLQTL/b0us3mlUIi+kUhizk9nroe0u1ZfGrbNkz7oLqxubFytuW
	cR3gZV5r19z4y6ny/1bzXxk7GI4/+SqiI9J6Yk7LuqPfPadoZW64a20e5Mt6z0li20VGJZbi
	jERDLeai4kQAo7F4EWUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TMU device tree node definition for Exynos4x12 family of SoCs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 861bb91..2e9f1f7 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -271,4 +271,14 @@
 		compatible = "samsung,exynos4x12-usb2-phy";
 		samsung,sysreg-phandle = <&sys_reg>;
 	};
+
+	tmu@100C0000 {
+		compatible = "samsung,exynos4412-tmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		reg = <0x100C0000 0x100>;
+		clocks = <&clock 383>;
+		clock-names = "tmu_apbif";
+		status = "disabled";
+	};
 };
-- 
2.0.0.rc2

