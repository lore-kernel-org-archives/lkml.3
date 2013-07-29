Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3G2VnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:43:22 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36320 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3G2VnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:43:21 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dilinger@queued.net, jon.nettleton@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH 2/2] staging: olpc_dcon: provide detailed FB_OLPC_DCON help section
Date: Mon, 29 Jul 2013 23:42:51 +0200
Message-Id: <1375134171-31989-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FB_OLPC_DCON help section is to short according to checkpatch.pl.
We want more information about the controller type, its task, its video
pipeline position and so on.

There are no style issues, remove checkpatch.pl TODO entry.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>
---
 drivers/staging/olpc_dcon/Kconfig |   11 ++++++++---
 drivers/staging/olpc_dcon/TODO    |    1 -
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/olpc_dcon/Kconfig b/drivers/staging/olpc_dcon/Kconfig
index fe40e0b..2ff015d 100644
--- a/drivers/staging/olpc_dcon/Kconfig
+++ b/drivers/staging/olpc_dcon/Kconfig
@@ -4,9 +4,14 @@ config FB_OLPC_DCON
 	select I2C
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
-	  Add support for the OLPC XO DCON controller.  This controller is
-	  only available on OLPC platforms.   Unless you have one of these
-	  platforms, you will want to say 'N'.
+	  In order to support very low power operation, the XO laptop uses a
+	  secondary Display CONtroller, or DCON.  This secondary controller
+	  is present in the video pipeline between the primary display
+	  controller (integrate into the processor or chipset) and the LCD
+	  panel.  It allows the main processor/display controller to be
+	  completely powered off while still retaining an image on the display.
+	  This controller is only available on OLPC platforms.  Unless you have
+	  one of these platforms, you will want to say 'N'.
 
 config FB_OLPC_DCON_1
 	bool "OLPC XO-1 DCON support"
diff --git a/drivers/staging/olpc_dcon/TODO b/drivers/staging/olpc_dcon/TODO
index 35f9cda..f378e84 100644
--- a/drivers/staging/olpc_dcon/TODO
+++ b/drivers/staging/olpc_dcon/TODO
@@ -1,5 +1,4 @@
 TODO:
-	- checkpatch.pl cleanups
 	- see if vx855 gpio API can be made similar enough to cs5535 so we can
 	  share more code
 	- allow simultaneous XO-1 and XO-1.5 support
-- 
1.7.9.5

