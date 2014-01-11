Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaAKNre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 08:47:34 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40893 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaAKNr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 08:47:27 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, bergwolf@gmail.com, andreas.dilger@intel.com,
        keith.mannthey@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: lustre: :Fix line over 80 character warning
Date: Sat, 11 Jan 2014 19:17:12 +0530
Message-Id: <1389448032-9713-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in
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

