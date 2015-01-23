Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbbAWWBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:01:19 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46945 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbAWWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:01:17 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH] xfs: fix typo
Date: Fri, 23 Jan 2015 14:00:51 -0800
Message-Id: <1422050451-11486-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'tobe' should be two words.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 fs/xfs/xfs_aops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 18e2f3bbae5e..af729e8975aa 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1161,7 +1161,7 @@ xfs_vm_writepage(
 	ASSERT(iohead);
 
 	/*
-	 * Any errors from this point onwards need tobe reported through the IO
+	 * Any errors from this point onwards need to be reported through the IO
 	 * completion path as we have marked the initial page as under writeback
 	 * and unlocked it.
 	 */
-- 
1.9.1

