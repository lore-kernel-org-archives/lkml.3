Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab3AONfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:35:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:31638 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab3AONe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:34:59 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-53-50f55b02e6eb
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com
Subject: [PATCH v4 4/4] ARM: Exynos5250: Enabling dwc3-exynos driver
Date: Tue, 15 Jan 2013 19:08:32 +0530
Message-id: <1358257112-19595-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWyRsSkVpcp+muAwYnV+haXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZZy49Yi14LNAxdo5h5gbGG/zdjFyckgImEgc
	Od7PCmGLSVy4t56ti5GLQ0hgKaPE4ucHWWCKDpx5wQyRWMQosaPrPhOEM5lJ4vmhQ2DtbAK6
	Ek1vdzGC2CICqhKf2xawg9jMAocYJU5NdQexhQVcJDa/2c8EYrMA1Sz7OxPM5hXwkNh88gvU
	GQoSb24/A9rGwcEp4CnxYKoXiCkEVDJjsTNEp4DEt8mHWEDCEgKyEpsOgJ0mIXCfTeLGL5hn
	JCUOrrjBMoFReAEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MwKA8/e+Z1A7GlQ0WhxgF
	OBiVeHhv6n4JEGJNLCuuzAU6nYNZSYRXw+hrgBBvSmJlVWpRfnxRaU5q8SFGH6BLJjJLiSbn
	AyMmryTe0NjE3NTY1NLIyMzUFIewkjgv46knAUIC6YklqdmpqQWpRTDjmDg4pRoYLT5kfUoW
	jU53F2u6KlJ0Ss2TIS7nySbpyI1/b5gpsgYbSaUaPtF10WGecaV84kvh2K4Ug1/Z9nxpS88H
	/951b0W8z7Fcm1bphTNik7MnrrOqts7z+TXtwXnLvsNfgr9Mv8h+qcXSc8GFVfWTGw1V/rE6
	HT81o+HarP0KD16df8+w7bHNjOxMJZbijERDLeai4kQAFKQ9h3cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAV2m6K8BBtt7VS0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4cesR
	a8FngYq1cw4xNzDe5u1i5OSQEDCROHDmBTOELSZx4d56ti5GLg4hgUWMEju67jNBOJOZJJ4f
	OsQKUsUmoCvR9HYXI4gtIqAq8bltATuIzSxwiFHi1FR3EFtYwEVi85v9TCA2C1DNsr8zwWxe
	AQ+JzSe/sEJsU5B4c/sZ0GYODk4BT4kHU71ATCGgkhmLnScw8i5gZFjFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERzyz6R2MK5ssDjEKMDBqMTDe1P3S4AQa2JZcWUu0CkczEoivBpGXwOE
	eFMSK6tSi/Lji0pzUosPMfoA3TSRWUo0OR8Yj3kl8YbGJuamxqaWJhYmZpY4hJXEeRlPPQkQ
	EkhPLEnNTk0tSC2CGcfEwSnVwLhxnqJnPsOhsP3Cxy5610409570a13KrDkanan2Lp+e5zZr
	shhIWq84yaZctPmrzCX+6Y0Cy881O2dO7dz98fTp2sk7mi+96o6V+sex/N7JfrkorpqDfbVn
	TObafbq70lTKPbmyaNOc5SrRAbfcxD67enlOlGxZuW4n323WQp5TrbwNLG46nkosxRmJhlrM
	RcWJAEN4oAKmAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding DWC3 device tree node for Exynos5250 needed to
parse device tree data.
Also enabling XHCI support on exynos5250.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 .../devicetree/bindings/usb/exynos-usb.txt         |   14 ++++++++++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |    6 ++++++
 arch/arm/mach-exynos/Kconfig                       |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt b/Documentation/devicetree/bindings/usb/exynos-usb.txt
index f66fcdd..d660410 100644
--- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
+++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
@@ -38,3 +38,17 @@ Example:
 		reg = <0x12120000 0x100>;
 		interrupts = <0 71 0>;
 	};
+
+DWC3
+Required properties:
+ - compatible: should be "samsung,exynos5250-dwc3" for USB 3.0 DWC3 controller.
+ - reg: physical base address of the controller and length of memory mapped
+   region.
+ - interrupts: interrupt number to the cpu.
+
+Example:
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwc3";
+		reg = <0x12000000 0x10000>;
+		interrupts = <0 72 0>;
+	};
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index ebb0907..a747524 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -275,6 +275,12 @@
 		#size-cells = <0>;
 	};
 
+	usb@12000000 {
+		compatible = "samsung,exynos5250-dwc3";
+		reg = <0x12000000 0x10000>;
+		interrupts = <0 72 0>;
+	};
+
 	usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index d26c9f9..e62fd20 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -428,6 +428,7 @@ config MACH_EXYNOS5_DT
 	depends on ARCH_EXYNOS5
 	select ARM_AMBA
 	select USE_OF
+	select USB_ARCH_HAS_XHCI
 	help
 	  Machine support for Samsung EXYNOS5 machine with device tree enabled.
 	  Select this if a fdt blob is available for the EXYNOS5 SoC based board.
-- 
1.7.6.5

