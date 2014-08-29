Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaH2PDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:03:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29806 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaH2PDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:03:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-7c-54009627bc6b
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: r.krypa@samsung.com, havner@gmail.com, m.lis@samsung.com,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Subject: [PATCH 1/3] Small fixes in comments describing function parameters
Date: Fri, 29 Aug 2014 17:02:53 +0200
Message-id: <1409324575-12057-1-git-send-email-l.pawelczyk@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsVy+t/xa7rq0xhCDJ5f5rO4t+0Xm8X/1zoW
	fY+DLM5MWshkcXnXHDaLDz2P2CzuHnzLYvF20gpmi/MXzrE7cHrsnHWX3ePa7kiPj09vsXj0
	bVnF6HF0/yI2j8+b5ALYorhsUlJzMstSi/TtErgyLq5vZSv4w1cxoe01YwPjb+4uRk4OCQET
	iadLrjNB2GISF+6tZwOxhQSWMkqc6avpYuQCsnuZJK7OfsICkmATMJD4fmEvM0hCRKCZSWLG
	thVg3cwCehKTluwGKxIW8JZ4eKEBKM7BwSKgKnHqUgxImFfAXWL+hzZ2iGVyEr3b3jBPYORe
	wMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMkeL7sYFx8zOoQowAHoxIPb8H//8FCrIll
	xZW5hxglOJiVRHjXTWAIEeJNSaysSi3Kjy8qzUktPsTIxMEp1cDos/js4589PTKi21bWrjbl
	EH7NqFDL8PqQwzb1YyHTFDMD0/N+pHPF3LuucOKC0rQl/qurMo+KrPm7VIm38fwBbkGTiUe2
	zHoVUrHKU+VkzGNJ/6obO6zOnCszWe7K8oXVxEFtzcmXAS/SrmVveWr66MhG/X3lKlqsU05v
	X/2Az2tyc/qMy3LNSizFGYmGWsxFxYkAsmpFtfwBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
---
 security/smack/smack_lsm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 154548e..478d99e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -771,8 +771,8 @@ static void smack_inode_free_security(struct inode *inode)
 
 /**
  * smack_inode_init_security - copy out the smack from an inode
- * @inode: the inode
- * @dir: unused
+ * @inode: the newly created inode
+ * @dir: containing directory object
  * @qstr: unused
  * @name: where to put the attribute name
  * @value: where to put the attribute value
@@ -923,10 +923,10 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 
 /**
  * smack_inode_rename - Smack check on rename
- * @old_inode: the old directory
- * @old_dentry: unused
- * @new_inode: the new directory
- * @new_dentry: unused
+ * @old_inode: unused
+ * @old_dentry: the old object
+ * @new_inode: unused
+ * @new_dentry: the new object
  *
  * Read and write access is required on both the old and
  * new directories.
@@ -1017,7 +1017,7 @@ static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 
 /**
  * smack_inode_getattr - Smack check for getting attributes
- * @mnt: unused
+ * @mnt: vfsmount of the object
  * @dentry: the object
  *
  * Returns 0 if access is permitted, an error code otherwise
@@ -1042,8 +1042,8 @@ static int smack_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
  * smack_inode_setxattr - Smack check for setting xattrs
  * @dentry: the object
  * @name: name of the attribute
- * @value: unused
- * @size: unused
+ * @value: value of the attribute
+ * @size: size of the value
  * @flags: unused
  *
  * This protects the Smack attribute explicitly.
-- 
1.9.3

