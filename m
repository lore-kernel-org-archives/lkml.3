Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbaFRIY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:24:58 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57794 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705AbaFRIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:24:54 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v7 4/8] staging: lustre: lclient: lcommon_cl.c fixing coding style issues
Date: Wed, 18 Jun 2014 18:23:52 +1000
Message-Id: <1403079836-9304-5-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403079836-9304-1-git-send-email-askb23@gmail.com>
References: <1403079836-9304-1-git-send-email-askb23@gmail.com>
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
index 1b0c216..1f39219 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -126,6 +126,7 @@ void ccc_key_fini(const struct lu_context *ctx,
 			 struct lu_context_key *key, void *data)
 {
 	struct ccc_thread_info *info = data;
+
 	OBD_SLAB_FREE_PTR(info, ccc_thread_kmem);
 }
 
@@ -144,6 +145,7 @@ void ccc_session_key_fini(const struct lu_context *ctx,
 				 struct lu_context_key *key, void *data)
 {
 	struct ccc_session *session = data;
+
 	OBD_SLAB_FREE_PTR(session, ccc_session_kmem);
 }
 
@@ -572,6 +574,7 @@ void ccc_lock_delete(const struct lu_env *env,
 void ccc_lock_fini(const struct lu_env *env, struct cl_lock_slice *slice)
 {
 	struct ccc_lock *clk = cl2ccc_lock(slice);
+
 	OBD_SLAB_FREE_PTR(clk, ccc_lock_kmem);
 }
 
@@ -733,6 +736,7 @@ int ccc_io_one_lock(const struct lu_env *env, struct cl_io *io,
 		    loff_t start, loff_t end)
 {
 	struct cl_object *obj = io->ci_obj;
+
 	return ccc_io_one_lock_index(env, io, enqflags, mode,
 				     cl_index(obj, start), cl_index(obj, end));
 }
-- 
1.9.0

