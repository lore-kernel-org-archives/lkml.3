Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3KFD0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:26:11 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33236 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3KFD0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:26:09 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Date: Tue,  5 Nov 2013 21:25:52 -0600
Message-Id: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In order to enable on arm64 and improve the build coverage, remove the
dependency on ARCH_HIGHBANK.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Robert Richter <rric@kernel.org>
Cc: linux-edac@vger.kernel.org
---
 drivers/edac/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 878f090..fc8aaaf 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -328,14 +328,14 @@ config EDAC_TILE
 
 config EDAC_HIGHBANK_MC
 	tristate "Highbank Memory Controller"
-	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
+	depends on EDAC_MM_EDAC
 	help
 	  Support for error detection and correction on the
 	  Calxeda Highbank memory controller.
 
 config EDAC_HIGHBANK_L2
 	tristate "Highbank L2 Cache"
-	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
+	depends on EDAC_MM_EDAC
 	help
 	  Support for error detection and correction on the
 	  Calxeda Highbank memory controller.
-- 
1.8.1.2

