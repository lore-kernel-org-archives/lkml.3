Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbaAKUEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 15:04:01 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37630 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaAKUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 15:03:59 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, bergwolf@gmail.com, andreas.dilger@intel.com,
        keith.mannthey@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] Staging: lustre: :Fix line over 80 character warning
Date: Sun, 12 Jan 2014 01:33:44 +0530
Message-Id: <1389470625-26306-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes the following checkpatch.pl error in
lustre/ldlm/ldlm_flock.c
WARNING: line over 80 characters in the file 

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index 07a2c33..2b5c2fe 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -468,7 +468,8 @@ reprocess:
 			new->l_policy_data.l_flock.end + 1;
 		new2->l_conn_export = lock->l_conn_export;
 		if (lock->l_export != NULL) {
-			new2->l_export = class_export_lock_get(lock->l_export, new2);
+			new2->l_export =
+				class_export_lock_get(lock->l_export, new2);
 			if (new2->l_export->exp_lock_hash &&
 			    hlist_unhashed(&new2->l_exp_hash))
 				cfs_hash_add(new2->l_export->exp_lock_hash,
-- 
1.7.9.5

