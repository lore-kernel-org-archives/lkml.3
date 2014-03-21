Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbaCUQi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:38:28 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:13411 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760754AbaCUQiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:38:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMWADNqLFNbtAWg/2dsb2JhbABZgwaCSX4TwBECAgEBgRQXdIJmHCMYgQIkE4d9Ac90jmqEPwSYSAGSMYMuPA
Date: Fri, 21 Mar 2014 17:40:01 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sage <sage@inktank.com>
Subject: [PATCH 1/1 RESEND] fs/ceph/inode.c: Remove get/set acl on symlinks
Message-Id: <20140321174001.3a2c665e84aed66f387ca4fc@skynet.be>
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

