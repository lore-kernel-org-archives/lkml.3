Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbbA1EOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:14:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:36934 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760645AbbA1EOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:19 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andreas Bomholtz <andreas@seluxit.com>,
        Johan Hovold <johan@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 012/177] USB: cp210x: add support for Seluxit USB dongle
Date: Wed, 28 Jan 2015 12:06:30 +0800
Message-Id: <1422418236-12852-23-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Bomholtz <andreas@seluxit.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit dee80ad12d2b1b304286a707fde7ab05d1fc7bab upstream.

Added the Seluxit ApS USB Serial Dongle to cp210x driver.

Signed-off-by: Andreas Bomholtz <andreas@seluxit.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index c91e6f0..37bca6b 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -162,6 +162,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
 	{ USB_DEVICE(0x1FB9, 0x0100) }, /* Lake Shore Model 121 Current Source */
-- 
1.9.1

