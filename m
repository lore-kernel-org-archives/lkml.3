Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3HWH4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:56:54 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51101 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3HWH4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:56:38 -0400
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: gregkh@linuxfoundation.org, oliver@neukum.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Enrico Mioso <mrkiko.rs@gmail.com>
Subject: [PATCH RESEND V3 net-next 3/3] net: cdc_ncm: remove non-standard NCM device IDs
Date: Fri, 23 Aug 2013 09:56:30 +0200
Message-Id: <1377244590-8558-4-git-send-email-mrkiko.rs@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1377244590-8558-1-git-send-email-mrkiko.rs@gmail.com>
References: <mrkiko.rs@gmail.com>
 <1377244590-8558-1-git-send-email-mrkiko.rs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove device IDs of NCM-like (but not NCM-conformant) devices, that are
handled by the huawwei_cdc_ncm driver now.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
---
 drivers/net/usb/cdc_ncm.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 62686be..31f43f7 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1236,17 +1236,6 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
-	/* Huawei NCM devices disguised as vendor specific */
-	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x16),
-	  .driver_info = (unsigned long)&wwan_info,
-	},
-	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x46),
-	  .driver_info = (unsigned long)&wwan_info,
-	},
-	{ USB_VENDOR_AND_INTERFACE_INFO(0x12d1, 0xff, 0x02, 0x76),
-	  .driver_info = (unsigned long)&wwan_info,
-	},
-
 	/* Infineon(now Intel) HSPA Modem platform */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1519, 0x0443,
 		USB_CLASS_COMM,
-- 
1.7.10.4

