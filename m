Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3EFHqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:46:34 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:54178 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3EFHqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:46:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd: ChromeOS EC - Spelling s/ned/need/
Date: Mon,  6 May 2013 09:46:29 +0200
Message-Id: <1367826389-6988-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 0d86b34..3145184 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -53,7 +53,7 @@ config MFD_CROS_EC
 	help
 	  If you say Y here you get support for the ChromeOS Embedded
 	  Controller (EC) providing keyboard, battery and power services.
-	  You also ned to enable the driver for the bus you are using. The
+	  You also need to enable the driver for the bus you are using. The
 	  protocol for talking to the EC is defined by the bus driver.
 
 config MFD_CROS_EC_I2C
-- 
1.7.0.4

