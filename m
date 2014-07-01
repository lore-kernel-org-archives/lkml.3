Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaGAFGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:06:42 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42642 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaGAFGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:06:41 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH] staging: gdm72xx: use consistent style for header guards
Date: Mon, 30 Jun 2014 22:06:39 -0700
Message-Id: <1404191199-1893-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/gdm72xx/gdm_qos.h   | 6 +++---
 drivers/staging/gdm72xx/gdm_sdio.h  | 6 +++---
 drivers/staging/gdm72xx/gdm_usb.h   | 6 +++---
 drivers/staging/gdm72xx/gdm_wimax.h | 6 +++---
 drivers/staging/gdm72xx/hci.h       | 6 +++---
 drivers/staging/gdm72xx/netlink_k.h | 7 ++++---
 drivers/staging/gdm72xx/sdio_boot.h | 6 +++---
 drivers/staging/gdm72xx/usb_boot.h  | 6 +++---
 drivers/staging/gdm72xx/usb_ids.h   | 6 +++---
 drivers/staging/gdm72xx/wm_ioctl.h  | 7 ++++---
 10 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.h b/drivers/staging/gdm72xx/gdm_qos.h
index 8f742f3..bbc8aab 100644
--- a/drivers/staging/gdm72xx/gdm_qos.h
+++ b/drivers/staging/gdm72xx/gdm_qos.h
@@ -11,8 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#if !defined(GDM_QOS_H_20090403)
-#define GDM_QOS_H_20090403
+#ifndef __GDM72XX_GDM_QOS_H__
+#define __GDM72XX_GDM_QOS_H__
 
 #include <linux/types.h>
 #include <linux/usb.h>
@@ -71,4 +71,4 @@ void gdm_qos_release_list(void *nic_ptr);
 int gdm_qos_send_hci_pkt(struct sk_buff *skb, struct net_device *dev);
 void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size);
 
-#endif
+#endif /* __GDM72XX_GDM_QOS_H__ */
diff --git a/drivers/staging/gdm72xx/gdm_sdio.h b/drivers/staging/gdm72xx/gdm_sdio.h
index 0c0e2cb..77ad9d6 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.h
+++ b/drivers/staging/gdm72xx/gdm_sdio.h
@@ -11,8 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __GDM_SDIO_H__
-#define __GDM_SDIO_H__
+#ifndef __GDM72XX_GDM_SDIO_H__
+#define __GDM72XX_GDM_SDIO_H__
 
 #include <linux/types.h>
 #include <linux/time.h>
@@ -60,4 +60,4 @@ struct sdiowm_dev {
 	struct work_struct	ws;
 };
 
-#endif /* __GDM_SDIO_H__ */
+#endif /* __GDM72XX_GDM_SDIO_H__ */
diff --git a/drivers/staging/gdm72xx/gdm_usb.h b/drivers/staging/gdm72xx/gdm_usb.h
index 3050652..8e58a25 100644
--- a/drivers/staging/gdm72xx/gdm_usb.h
+++ b/drivers/staging/gdm72xx/gdm_usb.h
@@ -11,8 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __GDM_USB_H__
-#define __GDM_USB_H__
+#ifndef __GDM72XX_GDM_USB_H__
+#define __GDM72XX_GDM_USB_H__
 
 #include <linux/types.h>
 #include <linux/usb.h>
@@ -75,4 +75,4 @@ struct usbwm_dev {
 	int			padding;
 };
 
-#endif /* __GDM_USB_H__ */
+#endif /* __GDM72XX_GDM_USB_H__ */
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index 7e2c888..c640d2c 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -11,8 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __GDM_WIMAX_H__
-#define __GDM_WIMAX_H__
+#ifndef __GDM72XX_GDM_WIMAX_H__
+#define __GDM72XX_GDM_WIMAX_H__
 
 #include <linux/netdevice.h>
 #include <linux/types.h>
@@ -57,4 +57,4 @@ int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev);
 int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev);
 void unregister_wimax_device(struct phy_dev *phy_dev);
 
-#endif
+#endif /* __GDM72XX_GDM_WIMAX_H__ */
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index 059ba00..ff6941e 100644
--- a/drivers/staging/gdm72xx/hci.h
+++ b/drivers/staging/gdm72xx/hci.h
@@ -11,8 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef HCI_H_20080801
-#define HCI_H_20080801
+#ifndef __GDM72XX_HCI_H__
+#define __GDM72XX_HCI_H__
 
 #define HCI_HEADER_SIZE		4
 #define HCI_VALUE_OFFS		(HCI_HEADER_SIZE)
