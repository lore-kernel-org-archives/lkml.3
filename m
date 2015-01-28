Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965142AbbA1EYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:34 -0500
Received: from mail.kernel.org ([198.145.29.136]:40710 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469AbbA1EYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:31 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adel Gadllah <adel.gadllah@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 132/177] USB: quirks: enable device-qualifier quirk for yet another Elan touchscreen
Date: Wed, 28 Jan 2015 12:09:50 +0800
Message-Id: <1422418236-12852-223-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adel Gadllah <adel.gadllah@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d749947561af5996ccc076b2ffcc5f48b1be5d74 upstream.

Yet another device affected by this.

Tested-by: Kevin Fenzi <kevin@scrye.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 9bd01502..980a9d8 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -91,6 +91,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x04f3, 0x009b), .driver_info =
 			USB_QUIRK_DEVICE_QUALIFIER },
 
+	{ USB_DEVICE(0x04f3, 0x016f), .driver_info =
+			USB_QUIRK_DEVICE_QUALIFIER },
+
 	/* Roland SC-8820 */
 	{ USB_DEVICE(0x0582, 0x0007), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
1.9.1

