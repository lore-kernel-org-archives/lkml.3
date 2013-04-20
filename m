Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3DTTUd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:20:33 -0400
Received: from p3plsmtpa11-06.prod.phx3.secureserver.net ([68.178.252.107]:55798
	"EHLO p3plsmtpa11-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154Ab3DTTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:20:03 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Apr 2013 15:20:03 EDT
From: David King <amigadave@amigadave.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        David King <amigadave@amigadave.com>
Subject: [PATCH] HID: clarify Magic Mouse KConfig description
Date: Sat, 20 Apr 2013 20:13:52 +0100
Message-Id: <1366485232-3692-1-git-send-email-amigadave@amigadave.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Magic Mouse driver also supports the Magic Trackpad, so mention it
in the KConfig description for the driver.

Signed-off-by: David King <amigadave@amigadave.com>
---
 drivers/hid/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5f07d85..a5984f0 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -373,13 +373,13 @@ config LOGIWHEELS_FF
 	  - Logitech Formula Force EX
 
 config HID_MAGICMOUSE
-	tristate "Apple MagicMouse multi-touch support"
+	tristate "Apple Magic Mouse/Trackpad multi-touch support"
 	depends on BT_HIDP
 	---help---
-	Support for the Apple Magic Mouse multi-touch.
+	Support for the Apple Magic Mouse/Trackpad multi-touch.
 
 	Say Y here if you want support for the multi-touch features of the
-	Apple Wireless "Magic" Mouse.
+	Apple Wireless "Magic" Mouse and the Apple Wireless "Magic" Trackpad.
 
 config HID_MICROSOFT
 	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
-- 
1.8.1.5

