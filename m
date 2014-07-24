Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbaGXUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:31:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48859 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503AbaGXUbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:31:14 -0400
Date: Thu, 24 Jul 2014 13:31:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julian Squires <julian@cipht.net>, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: wacom_serial4 - prepare for wacom USB moving to HID
Message-ID: <20140724203108.GA9191@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wacom_wac.h will be moving to drivers/hid. Since we only need 3 definitions
from it let's simply copy them over.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/tablet/wacom_serial4.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/input/tablet/wacom_serial4.c b/drivers/input/tablet/wacom_serial4.c
index d3d251e..deef50e 100644
--- a/drivers/input/tablet/wacom_serial4.c
+++ b/drivers/input/tablet/wacom_serial4.c
@@ -149,6 +149,11 @@ MODULE_LICENSE("GPL");
 #define F_HAS_STYLUS2		0x02
 #define F_HAS_SCROLLWHEEL	0x04
 
+/* device IDs */
+#define STYLUS_DEVICE_ID	0x02
+#define CURSOR_DEVICE_ID	0x06
+#define ERASER_DEVICE_ID	0x0A
+
 enum { STYLUS = 1, ERASER, CURSOR };
 
 static const struct {
-- 
2.0.0.526.g5318336


-- 
Dmitry
