Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3LDKMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:12:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20995 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3LDKJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:09:56 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-1a-529eff73e9c7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, kishon@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, t.figa@samsung.com, jwerner@chromium.org,
        k.debski@samsung.com
Subject: [PATCH v2 4/4] dt: exynos5420: Enable support for DWC3 controller
Date: Wed, 04 Dec 2013 15:39:07 +0530
Message-id: <1386151747-3209-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkRrf4/7wgg4fd3BYH79dbHJj9kNWi
	efF6NovLCy+xWnQcesxk8eP1BTaL3gVX2SwuPO1hs1jYtoTF4vKuOWwWM87vY7JYtKyV2eLw
	igNMFofftLNarJ/xmsWB32PB5yvsHrMbLrJ47J+7ht3j/IyFjB59W1Yxehy/sZ3J4/MmuQD2
	KC6blNSczLLUIn27BK6MWc2bWAsO8la0TNrA2MB4iauLkZNDQsBEonHDGnYIW0ziwr31bF2M
	XBxCAksZJX7vamGGKXq6oIsVIjGdUaK99yUjhDOFSWLOlHawKjYBXYmmt7sYQWwRgXSJ/3f7
	wWxmgZlMElM2S4LYwgJeEovffGADsVkEVCU2rjkE1ssr4C7RdH4LE8Q2BYk3t5+BxTkFPCRW
	bpwANkcIqGbXyxfMIIslBO6xSyx/upIFYpCAxLfJh4BsDqCErMSmA1BXS0ocXHGDZQKj8AJG
	hlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgbF0+t+z/h2Mdw9YH2JMBho3kVlKNDkfGIt5
	JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxkpXW
	PFn5BVeeXjl8o9o7c6m8yLvz+RfMdDx2l6mwzN19qHYuW8HFbdp3sxaVf+Sp4CrbbHXA59wB
	xwzN9jV3kljf3JGzm9axsevEWc8JXvP5+v+5Pu3yc+0yLzUNsdot7vf+RpDwwRdbyzbnsNyy
	mmV1T65lWe3849yf7kiZvrHRuBi29li5EktxRqKhFnNRcSIAg2+W2bsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xoG7x/3lBBnPlLQ7er7c4MPshq0Xz
	4vVsFpcXXmK16Dj0mMnix+sLbBa9C66yWVx42sNmsbBtCYvF5V1z2CxmnN/HZLFoWSuzxeEV
	B5gsDr9pZ7VYP+M1iwO/x4LPV9g9ZjdcZPHYP3cNu8f5GQsZPfq2rGL0OH5jO5PH501yAexR
	DYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3KymU
	JeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgzZjVvYi04yFvRMmkDYwPjJa4u
	Rk4OCQETiacLulghbDGJC/fWs3UxcnEICUxnlGjvfckI4UxhkpgzpZ0ZpIpNQFei6e0uRhBb
	RCBd4v/dfjCbWWAmk8SUzZIgtrCAl8TiNx/YQGwWAVWJjWsOgfXyCrhLNJ3fwgSxTUHize1n
	YHFOAQ+JlRsngM0RAqrZ9fIF8wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP0
	mfQOxlUNFocYBTgYlXh4EzjnBQmxJpYVV+YeYpTgYFYS4c38AxTiTUmsrEotyo8vKs1JLT7E
	mAx01URmKdHkfGAKySuJNzQ2MTc1NrU0sTAxsyRNWEmc92CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGxoaTKWyN96xf5Mn8uFZjY/PkZt4ybZENv/JnpzHbr8idt1rB5aRTwzHh6XN87d+Ynvqn
	eHe3l2XrrUOyhldmaPXfCQ9YdPhnWpq09P1YdoFrYs9WXvn+t7BI2+3fn2TeitP+sRa7T2tm
	R271n3Drt+f/czPaBD7G5yjNa559rSp/4qbKNrNjPEosxRmJhlrMRcWJANh3eCUXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for DWC3 controller present on
Exynos 5420 SoC, to enable support for USB 3.0.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   38 +++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index a88ab00..0554a68 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -313,7 +313,24 @@
 		clock-names = "mixer", "sclk_hdmi";
 	};
 
-	usbphy@12100000 {
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 366>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12000000 0x10000>;
+			interrupts = <0 72 0>;
+			phys = <&usb3_phy0>;
+			phy-names = "usb3-phy";
+		};
+	};
+
+	usb3_phy0: usbphy@12100000 {
 		compatible = "samsung,exynos5420-usb3phy";
 		reg = <0x12100000 0x100>;
 		clocks = <&clock 366>, <&clock 1>, <&clock 152>;
@@ -322,7 +339,24 @@
 		#phy-cells = <0>;
 	};
 
-	usbphy@12500000 {
+	usb@12400000 {
+		compatible = "samsung,exynos5250-dwusb3";
+		clocks = <&clock 367>;
+		clock-names = "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		dwc3 {
+			compatible = "synopsys,dwc3";
+			reg = <0x12400000 0x10000>;
+			interrupts = <0 73 0>;
+			phys = <&usb3_phy1>;
+			phy-names = "usb3-phy";
+		};
+	};
+
+	usb3_phy1: usbphy@12500000 {
 		compatible = "samsung,exynos5420-usb3phy";
 		reg = <0x12500000 0x100>;
 		clocks = <&clock 367>, <&clock 1>, <&clock 153>;
-- 
1.7.6.5

