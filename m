Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbbAVKSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:18:13 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:34566 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbAVKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:18:03 -0500
From: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>
To: gregkh@linuxfoundation.org
Cc: sharon.dvir1@mail.huji.ac.il, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] Modules: Add missing word to comment in mod_devicetable.h
Date: Thu, 22 Jan 2015 12:15:25 +0200
Message-Id: <1421921725-17361-1-git-send-email-sharon.dvir1@mail.huji.ac.il>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation of match_flags in struct usb_device_id said:
'Bit mask controlling of the other fields are used to match against new devices.'
Changed to:
'Bit mask controlling which of the other fields are used to match against new devices.'
By adding the word 'which' and editing the next lines to not exceed 80 chars.

Signed-off-by: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>
---
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 745def8..470a240 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -53,9 +53,9 @@ struct ieee1394_device_id {

 /**
  * struct usb_device_id - identifies USB devices for probing and hotplugging
- * @match_flags: Bit mask controlling of the other fields are used to match
- *	against new devices.  Any field except for driver_info may be used,
- *	although some only make sense in conjunction with other fields.
+ * @match_flags: Bit mask controlling which of the other fields are used to
+ *	match against new devices. Any field except for driver_info may be
+ *	used, although some only make sense in conjunction with other fields.
  *	This is usually set by a USB_DEVICE_*() macro, which sets all
  *	other fields in this structure except for driver_info.
  * @idVendor: USB vendor ID for a device; numbers are assigned
