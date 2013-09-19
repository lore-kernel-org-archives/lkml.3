Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3ISRWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:22:14 -0400
Received: from outbound-smtp06.blacknight.com ([81.17.249.39]:49929 "EHLO
	outbound-smtp06.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab3ISRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:22:13 -0400
From: "Ken O'Brien" <kernel@kenobrien.org>
To: marcel@holtmann.org, gustavo@padovan.org, johan.hedberg@gmail.com
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH] bluetooth: btusb: Added support for Belkin F8065bf usb bluetooth device
Date: Thu, 19 Sep 2013 18:21:57 +0100
Message-Id: <1379611317-3106-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Belkin bluetooth device's usb device id added to generic usb bluetooth driver.

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/bluetooth/btusb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 8e16f0a..117b90c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -111,6 +111,9 @@ static struct usb_device_id btusb_table[] = {
 
 	/*Broadcom devices with vendor specific id */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },
+
+	/* Belkin F8T065bf */
+	{ USB_DEVICE(0x050d, 0x065a) },
 
 	{ }	/* Terminating entry */
 };
-- 
1.8.1.4

