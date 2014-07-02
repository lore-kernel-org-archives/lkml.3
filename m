Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaGBJg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:36:58 -0400
Received: from smtp129.dfw.emailsrvr.com ([67.192.241.129]:55760 "EHLO
	smtp129.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBJg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:36:57 -0400
X-Broken-By: aardmail-smtpc (http://bwachter.lart.info/projects/aardmail/)
From: Bernd Wachter <bernd.wachter@jolla.com>
To: linux-usb@vger.kernel.org
Subject: [PATCH] usb: option: Add ID for Telewell TW-LTE 4G v2
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
CC: linux-kernel@vger.kernel.org
X-use-pgp: no
X-personality: jolla
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Date: Wed, 02 Jul 2014 12:36:48 +0300
Message-ID: <87ha30yudr.fsf@bwachter.lart.info>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add ID of the Telewell 4G v2 hardware to option driver to get legacy
serial interface working


Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>
---
--- linux-3.15.3/drivers/usb/serial/option.c.orig	2014-07-02 12:23:28.000000000 +0300
+++ linux-3.15.3/drivers/usb/serial/option.c	2014-07-02 12:25:16.000000000 +0300
@@ -1480,6 +1480,8 @@ static const struct usb_device_id option
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1426, 0xff, 0xff, 0xff),  /* ZTE MF91 */
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1428, 0xff, 0xff, 0xff),  /* Telewell TW-LTE 4G v2 */
+		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },

