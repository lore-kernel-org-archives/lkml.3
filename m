Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbaGCQgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:36:45 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55189 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbaGCQgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:36:43 -0400
From: Hao Lan <bylanhao@gmail.com>
To: Eric Paris <eparis@redhat.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hao Lan <bylanhao@gmail.com>
Subject: [PATCH 1/1] [trivial] Fix a coding style in include/linux/audit.h
Date: Fri,  4 Jul 2014 00:36:25 +0800
Message-Id: <1404405385-4883-1-git-send-email-bylanhao@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions have the opening brace at the beginning of the next line, but these
two functions in this file do not.

Signed-off-by: Hao Lan <bylanhao@gmail.com>
---
 include/linux/audit.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 22cfddb..24786d9 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -170,7 +170,8 @@ static inline void audit_getname(struct filename *name)
 }
 static inline void audit_inode(struct filename *name,
 				const struct dentry *dentry,
-				unsigned int parent) {
+				unsigned int parent)
+{
 	if (unlikely(!audit_dummy_context())) {
 		unsigned int flags = 0;
 		if (parent)
@@ -187,7 +188,8 @@ static inline void audit_inode_parent_hidden(struct filename *name,
 }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry,
-				     const unsigned char type) {
+				     const unsigned char type)
+{
 	if (unlikely(!audit_dummy_context()))
 		__audit_inode_child(parent, dentry, type);
 }
-- 
1.9.3

