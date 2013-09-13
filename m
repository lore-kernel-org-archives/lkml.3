Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3IML1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab3IML12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:27:28 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: linux-usb@vger.kernel.org
Cc: Gerd Hoffmann <kraxel@redhat.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        usb-storage@lists.one-eyed-alien.net (open list:USB MASS STORAGE...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 6/6] uas: remove BROKEN
Date: Fri, 13 Sep 2013 13:27:15 +0200
Message-Id: <1379071635-30701-7-git-send-email-kraxel@redhat.com>
In-Reply-To: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci streams support is fixed, unblock usb attached scsi.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/usb/storage/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
index 8470e1b..4761a28 100644
--- a/drivers/usb/storage/Kconfig
+++ b/drivers/usb/storage/Kconfig
@@ -202,7 +202,7 @@ config USB_STORAGE_ENE_UB6250
 
 config USB_UAS
 	tristate "USB Attached SCSI"
-	depends on SCSI && BROKEN
+	depends on SCSI
 	help
 	  The USB Attached SCSI protocol is supported by some USB
 	  storage devices.  It permits higher performance by supporting
-- 
1.8.3.1

