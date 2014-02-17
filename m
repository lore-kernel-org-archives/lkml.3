Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaBQFgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:36:12 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52341 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaBQFgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:36:10 -0500
X-AuditID: cbfee690-b7f266d00000287c-e1-53019fc9b24c
Date: Mon, 17 Feb 2014 05:35:44 +0000 (GMT)
From: Pankaj Kumar <pankaj.k2@samsung.com>
Subject: [PATCH] smack lsm bug fixes
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        casey@schaufler-ca.com
Cc: pankaj.k2@samsung.com
Reply-to: pankaj.k2@samsung.com
MIME-version: 1.0
X-MTR: 20140217052906741@pankaj.k2
Msgkey: 20140217052906741@pankaj.k2
X-EPLocale: en_US.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140217052906741@pankaj.k2
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <21003892.325021392615344031.JavaMail.weblogic@epv6ml08>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42JZI2JSrXtyPmOwwa4nIhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj/bxd7AXbhCqOP17I0sD4RbCLkZNDSEBF4vTDE6xdjBwcEgIm
	EotP5oKEJQTEJC7cW8/WxcgFVLKUUWLS4duMEAkTiUe3L7FC9M5nlHi2WQDEZhFQlZi1cBpY
	nE1AW2LW83YWEFsYaP6aBz1gvSICRRLPPk1kArGZBeQkpr+exgQxR15i8aYdzCA2r4CgxMmZ
	T1gg7lGSuLvXFyKsLPHh8Cl2iBPEJf42PIKyeSVmtD9lgbDlJKZ9XcMMYUtLnJ+1gRHml8Xf
	H0PF+SWO3d7BBDGeV+LJ/WCYMbs3f2GDsAUkpp45CNWqLrHk3RmoVj6JNQvfssCM2XVqOTNM
	7/0tc6G+UpSY0v2QHWQ8s4CmxPpd+qieArFdJO613GKawKg8C0lqFpLuWQjdyEoWMLKsYhRN
	LUguKE5KLzLRK07MLS7NS9dLzs/dxAhMB6f/PZuwg/HeAetDjMnA+JjILCWanA9MJ3kl8YbG
	ZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLjmwVqZH8wa
	2xi+mmr1W9qrMX369kDehG3+7c21RwJmv7sf9WfdXgenRQkR15xs57XP3ZqnxfuITXLzY4us
	lrTzq7aG7F29UeHD5hsPTZZ+3D7j74yPXOuE8u+lsQRxTIhbM7OS2WniP+/Pgsp39+ywffG9
	b9J1v6jvTS8mVR/+sUZOzWj6QteFSizFGYmGWsxFxYkAbL3wgR0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t/t6bob5jMGG7zYpm5xedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DE1jrQwNDIxMgWoS0jLW
	z9vFXrBNqOL444UsDYxfBLsYOTmEBFQkTj88wQpiSwiYSDy6fQnKFpO4cG89G0TNfEaJZ5sF
	QGwWAVWJWQungdWwCWhLzHrezgJiCwPNWfOghxHEFhEoknj2aSITiM0sICcx/fU0Jog58hKL
	N+1gBrF5BQQlTs58AtTLAbRLSeLuXl+IsLLEh8On2CFOEJf42/AIyuaVmNH+lAXClpOY9nUN
	M4QtLXF+1gZGmJMXf38MFeeXOHZ7BxPEeF6JJ/eDYcbs3vyFDcIWkJh65iBUq7rEkndnoFr5
	JNYsfMsCM2bXqeXMML33t8yF+kpRYkr3Q3aQ8cwCmhLrd+mjegrEdpG413KLaQKj3CwkqVlI
	umchdCMrWcDIsopRNLUguaA4Kb3CSK84Mbe4NC9dLzk/dxMjOC09W7SD8d9560OMAhyMSjy8
	BtWMwUKsiWXFlbmHGCU4mJVEeN3jgEK8KYmVValF+fFFpTmpxYcYk4GxN5FZSjQ5H5gy80ri
	DY1NzE2NTS0MDM3NzUgTVhLnlb+VFCQkkJ5YkpqdmlqQWgSzhYmDU6qBsUsg1CxgYU/H0cTp
	z61ZSzi3sy+Z0Z7ldmLtLEaplZ96Ey60yr2M4Que6bVoe7vpyeo8z1OFAdKs4q8nHTzyIeFt
	T3XsymkdOzrCe0O1eXKTmBq/vfYuSDczXqvo8kVY5+mfWbvDpj/94PjFuvjGXlZmpXVtm65/
	f3EnKDIy6IqKpmmNnsMzJZbijERDLeai4kQAL4fDeo8DAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1H5aL5L014879

>From 8fa425d071b7d4cfdf6bcb89d789138a13529d06 Mon Sep 17 00:00:00 2001
From: Pankaj Kumar <pankaj.k2@samsung.com>
Date: Mon, 17 Feb 2014 10:36:26 +0530
Subject: [PATCH] smack lsm bug fixes

1. In order to remove any SMACK extended attribute from a file, a user
should have CAP_MAC_ADMIN capability. But any user without this
capability is able to remove SMACK64MMAP security attribute. This error
has been corrected by a modification in smack_inode_removexattr hook.

2. While setting extended attribute in smack_inode_setsecurity hook,
'-EACCES' error is returned if extended attribute size or value is not
correct. This is wrong error rather this is invalid extended attribute
case. Corrected error '-EINVAL' shall be returned.
---
 security/smack/smack_lsm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 14f52be..e1b1650 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -938,7 +938,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
-	    strcmp(name, XATTR_NAME_SMACKMMAP)) {
+	    strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
 		if (!smack_privileged(CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
@@ -2076,7 +2076,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	int rc = 0;
 
 	if (value == NULL || size > SMK_LONGLABEL || size == 0)
-		return -EACCES;
+		return -EINVAL;
 
 	skp = smk_import_entry(value, size);
 	if (skp == NULL)
-- 
1.8.1.2

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
