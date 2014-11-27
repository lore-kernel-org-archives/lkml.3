Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaK0Iqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:41315 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbaK0Iqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:40 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 18/91] USB: sierra: add 1199:68AA device ID
Date: Thu, 27 Nov 2014 16:42:01 +0800
Message-Id: <1417077794-9299-18-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 5b3da69285c143b7ea76b3b9f73099ff1093ab73 upstream.

This VID:PID is used for some Direct IP devices behaving
identical to the already supported 0F3D:68AA devices.

Reported-by: Lars Melin <larsm17@gmail.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/sierra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 64df565..e3ddec0 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -300,6 +300,9 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68AA, 0xFF, 0xFF, 0xFF),
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
+	},
 	/* AT&T Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
 	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
-- 
1.9.1

