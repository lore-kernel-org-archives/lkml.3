Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaHZFvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:51:05 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:3459
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757173AbaHZFuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:50:22 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <dongsheng.wang@freescale.com>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 3/5] Clocksource: Flextimer: Remove the useless code.
Date: Tue, 26 Aug 2014 13:45:49 +0800
Message-ID: <1409031951-39021-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
In-Reply-To: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409031951-39021-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(69596002)(19580405001)(77156001)(26826002)(92726001)(229853001)(104166001)(50466002)(106466001)(93916002)(107046002)(84676001)(6806004)(81542001)(44976005)(64706001)(31966008)(92566001)(48376002)(76176999)(575784001)(95666004)(47776003)(74502001)(4396001)(83072002)(104016003)(102836001)(79102001)(85852003)(20776003)(76482001)(88136002)(87936001)(83322001)(90102001)(46102001)(80022001)(77982001)(105606002)(62966002)(74662001)(81342001)(36756003)(99396002)(50986999)(87286001)(97736001)(50226001)(81156004)(89996001)(85306004)(19580395003)(86362001)(68736004)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB178;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock envnt counter will be enabled in proper time and proper
place when needed.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
---
 drivers/clocksource/fsl_ftm_timer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clocksource/fsl_ftm_timer.c b/drivers/clocksource/fsl_ftm_timer.c
index c4d23d0f..f70fcf2 100644
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
1.8.5

