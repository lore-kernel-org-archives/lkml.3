Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaHMSXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:23:38 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41408 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaHMSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:23:37 -0400
Date: Wed, 13 Aug 2014 23:53:30 +0530
From: Hema Prathaban <hemaklnce@gmail.com>
To: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: ptlrpc: Fix pointer declaration
Message-ID: <20140813182330.GA23129@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issue in client.c:
ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/client.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index dd017f3..8fa9b71 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -721,7 +721,7 @@ struct ptlrpc_request *__ptlrpc_request_alloc(struct obd_import *imp,
  */
 static struct ptlrpc_request *
 ptlrpc_request_alloc_internal(struct obd_import *imp,
-			      struct ptlrpc_request_pool * pool,
+			      struct ptlrpc_request_pool *pool,
 			      const struct req_format *format)
 {
 	struct ptlrpc_request *request;
@@ -751,7 +751,7 @@ EXPORT_SYMBOL(ptlrpc_request_alloc);
  * initialize its buffer structure according to capsule template \a format.
  */
 struct ptlrpc_request *ptlrpc_request_alloc_pool(struct obd_import *imp,
-					    struct ptlrpc_request_pool * pool,
+					    struct ptlrpc_request_pool *pool,
 					    const struct req_format *format)
 {
 	return ptlrpc_request_alloc_internal(imp, pool, format);
@@ -2692,7 +2692,7 @@ struct ptlrpc_replay_async_args {
  */
 static int ptlrpc_replay_interpret(const struct lu_env *env,
 				   struct ptlrpc_request *req,
-				   void * data, int rc)
+				   void *data, int rc)
 {
 	struct ptlrpc_replay_async_args *aa = data;
 	struct obd_import *imp = req->rq_import;
-- 
1.9.1

