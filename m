Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaKLKMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:12:43 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35136 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaKLKMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:12:41 -0500
Date: Wed, 12 Nov 2014 15:42:34 +0530
From: Balavasu Kuppusammyprathaban <kp.balavasu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andreas.dilger@intel.com, oleg.drokin@intel.com, greg@kroah.com
Subject: [PATCH] staging: lustre: lustre: ptlrpc: Remove unnecessary braces
Message-ID: <20141112101234.GA4355@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch warning:
WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: Balavasu Kuppusammyprathaban <kp.balavasu@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 38cc931..6c8815f 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -2215,10 +2215,8 @@ EXPORT_SYMBOL(ptlrpc_set_wait);
  */
 static void __ptlrpc_free_req(struct ptlrpc_request *request, int locked)
 {
-	if (request == NULL) {
+	if (request == NULL)
 		return;
-	}
-
 	LASSERTF(!request->rq_receiving_reply, "req %p\n", request);
 	LASSERTF(request->rq_rqbd == NULL, "req %p\n", request);/* client-side */
 	LASSERTF(list_empty(&request->rq_list), "req %p\n", request);
-- 
1.9.1

