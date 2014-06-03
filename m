Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779AbaFCUKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:10:06 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:40749 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933820AbaFCUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:10:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnAOAPcqjlNbsmtf/2dsb2JhbABZgwerXgQDAQEBBQGYHIEOF3SDAiOBAhg3iC4DFQHLHA2GCBeFVYZngTJkHYQqBI9LiEaBeYsdgiGFdYM6O4Ew
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/test-kstrtox.c: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  3 Jun 2014 22:08:49 +0200
Message-Id: <1401826129-10129-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel.h definition.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/test-kstrtox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
index bea3f3f..4137bca 100644
--- a/lib/test-kstrtox.c
+++ b/lib/test-kstrtox.c
@@ -3,7 +3,7 @@
 #include <linux/module.h>
 
 #define for_each_test(i, test)	\
-	for (i = 0; i < sizeof(test) / sizeof(test[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(test); i++)
 
 struct test_fail {
 	const char *str;
-- 
1.8.4.5

