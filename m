Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbbAHBlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:41:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38622 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbbAHBlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:05 -0500
X-AuditID: cbfee691-f79b86d000004a5a-e4-54ade02b1331
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 5/8] ARM: dts: Add memory bus node for Exynos4x12
Date: Thu, 08 Jan 2015 10:40:54 +0900
Message-id: <1420681257-3078-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkRFf7wdoQg0XrpCwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlbF15UzGghfSFReXdrI1MC4R6WLk5JAQMJFYvOEVO4QtJnHh
	3nq2LkYuDiGBpYwSX5ZeYoIpWrDlCitEYhGjxLQXh1kgnCYmiVcr5jOCVLEJaEnsf3GDDcQW
	EdCT6Dy2B2wss8AfJommTSwgtrCAs8TyYy1g9SwCqhIz/95jBrF5BVwkDjbcYITYpiCxbPlM
	VhCbU8BVov/pNTBbCKjm8uNVjCCLJQResks8WHOeDWKQgMS3yYeAFnAAJWQlNh1ghpgjKXFw
	xQ2WCYzCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIExtTpf88m7mC8f8D6EKMAB6MS
	D29B35oQIdbEsuLK3EOMpkAbJjJLiSbnAyM3ryTe0NjMyMLUxNTYyNzSTEmcV0f6Z7CQQHpi
	SWp2ampBalF8UWlOavEhRiYOTqkGRq8PnYd891o1qKae2B7//aMhU3JCI7MB57M2T5Gsg+V/
	I9fMTLnKGTLp/anrjzYsWzDjwor2+gfSxxUX5cgerxDber1h9yf5BXp9bBN/cx56HcXZ96fi
	yyTdU0uW9d7g38+gvbQsT3T5xQjl1W4nXllFXOE9n8t+d1rm5DkSEc0bpLY+aTgSI6nEUpyR
	aKjFXFScCADnG/CDpAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV3tB2tDDDqeClg8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG1pUzGQteSFdcXNrJ
	1sC4RKSLkZNDQsBEYsGWK6wQtpjEhXvr2boYuTiEBBYxSkx7cZgFwmlikni1Yj4jSBWbgJbE
	/hc32EBsEQE9ic5je9hBbGaBP0wSTZtYQGxhAWeJ5cdawOpZBFQlZv69xwxi8wq4SBxsuMEI
	sU1BYtnymWCbOQVcJfqfXgOzhYBqLj9exTiBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOCIfSa9g3FVg8UhRgEORiUe3oK+NSFCrIllxZW5hxglOJiVRHi7zq4NEeJNSaysSi3K
	jy8qzUktPsRoCnTVRGYp0eR8YDLJK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1I
	LYLpY+LglGpg7FJtupmeVqil3KYWGiM3vYmrf5vulr18d4S3Lrmp/+Zzjulmdr43nFmV19bG
	y+rKlrjtaT0oIZ5RcJJ3RbquWOnrs6avFra6fXDlYFzYy3Bd1fDz9Ts+PqUHFl//2Oek2n74
	d5f4lg3Tnqt+P6GWzr72spLkb/7gkrNOq1eaGK3YZ5fd+b1EiaU4I9FQi7moOBEAhIRy7e4C	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the memory bus node for Exynos4x12 SoC. Exynos4x12 SoC has
two memory bus to translate data between DRAM and eMMC/sub-IPs.

Following list specifies the detailed relation between memory bus clock and DMC
IP in MIF (Memory Interface) block:
- DMC/ACP clock : DMC (Dynamic Memory Controller)

Following list specifies the detailed relation between memory bus clock and
sub-IPs in INT (Internal) block:
- ACLK100 clock : PERIL/PERIR/MFC(PCLK)
- ACLK160 clock : CAM/TV/LCD
- ACLK133 clock : FSYS
- GDL/GDR clock : leftbus/rightbus
- SCLK_MFC clock : MFC

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi | 121 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 93b7040..44f6272 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -31,6 +31,127 @@
 		mshc0 = &mshc_0;
 	};
 
+	memory_bus_mif: memory_bus@0 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			400000 1100000
+			200000 1000000
+			160000 950000
+			133000 950000
+			100000 950000>;
+		status = "disabled";
+
+		blocks {
+			dmc_block: memory_bus_block1 {
+				clocks = <&clock CLK_DIV_DMC>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					200000
+					160000
+					133000
+					100000>;
+			};
+
+			acp_block: memory_bus_block2 {
+				clocks = <&clock CLK_DIV_ACP>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					133000
+					133000
+					100000>;
+			};
+
+			c2c_block: memory_bus_block3 {
+				clocks = <&clock CLK_DIV_C2C>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					200000
+					160000
+					133000
+					100000>;
+			};
+		};
+	};
+
+	memory_bus_int: memory_bus@1 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			200000 1000000
+			160000 950000
+			133000 925000
+			100000 900000>;
+
+		status = "disabled";
+
+		blocks {
+			peri_block: memory_bus_block1 {
+				clocks = <&clock CLK_ACLK100>;
+				clock-names = "memory-bus";
+				frequency = <
+					100000
+					100000
+					100000
+					100000>;
+			};
+
+			fsys_block: memory_bus_block2 {
+				clocks = <&clock CLK_ACLK133>;
+				clock-names = "memory-bus";
+				frequency = <
+					133000
+					133000
+					100000
+					100000>;
+			};
+
+			display_block: memory_bus_block3 {
+				clocks = <&clock CLK_ACLK160>;
+				clock-names = "memory-bus";
+				frequency = <
+					160000
+					160000
+					133000
+					100000>;
+			};
+
+			leftbus_block: memory_bus_block4 {
+				clocks = <&clock CLK_DIV_GDL>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					133000
+					100000>;
+			};
+
+			rightbus_block: memory_bus_block5 {
+				clocks = <&clock CLK_DIV_GDR>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					133000
+					100000>;
+			};
+
+			mfc_block: memory_bus_block6 {
+				clocks = <&clock CLK_SCLK_MFC>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					133000
+					100000>;
+			};
+		};
+	};
+
 	sysram@02020000 {
 		compatible = "mmio-sram";
 		reg = <0x02020000 0x40000>;
-- 
1.8.5.5

