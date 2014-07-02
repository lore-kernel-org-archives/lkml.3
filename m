Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbaGBUKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:10:08 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:5097 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbaGBUKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:10:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IADZmtFNXQBPR/2dsb2JhbABagw2sZwUBAQEBAQEFAW4BmWeBBxd1hDEvI4EaN4hGAcdjF4VwiGVNHYQtBZpti0qIQINFO4Ey
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>,
        cluster-devel@redhat.com
Subject: [PATCH 1/1] fs/gfs2/super.c: replace seq_printf by seq_puts
Date: Wed,  2 Jul 2014 22:08:46 +0200
Message-Id: <1404331726-4858-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix checkpatch warnings:
"WARNING: Prefer seq_puts to seq_printf"

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/super.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 1319b5c..669e92e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1300,7 +1300,7 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	int val;
 
 	if (is_ancestor(root, sdp->sd_master_dir))
-		seq_printf(s, ",meta");
+		seq_puts(s, ",meta");
 	if (args->ar_lockproto[0])
 		seq_printf(s, ",lockproto=%s", args->ar_lockproto);
 	if (args->ar_locktable[0])
@@ -1308,13 +1308,13 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (args->ar_hostdata[0])
 		seq_printf(s, ",hostdata=%s", args->ar_hostdata);
 	if (args->ar_spectator)
-		seq_printf(s, ",spectator");
+		seq_puts(s, ",spectator");
 	if (args->ar_localflocks)
-		seq_printf(s, ",localflocks");
+		seq_puts(s, ",localflocks");
 	if (args->ar_debug)
-		seq_printf(s, ",debug");
+		seq_puts(s, ",debug");
 	if (args->ar_posix_acl)
-		seq_printf(s, ",acl");
+		seq_puts(s, ",acl");
 	if (args->ar_quota != GFS2_QUOTA_DEFAULT) {
 		char *state;
 		switch (args->ar_quota) {
@@ -1334,7 +1334,7 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",quota=%s", state);
 	}
 	if (args->ar_suiddir)
-		seq_printf(s, ",suiddir");
+		seq_puts(s, ",suiddir");
 	if (args->ar_data != GFS2_DATA_DEFAULT) {
 		char *state;
 		switch (args->ar_data) {
@@ -1351,7 +1351,7 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",data=%s", state);
 	}
 	if (args->ar_discard)
-		seq_printf(s, ",discard");
+		seq_puts(s, ",discard");
 	val = sdp->sd_tune.gt_logd_secs;
 	if (val != 30)
 		seq_printf(s, ",commit=%d", val);
@@ -1382,11 +1382,11 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",errors=%s", state);
 	}
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		seq_printf(s, ",nobarrier");
+		seq_puts(s, ",nobarrier");
 	if (test_bit(SDF_DEMOTE, &sdp->sd_flags))
-		seq_printf(s, ",demote_interface_used");
+		seq_puts(s, ",demote_interface_used");
 	if (args->ar_rgrplvb)
-		seq_printf(s, ",rgrplvb");
+		seq_puts(s, ",rgrplvb");
 	return 0;
 }
 
-- 
1.8.4.5

