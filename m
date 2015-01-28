Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965507AbbA1Elj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:41:39 -0500
Received: from mail.kernel.org ([198.145.29.136]:40646 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965075AbbA1EYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:17 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 127/177] USB: cdc-acm: add device id for GW Instek AFG-2225
Date: Wed, 28 Jan 2015 12:09:45 +0800
Message-Id: <1422418236-12852-218-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit cf84a691a61606a2e7269907d3727e2d9fa148ee upstream.

Add device-id entry for GW Instek AFG-2225, which has a byte swapped
bInterfaceSubClass (0x20).

Reported-by: Karl Palsson <karlp@tweak.net.au>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/class/cdc-acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 2f2540f..ec5f66e 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1601,6 +1601,7 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x2184, 0x001c) },	/* GW Instek AFG-2225 */
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
 	/* Motorola H24 HSPA module: */
-- 
1.9.1

