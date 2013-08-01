Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3HAJdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:33:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61560 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3HAJdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:33:44 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-fd-51fa2b77ce92
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kgene.kim@samsung.com, dianders@chromium.org
Subject: [PATCH] ARM: dts: exynos5420: add ADC device tree node
Date: Thu, 01 Aug 2013 14:58:41 +0530
Message-id: <1375349321-18646-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWyRsSkWrdc+1egwfNeIYuzyw6yWfQuuMpm
	cXnXHDaLGef3MTmweMxuuMji0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBlXlx1gKpjFXvH8
	zkTmBsYfrF2MHBwSAiYSB94JdjFyApliEhfurWfrYuTiEBJYyihx5tosJoiEicSrhjPMILaQ
	wCJGiaNtdRBFPUwSZ05PYwVJsAmYSRxctJodxBYRUJX43LYAzGYW8JPouP8abJCwgL3EhNsL
	GUFsFqCa/duXgPXyCrhK3Fs3lQniIAWJOZNsQOZLCNxmk2iacZYFol5A4tvkQywQNbISmw4w
	Q9wmKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIEBuDpf88m7GC8d8D6
	EGMy0LiJzFKiyfnAAM4riTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA+MkJefkJ4qC/Fd6wr5lrJoWFhpxbvYfma6pqTriX1497mH5YLb3bX/tDdEn
	DTXSXXeOHH5Y+f+637Rfr7fP1fn3WlSA30ozpmLSggNL1e4zZF8LPnyFcetan+iir0sVZ0dN
	bBHf/qnr40LbN8cv5P1adMRM39TC7RJLVcDnDOfUq4/vph9gVGdWYinOSDTUYi4qTgQA61K/
	9FYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd1y7V+BBvues1ucXXaQzaJ3wVU2
	i8u75rBZzDi/j8mBxWN2w0UWj74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMuLrsAFPBLPaK53cmMjcw/mDtYuTkkBAwkXjVcIYZwhaTuHBvPRuILSSw
	iFHiaFtdFyMXkN3DJHHm9DSwBjYBM4mDi1azg9giAqoSn9sWgNnMAn4SHfdfM4HYwgL2EhNu
	L2QEsVmAavZvXwLWyyvgKnFv3VSgGg6gZQoScybZTGDkXsDIsIpRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOMCfSe1gXNlgcYhRgINRiYc3Y+vPQCHWxLLiytxDjBIczEoivI81fgUK8aYk
	VlalFuXHF5XmpBYfYkwGWj6RWUo0OR8YfXkl8YbGJuamxqaWJhYmZpakCSuJ8x5otQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwLhmCktX8Umd82yNvGrc0j+2nCir7ehTdZRuWfP6keZzd8G5rYz/
	bFN+mS2I7LaIFn64ijXulfax+Zo6PF2Wy91CJnzkkN4sFj77LfvbC+5T06ZPM/KrWmnM/3S2
	m8baD66l+RaXSrp26CWLitiz8GdNz/T3KDt5bcrrHc027822eaR83flSSImlOCPRUIu5qDgR
	AAVRix60AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaehoon Kim <jh228.kim@samsung.com>

Add device tree node for ADC in exynos5420.dtsi

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/exynos5420.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 8c54c4b..074e1bc 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -145,4 +145,15 @@
 		clocks = <&clock 260>, <&clock 131>;
 		clock-names = "uart", "clk_uart_baud0";
 	};
+
+	adc: adc@12D10000 {
+		compatible = "samsung,exynos-adc-v2";
+		reg = <0x12D10000 0x100>, <0x10040720 0x4>;
+		interrupts = <0 106 0>;
+		#io-channel-cells = <1>;
+		io-channel-ranges;
+		clocks = <&clock 270>;
+		clock-names = "adc";
+		status = "disabled";
+	};
 };
-- 
1.7.9.5

