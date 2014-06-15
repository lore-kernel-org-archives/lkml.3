Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaFOGfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:35:39 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:43839 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbaFOGfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:35:38 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuIOAPA9nVNXQzGY/2dsb2JhbABagw2CR6hHBgEDAQaZIAICgQMXdYQxExwjGIECJBOIRgHPI4VjiC9khEoBA49silYBk1iDQjuBMQ
Date: Sun, 15 Jun 2014 08:34:22 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, sage <sage@inktank.com>
Subject: [PATCH 1/1 RESEND] fs/ceph/export.c: add static to local function
Message-Id: <20140615083422.8d3b4ab0f2b1c70eeef9ae03@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph_get_parent is only used in fs/ceph/export.c

Cc: Sage Weil <sage@inktank.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ceph/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 00d6af6..8d7d782 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -169,7 +169,7 @@ static struct dentry *__get_parent(struct super_block *sb,
 	return dentry;
 }
 
-struct dentry *ceph_get_parent(struct dentry *child)
+static struct dentry *ceph_get_parent(struct dentry *child)
 {
 	/* don't re-export snaps */
 	if (ceph_snap(child->d_inode) != CEPH_NOSNAP)
-- 
1.8.4.5

