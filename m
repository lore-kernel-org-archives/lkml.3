Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859Ab3GaNdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:33:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47097 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759860Ab3GaN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Oskar Schirmer" <oskar@scara.com>,
        "Fabio Estevam" <fabio.estevam@freescale.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.448607450@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [34/84] ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 016fcab8ff46fca29375d484226ec91932aa4a07 upstream.

According to the sgtl5000 reference manual, the default value of CHIP_SSS_CTRL
is 0x10.

Reported-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
[bwh: Backported to 3.2: format of register defaults array is different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/sgtl5000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -38,7 +38,7 @@
 static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET] =  {
 	[SGTL5000_CHIP_CLK_CTRL] = 0x0008,
 	[SGTL5000_CHIP_I2S_CTRL] = 0x0010,
-	[SGTL5000_CHIP_SSS_CTRL] = 0x0008,
+	[SGTL5000_CHIP_SSS_CTRL] = 0x0010,
 	[SGTL5000_CHIP_DAC_VOL] = 0x3c3c,
 	[SGTL5000_CHIP_PAD_STRENGTH] = 0x015f,
 	[SGTL5000_CHIP_ANA_HP_CTRL] = 0x1818,

