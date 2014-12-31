Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaLaFUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:20:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaLaFUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:20:02 -0500
X-AuditID: cbfee68f-f791c6d000004834-2e-54a3877bddf2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 6/8] ARM: dts: Add memory bus node for Exynos4210
Date: Wed, 31 Dec 2014 14:19:50 +0900
Message-id: <1420003192-5576-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSqFvdvjjEYMMvDovHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAldGz6LlLAVbJCoevlzJ2sA4XaiLkZNDQsBEYtG/t8wQtpjEhXvr2boYuTiEBJYy
	Sqw6t5sdpujm7bksEIlFjBKf31yAqmpikphyayoLSBWbgJbE/hc32EBsEQEZiasbt4N1MAv8
	Z5J4/Go5K0hCWMBdoulIOyOIzSKgKrFgwSkmEJtXwEXi8bLHjBDrFCSWLZ8JVM/BwSngKjHh
	izNIWAioZMaWZiaQmRICt9glDh95wgwxR0Di2+RDLCD1EgKyEpsOQL0jKXFwxQ2WCYzCCxgZ
	VjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIExs/pf8/6dzDePWB9iFGAg1GJh/em3eIQIdbE
	suLK3EOMpkAbJjJLiSbnA6M0ryTe0NjMyMLUxNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjDoeTu7PJT/K/1+77maFY8dp9pfM6lG1KnFTy/MO2yd3er98vzF5h3FF
	guCnBfet5b8wJQo85RfVY/1SbP23+aXZY/5PzoJT7HeerUopMJn3n3m28qyt+23P6vzM8zmz
	/3IFW4jyqbepRhM55R8dj0hKN1hfeUTMv8bl9k2j6WdDKiUmTFv/Q4mlOCPRUIu5qDgRALzx
	SRmaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd3q9sUhBp2qFo/XLGay2DhjPavF
	9S/PWS0m3Z/AYvH6haFF74KrbBZnm96wW2x6fI3V4vKuOWwWn3uPMFrMOL+PyWLp9YtMFrcb
	V7BZPF7xlt1i1a4/jA78HmvmrWH02DnrLrvH4j0vmTw2L6n36NuyitHj8ya5ALaoBkabjNTE
	lNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCLlRTKEnNKgUIB
	icXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZPYuWsxRskah4+HIlawPjdKEuRk4OCQET
	iZu357JA2GISF+6tZ+ti5OIQEljEKPH5zQUop4lJYsqtqWBVbAJaEvtf3GADsUUEZCSubtzO
	AlLELPCfSeLxq+WsIAlhAXeJpiPtjCA2i4CqxIIFp5hAbF4BF4nHyx4zQqxTkFi2fCZQPQcH
	p4CrxIQvziBhIaCSGVuamSYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERybz6R2
	MK5ssDjEKMDBqMTDe8NucYgQa2JZcWXuIUYJDmYlEd7LmkAh3pTEyqrUovz4otKc1OJDjKZA
	R01klhJNzgemjbySeENjEzMjSyNzQwsjY3MlcV4l+7YQIYH0xJLU7NTUgtQimD4mDk6pBkZn
	qTIjKx6usucrWqd929tjrPpv0/4ZFyoPzA6U96zguKY8OdtRZjHHxEOXZHqYOpu7WW6XTP2e
	w3vv7qG+CZLd3ZH7V9/5bzTz+0HGNqGApz0b/Pu/cYYlnJBfWe1yq6/z16/Lh5cJuhU8TOA8
	PDds8evltWqBs3IWs2xN4f35+3pMgLZG93QlluKMREMt5qLiRAAM7Cod4wIAAA==
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
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

