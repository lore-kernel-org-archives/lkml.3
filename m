Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbaJ1ROS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:14:18 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61100 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaJ1ROP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:14:15 -0400
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: treding@nvidia.com, swarren@nvidia.com, pdeschrijver@nvidia.com
Cc: linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] misc: Remove unused fuse/Makefile
Date: Tue, 28 Oct 2014 14:12:34 -0300
Message-Id: <1414516354-29932-1-git-send-email-ezequiel@vanguardiasur.com.ar>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:

commit 783c8f4c84451bc444e314a71b447239c6ef6fd9
Author: Peter De Schrijver <pdeschrijver@nvidia.com>
Date:   Thu Jun 12 18:36:37 2014 +0300

    soc/tegra: Add efuse driver for Tegra

introduced a fuse driver in drivers/soc. While at it, an unused file
drivers/misc/fuse/Makefile sneaked in, apparently as a left over from
a previous series. Remove it.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/misc/fuse/Makefile | 1 -
 1 file changed, 1 deletion(-)
 delete mode 100644 drivers/misc/fuse/Makefile

diff --git a/drivers/misc/fuse/Makefile b/drivers/misc/fuse/Makefile
deleted file mode 100644
index 0679c4f..0000000
--- a/drivers/misc/fuse/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
-- 
2.1.0

