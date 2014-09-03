Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaICW6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:58:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41841 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaICW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:58:37 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mod_devicetable: fix incorrect plural
Date: Thu,  4 Sep 2014 00:58:22 +0200
Message-Id: <1409785103-14262-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 include/linux/mod_devicetable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 44eeef0..745def8 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -69,7 +69,7 @@ struct ieee1394_device_id {
  * @bDeviceClass: Class of device; numbers are assigned
  *	by the USB forum.  Products may choose to implement classes,
  *	or be vendor-specific.  Device classes specify behavior of all
- *	the interfaces on a devices.
+ *	the interfaces on a device.
  * @bDeviceSubClass: Subclass of device; associated with bDeviceClass.
  * @bDeviceProtocol: Protocol of device; associated with bDeviceClass.
  * @bInterfaceClass: Class of interface; numbers are assigned
-- 
2.1.0

