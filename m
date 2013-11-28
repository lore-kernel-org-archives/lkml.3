Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3K1Hnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:43:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58108 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3K1Hns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:43:48 -0500
X-AuditID: cbfee61b-b7f166d000007a34-0f-5296f42ea4ff
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 3/5] f2fs: use true and false for boolean variable
Date: Thu, 28 Nov 2013 15:43:07 +0800
Message-id: <003401ceec0d$8b62a1b0$a227e510$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7sDIAfDFkC0F0+SYe8WAGoRHD10A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQV29L9OCDC60aFpc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxpWlPcwF
	bSwVq7t+sTcwLmTuYuTgkBAwkeh8y9LFyAlkiklcuLeeDcQWEpjOKPHiUU4XIxeQ/YNRou/B
	PiaQBJuAisTyjv9gtoiAosSG9xvYQYqYBWYwShye+48VJCEs4Ctx4/tpRhCbRUBV4tyVGWBx
	XgFLiWVLG5khbEGJH5PvgW1mFtCQ6F+0gQ3ClpfYvOYtM8RFChI7zr5mhFimJ/Fzwy52iBpx
	iY1HbrFMYBSYhWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwSH9
	THoH46oGi0OMAhyMSjy8EjrTgoRYE8uKK3MPMUpwMCuJ8CoUA4V4UxIrq1KL8uOLSnNSiw8x
	SnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUwsnhta3jlENv0ZmXJTl+DUwty358T+DP9
	x15uW9cXueuF1N0v1PiZe8tNv2h12mjL+jAF9Tvil+W6d2Xwqf7IPGDldNPJa+7XLwez7uhs
	3Xfgm/6bRaUrjugbzIs4JX/Fv+p2fZ2vLp+BteTvLSGWT64ZCf0peXdnx/l7l/a80oj/azyT
	5d3qtUosxRmJhlrMRcWJAOVU6KdlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 954155b..daf8ee8 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -791,7 +791,7 @@ int truncate_xattr_node(struct inode *inode, struct page *page)
 	set_new_dnode(&dn, inode, page, npage, nid);
 
 	if (page)
-		dn.inode_page_locked = 1;
+		dn.inode_page_locked = true;
 	truncate_node(&dn);
 	return 0;
 }
-- 
1.7.9.5

