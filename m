Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBISsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:45 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62425 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaBISsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:42 -0500
From: Richard Weinberger <richard@nod.at>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org (open list:USB GADGET/PERIPH...),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 23/28] Remove MACH_OMAP_H4_OTG
Date: Sun,  9 Feb 2014 19:48:01 +0100
Message-Id: <1391971686-9517-24-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/usb/gadget/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 8154165..42f017a 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -226,7 +226,7 @@ config USB_GR_UDC
 config USB_OMAP
 	tristate "OMAP USB Device Controller"
 	depends on ARCH_OMAP1
-	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
+	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	help
 	   Many Texas Instruments OMAP processors have flexible full
 	   speed USB device controllers, with support for up to 30
-- 
1.8.4.2

