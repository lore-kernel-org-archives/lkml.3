Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaAUJ4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:56:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50443 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbaAUJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:56:00 -0500
X-AuditID: cbfee690-b7f266d00000287c-c4-52de442fac64
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: move a branch for code redability
Date: Tue, 21 Jan 2014 18:54:34 +0900
Message-id: <1390298075-21458-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1390298075-21458-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1390298075-21458-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zI119l3tBBt1L5Cyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgypj6qoexYC9bRcvG
	u2wNjMtYuxg5OSQETCTOHelig7DFJC7cWw9kc3EICSxjlHh17TkLTNGFq0vZIRLTGSVWnrsM
	1i0k0MQk8bdBuYuRg4NNQFti834DkLCIALPEgqnnGUHqmQUmMEr8X/QebJCwgI3Exxf/wGwW
	AVWJ/Qvfs4PYvALuEnt2HGeCWKYtse35REYQm1PAQ+LJoRVsELvcJda++8gCMlRC4DebRO/F
	BkaIQQIS3yYfYgE5QkJAVmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWle
	ul5yfu4mRkjITtjBeO+A9SHGZKBxE5mlRJPzgSGfVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOk
	ICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MqfEv3e9N3HEqz1DPr8326atPHeXCpSq7GLft
	79yw5tr+iF8L69TS1x9fNSdrRYsq37GO1B1z0/+d+r2sbuN1h0lnDCrOlq+dxL3p9jqNl+vb
	zjq8KTpx/uTqs+oS12OPsHrKxLarzPj3c97Lwv9nFkmeKhCSPNyrtb0jyfb/omt2hZ2ed7tf
	L1BiKc5INNRiLipOBAChqwKfbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQV19l3tBBgenS1tc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx9VUPY8FetoqWjXfZGhiXsXYxcnJICJhIXLi6lB3CFpO4cG89WxcjF4eQ
	wHRGiZXnLoMVCQk0MUn8bVDuYuTgYBPQlti83wAkLCLALLFg6nlGkHpmgQmMEv8XvWcBSQgL
	2Eh8fPEPzGYRUJXYv/A92AJeAXeJPTuOM0Es05bY9nwiI4jNKeAh8eTQCjaIXe4Sa999ZJnA
	yLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBEPJPewbiqweIQowAHoxIPb8XGu0FC
	rIllxZW5hxglOJiVRHiPOd4LEuJNSaysSi3Kjy8qzUktPsSYDHTVRGYp0eR8YLTmlcQbGpuY
	GVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVAPjyluNElNCvm8/HjxLevZ+
	nuMnzNzEJrxLKPSQsm3YYh9nGfLsl6DNncMrKvkfLoxeH6BmUd/A9f1ccrFTzORpLmHljys0
	OM0ON8ffFPwucjs/7vbjZrfzJ8vPPTtz00lsfvCdWONc+W2nJfbfW9wlUJu9wCvuv3mRZ3/U
	c/1iBsFjvopFjTOVWIozEg21mIuKEwFKtcyjzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves a function in f2fs_delete_entry for code readability.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 1679e8b..2d5c657 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -552,12 +552,11 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 	mark_inode_dirty(dir);
 
-	if (inode && S_ISDIR(inode->i_mode)) {
-		drop_nlink(dir);
-		update_inode_page(dir);
-	}
-
 	if (inode) {
+		if (S_ISDIR(inode->i_mode)) {
+			drop_nlink(dir);
+			update_inode_page(dir);
+		}
 		inode->i_ctime = CURRENT_TIME;
 		drop_nlink(inode);
 		if (S_ISDIR(inode->i_mode)) {
-- 
1.8.4.474.g128a96c

