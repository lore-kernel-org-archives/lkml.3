Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3KSN0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:26:40 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55388 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3KSN0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:26:36 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Amir Shehata <amir.shehata@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 6/9] staging/lustre/lnet: remove extra space in lstcon_rpc_trans_abort
Date: Tue, 19 Nov 2013 21:23:45 +0800
Message-Id: <1384867428-8395-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amir Shehata <amir.shehata@intel.com>

This is coding style fix part of original Lustre commit in external tree.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3093
Lustre-change: http://review.whamcloud.com/6092
Signed-off-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lnet/selftest/conrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index 9a52f25..53d5892 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -311,7 +311,7 @@ lstcon_rpc_trans_abort(lstcon_rpc_trans_t *trans, int error)
 
 		sfw_abort_rpc(rpc);
 
-		if  (error != ETIMEDOUT)
+		if (error != ETIMEDOUT)
 			continue;
 
 		nd = crpc->crp_node;
-- 
1.7.9.5

