Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaAKLFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:05:09 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54452 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaAKLFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:05:06 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        monamagarwal123@gmail.com
Subject: [PATCH v3 2/2] Staging: lustre: Fix return does not need parantheses
Date: Sat, 11 Jan 2014 16:34:50 +0530
Message-Id: <1389438290-5987-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in
lustre/ldlm/interval_tree.c
ERROR: return is not a function, parentheses are not required

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---

Changes since version 1:
* Incoorect signed-off-by line

Changes since version 2:
* Forgot change log

 drivers/staging/lustre/lustre/ldlm/interval_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
index 7c956de..fb64aea 100644
--- a/drivers/staging/lustre/lustre/ldlm/interval_tree.c
+++ b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
@@ -585,8 +585,8 @@ EXPORT_SYMBOL(interval_erase);
 static inline int interval_may_overlap(struct interval_node *node,
 					  struct interval_node_extent *ext)
 {
-	return (ext->start <= node->in_max_high &&
-		ext->end >= interval_low(node));
+	return ext->start <= node->in_max_high &&
+		ext->end >= interval_low(node);
 }
 
 /*
-- 
1.7.9.5

