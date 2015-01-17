Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbbAQA0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 19:26:34 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57829 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbbAQA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 19:26:33 -0500
Message-ID: <1421454236.7996.38.camel@mail.huji.ac.il>
Subject: [PATCH 01/01] modules: Add missing word to comment
From: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>
To: gregkh@linuxfoundation.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 17 Jan 2015 02:23:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add missing 'which' in comment. 
Signed-off-by: Sharon Dvir <sharon.dvir1@mail.huji.ac.il>
---
diff --git a/include/linux/mod_devicetable.h
b/include/linux/mod_devicetable.h
index 745def8..470a240 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -53,9 +53,9 @@ struct ieee1394_device_id {
 
 /**
  * struct usb_device_id - identifies USB devices for probing and
hotplugging
- * @match_flags: Bit mask controlling of the other fields are used to
match
- *     against new devices.  Any field except for driver_info may be
used,
- *     although some only make sense in conjunction with other fields.
+ * @match_flags: Bit mask controlling which of the other fields are
used to
+ *     match against new devices. Any field except for driver_info may
be
+ *     used, although some only make sense in conjunction with other
fields.
  *     This is usually set by a USB_DEVICE_*() macro, which sets all
  *     other fields in this structure except for driver_info.
  * @idVendor: USB vendor ID for a device; numbers are assigned


