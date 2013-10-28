Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3J1KWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:22:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10639 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3J1KWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:22:22 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3d6d000001c4a-57-526e3add6478
Content-transfer-encoding: 8BIT
Message-id: <1382955704.992.91.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: shifei10.ge@samsung.com
Cc: ?? <shu.tan@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 28 Oct 2013 19:21:44 +0900
In-reply-to: <27929860.72301382948116848.JavaMail.weblogic@epml07>
References: <27929860.72301382948116848.JavaMail.weblogic@epml07>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zY927VnlBBg0/FSwuLXK32LP3JIvF
	5V1z2CweHHzGbNG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr48oczYL1
	shVPXk1jbmDsFe9i5OSQEDCRmH6hmwnCFpO4cG89WxcjF4eQwDJGiaM7ZgI5HGBFG9+pg9QI
	CUxnlFiy1hnE5hUQlPgx+R4LSAmzgLzEkUvZIGFmAXWJSfMWMUOMecUoMb1rOTtEvbbE2sOz
	WUFsYQFniY/NbWC9bEDxzfsNIMYrSrzdfxesRERAWqLr4m52kDnMAs1Ac9a9YwZJsAioSkzf
	0w5WxCngJHH+ez8TRLOjxL8JR8BsfgFRicMLtzND/KUksbu9E2yQhMApdonL108xQgwSkPg2
	+RALxI+yEpsOQNVLShxccYNlAqPELCRvzkJ4cxaSNxcwMq9iFE0tSC4oTkovMtErTswtLs1L
	10vOz93ECIm6CTsY7x2wPsSYDLRxIrOUaHI+MGrzSuINjc2MLExNTI2NzC3NSBNWEudVe5QU
	JCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGx/EHmzU+bnm375RCpd+L0O//8vZeCOvTk1u76
	6xCXfHfy5lmtToeiilzZT0w6/PtF2knDYNcJp3fJGn9fMbN/jZHq70Wxv7e/XyG04qe33y+J
	Nyo1J1bZbnt0WWHjI+VTIa7WyUfU2xmDzp/cueDE1n8Ha/jX9650nPDD0fHbSfN8vTWSCjrN
	VkosxRmJhlrMRcWJAB0aYiPQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd27VnlBBnu2yVhcWuRusWfvSRaL
	y7vmsFk8OPiM2aJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aVOZoF62UrnryaxtzA2CvexcjBISFgIrHxnXoXIyeQKSZx4d56
	NhBbSGA6o8SStc4gNq+AoMSPyfdYQMqZBeQljlzKBgkzC6hLTJq3iLmLkQuo/BWjxPSu5ewQ
	9doSaw/PZgWxhQWcJT42t4H1sgHFN+83gBivKPF2/12wEhEBaYmui7vZQeYwCzQDzVn3jhkk
	wSKgKjF9TztYEaeAk8T57/1MEM2OEv8mHAGz+QVEJQ4v3M4Mcb+SxO72TvYJjEKzkJw9C+Hs
	WUjOXsDIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOKafSe9gXNVgcYhRgINRiYd3w9rc
	ICHWxLLiytxDjBIczEoivMf184KEeFMSK6tSi/Lji0pzUosPMSYDHT6RWUo0OR+YbvJK4g2N
	TcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgZHfuziY8WvihJSITUdn
	yFhOM3pZ6pdVf33nt8QERbNn/ioTaliLdshPzphWsHjvn8eJce+eBqxSFlbMDzhnc+8fi1Lb
	h/w6i0hPzdN/fna6Pvk8M377xCWKj+bME9xn9USkPjX8xskij+rIu8I7Xic+/SbhaXPzQI8f
	F8ecZ70H88/94arN+67EUpyRaKjFXFScCAD5Yj+eLQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-28 (월), 08:15 +0000, Shifei Ge:
