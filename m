Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3ETDdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:33:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3ETDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:35 -0400
X-AuditID: cbfee690-b7efc6d000006d92-06-5199998e26bc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 01/15] f2fs: remove redundant assignment
Date: Mon, 20 May 2013 12:32:15 +0900
Message-id: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDdqesVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfGqaQFrwWqOiob7
	LA2MN9i6GDk4JARMJHZ8zO9i5AQyxSQu3FsPFObiEBJYxijR0tXOBpEwkZiw5QMTRGIRo8Sp
	vecZIZw2Jonlv3+wgExiE9CW2LzfAKRBRIBZYsFUiBpmgQmMEv8XvWcBSQgLWEi8OjkLbCqL
	gKrEggkLwK7gFXCXOHWjFmKZrsTq/8/ZQXolBG6zSSyf0sQKUS8g8W3yIRaIq2UlNh1ghqiX
	lDi44gbLBEbBBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFCwm/CDsZ7B6wPMSYDjZvI
	LCWanA8M37ySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MJq+9A5in+mwq7l9vmpX8xtHq9SOV5cVzzStvetuOO+O7knzyVZTl9/arhubGHfJ5PWj
	Lyp6T8NLPz/QCNDfYm9ofNxz6v2L7WyVqcZyl/a6yH3642AwR+LJ/0Dp47o2JpNZ9069c2kD
	S0huFO+qqMkM887PPnfJJHJZ3a9loRI7VJpElXK25SmxFGckGmoxFxUnAgAOgE4TVQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDVbfY7S4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjVdMC1oLVHBUN91kaGG+wdTFyckgImEhM2PKBCcIWk7hwbz1QnItDSGAR
	o8SpvecZIZw2Jonlv3+wdDFycLAJaEts3m8A0iAiwCyxYCpEDbPABEaJ/4ves4AkhAUsJF6d
	nAW2gUVAVWLBhAVsIL28Au4Sp27UQizTlVj9/zn7BEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL
	89L1kvNzNzGCw/uZ9A7GVQ0WhxgFOBiVeHgFAmYGCrEmlhVX5h5ilOBgVhLhje4GCvGmJFZW
	pRblxxeV5qQWH2JMBlo+kVlKNDkfGHt5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cAoqLR1emiOi9px9eJNb59G+V7i+/7ivEzMqsvx1823TXINWeKnFSVW
	sIjnSJj7f6mU/VJXvC7v+nb4Q1xOVIPnaZ8oHrmYtUwrPUz+t/1V55595NuSixnzTBjXhJfe
	KGHn3KYdZLP5neudiZY6DC7W+svq+ZocjA6U1Ty9u8Ukb+cM+wC2wzlKLMUZiYZazEXFiQCB
	0GiiswIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to assign a value redundantly.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 60c8a50..2941987 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -126,7 +126,6 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 
 		entry = get_fsync_inode(head, ino_of_node(page));
 		if (entry) {
-			entry->blkaddr = blkaddr;
 			if (IS_INODE(page) && is_dent_dnode(page))
 				set_inode_flag(F2FS_I(entry->inode),
 							FI_INC_LINK);
@@ -150,10 +149,10 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 				kmem_cache_free(fsync_entry_slab, entry);
 				goto unlock_out;
 			}
-
 			list_add_tail(&entry->list, head);
-			entry->blkaddr = blkaddr;
 		}
+		entry->blkaddr = blkaddr;
+
 		if (IS_INODE(page)) {
 			err = recover_inode(entry->inode, page);
 			if (err == -ENOENT) {
-- 
1.8.1.3.566.gaa39828

