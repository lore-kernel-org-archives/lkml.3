Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129AbaGXDoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:44:06 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44580 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077AbaGXDoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:44:04 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Remove checkpatch errors  in InterfaceMarcos.h
Date: Wed, 23 Jul 2014 23:43:58 -0400
Message-Id: <1406173438-7045-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the two errors I get when running checkpatch on this
file. The first being not to use C99 comments and the second to
remove spacing issues with the define statement on line 7.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/bcm/InterfaceMacros.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/InterfaceMacros.h b/drivers/staging/bcm/InterfaceMacros.h
index 7001caf..531aadf 100644
--- a/drivers/staging/bcm/InterfaceMacros.h
+++ b/drivers/staging/bcm/InterfaceMacros.h
@@ -4,13 +4,13 @@
 #define BCM_USB_MAX_READ_LENGTH 2048
 
 #define MAXIMUM_USB_TCB      128
-#define MAXIMUM_USB_RCB 	 128
+#define MAXIMUM_USB_RCB 128
 
 #define MAX_BUFFERS_PER_QUEUE   256
 
 #define MAX_DATA_BUFFER_SIZE    2048
 
-//Num of Asynchronous reads pending
+/* Num of Asynchronous reads pending */
 #define NUM_RX_DESC 64
 
 #define SYS_CFG 0x0F000C00
-- 
1.9.1

