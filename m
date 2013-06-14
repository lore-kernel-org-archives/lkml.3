Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab3FNCll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:41:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59768 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759632Ab3FNClj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:41:39 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 23/33] ocfs2: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:48 -0700
Message-Id: <0cbf3d3295fe11804974201af9d31898de8f0752.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
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

