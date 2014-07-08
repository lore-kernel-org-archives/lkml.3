Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaGHQJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:09:58 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:39109 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbaGHQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:09:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OAHcXvFNXQDwH/2dsb2JhbABZgw6tGgUBAQEBAQEFAW4BmVmBFxd1hQOBGjeIRgHJXReFeolIHYQtBZAJim2LXIgwggGBRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] scripts/coccinelle/free/ifnullfree.cocci: add copyright information
Date: Tue,  8 Jul 2014 18:09:28 +0200
Message-Id: <1404835768-5229-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all coccinelle scripts have a copyright in the header ...

Suggested-By: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/coccinelle/free/ifnullfree.cocci | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
index c826d98..9321fe3 100644
--- a/scripts/coccinelle/free/ifnullfree.cocci
+++ b/scripts/coccinelle/free/ifnullfree.cocci
@@ -4,8 +4,9 @@
 /// "kfree(NULL) is safe this check is probably not required"
 /// and kfreeaddr.cocci by Julia Lawall.
 ///
-/// Comments: -
-/// Options: --no-includes --include-headers
+// Copyright: (C) 2014 Fabian Frederick.  GPLv2.
+// Comments: -
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual org
-- 
1.8.4.5

