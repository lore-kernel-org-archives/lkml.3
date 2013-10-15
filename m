Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab3JOKiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:38:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38574 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab3JOKiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:38:06 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <tony@atomide.com>, <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 1/2] phy: omap-usb2: Sort the headers alphabetically
Date: Tue, 15 Oct 2013 16:07:42 +0530
Message-ID: <1381833463-12149-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1381833463-12149-1-git-send-email-george.cherian@ti.com>
References: <1381833463-12149-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes checking for duplicates easier while adding new #include.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/phy/phy-omap-usb2.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index bfc5c33..3e5f08c 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -16,20 +16,20 @@
  *
  */
 
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
-#include <linux/of.h>
-#include <linux/io.h>
 #include <linux/usb/omap_usb.h>
-#include <linux/usb/phy_companion.h>
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/pm_runtime.h>
-#include <linux/delay.h>
 #include <linux/usb/omap_control_usb.h>
-#include <linux/phy/phy.h>
-#include <linux/of_platform.h>
+#include <linux/usb/phy_companion.h>
 
 /**
  * omap_usb2_set_comparator - links the comparator present in the sytem with
-- 
1.8.1

