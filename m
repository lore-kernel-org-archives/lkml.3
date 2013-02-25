Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab3BYKdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:33:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44595 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3BYKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:32:57 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] HID: multitouch: Copyright and note on regression tests
Date: Mon, 25 Feb 2013 11:31:49 +0100
Message-Id: <1361788310-6048-8-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reflects my new company and officialize the regression tests I'm
conducting between each change.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
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
1.8.1.2

