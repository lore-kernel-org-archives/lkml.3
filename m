Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaF2KVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:21:49 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52609 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaF2KVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:21:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Subject: [PATCH -trivial 2/4] mtd: cmdlinepart: Spelling s/trucate/truncate/
Date: Sun, 29 Jun 2014 12:21:37 +0200
Message-Id: <1404037299-31570-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
References: <1404037299-31570-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/cmdlinepart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 3e829b37af8d..c8503006f17a 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -26,7 +26,7 @@
  * <mtd-id>  := unique name used in mapping driver/device (mtd->name)
  * <size>    := standard linux memsize OR "-" to denote all remaining space
  *              size is automatically truncated at end of device
- *              if specified or trucated size is 0 the part is skipped
+ *              if specified or truncated size is 0 the part is skipped
  * <offset>  := standard linux memsize
  *              if omitted the part will immediately follow the previous part
  *              or 0 if the first part
-- 
1.9.1

