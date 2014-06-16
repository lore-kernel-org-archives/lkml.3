Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaFPLT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:19:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48513 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaFPLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:19:54 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v4 4/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Mon, 16 Jun 2014 21:13:19 +1000
Message-Id: <1402917203-12798-5-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402917203-12798-1-git-send-email-askb23@gmail.com>
References: <1402917203-12798-1-git-send-email-askb23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

fixed: WARNING: Missing a blank line after declarations
Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 6907a16..f83e6f2 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -127,6 +127,7 @@ void ccc_key_fini(const struct lu_context *ctx,
 			 struct lu_context_key *key, void *data)
 {
 	struct ccc_thread_info *info = data;
+
 	OBD_SLAB_FREE_PTR(info, ccc_thread_kmem);
 }
 
@@ -145,6 +146,7 @@ void ccc_session_key_fini(const struct lu_context *ctx,
 				 struct lu_context_key *key, void *data)
 {
 	struct ccc_session *session = data;
+
 	OBD_SLAB_FREE_PTR(session, ccc_session_kmem);
 }
 
@@ -573,6 +575,7 @@ void ccc_lock_delete(const struct lu_env *env,
 void ccc_lock_fini(const struct lu_env *env, struct cl_lock_slice *slice)
 {
 	struct ccc_lock *clk = cl2ccc_lock(slice);
+
 	OBD_SLAB_FREE_PTR(clk, ccc_lock_kmem);
 }
 
@@ -753,6 +756,7 @@ int ccc_io_one_lock(const struct lu_env *env, struct cl_io *io,
 		    loff_t start, loff_t end)
 {
 	struct cl_object *obj = io->ci_obj;
+
 	return ccc_io_one_lock_index(env, io, enqflags, mode,
 				     cl_index(obj, start), cl_index(obj, end));
 }
-- 
1.9.0

