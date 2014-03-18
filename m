Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaCRR2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:28:17 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:34758 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbaCRR2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:28:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAOALeBKFNbsn1//2dsb2JhbABagwaCSH4Tv1gCAoEpF3SCUxMcIxiBAiQTh30B0DONfmSEPwEDmEUBilmHV4MuPIEs
Date: Tue, 18 Mar 2014 18:29:47 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, hch <hch@infradead.org>
Subject: [PATCH v2] fs/freevxfs/vxfs_lookup.c: Update function comment
Message-Id: <20140318182947.49a22064ba6a0e484ffac1f3@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nameidata was replaced by flags in
00cd8dd3bf95f2 ("stop passing nameidata to ->lookup()")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/freevxfs/vxfs_lookup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index 25d4099..99c7f0a 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -192,7 +192,7 @@ vxfs_inode_by_name(struct inode *dip, struct dentry *dp)
  * vxfs_lookup - lookup pathname component
  * @dip:	dir in which we lookup
  * @dp:		dentry we lookup
- * @nd:		lookup nameidata
+ * @flags:	lookup flags
  *
  * Description:
  *   vxfs_lookup tries to lookup the pathname component described
-- 
1.8.4.5

