Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaG3Gwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:52:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21829 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaG3Gwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:52:44 -0400
X-AuditID: cbfee691-b7f306d000003d81-49-53d8963b9fbe
Date: Wed, 30 Jul 2014 06:52:43 +0000 (GMT)
From: Dongho Sim <dh.sim@samsung.com>
Subject: [PATCH v2] f2fs: remove redundant lines in allocate_data_block
To: "jaegeuk@kernel.org" <jaegeuk@kernel.org>
Cc: "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-to: dh.sim@samsung.com
MIME-version: 1.0
X-MTR: 20140730064038374@dh.sim
Msgkey: 20140730064038374@dh.sim
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140730064038374@dh.sim
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <31343962.57441406703161454.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zvq71tBvBBptOc1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M+7O3sxVskajYfPsWSwPjA/EuRk4OIQFFiV/PdzGD2BICJhLH
	+u6yQthiEhfurWfrYuQCqlnGKLHp8TMWmKKt75pZIRJzGCVu75gP1s0ioCox49BORhCbTUBN
	4smxd2ANwgLuEmtergKzRQR0JT686WUGaWYWWMAosXP6R1aIM2Qk3m09D2bzCghKnJz5BGqb
	vMTxmUuZIOIKEo/OXIQ6T1ziwtxL7BA2r8SM9qdQ9XIS076ugXpHWuL8rA2MMO8s/v4YKs4v
	cez2DqCZHGC9T+4Hw4zZvfkLG4QtIDH1zEGoVhWJfW9aocbzSaxZ+JYFZsyuU8uZYXrvb5kL
	diYzMESndD9kBxnPLKApsX6XPrqveAUcJRb1H2efwKg8C0lqFpLuWQjdyEoWMLKsYhRNLUgu
	KE5KLzLVK07MLS7NS9dLzs/dxAhJCxN3MN4/YH2IMRkYIxOZpUST84FpJa8k3tDYzMjC1MTU
	2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDnOy5U8Vd6ygnvpjaly
	jy6sOu7wY479laWePFMrV17vdWL25Vq+pIfz5Jk7zx5KpAgKtk67+Hk37/UzbNprZ86bNr/0
	geHOB/wmBsuCpHX2Tco9md3qbFYj0j77e+WDs5erNzka6MvEvZt77eDbKM6nxzcsC7GU5I84
	XfXrhFXZwcgAp2seD5SUWIozEg21mIuKEwHmB5xqIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e92v671tBvBBkeWs1lc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz1jy1grQwMDI1OgqoSM
	jPuzt7MVbJGo2Hz7FksD4wPxLkZODiEBRYlfz3cxg9gSAiYSW981s0LYYhIX7q1n62LkAqqZ
	wyhxe8d8sCIWAVWJGYd2MoLYbAJqEk+OvWMBsYUF3CXWvFwFZosI6Ep8eNPLDNLMLLCAUWLn
	9I+sENtkJN5tPQ9m8woISpyc+YQFYpu8xPGZS5kg4goSj85chLpCXOLC3EvsEDavxIz2p1D1
	chLTvq6Bulpa4vysDYwwVy/+/hgqzi9x7PYOoJkcYL1P7gfDjNm9+QsbhC0gMfXMQahWFYl9
	b1qhxvNJrFn4lgVmzK5Ty5lheu9vmQt2JjMw4KZ0P2QHGc8soCmxfpc+uq94BRwlFvUfZ5/A
	KDcLSWoWku5ZCN3IShYwsqxiFE0tSC4oTkqvMNYrTswtLs1L10vOz93ECE5QzxbvYPx/3voQ
	owAHoxIP74z/14OFWBPLiitzDzFKcDArifCeKb8RLMSbklhZlVqUH19UmpNafIgxGRh/E5ml
	RJPzgckzryTe0NjYxMzE1NzAwsDSnDRhJXHe+FtJQUIC6YklqdmpqQWpRTBbmDg4pRoYZczb
	raYcrl8qZ6CirPr6z7MD+160OzZ8Zz8j/krjpsK08vh4Q69nzDJf1zIsZovdm7XWK2a6gySr
	E/eFY/7F1fPavk4V21Rwwjuyfcpre77H3i1GCu8TdhmeOlxYdali3vWHN/TnqoTELOO7+3+j
	mHH4lXl1adMXceXeiTe38Xn0dFLiw9SfSizFGYmGWsxFxYkAZwy0cJQDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6U6qral030889

There are redundant lines in allocate_data_block.

In this function, we call refresh_sit_entry with old seg and old curseg.
After that, we call locate_dirty_segment with old curseg.

But, the new address is always allocated from old curseg and
we call locate_dirty_segment with old curseg in refresh_sit_entry.
So, we do not need to call locate_dirty_segment with old curseg again.

We've discussed like below:

Jaegeuk said:
 "When considering SSR, we need to take care of the following scenario.
  - old segno : X
  - new address : Z
  - old curseg : Y
  This means, a new block is supposed to be written to Z from X.
  And Z is newly allocated in the same path from Y.

  In that case, we should trigger locate_dirty_segment for Y, since
  it was a current_segment and can be dirty owing to SSR.
  But that was not included in the dirty list."

Changman said:
 "We already choosed old curseg(Y) and then we allocate new address(Z) from old
  curseg(Y). After that we call refresh_sit_entry(old address, new address).
  In the funcation, we call locate_dirty_segment with old seg and old curseg.
  So calling locate_dirty_segment after refresh_sit_entry again is redundant."

Jaegeuk said:
 "Right. The new address is always allocated from old_curseg."

Signed-off-by: Dongho Sim <dh.sim@samsung.com>
---
 fs/f2fs/segment.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8a6e57d..7af4a8d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -973,14 +973,12 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 {
 	struct sit_info *sit_i = SIT_I(sbi);
 	struct curseg_info *curseg;
-	unsigned int old_cursegno;
 
 	curseg = CURSEG_I(sbi, type);
 
 	mutex_lock(&curseg->curseg_mutex);
 
 	*new_blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
-	old_cursegno = curseg->segno;
 
 	/*
 	 * __add_sum_entry should be resided under the curseg_mutex
@@ -1001,7 +999,6 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
 	 * since SSR needs latest valid block information.
 	 */
 	refresh_sit_entry(sbi, old_blkaddr, *new_blkaddr);
-	locate_dirty_segment(sbi, old_cursegno);
 
 	mutex_unlock(&sit_i->sentry_lock);
 
-- 
1.9.1

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
