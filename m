Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837Ab3E2HaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:30:22 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58881 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935042Ab3E2HaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:30:21 -0400
Message-ID: <1369812619.23034.4.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix comment typo "CONFIG_PAE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 May 2013 09:30:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2013 07:30:19.0602 (UTC) FILETIME=[5F3F1320:01CE5C3E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Please note that I don't really understand this comment, but
the fix is correct anyhow.

 drivers/lguest/page_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 5b9ac32..a35d8d1 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -70,7 +70,7 @@
 /*H:320
  * The page table code is curly enough to need helper functions to keep it
  * clear and clean.  The kernel itself provides many of them; one advantage
- * of insisting that the Guest and Host use the same CONFIG_PAE setting.
+ * of insisting that the Guest and Host use the same CONFIG_X86_PAE setting.
  *
  * There are two functions which return pointers to the shadow (aka "real")
  * page tables.
-- 
1.7.11.7

