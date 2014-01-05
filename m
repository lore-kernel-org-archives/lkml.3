Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaAEUL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 15:11:57 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48997 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAEUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:11:56 -0500
Date: Mon, 6 Jan 2014 01:41:51 +0530
From: MonamAgarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        monamagarwal123@gmail.com
Subject: [PATCH 1/2] Staging: lustre: Fix line length exceeding 80 characters
Message-ID: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in
lustre/ldlm/interval_tree.c
WARNING: line over 80 characters in the file

Signed-off-by: MonamAgarwal <monamagarwal123@gmail.com>
---
 drivers/staging/lustre/lustre/ldlm/interval_tree.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
index 1de1d8e..f61bf19 100644
--- a/drivers/staging/lustre/lustre/ldlm/interval_tree.c
+++ b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
@@ -429,7 +429,8 @@ static void interval_erase_color(struct interval_node *node,
 					struct interval_node *o_left;
 					o_left = tmp->in_left;
 					if (o_left)
-						o_left->in_color = INTERVAL_BLACK;
+						o_left->in_color =
+							INTERVAL_BLACK;
 					tmp->in_color = INTERVAL_RED;
 					__rotate_right(tmp, root);
 					tmp = parent->in_right;
@@ -437,7 +438,8 @@ static void interval_erase_color(struct interval_node *node,
 				tmp->in_color = parent->in_color;
 				parent->in_color = INTERVAL_BLACK;
 				if (tmp->in_right)
-					tmp->in_right->in_color = INTERVAL_BLACK;
+					tmp->in_right->in_color =
+						INTERVAL_BLACK;
 				__rotate_left(parent, root);
 				node = *root;
 				break;
@@ -460,7 +462,8 @@ static void interval_erase_color(struct interval_node *node,
 					struct interval_node *o_right;
 					o_right = tmp->in_right;
 					if (o_right)
-						o_right->in_color = INTERVAL_BLACK;
+						o_right->in_color =
+							INTERVAL_BLACK;
 					tmp->in_color = INTERVAL_RED;
 					__rotate_left(tmp, root);
-- 					tmp = parent->in_left;
1.7.9.5

