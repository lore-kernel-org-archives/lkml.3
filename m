Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaLOCDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:03:20 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:46067 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaLOCDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:03:08 -0500
From: Eduardo Barretto <edusbarretto@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wlan-ng: hfa384x_usb: fixed an 'else' statement coding style issue
Date: Mon, 15 Dec 2014 00:02:54 -0200
Message-Id: <1418608974-22509-1-git-send-email-edusbarretto@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue

Signed-off-by: Eduardo Barretto <edusbarretto@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 55d2f56..d388f2c 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -4123,12 +4123,11 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
 				 pdrcode);
 			return 1;
-		} else {
-			/* bad code */
-			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
-				 pdrcode);
-			return 0;
 		}
+		/* bad code */
+		pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
+			 pdrcode);
+		return 0;
 	}
 	return 0;		/* avoid compiler warnings */
 }
-- 
2.1.3

