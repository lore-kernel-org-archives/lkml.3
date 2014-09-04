Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaIDNUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:20:52 -0400
Received: from mail2.tiolive.com ([94.23.229.207]:39822 "EHLO
	mail2.tiolive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaIDNUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:20:51 -0400
From: Kirill Smelkov <kirr@nexedi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@nexedi.com>, Ken Chen <kenchen@google.com>
Subject: [PATCH] hugetlbfs: document that sticky mounts are allowed
Date: Thu,  4 Sep 2014 17:20:33 +0400
Message-Id: <1409836833-4320-1-git-send-email-kirr@nexedi.com>
X-Mailer: git-send-email 2.1.0.61.g11be0d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75897d60 (hugetlb: allow sticky directory mount option) added
support for mounting hugetlbfs with sticky option set, like /tmp is
usually mounted, but forgot to document that.

Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
---
 Documentation/vm/hugetlbpage.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
index bdd4bb9..b64e0af 100644
--- a/Documentation/vm/hugetlbpage.txt
+++ b/Documentation/vm/hugetlbpage.txt
@@ -274,7 +274,7 @@ This command mounts a (pseudo) filesystem of type hugetlbfs on the directory
 /mnt/huge.  Any files created on /mnt/huge uses huge pages.  The uid and gid
 options sets the owner and group of the root of the file system.  By default
 the uid and gid of the current process are taken.  The mode option sets the
-mode of root of file system to value & 0777.  This value is given in octal.
+mode of root of file system to value & 01777.  This value is given in octal.
 By default the value 0755 is picked. The size option sets the maximum value of
 memory (huge pages) allowed for that filesystem (/mnt/huge). The size is
 rounded down to HPAGE_SIZE.  The option nr_inodes sets the maximum number of
-- 
2.1.0.61.g11be0d6
