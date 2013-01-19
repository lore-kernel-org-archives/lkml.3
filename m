Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3ASC4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:56:35 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39085 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3ASC4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:56:33 -0500
Date: Fri, 18 Jan 2013 21:56:44 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sjening@linux.vnet.ibm.com, konrad.wilk@oracle.com,
        xiaoguangrong@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        jake.champlin.27@gmail.com
Subject: [PATCH] Staging: zcache-main: Fixed Camel Case Issue
Message-ID: <20130119025640.GA32271@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a camel case coding style issue.

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/zcache/zcache-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 52b43b7..95be348 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1851,7 +1851,7 @@ static int zcache_frontswap_store(unsigned type, pgoff_t offset,
 	int ret = -1;
 	unsigned long flags;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!page_locked(page));
 	if (likely(ind64 == ind)) {
 		local_irq_save(flags);
 		ret = zcache_put_page(LOCAL_CLIENT, zcache_frontswap_poolid,
@@ -1871,7 +1871,7 @@ static int zcache_frontswap_load(unsigned type, pgoff_t offset,
 	struct tmem_oid oid = oswiz(type, ind);
 	int ret = -1;
 
-	BUG_ON(!PageLocked(page));
+	BUG_ON(!page_locked(page));
 	if (likely(ind64 == ind))
 		ret = zcache_get_page(LOCAL_CLIENT, zcache_frontswap_poolid,
 					&oid, iswiz(ind), page);
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
8123742937
<MuttClient>
