Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbaEPP6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:58:45 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:43511 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbaEPP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:58:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjASAFg0dlNXQB71/2dsb2JhbABZgwaCQqgmBQUFAZoZAgKBFhd0gmYcIxiBAiQTiEUB0hWFVYgWZIRHAQOPLYoqAYsRiAiDOTuBMQ
Date: Fri, 16 May 2014 17:58:41 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Nadia Yvette Chambers <nyc@holomorphy.com>
Subject: [PATCH 2/3] fs/hugetlbfs/inode.c: use static const for
 dentry_operations
Message-Id: <20140516175841.1ee0c7b694f4469988f43364@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...like other filesystems.

Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hugetlbfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1c766f4..78cface 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -939,7 +939,7 @@ static int get_hstate_idx(int page_size_log)
 	return h - hstates;
 }
 
-static struct dentry_operations anon_ops = {
+static const struct dentry_operations anon_ops = {
 	.d_dname = simple_dname
 };
 
-- 
1.8.4.5

