Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaKYKk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKYKkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 015/254] USB: cdc-acm: add device id for GW Instek AFG-2225
Date: Tue, 25 Nov 2014 10:36:05 +0000
Message-Id: <1416912004-5928-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit cf84a691a61606a2e7269907d3727e2d9fa148ee upstream.

Add device-id entry for GW Instek AFG-2225, which has a byte swapped
bInterfaceSubClass (0x20).

Reported-by: Karl Palsson <karlp@tweak.net.au>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e934e19f49f5..959343b891c7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1681,6 +1681,7 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x2184, 0x001c) },	/* GW Instek AFG-2225 */
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
 	/* Motorola H24 HSPA module: */
-- 
2.1.0

