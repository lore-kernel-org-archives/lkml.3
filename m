Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbbAFJjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:39:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbbAFJjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:39:41 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mgorman@suse.de, Baoquan He <bhe@redhat.com>
Subject: [PATCH] mm: fix a typo of MIGRATE_RESERVE in comment
Date: Tue,  6 Jan 2015 17:37:59 +0800
Message-Id: <1420537079-5336-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found it when I want to jump to the definition of MIGRATE_RESERVE
ctags.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2f0856d..b418297 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -426,7 +426,7 @@ struct zone {
 	const char		*name;
 
 	/*
-	 * Number of MIGRATE_RESEVE page block. To maintain for just
+	 * Number of MIGRATE_RESERVE page block. To maintain for just
 	 * optimization. Protected by zone->lock.
 	 */
 	int			nr_migrate_reserve_block;
-- 
1.8.5.3

