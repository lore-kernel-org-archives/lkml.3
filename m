Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbaHHUvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:51:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbaHHUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bernd Wachter <bernd.wachter@jolla.com>, Johan Hovold <johan@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 075/259] usb: option: Add ID for Telewell TW-LTE 4G v2
Date: Fri,  8 Aug 2014 13:38:18 -0700
Message-Id: <1407530482-4483-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Wachter <bernd.wachter@jolla.com>

commit 3d28bd840b2d3981cd28caf5fe1df38f1344dd60 upstream.

Add ID of the Telewell 4G v2 hardware to option driver to get legacy
serial interface working

Signed-off-by: Bernd Wachter <bernd.wachter@jolla.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 7438f67..04d3eef 100644
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
1.9.1

