Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3L3JHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 04:07:48 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:53674 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3L3JHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 04:07:46 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>
Cc: linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] block/ps3: Remove obsolete reference to MTD
Date: Mon, 30 Dec 2013 10:07:43 +0100
Message-Id: <1388394463-25798-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ps3vram driver is a plain block device driver since commit
f507cd22035fdadd5dbb476dd05e9e7ee21c3b84 ("ps3/block: Replace mtd/ps3vram
by block/ps3vram").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/ps3vram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 06a2e53e5f37..313ee641ea10 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -1,5 +1,5 @@
 /*
- * ps3vram - Use extra PS3 video ram as MTD block device.
+ * ps3vram - Use extra PS3 video ram as block device.
  *
  * Copyright 2009 Sony Corporation
  *
-- 
1.7.9.5

