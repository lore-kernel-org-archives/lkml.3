Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3CARRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:17:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab3CARRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:17:49 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/3] blockconsole: Mark a local work struct static
Date: Fri,  1 Mar 2013 18:17:48 +0100
Message-Id: <1362158268-21122-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362158268-21122-1-git-send-email-tiwai@suse.de>
References: <s5htxovxcrl.wl%tiwai@suse.de>
 <1362158268-21122-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/block/blockconsole.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 147b8af..86744cc 100644
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
1.8.1.4

