Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaCFOje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:39:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58839 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCFOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:39:30 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH v2 03/13] phy: omap-control: update dra7 and am437 usb2 bindings
Date: Thu, 6 Mar 2014 16:38:39 +0200
Message-ID: <1394116729-28811-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394116729-28811-1-git-send-email-rogerq@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dra7-usb2 and am437-usb2 bindings have not yet been used.
Change them to be more elegant.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt | 4 ++--
 drivers/phy/phy-omap-control.c                   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index 5c5b1b0..28e674b 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -9,9 +9,9 @@ Required properties:
                         e.g. USB2_PHY on OMAP5.
  "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power control
                         e.g. USB3 PHY and SATA PHY on OMAP5.
- "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY on
+ "ti,control-phy-dra7-usb2" - if it has power down register like USB2 PHY on
                         DRA7 platform.
- "ti,control-phy-am437usb2" - if it has power down register like USB2 PHY on
+ "ti,control-phy-am437-usb2" - if it has power down register like USB2 PHY on
                         AM437 platform.
  - reg : Address and length of the register set for the device. It contains
    the address of "otghs_control" for control-phy-otghs or "power" register
diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index 17fc200..a7e2d7f 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -228,11 +228,11 @@ static const struct of_device_id omap_control_phy_id_table[] = {
 		.data = &pipe3_data,
 	},
 	{
-		.compatible = "ti,control-phy-dra7usb2",
+		.compatible = "ti,control-phy-dra7-usb2",
 		.data = &dra7usb2_data,
 	},
 	{
-		.compatible = "ti,control-phy-am437usb2",
+		.compatible = "ti,control-phy-am437-usb2",
 		.data = &am437usb2_data,
 	},
 	{},
-- 
1.8.3.2

