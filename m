Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab3JVWbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:31:14 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:56450 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755710Ab3JVWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3868:3871:5007:6261:10004:10026:10848:11026:11473:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: start40_a3b8496dd609
X-Filterd-Recvd-Size: 2001
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com
Subject: [PATCH 17/24] ocfs2: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:30:00 -0700
Message-Id: <f5f72664f6f5b3b433149e515cacbd0d90bf99f9.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/stackglue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..cb7ec0b 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -643,7 +643,7 @@ error:
 
 #define FS_OCFS2_NM		1
 
-static ctl_table ocfs2_nm_table[] = {
+static struct ctl_table ocfs2_nm_table[] = {
 	{
 		.procname	= "hb_ctl_path",
 		.data		= ocfs2_hb_ctl_path,
@@ -654,7 +654,7 @@ static ctl_table ocfs2_nm_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_mod_table[] = {
+static struct ctl_table ocfs2_mod_table[] = {
 	{
 		.procname	= "nm",
 		.data		= NULL,
@@ -665,7 +665,7 @@ static ctl_table ocfs2_mod_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_kern_table[] = {
+static struct ctl_table ocfs2_kern_table[] = {
 	{
 		.procname	= "ocfs2",
 		.data		= NULL,
@@ -676,7 +676,7 @@ static ctl_table ocfs2_kern_table[] = {
 	{ }
 };
 
-static ctl_table ocfs2_root_table[] = {
+static struct ctl_table ocfs2_root_table[] = {
 	{
 		.procname	= "fs",
 		.data		= NULL,
-- 
1.8.1.2.459.gbcd45b4.dirty

