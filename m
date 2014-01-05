Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaAEUSO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:18:14 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58188 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaAEUSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:18:13 -0500
Date: Mon, 6 Jan 2014 01:48:07 +0530
From: MonamAgarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, monamagarwal123@gmail.com,
        andreas.dilger@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: lustre: Fix return does not need parantheses
Message-ID: <52c9be03.c394420a.7a22.36eb@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in
lustre/ldlm/interval_tree.c
ERROR: return is not a function, parentheses are not required

Signed-off-by: MonamAgarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
index f61bf19..9338203 100644
--- a/drivers/staging/lustre/lustre/ldlm/interval_tree.c
+++ b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
@@ -578,8 +578,8 @@ EXPORT_SYMBOL(interval_erase);
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

