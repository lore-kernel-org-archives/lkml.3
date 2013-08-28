Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3H1Sk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:40:56 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:59362 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3H1Skz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:40:55 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vineet.Gupta1@synopsys.com
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] mmc/dw_mmc: Add support for ARC
Date: Wed, 28 Aug 2013 20:40:29 +0200
Message-Id: <1377715229-2414-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt Kconfig to include ARC in supported architectures

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 drivers/mmc/host/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 8a4c066..6496d50 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -530,7 +530,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
 
 config MMC_DW
 	tristate "Synopsys DesignWare Memory Card Interface"
-	depends on ARM
+	depends on ARC || ARM
 	help
 	  This selects support for the Synopsys DesignWare Mobile Storage IP
 	  block, this provides host support for SD and MMC interfaces, in both
-- 
1.7.9.5

