Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946571Ab3BHOjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:39:09 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52151 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946533Ab3BHOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:42 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] HID: multitouch: Copyright and note on regression tests
Date: Fri,  8 Feb 2013 15:37:36 +0100
Message-Id: <1360334256-22127-8-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reflects my new company and officialize the regression tests I'm
conducting between each change.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 184ac0a..3af9efdd 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2,8 +2,9 @@
  *  HID driver for multitouch panels
  *
  *  Copyright (c) 2010-2012 Stephane Chatty <chatty@enac.fr>
- *  Copyright (c) 2010-2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
+ *  Copyright (c) 2010-2013 Benjamin Tissoires <benjamin.tissoires@gmail.com>
  *  Copyright (c) 2010-2012 Ecole Nationale de l'Aviation Civile, France
+ *  Copyright (c) 2012-2013 Red Hat, Inc
  *
  *  This code is partly based on hid-egalax.c:
  *
@@ -26,6 +27,17 @@
  * any later version.
  */
 
+/*
+ * This driver is regularly tested thanks to the tool hid-test[1].
+ * This tool relies on hid-replay[2] and a database of hid devices[3].
+ * Please run these regression tests before patching this module so that
+ * your patch won't break existing known devices.
+ *
+ * [1] https://github.com/bentiss/hid-test
+ * [2] https://github.com/bentiss/hid-replay
+ * [3] https://github.com/bentiss/hid-devices
+ */
+
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
-- 
1.8.1

