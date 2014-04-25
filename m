Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaDYBR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:17:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39160 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaDYBQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:16:24 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-87-5359b762b5f5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCHv4 6/7] dt-bindings: add documentation for Exynos3250 clock
 controller
Date: Fri, 25 Apr 2014 10:16:11 +0900
Message-id: <1398388572-30239-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
References: <1398388572-30239-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA5VS/S+UcQDv+9zzPHeu1JOXfLP4wdTWNeS1L8n8oj3zU2rLUpvOeYblju5o
	bUXmZSQvT2hORTIWl7ddEnJej5CUeV2da5PjEsVOprzUnVt/QL993vb5/PLhcazyCHtejCSB
	kUqEsU4kH6+18bruInp16cLJLDWOtgv6uaigvgtDY50n0NTaAoGeqEcIlL/0lECGlXQuGlms
	AajgM4uj3PIJEr1LXeIi5ZdJAo21PSaR/H0Hhj6NWaJtzQ6JqqZGMaRjR0k0NGUgEVtch6Nl
	TTGOMlRqLhrcygVorneVQPLCryRqkH/DUb+8EqDMbRWJVK2FINCBri2rBXR6Wg5Jb/4uAPRY
	Xi5Gbyv0HLr14QyXrnm2RtIvqgW0UnGXpDWT7UZWeYceH0gl6LwmBaANSsdz+8P4/pFMbMwN
	RuoWcJUffY/9RcSX2dwsrSjmpoCsg9nAggcpL5jGtuNmfAh+0DaQ2YDPs6KqAMzZ6SL/hWY3
	RzGzUQxgS/0U10xSMaiYVu2mSEoAO/XTu9iGcoFFJRrCFOJQRSRcfdlBmAxrKhT+0ZRiJoxT
	R6HheRbXhC2pINir1WLmOUe40j67q1tQZ2Fr26JR5xnXgmDVFm3qhNQGD641lZLmHgquF/bg
	pgykHKCyi2OuOQy7q6dxFliXgz0KYMvEi+JlEVFSL1eZUCxLlES5iuLESmD8wtudebYFaLtO
	9wCRse4+x95WFGf8iiQh3N3TxwN5e3l7epzy9fk/2cnO8thsxHkrKkqYwFxjmHhGGi5NjGVk
	PQDjWdinALaRqilpjjowM2xJ8a8Y1PJmW9rn9RG/sIt9rr4hdvv9Wib2hc5VuwXrflQEAQn4
	Gf1It+GT4bT+IDFDl56ZHClO0uc38OrGKzMDgrUf82pj5udCIm8nLYulCZe/n3GOuKWvbhzy
	1w70+dkNc/QegYNvkvUh7MJeZ0m34PjwsBMuixa6CzhSmfAvItxg8CEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jQd2k7ZHBBg3fzCz+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi/43C1ktPn9oYbc492olo8Wk+xNYLHoXXGWzONv0ht1i0+NrrBaX
	d81hs5hxfh+Txe3LvBZ/7/xjs1h6/SKTxdMJF9ksTl3/zGYxYfpaFou3d6azWLTuPcJucfJP
	L6PFk8MfWS1mTH7JZrF+xmsWi2MzljBatP/dy2axd+dkRgdZjzXz1jB6tDT3sHn8/jWJ0eNy
	Xy+Tx99VL5g9ds66y+6xcvkXNo/NK7Q8Nq3qZPO4c20PkLek3uPKiSZWj74tqxg9Pm+SC+CL
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAEGj5JC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxo3vCT9aCeSIVcxdNZ29g7BDs
	YuTkkBAwkXj0+yIThC0mceHeerYuRi4OIYHpjBI71l1nh3CamCRW3djLBlLFJqAlsf/FDTBb
	REBXYsrMO6wgRcwCU9gkPm7dxwqSEBYIl/h/Zy7YWBYBVYnPqzvYQWxeAVeJw/fuQa2Tk/iw
	5xFYnFPATWLnrldAcQ6gba4SS/94TGDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OOk8k9rBuLLB4hCjAAejEg/vB7XIYCHWxLLiytxDjBIczEoivMqrgEK8KYmVValF+fFFpTmp
	xYcYk4GOmsgsJZqcD0yIeSXxhsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZ
	wsTBKdXAuHSqH+vqlFYBj2X/C24mf2es5p/zrqRMx++IVHnsiWXSOS7XWPJO9Vxsr97NqbT3
	uUttYOXivEcm+x6GKn5UuSTelcC+ie8Yb+ipzT/tfqtc9eEW3cPEnSn5Llz06hf1vwubD5pY
	NbxoMo5ZOsciwO2wZTrL9tI1Pf9f33+oejT6s+XVUxFnlFiKMxINtZiLihMBclLqOn4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos3250 clocks are statically listed and registered using the
Samsung specific common clock helper functions. Both device tree based
clock lookup and clkdev based clock lookups are supported.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/clock/exynos3250-clock.txt | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos3250-clock.txt

diff --git a/Documentation/devicetree/bindings/clock/exynos3250-clock.txt b/Documentation/devicetree/bindings/clock/exynos3250-clock.txt
new file mode 100644
index 0000000..aadc9c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/exynos3250-clock.txt
@@ -0,0 +1,41 @@
+* Samsung Exynos3250 Clock Controller
+
+The Exynos3250 clock controller generates and supplies clock to various
+controllers within the Exynos3250 SoC.
+
+Required Properties:
+
+- compatible: should be one of the following.
+  - "samsung,exynos3250-cmu" - controller compatible with Exynos3250 SoC.
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
+dt-bindings/clock/exynos3250.h header and can be used in device
+tree sources.
+
+Example 1: An example of a clock controller node is listed below.
+
+	cmu: clock-controller@10030000 {
+		compatible = "samsung,exynos3250-cmu";
+		reg = <0x10030000 0x20000>;
+		#clock-cells = <1>;
+	};
+
+Example 2: UART controller node that consumes the clock generated by the clock
+	   controller. Refer to the standard clock bindings for information
+	   about 'clocks' and 'clock-names' property.
+
+	serial@13800000 {
+		compatible = "samsung,exynos4210-uart";
+		reg = <0x13800000 0x100>;
+		interrupts = <0 109 0>;
+		clocks = <&cmu CLK_UART0>, <&cmu CLK_SCLK_UART0>;
+		clock-names = "uart", "clk_uart_baud0";
+	};
-- 
1.8.0

