Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaF2KN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:13:58 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:33894 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaF2KN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:13:56 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tim Waugh <tim@cyberelk.net>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -trivial] paride/pcd: Fix grammar
Date: Sun, 29 Jun 2014 12:13:49 +0200
Message-Id: <1404036829-31352-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/paride/pcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 719cb1bc1640..3b7c9f1be484 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -69,8 +69,8 @@
             nice        This parameter controls the driver's use of
                         idle CPU time, at the expense of some speed.
  
-	If this driver is built into the kernel, you can use kernel
-        the following command line parameters, with the same values
+	If this driver is built into the kernel, you can use the
+        following kernel command line parameters, with the same values
         as the corresponding module parameters listed above:
 
 	    pcd.drive0
-- 
1.9.1

