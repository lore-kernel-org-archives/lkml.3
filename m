Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3LPPLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:11:20 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:54793 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab3LPPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:57 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@inktank.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH 3/5] VFS: Add the declaration of shrink_pagecache_parent
Date: Mon, 16 Dec 2013 07:00:07 -0800
Message-Id: <1e2c2695163198cc660ef7a8761edcdae9e01612.1387205337.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
In-Reply-To: <cover.1387205337.git.liwang@ubuntukylin.com>
References: <cover.1387205337.git.liwang@ubuntukylin.com>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlMVU5PQkJCQklITEtNS05PTFdZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0
	AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDU0LyQ9Oj
	Y0LigkPzQ2OjI1JCgrPSQ9OjI3QUpLVUtAKC45JD5BSlVOTlkG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SUtNS05OTU5JVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUlKTUI3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
---
 include/linux/dcache.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 57e87e7..ce11098 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -247,6 +247,7 @@ extern struct dentry *d_find_any_alias(struct inode *inode);
 extern struct dentry * d_obtain_alias(struct inode *);
 extern void shrink_dcache_sb(struct super_block *);
 extern void shrink_dcache_parent(struct dentry *);
+extern void shrink_pagecache_parent(struct dentry *);
 extern void shrink_dcache_for_umount(struct super_block *);
 extern int d_invalidate(struct dentry *);
 
-- 
1.7.9.5

