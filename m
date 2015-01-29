Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbbA2OwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:52:21 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61884 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbbA2OwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:52:19 -0500
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gong.chen@linux.intel.com, josh@joshtriplett.org,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH] drivers: ras: Include appropriate header in debugfs.c
Date: Thu, 29 Jan 2015 20:22:12 +0530
Message-Id: <1422543132-32394-1-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Includes header file linux/ras.h that has function
prototypes for functions used in debugfs.c

This eliminates the following warnings:
drivers/ras/debugfs.c:7:5: warning: no previous prototype for ‘ras_userspace_consumers’ [-Wmissing-prototypes]
drivers/ras/debugfs.c:37:12: warning: no previous prototype for ‘ras_add_daemon_trace’ [-Wmissing-prototypes]
drivers/ras/debugfs.c:53:13: warning: no previous prototype for ‘ras_debugfs_init’ [-Wmissing-prototypes]

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
---
 drivers/ras/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ras/debugfs.c b/drivers/ras/debugfs.c
index 0322acf..627f6107 100644
--- a/drivers/ras/debugfs.c
+++ b/drivers/ras/debugfs.c
@@ -1,4 +1,5 @@
 #include <linux/debugfs.h>
+#include <linux/ras.h>
 
 static struct dentry *ras_debugfs_dir;
 
-- 
1.9.1

