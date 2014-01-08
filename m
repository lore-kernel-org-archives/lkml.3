Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaAHGQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:16:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52038 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaAHGQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:16:23 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 2/5] ARM: dts: OMAP5: Add 60MHz clock reference to USB Host module
Date: Wed, 8 Jan 2014 11:45:39 +0530
Message-ID: <1389161742-10533-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389161742-10533-1-git-send-email-rogerq@ti.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB Host driver (drivers/mfd/omap-usb-host.c) expects the 60MHz
reference clock to be named "init_60m_fclk". Provide this
information.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 2f12a47..e0ab379 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -765,6 +765,8 @@
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
+			clocks = <&l3init_60m_fclk>;
+			clock-names = "init_60m_fclk";
 
 			usbhsohci: ohci@4a064800 {
 				compatible = "ti,ohci-omap3", "usb-ohci";
-- 
1.8.3.2

