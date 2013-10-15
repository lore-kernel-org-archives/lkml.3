Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab3JOT55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:57:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45583 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759558Ab3JOTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:55:30 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH v2 3/7] Documentation: dt bindings: move ..usb/usb-phy.txt to ..phy/ti-phy.txt
Date: Wed, 16 Oct 2013 01:24:13 +0530
Message-ID: <1381866857-3861-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1381866857-3861-1-git-send-email-kishon@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have a separate folder for phy, move the PHY dt binding
documentation of TI to that folder.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/{usb/usb-phy.txt => phy/ti-phy.txt}   |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/ti-phy.txt} (86%)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
similarity index 86%
rename from Documentation/devicetree/bindings/usb/usb-phy.txt
rename to Documentation/devicetree/bindings/phy/ti-phy.txt
index c0245c8..355acf0 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -1,4 +1,4 @@
-USB PHY
+TI PHY: DT DOCUMENTATION FOR PHYs in TI PLATFORMs
 
 OMAP USB2 PHY
 
@@ -21,10 +21,11 @@ usb2phy@4a0ad080 {
 	#phy-cells = <0>;
 };
 
-OMAP USB3 PHY
+TI PIPE3 PHY
 
 Required properties:
- - compatible: Should be "ti,omap-usb3"
+ - compatible: Should be "ti,phy-usb3", "ti,phy-pcie" or "ti,phy-sata".
+   "ti,omap-usb3" is deprecated.
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
@@ -38,7 +39,7 @@ Optional properties:
 This is usually a subnode of ocp2scp to which it is connected.
 
 usb3phy@4a084400 {
-	compatible = "ti,omap-usb3";
+	compatible = "ti,phy-usb3";
 	reg = <0x4a084400 0x80>,
 	      <0x4a084800 0x64>,
 	      <0x4a084c00 0x40>;
-- 
1.7.10.4

