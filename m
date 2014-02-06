Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaBFUwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:52:31 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:43054 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbaBFUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:52:30 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQMAIn181JbsGxA/2dsb2JhbABZgwyCQ4EOvC8EAoEMF3SCUxMcIxiBAjeICQHNFBeOFmQdhCIEmCoBik+HUoMuO4Es
Date: Thu, 6 Feb 2014 21:52:27 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rdunlap@infradead.org
Subject: [PATCH 1/1] cifs: Add __init macro to cifs_init_inodecache
Message-Id: <20140206215227.b8dc23f4fc4b42a7cc085482@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cifs_init_inodecache is only called by __init init_cifs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 849f613..e8ae832 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1005,7 +1005,7 @@ cifs_init_once(void *inode)
 	init_rwsem(&cifsi->lock_sem);
 }
 
-static int
+static int __init
 cifs_init_inodecache(void)
 {
 	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
-- 
1.8.1.4

