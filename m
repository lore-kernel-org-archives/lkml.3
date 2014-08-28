Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaH1Ly2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:54:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:47703 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaH1Ly0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:54:26 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] include/linux/platform_data/tegra_emc.h: Remove unused header
Date: Thu, 28 Aug 2014 13:54:18 +0200
Message-Id: <1409226858-3406-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header file include/linux/platform_data/tegra_emc.h does not seem
to be used anywhere. It was orphaned by a7cbe92c "ARM: tegra: remove
tegra EMC scaling driver". Remove it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/platform_data/tegra_emc.h | 34 ---------------------------------
 1 file changed, 34 deletions(-)
 delete mode 100644 include/linux/platform_data/tegra_emc.h

diff --git a/include/linux/platform_data/tegra_emc.h b/include/linux/platform_data/tegra_emc.h
deleted file mode 100644
index df67505..0000000
--- a/include/linux/platform_data/tegra_emc.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright (C) 2011 Google, Inc.
- *
- * Author:
- *	Colin Cross <ccross@android.com>
- *	Olof Johansson <olof@lixom.net>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __TEGRA_EMC_H_
-#define __TEGRA_EMC_H_
-
-#define TEGRA_EMC_NUM_REGS 46
-
-struct tegra_emc_table {
-	unsigned long rate;
-	u32 regs[TEGRA_EMC_NUM_REGS];
-};
-
-struct tegra_emc_pdata {
-	int num_tables;
-	struct tegra_emc_table *tables;
-};
-
-#endif
-- 
2.0.4

