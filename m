Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaHNQwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:52:46 -0400
Received: from mail-ob0-f201.google.com ([209.85.214.201]:41075 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaHNQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:52:44 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alim Akhtar <alim.akhtar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 2/2] mmc: dw_mmc: Add support for MIPS
Date: Thu, 14 Aug 2014 09:45:28 -0700
Message-Id: <1408034728-4952-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
References: <1408034728-4952-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are upcoming MIPS SoCs with dw_mmc hosts.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mmc/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 385674b..6acc2ab 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -564,7 +564,7 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
 config MMC_DW
 	tristate "Synopsys DesignWare Memory Card Interface"
 	depends on HAS_DMA
-	depends on ARC || ARM || COMPILE_TEST
+	depends on ARC || ARM || MIPS || COMPILE_TEST
 	help
 	  This selects support for the Synopsys DesignWare Mobile Storage IP
 	  block, this provides host support for SD and MMC interfaces, in both
-- 
2.1.0.rc2.206.gedb03e5

