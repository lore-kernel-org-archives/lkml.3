Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3JEQLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:11:22 -0400
Received: from libra.uberspace.de ([95.143.172.171]:45211 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab3JEQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:11:17 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 2/5] drivers: usb: core: hcd: Whitespace fixes
Date: Sat,  5 Oct 2013 18:02:07 +0200
Message-Id: <e5dba9e89cd8c98d7d2f2578b72482ccf0a4ea88.1380986962.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

including
- spaces to tabs
- removing spaces before array indexing (foo [] to foo[])
- adding spaces around unary operator (foo? 1 : 0 to foo ? 1 : 0)
- removed trailing whitespace

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hcd.c | 56 +++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 9036794..0f3e5a0 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -6,7 +6,7 @@
  * (C) Copyright Deti Fliegl 1999
  * (C) Copyright Randy Dunlap 2000
  * (C) Copyright David Brownell 2000-2002
- * 
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
  * Free Software Foundation; either version 2 of the License, or (at your
@@ -93,7 +93,7 @@ EXPORT_SYMBOL_GPL (usb_bus_list);
 /* used when allocating bus numbers */
 #define USB_MAXBUS		64
 struct usb_busmap {
-	unsigned long busmap [USB_MAXBUS / (8*sizeof (unsigned long))];
+	unsigned long busmap[USB_MAXBUS / (8*sizeof (unsigned long))];
 };
 static struct usb_busmap busmap;
 
@@ -171,7 +171,7 @@ static const u8 usb25_rh_dev_descriptor[18] = {
 };
 
 /* usb 2.0 root hub device descriptor */
-static const u8 usb2_rh_dev_descriptor [18] = {
+static const u8 usb2_rh_dev_descriptor[18] = {
 	0x12,       /*  __u8  bLength; */
 	0x01,       /*  __u8  bDescriptorType; Device */
 	0x00, 0x02, /*  __le16 bcdUSB; v2.0 */
@@ -194,7 +194,7 @@ static const u8 usb2_rh_dev_descriptor [18] = {
 /* no usb 2.0 root hub "device qualifier" descriptor: one speed only */
 
 /* usb 1.1 root hub device descriptor */
-static const u8 usb11_rh_dev_descriptor [18] = {
+static const u8 usb11_rh_dev_descriptor[18] = {
 	0x12,       /*  __u8  bLength; */
 	0x01,       /*  __u8  bDescriptorType; Device */
 	0x10, 0x01, /*  __le16 bcdUSB; v1.1 */
@@ -219,7 +219,7 @@ static const u8 usb11_rh_dev_descriptor [18] = {
 
 /* Configuration descriptors for our root hubs */
 
-static const u8 fs_rh_config_descriptor [] = {
+static const u8 fs_rh_config_descriptor[] = {
 
 	/* one configuration */
 	0x09,       /*  __u8  bLength; */
@@ -228,13 +228,13 @@ static const u8 fs_rh_config_descriptor [] = {
 	0x01,       /*  __u8  bNumInterfaces; (1) */
 	0x01,       /*  __u8  bConfigurationValue; */
 	0x00,       /*  __u8  iConfiguration; */
-	0xc0,       /*  __u8  bmAttributes; 
+	0xc0,       /*  __u8  bmAttributes;
 				 Bit 7: must be set,
 				     6: Self-powered,
 				     5: Remote wakeup,
 				     4..0: resvd */
 	0x00,       /*  __u8  MaxPower; */
-      
+
 	/* USB 1.1:
 	 * USB 2.0, single TT organization (mandatory):
 	 *	one interface, protocol 0
@@ -256,17 +256,17 @@ static const u8 fs_rh_config_descriptor [] = {
 	0x00,       /*  __u8  if_bInterfaceSubClass; */
 	0x00,       /*  __u8  if_bInterfaceProtocol; [usb1.1 or single tt] */
 	0x00,       /*  __u8  if_iInterface; */
-     
+
 	/* one endpoint (status change endpoint) */
 	0x07,       /*  __u8  ep_bLength; */
 	0x05,       /*  __u8  ep_bDescriptorType; Endpoint */
 	0x81,       /*  __u8  ep_bEndpointAddress; IN Endpoint 1 */
- 	0x03,       /*  __u8  ep_bmAttributes; Interrupt */
- 	0x02, 0x00, /*  __le16 ep_wMaxPacketSize; 1 + (MAX_ROOT_PORTS / 8) */
+	0x03,       /*  __u8  ep_bmAttributes; Interrupt */
+	0x02, 0x00, /*  __le16 ep_wMaxPacketSize; 1 + (MAX_ROOT_PORTS / 8) */
 	0xff        /*  __u8  ep_bInterval; (255ms -- usb 2.0 spec) */
 };
 
-static const u8 hs_rh_config_descriptor [] = {
+static const u8 hs_rh_config_descriptor[] = {
 
 	/* one configuration */
 	0x09,       /*  __u8  bLength; */
@@ -275,13 +275,13 @@ static const u8 hs_rh_config_descriptor [] = {
 	0x01,       /*  __u8  bNumInterfaces; (1) */
 	0x01,       /*  __u8  bConfigurationValue; */
 	0x00,       /*  __u8  iConfiguration; */
-	0xc0,       /*  __u8  bmAttributes; 
+	0xc0,       /*  __u8  bmAttributes;
 				 Bit 7: must be set,
 				     6: Self-powered,
 				     5: Remote wakeup,
 				     4..0: resvd */
 	0x00,       /*  __u8  MaxPower; */
-      
+
 	/* USB 1.1:
 	 * USB 2.0, single TT organization (mandatory):
 	 *	one interface, protocol 0
@@ -303,12 +303,12 @@ static const u8 hs_rh_config_descriptor [] = {
 	0x00,       /*  __u8  if_bInterfaceSubClass; */
 	0x00,       /*  __u8  if_bInterfaceProtocol; [usb1.1 or single tt] */
 	0x00,       /*  __u8  if_iInterface; */
-     
+
 	/* one endpoint (status change endpoint) */
 	0x07,       /*  __u8  ep_bLength; */
 	0x05,       /*  __u8  ep_bDescriptorType; Endpoint */
 	0x81,       /*  __u8  ep_bEndpointAddress; IN Endpoint 1 */
- 	0x03,       /*  __u8  ep_bmAttributes; Interrupt */
+	0x03,       /*  __u8  ep_bmAttributes; Interrupt */
 		    /* __le16 ep_wMaxPacketSize; 1 + (MAX_ROOT_PORTS / 8)
 		     * see hub.c:hub_configure() for details. */
 	(USB_MAXCHILDREN + 1 + 7) / 8, 0x00,
@@ -464,7 +464,7 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 {
 	struct usb_ctrlrequest *cmd;
- 	u16		typeReq, wValue, wIndex, wLength;
+	u16		typeReq, wValue, wIndex, wLength;
 	u8		*ubuf = urb->transfer_buffer;
 	unsigned	len = 0;
 	int		status;
@@ -526,10 +526,10 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 	 */
 
 	case DeviceRequest | USB_REQ_GET_STATUS:
-		tbuf [0] = (device_may_wakeup(&hcd->self.root_hub->dev)
+		tbuf[0] = (device_may_wakeup(&hcd->self.root_hub->dev)
 					<< USB_DEVICE_REMOTE_WAKEUP)
 				| (1 << USB_DEVICE_SELF_POWERED);
-		tbuf [1] = 0;
+		tbuf[1] = 0;
 		len = 2;
 		break;
 	case DeviceOutRequest | USB_REQ_CLEAR_FEATURE:
@@ -546,7 +546,7 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 			goto error;
 		break;
 	case DeviceRequest | USB_REQ_GET_CONFIGURATION:
-		tbuf [0] = 1;
+		tbuf[0] = 1;
 		len = 1;
 			/* FALLTHROUGH */
 	case DeviceOutRequest | USB_REQ_SET_CONFIGURATION:
@@ -609,7 +609,7 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 		}
 		break;
 	case DeviceRequest | USB_REQ_GET_INTERFACE:
-		tbuf [0] = 0;
+		tbuf[0] = 0;
 		len = 1;
 			/* FALLTHROUGH */
 	case DeviceOutRequest | USB_REQ_SET_INTERFACE:
@@ -626,8 +626,8 @@ static int rh_call_control (struct usb_hcd *hcd, struct urb *urb)
 
 	case EndpointRequest | USB_REQ_GET_STATUS:
 		// ENDPOINT_HALT flag
-		tbuf [0] = 0;
-		tbuf [1] = 0;
+		tbuf[0] = 0;
+		tbuf[1] = 0;
 		len = 2;
 			/* FALLTHROUGH */
 	case EndpointOutRequest | USB_REQ_CLEAR_FEATURE:
@@ -877,7 +877,7 @@ static ssize_t authorized_default_store(struct device *dev,
 	usb_hcd = bus_to_hcd(usb_bus);
 	result = sscanf(buf, "%u\n", &val);
 	if (result == 1) {
-		usb_hcd->authorized_default = val? 1 : 0;
+		usb_hcd->authorized_default = val ? 1 : 0;
 		result = size;
 	}
 	else
@@ -1812,7 +1812,7 @@ rescan:
 				 case USB_ENDPOINT_XFER_INT:
 					s = "-intr"; break;
 				 default:
-			 		s = "-iso"; break;
+					s = "-iso"; break;
 				};
 				s;
 			}));
@@ -2245,7 +2245,7 @@ static void hcd_resume_work(struct work_struct *work)
 }
 
 /**
- * usb_hcd_resume_root_hub - called by HCD to resume its root hub 
+ * usb_hcd_resume_root_hub - called by HCD to resume its root hub
  * @hcd: host controller for this root hub
  *
  * The USB host controller calls this function when its root hub is
@@ -2600,7 +2600,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 
 	/* Keep old behaviour if authorized_default is not in [0, 1]. */
 	if (authorized_default < 0 || authorized_default > 1)
-		hcd->authorized_default = hcd->wireless? 0 : 1;
+		hcd->authorized_default = hcd->wireless ? 0 : 1;
 	else
 		hcd->authorized_default = authorized_default;
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
@@ -2743,7 +2743,7 @@ err_allocate_root_hub:
 err_register_bus:
 	hcd_buffer_destroy(hcd);
 	return retval;
-} 
+}
 EXPORT_SYMBOL_GPL(usb_add_hcd);
 
 /**
@@ -2840,7 +2840,7 @@ struct usb_mon_operations *mon_ops;
  * Notice that the code is minimally error-proof. Because usbmon needs
  * symbols from usbcore, usbcore gets referenced and cannot be unloaded first.
  */
- 
+
 int usb_mon_register (struct usb_mon_operations *ops)
 {
 
-- 
1.8.4

