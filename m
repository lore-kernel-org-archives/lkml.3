Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaKFEss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:48:48 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:53500 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKFEsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:48:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sA64mAxE012742, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 3/3] r8152: remove the definitions of the PID
Date: Thu, 6 Nov 2014 12:47:40 +0800
Message-ID: <1394712342-15778-87-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-84-Taiwan-albertk@realtek.com>
References: <1394712342-15778-84-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PIDs are only used in the id table, so the definitions are
unnacessary. Remove them wouldn't have confusion.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index cf1b8a7..66b139a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -461,11 +461,7 @@ enum rtl8152_flags {
 
 /* Define these values to match your device */
 #define VENDOR_ID_REALTEK		0x0bda
-#define PRODUCT_ID_RTL8152		0x8152
-#define PRODUCT_ID_RTL8153		0x8153
-
 #define VENDOR_ID_SAMSUNG		0x04e8
-#define PRODUCT_ID_SAMSUNG		0xa101
 
 #define MCU_TYPE_PLA			0x0100
 #define MCU_TYPE_USB			0x0000
@@ -3898,9 +3894,9 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 
 /* table of devices that work with this driver */
 static struct usb_device_id rtl8152_table[] = {
-	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8152)},
-	{USB_DEVICE(VENDOR_ID_REALTEK, PRODUCT_ID_RTL8153)},
-	{USB_DEVICE(VENDOR_ID_SAMSUNG, PRODUCT_ID_SAMSUNG)},
+	{USB_DEVICE(VENDOR_ID_REALTEK, 0x8152)},
+	{USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
+	{USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
 	{}
 };
 
-- 
1.9.3

