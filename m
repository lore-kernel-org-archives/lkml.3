Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbaEPNDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:03:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51870 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbaEPNDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:32 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] Documentation: dt: Add new compatible for the A31 USB Phy
Date: Fri, 16 May 2014 18:33:05 +0530
Message-ID: <1400245387-14445-11-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maxime Ripard <maxime.ripard@free-electrons.com>

Document the freshly introduced compatible for the USB phy in use in the
Allwinner A31 SoC.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/sun4i-usb-phy.txt      |   23 +++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/sun4i-usb-phy.txt b/Documentation/devicetree/bindings/phy/sun4i-usb-phy.txt
index a82361b..16528b9 100644
--- a/Documentation/devicetree/bindings/phy/sun4i-usb-phy.txt
+++ b/Documentation/devicetree/bindings/phy/sun4i-usb-phy.txt
@@ -2,15 +2,26 @@ Allwinner sun4i USB PHY
 -----------------------
 
 Required properties:
-- compatible : should be one of "allwinner,sun4i-a10-usb-phy",
-  "allwinner,sun5i-a13-usb-phy" or "allwinner,sun7i-a20-usb-phy"
+- compatible : should be one of
+  * allwinner,sun4i-a10-usb-phy
+  * allwinner,sun5i-a13-usb-phy
+  * allwinner,sun6i-a31-usb-phy
+  * allwinner,sun7i-a20-usb-phy
 - reg : a list of offset + length pairs
-- reg-names : "phy_ctrl", "pmu1" and for sun4i or sun7i "pmu2"
+- reg-names :
+  * "phy_ctrl"
+  * "pmu1"
+  * "pmu2" for sun4i, sun6i or sun7i
 - #phy-cells : from the generic phy bindings, must be 1
-- clocks : phandle + clock specifier for the phy clock
-- clock-names : "usb_phy"
+- clocks : phandle + clock specifier for the phy clocks
+- clock-names :
+  * "usb_phy" for sun4i, sun5i or sun7i
+  * "usb0_phy", "usb1_phy" and "usb2_phy" for sun6i
 - resets : a list of phandle + reset specifier pairs
-- reset-names : "usb0_reset", "usb1_reset" and for sun4i or sun7i "usb2_reset"
+- reset-names :
+  * "usb0_reset"
+  * "usb1_reset"
+  * "usb2_reset" for sun4i, sun6i or sun7i
 
 Example:
 	usbphy: phy@0x01c13400 {
-- 
1.7.9.5

