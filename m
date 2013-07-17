Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3GQLVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:21:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50455 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3GQLVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:21:36 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Wed, 17 Jul 2013 12:21:09 +0100
Message-Id: <1374060069-18589-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: wm8997: Make Kconfig prompt for WM8997 more consistent
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The Kconfig prompt for WM8997 says "Support for..." while the other MFD
Kconfigs (including the adjacent ones for other Arizona devices) just
list the device name which sticks out like a sore thumb when doing
configuration.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index aecd6dd..633ee43 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1070,7 +1070,7 @@ config MFD_WM5110
 	  Support for Wolfson Microelectronics WM5110 low power audio SoC
 
 config MFD_WM8997
-	bool "Support Wolfson Microelectronics WM8997"
+	bool "Wolfson Microelectronics WM8997"
 	depends on MFD_ARIZONA
 	help
 	  Support for Wolfson Microelectronics WM8997 low power audio SoC
-- 
1.8.3.2

