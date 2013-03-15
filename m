Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab3CONaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:30:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60983 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3CON3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:29:08 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 1/4] usb: Fix linker errors during build
Date: Fri, 15 Mar 2013 18:58:49 +0530
Message-ID: <1363354132-27523-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 63378a (usb: phy: remove CONFIG_USB_OTG_UTILS) removed
CONFIG_USB_OTG_UTILS from Kconfig but failed to removed from Makefile.
Fixed it here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 860306b..c41feba 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -44,7 +44,7 @@ obj-$(CONFIG_USB_MICROTEK)	+= image/
 obj-$(CONFIG_USB_SERIAL)	+= serial/
 
 obj-$(CONFIG_USB)		+= misc/
-obj-$(CONFIG_USB_OTG_UTILS)	+= phy/
+obj-$(CONFIG_USB_PHY)		+= phy/
 obj-$(CONFIG_EARLY_PRINTK_DBGP)	+= early/
 
 obj-$(CONFIG_USB_ATM)		+= atm/
-- 
1.7.10.4

