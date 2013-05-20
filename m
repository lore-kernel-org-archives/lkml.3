Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3ETDfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:35:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3ETDdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:36 -0400
X-AuditID: cbfee690-b7efc6d000006d92-07-5199998e6789
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 02/15] f2fs: remove unnecessary flag set
Date: Mon, 20 May 2013 12:32:16 +0900
Message-id: <1369020743-18520-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDWbu5LG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+Pcu+lsBf3sFZPe
	PWFrYHzE2sXIySEhYCLR9+I0C4QtJnHh3nq2LkYuDiGBZYwSqxv+ATkcYEVrlyaB1AgJLGKU
	ePY9C6KmjUli+e8fLCA1bALaEpv3G4DUiAgwSyyYep4RpIZZYAKjxP9F78EWCAtYSNz8cIIZ
	pJ5FQFVi/WRzkDCvgLvE/cfL2CFu0JVY/f85mM0p4CGx9e4pRpByIaCa1+dKQEZKCHxnkzhz
	up8RpIZFQEDi2+RDLBBnykpsOsAMMUZS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLRK07MLS7N
	S9dLzs/dxAgJ1gk7GO8dsD7EmAw0biKzlGhyPjDY80riDY3NjCxMTUyNjcwtzUgTVhLnVW+x
	DhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6PYqsNT14/SDHlxTQswPP9o3d8HXx7Gs819L
	5Tv/v/E51Toh547tX+EXevIMaoUbvM6mlG2c++RdvfSMx92ie+bv/MSyLcQ/Z6mettJy2d8K
	7/NEWGYantbUPNdxYXbad/ZTdh1i3qGMggevbv360CpzifJ0Oe1j954yhbXaPpD9MFXx3ybZ
	+UosxRmJhlrMRcWJAG5j0X9sAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDR50cFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx7t10toJ+9opJ756wNTA+Yu1i5OCQEDCRWLs0qYuRE8gUk7hwbz0biC0k
	sIhR4tn3rC5GLiC7jUli+e8fLCD1bALaEpv3G4DUiAgwSyyYep4RpIZZYAKjxP9F71lAEsIC
	FhI3P5xgBqlnEVCVWD/ZHCTMK+Aucf/xMnaIXboSq/8/B7M5BTwktt49xQhSLgRU8/pcyQRG
	3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPhmfQOxlUNFocYBTgYlXh4BQJmBgqx
	JpYVV+YeYpTgYFYS4Y3uBgrxpiRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjBO80riDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsd/jq/DHFLV17M9CvZ7/fJkf
	/uuW6Tmjw5v3O5x/u2uK3de3NW+ZpR4FPeXZv+Lp7EXyD7+c51aLPfHvk+v6prDQzu3hHF+L
	t4Qdf2E5ee2m718C0j+2sK5d4qHzbpKGcbLMs1lFK6fe9G2czC29WCFnwQQBZfv+XqkUqXwh
	JSuGXRtsgabbKrEUZyQaajEXFScCADC870PJAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an inode is recovered with its dentry, it will not invoke __f2fs_add_link,
since the recovery routine checks its dentry before calling __f2fs_add_link.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 2941987..993b601 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -125,11 +125,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 			goto next;
 
 		entry = get_fsync_inode(head, ino_of_node(page));
-		if (entry) {
-			if (IS_INODE(page) && is_dent_dnode(page))
-				set_inode_flag(F2FS_I(entry->inode),
-							FI_INC_LINK);
-		} else {
+		if (!entry) {
 			if (IS_INODE(page) && is_dent_dnode(page)) {
 				err = recover_inode_page(sbi, page);
 				if (err)
-- 
1.8.1.3.566.gaa39828

