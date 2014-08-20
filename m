Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaHTG4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:56:10 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:60602 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHTG4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:56:07 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 3/4] pwm: imx: indentation cleanup
Date: Wed, 20 Aug 2014 08:55:55 +0200
Message-Id: <1408517756-9412-4-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408517756-9412-3-git-send-email-LW@KARO-electronics.de>
References: <1408517756-9412-1-git-send-email-LW@KARO-electronics.de>
 <1408517756-9412-2-git-send-email-LW@KARO-electronics.de>
 <1408517756-9412-3-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/pwm/pwm-imx.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 5449d91..f836635 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -25,20 +25,21 @@
 #define MX1_PWMS    0x04   /* PWM Sample Register */
 #define MX1_PWMP    0x08   /* PWM Period Register */
 
-#define MX1_PWMC_EN		(1 << 4)
+#define MX1_PWMC_EN			(1 << 4)
 
 /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
 
-#define MX3_PWMCR                 0x00    /* PWM Control Register */
-#define MX3_PWMSAR                0x0C    /* PWM Sample Register */
-#define MX3_PWMPR                 0x10    /* PWM Period Register */
-#define MX3_PWMCR_PRESCALER(x)    (((x - 1) & 0xFFF) << 4)
-#define MX3_PWMCR_DOZEEN                (1 << 24)
-#define MX3_PWMCR_WAITEN                (1 << 23)
+#define MX3_PWMCR			0x00	  /* PWM Control Register */
+#define MX3_PWMSAR			0x0C	  /* PWM Sample Register */
+#define MX3_PWMPR			0x10	  /* PWM Period Register */
+#define MX3_PWMCR_PRESCALER(x)		((((x) - 1) & 0xFFF) << 4)
+#define MX3_PWMCR_DOZEEN		(1 << 24)
+#define MX3_PWMCR_WAITEN		(1 << 23)
 #define MX3_PWMCR_DBGEN			(1 << 22)
-#define MX3_PWMCR_CLKSRC_IPG_HIGH (2 << 16)
-#define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
-#define MX3_PWMCR_EN              (1 << 0)
+#define MX3_PWMCR_POUTC			(1 << 18)
+#define MX3_PWMCR_CLKSRC_IPG_HIGH	(2 << 16)
+#define MX3_PWMCR_CLKSRC_IPG		(1 << 16)
+#define MX3_PWMCR_EN			(1 << 0)
 
 struct imx_chip {
 	struct clk	*clk_per;
-- 
1.7.10.4

