Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaCKH4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 03:56:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45819 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaCKHzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 03:55:06 -0400
X-AuditID: cbfee690-b7f266d00000287c-53-531ec15876a2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 4/5] ARM: dts: exynos: Move common dt data for interrupt
 combiner controller
Date: Tue, 11 Mar 2014 16:54:53 +0900
Message-id: <1394524494-30641-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkRDfioFywwfk7VhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjigu
	m5TUnMyy1CJ9uwSujFl/3rMVrJao+LM4voGxWbiLkYNDQsBEoqPbt4uRE8gUk7hwbz1bFyMX
	h5DAUkaJRwu2sUEkTCQWnfjDApFYxChxakEXlNPIJNG25icLSBWbgJbE/hc3wDpEBHQlpsy8
	wwpSxCxwn0nix/FVYAlhgTiJv3e2soPYLAKqEgsfHQKL8wq4Ssy8PJkFYp2cxIc9j8BqOAXc
	JJ7eXs4KYgsB1Xx5cpMJZKiEwD12if2/QByQQQIS3yYfYoH4R1Zi0wFmiDmSEgdX3GCZwCi8
	gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgFJ3+92zCDsZ7B6wPMSYDjZvILCWanA+M
	wrySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYHQ4
	uPTqy8R3R7x+2n+//ViN3V7y5bndzze4CDJzCTPYHo9XlIsLupG5WZBxFmOlrtyZk2e+atRy
	1f4u49zxPfQ4+0exR/P3vqjlUn2x68LUBXyP2m6FL2d6UHyXvewzi3nx6Yiv3nUnNXwL3dN2
	9pxW/xSjwW6kfH2S36oUcYe0uUU9ivknjiixFGckGmoxFxUnAgCpQ5+5uAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG7EQblggxc9RhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmz/rxnK1gtUfFncXwDY7NwFyMn
	h4SAicSiE39YIGwxiQv31rN1MXJxCAksYpQ4taCLBcJpZJJoW/MTrIpNQEti/4sbbCC2iICu
	xJSZd1hBipgF7jNJ/Di+CiwhLBAn8ffOVnYQm0VAVWLho0NgcV4BV4mZlydDrZOT+LDnEVgN
	p4CbxNPby1lBbCGgmi9PbjJNYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Sp9J
	7WBc2WBxiFGAg1GJhzfAVy5YiDWxrLgy9xCjBAezkgiv01qgEG9KYmVValF+fFFpTmrxIcZk
	oKsmMkuJJucDE0heSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBK
	NTDKRj7LPPRzB/9lsRdsDvd6P64sdu43TVZ6s3hTTticbWvXvoxaWunjN+9WQ5pv+ZbIavne
	PtcFgRunKLv+OFDIymc6Q+XKlo+L9G+f4Pze9zP6w76NjI01B2z8Nz45vHaH7HJJs10CgcKT
	jq5atXT6rsDHX5h1Ev521Wk4Xfwav8W6vGntP6/lSizFGYmGWsxFxYkAZu4HfBYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch move common dt data of interrupt combiner controller to
exynos4x12.dtsi. Each Exynos4x12 SoC has different number of interrput combiner
as following:
- Exynos4212 : interrput combiner 18(0 ~ 17)
- Exynos4412 : interrput combiner 20(0 ~ 19)

The exynos combiner driver initialize interrupt according to specific number
of interrput combiner.
- samsung,combiner-nr : The number of interrput combiners supported.

Also,
This patch arrange again the dt data according to register address
in exynos4212/exynos4412.dtsi.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4212.dtsi | 13 ++++---------
 arch/arm/boot/dts/exynos4412.dtsi | 14 ++++----------
 arch/arm/boot/dts/exynos4x12.dtsi |  8 ++++++++
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 94a43f9..ceefc71 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -22,16 +22,11 @@
 / {
 	compatible = "samsung,exynos4212";
 
-	gic: interrupt-controller@10490000 {
-		cpu-offset = <0x8000>;
+	combiner: interrupt-controller@10440000 {
+		samsung,combiner-nr = <18>;
 	};
 
-	interrupt-controller@10440000 {
-		samsung,combiner-nr = <18>;
-		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
-			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
-			     <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
-			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
-			     <0 107 0>, <0 108 0>;
+	gic: interrupt-controller@10490000 {
+		cpu-offset = <0x8000>;
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index 87b339c..a40b6e2 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -22,17 +22,11 @@
 / {
 	compatible = "samsung,exynos4412";
 
-	gic: interrupt-controller@10490000 {
-		cpu-offset = <0x4000>;
-	};
-
-	interrupt-controller@10440000 {
+	combiner: interrupt-controller@10440000 {
 		samsung,combiner-nr = <20>;
-		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
-			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
-			     <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
-			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
-			     <0 107 0>, <0 108 0>, <0 48 0>, <0 42 0>;
 	};
 
+	gic: interrupt-controller@10490000 {
+		cpu-offset = <0x4000>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 066eb35..6e17034 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -73,6 +73,14 @@
 		};
 	};
 
+	combiner: interrupt-controller@10440000 {
+		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
+			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
+			     <0 8 0>, <0 9 0>, <0 10 0>, <0 11 0>,
+			     <0 12 0>, <0 13 0>, <0 14 0>, <0 15 0>,
+			     <0 107 0>, <0 108 0>, <0 48 0>, <0 42 0>;
+	};
+
 	pinctrl_0: pinctrl@11400000 {
 		compatible = "samsung,exynos4x12-pinctrl";
 		reg = <0x11400000 0x1000>;
-- 
1.8.0

