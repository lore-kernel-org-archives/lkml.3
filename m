Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaIPNau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:30:50 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaIPNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:30:48 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] UBIFS: Fix trivial typo in power_cut_emulated()
Date: Tue, 16 Sep 2014 15:30:36 +0200
Message-Id: <1410874236-3125-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410874236-3125-1-git-send-email-richard@nod.at>
References: <1410874236-3125-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/withing/within/

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 177b015..b439e84 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2462,7 +2462,7 @@ static int power_cut_emulated(struct ubifs_info *c, int lnum, int write)
 
 			if (chance(1, 2)) {
 				d->pc_delay = 1;
-				/* Fail withing 1 minute */
+				/* Fail within 1 minute */
 				delay = prandom_u32() % 60000;
 				d->pc_timeout = jiffies;
 				d->pc_timeout += msecs_to_jiffies(delay);
-- 
1.8.4.5

