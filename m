Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaE1KsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:48:07 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:9156
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbaE1KsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:48:02 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <linux-pwm@vger.kernel.org>
CC: <thierry.reding@gmail.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] pwm: i.MX: Cleanup indentation for register definitions
Date: Wed, 28 May 2014 18:50:12 +0800
Message-ID: <1401274213-8954-2-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401274213-8954-1-git-send-email-Ying.Liu@freescale.com>
References: <1401274213-8954-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(92726001)(575784001)(79102001)(97736001)(76176999)(23676002)(4396001)(76482001)(81342001)(50466002)(86362001)(92566001)(93916002)(80022001)(64706001)(104166001)(77156001)(20776003)(99396002)(47776003)(74502001)(74662001)(6806004)(83322001)(19580395003)(89996001)(31966008)(68736004)(19580405001)(84676001)(44976005)(62966002)(26826002)(77982001)(81542001)(88136002)(46102001)(36756003)(50986999)(50226001)(87286001)(85852003)(104016001)(21056001)(83072002)(87936001)(77096999)(102836001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB339;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0225B0D5BC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains no logic change to cleanup indentation
for register definitions only.

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Lothar Waßmann <LW@KARO-electronics.de>
Cc: linux-pwm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v1->v2:
* Rebase up to the commit(1/3 in this series) which fixes
  the macro MX3_PWMCR_PRESCALER(x) definition.

 drivers/pwm/pwm-imx.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 9835e0b..fc47fab 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -21,24 +21,24 @@
 
 /* i.MX1 and i.MX21 share the same PWM function block: */
 
-#define MX1_PWMC    0x00   /* PWM Control Register */
-#define MX1_PWMS    0x04   /* PWM Sample Register */
-#define MX1_PWMP    0x08   /* PWM Period Register */
+#define MX1_PWMC			0x00   /* PWM Control Register */
+#define MX1_PWMS			0x04   /* PWM Sample Register */
+#define MX1_PWMP			0x08   /* PWM Period Register */
 
-#define MX1_PWMC_EN		(1 << 4)
+#define MX1_PWMC_EN			(1 << 4)
 
 /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
 
-#define MX3_PWMCR                 0x00    /* PWM Control Register */
-#define MX3_PWMSAR                0x0C    /* PWM Sample Register */
-#define MX3_PWMPR                 0x10    /* PWM Period Register */
-#define MX3_PWMCR_PRESCALER(x)    ((((x) - 1) & 0xFFF) << 4)
-#define MX3_PWMCR_DOZEEN                (1 << 24)
-#define MX3_PWMCR_WAITEN                (1 << 23)
+#define MX3_PWMCR			0x00    /* PWM Control Register */
+#define MX3_PWMSAR			0x0C    /* PWM Sample Register */
+#define MX3_PWMPR			0x10    /* PWM Period Register */
+#define MX3_PWMCR_PRESCALER(x)		((((x) - 1) & 0xFFF) << 4)
+#define MX3_PWMCR_DOZEEN		(1 << 24)
+#define MX3_PWMCR_WAITEN		(1 << 23)
 #define MX3_PWMCR_DBGEN			(1 << 22)
-#define MX3_PWMCR_CLKSRC_IPG_HIGH (2 << 16)
-#define MX3_PWMCR_CLKSRC_IPG      (1 << 16)
-#define MX3_PWMCR_EN              (1 << 0)
+#define MX3_PWMCR_CLKSRC_IPG_HIGH	(2 << 16)
+#define MX3_PWMCR_CLKSRC_IPG		(1 << 16)
+#define MX3_PWMCR_EN			(1 << 0)
 
 struct imx_chip {
 	struct clk	*clk_per;
-- 
1.7.9.5

