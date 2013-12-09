Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3LIPAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:00:18 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35475 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765Ab3LIPAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:00:13 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 05/13] staging/lustre/seq: remove seq_{query,handle}
Date: Mon,  9 Dec 2013 22:56:57 +0800
Message-Id: <1386601025-422-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikhail Pershin <mike.pershin@intel.com>

This is only part of the original Lustre tree commit. Main part of the
original commit modifies server side code.

Lustre-change: http://review.whamcloud.com/6765
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3467
Signed-off-by: Mikhail Pershin <mike.pershin@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: wangdi <di.wang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_fid.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre_fid.h b/drivers/staging/lustre/lustre/include/lustre_fid.h
index ff11953..84a897e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_fid.h
+++ b/drivers/staging/lustre/lustre/include/lustre_fid.h
@@ -431,12 +431,6 @@ struct lu_server_seq {
 	struct seq_server_site  *lss_site;
 };
 
-struct com_thread_info;
-int seq_query(struct com_thread_info *info);
-
-struct ptlrpc_request;
-int seq_handle(struct ptlrpc_request *req);
-
 /* Server methods */
 
 int seq_server_init(struct lu_server_seq *seq,
-- 
1.7.9.5

