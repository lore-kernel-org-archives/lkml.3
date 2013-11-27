Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3K0FYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:24:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:27670 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3K0FYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:24:00 -0500
X-AuditID: cbfee68f-b7f336d00000481b-34-529581ef205a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: remove unnecessary return value
Date: Wed, 27 Nov 2013 14:23:00 +0900
Message-id: <1385529780-24043-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zI933jVODDOb+Yre4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PT/KssBcfZKmZc
	P8jawHictYuRk0NCwETi78ENULaYxIV769m6GLk4hASWMUq8nnGXHabo+uNrUInpjBL7+0+x
	QjjNTBIds5cDVXFwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgLWEnMfDWXCcRm
	EVCVmDjzFtgGXgF3iabtzYwQ27Qltj2fCNYsIfCYTeLCjF2sEA0CEt8mH2IBWSYhICux6QAz
	RL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREShP07GO8esD7EmAw0
	biKzlGhyPjCI80riDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDo93SHYvS71o8vx4web1yS+nCGum9Mq6su/sv/qypf7Y/a+OdGfxruies17vJMPed
	56LY7y+mtc/0W+JpFxWUUP5DYtqkX7ZPdXJWbd7buaawaYqQzg/TItEJSpcOr90nl/z/Wivj
	oQuvV18r2z6r4KeV0S2TrZ+FH2pPmce6OH/eycWXjY3m3PqvxFKckWioxVxUnAgAhQVKx1gC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd33jVODDBp7WSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zYNP8qS8FxtooZ1w+yNjAeZ+1i5OSQEDCRuP74GhuELSZx4d56IJuLQ0hg
	OqPE/v5TrBBOM5NEx+zl7F2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvWUASwgJW
	EjNfzWUCsVkEVCUmzrzFDmLzCrhLNG1vZoTYpi2x7flExgmM3AsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBIf4M6kdjCsbLA4xCnAwKvHwTrg8JUiINbGsuDL3EKMEB7OSCG945dQg
	Id6UxMqq1KL8+KLSnNTiQ4zJQNsnMkuJJucD4y+vJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaB
	QgLpiSWp2ampBalFMFuYODilGhh97PteNezMTKwPEN4nveDELKWGqhum5gbsSq8r3lR6pOlw
	TJ1eHVO96m5Ur7LYV6UtR7lVL5Vumhb7cNdxi6DrVyZV/PDLLJikotzSortRqVWP7591dEfx
	6pLlP4o0JygFNNZJ3FnLv0lpv8Azw7cnuWecfjRb5VXMphTriQr3PDzCbrnvv6rEUpyRaKjF
	XFScCACBhbM7tQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's remove the unnecessary return value.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 95d2aba..132bb3f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -773,13 +773,12 @@ static inline void inc_valid_inode_count(struct f2fs_sb_info *sbi)
 	spin_unlock(&sbi->stat_lock);
 }
 
-static inline int dec_valid_inode_count(struct f2fs_sb_info *sbi)
+static inline void dec_valid_inode_count(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->stat_lock);
 	f2fs_bug_on(!sbi->total_valid_inode_count);
 	sbi->total_valid_inode_count--;
 	spin_unlock(&sbi->stat_lock);
-	return 0;
 }
 
 static inline unsigned int valid_inode_count(struct f2fs_sb_info *sbi)
-- 
1.8.4.474.g128a96c

