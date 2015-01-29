Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbbA2Kwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:52:50 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52473 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762808AbbA2Kwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:52:43 -0500
Date: Thu, 29 Jan 2015 19:49:54 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ocfs2: remove unreachable code in
 __ocfs2_recovery_thread()
Message-ID: <20150129104953.GA6094@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/journal.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index ca11c83..ff53192 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1462,7 +1462,6 @@ bail:
 	 * requires that we call do_exit().  And it isn't exported, but
 	 * complete_and_exit() seems to be a minimal wrapper around it. */
 	complete_and_exit(NULL, status);
-	return status;
 }
 
 void ocfs2_recovery_thread(struct ocfs2_super *osb, int node_num)
-- 
1.7.1

