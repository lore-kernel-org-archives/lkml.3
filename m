Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3KEHWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:22:14 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55366 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3KEHWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:22:11 -0500
X-Originating-IP: 109.242.2.94
From: Aldo Iljazi <mail@aldo.io>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] BTRFS: fixed a coding style issue
Date: Tue,  5 Nov 2013 09:21:55 +0200
Message-Id: <1383636115-5291-2-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383636115-5291-1-git-send-email-mail@aldo.io>
References: <1383636115-5291-1-git-send-email-mail@aldo.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line 265: Inserted a space before the open parenthesis.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 fs/btrfs/async-thread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index 08cc08f..8aec751 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -262,7 +262,7 @@ static struct btrfs_work *get_next_work(struct btrfs_worker_thread *worker,
 	struct btrfs_work *work = NULL;
 	struct list_head *cur = NULL;
 
-	if(!list_empty(prio_head))
+	if (!list_empty(prio_head))
 		cur = prio_head->next;
 
 	smp_mb();
-- 
1.8.3.2

