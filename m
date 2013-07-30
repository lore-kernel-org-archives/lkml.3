Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab3G3KDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:03:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52943 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3G3JcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 008/106] ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
Date: Tue, 30 Jul 2013 10:30:27 +0100
Message-Id: <1375176725-5825-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 016fcab8ff46fca29375d484226ec91932aa4a07 upstream.

According to the sgtl5000 reference manual, the default value of CHIP_SSS_CTRL
is 0x10.

Reported-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[ luis: backported to 3.5:
  - adjusted context: use u16 array instead of regmap ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/sgtl5000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 8af6a52..ab5c078 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -37,7 +37,7 @@
 static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET] =  {
 	[SGTL5000_CHIP_CLK_CTRL] = 0x0008,
 	[SGTL5000_CHIP_I2S_CTRL] = 0x0010,
-	[SGTL5000_CHIP_SSS_CTRL] = 0x0008,
+	[SGTL5000_CHIP_SSS_CTRL] = 0x0010,
 	[SGTL5000_CHIP_DAC_VOL] = 0x3c3c,
 	[SGTL5000_CHIP_PAD_STRENGTH] = 0x015f,
 	[SGTL5000_CHIP_ANA_HP_CTRL] = 0x1818,
-- 
1.8.3.2

