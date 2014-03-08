Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaCHJdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 04:33:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35330 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaCHJaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 04:30:04 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/28] phy: omap-control: update dra7 and am437 usb2 bindings
Date: Sat, 8 Mar 2014 14:59:21 +0530
Message-ID: <1394270969-11851-21-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394270969-11851-1-git-send-email-kishon@ti.com>
References: <1394270969-11851-1-git-send-email-kishon@ti.com>
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
 drivers/phy/phy-omap-control.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-control.c
index 17fc200..311b4f9 100644
--- a/drivers/phy/phy-omap-control.c
+++ b/drivers/phy/phy-omap-control.c
@@ -228,11 +228,11 @@ static const struct of_device_id omap_control_phy_id_table[] = {
 		.data = &pipe3_data,
 	},
 	{
-		.compatible = "ti,control-phy-dra7usb2",
+		.compatible = "ti,control-phy-usb2-dra7",
 		.data = &dra7usb2_data,
 	},
 	{
-		.compatible = "ti,control-phy-am437usb2",
+		.compatible = "ti,control-phy-usb2-am437",
 		.data = &am437usb2_data,
 	},
 	{},
-- 
1.7.9.5

