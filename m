Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3EIWLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:11:14 -0400
Received: from longford.logfs.org ([213.229.74.203]:59048 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3EIWLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:11:12 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 10/14] blockconsole: Fix undefined MAX_RT_PRIO
Date: Thu,  9 May 2013 16:43:08 -0400
Message-Id: <1368132193-25817-13-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/block/blockconsole.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index e88b8ee..c22272f 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/ctype.h>
 
 #define BLOCKCONSOLE_MAGIC	"\nLinux blockconsole version 1.1\n"
-- 
1.7.10.4

