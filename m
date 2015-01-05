Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbbAEPH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:07:58 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35000 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbAEPH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:07:57 -0500
From: Valentin Rothberg <valentinrothberg@gmail.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: [PATCH] workqueue_internal.h: adjust tab alignment
Date: Mon,  5 Jan 2015 16:07:49 +0100
Message-Id: <1420470469-18092-1-git-send-email-valentinrothberg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment for the current_pwq member in the worker struct has
not been tab aligned, which is inconsistent with the rest of the
code.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
I am currently studying interrupt code. While reading, my eyes stopped at this
line to figure out what's wrong.  I hesitated to send this patch, but I think
it's less confusing (at least for my eyes) now.
---
 kernel/workqueue_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 4521587..3dcd4be 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -28,7 +28,7 @@ struct worker {
 
 	struct work_struct	*current_work;	/* L: work being processed */
 	work_func_t		current_func;	/* L: current_work's fn */
-	struct pool_workqueue	*current_pwq; /* L: current_work's pwq */
+	struct pool_workqueue	*current_pwq;	/* L: current_work's pwq */
 	bool			desc_valid;	/* ->desc is valid */
 	struct list_head	scheduled;	/* L: scheduled works */
 
-- 
1.9.1

