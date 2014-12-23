Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaLWLou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:44:50 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23444 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbaLWLoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:44:44 -0500
X-AuditID: cbfee68f-f791c6d000004834-f2-549955a6ea61
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCH 3/4] ARM: dts: Add memory bus node for Exynos3250
Date: Tue, 23 Dec 2014 20:44:36 +0900
Message-id: <1419335077-31020-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
References: <1419335077-31020-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSorssdGaIwYKdWhaP1yxmsrj+5Tmr
	xfwj51gtJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdYtWuP4wO/B5r5q1h9Ng56y67x+I9L5k8Ni+p9+jbsorR4/MmuQC2KC6blNSc
	zLLUIn27BK6MQ9OrCs5IV9w7tJOpgfGZUBcjB4eEgInE4zXxXYycQKaYxIV769m6GLk4hASW
	MkqsbD3FApEwkfh/chYTiC0kMJ1RomMrVFETk8SkmxfBEmwCWhL7X9xgA7FFBGQkrm7czgJS
	xCzQyCzxZdl/JpBtwgKuEneO1IHUsAioSmw68YgdxOYFCp9achNqmYLEsuUzWUFsTgE3iX8/
	3rFALHaVOPPrBjNEzTV2iT1P+SHmCEh8m3yIBeIZWYlNB6BKJCUOrrjBMoFReAEjwypG0dSC
	5ILipPQiY73ixNzi0rx0veT83E2MwLg5/e9Z/w7GuwesDzEKcDAq8fAuODMjRIg1say4MvcQ
	oynQhonMUqLJ+cDozCuJNzQ2M7IwNTE1NjK3NFMS510o9TNYSCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUA2P6klNhJgFzNczDvGZVri6W7ly2jFd3162JK7QcOf7flK3Q+revvmWH9Z8YXk7b
	wHUnE4vL+d1Es6IY/i7Y9+12+P26p7HVuXcfHq+ZcLflwmSXYmZTtz9LFaz3cU07V8Th/4z9
	7PRJZ66WtFz0vJkxJTK3xzOqNi5r7rugQ1NbkoQcmNw4mZVYijMSDbWYi4oTAfH5oROWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jQd1loTNDDD6/lLF4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDg0vargjHTFvUM7mRoYnwl1MXJySAiY
	SPw/OYsJwhaTuHBvPRuILSQwnVGiYyuQzQVkNzFJTLp5EayITUBLYv+LG2BFIgIyElc3bmcB
	KWIWaGSW+LLsP1ARB4ewgKvEnSN1IDUsAqoSm048YgexeYHCp5bcZIFYpiCxbPlMVhCbU8BN
	4t+PdywQi10lzvy6wTyBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODIfCa1g3Fl
	g8UhRgEORiUe3gVnZoQIsSaWFVfmHmKU4GBWEuFVDpwZIsSbklhZlVqUH19UmpNafIjRFOiq
	icxSosn5wKSRVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAuN9r
	0SHJyV61LpGm24tdJbmWsTOfru4TXPVi3o5b7gvnr+1dbL6ych9vrtfm2ylu8ZNbXJ0E190V
	PPeyKHKypO6RYvbDacKnwuwPqK3e8oBz+ZWwRZFHLZf2l0WcSvg+Wf5lwNa4Gauz65o+nlOM
	4+za3Ft24YLJomfHHe6fEc+omVSR+eHZLyWW4oxEQy3mouJEAHqYrkziAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the memory bus node for Exynos3250 SoC. Exynos3250 has
following memory buses to translate data between DRAM and eMMC/sub-IPs.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 137 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 9ed1260..7f20039 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -99,6 +99,143 @@
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
+				peri_block: memory_bus_block1 {
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
+				display_block: memory_bus_block2 {
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
+				isp_block: memory_bus_block3 {
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
+				gps_block: memory_bus_block4 {
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
+				mcuisp_block: memory_bus_block5 {
+					clocks = <&cmu CLK_DIV_ACLK_400_MCUISP>;
+					clock-names = "memory-bus";
+					frequency = <
+						400000
+						200000
+						50000
+						50000
+						50000
+						50000>;
+				};
+
+				leftbus_block: memory_bus_block6 {
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
+				rightbus_block: memory_bus_block7 {
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
+				mfc_block: memory_bus_block8 {
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

