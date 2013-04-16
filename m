Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500Ab3DPS0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:26:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935351Ab3DPS0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:26:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 02/28] Include missing linux/magic.h inclusions [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-efi@vger.kernel.org,
        viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:25:58 +0100
Message-ID: <20130416182558.27773.22728.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include missing linux/magic.h inclusions where the source file is currently
expecting to get magic numbers through linux/proc_fs.h.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-efi@vger.kernel.org
---

 drivers/firmware/efivars.c |    1 +
 fs/proc/inode.c            |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7acafb8..0f102601 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -80,6 +80,7 @@
 #include <linux/slab.h>
 #include <linux/pstore.h>
 #include <linux/ctype.h>
+#include <linux/magic.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index d50224c..bd2f764 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/mount.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 

