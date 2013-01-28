Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3A1Lcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:32:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49715 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240Ab3A1LcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:32:06 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 30/30] ARM: OMAP: USB: Remove unused fields from struct usbhs_omap_platform_data
Date: Mon, 28 Jan 2013 13:30:31 +0200
Message-ID: <1359372631-8180-31-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All users have been adapted to the changes in ehci-omap. We can now
get rid of the unused fields from usbhs_omap_platform_data.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 include/linux/platform_data/usb-omap.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
index 925a4a7..227601f 100644
--- a/include/linux/platform_data/usb-omap.h
+++ b/include/linux/platform_data/usb-omap.h
@@ -41,13 +41,10 @@ enum usbhs_omap_port_mode {
 struct usbhs_omap_platform_data {
 	int				nports;
 	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
-	int				reset_gpio_port[OMAP3_HS_USB_PORTS];
-	struct regulator		*regulator[OMAP3_HS_USB_PORTS];
 
 	/* OMAP3 <= ES2.1 have a single ulpi bypass control bit */
 	unsigned			single_ulpi_bypass:1;
 	unsigned			es2_compatibility:1;
-	unsigned			phy_reset:1;
 };
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.4.1