> truncate_partial_nodes puts pages incorrectly in two cases.note that the value for argc 'depth' can only be 2 or 3(see truncate_inode_blocks --->truncate_partial_nodes ).
> first case:err happened in the first 'for' loop
> 	assume depth is 2,when err happened,pages[0] is invalid,so this page don't need to be put when func return,there is no problem.
> 	but when depth is 3 ,pages isn't put correctly when pages[0] is valid and pages[1] is invalid.in this case,depth is set to 2(ref to statemnt depth = i + 1) ,and then 'goto fail'.
> 	in label 'fail', for (i = depth - 3; i >= 0; i--) cann't meet the condition because i=-1,so pages[0] cann't be put when func return.
> second case:err happened in the second 'for' loop
> 	now,we've got pages[0] with argc 'depth' is 2 ,or we've got pages[0] and pages[1] with depth is 3.when err happend,we need 'goto fail' to put pages we've got.
> 	when depth is 2,in label 'fail',for (i = depth - 3; i >= 0; i--) cann't meet the condition because i=-1,so pages[0] cann't be put.
> 	when depth is 3,in label 'fail',for (i = depth - 3; i >= 0; i--) can only put pages[0],pages[1] also cann't be put.
> notes 'depth' has been changed before first 'goto fail'(ref to statemnt depth = i + 1),so pass this modified 'depth' to trace_f2fs_truncate_partial_nodes is also incorrectly.

Please write a description not to exceed 80 columns.
It's very hard to understand.

> 
> From 9de8efa31759ce86a032f5ad092d337b686ede06 Mon Sep 17 00:00:00 2001
> Signed-off-by: Shifei Ge <shifei10.ge@samsung.com>
> ---
>  fs/f2fs/node.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 304d5ce..9986930 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -625,6 +625,7 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
>  	int err = 0;
>  	int i;
>  	int idx = depth - 2;
> +	int dep = depth;

I think we need to avoid using a local variable only for the use of
tracepoints below.
How about this?

---
 fs/f2fs/node.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 304d5ce..8578719 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -631,11 +631,10 @@ static int truncate_partial_nodes(struct
dnode_of_data *dn,
 		return 0;
 
 	/* get indirect nodes in the path */
-	for (i = 0; i < depth - 1; i++) {
+	for (i = 0; i < idx + 1; i++) {
 		/* refernece count'll be increased */
 		pages[i] = get_node_page(sbi, nid[i]);
 		if (IS_ERR(pages[i])) {
-			depth = i + 1;
 			err = PTR_ERR(pages[i]);
 			goto fail;
 		}
@@ -643,7 +642,7 @@ static int truncate_partial_nodes(struct
dnode_of_data *dn,
 	}
 
 	/* free direct nodes linked to a partial indirect node */
-	for (i = offset[depth - 1]; i < NIDS_PER_BLOCK; i++) {
+	for (i = offset[idx + 1]; i < NIDS_PER_BLOCK; i++) {
 		child_nid = get_nid(pages[idx], i, false);
 		if (!child_nid)
 			continue;
@@ -654,7 +653,7 @@ static int truncate_partial_nodes(struct
dnode_of_data *dn,
 		set_nid(pages[idx], i, 0, false);
 	}
 
-	if (offset[depth - 1] == 0) {
+	if (offset[idx + 1] == 0) {
 		dn->node_page = pages[idx];
 		dn->nid = nid[idx];
 		truncate_node(dn);
@@ -662,9 +661,10 @@ static int truncate_partial_nodes(struct
dnode_of_data *dn,
 		f2fs_put_page(pages[idx], 1);
 	}
 	offset[idx]++;
-	offset[depth - 1] = 0;
+	offset[idx + 1] = 0;
+	idx--;
 fail:
-	for (i = depth - 3; i >= 0; i--)
+	for (i = idx; i >= 0; i--)
 		f2fs_put_page(pages[i], 1);
 
 	trace_f2fs_truncate_partial_nodes(dn->inode, nid, depth, err);
-- 
1.8.4.474.g128a96c




-- 
Jaegeuk Kim
Samsung

