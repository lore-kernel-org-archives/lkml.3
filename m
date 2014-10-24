Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaJXLH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:07:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62160 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbaJXLHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:07:18 -0400
X-AuditID: cbfee691-f79b86d000004a5a-d3-544a32e08484
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, sw0312.kim@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, geunsik.lim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/2] clk: samsung: Document binding for Exynos4415 clock
 controller
Date: Fri, 24 Oct 2014 20:07:08 +0900
Message-id: <1414148828-23719-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414148828-23719-1-git-send-email-cw00.choi@samsung.com>
References: <1414148828-23719-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkQPeBkVeIwfUbAhbXvzxntfgzoZXN
	YtL9CSwWvQuuslmcbXrDbnF51xw2ixnn9zFZHH7TzmoxY/JLNotVu/4wOnB57Jx1l92jb8sq
	Ro/Pm+QCmKO4bFJSczLLUov07RK4MibdUS9oE6g41PaUrYHxAG8XIyeHhICJRMfDJ2wQtpjE
	hXvrwWwhgaWMEtM22nYxcoDVfPmW0MXIBRSezijxb1ofG4TTxCTxcPNcVpAGNgEtif0vbrCB
	NIgIGErcPKQEUsMscJ1RYuapHrChwgLhEldXd4LZLAKqEgf3vAbr5RVwlWi8OYkd4ggFiWXL
	Z4LFOQXcJE4sesIIMlMIqObVchGQmRIC89glZu/+ww4xR0Di2+RDLBCHykpsOsAMMUZS4uCK
	GywTGIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAgM9dP/nk3cwXj/gPUhRgEORiUe
	3hszPEOEWBPLiitzDzGaAm2YyCwlmpwPjKi8knhDYzMjC1MTU2Mjc0szJXFeHemfwUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoY3ecExfjK2h4oKFzz0L/uR9WO51nlagx3DTfO0RHsSg8+
	cbF89fU32o/ncnjms96cPWcF41qPuDzWxfqfPeNfT+9527+XzXbNiqvBBjPXdYvECz34OLvX
	j/VXltTqHzvnmBo5F6c8/q+0VT677UKSaaot34VtoT9E5hivKxFSrWy9/D1dZEa5EktxRqKh
	FnNRcSIAQgbFMXACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jQd0HRl4hBms+clhc//Kc1eLPhFY2
	i0n3J7BY9C64ymZxtukNu8XlXXPYLGac38dkcfhNO6vFjMkv2SxW7frD6MDlsXPWXXaPvi2r
	GD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx6Y56QZtAxaG2
	p2wNjAd4uxg5OCQETCS+fEvoYuQEMsUkLtxbz9bFyMUhJDCdUeLftD4op4lJ4uHmuawgVWwC
	WhL7X9xgA2kWETCUuHlICaSGWeA6o8TMUz1sIDXCAuESV1d3gtksAqoSB/e8BuvlFXCVaLw5
	iR1im4LEsuUzweKcAm4SJxY9YQSZKQRU82q5yARG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS
	9ZLzczcxgmPpmfQOxlUNFocYBTgYlXh4b8zwDBFiTSwrrsw9xCjBwawkwvtSzStEiDclsbIq
	tSg/vqg0J7X4EKMp0FETmaVEk/OBcZ5XEm9obGJmZGlkbmhhZGyuJM57sNU6UEggPbEkNTs1
	tSC1CKaPiYNTqoHR9Ukt67Vv00Ua7apt5004VcTd4iQo2+22Mko1dJv94njV8Ft9zNXCmTr3
	a+p2yLqFCLHMa1y9gCF9VyXn/Pz70xzvl4npmO45bLMzbR5zSstF7eQ909k/6anN2XFAPDVf
	/btj6lM2YeEJ3R7XG0M2MhxonpH7oJih7zpD//KWPned91q1ukosxRmJhlrMRcWJAGyJNqu7	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DT binding documentation for Exynos4415 SoC system
clock controllers.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/clock/exynos4415-clock.txt | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos4415-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/exynos4415-clock.txt b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
new file mode 100644
index 0000000..847d98b
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos4415-clock.txt
@@ -0,0 +1,38 @@
+* Samsung Exynos4415 Clock Controller
+
+The Exynos4415 clock controller generates and supplies clock to various
+consumer devices within the Exynos4415 SoC.
+
+Required properties:
+
+- compatible: should be one of the following:
+  - "samsung,exynos4415-cmu" - for the main system clocks controller
+    (CMU_LEFTBUS, CMU_RIGHTBUS, CMU_TOP, CMU_CPU clock domains).
+  - "samsung,exynos4415-cmu-dmc" - for the Exynos4415 SoC DRAM Memory
+    Controller (DMC) domain clock controller.
+
+- reg: physical base address of the controller and length of memory mapped
+  region.
+
+- #clock-cells: should be 1.
+
+Each clock is assigned an identifier and client nodes can use this identifier
+to specify the clock which they consume.
+
+All available clocks are defined as preprocessor macros in
+dt-bindings/clock/exynos4415.h header and can be used in device
+tree sources.
+
+Example 1: An example of a clock controller node is listed below.
+
+	cmu: clock-controller@10030000 {
+		compatible = "samsung,exynos4415-cmu";
+		reg = <0x10030000 0x18000>;
+		#clock-cells = <1>;
+	};
+
+	cmu-dmc: clock-controller@105C0000 {
+		compatible = "samsung,exynos4415-cmu-dmc";
+		reg = <0x105C0000 0x3000>;
+		#clock-cells = <1>;
+	};
-- 
1.8.5.5

