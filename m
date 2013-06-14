Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab3FNClt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:41:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57773 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759632Ab3FNCls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:41:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 24/33] quota: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:49 -0700
Message-Id: <4d5b25cd28ef11bd395be57955a431b945e1ac80.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/quota/dquot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b3d1ac9..017eaea 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2577,7 +2577,7 @@ static int do_proc_dqstats(struct ctl_table *table, int write,
 	return proc_dointvec(table, write, buffer, lenp, ppos);
 }
 
-static ctl_table fs_dqstats_table[] = {
+static struct ctl_table fs_dqstats_table[] = {
 	{
 		.procname	= "lookups",
 		.data		= &dqstats.stat[DQST_LOOKUPS],
@@ -2646,7 +2646,7 @@ static ctl_table fs_dqstats_table[] = {
 	{ },
 };
 
-static ctl_table fs_table[] = {
+static struct ctl_table fs_table[] = {
 	{
 		.procname	= "quota",
 		.mode		= 0555,
@@ -2655,7 +2655,7 @@ static ctl_table fs_table[] = {
 	{ },
 };
 
-static ctl_table sys_table[] = {
+static struct ctl_table sys_table[] = {
 	{
 		.procname	= "fs",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

