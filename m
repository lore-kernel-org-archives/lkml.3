Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaEGUjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:39:54 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:53287 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbaEGUjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:39:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocXALaZalNXQBiQ/2dsb2JhbABagwaDPahrCgUBmgoCAoEdF3SCZhwjGIECJBOIRQHQNoVWiHyERgEDjxuKGwGSe4M2Ow
Date: Wed, 7 May 2014 22:39:45 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/seccomp.c: kernel-doc warning fix
Message-Id: <20140507223945.c4fbf82c3430fe5e43d97c08@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ fix small typo

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/seccomp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b35c215..f6d76be 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -39,7 +39,7 @@
  *         is only needed for handling filters shared across tasks.
  * @prev: points to a previously installed, or inherited, filter
  * @len: the number of instructions in the program
- * @insns: the BPF program instructions to evaluate
+ * @insnsi: the BPF program instructions to evaluate
  *
  * seccomp_filter objects are organized in a tree linked via the @prev
  * pointer.  For any task, it appears to be a singly-linked list starting
@@ -220,7 +220,7 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 		return -ENOMEM;
 
 	/*
-	 * Installing a seccomp filter requires that the task have
+	 * Installing a seccomp filter requires that the task has
 	 * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
 	 * This avoids scenarios where unprivileged tasks can affect the
 	 * behavior of privileged children.
-- 
1.8.4.5

