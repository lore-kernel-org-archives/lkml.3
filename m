Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbbAHBnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:43:03 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38635 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbAHBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:03 -0500
X-AuditID: cbfee68f-f791c6d000004834-d5-54ade02a1e49
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 3/8] ARM: dts: Add memory bus node for Exynos3250
Date: Thu, 08 Jan 2015 10:40:52 +0900
Message-id: <1420681257-3078-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkQFf7wdoQg31bWSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlfF99W2WgjbZirvfXRoYl4p0MXJySAiYSHx5s4UVwhaTuHBv
	PVsXIxeHkMBSRomL7ROYYYparu2ESixilOg/d5EVwmlikni1Yj4jSBWbgJbE/hc32EBsEQE9
	ic5je9hBbGaBP0wSTZtYQGxhAWeJFdc/gdWwCKhKfP53kQnE5hVwkeh8t4ANYpuCxLLlM8FO
	4hRwleh/eg3MFgKqufx4FSPIYgmBR+wSd1e8ZIEYJCDxbfIhIJsDKCErsekA1NWSEgdX3GCZ
	wCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZgRJ3+96x/B+PdA9aHGAU4GJV4eAv6
	1oQIsSaWFVfmHmI0BdowkVlKNDkfGLd5JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJpCeWpGan
	phakFsUXleakFh9iZOLglGpgPCJ5qHFF1fPld9eJc2Y8vsNR53j39OQqrQffZ64KP2Vuekq5
	7N62dy8lzvrxTb7SXbLtQ9y2+zNmnjuesiLkjeLjlU++J72ZeCDxVY9C4PLJ1h6vvjzQXJNX
	8azxs9Nl07ZPhfNTgoRm3fC0LEqba7/1gLlw/Z4Nsu+fm2s7VW0S1i7cGlftE6DEUpyRaKjF
	XFScCABpJFusowIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV2tB2tDDObtsrB4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM76tvsxS0yVbc/e7S
	wLhUpIuRk0NCwESi5dpONghbTOLCvfVANheHkMAiRon+cxdZIZwmJolXK+YzglSxCWhJ7H9x
	A6xDREBPovPYHnYQm1ngD5NE0yYWEFtYwFlixfVPYDUsAqoSn/9dZAKxeQVcJDrfLYDapiCx
	bPlMVhCbU8BVov/pNTBbCKjm8uNVjBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CI7XZ9I7GFc1WBxiFOBgVOLhLehbEyLEmlhWXJl7iFGCg1lJhLfr7NoQId6UxMqq1KL8+KLS
	nNTiQ4ymQFdNZJYSTc4HppK8knhDYxMzI0sjc0MLI2NzJXFeJfu2ECGB9MSS1OzU1ILUIpg+
	Jg5OqQbGufunzb88Y6vvUW+OsNPnnz1Uqn+z+WmzoMvClb2Zy68tfZUUkrv5yo9Dr201mc48
	Ks0NlAww+C5dqbxtgml7jUne58VfL2/7X+18I9Rdyc9gtdvvf/zycy9F12/Jr2q9+v24tXgf
	bxCnbcJB2d3x3RMb3nmct3NJXRB9w2e+xfvZms9POm0LVGIpzkg01GIuKk4EANxDJ1/tAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the memory bus node for Exynos3250 SoC. Exynos3250 has
following memory buses to translate data between DRAM and eMMC/sub-IPs.

Following list specifies the detailed relation between memory bus clock and DMC
IP in MIF (Memory Interface) block:
- DMC clock : DMC (Dynamic Memory Controller)

Following list specifies the detailed relation between memory bus clock and
sub-IPs in INT (Internal) block:
- ACLK100 clock : PERIL
- ACLK160 clock : LCD0
- ACLK200 clock : FSYS
- ACLK266 clock : ISP
- GDL/GDR clock : leftbus/rightbus
- SCLK_MFC clock : MFC

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 125 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 9ed1260..3eaed53 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -99,6 +99,131 @@
 			};
 		};
 
+		memory_bus_mif: memory_bus@0 {
+			compatible = "samsung,exynos-memory-bus";
+
+			operating-points = <
+				400000 875000
+				200000 800000
+				133000 800000
+				100000 800000
+				50000  800000>;
+			status = "disabled";
+
+			blocks {
+				dmc_block: memory_bus_block1 {
+					clocks = <&cmu_dmc CLK_DIV_DMC>;
+					clock-names = "memory-bus";
+					frequency = <
+						400000
+						200000
+						133000
+						100000
+						50000>;
+				};
+			};
+		};
+
+		memory_bus_int: memory_bus@1 {
+			compatible = "samsung,exynos-memory-bus";
+
+			operating-points = <
+				400000 950000
+				200000 950000
+				133000 925000
+				100000 850000
+				80000  850000
+				50000  850000>;
+
+			status = "disabled";
+
+			blocks {
+				peril_block: memory_bus_block1 {
+					clocks = <&cmu CLK_DIV_ACLK_100>;
+					clock-names = "memory-bus";
+					frequency = <
+						100000
+						100000
+						100000
+						100000
+						50000
+						50000>;
+				};
+
+				lcd0_block: memory_bus_block2 {
+					clocks = <&cmu CLK_DIV_ACLK_160>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						160000
+						100000
+						80000
+						80000
+						50000>;
+				};
+
+				fsys_block: memory_bus_block3 {
+					clocks = <&cmu CLK_DIV_ACLK_200>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						100000
+						80000
+						50000
+						50000>;
+				};
+
+				isp_block: memory_bus_block4 {
+					clocks = <&cmu CLK_DIV_ACLK_266>;
+					clock-names = "memory-bus";
+					frequency = <
+						300000
+						200000
+						133000
+						100000
+						50000
+						50000>;
+				};
+
+				leftbus_block: memory_bus_block5 {
+					clocks = <&cmu CLK_DIV_GDL>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						133000
+						100000
+						100000
+						100000>;
+				};
+
+				rightbus_block: memory_bus_block6 {
+					clocks = <&cmu CLK_DIV_GDR>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						133000
+						100000
+						100000
+						100000>;
+				};
+
+				mfc_block: memory_bus_block7 {
+					clocks = <&cmu CLK_SCLK_MFC>;
+					clock-names = "memory-bus";
+					frequency = <
+						200000
+						200000
+						200000
+						133000
+						100000
+						80000>;
+				};
+			};
+		};
+
 		sysram@02020000 {
 			compatible = "mmio-sram";
 			reg = <0x02020000 0x40000>;
-- 
1.8.5.5

