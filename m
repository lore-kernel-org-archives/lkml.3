Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3JUC4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:56:18 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:64433 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3JUC4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:56:17 -0400
MIME-Version: 1.0
Date: Mon, 21 Oct 2013 10:56:15 +0800
Message-ID: <CAPgLHd-Pe_oBza-esdghKzFq5T2-Pj26YSBuEggAC9qR7vAdeg@mail.gmail.com>
Subject: [PATCH -next] xfs: remove duplicated include from xfs_bmap.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: bpm@sgi.com, elder@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/xfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index e6b4202..92b97f7 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -34,7 +34,6 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
-#include "xfs_mount.h"
 #include "xfs_itable.h"
 #include "xfs_inode_item.h"
 #include "xfs_extfree_item.h"

