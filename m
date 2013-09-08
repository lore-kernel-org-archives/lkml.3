Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3IHJWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 05:22:13 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33745 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990Ab3IHJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 05:22:11 -0400
X-Sasl-enc: wP49Wy3bzOjGM1g5WOoLMsI8iLzUwjpa8u+4vKLpGVpy 1378632128
Subject: [PATCH] vfs - and export user_path_mntpointat()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 08 Sep 2013 17:22:04 +0800
Message-ID: <20130908092203.16435.73547.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And, of course, export the function for module use, oops!
---
 fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/namei.c b/fs/namei.c
index 24f7562..849eadcf 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4347,6 +4347,7 @@ const struct inode_operations page_symlink_inode_operations = {
 };
 
 EXPORT_SYMBOL(user_path_at);
+EXPORT_SYMBOL(path_mntpointat);
 EXPORT_SYMBOL(follow_down_one);
 EXPORT_SYMBOL(follow_down);
 EXPORT_SYMBOL(follow_up);

