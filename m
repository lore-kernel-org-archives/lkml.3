Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaHICwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:52:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59276 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaHICwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:52:43 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1a-53e58cf7c597
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 5/5] f2fs: update f2fs documentation for inline dir
 support
Date: Sat, 09 Aug 2014 10:51:55 +0800
Message-id: <00c301cfb37c$fc1efe80$f45cfb80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+zfNFIIk1CVXAfSpyl3WYb/35KQA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAd0fPU+DDXZ9ZrK4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxtxPp5gL
	znNVvPh6mr2B8RV7FyMnh4SAicTy06+YIWwxiQv31rN1MXJxCAksYpSYfXADE4Tzg1Gi9fJ0
	JpAqNgEVieUd/8FsEQEviUn7T7CA2MwCHhKNHd9ZQWxhgXCJp00rwGwWAVWJa6+nMXYxcnDw
	ClhKXP/mDRLmFRCU+DH5HlSrlsTmbU2sELa8xOY1b6EOUpDYcfY1WKuIgJ7EhpvFECXiEhuP
	3GKZwCgwC8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggP6mdQO
	xpUNFocYBTgYlXh4V9g8DRZiTSwrrsw9xCjBwawkwruwEijEm5JYWZValB9fVJqTWnyIUZqD
	RUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBMbn9DB9jokDL/00GWpd4Fp9WOXlk4sH/j2/W
	z2HUry1beY/r+J8K2f3H3jk+mFWuu2DBnH8+M5ZdPhTM8qgl2tE9U/m4gmHDs47vk+bHcnrI
	z7r8suqcYE63bWL8VnUXodp4F71+pbuLKh9deXrEJs9rejVn15EFeoFPPx3KSZ91+Nzyk+wh
	WUosxRmJhlrMRcWJAJv2Gn1kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds descriptions for the inline dir support in f2fs document.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index a2046a7..08c9493 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -120,8 +120,9 @@ active_logs=%u         Support configuring the number of active logs. In the
 disable_ext_identify   Disable the extension list configured by mkfs, so f2fs
                        does not aware of cold files such as media files.
 inline_xattr           Enable the inline xattrs feature.
-inline_data            Enable the inline data feature: New created small(<~3.4k)
-                       files can be written into inode block.
+inline_data            Enable the inline data feature: data(<~3.4k) in new
+                       created small file and limited directory entries can be
+                       written into to inode block.
 flush_merge	       Merge concurrent cache_flush commands as much as possible
                        to eliminate redundant command issues. If the underlying
 		       device handles the cache_flush command relatively slowly,
-- 
2.0.1.474.g72c7794


