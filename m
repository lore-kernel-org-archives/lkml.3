Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab3APQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:56:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3APQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, Jiri Kosina <jkosina@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 069/222] HID: Add Apple wireless keyboard 2011 ANSI to special driver list
Date: Wed, 16 Jan 2013 13:54:29 -0200
Message-Id: <1358351822-7675-70-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit f9af7b9edccb87d4d80b58687ab63e58f3b64c4c upstream.

Commit 0a97e1e9f9a6 ('HID: apple: Add Apple wireless keyboard 2011 ANSI PID')
did not update the special driver list in hid-core.c, so hid-generic may
still bind to this device.

Reported-by: Ari Pollak <ari@scvngr.com>
References: http://bugs.debian.org/694546
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/hid/hid-core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0e4d41e..3cb5c99 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1519,6 +1519,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ANSI) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
-- 
1.7.9.5

