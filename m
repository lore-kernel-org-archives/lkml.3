Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaIXKVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:21:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53545 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaIXKVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:21:17 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-15-54229b1b91f1
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 6/6 v2] f2fs: update f2fs documentation for inline
 dir support
Date: Wed, 24 Sep 2014 18:20:23 +0800
Message-id: <004101cfd7e1$46710860$d3531920$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X36SJ8BdwJte2QpG3cpQUd/BbzQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAV3p2UohBqcWmltc29fIZPFk/Sxm
	i0uL3C0u75rD5sDisWlVJ5vH7gWfmTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr496ff6wF
	HzgrDj39x9zAuJC9i5GDQ0LAROLkLs8uRk4gU0ziwr31bF2MXBxCAosYJeY93MkKkhAS+MEo
	sfC7NojNJqAisbzjPxOILSLgJTFp/wkWEJtZwEOiseM7WL2wQJRE+79mdhCbRUBVomfqKjYQ
	m1fAUuLizy4oW1Dix+R7UL1aEut3HmeCsOUlNq95ywxxkILEjrOvGSF26UlMP9/NDlEjLrHx
	yC2WCYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzign0nv
	YFzVYHGIUYCDUYmHd4K4UogQa2JZcWXuIUYJDmYlEd5XPUAh3pTEyqrUovz4otKc1OJDjNIc
	LErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjCuVFPctM/k/rUpyUrrXr7erN955sKG8c31v
	tfVLkbz9F66rPvNnT1kS7jHH50ukynKV6d1yVRe1l//lvLfv7bNojddvVwiy/BA4Gci3aN+M
	1u+rWT4xfWJgnSdZcODGlLbZInlOlhyPm6ZoGZysP/jh5PN9RdOFXquFvrzwco2pttRv+T+m
	IbxKLMUZiYZazEXFiQAkdqnoZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds descriptions for the inline dir support in f2fs document.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 Documentation/filesystems/f2fs.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
index 2cca5a2..4bb9f27 100644
--- a/Documentation/filesystems/f2fs.txt
+++ b/Documentation/filesystems/f2fs.txt
@@ -122,6 +122,10 @@ disable_ext_identify   Disable the extension list configured by mkfs, so f2fs
 inline_xattr           Enable the inline xattrs feature.
 inline_data            Enable the inline data feature: New created small(<~3.4k)
                        files can be written into inode block.
+inline_dentry          Enable the inline dir feature: data in new created
+                       directory entries can be written into inode block. The
+                       space of inode block which is used to store inline
+                       dentries is limited to ~3.4k.
 flush_merge	       Merge concurrent cache_flush commands as much as possible
                        to eliminate redundant command issues. If the underlying
 		       device handles the cache_flush command relatively slowly,
-- 
2.0.1.474.g72c7794


