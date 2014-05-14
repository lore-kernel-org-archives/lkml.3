Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaENQ53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:57:29 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:3758 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbaENQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:57:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4OAHafc1NXQ68k/2dsb2JhbABZgwaCQaooBAEBAQEBAQUBmh2BIxd0gmYcIxiBAiQTiEUB0SUXhVSIFmSERwEDjyqKJgGLDYgHgzg7gTE
Date: Wed, 14 May 2014 18:57:23 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 1/1] fs/efivarfs/super.c: use static const for
 dentry_operations
Message-Id: <20140514185723.fd8595dbff3805e9989ec7d3@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...like other filesystems.

Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efivarfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index becc725..0a48886 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -83,7 +83,7 @@ static int efivarfs_d_hash(const struct dentry *dentry, struct qstr *qstr)
 	return 0;
 }
 
-static struct dentry_operations efivarfs_d_ops = {
+static const struct dentry_operations efivarfs_d_ops = {
 	.d_compare = efivarfs_d_compare,
 	.d_hash = efivarfs_d_hash,
 	.d_delete = always_delete_dentry,
-- 
1.9.1
