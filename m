Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaJBEpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 00:45:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbaJBEpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 00:45:44 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: trivial@kernel.org
Cc: gregkh@linuxfoundation.org, johannes.thumshirn@men.de,
        joshc@codeaurora.org, dl9pf@gmx.de, behanw@converseincode.com,
        kheitke@codeaurora.org, ard.biesheuvel@linaro.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [TRIVIAL] mod_devicetable.h: grammar fix in comment
Date: Thu,  2 Oct 2014 06:45:38 +0200
Message-Id: <1412225138-16158-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 include/linux/mod_devicetable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 44eeef0da186..745def862580 100644
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
1.9.1