@@ -204,4 +204,4 @@ struct hci_s {
 	unsigned char  data[0];
 } __packed;
 
-#endif
+#endif /* __GDM72XX_HCI_H__ */
diff --git a/drivers/staging/gdm72xx/netlink_k.h b/drivers/staging/gdm72xx/netlink_k.h
index b6caac1..1fe7198 100644
--- a/drivers/staging/gdm72xx/netlink_k.h
+++ b/drivers/staging/gdm72xx/netlink_k.h
@@ -11,8 +11,9 @@
  * GNU General Public License for more details.
  */
 
-#if !defined(NETLINK_H_20081202)
-#define NETLINK_H_20081202
+#ifndef __GDM72XX_NETLINK_K_H__
+#define __GDM72XX_NETLINK_K_H__
+
 #include <linux/netdevice.h>
 #include <net/sock.h>
 
@@ -21,4 +22,4 @@ struct sock *netlink_init(int unit, void (*cb)(struct net_device *dev, u16 type,
 void netlink_exit(struct sock *sock);
 int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len);
 
-#endif
+#endif /* __GDM72XX_NETLINK_K_H__ */
diff --git a/drivers/staging/gdm72xx/sdio_boot.h b/drivers/staging/gdm72xx/sdio_boot.h
index 045c1f4..e0800c6 100644
--- a/drivers/staging/gdm72xx/sdio_boot.h
+++ b/drivers/staging/gdm72xx/sdio_boot.h
@@ -11,11 +11,11 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __SDIO_BOOT_H__
-#define __SDIO_BOOT_H__
+#ifndef __GDM72XX_SDIO_BOOT_H__
+#define __GDM72XX_SDIO_BOOT_H__
 
 struct sdio_func;
 
 int sdio_boot(struct sdio_func *func);
 
-#endif /* __SDIO_BOOT_H__ */
+#endif /* __GDM72XX_SDIO_BOOT_H__ */
diff --git a/drivers/staging/gdm72xx/usb_boot.h b/drivers/staging/gdm72xx/usb_boot.h
index 05308e2..5bf7190 100644
--- a/drivers/staging/gdm72xx/usb_boot.h
+++ b/drivers/staging/gdm72xx/usb_boot.h
@@ -11,12 +11,12 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __USB_BOOT_H__
-#define __USB_BOOT_H__
+#ifndef __GDM72XX_USB_BOOT_H__
+#define __GDM72XX_USB_BOOT_H__
 
 struct usb_device;
 
 int usb_boot(struct usb_device *usbdev, u16 pid);
 int usb_emergency(struct usb_device *usbdev);
 
-#endif /* __USB_BOOT_H__ */
+#endif /* __GDM72XX_USB_BOOT_H__ */
diff --git a/drivers/staging/gdm72xx/usb_ids.h b/drivers/staging/gdm72xx/usb_ids.h
index 1a61b35..8ce544d 100644
--- a/drivers/staging/gdm72xx/usb_ids.h
+++ b/drivers/staging/gdm72xx/usb_ids.h
@@ -11,8 +11,8 @@
  * GNU General Public License for more details.
  */
 
-#ifndef __USB_IDS_H__
-#define __USB_IDS_H__
+#ifndef __GDM72XX_USB_IDS_H__
+#define __GDM72XX_USB_IDS_H__
 
 /*You can replace vendor-ID as yours.*/
 #define GCT_VID			0x1076
@@ -79,4 +79,4 @@ static const struct usb_device_id id_table[] = {
 	{ }
 };
 
-#endif /* __USB_IDS_H__ */
+#endif /* __GDM72XX_USB_IDS_H__ */
diff --git a/drivers/staging/gdm72xx/wm_ioctl.h b/drivers/staging/gdm72xx/wm_ioctl.h
index d022c6c..ed8f649 100644
--- a/drivers/staging/gdm72xx/wm_ioctl.h
+++ b/drivers/staging/gdm72xx/wm_ioctl.h
@@ -11,8 +11,9 @@
  * GNU General Public License for more details.
  */
 
-#if !defined(WM_IOCTL_H_20080714)
-#define WM_IOCTL_H_20080714
+#ifndef __GDM72XX_WM_IOCTL_H__
+#define __GDM72XX_WM_IOCTL_H__
+
 #if !defined(__KERNEL__)
 #include <net/if.h>
 #endif
@@ -92,4 +93,4 @@ struct wm_req_s {
 #define ifr_name ifr_ifrn.ifrn_name
 #endif
 
-#endif
+#endif /* __GDM72XX_WM_IOCTL_H__ */
-- 
2.0.0.526.g5318336

