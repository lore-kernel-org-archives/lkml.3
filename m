Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab3AXGxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:53:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38477 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3AXGxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:53:08 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <hvaibhav@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH] mtd: devices: elm: Removes <xx> literals in elm DT node
Date: Thu, 24 Jan 2013 12:23:30 +0530
Message-ID: <9580c5839ea64e09ddd61610ce922d7cd1adc861.1359010256.git.avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of removing generalized dependency, replace <xx> literal fields
in DT compatible field with <52> for am335x platforms.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 Documentation/devicetree/bindings/mtd/elm.txt |    2 +-
 drivers/mtd/devices/elm.c                     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mtd/elm.txt b/Documentation/devicetree/bindings/mtd/elm.txt
index e43c668..8c1528c 100644
--- a/Documentation/devicetree/bindings/mtd/elm.txt
+++ b/Documentation/devicetree/bindings/mtd/elm.txt
@@ -10,7 +10,7 @@ Optional properties:
 
 Example:
 elm: elm@0 {
-	compatible	= "ti,am33xx-elm";
+	compatible = "ti,am3352-elm";
 	reg = <0x48080000 0x2000>;
 	interrupts = <4>;
 };
diff --git a/drivers/mtd/devices/elm.c b/drivers/mtd/devices/elm.c
index f78f43f..f034239 100644
--- a/drivers/mtd/devices/elm.c
+++ b/drivers/mtd/devices/elm.c
@@ -381,7 +381,7 @@ static int elm_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 static const struct of_device_id elm_of_match[] = {
-	{ .compatible = "ti,am33xx-elm" },
+	{ .compatible = "ti,am3352-elm" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, elm_of_match);
-- 
1.7.9.5

