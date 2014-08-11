Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaHKCs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:48:27 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36974 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKCs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:48:26 -0400
Date: Mon, 11 Aug 2014 11:46:53 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dcache: Fix no spaces at the start of a line in dcache.c
Message-ID: <20140811024653.GA11323@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style in dcache.c

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/dcache.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b7e8b20..7252cac 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2104,10 +2104,10 @@ struct dentry *d_lookup(const struct dentry *parent, const struct qstr *name)
 	struct dentry *dentry;
 	unsigned seq;
 
-        do {
-                seq = read_seqbegin(&rename_lock);
-                dentry = __d_lookup(parent, name);
-                if (dentry)
+	do {
+		seq = read_seqbegin(&rename_lock);
+		dentry = __d_lookup(parent, name);
+		if (dentry)
 			break;
 	} while (read_seqretry(&rename_lock, seq));
 	return dentry;
-- 
1.7.1

