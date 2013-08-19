Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3HSPHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:07:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47098 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3HSPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:07:34 -0400
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@linaro.org>
Date: Mon, 19 Aug 2013 16:07:26 +0100
Message-Id: <1376924846-17063-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] pinctrl: palmas: Fix device name in Kconfig text
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

The device family is called Palmas so there should be a 's' on the end of
the name.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/pinctrl/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 8542cd4..bdb1a87 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -262,7 +262,7 @@ config PINCTRL_EXYNOS5440
 	select PINCONF
 
 config PINCTRL_PALMAS
-	bool "Pinctrl driver for the PALMA Series MFD devices"
+	bool "Pinctrl driver for the PALMAS Series MFD devices"
 	depends on OF && MFD_PALMAS
 	select GENERIC_PINCONF
 	help
-- 
1.8.4.rc3

