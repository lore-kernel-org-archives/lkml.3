Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaBTLoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:44:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42442 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbaBTLlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:41:24 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v8 13/14] ARM: dts: OMAP2+: Get rid of incompatible ids for USB host nodes
Date: Thu, 20 Feb 2014 13:40:08 +0200
Message-ID: <1392896409-5101-14-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392896409-5101-1-git-send-email-rogerq@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP EHCI and OHCI controllers are not compatible with drivers
other than "ti,ehci-omap" and "ti,ohci-omap3" respectively, so get
rid of the incompatible ids.

CC: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap3.dtsi | 4 ++--
 arch/arm/boot/dts/omap4.dtsi | 4 ++--
 arch/arm/boot/dts/omap5.dtsi | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index a5fc83b..8e7de9e 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -634,14 +634,14 @@
 			ranges;
 
 			usbhsohci: ohci@48064400 {
-				compatible = "ti,ohci-omap3", "usb-ohci";
+				compatible = "ti,ohci-omap3";
 				reg = <0x48064400 0x400>;
 				interrupt-parent = <&intc>;
 				interrupts = <76>;
 			};
 
 			usbhsehci: ehci@48064800 {
-				compatible = "ti,ehci-omap", "usb-ehci";
+				compatible = "ti,ehci-omap";
 				reg = <0x48064800 0x400>;
 				interrupt-parent = <&intc>;
 				interrupts = <77>;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 39a05ce..ff1b057 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -705,14 +705,14 @@
 				      "refclk_60m_ext_p2";
 
 			usbhsohci: ohci@4a064800 {
-				compatible = "ti,ohci-omap3", "usb-ohci";
+				compatible = "ti,ohci-omap3";
 				reg = <0x4a064800 0x400>;
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 			};
 
 			usbhsehci: ehci@4a064c00 {
-				compatible = "ti,ehci-omap", "usb-ehci";
+				compatible = "ti,ehci-omap";
 				reg = <0x4a064c00 0x400>;
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index d4dae48..f65aa65 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -783,14 +783,14 @@
 				      "refclk_60m_ext_p2";
 
 			usbhsohci: ohci@4a064800 {
-				compatible = "ti,ohci-omap3", "usb-ohci";
+				compatible = "ti,ohci-omap3";
 				reg = <0x4a064800 0x400>;
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 76 IRQ_TYPE_LEVEL_HIGH>;
 			};
 
 			usbhsehci: ehci@4a064c00 {
-				compatible = "ti,ehci-omap", "usb-ehci";
+				compatible = "ti,ehci-omap";
 				reg = <0x4a064c00 0x400>;
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
-- 
1.8.3.2

