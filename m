Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3KYKDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:03:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46461 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3KYKC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:02:56 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v3 06/10] Documentation: dt bindings: move ..usb/usb-phy.txt to ..phy/ti-phy.txt
Date: Mon, 25 Nov 2013 15:31:26 +0530
Message-ID: <1385373690-12170-7-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385373690-12170-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since now we have a separate folder for phy, move the PHY dt binding
documentation of TI to that folder.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/{usb/usb-phy.txt => phy/ti-phy.txt}    |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
 rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/ti-phy.txt} (88%)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
similarity index 88%
rename from Documentation/devicetree/bindings/usb/usb-phy.txt
rename to Documentation/devicetree/bindings/phy/ti-phy.txt
index c0245c8..207e14c 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -1,4 +1,4 @@
-USB PHY
+TI PHY: DT DOCUMENTATION FOR PHYs in TI PLATFORMs
 
 OMAP USB2 PHY
 
@@ -21,10 +21,10 @@ usb2phy@4a0ad080 {
 	#phy-cells = <0>;
 };
 
-OMAP USB3 PHY
+TI PIPE3 PHY
 
 Required properties:
- - compatible: Should be "ti,omap-usb3"
+ - compatible: Should be "ti,phy-usb3". "ti,omap-usb3" is deprecated.
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
@@ -38,7 +38,7 @@ Optional properties:
 This is usually a subnode of ocp2scp to which it is connected.
 
 usb3phy@4a084400 {
-	compatible = "ti,omap-usb3";
+	compatible = "ti,phy-usb3";
 	reg = <0x4a084400 0x80>,
 	      <0x4a084800 0x64>,
 	      <0x4a084c00 0x40>;
-- 
1.7.10.4

