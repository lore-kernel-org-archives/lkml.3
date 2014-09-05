Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaIEGJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:09:33 -0400
Received: from mail-by2on0136.outbound.protection.outlook.com ([207.46.100.136]:3016
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbaIEGJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:09:32 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/4] Clocksource: Flextimer: Remove the useless code.
Date: Fri, 5 Sep 2014 13:02:18 +0800
Message-ID: <1409893340-30027-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409893340-30027-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019016)(6009001)(189002)(199003)(105606002)(95666004)(81342001)(26826002)(50466002)(85306004)(104166001)(104016003)(86362001)(44976005)(6806004)(68736004)(19580395003)(19580405001)(83322001)(90102001)(62966002)(80022001)(48376002)(47776003)(106466001)(79102001)(81542001)(20776003)(64706001)(102836001)(229853001)(107046002)(76176999)(77982001)(50986999)(87286001)(74502001)(31966008)(89996001)(92566001)(77156001)(83072002)(99396002)(74662001)(87936001)(85852003)(76482001)(46102001)(21056001)(97736001)(93916002)(92726001)(50226001)(88136002)(4396001)(84676001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0624;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock envnt counter will be enabled in proper time and proper
place when needed.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index 9c6e935..ccb8c32 100644
--- a/drivers/clocksource/fsl_ftm_timer.c
+++ b/drivers/clocksource/fsl_ftm_timer.c
@@ -221,8 +221,6 @@ static int __init ftm_clockevent_init(unsigned long freq, int irq)
 					freq / (1 << priv->ps),
 					1, 0xffff);
 
-	ftm_counter_enable(priv->clkevt_base);
-
 	return 0;
 }
 
-- 
2.1.0.27.g96db324

