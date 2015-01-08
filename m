Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbbAHBmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:42:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAHBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:41:06 -0500
X-AuditID: cbfee68f-f791c6d000004834-da-54ade02b6a59
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv3 6/8] ARM: dts: Add memory bus node for Exynos4210
Date: Thu, 08 Jan 2015 10:40:55 +0900
Message-id: <1420681257-3078-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSoqv9YG2IwfTtMhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgylj0q5exYL1ERffsoAbGSUJdjJwcEgImEk+e7WOBsMUkLtxb
	z9bFyMUhJLCUUWLX8tesMEXHXr1mhEgsYpQ4cO4HO4TTxCTxasV8RpAqNgEtif0vbrCB2CIC
	ehKdx/awg9jMAn+YJJo2ga0QFnCWmPhrH1gNi4CqxIH/S5hBbF4BF4kLn9vYIbYpSCxbPhNs
	M6eAq0T/02tgthBQzeXHqxghal6ySzQssYOYIyDxbfIhoPkcQHFZiU0HmCFKJCUOrrjBMoFR
	eAEjwypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MwHg6/e9Z/w7GuwesDzEKcDAq8fAW9K0J
	EWJNLCuuzD3EaAq0YSKzlGhyPjBq80riDY3NjCxMTUyNjcwtzZTEeRdK/QwWEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwJgzzXMCK0cr87lLJ4wmenL/lT50VMCt4PGZO8d0I9+7KU9Szytd
	cTx3mbbVgetJh9dGOhgGzz4mzuqY6bKz4Mit6wzKpfLfFPwVE6QsXDzrT24J/7elm2GL5ovg
	J4/v2U2Wmf57pdWpfZzrE09+ny18oWTxrVXS+7gqPqT+TDlzc5dALIvSvvtKLMUZiYZazEXF
	iQAraITEogIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAV3tB2tDDK6sELZ4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMRb96GQvWS1R0zw5q
	YJwk1MXIySEhYCJx7NVrRghbTOLCvfVsXYxcHEICixglDpz7wQ7hNDFJvFoxH6yKTUBLYv+L
	G2wgtoiAnkTnsT3sIDazwB8miaZNLCC2sICzxMRf+8BqWARUJQ78X8IMYvMKuEhc+NzGDrFN
	QWLZ8pmsIDangKtE/9NrYLYQUM3lx6sYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yf
	u4kRHK/PpHYwrmywOMQowMGoxMNb0LcmRIg1say4MvcQowQHs5IIb9fZtSFCvCmJlVWpRfnx
	RaU5qcWHGE2BrprILCWanA9MJXkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp2ampBalF
	MH1MHJxSDYwy/vqvl4dPX2CceqPt59vt9harzzUd2WOxfkOGkjjPEVYznqfH3jd/a3w4hcXk
	9r5Jd6aYd1hY6LTMvxZl3Z/fVn1K76jMEsbi72pqZ+Q/H5t2siRklvaNAKnig0crvkumdO2s
	PMje/DlxXlzv4+WvH0V9LLzlFXR8WfTF4pKPyY67mc6xl/xQYinOSDTUYi4qTgQArgfNve0C	AAA=
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

