Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3EMVGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:06:25 -0400
Received: from mout.gmx.net ([212.227.15.19]:50850 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3EMVGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:06:24 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19fy6llhRpf88OiFimRA2AQoR19DDYHUPoNY+eCiH
	cfO0QwtG1ZPEHo
From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] insert missing space in printk line of root_delay
Date: Mon, 13 May 2013 23:06:20 +0200
Message-Id: <1368479180-3837-1-git-send-email-toralf.foerster@gmx.de>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trivial, but it really looks better

Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 init/do_mounts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index a2b49f2..816014c 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -536,7 +536,7 @@ void __init prepare_namespace(void)
 	int is_floppy;
 
 	if (root_delay) {
-		printk(KERN_INFO "Waiting %dsec before mounting root device...\n",
+		printk(KERN_INFO "Waiting %d sec before mounting root device...\n",
 		       root_delay);
 		ssleep(root_delay);
 	}
-- 
1.8.1.5

