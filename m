Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaLaFUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:20:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49839 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaLaFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:19:57 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-8c-54a3877a094f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 5/8] ARM: dts: Add memory bus node for Exynos4x12
Date: Wed, 31 Dec 2014 14:19:49 +0900
Message-id: <1420003192-5576-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSrFvdvjjEYMJURovHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAldGz+4LbAVvpSte/khqYFwp0sXIySEhYCLRebOTBcIWk7hwbz1bFyMXh5DAUkaJ
	OWfuMMEU3dl+E6xISGARo0TnHqiiJiaJKbemgiXYBLQk9r+4wQZiiwjISFzduJ0FpIhZ4D+T
	xONXy1lBEsIC7hKrmrazg9gsAqoSXxceALN5BVwkelb3sUFsU5BYtnwmUD0HB6eAq8SEL84Q
	i10kZmxpZgKZKSFwjV1i+uJLrBBzBCS+TT7EAlIvISArsekAM8QYSYmDK26wTGAUXsDIsIpR
	NLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMjMHZO/3s2YQfjvQPWhxgFOBiVeHhv2C0OEWJNLCuu
	zD3EaAq0YSKzlGhyPjBC80riDY3NjCxMTUyNjcwtzZTEeV9L/QwWEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwKioPbtUKnmZY94axv9u/x48276ppTKrOvyWmsLavsNa1zYcOXtLn6H2yOGk
	q4vZ/766P9MguqskVMbYP2HlwptnY4OY1r0ULouOc+D9qWG4/cEC2wW5YY/u/u1g2Pj5T+8y
	hw9pu3/0cUy60M3Xy7tljrms1YfvWjuk+CX//E+d2fxCuP+NyUwlluKMREMt5qLiRACdoTzY
	mAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAd2q9sUhBj2NZhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2qAZGm4zU
	xJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygk5UUyhJzSoFC
	AYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGT27L7AVvJWuePkjqYFxpUgXIyeHhICJ
	xJ3tN1kgbDGJC/fWs4HYQgKLGCU69wDZXEB2E5PElFtTwYrYBLQk9r+4AVYkIiAjcXXjdhaQ
	ImaB/0wSj18tZwVJCAu4S6xq2s4OYrMIqEp8XXgAzOYVcJHoWd3HBrFNQWLZ8plA9RwcnAKu
	EhO+OEMsdpGYsaWZaQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZH5TGoH48oG
	i0OMAhyMSjy8N+wWhwixJpYVV+YeYpTgYFYS4b2sCRTiTUmsrEotyo8vKs1JLT7EaAp01ERm
	KdHkfGDSyCuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C6WPi4JRqYDwy9ZVe
	+UJxQ2f3bl2fM3xyKbPz1kzP2HJjUbuHd8XM+38n3ZnySvaM7OLWnJiFLY+ag03W8LwoM4xP
	yFzP3f3Q5fxXk4VHVCZsEI+tsP1y/OV8zZradc6uBXqGfh4O4te1QkLvTDj6pT9OI3nu+gsz
	1SQMj2+WOSG79ODZVVW3ze4YCQcfZlJiKc5INNRiLipOBADMguPe4gIAAA==
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
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

