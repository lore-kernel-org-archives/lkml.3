Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbbAOBxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:53:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9446 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbAOBvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:51:09 -0500
X-AuditID: cbfee68d-f79296d000004278-1b-54b71d08789f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 5/9] ARM: dts: Add memory bus node for Exynos4x12
Date: Thu, 15 Jan 2015 10:50:53 +0900
Message-id: <1421286657-4720-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkQJdDdnuIwdevZhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgytj4YBJTwWyZioXztzI2MF4S6WLk5JAQMJG4eriRFcIWk7hw
	bz1bFyMXh5DAUkaJS79fssMU3VrWxwKRmM4o8en8RmaQhJBAE5PE06ZsEJtNQEti/4sbbCC2
	iICeROexPWDNzAJ/mCSaNrGA2MICLhJPPtxhArFZBFQlJi9ZARbnBYqvnv6CDWKZgsSy5TPB
	LuIUcJXo+bWfHWKXi8Squ5MZQY6QEHjJLvHy+g1WiEECEt8mHwIaxAGUkJXYdIAZYo6kxMEV
	N1gmMAovYGRYxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREYUaf/PevdwXj7gPUhRgEORiUe
	XocjW0OEWBPLiitzDzGaAm2YyCwlmpwPjNu8knhDYzMjC1MTU2Mjc0szJXFeRamfwUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoYOz3uu388vVF6ytorD/9NOCNRaLz/sv/G6auNvnxbL7tt
	bdBx9aRDTfPn7Pgvd9+B/12m23rmhM3ftLxtw9W/npv84cUGji1b/v1VdjzvLdcrk7PoYNLV
	4IaLD72E1jL6XpGwEuSSiJ68uum6zIbXu+Ya2zznyJR4+DuuRXfd9DUm69/0ze1uZ1RiKc5I
	NNRiLipOBABSTIIFowIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQV0O2e0hBq8361s8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtVu36w+gg4LFm3hpGj52z7rJ7LN7zkslj06pONo/NS+o9+rasYvT4
	vEkugD2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGxgeTmApmy1QsnL+V
	sYHxkkgXIyeHhICJxK1lfSwQtpjEhXvr2boYuTiEBKYzSnw6v5EZJCEk0MQk8bQpG8RmE9CS
	2P/iBhuILSKgJ9F5bA87iM0s8IdJomkT2CBhAReJJx/uMIHYLAKqEpOXrACL8wLFV09/wQax
	TEFi2fKZrCA2p4CrRM+v/ewQu1wkVt2dzDiBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOB4fSa9g3FVg8UhRgEORiUeXocjW0OEWBPLiitzDzFKcDArifC+/bQtRIg3JbGyKrUo
	P76oNCe1+BCjKdBVE5mlRJPzgakkryTe0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUg
	tQimj4mDU6qBUdWo4n3hySYutectCewbL7nudv9zL/7vkarZq5zFHBUdo6Oq8qfG3RLJbtso
	on9ctLPEU+3og0+egZd+urzZ9v1SL2OFNpPGi1nCnsYHzXUaFpostnybs2qTSTv7YWMRxjMZ
	DlzWeYzlRy7FTF50lmX6dMluF8XNG+5m9M7V3za1++IWB+8HSizFGYmGWsxFxYkAUzG7fu0C	AAA=
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
Acked-by: Myungjoo Ham <myungjoo.ham@samsung.com>
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

