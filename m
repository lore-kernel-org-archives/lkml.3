Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3FNH14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:27:56 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38108 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3FNH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:27:55 -0400
From: junwei.zhang@6wind.com
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, JunweiZhang <junwei.zhang@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH 1/2] kernel: remove unnecessary head file
Date: Fri, 14 Jun 2013 15:29:53 +0800
Message-Id: <1371194994-6130-1-git-send-email-junwei.zhang@6wind.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JunweiZhang <junwei.zhang@6wind.com>

ip_vs.h is not necessary for sysctl_binary.c.

prepare for the next patch to avoid compile issue.

Signed-off-by: JunweiZhang <junwei.zhang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 kernel/sysctl_binary.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index aea4a9e..b609213 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -3,7 +3,6 @@
 #include "../fs/xfs/xfs_sysctl.h"
 #include <linux/sunrpc/debug.h>
 #include <linux/string.h>
-#include <net/ip_vs.h>
 #include <linux/syscalls.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
-- 
1.8.1.2

