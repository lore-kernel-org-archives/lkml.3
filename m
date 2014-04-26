Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaDZQhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:37:16 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59040 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaDZQhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:37:14 -0400
MIME-Version: 1.0
From: Brian Healy <healybrian@gmail.com>
Date: Sat, 26 Apr 2014 17:36:53 +0100
Message-ID: <CAGG=RuYdtfjJf5wKG92KdyKuG6AiBHp2_OSH8Wemi3yQOsouMQ@mail.gmail.com>
Subject: [PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for
 rtl28xxu driver
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Kernel 3.15-rc2 : Peak DVB-T USB tuner device ids for rtl28xxu driver

Signed-off-by: Brian Healy <healybrian<at>gmail.com>


--- drivers/media/usb/dvb-usb-v2/rtl28xxu.c.orig    2014-04-26
17:02:36.068691000 +0100
+++ drivers/media/usb/dvb-usb-v2/rtl28xxu.c    2014-04-26
17:03:11.944691000 +0100
@@ -1499,6 +1499,8 @@ static const struct usb_device_id rtl28x
         &rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
     { DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
         &rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+        { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
+                &rtl2832u_props, "Peak DVB-T USB", NULL) },

     /* RTL2832P devices: */
     { DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
