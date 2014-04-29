Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaD2CGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:06:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42951 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbaD2CGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:06:07 -0400
X-Sasl-enc: PhRYLfOyZjBOwCA3t58086oCuUrwzoQD6jjlL4nQjlur 1398737166
Message-ID: <535F08EC.10701@fastmail.fm>
Date: Tue, 29 Apr 2014 10:05:32 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/10] staging: gdm72xx: Removed unnecessary extern declarations
 from header files
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Removed unnecessary extern declarations from header files

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
---
 drivers/staging/gdm72xx/gdm_wimax.h | 6 +++---
 drivers/staging/gdm72xx/sdio_boot.h | 2 +-
 drivers/staging/gdm72xx/usb_boot.h  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 1fcfc85..3013bdb 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -64,8 +64,8 @@ struct nic {
 
 /*#define LOOPBACK_TEST */
 
-extern int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev);
-extern int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev);
-extern void unregister_wimax_device(struct phy_dev *phy_dev);
+int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev);
+int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev);
+void unregister_wimax_device(struct phy_dev *phy_dev);
 
 #endif
diff --git a/drivers/staging/gdm72xx/sdio_boot.h b/drivers/staging/gdm72xx/sdio_boot.h
index 373ac28..045c1f4 100644
--- a/drivers/staging/gdm72xx/sdio_boot.h
+++ b/drivers/staging/gdm72xx/sdio_boot.h
@@ -16,6 +16,6 @@
 
 struct sdio_func;
 
-extern int sdio_boot(struct sdio_func *func);
+int sdio_boot(struct sdio_func *func);
 
 #endif /* __SDIO_BOOT_H__ */
diff --git a/drivers/staging/gdm72xx/usb_boot.h b/drivers/staging/gdm72xx/usb_boot.h
index c715cd3..05308e2 100644
--- a/drivers/staging/gdm72xx/usb_boot.h
+++ b/drivers/staging/gdm72xx/usb_boot.h
@@ -16,7 +16,7 @@
 
 struct usb_device;
 
-extern int usb_boot(struct usb_device *usbdev, u16 pid);
-extern int usb_emergency(struct usb_device *usbdev);
+int usb_boot(struct usb_device *usbdev, u16 pid);
+int usb_emergency(struct usb_device *usbdev);
 
 #endif /* __USB_BOOT_H__ */
-- 
1.8.4

