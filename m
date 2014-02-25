Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaBYHmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:42:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35360 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaBYHmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:42:23 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <530C4954.9090709@jp.fujitsu.com>
Date: Tue, 25 Feb 2014 16:42:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
CC: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] btrfs: Copyright string update
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix corporate name for copyright.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/btrfs/delayed-inode.c |    2 +-
 fs/btrfs/delayed-inode.h |    2 +-
 fs/btrfs/math.h          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 451b00c..483b918 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2011 Fujitsu.  All rights reserved.
+ * Copyright (C) 2011 FUJITSU LIMITED.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index f70119f..a07746d 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2011 Fujitsu.  All rights reserved.
+ * Copyright (C) 2011 FUJITSU LIMITED.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
index b7816ce..1ce7e18 100644
--- a/fs/btrfs/math.h
+++ b/fs/btrfs/math.h
@@ -1,6 +1,6 @@
 
 /*
- * Copyright (C) 2012 Fujitsu.  All rights reserved.
+ * Copyright (C) 2012 FUJITSU LIMITED.  All rights reserved.
  * Written by Miao Xie <miaox@cn.fujitsu.com>
  *
  * This program is free software; you can redistribute it and/or
-- 
1.7.1

