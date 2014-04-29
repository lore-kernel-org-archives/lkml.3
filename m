Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933798AbaD2L1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:27:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39533 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933710AbaD2L1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:27:16 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 11/15] ASoC: WM0010 needs SPI 
Date: Tue, 29 Apr 2014 19:18:32 +0800
Message-Id: <1398770316-19715-12-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The missing dependency can lead to build errors, so
make it explicit in Kconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
---
 sound/soc/samsung/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 9fd6f62..99cc196 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -201,7 +201,7 @@ config SND_SOC_SPEYSIDE
 	select SND_SAMSUNG_I2S
 	select SND_SOC_WM8996
 	select SND_SOC_WM9081
-	select SND_SOC_WM0010
+	select SND_SOC_WM0010 if SPI
 	select SND_SOC_WM1250_EV1
 
 config SND_SOC_TOBERMORY
@@ -217,7 +217,7 @@ config SND_SOC_BELLS
 	select SND_SOC_WM5102
 	select SND_SOC_WM5110
 	select SND_SOC_WM9081
-	select SND_SOC_WM0010
+	select SND_SOC_WM0010 if SPI
 	select SND_SOC_WM1250_EV1
 
 config SND_SOC_LOWLAND
-- 
1.7.9.5

