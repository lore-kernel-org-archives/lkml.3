Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaJSTZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:25:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52099 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaJSTZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:25:32 -0400
From: Mark Einon <mark.einon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH] MAINTAINERS: Remove duplicate entry for usbip driver
Date: Sun, 19 Oct 2014 20:25:26 +0100
Message-Id: <1413746726-3130-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usbip driver was moved out of staging in 3.17-rc3 but the MAINTAINERS file
still has the old staging entry as well as the new one. Remove the old entry.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 MAINTAINERS | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0eb6c2a..f26840c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9690,11 +9690,6 @@ S:	Maintained
 F:	Documentation/hid/hiddev.txt
 F:	drivers/hid/usbhid/
 
-USB/IP DRIVERS
-L:	linux-usb@vger.kernel.org
-S:	Orphan
-F:	drivers/staging/usbip/
-
 USB ISP116X DRIVER
 M:	Olav Kongas <ok@artecdesign.ee>
 L:	linux-usb@vger.kernel.org
-- 
2.1.1

