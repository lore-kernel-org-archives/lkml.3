Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaCOKpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 06:45:50 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:34207 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbaCOKpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 06:45:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwWAOwuJFNbskQL/2dsb2JhbABZgwaCSH4TvzUCAgEBgREXdIJmHCMYgQIkE4d9AdQCjmiEPwSYRQGSL4MuPA
Date: Sat, 15 Mar 2014 11:47:24 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sage <sage@inktank.com>
Subject: [PATCH 1/1] fs/ceph/inode.c: Remove get/set acl on symlinks
Message-Id: <20140315114724.5cef15fafccef903db1bbd80@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unsupported symlink operations.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 32d519d..704d714 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1616,8 +1616,6 @@ static const struct inode_operations ceph_symlink_iops = {
 	.getxattr = ceph_getxattr,
 	.listxattr = ceph_listxattr,
 	.removexattr = ceph_removexattr,
-	.get_acl = ceph_get_acl,
-	.set_acl = ceph_set_acl,
 };
 
 /*
-- 
1.8.4.5

