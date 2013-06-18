Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab3FRQFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:05:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48749 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab3FRQFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:05:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Sricharan R <r.sricharan@ti.com>
Subject: [PATCH v2 3/4] ARM: dts: omap5-uevm: Provide USB Host PHY clock frequency
Date: Tue, 18 Jun 2013 19:04:46 +0300
Message-ID: <1371571487-14389-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371571487-14389-1-git-send-email-rogerq@ti.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB Host PHY clock on port 2 must be configured to 19.2MHz.
Provide this information.

CC: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 927db1e..c0ad472 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -40,6 +40,13 @@
 	hsusb2_phy: hsusb2_phy {
 		compatible = "usb-nop-xceiv";
 		reset-supply = <&hsusb2_reset>;
+	/**
+	  * FIXME
+	  * Put the right clock phandle here when available
+	  *	clocks = <&auxclk1>;
+	  *	clock-names = "main_clk";
+	  */
+		clock-frequency = <19200000>;
 	};
 
 	/* HS USB Port 3 RESET */
-- 
1.7.4.1

