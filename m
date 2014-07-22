Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaGVCvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:51:44 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39931 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaGVCvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:51:42 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Asadi <asadi.samuel@gmail.com>
Subject: [PATCH 1/2] Staging: comedi: amcc_s5933: a line over 80 fixed
Date: Tue, 22 Jul 2014 05:51:22 +0300
Message-Id: <1405997483-11481-1-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 'line over 80 characters' fixed by removing comment to
previous line.

Signed-off-by: Sam Asadi <asadi.samuel@gmail.com>
---
 drivers/staging/comedi/drivers/amcc_s5933.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amcc_s5933.h b/drivers/staging/comedi/drivers/amcc_s5933.h
index 2ba7364..089b71f 100644
--- a/drivers/staging/comedi/drivers/amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/amcc_s5933.h
@@ -52,7 +52,8 @@
 #define INTCSR_INBOX_BYTE(x)	(((x) & 0x3) << 8)
 #define INTCSR_INBOX_SELECT(x)	(((x) & 0x3) << 10)
 #define INTCSR_INBOX_FULL_INT	0x1000	/*  enable inbox full interrupt */
-#define INTCSR_INBOX_INTR_STATUS	0x20000	/*  read, or write clear inbox full interrupt */
+/* read, or write clear inbox full interrupt */
+#define INTCSR_INBOX_INTR_STATUS	0x20000
 #define INTCSR_INTR_ASSERTED	0x800000	/*  read only, interrupt asserted */
 
 /****************************************************************************/
-- 
1.7.10.4

