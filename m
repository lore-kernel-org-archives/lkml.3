Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3BEM6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:58:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39709 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3BEM6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:58:35 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-8d-511101fad3b8
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
        balbi@ti.com, grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, dianders@chromium.org, p.paneri@samsung.com
Subject: [PATCH v3 1/2] ARM: Exynos5250: Enabling samsung-usb2phy driver
Date: Tue, 05 Feb 2013 18:33:53 +0530
Message-id: <1360069434-20417-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1360069434-20417-1-git-send-email-gautam.vivek@samsung.com>
References: <1360069434-20417-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkVvcXo2Cgwa1vUhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZVzYcZWtYDp7xbT57ewNjA9Yuxg5OSQETCQa
	ut4xQthiEhfurWfrYuTiEBJYyiix5mk/excjB1jRsZtqEPHpjBJH1+xggnAmM0ms+b0ArJtN
	QFei6e0uMFtEQFXic9sCdpAiZoEOJonvE1ezgySEBTwkFpycxwZiswAVnVn6lBnE5gWKT2q8
	AXWSgsSb28/A4pwCnhIf1/8CGyoEVHNo7jUWkKESAo/ZJDpfnGaFGCQg8W3yIRaIU2UlNh1g
	hpgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEBubpf8+kdjCubLA4
	xCjAwajEw/vjMn+gEGtiWXFl7iFGCQ5mJRHe6i8CgUK8KYmVValF+fFFpTmpxYcYk4GWT2SW
	Ek3OB0ZNXkm8obGJuamxqaWRkZmpKWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpgbPvw
	ZurCs7k9xes//Dzw63ON2F8tJzdn4UUbK6d7nFNNfWhZsv3uc66dE/l4V3wp17PcPP2zD8uK
	nbNXn9/996PUsSMTXsz573K5MGhb5ufkWWy+6y9VzQ5bqL7CrTN5xYp7k4/Ir/AOm6LqvreF
	77J+nVr/lYTFztKnjV9Zv+D8nbh1dST/ZGslluKMREMt5qLiRABKtRWPkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQd1fjIKBBp0HeC0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcy4sOMq
	W8F09opp89vZGxgfsHYxcnBICJhIHLup1sXICWSKSVy4t56ti5GLQ0hgOqPE0TU7mCCcyUwS
	a34vYASpYhPQlWh6uwvMFhFQlfjctoAdpIhZoINJ4vvE1ewgCWEBD4kFJ+exgdgsQEVnlj5l
	BrF5geKTGm+wQqxTkHhz+xlYnFPAU+Lj+l9gQ4WAag7NvcYygZF3ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzgsH8mtYNxZYPFIUYBDkYlHt4fl/kDhVgTy4orcw8xSnAwK4nwVn8R
	CBTiTUmsrEotyo8vKs1JLT7EmAx01URmKdHkfGBM5pXEGxqbmJsam1qaWJiYWZImrCTOy3jq
	SYCQQHpiSWp2ampBahHMFiYOTqkGxnnpHxr85qjZv1/7eUnZ9Mo7NcnJbGYTzZx4rAS2zK67
	b3JA73vNwi2f8uydDynM/W7FvyjpSbTDHeGVwb5Ry8yW/rPXOZb2P/qrcP43bRahGO0teufD
	F2V5d2+4c2B1/7Fcs+wTO08z/MjNPJHM9uVVh4vv582tHm8Vti50+OPRtPbqZ8F1UkosxRmJ
	hlrMRcWJAF1IgiS/AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding device node for Samsung USB 2.0 PHY controller driver
on Exynos5250 along with the necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 30485de..d1865a8 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -99,6 +99,19 @@
 		interrupts = <0 65 0>;
 	};
 
+	usbphy@12130000 {
+		compatible = "samsung,exynos5250-usb2phy";
+		reg = <0x12130000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			reg = <0x10040704 0x8>,
+			      <0x10050230 0x4>;
+		};
+	};
+
 	serial@12C00000 {
 		compatible = "samsung,exynos4210-uart";
 		reg = <0x12C00000 0x100>;
-- 
1.7.6.5

