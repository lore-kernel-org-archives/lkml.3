Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3APQBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:01:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3APQA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 056/222] USB: mark uas driver as BROKEN
Date: Wed, 16 Jan 2013 13:54:16 -0200
Message-Id: <1358351822-7675-57-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg KH <gregkh@linuxfoundation.org>

commit fb37ef98015f864d22be223a0e0d93547cd1d4ef upstream.

As reported https://bugzilla.kernel.org/show_bug.cgi?id=51031, the UAS
driver causes problems and has been asked to be not built into any of
the major distributions.  To prevent users from running into problems
with it, and for distros that were not notified, just mark the whole
thing as broken.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/storage/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 7691c86..685edc8 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -203,7 +203,7 @@ config USB_STORAGE_ENE_UB6250
 
 config USB_UAS
 	tristate "USB Attached SCSI"
-	depends on USB && SCSI
+	depends on USB && SCSI && BROKEN
 	help
 	  The USB Attached SCSI protocol is supported by some USB
 	  storage devices.  It permits higher performance by supporting
-- 
1.7.9.5

