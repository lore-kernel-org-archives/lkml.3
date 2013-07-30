Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3G3P1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:27:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3G3PSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:18:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 02/75] ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
Date: Tue, 30 Jul 2013 08:16:31 -0700
Message-Id: <1375197464-27962-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 016fcab8ff46fca29375d484226ec91932aa4a07 upstream.

According to the sgtl5000 reference manual, the default value of CHIP_SSS_CTRL
is 0x10.

Reported-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/sgtl5000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 92bbfec..ea47938 100644
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
1.8.1.2

