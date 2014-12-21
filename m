Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaLUIcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 03:32:23 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45334 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaLUIcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 03:32:21 -0500
From: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
To: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org,
        Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Subject: [PATCH] kernel: fixed a space coding style issue
Date: Sun, 21 Dec 2014 14:02:02 +0530
Message-Id: <1419150722-8313-1-git-send-email-gangs.freelancer@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed a space coding style issue in pid.c which was found when
running checkpatch.pl on pid.c

Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
---
 kernel/pid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index cd36a5e..ad9d780 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -72,7 +72,7 @@ struct pid_namespace init_pid_ns = {
 		.refcount       = ATOMIC_INIT(2),
 	},
 	.pidmap = {
-		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
+		[0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
 	.nr_hashed = PIDNS_HASH_ADDING,
@@ -267,7 +267,7 @@ void free_pid(struct pid *pid)
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
 		hlist_del_rcu(&upid->pid_chain);
-		switch(--ns->nr_hashed) {
+		switch (--ns->nr_hashed) {
 		case 2:
 		case 1:
 			/* When all that is left in the pid namespace
-- 
1.7.9.5

