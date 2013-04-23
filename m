Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3DWXno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:43:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44099 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab3DWXnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:43:42 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <mturquette@linaro.org>
CC: <linux-pm@vger.kernel.org>, Eduardo Valentin <eduardo.valentin@ti.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] drivers: clk: fix typo in Kconfig description
Date: Tue, 23 Apr 2013 19:42:55 -0400
Message-ID: <1366760575-2890-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing misspelled wording.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/clk/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 0357ac4..1ba18f9 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -27,7 +27,7 @@ config COMMON_CLK_DEBUG
 	bool "DebugFS representation of clock tree"
 	select DEBUG_FS
 	---help---
-	  Creates a directory hierchy in debugfs for visualizing the clk
+	  Creates a directory hierarchy in debugfs for visualizing the clk
 	  tree structure.  Each directory contains read-only members
 	  that export information specific to that clk node: clk_rate,
 	  clk_flags, clk_prepare_count, clk_enable_count &
-- 
1.8.2.1.342.gfa7285d

