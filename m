Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaEIKJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:09:16 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55379 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752174AbaEIKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:15 -0400
X-Sasl-enc: 1DS1ZPaio8uhWBdDzgGRagt8UVsmq/wKKP1BVbpkyDNf 1399630154
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 01/10] staging: gdm72xx: Remove unnecessary extern declarations from header files
Date: Fri,  9 May 2014 18:08:20 +0800
Message-Id: <1399630109-18701-1-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch.pl issue:

CHECK: extern prototypes should be avoided in .h files

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

