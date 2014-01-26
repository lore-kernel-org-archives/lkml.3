Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaAZQAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 11:00:44 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:39300 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaAZQAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 11:00:43 -0500
From: Gary Servin <garyservin@gmail.com>
To: jfrederich@gmail.com, dsd@laptop.org, jon.nettleton@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Gary Servin <garyservin@gmail.com>
Subject: [PATCH] staging: olpc_dcon: Trivial: Remove space before indentation.
Date: Sun, 26 Jan 2014 13:00:18 -0300
Message-Id: <1390752018-26243-1-git-send-email-garyservin@gmail.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This coding style error was detected using the checkpatch.pl script

Signed-off-by: Gary Servin <garyservin@gmail.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index e2663b1..aec9895 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -37,7 +37,7 @@
 /* Load Delay Locked Loop (DLL) settings for clock delay */
 #define MEM_DLL_CLOCK_DELAY	(1<<0)
 /* Memory controller power down function */
-#define MEM_POWER_DOWN  	(1<<8)
+#define MEM_POWER_DOWN		(1<<8)
 /* Memory controller software reset */
 #define MEM_SOFT_RESET		(1<<0)
 
-- 
1.8.5.3

