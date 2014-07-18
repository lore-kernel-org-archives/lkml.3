Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbaGRNly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:41:54 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17630 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934818AbaGRNMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bernd Wachter <bernd.wachter@jolla.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 127/170] usb: option: Add ID for Telewell TW-LTE 4G v2
Date: Fri, 18 Jul 2014 14:12:12 +0200
Message-Id: <b56ef44a38aa8725cdd328c0c3c2b4d3dbb54b56.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Wachter <bernd.wachter@jolla.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3d28bd840b2d3981cd28caf5fe1df38f1344dd60 upstream.

Add ID of the Telewell 4G v2 hardware to option driver to get legacy
serial interface working

Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index e25e8ca09fe2..9da566a3f5c8 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1487,6 +1487,8 @@ static const struct usb_device_id option_ids[] = {
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1426, 0xff, 0xff, 0xff),  /* ZTE MF91 */
 		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
+	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1428, 0xff, 0xff, 0xff),  /* Telewell TW-LTE 4G v2 */
+		.driver_info = (kernel_ulong_t)&net_intf2_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1533, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1534, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x1535, 0xff, 0xff, 0xff) },
-- 
2.0.0

