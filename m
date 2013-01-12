Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3ALEmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 23:42:15 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57170 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3ALEmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 23:42:14 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] tty: add parenthesis to macro POLL_PERIOD in rocket.c
Date: Sat, 12 Jan 2013 05:42:07 +0100
Message-Id: <1357965727-26058-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros should be enclosed in parenthesis

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/tty/rocket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index e42009a..e434a79 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -55,7 +55,7 @@
 #undef REV_PCI_ORDER
 #undef ROCKET_DEBUG_IO
 
-#define POLL_PERIOD HZ/100	/*  Polling period .01 seconds (10ms) */
+#define POLL_PERIOD (HZ/100)	/*  Polling period .01 seconds (10ms) */
 
 /****** Kernel includes ******/
 
-- 
1.7.10.4

