Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaHDAS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:18:26 -0400
Received: from s87.loopia.se ([194.9.94.112]:29719 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaHDASZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:18:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: tony@atomide.com, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 01/19] ARM: OMAP: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:18:03 -0700
Message-Id: <1407111483-14512-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 arch/arm/mach-omap2/id.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index d42022f..53841de 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -663,7 +663,7 @@ void __init dra7xxx_check_revision(void)
 
 	default:
 		/* Unknown default to latest silicon rev as default*/
-		pr_warn("%s: unknown idcode=0x%08x (hawkeye=0x%08x,rev=0x%d)\n",
+		pr_warn("%s: unknown idcode=0x%08x (hawkeye=0x%08x,rev=0x%x)\n",
 			__func__, idcode, hawkeye, rev);
 		omap_revision = DRA752_REV_ES1_1;
 	}
-- 
2.0.0.526.g5318336

