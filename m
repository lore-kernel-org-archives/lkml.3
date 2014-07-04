Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbaGDTsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:48:16 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:59209 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757174AbaGDTsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:48:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMAEoEt1NbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BmWeBCxd1hGAjgRo3iEYBtU2VIoVwiE5kHYQtBZAJim2UDINFO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/1] kernfs: kernel-doc warning fix
Date: Fri,  4 Jul 2014 21:47:53 +0200
Message-Id: <1404503273-32469-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/static_name/name_is_static

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/kernfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index d895b4b..4429d6d 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -896,7 +896,7 @@ const struct file_operations kernfs_file_fops = {
  * @ops: kernfs operations for the file
  * @priv: private data for the file
  * @ns: optional namespace tag of the file
- * @static_name: don't copy file name
+ * @name_is_static: don't copy file name
  * @key: lockdep key for the file's active_ref, %NULL to disable lockdep
  *
  * Returns the created node on success, ERR_PTR() value on error.
-- 
1.9.1

