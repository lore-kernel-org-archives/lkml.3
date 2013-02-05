Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3BEM7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:59:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20357 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3BEM7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:59:13 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-e9-511102200f77
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        balbi@ti.com, grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v3 2/2] ARM: Exynos5250: Enabling samsung-usb3phy driver
Date: Tue, 05 Feb 2013 18:33:54 +0530
Message-id: <1360069434-20417-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1360069434-20417-1-git-send-email-gautam.vivek@samsung.com>
References: <1360069434-20417-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkVleBSTDQYMFxJYvLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mmb1KRT8Yas4++8HcwPjRdYuRk4OCQETiffN
	C9khbDGJC/fWs3UxcnEICSxllFh0cQojTNHavtnMEInpjBLr1m9hhXAmM0k82fCRDaSKTUBX
	ountLrAOEQFVic9tC9hBipgFOpgkvk9cDbZDWMBD4kX3LCYQmwWoaNukScwgNi9Q/PaDvWwQ
	6xQk3tx+BhbnFPCU+Lj+F9hQIaCaQ3OvsYAMlRC4zyaxqvkWM8QgAYlvkw8BJTiAErISmw4w
	Q8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzECA/P0v2dSOxhXNlgc
	YhTgYFTi4f1xmT9QiDWxrLgy9xCjBAezkghv9ReBQCHelMTKqtSi/Pii0pzU4kOMyUDLJzJL
	iSbnA6MmryTe0NjE3NTY1NLIyMzUlDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFwSjUwhny9
	LHXTYe3choSl10ulZSIrZDSX9YUff3Hp9Ib3x/msLvy5YD9tQb7Sdb7P6xY1yEQFBiw9Nk+n
	9bxZ8vGYRtP8hna50yXsrGLGZ+9rOi99O4shoMk/beGuD6qfq3zbckQi+54mntWdG2c5R7pS
	RfDxvtaSG7MeuGjrfp59eH7zxbzO0sueSizFGYmGWsxFxYkAzX7EoZACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQV0FJsFAg9kPJC0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyY1adQ
	8Iet4uy/H8wNjBdZuxg5OSQETCTW9s1mhrDFJC7cW8/WxcjFISQwnVFi3fotrBDOZCaJJxs+
	soFUsQnoSjS93cUIYosIqEp8blvADlLELNDBJPF94mp2kISwgIfEi+5ZTCA2C1DRtkmTwFbw
	AsVvP9jLBrFOQeLN7WdgcU4BT4mP63+BDRUCqjk09xrLBEbeBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCw/6Z1A7GlQ0WhxgFOBiVeHh/XOYPFGJNLCuuzD3EKMHBrCTCW/1FIFCI
	NyWxsiq1KD++qDQntfgQYzLQVROZpUST84ExmVcSb2hsYm5qbGppYmFiZkmasJI4L+OpJwFC
	AumJJanZqakFqUUwW5g4OKUaGHPioz5e/x3LmH1ByLmp7YtWu/nBV4q50vozTSUehf6Ye+q7
	xP+76Q/vfajhcTIKuLH11mQ3nab4hbZ3epUavtf6HfITt55veOS7q5jvmTu9HyUW+C4W22ba
	5/FOdGuFQ34vu3J5nKt0V9zPJ4cTc1vPPLFd4FprvFpcsXjxpTS/zTwF68xDlViKMxINtZiL
	ihMBLDtexr8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding device node for Samsung USB 3.0 PHY controller driver
on Exynos5250 along with the necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index d1865a8..451dcdb 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -99,6 +99,18 @@
 		interrupts = <0 65 0>;
 	};
 
+	usbphy@12100000 {
+		compatible = "samsung,exynos5250-usb3phy";
+		reg = <0x12100000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			reg = <0x10040704 0x8>;
+		};
+	};
+
 	usbphy@12130000 {
 		compatible = "samsung,exynos5250-usb2phy";
 		reg = <0x12130000 0x100>;
-- 
1.7.6.5

