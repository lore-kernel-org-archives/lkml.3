Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaFXR2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:28:48 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47427 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbaFXR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:28:20 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 5/6] include/linux/platform_data/tegra_emc.h: Remove unused header
Date: Tue, 24 Jun 2014 19:27:34 +0200
Message-Id: <1403630855-29186-6-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403630855-29186-1-git-send-email-linux@rasmusvillemoes.dk>
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
1.9.2

