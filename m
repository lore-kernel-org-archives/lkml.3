Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab3DYLDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:03:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53932 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594Ab3DYLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:02:43 -0400
X-AuditID: cbfee68f-b7f066d000003683-a3-51790d51e0fa
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: add a tracepoint on f2fs_new_inode
Date: Thu, 25 Apr 2013 20:01:36 +0900
Message-id: <1366887697-24627-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1366887697-24627-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zY91A3spAgytv+Syu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvi9cwZbQQ9XxZct
	TUwNjMs4uhg5OSQETCRWNj9kgrDFJC7cW8/WxcjFISSwjFHi3qIj7DBFa1t2MkMkFjFK7J69
	khXCaWOS+Lx2B5DDwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SeBSQhLGArcWj2ZTYQ
	m0VAVeL8u3VgcV4Bd4k1y8+xQWzTlVj9/znYZk4BD4ktf3vAzhMCqnnQtQ/sCgmB32wSOxe0
	sEAMEpD4NvkQC8gREgKyEpsOMEPMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS
	9ZLzczcxQoK2fwfj3QPWhxiTgcZNZJYSTc4HBn1eSbyhsZmRhamJqbGRuaUZacJK4rxqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhj7vvBd2nIj2XzuhxeXbrh8e6vRsO7aYXVPlpY1
	HAmqOVbfw7Vv7/wZVdb8KcHR3V9oN9Oei4YnBUNFlQV+/Xj88rr5whPVBe9eGOY88Xr5UHjr
	s1OCB8pCVtbUbJ2+4ZT5g6xZudN0eyS/WS5ITvmx5sBCjpXqDMcSX2WXT09tLXm5YOOilplV
	SizFGYmGWsxFxYkAvHU/Q3ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd1A3spAg5e7uC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z4vXMGW0EPV8WXLU1MDYzLOLoYOTkkBEwk1rbsZIawxSQu3FvP1sXIxSEk
	sIhRYvfslawQThuTxOe1O4AcDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCAJYQFb
	iUOzL7OB2CwCqhLn360Di/MKuEusWX6ODWKbrsTq/8/ZQWxOAQ+JLX97mEBsIaCaB137mCcw
	8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwTz6R3MK5qsDjEKMDBqMTDK/CqPFCI
	NbGsuDL3EKMEB7OSCC/zj4pAId6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HxmteSbyhsYmZ
	kaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTCGby7Y16EnfUnEm6EoovCj
	0hzN2Msxd+WzNT1YAxU1nVReT12U2net8Lg3zz7/6xqlMxV+O69+w/JRak/I3YVHm75vOnZk
	la3x/tfaccKZrw04Jl+WOO7n/e+4acBB/c8n2e9WR2iwPVl7m+nWpu3PH18XmreovbdPlN+u
	sND3z0LpyPLHNV+VWIozEg21mIuKEwGDJD1nzQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can help when debugging the free nid allocation flows.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c             | 3 ++-
 include/trace/events/f2fs.h | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index c57fd18..4aa26e5 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -63,7 +63,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 		nid_free = true;
 		goto out;
 	}
-
+	trace_f2fs_new_inode(inode, 0);
 	mark_inode_dirty(inode);
 	return inode;
 
@@ -71,6 +71,7 @@ out:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 fail:
+	trace_f2fs_new_inode(inode, err);
 	iput(inode);
 	if (nid_free)
 		alloc_nid_failed(sbi, ino);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index b2b2f72..52ae548 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -197,6 +197,13 @@ DEFINE_EVENT(f2fs__inode, f2fs_evict_inode,
 	TP_ARGS(inode)
 );
 
+DEFINE_EVENT(f2fs__inode_exit, f2fs_new_inode,
+
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret)
+);
+
 TRACE_EVENT(f2fs_unlink_enter,
 
 	TP_PROTO(struct inode *dir, struct dentry *dentry),
-- 
1.8.1.3.566.gaa39828

