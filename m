Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaJKPYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:24:23 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33098 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaJKPYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:24:22 -0400
From: Philip Munksgaard <pmunksgaard@gmail.com>
To: johan@kernel.org
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philip Munksgaard <pmunksgaard@gmail.com>
Subject: [PATCH v2] usb: serial: Fix indentation style issue
Date: Sat, 11 Oct 2014 17:24:01 +0200
Message-Id: <1413041041-26926-1-git-send-email-pmunksgaard@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
References: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a style issue.

Signed-off-by: Philip Munksgaard <pmunksgaard@gmail.com>
---
 drivers/usb/serial/option.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d1a3f60..64ddc00 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1615,8 +1615,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
-  	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
-  	},
+	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist },
 	{ USB_DEVICE_INTERFACE_CLASS(LONGCHEER_VENDOR_ID, SPEEDUP_PRODUCT_SU9800, 0xff) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
-- 
2.1.2

