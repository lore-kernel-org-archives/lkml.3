Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3L3NqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:46:12 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:38323 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3L3NqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:46:03 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Zefan Li <lizefan@huawei.com>,
        Matthew Wilcox <matthew@wil.cx>, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 1/3] VFS: Add the declaration of shrink_pagecache_parent
Date: Mon, 30 Dec 2013 21:45:16 +0800
Message-Id: <110dae9d100e1a7221627fb9890c1c10d70ec3b1.1388409687.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1388409686.git.liwang@ubuntukylin.com>
References: <cover.1388409686.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQU5VTk5LS0tLSkJLTEhPQ01IV1kJDhceCFlBWS
	grPSQrOigoJDI1JDM#Oj8#KUFLVUtANiMkIj4oJDI1JDM#Oj8#KUFLVUtAKy8pJDU0JDI1JDM#Oj
	8#KUFJVUtAODQuNS8pIiQ4NUFLVUtAKT48MjQ1JDooMjpBS1VLQCspNC0yNTg#JDMuNTo1QUtVS0
	A*IjU6NjI4JDIrJDU0JDI1JDM#Oj8#KUFLVUtANi43LzIkKTgrLyQ*Mj09Pik#NS8kMjUkMz46Pz
	4pQUlVS0AyKyQvND86IiQ4NS8kSyRKS0tBS1VLQDIrJE4kNjI1Li8#JDg1LyRLJEpLQUtVS0AyKy
	RKJDYyNS4vPiQ4NS8kSyRKS0FLVUtAMiskSiQzNC4pJDg1LyRLJEpLS0FLVUtAMiskSEskNjI1Li
	8#JDg1LyRLJE5LQUtVS0AoLjkkPkFKVU5OWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSEND
	T0pKSk5OT0tCVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlPS043V1kSC1lBWUpKQlVIQlVKSU9VSkxLWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 include/linux/dcache.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index bf72e9a..6262171 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -249,6 +249,7 @@ extern struct dentry *d_find_any_alias(struct inode *inode);
 extern struct dentry * d_obtain_alias(struct inode *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
+extern void shrink_pagecache_parent(struct dentry *);
 extern void shrink_dcache_for_umount(struct super_block *);
 extern int d_invalidate(struct dentry *);
 
-- 
1.7.9.5

