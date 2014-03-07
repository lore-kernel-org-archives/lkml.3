Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaCGFsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:48:32 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38464 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaCGFsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:48:30 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <rogerq@ti.com>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH v3] phy: omap-control: update dra7 and am437 usb2 bindings
Date: Fri, 7 Mar 2014 11:18:00 +0530
Message-ID: <1394171280-13359-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

The dra7-usb2 and am437-usb2 bindings have not yet been used.
Change them to be more elegant.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v2:
Kept only the drivers/phy part in this patch

 drivers/phy/phy-omap-control.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
1.7.9.5

