Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaIXG6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:58:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61218 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaIXG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:58:05 -0400
X-AuditID: cbfee68e-f79b46d000002b74-81-54226b791fd5
Date: Wed, 24 Sep 2014 06:58:01 +0000 (GMT)
From: Priya Bansal <p.bansal@samsung.com>
Subject: [PATCH] NULL pointer dereference in ecryptfs (ecryptfs_setxattr)
To: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, p.bansal@samsung.com
Reply-to: p.bansal@samsung.com
MIME-version: 1.0
X-MTR: 20140924063455530@p.bansal
Msgkey: 20140924063455530@p.bansal
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20140924063455530@p.bansal
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <1630743052.107781411541880641.JavaMail.weblogic@epmlwas02d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWyRsSkVrcyWynE4PNGa4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWxsfcFS8EN6YpZXb1MDYw/pLoYOTmEBJQlln7+yQxiSwiYSNy5
	3swKYYtJXLi3nq2LkQuoZimjREv7IUaYoiute9khEnMYJb5vnw3WwSKgKnHp8y4gm4ODTUBL
	4nmTL0hYWMBT4mT3GUaQehGBTkaJi409TBCb5STO7trDDmLzCghKnJz5hAVigaLEt5snWSDi
	ShJ3F99lg4jLSSyZepkJwuaVmNH+lAUmPu3rGqgPpCXOz9rACPPB4u+PoeL8Esdu74DqFZCY
	euYgI8idEgJqErNvBEOE+STWLHzLAlO+69RyZphV97fMhWqVkNja8gTsXWagM6d0P2SHsA0k
	jiyaw4ruFV4BD4l1V2+ygvwuIdDKITHjyCQmSFgJSHybfIhlAqPiLCQ9s5DMnYVkLrKaBYws
	qxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECU8Ppf8/6djDePGB9iFGAg1GJh3eCuFKIEGti
	WXFl7iFGU6DVE5mlRJPzgQkoryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8
	UWlOavEhRiYOTqkGxuIq4SYtbcNNU85dlnrY9uHW6ij+kCmO0x23Fq3mYhPXknrB/3HqRp78
	n2ya3h/11WyNTs9b92Jxuo9Dypq9795cE1/u1+xoZCqrFlJd+Xrhjvh/szdukPqa3tI37cz2
	6hn2t/Z8PlQ6u+Pi/5u5x3zuq0vcnXZTwrKz69Di0lmC1+c/nfQ8lkuJpTgj0VCLuag4EQC0
	izUCCAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t/tPt3KbKUQg5O/dSwu75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoWmslaGBgZEpUE1CWsbG
	3hcsBTekK2Z19TI1MP6Q6mLk5BASUJZY+vknM4gtIWAicaV1LzuELSZx4d56ti5GLqCaOYwS
	37fPZgVJsAioSlz6vAvI5uBgE9CSeN7kCxIWFvCUONl9hhGkXkSgk1HiYmMPE8QCOYmzu/aA
	DeUVEJQ4OfMJC8QCRYlvN0+yQMSVJO4uvssGEZeTWDL1MhOEzSsxo/0pC0x82tc1UIdKS5yf
	tYER5tDF3x9Dxfkljt3eAdUrIDH1zEFGkDslBNQkZt8IhgjzSaxZ+JYFpnzXqeXMMKvub5kL
	1SohsbXlCdi7zEBnTul+yA5hG0gcWTSHFd0rvAIeEuuu3mSdwCgzC0lqFpL2WUjakdUsYGRZ
	xSiaWpBcUJyUXmGsV5yYW1yal66XnJ+7iRGcbp4t3sH4/7z1IUYBDkYlHt4J4kohQqyJZcWV
	uYcYJTiYlUR4LeKAQrwpiZVVqUX58UWlOanFhxhNgRE1kVlKNDkfmArzSuINjU3MTY1NLQwM
	zc3NlMR5428lBQkJpCeWpGanphakFsH0MXFwSjUwsuzqmcyvH/96i/aiRQsWxuyWPt/mZ+uo
	Md23rKCyzCKoIn1SoenVOfNi7u19d8RslvE8uwJTwYZ/6sHZR2PaFu+aIR9450/f0fzNU3uu
	Fr4X/17Nt/jmxZt9rEb7DZ35/gsneZlsXrX7D9uxMPO2uzMKzp9PlVm15qjYxl9rn1xc0HNY
	kM0iW4mlOCPRUIu5qDgRABCciWZNAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8O6wF2m010623

This patch fixes the issue which was found in
 ecryptfs_setxattr(). Previously, while trying to create a file when ecryptfs
 is mounted over ext4 filesystem  with  encrypted view enabled, the kernel
 crashes. the reason being the function fsstack_copy_attr_all was trying to
 access dentry->d_inode which was null hence the kernel crashes with NULL
 pointer dereference. Now a check has been applied which prevents such
 condition.

>From 74856445756aba18f98aa5b98ad46e7d98f54737 Mon Sep 17 00:00:00 2001
From: Priya Bansal <p.bansal@samsung.com>
Date: Fri, 29 Aug 2014 10:27:27 +0530
Subject: [PATCH] Fix in ecryptfs_setxattr for NULL check before calling
 fsstack_copy_attr_all. This patch fixes the issue which was found in
 ecryptfs_setxattr(). Previously, while trying to create a file when ecryptfs
 is mounted over ext4 filesystem  with  encrypted view enabled, the kernel
 crashes. the reason being the function fsstack_copy_attr_all was trying to
 access dentry->d_inode which was null hence the kernel crashes with NULL
 pointer dereference. Now a check has been applied which prevents such
 condition.
Signed-off-by: Priya Bansal <p.bansal@samsung.com>
---
 linux-3.16.1/fs/ecryptfs/inode.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)
diff --git a/linux-3.16.1/fs/ecryptfs/inode.c b/linux-3.16.1/fs/ecryptfs/inode.c
index d4a9431..7da03e5 100644
--- a/linux-3.16.1/fs/ecryptfs/inode.c
+++ b/linux-3.16.1/fs/ecryptfs/inode.c
@@ -1031,6 +1031,8 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 {
  int rc = 0;
  struct dentry *lower_dentry;
+ struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
+  &ecryptfs_superblock_to_private(dentry->d_sb)->mount_crypt_stat;
 
  lower_dentry = ecryptfs_dentry_to_lower(dentry);
  if (!lower_dentry->d_inode->i_op->setxattr) {
@@ -1039,8 +1041,20 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
  }
 
  rc = vfs_setxattr(lower_dentry, name, value, size, flags);
- if (!rc)
-  fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
+ if (!rc) {
+  if (dentry->d_inode == NULL) {
+   if (mount_crypt_stat->flags
+     & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
+    rc = -EPERM;
+   else if (mount_crypt_stat->flags
+     & ECRYPTFS_XATTR_METADATA_ENABLED)
+    goto out;
+  } else {
+   fsstack_copy_attr_all(dentry->d_inode,
+     lower_dentry->d_inode);
+  }
+ }
+
 out:
  return rc;
 }
-- 
1.8.3.2

If you need any other details regarding this contribution, please contact me.  

Thanks & Regards 
Priya Bansal. 
E-mail: p.bansal@samsung.com
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
