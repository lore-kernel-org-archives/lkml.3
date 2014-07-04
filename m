Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbaGDUC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:02:57 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:26480 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107AbaGDUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:02:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMMAF0Ht1NbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BkiiHP4ELF3WECwJTI4ECBxE3iC4DFQG1UY4sDYZSF4VwhwqBRGQdhC0FkAmIAWyCAI14hhSDRTuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] UBIFS: kernel-doc warning fix
Date: Fri,  4 Jul 2014 22:02:50 +0200
Message-Id: <1404504170-519-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no grouped argument in drop_last_node.

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/recovery.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index c14adb2..e256296 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -596,7 +596,6 @@ static void drop_last_group(struct ubifs_scan_leb *sleb, int *offs)
  * drop_last_node - drop the last node.
  * @sleb: scanned LEB information
  * @offs: offset of dropped nodes is returned here
- * @grouped: non-zero if whole group of nodes have to be dropped
  *
  * This is a helper function for 'ubifs_recover_leb()' which drops the last
  * node of the scanned LEB.
-- 
1.9.1

