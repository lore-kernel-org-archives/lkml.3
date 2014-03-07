Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaCGKP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:15:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53180 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGKPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:15:48 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <george.cherian@ti.com>, <balajitk@ti.com>,
        <hdegoede@redhat.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v3 3/8] phy: ti-pipe3: Add SATA compatible to Documentation binding
Date: Fri, 7 Mar 2014 12:15:03 +0200
Message-ID: <1394187308-19622-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394187308-19622-1-git-send-email-rogerq@ti.com>
References: <1394187308-19622-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SATA PHY needs a new compatible ID. Add it to the DT binding documentation.

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index 96ba29e..4ab9cb1 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -53,7 +53,8 @@ usb2phy@4a0ad080 {
 TI PIPE3 PHY
 
 Required properties:
- - compatible: Should be "ti,phy-usb3". "ti,omap-usb3" is deprecated.
+ - compatible: Should be "ti,phy-usb3" or "ti,phy-pipe3-sata".
+   "ti,omap-usb3" is deprecated.
  - reg : Address and length of the register set for the device.
  - reg-names: The names of the register addresses corresponding to the registers
    filled in "reg".
-- 
1.8.3.2

