Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3EIWLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:11:13 -0400
Received: from longford.logfs.org ([213.229.74.203]:59050 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3EIWLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:11:12 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 12/14] blockconsole: Mark a local work struct static
Date: Thu,  9 May 2013 16:43:10 -0400
Message-Id: <1368132193-25817-15-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/block/blockconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 40cc96e..01ddbc6 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -564,7 +564,7 @@ static void bcon_do_add(struct work_struct *work)
 	}
 }
 
-DECLARE_WORK(bcon_add_work, bcon_do_add);
+static DECLARE_WORK(bcon_add_work, bcon_do_add);
 
 void bcon_add(const char *name)
 {
-- 
1.7.10.4

