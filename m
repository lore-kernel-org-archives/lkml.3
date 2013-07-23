Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787Ab3GWWqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:46:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934630Ab3GWW13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oskar Schirmer <oskar@scara.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 048/103] ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK
Date: Tue, 23 Jul 2013 15:25:59 -0700
Message-Id: <20130723220423.935353938@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 5c78dfe87ea04b501ee000a7f03b9432ac9d008c upstream.

SGTL5000_PLL_FRAC_DIV_MASK is used to mask bits 0-10 (11 bits in total) of
register CHIP_PLL_CTRL, so fix the mask to accomodate all this bit range.

Reported-by: Oskar Schirmer <oskar@scara.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/sgtl5000.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


