Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaGMUOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 16:14:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63592 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaGMUO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 16:14:26 -0400
From: Rob Ward <robert.ward114@googlemail.com>
X-Google-Original-From: Rob Ward <rob@rob-thinkpad>
Date: Sun, 13 Jul 2014 21:14:21 +0100 (BST)
To: joern@lazybastard.org, dwmw2@infradead.org
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: phram: Fix whitespace issues
Message-ID: <alpine.DEB.2.02.1407132105320.19235@rob-thinkpad>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ae6ea29f112475aa1e2da20caabe36e318fd51c4 Mon Sep 17 00:00:00 2001
From: Rob Ward <robert.ward114@googlemail.com>
Date: Sun, 13 Jul 2014 20:39:01 +0100
Subject: [PATCH] mtd: phram: Fix whitespace issues

Fix various whitespace issues.

No functional changes.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/mtd/devices/phram.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 2cceebf..cf02f24 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -195,6 +195,7 @@ static int parse_name(char **pname, const char *token)
 static inline void kill_final_newline(char *str)
 {
 	char *newline = strrchr(str, '\n');
+
 	if (newline && !newline[1])
 		*newline = 0;
 }
@@ -233,7 +234,7 @@ static int phram_setup(const char *val)
 	strcpy(str, val);
 	kill_final_newline(str);
 
-	for (i=0; i<3; i++)
+	for (i = 0; i < 3; i++)
 		token[i] = strsep(&str, ",");
 
 	if (str)
-- 
1.8.1.2

