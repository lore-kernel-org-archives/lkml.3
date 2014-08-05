Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaHEPGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbaHEPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:06:09 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Przemo Firszt <przemo@firszt.eu>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v4] Input - wacom: add copyright note and bump version to 2.0
Date: Tue,  5 Aug 2014 11:05:43 -0400
Message-Id: <1407251143-10044-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1406659385-3256-7-git-send-email-benjamin.tissoires@redhat.com>
References: <1406659385-3256-7-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Ping Cheng <pingc@wacom.com>
Tested-by: Przemo Firszt <przemo@firszt.eu>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

changes in v4:
- also update the DRIVER_VERSION macro

Hi Dmitry,

if you could replace the v3 of this patch by this v4 in your pull request
to Linus, that would be better. Ping notified me about this last Friday, so I
kept her Rev-by.

Cheers,
Benjamin

 drivers/hid/wacom.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom.h b/drivers/hid/wacom.h
index 0b89ee7..8cc4406 100644
--- a/drivers/hid/wacom.h
+++ b/drivers/hid/wacom.h
@@ -12,6 +12,7 @@
  *  Copyright (c) 2001 Frederic Lepied		<flepied@mandrakesoft.com>
  *  Copyright (c) 2004 Panagiotis Issaris	<panagiotis.issaris@mech.kuleuven.ac.be>
  *  Copyright (c) 2002-2011 Ping Cheng		<pingc@wacom.com>
+ *  Copyright (c) 2014 Benjamin Tissoires	<benjamin.tissoires@redhat.com>
  *
  *  ChangeLog:
  *      v0.1 (vp)  - Initial release
@@ -72,6 +73,8 @@
  *      v1.52 (pc) - Query Wacom data upon system resume
  *                 - add defines for features->type
  *                 - add new devices (0x9F, 0xE2, and 0XE3)
+ *      v2.00 (bt) - conversion to a HID driver
+ *                 - integration of the Bluetooth devices
  */
 
 /*
@@ -93,7 +96,7 @@
 /*
  * Version Information
  */
-#define DRIVER_VERSION "v1.53"
+#define DRIVER_VERSION "v2.00"
 #define DRIVER_AUTHOR "Vojtech Pavlik <vojtech@ucw.cz>"
 #define DRIVER_DESC "USB Wacom tablet driver"
 #define DRIVER_LICENSE "GPL"
-- 
2.0.4

