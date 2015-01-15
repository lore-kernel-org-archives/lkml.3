Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbbAOBwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:52:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9446 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbbAOBvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:11 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-e5-54b71d08d92a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 6/9] ARM: dts: Add memory bus node for Exynos4210
Date: Thu, 15 Jan 2015 10:50:54 +0900
Message-id: <1421286657-4720-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSoMspuz3E4O59RovHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQov/xa2aLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtu0br3CLvFql1/GB0EPNbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H35ZVjB6f
	N8kFsEdx2aSk5mSWpRbp2yVwZSz61ctYsF6iont2UAPjJKEuRk4OCQETiQuvl7JC2GISF+6t
	ZwOxhQSWMkrcm5AEU9P2vYMRIj6dUaLzbgqE3cQk8bQpG8RmE9CS2P/iBliviICeROexPewg
	NrPAHyaJpk0sILawgItE+8LNYHNYBFQlLs5sBKvhBYqve7SYEWKXgsSy5TPB7uEUcJXo+bWf
	HWKXi8Squ5OBariAam6xS1zaO48JYpCAxLfJh4AWcAAlZCU2HWCGmCMpcXDFDZYJjMILGBlW
	MYqmFiQXFCelF5noFSfmFpfmpesl5+duYgTG0ul/zybsYLx3wPoQowAHoxIPr8ORrSFCrIll
	xZW5hxhNgTZMZJYSTc4HRmxeSbyhsZmRhamJqbGRuaWZkjjva6mfwUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYPV4dsbvhIFr/rKrPd26yPLfb9jO6xaJL+Z9tUuDguzkrqSeGy+BGmWJB
	o2Lo9heay/XDz2e8nnlzru6WztMTn8ec+MwwtfvJ49j+1ydnTLm8oHnakoWPpvcr5rTPkn6y
	oqnA7boLJ6dN1s/XpfNnsja9ybeyX1KQU3riRX6r+8eHibFrbnscVmIpzkg01GIuKk4EAH9q
	KaWgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jQV0O2e0hBnvOm1k8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGol+9jAXrJSq6Zwc1
	ME4S6mLk5JAQMJFo+97BCGGLSVy4t54NxBYSmM4o0Xk3BcJuYpJ42pQNYrMJaEnsf3EDrEZE
	QE+i89gedhCbWeAPk0TTJhYQW1jARaJ94WawmSwCqhIXZzaC1fACxdc9Wgy1S0Fi2fKZrCA2
	p4CrRM+v/ewQu1wkVt2dzDiBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBYfSa9
	g3FVg8UhRgEORiUeXocjW0OEWBPLiitzDzFKcDArifC+/bQtRIg3JbGyKrUoP76oNCe1+BCj
	KdBVE5mlRJPzgWkkryTe0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qB
	ke2zz2XryY2PN0a/PLpjvoXvSU5pu/CfcW3XShLjIo9vXyDr7bCq+PUPl7Jd5/uKAkSbpfxd
	Vu36/ylw/+PH8iorvibqx66LaWL1VZsdc/VI+xUxG75Xhs+2GV6y7Lv474jVysi2pBk3JNp4
	WaN8jzQ29iruFNMxVm9m42bb8r3N+3NZ+uRcJZbijERDLeai4kQA/aYfaOsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the memory bus node for Exynos4210 SoC. Exynos4210 SoC has
one memory bus to translate data between DRAM and eMMC/sub-IPs because
Exynos4210 must need only one regulator for memory bus.

Following list specifies the detailed relation between memory bus clock and
sub-IPs:
- DMC/ACP clock : DMC (Dynamic Memory Controller)
- ACLK200 clock : LCD0
- ACLK100 clock : PERIL/PERIR/MFC(PCLK)
- ACLK160 clock : CAM/TV/LCD0/LCD1
- ACLK133 clock : FSYS/GPS
- GDL/GDR clock : leftbus/rightbus
- SCLK_MFC clock : MFC

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi | 93 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index b2598de..c039409 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -48,6 +48,99 @@
 		};
 	};
 
+	memory_bus: memory_bus@0 {
+		compatible = "samsung,exynos-memory-bus";
+
+		operating-points = <
+			400000 1150000
+			267000 1050000
+			133000 1025000>;
+		status = "disabled";
+
+		blocks {
+			dmc_block: memory_bus_block1 {
+				clocks = <&clock CLK_DIV_DMC>;
+				clock-names = "memory-bus";
+				frequency = <
+					400000
+					267000
+					133000>;
+			};
+
+			acp_block: memory_bus_block2 {
+				clocks = <&clock CLK_DIV_ACP>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					133000>;
+			};
+
+			peri_block: memory_bus_block3 {
+				clocks = <&clock CLK_ACLK100>;
+				clock-names = "memory-bus";
+				frequency = <
+					100000
+					100000
+					100000>;
+			};
+
+			fsys_block: memory_bus_block4 {
+				clocks = <&clock CLK_ACLK133>;
+				clock-names = "memory-bus";
+				frequency = <
+					133000
+					133000
+					100000>;
+			};
+
+			display_block: memory_bus_block5 {
+				clocks = <&clock CLK_ACLK160>;
+				clock-names = "memory-bus";
+				frequency = <
+					160000
+					133000
+					100000>;
+			};
+
+			lcd0_block: memory_bus_block6 {
+				clocks = <&clock CLK_ACLK200>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					100000>;
+			};
+
+			leftbus_block: memory_bus_block7 {
+				clocks = <&clock CLK_DIV_GDL>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					100000>;
+			};
+
+			rightbus_block: memory_bus_block8 {
+				clocks = <&clock CLK_DIV_GDR>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					100000>;
+			};
+
+			mfc_block: memory_bus_block9 {
+				clocks = <&clock CLK_SCLK_MFC>;
+				clock-names = "memory-bus";
+				frequency = <
+					200000
+					160000
+					100000>;
+			};
+		};
+	};
+
 	pmu_system_controller: system-controller@10020000 {
 		clock-names = "clkout0", "clkout1", "clkout2", "clkout3",
 				"clkout4", "clkout8", "clkout9";
-- 
1.8.5.5

