Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaGNVjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:39:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56728 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453AbaGNVip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:38:45 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] doc: fix minor typos in firmware_class README
Date: Mon, 14 Jul 2014 14:38:11 -0700
Message-Id: <1405373897-31671-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405373897-31671-1-git-send-email-keescook@chromium.org>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a tiny clean up for typos in the firmware_class README.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/firmware_class/README |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/firmware_class/README b/Documentation/firmware_class/README
index 43fada989e65..71f86859d7d8 100644
--- a/Documentation/firmware_class/README
+++ b/Documentation/firmware_class/README
@@ -64,7 +64,7 @@
 
 	 if(request_firmware(&fw_entry, $FIRMWARE, device) == 0)
 	 	copy_fw_to_device(fw_entry->data, fw_entry->size);
-	 release(fw_entry);
+	 release_firmware(fw_entry);
 
  Sample/simple hotplug script:
  ============================
@@ -74,7 +74,7 @@
 	HOTPLUG_FW_DIR=/usr/lib/hotplug/firmware/
 
 	echo 1 > /sys/$DEVPATH/loading
-	cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
+	cat $HOTPLUG_FW_DIR/$FIRMWARE > /sys/$DEVPATH/data
 	echo 0 > /sys/$DEVPATH/loading
 
  Random notes:
@@ -123,6 +123,6 @@
  --------------------
  After firmware cache mechanism is introduced during system sleep,
  request_firmware can be called safely inside device's suspend and
- resume callback, and callers need't cache the firmware by
+ resume callback, and callers needn't cache the firmware by
  themselves any more for dealing with firmware loss during system
  resume.
-- 
1.7.9.5

