Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab3G3KET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:04:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3G3JcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 009/106] ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK
Date: Tue, 30 Jul 2013 10:30:28 +0100
Message-Id: <1375176725-5825-10-git-send-email-luis.henriques@canonical.com>
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

commit 5c78dfe87ea04b501ee000a7f03b9432ac9d008c upstream.

SGTL5000_PLL_FRAC_DIV_MASK is used to mask bits 0-10 (11 bits in total) of
register CHIP_PLL_CTRL, so fix the mask to accomodate all this bit range.

Reported-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/sgtl5000.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 8a9f435..d3a68bb 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -347,7 +347,7 @@
 #define SGTL5000_PLL_INT_DIV_MASK		0xf800
 #define SGTL5000_PLL_INT_DIV_SHIFT		11
 #define SGTL5000_PLL_INT_DIV_WIDTH		5
-#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
+#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff
 #define SGTL5000_PLL_FRAC_DIV_SHIFT		0
 #define SGTL5000_PLL_FRAC_DIV_WIDTH		11
 
-- 
1.8.3.2

