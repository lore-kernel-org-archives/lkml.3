Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaKJPPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:15:22 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:59365 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaKJPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:15:18 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] misc: Remove unused subdirectory
Date: Mon, 10 Nov 2014 16:09:56 +0100
Message-Id: <1415632196-13516-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit 783c8f4c8445 ("soc/tegra: Add efuse driver for Tegra") added a
fuse directory in drivers/misc along with a Makefile that were never
used. They were leftovers from an earlier version of the patch series.

Reported-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/misc/fuse/Makefile | 1 -
 1 file changed, 1 deletion(-)
 delete mode 100644 drivers/misc/fuse/Makefile

diff --git a/drivers/misc/fuse/Makefile b/drivers/misc/fuse/Makefile
deleted file mode 100644
index 0679c4febc89..000000000000
--- a/drivers/misc/fuse/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
-- 
2.1.3

